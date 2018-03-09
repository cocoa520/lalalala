//
//  IMBAppsListViewController.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/25.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBAppsListViewController.h"
#import "IMBAppEntity.h"
#import "StringHelper.h"
#import "IMBImageAndTextFieldCell.h"
#import "IMBInformation.h"
#import "IMBInformationManager.h"
#import "NSString+Category.h"
#import "IMBBackgroundBorderView.h"
#import "HoverButton.h"
#import "IMBDeviceInfo.h"
#import "IMBBlankDraggableCollectionView.h"
#import "IMBNotificationDefine.h"
#import "IMBCustomHeaderCell.h"
#import "IMBCommonDefine.h"
#import "TempHelper.h"
#import "IMBAirSyncImportTransfer.h"
#import "IMBDeleteApps.h"
#import "IMBDeleteTrack.h"
#import "IMBAppExport.h"
#import "IMBBetweenDeviceHandler.h"
#import "IMBAnimation.h"
@implementation IMBAppsListViewController
@synthesize itemArray = _itemArray;
@synthesize currentDevicePath = _currentDevicePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod {
    if (self = [self init]) {
        _iPod = [ipod retain];
        _information = [[IMBInformation alloc] initWithiPod:_iPod];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self.view setWantsLayer:YES];
    [self.view.layer setMasksToBounds:YES];
    [self.view.layer setCornerRadius:5];
    [super awakeFromNib];
    [_loadingDataVeiw setIsGradientColorNOCornerPart3:YES];
    [_collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor clearColor], nil]];
    [_collectionView setFocusRingType:NSFocusRingTypeNone];
    [_itemTableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    [_itemTableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
    //注册该表的拖动类型
    [_itemTableView registerForDraggedTypes:[NSArray arrayWithObjects:NSFilesPromisePboardType,NSFilenamesPboardType,nil]];
    _itemTableView.dataSource = self;
    _itemTableView.delegate = self;
    _itemTableView.allowsMultipleSelection = YES;
    [_itemTableView setListener:self];
    [_itemTableView setFocusRingType:NSFocusRingTypeNone];
    
    _rightView.isNOCanDraw = YES;
    [_rightView setIsGradientColorNOCornerPart3:YES];
    nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(changeCoDataSource:) name:BackupItemDoubleClick object:nil];
    [nc addObserver:self selector:@selector(singlecCick:) name:BackupItemSingleClick object:nil];
    [nc addObserver:self selector:@selector(changeCheckBoxState) name:NOTIFY_DONE object:nil];
    

    applicationManger = [_information applicationManager];
    [applicationManger loadAppArray];

    if (applicationManger != nil) {
        _dataSourceArray = (NSMutableArray *)[[applicationManger appEntityArray] retain];
    }
    [_lineView setBackgroundColor:COLOR_TEXT_LINE];
    [_levelLineView setBackgroundColor:COLOR_TEXT_LINE];
    [_topLevelView setBackgroundColor:COLOR_TEXT_LINE];
    _iOSVersion = _iPod.deviceInfo.productVersion;
    
    
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
        [self configNoDataView];
    }else {
        if ([_iOSVersion isVersionMajorEqual:@"8.3"]) {
            [_mainBox setContentView:_containTableView];
            [_itemTableView setListener:self];
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:-1]byExtendingSelection:NO];
        }else {
            [_leftTableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
            [_leftTableView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
            //注册该表的拖动类型
            [_leftTableView registerForDraggedTypes:[NSArray arrayWithObjects:NSFilesPromisePboardType,NSFilenamesPboardType,nil]];
            
            
            [_mainBox setContentView:_containTableCollectView];
            [_leftTableView setFocusRingType:NSFocusRingTypeNone];
            
            [_leftTableView setListener:self];
            _itemArray = [[NSMutableArray alloc] init];
            _nextContainer = [[NSMutableArray alloc] init];
            _backContainer = [[NSMutableArray alloc] init];
            _currentArray = [[NSMutableArray alloc] init];
            [_leftTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
            
            
            [_backButton setTarget:self];
            [_backButton setAction:@selector(backAction:)];
            
            [_advanceButton setTarget:self];
            [_advanceButton setAction:@selector(nextAction:)];
            
            [_advanceButton setMouseEnteredImage:[NSImage imageNamed:@"backup_advance_enter"] mouseExitImage:[NSImage imageNamed:@"backup_advance"] mouseDownImage:[NSImage imageNamed:@"backup_advance2"]  forBidImage:[NSImage imageNamed:@"backup_advance3"]];
            [_backButton setMouseEnteredImage:[NSImage imageNamed:@"backup_retreat_enter"] mouseExitImage:[NSImage imageNamed:@"backup_retreat"] mouseDownImage:[NSImage imageNamed:@"backup_retreat2"]  forBidImage:[NSImage imageNamed:@"backup_retreat3"]];
            [[_scrollView contentView] setPostsBoundsChangedNotifications: YES];
            [_backButton setEnabled:NO];
            [_advanceButton setEnabled:NO];
            [_leftTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]byExtendingSelection:NO];
        }
    }
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
}

- (void)changeSkin:(NSNotification *)notification
{
    [_rightView setIsGradientColorNOCornerPart3:YES];
    [_rightView setNeedsDisplay:YES];
    [_loadingDataVeiw setIsGradientColorNOCornerPart3:YES];
    [_loadingDataVeiw setNeedsDisplay:YES];
    [_collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor clearColor], nil]];
    [_lineView setBackgroundColor:COLOR_TEXT_LINE];
    [_levelLineView setBackgroundColor:COLOR_TEXT_LINE];
    [_topLevelView setBackgroundColor:COLOR_TEXT_LINE];
    [self configNoDataView];
    [_itemTitleField setTextColor:COLOR_TEXT_ORDINARY];
    [_advanceButton setMouseEnteredImage:[NSImage imageNamed:@"backup_advance_enter"] mouseExitImage:[NSImage imageNamed:@"backup_advance"] mouseDownImage:[NSImage imageNamed:@"backup_advance2"]  forBidImage:[NSImage imageNamed:@"backup_advance3"]];
    [_backButton setMouseEnteredImage:[NSImage imageNamed:@"backup_retreat_enter"] mouseExitImage:[NSImage imageNamed:@"backup_retreat"] mouseDownImage:[NSImage imageNamed:@"backup_retreat2"]  forBidImage:[NSImage imageNamed:@"backup_retreat3"]];
    [_loadingView setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}


