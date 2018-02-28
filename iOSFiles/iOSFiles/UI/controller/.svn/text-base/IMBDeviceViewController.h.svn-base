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

@interface IMBDeviceViewController : NSViewController<NSPopoverDelegate,BaseDriveDelegate>
{
    IBOutlet IMBSelecedDeviceBtn *_selectedDeviceBtn;
    NSPopover *_devPopover;
    NSMutableDictionary *_windowControllerDic;
    NSMutableDictionary *_driveControllerDic;
    IBOutlet IMBSecireTextField *_passTextField;
    IBOutlet customTextFiled *_loginTextField;
    IBOutlet IMBDrawTextFiledView *drawTextView;
    IMBDriveManage *_driveManage;
}
- (void)mainWindowClose;
- (void)switchViewController;
@end
