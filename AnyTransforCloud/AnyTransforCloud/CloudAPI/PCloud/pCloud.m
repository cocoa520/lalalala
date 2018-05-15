//
//  pCloud.m
//  DriveSync
//
//  Created by 罗磊 on 2018/3/20.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "pCloud.h"
#import "pCloudGetUserInfoAPI.h"
#import "pCloudGetListAPI.h"
#import "pCloudCreateFolderAPI.h"
#import "pCloudReNameAPI.h"
#import "pCloudMoveToNewParentAPI.h"
#import "pCloudCopyItemAPI.h"
#import "pCloudDeleteItemAPI.h"
#import "pCloudgetFileLinkAPI.h"
#import "pCloudUploadAPI.h"

NSString *const kClientIDWithpCloud = @"t6UwgT3z6K0";
NSString *const kClientSecretWithpCloud = @"bREHcoCvkE7AVGnHUBud2468o14k";
NSString *const kRedirectURIWithpCloud = @"http://127.0.0.1:58240/";
NSString *const kSuccessURLStringWithpCloud = @"https://www.baidu.com";
NSString *const OAuthorizationEndpointWithpCloud = @"https://my.pcloud.com/oauth2/authorize";
NSString *const TokenEndpointWithpCloud = @"https://api.pcloud.com/oauth2_token";

@implementation pCloud

- (instancetype)init{
    if (self = [super init]) {
        _queue = dispatch_queue_create("pClouddownloadsync", 0);
    }
    return self;
}

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
        NSURL *authorizationEndpoint =
        [NSURL URLWithString:OAuthorizationEndpointWithpCloud];
        NSURL *tokenEndpoint =
        [NSURL URLWithString:TokenEndpointWithpCloud];
        NSURL *successURL = [NSURL URLWithString:kSuccessURLStringWithpCloud];
        _redirectHTTPHandler = [[OIDRedirectHTTPHandler alloc] initWithSuccessURL:successURL];
        NSURL *redirectURI = [_redirectHTTPHandler startHTTPListener:nil];
        OIDServiceConfiguration *configuration =
        [[OIDServiceConfiguration alloc] initWithAuthorizationEndpoint:authorizationEndpoint
                                                         tokenEndpoint:tokenEndpoint];
        OIDAuthorizationRequest *request =
        [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                      clientId:kClientIDWithpCloud
                                                  clientSecret:kClientSecretWithpCloud
                                                        scopes:nil
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
- (void)getAccount:(NSString *)accountID success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            YTKRequest *requestAPI = [[pCloudGetUserInfoAPI alloc] initWithItemID:nil accessToken:_accessToken];
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
            YTKRequest *requestAPI = [[pCloudGetListAPI alloc] initWithItemID:folerID accessToken:_accessToken];
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
            YTKRequest *requestAPI = [[pCloudCreateFolderAPI alloc] initWithFolderName:folderName Parent:parentID accessToken:_accessToken];
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

- (void)copyToNewParentIDOrPath:(NSString *)newParentIdOrPath idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            if ([idOrPathArray count] > 0) {
                NSMutableArray *mutRequestArray = [[NSMutableArray alloc] init];
                BaseDriveAPI *requestAPI = nil;
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
                                requestAPI = [[pCloudCopyItemAPI alloc] initWithItemID:key newParentIDOrPath:value parent:nil accessToken:_accessToken];
                                [mutRequestArray addObject:requestAPI];
                                [requestAPI release];
                            }
                        }
                    }else {
                        requestAPI = [[pCloudCopyItemAPI alloc] initWithItemID:itemID newParentIDOrPath:newParentIdOrPath parent:nil accessToken:_accessToken];
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
        }
    }];
}

- (void)reName:(NSString *)newName idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if ([idOrPathArray count] > 0) {
            NSDictionary *dict = [idOrPathArray objectAtIndex:0];
            NSString *itemID = [dict objectForKey:@"itemIDOrPath"];
            BOOL isFolder = [[dict objectForKey:@"isFolder"] boolValue];
            BaseDriveAPI *requestAPI = [[pCloudReNameAPI alloc] initWithNewName:newName idOrPath:itemID accessToken:_accessToken];
            [requestAPI setIsFolder:isFolder];
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

- (void)moveToNewParentIDOrPath:(NSString *)newParentIdOrPath idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            if ([idOrPathArray count] > 0) {
                NSMutableArray *mutRequestArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in idOrPathArray) {
                    NSString *itemID = [dict objectForKey:@"fromItemIDOrPath"];
                    BOOL isFolder = [[dict objectForKey:@"isFolder"] boolValue];
                    BaseDriveAPI *requestAPI = [[pCloudMoveToNewParentAPI alloc] initWithItemID:itemID newParentIDOrPath:newParentIdOrPath parent:nil accessToken:_accessToken];
                    [requestAPI setIsFolder:isFolder];
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
        }
    }];
}

