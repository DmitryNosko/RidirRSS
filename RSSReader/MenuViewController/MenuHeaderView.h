//
//  MenuHeaderView.h
//  RSSReader
//
//  Created by Dzmitry Noska on 8/30/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuHeaderView;

@protocol MenuHeaderViewListener <NSObject>
- (void) didTapOnAddResourceButton:(MenuHeaderView*) addResourceButton;
@end

@interface MenuHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) id<MenuHeaderViewListener> listener;
@property (strong, nonatomic) UIButton* addResourceButton;
@end

