//
//  BLTabBarController.m
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLMainTabBarController.h"
#import "BLHomeViewController.h"
#import "BLExploreViewController.h"
#import "BLProfileViewController.h"
#import "BLNavigationController.h"

@interface BLMainTabBarController ()
@property (nonatomic, strong)UIView* indicatorView;
@end

@implementation BLMainTabBarController {
    CGFloat indicatorW;
    CGFloat indicatorH;
    NSInteger selectedIndex;
}


- (UIView*)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIView alloc]init];
    }
    //indicatorW = ScreenSize.width/15.0;
    indicatorH = 3.0;
    _indicatorView.width = indicatorW;
    _indicatorView.height = indicatorH;
    _indicatorView.y = ScreenSize.height-indicatorH;
    _indicatorView.backgroundColor = BLTintColor;
    return _indicatorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildVC];
    [self setupTabBarIndicator];
    [self setupTabBarBackground];
    
    [self.indicatorView removeFromSuperview];
    self.indicatorView.centerX = ScreenSize.width/6.0;
    [self.view addSubview:self.indicatorView];
}

- (void)setupTabBarBackground{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.95];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:image];
}


- (void)setupChildVC {
    [self setupChildVC:[[BLHomeViewController alloc]init] image:@"home"];
    [self setupChildVC:[[BLExploreViewController alloc]init] image:@"explore"];
    [self setupChildVC:[[BLProfileViewController alloc]init] image:@"user"];
}

-(void)setupChildVC:(UIViewController*)vc image:(NSString*)imageName {
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@-click",imageName]];
    if (indicatorW == 0.0) {
        indicatorW = vc.tabBarItem.image.size.width;
    }
    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    BLNavigationController* nav = [[BLNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)setupTabBarIndicator {
    selectedIndex = 0;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [tabBar.items indexOfObject:item];
    self.indicatorView.centerX = ScreenSize.width/6 + ScreenSize.width*index/3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
