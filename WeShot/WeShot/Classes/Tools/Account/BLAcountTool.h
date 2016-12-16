//
//  BLAcountTool.h
//  WeShot
//
//  Created by bo LI on 12/16/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLAcountTool : NSObject

+ (void)saveAcount:(NSString*)token;
+ (NSString*)access_Token;
+ (void)deleteToken;
+ (void)homeRootViewController:(UIWindow *)window;

@end
