//
//  BLNavigationController.m
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLNavigationController.h"

@interface BLNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation BLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupColor];
    [self fullscreenGestureBack];
}

- (void)fullscreenGestureBack {
    self.hidesBottomBarWhenPushed = YES;
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)setupColor {
    //set back button color to BlackColor
    self.navigationBar.tintColor = [UIColor blackColor];
    
    //set navigation bar background to alpha
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.95];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    // [self.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:17]}];
}

- (void) pushViewController: (UIViewController*)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        btn.size = CGSizeMake(30, 30);
        btn.size = btn.currentImage.size;
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    [super pushViewController:viewController animated:animated];
    
}

- (void) back{
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) handleNavigationTransition:(id)sender {
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}



@end
