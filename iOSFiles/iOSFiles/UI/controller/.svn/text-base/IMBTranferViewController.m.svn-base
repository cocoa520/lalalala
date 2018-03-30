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
@class IMBTranferViewController;
static id _instance = nil;
@interface IMBTranferViewController ()

@end

@implementation IMBTranferViewController
@synthesize driveBaseManage = _driveBaseManage;
@synthesize selectedAry = _selectedAry;
@synthesize deviceExportPath = _deviceExportPath;
@synthesize delegate = _delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
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
//    [_topLeftBtn setTitle:CustomLocalizedString(@"TransferUploading", nil)];
//    [_topRightBtn setTitle:CustomLocalizedString(@"TransferDownloading", nil)];
//    [_topLeftBtn setStringValue:CustomLocalizedString(@"TransferUploading", nil)];
//    [_topRightBtn setStringValue:CustomLocalizedString(@"TransferDownloading", nil)];
    NSMutableParagraphStyle *pghStyle = [[NSMutableParagraphStyle alloc] init];
    pghStyle.alignment = NSTextAlignmentCenter;
    NSMutableDictionary *attrText = [[NSMutableDictionary alloc] init];
    [attrText setValue:COLOR_TEXT_ORDINARY forKey:NSForegroundColorAttributeName];
    [attrText setValue:[NSFont fontWithName:IMBCommonFont size:14.0] forKey:NSFontAttributeName];
    [attrText setValue:pghStyle forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"TransferUploading", nil) attributes:attrText];
    [_topLeftBtn setAttributedTitle:attrString];
    
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:CustomLocalizedString(@"TransferDownloading", nil) attributes:attrText];
    [_topRightBtn setAttributedTitle:attrString2];
    [_topBoxs setContentView:_topView];
    [_bottomBoxs setContentView:_bottomView];
    
    [_topBottomLine setBackgroundColor:COLOR_TEXT_LINE];
    [_bottomLineView setBorderColor:COLOR_TEXT_LINE];
    [_topLeftLine setBackgroundColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT];
    [_completeBottomViewTopLine setBackgroundColor:COLOR_TEXT_LINE];
    [_topLeftLine setHidden:YES];
    [_topRightLine setBackgroundColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT];
    if (_downLoadViewController&&![_downLoadViewController.view superview]) {
        [_boxView setContentView:_downLoadViewController.view];
    }else {
        _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
        [_downLoadViewController setDelagete:self];
        [_boxView setContentView:_downLoadViewController.view];
    }
    [_bottomLineView setBackgroundColor:COLOR_TEXT_LINE];
    
    _isDownLoadView = YES;
    [_deleteAllBtn mouseDownImage:[NSImage imageNamed:@"transferlist_icon_delall_hover"] withMouseUpImg:[NSImage imageNamed:@"transferlist_icon_delall"]  withMouseExitedImg:[StringHelper imageNamed:@"transferlist_icon_delall"]  mouseEnterImg:[NSImage imageNamed:@"transferlist_icon_delall_hover"]  withButtonName:@""];
    [_historyBtn mouseDownImage:[NSImage imageNamed:@"transferlist_icon_history_hover"] withMouseUpImg:[StringHelper imageNamed:@"transferlist_icon_history"]  withMouseExitedImg:[NSImage imageNamed:@"transferlist_icon_history"]  mouseEnterImg:[NSImage imageNamed:@"transferlist_icon_history_hover"]  withButtonName:@""];
    [_closeCompleteView mouseDownImage:[NSImage imageNamed:@"transferlist_history_icon_close_hover"] withMouseUpImg:[StringHelper imageNamed:@"transferlist_history_icon_close"]  withMouseExitedImg:[NSImage imageNamed:@"transferlist_history_icon_close"]  mouseEnterImg:[NSImage imageNamed:@"transferlist_history_icon_close_hover"]  withButtonName:@""];
    
    [_removeAllCompleDataBtn WithMouseExitedfillColor:COLOR_BOTTN_Exited_COLOR WithMouseUpfillColor:COLOR_BOTTN_Exited_COLOR WithMouseDownfillColor:COLOR_BOTTN_Down_COLOR withMouseEnteredfillColor:COLOR_BOTTN_Down_COLOR];
    [_removeAllCompleDataBtn WithMouseExitedLineColor:[NSColor clearColor] WithMouseUpLineColor:[NSColor clearColor] WithMouseDownLineColor:[NSColor clearColor] withMouseEnteredLineColor:[NSColor clearColor]];
    [_removeAllCompleDataBtn WithMouseExitedtextColor:[NSColor whiteColor] WithMouseUptextColor:[NSColor whiteColor] WithMouseDowntextColor:[NSColor whiteColor] withMouseEnteredtextColor:[NSColor whiteColor]];
    [_removeAllCompleDataBtn setTitleName:@"Clear All" WithDarwRoundRect:4 WithLineWidth:0 withFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
    [self.view setWantsLayer:YES];
    [self.view.layer setMasksToBounds:YES];
    [self.view.layer setCornerRadius:5];
   
}

