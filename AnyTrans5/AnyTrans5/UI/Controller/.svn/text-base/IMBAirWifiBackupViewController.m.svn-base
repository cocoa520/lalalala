//
//  IMBAirWifiBackupViewController.m
//  AnyTrans
//
//  Created by smz on 17/10/18.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBAirWifiBackupViewController.h"
#import "IMBNotificationDefine.h"
#import "IMBiPodMenuItem.h"
#import "IMBHelper.h"
#import "IMBAlertViewController.h"
#import "IMBAirBackupPopoverViewController.h"
#import "SystemHelper.h"
#import "IMBAirBackupTextFieldCell.h"
#import "IMBSocketClient.h"
#import "IMBAnimation.h"
#import "IMBSoftWareInfo.h"
#import "IMBMainWindowController.h"

#define HEIGHT 18
@implementation IMBAirWifiBackupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_airBackupAnimationView setDelegate:self];
    _lastProgress = 0.0;
    [self loadBackupBackupRecord];
    [self configTextAndImageAndButton];
    [self setBackupGuideAlertView];
    [self addObserver];
    [self configAnnoyView];
    [_mainBox setContentView:_airBackupView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
}

#pragma mark - 加载backupRecord里面的设备
- (void)loadBackupBackupRecord {
    NSString *path = [[IMBHelper getBackupServerSupportConfigPath] stringByAppendingPathComponent:@"backupRecord.plist"];
    NSFileManager *_fm = [NSFileManager defaultManager];
    if ([_fm fileExistsAtPath:path]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
        if (dic != nil) {
            for (NSString *str in dic.allKeys) {
                id ary = [dic objectForKey:str];
                if ([ary isKindOfClass:[NSArray class]]) {
                    NSArray *records = (NSArray *)ary;
                    IMBBaseInfo *baseInfo = [[IMBBaseInfo alloc] init];
                    for (int i = (int)records.count - 1; i < records.count; i --) {
                        NSDictionary *dic = [records objectAtIndex:i];
                        if ([dic isKindOfClass:[NSDictionary class]]) {
                            if (i == (int)records.count - 1) {
                                baseInfo.backupSize = [dic objectForKey:@"BackupSize"];
                                baseInfo.backupTime = [dic objectForKey:@"BackupTime"];
                                baseInfo.deviceName = [dic objectForKey:@"DeviceName"];
                                baseInfo.uniqueKey = [dic objectForKey:@"SerialNumber"];
                                baseInfo.connectType = [IMBHelper family:[dic objectForKey:@"DeviceType"]];
                            }
                            IMBBackupRecord *record = [[IMBBackupRecord alloc] init];
                            record.name = [dic objectForKey:@"DeviceName"];
                            record.path = [dic objectForKey:@"BackupPath"];
                            record.size = [dic objectForKey:@"BackupSize"];
                            record.time = [dic objectForKey:@"BackupTime"];
                            record.encryptBackup = [[dic objectForKey:@"EncryptBackup"] boolValue];
                            record.connectType = baseInfo.connectType;
                            [baseInfo.backupRecordAryM addObject:record];
                            [record release], record = nil;
                        }
                    }
                    BOOL flag = NO;
                    for (IMBBaseInfo *itemInfo in [IMBDeviceConnection singleton].wifiDeviceArray) {
                        if ([baseInfo.uniqueKey isEqualToString:itemInfo.uniqueKey]) {
                            itemInfo.backupSize = baseInfo.backupSize;
                            itemInfo.backupTime = baseInfo.backupTime;
                            itemInfo.connectType = baseInfo.connectType;
                            itemInfo.deviceConnectMode = WifiTwoModeDevice;
                            [itemInfo.backupRecordAryM removeAllObjects];
                            [itemInfo.backupRecordAryM addObjectsFromArray:baseInfo.backupRecordAryM];
                            flag = YES;
                            break;
                        }
                    }
                    if (!flag) {
                        [[IMBDeviceConnection singleton].wifiDeviceArray addObject:baseInfo];
                    }
                     [baseInfo release], baseInfo = nil;
                }
            }
        }
    }
    if ([IMBDeviceConnection singleton].wifiDeviceArray.count > 0) {
        [_deviceNamePopBtn setHidden:NO];
        [_noDeviceTitle setHidden:YES];
    }else {
        [_deviceNamePopBtn setHidden:YES];
        [_noDeviceTitle setHidden:NO];
    }
}

#pragma mark - 接收消息
- (void)addObserver {
    _nc = [NSNotificationCenter defaultCenter];
    [_nc addObserver:self selector:@selector(wifiDeviceConnect:) name:NOTIFY_WIFIDEVICE_CONNECT object:nil];
    [_nc addObserver:self selector:@selector(wifiDeviceDisConnect:) name:NOTIFY_WIFIDEVICE_DISCONNECT object:nil];
    [_nc addObserver:self selector:@selector(wifiDeviceStartBackUp:) name:NOTIFY_WIFIDEVICE_STARTBACKUP object:nil];
    [_nc addObserver:self selector:@selector(wifiDeviceBackUpProgress:) name:NOTIFY_WIFIDEVICE_BACKUP_PROGRESS object:nil];
    [_nc addObserver:self selector:@selector(wifiDeviceBackUpComplete:) name:NOTIFY_WIFIDEVICE_BACKUP_COMPLETE object:nil];
    [_nc addObserver:self selector:@selector(wifiDeviceBackUpError:) name:NOTIFY_WIFIDEVICE_BACKUP_ERROR object:nil];
    [_nc addObserver:self selector:@selector(openMoreBackup:) name:NOTITY_OPEN_MOREBACKUP object:nil];
    [_nc addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [_nc addObserver:self selector:@selector(refreshWifiView:) name:NOTIFY_REFRESH_WIFI_VIEW object:nil];
    [_nc addObserver:self selector:@selector(registSuccess) name:NOTIFY_BACK_MAINVIEW object:nil];
    [_nc addObserver:self selector:@selector(registSuccess) name:ANNOY_REGIST_SUCCESS object:nil];
    [_nc addObserver:self selector:@selector(checkRegisterFail) name:NOTIFY_REGISTER_CHECK_FAIL object:nil];
}

#pragma mark - 注册成功
- (void)registSuccess {
    [_dayPopBtn setIsBackupTime:NO];
    if ([_airBackupView.subviews containsObject:_annoyView]) {
        [self closeWindow:nil];
    }
}

#pragma mark - 验证注册失败
- (void)checkRegisterFail {
    [_dayPopBtn setIsBackupTime:YES];
    [_dayPopBtn setDelegete:self];
}

#pragma mark - 设备消息
//wifi设备连接
- (void)wifiDeviceConnect:(NSNotification *)noti {
    NSLog(@"****************wifiDeviceConnect");
    dispatch_async(dispatch_get_main_queue(), ^{
        [_deviceNamePopBtn setHidden:NO];
        [_subTitleTextView setHidden:NO];
        [_noDeviceTitle setHidden:YES];
        [_noDeviceConnectSubTitleView setHidden:YES];
        [_switchButton setEnabled:YES];
        [_dayPopBtn setEnabled:YES];
        NSDictionary *dic = noti.userInfo;
        if ([dic.allKeys containsObject:@"BaseInfo"]) {
            IMBBaseInfo *baseInfo = [dic objectForKey:@"BaseInfo"];
            if ([IMBDeviceConnection singleton].wifiDeviceArray.count == 1) {//之前没有设备连接
                [_backupButton setEnabled:YES];
                BOOL flag = (baseInfo.deviceConnectMode == WifiRecordDevice)? NO : YES;
                [_deviceNamePopBtn configButtonName:baseInfo.deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:26.0 WithOnline:flag];
                [_deviceNamePopBtn setNeedsDisplay:YES];
                _curBaseInfo = baseInfo;
                _curBaseInfo.isSelected = YES;
                [self resetAirBackUpConfig];
            }
        }
        
        NSString *deviceNameStr = _curBaseInfo.deviceName;
        if (deviceNameStr.length >= 15) {
            deviceNameStr = [deviceNameStr substringToIndex:15];
            deviceNameStr = [deviceNameStr stringByAppendingString:@"..."];
        }
        NSString *deviceName = [NSString stringWithFormat:CustomLocalizedString(@"AirBackupOpen_Tips", nil),deviceNameStr];
        [_detailSubTitle1 setStringValue:deviceName];
       
        if (_curBaseInfo.deviceConnectMode == WifiRecordDevice) {
            [_deviceNamePopBtn setIsOnline:NO];
            [_deviceNamePopBtn setNeedsDisplay:YES];
            [_subTitleTextView setHidden:YES];
            [_noDeviceConnectSubTitleView setHidden:NO];
        }else {
            [_deviceNamePopBtn setIsOnline:YES];
            [_deviceNamePopBtn setNeedsDisplay:YES];
            [_subTitleTextView setHidden:NO];
            NSString *diskSize = nil;
            if ((_curBaseInfo.allDeviceSize - _curBaseInfo.kyDeviceSize) == 0) {
                diskSize = [CustomLocalizedString(@"AirBackupUseDiskCapacity", nil) stringByAppendingString:@"--"];
            }else {
                diskSize = [CustomLocalizedString(@"AirBackupUseDiskCapacity", nil) stringByAppendingString:[StringHelper getFileSizeString: (_curBaseInfo.allDeviceSize - _curBaseInfo.kyDeviceSize) reserved:2]];
            }
            
            NSString *batteryCapacity = nil;
            if (_curBaseInfo.batteryCapacity == 0) {
                batteryCapacity = [CustomLocalizedString(@"AirBackupBattery", nil) stringByAppendingString:@"--"];
            }else {
                batteryCapacity = [CustomLocalizedString(@"AirBackupBattery", nil) stringByAppendingString:[NSString stringWithFormat:@"%d%%",_curBaseInfo.batteryCapacity]];
            }
            
            NSString *promptStr = [[diskSize stringByAppendingString:@"  "]  stringByAppendingString:batteryCapacity];
            NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0] withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
            NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
            [mutParaStyle setAlignment:NSLeftTextAlignment];
            [mutParaStyle setLineSpacing:2.0];
            [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
            [[_subTitleTextView textStorage] setAttributedString:promptAs];
            [mutParaStyle release];
            [_noDeviceConnectSubTitleView setHidden:YES];
        }
    });
}

//wifi设备断开连接
- (void)wifiDeviceDisConnect:(NSNotification *)noti {
    NSLog(@"****************wifiDeviceDisConnect");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = noti.userInfo;
        if ([dic.allKeys containsObject:@"BaseInfo"]) {
            IMBBaseInfo *baseInfo = [dic objectForKey:@"BaseInfo"];
            baseInfo.isBackuping = NO;
            if (baseInfo.deviceConnectMode == WifiConnectDevice && [IMBDeviceConnection singleton].wifiDeviceArray.count == 1) {//没有设备连接
                [_deviceNamePopBtn setHidden:YES];
                [_subTitleTextView setHidden:YES];
                [_noDeviceTitle setHidden:NO];
                [_noDeviceConnectSubTitleView setHidden:NO];
                [self configNodeviceMainTitle];
                [_backupButton setEnabled:NO];
                [_switchButton setEnabled:NO];
                [_airBackupAnimationView endAnimation];
                [_airBackupAnimationView recoverBeginState];
                [_deviceNamePopBtn setIsDisable:NO];
                [_detailSubTitle1 setStringValue:CustomLocalizedString(@"AirBackupOpen_Tips1", nil)];
            }else {//还有设备连接
                if (baseInfo.deviceConnectMode != WifiConnectDevice) {//断开的是有记录的wifi设备
                    baseInfo.deviceConnectMode = WifiRecordDevice;
                    if ([baseInfo.uniqueKey isEqualToString:_curBaseInfo.uniqueKey]) {//断开的是当前设备
                        [_airBackupAnimationView endAnimation];
                        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[baseInfo.backupTime longValue]];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
                        NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
                        [dateFormatter release], dateFormatter = nil;
                        [_airBackupAnimationView setBackupSize:[StringHelper getFileSizeString:[baseInfo.backupSize longLongValue] reserved:2] WithBcakupDate:confromTimespStr WithRecordAry:baseInfo.backupRecordAryM];
                        [self resetAirBackUpConfig];
                        [_backupButton setEnabled:NO];
                        [_deviceNamePopBtn setIsDisable:NO];
                        NSString *deviceNameStr = _curBaseInfo.deviceName;
                        if (deviceNameStr.length >= 15) {
                            deviceNameStr = [deviceNameStr substringToIndex:15];
                            deviceNameStr = [deviceNameStr stringByAppendingString:@"..."];
                        }
                        NSString *deviceName = [NSString stringWithFormat:CustomLocalizedString(@"AirBackupOpen_Tips", nil),deviceNameStr];
                        [_detailSubTitle1 setStringValue:deviceName];
                    }
                }else {//断开的是无记录的wifi设备
                    if ([baseInfo.uniqueKey isEqualToString:_curBaseInfo.uniqueKey]) {//断开的是当前设备
                        [_airBackupAnimationView endAnimation];
                        IMBBaseInfo *reBaseInfo = [[IMBDeviceConnection singleton].wifiDeviceArray objectAtIndex:0];
                        BOOL flag = (reBaseInfo.deviceConnectMode == WifiRecordDevice)? NO : YES;
                        [_deviceNamePopBtn configButtonName:reBaseInfo.deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:26.0 WithOnline:flag];
                        [_deviceNamePopBtn setNeedsDisplay:YES];
                        _curBaseInfo = reBaseInfo;
                        _curBaseInfo.isSelected = YES;
                        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[reBaseInfo.backupTime longValue]];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
                        NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
                        [dateFormatter release], dateFormatter = nil;
                        [_airBackupAnimationView setBackupSize:[StringHelper getFileSizeString:[reBaseInfo.backupSize longLongValue] reserved:2] WithBcakupDate:confromTimespStr WithRecordAry:reBaseInfo.backupRecordAryM];
                        [self resetAirBackUpConfig];
                        if (reBaseInfo.deviceConnectMode == WifiRecordDevice) {
                            [_backupButton setEnabled:NO];
                        }else {
                            [_backupButton setEnabled:YES];
                        }
                        [_switchButton setEnabled:YES];
                        [_dayPopBtn setEnabled:YES];
                        [_deviceNamePopBtn setIsDisable:NO];
                        NSString *deviceNameStr = _curBaseInfo.deviceName;
                        if (deviceNameStr.length >= 15) {
                            deviceNameStr = [deviceNameStr substringToIndex:15];
                            deviceNameStr = [deviceNameStr stringByAppendingString:@"..."];
                        }
                        NSString *deviceName = [NSString stringWithFormat:CustomLocalizedString(@"AirBackupOpen_Tips", nil),deviceNameStr];
                        [_detailSubTitle1 setStringValue:deviceName];

                    }
                }
                [_deviceNamePopBtn setHidden:NO];
                [_noDeviceTitle setHidden:YES];
                if (_curBaseInfo.deviceConnectMode == WifiRecordDevice) {
                    [_deviceNamePopBtn setIsOnline:NO];
                    [_deviceNamePopBtn setNeedsDisplay:YES];
                    [_subTitleTextView setHidden:YES];
                    [_noDeviceConnectSubTitleView setHidden:NO];
                }else {
                    [_deviceNamePopBtn setIsOnline:YES];
                    [_deviceNamePopBtn setNeedsDisplay:YES];
                    [_subTitleTextView setHidden:NO];
                    NSString *diskSize = nil;
                    if ((_curBaseInfo.allDeviceSize - _curBaseInfo.kyDeviceSize) == 0) {
                        diskSize = [CustomLocalizedString(@"AirBackupUseDiskCapacity", nil) stringByAppendingString:@"--"];
                    }else {
                        diskSize = [CustomLocalizedString(@"AirBackupUseDiskCapacity", nil) stringByAppendingString:[StringHelper getFileSizeString: (_curBaseInfo.allDeviceSize - _curBaseInfo.kyDeviceSize) reserved:2]];
                    }
                    NSString *batteryCapacity = nil;
                    if (_curBaseInfo.batteryCapacity == 0) {
                        batteryCapacity = [CustomLocalizedString(@"AirBackupBattery", nil) stringByAppendingString:@"--"];
                    }else {
                        batteryCapacity = [CustomLocalizedString(@"AirBackupBattery", nil) stringByAppendingString:[NSString stringWithFormat:@"%d%%",_curBaseInfo.batteryCapacity]];
                    }
                    NSString *promptStr = [[diskSize stringByAppendingString:@"  "]  stringByAppendingString:batteryCapacity];
                    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0] withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
                    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
                    [mutParaStyle setAlignment:NSLeftTextAlignment];
                    [mutParaStyle setLineSpacing:2.0];
                    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
                    [[_subTitleTextView textStorage] setAttributedString:promptAs];
                    [mutParaStyle release];
                    [_noDeviceConnectSubTitleView setHidden:YES];
                }
            }
            if (baseInfo.deviceConnectMode == WifiConnectDevice) {
                [[IMBDeviceConnection singleton].wifiDeviceArray removeObject:baseInfo];
            }
        }
    });
}

