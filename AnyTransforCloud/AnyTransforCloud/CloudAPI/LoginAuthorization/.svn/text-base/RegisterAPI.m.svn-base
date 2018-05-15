//
//  RegisterAPI.m
//  AnyTransforCloud
//
//  Created by JGehry on 16/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "RegisterAPI.h"

@implementation RegisterAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return WebRegisterEndPointURL;
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
    NSString *confirmPassword = [NSString stringWithFormat:@"%@", _userConfirmPassword];
    return @{
             @"email": email,
             @"password": password,
             @"password_confirmation": confirmPassword
             };
}

@end
