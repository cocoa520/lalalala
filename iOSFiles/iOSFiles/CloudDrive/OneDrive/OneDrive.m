//
//  OneDrive.m
//  DriveSync
//
//  Created by 罗磊 on 2017/11/30.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import "OneDrive.h"
#import "OneDDeleteItemAPI.h"
#import "OneDCreateFolderAPI.h"
#import "OneDGetListAPI.h"
#import "OneDDownloadAPI.h"
#import "OneDUploadAPI.h"
#import "OneDReNameAPI.h"
#import "OneDMoveToNewParentAPI.h"
#import "OneDriveRefreshTokenAPI.h"

NSString *const kClientIDWithOneDrive = @"2fc079f7-b720-4947-9b3c-1886b9fa0456";
NSString *const kClientSecretWithOneDrive = nil;
NSString *const kRedirectURIWithOneDrive = @"msal2fc079f7-b720-4947-9b3c-1886b9fa0456://auth";
NSString *const OAuthorizationEndpointWithOneDrive = @"https://login.microsoftonline.com/common/oauth2/v2.0/authorize";
NSString *const TokenEndpointWithOneDrive = @"https://login.microsoftonline.com/common/oauth2/v2.0/token";

@implementation OneDrive

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
        NSArray *scope = @[@"files.readwrite", @"offline_access"];
        NSURL *authorizationEndpoint =
        [NSURL URLWithString:OAuthorizationEndpointWithOneDrive];
        NSURL *tokenEndpoint =
        [NSURL URLWithString:TokenEndpointWithOneDrive];
        OIDServiceConfiguration *configuration =
        [[OIDServiceConfiguration alloc] initWithAuthorizationEndpoint:authorizationEndpoint
                                                         tokenEndpoint:tokenEndpoint];
        OIDAuthorizationRequest *request =
        [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                      clientId:kClientIDWithOneDrive
                                                  clientSecret:kClientSecretWithOneDrive
                                                        scopes:scope
                                                   redirectURL:[NSURL URLWithString:kRedirectURIWithOneDrive]
                                                  responseType:OIDResponseTypeCode
                                          additionalParameters:nil];
        
        
        
        _currentAuthorizationFlow =
        [[OIDAuthState authStateByPresentingAuthorizationRequest:request
                                                        callback:^(OIDAuthState *_Nullable authState,
                                                                   NSError *_Nullable error) {
                                                            if (authState) {
                                                                self.accessToken = authState.lastTokenResponse.accessToken;
                                                                self.expirationDate = authState.lastTokenResponse.accessTokenExpirationDate;
                                                                self.refreshToken = authState.refreshToken;
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

- (void)createFolder:(NSString *)folderName parent:(NSString *)parentID success:(Callback)success fail:(Callback)fail
{
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            YTKRequest *requestAPI = [[OneDCreateFolderAPI alloc] initWithFolderName:folderName Parent:parentID accessToken:_accessToken];
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

- (void)getList:(NSString *)folerID success:(Callback)success fail:(Callback)fail
{
    [self performActionWithFreshTokens:^(BOOL refresh) {
        YTKRequest *requestAPI = [[OneDGetListAPI alloc] initWithItemID:folerID accessToken:_accessToken];
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
    }];
}

- (void)deleteFilesOrFolders:(NSArray *)fileOrFolderIDs success:(Callback)success fail:(Callback)fail
{
    [self performActionWithFreshTokens:^(BOOL refresh) {
        NSMutableArray *requestArray = [NSMutableArray array];
        for (NSString *itemID in fileOrFolderIDs ) {
            YTKRequest *requestAPI = [[OneDDeleteItemAPI alloc] initWithItemID:itemID accessToken:_accessToken];
            [requestArray addObject:requestAPI];
            [requestAPI release];
        }
        YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:requestArray];
        __block YTKBatchRequest *weakBatchRequest = batchRequest;
        [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
            YTKRequest *request = [batchRequest.requestArray lastObject];
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
            [weakBatchRequest release];
        } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
            //to do需要更具返回值判断错误
            YTKRequest *request = [batchRequest.requestArray lastObject];
            ResponseCode code = [self checkResponseTypeWithFailed:request];
            NSString *codeStr = [[request userInfo] objectForKey:@"errorMessage"];
            NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
            DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
            fail?fail(response):nil;
            [response release];
            [weakBatchRequest release];
        }];
    }];
}

- (void)reName:(NSString *)newName idOrPath:(NSString *)idOrPath success:(Callback)success fail:(Callback)fail
{
    [self performActionWithFreshTokens:^(BOOL refresh) {
        YTKRequest *requestAPI = [[OneDReNameAPI alloc] initWithNewName:newName idOrPath:idOrPath accessToken:_accessToken];
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
    }];
}

- (void)moveToNewParent:(NSString *)newParent sourceParent:(NSString *)parent idOrPaths:(NSArray *)idOrPaths success:(Callback)success fail:(Callback)fail{
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            NSMutableArray *requestArray = [NSMutableArray array];
            for (NSString *itemID in idOrPaths) {
                YTKRequest *requestAPI = [[OneDMoveToNewParentAPI alloc] initWithItemID:itemID newParentIDOrPath:newParent parent:parent accessToken:_accessToken];
                [requestArray addObject:requestAPI];
                [requestAPI release];
            }
            YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:requestArray];
            __block YTKBatchRequest *weakBatchRequest = batchRequest;
            [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
                YTKRequest *request = [batchRequest.requestArray lastObject];
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
                [weakBatchRequest release];
            } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
                //to do需要更具返回值判断错误
                YTKRequest *request = [batchRequest.requestArray lastObject];
                ResponseCode code = [self checkResponseTypeWithFailed:request];
                NSString *codeStr = [[request userInfo] objectForKey:@"errorMessage"];
                NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
                DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
                fail?fail(response):nil;
                [response release];
                [weakBatchRequest release];
            }];
        }
    }];
}

