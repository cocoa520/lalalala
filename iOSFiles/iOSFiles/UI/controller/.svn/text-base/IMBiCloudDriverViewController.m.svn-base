//
//  IMBiCloudDriverViewController.m
//  iOSFiles
//
//  Created by smz on 18/3/14.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBiCloudDriverViewController.h"
#import "CNGridViewItemLayout.h"
#import "IMBDriveEntity.h"
#import "IMBCommonDefine.h"
#import "IMBImageAndTextFieldCell.h"
#import "IMBSegmentedBtn.h"
#import "IMBiCloudPathSelectBtn.h"
#import "IMBTagImageView.h"
#import "TempHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface IMBiCloudDriverViewController ()

@end

@implementation IMBiCloudDriverViewController

- (id)initWithDrivemanage:(IMBDriveBaseManage *)driveManage withDelegete:(id)delegete {
    if (self = [super initWithNibName:@"IMBiCloudDriverViewController" bundle:nil]) {
        _dataSourceArray = [driveManage.driveDataAry retain];
        _tempDic  = [[NSMutableDictionary alloc] init];
        [_tempDic setObject:_dataSourceArray forKey:@"1"];
        _driveBaseManage = [driveManage retain];
        _delegate = delegete;
        [_driveBaseManage setDriveWindowDelegate:self];
    }
    return self;
}

- (void)dealloc {
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    if (_driveBaseManage != nil) {
        [_driveBaseManage release];
        _driveBaseManage = nil;
    }
    if (_oldWidthDic != nil) {
        [_oldWidthDic release];
        _oldWidthDic = nil;
    }
    if (_tempDic != nil) {
        [_tempDic release];
        _tempDic = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_HIDE_ICLOUDDETAIL object:nil];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configNoDataView];
    
    [_toolBarButtonView loadButtons:[NSArray arrayWithObjects:@(0),@(17),@(1),@(2),@(4),@(5),@(12),nil] Target:self DisplayMode:YES];
    
    [_leftContentView setFrame:NSMakeRect(0, 0, 1096, 548)];
    [_rightContentView setFrame:NSMakeRect(1096, 0, 282, 548)];
    
    _oldWidthDic = [[NSMutableDictionary alloc] init];
    [self configSelectPathButtonWithButtonTag:1 WithButtonTitle:CustomLocalizedString(@"iCloudWindow_clickButton", nil)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideFileDetailView:) name:NOTIFY_HIDE_ICLOUDDETAIL object:nil];
    
    _doubleclickCount = 1;
    _currentDevicePath = @"0";
    [_topLineView setBackgroundColor:COLOR_TEXT_LINE];
    [_gridView setWantsLayer:YES];
    [_gridView.layer setBackgroundColor:[NSColor whiteColor].CGColor];
    _gridView.itemSize = NSMakeSize(154, 150);
    _gridView.backgroundColor = [NSColor whiteColor];
    _gridView.scrollElasticity = NO;
    _gridView.allowsDragAndDrop = YES;
    _gridView.allowsMultipleSelection = YES;
    _gridView.allowsMultipleSelectionWithDrag = YES;
    
    [_gridView setIsFileManager:YES];
    [_gridView reloadData];
    [_itemTableView reloadData];
    _currentSelectView = 1;
    if (_dataSourceArray.count > 0 && _dataSourceArray != nil) {
        [_contentBox setContentView:_gridBgView];
    } else {
        [_contentBox setContentView:_nodataView];
    }
    
}

