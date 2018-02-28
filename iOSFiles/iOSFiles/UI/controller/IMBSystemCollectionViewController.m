//
//  IMBSystemCollectionViewController.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/28.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBSystemCollectionViewController.h"
#import "HoverButton.h"
#import "IMBDevicePageWindow.h"
#import "IMBBackgroundBorderView.h"
#import "IMBFileSystemManager.h"
#import "IMBBlankDraggableCollectionView.h"
#import "IMBNotificationDefine.h"
//#import "IMBColorDefine.h"
#import "StringHelper.h"
#import "IMBAnimation.h"
#import "TempHelper.h"
#import "IMBTrack.h"
#import "IMBPhotoEntity.h"
#import "SystemHelper.h"
#import "NSString+Compare.h"
#import "IMBInformationManager.h"
#import "IMBSelectionView.h"
#import "IMBFolderOrFileButton.h"
#import "IMBAnimateProgressBar.h"
#import "StringHelper.h"
#import <objc/runtime.h>
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

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    if (self = [self init]) {
        _ipod = [ipod retain];
        _information = [[IMBInformationManager shareInstance].informationDic objectForKey:_ipod.uniqueKey];
//        _category = category;
        _delegate = delegate;
//        _delArray = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [super doChangeLanguage:notification];
        [self configNoDataView];
    });
}

