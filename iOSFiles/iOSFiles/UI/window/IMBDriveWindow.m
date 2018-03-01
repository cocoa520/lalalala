//
//  IMBDriveWindow.m
//  iOSFiles
//
//  Created by JGehry on 2/27/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBDriveWindow.h"
#import "IMBToolbarWindow.h"
#import "IMBDriveEntity.h"
#import "IMBFolderOrFileButton.h"
#import "IMBSelectionView.h"
#import "HoverButton.h"
#import "DriveItem.h"
@interface IMBDriveWindow ()

@end

@implementation IMBDriveWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (id)initWithDrivemanage:(IMBDriveManage*)driveManage {
    if ([self initWithWindowNibName:@"IMBDriveWindow"]) {
        _drivemanage = [driveManage retain];
        [_drivemanage setDriveWindowDelegate:self];
    }
    return self;
}

- (id)initWithiCloudDriveAry:(NSMutableArray *)dataAry {
    if ([self initWithWindowNibName:@"IMBDriveWindow"]) {

    }
    return self;
}

-(void)awakeFromNib {
    NSButton *btn =  [self.window standardWindowButton:NSWindowCloseButton];
    NSButton *btn2 =  [self.window standardWindowButton:NSWindowZoomButton];
    [btn2 setAction:@selector(zoomWindow:)];
    [btn2 setTarget:self];
    
    [btn setAction:@selector(closeWindow:)];
    [btn setTarget:self];
    [(IMBToolbarWindow *)self.window setTitleBarHeight:20];
    _bindArray = [[NSMutableArray alloc]init];
    [_arrayController addObjects:_drivemanage.driveDataAry];
    [self addNotification];
    
    [_toolBarView setDelegate:self];
    
    _currentDevicePath = @"0";
    _backContainer = [[NSMutableArray alloc] init];
    _nextContainer = [[NSMutableArray alloc] init];
    [self loadButton];
    [_rootBox setContentView:_detailView];
    [self.window makeFirstResponder:_blankCollection];
    _blankCollection.delegate = self;
    [_blankCollection setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    [_blankCollection setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
    [_blankCollection registerForDraggedTypes:[NSArray arrayWithObjects:NSFilesPromisePboardType, NSFilenamesPboardType,NSStringPboardType,nil]];
    [_blankCollection setSelectable:YES];
    [_blankCollection setAllowsMultipleSelection:YES];
    [self.window setMovableByWindowBackground:YES];
}

- (void)loadButton {
    [advanceButton setMouseEnteredImage:[NSImage imageNamed:@"backup_advance_enter"]  mouseExitImage:[NSImage imageNamed:@"backup_advance"] mouseDownImage:[NSImage imageNamed:@"backup_advance2"]  forBidImage:[NSImage imageNamed:@"backup_advance3"]];
    [advanceButton setIsDrawBorder:NO];
    
    [backButton setMouseEnteredImage:[NSImage imageNamed:@"backup_retreat_enter"]  mouseExitImage:[NSImage imageNamed:@"backup_retreat"] mouseDownImage:[NSImage imageNamed:@"backup_retreat2"]  forBidImage:[NSImage imageNamed:@"backup_retreat3"]];
    [backButton setIsDrawBorder:NO];
    
    [backButton setEnabled:NO];
    [backButton setTarget:self];
    [backButton setAction:@selector(backAction:)];
    [advanceButton setEnabled:NO];
    [advanceButton setTarget:self];
    [advanceButton setAction:@selector(nextAction:)];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCoDataSource:) name:BackupItemDoubleClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(singlecCick:) name:BackupItemSingleClick object:nil];
}

