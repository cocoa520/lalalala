//
//  IMBTranferViewController.m
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/22.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBTranferViewController.h"
#import "IMBDownloadListViewController.h"
#import "IMBDriveEntity.h"
#import "IMBMainPageViewController.h"
#import "IMBPurcahseLeftNumLabel.h"
#import "IMBPurchaseOrAnnoyController.h"
#import "IMBViewAnimation.h"
#import "IMBLimitation.h"

#import <Quartz/Quartz.h>

@class IMBTranferViewController;
static id _instance = nil;
@interface IMBTranferViewController ()

@end

@implementation IMBTranferViewController
@synthesize driveBaseManage = _driveBaseManage;
@synthesize selectedAry = _selectedAry;
@synthesize deviceExportPath = _deviceExportPath;
@synthesize delegate = _delegate;
@synthesize appKey = _appKey;
@synthesize showWindowDelegate = _showWindowDelegate;
@synthesize reloadDelegate = _reloadDelegate;
@synthesize leftNums = _leftNums;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self performSelector:@selector(addKeyAnimation) withObject:nil afterDelay:.5f];
//    [self addKeyAnimation];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

+ (instancetype)singleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[IMBTranferViewController alloc] initWithNibName:@"IMBTranferViewController" bundle:nil];
    });
    return _instance;
}

