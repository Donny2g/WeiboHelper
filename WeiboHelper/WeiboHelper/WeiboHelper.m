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

#pragma mark- token
-(void)setWBToken:(NSString*)wbtoken{
    [[NSUserDefaults standardUserDefaults] setObject:wbtoken forKey:kToken];
}

-(NSString*)getWBToken{
    if (![[NSUserDefaults standardUserDefaults] stringForKey:kToken]) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:kToken];
}

#pragma mark- userInfo
-(void)_setUserInfo:(NSDictionary*)userInfo{
    
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:kUserInfo];
}

-(void)getUserInfoWithCompletion:(RequestCompletion)completion{
    if (![[NSUserDefaults standardUserDefaults] dictionaryForKey:kUserInfo]) {
        return;
    }
    self.requestCompletion = completion;
    NSDictionary* userInfo =[[NSUserDefaults standardUserDefaults] dictionaryForKey:kUserInfo];
    NSString* url = @"http://api.weibo.com/2/users/show.json";
    
    //測試用(官方帳號)
//    NSDictionary* params = @{@"access_token": @"2.00zBrJ2EjQ8zzC15a429a8ff2pybUD",
//                             @"source": @"2045436852",
//                             @"uid": @"1904178193"};
    
    
    NSDictionary* params = @{@"access_token": [userInfo objectForKey:@"access_token"],
                             @"source": kAppKey,
                             @"uid": [userInfo objectForKey:@"uid"]};
    
    [WBHttpRequest requestWithAccessToken:[self getWBToken] url:url httpMethod:@"GET" params:params delegate:self withTag:@"user"];
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
//這裡是用來接，微博App收到
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
        [alert show];        
        //存入token
        [self setWBToken:[(WBAuthorizeResponse *)response accessToken]];
        //存入userInfo
        [self _setUserInfo:response.userInfo];
        NSLog(@"userInfo:%@",response.userInfo);
        
    }
}

//當你用這個方法去呼叫時[WBHttpRequest requestWithAccessToken:...]，就會call back回下面的Delegate
#pragma mark- WBHttpRequestDelegate
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //UITextField *textField=[alertView textFieldAtIndex:0];
    //NSString *jsonData = @"{\"text\": \"新浪新闻是新浪网官方出品的新闻客户端，用户可以第一时间获取新浪网提供的高品质的全球资讯新闻，随时随地享受专业的资讯服务，加入一起吧\",\"url\": \"http://app.sina.com.cn/appdetail.php?appID=84475\",\"invite_logo\":\"http://sinastorage.com/appimage/iconapk/1b/75/76a9bb371f7848d2a7270b1c6fcf751b.png\"}";
    
    //[WeiboSDK inviteFriend:jsonData withUid:(NSString*)[alertView textFieldAtIndex:0] withToken:[self getWBToken] delegate:self withTag:@"invite1"];
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
    
    if (self.requestCompletion) {
        self.requestCompletion([self _JSONParser:result]);
        self.requestCompletion = nil;
    }
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

-(id)_JSONParser:(NSString*)JSONString{
    
    NSData* jsonData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    NSArray* jsonArray = nil;
    NSDictionary* jsonDictionary = nil;
    if (jsonData) {
        id _jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData                                                 options:NSJSONReadingMutableContainers error:&error];
        if ([_jsonObject isKindOfClass:[NSDictionary class]]) {
            jsonDictionary = (NSDictionary*)_jsonObject;
            NSLog(@"%@",jsonDictionary);
            return jsonDictionary;
        }else if ([_jsonObject isKindOfClass:[NSMutableArray class]]) {
            jsonArray = (NSArray*)_jsonObject;
            NSLog(@"%@",jsonArray);
            return jsonArray;
        }
    }
    return nil;
}
@end
