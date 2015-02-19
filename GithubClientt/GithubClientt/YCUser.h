//
//  YCUser.h
//  GitHubClient
//
//  Created by apple on 13.08.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCUser : NSObject

@property (nonatomic, strong) NSURL* avatarUrl;
@property (nonatomic, strong) NSString* login;
@property (nonatomic, strong) NSString* company;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* location;
@property (nonatomic, strong) NSNumber* publicReposCount;
@property (nonatomic, strong) NSString* reposUrl;
@property (nonatomic, strong) NSNumber* followers;
@property (nonatomic, strong) NSNumber* following;
@property (nonatomic, strong) NSString* userID;

-(id)initWithServerResponse :(NSDictionary*) responseObject;
@end
