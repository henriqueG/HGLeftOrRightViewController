//
//  HGLeftOrRightView.m
//  HGLeftOrRightViewController
//
//  Created by Henrique Galo on 9/17/15.
//  Copyright © 2015 Henrique Galo. All rights reserved.
//

#import "HGLeftOrRightViewController.h"

@interface HGViewCell ()
{
    UIPanGestureRecognizer *panGestureRecognizer;
}
@end

@implementation HGViewCell
@synthesize originalCenter;

- (instancetype)init {
    NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"HGViewCell" owner:self options:nil];
    
    if ([arrayOfViews count] < 1) {
        return nil;
    }
    
    if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UIView class]]) {
        return nil;
    }
    
    self = [arrayOfViews objectAtIndex:0];
    
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(draggingCard:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    return self;
}

- (void)awakeFromNib {
    
}

-(void)draggingCard:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat xFromCenter = [gestureRecognizer translationInView:self].x;
    CGFloat yFromCenter = [gestureRecognizer translationInView:self].y;
    
    switch (gestureRecognizer.state) {
        
        case UIGestureRecognizerStateBegan:{
            originalCenter = CGPointMake(self.centerX.constant, self.centerY.constant);
            break;
        };
        
        case UIGestureRecognizerStateChanged:{
            self.centerX.constant = originalCenter.x + xFromCenter;
            self.centerY.constant = originalCenter.y + yFromCenter;
            
            [self.delegate viewCell:self isDraggingItemWithOffset:CGPointMake(xFromCenter, yFromCenter)];

            break;
        };
        
        case UIGestureRecognizerStateEnded: {
            [self endDragging:xFromCenter];
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

- (IBAction)leftAction:(id)sender {
    CGFloat screenSize = self.superview.frame.size.width;
    CGFloat margin = screenSize / 3;

    [self endDragging:(-margin - 1)];
}

- (IBAction)rightAction:(id)sender {
    CGFloat screenSize = self.superview.frame.size.width;
    CGFloat margin = screenSize / 3;
    
    [self endDragging:(margin + 1)];
}

- (void)endDragging:(CGFloat)xPos {
    HGSwipe slideSide = HGSwipeCenter;
    
    CGFloat screenSize = self.superview.frame.size.width;
    CGFloat margin = screenSize / 3;
    
    [self.superview layoutIfNeeded];
    
    if (xPos > margin) { //right
        self.centerX.constant = self.superview.frame.size.width + self.frame.size.width;
        self.centerY.constant = originalCenter.y;
        slideSide = HGSwipeRight;
    }
    else if (xPos < -margin) { //left
        self.centerX.constant = -(self.superview.frame.size.width + self.frame.size.width);
        self.centerY.constant = originalCenter.y;
        slideSide = HGSwipeLeft;
    }
    else { //center
        self.centerX.constant = originalCenter.x;
        self.centerY.constant = originalCenter.y;
    }

    [self.delegate viewCell:self willSwapItemtoSide:slideSide];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.delegate viewCell:self isDraggingItemWithOffset:CGPointMake(originalCenter.x, originalCenter.y)];

        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.delegate viewCell:self didSwapItemtoSide:slideSide];

            if (slideSide != HGSwipeCenter) {
                [self removeFromSuperview];
            }
        }
    }];
}

@end


@interface HGLeftOrRightViewController()
{
    NSMutableArray *presentedCells;
    NSInteger currentLoadedIndex, numberOfItems, numberOfPreload;
}
@end

@implementation HGLeftOrRightViewController

- (void)awakeFromNib {
    [self setTranslatesAutoresizingMaskIntoConstraints:FALSE];
}

- (void)setDataSource:(id<HGLeftOrRightViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    
    presentedCells = [[NSMutableArray alloc] init];
    currentLoadedIndex = numberOfItems = numberOfPreload = 0;
    
    [self reloadData];
}

- (void)reloadData {
    numberOfItems = [self.dataSource numberOfItemsInLeftOrRightView:self];
    numberOfPreload = [self.dataSource numberOfItemsToPreLoadInLeftOrRightView:self];
    currentLoadedIndex = 0;
    
    [self removeAllPresentedCards];
    
    if (numberOfItems > 0) {
        if (numberOfPreload > numberOfItems) {
            NSLog(@"The number of preload cells is higher than the number of items. HGLeftOrRightViewController (%@) will assume that the number of preload is the same as the number of items. This behavior may change in future versions.", self);
            numberOfPreload = numberOfItems;
        }
        
        for (NSInteger i = 0; i < numberOfPreload; i++) {
            [self loadItemWithPreloadIndex:i];
        }
    }
}

- (void)removeAllPresentedCards {
    for (HGViewCell *cell in presentedCells) {
        [cell removeFromSuperview];
    }
    
    [presentedCells removeAllObjects];
}

- (void)loadItemWithPreloadIndex:(NSInteger)indexPreload {
    HGViewCell *viewCell = [self.dataSource leftOrRightView:self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentLoadedIndex inSection:0]];
    
    viewCell.tag = currentLoadedIndex;
    viewCell.delegate = self;
    [viewCell setTranslatesAutoresizingMaskIntoConstraints:FALSE];
    
    CGSize cellSize = [self.dataSource cellSizeOfleftOrRightView:self];
    
    if (indexPreload == 0) {
        [self addSubview:viewCell];
        [presentedCells addObject:viewCell];
    }
    else {
        [self insertSubview:viewCell belowSubview:[presentedCells objectAtIndex:indexPreload - 1]];
        [presentedCells insertObject:viewCell atIndex:indexPreload];
    }

    //Constraints to load in the middle
    viewCell.centerX = [NSLayoutConstraint constraintWithItem:viewCell attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self addConstraint:viewCell.centerX];
    
    viewCell.centerY = [NSLayoutConstraint constraintWithItem:viewCell attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self addConstraint:viewCell.centerY];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:viewCell attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:cellSize.width]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:viewCell attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:cellSize.height]];
    
    currentLoadedIndex++;
}

- (void)viewCell:(HGViewCell*)viewCell didSwapItemtoSide:(HGSwipe)swipeSide  {
    if (swipeSide != HGSwipeCenter) {
        [self.delegate leftOrRightView:self didSwapItemAtIndexPath:[NSIndexPath indexPathForItem:(viewCell.tag) inSection:0] toSide:swipeSide];
    }
}

- (void)viewCell:(HGViewCell *)viewCell isDraggingItemWithOffset:(CGPoint)offset {
    [self.delegate leftOrRightView:self isDraggingItemAtIndexPath:[NSIndexPath indexPathForItem:(viewCell.tag) inSection:0] withOffset:offset];
}

- (void)viewCell:(HGViewCell *)viewCell willSwapItemtoSide:(HGSwipe)swipeSide {
    if (swipeSide != HGSwipeCenter) {
        if (currentLoadedIndex < numberOfItems) {
            [presentedCells removeObjectAtIndex:0];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self backViewCellAtIndex:(numberOfPreload - 1)] == nil) {
                    [self loadItemWithPreloadIndex:(numberOfPreload - 1)];
                }
            });
        }
    }
}

- (HGViewCell *)firstViewCell {
    return (HGViewCell*)[presentedCells firstObject];
}

- (HGViewCell *)backViewCellAtIndex:(NSInteger)index {
    return ([presentedCells count] > index && numberOfPreload > index) ? (HGViewCell*)[presentedCells objectAtIndex:index]:nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

