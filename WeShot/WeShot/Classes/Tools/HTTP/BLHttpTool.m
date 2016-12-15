//
//  BLHttpTool.m
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//  Handle Networking Request

#import "BLHttpTool.h"
#import <AFNetworking.h>

@implementation BLHttpTool

+ (void)Get:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))sucess failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];
    [mgr GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)Post:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))sucess failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];
    [mgr POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
