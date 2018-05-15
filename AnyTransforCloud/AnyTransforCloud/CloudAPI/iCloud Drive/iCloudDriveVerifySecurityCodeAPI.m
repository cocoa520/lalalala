//
//  iCloudDriveVerifySecurityCodeAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/26.
//  Copyright © 2018年 imobie. All rights reserved.
//
/**
 *  此类主要是用作2fa二次验证的 验证安全码
 */
#import "iCloudDriveVerifySecurityCodeAPI.h"

@implementation iCloudDriveVerifySecurityCodeAPI

- (id)initWithSecurityCode:(NSString *)securityCode sessionID:(NSString *)sessionID scnt:(NSString *)scnt
{
    if (self = [super init]) {
        _securityCode = [securityCode retain];
        _xappleidSessionID = [sessionID retain];
        _scnt = [scnt retain];
    }
    return self;
}

- (NSString *)baseUrl
{
    return iCloudDriveAuthSinginBaseURL;
}

- (NSString *)requestUrl
{
    NSString *url = nil;
    url = iCloudDriveGetAndVerifySecuritycodePath;
    return url;
}

- (id)requestArgument
{
    return @{@"securityCode":@{@"code":_securityCode}};
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    return @{@"Accept":@"application/json",@"X-Apple-Widget-Key":@"83545bf919730e51dbfba24e7e8a78d2",@"X-Apple-ID-Session-Id":_xappleidSessionID,@"scnt":_scnt};
}

- (void)dealloc
{
    [_securityCode release],_securityCode = nil;
    [_xappleidSessionID release],_xappleidSessionID = nil;
    [_scnt release],_scnt = nil;
    [super dealloc];
}
@end
