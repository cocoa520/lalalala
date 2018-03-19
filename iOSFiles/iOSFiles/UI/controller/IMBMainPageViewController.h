//
//  IMBMainPageViewController.h
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/18.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "IMBDriveBaseManage.h"
#import "IMBLackCornerView.h"
#import "IMBWhiteView.h"
#import "HoverButton.h"
#import "IMBSelecedDeviceBtn.h"
#import "IMBPopoverViewController.h"
@interface IMBMainPageViewController : IMBBaseViewController
{
    IBOutlet IMBLackCornerView *_topView;

    IBOutlet NSBox *_rootBox;
    ChooseLoginModelEnum _chooseModelEnum;
    IMBDriveBaseManage *_driveBaseManage;
    IMBBaseViewController *_baseViewController;
    IBOutlet IMBSelecedDeviceBtn *_selectedDeviceBtn;
    IMBPopoverViewController *_popoverViewController;
//    IBOutlet IMBToolButtonView *_toolBarButtonView;
}

- (id)initWithiPod:(IMBiPod *)iPod withMedleEnum:(ChooseLoginModelEnum )logMedleEnum withiCloudDrvieBase:(IMBDriveBaseManage*)baseManage withDelegate:(id)delegate;
@end
