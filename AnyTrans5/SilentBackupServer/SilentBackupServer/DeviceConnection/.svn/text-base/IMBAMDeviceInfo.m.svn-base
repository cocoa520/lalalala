//
//  IMBAMDeviceInfo.m
//  iMobieTrans
//
//  Created by Pallas on 4/1/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBAMDeviceInfo.h"

@implementation IMBAMDeviceInfo
- (id)initWithDevice:(id)device {
    self = [super initWithDevice:device];
    if (self) {
        AFCRootDirectory *rootDic = [_device newAFCRootDirectory];
        if (rootDic != nil) {
            _isJailbreak = YES;
        } else {
            _isJailbreak = NO;
        }
        _isIOSDevice = YES;
        [self getDeviceBaseInfo];
        [self family];
    }
    return self;
}

- (void)dealloc {
    [deviceBaseInfo release],deviceBaseInfo = nil;
    [super dealloc];
}

- (void)reloadName
{
    if (deviceBaseInfo != nil) {
        [deviceBaseInfo release];
        deviceBaseInfo = nil;
    }
    if (_deviceName != nil) {
        [_deviceName release];
        _deviceName = nil;
    }
    deviceBaseInfo = [[(AMDevice*)_device getDeviceInfo] retain];
    _deviceName = [(NSString*)[deviceBaseInfo objectForKey:@"DeviceName"] retain];
}

- (void)getDeviceBaseInfo {
    deviceBaseInfo = [[(AMDevice*)_device getDeviceInfo] retain];
    _deviceName = [(NSString*)[deviceBaseInfo objectForKey:@"DeviceName"] retain];
    _airSync = [[deviceBaseInfo objectForKey:@"AirSync"] longValue];
    _productVersion = (NSString*)[deviceBaseInfo objectForKey:@"ProductVersion"];
    _deviceClass = (NSString*)[deviceBaseInfo objectForKey:@"DeviceClass"];
    _firmwareVersion = (NSString*)[deviceBaseInfo objectForKey:@"FirmwareVersion"];
    _serialNumber = (NSString*)[deviceBaseInfo objectForKey:@"SerialNumber"];
    _firewireID = (NSString*)[deviceBaseInfo objectForKey:@"FirewireID"];
    _serialNumberForHashing = (NSString*)[deviceBaseInfo objectForKey:@"SerialNumberForHashing"];
    _productType = (NSString*)[deviceBaseInfo objectForKey:@"ProductType"];
    _phoneNumber = (NSString*)[deviceBaseInfo objectForKey:@"PhoneNumber"];
    _uniqueChipID = (NSString*)[deviceBaseInfo objectForKey:@"UniqueDeviceID"];
    _deviceColor = (NSString*)[deviceBaseInfo objectForKey:@"DeviceColor"];
    _activationState = (NSString*)[deviceBaseInfo objectForKey:@"ActivationState"];
    _bluetoothAddress = (NSString*)[deviceBaseInfo objectForKey:@"BluetoothAddress"];
    _regionInfo = (NSString*)[deviceBaseInfo objectForKey:@"RegionInfo"];
    _simStatus = (NSString*)[deviceBaseInfo objectForKey:@"SIMStatus"];
    _timeZone = (NSString*)[deviceBaseInfo objectForKey:@"TimeZone"];
    _timeZoneOffsetFromUTC = [[deviceBaseInfo objectForKey:@"TimeZoneOffsetFromUTC"] longValue];
    _wifiAddress = (NSString*)[deviceBaseInfo objectForKey:@"WiFiAddress"];
    //2014-8-6
    _modelNumber = (NSString*)[deviceBaseInfo objectForKey:@"ModelNumber"];
    _buildVersion = (NSString*)[deviceBaseInfo objectForKey:@"BuildVersion"];
    _hardwareModel = (NSString*)[deviceBaseInfo objectForKey:@"HardwareModel"];
    _CPUArchitecture = (NSString*)[deviceBaseInfo objectForKey:@"CPUArchitecture"];
    _basebandVersion = (NSString*)[deviceBaseInfo objectForKey:@"BasebandVersion"];
    _basebandBootloaderVersion = (NSString*)[deviceBaseInfo objectForKey:@"BasebandBootloaderVersion"];
    _basebandChipId = [[deviceBaseInfo objectForKey:@"BasebandChipId"] longValue];
    _basebandGoldCertId = (long)[[deviceBaseInfo objectForKey:@"BasebandGoldCertId"] longValue];
    _integratedCircuitCardIdentity = (NSString*)[deviceBaseInfo objectForKey:@"IntegratedCircuitCardIdentity"];
    _internationalMobileEquipmentIdentity = (NSString*)[deviceBaseInfo objectForKey:@"InternationalMobileEquipmentIdentity"];
    _internationalMobileSubscriberIdentity = (NSString*)[deviceBaseInfo objectForKey:@"InternationalMobileSubscriberIdentity"];
    _MLBSerialNumber = (NSString*)[deviceBaseInfo objectForKey:@"MLBSerialNumber"];
    _mobileSubscriberCountryCode = (NSString*)[deviceBaseInfo objectForKey:@"MobileSubscriberCountryCode"];
    _mobileSubscriberNetworkCode = (NSString*)[deviceBaseInfo objectForKey:@"MobileSubscriberNetworkCode"];
    _SDIOProductInfo = (NSString*)[deviceBaseInfo objectForKey:@"SDIOProductInfo"];
    _activationStateAcknowledged = [[deviceBaseInfo objectForKey:@"ActivationStateAcknowledged"] longValue];
    _passwordProtected = [[deviceBaseInfo objectForKey:@"PasswordProtected"] longValue];
    _productionSOC = [[deviceBaseInfo objectForKey:@"ProductionSOC"] longValue];
    _protocolVersion = (NSString*)[deviceBaseInfo objectForKey:@"ProtocolVersion"];
    _supportedDeviceFamilies = (NSString*)[deviceBaseInfo objectForKey:@"SupportedDeviceFamilies"];
    _timeIntervalSince1970 = [[deviceBaseInfo objectForKey:@"TimeIntervalSince1970"] longValue];

}

