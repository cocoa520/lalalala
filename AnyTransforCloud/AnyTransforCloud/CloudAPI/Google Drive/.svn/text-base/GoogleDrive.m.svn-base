//
//  GoogleDrive.m
//  DriveSync
//
//  Created by JGehry on 12/24/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "GoogleDrive.h"
#import "GoogleDriveUserAccountAPI.h"
#import "GoogleDriveGetListAPI.h"
#import "GoogleDriveGetFolderAPI.h"
#import "GoogleDriveSearchAPI.h"
#import "GoogleDriveDeleteItemAPI.h"
#import "GoogleDriveCreateFolderAPI.h"
#import "GoogleDriveUploadAPI.h"
#import "GoogleDriveUploadAPITwo.h"
#import "GoogleDriveMoveToNewParentAPI.h"
#import "GoogleDriveReNameAPI.h"
#import "GoogleDriveCopyItemAPI.h"

NSString *const kClientIDWithGoogleDrive = @"330226033766-fphcvslq27gmq73ul023uinv2lm60d4o.apps.googleusercontent.com";
NSString *const kClientSecretWithGoogleDrive = @"7iHvJYVOw9wqz4TIPbhdL4nW";
NSString *const kRedirectURIWithGoogleDrive = @"com.googleusercontent.apps.330226033766-fphcvslq27gmq73ul023uinv2lm60d4o:/oauthredirect";
NSString *const OAuthorizationEndpointWithGoogleDrive = @"https://accounts.google.com/o/oauth2/v2/auth";
NSString *const TokenEndpointWithGoogleDrive = @"https://www.googleapis.com/oauth2/v4/token";

