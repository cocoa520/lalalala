//
//  AppDelegate.m
//  AirBackupHelper
//
//  Created by iMobie on 10/11/17.
//  Copyright (c) 2017 iMobie. All rights reserved.
//

#import "AppDelegate.h"
#import "IMBNotificationDefine.h"
#import "IMBSocketServer.h"
#import "IMBFileSystem.h"
#import "IMBWifiBackupConfig.h"

@implementation AppDelegate
@synthesize window = _window;
@synthesize ipod = _ipod;

- (void)setIpod:(IMBiPod *)ipod {
    if (_ipod) {
        [_ipod release];
        _ipod = nil;
    }
    _ipod = [ipod retain];
}

- (id)init {
    self = [super init];
    if (self) {
        nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(deviceConnected:) name:DeviceConnectedNotification object:nil];
        [nc addObserver:self selector:@selector(deviceDisconnected:) name:DeviceDisConnectedNotification object:nil];
        [nc addObserver:self selector:@selector(devicePwdProtected:) name:DeviceNeedPasswordNotification object:nil];
        [nc addObserver:self selector:@selector(deviceiPodLoadComplete:) name:DeviceIpodLoadCompleteNotification object:nil];
        
        [self checkLanguage];
        //注册设备连接通知
        _deviceConnection = [IMBDeviceConnection singleton];
        [_deviceConnection startListen];
        _logHandle = [IMBLogManager singleton];
    }
    return self;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return TRUE;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    [[NSUserDefaults standardUserDefaults] setObject:@[@"ja"] forKey:@"AppleLanguages"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    _notificationController = [[IMBNotificationWindowController alloc] init];
//    [_notificationController showWindow:self];
//    [self.window close];

    _mainRect = [[NSScreen mainScreen] frame];
    NSLog(@"mainRect:%f,%f,%f,%f",_mainRect.origin.x,_mainRect.origin.y,_mainRect.size.width,_mainRect.size.height);
    
    //TODO:测试
//    NSString *title = [NSString stringWithFormat:CustomLocalizedString(@"Backup_Start", nil),[IMBHelper cutOffString:@"iMobie'iPhone"], (int)100];
//    [self setUserNotificationCenter:title withSubTitle:nil withIsBackuping:YES withMode:3];
    
//    [self setUserNotificationCenter:[NSString stringWithFormat:CustomLocalizedString(@"Backup_Error", nil),[IMBHelper cutOffString:@"iMobie'iPhone"],-36] withSubTitle:nil withIsBackuping:NO withMode:6];
    
//    NSString *title = [NSString stringWithFormat:CustomLocalizedString(@"Backup_Complete", nil),[IMBHelper cutOffString:@"iMobie'iPhone"]];
//    [self setUserNotificationCenter:title withSubTitle:nil withIsBackuping:NO withMode:4];
    
//    NSString *title = [NSString stringWithFormat:CustomLocalizedString(@"Backup_Complete", nil),[IMBHelper cutOffString:@"iMobie'iPhone"]];
//    NSString *subTitle = [NSString stringWithFormat:CustomLocalizedString(@"Backup_Complete_Limite1", nil),@"5GB"];
//    [self setUserNotificationCenter:title withSubTitle:subTitle withIsBackuping:NO withMode:5];
    
//    NSString *title = [IMBHelper cutOffString:@"iMobie'iPhone"];
//    NSString *subTitle = CustomLocalizedString(@"Backup_Complete_Limite2", nil);
//    [self setUserNotificationCenter:title withSubTitle:subTitle withIsBackuping:NO withMode:2];

//    [self setUserNotificationCenter:CustomLocalizedString(@"Backup_Complete_Limite2", nil) withSubTitle:nil withIsBackuping:NO withMode:2];
    
//    [self setUserNotificationCenter:[NSString stringWithFormat:CustomLocalizedString(@"PrepareBackup_Start", nil),[IMBHelper cutOffString:@"iMobie'iPhone"]] withSubTitle:nil withIsBackuping:NO withMode:1];
    
//    [self setUserNotificationCenter:[NSString stringWithFormat:CustomLocalizedString(@"WifiDeviceConnected_Tips", nil),[IMBHelper cutOffString:@"iMobie'iPhone"]] withSubTitle:nil withIsBackuping:NO withMode:1];
    
//    [self setUserNotificationCenter:[NSString stringWithFormat:CustomLocalizedString(@"BatteryNotification_Low", nil),100] withSubTitle:nil withIsBackuping:NO withMode:1];
    
//    [self setUserNotificationCenter:[NSString stringWithFormat:CustomLocalizedString(@"BatteryHighNotification", nil),[IMBHelper cutOffString:@"iMobie'iPhone"], 100] withSubTitle:nil withIsBackuping:NO withMode:1];
    
//    [self setUserNotificationCenter:[NSString stringWithFormat:CustomLocalizedString(@"AirBackup_DeviceStoped", nil),[IMBHelper cutOffString:@"iMobie'iPhone"]] withSubTitle:nil withIsBackuping:NO withMode:1];

    [_logHandle writeInfoLog:@"AirBackupHelper Start!"];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [_logHandle writeInfoLog:@"backup server exit normally!!!"];
    [nc removeObserver:self name:DeviceConnectedNotification object:nil];
    [nc removeObserver:self name:DeviceDisConnectedNotification object:nil];
    [nc removeObserver:self name:DeviceNeedPasswordNotification object:nil];
    [nc removeObserver:self name:DeviceIpodLoadCompleteNotification object:nil];
    [nc removeObserver:self name:NOTIFY_BACKUP_RECORD object:nil];
}

