//
//  RenameDriveAPI.m
//  AnyTransforCloud
//
//  Created by JGehry on 16/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "RenameDriveAPI.h"

@implementation RenameDriveAPI

- (NSString *)baseUrl {
    return CloudStorageEndPointURL;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:CloudStorageRenameEndPointURL, _driveID];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPATCH;
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
    return @{
             @"name": _driveNewName
             };
}

@end
