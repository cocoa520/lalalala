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
#import "IMBAlertViewController.h"
#import "IMBInformation.h"
#import "IMBInformationManager.h"
#import "MediaHelper.h"
#import "IMBDeviceInfo.h"
#import "StringHelper.h"
#import "NSString+Category.h"
#import "IMBPopUpBtn.h"
#import "IMBOpenPanel.h"
#import "IMBTransferViewController.h"
#import "IMBExportSetting.h"
#import "IMBSoftWareInfo.h"
#import "IMBNewAnnoyViewController.h"
#import "OperationLImitation.h"
#import "ATTracker.h"
#import "CommonEnum.h"
#import "IMBMergeCloneAppViewController.h"
#import "IMBiCloudManager.h"
#import "IMBPopoverViewController.h"
#import "IMBiCloudPopViewController.h"
#import "IMBAndroid.h"
#import "IMBScanEntity.h"
#import "IMBCommonEnum.h"
#import "IMBCustomHeaderCell.h"
#import "IMBChineseSortHelper.h"
#import "IMBAndroidTransferViewController.h"
#import "IMBAndroidAlertViewController.h"
#import "IMBBackgroundBorderView.h"
#import "IMBSearchView.h"
#import "CommonDefine.h"

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
    IMBAndroid *_android;
    IMBiPod *_ipod;
    id _delegate;
    CategoryNodesEnum _category;
    id<InnerViewSwitchDelegate> _navigationController;
    NSMutableArray *_dataSourceArray; ///<表格数据源,通常指左边表格的数据源 此数据源是所有的数据
    NSMutableArray *_researchdataSourceArray;///<此数据源是指搜索之后的数据源
 
    IBOutlet IMBToolBarView *_toolBar;
    
    NSMutableArray *_playlistArray;
    
    IBOutlet NSCollectionView *_noDataCollectionView;
    
    IBOutlet NSScrollView *_noDataViewScrollView;
    
    IBOutlet NSMenuItem *_propertyMenuItem;
    IBOutlet NSMenuItem *_deleteMenuItem;
    IBOutlet NSMenuItem *_toDeviceMenuItem;
    IBOutlet NSMenuItem *_toMacMenuItem;
    IBOutlet NSMenuItem *_toiTunesMenuItem;
    IBOutlet NSMenuItem *_addToPlaylistMenuItem;
    IBOutlet NSMenuItem *_addToDeviceMenuItem;
    IBOutlet NSMenuItem *_toDeleteMenuItem;
    IBOutlet NSMenuItem *_isHiddenSeparator;
    IBOutlet NSMenuItem *_toiCloudMenuItem;
    IBOutlet NSMenuItem *_toAlbumMenuItem;
    IBOutlet NSMenuItem *_refreshMenuItem;
    IBOutlet NSMenuItem *_upLoadMenuItem;
    
    IBOutlet NSMenuItem *_downLoadMenuItem;
    IBOutlet NSMenuItem *_addMenuItem;
    IBOutlet NSMenuItem *_preViewMenuItem;
    IBOutlet NSMenuItem *_creatFolderMenuItem;
    
    IBOutlet NSMenuItem *_androidToDeviceItem;
    IBOutlet NSMenuItem *_androidToiTunesItem;
    IBOutlet NSMenuItem *_androidToiCloudItem;
    IBOutlet NSMenuItem *_androidReloadItem;

    
    BOOL _itemTableViewcanDrag; //是否支持拖;
    BOOL _itemTableViewcanDrop; //是否支持放
    BOOL _collectionViewcanDrag; //是否支持拖;
    BOOL _collectionViewcanDrop; //是否支持放
    IMBAlertViewController *_alertViewController;
    IMBAndroidAlertViewController *_androidAlertViewController;//android弹框
    IMBInformation *_information;

    IBOutlet NSBox *_box;
    IBOutlet IMBPopUpBtn *_sortRightPopuBtn;
    IBOutlet IMBPopUpBtn *_sortRightPopuBtn2;
    IBOutlet IMBPopUpBtn *_selectSortBtn;
    IBOutlet IMBPopUpBtn *_selectSortBtn2;//reminder列表二
    BOOL _isAscending;
    IBOutlet IMBWhiteView *_topWhiteView;
    IBOutlet IMBWhiteView *_topwhiteView2;
    IMBBackupDecryptAbove4 *_decryptAbove;
    IMBTransferViewController *_transferController;
    IMBExportSetting *_exportSetting;
    BOOL _isbackup;
    BOOL _isiCloud;
    BOOL _isloadingPopBtn;
    BOOL _isSearch;
    IMBSearchView *_searchFieldBtn;
    
    BOOL _isDeletePlaylist;
    NSMutableArray *_delArray;
    NSPopover *_toDevicePopover;
    IMBMergeCloneAppViewController *_mergeCloneAppVC;
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
    
    IMBiCloudManager *_iCloudManager;
    NSPopover *_devPopover;
    BOOL _isiCloudView;//判断是否为iCloud页面
    IMBiCloudManager *_otheriCloudManager;
    NSTimer *_annoyTimer;
     BOOL _isPause;
      NSCondition *_condition;
    BOOL _isStop;
    
    //android使用
    NSMutableArray *_baseAry;
    AryEnum showEnum;
    IMBResultEntity *_resultEntity;
    NSString *_sortName;
    IMBAndroidTransferViewController *_androidTransController;
    BOOL _isAndroid;
    BOOL _isAndroidView;

    @public
    NSWindow *_mainWindow;
    IMBBackgroundBorderView *_mainTopLineView;
    
    BOOL _isShowLineView;
}
@property (nonatomic,assign) BOOL isShowLineView;
@property (nonatomic,assign) BOOL isAndroid;
@property (nonatomic,assign) BOOL isStop;
@property (nonatomic,assign) BOOL isSearch;
@property (nonatomic,retain) NSCondition *condition;
@property (nonatomic,retain) IMBSearchView *searchFieldBtn;
@property (nonatomic,assign)id<InnerViewSwitchDelegate> navigationController;///<弱引用
@property(nonatomic,retain)NSMutableArray *dataSourceArray;
@property(nonatomic,retain)NSMutableArray *researchdataSourceArray;
@property (nonatomic,assign) CategoryNodesEnum category;

