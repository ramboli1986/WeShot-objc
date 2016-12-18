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
#import "BLUser.h"
#import "BLLikeShot.h"
#import "BLShotsParams.h"
#import "BLShotComment.h"

#import <MJExtension.h>

@implementation BLShotsTool

+ (void)userWithParams:(BLShotsParams*)params success:(void(^)(BLUser*))success failure:(void(^)(NSError* error))failure {
    [BLHttpTool Get:DRIBBBLE_USER parameters:params success:^(id responseObject) {
        success([BLUser mj_objectWithKeyValues:responseObject]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)likeshotWithURLStr:(NSString *)urlStr Params:(BLShotsParams *)params pageStr:(NSString *)pageStr Success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    [BLHttpTool Get:[NSString stringWithFormat:@"%@?%@",urlStr,pageStr] parameters:params success:^(id responseObject) {
        NSArray* shotsArray = [BLLikeShot mj_objectArrayWithKeyValuesArray:responseObject];
        success(shotsArray);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)commentWithURLStr:(NSString*)urlStr Params:(BLShotsParams*)params pageStr:(NSString*)pageStr Success:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure {
    [BLHttpTool Get:[NSString stringWithFormat:@"%@?%@",urlStr,pageStr] parameters:params success:^(id responseObject) {
        NSArray* shotsArray = [BLShotComment mj_objectArrayWithKeyValuesArray:responseObject];
        success(shotsArray);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)shotWithParams:(BLShotsParams*)params pageStr:(NSString*)pageStr Success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    [BLHttpTool Get:[NSString stringWithFormat:@"%@?%@",DRIBBBLE_SHOT,pageStr] parameters:params success:^(id responseObject) {
        NSArray* shotsArray = [BLShot mj_objectArrayWithKeyValuesArray:responseObject];
        success(shotsArray);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


+ (void)followShotWithParams:(BLShotsParams*)params pageStr:(NSString*)pageStr Success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    [BLHttpTool Get:[NSString stringWithFormat:@"%@?%@",DRIBBBLE_FOLLOW_SHOT,pageStr] parameters:params success:^(id responseObject) {
        NSArray* shotsArray = [BLShot mj_objectArrayWithKeyValuesArray:responseObject];
        success(shotsArray);
    } failure:^(NSError *error) {
        failure(error);
    }];
}



+ (void)shotWithURLStr:(NSString*)urlStr Params:(BLShotsParams*)params pageStr:(NSString*)pageStr Success:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure{
    [BLHttpTool Get:[NSString stringWithFormat:@"%@?%@",urlStr,pageStr] parameters:params success:^(id responseObject) {
        NSArray* shotsArray = [BLShot mj_objectArrayWithKeyValuesArray:responseObject];
        success(shotsArray);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)likeShotWithUserID:(NSInteger)uid success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    BLShotsParams* params = [[BLShotsParams alloc]init];
    params.access_token = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY];
    [BLHttpTool Post:[NSString stringWithFormat:@"%@/%@/like",DRIBBBLE_SHOT,[NSString stringWithFormat:@"%zd",uid]] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)unlikeShotWithUserID:(NSInteger)uid success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    BLShotsParams* params = [[BLShotsParams alloc]init];
    params.access_token = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY];
    [BLHttpTool Delete:[NSString stringWithFormat:@"%@/%@/like",DRIBBBLE_SHOT,[NSString stringWithFormat:@"%zd",uid]] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)islikeShotWithUserID:(NSInteger)uid success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    BLShotsParams* params = [[BLShotsParams alloc]init];
    params.access_token = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN_KEY];
    [BLHttpTool Get:[NSString stringWithFormat:@"%@/%@/like",DRIBBBLE_SHOT,[NSString stringWithFormat:@"%zd",uid]] parameters:params success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


@end
