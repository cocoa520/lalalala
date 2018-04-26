//
//  IMBDownloadListViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-12-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBackgroundBorderView.h"
#import "IMBBasedViewTableView.h"
@class IMBCustomPopupButton;
#import "IMBBaseViewController.h"
@class VideoBaseInfoEntity;
#import "IMBTextButtonView.h"
#import "IMBGridientButton.h"
#import "IMBDriveBaseManage.h"
#import "IMBBorderRectAndColorView.h"
#import "IMBDownWhiteView.h"
#import "IMBiPod.h"
#import "IMBHoverChangeImageBtn.h"
@interface IMBDownloadListViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate,NSTextViewDelegate>
{
    IBOutlet IMBBorderRectAndColorView *mainBgView;
    IBOutlet IMBBasedViewTableView *_tableView;

    NSMutableArray *_downloadDataSource;
    NSOperationQueue *_operationQueue;
    IBOutlet NSBox *_contentBox;
    IBOutlet NSImageView *_nodataImageView;
    IBOutlet NSTextField *_noTipTextField;
    IBOutlet NSScrollView *_scrollView;
    IBOutlet NSView *_nodataView;
    
    IBOutlet NSView *_reslutSuperView;
    int successCount;
    
    int _tempCount;
@public
    IMBCustomPopupButton *_popUpButton;
    IMBDriveBaseManage *_deviceManager;
    IMBiPod *_iPod;
    int _downCount;
    int _upCount;
    NSString *_exportPath;
    ChooseLoginModelEnum _chooseModeEnum;
    CategoryNodesEnum _categoryEnum;
    BOOL _isDownLoadData;
    id _delegate;
    BOOL _isdeiveData;
    long long _sysSize;
    IMBHoverChangeImageBtn *_transferBtn;
    NSString *_appKey;
    BOOL _isAllUpLoad;//是否是上次数据，上次完成刷新界面
    BOOL _isiCloudToDeviceDown;
    NSOperationQueue *_queue;
    BOOL _isiCloudDownComplete;
}
@property (nonatomic,assign) id delagete;
@property (nonatomic,retain)NSString *exportPath;
@property (nonatomic,retain)IMBiPod *iPod;
@property (nonatomic,retain)NSMutableArray *downloadDataSource;
@property (nonatomic,retain)IMBDriveBaseManage *deviceManager;
@property (nonatomic,retain)NSString *appKey;
@property (nonatomic, assign) CategoryNodesEnum categoryEnum;

/**
 *  给进度赋值
 *  @param addDataSource  选择的数据 分为文件和文件夹
 *  @param isdown  是否是下载  yes 是下载  No是上传
 *  @param categoryNodesEnum device 不同数据的枚举   icloud 传 Category_Normal
 *  @param addDataSource  ipod  针对设备  icloud 传空
 *  @param isiCloudDrive  选择下载的是否是iCloudDrive  其他的都为No
 */
- (void)deviceAddDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum isExportPath:(NSString *) exportPath withSystemPath:(NSString *)systemPath;
- (void)dropBoxAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent;
- (void)dropBoxToDeviceAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent  withiPod:(IMBiPod *)ipod;

- (void)icloudDriveAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent withUploadDocID:(NSString *) docID;
- (void)toDeviceAddDataSorue:(NSMutableArray *)addDataSource withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum srciPodKey:(NSString *)srcIpodKey desiPodKey:(NSString *)desiPodKey;
- (void)icloudToDriveAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent withUploadDocID:(NSString *) docID withiPod:(IMBiPod *)ipod;
/**
 *  toiCloud
 *  @param addDataSource  选择的数据 分为文件和文件夹
 *  @param driveBaseManage  目标云对象
 */
- (void)toiCloudBaseManager:(IMBDriveBaseManage *)driveBaseManage withAddDataSorue:(NSMutableArray *)addDataSource ;

- (void)downDeviceDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum isExportPath:(NSString *) exportPath withSystemPath:(NSString *)systemPath;
- (void)reloadData:(BOOL)isAdd;
- (void)reloadBgview;

- (void)switchUpDownViewAndDownView;

- (void)removeAllUpOrDownData;

-(void)transferBtn:(IMBHoverChangeImageBtn *)transferBtn;
@end
