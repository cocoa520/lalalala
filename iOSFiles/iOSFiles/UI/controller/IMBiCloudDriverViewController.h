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
#import "DriveItem.h"
#import "IMBDriveEntity.h"
#import "IMBCommonEnum.h"
#import "LoadingViewTwo.h"
#import "IMBGrideView.h"
#import "IMBDevicePopoverViewController.h"
@class IMBBaseInfo;
@interface IMBiCloudDriverViewController : IMBBaseViewController<CNGridViewDelegate,CNGridViewDataSource> {
    
    IBOutlet IMBWhiteView *_topView;
    
    IBOutlet NSBox *_contentBox;
    
    IBOutlet IMBWhiteView *_gridBgView;
    IBOutlet CNGridView *_gridView;
    
    IBOutlet IMBWhiteView *_tableViewBgView;
    
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingViewTwo *_loadAnimationView;
    
    IBOutlet IMBGrideView *_loadLeftView;
    IBOutlet IMBGrideView *_loadRightView;
    
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
    IBOutlet NSTextField *_detailCount;
    IBOutlet NSTextField *_detailCreateTime;
    
    IBOutlet NSTextField *_detailSizeContent;
    IBOutlet NSTextField *_detailCountContent;
    IBOutlet NSTextField *_detailCreateTimeContent;
    
    IBOutlet IMBBorderRectAndColorView *_promptCustomView;
    IBOutlet NSTextField *_promptLabel;
    IBOutlet NSImageView *_promptImageView;
    IMBDriveBaseManage *_driveBaseManage;
    IMBDriveBaseManage *_tagDriveBaseManage;
    NSString *_currentDevicePath;
    NSString *_currentGetListPath;//刷新用这个路径；
    
    NSMutableDictionary *_tempDic;
    int _doubleclickCount;
    BOOL _doubleClick;
    NSMutableDictionary *_oldWidthDic;
    NSMutableDictionary *_oldDocwsidDic;
    NSMutableDictionary *_oldFileidDic;
    
    BOOL _isShow;
    IMBDriveEntity *_curEntity;
    BOOL _isShowTranfer;

    BOOL _isTableViewEdit;
    NSTextField *_editTextField;

    IMBBaseInfo *_baseInfo;
    IBOutlet NSButton *_closeDetailBtn;
    BOOL _isDriveToDrive;
    NSPopover *_devChoosePopover;
    IMBDevicePopoverViewController *_devicePopoverViewController;
}
@property (nonatomic, retain) IMBBaseInfo *baseInfo;

- (void)moveitemsToIndex:(int)index;

- (id)initWithDrivemanage:(IMBDriveBaseManage *)driveManage withDelegete:(id)delegete withChooseLoginModelEnum:(ChooseLoginModelEnum) chooseLogModelEnum;
//这个方法中的，总数和个数不是真的
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount;

- (void)selectItemAry:(NSMutableArray *)itemAry;
- (void)moveToItemIndex:(int)index;
@end