- (void)awakeFromNib {
    NSMutableParagraphStyle *pghStyle = [[NSMutableParagraphStyle alloc] init];
    pghStyle.alignment = NSTextAlignmentCenter;
    NSMutableDictionary *attrText = [[NSMutableDictionary alloc] init];
    [attrText setValue:COLOR_TEXT_ORDINARY forKey:NSForegroundColorAttributeName];
    [attrText setValue:[NSFont fontWithName:IMBCommonFont size:14.0] forKey:NSFontAttributeName];
    [attrText setValue:pghStyle forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"Transfer_list", nil) attributes:attrText];
    [_topLeftBtn setAttributedTitle:attrString];
    

    
    [_limitView setBackgroundColor:COLOR_PURCHASE_COLUMN_BG];
    
    [_topRightBtn setHasBorder:NO];
    [_topRightBtn setIsLeftRightGridient:YES withLeftNormalBgColor:COLOR_View_NORMAL withRightNormalBgColor:COLOR_View_NORMAL withLeftEnterBgColor:COLOR_View_NORMAL withRightEnterBgColor:COLOR_View_NORMAL withLeftDownBgColor:COLOR_View_NORMAL withRightDownBgColor:COLOR_View_NORMAL withLeftForbiddenBgColor:COLOR_View_NORMAL withRightForbiddenBgColor:COLOR_View_NORMAL];
    [_topRightBtn setButtonTitle:CustomLocalizedString(@"Transfer_ClearAll", nil) withNormalTitleColor:COLOR_TEXT_EXPLAIN withEnterTitleColor:COLOR_TEXT_PASSAFTER withDownTitleColor:COLOR_TEXT_CLICK withForbiddenTitleColor:COLOR_TEXT_EXPLAIN withTitleSize:12 WithLightAnimation:NO];
    
    [_historyBtn setHasBorder:NO];
    [_historyBtn setIsLeftRightGridient:YES withLeftNormalBgColor:COLOR_View_NORMAL withRightNormalBgColor:COLOR_View_NORMAL withLeftEnterBgColor:COLOR_View_NORMAL withRightEnterBgColor:COLOR_View_NORMAL withLeftDownBgColor:COLOR_View_NORMAL withRightDownBgColor:COLOR_View_NORMAL withLeftForbiddenBgColor:COLOR_View_NORMAL withRightForbiddenBgColor:COLOR_View_NORMAL];
    [_historyBtn setButtonTitle:CustomLocalizedString(@"Transfer_History", nil) withNormalTitleColor:COLOR_TEXT_EXPLAIN withEnterTitleColor:COLOR_TEXT_PASSAFTER withDownTitleColor:COLOR_TEXT_CLICK withForbiddenTitleColor:COLOR_TEXT_EXPLAIN withTitleSize:14 WithLightAnimation:NO];
    
    [_unlimitBtn setHasBorder:NO];
    [_unlimitBtn setAlignment:NSCenterTextAlignment];
    
    [_unlimitBtn setIsLeftRightGridient:YES withLeftNormalBgColor:COLOR_PURCHASE_COLUMN_BG withRightNormalBgColor:COLOR_PURCHASE_COLUMN_BG withLeftEnterBgColor:COLOR_PURCHASE_COLUMN_BG withRightEnterBgColor:COLOR_PURCHASE_COLUMN_BG withLeftDownBgColor:COLOR_PURCHASE_COLUMN_BG withRightDownBgColor:COLOR_PURCHASE_COLUMN_BG withLeftForbiddenBgColor:COLOR_PURCHASE_COLUMN_BG withRightForbiddenBgColor:COLOR_PURCHASE_COLUMN_BG];
    [_unlimitBtn setButtonTitle:CustomLocalizedString(@"Purchase_unlimit_btn_title", nil) withNormalTitleColor:COLOR_TEXT_PASSAFTER withEnterTitleColor:COLOR_TEXT_PASSAFTER withDownTitleColor:COLOR_TEXT_PASSAFTER withForbiddenTitleColor:COLOR_TEXT_PASSAFTER withTitleSize:14 WithLightAnimation:NO];
    
    [_topBoxs setContentView:_topView];
    [_bottomBoxs setContentView:_bottomView];
    [_limitBox setContentView:_limitView];
    
    [_topBottomLine setBackgroundColor:COLOR_TEXT_LINE];
    [_bottomLineView setBorderColor:COLOR_TEXT_LINE];
    [_completeBottomViewTopLine setBackgroundColor:COLOR_TEXT_LINE];
    
    if (_downLoadViewController&&![_downLoadViewController.view superview]) {
        [_boxView setContentView:_downLoadViewController.view];
    }else {
        _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
        [_downLoadViewController setDelagete:self];
        [_downLoadViewController transferBtn:_tranferBtn];
        [_boxView setContentView:_downLoadViewController.view];
    }
    [_bottomLineView setBackgroundColor:COLOR_TEXT_LINE];
    
    _isDownLoadView = YES;
    [_deleteAllBtn mouseDownImage:[NSImage imageNamed:@"transferlist_icon_delall_hover"] withMouseUpImg:[NSImage imageNamed:@"transferlist_icon_delall"]  withMouseExitedImg:[StringHelper imageNamed:@"transferlist_icon_delall"]  mouseEnterImg:[NSImage imageNamed:@"transferlist_icon_delall_hover"]  withButtonName:@""];
    
    [_closeCompleteView mouseDownImage:[NSImage imageNamed:@"transferlist_history_icon_close_hover"] withMouseUpImg:[StringHelper imageNamed:@"transferlist_history_icon_close"]  withMouseExitedImg:[NSImage imageNamed:@"transferlist_history_icon_close"]  mouseEnterImg:[NSImage imageNamed:@"transferlist_history_icon_close_hover"]  withButtonName:@""];
    
    [_removeAllCompleDataBtn WithMouseExitedfillColor:COLOR_BOTTN_Exited_COLOR WithMouseUpfillColor:COLOR_BOTTN_Exited_COLOR WithMouseDownfillColor:COLOR_BOTTN_Down_COLOR withMouseEnteredfillColor:COLOR_BOTTN_Down_COLOR];
    [_removeAllCompleDataBtn WithMouseExitedLineColor:[NSColor clearColor] WithMouseUpLineColor:[NSColor clearColor] WithMouseDownLineColor:[NSColor clearColor] withMouseEnteredLineColor:[NSColor clearColor]];
    [_removeAllCompleDataBtn WithMouseExitedtextColor:[NSColor whiteColor] WithMouseUptextColor:[NSColor whiteColor] WithMouseDowntextColor:[NSColor whiteColor] withMouseEnteredtextColor:[NSColor whiteColor]];
    [_removeAllCompleDataBtn setTitleName:CustomLocalizedString(@"Clearall", nil) WithDarwRoundRect:4 WithLineWidth:0 withFont:[NSFont fontWithName:IMBCommonFont size:14]];
    [self.view setWantsLayer:YES];
    [self.view.layer setMasksToBounds:YES];
    [self.view.layer setCornerRadius:5];
    
    _titleLabel.textColor = COLOR_PURCHASE_TITLE_TEXT;
    _titleLabel.font = [NSFont fontWithName:IMBCommonFont size:14.f];
    
    _titleLabel.stringValue = CustomLocalizedString(@"Purchase_left_num_tips", nil);
    
    
    _firstLabel.leftStirngEnum = IMBPurcahseLeftNumLabelLeftStringToMac;
    _firstLabel.leftNum = [[IMBLimitation sharedLimitation] leftToMacNums];
    
    _secondLabel.leftStirngEnum = IMBPurcahseLeftNumLabelLeftStringToDevice;
    _secondLabel.leftNum = [[IMBLimitation sharedLimitation] leftToDeviceNums];
    
    _thirdLabel.leftStirngEnum = IMBPurcahseLeftNumLabelLeftStringToCloud;
    _thirdLabel.leftNum = [[IMBLimitation sharedLimitation] leftToCloudNums];
   
}

