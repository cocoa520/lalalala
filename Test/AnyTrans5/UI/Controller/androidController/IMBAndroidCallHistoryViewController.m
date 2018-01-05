//
//  IMBBackupCallHistoryViewController.m
//  AnyTrans
//
//  Created by long on 17-7-17.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBAndroidCallHistoryViewController.h"
#import "IMBCallHistoryDataEntity.h"
#import "IMBCenterTextFieldCell.h"
#import "IMBImageAndTextCell.h"
#import "DateHelper.h"
#import "IMBCallHistorySqliteManager.h"
#import "IMBCheckBoxCell.h"
#import "IMBCustomHeaderCell.h"
#import "IMBAndroidMainPageViewController.h"
@interface IMBAndroidCallHistoryViewController ()

@end

@implementation IMBAndroidCallHistoryViewController
@synthesize isSortByName = _isSortByName;
#pragma mark - 初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initwithAndroid:(IMBAndroid *)android withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate{
    if ([super initwithAndroid:android withCategoryNodesEnum:category withDelegate:delegate]) {
        _dataSourceArray = [android.adCallHistory.reslutEntity.reslutArray retain];
        _category = Category_CallHistory;
    }
    return self;
}
#pragma mark - 切换语言and皮肤
-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        [self setNoDataViewImageAndText];
    });
}

- (void)changeSkin:(NSNotification *)notification{
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [_itemTableView setBackgroundColor:[NSColor clearColor]];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [self setNoDataViewImageAndText];
    [_topWhiteView setNeedsDisplay:YES];
    [_sortRightPopuBtn setNeedsDisplay:YES];
    [_selectSortBtn setNeedsDisplay:YES];
    [_loadingAnmationView setNeedsDisplay:YES];
    [self.view setNeedsDisplay:YES];
}

- (void)awakeFromNib{
    _isloadingPopBtn = YES;
    _isAndroid = YES;
    [super awakeFromNib];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_itemTableView setBackgroundColor:[NSColor clearColor]];
    [_loadingAnmationView startAnimation];
    [_callHistoryBox setContentView:_loadingView];
    _itemTableView.allowsMultipleSelection = NO;
    _itemTableView.menu.delegate = self;
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_rightTableView setDelegate:self];
    [_rightTableView setDataSource:self];
    [_rightTableView setListener:self];
    [_rightTableView setBackgroundColor:[NSColor clearColor]];
    [_rightTableView.checkBoxCell.checkButton setHidden:YES];
    [_topWhiteView setIsBommt:YES];
    [_topWhiteView setBackgroundColor:[NSColor clearColor]];
    if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
        [_callHistoryBox setContentView:_callHistoryDataView];
        NSInteger row = [_itemTableView selectedRow];
        [_itemTableView deselectRow:row];
    }else{
        [self setNoDataViewImageAndText];
        [_callHistoryBox setContentView:_noData];
    }
}

#pragma mark - noData界面加载
- (void)setNoDataViewImageAndText {
    [_nodataImageView setImage:[StringHelper imageNamed:@"noData_callhistory"]];
    [_textView setDelegate:self];
    [_textView setSelectable:YES];
    NSString *overStr1 = CustomLocalizedString(@"noData_subTitle1", nil);
    NSString *promptStr1 = [[[NSString stringWithFormat:CustomLocalizedString(@"noData_subTitle", nil),CustomLocalizedString(@"MenuItem_id_18", nil)] stringByAppendingString:@" "] stringByAppendingString:overStr1];
    NSString *promptStr = [[[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_18", nil)] stringByAppendingString:@" "] stringByAppendingString:promptStr1];
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_textView setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [promptStr rangeOfString:overStr1];
    [promptAs addAttribute:NSLinkAttributeName value:overStr1 range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_textView textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
}

#pragma mark - textView Delegate
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    NSString *overStr = CustomLocalizedString(@"noData_subTitle1", nil);
    if ([link isEqualToString:overStr]) {
        NSLog(@"控制apk将手机界面显示为权限管理的界面");
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSView *view = nil;
            for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
                if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                    view = subView;
                    break;
                }
            }
            if (view) {
                [view setHidden:NO];
                [_androidAlertViewController setAndroid:_android];
                [_androidAlertViewController showNoDataAlertViewWithSuperView:view];
            }
            
        });
        
    }
    return YES;
}

