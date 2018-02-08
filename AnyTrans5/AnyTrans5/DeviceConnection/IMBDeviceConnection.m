//
//  IMBDeviceConnection.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-12.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBDeviceConnection.h"
#include "NSString+Category.h"
#import "SystemHelper.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
#import "IMBHelper.h"
#import "IMBSocketClient.h"
@implementation IMBBaseInfo
@synthesize kyDeviceSize = _kyDeviceSize;
@synthesize allDeviceSize = _allDeviceSize ;
@synthesize uniqueKey = _uniqueKey;
@synthesize deviceName = _deviceName;
@synthesize connectType = _connectType;
@synthesize devIconName = _devIconName;
@synthesize accountiCloud = _accountiCloud;
@synthesize isLoaded = _isLoaded;
@synthesize isSelected = _isSelected;
@synthesize isConnected = _isConnected;
@synthesize isicloudView = _isicloudView;
@synthesize isiPod = _isiPod;
@synthesize isAndroid = _isAndroid;
@synthesize backupTime = _backupTime;
@synthesize backupSize = _backupSize;
@synthesize deviceConnectMode = _deviceConnectMode;
@synthesize isNowDisconnect = _isNowDisconnect;
@synthesize isBackuping = _isBackuping;
@synthesize batteryCapacity = _batteryCapacity;
@synthesize backupRecordAryM = _backupRecordAryM;
- (id)init {
    self = [super init];
    if (self) {
        _isLoaded = NO;
        _isSelected = NO;
        _isiPod = NO;
        _isAndroid = NO;
        _deviceName = nil;
        _connectType = 0;
        _kyDeviceSize = 0;
        _accountiCloud = [[NSMutableArray alloc] init];
        _backupSize = @0;
        _backupTime = @0;
        _deviceConnectMode = WifiRecordDevice;
        _isNowDisconnect = YES;
        _isBackuping = NO;
        _backupRecordAryM = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)setIsConnected:(BOOL *)isConnected
{
    if (isConnected == NULL) {
        
    }else{
        _isConnected = isConnected;
    }
}

- (BOOL)isIsConnected
{
    return *_isConnected;
}

-(void)dealloc{
    [self setAccountiCloud:nil];
    [_backupRecordAryM release], _backupRecordAryM = nil;
    [super dealloc];
}
@end

@implementation IMBDeviceConnection
@synthesize iCloudDic = _iCloudDic;
@synthesize allDevice = _allDevice;
@synthesize wifiDeviceArray = _wifiDeviceArray;
@synthesize mobileDeviceAccess = _mobileDeviceAccess;
- (id)init {
    if (self=[super init]) {
        _ipodPool = [[NSMutableDictionary alloc] init];
        _allDevice = [[NSMutableArray alloc] init];
        _iCloudDic = [[NSMutableDictionary alloc] init];
        _processingQueue = [[NSOperationQueue alloc] init];
        [_processingQueue setMaxConcurrentOperationCount:4];
        nc = [NSNotificationCenter defaultCenter];
        _logHandle = [IMBLogManager singleton];
        _wifiDeviceArray = [[NSMutableArray alloc] init];
        _servialArray = [[NSMutableArray alloc] init];
    }
	return self;
}

+ (IMBDeviceConnection*)singleton {
    static IMBDeviceConnection *_singleton = nil;
    @synchronized(self) {
		if (_singleton == nil) {
			_singleton = [[IMBDeviceConnection alloc] init];
		}
	}
	return _singleton;
}

- (NSInteger)deviceCount {
    return [_ipodPool.allKeys count];
}

- (MobileDeviceAccess *)getMobileDeviceAccess {
    return _mobileDeviceAccess;
}

- (void)addIPodByKey:(IMBiPod*)ipod ipodKey:(NSString*)ipodkey {
    if (ipod != nil && ipodkey != nil) {
        if ([self checkIPodExsit:ipodkey] == YES) {
            [_ipodPool removeObjectForKey:ipodkey];
            [_ipodPool setValue:ipod forKey:ipodkey];
        } else {
            [_ipodPool setValue:ipod forKey:ipodkey];
        }
    }
}

- (void)removeIPodByKey:(NSString*)ipodKey {
    if (ipodKey != nil) {
        if ([self checkIPodExsit:ipodKey]) {
//            IMBIPod *ipod = [_ipodPool objectForKey:ipodKey];
            // 移除对该设备保留的session文件夹
//            NSString *deviceSessionPath = [ipod.session sessionFolderPath];
//            NSFileManager *fm = [NSFileManager defaultManager];
//            if ([fm fileExistsAtPath:deviceSessionPath]) {
//                [fm removeItemAtPath:deviceSessionPath error:nil];
//            }
            
            [_ipodPool removeObjectForKey:ipodKey];
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"remove seriaNumber: %@", ipodKey]];
        }
    }
}

