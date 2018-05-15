//
//  IMBTransferViewController.m
//  AnyTransforCloud
//
//  Created by hym on 03/05/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBTransferViewController.h"
#import "IMBSelectedButton.h"
#import "IMBBorderRectAndColorView.h"
#import "StringHelper.h"
#import "IMBWhiteView.h"
#import "TransferUpTableCellView.h"
#import "TransferDownTableCellView.h"
#import "TransferCompleteTableCellView.h"
#import "IMBDriveModel.h"
#import "IMBScrollView.h"
#import <sqlite3.h>
#import "TempHelper.h"
#import "NSString+Category.h"
#import "IMBTransferProgressView.h"
#import "IMBAllCloudViewController.h"
#import "IMBTableRowView.h"
#import "IMBTransferHistoryTable.h"
#import "IMBTransferPopoverController.h"
#import "TempHelper.h"
#import "IMBCloudManager.h"
#import "IMBAlertViewController.h"

@implementation IMBTransferViewController
@synthesize upLoadAryM = _upLoadAryM;
@synthesize downLoadAryM = _downLoadAryM;
@synthesize completeAryM = _completeAryM;
@synthesize allCloudDelegate = _allCloudDelegate;
@synthesize allCloudDic = _allCloudDic;
@synthesize devPopover = _devPopover;

- (void)loadView {
    [super loadView];
    [self.view setWantsLayer:YES];
    [_upLoadTableViewScrollView setListener:_upLoadItemTableView];
    [_downLoadTableViewScrollView setListener:_downLoadItemTableView];
    [_completeTableViewScrollView setListener:_completeItemTableView];
    _allCloudDic = [[NSMutableDictionary alloc] init];
    [_upLoadTableViewScrollView setListener:_upLoadItemTableView];
    [_downLoadTableViewScrollView setListener:_downLoadItemTableView];
    [_completeTableViewScrollView setListener:_completeItemTableView];
    _cloudManager = [IMBCloudManager singleton];
    [self configBtnAndTextFiled];
    _upLoadAryM = [[NSMutableArray alloc] init];
    _downLoadAryM = [[NSMutableArray alloc] init];
    _completeAryM = [[NSMutableArray alloc] init];
    _upLoadItemTableView.delegate = self;
    _upLoadItemTableView.dataSource = self;
    _downLoadItemTableView.delegate = self;
    _downLoadItemTableView.dataSource = self;
    _completeItemTableView.delegate = self;
    _completeItemTableView.dataSource = self;
    _transferHistoryTable = [IMBTransferHistoryTable singleton];
    [_transferHistoryTable readSqliteData];
    [_upLoadAryM addObjectsFromArray:_transferHistoryTable.upLoadFailAryM];
    [_downLoadAryM addObjectsFromArray:_transferHistoryTable.downLoadFailAryM];
    [_completeAryM addObjectsFromArray:_transferHistoryTable.completeAryM];
    _transferType = UploadType;
    if (_transferType == UploadType) {
        if (_upLoadAryM.count == 0) {
            [_contentBox setContentView:_noDataView];
        }else {
            [_contentBox setContentView:_upLoadTableViewScrollView];
            [_upLoadItemTableView reloadData];
        }
    }else if (_transferType == DownLoadType){
        if (_downLoadAryM.count == 0) {
            [_contentBox setContentView:_noDataView];
        }else {
            [_contentBox setContentView:_downLoadTableViewScrollView];
            [_downLoadItemTableView reloadData];
        }
    }else {
        if (_completeAryM.count == 0) {
            [_contentBox setContentView:_noDataView];
        }else {
            [_contentBox setContentView:_completeTableViewScrollView];
            [_completeItemTableView reloadData];
        }
    }
    [self configBottomTitle];
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    
    [self.view setWantsLayer:YES];
    [self.view.layer setCornerRadius:5];
}

- (void)dealloc {
    if (_upLoadAryM) {
        [_upLoadAryM release];
        _upLoadAryM = nil;
    }
    if (_downLoadAryM) {
        [_downLoadAryM release];
        _downLoadAryM = nil;
    }
    if (_completeAryM) {
        [_completeAryM release];
        _completeAryM = nil;
    }
    if (_allCloudDic) {
        [_allCloudDic release];
        _allCloudDic = nil;
    }
    [super dealloc];
    
}

