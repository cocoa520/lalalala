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
        [_selectedDeviceBtn configButtonName:deviceBaseInfo.deviceName WithTextColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT WithTextSize:15.0f WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:deviceBaseInfo.connectType];

        _baseViewController = [[IMBiCloudDriverViewController alloc] initWithDrivemanage:_driveBaseManage withDelegete:_delegate];
        [_rootBox setContentView:_baseViewController.view];
        
    }else if (_chooseModelEnum == DropBoxLogEnum) {
        for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
            if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                deviceBaseInfo = baseInfo;
            }
        }
          [_selectedDeviceBtn configButtonName:deviceBaseInfo.deviceName WithTextColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT WithTextSize:15.0f WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:deviceBaseInfo.connectType];
     
    }else if (_chooseModelEnum == DeviceLogEnum) {
        for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
            if ([baseInfo.uniqueKey isEqualToString:_iPod.uniqueKey]) {
                deviceBaseInfo = baseInfo;
            }
        }
        [_selectedDeviceBtn configButtonName:_iPod.deviceInfo.deviceName WithTextColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT WithTextSize:15.0f WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:deviceBaseInfo.connectType];

        //            }
        //        }
        //    }
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
        NSRectEdge prefEdge = NSMaxYEdge;
        NSRect rect = NSMakeRect(targetButton.bounds.origin.x, targetButton.bounds.origin.y, targetButton.bounds.size.width, targetButton.bounds.size.height);
        [_devPopover showRelativeToRect:rect ofView:sender preferredEdge:prefEdge];
    }
}

- (void)onItemClicked:(id)sender {
    IMBBaseInfo *baseInfo = (IMBBaseInfo *)sender;
    [_toDevicePopover close];
    if (baseInfo.connectType == general_Add_Content) {
        IMBMainWindowController *mainwindow = [[IMBMainWindowController alloc]initWithWindowNibName:@"IMBMainWindowController"];
//        _mainWindowController = [[IMBMainWindowController alloc] initWithWindowNibName:@"IMBMainWindowController"];
        //    [self.window setContentSize:NSMakeSize(1060, 635)];
        [mainwindow.window setContentSize:NSMakeSize(592, 430)];
        [mainwindow showWindow:nil];
    }else {
        if ([baseInfo.uniqueKey isEqualToString:_iPod.uniqueKey]) {
            return;
        }else {
            IMBiPod *newiPod = [[IMBDeviceConnection singleton] getiPodByKey:baseInfo.uniqueKey];
            IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
//            deviceConnection 
            IMBMainWindowController *mainwindow = [[IMBMainWindowController alloc]initWithNewWindowiPod:newiPod];
            //        _mainWindowController = [[IMBMainWindowController alloc] initWithWindowNibName:@"IMBMainWindowController"];
            //    [self.window setContentSize:NSMakeSize(1060, 635)];
            [mainwindow.window setContentSize:NSMakeSize(1096, 644)];
            [mainwindow showWindow:nil];
        }
    }
}

- (void)onItemExitClicked:(id)sender {
    
}

- (void)closeWindow:(id)sender {
    [_delegate closeWindow:nil];
}

- (void)swithViewController {
}

- (IBAction)backMainView:(id)sender {
//    _chooseModelEnum
//    _iPod
//    [_delegate backMainView:];
    [_delegate backMainViewChooseLoginModelEnum:_chooseModelEnum withiPod:_iPod];
}

@end
