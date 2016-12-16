//
//  BLProfileViewController.m
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLProfileViewController.h"
#import "BLProfileHeaderCell.h"
#import "BLProfileShotCell.h"
#import "BLCollectionReusableView.h"
#import "BLShotDetailTableViewController.h"
#import "BLUser.h"

#import "BLShotsTool.h"
#import "BLShot.h"
#import "BLLikeShot.h"
#import "BLShotsParams.h"
#import "BLDribbbleAPI.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDImageCache.h>
#import <MJRefresh.h>

@interface BLProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView* cv;
@property (nonatomic, weak) UIButton *selectButton;

@property (nonatomic, strong) NSMutableArray* shots;
@property (nonatomic, strong) NSMutableArray* likeShots;

@property (nonatomic, assign) BOOL isLike;

@end

@implementation BLProfileViewController {
    CGFloat gap;
    NSInteger shotpage;
    NSInteger likepage;
    NSInteger per_page;
}

- (NSMutableArray*)shots {
    if (_shots == nil) {
        _shots = [NSMutableArray array];
    }
    return _shots;
}

- (NSMutableArray*)likeShots {
    if (_likeShots == nil) {
        _likeShots = [NSMutableArray array];
    }
    return _likeShots;
}

- (void)viewDidLoad {
    gap = 4.0;
    per_page = 27;
    [super viewDidLoad];
    [self setupNav];
    [self setupCollectionView];
    [self setupRefresh];
}

- (void)setupRefresh {
    // The drop-down refresh
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShots)];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header beginRefreshing];
    
    self.cv.mj_header = header;
    
    // The pull-up refresh
    self.cv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.isLike) {
            [self loadMoreLikeShots];
        } else {
            [self loadMoreShots];
        }
    }];
}

- (void)setupNav{
    if (!self.user) {
        self.navigationItem.title = @"Profile";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"Logout" target:self action:@selector(logout)];
    } else {
        self.navigationItem.title = @"Player";
    }
}

