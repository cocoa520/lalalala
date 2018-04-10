//
//  IMBiCloudDriverViewListController.m
//  AnyTrans
//
//  Created by m on 17/2/20.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBiCloudDriverViewListController.h"
#import "IMBImageAndTextCell.h"
#import "ProgressCell.h"
#import "IMBAnimation.h"
@implementation IMBiCloudDriverViewListController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_itemTableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    [_itemTableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
    //注册该表的拖动类型
    [_itemTableView registerForDraggedTypes:[NSArray arrayWithObjects:NSFilesPromisePboardType,NSFilenamesPboardType,nil]];
    _itemTableView.dataSource = self;
    _itemTableView.delegate = self;
    _itemTableView.allowsMultipleSelection = YES;
    [_itemTableView setListener:self];
    [_itemTableView setFocusRingType:NSFocusRingTypeNone];
    _category = Category_iCloudDriver;
    [_itemTableView setDoubleAction:@selector(doublClick:)];
    [_itemTableView setTarget:self];
    
    int selectCount = self->_arrayController.selectionIndexes.count;
    int allCount = [self->_arrayController.content count];
    if (selectCount == allCount && allCount > 0 ) {
        [_itemTableView changeHeaderCheckState:NSOnState];
    }else if (selectCount == 0)
    {
        [_itemTableView changeHeaderCheckState:NSOffState];
    }else
    {
        [_itemTableView changeHeaderCheckState:NSMixedState];
    }
    [_itemTableView setBackgroundColor:[NSColor clearColor]];
    if (_dataSourceArray.count > 0) {
        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    }
    [_itemTableView reloadData];
}

#pragma mark - Actions
-(void)setAllselectState:(CheckStateEnum)sender{
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[_dataSourceArray count]; i++) {
        IMBiCloudDriveFolderEntity *node = [_dataSourceArray objectAtIndex:i];
        [node setCheckState:sender];
        if (node.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    [_arrayController setSelectionIndexes:set];
    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView reloadData];
}

- (void)doublClick:(id)sender
{
    NSInteger row = [_itemTableView clickedRow];
    if (row == -1) {
        return;
    }
    if (row <[_dataSourceArray count]) {
        IMBiCloudDriveFolderEntity *node = [_dataSourceArray objectAtIndex:row];
        if (![node.type isEqualToString:@"FILE"]) {
            [_itemTableView setCanSelect:NO];
        }else{
            [_itemTableView setCanSelect:YES];
        }
    }
    [_driverCollectionView doubleClick:row];
}

- (void)backAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(treeBack)]) {
        [_delegate treeBack];
    }
}

- (void)nextAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(treeNext)]) {
        [_delegate treeNext];
    }
}

- (void)reload:(id)sender
{
    [_itemTableView setCanSelect:YES];
//    for (int i=0; i<[self.dataSourceArray count];i++) {
//        IMBiCloudDriveFolderEntity *node = [self.dataSourceArray objectAtIndex:i];
//        if (node.isCoping) {
//            [node.listprogressBar removeFromSuperview];
//            [node.listCloseButton removeFromSuperview];
//        }
//    }
    [self.view.window makeFirstResponder:_itemTableView];
    self.dataSourceArray = [_arrayController content];
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    
//    for (int i=0; i<[self.dataSourceArray count];i++) {
//        IMBiCloudDriveFolderEntity *node = [self.dataSourceArray objectAtIndex:i];
//        [node.listprogressBar removeFromSuperview];
//        [node.listCloseButton removeFromSuperview];
//        if (node.checkState == NSOnState) {
//            [set addIndex:i];
//        }
//    }
    [_itemTableView selectRowIndexes:0 byExtendingSelection:NO];
    [_itemTableView reloadData];
}

#pragma mark - NSTableViewDataSource
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 55;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <=0) {
        return nil;
    }
    IMBiCloudDriveFolderEntity *node = [displayArray objectAtIndex:row];
    if ([@"Name" isEqualToString:tableColumn.identifier] ) {
        return node.name;
    }
    if ([@"Time" isEqualToString:tableColumn.identifier]) {
        return node.dateModified;
    }
    if ([@"Type" isEqualToString:tableColumn.identifier]) {
        if (![node.type isEqualToString:@"FILE"]) {
            return CustomLocalizedString(@"Bookmark_id_6", nil);
        }else{
//            return [[node.type pathExtension] uppercaseString];
            return node.extension;
        }
    }
    if ([@"Size" isEqualToString:tableColumn.identifier]) {
        if (![node.type isEqualToString:@"FILE"]) {
            return @"--";
        }else{
            return [StringHelper getFileSizeString:node.size reserved:2];
        }
    }
    if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
        return [NSNumber numberWithInt:node.checkState];
    }
    return @"";
    
}