- (IMBiPod*)getIPodByKey:(NSString*)ipodKey {
    if ([self checkIPodExsit:ipodKey]) {
        IMBiPod *ipod = [_ipodPool valueForKey:ipodKey];
        return ipod;
    }
    return nil;
}

- (BOOL)checkIPodExsit:(NSString*)ipodKey {
    NSArray *keyArray = [_ipodPool allKeys];
    if ([keyArray containsObject:ipodKey]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray*)getOtherConnectedIPod:(NSString*)ipodKey {
    NSLog(@"iPodKey %@:",ipodKey);
    
    if (_ipodPool != nil && _ipodPool.count > 1) {
        NSMutableArray *iPodArray = [[[NSMutableArray alloc] init] autorelease];
        NSArray *keyArray = [_ipodPool allKeys];
        
        for (NSString *key in keyArray) {
            if (![key isEqualToString:ipodKey]) {
                [iPodArray addObject:[_ipodPool objectForKey:key]];
            }
        }
        return iPodArray;
    }
    return nil;
}

- (NSArray*)getConnectedIPods {
    if (_ipodPool != nil && _ipodPool.count > 0) {
        NSMutableArray *iPodArray = [[[NSMutableArray alloc] init] autorelease];
        NSArray *keyArray = [_ipodPool allKeys];
        
        for (NSString *key in keyArray) {
            [iPodArray addObject:[_ipodPool objectForKey:key]];
        }
        return iPodArray;
    }
    return nil;
}

- (IMBiPod *)getNextConnectedIpod {
    IMBiPod *ipod = nil;
    if ([self deviceCount] > 0) {
        NSArray *allKey = [_ipodPool allKeys];
        id obj = [_ipodPool objectForKey:[allKey objectAtIndex:0]];
        if (obj && [obj isKindOfClass:[IMBiPod class]]) {
            ipod = (IMBiPod *)obj;
        }else {
            ipod = nil;
        }
    }
    return ipod;
}

- (void)resConnectDevice:(am_device)dev {
    [_mobileDeviceAccess connectDevice:dev];
}

- (NSMutableArray *)getAllDevice {
    return _allDevice;
}

- (void)addDeviceByKey:(IMBBaseInfo*)baseInfo ipodKey:(NSString*)uniqueKey {
    if (baseInfo != nil && uniqueKey != nil) {
        IMBBaseInfo *oldBaseInfo = [self getDeviceByKey:uniqueKey];
        if (oldBaseInfo != nil) {
            [_allDevice removeObject:oldBaseInfo];
            [_allDevice addObject:baseInfo];
        } else {
            [_allDevice addObject:baseInfo];
        }
    }
}

- (void)removeDeviceByKey:(NSString*)uniqueKey {
    if (uniqueKey != nil) {
        IMBBaseInfo *baseInfo = [self getDeviceByKey:uniqueKey];
        if (baseInfo != nil) {
            [_allDevice removeObject:baseInfo];
        }
    }
}

- (IMBBaseInfo*)getDeviceByKey:(NSString*)uniqueKey {
    for (IMBBaseInfo *baseInfo in _allDevice) {
        if ([baseInfo.uniqueKey isEqualToString:uniqueKey]) {
            return baseInfo;
        }
    }
    return nil;
}

- (IMBiPod *)getIPodByKeyFromDevice:(NSString *)path {
    for (NSString *uniqueKey in _ipodPool.allKeys) {
        IMBiPod *ipod = [_ipodPool objectForKey:uniqueKey];
        if ([ipod.deviceHandle isEqual:path]) {
            return ipod;
        }
    }
    return nil;
}

#pragma mark - Actions
- (void)startListen {
    // 开始监听iPhone这类的消息
    _mobileDeviceAccess = [MobileDeviceAccess singleton];
    [_mobileDeviceAccess setListener:self];//此处监听iOS设备的连接
    //USB设备的连接 非iOS设备
    [self searchAllConnectedUSBIPod];
    //开始监听IPod设备的消息
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(mountNotification:) name:NSWorkspaceDidMountNotification object:nil];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(unmountNotification:) name:NSWorkspaceDidUnmountNotification object:nil];
}

