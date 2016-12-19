//
//  BLProfileViewController.m
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLProfileViewController.h"
#import "BLProfileHeaderCell.h"
#import "BLGridCollectionViewCell.h"
#import "BLCollectionReusableView.h"
#import "BLShotDetailTableViewController.h"
#import "BLUser.h"

#import "BLShotsTool.h"
#import "BLShot.h"
#import "BLLikeShot.h"
#import "BLShotsParams.h"
#import "BLDribbbleAPI.h"
#import "BLHttpTool.h"

#import "NSString+BLExtension.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SDImageCache.h>
#import <MJRefresh.h>
#import <MJExtension.h>

@interface BLProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView* cv;
@property (nonatomic, weak) UIButton *selectButton;

@property (nonatomic, strong) NSMutableArray* shots;
@property (nonatomic, strong) NSMutableArray* likeShots;

@property (nonatomic, weak) UIButton* followBtn;

@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, assign) BOOL hasMoreLike;
@property (nonatomic, assign) BOOL hasMoreShot;

@property (nonatomic, weak) UIButton* likeBtn;
@property (nonatomic, weak) UIButton* shotBtn;

@end

//fix

@implementation BLProfileViewController {
    CGFloat gap;
    NSInteger shotpage;
    NSInteger likepage;
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
    [super viewDidLoad];
    [self setupNav];
    [self setupCollectionView];
    [self setupRefresh];
}


- (void)setupNav{
    if (!self.user) {
        self.navigationItem.title = @"Profile";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"Logout" target:self action:@selector(logout)];
        self.isSelf = YES;
        [self loadSelfUserObj];
    } else {
        self.navigationItem.title = @"Player";
    }
}

- (void)loadSelfUserObj{
    [BLShotsTool userWithSuccess:^(BLUser *user) {
        self.user = user;
        [self.cv reloadData];
    } failure:^(NSError *error) {
        NSLog(@"1.%@",error.localizedDescription);
    }];
}
- (void)setupRefresh {
    // The drop-down refresh
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShots)];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    [header beginRefreshing];
    
    self.cv.mj_header = header;
}


- (void)loadNewShots {

    self.hasMoreLike = YES;
    self.hasMoreShot = YES;
    
    NSString* pageStr = [NSString stringWithFormat:@"page=1&per_page%zd",PER_PAGE];
    [self.shotBtn setTitle:[NSString stringWithFormat:@"Shots • %zd", self.user.shots_count] forState:UIControlStateNormal];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"Likes • %zd", self.user.likes_count] forState:UIControlStateNormal];
    
    //shot data
    [BLShotsTool shotWithURLStr:self.user.shots_url pageStr:pageStr Success:^(NSArray *shotsArray) {
        shotpage = 1;
        likepage = 1;
        [self.shots removeAllObjects];
        [self.shots addObjectsFromArray:shotsArray];
        //like shot data
        [BLShotsTool likeshotWithURLStr:self.user.likes_url pageStr:pageStr Success:^(NSArray *shotsArray) {
            [self.likeShots removeAllObjects];
            [self.likeShots addObjectsFromArray:shotsArray];
            if (self.isSelf) {
                [BLShotsTool userWithSuccess:^(BLUser *user) {
                    self.user = user;
                    [self.shotBtn setTitle:[NSString stringWithFormat:@"Shots • %zd", self.user.shots_count] forState:UIControlStateNormal];
                    [self.likeBtn setTitle:[NSString stringWithFormat:@"Likes • %zd", self.user.likes_count] forState:UIControlStateNormal];
                    [self.cv reloadData];
                    [self.cv.mj_header endRefreshing];
                } failure:^(NSError *error) {
                    NSLog(@"1.%@",error.localizedDescription);
                    [self.cv.mj_header endRefreshing];
                }];
            } else {
                [self.cv reloadData];
                [self.cv.mj_header endRefreshing];
            }
        } failure:^(NSError *error) {
            NSLog(@"2.error:%@",error.localizedDescription);
            [self.cv.mj_header endRefreshing];
        }];
    } failure:^(NSError *error) {
        NSLog(@"3.error:%@",error.localizedDescription);
        [self.cv.mj_header endRefreshing];
    }];
    
    
}

- (void)loadMoreShots {

    NSString *pageStr = [NSString stringWithFormat:@"page=%zd&per_page=%zd",shotpage+1, PER_PAGE];
    //shot data
    [BLShotsTool shotWithURLStr:self.user.shots_url pageStr:pageStr Success:^(NSArray *shotsArray) {
        if (shotsArray.count == 0) {
            _hasMoreShot = NO;
            return;
        }
        shotpage++;
        [self.shots addObjectsFromArray:shotsArray];
        [self.cv reloadData];
    } failure:^(NSError *error) {
        NSLog(@"4.error:%@",error.localizedDescription);
    }];
}

- (void)loadMoreLikeShots{
    //like shot data
    NSString *pageStr = [NSString stringWithFormat:@"page=%zd&per_page=%zd",likepage+1, PER_PAGE];
    [BLShotsTool likeshotWithURLStr:self.user.likes_url pageStr:pageStr Success:^(NSArray *shotsArray) {
        if (shotsArray.count == 0) {
            _hasMoreLike = NO;
            return;
        }
        likepage++;
        for (int i = 0; i < shotsArray.count; i++) {
            BLLikeShot* likeshot = shotsArray[i];
            [self.likeShots addObject:likeshot];
        }
        [self.cv reloadData];
    } failure:^(NSError *error) {
        NSLog(@"5.error:%@",error.localizedDescription);
    }];
}


