//
//  RemoveDriveAPI.m
//  AnyTransforCloud
//
//  Created by JGehry on 16/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "RemoveDriveAPI.h"

@implementation RemoveDriveAPI

- (NSString *)baseUrl {
    return CloudStorageEndPointURL;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:CloudStorageRemoveEndPointURL, _driveID];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodDELETE;
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