- (void)configBottomTitle {
    int failCount = 0;
    int transferCount = 0;
    if (_transferType == UploadType) {
        for (IMBDriveModel *item in _upLoadAryM) {
            if (item.state == UploadStateError) {
                failCount ++;
            }else {
                transferCount ++;
            }
        }
        if (transferCount == 0 && failCount > 0) {
            [_bottomTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"TransferControl_Transfer9", nil),failCount]];
        }else {
            [_bottomTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"TransferControl_Transfer4", nil),transferCount]];
        }
    }else if (_transferType == DownLoadType) {
        for (IMBDriveModel *item in _downLoadAryM) {
            if (item.state == DownloadStateError) {
                failCount ++;
            }else {
                transferCount ++;
            }
        }
        if (transferCount == 0  && failCount > 0) {
            [_bottomTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"TransferControl_Transfer9", nil),failCount]];
        }else {
            [_bottomTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"TransferControl_Transfer4", nil),transferCount]];
        }
    }else {
        [_bottomTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"TransferControl_Transfer8", nil),_completeAryM.count]];
    }

}

- (void)configBtnAndTextFiled {
    _bgView.rightShadow = YES;
    [_bgView setLuCorner:NO LbCorner:NO RuCorner:NO RbConer:YES CornerRadius:5];
    [_bgView setNeedsDisplay:YES];
     NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:14];
    [_upLoadBtn setEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] downColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] ExitColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] SelectColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] titleFont:font buttonTitle:CustomLocalizedString(@"TransferControl_Transfer1", nil)];
    [_upLoadBtn setTag:101];
    [_upLoadBtn setTarget:self];
    [_upLoadBtn setAction:@selector(switchView:)];
    
    [_downLoadBtn setEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] downColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] ExitColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] SelectColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] titleFont:font buttonTitle:CustomLocalizedString(@"TransferControl_Transfer2", nil)];
    [_downLoadBtn setTag:102];
    [_downLoadBtn setTarget:self];
    [_downLoadBtn setAction:@selector(switchView:)];
    
    [_completeBtn setEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] downColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] ExitColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] SelectColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] titleFont:font buttonTitle:CustomLocalizedString(@"TransferControl_Transfer3", nil)];
    [_completeBtn setTag:103];
    [_completeBtn setTarget:self];
    [_completeBtn setAction:@selector(switchView:)];
    
    [_bottomTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    NSFont *font2 = [NSFont fontWithName:@"Helvetica Neue" size:12];
    [_pauseBtn setEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] downColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] ExitColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] SelectColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] titleFont:font2 buttonTitle:CustomLocalizedString(@"TransferControl_Transfer5", nil)];
    [_pauseBtn setTag:104];
    [_pauseBtn setTarget:self];
    [_pauseBtn setAction:@selector(pauseAll:)];
    
    [_deleteBtn setEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] downColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] ExitColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] SelectColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] titleFont:font2 buttonTitle:CustomLocalizedString(@"TransferControl_Transfer6", nil)];
    [_deleteBtn setTag:105];
    [_deleteBtn setTarget:self];
    [_deleteBtn setAction:@selector(deleteAll:)];
    [_moveLineView setCornerRadius:0];
    [_moveLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]];
    [_moveLineView setFrameOrigin:NSMakePoint(_upLoadBtn.frame.origin.x, 0)];
    [_upLoadBtn setIsSelect:YES];
    [_upLoadBtn setNeedsDisplay:YES];
    [_bottomLineView  setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    NSRect rect1 = [StringHelper calcuTextBounds:CustomLocalizedString(@"TransferControl_Transfer5", nil) font:font2];
    int width1 = (int)rect1.size.width + 20;
    NSRect rect2 = [StringHelper calcuTextBounds:CustomLocalizedString(@"TransferControl_Transfer6", nil) font:font2];
    int width2 = (int)rect2.size.width + 20;
    
    [_deleteBtn setFrame:NSMakeRect(ceil(self.view.frame.size.width - width1 - 8), _deleteBtn.frame.origin.y, width1, _deleteBtn.frame.size.height)];
    [_pauseBtn setFrame:NSMakeRect(ceil(self.view.frame.size.width - width1 - width2 - 8), _deleteBtn.frame.origin.y, width1, _deleteBtn.frame.size.height)];
    
    [_noDataTitle setStringValue:CustomLocalizedString(@"NoData_Transfer_title", nil)];
    [_noDataTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_noDataSubTitle setStringValue:CustomLocalizedString(@"NoData_Transfer_subtitle", nil)];
    [_noDataSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
}

- (void)addNewUploadAry:(NSMutableArray *)ary {
    for (IMBDriveModel *model in ary) {
        [model addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        [model setIsDownLoad:NO];
        [_upLoadAryM addObject:model];
    }
    if (_transferType == UploadType) {
        [_contentBox setContentView:_upLoadTableViewScrollView];
        [_upLoadItemTableView reloadData];
    }
    [self configBottomTitle];
}

- (void)addNewDownloadAry:(NSMutableArray *)ary {
    for (IMBDriveModel *model in ary) {
        [model addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        [model setIsDownLoad:YES];
        [_downLoadAryM addObject:model];
    }
    if (_transferType == DownLoadType) {
        [_contentBox setContentView:_downLoadTableViewScrollView];
        [_downLoadItemTableView reloadData];
    }
    [self configBottomTitle];
}

//传输状态改变的回调函数，监听传输的状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        IMBDriveModel *model = object;
        if (model.state == DownloadStateComplete || model.state ==  DownloadStateError || model.state == UploadStateError || model.state == UploadStateComplete) {
            [self saveSqliteWithItem:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self configBottomTitle];
                if (_transferType == UploadType) {
                    if (_upLoadAryM.count == 0) {
                        [_contentBox setContentView:_noDataView];
                    }else {
                        [_upLoadItemTableView reloadData];
                    }
                }else if (_transferType == DownLoadType){
                    if (_downLoadAryM.count == 0) {
                        [_contentBox setContentView:_noDataView];
                    }else {
                        [_downLoadItemTableView reloadData];
                    }
                }else {
                    if (_completeAryM.count == 0) {
                        [_contentBox setContentView:_noDataView];
                    }else {
                        [_completeItemTableView reloadData];
                    }
                }
                if (model.state == UploadStateComplete) {
                    //TODO: HUYUMIN 需要去刷新对应的页面
                    IMBBaseManager *manage = [_cloudManager getCloudManager:[_cloudManager getBindDrive:model.driveID]];
                    IMBAllCloudViewController *allCloudViewController =  [_allCloudDic objectForKey:manage.baseDrive.driveID];
                    [allCloudViewController reload:nil];
                }
            });
        }
    }
}

