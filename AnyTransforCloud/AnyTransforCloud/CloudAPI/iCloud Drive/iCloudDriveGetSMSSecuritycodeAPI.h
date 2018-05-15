//
//  iCloudDriveGetSMSSecuritycodeAPI.h
//  DriveSync
//
//  Created by 罗磊 on 2018/3/2.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "BaseDriveAPI.h"

@interface iCloudDriveGetSMSSecuritycodeAPI : BaseDriveAPI
{
    NSString *_xappleidSessionID;
    NSString *_scnt;
}
- (id)initWithAppleSessionID:(NSString *)appleSessionID scnt:(NSString *)scnt;
@end
