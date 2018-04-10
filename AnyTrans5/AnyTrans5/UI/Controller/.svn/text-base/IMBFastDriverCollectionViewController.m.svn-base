//
//  IMBFastDriverCollectionViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-5.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBFastDriverCollectionViewController.h"
#import "IMBNotificationDefine.h"
#import "IMBBlankDraggableCollectionView.h"
#import "IMBAnimation.h"
#import "IMBFileSystemExport.h"
#import "IMBFileSystemManager.h"
@interface IMBFastDriverCollectionViewController ()

@end

@implementation IMBFastDriverCollectionViewController
@synthesize currentArray = _currentArray;
@synthesize currentDevicePath = _currentDevicePath;
@synthesize backButton = backButton;
@synthesize advanceButton = advanceButton;
@synthesize backContainer = _backContainer;
@synthesize nextContainer = _nextContainer;
- (id)initWithIpod:(IMBiPod *)ipod  withDelegate:(id)delegate {
    if (self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil]) {
        _ipod = [ipod retain];
        _delegate = delegate;
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [_collectionView setListener:self];
    [_systemScrollView setScrollerStyle:NSScrollerStyleOverlay];
    [_pathField setStringValue:CustomLocalizedString(@"Fast_Drive_id_1", nil)];
    _category = Category_Storage;
    [_bgView setBackgroundColor:[NSColor clearColor]];
    [_collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor clearColor], nil]];
    [_collectionView setFocusRingType:NSFocusRingTypeNone];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(mouseDownFinish) name:NOTIFY_DONE object:nil];
    [nc addObserver:self selector:@selector(changeCoDataSource:) name:BackupItemDoubleClick object:nil];
    [nc addObserver:self selector:@selector(singlecCick:) name:BackupItemSingleClick object:nil];
    ((IMBBlankDraggableCollectionView *)_collectionView).exploreType = FileSystemExploreType;
    ((IMBBlankDraggableCollectionView *)_collectionView).forBidClick = NO;
    _currentArray = [[NSMutableArray alloc] init];
    _dataSourceArray = [[NSMutableArray alloc] init];
    
    [backButton setIsDrawBorder:NO];
    [backButton setEnabled:NO];
    [advanceButton setIsDrawBorder:NO];
    [advanceButton setEnabled:NO];
//    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
}

- (void)getSystemFile {
    systemManager = [[IMBFileSystemManager alloc] initWithiPodByExport:_ipod];
    [systemManager setDelegate:self];
    [systemManager setFolderIconSize:NSMakeSize(74, 74)];
    [systemManager setFileIconSize:NSMakeSize(64, 60)];
    
    NSArray *array = nil;
    array = [systemManager recursiveDirectoryContentsDics:@"/general_storage"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (array.count == 0) {
            [_mainBox  setContentView:_noDataView];
        }else{
            [_mainBox setContentView:_bgView];
        }
        [self configNoDataView];
        [_arrayController removeObjects:_dataSourceArray];
        self.currentDevicePath = @"/general_storage" ;
        [_arrayController addObjects:array];
        [_collectionView setSelectionIndexes:nil];
        currentIndex = (int)[_dataSourceArray count];
        [_currentArray addObjectsFromArray:_dataSourceArray];
        [self singlecCick:nil];
        
        if ([_delegate respondsToSelector:@selector(setSelectWord: withSelectCount:)]) {
            [_delegate setSelectWord:array.count withSelectCount:0];
        }
        if ([_delegate respondsToSelector:@selector(loadFastDriverCollecitonVC)]) {
            [_delegate loadFastDriverCollecitonVC];
        }
    });
}

- (void)setCollectionView
{
    [_mainBox setContentView:_bgView];
}