//数据操作完成
- (void)saveSqliteWithItem:(IMBDriveModel *)item {
    [_transferHistoryTable saveSqliteWithItem:item];
    if (item.state == DownloadStateComplete) {
        [_completeAryM addObject:item];
        [_downLoadAryM removeObject:item];
        [_cloudManager.userTable saveOperationRecords:item];
    }else if (item.state == UploadStateComplete) {
        [_completeAryM addObject:item];
        [_upLoadAryM removeObject:item];
        [_cloudManager.userTable saveOperationRecords:item];
    }
    [(NSObject*)item removeObserver:self forKeyPath:@"state"];
}

#pragma mark - tableView dadasource、delegate方法
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 76;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_transferType == UploadType) {
        return _upLoadAryM.count;
    }else if (_transferType == DownLoadType){
        return _downLoadAryM.count;
    }else {
        return _completeAryM.count;
    }
}

- (void)tableView:(NSTableView *)tableView didRemoveRowView:(NSTableRowView *)rowView forRow:(NSInteger)row {
    if ([rowView.subviews count]>0) {
//        TransferTableCellView *cellView = [[rowView subviews] objectAtIndex:0];
//        if ([cellView isKindOfClass:[TransferTableCellView class]]) {
//            [cellView.progessField unbind:@"value"];
//        }
    }
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (_transferType == UploadType) {
       TransferUpTableCellView *cellView = (TransferUpTableCellView *)[tableView makeViewWithIdentifier:@"TransferUpCell" owner:self];
        IMBDriveModel *entity = [_upLoadAryM objectAtIndex:row];
        [cellView setDriveModel:entity];
        [cellView.titleField setStringValue:entity.fileName];
        [cellView.downOrUpImage setImage:[NSImage imageNamed:@"transfer_up"]];

        if (entity.parent) {
            [cellView.progessField bind:@"value" toObject:entity.parent withKeyPath:@"currentProgressStr" options:nil];
        }else{
            [cellView.progessField bind:@"value" toObject:entity withKeyPath:@"currentProgressStr" options:nil];
        }
        if (entity.parent) {
            [cellView.progressView bind:@"progress" toObject:entity.parent withKeyPath:@"progress" options:nil];
        }else{
            [cellView.progressView bind:@"progress" toObject:entity withKeyPath:@"progress" options:nil];
        }
        
        if (entity.transferImage) {
            [cellView.icon setImage:entity.transferImage];
        }

        IMBBaseManager *manage = [_cloudManager getCloudManager:[_cloudManager getBindDrive:entity.driveID]];
        [cellView.cloudiCon setImage:[TempHelper getCloudImage:manage.baseDrive.driveType]];
        if (entity.state == UploadStateError) {
            [cellView.progressView setHidden:YES];
            [cellView.downloadFaildField setHidden:NO];
            [cellView.downloadFaildField setStringValue:CustomLocalizedString(@"transfer_failed", nil)];
            [cellView.progessField setHidden:YES];
        }else {
            [cellView.downloadFaildField setHidden:YES];
            [cellView.progessField setHidden:NO];
        }
        
        if (entity.state == UploadStateError) {
            [cellView.reUpLoad setHidden:NO];
        }else {
            [cellView.reUpLoad setHidden:YES];
        }
        
        [cellView.closeButton setTarget:self];
        [cellView.closeButton setAction:@selector(closeTask:)];
        [cellView.reUpLoad setTarget:self];
        [cellView.reUpLoad setAction:@selector(reUpLoadTask:)];
        return cellView;
    }else if (_transferType == DownLoadType){
        TransferDownTableCellView *cellView = (TransferDownTableCellView *)[tableView makeViewWithIdentifier:@"TransferDownCell" owner:self];
        IMBDriveModel *entity = [_downLoadAryM objectAtIndex:row];
        [cellView setDriveModel:entity];
        [cellView.titleField setStringValue:entity.fileName];
        [cellView.downOrUpImage setImage:[NSImage imageNamed:@"transfer_down"]];
        
        if (entity.parent) {
            [cellView.progessField bind:@"value" toObject:entity.parent withKeyPath:@"currentProgressStr" options:nil];
        }else{
            [cellView.progessField bind:@"value" toObject:entity withKeyPath:@"currentProgressStr" options:nil];
        }
        if (entity.parent) {
            [cellView.progressView bind:@"progress" toObject:entity.parent withKeyPath:@"progress" options:nil];
        }else{
            [cellView.progressView bind:@"progress" toObject:entity withKeyPath:@"progress" options:nil];
        }
        
        if (entity.transferImage) {
            [cellView.icon setImage:entity.transferImage];
        }
        if (entity.state == DownloadStateError) {
            [cellView.progressView setHidden:YES];
            [cellView.progessField setHidden:YES];
            [cellView.downloadFaildField setHidden:NO];
            [cellView.downloadFaildField setStringValue:CustomLocalizedString(@"transfer_failed", nil)];
            [cellView.reDownLoad setHidden:NO];
            [cellView.contiuneDownLoadButton setHidden:YES];
        }else if (entity.state == DownloadStatePaused) {
            [cellView.progessField setHidden:NO];
            [cellView.contiuneDownLoadButton setHidden:NO];
            [cellView.reDownLoad setHidden:YES];
        }else {
            [cellView.progessField setHidden:NO];
            [cellView.downloadFaildField setHidden:YES];
            [cellView.reDownLoad setHidden:YES];
            [cellView.contiuneDownLoadButton setHidden:YES];
        }

        IMBBaseManager *manage = [_cloudManager getCloudManager:[_cloudManager getBindDrive:entity.driveID]];
        [cellView.cloudiCon setImage:[TempHelper getCloudImage:manage.baseDrive.driveType]];
        [cellView.closeButton setTarget:self];
        [cellView.closeButton setAction:@selector(closeTask:)];
        [cellView.reDownLoad setTarget:self];
        [cellView.reDownLoad setAction:@selector(reDownLoadTask:)];
        [cellView.pauseButton setTarget:self];
        [cellView.pauseButton setAction:@selector(pauseTask:)];
        [cellView.contiuneDownLoadButton setTarget:self];
        [cellView.contiuneDownLoadButton setAction:@selector(contiuneDownLoaTask:)];
        return cellView;
    }else {
        TransferCompleteTableCellView *cellView = (TransferCompleteTableCellView *)[tableView makeViewWithIdentifier:@"TransferComPleteCell" owner:self];
        IMBDriveModel *entity = [_completeAryM objectAtIndex:row];
        [cellView setDriveModel:entity];
        [cellView.titleField setStringValue:entity.fileName];

        if (entity.transferImage) {
            [cellView.icon setImage:entity.transferImage];
        }
        IMBBaseManager *manage = [_cloudManager getCloudManager:[_cloudManager getBindDrive:entity.driveID]];
        [cellView.cloudiCon setImage:[TempHelper getCloudImage:manage.baseDrive.driveType]];
        
        if (entity.state == DownloadStateComplete) {
            [cellView.downOrUpImage setImage:[NSImage imageNamed:@"transfer_down"]];
        }else {
           [cellView.downOrUpImage setImage:[NSImage imageNamed:@"transfer_up"]];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:entity.completeInterval];
        NSInteger count = [DateHelper getDaysFrom:date To:[NSDate date]];
        if (count == 0) {
            [cellView.timeFiled setStringValue:CustomLocalizedString(@"Date_Today", nil)];
        }else if (count == 1) {
            [cellView.timeFiled setStringValue:CustomLocalizedString(@"Date_Yesterday", nil)];
        }else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy/MM/dd";
            NSString *dateString = [formatter stringFromDate:date];
            [cellView.timeFiled setStringValue:dateString];
            [formatter release];
            formatter = nil;
        }

        [cellView.sizeField setStringValue:[StringHelper getFileSizeString:entity.fileSize reserved:2]];
        [cellView.closeButton setTarget:self];
        [cellView.closeButton setAction:@selector(closeTask:)];
        [cellView.findButton setTarget:self];
        [cellView.findButton setAction:@selector(findTask:)];
        return cellView;
    }
    return nil;
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    IMBTableRowView *tableRowView = [tableView makeViewWithIdentifier:@"rowView" owner:self];
    if (tableRowView == nil) {
        tableRowView = [[[IMBTableRowView alloc] init] autorelease];
        tableRowView.identifier = @"rowView";
        [tableRowView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleRegular];
    }
    return tableRowView;
}