- (void)checkLanguage {
    NSArray *defineLang = @[@"en", @"ja", @"de", @"fr", @"es",@"ar",@"zh"];
    NSArray *checkLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSMutableArray *chooseLang = [[NSMutableArray alloc] init];
    NSString *_langStr = @"";
    for (NSString *langStr in checkLang) {
        if (![defineLang containsObject:langStr]) {
            continue;
        }
        _langStr = langStr;
        break;
    }
    NSString *langPath = [[NSBundle mainBundle] pathForResource:_langStr ofType:@".lproj"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:langPath]) {
        _langStr = @"en";
    }
    if (_langStr == nil) {
        _langStr = @"en";
    }
    [chooseLang addObject:_langStr];
    [[NSUserDefaults standardUserDefaults] setObject:chooseLang forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
#if !__has_feature(objc_arc)
    if (chooseLang) [chooseLang release]; chooseLang = nil;
#endif
}

- (void)awakeFromNib {
    [self.window setOpaque:NO];
    [self.window setBackgroundColor:[NSColor clearColor]];
    [self.window setStyleMask:NSBorderlessWindowMask];
    [self.window setAutodisplay:YES];
    
    //监听socket消息
    [self listenSocketMessage];
//    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (void)deviceConnected:(NSNotification *)notification {
    [self checkLanguage];
    NSLog(@"deviceConnected");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSFileManager *fm = [NSFileManager defaultManager];
        NSNumber *lastBackupTime = @0;
        AMDevice *device = notification.object;
        NSString *deviceKey = device.serialNumber;
        NSString *path = [[[IMBHelper getAppConfigPath] stringByAppendingPathComponent:@"backupRecord.plist"] retain];
        if ([fm fileExistsAtPath:path]) {
            NSDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
            if (dic != nil) {
                if ([dic.allKeys containsObject:deviceKey]) {
                    NSArray *array = [dic objectForKey:deviceKey];
                    NSDictionary *lastDic = [array lastObject];
                    if ([lastDic.allKeys containsObject:@"BackupTime"]) {
                        lastBackupTime = [lastDic objectForKey:@"BackupTime"];
                    }
                }
            }
        }
        
        int backupDay = 3;
        NSString *configPath = [[[IMBHelper getAppConfigPath] stringByAppendingPathComponent:@"airBackupConfig.plist"] retain];
        if ([fm fileExistsAtPath:configPath]) {
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:configPath];
            if (dic != nil) {
                if ([dic.allKeys containsObject:deviceKey]) {
                    NSDictionary *spiDic = [dic objectForKey:deviceKey];
                    if (spiDic != nil) {
                        if ([spiDic.allKeys containsObject:@"BackupDay"]) {
                            backupDay = [[spiDic objectForKey:@"BackupDay"] intValue];
                        }
                    }
                }
            }
        }
        
        BOOL ret = [IMBHelper timeLitme:[lastBackupTime longLongValue] backupDay:backupDay];
        if (ret && [IMBHelper stringIsNilOrEmpty:device.deviceName]) {
            [self setUserNotificationCenter:[NSString stringWithFormat:CustomLocalizedString(@"WifiDeviceConnected_Tips", nil),[IMBHelper cutOffString:device.deviceName]] withSubTitle:nil withIsBackuping:NO withMode:1];
        }
        if (configPath != nil) {
            [configPath release];
            configPath = nil;
        }
        if (path != nil) {
            [path release];
            path = nil;
        }
    });
}

- (void)deviceDisconnected:(NSNotification *)notification {
    NSLog(@"deviceDisconnected");
    NSString *uniqueKey = notification.object;
    if (_ipod && [uniqueKey isEqualToString:_ipod.deviceInfo.serialNumber]) {
        if (_backupDandle && _isBackuping) {
            if (!_backupDandle.backupFinished) {
                _isStop = YES;
                _isBackuping = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setUserNotificationCenter:[NSString stringWithFormat:CustomLocalizedString(@"Backup_Error", nil),[IMBHelper cutOffString:_ipod.deviceInfo.deviceName], -101] withSubTitle:nil withIsBackuping:NO withMode:6];
                });
            }
            [_backupDandle stopBackupRestore];
        }
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:uniqueKey, @"SerialNumber", @"DeviceDisconnect", @"CurrentStatus", nil];
    [self sendMessagetoAnytrans:dic];
}

- (void)devicePwdProtected:(NSNotification *)notification {
    NSLog(@"devicePwdProtected");
}

- (void)deviceiPodLoadComplete:(NSNotification *)notification {
    NSLog(@"deviceiPodLoadComplete");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *deviceInfo = [notification userInfo];
        IMBBaseInfo *baseInfo = [deviceInfo objectForKey:@"DeviceInfo"];
        IMBiPod *curiPod = [_deviceConnection getIPodByKey:[baseInfo uniqueKey]];
        
        NSDictionary *dic= [NSDictionary dictionaryWithObjectsAndKeys:curiPod.deviceInfo.deviceName, @"DeviceName", curiPod.deviceInfo.serialNumber, @"SerialNumber", curiPod.deviceInfo.productType, @"DeviceType", @"DeviceConnect", @"CurrentStatus",[NSNumber numberWithLongLong:curiPod.deviceInfo.totalDiskCapacity], @"DeviceTotalCapacity", [NSNumber numberWithLongLong:curiPod.deviceInfo.totalDataAvailable], @"DeviceAvailableCapacity", [NSNumber numberWithInt:curiPod.deviceInfo.currentCapacity], @"BatteryCapacity", nil];
        [self sendMessagetoAnytrans:dic];
        
        //检查备份设备
        BOOL ret = [self checkBackupDevice:curiPod withIsTime:YES];
        if (!ret && !_isBackuping) {
            NSArray *ipodArr = [_deviceConnection getOtherConnectedIPod:_ipod.uniqueKey];
            if (ipodArr) {
                for (IMBiPod *ipod in ipodArr) {
                    ret = [self checkBackupDevice:ipod withIsTime:YES];
                    if (ret) {
                        break;
                    }
                }
            }
        }
    });
}

