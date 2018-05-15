//
//  AdditionalHistoryAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/4/24.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "AdditionalHistoryAPI.h"

@implementation AdditionalHistoryAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:HistoryPath, _driveID];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
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
    if (_albumID && ![_albumID isEqualToString:@""]) {
        return @{
                 @"path_id": _folderOrfileID,           //文件或文件夹的ID
                 @"is_folder": @(_isFolder),            //是否是文件夹
                 @"album_id": _albumID                  //googlePhoto需要
                 };
    }else {
        return @{
                 @"path_id": _folderOrfileID,           //文件或文件夹的ID
                 @"is_folder": @(_isFolder),            //是否是文件夹
                 };
    }
}

@end
