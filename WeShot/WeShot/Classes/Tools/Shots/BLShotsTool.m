//
//  BLShotsTool.m
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLShotsTool.h"
#import "BLHttpTool.h"
#import "BLShotsParams.h"
#import "BLDribbbleAPI.h"
#import "BLShot.h"
#import "BLShotsParams.h"

#import <MJExtension.h>

@implementation BLShotsTool

+ (void)shotWithParams:(BLShotsParams*)params pageStr:(NSString*)pageStr Success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    [BLHttpTool Get:[NSString stringWithFormat:@"%@?%@",DRIBBBLE_SHOT,pageStr] parameters:params success:^(id responseObject) {
        NSArray* shotsArray = [BLShot mj_objectArrayWithKeyValuesArray:responseObject];
        success(shotsArray);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


@end
