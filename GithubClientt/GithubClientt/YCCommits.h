//
//  YCCommits.h
//  GithubClientt
//
//  Created by apple on 02.11.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCCommits : NSObject

@property(strong,nonatomic)NSString* sha;
@property(strong,nonatomic)NSString* message;
@property(strong,nonatomic)NSDate* date;
@property(strong,nonatomic)NSString* authorName;
@property(strong,nonatomic)NSURL* avatarUrl;

-(id)initWithServerResponse :(NSDictionary*) responseObject;
@end
