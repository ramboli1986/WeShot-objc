//
//  BLDetailHeaderView.h
//  WeShot
//
//  Created by bo LI on 12/17/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DACircularProgressView;
@class YLImageView;

@interface BLDetailHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet YLImageView *GifImageView;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIButton *location;
@property (weak, nonatomic) IBOutlet UILabel *create_time_label;
//@property (weak, nonatomic) IBOutlet UIView *shotView;
@property (weak, nonatomic) IBOutlet UILabel *shotTitle;
@property (weak, nonatomic) IBOutlet UILabel *shotdetail;
@property (weak, nonatomic) IBOutlet UILabel *shotInfo;
@property (weak, nonatomic) IBOutlet UIImageView *shotImage;
@property (weak, nonatomic) IBOutlet DACircularProgressView *progressView;
@end