#pragma mark - NSTextView
- (void)configNoDataView {
    [_noDataImageView setImage:[NSImage imageNamed:@"noData_iTunes_app"]];
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    NSString *overStr = @"";
    promptStr = [@"没有app" stringByAppendingString:overStr];
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [NSColor colorWithDeviceRed:1.0/255 green:150.0/255 blue:235.0/255 alpha:1], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_textView setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [TempHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[NSColor colorWithDeviceRed:1.0/255 green:150.0/255 blue:235.0/255 alpha:1]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [promptStr rangeOfString:overStr];
    [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithDeviceRed:1.0/255 green:150.0/255 blue:235.0/255 alpha:1] range:infoRange];
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

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSMutableArray *disPlayAry = nil;
//    if (_isSearch) {
//        disPlayAry = _researchdataSourceArray;
//    }else{
        disPlayAry = _dataSourceArray;
//    }
    if (disPlayAry.count <= 0 ) {
        return 0;
    }
    return [disPlayAry count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    NSMutableArray *displayArray = nil;
//    if (_isSearch) {
//        displayArray = _researchdataSourceArray;
//    }else{
        displayArray = _dataSourceArray;
//    }
    if (displayArray.count <= 0 ) {
        return 0;
    }
    IMBAppEntity *app = [displayArray objectAtIndex:row];
    if ([@"Name" isEqualToString:tableColumn.identifier] ) {
        return app.appName;
    }else if ([@"Version" isEqualToString:tableColumn.identifier]) {
        return app.version;
    }else if ([@"Minium" isEqualToString:tableColumn.identifier]) {
        return app.minimunOSVerison;
    }else if ([@"AppSize" isEqualToString:tableColumn.identifier]) {
        return [StringHelper getFileSizeString:app.appSize reserved:2];
    }else if ([@"DocumentSize" isEqualToString:tableColumn.identifier]) {
        return [StringHelper getFileSizeString:app.documentSize reserved:2];
    }else if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
        return [NSNumber numberWithInt:app.checkState];
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    
    NSMutableArray *displayArray = nil;
//    if (_isSearch) {
//        displayArray = _researchdataSourceArray;
//    }else{
        displayArray = _dataSourceArray;
//    }
    if (displayArray.count <= 0 ) {
        return ;
    }
    
    IMBAppEntity *entity = [displayArray objectAtIndex:index];
    entity.checkState = !entity.checkState;
    //点击checkBox 实现选中行
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[displayArray count]; i++) {
        IMBAppEntity *entity= [displayArray objectAtIndex:i];
        if (entity.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    
    if ([_iOSVersion isVersionMajorEqual:@"8.3"]) {
//        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
        
        if (set.count == _dataSourceArray.count) {
            [_itemTableView changeHeaderCheckState:NSOnState];
        }else if (set.count == 0){
            [_itemTableView changeHeaderCheckState:NSOffState];
        }else{
            [_itemTableView changeHeaderCheckState:NSMixedState];
        }
    }else {
        if (_currentEntity == entity) {
            if (entity.checkState == NSOnState) {
                //            [_leftTableView selectRowIndexes:set byExtendingSelection:NO];
                [_collectionView selectAll:nil];
                _currentEntity.set = [_collectionView selectionIndexes];
                [_collectionView setSelectionIndexes:_currentEntity.set];
            }else if (entity.checkState == NSOffState)
            {
                [_leftTableView deselectRow:index];
                [_collectionView setSelectionIndexes:nil];
            }
        }
        
        if (set.count == _dataSourceArray.count) {
            [_leftTableView changeHeaderCheckState:NSOnState];
        }else if (set.count == 0){
            [_leftTableView changeHeaderCheckState:NSOffState];
        }else{
            [_leftTableView changeHeaderCheckState:NSMixedState];
        }
        [_leftTableView reloadData];
    }
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSMutableArray *displayArray = nil;
//    if (_isSearch) {
//        displayArray = _researchdataSourceArray;
//    }else{
        displayArray = _dataSourceArray;
//    }
    if (displayArray.count <= 0 ) {
        return ;
    }
    
    if ([@"Name" isEqualToString:tableColumn.identifier] ) {
        IMBAppEntity *app = [displayArray objectAtIndex:row];
        IMBImageAndTextFieldCell *curCell = (IMBImageAndTextFieldCell*)cell;
        if (app.appIconImage == nil) {
            app.appIconImage = [NSImage imageNamed:@"app_default"];
        }
        [curCell setImageSize:NSMakeSize(48, 48)];
        curCell.image = app.appIconImage;
        curCell.paddingX = 2;
        curCell.marginX = 6;
        return;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 60;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSMutableArray *displayArray = nil;
//    if (_isSearch) {
//        displayArray = _researchdataSourceArray;
//    }else{
        displayArray = _dataSourceArray;
//    }
    if (displayArray.count <= 0 ) {
        return ;
    }
     NSTableView *atableView = [notification object];
    if ([_iOSVersion isVersionMajorEqual:@"8.3"]) {
//        NSIndexSet *set = [_itemTableView selectedRowIndexes];
//        for (int i=0; i<[_dataSourceArray count]; i++) {
//            IMBAppEntity *app = [_dataSourceArray objectAtIndex:i];
//            if ([set containsIndex:i]) {
//                [app setCheckState:NSOnState];
//            }else{
//                [app setCheckState:NSOffState];
//            }
//        }
//        if ([set count] == [displayArray count]&&[displayArray count]>0) {
//            [_itemTableView changeHeaderCheckState:NSOnState];
//        }else if ([set count] == 0)
//        {
//            [_itemTableView changeHeaderCheckState:NSOffState];
//        }else
//        {
//            [_itemTableView changeHeaderCheckState:NSMixedState];
//        }
        [_itemTableView reloadData];
    }else {
        if (atableView == _leftTableView) {
            [_itemArray removeAllObjects];
    //        [self showloading:YES baseView:_rightView];
            [_backButton setEnabled:NO];
            [_advanceButton setEnabled:NO];
            [_backContainer removeAllObjects];
            [_nextContainer removeAllObjects];
            NSInteger row = [_leftTableView selectedRow];
            if (row < 0) {
                row = 0;
            }
            _currentEntity = [displayArray objectAtIndex:row];
            
            _appBundle = _currentEntity.appKey;
//            ((IMBBlankDraggableCollectionView *)_collectionView).exploreType = AppDocumentExploreType;
            ((IMBBlankDraggableCollectionView *)_collectionView).forBidClick = NO;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSArray *array = [applicationManger recursiveDirectoryContentsDics:@"/" appBundle:_appBundle];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_arrayController removeObjects:_itemArray];
                    self.currentDevicePath = @"/" ;
                    [_currentArray removeAllObjects];
                    [_currentArray addObjectsFromArray:array];
                    currentIndex = 0;
                    [self loadItem];
                    [_collectionView setSelectionIndexes:nil];
    //                [self showloading:NO baseView:_rightView];
                    
                    [self singlecCick:nil];
                    if (_currentEntity.checkState == UnChecked) {
                        [_collectionView setSelectionIndexes:nil];
                    }else if (_currentEntity.checkState == Check) {
                       [_collectionView selectAll:nil];
                        _currentEntity.set = [_collectionView selectionIndexes];
                       [_collectionView setSelectionIndexes:_currentEntity.set];
                    }else {
                       [_collectionView setSelectionIndexes:_currentEntity.set];
                    }
                    
                });
            });
            [_leftTableView reloadData];
        }
    }
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    id cell = [tableColumn headerCell];
    NSString *identify = [tableColumn identifier];
    NSArray *array = [tableView tableColumns];
    NSMutableArray *displayArray = nil;
