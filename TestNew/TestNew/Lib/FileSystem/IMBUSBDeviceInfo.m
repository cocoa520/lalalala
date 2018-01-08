//
//  IMBUSBDeviceInfo.m
//  iMobieTrans
//
//  Created by Pallas on 4/1/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBUSBDeviceInfo.h"
#import "IMBSupportedArtworkFormat.h"

@implementation IMBUSBDeviceInfo

- (id)initWithDevice:(id)device {
    self = [super initWithDevice:device];
    if (self) {
        _isIOSDevice = NO;
        _isJailbreak = NO;
        fm = [NSFileManager defaultManager];
        NSString *devicePath = [(NSString*)_device stringByAppendingPathComponent:@"iPod_Control/Device"];
        BOOL isDir = NO;
        if ([fm fileExistsAtPath:devicePath isDirectory:&isDir]) {
            if (!isDir) {
                [fm removeItemAtPath:devicePath error:nil];
                [fm createDirectoryAtPath:devicePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
        } else {
            [fm createDirectoryAtPath:devicePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        extendedFilePath = [devicePath stringByAppendingPathComponent:@"ExtendedSysInfoXml"];
        if ([self checkExtendedInfo]) {
            _devInfoDic = [[NSDictionary dictionaryWithContentsOfFile:extendedFilePath] retain];
            if (_devInfoDic == nil) {
                [fm removeItemAtPath:extendedFilePath error:nil];
                if ([self checkExtendedInfo]) {
                    _devInfoDic = [[NSDictionary dictionaryWithContentsOfFile:extendedFilePath] retain];
                }
            }
            NSArray *allKey = [_devInfoDic allKeys];
            if ([allKey containsObject:@"PodcastsSupported"]) {
                _isSupportPodcast = [[_devInfoDic objectForKey:@"PodcastsSupported"] boolValue];
            } else {
                if ([allKey containsObject:@"SQLiteDB"]) {
                    _isSupportPodcast = [[_devInfoDic objectForKey:@"SQLiteDB"] boolValue];
                } else {
                    _isSupportPodcast = NO;
                }
            }
            _familyID =  [[_devInfoDic objectForKey:@"FamilyID"] intValue];
            _productVersion = [_devInfoDic objectForKey:@"VisibleBuildID"];
            _family = (IPodFamilyEnum)_familyID;
            
            _isInfoExsit = YES;
        } else {
            _isInfoExsit = NO;
        }
    }
    return self;
}

- (void)dealloc {
    if (_devInfoDic != nil) {
        [_devInfoDic release];
        _devInfoDic = nil;
    }
    
    [super dealloc];
}

- (BOOL)checkExtendedInfo {
    if ([fm fileExistsAtPath:extendedFilePath]) {
        return YES;
    } else {
        [IMBSTUCMethod createExtendedInfoByMountPath:_device extendedInfoPath:extendedFilePath];
        if ([fm fileExistsAtPath:extendedFilePath]) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (BOOL)isWifiConnect {
    return NO;
}

- (BOOL)airSync {
    return NO;
}

- (NSString*)deviceName {
    if ([self stringIsNilOrEmpty:_deviceName]) {
        _deviceName = [[(NSString*)_device lastPathComponent] copy];
    }
    return _deviceName;
}

- (NSString*)productVersion {
    //_productVersion = [_devInfoDic objectForKey:@"VisibleBuildID"];
    return _productVersion;
}


- (int)familyID {
    //NSLog(@"[_devInfoDic description] %@",[_devInfoDic description]);
    //_familyID =  [[_devInfoDic objectForKey:@"FamilyID"] intValue];
    return _familyID;
}

- (IPodFamilyEnum)family {
    //_family = (IPodFamilyEnum)_familyID;
    return _family;
}

- (NSString*)deviceClass {
    return @"";
    //return _deviceClass;
}

- (NSString*)firmwareVersion {
    return @"";
    //return _firmwareVersion;
}

- (NSString*)serialNumber {
    if ([self stringIsNilOrEmpty:_serialNumber]) {
        if (_devInfoDic != nil) {
            _serialNumber = [_devInfoDic objectForKey:@"SerialNumber"];
        } else {
            _serialNumber = @"";
        }
    }
    return _serialNumber;
}

- (NSString*)firewireID {
    if ([self stringIsNilOrEmpty:_firewireID]) {
        if (_devInfoDic != nil) {
            _firewireID = [_devInfoDic objectForKey:@"FireWireGUID"];
        } else {
            _firewireID = @"";
        }
    }
    return _firewireID;
}

- (NSString*)serialNumberForHashing {
    //_serialNumberForHashing = [[self firewireID] stringByAppendingFormat:@"%@%@", [IMBHelper getHexStringFromNSData:[[self firewireID] dataUsingEncoding:NSASCIIStringEncoding]], @"00"];
    return [self firewireID];
}

- (NSString*)productType {
    return @"";
    //return _productType;
}

- (NSString*)phoneNumber{
    return @"";
    //return _phoneNumber;
}

- (NSString*)uniqueChipID {
    return _uniqueChipID;
}

- (NSString*)deviceColor {
    return @"";
    //return _deviceColor;
}

- (NSString*)activationState {
    return @"";
    //return _activationState;
}

- (NSString*)bluetoothAddress {
    return @"";
    //return _bluetoothAddress;
}

- (NSString*)regionInfo {
    return @"";
    //return _regionInfo;
}

- (NSString*)simStatus {
    return @"";
    //return _simStatus;
}

- (NSString*)timeZone {
    return @"";
    //return _timeZone;
}

- (long)timeZoneOffsetFromUTC {
    return 0;
    //return _timeZoneOffsetFromUTC;
}

- (NSString*)wifiAddress {
    return @"";
    //return _wifiAddress;
}

- (BOOL)isBarreyCharging {
    return 0;
    //return _isBarreyCharging;
}

- (int)currentCapacity {
    return 0;
    return _currentCapacity;
}

- (int64_t)availableFreeSpace {
    NSError *err = nil;
    NSDictionary *fsAttrs = [fm attributesOfFileSystemForPath:(NSString*)_device error:&err];
    _availableFreeSpace = ([[fsAttrs objectForKey:NSFileSystemFreeSize] unsignedLongLongValue] - 10485760);
    return _availableFreeSpace;
}

- (int64_t)availableFreeSpaceWithOutRefresh {
    return _availableFreeSpace;
}

- (int64_t)totalSize {
    NSError *err = nil;
    NSDictionary *fsAttrs = [fm attributesOfFileSystemForPath:(NSString*)_device error:&err];
    _totalSize = [[fsAttrs objectForKey:NSFileSystemSize] unsignedLongLongValue];
    return _totalSize;
}

- (int64_t)totalDataAvailable {
    return [self availableFreeSpace];
    //return _totalDataAvailable;
}

- (int64_t)totalDataCapacity {
    return _totalDataCapacity;
}

- (int64_t)totalDiskCapacity {
    return [self totalSize];
    //return _totalDiskCapacity;
}

- (int64_t)totalSystemAvailable {
    return _totalSystemAvailable;
}

- (int64_t)totalSystemCapacity {
    return _totalSystemCapacity;
}

- (int64_t)mobileApplicationUsage {
    return _mobileApplicationUsage;
}

- (BOOL)refreshDiskUsage {
    return YES;
}

//2014-8-6
- (NSString *)modelNumber {
    return @"";
}

- (NSString *)buildVersion {
    return @"";
}

- (NSString *)hardwareModel {
    return @"";
}

- (NSString *)CPUArchitecture {
    return @"";
}

- (long)activationStateAcknowledged {
    return 0;
}

- (NSString *)basebandVersion {
    return @"";
}

- (NSString *)basebandBootloaderVersion {
    return @"";
}

- (long)basebandChipId {
    return 0;
}

- (long)basebandGoldCertId {
    return 0;
}

- (NSString *)integratedCircuitCardIdentity {
    return @"";
}

- (NSString *)internationalMobileEquipmentIdentity {
    return @"";
}

- (NSString *)internationalMobileSubscriberIdentity {
    return @"";
}

- (NSString *)MLBSerialNumber {
    return @"";
}

- (NSString *)mobileSubscriberCountryCode {
    return @"";
}

- (NSString *)mobileSubscriberNetworkCode {
    return @"";
}

- (long)passwordProtected {
    return 0;
}

- (long)productionSOC {
    return 0;
}

- (NSString *)protocolVersion {
    return @"";
}

- (NSString *)SDIOProductInfo {
    return @"";
}

- (NSString *)supportedDeviceFamilies {
    return @"";
}

- (long)timeIntervalSince1970 {
    return 0;
}

- (void)getDeviceSupportArtworkFormats {
    NSLog(@"_family %d",_family);
    NSLog(@"family %d",[self family]);
    if ([self family] == iPod_Nano_Gen5) {
        [_artworkFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithImageSize:1056 pixelFormat:Format16bppRgb565 width:128 heigth:128] autorelease]];
        [_artworkFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithPixelFormat:1078 pixelFormat:Format16bppRgb565] autorelease]];
        [_artworkFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithImageSize:1073 pixelFormat:Format16bppRgb565 width:240 heigth:240] autorelease]];
        [_artworkFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithPixelFormat:1074 pixelFormat:Format16bppRgb565] autorelease]];
        
        [_photeFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithPixelFormat:1087 pixelFormat:Format16bppRgb565] autorelease]];
        [_photeFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithPixelFormat:1079 pixelFormat:Format16bppRgb565] autorelease]];
        [_photeFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithPixelFormat:1066 pixelFormat:Format16bppRgb565] autorelease]];
        return;
    }
    
    if ([self family] == iPod_Nano_Gen6) {
        [_artworkFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithImageSize:1073 pixelFormat:Format16bppRgb565 width:240 heigth:240] autorelease]];
        [_artworkFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithImageSize:1074 pixelFormat:Format16bppRgb565 width:50 heigth:50] autorelease]];
        [_artworkFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithImageSize:1085 pixelFormat:Format16bppRgb565 width:88 heigth:88] autorelease]];
        [_artworkFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithImageSize:1089 pixelFormat:Format16bppRgb565 width:58 heigth:58] autorelease]];
        return;
    }
    
    if ([self family] == iPod_Nano_Gen7) {
        [_artworkFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithImageSize:1010 pixelFormat:Format16bppRgb565 width:240 heigth:240] autorelease]];
        [_artworkFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithImageSize:1013 pixelFormat:Format16bppRgb565 width:50 heigth:50] autorelease]];
        [_artworkFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithImageSize:1015 pixelFormat:Format16bppRgb565 width:58 heigth:58] autorelease]];
        [_artworkFormats addObject:[[[IMBSupportedArtworkFormat alloc] initWithImageSize:1016 pixelFormat:Format16bppRgb565 width:58 heigth:58] autorelease]];
        return;
    }
    
    [self readArtworkNode:@"AlbumArt" SupportedArray:_artworkFormats UseReportedSize:false];
    [self readArtworkNode:@"ImageSpecifications" SupportedArray:_photeFormats UseReportedSize:true];
    NSLog(@"_artworkFormats %@",  _artworkFormats);
}

