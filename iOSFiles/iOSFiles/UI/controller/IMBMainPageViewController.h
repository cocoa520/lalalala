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
#import "IMBCustomImageTextBtn.h"
#import "IMBPopoverViewController.h"
#import "IMBAlertSupeView.h"
#import "IMBLineView.h"
#import "IMBHoverChangeImageBtn.h"
#import "IMBMainPageWindowBackBtn.h"
#import "IMBCoverView.h"


@class IMBSearchView,IMBPurchaseOrAnnoyController;


@interface IMBMainPageViewController : IMBBaseViewController
{
    IBOutlet IMBLackCornerView *_topView;

    IBOutlet NSBox *_rootBox;
    ChooseLoginModelEnum _chooseModelEnum;
    IMBDriveBaseManage *_driveBaseManage;
    IMBBaseViewController *_baseViewController;
    IBOutlet IMBCustomImageTextBtn *_selectedDeviceBtn;
    IMBPopoverViewController *_popoverViewController;
//    IBOutlet IMBToolButtonView *_toolBarButtonView;
    IBOutlet IMBAlertSupeView *_alertSuperView;
    
    
    IBOutlet IMBLineView *_lineView1;
    IBOutlet IMBLineView *_lineView2;
    
    IBOutlet IMBHoverChangeImageBtn *_shoppingCartBtn;

    IBOutlet IMBSearchView *_searchView;
    BOOL _isLoadSearchView;//正在打开或者合拢SearchView
    BOOL _isShowTranfer;
    BOOL _isShowCompleteView;
    
    IBOutlet IMBMainPageWindowBackBtn *_backHomeBtn;
    
    IMBPurchaseOrAnnoyController *_purchaseVc;
    IBOutlet IMBCoverView *_topcoverView;
    IMBPurchaseOrAnnoyController *_annoyVc;
    
}
@property (nonatomic, assign) ChooseLoginModelEnum chooseModelEnum;
@property (nonatomic, assign) BOOL isShowTranfer;
- (void)setIsShowCompletView;
- (id)initWithiPod:(IMBiPod *)iPod withMedleEnum:(ChooseLoginModelEnum )logMedleEnum withiCloudDrvieBase:(IMBDriveBaseManage*)baseManage withDelegate:(id)delegate;
- (void)backdrive:(IMBBaseInfo *)baseInfo;
- (void)closeCompteleTranferView ;
- (void)setIsShowCompletView:(BOOL)isShowCompleteView ;
@end
