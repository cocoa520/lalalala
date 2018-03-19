


//
//  IMBDeviceViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBDeviceViewController.h"
#import "IMBDeviceConnection.h"
#import "IMBDeviceInfo.h"
#import "IMBiPod.h"
#import "IMBMainWindowController.h"
#import "IMBBackgroundBorderView.h"
#import "IMBDevViewController.h"
#import "IMBDevicePageWindow.h"
#import "NSString+Category.h"
#import "IMBInformation.h"
#import "IMBInformationManager.h"
#import "IMBCommonDefine.h"
#import "DateHelper.h"
#import "StringHelper.h"
#import "IMBDriveEntity.h"
#import "IMBDriveManage.h"
#import "StringHelper.h"
#import "IMBDriveWindow.h"
#import "IMBAppsListViewController.h"
#import "IMBViewAnimation.h"
#import "IMBSelectConntedDeviceView.h"
#import "IMBDropBoxManage.h"
#import <Quartz/Quartz.h>
#import "IMBDevicePageViewController.h"


static CGFloat const SelectedBtnTextFont = 15.0f;


@interface IMBDeviceViewController ()
{
    @private
    NSMutableArray *_devicesArray;
    IMBMainWindowController *_mainWindowController;
    IMBSelectConntedDeviceView *_selectView;
    IMBDevViewController *_devController;
    IMBBaseInfo *_selectedBaseInfo;
    NSString *_bigDevicesConnectedImageName;
}

@end

@implementation IMBDeviceViewController

#pragma mark -
- (id)initWithDelegate:(id)delegate {
    if ([super initWithNibName:@"IMBDeviceViewController" bundle:nil]) {
        _delegate = delegate;
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
    _isSecureMode = YES;
    _isCheckBoxSelected = NO;
    [(IMBBackgroundBorderView*)self.view setHasRadius:YES];
    [(IMBBackgroundBorderView*)self.view setBackgroundColor:COLOR_MAIN_WINDOW_BG];
    _windowControllerDic = [[NSMutableDictionary alloc] init];
    _driveControllerDic = [[NSMutableDictionary alloc] init];
    [_rootBox setContentView:_mainView];
    
    
    _bigDevicesConnectedImageName = @"mod_device_no";
    _selectedBaseInfo = nil;
    
    IMBDrawOneImageBtn *button = [[IMBDrawOneImageBtn alloc]initWithFrame:NSMakeRect(12, 10, 12, 12)];
    [button mouseDownImage:[NSImage imageNamed:@"windowclose3"] withMouseUpImg:[NSImage imageNamed:@"windowclose"] withMouseExitedImg:[NSImage imageNamed:@"windowclose"] mouseEnterImg:[NSImage imageNamed:@"windowclose2"]];
    [button setEnabled:YES];
    [button setTarget:self];
    [button setAction:@selector(closeWindow:)];
    [button setBordered:NO];
    [_topView initWithLuCorner:YES LbCorner:NO RuCorner:YES RbConer:NO CornerRadius:5];
    [_topView setBackgroundColor:COLOR_DEVICE_Main_WINDOW_TOPVIEW_COLOR];
    [_topView addSubview:button];
    [_topView setBackgroundColor:COLOR_MAIN_WINDOW_BG];
    
    [self mouseDown:nil];
}

/**
 *  初始化
 */
- (void)setupView {
    [_iCloudUserTextField setPlaceholderString:CustomLocalizedString(@"MainWindow_iCLoudUserPlaceholder_String", nil)];
    [_passTextField setPlaceholderString:CustomLocalizedString(@"mainWindow_iCloudPassWord_String", nil)];
    [icloudLoginbtn WithMouseExitedtextColor:[NSColor whiteColor] WithMouseUptextColor:[NSColor whiteColor] WithMouseDowntextColor:IMBGrayColor(240) withMouseEnteredtextColor:IMBGrayColor(245)];
    [icloudLoginbtn WithMouseExitedfillColor:COLOR_BTN_BLUE_BG WithMouseUpfillColor:[COLOR_BTN_BLUE_BG colorWithAlphaComponent:0.8] WithMouseDownfillColor:[COLOR_BTN_BLUE_BG colorWithAlphaComponent:0.7] withMouseEnteredfillColor:[COLOR_BTN_BLUE_BG colorWithAlphaComponent:0.8]];
    [icloudLoginbtn setTitleName:@"Login Now" WithDarwRoundRect:4.f WithLineWidth:0 withFont:[NSFont systemFontOfSize:14.f]];
    
    
    [dropboxLoginBtn WithMouseExitedtextColor:[NSColor whiteColor] WithMouseUptextColor:[NSColor whiteColor] WithMouseDowntextColor:IMBGrayColor(240) withMouseEnteredtextColor:IMBGrayColor(245)];
    [dropboxLoginBtn WithMouseExitedfillColor:COLOR_BTN_BLUE_BG WithMouseUpfillColor:[COLOR_BTN_BLUE_BG colorWithAlphaComponent:0.8] WithMouseDownfillColor:[COLOR_BTN_BLUE_BG colorWithAlphaComponent:0.7] withMouseEnteredfillColor:[COLOR_BTN_BLUE_BG colorWithAlphaComponent:0.8]];
    [dropboxLoginBtn setTitleName:@"Login Now" WithDarwRoundRect:4.f WithLineWidth:0 withFont:[NSFont systemFontOfSize:14.f]];
    
    [_devicesView setIsDevicesOriginalFrame:YES];
    [_loginTextField setTextColor:COLOR_TEXT_ORDINARY];
    [((customTextFieldCell *)_loginTextField.cell) setCursorColor:COLOR_TEXT_ORDINARY];
    
    NSMutableAttributedString *as5 = [[[NSMutableAttributedString alloc] initWithString:@"User"] autorelease];
    [as5 addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN_WINDOW_TEXTFIELD_TEXT range:NSMakeRange(0, as5.string.length)];
    [as5 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as5.string.length)];
    [as5 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:NSMakeRange(0, as5.string.length)];
    [_loginTextField.cell setPlaceholderAttributedString:as5];
    
    [_iCloudUserTextField setTextColor:COLOR_TEXT_ORDINARY];
    [((customTextFieldCell *)_iCloudUserTextField.cell) setCursorColor:COLOR_TEXT_ORDINARY];
    
    NSMutableAttributedString *as6 = [[[NSMutableAttributedString alloc] initWithString:@"iCloud ID"] autorelease];
    [as6 addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN_WINDOW_TEXTFIELD_TEXT range:NSMakeRange(0, as6.string.length)];
    [as6 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as6.string.length)];
    [as6 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:NSMakeRange(0, as6.string.length)];
    [_iCloudUserTextField.cell setPlaceholderAttributedString:as6];

    
    _selectedDeviceBtn.mouseEntered = ^(void){
        if (_selectView.isShowing) {
            return;
        }
        IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
        if (_devController) {
            [_devController release];
            _devController = nil;
        }
        _devController = [[IMBDevViewController alloc] initWithNibName:@"IMBDevViewController" bundle:nil];
        
        NSMutableArray *allDevices = [[NSMutableArray alloc] init];
        
        if (deviceConnection.allDevices.count) {
            for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
                [allDevices addObject:baseInfo];
            }
        }
        _devController.devices = allDevices;
        _devController.iconX = _selectedDeviceBtn.iconX;
        _devController.textX = _selectedDeviceBtn.textX;
        if (_selectView) {
            [_selectView release];
            _selectView = nil;
        }
        
        _selectView = [[IMBSelectConntedDeviceView alloc] init];
        [_selectView setContentView:_devController.view];
        NSRect finalF = _selectedDeviceBtn.frame;
        finalF.size.height += (IMBDevViewControllerRowH*allDevices.count + 6.0f);
        [_midiumSizeDevicesView addSubview:_selectView];
        [_selectView showWithOriginalFrame:_selectedDeviceBtn.frame finalF:finalF];
    };
    
