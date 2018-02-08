//
//  DeviceAccessManager.h
//  
//
//  Created by JGehry on 3/2/17.
//
//

#import <Foundation/Foundation.h>
//#import <IMBAndroidDevice/IMBAndroidDevice.h>
#import "IMBAndroidDevice.h"
#import "DeviceInfo.h"
#import "IMBAndroid.h"

@protocol DeviceAccessDelegate <NSObject>

@optional
- (void)showMessage:(NSString *)message;

@end

@interface DeviceAccessManager : NSObject<IMBAndroidDeviceDelegate> {
    IMBAndroidDevice *_listener;
    IMBAdbManager *_adbManager;
    id <DeviceAccessDelegate> _delegate;
    NSNotificationCenter *_nc;
    NSMutableDictionary *_devicePool; //连接设备池
    
    NSString *_apkPath;
    NSString *_installError;
}

/**
 *  devicePool            连接设备池
 *  apkPath               apk路径
 */
@property (nonatomic, assign) id <DeviceAccessDelegate> delegate;
@property (nonatomic, readwrite, retain) NSMutableDictionary *devicePool;
@property (nonatomic, readwrite, retain) NSString *apkPath;

/**
 *  是否信任此设备，每次连接前判断
 *
 *  @param dict key=@"deviceName" value=设备品牌名称
 *
 *  @return YES or NO
 */
- (BOOL)isUnauthorizedDevice:(NSDictionary *)dict;//是否信任此设备，每次连接前判断

/**
 *  是否打开USB调试模式
 *
 *  @return YES or NO
 */
- (BOOL)hasOpenUSBDebugModel:(NSDictionary *)dict;

/**
 *  下载Apk
 *
 *  @return YES or NO
 */
- (BOOL)uninstallAPK;

/**
 *  是否打开USB调试模式
 *
 *  @param dict = @{@"idVendor": @(idVendor), @"idProduct": @(idProduct), @"isOpenUSBDebugModel": @NO}
 *
 *  @return YES or NO
 */
- (void)deviceUSBDebugModelConnected:(NSDictionary *)deviceDic;

- (void)setIsDevicePause:(BOOL)isPause;

#pragma mark - 获取设备方法
- (NSInteger)deviceCount;
- (void)addAndroidByKey:(IMBAndroid *)android deviceKey:(NSString*)deviceKey;
- (void)removeAndroidByKey:(NSString*)deviceKey;
- (IMBAndroid *)getAndroidByKey:(NSString*)deviceKey;
- (BOOL)checkAndroidExsit:(NSString*)deviceKey;
- (NSArray*)getOtherConnectedAndroid:(NSString*)deviceKey;
- (NSArray*)getConnectedAndroid;
- (IMBAndroid *)getNextConnectedAndroid;

@end
