//
//  IMBVoicemailManager.m
//  iMobieTrans
//
//  Created by iMobie on 14-3-5.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBVoicemailManager.h"
#import "IMBVoicemailEntity.h"
#import "IMBInformationManager.h"
#import "IMBInformation.h"
#import "TempHelper.h"
#import "IMBBackAndRestore.h"
@implementation IMBVoicemailManager
@synthesize isFirst = _isFirst;
@synthesize isRefresh = _isRefresh;
@synthesize needDePassword = _needDePassword;
@synthesize voicemailData = _voicemailData;
@synthesize lastBackupScoend = _lastBackupScoend;

- (id)initWithAMDevice:(AMDevice *)device {
    self = [super initWithAMDevice:device];
    if (self) {
        _isRefresh = NO;
        _isFirst = NO;
        _lastBackupScoend = 0;
        _tmpPath = [[TempHelper getAppTempPath] retain];
        _backupFolder = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support/MobileSync/Backup"] retain];
    }
    return self;
}


- (void)queryAllVoicemail
{
    if (_voicemailData != nil) {
        [_voicemailData release];
        _voicemailData = nil;
    }
    
    if ([self getBackupPath]) {
        _voicemailData = [[IMBVoiceMailSqliteManager alloc] initWithAMDevice:_device backupfilePath:_backupPath withDBType:_iosVersion WithisEncrypted:_isEncrypted withBackUpDecrypt:_backupDecrypt];
        
        //copy 数据库到log中
        //        [self getSqliteFile];
        
        [_voicemailData querySqliteDBContentBackupPath:_backupPath];
    }
}

#pragma mark - 获取需要显示的备份文件夹
- (BOOL)getBackupPath {
    BOOL reslut = NO;
    
    IMBInformationManager *manager = [IMBInformationManager shareInstance];
    IMBInformation *information = [manager.informationDic objectForKey:_device.serialNumber];
    
    //从iTUnes备份里面去SMS
    if (!_isRefresh && [self findCurrentDeviceBackupFile]) {
        @autoreleasepool {
            if (_backupPath != nil) {
//                _isEncrypted = [self backupfileIsencrypt:_backupPath];
                if (_isEncrypted) {
                    if (_isFirst) {
                        return NO;
                    }
                    return NO;
//                    NSMutableDictionary *_passwordDic = [information passwordDic];
//                    _backupDecrypt = [_passwordDic objectForKey:_backupPath];
//                    if (_backupDecrypt == nil) {
////                        [[NSNotificationCenter defaultCenter] postNotificationName:DECRYPT_BACKUPFILE_PASSWORD object:_backupPath userInfo:[NSDictionary dictionaryWithObject:_device forKey:@"device"]];
//                        return NO;
//                    }else {
//                        reslut = YES;
//                    }
                }else {
                    reslut = YES;
                }
            }
        }
    }
    //从fileRelay里面去SMS
    if (!reslut) {
        /*_SMSMode = FileRelay;
         [self getSMSDatabasePathFileRelay];
         if ([fm fileExistsAtPath:_smsDataBasePath] && [fm fileExistsAtPath:_addressDatabasePath]) {
         reslut = YES;
         }*/
    }
    //从设备备份里面去SMS
    if (!reslut && !_isFirst) {
        @autoreleasepool {
            //backup
            IMBBackAndRestore *manager = [[IMBBackAndRestore alloc] initWithIPod:information.ipod];
            [manager backUp];
            _backupPath = [manager.deviceBackupPath retain];
            [manager release];
            
            if (_backupPath != nil && [fm fileExistsAtPath:_backupPath]) {
                _isEncrypted = [self backupfileIsencrypt:_backupPath];
                if (_isEncrypted) {
                    NSMutableDictionary *_passwordDic = [information passwordDic];
                    [_passwordDic removeObjectForKey:_backupPath];
                    _backupDecrypt = [_passwordDic objectForKey:_backupPath];
                    if (_backupDecrypt == nil) {
                        //NSDictionary *dic = [NSDictionary dictionaryWithObject:ipod forKey:@"ipod"];
                        _needDePassword = YES;
                        //                        [[NSNotificationCenter defaultCenter] postNotificationName:DECRYPT_BACKUPFILE_PASSWORD object:_backupPath userInfo:[NSDictionary dictionaryWithObject:_device forKey:@"device"]];
                        return NO;
                    }else {
                        reslut = YES;
                    }
                }else
                {
                    reslut = YES;
                }
            }
        }
    }
    return reslut;
}

//查找一个星期内device的备份文件
- (BOOL)findCurrentDeviceBackupFile {
    if ([self queryBackupItemFromiTunes]) {
        return YES;
    }
    return NO;
}

