//
//  BLGridViewController.m
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLGridViewController.h"
#import "BLWaterFlowLayout.h"
#import "BLGridCollectionViewCell.h"
#import "BLShotDetailTableViewController.h"
#import "BLShotsTool.h"
#import "BLShot.h"
#import "BLShotsParams.h"
#import "BLDribbbleAPI.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDImageCache.h>
#import <MJRefresh.h>


@interface BLGridViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, BLWaterFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray* shots;

@end

@implementation BLGridViewController {
    CGFloat gap;
    NSInteger page;
}

- (NSMutableArray*)shots {
    if (_shots == nil) {
        _shots = [NSMutableArray array];
    }
    return _shots;
}

- (void)viewDidLoad {
    gap = 4.0;
    
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupRefresh];
}

- (void)setupRefresh {
    // The drop-down refresh
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewshot)];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header beginRefreshing];
    
    self.collectionView.mj_header = header;
    
}

- (void)loadNewshot{
    
    page = 1;
    BLShotsParams* params = [[BLShotsParams alloc]init];
    params.access_token = OAuth2_CLIENT_ACCESS_TOKEN;
    
    //@{@"page":@(page), @"per_page":@100};
    
    if (self.type == 0) {
        params.sort = @"recent";
    } else if (self.type == 1) {
        params.list = @"teams";
    } else if (self.type == 2) {
        params.list = @"debuts";
    } else if (self.type == 3) {
        params.list = @"playoffs";
    }
    NSString *pageStr = [NSString stringWithFormat:@"page=%zd&per_page=99",page];
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


- (void)loadMoreShot {
    BLShotsParams* params = [[BLShotsParams alloc]init];
    params.access_token = OAuth2_CLIENT_ACCESS_TOKEN;
    if (self.type == 1) {
        params.sort = @"recent";
    } else if (self.type == 2) {
        params.list = @"teams";
    } else if (self.type == 3) {
        params.list = @"debuts";
    }
    NSString *pageStr = [NSString stringWithFormat:@"page=%zd&per_page=99",++page];
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
    self.collectionView.backgroundColor = [UIColor whiteColor];
    CGFloat bottom = self.tabBarController.tabBar.height;
    self.collectionView.contentInset = UIEdgeInsetsMake(64 + 44, 0, bottom, 0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.collectionView registerNib:[UINib nibWithNibName:@"BLGridCollectionViewCell" bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"gridflowCell"];
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
    BLGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gridflowCell" forIndexPath:indexPath];
    BLShot* shot = self.shots[indexPath.row];
    NSString* shotImageURLString = shot.images.teaser;
    [cell.shotImage sd_setImageWithURL:[NSURL URLWithString:shotImageURLString]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.gifLabel.hidden = shot.animated?NO:YES;
    if (indexPath.row == self.shots.count-1) {
        [self loadMoreShot];
    }
    return cell;
}

#pragma mark - <MSPWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(BLWaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    
    return (ScreenSize.width)/4;
    
    
}

- (CGFloat)columnMarginInWaterflowLayout:(BLWaterFlowLayout *)waterflowLayout {
    return gap;
}

- (CGFloat)rowMarginInWaterflowLayout:(BLWaterFlowLayout *)waterflowLayout
{
    return gap;
}

- (CGFloat)columnCountInWaterflowLayout:(BLWaterFlowLayout *)waterflowLayout
{
    return 3;
}

- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(BLWaterFlowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(gap, gap, gap, gap);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

@end
