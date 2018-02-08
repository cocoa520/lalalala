//
//  IMBiCloudDriverViewController.m
//  AnyTrans
//
//  Created by LuoLei on 17-2-6.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBiCloudDriverViewController.h"
#import "IMBNotificationDefine.h"
#import "IMBBlankDraggableCollectionView.h"
#import "IMBiCloudDriveRootFolderEntity.h"
#import "IMBAnimation.h"
#import "IMBiCloudDriverDListViewController.h"
#import "IMBImageAndTextCell.h"
#import "IMBSegmentedBtn.h"
#import "IMBiCloudMainPageViewController.h"
@implementation IMBiCloudDriverViewController
@synthesize currentArray = _currentArray;
@synthesize currentDevicePath = _currentDevicePath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (void)awakeFromNib
{
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
    [_itemTableView setDoubleAction:@selector(tableViewdoubleClick:)];
    [_itemTableView setTarget:self];
    int selectCount = (int)_arrayController.selectionIndexes.count;
    int allCount = (int)[(NSArray *)_arrayController.content count];
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
    
    _collectionView.delegate = self;
    [_collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    [_collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
    [_collectionView registerForDraggedTypes:[NSArray arrayWithObjects:NSFilesPromisePboardType, NSFilenamesPboardType,NSStringPboardType,nil]];
    [_collectionView setSelectable:YES];
    [_collectionView setAllowsMultipleSelection:YES];
    
    _isCollectionView = YES;
    _icloudListVC = [[IMBiCloudDriverDListViewController alloc] initWithNibName:@"IMBiCloudDriverDListViewController" bundle:nil];
    [_icloudListVC setTarget:self];
    [_itemTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart4:YES];
    [_homePage setTarget:self];
    [_homePage setAction:@selector(closeWindow:)];
    [_homePage setMouseEnteredImage:[StringHelper imageNamed:@"iCloud_close2"] mouseExitImage:[StringHelper imageNamed:@"iCloud_close1"] mouseDownImage:[StringHelper imageNamed:@"iCloud_close3"]];
    [_homePage setIsDrawBorder:NO];
//    [_homePage setMouseEnteredImage:[StringHelper imageNamed:@"fastdriver_home2"]  mouseExitImage:[StringHelper imageNamed:@"fastdriver_home1"] mouseDownImage:[StringHelper imageNamed:@"fastdriver_home3"]  forBidImage:[StringHelper imageNamed:@"fastdriver_home4"]];
//    [_homePage setTarget:self];
//    [_homePage setAction:@selector(closeWindow:)];
    [_separateLine setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];

    
    
    _allDownSize = 0;
    _nowFileSize = 0;
    
    [_homePage setEnabled:NO];
    _totolSize = 0;
    _updateCount = 0;
    _loadOneFileloadsize = 0;
    
    _upLoadTotolSize = 0;
    _upLoadDownTotolSize = 0;
    _upLoadNowDownSize = 0;
   _upLoadLastDownSize = 0;
    [backButton setEnabled:NO];
    [backButton setTarget:self];
    [backButton setAction:@selector(backAction:)];
    [_toolBar loadiCloudButtons:[NSArray arrayWithObjects:@(0),@(17),@(18),@(2),@(20),@(12), nil] Target:self DisplayMode:YES];
    [_toolBar addSubview:backButton];
    [_toolBar addSubview:_homePage];
    
//    [_backandnextView setHasBottomBorder:YES];
//    [_backandnextView setHasTopBorder:YES];
//    [_backandnextView setBottomBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
//    [_backandnextView setTopBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    for (NSView *subView in [[NSApplication sharedApplication].mainWindow.contentView subviews]) {
        if ([subView.identifier isEqualToString:@"topView"]) {
            for (NSView *view in subView.subviews ) {
                if ([view.identifier isEqualToString:@"continueDownBGView"]) {
                    _downloadBgView = (DownLoadView *)view;
                }
            }
        }
    }
    NSButton *downLoadButton = [_downloadBgView viewWithTag:100];
    [downLoadButton setTarget:self];
    [downLoadButton setAction:@selector(popUpContinueDownView:)];
    
    [_collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor clearColor], nil]];
    [_collectionView setFocusRingType:NSFocusRingTypeNone];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_bgView setBackgroundColor:[NSColor clearColor]];
    _backContainer = [[NSMutableArray alloc] init];
    _fileContainer = [[NSMutableArray alloc] init];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(changeCoDataSource:) name:BackupItemDoubleClick object:nil];
    [nc addObserver:self selector:@selector(singlecCick:) name:BackupItemSingleClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(icloudDriverProgress:) name:ICLOUD_DOWMLOAD_Progress object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(icloudDriverError:) name:ICLOUD_DOWMLOAD_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(icloudGetUploadProgress:) name:ICLOUD_GetUpload_Progress object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(icloudUpLoadReturnValue:) name:ICLOUD_GetUpload_ReturnValue object:nil];
    _dataSourceArray = [[NSMutableArray alloc] init];
    _currentArray = [[NSMutableArray alloc] init];

    [backButton setMouseEnteredImage:[StringHelper imageNamed:@"fastdriver_arrow_left2"] mouseExitImage:[StringHelper imageNamed:@"fastdriver_arrow_left1"] mouseDownImage:[StringHelper imageNamed:@"fastdriver_arrow_left3"]];
    [backButton setIsDrawBorder:NO];
    
//    [backButton setMouseEnteredImage:[StringHelper imageNamed:@"backup_retreat_enter"]  mouseExitImage:[StringHelper imageNamed:@"backup_retreat"] mouseDownImage:[StringHelper imageNamed:@"backup_retreat2"]  forBidImage:[StringHelper imageNamed:@"backup_retreat3"]];
//    [backButton setIsDrawBorder:NO];
    ((IMBBlankDraggableCollectionView *)_collectionView).exploreType = FileSystemExploreType;
    ((IMBBlankDraggableCollectionView *)_collectionView).forBidClick = NO;
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    [_toolBar toolBarButtonIsEnabled:NO];
    [_collectionView setCategory:Category_iCloudDriver];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_iCloudManager getiCloudDriveContent];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadingAnimationView endAnimation];
            [_toolBar toolBarButtonIsEnabled:YES];
            [_homePage setEnabled:YES];
            _selectedNode = _iCloudManager.driveFolderEntity;
            if ([_iCloudManager.driveFolderEntity.fileItemsList count] == 0) {
                [_mainBox setContentView:_noDataView];
            }else{
                [_mainBox setContentView:_detailView];
                [_itemTitleField setStringValue:@"/"];
            }
            [self configNoDataView];
             [_arrayController removeObjects:_dataSourceArray];
             self.currentDevicePath = @"/" ;
            [_fileContainer addObject:_iCloudManager.driveFolderEntity];
            [_arrayController addObjects:_iCloudManager.driveFolderEntity.fileItemsList];
            [_collectionView setSelectionIndexes:nil];
            currentIndex = (int)[_dataSourceArray count];
            [_currentArray addObjectsFromArray:_dataSourceArray];
            
            //检查是否有断点续传的数据
            dispatch_async(dispatch_get_global_queue(0, 0) , ^{
                NSMutableArray *data = [_iCloudManager getContinueDownData];
                if ( [data count] > 0) {
                    [self performSelectorOnMainThread:@selector(popUpContinueDownView:) withObject:data waitUntilDone:NO];
                }
            });
        });
    });

    [[_scrollView contentView] setPostsBoundsChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(boundsDidChangeNotification:) name: NSViewBoundsDidChangeNotification object: [_scrollView contentView]];
  
}

