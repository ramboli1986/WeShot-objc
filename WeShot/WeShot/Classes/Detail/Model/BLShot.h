//
//  BLShot.h
//  WeShot
//
//  Created by bo LI on 12/14/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUser.h"
#import "BLShotPicture.h"
@interface BLShot : NSObject

@property (nonatomic, assign) NSInteger sid;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* detailContent;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) BLShotPicture* images;
@property (nonatomic, assign) NSInteger views_count;
@property (nonatomic, assign) NSInteger likes_count;
@property (nonatomic, assign) NSInteger comments_count;
@property (nonatomic, copy) NSString* created_at;
@property (nonatomic, copy) NSString* comments_url;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, strong) BLUser* user;


//additonal property
@property (nonatomic, assign, readonly) CGFloat homeCellHeight;
@property (nonatomic, assign, readonly) CGFloat detailCellHeight;
@end
