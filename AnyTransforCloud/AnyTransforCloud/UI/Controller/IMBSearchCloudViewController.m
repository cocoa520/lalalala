//
//  IMBSearchCloudViewController.m
//  AnyTransforCloud
//
//  Created by hym on 24/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBSearchCloudViewController.h"
#import "BaseDrive.h"
#import "IMBCloudManager.h"
#import "IMBBaseManager.h"
#import "IMBDropBoxManager.h"
#import "IMBCloudDetailCollectionViewItem.h"
#import "IMBFileTableCellView.h"
#import "IMBTableRowView.h"
#import "IMBMoreMenuView.h"
#import "IMBCustomView.h"
#import "CloudItemView.h"
#import "IMBOneDriveManager.h"
#import "IMBPCloudManager.h"
#import "IMBBoxManager.h"
#import "IMBGoogleManager.h"
#import "CloudItemView.h"
#import "IMBiCloudDriveManager.h"
#import "IMBTextLinkButton.h"
#import "IMBTagImageView.h"
#import "IMBArrowButton.h"
#import "IMBCloudCollectionView.h"
#import "LoadingView.h"

@implementation IMBSearchCloudViewController
@synthesize searchManager = _searchManager;

- (id)initWithDelegate:(id)delegate {
    if (self = [super initWithDelegate:delegate]) {
        _searchManager = [IMBSearchManager singleton];
        _searchManager.delegate = self;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    _selectCount = 0;
    [_collectionScrollView setListener:_collectionView];
    [_tableViewScrollView setListener:_itemTableView];
    [(IMBCloudCollectionView *)_collectionView setCollDelegate:self];
    _itemTableViewcanDrag = NO;
    _itemTableViewcanDrop = NO;
    
    [self configNoDataView];
    
    _oldWidthDic = [[NSMutableDictionary alloc] init];
    _oldDocwsidDic = [[NSMutableDictionary alloc] init];
    _oldFileidDic = [[NSMutableDictionary alloc] init];
    _tempDic = [[NSMutableDictionary alloc] init];
    _oldPathTextDic = [[NSMutableDictionary alloc] init];
    _allPathBtnDic = [[NSMutableDictionary alloc] init];
    _toolBarArr = [[NSMutableArray alloc] init];
    
    [_topLeftView setHidden:YES];
    [_topLeftView2 setHidden:YES];
    
    _doubleclickCount = 1;
    _curSelectView = 1;
    
    [self setToolbarViewWithHasFolder:NO withHasFile:NO withIsMultiple:NO];
    
    NSCollectionViewFlowLayout* flowLayout = [[NSCollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = NSMakeSize(166, 166);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.sectionInset = NSEdgeInsetsMake(0, 30, 6, 30);
    _collectionView.collectionViewLayout = flowLayout;
    [flowLayout release];
    
    [_nc addObserver:self selector:@selector(itemViewMouseMove:) name:GLOBAL_MOUSE_MOVE object:nil];
    [_nc addObserver:self selector:@selector(saveName:) name:GLOBAL_MOUSE_DOWN object:nil];
    [_nc addObserver:self selector:@selector(saveEditName:) name:GLOBAL_KEY_ENTER object:nil];
    [_nc addObserver:self selector:@selector(removePathMenuView:) name:GLOBAL_MOUSE_DOWN object:nil];
    [_nc addObserver:self selector:@selector(removeSortMenuView:) name:GLOBAL_MOUSE_DOWN object:nil];
    [_nc addObserver:self selector:@selector(globalMouseScrollWhell:) name:GLOBAL_MOUSE_SCROLLWHELL object:nil];
    [_nc addObserver:self selector:@selector(removeRightKeyMenuView:) name:GLOBAL_MOUSE_DOWN object:nil];
    
    [_contentBox setWantsLayer:YES];
    
    _currentDriveID = @"0";
    _currentGetListPath = @"0";
    [_collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    [_collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:YES];
    [_collectionView registerForDraggedTypes:[NSArray arrayWithObjects:NSFilesPromisePboardType, NSFilenamesPboardType,NSStringPboardType,nil]];
    
    [_rightContentView setWantsLayer:YES];
    [_leftContentView setWantsLayer:YES];
    [_leftContentView setFrame:NSMakeRect(0, 0, _bgView.frame.size.width , self.view.frame.size.height)];
    [_rightContentView setFrame:NSMakeRect(_bgView.frame.size.width, 0, _rightContentView.frame.size.width, self.view.frame.size.height)];
    _sortMenuView = [[IMBSortMenuView alloc] initWithFrame:NSMakeRect(_topContentView.frame.size.width - 169, _topContentView.frame.origin.y - 200, 158, 210)];
    for (int itemTag = 1; itemTag <= 5; itemTag++) {
        IMBSortItem *item = [[IMBSortItem alloc] initWithFrame:NSMakeRect(5, 200 - itemTag*38, 148, 38)];
        [item setItemTag:itemTag];
        [item setTarget:self];
        [item setAction:@selector(sortMenuItemClick:)];
        [_sortMenuView addSubview:item];
        [item release];
        item = nil;
    }
    [self.view setWantsLayer:YES];
    [self.view.layer setCornerRadius:5];
    
    [_contentBox setContentView:_loadingBgView];
    [_loadingAnimationView startAnimation];
}

#pragma mark - nodataView
- (void)configNoDataView {
    [_noDataImage setImage:[NSImage imageNamed:@"nodata_files"]];
    NSString *promptStr = [[CustomLocalizedString(@"NoData_FileAddButton", nil) stringByAppendingString:@" "]stringByAppendingString:CustomLocalizedString(@"NoData_FileAdd", nil)];
    [_noDataText setNormalString:promptStr WithLinkString1:CustomLocalizedString(@"NoData_FileAddButton", nil) WithLinkString2:@"" WithNormalColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)]WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_noDataText setAlignment:NSCenterTextAlignment];
    [_noDataText setDelegate:self];
    [_noDataText setSelectable:YES];
}

- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    if ([link isEqualToString:CustomLocalizedString(@"NoData_FileAddButton", nil)]) {
        [self upload:nil];
    }
    return YES;
}

#pragma mark - path button config
- (void)configSelectPathButtonWithButtonTag:(int)buttonTag WithButtonTitle:(NSString *)buttonTitle {
    
    NSRect textRect = [StringHelper calcuTextBounds:buttonTitle font:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    if (textRect.size.width > 112) {
        textRect.size.width = 112;
    }
    int width = textRect.size.width + 12;
    [_oldWidthDic setObject:[NSNumber numberWithInt:width] forKey:[NSNumber numberWithInt:buttonTag]];
    int height = textRect.size.height + 4;
    int oldWidth = 0;
    for (int i = 1; i <= buttonTag; i++) {
        if ([_oldWidthDic.allKeys containsObject:[NSNumber numberWithInt:i - 1]]) {
            oldWidth += [[_oldWidthDic objectForKey:[NSNumber numberWithInt:i - 1]] intValue];
        }
    }
    int totalWidth = 10 + (buttonTag - 1)*12 + oldWidth + width;
    if (totalWidth > _topLeftView.frame.size.width) {
        [_topLeftView setHidden:YES];
        [_topLeftView2 setHidden:NO];
        [_arrowImage setImage:[NSImage imageNamed:@"arrow_right"]];
        [_lastPathBtn setButtonWithTitle:buttonTitle WithFontSize:12.0 WithTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTitleEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] WithTitleDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)]];
        [_lastPathBtn setEnabled:NO];
        [_lastPathBtn setNeedsDisplay:YES];
        
    } else {
        [_topLeftView setHidden:NO];
        [_topLeftView2 setHidden:YES];
    }
    if (!_isClickMenu) {
        IMBTextLinkButton *button = [[IMBTextLinkButton alloc] initWithFrame:NSMakeRect(10 + (buttonTag - 1)*12 + oldWidth, (_topLeftView.frame.size.height - height)/2 + 2, width, height)];
        
        [button setButtonWithTitle:buttonTitle WithFontSize:12.0 WithTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTitleEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] WithTitleDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)]];
        [button setToolTip:buttonTitle];
        [button setTag:buttonTag];
        [button setTarget:self];
        [button setAction:@selector(pathButtonClick:)];
        [_topLeftView addSubview:button];
        if (buttonTag - 1) {
            IMBTagImageView *arrowImageView = [[IMBTagImageView alloc] initWithFrame:NSMakeRect(button.frame.origin.x - 16, (_topLeftView.frame.size.height - 11)/2.0 - 1, 12, 11)];
            [arrowImageView setImage:[NSImage imageNamed:@"arrow_right"]];
            [arrowImageView setViewTag:buttonTag];
            [_topLeftView addSubview:arrowImageView];
            [arrowImageView release];
            arrowImageView = nil;
        }
        [_allPathBtnDic setObject:button forKey:[NSNumber numberWithInt:buttonTag]];
        for (IMBTextLinkButton *linkButton in _allPathBtnDic.allValues) {
            if (linkButton.tag == buttonTag) {
                [linkButton setEnabled:NO];
            } else {
                [linkButton setEnabled:YES];
            }
            [linkButton setNeedsDisplay:YES];
        }
        [button release];
        button = nil;
    } else {
        _isClickMenu = NO;
        if (buttonTag == 1) {
            IMBTextLinkButton *button = [[IMBTextLinkButton alloc] initWithFrame:NSMakeRect(10 + (buttonTag - 1)*12 + oldWidth, (_topLeftView.frame.size.height - height)/2 + 2, width, height)];
            
            [button setButtonWithTitle:buttonTitle WithFontSize:12.0 WithTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTitleEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_normalColor", nil)] WithTitleDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)]];
            [button setToolTip:buttonTitle];
            [button setTag:buttonTag];
            [button setTarget:self];
            [button setAction:@selector(pathButtonClick:)];
            [_topLeftView addSubview:button];
            
            [_allPathBtnDic setObject:button forKey:[NSNumber numberWithInt:buttonTag]];
            [button setEnabled:NO];
            [button release];
            button = nil;
        }
    }
}

