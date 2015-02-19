//
//  YCCommitsTableViewCell.h
//  GithubClientt
//
//  Created by apple on 12.11.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCCommitsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *authorImage;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commitDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *commitMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *commitShaLabel;

@end
