//
//  HideShowTestViewController.m
//  CustomTabs
//
//  Created by James Logan on 3/15/14.
//  Copyright (c) 2014 James Logan. All rights reserved.
//

#import "HideShowTestViewController.h"
#import "TabContainer.h"

@interface HideShowTestViewController ()

@end

@implementation HideShowTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.backgroundColor) {
        self.view.backgroundColor = self.backgroundColor;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_EXTRA_TAB object:nil];
}

- (IBAction)hideButtonClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_EXTRA_TAB object:nil];
}
@end
