//
//  IMBBaseViewController.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/19.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
#import "IMBBaseManager.h"
#import "IMBMoveAlertViewController.h"
#import "IMBCheckButton.h"
#import "IMBToolBarButton.h"
#import "IMBCustomTableView.h"
#import "IMBTableHeaderView.h"
#import "IMBCloudManager.h"
#import "IMBPromptView.h"
#import "IMBAlertViewController.h"
#import "IMBSearchManager.h"
@class IMBFileTableCellView;
@class CloudItemView;
@interface IMBBaseViewController : NSViewController<IMBDriveDelegate,NSCollectionViewDelegate,NSCollectionViewDataSource,NSTableViewDelegate,NSTableViewDataSource,IMBTableViewListener,NSTextViewDelegate,IMBSearchDelegate> {
    id _delegate;
    NSNotificationCenter *_nc;
    NSMutableArray *_dataSourAryM;///数据源
    NSMutableArray *_searchAryM;///搜索后的数据源
    BOOL _isSearch;
    IMBBaseManager *_baseManager;
    NSString *_currentDriveID;
    NSString *_currentGetListPath;//docwsid
    IBOutlet NSCollectionView *_collectionView;
    IBOutlet IMBCustomTableView *_itemTableView;
    IBOutlet IMBTableHeaderView *_tableViewHeaderView;
    
    BOOL _itemTableViewcanDrag; //是否支持拖
    BOOL _itemTableViewcanDrop; //是否支持放
    
    IMBDriveModel *_doubleDriveModel; //双击时的实体
    IMBDriveModel *_currentModel;   //当前选中的实体
    
    IMBFileTableCellView *_selectedCell; //当前选中的cell
    
    int _curSelectView;//1:collecionView  0:tableView
    IMBDriveModel *_newDriveModel; //用于新建文件夹，暂时新建的实体，如果失败删除
    CloudItemView *_newDriveItemView;
    BOOL _isRenameing;
    BOOL _isCreateFolder;
    CloudItemView *_renameItemView;
    IMBDriveModel *_renameDriveModel;
    IMBMoveAlertViewController *_alertView;
    
    IMBAlertViewController *_alertViewController;
    id _displayDelegate;
    
    CloudItemView *_cloudItemView;
    IMBPromptView *_promptView;
    NSString *_moveAndCopyFileID;

    IMBDriveModel *_itemModel;
    
    NSMutableArray *_toolBarArr;
}
@property (nonatomic, assign) id _Nonnull delegate;
@property (nonatomic, assign) id _Nonnull displayDelegate;

- (id _Nonnull)initWithDelegate:(id _Nonnull)delegate;
- (void)addNotification;
- (NSIndexSet *_Nonnull)selectedItems;
#pragma mark - toolBar action
- (void)sync:(id _Nonnull)sender; //同步
- (void)share:(id _Nonnull)sender; //分享
- (void)star:(id _Nonnull)sender; //收藏
- (void)rename:(id _Nonnull)sender; //重命名
- (void)copy:(id _Nonnull)sender; //复制
- (void)move:(id _Nonnull)sender; //移动
- (void)reload:(id _Nonnull)sender; //刷新
- (void)download:(id _Nonnull)sender; //下载
- (void)showDetailView:(id _Nonnull)sender; //展示详情
- (void)deleteFile:(id _Nonnull)sender; //删除
- (void)doSwitchView:(id _Nonnull)sender; //列表和集合的切换 以及排序
- (void)upload:(id _Nonnull)sender; //上传
- (void)createFolder:(id _Nonnull)sender; //新建文件夹
- (void)preViewFile:(id _Nonnull)sender;//预览

- (void)uploadFile:(id _Nonnull)sender;//上传文件
- (void)uploadFolder:(id _Nonnull)sender;//上传文件夹
/**
 *  保存reName名称
 *
 *  @param driveModel reName实体
 *  @param str        修改后的名字
 */