//    if (_isSearch) {
//        displayArray = _researchdataSourceArray;
//    }else{
        displayArray = _dataSourceArray;
//    }
    if (displayArray.count <= 0 ) {
        return ;
    }
    for (NSTableColumn  *column in array) {
        if ([column.headerCell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *columnHeadercell = (IMBCustomHeaderCell *)column.headerCell;
            if ([column.identifier isEqualToString:identify]) {
                [columnHeadercell setIsShowTriangle:YES];
            }else {
                [columnHeadercell setIsShowTriangle:NO];
            }
        }
        
    }
	if ( [@"Name" isEqualToString:identify] || [@"Version" isEqualToString:identify] || [@"Minium" isEqualToString:identify] || [@"AppSize" isEqualToString:identify] || [@"DocumentSize" isEqualToString:identify] || [@"Format" isEqualToString:identify]|| [@"Genre" isEqualToString:identify] || [@"Rating" isEqualToString:identify]) {
        if ([cell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *customHeaderCell = (IMBCustomHeaderCell *)cell;
            if (customHeaderCell.ascending) {
                customHeaderCell.ascending = NO;
            }else
            {
                customHeaderCell.ascending = YES;
            }
            [self sort:customHeaderCell.ascending key:identify dataSource:displayArray];
        }
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i=0;i<[_dataSourceArray count]; i++) {
            IMBTrack *track = [_dataSourceArray objectAtIndex:i];
            if (track.checkState == NSOnState) {
                [set addIndex:i];
            }
        }
        
//        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    }

    [_itemTableView reloadData];
}

- (void)sort:(BOOL)isAscending key:(NSString *)key dataSource:(NSMutableArray *)array {
    if ([key isEqualToString:@"Name"]) {
        key = @"appName";
    } else if ([key isEqualToString:@"Version"]) {
        key = @"version";
    }else if ([key isEqualToString:@"Minium"]) {
        key = @"minimunOSVerison";
    } else if ([key isEqualToString:@"AppSize"]) {
        key = @"appSize";
    } else if ([key isEqualToString:@"DocumentSize"]) {
        key = @"documentSize";
    } 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    [_itemTableView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
}

- (void)setAllselectState:(CheckStateEnum)checkState {
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[_dataSourceArray count]; i++) {
        IMBAppEntity *app = [_dataSourceArray objectAtIndex:i];
        [app setCheckState:checkState];
        if (app.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    if ([_iOSVersion isVersionMajorEqual:@"8.3"]) {
//        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
        [_itemTableView reloadData];
    }else {
        
        NSInteger row = [_leftTableView selectedRow];
        if (row >= 0) {
            IMBAppEntity *entity = [_dataSourceArray objectAtIndex:row];
            if (entity.checkState == NSOnState) {
                [_collectionView selectAll:nil];
                 _currentEntity.set = [_collectionView selectionIndexes];
                [_collectionView setSelectionIndexes:_currentEntity.set];
            }else if (entity.checkState == NSOffState)
            {
                [_leftTableView deselectRow:row];
                [_collectionView setSelectionIndexes:nil];
            }
        }
        [_leftTableView reloadData];
    }
}


//如果_itemArray count 大于120 每次加载120 一直到加载完成为止
- (void)loadItem {
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
            NSIndexSet *set = [[_collectionView selectionIndexes] copy];
            currentIndex = currentIndex + (int)range.length;
            [_arrayController  addObjects:[_currentArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]]];
            
            [_collectionView setSelectionIndexes:nil];
            [_collectionView setSelectionIndexes:set];
            [set release];
        }
    }
}

- (void)singlecCick:(NSNotification *)notification {
    NSCollectionView *view = notification.object;
    if (view == _collectionView||notification == nil) {
        NSInteger selectIndex = [_arrayController selectionIndex];
        if (selectIndex != -1 && selectIndex < [(NSArray *)[_arrayController content] count]) {
            SimpleNode *selectedNode = [[_arrayController content] objectAtIndex:selectIndex];
            if (selectedNode.fileName != nil) {
                [_itemTitleField setStringValue:selectedNode.path];
            }
        }else
        {
            [_itemTitleField setStringValue:_currentDevicePath];
        }
       [_itemTitleField setTextColor:COLOR_TEXT_ORDINARY];
    }
}

- (void)changeCoDataSource:(NSNotification *)notification {
    NSCollectionView *view = notification.object;
    if (view == _collectionView||notification == nil) {
        
        NSInteger selectIndex = [_arrayController selectionIndex];
        if (selectIndex >=0&&selectIndex<[(NSArray *)[_arrayController content] count]) {
            IMBBlankDraggableCollectionView *superView = (IMBBlankDraggableCollectionView *)_collectionView;
            SimpleNode *selectedNode = [[_arrayController content] objectAtIndex:selectIndex];
            if (selectedNode.container) {
                if ([self cacuCount:selectedNode.path]>120) {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        @autoreleasepool {
                            NSArray *array = nil;
                            array = [applicationManger recursiveDirectoryContentsDics:selectedNode.path appBundle:_appBundle];
                            
                            if (array == nil) {
                                return ;
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_itemArray,@"array",self.currentDevicePath,@"currentDevicePath", nil];
                                [_backContainer addObject:dic];
                                if ([_backContainer  count]>0) {
                                    [_backButton setEnabled:YES];
                                    [_backandnext setEnabled:YES forSegment:0];
                                }
                                [_arrayController removeObjects:_itemArray];
                                superView.forBidClick = NO;
                                
                                [_currentArray removeAllObjects];
                                [_currentArray addObjectsFromArray:array];
                                currentIndex = 0;
                                [self loadItem];
                                [_collectionView setSelectionIndexes:nil];
//                                if ([_countDelegate respondsToSelector:@selector(reCaulateItemCount)]) {
//                                    
//                                    [_countDelegate reCaulateItemCount];
//                                }
                                self.currentDevicePath = selectedNode.path;
                                [self singlecCick:nil];
                                
                            });
                        }
                    });
                }else
                {
                    [_currentArray removeAllObjects];
                    NSArray *childArray = nil;
                    childArray = [applicationManger recursiveDirectoryContentsDics:selectedNode.path appBundle:_appBundle];
                    
                    if (childArray == nil) {
                        return ;
                    }
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_itemArray,@"array",self.currentDevicePath,@"currentDevicePath", nil];
                    [_backContainer addObject:dic];
                    if ([_backContainer  count]>0) {
                        [_backButton setEnabled:YES];
                        [_backandnext setEnabled:YES forSegment:0];
                    }
                    [_arrayController removeObjects:_itemArray];
                    [_currentArray addObjectsFromArray:childArray];
                    superView.forBidClick = NO;
                    [_arrayController addObjects:childArray];
                    [_collectionView setSelectionIndexes:nil];
                    self.currentDevicePath = selectedNode.path;
                }
                
                
            }else
            {
                superView.forBidClick = NO;
            }
            
            //屏蔽advanceButton按钮，
            NSMutableArray *pathArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in _nextContainer) {
                NSString *Path = [dic objectForKey:@"currentDevicePath"];
                [pathArray addObject:Path];
            }
            if (![pathArray containsObject:self.currentDevicePath]) {
                [_nextContainer removeAllObjects];
                [_advanceButton setEnabled:NO];
            }
            
            //屏蔽nextButton按钮，
            if ([pathArray containsObject:self.currentDevicePath]) {
                NSDictionary *dic = [_nextContainer objectAtIndex:[_nextContainer count] - 1];
                [_nextContainer removeObject:dic];
            }
            if (_nextContainer.count>0) {
                [_advanceButton setEnabled:YES];
            }else {
                [_advanceButton setEnabled:NO];
            }

        }

        
        