- (void)stopListen {
    _mobileDeviceAccess = [MobileDeviceAccess singleton];
    [_mobileDeviceAccess stopListener];
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self name:NSWorkspaceDidMountNotification object:nil];
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self name:NSWorkspaceDidUnmountNotification object:nil];
}

- (void)searchAllConnectedUSBIPod {
    NSWorkspace  *ws = [NSWorkspace sharedWorkspace];
    NSArray  *vols = [ws mountedRemovableMedia];
    for (NSString *path in vols){
        [self mountSuccess:path];
    }
}

- (void)mountNotification:(NSNotification*)notify {
    NSDictionary *mountInfo = [notify userInfo];
    NSString *mountPath = [[mountInfo objectForKey:NSWorkspaceVolumeURLKey] path];
    [self mountSuccess:mountPath];
}

- (void)mountSuccess:(NSString *)path {
    DASessionRef session = DASessionCreate(kCFAllocatorDefault);
    const char * dir = [path UTF8String];
    CFURLRef pathRef = CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault, (void*)dir, strlen(dir), TRUE);
    DADiskRef disk = DADiskCreateFromVolumePath(kCFAllocatorDefault, session, pathRef);
    CFDictionaryRef desDic = DADiskCopyDescription(disk);
    NSDictionary *desDicA = (NSDictionary*)desDic;
    NSString *deviceModel = [desDicA objectForKey:@"DADeviceModel"];
    if (![deviceModel isNilOrEmpty] && [deviceModel isEqualToString:@"iPod"]) {
        [nc postNotificationName:DeviceConnectedNotification object:nil userInfo:nil];
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"searchAllConnectedUSBIPod, mount enter, mount path is %@, mount total size is %@, mount free size is %@", path, [SystemHelper getFileSizeString:[SystemHelper getDiskTotalSizeByPath:path] reserved:2], [SystemHelper getFileSizeString:[SystemHelper getDiskFreeSizeByPath:path] reserved:2]]];
        [_processingQueue addOperationWithBlock:^(void){
            [self createIPodByDevice:path];
        }];
        
//        IMBBaseInfo *baseInfo =[[[IMBBaseInfo alloc] init] autorelease];
//        [baseInfo setUniqueKey:path];
//        [baseInfo setDeviceName:[path lastPathComponent]];
//        [baseInfo setAllDeviceSize:[SystemHelper getDiskTotalSizeByPath:path]];
//        [baseInfo setKyDeviceSize:[SystemHelper getDiskFreeSizeByPath:path]];
//        [baseInfo setIsLoaded:YES];
//        [baseInfo setConnectType:@""];
//        [_allDevice addObject:baseInfo];
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                                  baseInfo, @"DeviceInfo"
//                                  , nil];
//        if (_allDevice.count > 1) {
//            [nc postNotificationName:DeviceBtnChangeNotification object:[NSNumber numberWithBool:YES] userInfo:userInfo];
//        }
//        [nc postNotificationName:DeviceConnectedNotification object:nil userInfo:userInfo];
    }
}

