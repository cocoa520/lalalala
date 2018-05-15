//
//  iCloudDriveGetListAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/30.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "iCloudDriveGetListAPI.h"

@implementation iCloudDriveGetListAPI

- (NSString *)baseUrl
{
    return _iCloudDriveUrl;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = @"retrieveItemDetailsInFolders";
    return url;
}

- (id)requestArgument
{
    if ([_folderOrfileID isEqualToString:@"0"]) {
        return @[@{@"drivewsid":@"FOLDER::com.apple.CloudDocs::root",@"partialData":@(0),@"includeHierarchy": @(1)}];
    }else{
        return @[@{@"drivewsid":_folderOrfileID,@"partialData":@(0)}];
    }
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{@"Content-Type":@"text/plain",@"Origin":@"https://www.icloud.com"}];
    [dic addEntriesFromDictionary:_cookie];
    return dic;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

@end
