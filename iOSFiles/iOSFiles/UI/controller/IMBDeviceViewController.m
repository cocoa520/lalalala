


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
#import "SystemHelper.h"
#import "IMBDevicePopoverViewController.h"

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
    
    _bigDevicesConnectedImageName = @"mod_device_no";
    _selectedBaseInfo = nil;
    
    IMBDrawOneImageBtn *button = [[IMBDrawOneImageBtn alloc]initWithFrame:NSMakeRect(12, 10, 12, 12)];
    [button mouseDownImage:[NSImage imageNamed:@"windowclose3"] withMouseUpImg:[NSImage imageNamed:@"windowclose"] withMouseExitedImg:[NSImage imageNamed:@"windowclose"] mouseEnterImg:[NSImage imageNamed:@"windowclose2"]];
    [button setEnabled:YES];
    [button setTarget:self];
    [button setAction:@selector(closeWindow:)];
    [button setBordered:NO];
    
    IMBDrawOneImageBtn *minButton = [[IMBDrawOneImageBtn alloc]initWithFrame:NSMakeRect(32, 10, 12, 12)];
    [minButton mouseDownImage:[NSImage imageNamed:@"windowmin3"] withMouseUpImg:[NSImage imageNamed:@"windowmin"] withMouseExitedImg:[NSImage imageNamed:@"windowmin"] mouseEnterImg:[NSImage imageNamed:@"windowmin2"]];
    [minButton setEnabled:YES];
    [minButton setTarget:self];
    [minButton setAction:@selector(minWindow:)];
    [minButton setBordered:NO];
    
    [_topView initWithLuCorner:YES LbCorner:NO RuCorner:YES RbConer:NO CornerRadius:5];
    [_topView setBackgroundColor:COLOR_DEVICE_Main_WINDOW_TOPVIEW_COLOR];
    [_topView addSubview:button];
    [_topView addSubview:minButton];
    [_topView setBackgroundColor:COLOR_MAIN_WINDOW_BG];
    
    if (_isNewController) {
        IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
        IMBBaseInfo *baseInfo = [deviceConnection.allDevices firstObject];
        [_selectedDeviceBtn setHidden:NO];
        [_selectedDeviceBtn configButtonName:baseInfo.deviceName WithTextColor:COLOR_TEXT_PRIORITY WithTextSize:SelectedBtnTextFont WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:baseInfo.connectType rightIcon:@"arrow"];
    }
    [_iCloudLoginAnimationView setHidden:YES];
}

#pragma mark - 初始化，view的点击事件，鼠标进出view的响应事件
/**
 *  初始化
 */
- (void)setupView {
    [_mainTitle setStringValue:CustomLocalizedString(@"MainWindow_id_7", nil)];
    _isEnable = YES;
    
    [_shoppingCartBtn setHoverImage:@"nav_icon_cart_hover" withSelfImage:[NSImage imageNamed:@"nav_icon_cart"]];
    [_helpBtn setHoverImage:@"nav_icon_help_hover" withSelfImage:[NSImage imageNamed:@"nav_icon_help"]];
    
    [_midiumiCloudClickLoginBtn setStringValue:CustomLocalizedString(@"NotConnectiCloudMouseEnter", nil)];
    [_midiumDropBoxClickLoginBtn setStringValue:CustomLocalizedString(@"NotConnectDropBoxMouseEnter", nil)];
    _midiumiCloudClickLoginBtn.font = [NSFont fontWithName:IMBCommonFont size:14.f];
    _midiumDropBoxClickLoginBtn.font = [NSFont fontWithName:IMBCommonFont size:14.f];
    _midiumiCloudClickLoginBtn.textColor = COLOR_TEXT_EXPLAIN;
    _midiumDropBoxClickLoginBtn.textColor = COLOR_TEXT_EXPLAIN;
    
    _midiumIcloudMsgLabel.stringValue = CustomLocalizedString(@"NotConnectiCloudTips", nil);
    _midiumDropboxMsgLabel.stringValue = CustomLocalizedString(@"NotConnectDropBoxTips", nil);
    _midiumIcloudMsgLabel.font = [NSFont fontWithName:IMBCommonFont size:14.f];
    _midiumDropboxMsgLabel.font = [NSFont fontWithName:IMBCommonFont size:14.f];
    _midiumIcloudMsgLabel.textColor = COLOR_TEXT_EXPLAIN;
    _midiumDropboxMsgLabel.textColor = COLOR_TEXT_EXPLAIN;
    
    _midiumIcloudTitleLabel.stringValue = CustomLocalizedString(@"NotConnectiCLoudTitle", nil);
    _midiumDropboxTitleLabel.stringValue = CustomLocalizedString(@"NotConnectDropBoxTitle", nil);
    _midiumIcloudTitleLabel.font = [NSFont fontWithName:IMBCommonFont size:14.f];
    _midiumDropboxTitleLabel.font = [NSFont fontWithName:IMBCommonFont size:14.f];
    _midiumIcloudTitleLabel.textColor = COLOR_TEXT_ORDINARY;
    _midiumDropboxTitleLabel.textColor = COLOR_TEXT_ORDINARY;
    
    
    
    [_iCloudUserTextField setPlaceholderString:CustomLocalizedString(@"CloudLogin_AppleID_Txt", nil)];
    [icloudLoginbtn setIsLeftRightGridient:YES withLeftNormalBgColor:COLOR_LOGIN_LEFTCOLOR withRightNormalBgColor:COLOR_LOGIN_RIGHTCOLOR withLeftEnterBgColor:COLOR_LOGIN_LEFTCOLOR withRightEnterBgColor:COLOR_LOGIN_RIGHTCOLOR withLeftDownBgColor:COLOR_LOGIN_LEFTCOLOR withRightDownBgColor:COLOR_LOGIN_RIGHTCOLOR withLeftForbiddenBgColor:COLOR_LOGIN_LEFT_FORBIDDENCOLOR withRightForbiddenBgColor:COLOR_LOGIN_RIGHT_FORBIDDENCOLOR];
    
    [icloudLoginbtn setBordered:NO];
    
    [icloudLoginbtn setButtonTitle:CustomLocalizedString(@"Cloud_Login" , nil) withNormalTitleColor:COLOR_View_NORMAL withEnterTitleColor:COLOR_View_NORMAL withDownTitleColor:COLOR_View_NORMAL withForbiddenTitleColor:COLOR_View_NORMAL withTitleSize:14 WithLightAnimation:NO];
    
    [_bigSizeIcloudGoNowBtn setIsLeftRightGridient:YES withLeftNormalBgColor:COLOR_LOGIN_LEFTCOLOR withRightNormalBgColor:COLOR_LOGIN_RIGHTCOLOR withLeftEnterBgColor:COLOR_LOGIN_LEFTCOLOR withRightEnterBgColor:COLOR_LOGIN_RIGHTCOLOR withLeftDownBgColor:COLOR_LOGIN_LEFTCOLOR withRightDownBgColor:COLOR_LOGIN_RIGHTCOLOR withLeftForbiddenBgColor:COLOR_LOGIN_LEFTCOLOR withRightForbiddenBgColor:COLOR_LOGIN_RIGHTCOLOR];
    
    [_bigSizeIcloudGoNowBtn setBordered:NO];
    
    [_bigSizeIcloudGoNowBtn setButtonTitle:CustomLocalizedString(@"DropBox_Login" , nil) withNormalTitleColor:COLOR_View_NORMAL withEnterTitleColor:COLOR_View_NORMAL withDownTitleColor:COLOR_View_NORMAL withForbiddenTitleColor:COLOR_View_NORMAL withTitleSize:14 WithLightAnimation:NO];

    [_devicesView setIsDevicesOriginalFrame:YES];
    
    [_iCloudUserTextField setTextColor:COLOR_TEXT_ORDINARY];
    [((customTextFieldCell *)_iCloudUserTextField.cell) setCursorColor:COLOR_TEXT_ORDINARY];
    
    NSMutableAttributedString *as6 = [[[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"CloudLogin_AppleID_Txt", nil)] autorelease];
    [as6 addAttribute:NSForegroundColorAttributeName value:COLOR_MAIN_WINDOW_TEXTFIELD_TEXT range:NSMakeRange(0, as6.string.length)];
    [as6 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as6.string.length)];
    [as6 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13] range:NSMakeRange(0, as6.string.length)];
    [_iCloudUserTextField.cell setPlaceholderAttributedString:as6];

    [(IMBSecureTextFieldCell *)_iCloudSecireTextField.cell setDelegate:self];
    [((IMBSecureTextFieldCell *)_iCloudSecireTextField.cell) setCursorColor:COLOR_TEXT_ORDINARY];
    
    [_icloudDrivebox setContentView:_midiumSizeiCloudView];
    [_dropboxBox setContentView:_midiumSizeOneDriveView];
    [_devicesBox setContentView:_midiumSizeDevicesView];
    
    
    _iCloudDriveView.isOriginalFrame = YES;
    _dropboxView.isOriginalFrame = YES;
    _devicesView.isOriginalFrame = YES;
    
