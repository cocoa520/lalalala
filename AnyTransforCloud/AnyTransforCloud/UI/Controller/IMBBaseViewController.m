//
//  IMBBaseViewController.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/19.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBBoxManager.h"
#import "CloudItemView.h"
#import "IMBTransferViewController.h"
#import "IMBFileTableCellView.h"
#import "IMBTableRowView.h"
#import "IMBMainPageViewController.h"
#import "IMBSearchManager.h"
@implementation IMBBaseViewController
@synthesize displayDelegate = _displayDelegate;
@synthesize delegate = _delegate;

- (id)initWithDelegate:(id)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        _nc = [NSNotificationCenter defaultCenter];
        _searchAryM = [[NSMutableArray alloc] init];
        _dataSourAryM = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id _Nonnull)initWithDelegate:(id _Nonnull)delegate withDriveID:(NSString * _Nonnull)driveID {
    if (self = [super init]) {
        
    }
    return self;
}

- (id _Nonnull)initWithDelegate:(id _Nonnull)delegate withCloudEntity:(IMBCloudEntity * _Nonnull)CloudEntity {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc {
    if (_searchAryM) {
        [_searchAryM release];
        _searchAryM = nil;
    }
    if (_baseManager) {
        [_baseManager release];
        _baseManager = nil;
    }
    if (_dataSourAryM) {
        [_dataSourAryM release];
        _dataSourAryM = nil;
    }
    if (_newDriveModel) {
        [_newDriveModel release];
        _newDriveModel = nil;
    }
    if (_alertViewController) {
        [_alertViewController release];
        _alertViewController = nil;
    }
    if (_promptView) {
        [_promptView release];
        _promptView = nil;
    }
    [super dealloc];
}

- (void)loadView {
    [super loadView];
    
    [[IMBCloudManager singleton].transferViewController setAllCloudDelegate:self];
//    [[IMBCloudManager singleton].transferViewController.allCloudDic setObject:self forKey:_baseManager.baseDrive.driveID];
    
    _alertView = [[IMBMoveAlertViewController alloc] initWithNibName:@"IMBMoveAlertViewController" bundle:nil];
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    
    [_itemTableView setDelegate:self];
    [_itemTableView setDataSource:self];
    _itemTableView.allowsMultipleSelection = YES;
    [_itemTableView setListener:self];
    [_itemTableView setFocusRingType:NSFocusRingTypeNone];
    
    [_itemTableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    [_itemTableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
    //注册该表的拖动类型
    [_itemTableView registerForDraggedTypes:[NSArray arrayWithObjects:NSFilesPromisePboardType,NSFilenamesPboardType,nil]];
    [_tableViewHeaderView setFrameSize:NSMakeSize(self.view.frame.size.width, 38)];
    [_tableViewHeaderView setTarget:self];
    [_tableViewHeaderView setAction:@selector(tableViewSortClick:)];
}

#pragma mark - NSTableView Datasource and Delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 58;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _dataSourAryM.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (_dataSourAryM > 0) {
        IMBFileTableCellView *cellView = [tableView makeViewWithIdentifier:@"fileTabCell" owner:self];
        [cellView setCellRow:row];
        IMBDriveModel *entity = [_dataSourAryM objectAtIndex:row];
        [cellView setModel:entity];
        [cellView setDelegate:self];
        
        return cellView;
    }else {
        return nil;
    }
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

- (void)tableViewSingleClick:(NSTableView *)tableView row:(NSInteger)index {
    _selectedCell = [tableView viewAtColumn:0 row:index makeIfNecessary:NO];
    if ((int)index >= 0 && index < _dataSourAryM.count) {
        IMBDriveModel *model = [_dataSourAryM objectAtIndex:index];
        _currentModel = model;
    }
    [self configDetailViewWith:_currentModel];
}

- (void)tableViewDoubleClick:(NSTableView *)tableView row:(NSInteger)index {
    if ((int)index >= 0 && index < _dataSourAryM.count) {
        IMBDriveModel *model = [_dataSourAryM objectAtIndex:index];
        if (model.isFolder) {
            [self collectionViewDoubleClick:model];
        }
    }
}

- (void)tableView:(NSTableView *)tableView rightDownrow:(NSInteger)index {
    [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
    [self tableViewSingleClick:tableView row:index];
}

//NSTableView drop and drag
- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    NSArray *fileTypeList = [NSArray arrayWithObject:@"export"];
    [pboard setPropertyList:fileTypeList
                    forType:NSFilesPromisePboardType];
    if (_itemTableViewcanDrag) {
        return YES;
    } else {
        return NO;
    }
}

//_itemTableView drag destination support
- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation {
    NSPasteboard *pastboard = [info draggingPasteboard];
    NSArray *fileTypeList = [pastboard propertyListForType:NSFilesPromisePboardType];
    if (fileTypeList == nil) {
        return NSDragOperationCopy;
    } else {
        return NSDragOperationNone;
    }
}

- (BOOL)tableView:(NSTableView *)tableView acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)dropOperation {
    NSPasteboard *pastboard = [info draggingPasteboard];
    NSArray *boarditemsArray = [pastboard pasteboardItems];
    NSMutableArray *itemArray = [NSMutableArray array];
    for (NSPasteboardItem *item in boarditemsArray) {
        NSString *urlPath = [item stringForType:@"public.file-url"];
        NSURL *url = [NSURL URLWithString:urlPath];
        NSString *path = [url relativePath];
        if (path == nil) {
            continue;
        }
        [itemArray addObject:path];
    }
    if (itemArray.count > 0) {
        [self dropToCollectionViewOrTableViewWithAry:itemArray];
        return YES;
    }else {
        return NO;
    }
}

- (NSArray *)tableView:(NSTableView *)tableView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedRowsWithIndexes:(NSIndexSet *)indexSet {
    NSArray *namesArray = nil;
    //获取目的url
    NSString *url = [dropDestination relativePath];
    //此处调用导出方法
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:indexSet,@"indexSet",url,@"url",tableView,@"tableView", nil];
    [self performSelector:@selector(dragCollectionViewOrTableViewToMac:) withObject:dic afterDelay:0.1];
    return namesArray;
}
//tableView排序
- (void)tableViewSortClick:(id)sender {
    IMBArrowButton *arrowButton = (IMBArrowButton *)sender;
    NSString *key = arrowButton.identifier;
    [_tableViewHeaderView currentButtonClick:key];
    BOOL isAscending = arrowButton.isAscending;
    if ([key isEqualToString:@"name"]) {
        key = @"fileName";
    } else if ([key isEqualToString:@"date"]) {
        key = @"lastModifiedDateString";
    }else if ([key isEqualToString:@"size"]) {
        key = @"fileSize";
    }else if ([key isEqualToString:@"extension"]) {
        key = @"extension";
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [_dataSourAryM sortUsingDescriptors:sortDescriptors];
    
    [_itemTableView reloadData];
    [_collectionView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
}

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id <NSDraggingInfo>)draggingInfo indexPath:(NSIndexPath *)indexPath dropOperation:(NSCollectionViewDropOperation)dropOperation {
    NSPasteboard *pastboard = [draggingInfo draggingPasteboard];
    NSArray *boarditemsArray = [pastboard pasteboardItems];
    NSMutableArray *itemArray = [NSMutableArray array];
    for (NSPasteboardItem *item in boarditemsArray) {
        NSString *urlPath = [item stringForType:@"public.file-url"];
        NSURL *url = [NSURL URLWithString:urlPath];
        NSString *path = [url relativePath];
        if(![StringHelper stringIsNilOrEmpty:path]) {
            [itemArray addObject:path];
        }
    }
    if (itemArray.count > 0) {
        [self dropToCollectionViewOrTableViewWithAry:itemArray];
        return YES;
    }else {
        return NO;
    }
}

- (NSArray<NSString *> *)collectionView:(NSCollectionView *)collectionView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropURL forDraggedItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    NSArray *namesArray = nil;
    //获取目的url
    NSString *url = [dropURL relativePath];
    //此处调用导出方法
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:indexPaths,@"indexPath",url,@"url",collectionView,@"collectionView", nil];
    [self performSelector:@selector(dragCollectionViewOrTableViewToMac:) withObject:dic afterDelay:0.1];
    return namesArray;
}

