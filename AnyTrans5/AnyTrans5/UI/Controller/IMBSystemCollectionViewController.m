//
//  IMBSystemCollectionViewController.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/28.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBSystemCollectionViewController.h"
#import "HoverButton.h"
#import "IMBBackgroundBorderView.h"
#import "IMBFileSystemManager.h"
#import "IMBBlankDraggableCollectionView.h"
#import "IMBNotificationDefine.h"
//#import "IMBColorDefine.h"
#import "IMBAnimation.h"
#import "IMBDeviceMainPageViewController.h"
@implementation IMBSystemCollectionViewController
@synthesize currentArray = _currentArray;
@synthesize currentDevicePath = _currentDevicePath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        [self configNoDataView];
    });
}

- (void)changeSkin:(NSNotification *)notification {
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [self configNoDataView];
    [advanceButton setMouseEnteredImage:[StringHelper imageNamed:@"backup_advance_enter"]  mouseExitImage:[StringHelper imageNamed:@"backup_advance"] mouseDownImage:[StringHelper imageNamed:@"backup_advance2"]  forBidImage:[StringHelper imageNamed:@"backup_advance3"]];
    [advanceButton setIsDrawBorder:NO];
    [backButton setMouseEnteredImage:[StringHelper imageNamed:@"backup_retreat_enter"]  mouseExitImage:[StringHelper imageNamed:@"backup_retreat"] mouseDownImage:[StringHelper imageNamed:@"backup_retreat2"]  forBidImage:[StringHelper imageNamed:@"backup_retreat3"]];
    [_collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor clearColor], nil]];
    [_backandnextView setBottomBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_backandnextView setTopBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_backandnextView setNeedsDisplay:YES];
    [_itemTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_loadingAnimationView setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor clearColor], nil]];
    [_collectionView setFocusRingType:NSFocusRingTypeNone];
    [_loadingView setIsGradientColorNOCornerPart3:YES];//    _bgView.isNOCanDraw = YES;
    [_bgView setBackgroundColor:[NSColor clearColor]];
    _backContainer = [[NSMutableArray alloc] init];
    _nextContainer = [[NSMutableArray alloc] init];
    nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(changeCoDataSource:) name:BackupItemDoubleClick object:nil];
    [nc addObserver:self selector:@selector(singlecCick:) name:BackupItemSingleClick object:nil];
    _dataSourceArray = [[NSMutableArray alloc] init];
    _currentArray = [[NSMutableArray alloc] init];
    systemManager = [[IMBFileSystemManager alloc] initWithiPodByExport:_ipod];
    [systemManager setDelegate:self];
    [advanceButton setMouseEnteredImage:[StringHelper imageNamed:@"backup_advance_enter"]  mouseExitImage:[StringHelper imageNamed:@"backup_advance"] mouseDownImage:[StringHelper imageNamed:@"backup_advance2"]  forBidImage:[StringHelper imageNamed:@"backup_advance3"]];
    [advanceButton setIsDrawBorder:NO];
    [backButton setMouseEnteredImage:[StringHelper imageNamed:@"backup_retreat_enter"]  mouseExitImage:[StringHelper imageNamed:@"backup_retreat"] mouseDownImage:[StringHelper imageNamed:@"backup_retreat2"]  forBidImage:[StringHelper imageNamed:@"backup_retreat3"]];
    [backButton setIsDrawBorder:NO];
    ((IMBBlankDraggableCollectionView *)_collectionView).exploreType = FileSystemExploreType;
    ((IMBBlankDraggableCollectionView *)_collectionView).forBidClick = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *array = nil;
        if (_category == Category_System) {
            array = [systemManager recursiveDirectoryContentsDics:@"/"];
            
        }else if (_category == Category_Storage)
        {
            array = [systemManager recursiveDirectoryContentsDics:@"/general_storage"];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_category == Category_System) {
                [_mainBox setContentView:_detailView];
            }else if (_category == Category_Storage) {
                if (array.count  ==  0) {
                    [_mainBox setContentView:_noDataView];
//                    [self configNoDataView];
                }else {
                    [_mainBox setContentView:_detailView];
                }
                [self configNoDataView];
            }

            [_arrayController removeObjects:_dataSourceArray];
            if (_category == Category_System) {
                self.currentDevicePath = @"/" ;
            }else if (_category == Category_Storage)
            {
                self.currentDevicePath = @"/general_storage" ;
            }
            [_arrayController addObjects:array];
            [_detailView removeFromSuperview];
            [_mainBox setContentView:_detailView];
            [self.view.window makeFirstResponder:_collectionView];
            [_collectionView setNeedsDisplay:YES];
            [_collectionView setNeedsLayout:YES];
            [_collectionView setSelectionIndexes:nil];
            currentIndex = (int)[_dataSourceArray count];
            [_currentArray addObjectsFromArray:_dataSourceArray];
            [self singlecCick:nil];
        });
    });
    
//    [_backandnextView setBackgroundColor:[NSColor whiteColor]];
    [_backandnextView setHasBottomBorder:YES];
    [_backandnextView setHasTopBorder:YES];
    [_backandnextView setBottomBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_backandnextView setTopBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [backButton setEnabled:NO];
    [backButton setTarget:self];
    [backButton setAction:@selector(backAction:)];
    [advanceButton setEnabled:NO];
    [advanceButton setTarget:self];
    [advanceButton setAction:@selector(nextAction:)];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    
    [[_scrollView contentView] setPostsBoundsChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(boundsDidChangeNotification:) name: NSViewBoundsDidChangeNotification object: [_scrollView contentView]];
    
}

