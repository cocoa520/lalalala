//
//  IMBVoiceMemosViewController.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/27.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBVoiceMemosViewController.h"
#import "IMBRecording.h"
#import "IMBRecordingEntry.h"
#import "IMBCustomHeaderCell.h"
#import "IMBCenterTextFieldCell.h"
#import "IMBDeviceMainPageViewController.h"
@implementation IMBVoiceMemosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    self = [super initWithIpod:ipod withCategoryNodesEnum:category withDelegate:delegate];
    if (self) {
        //获取数据
        if ([_information recording] != nil) {
            _dataSourceArray = [[[_information recording] recordingArray] retain];
        }
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        [self configNoDataView];
    });
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (_dataSourceArray.count == 0) {
        [_mainBox setContentView:_noDataView];
    }else {
        [_mainBox setContentView:_containTableView];
    }
    [self configNoDataView];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
}

- (void)changeSkin:(NSNotification *)notification
{
    [self configNoDataView];
    [_loadingAnimationView setNeedsDisplay:YES];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}


#pragma mark - NSTextView
- (void)configNoDataView {
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_iTunes_voice"]];
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    NSString *overStr = CustomLocalizedString(@"NO_DATA_TITLE_2", nil);
    promptStr = [[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_74", nil)] stringByAppendingString:overStr];
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]
, (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
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

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    return [displayArray count];
}

#pragma mark - NSTableViewDataSource
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <= 0) {
        return @"";
    }
    IMBRecordingEntry *record = [displayArray objectAtIndex:row];
    if ([@"Name" isEqualToString:tableColumn.identifier] ) {
        return record.name;
    }else if ([@"Time" isEqualToString:tableColumn.identifier]) {
        return [StringHelper getTimeString:record.timeLength * 1000];
    }else if ([@"Date" isEqualToString:tableColumn.identifier]) {
        return record.recorded;
    }else if ([@"Size" isEqualToString:tableColumn.identifier]) {
        return [StringHelper getFileSizeString:record.sizeLength reserved:2];
    }else if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
        return [NSNumber numberWithInt:record.checkState];
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    IMBRecordingEntry *record = [disAry objectAtIndex:index];
    record.checkState = !record.checkState;
    //点击checkBox 实现选中行
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[disAry count]; i++) {
        IMBRecordingEntry *record= [disAry objectAtIndex:i];
        if (record.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    
    if (record.checkState == NSOnState) {
//        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    }else if (record.checkState == NSOffState)
    {
        [_itemTableView deselectRow:index];
    }

    if (set.count == disAry.count) {
        [_itemTableView changeHeaderCheckState:NSOnState];
    }else if (set.count == 0){
        [_itemTableView changeHeaderCheckState:NSOffState];
    }else{
        [_itemTableView changeHeaderCheckState:NSMixedState];
    }
    [_itemTableView reloadData];
}

- (NSCell*)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == _itemTableView) {
        NSArray *displayArray = nil;
        if (_isSearch) {
            displayArray = _researchdataSourceArray;
        }else{
            displayArray = _dataSourceArray;
        }
        if (displayArray.count <= 0) {
            return nil;
        }
        IMBRecordingEntry *record = nil;
        if (displayArray != nil&&row<[displayArray count]) {
            record = [displayArray objectAtIndex:row];
        }
        
        if (![tableColumn.identifier isEqualToString:@"CheckCol"]) {
            if (tableColumn != nil) {
                IMBCenterTextFieldCell *cell = (IMBCenterTextFieldCell *)[tableColumn dataCell];
                cell.isExist = record.fileIsExist;
            }
        }
    }
    return [tableColumn dataCell];
}