#pragma mark - drag/drop方法
- (void)dropToCollectionViewOrTableViewWithAry:(NSArray *)ary {
    [self addItemsDelay:(NSMutableArray *)ary];
}

- (void)dragCollectionViewOrTableViewToMac:(NSDictionary *)dic {
    NSString *path = [dic objectForKey:@"url"];
    [_baseManager setDownloadPath:path];
    NSIndexSet *selectedSet = [self selectedItems];
    NSMutableArray *preparedArray = [NSMutableArray array];
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _searchAryM;
    }else {
        displayArr = _dataSourAryM;
    }
    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [preparedArray addObject:[displayArr objectAtIndex:idx] ];
    }];
    IMBTransferViewController *transferView = [IMBCloudManager singleton].transferViewController;
    [transferView addNewDownloadAry:preparedArray];
    [_baseManager downloadItems:preparedArray];
}

//选中
- (NSIndexSet *)selectedItems {
    NSIndexSet *selectedItems = [_collectionView selectionIndexes];
    return selectedItems;
}

#pragma mark - action
- (void)addNotification {
    
}

- (void)sync:(id)sender {
    if ([[IMBCloudManager singleton].driveManager driveArray].count < 2) {
        [self showAlertText:CustomLocalizedString(@"cloud_alert_title", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    } else {
        
    }
}

- (void)share:(id)sender {
    
}

- (void)star:(id)sender {
    NSMutableArray *preparedArray = [NSMutableArray array];
    if ([sender isKindOfClass:[IMBDriveModel class]]) {//item上的按钮传输
        [preparedArray addObject:sender];
    } else {
        NSIndexSet *selectedSet = [self selectedItems];
        [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            [preparedArray addObject:[_dataSourAryM objectAtIndex:idx]];
        }];
    }
    
    if (preparedArray.count == 0) {
        //TODO:提示窗口
        return;
    }
    IMBCloudManager *cloudManager = [IMBCloudManager singleton];
    [cloudManager addContent:preparedArray Type:@"star" DriveID:_baseManager.baseDrive.driveID];
}

//刷新
- (void)reload:(id)sender {
    //屏蔽toolbar按钮   加加载动画
//    IMBTransferViewController *transferView = [IMBCloudManager singleton].transferViewController;
//    if (transferView.downLoadAryM.count == 0) {
//        [_baseManager cancelAllDownloadItems];
//    }
    [_baseManager recursiveDirectoryContentsDics:_currentDriveID];
    //TODO:清空搜索按钮
}

//下载
- (void)download:(id)sender {
    
    NSMutableArray *preparedArray = [NSMutableArray array];
    if ([sender isKindOfClass:[IMBDriveModel class]]) {//item上的按钮传输
        [preparedArray addObject:sender];
    } else {
        NSIndexSet *selectedSet = [self selectedItems];
        NSArray *displayArr = nil;
        if (_isSearch) {
            displayArr = _searchAryM;
        }else {
            displayArr = _dataSourAryM;
        }
        [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            [preparedArray addObject:[displayArr objectAtIndex:idx]];
        }];
    }
   
    if (preparedArray.count == 0) {
        //TODO:提示窗口
        return;
    }
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:YES];
    [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode== NSFileHandlingPanelOKButton) {
            NSArray *urlArr = [openPanel URLs];
            NSMutableArray *paths = [NSMutableArray array];
            for (NSURL *url in urlArr) {
                [paths addObject:url.path];
            }
            IMBTransferViewController *transferView = [IMBCloudManager singleton].transferViewController;
            if (transferView.downLoadAryM.count == 0) {
                [_baseManager cancelAllDownloadItems];
            }
            NSString *exportPath = [paths objectAtIndex:0];
            [_baseManager setDownloadPath:exportPath];
            [transferView addNewDownloadAry:preparedArray];
            IMBMainPageViewController *mainPageView = (IMBMainPageViewController *)_displayDelegate;
            //TODO: HUYUMIN 这个个数可能需要修改
            [mainPageView showTransferTipViewWithCount:(int)preparedArray.count isDownLoad:YES];
            [_baseManager downloadItems:preparedArray];
        }
    }];
}