- (void)continueDown:(id)sender
{
    //继续下载
    //_icloudListVC.dataSourceArray 为数据源 需要遍历找出选中的数据
    NSMutableArray *selectArr = [NSMutableArray array];
    NSString *path = nil;
    if (_icloudListVC.dataSourceArray != nil) {
        for (IMBiCloudDriveFolderEntity *entity in _icloudListVC.dataSourceArray) {
            if (entity.checkState) {
                [selectArr addObject:entity];
                if ([StringHelper stringIsNilOrEmpty:path]) {
                    path = entity.downloadPath;
                }
            }
        }
    }
    if (_failedArray != nil) {
        [_failedArray release];
        _failedArray = nil;
    }
    _failedArray = [[NSMutableArray alloc] initWithArray:_icloudListVC.dataSourceArray];
    if ([StringHelper stringIsNilOrEmpty:path]) {
        
    }
    [_icloudListVC cancelContinuDown:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _isResume = YES;
        [self downloadToMac:path withItems:selectArr];
    });
    
}

- (void)cancelContinuDown:(id)sender
{
    [_alertViewController setIsStopPan:YES];
    int result = [self showAlertText:CustomLocalizedString(@"driver_record_cancelItem", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)];
    if (result == 1) {
        [_icloudListVC cancelContinuDown:nil];
        [_iCloudManager deleteContinueDonwData];
    }
    [_alertViewController setIsStopPan:NO];

}

- (void)retToolbar:(IMBToolBarView *)toolbar{
    _toolBar = toolbar;
}

- (void)popUpContinueDownView:(NSMutableArray *)data
{
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    [_icloudListVC showDownListView:view];
    [_icloudListVC setDataSourceArray:data];

}

- (void)boundsDidChangeNotification: (NSNotification *) notification
{
    //此处计算显示出来的itemView有哪些
    //itemView 每一行5个itemView 高170
    int contentOffset = _scrollView.documentVisibleRect.origin.y;
    NSView *doView = (NSView *)_scrollView.documentView;
    if (contentOffset != 0&&contentOffset>doView.frame.size.height - _scrollView.contentView.frame.size.height - 10) {
        if ([_currentArray count]>120) {
            [self loadItem];
        }
    }
}

#pragma mark double click
- (void)changeCoDataSource:(NSNotification *)notification{
    NSCollectionView *view = notification.object;
    if (view == _collectionView||notification == nil){
        NSInteger selectIndex = [_arrayController selectionIndex];
        [self doubleClick:selectIndex];
    }
}

- (void)doubleClick:(NSInteger)selectIndex {
    if (selectIndex>=0&&selectIndex < [[_arrayController arrangedObjects] count]) {
        IMBBlankDraggableCollectionView *superView = (IMBBlankDraggableCollectionView *)_collectionView;
        IMBiCloudDriveFolderEntity *selectedNode = [[_arrayController content] objectAtIndex:selectIndex];
        if (![selectedNode.type isEqualToString:@"FILE"]) {
            [_mainBox setContentView:_loadingView];
            [_loadingAnimationView startAnimation];
            [_toolBar toolBarButtonIsEnabled:NO];
            [_homePage setEnabled:NO];
            [backButton setEnabled:NO];
            [backButton setNeedsDisplay:YES];
            
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [selectedNode.fileItemsList removeAllObjects];
                [_iCloudManager getFolderContent:selectedNode];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_toolBar toolBarButtonIsEnabled:YES];
                    [_homePage setEnabled:YES];
                    [backButton setEnabled:YES];
                    [backButton setNeedsDisplay:YES];
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:_dataSourceArray],@"array",nil];
                    [_backContainer addObject:dic];
                    [_fileContainer addObject:selectedNode];
                    if ([_backContainer  count]>0) {
                        [backButton setEnabled:YES];
                    }
                    [_arrayController removeObjects:_dataSourceArray];
                    superView.forBidClick = NO;
                    [_currentArray removeAllObjects];
                    [_currentArray addObjectsFromArray:selectedNode.fileItemsList];
                    currentIndex = 0;
                    [self loadItem];
                    [_collectionView setSelectionIndexes:nil];
                    [self singlecCick:nil];
                    [_loadingAnimationView endAnimation];
                    [_itemTableView setCanSelect:YES];
                    [_itemTableView reloadData];
                    if ([selectedNode.fileItemsList count] == 0) {
                        [_mainBox setContentView:_noDataView];
                        [self configNoDataView];
                    }else{
                        if (_isCollectionView) {
                            [_mainBox setContentView:_detailView];
                        }else {
                            [_mainBox setContentView:_detailTableView];
                        }
                    }
                });
                
            });
        }else
        {
            superView.forBidClick = NO;
        }
    }
}