//点击切换界面
- (void)pathButtonClick:(id)sender {
    _currentModel = nil;
    int tag = 0;
    NSString *buttonTitle = @"";
    if ([sender isKindOfClass:[IMBPathItem class]]) {
        tag = [(IMBPathItem *)sender itemTag];
        buttonTitle = [(IMBPathItem *)sender pathTitle];
        _isClickMenu = YES;
    } else {
        tag = (int)((IMBTextLinkButton *)sender).tag;
        buttonTitle = [(IMBTextLinkButton *)sender buttonTitle];
        _isClickMenu = NO;
    }
    
    int viewCount = (int)[_topLeftView subviews].count;
    for (int i = viewCount - 1; i > 0; i--) {
        NSView *subView = [[_topLeftView subviews] objectAtIndex:i];
        if ([subView isKindOfClass:[NSClassFromString(@"IMBTextLinkButton") class]]) {
            if (subView.tag > tag) {
                [subView removeFromSuperview];
            }
        }
        if ([subView isKindOfClass:[NSClassFromString(@"IMBTagImageView") class]]) {
            if (((IMBTagImageView *)subView).viewTag > tag) {
                [subView removeFromSuperview];
            }
        }
    }
    
    for (int i = 1; i <= _doubleclickCount; i++) {
        if (tag == i) {
            [self changeContentViewWithDataArr:[_tempDic objectForKey:[NSNumber numberWithInt:i]]];
            for (int j = i + 1; j <= _doubleclickCount; j++) {
                if ([_tempDic.allKeys containsObject:[NSNumber numberWithInt:j]]) {
                    [_tempDic removeObjectForKey:[NSNumber numberWithInt:j]];
                }
                if ([_oldWidthDic.allKeys containsObject:[NSNumber numberWithInt:j]]) {
                    [_oldWidthDic removeObjectForKey:[NSNumber numberWithInt:j]];
                }
                if ([_oldDocwsidDic.allKeys containsObject:[NSNumber numberWithInt:j]]) {
                    [_oldDocwsidDic removeObjectForKey:[NSNumber numberWithInt:j]];
                }
                if ([_oldFileidDic.allKeys containsObject:[NSNumber numberWithInt:j]]) {
                    [_oldFileidDic removeObjectForKey:[NSNumber numberWithInt:j]];
                }
                if ([_allPathBtnDic.allKeys containsObject:[NSNumber numberWithInt:j]]) {
                    [_allPathBtnDic removeObjectForKey:[NSNumber numberWithInt:j]];
                }
            }
            _doubleclickCount = i;
            
            break;
        }
    }
    
    if (_isClickMenu) {
        if (tag == 1) {
            NSView *subView = [[_topLeftView subviews] objectAtIndex:0];
            if ([subView isKindOfClass:[NSClassFromString(@"IMBTextLinkButton") class]]) {
                [subView removeFromSuperview];
            }
        }
        [self configSelectPathButtonWithButtonTag:tag WithButtonTitle:buttonTitle];
    }

    if ([_oldDocwsidDic.allKeys containsObject:[NSNumber numberWithInt:tag]]) {
        _currentDriveID = [_oldDocwsidDic objectForKey:[NSNumber numberWithInt:tag]];
    }
    if ([_oldFileidDic.allKeys containsObject:[NSNumber numberWithInt:tag]]) {
        _currentGetListPath = [_oldFileidDic objectForKey:[NSNumber numberWithInt:tag]];
    }
    
    for (IMBTextLinkButton *linkButton in _allPathBtnDic.allValues) {
        if (linkButton.tag == tag) {
            [linkButton setEnabled:NO];
        } else {
            [linkButton setEnabled:YES];
        }
        [linkButton setNeedsDisplay:YES];
    }
    
    [_itemTableView reloadData];
    [self removePathMenuViewAnimation];

}

//点击打开路径menu
- (IBAction)pathMenuButtonClick:(id)sender {
    if (!_isPathMenuOpen) {
        _isPathMenuOpen = YES;
        int pathCount = (int)_tempDic.allKeys.count;
        int totalHeight = (pathCount - 1) * 48 + 20;
        _pathMenu = [[IMBPathMenuView alloc] initWithFrame:NSMakeRect(_topLeftView2.frame.origin.x + _pathMenuBtn.frame.origin.x - 4, _pathMenuBtn.frame.origin.y - totalHeight + _topContentView.frame.origin.y, 182, totalHeight)];
        for (int itemTag = 1; itemTag < pathCount; itemTag++) {
            IMBPathItem *item = [[IMBPathItem alloc] initWithFrame:NSMakeRect(5, totalHeight - 10 - itemTag*48, 172, 48)];
            [item setItemTag:itemTag];
            if (itemTag == 1) {
                IMBCloudEntity *cloudEntity = [[IMBCloudEntity alloc] init];
                [TempHelper setDriveDefultImage:_baseManager.baseDrive CloudEntity:cloudEntity];
                [item setPathTitle:cloudEntity.name];
                [item setPathImage:cloudEntity.image];
                [cloudEntity release];
                cloudEntity = nil;
            } else {
                IMBDriveModel *model = [_oldPathTextDic objectForKey:[NSNumber numberWithInt:itemTag]];
                [item setPathTitle:model.fileName];
                [item setPathImage:model.iConimage];
            }
            [item setTarget:self];
            [item setAction:@selector(pathButtonClick:)];
            [_pathMenu addSubview:item];
            [item release];
            item = nil;
        }
        [_pathMenu setWantsLayer:YES];
        [self.view addSubview:_pathMenu];
    }
}

- (void)removePathMenuView:(NSNotification *)notifi {
    NSEvent *theEvent = notifi.object;
    NSPoint point = [_pathMenu convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [_pathMenu bounds], [_pathMenu isFlipped]);
    
    NSPoint point1 = [_pathMenuBtn convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner1 = NSMouseInRect(point1, [_pathMenuBtn bounds], [_pathMenuBtn isFlipped]);
    
    if (_isPathMenuOpen) {
        if (!inner && !inner1) {
            [self removePathMenuViewAnimation];
        }
    }
}

- (void)removePathMenuViewAnimation {
    _isPathMenuOpen = NO;
    [_pathMenu removeFromSuperview];
    if (_pathMenu) {
        [_pathMenu release];
        _pathMenu = nil;
    }
}

- (void)changeContentViewWithDataArr:(NSMutableArray *)dataArr {
    [_dataSourAryM addObjectsFromArray:dataArr];
    
    [_collectionView reloadData];
    [_selectAllBtn setState:NSOffState];

    if (_dataSourAryM != nil && _dataSourAryM.count > 0) {
        if (_curSelectView == 0) {
            [_contentBox setContentView:_tableBgView];
        } else {
            [_contentBox setContentView:_collectionScrollView];
        }
    } else {
        [_contentBox setContentView:_noDataView];
    }
    [self setToolbarViewWithHasFolder:NO withHasFile:NO withIsMultiple:NO];
}

- (void)loadPromtViewTitle:(NSString *)title withPromptEnum:(promptTypeEnum)promptEnum {
    NSRect titleRect = [StringHelper calcuTextBounds:title font:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    int width = 0;
    width =  titleRect.size.width + 60;
    IMBPromptView *promptView = [[IMBPromptView alloc]initWithFrame:NSMakeRect(0, 0, width, 36)];
    if (promptEnum == successedType) {
        [promptView setFillColor:[StringHelper getColorFromString:CustomColor(@"prompt_success_bgView_fillColor", )] withBorderColor:[StringHelper getColorFromString:CustomColor(@"prompt_success_bgView_borderColor", )]];
        [promptView setImage:[NSImage imageNamed:@"alert_complete"] WithTextString:title withIsLoading:NO withIsState:promptEnum];
    } else if (promptEnum == failedType) {
        [promptView setFillColor:[StringHelper getColorFromString:CustomColor(@"prompt_fail_bgView_fillColor", )] withBorderColor:[StringHelper getColorFromString:CustomColor(@"prompt_fail_bgView_borderColor", )]];
        [promptView setImage:[NSImage imageNamed:@"alert_note"] WithTextString:title withIsLoading:NO withIsState:promptEnum];
    } else {
        [promptView setFillColor:[StringHelper getColorFromString:CustomColor(@"prompt_wait_bgView_fillColor", )] withBorderColor:[StringHelper getColorFromString:CustomColor(@"prompt_wait_bgView_borderColor", )]];
        [promptView setImage:nil WithTextString:title withIsLoading:NO withIsState:promptEnum];
    }
    
    [self addTipPromptCustomView:promptView withIsDeleteView:NO];
    [promptView release];
    promptView = nil;
}

#pragma mark - Collection
- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSourAryM.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataSourAryM.count > 0) {
        IMBCloudDetailCollectionViewItem* item = [_collectionView makeItemWithIdentifier:@"IMBCloudDetailCollectionViewItem" forIndexPath:indexPath];
        IMBDriveModel *model = [_dataSourAryM objectAtIndex:indexPath.item];
        item.model = model;
        item.delegate = self;
        CloudItemView *itemView = (CloudItemView *)item.view;
        itemView.delegate = self;
//        [item setSelected:model.checkState];
        return item;
    }else {
        return nil;
    }
}

- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths withEvent:(NSEvent *)event {
    return YES;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths toPasteboard:(NSPasteboard *)pasteboard {
    NSArray *fileTypeList = [NSArray arrayWithObject:@"export"];
    [pasteboard setPropertyList:fileTypeList forType:NSFilesPromisePboardType];
    return YES;
}

- (NSImage *)collectionView:(NSCollectionView *)collectionView draggingImageForItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths withEvent:(NSEvent *)event offset:(NSPointPointer)dragImageOffset {
    NSImage *image = [_collectionView draggingImageForItemsAtIndexPaths:indexPaths withEvent:event offset:dragImageOffset];
    NSImage *scalingimage = [[NSImage alloc] initWithSize:NSMakeSize(image.size.width, image.size.height)];
    [scalingimage lockFocus];
    [[NSColor clearColor] setFill];
    NSRectFill(NSMakeRect(0, 0, image.size.width/3.0, image.size.height/3.0));
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationLow];
    [image drawInRect:NSMakeRect(0, 0, image.size.width/3.0, image.size.height/3.0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    int count= (int)[_collectionView selectionIndexes].count;
//    int count = (int)[selectedArray count];
    NSString *countstr = [NSString stringWithFormat:@"%d",count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:countstr?:@""];
    [str addAttribute:NSFontAttributeName value:[NSFont boldSystemFontOfSize:12] range:NSMakeRange(0, str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, str.length)];

    NSRect drawRect = NSMakeRect(image.size.width/6.0, image.size.height/6.0, str.size.width + 8, str.size.width + 8);
    
    NSBezierPath *path = nil;
    path = [NSBezierPath bezierPathWithRoundedRect:drawRect xRadius:(str.size.width + 8)/2.0 yRadius:(str.size.width + 8)/2.0];
    
    [[NSColor redColor] setFill];
    [path fill];
    [[NSColor whiteColor] setStroke];
    [path stroke];
    
    //    [str drawInRect: NSMakeRect(image.size.width/6.0 + (str.size.width+8 - str.size.width)/2.0, image.size.height/6.0+(20-str.size.height)/2.0 - 3.5, str.size.width+8, 20)];
    [str drawInRect: NSMakeRect(drawRect.origin.x+4,drawRect.origin.y +(drawRect.size.height - str.size.height )/2.0 + 1, str.size.width+8, str.size.height)];
    [str release];
    str = nil;
    NSData *tempdata = nil;
    NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect: NSMakeRect(0, 0, image.size.width/3.0, image.size.height/3.0)];
    tempdata = [bitmap representationUsingType:NSPNGFileType properties:[NSDictionary dictionary]];
    [bitmap release];
    [scalingimage unlockFocus];
    [scalingimage release];
    
    NSImage *dragImage = [[[NSImage alloc] initWithData:tempdata] autorelease];
    return dragImage;
}

- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id <NSDraggingInfo>)draggingInfo proposedIndexPath:(NSIndexPath * __nonnull * __nonnull)proposedDropIndexPath dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation {
    NSPasteboard *pastboard = [draggingInfo draggingPasteboard];
    NSArray *fileTypeList = [pastboard propertyListForType:NSFilesPromisePboardType];
    if (fileTypeList == nil) {
        return NSDragOperationCopy;
    }else {
        return NSDragOperationNone;
    }
}

#pragma mark - action
//切换
- (void)doSwitchView:(id)sender {
    if ([_sortMenuView superview]) {
        [_sortMenuView removeFromSuperview];
        [_nc postNotificationName:DISABLE_ENTER_STATE object:[NSNumber numberWithBool:NO]];
    }else {
        _isSortMenuOpen = YES;
        IMBToolBarButton *switchButton = sender;
        NSPoint point = [self.view convertPoint:switchButton.curEventPoint fromView:nil];
        point = NSMakePoint(ceil(point.x), ceil(point.y));
        [_sortMenuView setFrameOrigin:NSMakePoint(point.x - _sortMenuView.frame.size.width + 8, point.y - _sortMenuView.frame.size.height - 12)];
        [_sortMenuView setWantsLayer:YES];
        [self.view addSubview:_sortMenuView];
        [_nc postNotificationName:DISABLE_ENTER_STATE object:[NSNumber numberWithBool:YES]];
    }
}

- (void)sortMenuItemClick:(id)sender {
    int itemTag = [(IMBSortItem *)sender itemTag];
    if (itemTag == 1) {//视图模式
        if (_curSelectView != 1) {
            if (_dataSourAryM.count > 0) {
                NSIndexSet *set = [self selectedItems];
                [_collectionView deselectAll:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [_contentBox setContentView:_collectionScrollView];
                    [_collectionView setSelectionIndexes:set];
                    _selectCount = (int)set.count;
                    if (set.count == _dataSourAryM.count) {
                        [_selectAllBtn setState:NSOnState];
                    }else if (set.count == 0) {
                        [_selectAllBtn setState:NSOffState];
                    }else {
                        [_selectAllBtn setState:NSMixedState];
                    }
                });
            } else {
                [_contentBox setContentView:_noDataView];
            }
            _curSelectView = 1;
        }
    } else if (itemTag == 2) {//列表模式
        if (_curSelectView != 0) {
            if (_dataSourAryM.count > 0) {
                NSIndexSet *set = [self selectedItems];
                for (IMBDriveModel *model in _dataSourAryM) {
                    [model setCheckState:NSOffState];
                }
                [_contentBox setContentView:_tableBgView];
                [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                    IMBDriveModel *model = [_dataSourAryM objectAtIndex:idx];
                    [model setCheckState:NSOnState];
                }];
                _selectCount = (int)set.count;
                [_itemTableView reloadData];
                if (set.count == _dataSourAryM.count) {
                    [_selectAllBtn setState:NSOnState];
                }else if (set.count == 0) {
                    [_selectAllBtn setState:NSOffState];
                }else {
                    [_selectAllBtn setState:NSMixedState];
                }
            } else {
                [_contentBox setContentView:_noDataView];
            }
            _curSelectView = 0;
        }
    } else {
        NSString *key = nil;
        if (itemTag == 3) {//时间排序
            key = @"lastModifiedDateString";
        } else if (itemTag == 4) {//名称排序
            key = @"fileName";
        } else if (itemTag == 5) {//大小排序
            key = @"fileSize";
        }
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [_dataSourAryM sortUsingDescriptors:sortDescriptors];
        [_collectionView reloadData];
        [_itemTableView reloadData];
        [sortDescriptor release];
    }
    [self removeSortMenuViewAnimation];
    [(IMBSortItem *)sender setItemTag:itemTag];
    [sender setNeedsDisplay:YES];
}

