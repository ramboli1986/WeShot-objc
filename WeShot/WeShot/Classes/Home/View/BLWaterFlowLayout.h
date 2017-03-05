//
//  BLWaterFlowLayout.h
//  WeShot
//
//  Created by bo LI on 12/13/16.
//  Copyright © 2016 Bo LI. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLWaterFlowLayout;

@protocol BLWaterFlowLayoutDelegate <NSObject>
@required
- (CGFloat)waterflowLayout:(BLWaterFlowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (CGFloat)columnCountInWaterflowLayout:(BLWaterFlowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(BLWaterFlowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(BLWaterFlowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(BLWaterFlowLayout *)waterflowLayout;
@end

@interface BLWaterFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) id<BLWaterFlowLayoutDelegate> delegate;
@end