#pragma mark - NSTabelDelegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 38;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView.tag == 1) {
        NSMutableArray *disAry = nil;
        if (_isSearch) {
            disAry = _researchdataSourceArray;
        }else{
            disAry = _dataSourceArray;
        }
        if (disAry.count <= 0) {
            return 0;
        }
        if (disAry != nil) {
            return disAry.count;
        }
    }else if (tableView.tag == 2){
        if (_sonAry == nil) {
            return 0;
        }else{
            return _sonAry.count;
        }
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView.tag == 1) {
        NSMutableArray *disAry = nil;
        if (_isSearch) {
            disAry = _researchdataSourceArray;
        }else{
            disAry = _dataSourceArray;
        }
        if (disAry.count <= 0) {
            return nil;
        }
        if (disAry != nil && disAry.count > row) {
            IMBADCallContactEntity *contactModel = [disAry objectAtIndex:row];
            if ([tableColumn.identifier isEqualToString:@"Name"]) {
                
                return contactModel.callName;
            }
            else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
                return [NSNumber numberWithInt:contactModel.checkState];
            }
        }
    }else if (tableView.tag == 2){
        if (_sonAry != nil && _sonAry.count > row) {
            IMBADCallHistoryEntity *contactModel = [_sonAry objectAtIndex:row];
            if ([tableColumn.identifier isEqualToString:@"Type"]) {
                if (contactModel.callType == OUTGOING_TYPE) {
                    return CustomLocalizedString(@"callhistory_id_1", nil);
                }else if (contactModel.callType == UNKNOW_TYPE){
                    return CustomLocalizedString(@"Common_id_10", nil);
                }else if (contactModel.callType == MISSED_TYPE){
                    return CustomLocalizedString(@"callhistory_id_1", nil);
                }else if (contactModel.callType == INCOMING_TYPE){
                    return CustomLocalizedString(@"callhistory_id_1", nil);
                }else if (contactModel.callType == REJECTED_TYPE){
                    return CustomLocalizedString(@"callhistory_id_1", nil);
                }
            }else if ([tableColumn.identifier isEqualToString:@"Phone"]) {
                return contactModel.phoneNumber;
            }else if ([tableColumn.identifier isEqualToString:@"Date"]){
                return contactModel.dateStr;
            }else if ([tableColumn.identifier isEqualToString:@"Duration"]){
                return [DateHelper getTimeAutoShowHourString:contactModel.duration*1000];
            }else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
                return[NSNumber numberWithBool:contactModel.checkState];
            }
        }
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView row:(NSInteger)index{
    if (tableView.tag == 1) {
        NSMutableArray *disAry = nil;
        if (_isSearch) {
            disAry = _researchdataSourceArray;
        }else{
            disAry = _dataSourceArray;
        }
        IMBADCallContactEntity *bookMark = [disAry objectAtIndex:index];
        if (bookMark.checkState == SemiChecked) {
            bookMark.checkState = Check;
        }else{
            bookMark.checkState = !bookMark.checkState;
        }
        int seleCount = 0;
        int semiCount = 0;
        NSMutableArray *disary = nil;
        if (_isSearch) {
            disary = _researchdataSourceArray;
        }else{
            disary = _dataSourceArray;
        }
        for (IMBADCallContactEntity *contactModel in _dataSourceArray) {
            if (contactModel.checkState == Check) {
                seleCount ++;
            }else if (contactModel.checkState == SemiChecked){
                semiCount ++;
            }
        }
        if (seleCount == _dataSourceArray.count) {
            [_itemTableView changeHeaderCheckState:Check];
        }else if (seleCount == 0 && semiCount == 0){
            [_itemTableView changeHeaderCheckState:UnChecked];
        }else{
            [_itemTableView changeHeaderCheckState:SemiChecked];
        }
        
        if (bookMark.checkState == Check) {
            for (IMBADCallHistoryEntity *entity in bookMark.callArray) {
                entity.checkState = Check;
            }
            bookMark.selectedCount = bookMark.callCount;
            if (_itemTableView.selectedRow == index) {
                [_rightTableView changeHeaderCheckState:Check];
            }
        }else{
            for (IMBADCallHistoryEntity *entity in bookMark.callArray) {
                entity.checkState = UnChecked;
            }
            bookMark.selectedCount = 0;
            if (_itemTableView.selectedRow == index) {
                [_rightTableView changeHeaderCheckState:UnChecked];
            }
        }
        [_itemTableView reloadData];
        [_rightTableView reloadData];
    }else if (tableView.tag == 2){
        NSMutableArray *disAry = nil;
        if (_isSearch) {
            disAry = _researchdataSourceArray;
        }else{
            disAry = _dataSourceArray;
        }

        IMBADCallHistoryEntity *safariEntity = [_sonAry objectAtIndex:index];
        safariEntity.checkState = !safariEntity.checkState;
        int checkCount = 0;
        for (IMBADCallHistoryEntity *historydata in _sonAry) {
            if (historydata.checkState == Check) {
                checkCount ++;
            }
        }
        IMBCallContactModel *bookMark = [disAry objectAtIndex:_itemTableView.selectedRow];
        if (checkCount == _sonAry.count) {
            bookMark.checkState = Check;
            [_rightTableView changeHeaderCheckState:Check];
        }else if (checkCount == 0){
            bookMark.checkState = UnChecked;
            [_rightTableView changeHeaderCheckState:UnChecked];
        }else{
            bookMark.checkState = SemiChecked;
            [_rightTableView changeHeaderCheckState:SemiChecked];
        }
        bookMark.selectedCount = checkCount;
        
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i=0;i<[_sonAry count]; i++) {
            IMBCallHistoryDataEntity *bookMark= [_sonAry objectAtIndex:i];
            if (bookMark.checkState == NSOnState) {
                [set addIndex:i];
            }
        }
    }
    int selecdCount = 0;
    int allselecdCount = 0;
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    for (IMBADCallContactEntity *bookMark in disAry) {
        if (bookMark.checkState == Check) {
            selecdCount ++;
        }
        for (IMBCallHistoryDataEntity *entity in bookMark.callArray) {
            if (entity.checkState == Check) {
                allselecdCount ++;
            }
        }
    }
    [_itemTableView reloadData];
    [_rightTableView reloadData];
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if (![@"CheckCol" isEqualToString:tableColumn.identifier]) {
        if (tableView.tag == 2){
            IMBCallHistoryDataEntity *contactModel = [_sonAry objectAtIndex:row];
            if ([tableColumn.identifier isEqualToString:@"Type"]) {
                IMBImageAndTextCell *imageCell = (IMBImageAndTextCell *)cell;
                [imageCell setMarginX:10];
                [imageCell setPaddingX:0];
                [imageCell setImageSize:NSMakeSize(12, 12)];
                
                if (contactModel.callType == OUTGOING_TYPE) {
                    [imageCell setImage:[StringHelper imageNamed:@"callOut"]];
                    [imageCell setImageName:@"callOut"];
                }else if (contactModel.callType == UNKNOW_TYPE){
                    [imageCell setImage:[StringHelper imageNamed:@"callIn"]];
                    [imageCell setImageName:@"callIn"];
                }else if (contactModel.callType == OUTGOING_TYPE){
                    [imageCell setImage:[StringHelper imageNamed:@"callOut"]];
                    [imageCell setImageName:@"callOut"];
                }else if (contactModel.callType == INCOMING_TYPE){
                    [imageCell setImage:[StringHelper imageNamed:@"callIn"]];
                    [imageCell setImageName:@"callIn"];
                }else if (contactModel.callType == OUTGOING_TYPE){
                    [imageCell setImage:[StringHelper imageNamed:@"callOut"]];
                    [imageCell setImageName:@"callOut"];
                }else if (contactModel.callType == OUTGOING_TYPE){
                    [imageCell setImage:[StringHelper imageNamed:@"callOut"]];
                    [imageCell setImageName:@"callOut"];
                }else if (contactModel.callType == OUTGOING_TYPE){
                    [imageCell setImage:[StringHelper imageNamed:@"callOut"]];
                    [imageCell setImageName:@"callOut"];
                }else if (contactModel.callType == OUTGOING_TYPE){
                    [imageCell setImage:[StringHelper imageNamed:@"callOut"]];
                    [imageCell setImageName:@"callOut"];
                }else if (contactModel.callType == OUTGOING_TYPE){
                    [imageCell setImage:[StringHelper imageNamed:@"callOut"]];
                    [imageCell setImageName:@"callOut"];
                }else if (contactModel.callType == MISSED_TYPE){
                    [imageCell setImage:[StringHelper imageNamed:@"callIn"]];
                    [imageCell setImageName:@"callIn"];
                }
            }
        }
    }else{
        if (tableView.tag == 1) {
            if ([[tableColumn identifier] isEqualToString:@"CheckCol"]) {
                IMBCheckBoxCell *boxCell = (IMBCheckBoxCell *)cell;
                boxCell.outlineCheck = YES;
            }
        }
    }
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    id cell = [tableColumn headerCell];
    NSString *identify = [tableColumn identifier];
    NSArray *array = [tableView tableColumns];
    for (NSTableColumn  *column in array) {
        if ([column.headerCell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *columnHeadercell = (IMBCustomHeaderCell *)column.headerCell;
            if (![@"Duration" isEqualToString:identify] && ![@"Date" isEqualToString:identify]) {
                [columnHeadercell setIsShowTriangle:NO];
            }else{
                if ([column.identifier isEqualToString:identify]) {
                    [columnHeadercell setIsShowTriangle:YES];
                }else {
                    [columnHeadercell setIsShowTriangle:NO];
                }
            }
        }
    }
	if ( [@"Duration" isEqualToString:identify] || [@"Date" isEqualToString:identify]) {
        if ([cell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *customHeaderCell = (IMBCustomHeaderCell *)cell;
            if (customHeaderCell.ascending) {
                customHeaderCell.ascending = NO;
            }else
            {
                customHeaderCell.ascending = YES;
            }
            [self sort:customHeaderCell.ascending key:identify dataSource:_sonAry];
        }
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i=0;i<[_sonAry count]; i++) {
            IMBTrack *track = [_sonAry objectAtIndex:i];
            if (track.checkState == NSOnState) {
                [set addIndex:i];
            }
        }
    }
}

