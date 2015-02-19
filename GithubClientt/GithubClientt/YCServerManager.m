//
//  YCServerManager.m
//  GitHubClient
//
//  Created by apple on 13.08.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCServerManager.h"
#import "AFNetworking.h"
#import "YCLoginViewController.h"
#import "YCAccessToken.h"
#import "YCRepository.h"
#import "YCViewController.h"
#import "YCUser.h"
#import "YCCommits.h"

@interface YCServerManager ()

@property (strong,nonatomic) AFHTTPRequestOperationManager* requestOperationManager;
@property (strong,nonatomic)YCAccessToken* accessToken;

@end

@implementation YCServerManager

- (id)init
{
    self = [super init];
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"https://api.github.com"];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:url];
        
    }
    return self;
}

+(YCServerManager*)sharedManager{
    
    static YCServerManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YCServerManager alloc]init];
    });
    
    return manager;
    
}

-(void) getUser:(NSString*) tokenID
      onSuccess:(void(^)(YCUser* user)) success
      onFailure:(void(^)(NSString* error)) failure{
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            tokenID,@"access_token", nil];
    
    [self.requestOperationManager GET:@"user" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        
        // NSLog(@"%@",responseObject);
        
        if(success){
            YCUser* user = [[YCUser alloc]initWithServerResponse:responseObject] ;
            success(user);
            
        }
        else if (failure){
            failure(nil);
        }
    }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSDictionary * dict = [NSDictionary dictionaryWithDictionary:operation.responseObject] ;
                                  
                                  NSString *message = [dict objectForKey:@"message"];
                                  NSLog(@"ERROR: %@",message);
                                  if(failure){
                                      failure(message);
                                  }
                              }];
    
    
}

-(void)autorizeUser:(void(^)(YCUser* user)) completions {
    
    YCLoginViewController* vc =
    [[YCLoginViewController alloc]initWithCompletionBlock:^(YCAccessToken *token) {
        if(token){
            AUTHORIZED = YES;
            self.accessToken = token;
            //     NSLog(@"%@",self.accessToken.token);
            [self getUser:self.accessToken.token
                onSuccess:^(YCUser* user) {
                    if(completions){
                        completions(user);
                    }
                    
                }
                onFailure:^(NSString *error) {
                    NSLog(@"ERROR: %@",error);
                    if(completions){
                        completions(nil);
                    }
                }];
            
        }
    }];
    
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:vc];
    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows]firstObject] rootViewController];
    [mainVC presentViewController:nav animated:YES completion:nil];
    
}

-(void) getRepo:(YCUser*)user onSuccess
               :(void(^)(NSArray* repos)) success
      onFailure:(void(^)(NSString* error)) failure{
    
    NSString* url = [NSString stringWithFormat:@"users/%@/repos",user.login];
    [self.requestOperationManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // NSLog(@"%@",responseObject);
        NSArray* repoArray = responseObject;
        NSMutableArray* objectsArray = [NSMutableArray array];
        for(NSDictionary* dict in repoArray){
            YCRepository* repo = [[YCRepository alloc]initWithServerResponse:dict];
            
            [objectsArray addObject:repo];
        }
        
        if(success) {
            success(objectsArray);
        }
        else if (failure) {
            failure(nil);
        }
    }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSDictionary * dict = [NSDictionary dictionaryWithDictionary:operation.responseObject] ;
                                  NSString *message = [dict objectForKey:@"message"];
                                  
                                  if(failure) {
                                      failure(message);
                                      NSLog(@"ERROR: %@",message);
                                  }
                              }];
    
}

-(void) getCommits:(YCRepository*)repository onSuccess
                  :(void(^)(NSArray* commits)) success
         onFailure:(void(^)(NSString* error)) failure{
    
    NSString* url = [NSString stringWithFormat:@"repos/%@/%@/commits",repository.owner.login,repository.name];
    [self.requestOperationManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray* commitsArray = responseObject;
        NSMutableArray* objectsArray = [NSMutableArray array];
        for(NSDictionary* dict in commitsArray){
            YCCommits* commits = [[YCCommits alloc]initWithServerResponse:dict];
            //  NSLog(@"%@",responseObject);
            [objectsArray addObject:commits];
        }
        
        if(success) {
            success(objectsArray);
        }
        else {
            failure(nil);
        }
    }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  NSDictionary * dict=[NSDictionary dictionaryWithDictionary:operation.responseObject] ;
                                  NSString *message= [dict objectForKey:@"message"];
                                  NSLog(@"ERROR: %@",message);
                                  
                                  if(failure) {
                                      failure(message);
                                  }
                              }];
}

-(void) deleteAuthorizations:(NSString*)userID{
    
    NSString* url = [NSString stringWithFormat:@"authorizations/%@",userID];
    [self.requestOperationManager DELETE:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"DELETE AUTH %@ ",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSDictionary * dict = [NSDictionary dictionaryWithDictionary:operation.responseObject] ;
        NSString *message = [dict objectForKey:@"message"];
        NSLog(@"ERROR: %@",message);
    }];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"accessToken"];
    [userDefaults synchronize];
    AUTHORIZED = NO;
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"github.com"];
        if(domainRange.length > 0) {
            [storage deleteCookie:cookie];
        }
    }
}

@end
