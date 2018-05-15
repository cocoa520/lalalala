//
//  Box.m
//  DriveSync
//
//  Created by JGehry on 12/22/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "Box.h"
#import "BoxUserAccountAPI.h"
#import "BoxCreateFolderAPI.h"
#import "BoxDeleteItemAPI.h"
#import "BoxGetListAPI.h"
#import "BoxGetListItemAPI.h"
#import "BOxGetFolderAPI.h"
#import "BoxSearchAPI.h"
#import "BoxUploadAPI.h"
#import "BoxCreateSessionAPI.h"
#import "BoxMoveToNewParentAPI.h"
#import "BoxReNameAPI.h"
#import "BoxCopyItemAPI.h"
#import "IMBNotificationDefine.h"

NSString *const kClientIDWithBox = @"oqdvrueaihef7y0r41r4e1hj4gtuptnx";
NSString *const kClientSecretWithBox = @"pUD0uQXo3MEUenEJI9MT135oPVAhLT5X";
NSString *const kRedirectURIWithBox = @"oqdvrueaihef7y0r41r4e1hj4gtuptnx://auth";
NSString *const OAuthorizationEndpointWithBox = @"https://account.box.com/api/oauth2/authorize";
NSString *const TokenEndpointWithBox = @"https://api.box.com/oauth2/token";

@implementation Box

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_PROCESS_COUNT object:nil];
    [super dealloc];
}

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
        
        NSArray *scope = @[@"root_readwrite",@"manage_managed_users",@"manage_app_users"];
        NSURL *authorizationEndpoint =
        [NSURL URLWithString:OAuthorizationEndpointWithBox];
        NSURL *tokenEndpoint =
        [NSURL URLWithString:TokenEndpointWithBox];
        OIDServiceConfiguration *configuration =
        [[OIDServiceConfiguration alloc] initWithAuthorizationEndpoint:authorizationEndpoint
                                                         tokenEndpoint:tokenEndpoint];
        OIDAuthorizationRequest *request =
        [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                      clientId:kClientIDWithBox
                                                  clientSecret:kClientSecretWithBox
                                                        scopes:scope
                                                   redirectURL:[NSURL URLWithString:kRedirectURIWithBox]
                                                  responseType:OIDResponseTypeCode
                                          additionalParameters:nil];
        [configuration release];
        configuration = nil;
        // performs authentication request
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

- (void)getAccount:(NSString *)accountID success:(Callback)success fail:(Callback)fail {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showProcessCount:) name:NOTIFY_PROCESS_COUNT object:nil];
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            YTKRequest *requestAPI = [[BoxUserAccountAPI alloc] initWithUserAccountID:accountID accessToken:_accessToken];
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

- (void)createFolder:(NSString *)folderName parent:(NSString *)parentID success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            YTKRequest *requestAPI = [[BoxCreateFolderAPI alloc] initWithFolderName:folderName Parent:parentID accessToken:_accessToken];
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

- (void)getList:(NSString *)folerID success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            YTKRequest *requestAPI = [[BoxGetListAPI alloc] initWithItemID:folerID accessToken:_accessToken];
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