#pragma mark - LoadData
- (void)loadSonAryComplete:(NSMutableArray *) sonAry {
    [self removeItemData];
    if (_isReload) {
        _isReload = NO;
        [_arrayController removeObjects:_bindArray];
//        if ([array count]>120) {
//            currentIndex = 0;
//            [self loadItem];
//        }else
//        {
            [_arrayController addObjects:sonAry];
//        }
        
//        if (_category == Category_System) {
//            [_mainBox setContentView:_detailView];
//        }else if (_category == Category_Storage) {
//            if (array.count  ==  0) {
//                [_mainBox setContentView:_noDataView];
//                [self configNoDataView];
//            }else {
//                [_mainBox setContentView:_detailView];
//            }
//        }
//        [_loadingAnimationView endAnimation];
        [_rootBox setContentView:_detailView];
        [_loadAnimation endAnimation];
        [_currentArray removeAllObjects];
        [_currentArray addObjectsFromArray:_bindArray];
        [_blankCollection setSelectionIndexes:nil];

    }else{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:_bindArray],@"array",_currentDevicePath,@"currentDevicePath", nil];
        if ([_backContainer count]>0) {
            [backButton setEnabled:YES];
            [backButton setNeedsDisplay:YES];
        }
        [_backContainer addObject:dic];
        
        [_arrayController removeObjects:_bindArray];
        [_arrayController addObjects:sonAry];
        
        //屏蔽advanceButton按钮，
        NSMutableArray *pathArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in _nextContainer) {
            NSString *Path = [dic objectForKey:@"currentDevicePath"];
            [pathArray addObject:Path];
        }
        if (![pathArray containsObject:_currentDevicePath]) {
            [_nextContainer removeAllObjects];
            [advanceButton setEnabled:NO];
        }
        
        //屏蔽nextButton按钮，
        if ([pathArray containsObject:_currentDevicePath]) {
            NSDictionary *dic = [_nextContainer objectAtIndex:[_nextContainer count] - 1];
            [_nextContainer removeObject:dic];
        }
        if (_nextContainer.count>0) {
            [advanceButton setEnabled:YES];
            [advanceButton setNeedsDisplay:YES];
        }else {
            [advanceButton setEnabled:NO];
            [advanceButton setNeedsDisplay:YES];
        }
        [pathArray release], pathArray = nil;
        [_blankCollection setSelectionIndexes:nil];
    }
  }

#pragma mark - Notification
- (void)changeCoDataSource:(NSNotification *)notification {
    NSCollectionView *view = notification.object;
    if (view == _blankCollection||notification == nil){
        NSInteger selectIndex = [_arrayController selectionIndex];
        if (selectIndex>=0&&selectIndex < [(NSArray *)[_arrayController content] count]) {
            IMBBlankDraggableCollectionView *superView = (IMBBlankDraggableCollectionView *)_blankCollection;
            IMBDriveEntity *driveEntity = [[_arrayController content] objectAtIndex:selectIndex];
            if (driveEntity.isFolder) {
                if (driveEntity.childCount>120) {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        @autoreleasepool {
                           [_drivemanage recursiveDirectoryContentsDics:driveEntity.fileID];
                            _currentDevicePath = driveEntity.fileID;
                        }
                    });
                }else
                {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                         [_drivemanage recursiveDirectoryContentsDics:driveEntity.fileID];
                         _currentDevicePath = driveEntity.fileID;
                    });
                }
            }else
            {
                superView.forBidClick = NO;
            }
        }
    }
//    [self reloadBtn];
}

- (void)singlecCick:(NSNotification *)notification {
    NSCollectionView *view = notification.object;
    if (view == _blankCollection||notification == nil) {
        NSInteger selectIndex = [_arrayController selectionIndex];
        if (selectIndex != -1 && selectIndex < [(NSArray *)[_arrayController content] count]) {
            IMBDriveEntity *selectedNode = [[_arrayController content] objectAtIndex:selectIndex];
            if (selectedNode.fileName != nil) {
////                [_itemTitleField setStringValue:selectedNode.path];
            }
        }else
        {
//            if (_currentDevicePath != nil) {
//                [_itemTitleField setStringValue:_currentDevicePath];
//            }
        }
    }
//    [_itemTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
}