//        if ([_countDelegate respondsToSelector:@selector(reCaulateItemCount)]) {
//            
//            [_countDelegate reCaulateItemCount];
//        }
        [self singlecCick:nil];
        
    }
}

- (int)cacuCount:(NSString *)nodePath {
    AFCApplicationDirectory *afcMedia = [_iPod.deviceHandle newAFCApplicationDirectory:_appBundle];
    NSArray *array = [afcMedia directoryContents:nodePath];
    [afcMedia close];
    return (int)array.count;
}

//获得选中的item
- (NSIndexSet *)selectedItems {
    NSMutableArray *disAry = nil;
//    if (_isSearch) {
//        disAry = _researchdataSourceArray;
//    }else{
        disAry = _dataSourceArray;
//    }
    NSMutableIndexSet *selectedItems = [NSMutableIndexSet indexSet];
    for (int i = 0;i < disAry.count; i ++) {
        IMBBaseEntity *entity = [disAry objectAtIndex:i];
        if (entity.checkState != UnChecked) {
            [selectedItems addIndex:i];
        }
    }
    return selectedItems;
}

#pragma mark - Actions
- (void)backAction:(id)sender {
    NSMutableArray *dataArr = nil;
    if ([_backContainer count]>0) {
        
        if ([_currentArray count]>120) {
            
            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:_currentArray],@"array",self.currentDevicePath,@"currentDevicePath", nil];
            [_nextContainer addObject:dic1];
            
        }else
        {
            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:_itemArray,@"array",self.currentDevicePath,@"currentDevicePath", nil];
            [_nextContainer addObject:dic1];
            
        }
        
        [_arrayController removeObjects:_itemArray];
        [_currentArray removeAllObjects];
        NSDictionary *dic = [_backContainer objectAtIndex:[_backContainer count] - 1];
        dataArr = [dic objectForKey:@"array"];
        self.currentDevicePath = [dic objectForKey:@"currentDevicePath"];
        [_currentArray addObjectsFromArray:dataArr];
        
        
        if ([dataArr count]>120) {
            currentIndex = 0;
            [self loadItem];
        }else
        {
            
            [_arrayController addObjects:dataArr];
        }
        
        [_backContainer removeObject:dic];
        if ([_nextContainer count]>0) {
            [_advanceButton setEnabled:YES];
            [_backandnext setEnabled:YES forSegment:1];
        }
        if ([_backContainer count]==0) {
            [_backButton setEnabled:NO];
            [_backandnext setEnabled:NO forSegment:0];
        }
        
        
    }else
    {
        [_backButton setEnabled:NO];
        [_backandnext setEnabled:NO forSegment:0];
    }
    
    [_collectionView setSelectionIndexes:nil];
//    if ([_countDelegate respondsToSelector:@selector(reCaulateItemCount)]) {
//        
//        [_countDelegate reCaulateItemCount];
//    }
    [self singlecCick:nil];
    if ([self.currentDevicePath isEqualToString:@"/"]) {
        [_collectionView setSelectionIndexes:_currentEntity.set];
    }

}

- (void)nextAction:(id)sender {
    NSMutableArray *dataArr = nil;
    if ([_nextContainer count]>0) {
        if ([_currentArray count]>120) {
            
            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:_currentArray],@"array",self.currentDevicePath,@"currentDevicePath", nil];
            [_backContainer addObject:dic1];
        }else
        {
            
            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:_itemArray,@"array",self.currentDevicePath,@"currentDevicePath", nil];
            [_backContainer addObject:dic1];
        }
        [_arrayController removeObjects:_itemArray];
        [_currentArray removeAllObjects];
        NSDictionary *dic = [_nextContainer objectAtIndex:[_nextContainer count] - 1];
        dataArr = [dic objectForKey:@"array"];
        self.currentDevicePath = [dic objectForKey:@"currentDevicePath"];
        
        [_currentArray addObjectsFromArray:dataArr];
        if ([dataArr count]>120) {
            currentIndex = 0;
            [self loadItem];
        }else
        {
            
            [_arrayController addObjects:dataArr];
        }
        
        
        [_nextContainer removeObject:dic];
        if ([_backContainer count]>0) {
            [_backButton setEnabled:YES];
            [_backandnext setEnabled:YES forSegment:0];
        }
        if ([_nextContainer count]==0) {
            [_advanceButton setEnabled:NO];
            [_backandnext setEnabled:NO forSegment:1];
        }
        
    }else
    {
        [_advanceButton setEnabled:NO];
        [_backandnext setEnabled:NO forSegment:1];
    }
    
    [_collectionView setSelectionIndexes:nil];
//    if ([_countDelegate respondsToSelector:@selector(reCaulateItemCount)]) {
//        
//        [_countDelegate reCaulateItemCount];
//    }
    [self singlecCick:nil];
}