- (void)configNoDataView {
    [_nodataImageView setImage:[StringHelper imageNamed:@"nodata_myfiles"]];

    NSString *promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_String", nil),CustomLocalizedString(@"iCloud_content_view_file", nil)];
    NSMutableAttributedString *promptAs = [TempHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:COLOR_TEXT_EXPLAIN];
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [_nodataTextView setEditable:NO];
    [_nodataTextView setSelectable:NO];
    [[_nodataTextView textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
}

#pragma mark - path button config
- (void)configSelectPathButtonWithButtonTag:(int)buttonTag WithButtonTitle:(NSString *)buttonTitle {
    NSRect textRect = [StringHelper calcuTextBounds:buttonTitle fontSize:12.0];
    int width = textRect.size.width + 16 + 5 + 8 + 5;
    [_oldWidthDic setObject:[NSString stringWithFormat:@"%d",width] forKey:[NSString stringWithFormat:@"%d",buttonTag]];
    int height = textRect.size.height + 4;
    int oldWidth = 0;
    for (int i = 1; i <= buttonTag; i++) {
        if ([_oldWidthDic.allKeys containsObject:[NSString stringWithFormat:@"%d",i - 1]]) {
            oldWidth += [[_oldWidthDic objectForKey:[NSString stringWithFormat:@"%d",i - 1]] intValue];
        }
    }
    IMBiCloudPathSelectBtn *button = [[IMBiCloudPathSelectBtn alloc] initWithFrame:NSMakeRect(38 + (buttonTag - 1)*10 + oldWidth, (_topView.frame.size.height - height)/2 - 2, width, height)];
    if (buttonTag == 1) {
        [button setButtonTitle:buttonTitle WithIsHomePage:YES];
    } else {
        [button setButtonTitle:buttonTitle WithIsHomePage:NO];
    }
    [button setTag:buttonTag];
    [button setTarget:self];
    [button setAction:@selector(iCloudButtonClick:)];
    [_topView addSubview:button];
    
    IMBTagImageView *arrowImageView = [[IMBTagImageView alloc] initWithFrame:NSMakeRect(button.frame.origin.x + button.frame.size.width, (_topView.frame.size.height - 9)/2.0 - 3, 10, 9)];
    [arrowImageView setImage:[NSImage imageNamed:@"addcontent_arrowright1"]];
    [arrowImageView setViewTag:buttonTag];
    [_topView addSubview:arrowImageView];
    [button release];
    button = nil;
    [arrowImageView release];
    arrowImageView = nil;
}

- (void)iCloudButtonClick:(id)sender {
    int tag = (int)((IMBiCloudPathSelectBtn *)sender).tag;
    int viewCount = (int)[_topView subviews].count;
    for (int i = viewCount - 1; i > 0; i--) {
        NSView *subView = [[_topView subviews] objectAtIndex:i];
        if ([subView isKindOfClass:[NSClassFromString(@"IMBiCloudPathSelectBtn") class]]) {
            if (subView.tag > tag) {
                [subView removeFromSuperview];
            }
        }
        if ([subView isKindOfClass:[NSClassFromString(@"IMBTagImageView") class]]) {
            if (((IMBTagImageView *)subView).viewTag > tag) {
                [subView removeFromSuperview];
            }
        }
        [_topView setNeedsDisplay:YES];
    }
    
    for (int i = 1; i <= _doubleclickCount; i++) {
        if (tag == i) {
            [self changeContentViewWithDataArr:[_tempDic objectForKey:[NSString stringWithFormat:@"%d",i]]];
            for (int j = i + 1; j <= _doubleclickCount; j++) {
                if ([_tempDic.allKeys containsObject:[NSString stringWithFormat:@"%d",j]]) {
                    [_tempDic removeObjectForKey:[NSString stringWithFormat:@"%d",j]];
                }
                if ([_oldWidthDic.allKeys containsObject:[NSString stringWithFormat:@"%d",j]]) {
                    [_oldWidthDic removeObjectForKey:[NSString stringWithFormat:@"%d",j]];
                }
            }
            _doubleclickCount = i;
            
            break;
        }
    }
}

#pragma mark - CNGridView DataSource
- (NSUInteger)gridView:(CNGridView *)gridView numberOfItemsInSection:(NSInteger)section {
    if (_isSearch) {
        return _researchdataSourceArray.count;
    }else {
        return _dataSourceArray.count;
    }
}

- (CNGridViewItem *)gridView:(CNGridView *)gridView itemAtIndex:(NSInteger)index inSection:(NSInteger)section {
    static NSString *reuseIdentifier = @"CNGridViewItem";
    
    CNGridViewItem *item = [gridView dequeueReusableItemWithIdentifier:@(index)];
    if (item == nil) {
        item = [[[CNGridViewItem alloc] initWithLayout:self.defaultLayout reuseIdentifier:reuseIdentifier] autorelease];
        item.hoverLayout = self.hoverLayout;
        item.selectionLayout = self.selectionLayout;
    }
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if (index >= array.count) {
        return item;
    }
    
    IMBDriveEntity *fileEntity = [array objectAtIndex:index];
    item.entity = fileEntity;
    item.category = _category;
    
    item.bgImg = fileEntity.image;
    item.itemTitle = fileEntity.fileName;
    
    item.isFileManager = YES;
    item.selected = fileEntity.checkState;
    
    if (fileEntity.checkState == Check) {
        if (![gridView.selectedItems containsObject:item]) {
            [[gridView getSelectedItemsDic] setObject:item forKey:@(item.index)];
        }
    }else{
        if ([gridView.selectedItems containsObject:item]) {
            [[gridView getSelectedItemsDic] removeObjectForKey:@(item.index)];
        }
    }
    return item;
}

#pragma mark - CNGridView Delegate
- (void)gridView:(CNGridView *)gridView didSelectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section{
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if (index < array.count) {
        IMBDriveEntity *fielEntity = [array objectAtIndex:index];
        fielEntity.checkState = Check;
        int count = 0;
        for (IMBDriveEntity *entity in array) {
            if (entity.checkState == Check) {
                count ++ ;
            }
        }
    }
}

- (void)gridView:(CNGridView *)gridView didDeselectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if (index < array.count) {
        IMBDriveEntity *fielEntity = [array objectAtIndex:index];
        fielEntity.checkState = UnChecked;
    }
}

- (void)gridViewDidDeselectAllItems:(CNGridView *)gridView {
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    
    for (IMBDriveEntity *fileEntity in array) {
        fileEntity.checkState = UnChecked;
    }
    [_gridView reloadSelecdImage];
}

- (void)gridView:(CNGridView *)gridView didDoubleClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
    if ((int)index >= 0 && index < _dataSourceArray.count) {
        IMBDriveEntity *driveEntity = [_dataSourceArray objectAtIndex:index];
        if (driveEntity.isFolder) {
            [_contentBox setContentView:_loadingView];
            [_loadAnimationView startAnimation];
            _doubleclickCount ++;
            _doubleClick = YES;
            NSString *fileName = driveEntity.fileName;
            if (fileName.length > 10) {
                fileName = [fileName substringWithRange:NSMakeRange(0, 9)];
            }
            [self configSelectPathButtonWithButtonTag:_doubleclickCount WithButtonTitle:fileName];
            if (driveEntity.childCount>120) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    @autoreleasepool {
                        [_driveBaseManage recursiveDirectoryContentsDics:driveEntity.fileID];
                        _currentDevicePath = driveEntity.fileID;
                    }
                });
            }else {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    if ([_oldDocwsid isEqualToString:driveEntity.docwsid]) {
                        _doubleClick = NO;
                        return ;
                    }
                    _oldDocwsid = driveEntity.docwsid;
                    [_driveBaseManage recursiveDirectoryContentsDics:driveEntity.docwsid];
                    _currentDevicePath = driveEntity.docwsid;
                });
            }
        }
    }
}

