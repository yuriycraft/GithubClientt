//
//  YCError.h
//  GithubClientt
//
//  Created by apple on 10.11.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCError : UIView
+(void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
+(void)showErrorNetworkDisabled;
+(void)showErrorServerDontRespond;
@end
