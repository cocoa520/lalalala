//
//  LoginAPI.m
//  DriveSync
//
//  Created by JGehry on 12/13/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "LoginAPI.h"

@implementation LoginAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return WebLoginEndPointURL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{
             @"Client": @"Cloud Drive/1.0.0",
             @"accept": @"application/json"
             };
}

- (id)requestArgument {
    NSString *email = [NSString stringWithFormat:@"%@", _userEmail];
    NSString *password = [NSString stringWithFormat:@"%@", _userPassword];
    NSString *g2fCode = [NSString stringWithFormat:@"%@", _userG2FCode];
    if (![g2fCode isEqualToString:@""] && g2fCode != nil) {
        return @{
                 @"email": email,
                 @"password": password,
                 @"code": g2fCode
                 };
    }else {
        return @{
                 @"email": email,
                 @"password": password
                 };
    }
}

@end
