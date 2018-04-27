//
//  IMBDeviceInfo.h
//  iMobieTrans
//
//  Created by Pallas on 4/1/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBCommonEnum.h"

@interface IMBDeviceInfo : NSObject {
    id _device;
@protected
    //设备信息属性
    BOOL _isIOSDevice;
    BOOL _isJailbreak;
    BOOL _isWifiConnect;
    BOOL _airSync;
    BOOL _isSyncing;
    BOOL _needHashABChkSum;
    NSString *_deviceName;
    NSString *_productVersion;
    NSString *_deviceClass;
    NSString *_firmwareVersion;
    int _familyID;
    IPodFamilyEnum _family;
    NSString *_serialNumber;
    NSString *_firewireID;
    NSString *_serialNumberForHashing;
    NSString *_productType;
    NSString *_phoneNumber;
    NSString *_uniqueChipID;
    NSString *_deviceColor;
    NSString *_activationState;
    NSString *_bluetoothAddress;
    NSString *_regionInfo;
    NSString *_simStatus;
    NSString *_timeZone;
    long _timeZoneOffsetFromUTC;
    NSString *_wifiAddress;
    BOOL _isBarreyCharging;
    int _currentCapacity;
    int64_t _availableFreeSpace;
    int64_t _totalSize;
    int64_t _totalDataAvailable;
    int64_t _totalDataCapacity;
    int64_t _totalDiskCapacity;
    int64_t _totalSystemAvailable;
    int64_t _totalSystemCapacity;
    int64_t _mobileApplicationUsage;
    
    BOOL _isShuffle;
    
    //2014-8-6
    NSString *_modelNumber;
    NSString *_buildVersion;
    NSString *_hardwareModel;
    NSString *_CPUArchitecture;
    long _activationStateAcknowledged;
    NSString *_basebandVersion;
    NSString *_basebandBootloaderVersion;
    long _basebandChipId;
    long _basebandGoldCertId;
    NSString *_integratedCircuitCardIdentity;
    NSString *_internationalMobileEquipmentIdentity;
    NSString *_internationalMobileSubscriberIdentity;
    NSString *_MLBSerialNumber;
    NSString *_mobileSubscriberCountryCode;
    NSString *_mobileSubscriberNetworkCode;
    long _passwordProtected;
    long _productionSOC;
    NSString *_protocolVersion;
    NSString *_SDIOProductInfo;
    NSString *_supportedDeviceFamilies;
    long _timeIntervalSince1970;
    
    
    // 媒体支持
    BOOL _isSupportMusic;
    BOOL _isSupportMovie;
    BOOL _isSupportPodcast;
    BOOL _isSupportVideo;
    BOOL _isSupportAudioBook;
    BOOL _isSupportMV;
    BOOL _isSupportTVShow;
    BOOL _isSupportRingtone;
    BOOL _isSupportApplication;
    BOOL _isSupportiTunesU;
    BOOL _isSupportiBook;
    BOOL _isSupportVoiceMemo;
    BOOL _isSupportPhoto;
    
    // 媒体支持的格式属性
    NSMutableArray *_artworkFormats;
    NSMutableArray *_photeFormats;
}

- (id)initWithDevice:(id)device;

