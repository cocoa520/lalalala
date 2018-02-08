//
//  IMBiCloudDriverViewController.h
//  AnyTrans
//
//  Created by LuoLei on 17-2-6.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "LoadingView.h"
#import "IMBBackgroundBorderView.h"
#import "DownLoadView.h"
@class IMBiCloudDriverDListViewController;
@interface IMBiCloudDriverViewController : IMBBaseViewController
{
    NSMutableArray *_backContainer;
    IBOutlet NSView *_noDataView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSView *_detailView;
    IBOutlet NSBox *_mainBox;
    
    IBOutlet NSTextField *_itemTitleField;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    IBOutlet HoverButton *backButton;
    IBOutlet IMBWhiteView *_bgView;
    IBOutlet IMBBackgroundBorderView *_backandnextView;

    IBOutlet HoverButton *_homePage;
    int currentIndex;
    NSMutableArray *_currentArray;
    NSString *_currentDevicePath;
    IBOutlet NSScrollView *_scrollView;
    //总共下载文件的大小
    long long _totolSize;

    float _loadOneFileloadsize;
    //下载所有文件的大小
    float _allDownSize;
    int _updateCount;
    //当前文件已经下载的大小
    float _nowFileSize;
    float _LastFileSize;
    IMBiCloudDriveFolderEntity *_selectedNode;
    NSString *_upLoadString;
    NSMutableArray *_fileContainer;
//    NSMutableArray *_failedArray;
    IMBiCloudDriveFolderEntity *_curDriveEntity;
   
  
    //上传总共的大小
    float _upLoadTotolSize;
    //
    float _upLoadDownTotolSize;
    float _upLoadNowDownSize;
    float _upLoadLastDownSize;
    int _successCount;
    BOOL _isResume;
    NSMutableArray *_failedArray;
    
    IBOutlet IMBBackgroundBorderView *_separateLine;
    DownLoadView *_downloadBgView;
    
    IMBiCloudDriverDListViewController *_icloudListVC;
    BOOL _isCollectionView;
    
    IBOutlet NSView *_detailTableView;
    
}



@property(nonatomic,retain) NSMutableArray *currentArray;
@property (nonatomic,retain) NSString *currentDevicePath;
- (void)retToolbar:(IMBToolBarView *)toolbar;

//继续下载或者上传
- (void)continueloadData;
//取消骚扰窗口的定时器
- (void)cancelTimerData;
- (void)iCloudReload:(id)sender;
- (void)copyInfomationToMac:(NSString *)filePath indexSet:(NSIndexSet *)set;

- (void)setToolBar:(IMBToolBarView*)toolBar;
- (void)doubleClick:(NSInteger)selectIndex ;
- (void)singlecCick:(NSNotification *)notification;
- (void)singleClickTableView;
@end