- (void)saveRenameModel:(IMBDriveModel *_Nonnull)driveModel withStr:(NSString *_Nonnull)str;

- (id _Nonnull)initWithDelegate:(id _Nonnull)delegate withDriveID:(NSString * _Nonnull)driveID;

- (id _Nonnull)initWithDelegate:(id _Nonnull)delegate withCloudEntity:(IMBCloudEntity * _Nonnull)CloudEntity;
/**
 *  star
 *
 *  @param model 具体的IMBDriveModel
 */
- (void)itemStar:(IMBDriveModel * _Nonnull)model;

/**
 *  share
 *
 *  @param model  具体的IMBDriveModel
 */
- (void)itemShare:(IMBDriveModel * _Nonnull)model;

/**
 *  sync
 *
 *  @param model  具体的IMBDriveModel
 */
- (void)itemSync:(IMBDriveModel * _Nonnull)model;

/**
 *  download
 *
 *  @param model 具体的IMBDriveModel
 */
- (void)itemDownload:(IMBDriveModel * _Nonnull)model;

/**
 *  more
 *
 *  @param model  具体的IMBDriveModel
 *  @param sender more按钮
 */
- (void)itemMore:(IMBDriveModel * _Nonnull)model withBtn:(id _Nonnull)sender;

/**
 *  改变总的复选框的状态
 *
 *  @param model  具体的IMBDriveModel
 */
- (void)changeCheckButtonState:(IMBDriveModel *_Nonnull)model;

/**
 *  取消所有选中
 *
 *  @param state 是否选中状态
 */
- (void)cancelSelectState:(NSInteger)state;

/**
 *  cell里的more
 *
 *  @param model   具体的IMBDriveModel
 *  @param moreBtn 对应的more按钮
 */
- (void)cellViewMoreBtn:(IMBDriveModel * _Nonnull)model withMoreBtn:(IMBToolBarButton * _Nonnull)moreBtn;
/**
 *  cell里的checkBtn
 *
 *  @param checkBtn 对应的checkBtn
 *  @param cellRow  对应行
 */
- (void)cellCheckButtonClick:(IMBCheckButton * _Nonnull)checkBtn withCellRow:(NSInteger)cellRow;

/**
 *  collection双击事件
 *
 *  @param model 实体
 */
- (void)collectionViewDoubleClick:(IMBDriveModel * _Nonnull)model;

/**
 *  collection右键事件
 *
 *  @param model 实体
 */
- (void)collectionViewRightMouseDownClick:(IMBDriveModel *_Nonnull)model;

/**
 *  用于iCloudDrive 数据的加载
 *
 *  @param ary      数据
 *  @param typeEnum 类型
 */
- (void)loadDriveComplete:(NSMutableArray *_Nonnull)ary WithEvent:(ActionTypeEnum)typeEnum;
/**
 *  配置详情信息
 *
 *  @param entity 单击的实体
 */
- (void)configDetailViewWith:(IMBDriveModel *_Nonnull)entity;

- (void)addTipPromptCustomView:(IMBPromptView *_Nonnull)prompt withIsDeleteView:(BOOL)isdelete;

/**
 *  单个按钮下拉框
 *
 *  @param alertText 下拉框标题
 *  @param OkText    按钮文字
 */
- (void)showAlertText:(NSString *_Nonnull)alertText OKButton:(NSString *_Nonnull)OkText;

/**
 *  两个按钮的下拉框
 *
 *  @param alertText    下拉框标题
 *  @param cancelBtnStr 取消按钮文字
 *  @param okBtnStr     确定按钮文字
 *
 *  @return 返回值为0 则取消；为1 则确定
 */
- (int)showAlertText:(NSString *_Nonnull)alertText withCancelButton:(NSString *_Nonnull)cancelBtnStr withOKButton:(NSString *_Nonnull)okBtnStr;
/**
 *  点击右键菜单功能
 *
 *  @param sender IMBMoreItem实体
 */
- (void)rightKeyMenuClick:(id _Nonnull)sender;

@end
