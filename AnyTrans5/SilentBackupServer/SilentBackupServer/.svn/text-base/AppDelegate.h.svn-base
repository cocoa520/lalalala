//
//  AppDelegate.h
//  AirBackupHelper
//
//  Created by iMobie on 10/11/17.
//  Copyright (c) 2017 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBDeviceConnection.h"
#import "IMBiPod.h"
#import "IMBLogManager.h"
#import "IMBBackAndRestore.h"
#import "IMBNotificationWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IMBDeviceConnection *_deviceConnection;
    IMBiPod *_ipod;
    NSNotificationCenter *nc;
    NSString *_uniqueKey;
    IMBBackAndRestore *_backupDandle;
    NSString *_deviceName;
    NSString *_deviceType;
    
    IMBLogManager *_logHandle;
    double _backupProgress;
    BOOL _isError;
    BOOL _isBackupComplete;
    BOOL _isBackuping;
    BOOL _isBackupPhotoMedia;
    BOOL _isStop;
    NSRect _mainRect;
    
    IMBNotificationWindowController *_notificationController;
    NSWindow *_window;
    
    IBOutlet NSTextField *_promptLabel;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain)IMBiPod *ipod;

- (void)backupDeviceNow:(NSString *)serialNumber;
- (void)USBDeviceConnect:(NSString *)serialNumber;
- (void)USBDeviceDisconnect:(NSString *)serialNumber;
- (void)stopCurBackup:(NSString *)serialNumber;
- (void)startBackup;


@end

