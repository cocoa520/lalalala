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
//#import "IMBDeviceViewController.h"
#import "IMBDriveBaseManage.h"
#import "IMBiPod.h"
#import "IMBCommonEnum.h"
#import "IMBWhiteView.h"
#import "IMBDeviceConnection.h"
#import "IMBAlertSupeView.h"


@interface IMBMainWindowController : NSWindowController {
    IBOutlet NSBox *_rootBox;
//    IMBDeviceViewController *_deviceViewController;
    IBOutlet IMBWhiteView *_whiteView;
    IMBiPod *_newiPod;
    BOOL _isNewWindow;
    ChooseLoginModelEnum _loginModelEnum;
    IBOutlet IMBAlertSupeView *_alertSuperView;
}
/**
*  设备选择按钮点击
*
*  @param sender 按钮
*/
- (id)initWithNewWindowiPod:(IMBiPod *)ipod WithNewWindow:(BOOL)isNewWindow withLogMedleEnum:(ChooseLoginModelEnum)logMedleEnum;
/**
 *  新建 window
 */
- (id)initWithNewWindow;
/**
 *  放大主界面 加新的界面
 *
 */
- (void)changeMainFrame:(IMBiPod *)iPod withMedleEnum:(ChooseLoginModelEnum )logMedleEnum withiCloudDrvieBase:(IMBDriveBaseManage*)baseManage;
/**
 * 缩小界面  返回按钮
 *
 */
- (void)backMainViewChooseLoginModelEnum;
/**
 * 内页切换 Controller
 * @param ipod  选择的设备
 * @param key controller 对于的存储字典里面的key
 * @param cloudStr 当前window的可以
 */
- (void)switchMainPageViewControllerWithiPod:(IMBiPod *)ipod withKey:(NSString *)key withCloud:(NSString *)cloudStr;
- (void)closeWindow:(id)sender;
@end