- (void)sort:(BOOL)isAscending key:(NSString *)key dataSource:(NSMutableArray *)array {
    if ([key isEqualToString:@"Duration"]) {
        key = @"duration";
    } else if ([key isEqualToString:@"Date"]) {
        key = @"dateStr";
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    
    [sortDescriptor release];
    [sortDescriptors release];
    [_rightTableView reloadData];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    NSTableView *atableView = [notification object];
    NSInteger row = [atableView selectedRow];
    if (row <0) {
        row = 0;
    }
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    
    if (atableView == _itemTableView) {
        
        [self changeSonTableViewData:atableView];
        
    } else {
        [_rightTableView reloadData];
        [_itemTableView reloadData];
    }
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
    return NSDragOperationNone;
}

- (void)changeSonTableViewrow:(NSInteger) tagRow {
    
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return ;
    }
    if (disAry != nil && disAry.count > tagRow) {
        IMBADCallContactEntity *model = [disAry objectAtIndex:tagRow];
        _sonAry = model.callArray ;
    }else {
        _sonAry = nil;
    }
    
    [_rightTableView reloadData];
    [_itemTableView reloadData];
}

- (void)loadSonAryData{
    
    NSInteger row = [_itemTableView selectedRow];
    if (row >= 0) {
        IMBADCallContactEntity *model = nil;[_dataSourceArray objectAtIndex:row];
        if (_dataSourceArray.count > row) {
            model = [_dataSourceArray objectAtIndex:row];
        }else {
            if (_dataSourceArray.count > 0) {
                model = [_dataSourceArray objectAtIndex:0];
            }
        }
        if (model) {
            _sonAry = model.callArray ;
        }
    }
}

