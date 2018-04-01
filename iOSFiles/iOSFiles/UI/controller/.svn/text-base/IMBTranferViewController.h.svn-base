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
    NSMutableArray *_downAry;
    NSMutableArray *_upAry;
    IMBDownloadListViewController *_upLoadViewController;
    IMBDownloadListViewController *_downLoadViewController;
    CategoryNodesEnum _categoryNodesEnum;
    NSString *_deviceExportPath;
    IBOutlet IMBWhiteView *_topLeftLine;
    IBOutlet IMBWhiteView *_topRightLine;
    IBOutlet IMBWhiteView *_topBottomLine;
    IBOutlet NSButton *_topLeftBtn;
    IBOutlet NSButton *_topRightBtn;
    NSMutableArray *_allHistoryArray;
    IBOutlet NSBox *_topBoxs;
    IBOutlet NSBox *_bottomBoxs;
    IBOutlet NSView *_topCompletVIew;
    IBOutlet NSView *_bottomCompleteView;
    IMBTranferShowCompleteViewController *_tranferCompleteViewController;
    IBOutlet IMBImageAndTitleButton *_deleteAllBtn;
    IBOutlet IMBImageAndTitleButton *_historyBtn;
    IBOutlet IMBWhiteView *_bottomLineView;
    IBOutlet IMBImageAndTitleButton *_closeCompleteView;
    id _delegate;
    BOOL _isDownLoadView;
    IBOutlet IMBMyDrawCommonly *_removeAllCompleDataBtn;
    IBOutlet IMBWhiteView *_completeBottomViewTopLine;
}
@property (nonatomic, assign) id delegate;
@property (nonatomic,retain) NSString *deviceExportPath;
@property (nonatomic,retain) IMBDriveBaseManage *driveBaseManage;
@property (nonatomic,retain) NSMutableArray *selectedAry;
+ (instancetype)singleton;
- (void)loadDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withSelectedAry:(NSMutableArray *)selectedAry withIsDownItem:(BOOL)isDownItem withiPod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum withIsiCloudDrive:(BOOL)isiCloudDrive;

- (void)icloudDriveAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent;
- (void)dropBoxAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent;
- (void)deviceAddDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum isExportPath:(NSString *) exportPath withSystemPath:(NSString *)systemPath;
- (void)loadCompleteData:(DriveItem *)driveItem;
- (void)reparinitialization;
- (IBAction)closeCompleteView:(id)sender;
- (void)removeAllHistoryAry;
@end
