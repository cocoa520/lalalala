//
//  IMBTransferViewController.h
//  AnyTransforCloud
//
//  Created by hym on 03/05/2018.
//  Copyright © 2018 IMB. All rights reserved.
//


typedef enum transferType {
    UploadType,
    DownLoadType,
    CompleteType,
}transferEnum;

#import <Cocoa/Cocoa.h>
#import "IMBCustomTableView.h"
#import "IMBUserHistoryTable.h"
@class IMBBorderRectAndColorView;
@class IMBSelectedButton;
@class IMBWhiteView;
@class IMBScrollView;
@class IMBTransferHistoryTable;
@class IMBTransferPopoverController;
@class IMBCloudManager;
@class IMBAlertViewController;
@interface IMBTransferViewController : NSViewController <NSTableViewDelegate,NSTableViewDataSource,NSPopoverDelegate>
{
    IBOutlet IMBBorderRectAndColorView *_bgView;
    IBOutlet IMBSelectedButton *_upLoadBtn;
    IBOutlet IMBSelectedButton *_downLoadBtn;
    IBOutlet IMBSelectedButton *_completeBtn;
    IBOutlet IMBWhiteView *_lineView;
    IBOutlet IMBWhiteView *_moveLineView;
    IBOutlet NSBox *_contentBox;
    IBOutlet NSTextField *_bottomTitle;
    IBOutlet IMBWhiteView *_bottomLineView;
    IBOutlet IMBSelectedButton *_pauseBtn;
    IBOutlet IMBSelectedButton *_deleteBtn;
    
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImgView;
    IBOutlet NSTextField *_noDataTitle;
    IBOutlet NSTextField *_noDataSubTitle;
    
    IBOutlet IMBScrollView *_upLoadTableViewScrollView;
    IBOutlet IMBCustomTableView *_upLoadItemTableView;
    IBOutlet IMBScrollView *_downLoadTableViewScrollView;
    IBOutlet IMBCustomTableView *_downLoadItemTableView;
    IBOutlet IMBScrollView *_completeTableViewScrollView;
    IBOutlet IMBCustomTableView *_completeItemTableView;
    transferEnum _transferType;
    
    NSPopover *_devPopover;
    IMBTransferPopoverController *_transferPopoverController;
    
    NSMutableArray *_upLoadAryM;
    NSMutableArray *_downLoadAryM;
    NSMutableArray *_completeAryM;
    id _allCloudDelegate;
    NSMutableDictionary *_allCloudDic;
    IMBCloudManager *_cloudManager;
    IMBTransferHistoryTable *_transferHistoryTable;
    IMBAlertViewController *_alertViewController;
}
@property (nonatomic, assign) id allCloudDelegate;
@property (nonatomic, retain) NSMutableDictionary *allCloudDic;
@property (nonatomic, retain) NSMutableArray *upLoadAryM;
@property (nonatomic, retain) NSMutableArray *downLoadAryM;
@property (nonatomic, retain) NSMutableArray *completeAryM;
@property (nonatomic, retain) NSPopover *devPopover;
/**
 *  添加新的上传任务
 *
 *  @param ary 新的的任务
 */
- (void)addNewUploadAry:(NSMutableArray *)ary;

/**
 *  添加新的下载任务
 *
 *  @param ary 新的的任务
 */
- (void)addNewDownloadAry:(NSMutableArray *)ary;

/**
 *  确定删除所有的任务
 *
 *  @param sender
 */
- (void)sureToDeleteAllTask:(id)sender;

/**
 *  取消删除所有的任务
 *
 *  @param sender
 */
- (void)cancelToDeleteAllTask:(id)sender;
@end
