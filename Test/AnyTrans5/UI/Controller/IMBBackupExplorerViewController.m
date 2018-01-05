//
//  IMBBackupExplorerViewController.m
//  iMobieTrans
//
//  Created by iMobie on 14-7-3.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBackupExplorerViewController.h"
#import "IMBFolderOrFileButton.h"
#import "SimpleNode.h"
#import "IMBFolderOrFileTitleField.h"
#import "IMBNotificationDefine.h"
//#import "IMBExportSetting.h"
#import "IMBBlankDraggableCollectionView.h"
#import "IMBBackupManager.h"
//#import "NSObject+PGPerformSelectorOnMainThreadWithTwoObjects.h"
//#import "IMBFileSystemManager.h"
#import "IMBBackupAllDataViewController.h"
@interface IMBBackupExplorerViewController ()

@end

@implementation IMBBackupExplorerViewController
@synthesize backupFileArray = _backupFileArray;
@synthesize currentDevicePath = _currentDevicePath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDataSource:) name:BackupItemDoubleClick object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(singlecCick:) name:BackupItemSingleClick object:nil];
        _backContainer = [[NSMutableArray array] retain];
        _nextContainer = [[NSMutableArray array] retain];
    }
    return self;
}

- (id)initWithProductVersion:(SimpleNode *)node withDelegate:(id)delegate WithIMBBackupDecryptAbove4:(IMBBackupDecryptAbove4 *)abve4 {
    if ([self initWithNibName:@"IMBBackupExplorerViewController" bundle:nil]) {
        _category = Category_Explorer;
        _delegate = delegate;
        _decryptAbove4 = abve4;
        _decryptPath = [node.decryptPath retain];
        _backupPath = [node.backupPath retain];
        _iosVersion = [node.productVersion retain];
    }
    return self;
}

-(void)loadData:(NSMutableArray *)ary {
    [self setBackupFileArray:ary];
    if (_tempbackupFileArray != nil) {
        [_tempbackupFileArray release];
        _tempbackupFileArray = nil;
    }
    _tempbackupFileArray = [ary retain];
    if (_tempbackupFileArray.count == 0) {
        [_explorerBox setContentView:_noDataView];
        [_noDataTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
        [_noDataTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_81", nil)]];//
    }else{
        SimpleNode *simpleNode = [_tempbackupFileArray objectAtIndex:0];
        [_itemTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [_itemTitleField setStringValue:simpleNode.fileName];
    }
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_noDataTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
        [_noDataTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_81", nil)]];//

    });
}

- (void)awakeFromNib {
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_nodataImageView setImage:[StringHelper imageNamed:@"noData_box"]];
    [_collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor clearColor], nil]];
    [_loadingViewAnimaView startAnimation];
