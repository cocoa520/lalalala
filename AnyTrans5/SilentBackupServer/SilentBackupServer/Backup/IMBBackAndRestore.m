//
//  IMBBackAndRestore.m
//  TestPipeDemo
//
//  Created by Pallas on 4/11/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBBackAndRestore.h"
#import "IMBNotificationDefine.h"
#import "IMBFileSystem.h"
#import "IMBHelper.h"
#import "IMBDeviceInfo.h"
#import "IMBWifiBackupConfig.h"

@implementation IMBBackAndRestore
@synthesize appStr = _appStr;
@synthesize restoreApp = _restoreApp;
@synthesize deviceBackupPath = _deviceBackupPath;
@synthesize isServiceBackup = _isServiceBackup;
@synthesize backupTime = _backupTime;
@synthesize isIncremental = _isIncremental;
@synthesize isEncryptBackup = _isEncryptBackup;
@synthesize backupFinished;

- (id)initWithIPod:(IMBiPod*)ipod {
    self = [super init];
    if (self) {
        _backupTime = 0;
        nc = [NSNotificationCenter defaultCenter];
        iPod = [ipod retain];
        deviceHandle = [iPod.deviceHandle retain];
        timeOutLimit = 120;
        timeOutCount = 0;
        backupFinished = NO;
        restoreFinished = NO;
        _restoreApp = NO;
        _isServiceBackup = NO;
        errorCount = 0;
        errorReason = nil;
        _logHandle = [IMBLogManager singleton];
        _condition = [[NSCondition alloc] init];
        fm = [NSFileManager defaultManager];
        
        _backupFolderPath = [[iPod backupConfig].backupPath retain];
        if ([IMBHelper stringIsNilOrEmpty:_backupFolderPath]) {
            if (_backupFolderPath) {
                [_backupFolderPath release];
                _backupFolderPath = nil;
            }
            _backupFolderPath = [[IMBHelper getBackupFolderPath] retain];
        }
        
        if (![fm fileExistsAtPath:_backupFolderPath]) {
            [fm createDirectoryAtPath:_backupFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _deviceBackupPath = [[_backupFolderPath stringByAppendingPathComponent:iPod.deviceInfo.serialNumberForHashing] retain];
    }
    return self;
}

- (void)setiPod:(IMBiPod*)aiPod {
    if (deviceHandle != nil) {
        [deviceHandle release];
        deviceHandle = nil;
    }
    
    if (iPod != nil) {
        [iPod release];
        iPod = nil;
    }
    iPod = [aiPod retain];
    deviceHandle = [iPod.deviceHandle retain];
}

- (void)dealloc {
    [self stopBackupRestore];
    if (deviceHandle != nil) {
        [deviceHandle release];
        deviceHandle = nil;
    }
    if (_backupRestore != nil) {
        [_backupRestore release];
        _backupRestore = nil;
    }
    if (iPod != nil) {
        [iPod release];
        iPod = nil;
    }
    if (_condition != nil) {
        [_condition release];
        _condition = nil;
    }
    if (_deviceBackupPath != nil) {
        [_deviceBackupPath release];
        _deviceBackupPath = nil;
    }
    if (_backupFolderPath != nil) {
        [_backupFolderPath release];
        _backupFolderPath = nil;
    }
    [super dealloc];
}

#pragma mark - backup操作
// 备份当前设备----使用增量备份，先是判断备份目录下是否有PhoneRescue备份的备份文件，然后在判断给备份是否超过一天，如超过一天就重命名，在备份；否则就直接增量备份；
- (void)backUp {
    @autoreleasepool {
        //写入备份开始日志
        [_logHandle writeErrorLog:@"backUp start"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *infoPath = [_deviceBackupPath stringByAppendingPathComponent:@"Info.plist"];
        NSString *lbDate = nil;
        _isIncremental = NO;
        BOOL isWifi = NO;//是否是AnyTransWifi的备份文件；
        long long time = 0;
        if ([fm fileExistsAtPath:infoPath]) {
            NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:infoPath];
            if (infoDic != nil && [[infoDic allKeys] count] > 0) {
                NSArray *allKey = [infoDic allKeys];
                if ([allKey containsObject:@"AnyTrans Version"]) {
                    NSString *ver = [infoDic objectForKey:@"AnyTrans Version"];
                    if ([ver isEqualToString:@"AnyTrans Wifi"]) {
                        isWifi = YES;
                    }
                }
                if ([allKey containsObject:@"BackupTime"]) {
                    time = [[infoDic objectForKey:@"BackupTime"] longLongValue];
                }
                if (isWifi) {
                    if ([allKey containsObject:@"Last Backup Date"]) {
                        NSTimeInterval curSecond = [[NSDate date] timeIntervalSince1970];
                        NSTimeInterval oriSecond = [(NSDate *)[infoDic objectForKey:@"Last Backup Date"] timeIntervalSince1970];
                        if (oriSecond + 259200 < curSecond) {
                            lbDate = [dateFormatter stringFromDate:(NSDate *)[infoDic objectForKey:@"Last Backup Date"]];
                            if (!lbDate) {
                                lbDate = [dateFormatter stringFromDate:[NSDate date]];
                            }
                        }else {
                            _isIncremental = YES;
                        }
                    }
                }else {
                    lbDate = [dateFormatter stringFromDate:[NSDate date]];
                }
            }else {
                lbDate = [dateFormatter stringFromDate:[NSDate date]];
            }
        }else {
            lbDate = [dateFormatter stringFromDate:[NSDate date]];
        }
        if (lbDate) {//需要重命名,从头备份
            if ([fm fileExistsAtPath:_deviceBackupPath]) {
                NSString *toPath = [[IMBHelper getBackupFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", deviceHandle.udid, lbDate]];
                [dateFormatter release];
                dateFormatter = nil;
                BOOL ret = [fm moveItemAtPath:_deviceBackupPath toPath:toPath error:nil];
                if (ret) {
                    //修改备份缓存记录的备份路径
                    NSString *savePath = [[IMBHelper getAppConfigPath] stringByAppendingPathComponent:@"backupRecord.plist"];
                    if ([fm fileExistsAtPath:savePath]) {
                        NSMutableDictionary *saveDic = [NSMutableDictionary dictionaryWithContentsOfFile:savePath];
                        if (saveDic) {
                            BOOL isChange = NO;
                            if ([saveDic.allKeys containsObject:iPod.deviceInfo.serialNumber]) {
                                NSArray *array = [saveDic objectForKey:iPod.deviceInfo.serialNumber];
                                if (array) {
                                    for (NSMutableDictionary *dic in array) {
                                        if ([dic.allKeys containsObject:@"BackupTime"]) {
                                            long long backupTime = [[dic objectForKey:@"BackupTime"] longLongValue];
                                            if (backupTime == time && time != 0) {
                                                [dic setObject:toPath forKey:@"BackupPath"];
                                                isChange = YES;
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                            if (isChange) {
                                [fm removeItemAtPath:savePath error:nil];
                                [saveDic writeToFile:savePath atomically:YES];
                            }
                        }
                    }
                }
            }
        }
        
        if (_isServiceBackup) {
            [self backupDevice];
        }else {
            [self backupNSTask];
        }
    }
}

// 备份当前设备的数据
- (void)backupDevice {
    [self backupDeviceByThread];
}
- (void)backupDeviceByThread {
    ScanStatus *scanStatus = [ScanStatus shareInstance];
    [_condition lock];
    if (scanStatus.isPause) {
        [_condition wait];
    }
    [_condition unlock];
    if (scanStatus.stopScan) {
        [_logHandle writeInfoLog:@"Stop Backup1!"];
        //停止备份返回到主界面;
        [nc postNotificationName:NOTIFY_BACKUP_COMPLETE object:[NSNumber numberWithBool:YES] userInfo:nil];
        return;
    }
    [self backupByService:_backupFolderPath withCondition:_condition];
}

#pragma mark - 使用命令行备份还原设备
- (void)backupNSTask {
    [_logHandle writeErrorLog:@"backupNSTask start"];
    backupFinished = NO;
    _isEnd = NO;
    errorCount = 0;
    timeOutCount = 0;
    NSString *uuid = [deviceHandle udid];
    _isEncryptBackup = [self checkBackupEncrypt];
//    if ([self checkBackupEncrypt]) {
//        //"text_id_45" = "Please uncheck the \"Encrypt local backup\" option on iTunes to allow PhoneRescue to backup your device data.";
//        [nc postNotificationName:NOTIFY_BACKUP_ERROR object:@"backup_id_text_10" userInfo:nil];
//        [_logHandle writeErrorLog:@"buckup Encrypt"];
//    } else {
        [nc postNotificationName:NOTIFY_BACKUP_START object:nil userInfo:nil];
        NSString *backupRestorPath = [[NSBundle mainBundle] pathForResource:@"iMobieBackupRestoreDevice" ofType:@""];
        NSArray *arguments = [NSArray arrayWithObjects: @"--backup", uuid, _backupFolderPath, nil];
        task = [[NSTask alloc] init];
        NSPipe *outpipe = [NSPipe pipe];
        NSPipe *errorPipe = [NSPipe pipe];
        NSFileHandle *readHandle = [outpipe fileHandleForReading];
        NSFileHandle *errorHandle = [errorPipe fileHandleForReading];
        [task setStandardError:outpipe];
        [task setStandardOutput:errorPipe];
        [readHandle waitForDataInBackgroundAndNotify];
        [errorHandle waitForDataInBackgroundAndNotify];
        [nc addObserver:self
               selector:@selector(backupFinished:)
                   name:NSTaskDidTerminateNotification
                 object:task];
        [nc addObserver:self
               selector:@selector(backupOutData:)
                   name:NSFileHandleDataAvailableNotification
                 object:readHandle];
        [nc addObserver:self
               selector:@selector(backupOutData:)
                   name:NSFileHandleDataAvailableNotification
                 object:errorHandle];
        [task setLaunchPath:backupRestorPath];
        [task setArguments:arguments];
        [task launch];
        [task waitUntilExit];
        _isEnd = YES;
        int status = [task terminationStatus];
        if (status == 0) {
            [_logHandle writeErrorLog:@"Task succeeded."];
        } else {
            [_logHandle writeErrorLog:@"Task failed."];
        }
        [nc removeObserver:self name:NSFileHandleDataAvailableNotification object:readHandle];
        [nc removeObserver:self name:NSFileHandleDataAvailableNotification object:errorHandle];
        [nc removeObserver:self name:NSTaskDidTerminateNotification object:task];
//        if (!_isEnd) {
//            _isEnd = YES;
//            [task terminate];
//        }
        [task release];
        task = nil;
//    }
    [_logHandle writeErrorLog:@"backupNSTask end"];
}

- (void)restoreNSTask:(NSString *)sourceUUID restoreType:(NSString *)restoreType{
    [_logHandle writeErrorLog:@"restoreNSTask start"];
    restoreFinished = NO;
    errorCount = 0;
    timeOutCount = 0;
    NSString *targetUUID = [deviceHandle udid];
    if ([IMBHelper stringIsNilOrEmpty:sourceUUID]) {
        sourceUUID = targetUUID;
    }
//    if ([self checkRestoreEncrypt]) {
//        //"text_id_45_1" = "PhoneRescue cannot restore your device to this backup point, because this is encrypted by iTunes. Please use iTunes to restore your device.";
////        [_logHandle writeErrorLog:CustomLocalizedString(@"CustomLocalizedString", nil)];
////        [nc postNotificationName:NOTIFY_RESTORE_ERROR object:CustomLocalizedString(@"CustomLocalizedString", nil) userInfo:nil];
//    } else {
        [nc postNotificationName:NOTIFY_RESTORE_START object:nil userInfo:nil];
        [nc postNotificationName:NOTIFY_BACKUP_START object:nil userInfo:nil];
        NSString *backupRestorPath = [[NSBundle mainBundle] pathForResource:@"iMobieBackupRestoreDevice" ofType:@""];
        NSArray *arguments = nil;
        if ([restoreType isEqualToString:@"restore"]) {
            arguments = [NSArray arrayWithObjects: @"--restore", sourceUUID, targetUUID, nil];
        } else if ([restoreType isEqualToString:@"deepclean"]) {
            arguments = [NSArray arrayWithObjects: @"--deepclean", sourceUUID, targetUUID, nil];
        } else if ([restoreType isEqualToString:@"restoreApp"]) {
            arguments = [NSArray arrayWithObjects: @"--restoreapp", sourceUUID, targetUUID, _appStr, nil];
        }else {
            arguments = [NSArray arrayWithObjects: @"--restore", sourceUUID, targetUUID, nil];
        }
        task = [[NSTask alloc] init];
        NSPipe *outpipe = [NSPipe pipe];
        NSPipe *errorPipe = [NSPipe pipe];
        NSFileHandle *readHandle = [outpipe fileHandleForReading];
        NSFileHandle *errorHandle = [errorPipe fileHandleForReading];
        [task setStandardError:outpipe];
        [task setStandardOutput:errorPipe];
        [readHandle waitForDataInBackgroundAndNotify];
        [errorHandle waitForDataInBackgroundAndNotify];
        [nc addObserver:self
               selector:@selector(restoreFinished:)
                   name:NSTaskDidTerminateNotification
                 object:task];
        [nc addObserver:self
               selector:@selector(restoreOutData:)
                   name:NSFileHandleDataAvailableNotification
                 object:readHandle];
        [nc addObserver:self
               selector:@selector(restoreOutData:)
                   name:NSFileHandleDataAvailableNotification
                 object:errorHandle];
        [task setLaunchPath:backupRestorPath];
        [task setArguments:arguments];
        [task launch];
        [task waitUntilExit];
        int status = [task terminationStatus];
        if (status == 0)
            [_logHandle writeErrorLog:@"Task succeeded."];
        else
            [_logHandle writeErrorLog:@"Task failed."];
        [nc removeObserver:self name:NSFileHandleDataAvailableNotification object:readHandle];
        [nc removeObserver:self name:NSFileHandleDataAvailableNotification object:errorHandle];
        [nc removeObserver:self name:NSTaskDidTerminateNotification object:task];
        [task release];
        task = nil;
        
//    }
    [_logHandle writeErrorLog:@"restoreNSTask end"];
}

- (void)backupOutData:(NSNotification *)notification {
    NSFileHandle *fh = [notification object];
    NSData *data = [fh availableData];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    [fh waitForDataInBackgroundAndNotify];
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"backup progress is: %@", str]];
    
    if (str != nil && [str rangeOfString:@"time out."].length > 0) {
        timeOutCount += 1;
        if (errorCount > 0) {
            if (task != nil) {
                if (!_isEnd) {
                    _isEnd = YES;
                    [task terminate];
                }
                return;
            }
        }else if (timeOutCount > timeOutLimit) {
            if (task != nil) {
                if (!_isEnd) {
                    _isEnd = YES;
                    [task terminate];
                }
                return;
            }
        }else {
            
        }
    }
    
    NSString *errStr = nil;
    if (![IMBHelper stringIsNilOrEmpty:str] && [str rangeOfString:@"ERROR:"].length > 0) {
        errStr = [str substringFromIndex:([str rangeOfString:@"ERROR:"].location + @"ERROR:".length)];
        [_logHandle writeErrorLog:[NSString stringWithFormat:@"errStr:%@", errStr]];
    }
    
    if (![IMBHelper stringIsNilOrEmpty:errStr] && [str rangeOfString:@"Request name missing from message:"].length > 0) {
        NSString *tmpStr = [errStr substringFromIndex:([errStr rangeOfString:@"Request name missing from message:"].location + @"Request name missing from message:".length)];
        NSDictionary *dic = [self dictionaryWithString:tmpStr];
        NSString *errorCode = nil;
        if (dic != nil && dic.allKeys.count > 0) {
            NSArray *allKey = dic.allKeys;
            if ([allKey containsObject:@"errorCode"]) {
                errorCode = [dic objectForKey:@"errorCode"];
                errorCount += 1;
            }
        }
        if (![IMBHelper stringIsNilOrEmpty:errorCode]) {
            NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:[IMBHelper stringIsNilOrEmpty:errorReason] ? @"": errorReason, NOTIFY_ERROR_REASON, errorCode, NOTIFY_ERROR_CODE, nil];
            [nc postNotificationName:NOTIFY_BACKUP_ERROR object:NOTIFY_ERROR_CODE userInfo:userDic];
            [_logHandle writeErrorLog:[NSString stringWithFormat:@"errorCode:%@", errorCode]];
            if (![IMBHelper stringIsNilOrEmpty:errorReason]) {
                [_logHandle writeErrorLog:[NSString stringWithFormat:@"errorReason:%@", errorReason]];
            }
            if (!_isEnd) {
                _isEnd = YES;
                [task terminate];
            }
            return;
        }
    } else if (![IMBHelper stringIsNilOrEmpty:errStr] && [errStr rangeOfString:@"MBErrorDomain"].length > 0) {
        errorReason = errStr;
        [_logHandle writeErrorLog:[NSString stringWithFormat:@"MBErrorDomain errorReason:%@", errorReason]];
    } else if ([IMBHelper stringIsNilOrEmpty:errStr]) {
        NSMutableArray *dicArray = [[NSMutableArray alloc] init];
        @try {
            NSDictionary *dataDic = nil;
            if ([str rangeOfString:@"<split>"].length > 0) {
                NSArray *progressStrArray = [str componentsSeparatedByString:@"<split>"];
                for (NSString *strItem in progressStrArray) {
                    if ([IMBHelper stringIsNilOrEmpty:strItem]) {
                        continue;
                    }
                    dataDic = [self dictionaryWithString:strItem];
                    if (dataDic != nil) {
                        [dicArray addObject:dataDic];
                    }
                }
            } else {
                dataDic = [self dictionaryWithString:str];
                if (dataDic != nil) {
                    [dicArray addObject:dataDic];
                }
            }
        }
        @catch (NSException *exception) {
            [_logHandle writeErrorLog:[NSString stringWithFormat:@"parse message failed reason: %@", exception.reason]];
            NSLog(@"parse message failed reason: %@", exception.reason);
        }
        
        if (dicArray != nil && dicArray.count > 0) {
            timeOutCount = 0;
            for (NSDictionary *dataDic in dicArray) {
                if (dataDic != nil) {
                    NSArray *allKey = [dataDic allKeys];
                    if (allKey == nil || allKey.count == 0) {
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:100], @"BRProgress", nil];
                        [nc postNotificationName:NOTIFY_BACKUP_PROGRESS object:@"Backup progress is %d" userInfo:userInfo];
                        [_logHandle writeErrorLog:[NSString stringWithFormat:@"Backup progress is %d", 100]];
                        backupFinished = YES;
                        double delayInSeconds = 20;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            if (!_isEnd) {
                                _isEnd = YES;
                                [task terminate];
                            }
                        });
                    }else {
                        if ([allKey containsObject:@"errorCode"]) {
                            NSString *errorCode = [NSString stringWithFormat:@"%@", [dataDic objectForKey:@"errorCode"]];
                            NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:[IMBHelper stringIsNilOrEmpty:errorReason] ? @"": errorReason, NOTIFY_ERROR_REASON, errorCode ,NOTIFY_ERROR_CODE, nil];
                            [nc postNotificationName:NOTIFY_BACKUP_ERROR object:NOTIFY_ERROR_CODE userInfo:userDic];
                            
                            [_logHandle writeErrorLog:[NSString stringWithFormat:@"errorCode1:%@", errorCode]];
                            if (![IMBHelper stringIsNilOrEmpty:errorReason]) {
                                [_logHandle writeErrorLog:[NSString stringWithFormat:@"errorReason1:%@", errorReason]];
                            }
                            if (!_isEnd) {
                                _isEnd = YES;
                                [task terminate];
                            }
                            [dicArray release];
                            dicArray = nil;
                            return;
                        }
                        if ([allKey containsObject:@"AMSBackupPercentageKey"]) {
                            id percebrNum = [dataDic valueForKey:@"AMSBackupPercentageKey"];
                            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:percebrNum, @"BRProgress", nil];
                            [nc postNotificationName:NOTIFY_BACKUP_PROGRESS object:@"Backup progress is %d" userInfo:userInfo];
                            if (percebrNum != nil) {
                                [_logHandle writeErrorLog:[NSString stringWithFormat:@"Backup progress is %d", [percebrNum intValue]]];
                            }
                            
                            if ([percebrNum intValue] == 100) {
                                backupFinished = YES;
                                [nc postNotificationName:NOTIFY_BACKUP_RECORD object:nil];
                                double delayInSeconds = 20;
                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                    if (!_isEnd) {
                                        _isEnd = YES;
                                        [task terminate];
                                    }
                                });
                            }
                        }
                    }
                }
            }
        } else {
            if (backupFinished && ![self checkExistSnapshot]) {
                if (!_isEnd) {
                    _isEnd = YES;
                    [task terminate];
                }
            }
        }
        [dicArray release];
        dicArray = nil;
    }
}

