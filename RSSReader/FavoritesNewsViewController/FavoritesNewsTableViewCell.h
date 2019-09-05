//
//  FavoritesNewsTableViewCell.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/3/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavoritesNewsTableViewCell;

@protocol FavoritesNewsTableViewCellListener <NSObject>
- (void) didTapOnInfoButton:(FavoritesNewsTableViewCell*) infoButton;
- (void) didTapOnInfoDescriptionButton:(FavoritesNewsTableViewCell*) descriptionButton;
@end

@interface FavoritesNewsTableViewCell : UITableViewCell
@property (weak, nonatomic) id<FavoritesNewsTableViewCellListener> listener;
@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UIButton* infoButton;
@property (strong, nonatomic) UIButton* descriptionButton;
@end
