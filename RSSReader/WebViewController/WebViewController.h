//
//  DetailsViewController.h
//  RSSReader
//
//  Created by Dzmitry Noska on 8/26/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"

@class WebViewController;

@protocol WebViewControllerListener <NSObject>
@property (strong, nonatomic) FeedItem* listenedItem;
- (void) didTapOnDoneButton:(UIBarButtonItem*) doneButton;
@end

@interface WebViewController : UIViewController
@property (weak, nonatomic) id<WebViewControllerListener> listener;
@property (strong, nonatomic) NSURL* newsURL;
@end

