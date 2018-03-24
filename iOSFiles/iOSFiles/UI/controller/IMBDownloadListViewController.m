//
//  IMBDownloadListViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBDownloadListViewController.h"
#import "HoverButton.h"
#import "StringHelper.h"
#define TableViewRowWidth 360
#define TableViewRowHight 100
#import "ObjectTableRowView.h"
#import "DownloadCellView.h"
#import "IMBAnimation.h"
#import "IMBNotificationDefine.h"
#define OringinalPropertityX 0
#define OringinalPropertityY 22
#import "IMBAirSyncImportTransfer.h"
#import "SystemHelper.h"
#import "TempHelper.h"
#import "IMBHelper.h"
#import "DriveItem.h"
#import "IMBDriveEntity.h"
#import "IMBTransferModel.h"
#import "IMBPhotoFileExport.h"
#import "IMBPhotoEntity.h"
@interface IMBDownloadListViewController ()

@end

@implementation IMBDownloadListViewController
@synthesize downloadDataSource = _downloadDataSource;
@synthesize deviceManager = _deviceManager;
@synthesize iPod = _iPod;
@synthesize exportPath = _exportPath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)awakeFromNib {
}

- (void)loadView
{
    [super loadView];
    
    successCount = 0;
    _cleanList.font = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
    _cleanList.fontColor = COLOR_BUTTON_SEGDOWN;
    _cleanList.fontEnterColor = COLOR_TEXTCLICK_ENTERCOLOR;
    _cleanList.fontDownColor = COLOR_TEXTCLICK_DOWNCOLOR;
    [_cleanList setTarget:self];
    [_cleanList setAction:@selector(cleanlist:)];
    [_cleanList setTitle:CustomLocalizedString(@"DownLoadCleanTips", nil)];
    _operationQueue = [[NSOperationQueue alloc] init];
    [_operationQueue setMaxConcurrentOperationCount:1];
    HoverButton *closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil((NSHeight(_titleView.frame) - 32)/2), 32, 32)];
    [closebutton setTarget:self];
    [closebutton setAction:@selector(closeWindow:)];
    [closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [closebutton setTag:10];
    [_titleView addSubview:closebutton];
    [_titleView setHasBottomBorder:YES];
    [_titleView setBottomBorderColor:COLOR_LINE_WINDOW];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _downloadDataSource = [[NSMutableArray alloc] init];
    _uploadDataSource = [[NSMutableArray alloc] init];
    //    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_nodataImageView setImage:[StringHelper imageNamed:@"download_nodata"]];
    [_noTipTextField setTextColor:NODATA_NOLIKTITLE_COLOR];
    [_titleTextField setTextColor:COLOR_TEXT_ORDINARY];
    [_noTipTextField setStringValue:CustomLocalizedString(@"downloadpageNoDataTips", nil)];
    
    [self.view setWantsLayer:YES];
    [self.view.layer setMasksToBounds:YES];
    [self.view.layer setCornerRadius:5];
    [_tableView setBackgroundColor:[NSColor clearColor]];
    [_rootBox setContentView:mainBgView];
}

- (void)icloudDriveAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage{
    
    _deviceManager = driveBaseManage ;
    if (isDown) {
        for (IMBDriveEntity *driveEntity in addDataSource) {
//            DriveItem *downloaditem = [[DriveItem alloc] init];
//            downloaditem.itemIDOrPath = driveEntity.fileID;
//            downloaditem.docwsID = driveEntity.docwsid;
//            downloaditem.zone = driveEntity.zone;
//            if (driveEntity.isFolder) {
//                downloaditem.isFolder = YES;
//                downloaditem.fileName = driveEntity.fileName;
//            }else {
//                downloaditem.isFolder = NO;
//                if (![StringHelper stringIsNilOrEmpty:driveEntity.extension]) {
//                    downloaditem.fileName = [[driveEntity.fileName stringByAppendingString:@"."] stringByAppendingString:driveEntity.extension];
//                }
//            }
//            
            
//            for (IMBDriveEntity *driveEntity in preparedArray) {
                DriveItem *downloaditem = [[DriveItem alloc] init];
                downloaditem.itemIDOrPath = driveEntity.fileID;
                downloaditem.docwsID = driveEntity.docwsid;
                downloaditem.zone = driveEntity.zone;
                downloaditem.isStart = YES;
                if (driveEntity.isFolder) {
                    downloaditem.isFolder = YES;
                    downloaditem.fileName = driveEntity.fileName;
                }else {
                    downloaditem.isFolder = NO;
                    if (driveEntity.extension){
                     downloaditem.fileName = [[driveEntity.fileName stringByAppendingString:@"."] stringByAppendingString:driveEntity.extension];
                    }else {
                        downloaditem.fileName = driveEntity.fileName;
                    }
                   
                }
             [_downloadDataSource insertObject:downloaditem atIndex:0];
                [downloaditem release];
                downloaditem = nil;

        }
        [_deviceManager driveDownloadItemsToMac:_downloadDataSource];
    }else {
    
    }
    [self reloadData:YES];
}

