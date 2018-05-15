//
//  Facebook.m
//  DriveSync
//
//  Created by JGehry on 26/02/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "Facebook.h"
#import "FacebookUserAccountAPI.h"
#import "FacebookGetListAlbumsAPI.h"
#import "FacebookGetListVideosAPI.h"
#import "FacebookGetVideoAPI.h"
#import "FacebookGetTimelineAPI.h"

NSString *const kClientIDWithFacebook = @"811956709002048";
NSString *const kClientSecretWithFacebook = @"b6f8518556763fd07ab4ad5d4282e4b5";
NSString *const kRedirectURIWithFacebook = @"http://127.0.0.1:58240/";
NSString *const kSuccessURLStringWithFacebook = @"https://www.facebook.com/connect/login_success.html";
NSString *const OAuthorizationEndpointWithFacebook = @"https://www.facebook.com/v2.12/dialog/oauth";
NSString *const TokenEndpointWithFacebook = @"https://graph.facebook.com/v2.12/oauth/access_token";

@implementation Facebook

- (void)logIn
{
    if ([self isAuthValid]) {
        if ([_delegate respondsToSelector:@selector(driveDidLogIn:)]) {
            [_delegate driveDidLogIn:self];
        }
    }else{
        if (_redirectHTTPHandler != nil) {
            [_redirectHTTPHandler release],
            _redirectHTTPHandler = nil;
        }
        NSArray *scope = @[@"user_photos", @"user_videos", @"user_posts"];
        NSURL *authorizationEndpoint =
        [NSURL URLWithString:OAuthorizationEndpointWithFacebook];
        NSURL *tokenEndpoint =
        [NSURL URLWithString:TokenEndpointWithFacebook];
        NSURL *successURL = [NSURL URLWithString:kSuccessURLStringWithFacebook];
        _redirectHTTPHandler = [[OIDRedirectHTTPHandler alloc] initWithSuccessURL:successURL];
        NSURL *redirectURI = [_redirectHTTPHandler startHTTPListener:nil];
        OIDServiceConfiguration *configuration =
        [[OIDServiceConfiguration alloc] initWithAuthorizationEndpoint:authorizationEndpoint
                                                         tokenEndpoint:tokenEndpoint];
        OIDAuthorizationRequest *request =
        [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                      clientId:kClientIDWithFacebook
                                                  clientSecret:kClientSecretWithFacebook
                                                        scopes:scope
                                                   redirectURL:redirectURI
                                                  responseType:OIDResponseTypeCode
                                          additionalParameters:nil];
        [request setCodeVerifier:nil];
        [request setCodeChallenge:nil];
        [request setCodeChallengeMethod:nil];
        _redirectHTTPHandler.currentAuthorizationFlow =
        [[OIDAuthState authStateByPresentingAuthorizationRequest:request
                                                        callback:^(OIDAuthState *_Nullable authState,
                                                                   NSError *_Nullable error) {
                                                            if (authState) {
                                                                //此处需要给自己的token赋值
                                                                self.accessToken = authState.lastTokenResponse.accessToken;
                                                                self.expirationDate = authState.lastTokenResponse.accessTokenExpirationDate;
                                                                
                                                                if ([_delegate respondsToSelector:@selector(driveDidLogIn:)]) {
                                                                    [_delegate driveDidLogIn:self];
                                                                }
                                                            } else {
                                                                if ([_delegate respondsToSelector:@selector(drive:logInFailWithError:)]) {
                                                                    [_delegate drive:self logInFailWithError:error];
                                                                }
                                                            }
                                                        }] retain];
    }
}

- (void)getAccount:(NSString *)accountID success:(Callback)success fail:(Callback)fail {
    if ([self isExecute]) {
        YTKRequest *requestAPI = [[FacebookUserAccountAPI alloc] initWithUserAccountID:accountID accessToken:_accessToken];
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

#pragma mark -- 获取相册及视频列表
- (void)getList:(NSString *)folerID isVideo:(BOOL)isVideo success:(Callback)success fail:(Callback)fail {
    if (!isVideo) {
        if ([self isExecute]) {
            YTKRequest *requestAPI = [[FacebookGetListAlbumsAPI alloc] initWithItemID:folerID accessToken:_accessToken];
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
    }else {
        if ([self isExecute]) {
            YTKRequest *requestAPI = [[FacebookGetListVideosAPI alloc] initWithItemID:folerID accessToken:_accessToken];
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
}

#pragma mark -- 获取某个视频
- (void)getVideo:(NSString *)videoID success:(Callback)success fail:(Callback)fail {
    if ([self isExecute]) {
        YTKRequest *requestAPI = [[FacebookGetVideoAPI alloc] initWithItemID:videoID accessToken:_accessToken];
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

#pragma mark -- 获取时间线帖子
- (void)getTimeline:(NSString *)folderID success:(Callback)success fail:(Callback)fail {
    if ([self isExecute]) {
        YTKRequest *requestAPI = [[FacebookGetTimelineAPI alloc] initWithItemID:folderID accessToken:_accessToken];
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

#pragma mark - downloadActions
- (void)downloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item
{
    NSString *urlString = item.itemIDOrPath;
    item.urlString = urlString;
    item.httpMethod = @"GET";
    [_downLoader downloadItem:item completionHandler:^(NSURL * _Nullable filePath, NSError * _Nullable error) {
        //todo 完成回调
    }];
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
