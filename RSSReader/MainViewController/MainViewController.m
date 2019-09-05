//
//  MainViewController.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/26/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "MainViewController.h"
#import "WebViewController.h"
#import "MainTableViewCell.h"
#import "DetailsViewController.h"
#import "FeedItem.h"
#import "RSSParser.h"
#import "MenuViewController.h"
#import "FeedResource.h"
#import "FileManager.h"
#import "ReachabilityStatusChecker.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, MainTableViewCellListener, WebViewControllerListener>
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray<FeedItem *>* feeds;
@property (strong, nonatomic) NSMutableArray<FeedItem *>* updatedFeeds;
@property (strong, nonatomic) RSSParser* rssParser;
@property (strong, nonatomic) NSMutableDictionary<NSURL*, FeedResource*>* feedResourceByURL;
@property (strong, nonatomic) NSMutableArray<NSString *>* readedItemsLinks;
@property (strong, nonatomic) NSMutableArray<NSString *>* readingInProgressItemsLinks;
@property (strong, nonatomic) NSMutableArray<NSString *>* favoritesItemsLinks;
@property (strong, nonatomic) NSIndexPath* selectedFeedItemIndexPath;
@end

static NSString* CELL_IDENTIFIER = @"Cell";
static NSString* PATTERN_FOR_VALIDATION = @"<\/?[A-Za-z]+[^>]*>";
static NSString* URL_TO_PARSE = @"https://news.tut.by/rss/index.rss";
static NSString* FAVORITES_NEWS_FILE_NIME = @"favoritiesNews.txt";
static NSString* TUT_BY_NEWS_FILE_NAME = @"tutbyportal";
static NSString* TXT_FORMAT_NAME = @".txt";
static NSString* READED_NEWS = @"readedNews.txt";
static NSString* READING_IN_PROGRESS = @"readingInProgressNews.txt";
static NSString* FAVORITES_NEWS_LINKS = @"favoritiesNewsLinks.txt";

@implementation MainViewController

