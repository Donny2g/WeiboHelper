//
//  WeiboHelper.m
//  WeiboHelper
//
//  Created by HarveyHu on 2014/1/17.
//  Copyright (c) 2014年 HarveyHu. All rights reserved.
//

#import "WeiboHelper.h"

@implementation WeiboHelper
#pragma mark- singleton
+(instancetype) sharedInstance {
    static dispatch_once_t pred;
    static WeiboHelper *instance = nil;
    dispatch_once(&pred, ^{instance = [[self alloc] initSingleton];});
    return instance;
}
- (id)init {
    return nil;
}
- (id)initSingleton {
    
    self = [super init];
    if ((self = [super init])) {
        //TODO: ...
    }
    
    return self;
}

#pragma mark- login
- (void)SSOLogin
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)Logout
{
    [WeiboSDK logOutWithToken:[self getWBToken] delegate:self withTag:@"user1"];
}
-(void)saveWBToken:(NSString*)wbtoken{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        // 這裡判斷是否第一次
        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"第一次"
                                                        message:@"進入App"
                                                       delegate:self
                                              cancelButtonTitle:@"我知道了"
                                              otherButtonTitles:nil];
        [alert show];
        
    }

}

#pragma mark- getInformation
-(NSString*)getWBToken{
    NSString* token;
    return token;
}
-(NSDictionary*)getUserInfo{
    NSDictionary* dic;
    return dic;
}

#pragma mark- WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        //ProvideMessageForWeiboViewController *controller = [[[ProvideMessageForWeiboViewController alloc] init] autorelease];
        //[self.viewController presentModalViewController:controller animated:YES];
    }
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *title = @"认证结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        
        //存入token
        [self saveWBToken:[(WBAuthorizeResponse *)response accessToken]];
        
        [alert show];
    }
}

#pragma mark- WBHttpRequestDelegate
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField=[alertView textFieldAtIndex:0];
    NSString *jsonData = @"{\"text\": \"新浪新闻是新浪网官方出品的新闻客户端，用户可以第一时间获取新浪网提供的高品质的全球资讯新闻，随时随地享受专业的资讯服务，加入一起吧\",\"url\": \"http://app.sina.com.cn/appdetail.php?appID=84475\",\"invite_logo\":\"http://sinastorage.com/appimage/iconapk/1b/75/76a9bb371f7848d2a7270b1c6fcf751b.png\"}";
    
    [WeiboSDK inviteFriend:jsonData withUid:[textField text] withToken:[self getWBToken] delegate:self withTag:@"invite1"];
}

- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"收到网络回调";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = @"请求异常";
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:@"确定"
                             otherButtonTitles:nil];
    [alert show];
}
@end
