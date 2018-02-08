//
//  IMBWifiBackupConfig.h
//  AirBackupHelper
//
//  Created by iMobie on 10/17/17.
//  Copyright (c) 2017 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"

@interface IMBWifiBackupConfig : NSObject {
    BOOL _isAirBackup;
    int _backupDay;
    long long _lastBackupTime;
    NSString *_backupPath;
    int _electricityReminder;
    NSString *_savePath;
//    BOOL _airBackupMasterSwitch;//总开关
    int _lowElectricityTip;//低电量提醒
    BOOL _isBackupPhotoMedia;//备份photo media

    NSFileManager *fm;
    IMBiPod *_ipod;
}

@property (nonatomic, readwrite) BOOL isAirBackup;
@property (nonatomic, readwrite) int backupDay;
@property (nonatomic, readwrite) long long lastBackupTime;
@property (nonatomic, readwrite, retain) NSString *backupPath;
@property (nonatomic, readwrite) int electricityReminder;
@property (nonatomic, readwrite, retain) NSString *savePath;
//@property (nonatomic, readwrite) BOOL airBackupMasterSwitch;
@property (nonatomic, assign) int lowElectricityTip;
@property (nonatomic, readwrite) BOOL isBackupPhotoMedia;

- (id)initWithiPod:(IMBiPod *)ipod;
- (void)save;

@end
