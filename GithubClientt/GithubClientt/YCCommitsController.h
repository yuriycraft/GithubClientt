//
//  YCCommitsController.h
//  GithubClientt
//
//  Created by apple on 02.11.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YCCommits;
@class YCRepository;
@interface YCCommitsController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *commitsTableView;
-(void)setCommitsItem:(NSArray*)commits
           repository:(YCRepository*)repo;
@end