//wifi设备开始备份
- (void)wifiDeviceStartBackUp:(NSNotification *)noti {
    NSLog(@"****************wifiDevice  startAnimation");
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Air_Backup action:AirBackup actionParams:@"Backup" label:Start transferCount:0 screenView:@"Backup View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = noti.userInfo;
        if ([dic.allKeys containsObject:@"BaseInfo"]) {
            IMBBaseInfo *baseInfo = [dic objectForKey:@"BaseInfo"];
            baseInfo.isBackuping = YES;
            if ([baseInfo.uniqueKey isEqualToString:_curBaseInfo.uniqueKey]) {
                _lastProgress = 0.0;
                [_backupButton setEnabled:NO];
                _curBaseInfo.isBackuping = YES;
                [_airBackupAnimationView startAnimationWithBaseInfo:baseInfo];
                [_airBackupAnimationView setBackupStart];
                [_deviceNamePopBtn setIsDisable:YES];
            }
        }
    });
}

//wifi设备备份进度
- (void)wifiDeviceBackUpProgress:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = noti.userInfo;
        if ([dic.allKeys containsObject:@"BaseInfo"]) {
            IMBBaseInfo *baseInfo = [dic objectForKey:@"BaseInfo"];
            if ([baseInfo.uniqueKey isEqualToString:_curBaseInfo.uniqueKey]) {
                [_backupButton setEnabled:NO];
                if (!_airBackupAnimationView.isRunning) {
                    [_airBackupAnimationView startAnimationWithBaseInfo:baseInfo];
                }
                if ([dic.allKeys containsObject:@"BackupProgress"]) {
                    double progress = [[dic objectForKey:@"BackupProgress"] doubleValue];
                    NSLog(@"****************wifiDevice BackUpProgress:%f",progress);
                    if (progress < _lastProgress) {
                        progress = _lastProgress;
                    }
                    [_airBackupAnimationView setBackupProgress:progress];
                    _lastProgress = progress;
                }
            }
        }
    });
}

//wifi设备备份完成
- (void)wifiDeviceBackUpComplete:(NSNotification *)noti {
    NSLog(@"****************wifiDevice  BackUpComplete");
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Air_Backup action:AirBackup actionParams:@"Backup" label:Finish transferCount:0 screenView:@"Backup View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = noti.userInfo;
        if ([dic.allKeys containsObject:@"BaseInfo"]) {
            IMBBaseInfo *baseInfo = [dic objectForKey:@"BaseInfo"];
            baseInfo.isBackuping = NO;
            long long backupSize = 0;
            NSString *path = [[IMBHelper getBackupServerSupportConfigPath] stringByAppendingPathComponent:@"backupRecord.plist"];
            NSFileManager *_fm = [NSFileManager defaultManager];
            if ([_fm fileExistsAtPath:path]) {
                NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
                if (dic != nil) {
                    for (NSString *str in dic.allKeys) {
                        id ary = [dic objectForKey:str];
                        if ([ary isKindOfClass:[NSArray class]]) {
                            if ([str isEqualToString:baseInfo.uniqueKey]) {
                                NSArray *records = (NSArray *)ary;
                                [baseInfo.backupRecordAryM removeAllObjects];
                                for (int i = (int)records.count - 1; i < records.count; i --) {
                                    NSDictionary *dic = [records objectAtIndex:i];
                                    if ([dic isKindOfClass:[NSDictionary class]]) {
                                        if (i == (int)records.count - 1) {
                                            baseInfo.backupSize = [dic objectForKey:@"BackupSize"];
                                            baseInfo.backupTime = [dic objectForKey:@"BackupTime"];
                                            baseInfo.deviceName = [dic objectForKey:@"DeviceName"];
                                            baseInfo.uniqueKey = [dic objectForKey:@"SerialNumber"];
                                            baseInfo.connectType = [IMBHelper family:[dic objectForKey:@"DeviceType"]];
                                        }
                                        IMBBackupRecord *record = [[IMBBackupRecord alloc] init];
                                        record.name = [dic objectForKey:@"DeviceName"];
                                        record.path = [dic objectForKey:@"BackupPath"];
                                        record.size = [dic objectForKey:@"BackupSize"];
                                        record.time = [dic objectForKey:@"BackupTime"];
                                        record.encryptBackup = [[dic objectForKey:@"EncryptBackup"] boolValue];
                                        record.connectType = baseInfo.connectType;
                                        [baseInfo.backupRecordAryM addObject:record];
                                        [record release], record = nil;
                                    }
                                }
                            }
                        }else {
                            backupSize = [(NSNumber *)ary longLongValue];
                        }
                    }
                }
            }
            if ([baseInfo.uniqueKey isEqualToString:_curBaseInfo.uniqueKey]) {
                [_deviceNamePopBtn setIsDisable:NO];
                _lastProgress = 0.0;
                if (baseInfo.deviceConnectMode != WifiRecordDevice) {
                    [_backupButton setEnabled:YES];
                }else {
                    [_backupButton setEnabled:NO];
                }
                _curBaseInfo.isBackuping = NO;
                [_airBackupAnimationView endAnimation];
                
                //备份完成界面处理
                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[baseInfo.backupTime longValue]];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
                
                NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
                [dateFormatter release], dateFormatter = nil;
                [_airBackupAnimationView setBackupSize:[StringHelper getFileSizeString:[baseInfo.backupSize longLongValue] reserved:2] WithBcakupDate:confromTimespStr WithRecordAry:baseInfo.backupRecordAryM];
            }
            
            if(![IMBSoftWareInfo singleton].isRegistered) {
                IMBMainWindowController *mainWindow = (IMBMainWindowController *)_delegate;
                if (mainWindow.curFunctionType == AirBackupModule) {
                    if (8600000000 - backupSize >0) {
                        _annoyEnum = BackupStorage_Limit;
                    }else {
                         _annoyEnum = BackupStorage_None;
                    }
                    [self configAnnoyView];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [_annoyView setWantsLayer:YES];
                        [_airBackupView addSubview:_annoyView];
                        [_annoyView setFrame:NSMakeRect(_airBackupView.frame.origin.x, _airBackupView.frame.origin.y, _airBackupView.frame.size.width, _airBackupView.frame.size.height)];
                        [_annoyView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
                        [_annoyView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-_annoyView.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
                    });
                }
            }
        }
    });
}

