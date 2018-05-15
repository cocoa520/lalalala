//
//  TwitterAccessTokenAPI.m
//  DriveSync
//
//  Created by JGehry on 21/03/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "TwitterAccessTokenAPI.h"

#include <CommonCrypto/CommonHMAC.h>

@implementation TwitterAccessTokenAPI

- (NSString *)baseUrl {
    return TwitterAPIBaseURL;
}

- (NSString *)requestUrl {
    return TwitterAccessTokenAPIURL;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    return @{
             @"Authorization": _oauthAccessToken
             };
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

@end
