//
//  IMBSystemSettingClone.m
//  iMobieTrans
//
//  Created by iMobie on 15-1-8.
//  Copyright (c) 2015年 iMobie Inc. All rights reserved.
//

#import "IMBSystemSettingClone.h"

@implementation IMBSystemSettingClone
@synthesize deviceName = _deviceName;
- (id)initWithSourceBackupPath:(NSString *)sourceBackupPath desBackupPath:(NSString *)desBackupPath sourcerecordArray:(NSMutableArray *)sourcerecordArray targetrecordArray:(NSMutableArray *)targetrecordArray isClone:(BOOL)isClone
{
    if (self = [super init]) {
        _isClone = isClone;
        _sourceVersion = [IMBBaseClone getBackupFileVersion:sourceBackupPath];
        _targetVersion = [IMBBaseClone getBackupFileVersion:desBackupPath];
        _sourceFloatVersion = [[IMBBaseClone getBackupFileFloatVersion:sourceBackupPath] retain];
        _targetFloatVersion = [[IMBBaseClone getBackupFileFloatVersion:desBackupPath] retain];
        _sourceBackuppath = [sourceBackupPath retain];
        _targetBakcuppath = [desBackupPath retain];
        //解析manifest
        _sourcerecordArray = [sourcerecordArray retain];
        _targetrecordArray = [targetrecordArray retain];
        
        _highPreferencesRecord = [[self getDBFileRecord:@"SystemPreferencesDomain" path:@"SystemConfiguration/preferences.plist" recordArray:_sourcerecordArray] retain];
        _lowPreferencesRecord = [[self getDBFileRecord:@"SystemPreferencesDomain" path:@"SystemConfiguration/preferences.plist" recordArray:_targetrecordArray] retain];
        _highOSthermalStatusRecord = [[self getDBFileRecord:@"SystemPreferencesDomain" path:@"SystemConfiguration/OSThermalStatus.plist" recordArray:_sourcerecordArray] retain];
        _lowOSthermalStatusRecord = [[self getDBFileRecord:@"SystemPreferencesDomain" path:@"SystemConfiguration/OSThermalStatus.plist" recordArray:_targetrecordArray] retain];
         _highexistsRecord = [[self getDBFileRecord:@"SystemPreferencesDomain" path:@"SystemConfiguration/com.apple.accounts.exists.plist" recordArray:_sourcerecordArray] retain];
         _lowexistsRecord = [[self getDBFileRecord:@"SystemPreferencesDomain" path:@"SystemConfiguration/com.apple.accounts.exists.plist" recordArray:_targetrecordArray] retain];
        _highwifiRecord = [[self getDBFileRecord:@"SystemPreferencesDomain" path:@"SystemConfiguration/com.apple.wifi.plist" recordArray:_sourcerecordArray] retain];
         _lowwifiRecord = [[self getDBFileRecord:@"SystemPreferencesDomain" path:@"SystemConfiguration/com.apple.wifi.plist" recordArray:_targetrecordArray] retain];
         _highprobeRecord = [[self getDBFileRecord:@"SystemPreferencesDomain" path:@"SystemConfiguration/com.apple.captive.probe.plist" recordArray:_sourcerecordArray] retain];
         _lowprobeRecord = [[self getDBFileRecord:@"SystemPreferencesDomain" path:@"SystemConfiguration/com.apple.captive.probe.plist" recordArray:_targetrecordArray] retain];
        
        _mobilegestaltRecord = [[self getDBFileRecord:@"SystemPreferencesDomain" path:@"SystemConfiguration/com.apple.mobilegestalt.plist" recordArray:_targetrecordArray] retain];
        _highoriginalLockBackgroundRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/SpringBoard/OriginalLockBackground.cpbitmap" recordArray:_sourcerecordArray] retain];
        _loworiginalLockBackgroundRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/SpringBoard/OriginalLockBackground.cpbitmap" recordArray:_targetrecordArray] retain];
        _highlockoutStateJournalRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/SpringBoard/LockoutStateJournal.plist" recordArray:_sourcerecordArray] retain];
        _lowlockoutStateJournalRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/SpringBoard/LockoutStateJournal.plist" recordArray:_targetrecordArray] retain];
        _highlockBackgroundRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/SpringBoard/LockBackground.cpbitmap" recordArray:_sourcerecordArray] retain];
        _lowlockBackgroundRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/SpringBoard/LockBackground.cpbitmap" recordArray:_targetrecordArray] retain];
        _highIconStateRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/SpringBoard/IconState.plist" recordArray:_sourcerecordArray] retain];
        _lowIconStateRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/SpringBoard/IconState.plist" recordArray:_targetrecordArray] retain];
        _highDesiredIconStateRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/SpringBoard/DesiredIconState.plist" recordArray:_sourcerecordArray] retain];
        _lowDesiredIconStateRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/SpringBoard/DesiredIconState.plist" recordArray:_targetrecordArray] retain];
        _highLockBackgroundThumbnailRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/SpringBoard/LockBackgroundThumbnail.jpg" recordArray:_sourcerecordArray] retain];
        _lowLockBackgroundThumbnailRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/SpringBoard/LockBackgroundThumbnail.jpg" recordArray:_targetrecordArray] retain];
        
        _highUserSettingsRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/ConfigurationProfiles/UserSettings.plist" recordArray:_sourcerecordArray] retain];
        _lowUserSettingsRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/ConfigurationProfiles/UserSettings.plist" recordArray:_targetrecordArray] retain];
        _highLockdownParametersRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/ConfigurationProfiles/LockdownParameters.plist" recordArray:_sourcerecordArray] retain];
        _lowLockdownParametersRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/ConfigurationProfiles/LockdownParameters.plist" recordArray:_targetrecordArray] retain];
        _highEffectiveUserSettingsRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/ConfigurationProfiles/EffectiveUserSettings.plist" recordArray:_sourcerecordArray] retain];
        _lowEffectiveUserSettingsRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/ConfigurationProfiles/EffectiveUserSettings.plist" recordArray:_targetrecordArray] retain];
        _highCloudConfigurationDetailsRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/ConfigurationProfiles/CloudConfigurationDetails.plist" recordArray:_sourcerecordArray] retain];
        _lowCloudConfigurationDetailsRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/ConfigurationProfiles/CloudConfigurationDetails.plist" recordArray:_targetrecordArray] retain];
        _highAppAccessibilityParametersRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/ConfigurationProfiles/AppAccessibilityParameters.plist" recordArray:_sourcerecordArray] retain];
        _lowAppAccessibilityParametersRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/ConfigurationProfiles/AppAccessibilityParameters.plist" recordArray:_targetrecordArray] retain];
    }
    return self;
}


