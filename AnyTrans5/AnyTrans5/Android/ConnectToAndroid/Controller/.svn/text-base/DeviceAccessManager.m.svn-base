//
//  DeviceAccessManager.m
//  
//
//  Created by JGehry on 3/2/17.
//
//

#import "DeviceAccessManager.h"
#import <Cocoa/Cocoa.h>
#import "IMBADDevice.h"
#import "IMBNotificationDefine.h"
#import "ATTracker.h"
#import "NSString+Category.h"
#import "IMBSoftWareInfo.h"
#import "TempHelper.h"
#import "IMBDeviceConnection.h"

@implementation DeviceAccessManager
@synthesize delegate = _delegate;
@synthesize devicePool = _devicePool;
@synthesize apkPath = _apkPath;

- (void)dealloc {
#if !__has_feature(objc_arc)
    [_devicePool release],_devicePool = nil;
    [self setApkPath:nil];
    [super dealloc];
#endif
}

- (instancetype)init {
    if (self = [super init]) {
        [self startAdbManager];
        _nc = [NSNotificationCenter defaultCenter];
        _devicePool = [[NSMutableDictionary alloc] init];
        self.apkPath = [[NSBundle mainBundle] pathForResource:@"anytransservice" ofType:@"apk"];
        _listener = [IMBAndroidDevice singleton];
        [_listener startListen:self];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)startAdbManager {
    _adbManager = [IMBAdbManager singleton];
}

#pragma mark -- 判断设备信任
- (BOOL)isUnauthorizedDevice:(NSDictionary *)dict {
    BOOL res = NO;
    NSString *str = [_adbManager runADBCommand:[_adbManager connectDevices]];
    if ([str rangeOfString:@"unauthorized"].location != NSNotFound) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self deviceUnauthorizedConnected:dict];
        });
        res = YES;
    }else if ([str rangeOfString:@"device"].location != NSNotFound) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self deviceConnected:dict];
        });
        res = NO;
    }
    return res;
}

#pragma mark -- 判断设备USB模式是否打开
- (BOOL)hasOpenUSBDebugModel:(NSDictionary *)dict {
    BOOL res = NO;
    if ([_listener hasOpenUSBDebugModel]) {
        res = YES;
    }else {
        [self deviceUSBDebugModelConnected:dict];
        res = NO;
    }
    return res;
}

- (void)deviceConnectedUSBMessage {
    [_nc postNotificationName:Andriod_Device_USB_Message object:nil];
}