- (BOOL)checkBackupDevice:(IMBiPod *)checkiPod withIsTime:(BOOL)isTime {
    //检查其他设备需要备份
    BOOL ret = NO;
    if (!_isBackuping && checkiPod) {
        _isBackuping = YES;
        if (_ipod) {
            [_ipod release];
            _ipod = nil;
        }
        _ipod = [checkiPod retain];
        BOOL isUSB = NO;
        if ([IMBHelper appIsRunningWithBundleIdentifier:@"com.imobie.AnyTrans"]) {
            for (NSString *serinalNumber in _deviceConnection.conArray) {
                if ([serinalNumber isEqualToString:_ipod.uniqueKey]) {
                    isUSB = YES;
                    [_logHandle writeInfoLog:[NSString stringWithFormat:@"deviceConnection.conArray serinalNumber:%@",serinalNumber]];
                    break;
                }
            }
        }
        if (!isUSB) {
            //检查设备该设备是否满足备份条件
            if ([self judgingIsCanBackup:isTime]) {
                ret = YES;
                [self performSelector:@selector(startBackup) withObject:nil afterDelay:0.5];
            }else {
                _isBackuping = NO;
                ret = NO;
            }
        }
    }
    return ret;
}

- (BOOL)judgingIsCanBackup:(BOOL)isTime {
    BOOL ret = NO;
    //电量提醒
    int currentCapacity = _ipod.deviceInfo.currentCapacity;
    if (currentCapacity == 0) {
        ret = YES;
    }else {
        if (currentCapacity < _ipod.backupConfig.lowElectricityTip) {//低电量提醒
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"lowElectricityTip serinalNumber:%@",_ipod.uniqueKey]];
            [self setUserNotificationCenter:[NSString stringWithFormat:CustomLocalizedString(@"BatteryNotification_Low", nil),currentCapacity] withSubTitle:nil withIsBackuping:NO withMode:1];
        }
        if (currentCapacity > _ipod.backupConfig.electricityReminder) {
            ret = YES;
        }else {
            //电量不足,无法备份提醒;
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"electricityReminder serinalNumber:%@",_ipod.uniqueKey]];
            NSArray *checkLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
            NSString *lanStr = [checkLang objectAtIndex:0];
            if ([lanStr isEqualToString:@"ar"] || [lanStr isEqualToString:@"de"] || [lanStr isEqualToString:@"es"] ) {
                [self setUserNotificationCenter:[NSString stringWithFormat:CustomLocalizedString(@"BatteryHighNotification", nil), currentCapacity,[IMBHelper cutOffString:_ipod.deviceInfo.deviceName]] withSubTitle:nil withIsBackuping:NO withMode:1];
            }else {
                [self setUserNotificationCenter:[NSString stringWithFormat:CustomLocalizedString(@"BatteryHighNotification", nil),[IMBHelper cutOffString:_ipod.deviceInfo.deviceName], currentCapacity] withSubTitle:nil withIsBackuping:NO withMode:1];
            }
        }
    }
    
    if (ret) {
        //备份间隔时间判断
        if (isTime) {
            ret = [IMBHelper timeLitme:_ipod.backupConfig.lastBackupTime backupDay:_ipod.backupConfig.backupDay];
        }
        if (ret) {
            //注册与否判断
            ret = [self judgingIsRegistered];
            if (!ret) {
                //备份大小判断
                NSString *savePath = [[IMBHelper getAppConfigPath] stringByAppendingPathComponent:@"backupRecord.plist"];
                NSFileManager *fm = [NSFileManager defaultManager];
                if ([fm fileExistsAtPath:savePath]) {
                    NSMutableDictionary *saveDic = [NSMutableDictionary dictionaryWithContentsOfFile:savePath];
                    long long totalBackupSize = [[saveDic objectForKey:@"TotalBackupSize"] longLongValue];
                    if (totalBackupSize < 8600000000) {
                        ret = YES;
                    }else {
                        //超过备份大小限制
                        //这里处理为一天只弹一次骚然界面 修改时间2017.12.20
                        
                        NSString *lastStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastDate"];
                        if (lastStr) {
                            NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
                            [dateFormat setDateFormat:@"MM/dd/yyyy"];
                            NSDate *lastDate = [dateFormat dateFromString:lastStr];
                            
                            NSDate *date = [NSDate date];
                            NSString *dateStr = [dateFormat stringFromDate:date];
                            NSDate *nowDate =  [dateFormat dateFromString:dateStr];
                            NSTimeInterval sec = [nowDate timeIntervalSinceDate:lastDate];
                            if (sec <= 0) {
                                return ret;
                            }
                        }
                        NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
                        [dateFormat setDateFormat:@"MM/dd/yyyy"];
                        NSDate *date = [NSDate date];
                        NSString *dateStr = [dateFormat stringFromDate:date];
                        [[NSUserDefaults standardUserDefaults] setObject:dateStr forKey:@"lastDate"];
                        

                        [_logHandle writeInfoLog:[NSString stringWithFormat:@"totalBackupSize serinalNumber:%@",_ipod.uniqueKey]];
                        NSString *title = [IMBHelper cutOffString:@"iMobie'iPhone"];
                        NSString *subTitle = CustomLocalizedString(@"Backup_Complete_Limite2", nil);
                        [self setUserNotificationCenter:title withSubTitle:subTitle withIsBackuping:NO withMode:2];

                    }
                }else {
                    ret = YES;
                }
            }
        }else {
            NSLog(@"备份间隔时间未到");
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"backupDay serinalNumber:%@",_ipod.uniqueKey]];
        }
    }
    return ret;
}

