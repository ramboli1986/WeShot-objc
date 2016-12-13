//
//  UIView+BLExtension.m
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "UIView+BLExtension.h"

@implementation UIView (BLExtension)
- (void) setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame  = frame;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame  = frame;
}

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame  = frame;
}
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame  = frame;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGSize) size {
    return self.frame.size;
}

- (CGFloat) width {
    return self.frame.size.width;
}

- (CGFloat) height {
    return self.frame.size.height;
}

- (CGFloat) x {
    return self.center.x;
}

- (CGFloat) y {
    return self.center.y;
}

- (CGFloat) centerX {
    return self.center.x;
}

- (CGFloat) centerY {
    return self.center.y;
}

@end