- (void)unmountNotification:(NSNotification*)notify {
    NSDictionary *mountInfo = [notify userInfo];
    NSString *mountPath = [[mountInfo objectForKey:NSWorkspaceVolumeURLKey] path];
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"unmountNotification, unmount device, path is %@", mountPath]];
    IMBiPod *ipod = [self getIPodByKeyFromDevice:mountPath];
    if (ipod) {
        [self removeDeviceByKey:ipod.uniqueKey];
        [self removeIPodByKey:ipod.uniqueKey];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  ipod.uniqueKey, @"UniqueKey"
                                  , nil];
        [nc postNotificationName:DeviceBtnChangeNotification object:[NSNumber numberWithBool:NO] userInfo:userInfo];
        [nc postNotificationName:DeviceDisConnectedNotification object:ipod.uniqueKey userInfo:nil];
    }
}


#pragma mark - MobileDeviceAccessListener
- (void)deviceConnected:(AMDevice*)device {
    //可以通过发通知 或者代理将消息返给上层
    if (device) {
        NSString *deviceSerialNumber = ((AMDevice *)device).serialNumber;
        if (deviceSerialNumber) {
            [_servialArray addObject:deviceSerialNumber];
            //发送消息到守护进程，停止该设备的wifi操作
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"USBDeviceConnect", @"MsgType", deviceSerialNumber, @"SerialNumber", nil];
            NSString *str = [IMBHelper dictionaryToJson:dic];
            [[IMBSocketClient singleton] sendData:str];
            for (IMBBaseInfo *baseInfo in _wifiDeviceArray) {
                if ([baseInfo.uniqueKey isEqualToString:deviceSerialNumber]) {
                    [baseInfo setDeviceConnectMode:WifiRecordDevice];
                    NSDictionary *userDic = @{@"BaseInfo":baseInfo};
                    //发通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_REFRESH_WIFI_VIEW object:nil userInfo:userDic];
                    break;
                }
            }
        }
        
        device.isValid = YES;
        [nc postNotificationName:DeviceConnectedNotification object:nil userInfo:nil];
        [_processingQueue addOperationWithBlock:^(void){
            sleep(2);
            if ([_servialArray containsObject:deviceSerialNumber]) {
                BOOL isWifi = [device enableWifi:YES];
                [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"ISWifi:%d",isWifi]];
                [self createIPodByDevice:device];
            }
        }];
    }else {
        NSLog(@"preSerialNumber is nil");
    }
}

- (void)deviceDisconnected:(AMDevice*)device {
    //可以通过发通知 或者代理将消息返给上层
    device.isValid = NO;
    NSString *seriaNumber = [device serialNumber];
    [self removeDeviceByKey:seriaNumber];
    [self removeIPodByKey:seriaNumber];
    if ([_servialArray containsObject:seriaNumber]) {
        [_servialArray removeObject:seriaNumber];
    }
    //发送消息到守护进程，有线连接设备断开
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"USBDeviceDisconnect", @"MsgType", seriaNumber, @"SerialNumber", nil];
    NSString *str = [IMBHelper dictionaryToJson:dic];
    [[IMBSocketClient singleton] sendData:str];
    for (IMBBaseInfo *baseInfo in _wifiDeviceArray) {
        if ([baseInfo.uniqueKey isEqualToString:seriaNumber]) {
            if (baseInfo.deviceConnectMode == WifiRecordDevice ) {
                baseInfo.deviceConnectMode = WifiTwoModeDevice;
            }
            NSDictionary *userDic = @{@"BaseInfo":baseInfo};
            //发通知
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_REFRESH_WIFI_VIEW object:nil userInfo:userDic];
            break;
        }
    }
    
