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
#import "BLDetailTableViewController.h"

@interface BLFlowViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, BLWaterFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation BLFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.type == 0) {
        self.view.backgroundColor = BLGlobalBg;
    } else {
        self.view.backgroundColor = [UIColor blueColor];
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
    self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, bottom, 0);
    self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    [self.collectionView registerNib:[UINib nibWithNibName:@"BLFlowCollectionViewCell" bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"waterflowCell"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}


- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"select item :%@", indexPath);
    BLDetailTableViewController* vc = [[BLDetailTableViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLFlowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"waterflowCell" forIndexPath:indexPath];
    cell.layer.borderWidth=0.3f;
    cell.layer.borderColor=[[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor;
    return cell;
}

#pragma mark - <MSPWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(BLWaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{

    return 16+24+(ScreenSize.width-12*3)/2 + 152;
    
    
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
