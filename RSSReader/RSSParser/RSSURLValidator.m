//
//  RSSURLValidator.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/3/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "RSSURLValidator.h"

@interface RSSURLValidator ()

@property (strong, nonatomic) NSURL* resultURL;
@end

static NSString* PATTERN_FOR_PARSE_FEED_RESOURSES_FROM_URL = @"href=\"([^\"]*)";
static NSString* PATTERN_FOR_UNNECESSARY_SYMBOLS = @"(\W|^)(href=)";

@implementation RSSURLValidator

- (NSURL*) parseFeedResoursecFromURL:(NSURL*) url { // TODO fix feed
    
    NSString* stringURL = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSError* error = nil;
    
    NSRegularExpression *regularExpretion = [NSRegularExpression regularExpressionWithPattern:PATTERN_FOR_PARSE_FEED_RESOURSES_FROM_URL
                                                                                      options:NSRegularExpressionCaseInsensitive
                                                                                        error:&error];
    [regularExpretion enumerateMatchesInString:stringURL
                                       options:1
                                         range:NSMakeRange(0, stringURL.length)
                                    usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                                        NSString* insideString = [stringURL substringWithRange:[result rangeAtIndex:0]];
                                        
                                        if (insideString.length > 0) {
                                            insideString = [self removeUnnecessarySymbolsFromString:insideString withPattern:PATTERN_FOR_UNNECESSARY_SYMBOLS];
                                            insideString = [self removeUnnecessarySymbolsFromString:insideString withPattern:@"[\"]"];
                                            if ([self hasRSSPrefix:insideString]) {
                                                NSString* str = [NSString stringWithFormat:@"https%@", [insideString substringFromIndex:4]];
                                                [self.rssLinks addObject:[NSURL URLWithString:str]];
                                                self.resultURL = [NSURL URLWithString:str];
                                            }
                                        }
                                    }];
    
    return self.resultURL;
}

- (NSString*) removeUnnecessarySymbolsFromString:(NSString*) string withPattern:(NSString*) pattern {
    NSError* error = nil;
    
    NSRegularExpression* regularExpretion = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                      options:NSRegularExpressionCaseInsensitive
                                                                                        error:&error];
    return [regularExpretion stringByReplacingMatchesInString:string
                                                      options:0
                                                        range:NSMakeRange(0, string.length)
                                                 withTemplate:@""];
}

- (BOOL) hasRSSPrefix:(NSString*) link {
    return [[link substringWithRange:NSMakeRange(link.length - 4, 4)] isEqualToString:@".rss"];
}

@end