- (void)configNoDataView {
    [_noDataImageView setImage:[StringHelper imageNamed:@"fastdriver_nodata"]];
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    NSString *overStr = CustomLocalizedString(@"NO_DATA_TITLE_2", nil);
    promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_81", nil)] stringByAppendingString:overStr];
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

- (void)backAction:(id)sender {
    NSMutableArray *dataArr = nil;
    if ([_backContainer count]>0) {
        if ([_currentArray count]>120) {
            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:_dataSourceArray],@"array",self.currentDevicePath,@"currentDevicePath", nil];
            [_nextContainer addObject:dic1];
            
        }else
        {
            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:_dataSourceArray],@"array",self.currentDevicePath,@"currentDevicePath", nil];
            [_nextContainer addObject:dic1];
            
        }
        [_arrayController removeObjects:_dataSourceArray];
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
            [advanceButton setEnabled:YES];
            [advanceButton setNeedsDisplay:YES];
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
    [self reloadBtn];
    
    if ([_delegate respondsToSelector:@selector(setSelectWord: withSelectCount:)]) {
        [_delegate setSelectWord:[[_arrayController content] count] withSelectCount:0];
    }
}

- (void)nextAction:(id)sender {
    NSMutableArray *dataArr = nil;
    if ([_nextContainer count]>0) {
        if ([_currentArray count]>120) {
            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:_dataSourceArray],@"array",self.currentDevicePath,@"currentDevicePath", nil];
            [_backContainer addObject:dic1];
        }else
        {
            NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:_dataSourceArray],@"array",self.currentDevicePath,@"currentDevicePath", nil];
            [_backContainer addObject:dic1];
        }
        [_arrayController removeObjects:_dataSourceArray];
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
    
    [_collectionView setSelectionIndexes:nil];
    [self singlecCick:nil];
    [self reloadBtn];
    
    if ([_delegate respondsToSelector:@selector(setSelectWord: withSelectCount:)]) {
        [_delegate setSelectWord:[[_arrayController content] count] withSelectCount:0];
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

- (void)doubleClick:(NSInteger)selectIndex
{
    IMBBlankDraggableCollectionView *superView = (IMBBlankDraggableCollectionView *)_collectionView;
    if (selectIndex>=0&&selectIndex < [[_arrayController arrangedObjects] count]) {
        SimpleNode *selectedNode = [[_arrayController content] objectAtIndex:selectIndex];
        if (selectedNode.container&&!selectedNode.isCoping) {
            if ([self cacuCount:selectedNode.path]>120) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    @autoreleasepool {
                        NSArray *array = [systemManager recursiveDirectoryContentsDics:selectedNode.path];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:_dataSourceArray],@"array",self.currentDevicePath,@"currentDevicePath", nil];
                            [_backContainer addObject:dic];
                            if ([_backContainer  count]>0) {
                                [backButton setEnabled:YES];
                            }
                            [_arrayController removeObjects:_dataSourceArray];
                            superView.forBidClick = NO;
                            [_currentArray removeAllObjects];
                            [_currentArray addObjectsFromArray:array];
                            currentIndex = 0;
                            [self loadItem];
                            [_collectionView setSelectionIndexes:nil];
                            self.currentDevicePath = selectedNode.path;
                            [self singlecCick:nil];
                            if ([_delegate respondsToSelector:@selector(collectionLoadDataComplete)]) {
                                [_delegate collectionLoadDataComplete];
                            }
                            
                            if ([_delegate respondsToSelector:@selector(setSelectWord: withSelectCount:)]) {
                                [_delegate setSelectWord:array.count withSelectCount:0];
                            }
                        });
                    }
                });
            }else
            {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    @autoreleasepool {
                        [_currentArray removeAllObjects];
                        NSArray *childArray = [systemManager recursiveDirectoryContentsDics:selectedNode.path];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithArray:_dataSourceArray],@"array",self.currentDevicePath,@"currentDevicePath", nil];
                            [_backContainer addObject:dic];
                            if ([_backContainer  count]>0) {
                                [backButton setEnabled:YES];
                                [backButton setNeedsDisplay:YES];
                            }
                            [_arrayController removeObjects:_dataSourceArray];
                            superView.forBidClick = NO;
                            [_arrayController addObjects:childArray];
                            [_currentArray addObjectsFromArray:childArray];
                            [_collectionView setSelectionIndexes:nil];
                            self.currentDevicePath = selectedNode.path;
                            if ([_delegate respondsToSelector:@selector(collectionLoadDataComplete)]) {
                                [_delegate collectionLoadDataComplete];
                            }
                            
                            if ([_delegate respondsToSelector:@selector(setSelectWord: withSelectCount:)]) {
                                [_delegate setSelectWord:childArray.count withSelectCount:0];
                            }
                        });
                    }
                });
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
            if ([pathArray containsObject:self.currentDevicePath]) {
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
            
            [self singlecCick:nil];
        }else
        {
            superView.forBidClick = NO;
        }
    }
    superView.forBidClick = NO;
    [self reloadBtn];

}