- (void)backAction:(id)sender {
    NSMutableArray *dataArr = nil;
    if ([_backContainer count]>0) {
        [_arrayController removeObjects:_dataSourceArray];
        [_currentArray removeAllObjects];
        NSDictionary *dic = [_backContainer objectAtIndex:[_backContainer count] - 1];
        dataArr = [dic objectForKey:@"array"];
        [_currentArray addObjectsFromArray:dataArr];
        if ([dataArr count]>120) {
            currentIndex = 0;
            [self loadItem];
        }else
        {
            [_arrayController addObjects:dataArr];
        }
        if (_fileContainer.count >1) {
            [_fileContainer removeObjectAtIndex:_fileContainer.count -1];
        }
        [_backContainer removeObject:dic];
        if ([_backContainer count]==0) {
            [backButton setEnabled:NO];
        }
    }else
    {
        [backButton setEnabled:NO];
    }
    [_collectionView setSelectionIndexes:nil];
    [self singlecCick:nil];
    if (_fileContainer.count >1) {
        NSString *pathStr = @"";
        if (_backContainer.count ==0) {
            pathStr = [@"/" stringByAppendingPathComponent:_selectedNode.name];
        }else{
            IMBiCloudDriveFolderEntity *selectFile = nil;
            NSString *oldPath = @"/";
            for (int i = 1; i <= _backContainer.count; i++) {
                selectFile = [_fileContainer objectAtIndex:i];
                oldPath = [oldPath stringByAppendingPathComponent:selectFile.name];
            }
            if (![TempHelper stringIsNilOrEmpty:_selectedNode.name]) {
                [oldPath stringByAppendingPathComponent:_selectedNode.name];
            }
            pathStr = oldPath;
        }
        [_itemTitleField setStringValue:pathStr];
//        [_itemTitleField setStringValue:icloudDriverController.name];
    }else{
        [_itemTitleField setStringValue:@"/"];
    }
    
    if ([[_arrayController content] count] == 0) {
        [_mainBox setContentView:_noDataView];
    }else{
        if (_isCollectionView) {
            [_mainBox setContentView:_detailView];
        }else {
            [_mainBox setContentView:_detailTableView];
        }
    }
}

- (void)loadItem{
    if (currentIndex < [_currentArray count]) {
        if ([_currentArray count] - currentIndex>=120&&currentIndex<[_currentArray count]) {
            NSRange range;
            range.location = currentIndex;
            range.length = 120;
            NSIndexSet *set = [[_collectionView selectionIndexes] copy];
            currentIndex = currentIndex+120;
            [_arrayController  addObjects:[_currentArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]]];
            [_collectionView setSelectionIndexes:nil];
            [_collectionView setSelectionIndexes:set];
            [set release];
        }else
        {
            NSRange range;
            range.location = currentIndex;
            range.length = [_currentArray count] - currentIndex;
            currentIndex =  currentIndex + (int)range.length;
            NSIndexSet *set = [[_collectionView selectionIndexes] copy];
            [_arrayController  addObjects:[_currentArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]]];
            [_collectionView setSelectionIndexes:nil];
            [_collectionView setSelectionIndexes:set];
            [set release];
        }
    }
}

- (void)singlecCick:(NSNotification *)notification{
    NSCollectionView *view = notification.object;
    if (notification == nil) {
        return;
    }
    if (view == _collectionView||notification == nil) {
        
        NSInteger selectIndex = [_arrayController selectionIndex];
               NSString *pathStr = @"";
        if (selectIndex != -1 && selectIndex < [[_arrayController content] count]) {
            _selectedNode = [[_arrayController content] objectAtIndex:selectIndex];
        }
        if (_backContainer.count ==0) {
            pathStr = [@"/" stringByAppendingPathComponent:_selectedNode.name];
        }else{
            IMBiCloudDriveFolderEntity *selectFile = nil;
            NSString *oldPath = @"/";
            for (int i = 1; i <= _backContainer.count; i++) {
                selectFile = [_fileContainer objectAtIndex:i];
                oldPath = [oldPath stringByAppendingPathComponent:selectFile.name];
            }
            if (![TempHelper stringIsNilOrEmpty:_selectedNode.name]) {
               oldPath = [oldPath stringByAppendingPathComponent:_selectedNode.name];
            }
            pathStr = oldPath;
        }
        [_itemTitleField setStringValue:pathStr];
    }
    else{
        NSString *pathStr = nil;
        if (_backContainer.count ==0) {
            pathStr = @"/";
        }else{
            IMBiCloudDriveFolderEntity *selectFile = nil;
            NSString *oldPath = @"/";
            for (int i = 1; i <= _backContainer.count; i++) {
                selectFile = [_fileContainer objectAtIndex:i];
                oldPath = [oldPath stringByAppendingPathComponent:selectFile.name];
            }
            pathStr = oldPath;
        }
        [_itemTitleField setStringValue:pathStr];

//        [_itemTitleField setStringValue:_selectedNode.name];
    }
    [_itemTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
}

- (void)singleClickTableView {
    NSInteger selectIndex = [_arrayController selectionIndex];
    NSString *pathStr = @"";
    if (selectIndex != -1 && selectIndex < [[_arrayController content] count]) {
        _selectedNode = [[_arrayController content] objectAtIndex:selectIndex];
    }
    if (_backContainer.count ==0) {
        pathStr = [@"/" stringByAppendingPathComponent:_selectedNode.name];
    }else{
        IMBiCloudDriveFolderEntity *selectFile = nil;
        NSString *oldPath = @"/";
        for (int i = 1; i <= _backContainer.count; i++) {
            selectFile = [_fileContainer objectAtIndex:i];
            oldPath = [oldPath stringByAppendingPathComponent:selectFile.name];
        }
        if (![TempHelper stringIsNilOrEmpty:_selectedNode.name]) {
            oldPath = [oldPath stringByAppendingPathComponent:_selectedNode.name];
        }
        pathStr = oldPath;
    }
    [_itemTitleField setStringValue:pathStr];
    [_itemTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
}

- (void)configNoDataView {
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iClouddriver"]];
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    NSString *overStr = CustomLocalizedString(@"NO_DATA_TITLE_2", nil);
    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_81", nil)] ;
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_textView setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [promptStr rangeOfString:overStr];
    [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_textView textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
}

- (IBAction)doDeleteItem:(id)sender {
    [self deleteiCloudItems:nil];
}

//删除
- (void)deleteiCloudItems:(id)sender
{
    if (![TempHelper isInternetAvail]) {
        NSString *str = nil;
        str = CustomLocalizedString(@"iCloudLogin_View_Tips2", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    [_alertViewController._removeprogressAnimationView setProgressWithOutAnimation:0];
    [_alertViewController._removeprogressAnimationView setProgress:90];
    NSIndexSet *selectedSet = [_arrayController selectionIndexes];
    if (selectedSet.count > 0) {
        NSString *str = nil;
        if (selectedSet.count == 1) {
            str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete_2", nil);
        }else {
            str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete", nil);
        }
        _alertViewController.isStopPan = NO;
        _alertViewController.isIcloudRemove = YES;
        if ([self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)] == 1) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSArray *selectArr = [_arrayController selectedObjects];
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Drive Delete" label:Start transferCount:selectArr.count screenView:@"iCloud Drive View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                [_iCloudManager deleteiCloudDriveArray:selectArr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_alertViewController._removeprogressAnimationView setProgress:100];
                });
            });
            
            double delayInSeconds = 2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                 NSArray *selectArr = [_arrayController selectedObjects];
                [_alertViewController showRemoveSuccessViewAlertText:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil) withCount:selectArr.count];
                [self iCloudReload:nil];
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Drive Delete" label:Finish transferCount:selectArr.count screenView:@"iCloud Drive View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
            });
        }
       
    }else {
        //弹出警告确认框
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_delete", nil),[StringHelper getCategeryStr:_category]];
        }else {
            str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        }
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
}