//wifi设备备份错误
- (void)wifiDeviceBackUpError:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        int errorId = 0;
        NSDictionary *dic = noti.userInfo;
        if ([dic.allKeys containsObject:@"BaseInfo"]) {
            IMBBaseInfo *baseInfo = [dic objectForKey:@"BaseInfo"];
            baseInfo.isBackuping = NO;
            if ([baseInfo.uniqueKey isEqualToString:_curBaseInfo.uniqueKey]) {
                if ([dic.allKeys containsObject:@"ErrorId"]) {
                    errorId = [[dic objectForKey:@"ErrorId"] intValue];
                    NSDictionary *dimensionDict = nil;
                    @autoreleasepool {
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:Air_Backup action:ActionNone actionParams:[NSString stringWithFormat:@"%d", errorId] label:Error transferCount:0 screenView:@"Backup View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                }
                if (baseInfo.deviceConnectMode != WifiRecordDevice) {
                    [_backupButton setEnabled:YES];
                }else {
                    [_backupButton setEnabled:NO];
                }
                [_deviceNamePopBtn setIsDisable:NO];
                _curBaseInfo.isBackuping = NO;
                [_airBackupAnimationView endAnimation];
                //备份错误界面处理
                if (_curBaseInfo.backupRecordAryM.count > 0) {
                    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_curBaseInfo.backupTime longValue]];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
                    NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
                    [dateFormatter release], dateFormatter = nil;
                    [_airBackupAnimationView setBackupSize:[StringHelper getFileSizeString:[_curBaseInfo.backupSize longLongValue] reserved:2] WithBcakupDate:confromTimespStr WithRecordAry:_curBaseInfo.backupRecordAryM];
                }else {
                    [_airBackupAnimationView recoverBeginState];
                }
            }
        }
    });
}

- (void)refreshWifiView:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = noti.userInfo;
        if ([dic.allKeys containsObject:@"BaseInfo"]) {
            IMBBaseInfo *baseInfo = [dic objectForKey:@"BaseInfo"];
            if ([baseInfo.uniqueKey isEqualToString:_curBaseInfo.uniqueKey]) {
                if (baseInfo.deviceConnectMode != WifiRecordDevice) {
                    [_backupButton setEnabled:YES];
                }else {
                    [_backupButton setEnabled:NO];
                }
            }
        }
    });
}

- (void)setBackupButtonAndDevicePopBtn {
    [_deviceNamePopBtn setIsDisable:NO];
    if (_curBaseInfo.deviceConnectMode != WifiRecordDevice) {
        [_backupButton setEnabled:YES];
    }else {
        [_backupButton setEnabled:NO];
    }
}

#pragma mark - 配置文字图片以及按钮属性 
- (void)configTextAndImageAndButton {
    //没有设备连接的时候
    [self configNodeviceMainTitle];
    
    [_deviceNamePopBtn setWantsLayer:YES];
    [_deviceNamePopBtn setTarget:self];
    [_deviceNamePopBtn setAction:@selector(selectDeviceBackupBtnClick:)];
    
    [_switchButton setTarget:self];
    [_switchButton setAction:@selector(changeSwitchBtnState)];
    
    [_detaiTitle1 setStringValue:CustomLocalizedString(@"AirBackupOpen", nil)];

    [_detaiTitle1 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_detailSubTitle1 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    [_detaiTitle2 setStringValue:CustomLocalizedString(@"AirBackupInterval", nil)];
    [_detailSubTitle2 setStringValue:CustomLocalizedString(@"AirBackupInterval_Tips", nil)];
    [_detaiTitle2 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_detailSubTitle2 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    [_detaiTitle3 setStringValue:CustomLocalizedString(@"AirBackupTimely", nil)];
    [_detailSubTitle3 setStringValue:CustomLocalizedString(@"AirBackupTimely_tips", nil)];
    [_detaiTitle3 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_detailSubTitle3 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_topLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_bottomLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    //图片配置
    [_imageView1 setImage:[StringHelper imageNamed:@"airbackup_seticon1"]];
    [_imageView2 setImage:[StringHelper imageNamed:@"airbackup_seticon2"]];
    [_imageView3 setImage:[StringHelper imageNamed:@"airbackup_seticon3"]];
    [_backgroundImageView setImage:[StringHelper imageNamed:@"airbackup_bg"]];
    
    //配置按钮
    //备份周期按钮
    [_dayPopBtn setHasMinWidth:YES];
    [_dayPopBtn setMinWidth:84];
    [_dayPopBtn setBtnHeight:20];
    [_dayPopBtn setTitleSpaceWidth:8];
    [_dayPopBtn setArrowSpace:5];
    [_dayPopBtn setTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_dayPopBtn setFontSize:12.0];
    [_dayPopBtn setArrowImage:[StringHelper imageNamed:@"arrow"]];
    [_dayPopBtn.menu removeAllItems];
    NSMenuItem *proItem1 = [[NSMenuItem alloc] init];
    [proItem1 setTitle:CustomLocalizedString(@"AirBackupIntervalType_Daily", nil)];
    [proItem1 setState:NSOffState];
    [proItem1 setTag:501];
    [proItem1 setTarget:self];
    [proItem1 setAction:@selector(changeBackupTimeInterval:)];
    [_dayPopBtn.menu addItem:proItem1];
    [proItem1 release];
    
    NSMenuItem *proItem2 = [[NSMenuItem alloc] init];
    if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
        [proItem2 setTitle:[@"Alle 2 " stringByAppendingString: CustomLocalizedString(@"AirBackupIntervalType_Day", nil)]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
         [proItem2 setTitle:@"يومين"];
    }else {
        [proItem2 setTitle:[@"2 " stringByAppendingString: CustomLocalizedString(@"AirBackupIntervalType_Day", nil)]];
    }
    
    [proItem2 setState:NSOffState];
    [proItem2 setTag:502];
    [proItem2 setTarget:self];
    [proItem2 setAction:@selector(changeBackupTimeInterval:)];
    [_dayPopBtn.menu addItem:proItem2];
    [proItem2 release];
    
    NSMenuItem *proItem3 = [[NSMenuItem alloc] init];
    if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
        [proItem3 setTitle:[@"Alle 3 " stringByAppendingString: CustomLocalizedString(@"AirBackupIntervalType_Day", nil)]];
    }else {
        [proItem3 setTitle:[@"3 " stringByAppendingString: CustomLocalizedString(@"AirBackupIntervalType_Day", nil)]];
    }
    
    [proItem3 setState:NSOffState];
    [proItem3 setTag:503];
    [proItem3 setTarget:self];
    [proItem3 setAction:@selector(changeBackupTimeInterval:)];
    [_dayPopBtn.menu addItem:proItem3];
    
    NSMenuItem *proItem4 = [[NSMenuItem alloc] init];
    [proItem4 setTitle:CustomLocalizedString(@"AirBackupIntervalType_Weekly", nil)];
    [proItem4 setState:NSOffState];
    [proItem4 setTag:504];
    [proItem4 setTarget:self];
    [proItem4 setAction:@selector(changeBackupTimeInterval:)];
    [_dayPopBtn.menu addItem:proItem4];
    [proItem4 release];
    
    NSMenuItem *proItem5 = [[NSMenuItem alloc] init];
    if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
        [proItem5 setTitle:[@"Alle 2 " stringByAppendingString: CustomLocalizedString(@"AirBackupIntervalType_Week", nil)]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        [proItem5 setTitle:@"أسبوعين"];
    }else {
        [proItem5 setTitle:[@"2 " stringByAppendingString: CustomLocalizedString(@"AirBackupIntervalType_Week", nil)]];
    }
    
    [proItem5 setState:NSOffState];
    [proItem5 setTag:505];
    [proItem5 setTarget:self];
    [proItem5 setAction:@selector(changeBackupTimeInterval:)];
    [_dayPopBtn.menu addItem:proItem5];
    [proItem5 release];
    
    NSMenuItem *proItem6 = [[NSMenuItem alloc] init];
    [proItem6 setTitle:CustomLocalizedString(@"AirBackupIntervalType_Monthly", nil)];
    [proItem6 setState:NSOffState];
    [proItem6 setTag:506];
    [proItem6 setTarget:self];
    [proItem6 setAction:@selector(changeBackupTimeInterval:)];
    [_dayPopBtn.menu addItem:proItem6];
    [proItem6 release];
    
    //默认为三天备份一次
    [proItem3 setState:NSOnState];
    [_dayPopBtn selectItem:proItem3];
    if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
        [_dayPopBtn setTitle:[@"Alle 3 " stringByAppendingString: CustomLocalizedString(@"AirBackupIntervalType_Day", nil)]];
    }else {
        [_dayPopBtn setTitle:[@"3 " stringByAppendingString: CustomLocalizedString(@"AirBackupIntervalType_Day", nil)]];
    }
    [proItem3 release];
    [_dayPopBtn setHasBorder:YES];
    if (![IMBSoftWareInfo singleton].isRegistered) {
        [_dayPopBtn setIsBackupTime:YES];
        [_dayPopBtn setDelegete:self];
    }
    [_dayPopBtn setNeedsDisplay:YES];
    
    //备份按钮
    //按钮样式
    NSString *okButtonString = CustomLocalizedString(@"AirBackupTimelyBackupText", nil);
    [_backupButton reSetInit:okButtonString WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okButtonString]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_backupButton setDisableColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)]];
    [_backupButton setFontSize:12.0];
    [_backupButton setAttributedTitle:attributedTitles];
    [_backupButton setTarget:self];
    [_backupButton setAction:@selector(backupNowClick)];
    NSRect rect = [StringHelper calcuTextBounds:_backupButton.title fontSize:12.0];
    [_backupButton setFrameSize:NSMakeSize(rect.size.width + 28, 22)];
    [_backupButton setNeedsDisplay:YES];
    
    //文字按钮
    NSString *settingStr = CustomLocalizedString(@"AirBackupSettingText", nil);
    [_settingTextView setNormalString:settingStr WithLinkString:settingStr WithNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    [_settingTextView setAlignment:NSLeftTextAlignment];
    [_settingTextView setDelegate:self];
    [_settingTextView setSelectable:YES];
    
    NSString *learnMoreStr = CustomLocalizedString(@"AirBackupGuideText", nil);
    [_learnMoreTextView setNormalString:learnMoreStr WithLinkString:learnMoreStr WithNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    [_learnMoreTextView setAlignment:NSRightTextAlignment];
    [_learnMoreTextView setSelectable:YES];
    [_learnMoreTextView setDelegate:self];
    
    if ([IMBDeviceConnection singleton].wifiDeviceArray.count == 0) {
        [_switchButton setEnabled:NO];
        [_backupButton setEnabled:NO];
        [_deviceNamePopBtn setHidden:YES];
        [_noDeviceTitle setHidden:NO];
        [_subTitleTextView setHidden:YES];
        [_noDeviceConnectSubTitleView setHidden:NO];
        [self resetAirBackUpConfig];
    } else {
        IMBBaseInfo *baseInfo = [[IMBDeviceConnection singleton].wifiDeviceArray objectAtIndex:0];
        if (_curBaseInfo) {
            _curBaseInfo.isSelected = NO;
        }
        _curBaseInfo = baseInfo;
        _curBaseInfo.isSelected = YES;
        if (_curBaseInfo.backupRecordAryM.count > 0) {
            [_airBackupAnimationView setHaveAirBackup:YES];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[baseInfo.backupTime longValue]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
            NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
            [dateFormatter release], dateFormatter = nil;
            [_airBackupAnimationView setBackupSize:[StringHelper getFileSizeString:[baseInfo.backupSize longLongValue] reserved:2] WithBcakupDate:confromTimespStr WithRecordAry:baseInfo.backupRecordAryM];
        }else {
            [_airBackupAnimationView setHaveAirBackup:NO];
        }
        BOOL flag = (baseInfo.deviceConnectMode == WifiRecordDevice)? NO : YES;
        [_deviceNamePopBtn configButtonName:baseInfo.deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:26.0 WithOnline:flag];
        [_deviceNamePopBtn setNeedsDisplay:YES];
        [_deviceNamePopBtn setHidden:NO];
        [_noDeviceConnectSubTitleView setHidden:YES];
        if (baseInfo.deviceConnectMode == WifiRecordDevice || _curBaseInfo.isBackuping) {
            [_backupButton setEnabled:NO];
        }else {
            [_backupButton setEnabled:YES];
        }
        
        NSString *diskSize = nil;
        if ((_curBaseInfo.allDeviceSize - _curBaseInfo.kyDeviceSize) == 0) {
            diskSize = [CustomLocalizedString(@"AirBackupUseDiskCapacity", nil) stringByAppendingString:@"--"];
        }else {
            diskSize = [CustomLocalizedString(@"AirBackupUseDiskCapacity", nil) stringByAppendingString:[StringHelper getFileSizeString: (_curBaseInfo.allDeviceSize - _curBaseInfo.kyDeviceSize) reserved:2]];
        }
        NSString *batteryCapacity = nil;
        if (_curBaseInfo.batteryCapacity == 0) {
            batteryCapacity = [CustomLocalizedString(@"AirBackupBattery", nil) stringByAppendingString:@"--"];
        }else {
            batteryCapacity = [CustomLocalizedString(@"AirBackupBattery", nil) stringByAppendingString:[NSString stringWithFormat:@"%d%%",_curBaseInfo.batteryCapacity]];
        }
        NSString *promptStr = [[diskSize stringByAppendingString:@"  "]  stringByAppendingString:batteryCapacity];
        NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0] withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:NSLeftTextAlignment];
        [mutParaStyle setLineSpacing:2.0];
        [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
        [[_subTitleTextView textStorage] setAttributedString:promptAs];
        [mutParaStyle release];
        
        [self resetAirBackUpConfig];
        if (_curBaseInfo.deviceConnectMode == WifiRecordDevice) {
            [_subTitleTextView setHidden:YES];
            [_noDeviceConnectSubTitleView setHidden:NO];
        }else {
            [_subTitleTextView setHidden:NO];
            [_noDeviceConnectSubTitleView setHidden:YES];
        }
    }
    
    if ([IMBDeviceConnection singleton].wifiDeviceArray.count > 0) {
        NSString *deviceNameStr = _curBaseInfo.deviceName;
        if (deviceNameStr.length >= 15) {
            deviceNameStr = [deviceNameStr substringToIndex:15];
            deviceNameStr = [deviceNameStr stringByAppendingString:@"..."];
        }
        NSString *deviceName = [NSString stringWithFormat:CustomLocalizedString(@"AirBackupOpen_Tips", nil),deviceNameStr];
        [_detailSubTitle1 setStringValue:deviceName];
    }else {
        [_detailSubTitle1 setStringValue:CustomLocalizedString(@"AirBackupOpen_Tips1", nil)];
    }
    
    [self setAirBackupViewframe];
}

