//
//  IMBDeviceViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBSelecedDeviceBtn.h"
#import "IMBSecireTextField.h"
#import "IMBDrawTextFiledView.h"
#import "IMBSecureTextFieldCell.h"
#import "customTextFiled.h"
#import "BaseDrive.h"
#import "IMBDriveManage.h"
#import "iCloudDrive.h"
#import "IMBiCloudDriveManager.h"
#import "IMBDriveBaseManage.h"
#import "IMBGradientComponentView.h"
#import "IMBiPod.h"
#import "IMBShadowView.h"
#import "IMBCheckBtn.h"
#import "IMBMyDrawCommonly.h"
#import "IMBBookEntity.h"
#import "IMBBackgroundBorderView.h"
#import "IMBLackCornerView.h"
#import "IMBMainWindowLoginSuccessView.h"
#import "IMBMainLoginButton.h"
#import "IMBAlertSupeView.h"


@interface IMBDeviceViewController : NSViewController<NSPopoverDelegate,BaseDriveDelegate>
{
    IBOutlet IMBLackCornerView *_topView;
    IBOutlet IMBSelecedDeviceBtn *_selectedDeviceBtn;
    NSPopover *_devPopover;
  
    iCloudDrive *_iCloudDrive;
    
    IBOutlet IMBDrawTextFiledView *_iCloudTextFiledView;
    IBOutlet customTextFiled *_iCloudUserTextField;
    IBOutlet IMBSecireTextField *_iCloudSecireTextField;
    
    IMBDriveBaseManage *_baseDriveManage;

    IBOutlet IMBGradientComponentView *_iCloudDriveView;
    IBOutlet IMBGradientComponentView *_oneDriveView;
    IBOutlet IMBGradientComponentView *_devicesView;
    IMBiPod *_iPod;
    
    IBOutlet NSView *_midiumSizeiCloudView;
    IBOutlet NSView *_bigSizeiCloudView;
    
    
    IBOutlet NSView *_bigSizeOneDriveView;
    IBOutlet NSView *_midiumSizeOneDriveView;
    
    
    IBOutlet NSBox *_devicesBox;
    IBOutlet NSBox *_oneDriveBox;
    IBOutlet NSBox *_icloudDrivebox;
    
    IBOutlet NSView *_smallSizeView;
    IBOutlet NSTextField *_smallSizeTitle;
    
    
    IBOutlet NSView *_smallOneDriveView;
    IBOutlet NSView *_smalliCloudDriveView;
    
    
    IBOutlet NSView *_midiumSizeDevicesView;
    IBOutlet NSTextField *_midiumiCloudClickLoginBtn;
    IBOutlet NSTextField *_midiumDropBoxClickLoginBtn;
    IBOutlet NSView *_midiumDropBoxContentView;
    IBOutlet NSView *_midiumiCloudContentView;
    
    
    IBOutlet NSImageView *_bigDevicesImageView;
    
    
    IBOutlet IMBShadowView *_icloudShadowView;
    IBOutlet IMBShadowView *_dropboxShadowView;
    IBOutlet IMBShadowView *_devicesShadowView;
    
    
    IBOutlet NSButton *_checkoutPwdBtn;
    
    IBOutlet NSView *_icloudLogInSuccessView;
    
    
    IBOutlet IMBDrawTextFiledView *_icloudLoginPwdView;
    
    IBOutlet customTextFiled *_icloudLoginPwdTextfield;
    
    IBOutlet IMBCheckBtn *_checkBoxbtn;
    
    
    
    BOOL _isSecureMode;
    BOOL _isCheckBoxSelected;
    
    
    IBOutlet NSView *_icloudCustomView;
    
    
    IBOutlet IMBMyDrawCommonly *icloudLoginbtn;
    
    
    CALayer *_loadLayer;
    BOOL _isEnter;
    id _delegate;
    IBOutlet NSBox *_rootBox;
    IBOutlet IMBBackgroundBorderView *_mainView;
    BOOL _isNewController;
    
    
    IMBMainWindowLoginSuccessView *_loginSuccessiCloudView;
    IMBMainWindowLoginSuccessView *_loginSuccessdropboxView;
    
    
    IBOutlet IMBMainLoginButton *_bigSizeIcloudGoNowBtn;
    
    IBOutlet IMBAlertSupeView *_alertSuperView;
    
    
    IBOutlet IMBHoverChangeImageBtn *_shoppingCartBtn;
    IBOutlet IMBHoverChangeImageBtn *_helpBtn;
    
    
    IBOutlet NSTextField *_midiumIcloudMsgLabel;
    IBOutlet NSTextField *_midiumDropboxMsgLabel;
    IBOutlet NSTextField *_midiumDropboxTitleLabel;
    IBOutlet NSTextField *_midiumIcloudTitleLabel;
    
    BOOL _isEnable;
}
@property (nonatomic,assign) BOOL isNewController;
@property (nonatomic,assign) id delegate;
//- (void)drive:(iCloudDrive *)iCloudDrive logInFailWithResponseCode:(ResponseCode)responseCode;
- (void)switchViewController;
- (id)initWithDelegate:(id)delegate;
//登录成功 切换页面
- (void)switchiCloudDriveViewControllerWithiCloudDrive:(iCloudDrive *)icloudDrive;
//登录错误
- (void)driveLogInFial:(ResponseCode)responseCode;
@end
