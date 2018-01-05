//
//  IMBAndroidDevice.m
//  IMBAndroidDevice
//
//  Created by JGehry on 3/13/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBAndroidDevice.h"
#import "IMBAdbManager.h"
#import "RegexKitLite.h"
#import "ATTracker.h"
#import "TempHelper.h"
#import <IOKit/usb/IOUSBLib.h>

extern BOOL isConnected = NO;
extern BOOL isOpenUSB = NO;

typedef struct MyPrivateData {
    io_object_t				notification;
    IOUSBDeviceInterface	**deviceInterface;
    CFStringRef				deviceName;
    UInt32					locationID;
} MyPrivateData;

//static IONotificationPortRef	gNotifyPort;
//static io_iterator_t			gAddedIter;
//static CFRunLoopRef				gRunLoop;

static IONotificationPortRef  notifyPort;
static CFRunLoopSourceRef  runLoopSource;
static CFRunLoopRef  runLoop;
io_iterator_t portIterator;

@implementation IMBAndroidDevice
@synthesize connectedDeviceArray = _connectedDeviceArray;
@synthesize connectedDeviceDictionary = _connectedDeviceDictionary;
@synthesize serialNo = _serialNo;
@synthesize deviceManufacturer = _deviceManufacturer;
@synthesize isOpenUSBDebugModel = _isOpenUSBDebugModel;
@synthesize deviceCondition = _deviceCondition;
@synthesize isDevicePause = _isDevicePause;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [self setConnectedDeviceArray:nil];
    [self setConnectedDeviceDictionary:nil];
    [self setSerialNo:nil];
    [self setDeviceManufacturer:nil];
    [_supportDeviceArray release],_supportDeviceArray = nil;
    [_deviceCondition release],_deviceCondition = nil;
    [super dealloc];
#endif
}

+ (IMBAndroidDevice*)singleton {
    static IMBAndroidDevice *_singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_singleton == nil) {
            _singleton = [[IMBAndroidDevice alloc] init];
        }
    });
    return _singleton;
}

- (id)init
{
    if (self = [super init]) {
        NSString *supportedDevicePath = [[NSBundle bundleForClass:[IMBAndroidDevice class]] pathForResource:@"matchingdevices" ofType:@"plist"];
        _supportDeviceArray = [[NSArray alloc] initWithContentsOfFile:supportedDevicePath];
        _connectedDeviceArray = [[NSMutableArray alloc] init];
        _connectedDeviceDictionary = [[NSMutableDictionary alloc] init];
        _deviceCondition = [[NSCondition alloc] init];
        _isDevicePause = YES;
    }
    return self;
}

- (void)startListen:(id<IMBAndroidDeviceDelegate>)delegate;
{
    _delegate = delegate;
    [self startNotificationPort];
}

- (void)startNotificationPort
{
    CFMutableDictionaryRef  matchingDict = IOServiceMatching(kIOUSBDeviceClassName);
    notifyPort = IONotificationPortCreate(kIOMasterPortDefault);
    runLoopSource = IONotificationPortGetRunLoopSource( notifyPort );
    runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource( runLoop, runLoopSource, kCFRunLoopDefaultMode);
    CFRetain( matchingDict );
    portIterator = 0;
    kern_return_t  returnCode = IOServiceAddMatchingNotification( notifyPort, kIOFirstMatchNotification, matchingDict, DeviceConnected, NULL, &portIterator );
    if ( returnCode == 0 )
    {
        DeviceConnected( nil, portIterator);
    }
    returnCode = IOServiceAddMatchingNotification(notifyPort, kIOTerminatedNotification, matchingDict, DeviceDisconnected, NULL, &portIterator );
    if ( returnCode == 0 )
    {
        DeviceDisconnected( nil, portIterator );
    }
}

void CleanUp() {
    IONotificationPortDestroy(notifyPort);
    if (portIterator) {
        IOObjectRelease(portIterator);
        portIterator = 0;
    }
    CFMutableDictionaryRef  matchingDict = IOServiceMatching(kIOUSBDeviceClassName);
    notifyPort = IONotificationPortCreate(kIOMasterPortDefault);
    runLoopSource = IONotificationPortGetRunLoopSource( notifyPort );
    runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource( runLoop, runLoopSource, kCFRunLoopDefaultMode);
    CFRetain( matchingDict );
    kern_return_t  returnCode = IOServiceAddMatchingNotification( notifyPort, kIOFirstMatchNotification, matchingDict, DeviceConnected, NULL, &portIterator );
    if ( returnCode == 0 )
    {
        DeviceConnected( nil, portIterator);
    }
    returnCode = IOServiceAddMatchingNotification(notifyPort, kIOTerminatedNotification, matchingDict, DeviceDisconnected, NULL, &portIterator );
    if ( returnCode == 0 )
    {
        DeviceDisconnected( nil, portIterator );
    }
}