//    [(IMBWhiteView *)self.view setIsNOCanDraw:YES];
    [_explorerBox setContentView:_loadingView];
    [advanceButton setMouseEnteredImage:[StringHelper imageNamed:@"backup_advance_enter"]  mouseExitImage:[StringHelper imageNamed:@"backup_advance"] mouseDownImage:[StringHelper imageNamed:@"backup_advance2"]  forBidImage:[StringHelper imageNamed:@"backup_advance3"]];
    [advanceButton setIsDrawBorder:NO];
    [backButton setMouseEnteredImage:[StringHelper imageNamed:@"backup_retreat_enter"]  mouseExitImage:[StringHelper imageNamed:@"backup_retreat"] mouseDownImage:[StringHelper imageNamed:@"backup_retreat2"]  forBidImage:[StringHelper imageNamed:@"backup_retreat3"]];
    [advanceButton setIsDrawBorder:NO];
    [super awakeFromNib];
    ((IMBBlankDraggableCollectionView *)_collectionView).exploreType = BackupExploreType;
    [_backandnextView setHasBottomBorder:YES];
    [_backandnextView setBottomBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
//     _tempbackupFileArray = [[NSMutableArray alloc] initWithArray:_backupFileArray];
    [self setBackupFileArray:_tempbackupFileArray];
    
    [[backandnext cell] setSegmentStyle:NSSegmentStyleTexturedSquare];
    [[backandnext cell] setTrackingMode:NSSegmentSwitchTrackingMomentary];
    [backandnext setSegmentCount:2];
    [backandnext setImage:[StringHelper imageNamed:@"backup_retreat_no"] forSegment:0];
    [backandnext setImage:[StringHelper imageNamed:@"backup_advance_no"] forSegment:1];
    [backandnext setWidth:20 forSegment:0];
    [backandnext setWidth:20 forSegment:1];
    
    [backandnext setAction:@selector(backAndnext:)];
    [backandnext setTarget:self];
    [backandnext setEnabled:YES];
    [backandnext setEnabled:NO forSegment:0];
    [backandnext setEnabled:NO forSegment:1];
    [backButton setEnabled:NO];
    [backButton setTarget:self];
    [backButton setAction:@selector(backAction:)];
    [advanceButton setEnabled:NO];
    [advanceButton setTarget:self];
    [advanceButton setAction:@selector(nextAction:)];
    self.currentDevicePath = @"/";
    [self singlecCick:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _backup = [IMBBackupManager shareInstance];
        [_backup setIosVersion:_iosVersion];
        NSMutableArray *rootBackupArr = nil;
        if (_decryptAbove4 != nil) {
            rootBackupArr = [_backup getRootArray:_decryptPath];
        }else {
            rootBackupArr = [_backup getRootArray:_backupPath];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setBackupFileArray:rootBackupArr];
            _tempbackupFileArray = [rootBackupArr retain];
            if (_tempbackupFileArray.count == 0) {
                [_explorerBox setContentView:_noDataView];
                [_noDataTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
                [_noDataTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_81", nil)]];
            }else{
                [_explorerBox setContentView:_dataView];
//                SimpleNode *simpleNode = [_tempbackupFileArray objectAtIndex:0];
//                [_itemTitleField setStringValue:simpleNode.fileName];
                [_itemTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
                [_itemTitleField setStringValue:_currentDevicePath];
                [_collectionView setSelectionIndexes:nil];
            }
        });
    });
}

- (void)changeSkin:(NSNotification *)notification
{
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor clearColor], nil]];
    [_backandnextView setBottomBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];

    [_noDataTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [_noDataTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_81", nil)]];//
    
    if (_tempbackupFileArray.count > 0) {
        [_itemTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [_itemTitleField setStringValue:_currentDevicePath];
    }
    [_nodataImageView setImage:[StringHelper imageNamed:@"noData_box"]];
    [backandnext setImage:[StringHelper imageNamed:@"backup_retreat_no"] forSegment:0];
    [backandnext setImage:[StringHelper imageNamed:@"backup_advance_no"] forSegment:1];
//    [_backandnextView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor",nil)]];
    [_dataView setNeedsDisplay:YES];
    [_loadingViewAnimaView setNeedsDisplay:YES];
    [self.view setNeedsDisplay:YES];
    [_backandnextView setNeedsDisplay:YES];
    [_loadingView setNeedsDisplay:YES];
}

- (void)backAndnext:(id)sender {
    NSInteger selectedSegment = backandnext.selectedSegment;
    if (selectedSegment == 0) {
        [self backAction:nil];
    }else{
        [self nextAction:nil];
    }
}

- (void)changeDataSource:(NSNotification *)notification {
    NSCollectionView *view = notification.object;
    if (view == _collectionView||notification == nil) {
    
        NSInteger selectIndex = [_arrayController selectionIndex];
        if (selectIndex >=0&&selectIndex<[(NSArray *)[_arrayController arrangedObjects] count]) {
            
            SimpleNode *selectedNode = [[_arrayController arrangedObjects] objectAtIndex:selectIndex];
            
            if (selectedNode.container) {
                if (_tempbackupFileArray.count>0) {
                    NSArray *array = [NSArray arrayWithArray: _tempbackupFileArray];
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:array,@"array",self.currentDevicePath,@"currentDevicePath", nil];
                    [_backContainer addObject:dic];
                    self.currentDevicePath = selectedNode.path;
                    if ([_backContainer  count]>0) {
                        [backButton setEnabled:YES];
                    }
                    [_tempbackupFileArray removeAllObjects];

                }
                
                [_arrayController setContent:selectedNode.childrenArray];
                [_tempbackupFileArray addObjectsFromArray:selectedNode.childrenArray];
            }
            
            //屏蔽advanceButton按钮，
            NSMutableArray *pathArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in _nextContainer) {
                NSString *Path = [dic objectForKey:@"currentDevicePath"];
                [pathArray addObject:Path];
            }
            if (![pathArray containsObject:self.currentDevicePath]) {
                [_nextContainer removeAllObjects];
                [advanceButton setEnabled:NO];
            }
            
            //屏蔽nextButton按钮，
            NSArray *array = [NSArray arrayWithArray:selectedNode.childrenArray];
             NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:array,@"array",self.currentDevicePath,@"currentDevicePath", nil];
             NSMutableArray *pathArray2 = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in _nextContainer) {
                NSString *path = [dic objectForKey:@"currentDevicePath"];
                [pathArray2 addObject:path];
            }
            if ([pathArray containsObject:self.currentDevicePath]) {
                [_nextContainer removeObject:dic2];
            }
            if (_nextContainer.count>0) {
                [advanceButton setEnabled:YES];
            }else {
                 [advanceButton setEnabled:NO];
            }

        }
        [_collectionView setSelectionIndexes:nil];
        [self singlecCick:nil];
    }
}

