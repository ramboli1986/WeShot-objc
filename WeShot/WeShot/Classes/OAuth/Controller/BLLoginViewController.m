//
//  BLLoginViewController.m
//  WeShot
//
//  Created by bo LI on 12/15/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLLoginViewController.h"
#import "BLOAuthViewController.h"

@interface BLLoginViewController ()
- (IBAction)LoginBtn:(id)sender;

@end

@implementation BLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginBtn:(id)sender {
    BLOAuthViewController* vc = [[BLOAuthViewController alloc]init];
    [self showViewController:vc sender:nil];
}
@end