- (void)awakeFromNib {
    [_toolBarView setHiddenIndexes:@[@(IMBToolBarNoData)]];
    [_toolBarView setDelegate:self];
  
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
    [advanceButton setMouseEnteredImage:[NSImage imageNamed:@"backup_advance_enter"]  mouseExitImage:[NSImage imageNamed:@"backup_advance"] mouseDownImage:[NSImage imageNamed:@"backup_advance2"]  forBidImage:[NSImage imageNamed:@"backup_advance3"]];
    [advanceButton setIsDrawBorder:NO];
    [backButton setMouseEnteredImage:[NSImage imageNamed:@"backup_retreat_enter"]  mouseExitImage:[NSImage imageNamed:@"backup_retreat"] mouseDownImage:[NSImage imageNamed:@"backup_retreat2"]  forBidImage:[NSImage imageNamed:@"backup_retreat3"]];
    [backButton setIsDrawBorder:NO];
//    ((IMBBlankDraggableCollectionView *)_collectionView).exploreType = FileSystemExploreType;
    ((IMBBlankDraggableCollectionView *)_collectionView).forBidClick = NO;
    _collectionView.delegate = self;
    [_collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    [_collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
    [_collectionView registerForDraggedTypes:[NSArray arrayWithObjects:NSFilesPromisePboardType, NSFilenamesPboardType,NSStringPboardType,nil]];
    [_collectionView setSelectable:YES];
    [_collectionView setAllowsMultipleSelection:YES];
    
    [_collectionView setBackgroundColors:[NSArray arrayWithObjects:[NSColor whiteColor], nil]];
    [_collectionView setFocusRingType:NSFocusRingTypeNone];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *array = nil;
        array = [systemManager recursiveDirectoryContentsDics:@"/"];
    
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            [_mainBox setContentView:_detailView];
            [_arrayController removeObjects:_dataSourceArray];
            self.currentDevicePath = @"/" ;

            [_arrayController addObjects:array];
//            [_detailView removeFromSuperview];
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
    [_backandnextView setBottomBorderColor:[NSColor colorWithDeviceRed:229.0/255 green:229.9/255 blue:229.0/255 alpha:1]];
    [_backandnextView setTopBorderColor:[NSColor colorWithDeviceRed:229.0/255 green:229.9/255 blue:229.0/255 alpha:1]];
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
    [_noDataImageView setImage:[NSImage imageNamed:@"noData_filesystem"]];
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    NSString *overStr = @"点击这里添加新内容。";
    promptStr = [[NSString stringWithFormat:@"没有%@",@"文件"] stringByAppendingString:overStr];
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
        for (NSView *subview in [_collectionView subviews]) {
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
    _collectionView.forBidClick = NO;
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
        for (NSView *subview in [_collectionView subviews]) {
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
    _collectionView.forBidClick = NO;
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
                    
                    for (NSView *subview in [view subviews]) {
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
//                                    for (NSView *subview in [button subviews]) {
//                                        if ([subview isKindOfClass:[IMBSelectionView class]]) {
//                                            selectionView = (IMBSelectionView *)subview;
//                                        }
//                                    }
                                }
                            }
                        }
                    }
                    
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
//                    [_currentArray addObjectsFromArray:childArray];
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
    [_itemTitleField setTextColor:[NSColor colorWithDeviceRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1]];
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


#pragma mark - NSCollectionViewDelegate
- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event
{
    return YES;
}

- (BOOL)collectionView:(NSCollectionView *)cv writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard
{
//    NSArray *fileTypeList = [NSArray arrayWithObject:@"export"];
//    [pasteboard setPropertyList:fileTypeList
//                        forType:NSFilesPromisePboardType];
//    if (_collectionViewcanDrag) {
//        return YES;
//    }else
//    {
//        return NO;
//    }
    return YES;
}

- (NSImage *)collectionView:(NSCollectionView *)collectionView draggingImageForItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event offset:(NSPointPointer)dragImageOffset
{
    NSImage *image = [_collectionView draggingImageForItemsAtIndexes:indexes withEvent:event offset:dragImageOffset];
    NSImage *scalingimage = [[NSImage alloc] initWithSize:NSMakeSize(image.size.width, image.size.height)];
    [scalingimage lockFocus];
    [[NSColor clearColor] setFill];
    NSRectFill(NSMakeRect(0, 0, image.size.width/3.0, image.size.height/3.0));
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationLow];
    [image drawInRect:NSMakeRect(0, 0, image.size.width/3.0, image.size.height/3.0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    NSArray *selectedArray = [_arrayController selectedObjects];
    int count = (int)[selectedArray count];
    NSString *countstr = [NSString stringWithFormat:@"%d",count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:countstr?:@""];
    [str addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:12] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, str.length)];
    //    NSRect drawRect = NSMakeRect(image.size.width/6.0, image.size.height/6.0, str.size.width+8, 20);
    //    NSBezierPath *path = nil;
    //    if (count <= 9) {
    //        path = [NSBezierPath bezierPathWithRoundedRect:drawRect xRadius:10 yRadius:10];
    //    }else
    //    {
    //        path = [NSBezierPath bezierPathWithRoundedRect:drawRect xRadius:8 yRadius:8];
    //    }
    
    NSRect drawRect = NSMakeRect(image.size.width/6.0, image.size.height/6.0, str.size.width + 8, str.size.width + 8);
    
    NSBezierPath *path = nil;
    path = [NSBezierPath bezierPathWithRoundedRect:drawRect xRadius:(str.size.width + 8)/2.0 yRadius:(str.size.width + 8)/2.0];
    
    [[NSColor redColor] setFill];
    [path fill];
    [[NSColor whiteColor] setStroke];
    [path stroke];
    
    //    [str drawInRect: NSMakeRect(image.size.width/6.0 + (str.size.width+8 - str.size.width)/2.0, image.size.height/6.0+(20-str.size.height)/2.0 - 3.5, str.size.width+8, 20)];
    [str drawInRect: NSMakeRect(drawRect.origin.x+4,drawRect.origin.y +(drawRect.size.height - str.size.height )/2.0 + 1, str.size.width+8, str.size.height)];
    
    NSData *tempdata = nil;
    NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect: NSMakeRect(0, 0, image.size.width/3.0, image.size.height/3.0)];
    tempdata = [bitmap representationUsingType:NSPNGFileType properties:nil];
    [bitmap release];
    [scalingimage unlockFocus];
    [scalingimage release];
    
    NSImage *dragImage = [[[NSImage alloc] initWithData:tempdata] autorelease];
    return dragImage;
}

- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id <NSDraggingInfo>)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation
{
    return NSDragOperationCopy;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id <NSDraggingInfo>)draggingInfo index:(NSInteger)index dropOperation:(NSCollectionViewDropOperation)dropOperation
{
    if (collectionView == _collectionView) {
        NSPasteboard *pastboard = [draggingInfo draggingPasteboard];
        NSArray *boarditemsArray = [pastboard pasteboardItems];
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSPasteboardItem *item in boarditemsArray) {
            NSString *urlPath = [item stringForType:@"public.file-url"];
            NSURL *url = [NSURL URLWithString:urlPath];
            NSString *path = [url relativePath];
           
                if(![TempHelper stringIsNilOrEmpty:path]) {
                    [itemArray addObject:path];
                }
            
        }
       
        [self dropToCollectionView:collectionView paths:itemArray];
    }
    return NO;
}