#pragma mark -- 设备已连接
- (void)deviceConnected:(NSDictionary *)deviceDic {
    if ([[deviceDic allKeys] containsObject:@"deviceName"]) {
        [_nc postNotificationName:Andriod_Device_Connect object:deviceDic];
    }
    
    //判断adb断开是否被占用，占用了kill，重新打开;
    NSString *retStr = [_adbManager runADBCommand:[_adbManager connectDevices]];
    if ([retStr rangeOfString:@"adb.501.log"].location != NSNotFound) {
        NSString *path = [[retStr componentsSeparatedByString:@"'"] objectAtIndex:1];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error = nil;
        BOOL result = [fm removeItemAtPath:path error:&error];
        if (result) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }else if ([retStr rangeOfString:@"failed to start daemon"].location != NSNotFound) {
        NSString *pid = [_adbManager runLsofCommand:[_adbManager checkPortOccupy]];
        NSString *cmdStr = [NSString stringWithFormat:@"kill %@",pid];
        char *cmd = (char *)[cmdStr UTF8String];
        int ret = system(cmd);
        NSLog(@"ret:%d",ret);
        [self deviceSoftwareConflictConnected:deviceDic];
    }
    NSString *serialNumber = [deviceDic objectForKey:@"serailNumber"];
    int vendor = [[deviceDic objectForKey:@"idVendor"] intValue];
    int product = [[deviceDic objectForKey:@"idProduct"] intValue];
    if (serialNumber) {
        DeviceInfo *deviceInfo = [[DeviceInfo alloc] initwithSerialNo:serialNumber];
        [deviceInfo setVendorId:vendor];
        [deviceInfo setProductId:product];
        IMBSoftWareInfo *softInfo = [IMBSoftWareInfo singleton];
        if (deviceInfo.deviceFirm && deviceInfo.devModel && deviceInfo.devVersion) {
            if ([softInfo.deviceArray count] > 0) {
                [softInfo.deviceArray removeAllObjects];
            }
            [softInfo.deviceArray addObject:deviceInfo.devVersion];
            [softInfo.deviceArray addObject:deviceInfo.devModel];
            if ([deviceInfo.deviceFirm rangeOfString:@"* daemon started successfully *"].location != NSNotFound) {
                deviceInfo.deviceFirm = [[deviceInfo.deviceFirm componentsSeparatedByString:@"* daemon started successfully *\n"] objectAtIndex:1];
            }
            [softInfo.deviceArray addObject:deviceInfo.deviceFirm];
        }
        BOOL isRet = YES;
        //检查apk是否正确
        isRet = [self checkAPKIsRight:serialNumber];
        if (isRet) {
            [_nc postNotificationName:Andriod_Device_ApkRunning object:nil];
            //查询设备详细信息
            IMBAndroid *android = [[IMBAndroid alloc] initWithDeviceInfo:deviceInfo];
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                NSMutableDictionary *dimensionMutDict = [[[NSMutableDictionary alloc] init] autorelease];
                dimensionMutDict = [TempHelper customDimension];
                [dimensionMutDict setObject:deviceInfo.devVersion forKey:@"cd1"];
                [dimensionMutDict setObject:deviceInfo.devModel forKey:@"cd2"];
                [dimensionMutDict setObject:deviceInfo.deviceFirm forKey:@"cd3"];
                dimensionDict = [dimensionMutDict copy];
            }
            [ATTracker event:Android_Connect action:ActionNone actionParams:deviceInfo.deviceFirm label:LabelNone transferCount:0 screenView:@"Move To iOS" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            NSString *devVersion = [deviceInfo devVersion];
            if ([devVersion isGreaterThan:@"5.0"]) {
                NSString *displayPowerStr = [_adbManager runADBCommand:[_adbManager checkScreenOnState:deviceInfo.devSerialNumber]];
                if ([displayPowerStr rangeOfString:@"Display Power: state=ON"].location != NSNotFound) {
                    [_adbManager runADBCommand:[_adbManager backHomeScreen:deviceInfo.devSerialNumber]];
                }else if ([displayPowerStr rangeOfString:@"Display Power: state=OFF"].location != NSNotFound) {
                    [_adbManager runADBCommand:[_adbManager wakeUpScreen:deviceInfo.devSerialNumber]];
                }
            }else if ([devVersion isGreaterThan:@"4.2.2"]) {
                NSString *displayPowerStr = [_adbManager runADBCommand:[_adbManager checkScreenOnState:deviceInfo.devSerialNumber]];
                if ([displayPowerStr rangeOfString:@"mScreenOn=true"].location != NSNotFound) {
                    [_adbManager runADBCommand:[_adbManager backHomeScreen:deviceInfo.devSerialNumber]];
                }else if ([displayPowerStr rangeOfString:@"mScreenOn=false"].location != NSNotFound) {
                    [_adbManager runADBCommand:[_adbManager wakeUpScreen:deviceInfo.devSerialNumber]];
                }
            }else if ([devVersion isGreaterThan:@"4.1.2"]) {
                NSString *displayPowerStr = [_adbManager runADBCommand:[_adbManager checkScreenOnState:deviceInfo.devSerialNumber]];
                if ([displayPowerStr rangeOfString:@"mIsPowered=true mPowerState=3"].location != NSNotFound) {
                    [_adbManager runADBCommand:[_adbManager backHomeScreen:deviceInfo.devSerialNumber]];
                }else if ([displayPowerStr rangeOfString:@"mIsPowered=true mPowerState=0"].location != NSNotFound) {
                    [_adbManager runADBCommand:[_adbManager wakeUpScreen:deviceInfo.devSerialNumber]];
                }
            }else if ([devVersion isGreaterThan:@"3.2"]) {
                NSString *displayPowerStr = [_adbManager runADBCommand:[_adbManager checkScreenOnState:deviceInfo.devSerialNumber]];
                if ([displayPowerStr rangeOfString:@"Display Power: state=ON"].location != NSNotFound) {
                    [_adbManager runADBCommand:[_adbManager backHomeScreen:deviceInfo.devSerialNumber]];
                }else if ([displayPowerStr rangeOfString:@"Display Power: state=OFF"].location != NSNotFound) {
                    [_adbManager runADBCommand:[_adbManager wakeUpScreen:deviceInfo.devSerialNumber]];
                }
            }
            NSLog(@"query Device complete result before");
            int result = [self queryDeviceDetailInfo:android];
            NSLog(@"query Device complete result after = %d", result);
            [self addAndroidByKey:android deviceKey:serialNumber];
            if (result == 0) {
                IMBBaseInfo *baseInfo =[[[IMBBaseInfo alloc] init] autorelease];
                [baseInfo setUniqueKey:android.deviceInfo.devSerialNumber];
                [baseInfo setDeviceName:android.deviceInfo.devName];
                [baseInfo setConnectType:general_Android];
                if (android.deviceInfo.storageArr.count > 0) {
                    StorageInfo *storageInfo =[android.deviceInfo.storageArr objectAtIndex:0];
                    [baseInfo setAllDeviceSize:storageInfo.totalSize];
                    [baseInfo setKyDeviceSize:storageInfo.availableSize];
                }
                [baseInfo setIsAndroid:YES];
                [baseInfo setIsLoaded:NO];
//                    [baseInfo setConnectType:android.deviceInfo.devModel];
                [[IMBDeviceConnection singleton].allDevice addObject:baseInfo];
                
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                          baseInfo, @"DeviceInfo"
                                          , nil];
                [_nc postNotificationName:Andriod_Device_Connect_Complete object:android userInfo:userInfo];
            }else {
                if (deviceInfo.deviceFirm) {
                    NSDictionary *dimensionDict = nil;
                    @autoreleasepool {
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:Android_Connect action:ActionNone actionParams:[NSString stringWithFormat:@"%@#%@", deviceInfo.deviceFirm, CustomLocalizedString(@"UNABLE_READ_DEVICEINFO", nil)] label:LabelNone transferCount:1 screenView:@"Move To iOS" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                }
                //获取设备信息失败;
                [_nc postNotificationName:Andriod_Device_Connect_Error object:CustomLocalizedString(@"UNABLE_READ_DEVICEINFO", nil)];
            }
            [android release];
        }else {
            if (deviceInfo.deviceFirm) {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:Android_Connect action:ActionNone actionParams:[NSString stringWithFormat:@"%@#%@", deviceInfo.deviceFirm, _installError] label:LabelNone transferCount:1 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
            }
            //连接设备失败；
            //                    NSString *errMsg = @"APK Install is Failed";
            [_nc postNotificationName:Andriod_Device_Connect_Error object:_installError];
        }
        [deviceInfo release];
    }else {
        NSLog(@"serialnumber is nil");
        //连接设备失败；
        [_nc postNotificationName:Andriod_Device_Connect_Error object:CustomLocalizedString(@"UNABLE_READ_DEVICEINFO", nil)];
    }
}

