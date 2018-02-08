//
//  IMBDeleteCameraRollPhotos.m
//  PhotoTrans
//
//  Created by iMobie on 11/22/13.
//  Copyright (c) 2013 iMobie. All rights reserved.
//

#import "IMBDeleteCameraRollPhotos.h"
#import "IMBSoftWareInfo.h"
#import "IMBDeviceInfo.h"
#import "IMBPhotoEntity.h"

@implementation IMBDeleteCameraRollPhotos
@synthesize isDeleteComplete = _isDeleteComplete;

- (id)initWithIPod:(IMBiPod *)ipod deleteArray:(NSMutableArray *)deleteArray
{
    if (self = [super initWithIPod:ipod deleteArray:deleteArray]) {
        removePhotosArray = [[NSMutableArray alloc]init];
        counts = 0;
        _isDeleteComplete = NO;
        _processQueue = [[NSOperationQueue alloc] init];
        [_processQueue setMaxConcurrentOperationCount:3];
    }
    return self;
}

-(id)initWithArray:(NSArray *)array withIpod:(IMBiPod *)ipod{
    self = [super init];
    if (self) {
        _ipod = [ipod retain];
//        _deleteArray = [array retain];
        _deleteArray = [[NSMutableArray alloc]initWithArray:array];
        logHandle = [IMBLogManager singleton];
        removePhotosArray = [[NSMutableArray alloc]init];
        counts = 0;
        _isDeleteComplete = NO;
        _processQueue = [[NSOperationQueue alloc] init];
        [_processQueue setMaxConcurrentOperationCount:3];
    }
    return self;
}


- (void)dealloc
{
    if (removePhotosArray != nil) {
        [removePhotosArray release];
        removePhotosArray = nil;
    }
    if (_processQueue != nil) {
        [_processQueue release];
        _processQueue = nil;
    }
    [super dealloc];
}


-(void)startDeviceBrowser{
    // ToDo 检测共享限制部分  并将结果写入共享配置文件中
//    IMBSoftWareInfo *softWareInfo = [IMBSoftWareInfo singleton];
//    if (softWareInfo != nil && softWareInfo.isNeedRegister &&softWareInfo.isRegistered == false) {
//        [softWareInfo addLimitCount:_iPod.deviceInfo.serialNumber ImpCount:0 ExpCount:0 DelCount:deleteArray.count];
//    }
//    [_processQueue addOperationWithBlock:^(void){
        if (mDeviceBrowser != nil) {
            mDeviceBrowser.delegate = NULL;
            [mDeviceBrowser stop];
            [mDeviceBrowser release];
            mDeviceBrowser = nil;
        }
        mDeviceBrowser = [[ICDeviceBrowser alloc] init];
//        mCameras = [[NSMutableArray alloc] init];
        mDeviceBrowser.delegate = self;
        mDeviceBrowser.browsedDeviceTypeMask = mDeviceBrowser.browsedDeviceTypeMask | ICDeviceTypeMaskCamera | ICDeviceLocationTypeMaskLocal | ICDeviceLocationTypeMaskShared | ICDeviceLocationTypeMaskBonjour | ICDeviceLocationTypeMaskBluetooth | ICDeviceLocationTypeMaskRemote;
        [mDeviceBrowser start];
//    }];
}

- (void)openSession {
    if (mDevice != nil) {
        if (![mDevice hasOpenSession]) {
            [mDevice requestOpenSession];
        } else {
            [self closeSession];
            [mDevice requestOpenSession];
        }
    }
}

- (void)closeSession {
    if (mDevice != nil) {
        if ([mDevice hasOpenSession]) {
            [mDevice requestCloseSession];
        }
    }
}

- (void)deviceBrowser:(ICDeviceBrowser*)browser didAddDevice:(ICDevice*)device moreComing:(BOOL)moreComing {
    NSLog(@"Device Name is %@", device.name);
    /*[self willChangeValueForKey:@"cameras"];
     [mCameras addObject:device];
     [self didChangeValueForKey:@"cameras"];*/
    
    if ([_ipod.deviceInfo.serialNumberForHashing isEqualToString:device.serialNumberString]) {
        [_logManager writeInfoLog: [NSString stringWithFormat:@"Add device, device serialNumberForHashing: %@", device.serialNumberString]];
        if (device.type & ICDeviceTypeCamera) {
            mDevice = [device retain];
            mDevice.delegate = self;
            [self openSession];
        }
    }
}

- (void)deviceBrowser:(ICDeviceBrowser*)browser didRemoveDevice:(ICDevice*)device moreGoing:(BOOL)moreGoing {
    if (mDevice != nil && [device.serialNumberString isEqualToString:mDevice.serialNumberString]) {
        [_logManager writeInfoLog: [NSString stringWithFormat:@"Remove device, device serialNumberForHashing: %@", mDevice.serialNumberString]];
        [self closeSession];
        [mDevice release];
        mDevice = nil;
    }
}

