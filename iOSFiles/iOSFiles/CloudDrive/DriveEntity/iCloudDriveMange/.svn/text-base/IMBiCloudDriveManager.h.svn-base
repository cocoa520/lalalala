//
//  IMBiCloudDriveManager.h
//  iOSFiles
//
//  Created by JGehry on 3/1/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iCloudDrive.h"
#import "IMBDriveEntity.h"
#import "IMBDriveBaseManage.h"
@interface IMBiCloudDriveManager : IMBDriveBaseManage <BaseDriveDelegate>
{
    iCloudDrive *_iCloudDrive;
}
/**
 *  初始化
 *
 *  @param userID id
 *  @param passID 密码
 */
- (id)initWithUserID:(NSString *)userID WithPassID:(NSString*)passID WithDelegate:(id)delegate ;
/**
 *  二次验证
 *
 *  @param twoCodeID 二次验证码
 */
- (void)setTwoCodeID:(NSString *)twoCodeID;
/**
 *  登录错误返回
 *
 *  @param iCloudDrive 
 *  @param responseCode
 */
- (void)drive:(iCloudDrive *)iCloudDrive logInFailWithResponseCode:(ResponseCode)responseCode;
/**
 *  Description 重命名
 *
 *  @param item    重名项  eg:
 *
 *  @{
 *  @"drivewsid": @"FOLDER::com.apple.CloudDocs::E0860A26-B413-457D-81F2-FDBCD79DFFCB",
 *  @"etag": @"pi",
 *  @"name": @"hhh22"
 *  }
 */
- (void)reNameWithDic:(nullable NSDictionary *)dic;
/**
 *  Description 移动
 *
 *  @param newParent 新的父目录id
 *  @param items      移动项的dic数组  eg
 *                               @{@"drivewsid":@"FOLDER::com.apple.CloudDocs::E0860A26-B413-457D-81F2-FDBCD79DFFCB",
 *                               @"etag":@"pp",
 *                               @"clientId":@"FOLDER::com.apple.CloudDocs::E0860A26-B413-457D-81F2-FDBCD79DFFCB"}
 *
 */
- (void)moveToNewParent:(nullable NSString *)newParent itemDics:(nullable NSArray *)items;



@end