- (void)setBackupGuideAlertView {
    if (![IMBSoftWareInfo singleton].isStartUpAirBackup) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSView *view = nil;
            for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
                if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                    view = subView;
                    break;
                }
            }
            [view setHidden:NO];
            [_alertViewController showAirBackupGuideAlertViewWithSuperView:view];
        });
    }
}

#pragma mark - 无设备连接配置对应文字
- (void)configNodeviceMainTitle {
    //文字属性
    [_noDeviceTitle setStringValue:CustomLocalizedString(@"AirBackupGuideHotSpot", nil)];
    [_noDeviceTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    if([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        NSRect pWifiRect = [StringHelper calcuTextBounds:CustomLocalizedString(@"AirBackupPublicWifi", nil) fontSize:12.0];
        [_publicWifiBtn setNormalFillColor:[NSColor colorWithDeviceWhite:0 alpha:0] WithEnterFillColor:[NSColor colorWithDeviceWhite:0 alpha:0] WithDownFillColor:[NSColor colorWithDeviceWhite:0 alpha:0]];
        [_publicWifiBtn setButtonTitle:CustomLocalizedString(@"AirBackupPublicWifi", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgnormalColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgEnterColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgDownColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgnormalColor", nil)] withTitleSize:12.0 WithLightAnimation:NO];
        
        [_publicWifiBtn setHasLeftImage:YES];
        [_publicWifiBtn setHasBorder:NO];
        [_publicWifiBtn setIsNoGridient:YES];
        [_publicWifiBtn setIsAirBackupBtn:YES];
        [_publicWifiBtn setTarget:self];
        [_publicWifiBtn setAction:@selector(publicWiFiBtnClick)];
        [_publicWifiBtn setLeftImage:[StringHelper imageNamed:@"airbackup_public"]];
        [_publicWifiBtn setSpaceWithText:1];
        [_publicWifiBtn setFrame:NSMakeRect(30,_noDeviceSubTitle.frame.origin.y, pWifiRect.size.width + 20 + 22, 22)];
        [_publicWifiBtn setNeedsDisplay:YES];
        
        [_orLabel setStringValue:CustomLocalizedString(@"AirBackupNoDevice_OrLabel", nil)];
        [_orLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        NSRect orRect = [StringHelper calcuTextBounds:_orLabel.stringValue fontSize:12.0];
        [_orLabel setFrame:NSMakeRect(_publicWifiBtn.frame.origin.x + _publicWifiBtn.frame.size.width - 6 , _noDeviceSubTitle.frame.origin.y, orRect.size.width + 5, 22)];
        
        NSRect hotRect = [StringHelper calcuTextBounds:CustomLocalizedString(@"AirBackupHotWifi", nil) fontSize:12.0];
        [_hotWiFiBtn setNormalFillColor:[NSColor clearColor] WithEnterFillColor:[NSColor clearColor] WithDownFillColor:[NSColor clearColor]];
        [_hotWiFiBtn setButtonTitle:CustomLocalizedString(@"AirBackupHotWifi", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgnormalColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgEnterColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgDownColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgnormalColor", nil)] withTitleSize:12.0 WithLightAnimation:NO];
        
        [_hotWiFiBtn setHasLeftImage:YES];
        [_hotWiFiBtn setHasBorder:NO];
        [_hotWiFiBtn setIsAirBackupBtn:YES];
        [_hotWiFiBtn setIsNoGridient:YES];
        [_hotWiFiBtn setTarget:self];
        [_hotWiFiBtn setAction:@selector(hotWiFiBtnClick)];
        [_hotWiFiBtn setLeftImage:[StringHelper imageNamed:@"airbackup_hot"]];
        [_hotWiFiBtn setSpaceWithText:1];
        [_hotWiFiBtn setFrame:NSMakeRect(_orLabel.frame.origin.x + orRect.size.width , _orLabel.frame.origin.y, hotRect.size.width + 20 + 22 , 22)];
        [_hotWiFiBtn setNeedsDisplay:YES];
        
        //配置未连接设备时的副标题
        [_noDeviceSubTitle setStringValue:CustomLocalizedString(@"AirBackupGuideHotSpotDetail", nil)];
        [_noDeviceSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        NSRect textRect = [StringHelper calcuTextBounds:_noDeviceSubTitle.stringValue fontSize:12.0];
        [_noDeviceSubTitle setFrame:NSMakeRect(_hotWiFiBtn.frame.origin.x + hotRect.size.width + 28, _orLabel.frame.origin.y, textRect.size.width, 22)];

        [_symbolLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [_symbolLabel setStringValue:@""];
        [_symbolLabel setFrame:NSMakeRect(_noDeviceSubTitle.frame.origin.x + textRect.size.width, _orLabel.frame.origin.y, 10 , 22)];
    }else {
        //配置未连接设备时的副标题
        [_noDeviceSubTitle setStringValue:CustomLocalizedString(@"AirBackupGuideHotSpotDetail", nil)];
        [_noDeviceSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        NSRect textRect = [StringHelper calcuTextBounds:_noDeviceSubTitle.stringValue fontSize:12.0];
        [_noDeviceSubTitle setFrame:NSMakeRect(30, 9, textRect.size.width+4, 22)];
        
        NSRect pWifiRect = [StringHelper calcuTextBounds:CustomLocalizedString(@"AirBackupPublicWifi", nil) fontSize:12.0];
        [_publicWifiBtn setNormalFillColor:[NSColor colorWithDeviceWhite:0 alpha:0] WithEnterFillColor:[NSColor colorWithDeviceWhite:0 alpha:0] WithDownFillColor:[NSColor colorWithDeviceWhite:0 alpha:0]];
        [_publicWifiBtn setButtonTitle:CustomLocalizedString(@"AirBackupPublicWifi", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgnormalColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgEnterColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgDownColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgnormalColor", nil)] withTitleSize:12.0 WithLightAnimation:NO];
        
        [_publicWifiBtn setHasLeftImage:YES];
        [_publicWifiBtn setHasBorder:NO];
        [_publicWifiBtn setIsNoGridient:YES];
        [_publicWifiBtn setIsAirBackupBtn:YES];
        [_publicWifiBtn setTarget:self];
        [_publicWifiBtn setAction:@selector(publicWiFiBtnClick)];
        [_publicWifiBtn setLeftImage:[StringHelper imageNamed:@"airbackup_public"]];
        [_publicWifiBtn setSpaceWithText:1];
        [_publicWifiBtn setFrame:NSMakeRect(_noDeviceSubTitle.frame.origin.x + textRect.size.width + 4,_noDeviceSubTitle.frame.origin.y, pWifiRect.size.width + 20 + 22, 22)];
        [_publicWifiBtn setNeedsDisplay:YES];
        
        [_orLabel setStringValue:CustomLocalizedString(@"AirBackupNoDevice_OrLabel", nil)];
        [_orLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        NSRect orRect = [StringHelper calcuTextBounds:_orLabel.stringValue fontSize:12.0];
        [_orLabel setFrame:NSMakeRect(_publicWifiBtn.frame.origin.x + _publicWifiBtn.frame.size.width - 1 , _noDeviceSubTitle.frame.origin.y, orRect.size.width + 5, 22)];
        
        NSRect hotRect = [StringHelper calcuTextBounds:CustomLocalizedString(@"AirBackupHotWifi", nil) fontSize:12.0];
        [_hotWiFiBtn setNormalFillColor:[NSColor clearColor] WithEnterFillColor:[NSColor clearColor] WithDownFillColor:[NSColor clearColor]];
        [_hotWiFiBtn setButtonTitle:CustomLocalizedString(@"AirBackupHotWifi", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgnormalColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgEnterColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgDownColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"textClick_bgnormalColor", nil)] withTitleSize:12.0 WithLightAnimation:NO];
        
        
        [_hotWiFiBtn setHasLeftImage:YES];
        [_hotWiFiBtn setHasBorder:NO];
        [_hotWiFiBtn setIsAirBackupBtn:YES];
        [_hotWiFiBtn setIsNoGridient:YES];
        [_hotWiFiBtn setTarget:self];
        [_hotWiFiBtn setAction:@selector(hotWiFiBtnClick)];
        [_hotWiFiBtn setLeftImage:[StringHelper imageNamed:@"airbackup_hot"]];
        [_hotWiFiBtn setSpaceWithText:1];
        [_hotWiFiBtn setFrame:NSMakeRect(_orLabel.frame.origin.x + orRect.size.width + 4, _orLabel.frame.origin.y, hotRect.size.width + 20 + 22 , 22)];
        [_hotWiFiBtn setNeedsDisplay:YES];
        
        [_symbolLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [_symbolLabel setStringValue:@"."];
        [_symbolLabel setFrame:NSMakeRect(_hotWiFiBtn.frame.origin.x + _hotWiFiBtn.frame.size.width - 6, _orLabel.frame.origin.y, 10 , 22)];
    }
}

#pragma mark - 计算文字长度设置界面
- (void)setAirBackupViewframe {
    NSRect rect1;
    NSRect rect2;
    NSRect rect3;
    rect1 = [StringHelper calcuTextBounds:_detailSubTitle1.stringValue fontSize:12.0];
    rect2 = [StringHelper calcuTextBounds:_detailSubTitle2.stringValue fontSize:12.0];
    rect3 = [StringHelper calcuTextBounds:_detailSubTitle3.stringValue fontSize:12.0];
    if (rect1.size.width >= 1095) {
        [_imageView2 setFrameOrigin:NSMakePoint(_imageView2.frame.origin.x, 216 - HEIGHT)];
        [_detaiTitle2 setFrameOrigin:NSMakePoint(_detaiTitle2.frame.origin.x, 241 - HEIGHT)];
        [_dayPopBtn setFrameOrigin:NSMakePoint(475 - 36 - _dayPopBtn.frame.size.width, 247 - HEIGHT)];
        [_detailSubTitle2 setFrameOrigin:NSMakePoint(_detailSubTitle2.frame.origin.x, 184 - HEIGHT)];
        [_imageView3 setFrameOrigin:NSMakePoint(_imageView3.frame.origin.x, 142 - HEIGHT)];
        [_detaiTitle3 setFrameOrigin:NSMakePoint(_detaiTitle3.frame.origin.x, 165 - HEIGHT)];
        [_backupButton setFrameOrigin:NSMakePoint(475 - 36 - _backupButton.frame.size.width, 169 - HEIGHT)];
        [_detailSubTitle3 setFrameOrigin:NSMakePoint(_detailSubTitle3.frame.origin.x, 106 - HEIGHT)];
        [_bottomLineView setFrameOrigin:NSMakePoint(_bottomLineView.frame.origin.x, 111 - HEIGHT*2)];
        [_settingScrollView setFrameOrigin:NSMakePoint(_settingScrollView.frame.origin.x, 80 - HEIGHT*2)];
        [_learnMoreScrollView setFrameOrigin:NSMakePoint(_learnMoreScrollView.frame.origin.x, 80 - HEIGHT*2)];
    } else if (rect2.size.width <= 369 && rect1.size.width >= 700) {
        [_imageView2 setFrameOrigin:NSMakePoint(_imageView2.frame.origin.x, 216)];
        [_detaiTitle2 setFrameOrigin:NSMakePoint(_detaiTitle2.frame.origin.x, 241)];
        [_dayPopBtn setFrameOrigin:NSMakePoint(475 - 36 - _dayPopBtn.frame.size.width, 247)];
        [_detailSubTitle2 setFrameOrigin:NSMakePoint(_detailSubTitle2.frame.origin.x, 184)];
        [_imageView3 setFrameOrigin:NSMakePoint(_imageView3.frame.origin.x, 142 + HEIGHT - 4)];
        [_detaiTitle3 setFrameOrigin:NSMakePoint(_detaiTitle3.frame.origin.x, 165 + HEIGHT - 4)];
        [_backupButton setFrameOrigin:NSMakePoint(475 - 36 - _backupButton.frame.size.width, 169 + HEIGHT - 4)];
        [_detailSubTitle3 setFrameOrigin:NSMakePoint(_detailSubTitle3.frame.origin.x, 106 + HEIGHT- 4)];
        [_bottomLineView setFrameOrigin:NSMakePoint(_bottomLineView.frame.origin.x, 111 + HEIGHT - 4)];
        [_settingScrollView setFrameOrigin:NSMakePoint(_settingScrollView.frame.origin.x, 80 + HEIGHT - 4)];
        [_learnMoreScrollView setFrameOrigin:NSMakePoint(_learnMoreScrollView.frame.origin.x, 80 + HEIGHT - 4)];
    } else {
        [_imageView2 setFrameOrigin:NSMakePoint(_imageView2.frame.origin.x, 216)];
        [_detaiTitle2 setFrameOrigin:NSMakePoint(_detaiTitle2.frame.origin.x, 241)];
        [_dayPopBtn setFrameOrigin:NSMakePoint(475 - 36 - _dayPopBtn.frame.size.width, 247)];
        [_detailSubTitle2 setFrameOrigin:NSMakePoint(_detailSubTitle2.frame.origin.x, 184)];
        [_imageView3 setFrameOrigin:NSMakePoint(_imageView3.frame.origin.x, 142)];
        [_detaiTitle3 setFrameOrigin:NSMakePoint(_detaiTitle3.frame.origin.x, 165)];
        [_backupButton setFrameOrigin:NSMakePoint(475 - 36 - _backupButton.frame.size.width, 169)];
        [_detailSubTitle3 setFrameOrigin:NSMakePoint(_detailSubTitle3.frame.origin.x, 106)];
        [_bottomLineView setFrameOrigin:NSMakePoint(_bottomLineView.frame.origin.x, 111)];
        [_settingScrollView setFrameOrigin:NSMakePoint(_settingScrollView.frame.origin.x, 80)];
        [_learnMoreScrollView setFrameOrigin:NSMakePoint(_learnMoreScrollView.frame.origin.x, 80)];
    }
    
}

#pragma mark - 骚扰窗口
- (void)configAnnoyView {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [[OperationLImitation singleton] setLimitStatus:@""];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:AnyTrans_Activation action:AdAnnoy actionParams:[IMBSoftWareInfo singleton].selectModular label:LabelNone transferCount:0 screenView:@"Air Backup" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    if (![_annoyView.subviews containsObject:_closebutton]) {
        _closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil(_annoyView.frame.origin.y + _annoyView.frame.size.height - 38), 32, 32)];
        [_closebutton setTarget:self];
        [_closebutton setAction:@selector(closeWindow:)];
        [_closebutton setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin|NSViewNotSizable];
        [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
         [_annoyView addSubview:_closebutton];
    }
    [_annoyView setWantsLayer:YES];
    [_annoyView.layer setCornerRadius:5.0];
    
    //配置文字
    if(_annoyEnum == Backup_Now) {
        NSString *promptStr = CustomLocalizedString(@"AirBackupAnnoy_Title3", nil);
        NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:NSCenterTextAlignment];
        [mutParaStyle setLineSpacing:-0.8];
        [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
        [[_annoyViewTitle textStorage] setAttributedString:promptAs];
        NSString *promptStr1 = CustomLocalizedString(@"AirBackupAnnoy_SubTitle1", nil);
        NSMutableAttributedString *promptAs1 = [StringHelper setSingleTextAttributedString:promptStr1 withFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0] withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
        NSMutableParagraphStyle *mutParaStyle1=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle1 setAlignment:NSCenterTextAlignment];
        [mutParaStyle1 setLineSpacing:1.0];
        [promptAs1 addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle1 forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs1 string] length])];
        [_annoyViewSubTitle setAttributedStringValue:promptAs1];
    }else if (_annoyEnum == Change_BackupScheduled) {
        NSString *promptStr = CustomLocalizedString(@"AirBackupAnnoy_Title2", nil);
        NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:NSCenterTextAlignment];
        [mutParaStyle setLineSpacing:-0.8];
        [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
        [[_annoyViewTitle textStorage] setAttributedString:promptAs];
        [_annoyViewTitle setNeedsDisplay:YES];
        NSString *promptStr1 = CustomLocalizedString(@"AirBackupAnnoy_SubTitle1", nil);
        NSMutableAttributedString *promptAs1 = [StringHelper setSingleTextAttributedString:promptStr1 withFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0] withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
        NSMutableParagraphStyle *mutParaStyle1=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle1 setAlignment:NSCenterTextAlignment];
        [mutParaStyle1 setLineSpacing:1.0];
        [promptAs1 addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle1 forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs1 string] length])];
        [_annoyViewSubTitle setAttributedStringValue:promptAs1];
    }else if (_annoyEnum == BackupStorage_Limit) {
        NSString *remainSize = nil;
        NSString *path = [[IMBHelper getBackupServerSupportConfigPath] stringByAppendingPathComponent:@"backupRecord.plist"];
        NSFileManager *_fm = [NSFileManager defaultManager];
        if ([_fm fileExistsAtPath:path]) {
            NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
            if (dic != nil) {
                for (NSString *str in dic.allKeys) {
                    if ([str isEqualToString:@"TotalBackupSize"]) {
                        long long totalSize = [[dic objectForKey:@"TotalBackupSize"] longLongValue];
                        remainSize = [StringHelper getFileSizeString:(8600000000 - totalSize) reserved:2];
                        break;
                    }
                }
            }
        }
        if (remainSize == nil) {
            remainSize = [@"8" stringByAppendingString:CustomLocalizedString(@"MSG_Size_GB", nil)];
        }

        NSString *overStr = remainSize;
        NSString *promptStr = [NSString stringWithFormat:CustomLocalizedString(@"AirBackupAnnoy_Title", nil),overStr];
        NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
        [_annoyViewTitle setLinkTextAttributes:linkAttributes];
        
        NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
        NSRange infoRange = [promptStr rangeOfString:overStr];
        [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] range:infoRange];
        [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
        
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:NSCenterTextAlignment];
        [mutParaStyle setLineSpacing:-0.8];
        [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
        [[_annoyViewTitle textStorage] setAttributedString:promptAs];
        [mutParaStyle release], mutParaStyle = nil;
        
        NSString *promptStr1 = CustomLocalizedString(@"AirBackupAnnoy_SubTitle1", nil);
        NSMutableAttributedString *promptAs1 = [StringHelper setSingleTextAttributedString:promptStr1 withFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0] withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
        NSMutableParagraphStyle *mutParaStyle1=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle1 setAlignment:NSCenterTextAlignment];
        [mutParaStyle1 setLineSpacing:1.0];
        [promptAs1 addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle1 forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs1 string] length])];
        [_annoyViewSubTitle setAttributedStringValue:promptAs1];

    }else if (_annoyEnum == BackupStorage_None) {
        NSString *promptStr = CustomLocalizedString(@"AirBackupAnnoy_Title1", nil);
        NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:NSCenterTextAlignment];
        [mutParaStyle setLineSpacing:-0.8];
        [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
        [[_annoyViewTitle textStorage] setAttributedString:promptAs];
        [_annoyViewSubTitle setStringValue:CustomLocalizedString(@"AirBackupAnnoy_SubTitle1", nil)];
        NSString *promptStr1 = CustomLocalizedString(@"AirBackupAnnoy_SubTitle1", nil);
        NSMutableAttributedString *promptAs1 = [StringHelper setSingleTextAttributedString:promptStr1 withFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0] withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
        NSMutableParagraphStyle *mutParaStyle1=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle1 setAlignment:NSCenterTextAlignment];
        [mutParaStyle1 setLineSpacing:1.0];
        [promptAs1 addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle1 forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs1 string] length])];
        [_annoyViewSubTitle setAttributedStringValue:promptAs1];
    }
    
    [_annoyViewSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    //背景图
    [_annoyBgImageView setImage:[StringHelper imageNamed:@"annoy_airbackup"]];
//    [_annoyBgImageView setCanDrawSubviewsIntoLayer:YES];
    
    //两个按钮配置
    [_annoyButton1 setFont:[NSFont fontWithName:@"Helvetica Neue" size:16.0]];
    [_annoyButton1 setFontColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_annoyButton1 setLeftImage:[StringHelper imageNamed:@"annoyregister_normal_left"]];
    [_annoyButton1 setLeftEnterImage:[StringHelper imageNamed:@"annoyregister_enter_left"]];
    [_annoyButton1 setLeftDownImage:[StringHelper imageNamed:@"annoyregister_down_left"]];
    [_annoyButton1 setMiddleImage:[StringHelper imageNamed:@"annoyregister_normal_mid"]];
    [_annoyButton1 setMiddleEnterImage:[StringHelper imageNamed:@"annoyregister_enter_mid"]];
    [_annoyButton1 setMiddleDownImage:[StringHelper imageNamed:@"annoyregister_down_mid"]];
    [_annoyButton1 setRightImage:[StringHelper imageNamed:@"annoyregister_normal_right"]];
    [_annoyButton1 setRightEnterImage:[StringHelper imageNamed:@"annoyregister_enter_right"]];
    [_annoyButton1 setRightDownImage:[StringHelper imageNamed:@"annoyregister_down_right"]];
    [_annoyButton1 setMinWidth:150];
    [_annoyButton1 setTitle:CustomLocalizedString(@"annoy_id_1", nil)];
    [_annoyButton1 setTarget:self];
    [_annoyButton1 setAction:@selector(activateButtonClick)];
    NSRect rect = [StringHelper calcuTextBounds:CustomLocalizedString(@"annoy_id_1", nil) fontSize:16.0];
    if (rect.size.width<130) {
        rect.size.width = 130;
    }
    [_annoyButton1 setFrame:NSMakeRect(_annoyButton2.frame.origin.x - 20 - rect.size.width - 20, _annoyButton1.frame.origin.y, rect.size.width + 20, _annoyButton1.frame.size.height)];
    [_annoyButton1 setNeedsDisplay:YES];
    
    [_annoyButton2 setFont:[NSFont fontWithName:@"Helvetica Neue" size:16.0]];
    [_annoyButton2 setLeftImage:[StringHelper imageNamed:@"annoybuy_normal_left"]];
    [_annoyButton2 setLeftEnterImage:[StringHelper imageNamed:@"annoybuy_enter_left"]];
    [_annoyButton2 setLeftDownImage:[StringHelper imageNamed:@"annoybuy_down_left"]];
    [_annoyButton2 setMiddleImage:[StringHelper imageNamed:@"annoybuy_normal_mid"]];
    [_annoyButton2 setMiddleEnterImage:[StringHelper imageNamed:@"annoybuy_enter_mid"]];
    [_annoyButton2 setMiddleDownImage:[StringHelper imageNamed:@"annoybuy_down_mid"]];
    [_annoyButton2 setRightImage:[StringHelper imageNamed:@"annoybuy_normal_right"]];
    [_annoyButton2 setRightEnterImage:[StringHelper imageNamed:@"annoybuy_enter_right"]];
    [_annoyButton2 setRightDownImage:[StringHelper imageNamed:@"annoybuy_down_right"]];
    [_annoyButton2 setMinWidth:150];
    
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
        [_annoyButton2 setBgImage:[StringHelper imageNamed:@"annoy_christmas_buy_bg"]];
    }
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"] && [StringHelper chirstmasActivity] &&[IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {//圣诞节活动，只针对英语版本在圣诞节期间显示
        [_annoyButton2 setTitle:CustomLocalizedString(@"Christmas_Active_id_11", nil)];
    }else {
        [_annoyButton2 setTitle:CustomLocalizedString(@"harassment_buyBtn", nil)];
    }
    IMBBackgroundBorderView *arrowView = [[IMBBackgroundBorderView alloc] initWithFrame:NSMakeRect(NSWidth(_annoyButton2.frame)-8-8, ceil((NSHeight(_annoyButton2.frame) - 14)/2), 8, 14)];
    [arrowView setBackgroundImage:[StringHelper imageNamed:@"reg_buy_arrow1"]];
    [_annoyButton2 addSubview:arrowView];
    [arrowView release];
    [_annoyButton2 setTarget:self];
    [_annoyButton2 setAction:@selector(buyNowButtonClick)];
    [_annoyButton2 setNeedsDisplay:YES];
    
}