- (void)deviceUnauthorizedConnected:(NSDictionary *)deviceDic {
    NSString *msg = nil;
    if ([[deviceDic allKeys] containsObject:@"deviceName"]) {
        id obj = [deviceDic objectForKey:@"deviceName"];
        if (obj && [obj isMemberOfClass:[NSString class]]) {
            msg = (NSString*)obj;
            msg = [NSString stringWithFormat:@"请信任%@设备", msg];
        }else {
            msg = @"请信任Android设备";
        }
    }
    
    [_nc postNotificationName:Andriod_Device_Connect_Unauthorized object:msg userInfo:deviceDic];
}

- (void)deviceUSBDebugModelConnected:(NSDictionary *)deviceDic {
    NSString *msg = @"请打开USB调试模式";
    [_nc postNotificationName:Andriod_Device_Connect_Debugging object:msg userInfo:deviceDic];
}

- (void)setIsDevicePause:(BOOL)isPause {
    if (_listener.isDevicePause != isPause) {
        _listener.isDevicePause = isPause;
        if (!isPause) {
            [_listener.deviceCondition lock];
            [_listener.deviceCondition signal];
            [_listener.deviceCondition unlock];
        }
    }
}

#pragma mark -- 设备已断开
- (void)deviceDisconnected:(NSDictionary *)deviceDic {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int vendor = [[deviceDic objectForKey:@"idVendor"] intValue];
        int product = [[deviceDic objectForKey:@"idProduct"] intValue];
        NSString *serialNo = [deviceDic objectForKey:@"serailNumber"];
        NSArray *array = [self getConnectedAndroid];
        if (array.count > 0) {
            int i = 0;
            for (IMBAndroid *android in array) {
                if (android.deviceInfo.vendorId == vendor && android.deviceInfo.productId == product) {
                    i++;
                    NSLog(@"connectcount :%d",i);
                    [self removeAndroidByKey:android.deviceInfo.devSerialNumber];
                    [[IMBDeviceConnection singleton] removeDeviceByKey:android.deviceInfo.devSerialNumber];
                    [_nc postNotificationName:Andriod_Device_Disconnect object:android.deviceInfo.devSerialNumber];
                    break;
                }else {
                    [_nc postNotificationName:Andriod_Device_Disconnect object:serialNo];
                    break;
                }
            }
        }else {
            [_nc postNotificationName:Andriod_Device_Disconnect object:serialNo];
        }
    });
}

