//
//  OneDrive.m
//  DriveSync
//
//  Created by 罗磊 on 2017/11/30.
//  Copyright © 2017年 imobie. All rights reserved.
//

#import "OneDrive.h"
#import "OneDUserAccountAPI.h"
#import "OneDDeleteItemAPI.h"
#import "OneDCreateFolderAPI.h"
#import "OneDGetListAPI.h"
#import "OneDGetFolderAPI.h"
#import "OneDSearchAPI.h"
#import "OneDDownloadAPI.h"
#import "OneDUploadAPI.h"
#import "OneDCreateSessionAPI.h"
#import "OneDUploadSessionAPI.h"
#import "OneDReNameAPI.h"
#import "OneDMoveToNewParentAPI.h"
#import "OneDCopyItemAPI.h"
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
- (void)getAccount:(NSString *)accountID success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            YTKRequest *requestAPI = [[OneDUserAccountAPI alloc] initWithUserAccountID:accountID accessToken:_accessToken];
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
        if (refresh) {
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
        }
    }];
}

- (void)getFolderInfo:(NSString *)folerID success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            YTKRequest *requestAPI = [[OneDGetFolderAPI alloc] initWithItemID:folerID accessToken:_accessToken];
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

- (void)searchContent:(NSString *)query withLimit:(NSString *)limit withPageIndex:(NSString *)pageIndex success:(Callback)success fail:(Callback)fail {
    __block NSString *tmpLimit = limit;
    __block NSString *tmpPageIndex = pageIndex;
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            if ([tmpLimit isEqualToString:@""] || [tmpLimit isEqualToString:@"0"] || !tmpLimit) {
                tmpLimit = @"20";
            }
            if ([tmpPageIndex isEqualToString:@""] || [tmpPageIndex isEqualToString:@"0"] || !tmpPageIndex) {
                tmpPageIndex = nil;
            }
            YTKRequest *requestAPI = [[OneDSearchAPI alloc] initWithUserLoginToken:self.userLoginToken withDriveID:self.driveID withSearchName:query withSearchLimit:tmpLimit withSearchPageIndex:tmpPageIndex];
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

- (void)deleteFilesOrFolders:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            if ([idOrPathArray count] > 0) {
                NSMutableArray *mutRequestArray = [[NSMutableArray alloc] init];
                for (NSDictionary *itemDict in idOrPathArray ) {
                    NSString *itemID = [itemDict objectForKey:@"itemIDOrPath"];
                    YTKRequest *requestAPI = [[OneDDeleteItemAPI alloc] initWithItemID:itemID accessToken:_accessToken];
                    [mutRequestArray addObject:requestAPI];
                    [requestAPI release];
                }
                YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:mutRequestArray];
                [mutRequestArray release];
                mutRequestArray = nil;
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
                    YTKRequest *request = [batchRequest failedRequest];
                    ResponseCode code = [self checkResponseTypeWithFailed:request];
                    NSString *codeStr = [[request userInfo] objectForKey:@"errorMessage"];
                    NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
                    DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
                    fail?fail(response):nil;
                    [response release];
                    [weakBatchRequest release];
                }];
            }
        }
    }];
}

- (void)copyToNewParentIDOrPath:(NSString *)newParentIdOrPath idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            NSMutableArray *mutRequestArray = [[NSMutableArray alloc] init];
            for (NSDictionary *itemDict in idOrPathArray) {
                NSString *itemID = [itemDict objectForKey:@"fromItemIDOrPath"];
                NSString *targetItemDriveID = [[itemID componentsSeparatedByString:@"!"] objectAtIndex:0];
                YTKRequest *requestAPI = [[OneDCopyItemAPI alloc] initWithItemID:itemID newParentIDOrPath:newParentIdOrPath newParentDriveID:targetItemDriveID accessToken:_accessToken];
                [mutRequestArray addObject:requestAPI];
                [requestAPI release];
            }
            YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:mutRequestArray];
            [mutRequestArray release];
            mutRequestArray = nil;
            __block YTKBatchRequest *weakBatchRequest = batchRequest;
            [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
                NSMutableArray *mutArray = [[NSMutableArray alloc] init];
                for (BaseDriveAPI *api in batchRequest.requestArray) {
                    [mutArray addObject:[api responseData]];
                }
                NSData *requestData = [NSKeyedArchiver archivedDataWithRootObject:mutArray];
                DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:requestData status:ResponseSuccess];
                success?success(response):nil;
                [response release];
                [weakBatchRequest release];
            } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
                //to do需要更具返回值判断错误
                YTKRequest *request = [batchRequest failedRequest];
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

