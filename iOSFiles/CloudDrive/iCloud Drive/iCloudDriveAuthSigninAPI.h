//
//  iCloudDriveAuthSigninAPI.h
//  DriveSync
//
//  Created by 罗磊 on 2018/1/17.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "BaseDriveAPI.h"

@interface iCloudDriveAuthSigninAPI : BaseDriveAPI
{
    BOOL _rememberMe;
}
- (instancetype)initWithEmail:(NSString *)email withPassword:(NSString *)password rememberMe:(BOOL)rememberMe;
@end
