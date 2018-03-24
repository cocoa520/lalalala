//
//  IMBMainPageViewController.m
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/18.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBMainPageViewController.h"
#import "IMBDriveBaseManage.h"
#import "IMBiPod.h"
#import "IMBiCloudDriverViewController.h"
#import "IMBDevicePageViewController.h"
#import "IMBDrawOneImageBtn.h"
#import "IMBDeviceViewController.h"
#import "SystemHelper.h"
#import "IMBMainWindowController.h"
#import "IMBViewManager.h"
#import "IMBCommonTool.h"
#import "IMBCommonDefine.h"


#import <objc/runtime.h>


@interface IMBMainPageViewController ()

@end

@implementation IMBMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (id)initWithiPod:(IMBiPod *)iPod withMedleEnum:(ChooseLoginModelEnum )logMedleEnum withiCloudDrvieBase:(IMBDriveBaseManage*)baseManage withDelegate:(id)delegate{
    if ([super initWithNibName:@"IMBMainPageViewController" bundle:nil]) {
        _chooseModelEnum = logMedleEnum;
        _iPod = [iPod retain];
        _driveBaseManage = baseManage;
        _delegate = delegate;
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    if (_alertSuperView) {
        objc_setAssociatedObject([NSApplication sharedApplication], &kIMBMainPageWindowAlertView, _alertSuperView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [_lineView1 setLineColor:COLOR_MAIN_WINDOW_LINE_COLOR];
    [_lineView2 setLineColor:COLOR_MAIN_WINDOW_LINE_COLOR];
    
    //TODO  这里图片暂时未给。等给了再改
    [_shoppingCartBtn setHoverImage:@"navbar_icon_transtion copy"];
    [_transferBtn setHoverImage:@"navbar_icon_transtion"];
    
    IMBDrawOneImageBtn *button = [[IMBDrawOneImageBtn alloc]initWithFrame:NSMakeRect(12, 18, 12, 12)];
    [button mouseDownImage:[NSImage imageNamed:@"windowclose3"] withMouseUpImg:[NSImage imageNamed:@"windowclose"] withMouseExitedImg:[NSImage imageNamed:@"windowclose"] mouseEnterImg:[NSImage imageNamed:@"windowclose2"]];
    [button setEnabled:YES];
    [button setTarget:self];
    [button setAction:@selector(closeWindow:)];
    [button setBordered:NO];
    [_topView initWithLuCorner:YES LbCorner:NO RuCorner:YES RbConer:NO CornerRadius:5];
    [_topView setBackgroundColor:COLOR_DEVICE_Main_WINDOW_TOPVIEW_COLOR];
    [_topView addSubview:button];
    [_topView setBackgroundColor:COLOR_MAIN_WINDOW_BG];
//    _toolBarButtonView = [[IMBToolButtonView alloc]initWithFrame:NSMakeRect(540, 6, 450, 40)];
 
//    [_toolBarView addSubview:_toolBarButtonView];

//    [_toolBarButtonView setDelegate:self];
//    [super awakeFromNib];
    [_selectedDeviceBtn setHidden:NO];
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    IMBBaseInfo *deviceBaseInfo = nil;
    //    if (deviceConnection.allDevices.count) {
  
    //            if (baseInfo.isSelected) {
    if (_chooseModelEnum == iCloudLogEnum) {
        for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
            if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                deviceBaseInfo = baseInfo;
            }
        }
//        [_selectedDeviceBtn configButtonName:deviceBaseInfo.deviceName WithTextColor:COLOR_MAINWINDOW_TITLE_TEXT WithTextSize:12.0f WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:deviceBaseInfo.connectType rightIcon:@"arrow"];
        [_selectedDeviceBtn setTitle:deviceBaseInfo.deviceName titleColor:COLOR_MAINWINDOW_TITLE_TEXT titleSize:15.0f leftIcon:@"device_name_icloud" rightIcon:@"arrow"];

        _baseViewController = [[IMBiCloudDriverViewController alloc] initWithDrivemanage:_driveBaseManage withDelegete:_delegate];
        [_rootBox setContentView:_baseViewController.view];
        
    }else if (_chooseModelEnum == DropBoxLogEnum) {
        for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
            if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                deviceBaseInfo = baseInfo;
            }
        }
        
//          [_selectedDeviceBtn configButtonName:deviceBaseInfo.deviceName WithTextColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT WithTextSize:15.0f WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:deviceBaseInfo.connectType rightIcon:@"arrow"];
        [_selectedDeviceBtn setTitle:deviceBaseInfo.deviceName titleColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT titleSize:15.0f leftIcon:@"device_name_icloud" rightIcon:@"arrow"];
        _baseViewController = [[IMBiCloudDriverViewController alloc] initWithDrivemanage:_driveBaseManage withDelegete:_delegate];
        [_rootBox setContentView:_baseViewController.view];
    }else if (_chooseModelEnum == DeviceLogEnum) {
        for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
            if ([baseInfo.uniqueKey isEqualToString:_iPod.uniqueKey]) {
                deviceBaseInfo = baseInfo;
            }
        }