#pragma mark - NSTableViewDelegate
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    IMBiCloudDriveFolderEntity *node = [_dataSourceArray objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:@"Name"]) {
        IMBImageAndTextCell *imagecell = (IMBImageAndTextCell *)cell;
        [imagecell setImageSize:NSMakeSize(32, 32)];
        imagecell.image = node.image;
    }else if ([tableColumn.identifier isEqualToString:@"Type"])
    {
        ProgressCell *arrowcell = (ProgressCell *)cell;
//        if (node.isCoping) {
//            [node.listprogressBar setIsFastDrive:YES];
//            arrowcell.arrowBtn = node.listprogressBar;
//            arrowcell.closeBtn = node.listCloseButton;
//        }else{
            arrowcell.arrowBtn = nil;
            arrowcell.closeBtn  = nil;
//        }
    }
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    IMBiCloudDriveFolderEntity *node = [_dataSourceArray objectAtIndex:row];
//    if (node.isCoping) {
//        return NO;
//    }else{
        return YES;
//    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <=0) {
        return ;
    }
    NSIndexSet *set = [_itemTableView selectedRowIndexes];
    for (int i=0; i<[displayArray count]; i++) {
        IMBiCloudDriveFolderEntity *node = [displayArray objectAtIndex:i];
        if ([set containsIndex:i]) {
            [node setCheckState:NSOnState];
        }else{
            [node setCheckState:NSOffState];
        }
    }
    if ([set count] > 0) {
        IMBiCloudDriveFolderEntity *node = [displayArray objectAtIndex:[set lastIndex]];
//        NSString *subStr = [node.path substringFromIndex:16];
//        NSString *path = [[NSString stringWithFormat:@"/%@" ,CustomLocalizedString(@"Fast_Drive_id_1", nil)] stringByAppendingString:subStr];
//        [_pathField setStringValue:path];
    }
    [_arrayController setSelectionIndexes:set];
    if ([set count] == [_dataSourceArray count]&&[_dataSourceArray count]>0) {
        [_itemTableView changeHeaderCheckState:NSOnState];
    }else if ([set count] == 0)
    {
        [_itemTableView changeHeaderCheckState:NSOffState];
    }else
    {
        [_itemTableView changeHeaderCheckState:NSMixedState];
    }
    [_driverCollectionView singleClickTableView];
    [_itemTableView reloadData];
}

- (NSArray *)tableView:(NSTableView *)tableView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedRowsWithIndexes:(NSIndexSet *)indexSet
{
    NSArray *namesArray = nil;
    //获取目的url
    BOOL iconHide = NO;
    NSString *url = [dropDestination relativePath];
    //此处调用导出方法
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:indexSet,@"indexSet",url,@"url",tableView,@"tableView", nil];
    [self performSelector:@selector(delayTableViewdragToMac:) withObject:dic afterDelay:0.1];
    iconHide = YES;
    return namesArray;
}

- (void)delayTableViewdragToMac:(NSDictionary *)param
{
    NSIndexSet *indexSet = [param objectForKey:@"indexSet"];
    NSString *url = [param objectForKey:@"url"];
    NSTableView *tableView = [param objectForKey:@"tableView"];
    [self dragToMac:indexSet withDestination:url withView:tableView];
}

- (void)dragToMac:(NSIndexSet *)indexSet withDestination:(NSString *)destinationPath withView:(NSView *)view {
    if (indexSet.count > 0){
        NSViewController *annoyVC = nil;
        long long result = [self checkNeedAnnoy:&(annoyVC)];
        if (result == 0) {
            return;
        }
        [((IMBNewAnnoyViewController *)annoyVC) closeWindow:nil];
        //        destinationPath = [TempHelper createCategoryPath:[TempHelper createExportPath:destinationPath] withString:CustomLocalizedString(@"Fast_Drive_id_1", nil)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self exportSelectedItems:destinationPath];
        });
    }
}

#pragma mark - IMBImageRefreshListListener
- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <=0) {
        return;
    }
    IMBiCloudDriveFolderEntity *node = [displayArray objectAtIndex:index];
