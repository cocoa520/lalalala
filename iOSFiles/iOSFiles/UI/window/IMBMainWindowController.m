//
//  IMBMainWindowController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBMainWindowController.h"
#import "IMBCommonDefine.h"
#import "IMBMainPageViewController.h"
#define WindowMinSizeWidth 438
#define WindowMinSizeHigh 592
#define WindowMaxSizeWidth 644
#define WindowMaxSizeHigh 1096
@interface IMBMainWindowController ()<NSPopoverDelegate,NSAnimationDelegate>

@end

@implementation IMBMainWindowController


- (id)initWithWindowNibName:(NSString *)windowNibName {
    if (self = [super initWithWindowNibName:windowNibName]) {
     
    }
    return self;
}

- (id)initWithNewWindowiPod:(IMBiPod *)ipod {
    if ([super initWithWindowNibName:@"IMBMainWindowController"]) {
        _newiPod = [ipod retain];
    }
    return self;
}

/**
 *  初始化操作
 */
- (void)awakeFromNib {
    [_whiteView setBackgroundColor:COLOR_MAIN_WINDOW_BG];
    [[self window] setMovableByWindowBackground:YES];

    if (_newiPod) {
        IMBMainPageViewController *mainPageViewController = [[IMBMainPageViewController alloc]initWithiPod:_newiPod withMedleEnum:DeviceLogEnum withiCloudDrvieBase:nil withDelegate:self];
        [_rootBox setContentView:mainPageViewController.view];
        IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
        [connection.allMainControllerDic setObject:self forKey:_newiPod.uniqueKey];
//        [mainPageViewController release];
//        mainPageViewController = nil;
        [self.window setMinSize:NSMakeSize(WindowMaxSizeHigh, WindowMaxSizeWidth)];
        [self.window setMaxSize:NSMakeSize(WindowMaxSizeHigh, WindowMaxSizeWidth)];
    }else {
        _deviceViewController = [[IMBDeviceViewController alloc]initWithDelegate:self];
        [_rootBox setContentView:_deviceViewController.view];
        [self.window setMinSize:NSMakeSize(WindowMinSizeHigh, WindowMinSizeWidth)];
        [self.window setMaxSize:NSMakeSize(WindowMinSizeHigh, WindowMinSizeWidth)];
    }
}

- (void)changeMainFrame:(IMBiPod *)iPod withMedleEnum:(ChooseLoginModelEnum )logMedleEnum withiCloudDrvieBase:(IMBDriveBaseManage*)baseManage {
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    IMBMainPageViewController *mainPageViewController = nil;
    if (logMedleEnum == iCloudLogEnum) {
        mainPageViewController = [connection.allMainControllerDic objectForKey:@"iCloud"];
    }else if (logMedleEnum == DropBoxLogEnum) {
        mainPageViewController = [connection.allMainControllerDic objectForKey:@"DropBox"];
    }else if (logMedleEnum == DeviceLogEnum) {
        mainPageViewController = [connection.allMainControllerDic objectForKey:iPod.uniqueKey];
    }
    if (!mainPageViewController) {
        mainPageViewController = [[IMBMainPageViewController alloc]initWithiPod:iPod withMedleEnum:logMedleEnum withiCloudDrvieBase:baseManage withDelegate:self];
        if (logMedleEnum == iCloudLogEnum) {
            [connection.allMainControllerDic setObject:mainPageViewController forKey:@"iCloud"];
        }else if (logMedleEnum == DropBoxLogEnum) {
            [connection.allMainControllerDic setObject:mainPageViewController forKey:@"DropBox"];
        }else if (logMedleEnum == DeviceLogEnum) {
            [connection.allMainControllerDic setObject:mainPageViewController forKey:iPod.uniqueKey];
        }
    }
    [_rootBox setContentView:mainPageViewController.view];

    NSRect startFrame = [self.window frame];
    NSRect endFrame = NSMakeRect(startFrame.origin.x - (WindowMaxSizeHigh - startFrame.size.width)/2, startFrame.origin.y - (WindowMaxSizeWidth - startFrame.size.height)/2, WindowMaxSizeHigh, WindowMaxSizeWidth);
    [self.window setMinSize:endFrame.size];
    [self.window setMaxSize:endFrame.size];
    [self.window setFrame:endFrame display:YES animate:YES];
}

- (void)backMainViewChooseLoginModelEnum:(ChooseLoginModelEnum) choosemodelEnum withiPod:(IMBiPod *)ipod{
    if (choosemodelEnum == iCloudLogEnum) {

    }else if (choosemodelEnum == DropBoxLogEnum) {

    }else if (choosemodelEnum == DeviceLogEnum) {

    }
    [_rootBox setContentView:_deviceViewController.view];
    NSRect startFrame = [self.window frame];
    NSRect endFrame = NSMakeRect(startFrame.origin.x + (startFrame.size.width - WindowMinSizeWidth)/2, startFrame.origin.y + (startFrame.size.height - WindowMinSizeHigh)/2, WindowMinSizeHigh, WindowMinSizeWidth);
    [self.window setMinSize:endFrame.size];
    [self.window setMaxSize:endFrame.size];
    [self.window setFrame:endFrame display:YES animate:YES];
}
/**
 *  关闭window
 */
- (void)closeWindow:(id)sender {
    [self.window close];
    [_deviceViewController mainWindowClose];
}

- (void)dealloc {
    if (_deviceViewController) {
        [_deviceViewController release];
        _deviceViewController = nil;
    }
    //移除通知
    [super dealloc];
}


@end