- (void)closeTask:(id)sender {
    HoverButton *btn = (HoverButton *)sender;
    if (btn.tag == 101) {//上传
        TransferUpTableCellView *view = (TransferUpTableCellView *)[sender superview];
        IMBDriveModel *model = [view getDriveModel];
        IMBBaseManager *manage = [_cloudManager getCloudManager:[_cloudManager getBindDrive:model.driveID]];
        [manage cancelUploadItem:model];
        [(NSObject*)model removeObserver:self forKeyPath:@"state"];
        [_upLoadAryM removeObject:model];
        [_upLoadItemTableView reloadData];
    }else if (btn.tag == 102) {//下载
        TransferDownTableCellView *view = (TransferDownTableCellView *)[sender superview];
        IMBDriveModel *model = [view getDriveModel];
        IMBBaseManager *manage = [_cloudManager getCloudManager:[_cloudManager getBindDrive:model.driveID]];
        [manage cancelDownloadItem:model];
        [(NSObject*)model removeObserver:self forKeyPath:@"state"];
        [_downLoadAryM removeObject:model];
        [_downLoadItemTableView reloadData];
    }else {//完成
        TransferCompleteTableCellView *view = (TransferCompleteTableCellView *)[sender superview];
        IMBDriveModel *model = [view getDriveModel];
        [_transferHistoryTable deleteDataSqlite:model.fileID];
        [_completeAryM removeObject:model];
        [_completeItemTableView reloadData];
    }
}