#pragma mark - buy-now
- (void)buyNowButtonClick {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [[OperationLImitation singleton] setLimitStatus:@""];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@#status=%@", [TempHelper currentSelectionLanguage], [IMBSoftWareInfo singleton].selectModular] label:Buy transferCount:0 screenView:@"Air Backup" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    [SystemHelper openChooseBrowser:softWare.buyId withIsActivate:NO isDiscount:NO isNeedAnalytics:NO];
}

#pragma mark - activate method
- (void)activateButtonClick {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    [[OperationLImitation singleton] setLimitStatus:@""];
    int result = [_alertViewController showAlertActivationView:view WithIsBackupNow:_isBackupNow];
    if (result == 2) {
        [self backupNowClick];
        [self closeWindow:nil];
    } else if (result == 1) {
        [self changeBackupTimeInterval:nil];
        [self closeWindow:nil];
    }
}

- (void)activateSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:ANNOY_REGIST_SUCCESS object:nil];
}

#pragma mark - closeWindow
- (void)closeWindow:(id)sender {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:@(0) Y:@(20) repeatCount:1];
        anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [_annoyView.layer addAnimation:anima1 forKey:@"moveY"];
    } completionHandler:^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:@(20) Y:@(-NSHeight(_annoyView.frame)) repeatCount:1];
            anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [_annoyView.layer addAnimation:anima1 forKey:@"moveY"];
        } completionHandler:^{
            [_annoyView removeFromSuperview];
        }];
    }];
}

