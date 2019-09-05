//
//  DetailsViewController.h
//  RSSReader
//
//  Created by Dzmitry Noska on 8/27/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) NSString* itemTitleString;
@property (strong, nonatomic) NSString* itemDescriptionString;
@property (strong, nonatomic) NSString* itemURLString;
@property (strong, nonatomic) NSString* itemDateString;
@property (assign, nonatomic) BOOL hasInternetConnection;
@end

