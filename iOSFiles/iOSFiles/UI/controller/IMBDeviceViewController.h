//
//  IMBDeviceViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBSelecedDeviceBtn.h"

@interface IMBDeviceViewController : NSViewController<NSPopoverDelegate>
{
    IBOutlet IMBSelecedDeviceBtn *_selectedDeviceBtn;
    NSPopover *_devPopover;
//    IBOutlet NSBox *_deviceBox;
}

@end