#pragma mark - view的点击事件，鼠标进出view的响应事件
    /***  界面上的三个view的鼠标点击响应事件 ***/
    /***  _iCloudDriveView的鼠标点击响应事件 ***/
    _iCloudDriveView.mouseClicked = ^(void){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *cookie = [defaults objectForKey:@"iCloud"];
        if (_iCloudDriveView.loginStatus||cookie) {//如果icloud登陆成功，则直接进入详情界面
            if (_iCloudDriveView.loginStatus) {
                [self icloudViewClicked];
            }else {
                _isEnable = NO;
                [self addLoginLoadingAnimation];
                _baseDriveManage = [[IMBiCloudDriveManager alloc]initWithUserID:_iCloudUserTextField.stringValue WithPassID:_icloudLoginPwdTextfield.stringValue WithDelegate:self isRememberPassCode:_isCheckBoxSelected];
            }
        }else {
            [self setShadowHidden:YES];
            [_icloudDrivebox setContentView:_bigSizeiCloudView];
            
            NSRect cloudF = NSMakeRect(18.f, 92.f, 302.f, 304.f);
            NSRect oneDriveF = NSMakeRect(18.f, 20.f, 302.f, 56.f);
            NSRect devicesF = NSMakeRect(336.f, 20.f, 238.f, 376.f);
            
            NSArray *views = @[_iCloudDriveView,_dropboxView,_devicesView];
            NSArray *frames = @[[NSValue valueWithRect:cloudF],[NSValue valueWithRect:oneDriveF],[NSValue valueWithRect:devicesF]];
            [IMBViewAnimation animationWithViews:views frames:frames disable:YES completion:^{
                [self setOriginalFrame:NO];
                _devicesView.isDevicesOriginalFrame = YES;
                
                [_smallSizeTitle setStringValue:@"DropBox"];
                [_smallSizeTitle setTextColor:COLOR_TEXT_ORDINARY];
                [_dropboxBox setContentView:_smallSizeView];
                [self setDeviceViewConnectedStatus];
            }];
        }
        
    };
    /***  _oneDriveView的鼠标点击响应事件 ***/
    _dropboxView.mouseClicked = ^(void){
        if (_dropboxView.loginStatus) {//如果dropbox登陆成功，则直接进入详情界面
            [self dropboxViewClicked];
        }else {
            [self setShadowHidden:YES];
            [_dropboxBox setContentView:_bigSizeOneDriveView];
            
            NSRect cloudF = NSMakeRect(18.f, 340.f, 302.f, 56.f);
            NSRect oneDriveF = NSMakeRect(18.f, 20.f, 302.f, 304.f);
            NSRect devicesF = NSMakeRect(336.f, 20.f, 238.f, 376.f);
            
            NSArray *views = @[_iCloudDriveView,_dropboxView,_devicesView];
            NSArray *frames = @[[NSValue valueWithRect:cloudF],[NSValue valueWithRect:oneDriveF],[NSValue valueWithRect:devicesF]];
            [IMBViewAnimation animationWithViews:views frames:frames disable:YES completion:^{
                [self setOriginalFrame:NO];
                _devicesView.isDevicesOriginalFrame = YES;
                
                [_smallSizeTitle setStringValue:@"iCloud"];
                [_icloudDrivebox setContentView:_smallSizeView];
                [self setDeviceViewConnectedStatus];
            }];
        }
    };
    /***  _devicesView的鼠标点击响应事件 ***/
    _devicesView.mouseClicked = ^(void){
        [self setShadowHidden:YES];
        NSRect cloudF = NSMakeRect(18.f, 216.f, 122.f, 180.f);
        NSRect oneDriveF = NSMakeRect(18.f, 20.f, 122.f, 180.f);
        NSRect devicesF = NSMakeRect(156.0f, 20.0f, 418.f, 376.f);
        NSArray *views = @[_iCloudDriveView,_dropboxView,_devicesView];
        NSArray *frames = @[[NSValue valueWithRect:cloudF],[NSValue valueWithRect:oneDriveF],[NSValue valueWithRect:devicesF]];
        [IMBViewAnimation animationWithViews:views frames:frames disable:YES completion:^{
            [self setOriginalFrame:NO];
            _devicesView.isDevicesOriginalFrame = NO;
            
            [_icloudDrivebox setContentView:_smalliCloudDriveView];
            [_dropboxBox setContentView:_smallOneDriveView];
            if ([[IMBDeviceConnection singleton] isConnectedDevice]) {
                [_bigDevicesImageView setImage:[NSImage imageNamed:_bigDevicesConnectedImageName]];
            }else {
                [_bigDevicesImageView setImage:[NSImage imageNamed:@"mod_device_no"]];
            }
            [_devicesView setFrame:devicesF];
        }];
    };
    
    /***  鼠标进出view响应事件 ***/
    /***  鼠标进入view响应事件 ***/
    _iCloudDriveView.mouseEntered = ^(void){
        if (_iCloudDriveView.loginStatus) {
            [IMBViewAnimation animationOpacityWithView:_loginSuccessiCloudView.logoutBtn timeInterval:MidiumSizeAnimationTimeInterval isHidden:NO];
        }else {
            NSRect newFrame = NSMakeRect(17, 212 + 8, 302, 180);
            [IMBViewAnimation animationScaleWithView:_iCloudDriveView frame:newFrame timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
            
            NSRect newFrame2 = NSMakeRect(12, 212, 312, 188);
            [IMBViewAnimation animationScaleWithView:_icloudShadowView frame:newFrame2 timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
            [self setMouseEnteredMidiumContentViewWithView:_midiumiCloudContentView btn:_midiumiCloudClickLoginBtn withTextField:_midiumIcloudMsgLabel];
        }
        
    };
    _dropboxView.mouseEntered = ^(void){
        if (_dropboxView.loginStatus) {
            [IMBViewAnimation animationOpacityWithView:_loginSuccessdropboxView.logoutBtn timeInterval:MidiumSizeAnimationTimeInterval isHidden:NO];
        }else {
            NSRect newFrame = NSMakeRect(17, 18 + 8, 302, 180);
            [IMBViewAnimation animationScaleWithView:_dropboxView frame:newFrame timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
            
            NSRect newFrame2 = NSMakeRect(12, 18, 312.0f, 188);
            [IMBViewAnimation animationScaleWithView:_dropboxShadowView frame:newFrame2 timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
            [self setMouseEnteredMidiumContentViewWithView:_midiumDropBoxContentView btn:_midiumDropBoxClickLoginBtn withTextField:_midiumDropboxMsgLabel];
        }
       
    };
    _devicesView.mouseEntered = ^(void){
        NSRect newFrame = NSMakeRect(335, 19 + 8, 238, 376);
        [IMBViewAnimation animationScaleWithView:_devicesView frame:newFrame timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
        
        NSRect newFrame2 = NSMakeRect(330.f, 19, 248, 384);
        [IMBViewAnimation animationScaleWithView:_devicesShadowView frame:newFrame2 timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
    };
    
    /***  鼠标移除view响应事件 ***/
    _iCloudDriveView.mouseExited = ^(void){
        if (_iCloudDriveView.loginStatus) {
            [IMBViewAnimation animationOpacityWithView:_loginSuccessiCloudView.logoutBtn timeInterval:MidiumSizeAnimationTimeInterval isHidden:YES];
        }else {
            NSRect newFrame = NSMakeRect(17, 212, 302, 180);
            [IMBViewAnimation animationScaleWithView:_iCloudDriveView frame:newFrame timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
            
            NSRect newFrame2 = NSMakeRect(17.0f, 212.0f, 302.0f, 180);
            [IMBViewAnimation animationScaleWithView:_icloudShadowView frame:newFrame2 timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];

            [self setMouseExitedMidiumContentViewWithView:_midiumiCloudContentView btn:_midiumiCloudClickLoginBtn timeInterval:MidiumSizeAnimationTimeInterval];
            
            [IMBViewAnimation animationMouseEnteredExitedWithView:_midiumIcloudMsgLabel frame:NSMakeRect(41, 20 , 221, 25) timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
            
        }
        
    };
    _dropboxView.mouseExited = ^(void){
        if (_dropboxView.loginStatus) {
            [IMBViewAnimation animationOpacityWithView:_loginSuccessdropboxView.logoutBtn timeInterval:MidiumSizeAnimationTimeInterval + 0.15f isHidden:YES];
        }else {
            NSRect newFrame = NSMakeRect(17, 18, 302, 180);
            [IMBViewAnimation animationScaleWithView:_dropboxView frame:newFrame timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
            
            
            NSRect newFrame2 = NSMakeRect(17.0f, 18.0f, 302.0f, 180);
            [IMBViewAnimation animationScaleWithView:_dropboxShadowView frame:newFrame2 timeInterval:MidiumSizeAnimationTimeInterval + 0.15f disable:NO completion:nil];
            [self setMouseExitedMidiumContentViewWithView:_midiumDropBoxContentView btn:_midiumDropBoxClickLoginBtn timeInterval:MidiumSizeAnimationTimeInterval];
            
            [IMBViewAnimation animationMouseEnteredExitedWithView:_midiumDropboxMsgLabel frame:NSMakeRect(46, 23 , 210, 25) timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
        }
        
    };
    _devicesView.mouseExited = ^(void){
        NSRect newFrame = NSMakeRect(335, 19, 238, 376);
        [IMBViewAnimation animationScaleWithView:_devicesView frame:newFrame timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
        
        
        NSRect newFrame2 = NSMakeRect(335.0f, 19.0f, 238.0f, 376);
        [IMBViewAnimation animationScaleWithView:_devicesShadowView frame:newFrame2 timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
    };
    
}

- (void)chooseDeviceClick:(id)sender {
    if (_devPopover != nil) {
        if (_devPopover.isShown) {
            [_devPopover close];
        }
    }
    if ([sender isKindOfClass:[IMBBaseInfo class]]) {
        IMBBaseInfo *baseInfo = (IMBBaseInfo *)sender;
        IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
        IMBiPod *ipod = [deviceConnection getiPodByKey:baseInfo.uniqueKey];
        [_devicesView mouseExited:nil];
        [_delegate changeMainFrame:ipod withMedleEnum:DeviceLogEnum withiCloudDrvieBase:nil];
    }
}

#pragma mark - 鼠标响应事件
- (void)setOriginalFrame:(BOOL)isOriginalFrame {
    _iCloudDriveView.isOriginalFrame = isOriginalFrame;
    _dropboxView.isOriginalFrame = isOriginalFrame;
    _devicesView.isOriginalFrame = isOriginalFrame;
}

- (void)setShadowHidden:(BOOL)hidden {
    [_icloudShadowView setHidden:hidden];
    [_dropboxShadowView setHidden:hidden];
    [_devicesShadowView setHidden:hidden];
}

- (void)setMouseEnteredMidiumContentViewWithView:(NSView *)view btn:(NSView *)btn withTextField:(NSTextField *)textfiled{
    NSRect f = view.frame;
    f.origin.y = 6;
    [IMBViewAnimation animationMouseEnteredExitedWithView:view frame:f timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
    
    if ([textfiled isEqual:_midiumDropboxMsgLabel]) {
        [IMBViewAnimation animationMouseEnteredExitedWithView:textfiled frame:NSMakeRect(46, 23  + 2, 210, 25) timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
    }else if ([textfiled isEqual:_midiumIcloudMsgLabel]) {
        [IMBViewAnimation animationMouseEnteredExitedWithView:textfiled frame:NSMakeRect(41, 20 + 3, 221, 25) timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
    }

    
    [btn setHidden:NO];
    [btn setWantsLayer:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation1.beginTime = CACurrentMediaTime();
        animation1.fromValue=[NSNumber numberWithFloat:0.0];
        animation1.toValue=[NSNumber numberWithFloat:1.0];
        animation1.duration = MidiumSizeAnimationTimeInterval;
        animation1.removedOnCompletion = NO;
        animation1.fillMode = kCAFillModeForwards;
        [btn.layer addAnimation:animation1 forKey:@"1"];
    } completionHandler:^{
        [btn setHidden:NO];
    }];
}

- (void)setMouseExitedMidiumContentViewWithView:(NSView *)view btn:(NSView *)btn timeInterval:(CGFloat)timeInterval {
    NSRect f = view.frame;
    f.origin.y = 0;
    [IMBViewAnimation animationMouseEnteredExitedWithView:view frame:f timeInterval:timeInterval disable:NO completion:nil];
    
    
    [btn setWantsLayer:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation1.beginTime = CACurrentMediaTime();
        animation1.fromValue=[NSNumber numberWithFloat:1.0];
        animation1.toValue=[NSNumber numberWithFloat:0.0];
        animation1.duration = timeInterval;
        animation1.removedOnCompletion = NO;
        animation1.fillMode = kCAFillModeForwards;
        [btn.layer addAnimation:animation1 forKey:@"1"];
    } completionHandler:^{
        [btn setHidden:YES];
    }];
    
    
    
//    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
//        [context setDuration:timeInterval];
//        [context setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
//        [view.animator setFrame:frame];
//    } completionHandler:completion];
    

    
//    [view.layer addAnimation:animation1 forKey:@"opacityAnim1"];
    
//    NSRect btnF = btn.frame;
//    [IMBViewAnimation animationMouseMovedWithView:btn frame:btnF timeInterval:timeInterval disable:NO completion:^{
//        [btn setHidden:YES];
//    }];
}

- (void)setDeviceViewConnectedStatus {
    if ([[IMBDeviceConnection singleton] isConnectedDevice]) {
        [_bigDevicesImageView setImage:[NSImage imageNamed:_bigDevicesConnectedImageName]];
    }else {
        [_bigDevicesImageView setImage:[NSImage imageNamed:@"mod_device"]];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (_isEnable == NO) return;
    
    [self setShadowHidden:NO];
    
    
    _icloudShadowView.frame = NSMakeRect(17.0f, 213.0f, 302.0f, 180.0f);
    _dropboxShadowView.frame = NSMakeRect(17.0f, 18.0f, 302.0f, 180.0f);
    _devicesShadowView.frame = NSMakeRect(335.0f, 19.0f, 238.0f, 376.0f);
    
    
    NSRect cloudF = NSMakeRect(17.0f, 213.0f, 302.0f, 180.0f);
    NSRect oneDriveF = NSMakeRect(17.0f, 18.0f, 302.0f, 180.0f);
    NSRect devicesF = NSMakeRect(335.0f, 19.0f, 238.0f, 376.0f);
    
    
    NSArray *views = @[_iCloudDriveView,_dropboxView,_devicesView];
    NSArray *frames = @[[NSValue valueWithRect:cloudF],[NSValue valueWithRect:oneDriveF],[NSValue valueWithRect:devicesF]];
    [IMBViewAnimation animationWithViews:views frames:frames disable:YES completion:^{
        _iCloudDriveView.isOriginalFrame = YES;
        _dropboxView.isOriginalFrame = YES;
        _devicesView.isOriginalFrame = YES;
        
        if (_dropboxView.loginStatus) {
            [_dropboxBox setContentView:_loginSuccessdropboxView.view];
        }else {
            [_dropboxBox setContentView:_midiumSizeOneDriveView];
        }
        if (_iCloudDriveView.loginStatus) {
            [_icloudDrivebox setContentView:_loginSuccessiCloudView.view];
        }else {
            [_icloudDrivebox setContentView:_midiumSizeiCloudView];
        }
        
        [self setMouseExitedMidiumContentViewWithView:_midiumDropBoxContentView btn:_midiumDropBoxClickLoginBtn timeInterval:MidiumSizeAnimationTimeInterval];
        
        [self setDeviceViewConnectedStatus];
        
        if (_iCloudDriveView.loginStatus) {
            [IMBViewAnimation animationOpacityWithView:_loginSuccessiCloudView.logoutBtn timeInterval:0 isHidden:YES];
        }else {
            NSRect newFrame = NSMakeRect(17.0f, 213.0f, 302.0f, 180);
            [IMBViewAnimation animationScaleWithView:_icloudShadowView frame:newFrame timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
            
            [self setMouseExitedMidiumContentViewWithView:_midiumiCloudContentView btn:_midiumiCloudClickLoginBtn timeInterval:MidiumSizeAnimationTimeInterval];
        }
        if (_dropboxView.loginStatus) {
            [IMBViewAnimation animationOpacityWithView:_loginSuccessdropboxView.logoutBtn timeInterval:0 isHidden:YES];
        }else {
            NSRect newFrame = NSMakeRect(17.0f, 18.0f, 302.0f, 180);
            [IMBViewAnimation animationScaleWithView:_dropboxShadowView frame:newFrame timeInterval:MidiumSizeAnimationTimeInterval + 0.15f disable:NO completion:nil];
            [self setMouseExitedMidiumContentViewWithView:_midiumDropBoxContentView btn:_midiumDropBoxClickLoginBtn timeInterval:MidiumSizeAnimationTimeInterval];
        }
    }];
}

/**
 *  添加通知
 */
- (void)addNotis {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedDeviceDidChangeNoti:) name:IMBSelectedDeviceDidChangeNotiWithParams object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertTabKey:) name:INSERT_TAB object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changBtnState) name:NOTIFY_TEXTFILED_INPUT_CHANGE object:nil];
}
#pragma mark - 设备  连接 和 断开
- (void)deviceConnection {
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    
    deviceConnection.IMBDeviceConnected = ^{
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            [TempHelper customViewType:2 withCategoryEnum:0];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:CDevice action:ALogin label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        //设备连接成功
        [self deviceConnectedWithConnection:deviceConnection];
    };
    deviceConnection.IMBDeviceDisconnected = ^(NSString *serialNum){
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            [TempHelper customViewType:2 withCategoryEnum:0];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:CDevice action:ALogout label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        //设备断开连接
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
                    [self deviceDisconnected:serialNum];
                    if (_selectedBaseInfo) {
                        [_selectedBaseInfo release];
                        _selectedBaseInfo = nil;
                    }
                    _selectedBaseInfo = [baseInfo retain];
                    [_selectedDeviceBtn configButtonName:_selectedBaseInfo.deviceName WithTextColor:COLOR_TEXT_PRIORITY WithTextSize:SelectedBtnTextFont WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:baseInfo.connectType rightIcon:@"popup_icon_arrow"];
                    [_selectedDeviceBtn setFrame:NSMakeRect((_midiumSizeDevicesView.frame.size.width - _selectedDeviceBtn.frame.size.width)/2, _selectedDeviceBtn.frame.origin.y, _selectedDeviceBtn.frame.size.width, _selectedDeviceBtn.frame.size.height)];
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
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            [TempHelper customViewType:2 withCategoryEnum:0];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:CDevice action:ALogin label:LFailed labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
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
    static NSUInteger needPwdCount = 0;
    if (needPwdCount > 0) return;
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        needPwdCount = 1;
        [IMBCommonTool showTwoBtnsAlertInMainWindow:nil firstBtnTitle:@"Cancel" secondBtnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"TrustView_id_1", nil) firstBtnClickedBlock:^{
            needPwdCount = 0;
        } secondBtnClickedBlock:^{
            //点击确定，重新链接设备
            [[IMBDeviceConnection singleton] performSelector:@selector(reConnectDevice:) withObject:(id)device afterDelay:1.0f];
            needPwdCount = 0;
        }];
    });
    
}

/**
 *  设备连接完成  设置显示设备信息
 *
 *  @param iPod iPod
 */
- (void)setDeviceInfosWithiPod:(IMBBaseInfo *)baseInfo {
    IMBiPod *iPod = [[IMBDeviceConnection singleton] getiPodByKey:baseInfo.uniqueKey];
    [iPod startSync];
    dispatch_async(dispatch_get_main_queue(), ^{
      
        [_selectedDeviceBtn setHidden:NO];
        if (!_selectedBaseInfo) {
            _selectedBaseInfo = [baseInfo retain];
            
        }
        [_selectedDeviceBtn configButtonName:_selectedBaseInfo.deviceName WithTextColor:COLOR_TEXT_PRIORITY WithTextSize:SelectedBtnTextFont WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:baseInfo.connectType rightIcon:@"popup_icon_arrow"];
        [_selectedDeviceBtn setFrame:NSMakeRect((_midiumSizeDevicesView.frame.size.width - _selectedDeviceBtn.frame.size.width)/2, _selectedDeviceBtn.frame.origin.y, _selectedDeviceBtn.frame.size.width, _selectedDeviceBtn.frame.size.height)];
        NSString *familyString = iPod.deviceInfo.familyNewString;
        if ([familyString isEqualToString:@"iPhoneN"]) {
            _bigDevicesConnectedImageName = @"mod_device_detail_iphoneN";
            
        }else if ([familyString isEqualToString:@"iPhoneX"]) {
            _bigDevicesConnectedImageName = @"mod_device_detail_iphoneX";
        }else if ([familyString isEqualToString:@"iPad"]) {
            _bigDevicesConnectedImageName = @"mod_device_detail_ipad";
        }else {
            _bigDevicesConnectedImageName = @"";
        }
        [_bigDevicesImageView setImage:[NSImage imageNamed:_bigDevicesConnectedImageName]];
    });
    IMBInformationManager *inforManager = [IMBInformationManager shareInstance];
    IMBInformation *information = [[[IMBInformation alloc]initWithiPod:iPod] autorelease];
    dispatch_queue_t spatchqueue = dispatch_queue_create("load", NULL);
    dispatch_async(spatchqueue, ^{
        [information loadphotoData];
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSMutableArray *cameraRoll = [[NSMutableArray alloc] init];
            [cameraRoll addObjectsFromArray:[information camerarollArray] ? [information camerarollArray] : [NSArray array]];
//            [cameraRoll addObjectsFromArray:[information photovideoArray] ? [information photovideoArray] : [NSArray array]];
            [cameraRoll addObjectsFromArray:[information photoSelfiesArray] ? [information photoSelfiesArray] : [NSArray array]];
            [cameraRoll addObjectsFromArray:[information screenshotArray] ? [information screenshotArray] : [NSArray array]];
            [cameraRoll addObjectsFromArray:[information slowMoveArray] ? [information slowMoveArray] : [NSArray array]];
            [cameraRoll addObjectsFromArray:[information timelapseArray] ? [information timelapseArray] : [NSArray array]];
            [cameraRoll addObjectsFromArray:[information panoramasArray] ? [information panoramasArray] : [NSArray array]];
            information.allPhotoArray = [cameraRoll retain];
            [cameraRoll release];
            [information.ipod setPhotoLoadFinished:YES];
            [inforManager.informationDic setObject:information forKey:iPod.uniqueKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:DeviceDataLoadCompletePhoto object:iPod];
        });
    });

    dispatch_async(spatchqueue, ^{
        [information loadiBook];
        NSArray *ibooks = [information allBooksArray] ;
        [IMBCommonTool loadbookCover:ibooks ipod:iPod];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [iPod setBookLoadFinished:YES];
            [inforManager.informationDic setObject:information forKey:iPod.uniqueKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:deviceDataLoadCompleteBooks object:iPod];
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
            [iPod setMediaLoadFinished:YES];
            [iPod setVideoLoadFinished:YES];
            [inforManager.informationDic setObject:information forKey:iPod.uniqueKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:deviceDataLoadCompleteMedia object:iPod];
            [[NSNotificationCenter defaultCenter] postNotificationName:DeviceDataLoadCompleteVideo object:iPod];
        });
    });

    dispatch_async(spatchqueue, ^{
        IMBApplicationManager *appManager = [[information applicationManager] retain];
        [appManager loadAppArray];
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSMutableArray *appArray = (NSMutableArray *)[appManager appEntityArray];
            information.appArray = [appArray retain];
            [iPod setAppsLoadFinished:YES];
            [inforManager.informationDic setObject:information forKey:iPod.uniqueKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:DeviceDataLoadCompleteApp object:iPod];
        });
    });
    
    dispatch_async(spatchqueue, ^{
        IMBApplicationManager *appManager = [[information applicationManager] retain];
        [appManager loadAppDoucmentArray];
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSMutableArray *appArray = (NSMutableArray *)[appManager appDoucmentArray];
            information.appDoucmentArray = [appArray retain];
            [iPod setAppDoucmentFinished:YES];
            [inforManager.informationDic setObject:information forKey:iPod.uniqueKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:DeviceDataLoadCompleteAppDoucment object:iPod];
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
    _iCloudSecireTextField.stringValue = @"";
    _icloudLoginPwdTextfield.stringValue = @"";
    _iCloudUserTextField.enabled = YES;
    _iCloudUserTextField.editable = YES;
    _isEnter = NO;
    _iCloudDriveView.loginStatus = NO;
    [_iCloudLoginAnimationView setHidden:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"iCloud"];
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    IMBBaseInfo *itemBaseInfo = nil;
    for (IMBBaseInfo *baseInfo in connection.allDevices) {
        if (baseInfo.chooseModelEnum == iCloudLogEnum) {
            itemBaseInfo = baseInfo;
        }
    }
    [connection.allDevices removeObject:itemBaseInfo];
    IMBViewManager *viewManger = [IMBViewManager singleton];
    [viewManger.allMainControllerDic removeObjectForKey:@"iCloud"];
    [_baseDriveManage userDidLogout];
    [_icloudDrivebox setContentView:_midiumSizeiCloudView];
}

- (void)chooseDeviceBtn:(IMBBaseInfo *)baseInfo {
    if (baseInfo) {
        [_selectedDeviceBtn configButtonName:baseInfo.deviceName WithTextColor:COLOR_TEXT_PRIORITY WithTextSize:SelectedBtnTextFont WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:baseInfo.connectType rightIcon:@"popup_icon_arrow"];
        
    }else {
        [_selectedDeviceBtn setHidden:YES];
    }
}

- (void)signoutDropboxClicked {
    _dropboxView.loginStatus = NO;
    _isDropBoxdown = NO;
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    IMBBaseInfo *itemBaseInfo = nil;
    for (IMBBaseInfo *baseInfo in connection.allDevices) {
        if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
            itemBaseInfo = baseInfo;
        }
    }

    [connection.allDevices removeObject:itemBaseInfo];
    [_baseDriveManage userDidLogout];
    IMBViewManager *viewManger = [IMBViewManager singleton];
    [viewManger.allMainControllerDic removeObjectForKey:@"DropBox"];
    [_dropboxBox setContentView:_midiumSizeOneDriveView];
}
#pragma mark - 其他按钮点击
- (IBAction)selectedDeviceBtnClicked:(IMBSelecedDeviceBtn *)sender {
    IMBFFuncLog;
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    NSMutableArray *allDevices = [NSMutableArray array];
    if (deviceConnection.allDevices.count) {
        for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
            if (baseInfo.chooseModelEnum == DeviceLogEnum) {
                [allDevices addObject:baseInfo];
            }
        }
    }
    
    if (allDevices.count == 1) {
        _selectedBaseInfo = [allDevices objectAtIndex:0];
        [self selectedDeviceDidChange];
    }else if (allDevices.count >= 2) {
        if (_devPopover.isShown) {
            return;
        }
        
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
        
        _devicePopoverViewController = [[IMBDevicePopoverViewController alloc]  initWithNibName:@"IMBDevicePopoverViewController" bundle:nil withDeviceAry:allDevices];
        if (_devPopover != nil) {
            _devPopover.contentViewController = _devicePopoverViewController;
        }
        [_devicePopoverViewController setTarget:self];
        [_devicePopoverViewController setAction:@selector(chooseDeviceClick:)];
        [_devicePopoverViewController release];
        NSRectEdge prefEdge = NSMinYEdge;
        NSRect rect = NSMakeRect(_selectedDeviceBtn.bounds.origin.x, _selectedDeviceBtn.bounds.origin.y, _selectedDeviceBtn.bounds.size.width, _selectedDeviceBtn.bounds.size.height);
        [_devPopover showRelativeToRect:rect ofView:_selectedDeviceBtn preferredEdge:prefEdge];
    }
}

- (IBAction)oneDriveLogin:(id)sender {
    if (!_isDropBoxdown) {
        _isDropBoxdown = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ICLOUD_ENTER_SIGNIN object:nil userInfo:nil];
        [self signDown:sender];
    }
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
    NSString *str = CustomLocalizedString(@"FAQ_Url", nil);
    NSURL *url = [NSURL URLWithString:str];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:3 withCategoryEnum:0];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:CSupport action:AHelp label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}

