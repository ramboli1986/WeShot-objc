//
//  BLHttpTool.h
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLHttpTool : NSObject

+ (void)Get:(NSString*)URLString parameters:(id)parameters success:(void(^)(id responseObject))sucess failure:(void(^)(NSError* error))failure;
+ (void)Post:(NSString*)URLString parameters:(id)parameters success:(void(^)(id responseObject))sucess failure:(void(^)(NSError* error))failure;
+ (void)Delete:(NSString*)URLString parameters:(id)parameters success:(void(^)(id responseObject))sucess failure:(void(^)(NSError* error))failure;
+ (void)Put:(NSString*)URLString parameters:(id)parameters success:(void(^)(id responseObject))sucess failure:(void(^)(NSError* error))failure;
@end
