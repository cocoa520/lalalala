//
//  IMBMainPageViewController.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/17.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBWhiteView.h"
#import "IMBGridientButton.h"
#import "IMBHomePageViewController.h"
#import "IMBImageAndColorButton.h"
@class IMBSearchView;
@class IMBAddMenuView;
@class IMBSearchParamterChooseView;
@class IMBBorderRectAndColorView;
@class IMBTransferViewController;
@class IMBTransferTipShadowsView;
@class IMBCurrencySvgButton;
@class IMBDrawImageBtn;
@class IMBSearchCloudViewController;

@interface IMBMainPageViewController : NSViewController {
    /// 带有搜索功能的主界面
    IBOutlet IMBBorderRectAndColorView *_topView;
    IBOutlet IMBGridientButton *_addButton;
    IBOutlet IMBImageAndColorButton *_syncButton;
    IBOutlet IMBImageAndColorButton *_transferButton;
    IBOutlet NSBox *_detailBox;
    IBOutlet NSView *_detailView;
    IBOutlet IMBSearchView *_searchView;
    IBOutlet IMBDrawImageBtn *_searchBtn;
    IBOutlet IMBCurrencySvgButton *_clearSearchBtn;
    IBOutlet NSView *_bomContentView;
//    IMBHomePageViewController *_homePageViewController;
    
    IBOutlet IMBTransferTipShadowsView *_transferTipView;
    NSTimer *_timer;
    IMBAddMenuView *_addMenu;
    id _delegate;
    BOOL _isOpenMenu;
    NSNotificationCenter *_nc;
    NSMutableDictionary *_driveViewDic; ///缓存各种界面
    IMBCloudEntity *_curCloudEntity;
    
    IBOutlet IMBSearchParamterChooseView *_chooseSearchParaterView;
    int _pullDownIndex;//打开搜索下拉框的下标，名称：1，类型：2 时间：3
    IBOutlet NSBox *_contentBox;
    IMBBaseViewController *_baseViewController;
    IMBSearchCloudViewController *_searchViewController;
    FileTypeEnum _currentFileType;
    DateTypeEnum _currentDateType;
    
}

- (id)initWithDelegate:(id)delegate CloudEntity:(IMBCloudEntity *)curCloudEntity;

/**
 *  切换云盘详细页面方法
 *
 *  @param cloudEnity 云盘实体
 */
- (void)cloudDriveDetailSwitch:(IMBCloudEntity *)cloudEnity;
/**
 *  searchView展示下拉选项
 */
- (void)pullDownSearchView;
/**
 *  展开选择搜索的参数
 *
 *  @param sender 点击的按钮
 */
- (void)pullDownSearchParameter:(id)sender;
/**
 *  展示传输页面
 */
- (void)showTransferView;
/**
 *  显示传输TipView
 *
 *  @param count    传输的个数
 *  @param isDownLoad YES：是下载， NO：上传
 */
- (void)showTransferTipViewWithCount:(int)count isDownLoad:(BOOL)isDownLoad;

/**
 *  清除搜索内容
 *
 *  @param sender
 */
- (void)clearSearch:(id)sender;

/**
 *  开始搜索
 *
 *  @param sender
 */
- (void)startSearch:(id)sender;

@end
