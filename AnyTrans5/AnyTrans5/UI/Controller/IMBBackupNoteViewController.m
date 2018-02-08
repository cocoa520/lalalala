//
//  IMBBackupNoteViewController.m
//  AnyTrans
//
//  Created by long on 16-7-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBackupNoteViewController.h"
#import "StringHelper.h"
#import "IMBNoteSqliteManager.h"
#import "DateHelper.h"
#import "IMBCheckBoxTableColumnCell.h"
#import "IMBCustomHeaderCell.h"
#import "IMBCenterTextFieldCell.h"
#import "IMBCustomCornerView.h"
#import "IMBNoteDataEntity.h"
#import "IMBSMSChatDataEntity.h"
#import "IMBContactSqliteManager.h"
#import "IMBNotificationDefine.h"
#import "IMBCheckBoxCell.h"
@interface IMBBackupNoteViewController ()

@end

@implementation IMBBackupNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithProductVersion:(SimpleNode *)node withDelegate:(id)delegate WithIMBBackupDecryptAbove4:(IMBBackupDecryptAbove4*)abve4{
    if ([super initWithNibName:@"IMBBackupNoteViewController" bundle:nil]) {
        _delegate = delegate;
        _category = Category_Notes;
        _decryptAbove4 = abve4;
        _isiCloud = NO;
        _node = node;
    }
    return self;
}

-(id)initiCloudWithiCloudBackUp:(IMBiCloudBackup *)icloudBackup WithDelegate:(id)delegate {
    if ([super initWithNibName:@"IMBBackupNoteViewController" bundle:nil]) {
        _delegate = delegate;
        _category = Category_Notes;
        _iCloudBackUp= icloudBackup;
        _isiCloud = YES;
        _isiCloudView = YES;
    }
    return self;
}

-(void)dealloc{
 
    [super dealloc];
    if (_noteEditView != nil) {
        [_noteEditView release];
        _noteEditView = nil;
    }
}

-(void)loadData:(NSMutableArray *)ary{
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_60", nil)];
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [_noDataTitle setAttributedStringValue:as];
        [_noDataTitle setSelectable:NO];
        [as release], as = nil;
    });

}

-(void)awakeFromNib{
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_nodataImageVIew setImage:[StringHelper imageNamed:@"noData_note"]];
    _isloadingPopBtn = YES;
    [super awakeFromNib];
    _isAscending = YES;
    [_loadingAnimationView startAnimation];
    [_noteBox setContentView:_loadingView];
    [_topWhiteView setIsBommt:YES];
    [_topWhiteView setBackgroundColor:[NSColor clearColor]];
    [_itemTableView setGridColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    _itemTableView.allowsMultipleSelection = NO;
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    //    [_tabScrollView setHastopBorder:NO leftBorder:NO BottomBorder:NO rightBorder:YES];
    _noteEditView = [[IMBBackupNoteEditView alloc] initWithFrame:NSMakeRect(0, 0, noteScrollView.frame.size.width -15, noteScrollView.frame.size.height - 5)];
    [_noteEditView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin|NSViewWidthSizable|NSViewHeightSizable];
    [noteScrollView setDocumentView:_noteEditView];
    if (_dataSourceArray!= nil &&_dataSourceArray.count >0) {
        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]byExtendingSelection:NO];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        IMBNoteSqliteManager *noteManager = nil;
        if (_isiCloud) {
            noteManager = [[IMBNoteSqliteManager alloc]initWithiCloudBackup:_iCloudBackUp withType:_iCloudBackUp.iOSVersion];
        }else{
            noteManager = [[IMBNoteSqliteManager alloc] initWithAMDevice:nil backupfilePath:_node.backupPath withDBType:_node.productVersion WithisEncrypted:_node.isEncrypt withBackUpDecrypt:_decryptAbove4];
        }
        [noteManager querySqliteDBContent];
        dispatch_async(dispatch_get_main_queue(), ^{
            _dataSourceArray = [noteManager.dataAry retain];
            if (_dataSourceArray != nil && _dataSourceArray.count >0) {
                [_noteBox setContentView:_dataView];
                [self tableViewchangeCellData:0];
                [_itemTableView reloadData];
            }else{
                [_noteBox setContentView:_noDataView];
                NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_60", nil)];
                NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
                [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
                [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
                [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
                [_noDataTitle setAttributedStringValue:as];
                [_noDataTitle setSelectable:NO];
                [as release], as = nil;

            }
            [noteManager release];
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        });
    });
    [(IMBWhiteView *) self.view setIsGradientColorNOCornerPart3:YES];
}