- (void)reparinitialization {
    [_topBoxs setContentView:_topView];
    [_bottomBoxs setContentView:_bottomView];
    if (_isDownLoadView){
        if (_downLoadViewController) {
            [_boxView setContentView:_downLoadViewController.view];
        }
    }else {
        if (_upLoadViewController) {
            [_boxView setContentView:_upLoadViewController.view];
        }
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
        FileTypeEnum type = [StringHelper getFileFormatWithExtension:extension];
        NSImage *image;
        if (folder) {
            image = [NSImage imageNamed:@"mac_cnt_fileicon_myfile"];
        }else{
            if (type == ImageFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_img"];
            } else if (type == MusicFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_music"];
            } else if (type == MovieFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_video"];
            } else if (type == TxtFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_txt"];
            } else if (type == DocFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_doc"];
            } else if (type == BookFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_books"];
            } else if (type == PPtFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_ppt"];
            } else if (type == ZIPFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_zip"];
            } else if (type == dmgFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_dmg"];
            } else if (type == contactFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_contacts"];
            } else if (type == excelFile) {
                image = [NSImage imageNamed:@"cnt_fileicon_excel"];
            } else {
                image = [NSImage imageNamed:@"cnt_fileicon_common"];
            }
        }
        driveItem.photoImage = [image retain];
        
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
- (void)icloudDriveAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent{
    if (isDown) {
         [self downLoadBtn:nil];
        if (!_downLoadViewController) {
            _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_downLoadViewController setDelagete:self];
           
            //                [_downLoadViewController setDeviceManager:_driveBaseManage];
        }
        [_boxView setContentView:_downLoadViewController.view];
        [_downLoadViewController icloudDriveAddDataSource:addDataSource WithIsDown:isDown WithDriveBaseManage:driveBaseManage withUploadParent:uploadParent];
       
    }else {
          [self upLoadBtn:nil];
        if (!_upLoadViewController) {
            _upLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_upLoadViewController setDelagete:self];
        }
        [_boxView setContentView:_upLoadViewController.view];
        [_upLoadViewController icloudDriveAddDataSource:addDataSource WithIsDown:isDown WithDriveBaseManage:driveBaseManage withUploadParent:uploadParent];
    }
}

- (void)dropBoxAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withUploadParent:(NSString *)uploadParent{
    if (isDown) {
        if (!_downLoadViewController) {
            _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_downLoadViewController setDelagete:self];
            [_boxView setContentView:_downLoadViewController.view];
        }
        [_downLoadViewController dropBoxAddDataSource:addDataSource WithIsDown:isDown WithDriveBaseManage:driveBaseManage withUploadParent:uploadParent];
           [self downLoadBtn:nil];
    }else {
        
        if (!_upLoadViewController) {
            _upLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_upLoadViewController setDelagete:self];
            
        }
        [_upLoadViewController dropBoxAddDataSource:addDataSource WithIsDown:isDown WithDriveBaseManage:driveBaseManage withUploadParent:uploadParent];
        [_boxView setContentView:_upLoadViewController.view];
        [self upLoadBtn:nil];
    }
}

- (void)deviceAddDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum isExportPath:(NSString *) exportPath{
    if (isDown) {
        if (!_downLoadViewController) {
            _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_downLoadViewController setDelagete:self];
            [_boxView setContentView:_downLoadViewController.view];
            //                [_downLoadViewController setDeviceManager:_driveBaseManage];
        }
        [_downLoadViewController deviceAddDataSoure:addDataSource WithIsDown:isDown WithiPod:ipod withCategoryNodesEnum:categoryNodesEnum isExportPath:exportPath];
    }else {
        if (!_upLoadViewController) {
            _upLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
            [_upLoadViewController setDelagete:self];
            [_boxView setContentView:_upLoadViewController.view];
        }
        [_upLoadViewController deviceAddDataSoure:addDataSource WithIsDown:isDown WithiPod:ipod withCategoryNodesEnum:categoryNodesEnum isExportPath:exportPath];
    }
}


- (void)loadDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage withSelectedAry:(NSMutableArray *)selectedAry withIsDownItem:(BOOL)isDownItem withiPod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum withIsiCloudDrive:(BOOL)isiCloudDrive{
        _driveBaseManage = [driveBaseManage retain];
        if (isDownItem) {
            if (!_downLoadViewController) {
                _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
                [_boxView setContentView:_downLoadViewController.view];
                [_downLoadViewController setDelagete:self];
//                [_downLoadViewController setDeviceManager:_driveBaseManage];
            }
            if (isiCloudDrive) {
                [_downLoadViewController addDataSource:selectedAry withIsDown:isDownItem withCategoryNodesEnum:categoryNodesEnum withipod:nil withIsiCloudDrive:YES];
            }else if (ipod){
                [_downLoadViewController addDataSource:selectedAry withIsDown:isDownItem withCategoryNodesEnum:categoryNodesEnum withipod:ipod withIsiCloudDrive:NO];
                [_downLoadViewController setExportPath:_deviceExportPath];
            }else {
                [_downLoadViewController addDataSource:selectedAry withIsDown:isDownItem withCategoryNodesEnum:categoryNodesEnum withipod:nil withIsiCloudDrive:NO];
            }
        }else{
            if (!_upLoadViewController) {
                _upLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
                [_upLoadViewController setDelagete:self];
                [_boxView setContentView:_upLoadViewController.view];
                [_upLoadViewController setDeviceManager:_driveBaseManage];
            }
            if (isiCloudDrive) {
                [_upLoadViewController addDataSource:selectedAry withIsDown:isDownItem withCategoryNodesEnum:categoryNodesEnum withipod:nil withIsiCloudDrive:YES];
            }else if (ipod){
                [_upLoadViewController addDataSource:selectedAry withIsDown:isDownItem withCategoryNodesEnum:categoryNodesEnum withipod:ipod withIsiCloudDrive:NO];
            }else {
                [_upLoadViewController addDataSource:selectedAry withIsDown:isDownItem withCategoryNodesEnum:categoryNodesEnum withipod:nil withIsiCloudDrive:NO];
            }
        }
}