void DeviceConnected( void *refCon, io_iterator_t iterator)
{
    __block kern_return_t  returnCode = KERN_FAILURE;
    io_object_t  usbDevice;
    while ( ( usbDevice = IOIteratorNext( iterator ) ) )
    {
        io_name_t name;
        returnCode = IORegistryEntryGetName(usbDevice, name );
        if ( returnCode != KERN_SUCCESS )
        {
            return;
        }
        CFNumberRef idVendor = (CFNumberRef)IORegistryEntrySearchCFProperty(usbDevice, kIOServicePlane, CFSTR(kUSBVendorID), kCFAllocatorDefault, 0);
        CFNumberRef idProduct = (CFNumberRef)IORegistryEntrySearchCFProperty(usbDevice, kIOServicePlane, CFSTR(kUSBProductID), kCFAllocatorDefault, 0);
        CFStringRef productName = (CFStringRef)IORegistryEntrySearchCFProperty(usbDevice, kIOServicePlane, CFSTR(kUSBVendorString), kCFAllocatorDefault, 0);
        uint16_t vendorPID;
        CFNumberGetValue(idVendor, kCFNumberSInt16Type, (void *)&vendorPID);
        uint16_t productPID;
        CFNumberGetValue(idProduct, kCFNumberSInt16Type, (void *)&productPID);
        NSString *productNameStr = (__bridge NSString*)productName;
        if ([productNameStr rangeOfString:@"Apple"].location == NSNotFound) {
            //检查是否支持该设备
            if ([[IMBAndroidDevice singleton] checkDeviceisSupported:vendorPID] && (productName != NULL)) {
                NSLog(@"DeviceConnected");
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:Android_Connect action:ActionNone actionParams:[[IMBAndroidDevice singleton] deviceManufacturer] label:LabelNone transferCount:2 screenView:@"Move To iOS" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //发个消息提示用户有安卓设备连接
                    [[IMBAndroidDevice singleton] deviceConnectedUSBMessageCallBack];
                
                    [[IMBAndroidDevice singleton].deviceCondition lock];
                    if ([IMBAndroidDevice singleton].isDevicePause) {
                        [[IMBAndroidDevice singleton].deviceCondition wait];
                    }
                    [[IMBAndroidDevice singleton].deviceCondition unlock];
                    
                    //获取当前连接设备的序列号
                    NSString *newSerialNumber = [IMBAdbManager findSerial:vendorPID withProductID:productPID];
                    [[IMBAndroidDevice singleton] setSerialNo:newSerialNumber];
                    
                    if ([[[IMBAndroidDevice singleton] connectedDeviceArray] count] == 0) {
                        NSString *customVersionName = [(__bridge NSString*)productName lowercaseString];
                        NSLog(@"customVersionName = %@", customVersionName);
                        //序列号
                        NSString *serialNumber = nil;
                        NSString *currentSerialNumber = nil;
                        //检测此设备序列号是否与连接的设备是同一个
                        IMBAdbManager *_adbManager = [IMBAdbManager singleton];
                        [_adbManager runADBCommand:[_adbManager startServer]];
                        sleep(1);
                        NSString *str = [_adbManager runADBCommand:[_adbManager connectDevices]];
                        NSLog(@"connect Device Str:%@  ",str);
                        
                        NSString *deviceStr = [[str componentsSeparatedByString:@"List of devices attached\n"] objectAtIndex:1];
                        if ([deviceStr rangeOfString:@"* daemon not running. starting it now on port 5037 *"].location != NSNotFound) {
                            DeviceConnected(nil, iterator);
                        }
                        if ([deviceStr rangeOfString:@"adb.501.log"].location != NSNotFound) {
                            NSString *path = [[str componentsSeparatedByString:@"'"] objectAtIndex:1];
                            NSFileManager *fm = [NSFileManager defaultManager];
                            NSError *error = nil;
                            BOOL result = [fm removeItemAtPath:path error:&error];
                            if (result) {
                                NSLog(@"删除成功");
                            }else {
                                NSLog(@"删除失败");
                            }
                            DeviceConnected(nil, iterator);
                        }
                        if (([deviceStr rangeOfString:@"doesn't match this client"].location != NSNotFound) || ([deviceStr rangeOfString:@"Address already in use"].location != NSNotFound)) {
                            [[IMBAndroidDevice singleton] deviceSoftwareConflictConnectedCallBack:vendorPID idProduct:productPID];
                        }else if ([deviceStr rangeOfString:@"failed to start daemon"].location != NSNotFound) {
                            NSString *pid = [_adbManager runLsofCommand:[_adbManager checkPortOccupy]];
                            NSString *cmdStr = [NSString stringWithFormat:@"kill %@",pid];
                            char *cmd = (char *)[cmdStr UTF8String];
                            int ret = system(cmd);
                            NSLog(@"ret:%d",ret);
                            [_adbManager runADBCommand:[_adbManager killServer]];
                            [_adbManager runADBCommand:[_adbManager startServer]];
                            DeviceConnected(nil, iterator);
                        }else {
                            NSString *tmpStr = [deviceStr retain];
                            NSString *type = nil;
                            if (([deviceStr rangeOfString:@"device\n"].location != NSNotFound) || ([deviceStr rangeOfString:@"unauthorized\n"].location != NSNotFound)) {
                                if ([deviceStr rangeOfString:@"* daemon started successfully *"].location != NSNotFound) {
                                    deviceStr = [[deviceStr componentsSeparatedByString:@"* daemon started successfully *\n"] objectAtIndex:1];
                                }
                                NSString *patternStr = @"\x09+[a-zA-Z]+\x0a";
                                NSArray *newArr = [deviceStr componentsMatchedByRegex:patternStr];
                                for (NSString *str in newArr) {
                                    deviceStr = [deviceStr stringByReplacingOccurrencesOfString:str withString:@"$$$"];
                                }
                                NSArray *deviceAry = [deviceStr componentsSeparatedByString:@"$$$"];
                                if ([deviceAry count] > 2) {
                                    NSUInteger lengthAtIndex = [deviceAry count];
                                    serialNumber = [deviceAry objectAtIndex:lengthAtIndex - 2];
                                }else {
                                    serialNumber = [deviceAry objectAtIndex:0];
                                }
                                
                                NSArray *typeAry = [tmpStr componentsSeparatedByString:@"\n"];
                                if ([typeAry count] > 2) {
                                    NSUInteger lengthAtIndex = [typeAry count];
                                    type = [typeAry objectAtIndex:lengthAtIndex - 3];
                                }else {
                                    type = [typeAry objectAtIndex:0];
                                }
                                NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                    NSString *serialNumber = (NSString *)evaluatedObject;
                                    if ([serialNumber isEqualToString:serialNumber]) {
                                        return YES;
                                    }else {
                                        return NO;
                                    }
                                }];
                                NSArray *ary = [[[IMBAndroidDevice singleton] connectedDeviceArray] filteredArrayUsingPredicate:pre];
                                if ([ary count] > 0) {
                                    currentSerialNumber = [[[IMBAndroidDevice singleton] connectedDeviceArray] objectAtIndex:0];
                                }else {
                                    [[[IMBAndroidDevice singleton] connectedDeviceArray] addObject:serialNumber];
                                    currentSerialNumber = [[[IMBAndroidDevice singleton] connectedDeviceArray] objectAtIndex:0];
                                }
                            }
                            
                            if (tmpStr.length > 5) {
                                /**
                                 *  SAMSUNG  1256
                                 *  LGE      4100
                                 *  HTC      2996
                                 *  HUAWEI   4817
                                 *  SONY     4046
                                 *  MOTOROLA 8888
                                 *  Google   6353
                                 */
                                NSArray *matchedConnectionArray = @[@"1256", @"6353", @"2996", @"4817", @"4046"];
                                BOOL isHasCurrentCustomVersion = YES;//发布定制版本前改变此值为NO即可
                                BOOL isHasCurrentMismatchedConnection = NO;
#if Android_Samsung
                                if (vendorPID == 1256) {
                                    isHasCurrentCustomVersion = YES;
                                }else if ([matchedConnectionArray containsObject:[NSString stringWithFormat:@"%d", vendorPID]]) {
                                    isHasCurrentMismatchedConnection = YES;
                                }
#elif Android_LG
                                if (vendorPID == 4100) {
                                    isHasCurrentCustomVersion = YES;
                                }else if ([matchedConnectionArray containsObject:[NSString stringWithFormat:@"%d", vendorPID]]) {
                                    isHasCurrentMismatchedConnection = YES;
                                }
#elif Android_HTC
                                if (vendorPID == 2996) {
                                    isHasCurrentCustomVersion = YES;
                                }else if ([matchedConnectionArray containsObject:[NSString stringWithFormat:@"%d", vendorPID]]) {
                                    isHasCurrentMismatchedConnection = YES;
                                }
#elif Android_Huawei
                                if (vendorPID == 4817) {
                                    isHasCurrentCustomVersion = YES;
                                }else if ([matchedConnectionArray containsObject:[NSString stringWithFormat:@"%d", vendorPID]]) {
                                    isHasCurrentMismatchedConnection = YES;
                                }
#elif Android_Sony
                                if (vendorPID == 4046) {
                                    isHasCurrentCustomVersion = YES;
                                }else if ([matchedConnectionArray containsObject:[NSString stringWithFormat:@"%d", vendorPID]]) {
                                    isHasCurrentMismatchedConnection = YES;
                                }
#elif Android_Motorola
                                if (vendorPID == 8888) {
                                    isHasCurrentCustomVersion = YES;
                                }else if ([matchedConnectionArray containsObject:[NSString stringWithFormat:@"%d", vendorPID]]) {
                                    isHasCurrentMismatchedConnection = YES;
                                }
#elif Android_Google
                                if (vendorPID == 6353) {
                                    isHasCurrentCustomVersion = YES;
                                }else if ([matchedConnectionArray containsObject:[NSString stringWithFormat:@"%d", vendorPID]]) {
                                    isHasCurrentMismatchedConnection = YES;
                                }
#endif
                                isConnected = YES;
                                isOpenUSB = YES;
                                [[[IMBAndroidDevice singleton] connectedDeviceDictionary] setValue:@"YES" forKey:currentSerialNumber?currentSerialNumber:newSerialNumber];
                                NSLog(@"No Debug Dict: %@", [[IMBAndroidDevice singleton] connectedDeviceDictionary]);
                                //检测是否为定制版本
                                if (isHasCurrentCustomVersion) {
                                    //检测是否打开USB调试模式
                                    if ([type rangeOfString:@"device"].location != NSNotFound) {
                                        if ([deviceStr rangeOfString:@"* daemon started successfully *"].location != NSNotFound) {
                                            deviceStr = [[deviceStr componentsSeparatedByString:@"* daemon started successfully *\n"] objectAtIndex:1];
                                        }
                                        NSString *patternStr = @"\x09+[a-zA-Z]+\x0a";
                                        NSArray *newArr = [deviceStr componentsMatchedByRegex:patternStr];
                                        for (NSString *str in newArr) {
                                            deviceStr = [deviceStr stringByReplacingOccurrencesOfString:str withString:@"$$$"];
                                        }
                                        NSArray *deviceAry = [deviceStr componentsSeparatedByString:@"$$$"];
                                        if ([deviceAry count] > 2) {
                                            NSUInteger lengthAtIndex = [deviceAry count];
                                            serialNumber = [deviceAry objectAtIndex:lengthAtIndex - 2];
                                        }else {
                                            serialNumber = [deviceAry objectAtIndex:0];
                                        }
                                        if (serialNumber) {
                                            //连接
                                            if (isConnected) {
                                                [[IMBAndroidDevice singleton] deviceConnectedcallBack:vendorPID idProduct:productPID withDeviceName:[[IMBAndroidDevice singleton] deviceManufacturer] withSerialNumber:serialNumber];
                                            }
                                        }
                                    }
                                    //检测是否为信任设备
                                    else if ([type rangeOfString:@"unauthorized"].location != NSNotFound) {
                                        if (isConnected) {
                                            if ([deviceStr rangeOfString:@"* daemon started successfully *"].location != NSNotFound) {
                                                deviceStr = [[deviceStr componentsSeparatedByString:@"* daemon started successfully *\n"] objectAtIndex:1];
                                            }
                                            NSString *patternStr = @"\x09+[a-zA-Z]+\x0a";
                                            NSArray *newArr = [deviceStr componentsMatchedByRegex:patternStr];
                                            for (NSString *str in newArr) {
                                                deviceStr = [deviceStr stringByReplacingOccurrencesOfString:str withString:@"$$$"];
                                            }
                                            NSArray *deviceAry = [deviceStr componentsSeparatedByString:@"$$$"];
                                            if ([deviceAry count] > 2) {
                                                NSUInteger lengthAtIndex = [deviceAry count];
                                                serialNumber = [deviceAry objectAtIndex:lengthAtIndex - 2];
                                            }else {
                                                serialNumber = [deviceAry objectAtIndex:0];
                                            }
                                            if (serialNumber) {
                                                //未信任设备
                                                [[IMBAndroidDevice singleton] deviceUnauthorizedConnectedCallBack:vendorPID idProduct:productPID withDeviceName:[[IMBAndroidDevice singleton] deviceManufacturer] withSerialNumber:serialNumber];
                                            }
                                        }
                                    }
                                }else if (isHasCurrentMismatchedConnection) {
                                    if ([deviceStr rangeOfString:@"* daemon started successfully *"].location != NSNotFound) {
                                        deviceStr = [[deviceStr componentsSeparatedByString:@"* daemon started successfully *\n"] objectAtIndex:1];
                                    }
                                    NSString *patternStr = @"\x09+[a-zA-Z]+\x0a";
                                    NSArray *newArr = [deviceStr componentsMatchedByRegex:patternStr];
                                    for (NSString *str in newArr) {
                                        deviceStr = [deviceStr stringByReplacingOccurrencesOfString:str withString:@"$$$"];
                                    }
                                    NSArray *deviceAry = [deviceStr componentsSeparatedByString:@"$$$"];
                                    if ([deviceAry count] > 2) {
                                        NSUInteger lengthAtIndex = [deviceAry count];
                                        serialNumber = [deviceAry objectAtIndex:lengthAtIndex - 2];
                                    }else {
                                        serialNumber = [deviceAry objectAtIndex:0];
                                    }
                                    if (serialNumber) {
                                        //非匹配版本
                                        [[IMBAndroidDevice singleton] deviceConnectedIsMactchedConnectionCallBack:vendorPID idProduct:productPID withSerialNumber:serialNumber];
                                    }
                                }else {
                                    if ([deviceStr rangeOfString:@"* daemon started successfully *"].location != NSNotFound) {
                                        deviceStr = [[deviceStr componentsSeparatedByString:@"* daemon started successfully *\n"] objectAtIndex:1];
                                    }
                                    NSString *patternStr = @"\x09+[a-zA-Z]+\x0a";
                                    NSArray *newArr = [deviceStr componentsMatchedByRegex:patternStr];
                                    for (NSString *str in newArr) {
                                        deviceStr = [deviceStr stringByReplacingOccurrencesOfString:str withString:@"$$$"];
                                    }
                                    NSArray *deviceAry = [deviceStr componentsSeparatedByString:@"$$$"];
                                    if ([deviceAry count] > 2) {
                                        NSUInteger lengthAtIndex = [deviceAry count];
                                        serialNumber = [deviceAry objectAtIndex:lengthAtIndex - 2];
                                    }else {
                                        serialNumber = [deviceAry objectAtIndex:0];
                                    }
                                    if (serialNumber) {
                                        //非定制版本
                                        [[IMBAndroidDevice singleton] deviceConnectedIsCustomVersionCallBack:vendorPID idProduct:productPID withSerialNumber:serialNumber];
                                    }
                                }
                            }else {
                                NSString *result = (NSString *)[[[IMBAndroidDevice singleton] connectedDeviceDictionary] objectForKey:currentSerialNumber?currentSerialNumber:newSerialNumber];
                                if (result) {
                                    if ([result isEqualToString:@"YES"]) {
                                        isConnected = YES;
                                        isOpenUSB = YES;
                                        [[[IMBAndroidDevice singleton] connectedDeviceDictionary] setValue:@"YES" forKey:currentSerialNumber?currentSerialNumber:newSerialNumber];
                                    }else {
                                        isConnected = NO;
                                        isOpenUSB = NO;
                                        [[[IMBAndroidDevice singleton] connectedDeviceDictionary] setValue:@"NO" forKey:currentSerialNumber?currentSerialNumber:newSerialNumber];
                                    }
                                }
                                NSLog(@"Debug Dict: %@", [[IMBAndroidDevice singleton] connectedDeviceDictionary]);
                                //检测未打开USB调试模式
                                [[IMBAndroidDevice singleton] deviceUSBDebugModelConnectedCallBack:vendorPID idProduct:productPID];
                            }
                        }
                    }
                    CFRelease(idVendor);
                    CFRelease(idProduct);
                    if (productName != NULL) {
                        CFRelease(productName);
                    }
                });
            }
        }
    }
}

