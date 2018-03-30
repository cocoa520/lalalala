


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
#import "NSString+Category.h"
#import "IMBInformation.h"
#import "IMBInformationManager.h"
#import "IMBCommonDefine.h"
#import "DateHelper.h"
#import "StringHelper.h"
#import "IMBDriveEntity.h"
#import "IMBDriveManage.h"
#import "StringHelper.h"
#import "IMBViewAnimation.h"
#import "IMBSelectConntedDeviceView.h"
#import "IMBDropBoxManage.h"
#import <Quartz/Quartz.h>
#import "IMBDevicePageViewController.h"
#import "IMBViewManager.h"
#import "IMBCommonTool.h"
#import <objc/runtime.h>


static CGFloat const SelectedBtnTextFont = 15.0f;


@interface IMBDeviceViewController ()
{
    @private
    NSMutableArray *_devicesArray;
    IMBSelectConntedDeviceView *_selectView;
    IMBDevViewController *_devController;
    IMBBaseInfo *_selectedBaseInfo;
    NSString *_bigDevicesConnectedImageName;
}

@end

@implementation IMBDeviceViewController
@synthesize isNewController = _isNewController;
@synthesize delegate = _delegate;
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
    
    if (_alertSuperView) {
        objc_setAssociatedObject([NSApplication sharedApplication], &kIMBMainWindowAlertView, _alertSuperView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    _isSecureMode = YES;
    _isCheckBoxSelected = NO;
    [(IMBBackgroundBorderView*)self.view setHasRadius:YES];
    [(IMBBackgroundBorderView*)self.view setBackgroundColor:COLOR_MAIN_WINDOW_BG];
    [_rootBox setContentView:_mainView];
    
    
//    NSMutableDictionary *attrText = [[NSMutableDictionary alloc] init];
//    [attrText setValue:COLOR_MAINWINDOW_MESSAGE_TEXT forKey:NSForegroundColorAttributeName];
//    [attrText setValue:IMBCommonFont forKey:NSFontAttributeName];
//    
//    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_bigSizeIcloudGoNowBtn.stringValue attributes:attrText];
//    [_bigSizeIcloudGoNowBtn setAttributedStringValue:attrString];
    
//    [attrText release];
//    attrText = nil;
//    [attrString release];
//    attrString = nil;
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
    
    if (_isNewController) {
        IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
        IMBBaseInfo *baseInfo = [deviceConnection.allDevices firstObject];
        [_selectedDeviceBtn setHidden:NO];
        [_selectedDeviceBtn configButtonName:baseInfo.deviceName WithTextColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT WithTextSize:SelectedBtnTextFont WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:baseInfo.connectType rightIcon:@"arrow"];
    }
//    [self mouseDown:nil];
}

#pragma mark - 初始化，view的点击事件，鼠标进出view的响应事件
/**
 *  初始化
 */
- (void)setupView {
    _isEnable = YES;
    
    [_shoppingCartBtn setHoverImage:@"nav_icon_cart_hover"];
    [_helpBtn setHoverImage:@"nav_icon_help_hover"];
    
    [_midiumiCloudClickLoginBtn setStringValue:CustomLocalizedString(@"MainWindow_iCloud_ClickTo_Login", nil)];
    [_midiumDropBoxClickLoginBtn setStringValue:CustomLocalizedString(@"MainWindow_iCloud_ClickTo_Login", nil)];
    _midiumiCloudClickLoginBtn.font = [NSFont fontWithName:IMBCommonFont size:14.f];
    _midiumDropBoxClickLoginBtn.font = [NSFont fontWithName:IMBCommonFont size:14.f];
    _midiumiCloudClickLoginBtn.textColor = COLOR_MAINWINDOW_MESSAGE_TEXT;
    _midiumDropBoxClickLoginBtn.textColor = COLOR_MAINWINDOW_MESSAGE_TEXT;
    
    _midiumIcloudMsgLabel.stringValue = CustomLocalizedString(@"MainWindow_iCloud_Msg_String", nil);
    _midiumDropboxMsgLabel.stringValue = CustomLocalizedString(@"MainWindow_Dropbox_Msg_String", nil);
    _midiumIcloudMsgLabel.font = [NSFont fontWithName:IMBCommonFont size:14.f];
    _midiumDropboxMsgLabel.font = [NSFont fontWithName:IMBCommonFont size:14.f];
    _midiumIcloudMsgLabel.textColor = COLOR_MAINWINDOW_MESSAGE_TEXT;
    _midiumDropboxMsgLabel.textColor = COLOR_MAINWINDOW_MESSAGE_TEXT;
    
    _midiumIcloudTitleLabel.stringValue = CustomLocalizedString(@"MainWindow_iCloud_Title_String", nil);
    _midiumDropboxTitleLabel.stringValue = CustomLocalizedString(@"MainWindow_Dropbox_Title_String", nil);
    _midiumIcloudTitleLabel.font = [NSFont fontWithName:IMBCommonFont size:14.f];
    _midiumDropboxTitleLabel.font = [NSFont fontWithName:IMBCommonFont size:14.f];
    _midiumIcloudTitleLabel.textColor = COLOR_MAINWINDOW_MESSAGE_TEXT;
    _midiumDropboxTitleLabel.textColor = COLOR_MAINWINDOW_MESSAGE_TEXT;
    
    
    [_iCloudUserTextField setPlaceholderString:CustomLocalizedString(@"MainWindow_iCLoudUserPlaceholder_String", nil)];
    [icloudLoginbtn WithMouseExitedtextColor:[NSColor whiteColor] WithMouseUptextColor:[NSColor whiteColor] WithMouseDowntextColor:IMBGrayColor(240) withMouseEnteredtextColor:IMBGrayColor(245)];
    [icloudLoginbtn WithMouseExitedfillColor:COLOR_BTN_BLUE_BG WithMouseUpfillColor:[COLOR_BTN_BLUE_BG colorWithAlphaComponent:0.8] WithMouseDownfillColor:[COLOR_BTN_BLUE_BG colorWithAlphaComponent:0.7] withMouseEnteredfillColor:[COLOR_BTN_BLUE_BG colorWithAlphaComponent:0.8]];
    [icloudLoginbtn setTitleName:CustomLocalizedString(@"MainWindow_BigSize_Icloud_LoginBtnString" , nil)WithDarwRoundRect:4.f WithLineWidth:0 withFont:[NSFont systemFontOfSize:14.f]];
    
    
    [_devicesView setIsDevicesOriginalFrame:YES];
    
    [_iCloudUserTextField setTextColor:COLOR_TEXT_ORDINARY];
    [((customTextFieldCell *)_iCloudUserTextField.cell) setCursorColor:COLOR_TEXT_ORDINARY];
    
    NSMutableAttributedString *as6 = [[[NSMutableAttributedString alloc] initWithString:@"iCloud ID"] autorelease];
    [as6 addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN_WINDOW_TEXTFIELD_TEXT range:NSMakeRange(0, as6.string.length)];
    [as6 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as6.string.length)];
    [as6 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:NSMakeRange(0, as6.string.length)];
    [_iCloudUserTextField.cell setPlaceholderAttributedString:as6];

    /****  选择设备按钮鼠标进入显示已连接设备view  ****/
    _selectedDeviceBtn.mouseEntered = ^(void){
        if (_selectView.isShowing) {//如果selectView正在显示，则不执行下面的代码
            return;
        }
        IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
        if (_devController) {
            [_devController release];
            _devController = nil;
        }
        _devController = [[IMBDevViewController alloc] initWithNibName:@"IMBDevViewController" bundle:nil];
        
        NSMutableArray *allDevices = [NSMutableArray array];
        
        if (deviceConnection.allDevices.count) {
            for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
                if (baseInfo.chooseModelEnum == DeviceLogEnum) {
                    [allDevices addObject:baseInfo];
                }
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
        if (_iCloudDriveView.loginStatus) {//如果icloud登陆成功，则直接进入详情界面
            [self icloudViewClicked];
        }else {
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
        }
        
    };
    /***  _oneDriveView的鼠标点击响应事件 ***/
    _oneDriveView.mouseClicked = ^(void){
        if (_oneDriveView.loginStatus) {//如果dropbox登陆成功，则直接进入详情界面
            [self dropboxViewClicked];
        }else {
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
        }
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
                [_bigDevicesImageView setImage:[NSImage imageNamed:@"mod_device_no"]];
            }
            
            
        }];
    };
    
    /***  鼠标进出view响应事件 ***/
    /***  鼠标进入view响应事件 ***/
    _iCloudDriveView.mouseEntered = ^(void){
        if (_iCloudDriveView.loginStatus) {
            [IMBViewAnimation animationOpacityWithView:_loginSuccessiCloudView.logoutBtn timeInterval:MidiumSizeAnimationTimeInterval + 0.15f isHidden:NO];
        }else {
            NSRect newFrame = NSMakeRect(15.0f, 212.0f, 308.0f, 188.0f);
            [IMBViewAnimation animationScaleWithView:_icloudShadowView frame:newFrame timeInterval:MidiumSizeAnimationTimeInterval + 0.15f disable:NO completion:nil];
            [self setMouseEnteredMidiumContentViewWithView:_midiumiCloudContentView btn:_midiumiCloudClickLoginBtn];
        }
        
    };
    _oneDriveView.mouseEntered = ^(void){
        if (_oneDriveView.loginStatus) {
            [IMBViewAnimation animationOpacityWithView:_loginSuccessdropboxView.logoutBtn timeInterval:MidiumSizeAnimationTimeInterval + 0.15f isHidden:NO];
        }else {
            NSRect newFrame = NSMakeRect(15.0f, 16.0f, 308.0f, 188.0f);
            [IMBViewAnimation animationScaleWithView:_dropboxShadowView frame:newFrame timeInterval:MidiumSizeAnimationTimeInterval + 0.15f disable:NO completion:nil];
            [self setMouseEnteredMidiumContentViewWithView:_midiumDropBoxContentView btn:_midiumDropBoxClickLoginBtn];
        }
       
    };
    _devicesView.mouseEntered = ^(void){
        NSRect newFrame = NSMakeRect(333.f, 16.0f, 244.0f, 384.0f);
        [IMBViewAnimation animationScaleWithView:_devicesShadowView frame:newFrame timeInterval:MidiumSizeAnimationTimeInterval + 0.15f disable:NO completion:nil];
    };
    
    /***  鼠标移除view响应事件 ***/
    _iCloudDriveView.mouseExited = ^(void){
        if (_iCloudDriveView.loginStatus) {
            [IMBViewAnimation animationOpacityWithView:_loginSuccessiCloudView.logoutBtn timeInterval:MidiumSizeAnimationTimeInterval + 0.15f isHidden:YES];
        }else {
            _icloudShadowView.frame = NSMakeRect(18.0f, 216.0f, 302.0f, 180.0f);
            [self setMouseExitedMidiumContentViewWithView:_midiumiCloudContentView btn:_midiumiCloudClickLoginBtn timeInterval:MidiumSizeAnimationTimeInterval - 0.2f];
        }
        
    };
    _oneDriveView.mouseExited = ^(void){
        if (_oneDriveView.loginStatus) {
            [IMBViewAnimation animationOpacityWithView:_loginSuccessdropboxView.logoutBtn timeInterval:MidiumSizeAnimationTimeInterval + 0.15f isHidden:YES];
        }else {
            _dropboxShadowView.frame = NSMakeRect(18.0f, 20.0f, 302.0f, 180.0f);
            [self setMouseExitedMidiumContentViewWithView:_midiumDropBoxContentView btn:_midiumDropBoxClickLoginBtn timeInterval:MidiumSizeAnimationTimeInterval - 0.2f];
        }
        
    };
    _devicesView.mouseExited = ^(void){
        _devicesShadowView.frame = NSMakeRect(336.0f, 20.0f, 238.0f, 376.0f);
    };
}