#pragma mark - operation action

- (IBAction)upLoadBtn:(id)sender {
    _isDownLoadView = NO;
    [_topLeftLine setBackgroundColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT];
    [_topRightLine setHidden:YES];
    [_topLeftLine setHidden:NO];
    
    if (!_upLoadViewController) {
        _upLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
        [_upLoadViewController setDelagete:self];
    }
    [_boxView setContentView:_upLoadViewController.view];
    [_upLoadViewController icloudDriveAddDataSource:nil WithIsDown:NO WithDriveBaseManage:nil withUploadParent:nil];
}

- (IBAction)downLoadBtn:(id)sender {
    _isDownLoadView = YES;
    [_topRightLine setBackgroundColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT];
    [_topLeftLine setHidden:YES];
    [_topRightLine setHidden:NO];
    if (!_downLoadViewController) {
        _downLoadViewController = [[IMBDownloadListViewController alloc] initWithNibName:@"IMBDownloadListViewController" bundle:nil];
        [_downLoadViewController setDelagete:self];
//        [_boxView setContentView:_downLoadViewController.view];
//        [_downLoadViewController setDeviceManager:_driveBaseManage];
    }
    [_boxView setContentView:_downLoadViewController.view];
}

- (IBAction)removeAllDataBtnDown:(id)sender {
    if (_downLoadViewController ) {
        [_downLoadViewController removeAllUpOrDownData];
    }
    if (_upLoadViewController) {
        [_upLoadViewController removeAllUpOrDownData];
    }
}

- (IBAction)removeAllCompleteDataBtnDown:(id)sender {
    [_tranferCompleteViewController removeAllData];
}

- (IBAction)showHistoryBtnDown:(id)sender {
    NSRect startFrame = [self.view frame];
//    - (void)setIsShowCompletView:(BOOL)isShowCompleteView
    [_delegate setIsShowCompletView:YES];
    NSRect endFrame = NSMakeRect(-4, -5, 1104, 606);
//    [self.view setWantsLayer:YES];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:self.view,NSViewAnimationTargetKey,NSViewAnimationFadeInEffect,NSViewAnimationEffectKey,[NSValue valueWithRect:startFrame],NSViewAnimationStartFrameKey,[NSValue valueWithRect:endFrame],NSViewAnimationEndFrameKey,nil];
    NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObject:dictionary]];

    animation.duration = 0.5;
    [animation setAnimationBlockingMode:NSAnimationNonblocking];
    [animation startAnimation];
    [_topBoxs setContentView:_topCompletVIew];
    [_bottomBoxs setContentView:_bottomCompleteView];
    [self.view setWantsLayer:YES];
    [self.view setFrame:endFrame];
    if (!_tranferCompleteViewController) {
        _tranferCompleteViewController = [[IMBTranferShowCompleteViewController alloc]initWithNibName:@"IMBTranferShowCompleteViewController" bundle:nil];
        [_tranferCompleteViewController setDelegate:self];
    }
//    [_tranferCompleteViewController.view setFrame:NSMakeRect(-8, -8, 1104, 606)];
    [_boxView setContentView:_tranferCompleteViewController.view];
    [_tranferCompleteViewController addDataAry:_allHistoryArray];
}

- (IBAction)closeCompleteView:(id)sender {
    [_delegate setIsShowCompletView:NO];
    [_delegate closeCompteleTranferView];
    if (_isDownLoadView) {
        [_boxView setContentView:_downLoadViewController.view];
    }else {
        [_boxView setContentView:_upLoadViewController.view];
    }
}

- (void)loadCompleteData:(DriveItem *) driveItem{
    [_allHistoryArray insertObject:driveItem atIndex:0];
    if (_tranferCompleteViewController){
        [_tranferCompleteViewController addDataAry:_allHistoryArray];
    }
}

- (void)removeAllHistoryAry {
    [_allHistoryArray removeAllObjects];
}

-(void)dealloc  {
    [_allHistoryArray release],_allHistoryArray = nil;
    [_downAry release],_downAry = nil;
    [_upAry release],_upAry = nil;
    [_driveBaseManage release],_driveBaseManage = nil;
    [super dealloc];
}

@end
