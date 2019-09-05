//
//  MenuTableViewCell.h
//  RSSReader
//
//  Created by Dzmitry Noska on 8/29/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuTableViewCell;

@protocol MenuTableViewCellListener <NSObject>
- (void) didTapOnCheckBoxButton:(MenuTableViewCell*) checkBoxButton;
@end

@interface MenuTableViewCell : UITableViewCell
@property (weak, nonatomic) id<MenuTableViewCellListener> listener;
@property (strong, nonatomic) UILabel* newsLabel;
@property (strong, nonatomic) UIImageView* iconView;
@property (strong, nonatomic) UIButton* checkBoxButton;
@end