//    [_selectedDeviceBtn configButtonName:@"No Device Connected" WithTextColor:IMBGrayColor(51) WithTextSize:12.0f WithIsShowIcon:YES WithIsShowTrangle:NO WithIsDisable:YES withConnectType:0];
    [(IMBSecureTextFieldCell *)_passTextField.cell setDelegate:self];
    [((IMBSecureTextFieldCell *)_passTextField.cell) setCursorColor:COLOR_TEXT_ORDINARY];
    
    [(IMBSecureTextFieldCell *)_iCloudSecireTextField.cell setDelegate:self];
    [((IMBSecureTextFieldCell *)_iCloudSecireTextField.cell) setCursorColor:COLOR_TEXT_ORDINARY];
    
    [_icloudDrivebox setContentView:_midiumSizeiCloudView];
    [_oneDriveBox setContentView:_midiumSizeOneDriveView];
    [_devicesBox setContentView:_midiumSizeDevicesView];
    
    
    _iCloudDriveView.isOriginalFrame = YES;
    _oneDriveView.isOriginalFrame = YES;
    _devicesView.isOriginalFrame = YES;
    
    /***  界面上的三个view的鼠标点击响应事件 ***/
    /***  _iCloudDriveView的鼠标点击响应事件 ***/
    _iCloudDriveView.mouseClicked = ^(void){
        [self setShadowHidden:YES];
        [_icloudDrivebox setContentView:_bigSizeiCloudView];
        
        NSRect cloudF = NSMakeRect(18.f, 92.f, 302.f, 304.f);
        NSRect oneDriveF = NSMakeRect(18.f, 20.f, 302.f, 56.f);
        NSRect devicesF = NSMakeRect(336.f, 20.f, 238.f, 376.f);
        
        NSArray *views = @[_iCloudDriveView,_oneDriveView,_devicesView];
        NSArray *frames = @[[NSValue valueWithRect:cloudF],[NSValue valueWithRect:oneDriveF],[NSValue valueWithRect:devicesF]];
        [IMBViewAnimation animationWithViews:views frames:frames disable:YES completion:^{
            [self setOriginalFrame:NO];
            _devicesView.isDevicesOriginalFrame = YES;
            
            [_smallSizeTitle setStringValue:@"DropBox"];
            [_oneDriveBox setContentView:_smallSizeView];
            [self setDeviceViewConnecteStatus];
        }];
    };
    /***  _oneDriveView的鼠标点击响应事件 ***/
    _oneDriveView.mouseClicked = ^(void){
        [self setShadowHidden:YES];
        [_oneDriveBox setContentView:_bigSizeOneDriveView];
        
        NSRect cloudF = NSMakeRect(18.f, 340.f, 302.f, 56.f);
        NSRect oneDriveF = NSMakeRect(18.f, 20.f, 302.f, 304.f);
        NSRect devicesF = NSMakeRect(336.f, 20.f, 238.f, 376.f);
        
        NSArray *views = @[_iCloudDriveView,_oneDriveView,_devicesView];
        NSArray *frames = @[[NSValue valueWithRect:cloudF],[NSValue valueWithRect:oneDriveF],[NSValue valueWithRect:devicesF]];
        [IMBViewAnimation animationWithViews:views frames:frames disable:YES completion:^{
            [self setOriginalFrame:NO];
            _devicesView.isDevicesOriginalFrame = YES;
            
            [_smallSizeTitle setStringValue:@"iCloud"];
            [_icloudDrivebox setContentView:_smallSizeView];
            [self setDeviceViewConnecteStatus];
        }];
    };
    /***  _devicesView的鼠标点击响应事件 ***/
    _devicesView.mouseClicked = ^(void){
        [self setShadowHidden:YES];
        NSRect cloudF = NSMakeRect(18.f, 216.f, 122.f, 180.f);
        NSRect oneDriveF = NSMakeRect(18.f, 20.f, 122.f, 180.f);
        NSRect devicesF = NSMakeRect(156.0f, 20.0f, 418.f, 376.f);
        NSArray *views = @[_iCloudDriveView,_oneDriveView,_devicesView];
        NSArray *frames = @[[NSValue valueWithRect:cloudF],[NSValue valueWithRect:oneDriveF],[NSValue valueWithRect:devicesF]];
        [IMBViewAnimation animationWithViews:views frames:frames disable:YES completion:^{
            [self setOriginalFrame:NO];
            _devicesView.isDevicesOriginalFrame = NO;
            
            [_icloudDrivebox setContentView:_smalliCloudDriveView];
            [_oneDriveBox setContentView:_smallOneDriveView];
            if ([[IMBDeviceConnection singleton] isConnectedDevice]) {
                [_bigDevicesImageView setImage:[NSImage imageNamed:_bigDevicesConnectedImageName]];
            }else {
                [_bigDevicesImageView setImage:[NSImage imageNamed:@"symbols-no-device"]];
            }
            
            
        }];
    };
    
    /***  鼠标进出view响应事件 ***/
    /***  鼠标进入view响应事件 ***/
    _iCloudDriveView.mouseEntered = ^(void){
        NSRect newFrame = NSMakeRect(15.0f, 212.0f, 308.0f, 188.0f);
        [IMBViewAnimation animationScaleWithView:_icloudShadowView frame:newFrame timeInterval:MidiumSizeAnimationTimeInterval + 0.15f disable:NO completion:nil];
        [self setMouseEnteredMidiumContentViewWithView:_midiumiCloudContentView btn:_midiumiCloudClickLoginBtn];
    };
    _oneDriveView.mouseEntered = ^(void){
        NSRect newFrame = NSMakeRect(15.0f, 16.0f, 308.0f, 188.0f);
        [IMBViewAnimation animationScaleWithView:_dropboxShadowView frame:newFrame timeInterval:MidiumSizeAnimationTimeInterval + 0.15f disable:NO completion:nil];
        [self setMouseEnteredMidiumContentViewWithView:_midiumDropBoxContentView btn:_midiumDropBoxClickLoginBtn];
    };
    _devicesView.mouseEntered = ^(void){
        NSRect newFrame = NSMakeRect(333.f, 16.0f, 244.0f, 384.0f);
        [IMBViewAnimation animationScaleWithView:_devicesShadowView frame:newFrame timeInterval:MidiumSizeAnimationTimeInterval + 0.15f disable:NO completion:nil];
    };
    
    /***  鼠标移除view响应事件 ***/
    _iCloudDriveView.mouseExited = ^(void){
        _icloudShadowView.frame = NSMakeRect(18.0f, 216.0f, 302.0f, 180.0f);
        [self setMouseExitedMidiumContentViewWithView:_midiumiCloudContentView btn:_midiumiCloudClickLoginBtn];
    };
    _oneDriveView.mouseExited = ^(void){
        _dropboxShadowView.frame = NSMakeRect(18.0f, 20.0f, 302.0f, 180.0f);
        [self setMouseExitedMidiumContentViewWithView:_midiumDropBoxContentView btn:_midiumDropBoxClickLoginBtn];
    };
    _devicesView.mouseExited = ^(void){
        _devicesShadowView.frame = NSMakeRect(336.0f, 20.0f, 238.0f, 376.0f);
    };
    
    
}

