//
//  DetailsViewController.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/26/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "MainViewController.h"

@interface WebViewController () <WKNavigationDelegate>
@property (copy, nonatomic) NSString* url;
@property (strong, nonatomic) WKWebView* webView;
@property (strong, nonatomic) UIToolbar* toolBar;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLRequest* request = [NSURLRequest requestWithURL:self.newsURL];
    [self.webView loadRequest:request];
    [self configureNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - SetUp

- (void) setUp {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(setNewsAsReadedAction:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.webView = [[WKWebView alloc] init];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.webView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                                              [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                              [self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-50]
                                              ]];
    
    UIBarButtonItem* refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction)];
    UIBarButtonItem* stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopAction)];
    UIBarButtonItem* forwarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(forwardAction)];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    UIBarButtonItem* launchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(launchAction)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    self.toolBar = [[UIToolbar alloc] init];
    self.toolBar.items = @[forwarButton, flexibleSpace, refreshButton, flexibleSpace, stopButton, flexibleSpace, backButton, flexibleSpace, launchButton];
    [self.view addSubview:self.toolBar];
    self.toolBar.tintColor = [UIColor darkGrayColor];
    self.toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.toolBar.topAnchor constraintEqualToAnchor:self.webView.bottomAnchor],
                                              [self.toolBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                                              [self.toolBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                                              [self.toolBar.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
                                              ]];
    
}

- (void) setNewsAsReadedAction:(id)sender {
    if ([self.listener respondsToSelector:@selector(didTapOnDoneButton:)]) {
        [self.listener didTapOnDoneButton:self.navigationItem.rightBarButtonItem];
    }
}

- (void) configureNavigationBar {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.title = @"News";
}

- (void) refreshAction {
    [self.webView reload];
}

- (void) stopAction {
    [self.webView stopLoading];
}

- (void) forwardAction {
    [self.webView goForward];
}

- (void) backAction {
    [self.webView goBack];
}

- (void) launchAction {
    [[UIApplication sharedApplication] openURL:self.newsURL options:@{} completionHandler:nil];
}

@end
