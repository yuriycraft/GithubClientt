//
//  YCRepositoryTableViewController.h
//  GithubClientt
//
//  Created by apple on 30.10.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YCUser;
@interface YCRepositoryTableViewController : UITableViewController <UITableViewDataSource,UITableViewDelegate>

-(void)getParameters:(YCUser*) user;
@end