#pragma mark - Dropbox Login
- (void)signDown:(id)sender {
    _baseDriveManage = [[IMBDropBoxManage alloc] initWithUserID:nil withDelegate:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ICLOUD_SIGNIN_FAIL object:nil userInfo:nil];
}

- (void)switchViewControllerDropBox:(Dropbox *) dropbox {
    [_iCloudLoginAnimationView setHidden:YES];
    [_iCloudUserTextField.cell setEnabled:YES];
    [_iCloudUserTextField setEditable:YES];
    _isEnter = NO;
    
    IMBDeviceConnection *deivceConnection = [IMBDeviceConnection singleton];
    IMBBaseInfo *baseInfo = [[IMBBaseInfo alloc] init];
    [baseInfo setDeviceName:dropbox.userID?:@"DropBox"];
    [baseInfo setUniqueKey:dropbox.userID?:@"DropBox"];
    [baseInfo setConnectType:general_iCloud];
    [baseInfo setIsicloudView:YES];
    [baseInfo setAllDeviceSize:dropbox.totalStorageInBytes];
    [baseInfo setKyDeviceSize:dropbox.usedStorageInBytes];
    [baseInfo setLeftImage:[NSImage imageNamed:@"popbox_icon_dropbox"]];
    [baseInfo setLeftHoverImage:[NSImage imageNamed:@"popbox_icon_dropbox_hover"]];
    [baseInfo setChooseModelEnum:DropBoxLogEnum];
    [baseInfo setDriveBaseManage:_baseDriveManage];
//    [baseInfo setDropBox:dropbox];
    baseInfo.dropBox = [dropbox  retain];
    [[deivceConnection allDevices] addObject:baseInfo];
    
    if (!_loginSuccessdropboxView) {
        _loginSuccessdropboxView = [[IMBMainWindowLoginSuccessView alloc] initWithNibName:@"IMBMainWindowLoginSuccessView" bundle:nil];
    }
    [_dropboxBox setContentView:_loginSuccessdropboxView.view];
    //退出按钮点击
    _loginSuccessdropboxView.quitBtnClicked = ^{
        [self signoutDropboxClicked];
    };
    
    [_loginSuccessdropboxView.nameLabel setStringValue:dropbox.userID?:@""];
    [_loginSuccessdropboxView.imageView setImage:[NSImage imageNamed:@"mod_dropboxdrive"]];
    [_loginSuccessdropboxView.sizeLabel setStringValue:[NSString stringWithFormat:@"%@/%@",[StringHelper getFileSizeString:dropbox.usedStorageInBytes reserved:2]?:@"",[StringHelper getFileSizeString:dropbox.totalStorageInBytes reserved:2]?:@""]];
    [_dropboxView setLoginStatus:YES];
    [self mouseDown:nil];
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    [deviceConnection.drviceAry addObject:baseInfo];
    [baseInfo release];
    baseInfo = nil;
    [_delegate changeMainFrame:nil withMedleEnum:DropBoxLogEnum withiCloudDrvieBase:_baseDriveManage];
    
}

