//
//  iCloudDriveValidateAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/2/24.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "iCloudDriveValidateAPI.h"

@implementation iCloudDriveValidateAPI

- (id)initWithCookie:(NSMutableDictionary *)cookie
{
    if (self = [super init]) {
        _cookie = [cookie retain];
    }
    return self;
}

- (NSString *)baseUrl
{
    return iCloudDriveValidateBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = iCloudDriveValidatePath;
    return url;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{@"Origin":@"https://www.icloud.com",@"Content-Type":@"text/plain"}];
    [dic addEntriesFromDictionary:_cookie];
    return dic;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}
@end