- (void)singlecCick:(NSNotification *)notification {

    NSCollectionView *view = notification.object;
//    if (view == _collectionView||notification == nil) {
////        [_collectionView  _indexAtPoint:<#(NSPoint)#>];
//        NSInteger selectIndex = [_arrayController selectionIndex];
//        if (selectIndex != -1 && selectIndex < [[_arrayController content] count]) {
//            SimpleNode *selectedNode = [[_arrayController content] objectAtIndex:selectIndex];
//            if (selectedNode.fileName != nil) {
//                [_itemTitleField setStringValue:selectedNode.fileName];
//            }
//        }
//
//    }
    
    if (view == _collectionView||notification == nil) {
        [_itemTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        NSInteger selectIndex = [_arrayController selectionIndex];
        if (selectIndex != -1 && selectIndex < [(NSArray *)[_arrayController arrangedObjects] count]) {
            SimpleNode *selectedNode = [[_arrayController arrangedObjects] objectAtIndex:selectIndex];
            if (selectedNode.fileName != nil) {
                [_itemTitleField setStringValue:selectedNode.path];
            }
        }else
        {
            [_itemTitleField setStringValue:_currentDevicePath];
        }
        if (![[_itemTitleField.stringValue substringToIndex:0] isEqualToString:@"/" ]&&![_itemTitleField.stringValue isEqualToString:@"/"] ) {
            [_itemTitleField setStringValue:[NSString stringWithFormat:@"%@%@",@"/",_itemTitleField.stringValue]];
        }
    }
}

- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id <NSDraggingInfo>)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation {
    return NSDragOperationNone;
}

#pragma mark - Actions
- (IBAction)backAction:(id)sender {
    NSMutableArray *dataArr = nil;
    if ([_backContainer count]>0) {
        NSArray *arry = [NSArray arrayWithArray:_tempbackupFileArray];
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:arry,@"array",self.currentDevicePath,@"currentDevicePath", nil];
        [_nextContainer addObject:dic1];

        NSDictionary *dic = [_backContainer objectAtIndex:[_backContainer count] - 1];
        dataArr = [dic objectForKey:@"array"];
        self.currentDevicePath = [dic objectForKey:@"currentDevicePath"];
        
        
//        NSDictionary *dic = [_backContainer objectAtIndex:[_backContainer count] - 1];
//        dataArr = [dic objectForKey:@"array"];
//        self.currentDevicePath = [dic objectForKey:@"currentDevicePath"];
//        NSArray *arry = [NSArray arrayWithArray:_tempbackupFileArray];
//        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:arry,@"array",self.currentDevicePath,@"currentDevicePath", nil];
//        [_nextContainer addObject:dic1];
//
          [_tempbackupFileArray removeAllObjects];
        if (dataArr != nil) {
            [_arrayController setContent:dataArr];
            [_tempbackupFileArray addObjectsFromArray:dataArr];
            [_backContainer removeObject:dic];
        }
        
        if ([_nextContainer count]>0) {
            [advanceButton setEnabled:YES];
        }
        if ([_backContainer count]==0) {
            [backButton setEnabled:NO];
        }

    }else
    {
        [backButton setEnabled:NO];
    }
    [_collectionView setSelectionIndexes:nil];
    [self singlecCick:nil];
}

