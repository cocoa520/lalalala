//
//  GetDriveIDAPI.m
//  DriveSync
//
//  Created by JGehry on 12/13/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "GetDriveIDAPI.h"

@implementation GetDriveIDAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return WebDriveListIDEndPointURL;
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
