//
//  UIBarButtonItem+BLExtension.h
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (BLExtension)
+ (instancetype)itemWithImage:(NSString *)image target:(id)target action:(SEL)action;
@end
