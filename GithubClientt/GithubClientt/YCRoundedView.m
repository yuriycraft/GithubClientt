//
//  YCRoundedView.m
//  GithubClientt
//
//  Created by apple on 07.11.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCRoundedView.h"

@implementation YCRoundedView

+(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
    roundedView.clipsToBounds = YES;
}

@end