- (void)setOriginalFrame:(BOOL)isOriginalFrame {
    _iCloudDriveView.isOriginalFrame = isOriginalFrame;
    _oneDriveView.isOriginalFrame = isOriginalFrame;
    _devicesView.isOriginalFrame = isOriginalFrame;
}

- (void)setShadowHidden:(BOOL)hidden {
    [_icloudShadowView setHidden:hidden];
    [_dropboxShadowView setHidden:hidden];
    [_devicesShadowView setHidden:hidden];
}

- (void)setMouseEnteredMidiumContentViewWithView:(NSView *)view btn:(NSView *)btn {
    NSRect f = view.frame;
    f.origin.y = 18;
    [IMBViewAnimation animationMouseEnteredExitedWithView:view frame:f timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
    
    [btn setHidden:NO];
    NSRect btnF = btn.frame;
    [IMBViewAnimation animationMouseMovedWithView:btn frame:btnF timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
}

- (void)setMouseExitedMidiumContentViewWithView:(NSView *)view btn:(NSView *)btn {
    NSRect f = view.frame;
    f.origin.y = 0;
    [IMBViewAnimation animationMouseEnteredExitedWithView:view frame:f timeInterval:MidiumSizeAnimationTimeInterval - 0.2f disable:NO completion:nil];
    
    
    NSRect btnF = btn.frame;
    [IMBViewAnimation animationMouseMovedWithView:btn frame:btnF timeInterval:MidiumSizeAnimationTimeInterval - 0.2f disable:NO completion:^{
        [btn setHidden:YES];
    }];
}

- (void)setDeviceViewConnecteStatus {
    if ([[IMBDeviceConnection singleton] isConnectedDevice]) {
        [_bigDevicesImageView setImage:[NSImage imageNamed:_bigDevicesConnectedImageName]];
    }else {
        [_bigDevicesImageView setImage:[NSImage imageNamed:@"mod_device"]];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    [self setShadowHidden:NO];
    _icloudShadowView.frame = NSMakeRect(18.0f, 216.0f, 302.0f, 180.0f);
    _dropboxShadowView.frame = NSMakeRect(18.0f, 20.0f, 302.0f, 180.0f);
    _devicesShadowView.frame = NSMakeRect(336.0f, 20.0f, 238.0f, 376.0f);
    
    NSRect cloudF = NSMakeRect(18.f, 216.f, 302.f, 180.f);
    NSRect oneDriveF = NSMakeRect(18.f, 20.f, 302.f, 180.f);
    NSRect devicesF = NSMakeRect(336.f, 20.f, 238.f, 376.f);
    
    
    NSArray *views = @[_iCloudDriveView,_oneDriveView,_devicesView];
    NSArray *frames = @[[NSValue valueWithRect:cloudF],[NSValue valueWithRect:oneDriveF],[NSValue valueWithRect:devicesF]];
    [IMBViewAnimation animationWithViews:views frames:frames disable:YES completion:^{
        _iCloudDriveView.isOriginalFrame = YES;
        _oneDriveView.isOriginalFrame = YES;
        _devicesView.isOriginalFrame = YES;
        
        [_oneDriveBox setContentView:_midiumSizeOneDriveView];
        [_icloudDrivebox setContentView:_midiumSizeiCloudView];
        [self setMouseExitedMidiumContentViewWithView:_midiumDropBoxContentView btn:_midiumDropBoxClickLoginBtn];
        
        [self setDeviceViewConnecteStatus];
    }];
//    [self setMouseExitedMidiumContentViewWithView:_midiumiCloudContentView btn:_midiumiCloudClickLoginBtn];
//    [self setMouseExitedMidiumContentViewWithView:_midiumDropBoxContentView btn:_midiumDropBoxClickLoginBtn];
}

/**
 *  添加通知
 */
- (void)addNotis {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedDeviceDidChangeNoti:) name:IMBSelectedDeviceDidChangeNotiWithParams object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertTabKey:) name:INSERT_TAB object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changBtnState) name:NOTIFY_TEXTFILED_INPUT_CHANGE object:nil];
}
#pragma mark - 设备连接断开
- (void)deviceConnection {
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    
    deviceConnection.IMBDeviceConnected = ^{
        //设备连接成功
        [self deviceConnectedWithConnection:deviceConnection];
    };
    deviceConnection.IMBDeviceDisconnected = ^(NSString *serialNum){
        //设备断开连接
        if (deviceConnection.allDevices.count) {
            IMBBaseInfo *baseInfo = [deviceConnection.allDevices firstObject];
            if (![baseInfo.uniqueKey isEqualToString:_selectedBaseInfo.uniqueKey]) {
//                [_selectedDeviceBtn configButtonName:baseInfo.deviceName WithTextColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT WithTextSize:SelectedBtnTextFont WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:baseInfo.connectType];
                [self setDeviceInfosWithiPod:baseInfo];
                [self deviceDisconnected:serialNum];
                _selectedBaseInfo = baseInfo;
            }
            
        }else {
            [_selectedDeviceBtn setHidden:YES];
//            [_selectedDeviceBtn configButtonName:@"No Device Connected" WithTextColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT WithTextSize:SelectedBtnTextFont WithIsShowIcon:YES WithIsShowTrangle:NO WithIsDisable:YES withConnectType:0];
            [self deviceDisconnected:serialNum];
            _selectedBaseInfo = nil;
        }
    };
    deviceConnection.IMBDeviceNeededPassword = ^(am_device device){
        //设备连接需要密码
        if (deviceConnection.allDevices.count == 0) {
//            _disConnectController.promptTF.stringValue = @"Device Needs Password";
//            [self emptyDeviceInfo];
        }
        [self deviceNeededPwd:device];
    };
    deviceConnection.IMBDeviceConnectedCompletion = ^(IMBBaseInfo *baseInfo) {
        //加载设备信息完成,ipod中含有设备详细信息
        IMBInformation *information = [[IMBInformation alloc] initWithiPod:[[deviceConnection getiPodByKey:baseInfo.uniqueKey] retain]];
        _iPod = [deviceConnection getiPodByKey:baseInfo.uniqueKey];
        IMBInformationManager *manager = [IMBInformationManager shareInstance];
        [manager.informationDic setObject:information forKey:baseInfo.uniqueKey];
        [self setDeviceInfosWithiPod:baseInfo];
    };
    [deviceConnection startListening];
}

