//
//  BLShotComment.h
//  WeShot
//
//  Created by bo LI on 12/15/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BLUser;

@interface BLShotComment : NSObject

@property (nonatomic, copy) NSString* body;
@property (nonatomic, strong) BLUser* user;
@property (nonatomic, copy) NSString* created_at;

@property (nonatomic, assign) CGFloat height;
@end
