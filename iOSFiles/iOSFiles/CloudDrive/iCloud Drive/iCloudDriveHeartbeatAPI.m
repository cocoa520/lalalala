//
//  iCloudDriveHeartbeatAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/2/8.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "iCloudDriveHeartbeatAPI.h"

@implementation iCloudDriveHeartbeatAPI

- (id)initWithPushUrl:(NSString *)pushUrl dsid:(NSString *)dsid cookie:(NSMutableDictionary *)cookie
{
    if (self = [super init]) {
        _iCloudPushUrl = [pushUrl retain];
        _dsid = [dsid retain];
        _cookie = [cookie retain];
    }
    return self;
}

- (NSString *)baseUrl
{
    return _iCloudPushUrl;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = [NSString stringWithFormat:@"/refreshWebAuth?dsid=%@",_dsid];
    return url;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:@{@"Origin":@"https://www.icloud.com",@"Content_Type":@"text/plain"}];
    [dic addEntriesFromDictionary:_cookie];
    return dic;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

- (void)dealloc
{
    [_iCloudPushUrl release],_iCloudPushUrl = nil;
    [super dealloc];
}

@end