- (void)reUpLoadTask:(id)sender {
    TransferUpTableCellView *view = (TransferUpTableCellView *)[sender superview];
    IMBDriveModel *model = [view getDriveModel];
    [model addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    IMBBaseManager *manage = [_cloudManager getCloudManager:[_cloudManager getBindDrive:model.driveID]];
    model.state = TransferStateNormal;
    [manage uploadItem:model];
}

- (void)reDownLoadTask:(id)sender {
    TransferDownTableCellView *view = (TransferDownTableCellView *)[sender superview];
    IMBDriveModel *model = [view getDriveModel];
    [model addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    IMBBaseManager *manage = [_cloudManager getCloudManager:[_cloudManager getBindDrive:model.driveID]];
    model.state = TransferStateNormal;
    [manage downloadItem:model];
}

- (void)pauseTask:(id)sender {
    TransferDownTableCellView *view = (TransferDownTableCellView *)[sender superview];
    IMBDriveModel *model = [view getDriveModel];
    IMBBaseManager *manage = [_cloudManager getCloudManager:[_cloudManager getBindDrive:model.driveID]];
    [manage pauseUploadItem:model];
}

- (void)contiuneDownLoaTask:(id)sender {
    TransferDownTableCellView *view = (TransferDownTableCellView *)[sender superview];
    IMBDriveModel *model = [view getDriveModel];
    IMBBaseManager *manage = [_cloudManager getCloudManager:[_cloudManager getBindDrive:model.driveID]];
    [manage resumeDownloadItem:model];
}

- (void)findTask:(id)sender {
    TransferCompleteTableCellView *view = (TransferCompleteTableCellView *)[sender superview];
    IMBDriveModel *model = [view getDriveModel];
    NSString *path = model.localPath;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
        [workSpace selectFile:path inFileViewerRootedAtPath:[path stringByDeletingLastPathComponent]];
    }else {
        NSString *alertText = CustomLocalizedString(@"CWTip_FileNotExist", nil);
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSuperView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        [_alertViewController showAlertText:alertText withAlertButton:CustomLocalizedString(@"Button_Yes", nil) withSuperView:view];
    }
}


#pragma mark -- 切换页面
- (void)switchView:(id)sender {
    IMBSelectedButton *btn = (IMBSelectedButton *)sender;
    NSEvent *event = nil;
    if (btn.tag == 101) {
        [_upLoadBtn setIsSelect:YES];
        [_downLoadBtn setIsSelect:NO];
        [_completeBtn setIsSelect:NO];
        [_upLoadBtn mouseEntered:event];
        [_downLoadBtn mouseExited:event];
        [_completeBtn mouseExited:event];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            [[_moveLineView animator] setFrameOrigin:NSMakePoint(_upLoadBtn.frame.origin.x, 0)];
        } completionHandler:^{
            [_moveLineView setFrameOrigin:NSMakePoint(_upLoadBtn.frame.origin.x, 0)];
        }];
        [_pauseBtn setHidden:YES];
        _transferType = UploadType;
    }else if (btn.tag == 102) {
        [_upLoadBtn setIsSelect:NO];
        [_downLoadBtn setIsSelect:YES];
        [_completeBtn setIsSelect:NO];
        [_upLoadBtn mouseExited:event];
        [_downLoadBtn mouseEntered:event];
        [_completeBtn mouseExited:event];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            [[_moveLineView animator] setFrameOrigin:NSMakePoint(_downLoadBtn.frame.origin.x, 0)];
        } completionHandler:^{
            [_moveLineView setFrameOrigin:NSMakePoint(_downLoadBtn.frame.origin.x, 0)];
        }];
        [_pauseBtn setHidden:NO];
        _transferType = DownLoadType;
    }else if (btn.tag == 103) {
        [_upLoadBtn setIsSelect:NO];
        [_downLoadBtn setIsSelect:NO];
        [_completeBtn setIsSelect:YES];
        [_upLoadBtn mouseExited:event];
        [_downLoadBtn mouseExited:event];
        [_completeBtn mouseEntered:event];
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
            [[_moveLineView animator] setFrameOrigin:NSMakePoint(_completeBtn.frame.origin.x, 0)];
        } completionHandler:^{
            [_moveLineView setFrameOrigin:NSMakePoint(_completeBtn.frame.origin.x, 0)];
        }];
        [_pauseBtn setHidden:YES];
        _transferType = CompleteType;
    }
    
    if (_transferType == UploadType) {
        if (_upLoadAryM.count == 0) {
            [_contentBox setContentView:_noDataView];
        }else {
            [_contentBox setContentView:_upLoadTableViewScrollView];
            [_upLoadItemTableView reloadData];
        }
    }else if (_transferType == DownLoadType){
        if (_downLoadAryM.count == 0) {
            [_contentBox setContentView:_noDataView];
        }else {
            [_contentBox setContentView:_downLoadTableViewScrollView];
            [_downLoadItemTableView reloadData];
        }
    }else {
        if (_completeAryM.count == 0) {
            [_contentBox setContentView:_noDataView];
        }else {
            [_contentBox setContentView:_completeTableViewScrollView];
            [_completeItemTableView reloadData];
        }
    }
    [self configBottomTitle];
}