- (void)changeSonTableViewData:(NSTableView *)tableView {
    NSInteger row = [tableView selectedRow];
    if (row < 0) {
        row = 0;
    }
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return ;
    }
    if (tableView == _itemTableView) {
        if (disAry != nil && disAry.count > row) {
            IMBADCallContactEntity *contactEntity = [disAry objectAtIndex:row];
            _sonAry = contactEntity.callArray;
        }else {
            _sonAry = nil;
        }
    }
    [_rightTableView reloadData];
    [_itemTableView reloadData];
}

-(void)setselectState:(CheckStateEnum)state WithTableView:(NSTableView *)tableView {
    
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    
    if (tableView.tag == 1) {
        for (IMBADCallContactEntity *contactModel in disAry) {
            contactModel.checkState = state;
            for (IMBADCallHistoryEntity *historydata in contactModel.callArray) {
                historydata.checkState = state;
            }
        }
        
        [_rightTableView changeHeaderCheckState:state];
    }else{
        IMBADCallContactEntity *contactModel = [disAry objectAtIndex:[_itemTableView selectedRow]];
        contactModel.checkState = state;
        for (IMBADCallHistoryEntity *historydata in _sonAry) {
            historydata.checkState = state;
        }
        int checkCount = 0;
        int semiCount = 0;
        for (IMBADCallContactEntity *contactModel in disAry) {
            if (contactModel.checkState == Check) {
                checkCount++;
            }else if (contactModel.checkState == SemiChecked){
                semiCount++;
            }
        }
        if (checkCount == disAry.count) {
            [_itemTableView changeHeaderCheckState:Check];
        }else if (semiCount == 0&& checkCount == 0){
            [_itemTableView changeHeaderCheckState:UnChecked];
        }else{
            [_itemTableView changeHeaderCheckState:SemiChecked];
        }
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i=0;i<[_sonAry count]; i++) {
            IMBADCallHistoryEntity *bookMark= [_sonAry objectAtIndex:i];
            if (bookMark.checkState == NSOnState) {
                [set addIndex:i];
            }
        }
    }
    [_itemTableView reloadData];
    [_rightTableView reloadData];
}
#pragma mark - Action
- (IBAction)sortRightPopuBtn:(id)sender {
    NSMenuItem *item = [_sortRightPopuBtn selectedItem];
    NSInteger tag = [_sortRightPopuBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
        if (menuItem.tag != 1 || menuItem.tag != 2) {
            [menuItem setState:NSOffState];
        }
    }
    NSMutableArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else{
        displayArr = _dataSourceArray;
    }
    NSString *str1 = nil;
    if (item.tag == 1) {
        _isSortByName = YES;
        for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
            if (menuItem.tag != 1) {
                [menuItem setState:NSOffState];
            }
            if (menuItem.tag == 3) {
                if (_isAscending) {
                    [menuItem setState:NSOnState];
                }else{
                    [menuItem setState:NSOffState];
                }
            }else if (menuItem.tag == 4){
                if (_isAscending) {
                    [menuItem setState:NSOffState];
                }else{
                    [menuItem setState:NSOnState];
                }
            }
        }
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"callName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [displayArr sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        [_sortRightPopuBtn setTitle:[_sortRightPopuBtn titleOfSelectedItem]];
        str1 = CustomLocalizedString(@"SortBy_Name", nil);
    }else if (tag == 2){
        _isSortByName = NO;
        for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
            if (menuItem.tag != 2) {
                [menuItem setState:NSOffState];
            }
            if (menuItem.tag == 3) {
                if (_isAscending) {
                    [menuItem setState:NSOnState];
                }else{
                    [menuItem setState:NSOffState];
                }
            }else if (menuItem.tag == 4){
                if (_isAscending) {
                    [menuItem setState:NSOffState];
                }else{
                    [menuItem setState:NSOnState];
                }
            }
        }
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateStr" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [displayArr sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        str1 = CustomLocalizedString(@"SortBy_Date", nil);
    }else if (item.tag == 3){
        _isAscending = YES;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = nil;
        for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
            if (menuItem.tag == 1) {
                [menuItem setState:NSOnState];
            }
        }
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"callName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        str1 = CustomLocalizedString(@"SortBy_Name", nil);
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [displayArr sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }else if (item.tag == 4){
        _isAscending = NO;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = nil;
        for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
            if (menuItem.tag == 1) {
                [menuItem setState:NSOnState];
            }
        }
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"callName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        str1 = CustomLocalizedString(@"SortBy_Name", nil);
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [displayArr sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }
    [_sortRightPopuBtn setTitle:str1];
    [_sortRightPopuBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    
    NSRect rect = [TempHelper calcuTextBounds:str1 fontSize:12];
    [_sortRightPopuBtn setFrame:NSMakeRect(_topWhiteView.frame.size.width - 30 - rect.size.width-12,_sortRightPopuBtn.frame.origin.y , rect.size.width +30, _sortRightPopuBtn.frame.size.height)];
    [_sortRightPopuBtn setTitle:str1];
    [self changeSonTableViewData:_itemTableView];
}

