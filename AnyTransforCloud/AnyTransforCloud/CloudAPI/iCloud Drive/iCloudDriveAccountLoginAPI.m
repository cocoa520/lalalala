//
//  iCloudDriveAccountLoginAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/26.
//  Copyright © 2018年 imobie. All rights reserved.
//

/**
 *  完成所有用户名 密码 安全码人认证之后 进行最后一步账户登录。
 */

#import "iCloudDriveAccountLoginAPI.h"

@implementation iCloudDriveAccountLoginAPI
@synthesize xappleSesionToken = _xappleSesionToken;

- (id)initWithXappleSessionToken:(NSString *)sessionToken clientID:(NSString *)clientID rememberMe:(BOOL)rememberMe;
{
    if (self = [super init]) {
        _xappleSesionToken = [sessionToken retain];
        _clientID = [clientID retain];
        _rememberMe = rememberMe;
    }
    return self;
}

- (NSString *)baseUrl
{
    return iCloudDriveAuthAcountLoginBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = [NSString stringWithFormat:iCloudDriveAuthAcountLoginPath,@"17HHotfix8",_clientID,@"17HHotfix8"];
    return url;
}

- (id)requestArgument
{
    return @{@"dsWebAuthToken":_xappleSesionToken,@"extended_login":@(_rememberMe)};
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    return @{@"Content-Type":@"text/plain",@"Origin":@"https://www.icloud.com",@"Refer":@"https://www.icloud.com/"};
}

- (void)dealloc
{
    [_xappleSesionToken release],_xappleSesionToken = nil;
    [super dealloc];
}

@end