- (void)clone
{
    //开启数据库
    if (_sourceVersion<=_targetVersion) {
        if ([_sourceFloatVersion isVersionLessEqual:_targetFloatVersion]) {
            if (isneedClone) {
                return;
            }
        }else
        {
            if (!isneedClone) {
                return;
            }
        }
    }else
    {
        if (!isneedClone) {
            return;
        }
    }
    [self replaceLowPlist];
    [self modifyPlist];
    [self modifyHashAndManifest];
}

- (void)modifyPlist
{
    if (_mobilegestaltRecord != nil) {
        NSString *mobilegestaltPath = [_targetBakcuppath stringByAppendingPathComponent:_mobilegestaltRecord.key];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:mobilegestaltPath];
        [dic setObject:_deviceName?_deviceName:@"" forKey:@"UserAssignedDeviceName"];
        [dic writeToFile:mobilegestaltPath atomically:YES];
        [dic release];
    }
}

//替换低版本的plist文件
- (void)replaceLowPlist
{
    [_logHandle writeInfoLog:@"replaceLowPlist enter"];
    NSFileManager *fileM = [NSFileManager defaultManager];
    NSString *highPreferencesPath = [_sourceBackuppath stringByAppendingPathComponent:_highPreferencesRecord.key];
    NSString *lowPreferencesPath = [_targetBakcuppath stringByAppendingPathComponent:_lowPreferencesRecord.key];
    if ([fileM fileExistsAtPath:lowPreferencesPath]&&_lowPreferencesRecord!=nil&&_highPreferencesRecord!= nil) {
        [fileM removeItemAtPath:lowPreferencesPath error:nil];
        [fileM copyItemAtPath:highPreferencesPath toPath:lowPreferencesPath error:nil];//
    }
   
    NSString *highOSthermalStatusPath = [_sourceBackuppath stringByAppendingPathComponent:_highOSthermalStatusRecord.key];
    NSString *lowOSthermalStatusPath = [_targetBakcuppath stringByAppendingPathComponent:_lowOSthermalStatusRecord.key];
    if ([fileM fileExistsAtPath:lowOSthermalStatusPath]&&_lowOSthermalStatusRecord != nil&&_highOSthermalStatusRecord!= nil) {
        [fileM removeItemAtPath:lowOSthermalStatusPath error:nil];
        [fileM copyItemAtPath:highOSthermalStatusPath toPath:lowOSthermalStatusPath error:nil];//
    }
    
    NSString *highexistsPath = [_sourceBackuppath stringByAppendingPathComponent:_highexistsRecord.key];
    NSString *lowexistsPath = [_targetBakcuppath stringByAppendingPathComponent:_lowexistsRecord.key];
    if ([fileM fileExistsAtPath:lowexistsPath]&&_lowexistsRecord != nil&&_highexistsRecord!=nil) {
        [fileM removeItemAtPath:lowexistsPath error:nil];
        [fileM copyItemAtPath:highexistsPath toPath:lowexistsPath error:nil];//
    }
   
    NSString *highwifiPath = [_sourceBackuppath stringByAppendingPathComponent:_highwifiRecord.key];
    NSString *lowwifiPath = [_targetBakcuppath stringByAppendingPathComponent:_lowwifiRecord.key];
    if ([fileM fileExistsAtPath:lowwifiPath]&&_lowwifiRecord != nil&&_highwifiRecord!=nil) {
        [fileM removeItemAtPath:lowwifiPath error:nil];
        [fileM copyItemAtPath:highwifiPath toPath:lowwifiPath error:nil];//
    }
    
    NSString *highprobePath = [_sourceBackuppath stringByAppendingPathComponent:_highprobeRecord.key];
    NSString *lowprobePath = [_targetBakcuppath stringByAppendingPathComponent:_lowprobeRecord.key];
    if ([fileM fileExistsAtPath:lowprobePath]&&_lowprobeRecord != nil&&_highprobeRecord!=nil) {
        [fileM removeItemAtPath:lowprobePath error:nil];
        [fileM copyItemAtPath:highprobePath toPath:lowprobePath error:nil];//
    }
   
    NSString *highoriginalLockBackgroundPath = [_sourceBackuppath stringByAppendingPathComponent:_highoriginalLockBackgroundRecord.key];
    NSString *loworiginalLockBackgroundPath = [_targetBakcuppath stringByAppendingPathComponent:_loworiginalLockBackgroundRecord.key];
    if ([fileM fileExistsAtPath:loworiginalLockBackgroundPath]&&_loworiginalLockBackgroundRecord != nil&&_highoriginalLockBackgroundRecord!=nil) {
        [fileM removeItemAtPath:loworiginalLockBackgroundPath error:nil];
        [fileM copyItemAtPath:highoriginalLockBackgroundPath toPath:loworiginalLockBackgroundPath error:nil];//
    }
    
    NSString *higlockoutStateJournalPath = [_sourceBackuppath stringByAppendingPathComponent:_highlockoutStateJournalRecord.key];
    NSString *lowlockoutStateJournalPath = [_targetBakcuppath stringByAppendingPathComponent:_lowlockoutStateJournalRecord.key];
    if ([fileM fileExistsAtPath:lowlockoutStateJournalPath]&&_lowlockoutStateJournalRecord != nil&&_highlockoutStateJournalRecord!=nil) {
        [fileM removeItemAtPath:lowlockoutStateJournalPath error:nil];
        [fileM copyItemAtPath:higlockoutStateJournalPath toPath:lowlockoutStateJournalPath error:nil];//
    }
    
    NSString *higlockBackgroundPath = [_sourceBackuppath stringByAppendingPathComponent:_highlockBackgroundRecord.key];
    NSString *lowllockBackgroundPath = [_targetBakcuppath stringByAppendingPathComponent:_lowlockBackgroundRecord.key];
    if ([fileM fileExistsAtPath:lowllockBackgroundPath]&&_lowlockBackgroundRecord != nil&&_highlockBackgroundRecord!=nil) {
        [fileM removeItemAtPath:lowllockBackgroundPath error:nil];
        [fileM copyItemAtPath:higlockBackgroundPath toPath:lowllockBackgroundPath error:nil];//
    }
    
    NSString *higIconStatePath = [_sourceBackuppath stringByAppendingPathComponent:_highIconStateRecord.key];
    NSString *lowIconStatePath = [_targetBakcuppath stringByAppendingPathComponent:_lowIconStateRecord.key];
    if ([fileM fileExistsAtPath:lowIconStatePath]&&_lowIconStateRecord != nil&&_highIconStateRecord!=nil) {
        [fileM removeItemAtPath:lowIconStatePath error:nil];
        [fileM copyItemAtPath:higIconStatePath toPath:lowIconStatePath error:nil];//
    }
    
    NSString *higDesiredIconStatePath = [_sourceBackuppath stringByAppendingPathComponent:_highDesiredIconStateRecord.key];
    NSString *lowDesiredIconStatePath = [_targetBakcuppath stringByAppendingPathComponent:_lowDesiredIconStateRecord.key];
    if ([fileM fileExistsAtPath:lowDesiredIconStatePath]&&_lowDesiredIconStateRecord != nil&&_highDesiredIconStateRecord!=nil) {
        [fileM removeItemAtPath:lowDesiredIconStatePath error:nil];
        [fileM copyItemAtPath:higDesiredIconStatePath toPath:lowDesiredIconStatePath error:nil];//
    }
    
    NSString *higUserSettingsPath = [_sourceBackuppath stringByAppendingPathComponent:_highUserSettingsRecord.key];
    NSString *lowUserSettingsPath = [_targetBakcuppath stringByAppendingPathComponent:_lowUserSettingsRecord.key];
    if ([fileM fileExistsAtPath:lowUserSettingsPath]&&_lowUserSettingsRecord != nil&&_highUserSettingsRecord!=nil) {
        [fileM removeItemAtPath:lowUserSettingsPath error:nil];
        [fileM copyItemAtPath:higUserSettingsPath toPath:lowUserSettingsPath error:nil];
    }
  
    NSString *higLockdownParametersPath = [_sourceBackuppath stringByAppendingPathComponent:_highLockdownParametersRecord.key];
    NSString *lowLockdownParametersPath = [_targetBakcuppath stringByAppendingPathComponent:_lowLockdownParametersRecord.key];
    if ([fileM fileExistsAtPath:lowLockdownParametersPath]&&_lowLockdownParametersRecord != nil&&_highLockdownParametersRecord!=nil) {
        [fileM removeItemAtPath:lowLockdownParametersPath error:nil];
        [fileM copyItemAtPath:higLockdownParametersPath toPath:lowLockdownParametersPath error:nil];
    }
    
    NSString *higEffectiveUserSettingsPath = [_sourceBackuppath stringByAppendingPathComponent:_highEffectiveUserSettingsRecord.key];
    NSString *lowEffectiveUserSettingsPath = [_targetBakcuppath stringByAppendingPathComponent:_lowEffectiveUserSettingsRecord.key];
    if ([fileM fileExistsAtPath:lowEffectiveUserSettingsPath]&&_lowEffectiveUserSettingsRecord != nil&&_highEffectiveUserSettingsRecord!=nil) {
        [fileM removeItemAtPath:lowEffectiveUserSettingsPath error:nil];
        [fileM copyItemAtPath:higEffectiveUserSettingsPath toPath:lowEffectiveUserSettingsPath error:nil];
    }
    
    NSString *higAppAccessibilityParametersPath = [_sourceBackuppath stringByAppendingPathComponent:_highAppAccessibilityParametersRecord.key];
    NSString *lowAppAccessibilityParametersPath = [_targetBakcuppath stringByAppendingPathComponent:_lowAppAccessibilityParametersRecord.key];
    if ([fileM fileExistsAtPath:lowAppAccessibilityParametersPath]&&_lowAppAccessibilityParametersRecord != nil&&_highAppAccessibilityParametersRecord!=nil) {
        [fileM removeItemAtPath:lowAppAccessibilityParametersPath error:nil];
        [fileM copyItemAtPath:higAppAccessibilityParametersPath toPath:lowAppAccessibilityParametersPath error:nil];
    }
    NSString *higLockBackgroundThumbnailPath = [_sourceBackuppath stringByAppendingPathComponent:_highLockBackgroundThumbnailRecord.key];
    NSString *lowLockBackgroundThumbnailPath = [_targetBakcuppath stringByAppendingPathComponent:_lowLockBackgroundThumbnailRecord.key];
    if ([fileM fileExistsAtPath:lowLockBackgroundThumbnailPath]&&_lowLockBackgroundThumbnailRecord != nil&&_highLockBackgroundThumbnailRecord!=nil) {
        [fileM removeItemAtPath:lowLockBackgroundThumbnailPath error:nil];
        [fileM copyItemAtPath:higLockBackgroundThumbnailPath toPath:lowLockBackgroundThumbnailPath error:nil];
    }
    [_logHandle writeInfoLog:@"replaceLowPlist exit"];

}
- (void)modifyHashAndManifest
{
    //修改manifest
    NSMutableArray *lownewRecordArray = [[NSMutableArray alloc] initWithArray:_targetrecordArray];
    for (int i=0;i<[lownewRecordArray count];i++) {
        IMBMBFileRecord *lowrecord = [lownewRecordArray objectAtIndex:i];
        if (lowrecord == _lowPreferencesRecord &&_highPreferencesRecord != nil) {
            [lownewRecordArray replaceObjectAtIndex:i withObject:_highPreferencesRecord];
        }else if (lowrecord == _lowOSthermalStatusRecord&&_highOSthermalStatusRecord!=nil) {
            [lownewRecordArray replaceObjectAtIndex:i withObject:_highOSthermalStatusRecord];
        }else if (lowrecord == _lowexistsRecord&&_highexistsRecord != nil) {
            [lownewRecordArray replaceObjectAtIndex:i withObject:_highexistsRecord];
        }else if (lowrecord == _lowwifiRecord&&_highwifiRecord != nil) {
            [lownewRecordArray replaceObjectAtIndex:i withObject:_highwifiRecord];
        }else if (lowrecord == _lowprobeRecord&&_highprobeRecord != nil) {
            [lownewRecordArray replaceObjectAtIndex:i withObject:_highprobeRecord];
        }else if (lowrecord == _loworiginalLockBackgroundRecord&&_highoriginalLockBackgroundRecord != nil) {
            [lownewRecordArray replaceObjectAtIndex:i withObject:_highoriginalLockBackgroundRecord];
        }else if (lowrecord == _lowlockoutStateJournalRecord&&_highlockoutStateJournalRecord != nil) {
            [lownewRecordArray replaceObjectAtIndex:i withObject:_highlockoutStateJournalRecord];
        }else if (lowrecord == _lowlockBackgroundRecord&&_highlockBackgroundRecord != nil) {
            [lownewRecordArray replaceObjectAtIndex:i withObject:_highlockBackgroundRecord];
        }else if (lowrecord == _lowIconStateRecord&&_highIconStateRecord != nil) {
            [lownewRecordArray replaceObjectAtIndex:i withObject:_highIconStateRecord];
        }else if (lowrecord == _lowDesiredIconStateRecord&&_highDesiredIconStateRecord != nil) {
            [lownewRecordArray replaceObjectAtIndex:i withObject:_highDesiredIconStateRecord];
        }else if (lowrecord == _lowUserSettingsRecord&&_highUserSettingsRecord != nil) {
            [lownewRecordArray replaceObjectAtIndex:i withObject:_highUserSettingsRecord];
        }else if (lowrecord == _lowLockdownParametersRecord&&_highLockdownParametersRecord != nil) {
            [lownewRecordArray replaceObjectAtIndex:i withObject:_highLockdownParametersRecord];
        }else if (lowrecord == _lowEffectiveUserSettingsRecord&&_highEffectiveUserSettingsRecord != nil) {
            [lownewRecordArray replaceObjectAtIndex:i withObject:_highEffectiveUserSettingsRecord];
        }else if (lowrecord == _lowCloudConfigurationDetailsRecord&&_highCloudConfigurationDetailsRecord != nil) {
            //[lownewRecordArray replaceObjectAtIndex:i withObject:_highCloudConfigurationDetailsRecord];
        }else if (lowrecord == _lowAppAccessibilityParametersRecord&&_highAppAccessibilityParametersRecord != nil) {
            [lownewRecordArray replaceObjectAtIndex:i withObject:_highAppAccessibilityParametersRecord];
        }else if (lowrecord == _lowLockBackgroundThumbnailRecord&&_highLockBackgroundThumbnailRecord != nil) {
            [lownewRecordArray replaceObjectAtIndex:i withObject:_highLockBackgroundThumbnailRecord];
        }
    }
    if (_mobilegestaltRecord != nil) {
        [IMBBaseClone reCaculateRecordHash:_mobilegestaltRecord backupFolderPath:_targetBakcuppath];
    }
    [IMBBaseClone saveMBDB:lownewRecordArray cacheFilePath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"lowManifest.mbdb"] backupFolderPath:_targetBakcuppath];
}



