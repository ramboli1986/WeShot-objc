//
//  BLHomeViewController.m
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLHomeViewController.h"
#import "BLFlowViewController.h"

@interface BLHomeViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *indicatorView;
@property (nonatomic, weak) UIButton *selectButton;
@property (nonatomic, weak) UIView *titlesView;
@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation BLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BLGlobalBg;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"location" target:self action:@selector(rightClick)];
    [self setupChildView];
    [self setupTitleView];
    [self setContentView];
}

- (void)setupChildView {
    BLFlowViewController* followVC = [[BLFlowViewController alloc]init];
    followVC.type = BLFlowVCTypeFollow;
    [self addChildViewController:followVC];
    
    BLFlowViewController* popularVC = [[BLFlowViewController alloc]init];
    popularVC.type = BLFlowVCTypePopular;
    [self addChildViewController:popularVC];
}


- (void)setupTitleView {
    //setup TitleView
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    titleView.width = ScreenSize.width;
    titleView.height = 35;
    titleView.y = 4;
    titleView.x = 0;
    self.navigationItem.titleView = titleView;
    self.titlesView = titleView;
    
    //setup TitleView's Indicator
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor = BLTintColor;
    indicatorView.alpha = 0.9;
    indicatorView.height = 3;
    indicatorView.tag = -1;
    indicatorView.y = titleView.height - indicatorView.height + 4;
    self.indicatorView = indicatorView;
    
    NSArray *titles = @[@"Following", @"Popular"];
    CGFloat width = ScreenSize.width/4;
    CGFloat height = titleView.height;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.tag = i;
        button.height = height;
        button.width = width;
        button.x = width*i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIColor *tintColor = BLTintColor;
        [button setTitleColor:tintColor forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
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

- (void) setContentView {
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
    BLFlowViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;
    vc.view.height = scrollView.height;
    //CGFloat bottom = self.tabBarController.tabBar.height;
    //vc.cv.contentInset = UIEdgeInsetsMake(64, 0, bottom, 0);
    //vc.cv.scrollIndicatorInsets = vc.cv.contentInset;
    [scrollView addSubview:vc.view];
    [vc refreshView];
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