- (BOOL)queryBackupItemFromiTunes {
    BOOL reslut = NO;
    if (![TempHelper stringIsNilOrEmpty:_backupFolder]) {
        NSArray *dirArray = [fm directoryContentsAtPath:_backupFolder];
        if (dirArray != nil && dirArray.count > 0) {
            NSString *backupFile = nil;
            for (NSString *fileName in dirArray) {
                if ([fileName isEqualToString:@".DS_Store"]) {
                    continue;
                }
                backupFile = [_backupFolder stringByAppendingPathComponent:fileName];
                //读Manifest.plist文件
                NSString *manifestFilePath = [backupFile stringByAppendingPathComponent:@"Manifest.plist"];
                if ([fm fileExistsAtPath:manifestFilePath]) {
                    NSString *tmpManifestPath = [_tmpPath stringByAppendingPathComponent:@"Manifest.plist"];
                    if ([fm fileExistsAtPath:tmpManifestPath]) {
                        [fm removeItemAtPath:tmpManifestPath error:nil];
                    }
                    [fm copyItemAtPath:manifestFilePath toPath:tmpManifestPath error:nil];
                    NSDictionary *manifestDic = [NSDictionary dictionaryWithContentsOfFile:tmpManifestPath];
                    NSArray *allKey = [manifestDic allKeys];
                    if (allKey != nil & allKey.count > 0) {
                        if ([allKey containsObject:@"Lockdown"]) {
                            NSDictionary *lockdownDic = [manifestDic objectForKey:@"Lockdown"];
                            NSArray *ldAlllKeys = lockdownDic.allKeys;
                            NSString *serialNumber = nil;
                            if ([ldAlllKeys containsObject:@"SerialNumber"]) {
                                serialNumber = [lockdownDic objectForKey:@"SerialNumber"];
                            }
                            if ([serialNumber isEqualToString:_device.serialNumber]) {
                                NSDate *curDate = [NSDate date];
                                NSTimeInterval curScoend=[curDate timeIntervalSince1970]*1;
                                if ([allKey containsObject:@"Date"]) {
                                    NSDate *backupDate = [manifestDic objectForKey:@"Date"];
                                    NSTimeInterval backupScoend = [backupDate timeIntervalSince1970]*1;
                                    if (backupScoend > (curScoend - 604800)){
                                        if (backupScoend > _lastBackupScoend) {
                                            _lastBackupScoend = backupScoend;
                                            if (_backupPath != nil) {
                                                [_backupPath release];
                                                _backupPath = nil;
                                            }
                                            _backupPath = [backupFile retain];
                                        }
                                        if (_iosVersion != nil) {
                                            [_iosVersion release];
                                            _iosVersion = nil;
                                        }
                                        if ([lockdownDic.allKeys containsObject:@"ProductVersion"]) {
                                            _iosVersion = [[lockdownDic objectForKey:@"ProductVersion"] retain];
                                        }else {
                                            _iosVersion = [@"6.0.1" retain];
                                        }
                                        _isEncrypted = [[manifestDic objectForKey:@"IsEncrypted"] boolValue];
                                        reslut = YES;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return reslut;
}

//判断备份文件是否加密
- (BOOL)backupfileIsencrypt:(NSString *)backupPath
{
    //从备份文件目录下读取manifest.plist文件从它的encrypt属性去判断
    NSString *mpfilePath = [backupPath stringByAppendingPathComponent:@"Manifest.plist"];
    NSString *desfilePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"Manifest.plist"];
    if ([fm fileExistsAtPath:desfilePath]) {
        
        [fm removeItemAtPath:desfilePath error:nil];
    }
    [fm copyItemAtPath:mpfilePath toPath:desfilePath error:nil];
    NSDictionary *mpDic = [NSDictionary dictionaryWithContentsOfFile:desfilePath];
    if ([mpDic.allKeys containsObject:@"Lockdown"]) {
        NSDictionary *lockdownDic = [mpDic objectForKey:@"Lockdown"];
        if ([lockdownDic.allKeys containsObject:@"ProductVersion"]) {
            _iosVersion = [[lockdownDic objectForKey:@"ProductVersion"] retain];
        }else {
            _iosVersion = [@"6.0.1" retain];
        }
    }else {
        _iosVersion = [@"6.0.1" retain];
    }
    BOOL isEncrypted = [[mpDic objectForKey:@"IsEncrypted"] boolValue];
    return isEncrypted;
}

//通过fileRelay取数据库
+ (BOOL)getSMSDatabaseByFileRelay:(NSString*)cacheFilePath device:(AMDevice *)device {
    BOOL ret = NO;
    AMFileRelay *fileRelay = [device newAMFileRelay];
    NSOutputStream *outStream = [[NSOutputStream alloc] initToFileAtPath:cacheFilePath append:YES];
    //Voicemail
    if ([fileRelay getFileSet:@"Voicemail" into:outStream]) {
        ret = YES;
    } else {
        ret = NO;
    }
    [outStream release];
    [fileRelay release];
    return ret;
}

// 从备份中或者通过FileRelay取得联系人的数据表
+ (NSString *)getVoicemailDatabasePathFileRelaySqlitPath:(AMDevice *)device {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"UserDataBase.tar"];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    [self getSMSDatabaseByFileRelay:filePath device:device];
    NSString *decompressionFolder = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"FileRelay"];
    // 解压压缩包
    if ([fileManager fileExistsAtPath:decompressionFolder]) {
        [fileManager removeItemAtPath:decompressionFolder error:nil];
    }
    
    if (![fileManager fileExistsAtPath:decompressionFolder]) {
        [fileManager createDirectoryAtPath:decompressionFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [TempHelper unTarFile:filePath unTarPath:nil toDestFolder:decompressionFolder];
    sleep(1);
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    NSString *voicemailFileRelaySqlitePath = nil;
    if ([fileManager fileExistsAtPath:decompressionFolder]) {
       
        voicemailFileRelaySqlitePath = [decompressionFolder stringByAppendingPathComponent:@"var/mobile/Library/Voicemail/voicemail.db"];
        if ([fileManager fileExistsAtPath:voicemailFileRelaySqlitePath]) {
            
            return voicemailFileRelaySqlitePath;
        }
    }
    
    return nil;
}

- (void)dealloc
{
    if (_iosVersion != nil) {
        [_iosVersion release];
        _iosVersion = nil;
    }
    if (_voicemailData != nil) {
        [_voicemailData release];
        _voicemailData = nil;
    }
    if (_backupFolder != nil) {
        [_backupFolder release];
        _backupFolder = nil;
    }
    if (_tmpPath != nil) {
        [_tmpPath release];
        _tmpPath = nil;
    }
    if (_backupPath != nil) {
        [_backupPath release];
        _backupPath = nil;
    }
    [super dealloc];
}

@end
