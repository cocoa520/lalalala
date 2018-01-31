//
//  RefreshTokenAPI.m
//  DriveSync
//
//  Created by JGehry on 12/13/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "RefreshTokenAPI.h"

@implementation RefreshTokenAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    NSString *url = [NSString stringWithFormat:WebRefreshEndPointURL, _driveID];
    return url;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", _userLogintoken];
    return @{
             @"Authorization": authorizationHeaderValue,
             @"Client": @"Cloud Drive/1.0.0",
             @"accept": @"application/json"
             };
}

@end
