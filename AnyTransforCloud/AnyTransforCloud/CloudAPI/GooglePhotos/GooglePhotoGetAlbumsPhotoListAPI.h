//
//  GooglePhotoGetAlbumsPhotoListAPI.h
//  DriveSync
//
//  Created by 罗磊 on 2018/4/8.
//  Copyright © 2018年 imobie. All rights reserved.
//

#import "BaseDriveAPI.h"

@interface GooglePhotoGetAlbumsPhotoListAPI : BaseDriveAPI

- (instancetype)initWithUserAccountID:(NSString *)userAccountID albumID:(NSString *)albumID accessToken:(NSString *)accessToken;
@end
