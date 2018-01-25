//
//  IMBDeviceViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBDeviceViewController.h"
#import "IMBDisconnectViewController.h"
#import "IMBDeviceConnection.h"
#import "IMBDeviceInfo.h"
#import "IMBiPod.h"
#import "IMBMainWindowController.h"



@interface IMBDeviceViewController ()

{
    @private
    IMBDisconnectViewController *_disConnectController;
    NSMutableArray *_devicesArray;
    IMBMainWindowController *_mainWindowController;
}

@end

@implementation IMBDeviceViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

/**
 * 初始化操作
 */
- (void)awakeFromNib {
    [self setupView];
    [self deviceConnection];
    [self addNotis];
    
}


- (void)setupView {
    _disConnectController = [[IMBDisconnectViewController alloc] initWithNibName:@"IMBDisconnectViewController" bundle:nil];
    [_deviceBox addSubview:_disConnectController.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_mainWindowController == nil) {
            _mainWindowController = (IMBMainWindowController *)[self.view.window.windowController retain];
            [_mainWindowController configButtonName:@"No Device Connected" WithTextColor:IMBGrayColor(51) WithTextSize:12.0f WithIsShowIcon:YES WithIsShowTrangle:NO WithIsDisable:YES withConnectType:0];
        }
    });
}

- (void)addNotis {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedDeviceDidChangeNoti:) name:IMBSelectedDeviceDidChangeNoti object:nil];
}

- (void)deviceConnection {
    
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    [deviceConnection startListening];
    
//    __block typeof(self) weakSelf = self;
    deviceConnection.IMBDeviceConnected = ^{
        //设备连接成功
        [self deviceConnected];
    };
    deviceConnection.IMBDeviceDisconnected = ^(NSString *serialNum){
        //设备断开连接
        
        if (deviceConnection.allDevices.count) {
            IMBBaseInfo *baseInfo = [[deviceConnection.allDevices lastObject] retain];
            [_mainWindowController configButtonName:baseInfo.deviceName WithTextColor:IMBGrayColor(51) WithTextSize:12.0f WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:baseInfo.connectType];
            [baseInfo release];
            baseInfo = nil;
        }else {
            [_mainWindowController configButtonName:@"No Device Connected" WithTextColor:IMBGrayColor(51) WithTextSize:12.0f WithIsShowIcon:YES WithIsShowTrangle:NO WithIsDisable:YES withConnectType:0];
        }
        [self deviceDisconnected:serialNum];
    };
    deviceConnection.IMBDeviceNeededPassword = ^(am_device device){
        //设备连接需要密码
        [self deviceNeededPwd:device];
    };
    deviceConnection.IMBDeviceConnectedCompletion = ^(IMBiPod *iPod) {
        //加载设备信息完成,ipod中含有设备详细信息
        
        if (iPod) {
            [self setDeviceInfosWithiPod:iPod];
        }
    };
}

- (void)dealloc {
    [_disConnectController release];
    _disConnectController = nil;
    
    [_mainWindowController release];
    _mainWindowController = nil;
    
    [[IMBDeviceConnection singleton] stopListening];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBSelectedDeviceDidChangeNoti object:nil];
    
    [super dealloc];
    
    
}

#pragma mark -- 设备连接状态
/**
 *  设备连接成功
 */
- (void)deviceConnected {
    _disConnectController.promptTF.stringValue = @"Connected";
    
    [self emptyDeviceInfo];
}
/**
 *  设备断开连接
 */
- (void)deviceDisconnected:(NSString *)serialNum {
    [[IMBLogManager singleton] writeInfoLog:@"Disonneted"];
    _disConnectController.promptTF.stringValue = @"Please plug-in your iPhone,iPad or iPod, Start your journey";
    [self emptyDeviceInfo];
    
}
/**
 *  设备连接需要密码
 */
- (void)deviceNeededPwd:(am_device)device {
    [[IMBLogManager singleton] writeInfoLog:@"Connetion Needs Password"];
    _disConnectController.promptTF.stringValue = @"Device Needs Password";
    [self emptyDeviceInfo];
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Device Needs Password" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Make sure you give access to us"];
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == 1) {
            IMBFLog(@"111111111");
            //点击确定，重新链接设备
            [[IMBDeviceConnection singleton] performSelector:@selector(reConnectDevice:) withObject:(id)device afterDelay:1.0f];
        }
    }];
    
    
}

- (void)emptyDeviceInfo {
    _disConnectController.promptLeftTF.stringValue = @"";
    _disConnectController.promptRightTF.stringValue = @"";
}

- (void)setDeviceInfosWithiPod:(IMBiPod *)iPod {
    IMBDeviceInfo *deviceInfo = [iPod.deviceInfo retain];
    
    
    [_mainWindowController configButtonName:deviceInfo.deviceName WithTextColor:IMBGrayColor(51) WithTextSize:12.0f WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:deviceInfo.family];
    
    _disConnectController.promptLeftTF.stringValue = [NSString stringWithFormat:@"Device Name:\nAvailable Size:\nSerial Num:\nDevice Class:\nPhone:\nProduct Type:\nProduct Version::\nPhone Num:\nFirmware Version:\nUnique ChipID:\nActivation State:\nRegionInfo:\nModel Number:\nBuild Version:\nHardware Model:\nCPU Architecture:\nBaseband Version:"];
    _disConnectController.promptRightTF.stringValue = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@",deviceInfo.deviceName,[NSString stringWithFormat:@"%.01f GB",deviceInfo.totalDataAvailable/1024.0/1024.0/1024.0],deviceInfo.serialNumber,deviceInfo.deviceClass,[deviceInfo getIPodFamilyString],deviceInfo.productType,deviceInfo.productVersion,deviceInfo.phoneNumber,deviceInfo.firmwareVersion,deviceInfo.uniqueChipID,deviceInfo.activationState,deviceInfo.regionInfo,deviceInfo.modelNumber,deviceInfo.buildVersion,deviceInfo.hardwareModel,deviceInfo.CPUArchitecture,deviceInfo.basebandVersion];
    
    [deviceInfo release];
    deviceInfo = nil;
}
#pragma mark -- 通知

- (void)selectedDeviceDidChangeNoti:(NSNotification *)noti {
    IMBiPod *iPod = [noti object];
    
    if (iPod) {
        [self setDeviceInfosWithiPod:iPod];
    }
}
@end