//    if (node.isCoping) {
//        return;
//    }
    node.checkState = !node.checkState;
    
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[_dataSourceArray count]; i++) {
        IMBiCloudDriveFolderEntity *item= [_dataSourceArray objectAtIndex:i];
        if (item.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    
    if (node.checkState == NSOnState) {
        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    }else if (node.checkState == NSOffState)
    {
        [_itemTableView deselectRow:index];
    }
    
    if (set.count == _dataSourceArray.count) {
        [_itemTableView changeHeaderCheckState:Check];
    }else if (set.count == 0){
        [_itemTableView changeHeaderCheckState:UnChecked];
    }else{
        [_itemTableView changeHeaderCheckState:SemiChecked];
    }
    [_driverCollectionView->_arrayController setSelectionIndexes:set];
    
    [_driverCollectionView singleClickTableView];
    [_itemTableView reloadData];
}

#pragma mark drop and drag
- (void)dropToTabView:(NSTableView *)tableView paths:(NSArray *)pathArray
{
    if ([_delegate respondsToSelector:@selector(dropToTabView:paths:)]) {
        [_delegate dropToTabView:tableView paths:pathArray];
    }
}


- (void)dealloc
{
    if (_exportFolder != nil) {
        [_exportFolder release];
        _exportFolder = nil;
    }
    [super dealloc];
}

- (void)setTableViewSelectStatus
{
    [_itemTableView setCanSelect:YES];

    [self.view.window makeFirstResponder:_itemTableView];
    self.dataSourceArray = [_arrayController content];
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    
    for (int i=0; i<[self.dataSourceArray count];i++) {
        IMBiCloudDriveFolderEntity *node = [self.dataSourceArray objectAtIndex:i];
        if (node.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView reloadData];
}

#pragma mark - 实现方法

//获得选中的item
- (NSIndexSet *)selectedItems
{
    NSIndexSet *selectedItems = nil;
    if (_arrayController != nil) {
        selectedItems = [_arrayController selectionIndexes];
    }
    return selectedItems;
}

- (void)editFileName {
    NSIndexSet *selectedItems = [self selectedItems];
    if (selectedItems == nil || selectedItems.count>1) {
        [self showAlertText:CustomLocalizedString(@"System_selectOne_item", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }else if (selectedItems.count == 0){
        [self showAlertText:CustomLocalizedString(@"System_selectOne_item", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
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
    IMBiCloudDriveFolderEntity *seletednode = nil;
    NSInteger seleted = [_arrayController selectionIndex];
    if (_dataSourceArray.count <= seleted || seleted == -1) {
        return;
    }
    seletednode = [_dataSourceArray objectAtIndex:seleted];
    NSString *nameString = nil;
    if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        nameString= CustomLocalizedString(@"List_Header_id_Name", nil);
    }else {
        nameString= [NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"List_Header_id_Name", nil),@":"];
    }
    
    
    int i = [_alertViewController showTitleName:nameString InputTextFiledString:seletednode.name OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
    if (i == 1) {
        NSString *str = [[_alertViewController reNameInputTextField] stringValue];
        if ([str isEqualToString:seletednode.name]) {
            [_alertViewController unloadAlertView:_alertViewController.reNameView];
            [_alertViewController.renameLoadingView setHidden:YES];
            return;
        }
        [_alertViewController.renameLoadingView setHidden:NO];
        [_alertViewController.renameLoadingView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [_alertViewController.renameLoadingView setImage:[StringHelper imageNamed:@"registedLoading"]];
        [_alertViewController.renameLoadingView.layer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:-2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
        if (seletednode != nil) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                if ([_delegate respondsToSelector:@selector(doRename: withName:)]) {
                    [_delegate doRename:seletednode withName:str];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [self singlecCick:nil];
                    [_alertViewController unloadAlertView:_alertViewController.reNameView];
                    [_alertViewController.renameLoadingView setHidden:YES];
                    
                    [self reload:nil];
                });
            });
        }
    }
}

- (void)deleteSelectedItems {
    NSIndexSet *selectedSet = [self selectedItems];
    if (selectedSet.count > 0) {
        _isDeletePlaylist = NO;
        NSString *str = nil;
        if (selectedSet.count == 1) {
            str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete_2", nil);
        }else {
            str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete", nil);
        }
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Fast_Drive action:Delete actionParams:@"Fast Drive" label:Start transferCount:selectedSet.count screenView:@"Fast Drive" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)];
    }else {
        //弹出警告确认框
        NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_delete", nil),[StringHelper getCategeryStr:_category]];
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
}

- (void)deleteBackupSelectedItems:(id)sender {
    if (_delArray != nil) {
        [_delArray release];
        _delArray = nil;
    }
    _delArray = [[NSMutableArray alloc]init];
    [_alertViewController._removeprogressAnimationView setProgress:0];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSIndexSet *selectedSet = [self selectedItems];
        NSMutableArray *selectedTracks = [NSMutableArray array];
        [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
            [selectedTracks addObject:[_dataSourceArray objectAtIndex:idx]];
        }];
        //        NSArray *newArray = nil;
        if ([_delegate respondsToSelector:@selector(doDelete:)]) {
            [_delegate doDelete:selectedTracks];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_alertViewController._removeprogressAnimationView setProgress:100];
            double delayInSeconds = 1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [_alertViewController showRemoveSuccessViewAlertText:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil) withCount:selectedSet.count];
                
                //                if ([_delegate respondsToSelector:@selector(doReloadDelete:)] && newArray != nil) {
                //                    [_delegate doReloadDelete:newArray];
                //                }
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:Fast_Drive action:Delete actionParams:@"Fast Drive" label:Finish transferCount:selectedSet.count screenView:@"Fast Drive" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                [_arrayController removeObjects:selectedTracks];
                
                if ([_arrayController.content count] == 0) {
                    NSString *subStr = [[_pathField stringValue] stringByDeletingLastPathComponent];
                    if (subStr != nil && ![subStr isEqualToString:@""]) {
                        [_pathField setStringValue:subStr];
                    }else {
                        [_pathField setStringValue:CustomLocalizedString(@"Fast_Drive_id_1", nil)];
                    }
                }
                
                if ([_delegate respondsToSelector:@selector(setSelectWord: withSelectCount:)]) {
                    [_delegate setSelectWord:[[_arrayController content] count] withSelectCount:[_arrayController selectionIndexes].count];
                }
                
                [self reload:nil];
            });
            
        });
        
    });
    
}