@property (nonatomic, readonly) BOOL isIOSDevice;
@property (nonatomic, readonly) BOOL isJailbreak;
@property (nonatomic, getter = isWifiConnect, readonly) BOOL isWifiConnect;
@property (nonatomic, getter = airSync, readonly) BOOL airSync;
@property (nonatomic, getter = deviceName, readonly) NSString *deviceName;
@property (nonatomic, getter = productVersion, readonly) NSString *productVersion;
@property (nonatomic, getter = familyID, readonly) int familyID;
@property (nonatomic, getter = family, readonly) IPodFamilyEnum family;
@property (nonatomic, getter = deviceClass, readonly) NSString *deviceClass;
@property (nonatomic, getter = firmwareVersion, readonly) NSString *firmwareVersion;
@property (nonatomic, getter = serialNumber, readonly) NSString *serialNumber;
@property (nonatomic, getter = firewireID, readonly) NSString *firewireID;
@property (nonatomic, getter = serialNumberForHashing, readonly) NSString *serialNumberForHashing;
@property (nonatomic, getter = productType, readonly) NSString *productType;
@property (nonatomic, getter = phoneNumber, readonly) NSString *phoneNumber;
@property (nonatomic, getter = uniqueChipID, readonly) NSString *uniqueChipID;
@property (nonatomic, getter = deviceColor, readonly) NSString *deviceColor;
@property (nonatomic, getter = activationState, readonly) NSString *activationState;
@property (nonatomic, getter = bluetoothAddress, readonly) NSString *bluetoothAddress;
@property (nonatomic, getter = regionInfo, readonly) NSString *regionInfo;
@property (nonatomic, getter = simStatus, readonly) NSString *simStatus;
@property (nonatomic, getter = timeZone, readonly) NSString *timeZone;
@property (nonatomic, getter = timeZoneOffsetFromUTC, readonly) long timeZoneOffsetFromUTC;
@property (nonatomic, getter = wifiAddress, readonly) NSString *wifiAddress;
@property (nonatomic, getter = isBarreyCharging, readonly) BOOL isBarreyCharging;
@property (nonatomic, getter = currentCapacity, readonly) int currentCapacity;
@property (nonatomic, getter = availableFreeSpace, readonly) int64_t availableFreeSpace;
@property (nonatomic, getter = totalSize, readonly) int64_t totalSize;
@property (nonatomic, getter = totalDataAvailable, readonly) int64_t totalDataAvailable;
@property (nonatomic, getter = totalDataCapacity, readonly) int64_t totalDataCapacity;
@property (nonatomic, getter = totalDiskCapacity, readonly) int64_t totalDiskCapacity;
@property (nonatomic, getter = totalSystemAvailable, readonly) int64_t totalSystemAvailable;
@property (nonatomic, getter = totalSystemCapacity, readonly) int64_t totalSystemCapacity;
@property (nonatomic, getter = mobileApplicationUsage, readonly) int64_t mobileApplicationUsage;

//2014-8-6
@property (nonatomic, getter = modelNumber, readonly) NSString *modelNumber;
@property (nonatomic, getter = buildVersion, readonly) NSString *buildVersion;
@property (nonatomic, getter = hardwareModel, readonly) NSString *hardwareModel;
@property (nonatomic, getter = CPUArchitecture, readonly) NSString *CPUArchitecture;
@property (nonatomic, getter = activationStateAcknowledged, readonly) long activationStateAcknowledged;
@property (nonatomic, getter = basebandVersion, readonly) NSString *basebandVersion;
@property (nonatomic, getter = basebandBootloaderVersion, readonly) NSString *basebandBootloaderVersion;
@property (nonatomic, getter = basebandChipId, readonly) long basebandChipId;
@property (nonatomic, getter = basebandGoldCertId, readonly) long basebandGoldCertId;
@property (nonatomic, getter = integratedCircuitCardIdentity, readonly) NSString *integratedCircuitCardIdentity;
@property (nonatomic, getter = internationalMobileEquipmentIdentity, readonly) NSString *internationalMobileEquipmentIdentity;
@property (nonatomic, getter = internationalMobileSubscriberIdentity, readonly) NSString *internationalMobileSubscriberIdentity;
@property (nonatomic, getter = MLBSerialNumber, readonly) NSString *MLBSerialNumber;
@property (nonatomic, getter = mobileSubscriberCountryCode, readonly) NSString *mobileSubscriberCountryCode;
@property (nonatomic, getter = mobileSubscriberNetworkCode, readonly) NSString *mobileSubscriberNetworkCode;
@property (nonatomic, getter = passwordProtected, readonly) long passwordProtected;
@property (nonatomic, getter = productionSOC, readonly) long productionSOC;
@property (nonatomic, getter = protocolVersion, readonly) NSString *protocolVersion;
@property (nonatomic, getter = SDIOProductInfo, readonly) NSString *SDIOProductInfo;
@property (nonatomic, getter = supportedDeviceFamilies, readonly) NSString *supportedDeviceFamilies;
@property (nonatomic, getter = timeIntervalSince1970, readonly) long timeIntervalSince1970;