#pragma mark - iCloud Diver Login
- (IBAction)iCloudLogIn:(id)sender {
    [_iCloudLoginAnimationView setHidden:NO];
    if ([IMBHelper stringIsNilOrEmpty:_iCloudUserTextField.stringValue] ||( [IMBHelper stringIsNilOrEmpty:_icloudLoginPwdTextfield.stringValue] && [IMBHelper stringIsNilOrEmpty:_iCloudSecireTextField.stringValue])) {
        [IMBCommonTool showSingleBtnAlertInMainWindow:nil btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"iCloud_id_4", nil) btnClickedBlock:nil];
        return;
    }
    _isEnable = NO;
    [self addLoginLoadingAnimation];
    if ([_icloudLoginPwdTextfield.stringValue isEqualToString:@""]) {
        _baseDriveManage = [[IMBiCloudDriveManager alloc]initWithUserID:_iCloudUserTextField.stringValue WithPassID:_iCloudSecireTextField.stringValue WithDelegate:self isRememberPassCode:_isCheckBoxSelected];
    }else {
        _baseDriveManage = [[IMBiCloudDriveManager alloc]initWithUserID:_iCloudUserTextField.stringValue WithPassID:_icloudLoginPwdTextfield.stringValue WithDelegate:self isRememberPassCode:_isCheckBoxSelected];
    }
}