- (BOOL)isWifiConnect {
    return [_device isWifiConnection];
}

- (BOOL)airSync {
    return _airSync;
}

- (NSString*)deviceName {
    return _deviceName;
}

- (NSString*)productVersion {
    return _productVersion;
}

- (int)familyID {
    _familyID = (int)_family;
    return _familyID;
}

- (IPodFamilyEnum)family {
    if ([_productType isEqualToString:@"iPod1,1"]) {
        _family = iPod_Touch_1;
    } else if ([_productType isEqualToString:@"iPod2,1"]) {
        _family = iPod_Touch_2;
    } else if ([_productType isEqualToString:@"iPod3,1"]) {
        _family = iPod_Touch_3;
    } else if ([_productType isEqualToString:@"iPod4,1"]) {
        _family = iPod_Touch_4;
    } else if ([_productType isEqualToString:@"iPod5,1"]) {
        _family = iPod_Touch_5;
    } else if ([_productType isEqualToString:@"iPod7,1"]) {
        _family = iPod_Touch_6;
    } else if ([_productType isEqualToString:@"iPhone1,1"]) {
        _family = iPhone;
    } else if ([_productType isEqualToString:@"iPhone1,2"]) {
        _family = iPhone_3G;
    } else if ([_productType isEqualToString:@"iPhone2,1"]) {
        _family = iPhone_3GS;
    } else if ([_productType isEqualToString:@"iPhone3,1"] ||
               [_productType isEqualToString:@"iPhone3,2"] ||
               [_productType isEqualToString:@"iPhone3,3"]) {
        _family = iPhone_4;
    } else if ([_productType isEqualToString:@"iPhone4,1"]) {
        _family = iPhone_4S;
    } else if ([_productType isEqualToString:@"iPhone5,1"] ||
               [_productType isEqualToString:@"iPhone5,2"]) {
        _family = iPhone_5;
    } else if ([_productType isEqualToString:@"iPhone5,3"] ||
               [_productType isEqualToString:@"iPhone5,4"]) {
        _family = iPhone_5C;
    } else if ([_productType isEqualToString:@"iPhone6,1"] ||
               [_productType isEqualToString:@"iPhone6,2"]) {
        _family = iPhone_5S;
    } else if ([_productType isEqualToString:@"iPhone7,2"]) {
        _family = iPhone_6;
    } else if ([_productType isEqualToString:@"iPhone7,1"]) {
        _family = iPhone_6_Plus;
    } else if ([_productType isEqualToString:@"iPhone8,1"]) {
        _family = iPhone_6S;
    } else if ([_productType isEqualToString:@"iPhone8,2"]) {
        _family = iPhone_6S_Plus;
    } else if ([_productType isEqualToString:@"iPhone8,4"]) {
        _family = iPhone_SE;
    }else if ([_productType isEqualToString:@"iPhone9,1"] ||
              [_productType isEqualToString:@"iPhone9,3"]) {
        _family = iPhone_7;
    }else if ([_productType isEqualToString:@"iPhone9,2"] ||
               [_productType isEqualToString:@"iPhone9,4"]) {
        _family = iPhone_7_Plus;
    }else if ([_productType isEqualToString:@"iPad1,1"]) {
        _family = iPad_1;
    }else if ([_productType isEqualToString:@"iPhone10,4"] ||
              [_productType isEqualToString:@"iPhone10,1"]) {
        _family = iPhone_8;
    }else if ([_productType isEqualToString:@"iPhone10,2"] ||
              [_productType isEqualToString:@"iPhone10,5"]) {
        _family = iPhone_8_Plus;
    }else if ([_productType isEqualToString:@"iPhone10,3"] ||
              [_productType isEqualToString:@"iPhone10,6"]) {
        _family = iPhone_X;
    } else if ([_productType isEqualToString:@"iPad2,1"] ||
               [_productType isEqualToString:@"iPad2,2"] ||
               [_productType isEqualToString:@"iPad2,3"] ||
               [_productType isEqualToString:@"iPad2,4"]) {
        _family = iPad_2;
    } else if ([_productType isEqualToString:@"iPad3,1"] ||
               [_productType isEqualToString:@"iPad3,2"] ||
               [_productType isEqualToString:@"iPad3,3"]) {
        _family = The_New_iPad;
    } else if ([_productType isEqualToString:@"iPad3,4"]) {
        _family = iPad_4;
    } else if ([_productType isEqualToString:@"iPad4,1"] ||
               [_productType isEqualToString:@"iPad4,2"] ||
               [_productType isEqualToString:@"iPad4,3"]) {
        _family = iPad_Air;
    } else if ([_productType isEqualToString:@"iPad5,3"] ||
               [_productType isEqualToString:@"iPad5,4"]) {
        _family = iPad_Air2;
    } else if ([_productType isEqualToString:@"iPad6,3"] ||
               [_productType isEqualToString:@"iPad6,4"]||
               [_productType isEqualToString:@"iPad6,7"]||
               [_productType isEqualToString:@"iPad6,8"]) {
        _family = iPad_Pro;
    }else if ([_productType isEqualToString:@"iPad2,5"] ||
               [_productType isEqualToString:@"iPad2,6"] ||
               [_productType isEqualToString:@"iPad2,7"]) {
        _family = iPad_mini;
    } else if ([_productType isEqualToString:@"iPad4,4"] ||
               [_productType isEqualToString:@"iPad4,5"]) {
        _family = iPad_mini_2;
    } else if ([_productType isEqualToString:@"iPad4,7"] ||
               [_productType isEqualToString:@"iPad4,8"] ||
               [_productType isEqualToString:@"iPad4,9"]) {
        _family = iPad_mini_3;
    } else if ([_productType isEqualToString:@"iPad5,1"] ||
               [_productType isEqualToString:@"iPad5,2"]) {
        _family = iPad_mini_4;
    }else if ([_productType isEqualToString:@"iPad7,1"] ||
              [_productType isEqualToString:@"iPad7,2"] ||
              [_productType isEqualToString:@"iPad7,3"] ||
              [_productType isEqualToString:@"iPad7,4"]) {
        _family = iPad_Pro;
    }else if ([_productType isEqualToString:@"iPad6,11"] ||
              [_productType isEqualToString:@"iPad6,12"]) {
        _family = iPad_5;
    }else {
        if ([_hardwareModel.lowercaseString isEqualToString:@"n61ap"]) {
            _family = iPhone_6;
        } else if ([_hardwareModel.lowercaseString isEqualToString:@"n56ap"]) {
             _family = iPhone_6_Plus;
        } else {
             _family = iPod_Unknown;
        }
    }
    return _family;
}

