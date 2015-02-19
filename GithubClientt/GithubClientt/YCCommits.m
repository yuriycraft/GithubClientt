//
//  YCCommits.m
//  GithubClientt
//
//  Created by apple on 02.11.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCCommits.h"
#define IS_NOT_EMPTY_STRING(str)  ((str) && [(str) isKindOfClass:NSString.class] && [(str) length] > 0)

@implementation YCCommits

-(id)initWithServerResponse :(NSDictionary*) responseObject{
    
    self = [super init];
    if (self) {
        if (IS_NOT_EMPTY_STRING([responseObject objectForKey:@"sha"])) {
            self.sha = [responseObject objectForKey:@"sha"];
        }
        else {
            self.sha = @"";
        }
        NSDictionary *dictionary = [responseObject objectForKey:@"commit"];
        NSDictionary *commitAuthorDictionary = [dictionary objectForKey:@"author"];
        NSDictionary *commitUrlAuthorDict = [responseObject objectForKey:@"author"];
        if (IS_NOT_EMPTY_STRING([commitUrlAuthorDict objectForKey:@"avatar_url"])) {
            NSString *urlAvatar = [commitUrlAuthorDict objectForKey:@"avatar_url"];
            if (urlAvatar) {
                self.avatarUrl = [NSURL URLWithString:urlAvatar];
            }
        }
        else {
            self.avatarUrl = [NSURL URLWithString:@""];
        }
        if (IS_NOT_EMPTY_STRING([dictionary objectForKey:@"message"])) {
            self.message = [dictionary objectForKey:@"message"];
        }
        else {
            self.message = @"";
        }
        if (IS_NOT_EMPTY_STRING([commitAuthorDictionary objectForKey:@"name"])) {
            self.authorName = [commitAuthorDictionary objectForKey:@"name"];
        }
        else {
            self.authorName = @"";
        }
        NSString* str = [commitAuthorDictionary objectForKey:@"date"];
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        self.date = [formatter dateFromString:str];
    }
    return self;
}

@end
