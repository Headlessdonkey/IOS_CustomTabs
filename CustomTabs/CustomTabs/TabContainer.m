//
//  ViewController.m
//  CustomTabs
//
//  Created by James Logan on 3/15/14.
//  Copyright (c) 2014 James Logan. All rights reserved.
//

#import "TabContainer.h"
#import "HideShowTestViewController.h"

@interface TabContainer ()
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) UIViewController *hiddenViewController;
@end

@implementation TabContainer
{
    CGFloat firstX;
    CGFloat firstY;
    
    CGFloat startingY;
    
    float firstTabY;
    
    int _currentTabIndex;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self _setupTabViewControllers];
    
    [self _initializeHiddenViewController];
    
    [self _registerForNotifications];

}


- (void)_setupTabViewControllers
{
    _currentTabIndex = 0;
    
    self.viewControllers = [NSMutableArray array];
    
    for (int i = 0; i < 4; i++) {
        HideShowTestViewController *vc = [[HideShowTestViewController alloc] init];
        vc.backgroundColor = [UIColor colorWithRed:i/4.0 green:i/4 blue:i/4.0 alpha:1];
        [self.viewControllers addObject:vc];
    }
    
    UIViewController *firstVC = [self.viewControllers objectAtIndex:0];
    [self.contentView addSubview: [firstVC view]];
    [firstVC viewDidLoad];
}

- (void)_initializeHiddenViewController
{
    HideShowTestViewController *hiddenController = [[HideShowTestViewController alloc] init];
    hiddenController.backgroundColor = [UIColor greenColor];
    self.hiddenViewController = hiddenController;

    [self.hiddenView addSubview:[self.hiddenViewController view]];

    hiddenController.showButton.hidden = YES;
    hiddenController.hideButton.hidden = YES;
    hiddenController.extraLabel.text = @"Surprise! I am another ViewController";
    hiddenController.extraLabel.hidden = NO;
    
    [self.hiddenViewController viewDidLoad];
    [self.hiddenViewController viewWillAppear:YES];
    [self.hiddenViewController viewDidAppear:YES];
}

- (void)_registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_showExtraTab) name:SHOW_EXTRA_TAB object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_hideExtraTab) name:HIDE_EXTRA_TAB object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self.viewControllers objectAtIndex:_currentTabIndex] viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self.viewControllers objectAtIndex:_currentTabIndex] viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self.viewControllers objectAtIndex:_currentTabIndex] viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[self.viewControllers objectAtIndex:_currentTabIndex] viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tabSelected:(id)sender {
    
    [[[self.viewControllers objectAtIndex:_currentTabIndex] view] removeFromSuperview];
    [[self.viewControllers objectAtIndex:_currentTabIndex] viewWillDisappear:YES];
    [[self.viewControllers objectAtIndex:_currentTabIndex] viewDidDisappear:YES];
    
    _currentTabIndex = (int)[(UIView*)sender tag];
    
    UIViewController *currentViewcontroller = [self.viewControllers objectAtIndex:_currentTabIndex];
    
    [self.contentView addSubview:[currentViewcontroller view]];
    
//    [currentViewcontroller viewDidLoad];
    [currentViewcontroller viewWillAppear:YES];
    [currentViewcontroller viewDidAppear:YES];
}
- (IBAction)showButtonClicked:(id)sender {
    [self _showExtraTab];
}

- (IBAction)hideButtonClicked:(id)sender {
    [self _hideExtraTab];
}

