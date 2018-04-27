//
//  iCloudDriveUploadTwoAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/2/2.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "iCloudDriveUploadTwoAPI.h"

@implementation iCloudDriveUploadTwoAPI

- (id)initWithUploadURL:(NSString *)uploadUrl
{
    if (self = [super init]) {
        _uploadUrl = [uploadUrl retain];
    }
    return self;
}

- (NSString *)baseUrl
{
    return _uploadUrl;
}

- (NSString *)requestUrl
{
    return @"";
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{@"Origin":@"https://www.icloud.com"}];
    return dic;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (void)dealloc
{
    [_uploadUrl retain],_uploadUrl = nil;
    [super dealloc];
}

@end
