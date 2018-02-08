//
//  IMBDeviceConnection.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-12.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileDeviceAccess.h"
#import "IMBiPod.h"
#import "IMBDeviceInfo.h"

typedef enum DeviceConnectMode {
    WifiRecordDevice = 0,
    WifiConnectDevice = 1,
    WifiTwoModeDevice = 2,
}DeviceConnectModeEnum;

@interface IMBBaseInfo : NSObject {
@private
    NSString *_uniqueKey;
    NSString *_deviceName;
    IPodFamilyEnum _connectType;
    NSString *_devIconName;
    NSMutableArray *_accountiCloud;
    BOOL _isLoaded;
    BOOL _isSelected;
    long long _allDeviceSize;//全部空间
    long long _kyDeviceSize;//可用空间
    int _batteryCapacity;
    
    BOOL *_isConnected;
    BOOL _isiPod;
    BOOL _isicloudView;
    BOOL _isAndroid;
    //用于WiFi记录设备
    NSNumber *_backupSize;
    NSNumber *_backupTime;
    DeviceConnectModeEnum _deviceConnectMode;//设备连接模式
    BOOL _isNowDisconnect;
    BOOL _isBackuping;//正在备份
    NSMutableArray *_backupRecordAryM;
}
@property (nonatomic, assign) int batteryCapacity;
@property (nonatomic, assign) BOOL isicloudView;
@property (nonatomic, assign) BOOL *isConnected;
@property (nonatomic, assign) long long kyDeviceSize;
@property (nonatomic, assign) long long allDeviceSize;
@property (nonatomic, retain) NSString *uniqueKey;
@property (nonatomic, readwrite, retain) NSString *deviceName;
@property (nonatomic, readwrite) IPodFamilyEnum connectType;
@property (nonatomic, readwrite, retain) NSString *devIconName;
@property (nonatomic, readwrite, retain) NSMutableArray *accountiCloud;
@property (nonatomic, readwrite) BOOL isLoaded;
@property (nonatomic, readwrite) BOOL isSelected;
@property (nonatomic, readwrite) BOOL isiPod;
@property (nonatomic, readwrite) BOOL isAndroid;
@property (nonatomic, readwrite) BOOL isNowDisconnect;
@property (nonatomic, readwrite) BOOL isBackuping;

@property (nonatomic, retain) NSNumber *backupSize;
@property (nonatomic, retain) NSNumber *backupTime;
@property (nonatomic, assign) DeviceConnectModeEnum deviceConnectMode;
@property (nonatomic, retain) NSMutableArray *backupRecordAryM;
@end

@interface IMBDeviceConnection : NSObject<MobileDeviceAccessListener>
{
@private
    NSMutableDictionary *_ipodPool;//连接设备存储的地方
    NSMutableArray *_allDevice;
    MobileDeviceAccess *_mobileDeviceAccess;
    IMBLogManager *_logHandle;
    NSNotificationCenter *nc;
    NSOperationQueue *_processingQueue;
    //存储icloud登陆的账号信息
    NSMutableDictionary *_iCloudDic;
    
    //wifi连接的设备
    NSMutableArray *_wifiDeviceArray;
    
    NSMutableArray *_servialArray;
}

@property (nonatomic, retain) MobileDeviceAccess *mobileDeviceAccess;
@property (nonatomic,retain)NSMutableDictionary *iCloudDic;
@property (nonatomic,retain)NSMutableArray *allDevice;
@property (nonatomic,retain)NSMutableArray *wifiDeviceArray;
+ (IMBDeviceConnection*)singleton;
- (void)startListen;
- (MobileDeviceAccess *)getMobileDeviceAccess;
- (NSInteger)deviceCount;
- (void)addIPodByKey:(IMBiPod*)ipod ipodKey:(NSString*)ipodkey;
- (IMBiPod*)getIPodByKey:(NSString*)ipodKey;
- (BOOL)checkIPodExsit:(NSString*)ipodKey;
- (void)removeIPodByKey:(NSString*)ipodKey;
- (NSArray*)getOtherConnectedIPod:(NSString*)ipodKey;
- (NSArray*)getConnectedIPods;
- (IMBiPod *)getNextConnectedIpod;

- (NSMutableArray *)getAllDevice;
- (void)addDeviceByKey:(IMBBaseInfo*)baseInfo ipodKey:(NSString*)uniqueKey;
- (void)removeDeviceByKey:(NSString*)uniqueKey;
- (IMBBaseInfo*)getDeviceByKey:(NSString*)uniqueKey;

- (void)resConnectDevice:(am_device)dev;
#pragma mark - WIFI Device
- (void)addWIFIConnectDevice:(NSDictionary *)dic;
- (void)removeWIFIConnectDevice:(NSDictionary *)dic;

@end
