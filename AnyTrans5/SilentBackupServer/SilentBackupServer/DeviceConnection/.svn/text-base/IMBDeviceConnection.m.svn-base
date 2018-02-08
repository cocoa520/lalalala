//
//  IMBDeviceConnection.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-12.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBDeviceConnection.h"
#include "NSString+Category.h"
#import "IMBHelper.h"
#import "IMBNotificationDefine.h"

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
    [super dealloc];
}
@end

@implementation IMBDeviceConnection
@synthesize iCloudDic = _iCloudDic;
@synthesize allDevice = _allDevice;
@synthesize mobileDeviceAccess = _mobileDeviceAccess;
@synthesize conArray = _conArray;
- (id)init {
    if (self=[super init]) {
        _ipodPool = [[NSMutableDictionary alloc] init];
        _allDevice = [[NSMutableArray alloc] init];
        _iCloudDic = [[NSMutableDictionary alloc] init];
        _processingQueue = [[NSOperationQueue alloc] init];
        [_processingQueue setMaxConcurrentOperationCount:4];
        nc = [NSNotificationCenter defaultCenter];
        _logHandle = [IMBLogManager singleton];
        _servialArray = [[NSMutableArray alloc] init];
        _conArray = [[NSMutableArray alloc] init];
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

- (NSInteger)deviceCount
{
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
}

- (void)stopListen {
    _mobileDeviceAccess = [MobileDeviceAccess singleton];
    [_mobileDeviceAccess stopListener];
}

#pragma mark - MobileDeviceAccessListener
- (void)deviceConnected:(AMDevice*)device {
    //可以通过发通知 或者代理将消息返给上层
    if (device) {
        NSString *deviceSerialNumber = ((AMDevice *)device).serialNumber;
        if (deviceSerialNumber) {
//            [_ipodPool setValue:@"preSerialNumber" forKey:deviceSerialNumber];
            [_servialArray addObject:deviceSerialNumber];
            BOOL isUSB = NO;
            if ([IMBHelper appIsRunningWithBundleIdentifier:@"com.imobie.AnyTrans"]) {
                for (NSString *serinalNumber in _conArray) {
                    if ([serinalNumber isEqualToString:deviceSerialNumber]) {
                        isUSB = YES;
                        break;
                    }
                }
            }
            if (!isUSB && device.deviceName) {
                [nc postNotificationName:DeviceConnectedNotification object:device userInfo:nil];
            }
        }
        device.isValid = YES;
//        [_processingQueue addOperationWithBlock:^(void){
//            sleep(2);
            if ([_servialArray containsObject:deviceSerialNumber]) {
                [self createIPodByDevice:device];
            }
//        }];
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
    [nc postNotificationName:DeviceDisConnectedNotification object:seriaNumber userInfo:nil];
}

- (void)deviceNeedPassword:(am_device)device {
    [nc postNotificationName:DeviceNeedPasswordNotification object:(id)device userInfo:nil];
}

- (void)createIPodByDevice:(id)device {
    IMBiPod *ipod = [[IMBiPod alloc] initWithDevice:device];
    if ([device isKindOfClass:[AMDevice class]]) {
        ipod.uniqueKey = ((AMDevice *)device).serialNumber;
    } else {
        ipod.uniqueKey = ipod.deviceInfo.serialNumber;
    }
    [self addIPodByKey:ipod ipodKey:ipod.uniqueKey];
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"add seriaNumber: %@", ipod.uniqueKey]];
    
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
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:baseInfo, @"DeviceInfo", nil];
    
    [nc postNotificationName:DeviceIpodLoadCompleteNotification object:nil userInfo:userInfo];
}

- (BOOL)canSupportWifi {
    return YES;
}

- (void)dealloc {
    [_conArray release],_conArray = nil;
    [_iCloudDic release],_iCloudDic = nil;
    [_allDevice release],_allDevice = nil;
    [_ipodPool release],_ipodPool = nil;
    [_processingQueue release],_processingQueue = nil;
    [_servialArray release],_servialArray = nil;
    [super dealloc];
}
@end