//上传
- (void)upload:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:YES];
    [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (NSModalResponseOK == result) {
            NSArray *urlArr = [openPanel URLs];
            NSMutableArray *paths = [NSMutableArray array];
            for (NSURL *url in urlArr) {
                [paths addObject:url.path];
            }
            [self performSelector:@selector(addItemsDelay:) withObject:paths afterDelay:0.3];
        }
    }];
}

- (void)uploadFile:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:NO];
    [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (NSModalResponseOK == result) {
            NSArray *urlArr = [openPanel URLs];
            NSMutableArray *paths = [NSMutableArray array];
            for (NSURL *url in urlArr) {
                [paths addObject:url.path];
            }
            [self performSelector:@selector(addItemsDelay:) withObject:paths afterDelay:0.3];
        }
    }];
}

- (void)uploadFolder:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel setCanChooseFiles:NO];
    [openPanel setCanChooseDirectories:YES];
    [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (NSModalResponseOK == result) {
            NSArray *urlArr = [openPanel URLs];
            NSMutableArray *paths = [NSMutableArray array];
            for (NSURL *url in urlArr) {
                [paths addObject:url.path];
            }
            [self performSelector:@selector(addItemsDelay:) withObject:paths afterDelay:0.3];
        }
    }];
}

- (void)addItemsDelay:(NSMutableArray *)paths {
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *path in paths) {
        BOOL isFolder;
        BOOL ret = [fm fileExistsAtPath:path isDirectory:&isFolder];
        if (ret) {
            IMBDriveModel *uploaditem = [[IMBDriveModel alloc] init];
            [uploaditem setUploadParent:_currentDriveID];
            [uploaditem setUploadDocwsID:_currentGetListPath];
            [uploaditem setFileName:[path lastPathComponent]];
            [uploaditem setLocalPath:path];
            [uploaditem setDriveID:_baseManager.baseDrive.driveID];
            uploaditem.isFolder = isFolder;
            if (isFolder) {
                uploaditem.transferImage = [NSImage imageNamed:@"def_folder_mac32"];
            }else {
                uploaditem.fileTypeEnum = [TempHelper getFileFormatWithExtension:[path pathExtension]];
                uploaditem.transferImage = [TempHelper loadFileTransferImage:uploaditem.fileTypeEnum];
            }
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] fileAttributesAtPath:path traverseLink:YES];
            unsigned long long length = [fileAttributes fileSize];
            uploaditem.fileSize = length;
            [ary addObject:uploaditem];
            [uploaditem release];
            uploaditem = nil;
        }
    }
    IMBTransferViewController *transferView = [IMBCloudManager singleton].transferViewController;;
    [transferView addNewUploadAry:ary];
    IMBMainPageViewController *mainPageView = (IMBMainPageViewController *)_displayDelegate;
    //TODO: HUYUMIN 这个个数可能需要修改
    [mainPageView showTransferTipViewWithCount:(int)ary.count isDownLoad:NO];
    [_baseManager uploadItems:ary];
    [ary release];
    ary = nil;
}