#pragma mark - about loadingActions
- (void)showloading:(BOOL)isloading baseView:(NSView *)view {
    if (isloading&&_loadingView == nil) {
        _loadingView = [[IMBBackgroundBorderView alloc] initWithFrame:view.bounds];
        [_loadingView setTopBorderColor:[NSColor colorWithCalibratedRed:227.0/255 green:226.0/255 blue:226.0/255 alpha:1.0]];
        [_loadingView setFrame:view.frame];
        [_loadingView setHasTopBorder:YES];
        indicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect((view.frame.size.width)/2.0, (view.frame.size.height)/2.0+10, 60, 60)];
        indicator.style = NSProgressIndicatorSpinningStyle;
        [indicator setIndeterminate:YES];
        [indicator setDisplayedWhenStopped:YES];
        [indicator startAnimation:self];
        [_loadingView addSubview:indicator];
        [indicator release];
        
        if ([view respondsToSelector:@selector(setContentView:)]) {
            [_loadingView setBackgroundColor:[NSColor whiteColor]];
            [((NSBox *)view) setContentView:_loadingView];
        }else
        {
            [_loadingView setBackgroundColor:[NSColor redColor]];
            [view addSubview:_loadingView];
        }
    }else if (_loadingView != nil&&isloading)
    {
        [indicator startAnimation:self];
        if ([view respondsToSelector:@selector(setContentView:)]) {
            
            [_loadingView setBackgroundColor:[NSColor whiteColor]];
            [((NSBox *)view) setContentView:_loadingView];
        }else
        {
            [_loadingView setBackgroundColor:[NSColor whiteColor]];
            [view addSubview:_loadingView];
            [_loadingView setFrame:view.bounds];
        }
    }
    else
    {
        if ([_loadingView superview]) {
            [indicator stopAnimation:self];
            [_loadingView removeFromSuperview];
        }
        
    }
}

- (void)changeCheckBoxState {
    if (![self.currentDevicePath isEqualToString:@"/"]) {
        return;
    }
    NSIndexSet *set = [[_collectionView selectionIndexes] copy];
    int count = (int)[(NSArray *)[_arrayController content] count];
    if (set.count == count) {
        _currentEntity.checkState = Check;
    }else if (set.count == 0) {
         _currentEntity.checkState = UnChecked;
    } else {
         _currentEntity.checkState = SemiChecked;
    }
    
    _currentEntity.set = set;
    [_leftTableView reloadData];
    //改变headerCheckBox
    int checkCount = 0;
    int uncheckCount = 0;
    for (IMBAppEntity *app in _dataSourceArray) {
        if (app.checkState == Check) {
            checkCount ++;
        }else if (app.checkState == UnChecked) {
            uncheckCount ++;
        }
    }
    
    if (checkCount == _dataSourceArray.count) {
        [_leftTableView changeHeaderCheckState:Check];
    }else if (uncheckCount == _dataSourceArray.count) {
        [_leftTableView changeHeaderCheckState:UnChecked];
    }else {
        [_leftTableView changeHeaderCheckState:SemiChecked];
    }
}

#pragma mark - about reloadActions
- (void)reload:(id)sender {
//    [self disableFunctionBtn:NO];
    [_mainBox setContentView:_loadingDataVeiw];
    [_loadingAnimationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            if (_iPod != nil) {
                [_iPod startSync];
                [_information.applicationManager refreshAppEntityArray];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
//                    [self refresh];
//                    [self disableFunctionBtn:YES];
                    if (_dataSourceArray != nil) {
                        [_dataSourceArray release];
                        _dataSourceArray = nil;
                    }
                    _dataSourceArray = (NSMutableArray *)[[_information.applicationManager appEntityArray] retain];
                    [_itemTableView deselectAll:nil];
                    
                    if (_dataSourceArray.count == 0) {
                        [_mainBox setContentView:_noDataView];
                        [self configNoDataView];
                    }else {
//                        [self doSearchBtn:_searchFieldBtn.stringValue withSearchBtn:_searchFieldBtn];
                        if ([_iOSVersion isVersionMajorEqual:@"8.3"]) {
                            [_mainBox setContentView:_containTableView];
                        }else {
                            [_mainBox setContentView:_containTableCollectView];
                        }
                    }
//                    if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
//                        [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
//                    }
                    [_loadingAnimationView endAnimation];
                    
                    [_itemTableView reloadData];
                });
                [_iPod endSync];
            } 
        }
        
    });
}

- (void)refresh:(IMBInformation *)information {
    //    [self disableFunctionBtn:NO];
//    [_mainBox setContentView:_loadingDataVeiw];
//    [_loadingAnimationView startAnimation];
    NSInteger row = [_leftTableView selectedRow];
    if (row < 0) {
        row = 0;
    }
    _currentEntity = [_dataSourceArray objectAtIndex:row];
    
    _appBundle = _currentEntity.appKey;
    //            ((IMBBlankDraggableCollectionView *)_collectionView).exploreType = AppDocumentExploreType;
    ((IMBBlankDraggableCollectionView *)_collectionView).forBidClick = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *array = [applicationManger recursiveDirectoryContentsDics:_currentDevicePath appBundle:_appBundle];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_arrayController removeObjects:_itemArray];
//            self.currentDevicePath = @"/" ;
            [_currentArray removeAllObjects];
            [_currentArray addObjectsFromArray:array];
            currentIndex = 0;
            [self loadItem];
            [_collectionView setSelectionIndexes:nil];
            //                [self showloading:NO baseView:_rightView];
            
            [self singlecCick:nil];
            if (_currentEntity.checkState == UnChecked) {
                [_collectionView setSelectionIndexes:nil];
            }else if (_currentEntity.checkState == Check) {
                [_collectionView selectAll:nil];
                _currentEntity.set = [_collectionView selectionIndexes];
                [_collectionView setSelectionIndexes:_currentEntity.set];
            }else {
                [_collectionView setSelectionIndexes:_currentEntity.set];
            }
            
        });
    });
    [_leftTableView reloadData];
}

//- (void)toMac:(IMBInformation *)information {
//     NSIndexSet *selectedSet =[self selectedItems];
//    if (!selectedSet || selectedSet.count == 0) {
//        NSAlert *alert = [NSAlert alertWithMessageText:@"Please select item" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please select item"];
//        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
//            //            if (returnCode == 1) {
//            //                IMBFLog(@"clicked OK button");
//            //            }
//        }];
//    }else {
//
//        if ([_iPod.deviceInfo.getDeviceFloatVersionNumber isVersionMajorEqual:@"8.3"]) {
//            NSAlert *alert = [NSAlert alertWithMessageText:@"Warning" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Your device is running iOS 8.3 or higher version, which has disabled this feature in iOS Files."];
//            [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
//                if (returnCode == 1) {
//                    
//                }
//            }];
//            return;
//        }
//        
//        NSOpenPanel *openPanel = [NSOpenPanel openPanel];
//        [openPanel setCanChooseFiles:NO];
//        [openPanel setCanChooseDirectories:YES];
//        [openPanel setCanCreateDirectories:YES];
//        //                [openPanel setAllowsOtherFileTypes:NO];
//        [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
//            if (NSModalResponseOK == result) {
//                NSOperationQueue *opQueue = [[[NSOperationQueue alloc] init] autorelease];
//                [opQueue addOperationWithBlock:^{
//                    NSString *path = [[openPanel URL] path];
//                    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:Category_Applications]];
//                    NSMutableArray *exportArray = [NSMutableArray array];
//                    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                        IMBAppEntity *app = [[_dataSourceArray objectAtIndex:idx] retain];
//                        [exportArray addObject:app];
//                        [app release];
//                    }];
//                    
//                    IMBAppExport *baseTransfer = [[IMBAppExport alloc] initWithIPodkey:information.ipod.uniqueKey exportTracks:exportArray exportFolder:filePath withDelegate:self];
//                    [baseTransfer startTransfer];
//                }];
//            }
//        }];
//    }
//}