- (void)readArtworkNode:(NSString*)nodeName SupportedArray:(NSMutableArray*)artwork UseReportedSize:(BOOL)useReportedSize {
    if (nodeName == nil) return;
    NSArray *artNodes = [_devInfoDic objectForKey:nodeName];
    if (artNodes == nil) return;
    for (id artNode in artNodes) {
        if ( ![artNode isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        NSString *formatID = [artNode objectForKey:@"FormatId"];
        int width = 0, height = 0;
        if ([artNode objectForKey:@"RenderWidth"] != nil) {
            width = [(NSNumber*)[artNode objectForKey:@"RenderWidth"] intValue];
        }
        if ([artNode objectForKey:@"RenderHeight"] != nil) {
            height = [(NSNumber*)[artNode objectForKey:@"RenderHeight"] intValue];
        }
        NSString *pixelFormat = [artNode objectForKey:@"PixelFormat"];
        if ([@"4C353635" isEqualToString:pixelFormat]) {
            NSLog(@"Supported artwork format: %@ %dx%d, format %@", formatID,width,height,pixelFormat);
            @try {
                
                NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(IMBSupportedArtworkFormat *supportedFormat, NSDictionary *bindings) {
                    return supportedFormat.width == width && supportedFormat.height == height;
                }];
                NSArray *preRes = [artwork filteredArrayUsingPredicate:pre];
                if (preRes == nil || preRes.count == 0) {
                    if (useReportedSize) {
                        IMBSupportedArtworkFormat *artFormat = [[IMBSupportedArtworkFormat alloc] initWithImageSize:formatID.intValue pixelFormat:Format16bppRgb565 width:width heigth:height];
                        [artwork addObject:artFormat];
                        [artFormat release];
                    }else {
                        IMBSupportedArtworkFormat *artFormat = [[IMBSupportedArtworkFormat alloc] initWithPixelFormat:formatID.intValue pixelFormat: Format16bppRgb565];
                        [artwork addObject:artFormat];
                        [artFormat release];
                    }
                } else {
                    NSLog(@"Format ignored.");
                }

            }
            @catch (NSException *exception) {
                NSLog(@"%@", [exception reason]);
            }
        } else {
            NSLog(@"Unknown artwork format: %@ %dx%d, format %@", formatID,width,height,pixelFormat);
        }
    }
}

- (BOOL)stringIsNilOrEmpty:(NSString*)string {
    if (string == nil || [string isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

@end