- (NSString*)deviceClass {
    return _deviceClass;
}

- (NSString*)firmwareVersion {
    return _firmwareVersion;
}

- (NSString*)serialNumber {
    return _serialNumber;
}

- (NSString*)firewireID {
    return _firewireID;
}

- (NSString*)serialNumberForHashing {
    return _serialNumberForHashing;
}

- (NSString*)productType {
    return _productType;
}

- (NSString*)phoneNumber{
    return _phoneNumber;
}

- (NSString*)uniqueChipID {
    return _uniqueChipID;
}

- (NSString*)deviceColor {
    return _deviceColor;
}

- (NSString*)activationState {
    return _activationState;
}

- (NSString*)bluetoothAddress {
    return _bluetoothAddress;
}

- (NSString*)regionInfo {
    return _regionInfo;
}

- (NSString*)simStatus {
    return _simStatus;
}

- (NSString*)timeZone {
    return _timeZone;
}

- (long)timeZoneOffsetFromUTC {
    return _timeZoneOffsetFromUTC;
}

- (NSString*)wifiAddress {
    return _wifiAddress;
}

//2014-8-6
- (NSString *)modelNumber {
    return _modelNumber;
}

- (NSString *)buildVersion {
    return _buildVersion;
}

- (NSString *)hardwareModel {
    return _hardwareModel;
}