//创建文件夹
- (void)createAlbum:(id)sender
{
    if (![TempHelper isInternetAvail]) {
        NSString *str = nil;
        str = CustomLocalizedString(@"iCloudLogin_View_Tips2", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Drive Create Album" label:Start transferCount:0 screenView:@"iCloud Drive View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    NSInteger result = [_alertViewController showTitleName:CustomLocalizedString(@"iCloud_greateFile_FileName", nil) InputTextFiledString:@"" OkButton:CustomLocalizedString(@"Button_Ok", nil)  CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
    
    [_alertViewController.renameLoadingView setHidden:NO];
    [_alertViewController.renameLoadingView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_alertViewController.renameLoadingView setImage:[StringHelper imageNamed:@"registedLoading"]];
    [_alertViewController.renameLoadingView.layer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:-2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
    if (result == 1) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            IMBiCloudDriveFolderEntity *selectFile = nil;
            if (_fileContainer.count >0) {
                selectFile = [_fileContainer objectAtIndex:[_fileContainer count] - 1];
            }
            if ([_backContainer count ] <= 0&&[TempHelper stringIsNilOrEmpty:selectFile.etag]) {
                [_iCloudManager createiCloudDriveFolder:_iCloudManager.driveFolderEntity.drivewsid withFolderName:_alertViewController.reNameInputTextField.stringValue];
            }else{
                [_iCloudManager createiCloudDriveFolder:selectFile.drivewsid withFolderName:_alertViewController.reNameInputTextField.stringValue];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_alertViewController unloadAlertView:_alertViewController.reNameView];
                [self iCloudReload:nil];
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Drive Create Album" label:Finish transferCount:0 screenView:@"iCloud Drive View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                [_alertViewController.renameLoadingView setHidden:YES];
            });
        });
    }
}
//上传
- (void)upLoad:(id)sender
{
    if (![TempHelper isInternetAvail]) {
        NSString *str = nil;
        str = CustomLocalizedString(@"iCloudLogin_View_Tips2", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    
    _openPanel = [NSOpenPanel openPanel];
    _isOpen = YES;
    [_openPanel setAllowsMultipleSelection:YES];
    [_openPanel setCanChooseFiles:YES];
    [_openPanel setCanChooseDirectories:NO];
    [_openPanel beginSheetModalForWindow:[self view].window completionHandler:^(NSInteger result) {
        _isStop = NO;
        _updateCount = 0;
        _upLoadTotolSize = 0;
        _upLoadDownTotolSize = 0;
        _upLoadNowDownSize = 0;
        _upLoadLastDownSize = 0;
        if (result== NSFileHandlingPanelOKButton) {
            NSFileManager *fm = [NSFileManager defaultManager];
            if (_transferController != nil) {
                [_transferController release];
                _transferController = nil;
            }
            _transferController = [[IMBTransferViewController alloc] initWithType:Category_iCloudDriver withDelegate:self withTransfertype:TransferUpLoading];
            [_transferController setDelegate:self];
            _transferController.isicloudView = YES;
            [self animationAddTransferView:_transferController.view];
             if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
                 [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"icloud_drive", nil)]];
             }
            if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
                [_transferController transferProgress:0];
            }
            _alertViewController.isIcloudOneOpen = YES;
            if (![IMBSoftWareInfo singleton].isRegistered) {
//                _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
            }

            NSArray *pathAry = [_openPanel URLs];
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Drive Upload" label:Start transferCount:pathAry.count screenView:@"iCloud Drive View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (NSURL *pathString in pathAry) {
                    NSString * pathString1 = [pathString path];
                    NSDictionary *fileDic = [fm fileAttributesAtPath:pathString1 traverseLink:YES];
                    long long fileSize = [[fileDic objectForKey:NSFileSize] longLongValue];
                    _upLoadTotolSize = _upLoadTotolSize + fileSize;
                }
                for (NSURL *pathStr in pathAry) {
                    _updateCount ++;
                    _upLoadNowDownSize = 0;
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
            //                [_iCloudManager cancel];
                        break;
                    }
                    NSString * path = [pathStr path];
                    if ([fm fileExistsAtPath:path]) {
                        NSString *fileName = [fm displayNameAtPath:path];
                        NSDictionary *fileDic = [fm fileAttributesAtPath:path traverseLink:YES];
                        long long fileSize = [[fileDic objectForKey:NSFileSize] longLongValue];
                        IMBiCloudDriveFolderEntity *selectFile = [_fileContainer objectAtIndex:[_fileContainer count] -1];
                        [_iCloudManager iCloudDriveUpload:path withFileSize:fileSize withZone:selectFile.zone withContentType:@"text/plain"];
                        if (_updateCount == pathAry.count) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [_transferController startTransAnimation];
                            });
                            if (![TempHelper stringIsNilOrEmpty:_upLoadString]) {
                                NSDictionary *retDic = [TempHelper dictionaryWithJsonString:_upLoadString];
                                [_iCloudManager updateFileAfterUpload:retDic withParentDir:selectFile.docwsid withUploadFileName:fileName];
                            }else{
                                _updateCount = _updateCount -1;
                            }
                        }else{
                            if (![TempHelper stringIsNilOrEmpty:_upLoadString]) {
                                NSDictionary *retDic = [TempHelper dictionaryWithJsonString:_upLoadString];
                                [_iCloudManager updateFileAfterUpload:retDic withParentDir:selectFile.docwsid withUploadFileName:fileName];
                            }else{
                                _updateCount = _updateCount -1;
                            }
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_annoyTimer != nil) {
                        [_annoyTimer invalidate];
                        _annoyTimer = nil;
                    }
                    if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                        NSDictionary *dimensionDict = nil;
                        @autoreleasepool {
                            dimensionDict = [[TempHelper customDimension] copy];
                        }
                        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Drive Upload" label:Finish transferCount:_updateCount screenView:@"iCloud Drive View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                        if (dimensionDict) {
                            [dimensionDict release];
                            dimensionDict = nil;
                        }
                        [_transferController transferComplete:_updateCount TotalCount:(int)pathAry.count];
                    }
                });
            });
         }
    }];
}