//判断是否注册
- (BOOL)judgingIsRegistered {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *regFolderPath = [IMBHelper getAnyTransSupportPath];
    NSString *regFilePath = [regFolderPath stringByAppendingPathComponent:@"IMBSoftware-Info.plist"];
    BOOL isReg = NO;
    if ([fm fileExistsAtPath:regFilePath]) {
        NSDictionary *regDic = [NSDictionary dictionaryWithContentsOfFile:regFilePath];
        if (regDic != nil && [[regDic allKeys] count] > 0) {
            NSArray *allKey = [regDic allKeys];
            if ([allKey containsObject:@"IsRegistered"]) {
                isReg = [[regDic objectForKey:@"IsRegistered"] boolValue];
            }
            if (isReg) {
                NSString *licnese = nil;
                if ([allKey containsObject:@"RegisteredCode"]) {
                    licnese = [regDic objectForKey:@"RegisteredCode"];
                    KeyStateStruct *ks = [IMBHelper verifyProductLicense:licnese];
                    isReg = ks->valid;
                }
            }
        }
    }
    return isReg;
}

- (void)startBackup {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_ipod) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"startBackup serinalNumber:%@",_ipod.uniqueKey]];
            [self addAllObserver];
            _isBackupPhotoMedia = _ipod.backupConfig.isBackupPhotoMedia;
            _backupProgress = 0;
            _isStop = NO;
            _isError = NO;
            _isBackupComplete = NO;
            if (_backupDandle) {
                [_backupDandle release];
                _backupDandle = nil;
            }
            _backupDandle = [[IMBBackAndRestore alloc] initWithIPod:_ipod];
            [_backupDandle backUp];
        }
    });
}

- (void)addAllObserver {
    [self removeAllObserver];
    [nc addObserver:self selector:@selector(doBackUpStart:) name:NOTIFY_BACKUP_START object:nil];
    [nc addObserver:self selector:@selector(doBackUpComplete:) name:NOTIFY_BACKUP_COMPLETE object:nil];
    [nc addObserver:self selector:@selector(doBackUpProgress:) name:NOTIFY_BACKUP_PROGRESS object:nil];
    [nc addObserver:self selector:@selector(doBackUpError:) name:NOTIFY_BACKUP_ERROR object:nil];
    [nc addObserver:self selector:@selector(doBackUpRecord:) name:NOTIFY_BACKUP_RECORD object:nil];
}

- (void)removeAllObserver {
    [nc removeObserver:self name:NOTIFY_BACKUP_START object:nil];
    [nc removeObserver:self name:NOTIFY_BACKUP_PROGRESS object:nil];
    [nc removeObserver:self name:NOTIFY_BACKUP_COMPLETE object:nil];
    [nc removeObserver:self name:NOTIFY_BACKUP_ERROR object:nil];
}

#pragma mark -- 备份过程中的通知方法
- (void)doBackUpStart:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        _backupProgress = 0;
        NSDictionary *dic= [NSDictionary dictionaryWithObjectsAndKeys:_ipod.deviceInfo.deviceName, @"DeviceName", _ipod.deviceInfo.serialNumber, @"SerialNumber", _ipod.deviceInfo.productType, @"DeviceType", @"BackupStart", @"CurrentStatus", [NSNumber numberWithInt:_ipod.deviceInfo.currentCapacity], @"BatteryCapacity", nil];
        [self sendMessagetoAnytrans:dic];
        
        if (_notificationController) {
            [_notificationController setIsClosePrompt:NO];
        }
        [self setUserNotificationCenter:[NSString stringWithFormat:CustomLocalizedString(@"PrepareBackup_Start", nil),[IMBHelper cutOffString:_ipod.deviceInfo.deviceName]] withSubTitle:nil withIsBackuping:NO withMode:1];
    });
}

- (void)doBackUpProgress:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [notification userInfo];
        if (dic != nil) {
            double progress = [[dic objectForKey:@"BRProgress"] doubleValue];
            if (progress >=100){
                progress = 100.0;
            }
            if (_isBackupPhotoMedia) {
                progress = progress * 0.9;
            }
            if (progress < _backupProgress) {
                progress = _backupProgress;
            }else {
                _backupProgress = progress;
            }
            
            NSDictionary *dic= [NSDictionary dictionaryWithObjectsAndKeys:_ipod.deviceInfo.deviceName, @"DeviceName", _ipod.deviceInfo.serialNumber, @"SerialNumber", _ipod.deviceInfo.productType, @"DeviceType", @"Backuping", @"CurrentStatus", [NSNumber numberWithDouble:progress], @"BackupProgress", nil];
            [self sendMessagetoAnytrans:dic];
            
            NSString *title = [NSString stringWithFormat:CustomLocalizedString(@"Backup_Start", nil),[IMBHelper cutOffString:_ipod.deviceInfo.deviceName], (int)progress];
            [self setUserNotificationCenter:title withSubTitle:nil withIsBackuping:YES withMode:3];
        }
    });
}

