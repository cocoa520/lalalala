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
#import "IMBDeviceViewController.h"
@class IMBWhiteView;

@interface IMBMainWindowController : NSWindowController
{
    IBOutlet IMBNoTitleBarContentView *_mainContontView;
    IBOutlet IMBLackCornerView *_topView;
    IBOutlet NSBox *_rootBox;
    IMBDeviceViewController *_deviceViewController;
    
    IBOutlet IMBWhiteView *_whiteView;
}

@end
