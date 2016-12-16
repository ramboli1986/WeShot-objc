//
//  BLLikeShot.h
//  WeShot
//
//  Created by bo LI on 12/15/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLShot;
@class  BLUser;

@interface BLLikeShot : NSObject

@property (nonatomic, strong) BLShot* shot;
@property (nonatomic, strong) BLUser* user;

@end
