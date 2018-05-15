//
//  AdditionalDriveAPI.m
//  DriveSync
//
//  Created by JGehry on 14/02/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "AdditionalDriveAPI.h"

@implementation AdditionalDriveAPI

- (NSString *)baseUrl {
    return CloudStorageEndPointURL;
}

- (NSString *)requestUrl {
    NSString *url = nil;
    if ([_driveName isEqualToString:GoogleDriveCSEndPointURL]) {
        url = [NSString stringWithFormat:GoogleDriveCSEndPointURL];
    }else if ([_driveName isEqualToString:OneDriveCSEndPointURL]) {
        url = [NSString stringWithFormat:OneDriveCSEndPointURL];
    }else if ([_driveName isEqualToString:DropboxCSEndPointURL]) {
        url = [NSString stringWithFormat:DropboxCSEndPointURL];
    }else if ([_driveName isEqualToString:BoxCSEndPointURL]) {
        url = [NSString stringWithFormat:BoxCSEndPointURL];
    }else if ([_driveName isEqualToString:FacebookCSEndPointURL]) {
        url = [NSString stringWithFormat:FacebookCSEndPointURL];
    }else if ([_driveName isEqualToString:PCloudCSEndPointURL]) {
        url = [NSString stringWithFormat:PCloudCSEndPointURL];
    }
    return [NSString stringWithFormat:CloudStorageBindEndPointURL, url];
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