- (void)getListItem:(NSString *)folerID success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            YTKRequest *requestAPI = [[BoxGetListItemAPI alloc] initWithItemID:folerID accessToken:_accessToken];
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
            YTKRequest *requestAPI = [[BOxGetFolderAPI alloc] initWithItemID:folerID accessToken:_accessToken];
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
            if ([tmpPageIndex isEqualToString:@""] || [tmpPageIndex isEqualToString:@"0"]) {
                tmpPageIndex = nil;
            }
            YTKRequest *requestAPI = [[BoxSearchAPI alloc] initWithUserLoginToken:self.userLoginToken withDriveID:self.driveID withSearchName:query withSearchLimit:tmpLimit withSearchPageIndex:tmpPageIndex];
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
                for (NSDictionary *itemDict in idOrPathArray) {
                    NSString *itemID = [itemDict objectForKey:@"itemIDOrPath"];
                    BOOL isFolder = [[itemDict objectForKey:@"isFolder"] boolValue];
                    YTKRequest *requestAPI = [[BoxDeleteItemAPI alloc] initWithItemID:itemID accessToken:_accessToken withIsFolder:isFolder];
                    [mutRequestArray addObject:requestAPI];
                    [requestAPI release];
                    requestAPI = nil;
                }
                YTKBatchRequest *batchRequestAPI = [[YTKBatchRequest alloc] initWithRequestArray:mutRequestArray];
                [mutRequestArray release];
                mutRequestArray = nil;
                __block YTKBatchRequest *weakBatchRequestAPI = batchRequestAPI;
                [batchRequestAPI startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
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
                    [weakBatchRequestAPI release];
                } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
                    //to do需要更具返回值判断错误
                    YTKRequest *request = [batchRequest failedRequest];
                    ResponseCode code = [self checkResponseTypeWithFailed:request];
                    NSString *codeStr = [[request userInfo] objectForKey:@"errorMessage"];
                    NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
                    DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:data status:code];
                    fail?fail(response):nil;
                    [response release];
                    [weakBatchRequestAPI release];
                }];
            }
        }
    }];
}

- (void)copyToNewParentIDOrPath:(NSString *)newParentIdOrPath idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            NSMutableArray *mutRequestArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in idOrPathArray) {
                NSString *itemID = [dict objectForKey:@"fromItemIDOrPath"];
                BOOL isFolder = [[dict objectForKey:@"isFolder"] boolValue];
                BaseDriveAPI *requestAPI = [[BoxCopyItemAPI alloc] initWithItemID:itemID newParentIDOrPath:newParentIdOrPath name:nil accessToken:_accessToken];
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
    }];
}

- (void)reName:(NSString *)newName idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            if ([idOrPathArray count] > 0) {
                NSDictionary *dict = [idOrPathArray objectAtIndex:0];
                NSString *itemID = [dict objectForKey:@"itemIDOrPath"];
                BOOL isFolder = [[dict objectForKey:@"isFolder"] boolValue];
                BaseDriveAPI *requestAPI = [[BoxReNameAPI alloc] initWithNewName:newName idOrPath:itemID accessToken:_accessToken];
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
        }
    }];
}

- (void)moveToNewParentIDOrPath:(NSString *)newParentIdOrPath idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
    [self performActionWithFreshTokens:^(BOOL refresh) {
        if (refresh) {
            NSMutableArray *mutRequestArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in idOrPathArray) {
                NSString *itemID = [dict objectForKey:@"fromItemIDOrPath"];
                NSString *name = [dict objectForKey:@"fromName"];
                BOOL isFolder = [[dict objectForKey:@"isFolder"] boolValue];
                BaseDriveAPI *requestAPI = [[BoxMoveToNewParentAPI alloc] initWithItemID:itemID newParentIDOrPath:newParentIdOrPath name:name accessToken:_accessToken];
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
    }];
}

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
                NSString *urlString = [BoxAPIBaseURL stringByAppendingPathComponent:[NSString stringWithFormat:BoxDownloadFilePath,item.itemIDOrPath]];
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
            [self getAllFile:item.itemIDOrPath AllChildArray:allfileArray parentPath:[NSString stringWithFormat:@"/%@",item.fileName] withItem:item];
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

