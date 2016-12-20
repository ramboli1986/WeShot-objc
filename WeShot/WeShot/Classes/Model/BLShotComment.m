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
        UIFont* font = [UIFont systemFontOfSize:13.0f];
        CGFloat bodyHeight = [self.bodyEasyContent boundingRectWithSize:CGSizeMake(cellWidth-16, MAXFLOAT) font:font lineSpacing:0 maxLines:100];
        //NSLog(@"body easy content:%@",self.bodyEasyContent);
        _height = 16 + 28 + 8 + bodyHeight + 16;
    }
    return _height;
}

- (NSString*)bodyEasyContent{
    if (!_bodyEasyContent){
        NSString* res = [self.body stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        res = [res stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        res = [res stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
        res = [res stringByReplacingOccurrencesOfString:@"<br  />" withString:@""];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a href=.*?>(.*?)</a>" options:NSRegularExpressionCaseInsensitive error:nil];
        if (res) {
            NSString *finalRes = [regex stringByReplacingMatchesInString:res options:0 range:NSMakeRange(0, [res length]) withTemplate:@"$1"];
            _bodyEasyContent = finalRes;
        }else {
            _bodyEasyContent = res;
        }
    }
    return _bodyEasyContent;
}
@end