#pragma mark - downloadActions
- (void)downloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item
{
    if (item.isFolder) {
        [_folderItemArray addObject:item];
        [(NSObject *)item addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        [self downloadFolder:item];
    }else{
        [self performActionWithFreshTokens:^(BOOL refresh) {
            NSString *urlString = [OneDriveEndPointURL stringByAppendingPathComponent:[NSString stringWithFormat:OneDriveDownloadFilePath,item.itemIDOrPath]];
            item.urlString = urlString;
            item.httpMethod = @"GET";
            [_downLoader downloadItem:item];
        }];
    }
}

- (void)startDownload:(_Nonnull id <DownloadAndUploadDelegate>)item completionHandler:(nullable void (^)(NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler
{
    NSString *urlString = [OneDriveEndPointURL stringByAppendingPathComponent:[NSString stringWithFormat:OneDriveDownloadFilePath,item.itemIDOrPath]];
    item.urlString = urlString;
    item.httpMethod = @"GET";
    [_downLoader startDownload:item completionHandler:completionHandler];
}

- (void)downloadFolder:(_Nonnull id<DownloadAndUploadDelegate>)item
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            NSMutableArray *allfileArray = [NSMutableArray array];
            [self getAllFile:item.itemIDOrPath AllChildArray:allfileArray parentPath:[NSString stringWithFormat:@"/%@",item.fileName]];
            [item setChildArray:allfileArray];
            long long  totalSize = [[item.childArray valueForKeyPath:@"@sum.fileSize"] longLongValue];
            [item setFileSize:totalSize];
            NSArray *sortArray = [item.childArray sortedArrayUsingSelector:@selector(compare:)];            //设置为等待状态
            [sortArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id <DownloadAndUploadDelegate> childItem = obj;
                childItem.parent = item;
            }];
            //设置为等待状态
            item.state = DownloadStateWait;
            if ([sortArray count] > 0) {
                [self downloadItems:sortArray];
            }else{
                item.progress = 100;
                item.state = DownloadStateComplete;
            }        }
    });
}

