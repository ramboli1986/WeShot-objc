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
#import "BLShotsResult.h"
#import "BLDribbbleAPI.h"

@implementation BLShotsTool


+ (void)popularShotWithSuccess:(void (^)(id shots))success failure:(void (^)(NSError *))failure{
    //send request
    BLShotsParams* params = [[BLShotsParams alloc]init];
    params.access_token = OAuth2_CLIENT_ACCESS_TOKEN;
    [BLHttpTool Get:DRIBBBLE_SHOT parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)recentShotWithSuccess:(void (^)(id shots))success failure:(void (^)(NSError *))failure {
    //send request
    BLShotsParams* params = [[BLShotsParams alloc]init];
    params.access_token = OAuth2_CLIENT_ACCESS_TOKEN;
    params.sort = @"recent";
    [BLHttpTool Get:DRIBBBLE_SHOT parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)teamsShotWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    //send request
    BLShotsParams* params = [[BLShotsParams alloc]init];
    params.access_token = OAuth2_CLIENT_ACCESS_TOKEN;
    params.list = @"teams";
    [BLHttpTool Get:DRIBBBLE_SHOT parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)debutsShotWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    //send request
    BLShotsParams* params = [[BLShotsParams alloc]init];
    params.access_token = OAuth2_CLIENT_ACCESS_TOKEN;
    params.list = @"debuts";
    [BLHttpTool Get:DRIBBBLE_SHOT parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)playoffsShotWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    //send request
    BLShotsParams* params = [[BLShotsParams alloc]init];
    params.access_token = OAuth2_CLIENT_ACCESS_TOKEN;
    params.list = @"playoffs";
    [BLHttpTool Get:DRIBBBLE_SHOT parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


@end
