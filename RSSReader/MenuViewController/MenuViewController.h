//
//  MenuViewController.h
//  RSSReader
//
//  Created by Dzmitry Noska on 8/29/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const MenuViewControllerFeedResourceWasAddedNotification;
extern NSString* const MenuViewControllerFeedResourceWasChosenNotification;
extern NSString* const MenuViewControllerFetchButtonWasPressedNotification;

@interface MenuViewController : UIViewController
@property (strong, nonatomic) UIButton* fetchButton;
@end