- (NSArray *)collectionView:(NSCollectionView *)collectionView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropURL forDraggedItemsAtIndexes:(NSIndexSet *)indexes
{
    NSArray *namesArray = nil;
    //获取目的url
    NSString *url = [dropURL relativePath];
    //此处调用导出方法
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:indexes,@"indexSet",url,@"url",collectionView,@"collectionView", nil];
    [self performSelector:@selector(delayCollectionViewdragToMac:) withObject:dic afterDelay:0.1];
    return namesArray;
}

- (void)delayCollectionViewdragToMac:(NSDictionary *)param
{
    NSIndexSet *indexSet = [param objectForKey:@"indexSet"];
    NSString *url = [param objectForKey:@"url"];
//    NSCollectionView *collectionView = [param objectForKey:@"collectionView"];
//    if (_isiCloud && (_category == Category_CameraRoll || _category == Category_PhotoVideo)) {
//        [self dragToMac:indexSet withDestination:url withView:collectionView];
//    }else {
//        if (_isiCloudView && (_category == Category_PhotoVideo||_category == Category_Photo||_category == Category_ContinuousShooting)) {
//            [self iClouddragDownDataToMac:url];
//        }else{
//            [self dragToMac:indexSet withDestination:url withView:collectionView];
//        }
//    }
}

