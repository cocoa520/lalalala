//
//  IMBTranferShowCompleteViewController.m
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/24.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBTranferShowCompleteViewController.h"
#import "IMBCommonDefine.h"
#import "DriveItem.h"
#import "IMBImageAndTextCell.h"
#import "IMBHelper.h"
#import "IMBMessageNameTextCell.h"
#import "IMBTableViewBtnCell.h"
#import <sqlite3.h>
#import "TempHelper.h"
#define TableViewRowWidth 360
#define TableViewRowHight 100
#define OringinalPropertityX 0
#define OringinalPropertityY 22
@interface IMBTranferShowCompleteViewController ()

@end

@implementation IMBTranferShowCompleteViewController
@synthesize delegate = _delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)loadView
{
    [super loadView];
    count = 0;
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setListener:self];
    [_tableView setCanSelect:YES];
    [_tableView setIsTranferView:YES];
    _dataAry = [[NSMutableArray alloc] init];
    //    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_nodataImageView setImage:[NSImage imageNamed:@"download_nodata"]];
    [_noTipTextField setTextColor:NODATA_NOLIKTITLE_COLOR];
    [_noTipTextField setStringValue:CustomLocalizedString(@"downloadpageNoDataTips", nil)];
    
    [_tableView setBackgroundColor:[NSColor clearColor]];
    [_rootBox setContentView:_dataView];
    _deleteFileBtn = [[IMBImageAndTitleButton alloc]initWithFrame:NSMakeRect(0, 0, 40, 40)];
    _findFileBtn = [[IMBImageAndTitleButton alloc]initWithFrame:NSMakeRect(0, 0, 40, 40)];
    [_findFileBtn setBordered:NO];
    [_deleteFileBtn setBordered:NO];
    [_findFileBtn setTitle:@""];
    [_deleteFileBtn setTitle:@""];
    [_deleteFileBtn mouseDownImage:[NSImage imageNamed:@"transferlist_icon_history_hover"] withMouseUpImg:[NSImage imageNamed:@"transferlist_icon_history"]  withMouseExitedImg:[NSImage imageNamed:@"transferlist_icon_history"]  mouseEnterImg:[NSImage imageNamed:@"transferlist_icon_history_hover"]  withButtonName:@""];
   [_findFileBtn mouseDownImage:[NSImage imageNamed:@"transferlist_icon_history_hover"] withMouseUpImg:[NSImage imageNamed:@"transferlist_icon_history"]  withMouseExitedImg:[NSImage imageNamed:@"transferlist_icon_history"]  mouseEnterImg:[NSImage imageNamed:@"transferlist_icon_history_hover"]  withButtonName:@""];
}

