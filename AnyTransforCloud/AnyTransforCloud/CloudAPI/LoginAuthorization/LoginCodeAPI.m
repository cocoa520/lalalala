//
//  LoginCodeAPI.m
//  AnyTransforCloud
//
//  Created by JGehry on 18/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "LoginCodeAPI.h"

@implementation LoginCodeAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return WebLoginCodeEndPointURL;
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
    NSString *loginCode = [NSString stringWithFormat:@"%@", _userLoginCode];
    return @{
             @"code": loginCode
             };
}

@end