- (void)dropToCollectionView:(NSCollectionView *)collectionView paths:(NSMutableArray *)pathArray {
    [self dropToTabviewAndCollectionViewWithPaths:pathArray];
}
- (void)dropToTabviewAndCollectionViewWithPaths:(NSArray *)pathArray {
//    NSMutableArray *allPaths = [[NSMutableArray alloc] init];
//    NSArray *supportExtension = [[MediaHelper getSupportFileTypeArray:_category supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_ipod] componentsSeparatedByString:@";"];
//    //限制每次只能导入1000首，超过的就不导入
//    if (_category == Category_Music || _category == Category_Ringtone || _category == Category_Audiobook || _category == Category_VoiceMemos  || _category == Category_Playlist || _category == Category_Movies || _category == Category_HomeVideo || _category == Category_TVShow || _category == Category_MusicVideo || _category == Category_PhotoLibrary || _category == Category_MyAlbums) {
//        if (_ipod.beingSynchronized) {
//            [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
//            return;
//        }
//        [self getFileNames:pathArray byFileExtensions:supportExtension toArray:allPaths];
//        
//        if (allPaths.count > 1000) {
//            NSView *view = nil;
//            for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
//                if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
//                    view = subView;
//                    [view setHidden:NO];
//                    break;
//                }
//            }
//            [_alertViewController showAlertText:CustomLocalizedString(@"MSG_AddData_Tips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) SuperView:view];
//            int i = (int)allPaths.count;
//            [allPaths removeObjectsInRange:NSMakeRange(999, i - 1000)];
//        }
//    }else {
//        [allPaths addObjectsFromArray:pathArray];
//    }
//    
//    if (_category == Category_iCloudDriver){
//        [self dropUpLoad:allPaths];
//        return;
//        //        [self copyInfomationToMac:destinationPath indexSet:indexSet];
//    }
//    long long playlistID = 0;
//    if (_category == Category_Playlist) {
//        if ([self isKindOfClass:[IMBDevicePlaylistsViewController class]]) {
//            IMBDevicePlaylistsViewController *playlistsViewController = (IMBDevicePlaylistsViewController *)self;
//            int seletedIndex =  (int)playlistsViewController.playlistsTableView.selectedRow;
//            if (seletedIndex < _playlistArray.count && seletedIndex != -1) {
//                IMBPlaylist *playlist = [_playlistArray objectAtIndex:seletedIndex];
//                playlistID = playlist.iD;
//            }
//        }
//    }
//    
//    IMBPhotoEntity *albumEntity = nil;
//    if (_category == Category_MyAlbums) {
//        if ([self isKindOfClass:[IMBMyAlbumsViewController class]]) {
//            IMBMyAlbumsViewController *albumsContorller = (IMBMyAlbumsViewController *)self;
//            int seletedIndex = (int)[albumsContorller.albumTableView selectedRow];
//            if (seletedIndex == -1) {
//                return;
//            }
//            albumEntity = [_playlistArray objectAtIndex:seletedIndex];
//        }else if ([self isKindOfClass:[IMBPhotosCollectionViewController class]]) {
//            IMBPhotosCollectionViewController *contorller = (IMBPhotosCollectionViewController *)self;
//            if (contorller.curEntity != nil) {
//                albumEntity = contorller.curEntity;
//            }
//        }else if ([self isKindOfClass:[IMBPhotosListViewController class]]) {
//            IMBPhotosListViewController *contorller = (IMBPhotosListViewController *)self;
//            if (contorller.curEntity != nil) {
//                albumEntity = contorller.curEntity;
//            }
//        }
//        if (albumEntity.albumKind == 2) {
//            return;
//        }
//    }
//    
//    BOOL isAlloc = NO;
//    if (_category == Category_PhotoLibrary) {
//        if (_ipod.deviceInfo.isIOSDevice) {
//            if (albumEntity == nil) {
//                NSArray *albumArray = [_information myAlbumsArray];
//                for (IMBPhotoEntity *entity in albumArray) {
//                    if ([entity.albumTitle isEqualToString:CustomLocalizedString(@"MSG_AddPhotoToDefaultAlbum", nil)] && entity.albumKind == 1550) {
//                        albumEntity = entity;
//                        isAlloc = YES;
//                        break;
//                    }
//                }
//                if (!isAlloc) {
//                    isAlloc = YES;
//                    albumEntity = [[IMBPhotoEntity alloc] init];
//                    albumEntity.albumZpk = -4;
//                    albumEntity.albumKind = 1550;
//                    albumEntity.albumTitle = CustomLocalizedString(@"MSG_AddPhotoToDefaultAlbum", nil);
//                    albumEntity.albumType = SyncAlbum;
//                }else {
//                    isAlloc = NO;
//                }
//            }
//        }
//    }
//    
//    if (_category == Category_Storage || _category == Category_System) {
//        //        NSViewController *annoyVC = nil;
//        //        long long result = [self checkNeedAnnoy:&(annoyVC)];
//        //        if (result == 0) {
//        //            return;
//        //        }
//        //
//        //        [self importToDevice:[NSMutableArray arrayWithArray:allPaths] photoAlbum:albumEntity playlistID:playlistID Result:result AnnoyVC:annoyVC];
//        
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:allPaths, @"supportArray", albumEntity, @"albumEntity", playlistID, @"playlistID", nil];
//        [self performSelector:@selector(executeAction:) withObject:dic afterDelay:0.1];
//        
//        [allPaths autorelease], allPaths = nil;
//        return;
//    }
//    
//    
//    NSMutableArray *supportArray = [[NSMutableArray alloc]init];
//    NSArray *supportFiles = [[MediaHelper getSupportFileTypeArray:_category supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_ipod] componentsSeparatedByString:@";"];
//    for (NSString *path in allPaths) {
//        NSLog(@"%@",path.pathExtension);
//        if ([supportFiles containsObject:[path.pathExtension lowercaseString]]) {
//            [supportArray addObject:path];
//        }
//    }
//    
//    if (supportArray.count > 0) {
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:supportArray, @"supportArray", albumEntity, @"albumEntity", playlistID, @"playlistID", nil];
//        [self performSelector:@selector(executeAction:) withObject:dic afterDelay:0.1];
//    }
//    [supportArray autorelease], supportArray = nil;
//    [allPaths autorelease], allPaths = nil;
}

