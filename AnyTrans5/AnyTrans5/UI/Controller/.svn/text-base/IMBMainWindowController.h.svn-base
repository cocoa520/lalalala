//
//  IMBMainWindowController.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBackgroundBorderView.h"
#import "HoverButton.h"
#import "IMBDeviceConnection.h"
#import "IMBSelecedDeviceBtn.h"
#import "IMBMainFrameButtonBarView.h"
#import "IMBAlertSupeView.h"
#import "IMBDeviceInfoViewController.h"
#import "IMBGuideViewController.h"
#import "IMBNoTitleBarContentView.h"
#import "IMBAndroidViewController.h"
#import "IMBiCloudNetClient.h"
#import "IMBPopoverViewController.h"
#import "IMBiCloudViewController.h"
#import "IMBSearchView.h"
#import "IMBBuyView.h"
#import "IMBShoppingCarViewController.h"
#import "IMBHelpView.h"
#import "MobileDeviceAccess.h"
@class IMBBackupViewController;
@interface IMBMainWindowController : NSWindowController <NSPopoverDelegate,NSTextFieldDelegate>
{
    IBOutlet NSBox *_contentBoxView;
    IBOutlet IMBBackgroundBorderView *_topLineView;
    IBOutlet IMBLackCornerView *_topView;
    IBOutlet IMBNoTitleBarContentView *_mainContentView;
    IBOutlet NSBox *_guideBoxView;

    AMDiagnosticsRelayServices *_mobileRelayServices;
    NSMutableDictionary *_contentDic; //存储主模块的viewcontroller
    NSMutableDictionary *_connectDic; //存储连接项
    NSMutableArray *_connectiCloudTotalArray; //存储所有连接的iCloud账户项
    NSMutableArray *_connectiPodTotalArray; //存储所有iPod设备项
    NSPopover *_devPopover;
    NSPopover *_adPopover;
    IMBDeviceConnection *_deviceConnection;
    IMBiCloudNetClient *_accountLogin;
    IMBBaseInfo *_curBaseInfo;
    FunctionType _curFunctionType;
    BOOL _isConnectDevice;
    
    IBOutlet IMBSelecedDeviceBtn *_selectDeviceBtn;
    IBOutlet NSView *_hiddenView;
    IMBDeviceInfoViewController *_deviceInfoVC;
    IMBAndroidViewController *_androidVC;
    IMBAlertViewController *_alertView;
    IMBiCloudViewController *_icloudVC;
    IMBBackupViewController *_backupVC;
    IMBPopoverViewController *devPopoverViewController;
    
    IMBGuideViewController *_guideViewController;
    IMBMainFrameButtonBarView *_mainframeButtonBar;
    BOOL _isDevice;
    BOOL _isiOSDevice;
    NSView *_rightUpDownbgView;
    NSString *_appleID;
    IBOutlet IMBSearchView *_searchView;
    BOOL _isLoadSearchView;//正在打开或者合拢SearchView
    IBOutlet IMBBuyView *_buyView;
    IMBShoppingCarViewController *_shopCarViewController;
    IBOutlet IMBHelpView *_helpView;
    BOOL _mainFrameBtnIsEnable;//弹出shopping页面时候，主按钮的状态
    //刷新itunes界面
    BOOL _isLoadiTunesData;
}
@property (nonatomic, retain) IMBSearchView *searchView;
@property (nonatomic, retain) IMBBuyView *buyView;
@property (nonatomic, retain) AMDiagnosticsRelayServices *mobileRelayServices;
@property (nonatomic, readwrite, retain) NSString *appleID;
@property (nonatomic, readwrite, retain) NSMutableDictionary *connectDic;
@property (nonatomic, readwrite, retain) NSMutableArray *connectiCloudTotalArray;
@property (nonatomic, readwrite, retain) NSMutableArray *connectiPodTotalArray;
@property (nonatomic, readwrite) FunctionType curFunctionType;

- (void)backdrive:(IMBBaseInfo *)baseInfo;
- (void)showInfo:(IMBBaseInfo *)baseInfo;
- (void)restartDeviceBase:(IMBBaseInfo *)baseInfo;
- (void)shutdownDeviceBase:(IMBBaseInfo *)baseInfo;

- (void)changeViewController:(FunctionType)functionType;
- (BOOL)getSkinBtnEnable;
- (void)androidConnectPopoverView;
- (void)setTopLineViewIsHidden:(BOOL)isHidden;

@end
