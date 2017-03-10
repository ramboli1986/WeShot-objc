//
//  BLDetailHeaderView.m
//  WeShot
//
//  Created by bo LI on 12/17/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLDetailHeaderView.h"

@implementation BLDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UITextView*)shotdetail{
    if (_shotdetail == nil){
        _shotdetail.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _shotdetail.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor]};
    }
    return _shotdetail;
}


@end
