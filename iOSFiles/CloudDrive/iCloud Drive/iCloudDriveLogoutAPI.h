//
//  iCloudDriveLogoutAPI.h
//  DriveSync
//
//  Created by 罗磊 on 2018/2/8.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "BaseDriveAPI.h"

@interface iCloudDriveLogoutAPI : BaseDriveAPI
{
    NSString *_proxyDest;
}

- (id)initWithClientID:(NSString *)clientID proxyDest:(NSString *)proxyDest dsid:(NSString *)dsid cookie:(NSMutableDictionary *)cookie;
@end
