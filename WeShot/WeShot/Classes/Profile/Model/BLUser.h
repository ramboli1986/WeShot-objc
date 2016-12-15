//
//  BLUser.h
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLUser : NSObject

@property (nonatomic, assign, getter=uid) NSInteger id;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* bio;
@property (nonatomic, strong) NSString* location;
@property (nonatomic, assign) NSInteger followers_count;
@property (nonatomic, assign) NSInteger followings_count;
@property (nonatomic, assign) NSInteger likes_count;
@property (nonatomic, assign) NSInteger shots_count;
@property (nonatomic, strong) NSString* shots_url;
@property (nonatomic, strong) NSString* likes_url;
@property (nonatomic, strong) NSString* avatar_url;

@end