#pragma mark OperaitonActions
- (void)refresh {
    [_mainBox setContentView:_loadingView];
    for (NSView *subview in [_collectionView subviews]) {
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
    [_loadingAnimationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *array = [systemManager recursiveDirectoryContentsDics:_currentDevicePath];
        dispatch_async(dispatch_get_main_queue(), ^{
            //            [self disableFunctionBtn:YES];
            [_arrayController removeObjects:_dataSourceArray];
            if ([array count]>120) {
                currentIndex = 0;
                [self loadItem];
            }else
            {
                [_arrayController addObjects:array];
            }
            
            
            [_mainBox setContentView:_detailView];
            
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

- (void)addItems{
    _openPanel = [NSOpenPanel openPanel];
    _isOpen = YES;
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel setCanChooseFiles:YES];
    [_openPanel setAllowsMultipleSelection:YES];
    [_openPanel beginSheetModalForWindow:[_delegate window] completionHandler:^(NSModalResponse returnCode) {
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
//    long long result = [self checkNeedAnnoy:&(annoyVC)];
//    if (result == 0) {
//        return;
//    }
    [self importToDevice:paths photoAlbum:nil playlistID:0 Result:1 AnnoyVC:annoyVC];
}

#pragma mark - import Action
- (void)importToDevice:(NSMutableArray *)paths photoAlbum:(IMBPhotoEntity *)photoAlbum playlistID:(int64_t)playlistID Result:(long long)result AnnoyVC:(NSViewController *)annoyVC{
    if (_transferViewController != nil) {
        [_transferViewController release];
        _transferViewController = nil;
    }
    _transferViewController = [[IMBTransferViewController alloc]initWithToDevicePath:paths WithiPodKey:_ipod.uniqueKey curFolder:self.currentDevicePath];
//    _transferController = [[IMBTransferViewController alloc] initWithIPodkey:_ipod.uniqueKey Type:_category SelectItems:paths curFolder:self.currentDevicePath];
//    [_transferController setDelegate:self];
////    if (result>0) {
//        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
//    }else{
    [_transferViewController.view setFrame:NSMakeRect(0, 0, [(IMBDevicePageWindow *)_delegate window].contentView.frame.size.width, [(IMBDevicePageWindow *)_delegate window].contentView.frame.size.height)];
    [[(IMBDevicePageWindow *)_delegate window].contentView addSubview:_transferViewController.view];
    [_transferViewController.view setWantsLayer:YES];
    [_transferViewController.view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-_transferViewController.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
    [self refresh];
//
//    }
}

- (void)animationAddTransferViewfromRight:(NSView *)view AnnoyVC:(NSViewController *)AnnoyVC;
{
//    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//        [view setFrame:NSMakeRect(0, 0, [(IMBDeviceMainPageViewController *)_delegate view].frame.size.width, [_delegate windows].content.frame.size.height)];
//        [[(IMBDeviceMainPageViewController *)_delegate view] addSubview:view];
//        [view setWantsLayer:YES];
//        [view.layer  addAnimation:[IMBAnimation moveX:0.5 fromX:[NSNumber numberWithInt:view.frame.size.width] toX:[NSNumber numberWithInt:0] repeatCount:1 beginTime:0] forKey:@"movex"];
//    } completionHandler:^{
//        [(AnnoyVC).view removeFromSuperview];
//        [(AnnoyVC) release];
//    }];
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

- (void)deleteItem{
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
  
    if (_delArray != nil) {
        [_delArray release];
        _delArray = nil;
    }
    _delArray = [[NSMutableArray alloc]init];
    //    [_alertViewController._removeprogressAnimationView setProgress:0];
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
                      //            [_alertViewController._removeprogressAnimationView setProgress:100];
            double delayInSeconds = 2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //                [_alertViewController showRemoveSuccessViewAlertText:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil) withCount:(int)selectedSet.count];
                for (NSView *subview in [_collectionView subviews]) {
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
                [_mainBox setContentView:_detailView];
                [_loadingAnimationView endAnimation];

                [_collectionView setSelectionIndexes:nil];
                [self singlecCick:nil];
            });
            
        });
        
    });
}

- (void)deleteBackupSelectedItems:(id)sender {
  
}

- (void)toMac{
    //弹出路径选择框
    _openPanel = [NSOpenPanel openPanel];
    _isOpen = YES;
    [_openPanel setAllowsMultipleSelection:NO];
    [_openPanel setCanChooseFiles:NO];
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel beginSheetModalForWindow:[_delegate window] completionHandler:^(NSInteger result) {
        if (result== NSFileHandlingPanelOKButton) {
            [self performSelector:@selector(systemtoMacDelay:) withObject:_openPanel afterDelay:0.1];
        }else{
            NSLog(@"other other other");
        }
        _isOpen = NO;
    }];
}

- (void)systemtoMacDelay:(NSOpenPanel *)openPanel
{
//    NSViewController *annoyVC = nil;
//    long long result = [self checkNeedAnnoy:&(annoyVC)];
//    if (result == 0) {
//        return;
//    }
    NSString * path =[[openPanel URL] path];
    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:Category_System]];
    
    
    NSIndexSet *selectedSet = [self selectedItems];
    NSMutableArray *selectedTracks = [NSMutableArray array];
    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [selectedTracks addObject:[_dataSourceArray objectAtIndex:idx]];
    }];

