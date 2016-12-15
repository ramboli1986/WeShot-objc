//
//  BLShotsTool.h
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLShotsTool : NSObject


+ (void)popularShotWithSuccess:(void(^)(id shots))success failure:(void(^)(NSError* error))failure;

+ (void)recentShotWithSuccess:(void(^)(id shots))success failure:(void(^)(NSError* error))failure;

+ (void)teamsShotWithSuccess:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure;

+ (void)debutsShotWithSuccess:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure;

+ (void)playoffsShotWithSuccess:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure;

@end
