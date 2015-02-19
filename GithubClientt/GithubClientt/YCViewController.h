//
//  YCViewController.h
//  GithubClientt
//
//  Created by apple on 28.10.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCUser;

@interface YCViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *cellRepoLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonDeauthorization;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *publicReposLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property ( strong, nonatomic)IBOutlet UINavigationItem * item1;

- (IBAction)actionDeauthorization:(id)sender;


@end