- (void)removeSortMenuView:(NSNotification *)notifi {
    NSEvent *theEvent = notifi.object;
    NSPoint point = [_sortMenuView convertPoint:theEvent.locationInWindow fromView:nil];
     IMBToolBarButton *switchBtn = [_toolbarView.subviews lastObject];
    BOOL inner = NSMouseInRect(point, [_sortMenuView bounds], [_sortMenuView isFlipped]);

    NSPoint point1 = [switchBtn convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner1 = NSMouseInRect(point1, [switchBtn bounds], [switchBtn isFlipped]);
    
    if (_isSortMenuOpen) {
        if (!inner && !inner1) {
            [self removeSortMenuViewAnimation];
        }
    }
}

- (void)removeSortMenuViewAnimation {
    _isSortMenuOpen = NO;
    [_sortMenuView removeFromSuperview];
    [_nc postNotificationName:DISABLE_ENTER_STATE object:[NSNumber numberWithBool:NO]];
}
//全选
- (IBAction)doSelectAll:(id)sender {
    IMBCheckButton *selectBtn = sender;
    if (_curSelectView == 0) {
        if (selectBtn.state == NSOnState || selectBtn.state == NSMixedState) {
            _itemTableViewcanDrag = YES;
            _itemTableView.selectedCount = (int)_dataSourAryM.count;
        } else {
            _itemTableViewcanDrag = NO;
            _itemTableView.selectedCount = 0;
        }
        
        if (selectBtn.state == NSOnState || selectBtn.state == NSMixedState) {
            for (IMBDriveModel *model in _dataSourAryM) {
                [model setCheckState:NSOnState];
            }
            [_collectionView selectAll:nil];
            [_selectAllBtn setState:NSOnState];
            _selectCount = (int)_dataSourAryM.count;
        } else {
            for (IMBDriveModel *model in _dataSourAryM) {
                [model setCheckState:NSOffState];
            }
            [_collectionView deselectAll:nil];
            [_selectAllBtn setState:NSOffState];
            _selectCount = 0;
        }
        
        [_itemTableView reloadData];
    }else {
        if (selectBtn.state == NSOnState || selectBtn.state == NSMixedState) {
            [_collectionView selectAll:nil];
            [_selectAllBtn setState:NSOnState];
            _selectCount = (int)_dataSourAryM.count;
        } else {
            [_collectionView deselectAll:nil];
            [_selectAllBtn setState:NSOffState];
            _selectCount = 0;
        }
    }
}

//cell的checkButton
- (void)cellCheckButtonClick:(IMBCheckButton *)checkBtn withCellRow:(NSInteger)cellRow {
    IMBDriveModel *model = [_dataSourAryM objectAtIndex:cellRow];
    [self singleClickSelect:checkBtn.state DriveModel:model];
}

- (void)collectionViewDoubleClick:(IMBDriveModel *)model {
    if (model.isForbiddden) {
        return;
    }
    
    if (_isOpenMenu) {
        [self removeMoreMenuViewAnimation];
    }
    
    [_contentBox setContentView:_loadingBgView];
    [_loadingAnimationView startAnimation];
    _doubleclickCount ++;
    if (_doubleDriveModel) {
        [_doubleDriveModel release];
        _doubleDriveModel = nil;
    }
    _doubleDriveModel = [model retain];
    [self configSelectPathButtonWithButtonTag:_doubleclickCount WithButtonTitle:model.fileName];
    [_baseManager recursiveDirectoryContentsDics:model.itemIDOrPath];
    if ([_baseManager.baseDrive.driveType isEqualToString:DropboxCSEndPointURL]) {
        _currentDriveID = model.filePath;
    }else {
        _currentDriveID = model.itemIDOrPath;
    }
    [self setToolbarViewWithHasFolder:NO withHasFile:NO withIsMultiple:NO];
}

- (void)collectionViewRightMouseDownClick:(IMBDriveModel *)model {
    NSIndexSet *selectSet = [self selectedItems];
    NSUInteger selectIndex = [_dataSourAryM indexOfObject:model];
    if (![selectSet containsIndex:selectIndex]) {
        BOOL hasFloder = NO;
        BOOL hasFile = NO;
        BOOL isMultiple = NO;//多选的时候应该屏蔽重命名按钮
        if (model.isFolder) {
            hasFloder = YES;
        }else {
            hasFile = YES;
        }
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:selectIndex];
        if (set.count == _dataSourAryM.count) {
            _itemTableViewcanDrag = YES;
            [_selectAllBtn setState:NSOnState];
        }else if (set.count == 0) {
            _itemTableViewcanDrag = NO;
            [_selectAllBtn setState:NSOffState];
        }else {
            _itemTableViewcanDrag = YES;
            [_selectAllBtn setState:NSMixedState];
        }
        _itemTableView.selectedCount = (int)set.count;
        _selectCount = (int)set.count;
        [_collectionView setSelectionIndexes:set];
        
        if (_selectCount > 1) {
            isMultiple = YES;
        }
        [self setToolbarViewWithHasFolder:hasFloder withHasFile:hasFile withIsMultiple:isMultiple];
        
    }
}

- (void)singleClickSelect:(NSInteger)state DriveModel:(IMBDriveModel *)model {
    BOOL hasFloder = NO;
    BOOL hasFile = NO;
    BOOL isMultiple = NO;//多选的时候应该屏蔽重命名按钮
    if (state == NSOnState) {
        [model setCheckState:Check];
    } else {
        [model setCheckState:UnChecked];
    }
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (IMBDriveModel *allModel in _dataSourAryM) {
        if (allModel.checkState == Check) {
            if (allModel.isFolder) {
                hasFloder = YES;
            }else {
                hasFile = YES;
            }
            [set addIndex:[_dataSourAryM indexOfObject:allModel]];
        }
    }
    if (set.count == _dataSourAryM.count) {
        _itemTableViewcanDrag = YES;
        [_selectAllBtn setState:NSOnState];
    }else if (set.count == 0) {
        _itemTableViewcanDrag = NO;
        [_selectAllBtn setState:NSOffState];
    }else {
        _itemTableViewcanDrag = YES;
        [_selectAllBtn setState:NSMixedState];
    }
    _itemTableView.selectedCount = (int)set.count;
    
    _selectCount = (int)set.count;
    [_collectionView setSelectionIndexes:set];
    
    if (_selectCount > 1) {
        isMultiple = YES;
    }
    
    [self setToolbarViewWithHasFolder:hasFloder withHasFile:hasFile withIsMultiple:isMultiple];
}

#pragma mark - item操作:More
- (void)cellViewMoreBtn:(IMBDriveModel *)model withMoreBtn:(IMBToolBarButton *)moreBtn {
    if (!_isOpenMenu) {
        NSInteger index = [_dataSourAryM indexOfObject:model];
        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
        _itemModel = model;
        _isOpenMenu = YES;
        if (_openMenuCell) {
            [_openMenuCell release];
            _openMenuCell = nil;
        }
        _openMenuCell = [(IMBFileTableCellView *)moreBtn.superview.superview retain];
        [_openMenuCell setIsOpenMenu:YES];
        
        NSPoint point = [self.view convertPoint:moreBtn.curEventPoint fromView:nil];
        point = NSMakePoint(ceil(point.x), ceil(point.y));
        
        NSArray *menuArr = [NSArray arrayWithObjects:@(syncAction),@(moveAction),@(copyAction),@(renameAction),@(deleteAction),@(infoAction),nil];
        
        if (model.isFolder) {
            menuArr = [NSArray arrayWithObjects:@(downloadAction),@(moveAction),@(copyAction),@(renameAction),@(deleteAction),@(infoAction),nil];
        }
        
        int menuHeight = (int)menuArr.count * 39 + 24;
        _moreMenu = [[IMBMoreMenuView alloc] initWithFrame:NSMakeRect(point.x, point.y, 180, menuHeight)];
        
        for (int itemTag = 1; itemTag <= menuArr.count; itemTag++) {
            IMBCustomView *bgView = [[IMBCustomView alloc] initWithFrame:NSMakeRect(5, menuHeight - 12 - itemTag*39, 170, 39)];
            IMBMoreItem *item = [[IMBMoreItem alloc] initWithFrame:NSMakeRect(-3, 0, 173, 39)];
            [item setItemTag:itemTag];
            [item setActionType:[[menuArr objectAtIndex:itemTag - 1] intValue]];
            [item setTarget:self];
            [item setAction:@selector(menuItemClick:)];
            [bgView addSubview:item];
            [_moreMenu addSubview:bgView];
            [item release];
            item = nil;
            [bgView release];
            bgView = nil;
        }
        if (point.y - _moreMenu.frame.size.height > 0) {
            [_moreMenu setFrameOrigin:NSMakePoint(point.x, point.y - _moreMenu.frame.size.height)];
        }else {
            [_moreMenu setFrameOrigin:point];
        }

        [_moreMenu setWantsLayer:YES];
        
        CATransition *transition = [CATransition animation];
        transition.delegate = self;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromTop;
        transition.removedOnCompletion = NO;
        transition.fillMode = kCAFillModeForwards;
        [_moreMenu.layer addAnimation:transition forKey:@"animation"];
        [self.view addSubview:_moreMenu];
        [_nc postNotificationName:DISABLE_ENTER_STATE object:[NSNumber numberWithBool:YES]];
    }
}

