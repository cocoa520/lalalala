//
//  DeviceInfo.m
//  
//
//  Created by JGehry on 2/6/17.
//
//

#import "DeviceInfo.h"
#import "IMBHelper.h"

@implementation StorageInfo
@synthesize availableSize = _availableSize;
@synthesize storageKind = _storageKind;
@synthesize totalSize = _totalSize;
@synthesize storagePath = _storagePath;

- (id)init {
    self = [super init];
    if (self) {
        _availableSize = 0;
        _totalSize = 0;
    }
    return self;
}

- (void)dealloc
{
    if (_storageKind != nil) {
        [_storageKind release];
        _storageKind = nil;
    }
    if (_storagePath != nil) {
        [_storagePath release];
        _storagePath = nil;
    }
    [super dealloc];
}

- (void)setStorageKind:(NSString *)storageKind {
    if (_storageKind != nil) {
        [_storageKind release];
        _storageKind = nil;
    }
    _storageKind = [storageKind retain];
}

- (void)setStoragePath:(NSString *)storagePath {
    if (_storagePath != nil) {
        [_storagePath release];
        _storagePath = nil;
    }
    _storagePath = [storagePath retain];
}

@end

@implementation DeviceInfo
@synthesize devName = _devName;
@synthesize devModel = _devModel;
@synthesize devBaseband = _devBaseband;
@synthesize devKernelVersion = _devKernelVersion;
@synthesize devInternalVersion = _devInternalVersion;
@synthesize devHardwareVersion = _devHardwareVersion;
@synthesize devBarCode = _devBarCode;
@synthesize devIpAddress = _devIpAddress;
@synthesize devMacAddress = _devMacAddress;
@synthesize devVersion = _devVersion;
@synthesize devSerialNumber = _devSerialNumber;
@synthesize devScreenResolution = _devScreenResolution;
@synthesize deviceBrand = _deviceBrand;
@synthesize deviceFirm = _deviceFirm;
@synthesize imei = _imei;
@synthesize isRoot = _isRoot;
@synthesize phoneNumber = _phoneNumber;
@synthesize storageArr = _storageArr;
@synthesize productId = _productId;
@synthesize vendorId = _vendorId;
@synthesize pathDir = _pathDir;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_devName != nil) {
        [_devName release];
        _devName = nil;
    }
    if (_devModel != nil) {
        [_devModel release];
        _devModel = nil;
    }
    if (_devBaseband != nil) {
        [_devBaseband release];
        _devBaseband = nil;
    }
    if (_devKernelVersion != nil) {
        [_devKernelVersion release];
        _devKernelVersion = nil;
    }
    if (_devInternalVersion != nil) {
        [_devInternalVersion release];
        _devInternalVersion = nil;
    }
    if (_devHardwareVersion != nil) {
        [_devHardwareVersion release];
        _devHardwareVersion = nil;
    }
    if (_devBarCode != nil) {
        [_devBarCode release];
        _devBarCode = nil;
    }
    if (_devIpAddress != nil) {
        [_devIpAddress release];
        _devIpAddress = nil;
    }
    if (_devMacAddress != nil) {
        [_devMacAddress release];
        _devMacAddress = nil;
    }
    if (_devVersion != nil) {
        [_devVersion release];
        _devVersion = nil;
    }
    if (_devSerialNumber != nil) {
        [_devSerialNumber release];
        _devSerialNumber = nil;
    }
    if (_devScreenResolution != nil) {
        [_devScreenResolution release];
        _devScreenResolution = nil;
    }
    if (_deviceBrand != nil) {
        [_deviceBrand release];
        _deviceBrand = nil;
    }
    if (_deviceFirm != nil) {
        [_deviceFirm release];
        _deviceFirm = nil;
    }
    if (_imei != nil) {
        [_imei release];
        _imei = nil;
    }
    if (_phoneNumber != nil) {
        [_phoneNumber release];
        _phoneNumber = nil;
    }
    if (_pathDir != nil) {
        [_pathDir release];
        _pathDir = nil;
    }
    [_storageArr release], _storageArr = nil;
    [super dealloc];
#endif
}