- (void)doBackUpRecord:(NSNotification *)notification {
    if (_ipod && !_isError) {
        if (_deviceName) {
            [_deviceName release];
            _deviceName = nil;
        }
        _deviceName = [_ipod.deviceInfo.deviceName retain];
        if (_uniqueKey) {
            [_uniqueKey release];
            _uniqueKey = nil;
        }
        _uniqueKey = [_ipod.deviceInfo.serialNumber retain];
        if (_deviceType) {
            [_deviceType release];
            _deviceType = nil;
        }
        _deviceType = [_ipod.deviceInfo.productType retain];
        long long time = [[NSDate date] timeIntervalSince1970];
        NSString *backupPath = [_backupDandle.deviceBackupPath retain];
        BOOL isIncremental = _backupDandle.isIncremental;
        BOOL isEncryptBackup = _backupDandle.isEncryptBackup;
        _ipod.backupConfig.lastBackupTime = time;
        _backupDandle.backupTime = time;
        NSDictionary *dic = nil;
        if (!_isStop) {
            [_ipod.backupConfig save];
            NSDictionary *dic= [NSDictionary dictionaryWithObjectsAndKeys:_deviceName, @"DeviceName", _uniqueKey, @"SerialNumber", _deviceType, @"DeviceType", @"BackupRecord", @"CurrentStatus", [NSNumber numberWithDouble:_backupProgress], @"BackupProgress", [NSNumber numberWithInt:_ipod.deviceInfo.currentCapacity], @"BatteryCapacity", nil];
            [self sendMessagetoAnytrans:dic];
        }
        
        //backup完成了之后，拷贝Midea和photo到备份中；
        if (_isBackupPhotoMedia) {
            [self copyMediaAndPhotoToBackupPath:_backupDandle.deviceBackupPath];
        }
        
        //保存备份结果
        [self saveBackupReslut:_deviceName serialNumber:_uniqueKey deviceType:_deviceType backupTime:time backupPath:backupPath isIncremental:isIncremental isEncryptBackup:isEncryptBackup];
        [backupPath release];
        
        if (!_isStop) {
            double progress = 100;
            _backupProgress = progress;
            dic= [NSDictionary dictionaryWithObjectsAndKeys:_deviceName, @"DeviceName", _uniqueKey, @"SerialNumber", _deviceType, @"DeviceType", @"Backuping", @"CurrentStatus", [NSNumber numberWithDouble:progress], @"BackupProgress", nil];
            [self sendMessagetoAnytrans:dic];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *title = [NSString stringWithFormat:CustomLocalizedString(@"Backup_Start", nil),[IMBHelper cutOffString:_deviceName], (int)progress];
                [self setUserNotificationCenter:title withSubTitle:nil withIsBackuping:YES withMode:3];
            });
        }
    }
}

- (void)doBackUpComplete:(NSNotification *)notification {
    sleep(0.2);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_isError && !_isBackupComplete && !_isStop) {
            _isBackupComplete = YES;
            NSString *title = nil;
            NSString *subTitle = nil;
            int mode = 4;
            if ([self judgingIsRegistered] || [IMBHelper appIsRunningWithBundleIdentifier:@"com.imobie.AnyTrans"]) {
                mode = 4;
                title = [NSString stringWithFormat:CustomLocalizedString(@"Backup_Complete", nil),[IMBHelper cutOffString:_deviceName]];
            }else {
                mode = 5;
                title = [NSString stringWithFormat:CustomLocalizedString(@"Backup_Complete", nil),[IMBHelper cutOffString:_deviceName]];
                NSString *savePath = [[IMBHelper getAppConfigPath] stringByAppendingPathComponent:@"backupRecord.plist"];
                long long totalBackupSize = 0;
                NSFileManager *fm = [NSFileManager defaultManager];
                if ([fm fileExistsAtPath:savePath]) {
                    NSDictionary *saveDic = [NSMutableDictionary dictionaryWithContentsOfFile:savePath];
                    if ([saveDic.allKeys containsObject:@"TotalBackupSize"]) {
                        totalBackupSize = [[saveDic objectForKey:@"TotalBackupSize"] longLongValue];
                    }
                }
                long long size = 8600000000 - totalBackupSize;
                NSString *sizeStr = @"";
                if (size <= 0) {
                    sizeStr = [NSString stringWithFormat:@"0 %@", CustomLocalizedString(@"MSG_Size_GB", nil)];
                }else {
                    sizeStr = [IMBHelper getFileSizeString:size reserved:1];
                }
                subTitle = [NSString stringWithFormat:CustomLocalizedString(@"Backup_Complete_Limite1", nil),sizeStr];
            }
            [self setUserNotificationCenter:title withSubTitle:subTitle withIsBackuping:NO withMode:mode];
            
            NSDictionary *dic= [NSDictionary dictionaryWithObjectsAndKeys:_deviceName, @"DeviceName", _uniqueKey, @"SerialNumber", _deviceType, @"DeviceType", @"BackupComplete", @"CurrentStatus", nil];
            [self sendMessagetoAnytrans:dic];
            _isBackuping = NO;
        }
        [self removeAllObserver];
        //备份下一个设备
        if (!_isBackuping) {
            NSArray *ipodArr = [_deviceConnection getOtherConnectedIPod:_ipod.uniqueKey];
            if (ipodArr) {
                for (IMBiPod *ipod in ipodArr) {
                    BOOL ret = [self checkBackupDevice:ipod withIsTime:YES];
                    if (ret) {
                        break;
                    }
                }
            }
        }
    });
}