- (void)dropUpLoad:(NSMutableArray *)pathArray{
    if (![TempHelper isInternetAvail]) {
        NSString *str = nil;
        str = CustomLocalizedString(@"iCloudLogin_View_Tips2", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }
    _isStop = NO;
    _updateCount = 0;
    _upLoadTotolSize = 0;
    _upLoadDownTotolSize = 0;
    _upLoadNowDownSize = 0;
    _upLoadLastDownSize = 0;
    _transferController = [[IMBTransferViewController alloc] initWithType:Category_iCloudDriver withDelegate:self withTransfertype:TransferUpLoading];
    [_transferController setDelegate:self];
    _transferController.isicloudView = YES;
//    [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:nil];
         [self animationAddTransferView:_transferController.view];
    _alertViewController.isIcloudOneOpen = YES;
    if (![IMBSoftWareInfo singleton].isRegistered) {
//        _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
    }
    
    NSMutableArray *pathAry = pathArray;
    for (NSString *pathString in pathAry) {
        NSString * pathString1 = pathString;
        NSDictionary *fileDic = [fm fileAttributesAtPath:pathString1 traverseLink:YES];
        long long fileSize = [[fileDic objectForKey:NSFileSize] longLongValue];
        _upLoadTotolSize = _upLoadTotolSize + fileSize;
    }
    if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
        [_transferController transferProgress:0];
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Drive Upload" label:Start transferCount:pathAry.count screenView:@"iCloud Drive View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSString *pathStr in pathAry) {
            _updateCount ++;
            _upLoadNowDownSize= 0;
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
//                [_iCloudManager cancel];
                break;
            }
            NSString * path = pathStr;
            if ([fm fileExistsAtPath:path]) {
                NSString *fileName = [fm displayNameAtPath:path];
                NSDictionary *fileDic = [fm fileAttributesAtPath:path traverseLink:YES];
                long long fileSize = [[fileDic objectForKey:NSFileSize] longLongValue];
                IMBiCloudDriveFolderEntity *selectFile = [_fileContainer objectAtIndex:[_fileContainer count] -1];
                [_iCloudManager iCloudDriveUpload:path withFileSize:fileSize withZone:selectFile.zone withContentType:@"text/plain"];
                if (_updateCount == pathAry.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_transferController startTransAnimation];
                    });
                    NSDictionary *retDic = [TempHelper dictionaryWithJsonString:_upLoadString];
                    [_iCloudManager updateFileAfterUpload:retDic withParentDir:selectFile.docwsid withUploadFileName:fileName];
                    
                }else{
                    NSDictionary *retDic = [TempHelper dictionaryWithJsonString:_upLoadString];
                    [_iCloudManager updateFileAfterUpload:retDic withParentDir:selectFile.docwsid withUploadFileName:fileName];
                }
//                NSDictionary *retDic = [TempHelper dictionaryWithJsonString:_upLoadString];
//                [_iCloudManager updateFileAfterUpload:retDic withParentDir:selectFile.docwsid withUploadFileName:fileName];
                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_annoyTimer != nil) {
                [_annoyTimer invalidate];
                _annoyTimer = nil;
            }
            if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Drive Upload" label:Finish transferCount:_updateCount screenView:@"iCloud Drive View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                [_transferController transferComplete:_updateCount TotalCount:pathAry.count];
            }
        });
    });

}

//上传进度
- (void)icloudGetUploadProgress:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *info = [notification userInfo];
        _upLoadLastDownSize = _upLoadNowDownSize;
        _upLoadNowDownSize = [[info objectForKey:@"progress"] floatValue];
        if (_upLoadNowDownSize > _upLoadLastDownSize) {
            _upLoadDownTotolSize = _upLoadNowDownSize  - _upLoadLastDownSize + _upLoadDownTotolSize;
        }
        float progress = (_upLoadDownTotolSize / _upLoadTotolSize) * 100;
        [_transferController transferPrepareFileEnd];
        if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
            [_transferController transferProgress:progress];
        }
    });
}

- (void)startTransfer {

}
//下载进度
- (void)icloudDriverProgress:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = [notification userInfo];
        _LastFileSize = _nowFileSize;
        _nowFileSize = [[dic valueForKey:@"DownFileSize"] floatValue];
        if (_nowFileSize > _LastFileSize) {
            _allDownSize = _nowFileSize  - _LastFileSize + _allDownSize;
        }
        [_transferController transferPrepareFileEnd];
        _loadOneFileloadsize = [[dic valueForKey:@"onefileSize"] floatValue];
        float progress = (_allDownSize / _totolSize) * 100;
        if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
            [_transferController transferProgress:progress];
        }
    });
}
//下载失败
- (void)icloudDriverError:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        _successCount --;
        NSDictionary *userInfo = [notification userInfo];
        NSString *errorStr = [userInfo objectForKey:@"Error"];
        if ([errorStr isEqualToString:@"Cancel"]) {
            long long dataLength = [[userInfo objectForKey:@"DataLength"] longLongValue];
            _curDriveEntity.finishSize = dataLength;
        }else {
            _curDriveEntity.finishSize = _nowFileSize;
        }
        if (_failedArray != nil && ![_failedArray containsObject:_curDriveEntity]) {
            [_failedArray addObject:_curDriveEntity];
        }
        _allDownSize =  _allDownSize - _nowFileSize;
        _upLoadNowDownSize = _upLoadNowDownSize - _upLoadNowDownSize;
    });
}
//获取下载后更新的key
- (void)icloudUpLoadReturnValue:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSData *dataM = [info objectForKey:@"dataM"];
    if (_upLoadString != nil) {
        [_upLoadString release];
        _upLoadString = nil;
    }
    _upLoadString = [[NSString alloc] initWithData:dataM encoding:NSUTF8StringEncoding];
}
//下载
- (void)downLoad:(id)sender {
    if (![TempHelper isInternetAvail]) {
        NSString *str = nil;
        str = CustomLocalizedString(@"iCloudLogin_View_Tips2", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    NSIndexSet *indexSet =  [_collectionView selectionIndexes];
    NSMutableArray *items = [NSMutableArray array];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [items addObject:[_dataSourceArray objectAtIndex:idx]];
    }];
    NSLog(@"%d",items.count);
    if (items.count <=0) {
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_transfer", nil),[StringHelper getCategeryStr:_category]];
        }else {
            str = CustomLocalizedString(@"icloudDrive_View_dowunload_Tips", nil);
        }
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }else{
        //弹出路径选择框
        _openPanel = [NSOpenPanel openPanel];
        _isOpen = YES;
        [_openPanel setAllowsMultipleSelection:NO];
        [_openPanel setCanChooseFiles:NO];
        [_openPanel setCanChooseDirectories:YES];
        [_openPanel beginSheetModalForWindow:[self view].window completionHandler:^(NSInteger result) {
            if (result== NSFileHandlingPanelOKButton) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSString *path = [[_openPanel URL] path];
                    path = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:_category]];
                    _isStop = NO;
                    if (_failedArray != nil) {
                        [_failedArray release];
                        _failedArray = nil;
                    }
                    _failedArray = [[NSMutableArray alloc] initWithArray:items];
                    _isResume = NO;
                    [self downloadToMac:path withItems:items];
                });
            }else{
            }
        }];
    }
}
//拖拽下载
- (void)copyInfomationToMac:(NSString *)filePath indexSet:(NSIndexSet *)set{
    if (![TempHelper isInternetAvail]) {
        NSString *str = nil;
        str = CustomLocalizedString(@"iCloudLogin_View_Tips2", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    NSIndexSet *selectedSet = set;
    NSMutableArray *selectedArray = [NSMutableArray array];
    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [selectedArray addObject:[_dataSourceArray objectAtIndex:idx]];
    }];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_failedArray != nil) {
            [_failedArray release];
            _failedArray = nil;
        }
        _failedArray = [[NSMutableArray alloc] initWithArray:selectedArray];
        _isResume = NO;
        [self downloadToMac:filePath withItems:selectedArray];
    });
}