//    [nc postNotificationName:NOTIFY_NO_CLICK_CAGETORY_BTN object:nil userInfo:nil];

    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              seriaNumber, @"UniqueKey"
                              , nil];
    [nc postNotificationName:DeviceBtnChangeNotification object:[NSNumber numberWithBool:NO] userInfo:userInfo];
    [nc postNotificationName:DeviceDisConnectedNotification object:seriaNumber userInfo:userInfo];
}

- (void)deviceNeedPassword:(am_device)device {
    [nc postNotificationName:DeviceNeedPasswordNotification object:(id)device userInfo:nil];
}

- (void)createIPodByDevice:(id)device {
    IMBiPod *ipod = [[IMBiPod alloc] initWithDevice:device];
    if ([device isKindOfClass:[AMDevice class]]) {
        ipod.uniqueKey = ((AMDevice *)device).serialNumber;
        BOOL isConnected = *(((AMDevice *)device).isConnected);
        if ([StringHelper stringIsNilOrEmpty:ipod.uniqueKey]||isConnected == NO) {
            return;
        }
    } else {
        ipod.uniqueKey = ipod.deviceInfo.serialNumber;
    }
    IMBBaseInfo *baseInfo =[[[IMBBaseInfo alloc] init] autorelease];
    [baseInfo setUniqueKey:ipod.uniqueKey];
    [baseInfo setDeviceName:ipod.deviceInfo.deviceName];
    [baseInfo setAllDeviceSize:ipod.deviceInfo.totalDiskCapacity];
    [baseInfo setKyDeviceSize:ipod.deviceInfo.totalDataAvailable];
    [baseInfo setIsLoaded:NO];
    if ([device isKindOfClass:[AMDevice class]]) {
        [baseInfo setIsConnected:((AMDevice *)device).isConnected];
    }
    [baseInfo setConnectType:ipod.deviceInfo.family];
    [baseInfo setIsiPod:YES];
    [_allDevice addObject:baseInfo];
    
    [self addIPodByKey:ipod ipodKey:ipod.uniqueKey];
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"add seriaNumber: %@", ipod.uniqueKey]];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              baseInfo, @"DeviceInfo"
                              , nil];
    [nc postNotificationName:DeviceIpodLoadCompleteNotification object:nil userInfo:userInfo];
}

- (BOOL)canSupportWifi {
    return NO;
}