- (void)saveBackupReslut:(NSString *)deviceName serialNumber:(NSString *)serialNumber deviceType:(NSString *)deviceType backupTime:(long long)backupTime backupPath:(NSString *)backupPath isIncremental:(BOOL)isIncremental isEncryptBackup:(BOOL)isEncryptBackup {
    NSString *savePath = [[IMBHelper getAppConfigPath] stringByAppendingPathComponent:@"backupRecord.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableDictionary *saveDic = nil;
    NSMutableArray *saveArr = nil;
    long long totalBackupSize = 0;
    if ([fm fileExistsAtPath:savePath]) {
        saveDic = [NSMutableDictionary dictionaryWithContentsOfFile:savePath];
        if ([saveDic.allKeys containsObject:serialNumber]) {
            saveArr = [saveDic objectForKey:serialNumber];
        }else {
            saveArr = [NSMutableArray array];
        }
        if ([saveDic.allKeys containsObject:@"TotalBackupSize"]) {
            totalBackupSize = [[saveDic objectForKey:@"TotalBackupSize"] longLongValue];
        }
//        if (isIncremental) {
            for (NSDictionary *dic in saveArr) {
                if ([dic.allKeys containsObject:@"BackupPath"]) {
                    NSString *path = [dic objectForKey:@"BackupPath"];
                    if ([path isEqualToString:backupPath]) {
                        if ([dic.allKeys containsObject:@"BackupSize"]) {
                            long long size = [[dic objectForKey:@"BackupSize"] longLongValue];
                            totalBackupSize -= size;
                        }
                        [saveArr removeObject:dic];
                        break;
                    }
                }
            }
//        }
    }else {
        saveDic = [NSMutableDictionary dictionary];
        saveArr = [NSMutableArray array];
    }
    NSMutableDictionary *singleDic = [NSMutableDictionary dictionary];
    [singleDic setObject:deviceName forKey:@"DeviceName"];
    [singleDic setObject:serialNumber forKey:@"SerialNumber"];
    [singleDic setObject:deviceType forKey:@"DeviceType"];
    [singleDic setObject:[NSNumber numberWithLongLong:backupTime] forKey:@"BackupTime"];
    int64_t backupSize = [IMBHelper getFolderSize:backupPath];
    [singleDic setObject:[NSNumber numberWithLongLong:backupSize] forKey:@"BackupSize"];
    [singleDic setObject:backupPath forKey:@"BackupPath"];
    [singleDic setObject:[NSNumber numberWithBool:isEncryptBackup] forKey:@"EncryptBackup"];
    [saveArr addObject:singleDic];
    [saveDic setObject:[NSNumber numberWithLongLong:totalBackupSize + backupSize] forKey:@"TotalBackupSize"];
    [saveDic setObject:saveArr forKey:serialNumber];
    [saveDic writeToFile:savePath atomically:YES];
}

- (void)copyMediaAndPhotoToBackupPath:(NSString *)path {
    if (_ipod && !_isStop) {
        double progress = 91;
        _backupProgress = progress;
        NSDictionary *dic= [NSDictionary dictionaryWithObjectsAndKeys:_deviceName, @"DeviceName", _uniqueKey, @"SerialNumber", _deviceType, @"DeviceType", @"Backuping", @"CurrentStatus", [NSNumber numberWithDouble:progress], @"BackupProgress", nil];
        [self sendMessagetoAnytrans:dic];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = [NSString stringWithFormat:CustomLocalizedString(@"Backup_Start", nil),[IMBHelper cutOffString:_deviceName], (int)progress];
            [self setUserNotificationCenter:title withSubTitle:nil withIsBackuping:YES withMode:3];
        });
            
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *copyPath = [path stringByAppendingPathComponent:@"Archive"];
        if (![fm fileExistsAtPath:copyPath]) {
            [fm createDirectoryAtPath:copyPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        // /PhotoData/Photos.sqlite   /PhotoData/Photos.sqlite-shm   /PhotoData/Photos.sqlite-wal  /PhotoData/Sync--文件夹
        // /iTunes_Control/iTunes/MediaLibrary.sqlitedb  /iTunes_Control/iTunes/MediaLibrary.sqlitedb-shm  /iTunes_Control/iTunes/MediaLibrary.sqlitedb-wal   /iTunes_Control/Music--文件夹
        NSString *copyPhotoPath = [copyPath stringByAppendingPathComponent:@"Photo"];
        if (![fm fileExistsAtPath:copyPhotoPath]) {
            [fm createDirectoryAtPath:copyPhotoPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *photoPath = [copyPhotoPath stringByAppendingPathComponent:@"Photos.sqlite"];
        if ([fm fileExistsAtPath:photoPath]) {
            [fm removeItemAtPath:photoPath error:nil];
        }
        [_ipod.fileSystem copyRemoteFile:@"PhotoData/Photos.sqlite" toLocalFile:photoPath];
        NSString *photoshmPath = [copyPhotoPath stringByAppendingPathComponent:@"Photos.sqlite-shm"];
        if ([fm fileExistsAtPath:photoshmPath]) {
            [fm removeItemAtPath:photoshmPath error:nil];
        }
        [_ipod.fileSystem copyRemoteFile:@"PhotoData/Photos.sqlite-shm" toLocalFile:photoshmPath];
        NSString *photowalPath = [copyPhotoPath stringByAppendingPathComponent:@"Photos.sqlite-wal"];
        if ([fm fileExistsAtPath:photowalPath]) {
            [fm removeItemAtPath:photowalPath error:nil];
        }
        [_ipod.fileSystem copyRemoteFile:@"PhotoData/Photos.sqlite-wal" toLocalFile:photowalPath];
        
        if (!_isStop) {
            progress = 92;
            _backupProgress = progress;
            dic= [NSDictionary dictionaryWithObjectsAndKeys:_deviceName, @"DeviceName", _uniqueKey, @"SerialNumber", _deviceType, @"DeviceType", @"Backuping", @"CurrentStatus", [NSNumber numberWithDouble:progress], @"BackupProgress", nil];
            [self sendMessagetoAnytrans:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *title = [NSString stringWithFormat:CustomLocalizedString(@"Backup_Start", nil),[IMBHelper cutOffString:_deviceName], (int)progress];
                [self setUserNotificationCenter:title withSubTitle:nil withIsBackuping:YES withMode:3];
            });
        }
        
        NSString *copySyncPath = [copyPhotoPath stringByAppendingPathComponent:@"PhotoData"];
        if (![fm fileExistsAtPath:copySyncPath]) {
            [fm createDirectoryAtPath:copySyncPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        copySyncPath = [copySyncPath stringByAppendingPathComponent:@"Sync"];
        if (![fm fileExistsAtPath:copySyncPath]) {
            [fm createDirectoryAtPath:copySyncPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [self recursionCopyWithCurrFolderPath:copySyncPath folderPath:@"PhotoData/Sync"];
        
         if (!_isStop) {
            progress = 95;
            _backupProgress = progress;
            dic= [NSDictionary dictionaryWithObjectsAndKeys:_deviceName, @"DeviceName", _uniqueKey, @"SerialNumber", _deviceType, @"DeviceType", @"Backuping", @"CurrentStatus", [NSNumber numberWithDouble:progress], @"BackupProgress", nil];
            [self sendMessagetoAnytrans:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *title = [NSString stringWithFormat:CustomLocalizedString(@"Backup_Start", nil),[IMBHelper cutOffString:_deviceName], (int)progress];
                [self setUserNotificationCenter:title withSubTitle:nil withIsBackuping:YES withMode:3];
            });
        }
            
        NSString *copyMeidaPath = [copyPath stringByAppendingPathComponent:@"Media"];
        if (![fm fileExistsAtPath:copyMeidaPath]) {
            [fm createDirectoryAtPath:copyMeidaPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *msqlPath = [copyMeidaPath stringByAppendingPathComponent:@"MediaLibrary.sqlitedb"];
        if ([fm fileExistsAtPath:msqlPath]) {
            [fm removeItemAtPath:msqlPath error:nil];
        }
        [_ipod.fileSystem copyRemoteFile:@"iTunes_Control/iTunes/MediaLibrary.sqlitedb" toLocalFile:msqlPath];
        NSString *msqlshmPath = [copyMeidaPath stringByAppendingPathComponent:@"MediaLibrary.sqlitedb-shm"];
        if ([fm fileExistsAtPath:msqlshmPath]) {
            [fm removeItemAtPath:msqlshmPath error:nil];
        }
        [_ipod.fileSystem copyRemoteFile:@"iTunes_Control/iTunes/MediaLibrary.sqlitedb-shm" toLocalFile:msqlshmPath];
        NSString *msqlwalPath = [copyMeidaPath stringByAppendingPathComponent:@"MediaLibrary.sqlitedb-wal"];
        if ([fm fileExistsAtPath:msqlwalPath]) {
            [fm removeItemAtPath:msqlwalPath error:nil];
        }
        [_ipod.fileSystem copyRemoteFile:@"iTunes_Control/iTunes/MediaLibrary.sqlitedb-wal" toLocalFile:msqlwalPath];

        if (!_isStop) {
            progress = 96;
            _backupProgress = progress;
            dic= [NSDictionary dictionaryWithObjectsAndKeys:_deviceName, @"DeviceName", _uniqueKey, @"SerialNumber", _deviceType, @"DeviceType", @"Backuping", @"CurrentStatus", [NSNumber numberWithDouble:progress], @"BackupProgress", nil];
            [self sendMessagetoAnytrans:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *title = [NSString stringWithFormat:CustomLocalizedString(@"Backup_Start", nil),[IMBHelper cutOffString:_deviceName], (int)progress];
                [self setUserNotificationCenter:title withSubTitle:nil withIsBackuping:YES withMode:3];
            });
        }
        
        NSString *copyMusicPath = [copyMeidaPath stringByAppendingPathComponent:@"iTunes_Control"];
        if (![fm fileExistsAtPath:copyMusicPath]) {
            [fm createDirectoryAtPath:copyMusicPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        copyMusicPath = [copyMusicPath stringByAppendingPathComponent:@"Music"];
        if (![fm fileExistsAtPath:copyMusicPath]) {
            [fm createDirectoryAtPath:copyMusicPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [self recursionCopyWithCurrFolderPath:copyMusicPath folderPath:@"iTunes_Control/Music"];
    
        if (!_isStop) {
            progress = 99;
            _backupProgress = progress;
            dic= [NSDictionary dictionaryWithObjectsAndKeys:_deviceName, @"DeviceName", _uniqueKey, @"SerialNumber", _deviceType, @"DeviceType", @"Backuping", @"CurrentStatus", [NSNumber numberWithDouble:progress], @"BackupProgress", nil];
            [self sendMessagetoAnytrans:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                 NSString *title = [NSString stringWithFormat:CustomLocalizedString(@"Backup_Start", nil),[IMBHelper cutOffString:_deviceName], (int)progress];
                [self setUserNotificationCenter:title withSubTitle:nil withIsBackuping:YES withMode:3];
            });
        }
    }
}

- (void)recursionCopyWithCurrFolderPath:(NSString *)currFolderPath folderPath:(NSString *)folderPath {
    if (!_isStop) {
        NSString *tempPath = nil;
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *fileArray = [_ipod.fileSystem getItemInDirectory:folderPath];
        if (fileArray != nil && fileArray.count > 0) {
            for (AMFileEntity *item in fileArray) {
                if (_isStop) {
                    break;
                }
                if (item.FileType == AMDirectory) {
                    if ([[item.FilePath stringByStandardizingPath] isEqualToString:[folderPath stringByStandardizingPath]]) {
                        continue;
                    }
                    tempPath = [currFolderPath stringByAppendingPathComponent:item.Name];
                    if (![fm fileExistsAtPath:tempPath]) {
                        [fm createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    [self recursionCopyWithCurrFolderPath:tempPath folderPath:item.FilePath];
                } else {
                    tempPath = [currFolderPath stringByAppendingPathComponent:item.Name];
                    if (![fm fileExistsAtPath:tempPath]) {
                        [_ipod.fileSystem copyRemoteFile:item.FilePath toLocalFile:tempPath];
                    }
                }
            }
        }
    }
}

- (void)doBackUpError:(NSNotification *)notification {
//    [self performSelectorOnMainThread:@selector(backupError:) withObject:notification waitUntilDone:YES];
    [self backupError:notification];
}

-(void)backupError:(id)sender {
    _isError = YES;
    NSDictionary *userInfo = [sender userInfo];
    if (userInfo != nil) {
        NSNumber *errorid = nil;
        if ([userInfo.allKeys containsObject:NOTIFY_ERROR_CODE]) {
            errorid = [userInfo objectForKey:NOTIFY_ERROR_CODE];
        }
        NSString *errorStr = nil;
        if ([userInfo.allKeys containsObject:NOTIFY_ERROR_REASON]) {
            errorStr = [userInfo objectForKey:NOTIFY_ERROR_REASON];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errorid) {
                [self setUserNotificationCenter:[NSString stringWithFormat:CustomLocalizedString(@"Backup_Error", nil),[IMBHelper cutOffString:_ipod.deviceInfo.deviceName],errorid.intValue] withSubTitle:nil withIsBackuping:NO withMode:6];
            }else {
                [self setUserNotificationCenter:[NSString stringWithFormat:CustomLocalizedString(@"Backup_Error", nil),[IMBHelper cutOffString:_ipod.deviceInfo.deviceName],@0] withSubTitle:nil withIsBackuping:NO withMode:6];
            }
        });
        NSDictionary *dic= [NSDictionary dictionaryWithObjectsAndKeys:_ipod.deviceInfo.deviceName ? _ipod.deviceInfo.deviceName : @"", @"DeviceName", _ipod.deviceInfo.serialNumber ? _ipod.deviceInfo.serialNumber : @"", @"SerialNumber", _ipod.deviceInfo.productType ? _ipod.deviceInfo.productType : @"", @"DeviceType", @"BackupError", @"CurrentStatus", errorid ? errorid : @"", "ErrorId", nil];
        [self sendMessagetoAnytrans:dic];
        
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"errorid:%d   errorReason:%@",errorid.intValue,errorStr]];
    }
    _isBackuping = NO;
}

- (void)listenSocketMessage {
    //监听socket消息
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int i = 3;
        IMBSocketServer *socketServer = [IMBSocketServer singleton];
        while (i--) {
            if ([socketServer listenServer]) {
                [socketServer setIsListen:YES];
                [socketServer acceptConnect:self];
                break;
            }
            [socketServer setPort:6888];
        }
    });
}

- (void)sendMessagetoAnytrans:(NSDictionary *)dic {
    NSString *str = [IMBHelper dictionaryToJson:dic];
    //发送json对象
    [[IMBSocketServer singleton] sendDataToClient:str];
}

- (void)setUserNotificationCenter:(NSString *)title withSubTitle:(NSString *)subTitle withIsBackuping:(BOOL)isBackuping withMode:(int)mode {
    //mode = 1--->电量提醒; 2--->备份大小限制提醒; 3--->备份进度提醒; 4--->备份完成（注册或者未注册打开anytrans）提醒; 5--->备份完成（未注册没有打开anytrans）提醒; 6--->备份错误提醒
    if (!_notificationController) {
        _notificationController = [[IMBNotificationWindowController alloc] initWithRect:_mainRect];
    }
    
    [_notificationController setCureentMode:mode];
    
    if (isBackuping) {
        if (_notificationController.isClosePrompt) {
            return;
        }else {
            if (_notificationController.isShow) {
                [_notificationController loadWindowWord:title withPrompt:subTitle withMode:mode];
                return;
            }
        }
    }
    if (_notificationController.isShow) {//如果通知窗口显示的，就先关闭，在显示；
        [_notificationController close:nil];
    }
    [_notificationController showWindow:self];
    [_notificationController loadWindowWord:title withPrompt:subTitle withMode:mode];
    
    __block NSRect newRect;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 0.2;
            NSRect notifiRect = _notificationController.window.frame;
            newRect = NSMakeRect(_mainRect.size.width - notifiRect.size.width - 10, _mainRect.size.height - notifiRect.size.height - 30, notifiRect.size.width, notifiRect.size.height);
            [[_notificationController.window animator] setFrame:newRect display:YES];
            _notificationController.isShow = YES;
        } completionHandler:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_notificationController.isShow && !isBackuping) {
                    [_notificationController close:nil];
                }
            });
        }];
    });
}

