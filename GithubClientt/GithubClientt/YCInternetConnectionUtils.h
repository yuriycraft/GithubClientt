//
//  YCInternetConnectionUtils.h
//  GithubClientt
//
//  Created by apple on 07.11.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Reachability;
@interface YCInternetConnectionUtils : NSObject
+(BOOL)isWebSiteUp;
+(BOOL)isConnectedToInternet;
@end