void DeviceDisconnected( void *refCon, io_iterator_t iterator )
{
    kern_return_t    returnCode = KERN_FAILURE;
    io_object_t      usbDevice;
    
    while ( ( usbDevice = IOIteratorNext( iterator ) ) )
    {
        CFNumberRef idVendor = (CFNumberRef)IORegistryEntrySearchCFProperty(usbDevice, kIOServicePlane, CFSTR(kUSBVendorID), kCFAllocatorDefault, 0);
        
        CFNumberRef idProduct = (CFNumberRef)IORegistryEntrySearchCFProperty(usbDevice, kIOServicePlane, CFSTR(kUSBProductID), kCFAllocatorDefault, 0);
        CFStringRef productName = (CFStringRef)IORegistryEntrySearchCFProperty(usbDevice, kIOServicePlane, CFSTR(kUSBVendorString), kCFAllocatorDefault, 0);
        uint16_t vendorPID;
        CFNumberGetValue(idVendor, kCFNumberSInt16Type, (void *)&vendorPID);
        uint16_t productPID;
        CFNumberGetValue(idProduct, kCFNumberSInt16Type, (void *)&productPID);
        NSLog(@"DeviceDisconnected");
        NSString *productNameStr = (__bridge NSString*)productName;
        if ([productNameStr rangeOfString:@"Apple"].location == NSNotFound) {
            IMBAdbManager *adb = [IMBAdbManager singleton];
            [adb runADBCommand:[adb startServer]];
            sleep(1);
            NSString *deviceStr = [adb runADBCommand:[adb connectDevices]];
            if ([deviceStr rangeOfString:[NSString stringWithFormat:@"%@", [[IMBAndroidDevice singleton] serialNo]]].location != NSNotFound) {
                isOpenUSB = YES;
                isConnected = YES;
            }
            NSString *tmpDevice = @"";
            if ([[[IMBAndroidDevice singleton] connectedDeviceArray] count] > 0) {
                tmpDevice = [[[[IMBAndroidDevice singleton] connectedDeviceArray] objectAtIndex:0] retain];
            }
            if (!isConnected && !isOpenUSB) {
                NSLog(@"DisConnected Dict: %@", [[IMBAndroidDevice singleton] connectedDeviceDictionary]);
                if ([[IMBAndroidDevice singleton] checkDeviceisSupported:vendorPID]&&productName != NULL) {
                    if ([[IMBAndroidDevice singleton] serialNo]) {
                        if ([[[IMBAndroidDevice singleton] connectedDeviceDictionary].allKeys containsObject:[[IMBAndroidDevice singleton] serialNo]]) {
                            [[[IMBAndroidDevice singleton] connectedDeviceDictionary] removeObjectForKey:[[IMBAndroidDevice singleton] serialNo]];
                        }
                        [[IMBAndroidDevice singleton] deviceDisConnectedcallBack:vendorPID idProduct:productPID withSerialNumber:[[IMBAndroidDevice singleton] serialNo]];
                    }
                }
                CFRelease(idVendor);
                CFRelease(idProduct);
                if (productName != NULL) {
                    CFRelease(productName);
                }
                returnCode = IOObjectRelease( usbDevice );
                if ( returnCode != kIOReturnSuccess )
                {
                    NSLog( @"Couldn't release raw device object: %08x.", returnCode );
                }
                returnCode = IOObjectRelease(iterator);
                if (returnCode != kIOReturnSuccess) {
                    NSLog(@"Couldn't release: %08x.", returnCode);
                }
                CleanUp();
            }else {
                NSString *device = [[deviceStr componentsSeparatedByString:@"List of devices attached\n"] objectAtIndex:1];
                if (device.length > 5) {
                    if ([deviceStr rangeOfString:tmpDevice].location != NSNotFound) {
                        isConnected = NO;
                    }else {
                        isConnected = YES;
                        isOpenUSB = NO;
                    }
                    if (isConnected) {
                        NSString *result = (NSString *)[[[IMBAndroidDevice singleton] connectedDeviceDictionary] objectForKey:tmpDevice];
                        NSLog(@"DisConnected Dict: %@", [[IMBAndroidDevice singleton] connectedDeviceDictionary]);
                        NSLog(@"result: %@", result);
                        [[[IMBAndroidDevice singleton] connectedDeviceArray] removeAllObjects];
                        if (!isOpenUSB) {
                            if ([[IMBAndroidDevice singleton] checkDeviceisSupported:vendorPID]&&productName != NULL) {
                                if ([[IMBAndroidDevice singleton] serialNo]) {
                                    if ([[[IMBAndroidDevice singleton] connectedDeviceDictionary].allKeys containsObject:[[IMBAndroidDevice singleton] serialNo]]) {
                                        [[[IMBAndroidDevice singleton] connectedDeviceDictionary] removeObjectForKey:[[IMBAndroidDevice singleton] serialNo]];
                                    }
                                    [[IMBAndroidDevice singleton] deviceDisConnectedcallBack:vendorPID idProduct:productPID withSerialNumber:[[IMBAndroidDevice singleton] serialNo]];
                                }
                            }
                            CFRelease(idVendor);
                            CFRelease(idProduct);
                            if (productName != NULL) {
                                CFRelease(productName);
                            }
                            returnCode = IOObjectRelease( usbDevice );
                            if ( returnCode != kIOReturnSuccess )
                            {
                                NSLog( @"Couldn't release raw device object: %08x.", returnCode );
                            }
                            returnCode = IOObjectRelease(iterator);
                            if (returnCode != kIOReturnSuccess) {
                                NSLog(@"Couldn't release: %08x.", returnCode);
                            }
                        }else {
                            isConnected = NO;
                            isOpenUSB = YES;
                        }
                        CleanUp();
                    }else {
                        isOpenUSB = YES;
                        isConnected = YES;
                    }
                }else {
                    [[[IMBAndroidDevice singleton] connectedDeviceArray] removeAllObjects];
                    if ([[IMBAndroidDevice singleton] checkDeviceisSupported:vendorPID]&&productName != NULL) {
                        if ([[IMBAndroidDevice singleton] serialNo]) {
                            if ([[[IMBAndroidDevice singleton] connectedDeviceDictionary].allKeys containsObject:[[IMBAndroidDevice singleton] serialNo]]) {
                                [[[IMBAndroidDevice singleton] connectedDeviceDictionary] removeObjectForKey:[[IMBAndroidDevice singleton] serialNo]];
                            }
                            [[IMBAndroidDevice singleton] deviceDisConnectedcallBack:vendorPID idProduct:productPID withSerialNumber:[[IMBAndroidDevice singleton] serialNo]];
                        }
                    }
                    CFRelease(idVendor);
                    CFRelease(idProduct);
                    if (productName != NULL) {
                        CFRelease(productName);
                    }
                    returnCode = IOObjectRelease( usbDevice );
                    if ( returnCode != kIOReturnSuccess )
                    {
                        NSLog( @"Couldn't release raw device object: %08x.", returnCode );
                    }
                    returnCode = IOObjectRelease(iterator);
                    if (returnCode != kIOReturnSuccess) {
                        NSLog(@"Couldn't release: %08x.", returnCode);
                    }
                    CleanUp();
                }
            }
        }
    }
}