- (void)loadNewShots {
    BLShotsParams* params = [[BLShotsParams alloc]init];
    params.access_token = OAuth2_CLIENT_ACCESS_TOKEN;
    NSString* pageStr = @"page=1&per_page=21";
    //shot data
    [BLShotsTool shotWithURLStr:self.user.shots_url Params:params pageStr:pageStr Success:^(NSArray *shotsArray) {
        shotpage = 1;
        likepage = 1;
        [self.shots removeAllObjects];
        [self.shots addObjectsFromArray:shotsArray];
        [self.cv reloadData];
        [self.cv.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
        [self.cv.mj_header endRefreshing];
    }];
    //like shot data
    [BLShotsTool likeshotWithURLStr:self.user.likes_url Params:params pageStr:pageStr Success:^(NSArray *shotsArray) {
        [self.likeShots removeAllObjects];
        //[self.likeShots addObjectsFromArray:shotsArray];
        for (int i = 0; i < shotsArray.count; i++) {
            BLLikeShot* likeshot = shotsArray[i];
            [self.likeShots addObject:likeshot];
        }
        //[self.cv reloadData];
        [self.cv.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
        [self.cv.mj_header endRefreshing];
    }];
}

- (void)loadMoreShots {
    BLShotsParams* params = [[BLShotsParams alloc]init];
    params.access_token = OAuth2_CLIENT_ACCESS_TOKEN;
    NSString *pageStr = [NSString stringWithFormat:@"page=%zd&per_page=%zd",shotpage+1, per_page];
    //shot data
    [BLShotsTool shotWithURLStr:self.user.shots_url Params:params pageStr:pageStr Success:^(NSArray *shotsArray) {
        shotpage++;
        [self.shots addObjectsFromArray:shotsArray];
        [self.cv reloadData];
        [self.cv.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
        [self.cv.mj_footer endRefreshing];
    }];
}

- (void)loadMoreLikeShots{
    //like shot data
    BLShotsParams* params = [[BLShotsParams alloc]init];
    params.access_token = OAuth2_CLIENT_ACCESS_TOKEN;
    NSString *pageStr = [NSString stringWithFormat:@"page=%zd&per_page=%zd",likepage+1, per_page];
    [BLShotsTool likeshotWithURLStr:self.user.likes_url Params:params pageStr:pageStr Success:^(NSArray *shotsArray) {
        likepage++;
        for (int i = 0; i < shotsArray.count; i++) {
            BLLikeShot* likeshot = shotsArray[i];
            [self.likeShots addObject:likeshot];
        }
        [self.cv reloadData];
        [self.cv.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
        [self.cv.mj_footer endRefreshing];
    }];
}


- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    _cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowlayout];
    _cv.delegate = self;
    _cv.dataSource = self;
    _cv.backgroundColor = BLGlobalBg;
    
    [_cv registerNib:[UINib nibWithNibName:@"BLCollectionReusableView" bundle: [NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BLCollectionReusableView"];
    [_cv registerNib:[UINib nibWithNibName:@"BLProfileShotCell" bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"BLProfileShotCell"];
    [_cv registerNib:[UINib nibWithNibName:@"BLProfileHeaderCell" bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"BLProfileHeaderCell"];
    
    [self.view addSubview:_cv];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BLProfileHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BLProfileHeaderCell" forIndexPath:indexPath];
        NSString* avatorURLStr = self.user.avatar_url;
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:avatorURLStr] placeholderImage:nil];
        cell.userName.text = self.user.username;
        cell.shotsCount.text = [NSString stringWithFormat:@"%zd",self.user.shots_count];
        cell.followerCount.text = [NSString stringWithFormat:@"%zd",self.user.followers_count];
        cell.followingCount.text = [NSString stringWithFormat:@"%zd",self.user.followings_count];
        [cell.userLocation setTitle:self.user.location forState:UIControlStateNormal];
        cell.userBIO.text = self.user.bio;
        return cell;
    }
    else {
        BLProfileShotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BLProfileShotCell" forIndexPath:indexPath];
        
        NSString* imageURLStr;
        if (self.isLike) {
            BLLikeShot* likeShot = self.likeShots[indexPath.row];
            imageURLStr = likeShot.shot.images.teaser;
        } else {
            BLShot *shot = self.shots[indexPath.row];
            imageURLStr = shot.images.teaser;
        }
        
        [cell.shotImage sd_setImageWithURL:[NSURL URLWithString:imageURLStr] placeholderImage:nil];
        return cell;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.isLike?self.likeShots.count:self.shots.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat cellWidth = ScreenSize.width;
        return CGSizeMake(cellWidth, cellWidth-110);
    } else {
        CGFloat cellWidth = (ScreenSize.width - (3+1)*gap)/3;
        return CGSizeMake(cellWidth, cellWidth);
    }
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, gap, 0);
    }
    else {
        return UIEdgeInsetsMake(gap, gap, gap, gap);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    BLCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BLCollectionReusableView" forIndexPath:indexPath];
    
    CGFloat width = headerView.width/2;
    CGFloat height = headerView.height;
    NSArray* titles = @[@"Shots", @"Likes"];
    if (headerView.subviews.count >= 2) {
        return headerView;
    }
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.tag = i;
        button.height = height;
        button.width = width;
        button.x = width*i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        //UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        UIColor *tintColor = BLTintColor;
        [button setTitleColor:tintColor forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        if (i == 0) {
            button.enabled = NO;
            self.selectButton = button;
        }
    }
    return headerView;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        BLShotDetailTableViewController* vc = [[BLShotDetailTableViewController alloc]init];
        BLLikeShot* likeShot = self.likeShots[indexPath.row];
        vc.shot = self.isLike ? likeShot.shot : self.shots[indexPath.row];
        vc.shot.user = self.isLike ? likeShot.shot.user : self.user;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return gap;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return gap;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeZero;
    } else {
        return CGSizeMake(ScreenSize.width, 44); // header cell width and height
    }
}

- (void)titleClick: (UIButton*) button {
    self.selectButton.enabled = YES;
    button.enabled = NO;
    self.selectButton = button;
    self.isLike = !self.isLike;
    [self.cv reloadData];
}

- (void)logout{
    NSLog(@"log out");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
