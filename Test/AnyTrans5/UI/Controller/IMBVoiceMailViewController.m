//
//  IMBVoiceMailViewController.m
//  AnyTrans
//
//  Created by long on 16-7-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBVoiceMailViewController.h"
#import "IMBVoiceMailEntity.h"
#import "DateHelper.h"
#import "IMBVoiceMailSqliteManager.h"
//#import "IMBColorDefine.h"
#import "IMBCheckBoxCell.h"
#import "IMBCustomHeaderCell.h"
#import "IMBCenterTextFieldCell.h"
#import "IMBNotificationDefine.h"
#import "IMBAnimation.h"
#import "IMBImageAndTextCell.h"
#import "IMBDeviceMainPageViewController.h"
@implementation IMBVoiceMailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    if (self = [super initWithIpod:ipod withCategoryNodesEnum:category withDelegate:delegate]) {
        _isBackup = NO;
        _dataSourceArray = [[_information voicemailArray] retain];
    }
    return self;
}

- (id)initWithProductVersion:(SimpleNode *)node withDelegate:(id)delegate WithIMBBackupDecryptAbove4:(IMBBackupDecryptAbove4 *)abve4 {
    if ([super initWithNibName:@"IMBVoiceMailViewController" bundle:nil]) {
        _category = Category_Voicemail;
        _delegate = delegate;
        _isBackup = YES;
        _node = node;
        _decryptAbove4 = abve4;
    }
    return self;
}

- (id)initiCloudWithiCloudBackUp:(IMBiCloudBackup *)icloudBackup WithDelegate:(id)delegate{
    if ([super initWithNibName:@"IMBVoiceMailViewController" bundle:nil]) {
        _category = Category_Voicemail;
        _delegate = delegate;
        _isiCloud = YES;
        _isBackup = YES;
        _iCloudBackUp = icloudBackup;
        _isiCloudView = YES;
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        [self configNoDataView];
        NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_27", nil)];
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [_backUpNoDataTextStr setAttributedStringValue:as];
        [_backUpNoDataTextStr setSelectable:NO];
        [as release], as = nil;
        if (!_isBackup) {
            [self configRefreshView];
        }
    });
}

-(void)awakeFromNib{
    _isloadingPopBtn = YES;
    [super awakeFromNib];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_itemTableView setBackgroundColor:[NSColor clearColor]];
    _itemTableView.allowsMultipleSelection = NO;
    [_middleLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_rightTableView setDelegate:self];
    [_rightTableView setDataSource:self];
    [_rightTableView setListener:self];
    [_rightTableView setBackgroundColor:[NSColor clearColor]];
    [_rightTableView.checkBoxCell.checkButton setHidden:YES];
    [_topWhiteView setIsBommt:YES];
    [_topWhiteView setBackgroundColor:[NSColor clearColor]];
    
    _nc = [NSNotificationCenter defaultCenter];
    [_nc addObserver:self selector:@selector(backupCompleteReload:) name:NOTIFY_BACKUP_COMPELTE object:nil];
    [_nc addObserver:self selector:@selector(backupErrorReload:) name:NOTIFY_BACKUP_ERROE object:nil];
    if (!_isBackup) {
        if (_dataSourceArray.count == 0) {
            [_mainBox setContentView: _noDataView];
        }else {
            [_mainBox setContentView:_containTableView];
        }
        [self configRefreshView];
        [_nc addObserver:self selector:@selector(hideRefreshView) name:NOTITY_HIDE_REFRESHVIEW object:nil];
    }else{
        [_loadingAnimationView startAnimation];
        [_mainBox setContentView:_loadingView];
        [self.view setFrame:NSMakeRect(0, 0, 859, 534)];
        [_mainBox setFrame:NSMakeRect(0, 0, 859, 534)];
        [_containTableView setFrame:NSMakeRect(0, 0, 859, 534)];
        [_noDataView setFrame:NSMakeRect(0, 0, 859, 534)];
        [_noDataTextScroll setFrameOrigin:NSMakePoint(_noDataTextScroll.frame.origin.x - 100, _noDataTextScroll.frame.origin.y)];
        [_noDataImageView setFrameOrigin:NSMakePoint(_noDataImageView.frame.origin.x - 100, _noDataImageView.frame.origin.y)];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            IMBVoiceMailSqliteManager *bookMarkManager = nil;
            if (_isiCloud) {
                bookMarkManager = [[IMBVoiceMailSqliteManager alloc] initWithiCloudBackup:_iCloudBackUp withType:_iCloudBackUp.iOSVersion];
            }else{
                bookMarkManager = [[IMBVoiceMailSqliteManager alloc] initWithAMDevice:nil backupfilePath:_node.backupPath withDBType:_node.productVersion WithisEncrypted:_node.isEncrypt withBackUpDecrypt:_decryptAbove4];
            }
            
            [bookMarkManager querySqliteDBContent] ;
            dispatch_async(dispatch_get_main_queue(), ^{
                _dataSourceArray = [bookMarkManager.dataAry retain];
                if (_dataSourceArray.count == 0) {
                    [_mainBox setContentView:_backUpNoDataView];
                    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_27", nil)];
                    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
                    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
                    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
                    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
                    [_backUpNoDataTextStr setAttributedStringValue:as];
                    [_backUpNoDataTextStr setSelectable:NO];
                    [as release], as = nil;
                }else {
                    [_mainBox setContentView:_containTableView];
                }
                [_itemTableView reloadData];
            });
        });
    }
    if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
        [_mainBox setContentView:_containTableView];
        NSInteger row = [_itemTableView selectedRow];
        [_itemTableView deselectRow:row];
    }else{
        [self configNoDataView];
        [_mainBox setContentView:_noDataView];
    }
    
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
}