//删除
- (void)deleteFile:(id)sender {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSuperView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    
    int result = [_alertViewController showAlertText:CustomLocalizedString(@"CWTip_DeleteFile", nil) withCancelButton:CustomLocalizedString(@"Button_Cancel", nil) withOKButton:CustomLocalizedString(@"Button_Yes", nil) withSuperView:view];
    if (result) {
        [self doSureDelete:sender];
    }
}

- (void)doSureDelete:(id)sender {
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    
    if ([sender isKindOfClass:[IMBDriveModel class]]) {
        [ary addObject:sender];
    } else {
        NSIndexSet *selectedSet = [self selectedItems];
        if (selectedSet.count == 0) {
            [ary release];
            ary = nil;
            //TODO:提示窗口
            return;
        }
        NSArray *displayArr = nil;
        if (_isSearch) {
            displayArr = _searchAryM;
        }else {
            displayArr = _dataSourAryM;
        }
        [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            IMBDriveModel *driveModel = [displayArr objectAtIndex:idx];
            if ([_baseManager.baseDrive.driveType isEqualToString:iCloudDriveCSEndPointURL]) {
                [_baseManager setDelegate:self];
                [ary addObject:@{@"etag":driveModel.etag,@"drivewsid":driveModel.itemIDOrPath}];
            }else {
                [ary addObject:@{@"itemIDOrPath":driveModel.itemIDOrPath,@"isFolder":@(driveModel.isFolder)}];
            }
        }];
    }
    [self loadDeletePromtViewTitle:CustomLocalizedString(@"MainTopTips_deleteTips", nil)];
    [_baseManager deleteDriveItem:ary];
    [ary release];
    ary = nil;
}