#pragma mark - Action
- (void)refresh {
    [_rootBox setContentView:_loadView];
    [_loadAnimation startAnimation];
    _isReload = YES;
    [advanceButton setEnabled:YES];
    [backButton setEnabled:NO];
    [_drivemanage recursiveDirectoryContentsDics:_currentDevicePath];
}

- (void)toMac {
    NSIndexSet *selectedSet = [self selectedItems];
    NSMutableArray *selectedTracks = [NSMutableArray array];
    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [selectedTracks addObject:[_bindArray objectAtIndex:idx]];
    }];
    
//    for (IMBDriveEntity *driveEntity in selectedTracks) {
//        
//    }
    
    IMBDriveEntity *driveEntity = [selectedTracks objectAtIndex:0];

    DriveItem *downloaditem = [[DriveItem alloc] init];
    downloaditem.itemIDOrPath = driveEntity.fileID;
    downloaditem.fileName = driveEntity.fileName;
    NSUInteger state = driveEntity.isFolder;
    if (state == 1) {
        downloaditem.isFolder = YES;
    }else {
        downloaditem.isFolder = NO;
    }
    [_drivemanage oneDriveDownloadOneItem:downloaditem];
}

- (void)addItems {
    _openPanel = [NSOpenPanel openPanel];
//    _isOpen = YES;
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel setCanChooseFiles:YES];
    [_openPanel setAllowsMultipleSelection:YES];
    [_openPanel beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSFileHandlingPanelOKButton) {
            NSArray *urlArr = [_openPanel URLs];
            NSMutableArray *paths = [NSMutableArray array];
            for (NSURL *url in urlArr) {
                [paths addObject:url.path];
            }
            [self performSelector:@selector(addItemsDelay:) withObject:paths afterDelay:0.1];
        }
//        _isOpen = NO;
    }];

}

- (void)deleteItem {
    NSIndexSet *selectedSet = [self selectedItems];
    NSMutableArray *selectedTracks = [NSMutableArray array];
    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [selectedTracks addObject:[_bindArray objectAtIndex:idx]];
    }];
    NSMutableArray *deleteAry = [[NSMutableArray alloc]init];
    for (IMBDriveEntity *driveEntity in selectedTracks) {
        [deleteAry addObject:driveEntity.fileID];
    }
    [_drivemanage deleteDriveItem:deleteAry];
}

- (void)addItemsDelay:(NSMutableArray *)paths {
    DriveItem *uploaditem = [[DriveItem alloc] init];
    [uploaditem setUploadParent:_currentDevicePath];
     NSString *pathStr = [paths objectAtIndex:0];
    
    [uploaditem setFileName:[pathStr lastPathComponent]];
    [uploaditem setLocalPath:pathStr];
//    NSUInteger state = _dbxIsFolder.state;
//    if (state == 1) {
//        uploaditem.isFolder = YES;
//    }else {
        uploaditem.isFolder = NO;
//    }
    [_drivemanage oneDriveUploadItem:uploaditem];
}

- (void)backAction:(id)sender {
    NSMutableArray *dataArr = nil;
    if ([_backContainer count]>0) {
        if ([_currentArray count]>120) {
            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:_bindArray],@"array",_currentDevicePath,@"currentDevicePath", nil];
            [_nextContainer addObject:dic1];
            
        }else
        {
            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:_bindArray],@"array",_currentDevicePath,@"currentDevicePath", nil];
            [_nextContainer addObject:dic1];
            
        }
        [self removeItemData];
        [_arrayController removeObjects:_bindArray];
        [_currentArray removeAllObjects];
        NSDictionary *dic = [_backContainer objectAtIndex:[_backContainer count] - 1];
        dataArr = [dic objectForKey:@"array"];
        _currentDevicePath = [dic objectForKey:@"currentDevicePath"];
        [_currentArray addObjectsFromArray:dataArr];
        
        if ([dataArr count]>120) {
//            currentIndex = 0;
//            [self loadItem];
        }else
        {
            [_arrayController addObjects:dataArr];
        }
        [_backContainer removeObject:dic];
        if ([_nextContainer count]>0) {
            [advanceButton setEnabled:YES];
            [advanceButton setNeedsDisplay:YES];
        }
        if ([_backContainer count]==0) {
            [backButton setEnabled:NO];
        }
    }else
    {
//        [backButton setEnabled:NO];
    }
    
    [_blankCollection setSelectionIndexes:nil];
    [self singlecCick:nil];
