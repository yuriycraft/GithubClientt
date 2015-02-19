//
//  YCUIImageBackgroundColor.m
//  GithubClientt
//
//  Created by apple on 07.11.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCUIImageBackgroundColor.h"

@implementation UIColor (YCUIImageBackgroundColor)

+ (UIColor *)patternBackgroundColor {
	return [self colorWithPatternImage:[UIImage imageNamed:@"grey.png"]];
}
@end