- (void)gridView:(CNGridView *)gridView didClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section {
    if (index < _dataSourceArray.count && (int)index >= 0) {
        IMBDriveEntity *driveEntity = [_dataSourceArray objectAtIndex:index];
        [self showFileDetailViewWithEntity:driveEntity];
    }
}

- (CATransition *)pushAnimation:(NSString *)type withSubType:(NSString *)subType durTimes:(float)time {//推动动画
    CATransition *transition = [CATransition animation];
    transition.duration = time;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = type;
    transition.subtype = subType;
    transition.startProgress = 0.0;
    transition.endProgress = 0.4;
    transition.removedOnCompletion = NO;
    transition.fillMode = kCAFillModeForwards;
    return transition;
}

- (void)showFileDetailViewWithEntity:(IMBDriveEntity *)entity {
    [_rightLineView setBackgroundColor:COLOR_TEXT_LINE];
    
    [_rightContentView setWantsLayer:YES];
    [_leftContentView setWantsLayer:YES];
    [_rightContentView.layer removeAllAnimations];
    [_leftContentView.layer removeAllAnimations];
    
//    CATransition *transition = [self pushAnimation:kCATransitionPush withSubType:kCATransitionFromRight durTimes:0.5];
//    [_rightContentView.layer addAnimation:transition forKey:@"animation"];
//    [_rightContentView setFrame:NSMakeRect(814, 0, 282, 548)];
//    [_leftContentView setFrame:NSMakeRect(0, 0, 814, 548)];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        
        NSRect rect= NSMakeRect(814, 0, 282, 548);
        NSRect rect2 = NSMakeRect(0, 0, 814, 548);
        [context setDuration:0.3];
        [[_rightContentView animator] setFrame:rect];
        [[_leftContentView animator] setFrame:rect2];
        
    } completionHandler:^{
        [self configDetailViewWith:entity];
    }];
}