- (void) boundsDidChangeNotification: (NSNotification *) notification
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


- (void)configNoDataView {
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_filesystem"]];
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
}

- (void)changeCoDataSource:(NSNotification *)notification{
    NSCollectionView *view = notification.object;
    if (view == _collectionView||notification == nil){
        NSInteger selectIndex = [_arrayController selectionIndex];
        if (selectIndex>=0&&selectIndex < [(NSArray *)[_arrayController arrangedObjects] count]) {
            IMBBlankDraggableCollectionView *superView = (IMBBlankDraggableCollectionView *)_collectionView;
            SimpleNode *selectedNode = [[_arrayController content] objectAtIndex:selectIndex];
            if (selectedNode.container) {
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
                            });
                        }
                    });
                }else
                {
                    [_currentArray removeAllObjects];
                    NSArray *childArray = [systemManager recursiveDirectoryContentsDics:selectedNode.path];
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
    }
    [self reloadBtn];
}

- (void)singlecCick:(NSNotification *)notification{
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
            if (_currentDevicePath != nil) {
                [_itemTitleField setStringValue:_currentDevicePath];
            }
        }
    }
    [_itemTitleField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
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

#pragma mark OperaitonActions
- (void)reload:(id)sender
{
    [self disableFunctionBtn:NO];
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *array = [systemManager recursiveDirectoryContentsDics:_currentDevicePath];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self disableFunctionBtn:YES];
            [_arrayController removeObjects:_dataSourceArray];
            if ([array count]>120) {
                currentIndex = 0;
                [self loadItem];
            }else
            {
                [_arrayController addObjects:array];
            }
            
            if (_category == Category_System) {
                [_mainBox setContentView:_detailView];
            }else if (_category == Category_Storage) {
                if (array.count  ==  0) {
                    [_mainBox setContentView:_noDataView];
                    [self configNoDataView];
                }else {
                    [_mainBox setContentView:_detailView];
                }
            }
            [_loadingAnimationView endAnimation];
            [_currentArray removeAllObjects];
            [_currentArray addObjectsFromArray:array];
            [_collectionView setSelectionIndexes:nil];
            //[_backContainer removeAllObjects];
            //[_nextContainer removeAllObjects];
            //[backButton setEnabled:NO];
            //[advanceButton setEnabled:NO];
//            if ([_countDelegate respondsToSelector:@selector(reCaulateItemCount)]) {
//                
//                [_countDelegate reCaulateItemCount];
//            }
            [self singlecCick:nil];
            
        });
    });
}

- (void)addItems:(id)sender {
   
    _openPanel = [NSOpenPanel openPanel];
    _isOpen = YES;
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel setCanChooseFiles:YES];
    [_openPanel setAllowsMultipleSelection:YES];
    [_openPanel beginSheetModalForWindow:[(IMBDeviceMainPageViewController *)_delegate view].window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSFileHandlingPanelOKButton) {
            NSArray *urlArr = [_openPanel URLs];
            NSMutableArray *paths = [NSMutableArray array];
            for (NSURL *url in urlArr) {
                [paths addObject:url.path];
            }
            [self performSelector:@selector(addItemsDelay:) withObject:paths afterDelay:0.1];
        }
        _isOpen = NO;
    }];
}

- (void)addItemsDelay:(NSMutableArray *)paths
{
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        return;
    }
    [self importToDevice:paths photoAlbum:nil playlistID:0 Result:result AnnoyVC:annoyVC];
}

#pragma mark - import Action
- (void)importToDevice:(NSMutableArray *)paths photoAlbum:(IMBPhotoEntity *)photoAlbum playlistID:(int64_t)playlistID Result:(long long)result AnnoyVC:(NSViewController *)annoyVC{
    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }
    _transferController = [[IMBTransferViewController alloc] initWithIPodkey:_ipod.uniqueKey Type:_category SelectItems:paths curFolder:self.currentDevicePath];
    [_transferController setDelegate:self];
    if (result>0) {
        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
    }else{
        [self animationAddTransferView:_transferController.view];

    }
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
//delete
-(void)deleteBackupSelectedItems:(id)sender {
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
        AFCMediaDirectory *afcMedia = [_ipod.deviceHandle newAFCMediaDirectory];
        [systemManager setCurItems:0];
        _deleteTotalItems = [systemManager caculateTotalFileCount:selectedTracks afcMedia:afcMedia];
        [systemManager removeFiles:selectedTracks afcMediaDir:afcMedia];
        [afcMedia close];
        SimpleNode *node = [selectedTracks objectAtIndex:0];
        NSArray *newArray = [systemManager recursiveDirectoryContentsDics:node.parentPath];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_alertViewController._removeprogressAnimationView setProgress:100];
            double delayInSeconds = 2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [_alertViewController showRemoveSuccessViewAlertText:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil) withCount:(int)selectedSet.count];
                
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
            });
     
        });

    });
 
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

//edit
-(void)doEdit:(id)sender{
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

-(void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn {
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

- (void)dealloc {
    [nc removeObserver:self name:BackupItemDoubleClick object:nil];
    [nc removeObserver:self name:BackupItemSingleClick object:nil];
    [nc removeObserver:self name:NSViewBoundsDidChangeNotification object:nil];

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
    [super dealloc];
}
@end
