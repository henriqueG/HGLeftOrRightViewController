//
//  ViewController.m
//  HGLeftOrRightViewController
//
//  Created by Henrique Galo on 9/17/15.
//  Copyright © 2015 Henrique Galo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSArray *content;
}
@end

@implementation ViewController

- (void)awakeFromNib {
    content = @[@"test", @"test2", @"test3", @"test4"];
}

- (NSInteger)numberOfItemsInLeftOrRightView:(HGLeftOrRightViewController*)lorView {
    return [content count];
}

- (HGViewCell*)leftOrRightView:(HGLeftOrRightViewController*)lorView cellForItemAtIndexPath:(NSIndexPath*)indexPath {
    HGViewCell *viewCell = [[HGViewCell alloc] init];

    viewCell.information.text = [content objectAtIndex:[indexPath item]];
    
    return viewCell;
}

- (CGSize)cellSizeOfleftOrRightView:(HGLeftOrRightViewController*)lorView {
    return CGSizeMake(150, 400);
}

- (NSInteger)numberOfItemsToPreLoadInLeftOrRightView:(HGLeftOrRightViewController*)lorView {
    return 2;
}

- (void)leftOrRightView:(HGLeftOrRightViewController*)lorView didSwapItemAtIndexPath:(NSIndexPath*)indexPath toSide:(HGSwipe)swipeSide {
    NSLog(@"SIDE %d", swipeSide);
}

- (void)leftOrRightView:(HGLeftOrRightViewController *)lorView isDraggingItemAtIndexPath:(NSIndexPath *)indexPath withOffset:(CGPoint)offset {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
