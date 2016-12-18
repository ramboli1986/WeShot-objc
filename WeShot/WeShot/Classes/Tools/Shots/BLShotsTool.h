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

+ (void)likeshotWithURLStr:(NSString*)urlStr Params:(BLShotsParams*)params pageStr:(NSString*)pageStr Success:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure;

+ (void)shotWithURLStr:(NSString*)urlStr Params:(BLShotsParams*)params pageStr:(NSString*)pageStr Success:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure;

+ (void)commentWithURLStr:(NSString*)urlStr Params:(BLShotsParams*)params pageStr:(NSString*)pageStr Success:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure;

+ (void)userWithParams:(BLShotsParams*)params success:(void(^)(BLUser* user))success failure:(void(^)(NSError* error))failure;

+ (void)followShotWithParams:(BLShotsParams*)params pageStr:(NSString*)pageStr Success:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure;

+ (void)likeShotWithUserID:(NSInteger)uid success:(void(^)(id responseObject))success failure:(void(^)(NSError* error))failure;

+ (void)unlikeShotWithUserID:(NSInteger)uid success:(void(^)(id responseObject))success failure:(void(^)(NSError* error))failure;

+ (void)islikeShotWithUserID:(NSInteger)uid success:(void(^)(id responseObject))success failure:(void(^)(NSError* error))failure;

@end
