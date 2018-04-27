//
//  IMBDeviceConnection.h
//  iOSFiles
//
//  Created by iMobie on 18/1/16.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileDeviceAccess.h"
#import "IMBAMDeviceInfo.h"
#import "IMBDriveBaseManage.h"
#import "iCloudDrive.h"
#import "Dropbox.h"
typedef enum DeviceConnectMode {
    WifiRecordDevice = 0,
    WifiConnectDevice = 1,
    WifiTwoModeDevice = 2,
}DeviceConnectModeEnum;

#pragma mark -- IMBBaseInfo  Class

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
    ChooseLoginModelEnum _chooseModelEnum;
    IMBDriveBaseManage *_driveBaseManage;
    Dropbox *_dropBox;
    iCloudDrive *_iCloudDrive;
    NSImage *_leftImage;
    NSImage *_leftHoverImage;
}
@property (nonatomic, readwrite, retain) NSImage *leftHoverImage;
@property (nonatomic, readwrite, retain) NSImage *leftImage;
@property (nonatomic, readwrite, retain) iCloudDrive *iCloudDrive;
@property (nonatomic, readwrite, retain) Dropbox *dropBox;
@property (nonatomic, readwrite, retain) IMBDriveBaseManage *driveBaseManage;
@property (nonatomic, assign) ChooseLoginModelEnum chooseModelEnum;
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

#pragma mark -- IMBDeviceConnection  Class

@class IMBiPod;
@interface IMBDeviceConnection : NSObject
{
    @private
    NSMutableArray *_allDevices;
    NSMutableArray *_alliPods;
    NSMutableArray *_drviceAry;
}
@property(nonatomic, retain, readonly)NSMutableArray *drviceAry;
@property(nonatomic, retain, readonly)NSMutableArray *allDevices;
@property(nonatomic, retain, readonly)NSMutableArray *alliPods;

/**
 *  监听设备连接状态
 */
@property(nonatomic, copy)void(^IMBDeviceConnected)(void);
@property(nonatomic, copy)void(^IMBDeviceDisconnected)(NSString *serialNum);
@property(nonatomic, copy)void(^IMBDeviceNeededPassword)(am_device device);
@property(nonatomic, copy)void(^IMBDeviceConnectedCompletion)(IMBBaseInfo *baseInfo);


+ (instancetype)singleton;

/**
 *  判断当前是否有设备链接上
 *
 *  @return 是否链接
 */
- (BOOL)isConnectedDevice;

/**
 *  开始监听和注销监听
 */
- (void)startListening;
- (void)stopListening;
/**
 *  重新链接设备
 *
 *  @param dev dev
 */
- (void)reConnectDevice:(am_device)dev;
/**
 *  通过key获取iPod
 *
 *  @param key eky
 *
 *  @return iPod
 */
- (IMBiPod *)getiPodByKey:(NSString *)key;
/**
 *  根据serialNum获取已连接设备
 *
 *  @param key serialNum
 *
 *  @return 基本设备信息
 */
- (IMBBaseInfo *)getDeviceByKey:(NSString *)key;

/**
 *  根据serialNum删除设备
 *
 *  @param key serialNum
 */
- (void)removeDeviceByKey:(NSString *)key;

@end
