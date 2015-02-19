//
//  YCLoginViewController.h
//  GitHubClient
//
//  Created by apple on 19.08.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCViewController.h"


@class YCAccessToken;

typedef void(^YCLoginCompletionBlock )(YCAccessToken* token);

@interface YCLoginViewController : UIViewController
@property (strong,nonatomic) NSString* codes;
@property( strong,nonatomic) YCAccessToken* token;

-(id)initWithCompletionBlock:(YCLoginCompletionBlock)completionBlock;

@end
