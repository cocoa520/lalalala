//
//  DeviceInfo.h
//  
//
//  Created by JGehry on 2/6/17.
//
//

#import <Foundation/Foundation.h>
#import "IMBAdbManager.h"
//#import <IMBAndroidDevice/IMBAdbManager.h>

@interface StorageInfo : NSObject {
@private
    long long _availableSize;
    long long _totalSize;
    NSString *_storageKind;
    NSString *_storagePath;
}
/*
     *  availableSize               可用磁盘空间
     *  totalSize                   总磁盘空间
     *  storageKind                 磁盘类型
     *  storagePath                 磁盘路劲
 */

@property (nonatomic, readwrite) long long availableSize;
@property (nonatomic, readwrite) long long totalSize;
@property (nonatomic, readwrite, retain) NSString *storageKind;
@property (nonatomic, readwrite, retain) NSString *storagePath;

@end

@interface DeviceInfo : NSObject {
 @private
    NSString *_devName;
    NSString *_devModel;
    NSString *_devBaseband;
    NSString *_devKernelVersion;
    NSString *_devInternalVersion;
    NSString *_devHardwareVersion;
    NSString *_devBarCode;
    NSString *_devIpAddress;
    NSString *_devMacAddress;
    NSString *_devVersion;
    NSString *_devSerialNumber;
    NSString *_devScreenResolution;
    
    BOOL _isRoot;
    NSString *_phoneNumber;
    NSString *_deviceFirm;
    NSString *_deviceBrand;
    NSString *_imei;
    
    NSMutableArray *_storageArr;
    
    int _vendorId;
    int _productId;
    
    NSString *_pathDir;
    
 @public
    IMBAdbManager *_adbManager;
}

/**
 *  devName                     名称
 *  devModel                    型号
 *  devBaseband                 基带版本
 *  devKernelVersion            内核版本
 *  devInternalVersion          内部版本号
 *  devHardwareVersion          硬件版本
 *  devBarCode                  IMEI
 *  devIpAddress                IP地址
 *  devMacAddress               MAC地址
 *  devVersion                  设备版本号
 *  devSerialNumber             设备序列号
 *  devScreenResolution         屏幕分辨率
 
 *  pathDir                     Android设备环境变量PATH, 用于Root设备
 
 *  isRoot                      是否root
 *  phoneNumber                 设备电话号码
 *  deviceFirm
 *  deviceBrand
 *  imei
 *
 */
@property (nonatomic, readwrite, retain) NSString *devName;
@property (nonatomic, readwrite, retain) NSString *devModel;
@property (nonatomic, readwrite, retain) NSString *devBaseband;
@property (nonatomic, readwrite, retain) NSString *devKernelVersion;
@property (nonatomic, readwrite, retain) NSString *devInternalVersion;
@property (nonatomic, readwrite, retain) NSString *devHardwareVersion;
@property (nonatomic, readwrite, retain) NSString *devBarCode;
@property (nonatomic, readwrite, retain) NSString *devIpAddress;
@property (nonatomic, readwrite, retain) NSString *devMacAddress;
@property (nonatomic, readwrite, retain) NSString *devVersion;
@property (nonatomic, readwrite, retain) NSString *devSerialNumber;
@property (nonatomic, readwrite, retain) NSString *devScreenResolution;

@property (nonatomic, readwrite) BOOL isRoot;
@property (nonatomic, readwrite, retain) NSString *phoneNumber;
@property (nonatomic, readwrite, retain) NSString *deviceFirm;
@property (nonatomic, readwrite, retain) NSString *deviceBrand;
@property (nonatomic, readwrite, retain) NSString *imei;
@property (nonatomic, readwrite, retain) NSMutableArray *storageArr;
@property (nonatomic, readwrite) int vendorId;
@property (nonatomic, readwrite) int productId;
@property (nonatomic, readwrite, retain) NSString *pathDir;

- (instancetype)initwithSerialNo:(NSString *)serialNo;

@end
