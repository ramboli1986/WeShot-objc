//
//  BLOAuthViewController.m
//  WeShot
//
//  Created by bo LI on 12/15/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import "BLOAuthViewController.h"
#import "BLDribbbleAPI.h"

#import <WebKit/WebKit.h>

@interface BLOAuthViewController ()

@property (weak, nonatomic) WKWebView *webView;
@property (weak, nonatomic) CALayer *progresslayer;

@end

@implementation BLOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarView];
    [self setupWKView];
}

- (void)setBarView{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenSize.width, 64)];
    view.backgroundColor = [UIColor lightGrayColor];
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, ScreenSize.width, 34)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Dribbble Sign in";
    titleLabel.textColor = [UIColor blackColor];
    [view addSubview:titleLabel];
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenSize.width - 70, 25, 60, 30)];
    [btn setTitle:@"Done" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    
    [self.view addSubview:view];
}
- (void)setupWKView{
    NSString* urlStr = [NSString stringWithFormat:@"%@?client_id=%@&scope=public+write", OAuth2_AuthorizationUrl, OAuth2_CLIENT_ID];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenSize.width, ScreenSize.height-64)];
    [self.view addSubview:webView];
    self.webView = webView;
    
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 3)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

#pragma mark - UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"%@", change);
        self.progresslayer.opacity = 1;
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue], 3);
        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