//重命名
- (void)rename:(id)sender {
    if (_curSelectView == 1) {
        NSMutableArray *preparedArray = [NSMutableArray array];
        __block NSUInteger index = -1;
        
        if ([sender isKindOfClass:[IMBDriveModel class]]) {
            index = [_dataSourAryM indexOfObject:sender];
            [preparedArray addObject:sender];
        } else {
            NSIndexSet *selectedSet = [self selectedItems];
            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                [preparedArray addObject:[_dataSourAryM objectAtIndex:idx]];
                if (index == -1) {
                    index = idx;
                }
            }];
        }
        
        if (preparedArray.count > 0) {
            _renameDriveModel = [preparedArray objectAtIndex:0];
            _renameDriveModel.isForbiddden = YES;
            NSCollectionViewItem *viewItem = [_collectionView itemAtIndex:index];
            CloudItemView *itemView = (CloudItemView *)viewItem.view;
            itemView.isRename = YES;
            _renameItemView = itemView;
            [itemView.textFiled setSelectable:YES];
            [itemView.textFiled setEditable:YES];
            NSEvent *event = nil;
            [itemView.textFiled mouseDown:event];
            [itemView.textFiled becomeFirstResponder];
            _isRenameing = YES;
        }
    } else {
        if ([sender isKindOfClass:[IMBDriveModel class]]) {
            NSInteger index = [_dataSourAryM indexOfObject:sender];
            _selectedCell = [_itemTableView viewAtColumn:0 row:index makeIfNecessary:NO];
        }
        if (_selectedCell) {
            _renameDriveModel = _selectedCell.model;
            _renameDriveModel.isForbiddden = YES;
            [_selectedCell.fileName setSelectable:YES];
            [_selectedCell.fileName setEditable:YES];
            [_selectedCell.fileName becomeFirstResponder];
            _isRenameing = YES;
        }
    }
}

- (void)saveRenameModel:(IMBDriveModel *)driveModel withStr:(NSString *)str {
    NSString *newName = @"";
    if (driveModel.isFolder) {
        newName = str;
    }else {
        FileTypeEnum fileType =[TempHelper getFileFormatWithExtension:str.pathExtension];
        if (fileType == CommonFile) {
           newName = [NSString stringWithFormat:@"%@.%@",str,driveModel.extension];
        }else {
            newName = str;
        }
    }
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    if ([_baseManager.baseDrive.driveType isEqualToString:DropboxCSEndPointURL]) {
        [ary addObject:@{@"itemIDOrPath":driveModel.filePath,@"isFolder":[NSNumber numberWithBool:driveModel.isFolder]}];
    }else if ([_baseManager.baseDrive.driveType isEqualToString:iCloudDriveCSEndPointURL]) {
        [ary addObject:@{@"drivewsid":driveModel.itemIDOrPath,@"etag":driveModel.etag,@"name":newName}];
    }else {
        [ary addObject:@{@"itemIDOrPath":driveModel.itemIDOrPath,@"isFolder":[NSNumber numberWithBool:driveModel.isFolder]}];
    }
    [_baseManager reName:newName idOrPathArray:ary withEntity:_renameDriveModel];
    [ary release];
    ary = nil;
}

//新建
- (void)createFolder:(id)sender {
    if (_dataSourAryM != nil) {
        [_collectionView deselectAll:nil];
    }
    if (_newDriveModel) {
        [_newDriveModel release];
        _newDriveModel = nil;
    }
    _newDriveModel = [[IMBDriveModel alloc]init];
    _newDriveModel.isFolder = YES;
    _newDriveModel.extension = @"Folder";
    _newDriveModel.iConimage = [NSImage imageNamed:@"def_folder_mac"];
    _newDriveModel.transferImage = [NSImage imageNamed:@"def_folder_mac32"];
    _newDriveModel.fileName = CustomLocalizedString(@"Mouse_Right_Menu_7", nil);
    _newDriveModel.displayName = CustomLocalizedString(@"Mouse_Right_Menu_7", nil);
    _newDriveModel.fileTypeEnum = Folder;
    _newDriveModel.isForbiddden = YES;
    [_dataSourAryM insertObject:_newDriveModel atIndex:0];
    [_collectionView reloadData];
    [_itemTableView reloadData];
    [self performSelector:@selector(setCreateFolderIsEditing) withObject:nil afterDelay:0.1];
}

- (void)preViewFile:(id)sender {
    
}

