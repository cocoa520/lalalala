//
//  IMBTranferViewController.h
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/22.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBackgroundBorderView.h"
#import "IMBDriveBaseManage.h"
#import "IMBDownloadListViewController.h"
#import "IMBTranferShowCompleteViewController.h"
#import "DriveItem.h"
#import "IMBImageAndTitleButton.h"

@interface IMBTranferViewController : NSViewController
{
    IBOutlet IMBBackgroundBorderView *_topView;
    IBOutlet NSBox *_boxView;
    IBOutlet IMBWhiteView *_bottomView;
    IMBDriveBaseManage *_driveBaseManage;
    IMBDownloadListViewController *_downLoadViewController;
    CategoryNodesEnum _categoryNodesEnum;
    ChooseLoginModelEnum _chooseLoginModelEnum;
    NSString *_deviceExportPath;
    IBOutlet IMBWhiteView *_topBottomLine;
    IBOutlet NSButton *_topLeftBtn;
    IBOutlet IMBGridientButton *_topRightBtn;
    NSMutableArray *_allHistoryArray;
    IBOutlet NSBox *_topBoxs;
    IBOutlet NSBox *_bottomBoxs;
    IBOutlet NSView *_topCompletVIew;
    IBOutlet NSView *_bottomCompleteView;
    IMBTranferShowCompleteViewController *_tranferCompleteViewController;
    IBOutlet IMBImageAndTitleButton *_deleteAllBtn;
    IBOutlet IMBGridientButton *_historyBtn;
    IBOutlet IMBWhiteView *_bottomLineView;
    IBOutlet IMBImageAndTitleButton *_closeCompleteView;
    id _delegate;
    BOOL _isDownLoadView;
    IBOutlet IMBMyDrawCommonly *_removeAllCompleDataBtn;
    IBOutlet IMBWhiteView *_completeBottomViewTopLine;
    IMBHoverChangeImageBtn *_tranferBtn;
    NSString *_appKey;
    id _showWindowDelegate;
    id _reloadDelegate;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) id reloadDelegate;
@property (nonatomic,retain) NSString *deviceExportPath;
@property (nonatomic,retain) IMBDriveBaseManage *driveBaseManage;
@property (nonatomic,retain) NSMutableArray *selectedAry;
@property (nonatomic,retain) NSString *appKey;
@property (nonatomic, assign) id showWindowDelegate;
@property (nonatomic, assign) ChooseLoginModelEnum chooseLoginModelEnum;

+ (instancetype)singleton;
- (void)loadDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withSelectedAry:(NSMutableArray *)selectedAry withIsDownItem:(BOOL)isDownItem withiPod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum withIsiCloudDrive:(BOOL)isiCloudDrive;

- (void)icloudDriveAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent withUploadDocID:(NSString *) docID;
- (void)dropBoxAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent;
- (void)deviceAddDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum isExportPath:(NSString *) exportPath withSystemPath:(NSString *)systemPath;
- (void)downDeviceDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum isExportPath:(NSString *) exportPath withSystemPath:(NSString *)systemPath;
- (void)toDeviceAddDataSorue:(NSMutableArray *)addDataSource withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum srciPodKey:(NSString *)srcIpodKey desiPodKey:(NSString *)desiPodKey ;
- (void)loadCompleteData:(DriveItem *)driveItem;
- (void)reparinitialization;
- (IBAction)closeCompleteView:(id)sender;
- (void)removeAllHistoryAry;
- (void)transferBtn:(IMBHoverChangeImageBtn *)transferBtn;
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount;

@end
