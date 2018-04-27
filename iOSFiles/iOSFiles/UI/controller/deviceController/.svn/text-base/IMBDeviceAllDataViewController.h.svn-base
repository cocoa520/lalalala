//
//  IMBiCloudDriverViewController.h
//  iOSFiles
//
//  Created by smz on 18/3/14.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "CNGridView.h"
#import "IMBDriveBaseManage.h"
#import "LoadingView.h"
#import "IMBToolButtonView.h"
#import "IMBFileSystemManager.h"
#import "IMBDevicePopoverViewController.h"
#import "LoadingViewTwo.h"
#import "IMBGrideView.h"

@interface IMBDeviceAllDataViewController : IMBBaseViewController<CNGridViewDelegate,CNGridViewDataSource> {
    
    IBOutlet IMBWhiteView *_topView;
    
    IBOutlet NSBox *_contentBox;
    
    IBOutlet IMBWhiteView *_gridBgView;
    IBOutlet CNGridView *_gridView;
    
    IBOutlet IMBWhiteView *_tableViewBgView;
    
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingViewTwo *_loadAnimationView;
    
    IBOutlet IMBGrideView *_loadLeftMaskView;
    IBOutlet IMBGrideView *_loadRightMaskView;
    
    IBOutlet IMBBackgroundBorderView *_topLineView;
    
    IBOutlet IMBWhiteView *_nodataView;
    IBOutlet NSImageView *_nodataImageView;
    IBOutlet NSTextView *_nodataTextView;
    
    IBOutlet IMBWhiteView *_leftContentView;
    IBOutlet IMBWhiteView *_rightContentView;
    IBOutlet IMBBackgroundBorderView *_rightLineView;
    
    //点击详细显示
    IBOutlet NSImageView *_detailImageView;
    IBOutlet NSTextField *_detailTitle;
    
    IBOutlet NSTextField *_detailSize;
    IBOutlet NSTextField *_detailCreateTime;
    
    IBOutlet NSTextField *_detailSizeContent;
    IBOutlet NSTextField *_detailCreateTimeContent;
    
    IBOutlet IMBBorderRectAndColorView *_promptCustomView;
    IBOutlet NSTextField *_promptLabel;
    IBOutlet NSImageView *_promptImageView;
    
    IMBDriveBaseManage *_driveBaseManage;
    NSString *_currentDevicePath;
    
    NSMutableDictionary *_tempDic;
    int _doubleclickCount;
    BOOL _doubleClick;
    NSMutableDictionary *_oldWidthDic;
    NSMutableDictionary *_oldDocwsidDic;
    NSPopover *_devChoosePopover;
    BOOL _isShow;
    id _curEntity;
    BOOL _isShowTranfer;
    IMBBaseEntity *_baseEntity;
    
//    CategoryNodesEnum _categoryNodeEunm;
    IMBFileSystemManager *_systemManager;
    IMBDevicePopoverViewController *_devicePopoverViewController;
    int downCount;
    
    IBOutlet NSButton *_closeDetailBtn;
    
    BOOL _isSmipNode;
    NSString *_appKey;
    BOOL _isTableViewEdit;
    NSTextField *_editTextField;
    BOOL _isPreview;//如果是预览 就不掉完成代理
}
- (id)initWithCategoryNodesEnum:(CategoryNodesEnum )nodeEnum withiPod:(IMBiPod *)iPod WithDelegete:(id)delegete;
- (void)loadApplicationsData;
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount;
- (void)moveitemsToIndex:(int)index;
@end
