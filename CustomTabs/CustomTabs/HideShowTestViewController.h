//
//  HideShowTestViewController.h
//  CustomTabs
//
//  Created by James Logan on 3/15/14.
//  Copyright (c) 2014 James Logan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HideShowTestViewController : UIViewController

@property (nonatomic, strong) UIColor *backgroundColor;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UIButton *hideButton;
@property (weak, nonatomic) IBOutlet UILabel *extraLabel;


- (IBAction)showButtonClicked:(id)sender;
- (IBAction)hideButtonClicked:(id)sender;

@end
