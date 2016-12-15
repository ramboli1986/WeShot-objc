//
//  BLShotsTool.h
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLShotsTool : NSObject

+ (void)allShotsWithList:(NSString*)list sortBy:(NSString*)sortType success:(void(^)(NSArray* shotsArray))success failure:(void(^)(NSError* error))failure;


@end
