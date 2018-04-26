//
//  iCloudDriveAuthSigninAPI.m
//  DriveSync
//
//  Created by 罗磊 on 2018/1/17.
//  Copyright © 2018年 imobie. All rights reserved.
//

/**
 * 此类主要是用作登录的第一步验证 需要用户提供用户名和密码
 */

#import "iCloudDriveAuthSigninAPI.h"

@implementation iCloudDriveAuthSigninAPI

- (instancetype)initWithEmail:(NSString *)email withPassword:(NSString *)password rememberMe:(BOOL)rememberMe
{
    if (self = [super initWithEmail:email withPassword:password]) {
        _rememberMe = rememberMe;
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
    url = iCloudDriveAuthSinginPath;
    return url;
}

- (id)requestArgument
{
    return @{@"accountName":_userEmail,@"password":_userPassword,@"rememberMe":@(_rememberMe),@"trustTokens":@[]};
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    return @{@"Accept":@"application/json, text/javascript, */*; q=0.01",@"X-Apple-Widget-Key":@"83545bf919730e51dbfba24e7e8a78d2"};
}
@end
