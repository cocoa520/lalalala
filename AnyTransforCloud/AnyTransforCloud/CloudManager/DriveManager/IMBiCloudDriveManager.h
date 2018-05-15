//
//  IMBiCloudDriveManager.h
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/25.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBBaseManager.h"
#import "iCloudDrive.h"

@interface IMBiCloudDriveManager : IMBBaseManager <BaseDriveDelegate>
{
    NSString *_userID;
    BOOL _isRememberPassCode;
}
/**
 *  icloudDrive 登录
 *
 *  @param userID             账号
 *  @param passID             密码
 *  @param delegate           
 *  @param isRememberPassCode 是否保存令牌
 *
 *  @return <#return value description#>
 */
- (id)initWithUserID:(NSString *) userID WithPassID:(NSString*) passID WithDelegate:(id)delegate isRememberPassCode:(BOOL)isRememberPassCode;
@end