- (IBAction)sortSelectedPopuBtn:(id)sender {
    NSMenuItem *item = [_selectSortBtn selectedItem];
    NSInteger tag = [_selectSortBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _selectSortBtn.itemArray) {
        [menuItem setState:NSOffState];
    }
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else{
        displayArr = _dataSourceArray;
    }
    if (tag == 1) {
        for (IMBADCallContactEntity *note in displayArr) {
            note.checkState = Check;
            for (IMBADCallHistoryEntity *dataEntity in note.callArray) {
                dataEntity.checkState = Check;
            }
        }
        [_rightTableView changeHeaderCheckState:Check];
    }else if (tag == 2){
        for (IMBADCallContactEntity *note in displayArr) {
            note.checkState = UnChecked;
            for (IMBADCallHistoryEntity *dataEntity in note.callArray) {
                dataEntity.checkState = UnChecked;
            }
        }
        [_rightTableView changeHeaderCheckState:UnChecked];
    }
    [item setState:NSOnState];
    NSRect rect1 = [TempHelper calcuTextBounds:item.title fontSize:12];
    int wide = 0;
    if (rect1.size.width >170) {
        wide = 170;
    }else{
        wide = rect1.size.width;
    }
    [_selectSortBtn setFrame:NSMakeRect(-2,_selectSortBtn.frame.origin.y , wide +30, _selectSortBtn.frame.size.height)];
    [_selectSortBtn setTitle:[_selectSortBtn titleOfSelectedItem]];
    [_itemTableView reloadData];
    [_rightTableView reloadData];
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
        _isSearch = YES;
    _searchFieldBtn = searchBtn;
    [_researchdataSourceArray removeAllObjects];
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"callName CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
        if (_researchdataSourceArray.count <=0) {
            _sonAry = nil;
        }
    }else{
        _isSearch = NO;
        
    }
    NSNotification *noti = [NSNotification notificationWithName:@"" object:_itemTableView];
    NSNotification *noti1 = [NSNotification notificationWithName:@"" object:_rightTableView];
    [self tableViewSelectionDidChange:noti];
    [self tableViewSelectionDidChange:noti1];
    [_itemTableView reloadData];
    [_rightTableView reloadData];
}