#pragma mark - 鼠标响应事件
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

- (void)setMouseExitedMidiumContentViewWithView:(NSView *)view btn:(NSView *)btn timeInterval:(CGFloat)timeInterval {
    NSRect f = view.frame;
    f.origin.y = 0;
    [IMBViewAnimation animationMouseEnteredExitedWithView:view frame:f timeInterval:timeInterval disable:NO completion:nil];
    
    
    NSRect btnF = btn.frame;
    [IMBViewAnimation animationMouseMovedWithView:btn frame:btnF timeInterval:timeInterval disable:NO completion:^{
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

- (void)mouseUp:(NSEvent *)theEvent {
    if (_isEnable == NO) return;
    
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
        
        if (_oneDriveView.loginStatus) {
            [_oneDriveBox setContentView:_loginSuccessdropboxView.view];
        }else {
            [_oneDriveBox setContentView:_midiumSizeOneDriveView];
        }
        if (_iCloudDriveView.loginStatus) {
            [_icloudDrivebox setContentView:_loginSuccessiCloudView.view];
        }else {
            [_icloudDrivebox setContentView:_midiumSizeiCloudView];
        }
        
        [self setMouseExitedMidiumContentViewWithView:_midiumDropBoxContentView btn:_midiumDropBoxClickLoginBtn timeInterval:MidiumSizeAnimationTimeInterval - 0.2f];
        
        [self setDeviceViewConnecteStatus];
        
        if (_iCloudDriveView.loginStatus) {
            [IMBViewAnimation animationOpacityWithView:_loginSuccessiCloudView.logoutBtn timeInterval:0 isHidden:YES];
        }else {
            _icloudShadowView.frame = NSMakeRect(18.0f, 216.0f, 302.0f, 180.0f);
            [self setMouseExitedMidiumContentViewWithView:_midiumiCloudContentView btn:_midiumiCloudClickLoginBtn timeInterval:0];
        }
        if (_oneDriveView.loginStatus) {
            [IMBViewAnimation animationOpacityWithView:_loginSuccessdropboxView.logoutBtn timeInterval:0 isHidden:YES];
        }else {
            _dropboxShadowView.frame = NSMakeRect(18.0f, 20.0f, 302.0f, 180.0f);
            [self setMouseExitedMidiumContentViewWithView:_midiumDropBoxContentView btn:_midiumDropBoxClickLoginBtn timeInterval:0];
        }
    }];
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
        //设备断开连接----TODO:处理有问题    已修改
        NSMutableArray *allDevices = [NSMutableArray array];
        if (deviceConnection.allDevices.count) {
            for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
                if (baseInfo.chooseModelEnum == DeviceLogEnum) {
                    [allDevices addObject:baseInfo];
                }
            }
            if (allDevices.count) {
                IMBBaseInfo *baseInfo = [allDevices firstObject];
                if (![baseInfo.uniqueKey isEqualToString:_selectedBaseInfo.uniqueKey]) {
                    [self setDeviceInfosWithiPod:baseInfo];
                    [self deviceDisconnected:serialNum];
                    _selectedBaseInfo = baseInfo;
                }
            }else {
                [_selectedDeviceBtn setHidden:YES];
                [self deviceDisconnected:serialNum];
                _selectedBaseInfo = nil;
            }
            
            
        }else {
            [_selectedDeviceBtn setHidden:YES];
            [self deviceDisconnected:serialNum];
            _selectedBaseInfo = nil;
        }
        
        //设备断开时，窗口的操作
        IMBViewManager *viewManager = [IMBViewManager singleton];
        if ([viewManager.windowDic.allKeys containsObject:serialNum]) {
            IMBMainWindowController *windowController = [viewManager.windowDic objectForKey:serialNum];
            [windowController backMainViewChooseLoginModelEnum];
        }
        if ([viewManager.allMainControllerDic.allKeys containsObject:serialNum]) {
            [viewManager.allMainControllerDic removeObjectForKey:serialNum];
        }
    };
    deviceConnection.IMBDeviceNeededPassword = ^(am_device device){
        //设备连接需要密码
        if (deviceConnection.allDevices.count == 0) {
            
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
    
}

- (void)deviceDisconnected:(NSString *)serialNum {
    [[IMBLogManager singleton] writeInfoLog:@"Disconneted"];
    if ([[IMBDeviceConnection singleton] isConnectedDevice]) {
        
        [_bigDevicesImageView setImage:[NSImage imageNamed:_bigDevicesConnectedImageName]];
    }else {
        if (_devicesView.isDevicesOriginalFrame) {
            [_bigDevicesImageView setImage:[NSImage imageNamed:@"mod_device"]];
        }else {
            [_bigDevicesImageView setImage:[NSImage imageNamed:@"mod_device_no"]];
        }
    }
    
    if (_devPopover != nil) {
        if (_devPopover.isShown) {
            [_devPopover close];
        }
    }
}

- (void)deviceNeededPwd:(am_device)device {
    [[IMBLogManager singleton] writeInfoLog:@"Connetion Needs Password"];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [IMBCommonTool showTwoBtnsAlertInMainWindow:nil firstBtnTitle:@"Cancel" secondBtnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"AlertView_Device_Need_Pwd", nil) firstBtnClickedBlock:nil secondBtnClickedBlock:^{
            //点击确定，重新链接设备
            [[IMBDeviceConnection singleton] performSelector:@selector(reConnectDevice:) withObject:(id)device afterDelay:1.0f];
        }];
    });
    
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
        [_selectedDeviceBtn configButtonName:_selectedBaseInfo.deviceName WithTextColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT WithTextSize:SelectedBtnTextFont WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:baseInfo.connectType rightIcon:@"popup_icon_arrow"];
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
            information.allPhotoArray = [cameraRoll retain];
            [cameraRoll release];
            [information.ipod setPhotoLoadFinished:YES];
            [inforManager.informationDic setObject:information forKey:_iPod.uniqueKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:DeviceDataLoadCompletePhoto object:_iPod];
        });
    });

    dispatch_async(spatchqueue, ^{
        [information loadiBook];
        NSArray *ibooks = [information allBooksArray] ;
        [IMBCommonTool loadbookCover:ibooks ipod:_iPod];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_iPod setBookLoadFinished:YES];
            [inforManager.informationDic setObject:information forKey:_iPod.uniqueKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:deviceDataLoadCompleteBooks object:_iPod];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:deviceDataLoadCompleteMedia object:_iPod];
            [[NSNotificationCenter defaultCenter] postNotificationName:DeviceDataLoadCompleteVideo object:_iPod];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:DeviceDataLoadCompleteApp object:_iPod];
        });
    });
    
}