- (void)getAllFile:(NSString *)folderID  AllChildArray:(NSMutableArray *)allChildArray  parentPath:(NSString *)parentPath
{
    NSDictionary *dic = [self getList:folderID];
    NSString *folderPath = [_downLoader.downloadPath stringByAppendingString:parentPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    //解析列表
    NSMutableArray *childArray = [self parseListDic:dic];
    for (NSDictionary *childDic in childArray) {
        if ([[childDic allKeys] containsObject:@"folder"]) {
            //是文件夹
            NSString *folderID = [childDic objectForKey:@"id"];
            NSString *foderName = [childDic objectForKey:@"name"];
            NSString *path = [parentPath stringByAppendingPathComponent:foderName];
            [self getAllFile:folderID AllChildArray:allChildArray parentPath:path];
        }else{
            //构建downloaditem
            DownLoadAndUploadItem *item = [[DownLoadAndUploadItem alloc] init];
            item.itemIDOrPath = [childDic objectForKey:@"id"];
            item.parentPath = parentPath;
            item.fileName = [childDic objectForKey:@"name"];
            item.fileSize = [[childDic objectForKey:@"size"] longLongValue];
            [allChildArray addObject:item];
            [item release];
        }
    }
}

- (NSMutableArray <NSDictionary *> *)parseListDic:(NSDictionary *)content
{
    NSMutableArray *childArray = [NSMutableArray array];
    NSArray *valueArray = [content objectForKey:@"value"];
    for (NSDictionary *dic in valueArray) {
        NSMutableDictionary *childDic = [NSMutableDictionary dictionary];
        for (NSString *key in dic.allKeys) {
            if ([key isEqualToString:@"id"]) {
                [childDic setObject:[dic objectForKey:@"id"] forKey:@"id"];
            }else if ([key isEqualToString:@"name"]){
                [childDic setObject:[dic objectForKey:@"name"] forKey:@"name"];
            }else if ([key isEqualToString:@"folder"]){
                [childDic setObject:@(1) forKey:@"folder"];
            }else if ([key isEqualToString:@"parentReference"]){
                NSDictionary *parentReference = [dic objectForKey:@"parentReference"];
                NSString *path = [parentReference objectForKey:@"path"];
                NSString *parent = [path stringByReplacingOccurrencesOfString:@"/drive/root:" withString:@""];
                [childDic setObject:parent forKey:@"parent"];
            }else if ([key isEqualToString:@"size"]){
                [childDic setObject:[dic objectForKey:@"size"] forKey:@"size"];
            }
        }
        [childArray addObject:childDic];
    }
    return childArray;
}

- (void)uploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    if (item.isFolder) {
        [_folderItemArray addObject:item];
        [(NSObject *)item addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        [self uploadFolder:item];
    }else{
        [self performActionWithFreshTokens:^(BOOL refresh) {
            YTKRequest *requestAPI = [[OneDUploadAPI alloc] initWithFileName:[item fileName] Parent:[item uploadParent] accessToken:_accessToken];
            [requestAPI setResumableUploadPath:[item localPath]];
            [item setRequestAPI:requestAPI];
            [requestAPI release];
            [_upLoader uploadItem:item];
        }];
    }
}

- (void)uploadFolder:(_Nonnull id<DownloadAndUploadDelegate>)item
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            NSMutableArray *allfileArray = [NSMutableArray array];
            [self createFolder:[item localPath] parent:[item uploadParent] AllChildArray:allfileArray];
            [item setChildArray:allfileArray];
            long long  totalSize = [[item.childArray valueForKeyPath:@"@sum.fileSize"] longLongValue];
            [item setFileSize:totalSize];
            [allfileArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id <DownloadAndUploadDelegate> childItem = obj;
                childItem.parent = item;
            }];
            [self uploadItems:allfileArray];
        }
    });
}

