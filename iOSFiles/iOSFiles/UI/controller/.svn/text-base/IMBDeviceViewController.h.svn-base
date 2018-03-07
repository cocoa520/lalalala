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

}
- (void)drive:(iCloudDrive *)iCloudDrive logInFailWithResponseCode:(ResponseCode)responseCode;
- (void)mainWindowClose;
- (void)switchViewController;
- (void)switchiCloudDriveViewController;
@end
