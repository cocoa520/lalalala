//
//  IMBAMDeviceInfo.h
//  iMobieTrans
//
//  Created by Pallas on 4/1/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBDeviceInfo.h"
#import "MobileDeviceAccess.h"

@interface IMBAMDeviceInfo : IMBDeviceInfo {
    NSDictionary *deviceBaseInfo;
    BOOL _isJailBreak;
}

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
- (void)reloadName;
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

- (void)getDeviceSupportArtworkFormats;

- (int64_t)availableFreeSpaceWithOutRefresh;

@end