- (void)addToDevice:(IMBInformation *)information {
    NSArray *supportFiles = [@"ipa;pxl" componentsSeparatedByString:@";"];
    
    _openPanel = [NSOpenPanel openPanel];
//    _isOpen = YES;
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel setCanChooseFiles:YES];
    [_openPanel setAllowsMultipleSelection:YES];
    [_openPanel beginSheetModalForWindow:[self view].window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSFileHandlingPanelOKButton) {
            NSDictionary *param = nil;
            param = [NSDictionary dictionaryWithObjectsAndKeys:_openPanel,@"openPanel",[NSNull null],@"albumEntity",@(0),@"playlistID",@(NO),@"isAlloc",nil];
        
            [self performSelector:@selector(addItemsDelay:) withObject:param afterDelay:0.1];
        }
//        _isOpen = NO;
    }];
}

- (void)addItemsDelay:(NSDictionary *)param {
    NSOpenPanel *openPanel = [param objectForKey:@"openPanel"];
    NSArray *urlArr = [openPanel URLs];
    NSMutableArray *paths = [NSMutableArray array];
    IMBAppEntity *appEntity = [_dataSourceArray objectAtIndex:_leftTableView.selectedRow];
    AFCApplicationDirectory *appDir = [[_iPod deviceHandle] newAFCApplicationDirectory:[appEntity appKey]];
    for (NSURL *url in urlArr) {
//        [paths addObject:url.path];
        [appDir copyLocalFile:url.path toRemoteFile:_currentDevicePath];
        [appDir copyLocalFile:url.path toRemoteDir:_currentDevicePath transLength:1];
//        - (BOOL)copyLocalFile:(NSString*)frompath toRemoteDir:(NSString*)topath transLength:(long*)length;

    }

//    - (BOOL)copyLocalFile:(NSString*)frompath toRemoteFile:(NSString*)topath;
//    - (BOOL)copyLocalFile:(NSString*)frompath toRemoteFile:(NSString*)topath;
//    IMBAirSyncImportTransfer * _baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:_iPod.uniqueKey importFiles:paths CategoryNodesEnum:Category_Applications photoAlbum:nil playlistID:0 delegate:self];
//    [_baseTransfer startTransfer];
//    [self importToDevice:paths photoAlbum:albumEntity playlistID:playlistID Result:result AnnoyVC:annoyVC];
}

- (void)toDevice:(IMBInformation *)information {
    NSIndexSet *selectedSet =[self selectedItems];
    IMBDeviceConnection *conn = [IMBDeviceConnection singleton];
    IMBiPod *desIpod = nil;
    for (IMBiPod *ipod in conn.alliPods) {
        if (![ipod.uniqueKey isEqualToString:information.ipod.uniqueKey]) {
            desIpod = ipod;
            break;
        }
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *selectAry = [NSMutableArray array];
        if (desIpod.appsLoadFinished) {
            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
                //TODO
                IMBAppEntity *be = [_dataSourceArray objectAtIndex:idx];
                [selectAry addObject:be];
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_current_queue(), ^{
                IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
                model.categoryNodes = Category_Applications;
                IMBBetweenDeviceHandler *_baseTransfer = [[IMBBetweenDeviceHandler alloc] initWithSelectedArray:selectAry categoryModel:model srcIpodKey:information.ipod.uniqueKey desIpodKey:desIpod.uniqueKey withPlaylistArray:[NSArray array] albumEntity:nil Delegate:self];
                [_baseTransfer startTransfer];
            });
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSAlert *alert = [NSAlert alertWithMessageText:@"Warning!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please connect at least 2 devices"];
                [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                    
                }];
            });
        }
        
    });
    
}



- (void)toMac:(IMBInformation *)information{
    //弹出路径选择框
    _openPanel = [NSOpenPanel openPanel];
    //    _isOpen = YES;
    [_openPanel setAllowsMultipleSelection:NO];
    [_openPanel setCanChooseFiles:NO];
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel beginSheetModalForWindow:[self.view window] completionHandler:^(NSInteger result) {
        if (result== NSFileHandlingPanelOKButton) {
            [self performSelector:@selector(systemtoMacDelay:) withObject:_openPanel afterDelay:0.1];
        }else{
            NSLog(@"other other other");
        }
        //        _isOpen = NO;
    }];
}

- (void)systemtoMacDelay:(NSOpenPanel *)openPanel
{
    //    NSViewController *annoyVC = nil;
    //    long long result = [self checkNeedAnnoy:&(annoyVC)];
    //    if (result == 0) {
    //        return;
    //    }
    
    NSMutableArray *disAry = nil;
    disAry = _currentArray;
    NSMutableIndexSet *selectedSet = [NSMutableIndexSet indexSet];
    for (int i = 0;i < disAry.count; i ++) {
        IMBBaseEntity *entity = [disAry objectAtIndex:i];
        if (entity.checkState != UnChecked) {
            [selectedSet addIndex:i];
        }
    }
    NSMutableArray *delArray = [[NSMutableArray alloc] init];
    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        SimpleNode *app = [[_currentArray objectAtIndex:idx] retain];
        [delArray addObject:app];
        [app release];
        app = nil;
    }];
    
    NSString * path =[[openPanel URL] path];
    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:Category_System]];
    
    
    IMBAppEntity *appEntity = [_dataSourceArray objectAtIndex:_leftTableView.selectedRow];
    AFCApplicationDirectory *appDir = [[_iPod deviceHandle] newAFCApplicationDirectory:[appEntity appKey]];

    for (SimpleNode *app in delArray) {
        [appDir copyRemoteFile:app.path toLocalFile:filePath];
    }
    
    if (appDir != nil) {
        [appDir close];
    }
}

