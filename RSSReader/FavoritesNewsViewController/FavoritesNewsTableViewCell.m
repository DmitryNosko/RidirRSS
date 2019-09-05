//
//  FavoritesNewsTableViewCell.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/3/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FavoritesNewsTableViewCell.h"

@implementation FavoritesNewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
        
        [self.infoButton addTarget:self action:@selector(pushToInfoButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.infoButton];
        
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

- (void) setUp {
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 0;
    
    [self.contentView addSubview:self.titleLabel];
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10],
                                              [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
                                              [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-80],
                                              [self.titleLabel.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
                                              [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10]
                                              ]];
    
    
    self.infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [self.contentView addSubview:self.infoButton];
    
    self.infoButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.infoButton.leadingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor constant:20],
                                              [self.infoButton.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
                                              [self.infoButton.heightAnchor constraintEqualToConstant:35],
                                              [self.infoButton.widthAnchor constraintEqualToConstant:35]
                                              ]];
    
}

@end