#pragma mark - NSTableViewdelegate
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
//    NSTableView *atableView = [notification object];
//    if (atableView == _itemTableView) {
//        NSIndexSet *set = [_itemTableView selectedRowIndexes];
//        for (int i=0; i<[_dataSourceArray count]; i++) {
//            IMBRecordingEntry *record = [_dataSourceArray objectAtIndex:i];
//            if ([set containsIndex:i]) {
//                [record setCheckState:NSOnState];
//            }else{
//                [record setCheckState:NSOffState];
//            }
//        }
//        if ([set count] == [_dataSourceArray count]&&[_dataSourceArray count]>0) {
//            [_itemTableView changeHeaderCheckState:NSOnState];
//        }else if ([set count] == 0) {
//            [_itemTableView changeHeaderCheckState:NSOffState];
//        }else {
//            [_itemTableView changeHeaderCheckState:NSMixedState];
//        }
//    }
    [_itemTableView reloadData];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 32;
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    id cell = [tableColumn headerCell];
    NSString *identify = [tableColumn identifier];
    NSArray *array = [tableView tableColumns];
    NSMutableArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <= 0) {
        return;
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
	if ( [@"Name" isEqualToString:identify] || [@"Time" isEqualToString:identify] || [@"Date" isEqualToString:identify] || [@"Size" isEqualToString:identify] ) {
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
        key = @"name";
    } else if ([key isEqualToString:@"Time"]) {
        key = @"timeLength";
    }else if ([key isEqualToString:@"Date"]) {
        key = @"recorded";
    } else if ([key isEqualToString:@"Size"]) {
        key = @"sizeLength";
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
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }

    for (int i=0;i<[disAry count]; i++) {
        IMBRecordingEntry *record = [disAry objectAtIndex:i];
        [record setCheckState:checkState];
        if (record.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
//    [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    [_itemTableView reloadData];
}

#pragma mark - about reloadActions
- (void)reload:(id)sender
{
    [self disableFunctionBtn:NO];
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            if (_ipod != nil) {
                [_ipod startSync];
                [_information refreshMedia];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self disableFunctionBtn:YES];
//                    [self refresh];
                    if (_dataSourceArray != nil) {
                        [_dataSourceArray release];
                        _dataSourceArray = nil;
                    }
                    _dataSourceArray = (NSMutableArray *)[[[_information recording] refreshRecordings] retain];
                    if (_dataSourceArray.count == 0) {
                        [_mainBox setContentView:_noDataView];
                        [self configNoDataView];
                    }else {
                        [_mainBox setContentView:_containTableView];
                    }
                    [_itemTableView deselectAll:nil];
                    if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                        [(IMBDeviceMainPageViewController*)_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
                    }
                    [_loadingAnimationView endAnimation];
                    
                    int checkCount = 0;
                    for (int i=0; i<[_dataSourceArray count]; i++) {
                        IMBRecordingEntry *entity = [_dataSourceArray objectAtIndex:i];
                        if (entity.checkState == NSOnState) {
                            checkCount ++;
                        }
                    }
                    if (checkCount == [_dataSourceArray count]&&[_dataSourceArray count]>0) {
                        [_itemTableView changeHeaderCheckState:NSOnState];
                    }else if (checkCount  == 0){
                        [_itemTableView changeHeaderCheckState:NSOffState];
                    }else{
                        [_itemTableView changeHeaderCheckState:NSMixedState];
                    }
                    [_itemTableView reloadData];
                    
                });
                [_ipod endSync];
            }
        }
    });
}

-(void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    _searchFieldBtn = searchBtn;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
    }
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    
    int checkCount = 0;
    for (int i=0; i<[disAry count]; i++) {
        IMBRecordingEntry *photoEntity = [disAry objectAtIndex:i];
        if (photoEntity.checkState == NSOnState) {
            checkCount ++;
        }
    }
    if (checkCount == [disAry count]&&[disAry count]>0) {
        [_itemTableView changeHeaderCheckState:NSOnState];
    }else if (checkCount  == 0)
    {
        [_itemTableView changeHeaderCheckState:NSOffState];
    }else
    {
        [_itemTableView changeHeaderCheckState:NSMixedState];
    }
    

    [_itemTableView reloadData];
}

@end
