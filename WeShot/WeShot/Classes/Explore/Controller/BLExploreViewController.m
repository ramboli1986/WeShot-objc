//
//  BLExploreViewController.m
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLExploreViewController.h"
#import "BLGridViewController.h"

@interface BLExploreViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, weak) UIView *titlesView;
@property (nonatomic, weak) UIButton *selectButton;
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, weak) UIView *indicatorView;

@end

@implementation BLExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BLGlobalBg;
    self.navigationItem.title = @"Explore";
    [self setupChildView];
    [self setupTitleView];
    [self setupContentView];
}

- (void)setupChildView {
    BLGridViewController* recentVC = [[BLGridViewController alloc]init];
    recentVC.type = BLGridVCTypeRecent;
    [self addChildViewController:recentVC];
    
    BLGridViewController* teamsVC = [[BLGridViewController alloc]init];
    teamsVC.type = BLGridVCTypeTeams;
    [self addChildViewController:teamsVC];
    
    BLGridViewController* debutsVC = [[BLGridViewController alloc]init];
    debutsVC.type = BLGridVCTypeDebuts;
    [self addChildViewController:debutsVC];
    
    BLGridViewController* playoffVC = [[BLGridViewController alloc]init];
    playoffVC.type = BLGridVCTypePlayoffs;
    [self addChildViewController:playoffVC];
}

- (void)setupTitleView {
    //setup TitleView
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    titleView.width = ScreenSize.width;
    titleView.height = 44;
    titleView.y = 64;
    titleView.x = 0;
    [self.view addSubview:titleView];
    self.titlesView = titleView;
    
    //setup TitleView's Indicator
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor = BLTintColor;
    indicatorView.alpha = 0.9;
    indicatorView.height = 1;
    indicatorView.tag = -1;
    indicatorView.y = titleView.height - indicatorView.height - 1;
    self.indicatorView = indicatorView;
    
    NSArray *titles = @[@"Recent", @"Teams", @"Debuts", @"Playoffs"];
    CGFloat width = ScreenSize.width/4;
    CGFloat height = titleView.height;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.tag = i;
        button.height = height;
        button.width = width;
        button.x = width*i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        //[button layoutIfNeeded];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        UIColor *tintColor = BLTintColor;
        [button setTitleColor:tintColor forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        
        if (i == 0) {
            button.enabled = NO;
            self.selectButton = button;
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
    }
    [titleView addSubview:indicatorView];
    
}

- (void) setupContentView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *contentView = [[UIScrollView alloc]init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    //add first tableview
    [self scrollViewDidEndScrollingAnimation:contentView];
}

- (void) titleClick: (UIButton*) button {
    self.selectButton.enabled = YES;
    button.enabled = NO;
    self.selectButton = button;
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    //switch child controller
    CGPoint offset = self.contentView.contentOffset;
    offset.x = self.view.width * button.tag;
    [self.contentView setContentOffset:offset animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //add child controller
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    BLGridViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;
    vc.view.height = scrollView.height;
    [scrollView addSubview:vc.view];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightClick {
    NSLog(@"right button");
}


@end