//在新建文件夹的时候 让名字处于编辑状态
- (void)setCreateFolderIsEditing {
    if (_curSelectView == 1) {
        _newDriveModel = [_dataSourAryM objectAtIndex:0];
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:0];
        [_collectionView setSelectionIndexes:set];
        
        NSCollectionViewItem *viewItem = [_collectionView itemAtIndex:0];
        _cloudItemView = (CloudItemView *)viewItem.view;
        if (_cloudItemView.isSelected) {
            _cloudItemView.isRename = YES;
            _newDriveItemView = _cloudItemView;
            NSString *str = CustomLocalizedString(@"Mouse_Right_Menu_7", nil);
            NSString *newName = [TempHelper getFilePathAlias:str withary:_dataSourAryM WithIsFolder:YES];
            _newDriveItemView.model.displayName = newName;
            _newDriveModel.displayName = newName;
            [_cloudItemView.textFiled setStringValue:newName];
            [_cloudItemView.textFiled setSelectable:YES];
            [_cloudItemView.textFiled setEditable:YES];
            NSEvent *event = nil;
            [_cloudItemView.textFiled mouseDown:event];
            [_cloudItemView.textFiled becomeFirstResponder];
            _isCreateFolder = YES;
        }
    }else {
        _selectedCell = [_itemTableView viewAtColumn:0 row:0 makeIfNecessary:NO];
        if (_selectedCell) {
            NSString *str = CustomLocalizedString(@"Mouse_Right_Menu_7", nil);
            NSString *newName = [TempHelper getFilePathAlias:str withary:_dataSourAryM WithIsFolder:YES];
            _newDriveModel = _selectedCell.model;
            _newDriveModel.displayName = newName;
            [_selectedCell.fileName setStringValue:newName];
            [_selectedCell.fileName setSelectable:YES];
            [_selectedCell.fileName setEditable:YES];
            [_selectedCell.fileName becomeFirstResponder];
            _isCreateFolder = YES;
        }
    }
}

//移动
- (void)move:(id)sender {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSuperView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    
    __block NSMutableArray *seletedAyM = [[NSMutableArray alloc] init];
    __block NSMutableArray *ary = [[NSMutableArray alloc]init];
    if ([sender isKindOfClass:[IMBToolBarButton class]]) {
        NSIndexSet *selectedSet = [self selectedItems];
       [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            IMBDriveModel *driveModel = [_dataSourAryM objectAtIndex:idx];
           [seletedAyM addObject:driveModel];
           
           if ([_baseManager.baseDrive.driveType isEqualToString:DropboxCSEndPointURL]) {
               [ary addObject:@{@"fromItemIDOrPath":driveModel.filePath,@"isFolder":[NSNumber numberWithBool:driveModel.isFolder]}];
           }else if ([_baseManager.baseDrive.driveType isEqualToString:iCloudDriveCSEndPointURL]) {
               [ary addObject:@{@"drivewsid":driveModel.itemIDOrPath,@"etag":driveModel.etag,@"clientId":driveModel.itemIDOrPath}];
           }else if ([_baseManager.baseDrive.driveType isEqualToString:GoogleDriveCSEndPointURL]){
               [ary addObject:@{@"fromItemIDOrPath":driveModel.itemIDOrPath,@"fromItemParentID":_currentDriveID,@"isFolder":[NSNumber numberWithBool:driveModel.isFolder]}];
           }else if ([_baseManager.baseDrive.driveType isEqualToString:BoxCSEndPointURL]){
               [ary addObject:@{@"fromItemIDOrPath":driveModel.itemIDOrPath,@"fromName":driveModel.displayName,@"isFolder":[NSNumber numberWithBool:driveModel.isFolder]}];
           }else {
               [ary addObject:@{@"fromItemIDOrPath":driveModel.itemIDOrPath,@"isFolder":[NSNumber numberWithBool:driveModel.isFolder]}];
           }
       }];
    } else if ([sender isKindOfClass:[IMBDriveModel class]]) {
        IMBDriveModel *driveModel = sender;
        [seletedAyM addObject:driveModel];
        if ([_baseManager.baseDrive.driveType isEqualToString:DropboxCSEndPointURL]) {
            [ary addObject:@{@"fromItemIDOrPath":driveModel.filePath,@"isFolder":[NSNumber numberWithBool:driveModel.isFolder]}];
        }else if ([_baseManager.baseDrive.driveType isEqualToString:iCloudDriveCSEndPointURL]) {
            [ary addObject:@{@"drivewsid":driveModel.itemIDOrPath,@"etag":driveModel.etag,@"clientId":driveModel.itemIDOrPath}];
        }else if ([_baseManager.baseDrive.driveType isEqualToString:GoogleDriveCSEndPointURL]){
            [ary addObject:@{@"fromItemIDOrPath":driveModel.itemIDOrPath,@"fromItemParentID":_currentDriveID,@"isFolder":[NSNumber numberWithBool:driveModel.isFolder]}];
        }else if ([_baseManager.baseDrive.driveType isEqualToString:BoxCSEndPointURL]){
            [ary addObject:@{@"fromItemIDOrPath":driveModel.itemIDOrPath,@"fromName":driveModel.displayName,@"isFolder":[NSNumber numberWithBool:driveModel.isFolder]}];
        }else {
            [ary addObject:@{@"fromItemIDOrPath":driveModel.itemIDOrPath,@"isFolder":[NSNumber numberWithBool:driveModel.isFolder]}];
        }
    }
    
    [_alertView showMoveDestinationWith:_baseManager SuperView:view withSeletedAyM:seletedAyM isMove:YES  MoveBlock:^(IMBDriveModel *model) {
        [_baseManager setDelegate:self];
        if ([_baseManager.baseDrive.driveType isEqualToString:DropboxCSEndPointURL]) {
            _moveAndCopyFileID = [NSString stringWithFormat:@"%@",model.filePath];
        }else {
            _moveAndCopyFileID = [NSString stringWithFormat:@"%@",model.itemIDOrPath];
        }
        if ([StringHelper stringIsNilOrEmpty:_moveAndCopyFileID]) {
            _moveAndCopyFileID = @"0";
        }
        
        NSString *newParentId = @"";
        if ([_baseManager.baseDrive.driveType isEqualToString:DropboxCSEndPointURL]) {
            newParentId = [NSString stringWithFormat:@"%@",model.filePath];
        }else {
            newParentId = [NSString stringWithFormat:@"%@",model.itemIDOrPath];
        }
        if ([StringHelper stringIsNilOrEmpty:newParentId]) {
            newParentId = @"0";
        }
        [_baseManager moveToNewParent:newParentId idOrPaths:ary];
        [ary release];
        ary = nil;
        [seletedAyM release];
        seletedAyM = nil;
    }];
}