- (IBAction)nextAction:(id)sender {
    NSMutableArray *dataArr = nil;
    if ([_nextContainer count]>0) {
        NSArray *array = [NSArray arrayWithArray:_tempbackupFileArray];
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:array,@"array",self.currentDevicePath,@"currentDevicePath", nil];
        [_backContainer addObject:dic1];
        
        NSDictionary *dic = [_nextContainer objectAtIndex:[_nextContainer count] - 1];
        dataArr = [dic objectForKey:@"array"];
        self.currentDevicePath = [dic objectForKey:@"currentDevicePath"];
        
//        NSDictionary *dic = [_nextContainer objectAtIndex:[_nextContainer count] - 1];
//        dataArr = [dic objectForKey:@"array"];
//        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:_tempbackupFileArray,@"array",self.currentDevicePath,@"currentDevicePath", nil];
//        [_backContainer addObject:dic1];
        [_tempbackupFileArray removeAllObjects];
        
        if (dataArr != nil) {
            [_arrayController setContent:dataArr];
            [_tempbackupFileArray addObjectsFromArray:dataArr];
        }
        [_nextContainer removeObject:dic];
        if (_backContainer.count > 0) {
            [backButton setEnabled:YES];
        }
        if ([_nextContainer count] == 0) {
            [advanceButton setEnabled:NO];
        }
    }else
    {
        [advanceButton setEnabled:NO];
    }
    [_collectionView setSelectionIndexes:nil];
    [self singlecCick:nil];
    
}

- (void)toMac:(id)sender {
    NSIndexSet *selectedSet = [self selectedItems];
    if ([selectedSet count] <= 0) {
        
        NSString *str = nil;
        if (_backupFileArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_transfer", nil),CustomLocalizedString(@"MenuItem_id_81", nil)];
        }else {
            str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        }
        //弹出警告确认框
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }else {
        //弹出路径选择框
        NSOpenPanel *openPanel = [IMBOpenPanel openPanel];
        [openPanel setAllowsMultipleSelection:NO];
        [openPanel setCanChooseFiles:NO];
        [openPanel setCanChooseDirectories:YES];
        [openPanel beginSheetModalForWindow:[(IMBBackupAllDataViewController *)_delegate view].window completionHandler:^(NSInteger result) {
            if (result== NSFileHandlingPanelOKButton) {
                [self performSelector:@selector(systemtoMacDelay:) withObject:openPanel afterDelay:0.1];
            }else{
                NSLog(@"other other other");
            }
        }];
    }
}

- (void)systemtoMacDelay:(NSOpenPanel *)openPanel
{
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        return;
    }
    NSString * path =[[openPanel URL] path];
    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:_category]];
    [self copyCollectionContentToMac:filePath Result:(long long)result AnnoyVC:(NSViewController *)annoyVC];
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    _searchFieldBtn = searchBtn;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fileName CONTAINS[cd] %@ ",searchStr];
        [_arrayController setFilterPredicate:predicate];
    }else{
        _isSearch = NO;
        [_arrayController setFilterPredicate:nil];
    }
}

- (void)reloadTableView{
    [self doSearchBtn:@"" withSearchBtn:_searchFieldBtn];
}

- (void)copyCollectionContentToMac:(NSString *)filePath Result:(long long)result AnnoyVC:(NSViewController *)annoyVC{
    NSArray *selectedFile = [_arrayController selectedObjects];
    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }
    _transferController = [[IMBTransferViewController alloc] initWithType:_category SelectItems:(NSMutableArray *)selectedFile ExportFolder:filePath BackupPath:_backupPath BackUpDecrypt:_decryptAbove4];
    if (result>0) {
        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];

    }else{
        [self animationAddTransferView:_transferController.view];

    }
}

