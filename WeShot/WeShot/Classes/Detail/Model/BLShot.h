//
//  BLShot.h
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUser.h"

@interface BLShot : NSObject

@property (nonatomic, assign, getter=sid) NSInteger id;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) NSDictionary* images;
@property (nonatomic, assign) NSInteger views_count;
@property (nonatomic, assign) NSInteger likes_count;
@property (nonatomic, assign) NSInteger comments_count;
@property (nonatomic, strong) NSString* created_at;
@property (nonatomic, strong) NSString* comments_url;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, strong) BLUser* user;

@end