- (void)androidReload:(id)sender{
    [_toolBar toolBarButtonIsEnabled:NO];
    [self disableFunctionBtn:NO];
    [_callHistoryBox setContentView:_loadingView];
    [_loadingAnmationView startAnimation];
    
    //检查apk是否赋予权限
    if (_delegate != nil && [_delegate respondsToSelector:@selector(checkDeviceGreantedPermission:)] ) {
        [_delegate checkDeviceGreantedPermission:ReloadFunctionType];
    }
}

- (void)reloadData {
    [_android queryCallHistoryDetailInfo];
    if (_dataSourceArray!= nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    _dataSourceArray = [_android.adCallHistory.reslutEntity.reslutArray retain];
    if (_dataSourceArray.count >0) {
        IMBADCallContactEntity *callEntity = [_dataSourceArray objectAtIndex:0];
        [callEntity setCheckState:UnChecked];
        if (_isSearch) {
            if (_researchdataSourceArray.count >0) {
                _sonAry =  callEntity.callArray;
            }
        }else{
            if (_dataSourceArray.count >0) {
                _sonAry =  callEntity.callArray ;
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self disableFunctionBtn:YES];
        if ([_dataSourceArray count]>0) {
            [_callHistoryBox setContentView:_callHistoryDataView];
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }else {
            [self setNoDataViewImageAndText];
            [_callHistoryBox setContentView:_noData];
        }
        
        int count = 0;
        for (IMBADCallContactEntity *collectionEntity in _dataSourceArray) {
            count += collectionEntity.callArray.count;
        }
        
        if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
            [_delegate refeashBadgeConut:count WithCategory:_category];
        }
        [_loadingAnmationView endAnimation];
        [_itemTableView reloadData];
        [_toolBar toolBarButtonIsEnabled:YES];
        [_itemTableView reloadData];
        [_rightTableView reloadData];
    });
}

- (void)cancelReload {
    if ([_dataSourceArray count]>0) {
        [_callHistoryBox setContentView:_callHistoryDataView];
    }else {
        [self setNoDataViewImageAndText];
        [_callHistoryBox setContentView:_noData];
    }
    [_loadingAnmationView endAnimation];
    [self disableFunctionBtn:YES];
    [_toolBar toolBarButtonIsEnabled:YES];
}

- (void)menuWillOpen:(NSMenu *)menu {
    [self initAndroidDeviceMenuItem];
}

//返回按钮
- (void)doBack:(id)sender {
    [super doBack:sender];
    if (_searchFieldBtn != nil) {
        [self doSearchBtn:nil withSearchBtn:_searchFieldBtn];
    }
}

- (void)dealloc {
    [super dealloc];
}
@end