//获得选中的item
- (NSIndexSet *)selectedItems {
    NSIndexSet *selectedItems = nil;
    if (_collectionView != nil) {
        selectedItems = [_arrayController selectionIndexes];
    }
    return selectedItems;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BackupItemDoubleClick object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BackupItemSingleClick object:nil];
    [_tempbackupFileArray release],_tempbackupFileArray = nil;
    [_backContainer release],_backContainer = nil;
    [_nextContainer release],_nextContainer = nil;
    [_backupPath release],_backupPath = nil;
    [_decryptPath release],_decryptPath = nil;
    [_iosVersion release],_iosVersion = nil;
    [super dealloc];
}
@end

@implementation IMBFolderOrFileCollectionViewItem

- (void)awakeFromNib
{

}



- (void)setSelected:(BOOL)selected
{
    id node =  self.representedObject;
    if ([node isKindOfClass:[SimpleNode class]]) {
        SimpleNode *node = self.representedObject;
        if (!node.isCoping) {
            [super setSelected:selected];
            [node setCheckState:selected];
        }else{
            [super setSelected:NO];
            [node setCheckState:NO];
        }
        IMBFolderOrFileCollectionItemView *itemView = (IMBFolderOrFileCollectionItemView *)self.view;
        for (NSView *subview in [itemView subviews]) {
            if ([subview isKindOfClass:[IMBFolderOrFileButton class]]) {
                if (node.isCoping) {
                    [node.coprogressBar setIsFastDrive:YES];
                    [subview addSubview:node.coprogressBar];
                    [subview addSubview:node.coCloseButton];
                }
                if (!node.isCoping) {
                    [((IMBFolderOrFileButton *)subview) setSelected:selected];
                }
            }
        }

    }else {
        [super setSelected:selected];
        [node setCheckState:selected];
        IMBFolderOrFileCollectionItemView *itemView = (IMBFolderOrFileCollectionItemView *)self.view;
        for (NSView *subview in [itemView subviews]) {
            if ([subview isKindOfClass:[IMBFolderOrFileButton class]]) {
                [((IMBFolderOrFileButton *)subview) setSelected:selected];
            }
        }
    }
    
    NSImageView *imageView  = [self.view viewWithTag:101];
    [imageView unregisterDraggedTypes];
}

@end

@implementation IMBFolderOrFileCollectionItemView
@synthesize done = _done;


