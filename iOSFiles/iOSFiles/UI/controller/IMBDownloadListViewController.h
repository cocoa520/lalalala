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
@interface IMBDownloadListViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate,NSTextViewDelegate>
{
    IBOutlet IMBBorderRectAndColorView *mainBgView;
    IBOutlet IMBBasedViewTableView *_tableView;

    NSMutableArray *_downloadDataSource;
    NSMutableArray *_uploadDataSource;
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
    BOOL _isDownLoadData;
    id _delegate;
    BOOL _isdeiveData;
    long long _sysSize;
}
@property (nonatomic,assign) id delagete;
@property (nonatomic,retain)NSString *exportPath;
@property (nonatomic,retain)IMBiPod *iPod;
@property (nonatomic,retain)NSMutableArray *downloadDataSource;
@property (nonatomic,retain)IMBDriveBaseManage *deviceManager;
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
- (void)icloudDriveAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent;

- (void)reloadData:(BOOL)isAdd;
- (void)reloadBgview;

- (void)switchUpDownViewAndDownView;

- (void)removeAllUpOrDownData;
@end
