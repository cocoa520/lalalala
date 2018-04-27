//
//  iCloudDriveCreateFolderAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/31.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "iCloudDriveCreateFolderAPI.h"

@implementation iCloudDriveCreateFolderAPI

- (id)initWithFolderName:(NSString *)folderName Parent:(NSString *)parent dsid:(NSString *)dsid cookie:(NSMutableDictionary *)cookie iCloudDriveURL:(NSString *)url
{
    if (self = [super initWithFolderName:folderName Parent:parent accessToken:nil]) {
        _dsid = [dsid retain];
        _iCloudDriveUrl = [url retain];
        _cookie = [cookie retain];
    }
    return self;
}

- (NSString *)baseUrl
{
    return _iCloudDriveUrl;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = [NSString stringWithFormat:@"createFolders?dsid=%@",_dsid] ;
    return url;
}

- (id)requestArgument
{
    if ([_parent isEqualToString:@"0"]) {
        return @{@"destinationDrivewsId":@"FOLDER::com.apple.CloudDocs::root",@"folders":@[@{@"clientId":[BaseDriveAPI createGUID],@"name":_folderName}]};
    }else {
        return @{@"destinationDrivewsId":_parent,@"folders":@[@{@"clientId":[BaseDriveAPI createGUID],@"name":_folderName}]};
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
