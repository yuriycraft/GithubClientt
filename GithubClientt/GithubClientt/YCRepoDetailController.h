//
//  YCRepoDetailController.h
//  GithubClientt
//
//  Created by apple on 02.11.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YCRepository;
@interface YCRepoDetailController : UITableViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *repoNavItem;
@property (strong, nonatomic) IBOutlet UITableView *repoTableView;
@property (weak, nonatomic) IBOutlet UILabel *nameRepoLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionRepoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorRepoImage;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *forksCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commitsCountLabel;
-(void)setRepoDetailItem:(YCRepository*)repository;
@end