- (void)deviceConnectedWithConnection:(IMBDeviceConnection *)connection {
//    if (connection.allDevices.count) {
//        _disConnectController.promptTF.stringValue = @"Connecting another device";
//    }else {
//        _disConnectController.promptTF.stringValue = @"Connecting";
//    }
    
    
//    [self emptyDeviceInfo];
    
}

- (void)deviceDisconnected:(NSString *)serialNum {
    [[IMBLogManager singleton] writeInfoLog:@"Disconneted"];
    if ([[IMBDeviceConnection singleton] isConnectedDevice]) {
        
        [_bigDevicesImageView setImage:[NSImage imageNamed:_bigDevicesConnectedImageName]];
    }else {
        if (_devicesView.isDevicesOriginalFrame) {
            [_bigDevicesImageView setImage:[NSImage imageNamed:@"mod_device.png"]];
        }else {
            [_bigDevicesImageView setImage:[NSImage imageNamed:@"symbols-no-device"]];
        }
    }
    
    if (_windowControllerDic.count >0) {
        IMBDevicePageWindow *devicePageWindow = [_windowControllerDic objectForKey:serialNum];
        [devicePageWindow.window close];
//        [devicePageWindow release];
//        devicePageWindow = nil;
        [_windowControllerDic removeObjectForKey:serialNum];
    }
    if (_devPopover != nil) {
        if (_devPopover.isShown) {
            [_devPopover close];
        }
    }
}

- (void)deviceNeededPwd:(am_device)device {
    [[IMBLogManager singleton] writeInfoLog:@"Connetion Needs Password"];
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Device Needs Password" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Make sure you give access to us"];
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == 1) {
            IMBFLog(@"clicked OK button");
            //点击确定，重新链接设备
            [[IMBDeviceConnection singleton] performSelector:@selector(reConnectDevice:) withObject:(id)device afterDelay:1.0f];
        }
    }];
}

/**
 *  设备连接完成  设置显示设备信息
 *
 *  @param iPod iPod
 */
- (void)setDeviceInfosWithiPod:(IMBBaseInfo *)baseInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_selectedDeviceBtn setHidden:NO];
        if (!_selectedBaseInfo) {
            _selectedBaseInfo = baseInfo;
            
        }
        [_selectedDeviceBtn configButtonName:_selectedBaseInfo.deviceName WithTextColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT WithTextSize:SelectedBtnTextFont WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:baseInfo.connectType];
        [_selectedDeviceBtn setFrame:NSMakeRect((_midiumSizeDevicesView.frame.size.width - _selectedDeviceBtn.frame.size.width)/2, _selectedDeviceBtn.frame.origin.y, _selectedDeviceBtn.frame.size.width, _selectedDeviceBtn.frame.size.height)];
        NSString *familyString = _iPod.deviceInfo.familyNewString;
        if ([familyString isEqualToString:@"iPhoneN"]) {
            _bigDevicesConnectedImageName = @"mod_device_detail_iphoneN.png";
            
        }else if ([familyString isEqualToString:@"iPhoneX"]) {
            _bigDevicesConnectedImageName = @"mod_device_detail_iphoneX.png";
        }else if ([familyString isEqualToString:@"iPad"]) {
            _bigDevicesConnectedImageName = @"mod_device_detail_ipad.png";
        }else {
            _bigDevicesConnectedImageName = @"";
        }
        [_bigDevicesImageView setImage:[NSImage imageNamed:_bigDevicesConnectedImageName]];
    });
    IMBInformationManager *inforManager = [IMBInformationManager shareInstance];
    IMBInformation *information = [[[IMBInformation alloc]initWithiPod:_iPod] autorelease];
    dispatch_queue_t spatchqueue = dispatch_queue_create("load", NULL);
    dispatch_async(spatchqueue, ^{
        [information loadphotoData];
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSMutableArray *cameraRoll = [[NSMutableArray alloc] init];
            [cameraRoll addObjectsFromArray:[information camerarollArray] ? [information camerarollArray] : [NSArray array]];
            [cameraRoll addObjectsFromArray:[information photovideoArray] ? [information photovideoArray] : [NSArray array]];
            [cameraRoll addObjectsFromArray:[information photoSelfiesArray] ? [information photoSelfiesArray] : [NSArray array]];
            [cameraRoll addObjectsFromArray:[information screenshotArray] ? [information screenshotArray] : [NSArray array]];
            [cameraRoll addObjectsFromArray:[information slowMoveArray] ? [information slowMoveArray] : [NSArray array]];
            [cameraRoll addObjectsFromArray:[information timelapseArray] ? [information timelapseArray] : [NSArray array]];
            [cameraRoll addObjectsFromArray:[information panoramasArray] ? [information panoramasArray] : [NSArray array]];
//            [photoArray addObject:cameraRoll];
            information.allPhotoArray = [cameraRoll retain];
            
//            [photoArray addObject:[information photostreamArray] ? [information photostreamArray] : [NSArray array]];
//            [photoArray addObject:[information photolibraryArray] ? [information photolibraryArray] : [NSArray array]];
////            information.allPhotoArray = [photoArray retain];
//            information.photostreamArray = [cameraRoll retain];
//            [photoArray release];
            [cameraRoll release];
            [information.ipod setPhotoLoadFinished:YES];
            [inforManager.informationDic setObject:information forKey:_iPod.uniqueKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:DEVICE_LOADCOMPLETE_CAMERAROLL object:_iPod];
        });
    });

    dispatch_async(spatchqueue, ^{
        [information loadiBook];
        NSArray *ibooks = [information allBooksArray] ;
        [self loadbookCover:ibooks];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_iPod setBookLoadFinished:YES];
            [inforManager.informationDic setObject:information forKey:_iPod.uniqueKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:DEVICE_LOADCOMPLETE_BOOKS object:_iPod];
        });
    });

    dispatch_async(spatchqueue, ^{
        [information refreshMedia];
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSArray *audioArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:(int)Audio],
                                   nil];
            NSMutableArray *trackArray = [[NSMutableArray alloc] initWithArray:[information getTrackArrayByMediaTypes:audioArray]];
            information.mediaArray = [trackArray retain];
            NSArray *videoArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:(int)Video],
                                   [NSNumber numberWithInt:(int)TVShow],
                                   [NSNumber numberWithInt:(int)MusicVideo],
                                   [NSNumber numberWithInt:(int)HomeVideo],
                                   nil];
            trackArray = [[NSMutableArray alloc] initWithArray:[information getTrackArrayByMediaTypes:videoArray]];
            information.videoArray = [trackArray retain];
            [trackArray release];
            trackArray = nil;
            [_iPod setMediaLoadFinished:YES];
            [_iPod setVideoLoadFinished:YES];
            [inforManager.informationDic setObject:information forKey:_iPod.uniqueKey];
        });
    });

    dispatch_async(spatchqueue, ^{
        IMBApplicationManager *appManager = [[information applicationManager] retain];
        [appManager loadAppArray];
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSMutableArray *appArray = (NSMutableArray *)[appManager appEntityArray];
            information.appArray = [appArray retain];
            [_iPod setAppsLoadFinished:YES];
            [inforManager.informationDic setObject:information forKey:_iPod.uniqueKey];
        });
    });
    
}