- (BOOL)checkExistSnapshot {
    NSString *backupFilePath = [_deviceBackupPath stringByAppendingPathComponent:@"Snapshot"];
    return [fm fileExistsAtPath:backupFilePath];
}

- (void)backupFinished:(NSNotification *)notification {
    [_logHandle writeErrorLog:@"backupFinished in"];
    if (backupFinished) {
        [_logHandle writeErrorLog:@"backupFinished in backupFinished"];
        NSString *infoLocalPath = [_deviceBackupPath stringByAppendingPathComponent:@"Info.plist"];
        [nc postNotificationName:NOTIFY_BACKUP_PROGRESS object:@"Being write Info.plist file." userInfo:nil];
        [self writePlistFile:infoLocalPath];
        [nc postNotificationName:NOTIFY_BACKUP_PROGRESS object:@"Write Info.plist file finished." userInfo:nil];
        [nc postNotificationName:NOTIFY_BACKUP_COMPLETE object:@"Backup finished." userInfo:nil];
    }else {
        [nc postNotificationName:NOTIFY_BACKUP_COMPLETE object:@"Backup finished." userInfo:nil];
    }
    [_logHandle writeErrorLog:@"backupFinished out"];
}

- (void)restoreOutData:(NSNotification *)notification {
    
    //[_logHandle writeErrorLog:@"restoreOutData in"];
    
    NSFileHandle *fh = [notification object];
    NSData *data = [fh availableData];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    [fh waitForDataInBackgroundAndNotify];
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"restore progress is : %@", str]];
    
    if (str != nil && [str rangeOfString:@"time out."].length > 0) {
        timeOutCount += 1;
        if (errorCount > 0) {
            if (task != nil) {
                [task terminate];
                return;
            }
        } else if (timeOutCount > timeOutLimit) {
            [task terminate];
            return;
        } else {
            
        }
    }
    
    // 查找返回回来的信息有不有Error
    NSString *errStr = nil;
    if (![IMBHelper stringIsNilOrEmpty:str] && [str rangeOfString:@"ERROR:"].length > 0) {
        errStr = [str substringFromIndex:([str rangeOfString:@"ERROR:"].location + @"ERROR:".length)];
        [_logHandle writeErrorLog:[NSString stringWithFormat:@"errStr:%@", errStr]];
    }
    
    if (![IMBHelper stringIsNilOrEmpty:errStr] && [errStr rangeOfString:@"Request name missing from message:"].length > 0) {
        NSString *tmpStr = [errStr substringFromIndex:([errStr rangeOfString:@"Request name missing from message:"].location + @"Request name missing from message:".length)];
        NSDictionary *dic = [self dictionaryWithString:tmpStr];
        NSString *errorCode = nil;
        if (dic != nil && dic.allKeys.count > 0) {
            NSArray *allKey = dic.allKeys;
            if ([allKey containsObject:@"errorCode"]) {
                errorCode = [dic objectForKey:@"errorCode"];
                errorCount += 1;
            }
        }
        if (![IMBHelper stringIsNilOrEmpty:errorCode]) {
            NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [IMBHelper stringIsNilOrEmpty:errorReason] ? @"": errorReason, NOTIFY_ERROR_REASON,
                                     errorCode ,NOTIFY_ERROR_CODE, nil];
            [nc postNotificationName:NOTIFY_RESTORE_ERROR object:NOTIFY_ERROR_CODE userInfo:userDic];
            [_logHandle writeErrorLog:[NSString stringWithFormat:@"NOTIFY_ERROR_CODE:%@", errorCode]];
            if (![IMBHelper stringIsNilOrEmpty:errorReason]) {
                [_logHandle writeErrorLog:[NSString stringWithFormat:@"NOTIFY_ERROR_REASON:%@", errorReason]];
            }
            [task terminate];
            task= nil;
            
        }
    } else if (![IMBHelper stringIsNilOrEmpty:errStr] && [errStr rangeOfString:@"MBErrorDomain"].length > 0) {
        errorReason = errStr;
        [_logHandle writeErrorLog:[NSString stringWithFormat:@"MBErrorDomain errorReason:%@", errorReason]];
        NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [IMBHelper stringIsNilOrEmpty:errorReason] ? @"": errorReason, NOTIFY_ERROR_REASON,
                                 @"-1000" ,NOTIFY_ERROR_CODE, nil];
        [nc postNotificationName:NOTIFY_RESTORE_ERROR object:NOTIFY_ERROR_CODE userInfo:userDic];
        [task terminate];
        task= nil;
    } else if ([IMBHelper stringIsNilOrEmpty:errStr] ) {
        NSMutableArray *dicArray = [[NSMutableArray alloc] init];
        @try {
            NSDictionary *dataDic = nil;
            if ([str rangeOfString:@"<split>"].length > 0) {
                NSArray *progressStrArray = [str componentsSeparatedByString:@"<split>"];
                for (NSString *strItem in progressStrArray) {
                    if ([IMBHelper stringIsNilOrEmpty:strItem]) {
                        continue;
                    }
                    dataDic = [self dictionaryWithString:strItem];
                    if (dataDic != nil) {
                        [dicArray addObject:dataDic];
                    }
                }
            } else {
                dataDic = [self dictionaryWithString:str];
                if (dataDic != nil) {
                    [dicArray addObject:dataDic];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"parse message failed reason: %@", exception.reason);
        }
        
        if (dicArray != nil && dicArray.count > 0) {
            timeOutCount = 0;
            for (NSDictionary *dataDic in dicArray) {
                if (dataDic != nil) {
                    NSArray *allKey = [dataDic allKeys];
                    if (allKey == nil || allKey.count == 0) {
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [NSNumber numberWithInt:100], @"BRProgress"
                                                  , nil];
                        [nc postNotificationName:NOTIFY_RESTORE_PROGRESS object:@"Restore progress is %d" userInfo:userInfo];
                        [_logHandle writeErrorLog:[NSString stringWithFormat:@"Restore progress is %d", 100]];
                        restoreFinished = YES;
                        if (_restoreApp) {
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                NSLog(@"_restoreApp1:%d",_restoreApp);
                                sleep(60);
                                NSLog(@"_restoreApp2:%d",_restoreApp);
                                if (restoreFinished && task != nil) {
                                    [task terminate];
                                    task= nil;
                                }
                            });
                        }
                    } else {
                        if ([allKey containsObject:@"errorCode"]) {
                            NSString *errorCode = [NSString stringWithFormat:@"%@", [dataDic objectForKey:@"errorCode"]];
                            NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     [IMBHelper stringIsNilOrEmpty:errorReason] ? @"": errorReason, NOTIFY_ERROR_REASON,
                                                     errorCode ,NOTIFY_ERROR_CODE, nil];
                            [nc postNotificationName:NOTIFY_RESTORE_ERROR object:NOTIFY_ERROR_CODE userInfo:userDic];
                            [_logHandle writeErrorLog:[NSString stringWithFormat:@"NOTIFY_ERROR_CODE1:%@", errorCode]];
                            if (![IMBHelper stringIsNilOrEmpty:errorReason]) {
                                [_logHandle writeErrorLog:[NSString stringWithFormat:@"NOTIFY_ERROR_REASON1:%@", errorReason]];
                            }
                            [task terminate];
                            task= nil;
                            return;
                        }
                        if ([allKey containsObject:@"AMSBackupPercentageKey"]) {
                            id percebrNum = [dataDic valueForKey:@"AMSBackupPercentageKey"];
                            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                      percebrNum, @"BRProgress"
                                                      , nil];
                            [nc postNotificationName:NOTIFY_RESTORE_PROGRESS object:@"Restore progress is %d" userInfo:userInfo];
                            
                            if (percebrNum != nil) {
                                [_logHandle writeErrorLog:[NSString stringWithFormat:@"Restore progress is %d", [percebrNum intValue]]];
                            }
                            
                            if ([percebrNum intValue] == 100) {
                                restoreFinished = YES;
                                if (_restoreApp) {
                                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                        NSLog(@"_restoreApp1:%d",_restoreApp);
                                        sleep(60);
                                        NSLog(@"_restoreApp2:%d",_restoreApp);
                                        if (restoreFinished && task != nil) {
                                            [task terminate];
                                            task= nil;
                                        }
                                    });
                                }
                            }
                        }
                    }
                }
            }
        } else {
            if (restoreFinished) {
                [task terminate];
                task= nil;
            }
        }
    }
    
    // [_logHandle writeErrorLog:@"restoreOutData out"];
    
}

