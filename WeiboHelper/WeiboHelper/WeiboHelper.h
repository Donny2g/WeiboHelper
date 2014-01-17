//
//  WeiboHelper.h
//  WeiboHelper
//
//  Created by HarveyHu on 2014/1/17.
//  Copyright (c) 2014年 HarveyHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

//com.sina.weibo.SNWeiboSDKDemo
#define kAppKey         @"2045436852"
#define kRedirectURI    @"http://www.sina.com"

@interface WeiboHelper : NSObject <WBHttpRequestDelegate, WeiboSDKDelegate>
//singleton
+(instancetype) sharedInstance;

//login <-> logout
-(void)SSOLogin;
-(void)Logout;

//token
-(void)saveWBToken:(NSString*)wbtoken;
-(NSString*)getWBToken;

//getUserInfo
-(NSDictionary*)getUserInfo;
@end
