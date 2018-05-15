//
//  ModifyHistoryAPI.m
//  DriveSync
//
//  Created by JGehry on 2018/4/24.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "ModifyHistoryAPI.h"

@implementation ModifyHistoryAPI

- (NSString *)baseUrl {
    return WebEndPointURL;
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:HistoryPath, _collectionID];
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
             @"name": @"",              //文件或文件夹的名称
             @"path": @"",              //dropbox需要
             @"active": @"",            //收藏是否有效
             @"album_id": @""           //googlePhoto需要
             };
}

@end
