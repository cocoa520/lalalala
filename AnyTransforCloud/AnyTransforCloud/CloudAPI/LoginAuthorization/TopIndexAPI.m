//
//  TopIndexAPI.m
//  AnyTransforCloud
//
//  Created by JGehry on 2018/4/23.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "TopIndexAPI.h"

@implementation TopIndexAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:CloudStorageTopIndexEndPointURL, _driveID];
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