- (void)restoreFinished:(NSNotification *) notification {
    
    [_logHandle writeErrorLog:@"restoreFinished in"];
    if (restoreFinished) {
        [_logHandle writeErrorLog:@"restoreFinished in restoreFinished"];
        
        [nc postNotificationName:NOTIFY_RESTORE_COMPLETE object:@"Restore finished." userInfo:nil];
    }
    [_logHandle writeErrorLog:@"restoreFinished out"];
}

// 通过字符串分析是否是一个Dictionary，然后再构建它
- (NSDictionary *)dictionaryWithString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *error;
    NSPropertyListFormat format;
    NSDictionary *dict = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    return dict;
}

// 通过Dictionary分析是否是一个字符串，然后再构建它
- (NSString *)stringWithDictionary:(NSDictionary *)dict {
    NSData *dicData = [NSPropertyListSerialization dataWithPropertyList:dict format:NSPropertyListXMLFormat_v1_0 options:0 error:NULL];
    NSString *dicStr = [[[NSString alloc] initWithData:dicData encoding:NSASCIIStringEncoding] autorelease];
    return dicStr;
}

// 获取iTunes备份的目录
- (NSString *)getBackupFolderPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support/MobileSync/Backup"];
}

// 检查备份是否被加密
- (BOOL)checkBackupEncrypt {
    BOOL isEncrypt = [[deviceHandle deviceValueForKey:@"WillEncrypt" inDomain:@"com.apple.mobile.backup"] boolValue];
    return isEncrypt;
}

