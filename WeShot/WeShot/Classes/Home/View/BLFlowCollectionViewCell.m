//
//  BLFlowCollectionViewCell.m
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLFlowCollectionViewCell.h"

@implementation BLFlowCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.isGif.layer.cornerRadius = 2.0f;
    self.isGif.layer.masksToBounds = YES;
}

@end
