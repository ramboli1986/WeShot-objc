//
//  BLProfileHeaderCell.m
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLProfileHeaderCell.h"

@implementation BLProfileHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setCircleImage:self.headImgView];
    _followBtn.layer.cornerRadius = 4;
    _followBtn.layer.masksToBounds = YES;
    UIColor *color = [UIColor colorWithRed:1 green:0.2 blue:0 alpha:1];
    _followBtn.layer.borderColor = color.CGColor;
    _followBtn.layer.borderWidth = 1.0f;
    [self setCircleImage:self.headImgView];
    
}

- (void) setCircleImage: (UIImageView*) imageView {
    imageView.layer.cornerRadius = imageView.size.width / 2;
    imageView.layer.masksToBounds = YES;
}

@end
