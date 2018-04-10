//
//  IMBDeviceInfo.m
//  iMobieTrans
//
//  Created by Pallas on 4/1/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBDeviceInfo.h"
#import "NSString+Category.h"

@implementation IMBDeviceInfo
@synthesize isIOSDevice = _isIOSDevice;
@synthesize isJailbreak = _isJailbreak;
@synthesize supportedArtworkFormats = _artworkFormats;
@synthesize supportedPhoteFormats = _photeFormats;

- (id)initWithDevice:(id)device {
    self = [super init];
    if (self != nil) {
        _device = [device retain];
        _artworkFormats = [[NSMutableArray alloc] init];
        _photeFormats = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_artworkFormats != nil) {
        [_artworkFormats release];
        _artworkFormats = nil;
    }
    if (_photeFormats != nil) {
        [_photeFormats release];
        _photeFormats = nil;
    }
    if (_device != nil) {
        [_device release];
        _device = nil;
    }
    [_deviceName release],_deviceName = nil;
    [super dealloc];
}

- (BOOL)isWifiConnect {
    return NO;
}

- (BOOL)airSync {
    return NO;
}

- (NSString*)deviceName {
    return _deviceName;
}

- (NSString*)productVersion {
    return _productVersion;
}

- (int)familyID {
    return _familyID;
}

