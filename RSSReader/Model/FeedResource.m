//
//  FeedResource.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/3/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "FeedResource.h"

@interface FeedResource () <NSCoding>

@end

static NSString* const NAME_KEY = @"NAME_KEY";
static NSString* const URL_KEY = @"URL_KEY";


@implementation FeedResource

- (instancetype)initWithName:(NSString*) name url:(NSURL*) url
{
    self = [super init];
    if (self) {
        _name = name;
        _url = url;
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:NAME_KEY];
    [aCoder encodeObject:self.url forKey:URL_KEY];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:NAME_KEY];
        self.url = [aDecoder decodeObjectForKey:URL_KEY];
    }
    return self;
}

@end
