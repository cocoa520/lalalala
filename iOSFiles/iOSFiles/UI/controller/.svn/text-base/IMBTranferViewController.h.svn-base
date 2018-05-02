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


@class IMBPurcahseLeftNumLabel;


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
    IBOutlet NSTextField *_titleLabel;
    IBOutlet IMBPurcahseLeftNumLabel *_firstLabel;
    IBOutlet IMBPurcahseLeftNumLabel *_secondLabel;
    IBOutlet IMBPurcahseLeftNumLabel *_thirdLabel;
    
    NSArray *_leftNums;
    IBOutlet NSBox *_limitBox;
    IBOutlet IMBBackgroundBorderView *_limitView;
    IBOutlet IMBGridientButton *_unlimitBtn;
    
    IBOutlet NSImageView *_keyImageView;
    
    
    IBOutlet NSLayoutConstraint *_limitBoxH;
    
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) id reloadDelegate;
@property (nonatomic,retain) NSString *deviceExportPath;
@property (nonatomic,retain) IMBDriveBaseManage *driveBaseManage;
@property (nonatomic,retain) NSMutableArray *selectedAry;
@property (nonatomic,retain) NSString *appKey;
@property (nonatomic, assign) id showWindowDelegate;
@property (nonatomic, assign) ChooseLoginModelEnum chooseLoginModelEnum;
@property(nonatomic, retain)NSArray *leftNums;

@property(nonatomic, copy)void(^unlimitClicked)(void);

+ (instancetype)singleton;
/**
 *  icloud 上传 下载
 *  @param addDataSource  选择的数据
 *  @param isdown  是否是下载  yes 是下载  No是上传
 *  @param categoryNodesEnum device 不同数据的枚举   icloud 传 Category_Normal
 *  @param driveBaseManage  iclouddrive 或者 dropbox 管理对象
 *  @param uploadParent  上传的目录
 *  @param docID  用户新建文件夹
 */
- (void)icloudDriveAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent withUploadDocID:(NSString *) docID;
/**
 *  dropBox 上传 下载
 *  @param addDataSource  选择的数据
 *  @param isdown  是否是下载  yes 是下载  No是上传
 *  @param categoryNodesEnum device 不同数据的枚举   icloud 传 Category_Normal
 *  @param driveBaseManage  iclouddrive 或者 dropbox 管理对象
 *  @param uploadParent  上传的目录
 */
- (void)dropBoxAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent;
/**
 *  device 上传 下载
 *  @param addDataSource  选择的数据
 *  @param isdown  是否是下载  yes 是下载  No是上传
 *  @param categoryNodesEnum device 不同数据的枚举   icloud 传 Category_Normal
 *  @param driveBaseManage  iclouddrive 或者 dropbox 管理对象
 *  @param uploadParent  上传的目录
 */
- (void)deviceAddDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum isExportPath:(NSString *) exportPath withSystemPath:(NSString *)systemPath;
/**
 *  设备toicloud 下载
 *  @param addDataSource  选择的数据
 *  @param isdown  是否是下载  yes 是下载  No是上传
 *  @param categoryNodesEnum device 不同数据的枚举   icloud 传 Category_Normal
 *  @param driveBaseManage  iclouddrive 或者 dropbox 管理对象
 *  @param uploadParent  上传的目录
 */
- (void)downDeviceDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum isExportPath:(NSString *) exportPath withSystemPath:(NSString *)systemPath;
/**
 *  todevice
 *  @param addDataSource  选择的数据
 *  @param isdown  是否是下载  yes 是下载  No是上传
 *  @param categoryNodesEnum device 不同数据的枚举   icloud 传 Category_Normal
 *  @param driveBaseManage  iclouddrive 或者 dropbox 管理对象
 *  @param uploadParent  上传的目录
 */
- (void)toDeviceAddDataSorue:(NSMutableArray *)addDataSource withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum srciPodKey:(NSString *)srcIpodKey desiPodKey:(NSString *)desiPodKey ;

- (void)dropBoxToDeviceAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent  withiPod:(IMBiPod *)ipod;

- (void)icloudToDriveAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent withUploadDocID:(NSString *) docID withiPod:(IMBiPod *)ipod;

- (void)loadCompleteData:(DriveItem *)driveItem;
- (void)reparinitialization;
- (IBAction)closeCompleteView:(id)sender;
- (void)removeAllHistoryAry;
- (void)transferBtn:(IMBHoverChangeImageBtn *)transferBtn;
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount;
- (void)setLimitViewShowing:(BOOL)showing;
/**
 *  完成界面删除所有记录
 */
- (void)removeCompletData:(DriveItem *)driveItem WithIsRemoveAllData:(BOOL) isRemoveAllData;
@end