#pragma mark - action

#pragma mark - iCloud、dropbox登录成功后view点击响应事件

//iCloud点击事件
- (void)icloudViewClicked {
    [_delegate changeMainFrame:nil withMedleEnum:iCloudLogEnum withiCloudDrvieBase:_baseDriveManage];
}

//dropbox点击事件
- (void)dropboxViewClicked {
    [_delegate changeMainFrame:nil withMedleEnum:DropBoxLogEnum withiCloudDrvieBase:_baseDriveManage];
}

/**
 *  设备选择按钮点击
 *
 *  @param sender 按钮
 */
#pragma mark - icloud、dropbox退出登录按钮点击事件
- (void)signoutiCloudClicked {
    _iCloudDriveView.loginStatus = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:_baseDriveManage.userID];
    [[IMBDeviceConnection singleton] removeDeviceByKey:_baseDriveManage.userID];
    IMBViewManager *viewManger = [IMBViewManager singleton];
    [viewManger.allMainControllerDic removeObjectForKey:@"iCloud"];
    [_baseDriveManage userDidLogout];
    [_icloudDrivebox setContentView:_midiumSizeiCloudView];
}

- (void)signoutDropboxClicked {
    _oneDriveView.loginStatus = NO;
    [[IMBDeviceConnection singleton] removeDeviceByKey:_baseDriveManage.userID];
    [_baseDriveManage userDidLogout];
    IMBViewManager *viewManger = [IMBViewManager singleton];
    [viewManger.allMainControllerDic removeObjectForKey:@"DropBox"];
    [_oneDriveBox setContentView:_midiumSizeOneDriveView];
}
#pragma mark - 其他按钮点击
- (IBAction)selectedDeviceBtnClicked:(IMBSelecedDeviceBtn *)sender {
    IMBFFuncLog;
    if (_selectView.isShowing) {
        if (_selectView) {
            [_selectView hideWithTimeInterval:0.2];
        }
        [self selectedDeviceDidChange];
    }
}