- (void)deviceSoftwareConflictConnected:(NSDictionary *)deviceDic {
    NSString *msg = @"";//软件冲突，请关闭同类软件
    [_nc postNotificationName:Andriod_Device_Connect_Software_Conflict object:msg userInfo:deviceDic];
}

- (BOOL)checkIsInstallApk:(NSString *)serialNo {
    BOOL res = NO;
    NSString *str = [_adbManager runADBCommand:[_adbManager isInstallerAPK:_adbManager.packageName withSerialNo:serialNo]];
    if (![str isEqualToString:@""]) {
        int i = 10;
        while (i--) {
            if (![str contains:@"Error: Could not access the Package Manager"]) {
                break;
            }
            sleep(10);
            str = [_adbManager runADBCommand:[_adbManager isInstallerAPK:_adbManager.packageName withSerialNo:serialNo]];
        }
        res = YES;
    }
    return res;
}

- (void)checkIsNormalDevice:(NSDictionary *)deviceDic {
    int vendor = [[deviceDic objectForKey:@"idVendor"] intValue];
    int product = [[deviceDic objectForKey:@"idProduct"] intValue];
    NSString *vendorStr = [IMBAdbManager findVendor:vendor withProductID:product];
    NSString *productStr = [IMBAdbManager findProduct:vendor withProductID:product];
    NSString *deviceNameAndModel = [NSString stringWithFormat:@"%@__%@", vendorStr, productStr];
    NSLog(@"%@", deviceNameAndModel);
}

#pragma mark -- 检查APK是否正确
- (BOOL)checkAPKIsRight:(NSString *)serialStr {
    BOOL isRet = YES;
    //检查当前设备是否已安装Apk
    if (![self checkIsInstallApk:serialStr]) {
        isRet = [self installAPK:serialStr];
    }else {
        //检查apk是否需要更新,用版本号判断；
        IMBAdbManager *adbManager = [IMBAdbManager singleton];
        //获取设备上安装的apk信息
        NSArray *adbArray = [adbManager getAPKVersion:serialStr withPackageName:adbManager.packageName];
        NSString *packageInfo = [adbManager runADBCommand:adbArray];
        NSArray *packageArr = [packageInfo componentsSeparatedByString:@"\n"];
        NSString *packageVersion = nil;
        for (NSString *packStr in packageArr) {
            if ([packStr rangeOfString:@"versionName"].location != NSNotFound) {
                packageVersion = [packStr stringByReplacingOccurrencesOfString:@"versionName=" withString:@""];
                packageVersion = [packageVersion stringByReplacingOccurrencesOfString:@" " withString:@""];
                packageVersion = [packageVersion stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"packageVersion:%@",packageVersion]];
                break;
            }
        }
        
        //获取本地的apk信息
        NSArray *localArr = [adbManager localAPKVersion:_apkPath];
        NSString *localInfo = [adbManager runAAPTCommand:localArr];
        NSArray *infoArr = [localInfo componentsSeparatedByString:@"\n"];
        NSString *infoStr = [infoArr objectAtIndex:0];
        NSArray *firstArr = [infoStr componentsSeparatedByString:@" "];
        NSString *localVersion = nil;
        for (NSString *str in firstArr) {
            if ([str rangeOfString:@"versionName"].location != NSNotFound) {
                localVersion = [str stringByReplacingOccurrencesOfString:@"versionName='" withString:@""];
                localVersion = [localVersion stringByReplacingOccurrencesOfString:@"'" withString:@""];
                [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"localVersion:%@",localVersion]];
                break;
            }
        }
        
        if ([localVersion isVersionMajor:packageVersion]) {
            //先要卸载
            [self uninstallAPK];

            //重新安装APK ;
            isRet = [self installAPK:serialStr];
        }
    }
    return isRet;
}