// 检查还原是否被加密
- (BOOL)checkRestoreEncrypt {
    NSString *manifestLocalPath = [[[self getBackupFolderPath] stringByAppendingPathComponent:[deviceHandle udid]] stringByAppendingPathComponent:@"Manifest.plist"];
    NSDictionary *manifestDic = [NSDictionary dictionaryWithContentsOfFile:manifestLocalPath];
    NSArray *allKey = [manifestDic allKeys];
    BOOL isEncrypt = NO;
    if ([allKey containsObject:@"IsEncrypted"]) {
        isEncrypt = [[manifestDic valueForKey:@"IsEncrypted"] boolValue];
    } else {
        isEncrypt = NO;
    }
    return isEncrypt;
}

// 写Plist文件
- (void)writePlistFile:(NSString*)filePath {
    NSMutableDictionary *infoPlist = [[NSMutableDictionary alloc] init];
    [infoPlist setValue:[NSNumber numberWithLongLong:_backupTime] forKey:@"BackupTime"];
    // 获取设备的基本的属性值
    NSString *buildVersion = iPod.deviceInfo.buildVersion;//[deviceHandle deviceValueForKey:@"BuildVersion"];
    if (buildVersion != nil && ![buildVersion isEqualToString:@""] ) {
        [infoPlist setValue:buildVersion forKey:@"Build Version"];
    }
    NSString *deviceName = iPod.deviceInfo.deviceName;
    if (deviceName != nil && ![deviceName isEqualToString:@""] ) {
        [infoPlist setValue:deviceName forKey:@"Device Name"];
        [infoPlist setValue:deviceName forKey:@"Display Name"];
    }
    // guid 是随机生成
    CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
    NSString *guid = [(NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref) stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (guid != nil && ![guid isEqualToString:@""] ) {
        [infoPlist setValue:guid forKey:@"GUID"];
    }
    /*NSString *udid = [deviceHandle deviceValueForKey:@"UniqueDeviceID"];
     NSLog(@"udid is %@", udid);*/
    NSString *ICCID = iPod.deviceInfo.integratedCircuitCardIdentity;//[deviceHandle deviceValueForKey:@"IntegratedCircuitCardIdentity"];
    if (ICCID != nil && ![ICCID isEqualToString:@""] ) {
        [infoPlist setValue:ICCID forKey:@"ICCID"];
    }
    NSString *IMEI = iPod.deviceInfo.internationalMobileEquipmentIdentity;//[deviceHandle deviceValueForKey:@"InternationalMobileEquipmentIdentity"];
    if (IMEI != nil && ![IMEI isEqualToString:@""] ) {
        [infoPlist setValue:IMEI forKey:@"IMEI"];
    }
    NSMutableArray *installappArray = [[NSMutableArray alloc] init];
    NSArray *appArray = [deviceHandle installedApplications];
    for (AMApplication *item in appArray) {
        [installappArray addObject:[item bundleid]];
    }
    if (appArray != nil && [appArray count] > 0) {
        [infoPlist setObject:installappArray forKey:@"Installed Applications"];
    }
    [installappArray release];
    NSDate *nowdate = [NSDate date];
    [infoPlist setObject:nowdate forKey:@"Last Backup Date"];
    NSString *phoneNumber = iPod.deviceInfo.phoneNumber;//[deviceHandle deviceValueForKey:@"PhoneNumber"];
    if (phoneNumber != nil && ![phoneNumber isEqualToString:@""] ) {
        [infoPlist setValue:phoneNumber forKey:@"Phone Number"];
    }
    [infoPlist setValue:@"AnyTrans Wifi" forKey:@"AnyTrans Version"];
    NSString *productType = iPod.deviceInfo.productType;//[deviceHandle deviceValueForKey:@"ProductType"];
    if (productType != nil && ![productType isEqualToString:@""] ) {
        [infoPlist setValue:productType forKey:@"Product Type"];
    }
    NSString *productVersion = iPod.deviceInfo.productVersion;//[deviceHandle deviceValueForKey:@"ProductVersion"];
    if (productVersion != nil && ![productVersion isEqualToString:@""] ) {
        [infoPlist setValue:productVersion forKey:@"Product Version"];
    }
    NSString *serialNumber = iPod.deviceInfo.serialNumber;//[deviceHandle deviceValueForKey:@"SerialNumber"];
    if (serialNumber != nil && ![serialNumber isEqualToString:@""] ) {
        [infoPlist setValue:serialNumber forKey:@"Serial Number"];
    }
    NSString *targetIdentifier = iPod.deviceInfo.uniqueChipID;//[deviceHandle deviceValueForKey:@"UniqueDeviceID"];
    if (targetIdentifier != nil && ![targetIdentifier isEqualToString:@""] ) {
        [infoPlist setValue:targetIdentifier forKey:@"Target Identifier"];
    }
    NSString *targetType = @"Device";
    [infoPlist setValue:targetType forKey:@"Target Type"];
    NSString *uniqueIdentifier = [targetIdentifier uppercaseString];
    if (uniqueIdentifier != nil && ![uniqueIdentifier isEqualToString:@""] ) {
        [infoPlist setValue:uniqueIdentifier forKey:@"Unique Identifier"];
    }
    
    // 读取设备中文件的
    AFCMediaDirectory *mediaDirectory = [deviceHandle newAFCMediaDirectory];
    AFCFileReference *fileHandle = nil;
    const uint32_t bufsz = 10240;
    char *buff = (char*)malloc(bufsz);
    uint32_t done = 0;
    
    NSMutableData *fileData = nil;
    if ([mediaDirectory fileExistsAtPath:@"/Books/iBooksData.plist"]) {
        fileHandle = [mediaDirectory openForRead:@"/Books/iBooksData.plist"];
        
        fileData = [[NSMutableData alloc] init];
        while (1) {
            memset(buff, 0, bufsz);
            uint64_t n = [fileHandle readN:bufsz bytes:buff];
            if (n==0) break;
            NSData *b2 = [[NSData alloc]
                          initWithBytesNoCopy:buff length:n freeWhenDone:NO];
            [fileData appendData:b2];
            [b2 release];
            done += n;
        }
        [fileHandle closeFile];
        [infoPlist setObject:fileData forKey:@"iBooks Data"];
        [fileData release];
    }
    
    if ([mediaDirectory fileExistsAtPath:@"/Books/iBooksData2.plist"]) {
        fileHandle = [mediaDirectory openForRead:@"/Books/iBooksData2.plist"];
        
        fileData = [[NSMutableData alloc] init];
        while (1) {
            memset(buff, 0, bufsz);
            uint64_t n = [fileHandle readN:bufsz bytes:buff];
            if (n==0) break;
            NSData *b2 = [[NSData alloc]
                          initWithBytesNoCopy:buff length:n freeWhenDone:NO];
            [fileData appendData:b2];
            [b2 release];
            done += n;
        }
        [fileHandle closeFile];
        [infoPlist setObject:fileData forKey:@"iBooks Data 2"];
        [fileData release];
    }
    
    if ([mediaDirectory fileExistsAtPath:@"/Books/iBooksData3.plist"]) {
        fileHandle = [mediaDirectory openForRead:@"/Books/iBooksData3.plist"];
        
        fileData = [[NSMutableData alloc] init];
        while (1) {
            memset(buff, 0, bufsz);
            uint64_t n = [fileHandle readN:bufsz bytes:buff];
            if (n==0) break;
            NSData *b2 = [[NSData alloc]
                          initWithBytesNoCopy:buff length:n freeWhenDone:NO];
            [fileData appendData:b2];
            [b2 release];
            done += n;
        }
        [fileHandle closeFile];
        [infoPlist setObject:fileData forKey:@"iBooks Data 3"];
        [fileData release];
    }
    
    // 读取iTunesFile里面的数据
    NSArray *itunesFiles = [NSArray arrayWithObjects:@"ApertureAlbumPrefs", @"IC-Info.sidb", @"IC-Info.sidv", @"PhotosFolderAlbums", @"PhotosFolderName", @"PhotosFolderPrefs", @"iPhotoAlbumPrefs", @"iTunesApplicationIDs", @"iTunesPrefs", @"iTunesPrefs.plist", nil];
    
    NSString *tempFilePath;
    NSMutableDictionary *itunesFileDic = [[NSMutableDictionary alloc] init];
    for (int i =  0; i < [itunesFiles count]; i++) {
        tempFilePath = [NSString stringWithFormat:@"/iTunes_Control/iTunes/%@", [itunesFiles objectAtIndex:i]];
        
        if ([mediaDirectory fileExistsAtPath:tempFilePath]) {
            fileData = [[NSMutableData alloc] init];
            fileHandle = [mediaDirectory openForRead:tempFilePath];
            
            while (1) {
                memset(buff, 0, bufsz);
                uint64_t n = [fileHandle readN:bufsz bytes:buff];
                if (n==0) break;
                NSData *b2 = [[NSData alloc]
                              initWithBytesNoCopy:buff length:n freeWhenDone:NO];
                [fileData appendData:b2];
                [b2 release];
                done += n;
            }
            [fileHandle closeFile];
            [itunesFileDic setObject:fileData forKey:(NSString*)[itunesFiles objectAtIndex:i]];
            [fileData release];
        }
    }
    if (itunesFileDic != nil && [[itunesFileDic allKeys] count] > 0) {
        [infoPlist setObject:itunesFileDic forKey:@"iTunes Files"];
    }
    [itunesFileDic release];
    [mediaDirectory close];
    
    NSString * itunesSettings = [deviceHandle deviceValueForKey:nil inDomain:@"com.apple.iTunes"];
    [infoPlist setValue:itunesSettings forKey:@"iTunes Settings"];
    NSString *itunesInfoFilePath = @"/Applications/iTunes.app/Contents/Info.plist";
    NSDictionary *itunesInfoDic = [NSDictionary dictionaryWithContentsOfFile:itunesInfoFilePath];
    NSArray *allKey = [itunesInfoDic allKeys];
    if ([allKey containsObject:@"CFBundleVersion"]) {
        [infoPlist setValue:[itunesInfoDic valueForKey:@"CFBundleVersion"] forKey:@"iTunes Version"];
    }
    [infoPlist writeToFile:filePath atomically:YES];
    [infoPlist release];
}

//停止备份还原
- (void)stopBackupRestore {
    [IMBHelper killProcessByProcessName:@"iMobieBackupRestoreDevice"];
    if (iPod) {
        [iPod.deviceHandle cancelBackupRestore];
    }
    [IMBHelper killProcessByProcessName:@"AppleMobileBackup"];
}

#pragma mark - 通过访问服务方式备份还原设备
- (void)backupByService:(NSString *)backupPath withCondition:(NSCondition *)condition {
    [_logHandle writeInfoLog:@"backupByService start"];
    if (_backupRestore != nil) {
        [_backupRestore release];
        _backupRestore = nil;
    }
    _backupRestore = [iPod.deviceHandle newAMMobileBackupRestore];
    if (_backupRestore != nil && _backupRestore.handShakeStatus) {
        [_backupRestore setCondition:condition];
//        [iPod.fileSystem startSync:YES];
        [_backupRestore requestWithExcute:EXCUTE_BACKUP withBackupPath:backupPath withSourceUUID:nil withIsFullBackup:NO withAFCDirectory:iPod.fileSystem.afcMediaDirectory];
//        [iPod.fileSystem endSync];
    }else {
        NSNumber *errorId = [NSNumber numberWithInt:-110];
        NSString *error = @"ERROR: Backup handle is nil";
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:error, @"errorReason", errorId, @"errorId", nil];
        [nc postNotificationName:NOTIFY_BACKUP_ERROR object:nil userInfo:dic];
        [_logHandle writeInfoLog:@"backupByService failed"];
    }
    if (_backupRestore != nil) {
        [_backupRestore release];
        _backupRestore = nil;
    }
    [_logHandle writeInfoLog:@"backupByService end"];
}