- (void)itemMore:(IMBDriveModel *)model withBtn:(id)sender {
    if (!_isOpenMenu) {
        _itemModel = model;
        _isOpenMenu = YES;
        NSArray *disAry = nil;
        if (_isSearch) {
            disAry = _searchAryM;
        }else {
            disAry = _dataSourAryM;
        }
        
        int index = (int)[disAry indexOfObject:model];
        NSRect rect = [_collectionView frameForItemAtIndex:index];
        IMBToolBarButton *toolBtn = (IMBToolBarButton *)sender;
        _openMenuView = (CloudItemView *)toolBtn.superview.superview;
        [_openMenuView setIsOpenMenu:YES];
        NSPoint point = [self.view convertPoint:toolBtn.curEventPoint fromView:nil];
        point = NSMakePoint(ceil(point.x), ceil(point.y));
        
        NSArray *menuArr = [NSArray arrayWithObjects:@(syncAction),@(moveAction),@(copyAction),@(renameAction),@(deleteAction),@(infoAction),nil];
        
        if (model.isFolder) {
            menuArr = [NSArray arrayWithObjects:@(downloadAction),@(moveAction),@(copyAction),@(renameAction),@(deleteAction),@(infoAction),nil];
        }
        int menuHeight = (int)menuArr.count * 39 + 24;
        _moreMenu = [[IMBMoreMenuView alloc] initWithFrame:NSMakeRect(rect.origin.x + 166 - 18, point.y, 180, menuHeight)];
        
        for (int itemTag = 1; itemTag <= menuArr.count; itemTag++) {
            IMBCustomView *bgView = [[IMBCustomView alloc] initWithFrame:NSMakeRect(5, menuHeight - 12 - itemTag*39, 170, 39)];
            IMBMoreItem *item = [[IMBMoreItem alloc] initWithFrame:NSMakeRect(-3, 0, 173, 39)];
            [item setItemTag:itemTag];
            [item setActionType:[[menuArr objectAtIndex:itemTag - 1] intValue]];
            [item setTarget:self];
            [item setAction:@selector(menuItemClick:)];
            [bgView addSubview:item];
            [_moreMenu addSubview:bgView];
            [item release];
            item = nil;
            [bgView release];
            bgView = nil;
        }
        if (point.y - _moreMenu.frame.size.height > 0) {
            if (point.x + _openMenuView.frame.size.width > self.view.frame.size.width) {
                [_moreMenu setFrameOrigin:NSMakePoint(point.x - _openMenuView.frame.size.width, point.y - _moreMenu.frame.size.height)];
            }else {
                [_moreMenu setFrameOrigin:NSMakePoint(point.x, point.y - _moreMenu.frame.size.height)];
            }
        }else {
            if (point.x + _openMenuView.frame.size.width > self.view.frame.size.width) {
                [_moreMenu setFrameOrigin:NSMakePoint(point.x - _openMenuView.frame.size.width, point.y)];
            }else {
                [_moreMenu setFrameOrigin:point];
            }
        }

        [_moreMenu setWantsLayer:YES];
        
        CATransition *transition = [CATransition animation];
        transition.delegate = self;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromTop;
        transition.removedOnCompletion = NO;
        transition.fillMode = kCAFillModeForwards;
        [_moreMenu.layer addAnimation:transition forKey:@"animation"];
        [self.view addSubview:_moreMenu];
        [_nc postNotificationName:DISABLE_ENTER_STATE object:[NSNumber numberWithBool:YES]];
    }
}

- (void)menuItemClick:(id)sender {
    IMBMoreItem *moreItem = sender;
    ActionTypeEnum actionType = moreItem.actionType;
    if (actionType == downloadAction) {
        [self download:_itemModel];
    } else if (actionType == syncAction) {
//        [self sync:nil];
    } else if (actionType == copyAction) {
        [self copy:_itemModel];
    } else if (actionType == renameAction) {
        [self rename:_itemModel];
    } else if (actionType == moveAction) {
        [self move:_itemModel];
    } else if (actionType == deleteAction) {
        [self deleteFile:_itemModel];
    } else if (actionType == infoAction) {
        [self showDetailView:_itemModel];
    }
    [self removeMoreMenuViewAnimation];
}

- (void)changeCheckButtonState:(IMBDriveModel *)model {
    BOOL hasFloder = NO;
    BOOL hasFile = NO;
    BOOL isMultiple = NO;//多选的时候应该屏蔽重命名按钮
    NSIndexSet *set = [self selectedItems];
    for (int i=0;i<_dataSourAryM.count;i++) {
        IMBDriveModel *allModel =  [_dataSourAryM objectAtIndex:i];
        if ([set containsIndex:i]) {
            [allModel setCheckState:NSOnState];
            if (allModel.isFolder) {
                hasFloder = YES;
            }else {
                hasFile = YES;
            }
        }else {
            [allModel setCheckState:NSOffState];
        }
    }
    int checkCount = (int)set.count;
    
    if (checkCount > 1) {
        isMultiple = YES;
    }
    if (checkCount != _selectCount) {
        _selectCount = checkCount;
        if (checkCount == _dataSourAryM.count) {
            [_selectAllBtn setState:NSOnState];
        }else if (checkCount == 0) {
            [_selectAllBtn setState:NSOffState];
        }else {
            [_selectAllBtn setState:NSMixedState];
        }
    }
    
    if (_isShow) {
        NSIndexSet *set = [_collectionView selectionIndexes];
        if (set.count > 0) {
            _currentModel = [_dataSourAryM objectAtIndex:[set firstIndex]];
        } else {
            _currentModel = nil;
        }
        [self configDetailViewWith:_currentModel];
    }
    
    [self setToolbarViewWithHasFolder:hasFloder withHasFile:hasFile withIsMultiple:isMultiple];
}

- (void)cancelSelectState:(NSInteger)state {
    if (state == NSOnState || state == NSMixedState) {
        [_collectionView selectAll:nil];
        [_selectAllBtn setState:NSOnState];
        _selectCount = (int)_dataSourAryM.count;
    } else {
        [_collectionView deselectAll:nil];
        [_selectAllBtn setState:NSOffState];
        _selectCount = 0;
    }
}

- (void)setToolbarViewWithHasFolder:(BOOL)hasFolder withHasFile:(BOOL)hasFile withIsMultiple:(BOOL)isMultiple {
    [_toolBarArr removeAllObjects];
    
    if (hasFolder && !hasFile) {
        if (isMultiple) {
            [_toolBarArr addObjectsFromArray:@[@(refreshAction),@(downloadAction),@(shareAction),@(syncAction),@(moveAction),@(copyAction),@(starAction),@(deleteAction),@(infoAction),@(switchAction)]];
            
        } else {
            [_toolBarArr addObjectsFromArray:@[@(refreshAction),@(downloadAction),@(shareAction),@(syncAction),@(moveAction),@(copyAction),@(renameAction),@(starAction),@(deleteAction),@(infoAction),@(switchAction)]];
        }
        
    }else if (!hasFolder && hasFile) {
        if (isMultiple) {
            [_toolBarArr addObjectsFromArray:@[@(refreshAction),@(downloadAction),@(shareAction),@(syncAction),@(moveAction),@(copyAction),@(starAction),@(deleteAction),@(infoAction),@(switchAction)]];
            
        } else {
            [_toolBarArr addObjectsFromArray:@[@(refreshAction),@(downloadAction),@(shareAction),@(syncAction),@(moveAction),@(copyAction),@(renameAction),@(starAction),@(deleteAction),@(infoAction),@(switchAction)]];
        }
        
    }else if (hasFile && hasFolder) {
        [_toolBarArr addObjectsFromArray:@[@(refreshAction),@(downloadAction),@(syncAction),@(moveAction),@(copyAction),@(starAction),@(deleteAction),@(switchAction)]];
        
    }else {
        [_toolBarArr addObjectsFromArray:@[@(refreshAction),@(syncAction),@(createFolder),@(uploadAction),@(infoAction),@(switchAction)]];
    }
    [_toolbarView loadButtons:_toolBarArr Target:self DisplayMode:_curSelectView];
}

#pragma mark - 功能按钮
- (void)reload:(id)sender {
    [_contentBox setContentView:_loadingBgView];
    [_loadingAnimationView startAnimation];
    [_toolbarView toolBarButtonIsEnabled:NO];
    [super reload:sender];
}

- (void)createFolder:(id)sender {
    if (_curSelectView == 1) {
        [_contentBox setContentView:_collectionScrollView];
    }else {
        [_contentBox setContentView:_tableBgView];
    }
    [_toolbarView toolBarButtonIsEnabled:NO];
    [super createFolder:sender];
}
//展示详情
- (void)showDetailView:(id)sender {
    if (!_isShow) {
        _isShow = YES;
        
        NSIndexSet *set = [_collectionView selectionIndexes];
        if (set.count > 0) {
            _currentModel = [_dataSourAryM objectAtIndex:[set firstIndex]];
        } else {
            _currentModel = nil;
        }
        
        if ([sender isKindOfClass:[IMBDriveModel class]]) {
            _currentModel = sender;
        }
        
        [_rightContentView.layer removeAllAnimations];
        [_leftContentView.layer removeAllAnimations];
        
        if (_rightContentView.frame.origin.x != _bgView.frame.size.width) {
            [self configDetailViewWith:_currentModel];
        }else {
            [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
                NSRect rect= NSMakeRect(_bgView.frame.size.width - _rightContentView.frame.size.width, 0, _rightContentView.frame.size.width, self.view.frame.size.height);
                NSRect rect2 = NSMakeRect(0, 0, _bgView.frame.size.width - _rightContentView.frame.size.width , self.view.frame.size.height);
                [context setDuration:0.3];
                [[_rightContentView animator] setFrame:rect];
                [[_leftContentView animator] setFrame:rect2];
                
            } completionHandler:^{
                [self configDetailViewWith:_currentModel];
            }];
        }
    }
}

