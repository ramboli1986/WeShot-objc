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

@interface BLGridViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, BLWaterFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation BLGridViewController {
    CGFloat gap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    gap = 4.0;
    // Do any additional setup after loading the view.
    if (self.type == 1) {
        self.view.backgroundColor = [UIColor yellowColor];
    }else if (self.type == 2) {
        self.view.backgroundColor = [UIColor greenColor];
    }else {
        self.view.backgroundColor = BLGlobalBg;
    }
    [self setupCollectionView];
}
- (void)setupCollectionView {
    BLWaterFlowLayout* flowLayout = [[BLWaterFlowLayout alloc]init];
    flowLayout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, ScreenSize.height) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = BLGlobalBg;
    CGFloat bottom = self.tabBarController.tabBar.height;
    self.collectionView.contentInset = UIEdgeInsetsMake(64 + 44, 0, bottom, 0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.collectionView registerNib:[UINib nibWithNibName:@"BLGridCollectionViewCell" bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"gridflowCell"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 22;
}


- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select item :%@", indexPath);
    //MSPDetailViewController *vc = [[MSPDetailViewController alloc]init];
    //vc.hidesBottomBarWhenPushed = YES;
    //[self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gridflowCell" forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - <MSPWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(BLWaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    
    return (ScreenSize.width)/3;
    
    
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
    // Dispose of any resources that can be recreated.
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
