//
//  BLGridCollectionViewCell.m
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLGridCollectionViewCell.h"

@implementation BLGridCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.gifLabel.layer.cornerRadius = 2.0f;
    self.gifLabel.layer.masksToBounds = YES;
}

@end