- (IBAction)hideFileDetailView:(id)sender {
    [_rightContentView.layer removeAllAnimations];
    [_leftContentView.layer removeAllAnimations];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(1096, 0, 282,548);
        NSRect rect2 = NSMakeRect(0, 0, 1096, 548);
        [context setDuration:0.3];
        [[_rightContentView animator] setFrame:rect];
        [[_leftContentView animator] setFrame:rect2];
    } completionHandler:^{
        
    }];
    
}

- (void)configDetailViewWith:(IMBDriveEntity *)entity {
    
    [_detailSize setStringValue:CustomLocalizedString(@"iCloud_detailView_Size", nil)];
    [_detailCount setStringValue:CustomLocalizedString(@"iCloud_detailView_count", nil)];
    [_detailLastTime setStringValue:CustomLocalizedString(@"iCloud_detailView_lastTime", nil)];
    [_detailCreateTime setStringValue:CustomLocalizedString(@"iCloud_detailView_creatTime", nil)];
    
    [_detailSize setTextColor:COLOR_TEXT_ORDINARY];
    [_detailCount setTextColor:COLOR_TEXT_ORDINARY];
    [_detailLastTime setTextColor:COLOR_TEXT_ORDINARY];
    [_detailCreateTime setTextColor:COLOR_TEXT_ORDINARY];
    [_detailTitle setTextColor:COLOR_TEXT_ORDINARY];
    
    
    [_detailImageView setImage:entity.image];
    [_detailTitle setStringValue:entity.fileName];
    
    if ([StringHelper stringIsNilOrEmpty:entity.lastModifiedDateString]) {
        [_detailLastTimeContent setStringValue:@"--"];
    } else {
        [_detailLastTimeContent setStringValue:entity.lastModifiedDateString];
    }
    if ([StringHelper stringIsNilOrEmpty:entity.createdDateString]) {
        [_detailCreateTimeContent setStringValue:@"--"];
    } else {
        [_detailCreateTimeContent setStringValue:entity.createdDateString];
    }
    [_detailSizeContent setStringValue:[IMBHelper getFileSizeString:entity.fileSize reserved:2]];
    [_detailCountContent setStringValue:[NSString stringWithFormat:@"%d",entity.childCount]];
    
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_isSearch) {
        if (_researchdataSourceArray != nil && _researchdataSourceArray.count > 0) {
            return _researchdataSourceArray.count;
        }
    }else {
        if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
            return _dataSourceArray.count;
        }
    }
    
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    IMBDriveEntity *fileEntity = nil;
    if (_isSearch) {
        if (row >= _researchdataSourceArray.count) {
            return @"";
        }
        fileEntity = [_researchdataSourceArray objectAtIndex:row];
    }else{
        if (row >= _dataSourceArray.count) {
            return @"";
        }
        fileEntity = [_dataSourceArray objectAtIndex:row];
    }
    if ([tableColumn.identifier isEqualToString:@"Name"]) {
        
        return fileEntity.fileName;
        
    }else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
        
        return [NSNumber numberWithInt:fileEntity.checkState];
        
    }else if ([@"Formats" isEqualToString:tableColumn.identifier]){
        
        if (![StringHelper stringIsNilOrEmpty:fileEntity.extension]) {
            return fileEntity.extension;
        }else {
            return @"--";
        }
    }else if ([@"Time" isEqualToString:tableColumn.identifier]){
        if ([StringHelper stringIsNilOrEmpty:fileEntity.createdDateString]) {
            return @"--";
        }else{
            return fileEntity.createdDateString;
        }
    }else if ([@"Size" isEqualToString:tableColumn.identifier]){
        return [IMBHelper getFileSizeString:fileEntity.fileSize reserved:2];
    }
    return @"";
}