- (void)setLimitViewShowing:(BOOL)showing {
    if (showing) {
        _limitBoxH.constant = 140;
        _limitView.hidden = NO;
    }else {
        _limitBoxH.constant = 0;
        _limitView.hidden = YES;
    }
    
}

- (void)addKeyAnimation {
    _keyImageView.layer.anchorPoint = NSMakePoint(0.5, 0.5);
    _keyImageView.wantsLayer = YES;
    
    [IMBViewAnimation animationMouseEnteredExitedWithView:_keyImageView frame:NSMakeRect(307.f, 107.f, 16.f, 16.f) timeInterval:2.f disable:NO completion:^{
        _keyImageView.frame = NSMakeRect(307.f, 107.f, 16.f, 16.f);
        _keyImageView.hidden = NO;
        [_limitView addSubview:_keyImageView];
    }];
}

- (void)reparinitialization {
    [_topBoxs setContentView:_topView];
    [_bottomBoxs setContentView:_bottomView];
    if (_downLoadViewController) {
        [_boxView setContentView:_downLoadViewController.view];
    }
}

- (void)loadView {
    [super loadView];
    [self.view setWantsLayer:YES];
    [self.view.layer setMasksToBounds:YES];
    [self.view.layer setCornerRadius:5];
    _allHistoryArray = [[NSMutableArray alloc]init];
    sqlite3 *dbPoint;
    sqlite3_stmt *stmt=nil;
    NSString *tempPath = [TempHelper getAppiMobieConfigPath];
    NSString *documentPath= [tempPath stringByAppendingPathComponent:@"FileHistory.sqlite"];
    sqlite3_open([documentPath UTF8String], &dbPoint);
    NSString *sldsf = @"create table \"main\".\"FileHistory\" (\"history_id\" integer primary key autoincrement not null, \"transfer_name\" text,\"transfer_exportPath\" text,\"transfer_time\" text,\"transfer_size\" integer, \"transfer_status\" integer, \"transfer_isdown\" integer, \"transfer_id\" text,\"transfer_isfolder\" integer);";
//      return  @"create table \"main\".\"FileHistory\" (\"history_id\" integer primary key autoincrement not null, \"transfer_name\" text,\"transfer_exportPath\" text,\"transfer_time\" text,\"transfer_size\" integer, \"transfer_status\" integer, \"transfer_isdown\" integer, \"transfer_id\" text,\"transfer_isfolder\" integer);";
    
    sqlite3_exec(dbPoint, [sldsf UTF8String], nil, nil, nil);
    NSString *sqlStr=@"select * from FileHistory";
    sqlite3_prepare_v2(dbPoint, [sqlStr UTF8String], -1, &stmt, nil);
    while (sqlite3_step(stmt)==SQLITE_ROW) {
        DriveItem *driveItem = [[DriveItem alloc]init];
        const unsigned char *name =sqlite3_column_text(stmt, 1);
        NSString *stuName =[NSString stringWithUTF8String:(const char *)name];
        driveItem.fileName = stuName;
        const unsigned char *path =sqlite3_column_text(stmt, 2);
        NSString *filePath=[NSString stringWithUTF8String:(const char *)path];
        driveItem.localPath = filePath;
        const unsigned char *time=sqlite3_column_text(stmt, 3);
        NSString *fileTime =[NSString stringWithUTF8String:(const char *)time];
        driveItem.completeDate = fileTime;
        
        int folder = sqlite3_column_int(stmt, 8);
        driveItem.isFolder = folder;
        
        NSString *extension = [driveItem.fileName pathExtension];
        if (![StringHelper stringIsNilOrEmpty:extension]) {
            extension = [extension lowercaseString];
        }
        if (folder) {
            driveItem.photoImage = [NSImage imageNamed:@"transferlist_history_icon_list_folder"];

        }else {
            driveItem.photoImage = [[TempHelper loadTransferFileImage:extension] retain];
        }
        
        
        int size =sqlite3_column_int(stmt, 4);
        driveItem.fileSize = size;
        int state =sqlite3_column_int(stmt, 5);
        int isdown =sqlite3_column_int(stmt, 6);
        if (state&&isdown) {
            driveItem.state = DownloadStateComplete;
        }else if (state&&!isdown) {
            driveItem.state = UploadStateComplete;
        }else if (!state&&isdown){
            driveItem.state = DownloadStateError;
        }else if (!state&&!isdown){
            driveItem.state = UploadStateError;
        }
        const unsigned char *idtext=sqlite3_column_text(stmt, 7);
        NSString *fileId =[NSString stringWithUTF8String:(const char *)idtext];
        driveItem.docwsID = fileId;
        [_allHistoryArray addObject:driveItem];
    }
}

