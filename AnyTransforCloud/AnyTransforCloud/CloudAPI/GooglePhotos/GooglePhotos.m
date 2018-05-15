//
//  GooglePhotos.m
//  DriveSync
//
//  Created by 罗磊 on 2018/4/12.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "GooglePhotos.h"
#import "GooglePhotoGetAlbumsListAPI.h"
#import "GooglePhotoGetAlbumsPhotoListAPI.h"
#import "GooglePhotosPhotoListXMLParse.h"
#import "GooglePhotosAlbumsListXMLParse.h"

NSString *const kClientIDWithGooglePhotos = @"330226033766-fphcvslq27gmq73ul023uinv2lm60d4o.apps.googleusercontent.com";
NSString *const kClientSecretWithGooglePhotos = @"7iHvJYVOw9wqz4TIPbhdL4nW";
NSString *const kRedirectURIWithGooglePhotos = @"com.googleusercontent.apps.330226033766-fphcvslq27gmq73ul023uinv2lm60d4o:/oauthredirect";
NSString *const OAuthorizationEndpointWithGooglePhotos = @"https://accounts.google.com/o/oauth2/v2/auth";
NSString *const TokenEndpointWithGooglePhotos = @"https://www.googleapis.com/oauth2/v4/token";

@implementation GooglePhotos

- (void)logIn
{
    if ([self isAuthValid]) {
        if ([_delegate respondsToSelector:@selector(driveDidLogIn:)]) {
            [_delegate driveDidLogIn:self];
        }
    }else{
        NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];
        [appleEventManager setEventHandler:self
                               andSelector:@selector(handleGetURLEvent:withReplyEvent:)
                             forEventClass:kInternetEventClass
                                andEventID:kAEGetURL];
        if (_currentAuthorizationFlow != nil) {
            [_currentAuthorizationFlow release],
            _currentAuthorizationFlow = nil;
        }
        NSArray *scope = @[@"https://picasaweb.google.com/data"];
        NSURL *authorizationEndpoint =
        [NSURL URLWithString:OAuthorizationEndpointWithGooglePhotos];
        NSURL *tokenEndpoint =
        [NSURL URLWithString:TokenEndpointWithGooglePhotos];
        OIDServiceConfiguration *configuration =
        [[OIDServiceConfiguration alloc] initWithAuthorizationEndpoint:authorizationEndpoint
                                                         tokenEndpoint:tokenEndpoint];
        OIDAuthorizationRequest *request =
        [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                      clientId:kClientIDWithGooglePhotos
                                                  clientSecret:kClientSecretWithGooglePhotos
                                                        scopes:scope
                                                   redirectURL:[NSURL URLWithString:kRedirectURIWithGooglePhotos]
                                                  responseType:OIDResponseTypeCode
                                          additionalParameters:nil];
        request.bodyNeedClientandSecret = YES;
        _currentAuthorizationFlow = [[OIDAuthState authStateByPresentingAuthorizationRequest:request
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

#pragma makr - 一般业务方法
- (void)getPhotoAlbumsList:(NSString *)accountName success:(Callback)success fail:(Callback)fail
{
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            YTKRequest *requestAPI = [[GooglePhotoGetAlbumsListAPI alloc] initWithUserAccountID:accountName accessToken:_accessToken];
            __block YTKRequest *weakRequestAPI = requestAPI;
            [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                ResponseCode code = [self checkResponseTypeWithSuccess:request];
                if (code == ResponseSuccess) {
                    GooglePhotosAlbumsListXMLParse *albumsXMLParse = [[GooglePhotosAlbumsListXMLParse alloc] init];
                    __block GooglePhotosAlbumsListXMLParse *weakxml = albumsXMLParse;
                    [weakxml decodeXML:request.responseString finish:^(id result) {
                        DriveAPIResponse *response = [[DriveAPIResponse alloc] init];
                        response.responseCode = code;
                        response.content = result;
                        success?success(response):nil;
                        [response release];
                        [weakxml release];
                    }];
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

- (void)getPhotoAlbumsPhotoList:(NSString *)accountName albumID:(NSString *)albumID success:(Callback)success fail:(Callback)fail
{
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            YTKRequest *requestAPI = [[GooglePhotoGetAlbumsPhotoListAPI alloc] initWithUserAccountID:accountName albumID:albumID accessToken:_accessToken];
            __block YTKRequest *weakRequestAPI = requestAPI;
            [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                ResponseCode code = [self checkResponseTypeWithSuccess:request];
                if (code == ResponseSuccess) {
                    GooglePhotosPhotoListXMLParse *photoListXMLParse = [[GooglePhotosPhotoListXMLParse alloc] init];
                    __block GooglePhotosPhotoListXMLParse *weakxml = photoListXMLParse;
                    [weakxml decodeXML:request.responseString finish:^(id result) {
                        DriveAPIResponse *response = [[DriveAPIResponse alloc] init];
                        response.responseCode = code;
                        response.content = result;
                        success?success(response):nil;
                        [response release];
                        [weakxml release];
                    }];
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

#pragma mark - 下载
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

- (ResponseCode)checkResponseTypeWithSuccess:(YTKBaseRequest *)request
{
    if (request.responseStatusCode == 200) {
        return ResponseSuccess;
    }else if (request.responseStatusCode == 403){
        return ResponseTokenInvalid;
    }else if (request.responseStatusCode == 400){
        return ResponseInvalid;
    }else{
        return ResponseUnknown;
    }
}

@end
