//
//  BLFlowViewController.h
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BLFlowVCTypeFollow = 1,
    BLFlowVCTypePopular = 0
}BLWaterType;

@interface BLFlowViewController : UIViewController

@property (nonatomic, assign) BLWaterType type;

- (void)refreshView;
@end