#pragma single click
- (void)singlecCick:(NSNotification *)notification{
    NSCollectionView *view = notification.object;
    if (view == _collectionView||notification == nil) {
        NSInteger selectIndex = [_arrayController selectionIndex];
        if (selectIndex != -1 && selectIndex < [[_arrayController content] count]) {
            SimpleNode *selectedNode = [[_arrayController content] objectAtIndex:selectIndex];
            if (selectedNode.fileName != nil) {
                NSString *subStr = [selectedNode.path substringFromIndex:16];
                NSString *path = [[NSString stringWithFormat:@"/%@" ,CustomLocalizedString(@"Fast_Drive_id_1", nil)] stringByAppendingString:subStr];
                [_pathField setStringValue:path];
            }
//            if ([_delegate respondsToSelector:@selector(setSelectWord: withSelectCount:)]) {
//                [_delegate setSelectWord:[[_arrayController content] count] withSelectCount:[_arrayController selectionIndexes].count];
//            }
        }else
        {
            NSString *subStr = [_currentDevicePath substringFromIndex:16];
            NSString *path = [[NSString stringWithFormat:@"/%@" ,CustomLocalizedString(@"Fast_Drive_id_1", nil)] stringByAppendingString:subStr];
            [_pathField setStringValue:path];
//            if ([_delegate respondsToSelector:@selector(setSelectWord: withSelectCount:)]) {
//                [_delegate setSelectWord:[[_arrayController content] count] withSelectCount:0];
//            }
        }
    }else{
        NSString *subStr = [_currentDevicePath substringFromIndex:16];
        NSString *path = [[NSString stringWithFormat:@"/%@" ,CustomLocalizedString(@"Fast_Drive_id_1", nil)] stringByAppendingString:subStr];
        [_pathField setStringValue:path];
    }
    
}

- (int)cacuCount:(NSString *)nodePath{
    AFCMediaDirectory *afcMedia = [_ipod.deviceHandle newAFCMediaDirectory];
    NSArray *array = [afcMedia directoryContents:nodePath];
    [afcMedia close];
    return (int)[array count];
}

- (void)reloadBtn {
    [advanceButton setNeedsDisplay:YES];
    [backButton setNeedsDisplay:YES];
}

#pragma mark - drag and drop
- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id <NSDraggingInfo>)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation
{
    NSPasteboard *pastboard = [draggingInfo draggingPasteboard];
    NSArray *fileTypeList = [pastboard propertyListForType:NSFilesPromisePboardType];
    if (fileTypeList == nil) {
        if (_collectionViewcanDrop) {
            return NSDragOperationCopy;
        }else
        {
            return NSDragOperationNone;
        }
    }else
    {
        return NSDragOperationNone;
    }
}

- (void)dropToCollectionView:(NSCollectionView *)collectionView paths:(NSMutableArray *)pathArray {
   
    if ([_delegate respondsToSelector:@selector(dropToCollectionView:paths:)]) {
        [_delegate dropToCollectionView:collectionView paths:pathArray];
    }
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_DONE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BackupItemDoubleClick object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BackupItemSingleClick object:nil];
    if (_backContainer != nil) {
        [_backContainer release];
        _backContainer = nil;
    }
    if (_nextContainer != nil) {
        [_nextContainer release];
        _nextContainer = nil;
    }
    if (_currentArray != nil) {
        [_currentArray release];
        _currentArray = nil;
    }
    if (systemManager != nil) {
        [systemManager release];
        systemManager = nil;
    }
    if (_exportFolder != nil) {
        [_exportFolder release];
        _exportFolder = nil;
    }
    [super dealloc];
}