- (void)dropBoxAddDataSource:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithDriveBaseManage:(IMBDriveBaseManage *)driveBaseManage{
    _deviceManager = [driveBaseManage retain];
    if (isDown) {
        
    }else {
    
    }
    [self reloadData:YES];
}

- (void)deviceAddDataSoure:(NSMutableArray *)addDataSource WithIsDown:(BOOL)isDown WithiPod:(IMBiPod *) ipod withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum{
    if (isDown) {
        if (categoryNodesEnum == Category_CameraRoll || categoryNodesEnum == Category_PhotoStream || categoryNodesEnum == Category_PhotoLibrary) {
            for (id driveEntity in addDataSource) {
                DriveItem *downloaditem = [[DriveItem alloc] init];
                if ([driveEntity isKindOfClass:[IMBPhotoEntity class]]) {
                    IMBPhotoEntity *photoEntity = (IMBPhotoEntity *)driveEntity;
                    downloaditem.fileName = photoEntity.photoName;
                    downloaditem.isStart = YES;
                    [_uploadDataSource addObject:downloaditem];
                }else{
                    downloaditem.fileName = @"111111";
                    downloaditem.isStart = YES;
                    downloaditem.dataAry = [driveEntity retain];
                    [_downloadDataSource addObject:downloaditem];
                }
                [downloaditem release];
                downloaditem = nil;
            }
            
            IMBPhotoFileExport *baseTransfer = [[IMBPhotoFileExport alloc] initWithIPodkey:ipod.uniqueKey exportTracks:_uploadDataSource exportFolder:_exportPath withDelegate:self];
            [(IMBPhotoFileExport *)baseTransfer setExportType:1];
            [baseTransfer startTransfer];
        }
    }else {
    
    }
    [self reloadData:YES];
}

- (void)addDataSource:(NSMutableArray *)addDataSource withIsDown:(BOOL)isdown withCategoryNodesEnum:(CategoryNodesEnum)categoryNodesEnum withipod:(IMBiPod *)ipod withIsiCloudDrive:(BOOL) isiCloudDrive
{
    if (isdown) {
        _downCount ++;
        if (isiCloudDrive) {
            for (IMBDriveEntity *driveEntity in addDataSource) {
                DriveItem *downloaditem = [[DriveItem alloc] init];
                downloaditem.itemIDOrPath = driveEntity.fileID;
                downloaditem.docwsID = driveEntity.docwsid;
                downloaditem.zone = driveEntity.zone;
                if (driveEntity.isFolder) {
                    downloaditem.isFolder = YES;
                    downloaditem.fileName = driveEntity.fileName;
                }else {
                    downloaditem.isFolder = NO;
                    if (![StringHelper stringIsNilOrEmpty:driveEntity.extension]) {
                        downloaditem.fileName = [[driveEntity.fileName stringByAppendingString:@"."] stringByAppendingString:driveEntity.extension];
                    }
                }
                [_downloadDataSource addObject:downloaditem];
                [downloaditem release];
                downloaditem = nil;
            }
            [_deviceManager driveDownloadItemsToMac:_downloadDataSource];
        }else if (ipod) {
        
        }else {
        
        }
    }else {
        _upCount ++;
        if (isiCloudDrive) {
//            IMBTransferModel *transferModel = [[IMBTransferModel alloc] init];
//            transferModel.dataAry = [addDataSource retain];
//            transferModel.uniqueKey = _iPod.uniqueKey;
        }else if (ipod) {
            if (categoryNodesEnum == Category_CameraRoll || categoryNodesEnum == Category_PhotoStream || categoryNodesEnum == Category_PhotoLibrary) {
                for (id driveEntity in addDataSource) {
                    DriveItem *downloaditem = [[DriveItem alloc] init];
                    if ([driveEntity isKindOfClass:[IMBPhotoEntity class]]) {
                        IMBPhotoEntity *photoEntity = (IMBPhotoEntity *)driveEntity;
                        downloaditem.fileName = photoEntity.photoName;
                        downloaditem.isStart = YES;
                        [_uploadDataSource addObject:downloaditem];
                    }else{
                        downloaditem.fileName = @"111111";
                        downloaditem.isStart = YES;
                        downloaditem.dataAry = [driveEntity retain];
                        [_uploadDataSource addObject:downloaditem];
                    }
                    [downloaditem release];
                    downloaditem = nil;
                }

                IMBPhotoFileExport *baseTransfer = [[IMBPhotoFileExport alloc] initWithIPodkey:ipod.uniqueKey exportTracks:_uploadDataSource exportFolder:_exportPath withDelegate:self];
                [(IMBPhotoFileExport *)baseTransfer setExportType:1];
                [baseTransfer startTransfer];
            }
        }else {
            
        }
    }
    //    for (IMBDriveEntity *driveEntity in addDataSource) {
//        DriveItem *downloaditem = [[DriveItem alloc] init];
//        downloaditem.itemIDOrPath = driveEntity.fileID;
//        downloaditem.docwsID = driveEntity.docwsid;
//        downloaditem.zone = driveEntity.zone;
//        if (driveEntity.isFolder) {
//            downloaditem.isFolder = YES;
//            downloaditem.fileName = driveEntity.fileName;
//        }else {
//            downloaditem.isFolder = NO;
//            downloaditem.fileName = driveEntity.fileName;
//        }
//        [_downloadDataSource insertObject:downloaditem atIndex:0];
//        [downloaditem release];
//        downloaditem = nil;
//    }
  
    [self reloadData:YES];
}