#pragma mark - loadData
- (void)icloudDriveAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent withUploadDocID:(NSString *) docID{
    _chooseLoginModelEnum = iCloudLogEnum;
    if (isDown) {
         [self downLoadBtn:nil];
        if (!_downLoadViewController) {
            _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_downLoadViewController setDelagete:self];
            [_downLoadViewController transferBtn:_tranferBtn];
        }
        [_boxView setContentView:_downLoadViewController.view];
        [_downLoadViewController icloudDriveAddDataSource:addDataSource WithIsDown:isDown WithDriveBaseManage:driveBaseManage withUploadParent:uploadParent withUploadDocID:docID];
       
    }else {
        [self upLoadBtn:nil];
        if (!_downLoadViewController) {
            _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_downLoadViewController setDelagete:self];
            [_downLoadViewController transferBtn:_tranferBtn];
        }
        [_boxView setContentView:_downLoadViewController.view];
        [_downLoadViewController icloudDriveAddDataSource:addDataSource WithIsDown:isDown WithDriveBaseManage:driveBaseManage withUploadParent:uploadParent withUploadDocID:docID];
    }
}

- (void)icloudToDriveAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent withUploadDocID:(NSString *) docID withiPod:(IMBiPod *)ipod{
    _chooseLoginModelEnum = iCloudLogEnum;
    [self downLoadBtn:nil];
    if (!_downLoadViewController) {
        _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
        [_downLoadViewController setDelagete:self];
        [_downLoadViewController transferBtn:_tranferBtn];
    }
    [_boxView setContentView:_downLoadViewController.view];
    [_downLoadViewController icloudToDriveAddDataSource:addDataSource WithIsDown:isDown WithDriveBaseManage:driveBaseManage withUploadParent:uploadParent withUploadDocID:docID withiPod:ipod];

}

