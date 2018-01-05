//
//  IMBBackupCallHistoryViewController.m
//  AnyTrans
//
//  Created by long on 16-7-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBackupCallHistoryViewController.h"
#import "IMBCallHistoryDataEntity.h"
#import "IMBCenterTextFieldCell.h"
#import "IMBImageAndTextCell.h"
#import "DateHelper.h"
#import "IMBCallHistorySqliteManager.h"
#import "IMBCheckBoxCell.h"
#import "IMBCustomHeaderCell.h"
@interface IMBBackupCallHistoryViewController ()

@end

@implementation IMBBackupCallHistoryViewController
@synthesize isSortByName = _isSortByName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithProductVersion:(SimpleNode *)node withDelegate:(id)delegate WithIMBBackupDecryptAbove4:(IMBBackupDecryptAbove4 *)abve4 {
    if ([super initWithNibName:@"IMBBackupCallHistoryViewController" bundle:nil]) {
        _category = Category_CallHistory;
        _delegate = delegate;
        _decryptAbove4 = abve4;
        _node = node;
    }
    return self;
}

-(id)initiCloudWithiCloudBackUp:(IMBiCloudBackup *)icloudBackup WithDelegate:(id)delegate{
    if ([super initWithNibName:@"IMBBackupCallHistoryViewController" bundle:nil]) {
        _category = Category_CallHistory;
        _delegate = delegate;
        _isiCloud = YES;
        _iCloudBackup = icloudBackup;
        _isiCloudView = YES;
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_CallLog", nil)];
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [_textView setAttributedStringValue:as];
        [_textView setSelectable:NO];
    });

}

-(void)awakeFromNib{
    _isloadingPopBtn = YES;
    [super awakeFromNib];
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_nodataImageView setImage:[StringHelper imageNamed:@"noData_callhistory"]];
//    [_itemTableView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_itemTableView setBackgroundColor:[NSColor clearColor]];
    [_loadingAnmationView startAnimation];
    [_callHistoryBox setContentView:_loadingView];
    _itemTableView.allowsMultipleSelection = NO;
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_rightTableView setDelegate:self];
    [_rightTableView setDataSource:self];
    [_rightTableView setListener:self];
    [_rightTableView setBackgroundColor:[NSColor clearColor]];
    [_topWhiteView setIsBommt:YES];
    [_topWhiteView setBackgroundColor:[NSColor clearColor]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        IMBCallHistorySqliteManager *bookMarkManager = nil;
        if (_isiCloud) {
            bookMarkManager = [[IMBCallHistorySqliteManager alloc] initWithiCloudBackup:_iCloudBackup withType:_iCloudBackup.iOSVersion];
        }else{
            bookMarkManager = [[IMBCallHistorySqliteManager alloc] initWithAMDevice:nil backupfilePath:_node.backupPath withDBType:_node.productVersion WithisEncrypted:_node.isEncrypt withBackUpDecrypt:_decryptAbove4];
        }
        [bookMarkManager querySqliteDBContent] ;
        dispatch_async(dispatch_get_main_queue(), ^{
            _dataSourceArray = [bookMarkManager.dataAry retain];
            if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
                [_callHistoryBox setContentView:_callHistoryDataView];
                [_itemTableView reloadData];
                [_rightTableView reloadData];
            }else{
                [_callHistoryBox setContentView:_noData];
                NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_CallLog", nil)];
                NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
                [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
                [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
                [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
                [_textView setAttributedStringValue:as];
                [_textView setSelectable:NO];
            }
        });
    });

    
}

- (void)changeSkin:(NSNotification *)notification
{
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
//    [_itemTableView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [_itemTableView setBackgroundColor:[NSColor clearColor]];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_CallLog", nil)];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_textView setAttributedStringValue:as];
    [_textView setSelectable:NO];
    [_nodataImageView setImage:[StringHelper imageNamed:@"noData_callhistory"]];
    [_topWhiteView setNeedsDisplay:YES];
    [_sortRightPopuBtn setNeedsDisplay:YES];
    [_selectSortBtn setNeedsDisplay:YES];
    [_loadingAnmationView setNeedsDisplay:YES];
    [self.view setNeedsDisplay:YES];
}


- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 36;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
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
            IMBCallContactModel *contactModel = [disAry objectAtIndex:row];
            if ([tableColumn.identifier isEqualToString:@"Name"]) {

                return contactModel.contactName;
            }else if ([tableColumn.identifier isEqualToString:@"Date"]) {
                return [DateHelper dateFrom2001ToString:contactModel.lastcalldate withMode:2];//[NSNumber numberWithInteger:contactModel.selectedCount];
            }else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
                return [NSNumber numberWithInt:contactModel.checkState];
            }
        }
    }else if (tableView.tag == 2){
        if (_sonAry != nil && _sonAry.count > row) {
            IMBCallHistoryDataEntity *contactModel = [_sonAry objectAtIndex:row];
            if ([tableColumn.identifier isEqualToString:@"Type"]) {
                if (contactModel.callType == CallingCall) {
                    return CustomLocalizedString(@"callhistory_id_1", nil);
                }else if (contactModel.callType == CallingUnkonw){
                    return CustomLocalizedString(@"callhistory_id_1", nil);
                }else if (contactModel.callType == CallingMissed){
                    return CustomLocalizedString(@"callhistory_id_1", nil);
                }else if (contactModel.callType == CallingReceive){
                    return CustomLocalizedString(@"callhistory_id_1", nil);
                }else if (contactModel.callType == CallingCanceled){
                    return CustomLocalizedString(@"callhistory_id_1", nil);
                }else if (contactModel.callType == CallingMissedFacetime){
                    return CustomLocalizedString(@"Common_id_10", nil);
                }else if (contactModel.callType == CallingCallFacetime){
                    return CustomLocalizedString(@"Common_id_10", nil);
                }else if (contactModel.callType == CallingReceiveFacetime){
                    return CustomLocalizedString(@"Common_id_10", nil);
                }else if (contactModel.callType == CallingCanceledFacetime){
                    return CustomLocalizedString(@"Common_id_10", nil);
                }
            }else if ([tableColumn.identifier isEqualToString:@"Phone"]) {
                return contactModel.address;
            }else if ([tableColumn.identifier isEqualToString:@"Date"]){
                return contactModel.dateStr;
            }else if ([tableColumn.identifier isEqualToString:@"Duration"]){
                return [DateHelper getTimeAutoShowHourString:contactModel.duration ];
            }else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
                return[NSNumber numberWithBool:contactModel.checkState];
            }
        }
    }
    return @"";
}

