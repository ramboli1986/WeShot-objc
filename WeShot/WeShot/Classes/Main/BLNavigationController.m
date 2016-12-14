//
//  BLNavigationController.m
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLNavigationController.h"

@interface BLNavigationController ()

@end

@implementation BLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