- (void)getAllFile:(NSString *)folderID  AllChildArray:(NSMutableArray *)allChildArray parentPath:(NSString *)parentPath withItem:(_Nonnull id<DownloadAndUploadDelegate>)items
{
    NSDictionary *dic = [self getList:folderID];
    NSString *folderPath = [_downLoader.downloadPath stringByAppendingString:parentPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ([[dic allKeys] containsObject:@"item_collection"]) {
        NSDictionary *itemDict = [dic objectForKey:@"item_collection"];
//        int totalCount = 0;
//        if ([[itemDict allKeys] containsObject:@"total_count"]) {
//            totalCount = [[itemDict objectForKey:@"total_count"] intValue];
//        }
        if ([[dic allKeys] containsObject:@"type"]) {
            if ([[dic objectForKey:@"type"] isEqualToString:@"folder"]) {
                [items setFileSize:[[dic objectForKey:@"size"] longLongValue]];
            }
        }
        //解析列表
        NSMutableArray *childArray = [self parseListDic:itemDict];
        for (NSDictionary *childDic in childArray) {
            if ([[childDic objectForKey:@"folder"] isEqualToString:@"folder"]) {
                //是文件夹
                NSString *folderID = [childDic objectForKey:@"id"];
                NSString *foderName = [childDic objectForKey:@"name"];
                NSString *path = [parentPath stringByAppendingPathComponent:foderName];
                [self getAllFile:folderID AllChildArray:allChildArray parentPath:path withItem:items];
            }else{
                NSString *fileID = [childDic objectForKey:@"id"];
                NSDictionary *dic = [self getFile:fileID AllChildArray:allChildArray parentPath:parentPath];
                //构建downloaditem
                DownLoadAndUploadItem *item = [[DownLoadAndUploadItem alloc] init];
                item.itemIDOrPath = [dic objectForKey:@"id"];
                item.fileName = [dic objectForKey:@"name"];
                item.fileSize = [[dic objectForKey:@"size"] longLongValue];
                item.parentPath = parentPath;
                [allChildArray addObject:item];
                [item release];
            }
        }
    }
}

- (NSDictionary *)getFile:(NSString *)fileID AllChildArray:(NSMutableArray *)allChildArray parentPath:(NSString *)parentPath {
    __block NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    __block BOOL iswait = YES;
    __block BaseDrive *weakSelf = self;
    __block NSThread *currentthread = [NSThread currentThread];
    [self getListItem:fileID success:^(DriveAPIResponse *response) {
        [dic setDictionary:response.content];
        iswait = NO;
        [weakSelf performSelector:@selector(createFolderWait) onThread:currentthread withObject:nil waitUntilDone:NO];
    } fail:^(DriveAPIResponse *response) {
        iswait = NO;
    }];
    while (iswait) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return dic;
}

- (void)createFolderWait{}

- (NSMutableArray <NSDictionary *> *)parseListDic:(NSDictionary *)content
{
    NSMutableArray *childArray = [NSMutableArray array];
    NSArray *valueArray = [content objectForKey:@"entries"];
    for (NSDictionary *dic in valueArray) {
        NSMutableDictionary *childDic = [NSMutableDictionary dictionary];
        for (NSString *key in dic.allKeys) {
            if ([key isEqualToString:@"id"]) {
                [childDic setObject:[dic objectForKey:@"id"] forKey:@"id"];
            }else if ([key isEqualToString:@"name"]){
                [childDic setObject:[dic objectForKey:@"name"] forKey:@"name"];
            }else if ([key isEqualToString:@"type"]){
                [childDic setObject:[dic objectForKey:@"type"] forKey:@"folder"];
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
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                @autoreleasepool {
                    _activeUploadCount++;
                    item.state = UploadStateLoading;
                    if (item.parent != nil) {
                        id <DownloadAndUploadDelegate> parentItem = item.parent;
                        parentItem.state = UploadStateLoading;
                    }
                    __block Box *weakSelf = self;
                    if ([self isHasBigFile:[item localPath] withItem:item]) {
                        @try {
                            YTKRequest *requestAPI = [[BoxCreateSessionAPI alloc] initWithFileName:[item fileName] fileSize:[item fileSize] Parent:[item uploadParent] accessToken:_accessToken];
                            [item setRequestAPI:requestAPI];
                            [requestAPI release];
                            [_upLoader uploadItem:item  success:^(__kindof YTKBaseRequest * _Nonnull request) {
                                
                            } fail:^(__kindof YTKBaseRequest * _Nonnull request) {
                                
                            }];
                            while ([item isBigFile]) {
                                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                            }
                            //请求完成后，检查当前任务状态
                            [self checkUploadStatus:item];
                            NSDictionary *jsonObject = nil;
                            if ([[[item requestAPI] responseJSONObject] isKindOfClass:[NSDictionary class]]) {
                                jsonObject = (NSDictionary *)[[item requestAPI] responseJSONObject];
                                int totalParts = 0;
                                if ([[jsonObject allKeys] containsObject:@"total_parts"]) {
                                    totalParts = [[jsonObject objectForKey:@"total_parts"] intValue];
                                }
                                int partSize = 0;
                                if ([[jsonObject allKeys] containsObject:@"part_size"]) {
                                    partSize = [[jsonObject objectForKey:@"part_size"] intValue];
                                }
                                for (int i = 0; i < totalParts; i++) {
                                    if ([self isExecute]) {
                                        [item setIsBigFile:YES];
                                        YTKRequest *requestAPI = [[BoxUploadAPI alloc] initWithFileSize:[item fileSize] fileStart:(i * partSize) fileEnd:partSize * i + partSize - 1  accessToken:_accessToken];
                                        [item setRequestAPI:requestAPI];
                                        [item setIsConstructingData:YES];
                                        [requestAPI release];
                                        if (i == totalParts - 1) {
                                            [item setConstructingDataDriveName:BoxCSEndPointURL];
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
                                        }
                                    }
                                }
                            }
                        } @catch (NSException *exception) {
                            //捕获了上传文件异常，在主线程中跳出提示警告
                            dispatch_sync(_synchronQueue, ^{
                                [weakSelf removeUploadTaskForItem:item];
                                [weakSelf startNextTaskIfAllow];
                            });
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //刷新UI界面
                                NSLog(@"Upload Exception: %@", exception.description);
                            });
                        } @finally {
                            NSLog(@"Upload Completed");
                        }
                    }else {
                        @try {
                            [item setIsBigFile:YES];
                            YTKRequest *requestAPI = [[BoxUploadAPI alloc] initWithFileSize:[item fileSize] fileStart:0 fileEnd:[item fileSize] - 1  accessToken:_accessToken];
                            [item setRequestAPI:requestAPI];
                            [item setIsConstructingData:YES];
                            [item setConstructingDataDriveName:BoxCSEndPointURL];
                            [requestAPI release];
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
                    }
                }
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
            if ([allfileArray count] > 0) {
                [self uploadItems:allfileArray];
            }else{
                item.progress = 100;
                item.state = UploadStateComplete;
            }
        }
    });
}

