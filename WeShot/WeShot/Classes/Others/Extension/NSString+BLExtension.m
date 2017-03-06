//
//  NSString+BLExtension.m
//  WeShot
//
//  Created by bo LI on 12/15/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "NSString+BLExtension.h"

@implementation NSString (BLExtension)

+ (instancetype)stringWithDate:(NSString *)dateString{
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    [format setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDate* createDate = [format dateFromString:dateString];
    NSDate* now = [NSDate date];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents* components = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    if (components.year) {
        return [NSString stringWithFormat:@"%zd years ago", components.year];
    } else if (components.month) {
        return [NSString stringWithFormat:@"%zd months ago", components.month];
    } else if (components.day) {
        return [NSString stringWithFormat:@"%zd days ago", components.day];
    } else if (components.minute) {
        return [NSString stringWithFormat:@"%zd minutes ago", components.minute];
    } else {
        return [NSString stringWithFormat:@"%zd seconds ago", components.second];
    }
}

- (CGFloat)boundingRectWithSize:(CGSize)size fontSize:(NSInteger)fontSize{
    NSString* HTMLSTYLE1 = @"<head><style>*{font-size: 15px;color: gray; line-height:130%}a{color:red; text-decoration: none;}</style></head>";
    NSString* HTMLSTYLE2 = @"<head><style>p{font-size: 14px;color: gray; line-height:130%}a{color:red; text-decoration: none;}</style></head>";
    NSString* HTMLSTYLE;
    if (fontSize == 15) {
        HTMLSTYLE = HTMLSTYLE1;
    } else {
        HTMLSTYLE = HTMLSTYLE2;
    }
    NSString* commentHTMLStr = [NSString stringWithFormat:@"%@%@",HTMLSTYLE,self];
    if (self) {
        NSAttributedString * strAtt = [[NSAttributedString alloc] initWithData: [commentHTMLStr dataUsingEncoding:NSUnicodeStringEncoding] options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }documentAttributes: nil error: nil];
        return [strAtt boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    } else {
        return 0;
    }
}

/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)boundingRectWithSize:(CGSize)size paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle font:(UIFont*)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self containChinese:self]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    
    
    return rect.size;
}



/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self containChinese:self]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    
    
    return rect.size;
}



/**
 *  计算最大行数文字高度,可以处理计算带行间距的
 */
- (CGFloat)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines{
    
    if (maxLines <= 0) {
        return 0;
    }
    
    CGFloat maxHeight = font.lineHeight * maxLines + lineSpacing * (maxLines - 1);
    
    CGSize orginalSize = [self boundingRectWithSize:size font:font lineSpacing:lineSpacing];
    
    if ( orginalSize.height >= maxHeight ) {
        return maxHeight;
    }else{
        return orginalSize.height;
    }
}

/**
 *  计算是否超过一行
 */
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing{
    
    if ( [self boundingRectWithSize:size font:font lineSpacing:lineSpacing].height > font.lineHeight  ) {
        return YES;
    }else{
        return NO;
    }
}

- (instancetype)removeURLTag{
    NSString* res = [self stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    res = [res stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    res = [res stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    res = [res stringByReplacingOccurrencesOfString:@"<br  />" withString:@""];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<a href=.*?>(.*?)</a>" options:NSRegularExpressionCaseInsensitive error:nil];
    if (res) {
        return  [regex stringByReplacingMatchesInString:res options:0 range:NSMakeRange(0, [res length]) withTemplate:@"$1"];
    }else {
        return  res;
    }
}

//判断是否包含中文
- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}


@end