- (void)dropBoxAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent{
    _chooseLoginModelEnum = DropBoxLogEnum;
    if (isDown) {
        if (!_downLoadViewController) {
            _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_downLoadViewController setDelagete:self];
            [_downLoadViewController transferBtn:_tranferBtn];
            [_boxView setContentView:_downLoadViewController.view];
        }
        [_downLoadViewController dropBoxAddDataSource:addDataSource WithIsDown:isDown WithDriveBaseManage:driveBaseManage withUploadParent:uploadParent];
           [self downLoadBtn:nil];
    }else {
        
        if (!_downLoadViewController) {
            _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_downLoadViewController setDelagete:self];
            [_downLoadViewController transferBtn:_tranferBtn];
            
        }
        [_downLoadViewController dropBoxAddDataSource:addDataSource WithIsDown:isDown WithDriveBaseManage:driveBaseManage withUploadParent:uploadParent];
        [_boxView setContentView:_downLoadViewController.view];
        [self upLoadBtn:nil];
    }
}

- (void)dropBoxToDeviceAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent  withiPod:(IMBiPod *)ipod{
    _chooseLoginModelEnum = DropBoxLogEnum;
    if (!_downLoadViewController) {
        _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
        [_downLoadViewController setDelagete:self];
        [_downLoadViewController transferBtn:_tranferBtn];
        [_boxView setContentView:_downLoadViewController.view];
    }
//    [_downLoadViewController dropBoxToDeviceAddDataSource:addDataSource WithIsDown:isDown WithDriveBaseManage:driveBaseManage withUploadParent:uploadParent];
    [_downLoadViewController dropBoxToDeviceAddDataSource:addDataSource WithIsDown:isDown WithDriveBaseManage:driveBaseManage withUploadParent:uploadParent withiPod:ipod];

    [self downLoadBtn:nil];
}

- (void)deviceAddDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum isExportPath:(NSString *) exportPath withSystemPath:(NSString *)systemPath{
    _categoryNodesEnum = categoryNodesEnum;
    _chooseLoginModelEnum = DeviceLogEnum;
    if (isDown) {
        if (!_downLoadViewController) {
            _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_downLoadViewController setDelagete:self];
            [_downLoadViewController transferBtn:_tranferBtn];
            [_boxView setContentView:_downLoadViewController.view];
            //                [_downLoadViewController setDeviceManager:_driveBaseManage];
        }
        [_downLoadViewController setAppKey:_appKey];
        [_downLoadViewController deviceAddDataSoure:addDataSource WithIsDown:isDown WithiPod:ipod withCategoryNodesEnum:categoryNodesEnum isExportPath:exportPath withSystemPath:systemPath];
    }else {
        if (!_downLoadViewController) {
            _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_downLoadViewController setDelagete:self];
            [_downLoadViewController setAppKey:_appKey];
            [_downLoadViewController transferBtn:_tranferBtn];
            [_boxView setContentView:_downLoadViewController.view];
        }
        [_downLoadViewController deviceAddDataSoure:addDataSource WithIsDown:isDown WithiPod:ipod withCategoryNodesEnum:categoryNodesEnum isExportPath:exportPath withSystemPath:systemPath];
    }
}

- (void)downDeviceDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum isExportPath:(NSString *) exportPath withSystemPath:(NSString *)systemPath{
    if (!_downLoadViewController) {
        _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
        [_downLoadViewController setDelagete:self];
        [_downLoadViewController transferBtn:_tranferBtn];
        [_boxView setContentView:_downLoadViewController.view];
    }
    [_downLoadViewController setAppKey:_appKey];
    [_downLoadViewController downDeviceDataSoure:addDataSource WithIsDown:isDown WithiPod:ipod withCategoryNodesEnum:categoryNodesEnum isExportPath:exportPath withSystemPath:systemPath];
}