- (void)configDetailViewWith:(IMBDriveModel *)entity {
    [_detailLabel1 setHidden:NO];
    [_detailLabel2 setHidden:NO];
    [_detailLabel3 setHidden:NO];
    [_detailLabel4 setHidden:NO];
    [_detailLabel5 setHidden:NO];
    
    [_detailContent1 setHidden:NO];
    [_detailContent2 setHidden:NO];
    [_detailContent3 setHidden:NO];
    [_detailContent4 setHidden:NO];
    [_detailContent5 setHidden:NO];
    
    [_detailLabel1 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_detailLabel2 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_detailLabel3 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_detailLabel4 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_detailLabel5 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    [_detailContent1 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_detailContent2 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_detailContent3 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_detailContent4 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_detailContent5 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_detailTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    if (entity) {
        if (entity.image) {
            [_detailImageView setImage:entity.image];
        } else {
            [_detailImageView setImage:entity.iConimage];
        }
        [_detailTitle setStringValue:entity.fileName];
        
        if (entity.isFolder) {
            [_detailLabel1 setStringValue:CustomLocalizedString(@"detailView_id_4", nil)];
            [_detailLabel2 setStringValue:CustomLocalizedString(@"detailView_id_5", nil)];
            [_detailLabel3 setStringValue:CustomLocalizedString(@"detailView_id_6", nil)];
            [_detailLabel4 setStringValue:CustomLocalizedString(@"detailView_id_7", nil)];
            [_detailLabel5 setStringValue:CustomLocalizedString(@"detailView_id_8", nil)];
            
            if ([StringHelper stringIsNilOrEmpty:entity.filePath]) {
                [_detailContent1 setStringValue:@"--"];
            } else {
                [_detailContent1 setStringValue:entity.filePath];
            }
            [_detailContent2 setStringValue:@"还未取到值"];
            if (entity.fileSize == 0) {
                [_detailContent3 setStringValue:@"--"];
            }else {
                [_detailContent3 setStringValue:[StringHelper getFileSizeString:entity.fileSize reserved:2]];
            }
            if ([StringHelper stringIsNilOrEmpty:entity.createdDateString]) {
                [_detailContent4 setStringValue:@"--"];
            } else {
                [_detailContent4 setStringValue:entity.createdDateString];
            }
            if ([StringHelper stringIsNilOrEmpty:entity.lastModifiedDateString]) {
                [_detailContent5 setStringValue:@"--"];
            } else {
                [_detailContent5 setStringValue:entity.lastModifiedDateString];
            }
            
        } else {
            [_detailLabel1 setStringValue:CustomLocalizedString(@"detailView_id_4", nil)];
            [_detailLabel2 setStringValue:CustomLocalizedString(@"detailView_id_6", nil)];
            [_detailLabel3 setStringValue:CustomLocalizedString(@"detailView_id_7", nil)];
            [_detailLabel4 setStringValue:CustomLocalizedString(@"detailView_id_8", nil)];
            [_detailLabel5 setHidden:YES];
            
            if ([StringHelper stringIsNilOrEmpty:entity.filePath]) {
                [_detailContent1 setStringValue:@"--"];
            } else {
                [_detailContent1 setStringValue:entity.filePath];
            }
            if (entity.fileSize == 0) {
                [_detailContent2 setStringValue:@"--"];
            }else {
                [_detailContent2 setStringValue:[StringHelper getFileSizeString:entity.fileSize reserved:2]];
            }
            if ([StringHelper stringIsNilOrEmpty:entity.createdDateString]) {
                [_detailContent3 setStringValue:@"--"];
            } else {
                [_detailContent3 setStringValue:entity.createdDateString];
            }
            if ([StringHelper stringIsNilOrEmpty:entity.lastModifiedDateString]) {
                [_detailContent4 setStringValue:@"--"];
            } else {
                [_detailContent4 setStringValue:entity.lastModifiedDateString];
            }
            [_detailContent5 setHidden:YES];
        }
    } else {
        [_detailLabel1 setStringValue:CustomLocalizedString(@"detailView_id_1", nil)];
        [_detailLabel2 setStringValue:CustomLocalizedString(@"detailView_id_2", nil)];
        [_detailLabel3 setStringValue:CustomLocalizedString(@"detailView_id_3", nil)];
        [_detailLabel4 setHidden:YES];
        [_detailLabel5 setHidden:YES];
        
        NSString *allSize = _baseManager.baseDrive.driveTotalCapacity;
        NSString *aviableSize = _baseManager.baseDrive.driveUsedCapacity;
        NSString *driveEmail = _baseManager.baseDrive.driveEmail;
        if ([StringHelper stringIsNilOrEmpty:allSize]) {
            [_detailContent1 setStringValue:@"--"];
        } else {
            [_detailContent1 setStringValue:allSize];
        }
        if ([StringHelper stringIsNilOrEmpty:aviableSize]) {
            [_detailContent2 setStringValue:@"--"];
        } else {
            [_detailContent2 setStringValue:aviableSize];
        }
        if ([StringHelper stringIsNilOrEmpty:driveEmail]) {
            [_detailContent3 setStringValue:@"--"];
        } else {
            [_detailContent3 setStringValue:driveEmail];
        }
        [_detailContent4 setHidden:YES];
        [_detailContent5 setHidden:YES];
        
        IMBCloudEntity *cloudEntity = [[IMBCloudEntity alloc] init];
        [TempHelper setDriveDefultImage:_baseManager.baseDrive CloudEntity:cloudEntity];
        [_detailImageView setImage:cloudEntity.image];
        [_detailTitle setStringValue:cloudEntity.name];
        [cloudEntity release];
        cloudEntity = nil;
    }
    //根据文字长度计算位置
    NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
    NSRect labelRect1 = [StringHelper calcuTextBounds:_detailLabel1.stringValue font:font];
    NSRect labelRect2 = [StringHelper calcuTextBounds:_detailLabel2.stringValue font:font];
    NSRect labelRect3 = [StringHelper calcuTextBounds:_detailLabel3.stringValue font:font];
    NSRect labelRect4 = [StringHelper calcuTextBounds:_detailLabel4.stringValue font:font];
    NSRect labelRect5 = [StringHelper calcuTextBounds:_detailLabel5.stringValue font:font];
    
    [_detailContent1 setFrame:NSMakeRect(_detailLabel1.frame.origin.x + labelRect1.size.width + 5, _detailContent1.frame.origin.y, 209 - labelRect1.size.width - 5, _detailContent1.frame.size.height)];
    [_detailContent2 setFrame:NSMakeRect(_detailLabel2.frame.origin.x + labelRect2.size.width + 5, _detailContent2.frame.origin.y, 209 - labelRect2.size.width - 5, _detailContent2.frame.size.height)];
    [_detailContent3 setFrame:NSMakeRect(_detailLabel3.frame.origin.x + labelRect3.size.width + 5, _detailContent3.frame.origin.y, 209 - labelRect3.size.width - 5, _detailContent3.frame.size.height)];
    [_detailContent4 setFrame:NSMakeRect(_detailLabel4.frame.origin.x + labelRect4.size.width + 5, _detailContent4.frame.origin.y, 209 - labelRect4.size.width - 5, _detailContent4.frame.size.height)];
    [_detailContent5 setFrame:NSMakeRect(_detailLabel5.frame.origin.x + labelRect5.size.width + 5, _detailContent5.frame.origin.y, 209 - labelRect5.size.width - 5, _detailContent5.frame.size.height)];
    
}

- (IBAction)hideFileDetailView:(id)sender {
    if (_isShow) {
        [_rightContentView.layer removeAllAnimations];
        [_leftContentView.layer removeAllAnimations];
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            NSRect rect = NSMakeRect(_bgView.frame.size.width, 0, _rightContentView.frame.size.width,self.view.frame.size.height);
            NSRect rect2 = NSMakeRect(0, 0, _bgView.frame.size.width, self.view.frame.size.height);
            [context setDuration:0.3];
            [[_rightContentView animator] setFrame:rect];
            [[_leftContentView animator] setFrame:rect2];
        } completionHandler:^{
            _isShow = NO;
        }];
    }
}
//鼠标移动
- (void)itemViewMouseMove:(NSNotification *)notifi {
    NSEvent *theEvent = notifi.object;
    NSPoint point = [_openMenuView convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [_openMenuView bounds], [_openMenuView isFlipped]);
    if (_curSelectView == 0) {
        point = [_openMenuCell convertPoint:theEvent.locationInWindow fromView:nil];
        inner = NSMouseInRect(point, [_openMenuCell bounds], [_openMenuCell isFlipped]);
    }
    
    NSPoint point1 = [_moreMenu convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner1 = NSMouseInRect(point1, [_moreMenu bounds], [_moreMenu isFlipped]);
    
    if (!inner && !inner1 && _isOpenMenu) {
        [self removeMoreMenuViewAnimation];
    }
}

- (void)globalMouseScrollWhell:(NSNotification *)notifi {
    if (_isOpenMenu) {
        [self removeMoreMenuViewAnimation];
    }
    if (_isRightKeyMenuOpen) {
        [self removeRightKeyMenuViewAnimation];
    }
}

- (void)removeMoreMenuViewAnimation {
    _itemModel = nil;
    [_openMenuView setIsOpenMenu:NO];
    [_openMenuCell setIsOpenMenu:NO];
    _isOpenMenu = NO;
    [_moreMenu removeFromSuperview];
    [_nc postNotificationName:DISABLE_ENTER_STATE object:[NSNumber numberWithBool:NO]];
    if (_moreMenu) {
        [_moreMenu release];
        _moreMenu = nil;
    }
}

- (void)saveName:(NSNotification *)notification {
    NSEvent *envent = notification.object;
    NSPoint point = envent.locationInWindow;
    if (_isRenameing) {
        if (_curSelectView == 0) {
            point = [_selectedCell convertPoint:envent.locationInWindow fromView:nil];
            if (!NSMouseInRect(point, [_selectedCell.fileName frame], [_selectedCell isFlipped])) {
                [self execRename:_selectedCell.fileName];
            }
        } else {
            if (!NSMouseInRect(point, NSMakeRect(_renameItemView.frame.origin.x + 74, _collectionScrollView.frame.size.height - _renameItemView.frame.origin.y - _renameItemView.frame.size.height + _renameItemView.textFiled.frame.origin.y, _renameItemView.textFiled.frame.size.width, _renameItemView.textFiled.frame.size.height), [_renameItemView isFlipped])) {
                [_renameItemView setIsRename:NO];
                [self execRename:_renameItemView.textFiled];
            }
        }
    } else if (_isCreateFolder) {
        if (_curSelectView == 0) {
            point = [_selectedCell convertPoint:envent.locationInWindow fromView:nil];
            if (!NSMouseInRect(point, [_selectedCell.fileName frame], [_selectedCell isFlipped])) {
                [self execCreateFolder:_selectedCell.fileName];
            }
        } else {
            if (!NSMouseInRect(point, NSMakeRect(_newDriveItemView.frame.origin.x + 74, _collectionScrollView.frame.size.height - _newDriveItemView.frame.origin.y - _newDriveItemView.frame.size.height + _newDriveItemView.textFiled.frame.origin.y, _newDriveItemView.textFiled.frame.size.width, _newDriveItemView.textFiled.frame.size.height), [_newDriveItemView isFlipped])) {
                [_newDriveItemView setIsRename:NO];
                [self execCreateFolder:_newDriveItemView.textFiled];
            }
        }
    }
}

- (void)saveEditName:(NSNotification *)notification {
    if (_isRenameing) {
        if (_curSelectView == 0) {
            [self execRename:_selectedCell.fileName];
        } else {
            [_renameItemView setIsRename:NO];
            [self execRename:_renameItemView.textFiled];
        }
    } else if (_isCreateFolder) {
        if (_curSelectView == 0) {
            [self execCreateFolder:_selectedCell.fileName];
        } else {
            [_newDriveItemView setIsRename:NO];
            [self execCreateFolder:_newDriveItemView.textFiled];
        }
    }
}

//执行重命名操作
- (void)execRename:(NSTextField *)textFiled {
    [textFiled setEditable:NO];
    [textFiled setSelectable:NO];
    _isRenameing = NO;
    NSString *str = nil;
    if ([StringHelper stringIsNilOrEmpty:textFiled.stringValue]) {
        [textFiled setStringValue:_renameDriveModel.fileName];
        return;
    }else {
        str = textFiled.stringValue;
    }
    
    if ([str isEqualToString:_renameDriveModel.fileName]) {
        [_toolbarView toolBarButtonIsEnabled:YES];
        return;
    }
    
    BOOL ret = [TempHelper filePathExists:_dataSourAryM FileName:str Index:0 WithIsFolder:_renameDriveModel.isFolder];
    if (ret) {
        NSString *alertText = [NSString stringWithFormat:CustomLocalizedString(@"CWTip_Rename_NameRepeat", nil),str];
        [self showAlertText:alertText OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        [textFiled setStringValue:_renameDriveModel.fileName];
        [_toolbarView toolBarButtonIsEnabled:YES];
        return;
    }else {
        [self saveRenameModel:_renameDriveModel withStr:str];
    }
}

//执行创建文件夹操作
- (void)execCreateFolder:(NSTextField *)textFiled {
    [textFiled setEditable:NO];
    [textFiled setSelectable:NO];
    _isCreateFolder = NO;
    NSString *str = nil;
    if ([StringHelper stringIsNilOrEmpty:textFiled.stringValue]) {
        str = _newDriveModel.fileName;
        [textFiled setStringValue:str];
    }else {
        str = textFiled.stringValue;
    }
    BOOL ret = [TempHelper filePathExists:_dataSourAryM FileName:str Index:1 WithIsFolder:YES];
    if (ret) {
        NSString *newName = [TempHelper getFilePathAlias:str withary:_dataSourAryM WithIsFolder:YES];
        NSString *alertText = [NSString stringWithFormat:CustomLocalizedString(@"CWTip_RenameFolder", nil),newName];
        int result = [self showAlertText:alertText withCancelButton:CustomLocalizedString(@"Button_No", nil) withOKButton:CustomLocalizedString(@"Button_Ok", nil)];
        if (result) {
            [self createFolderIsOk:newName];
        } else {
            [self createFolderIsOkCancel];
        }
        
    }else {
        [_baseManager createFolder:str parent:_currentDriveID withEntity:_newDriveModel];
    }
}

- (void)createFolderIsOk:(NSString *)newName {
    if (_curSelectView == 0) {
        [_selectedCell.fileName setStringValue:newName];
    }else {
        [_cloudItemView.textFiled setStringValue:newName];
    }
    [_baseManager createFolder:newName parent:_currentDriveID withEntity:_newDriveModel];
}

- (void)createFolderIsOkCancel {
    [_toolbarView toolBarButtonIsEnabled:YES];
    [_dataSourAryM removeObject:_newDriveModel];
    [_collectionView reloadData];
    [_itemTableView reloadData];
}

- (void)reNameIsOk:(NSString *)newName {
    
}

- (void)reNameIsOkCancel {
    
}

//加载浮起 提示窗口
- (void)addTipPromptCustomView:(IMBPromptView *)prompt withIsDeleteView:(BOOL)isdelete {
    [prompt setFrameOrigin:NSMakePoint(-400,-300)];
    NSRect startFrame = NSZeroRect;
    NSRect endFrame = NSZeroRect;
    if (_curSelectView == 0) {
        startFrame = NSMakeRect((_contentBox.frame.size.width - prompt.frame.size.width)/2,-prompt.frame.size.height, prompt.frame.size.width, prompt.frame.size.height);
        endFrame = NSMakeRect((_contentBox.frame.size.width - prompt.frame.size.width)/2, 40, prompt.frame.size.width, prompt.frame.size.height);
    } else {
        startFrame = NSMakeRect((_contentBox.frame.size.width - prompt.frame.size.width)/2,_contentBox.frame.size.height, prompt.frame.size.width, prompt.frame.size.height);
        endFrame = NSMakeRect((_contentBox.frame.size.width - prompt.frame.size.width)/2, _contentBox.frame.size.height - prompt.frame.size.height - 40, prompt.frame.size.width, prompt.frame.size.height);
    }
    [self addPromptCustomView:prompt WithEndFrame:endFrame WithStartFrame:startFrame];
    if (!isdelete) {
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [prompt setFrameOrigin:NSMakePoint(ceil((prompt.frame.size.width - 20 - 4 )/2.0), (prompt.frame.size.height - 20)/2)];
            NSRect startFrame = NSZeroRect;
            NSRect endFrame = NSZeroRect;
            if (_curSelectView == 0) {
                startFrame = NSMakeRect((_contentBox.frame.size.width - prompt.frame.size.width)/2,-prompt.frame.size.height, prompt.frame.size.width, prompt.frame.size.height);
                endFrame = NSMakeRect((_contentBox.frame.size.width - prompt.frame.size.width)/2, 40, prompt.frame.size.width, prompt.frame.size.height);
            } else {
                startFrame = NSMakeRect((_contentBox.frame.size.width - prompt.frame.size.width)/2,_contentBox.frame.size.height, prompt.frame.size.width, prompt.frame.size.height);
                endFrame = NSMakeRect((_contentBox.frame.size.width - prompt.frame.size.width)/2, _contentBox.frame.size.height - prompt.frame.size.height - 40, prompt.frame.size.width, prompt.frame.size.height);
            }
            NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:prompt,NSViewAnimationTargetKey,NSViewAnimationFadeInEffect,NSViewAnimationEffectKey,[NSValue valueWithRect:endFrame],NSViewAnimationStartFrameKey,[NSValue valueWithRect:startFrame],NSViewAnimationEndFrameKey,nil];
            NSViewAnimation *ani1 = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObject:dic1]];
            ani1.duration = 0.5;
            [ani1 setAnimationBlockingMode:NSAnimationNonblocking];
            [ani1 startAnimation];
            [_contentBox addSubview:prompt];
            [dic1 release];
            [ani1 release];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [prompt removeFromSuperview];
            });
        });
    }
}