- (void)didRemoveDevice:(ICDevice*)removedDevice{
    NSLog( @"didRemoveDevice: \n%@\n", removedDevice );
    if (mDevice != nil && [removedDevice.serialNumberString isEqualToString:mDevice.serialNumberString]) {
        [self closeSession];
        [mDevice release];
        mDevice = nil;
    }
}

- (void)device:(ICDevice*)device didOpenSessionWithError:(NSError*)error{
    NSLog( @"device:didOpenSessionWithError: \n" );
    NSLog( @"  device: %@\n", device );
    NSLog( @"  error : %@\n", error );
    // 得到是否开启Session成功
    BOOL state = [device hasOpenSession];
    [_logManager writeInfoLog:[NSString stringWithFormat:@"is open session:%d",state]];
    if (mDevice != nil && [device.serialNumberString isEqualToString:mDevice.serialNumberString]) {
        [_logManager writeInfoLog:[NSString stringWithFormat:@"Camera open session error is %@", error]];
    }
}

- (void)deviceDidBecomeReady:(ICCameraDevice*)camera;{
    // 得到设备里面的文件,然后就可以向camera发送- (void)requestDeleteFiles:(NSArray*)files;方法进行删除文件.其他的类推.
    NSArray *mediaFileList = camera.mediaFiles;
    [_logManager writeInfoLog:[NSString stringWithFormat:@"delete array count:%d; media files count:%d",_deleteArray.count,mediaFileList.count]];
    if (_deleteArray != nil && _deleteArray.count > 0 && mediaFileList.count > 0) {
        for (IMBPhotoEntity *entity in _deleteArray) {
            @autoreleasepool {
                NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    ICCameraFile *item = evaluatedObject;
                    NSLog(@"%@ %@",item.name,entity.photoName);
                    if ([item.name isEqualToString:entity.photoName]) {
                        return YES;
                    }else
                    {
                        return NO;
                    }
                    
                }];
                //目的设备中的同名数组
                NSArray *sameNameArr = [mediaFileList filteredArrayUsingPredicate:predicate];
                if (sameNameArr != nil && sameNameArr.count > 0) {
                    ICCameraFile *item = [sameNameArr objectAtIndex:0];
                    [_logManager writeInfoLog:[NSString stringWithFormat:@"entity name:%@  ; item name:%@",entity.photoName,item.name]];
                    [removePhotosArray addObject:item];
                    counts += 1;
                }
            }
        }
        if (camera != nil && removePhotosArray.count > 0) {
            [camera requestDeleteFiles:removePhotosArray];
        }else {
            _isDeleteComplete = YES;
        }
    }else {
        _isDeleteComplete = YES;
    }
}

- (void)device:(ICDevice*)device didCloseSessionWithError:(NSError*)error{
    if (device != nil) {
        [_logManager writeInfoLog:[NSString stringWithFormat:@"Camera close session error is %@  device serialNember:%@", error, device.serialNumberString]];
    }
}

- (void)device:(ICDevice*)device didEncounterError:(NSError*)error{
    NSBeginAlertSheet(
                      NULL,
                      @"OK",
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      NULL,
                      [error localizedDescription],
                      NULL
                      );
}

- (void)cameraDevice:(ICCameraDevice*)device didAddItem:(ICCameraItem*)item{
    //    NSLog( @"cameraDevice1: \n%@\ndidAddItem: \n%@\n", device, item );
}

- (void)cameraDevice:(ICCameraDevice*)camera didRemoveItems:(NSArray*)items{
//    NSLog( @"cameraDevice3: \n%@\ndidRemoveItems: \n%@\n", camera, items );
    //NSLog(@"counts:%d",counts);
    if (counts == removePhotosArray.count) {
        
    }
}

- (void)cameraDevice:(ICCameraDevice*)scanner didCompleteDeleteFilesWithError:(NSError*)error {
    _isDeleteComplete = YES;
    [_logManager writeInfoLog:[NSString stringWithFormat:@"Request Delete Files, Remove files count: %d",counts]];
    if (mDevice != nil) {
        [self closeSession];
        [mDevice release];
        mDevice = nil;
    }
    if (mDeviceBrowser != nil) {
        mDeviceBrowser.delegate = NULL;
        [mDeviceBrowser stop];
        [mDeviceBrowser release];
        mDeviceBrowser = nil;
    }
}

- (void)deleteItem{
    [_logManager writeInfoLog:[NSString stringWithFormat:@"Request Delete Files, Remove files count: %d",removePhotosArray.count]];
    for (NSMutableArray *item in removePhotosArray) {
        if (mDevice != nil) {
            [(ICCameraDevice *)mDevice requestDeleteFiles:item];
        }
        counts -= 1;
    }
    if (removePhotosArray.count == 0) {
    }
}

@end
