//
//  BoxDeleteItemAPI.m
//  DriveSync
//
//  Created by JGehry on 1/2/18.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "BoxDeleteItemAPI.h"

@implementation BoxDeleteItemAPI

- (NSString *)baseUrl {
    return BoxAPIBaseURL;
}

- (NSString *)requestUrl {
    NSString *url = nil;
    if (_isFolder) {
        url = [NSString stringWithFormat:BoxDeleteFolderPath, _folderOrfileID];
    }else {
        url = [NSString stringWithFormat:BoxDeleteFilePath, _folderOrfileID];
    }
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodDELETE;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary
{
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", _accestoken];
    return @{
             @"Authorization": authorizationHeaderValue,
             @"Content-Type": @"application/json",
             @"If-Matchg": @"a_unique_value"
             };
    
}

@end
