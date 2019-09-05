//
//  MainTableViewCell.h
//  RSSReader
//
//  Created by Dzmitry Noska on 8/27/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTableViewCell;

@protocol MainTableViewCellListener <NSObject>
- (void) didTapOnInfoButton:(MainTableViewCell*) infoButton;
- (void) didTapOnFavoritesButton:(MainTableViewCell*) favoritesButton;
@end

@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) id<MainTableViewCellListener> listener;
@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UIButton* infoButton;
@property (strong, nonatomic) UIButton* descriptionButton;
@property (strong, nonatomic) UILabel* stateLabel;
@property (strong, nonatomic) UIButton* favoritesButton;
@property (assign, nonatomic) BOOL isNew;
@end

