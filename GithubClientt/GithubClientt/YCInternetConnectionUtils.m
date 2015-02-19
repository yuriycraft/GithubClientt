//
//  YCInternetConnectionUtils.m
//  GithubClientt
//
//  Created by apple on 07.11.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCInternetConnectionUtils.h"
#import "Reachability.h"

@implementation YCInternetConnectionUtils

+(BOOL)isWebSiteUp {
    Reachability *reachable = [Reachability reachabilityWithHostName:@"github.com"];
    NetworkStatus networkStatus = [reachable currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

+(BOOL)isConnectedToInternet {
    Reachability *reachable = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachable currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

@end