//    NSArray *selectedFile = [_arrayController selectedObjects];
    if (_transferViewController != nil) {
        [_transferViewController release];
        _transferViewController = nil;
    }
    _transferViewController = [[IMBTransferViewController alloc]initWithUniqueKey:_ipod.uniqueKey withSelectedAry:selectedTracks exportFolder:filePath withDelegate:self];
    [_transferViewController.view setFrame:NSMakeRect(0, 0, [(IMBDevicePageWindow *)_delegate window].contentView.frame.size.width, [(IMBDevicePageWindow *)_delegate window].contentView.frame.size.height)];
    [[(IMBDevicePageWindow *)_delegate window].contentView addSubview:_transferViewController.view];
    [_transferViewController.view setWantsLayer:YES];
    [_transferViewController.view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-_transferViewController.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
    
}

//- (void)setDeleteCurItems:(int)curItem {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        float itemCount = curItem;
//        if (curItem < 0) {
//            itemCount = 0;
//        }else if (curItem > _deleteTotalItems) {
//            itemCount = _deleteTotalItems;
//        }
//        float progress = itemCount / _deleteTotalItems * 100;
//        [_alertViewController._removeprogressAnimationView setProgress:progress];
//    });
//}

//-(void)doEdit:(id)sender{
//    NSIndexSet *selectedItems = [self selectedItems];
//    if (selectedItems == nil || selectedItems.count>1) {
//        [self showAlertText:CustomLocalizedString(@"System_selectOne_item", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
//        return;
//    }else if (selectedItems.count == 0){
//        [self showAlertText:CustomLocalizedString(@"System_selectOne_item", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
//        return;
//    }
//    NSView *view = nil;
//    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
//        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
//            view = subView;
//            break;
//        }
//    }
//    [view setHidden:NO];
//    SimpleNode *seletednode = nil;
//    NSInteger seleted = [_arrayController selectionIndex];
//    if (_dataSourceArray.count <= seleted || seleted == -1) {
//        return;
//    }
//    seletednode = [_dataSourceArray objectAtIndex:seleted];
//    NSString *nameString = nil;
//    if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
//        nameString= CustomLocalizedString(@"List_Header_id_Name", nil);
//    }else {
//       nameString= [NSString stringWithFormat:@"%@%@",CustomLocalizedString(@"List_Header_id_Name", nil),@":"];
//    }
//    
//    
//    int i = [_alertViewController showTitleName:nameString InputTextFiledString:seletednode.fileName OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
//    if (i == 1) {
//        NSString *str = [[_alertViewController reNameInputTextField] stringValue];
//        if ([str isEqualToString:seletednode.fileName]) {
//            [_alertViewController unloadAlertView:_alertViewController.reNameView];
//            [_alertViewController.renameLoadingView setHidden:YES];
//            return;
//        }
//        [_alertViewController.renameLoadingView setHidden:NO];
//        [_alertViewController.renameLoadingView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
//        [_alertViewController.renameLoadingView setImage:[StringHelper imageNamed:@"registedLoading"]];
//        [_alertViewController.renameLoadingView.layer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:-2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
//        if (seletednode != nil) {
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                [systemManager rename:seletednode withfileName:str];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self singlecCick:nil];
//                    [_alertViewController unloadAlertView:_alertViewController.reNameView];
//                    [_alertViewController.renameLoadingView setHidden:YES];
//                });
//            });
//        }
//    }
//}

//-(void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn {
//    _isSearch = YES;
//    _searchFieldBtn = searchBtn;
//    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fileName CONTAINS[cd] %@ ",searchStr];
//        [_arrayController setFilterPredicate:predicate];
//    }else{
//        _isSearch = NO;
//        [_arrayController setFilterPredicate:nil];
//    }
//}

//- (void)reloadTableView{
//    [self doSearchBtn:@"" withSearchBtn:_searchFieldBtn];
//}

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