- (IPodFamilyEnum)family {
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

//得到如iPhone,iPad,iPod等的分类
- (NSString*)familyTypeString {
    if (_family < 1000) {
        return @"iPod";
    } else if (_family > 1000 && _family < 2000) {
        return @"iPod touch";
    } else if (_family > 2000 && _family < 3000) {
        return @"iPhone";
    } else if (_family > 3000) {
        return @"iPad";
    }
    return @"";
}

- (NSString *)getIPodFamilyString {
    NSString *familyTypeStr = nil;
    switch (_family) {
        case iPod_Unknown: {
            familyTypeStr = @"iPod_Unknown";
            break;
        }
        case iPod_Gen1_Gen2: {
            familyTypeStr = @"iPod_Gen1_Gen2";
            break;
        }
        case iPod_Gen3: {
            familyTypeStr = @"iPod_Gen3";
            break;
        }
        case iPod_Mini: {
            familyTypeStr = @"iPod_Mini";
            break;
        }
        case iPod_Gen4: {
            familyTypeStr = @"iPod_Gen4";
            break;
        }
        case iPod_Gen4_2: {
            familyTypeStr = @"iPod_Gen4_2";
            break;
        }
        case iPod_Gen5: {
            familyTypeStr = @"iPod_Gen5";
            break;
        }
        case iPod_Nano_Gen1: {
            familyTypeStr = @"iPod_Nano_Gen1";
            break;
        }
        case iPod_Nano_Gen2: {
            familyTypeStr = @"iPod_Nano_Gen2";
            break;
        }
        case iPod_Classic: {
            familyTypeStr = @"iPod_Classic";
            break;
        }
        case iPod_Nano_Gen3: {
            familyTypeStr = @"iPod_Nano_Gen3";
            break;
        }
        case iPod_Nano_Gen4: {
            familyTypeStr = @"iPod_Nano_Gen4";
            break;
        }
        case iPod_Nano_Gen5: {
            familyTypeStr = @"iPod_Nano_Gen5";
            break;
        }
        case iPod_Nano_Gen6: {
            familyTypeStr = @"iPod_Nano_Gen6";
            break;
        }
        case iPod_Nano_Gen7: {
            familyTypeStr = @"iPod_Nano_Gen7";
            break;
        }
        case iPod_Shuffle_Gen1: {
            familyTypeStr = @"iPod_Shuffle_Gen1";
            break;
        }
        case iPod_Shuffle_Gen2: {
            familyTypeStr = @"iPod_Shuffle_Gen2";
            break;
        }
        case iPod_Shuffle_Gen3: {
            familyTypeStr = @"iPod_Shuffle_Gen3";
            break;
        }
        case iPod_Shuffle_Gen4: {
            familyTypeStr = @"iPod_Shuffle_Gen4";
            break;
        }
        case iOS_Device: {
            familyTypeStr = @"iOS_Device";
            break;
        }
        case iPod_Touch_1: {
            familyTypeStr = @"iPod_Touch_1";
            break;
        }
        case iPod_Touch_2: {
            familyTypeStr = @"iPod_Touch_2";
            break;
        }
        case iPod_Touch_3: {
            familyTypeStr = @"iPod_Touch_3";
            break;
        }
        case iPod_Touch_4: {
            familyTypeStr = @"iPod_Touch_4";
            break;
        }
        case iPod_Touch_5: {
            familyTypeStr = @"iPod_Touch_5";
            break;
        }
        case iPhone: {
            familyTypeStr = @"iPhone";
            break;
        }
        case iPhone_3G: {
            familyTypeStr = @"iPhone_3G";
            break;
        }
        case iPhone_3GS: {
            familyTypeStr = @"iPhone_3GS";
            break;
        }
        case iPhone_4: {
            familyTypeStr = @"iPhone_4";
            break;
        }
        case iPhone_4S: {
            familyTypeStr = @"iPhone_4S";
            break;
        }
        case iPhone_5: {
            familyTypeStr = @"iPhone_5";
            break;
        }
        case iPhone_5S: {
            familyTypeStr = @"iPhone_5S";
            break;
        }
        case iPhone_5C: {
            familyTypeStr = @"iPhone_5C";
            break;
        }
        case iPhone_6:{
            familyTypeStr = @"iPhone_6";
            break;
        }
        case iPhone_6_Plus:{
            familyTypeStr = @"iPhone_6_Plus";
            break;
        }
        case iPhone_6S:{
            familyTypeStr = @"iPhone_6S";
            break;
        }
        case iPhone_6S_Plus:{
            familyTypeStr = @"iPhone_6S_Plus";
            break;
        }
        case iPhone_SE:{
            familyTypeStr = @"iPhone_SE";
            break;
        }
        case iPhone_7:{
            familyTypeStr = @"iPhone_7";
            break;
        }
        case iPhone_7_Plus:{
            familyTypeStr = @"iPhone_7_Plus";
            break;
        }
        case iPhone_8:{
            familyTypeStr = @"iPhone_8";
            break;
        }
        case iPhone_8_Plus:{
            familyTypeStr = @"iPhone_8_Plus";
            break;
        }
        case iPhone_X:{
            familyTypeStr = @"iPhone_X";
            break;
        }
        case iPad_1: {
            familyTypeStr = @"iPad_1";
            break;
        }
        case iPad_2: {
            familyTypeStr = @"iPad_2";
            break;
        }
        case The_New_iPad: {
            familyTypeStr = @"The_New_iPad";
            break;
        }
        case iPad_4: {
            familyTypeStr = @"iPad_4";
            break;
        }
        case iPad_Air: {
            familyTypeStr = @"iPad_Air";
            break;
        }
        case iPad_Air2: {
            familyTypeStr = @"iPad_Air2";
            break;
        }
        case iPad_mini: {
            familyTypeStr = @"iPad_mini";
            break;
        }
        case iPad_mini_2: {
            familyTypeStr = @"iPad_mini_2";
            break;
        }
        case iPad_mini_3: {
            familyTypeStr = @"iPad_mini_3";
            break;
        }
        case iPad_mini_4: {
            familyTypeStr =  @"iPad mini 4";
            break;
        }
        case iPad_Pro: {
            familyTypeStr = @"iPad_Pro";
            break;
        }
        case iPad_5: {
            familyTypeStr = @"iPad_5";
            break;
        }
        case iPad_6: {
            familyTypeStr = @"iPad_6";
            break;
        }

        default: {
            familyTypeStr = @"Unknown";
            break;
        }
            
    }
    return familyTypeStr;
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

- (BOOL)isBarreyCharging {
    return _isBarreyCharging;
}

- (int)currentCapacity {
    return _currentCapacity;
}

- (int64_t)availableFreeSpace {
    return _availableFreeSpace;
}

- (int64_t)availableFreeSpaceWithOutRefresh {
    return _availableFreeSpace;
}

- (int64_t)totalSize {
    return _totalSize;
}

- (int64_t)totalDataAvailable {
    return _totalDataAvailable;
}

- (int64_t)totalDataCapacity {
    return _totalDataCapacity;
}

- (int64_t)totalDiskCapacity {
    return _totalDiskCapacity;
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


- (BOOL)refreshDiskUsage {
    return NO;
}

- (BOOL)needHashABChkSum {
    _needHashABChkSum = NO;
    if (_family == iPod_Nano_Gen6 || _family == iPod_Nano_Gen7) {
        _needHashABChkSum = YES;
    } else if (_isIOSDevice && ![_productVersion isNilOrEmpty] && [_productVersion isVersionMajorEqual:@"5.0"]) {
        _needHashABChkSum = YES;
    }
    return _needHashABChkSum;
}

- (BOOL)isShuffle {
    _isShuffle = NO;
    if (_family == iPod_Shuffle_Gen1 ||
        _family == iPod_Shuffle_Gen2 ||
        _family == iPod_Shuffle_Gen3 ||
        _family == iPod_Shuffle_Gen4) {
        _isShuffle = YES;
    } else {
        _isShuffle = NO;
    }
    return _isShuffle;
}

#pragma mark - 设备支持的媒体分类属性
- (BOOL)isSupportMusic {
    _isSupportMusic = YES;
    return _isSupportMusic;
}

- (BOOL)isSupportMovie {
    if (_family == iPod_Nano_Gen3 || _family == iPod_Nano_Gen4 || _family == iPod_Nano_Gen5 || _family == iPod_Nano_Gen7 ||
        _family == iPod_Gen5 || _family == iPod_Classic || _isIOSDevice) {
        _isSupportMovie = YES;
    } else {
        _isSupportMovie = NO;
    }
    
    return _isSupportMovie;
}

- (BOOL)isSupportHomeVideo
{
    if (!_isIOSDevice) {
        return NO;
    }else if ([self getDeviceVersionNumber] >=7)
    {
        return YES;
    }else
    {
        return NO;
    }
}

- (BOOL)isSupportPodcast {
    return _isSupportPodcast;
}

- (BOOL)isSupportVideo {
    if (_family == iPod_Nano_Gen3 || _family == iPod_Nano_Gen4 || _family == iPod_Nano_Gen5 || _family == iPod_Nano_Gen7 ||
        _family == iPod_Gen5 || _family == iPod_Classic || _isIOSDevice ) {
        _isSupportVideo = YES;
    } else {
        _isSupportVideo = NO;
    }
    return _isSupportVideo;
}

- (BOOL)isSupportAudioBook {
    _isSupportAudioBook = YES;
    return _isSupportAudioBook;
}

- (BOOL)isSupportMV{
    if (_family == iPod_Nano_Gen3 || _family == iPod_Nano_Gen4 || _family == iPod_Nano_Gen5 || _family == iPod_Nano_Gen7 ||
        _family == iPod_Gen5 || _family == iPod_Classic || _isIOSDevice) {
        _isSupportMV = YES;
    } else {
        _isSupportMV = NO;
    }

    return _isSupportMV;
}

- (BOOL)isSupportTVShow {
    if (_family == iPod_Nano_Gen3 || _family == iPod_Nano_Gen4 || _family == iPod_Nano_Gen5 || _family == iPod_Nano_Gen7 ||
        _family == iPod_Gen5 || _family == iPod_Classic || _isIOSDevice) {
        _isSupportTVShow = YES;
    } else {
        _isSupportTVShow = NO;
    }

    return _isSupportTVShow;
}

- (BOOL)isSupportRingtone {
    if (_isIOSDevice && (_family == iPad_1 || _family == iPad_2 || _family == iPad_Pro || _family == iPad_5 || _family == iPad_6 || _family == The_New_iPad || _family == iPad_4 || _family == iPad_Air || _family == iPad_Air2 || _family == iPad_mini || _family == iPad_mini_2 || _family == iPad_mini_3 ||
                         _family == iPhone_3GS || _family == iPhone_4 || _family == iPhone_4S ||
                         _family == iPod_Touch_4 ||
                         _family == iPhone_5 || _family == iPod_Touch_5 ||
                         _family == iPhone_5S || _family == iPhone_5C ||
                         _family == iPhone_6 || _family == iPhone_6_Plus || _family == iPhone_6S|| _family == iPhone_6S_Plus|| _family == iPhone_SE || _family == iPod_Touch_6|| _family == iPhone_7|| _family == iPhone_7_Plus || _family == iPhone_8 || _family == iPhone_8_Plus || _family == iPhone_X) && [@"4.0" isVersionAscending:_productVersion]) {
        _isSupportRingtone = YES;
    } else {
        _isSupportRingtone = NO;
    }
    return _isSupportRingtone;
}

- (BOOL)isSupportApplication {
    if (_isIOSDevice && (_family == iPad_1 || _family == iPad_2 || _family == iPad_Pro || _family == iPad_5  || _family == iPad_6 || _family == The_New_iPad || _family == iPad_4 || _family == iPad_Air || _family == iPad_Air2 || _family == iPad_mini || _family == iPad_mini_2 || _family == iPad_mini_3 ||
                         _family == iPhone_3GS || _family == iPhone_4 || _family == iPhone_4S ||
                         _family == iPod_Touch_4 ||
                         _family == iPhone_5 || _family == iPod_Touch_5 ||
                         _family == iPhone_5S || _family == iPhone_5C ||
                         _family == iPhone_6 || _family == iPhone_6_Plus|| _family == iPhone_6S|| _family == iPhone_6S_Plus|| _family == iPhone_SE||_family == iPhone_7|| _family == iPhone_7_Plus || _family == iPhone_8 || _family == iPhone_8_Plus || _family == iPhone_X) && [@"4.0" isVersionAscending:_productVersion]) {
        _isSupportApplication = YES;
    } else {
        _isSupportApplication = NO;
    }
    return _isSupportApplication;
}


- (BOOL)isSupportiTunesU {
    if (_isIOSDevice || _family == iPod_Nano_Gen6 || _family == iPod_Nano_Gen7) {
        _isSupportiTunesU = YES;
    } else {
        _isSupportiTunesU = NO;
    }
    return _isSupportiTunesU;
}

- (BOOL)isSupportiBook {
    if (_isIOSDevice) {
        _isSupportiBook = YES;
    } else {
        _isSupportiBook = NO;
    }
    return _isSupportiBook;
}

- (BOOL)isSupportVoiceMemo {//iPad不支持VoiceMemos
    if (_isIOSDevice && [@"4.0" isVersionAscending:_productVersion] && _family != iPad_1 && _family != iPad_2 && _family != The_New_iPad && _family != iPad_4 && _family != iPad_Air && _family != iPad_Air2 && _family != iPad_mini && _family != iPad_mini_2 && _family != iPad_mini_3 && _family != iPad_mini_4 && _family != iPad_Pro && _family != iPad_5 && _family != iPad_6) {
        _isSupportVoiceMemo = YES;
    } else {
        _isSupportVoiceMemo = NO;
    }
    return _isSupportVoiceMemo;
}

- (BOOL)isSupportPhoto
{
  if (_isIOSDevice) {
        _isSupportPhoto = YES;
    } else {
        _isSupportPhoto = NO;
    }
    return _isSupportPhoto;

}

- (BOOL)isiPhone
{
    if (_family == iPhone||_family == iPhone_3G||_family == iPhone_3GS||_family == iPhone_4||_family == iPhone_4S||_family == iPhone_5||_family == iPhone_5C||_family == iPhone_5S ||
        _family == iPhone_6 || _family == iPhone_6_Plus|| _family == iPhone_6S|| _family == iPhone_6S_Plus|| _family == iPhone_SE||_family == iPhone_7|| _family == iPhone_7_Plus || _family == iPhone_8 || _family == iPhone_8_Plus || _family == iPhone_X) {
        return YES;
    }else
    {
        return NO;
    }

}

- (BOOL)isiPad
{
   if (_family == iPad_1||_family == iPad_2||_family == The_New_iPad||_family == iPad_4||_family == iPad_Air||_family == iPad_Air2||_family == iPad_Pro||_family == iPad_5||_family == iPad_6||_family == iPad_mini||_family == iPad_mini_2||_family == iPad_mini_3||_family == iPad_mini_4) {
        return YES;
    }else
    {
        return NO;
    }

}

- (BOOL)isiPod
{

    if (_family == iPod_Unknown||_family == iPod_Gen1_Gen2||_family == iPod_Gen3||_family == iPod_Mini||_family == iPod_Gen4||_family == iPod_Gen4_2||_family == iPod_Gen5||_family ==iPod_Nano_Gen1||_family ==iPod_Nano_Gen2||_family ==iPod_Classic||_family ==iPod_Nano_Gen3||_family ==iPod_Nano_Gen4||_family ==iPod_Nano_Gen5||_family ==iPod_Nano_Gen6||_family ==iPod_Nano_Gen7||_family ==iPod_Shuffle_Gen1||_family ==iPod_Shuffle_Gen2||_family ==iPod_Shuffle_Gen3||_family ==iPod_Shuffle_Gen4||_family ==iPod_Touch_1||_family ==iPod_Touch_2||_family ==iPod_Touch_3||_family ==iPod_Touch_4||_family ==iPod_Touch_5) {
        return YES;
    }else
    {
        return NO;
    }

}

- (BOOL)isiPodnano
{
    if (_family == 7||_family == 9||_family == 12||_family == 15||_family == 16||_family == 17||_family == 18) {
        return YES;
    }else
    {
        return NO;
    }
}

- (BOOL)isiPodShuffle
{
    if (_family == 128||_family == 130||_family == 132||_family == 133) {
        return YES;
    }else
    {
        return NO;
    }
}

- (BOOL)isiPodClassic
{
    if (_family == 11) {
        return YES;
    }else
    {
        return NO;
    }
}

- (int)getDeviceVersionNumber
{
   NSString *versionstrone = nil;
    if (_productVersion.length>=3) {
        NSRange range;
        NSString *str = [_productVersion substringWithRange:NSMakeRange(2, 1)];
        if ([str isEqualToString:@"."]) {
            range.length = 2;
            range.location = 0;
        }else {
            range.length = 1;
            range.location = 0;
        }
        versionstrone = [_productVersion substringWithRange:range];
    }else
    {
        return 5;
    }
    
    return [versionstrone intValue];
}

- (NSString *)getDeviceFloatVersionNumber
{
    NSString *versionstrone = nil;
    if (_productVersion.length>=3) {
        NSRange range;
        NSString *str = [_productVersion substringWithRange:NSMakeRange(2, 1)];
        if ([str isEqualToString:@"."]) {
            range.length = 4;
            range.location = 0;
        }else{
            range.length = 3;
            range.location = 0;
        }
        versionstrone = [_productVersion substringWithRange:range];
        return versionstrone;
    }
   return @"9.0";
}

- (void)getDeviceSupportArtworkFormats {
    
}

@end