- (void)reloadData:(BOOL)isAdd
{
    [_cleanList setTitle:CustomLocalizedString(@"DownLoadCleanTips", nil)];
    [_cleanList setFrameOrigin:NSMakePoint(NSWidth(_cleanList.superview.frame) - NSWidth(_cleanList.frame), NSMinY(_cleanList.frame))];
    if ([_downloadDataSource count] <= 1) {
        [_titleTextField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"DownloadListPageBtnCountTip", nil),[_downloadDataSource count]]];
    }else{
        [_titleTextField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"DownloadListPageBtnCountTips", nil),[_downloadDataSource count]]];
    }
    if (isAdd) {
        [_titleView setHidden:NO];
        if ([_downloadDataSource count]>0) {
            [_tableView reloadData];
            [_scrollView setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
            [_contentBox setContentView:_scrollView];
        }else{
            [_nodataView setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
            [_contentBox setContentView:_nodataView];
        }
    }
}

#pragma mark - NSTableView Datasource and Delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 100;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_downloadDataSource count];
}

- (void)tableView:(NSTableView *)tableView didRemoveRowView:(ObjectTableRowView *)rowView forRow:(NSInteger)row {
    if ([rowView.subviews count]>0) {
        DownloadCellView *cellView = (DownloadCellView *)[[rowView subviews] objectAtIndex:0];
        if ([cellView isKindOfClass:[DownloadCellView class]]) {
            [cellView.progessField unbind:@"value"];
            [cellView.progessView unbind:@"doubleValue"];
            [cellView.transferProgressView unbind:@"doubleValue"];
        }
    }
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    ObjectTableRowView *result = [[ObjectTableRowView alloc] initWithFrame:NSMakeRect(0, 0, TableViewRowWidth, TableViewRowHight)];
    result.objectValue = [_downloadDataSource objectAtIndex:row];
    return [result autorelease];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    DownloadCellView *cellView = [tableView makeViewWithIdentifier:@"MainCell" owner:self];
    DriveItem *entity = [_downloadDataSource objectAtIndex:row];
    [cellView.propertityViewArray removeAllObjects];
    
    [cellView setDownLoadDriveItem:entity];
    [cellView.closeButton setTarget:self];
    [cellView.closeButton setAction:@selector(closeTask:)];
    if (entity.fileName.length>0) {
        [cellView.titleField setStringValue:entity.fileName];
    }

    [cellView.icon setImage:[NSImage imageNamed:@"noData_box"]];
    [cellView.progessField bind:@"value" toObject:entity withKeyPath:@"currentSizeStr" options:nil];
    for (NSView *subView in cellView.subviews) {
        [subView setHidden:YES];
    }
    [cellView adjustSpaceX:OringinalPropertityX Y:OringinalPropertityY];
    [cellView.icon setHidden:NO];
    [cellView.titleField setHidden:NO];
    [cellView.transferProgressView bind:@"doubleValue" toObject:entity withKeyPath:@"progress" options:nil];
    if (entity.state == DownloadStateLoading ||entity.state == UploadStateLoading|| entity.state == TransferStateNormal) {
        [cellView.progessView bind:@"doubleValue" toObject:entity withKeyPath:@"progress" options:nil];
        [cellView.closeButton setHidden:NO];
        [cellView.progessView setHidden:NO];
        [cellView.progessField setHidden:NO];
        [cellView.finderButton setHidden:NO];
        [cellView.finderButton setTarget:self];
        [cellView.finderButton setAction:@selector(finderFile:)];
        [cellView.deleteButton setHidden:NO];
        [cellView.deleteButton setTarget:self];
        [cellView.deleteButton setAction:@selector(deleteFile:)];
    }else if (entity.state == UploadStateComplete || entity.state == DownloadStateComplete){
        [cellView.finderButton setHidden:NO];
        [cellView.finderButton setTarget:self];
        [cellView.finderButton setAction:@selector(finderFile:)];
        [cellView.deleteButton setHidden:NO];
        [cellView.deleteButton setTarget:self];
        [cellView.deleteButton setAction:@selector(deleteFile:)];
    }
    return cellView;
}