#pragma mark - action

/**
 *  设备选择按钮点击
 *
 *  @param sender 按钮
 */
- (IBAction)selectedDeviceBtnClicked:(IMBSelecedDeviceBtn *)sender {
    IMBFFuncLog;
    if (_selectView.isShowing) {
        if (_selectView) {
            [_selectView hideWithTimeInterval:0.2];
        }
        [self selectedDeviceDidChange];
        
        return;
    }
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    if (_devController) {
        [_devController release];
        _devController = nil;
    }
    _devController = [[IMBDevViewController alloc] initWithNibName:@"IMBDevViewController" bundle:nil];
    
    NSMutableArray *allDevices = [[NSMutableArray alloc] init];
    
    if (deviceConnection.allDevices.count) {
        for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
            [allDevices addObject:baseInfo];
        }
    }
    _devController.devices = allDevices;
    _devController.iconX = _selectedDeviceBtn.iconX;
    _devController.textX = _selectedDeviceBtn.textX;
    if (_selectView) {
        [_selectView release];
        _selectView = nil;
    }
    
    _selectView = [[IMBSelectConntedDeviceView alloc] init];
    [_selectView setContentView:_devController.view];
    NSRect finalF = _selectedDeviceBtn.frame;
    finalF.size.height += (IMBDevViewControllerRowH*allDevices.count + 6.0f);
//    _selectView.frame = finalF;
    [_midiumSizeDevicesView addSubview:_selectView];
    [_selectView showWithOriginalFrame:_selectedDeviceBtn.frame finalF:finalF];
//    [selectView release];
//    selectView = nil;
    
//    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
//    if (!_selectedDeviceBtn.isDisable) {
//        if (_devPopover != nil) {
//            if (_devPopover.isShown) {
//                [_devPopover close];
//                return;
//            }
//        }
//        if (_devPopover != nil) {
//            [_devPopover release];
//            _devPopover = nil;
//        }
//        _devPopover = [[NSPopover alloc] init];
//        
//        if ([[self getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
//            _devPopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
//        }else {
//            _devPopover.appearance = NSPopoverAppearanceMinimal;
//        }
//    
//        _devPopover.animates = YES;
//        _devPopover.behavior = 0;
//        _devPopover.delegate = self;
//        
//        IMBDevViewController *devController = [[IMBDevViewController alloc] initWithNibName:@"IMBDevViewController" bundle:nil];
//        CGFloat w = 300.0f;
//        CGFloat h = 50.0f*deviceConnection.allDevices.count;
//        h = h > 200.0f ? 200.0f : h;
//        
//        devController.view.frame = NSMakeRect(0, 0, w, h);
//        
//        NSMutableArray *allDevices = [[NSMutableArray alloc] init];
//        
//        if (deviceConnection.allDevices.count) {
//            for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
//                [allDevices addObject:baseInfo];
//            }
//            if (_devPopover != nil) {
//                _devPopover.contentViewController = devController;
//            }
//            devController.devices = allDevices;
//            NSRectEdge prefEdge = NSMaxYEdge;
//            NSRect rect = NSMakeRect(sender.bounds.origin.x, sender.bounds.origin.y, sender.bounds.size.width, sender.bounds.size.height);
//            [_devPopover showRelativeToRect:rect ofView:sender preferredEdge:prefEdge];
//        }
//    }
}

- (IBAction)oneDriveLogin:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ICLOUD_ENTER_SIGNIN object:nil userInfo:nil];
    [self signDown:sender];
}

- (IBAction)enterTextView:(id)sender {
    [_passTextField.cell setEnabled:NO];
    [_passTextField setEditable:NO];
    [_iCloudUserTextField setEditable:NO];
    [_iCloudUserTextField.cell setEnabled:NO];
    if (_isEnter) {
        return;
    }
    _isEnter = YES;
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ICLOUD_ENTER_SIGNIN object:nil userInfo:nil];
    [self iCloudLogIn:sender];
}


- (IBAction)checkoutPwdClicked:(NSButton *)sender {
    if (_isSecureMode) {
        _isSecureMode = NO;
        [_iCloudSecireTextField setHidden:YES];
      
        _icloudLoginPwdTextfield.stringValue = _iCloudSecireTextField.stringValue;
        [_icloudLoginPwdTextfield becomeFirstResponder];
    }else {
        _isSecureMode = YES;
        _iCloudSecireTextField.stringValue = _icloudLoginPwdTextfield.stringValue;
        [_iCloudSecireTextField setHidden:NO];
        [_iCloudSecireTextField becomeFirstResponder];
        
    }
}
- (IBAction)checkBoxClicked:(NSButton *)sender {
    _isCheckBoxSelected = !_isCheckBoxSelected;
}