- (void)reName:(NSString *)newName idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            if ([idOrPathArray count] > 0) {
                NSDictionary *dict = [idOrPathArray objectAtIndex:0];
                NSString *itemID = [dict objectForKey:@"itemIDOrPath"];
                YTKRequest *requestAPI = [[OneDReNameAPI alloc] initWithNewName:newName idOrPath:itemID accessToken:_accessToken];
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
    }];
}

- (void)moveToNewParentIDOrPath:(NSString *)newParentIdOrPath idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            NSMutableArray *mutRequestArray = [[NSMutableArray alloc] init];
            for (NSDictionary *itemDict in idOrPathArray) {
                NSString *itemID = [itemDict objectForKey:@"fromItemIDOrPath"];
                YTKRequest *requestAPI = [[OneDMoveToNewParentAPI alloc] initWithItemID:itemID newParentIDOrPath:newParentIdOrPath parent:nil accessToken:_accessToken];
                [mutRequestArray addObject:requestAPI];
                [requestAPI release];
            }
            YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:mutRequestArray];
            [mutRequestArray release];
            mutRequestArray = nil;
            __block YTKBatchRequest *weakBatchRequest = batchRequest;
            [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
                NSMutableArray *mutArray = [[NSMutableArray alloc] init];
                for (BaseDriveAPI *api in batchRequest.requestArray) {
                    [mutArray addObject:[api responseData]];
                }
                NSData *requestData = [NSKeyedArchiver archivedDataWithRootObject:mutArray];
                DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:requestData status:ResponseSuccess];
                success?success(response):nil;
                [response release];
                [weakBatchRequest release];
            } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
                //to do需要更具返回值判断错误
                YTKRequest *request = [batchRequest failedRequest];
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
            if (refresh) {
                NSString *urlString = [OneDriveEndPointURL stringByAppendingPathComponent:[NSString stringWithFormat:OneDriveDownloadFilePath,item.itemIDOrPath]];
                item.urlString = urlString;
                item.httpMethod = @"GET";
                [_downLoader downloadItem:item completionHandler:^(NSURL * _Nullable filePath, NSError * _Nullable error) {
                    //todo 完成回调
                }];
            }
        }];
    }
}

- (void)startDownload:(_Nonnull id <DownloadAndUploadDelegate>)item completionHandler:(nullable void (^)(NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler
{
    NSString *urlString = [OneDriveEndPointURL stringByAppendingPathComponent:[NSString stringWithFormat:OneDriveDownloadFilePath,item.itemIDOrPath]];
    item.urlString = urlString;
    item.httpMethod = @"GET";
    [_downLoader downloadItem:item completionHandler:completionHandler];

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
            NSArray *sortArray = [item.childArray sortedArrayUsingSelector:@selector(compare:)];
            [sortArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id <DownloadAndUploadDelegate> childItem = obj;
                childItem.parent = item;
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置为等待状态
                item.state = DownloadStateWait;
                if ([sortArray count] > 0) {
                    [self downloadItems:sortArray];
                }else{
                    item.progress = 100;
                    item.state = DownloadStateComplete;
                }
            });
        }
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
        [_uploadArray addObject:item];
        item.state = UploadStateWait;
        dispatch_sync(_synchronQueue, ^{
            if ([self isUploadActivityLessMax]) {
                [self startUploadItem:item];
            }
        });
    }
}