- (void)changeSkin:(NSNotification *)notification
{
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [_nodataImageVIew setImage:[StringHelper imageNamed:@"noData_note"]];
    [_itemTableView setGridColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_60", nil)];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_noDataTitle setAttributedStringValue:as];
    [_noDataTitle setSelectable:NO];
    [as release], as = nil;
    [_topWhiteView setNeedsDisplay:YES];
    [_sortRightPopuBtn setNeedsDisplay:YES];
    [_selectSortBtn setNeedsDisplay:YES];
    [_loadingAnimationView setNeedsDisplay:YES];
    [(IMBWhiteView *) self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}


#pragma mark - NSTableView datasource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry != nil && disAry.count >0) {
        return [disAry count];
    }
    return 0;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 60;
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry != nil&&disAry.count >0) {
        IMBNoteModelEntity *note = nil;
        
        note = [disAry objectAtIndex:row];
        
        if ([[tableColumn identifier] isEqualToString:@"Name"]) {
            NSString *noteTitleString = note.title;
            NSCharacterSet *set = [NSCharacterSet newlineCharacterSet];
            if ([noteTitleString rangeOfCharacterFromSet:set].location != NSNotFound) {
                NSMutableString *string = [[note.title mutableCopy] autorelease];
                NSRange range = [string rangeOfCharacterFromSet:set];
                string = [[[string substringToIndex:range.location] mutableCopy] autorelease];
                [string appendString:@"..."];
                noteTitleString = string;
            }
            NSString *str = nil;
            if (note.modifyDate != 0) {
                str = [DateHelper dateFrom2001ToString:note.modifyDate withMode:1];
            }else {
                str = [DateHelper dateFrom2001ToString:note.creatDate withMode:1];
            }
    
            if (noteTitleString.length>0) {
                NSString *titleStr = [noteTitleString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                NSString *titleStr1 = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                return [NSString stringWithFormat:@"%@\n%@",titleStr,titleStr1];
            }else
            {
                NSString *titleStr = [noteTitleString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                return titleStr;
            }
        }
        if ([[tableColumn identifier] isEqualToString:@"Time"]) {
            NSString *str = [DateHelper dateFrom2001ToString:note.creatDate withMode:1];
            return str;
        }else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
            return [NSNumber numberWithBool:note.checkState];
        }

    }
    return nil;
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([[tableColumn identifier] isEqualToString:@"CheckCol"]) {
        IMBCheckBoxCell *boxCell = (IMBCheckBoxCell *)cell;
        boxCell.outlineCheck = YES;
    }
}

- (void)tableView:(NSTableView *)tableView row:(NSInteger)index{
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <=0 ) {
        return;
    }
    if (disAry != nil&&disAry.count >0) {
        IMBNoteModelEntity *contactData = [disAry objectAtIndex:index];
        contactData.checkState = !contactData.checkState;
    }
    int checkCount = 0;
    for (IMBNoteModelEntity *entity in disAry) {
        if (entity.checkState == Check) {
            checkCount ++;
        }
    }
    if (checkCount == disAry.count) {
        [_itemTableView changeHeaderCheckState:Check];
    }else if (checkCount == 0){
        [_itemTableView changeHeaderCheckState:UnChecked];
    }else{
        [_itemTableView changeHeaderCheckState:SemiChecked];
    }
    
    [_itemTableView  reloadData];
//
}

-(void)setAllselectState:(CheckStateEnum)sender{
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <=0 ) {
        return;
    }
    if (sender == Check||sender == SemiChecked ) {
        for (IMBNoteModelEntity *entity in disAry) {
            entity.checkState = Check;
        }
    }else if ( sender == UnChecked){
        for (IMBNoteModelEntity *entity in disAry) {
            entity.checkState = UnChecked;
        }
    }
    [_itemTableView  reloadData];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <=0 ) {
        return;
    }
    NSInteger row = [_itemTableView selectedRow];
    if (disAry!= nil&&disAry.count >0) {
        [self tableViewchangeCellData:row];
    }
}

