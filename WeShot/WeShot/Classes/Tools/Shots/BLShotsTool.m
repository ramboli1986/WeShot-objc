//
//  BLShotsTool.m
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLShotsTool.h"
#import "BLHttpTool.h"
#import "BLShotsParam.h"
#import "BLShotsResult.h"


@implementation BLShotsTool

static NSString* APIURL = @"https://api.dribbble.com/v1/user?access_token=17840caa0d314c0d157aa4f5b8dc34c7fdfaa4c0e072ffc1591c366afe24d6cf/shots";


+ (void)allShotsWithList:(NSString *)list sortBy:(NSString *)sortType success:(void (^)(NSArray* shotsArray))success failure:(void (^)(NSError *))failure {
    //create parameter model object
    BLShotsParam* param = [[BLShotsParam alloc]init];
    param.list = list;
    param.sortType = sortType;
    
    //send request
    [BLHttpTool Get:APIURL parameters:param success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}
@end