- (IBAction)extraTabDragged:(id)sender {
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
        if (!startingY) {
            startingY = firstY;
        }
        firstTabY = self.rightTabParent.frame.origin.y;
    }

    translatedPoint = CGPointMake(firstX, firstY+translatedPoint.y);
    
    if (translatedPoint.y < startingY) {
        [[sender view] setCenter:translatedPoint];

    }
    
    
    float newRightY = self.view.frame.size.height - self.hiddenView.frame.origin.y  + firstTabY;
    
    self.hiddenView.frame = CGRectMake(self.hiddenView.frame.origin.x, [sender view].frame.origin.y + [sender view].frame.size.height, self.hiddenView.frame.size.width, self.hiddenView.frame.size.height);
    
    self.hiddenTabs.frame = CGRectMake(self.hiddenTabs.frame.origin.x, [sender view].frame.origin.y, self.hiddenTabs.frame.size.width, self.hiddenTabs.frame.size.height);

    self.leftTabParent.frame = CGRectMake(self.leftTabParent.frame.origin.x, newRightY, self.leftTabParent.frame.size.height, self.leftTabParent.frame.size.width);

    self.rightTabParent.frame = CGRectMake(self.rightTabParent.frame.origin.x, newRightY , self.rightTabParent.frame.size.height, self.rightTabParent.frame.size.width);
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        CGFloat finalYWithMomentum = translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        
        float finalY = self.view.frame.size.height - self.extraTab.frame.size.height;
        if (finalYWithMomentum < self.view.frame.size.height * .5) {
            finalY = 0.0;
        }
        
        [UIView animateWithDuration:.2 animations:^{
            CGRect newFrame = self.extraTab.frame;
            newFrame.origin.y = finalY;
            self.extraTab.frame = newFrame;
            
            self.hiddenView.frame = CGRectMake(self.hiddenView.frame.origin.x, [sender view].frame.origin.y + [sender view].frame.size.height, self.hiddenView.frame.size.width, self.hiddenView.frame.size.height);
            
            self.hiddenTabs.frame = CGRectMake(self.hiddenTabs.frame.origin.x, [sender view].frame.origin.y, self.hiddenTabs.frame.size.width, self.hiddenTabs.frame.size.height);
            
            self.rightTabParent.frame = CGRectMake(self.rightTabParent.frame.origin.x, firstTabY , self.rightTabParent.frame.size.height, self.rightTabParent.frame.size.width);
            
            self.leftTabParent.frame = CGRectMake(self.leftTabParent.frame.origin.x, firstTabY, self.leftTabParent.frame.size.height, self.leftTabParent.frame.size.width);
            
            
        } completion:^(BOOL finished) {
            
        }];
        
//        [UIView animateWithDuration:.25
//                              delay:0.0
//                            options:UIViewAnimationOptionCurveEaseOut
//                         animations:^{
//                             CGRect newFrame = self.extraTab.frame;
//                             newFrame.origin.y = finalY;
//                             self.extraTab.frame = newFrame;
//                             
//                             self.hiddenView.frame = CGRectMake(self.hiddenView.frame.origin.x, [sender view].frame.origin.y + [sender view].frame.size.height, self.hiddenView.frame.size.width, self.hiddenView.frame.size.height);
//                             
//                             self.hiddenTabs.frame = CGRectMake(self.hiddenTabs.frame.origin.x, [sender view].frame.origin.y, self.hiddenTabs.frame.size.width, self.hiddenTabs.frame.size.height);
//                             
//                             self.rightTabParent.frame = CGRectMake(self.rightTabParent.frame.origin.x, firstTabY , self.rightTabParent.frame.size.height, self.rightTabParent.frame.size.width);
//                             
//                             self.leftTabParent.frame = CGRectMake(self.leftTabParent.frame.origin.x, firstTabY, self.leftTabParent.frame.size.height, self.leftTabParent.frame.size.width);
//                         } completion:^(BOOL finished) {
//                             
//                         }];
    }
}

#pragma mark tab animtaion methods

- (void)_showExtraTab
{
    if (self.extraTab.frame.origin.y >= self.view.frame.size.height) {
        [UIView animateWithDuration:.5 animations:^{
            CGRect newFrame = self.extraTab.frame;
            newFrame.origin.y = newFrame.origin.y - newFrame.size.height;
            self.extraTab.frame = newFrame;
            
            CGRect newleftTabFrame = self.leftTabParent.frame;
            newleftTabFrame.origin.x = newleftTabFrame.origin.x - newFrame.size.width/4;
            self.leftTabParent.frame = newleftTabFrame;
            
            CGRect newRightTabFrame = self.rightTabParent.frame;
            newRightTabFrame.origin.x = newRightTabFrame.origin.x + newFrame.size.width/4;
            self.rightTabParent.frame = newRightTabFrame;
            
        } completion:^(BOOL finished) {
            
        }];
    }

}

- (void)_hideExtraTab
{
    if (self.extraTab.frame.origin.y + 3 <= self.view.frame.size.height) {
        [UIView animateWithDuration:.5 animations:^{
            CGRect newFrame = self.extraTab.frame;
            newFrame.origin.y = newFrame.origin.y + newFrame.size.height;
            self.extraTab.frame = newFrame;
            
            CGRect newleftTabFrame = self.leftTabParent.frame;
            newleftTabFrame.origin.x = newleftTabFrame.origin.x + newFrame.size.width/4;
            self.leftTabParent.frame = newleftTabFrame;
            
            CGRect newRightTabFrame = self.rightTabParent.frame;
            newRightTabFrame.origin.x = newRightTabFrame.origin.x - newFrame.size.width/4;
            self.rightTabParent.frame = newRightTabFrame;
            
        } completion:^(BOOL finished) {
            
        }];
    }

}

@end