#pragma mark -- 设备回调方法
- (void)deviceConnectedUSBMessageCallBack
{
    if ([_delegate respondsToSelector:@selector(deviceConnectedUSBMessage)]) {
        [_delegate deviceConnectedUSBMessage];
    }
}

- (void)deviceConnectedcallBack:(uint16_t)idVendor idProduct:(uint16_t)idProduct withDeviceName:(NSString *)name withSerialNumber:(NSString *)serialNumber
{
    if (serialNumber) {
        if (![_connectedDeviceArray containsObject:serialNumber]) {
            [_connectedDeviceArray addObject:serialNumber];
        }
    }
    _isOpenUSBDebugModel = YES;
    if ([_delegate respondsToSelector:@selector(deviceConnected:)]) {
        [_delegate deviceConnected:@{@"idVendor": @(idVendor),@"idProduct":@(idProduct), @"isOpenUSBDebugModel": @YES, @"deviceName": name, @"serailNumber": serialNumber}];
    }
}

- (void)deviceDisConnectedcallBack:(uint16_t)idVendor idProduct:(uint16_t)idProduct withSerialNumber:(NSString *)serialNumber
{
    if ([_delegate respondsToSelector:@selector(deviceConnected:)]) {
        [_delegate deviceDisconnected:@{@"idVendor": @(idVendor),@"idProduct":@(idProduct), @"serailNumber": serialNumber}];
    }
}