- (void)downloadToMac:(NSString *)path withItems:(NSArray *)items {
    _allDownSize = 0;
    _nowFileSize = 0;
    _totolSize = 0;
    _loadOneFileloadsize = 0;
    _isStop = NO;
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Drive Download" label:Start transferCount:items.count screenView:@"iCloud Drive View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_transferController != nil) {
            [_transferController release];
            _transferController = nil;
        }
        _transferController = [[IMBTransferViewController alloc] initWithType:Category_iCloudDriver withDelegate:self withTransfertype:TransferDownLoad];
        [_transferController setDelegate:self];
        [_transferController setExprtPath:path];
        _transferController.isicloudView = YES;
        _alertViewController.isIcloudOneOpen = YES;
        if (![IMBSoftWareInfo singleton].isRegistered) {
//            _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
        }
        
        [self animationAddTransferView:_transferController.view];
        if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"icloud_drive", nil)]];
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _successCount = 0;
            for (IMBiCloudDriveFolderEntity *driveEntity in items) {
                if (![driveEntity.type isEqualToString:@"FILE"]) {
                    if (driveEntity.fileItemsList.count == 0) {
                        [_iCloudManager getFolderContent:driveEntity];
                    }
                    [self loadFileSize:driveEntity];
                }else{
                    _totolSize = _totolSize + driveEntity.size;
                }
            }
            for (IMBiCloudDriveFolderEntity *driveEntity in items) {
                if ([_failedArray containsObject:driveEntity]) {
                    [_failedArray removeObject:driveEntity];
                }
                _curDriveEntity = driveEntity;
                NSString *newPath = path;
                if (![driveEntity.type isEqualToString:@"FILE"]) {
                    newPath = [newPath stringByAppendingPathComponent:driveEntity.name];
                    if (![[NSFileManager defaultManager] fileExistsAtPath:newPath]) {
                        [[NSFileManager defaultManager] createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    if (driveEntity.fileItemsList.count == 0) {
                        [_iCloudManager getFolderContent:driveEntity];
                    }
                    BOOL ret = [self loadDownNoFile:driveEntity withPath:newPath];
                    if (!ret) {
                        [_failedArray addObject:driveEntity];
                    }
                }else{
                    NSString *url = [_iCloudManager getiCloudDriveFileDownloadInfo:driveEntity.docwsid withZone:driveEntity.zone withExtension:driveEntity.extension];
                    NSString *name = @"";
                    if (![StringHelper stringIsNilOrEmpty:driveEntity.extension]) {
                        name = [driveEntity.name stringByAppendingPathExtension:driveEntity.extension];
                    }else {
                        name = driveEntity.name;
                    }
                    newPath = [newPath stringByAppendingPathComponent:name];
                    if ([url isEqualToString:@""]) {
                        _successCount --;
                        [_failedArray addObject:driveEntity];
                    }else{
                        if (_isResume) {
                            long long startBytes = driveEntity.finishSize;
                            if ([driveEntity.extension isEqualToString:@"pages"] || [driveEntity.extension isEqualToString:@"key"] || [driveEntity.extension isEqualToString:@"numbers"]) {
                                startBytes = 0;
                            }
                            [_iCloudManager iCloudDriveDownload:url withPath:newPath withStartBytes:startBytes];
                        }else {
                            [_iCloudManager iCloudDriveDownload:url withPath:newPath];
                        }
                    }
                    
                }
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
//                    [_iCloudManager cancel];
                    
                    break;
                }
                _successCount ++;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_annoyTimer != nil) {
                    [_annoyTimer invalidate];
                    _annoyTimer = nil;
                }
                if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                    NSDictionary *dimensionDict = nil;
                    @autoreleasepool {
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Drive Download" label:Finish transferCount:_successCount screenView:@"iCloud Drive View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                    if (_successCount <=0) {
                        _successCount = 0;
                    }
                    //保存下载失败或跳过的实体；
                    [self saveFailedFile:_failedArray withPath:path];
                    [_transferController transferComplete:_successCount TotalCount:items.count];
                }
            });
        });
    });
}

- (void)loadFileSize:(IMBiCloudDriveFolderEntity *)folderEntity{
     for (IMBiCloudDriveFolderEntity *driveEntity in folderEntity.fileItemsList) {
         if ([driveEntity.type isEqualToString:@"FILE"]) {
             _totolSize = _totolSize + driveEntity.size;
         }else{
             if (driveEntity.fileItemsList.count == 0) {
                 [_iCloudManager getFolderContent:driveEntity];
             }
             [self loadFileSize:driveEntity];
         }
     }
}

- (BOOL)loadDownNoFile:(IMBiCloudDriveFolderEntity *)folderEntity withPath:(NSString *)path{
    int count = 0;
    BOOL ret = YES;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    for (IMBiCloudDriveFolderEntity *driveEntity in folderEntity.fileItemsList) {
        _curDriveEntity = driveEntity;
        driveEntity.downloadPath = path;
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
//            [_iCloudManager cancel];
            ret =  NO;
            break;
        }
        if ([driveEntity.type isEqualToString:@"FILE"]) {
            
            NSString *name = @"";
            if (![StringHelper stringIsNilOrEmpty:driveEntity.extension]) {
                name = [driveEntity.name stringByAppendingPathExtension:driveEntity.extension];
            }else {
                name = driveEntity.name;
            }
            if (count == 0) {
                path = [path stringByAppendingPathComponent:name];
            }else{
                path = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:name];
            }
            count ++;
            NSString *url = [_iCloudManager getiCloudDriveFileDownloadInfo:driveEntity.docwsid withZone:driveEntity.zone withExtension:driveEntity.extension];
            if ([url isEqualToString:@""]) {
            }else{
                [_iCloudManager iCloudDriveDownload:url withPath:path];
            }
        }else{
            if (driveEntity.fileItemsList.count == 0) {
                [_iCloudManager getFolderContent:driveEntity];
            }
            path = [path stringByAppendingPathComponent:driveEntity.name];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            }
            ret = [self loadDownNoFile:driveEntity withPath:path];
        }
    }
    return ret;
}