#pragma mark - textView-delegete
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    if ([link isEqualToString:CustomLocalizedString(@"AirBackupSettingText", nil)]) {
        [self settingButtonClick];
    } else if ([link isEqualToString:CustomLocalizedString(@"AirBackupGuideText", nil)]) {
        [self chargeButtonClick];
    }
    return YES;
}

#pragma mark - 点击弹窗关于公共WIFI
- (void)publicWiFiBtnClick {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Air_Backup action:ActionNone actionParams:@"WLAN" label:Click transferCount:0 screenView:@"WLAN Guide" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        [_alertViewController showAirBackupPublicWiFiAlertViewWithSuperView:view];
    });
}

#pragma mark - 点击弹窗关于私人WiFi
- (void)hotWiFiBtnClick {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Air_Backup action:ActionNone actionParams:@"Wi-Fi hotspot" label:Click transferCount:0 screenView:@"Wi-Fi Hotspot Guide" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        [_alertViewController showAirBackupHotWiFiAlertViewWithSuperView:view];
    });
}

#pragma mark - 点击立即备份
- (void)backupNowClick {
    
    if (![IMBSoftWareInfo singleton].isRegistered) {
        _annoyEnum = Backup_Now;
        _isBackupNow = YES;
        [self configAnnoyView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_annoyView setWantsLayer:YES];
            [_airBackupView addSubview:_annoyView];
            [_annoyView setFrame:NSMakeRect(_airBackupView.frame.origin.x, _airBackupView.frame.origin.y, _airBackupView.frame.size.width, _airBackupView.frame.size.height)];
            [_annoyView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
            [_annoyView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-_annoyView.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
        });
    } else {
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Air_Backup action:ActionNone actionParams:@"Back Up Now" label:Click transferCount:0 screenView:@"Back Up Now View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        IMBSocketClient *socket = [IMBSocketClient singleton];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_curBaseInfo.uniqueKey, @"SerialNumber", @"BackupNow", @"MsgType", nil];
        NSString *str = [IMBHelper dictionaryToJson:dic];
        [socket sendData:str];
    }
}

#pragma mark - 点击高级设置弹窗 method
- (void)settingButtonClick {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Air_Backup action:ActionNone actionParams:@"Advanced Settings" label:Click transferCount:0 screenView:@"Advanced Settings View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    [_alertViewController showAirBackupSettingAlertViewWithSuperView:view WithDelegete:self];
}

