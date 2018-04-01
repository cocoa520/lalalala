//
//  IMBBaseViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCustomHeaderTableView.h"
#import "IMBWhiteView.h"
#import "IMBCommonEnum.h"
#import "IMBiPod.h"
#import "IMBInformation.h"
#import "IMBInformationManager.h"
#import "MediaHelper.h"
#import "IMBDeviceInfo.h"
#import "StringHelper.h"
#import "NSString+Category.h"
#import "IMBDownloadListViewController.h"
#import "IMBExportSetting.h"
#import "IMBSoftWareInfo.h"
#import "CommonEnum.h"
#import "IMBCommonEnum.h"
#import "IMBCustomHeaderCell.h"
#import "IMBBackgroundBorderView.h"
#import "CommonDefine.h"
#import "CNGridViewItemLayout.h"
#import "IMBCommonDefine.h"
#import "IMBToolButtonView.h"
#import "LoadingView.h"
#import "IMBAlertViewController.h"
#import "IMBSortPopoverViewController.h"
#import "DateHelper.h"

@class IMBSearchView;
@class IMBBaseViewController;
typedef NS_ENUM(int, AnimationStyle) {
     EaseInEaseOutStyle,
};

#define progresstimer 60*5
@protocol InnerViewSwitchDelegate <NSObject>
@required
///<将视图推入到当前页面 
- (void)pushViewController:(IMBBaseViewController *)viewController AnimationStyle:(AnimationStyle)animationStyle;
//将视图推出当前页面
- (void)popViewController:(IMBBaseViewController *)viewController AnimationStyle:(AnimationStyle)animationStyle;
//将视图推入到根页面
- (void)popRootViewController:(AnimationStyle)animationStyle;
@end

@interface IMBBaseViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate,IMBImageRefreshListListener,NSTextViewDelegate,NSPopoverDelegate>
{
    
    IBOutlet IMBToolButtonView *_toolBarButtonView;
    NSArray *_toolBarArr;
    IMBiPod *_iPod;
    id _delegate;
    CategoryNodesEnum _category;
    id<InnerViewSwitchDelegate> _navigationController;
    NSMutableArray *_dataSourceArray; ///<表格数据源,通常指左边表格的数据源 此数据源是所有的数据
    NSMutableArray *_researchdataSourceArray;///<此数据源是指搜索之后的数据源
    
    NSMutableArray *_playlistArray;
    
    IBOutlet NSCollectionView *_noDataCollectionView;
    
    BOOL _itemTableViewcanDrag; //是否支持拖;
    BOOL _itemTableViewcanDrop; //是否支持放
    IMBInformation *_information;
    
    BOOL _isAscending;

    IMBExportSetting *_exportSetting;
    BOOL _isbackup;
  
    BOOL _isloadingPopBtn;
    BOOL _isSearch;
    
    BOOL _isDeletePlaylist;
    NSMutableArray *_delArray;
    NSPopover *_toDevicePopover;
    
    @public
    BOOL _endRunloop;
    BOOL _isClone;
    BOOL _isMerge;
    BOOL _isContentToMac;
    BOOL _isAddContent;
    SimpleNode *_simpleNode;
    
    @public
    
    IBOutlet  IMBCustomHeaderTableView *_itemTableView;//通用列表对象
    NSOpenPanel *_openPanel;
    BOOL _openPanelIsExite;
    BOOL _isOpen;
    

    NSPopover *_devPopover;
    NSTimer *_annoyTimer;
     BOOL _isPause;
      NSCondition *_condition;
    BOOL _isStop;
    

    NSMutableArray *_baseAry;
    AryEnum showEnum;
    NSString *_sortName;
    
    CNGridViewItemLayout *_defaultLayout;
    CNGridViewItemLayout *_hoverLayout;
    CNGridViewItemLayout *_selectionLayout;
    int _currentSelectView;
    
    @public
    NSWindow *_mainWindow;
    IMBBackgroundBorderView *_mainTopLineView;

    IMBAlertViewController *_alertViewController;
    
    IMBSearchView *_searhView;
    IMBSortPopoverViewController *_sortPopoverViewController;
}
@property (nonatomic,retain) IMBiPod *iPod;
@property (nonatomic,assign) BOOL isStop;
@property (nonatomic,assign) BOOL isSearch;
@property (nonatomic,retain) NSCondition *condition;
@property (nonatomic,assign)id<InnerViewSwitchDelegate> navigationController;///<弱引用
@property(nonatomic,retain) NSMutableArray *dataSourceArray;
@property(nonatomic,retain) NSMutableArray *researchdataSourceArray;
@property (nonatomic,assign) CategoryNodesEnum category;

@property (nonatomic,assign) BOOL itemTableViewcanDrag;
@property (nonatomic,assign) BOOL itemTableViewcanDrop;
@property (nonatomic,assign) BOOL isPause;
@property (nonatomic, retain) IMBBackgroundBorderView *mainTopLineView;
@property (nonatomic, retain) CNGridViewItemLayout *defaultLayout;
@property (nonatomic, retain) CNGridViewItemLayout *hoverLayout;
@property (nonatomic, retain) CNGridViewItemLayout *selectionLayout;
@property (nonatomic,assign) int currentSelectView;

- (void)setDelegate:(id)delegate;

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate;

- (void)loadToolBarView:(CategoryNodesEnum) nodesEnum WithDisplayMode:(BOOL)displayMode;

///搜索
- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchView;


- (void)setToolBar:(IMBToolButtonView *)toolbar;

- (void)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText;

- (void)reload:(id)sender;

- (void)addItems:(id)sender;

- (void)deleteItems:(id)sender;

- (void)doSwitchView:(id)sender;

- (void)toMac:(id)sender;

- (void)deleteItem:(id)sender;

- (void)toDevice:(id)sender;

- (void)doEdit:(id)sender;

- (void)createNewFloder:(id)sender;

- (void)rename:(id)sender;

- (void)toiCloud:(id)sender;

- (void)showDetailView:(id)sender;

- (void)moveToFolder:(id)sender;

- (void)downloadToMac:(id)sender;

- (void)sortBtnClick:(id)sender;

- (void)loadSonAryComplete:(NSMutableArray *)sonAry;

- (void)loadTransferComplete:(NSMutableArray *)transferAry WithEvent:(ActionTypeEnum)actionType;

//开始移动文件
- (void)startMoveTransferWith:(IMBDriveEntity *)entity;

@end
