//
//  UITextView+NoFirstResponder.m
//  WeShot
//
//  Created by bo LI on 3/10/17.
//  Copyright © 2017 Bo LI. All rights reserved.
//

#import "UITextView+NoFirstResponder.h"

@implementation UITextView (NoFirstResponder)
- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        
        @try {
            id targetAndAction = ((NSMutableArray *)[gestureRecognizer valueForKey:@"_targets"]).firstObject;
            NSArray <NSString *>*actions = @[@"action=loupeGesture:",           // link: no, selection: shows circle loupe and blue selectors for a second
                                             @"action=longDelayRecognizer:",    // link: no, selection: no
                                             /*@"action=smallDelayRecognizer:", // link: yes (no long press), selection: no*/
                                             @"action=oneFingerForcePan:",      // link: no, selection: shows rectangular loupe for a second, no blue selectors
                                             @"action=_handleRevealGesture:"];  // link: no, selection: no
            for (NSString *action in actions) {
                if ([[targetAndAction description] containsString:action]) {
                    [gestureRecognizer setEnabled:false];
                }
            }
            
        }
        
        @catch (NSException *e) {
        }
        
        @finally {
            [super addGestureRecognizer: gestureRecognizer];
        }
    }
}
@end