@property (nonatomic,assign) BOOL itemTableViewcanDrag;
@property (nonatomic,assign) BOOL itemTableViewcanDrop;
@property (nonatomic,assign) BOOL collectionViewcanDrag;
@property (nonatomic,assign) BOOL collectionViewcanDrop;
@property (nonatomic,retain) IMBiCloudManager *iCloudManager;
@property (nonatomic,assign) BOOL isPause;
@property (nonatomic, retain) IMBBackgroundBorderView *mainTopLineView;

- (void)setDelegate:(id)delegate;

- (id)initWithNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate WithProductVersion:(SimpleNode *)node WithIMBBackupDecryptAbove4:(IMBBackupDecryptAbove4 *)abve4;
- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate;
-(id)initiCloudWithiCloudBackUp:(IMBiCloudBackup *)icloudBackup WithDelegate:(id)delegate withCategoryNodesEnum:(CategoryNodesEnum)category;
//backup界面初始化函数
- (id)initWithProductVersion:(SimpleNode *)node withDelegate:(id)delegate WithIMBBackupDecryptAbove4:(IMBBackupDecryptAbove4*)abve4;
//icloud
-(id)initiCloudWithiCloudBackUp:(IMBiCloudBackup *)icloudBackup WithDelegate:(id)delegate;
- (id)initWithiCloudManager:(IMBiCloudManager *)iCloudManager withDelegate:(id)delegate withiCloudView:(BOOL)isiCloudView withCategory:(CategoryNodesEnum)Category;
- (id)initWithiCloudManager:(IMBiCloudManager *)iCloudManager withDelegate:(id)delegate withiCloudView:(BOOL)isiCloudView withCategory:(CategoryNodesEnum)Category  withiCloudPhotoEntity:(IMBToiCloudPhotoEntity *)iCloudPhotoEntity;
- (void)doChangeLanguage:(NSNotification *)notification;
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
- (void)dropicloudToTabView:(NSTableView *)tableView paths:(NSArray *)pathArray;