- (void)createFolder:(NSString *)localPath parent:(NSString *)parent AllChildArray:(NSMutableArray *)allfileArray
{
    NSString *folderName = [localPath lastPathComponent];
    NSDictionary *dic = [self createFolder:folderName parent:parent];
    NSString *subparent = nil;
    if ([dic objectForKey:@"id"]) {
        subparent = [dic objectForKey:@"id"];
    }
    //创建文件夹成功之后 开始遍历本地的这个文件目录
    NSArray *content = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localPath error:nil];
    NSString *sublocalPath = nil;
    for (NSString *fileName in content) {
        if ([fileName rangeOfString:@".DS_Store"].location != NSNotFound) {
            continue;
        }
        sublocalPath = [localPath stringByAppendingPathComponent:fileName];
        if ([[[NSFileManager defaultManager] attributesOfItemAtPath:sublocalPath error:nil] fileType] == NSFileTypeDirectory) {
            //如果是文件夹
            [self createFolder:sublocalPath parent:subparent AllChildArray:allfileArray];
        } else if ([[[NSFileManager defaultManager] attributesOfItemAtPath:sublocalPath error:nil] fileType] == NSFileTypeRegular) {
            //如果是文件
            DownLoadAndUploadItem *upLoadItme = [[DownLoadAndUploadItem alloc] init];
            upLoadItme.fileName = fileName;
            upLoadItme.localPath = sublocalPath;
            upLoadItme.uploadParent = subparent;
            upLoadItme.fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:sublocalPath error:nil] fileSize];
            [allfileArray addObject:upLoadItme];
            [upLoadItme release];
        }
    }
}

//看是否需要执行token刷新，如果需要刷新token，则刷新token之后再进行操作
- (void)performActionWithFreshTokens:(RefreshTokenAction)refreshAction
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL result = NO;
        if (_isFromLocalOAuth) {
            result = [self refreshAccessToken];
            if (refreshAction != nil) {
                refreshAction(result);
            }
        }else{
            BOOL result = NO;
            NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
            NSDate *expirationDate = [self expirationDate];
            NSTimeInterval time = [expirationDate timeIntervalSinceDate:nowDate];
            if (time < 60) {
                result = [self refreshTokenWithDrive];
            }else {
                result = YES;
            }
            if (!result) {
                NSDictionary *dict = @{@"RefreshTokenInvalid": @"请重新授权OneDrive"};
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshTokenInvalid object:nil userInfo:dict];
            }
            if (refreshAction != nil) {
                refreshAction(result);
            }
        }
    });
}

- (BOOL)refreshAccessToken
{
    //首先判断当前访问令牌是否可用
    __block BOOL result = NO;
    if (![self isAuthValid]) {
        //令牌已经过期 需要刷新令牌
        __block BOOL iswait = YES;
    __block BaseDrive *weakSelf = self;
    __block NSThread *currentthread = [NSThread currentThread];
        OneDriveRefreshTokenAPI *refreshToken = [[OneDriveRefreshTokenAPI alloc] initWithClientID:kClientIDWithOneDrive redirectUri:kRedirectURIWithOneDrive clientSecret:nil refreshToken:_refreshToken];
        __block YTKRequest *weakrefreshTokenAPI = refreshToken;
        [refreshToken startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            id content = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:NULL];
            if ([content isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)content;
                if ([[dic allKeys] containsObject:@"access_token"]) {
                    NSString *accessToken = [dic objectForKey:@"access_token"];
                    NSString *refreshToken = [dic objectForKey:@"refresh_token"];
                    NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:3600];
                    self.expirationDate = expirationDate;
                    self.accessToken = accessToken;
                    self.refreshToken = refreshToken;
                    if ([_delegate respondsToSelector:@selector(driveDidLogIn:)]) {
                        [_delegate driveDidLogIn:self];
                    }
                    result = YES;
                }
            }
            iswait = NO;
            [weakrefreshTokenAPI release];
            [weakSelf performSelector:@selector(refreshTokenWait) onThread:currentthread withObject:nil waitUntilDone:NO];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            iswait = NO;
            [weakrefreshTokenAPI release];
            [weakSelf performSelector:@selector(refreshTokenWait) onThread:currentthread withObject:nil waitUntilDone:NO];
        }];
        while (iswait) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
   }
    return result;
}
- (void)refreshTokenWait{}

