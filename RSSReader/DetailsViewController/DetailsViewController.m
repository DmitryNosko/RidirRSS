//
//  DetailsViewController.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/27/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UILabel* itemTitel;
@property (strong, nonatomic) UIImageView* itemImage;
@property (strong, nonatomic) UILabel* itemDescription;
@property (strong, nonatomic) UILabel* itemDate;
@property (strong, nonatomic) NSData* imageData;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"About news";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUp:self.hasInternetConnection];
    [self configureNavigationBar];
    
    if (![self.itemURLString isEqualToString:@""]) {
        NSThread* thread = [[NSThread alloc] initWithBlock:^{
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.itemURLString]];
            if (imageData) {
                self.imageData = imageData;
                [self performSelectorOnMainThread:@selector(execute) withObject:nil waitUntilDone:NO];
            }
        }];
        [thread start];
    }
}

- (void) execute {
    self.itemImage.image = [UIImage imageWithData:self.imageData];
}

- (void) setUp:(BOOL) hasInternetConnection {
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
                                              ]];
    
    self.itemTitel = [[UILabel alloc] init];
    self.itemTitel.textAlignment = NSTextAlignmentLeft;
    self.itemTitel.numberOfLines = 0;
    self.itemTitel.text = [NSString stringWithFormat:@"News: %@", self.itemTitleString];
    [self.scrollView addSubview:self.itemTitel];
    
    self.itemTitel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.itemTitel.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:10],
                                              [self.itemTitel.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:10],
                                              [self.itemTitel.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-10],
                                              [self.itemTitel.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
                                              ]];
    
    if (hasInternetConnection) {
        
        
        self.itemImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noPhoto"]];
        [self.scrollView addSubview:self.itemImage];
        
        self.itemImage.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.itemImage.topAnchor constraintEqualToAnchor:self.itemTitel.bottomAnchor constant:15],
                                                  [self.itemImage.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:10],
                                                  [self.itemImage.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-10],
                                                  [self.itemImage.heightAnchor constraintEqualToConstant:CGRectGetWidth(self.view.bounds)],
                                                  [self.itemImage.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
                                                  ]];
        
        self.itemDate = [[UILabel alloc] init];
        self.itemDate.textAlignment = NSTextAlignmentCenter;
        self.itemDate.numberOfLines = 0;
        self.itemDate.text = [NSString stringWithFormat:@"Publication date: %@", self.itemDateString];
        [self.itemDate setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [self.scrollView addSubview:self.itemDate];
        
        self.itemDate.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.itemDate.topAnchor constraintEqualToAnchor:self.itemImage.bottomAnchor constant:5],
                                                  [self.itemDate.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:10],
                                                  [self.itemDate.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-10],
                                                  [self.itemDate.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
                                                  ]];
        
        
        self.itemDescription = [[UILabel alloc] init];
        self.itemDescription.textAlignment = NSTextAlignmentCenter;
        self.itemDescription.numberOfLines = 0;
        self.itemDescription.text = [NSString stringWithFormat:@"Description: %@", self.itemDescriptionString];
        [self.itemDescription setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [self.scrollView addSubview:self.itemDescription];
        
        self.itemDescription.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.itemDescription.topAnchor constraintEqualToAnchor:self.itemDate.bottomAnchor constant:25],
                                                  [self.itemDescription.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:10],
                                                  [self.itemDescription.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-10],
                                                  [self.itemDescription.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
                                                  [self.itemDescription.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
                                                  ]];
    } else {
        self.itemDescription = [[UILabel alloc] init];
        self.itemDescription.textAlignment = NSTextAlignmentCenter;
        self.itemDescription.numberOfLines = 0;
        self.itemDescription.text = [NSString stringWithFormat:@"Description: %@", self.itemDescriptionString];
        [self.itemDescription setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [self.scrollView addSubview:self.itemDescription];
        
        self.itemDescription.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
                                                  [self.itemDescription.topAnchor constraintEqualToAnchor:self.itemTitel.bottomAnchor constant:30],
                                                  [self.itemDescription.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:10],
                                                  [self.itemDescription.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-10],
                                                  [self.itemDescription.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor]
                                                  ]];
    }
    
}

- (void) configureNavigationBar {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"News details";
}



@end