- (void)tableView:(NSTableView *)tableView row:(NSInteger)index{
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (tableView.tag == 1) {
 
        IMBCallContactModel *bookMark = [disAry objectAtIndex:index];
        if (bookMark.checkState == SemiChecked) {
            bookMark.checkState = Check;
        }else{
            bookMark.checkState = !bookMark.checkState;
        }
        int seleCount = 0;
        int semiCount = 0;
        for (IMBCallContactModel *contactModel in disAry) {
            if (contactModel.checkState == Check) {
                seleCount ++;
            }else if (contactModel.checkState == SemiChecked){
                semiCount ++;
            }
        }
        
        if (seleCount == disAry.count) {
            [_itemTableView changeHeaderCheckState:Check];
        }else if (seleCount == 0 && semiCount == 0){
            [_itemTableView changeHeaderCheckState:UnChecked];
        }else{
            [_itemTableView changeHeaderCheckState:SemiChecked];
        }
        
        if (bookMark.checkState == Check) {
            for (IMBCallHistoryDataEntity *entity in bookMark.callHistoryList) {
                entity.checkState = Check;
            }
            bookMark.selectedCount = bookMark.callHistoryCount;
            if (_itemTableView.selectedRow == index) {
                [_rightTableView changeHeaderCheckState:Check];
            }
            
        }else{
            for (IMBCallHistoryDataEntity *entity in bookMark.callHistoryList) {
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
   
        IMBCallHistoryDataEntity *safariEntity = [_sonAry objectAtIndex:index];
        safariEntity.checkState = !safariEntity.checkState;
        int checkCount = 0;
        for (IMBCallHistoryDataEntity *historydata in _sonAry) {
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
        [_rightTableView selectRowIndexes:set byExtendingSelection:NO];
    }
    int selecdCount = 0;
    int allselecdCount = 0;
    for (IMBCallContactModel *bookMark in disAry) {
        if (bookMark.checkState == Check) {
            selecdCount ++;
        }
        for (IMBCallHistoryDataEntity *entity in bookMark.callHistoryList) {
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
                
                if (contactModel.callType == CallingCall) {
       
                    [imageCell setImage:[StringHelper imageNamed:@"callOut"]];
                    [imageCell setImageName:@"callOut"];
                }else if (contactModel.callType == CallingUnkonw){
                        [imageCell setImage:[StringHelper imageNamed:@"callIn"]];
                        [imageCell setImageName:@"callIn"];
                    //                    return @"CallingUnkonw";
                }else if (contactModel.callType == CallingMissed){
 
                        [imageCell setImage:[StringHelper imageNamed:@"callOut"]];
                        [imageCell setImageName:@"callOut"];
                }else if (contactModel.callType == CallingReceive){
       
                        [imageCell setImage:[StringHelper imageNamed:@"callIn"]];
                        [imageCell setImageName:@"callIn"];
                }else if (contactModel.callType == CallingCanceled){
          
                        [imageCell setImage:[StringHelper imageNamed:@"callOut"]];
                        [imageCell setImageName:@"callOut"];
                }else if (contactModel.callType == CallingMissedFacetime){
        
                        [imageCell setImage:[StringHelper imageNamed:@"callOut"]];
                        [imageCell setImageName:@"callOut"];
                }else if (contactModel.callType == CallingCallFacetime){
        
                        [imageCell setImage:[StringHelper imageNamed:@"callOut"]];
           [imageCell setImageName:@"callOut"];
                }else if (contactModel.callType == CallingReceiveFacetime){
            
                        [imageCell setImage:[StringHelper imageNamed:@"callOut"]];
                [imageCell setImageName:@"callOut"];
                }else if (contactModel.callType == CallingCanceledFacetime){
                        [imageCell setImage:[StringHelper imageNamed:@"callOut"]];
                    [imageCell setImageName:@"callOut"];
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
        
//        [_itemTableView selectRowIndexes:set byExtendingSelection:NO];
    }
    
//    [_itemTableView reloadData];
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
        return;
    }
    if (atableView.tag == 1) {

        if (row < 0||_dataSourceArray.count <=row) {
            return;
        }
    
        IMBCallContactModel *bookMark = [_dataSourceArray objectAtIndex:row];
        int allselecdCount =0;
        for (IMBCallHistoryDataEntity *entity in bookMark.callHistoryList) {
            if (entity.checkState == Check) {
                allselecdCount ++;
            }
        }
        if (allselecdCount == bookMark.callHistoryList.count) {
            [_rightTableView  changeHeaderCheckState:Check];
        }else if (allselecdCount ==0){
            [_rightTableView  changeHeaderCheckState:UnChecked];
        }else{
            [_rightTableView  changeHeaderCheckState:SemiChecked];
        }
        
        [self changeSonTableViewData:atableView];

    }else{
        
        NSInteger count = [_itemTableView selectedRow];
         IMBCallContactModel *bookMark = [_dataSourceArray objectAtIndex:count];
        IMBCallHistoryDataEntity *callhistory = [_sonAry objectAtIndex:row];
        callhistory.checkState = Check;
        int allselecdCount = 0;
        for (IMBCallHistoryDataEntity *entity in _sonAry) {
            if (entity.checkState == Check) {
                allselecdCount ++;
            }
        }
        if (allselecdCount == _sonAry.count) {
            [_rightTableView  changeHeaderCheckState:Check];
            bookMark.checkState = Check;
        }else if (allselecdCount ==0){
            [_rightTableView  changeHeaderCheckState:UnChecked];
            bookMark.checkState = UnChecked;
        }else{
            [_rightTableView  changeHeaderCheckState:SemiChecked];
            bookMark.checkState = SemiChecked;
        }
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
            if (_sonAry != nil) {
                [_sonAry release];
                _sonAry = nil;
            }
            //                _sonAry = [[NSMutableArray alloc]init];
            IMBCallContactModel *model = [disAry objectAtIndex:tagRow];
            _sonAry = [model.callHistoryList retain];
        }else {
            _sonAry = nil;
        }
 
    [_rightTableView reloadData];
    [_itemTableView reloadData];
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
    if (tableView.tag == 1) {
            if (disAry != nil && disAry.count > row) {
                if (_sonAry != nil) {
                    [_sonAry release];
                    _sonAry = nil;
                }
//                _sonAry = [[NSMutableArray alloc]init];
                IMBCallContactModel *model = [disAry objectAtIndex:row];
                _sonAry = [model.callHistoryList retain];
            }else {
                _sonAry = nil;
            }
    }
    [_rightTableView reloadData];
    [_itemTableView reloadData];
}

-(void)setselectState:(CheckStateEnum)state WithTableView:(NSTableView *)tableView{
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (tableView.tag == 1) {
        for (IMBCallContactModel *contactModel in disAry) {
            contactModel.checkState = state;
            for (IMBCallHistoryDataEntity *historydata in contactModel.callHistoryList) {
                historydata.checkState = state;
            }
        }

        [_rightTableView changeHeaderCheckState:state];
    }else{
        IMBCallContactModel *contactModel = [disAry objectAtIndex:[_itemTableView selectedRow]];
        contactModel.checkState = state;
        for (IMBCallHistoryDataEntity *historydata in _sonAry) {
            historydata.checkState = state;
        }
        int checkCount = 0;
        int semiCount = 0;
        for (IMBCallContactModel *contactModel in disAry) {
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
            IMBCallHistoryDataEntity *bookMark= [_sonAry objectAtIndex:i];
            if (bookMark.checkState == NSOnState) {
                [set addIndex:i];
            }
        }
        if (set.count == 0){
    
        }else{
//            [_rightTableView selectRowIndexes:set byExtendingSelection:NO];
        }
        
    }
    [_itemTableView reloadData];
    [_rightTableView reloadData];
}

- (IBAction)sortRightPopuBtn:(id)sender {
    NSMenuItem *item = [_sortRightPopuBtn selectedItem];
    NSInteger tag = [_sortRightPopuBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
        if (menuItem.tag != 1 || menuItem.tag != 2) {
            [menuItem setState:NSOffState];
        }
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
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"contactName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_dataSourceArray sortUsingDescriptors:sortDescriptors];
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
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastCallStrForm2001" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_dataSourceArray sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        str1 = CustomLocalizedString(@"SortBy_Date", nil);
    }else if (item.tag == 3){
        _isAscending = YES;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = nil;
        if (_isSortByName) {
            for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
                if (menuItem.tag == 1) {
                    [menuItem setState:NSOnState];
                }
            }
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"contactName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
            str1 = CustomLocalizedString(@"SortBy_Name", nil);
        }else {
            for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
                if (menuItem.tag == 2) {
                    [menuItem setState:NSOnState];
                }
            }
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastCallStrForm2001" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
            str1 = CustomLocalizedString(@"SortBy_Date", nil);
        }
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_dataSourceArray sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        //        [_topPopuBtn setTitle:[_topPopuBtn titleOfSelectedItem]];
    }else if (item.tag == 4){
        _isAscending = NO;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = nil;
        if (_isSortByName) {
            for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
                if (menuItem.tag == 1) {
                    [menuItem setState:NSOnState];
                }
            }
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"contactName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
            str1 = CustomLocalizedString(@"SortBy_Name", nil);
        }else {
            for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
                if (menuItem.tag == 2) {
                    [menuItem setState:NSOnState];
                }
            }
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastCallStrForm2001" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
            str1 = CustomLocalizedString(@"SortBy_Date", nil);
        }
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_dataSourceArray sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        //        //
    }
//    NSString *str1 = CustomLocalizedString(@"SortBy_Name", nil);
    [_sortRightPopuBtn setTitle:str1];
    [_sortRightPopuBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    
    NSRect rect = [TempHelper calcuTextBounds:str1 fontSize:12];
    [_sortRightPopuBtn setFrame:NSMakeRect(_topWhiteView.frame.size.width - 30 - rect.size.width-12,_sortRightPopuBtn.frame.origin.y , rect.size.width +30, _sortRightPopuBtn.frame.size.height)];
    [_sortRightPopuBtn setTitle:str1];
    [self changeSonTableViewData:_itemTableView];
    
    for (IMBCallContactModel *model in _dataSourceArray) {
        NSLog(@"===name:%@=====lastTime:%@====",model.contactName,model.lastCallStrForm2001);
    }
}
- (IBAction)sortSelectedPopuBtn:(id)sender {
    NSMenuItem *item = [_selectSortBtn selectedItem];
    NSInteger tag = [_selectSortBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _selectSortBtn.itemArray) {
        [menuItem setState:NSOffState];
    }
    
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray =  _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (tag == 1) {
        for (IMBCallContactModel *note in displayArray) {
            note.checkState = Check;
            //            IMBCallContactModel *model = [_dataSourceArray objectAtIndex:row];
            //            _sonAry = [model.callHistoryList retain];
            for (IMBCallHistoryDataEntity *dataEntity in note.callHistoryList) {
                dataEntity.checkState = Check;
            }
        }
        [_rightTableView changeHeaderCheckState:Check];
        //        [_sortRightPopuBtn setTitle:CustomLocalizedString(@"showMenu_id_1", nil)];
    }else if (tag == 2){
        for (IMBCallContactModel *note in displayArray) {
            note.checkState = UnChecked;
//            IMBCallContactModel *model = [_dataSourceArray objectAtIndex:row];
//            _sonAry = [model.callHistoryList retain];
            for (IMBCallHistoryDataEntity *dataEntity in note.callHistoryList) {
                dataEntity.checkState = UnChecked;
            }
        }
     
        [_rightTableView changeHeaderCheckState:UnChecked];
        //        [_sortRightPopuBtn setTitle:CustomLocalizedString(@"showMenu_id_2", nil)];
    }else if (tag == 3){
        
        
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
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contactName CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
        if (_researchdataSourceArray.count <=0) {
            _sonAry = nil;
        }
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
    }
    [self changeSonTableViewrow:0];;
    [_itemTableView reloadData];
    [_rightTableView reloadData];
}
@end
