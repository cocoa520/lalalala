//
//  IMBTransferViewController.h
//  AnyTrans
//
//  Created by iMobie on 8/1/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBAnimateProgressBar.h"
#import "IMBBaseTransfer.h"
#import "IMBCommonEnum.h"
#import "IMBBackupDecryptAbove4.h"
#import "TransferAnimationView.h"
#import "BoatAnimationView.h"
#import "CarAnimationView.h"
#import "MediaTransferAnimationView.h"
#import "IMBPhotoEntity.h"
#import "HoverButton.h"
#import "IMBAlertViewController.h"
#import "IMBContactManager.h"
#import "CommonEnum.h"
#import "IMBTextBoxView.h"
#import "IMBGridientButton.h"
#import "IMBDrawOneImageBtn.h"
#import "IMBAndroidAlertViewController.h"

@class IMBiCloudManager;
typedef enum TransferAnimation {
    CustomAnimation = 1,
    BoatAnimation = 2,
    CarAnimation = 3,
    MediaAnimation = 4,
} TransferAnimationType;

typedef enum TransferMode {
    TransferExport = 1,
    TransferImport = 2,
    TransferToiTunes = 3,
    TransferToDevice = 4,
    TransferToContact = 5,
    TransferImportContacts = 6,
    TransferDownLoad = 7,
    TransferUpLoading = 8,
    TransferSync = 9,
    TransferToiCloud = 10, //设备到iCloud
    TransferAllAndroidToiOSDevice = 11,
    TransferAllAndroidToiCloud = 12,
    TransferAllAndroidToiTunes = 13,
} TransferModeType;

@interface IMBTransferViewController : NSViewController<TransferDelegate,NSTextViewDelegate> {
    IBOutlet NSTextField *_backUpProgressLable;
    IBOutlet IMBAnimateProgressBar *_animateProgressView;
    IBOutlet NSTextField *_titleStr;
    IBOutlet NSTextField *_promptLabel;
    IBOutlet NSImageView *_noteImageView;
    IBOutlet IMBWhiteView *_contentProView;
    IBOutlet NSBox *_contentBox;
    IBOutlet TransferAnimationView *_customAnimationView;
    IBOutlet BoatAnimationView *_boatAnimationView;
    IBOutlet CarAnimationView *_carAnimationView;
    IBOutlet MediaTransferAnimationView *_mediaAnimationView;
    IBOutlet NSView *_proContentView;
    IBOutlet NSView *_contentView;
    IBOutlet NSView *_resultContentView;
    
    IBOutlet NSTextView *_resultSubTextView;
    IBOutlet NSTextField *_resultMainStr;
    IBOutlet NSTextView *_textView;
    IBOutlet NSImageView *_roseProgressBgImageView;
    IBOutlet NSImageView *_bellImgView;
    CategoryNodesEnum _category;
    NSMutableArray *_selectedItems;
    NSString *_ipodKey;
    NSString *_exportFolder;
    IMBBaseTransfer *_baseTransfer;
    NSString *_mode;//导出mationinfo类型
    IMBBackupDecryptAbove4 *_backUpDecrypt;
    NSString *_backupPath;
    
    NSDictionary *_selectDic;
    
    TransferAnimationType _animationType;
    TransferModeType _transferType;
    
    IMBPhotoEntity *_photoAlbum;
    int64_t _playlistID;
    
    NSString *_desIpodKey;
    
    id _delegate;
    HoverButton *_closebutton;
    
    BOOL _isTransferComplete;
    IMBAlertViewController *_alertViewController;
    IMBAndroidAlertViewController *_androidAlertViewController;
    IMBContactManager *_contactManager;
    BOOL _isiTunesImport; //是否是itunes导入
    
    EventCategory _eventCategory;
    NSString *_downPath;
    BOOL _isStop;
    BOOL _isicloud;
    IMBiCloudManager *_icloudManager;
    BOOL _isicloudView;
    NSTimer *_annoyTimer;
    BOOL _isPause;
    int _successCount;
    int _totalCount;
    NSCondition *_condition;
    
    int _exportType;//1--从设备导出；2--从iTunes backup导出；3--从iCloud Backup导出;0--从iTunes library导出;
    
    //icloud传输完成界面(活动)- 英语版
    IBOutlet NSTextView *_resultTitle;
    IBOutlet NSTextField *_resultSubTitle;
    IBOutlet IMBWhiteView *_resultView;
    IBOutlet NSView *_atResultView;
    
    IBOutlet IMBWhiteView *_lineViewOne;
    IBOutlet IMBWhiteView *_lineViewTwo;
    IBOutlet IMBWhiteView *_lineViewThree;
    IBOutlet IMBWhiteView *_lineViewFour;
    IBOutlet IMBWhiteView *_lineViewFive;
    
    IBOutlet IMBGridientButton *_buttonOne;
    IBOutlet IMBGridientButton *_buttonTwo;
    IBOutlet IMBGridientButton *_buttonThree;
    IBOutlet IMBGridientButton *_buttonFour;
    
