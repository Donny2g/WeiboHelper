//
//  ViewController.h
//  WeiboHelper
//
//  Created by HarveyHu on 2014/1/16.
//  Copyright (c) 2014年 HarveyHu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *userInfo;
- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)getUserInfo:(id)sender;
@end