- (void)copy:(id)sender {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSuperView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    
    __block NSMutableArray *seletedAyM = [[NSMutableArray alloc] init];
    __block NSMutableArray *ary = [[NSMutableArray alloc]init];
    if ([sender isKindOfClass:[IMBToolBarButton class]]) {
        NSIndexSet *selectedSet = [self selectedItems];
        [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            IMBDriveModel *driveModel = [_dataSourAryM objectAtIndex:idx];
            [seletedAyM addObject:driveModel];
            if ([_baseManager.baseDrive.driveType isEqualToString:DropboxCSEndPointURL]) {
                [ary addObject:@{@"fromItemIDOrPath":driveModel.filePath,@"isFolder":[NSNumber numberWithBool:driveModel.isFolder]}];
            }else if ([_baseManager.baseDrive.driveType isEqualToString:iCloudDriveCSEndPointURL]) {
                [ary addObject:@{@"drivewsid":driveModel.itemIDOrPath,@"etag":driveModel.etag,@"name":driveModel.displayName}];
            }else {
                [ary addObject:@{@"fromItemIDOrPath":driveModel.itemIDOrPath,@"isFolder":[NSNumber numberWithBool:driveModel.isFolder]}];
            }
        }];
    } else if ([sender isKindOfClass:[IMBDriveModel class]]) {
        IMBDriveModel *driveModel = sender;
        [seletedAyM addObject:driveModel];
        if ([_baseManager.baseDrive.driveType isEqualToString:DropboxCSEndPointURL]) {
            [ary addObject:@{@"fromItemIDOrPath":driveModel.filePath,@"isFolder":[NSNumber numberWithBool:driveModel.isFolder]}];
        }else if ([_baseManager.baseDrive.driveType isEqualToString:iCloudDriveCSEndPointURL]) {
            [ary addObject:@{@"drivewsid":driveModel.itemIDOrPath,@"etag":driveModel.etag,@"name":driveModel.displayName}];
        }else {
            [ary addObject:@{@"fromItemIDOrPath":driveModel.itemIDOrPath,@"isFolder":[NSNumber numberWithBool:driveModel.isFolder]}];
        }
    }
    
    [_alertView showMoveDestinationWith:_baseManager SuperView:view withSeletedAyM:seletedAyM isMove:NO  MoveBlock:^(IMBDriveModel *model) {
        [_baseManager setDelegate:self];
        if ([_baseManager.baseDrive.driveType isEqualToString:DropboxCSEndPointURL]) {
            _moveAndCopyFileID = [NSString stringWithFormat:@"%@",model.filePath];
        }else {
            _moveAndCopyFileID = [NSString stringWithFormat:@"%@",model.itemIDOrPath];
        }
        if ([StringHelper stringIsNilOrEmpty:_moveAndCopyFileID]) {
            _moveAndCopyFileID = @"0";
        }
        NSString *newParentId = @"";
        if ([_baseManager.baseDrive.driveType isEqualToString:DropboxCSEndPointURL]) {
            newParentId = [NSString stringWithFormat:@"%@",model.filePath];
        }else {
            newParentId = [NSString stringWithFormat:@"%@",model.itemIDOrPath];
        }
        if ([StringHelper stringIsNilOrEmpty:newParentId]) {
            newParentId = @"0";
        }
        [_baseManager copyToNewParentIDOrPath:newParentId idOrPathArray:ary];
        [ary release];
        ary = nil;
        [seletedAyM release];
        seletedAyM = nil;
    }];
}

