//
//  Twitter.m
//  DriveSync
//
//  Created by JGehry on 28/02/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "Twitter.h"
#import "TwitterRequestTokenAPI.h"
#import "TwitterAccessTokenAPI.h"
#import "TwitterUserAccountAPI.h"
#import "TwitterGetVideoAPI.h"

NSString *const kClientIDWithTwitter = @"SscDcqmsKpH6jsf3MFPSeK6no";
NSString *const kClientSecretWithTwitter = @"SFtcAZ3FIgTYpHGllFUutTR6RSkq1oVVoq5RSGXBkJv2AUzE1s";
NSString *const OAuthorizationEndpointWithTwitter = @"https://api.twitter.com/oauth/authorize";

@implementation Twitter
@synthesize authorizeToken = _authorizeToken;
@synthesize authorizeAccessToken = _authorizeAccessToken;
@synthesize twitterUserID = _twitterUserID;
@synthesize screenName = _screenName;

- (void)dealloc
{
    self.authorizeToken = nil;
    self.authorizeAccessToken = nil;
    self.twitterUserID = nil;
    self.screenName = nil;
    [super dealloc];
}

#pragma mark -- 打开浏览器
- (void)openBrower {
    NSString *oauth = [[OAuthorizationEndpointWithTwitter stringByAppendingString:@"?"] stringByAppendingString:_authorizeToken];
    NSURL *authorizationEndpoint =
    [NSURL URLWithString:oauth];
    
    [[NSWorkspace sharedWorkspace] openURL:authorizationEndpoint];
}

#pragma mark -- 获取请求Token
- (void)fetchRequestToken:(NSString *)consumerKey success:(Callback)success fail:(Callback)fail {
    if ([self isExecute]) {
        YTKRequest *requestAPI = [[TwitterRequestTokenAPI alloc] initWithFetchResource:TwitterRequestTokenAPIURL httpMethod:@"POST" baseURLString:TwitterAPIBaseURL consumerKey:kClientIDWithTwitter withConsumerSecret:kClientSecretWithTwitter withTokenKey:nil withTokenSecret:nil withPIN:nil isHasRequestToken:NO isHasAccessToken:NO];
        __block YTKRequest *weakRequestAPI = requestAPI;
        [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            ResponseCode code = [self checkResponseTypeWithSuccess:request];
            if (code == ResponseSuccess) {
                DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:[request responseData] status:code];
                success?success(response):nil;
                [response release];
            }else {
                NSString *codeStr = [[request userInfo] objectForKey:@"errorMessage"];
                NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
                DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
                fail?fail(response):nil;
                [response release];
            }
            [weakRequestAPI release];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            //to do需要更具返回值判断错误
            if ([[requestAPI error] code] == 3840) {
                ResponseCode code = [self checkResponseTypeWithSuccess:request];
                if (code == ResponseSuccess) {
                    DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:[request responseData] status:code];
                    self.authorizeToken = [request responseString];
                    success?success(response):nil;
                    [response release];
                }
            }else {
                ResponseCode code = [self checkResponseTypeWithFailed:request];
                NSString *codeStr = [[request userInfo] objectForKey:@"errorMessage"];
                NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
                DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
                fail?fail(response):nil;
                [response release];
                [weakRequestAPI release];
            }
        }];
    }
}

#pragma mark -- 获取访问Token
- (void)fetchAccessTokenWithPIN:(NSString *)pin success:(Callback)success fail:(Callback)fail {
    if ([self isExecute]) {
        NSArray *keyValue = [_authorizeToken componentsSeparatedByString:@"&"];
        NSString *oauthToken = nil;
        for (NSString *key in keyValue) {
            if ([key rangeOfString:@"oauth_token"].location != NSNotFound) {
                oauthToken = [[key componentsSeparatedByString:@"="] lastObject];
                break;
            }
        }
        YTKRequest *requestAPI = [[TwitterAccessTokenAPI alloc] initWithFetchResource:TwitterAccessTokenAPIURL httpMethod:@"POST" baseURLString:TwitterAPIBaseURL consumerKey:kClientIDWithTwitter withConsumerSecret:kClientSecretWithTwitter withTokenKey:oauthToken withTokenSecret:nil withPIN:pin isHasRequestToken:YES isHasAccessToken:NO];
        __block YTKRequest *weakRequestAPI = requestAPI;
        [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            ResponseCode code = [self checkResponseTypeWithSuccess:request];
            if (code == ResponseSuccess) {
                DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:[request responseData] status:code];
                success?success(response):nil;
                [response release];
            }else {
                NSString *codeStr = [[request userInfo] objectForKey:@"errorMessage"];
                NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
                DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
                fail?fail(response):nil;
                [response release];
            }
            [weakRequestAPI release];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            //to do需要更具返回值判断错误
            if ([[requestAPI error] code] == 3840) {
                ResponseCode code = [self checkResponseTypeWithSuccess:request];
                if (code == ResponseSuccess) {
                    DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:[request responseData] status:code];
                    self.authorizeAccessToken = [request responseString];
                    NSArray *keyValue = [_authorizeAccessToken componentsSeparatedByString:@"&"];
                    for (NSString *key in keyValue) {
                        if ([key rangeOfString:@"user_id"].location != NSNotFound) {
                            self.twitterUserID = [[key componentsSeparatedByString:@"="] lastObject];
                            continue;
                        }else if ([key rangeOfString:@"screen_name"].location != NSNotFound) {
                            self.screenName = [[key componentsSeparatedByString:@"="] lastObject];
                            break;
                        }
                    }
                    success?success(response):nil;
                    [response release];
                }
            }else {
                ResponseCode code = [self checkResponseTypeWithFailed:request];
                NSString *codeStr = [[request userInfo] objectForKey:@"errorMessage"];
                NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
                DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
                fail?fail(response):nil;
                [response release];
                [weakRequestAPI release];
            }
        }];
    }
}

