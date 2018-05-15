//
//  iCloudDriveGetSMSSecuritycodeAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/3/2.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "iCloudDriveGetSMSSecuritycodeAPI.h"

@implementation iCloudDriveGetSMSSecuritycodeAPI

- (id)initWithAppleSessionID:(NSString *)appleSessionID scnt:(NSString *)scnt;
{
    if (self = [super init]) {
        _xappleidSessionID = [appleSessionID retain];
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
    url = iCloudDriveGetSMSAndVerifySecuritycodePath;
    return url;
}

- (id)requestArgument
{
    return @{@"phoneNumber":@{@"id":@(1)},@"mode":@"sms"};
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPUT;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    return @{@"Accept":@"application/json, text/javascript, */*; q=0.01",@"X-Apple-Widget-Key":@"83545bf919730e51dbfba24e7e8a78d2",@"X-Apple-ID-Session-Id":_xappleidSessionID,@"scnt":_scnt};
}


- (void)dealloc
{
    [_xappleidSessionID release],_xappleidSessionID = nil;
    [_scnt release],_scnt = nil;
    [super dealloc];
}
@end