- (void)startUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item
{
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            _activeUploadCount++;
            item.state = UploadStateLoading;
            if (item.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = item.parent;
                parentItem.state = UploadStateLoading;
            }
            __block OneDrive *weakSelf = self;
            YTKRequest *requestAPI = [[OneDCreateSessionAPI alloc] initWithFileName:[item fileName] Parent:[item uploadParent] accessToken:_accessToken];
            __block YTKRequest *weakRequestAPI = requestAPI;
            [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                if ([request responseJSONObject] && [[request responseJSONObject] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *jsonObjectDict = (NSDictionary *)[request responseJSONObject];
                    if ([[jsonObjectDict allKeys] containsObject:@"uploadUrl"]) {
                        NSString *uploadUrl = [jsonObjectDict objectForKey:@"uploadUrl"];
                        
                        __block uint64_t fileSize = 0;
                        NSFileManager *fm = [NSFileManager defaultManager];
                        if ([fm fileExistsAtPath:[item localPath] isDirectory:NO]) {
                            NSDictionary *attributes = [fm attributesOfItemAtPath:[item localPath] error:nil];
                            if ([[attributes allKeys] containsObject:NSFileSize]) {
                                if ([[attributes objectForKey:NSFileSize] isKindOfClass:[NSNumber class]]) {
                                    fileSize = [[attributes objectForKey:NSFileSize] longValue];
                                    [item setFileSize:fileSize];
                                }
                            }
                            
                            /**
                             *  fileBlock: 文件块上传的预设值，约定的上传块数必须是320KB的倍数
                             */
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                @try {
                                    long long fileBlock = 327680 * 32;
                                    if (fileSize > fileBlock) {
                                        int totalCount = (int)(fileSize / fileBlock);
                                        uint64_t start = 0;
                                        uint64_t end = 0;
                                        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:[item localPath]];
                                        [fileHandle seekToFileOffset:0];
                                        if (fileSize % fileBlock != 0) {
                                            for (int i = 0; i < totalCount; i++) {
                                                if ([self isExecute]) {
                                                    [item setIsBigFile:YES];
                                                    start = i * fileBlock;
                                                    end = fileBlock * i + fileBlock - 1;
                                                    YTKRequest *uploadUrlRequestAPI = [[OneDUploadSessionAPI alloc] initWithUploadUrl:uploadUrl fileSize:fileSize fileStart:start fileEnd:end accessToken:_accessToken];
                                                    NSData *data = [fileHandle readDataOfLength:fileBlock];
                                                    [uploadUrlRequestAPI setResumableUploadBodyData:data];
                                                    [item setRequestAPI:uploadUrlRequestAPI];
                                                    [fileHandle seekToFileOffset:fileBlock];
                                                    [uploadUrlRequestAPI release];
                                                    [_upLoader uploadItem:item success:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                        
                                                    } fail:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                        
                                                    }];
                                                    while ([item isBigFile]) {
                                                        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                                                    }
                                                    //请求完成后，检查当前任务状态
                                                    [self checkUploadStatus:item];
                                                    if (i == totalCount - 1) {
                                                        break;
                                                    }
                                                }
                                            }
                                            if ([self isExecute]) {
                                                [item setIsBigFile:YES];
                                                long long residualBlock = (fileSize % fileBlock);
                                                YTKRequest *uploadUrlRequestAPI = [[OneDUploadSessionAPI alloc] initWithUploadUrl:uploadUrl fileSize:fileSize fileStart:(fileSize - residualBlock) fileEnd:fileSize - 1 accessToken:_accessToken];
                                                [fileHandle seekToEndOfFile];
                                                [fileHandle seekToFileOffset:([fileHandle offsetInFile] - residualBlock * sizeof(char))];
                                                NSData *data = [fileHandle readDataToEndOfFile];
                                                [uploadUrlRequestAPI setResumableUploadBodyData:data];
                                                [item setRequestAPI:uploadUrlRequestAPI];
                                                [fileHandle seekToEndOfFile];
                                                [uploadUrlRequestAPI release];
                                                [_upLoader uploadItem:item success:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                    
                                                } fail:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                    
                                                }];
                                                while ([item isBigFile]) {
                                                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                                                }
                                                //请求完成后，检查当前任务状态
                                                [self checkUploadStatus:item];
                                                if (item.state == UploadStateComplete) {
                                                    dispatch_sync(_synchronQueue, ^{
                                                        [weakSelf removeUploadTaskForItem:item];
                                                        [weakSelf startNextTaskIfAllow];
                                                    });
                                                }
                                            }
                                            [weakRequestAPI release];
                                        }else {
                                            NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:[item localPath]];
                                            for (int i = 0; i < totalCount; i++) {
                                                if ([self isExecute]) {
                                                    [item setIsBigFile:YES];
                                                    YTKRequest *uploadUrlRequestAPI = [[OneDUploadSessionAPI alloc] initWithUploadUrl:uploadUrl fileSize:fileSize fileStart:i * fileBlock fileEnd:fileBlock * i + fileBlock - 1 accessToken:_accessToken];
                                                    NSData *data = [fileHandle readDataOfLength:fileBlock];
                                                    [uploadUrlRequestAPI setResumableUploadBodyData:data];
                                                    [item setRequestAPI:uploadUrlRequestAPI];
                                                    [uploadUrlRequestAPI release];
                                                    if (i == totalCount - 1) {
                                                        
                                                    }else {
                                                        [fileHandle seekToFileOffset:fileBlock];
                                                    }
                                                    [_upLoader uploadItem:item success:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                        
                                                    } fail:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                        
                                                    }];
                                                    while ([item isBigFile]) {
                                                        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                                                    }
                                                    //请求完成后，检查当前任务状态
                                                    [self checkUploadStatus:item];
                                                }
                                            }
                                            if (item.state == UploadStateComplete) {
                                                dispatch_sync(_synchronQueue, ^{
                                                    [weakSelf removeUploadTaskForItem:item];
                                                    [weakSelf startNextTaskIfAllow];
                                                });
                                            }
                                            [weakRequestAPI release];
                                        }
                                    }else {
                                        [item setIsBigFile:YES];
                                        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:[item localPath]];
                                        YTKRequest *uploadUrlRequestAPI = [[OneDUploadSessionAPI alloc] initWithUploadUrl:uploadUrl fileSize:fileSize fileStart:0 fileEnd:fileSize - 1 accessToken:_accessToken];
                                        NSData *data = [fileHandle readDataOfLength:fileSize];
                                        [uploadUrlRequestAPI setResumableUploadBodyData:data];
                                        [item setRequestAPI:uploadUrlRequestAPI];
                                        [uploadUrlRequestAPI release];
                                        [_upLoader uploadItem:item success:^(__kindof YTKBaseRequest * _Nonnull request) {
                                            dispatch_sync(_synchronQueue, ^{
                                                [weakSelf removeUploadTaskForItem:item];
                                                [weakSelf startNextTaskIfAllow];
                                            });
                                        } fail:^(__kindof YTKBaseRequest * _Nonnull request) {
                                            
                                        }];
                                        while ([item isBigFile]) {
                                            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                                        }
                                        //请求完成后，检查当前任务状态
                                        [self checkUploadStatus:item];
                                        [weakRequestAPI release];
                                    }
                                } @catch (NSException *exception) {
                                    dispatch_sync(_synchronQueue, ^{
                                        [weakSelf removeUploadTaskForItem:item];
                                        [weakSelf startNextTaskIfAllow];
                                    });
                                    //捕获了上传文件异常，在主线程中跳出提示警告
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        //刷新UI界面
                                        NSLog(@"Upload Exception: %@", exception.description);
                                    });
                                } @finally {
                                    NSLog(@"Upload Completed");
                                }
                            });
                        }
                    }
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                item.state = UploadStateError;
                dispatch_sync(_synchronQueue, ^{
                    [weakSelf removeUploadTaskForItem:item];
                    [weakSelf startNextTaskIfAllow];
                });
                [weakRequestAPI release];
            }];
        }
    }];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                item.state = UploadStateWait;
                if ([allfileArray count] > 0) {
                    [self uploadItems:allfileArray];
                }else{
                    item.progress = 100;
                    item.state = UploadStateComplete;
                }
            });
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
        
    }else{
        result = YES;
    }
    return result;
}
- (void)refreshTokenWait{}