- (void)saveFailedFile:(NSArray *)failedArr withPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *failedPath = [[TempHelper getAppDownloadDefaultPath] stringByAppendingPathComponent:@"DriverConfig.plist"];
    if (failedArr.count > 0) {
        NSMutableDictionary *driveDic = nil;
        if ([fm fileExistsAtPath:failedPath]) {
            driveDic = [NSMutableDictionary dictionaryWithContentsOfFile:failedPath];
        }
        if (driveDic == nil){
            driveDic = [NSMutableDictionary dictionary];
        }
        NSMutableArray *arr = [NSMutableArray array];
        
        for (IMBiCloudDriveFolderEntity *failedEntity in failedArr) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (failedEntity.docwsid != nil) {
                [dic setObject:failedEntity.docwsid forKey:@"docwsid"];
            }
            if (failedEntity.name != nil) {
                [dic setObject:failedEntity.name forKey:@"name"];
            }
            if (failedEntity.extension != nil) {
                [dic setObject:failedEntity.extension forKey:@"extension"];
            }
            if (failedEntity.parentId != nil) {
                [dic setObject:failedEntity.parentId forKey:@"parentId"];
            }
            if (failedEntity.type != nil) {
                [dic setObject:failedEntity.type forKey:@"type"];
            }
            if (failedEntity.zone != nil) {
                [dic setObject:failedEntity.zone forKey:@"zone"];
            }
            if (path != nil) {
                [dic setObject:path forKey:@"downloadPath"];
            }
            
            [dic setObject:[NSNumber numberWithLongLong:failedEntity.size] forKey:@"size"];
            [dic setObject:[NSNumber numberWithLongLong:failedEntity.finishSize] forKey:@"finishSize"];
            [arr addObject:dic];
        }
        
        [driveDic setObject:arr forKey:[[_delegate iCloudManager].netClient.loginInfo.appleID lowercaseString]];
        
        [driveDic writeToFile:failedPath atomically:YES];
    }else {
        NSMutableDictionary *driveDic = nil;
        if ([fm fileExistsAtPath:failedPath]) {
            driveDic = [NSMutableDictionary dictionaryWithContentsOfFile:failedPath];
            if ([driveDic.allKeys containsObject:[[_delegate iCloudManager].netClient.loginInfo.appleID lowercaseString]]) {
                [driveDic removeObjectForKey:[[_delegate iCloudManager].netClient.loginInfo.appleID lowercaseString]];
                [driveDic writeToFile:failedPath atomically:YES];
            }
        }
    }
}

//刷新
- (void)iCloudReload:(id)sender {
    if (![TempHelper isInternetAvail]) {
        NSString *str = nil;
        str = CustomLocalizedString(@"iCloudLogin_View_Tips2", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Drive Refresh" label:Start transferCount:0 screenView:@"iCloud Drive View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    [_toolBar toolBarButtonIsEnabled:NO];
    [_homePage setEnabled:NO];
    [backButton setEnabled:YES];
    [backButton setNeedsDisplay:YES];
    IMBiCloudDriveFolderEntity *selectFile = nil;
    if (_fileContainer.count >0) {
         selectFile = [_fileContainer objectAtIndex:[_fileContainer count] - 1];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_backContainer.count ==0&&[TempHelper stringIsNilOrEmpty:selectFile.zone]) {
            [_iCloudManager getiCloudDriveContent];
        }else{
            [backButton setEnabled:NO];
            [backButton setNeedsDisplay:YES];
            [selectFile.fileItemsList removeAllObjects];
            [_iCloudManager getFolderContent:selectFile];
        }
        
//
        dispatch_async(dispatch_get_main_queue(), ^{
            [_toolBar toolBarButtonIsEnabled:YES];
            [_homePage setEnabled:YES];
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:_dataSourceArray],@"array",nil];
//            [_backContainer addObject:dic];
            if ([_backContainer  count]>0) {
                [backButton setEnabled:YES];
            }
            [_arrayController removeObjects:_dataSourceArray];
//            superView.forBidClick = NO;
            
            if ([_backContainer count ] <= 0&&[TempHelper stringIsNilOrEmpty:selectFile.etag]) {
                [_arrayController addObjects:_iCloudManager.driveFolderEntity.fileItemsList];
            }else{
                [_currentArray removeAllObjects];
                [_currentArray addObjectsFromArray:selectFile.fileItemsList];
            }
           
            
            
            currentIndex = 0;
            [self loadItem];
            [_collectionView setSelectionIndexes:nil];
            [self singlecCick:nil];
            [_loadingAnimationView endAnimation];
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Drive Refresh" label:Finish transferCount:0 screenView:@"iCloud Drive View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            if (_backContainer.count ==0&&[TempHelper stringIsNilOrEmpty:selectFile.zone]) {
                if ([_iCloudManager.driveFolderEntity.fileItemsList count] == 0) {
                    [_mainBox setContentView:_noDataView];
                }else{
                    if (_isCollectionView) {
                        [_mainBox setContentView:_detailView];
                    }else {
                        [_mainBox setContentView:_detailTableView];
                    }
                }
            }else{
                if ([selectFile.fileItemsList count] == 0) {
                    [_mainBox setContentView:_noDataView];
                }else{
                    if (_isCollectionView) {
                        [_mainBox setContentView:_detailView];
                    }else {
                        [_mainBox setContentView:_detailTableView];
                    }
                }
            }
        
            [self configNoDataView];
            NSString *pathStr = @"";
            if (_backContainer.count ==0) {
                pathStr = @"/" ;
            }else{
                IMBiCloudDriveFolderEntity *selectFile = nil;
                NSString *oldPath = @"/";
                for (int i = 1; i <= _backContainer.count; i++) {
                    selectFile = [_fileContainer objectAtIndex:i];
                    oldPath = [oldPath stringByAppendingPathComponent:selectFile.name];
                }
//                if (![TempHelper stringIsNilOrEmpty:_selectedNode.name]) {
//                    oldPath = [oldPath stringByAppendingPathComponent:_selectedNode.name];
//                }
                pathStr = oldPath;
            }
            [_itemTitleField setStringValue:pathStr];
        });
        
    });

}

- (IBAction)closeWindow:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
    [self animationRemoveToMacView];
    
}