- (void)switchiCloudDriveViewControllerWithiCloudDrive:(iCloudDrive *)icloudDrive {
    [self removeLoginLoadingAnimation];
    _isEnable = YES;
    IMBDeviceConnection *deivceConnection = [IMBDeviceConnection singleton];
    IMBBaseInfo *baseInfo = [[IMBBaseInfo alloc] init];
    [baseInfo setDeviceName:icloudDrive.userName];
    [baseInfo setUniqueKey:icloudDrive.userName];
    [baseInfo setConnectType:general_iCloud];
    [baseInfo setIsicloudView:YES];
    [baseInfo setKyDeviceSize:icloudDrive.usedStorageInBytes];
    [baseInfo setAllDeviceSize:icloudDrive.totalStorageInBytes];
    [baseInfo setChooseModelEnum:iCloudLogEnum];
    [baseInfo setLeftImage:[NSImage imageNamed:@"popbox_icon_icloud"]];
    [baseInfo setLeftHoverImage:[NSImage imageNamed:@"popbox_icon_icloud_hover"]];
    [baseInfo setDriveBaseManage:_baseDriveManage];
//    [baseInfo setICloudDrive:icloudDrive];
    baseInfo.iCloudDrive = [icloudDrive retain];
    [[deivceConnection allDevices] addObject:baseInfo];
//    _iCloudDrive
//_dropboxBox
    if (!_loginSuccessiCloudView) {
        _loginSuccessiCloudView = [[IMBMainWindowLoginSuccessView alloc] initWithNibName:@"IMBMainWindowLoginSuccessView" bundle:nil];
    }
    [_icloudDrivebox setContentView:_loginSuccessiCloudView.view];
    //退出按钮点击
    _loginSuccessiCloudView.quitBtnClicked = ^{
        
        [self signoutiCloudClicked];
    };
    [_loginSuccessiCloudView.imageView setImage:[NSImage imageNamed:@"mod_iclouddrive"]];
    [_loginSuccessiCloudView.nameLabel setStringValue:icloudDrive.userName];
    [_loginSuccessiCloudView.sizeLabel setStringValue:[NSString stringWithFormat:@"%@/%@",[StringHelper getFileSizeString:baseInfo.kyDeviceSize reserved:2],[StringHelper getFileSizeString:baseInfo.allDeviceSize reserved:2]]];
    
    [_iCloudDriveView setLoginStatus:YES];
    
    [self mouseDown:nil];
    
    [_delegate changeMainFrame:nil withMedleEnum:iCloudLogEnum withiCloudDrvieBase:_baseDriveManage];
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    [deviceConnection.drviceAry addObject:baseInfo];
    [baseInfo release];
    baseInfo = nil;
}

