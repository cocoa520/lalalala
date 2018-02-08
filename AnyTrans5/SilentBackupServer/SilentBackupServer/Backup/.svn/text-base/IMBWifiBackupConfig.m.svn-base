//
//  IMBWifiBackupConfig.m
//  AirBackupHelper
//
//  Created by iMobie on 10/17/17.
//  Copyright (c) 2017 iMobie. All rights reserved.
//

#import "IMBWifiBackupConfig.h"
#import "IMBHelper.h"
#import "IMBAMDeviceInfo.h"

@implementation IMBWifiBackupConfig
@synthesize isAirBackup = _isAirBackup;
@synthesize backupDay = _backupDay;
@synthesize lastBackupTime = _lastBackupTime;
@synthesize backupPath = _backupPath;
@synthesize electricityReminder = _electricityReminder;
@synthesize savePath = _savePath;
//@synthesize airBackupMasterSwitch = _airBackupMasterSwitch;
@synthesize lowElectricityTip = _lowElectricityTip;
@synthesize isBackupPhotoMedia = _isBackupPhotoMedia;

- (id)initWithiPod:(IMBiPod *)ipod {
    self = [super init];
    if (self) {
        _ipod = ipod;
        _isBackupPhotoMedia = YES;
//        _airBackupMasterSwitch = NO;
        _isAirBackup = YES;
        _lowElectricityTip = 10;
        _backupDay = 3;
        _lastBackupTime = 0;
        _backupPath  = [[IMBHelper getBackupFolderPath] retain];
        _electricityReminder = 20;
        _savePath = [[[IMBHelper getAppConfigPath] stringByAppendingPathComponent:@"airBackupConfig.plist"] retain];
        fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:_savePath]) {
            NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:_savePath];
            if (dic != nil) {
                if ([dic.allKeys containsObject:_ipod.deviceInfo.serialNumber]) {
                    NSDictionary *spiDic = [dic objectForKey:_ipod.deviceInfo.serialNumber];
                    if (spiDic != nil) {
                        if ([spiDic.allKeys containsObject:@"IsAirBackup"]) {
                            _isAirBackup = [[spiDic objectForKey:@"IsAirBackup"] boolValue];
                        }
                        if ([spiDic.allKeys containsObject:@"BackupDay"]) {
                            _backupDay = [[spiDic objectForKey:@"BackupDay"] intValue];
                        }
                        if ([spiDic.allKeys containsObject:@"LastBackupTime"]) {
                            _lastBackupTime = [[spiDic objectForKey:@"LastBackupTime"] longLongValue];
                        }
                    }
                }
                if ([dic.allKeys containsObject:@"BackupPath"]) {
                    if (_backupPath) {
                        [_backupPath release];
                        _backupPath = nil;
                    }
                    _backupPath = [[dic objectForKey:@"BackupPath"] retain];
                }
                
//                if ([dic.allKeys containsObject:@"AirBackupMasterSwitch"]) {
//                    _airBackupMasterSwitch = [[dic objectForKey:@"AirBackupMasterSwitch"] boolValue];
//                }
                if ([dic.allKeys containsObject:@"ElectricityReminder"]) {
                    _electricityReminder = [[dic objectForKey:@"ElectricityReminder"] intValue];
                }
                if ([dic.allKeys containsObject:@"LowElectricityTip"]) {
                    _lowElectricityTip = [[dic objectForKey:@"LowElectricityTip"] intValue];
                }
                if ([dic.allKeys containsObject:@"PhotoMediaBackupIsOn"]) {
                    _isBackupPhotoMedia = [[dic objectForKey:@"PhotoMediaBackupIsOn"] boolValue];
                }
            }
        }
    }
    return self;
}

- (void)dealloc {
    if (_backupPath) {
        [_backupPath release];
        _backupPath = nil;
    }
    if (_savePath) {
        [_savePath release];
        _savePath = nil;
    }
    [super dealloc];
}

- (void)save {
    NSMutableDictionary *dic = nil;
    NSMutableDictionary *subDic = nil;
    if ([fm fileExistsAtPath:_savePath]) {
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:_savePath];
        if ([dic.allKeys containsObject:_ipod.deviceInfo.serialNumber]) {
            subDic = [dic objectForKey:_ipod.deviceInfo.serialNumber];
        }else {
            subDic = [NSMutableDictionary dictionary];
        }
    }else {
        dic = [[NSMutableDictionary alloc] init];
        subDic = [NSMutableDictionary dictionary];
    }
    [subDic setObject:[NSNumber numberWithBool:_isAirBackup] forKey:@"IsAirBackup"];
    [subDic setObject:[NSNumber numberWithInt:_backupDay] forKey:@"BackupDay"];
    _lastBackupTime = [[NSDate date] timeIntervalSince1970];
    [subDic setObject:[NSNumber numberWithLongLong:_lastBackupTime] forKey:@"LastBackupTime"];
    [dic setObject:_backupPath forKey:@"BackupPath"];
    [dic setObject:[NSNumber numberWithInt:_electricityReminder] forKey:@"ElectricityReminder"];
    [dic setObject:[NSNumber numberWithInt:_lowElectricityTip] forKey:@"LowElectricityTip"];
//    [dic setObject:[NSNumber numberWithBool:_airBackupMasterSwitch] forKey:@"AirBackupMasterSwitch"];
    [dic setObject:[NSNumber numberWithBool:_isBackupPhotoMedia] forKey:@"PhotoMediaBackupIsOn"];
    [dic setObject:subDic forKey:_ipod.deviceInfo.serialNumber];

    [dic writeToFile:_savePath atomically:YES];
    [dic release];
}

@end