- (void)changeSkin:(NSNotification *)notification
{
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [self doChangeLanguage:nil];
    [_loadingAnimationView setNeedsDisplay:YES];
    [_middleLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [self configNoDataView];
    [self configRefreshView];
    [_topWhiteView setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_backupnodataImageView setImage:[StringHelper imageNamed:@"noData_VioceMail"]];
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_VioceMail"]];
    [_textView setDelegate:self];
    [_textView setSelectable:NO];
    NSString *promptStr = @"";
    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_27", nil)];
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_textView setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];

    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_textView textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
}

#pragma mark - tablewView - datasource
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 38;
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView == _itemTableView) {
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
    }else if (tableView == _rightTableView){
        if (_sonAry.count <= 0) {
            return 0;
        }else{
            return _sonAry.count;
        }
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == _itemTableView) {
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
            IMBVoiceMailAccountEntity *accountModel = [disAry objectAtIndex:row];
            if ([tableColumn.identifier isEqualToString:@"Name"]) {
                
                return accountModel.contactName;
            } else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
                return [NSNumber numberWithInt:accountModel.checkState];
            } else if ([tableColumn.identifier isEqualToString:@"Count"]) {
                if (accountModel.subArray.count > 0) {
                    return [NSNumber numberWithInt:(int)accountModel.subArray.count];
                } else {
                    return @"--";
                }
                
            }
        }
    }else if (tableView == _rightTableView){
        if (_sonAry != nil && _sonAry.count > row) {
            IMBVoiceMailEntity *trackData = [_sonAry objectAtIndex:row];
            if ([tableColumn.identifier isEqualToString:@"Name"]) {
                return trackData.sender;
            }else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
                return [NSNumber numberWithInt:trackData.checkState];
            }else if ([tableColumn.identifier isEqualToString:@"Date"]){
                NSLog(@"datestr:%@",trackData.dateStr);
                return trackData.dateStr;
            }else if ([tableColumn.identifier isEqualToString:@"Duration"]){
                return [DateHelper getTimeAutoShowHourString:trackData.duration * 1000];
            }else if ([@"State" isEqualToString:tableColumn.identifier]) {
                return trackData.stateStr;
            }
        }
    }
    return @"";
}


-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
        if (tableView == _itemTableView) {
            if ([[tableColumn identifier] isEqualToString:@"CheckCol"]) {
                IMBCheckBoxCell *boxCell = (IMBCheckBoxCell *)cell;
                boxCell.outlineCheck = YES;
            } else if ([[tableColumn identifier] isEqualToString:@"Count"]) {
                IMBCenterTextFieldCell *textCell = (IMBCenterTextFieldCell *)cell;
                textCell.isRighVale = YES;
            }
        }
}

