//
//  ViewController.m
//  WeiboHelper
//
//  Created by HarveyHu on 2014/1/16.
//  Copyright (c) 2014年 HarveyHu. All rights reserved.
//

#import "ViewController.h"
#import "WeiboHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    [[WeiboHelper sharedInstance] SSOLogin];
}
- (IBAction)logout:(id)sender {
    [[WeiboHelper sharedInstance] Logout];
}

- (IBAction)getUserInfo:(id)sender {
    [[WeiboHelper sharedInstance] getUserInfoWithCompletion:^(id result) {
        NSString *title = @"User Information";
        NSString *message = [NSString stringWithFormat:@"名稱: %@\n生日: %@\n性別: %@",[result objectForKey:@"screen_name"], [result objectForKey:@""], [result objectForKey:@"gender"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }];

    

}
@end
