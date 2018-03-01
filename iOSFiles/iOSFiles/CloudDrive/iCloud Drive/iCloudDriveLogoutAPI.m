//
//  iCloudDriveLogoutAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/2/8.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "iCloudDriveLogoutAPI.h"

@implementation iCloudDriveLogoutAPI

- (id)initWithClientID:(NSString *)clientID proxyDest:(NSString *)proxyDest dsid:(NSString *)dsid cookie:(NSMutableDictionary *)cookie
{
    if (self = [super init]) {
        _clientID = [clientID retain];
        _proxyDest = [proxyDest retain];
        _dsid = [dsid retain];
        _cookie = [cookie retain];
    }
    return self;
}

- (NSString *)baseUrl
{
    return iCloudDriveLogoutBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = [NSString stringWithFormat:@"setup/ws/1/logout?clientId=%@&dsid=%@&proxyDest=%@",_clientID,_dsid,_proxyDest];
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
    return YTKRequestMethodPOST;
}

- (void)dealloc
{
    [_proxyDest release],_proxyDest = nil;
    [super dealloc];
}

@end
