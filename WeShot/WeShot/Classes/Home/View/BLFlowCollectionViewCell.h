//
//  BLFlowCollectionViewCell.h
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLFlowCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *shotImage;
@property (weak, nonatomic) IBOutlet UILabel *shotTitle;
@property (weak, nonatomic) IBOutlet UILabel *shotDetail;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatorImage;

@end
