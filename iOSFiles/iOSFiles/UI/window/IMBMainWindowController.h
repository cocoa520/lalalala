//
//  IMBMainWindowController.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "IMBNoTitleBarContentView.h"
#import "IMBLackCornerView.h"
#import "IMBDeviceViewController.h"
#import "IMBiPod.h"
#import "IMBCommonEnum.h"
#import "IMBWhiteView.h"
#import "IMBDeviceConnection.h"

@interface IMBMainWindowController : NSWindowController {
    IBOutlet NSBox *_rootBox;
    IMBDeviceViewController *_deviceViewController;
    IBOutlet IMBWhiteView *_whiteView;
    IMBiPod *_newiPod;
}
- (id)initWithNewWindowiPod:(IMBiPod *)ipod;
- (void)changeMainFrame:(IMBiPod *)iPod withMedleEnum:(ChooseLoginModelEnum )logMedleEnum withiCloudDrvieBase:(IMBDriveBaseManage*)baseManage;
- (void)backMainViewChooseLoginModelEnum:(ChooseLoginModelEnum) choosemodelEnum withiPod:(IMBiPod *)ipod;
- (void)closeWindow:(id)sender;
@end