    IBOutlet NSImageView *_imageViewOne;
    IBOutlet NSImageView *_imageViewTwo;
    IBOutlet NSImageView *_imageViewThree;
    IBOutlet NSImageView *_imageViewFour;
    
    IBOutlet NSTextField *_imageTitleOne;
    IBOutlet NSTextField *_imageTitleTwo;
    IBOutlet NSTextField *_imageTitleThree;
    IBOutlet NSTextField *_imageTitleFour;
    
    IBOutlet NSTextView *_imageSubTitleOne;
    IBOutlet NSTextView *_imageSubTitleTwo;
    IBOutlet NSTextView *_imageSubTitleThree;
    IBOutlet NSTextView *_imageSubTitleFour;
    
    IBOutlet NSTextView *_bottomTitle;
    
    //除英语外的icloud 完成界面
    IBOutlet IMBWhiteView *_muicloudCompleteView;
    IBOutlet NSView *_muAtCompleteView;
    IBOutlet NSTextView *_muicloudCompleteMainTitle;
    IBOutlet NSTextField *_muicloudCompleteSubTitle;
    
    IBOutlet IMBTextBoxView *_muicloudCompleteDetailView;
    IBOutlet IMBDrawOneImageBtn *_muicloudCompleteBtnView1;
    IBOutlet NSTextField *_muicloudCompleteLable1;
    IBOutlet IMBDrawOneImageBtn *_muicloudCompleteBtnView2;
    IBOutlet NSTextField *_muicloudCompleteLable2;
    IBOutlet IMBDrawOneImageBtn *_muicloudCompleteBtnView3;
    IBOutlet NSTextField *_muicloudCompleteLable3;
    IBOutlet IMBDrawOneImageBtn *_muicloudCompleteBtnView4;
    IBOutlet NSTextField *_muicloudCompleteLable4;
    IBOutlet IMBDrawOneImageBtn *_muicloudCompleteBtnView5;
    IBOutlet NSTextField *_muicloudCompleteLable5;
    
    IBOutlet NSTextField *_muicloudCompleteMiddleTitle;
    IBOutlet IMBGridientButton *_muicloudCompleteButton;
    
    
    
}
@property (nonatomic,retain) IMBiCloudManager *icloudManager;
@property (nonatomic,assign) BOOL isStop;
@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) BOOL isiTunesImport;
@property (nonatomic,assign) BOOL isicloudView;
@property (nonatomic,assign) int exportType;
//media、photo、audio等导出初始化
- (id)initWithIPodkey:(NSString *)ipodKey Type:(CategoryNodesEnum)category SelectItems:(NSMutableArray *)selectedItems ExportFolder:(NSString *)exportFolder;

- (id)initWithIPodkey:(NSString *)ipodKey Type:(CategoryNodesEnum)category SelectItems:(NSMutableArray *)selectedItems iCloudManager:(IMBiCloudManager *)iCloudManager;

//message、note、callhistory、contact、calendar等导出初始化
- (id)initWithType:(CategoryNodesEnum)category SelectItems:(NSMutableArray *)selectedItems ExportFolder:(NSString *)exportFolder Mode:(NSString *)mode ;
//icloudView的导出
- (id)initWithType:(CategoryNodesEnum)category SelectItems:(NSMutableArray *)selectedItems ExportFolder:(NSString *)exportFolder Mode:(NSString *)mode IsicloudView:(BOOL)isicloudView;

//backup目录结构导出初始化
- (id)initWithType:(CategoryNodesEnum)category SelectItems:(NSMutableArray *)selectedItems ExportFolder:(NSString *)exportFolder BackupPath:(NSString *)backupPath BackUpDecrypt:(IMBBackupDecryptAbove4 *)backUpDecrypt;

//to iTunes初始化
- (id)initWithIPodkey:(NSString *)ipodKey SelectDic:(NSDictionary *)selectedDic;

//mac到设备初始化
- (id)initWithIPodkey:(NSString *)ipodKey Type:(CategoryNodesEnum)category importFiles:(NSMutableArray *)importFiles photoAlbum:(IMBPhotoEntity *)photoAlbum playlistID:(int64_t)playlistID;

//导入file system
- (id)initWithIPodkey:(NSString *)ipodKey Type:(CategoryNodesEnum)category SelectItems:(NSMutableArray *)selectedItems curFolder:(NSString *)curFolder;

//设备到设备初始化
- (id)initWithIPodkey:(NSString *)srcIpodKey DesIpodKey:(NSString *)desIpodKey SelectDic:(NSDictionary *)selectedDic;

//contact操作;
- (id)initWithContactManager:(IMBContactManager *)contactManager SelectFiles:(NSMutableArray *)selectFiles TransferModeType:(TransferModeType)type;
//同步操作
- (id)initWithType:(CategoryNodesEnum)category withDelegate:(id)delegate withTransfertype:(TransferModeType)transferModeType;
//icloudView同步操作
- (id)initWithType:(CategoryNodesEnum)category withDelegate:(id)delegate withTransfertype:(TransferModeType)transferModeType withIsicloudView:(BOOL)isicloudView;

- (void)moveBellImageView:(int)moveX;
- (void)setExprtPath:(NSString *)path;
- (void)startTransAnimation;
@end
