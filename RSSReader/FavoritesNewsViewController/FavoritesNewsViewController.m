//
//  FavoritesNewsViewController.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/3/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FavoritesNewsViewController.h"
#import "FavoritesNewsTableViewCell.h"
#import "DetailsViewController.h"
#import "WebViewController.h"
#import "FileManager.h"
#import "ReachabilityStatusChecker.h"

@interface FavoritesNewsViewController () <UITableViewDelegate, UITableViewDataSource, FavoritesNewsTableViewCellListener>
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray<FeedItem *>* feeds;
@end

static NSString* CELL_IDENTIFIER = @"Cell";
static NSString* FAVORITES_NEWS_FILE_NIME = @"favoritiesNews.txt";
static NSString* PATTERN_FOR_VALIDATION = @"<\/?[A-Za-z]+[^>]*>";

@implementation FavoritesNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableViewSetUp];
    [self configureNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.feeds = [[FileManager sharedFileManager] readFeedItemsFile:FAVORITES_NEWS_FILE_NIME];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FavoritesNewsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.listener = self;
    cell.titleLabel.text = [self.feeds objectAtIndex:indexPath.row].itemTitle;
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([ReachabilityStatusChecker hasInternerConnection]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        WebViewController* dvc = [[WebViewController alloc] init];
        NSString* string = [self.feeds objectAtIndex:indexPath.row].link;
        NSString *stringForURL = [string substringWithRange:NSMakeRange(0, [string length]-6)];
        NSURL* url = [NSURL URLWithString:stringForURL];
        dvc.newsURL = url;
        [self.navigationController pushViewController:dvc animated:YES];
    } else {
        [self showNotInternerConnectionAlert];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        FeedItem* item = [self.feeds objectAtIndex:indexPath.row];
        [[FileManager sharedFileManager] removeFeedItem:item fromFile:FAVORITES_NEWS_FILE_NIME];
        [self.feeds removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView reloadData];
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

#pragma mark - FavoritesNewsTableViewCellListener

- (void)didTapOnInfoButton:(FavoritesNewsTableViewCell *)infoButton {
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:infoButton];
    FeedItem* item = [self.feeds objectAtIndex:indexPath.row];
    
    DetailsViewController* dvc = [[DetailsViewController alloc] init];
    
    if ([ReachabilityStatusChecker hasInternerConnection]) {
        dvc.itemTitleString = item.itemTitle;
        dvc.itemDateString = item.pubDate;
        dvc.itemURLString = item.imageURL;
        dvc.itemDescriptionString = [self correctDescription:item.itemDescription];
        
        [self.navigationController pushViewController:dvc animated:YES];
    } else {
        dvc.itemTitleString = item.itemTitle;
        dvc.itemDescriptionString = [self correctDescription:item.itemDescription];
        [self.navigationController pushViewController:dvc animated:YES];
    }
    
}

- (NSString*) correctDescription:(NSString *) string {
    NSRegularExpression* regularExpression = [NSRegularExpression regularExpressionWithPattern:PATTERN_FOR_VALIDATION
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    string = [regularExpression stringByReplacingMatchesInString:string
                                                         options:0
                                                           range:NSMakeRange(0, [string length])
                                                    withTemplate:@""];
    return string;
}

#pragma mark - ViewControllerSetUp

- (void) configureNavigationBar {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Favorites news";
}

- (void) tableViewSetUp {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[FavoritesNewsTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
                                              [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
                                              [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
                                              [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
                                              ]];
}

- (void) showNotInternerConnectionAlert {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Check your internet connection"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