- (void)deleteFilesOrFolders:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if ([idOrPathArray count] > 0) {
            NSMutableArray *mutRequestArray = [[NSMutableArray alloc] init];
            for (NSDictionary *itemDic in idOrPathArray ) {
                NSString *itemID = [itemDic objectForKey:@"itemIDOrPath"];
                BOOL isFolder = [[itemDic objectForKey:@"isFolder"] boolValue];
                BaseDriveAPI *requestAPI = [[pCloudDeleteItemAPI alloc] initWithItemID:itemID accessToken:_accessToken];
                [requestAPI setIsFolder:isFolder];
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
    }];
}

- (void)createNewFolderWithID:(NSString *)newfolderID newfolderName:(NSString *)newfolderName sourceFolderID:(NSString *)folderID withAllChildArray:(NSMutableArray *)allfileArray {
    NSDictionary *folderDict = [self createFolder:newfolderName parent:newfolderID];
    if ([[folderDict allKeys] count] > 0) {
        NSDictionary *tmpDict = [folderDict objectForKey:@"metadata"];
        NSString *newFolderID = [tmpDict objectForKey:@"folderid"];
        NSDictionary *dict = [self getList:folderID];
        if ([dict allKeys] > 0) {
            if ([[dict allKeys] containsObject:@"metadata"]) {
                NSDictionary *contentsDict = [dict objectForKey:@"metadata"];
                if ([[contentsDict allKeys] containsObject:@"contents"]) {
                    NSArray *itemAry = [contentsDict objectForKey:@"contents"];
                    for (NSDictionary *itemDict in itemAry) {
                        if ([[itemDict allKeys] containsObject:@"size"]) {
                            NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
                            NSString *itemID = [itemDict objectForKey:@"fileid"];
                            [mutDict setObject:newFolderID forKey:itemID];
                            [allfileArray addObject:mutDict];
                            [mutDict release];
                            mutDict = nil;
                        }else {
                            NSString *folderName = [itemDict objectForKey:@"name"];
                            NSString *sourceFolderID = [itemDict objectForKey:@"folderid"];
                            [self createNewFolderWithID:newFolderID newfolderName:folderName sourceFolderID:sourceFolderID withAllChildArray:allfileArray];
                        }
                    }
                }
            }
        }
    }
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
                //第一步先获取下载链接
                dispatch_async(_queue, ^{
                    @autoreleasepool {
                        pCloudgetFileLinkAPI *downloadAPI = [[pCloudgetFileLinkAPI alloc] initWithItemID:[item itemIDOrPath] accessToken:_accessToken];
                        __block YTKRequest *weakdownloadAPI = downloadAPI;
                        __block BOOL iswait = YES;
                        __block BaseDrive *weakSelf = self;
                        __block NSThread *currentthread = [NSThread currentThread];
                        [downloadAPI startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                            iswait = NO;
                            [weakSelf performSelector:@selector(createFolderWait) onThread:currentthread withObject:nil waitUntilDone:NO];
                            if (request.responseStatusCode == 200) {
                                //解析返回结果
                                if (request.responseData) {
                                    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:NULL];
                                    NSString *path = [resultDic objectForKey:@"path"];
                                    NSArray *hostArray = [resultDic objectForKey:@"hosts"];
                                    if ([hostArray count]>=1) {
                                        NSString *host = [hostArray objectAtIndex:0];
                                        NSString *url = [[@"http://"  stringByAppendingString:host] stringByAppendingString:path];
                                        item.urlString = url;
                                        item.httpMethod = @"GET";
                                        [_downLoader downloadItem:item completionHandler:^(NSURL * _Nullable filePath, NSError * _Nullable error) {
                                            //todo 完成回调
                                        }];
                                    }else{
                                        item.state = DownloadStateError;
                                    }
                                }else{
                                    item.state = DownloadStateError;
                                }
                            }else{
                                item.state = DownloadStateError;
                            }
                            [weakdownloadAPI release];
                        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                            item.state = DownloadStateError;
                            iswait = NO;
                            [weakSelf performSelector:@selector(createFolderWait) onThread:currentthread withObject:nil waitUntilDone:NO];
                            [weakdownloadAPI release];
                        }];
                        while (iswait) {
                            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                        }
                    }
                });
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
    NSString *folderPath = [_downLoader.downloadPath stringByAppendingString:parentPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    //解析列表
    NSMutableArray *childArray = [self parseListDic:dic];
    for (NSDictionary *childDic in childArray) {
        if ([[childDic objectForKey:@"isfolder"] boolValue]) {
            //是文件夹
            NSString *folderID = [childDic objectForKey:@"id"];
            NSString *foderName = [childDic objectForKey:@"name"];
            NSString *path = [parentPath stringByAppendingPathComponent:foderName];
            [self getAllFile:folderID AllChildArray:allChildArray parentPath:path];
        }else{
            //构建downloaditem
            DownLoadAndUploadItem *item = [[DownLoadAndUploadItem alloc] init];
            item.itemIDOrPath = [[childDic objectForKey:@"id"] stringValue];
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
    NSDictionary *metadataDic = [content objectForKey:@"metadata"];
    NSArray *valueArray = [metadataDic objectForKey:@"contents"];
    for (NSDictionary *dic in valueArray) {
        NSMutableDictionary *childDic = [NSMutableDictionary dictionary];
        for (NSString *key in dic.allKeys) {
            if ([key isEqualToString:@"fileid"]) {
                [childDic setObject:[dic objectForKey:@"fileid"] forKey:@"id"];
            }else if ([key isEqualToString:@"name"]){
                [childDic setObject:[dic objectForKey:@"name"] forKey:@"name"];
            }else if ([key isEqualToString:@"isfolder"]){
                [childDic setObject:[dic objectForKey:@"isfolder"] forKey:@"isfolder"];
            }else if ([key isEqualToString:@"size"]){
                [childDic setObject:[dic objectForKey:@"size"] forKey:@"size"];
            }else if ([key isEqualToString:@"folderid"]){
                [childDic setObject:[dic objectForKey:@"folderid"] forKey:@"id"];
            }
        }
        [childArray addObject:childDic];
    }
    return childArray;
}

- (ResponseCode)checkResponseTypeWithSuccess:(YTKBaseRequest *)request
{
    if (request.responseStatusCode == 200) {
        if (request.responseData) {
            NSDictionary *resultDic = [[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:NULL] retain];
            if ([resultDic.allKeys containsObject:@"error"]) {
                NSString *errorMessage = [resultDic objectForKey:@"error"];
                [request setUserInfo:@{@"errorMessage": errorMessage}];
                NSInteger errorCode = [[resultDic objectForKey:@"result"] integerValue];
                if (errorCode == 2004) {
                    return ResponseItemAlreadyExists;
                }else if (errorCode == 1004) {
                    return ResponseItemNotExists;
                }else{
                    return ResponseUnknown;
                }
            }
        }
        return ResponseSuccess;
    }else if (request.responseStatusCode == 204 || request.responseStatusCode == 205){
        return ResponseTokenInvalid;
    }else if (request.responseStatusCode == 401){
        return ResponseTokenInvalid;
    }else if (request.responseStatusCode == 400){
        return ResponseInvalid;
    }else{
        return ResponseUnknown;
    }
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
            pCloudUploadAPI *requestAPI = [[pCloudUploadAPI alloc] initWithFileName:[item fileName] Parent:[item uploadParent] accessToken:_accessToken];
            item.requestAPI = requestAPI;
            item.isConstructingData = YES;
            __block pCloud *weakSelf = self;
            [_upLoader uploadmutilPartItem:item success:^(__kindof YTKBaseRequest * _Nonnull request) {
                item.state = UploadStateComplete;
                //如果是文件夹
                if (item.parent != nil) {
                    id <DownloadAndUploadDelegate> parentItem = item.parent;
                    NSPredicate *cate1 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateComplete];
                    NSArray *completeArray = [parentItem.childArray filteredArrayUsingPredicate:cate1];
                    NSPredicate *cate2 =[NSPredicate predicateWithFormat:@"self.state=%d",UploadStateError];
                    NSArray *errorArray = [parentItem.childArray filteredArrayUsingPredicate:cate2];
                    if ([completeArray count] + [errorArray count] == [parentItem.childArray count]) {
                        parentItem.state = UploadStateComplete;
                    }
                }
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
            [requestAPI release];
        }
    }];
}

- (void)uploadFolder:(_Nonnull id<DownloadAndUploadDelegate>)item
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            NSMutableArray *allfileArray = [NSMutableArray array];
            [self createFolder:[item localPath] parent:[item uploadParent] AllChildArray:allfileArray];
            if ([allfileArray count] > 0) {
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
            }else {
                item.state = UploadStateError;
            }
        }
    });
}

- (void)createFolder:(NSString *)localPath parent:(NSString *)parent AllChildArray:(NSMutableArray *)allfileArray
{
    NSString *folderName = [localPath lastPathComponent];
    NSDictionary *dic = [self createFolder:folderName parent:parent];
    if ([[dic allKeys] count] > 0 && ![[dic allKeys] containsObject:@"error"]) {
        NSDictionary *metaDataDic = [dic objectForKey:@"metadata"];
        NSString *subparent = nil;
        if ([metaDataDic objectForKey:@"folderid"]) {
            subparent = [metaDataDic objectForKey:@"folderid"];
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
    }else {
        
    }
}

- (void)performActionWithFreshTokens:(RefreshTokenAction)refreshAction
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (refreshAction != nil) {
            refreshAction(YES);
        }
    });
}


@end
