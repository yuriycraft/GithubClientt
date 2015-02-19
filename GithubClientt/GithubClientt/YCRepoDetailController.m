//
//  YCRepoDetailController.m
//  GithubClientt
//
//  Created by apple on 02.11.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCRepoDetailController.h"
#import "YCRepository.h"
#import "YCUser.h"
#import "YCServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "YCCommits.h"
#import "YCCommitsController.h"
#import "YCError.h"
#import "YCInternetConnectionUtils.h"
#import "YCRoundedView.h"

@interface YCRepoDetailController ()
@property(strong,nonatomic)YCRepository* repo;
@property(strong,nonatomic)YCUser* owner;
@property(strong,nonatomic)NSArray* arrayCommits;
@end

@implementation YCRepoDetailController
@synthesize repoTableView,nameRepoLabel,descriptionRepoLabel,authorNameLabel,forksCountLabel,watchsCountLabel,commitsCountLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor patternBackgroundColor];
    [YCRoundedView setRoundedView:self.authorRepoImage toDiameter:57];
    [self initController];
    
    [[YCServerManager sharedManager]getCommits:self.repo onSuccess:^(NSArray *commits) {
        self.arrayCommits = commits;
        self.commitsCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[self.arrayCommits count]];
        [repoTableView reloadData];
    } onFailure:^(NSString *error) {
        //  [YCError showAlertWithTitle:@"Error" message:error];
    }];
    UIRefreshControl* refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self action:@selector(refreshRepoDetail) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    [repoTableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.repoTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setRepoDetailItem:(YCRepository*)repository{
    self.repo = repository;
    self.owner = repository.owner;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showCommits"]) {
        
        [[segue destinationViewController]setCommitsItem:self.arrayCommits repository:self.repo];
    }
}


-(void)initController{
    self.repoNavItem.title = self.repo.name;
    self.nameRepoLabel.text = self.repo.full_name;
    self.descriptionRepoLabel.text = self.repo.repDescription;
    self.authorNameLabel.text = self.owner.login;
    [self.authorRepoImage setImageWithURL:self.repo.owner.avatarUrl placeholderImage:[UIImage imageNamed:@"emptyAvatar.png"]];
    self.forksCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.repo.forks_count.integerValue ] ;
    self.watchsCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.repo.watchers_count.integerValue];
}
-(void)refreshRepoDetail{
    if(![YCInternetConnectionUtils isConnectedToInternet]) {
        [YCError showErrorNetworkDisabled];
    }
    else if (![YCInternetConnectionUtils isWebSiteUp]) {
        [YCError showErrorServerDontRespond];
    }
    else {
        [[YCServerManager sharedManager]getCommits:self.repo onSuccess:^(NSArray *commits) {
            self.arrayCommits = commits;
            self.commitsCountLabel.text=[NSString stringWithFormat:@"%lu", (unsigned long)[self.arrayCommits count]];
            [repoTableView reloadData];
        } onFailure:^(NSString *error) {
            // [YCError showAlertWithTitle:@"Error" message:error];
        }];
    }
    [self initController];
    [self.repoTableView reloadData];
    [self.refreshControl endRefreshing];
}
@end
