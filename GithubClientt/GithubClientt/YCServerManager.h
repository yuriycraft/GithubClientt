//
//  YCServerManager.h
//  GitHubClient
//
//  Created by apple on 13.08.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YCUser;
@class YCAccessToken;
@class YCRepository;
@class YCCommits;
@interface YCServerManager : NSObject
@property (strong,nonatomic,readonly)YCUser* currentUser;

+(YCServerManager*)sharedManager;

-(void)autorizeUser:(void(^)(YCUser* user)) completions;

-(void) getUser:(NSString*) tokenID
      onSuccess:(void(^)(YCUser* user)) success
      onFailure:(void(^)(NSString* error)) failure;

-(void) getRepo:(YCUser*)user onSuccess:
(void(^)(NSArray* repos)) success
      onFailure:(void(^)(NSString* error)) failure;

-(void) getCommits:(YCRepository*)repository onSuccess
                  :(void(^)(NSArray* commits)) success
         onFailure:(void(^)(NSString* error)) failure;

-(void) deleteAuthorizations:(NSString*)userID;
@end