- (void)cancelBackupOrRestore {
    if (_backupRestore != nil) {
        [_backupRestore setQuitFlag:YES];
    }
}

- (void)restoreByService:(NSString *)restorePath withSourceUUID:(NSString *)sourceUUID {
    [_logHandle writeInfoLog:@"restoreByService start"];
    if (_backupRestore != nil) {
        [_backupRestore release];
        _backupRestore = nil;
    }
    _backupRestore = [iPod.deviceHandle newAMMobileBackupRestore];
    if (_backupRestore != nil && _backupRestore.handShakeStatus) {
        NSCondition *condition = [[NSCondition alloc] init];
        [_backupRestore setCondition:condition];
        [_backupRestore setRestoreReboot:YES];
        [_backupRestore requestWithExcute:EXCUTE_RESTORE withBackupPath:restorePath withSourceUUID:sourceUUID withIsFullBackup:YES withAFCDirectory:iPod.fileSystem.afcMediaDirectory];
        [condition release];
        condition = nil;
    }else {
        [_logHandle writeInfoLog:@"restoreByService failed"];
        NSNumber *errorId = [NSNumber numberWithInt:-2];
        NSString *error = @"ERROR: Restore handle is nil";
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:error, @"errorReason", errorId, @"errorId", nil];
        [nc postNotificationName:NOTIFY_RESTORE_ERROR object:nil userInfo:dic];
    }
    AFCMediaDirectory *dir = [iPod.deviceHandle newAFCMediaDirectory];
    [dir close];
    if (_backupRestore != nil) {
        [_backupRestore release];
        _backupRestore = nil;
    }
    [_logHandle writeInfoLog:@"restoreByService end"];
}

#pragma mark - 暂停方法
- (void)pauseScan {
    ScanStatus *scanStatus = [ScanStatus shareInstance];
    [_condition lock];
    if(!scanStatus.isPause)
    {
        scanStatus.isPause = YES;
    }
    [_condition unlock];
}

- (void)resumeScan {
    ScanStatus *scanStatus = [ScanStatus shareInstance];
    [_condition lock];
    if(scanStatus.isPause)
    {
        scanStatus.isPause = NO;
        [_condition signal];
    }
    [_condition unlock];
}

- (void)stopScan {
    [_condition lock];
    [ScanStatus shareInstance].stopScan = YES;
    [self cancelBackupOrRestore];
    [_condition signal];
    [_condition unlock];
}

@end
