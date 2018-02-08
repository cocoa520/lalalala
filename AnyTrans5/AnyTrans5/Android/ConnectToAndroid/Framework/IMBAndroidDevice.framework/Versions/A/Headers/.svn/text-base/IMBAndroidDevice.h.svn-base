//
//  IMBAndroidDevice.h
//  IMBAndroidDevice
//
//  Created by JGehry on 3/13/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMBAndroidDeviceDelegate <NSObject>
@optional
//deviceDic @"idVendor"  @"idProduct"

/**
 *  设备正常连接
 */
- (void)deviceConnected:(NSDictionary *)deviceDic;

/**
 *  设备断开连接
 */
- (void)deviceDisconnected:(NSDictionary *)deviceDic;

/**
 *  设备软件冲突连接
 *
 */
- (void)deviceSoftwareConflictConnected:(NSDictionary *)deviceDic;

/**
 *  未信任设备连接
 */
- (void)deviceUnauthorizedConnected:(NSDictionary *)deviceDic;

/**
 *  未开启媒体设备MTP模式
 */
- (void)deviceMediaDeviceMTPModelConnected:(NSDictionary *)deviceDic;

/**
 *  未开启USB调试模式
 */
- (void)deviceUSBDebugModelConnected:(NSDictionary *)deviceDic;

/**
 *  非匹配版本
 */
- (void)deviceConnectedIsMatchedConnection:(NSDictionary *)deviceDic;

/**
 *  非定制版本
 */
- (void)deviceConnectedIsCustomVersion:(NSDictionary *)deviceDic;

@end

@interface IMBAndroidDevice : NSObject {
    NSArray *_supportDeviceArray;
    NSMutableArray *_connectedDeviceArray;
    NSMutableDictionary *_connectedDeviceDictionary;
    id <IMBAndroidDeviceDelegate> _delegate;
    
    BOOL _isOpenUSBDebugModel;
}

@property (nonatomic, readwrite, retain) NSMutableArray *connectedDeviceArray;
@property (nonatomic, readwrite, retain) NSMutableDictionary *connectedDeviceDictionary;
@property (nonatomic, assign) BOOL isOpenUSBDebugModel;

+ (IMBAndroidDevice*)singleton;
- (void)startListen:(id<IMBAndroidDeviceDelegate>)delegate;

- (BOOL)hasOpenUSBDebugModel;
- (void)deviceSoftwareConflictConnectedCallBack:(uint16_t)idVendor idProduct:(uint16_t)idProduct;
@end