#pragma mark -- APK安装
- (BOOL)installAPK:(NSString *)serialNumber {
    [_nc postNotificationName:Andriod_Device_ApkInstall object:nil];
    BOOL ret = NO;
    NSString *str = [_adbManager runADBCommand:[_adbManager installAPK:_apkPath withSerialNo:serialNumber]];
    NSLog(@"Install Info:\n%@", str);
    if ([IMBHelper stringIsNilOrEmpty:str] || [str rangeOfString:@"Success"].location != NSNotFound || [str rangeOfString:@"connect failed: device"].location != NSNotFound) {
        ret = YES;
    }else if ([str rangeOfString:@"INSTALL_CANCELED_BY_USER"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_CANCELED_BY_USER", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_USER_RESTRICTED"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_USER_RESTRICTED", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_INVALID_APK"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_INVALID_APK", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_INVALID_URI"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_INVALID_URI", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_INSUFFICIENT_STORAGE"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_INSUFFICIENT_STORAGE", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_DUPLICATE_PACKAGE"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_DUPLICATE_PACKAGE", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_NO_SHARED_USER"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_NO_SHARED_USER", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_UPDATE_INCOMPATIBLE"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_UPDATE_INCOMPATIBLE", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_SHARED_USER_INCOMPATIBLE"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_SHARED_USER_INCOMPATIBLE", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_MISSING_SHARED_LIBRARY"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_MISSING_SHARED_LIBRARY", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_REPLACE_COULDNT_DELETE"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_REPLACE_COULDNT_DELETE", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_DEXOPT"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_DEXOPT", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_OLDER_SDK"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_OLDER_SDK", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_CONFLICTING_PROVIDER"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_CONFLICTING_PROVIDER", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_NEWER_SDK"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_NEWER_SDK", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_TEST_ONLY"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_TEST_ONLY", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_CPU_ABI_INCOMPATIBLE"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_CPU_ABI_INCOMPATIBLE", nil);
        ret = NO;
    }else if ([str rangeOfString:@"CPU_ABIINSTALL_FAILED_MISSING_FEATURE"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"CPU_ABIINSTALL_FAILED_MISSING_FEATURE", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_CONTAINER_ERROR"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_CONTAINER_ERROR", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_INVALID_INSTALL_LOCATION"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_INVALID_INSTALL_LOCATION", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_MEDIA_UNAVAILABLE"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_MEDIA_UNAVAILABLE", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_FAILED_INTERNAL_ERROR"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_FAILED_INTERNAL_ERROR", nil);
        ret = NO;
    }else if ([str rangeOfString:@"INSTALL_PARSE_FAILED_BAD_MANIFEST"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"INSTALL_PARSE_FAILED_BAD_MANIFEST", nil);
        ret = NO;
    }else if ([str rangeOfString:@"UNINSTALL_APK_ERROR"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"UNINSTALL_APK_ERROR", nil);
        ret = NO;
    }else if ([str rangeOfString:@"ALLOW_INSTALL_APK"].location != NSNotFound) {
        _installError = CustomLocalizedString(@"ALLOW_INSTALL_APK", nil);
        ret = NO;
    }else {//INSTALL_CANCELED_BY_USER
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"Install Application:%@", str]];
        _installError = CustomLocalizedString(@"DEFAULT", nil);
        ret = NO;
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if (ret) {
        [ATTracker event:Android_Connect action:ActionNone actionParams:@"Success" label:LabelNone transferCount:3 screenView:@"Move To iOS" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }else {
        [ATTracker event:Android_Connect action:ActionNone actionParams:[NSString stringWithFormat:@"Failed: %@", _installError] label:LabelNone transferCount:3 screenView:@"Move To iOS" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    return ret;
}

#pragma mark -- APK卸载
- (BOOL)uninstallAPK {
    BOOL res = NO;
    NSString *str = [_adbManager runADBCommand:[_adbManager unInstallAPK:_adbManager.packageName withSerialNo:nil]];
    if (str == nil || [str isEqualToString:@""]) {
        [[IMBLogManager singleton] writeInfoLog:@"UnInstall Application no result info. return false;"];
        res = NO;
    }else if ([str rangeOfString:@"Success"].location != NSNotFound) {
        res = YES;
    }else {
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"UnInstall Application:%@" ,str]];
        res = NO;
    }
    return res;
}

#pragma mark -- 查询设备详细信息
- (int)queryDeviceDetailInfo:(IMBAndroid *)android {
    int ret = 0;
    [_adbManager runADBCommand:[_adbManager forceStopIntentWithSerialNo:android.deviceInfo.devSerialNumber]];
    [_adbManager runADBCommand:[_adbManager clearServiceLogcat:android.deviceInfo.devSerialNumber]];
    [_adbManager runADBCommand:[_adbManager startIntent:android.deviceInfo.devSerialNumber]];
    [_adbManager runGrepCommand:[_adbManager checkServiceIsRunning:android.deviceInfo.devSerialNumber]];//检查apk服务是否启动成功，会阻塞等待
    
    //与服务器进行3次握手操作
    int i = 3;
    BOOL isSuccess = NO;
    while (i--) {
        if ([android.adPermisson shakehandApk]) {
            isSuccess = YES;
            break;
        }
    }
    
    ret = [android queryDeviceDetailInfo];
    if (isSuccess) {
        
    }else {
        ret = -9;
        [[IMBLogManager singleton] writeInfoLog:@"shakehand failed"];
    }
    return ret;
}

#pragma mark - 获取设备方法
- (NSInteger)deviceCount {
    return [_devicePool.allKeys count];
}

- (void)addAndroidByKey:(IMBAndroid *)android deviceKey:(NSString*)deviceKey {
    if (android != nil && deviceKey != nil) {
        if ([self checkAndroidExsit:deviceKey] == YES) {
            [_devicePool removeObjectForKey:deviceKey];
            [_devicePool setValue:android forKey:deviceKey];
        } else {
            [_devicePool setValue:android forKey:deviceKey];
        }
    }
}

- (void)removeAndroidByKey:(NSString*)deviceKey {
    if (deviceKey != nil) {
        if ([self checkAndroidExsit:deviceKey]) {
            [_devicePool removeObjectForKey:deviceKey];
        }
    }
}

- (IMBAndroid *)getAndroidByKey:(NSString*)deviceKey {
    if ([self checkAndroidExsit:deviceKey]) {
        IMBAndroid *android = [_devicePool valueForKey:deviceKey];
        return android;
    }
    return nil;
}

- (BOOL)checkAndroidExsit:(NSString*)deviceKey {
    NSArray *keyArray = [_devicePool allKeys];
    if ([keyArray containsObject:deviceKey]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray*)getOtherConnectedAndroid:(NSString*)deviceKey {
    if (_devicePool != nil && _devicePool.count > 1) {
        NSMutableArray *deviceArray = [[[NSMutableArray alloc] init] autorelease];
        NSArray *keyArray = [_devicePool allKeys];
        
        for (NSString *key in keyArray) {
            if (![key isEqualToString:deviceKey]) {
                [deviceArray addObject:[_devicePool objectForKey:key]];
            }
        }
        return deviceArray;
    }
    return nil;
}

- (NSArray*)getConnectedAndroid {
    if (_devicePool != nil && _devicePool.count > 0) {
        NSMutableArray *deviceArray = [[[NSMutableArray alloc] init] autorelease];
        NSArray *keyArray = [_devicePool allKeys];
        
        for (NSString *key in keyArray) {
            [deviceArray addObject:[_devicePool objectForKey:key]];
        }
        return deviceArray;
    }
    return nil;
}

- (IMBAndroid *)getNextConnectedAndroid {
    IMBAndroid *andriod = nil;
    if ([self deviceCount] > 0) {
        NSArray *allKey = [_devicePool allKeys];
        andriod = [_devicePool objectForKey:[allKey objectAtIndex:0]];
    }
    return andriod;
}

@end
