//
//  BLAcountTool.m
//  WeShot
//
//  Created by bo LI on 12/16/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLAcountTool.h"
#import "BLMainTabBarController.h"
#import "BLUser.h"
#import "BLHttpTool.h"
#import "BLShotsParams.h"
#import "BLLoginViewController.h"

#import <MJExtension.h>
#import <WebKit/WebKit.h>

//#import "AppDelegate.h"

#define ACCESS_TOKEN_KEY @"accessToken"
@implementation BLAcountTool

static NSString* _accessToken;
static BLUser* _user;

+ (void)saveAcount:(NSString *)token {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:ACCESS_TOKEN_KEY];
    [defaults synchronize];
}

+ (NSString *)access_Token {
    if (_accessToken == nil) {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        _accessToken = [defaults objectForKey:ACCESS_TOKEN_KEY];
    }
    return _accessToken;
}

+ (void)deleteToken {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:ACCESS_TOKEN_KEY];
    [defaults synchronize];
}

+ (void)logout{
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                               modifiedSince:dateFrom completionHandler:^{
                                                   // code
                                                   [[UIApplication sharedApplication] keyWindow].rootViewController = [[BLLoginViewController alloc]init];
                                               }];
}

+ (void)homeRootViewController:(UIWindow *)window{
    BLMainTabBarController* vc = [[BLMainTabBarController alloc]init];
    window.rootViewController = vc;
    [window makeKeyAndVisible];
}
@end