- (BOOL)isWifiConnect;
- (BOOL)airSync;
- (NSString*)deviceName;
- (NSString*)productVersion;
- (int)familyID;
- (IPodFamilyEnum)family;
- (NSString*)deviceClass;
- (NSString*)firmwareVersion;
- (NSString*)serialNumber;
- (NSString*)firewireID;
- (NSString*)serialNumberForHashing;
- (NSString*)productType;
- (NSString*)phoneNumber;
- (NSString*)uniqueChipID;
- (NSString*)deviceColor;
- (NSString*)activationState;
- (NSString*)bluetoothAddress;
- (NSString*)regionInfo;
- (NSString*)simStatus;
- (NSString*)timeZone;
- (long)timeZoneOffsetFromUTC;
- (NSString*)wifiAddress;
- (BOOL)isBarreyCharging;
- (int)currentCapacity;
- (int64_t)availableFreeSpace;
- (int64_t)totalSize;
- (int64_t)totalDataAvailable;
- (int64_t)totalDataCapacity;
- (int64_t)totalDiskCapacity;
- (int64_t)totalSystemAvailable;
- (int64_t)totalSystemCapacity;
- (int64_t)mobileApplicationUsage;
//得到iPad,iPhone,itouch,iPod的分类
- (NSString*)familyTypeString;
// 得到每个设备的FamilyType的字符串
- (NSString *)getIPodFamilyString;
- (NSString *)familyNewString;

//2014-8-6
- (NSString *)modelNumber;
- (NSString *)buildVersion;
- (NSString *)hardwareModel;
- (NSString *)CPUArchitecture;
- (long)activationStateAcknowledged;
- (NSString *)basebandVersion;
- (NSString *)basebandBootloaderVersion;
- (long)basebandChipId;
- (long)basebandGoldCertId;
- (NSString *)integratedCircuitCardIdentity;
- (NSString *)internationalMobileEquipmentIdentity;
- (NSString *)internationalMobileSubscriberIdentity;
- (NSString *)MLBSerialNumber;
- (NSString *)mobileSubscriberCountryCode;
- (NSString *)mobileSubscriberNetworkCode;
- (long)passwordProtected;
- (long)productionSOC;
- (NSString *)protocolVersion;
- (NSString *)SDIOProductInfo;
- (NSString *)supportedDeviceFamilies;
- (long)timeIntervalSince1970;

- (int64_t)availableFreeSpaceWithOutRefresh;

@property (nonatomic, getter = needHashABChkSum, readonly) BOOL needHashABChkSum;
@property (nonatomic, getter = isShuffle, readonly) BOOL isShuffle;
@property (nonatomic, getter = isSupportMusic, readonly) BOOL isSupportMusic;
@property (nonatomic, getter = isSupportMovie, readonly) BOOL isSupportMovie;
@property (nonatomic, getter = isSupportPodcast, readonly) BOOL isSupportPodcast;
@property (nonatomic, getter = isSupportVideo, readonly) BOOL isSupportVideo;
@property (nonatomic, getter = isSupportAudioBook, readonly) BOOL isSupportAudioBook;
@property (nonatomic, getter = isSupportMV, readonly) BOOL isSupportMV;
@property (nonatomic, getter = isSupportTVShow, readonly) BOOL isSupportTVShow;
@property (nonatomic, getter = isSupportRingtone, readonly) BOOL isSupportRingtone;
@property (nonatomic, getter = isSupportiTunesU, readonly) BOOL isSupportiTunesU;
@property (nonatomic, getter = isSupportiBook, readonly) BOOL isSupportiBook;
@property (nonatomic, getter = isSupportVoiceMemo, readonly) BOOL isSupportVoiceMemo;
@property (nonatomic, getter = isSupportPhoto, readonly) BOOL isSupportPhoto;
@property (nonatomic, getter = isSupportApplication, readonly) BOOL isSupportApplication;
//- (void)reloadName;
- (BOOL)needHashABChkSum;
- (BOOL)isShuffle;
- (BOOL)isSupportMusic;
- (BOOL)isSupportMovie;
- (BOOL)isSupportPodcast;
- (BOOL)isSupportVideo;
- (BOOL)isSupportAudioBook;
- (BOOL)isSupportMV;
- (BOOL)isSupportTVShow;
- (BOOL)isSupportRingtone;
- (BOOL)isSupportiTunesU;
- (BOOL)isSupportiBook;
- (BOOL)isSupportPhoto;
- (BOOL)isSupportApplication;
- (BOOL)isSupportHomeVideo;
- (BOOL)isiPhone;
- (BOOL)isiPad;
- (BOOL)isiPod;
- (BOOL)isiPodnano;
- (BOOL)isiPodShuffle;
- (BOOL)isiPodClassic;
//只返回大版本号 如ios7.1.1则返回7
- (int)getDeviceVersionNumber;
- (NSString *)getDeviceFloatVersionNumber;
@property (nonatomic, readonly) NSMutableArray *supportedArtworkFormats;
@property (nonatomic, readonly) NSMutableArray *supportedPhoteFormats;

- (void)getDeviceSupportArtworkFormats;

@end