//        [_selectedDeviceBtn configButtonName:_iPod.deviceInfo.deviceName WithTextColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT WithTextSize:15.0f WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:deviceBaseInfo.connectType rightIcon:@"popup_icon_arrow"];
        [_selectedDeviceBtn setTitle:deviceBaseInfo.deviceName titleColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT titleSize:15.0f leftIcon:@"symbols-apple" rightIcon:@"popup_icon_arrow"];
        _baseViewController = [[IMBDevicePageViewController alloc]initWithiPod:_iPod withDelegate:_delegate];
        [_rootBox setContentView:_baseViewController.view];
    }
  
}
#pragma -- mark  Actions
- (void)toMac:(IMBInformation *)information {

}

- (void)addItems:(id)sender {

}

- (void)backAction:(id)sender {
    [(IMBDevicePageViewController *)_baseViewController backAction:sender];
}

- (void)doSwitchView:(id)sender {
    [_baseViewController doSwitchView:sender];
}
#pragma mark - toolbar上购 物额车 和 传输  按钮点击事件

- (IBAction)toolbarShoppingCartClicked:(id)sender {
    IMBFFuncLog
}

- (IBAction)toolbarTransfefClicked:(id)sender {
    IMBFFuncLog
}

#pragma -- mark  DeviceBtn Actions
- (IBAction)selectedDeviceBtnDown:(id)sender {
    if (_devPopover != nil) {
        [_devPopover release];
        _devPopover = nil;
    }
    _devPopover = [[NSPopover alloc] init];
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
        _devPopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
    }else {
        _devPopover.appearance = NSPopoverAppearanceMinimal;
    }
    
    _devPopover.animates = YES;
    _devPopover.behavior = NSPopoverBehaviorTransient;
    _devPopover.delegate = self;
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    IMBBaseInfo *deviceBaseInfo = nil;
    //    if (deviceConnection.allDevices.count) {
    for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
        if ([baseInfo.uniqueKey isEqualToString:_iPod.uniqueKey]) {
            deviceBaseInfo = baseInfo;
        }
    }
    if (deviceConnection.allDevices) {
        _popoverViewController = [[IMBPopoverViewController alloc] initWithNibName:@"IMBPopoverViewController" bundle:nil withSelectedValue:deviceBaseInfo.uniqueKey WithDevice:deviceConnection.allDevices withConnectType:deviceBaseInfo.connectType];
        
        [_popoverViewController setTarget:self];
        [_popoverViewController setAction:@selector(onItemClicked:)];
        
        [_popoverViewController setExitTarget:self];
        [_popoverViewController setExitAction:@selector(onItemExitClicked:)];
        [_popoverViewController setDelegate:self];
        if (_devPopover != nil) {
            _devPopover.contentViewController = _popoverViewController;
        }
        
        [_popoverViewController release];
//        [allDevice release];
//        allDevice = nil;
        NSButton *targetButton = (NSButton *)sender;
        NSWindow *window = targetButton.window;
        
        NSRectEdge prefEdge = NSMaxYEdge;
        NSRect rect = NSMakeRect(targetButton.bounds.origin.x, targetButton.bounds.origin.y, targetButton.bounds.size.width, targetButton.bounds.size.height);
        [_devPopover showRelativeToRect:rect ofView:sender preferredEdge:prefEdge];
    }
}