#pragma mark -- 获取Twitter用户信息
- (void)getAccount:(NSString *)accountID success:(Callback)success fail:(Callback)fail {
    if ([self isExecute]) {
        NSArray *keyValue = [_authorizeAccessToken componentsSeparatedByString:@"&"];
        NSString *oauthToken = nil;
        NSString *oauthTokenSecret = nil;
        for (NSString *key in keyValue) {
            if ([key rangeOfString:@"oauth_token_secret"].location != NSNotFound) {
                oauthTokenSecret = [[key componentsSeparatedByString:@"="] lastObject];
                break;
            }else if ([key rangeOfString:@"oauth_token"].location != NSNotFound) {
                oauthToken = [[key componentsSeparatedByString:@"="] lastObject];
                continue;
            }
        }
        YTKRequest *requestAPI = [[TwitterUserAccountAPI alloc] initWithFetchResource:[NSString stringWithFormat:TwitterGetCurrentAccount, accountID] httpMethod:@"GET" baseURLString:TwitterAPIBaseURL consumerKey:kClientIDWithTwitter withConsumerSecret:kClientSecretWithTwitter withTokenKey:oauthToken withTokenSecret:oauthTokenSecret withPIN:nil isHasRequestToken:YES isHasAccessToken:YES];
        __block YTKRequest *weakRequestAPI = requestAPI;
        [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            ResponseCode code = [self checkResponseTypeWithSuccess:request];
            if (code == ResponseSuccess) {
                DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:[request responseData] status:code];
                success?success(response):nil;
                [response release];
            }else {
                NSString *codeStr = [[request userInfo] objectForKey:@"errorMessage"];
                NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
                DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
                fail?fail(response):nil;
                [response release];
            }
            [weakRequestAPI release];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            //to do需要更具返回值判断错误
            ResponseCode code = [self checkResponseTypeWithFailed:request];
            NSString *codeStr = [[request userInfo] objectForKey:@"errorMessage"];
            NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
            DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
            fail?fail(response):nil;
            [response release];
            [weakRequestAPI release];
        }];
    }
}

#pragma mark -- 获取所有媒体文件
- (void)getVideo:(NSString *)screenName success:(Callback)success fail:(Callback)fail {
    if ([self isExecute]) {
        NSArray *keyValue = [_authorizeAccessToken componentsSeparatedByString:@"&"];
        NSString *oauthToken = nil;
        NSString *oauthTokenSecret = nil;
        for (NSString *key in keyValue) {
            if ([key rangeOfString:@"oauth_token_secret"].location != NSNotFound) {
                oauthTokenSecret = [[key componentsSeparatedByString:@"="] lastObject];
                break;
            }else if ([key rangeOfString:@"oauth_token"].location != NSNotFound) {
                oauthToken = [[key componentsSeparatedByString:@"="] lastObject];
                continue;
            }
        }
        YTKRequest *requestAPI = [[TwitterGetVideoAPI alloc] initWithFetchResource:TwitterUpdateProfile httpMethod:@"POST" baseURLString:TwitterAPIBaseURL consumerKey:kClientIDWithTwitter withConsumerSecret:kClientSecretWithTwitter withTokenKey:oauthToken withTokenSecret:oauthTokenSecret withPIN:nil isHasRequestToken:YES isHasAccessToken:YES];
        __block YTKRequest *weakRequestAPI = requestAPI;
        [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            ResponseCode code = [self checkResponseTypeWithSuccess:request];
            if (code == ResponseSuccess) {
                DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:[request responseData] status:code];
                success?success(response):nil;
                [response release];
            }else {
                NSString *codeStr = [[request userInfo] objectForKey:@"errorMessage"];
                NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
                DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
                fail?fail(response):nil;
                [response release];
            }
            [weakRequestAPI release];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            //to do需要更具返回值判断错误
            ResponseCode code = [self checkResponseTypeWithFailed:request];
            NSString *codeStr = [[request userInfo] objectForKey:@"errorMessage"];
            NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
            DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
            fail?fail(response):nil;
            [response release];
            [weakRequestAPI release];
        }];
    }
}

#pragma mark -- 判断当前的Token有效期
- (BOOL)isExecute {
    return YES;
}

#pragma mark -- 激活已授权的云服务状态
- (void)driveSetAccessTokenKey:(NSString *)driveIDKey {
    //保存数据到本地
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.accessToken forKey:kAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:driveIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -- 取消激活已授权的云服务状态
- (BOOL)driveGetAccessTokenKey:(NSString *)driveIDKey {
    BOOL result = NO;
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:driveIDKey];
    if ([dic objectForKey:kAccessTokenKey]) {
        self.accessToken = [dic objectForKey:kAccessTokenKey];
        result = YES;
    }
    return result;
}

#pragma mark -- 移除已授权的云服务状态
- (void)driveRemoveAccessTokenKey:(NSString *)driveIDKey {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:driveIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self logOut];
}

@end