@synthesize listenedItem = _listenedItem;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureNavigationBar];
    [self tableViewSetUp];
    
    self.feeds = [[NSMutableArray alloc] init];
    self.updatedFeeds = [[NSMutableArray alloc] init];
    self.feedResourceByURL = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                [[FeedResource alloc] initWithName:TUT_BY_NEWS_FILE_NAME url:[NSURL URLWithString:URL_TO_PARSE]] , [NSURL URLWithString:URL_TO_PARSE], nil];
    self.readedItemsLinks = [[FileManager sharedFileManager] readStringsFromFile:READED_NEWS];
    self.readingInProgressItemsLinks = [[FileManager sharedFileManager] readStringsFromFile:READING_IN_PROGRESS];
    self.favoritesItemsLinks = [[FileManager sharedFileManager] readStringsFromFile:FAVORITES_NEWS_LINKS];
    self.rssParser = [[RSSParser alloc] init];
    
    __weak MainViewController* weakSelf = self;
    self.rssParser.feedItemDownloadedHandler = ^(FeedItem *item) {
        NSThread* thread = [[NSThread alloc] initWithBlock:^{
            [weakSelf addFeedItemToFeeds:item];
            [weakSelf performSelectorOnMainThread:@selector(reloadDataHandler) withObject:item waitUntilDone:NO];
        }];
        [thread start];
    };
    
    if ([ReachabilityStatusChecker hasInternerConnection]) {
        [self.rssParser rssParseWithURL:[NSURL URLWithString:URL_TO_PARSE]];
    } else {
        [self showNotInternerConnectionAlert];
        self.feeds = [[FileManager sharedFileManager] readFeedItemsFile:TUT_BY_NEWS_FILE_NAME];
    }
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(feedResourceWasAddedNotification:)
                                                 name:MenuViewControllerFeedResourceWasAddedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(feedResourceWasChosenNotification:)
                                                 name:MenuViewControllerFeedResourceWasChosenNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemsLoaded:)
                                                 name:RSSParserItemsWasLoadedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchButtonWasPressed:)
                                                 name:MenuViewControllerFetchButtonWasPressedNotification
                                               object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) handlemenuToggle {
    [self.delegate handleMenuToggle];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.listener = self;
    cell.titleLabel.text = [self.feeds objectAtIndex:indexPath.row].itemTitle;
    
    FeedItem* item = [self.feeds objectAtIndex:indexPath.row];
    
    if (item.isReaded) {
        cell.stateLabel.text = @"readind";
    }
    
    if (item.isFavorite) {
        [cell.favoritesButton setImage:[UIImage imageNamed:@"fullStar"] forState:UIControlStateNormal];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([ReachabilityStatusChecker hasInternerConnection]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        FeedItem* item = [self.feeds objectAtIndex:indexPath.row];
        item.isReaded = YES;
        NSThread* thread = [[NSThread alloc] initWithBlock:^{
            [[FileManager sharedFileManager] saveString:item.link toFile:READING_IN_PROGRESS];
            FeedResource* resource = [self.feedResourceByURL objectForKey:item.resourceURL];
            [[FileManager sharedFileManager] updateFeedItem:item atIndex:indexPath.row inFile:[NSString stringWithFormat:@"%@%@", resource.name, TXT_FORMAT_NAME]];
        }];
        [thread start];
        self.listenedItem = item;
        WebViewController* dvc = [[WebViewController alloc] init];
        dvc.listener = self;
        self.selectedFeedItemIndexPath = indexPath;
        NSString* string = [self.feeds objectAtIndex:indexPath.row].link;
        NSString *stringForURL = [string substringWithRange:NSMakeRange(0, [string length]-6)];
        NSURL* url = [NSURL URLWithString:stringForURL];
        dvc.newsURL = url;
        [self.navigationController pushViewController:dvc animated:YES];
    } else {
        [self showNotInternerConnectionAlert];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
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

- (BOOL) hasRSSLink:(NSString*) link {
    return [[link substringWithRange:NSMakeRange(link.length - 4, 4)] isEqualToString:@".rss"];
}

#pragma mark - MainTableViewCellListener

- (void)didTapOnInfoButton:(MainTableViewCell *)infoButton {
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:infoButton];
    FeedItem* item = [self.feeds objectAtIndex:indexPath.row];
    
    DetailsViewController* dvc = [[DetailsViewController alloc] init];
    
    if ([ReachabilityStatusChecker hasInternerConnection]) {
        dvc.hasInternetConnection = YES;
        dvc.itemTitleString = item.itemTitle;
        dvc.itemDateString = [self dateToString:item.pubDate];
        dvc.itemURLString = item.imageURL;
        dvc.itemDescriptionString = [self correctDescription:item.itemDescription];
        
        [self.navigationController pushViewController:dvc animated:YES];
    } else {
        dvc.hasInternetConnection = NO;
        dvc.itemTitleString = item.itemTitle;
        dvc.itemDescriptionString = [self correctDescription:item.itemDescription];
        
        [self.navigationController pushViewController:dvc animated:YES];
    }
    
}

- (NSString *) dateToString:(NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (void)didTapOnFavoritesButton:(MainTableViewCell *) favoritesButton {
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:favoritesButton];
    
    FeedItem* item = [self.feeds objectAtIndex:indexPath.row];
    FeedResource* resource = [self.feedResourceByURL objectForKey:item.resourceURL];
    
    if (item.isFavorite) {
        item.isFavorite = NO;
        [self.favoritesItemsLinks removeObject:item.link];
        NSThread* thread = [[NSThread alloc] initWithBlock:^{
            [[FileManager sharedFileManager] removeFeedItem:item fromFile:FAVORITES_NEWS_FILE_NIME];
            [[FileManager sharedFileManager] removeString:item.link fromFile:FAVORITES_NEWS_LINKS];
            [[FileManager sharedFileManager] updateFeedItem:item atIndex:indexPath.row inFile:[NSString stringWithFormat:@"%@%@", resource.name, TXT_FORMAT_NAME]];
        }];
        [thread start];
        
    } else {
        item.isFavorite = YES;
        [self.favoritesItemsLinks addObject:item.link];
        NSThread* thread = [[NSThread alloc] initWithBlock:^{
            [[FileManager sharedFileManager] saveFeedItem:item toFileWithName:FAVORITES_NEWS_FILE_NIME];
            [[FileManager sharedFileManager] saveString:item.link toFile:FAVORITES_NEWS_LINKS];
            [[FileManager sharedFileManager] updateFeedItem:item atIndex:indexPath.row inFile:[NSString stringWithFormat:@"%@%@", resource.name, TXT_FORMAT_NAME]];
        }];
        [thread start];
    }
    [self.tableView reloadData];
}

#pragma mark - MainTableViewCellListener

- (void)didTapOnDoneButton:(UIBarButtonItem *)doneButton {
    FeedItem* item = [self.feeds objectAtIndex:self.selectedFeedItemIndexPath.row];
    FeedResource* resource = [self.feedResourceByURL objectForKey:item.resourceURL];
    
    NSThread* thread = [[NSThread alloc] initWithBlock:^{
        [[FileManager sharedFileManager] saveString:self.listenedItem.link toFile:READED_NEWS];
        [[FileManager sharedFileManager] removeFeedItem:self.listenedItem fromFile:[NSString stringWithFormat:@"%@%@", resource.name, TXT_FORMAT_NAME]];
    }];
    [thread start];
    [self.readedItemsLinks addObject:self.listenedItem.link];
    [self.feeds removeObjectAtIndex:self.selectedFeedItemIndexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[self.selectedFeedItemIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}


#pragma mark - ViewControllerSetUp

- (void) tableViewSetUp {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
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

- (void) configureNavigationBar {
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationItem.title = @"RSS Reader";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handlemenuToggle)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}

#pragma mark - Shake gesture

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    [self.feeds removeAllObjects];
    
    __weak MainViewController* weakSelf = self;
    self.rssParser.feedItemDownloadedHandler = ^(FeedItem *item) {
        NSThread* thread = [[NSThread alloc] initWithBlock:^{
            [weakSelf addFeedItemToFeeds:item];
            [weakSelf performSelectorOnMainThread:@selector(reloadDataHandler) withObject:item waitUntilDone:NO];
        }];
        [thread start];
    };
    
    for (NSURL* url in [self.feedResourceByURL allKeys]) {
        [self.rssParser rssParseWithURL:url];
    }
    
}

#pragma mark - Notifications

- (void) feedResourceWasAddedNotification:(NSNotification*) notification {
    [self.feeds removeAllObjects];
    
    FeedResource* resource = [notification.userInfo objectForKey:@"resource"];
    [self.feedResourceByURL setObject:resource forKey:resource.url];
    
    __weak MainViewController* weakSelf = self;
    self.rssParser.feedItemDownloadedHandler = ^(FeedItem *item) {
        NSThread* thread = [[NSThread alloc] initWithBlock:^{
            [weakSelf addFeedItemToFeeds:item];
            [weakSelf performSelectorOnMainThread:@selector(reloadDataHandler) withObject:item waitUntilDone:NO];
        }];
        [thread start];
    };
    
    [self.rssParser rssParseWithURL:resource.url];
    
}

- (void) feedResourceWasChosenNotification:(NSNotification*) notification {

    FeedResource* resource = [notification.userInfo objectForKey:@"resource"];
    NSString* str = [NSString stringWithFormat:@"%@%@", resource.name, TXT_FORMAT_NAME];
    NSMutableArray<FeedItem*>* items = [[FileManager sharedFileManager] readFeedItemsFile:str];
    self.feeds = items;
    [self.tableView reloadData];
}

- (void) addFeedItemToFeeds:(FeedItem* ) item {
    if (item) {
        if (![self.readedItemsLinks containsObject:item.link]) {
            if ([self.readingInProgressItemsLinks containsObject:item.link]) {
                item.isReaded = YES;
            }
            if ([self.favoritesItemsLinks containsObject:item.link]) {
                item.isFavorite = YES;
            }
            [self.feeds addObject:item];
        }
    }
}

- (void) reloadDataHandler {
    [self.tableView reloadData];
}


- (void) itemsLoaded:(NSNotification *) notification {
    [self.feeds sortUsingComparator:^NSComparisonResult(FeedItem* obj1, FeedItem* obj2) {
        return [obj2.pubDate compare:obj1.pubDate];
    }];
    FeedItem* item = [self.feeds firstObject];
    FeedResource* resource = [self.feedResourceByURL objectForKey:item.resourceURL];
    
    [[FileManager sharedFileManager] createAndSaveFeedItems:self.feeds toFileWithName:[NSString stringWithFormat:@"%@%@", resource.name, TXT_FORMAT_NAME]];
    
}

- (void) fetchButtonWasPressed:(NSNotification *) notification {
    
    [self.feeds removeAllObjects];
    
    NSMutableArray<FeedResource *>* resourcesToLoad = [notification.userInfo objectForKey:@"resources"];
    
    __weak MainViewController* weakSelf = self;
    self.rssParser.feedItemDownloadedHandler = ^(FeedItem *item) {
        NSThread* thread = [[NSThread alloc] initWithBlock:^{
            [weakSelf addFeedItemToFeeds:item];
            [weakSelf performSelectorOnMainThread:@selector(reloadDataHandler) withObject:item waitUntilDone:NO];
        }];
        [thread start];
    };
    
    for (FeedResource* fr in resourcesToLoad) {
        [self.rssParser rssParseWithURL:fr.url];
    }
    
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

