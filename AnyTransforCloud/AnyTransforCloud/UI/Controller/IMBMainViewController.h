//
//  IMBMainViewController.h
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/10.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBorderRectAndColorView.h"
#import "IMBAddCloudViewController.h"
#import "IMBMainNavigationView.h"
#import "IMBPopoverViewController.h"
#import "IMBMainPageViewController.h"
#import "IMBHeadImageButton.h"
#import "IMBMainPageMenuView.h"
#import "IMBCloudManager.h"
#import "IMBBaseViewController.h"
#import "IMBToolTipShadowsView.h"
#import "IMBBaseManager.h"
#import "IMBiCloudDriveManager.h"
#import "IMBAlertViewController.h"

#define ACCOUNT_MAIN_PAGE @"Account_Main_Page"
#define ACCOUNT_DETAIL_PAGE @"Account_Detail_Page"
#define ACCOUNT_ADDCLOUD_PAGE @"Account_AddCloud_Page"
#define ACCOUNT_SHARE_PAGE @"Account_Share_Page"
#define ACCOUNT_STAR_PAGE @"Account_Star_Page"
#define ACCOUNT_HISTORY_PAGE @"Account_History_Page"
#define ACCOUNT_TRASH_PAGE @"Account_Trash_Page"
#define ACCOUNT_SEARCH_PAGE @"Account_Search_Page"

@interface IMBMainViewController : NSViewController<CloudNavigationDelegate,NSPopoverDelegate> {
    IMBPopoverViewController *_popoverViewController;
    NSMutableDictionary *_cloudViewDic; /// 保存所有关联的cloud的页面
    NSPopover *_devPopover;
    
    IBOutlet IMBHeadImageButton *_headButton;
    IBOutlet IMBBorderRectAndColorView *_rightView;
    IBOutlet NSBox *_contentBox;
    IBOutlet IMBMainNavigationView *_navigationView;
    IBOutlet IMBSVGButton *_lockBtn;
    
    IMBMainPageMenuView *_mainPageMenuView;
    IMBToolTipShadowsView *_toolTopShadowsView;
    BOOL _isNewAddBtn;
    id _delegate;
    BOOL _isOpenMenu;
    NSNotificationCenter *_nc;
    
    IMBAlertViewController *_alertViewController;
}
@property (nonatomic, retain)IMBMainNavigationView *navigationView;

- (id)initWithDelegate:(id)delegate;

/**
 *  选折pop按钮 里面把选中的cloud放在工具栏的第一位
 *
 *  @param cloudEntity
 */
- (void)choosePopCloudBtnDown:(IMBCloudEntity *)cloudEntity;

/**
 *  增加云盘按钮
 *
 *  @param drive 云盘信息
 *  @param isAnimate    是否执行动画
 */
- (void)addCloudBtn:(BaseDrive *)drive animate:(BOOL)isAnimate;
/**
 *  点击到添加云的界面
 *
 *  @param sender
 */
- (void)gotoAddCloudView:(id)sender;
/**
 *  跳转到历史文件界面
 */
- (void)gotoHistoryFileView;
/**
 *  切换到对应云盘详细页面
 *
 *  @param driveID 云盘唯一标记
 */
- (void)gotoBindCloudView:(NSString *)driveID;
/**
 *  按钮的tooltip
 *  @param sender 当前按钮
 *  @param toolTip 显示文字
 */
- (void)showToolTip:(NSButton *)sender withToolTip:(NSString *)toolTip;
/**
 *  按钮的tooltip退出方法
 */
- (void)toolTipViewClose;

/**
 *  iCloudDrive登录成功
 *
 *  @param iCloudManager iCloudDrive 对象
 *  @param dataAry       加载的数据
 */
- (void)loadiCloudDriveView:(IMBiCloudDriveManager *) iCloudManager WithDataAry:(NSMutableArray *)dataAry;
@end