#pragma mark -- 暂停、删除任务
- (void)pauseAll:(id)sender {
    NSEvent *event = nil;
    [_pauseBtn setIsSelect:NO];
    [_pauseBtn mouseExited:event];
    for (IMBDriveModel *model in _downLoadAryM) {
        if (model.state != DownloadStateError) {
             IMBBaseManager *manage = [_cloudManager getCloudManager:[_cloudManager getBindDrive:model.driveID]];
            [manage pauseDownloadItem:model];
        }
    }
}

- (void)deleteAll:(id)sender {
    NSEvent *event = nil;
    [_deleteBtn setIsSelect:NO];
    [_deleteBtn mouseExited:event];
    
    if (_devPopover != nil) {
        if (_devPopover.isShown) {
            [_devPopover close];
            return;
        }
    }
    if (_devPopover != nil) {
        [_devPopover release];
        _devPopover = nil;
    }
    _devPopover = [[NSPopover alloc] init];
    
    if ([[TempHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
        _devPopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
    }else {
        _devPopover.appearance = NSPopoverAppearanceMinimal;
    }
    _devPopover.animates = YES;
    _devPopover.behavior = NSPopoverBehaviorTransient;
    _devPopover.delegate = self;
    _transferPopoverController = [[IMBTransferPopoverController alloc] initWithNibName:@"IMBTransferPopoverController" bundle:nil];
    if (_devPopover != nil) {
        _devPopover.contentViewController = _transferPopoverController;
    }
    [_transferPopoverController setDelegate:self];
    [_transferPopoverController release];
    NSButton *targetButton = (NSButton *)sender;
    NSRectEdge prefEdge = NSMinYEdge;
    NSRect rect = NSMakeRect(targetButton.bounds.origin.x, targetButton.bounds.origin.y, targetButton.bounds.size.width, targetButton.bounds.size.height);
    [_devPopover showRelativeToRect:rect ofView:sender preferredEdge:prefEdge];
}

- (void)sureToDeleteAllTask:(id)sender {
     [_devPopover close];
    if (_transferType == UploadType) {
        for (IMBDriveModel *model in _upLoadAryM) {
            IMBBaseManager *manage = [_cloudManager getCloudManager:[_cloudManager getBindDrive:model.driveID]];
            [manage cancelUploadItem:model];
        }
        [_upLoadAryM removeAllObjects];
        [_upLoadItemTableView reloadData];
    }else if (_transferType == DownLoadType) {
        for (IMBDriveModel *model in _downLoadAryM) {
            IMBBaseManager *manage = [_cloudManager getCloudManager:[_cloudManager getBindDrive:model.driveID]];
            [manage cancelUploadItem:model];
        }
        [_downLoadAryM removeAllObjects];
        [_downLoadItemTableView reloadData];
    }else {
        for (IMBDriveModel *model in _completeAryM) {
            [_transferHistoryTable deleteDataSqlite:model.fileID];
        }
        [_completeAryM removeAllObjects];
        [_completeItemTableView reloadData];
    }
}

- (void)cancelToDeleteAllTask:(id)sender {
     [_devPopover close];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