#pragma mark -- 判断当前的Token有效期
- (BOOL)isExecute {
    if (_isFromLocalOAuth) {
        return [self refreshAccessToken];
    }else{
        __block BOOL result = NO;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
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
        });
        return result;
    }
}

#pragma mark -- 刷新令牌状态
- (BOOL)refreshTokenWithDrive {
    __block BOOL result = NO;
    //请求刷新令牌
    if (_userLoginToken) {
        __block BaseDrive *weakSelf = self;
        __block NSThread *currentthread = [NSThread currentThread];
        __block BOOL isWait = YES;
        [self refreshToken:_userLoginToken withDriveID:[self driveID] success:^(DriveAPIResponse *response) {
            result = YES;
            isWait = NO;
            [weakSelf performSelector:@selector(refreshTokenWait) onThread:currentthread withObject:nil waitUntilDone:NO];
        } fail:^(DriveAPIResponse *response) {
            result = NO;
            isWait = NO;
            [weakSelf performSelector:@selector(refreshTokenWait) onThread:currentthread withObject:nil waitUntilDone:NO];

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
                    long longDate = [[tmpDict objectForKey:@"expires_timestamp"] longValue];
                    NSDate *Date = [[NSDate alloc] initWithTimeIntervalSince1970:longDate];
                    self.expirationDate = Date;
                    [self driveSetAccessTokenKey:driveID];
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

#pragma mark -- 检查会话请求状态
- (NSString *)checkRequestStatus:(YTKBaseRequest *)request {
    if ([request responseString]) {
        return request.responseString;
    }else {
        NSError *error = [request error];
        return error.localizedDescription;
    }
}

#pragma mark -- 检查下载或者上传文件状态
- (void)checkUploadStatus:(_Nonnull id<DownloadAndUploadDelegate>)item {
    if ([item state] == UploadStateError) {
        if ([[item requestAPI] responseString]) {
            @throw [NSException exceptionWithName:@"requestException" reason:[[item requestAPI] responseString] userInfo:nil];
        }else {
            NSError *error = [[item requestAPI] error];
            if ([error code] == NSURLErrorNotConnectedToInternet) {
                @throw [NSException exceptionWithName:@"requestNotConnectedToInternetException" reason:[[[item requestAPI] error] localizedDescription] userInfo:nil];
            }else if ([error code] == NSURLErrorNetworkConnectionLost) {
                @throw [NSException exceptionWithName:@"requestNetworkConnectionLostException" reason:[[[item requestAPI] error] localizedDescription] userInfo:nil];
            }
        }
        @throw [NSException exceptionWithName:@"requestUnKnowException" reason:[[[item requestAPI] error] localizedDescription] userInfo:nil];
    }
}

#pragma mark -- 检查请求响应的数据类型
- (ResponseCode)checkResponseTypeWithSuccess:(YTKBaseRequest *)request
{
    if (request.responseStatusCode == 200 || request.responseStatusCode == 201 || request.responseStatusCode == 202 || request.responseStatusCode == 204 || request.responseStatusCode == 205) {
        return ResponseSuccess;
    }else if (request.responseStatusCode == 401){
        return ResponseTokenInvalid;
    }else if (request.responseStatusCode == 400){
        return ResponseInvalid;
    }else if (request.responseStatusCode == 409){
         NSDictionary *resultDic = [[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:NULL] retain];
        if ([resultDic.allKeys containsObject:@"error"]) {
            NSDictionary *errorDic = [resultDic objectForKey:@"error"];
            if ([[errorDic objectForKey:@"code"] isEqualToString:@"nameAlreadyExists"]) {
                return ResponseItemAlreadyExists;
            }
        }
        return ResponseUnknown;
    }else{
        return ResponseUnknown;
    }
}

@end