- (void)dropToCollectionView:(NSCollectionView *)collectionView paths:(NSMutableArray *)pathArray;
#pragma mark Operaiton Actions
- (void)reload:(id)sender;
- (void)addItems:(id)sender;
- (void)addItemContent;
- (void)deleteItems:(id)sender;
- (void)toiTunes:(id)sender;
- (void)toMac:(id)sender;
- (void)toDevice:(id)sender;
- (void)doDeviceDetail:(id)sender;
- (void)doSetting:(id)sender;
- (void)doExit:(id)sender;
- (void)doEdit:(id)sender;
- (void)doBackup:(id)sender;
- (void)doExitiCloud:(id)sender;
- (void)doSwitchView:(id)sender;
- (void)dofindPath:(id)sender;
- (void)doImportContact:(id)sender;
- (void)doToContact:(id)sender;
- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn;
- (void)photoToMac;
#pragma mark - iCloud Actions
- (void)toiCloud:(id)sender;
- (void)upLoad:(id)sender;
- (void)downLoad:(id)sender;
- (void)movePicture:(id)sender;
- (void)createAlbum:(id)sender;
- (void)newGroup:(id)sender;
- (void)iCloudSyncTransfer:(id)sender;
- (void)iCloudReload:(id)sender;
- (void)addiCloudItems:(id)sender;
- (void)deleteiCloudItems:(id)sender;
- (void)iClouditemtoMac:(id)sender;
- (void)doiClouditemEdit:(id)sender;
- (void)doiCloudImportContact:(id)sender;
#pragma mark - Android Actions
- (void)androidReload:(id)sender;
- (void)androidToDevice:(id)sender;
- (void)androidToiCloud:(id)sender;
- (void)androidToiTunes:(id)sender;

#pragma mark - Android rightKeyClick
- (IBAction)androidRightKeyReload:(id)sender;
- (IBAction)androidRightKeyToDevice:(id)sender;
- (IBAction)androidRightKeyToiCloud:(id)sender;
- (IBAction)androidRightKeyToiTunes:(id)sender;

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
//icloud 骚扰窗口
- (void)showiCloudAnnoyAlertTitleText:(NSString *)titleText withSubStr:(NSString *)subText withImageName:(NSString *)imageName buyButtonText:(NSString *)OkText CancelButton:(NSString *)cancelText;
- (void)showRemoveSuccessAlertText:(NSString *)alertText withCount:(int)successCount;
- (BOOL)chekiCloud:(NSString *)itemKey withCategoryEnum:(CategoryNodesEnum)categoryEnum;
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
//获得iCloud登录的其他账号
- (IMBiCloudManager *)getOtheriCloudAccountManager;
- (void)iClouddragDownDataToMac:(NSString *)pathUrl;
//设备对icloud
//一个icloud账号
- (void)deviceToiCloud:(id)sender;
- (void)toiCloudItemClicked:(id)sender;
- (void)initiCloudPhotoAlbumMenuItem;
- (void)onItemiCloudClicked:(id)sender;
- (id)initwithAndroid:(IMBAndroid *)android withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate;
- (void)initAndroidDeviceMenuItem;
- (void)initAndroidiCloudMenuItem;

- (NSData *)readFileData:(NSString *)filePath;
//刷新tableview头上的checkbox
- (void)setTableViewHeadCheckBtn;
@end
