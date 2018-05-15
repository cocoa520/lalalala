//
//  IMBAllCloudViewController.h
//  AnyTransforCloud
//
//  Created by hym on 24/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "IMBBaseManager.h"
#import "IMBScrollView.h"
#import "IMBToolBarView.h"
#import "IMBCheckButton.h"
#import "IMBCurrencySvgButton.h"
#import "IMBWhiteView.h"
#import "IMBCanClickText.h"
#import "IMBTextLinkButton.h"
#import "IMBPathMenuView.h"
#import "IMBSortMenuView.h"
#import "IMBPromptView.h"
#import "IMBRightKeyMenu.h"

@class IMBTableRowView;
@class IMBDriveModel;
@class IMBMoreMenuView;
@class CloudItemView;
@class LoadingView;
@interface IMBAllCloudViewController : IMBBaseViewController {
    IBOutlet NSView *_bgView;
    IBOutlet NSBox *_contentBox;
    IBOutlet IMBScrollView *_collectionScrollView;
    IBOutlet IMBScrollView *_tableViewScrollView;
    IBOutlet IMBWhiteView *_tableBgView;
    
    IBOutlet NSView *_topContentView;
    IBOutlet IMBWhiteView *_leftContentView;
    IBOutlet IMBWhiteView *_rightContentView;
    
    BOOL _isShow;
    
    IBOutlet NSButton *_closeDetailBtn;
    
    //点击详细显示
    IBOutlet NSImageView *_detailImageView;
    IBOutlet NSTextField *_detailTitle;
    
    IBOutlet NSTextField *_detailLabel1;
    IBOutlet NSTextField *_detailLabel2;
    IBOutlet NSTextField *_detailLabel3;
    IBOutlet NSTextField *_detailLabel4;
    IBOutlet NSTextField *_detailLabel5;
    
    IBOutlet NSTextField *_detailContent1;
    IBOutlet NSTextField *_detailContent2;
    IBOutlet NSTextField *_detailContent3;
    IBOutlet NSTextField *_detailContent4;
    IBOutlet NSTextField *_detailContent5;
   
    IBOutlet NSView *_topLeftView;
    IBOutlet NSView *_topLeftView2; //用来存放文件名显示不下的情况，默认是隐藏状态
    IBOutlet IMBToolBarView *_toolbarView;
    IBOutlet IMBCheckButton *_selectAllBtn;
    IMBMoreMenuView *_moreMenu;
    BOOL _isOpenMenu;
    CloudItemView *_openMenuView;
    
    IMBFileTableCellView *_openMenuCell;

    //nodata界面
    IBOutlet IMBWhiteView *_noDataView;
    IBOutlet NSImageView *_noDataImage;
    IBOutlet IMBCanClickText *_noDataText;
    //刷新
    IBOutlet IMBWhiteView *_loadingBgView;
    IBOutlet LoadingView *_loadingAnimationView;
    
    IBOutlet NSButton *_pathMenuBtn;
    IBOutlet IMBTextLinkButton *_lastPathBtn;
    IBOutlet NSImageView *_arrowImage;
    IMBPathMenuView *_pathMenu;
    
    int _doubleclickCount;
    BOOL _isFristEnter;
    NSMutableDictionary *_tempDic; //记录每次双击过后的数组
    NSMutableDictionary *_oldWidthDic; //记录每次双击过后的名字长度
    NSMutableDictionary *_oldDocwsidDic; //记录双击文件夹的Docwsid
    NSMutableDictionary *_oldFileidDic; //记录双击文件夹的fileid
    NSMutableDictionary *_oldPathTextDic; //记录每次双击文件夹的实体
    NSMutableDictionary *_allPathBtnDic; //记录所有的路径按钮
    
    BOOL _isClickMenu;  //是否正在点击pathMenu
    BOOL _isPathMenuOpen;  //pathMenu是否处于打开状态
    
    int _selectCount; ///上一次的选中个数
    
    //sortMenu
    IMBSortMenuView *_sortMenuView;
    BOOL _isSortMenuOpen;
    
    IMBRightKeyMenu *_rightKeyMenu;
    BOOL _isRightKeyMenuOpen;
}

/**
 *  重新加载数据源
 *
 *  @param dataArr 数据源数组
 */
- (void)changeContentViewWithDataArr:(NSMutableArray *)dataArr;

@end