- (instancetype)initwithSerialNo:(NSString *)serialNo
{
    if (self = [super init]) {
        _isRoot = NO;
        _storageArr = [[NSMutableArray alloc] init];
        
        _adbManager = [IMBAdbManager singleton];
        [self getDeviceInfo:serialNo];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)getDeviceInfo:(NSString *)serialNo {
    _deviceFirm = [[_adbManager runADBCommand:@[@"-s", serialNo, @"shell", @"getprop", @"ro.product.manufacturer"]] retain];
    _devName = [_deviceFirm retain];
    _devModel = [[_adbManager runADBCommand:@[@"-s", serialNo, @"shell", @"getprop", @"ro.product.model"]] retain];
    _devBaseband = [[_adbManager runADBCommand:@[@"-s", serialNo, @"shell", @"getprop", @"gsm.version.baseband"]] retain];
    _devKernelVersion = [[_adbManager runADBCommand:@[@"-s", serialNo, @"shell", @"cat", @"/proc/version"]] retain];
    _devInternalVersion = [[_adbManager runADBCommand:@[@"-s", serialNo, @"shell", @"getprop", @"ro.build.display.id"]] retain];
    _devHardwareVersion = [[_adbManager runADBCommand:@[@"-s", serialNo, @"shell", @"getprop", @"ril.hw_ver"]] retain];
    _devBarCode = [[[[_adbManager runADBCommand:@[@"-s", serialNo, @"shell", @"dumpsys", @"iphonesubinfo"]] componentsSeparatedByString:@"ID = "] lastObject] retain];
    _devIpAddress = [[_adbManager runADBCommand:@[@"-s", serialNo, @"shell", @"getprop", @"dhcp.wlan0.ipaddress"]] retain];
    _devMacAddress = [[_adbManager runADBCommand:@[@"-s", serialNo, @"shell", @"cat", @"/sys/class/net/wlan0/address"]] retain];
    _devVersion = [[_adbManager runADBCommand:@[@"-s", serialNo, @"shell", @"getprop", @"ro.build.version.release"]] retain];
    _devSerialNumber = [serialNo retain];
    _devScreenResolution = [[[[_adbManager runADBCommand:@[@"-s", serialNo, @"shell", @"wm", @"size"]] componentsSeparatedByString:@": "] lastObject] retain];
}

- (void)setDevName:(NSString *)devName {
    if (_devName != nil) {
        [_devName release];
        _devName = nil;
    }
    if ([IMBHelper stringIsNilOrEmpty:devName]) {
        _devName = [_deviceFirm retain];
    }else {
        _devName = [devName retain];
    }
}

- (void)setDevModel:(NSString *)devModel {
    if (_devModel != nil) {
        [_devModel release];
        _devModel = nil;
    }
    _devModel = [devModel retain];
}

- (void)setDevBaseband:(NSString *)devBaseband {
    if (_devBaseband != nil) {
        [_devBaseband release];
        _devBaseband = nil;
    }
    _devBaseband = [devBaseband retain];
}

- (void)setDevKernelVersion:(NSString *)devKernelVersion {
    if (_devKernelVersion != nil) {
        [_devKernelVersion release];
        _devKernelVersion = nil;
    }
    _devKernelVersion = [devKernelVersion retain];
}

- (void)setDevInternalVersion:(NSString *)devInternalVersion {
    if (_devInternalVersion != nil) {
        [_devInternalVersion release];
        _devInternalVersion = nil;
    }
    _devInternalVersion = [devInternalVersion retain];
}

- (void)setDevHardwareVersion:(NSString *)devHardwareVersion {
    if (_devHardwareVersion != nil) {
        [_devHardwareVersion release];
        _devHardwareVersion = nil;
    }
    _devHardwareVersion = [devHardwareVersion retain];
}

- (void)setDevBarCode:(NSString *)devBarCode {
    if (_devBarCode != nil) {
        [_devBarCode release];
        _devBarCode = nil;
    }
    _devBarCode = [devBarCode retain];
}

- (void)setDevIpAddress:(NSString *)devIpAddress {
    if (_devIpAddress != nil) {
        [_devIpAddress release];
        _devIpAddress = nil;
    }
    _devIpAddress = [devIpAddress retain];
}

- (void)setDevMacAddress:(NSString *)devMacAddress {
    if (_devMacAddress != nil) {
        [_devMacAddress release];
        _devMacAddress = nil;
    }
    _devMacAddress = [devMacAddress retain];
}

- (void)setDevVersion:(NSString *)devVersion {
    if (_devVersion != nil) {
        [_devVersion release];
        _devVersion = nil;
    }
    _devVersion = [devVersion retain];
}

- (void)setDevSerialNumber:(NSString *)devSerialNumber {
    if (_devSerialNumber != nil) {
        [_devSerialNumber release];
        _devSerialNumber = nil;
    }
    _devSerialNumber = [devSerialNumber retain];
}

- (void)setScriptingProperties:(NSDictionary *)properties {
    if (_devScreenResolution != nil) {
        [_devScreenResolution release];
        _devScreenResolution = nil;
    }
    _devScreenResolution = [_devScreenResolution retain];
}

- (void)setDeviceBrand:(NSString *)deviceBrand {
    if (_deviceBrand != nil) {
        [_deviceBrand release];
        _deviceBrand = nil;
    }
    _deviceBrand = [deviceBrand retain];
}

- (void)setDeviceFirm:(NSString *)deviceFirm {
    if (_deviceFirm != nil) {
        [_deviceFirm release];
        _deviceFirm = nil;
    }
    _deviceFirm = [deviceFirm retain];
}

- (void)setImei:(NSString *)imei {
    if (_imei != nil) {
        [_imei release];
        _imei = nil;
    }
    _imei = [imei retain];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    if (_phoneNumber != nil) {
        [_phoneNumber release];
        _phoneNumber = nil;
    }
    _phoneNumber = [phoneNumber retain];
}

- (void)setPathDir:(NSString *)pathDir {
    if (_pathDir != nil) {
        [_pathDir release];
        _pathDir = nil;
    }
    _pathDir = [pathDir retain];
}

- (void)setIsRoot:(BOOL)isRoot {
    _isRoot = isRoot;
}

@end
