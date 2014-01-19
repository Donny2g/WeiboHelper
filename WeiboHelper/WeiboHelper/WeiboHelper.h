//
//  WeiboHelper.h
//  WeiboHelper
//
//  Created by HarveyHu on 2014/1/17.
//  Copyright (c) 2014年 HarveyHu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
typedef void(^RequestCompletion)(id result);

//com.sina.weibo.SNWeiboSDKDemo
//#define kAppKey         @"2045436852"
#define kAppKey         @"2748264993"
#define kRedirectURI    @"https://open.weibo.cn/oauth2/authorize"
#define kToken          @"WBToken"
#define kUserInfo       @"userInfo"

@interface WeiboHelper : NSObject <WBHttpRequestDelegate, WeiboSDKDelegate>{
    NSDictionary* _userInfo;
}
@property (strong,nonatomic) RequestCompletion requestCompletion;

//singleton
+(instancetype) sharedInstance;

//login <-> logout
-(void)SSOLogin;
-(void)Logout;

//token
-(void)setWBToken:(NSString*)wbtoken;
-(NSString*)getWBToken;

//getUserInfo
-(void)getUserInfoWithCompletion:(RequestCompletion)completion;
@end
