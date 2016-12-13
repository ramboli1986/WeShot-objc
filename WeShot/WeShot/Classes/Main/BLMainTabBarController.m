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
#import "BLProfileTableViewController.h"
#import "BLNavigationController.h"

@interface BLMainTabBarController ()
@property (nonatomic, strong)UIView* indicatorView;
@end

@implementation BLMainTabBarController {
    CGFloat indicatorW;
    CGFloat indicatorH;
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
    
    [self.indicatorView removeFromSuperview];
    self.indicatorView.centerX = ScreenSize.width/6.0;
    [self.view addSubview:self.indicatorView];
}



- (void)setupChildVC {
    [self setupChildVC:[[BLHomeViewController alloc]init] image:@"home"];
    [self setupChildVC:[[BLExploreViewController alloc]init] image:@"explore"];
    [self setupChildVC:[[BLProfileTableViewController alloc]init] image:@"user"];
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
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [tabBar.items indexOfObject:item];
    self.indicatorView.centerX = ScreenSize.width/6 + ScreenSize.width*index/3;
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
