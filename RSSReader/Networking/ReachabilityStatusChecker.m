//
//  ReachabilityStatusChecker.m
//  RSSReader
//
//  Created by Dzmitry Noska on 9/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "ReachabilityStatusChecker.h"
#import "Reachability.h"

@implementation ReachabilityStatusChecker

+ (BOOL) hasInternerConnection {
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus* status = [reachability currentReachabilityStatus];
    return status != NotReachable;
}

@end
