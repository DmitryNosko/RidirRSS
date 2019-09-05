//
//  RSSURLValidator.h
//  RSSReader
//
//  Created by Dzmitry Noska on 9/3/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSURLValidator : NSObject
@property (strong, nonatomic) NSMutableArray* rssLinks;
- (NSURL*) parseFeedResoursecFromURL:(NSURL*) url;
@end