-(void)tableViewchangeCellData:(NSInteger)row{
    if(row == NSNotFound || row == -1){
//        if (_dataSourceArray.count > 0) {
//            [_noteEditView setHidden:NO];
//            [_itemTableView deselectAll:nil];
//            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:YES];
//        }
//        else{
//            [_noteEditView setHidden:YES];
//        }
        return;
    }
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <=0 ) {
        return;
    }
    if (_noteEditView.isHidden) {
        [_noteEditView setHidden:NO];
    }
    NSIndexSet *set = [_itemTableView selectedRowIndexes];
    
    IMBNoteModelEntity *note = nil;
    if (row == -1 && [disAry count]>0&&[set count]==0)
    {
        note = nil;
    }else if(row < [disAry count])
    {
        note = [disAry objectAtIndex:row];
    }
    if (_notesEntity != nil) {
        [_notesEntity release];
        _notesEntity = nil;
    }
    _notesEntity = [note retain];
    IMBNoteModelEntity *note1 = [disAry objectAtIndex:row];
    if (note.modifyDateStr.length != 0) {
        [_noteEditView setTime:note.modifyDateStr];
    }else {
        [_noteEditView setTime:note.creatDateStr];
    }
    if ([StringHelper stringIsNilOrEmpty:note.content]) {
        [_noteEditView setContent:note.title];
    }else{
        [_noteEditView setContent:note.content];
    }
    
    NSArray *views = [NSArray arrayWithArray:_noteEditView.subviews];
    for (NSView *view in views) {
        if ([view isKindOfClass:[NSImageView class]]) {
            [view removeFromSuperview];
        }
    }
    _noteEditView.noteHigh = 0;
    if (note1.attachmentAry.count > 0) {
        for (IMBNoteAttachmentEntity  *attachmentData in note1.attachmentAry) {
            if (attachmentData.attachDetailList.count > 0) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                long long curFileSize = 0;
                for (IMBAttachDetailEntity *attach in attachmentData.attachDetailList) {
                    if (curFileSize == 0) {
                        [array addObject:attach];
                        curFileSize = attach.fileSize;
                    }else if (attach.fileSize < curFileSize) {
                        [array removeAllObjects];
                        [array addObject:attach];
                        curFileSize = attach.fileSize;
                    }
                }
                for (IMBAttachDetailEntity *attachDetail in array) {
                    [_noteEditView addAttachment:attachDetail.backUpFilePath];
                }
                [array release];
            }
        }
    }
}


- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
    
    return NO;
}
- (IBAction)sortRightPopuBtn:(id)sender {
    NSMenuItem *item = [_sortRightPopuBtn selectedItem];
    NSInteger tag = [_sortRightPopuBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
        if (menuItem.tag != 1) {
            [menuItem setState:NSOffState];
        }
    }
    
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    
    if (item.tag == 1) {
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
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [disAry sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        [_sortRightPopuBtn setTitle:[_sortRightPopuBtn titleOfSelectedItem]];
    }else if (tag == 2){
        
    }else if (item.tag == 3){
        _isAscending = YES;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [disAry sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        //        [_topPopuBtn setTitle:[_topPopuBtn titleOfSelectedItem]];
    }else if (item.tag == 4){
        _isAscending = NO;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [disAry sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        //        //
    }
    NSString *str1 = CustomLocalizedString(@"SortBy_Name", nil);
    [_sortRightPopuBtn setTitle:str1];
    [_sortRightPopuBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    
    NSRect rect = [TempHelper calcuTextBounds:str1 fontSize:12];
    [_sortRightPopuBtn setFrame:NSMakeRect(_topWhiteView.frame.size.width - 30 - rect.size.width-12,_sortRightPopuBtn.frame.origin.y , rect.size.width +30, _sortRightPopuBtn.frame.size.height)];
    [_sortRightPopuBtn setTitle:str1];
    NSInteger row = [_itemTableView selectedRow];
   [self tableViewchangeCellData:row];
}
- (IBAction)sortSelectedPopuBtn:(id)sender {
    NSMenuItem *item = [_selectSortBtn selectedItem];
    NSInteger tag = [_selectSortBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _selectSortBtn.itemArray) {
        [menuItem setState:NSOffState];
    }
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }

    if (tag == 1) {
        for (IMBNoteModelEntity *note in disAry) {
            note.checkState = Check;
        }

    //        [_sortRightPopuBtn setTitle:CustomLocalizedString(@"showMenu_id_1", nil)];
    }else if (tag == 2){
        for (IMBNoteModelEntity *note in disAry) {
            note.checkState = UnChecked;
        }
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
}

//- (void)reloadTableView{
//    [_itemTableView reloadData];
//}

-(void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
        if (_researchdataSourceArray.count <=0) {
            IMBNoteModelEntity *note = nil;
            if (_notesEntity != nil) {
                [_notesEntity release];
                _notesEntity = nil;
            }
            _notesEntity = [note retain];
            NSString *createDate = @"";
            NSString *content = @"";
            [_noteEditView setTime:createDate];
            [_noteEditView setContent:content];
            for (NSView *view in noteScrollView.subviews) {
                if ([view isKindOfClass:[NSScroller class]]) {
                    NSScroller *scroller = (NSScroller *)view;
                    [scroller setNeedsDisplay];
                }
            }
        }else {
            NSInteger selectedRow = [_itemTableView selectedRow];
            if (selectedRow == 0) {
                [self tableViewchangeCellData:0];
            }else {
                [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
            }
        }
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
        NSInteger selectedRow = [_itemTableView selectedRow];
        if (selectedRow == 0) {
            [self tableViewchangeCellData:0];
        }else {
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }
        
    }
    [_itemTableView reloadData];
}

@end