#pragma mark - 了解更多 method
- (void)chargeButtonClick {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Air_Backup action:ActionNone actionParams:@"Learn more" label:Click transferCount:0 screenView:@"Learn more View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSString *urlStr = CustomLocalizedString(@"AirWiFiBackup_LearnMore_Url", nil);
    NSURL *url = [NSURL URLWithString:urlStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

#pragma mark - 从配置文件中读取airbackup的配置
- (void)resetAirBackUpConfig {
    NSString *configPath = [[IMBHelper getBackupServerSupportConfigPath] stringByAppendingPathComponent:@"airBackupConfig.plist"];
    NSFileManager *_fm = [NSFileManager defaultManager];
    if ([_fm fileExistsAtPath:configPath]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:configPath];
        if (dic != nil) {
            if ([dic.allKeys containsObject:_curBaseInfo.uniqueKey]) {
                 NSDictionary *spiDic = [dic objectForKey:_curBaseInfo.uniqueKey];
                BOOL isAirBackup = YES;
                if ([spiDic.allKeys containsObject:@"IsAirBackup"]) {
                   isAirBackup = [[spiDic objectForKey:@"IsAirBackup"] boolValue];
                }
                [_switchButton setOn:isAirBackup];
                if ([spiDic.allKeys containsObject:@"BackupDay"]) {
                   int backupDay = [[spiDic objectForKey:@"BackupDay"] intValue];
                    for (NSMenuItem *item in _dayPopBtn.menu.itemArray) {
                        [item setState:NSOffState];
                        if (backupDay == 1) {
                            if (item.tag == 501) {
                                [item setState:NSOnState];
                                [_dayPopBtn setTitle:item.title];
                            }
                        }else if (backupDay == 2) {
                            if (item.tag == 502) {
                                [item setState:NSOnState];
                                [_dayPopBtn setTitle:item.title];
                            }
                        }else if (backupDay == 3) {
                            if (item.tag == 503) {
                                [item setState:NSOnState];
                                [_dayPopBtn setTitle:item.title];
                            }
                        }else if (backupDay == 7) {
                            if (item.tag == 504) {
                                [item setState:NSOnState];
                                [_dayPopBtn setTitle:item.title];
                            }
                        }else if (backupDay == 14) {
                            if (item.tag == 505) {
                                [item setState:NSOnState];
                                [_dayPopBtn setTitle:item.title];
                            }
                        }else if (backupDay == 30) {
                            if (item.tag == 506) {
                                [item setState:NSOnState];
                                [_dayPopBtn setTitle:item.title];
                            }
                        }else {
                            if (item.tag == 503) {
                                [item setState:NSOnState];
                                [_dayPopBtn setTitle:item.title];
                            }
                        }
                    }
                }
                
            }else {//文件里面不存在，就显示默认的设置
                [_switchButton setOn:YES];
                for (NSMenuItem *item in _dayPopBtn.menu.itemArray) {
                    if (item.tag == 503) {
                        [item setState:NSOnState];
                        break;
                    }
                }
                [_dayPopBtn selectItemWithTag:503];
            }
        }
        [dic release];
    } else {
        //文件不存在设为默认值
        [_switchButton setOn:YES];
        for (NSMenuItem *item in _dayPopBtn.menu.itemArray) {
            if (item.tag == 503) {
                [item setState:NSOnState];
                break;
            }
        }
        [_dayPopBtn selectItemWithTag:503];
    }
}

#pragma mark - 点击周期按钮
- (void)backupTimeButtonClick {

    if (![IMBSoftWareInfo singleton].isRegistered) {
        _annoyEnum = Change_BackupScheduled;
        [self configAnnoyView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_annoyView setWantsLayer:YES];
            [_airBackupView addSubview:_annoyView];
            [_annoyView setFrame:NSMakeRect(_airBackupView.frame.origin.x, _airBackupView.frame.origin.y, _airBackupView.frame.size.width, _airBackupView.frame.size.height)];
            [_annoyView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
            [_annoyView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-_annoyView.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
        });
    }
}

#pragma mark - 选择备份周期并保存设置
- (void)changeBackupTimeInterval:(id)sender {
    for (NSMenuItem *item in _dayPopBtn.menu.itemArray) {
        if (item.state == NSOnState) {
            [_dayPopBtn setTitle:item.title];
            break;
        }
    }
    int day;
    if (_dayPopBtn.selectedItem.tag == 501) {
        day = 1;
    }else if (_dayPopBtn.selectedItem.tag == 502) {
        day = 2;
    }else if (_dayPopBtn.selectedItem.tag == 503) {
        day = 3;
    }else if (_dayPopBtn.selectedItem.tag == 504) {
        day = 7;
    }else if (_dayPopBtn.selectedItem.tag == 505) {
        day = 14;
    }else if (_dayPopBtn.selectedItem.tag == 506) {
        day = 30;
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Air_Backup action:ActionNone actionParams:[NSString stringWithFormat:@"Schedule Air Backup %d", day] label:Click transferCount:0 screenView:@"Schedule Air Backup View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [self saveConfig];
}

#pragma mark - 开关备份按钮并保存设置
- (void)changeSwitchBtnState {
    if (!_switchButton.isOn) {
        [_switchButton setOn:NO];
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    NSString *switchButtonStatus = nil;
    if (_switchButton.isOn) {
        switchButtonStatus = @"Enabled";
    }else {
        switchButtonStatus = @"Disabled";
    }
    [ATTracker event:Air_Backup action:ActionNone actionParams:[NSString stringWithFormat:@"Air Backup Preference %@", switchButtonStatus] label:Click transferCount:0 screenView:@"Air Backup Preference View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [self saveConfig];
}

#pragma mark - 保存设置方法
- (void)saveConfig {
    NSString *configPath = [[IMBHelper getBackupServerSupportConfigPath] stringByAppendingPathComponent:@"airBackupConfig.plist"];
    NSFileManager *_fm = [NSFileManager defaultManager];
    
    if ([IMBHelper stringIsNilOrEmpty:_curBaseInfo.uniqueKey]) {
        return;
    }
    NSMutableDictionary *dic = nil;
    NSMutableDictionary *subDic = nil;
    if ([_fm fileExistsAtPath:configPath]) {
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:configPath];
        if ([dic.allKeys containsObject:_curBaseInfo.uniqueKey]) {
            subDic = [dic objectForKey:_curBaseInfo.uniqueKey];
        }else {
            subDic = [NSMutableDictionary dictionary];
        }
    }else {
        dic = [[NSMutableDictionary alloc] init];
        subDic = [NSMutableDictionary dictionary];
    }
    [subDic setObject:[NSNumber numberWithBool:_switchButton.isOn] forKey:@"IsAirBackup"];
    int day;
    if (_dayPopBtn.selectedItem.tag == 501) {
        day = 1;
    }else if (_dayPopBtn.selectedItem.tag == 502) {
        day = 2;
    }else if (_dayPopBtn.selectedItem.tag == 503) {
        day = 3;
    }else if (_dayPopBtn.selectedItem.tag == 504) {
        day = 7;
    }else if (_dayPopBtn.selectedItem.tag == 505) {
        day = 14;
    }else if (_dayPopBtn.selectedItem.tag == 506) {
        day = 30;
    }
    [subDic setObject:[NSNumber numberWithInt:day] forKey:@"BackupDay"];
    [dic setObject:subDic forKey:_curBaseInfo.uniqueKey];
    [dic writeToFile:configPath atomically:YES];
    [dic release];
}

#pragma mark - forgot备份记录
- (void)removeAirBackupConfigWith:(NSString *)uuidKey {
    if([_curBaseInfo.uniqueKey isEqualToString:uuidKey]) {//如果是当前记录
        if (_curBaseInfo.deviceConnectMode == WifiRecordDevice) {//记录设备
            int count = (int)[IMBDeviceConnection singleton].wifiDeviceArray.count;
            if (count == 1) {
                [[IMBDeviceConnection singleton].wifiDeviceArray removeAllObjects];
                [_airBackupAnimationView recoverBeginState];
                [_switchButton setEnabled:NO];
                [_dayPopBtn selectItemWithTag:502];
                if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
                    [_dayPopBtn setTitle:[@"Alle 3 " stringByAppendingString: CustomLocalizedString(@"AirBackupIntervalType_Day", nil)]];
                }else {
                    [_dayPopBtn setTitle:[@"3 " stringByAppendingString: CustomLocalizedString(@"AirBackupIntervalType_Day", nil)]];
                }
                [_backupButton setEnabled:NO];
                [_deviceNamePopBtn setHidden:YES];
                [_subTitleTextView setHidden:YES];
                [_noDeviceTitle setHidden:NO];
                [_noDeviceConnectSubTitleView setHidden:NO];
                [self configNodeviceMainTitle];
            }else {
                __block BOOL flag = NO;
                [[IMBDeviceConnection singleton].wifiDeviceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    IMBBaseInfo *baseInfo = (IMBBaseInfo *)obj;
                    if ([baseInfo.uniqueKey isEqualToString:uuidKey]) {
                        if ([uuidKey isEqualToString:_curBaseInfo.uniqueKey]) {
                            flag = YES;
                        }
                        [[IMBDeviceConnection singleton].wifiDeviceArray removeObject:baseInfo];
                    }
                }];
                IMBBaseInfo *item = [[IMBDeviceConnection singleton].wifiDeviceArray objectAtIndex:0];
                if (flag) {
                    _curBaseInfo = item;
                }
                [self popOverViewControllerClick:item];
            }
        }else if (_curBaseInfo.deviceConnectMode == WifiTwoModeDevice) {
            for (IMBBaseInfo *itemInfo in [IMBDeviceConnection singleton].wifiDeviceArray) {
                if ([_curBaseInfo.uniqueKey isEqualToString:itemInfo.uniqueKey]) {
                    itemInfo.deviceConnectMode = WifiConnectDevice;
                    [itemInfo.backupRecordAryM removeAllObjects];
                    if (!_curBaseInfo.isBackuping) {
                        [_airBackupAnimationView recoverBeginState];
                    }
                    break;
                }
            }
        }
    }else {//如果是其他记录
        [[IMBDeviceConnection singleton].wifiDeviceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            IMBBaseInfo *baseInfo = (IMBBaseInfo *)obj;
            if ([baseInfo.uniqueKey isEqualToString:uuidKey]) {
                if (baseInfo.deviceConnectMode == WifiRecordDevice) {
                    [[IMBDeviceConnection singleton].wifiDeviceArray removeObject:baseInfo];
                }else if (baseInfo.deviceConnectMode == WifiTwoModeDevice) {
                    baseInfo.deviceConnectMode = WifiConnectDevice;
                    [baseInfo.backupRecordAryM removeAllObjects];
                }
            }
        }];
    }
}

#pragma mark - 点击选择设备
- (void)selectDeviceBackupBtnClick:(NSButton *)sender {
    if (_devPopover != nil) {
        if (_devPopover.isShown) {
            [_devPopover close];
            return;
        }
    }
    if (_devPopover != nil) {
        [_devPopover release];
        _devPopover = nil;
    }
    _devPopover = [[NSPopover alloc] init];
        
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
        _devPopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
    }else {
        _devPopover.appearance = NSPopoverAppearanceMinimal;
    }
    
    _devPopover.animates = YES;
    _devPopover.behavior = NSPopoverBehaviorTransient;
    _devPopover.delegate = self;
    _devPopoverViewController = [[IMBAirBackupPopoverViewController alloc] initWithNibName:@"IMBAirBackupPopoverViewController" bundle:nil withSelectedValue:_curBaseInfo.uniqueKey WithDevice:[IMBDeviceConnection singleton].wifiDeviceArray withConnectType:_curBaseInfo.connectType];
    if (_devPopover != nil) {
       _devPopover.contentViewController = _devPopoverViewController;
   }
    [_devPopoverViewController setTarget:self];
    [_devPopoverViewController setDelegate:self];
    [_devPopoverViewController setAction:@selector(popOverViewControllerClick:)];
    [_devPopoverViewController release];
    NSButton *targetButton = (NSButton *)sender;
    NSRectEdge prefEdge = NSMaxYEdge;
    NSRect rect = NSMakeRect(targetButton.bounds.origin.x, targetButton.bounds.origin.y, targetButton.bounds.size.width, targetButton.bounds.size.height);
    [_devPopover showRelativeToRect:rect ofView:sender preferredEdge:prefEdge];

}

