//
//  YCCommitsController.m
//  GithubClientt
//
//  Created by apple on 02.11.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCCommitsController.h"
#import "YCCommits.h"
#import "YCRepository.h"
#import "UIImageView+AFNetworking.h"
#import "YCRoundedView.h"
#import "YCInternetConnectionUtils.h"
#import "YCServerManager.h"
#import "YCError.h"
#import "YCCommitsTableViewCell.h"

@interface YCCommitsController ()
@property (strong,nonatomic)NSArray* comm;
@property (strong,nonatomic)YCRepository* repos;
@end

@implementation YCCommitsController
@synthesize commitsTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor patternBackgroundColor];
    UIRefreshControl* refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self action:@selector(refreshCommits) forControlEvents:UIControlEventValueChanged];
    self.refreshControl=refresh;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comm count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"Cell";
    YCCommitsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    
    if(!cell) {
        cell = [[YCCommitsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    YCCommits* commits = [self.comm objectAtIndex:indexPath.row];
    cell.authorNameLabel.text = commits.authorName;
    cell.commitMessageLabel.text = commits.message;
    [YCRoundedView setRoundedView:cell.authorImage toDiameter:43];
    [cell.authorImage setImageWithURL:commits.avatarUrl placeholderImage:[UIImage imageNamed:@"emptyAvatar.png"]];
    cell.commitShaLabel.text = commits.sha;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yy HH:mm" ];
    cell.commitDateLabel.text = [dateFormatter stringFromDate:commits.date];
    
    return cell;
}
-(void)refreshCommits{
    if(![YCInternetConnectionUtils isConnectedToInternet]) {
        [YCError showErrorNetworkDisabled];
    }
    else if (![YCInternetConnectionUtils isWebSiteUp]) {
        [YCError showErrorServerDontRespond];
    }
    else {
        [[YCServerManager sharedManager]getCommits:self.repos onSuccess:^(NSArray *commits) {
            self.comm = commits;
        } onFailure:^(NSString *error) {
            [YCError showAlertWithTitle:@"Error" message:error];
        }];
    }
    [self.commitsTableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - Initialization

-(void)setCommitsItem:(NSArray*)commits
           repository:(YCRepository*)repo{
    self.comm = commits;
    self.repos = repo;
    [commitsTableView reloadData];
}

@end