#import "IMBPhotoEntity.h"
@implementation IMBPhotoCollectionViewItem
//static int i=0;
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    IMBBlankDraggableCollectionView *blankCollectionView = (IMBBlankDraggableCollectionView *)[self.view superview];
    NSArray *itemArray = [blankCollectionView subviews];
    NSArray *allArray = [blankCollectionView content];
    NSUInteger index = [itemArray indexOfObject:self.view];
    if (allArray.count > index) {
        IMBPhotoEntity *photoEntity = [allArray objectAtIndex:index];
        photoEntity.checkState = selected;
        photoEntity.isHiddenSelectImage = !selected;
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end


@implementation IMBPhotoImageView
@synthesize isSelected = _isSected;
@synthesize loadImage = _loadImage;
@synthesize isload = _isload;
@synthesize isfree = _isfree;
@synthesize exist = _exist;
- (void)awakeFromNib
{
    //    _isDraw = NO;
    //    [super awakeFromNib];
    //    [self wantsLayer];
    
}

- (void)dealloc
{
    if (_loadImage != nil) {
        [_loadImage release];
        _loadImage = nil;
    }
    
    
    [super dealloc];
}


//- (void)drawRect:(NSRect)dirtyRect
//{
//    [super drawRect:dirtyRect];
//
//    if (_isDraw) {
//        NSRect imageRect;
//        imageRect.origin = NSZeroPoint;
//        imageRect.size = _loadImage.size;
//
//        NSRect drRect;
//        drRect.origin = NSMakePoint(0, (dirtyRect.size.height - _loadImage.size.height) / 2);
//        drRect.size = _loadImage.size;
//
//        [_loadImage drawInRect:drRect fromRect:imageRect operation:NSCompositeDestinationOver fraction:1 respectFlipped:YES hints:nil];
//    }
//
//    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
//    [[NSColor grayColor] setStroke];
//    [path stroke];
//    if (_isSected) {
//
//    }
//    self.layer.shadowOpacity = 0.3;
//    self.layer.shadowColor = [NSColor blackColor].CGColor;
//    self.layer.shadowRadius = 3;
//    self.layer.shadowOffset = CGSizeMake(1, 1);
//}

//- (void)drawRect:(NSRect)dirtyRect
//{
//
//    [super drawRect:dirtyRect];
//
//}

//- (void)drawRect:(NSRect)dirtyRect
//{
//    @autoreleasepool {
//         [self.image drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeDestinationOver fraction:1 respectFlipped:YES hints:nil];
//    }
//
//}
@end


@implementation IMBCollectionImageView
@synthesize backgroundImage = _backgroundImage;
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setImageScaling:NSImageScaleProportionallyUpOrDown];
}

- (void)dealloc{
    [_backgroundImage release],_backgroundImage = nil;
    [super dealloc];
}

@end


@implementation IMBFolderOrFileCollectionItemView
@synthesize done = _done;

- (void)mouseDown:(NSEvent *)theEvent {
    IMBBlankDraggableCollectionView *superView = (IMBBlankDraggableCollectionView *)[self superview];
//    if (superView.forBidClick) {
//        return;
//    }
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
            superView.forBidClick = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:BackupItemDoubleClick object:superView];
        }
        if (theEvent.clickCount == 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:BackupItemSingleClick object:superView];
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
                str = [NSString stringWithFormat:@"%@ \n %@:-- \n %@:%@",node.fileName,@"Size",@"Date",node.creatDate];
            }else {
                str = [NSString stringWithFormat:@"%@ \n %@:%@ \n %@:%@",node.fileName,@"Size",[StringHelper getFileSizeString:node.itemSize reserved:2],@"Date",node.creatDate];
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
#import "IMBDriveEntity.h"
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
        
    }else if ([node isKindOfClass:[IMBDriveEntity class]]){
        IMBDriveEntity *node = self.representedObject;
//        if (!node.isCoping) {
            [super setSelected:selected];
            [node setCheckState:selected];
//        }else{
//            [super setSelected:NO];
//            [node setCheckState:NO];
//        }
        IMBFolderOrFileCollectionItemView *itemView = (IMBFolderOrFileCollectionItemView *)self.view;
        for (NSView *subview in [itemView subviews]) {
            if ([subview isKindOfClass:[IMBFolderOrFileButton class]]) {
//                if (node.isCoping) {
//                    [node.coprogressBar setIsFastDrive:YES];
//                    [subview addSubview:node.coprogressBar];
//                    [subview addSubview:node.coCloseButton];
//                }
//                if (!node.isCoping) {
                    [((IMBFolderOrFileButton *)subview) setSelected:selected];
//                }
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
