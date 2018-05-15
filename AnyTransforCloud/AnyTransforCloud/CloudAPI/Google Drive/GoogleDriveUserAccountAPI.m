//
//  GoogleDriveUserAccountAPI.m
//  DriveSync
//
//  Created by JGehry on 22/03/2018.
//  Copyright © 2018 imobie. All rights reserved.
//

#import "GoogleDriveUserAccountAPI.h"

@implementation GoogleDriveUserAccountAPI

- (NSString *)baseUrl {
    return GoogleDriveAPIBaseURL;
}

- (NSString *)requestUrl {
    return GoogleDriveGetCurrentAccount;
}

@end