- (void)dealloc
{
    [_highPreferencesRecord release],_highPreferencesRecord = nil;
    [_lowPreferencesRecord release],_lowPreferencesRecord = nil;
    [_highOSthermalStatusRecord release],_highOSthermalStatusRecord = nil;
    [_lowOSthermalStatusRecord release],_lowOSthermalStatusRecord = nil;
    [_highexistsRecord release],_highexistsRecord = nil;
    [_lowexistsRecord release],_lowexistsRecord = nil;
    [_highwifiRecord release],_highwifiRecord = nil;
    [_lowwifiRecord release],_lowwifiRecord = nil;
    [_highprobeRecord release],_highprobeRecord = nil;
    [_lowprobeRecord release],_lowprobeRecord = nil;
    
      //把设备名替换到该plist文件中
    [_mobilegestaltRecord release], _mobilegestaltRecord =nil;
    [_highoriginalLockBackgroundRecord release], _highoriginalLockBackgroundRecord =nil;
    [_loworiginalLockBackgroundRecord release], _loworiginalLockBackgroundRecord =nil;
    [_highlockoutStateJournalRecord release], _highlockoutStateJournalRecord =nil;
    [_lowlockoutStateJournalRecord release], _lowlockoutStateJournalRecord =nil;
    [_highlockBackgroundRecord release], _highlockBackgroundRecord =nil;
    [_lowlockBackgroundRecord release], _lowlockBackgroundRecord =nil;
    [_highIconStateRecord release], _highIconStateRecord =nil;
    [_lowIconStateRecord release], _lowIconStateRecord =nil;
    [_highDesiredIconStateRecord release], _highDesiredIconStateRecord =nil;
    [_lowDesiredIconStateRecord release], _lowDesiredIconStateRecord =nil;
    [_highUserSettingsRecord release], _highUserSettingsRecord =nil;
    [_lowUserSettingsRecord release], _lowUserSettingsRecord =nil;
    [_highLockdownParametersRecord release], _highLockdownParametersRecord =nil;
    [_lowLockdownParametersRecord release], _lowLockdownParametersRecord =nil;
    [_highEffectiveUserSettingsRecord release], _highEffectiveUserSettingsRecord =nil;
    [_lowEffectiveUserSettingsRecord release], _lowEffectiveUserSettingsRecord =nil;
    [_highCloudConfigurationDetailsRecord release], _highCloudConfigurationDetailsRecord =nil;
    [_lowCloudConfigurationDetailsRecord release], _lowCloudConfigurationDetailsRecord =nil;
    [_highAppAccessibilityParametersRecord release], _highAppAccessibilityParametersRecord =nil;
    [_lowAppAccessibilityParametersRecord release], _lowAppAccessibilityParametersRecord =nil;
    [_highLockBackgroundThumbnailRecord release], _highLockBackgroundThumbnailRecord =nil;
    [_lowLockBackgroundThumbnailRecord release], _lowLockBackgroundThumbnailRecord =nil;
    [_deviceName release], _deviceName =nil;
    [super dealloc];

}
@end