- (void)toDeviceAddDataSorue:(NSMutableArray *)addDataSource withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum srciPodKey:(NSString *)srcIpodKey desiPodKey:(NSString *)desiPodKey {
    if (!_downLoadViewController) {
        _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
        [_downLoadViewController setDelagete:self];
        [_downLoadViewController transferBtn:_tranferBtn];
        [_boxView setContentView:_downLoadViewController.view];
    }
    [_downLoadViewController toDeviceAddDataSorue:addDataSource withCategoryNodesEnum:categoryNodesEnum srciPodKey:srcIpodKey desiPodKey:desiPodKey];
}


#pragma mark - operation action
- (IBAction)unlimitClicked:(id)sender {
    if (self.unlimitClicked) {
        self.unlimitClicked();
    }
    
}

- (IBAction)upLoadBtn:(id)sender {
    _isDownLoadView = NO;
    
    if (!_downLoadViewController) {
        _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
        [_downLoadViewController setDelagete:self];
        [_downLoadViewController transferBtn:_tranferBtn];
    }
    [_boxView setContentView:_downLoadViewController.view];
    [_downLoadViewController icloudDriveAddDataSource:nil WithIsDown:NO WithDriveBaseManage:nil withUploadParent:nil withUploadDocID:nil];
}

- (IBAction)downLoadBtn:(id)sender {
    _isDownLoadView = YES;
    if (!_downLoadViewController) {
        _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
        [_downLoadViewController setDelagete:self];
        [_downLoadViewController transferBtn:_tranferBtn];
    }
    [_boxView setContentView:_downLoadViewController.view];
}