- (void)deviceSoftwareConflictConnectedCallBack:(uint16_t)idVendor idProduct:(uint16_t)idProduct {
    _isOpenUSBDebugModel = YES;
    if ([_delegate respondsToSelector:@selector(deviceSoftwareConflictConnected:)]) {
        [_delegate deviceSoftwareConflictConnected:@{@"idVendor": @(idVendor), @"idProduct": @(idProduct)}];
    }
}

- (void)deviceUnauthorizedConnectedCallBack:(uint16_t)idVendor idProduct:(uint16_t)idProduct withDeviceName:(NSString *)name withSerialNumber:(NSString *)serialNumber {
    if (serialNumber) {
        if (![_connectedDeviceArray containsObject:serialNumber]) {
            [_connectedDeviceArray addObject:serialNumber];
        }
    }
    _isOpenUSBDebugModel = YES;
    if ([_delegate respondsToSelector:@selector(deviceUnauthorizedConnected:)]) {
        [_delegate deviceUnauthorizedConnected:@{@"idVendor": @(idVendor), @"idProduct": @(idProduct), @"deviceName": name, @"serailNumber": serialNumber}];
    }
}

- (void)deviceMediaDeviceMTPModelConnectedCallBack:(uint16_t)idVendor idProduct:(uint16_t)idProduct {
    _isOpenUSBDebugModel = YES;
    if ([_delegate respondsToSelector:@selector(deviceMediaDeviceMTPModelConnected:)]) {
        [_delegate deviceMediaDeviceMTPModelConnected:@{@"idVendor": @(idVendor), @"idProduct": @(idProduct), @"isOpenUSBDebugModel": @NO}];
    }
}

