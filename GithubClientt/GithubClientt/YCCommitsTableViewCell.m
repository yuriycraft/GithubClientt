//
//  YCCommitsTableViewCell.m
//  GithubClientt
//
//  Created by apple on 12.11.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCCommitsTableViewCell.h"

@implementation YCCommitsTableViewCell

@synthesize commitDateLabel,commitShaLabel,commitMessageLabel,authorImage,authorNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