- (IBAction)removeAllDataBtnDown:(id)sender {
    if (_downLoadViewController) {
        [_downLoadViewController removeAllUpOrDownData];
        NSDictionary *dimensionDict = nil;
        if ([_showWindowDelegate chooseModelEnum] == iCloudLogEnum) {
            @autoreleasepool {
                [TempHelper customViewType:[_showWindowDelegate chooseModelEnum] withCategoryEnum:[_reloadDelegate categoryNodeEunm]];
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:CiCloud action:AClearRecord label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if ([_showWindowDelegate chooseModelEnum] == DropBoxLogEnum) {
            @autoreleasepool {
                [TempHelper customViewType:[_showWindowDelegate chooseModelEnum] withCategoryEnum:[_reloadDelegate categoryNodeEunm]];
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:CDropbox action:AClearRecord label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else {
            @autoreleasepool {
                [TempHelper customViewType:[_showWindowDelegate chooseModelEnum] withCategoryEnum:[_reloadDelegate categoryNodeEunm]];
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:CDevice action:AClearRecord label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    }
}

- (IBAction)removeAllCompleteDataBtnDown:(id)sender {
    [_tranferCompleteViewController removeAllData];
}

- (IBAction)showHistoryBtnDown:(id)sender {
    
    _limitBoxH.constant = 0;
    _limitView.hidden = YES;
    
    NSDictionary *dimensionDict = nil;
    if ([_showWindowDelegate chooseModelEnum] == iCloudLogEnum) {
        @autoreleasepool {
            [TempHelper customViewType:[_showWindowDelegate chooseModelEnum] withCategoryEnum:[_reloadDelegate categoryNodeEunm]];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:CiCloud action:AViewRecord label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }else if ([_showWindowDelegate chooseModelEnum] == DropBoxLogEnum) {
        @autoreleasepool {
            [TempHelper customViewType:[_showWindowDelegate chooseModelEnum] withCategoryEnum:[_reloadDelegate categoryNodeEunm]];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:CDropbox action:AViewRecord label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }else {
        @autoreleasepool {
            [TempHelper customViewType:[_showWindowDelegate chooseModelEnum] withCategoryEnum:[_reloadDelegate categoryNodeEunm]];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:CDevice action:AViewRecord label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSRect startFrame = [self.view frame];
    [_showWindowDelegate setIsShowCompletView:YES];
    
    [_topBoxs setContentView:_topCompletVIew];
    [_bottomBoxs setContentView:_bottomCompleteView];
    [self.view setWantsLayer:YES];
    if (!_tranferCompleteViewController) {
        _tranferCompleteViewController = [[IMBTranferShowCompleteViewController alloc]initWithNibName:@"IMBTranferShowCompleteViewController" bundle:nil];
        [_tranferCompleteViewController setDelegate:self];
    }
    //    [_tranferCompleteViewController.view setFrame:NSMakeRect(-8, -8, 1104, 606)];
    [_boxView setContentView:_tranferCompleteViewController.view];
    [_tranferCompleteViewController addDataAry:_allHistoryArray];
    NSRect endFrame = NSMakeRect(-4, -5, 1104, 606);
       NSMutableArray *animations = [NSMutableArray array];
    NSMutableDictionary *viewDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [viewDict setObject:self.view forKey:NSViewAnimationTargetKey];
    //set original frame of the view
    [viewDict setObject:[NSValue valueWithRect:startFrame] forKey:NSViewAnimationStartFrameKey];
    [viewDict setObject:[NSValue valueWithRect:endFrame] forKey:NSViewAnimationEndFrameKey];
    [animations addObject:viewDict];
    NSViewAnimation *theAnim = [[NSViewAnimation alloc] initWithViewAnimations:animations];
    // set time interval of the animation
    [theAnim setDuration:0.5];    // .
    [theAnim setAnimationCurve:NSAnimationEaseIn];
    [theAnim startAnimation];
    [theAnim release];
    theAnim = nil;
    
    
    [_boxView setNeedsDisplay:YES];
}

- (IBAction)closeCompleteView:(id)sender {
    [_showWindowDelegate setIsShowCompletView:NO];
    [_showWindowDelegate closeCompteleTranferView];
    if (_isDownLoadView) {
        [_boxView setContentView:_downLoadViewController.view];
    }else {
        [_boxView setContentView:_downLoadViewController.view];
    }
}

- (void)transferBtn:(IMBHoverChangeImageBtn *)transferBtn {
    _tranferBtn = transferBtn;
}

- (void)loadCompleteData:(DriveItem *) driveItem{
    [_allHistoryArray insertObject:driveItem atIndex:0];
    if (_tranferCompleteViewController){
        [_tranferCompleteViewController addDataAry:_allHistoryArray];
    }
}

- (void)removeAllHistoryAry {
    NSDictionary *dimensionDict = nil;
    if ([_showWindowDelegate chooseModelEnum] == iCloudLogEnum) {
        @autoreleasepool {
            [TempHelper customViewType:[_showWindowDelegate chooseModelEnum] withCategoryEnum:[_reloadDelegate categoryNodeEunm]];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:CiCloud action:AClearAll label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }else if ([_showWindowDelegate chooseModelEnum] == DropBoxLogEnum) {
        @autoreleasepool {
            [TempHelper customViewType:[_showWindowDelegate chooseModelEnum] withCategoryEnum:[_reloadDelegate categoryNodeEunm]];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:CDropbox action:AClearAll label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }else {
        @autoreleasepool {
            [TempHelper customViewType:[_showWindowDelegate chooseModelEnum] withCategoryEnum:[_reloadDelegate categoryNodeEunm]];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:CDevice action:AClearAll label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [_allHistoryArray removeAllObjects];
}

- (void)removeCompletData:(DriveItem *) driveItem WithIsRemoveAllData:(BOOL) isRemoveAllData {
    if (isRemoveAllData) {
        [_allHistoryArray removeAllObjects];
    }else {
        [_allHistoryArray removeObject:driveItem];
    }
}

- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
    if (_reloadDelegate &&[_reloadDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_reloadDelegate transferComplete:successCount TotalCount:totalCount];
    }
}


-(void)dealloc  {
    [_allHistoryArray release],_allHistoryArray = nil;
    [_driveBaseManage release],_driveBaseManage = nil;
    [super dealloc];
}

@end