#pragma mark - 实现方法
- (void)reloadView:(NSArray *)array {
    if (array.count == 0 && [_pathField.stringValue isEqualToString:[NSString stringWithFormat:@"/%@",CustomLocalizedString(@"Fast_Drive_id_1", nil)]]) {
        [_mainBox  setContentView:_noDataView];
    }else{
        [_mainBox setContentView:_bgView];
    }
    [self configNoDataView];
    [_arrayController removeObjects:_dataSourceArray];
    [_arrayController addObjects:array];
    [_collectionView setSelectionIndexes:nil];
    currentIndex = (int)[_dataSourceArray count];
    [_currentArray removeAllObjects];
    [_currentArray addObjectsFromArray:_dataSourceArray];
    [_collectionView setSelectionIndexes:nil];
    [self singlecCick:nil];
    
    if ([_delegate respondsToSelector:@selector(collectionLoadDataComplete)]) {
        [_delegate collectionLoadDataComplete];
    }
}

- (NSArray *)doReloadMode {
    NSArray *array = nil;
    if (_currentDevicePath != nil && ![_currentDevicePath isEqualToString:@""]) {
        array = [systemManager recursiveDirectoryContentsDics:_currentDevicePath];
    }else {
        array = [systemManager recursiveDirectoryContentsDics:@"/general_storage"];
         self.currentDevicePath = @"/general_storage";
    }
    return array;
}

//获得选中的item
- (NSIndexSet *)selectedItems
{
    NSIndexSet *selectedItems = nil;
    if (_collectionView != nil) {
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
    SimpleNode *seletednode = nil;
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
    
    
    int i = [_alertViewController showTitleName:nameString InputTextFiledString:seletednode.fileName OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
    if (i == 1) {
        NSString *str = [[_alertViewController reNameInputTextField] stringValue];
        if ([str isEqualToString:seletednode.fileName]) {
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
                [systemManager rename:seletednode withfileName:str];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self singlecCick:nil];
                    [_alertViewController unloadAlertView:_alertViewController.reNameView];
                    [_alertViewController.renameLoadingView setHidden:YES];
                });
            });
        }
    }
}

- (void)doRename:(SimpleNode *)seletednode withName:(NSString *)name {
    [systemManager rename:seletednode withfileName:name];
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
        
//        NSArray *newArray = [self doDelete:selectedTracks];
        if ([_delegate respondsToSelector:@selector(doDelete:)]) {
            [_delegate doDelete:selectedTracks];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_alertViewController._removeprogressAnimationView setProgressWithOutAnimation:100];
            double delayInSeconds = 1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [_alertViewController showRemoveSuccessViewAlertText:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil) withCount:selectedSet.count];
//                [self doReloadDelete:newArray];
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:Fast_Drive action:Delete actionParams:@"Fast Drive" label:Finish transferCount:selectedTracks.count screenView:@"Fast Drive" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                [_arrayController removeObjects:selectedTracks];
                
                if ([_arrayController.content count] == 0) {
                    NSString *subStr = [_currentDevicePath substringFromIndex:16];
                    NSString *path = [[NSString stringWithFormat:@"/%@" ,CustomLocalizedString(@"Fast_Drive_id_1", nil)] stringByAppendingString:subStr];
                    [_pathField setStringValue:path];
                }else {
                    NSArray *selArray = [_arrayController selectedObjects];
                    if (selArray != nil && selArray.count > 0) {
                        SimpleNode *selectedNode = [selArray lastObject];
                        NSString *subStr = [selectedNode.path substringFromIndex:16];
                        NSString *path = [[NSString stringWithFormat:@"/%@" ,CustomLocalizedString(@"Fast_Drive_id_1", nil)] stringByAppendingString:subStr];
                        [_pathField setStringValue:path];
                    }else {
                        NSString *subStr = [_currentDevicePath substringFromIndex:16];
                        NSString *path = [[NSString stringWithFormat:@"/%@" ,CustomLocalizedString(@"Fast_Drive_id_1", nil)] stringByAppendingString:subStr];
                        [_pathField setStringValue:path];
                    }
                }
                
                if ([_delegate respondsToSelector:@selector(setSelectWord: withSelectCount:)]) {
                    [_delegate setSelectWord:[[_arrayController content] count] withSelectCount:[_arrayController selectionIndexes].count];
                }
            });
        });
    });
}

