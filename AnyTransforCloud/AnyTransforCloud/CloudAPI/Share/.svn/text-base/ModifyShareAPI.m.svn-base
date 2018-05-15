//
//  ModifyShareAPI.m
//  AnyTransforCloud
//
//  Created by JGehry on 2018/4/27.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "ModifyShareAPI.h"

@implementation ModifyShareAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:SharePath, _folderOrfileID];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", _userLogintoken];
    return @{
             @"Authorization": authorizationHeaderValue,
             @"Client": @"Cloud Drive/1.0.0",
             @"accept": @"application/json"
             };
}

- (id)requestArgument {
    if (_albumID && ![_albumID isEqualToString:@""]) {
        return @{
                 @"max_download": @(_maxDownload),      //最大下载数
                 @"expire_at": _shareExpireAt,          //到期时间
                 @"password": _sharePassword,           //分享密码
                 @"album_id": _albumID                  //googlePhoto需要
                 };
    }else {
        return @{
                 @"max_download": @(_maxDownload),      //最大下载数
                 @"expire_at": _shareExpireAt,          //到期时间
                 @"password": _sharePassword,           //分享密码
                 };
    }
}

@end
