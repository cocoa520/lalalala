//
//  iCloudDriveUsedStorageAPI.m
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/20.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "iCloudDriveUsedStorageAPI.h"

@implementation iCloudDriveUsedStorageAPI

- (NSString *)baseUrl
{
    return iCloudDriveAuthAcountLoginBaseURL;
}

- (NSString *)requestUrl
{
    return [NSString stringWithFormat:iCloudDriveUsedStorage, _dsid];
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{@"Origin":@"https://www.icloud.com", @"Referer":@"https://www.icloud.com"}];
    [dic addEntriesFromDictionary:_cookie];
    return dic;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

@end