- (IBAction)oneDriveLogin:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ICLOUD_ENTER_SIGNIN object:nil userInfo:nil];
    [self signDown:sender];
}

- (IBAction)enterTextView:(id)sender {
    [_iCloudUserTextField setEditable:NO];
    [_iCloudUserTextField.cell setEnabled:NO];
    if (_isEnter) {
        return;
    }
    _isEnter = YES;
    [self iCloudLogIn:sender];
}

- (IBAction)enterText:(id)sender {
    [self iCloudLogIn:nil];
}
/**
 *  查看密码 按钮 点击
 */
- (IBAction)checkoutPwdClicked:(NSButton *)sender {
    if (_isSecureMode) {
        _isSecureMode = NO;
        [_iCloudSecireTextField setHidden:YES];
      
        _icloudLoginPwdTextfield.stringValue = _iCloudSecireTextField.stringValue;
        _iCloudSecireTextField.stringValue = @"";
        [_icloudLoginPwdTextfield becomeFirstResponder];
    }else {
        _isSecureMode = YES;
        _iCloudSecireTextField.stringValue = _icloudLoginPwdTextfield.stringValue;
        _icloudLoginPwdTextfield.stringValue = @"";
        [_iCloudSecireTextField setHidden:NO];
        [_iCloudSecireTextField becomeFirstResponder];
        
    }
}

