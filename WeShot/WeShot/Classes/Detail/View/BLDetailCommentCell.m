//
//  BLDetailCommentCell.m
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLDetailCommentCell.h"

@implementation BLDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.comment.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.comment.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};

}

- (void) setFrame:(CGRect)frame {
    frame.size.height -= 8;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