- (void)showDetailView:(id)sender {
    
}

- (void)doSwitchView:(id)sender {
    
}

- (void)itemStar:(IMBDriveModel * _Nonnull)model {
    
}

- (void)itemShare:(IMBDriveModel * _Nonnull)model {
    
}

- (void)itemSync:(IMBDriveModel * _Nonnull)model {
    
}

- (void)itemDownload:(IMBDriveModel * _Nonnull)model {
    [self download:model];
}

- (void)itemMore:(IMBDriveModel * _Nonnull)model withBtn:(id _Nonnull)sender {
    
}

- (void)changeCheckButtonState:(IMBDriveModel *)model {
    
}

- (void)cellViewMoreBtn:(IMBDriveModel * _Nonnull)model withMoreBtn:(IMBToolBarButton * _Nonnull)moreBtn {
    
}

- (void)cellCheckButtonClick:(IMBCheckButton * _Nonnull)checkBtn withCellRow:(NSInteger)cellRow {
    
}

- (void)collectionViewDoubleClick:(IMBDriveModel * _Nonnull)model {
    
}

- (void)collectionViewRightMouseDownClick:(IMBDriveModel *)model {
    
}

- (void)loadDriveComplete:(NSMutableArray *_Nonnull)ary WithEvent:(ActionTypeEnum)typeEnum {
    
}

- (void)loadDeletePromtViewTitle:(NSString *)title {
    NSRect titleRect = [StringHelper calcuTextBounds:title font:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    int width = 0;
    width =  titleRect.size.width + 60;
    if (_promptView) {
        [_promptView release];
        _promptView = nil;
    }
    _promptView = [[IMBPromptView alloc]initWithFrame:NSMakeRect(0, 0, width, 36)];
    [_promptView setFillColor:[StringHelper getColorFromString:CustomColor(@"prompt_wait_bgView_fillColor", )] withBorderColor:[StringHelper getColorFromString:CustomColor(@"prompt_wait_bgView_borderColor", )]];
    [_promptView setImage:[NSImage imageNamed:@"detail_loading"] WithTextString:title withIsLoading:YES withIsState:transferringType];
    [self addTipPromptCustomView:_promptView withIsDeleteView:YES];
}

- (void)configDetailViewWith:(IMBDriveModel *_Nonnull)entity {
    
}

- (void)cancelSelectState:(NSInteger)state {
    
}

- (void)showAlertText:(NSString *_Nonnull)alertText OKButton:(NSString *_Nonnull)OkText {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSuperView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    if (view) {
        [view setHidden:NO];
        [_alertViewController showAlertText:alertText withAlertButton:OkText withSuperView:view];
    }
}

- (int)showAlertText:(NSString *)alertText withCancelButton:(NSString *)cancelBtnStr withOKButton:(NSString *)okBtnStr {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSuperView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    
    int result = [_alertViewController showAlertText:alertText withCancelButton:cancelBtnStr withOKButton:okBtnStr withSuperView:view];
    return result;
}

- (void)addTipPromptCustomView:(IMBPromptView *_Nonnull)prompt withIsDeleteView:(BOOL)isdelete {

}

- (void)rightKeyMenuClick:(id)sender {
    
}
@end