- (NSString *)CPUArchitecture {
    return _CPUArchitecture;
}

- (long)activationStateAcknowledged {
    return _activationStateAcknowledged;
}

- (NSString *)basebandVersion {
    return _basebandVersion;
}

- (NSString *)basebandBootloaderVersion {
    return _basebandBootloaderVersion;
}

- (long)basebandChipId {
    return _basebandChipId;
}

- (long)basebandGoldCertId {
    return _basebandGoldCertId;
}

- (NSString *)integratedCircuitCardIdentity {
    return _integratedCircuitCardIdentity;
}

- (NSString *)internationalMobileEquipmentIdentity {
    return _internationalMobileEquipmentIdentity;
}

- (NSString *)internationalMobileSubscriberIdentity {
    return _internationalMobileSubscriberIdentity;
}

- (NSString *)MLBSerialNumber {
    return _MLBSerialNumber;
}

- (NSString *)mobileSubscriberCountryCode {
    return _mobileSubscriberCountryCode;
}

- (NSString *)mobileSubscriberNetworkCode {
    return _mobileSubscriberNetworkCode;
}

- (long)passwordProtected {
    return _passwordProtected;
}

- (long)productionSOC {
    return _productionSOC;
}

- (NSString *)protocolVersion {
    return _protocolVersion;
}

- (NSString *)SDIOProductInfo {
    return _SDIOProductInfo;
}

- (NSString *)supportedDeviceFamilies {
    return _supportedDeviceFamilies;
}

- (long)timeIntervalSince1970 {
    return _timeIntervalSince1970;
}

- (BOOL)isBarreyCharging {
    _isBarreyCharging = [[(AMDevice*)_device deviceValueForKey:@"BatteryIsCharging" inDomain:@"com.apple.mobile.battery"] boolValue];
    return _isBarreyCharging;
}

- (int)currentCapacity {
    _currentCapacity = [[(AMDevice*)_device deviceValueForKey:@"BatteryCurrentCapacity" inDomain:@"com.apple.mobile.battery"] intValue];
    return _currentCapacity;
}

- (int64_t)availableFreeSpace {
    [self refreshDiskUsage];
    _availableFreeSpace = ([[(AMDevice*)_device deviceValueForKey:@"TotalDataAvailable" inDomain:@"com.apple.disk_usage"] longLongValue] - 10485760);
    return _availableFreeSpace;
}