- (void)mouseDown:(NSEvent *)theEvent {
    IMBBlankDraggableCollectionView *superView = (IMBBlankDraggableCollectionView *)[self superview];
    if (superView.forBidClick) {
      return;
    }
    IMBFolderOrFileButton *button = nil;
    IMBSelectionView *selectionView = nil;
    for (NSView *subview in [self subviews]) {
        if ([subview isKindOfClass:[IMBFolderOrFileButton class]]) {
            button = (IMBFolderOrFileButton *)subview;
        }
    }
    for (NSView *subview in [button subviews]) {
        if ([subview isKindOfClass:[IMBSelectionView class]]) {
            selectionView = (IMBSelectionView *)subview;
        }
    }
    NSPoint mousebuttonPt = [button convertPoint:[theEvent locationInWindow] fromView:nil];
    NSPoint mouseselectionPt = [selectionView convertPoint:[theEvent locationInWindow] fromView:nil];
    IMBFolderOrFileTitleField *titlefield = [self viewWithTag:100];
    NSImageView *imageView  = [self viewWithTag:101];
    BOOL titleinner = NSMouseInRect(mousebuttonPt,[titlefield frame], [self isFlipped]);
    BOOL imageinner = NSMouseInRect(mouseselectionPt,[imageView frame], [self isFlipped]);
    if (titleinner || imageinner) {
        [super mouseDown:theEvent];
        //双击事件
        if (theEvent.clickCount == 2) {
           
           if (superView.exploreType ==  BackupExploreType)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:BackupItemDoubleClick object:superView];
            }else if (superView.exploreType ==  AppDocumentExploreType)
            {
                  superView.forBidClick = YES;
                 [[NSNotificationCenter defaultCenter] postNotificationName:BackupItemDoubleClick object:superView];
            }else if (superView.exploreType ==  FileSystemExploreType)
            {
                superView.forBidClick = YES;
                 [[NSNotificationCenter defaultCenter] postNotificationName:BackupItemDoubleClick object:superView];
            }else if (superView.exploreType == CrashLogExploreType) {
                superView.forBidClick = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:BackupItemDoubleClick object:superView];
            }
        }
        if (theEvent.clickCount == 1) {
            if (superView.exploreType ==  BackupExploreType)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:BackupItemSingleClick object:superView];
            }else if (superView.exploreType ==  AppDocumentExploreType)
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:BackupItemSingleClick object:superView];
            }else if (superView.exploreType ==  FileSystemExploreType)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:BackupItemSingleClick object:superView];
            }else if (superView.exploreType == CrashLogExploreType) {
                [[NSNotificationCenter defaultCenter] postNotificationName:BackupItemSingleClick object:superView];
            }
        }
    }else
    {
        IMBBlankDraggableCollectionView *blankDraggableView = (IMBBlankDraggableCollectionView *)self.superview;
        [blankDraggableView setSelectionIndexes:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyDone:) name:NOTIFY_DONE object:nil];
        NSPoint initialLocation = [theEvent locationInWindow];
        _done = NO;
        NSUInteger eventMask = (NSLeftMouseUpMask | NSLeftMouseDownMask | NSLeftMouseDraggedMask | NSPeriodicMask);
        NSEvent *lastEvent = theEvent;
        while (!_done) {
            lastEvent = [NSApp nextEventMatchingMask:eventMask untilDate:[NSDate date] inMode:NSEventTrackingRunLoopMode dequeue:YES];
            NSEventType eventType = [lastEvent type];
            NSPoint mouseLocationWin = [lastEvent locationInWindow];
            switch (eventType)
            {
                case NSLeftMouseDown:
                    break;
                case NSLeftMouseDragged:
                    if (fabs(mouseLocationWin.x - initialLocation.x) >= 2
                        || fabs(mouseLocationWin.y - initialLocation.y) >= 2)
                    {
                        [super mouseDown:theEvent];
                    }
                    break;
                case NSLeftMouseUp:
                    _done = YES;
                    break;
                default:
                    _done = NO;
                    break;
            }
        }
        
        [[NSNotificationCenter defaultCenter]  postNotificationName:NOTIFY_DONE object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_DONE object:nil];
    }
}

- (void)notifyDone:(NSNotification *)notification {
    NSNumber *number = [notification object];
    BOOL isDone = [number boolValue];
    [self setDone:isDone];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [super mouseUp:theEvent];
    _done = YES;
}

- (void)mouseEntered:(NSEvent *)theEvent {
    IMBBlankDraggableCollectionView *blankDraggableView = (IMBBlankDraggableCollectionView *)self.superview;
    if ([blankDraggableView.collectionItem isKindOfClass:[IMBFolderOrFileCollectionViewItem class]]) {
        NSPoint initialLocation = [theEvent locationInWindow];
        NSPoint location = [blankDraggableView convertPoint:initialLocation fromView:nil];
        NSInteger index = [blankDraggableView _indexAtPoint: location];
        NSArray *contentArray = blankDraggableView.content;
        if (index < [blankDraggableView content].count) {
            SimpleNode *node = [contentArray objectAtIndex:index];
            NSString *str = nil;
            if (node.itemSize == 0) {
                str = [NSString stringWithFormat:@"%@ \n %@:-- \n %@:%@",node.fileName,CustomLocalizedString(@"List_Header_id_Size", nil),CustomLocalizedString(@"List_Header_id_Date", nil),node.creatDate];
            }else {
                str = [NSString stringWithFormat:@"%@ \n %@:%@ \n %@:%@",node.fileName,CustomLocalizedString(@"List_Header_id_Size", nil),[StringHelper getFileSizeString:node.itemSize reserved:2],CustomLocalizedString(@"List_Header_id_Date", nil),node.creatDate];
            }
            [self setToolTip:str];
        }
    }
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    if (_trackingArea)
    {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}


-(void)dealloc{
    [super dealloc];
      [[NSNotificationCenter defaultCenter] removeObserver:self name:BackupItemSingleClick object:nil];
}

@end