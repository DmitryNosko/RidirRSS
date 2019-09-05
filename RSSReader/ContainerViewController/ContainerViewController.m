//
//  ContainerViewController.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/29/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "ContainerViewController.h"
#import "MainViewController.h"
#import "MenuViewController.h"
#import "MainViewControllerDelegate.h"

@interface ContainerViewController () <MainViewControllerDelegate>
@property (strong, nonatomic) UIViewController* controller;
@property (strong, nonatomic) MainViewController* mainViewController;
@property (strong, nonatomic) MenuViewController* menuViewController;
@property (assign, nonatomic) BOOL isExpanded;
@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isExpanded = false;
    [self configurateMainViewController];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void) configurateMainViewController {
    self.mainViewController = [[MainViewController alloc] init];
    self.mainViewController.delegate = self;
    self.controller = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    [self.view addSubview:self.controller.view];
    [self addChildViewController:self.controller];
    [self.controller didMoveToParentViewController:self];
}

- (void) configerateMenuViewConstroller {
    if (self.menuViewController == nil) {
        self.menuViewController = [[MenuViewController alloc] init];
        [self.view insertSubview:self.menuViewController.view atIndex:0];
        [self addChildViewController:self.menuViewController];
        [self.menuViewController didMoveToParentViewController:self];
    }
}

- (void) showMenuController:(BOOL) shouldMove {
    if (shouldMove) {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.controller.view.frame = CGRectMake(self.controller.view.frame.size.width- 140, self.controller.view.frame.origin.y, self.controller.view.frame.size.width, self.controller.view.frame.size.height);
                         } completion:^(BOOL finished) {
                             
                         }];
    } else {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.controller.view.frame = CGRectMake(0, self.controller.view.frame.origin.y, self.controller.view.frame.size.width, self.controller.view.frame.size.height);
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)handleMenuToggle {
    
    if (!self.isExpanded) {
        [self configerateMenuViewConstroller];
    }
    
    self.isExpanded = !self.isExpanded;
    [self showMenuController:self.isExpanded];
    
}

@end