- (BOOL)isHasBigFile:(NSString *)filePath withItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    BOOL result = NO;
    uint64_t fileSize = 0;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath isDirectory:NO]) {
        NSDictionary *attributes = [fm attributesOfItemAtPath:filePath error:nil];
        if ([[attributes allKeys] containsObject:NSFileSize]) {
            if ([[attributes objectForKey:NSFileSize] isKindOfClass:[NSNumber class]]) {
                fileSize = [[attributes objectForKey:NSFileSize] longValue];
                [item setFileSize:fileSize];
            }
        }
        if (fileSize > 50000000) {
            [item setIsBigFile:YES];
            result = YES;
        }else {
            [item setIsBigFile:NO];
        }
    }
    return result;
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
            NSDictionary *dict = @{@"RefreshTokenInvalid": @"请重新授权Box"};
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
                    [Date release];
                    Date = nil;
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
- (ResponseCode)checkResponseTypeWithSuccess:(YTKBaseRequest * _Nonnull)response {
    if ([response responseData]) {
        if ([response responseJSONObject] && [[response responseJSONObject] isKindOfClass:[NSDictionary class]]) {
            if ([[[response responseJSONObject] allKeys] containsObject:@"url"]) {
                NSString *url = nil;
                url = [[response responseJSONObject] objectForKey:@"url"];
                if (url) {
                    [response setUserInfo:@{@"bindURL": url}];
                }
                return ResponseSuccess;
            }else if ([[[response responseJSONObject] allKeys] containsObject:@"error"]) {
                NSDictionary *errorDict = [[response responseJSONObject] objectForKey:@"error"];
                NSString *errorStr = [errorDict objectForKey:@"code"];
                NSString *errorMessage = nil;
                errorMessage = [errorDict objectForKey:@"message"];
                if ([errorStr rangeOfString:@"InvalidAuthenticationToken"].location != NSNotFound) {
                    if (errorMessage) {
                        [response setUserInfo:@{@"errorMessage": errorMessage}];
                    }
                    return ResponseTokenInvalid;
                }else if ([errorStr rangeOfString:@"The request timed out."].location != NSNotFound) {
                    if (errorMessage) {
                        [response setUserInfo:@{@"errorMessage": errorMessage}];
                    }
                    return ResponseTimeOut;
                }else if ([errorStr rangeOfString:@"invalidRequest"].location != NSNotFound) {
                    if (errorMessage) {
                        [response setUserInfo:@{@"errorMessage": errorMessage}];
                    }
                    return ResponseInvalid;
                }else {
                    if (errorMessage) {
                        [response setUserInfo:@{@"errorMessage": errorMessage}];
                    }
                    return ResponseUnknown;
                }
            }else if ([[[response responseJSONObject] allKeys] containsObject:@"errors"]) {
                NSString *errorMessage = [[response responseJSONObject] objectForKey:@"message"];
                if (errorMessage) {
                    [response setUserInfo:@{@"errorMessage": errorMessage}];
                }
                return ResponseInvalid;
            }else if ([[[response responseJSONObject] allKeys] containsObject:@"expires_in"]) {
                NSString *successStr = [[response responseJSONObject] objectForKey:@"token"];
                self.accessToken = successStr;
                [response setUserInfo:@{@"AuthValidRefreshToken": @"Valid refresh token authorization succeeded"}];
                return ResponseSuccess;
            }else if ([[[response responseJSONObject] allKeys] containsObject:@"token"]) {
                NSString *successStr = [[response responseJSONObject] objectForKey:@"token"];
                self.userLoginToken = successStr;
                [response setUserInfo:@{@"AuthValidToken": @"Valid token authorization succeeded"}];
                return ResponseSuccess;
            }else if ([[[response responseJSONObject] allKeys] containsObject:@"context_info"]) {
                if ([[[response responseJSONObject] allKeys] containsObject:@"message"]) {
                    NSString *errorMessage = [[response responseJSONObject] objectForKey:@"message"];
                    if (errorMessage) {
                        [response setUserInfo:@{@"errorMessage": errorMessage}];
                    }
                }
                return ResponseInvalid;
            }else {
                return ResponseSuccess;
            }
        }else if ([response responseJSONObject] && [[response responseJSONObject] isKindOfClass:[NSArray class]]) {
            return ResponseSuccess;
        }else if ([response responseString] && [[response responseString] isKindOfClass:[NSString class]]) {
            NSString *errorStr = [response responseString];
            if ([errorStr rangeOfString:@"access token"].location != NSNotFound) {
                [response setUserInfo:@{@"errorMessage": @"The given OAuth 2 access token is malformed"}];
                return ResponseTokenInvalid;
            }else if ([errorStr isEqualToString:@""]) {
                return ResponseSuccess;
            }else {
                if (errorStr) {
                    [response setUserInfo:@{@"errorMessage": errorStr}];
                }
                return ResponseUnknown;
            }
        }else {
            return ResponseUnknown;
        }
    }else if ([[response error] localizedDescription]) {
        NSString *errorDescription = [[response error] localizedDescription];
        NSError *errorCode = [response error];
        if ([errorDescription isEqualToString:@"InvalidAuthenticationToken"]) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseTokenInvalid;
        }else if ([errorDescription isEqualToString:@"invalidRequest"]) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseInvalid;
        }else if (errorCode.code == -1001) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseTimeOut;
        }else if (errorCode.code == -1009) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseNotConnectedToInternet;
        }else if (errorCode.code == -1005) {
            [response setUserInfo:@{@"errorMessage": errorDescription}];
            return ResponseNetworkConnectionLost;
        }else {
            return ResponseUnknown;
        }
    }else {
        return ResponseUnknown;
    }
}

- (void)showProcessCount:(NSNotification *)notify {
    NSDictionary *dict = notify.userInfo;
    NSLog(@"success Count: %d", [[dict objectForKey:@"processCount"] intValue]);
}

@end
