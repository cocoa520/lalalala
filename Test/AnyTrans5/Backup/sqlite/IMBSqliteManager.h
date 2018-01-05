//
//  IMBSqliteManager.h
//  iMobieTrans
//
//  Created by iMobie on 14-2-24.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "MobileDeviceAccess.h"
#import "IMBLogManager.h"
#import "IMBTransResult.h"
#import "IMBProgressCounter.h"
#import "IMBLogManager.h"
#import "IMBBackupDecryptAbove4.h"
#import "IMBiCloudClient.h"
#import "TempHelper.h"
@interface IMBSqliteManager : NSObject
{
    FMDatabase    *_databaseConnection;
    AMDevice      *_device;
    IMBResultSingleton *_transResult;
    IMBProgressCounter *_progressCounter;
    BOOL _threadBreak;
    IMBLogManager *_logManger;
    NSFileManager *fm;
    NSString *_iOSVersion;
    NSMutableArray *_dataAry;
    NSString *_daPath;
    BOOL _dbType;
    
    NSString *_backUpPath;
    IMBiCloudBackup *_iCloudBackup;
    IMBBackupDecrypt* _decrypt;
}
@property (nonatomic, retain) NSMutableArray *dataAry;
@property (nonatomic, assign) IMBLogManager *logManger;
@property (nonatomic, assign) BOOL dbType;
- (id)initWithAMDevice:(AMDevice *)device path:(NSString *)dataBasePath;
- (id)initWithiCloudBackup:(IMBiCloudBackup*)iCloudBackup withType:(NSString *)type;
- (id)initWithAMDevice:(AMDevice *)dev backupfilePath:(NSString *)backupfilePath  withDBType:(NSString *)type WithisEncrypted:(BOOL)isEncrypted withBackUpDecrypt:(IMBBackupDecrypt*)decypt;
- (id)initWithAMDevice:(AMDevice *)dev;
- (id)initWithBackupfilePath:(NSString *)backupfilePath recordArray:(NSMutableArray *)recordArray;
- (id)initWithAMDeviceByexport:(AMDevice *)dev;//用于导出类的初始化方法
+ (NSString *)getBackupFileFloatVersion:(NSString *)backupPath;
//打开数据库连接
- (BOOL)openDataBase;
//关闭数据库连接
- (void)closeDataBase;
- (NSString *)copysqliteToApptempWithsqliteName:(NSString *)sqliteName backupfilePath:(NSString *)backupfilePath recordArray:(NSMutableArray *)recordArray;
- (void)querySqliteDBContent;
//将NSDate转换为指定格式的formate 字符串形式
- (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate;
//将秒数转换为标准时间格式
- (NSString *)getDateStrBySecond:(int)second;
//创建一个不相同的文件名 (当我们拷贝文件时，如果文件已经存在但是我们又不想覆盖它 就需要自动重命名)
- (NSString *)createDifferentfileNameinfolder:(NSString *)folder  filePath:(NSString *)filePath fileManager:(NSFileManager *)fileMan;
////去掉&nbsp 和<div>
//-(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;
@end
