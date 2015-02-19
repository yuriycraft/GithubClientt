//
//  YCRepositoryTableViewController.m
//  GithubClientt
//
//  Created by apple on 30.10.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCRepositoryTableViewController.h"
#import "YCUser.h"
#import "YCRepository.h"
#import "YCServerManager.h"
#import "YCViewController.h"
#import "YCAccessToken.h"
#import "YCRepoDetailController.h"
#import "YCError.h"
#import "YCInternetConnectionUtils.h"

@interface YCRepositoryTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *repoTableView;
@property(strong,nonatomic)YCUser* currentUser;
@property (assign,nonatomic) BOOL firstTimeAppear;
@property (strong,nonatomic)NSArray* arrayRepos;

@end

@implementation YCRepositoryTableViewController

-(void)getParameters:(YCUser*) user{
    self.currentUser = user;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor patternBackgroundColor];
    if(![YCInternetConnectionUtils isConnectedToInternet]) {
        [YCError showErrorNetworkDisabled];
    }
    else if (![YCInternetConnectionUtils isWebSiteUp]) {
        [YCError showErrorServerDontRespond];
    }
    else {
        [[YCServerManager sharedManager]getRepo:self.currentUser onSuccess:^(NSArray *repos) {
            self.arrayRepos = repos;
            [self.repoTableView reloadData];
        } onFailure:^(NSString *error) {
            [YCError showAlertWithTitle:@"Error" message:error];
        }];
    }
    UIRefreshControl* refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self action:@selector(refreshRepository) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.repoTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayRepos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier ];
    
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    YCRepository* repository = [self.arrayRepos objectAtIndex:indexPath.row];
    cell.textLabel.text = repository.full_name;
    cell.imageView.image = [UIImage imageNamed:@"repo.png"];
    cell.detailTextLabel.text = repository.repDescription;
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showRepoDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        YCRepository* repp = [self.arrayRepos objectAtIndex:indexPath.row];
        [[segue destinationViewController]setRepoDetailItem:repp];
    }
}

#pragma mark - Refresh

-(void)refreshRepository{
    if(![YCInternetConnectionUtils isConnectedToInternet]) {
        [YCError showErrorNetworkDisabled];
    }
    else if (![YCInternetConnectionUtils isWebSiteUp]) {
        [YCError showErrorServerDontRespond];
    }
    else {
        [[YCServerManager sharedManager]getRepo:self.currentUser onSuccess:^(NSArray *repos) {
            self.arrayRepos = repos;
            [self.repoTableView reloadData];
        } onFailure:^(NSString *error) {
            [YCError showAlertWithTitle:@"Error" message:error];
        }];
    }
    [self.refreshControl endRefreshing];
}
@end