- (void)deleteItem:(IMBInformation *)information {
//    NSIndexSet *selectedSet =[self selectedItems];
    
    NSMutableArray *disAry = nil;
    //    if (_isSearch) {
    //        disAry = _researchdataSourceArray;
    //    }else{
    disAry = _currentArray;
    //    }
    NSMutableIndexSet *selectedSet = [NSMutableIndexSet indexSet];
    for (int i = 0;i < disAry.count; i ++) {
        IMBBaseEntity *entity = [disAry objectAtIndex:i];
        if (entity.checkState != UnChecked) {
            [selectedSet addIndex:i];
        }
    }

    NSMutableArray *delArray = [[NSMutableArray alloc] init];
    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        SimpleNode *app = [[_currentArray objectAtIndex:idx] retain];
        [delArray addObject:app];
        [app release];
        app = nil;
    }];
    IMBAppEntity *appEntity = [_dataSourceArray objectAtIndex:_leftTableView.selectedRow];
    AFCApplicationDirectory *appDir = [[_iPod deviceHandle] newAFCApplicationDirectory:[appEntity appKey]];
    for (SimpleNode *app in delArray) {
        if (app.container) {
            [appDir unlinkFolder:app.path];
        }else{
            [appDir unlink:app.path];
        }
    }
    if (appDir != nil) {
        [appDir close];
    }
}

//- (void)toDevice:(IMBInformation *)information {
//    NSIndexSet *selectedSet =[self selectedItems];
//    IMBDeviceConnection *conn = [IMBDeviceConnection singleton];
//    IMBiPod *desIpod = nil;
//    for (IMBiPod *ipod in conn.alliPods) {
//        if (![ipod.uniqueKey isEqualToString:information.ipod.uniqueKey]) {
//            desIpod = ipod;
//            break;
//        }
//    }
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSMutableArray *selectAry = [NSMutableArray array];
//        if (desIpod.appsLoadFinished) {
//            [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                //TODO
//                IMBAppEntity *be = [_dataSourceArray objectAtIndex:idx];
//                [selectAry addObject:be];
//            }];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_current_queue(), ^{
//                IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
//                model.categoryNodes = Category_Applications;
//                IMBBetweenDeviceHandler *_baseTransfer = [[IMBBetweenDeviceHandler alloc] initWithSelectedArray:selectAry categoryModel:model srcIpodKey:information.ipod.uniqueKey desIpodKey:desIpod.uniqueKey withPlaylistArray:[NSArray array] albumEntity:nil Delegate:self];
//                [_baseTransfer startTransfer];
//            });
//            
//        }else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSAlert *alert = [NSAlert alertWithMessageText:@"Warning!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please connect at least 2 devices"];
//                [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
//                    
//                }];
//            });
//        }
//        
//    });
//    
//}



//- (void)toMac:(IMBInformation *)information{
//    //弹出路径选择框
//    _openPanel = [NSOpenPanel openPanel];
//    //    _isOpen = YES;
//    [_openPanel setAllowsMultipleSelection:NO];
//    [_openPanel setCanChooseFiles:NO];
//    [_openPanel setCanChooseDirectories:YES];
//    [_openPanel beginSheetModalForWindow:[self.view window] completionHandler:^(NSInteger result) {
//        if (result== NSFileHandlingPanelOKButton) {
//            [self performSelector:@selector(systemtoMacDelay:) withObject:_openPanel afterDelay:0.1];
//        }else{
//            NSLog(@"other other other");
//        }
//        //        _isOpen = NO;
//    }];
//}
//
//- (void)systemtoMacDelay:(NSOpenPanel *)openPanel
//{
//    //    NSViewController *annoyVC = nil;
//    //    long long result = [self checkNeedAnnoy:&(annoyVC)];
//    //    if (result == 0) {
//    //        return;
//    //    }
//    NSString * path =[[openPanel URL] path];
//    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:Category_System]];
//    
//    
//    NSIndexSet *selectedSet = [self selectedItems];
//    NSMutableArray *selectedTracks = [NSMutableArray array];
//    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//        [selectedTracks addObject:[_currentArray objectAtIndex:idx]];
//    }];
//    
//    //    NSArray *selectedFile = [_arrayController selectedObjects];
//    if (_transferViewController != nil) {
//        [_transferViewController release];
//        _transferViewController = nil;
//    }
//    _transferViewController = [[IMBTransferViewController alloc]initWithUniqueKey:_iPod.uniqueKey withSelectedAry:selectedTracks exportFolder:filePath withDelegate:self];
//    [_transferViewController.view setFrame:NSMakeRect(0, 0, [self.view window].contentView.frame.size.width, [self.view window].contentView.frame.size.height)];
//    [[self.view window].contentView addSubview:_transferViewController.view];
//    [_transferViewController.view setWantsLayer:YES];
//    [_transferViewController.view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-_transferViewController.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
//    
//}

//- (void)deleteItem:(IMBInformation *)information {
//     NSIndexSet *selectedSet =[self selectedItems];
//    if (!selectedSet || selectedSet.count == 0) {
//        NSAlert *alert = [NSAlert alertWithMessageText:@"Please select item" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please select item"];
//        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
//            
//        }];
//    }else {
//        NSAlert *alert = [NSAlert alertWithMessageText:@"Warning" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"Are U Sure To Delete?"];
//        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
//            if (returnCode == 1) {
//                IMBFLog(@"clicked OK button");
//                NSOperationQueue *opQueue = [[[NSOperationQueue alloc] init] autorelease];
//                [opQueue addOperationWithBlock:^{
//                    
//                    NSMutableArray *delArray = [[NSMutableArray alloc] init];
//                    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
//                        IMBAppEntity *app = [[_dataSourceArray objectAtIndex:idx] retain];
//                        [delArray addObject:app];
//                        [app release];
//                        app = nil;
//                    }];
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
//                    });
//                    IMBDeleteApps *procedure = [[IMBDeleteApps alloc] initWithIPod:_iPod deleteArray:delArray];
//                    [procedure startDelete];
//                    [procedure release];
//                    
////                    [self setCompletionWithSuccessCount:(int)delArray.count totalCount:(int)delArray.count title:@"Delete Success"];
//                    
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:IMBDevicePageStartLoadingAnimNoti object:_iPod.uniqueKey];
//                    });
//                    IMBDeleteTrack *deleteTrack = [[IMBDeleteTrack alloc] initWithIPod:_iPod deleteArray:delArray Category:Category_Applications];
//                    [deleteTrack setDelegate:self];
//                    [deleteTrack startDelete];
//                    [deleteTrack release];
//                    [delArray release];
//                    delArray = nil;
//                    
//                }];
//            }
//            
//        }];
//        
//    }
//}

