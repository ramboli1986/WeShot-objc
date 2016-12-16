//
//  BLShotComment.m
//  WeShot
//
//  Created by bo LI on 12/15/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLShotComment.h"
#import "NSString+BLExtension.h"

@implementation BLShotComment

- (CGFloat)height{
    if (!_height) {
        CGFloat cellWidth = ScreenSize.width - 52;
        UIFont* font = [UIFont systemFontOfSize:13.0f];
        CGFloat bodyHeight = [self.body boundingRectWithSize:CGSizeMake(cellWidth-16, MAXFLOAT) font:font lineSpacing:0 maxLines:100];
        _height = 16 + 28 + 8 + bodyHeight + 16;
    }
    return _height;
}


@end