#pragma mark - Dropbox Login
- (void)signDown:(id)sender{
    [_loginTextField.cell setEnabled:NO];
    [_passTextField.cell setEnabled:NO];
    NSString *loginTextId = [@"imobie@yahoo.com" stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    if ([loginTextId isEqualToString: @""]){
//        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ICLOUD_SIGNIN_FAIL object:nil userInfo:nil];
//        return;
//    }else{
//        if (_driveManage != nil) {
            if ([_baseDriveManage.userID isEqualToString:loginTextId]) {
                if ([_driveControllerDic.allKeys containsObject:_baseDriveManage.userID]) {
                    IMBDriveWindow *driveWindow = [_driveControllerDic objectForKey:_baseDriveManage.userID];
                    [driveWindow showWindow:self];
                }
            }else{
                _baseDriveManage = [[IMBDropBoxManage alloc]initWithUserID:loginTextId withDelegate:self];
            }
//        }else{
//            _driveManage = [[IMBDriveManage alloc]initWithUserID:loginTextId withDelegate:self];
//        }
//    }
    [_loginTextField.cell setEnabled:YES];
    [_passTextField.cell setEnabled:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ICLOUD_SIGNIN_FAIL object:nil userInfo:nil];
}

- (void)switchViewController {
    [_passTextField.cell setEnabled:YES];
    [_iCloudUserTextField.cell setEnabled:YES];
    [_passTextField setEditable:YES];
    [_iCloudUserTextField setEditable:YES];
    _isEnter = NO;
    
    IMBDeviceConnection *deivceConnection = [IMBDeviceConnection singleton];
    IMBBaseInfo *baseInfo = [[IMBBaseInfo alloc] init];
    [baseInfo setDeviceName:@"Drop box"];
    [baseInfo setUniqueKey:@"Drop box"];
    [baseInfo setConnectType:general_iCloud];
    [baseInfo setIsicloudView:YES];
    [baseInfo setChooseModelEnum:DropBoxLogEnum];
    [[deivceConnection allDevices] addObject:baseInfo];
    [baseInfo release];
    baseInfo = nil;
//    if ([_driveControllerDic.allKeys containsObject:_baseDriveManage.userID]) {
//        IMBDriveWindow *driveWindow = [_driveControllerDic objectForKey:_baseDriveManage.userID];
//        [driveWindow showWindow:self];
//    }else{
//        IMBDriveWindow *driveWindow = [[IMBDriveWindow alloc]initWithDrivemanage:(IMBDriveManage *)_baseDriveManage withisiCloudDrive:NO];
//        [_driveControllerDic setObject:driveWindow forKey:_baseDriveManage.userID];
//        //    IMBDevicePageWindow *devicePagewindow = [[IMBDevicePageWindow alloc] initWithiPod:ipod];
//        [[driveWindow window] center];
//        [driveWindow showWindow:self];
//        [driveWindow release];
//    }
    [_delegate changeMainFrame:nil withMedleEnum:DropBoxLogEnum withiCloudDrvieBase:nil];
}

#pragma mark - One Diver Login

//- (void)signDown:(id)sender{
//    [_loginTextField.cell setEnabled:NO];
//    [_passTextField.cell setEnabled:NO];
//    NSString *loginTextId = [_loginTextField.stringValue stringByReplacingOccurrencesOfString:@"\n" withString:@""];
////    if ([loginTextId isEqualToString: @""]){
////        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ICLOUD_SIGNIN_FAIL object:nil userInfo:nil];
////        return;
////    }else{
////        if (_driveManage != nil) {
//            if ([_baseDriveManage.userID isEqualToString:loginTextId]) {
//                if ([_driveControllerDic.allKeys containsObject:_baseDriveManage.userID]) {
//                    IMBDriveWindow *driveWindow = [_driveControllerDic objectForKey:_baseDriveManage.userID];
//                    [driveWindow showWindow:self];
//                }
//            }else{
//                _baseDriveManage = [[IMBDriveManage alloc]initWithUserID:loginTextId withDelegate:self];
//            }
////        }else{
////            _driveManage = [[IMBDriveManage alloc]initWithUserID:loginTextId withDelegate:self];
////        }
////    }
//    [_loginTextField.cell setEnabled:YES];
//    [_passTextField.cell setEnabled:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ICLOUD_SIGNIN_FAIL object:nil userInfo:nil];
//}
//
//- (void)switchViewController {
//    if ([_driveControllerDic.allKeys containsObject:_baseDriveManage.userID]) {
//        IMBDriveWindow *driveWindow = [_driveControllerDic objectForKey:_baseDriveManage.userID];
//        [driveWindow showWindow:self];
//    }else{
//        IMBDriveWindow *driveWindow = [[IMBDriveWindow alloc]initWithDrivemanage:(IMBDriveManage *)_baseDriveManage withisiCloudDrive:NO];
//        [_driveControllerDic setObject:driveWindow forKey:_baseDriveManage.userID];
//        //    IMBDevicePageWindow *devicePagewindow = [[IMBDevicePageWindow alloc] initWithiPod:ipod];
//        [[driveWindow window] center];
//        [driveWindow showWindow:self];
//        [driveWindow release];
//    }
//}

#pragma mark - iCloud Diver Login

- (IBAction)iCloudLogIn:(id)sender {

    if (_isCheckBoxSelected && _iCloudUserTextField.stringValue.length) {
        //当checkbox选中并且用户名有值的情况下，存储用户名
        [[NSUserDefaults standardUserDefaults] setValue:_iCloudUserTextField.stringValue forKey:IMBiCloudUserName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self addLoginLoadingAnimation];
    _baseDriveManage = [[IMBiCloudDriveManager alloc]initWithUserID:_iCloudUserTextField.stringValue WithPassID:_iCloudSecireTextField.stringValue WithDelegate:self];
}

- (void)switchiCloudDriveViewController {
    [self removeLoginLoadingAnimation];
    IMBDeviceConnection *deivceConnection = [IMBDeviceConnection singleton];
    IMBBaseInfo *baseInfo = [[IMBBaseInfo alloc] init];
    [baseInfo setDeviceName:_baseDriveManage.userID];
    [baseInfo setUniqueKey:_baseDriveManage.userID];
    [baseInfo setConnectType:general_iCloud];
    [baseInfo setIsicloudView:YES];
    [baseInfo setChooseModelEnum:iCloudLogEnum];
    [[deivceConnection allDevices] addObject:baseInfo];
    [baseInfo release];
    baseInfo = nil;
    [_delegate changeMainFrame:nil withMedleEnum:iCloudLogEnum withiCloudDrvieBase:_baseDriveManage];
    //    }
}
//登录错误
- (void)driveLogInFial:(ResponseCode)responseCode {
    [_passTextField.cell setEnabled:YES];
    [_iCloudUserTextField.cell setEnabled:YES];
    [_passTextField setEditable:YES];
    [_iCloudUserTextField setEditable:YES];
    _isEnter = NO;
    if (responseCode == ResponseUserNameOrPasswordError) {//密码或者账号错误
        [self removeLoginLoadingAnimation];
    }else if (responseCode == ResonseSecurityCodeError) {//<沿验证码错误
        [self removeLoginLoadingAnimation];
    }else if (responseCode == ResponseUnknown) {//未知错误
        [self removeLoginLoadingAnimation];
    }else if (responseCode == ResponseInvalid) {///<响应无效 一般参数错误
        [self removeLoginLoadingAnimation];
    }
    NSAlert *alert = [NSAlert alertWithMessageText:@"Error" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Error"];
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        
    }];
    
}

- (void)driveNeedSecurityCode:(iCloudDrive *)iCloudDrive {
    [self removeLoginLoadingAnimation];
}

- (IBAction)codeDown:(id)sender {
    [(IMBiCloudDriveManager *)_baseDriveManage  setTwoCodeID:_twoCode.stringValue];
}

//时间转换
- (NSString *)dateForm2001DateSting:(NSString *) dateSting {
    if ([StringHelper stringIsNilOrEmpty:dateSting] ) {
        return @"";
    }
    NSString *replacString = [dateSting stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString * replacString1 = [replacString substringToIndex:19];
    NSDate *replacDate = [DateHelper dateFromString:replacString1 Formate:nil];
    NSString *replacDateString = [DateHelper dateFrom2001ToDate:replacDate withMode:2];
    return replacDateString;
}


#pragma mark - 通知
/**
 *  设备选择切换响应方法
 *
 *  @param noti noti
 */
- (void)changBtnState {
    if ([_iCloudUserTextField.stringValue isEqualToString:@""]) {
        [_iCloudUserTextField setPlaceholderString:CustomLocalizedString(@"MainWindow_iCLoudUserPlaceholder_String", nil)];
    }else {
        [_iCloudUserTextField setPlaceholderString:CustomLocalizedString(@"", nil)];
    }
}

- (void)selectedDeviceDidChangeNoti:(NSNotification *)noti {
    
    if (_selectView) {
        [_selectView hideWithTimeInterval:0.2];
    }
    IMBBaseInfo *baseInfo = [noti object];
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
//    for (IMBBaseInfo *baseInfo1 in deviceConnection.allDevices) {
//        if ([baseInfo.uniqueKey isEqualToString:baseInfo1.uniqueKey]) {
//            baseInfo.isSelected = YES;
//        }else{
//            
//        }
//    }
    _selectedBaseInfo = baseInfo;
//    [baseInfo setIsSelected:YES];
    [self selectedDeviceDidChange];
}
// 选择设备按钮 切换界面
- (void)selectedDeviceDidChange {
    if (_devPopover.isShown) {
        [_devPopover close];
    }
//    [self setDeviceInfosWithiPod:_selectedBaseInfo];
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    IMBiPod *ipod = [deviceConnection getiPodByKey:_selectedBaseInfo.uniqueKey];
    
//    if (!_selectedBaseInfo.isSelected) {
////        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
////        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            _selectedBaseInfo.isSelected = YES;
//            IMBDevicePageViewController *devicePageView = [[IMBDevicePageViewController alloc]initWithiPod:_iPod];
//            [_rootBox setContentView:devicePageView.view];
////            IMBDevicePageWindow *devicePagewindow = [[IMBDevicePageWindow alloc] initWithiPod:ipod];
////            [[devicePagewindow window] center];
////            [devicePagewindow showWindow:self];
////            [_windowControllerDic setObject:devicePagewindow forKey:ipod.uniqueKey];
////            [devicePagewindow release];
////            devicePagewindow = nil;
////        });
//    }else{
////        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
////        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            IMBDevicePageWindow *devicePagewindow = [_windowControllerDic objectForKey:ipod.uniqueKey];
//            [[devicePagewindow window] center];
//            [devicePagewindow showWindow:self];
////        });
//    }
//    ;
    [_delegate changeMainFrame:ipod withMedleEnum:DeviceLogEnum withiCloudDrvieBase:nil];

}

- (NSString*)getSystemLastNumberString {
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSString *systemVersion = processInfo.operatingSystemVersionString;
    NSArray *array = [systemVersion componentsSeparatedByString:@"."];
    NSString *lastStr = @"0";
    if (array.count >= 2) {
        lastStr = [array objectAtIndex:1];
    }
    return lastStr;
}

- (void)mainWindowClose{
    if (_windowControllerDic.count > 0) {
        for (NSWindowController * chooseWindow in _windowControllerDic.allValues) {
            [chooseWindow.window close];
        }
    }
}

- (void)insertTabKey:(id)sender {
    [_passTextField becomeFirstResponder];
    if (_isSecureMode) {
        [_iCloudSecireTextField becomeFirstResponder];
    }else{
        [_icloudLoginPwdTextfield becomeFirstResponder];
    }
}

- (void)dealloc {
    
    [_mainWindowController release];
    _mainWindowController = nil;
    
    [_windowControllerDic release];
    _windowControllerDic = nil;
    
    if (_selectView) {
        [_selectView release];
        _selectView = nil;
    }
    if (_devPopover) {
        [_devPopover release];
        _devPopover = nil;
    }
    
    if (_driveControllerDic) {
        [_driveControllerDic release];
        _driveControllerDic = nil;
    }

    if (_baseDriveManage) {
        [_baseDriveManage release];
        _baseDriveManage = nil;
    }

    [[IMBDeviceConnection singleton] stopListening];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBSelectedDeviceDidChangeNotiWithParams object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:INSERT_TAB object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_TEXTFILED_INPUT_CHANGE object:nil];
    [super dealloc];
    
}


#pragma mark - 其他
#pragma mark - 加载动画的添加和移除
- (void)addLoginLoadingAnimation {
    [_iCloudDriveView setDisable:YES];
    [_oneDriveView setDisable:YES];
    [_devicesView setDisable:YES];
    
    [icloudLoginbtn setEnabled:NO];
    _loadLayer = [[CALayer alloc]init];
    _loadLayer.contents = [NSImage imageNamed:@"other_sending"];
    [_checkoutPwdBtn setHidden:YES];
    [_loadLayer setFrame:NSMakeRect(_checkoutPwdBtn.frame.origin.x, _checkoutPwdBtn.frame.origin.y, 12, 12)];
    [_icloudCustomView setWantsLayer:YES];
    [[_icloudCustomView layer] addSublayer:_loadLayer];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(2*M_PI);
    animation.toValue = 0;
    animation.repeatCount = MAXFLOAT;
    animation.duration = 1.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //    [_loadingImg setWantsLayer:YES];
    [_loadLayer addAnimation:animation forKey:@""];
}


- (void)loadbookCover:(NSArray *)array {

//    [queue addOperationWithBlock:^{
        for (IMBBookEntity *book in array ) {
            
            __block NSString *filePath = nil;
            @synchronized(self){
                NSData *data = nil;
                if ([book.extension isEqualToString:@"epub"]) {
                    filePath = book.coverPath;
                    data = [self loadEpubCover:filePath];
                }else if ([book.extension isEqualToString:@"pdf"]&&!book.isPurchase)
                {
                    filePath = [NSString stringWithFormat:@"Books/%@",book.path];
                    data = [self loadPdfCover:filePath];
                }else
                {
                    filePath = [NSString stringWithFormat:@"Books/Purchases/%@",book.path];
                    data = [self loadPdfCover:filePath];
                }
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSImage *image = [[NSImage alloc] initWithData:data];
                    if (image != nil) {
                        [image setSize:NSMakeSize(110, 168)];
                        book.coverImage = image;
                    }else
                    {
                        book.bookTitle = book.bookName;
                    }
                    [image release];
                    
                });
            }
        }

//    }];
}