- (void)closeWindow:(id)sender
{
    
}

#pragma makr Actions
- (void)finderFile:(id)sender
{
    //    NSDictionary *dimensionDict = nil;
    //    @autoreleasepool {
    //        dimensionDict = [[TempHelper customDimension] copy];
    //    }
    //    [ATTracker event:Video_Download action:Find actionParams:@"Find Video" label:LabelNone transferCount:1 screenView:@"Download View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    //    if (dimensionDict) {
    //        [dimensionDict release];
    //        dimensionDict = nil;
    //    }
    //    ObjectTableRowView *rowView = (ObjectTableRowView *)[[sender superview] superview];
    //    VideoBaseInfoEntity *entity = (VideoBaseInfoEntity *)rowView.objectValue;
    //    NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
    //    [workSpace selectFile:entity.vDownloadPath inFileViewerRootedAtPath:nil];
}

- (void)deleteFile:(id)sender
{
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    if (view) {
        [view setHidden:NO];
    }
    if ([_downloadDataSource count] <= 1) {
        [_titleTextField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"DownloadListPageBtnCountTip", nil),[_downloadDataSource count]]];
    }else{
        [_titleTextField setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"DownloadListPageBtnCountTips", nil),[_downloadDataSource count]]];
    }
    
}

- (void)cleanlist:(id)sender
{
    if ([_downloadDataSource count] == 0) {
        return;
    }
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
}

- (void)closeTask:(id)sender
{
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
}

- (void)learnMore:(id)sender
{
    //跳转到anytrans主页；
    NSURL *url = nil;
    url = [NSURL URLWithString:CustomLocalizedString(@"Product_Url", nil)];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Video_Download action:ActionNone actionParams:[TempHelper currentSelectionLanguage] label:Click transferCount:0 screenView:@"Download View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}

//传输准备进度开始
- (void)transferPrepareFileStart:(NSString *)file {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}
//传输准备进度结束
- (void)transferPrepareFileEnd {
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}

- (void)startTransAnimation{

}
//传输进度
- (void)transferProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}
//当前传输文件的名字或者路径
- (void)transferFile:(NSString *)file {
    dispatch_async(dispatch_get_main_queue(), ^{
    });
}
//分析进度
- (void)parseProgress:(float)progress {
//    for (DriveItem *eriveItem in dataArr) {
//        
//    }
}
//当前分析文件的名字或者路径
- (void)parseFile:(NSString *)file {
    
}

//全部传输成功
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
}

- (void)reloadBgview {
    [self.view setNeedsDisplay:YES];
}

- (void)dealloc
{
    [_deviceManager release],_deviceManager = nil;
    [_downloadDataSource release],_downloadDataSource = nil;
    [_uploadDataSource release],_uploadDataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [super dealloc];
}
@end