/**
 *  记住我勾选按钮点击
 */
- (IBAction)checkBoxClicked:(NSButton *)sender {
    _isCheckBoxSelected = !_isCheckBoxSelected;
}

/**
 *  购物车按钮点击
 */
- (IBAction)shoppingCartClicked:(id)sender {
    
}

/**
 *  帮助按钮点击
 */
- (IBAction)helpClicked:(id)sender {
    
}

#pragma mark - Dropbox Login
- (void)signDown:(id)sender {
    _baseDriveManage = [[IMBDropBoxManage alloc] initWithUserID:nil withDelegate:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ICLOUD_SIGNIN_FAIL object:nil userInfo:nil];
}

- (void)switchViewController {
    [_iCloudUserTextField.cell setEnabled:YES];
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
    
    if (!_loginSuccessdropboxView) {
        _loginSuccessdropboxView = [[IMBMainWindowLoginSuccessView alloc] initWithNibName:@"IMBMainWindowLoginSuccessView" bundle:nil];
    }
    [_oneDriveBox setContentView:_loginSuccessdropboxView.view];
    //退出按钮点击
    _loginSuccessdropboxView.quitBtnClicked = ^{
        
        [self signoutDropboxClicked];
    };
    [_loginSuccessdropboxView.imageView setImage:[NSImage imageNamed:@"mod_dropboxdrive"]];
    [_loginSuccessdropboxView.sizeLabel setStringValue:[NSString stringWithFormat:@"%@/%@",[StringHelper getFileSizeString:baseInfo.allDeviceSize reserved:2],[StringHelper getFileSizeString:baseInfo.kyDeviceSize reserved:2]]];
    [_oneDriveView setLoginStatus:YES];
    
    [self mouseUp:nil];
    
    
    [baseInfo release];
    baseInfo = nil;
    [_delegate changeMainFrame:nil withMedleEnum:DropBoxLogEnum withiCloudDrvieBase:_baseDriveManage];
}

