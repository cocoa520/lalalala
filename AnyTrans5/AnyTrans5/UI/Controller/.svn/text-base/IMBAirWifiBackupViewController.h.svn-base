//
//  IMBAirWifiBackupViewController.h
//  AnyTrans
//
//  Created by smz on 17/10/18.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBSwitchButton.h"
#import "IMBGeneralButton.h"
#import "IMBPopupButton.h"
#import "IMBTextButtonView.h"
#import "IMBAirBackupAnimationView.h"
#import "IMBCustomPopBtn.h"
#import "IMBAirBackupDeviceBtn.h"
#import "IMBAirBackupPopoverViewController.h"
#import "IMBCanClickText.h"
#import "IMBBackupInfoViewController.h"
#import "IMBGridientButton.h"
#import "IMBMonitorBtn.h"

typedef enum AnnoyMode {
    Change_BackupScheduled = 0,
    Backup_Now = 1,
    BackupStorage_None = 2,
    BackupStorage_Limit = 3,
}AnnoyEnum;

@interface IMBAirWifiBackupViewController : IMBBaseViewController<NSPopoverDelegate> {
    
    IBOutlet NSView *_airBackupView;
    IBOutlet NSTextField *_noDeviceTitle;
    IBOutlet NSImageView *_backgroundImageView;
    IBOutlet IMBAirBackupDeviceBtn *_deviceNamePopBtn;
    IBOutlet NSTextView *_subTitleTextView;
    IBOutlet IMBWhiteView *_topLineView;
    IBOutlet IMBWhiteView *_bottomLineView;
    IBOutlet NSImageView *_imageView1;
    IBOutlet NSTextField *_detaiTitle1;
    IBOutlet NSTextField *_detailSubTitle1;
    IBOutlet NSImageView *_imageView2;
    IBOutlet NSTextField *_detaiTitle2;
    IBOutlet NSTextField *_detailSubTitle2;
    IBOutlet NSImageView *_imageView3;
    IBOutlet NSTextField *_detaiTitle3;
    IBOutlet NSTextField *_detailSubTitle3;
    IBOutlet IMBSwitchButton *_switchButton;
    IBOutlet IMBCustomPopBtn *_dayPopBtn;
    IBOutlet IMBGeneralButton *_backupButton;
    IBOutlet IMBCanClickText *_settingTextView;
    IBOutlet NSScrollView *_learnMoreScrollView;
    IBOutlet NSScrollView *_settingScrollView;
    IBOutlet IMBCanClickText *_learnMoreTextView;
    IBOutlet IMBAirBackupAnimationView *_airBackupAnimationView;
    
    IBOutlet NSView *_noDeviceConnectSubTitleView;
    IBOutlet NSTextField *_noDeviceSubTitle;
    IBOutlet IMBGridientButton *_publicWifiBtn;
    IBOutlet IMBGridientButton *_hotWiFiBtn;
    IBOutlet NSTextField *_orLabel;
    IBOutlet NSTextField *_symbolLabel;
    
    IBOutlet IMBWhiteView *_annoyView;
    IBOutlet NSImageView *_annoyBgImageView;
    IBOutlet NSTextView *_annoyViewTitle;
    IBOutlet NSTextField *_annoyViewSubTitle;
    IBOutlet IMBMonitorBtn *_annoyButton1;
    IBOutlet IMBMonitorBtn *_annoyButton2;
    IBOutlet NSBox *_mainBox;
    NSNotificationCenter *_nc;
    IMBBaseInfo *_curBaseInfo;
    float _lastProgress;
    
    IMBAirBackupPopoverViewController *_devPopoverViewController;
    IMBBackupInfoViewController *_backupPopoverViewController;
    HoverButton *_closebutton;
    BOOL _isBackupNow;//是否是点击立即备份按钮
    AnnoyEnum _annoyEnum;
}

- (void)setBackupButtonAndDevicePopBtn;
- (void)backupTimeButtonClick;
- (void)setBackupGuideAlertView;
- (void)removeAirBackupConfigWith:(NSString *)uuidKey;
- (void)closeMasterAirBackSwitch;
@end



@interface IMBBackupRecord : NSObject {
    NSString *_name;
    NSString *_path;
    NSNumber *_size;
    NSNumber *_time;
    IPodFamilyEnum _connectType;
    BOOL _encryptBackup;//加密备份
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSNumber *size;
@property (nonatomic, retain) NSNumber *time;
@property (nonatomic, assign) IPodFamilyEnum connectType;
@property (nonatomic, assign) BOOL encryptBackup;

@end



