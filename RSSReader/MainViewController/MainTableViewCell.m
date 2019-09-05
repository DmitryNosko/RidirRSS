//
//  MainTableViewCell.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/27/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
        
        [self.infoButton addTarget:self action:@selector(pushToInfoButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.infoButton];
        
        [self.favoritesButton addTarget:self action:@selector(pushToFavoritesButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.favoritesButton];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) pushToInfoButton:(id)sender {
    if ([self.listener respondsToSelector:@selector(didTapOnInfoButton:)]) {
        [self.listener didTapOnInfoButton:self];
    }
}

- (void) pushToFavoritesButton:(id)sender {
    if ([self.listener respondsToSelector:@selector(didTapOnFavoritesButton:)]) {
        [self.listener didTapOnFavoritesButton:self];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.stateLabel.text = @"new";
    [self.favoritesButton setImage:[UIImage imageNamed:@"clearStar"] forState:UIControlStateNormal];
}

- (void) setUp {
    
    self.favoritesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.favoritesButton setImage:[UIImage imageNamed:@"clearStar"] forState:UIControlStateNormal];
    self.favoritesButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //    [self.favoritesButton setImage:[UIImage imageNamed:@"fullStar"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.favoritesButton];
    
    self.favoritesButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.favoritesButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
                                              [self.favoritesButton.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
                                              [self.favoritesButton.heightAnchor constraintEqualToConstant:15],
                                              [self.favoritesButton.widthAnchor constraintEqualToConstant:15]
                                              ]];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.titleLabel];
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10],
                                              [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.favoritesButton.trailingAnchor constant:10],
                                              [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-80],
                                              [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
                                              [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10]
                                              ]];
    
    
    
    
    self.infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [self.contentView addSubview:self.infoButton];
    
    self.infoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.infoButton.leadingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor constant:20],
                                              [self.infoButton.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
                                              [self.infoButton.heightAnchor constraintEqualToConstant:40],
                                              [self.infoButton.widthAnchor constraintEqualToConstant:40]
                                              ]];
    
    self.stateLabel = [[UILabel alloc] init];
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    [self.stateLabel setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    self.stateLabel.backgroundColor = [UIColor clearColor];
    self.stateLabel.text = @"new";
    [self.contentView addSubview:self.stateLabel];
    
    self.stateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.stateLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:3],
                                              [self.stateLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-5],
                                              [self.stateLabel.heightAnchor constraintEqualToConstant:12]
                                              ]];
}

@end
