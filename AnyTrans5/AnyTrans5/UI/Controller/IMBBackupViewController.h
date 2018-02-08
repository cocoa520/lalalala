//
//  IMBBackupViewController.h
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "SimpleNode.h"
#import "IMBBackUpTableView.h"
#import "IMBiPod.h"
#import "IMBBackupAllDataViewController.h"
#import "IMBMyDrawCommonly.h"
#import "LoadingView.h"
#import "IMBBackAndRestore.h"
#import "BackupViewAnimation.h"
#import "IMBScreenClickView.h"
@interface IMBBackupViewController : IMBBaseViewController<NSMenuDelegate>
{
    IMBMyDrawCommonly *_jumpViewBtn;
    int _moveRow;
    IBOutlet IMBBackUpTableView *_tableView;
    IMBBackupAllDataViewController *_allDataController;
    IBOutlet NSTextField *_titleTextStr;
    IBOutlet NSView *_backupDataView;
    IBOutlet NSBox *_itemBox;
    IBOutlet IMBWhiteView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    NSOperationQueue *_processingQueue;
    int _selectedRow;
    IMBAlertViewController *alerView;
    IBOutlet NSBox *_noDataBoxView;
   
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
@public
    NSMenu *_navMainMenu;
    
    SimpleNode *_secrettnode;//解密node
    NSInteger _oldTagRow;
    IMBBackAndRestore *_backRestore;
    double _backupProgress;
    BOOL _isCanceled;
    BOOL _isError;
    BOOL _isProgressStard;
    BOOL _isOkAction;
    IBOutlet BackupViewAnimation *_backupAnimationView;
    IBOutlet NSTextField *_backUpProgressLable;
    IBOutlet IMBAnimateProgressBar *_animateProgressView;
    IBOutlet NSTextField *_titleStr;
    IBOutlet NSTextField *_promptLabel;
    IBOutlet NSImageView *_noteImageView;
    IBOutlet IMBScreenClickView *_backupProView;
    IBOutlet NSView *_backupProgressView;
    IBOutlet NSView *_backupCompleteView;
    IBOutlet NSBox *_backupViewProgressView;
    IBOutlet NSTextField *_backupCompleteViewTitel;
    IBOutlet NSTextField *_backupCompleteSubTitle;
    IBOutlet NSTextView *_completeTextView;
    IBOutlet IMBMyDrawCommonly *_toBackupPathBtn;
    IBOutlet NSScrollView *_nodataScrollView;
    
    IBOutlet IMBWhiteView *_contentView;
    IBOutlet NSImageView *_roseProgressBgImageView;
    IBOutlet NSImageView *_bellImgView;
    HoverButton *_closebutton;
    BOOL _isBackupComplete;
    IMBDeviceConnection *_connection;
    IBOutlet NSView *_noBackupView;
    IBOutlet NSTextField *_noDataBackupTitle;
    IBOutlet NSTextView *_noDataBackupDescription;
    IBOutlet NSView *_noDataBackupView;
    IBOutlet NSImageView *_noDataBackupImageView;
    BOOL _isConnectBackup;
    BOOL _isStartBackup;
    NSMutableDictionary *_backupMainPageDic;
    
    BOOL _isView;
    BOOL _isComeFormAirwifi;//从airWifi界面进入备份的详细页面
}

@property (nonatomic, assign) BOOL isConnectBackup;
@property (nonatomic, assign) BOOL isStartBackup;
@property (nonatomic, readwrite, retain) NSMutableDictionary *backupMainPageDic;
@property (nonatomic, assign) BOOL isComeFormAirwifi;

- (void)loadButtonCell:(int)row withOutlineView:(IMBCustomHeaderTableView *)outlineView;
-(void)loadButtonMouseExitedCell:(int)row withOutlineView:(IMBCustomHeaderTableView *)outlineView;
-(id)initWithiPod:(IMBiPod *)ipod;

-(void)repIpod:(IMBiPod *)ipod;
-(void)backBackUpView;
-(void)loadViewBtn;
-(void)secireOkBtnOperation:(id)sender with:(NSString *)pass;
- (void)deleteBackupSelectedItems:(id)sender;
- (void)doBackup:(id)sender;
- (BOOL)checkIsHasBackupData;
- (void)changeViewController:(BOOL)isBool;
- (void)enterView:(SimpleNode *)node;
@end
