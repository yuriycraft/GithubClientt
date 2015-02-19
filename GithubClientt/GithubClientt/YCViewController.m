//
//  YCViewController.m
//  GithubClientt
//
//  Created by apple on 28.10.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCViewController.h"
#import "YCServerManager.h"
#import "YCUser.h"
#import "UIImageView+AFNetworking.h"
#import "YCRepositoryTableViewController.h"
#import "YCRoundedView.h"
#import "YCInternetConnectionUtils.h"
#import "YCError.h"


@interface YCViewController ()

@property(strong,nonatomic)YCUser* currentUser;
@property(strong,nonatomic)NSString* sectionName;
@property(strong,nonatomic)NSString* accessTokenString;
@end

@implementation YCViewController

@synthesize avatarImageView,loginLabel,locationLabel,nameLabel,followersLabel,followingLabel,publicReposLabel ,companyLabel,cellRepoLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor patternBackgroundColor];
    [YCRoundedView setRoundedView:avatarImageView toDiameter:100];
    
    UIRefreshControl* refresh = [[UIRefreshControl alloc]init];
    [refresh addTarget:self action:@selector(refreshProfile) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

-(void) initControllerWithUser:(YCUser*) user {
    if (AUTHORIZED) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.accessTokenString = [userDefaults objectForKey:@"accessToken"];
        cellRepoLabel.text = @"My repositories";
        nameLabel.text = user.name;
        loginLabel.text = user.login;
        locationLabel.text = user.location;
        companyLabel.text = user.company;
        avatarImageView.image = nil;
        
        [avatarImageView setImageWithURL:user.avatarUrl placeholderImage:[UIImage imageNamed:@"emptyAvatar.png"]];
        followingLabel.text = [NSString stringWithFormat:@"%@",user.following];
        followersLabel.text = [NSString stringWithFormat:@"%@",user.followers];
        publicReposLabel.text = [NSString stringWithFormat:@"%@",user.publicReposCount];
    }
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!AUTHORIZED) {
        if(![YCInternetConnectionUtils isConnectedToInternet]) {
            [YCError showErrorNetworkDisabled];
        }
        else if (![YCInternetConnectionUtils isWebSiteUp]) {
            [YCError showErrorServerDontRespond];
        }
        else {
            [[YCServerManager sharedManager]autorizeUser:^(YCUser *user) {
                AUTHORIZED = YES;
                self.buttonDeauthorization.enabled = YES;
                self.currentUser = user;
                [self initControllerWithUser:self.currentUser];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(AUTHORIZED) {
        if ([[segue identifier] isEqualToString:@"showRepo"]) {
            [[segue destinationViewController]getParameters:self.currentUser];
        }
    }
}

#pragma mark - actions

- (IBAction)actionDeauthorization:(id)sender {
    
    self.buttonDeauthorization.enabled = NO;
    
    [[YCServerManager sharedManager]deleteAuthorizations:self.currentUser.userID];
    AUTHORIZED = NO;
    
    nameLabel.text = nil;
    loginLabel.text = nil;
    locationLabel.text = nil;
    companyLabel.text = nil;
    publicReposLabel.text = nil;
    followersLabel.text = nil;
    followingLabel.text = nil;
    
    avatarImageView.image = [UIImage imageNamed:@"emptyAvatar"];
    cellRepoLabel.text = nil;
    [self.tableView reloadData];
    
    if (!AUTHORIZED) {
        if(![YCInternetConnectionUtils isConnectedToInternet]) {
            [YCError showErrorNetworkDisabled];
        }
        else if (![YCInternetConnectionUtils isWebSiteUp]) {
            [YCError showErrorServerDontRespond];
        }
        else {
            [[YCServerManager sharedManager]autorizeUser:^(YCUser *user) {
                AUTHORIZED = YES;
                self.buttonDeauthorization.enabled = YES;
                self.currentUser = user;
                [self initControllerWithUser:self.currentUser];
            }];
        }
    }
}

#pragma mark - Refresh

-(void)refreshProfile{
    if (AUTHORIZED) {
        if(![YCInternetConnectionUtils isConnectedToInternet]) {
            [YCError showErrorNetworkDisabled];
        }
        else if (![YCInternetConnectionUtils isWebSiteUp]) {
            [YCError showErrorServerDontRespond];
        }
        else {
            // NSLog(@"%@",self.accessTokenString);
            [[YCServerManager sharedManager]getUser:self.accessTokenString onSuccess:^(YCUser *user) {
                self.currentUser = user;
                AUTHORIZED = YES;
                [self initControllerWithUser:self.currentUser];
            }
                                          onFailure:^(NSString *error) {
                                              NSLog(@"ERROR: %@",error);
                                              
                                          }];
        }
    } else if(!AUTHORIZED) {
        [[YCServerManager sharedManager]autorizeUser:^(YCUser *user) {
            AUTHORIZED = YES;
            self.buttonDeauthorization.enabled = YES;
            self.currentUser = user;
            [self initControllerWithUser:self.currentUser];
        }];
    }
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}
@end