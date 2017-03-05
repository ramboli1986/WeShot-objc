//
//  BLGridViewController.h
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    BLGridVCTypeRecent = 0,
    BLGridVCTypeTeams = 1,
    BLGridVCTypeDebuts = 2,
    BLGridVCTypePlayoffs = 3
}BLGridVCType;
@interface BLGridViewController : UIViewController

@property (nonatomic, assign) BLGridVCType type;

- (void)refreshView;

@end