#pragma mark - WIFI Device
- (void)addWIFIConnectDevice:(NSDictionary *)dic {
    if ([dic.allKeys containsObject:@"SerialNumber"]) {
        NSString *serialNumber = [dic objectForKey:@"SerialNumber"];
        if (![StringHelper stringIsNilOrEmpty:serialNumber]) {
            IMBBaseInfo *curBaseInfo = nil;
            BOOL flag = NO;
            for (IMBBaseInfo *baseInfo in _wifiDeviceArray) {
                if ([baseInfo.uniqueKey isEqualToString:serialNumber]) {
                    curBaseInfo = baseInfo;
                    if (curBaseInfo.deviceConnectMode == WifiRecordDevice ) {
                        curBaseInfo.deviceConnectMode = WifiTwoModeDevice;
                    }
                    flag = YES;
                    break;
                }
            }
            if (!flag) {
                curBaseInfo = [[IMBBaseInfo alloc] init];
                curBaseInfo.deviceConnectMode = WifiConnectDevice;
            }
            
            curBaseInfo.uniqueKey = serialNumber;
            if ([dic.allKeys containsObject:@"DeviceName"]) {
                [curBaseInfo setDeviceName:[dic objectForKey:@"DeviceName"]];
            }
            if ([dic.allKeys containsObject:@"DeviceType"]) {
                [curBaseInfo setConnectType:[IMBHelper family:[dic objectForKey:@"DeviceType"]]];
            }
            if ([dic.allKeys containsObject:@"DeviceTotalCapacity"]) {
                [curBaseInfo setAllDeviceSize:[[dic objectForKey:@"DeviceTotalCapacity"] longLongValue]];
            }
            if ([dic.allKeys containsObject:@"DeviceAvailableCapacity"]) {
                [curBaseInfo setKyDeviceSize:[[dic objectForKey:@"DeviceAvailableCapacity"] longLongValue]];
            }
            if ([dic.allKeys containsObject:@"BatteryCapacity"]) {
                int bat = [[dic objectForKey:@"BatteryCapacity"] intValue];
                if (bat > 0) {
                    [curBaseInfo setBatteryCapacity:bat];
                }
            }
            
            NSString *curStatus = @"";
            if ([dic.allKeys containsObject:@"CurrentStatus"]) {
                curStatus = [dic objectForKey:@"CurrentStatus"];
            }
            if (!flag || [curStatus isEqualToString:@"DeviceConnect"]) {
                if (!flag) {
                    [_wifiDeviceArray addObject:curBaseInfo];
                }
                NSDictionary *userDic = @{@"BaseInfo":curBaseInfo};
                //发通知
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_WIFIDEVICE_CONNECT object:nil userInfo:userDic];
                if (!flag) {
                    [curBaseInfo release];
                    curBaseInfo = nil;
                }
            }
            if ([curStatus isEqualToString:@"BackupStart"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_WIFIDEVICE_STARTBACKUP object:nil userInfo:@{@"BaseInfo":curBaseInfo}];
            }else if ([curStatus isEqualToString:@"Backuping"]) {
                double progress = [[dic objectForKey:@"BackupProgress"] doubleValue];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_WIFIDEVICE_BACKUP_PROGRESS object:nil userInfo:@{@"BackupProgress":[NSNumber numberWithDouble:progress], @"BaseInfo":curBaseInfo}];
            }else if ([curStatus isEqualToString:@"BackupComplete"]) {
                curBaseInfo.isNowDisconnect = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_WIFIDEVICE_BACKUP_COMPLETE object:nil userInfo:@{@"BaseInfo":curBaseInfo}];
            }else if ([curStatus isEqualToString:@"BackupError"]) {
                NSNumber *errorId = [dic objectForKey:@"ErrorId"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_WIFIDEVICE_BACKUP_ERROR object:@{@"BackUpError":curStatus, @"BaseInfo":curBaseInfo,@"ErrorId":errorId}];
            }else if ([curStatus isEqualToString:@"BackupRecord"]) {
                curBaseInfo.isNowDisconnect = NO;
                curBaseInfo.deviceConnectMode = WifiTwoModeDevice;
            }
        }
    }
}

- (void)removeWIFIConnectDevice:(NSDictionary *)dic {
    if ([dic.allKeys containsObject:@"SerialNumber"]) {
        NSString *uniqueKey = [dic objectForKey:@"SerialNumber"];
        if (uniqueKey) {
            [_wifiDeviceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                IMBBaseInfo *baseInfo = (IMBBaseInfo *)obj;
                if ([baseInfo.uniqueKey isEqualToString:uniqueKey]) {
                    if (baseInfo.isNowDisconnect) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_WIFIDEVICE_DISCONNECT object:nil userInfo:@{@"BaseInfo":baseInfo}];
                        *stop = YES;
                    }else {
                        baseInfo.deviceConnectMode = WifiRecordDevice;
                    }
                }
            }];
        }
    }
}

- (void)dealloc {
    [_iCloudDic release],_iCloudDic = nil;
    [_allDevice release],_allDevice = nil;
    [_ipodPool release],_ipodPool = nil;
    [_processingQueue release],_processingQueue = nil;
    [_wifiDeviceArray release],_wifiDeviceArray = nil;
    [_servialArray release],_servialArray = nil;
    [super dealloc];
}
@end
