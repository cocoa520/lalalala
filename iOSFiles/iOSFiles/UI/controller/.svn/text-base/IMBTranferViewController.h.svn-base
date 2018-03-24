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

@interface IMBTranferViewController : NSViewController
{
    IBOutlet IMBBackgroundBorderView *_topView;
    IBOutlet NSBox *_boxView;
    IBOutlet NSView *_bottomView;
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
}
@property (nonatomic,retain) NSString *deviceExportPath;
@property (nonatomic,retain) IMBDriveBaseManage *driveBaseManage;
@property (nonatomic,retain) NSMutableArray *selectedAry;
+ (instancetype)singleton;
- (void)loadDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withSelectedAry:(NSMutableArray *)selectedAry withIsDownItem:(BOOL)isDownItem withiPod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum withIsiCloudDrive:(BOOL)isiCloudDrive;

- (void)icloudDriveAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage;
- (void)dropBoxAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage;
- (void)deviceAddDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum isExportPath:(NSString *) exportPath;
@end
