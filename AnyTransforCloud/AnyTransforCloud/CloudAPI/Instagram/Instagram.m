//
//  Instagram.m
//  DriveSync
//
//  Created by JGehry on 28/02/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "Instagram.h"
#import "InstagramGetRecentMeidaListAPI.h"
#import "InstagramGetUserInfoAPI.h"

NSString *const kClientIDWithInstagram = @"2893c22f7a5c4adf85bfe08c54cb260d";
NSString *const kClientSecretWithInstagram = @"2bcda9aeeeb44053b6d8c9a84b1d55ff";
NSString *const kRedirectURIWithInstagram = @"http://127.0.0.1:58240/";
NSString *const kSuccessURLStringWithInstagram = @"https://www.baidu.com";
NSString *const OAuthorizationEndpointWithInstagram = @"https://api.instagram.com/oauth/authorize";
NSString *const TokenEndpointWithInstagram = @"https://api.instagram.com/oauth/access_token";

@implementation Instagram

- (void)logIn {
    if ([self isAuthValid]) {
        if ([_delegate respondsToSelector:@selector(driveDidLogIn:)]) {
            [_delegate driveDidLogIn:self];
        }
    }else{
        if (_redirectHTTPHandler != nil) {
            [_redirectHTTPHandler release],
            _redirectHTTPHandler = nil;
        }
        NSArray *scope = @[@"public_content"];
        NSURL *authorizationEndpoint =
        [NSURL URLWithString:OAuthorizationEndpointWithInstagram];
        NSURL *tokenEndpoint =
        [NSURL URLWithString:TokenEndpointWithInstagram];
        NSURL *successURL = [NSURL URLWithString:kSuccessURLStringWithInstagram];
        _redirectHTTPHandler = [[OIDRedirectHTTPHandler alloc] initWithSuccessURL:successURL];
        NSURL *redirectURI = [_redirectHTTPHandler startHTTPListener:nil];
        OIDServiceConfiguration *configuration =
        [[OIDServiceConfiguration alloc] initWithAuthorizationEndpoint:authorizationEndpoint
                                                         tokenEndpoint:tokenEndpoint];
        OIDAuthorizationRequest *request =
        [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                      clientId:kClientIDWithInstagram
                                                  clientSecret:kClientSecretWithInstagram
                                                        scopes:scope
                                                   redirectURL:redirectURI
                                                  responseType:OIDResponseTypeCode
                                          additionalParameters:nil];
        request.bodyNeedClientandSecret = YES;
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

#pragma mark - business Actions
- (void)getRecentMediaListWithsuccess:(Callback)success fail:(Callback)fail
{
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            YTKRequest *requestAPI = [[InstagramGetRecentMeidaListAPI alloc] initWithItemID:nil accessToken:_accessToken];
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
    }];
}

- (void)getAccount:(NSString *)accountID success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            YTKRequest *requestAPI = [[InstagramGetUserInfoAPI alloc] initWithItemID:nil accessToken:_accessToken];
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
    }];
}


#pragma mark - downloadActions
- (void)downloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item
{
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            item.urlString = item.itemIDOrPath;
            item.httpMethod = @"GET";
            [_downLoader downloadItem:item completionHandler:^(NSURL * _Nullable filePath, NSError * _Nullable error) {
                //todo 完成回调
            }];
        }
    }];
}

- (void)performActionWithFreshTokens:(RefreshTokenAction)refreshAction
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (refreshAction != nil) {
            refreshAction(YES);
        }
    });
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