- (int64_t)availableFreeSpaceWithOutRefresh {
    return _availableFreeSpace;
}


- (int64_t)totalSize {
    [self refreshDiskUsage];
    _totalSize = [[(AMDevice*)_device deviceValueForKey:@"TotalDiskCapacity" inDomain:@"com.apple.disk_usage"] longLongValue];
    return _totalSize;
}

- (int64_t)totalDataAvailable {
    [self refreshDiskUsage];
    _totalDataAvailable = [[(AMDevice*)_device deviceValueForKey:@"TotalDataAvailable" inDomain:@"com.apple.disk_usage"] longLongValue];
    return _totalDataAvailable;
}

- (int64_t)totalDataCapacity {
    [self refreshDiskUsage];
    _totalDataCapacity = [[(AMDevice*)_device deviceValueForKey:@"TotalDataCapacity" inDomain:@"com.apple.disk_usage"] longLongValue];
    return _totalDataCapacity;
}

- (int64_t)totalDiskCapacity {
    [self refreshDiskUsage];
    _totalDiskCapacity = [[(AMDevice*)_device deviceValueForKey:@"TotalDiskCapacity" inDomain:@"com.apple.disk_usage"] longLongValue];
    int i = 0;
    if (_totalDiskCapacity == 0) {
        while (YES) {
             usleep(2);
             _totalDiskCapacity = [[(AMDevice*)_device deviceValueForKey:@"TotalDiskCapacity" inDomain:@"com.apple.disk_usage"] longLongValue];
            if (_totalDiskCapacity != 0) {
                break;
            }
            i++;
            if (i==50) {
                break;
            }
        }
    }
    return _totalDiskCapacity;
}

- (int64_t)totalSystemAvailable {
    [self refreshDiskUsage];
    _totalSystemAvailable = [[(AMDevice*)_device deviceValueForKey:@"TotalSystemAvailable" inDomain:@"com.apple.disk_usage"] longLongValue];
    return _totalSystemAvailable;
}

- (int64_t)totalSystemCapacity {
    [self refreshDiskUsage];
    _totalSystemCapacity = [[(AMDevice*)_device deviceValueForKey:@"TotalSystemCapacity" inDomain:@"com.apple.disk_usage"] longLongValue];
    return _totalSystemCapacity;
}

- (int64_t)mobileApplicationUsage {
    [self refreshDiskUsage];
    _mobileApplicationUsage = [[(AMDevice*)_device deviceValueForKey:@"MobileApplicationUsage" inDomain:@"com.apple.disk_usage"] longLongValue];
    return _mobileApplicationUsage;
}

- (BOOL)refreshDiskUsage {
    return [[(AMDevice*)_device deviceValueForKey:@"CalculateDiskUsage" inDomain:@"com.apple.disk_usage"] isEqualToString:@"OkilyDokily"];
}

- (BOOL)isSupportPodcast {
    return TRUE;
}

- (void)getDeviceSupportArtworkFormats {
//    [_artworkFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithPixelFormat:3005 pixelFormat:Format16bppRgb555] autorelease]];
//    [_artworkFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithiThmbBlockLength:3006 pixelFormat:Format16bppRgb555 ithmbBlockLength:8192] autorelease]];
//    IMBSupportedArtworkFormat *format = [[IMBSupportedArtworkFormat alloc] initWithiThmbBlockLength:3007 pixelFormat:Format16bppRgb555 ithmbBlockLength:16384];
//    [format setVideoOnly:TRUE];
//    [_artworkFormats addObject:[format autorelease]];
//    
//    [_photeFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithPixelFormat:3004 pixelFormat:Format16bppRgb555] autorelease]];
//    [_photeFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithPixelFormat:3011 pixelFormat:Format16bppRgb555] autorelease]];
//    [_photeFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithPixelFormat:3008 pixelFormat:Format16bppRgb555] autorelease]];
//    [_photeFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithPixelFormat:3009 pixelFormat:Format16bppRgb555] autorelease]];
}

@end
