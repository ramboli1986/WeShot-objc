//
//  NSString+BLNumber.m
//  WeShot
//
//  Created by bo LI on 3/5/17.
//  Copyright © 2017 Bo LI. All rights reserved.
//

#import "NSString+BLNumber.h"

@implementation NSString (BLNumber)

+ (instancetype)stringWithIntger:(NSInteger)num{
    if (num >= 1000000) {
        return [NSString stringWithFormat:@"%zd.%zdM",num/1000000, (num%1000000)/100000];
    } else if (num > 100000) {
        return[NSString stringWithFormat:@"%zdK", num/100000];
    }
    else if (num >= 1000) {
        return [NSString stringWithFormat:@"%zd.%zdK",num/1000, (num%1000)/100];
    } else {
        return [NSString stringWithFormat:@"%zd",num];
    }
}

@end
