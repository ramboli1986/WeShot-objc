//
//  BLFlowViewController.m
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLFlowViewController.h"
#import "BLWaterFlowLayout.h"
#import "BLFlowCollectionViewCell.h"
#import "BLShotDetailTableViewController.h"
#import "BLShotsTool.h"
#import "BLShot.h"
#import "BLShotsParams.h"
#import "BLDribbbleAPI.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDImageCache.h>
#import <MJRefresh.h>

@interface BLFlowViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, BLWaterFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray* shots;

@end

@implementation BLFlowViewController {
    NSInteger page;
    NSInteger per_page;
}

- (NSMutableArray*)shots {
    if (_shots == nil) {
        _shots = [NSMutableArray array];
    }
    return _shots;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupRefresh];
}

- (void)setupRefresh {
    // The drop-down refresh
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewshots)];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header beginRefreshing];
    
    self.collectionView.mj_header = header;
    
}

- (void)loadNewshots{
    
    page = 1;
    per_page = 18;
    BLShotsParams* params = [[BLShotsParams alloc]init];
    if (self.type == 0) {
        params.access_token = OAuth2_CLIENT_ACCESS_TOKEN;
    } else {
        params.access_token = [BLAcountTool access_Token];
    }
    
    
    NSString *pageStr = [NSString stringWithFormat:@"page=%zd&per_page=%zd",page, per_page];
    [BLShotsTool shotWithParams:params pageStr:pageStr Success:^(NSArray *shotsArray) {
        [self.shots removeAllObjects];
        [self.shots addObjectsFromArray:shotsArray];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
        [self.collectionView.mj_header endRefreshing];
    }];

}
- (void)loadMoreShots {
    BLShotsParams* params = [[BLShotsParams alloc]init];
    if (self.type == 0) {
        params.access_token = OAuth2_CLIENT_ACCESS_TOKEN;
    } else {
        params.access_token = [BLAcountTool access_Token];
    }
    NSString *pageStr = [NSString stringWithFormat:@"page=%zd&per_page=%zd",++page,per_page];
    [BLShotsTool shotWithParams:params pageStr:pageStr Success:^(NSArray *shotsArray){
        [self.shots addObjectsFromArray:shotsArray];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
    }];
}

- (void)setupCollectionView {
    BLWaterFlowLayout* flowLayout = [[BLWaterFlowLayout alloc]init];
    flowLayout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = BLGlobalBg;
    CGFloat bottom = self.tabBarController.tabBar.height;
    self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, bottom, 0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.collectionView registerNib:[UINib nibWithNibName:@"BLFlowCollectionViewCell" bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"waterflowCell"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.shots.count;
}


- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select item :%@", indexPath);
    BLShotDetailTableViewController* vc = [[BLShotDetailTableViewController alloc]init];
    vc.shot = self.shots[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLFlowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"waterflowCell" forIndexPath:indexPath];
    cell.layer.borderWidth=0.3f;
    cell.layer.borderColor=[[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor;
    
    BLShot* shot = self.shots[indexPath.row];
    NSString* shotImageURLStr = shot.images.teaser;
    NSString* avatorImageUrlStr = shot.user.avatar_url;
    
    [cell.shotImage sd_setImageWithURL:[NSURL URLWithString:shotImageURLStr]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [cell.userAvatorImage sd_setImageWithURL:[NSURL URLWithString:avatorImageUrlStr]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    CGFloat shotImageHeight = cell.width*shot.height/shot.width;
    cell.shotImage.height = shotImageHeight;
    cell.shotTitle.text = shot.title;
    cell.shotDetail.text = shot.detailContent;
    cell.username.text = shot.user.username;
    cell.likeCount.text = [NSString stringWithFormat:@"%zd",shot.likes_count];
    
    if (indexPath.row == self.shots.count - 1) {
        [self loadMoreShots];
    }
    return cell;
}

#pragma mark - <MSPWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(BLWaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    BLShot* shot = self.shots[index];
    return shot.homeCellHeight;
}

- (CGFloat)columnMarginInWaterflowLayout:(BLWaterFlowLayout *)waterflowLayout {
    return 10;
}

- (CGFloat)rowMarginInWaterflowLayout:(BLWaterFlowLayout *)waterflowLayout
{
    return 12;
}

- (CGFloat)columnCountInWaterflowLayout:(BLWaterFlowLayout *)waterflowLayout
{
    return 2;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(BLWaterFlowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