#pragma mark - NSTableViewdelegate
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
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
            IMBVoiceMailAccountEntity *contactEntity = [disAry objectAtIndex:row];
            _sonAry = contactEntity.subArray;
        }else {
            _sonAry = nil;
        }
    }
    [_rightTableView reloadData];
    [_itemTableView reloadData];
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    if (_sonAry.count <= 0) {
        return;
    }
    id cell = [tableColumn headerCell];
    NSString *identify = [tableColumn identifier];
    NSArray *array = [tableView tableColumns];
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
	if ( [@"Name" isEqualToString:identify] || [@"Date" isEqualToString:identify] || [@"Duration" isEqualToString:identify] || [@"State" isEqualToString:identify]) {
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
    if ([key isEqualToString:@"Name"]) {
        key = @"sender";
    } else if ([key isEqualToString:@"Date"]) {
        key = @"dateStr";
    } else if ([key isEqualToString:@"Duration"]) {
        key = @"duration";
    } else if ([key isEqualToString:@"State"]) {
        key = @"stateStr";
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    [_rightTableView reloadData];
    
    [sortDescriptor release];
    [sortDescriptors release];
}

-(void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    
    if (tableView == _itemTableView) {
        
        IMBVoiceMailAccountEntity *accountEntity = [disAry objectAtIndex:index];
        if (accountEntity.checkState == SemiChecked) {
            accountEntity.checkState = Check;
        }else{
            accountEntity.checkState = !accountEntity.checkState;
        }
        int seleCount = 0;
        int semiCount = 0;
        for (IMBVoiceMailAccountEntity *contactModel in _dataSourceArray) {
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
        
        if (accountEntity.checkState == Check) {
            for (IMBADCallHistoryEntity *entity in accountEntity.subArray) {
                entity.checkState = Check;
            }
            accountEntity.selectedCount = accountEntity.totalCount;
            if (_itemTableView.selectedRow == index) {
                [_rightTableView changeHeaderCheckState:Check];
            }
        }else{
            for (IMBVoiceMailEntity *entity in accountEntity.subArray) {
                entity.checkState = UnChecked;
            }
            accountEntity.selectedCount = 0;
            if (_itemTableView.selectedRow == index) {
                [_rightTableView changeHeaderCheckState:UnChecked];
            }
        }
        [_itemTableView reloadData];
        [_rightTableView reloadData];
    }else if (tableView == _rightTableView){

        IMBVoiceMailEntity *voiceEntity = [_sonAry objectAtIndex:index];
        voiceEntity.checkState = !voiceEntity.checkState;
        int checkCount = 0;
        for (IMBVoiceMailEntity *historydata in _sonAry) {
            if (historydata.checkState == Check) {
                checkCount ++;
            }
        }
        IMBVoiceMailAccountEntity *accountEntity = [disAry objectAtIndex:_itemTableView.selectedRow];
        if (checkCount == _sonAry.count) {
            accountEntity.checkState = Check;
            [_rightTableView changeHeaderCheckState:Check];
        }else if (checkCount == 0){
            accountEntity.checkState = UnChecked;
            [_rightTableView changeHeaderCheckState:UnChecked];
        }else{
            accountEntity.checkState = SemiChecked;
            [_rightTableView changeHeaderCheckState:SemiChecked];
        }
        accountEntity.selectedCount = checkCount;
        
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (int i=0;i<[_sonAry count]; i++) {
            IMBVoiceMailEntity *voice= [_sonAry objectAtIndex:i];
            if (voice.checkState == NSOnState) {
                [set addIndex:i];
            }
        }
    }
    int selecdCount = 0;
    int allselecdCount = 0;
    for (IMBVoiceMailAccountEntity *accountEntity in disAry) {
        if (accountEntity.checkState == Check) {
            selecdCount ++;
        }
        for (IMBVoiceMailEntity *entity in accountEntity.subArray) {
            if (entity.checkState == Check) {
                allselecdCount ++;
            }
        }
    }
    [_itemTableView reloadData];
    [_rightTableView reloadData];}

-(void)setAllselectState:(CheckStateEnum)sender {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return;
    }
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    for (int i=0;i<[disAry count]; i++) {
        IMBVoiceMailAccountEntity *entity = [disAry objectAtIndex:i];
        [entity setCheckState:sender];
        if (entity.checkState == NSOnState) {
            [set addIndex:i];
        }
    }
    [_itemTableView reloadData];
}

#pragma mark - OperationActions
- (void)reload:(id)sender {
    [self refreshBackup:NO];
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn {
    _isSearch = YES;
    _searchFieldBtn = searchBtn;
    [_researchdataSourceArray removeAllObjects];
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contactName CONTAINS[cd] %@ ",searchStr];
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

#pragma mark - sort and select Action
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
        [displayArr sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        [_sortRightPopuBtn setTitle:[_sortRightPopuBtn titleOfSelectedItem]];
        str1 = CustomLocalizedString(@"SortBy_Name", nil);
    }else if (tag == 2){
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
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"contactName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
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
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"contactName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
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
        for (IMBVoiceMailAccountEntity *note in displayArr) {
            note.checkState = Check;
            for (IMBVoiceMailEntity *dataEntity in note.subArray) {
                dataEntity.checkState = Check;
            }
        }
        [_rightTableView changeHeaderCheckState:Check];
    }else if (tag == 2){
        for (IMBVoiceMailAccountEntity *note in displayArr) {
            note.checkState = UnChecked;
            for (IMBVoiceMailEntity *dataEntity in note.subArray) {
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

- (void)configRefreshView {
    //检测是否备份
    NSString *textString = nil;
    NSString *btnString = nil;
    if (_dataSourceArray.count > 0 || _information.safariManager.lastBackupScoend != 0) {
        textString =  [NSString stringWithFormat:CustomLocalizedString(@"NoticeBackup_id_1", nil),[DateHelper dateFrom1970ToString:_information.safariManager.lastBackupScoend withMode:2]];
        btnString = CustomLocalizedString(@"Common_id_1", nil);
    }else
    {
        textString = CustomLocalizedString(@"Backup_id_2", nil);
        btnString = CustomLocalizedString(@"Backup_id_3", nil);
    }
    
    NSRect btnRect = [StringHelper calcuTextBounds:btnString fontSize:14];
    NSRect textRect = [StringHelper calcuTextBounds:textString fontSize:14];
    
    [_refreshView initWithLuCorner:YES LbCorner:NO RuCorner:YES RbConer:NO CornerRadius:5];
    [(IMBLackCornerView *)_refreshView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"refreshView_bgColor", nil)]];
    _refreshTitle = [[NSTextField alloc] init];
    [_refreshTitle setSelectable:NO];
    [_refreshTitle setFrame:NSMakeRect(30, 2, textRect.size.width + 20, 24)];
    [_refreshTitle setFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_refreshTitle setBordered:NO];
    [_refreshTitle setFocusRingType:NSFocusRingTypeNone];
    [_refreshTitle setDrawsBackground:NO];
    [_refreshTitle setAlignment:NSCenterTextAlignment];
    [_refreshTitle setStringValue:textString];
    [_refreshTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"refreshView_titleColor", nil)]];
    if (_dataSourceArray.count <= 0) {
        [_refreshView setFrame:NSMakeRect(((self.view.bounds.size.width) - (textRect.size.width + btnRect.size.width + 100))/2, 0, (textRect.size.width + btnRect.size.width + 100), 30)];
    } else {
        [_refreshView setFrame:NSMakeRect((self.view.bounds.size.width) - (textRect.size.width + btnRect.size.width + 100) - (((self.view.bounds.size.width) - (_itemTableView.bounds.size.width) - (textRect.size.width + btnRect.size.width + 100))/2), 0, (textRect.size.width + btnRect.size.width + 100), 30)];
    }
    [_refreshView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewNotSizable];
    for (NSView *view in _refreshView.subviews) {
        if ([view isKindOfClass:[NSTextField class]]) {
            [view removeFromSuperview];
            break;
        }
    }
    [_refreshView addSubview:_refreshTitle];
    [_refreshTitle release];

    [self.view addSubview:_refreshView];

    
    for (NSView *view in _refreshView.subviews) {
        if ([view isKindOfClass:[IMBRefreshButton class]]) {
            [view removeFromSuperview];
            break;
        }
    }
    if (_refreshBtn != nil) {
        [_refreshBtn release];
        _refreshBtn = nil;
    }
    _refreshBtn = [[IMBRefreshButton alloc] initWithFrame:NSMakeRect(_refreshTitle.frame.size.width + 40, _refreshTitle.frame.origin.y + 4 , btnRect.size.width + 6, btnRect.size.height) withName:btnString];
    [_refreshBtn setTarget:self];
    [_refreshBtn setAction:@selector(doRefreshView:)];
    [_refreshView addSubview:_refreshBtn];
    [_refreshView setNeedsDisplay:YES];
}

- (void)doRefreshView:(id)sender {
    [_loadingView removeFromSuperview];
    [_containTableView removeFromSuperview];
    if ([self checkBackupEncrypt]) {//设备备份在iTunes上设置的是加密的
        [self showAlertText:CustomLocalizedString(@"backup_id_text_10", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    if (_backupAnimationVC) {
        [_backupAnimationVC release];
        _backupAnimationVC = nil;
    }
    _backupAnimationVC = [[IMBBackupAnimationViewController alloc]initWithNibName:@"IMBBackupAnimationViewController" bundle:nil Withipod:_ipod withViewTag:3];
    
    [_mainBox setContentView:_backupAnimationVC.view];
    [self animationAddTransferView:_backupAnimationVC.view];
    [_backupAnimationVC startBackupDevice];
}

- (void)refreshBackup:(BOOL)refresh {
    if ([self checkBackupEncrypt]) {
        [self showAlertText:CustomLocalizedString(@"backup_id_text_10", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    [self disableFunctionBtn:NO];
    [_backupAnimationVC.view removeFromSuperview];
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            //刷新方式，重新读取
            [_information.voicemailManager setIsRefresh:refresh];
            [_information loadVoicemail:NO];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self disableFunctionBtn:YES];
                [_loadingAnimationView endAnimation];
                if (_dataSourceArray != nil) {
                    [_dataSourceArray release];
                    _dataSourceArray = nil;
                }
                _dataSourceArray = (NSMutableArray *)[[_information voicemailArray] retain];
                if (_dataSourceArray.count == 0) {
                    [_mainBox setContentView: _noDataView];
                    [self configNoDataView];
                }else {
                    NSNotification *noti = [NSNotification notificationWithName:@"" object:_itemTableView];
                    [self tableViewSelectionDidChange:noti];
                    [_mainBox setContentView:_containTableView];
                }
                [_itemTableView reloadData];
                [_itemTableView deselectAll:nil];
                int count = 0;
                for (IMBVoiceMailAccountEntity *accountEntity in _dataSourceArray) {
                    count += accountEntity.subArray.count;
                }
                if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                    [_delegate refeashBadgeConut:count WithCategory:_category];
                }
                [_loadingAnimationView endAnimation];
            });
        }
    });
}

- (void)hideRefreshView {
    [_refreshView setHidden:YES];
}

- (void)animationAddTransferView:(NSView *)view {

    [view setFrame:NSMakeRect(0, 0, [(IMBDeviceMainPageViewController *)_delegate view].frame.size.width, [(IMBDeviceMainPageViewController *)_delegate view].frame.size.height)];
    [[(IMBDeviceMainPageViewController *)_delegate view] addSubview:view];
    [view setWantsLayer:YES];
    [view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
}

- (void)backupCompleteReload:(NSNotification *)notification {
    int i  =  [notification.object intValue];
    if (i == 3) {
        [self reload:nil];
    }
    [_refreshView setHidden:YES];
    [_nc postNotificationName:NOTITY_HIDE_REFRESHVIEW object:nil];
}

- (void)backupErrorReload:(NSNotification *)notification {
    int i  =  [notification.object intValue];
    if (i == 3) {
//        [self reload:nil];
        if (_dataSourceArray.count == 0) {
            [_mainBox setContentView: _noDataView];
            [self configNoDataView];
        }else {
            [_mainBox setContentView:_containTableView];
        }
    }
}

- (void)dealloc {
    if (_backupAnimationVC) {
        [_backupAnimationVC release];
        _backupAnimationVC = nil;
    }
    [_nc removeObserver:self name:NOTIFY_BACKUP_COMPELTE object:nil];
    [_nc removeObserver:self name:NOTITY_HIDE_REFRESHVIEW object:nil];
    [_nc removeObserver:self name:NOTIFY_BACKUP_ERROE object:nil];
    [super dealloc];
}
@end
