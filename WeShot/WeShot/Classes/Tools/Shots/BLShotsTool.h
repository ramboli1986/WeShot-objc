//
//  BLShotsTool.h
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BLShotsParams;
@interface BLShotsTool : NSObject


+ (void)shotWithParams:(BLShotsParams*)params pageStr:(NSString*)pageStr Success:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure;


@end