- (NSArray *)doDelete:(NSArray *)selectedTracks {
    AFCMediaDirectory *afcMedia = [_ipod.deviceHandle newAFCMediaDirectory];
    [systemManager setCurItems:0];
    _deleteTotalItems = [systemManager caculateTotalFileCount:selectedTracks afcMedia:afcMedia];
    [systemManager removeFiles:selectedTracks afcMediaDir:afcMedia];
    [afcMedia close];
//    SimpleNode *node = [selectedTracks objectAtIndex:0];
//    NSArray *newArray = [systemManager recursiveDirectoryContentsDics:node.parentPath];
    return nil;
}

- (void)doReloadDelete:(NSArray *)newArray {
    [_arrayController removeObjects:_dataSourceArray];
    [_currentArray removeAllObjects];
    [_currentArray addObjectsFromArray:newArray];
    if ([newArray count]>120) {
        currentIndex = 0;
        [self loadItem];
    }else
    {
        [_arrayController addObjects:newArray];
    }
    [_collectionView setSelectionIndexes:nil];
    [self singlecCick:nil];
}

- (void)setDeleteCurItems:(int)curItem {
    dispatch_async(dispatch_get_main_queue(), ^{
        float itemCount = curItem;
        if (curItem < 0) {
            itemCount = 0;
        }else if (curItem > _deleteTotalItems) {
            itemCount = _deleteTotalItems;
        }
        float progress = itemCount / _deleteTotalItems * 100;
        [_alertViewController._removeprogressAnimationView setProgress:progress];
    });
}

- (void)exportSelectedItems:(NSString *)exportFolder {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    [_alertViewController fastDriveExportWindow:[NSString stringWithFormat:CustomLocalizedString(@"ToPCiTunes_Transfer_Title", nil),@"Mac"] SuperView:view];
    [_alertViewController._removeprogressAnimationView setProgress:0];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *selectedFile = [_arrayController selectedObjects];
        if (_exportFolder != nil) {
            [_exportFolder release];
            _exportFolder = nil;
        }
        _exportFolder = [exportFolder retain];
        IMBFileSystemExport *baseTransfer = [[IMBFileSystemExport alloc] initWithIPodkey:_ipod.uniqueKey exportTracks:selectedFile exportFolder:exportFolder withDelegate:self];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Fast_Drive action:ContentToMac actionParams:@"Fast Drive" label:Start transferCount:selectedFile.count screenView:@"Fast Drive" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [baseTransfer startTransfer];
    });
}

-  (void)mouseDownFinish
{
    if ([_delegate respondsToSelector:@selector(setSelectWord: withSelectCount:)]) {
        int count = [[_collectionView selectionIndexes] count];
        if (count == 0) {
            NSString *subStr = [_currentDevicePath substringFromIndex:16];
            NSString *path = [[NSString stringWithFormat:@"/%@" ,CustomLocalizedString(@"Fast_Drive_id_1", nil)] stringByAppendingString:subStr];
            [_pathField setStringValue:path];
        }
        [_delegate setSelectWord:[[_arrayController content] count] withSelectCount:[_arrayController selectionIndexes].count];
    }
}

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

- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex{
    if ([_delegate respondsToSelector:@selector(addItems:)]) {
        [_delegate addItems:nil];
    }
    return YES;
}

- (NSIndexSet *)itemCanSelected:(NSIndexSet *)indexset
{
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    [set addIndexes:indexset];
    for (int i=0;i<[[_arrayController content] count];i++) {
        SimpleNode *node = [[_arrayController content] objectAtIndex:i];
        if (node.isCoping) {
            [set removeIndex:i];
            NSCollectionViewItem *item = [_collectionView itemAtIndex:i];
            [item setSelected:NO];
        }
    }
    return set;
}

@end