#pragma mark -- 判断当前的Token有效期
- (BOOL)isExecute {
    if (_isFromLocalOAuth) {
        return [self refreshAccessToken];
    }else{
        BOOL result = NO;
        NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSDate *expirationDate = [self expirationDate];
        NSTimeInterval time = [expirationDate timeIntervalSinceDate:nowDate];
        if (time < 60) {
            result = [self refreshTokenWithDrive];
        }else {
            result = YES;
        }
        if (!result) {
            NSDictionary *dict = @{@"RefreshTokenInvalid": @"请重新授权OneDrive"};
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshTokenInvalid object:nil userInfo:dict];
        }
        return result;
    }
}

#pragma mark -- 刷新令牌状态
- (BOOL)refreshTokenWithDrive {
    __block BOOL result = NO;
    //请求刷新令牌
    if (_userLoginToken) {
        __block BOOL isWait = YES;
        [self refreshToken:_userLoginToken withDriveID:[self driveID] success:^(DriveAPIResponse *response) {
            result = YES;
            isWait = NO;
        } fail:^(DriveAPIResponse *response) {
            result = NO;
            isWait = NO;
        }];
        while (isWait) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        return result;
    }else {
        NSLog(@"用户已退出");
        return result;
    }
}
#pragma mark -- 执行刷新令牌
- (void)refreshToken:(NSString *)token withDriveID:(NSString *)driveID success:(Callback)success fail:(Callback)fail {
    YTKRequest *requestAPI = [[RefreshTokenAPI alloc] initWithUserLoginToken:token withDriveID:driveID];
    __block YTKRequest *weakRequestAPI = requestAPI;
    [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        ResponseCode code = [self checkResponseTypeWithSuccess:request];
        if (code == ResponseSuccess) {
            NSDictionary *tmpDict = nil;
            if ([[request responseJSONObject] isKindOfClass:[NSDictionary class]]) {
                tmpDict = (NSDictionary *)[request responseJSONObject];
                NSString *driveID = [tmpDict objectForKey:@"id"];
                if ([[self driveID] isEqualToString:driveID]) {
                    self.accessToken = [tmpDict objectForKey:@"token"];
                    NSString *dateStr = [tmpDict objectForKey:@"expires_at"];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *date = [[formatter dateFromString:dateStr] dateByAddingTimeInterval:8 * 60 * 60];
                    self.expirationDate = date;
                    [formatter release];
                    formatter = nil;
                    [self driveSetAccessTokenKey];
                }
            }
            NSString *codeStr = [[request userInfo] objectForKey:@"AuthValidRefreshToken"];
            NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
            DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
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
        ResponseCode code = [self checkResponseTypeWithFailed:request];
        NSString *codeStr = [[request userInfo] objectForKey:@"errorMessage"];
        NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
        DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
        fail?fail(response):nil;
        [response release];
        [weakRequestAPI release];
    }];
}

#pragma mark -- 激活已授权的云服务状态
- (void)driveSetAccessTokenKey {
    //保存数据到本地
    NSDictionary *dic = [NSDictionary dictionaryWithObject:self.accessToken forKey:kAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:kAppAuthOneDriveStateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -- 取消激活已授权的云服务状态
- (void)driveGetAccessTokenKey {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kAppAuthOneDriveStateKey];
    if ([dic objectForKey:kAccessTokenKey]) {
        self.accessToken = [dic objectForKey:kAccessTokenKey];
    }
}

#pragma mark -- 移除已授权的云服务状态
- (void)driveRemoveAccessTokenKey {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAppAuthOneDriveStateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self logOut];
}

@end

