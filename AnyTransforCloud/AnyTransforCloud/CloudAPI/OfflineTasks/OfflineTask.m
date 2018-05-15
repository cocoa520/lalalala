//
//  OfflineTask.m
//  DriveSync
//
//  Created by JGehry on 2018/4/28.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "OfflineTask.h"
#import "GetOfflineTaskRunningListAPI.h"
#import "GetOfflineTaskWaitingListAPI.h"
#import "GetOfflineTaskCompletedListAPI.h"
#import "CreateOfflineTaskAPI.h"
#import "CancelOfflineTaskAPI.h"
#import "RemoveOfflineTaskAPI.h"
#import "ModifyOfflineTaskAPI.h"
#import "ClearOfflineTaskAPI.h"

@implementation OfflineTask

- (void)getStatusList:(OfflineStatus)status success:(Callback)success fail:(Callback)fail {
    YTKRequest *requestAPI = nil;
    switch (status) {
        case OfflineTaskWaiting:
            requestAPI = [[GetOfflineTaskWaitingListAPI alloc] initWithUserLoginToken:_userLoginToken];
            break;
        case OfflineTaskRunning:
            requestAPI = [[GetOfflineTaskRunningListAPI alloc] initWithUserLoginToken:_userLoginToken];
            break;
        case OfflineTaskCompleted:
            requestAPI = [[GetOfflineTaskCompletedListAPI alloc] initWithUserLoginToken:_userLoginToken];
            break;
        case OfflineTaskClear:
            requestAPI = [[ClearOfflineTaskAPI alloc] initWithUserLoginToken:_userLoginToken];
            break;
        default:
            break;
    }
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

- (void)createOfflineTask:(NSArray *)offlineTaskAry success:(Callback)success fail:(Callback)fail {
    if ([offlineTaskAry count] > 0) {
        NSMutableArray *mutRequestArray = [[NSMutableArray alloc] init];
        YTKRequest *requestAPI = nil;
        for (NSDictionary *itemDict in offlineTaskAry) {
            NSString *name = [itemDict objectForKey:@"name"];
            NSString *source_drive_id = [itemDict objectForKey:@"source_drive_id"];
            NSString *target_drive_id = [itemDict objectForKey:@"target_drive_id"];
            NSArray *source_path = [itemDict objectForKey:@"source_path"];
            NSString *target_path = [itemDict objectForKey:@"target_path"];
            NSString *type = [itemDict objectForKey:@"type"];
            NSString *mode = [itemDict objectForKey:@"mode"];
            NSString *scope = [itemDict objectForKey:@"scope"];
            NSString *conflict = [itemDict objectForKey:@"conflict"];
            NSString *frequency = [itemDict objectForKey:@"frequency"];
            NSString *execute_time = [itemDict objectForKey:@"execute_time"];
            requestAPI = [[CreateOfflineTaskAPI alloc] initWithOfflineTaskName:name withSourceDriveID:source_drive_id withTargetDriveID:target_drive_id withSourceFolderOrFileID:source_path withTargetFolderOrFileID:target_path withType:type withMode:mode withScope:scope withConflict:conflict withFrequency:frequency withExecuteTime:execute_time userLoginToken:_userLoginToken];
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
                NSLog(@"codeStr: %@", codeStr);
//                NSData *data = [codeStr dataUsingEncoding:NSUTF8StringEncoding];
                DriveAPIResponse *response = [[DriveAPIResponse alloc] initWithResponseData:nil status:code];
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

- (void)modifyOfflineTask:(NSArray *)offlineTaskAry success:(Callback)success fail:(Callback)fail {
    if ([offlineTaskAry count] > 0) {
        NSMutableArray *mutRequestArray = [[NSMutableArray alloc] init];
        YTKRequest *requestAPI = nil;
        for (NSDictionary *itemDict in offlineTaskAry) {
            NSString *name = [itemDict objectForKey:@"name"];
            NSString *type = [itemDict objectForKey:@"type"];
            NSString *mode = [itemDict objectForKey:@"mode"];
            NSString *scope = [itemDict objectForKey:@"scope"];
            NSString *conflict = [itemDict objectForKey:@"conflict"];
            NSString *frequency = [itemDict objectForKey:@"frequency"];
            NSString *execute_time = [itemDict objectForKey:@"execute_time"];
            requestAPI = [[ModifyOfflineTaskAPI alloc] initWithOfflineTaskName:name withSourceDriveID:nil withTargetDriveID:nil withSourceFolderOrFileID:nil withTargetFolderOrFileID:nil withType:type withMode:mode withScope:scope withConflict:conflict withFrequency:frequency withExecuteTime:execute_time userLoginToken:_userLoginToken];
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

- (void)removeOrCancelOfflineTaskID:(NSString *)offlineTaskID withType:(OfflineStatus)type success:(Callback)success fail:(Callback)fail {
    YTKRequest *requestAPI = nil;
    switch (type) {
        case OfflineTaskCancel:
            requestAPI = [[CancelOfflineTaskAPI alloc] initWithOfflineTaskID:offlineTaskID userLoginToken:_userLoginToken];
            break;
        case OfflineTaskRemove:
            requestAPI = [[RemoveOfflineTaskAPI alloc] initWithOfflineTaskID:offlineTaskID userLoginToken:_userLoginToken];
        default:
            break;
    }
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

- (ResponseCode)checkResponseTypeWithSuccess:(YTKBaseRequest * _Nonnull)response {
    if ([response responseData]) {
        if ([response responseJSONObject] && [[response responseJSONObject] isKindOfClass:[NSDictionary class]]) {
            if ([[[response responseJSONObject] allKeys] containsObject:@"errors"]) {
                id obj = [[response responseJSONObject] objectForKey:@"errors"];
                if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *objDict = (NSDictionary *)obj;
                    NSEnumerator *enumerator = [objDict keyEnumerator];
                    NSString *obj = nil;
                    while (obj = [enumerator nextObject]) {
                        NSString *errorMessage = [objDict objectForKey:obj];
                        if (errorMessage) {
                            [response setUserInfo:@{@"errorMessage": errorMessage}];
                        }
                    }
                    return ResponseInvalid;
                }else {
                    return ResponseUnknown;
                }
            }else {
                return ResponseSuccess;
            }
        }else {
            return ResponseSuccess;
        }
    }else {    
        return ResponseSuccess;
    }
}

@end
