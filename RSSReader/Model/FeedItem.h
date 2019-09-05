//
//  FeedItem.h
//  RSSReader
//
//  Created by Dzmitry Noska on 8/30/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedItem : NSObject
@property (strong, nonatomic) NSString* itemTitle;
@property (strong, nonatomic) NSMutableString* link;
//@property (strong, nonatomic) NSString* pubDate;
@property (strong, nonatomic) NSDate* pubDate;
@property (strong, nonatomic) NSMutableString* itemDescription;
@property (strong, nonatomic) NSString* enclosure;
@property (strong, nonatomic) NSString* imageURL;
@property (assign, nonatomic) BOOL isFavorite;
@property (assign, nonatomic) BOOL isReaded;
@property (assign, nonatomic) BOOL isAvailable;
@property (strong, nonatomic) NSURL* resourceURL;
@end;
