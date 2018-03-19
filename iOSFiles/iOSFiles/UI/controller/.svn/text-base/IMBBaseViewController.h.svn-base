//
//  IMBBaseViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCustomHeaderTableView.h"
#import "IMBToolBarView.h"
#import "IMBWhiteView.h"
#import "IMBCommonEnum.h"
#import "IMBiPod.h"

#import "IMBInformation.h"
#import "IMBInformationManager.h"
#import "MediaHelper.h"
#import "IMBDeviceInfo.h"
#import "StringHelper.h"
#import "NSString+Category.h"
#import "IMBTransferViewController.h"
#import "IMBExportSetting.h"
#import "IMBSoftWareInfo.h"
#import "CommonEnum.h"
#import "IMBCommonEnum.h"
#import "IMBCustomHeaderCell.h"
#import "IMBBackgroundBorderView.h"
#import "CommonDefine.h"
#import "IMBToolBarView.h"
#import "CNGridViewItemLayout.h"
#import "IMBCommonDefine.h"
#import "IMBToolButtonView.h"
#import "LoadingView.h"
@class IMBInformation;
@class IMBBlankDraggableCollectionView;
@class IMBBaseViewController;
@class IMBDeleteCameraRollPhotos;
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

@interface IMBBaseViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate,IMBImageRefreshListListener,NSCollectionViewDelegate,NSTextViewDelegate,NSPopoverDelegate>
{
    
    IBOutlet IMBToolButtonView *_toolBarButtonView;
    IMBiPod *_iPod;
    id _delegate;
    CategoryNodesEnum _category;
    id<InnerViewSwitchDelegate> _navigationController;
    NSMutableArray *_dataSourceArray; ///<表格数据源,通常指左边表格的数据源 此数据源是所有的数据
    NSMutableArray *_researchdataSourceArray;///<此数据源是指搜索之后的数据源
    
    NSMutableArray *_playlistArray;
    
    IBOutlet NSCollectionView *_noDataCollectionView;
    
    IBOutlet NSScrollView *_noDataViewScrollView;
    
    BOOL _itemTableViewcanDrag; //是否支持拖;
    BOOL _itemTableViewcanDrop; //是否支持放
    BOOL _collectionViewcanDrag; //是否支持拖;
    BOOL _collectionViewcanDrop; //是否支持放
    IMBInformation *_information;

    IBOutlet NSBox *_box;
    BOOL _isAscending;
    IBOutlet IMBWhiteView *_topWhiteView;
    IBOutlet IMBWhiteView *_topwhiteView2;
    IMBTransferViewController *_transferController;
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
    IMBDeleteCameraRollPhotos *camera;
    @public
    IBOutlet  IMBBlankDraggableCollectionView  *_collectionView;
    IBOutlet  NSArrayController *_arrayController;
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
    
    BOOL _isShowLineView;
//    LoadingView *_loadingView;
}
@property (nonatomic,retain) IMBiPod *iPod;
@property (nonatomic,assign) BOOL isShowLineView;
@property (nonatomic,assign) BOOL isStop;
@property (nonatomic,assign) BOOL isSearch;
@property (nonatomic,retain) NSCondition *condition;
@property (nonatomic,assign)id<InnerViewSwitchDelegate> navigationController;///<弱引用
@property(nonatomic,retain)NSMutableArray *dataSourceArray;
@property(nonatomic,retain)NSMutableArray *researchdataSourceArray;
@property (nonatomic,assign) CategoryNodesEnum category;

@property (nonatomic,assign) BOOL itemTableViewcanDrag;
@property (nonatomic,assign) BOOL itemTableViewcanDrop;
@property (nonatomic,assign) BOOL collectionViewcanDrag;
@property (nonatomic,assign) BOOL collectionViewcanDrop;
@property (nonatomic,assign) BOOL isPause;
@property (nonatomic, retain) IMBBackgroundBorderView *mainTopLineView;
@property (nonatomic, retain) CNGridViewItemLayout *defaultLayout;
@property (nonatomic, retain) CNGridViewItemLayout *hoverLayout;
@property (nonatomic, retain) CNGridViewItemLayout *selectionLayout;
@property (nonatomic,assign) int currentSelectView;