//浮起提示窗口 向上移动
- (void)addPromptCustomView:(IMBPromptView *)promptView WithEndFrame:(NSRect) endFrame WithStartFrame:(NSRect) startFrame {
    [promptView setHidden:NO];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:promptView,NSViewAnimationTargetKey,NSViewAnimationFadeInEffect,NSViewAnimationEffectKey,[NSValue valueWithRect:startFrame],NSViewAnimationStartFrameKey,[NSValue valueWithRect:endFrame],NSViewAnimationEndFrameKey,nil];
    NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObject:dictionary]];
    
    animation.duration = 0.5;
    [animation setAnimationBlockingMode:NSAnimationNonblocking];
    [animation startAnimation];
    
    [_contentBox addSubview:promptView];
    [dictionary release];
    [animation release];
}

//浮起提示窗口 向下移动
- (void)removePromptView:(IMBPromptView *)promptView {
    [promptView setFrameOrigin:NSMakePoint(- 200, -100)];
    NSRect startFrame = NSZeroRect;
    NSRect endFrame = NSZeroRect;
    if (_curSelectView == 0) {
        startFrame = NSMakeRect((_contentBox.frame.size.width - promptView.frame.size.width)/2,-promptView.frame.size.height, promptView.frame.size.width, promptView.frame.size.height);
        endFrame = NSMakeRect((_contentBox.frame.size.width - promptView.frame.size.width)/2, 40, promptView.frame.size.width, promptView.frame.size.height);
    } else {
        startFrame = NSMakeRect((_contentBox.frame.size.width - promptView.frame.size.width)/2,_contentBox.frame.size.height, promptView.frame.size.width, promptView.frame.size.height);
        endFrame = NSMakeRect((_contentBox.frame.size.width - promptView.frame.size.width)/2, _contentBox.frame.size.height - promptView.frame.size.height - 40, promptView.frame.size.width, promptView.frame.size.height);
    }
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:promptView,NSViewAnimationTargetKey,NSViewAnimationFadeInEffect,NSViewAnimationEffectKey,[NSValue valueWithRect:endFrame],NSViewAnimationStartFrameKey,[NSValue valueWithRect:startFrame],NSViewAnimationEndFrameKey,nil];
    NSViewAnimation *ani1 = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObject:dic1]];
    ani1.duration = 0.5;
    [ani1 setAnimationBlockingMode:NSAnimationNonblocking];
    [ani1 startAnimation];
    [_contentBox addSubview:promptView];
    [dic1 release];
    [ani1 release];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [promptView removeFromSuperview];
    });
}

