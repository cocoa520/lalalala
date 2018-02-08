//
//  IMBBackAndRestore.h
//  TestPipeDemo
//
//  Created by Pallas on 4/11/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <stdio.h>
#include <sys/stat.h>
#import "IMBiPod.h"
#import "IMBSoftWareInfo.h"
#import "IMBLogManager.h"

@interface IMBBackAndRestore : NSObject {
    NSNotificationCenter *nc;
    IMBiPod *iPod;
    AMDevice *deviceHandle;
    NSTask *task;
    int timeOutLimit;
    int timeOutCount;
    BOOL backupFinished;
    BOOL restoreFinished;
    NSString *errorReason;
    int errorCount;
    IMBLogManager *_logHandle;
    NSString *_appStr;
    BOOL _restoreApp;
    
    AMMobileBackupRestore *_backupRestore;
    NSCondition *_condition;
    // 备份文件存放的文件夹路径
    NSString *_backupFolderPath;
    // 设备备份的文件夹路径
    NSString *_deviceBackupPath;
    NSFileManager *fm;
    BOOL _isServiceBackup;
}
@property (nonatomic, readwrite) BOOL restoreApp;
@property (nonatomic, readwrite,retain) NSString *appStr;
@property (nonatomic, retain) NSString *deviceBackupPath;
@property (nonatomic, readwrite) BOOL isServiceBackup;

- (id)initWithIPod:(IMBiPod*)ipod;
- (void)setiPod:(IMBiPod*)aiPod;

//备份手机中的文件 备份文件的目录是itunes备份的目录/Users/iMobie/Library/Application Support/MobileSync/Backup 其原理是使用命令行调用applemobilebackup使itunes进行备份
- (void)backUp;
//- (void)incrementalBackup;

//通过备份文件还原手机中的文件，sourceUUID为已备份的手机udid 如果为空则为当前连接手机的udid 其原理是使用命令行调用applemobilebackup使itunes进行还原
//- (BOOL)restore:(NSString *)sourceUUID;

#pragma mark - 使用命令行备份还原设备
- (void)backupNSTask;
- (void)restoreNSTask:(NSString *)sourceUUID restoreType:(NSString *)restoreType;

- (void)writePlistFile:(NSString*)filePath;

#pragma mark - 通过访问服务方式备份还原设备
- (void)backupByService:(NSString *)backupPath withCondition:(NSCondition *)condition;
- (void)cancelBackupOrRestore;
- (void)restoreByService:(NSString *)restorePath withSourceUUID:(NSString *)sourceUUID;

#pragma mark - 暂停方法
- (void)pauseScan;
- (void)resumeScan;
- (void)stopScan;

@end