- (void)deviceUSBDebugModelConnectedCallBack:(uint16_t)idVendor idProduct:(uint16_t)idProduct {
    _isOpenUSBDebugModel = NO;
    if ([_delegate respondsToSelector:@selector(deviceUSBDebugModelConnected:)]) {
        [_delegate deviceUSBDebugModelConnected:@{@"idVendor": @(idVendor), @"idProduct": @(idProduct), @"isOpenUSBDebugModel": @NO}];
    }
}

- (void)deviceConnectedIsMactchedConnectionCallBack:(uint16_t)idVendor idProduct:(uint16_t)idProduct withSerialNumber:(NSString *)serialNumber {
    if (serialNumber) {
        if (![_connectedDeviceArray containsObject:serialNumber]) {
            [_connectedDeviceArray addObject:serialNumber];
        }
    }
    if ([_delegate respondsToSelector:@selector(deviceConnectedIsMatchedConnection:)]) {
        [_delegate deviceConnectedIsMatchedConnection:@{@"idVendor": @(idVendor), @"idProduct": @(idProduct), @"serailNumber": serialNumber}];
    }
}

- (void)deviceConnectedIsCustomVersionCallBack:(uint16_t)idVendor idProduct:(uint16_t)idProduct withSerialNumber:(NSString *)serialNumber {
    if (serialNumber) {
        if (![_connectedDeviceArray containsObject:serialNumber]) {
            [_connectedDeviceArray addObject:serialNumber];
        }
        if ([_delegate respondsToSelector:@selector(deviceConnectedIsCustomVersion:)]) {
            [_delegate deviceConnectedIsCustomVersion:@{@"idVendor": @(idVendor), @"idProduct": @(idProduct), @"serailNumber": serialNumber}];
        }
    }else {
        if ([_delegate respondsToSelector:@selector(deviceConnectedIsCustomVersion:)]) {
            [_delegate deviceConnectedIsCustomVersion:@{@"idVendor": @(idVendor), @"idProduct": @(idProduct), @"serailNumber": @"unknownSerialNumber"}];
        }
    }
}

#pragma mark -- 检查支持的android设备
- (BOOL)checkDeviceisSupported:(uint16_t)vendorPID
{
    NSPredicate *cate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSDictionary *dic = (NSDictionary *)evaluatedObject;
        NSDictionary *deviceDic = [dic objectForKey:@"matchingDictionary"];
        uint16_t verdor = [[deviceDic objectForKey:@"idVendor"] shortValue];
        if (verdor == vendorPID) {
            self.deviceManufacturer = [dic objectForKey:@"deviceName"];
            return YES;
        }else{
            return NO;
        }
    }];
    NSArray *resultArray = [_supportDeviceArray filteredArrayUsingPredicate:cate];
    if ([resultArray count]>=1) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)hasOpenUSBDebugModel {
    BOOL res = NO;
    if (_isOpenUSBDebugModel) {
        res = YES;
        return res;
    }
    return res;
}

@end