- (void)rightMouseUp:(NSEvent *)theEvent {
    NSPoint point = [self.view convertPoint:theEvent.locationInWindow fromView:nil];
    
    int menuHeight = (int)(_toolBarArr.count - 1) * 39 + 24;

    point.x += self.view.window.frame.origin.x + self.view.frame.origin.x + 73;
    point.y += self.view.window.frame.origin.y + self.view.frame.origin.y - menuHeight;
    NSRect menuRect = NSMakeRect(point.x, point.y, 180, menuHeight);
    [self showRightKeyMenuWithBtnArr:_toolBarArr withMenuFrame:menuRect];
    
}

- (void)showRightKeyMenuWithBtnArr:(NSArray *)btnArr withMenuFrame:(NSRect)menuFrame {
    if (_rightKeyMenu) {
        [_rightKeyMenu.window close];
        [_rightKeyMenu release];
        _rightKeyMenu = nil;
    }
    _rightKeyMenu = [[IMBRightKeyMenu alloc] initWithDelegate:self withBtnArray:btnArr];
    _isRightKeyMenuOpen = YES;
    _rightKeyMenu.window.viewsNeedDisplay = YES;
    [_rightKeyMenu.window orderOut:nil];
    [_rightKeyMenu.window setFrame:menuFrame display:YES];
    [_rightKeyMenu.window setMaxSize:menuFrame.size];
    [_rightKeyMenu.window setMinSize:menuFrame.size];
    [_rightKeyMenu.window makeKeyAndOrderFront:nil];
    [_rightKeyMenu showWindow:self];
}

- (void)rightKeyMenuClick:(id)sender {
    IMBMoreItem *moreItem = sender;
    ActionTypeEnum actionType = moreItem.actionType;
    if (actionType == downloadAction) {
        [self download:sender];
        
    } else if (actionType == syncAction) {
        [self sync:sender];
        
    } else if (actionType == copyAction) {
        [self copy:sender];
        
    } else if (actionType == renameAction) {
        [self rename:sender];
        
    } else if (actionType == moveAction) {
        [self move:sender];
        
    } else if (actionType == deleteAction) {
        [self deleteFile:sender];
        
    } else if (actionType == infoAction) {
        [self showDetailView:sender];
        
    } else if (actionType == shareAction) {
        [self share:sender];
        
    } else if (actionType == starAction) {
        [self star:sender];
        
    } else if (actionType == refreshAction) {
        [self reload:sender];
        
    } else if (actionType == createFolder) {
        [self createFolder:sender];
        
    } else if (actionType == uploadAction) {
        [self upload:sender];
        
    }
    [self removeRightKeyMenuViewAnimation];
}

- (void)removeRightKeyMenuView:(NSNotification *)notifi {
    NSEvent *theEvent = notifi.object;
    NSPoint point = [self.view convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [_rightKeyMenu.window.contentView bounds], [_rightKeyMenu.window.contentView isFlipped]);
    
    if (_isRightKeyMenuOpen) {
        if (!inner) {
            [self removeRightKeyMenuViewAnimation];
        }
    }
}

- (void)removeRightKeyMenuViewAnimation {
    _isRightKeyMenuOpen = NO;
    [_rightKeyMenu.window close];
    if (_rightKeyMenu) {
        [_rightKeyMenu release];
        _rightKeyMenu = nil;
    }
}

#pragma mark - 搜索的回调方法
- (void)searchName:(NSString*)name WithCloudDriveID:(NSString *)driveID WithFileType:(FileTypeEnum)fileTypeEnum WithDate:(DateTypeEnum)dateTypeEnum {
    [_searchManager searchName:name WithCloudDriveID:driveID WithFileType:fileTypeEnum WithDate:dateTypeEnum];
}

- (void)searchDataComplete:(NSMutableArray *)searchAry {
    [_toolbarView toolBarButtonIsEnabled:YES];
    [self changeContentViewWithDataArr:searchAry];
    
//    [_tempDic setObject:ary forKey:[NSNumber numberWithInt:_doubleclickCount]];
    [_oldDocwsidDic setObject:_currentDriveID forKey:[NSNumber numberWithInt:_doubleclickCount]];
    [_oldFileidDic setObject:_currentGetListPath forKey:[NSNumber numberWithInt:_doubleclickCount]];
//    if (_doubleDriveModel) {
//        [_oldPathTextDic setObject:_doubleDriveModel forKey:[NSNumber numberWithInt:_doubleclickCount]];
//    } else if (_doubleclickCount == 1 && !_isFristEnter) {
//        _isFristEnter  = YES;
//        [self configSelectPathButtonWithButtonTag:1 WithButtonTitle:_baseManager.baseDrive.displayName];
//    }
    
    _currentModel = nil;
    
    [_collectionView reloadData];
    [_itemTableView reloadData];
    //判读数据是否为空 切换界面
    if (_dataSourAryM.count <= 0) {
        [_contentBox setContentView:_noDataView];
    }
}

- (void)searchDataFail {
    //TODO: HUYUMIN 添加搜索失败页面
    [_toolbarView toolBarButtonIsEnabled:YES];
    [_collectionView reloadData];
    [_itemTableView reloadData];
    
}

- (void)dealloc {
    [_nc removeObserver:self];
    if (_oldWidthDic != nil) {
        [_oldWidthDic release];
        _oldWidthDic = nil;
    }
    if (_tempDic != nil) {
        [_tempDic release];
        _tempDic = nil;
    }
    if (_oldDocwsidDic != nil) {
        [_oldDocwsidDic release];
        _oldDocwsidDic = nil;
    }
    if (_oldFileidDic) {
        [_oldFileidDic release];
        _oldFileidDic = nil;
    }
    if (_allPathBtnDic) {
        [_allPathBtnDic release];
        _allPathBtnDic = nil;
    }
    if (_dataSourAryM) {
        [_dataSourAryM release];
        _dataSourAryM = nil;
    }
    if (_pathMenu) {
        [_pathMenu release];
        _pathMenu = nil;
    }
    if (_sortMenuView) {
        [_sortMenuView release];
        _sortMenuView = nil;
    }
    if (_doubleDriveModel) {
        [_doubleDriveModel release];
        _doubleDriveModel = nil;
    }
    if (_openMenuCell) {
        [_openMenuCell release];
        _openMenuCell = nil;
    }
    if (_moreMenu) {
        [_moreMenu release];
        _moreMenu = nil;
    }
    if (_toolBarArr) {
        [_toolBarArr release];
        _toolBarArr = nil;
    }
    [super dealloc];
}

@end
