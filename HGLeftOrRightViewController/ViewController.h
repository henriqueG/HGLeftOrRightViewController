//
//  ViewController.h
//  HGLeftOrRightViewController
//
//  Created by Henrique Galo on 9/17/15.
//  Copyright © 2015 Henrique Galo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGLeftOrRightViewController.h"

@interface ViewController : UIViewController <HGLeftOrRightViewControllerDataSource, HGLeftOrRightViewControllerDelegate>

@property (nonatomic, retain) IBOutlet HGLeftOrRightViewController *hglorView;

@end

