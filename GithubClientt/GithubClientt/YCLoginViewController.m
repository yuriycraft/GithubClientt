//
//  YCLoginViewController.m
//  GitHubClient
//
//  Created by apple on 19.08.14.
//  Copyright (c) 2014 Юрий Крафт. All rights reserved.
//

#import "YCLoginViewController.h"
#import "YCAccessToken.h"
#import "YCServerManager.h"
#import "YCInternetConnectionUtils.h"
#import "YCError.h"

@interface YCLoginViewController () <UIWebViewDelegate>
@property (weak,nonatomic)UIWebView* webView;
@property (copy,nonatomic)YCLoginCompletionBlock completionBlock;
@property (strong,nonatomic)YCAccessToken* accessToken;
@end

@implementation YCLoginViewController

-(id)initWithCompletionBlock:(YCLoginCompletionBlock)completionBlock{
    self = [super init];
    if (self) {
        self.completionBlock =completionBlock;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect r = self.view.bounds;
    r.origin = CGPointZero;
    UIWebView* webView = [[UIWebView alloc]initWithFrame:r];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
    [self.view addSubview:webView];
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                         target:(self) action:@selector(actionCancel:)];
    
    [self.navigationItem setRightBarButtonItem:item animated:YES];
    self.navigationItem.title = @"Sign in";
    NSString* urlString = [NSString stringWithFormat:@"https://github.com/login/oauth/authorize?"
                           "client_id=cf03ca0d88021f642438&"
                           "scope=user,public_repo"];
    
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest  requestWithURL:url];
    webView.delegate=self;
    if(![YCInternetConnectionUtils isConnectedToInternet]) {
        [YCError showErrorNetworkDisabled];
    }
    else if (![YCInternetConnectionUtils isWebSiteUp]) {
        [YCError showErrorServerDontRespond];
    }
    else {
        [webView loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

-(void)actionCancel:(UIBarButtonItem*) item{
    if(self.completionBlock) {
        self.completionBlock(nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if ([[[request URL]host] isEqualToString:@"oauth"]) {
        NSString* query = [[request URL]description];
        NSArray* array  = [query componentsSeparatedByString:@"="];
        if([array count] == 2 ){
            NSString* key = [array firstObject];
            if([key isEqualToString:@"my-app://oauth?code"]) {
                self.codes = [array lastObject];
                NSString* urlString1 =[NSString stringWithFormat:@"https://github.com/login/oauth/access_token"];
                NSString* params=[NSString stringWithFormat:@"client_id=cf03ca0d88021f642438"
                                  "&client_secret=4e77518a4227db877413a2b6253fad9c0fd309b6"
                                  "&code=%@",self.codes];
                NSURL* url1 = [NSURL URLWithString:urlString1];
                NSMutableURLRequest* request1 = [NSMutableURLRequest  requestWithURL:url1];
                
                [request1 setTimeoutInterval:30.0f];
                [request1 setHTTPMethod:@"POST"];
                [request1 setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
                NSOperationQueue *queue = [[NSOperationQueue alloc]init];
                [NSURLConnection sendAsynchronousRequest:request1 queue:queue completionHandler:^
                 (NSURLResponse *response, NSData *data, NSError *connectionError) {
                     
                     if ([data length]>0 && connectionError == nil) {
                         NSString* html = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                         NSArray* arrayToken  = [html componentsSeparatedByString:@"&"];
                         if([arrayToken count] >1 ) {
                             YCAccessToken* token = [[YCAccessToken alloc]init];
                             NSString* stringToken = [arrayToken firstObject];
                             NSArray*  tmpArrayToken = [stringToken componentsSeparatedByString:@"="];
                             token.token= [tmpArrayToken lastObject];
                             
                             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                             [userDefaults setObject:token.token forKey:@"accessToken"];
                             [userDefaults synchronize];
                             
                             webView.delegate = nil;
                             if(self.completionBlock) {
                                 self.completionBlock(token);
                             }
                             [self dismissViewControllerAnimated:YES completion:nil];
                         }
                     }
                 }];
                return NO;
            }
        }
    }
    return YES;
}
-(void)dealloc{
    self.webView.delegate=nil;
    
}

@end
