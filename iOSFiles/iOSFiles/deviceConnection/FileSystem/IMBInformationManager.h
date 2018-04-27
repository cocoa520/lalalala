//
//  IMBInformationManager.h
//  iMobieTrans
//
//  Created by iMobie on 14-3-11.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MobileDeviceAccess.h"
//#import "SimpleNode.h"
//#import "IMBiCloudClient.h"
//#import "IMBMBDBParse.h"
@interface IMBInformationManager : NSObject
{
    NSMutableDictionary *_informationDic;
}

@property(nonatomic,retain)NSMutableDictionary *informationDic;
//单例创建类方法
+ (IMBInformationManager *)shareInstance;
//将各个设备的backup以树形目录展示出来
//具体效果如下
/*
 设备1
     备份1
         note
         contact
         .......
     备份2
         note
         contact
         .......
     ....
 设备2
     备份1
         note
         contact
         .......
     备份2
         note
         contact
         .......
      ....

 */
/*
- (SimpleNode *)getBackupRootNode:(IMBIPod *)ipod;
- (SimpleNode *)getBackupRootNodeByiCloud:(IMBIPod *)ipod WithArray:(NSArray *)backupListArray;


//将备份文件拷贝到用户指定目录
- (BOOL)copyBackupItemToMac:(NSString *)desPath node:(NSArray *)nodeArr backupPath:(NSString *)backupPath iCloudBackup:(IMBiCloudBackup *)iCloudBackup ipod:(IMBIPod *)ipod;

//检查备份文件是否加密
+ (BOOL)backupfileIsencrypt:(NSString *)backupPath;
+ (int)getBackupFileVersion:(NSString *)backupPath;

+ (void)reCaculateRecordHash:(IMBMBFileRecord *)mbfileRecord backupFolderPath:(NSString *)backupFolderPath;
+ (BOOL)saveMBDB:(NSArray*)recordsArray cacheFilePath:(NSString *)cacheFilePath backupFolderPath:(NSString*)backupFolderPath;
+ (float)getBackupFileFloatVersion:(NSString *)backupPath;
 */
@end