#pragma mark - Socket Message Mode
- (void)backupDeviceNow:(NSString *)serialNumber {
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"backupDeviceNow:%@",serialNumber]];
    dispatch_async(dispatch_get_main_queue(), ^{
        IMBiPod *curiPod = [_deviceConnection getIPodByKey:serialNumber];
        [self checkBackupDevice:curiPod withIsTime:NO];
    });
}

- (void)USBDeviceConnect:(NSString *)serialNumber {
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"USBDeviceConnect:%@",serialNumber]];
    if (![_deviceConnection.conArray containsObject:serialNumber]) {
        [_deviceConnection.conArray addObject:serialNumber];
    }
    if (_ipod && [_ipod.uniqueKey isEqualToString:serialNumber]) {
        _isStop = YES;
        _isBackuping = NO;
        if (_backupDandle) {
            [_backupDandle stopBackupRestore];
        }
    }
}

- (void)USBDeviceDisconnect:(NSString *)serialNumber {
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"USBDeviceDisconnect:%@",serialNumber]];
    if ([_deviceConnection.conArray containsObject:serialNumber]) {
        [_deviceConnection.conArray removeObject:serialNumber];
    }
}

- (void)stopCurBackup:(NSString *)serialNumber {
    if (_ipod && [_ipod.uniqueKey isEqualToString:serialNumber]) {
        [_logHandle writeInfoLog:@"stop Backup"];
        _isStop = YES;
        _isBackuping = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setUserNotificationCenter:[NSString stringWithFormat:CustomLocalizedString(@"AirBackup_DeviceStoped", nil),[IMBHelper cutOffString:_ipod.deviceInfo.deviceName]] withSubTitle:nil withIsBackuping:NO withMode:1];
        });
        if (_backupDandle) {
            [_backupDandle stopBackupRestore];
        }
    }
}

@end
