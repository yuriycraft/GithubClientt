//
//  YCRepository.m
//  GitHubClient
//
//  Created by apple on 13.08.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCRepository.h"
#import "YCUser.h"
#define IS_NOT_EMPTY_STRING(str)  ((str) && [(str) isKindOfClass:NSString.class] && [(str) length] > 0)
@implementation YCRepository

-(id)initWithServerResponse: (NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        //  description ,forks_count,full_name ,name ,owner [avatar_url,login],watchers,watchers_count
        if (IS_NOT_EMPTY_STRING([responseObject objectForKey:@"description"])) {
            self.repDescription = [responseObject objectForKey:@"description"];
        }
        else {
            self.repDescription = @"";
        }
        if (IS_NOT_EMPTY_STRING([responseObject objectForKey:@"forks_count"])) {
            self.forks_count = [responseObject objectForKey:@"forks_count"];
        }
        else { self.forks_count=0;
        }
        if (IS_NOT_EMPTY_STRING([responseObject objectForKey:@"full_name"])) {
            self.full_name = [responseObject objectForKey:@"full_name"];
        }
        else {
            self.full_name = @"";
        }
        if (IS_NOT_EMPTY_STRING([responseObject objectForKey:@"name"])) {
            self.name = [responseObject objectForKey:@"name"];
        }
        else {
            self.name = @"";
        }
        if (IS_NOT_EMPTY_STRING([responseObject objectForKey:@"watchers_count"])) {
            self.watchers_count = [responseObject objectForKey:@"watchers_count"];
        }
        else {self.watchers_count = 0;
        }
        if (IS_NOT_EMPTY_STRING([responseObject objectForKey:@"commits_url"])) {
            self.commits_url = [responseObject objectForKey:@"commits_url"];
        }
        else {
            self.commits_url = @"";
        }
        NSDictionary* dict=[responseObject objectForKey:@"owner"];
        
        self.owner=[[YCUser alloc] initWithServerResponse:dict];
        // NSLog(@"%@",self.owner.login);
        
    }
    return self;
}
@end