//登录错误
- (void)driveLogInFial:(ResponseCode)responseCode {
    [_iCloudLoginAnimationView setHidden:YES];
    _isEnable = YES;
    [_iCloudUserTextField.cell setEnabled:YES];
    [_iCloudUserTextField setEditable:YES];
    _isEnter = NO;
    NSString *errStr = CustomLocalizedString(@"iCloud_id_6", nil);
    switch (responseCode) {
        case ResponseUserNameOrPasswordError://密码或者账号错误
        {
            [self removeLoginLoadingAnimation];
            errStr = CustomLocalizedString(@"iCloud_id_4", nil);
        }
            break;
        case ResonseSecurityCodeError://<沿验证码错误
        {
            [self removeLoginLoadingAnimation];
            errStr = CustomLocalizedString(@"iCloud_id_2", nil);
        }
            break;
        case ResponseUnknown://未知错误
        {
            [self removeLoginLoadingAnimation];
            errStr = CustomLocalizedString(@"iCloud_id_4", nil);
        }
            break;
        case ResponseInvalid://<响应无效 一般参数错误
        {
            [self removeLoginLoadingAnimation];
            errStr = CustomLocalizedString(@"iCloud_id_1", nil);
        }
            break;
        case ResponseNotConnectedToInternet://网络错误
            [self removeLoginLoadingAnimation];
            errStr = CustomLocalizedString(@"iCloud_id_5", nil);
            break;
        case ResponseAccountLocked:
            [self removeLoginLoadingAnimation];
            errStr = CustomLocalizedString(@"iCloudLogin_View_Unlock_Account", nil);
            break;
        default:
            [self removeLoginLoadingAnimation];
            errStr = CustomLocalizedString(@"iCloud_id_6", nil);
            break;
    }
    [IMBCommonTool showSingleBtnAlertInMainWindow:nil btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:errStr btnClickedBlock:^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"iCloud"];
        [defaults synchronize];
        [_iCloudDriveView setLoginStatus:NO];
    }];
}

