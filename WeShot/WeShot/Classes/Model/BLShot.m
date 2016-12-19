//
//  BLShot.m
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLShot.h"
#import "NSString+BLExtension.h"

@implementation BLShot {
    CGFloat _homeCellHeight;
    CGFloat _detailCellHeight;
    NSString* _detailEasyContent;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"sid":@"id",
             @"detailContent":@"description",
             };
}

- (CGFloat)homeCellHeight {
    if (!_homeCellHeight) {
        UIFont *titleFont = [UIFont systemFontOfSize:12.0f weight:UIFontWeightSemibold];
        UIFont *detailFont = [UIFont fontWithName:@"Kohinoor Telugu" size:12.0f];
        CGFloat cellWidth = (ScreenSize.width-12*3)/2.0;
        
        CGFloat shotImageHeight = cellWidth*self.height/self.width;
        CGFloat titleHeight = [self.title boundingRectWithSize:CGSizeMake(cellWidth-16, MAXFLOAT) font:titleFont lineSpacing:0 maxLines:2];
        CGFloat detailHeight = [self.detailEasyContent boundingRectWithSize:CGSizeMake(cellWidth-16, MAXFLOAT) font:detailFont lineSpacing:0 maxLines:3];
        _homeCellHeight = 8 + BLAvatorHeight + 16 + detailHeight + 16 + titleHeight + 16 + shotImageHeight;
        //NSLog(@"%@,%f, %f",self.title, titleHeight, _homeCellHeight);
    }
    return _homeCellHeight;
}



- (CGFloat)detailCellHeight {
    if (!_detailCellHeight) {
        UIFont *titleFont = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
        UIFont *detailFont = [UIFont fontWithName:@"Kailasa" size:14.0f];
        
        CGFloat shotImageHeight = ScreenSize.width*3/4;
        CGFloat titleHeight = [self.title boundingRectWithSize:CGSizeMake(ScreenSize.width-16, MAXFLOAT) font:titleFont lineSpacing:0 maxLines:INT_MAX];
        CGFloat detailHeight = [self.detailEasyContent boundingRectWithSize:CGSizeMake(ScreenSize.width-16, MAXFLOAT) font:detailFont lineSpacing:0 maxLines:INT_MAX];
        
        _detailCellHeight = 8 + 35 + 8 + shotImageHeight + 16 + titleHeight + 16 + detailHeight + 30 + 44;
        NSLog(@"%@,%f, %f",self.title, titleHeight, _homeCellHeight);
    }
    return _detailCellHeight;
}

- (NSString*)detailEasyContent{
    if (!_detailEasyContent){
        NSString* res = [self.detailContent stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        res = [res stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        res = [res stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
        res = [res stringByReplacingOccurrencesOfString:@"<br  />" withString:@""];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a href=.*?>(.*?)</a>" options:NSRegularExpressionCaseInsensitive error:nil];
        if (res) {
            NSString *finalRes = [regex stringByReplacingMatchesInString:res options:0 range:NSMakeRange(0, [res length]) withTemplate:@"$1"];
            _detailEasyContent = finalRes;
        }else {
            _detailContent = res;
        }
    }
    return _detailEasyContent;
}
@end
