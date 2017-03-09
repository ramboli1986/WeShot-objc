//
//  BLAboutMeViewController.m
//  WeShot
//
//  Created by bo LI on 3/8/17.
//  Copyright © 2017 Bo LI. All rights reserved.
//

#import "BLAboutMeViewController.h"
#import "BLProfileViewController.h"
#import <PureLayout.h>

@interface BLAboutMeViewController ()

@property (nonatomic, strong) UIButton* closeButon;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIView* backgroundMaskView;
@property (nonatomic, strong) UILabel* detailLabel;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIImageView* avatarImageView;
@property (nonatomic, strong) UIButton* instagramButton;
@property (nonatomic, strong) UIButton* linkedinButton;
@property (nonatomic, strong) UIButton* dribbbleButton;


@end

@implementation BLAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubViews];
    [self setupSubViewsLayout];
    
    
}

- (void)addSubViews {
    self.imageView = [UIImageView new];
    self.imageView.image = [UIImage imageNamed:@"AboutMeBG"];
    [self.view addSubview:self.imageView];
    self.imageView.userInteractionEnabled = YES;
    
    self.backgroundMaskView = [UIView new];
    self.backgroundMaskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:self.backgroundMaskView];
    
    self.detailLabel = [UILabel new];
    self.detailLabel.text = @"an iOS developer @San Jose, CA. \n\nIf you have any suggestion about Weshot, please feel free to contact me. \nThank you!";
    self.detailLabel.numberOfLines = 5;
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.textColor = [UIColor whiteColor];
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundMaskView addSubview:self.detailLabel];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = @"Hello, I'm Bo.";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundMaskView addSubview:self.titleLabel];
    
    self.avatarImageView = [UIImageView new];
    self.avatarImageView.image = [UIImage imageNamed:@"myself"];
    self.avatarImageView.layer.cornerRadius = 50;
    self.avatarImageView.clipsToBounds = YES;
    [self.backgroundMaskView addSubview:self.avatarImageView];
    
    self.instagramButton = [self createButtonWithImageName:@"instagram" selectorName:@selector(followIns)];
    self.dribbbleButton = [self createButtonWithImageName:@"dribbble" selectorName:@selector(followDribbble)];
    self.linkedinButton = [self createButtonWithImageName:@"linkedin" selectorName:@selector(followlinkedin)];
    
    [self.backgroundMaskView addSubview:self.instagramButton];
    [self.backgroundMaskView addSubview:self.dribbbleButton];
    [self.backgroundMaskView addSubview:self.linkedinButton];
    
    self.closeButon = [UIButton new];
    [self.closeButon setTitle:@"Close" forState:UIControlStateNormal];
    [self.closeButon.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.closeButon addTarget:self action:@selector(dismissPage) forControlEvents:UIControlEventTouchUpInside];
    self.closeButon.clipsToBounds = YES;
    self.closeButon.layer.cornerRadius = 33;
    self.closeButon.layer.borderColor = [UIColor whiteColor].CGColor;
    self.closeButon.layer.borderWidth = 1.5;
    [self.backgroundMaskView addSubview:self.closeButon];
    
}


// image button
- (UIButton*)createButtonWithImageName:(NSString*)imageName selectorName:(SEL)selector {
    UIButton* button = [UIButton new];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void) setupSubViewsLayout {
    [self.imageView autoPinEdgesToSuperviewEdges];
    
    [self.backgroundMaskView autoPinEdgesToSuperviewEdges];
    
    [self.detailLabel autoCenterInSuperview];
    [self.detailLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.backgroundMaskView withOffset:44];
    [self.detailLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.backgroundMaskView withOffset:-44];
    
    [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.backgroundMaskView withOffset:44];
    [self.titleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.backgroundMaskView withOffset:-44];
    [self.titleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.detailLabel withOffset:-4];
    
    [self.avatarImageView autoSetDimension:ALDimensionHeight toSize:100];
    [self.avatarImageView autoSetDimension:ALDimensionWidth toSize:100];
    [self.avatarImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.avatarImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.titleLabel withOffset:-32];
    
    [self.dribbbleButton autoSetDimension:ALDimensionWidth toSize:32];
    [self.dribbbleButton autoSetDimension:ALDimensionHeight toSize:32];
    [self.dribbbleButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.dribbbleButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.detailLabel withOffset:32];
    
    [self.linkedinButton autoSetDimension:ALDimensionWidth toSize:36];
    [self.linkedinButton autoSetDimension:ALDimensionHeight toSize:36];
    [self.linkedinButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.dribbbleButton];
    [self.linkedinButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view withMultiplier:1.5];

    [self.instagramButton autoSetDimension:ALDimensionWidth toSize:36];
    [self.instagramButton autoSetDimension:ALDimensionHeight toSize:36];
    [self.instagramButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.dribbbleButton];
    [self.instagramButton autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view withMultiplier:0.5];
    
    
    
    [self.closeButon autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.closeButon autoSetDimension:ALDimensionHeight toSize:66];
    [self.closeButon autoSetDimension:ALDimensionWidth toSize:66];
    [self.closeButon autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:32];
    
}

- (void)followIns {
    NSURL *instagramURL = [NSURL URLWithString:@"https://www.instagram.com/ramboli2046/"];
    [[UIApplication sharedApplication] openURL:instagramURL options:@{} completionHandler:nil];
}

- (void)followlinkedin {
    NSURL *url = [NSURL URLWithString:@"https://www.linkedin.com/in/bo-li-51984aa3/"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (void)followDribbble {
    UINavigationController* presentingVC = self.presentingViewController.childViewControllers[0];
    [self dismissViewControllerAnimated:YES completion:^{
        BLProfileViewController *vc = [BLProfileViewController new];
        [presentingVC pushViewController:vc animated:YES];
        NSLog(@"%@",presentingVC);
    }];
}

- (void)dismissPage {
    [self dismissViewControllerAnimated:YES completion:nil];
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