- (void)loadDataFial {
//    [IMBCommonTool showSingleBtnAlertInMainWindow:@"iCloud" btnTitle:CustomLocalizedString(@"Button_Ok", nil) msgText:CustomLocalizedString(@"iCloudLogin_Load_Error", nil) btnClickedBlock:^{
    _isDropBoxdown = NO;
    [self removeLoginLoadingAnimation];
//    }];
}

- (void)driveNeedSecurityCode:(iCloudDrive *)iCloudDrive {
    _isEnable = YES;
    [self removeLoginLoadingAnimation];
    [_iCloudDriveView setDisable:YES];
    [_dropboxView setDisable:YES];
    [_devicesView setDisable:YES];
    _icloudLoginPwdTextfield.editable = NO;
    _iCloudSecireTextField.enabled = NO;
    _iCloudSecireTextField.editable = NO;
    _iCloudUserTextField.editable = NO;
    _iCloudUserTextField.enabled = NO;
    [IMBCommonTool showDoubleVerificationViewIsDetailWindow:nil CancelClicked:nil okClicked:^(NSString *codeId){
        [(IMBiCloudDriveManager *)_baseDriveManage  setTwoCodeID:codeId];
        [self addLoginLoadingAnimation];
    }];
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
        [_iCloudUserTextField setPlaceholderString:CustomLocalizedString(@"CloudLogin_AppleID_Txt", nil)];
    }else {
        [_iCloudUserTextField setPlaceholderString:CustomLocalizedString(@"", nil)];
    }
}

