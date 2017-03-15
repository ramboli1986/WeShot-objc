//
//  BLShotsTool.h
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BLShotsParams;
@class BLUser;
@interface BLShotsTool : NSObject


+ (void)shotWithParams:(BLShotsParams*)params pageStr:(NSString*)pageStr Success:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure;

+ (void)likeshotWithURLStr:(NSString*)urlStr pageStr:(NSString*)pageStr Success:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure;

+ (void)shotWithURLStr:(NSString*)urlStr pageStr:(NSString*)pageStr Success:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure;

+ (void)commentWithURLStr:(NSString*)urlStr Params:(BLShotsParams*)params pageStr:(NSString*)pageStr Success:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure;

+ (void)userWithSuccess:(void(^)(BLUser* user))success failure:(void(^)(NSError* error))failure;

+ (void)userWithUserId:(NSString*)userId Success:(void(^)(BLUser*))success failure:(void(^)(NSError* error))failure;

+ (void)followShotWithParams:(BLShotsParams*)params pageStr:(NSString*)pageStr Success:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure;

+ (void)likeShotWithUserID:(NSInteger)sid success:(void(^)(id responseObject))success failure:(void(^)(NSError* error))failure;

+ (void)unlikeShotWithUserID:(NSInteger)sid success:(void(^)(id responseObject))success failure:(void(^)(NSError* error))failure;

+ (void)islikeShotWithUserID:(NSInteger)sid success:(void(^)(id responseObject))success failure:(void(^)(NSError* error))failure;

+ (void)followUserWithUserID:(NSInteger)uid success:(void(^)(id responseObject))success failure:(void(^)(NSError* error))failure;

+ (void)unfollowUserWithUserID:(NSInteger)uid success:(void(^)(id responseObject))success failure:(void(^)(NSError* error))failure;

+ (void)isfollowUserWithUserID:(NSString*)uid success:(void(^)(id responseObject))success failure:(void(^)(NSError* error))failure;


@end