- (void)setupCollectionView {
    gap = 4.0;
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    _cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowlayout];
    _cv.delegate = self;
    _cv.dataSource = self;
    _cv.backgroundColor = BLGlobalBg;
    
    [_cv registerNib:[UINib nibWithNibName:@"BLCollectionReusableView" bundle: [NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BLCollectionReusableView"];
    
    [_cv registerNib:[UINib nibWithNibName:@"BLGridCollectionViewCell" bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"BLGridCollectionViewCell"];
    [_cv registerNib:[UINib nibWithNibName:@"BLProfileHeaderCell" bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"BLProfileHeaderCell"];
    
    [self.view addSubview:_cv];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BLProfileHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BLProfileHeaderCell" forIndexPath:indexPath];
        NSString* avatorURLStr = self.user.avatar_url;
        [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:avatorURLStr] placeholderImage:nil];
        cell.userName.text = self.user.name;
        cell.shotsCount.text = [NSString stringWithFormat:@"%zd",self.user.shots_count];
        cell.followerCount.text = [NSString stringWithFormat:@"%zd",self.user.followers_count];
        cell.followingCount.text = [NSString stringWithFormat:@"%zd",self.user.followings_count];
        [cell.userLocation setTitle:self.user.location forState:UIControlStateNormal];
        cell.userBIO.text = self.user.bio;
        self.followBtn = cell.followBtn;
        [self setupProfileBtn];
        return cell;
    }
    else {
        BLGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BLGridCollectionViewCell" forIndexPath:indexPath];
        
        NSString* imageURLStr;
        if (self.isLike) {
            BLLikeShot* likeShot = self.likeShots[indexPath.row];
            imageURLStr = likeShot.shot.images.teaser;
            cell.gifLabel.hidden = likeShot.shot.animated?NO:YES;
        } else {
            BLShot *shot = self.shots[indexPath.row];
            imageURLStr = shot.images.teaser;
            cell.gifLabel.hidden = shot.animated?NO:YES;
        }
        
        [cell.shotImage sd_setImageWithURL:[NSURL URLWithString:imageURLStr] placeholderImage:nil];
        
        if (self.isLike) {
            if (indexPath.row == self.likeShots.count-1) {
                if (_hasMoreLike) {
                    [self loadMoreLikeShots];
                }
            }
        } else {
            if (indexPath.row == self.shots.count-1) {
                if (_hasMoreShot) {
                    [self loadMoreShots];
                }
            }
        }
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
        UIFont* bioFont = [UIFont fontWithName:@"Kannada Sangam MN" size:14.0f];
        CGFloat bioWidth = [self.user.bio boundingRectWithSize:CGSizeMake(cellWidth-16, MAXFLOAT) font:bioFont lineSpacing:0 maxLines:100];
        CGFloat cellHeight = 16 + 80 + 16 + 43 + 16 + bioWidth + 16;
        return CGSizeMake(cellWidth, cellHeight);
    } else {
        CGFloat cellWidth = (ScreenSize.width - (3+1)*gap)/3;
        return CGSizeMake(cellWidth, 3*cellWidth/4);
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
        NSString* btnTitle;
        if (i == 0) {
            self.shotBtn = button;
            btnTitle = [NSString stringWithFormat:@"Shots • %zd", self.user.shots_count];
        } else {
            self.likeBtn = button;
            btnTitle =[NSString stringWithFormat:@"Likes • %zd", self.user.likes_count];
        }
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
        
        if (self.isLike) {
            BLLikeShot* likeShot = self.likeShots[indexPath.row];
            vc.shot = likeShot.shot;
        }else {
            vc.shot = self.shots[indexPath.row];
            vc.shot.user = self.user;
        }
        
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
    [BLAcountTool logout];
}

- (void)setupProfileBtn{
    if (self.isSelf) {
        _followBtn.enabled = NO;
        _followBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_followBtn setTitle:@"Profile" forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        return;
    } else {
        [BLShotsTool isfollowUserWithUserID:self.user.uid success:^(id responseObject) {
            [self followingStyle];
        } failure:^(NSError *error) {
            NSLog(@"not a following:%@",error.localizedDescription);
            [self unfollowStyle];
        }];
    }
    [_followBtn addTarget:self action:@selector(followUserBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)followUserBtn{
    //follow to unfollow
    if (_followBtn.tag == 101) {
        [self unfollowStyle];
        [BLShotsTool unfollowUserWithUserID:self.user.uid success:^(id responseObject) {
            ;
        } failure:^(NSError *error) {
            [self followingStyle];
        }];
    } else if (_followBtn.tag == 102){
        
        [self followingStyle];
        [BLShotsTool followUserWithUserID:self.user.uid success:^(id responseObject) {
            ;
        } failure:^(NSError *error) {
            [self unfollowStyle];
        }];
    }
}

- (void)followingStyle{
    _followBtn.tag = 101;
    _followBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_followBtn setTitle:@"Following" forState:UIControlStateNormal];
    [_followBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

}

- (void)unfollowStyle{
    _followBtn.tag = 102;
    _followBtn.layer.borderColor = [UIColor redColor].CGColor;
    [_followBtn setTitle:@"Follow" forState:UIControlStateNormal];
    [_followBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
}

@end