#pragma mark - 切换设备
- (void)popOverViewControllerClick:(id)sender {
    IMBBaseInfo *baseInfo = nil;
    id obj = sender;
    if (obj && [obj isKindOfClass:[IMBBaseInfo class]]) {
        baseInfo = (IMBBaseInfo *)obj;
        if ([baseInfo.uniqueKey isEqualToString:_curBaseInfo.uniqueKey] && baseInfo.isSelected ) {
            [_devPopover close];
            return;
        }
        _curBaseInfo.isSelected = NO;
        _curBaseInfo = baseInfo;
        _curBaseInfo.isSelected = YES;
    }
    BOOL flag = (_curBaseInfo.deviceConnectMode == WifiRecordDevice)? NO : YES;
    [_deviceNamePopBtn configButtonName:_curBaseInfo.deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:26.0 WithOnline:flag];
    [_deviceNamePopBtn setNeedsDisplay:YES];
    if (_curBaseInfo.deviceConnectMode == WifiRecordDevice) {
        [_airBackupAnimationView endAnimation];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_curBaseInfo.backupTime longValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
        
        NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
        [dateFormatter release], dateFormatter = nil;
        [_airBackupAnimationView setBackupSize:[StringHelper getFileSizeString:[_curBaseInfo.backupSize longLongValue] reserved:2] WithBcakupDate:confromTimespStr WithRecordAry:baseInfo.backupRecordAryM];
        [_backupButton setEnabled:NO];
        [_subTitleTextView setHidden:YES];
        [_noDeviceConnectSubTitleView setHidden:NO];
    }else {
        if(_curBaseInfo.isBackuping) {
//            [_airBackupAnimationView endAnimation];
            if (!_airBackupAnimationView.isRunning) {
                [_airBackupAnimationView startAnimationWithBaseInfo:baseInfo];
            }
            
            [_backupButton setEnabled:NO];
        }else {
            [_airBackupAnimationView endAnimation];
            if (_curBaseInfo.backupRecordAryM.count > 0) {
                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_curBaseInfo.backupTime longValue]];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
                NSString *confromTimespStr = [dateFormatter stringFromDate:confromTimesp];
                [dateFormatter release], dateFormatter = nil;
                [_airBackupAnimationView setBackupSize:[StringHelper getFileSizeString:[_curBaseInfo.backupSize longLongValue] reserved:2] WithBcakupDate:confromTimespStr WithRecordAry:_curBaseInfo.backupRecordAryM];
            }else {
                [_airBackupAnimationView recoverBeginState];
            }
            
            [_backupButton setEnabled:YES];
        }
        [_subTitleTextView setHidden:NO];
        NSString *diskSize = nil;
        if ((_curBaseInfo.allDeviceSize - _curBaseInfo.kyDeviceSize) == 0) {
            diskSize = [CustomLocalizedString(@"AirBackupUseDiskCapacity", nil) stringByAppendingString:@"--"];
        }else {
            diskSize = [CustomLocalizedString(@"AirBackupUseDiskCapacity", nil) stringByAppendingString:[StringHelper getFileSizeString: (_curBaseInfo.allDeviceSize - _curBaseInfo.kyDeviceSize) reserved:2]];
        }
        
        NSString *batteryCapacity = nil;
        if (_curBaseInfo.batteryCapacity == 0) {
            batteryCapacity = [CustomLocalizedString(@"AirBackupBattery", nil) stringByAppendingString:@"--"];
        }else {
            batteryCapacity = [CustomLocalizedString(@"AirBackupBattery", nil) stringByAppendingString:[NSString stringWithFormat:@"%d%%",_curBaseInfo.batteryCapacity]];
        }
        
        NSString *promptStr = [[diskSize stringByAppendingString:@"  "]  stringByAppendingString:batteryCapacity];
        NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0] withColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:NSLeftTextAlignment];
        [mutParaStyle setLineSpacing:2.0];
        [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
        [[_subTitleTextView textStorage] setAttributedString:promptAs];
        [mutParaStyle release];
        [_noDeviceConnectSubTitleView setHidden:YES];
    }
    [self resetAirBackUpConfig];
    [_devPopover close];
    NSString *deviceNameStr = _curBaseInfo.deviceName;
    if (deviceNameStr.length >= 15) {
        deviceNameStr = [deviceNameStr substringToIndex:15];
        deviceNameStr = [deviceNameStr stringByAppendingString:@"..."];
    }
    NSString *deviceName = [NSString stringWithFormat:CustomLocalizedString(@"AirBackupOpen_Tips", nil),deviceNameStr];
    [_detailSubTitle1 setStringValue:deviceName];
    
}

#pragma mark - more backup方法
- (void)openMoreBackup:(NSNotification *)sender {
    NSDictionary *dic = (NSDictionary *)sender.userInfo;
    NSTextView *moreBackup = [dic objectForKey:@"moreBackup"];
    if (_devPopover != nil) {
        if (_devPopover.isShown) {
            [_devPopover close];
            return;
        }
    }
    if (_devPopover != nil) {
        [_devPopover release];
        _devPopover = nil;
    }
    _devPopover = [[NSPopover alloc] init];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
        _devPopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
    }else {
        _devPopover.appearance = NSPopoverAppearanceMinimal;
    }
    

    _devPopover.animates = YES;
    _devPopover.behavior = NSPopoverBehaviorTransient;
    _devPopover.delegate = self;
    _backupPopoverViewController = [[IMBBackupInfoViewController alloc] initWithDataArray:_curBaseInfo.backupRecordAryM withDelegate:self];
    if (_devPopover != nil) {
        _devPopover.contentViewController = _backupPopoverViewController;
    }
    [_backupPopoverViewController release];
    NSRectEdge prefEdge = NSMinYEdge;
    NSRect rect = NSMakeRect(moreBackup.bounds.origin.x, moreBackup.bounds.origin.y, moreBackup.bounds.size.width, moreBackup.bounds.size.height);
    [_devPopover showRelativeToRect:rect ofView:moreBackup preferredEdge:prefEdge];
}

- (void)closeMasterAirBackSwitch {
    [_airBackupAnimationView endAnimation];
    __block BOOL flag = NO;
    [[IMBDeviceConnection singleton].wifiDeviceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IMBBaseInfo *baseInfo = (IMBBaseInfo *)obj;
        if (baseInfo.deviceConnectMode == WifiConnectDevice) {
            if ([baseInfo.uniqueKey isEqualToString:_curBaseInfo.uniqueKey]) {
                flag = YES;
            }
            [[IMBDeviceConnection singleton].wifiDeviceArray removeObject:baseInfo];
        }else if (baseInfo.deviceConnectMode == WifiTwoModeDevice){
            baseInfo.deviceConnectMode = WifiRecordDevice;
        }
    }];
    int count = (int)[IMBDeviceConnection singleton].wifiDeviceArray.count;
    if (count == 0) {
        [_airBackupAnimationView recoverBeginState];
        [_switchButton setEnabled:NO];
        [_dayPopBtn selectItemWithTag:502];
        if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
            [_dayPopBtn setTitle:[@"Alle 3 " stringByAppendingString: CustomLocalizedString(@"AirBackupIntervalType_Day", nil)]];
        }else {
            [_dayPopBtn setTitle:[@"3 " stringByAppendingString: CustomLocalizedString(@"AirBackupIntervalType_Day", nil)]];
        }
        [_backupButton setEnabled:NO];
        [_deviceNamePopBtn setHidden:YES];
        [_subTitleTextView setHidden:YES];
        [_noDeviceTitle setHidden:NO];
        [_noDeviceConnectSubTitleView setHidden:NO];
        [self configNodeviceMainTitle];
    }else {
        if (flag) {//表示之前的选中设备被移除了
            IMBBaseInfo *item = [[IMBDeviceConnection singleton].wifiDeviceArray objectAtIndex:0];
            _curBaseInfo = item;
            [self popOverViewControllerClick:item];
        }else {
            [self popOverViewControllerClick:_curBaseInfo];
        }
    }
}

- (NSMutableArray *)loadDeviceHistoryBackupRecord:(NSString *)uniqueKey {
    NSMutableArray *recordAryM = [[NSMutableArray alloc] init];
    NSString *path = [[IMBHelper getBackupServerSupportConfigPath] stringByAppendingPathComponent:@"backupRecord.plist"];
    NSFileManager *_fm = [NSFileManager defaultManager];
    if ([_fm fileExistsAtPath:path]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
        if (dic != nil) {
            for (NSString *str in dic.allKeys) {
                id ary = [dic objectForKey:str];
                if ([str isEqualToString:uniqueKey]) {
                    if ([ary isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *dic in ary) {
                            if ([dic isKindOfClass:[NSDictionary class]]) {
                                IMBBaseInfo *baseInfo = [[IMBBaseInfo alloc] init];
                                baseInfo.backupSize = [dic objectForKey:@"BackupSize"];
                                baseInfo.backupTime = [dic objectForKey:@"BackupTime"];
                                baseInfo.deviceName = [dic objectForKey:@"DeviceName"];
                                baseInfo.uniqueKey = [dic objectForKey:@"SerialNumber"];
                                [recordAryM addObject:baseInfo];
                                [baseInfo release], baseInfo = nil;
                            }
                        }
                    }
                }
            }
        }
    }
    return [recordAryM autorelease];
}

#pragma mark - 切换皮肤和语言
- (void)changeSkin:(NSNotification *)notification {
    [super changeSkin:notification];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configTextAndImageAndButton];
        [self configAnnoyView];
        [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
        [_closebutton setNeedsDisplay:YES];
    });
}

- (void)doChangeLanguage:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configTextAndImageAndButton];
        [self configAnnoyView];
    });
}

- (void)dealloc {
    [_nc removeObserver:self name:NOTIFY_WIFIDEVICE_DISCONNECT object:nil];
    [_nc removeObserver:self name:NOTIFY_WIFIDEVICE_CONNECT object:nil];
    [_nc removeObserver:self name:NOTIFY_WIFIDEVICE_STARTBACKUP object:nil];
    [_nc removeObserver:self name:NOTIFY_WIFIDEVICE_BACKUP_PROGRESS object:nil];
    [_nc removeObserver:self name:NOTIFY_WIFIDEVICE_BACKUP_COMPLETE object:nil];
    [_nc removeObserver:self name:NOTIFY_WIFIDEVICE_BACKUP_ERROR object:nil];
    [_nc removeObserver:self name:NOTITY_OPEN_MOREBACKUP object:nil];
    [_nc removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [_nc removeObserver:self name:NOTIFY_BACK_MAINVIEW object:nil];
    [_nc removeObserver:self name:ANNOY_REGIST_SUCCESS object:nil];
    [_nc removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [_nc removeObserver:self name:NOTIFY_REGISTER_CHECK_FAIL object:nil];
    if (_closebutton != nil) {
        [_closebutton release];
        _closebutton = nil;
    }
    [super dealloc];
}

@end

@implementation IMBBackupRecord
@synthesize path = _path;
@synthesize name = _name;
@synthesize size = _size;
@synthesize time = _time;
@synthesize connectType = _connectType;
@synthesize encryptBackup = _encryptBackup;
- (id)init {
    if (self = [super init]) {
        _path = @"";
        _name = @"";
        _encryptBackup = NO;
    }
    return self;
}
@end