#pragma mark - NSTableViewdelegate
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    if ([tableColumn.identifier isEqualToString:@"Image"] && row < array.count) {
        IMBDriveEntity *fileEntity = [array objectAtIndex:row];
        NSImage *image = nil;
        IMBImageAndTextFieldCell *curCell = (IMBImageAndTextFieldCell *)cell;
        [curCell setImageSize:NSMakeSize(24, 24)];
        
        if (fileEntity.image) {
            image = fileEntity.image;
            [curCell setIsDataImage:YES];
            
        }else {
            image = fileEntity.image;
            [curCell setIsDataImage:YES];
        }
        curCell.image = image;
        curCell.marginX = 14;
    }
    
}

- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    return NO;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 40;
}

- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    NSMutableArray *disPalyAry = nil;
    if (_isSearch) {
        disPalyAry = _researchdataSourceArray;
    }else{
        disPalyAry = _dataSourceArray;
    }
    if (disPalyAry.count <=0) {
        return;
    }
    IMBDriveEntity *entity = [disPalyAry objectAtIndex:index];
    entity.checkState = !entity.checkState;
    
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[disPalyAry count]; i++) {
        IMBDriveEntity *item= [disPalyAry objectAtIndex:i];
        if (item.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    
    if (set.count == disPalyAry.count) {
        [_itemTableView changeHeaderCheckState:Check];
    }else if (set.count == 0){
        [_itemTableView changeHeaderCheckState:UnChecked];
    }else{
        [_itemTableView changeHeaderCheckState:SemiChecked];
    }
    [_itemTableView reloadData];
    
}

- (void)tableViewDoubleClick:(NSTableView *)tableView row:(NSInteger)index {
    [self gridView:_gridView didDoubleClickItemAtIndex:index inSection:0];
}

//排序
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    id cell = [tableColumn headerCell];
    NSString *identify = [tableColumn identifier];
    NSArray *array = [tableView tableColumns];
    NSMutableArray *disPalyAry = nil;
    if (_isSearch) {
        disPalyAry = _researchdataSourceArray;
    }else{
        disPalyAry = _dataSourceArray;
    }
    if (disPalyAry.count <=0) {
        return;
    }
    for (NSTableColumn  *column in array) {
        if ([column.headerCell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *columnHeadercell = (IMBCustomHeaderCell *)column.headerCell;
            if ([column.identifier isEqualToString:identify] && ![identify isEqualToString: @"Image"]) {
                [columnHeadercell setIsShowTriangle:YES];
            }else {
                [columnHeadercell setIsShowTriangle:NO];
            }
        }
        
    }
    
    if ( [@"Name" isEqualToString:identify] || [@"Formats" isEqualToString:identify] || [@"Time" isEqualToString:identify] || [@"Size" isEqualToString:identify]) {
        if ([cell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *customHeaderCell = (IMBCustomHeaderCell *)cell;
            if (customHeaderCell.ascending) {
                customHeaderCell.ascending = NO;
            }else {
                customHeaderCell.ascending = YES;
            }
            [self sort:customHeaderCell.ascending key:identify dataSource:disPalyAry];
        }
    }
    [_itemTableView reloadData];
}

- (void)sort:(BOOL)isAscending key:(NSString *)key dataSource:(NSMutableArray *)array {
    if ([key isEqualToString:@"Name"]) {
        key = @"fileName";
    } else if ([key isEqualToString:@"Formats"]) {
        key = @"fileExtension";
    }else if ([key isEqualToString:@"Size"]) {
        key = @"fileSize";
    }else if ([key isEqualToString:@"Time"]) {
        key = @"time";
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    [_itemTableView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
}

- (void)setAllselectState:(CheckStateEnum)checkState {
    NSArray *array = nil;
    if (_isSearch) {
        array = _researchdataSourceArray;
    }else {
        array = _dataSourceArray;
    }
    for (int i=0;i<[array count]; i++) {
        IMBDriveEntity *entity = [array objectAtIndex:i];
        [entity setCheckState:checkState];
    }
    [_itemTableView reloadData];
}

- (void)doSwitchView:(id)sender {
    IMBSegmentedBtn *segBtn = (IMBSegmentedBtn *)sender;
    if (segBtn.selectedSegment == 0) {
        [_itemTableView reloadData];
        if (_dataSourceArray.count > 0) {
            [_contentBox setContentView:_tableViewBgView];
        }else {
            //[_contentBox setContentView:_nodataView];
        }
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i=0;i<[_dataSourceArray count]; i++) {
            IMBDriveEntity *item= [_dataSourceArray objectAtIndex:i];
            if (item.checkState == NSOnState) {
                [set addIndex:i];
            }
        }
        if (set.count == _dataSourceArray.count && _dataSourceArray.count > 0) {
            [_itemTableView changeHeaderCheckState:Check];
        }else if (set.count == 0){
            [_itemTableView changeHeaderCheckState:UnChecked];
        }else{
            [_itemTableView changeHeaderCheckState:SemiChecked];
        }
        _currentSelectView = 0;
        [_itemTableView reloadData];
    }else if (segBtn.selectedSegment == 1) {
        [_gridView reloadData];
        _currentSelectView = 1;
        if (_dataSourceArray.count > 0) {
            [_contentBox setContentView:_gridBgView];
        }else {
            //[_contentBox setContentView:_nodataView];
        }
    }
}

- (void)changeContentViewWithDataArr:(NSMutableArray *)dataArr {
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    _dataSourceArray = [dataArr retain];
    [_gridView reloadData];
    [_itemTableView reloadData];
    if (_dataSourceArray.count > 0 && _dataSourceArray != nil) {
        if (_currentSelectView == 0) {
            [_contentBox setContentView:_itemTableView];
        } else {
            [_contentBox setContentView:_gridBgView];
        }
    } else {
        [_contentBox setContentView:_nodataView];
    }
    
}

- (void)loadSonAryComplete:(NSMutableArray *)sonAry {
    if (_doubleClick) {
        [_tempDic setObject:sonAry forKey:[NSString stringWithFormat:@"%d",_doubleclickCount]];
    }
    [self changeContentViewWithDataArr:sonAry];
    [_loadAnimationView endAnimation];
}

- (NSIndexSet *)selectedItems  {
    NSIndexSet *selectedItems = nil;
    if (_currentSelectView == 0) {
        NSMutableArray *disAry = nil;
        if (_isSearch) {
            disAry = _researchdataSourceArray;
        }else{
            disAry = _dataSourceArray;
        }
        NSMutableIndexSet *sets = [NSMutableIndexSet indexSet];
        for (int i=0;i<[disAry count]; i++) {
            IMBBaseEntity *entity = [disAry objectAtIndex:i];
            if (entity.checkState == Check||entity.checkState == SemiChecked) {
                [sets addIndex:i];
            }
        }
        selectedItems = sets;
    }else {
        selectedItems = _gridView.selectedIndexes;
    }
    return selectedItems;
}

#pragma mark - refresh data
- (void)reload:(id)sender {
    [_contentBox setContentView:_loadingView];
    [_loadAnimationView startAnimation];
    [_driveBaseManage recursiveDirectoryContentsDics:_currentDevicePath];
}

- (void)toMac:(id)sender {
    NSIndexSet *selectedItems = nil;
    if (_currentSelectView == 0) {
        NSMutableArray *disAry = nil;
        if (_isSearch) {
            disAry = _researchdataSourceArray;
        }else{
            disAry = _dataSourceArray;
        }
        NSMutableIndexSet *sets = [NSMutableIndexSet indexSet];
        for (int i=0;i<[disAry count]; i++) {
            IMBBaseEntity *entity = [disAry objectAtIndex:i];
            if (entity.checkState == Check||entity.checkState == SemiChecked) {
                [sets addIndex:i];
            }
        }
        selectedItems = sets;
    }else {
        selectedItems = [self selectedItems];
    }
    IMBDriveEntity *driveEntity = nil;
    if (_isSearch) {
        driveEntity = [[_researchdataSourceArray objectsAtIndexes:selectedItems] objectAtIndex:0];
    }else {
        driveEntity = [[_dataSourceArray objectsAtIndexes:selectedItems] objectAtIndex:0];
    }
    
    _downloaditem = [[DriveItem alloc] init];
    _downloaditem.itemIDOrPath = driveEntity.fileID;
    _downloaditem.fileName = driveEntity.fileName;
    NSUInteger state = driveEntity.isFolder;
    _downloaditem.docwsID = driveEntity.fileID;
    _downloaditem.zone = driveEntity.zone;
    
    if (state == 1) {
        _downloaditem.isFolder = YES;
    }else {
        _downloaditem.isFolder = NO;
    }
    [_driveBaseManage oneDriveDownloadOneItem:_downloaditem];
}

- (void)toDevice:(id)sender {
//    _openPanel = [NSOpenPanel openPanel];
//    //    _isOpen = YES;
//    [_openPanel setCanChooseDirectories:YES];
//    [_openPanel setCanChooseFiles:YES];
//    [_openPanel setAllowsMultipleSelection:YES];
//    [_openPanel beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
//        if (returnCode == NSFileHandlingPanelOKButton) {
//            NSArray *urlArr = [_openPanel URLs];
//            NSMutableArray *paths = [NSMutableArray array];
//            for (NSURL *url in urlArr) {
//                [paths addObject:url.path];
//            }
//            [self performSelector:@selector(addItemsDelay:) withObject:paths afterDelay:0.1];
//        }
//    }];
}

- (void)addItems:(id)sender {
    
}

- (void)addItemsDelay:(NSMutableArray *)paths {
    DriveItem *uploaditem = [[DriveItem alloc] init];
    [uploaditem setUploadParent:_currentDevicePath];
    NSString *pathStr = [paths objectAtIndex:0];
    
    [uploaditem setFileName:[pathStr lastPathComponent]];
    [uploaditem setLocalPath:pathStr];
    uploaditem.isFolder = NO;
    
    [_driveBaseManage oneDriveUploadItem:uploaditem];
}

- (void)deleteItems:(id)sender {
    
}

@end
