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

@interface IMBDeviceViewController : NSViewController<NSPopoverDelegate,BaseDriveDelegate>
{
    IBOutlet IMBSelecedDeviceBtn *_selectedDeviceBtn;
    NSPopover *_devPopover;
    NSMutableDictionary *_windowControllerDic;
    NSMutableDictionary *_driveControllerDic;
    IBOutlet IMBSecireTextField *_passTextField;
    IBOutlet customTextFiled *_loginTextField;
    IBOutlet IMBDrawTextFiledView *drawTextView;
  
    iCloudDrive *_iCloudDrive;
    
    IBOutlet IMBDrawTextFiledView *_iCloudTextFiledView;
    IBOutlet customTextFiled *_iCloudUserTextField;
    IBOutlet IMBSecireTextField *_iCloudSecireTextField;

    IBOutlet customTextFiled *_twoCode;
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
    IBOutlet NSButton *_midiumiCloudClickLoginBtn;
    IBOutlet NSButton *_midiumDropBoxClickLoginBtn;
    IBOutlet NSView *_midiumDropBoxContentView;
    IBOutlet NSView *_midiumiCloudContentView;
    
}
- (void)drive:(iCloudDrive *)iCloudDrive logInFailWithResponseCode:(ResponseCode)responseCode;
- (void)mainWindowClose;
- (void)switchViewController;
- (void)switchiCloudDriveViewController;
@end
