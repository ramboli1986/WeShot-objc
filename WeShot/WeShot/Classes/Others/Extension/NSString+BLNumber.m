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
        return [NSString stringWithFormat:@"%ld.%ldM",num/1000000, (num%1000000)/100000];
    } else if (num > 100000) {
        return[NSString stringWithFormat:@"%ldK", num/100000];
    }
    else if (num >= 1000) {
        return [NSString stringWithFormat:@"%ld.%ldK",num/1000, (num%1000)/100];
    } else {
        return [NSString stringWithFormat:@"%ld",num];
    }
}

@end
