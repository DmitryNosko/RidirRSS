//
//  MenuHeaderView.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/30/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "MenuHeaderView.h"

@implementation MenuHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUp];
        
    }
    return self;
}

- (void) addResource:(id) sender {
    if ([self.listener respondsToSelector:@selector(didTapOnAddResourceButton:)]) {
        [self.listener didTapOnAddResourceButton:self];
    }
}

- (void) setUp {
    
    self.addResourceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addResourceButton setTitle:@"Add new resource" forState:UIControlStateNormal];
    [self.addResourceButton setTitle:@"Added" forState:UIControlStateHighlighted];
    self.addResourceButton.backgroundColor = [UIColor darkGrayColor];
    [self.addResourceButton addTarget:self action:@selector(addResource:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.addResourceButton];
    
    self.addResourceButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.addResourceButton.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10],
                                              [self.addResourceButton.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
                                              [self.addResourceButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
                                              [self.addResourceButton.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10]
                                              ]];
    
}

@end