- (void)onItemClicked:(id)sender {
    IMBViewManager *viewManager = [IMBViewManager singleton];
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    IMBBaseInfo *baseInfo = (IMBBaseInfo *)sender;
    IMBMainWindowController *windowController = nil;
    [_devPopover close];
    if (baseInfo.connectType == general_Add_Content) {
        if (!viewManager.mainWindowController) {
            viewManager.mainWindowController = [[IMBMainWindowController alloc] initWithNewWindow];
            [viewManager.mainWindowController.window setContentSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
        }
        [viewManager.mainWindowController showWindow:self];
    }else {
        if (_chooseModelEnum == iCloudLogEnum || _chooseModelEnum == DropBoxLogEnum) {
            if (_chooseModelEnum == baseInfo.chooseModelEnum) {
                return;
            }
        }
        if ([baseInfo.uniqueKey isEqualToString:_iPod.uniqueKey] || _chooseModelEnum == baseInfo.chooseModelEnum) {
            return;
        }else {
            IMBiPod *ipod = [connection getiPodByKey:baseInfo.uniqueKey];
            if (_chooseModelEnum == iCloudLogEnum) {
                if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                    return;
                }else if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                    windowController = [viewManager.windowDic objectForKey:@"DropBox"];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:nil withKey:@"DropBox" withCloud:@"iCloud"];
                    }
                }else if (baseInfo.chooseModelEnum == DeviceLogEnum) {
                    windowController = [viewManager.windowDic objectForKey:baseInfo.uniqueKey];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:ipod withKey:baseInfo.uniqueKey withCloud:@"iCloud"];
                    }
                }
            }else if (_chooseModelEnum == DropBoxLogEnum) {
                if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                    windowController = [viewManager.windowDic objectForKey:@"iCloud"];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:nil withKey:@"iCloud" withCloud:@"DropBox"];
                    }
                }else if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                    return;
                }else if (baseInfo.chooseModelEnum == DeviceLogEnum) {
                    windowController = [viewManager.windowDic objectForKey:baseInfo.uniqueKey];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:ipod withKey:baseInfo.uniqueKey withCloud:@"DropBox"];
                    }
                }
            }else if (_chooseModelEnum == DeviceLogEnum) {
                if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                    windowController = [viewManager.windowDic objectForKey:@"iCloud"];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:nil withKey:@"iCloud" withCloud:_iPod.uniqueKey];
                    }
                }else if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                     windowController = [viewManager.windowDic objectForKey:@"DropBox"];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:nil withKey:@"DropBox" withCloud:_iPod.uniqueKey];
                    }
                }else if (baseInfo.chooseModelEnum == DeviceLogEnum) {
                    return;
                }
            }
            if (windowController) {
                [windowController showWindow:self];
            }
        }
    }
}

- (void)onItemExitClicked:(id)sender {
    
}

- (void)backdrive:(IMBBaseInfo *)baseInfo {
    IMBViewManager *viewManager = [IMBViewManager singleton];
    IMBMainWindowController *windowController = nil;
    if ([viewManager.windowDic objectForKey:@"iCloud"] && baseInfo.chooseModelEnum == iCloudLogEnum) {
        windowController = [viewManager.windowDic objectForKey:@"iCloud"];
        [windowController showWindow:self];
    }else if ([viewManager.windowDic objectForKey:@"DropBox"] && baseInfo.chooseModelEnum == DropBoxLogEnum) {
        windowController = [viewManager.windowDic objectForKey:@"DropBox"];
        [windowController showWindow:self];
    }else if ([viewManager.windowDic objectForKey:baseInfo.uniqueKey] && baseInfo.chooseModelEnum == DeviceLogEnum) {
        windowController = [viewManager.windowDic objectForKey:baseInfo.uniqueKey];
        [windowController showWindow:self];
    }else {
        IMBiPod *newiPod = [[IMBDeviceConnection singleton] getiPodByKey:baseInfo.uniqueKey];
        IMBMainWindowController *mainwindow = [[IMBMainWindowController alloc]initWithNewWindowiPod:newiPod WithNewWindow:YES withLogMedleEnum:baseInfo.chooseModelEnum];
        [mainwindow showWindow:self];
    }
    [_devPopover close];
}

- (void)closeWindow:(id)sender {
    [_delegate closeWindow:nil];
}

- (IBAction)backMainView:(id)sender {
//    [IMBCommonTool showTwoBtnsAlertInMainWindow:NO firstBtnTitle:@"Canc" secondBtnTitle:@"Sure" msgText:@"Test" firstBtnClickedBlock:^{
//        
//    } secondBtnClickedBlock:^{
//        
//    }];
    [_delegate backMainViewChooseLoginModelEnum];
}

@end
