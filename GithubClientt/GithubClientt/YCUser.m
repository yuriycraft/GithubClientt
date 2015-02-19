//
//  YCUser.m
//  GitHubClient
//
//  Created by apple on 13.08.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCUser.h"
#define IS_NOT_EMPTY_STRING(str)  ((str) && [(str) isKindOfClass:NSString.class] && [(str) length] > 0)

@implementation YCUser

-(id)initWithServerResponse: (NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        if (IS_NOT_EMPTY_STRING([responseObject objectForKey:@"login"])) {
            self.login = [responseObject objectForKey:@"login"];
        }
        else {
            self.login = @"";
        }
        if (IS_NOT_EMPTY_STRING([responseObject objectForKey:@"location"])) {
            self.location = [responseObject objectForKey:@"location"];
        }
        else {
            self.location = @"";
        }
        NSString *urlAvatar = [responseObject objectForKey:@"avatar_url"];
        if (urlAvatar) {
            self.avatarUrl = [NSURL URLWithString:urlAvatar];
        }
        if(IS_NOT_EMPTY_STRING([responseObject objectForKey:@"name"])) {
            self.name = [responseObject objectForKey:@"name"];
        }
        else {
            self.name = @"";
        }
        self.publicReposCount = [responseObject objectForKey:@"public_repos"];
        
        if (IS_NOT_EMPTY_STRING([responseObject objectForKey:@"repos_url"])) {
            self.reposUrl = [responseObject objectForKey:@"repos_url"];
        }
        else {
            self.reposUrl = @"";
        }
        self.followers = [responseObject objectForKey:@"followers"];
        self.following = [responseObject objectForKey:@"following"];
        
        if (IS_NOT_EMPTY_STRING([responseObject objectForKey:@"company"])) {
            self.company = [responseObject objectForKey:@"company"];
        }
        else {
            self.company = @"";
        }
        if (IS_NOT_EMPTY_STRING([responseObject objectForKey:@"id"])) {
            self.userID = [responseObject objectForKey:@"id"];
        }
        else {
            self.userID = @"";
        }
    }
    return self;
}

@end