//    [self reloadBtn];
    
}

- (void)nextAction:(id)sender {
    NSMutableArray *dataArr = nil;
    if ([_nextContainer count]>0) {
        if ([_currentArray count]>120) {
            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:_bindArray],@"array",_currentDevicePath,@"currentDevicePath", nil];
            [_backContainer addObject:dic1];
        }else
        {
            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:_bindArray],@"array",_currentDevicePath,@"currentDevicePath", nil];
            [_backContainer addObject:dic1];
        }
        [self removeItemData];
        [_arrayController removeObjects:_bindArray];
        [_currentArray removeAllObjects];
        NSDictionary *dic = [_nextContainer objectAtIndex:[_nextContainer count] - 1];
        dataArr = [dic objectForKey:@"array"];
        _currentDevicePath = [dic objectForKey:@"currentDevicePath"];
        
        [_currentArray addObjectsFromArray:dataArr];
//        if ([dataArr count]>120) {
//            currentIndex = 0;
//            [self loadItem];
//        }else
//        {
        
            [_arrayController addObjects:dataArr];
//        }
        
        [_nextContainer removeObject:dic];
        if ([_backContainer count]>0) {
            [backButton setEnabled:YES];
            [backButton setNeedsDisplay:YES];
        }
        if ([_nextContainer count]==0) {
            [advanceButton setEnabled:NO];
            [advanceButton setNeedsDisplay:YES];
        }
        
    }else
    {
        [advanceButton setEnabled:NO];
        [advanceButton setNeedsDisplay:YES];
    }
    
    [_blankCollection setSelectionIndexes:nil];
    [self singlecCick:nil];
//    [self reloadBtn];
}


- (void)removeItemData {
    for (NSView *subview in [_blankCollection subviews]) {
        if ([subview isKindOfClass:[IMBFolderOrFileCollectionItemView class]]) {
            for (NSView *subview1 in [subview subviews]) {
                if ([subview1 isKindOfClass:[IMBFolderOrFileButton class]]) {
                    [(IMBFolderOrFileButton*)subview1 setSelected:NO];
                    for (id subview2 in [subview1 subviews]) {
                        if ([subview2 isKindOfClass:[IMBFolderOrFileTitleField class]]) {
                            [subview2 setStringValue:@""];
                        }
                        if ([subview2 isKindOfClass:[IMBSelectionView class]]) {
                            for (id image in [(NSView*)subview2 subviews]) {
                                [(NSImageView *)image setImage:nil];
                            }
                        }
                    }
                }
            }
        }
    }
}

//获得选中的item
- (NSIndexSet *)selectedItems {
    NSIndexSet *selectedItems = nil;
    if (_blankCollection != nil) {
        selectedItems = [_arrayController selectionIndexes];
    }
    return selectedItems;
}

- (void)zoomWindow:(id)sender {

}

- (void)closeWindow:(id)sender {
    [self.window close];
}

- (void)dealloc {
    [super dealloc];
    if (_backContainer != nil) {
        [_backContainer release];
        _backContainer = nil;
    }
    if (_nextContainer != nil) {
        [_nextContainer release];
        _nextContainer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BackupItemDoubleClick object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BackupItemSingleClick object:nil];
}

@end