//加载epub的封面
- (NSData *)loadEpubCover:(NSString *)filePath {
    AFCDirectoryAccess *afcDir = [_iPod.deviceHandle newAFCMediaDirectory];
    AFCFileReference *infile = [afcDir openForRead:filePath];
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    const uint32_t bufsz = 10240;
    char *buff = malloc(bufsz);
    uint32_t done = 0;
    while (1) {
        uint64_t n = [infile readN:bufsz bytes:buff];
        if (n==0) break;
        NSData *b2 = [[NSData alloc]
                      initWithBytesNoCopy:buff length:n freeWhenDone:NO];
        [data appendData:b2];
        [b2 release];
        done += n;
    }
    
    free(buff);
    // close output file
    [infile closeFile];
    [afcDir close];
    return data;
}

//加载pdf的封面 pdf的封面默认是第一页
- (NSMutableData *)loadPdfCover:(NSString *)filePath {
    
    NSMutableData *pdfData = [NSMutableData data];
    int desiredResolution = 200; // in DPI
    
    BOOL morePages = YES;
    int page = 1;
    
    // Package all arguments as NSStrings in an NSArray
    NSMutableArray* args = [NSMutableArray array];
    [args addObject:@"--page"];
    [args addObject:@"1"];
    // If we have a "--dpi" along with a corresponding argument ...
    NSUInteger index = NSNotFound;
    if ( (index = [args indexOfObject: @"--dpi"]) != NSNotFound && index + 1 < [args count] )
    {
        // Parse it as an integer
        desiredResolution = [[args objectAtIndex: index + 1] intValue];
        [args removeObjectAtIndex: index + 1];
        [args removeObjectAtIndex: index];
    }
    // If we have a "--page" along with a corresponding argument ...
    if ( (index = [args indexOfObject: @"--page"]) != NSNotFound && index + 1 < [args count] )
    {
        // Parse it as an integer
        page = [[args objectAtIndex: index + 1] intValue];
        morePages = NO;
        [args removeObjectAtIndex: index + 1];
        [args removeObjectAtIndex: index];
    }
    // --transparent    Do not fill background white color, keep transparency from PDF.
    BOOL keepTransparent = NO;
    if ( (index = [args indexOfObject: @"--transparent"]) != NSNotFound )
    {
        keepTransparent = YES;
        [args removeObjectAtIndex: index];
    }
    
    AFCDirectoryAccess *afcDir = [_iPod.deviceHandle newAFCMediaDirectory];
    AFCFileReference *infile = [afcDir openForRead:filePath];
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    const uint32_t bufsz = 10240;
    char *buff = malloc(bufsz);
    uint32_t done = 0;
    while (1) {
        uint64_t n = [infile readN:bufsz bytes:buff];
        if (n==0) break;
        NSData *b2 = [[NSData alloc]
                      initWithBytesNoCopy:buff length:n freeWhenDone:NO];
        [data appendData:b2];
        [b2 release];
        done += n;
    }
    
    free(buff);
    // close output file
    [infile closeFile];
    [afcDir close];
    
    
    NSImage* source = [ [NSImage alloc] initWithData:data];
    [source setScalesWhenResized: YES];
    
    
    // Allows setCurrentPage to do anything
    [source setDataRetained: YES];
    
    if ( source == nil )
    {
        return nil;
    }
    
    // The output file name
    NSString* outputFileFormat = @"%@-p%01d";
    
    // Find the PDF representation
    NSPDFImageRep* pdfSource = NULL;
    NSArray* reps = [source representations];
    [source release];
    for ( int i = 0; i < [reps count] && pdfSource == NULL; ++ i )
    {
        if ( [[reps objectAtIndex: i] isKindOfClass: [NSPDFImageRep class]] )
        {
            pdfSource = [reps objectAtIndex: i];
            [pdfSource setCurrentPage: page-1];
            
            // Set the output format to have the correct number of leading zeros
            NSString *string0 = [NSString stringWithFormat: @"%ld", (long)[pdfSource pageCount]];
            long numDigits = [string0 length];
            outputFileFormat = [NSString stringWithFormat: @"%%@-p%%0%ldd", numDigits];
        }
    }
    
    [NSApplication sharedApplication];
    [[NSGraphicsContext currentContext] setImageInterpolation: NSImageInterpolationHigh];
    NSSize sourceSize = [pdfSource size];
    if (sourceSize.height == 0 && sourceSize.width == 0) {
        return nil;
    }
    do
    {
        // Set up a temporary release pool so memory will get cleaned up properly
        NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init];
        NSSize sourceSize = [pdfSource size];
        // int pixels = [ [source bestRepresentationForDevice: nil] pixelsWide];
        // if ( pixels != 0 ) sourceResolution = ((double)pixels / sourceSize.width) * 72.0;
        
        NSSize size = NSMakeSize( sourceSize.width * 0.2, sourceSize.width * 0.2*159/104 );
        
        //	[source setSize: size];
        NSRect sourceRect = NSMakeRect( 0, 0, sourceSize.width, sourceSize.height );
        NSRect destinationRect = NSMakeRect( 0, 0, size.width, size.height );
        
        NSImage* image = [[NSImage alloc] initWithSize:size];
        [image lockFocus];
        
        
        if (keepTransparent) {
            [pdfSource drawInRect: destinationRect
                         fromRect: sourceRect
                        operation: NSCompositeCopy fraction: 1.0 respectFlipped: NO hints: [NSDictionary dictionary] ];
        } else {
            [[NSColor whiteColor] set];
            NSRectFill( destinationRect );
            [pdfSource drawInRect: destinationRect
                         fromRect: sourceRect
                        operation: NSCompositeSourceOver fraction: 1.0 respectFlipped: NO hints: [NSDictionary dictionary] ];
        }
        
        NSBitmapImageRep* bitmap = [ [NSBitmapImageRep alloc]
                                    initWithFocusedViewRect: destinationRect ];
        
        [pdfData appendData:[bitmap representationUsingType:NSPNGFileType properties:nil]];
        [bitmap release];
        if ( morePages == YES )
        {
            // Go get the next page
            if ( pdfSource != NULL && page < [pdfSource pageCount] )
            {
                [pdfSource setCurrentPage: page];
                [source recache];
                page ++;
            }
            else
            {
                morePages = NO;
            }
        }
        
        [image unlockFocus];
        [image release];
        [loopPool release];
    }
    while ( morePages == YES );
    return pdfData;
    
}

- (void)closeWindow:(id)sender {
    [_delegate closeWindow:sender];
}

- (void)removeLoginLoadingAnimation {
    [_iCloudDriveView setDisable:NO];
    [_oneDriveView setDisable:NO];
    [_devicesView setDisable:NO];
    
    if (_loadLayer) {
        [_loadLayer removeFromSuperlayer];
        [_loadLayer release];
        _loadLayer = nil;
    }
    [icloudLoginbtn setEnabled:YES];
    [_checkoutPwdBtn setHidden:NO];
}

@end