- (void)addDataAry:(NSMutableArray *)dataAry {
//    _dataAry insertObject:dataAry atIndex:<#(NSUInteger)#>
    if  (_dataAry){
        [_dataAry release];
        _dataAry = nil;
        _dataAry = [[NSMutableArray alloc]init];
    }
    for (DriveItem *driveItem in dataAry) {
//        if (!driveItem.isAddCompleteView&&!driveItem.isStart) {
//            driveItem.isAddCompleteView = YES;
            if (driveItem.state == DownloadStateComplete) {
                count ++;
                if (driveItem.deleteFileBtn) {
                    [driveItem.deleteFileBtn removeFromSuperview];
                    [driveItem.deleteFileBtn release];
                }
                if (driveItem.findFileBtn) {
                    [driveItem.findFileBtn release];
                    [driveItem.findFileBtn removeFromSuperview];
                }
                driveItem.deleteFileBtn = [[IMBImageAndTitleButton alloc]initWithFrame:NSMakeRect(100, 0, 40, 40)];
                [driveItem.deleteFileBtn setBordered:NO];
                [driveItem.deleteFileBtn setTitle:@""];
                driveItem.deleteFileBtn.tag = count;
                [driveItem.deleteFileBtn mouseDownImage:[NSImage imageNamed:@"transferlist_history_icon_del_hover"] withMouseUpImg:[NSImage imageNamed:@"transferlist_history_icon_del"]  withMouseExitedImg:[NSImage imageNamed:@"transferlist_history_icon_del"]  mouseEnterImg:[NSImage imageNamed:@"transferlist_history_icon_del_hover"]  withButtonName:@""];
                [driveItem.deleteFileBtn setTarget:self];
                [driveItem.deleteFileBtn setAction:@selector(deleteItemDown:)];
                
                driveItem.findFileBtn = [[IMBImageAndTitleButton alloc]initWithFrame:NSMakeRect(100, 0, 40, 40)];
                [driveItem.findFileBtn setBordered:NO];
                [driveItem.findFileBtn setTitle:@""];
                driveItem.findFileBtn.tag = count;
                [driveItem.findFileBtn mouseDownImage:[NSImage imageNamed:@"transferlist_history_icon_folder_hover"] withMouseUpImg:[NSImage imageNamed:@"transferlist_history_icon_folder"]  withMouseExitedImg:[NSImage imageNamed:@"transferlist_history_icon_folder"]  mouseEnterImg:[NSImage imageNamed:@"transferlist_history_icon_folder_hover"]  withButtonName:@""];
                [driveItem.findFileBtn setTarget:self];
                [driveItem.findFileBtn setAction:@selector(findItemDown:)];

            }else{
                driveItem.deleteFileBtn = [[IMBImageAndTitleButton alloc]initWithFrame:NSMakeRect(100, 0, 40, 40)];
                [driveItem.deleteFileBtn setBordered:NO];
                [driveItem.deleteFileBtn setTitle:@""];
                driveItem.deleteFileBtn.tag = count;
                [driveItem.deleteFileBtn mouseDownImage:[NSImage imageNamed:@"transferlist_history_icon_del_hover"] withMouseUpImg:[NSImage imageNamed:@"transferlist_history_icon_del"]  withMouseExitedImg:[NSImage imageNamed:@"transferlist_history_icon_del"]  mouseEnterImg:[NSImage imageNamed:@"transferlist_history_icon_del_hover"]  withButtonName:@""];
                [driveItem.deleteFileBtn setTarget:self];
                [driveItem.deleteFileBtn setAction:@selector(deleteItemDown:)];
            }
            [_dataAry addObject:driveItem];
//        }
    }
    if (_dataAry.count > 0) {
        [_rootBox setContentView:_dataView];
    }else {
        [_rootBox setContentView:_nodataView];
    }
    [_tableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_dataAry count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSMutableArray *displayArray = nil;
//    if (_dataAry) {
//        displayArray = _researchdataSourceArray;
//    }else{
        displayArray = _dataAry;
//    }
    if (displayArray.count <= 0 ) {
        return 0;
    }
    DriveItem *driveItem = [displayArray objectAtIndex:row];
    if ([@"transferTime" isEqualToString:tableColumn.identifier]) {
        return driveItem.completeDate;
    }else if ([@"transferState" isEqualToString:tableColumn.identifier]) {
        if (driveItem.state == DownloadStateComplete) {
            return CustomLocalizedString(@"TransferCompelete", nil);
        }else if (driveItem.state == DownloadStateError){
            return CustomLocalizedString(@"TransferFailed", nil);
        }else if (driveItem.state == UploadStateComplete){
            return CustomLocalizedString(@"Transfer_completeView_transferState_Upload_Complete", nil);
        }else if (driveItem.state == UploadStateError){
            return CustomLocalizedString(@"TransferFailed", nil);
        }
    }else if ([@"transferName" isEqualToString:tableColumn.identifier]) {
        return [NSString stringWithFormat:@"%@\n%@",driveItem.fileName,[IMBHelper getFileSizeString:driveItem.fileSize reserved:2]];
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    DriveItem *driveitem = [_dataAry objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:@"transferImage"]) {
        IMBImageAndTextCell *curCell = (IMBImageAndTextCell*)cell;
//        if (driveitem.appIconImage == nil) {
//            driveitem.appIconImage = [StringHelper imageNamed:@"app_default"];
//            curCell.imageName = @"app_default";
//        }
        [curCell setImageSize:NSMakeSize(30, 36)];
        if (driveitem.photoImage){
            curCell.image = driveitem.photoImage;
        }
        
        curCell.paddingX = 20;
        curCell.marginX = 20;
    }else if ([@"transferName" isEqualToString:tableColumn.identifier]) {
        IMBMessageNameTextCell *message = (IMBMessageNameTextCell *)cell;
        message.titleFont = [NSFont userFontOfSize:12];
        [message setTitleFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
        [message setSubTitleFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
        [message setTitleColor:[NSColor blackColor]];
        [message setSubTitleColor:[NSColor colorWithCalibratedRed:141.0/255 green:141.0/255 blue:141.0/255 alpha:1]];
    }else if ([@"transferBtn" isEqualToString:tableColumn.identifier]) {
        IMBTableViewBtnCell *tableCell = (IMBTableViewBtnCell *)cell;
        tableCell.deleteBtn = driveitem.deleteFileBtn;
        tableCell.findBtn = driveitem.findFileBtn;
    }
}

- (void)findItemDown:(id)sender {
    IMBImageAndTitleButton *imageBtn = (IMBImageAndTitleButton *)sender;
    for (DriveItem *driveItem in _dataAry) {
        if (driveItem.deleteFileBtn.tag == imageBtn.tag) {
            NSWorkspace *ws = [NSWorkspace sharedWorkspace];
            [ws openFile:driveItem.localPath];
//            NSURL *fileURL = [NSURL fileURLWithPath: driveItem.localPath];
//             [ws selectFile:[fileURL path] inFileViewerRootedAtPath:nil];
            break;
        }
    }
}

- (void)deleteItemDown:(id)sender {
    IMBImageAndTitleButton *imageBtn = (IMBImageAndTitleButton *)sender;
    DriveItem *item = nil;
    for (DriveItem *driveItem in _dataAry) {
        [driveItem.deleteFileBtn removeFromSuperview];
        [driveItem.findFileBtn removeFromSuperview];
        if (driveItem.deleteFileBtn.tag == imageBtn.tag) {
            item = driveItem;
            sqlite3 *dbPoint;
            NSString *tempPath = [TempHelper getAppiMobieConfigPath];
            NSString *documentPath= [tempPath stringByAppendingPathComponent:@"FileHistory.sqlite"];
            sqlite3_open([documentPath UTF8String], &dbPoint);
            NSString *sqlStr=[NSString stringWithFormat:@"delete from FileHistory where transfer_id ='%@'",driveItem.docwsID];
            sqlite3_exec(dbPoint, [sqlStr UTF8String], nil, nil, nil);
            sqlite3_close(dbPoint);
        }
    }
    
    [_dataAry removeObject:item];
    [_tableView reloadData];
}

- (void)removeAllData {
    sqlite3 *dbPoint;
    NSString *tempPath = [TempHelper getAppiMobieConfigPath];
    NSString *documentPath= [tempPath stringByAppendingPathComponent:@"FileHistory.sqlite"];
    sqlite3_open([documentPath UTF8String], &dbPoint);
    NSString *sqlStr=@"delete from FileHistory";
    sqlite3_exec(dbPoint, [sqlStr UTF8String], nil, nil, nil);
    sqlite3_close(dbPoint);
    
    for (DriveItem *driveItem in _dataAry) {
        [driveItem.deleteFileBtn removeFromSuperview];
        [driveItem.findFileBtn removeFromSuperview];
    }
    
    [_dataAry removeAllObjects];
    if (_dataAry.count > 0) {
        [_rootBox setContentView:_dataView];
    }else {
        [_rootBox setContentView:_nodataView];
    }
    [_delegate removeAllHistoryAry];
    [_tableView reloadData];
}

- (void)dealloc {
    [super dealloc];
    [_dataAry release],_dataAry = nil;
}


@end