#pragma mark - iCloud Diver Login
- (IBAction)iCloudLogIn:(id)sender {
    if (_isCheckBoxSelected && _iCloudUserTextField.stringValue.length) {
        //当checkbox选中并且用户名有值的情况下，存储用户名
        [[NSUserDefaults standardUserDefaults] setValue:_iCloudUserTextField.stringValue forKey:IMBiCloudUserName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    _isEnable = NO;
    [self addLoginLoadingAnimation];
    if ([_icloudLoginPwdTextfield.stringValue isEqualToString:@""]) {
        _baseDriveManage = [[IMBiCloudDriveManager alloc]initWithUserID:_iCloudUserTextField.stringValue WithPassID:_iCloudSecireTextField.stringValue WithDelegate:self];
    }else {
        _baseDriveManage = [[IMBiCloudDriveManager alloc]initWithUserID:_iCloudUserTextField.stringValue WithPassID:_icloudLoginPwdTextfield.stringValue WithDelegate:self];
    }
    
}

- (void)switchiCloudDriveViewControllerWithiCloudDrive:(iCloudDrive *)icloudDrive {
    [self removeLoginLoadingAnimation];
    _isEnable = YES;
    IMBDeviceConnection *deivceConnection = [IMBDeviceConnection singleton];
    IMBBaseInfo *baseInfo = [[IMBBaseInfo alloc] init];
    [baseInfo setDeviceName:_baseDriveManage.userID];
    [baseInfo setUniqueKey:_baseDriveManage.userID];
    [baseInfo setConnectType:general_iCloud];
    [baseInfo setIsicloudView:YES];
    [baseInfo setKyDeviceSize:icloudDrive.usedStorageInBytes];
    [baseInfo setAllDeviceSize:icloudDrive.totalStorageInBytes];
    [baseInfo setChooseModelEnum:iCloudLogEnum];
    [[deivceConnection allDevices] addObject:baseInfo];
    
    if (!_loginSuccessiCloudView) {
        _loginSuccessiCloudView = [[IMBMainWindowLoginSuccessView alloc] initWithNibName:@"IMBMainWindowLoginSuccessView" bundle:nil];
    }
    [_icloudDrivebox setContentView:_loginSuccessiCloudView.view];
    //退出按钮点击
    _loginSuccessiCloudView.quitBtnClicked = ^{
        
        [self signoutiCloudClicked];
    };
    [_loginSuccessiCloudView.imageView setImage:[NSImage imageNamed:@"mod_iclouddrive"]];
    [_loginSuccessiCloudView.nameLabel setStringValue:_baseDriveManage.userID];
    [_loginSuccessiCloudView.sizeLabel setStringValue:[NSString stringWithFormat:@"%@/%@",[StringHelper getFileSizeString:baseInfo.kyDeviceSize reserved:2],[StringHelper getFileSizeString:baseInfo.allDeviceSize reserved:2]]];
    
    [_iCloudDriveView setLoginStatus:YES];
    
    [self mouseUp:nil];
    
    
    [_delegate changeMainFrame:nil withMedleEnum:iCloudLogEnum withiCloudDrvieBase:_baseDriveManage];
    
    [baseInfo release];
    baseInfo = nil;
}

//登录错误
- (void)driveLogInFial:(ResponseCode)responseCode {
    _isEnable = YES;
    [_iCloudUserTextField.cell setEnabled:YES];
    [_iCloudUserTextField setEditable:YES];
    _isEnter = NO;
    NSString *errStr = @"Error";
    switch (responseCode) {
        case ResponseUserNameOrPasswordError://密码或者账号错误
        {
            [self removeLoginLoadingAnimation];
            errStr = CustomLocalizedString(@"iCloud_LoginWarnig_Wrong_UsernameOrPwd", nil);
        }
            break;
        case ResonseSecurityCodeError://<沿验证码错误
        {
            [self removeLoginLoadingAnimation];
            errStr = CustomLocalizedString(@"iCloud_LoginWarnig_Wrong_Passcode", nil);
        }
            break;
        case ResponseUnknown://未知错误
        {
            [self removeLoginLoadingAnimation];
            errStr = CustomLocalizedString(@"iCloud_LoginWarnig_Uknown_Error", nil);
        }
            break;
        case ResponseInvalid://<响应无效 一般参数错误
        {
            [self removeLoginLoadingAnimation];
            errStr = CustomLocalizedString(@"iCloud_LoginWarnig_No_Reponse", nil);
        }
            break;
            
        default:
            break;
    }
    [IMBCommonTool showSingleBtnAlertInMainWindow:nil btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:errStr btnClickedBlock:nil];
}

- (void)driveNeedSecurityCode:(iCloudDrive *)iCloudDrive {
    _isEnable = YES;
    [self removeLoginLoadingAnimation];
}

- (IBAction)codeDown:(id)sender {
//    [(IMBiCloudDriveManager *)_baseDriveManage  setTwoCodeID:_twoCode.stringValue];
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

- (void)insertTabKey:(id)sender {
    if (_isSecureMode) {
        [_iCloudSecireTextField becomeFirstResponder];
    }else{
        [_icloudLoginPwdTextfield becomeFirstResponder];
    }
}

- (void)dealloc {
    if (_selectView) {
        [_selectView release];
        _selectView = nil;
    }
    if (_devPopover) {
        [_devPopover release];
        _devPopover = nil;
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
    [_loadLayer addAnimation:animation forKey:@""];
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
