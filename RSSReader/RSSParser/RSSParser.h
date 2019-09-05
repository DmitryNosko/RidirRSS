//
//  RSSParser.h
//  RSSReader
//
//  Created by Dzmitry Noska on 8/30/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"

extern NSString* const RSSParserItemsWasLoadedNotification;

@interface RSSParser : NSObject
@property (copy, nonatomic) void(^feedItemDownloadedHandler)(FeedItem* item);
- (void) rssParseWithURL:(NSURL*) url;
@end

