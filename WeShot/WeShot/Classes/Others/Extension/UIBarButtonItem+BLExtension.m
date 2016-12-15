//
//  UIBarButtonItem+BLExtension.m
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "UIBarButtonItem+BLExtension.h"

@implementation UIBarButtonItem (BLExtension)

+ (instancetype)itemWithImage:(NSString *)image target:(id)target action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];

    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

@end
