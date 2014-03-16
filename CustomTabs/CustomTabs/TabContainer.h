//
//  ViewController.h
//  CustomTabs
//
//  Created by James Logan on 3/15/14.
//  Copyright (c) 2014 James Logan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SHOW_EXTRA_TAB @"SHOW_EXTRA_TAB"
#define HIDE_EXTRA_TAB @"HIDE_EXTRA_TAB"

@interface TabContainer : UIViewController
@property (weak, nonatomic) IBOutlet UIView *extraTab;
@property (weak, nonatomic) IBOutlet UIButton *hideButtonClicked;
@property (weak, nonatomic) IBOutlet UIView *leftTabParent;
@property (weak, nonatomic) IBOutlet UIView *rightTabParent;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *extraTabPanRecognizer;
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
@property (weak, nonatomic) IBOutlet UIView *hiddenTabs;
@property (weak, nonatomic) IBOutlet UIView *contentView;

- (IBAction)tabSelected:(id)sender;
- (IBAction)showButtonClicked:(id)sender;
- (IBAction)hideButtonClicked:(id)sender;
- (IBAction)extraTabDragged:(id)sender;

@end
