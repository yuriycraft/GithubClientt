//
//  YCRepository.h
//  GitHubClient
//
//  Created by apple on 13.08.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YCUser;

@interface YCRepository : NSObject
// created_at , description ,forks_count,full_name ,name ,owner [avatar_url,login],watchers,watchers_count,commits_url
@property (nonatomic, strong) NSString *repDescription;
@property (nonatomic, strong) NSNumber *forks_count;
@property (nonatomic, strong) NSString *full_name;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *watchers_count;
@property (nonatomic, strong) YCUser   *owner;
@property (nonatomic, strong) NSString   *commits_url;

-(id)initWithServerResponse :(NSDictionary*) responseObject;

@end