//- (void)reload:(id)sender {
//    //    [self disableFunctionBtn:NO];
//    [_mainBox setContentView:_loadingDataVeiw];
//    [_loadingAnimationView startAnimation];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        @autoreleasepool {
//            if (_iPod != nil) {
//                [_iPod startSync];
//                [_information.applicationManager refreshAppEntityArray];
//                
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    //                    [self refresh];
//                    //                    [self disableFunctionBtn:YES];
//                    if (_dataSourceArray != nil) {
//                        [_dataSourceArray release];
//                        _dataSourceArray = nil;
//                    }
//                    _dataSourceArray = (NSMutableArray *)[[_information.applicationManager appEntityArray] retain];
//                    [_itemTableView deselectAll:nil];
//                    
//                    if (_dataSourceArray.count == 0) {
//                        [_mainBox setContentView:_noDataView];
//                        [self configNoDataView];
//                    }else {
//                        //                        [self doSearchBtn:_searchFieldBtn.stringValue withSearchBtn:_searchFieldBtn];
//                        if ([_iOSVersion isVersionMajorEqual:@"8.3"]) {
//                            [_mainBox setContentView:_containTableView];
//                        }else {
//                            [_mainBox setContentView:_containTableCollectView];
//                        }
//                    }
//                    //                    if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
//                    //                        [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
//                    //                    }
//                    [_loadingAnimationView endAnimation];
//                    
//                    [_itemTableView reloadData];
//                });
//                [_iPod endSync];
//            }
//        }
//        
//    });
//}

//- (void)refresh:(IMBInformation *)information {
//    //    [self disableFunctionBtn:NO];
//    [_mainBox setContentView:_loadingDataVeiw];
//    [_loadingAnimationView startAnimation];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        @autoreleasepool {
//            if (_iPod != nil) {
//                [_iPod startSync];
//                [_information.applicationManager refreshAppEntityArray];
//                
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    //                    [self refresh];
//                    //                    [self disableFunctionBtn:YES];
//                    if (_dataSourceArray != nil) {
//                        [_dataSourceArray release];
//                        _dataSourceArray = nil;
//                    }
//                    _dataSourceArray = (NSMutableArray *)[[_information.applicationManager appEntityArray] retain];
//                    [_itemTableView deselectAll:nil];
//                    
//                    if (_dataSourceArray.count == 0) {
//                        [_mainBox setContentView:_noDataView];
//                        [self configNoDataView];
//                    }else {
//                        //                        [self doSearchBtn:_searchFieldBtn.stringValue withSearchBtn:_searchFieldBtn];
//                        if ([_iOSVersion isVersionMajorEqual:@"8.3"]) {
//                            [_mainBox setContentView:_containTableView];
//                        }else {
//                            [_mainBox setContentView:_containTableCollectView];
//                        }
//                    }
//                    //                    if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
//                    //                        [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
//                    //                    }
//                    [_loadingAnimationView endAnimation];
//                    
//                    [_itemTableView reloadData];
//                });
//                [_iPod endSync];
//            }
//        }
//        
//    });
//}
//
//- (void)addToDevice:(IMBInformation *)information {
//    NSArray *supportFiles = [@"ipa;pxl" componentsSeparatedByString:@";"];
//    
//    _openPanel = [NSOpenPanel openPanel];
//    //    _isOpen = YES;
//    [_openPanel setCanChooseDirectories:YES];
//    [_openPanel setCanChooseFiles:YES];
//    [_openPanel setAllowsMultipleSelection:YES];
//    [_openPanel setAllowedFileTypes:supportFiles];
//    [_openPanel beginSheetModalForWindow:[self view].window completionHandler:^(NSModalResponse returnCode) {
//        if (returnCode == NSFileHandlingPanelOKButton) {
//            NSDictionary *param = nil;
//            param = [NSDictionary dictionaryWithObjectsAndKeys:_openPanel,@"openPanel",[NSNull null],@"albumEntity",@(0),@"playlistID",@(NO),@"isAlloc",nil];
//            
//            [self performSelector:@selector(addItemsDelay:) withObject:param afterDelay:0.1];
//        }
//        //        _isOpen = NO;
//    }];
//}
//
//- (void)addItemsDelay:(NSDictionary *)param {
//    NSOpenPanel *openPanel = [param objectForKey:@"openPanel"];
//    NSArray *urlArr = [openPanel URLs];
//    NSMutableArray *paths = [NSMutableArray array];
//    for (NSURL *url in urlArr) {
//        [paths addObject:url.path];
//    }
//    IMBAirSyncImportTransfer * _baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:_iPod.uniqueKey importFiles:paths CategoryNodesEnum:Category_Applications photoAlbum:nil playlistID:0 delegate:self];
//    [_baseTransfer startTransfer];
//    //    [self importToDevice:paths photoAlbum:albumEntity playlistID:playlistID Result:result AnnoyVC:annoyVC];
//}

//- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
//    _isSearch = YES;
//    _searchFieldBtn = searchBtn;
//    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"appName CONTAINS[cd] %@ ",searchStr];
//        [_researchdataSourceArray removeAllObjects];
//        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
//        if (_researchdataSourceArray.count <=0) {
//            if ([_iOSVersion isVersionMajorEqual:@"8.3"]) {
//
//            }else {
//                [_arrayController removeObjects:_itemArray];
//                [_itemArray removeAllObjects];
//                [_currentArray removeAllObjects];
//                currentIndex = 0;
//            }
//        }else{
//             [_leftTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]byExtendingSelection:NO];
//        }
//    }else{
//        _isSearch = NO;
//        [_researchdataSourceArray removeAllObjects];
//        [_leftTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]byExtendingSelection:NO];
//    }
//    
//    NSMutableArray *disAry = nil;
//    if (_isSearch) {
//        disAry = _researchdataSourceArray;
//    }else{
//        disAry = _dataSourceArray;
//    }
//    
//    int checkCount = 0;
//    for (int i=0; i<[disAry count]; i++) {
//        IMBAppEntity *bookMark = [disAry objectAtIndex:i];
//        if (bookMark.checkState == NSOnState) {
//            checkCount ++;
//        }
//    }
//    if (checkCount == [disAry count]&&[disAry count]>0) {
//        [_itemTableView changeHeaderCheckState:NSOnState];
//    }else if (checkCount  == 0)
//    {
//        [_itemTableView changeHeaderCheckState:NSOffState];
//    }else
//    {
//        [_itemTableView changeHeaderCheckState:NSMixedState];
//    }
//
//    [_itemTableView reloadData];
//    [_leftTableView reloadData];
//}

- (void)dealloc {
    [nc removeObserver:self name:BackupItemDoubleClick object:nil];
    [nc removeObserver:self name:BackupItemSingleClick object:nil];
    [nc removeObserver:self name:NOTIFY_DONE object:nil];
    [super dealloc];
}
@end