@implementation GoogleDrive

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
        
        NSArray *scope = @[@"https://www.googleapis.com/auth/drive",@"https://www.googleapis.com/auth/drive.appdata",@"https://www.googleapis.com/auth/drive.photos.readonly",@"https://picasaweb.google.com/data"];
        NSURL *authorizationEndpoint =
        [NSURL URLWithString:OAuthorizationEndpointWithGoogleDrive];
        NSURL *tokenEndpoint =
        [NSURL URLWithString:TokenEndpointWithGoogleDrive];
        OIDServiceConfiguration *configuration =
        [[OIDServiceConfiguration alloc] initWithAuthorizationEndpoint:authorizationEndpoint
                                                         tokenEndpoint:tokenEndpoint];
        OIDAuthorizationRequest *request =
        [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                      clientId:kClientIDWithGoogleDrive
                                                  clientSecret:kClientSecretWithGoogleDrive
                                                        scopes:scope
                                                   redirectURL:[NSURL URLWithString:kRedirectURIWithGoogleDrive]
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

#pragma mark - business Actions

- (void)getAccount:(NSString *)accountID success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            YTKRequest *requestAPI = [[GoogleDriveUserAccountAPI alloc] initWithUserAccountID:accountID accessToken:_accessToken];
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
            YTKRequest *requestAPI = [[GoogleDriveCreateFolderAPI alloc] initWithFolderName:folderName Parent:parentID accessToken:_accessToken];
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
            YTKRequest *requestAPI = [[GoogleDriveGetListAPI alloc] initWithItemID:folerID accessToken:_accessToken];
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
            YTKRequest *requestAPI = [[GoogleDriveGetFolderAPI alloc] initWithItemID:folerID accessToken:_accessToken];
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
    __block NSString *tmpPageIndex = [pageIndex retain];
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            if ([tmpLimit isEqualToString:@""] || [tmpLimit isEqualToString:@"0"] || !tmpLimit) {
                tmpLimit = @"20";
            }
            if ([tmpPageIndex isKindOfClass:[NSNull class]]) {
                tmpPageIndex = nil;
            }
            if ([tmpPageIndex isEqualToString:@""] || [tmpPageIndex isEqualToString:@"0"]) {
                [tmpPageIndex release];
                tmpPageIndex = nil;
            }
            YTKRequest *requestAPI = [[GoogleDriveSearchAPI alloc] initWithUserLoginToken:self.userLoginToken withDriveID:self.driveID withSearchName:query withSearchLimit:tmpLimit withSearchPageIndex:tmpPageIndex];
            __block YTKRequest *weakRequestAPI = requestAPI;
            if (tmpPageIndex) {
                [tmpPageIndex release];
                tmpPageIndex = nil;
            }
            
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
                    YTKRequest *requestAPI = [[GoogleDriveDeleteItemAPI alloc] initWithItemID:itemID accessToken:_accessToken];
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
            YTKRequest *requestAPI = nil;
            for (NSDictionary *itemDict in idOrPathArray) {
                NSString *itemID = [itemDict objectForKey:@"fromItemIDOrPath"];
                NSString *newParentID = newParentIdOrPath;
                BOOL isFolder = [[itemDict objectForKey:@"isFolder"] boolValue];
                if (isFolder) {
                    NSString *folderName = [itemDict objectForKey:@"fromFolderName"];
                    NSMutableArray *allChildArray = [NSMutableArray array];
                    [self createNewFolderWithID:newParentID newfolderName:folderName sourceFolderID:itemID withAllChildArray:allChildArray];
                    for (NSDictionary *dict in allChildArray) {
                        NSEnumerator *enumerator = [dict keyEnumerator];
                        NSString *key = nil;
                        while (key = [enumerator nextObject]) {
                            NSString *value = [dict objectForKey:key];
                            requestAPI = [[GoogleDriveCopyItemAPI alloc] initWithItemID:key newParentIDOrPath:value parent:nil accessToken:_accessToken];
                            [mutRequestArray addObject:requestAPI];
                            [requestAPI release];
                        }
                    }
                }else {
                    requestAPI = [[GoogleDriveCopyItemAPI alloc] initWithItemID:itemID newParentIDOrPath:newParentID parent:nil accessToken:_accessToken];
                    [mutRequestArray addObject:requestAPI];
                    [requestAPI release];
                }
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
                YTKRequest *requestAPI = [[GoogleDriveReNameAPI alloc] initWithNewName:newName idOrPath:itemID accessToken:_accessToken];
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
                NSString *itemParentID = [itemDict objectForKey:@"fromItemParentID"];
                YTKRequest *requestAPI = [[GoogleDriveMoveToNewParentAPI alloc] initWithItemID:itemID newParentIDOrPath:newParentIdOrPath parent:itemParentID accessToken:_accessToken];
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

#pragma mark -- 检查请求响应的数据类型
//- (ResponseCode)checkResponseTypeWithSuccess:(YTKBaseRequest * _Nonnull)response {
//    ResponseCode code = ResponseSuccess;
//    if ([[response responseJSONObject] isKindOfClass:[NSDictionary class]]) {
//        NSDictionary *reslutDic = [response responseJSONObject];
//        if ([[[response responseJSONObject] allKeys] containsObject:@"error"]) {
//            NSDictionary *errorDic = [reslutDic objectForKey:@"error"];
//            NSString *errorMessage = [errorDic objectForKey:@"message"];
//            if ([errorMessage isEqualToString:@"Invalid Credentials"]) {
//                code = ResponseTokenInvalid;
//            }else if ([errorMessage containsString:@"Invalid"]){
//                code = ResponseInvalid;
//            }else{
//                code = ResponseUnknown;
//            }
//        }
//    }else{
//        code = ResponseUnknown;
//    }
//    return code;
//}

#pragma mark - downloadActions

- (void)downloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item
{
    if (item.isFolder) {
        [_folderItemArray addObject:item];
        [(NSObject *)item addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        [self downloadFolder:item];
    }else {
        [self performActionWithFreshTokens:^(BOOL refresh) {
            if (refresh) {
                NSString *urlString = [GoogleDriveAPIBaseURL stringByAppendingPathComponent:[NSString stringWithFormat:GoogleDriveDownloadFilePath,item.itemIDOrPath]];
                item.urlString = urlString;
                item.httpMethod = @"GET";
                [_downLoader downloadItem:item completionHandler:^(NSURL * _Nullable filePath, NSError * _Nullable error) {
                    //todo 完成回调
                }];
            }
        }];
    }
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
    //解析列表
    NSString *folderPath = [_downLoader.downloadPath stringByAppendingString:parentPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    NSMutableArray *childArray = [self parseListDic:dic];
    for (NSDictionary *childDic in childArray) {
        if ([[childDic objectForKey:@"mimeType"] isEqualToString:@"application/vnd.google-apps.folder"]) {
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
    NSArray *valueArray = [content objectForKey:@"files"];
    for (NSDictionary *dic in valueArray) {
        NSMutableDictionary *childDic = [NSMutableDictionary dictionary];
        for (NSString *key in dic.allKeys) {
            if ([key isEqualToString:@"id"]) {
                [childDic setObject:[dic objectForKey:@"id"] forKey:@"id"];
            }else if ([key isEqualToString:@"name"]){
                [childDic setObject:[dic objectForKey:@"name"] forKey:@"name"];
            }else if ([key isEqualToString:@"mimeType"]){
                [childDic setObject:[dic objectForKey:@"mimeType"] forKey:@"mimeType"];
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
            __block GoogleDrive *weakSelf = self;
            _activeUploadCount++;
            item.state = UploadStateLoading;
            if (item.parent != nil) {
                id <DownloadAndUploadDelegate> parentItem = item.parent;
                parentItem.state = UploadStateLoading;
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                YTKRequest *requestAPI = [[GoogleDriveUploadAPI alloc] initWithFileName:[item fileName] Parent:[item uploadParent] accessToken:_accessToken];
                __block YTKRequest *weakRequestAPI = requestAPI;
                [requestAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        @try {
                            NSDictionary *dictionary = [request.response allHeaderFields];
                            if ([[dictionary allKeys] containsObject:@"Location"]) {
                                [item setIsBigFile:YES];
                                NSString *url = [dictionary objectForKey:@"Location"];
                                YTKRequest *uploadrequestAPI = [[GoogleDriveUploadAPITwo alloc] initWithUploadURLStr:url];
                                [uploadrequestAPI setResumableUploadPath:[item localPath]];
                                [item setRequestAPI:uploadrequestAPI];
                                [uploadrequestAPI release];
                                [_upLoader uploadItem:item success:^(__kindof YTKBaseRequest * _Nonnull request) {
                                    dispatch_sync(_synchronQueue, ^{
                                        [weakSelf removeUploadTaskForItem:item];
                                        [weakSelf startNextTaskIfAllow];
                                    });
                                    
                                } fail:^(__kindof YTKBaseRequest * _Nonnull request) {
                                    dispatch_sync(_synchronQueue, ^{
                                        [weakSelf removeUploadTaskForItem:item];
                                        [weakSelf startNextTaskIfAllow];
                                    });
                                    
                                }];
                                while ([item isBigFile]) {
                                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                                }
                                //请求完成后，检查当前任务状态
                                [self checkUploadStatus:item];
                            }else {
                                [item setState:UploadStateError];
                            }
                        } @catch (NSException *exception) {
                            //捕获了上传文件异常，在主线程中跳出提示警告
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //刷新UI界面
                                NSLog(@"Upload Exception: %@", exception.description);
                            });
                        } @finally {
                            NSLog(@"Upload Completed");
                        }
                    });
                    [weakRequestAPI release];
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [item setState:UploadStateError];
                    dispatch_sync(_synchronQueue, ^{
                        [weakSelf removeUploadTaskForItem:item];
                        [weakSelf startNextTaskIfAllow];
                    });
                    [weakRequestAPI release];
                }];
            });
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

- (void)createNewFolderWithID:(NSString *)newfolderID newfolderName:(NSString *)newfolderName sourceFolderID:(NSString *)folderID withAllChildArray:(NSMutableArray *)allfileArray {
    NSDictionary *folderDict = [self createFolder:newfolderName parent:newfolderID];
    if ([[folderDict allKeys] count] > 0) {
        NSString *newFolderID = [folderDict objectForKey:@"id"];
        NSDictionary *dict = [self getList:folderID];
        if ([dict allKeys] > 0) {
            if ([[dict allKeys] containsObject:@"files"]) {
                NSArray *itemAry = [dict objectForKey:@"files"];
                for (NSDictionary *itemDict in itemAry) {
                    if ([[itemDict allKeys] containsObject:@"size"]) {
                        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
                        NSString *itemID = [itemDict objectForKey:@"id"];
                        [mutDict setObject:newFolderID forKey:itemID];
                        [allfileArray addObject:mutDict];
                        [mutDict release];
                        mutDict = nil;
                    }else {
                        NSString *folderName = [itemDict objectForKey:@"name"];
                        NSString *sourceFolderID = [itemDict objectForKey:@"id"];
                        [self createNewFolderWithID:newFolderID newfolderName:folderName sourceFolderID:sourceFolderID withAllChildArray:allfileArray];
                    }
                }
            }
        }
    }
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

#pragma mark -- 看是否需要执行token刷新，如果需要刷新token，则刷新token之后再进行操作
- (void)performActionWithFreshTokens:(RefreshTokenAction)refreshAction
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
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
    });
}

#pragma mark -- 判断当前的Token有效期
- (BOOL)isExecute {
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
            NSDictionary *dict = @{@"RefreshTokenInvalid": @"请重新授权GoogleDrive"};
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshTokenInvalid object:nil userInfo:dict];
        }
    });
    return result;
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

- (void)refreshTokenWait{}

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

#pragma mark -- 检查下载或者上传文件状态
- (void)checkUploadStatus:(_Nonnull id<DownloadAndUploadDelegate>)item {
    if ([item state] == UploadStateError) {
        if (![[item requestAPI] responseString]) {
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
    if (request.responseStatusCode == 200 || request.responseStatusCode == 204 || request.responseStatusCode == 204) {
        return ResponseSuccess;
    }else if (request.responseStatusCode == 401){
        return ResponseTokenInvalid;
    }else if (request.responseStatusCode == 400){
        return ResponseInvalid;
    }else{
        return ResponseUnknown;
    }
}

@end
