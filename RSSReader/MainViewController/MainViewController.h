//
//  MainViewController.h
//  RSSReader
//
//  Created by Dzmitry Noska on 8/26/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewControllerDelegate.h"

@interface MainViewController : UIViewController
@property (weak, nonatomic) id<MainViewControllerDelegate> delegate;
@end

