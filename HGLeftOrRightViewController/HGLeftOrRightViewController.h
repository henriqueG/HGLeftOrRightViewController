//
//  HGLeftOrRightView.h
//  HGLeftOrRightViewController
//
//  Created by Henrique Galo on 9/17/15.
//  Copyright © 2015 Henrique Galo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGLeftOrRightViewController;
@class HGViewCell;

typedef NS_ENUM(NSUInteger , HGSwipe) {
    HGSwipeCenter = 0,
    HGSwipeLeft,
    HGSwipeRight,
};

@protocol HGViewDelegate <NSObject>
@required
- (void)viewCell:(HGViewCell*)viewCell didSwapItemtoSide:(HGSwipe)swipeSide;
- (void)viewCell:(HGViewCell *)viewCell willSwapItemtoSide:(HGSwipe)swipeSide;
- (void)viewCell:(HGViewCell*)viewCell isDraggingItemWithOffset:(CGPoint)offset;
@end

IB_DESIGNABLE
@interface HGViewCell : UIView

@property (nonatomic, retain) NSLayoutConstraint *centerX, *centerY;
@property (nonatomic, assign) id <HGViewDelegate> delegate;

@property (nonatomic,strong) IBOutlet UILabel *information, *dateAddedLabel, *confidenceLabel;
@property (nonatomic,strong) IBOutlet UIButton *leftButton, *rightButton;
- (IBAction)leftAction:(id)sender;
- (IBAction)rightAction:(id)sender;   

@property CGPoint originalCenter;
@property NSInteger cellIndex;

- (instancetype)init;
@end

@protocol HGLeftOrRightViewControllerDelegate <NSObject>
- (void)leftOrRightView:(HGLeftOrRightViewController*)lorView didSwapItemAtIndexPath:(NSIndexPath*)indexPath toSide:(HGSwipe)swipeSide;
- (void)leftOrRightView:(HGLeftOrRightViewController*)lorView isDraggingItemAtIndexPath:(NSIndexPath*)indexPath withOffset:(CGPoint)offset;
@end

@protocol HGLeftOrRightViewControllerDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInLeftOrRightView:(HGLeftOrRightViewController*)lorView;
- (HGViewCell*)leftOrRightView:(HGLeftOrRightViewController*)lorView cellForItemAtIndexPath:(NSIndexPath*)indexPath;
- (CGSize)cellSizeOfleftOrRightView:(HGLeftOrRightViewController*)lorView;
- (NSInteger)numberOfItemsToPreLoadInLeftOrRightView:(HGLeftOrRightViewController*)lorView;
@end

IB_DESIGNABLE
@interface HGLeftOrRightViewController : UIView <HGViewDelegate>

@property (nonatomic, assign) IBOutlet id <HGLeftOrRightViewControllerDelegate> delegate;
@property (nonatomic, assign, setter=setDataSource:) IBOutlet id <HGLeftOrRightViewControllerDataSource> dataSource;
@property (readonly) HGViewCell *firstViewCell;
- (HGViewCell *)backViewCellAtIndex:(NSInteger)index;

- (void)reloadData;
@end
