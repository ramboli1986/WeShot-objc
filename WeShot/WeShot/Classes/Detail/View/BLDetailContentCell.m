//
//  BLDetailContentCell.m
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLDetailContentCell.h"

@implementation BLDetailContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    [self setCircleImage:_headImgView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) setFrame:(CGRect)frame {
    frame.size.height -= 8;
    [super setFrame:frame];
}

- (void) setCircleImage: (UIImageView*) imageView {
    //imageView.layer.cornerRadius = imageView.size.width / 2;
    imageView.layer.cornerRadius = imageView.width/2;
    imageView.layer.masksToBounds = YES;
}
@end
