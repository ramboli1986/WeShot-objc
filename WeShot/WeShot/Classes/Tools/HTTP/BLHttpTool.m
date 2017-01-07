//
//  BLHttpTool.m
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//  Handle Networking Request

#import "BLHttpTool.h"
#import <AFNetworking.h>
#import <MJExtension.h>
@implementation BLHttpTool

+ (void)Get:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))sucess failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];
    [mgr.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [mgr.requestSerializer setTimeoutInterval:15];
    [mgr GET:URLString parameters:[parameters mj_keyValues] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    [mgr POST:URLString parameters:[parameters mj_keyValues] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)Delete:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))sucess failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];
    
    [mgr DELETE:URLString parameters:[parameters mj_keyValues] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (sucess) {
            sucess(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)Put:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))sucess failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];
    
    [mgr PUT:URLString parameters:[parameters mj_keyValues] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
