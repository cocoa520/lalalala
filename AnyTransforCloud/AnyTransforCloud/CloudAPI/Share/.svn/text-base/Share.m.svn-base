//
//  Share.m
//  AnyTransforCloud
//
//  Created by JGehry on 2018/4/27.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "Share.h"
#import "GetShareListAPI.h"
#import "AdditionalShareAPI.h"
#import "ModifyShareAPI.h"
#import "RemoveShareAPI.h"
#import "SendEmailShareAPI.h"

@implementation Share

- (void)getListWithPageLimit:(int)pageLimit withPageIndex:(int)pageIndex success:(Callback)success fail:(Callback)fail {
    YTKRequest *requestAPI = [[GetShareListAPI alloc] initWithItemLimit:pageLimit withPageIndex:pageIndex userLoginToken:_userLoginToken];
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

- (void)addShare:(BaseDrive *)baseDrive idOrPathArray:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
    if ([idOrPathArray count] > 0) {
        NSMutableArray *mutRequestArray = [[NSMutableArray alloc] init];
        YTKRequest *requestAPI = nil;
        for (NSDictionary *itemDict in idOrPathArray) {
            NSString *itemID = [itemDict objectForKey:@"itemIDOrPath"];
            BOOL isFolder = [[itemDict objectForKey:@"isFolder"] boolValue];
            int maxDownload = [[itemDict objectForKey:@"maxDownload"] intValue];
            NSString *shareExpireAt = [itemDict objectForKey:@"shareExpireAt"];
            NSString *sharePassword = [itemDict objectForKey:@"sharePassword"];
            NSString *albumID = nil;
            if ([[itemDict allKeys] containsObject:@"albumID"]) {
                albumID = [itemDict objectForKey:@"albumID"];
            }
            requestAPI = [[AdditionalShareAPI alloc] initWithDriveID:baseDrive.driveID withFileOrFolderID:itemID withIsFolder:isFolder withMaxDownload:maxDownload withShareExpireAt:shareExpireAt withSharePassword:sharePassword withAlbumID:albumID userLoginToken:_userLoginToken];
            [mutRequestArray addObject:requestAPI];
            [requestAPI release];
            requestAPI = nil;
        }
        YTKBatchRequest *batchRequestAPI = [[YTKBatchRequest alloc] initWithRequestArray:mutRequestArray];
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

- (void)modifyShare:(NSArray *)idOrPathArray success:(Callback)success fail:(Callback)fail {
    if ([idOrPathArray count] > 0) {
        NSMutableArray *mutRequestArray = [[NSMutableArray alloc] init];
        YTKRequest *requestAPI = nil;
        for (NSDictionary *itemDict in idOrPathArray) {
            NSString *shareID = [itemDict objectForKey:@"collectionOrShareID"];
            int maxDownload = [[itemDict objectForKey:@"maxDownload"] intValue];
            NSString *shareExpireAt = [itemDict objectForKey:@"shareExpireAt"];
            NSString *sharePassword = [itemDict objectForKey:@"sharePassword"];
            NSString *albumID = nil;
            if ([[itemDict allKeys] containsObject:@"albumID"]) {
                albumID = [itemDict objectForKey:@"albumID"];
            }
            requestAPI = [[AdditionalShareAPI alloc] initWithDriveID:nil withFileOrFolderID:shareID withIsFolder:NO withMaxDownload:maxDownload withShareExpireAt:shareExpireAt withSharePassword:sharePassword withAlbumID:albumID userLoginToken:_userLoginToken];
            [mutRequestArray addObject:requestAPI];
            [requestAPI release];
            requestAPI = nil;
        }
        YTKBatchRequest *batchRequestAPI = [[YTKBatchRequest alloc] initWithRequestArray:mutRequestArray];
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

- (void)deleteCollectionOrShareID:(NSArray *)collectionOrShareIDArray success:(Callback)success fail:(Callback)fail {
    if ([collectionOrShareIDArray count] > 0) {
        NSMutableArray *mutRequestArray = [[NSMutableArray alloc] init];
        YTKRequest *requestAPI = nil;
        for (NSDictionary *itemDict in collectionOrShareIDArray) {
            NSString *itemID = [itemDict objectForKey:@"collectionOrShareID"];
            requestAPI = [[RemoveShareAPI alloc] initWithShareID:itemID userLoginToken:_userLoginToken];
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

- (void)sendEmailShare:(NSString *)shareID success:(Callback)success fail:(Callback)fail {
    YTKRequest *requestAPI = [[SendEmailShareAPI alloc] initWithShareID:shareID userLoginToken:nil];
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

@end