- (void)setDelegate:(id)delegate;

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate;
- (void)setTableViewHeadOrCollectionViewCheck;
- (void)doOkBtnOperation:(id)sender;
#pragma mark rightKeyClick
- (IBAction)doDeleteItem:(id)sender;
- (IBAction)doToDeviceItem:(id)sender;
- (IBAction)doToMacItem:(id)sender;
- (IBAction)doToiTunesItem:(id)sender;
- (void)setToolBar:(IMBToolBarView *)toolbar;
//切换页面时刷新界面
- (void)reloadTableView;
- (void)loadCollectionView:(BOOL)isFrist;
- (void)ShowWindowControllerCategory;
#pragma mark drop and drag Actions
- (void)dragToMac:(NSIndexSet *)indexSet withDestination:(NSString *)destinationPath withView:(NSView *)view;//拖入到电脑
- (void)dropToTabView:(NSTableView *)tableView paths:(NSArray *)pathArray;//拖入到设备


- (void)dropToCollectionView:(NSCollectionView *)collectionView paths:(NSMutableArray *)pathArray;


- (void)reloadData;
- (void)cancelReload;
//内页返回按钮
- (void)doBack:(id)sender;
- (void)back:(id)sender;
-(void)loadData:(NSMutableArray *)ary;
//获得选中的item
- (NSIndexSet *)selectedItems;
- (void)animationAddTransferView:(NSView *)view;
- (void)animationAddTransferViewfromRight:(NSView *)view AnnoyVC:(NSViewController *)AnnoyVC;

#pragma alert
//返回-1 表示点击cancel 返回1 表示点击ok
- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText;
- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText CancelButton:(NSString *)cancelText;


// 检查备份是否被加密
- (BOOL)checkBackupEncrypt;
//检查网络和服务器是否正常连接
- (BOOL)checkInternetAvailble;
//检查数据库是否损坏
- (void)checkCDBcorrupted;
//检查是否有另一个设备准备好 可以clone和merge、todevcie
- (BOOL)checkDeviceReady:(BOOL)todevice;
//iclud拖拽上传下载
- (void)copyInfomationToMac:(NSString *)filePath indexSet:(NSIndexSet *)set;
- (void)copyInPhotofomationToMac:(NSString *)filePath indexSet:(NSIndexSet *)set;
- (void)dropUpLoad:(NSMutableArray *)pathArray;
//屏蔽按钮
- (void)disableFunctionBtn:(BOOL)isDisable;

#pragma mark - delete Action
-(void)deleteBackupSelectedItems:(id)sender;
- (void)setDeleteProgress:(float)progress withWord:(NSString *)msgStr;
- (void)setDeleteComplete:(int)success totalCount:(int)totalCount;
- (void)toDeviceWithSelectArray:(NSMutableArray *)selectArry WithView:(NSView *)view;

#pragma mark - import Action
- (void)importToDevice:(NSMutableArray *)paths photoAlbum:(IMBPhotoEntity *)photoAlbum playlistID:(int64_t)playlistID Result:(long long)result AnnoyVC:(NSViewController *)annoyVC;

#pragma mark - CheckNeedAnnoy;
//核查是否需要弹出骚扰窗口 -1表示已注册 0表示剩余为0 无法传输 如果大于0表示能够传输
- (long long)checkNeedAnnoy:(NSViewController **)annoyVC;
- (void)changeSkin:(NSNotification *)notification;
- (void)showAlert;


- (NSData *)readFileData:(NSString *)filePath;
//刷新tableview头上的checkbox
- (void)setTableViewHeadCheckBtn;


//- (void)refresh:(IMBInformation *)information;
//- (void)toMac:(IMBInformation *)information;
//- (void)addToDevice:(IMBInformation *)information;
//- (void)deleteItem:(IMBInformation *)information;
//- (void)toDevice:(IMBInformation *)information;
//- (void)doEdit:(IMBInformation *)information;

//iCloudDriver
- (void)reload:(id)sender;
- (void)addItems:(id)sender;
- (void)deleteItems:(id)sender;
- (void)doSwitchView:(id)sender;
- (void)refresh:(id)sender;
- (void)toMac:(id)sender;
- (void)addToDevice:(id)sender;
- (void)deleteItem:(id)sender;
- (void)toDevice:(id)sender;
- (void)doEdit:(id)sender;
@end