//- (void)selectedDeviceDidChangeNoti:(NSNotification *)noti {
//    
//    if (_selectView) {
//        [_selectView hideWithTimeInterval:0.2];
//    }
//    IMBBaseInfo *baseInfo = [noti object];
//    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
//    _selectedBaseInfo = baseInfo;
//    [self selectedDeviceDidChange];
//}

// 选择设备按钮 切换界面
- (void)selectedDeviceDidChange {
    if (_devPopover.isShown) {
        [_devPopover close];
    }
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    IMBiPod *ipod = [deviceConnection getiPodByKey:_selectedBaseInfo.uniqueKey];
    [_devicesView mouseExited:nil];
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
    if (_devicePopoverViewController) {
        [_devicePopoverViewController release];
        _devicePopoverViewController = nil;
    }
    if (_loadLayer) {
        [_loadLayer release];
        _loadLayer = nil;
    }

    [[IMBDeviceConnection singleton] stopListening];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:INSERT_TAB object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_TEXTFILED_INPUT_CHANGE object:nil];
    [super dealloc];
    
}

#pragma mark - 加载动画的添加和移除
- (void)addLoginLoadingAnimation {
    [_iCloudDriveView setDisable:YES];
    [_dropboxView setDisable:YES];
    [_devicesView setDisable:YES];
    _icloudLoginPwdTextfield.editable = NO;
    _iCloudSecireTextField.enabled = NO;
    _iCloudSecireTextField.editable = NO;
    _iCloudUserTextField.editable = NO;
    _iCloudUserTextField.enabled = NO;
    

    CGFloat loadLayerWH = 14.f;
    
    _loadLayer = [[CALayer alloc] init];
    
     [_loadLayer setHidden:NO];
    _loadLayer.contents = [NSImage imageNamed:@"other_sending"];
    [_loadLayer setFrame:NSMakeRect(1,1, loadLayerWH, loadLayerWH)];
    [_iCloudLoginAnimationView setHidden:NO];
    [_iCloudLoginAnimationView setWantsLayer:YES];
    [_iCloudLoginAnimationView.layer addSublayer:_loadLayer];
    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    animation.fromValue = @(2*M_PI);
//    animation.toValue = 0;
//    animation.repeatCount = MAXFLOAT;
//    animation.duration = 1.0f;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    [_loadLayer addAnimation:animation forKey:@""];
    [IMBViewAnimation animationWithRotationWithLayer:_loadLayer];
    
    
    [icloudLoginbtn setEnabled:NO];
    [icloudLoginbtn setNeedsDisplay:YES];
    [_checkoutPwdBtn setHidden:YES];
}


- (void)removeLoginLoadingAnimation {
    [_iCloudDriveView setDisable:NO];
    [_dropboxView setDisable:NO];
    [_devicesView setDisable:NO];
    _icloudLoginPwdTextfield.editable = YES;
    _iCloudSecireTextField.editable = YES;
    _iCloudUserTextField.editable = YES;
    _iCloudSecireTextField.enabled = YES;
    _iCloudUserTextField.enabled = YES;
    
    if (_loadLayer) {
        [_loadLayer removeAllAnimations];
        [_loadLayer removeFromSuperlayer];
        [_loadLayer release];
        _loadLayer = nil;
    }
    [icloudLoginbtn setEnabled:YES];
    [_checkoutPwdBtn setHidden:NO];
    
//    NSParameterAssert(<#condition#>)
}

- (void)closeWindow:(id)sender {
    [_delegate closeWindow:sender];
}

- (void)minWindow:(id)sender {
    [_delegate minWindow:sender];
}


@end
