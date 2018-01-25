//
//  IMBMainWindowController.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBNoTitleBarContentView.h"
#import "IMBLackCornerView.h"
#import "IMBSelecedDeviceBtn.h"

@interface IMBMainWindowController : NSWindowController
{
    IBOutlet IMBNoTitleBarContentView *_mainContontView;
    IBOutlet IMBLackCornerView *_topView;
    IBOutlet NSBox *_rootBox;
    IBOutlet IMBSelecedDeviceBtn *_selectedDeviceBtn;
    
    NSPopover *_devPopover;
//    IMBPopoverViewController *devPopoverViewController;
}

- (void)configButtonName:(NSString *)buttonName WithTextColor:(NSColor *)textColor WithTextSize:(float)size WithIsShowIcon:(BOOL)showIcon WithIsShowTrangle:(BOOL)showTrangle  WithIsDisable:(BOOL)isDisable withConnectType:(IPodFamilyEnum)connectType;

@end
