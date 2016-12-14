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


@interface BLProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView* cv;
@property (nonatomic, weak) UIButton *selectButton;

@end

@implementation BLProfileViewController {
    CGFloat gap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    gap = 4.0;
    [self setupNav];
    [self setupCollectionView];
}

- (void)setupNav{
    if (!self.uid) {
        self.navigationItem.title = @"Profile";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"Logout" target:self action:@selector(logout)];
    } else {
        self.navigationItem.title = @"Player";
    }
    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"location" target:self action:@selector(rightClick)];
    
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
        return cell;
    }
    else {
        BLProfileShotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BLProfileShotCell" forIndexPath:indexPath];
        return cell;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 21;
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
    NSLog(@"select item :%@", indexPath);
    if (indexPath.section == 1) {
        NSLog(@"go to detail");
//        MSPDetailViewController *vc = [[MSPDetailViewController alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
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
    NSLog(@"switch likes / shots");
}

- (void)logout{
    NSLog(@"log out");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