//- (void)exportSelectedItems:(NSString *)exportFolder {
//    NSView *view = nil;
//    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
//        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
//            view = subView;
//            break;
//        }
//    }
//    [view setHidden:NO];
//    [_alertViewController fastDriveExportWindow:[NSString stringWithFormat:CustomLocalizedString(@"ToPCiTunes_Transfer_Title", nil),@"Mac"] SuperView:view];
//    [_alertViewController._removeprogressAnimationView setProgress:0];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSArray *selectedFile = [_arrayController selectedObjects];
//        if (_exportFolder != nil) {
//            [_exportFolder release];
//            _exportFolder = nil;
//        }
//        _exportFolder = [exportFolder retain];
//        IMBFileSystemExport *baseTransfer = [[IMBFileSystemExport alloc] initWithIPodkey:_ipod.uniqueKey exportTracks:selectedFile exportFolder:exportFolder withDelegate:self];
//        [ATTracker event:Fast_Drive action:ContentToMac actionParams:@"Fast Drive" label:Start transferCount:selectedFile.count screenView:@"Fast Drive" screenColor:[IMBSoftWareInfo singleton].curUseSkin userLanguageName:[TempHelper currentSelectionLanguage] customParameters:nil];
//        [baseTransfer startTransfer];
//    });
//}

//传输进度
- (void)transferProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"fast drive progress:%f",progress);
        [_alertViewController._removeprogressAnimationView setProgress:progress];
    });
}
//全部传输成功
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_alertViewController._removeprogressAnimationView setProgressWithOutAnimation:100];
        NSWorkspace *workSpace = [NSWorkspace sharedWorkspace];
        [workSpace openFile:_exportFolder];
        NSString *str = @"";
        NSString *transferCountStr = @"";
        if (successCount> 1) {
            transferCountStr = [NSString stringWithFormat:@"%d/%d",successCount,totalCount];
            str = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_tips", nil),transferCountStr];
        }else {
            transferCountStr = [NSString stringWithFormat:@"%d/%d",successCount,totalCount];
            str = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_tip", nil),transferCountStr];
        }
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Fast_Drive action:ContentToMac actionParams:@"Fast Drive" label:Finish transferCount:successCount screenView:@"Fast Drive" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [_alertViewController showFastDriveSuccessViewAlertText:str withSuccessCountStr:transferCountStr];
    });
}

@end