- (void)animationRemoveToMacView {
    //放开语言设置按钮-----long
    NSString *str = @"open";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    
    [self.view setFrame: NSMakeRect(0, -20, NSWidth(self.view.frame), NSHeight(self.view.frame)+20)];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:@(0) Y:@(20) repeatCount:1];
        anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.view.layer addAnimation:anima1 forKey:@"moveY"];
    } completionHandler:^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:@(20) Y:@(-NSHeight(self.view.frame)) repeatCount:1];
            anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [self.view.layer addAnimation:anima1 forKey:@"moveY"];
            if (_delegate && [_delegate respondsToSelector:@selector(setTrackingAreaEnable:)]) {
                [_delegate setTrackingAreaEnable:YES];
            }
        } completionHandler:^{
            [self.view removeFromSuperview];
            [self release];
        }];
    }];
}

- (void)transferMore:(id)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //检查是否有断点续传的数据
        dispatch_async(dispatch_get_global_queue(0, 0) , ^{
            NSMutableArray *data = [_iCloudManager getContinueDownData];
            if ( [data count] > 0) {
                [self performSelectorOnMainThread:@selector(popUpContinueDownView:) withObject:data waitUntilDone:NO];
            }
        });
    });
    
}

- (void)closeResultWindow:(id)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //检查是否有断点续传的数据
        dispatch_async(dispatch_get_global_queue(0, 0) , ^{
            NSMutableArray *data = [_iCloudManager getContinueDownData];
            if ( [data count] > 0) {
                [self performSelectorOnMainThread:@selector(popUpContinueDownView:) withObject:data waitUntilDone:NO];
            }
        });
    });
}

- (void)dropIcloudToCollectionView:(NSCollectionView *)collectionView paths:(NSMutableArray *)pathArray {
    [self dropUpLoad:pathArray];
}

#pragma DriverListView
- (void)doSwitchView:(id)sender {
    IMBSegmentedBtn *segBtn = (IMBSegmentedBtn *)sender;
    if (segBtn.selectedSegment == 1) {
        if (_dataSourceArray.count >0) {
            [_mainBox setContentView:_detailView];
        }else {
            [_mainBox setContentView:_noDataView];
        }
        _isCollectionView = YES;
    }else {
        if (_dataSourceArray.count > 0) {
            [_mainBox setContentView:_detailTableView];
        }else {
            [_mainBox setContentView:_noDataView];
        }
        _isCollectionView = NO;
    }
}

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

- (void)tableViewdoubleClick:(id)sender {
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
    [self doubleClick:row];
}

#pragma mark - NSTableViewDataSource
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 55;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
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
    if ([@"TimeDate" isEqualToString:tableColumn.identifier]) {
        return [self convertTimeWithString:node.dateModified];
    }
    if ([@"Type" isEqualToString:tableColumn.identifier]) {
        if (![node.type isEqualToString:@"FILE"]) {
            return CustomLocalizedString(@"Bookmark_id_6", nil);
        }else{
            //            return [[node.type pathExtension] uppercaseString];
            return [node.extension uppercaseString];
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
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    IMBiCloudDriveFolderEntity *node = [_dataSourceArray objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:@"Name"]) {
        IMBImageAndTextCell *imagecell = (IMBImageAndTextCell *)cell;
        [imagecell setImageSize:NSMakeSize(32, 32)];
        imagecell.image = node.image;
    }else if ([tableColumn.identifier isEqualToString:@"Type"])
    {
//        ProgressCell *arrowcell = (ProgressCell *)cell;
        //        if (node.isCoping) {
        //            [node.listprogressBar setIsFastDrive:YES];
        //            arrowcell.arrowBtn = node.listprogressBar;
        //            arrowcell.closeBtn = node.listCloseButton;
        //        }else{
//        arrowcell.arrowBtn = nil;
//        arrowcell.closeBtn  = nil;
        //        }
    }
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
//        IMBiCloudDriveFolderEntity *node = [displayArray objectAtIndex:[set lastIndex]];
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
    [self singleClickTableView];
    [_itemTableView reloadData];
}

- (NSArray *)tableView:(NSTableView *)tableView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination forDraggedRowsWithIndexes:(NSIndexSet *)indexSet {
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

- (void)iClouddragDownDataToMac:(NSString *)url {
    [self exportSelectedItems:url];
}

- (void)dragToMac:(NSIndexSet *)indexSet withDestination:(NSString *)destinationPath withView:(NSView *)view {
    if (indexSet.count > 0){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self exportSelectedItems:destinationPath];
            [self copyInfomationToMac:destinationPath indexSet:indexSet];
        });
    }
}

- (void)exportSelectedItems:(NSString*)destinationPath {
    NSIndexSet *indexSet =  [_collectionView selectionIndexes];
    NSMutableArray *items = [[[NSMutableArray alloc] init] autorelease];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [items addObject:[_dataSourceArray objectAtIndex:idx]];
    }];
    [self downloadToMac:destinationPath withItems:items];
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
    [_arrayController setSelectionIndexes:set];
    
    [_itemTableView reloadData];
}

#pragma mark drop and drag
- (void)dropToTabView:(NSTableView *)tableView paths:(NSArray *)pathArray {
    [self dropUpLoad:(NSMutableArray *)pathArray];
}

- (NSString *)convertTimeWithString:(NSString *)timeStr {
    if(timeStr.length >= 19) {
        NSString *str = [timeStr substringToIndex:19];
        str = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSDate *date = [DateHelper dateFromString:str Formate:@"yyyy-MM-dd HH:mm:ss" withTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
        NSTimeInterval interval1 = [DateHelper getTimeStampFrom1970Date:date withTimezone:[NSTimeZone localTimeZone]];
        NSString *str2 = [DateHelper dateFrom1970ToString:interval1 withMode:2];
        return str2;
    }else {
        return @"--";
    }
}

- (void)dealloc {
    [_icloudListVC release],_icloudListVC = nil;
    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }
    if (_annoyTimer != nil) {
        [_annoyTimer invalidate];
        _annoyTimer = nil;
    }
    if (_upLoadString != nil) {
        [_upLoadString release];
        _upLoadString = nil;
    }
    if (_failedArray != nil) {
        [_failedArray release];
        _failedArray = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BackupItemDoubleClick object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BackupItemSingleClick object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ICLOUD_DOWMLOAD_Progress object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ICLOUD_DOWMLOAD_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSViewBoundsDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ICLOUD_GetUpload_ReturnValue object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ICLOUD_GetUpload_Progress object:nil];
    [_fileContainer release],_fileContainer = nil;
    [_backContainer release],_backContainer = nil;
    [super dealloc];
}
@end
