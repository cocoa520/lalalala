//
//  iCloudDriveUploadOneAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/2/1.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "iCloudDriveUploadOneAPI.h"

@implementation iCloudDriveUploadOneAPI

- (id)initWithiCloudDriveDocwsUrl:(NSString *)url fileName:(NSString *)fileName mimeType:(NSString *)mimeType fileSize:(long long)fileSize cookie:(NSMutableDictionary *)cookie
{
    if (self = [super init]) {
        _iCloudDriveDocwsUrl = [url retain];
        _cookie = [cookie retain];
        _fileName = [fileName retain];
        _mimeType = [mimeType retain];
        _uploadFileSize = fileSize;
    }
    return self;
}

- (NSString *)baseUrl
{
    return _iCloudDriveDocwsUrl;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = iCloudDriveUploadOnePath;
    return url;
}

- (id)requestArgument
{
    return @{@"filename":_fileName,@"type":@"FILE",@"content_type":_mimeType,@"size":@(_uploadFileSize)};
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{@"Origin":@"https://www.icloud.com"}];
    [dic addEntriesFromDictionary:_cookie];
    return dic;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (void)dealloc
{
    [_iCloudDriveDocwsUrl release],_iCloudDriveDocwsUrl = nil;
    [_mimeType release],_mimeType = nil;
    [super dealloc];
}
@end
