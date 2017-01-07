//
//  BLShotComment.m
//  WeShot
//
//  Created by bo LI on 12/15/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLShotComment.h"
#import "NSString+BLExtension.h"

@implementation BLShotComment{
    NSString* _bodyEasyContent;
}

- (CGFloat)height{
    if (!_height) {
        CGFloat cellWidth = ScreenSize.width - 52;
        UIFont* font = [UIFont systemFontOfSize:14.0f];
        CGFloat bodyHeight = [self.bodyEasyContent boundingRectWithSize:CGSizeMake(cellWidth-16, MAXFLOAT) font:font lineSpacing:0 maxLines:100];
        //NSLog(@"body easy content:%@",self.bodyEasyContent);
        _height = 16 + 28 + 8 + bodyHeight + 32;
    }
    return _height;
}

- (NSString*)bodyEasyContent{
    if (!_bodyEasyContent){
        _bodyEasyContent = [self.body removeURLTag];
    }
    return _bodyEasyContent;
}
@end
