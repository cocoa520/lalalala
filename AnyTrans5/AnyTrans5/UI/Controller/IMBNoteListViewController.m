//
//  IMBNoteListViewController.m
//  iMobieTrans
//
//  Created by iMobie on 14-6-18.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBNoteListViewController.h"
#import "IMBNoteScroller.h"
#import "IMBCenterTextFieldCell.h"
#import "IMBCustomHeaderCell.h"
#import "IMBCustomCornerView.h"
//#import "IMBExportSetting.h"
#import "IMBInformation.h"
//#import "IMBBlankDraggableCollectionView.h"
//#import "IMBNoteExportToHtm.h"
#import "IMBEditButton.h"
//#import "IMBNoteClone.h"
#import "IMBCheckBoxCell.h"
#import "IMBMessageNameTextCell.h"
#import "IMBNotificationDefine.h"
#import "IMBSMSChatDataEntity.h"
@interface IMBNoteListViewController ()

@end

@implementation IMBNoteListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    if ([super initWithIpod:ipod withCategoryNodesEnum:category withDelegate:delegate]) {
        _dataSourceArray = [[_information noteArray] retain];
        _noteManagerInNormal = [[_information notesManager] retain];
    }
    return self;
}

- (IMBNotesManager *)getMobileSyncNotesManager{
    if (_noteManagerInNormal == nil) {
        _noteManagerInNormal = [[[IMBNotesManager alloc] initWithAMDevice:_ipod.deviceHandle] retain];
    }
    return _noteManagerInNormal;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        [self configNoDataView];
        [_editButton setTitleName:CustomLocalizedString(@"contact_id_92", nil)];
        [_editButton setNeedsDisplay:YES];
        NSString *cancelStr = CustomLocalizedString(@"Calendar_id_12", nil);
        [_cancelButton setTitleName:cancelStr WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
        [_cancelButton setNeedsDisplay:YES];
        
        
    });
}

- (void)changeSkin:(NSNotification *)notification
{
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [_itemTableView setNeedsDisplay:YES];
    [_itemTableView setGridColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [self configNoDataView];
    [editNoteScrollView setNeedsDisplay:YES];
    [_topWhiteView setNeedsDisplay:YES];
    [self settingNotesViewinRow];
    [_sortRightPopuBtn setNeedsDisplay:YES];
    [_selectSortBtn setNeedsDisplay:YES];
    [_loadAnimationView setNeedsDisplay:YES];
    
    [_editButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [_editButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [_editButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [_cancelButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [_cancelButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [_cancelButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [_editButton setNeedsDisplay:YES];
    [_cancelButton setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
}

- (void)awakeFromNib {
    _isloadingPopBtn = YES;
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkFaultInterrupt) name:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
    [_itemTableView setIsNote:YES];
    [_itemTableView setDelegate:self];
    [_itemTableView setListener:self];
    [_itemTableView setDataSource:self];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    _alertView = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_itemTableView setGridColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    _itemTableView.allowsMultipleSelection = NO;
   
     if (_isiCloudView) {
        _dataSourceArray = [_iCloudManager.noteArray retain];
     }
        if (_dataSourceArray.count == 0) {
            [_mainBox setContentView:_noDataView];
        }else {
            [_mainBox setContentView:_detailView];
        }
        [self configNoDataView];
        [_topWhiteView setIsBommt:YES];
        [_topWhiteView setBackgroundColor:[NSColor clearColor]];
        
        [editNoteScrollView setHastopBorder:NO leftBorder:YES BottomBorder:YES rightBorder:NO];
        [_itemTableView setAllowsEmptySelection:NO];
        _noteEditView = [[IMBBackupNoteEditView alloc] initWithFrame:NSMakeRect(0, 0, editNoteScrollView.frame.size.width -15, editNoteScrollView.frame.size.height - 5)];
        [editNoteScrollView setDocumentView:_noteEditView];
        [_noteEditView setAutoresizesSubviews:YES];
        [_noteEditView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin|NSViewWidthSizable|NSViewHeightSizable];
    
        if (_dataSourceArray.count > 0) {
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
            [_itemTableView reloadData];
        }
        [self initEditAndCancelButton];
        
        if(_dataSourceArray.count == 0){
            [_noteEditView setHidden:YES];
        }
        
        if (_information.noteNeedReload) {
            [self reload:nil];
            _information.noteNeedReload = NO;
        }
        [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNote:) name:NOTIFY_REFRESH_NOTEVIEW object:nil];
}

#pragma mark - 配置取消和保存按钮
- (void)initEditAndCancelButton{
    NSString *editStr = CustomLocalizedString(@"Calendar_id_10", nil);
    NSRect editRect = [StringHelper calcuTextBounds:editStr fontSize:13];
    int w = 80;
    if (editRect.size.width > 80) {
        w = editRect.size.width + 10;
    }
    _editButton = [[[IMBMyDrawCommonly alloc] initWithFrame:NSMakeRect(_noteEditView.frame.size.width - w - 10, 15, w, 20)] autorelease];
    //设置按钮样式
    [_editButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [_editButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [_editButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [_editButton setTitleName:editStr WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13]];
    [_editButton setTarget:self];
    [_editButton setAction:@selector(setIsEditing)];
    
    NSString *cancelStr = CustomLocalizedString(@"Calendar_id_12", nil);
    NSRect cancelRect = [StringHelper calcuTextBounds:cancelStr fontSize:13];
    w = 80;
    if (cancelRect.size.width > 80) {
        w = cancelRect.size.width + 10;
    }
    _cancelButton = [[[IMBMyDrawCommonly alloc] initWithFrame:NSMakeRect(_editButton.frame.origin.x - 10 - w, _editButton.frame.origin.y, w, _editButton.frame.size.height)] autorelease];
    //设置按钮样式
    [_cancelButton WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    //线的颜色
    [_cancelButton WithMouseExitedLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseUpLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] WithMouseDownLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withMouseEnteredLineColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [_cancelButton WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseUpfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)]];
    [_cancelButton setTitleName:cancelStr WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13]];
    [_cancelButton setTarget:self];
    [_cancelButton setAction:@selector(setIsCanceling)];
    
    [_editButton setAutoresizingMask:YES];
    [_editButton setAutoresizingMask:NSViewMinXMargin|NSViewMaxYMargin];
    [_cancelButton setAutoresizingMask:YES];
    [_cancelButton setAutoresizingMask:NSViewMinXMargin|NSViewMaxYMargin];
    
    [_noteEditView addSubview:_cancelButton];
    [_noteEditView addSubview:_editButton];
    
    [_editButton setHidden:YES];
    [_cancelButton setHidden:YES];
}

- (void)retToolbar:(IMBToolBarView *)toolbar{
    _toolBar = toolbar;
}

- (IBAction)setIsEditing{
    [self actionWhenEditing];
}

- (IBAction)setIsCanceling{
    if (_isiCloudView) {
        _isEditing = NO;
        [_toolBar toolBarButtonIsEnabled:NO];
        [self actionWhenDone];
        if (_dataSourceArray.count > 0) {
            [_dataSourceArray removeObjectAtIndex:0];
            [_itemTableView reloadData];
        }
        if (_dataSourceArray.count > 0) {
            int row = (int)[_itemTableView selectedRow];
            if (row > -1 && row < _dataSourceArray.count) {
                [self changeSonTableViewData:row];
            }else {
                [self changeSonTableViewData:0];
            }
            [_itemTableView reloadData];
        }else {
            [_mainBox setContentView:_noDataView];
            [self configNoDataView];
        }
        [_toolBar toolBarButtonIsEnabled:YES];
    }else{
        [self reload:nil];
    }
}

- (IBAction)setIsDone{
    
    [self actionWhenDone];
    if (_isiCloudView) {
        BOOL success = NO;
        if (![TempHelper stringIsNilOrEmpty:_noteEditView.contentField.stringValue]) {
            IMBUpdateNoteEntity *entity = [[IMBUpdateNoteEntity alloc] init];
            entity.noteContent = _noteEditView.contentField.stringValue;
            entity.timeStamp = [[NSDate date] timeIntervalSince1970];
            success = [_iCloudManager addNoteData:[NSArray arrayWithObject:entity]];
            [entity release];
        }
        
        if (success) {
            [self iCloudReload:nil];
        } else {
            [self performSelectorOnMainThread:@selector(showAddErrorTip) withObject:nil waitUntilDone:NO];
        }
        
        [_toolBar toolBarButtonIsEnabled:YES];
    }else{
        if (!_isRefreshing) {
            [self getMobileSyncNotesManager];
            if (![TempHelper stringIsNilOrEmpty:_noteEditView.contentField.stringValue]) {
                [_notesEntity setContent:_noteEditView.contentField.stringValue];
            }
            if (_notesEntity.isNew) {
                [_noteManagerInNormal openMobileSync];
                [_noteManagerInNormal insertNote:_notesEntity];
                [_noteManagerInNormal closeMobileSync];
                [self reload:nil];
            }
            else{
                [_noteManagerInNormal openMobileSync];
                [_noteManagerInNormal modifyNote:_notesEntity];
                [_noteManagerInNormal closeMobileSync];
                [self reload:nil];
            }
        }

    }
    [_itemTableView reloadData];
}

- (void)addItems:(id)sender{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Notes Add" label:Start transferCount:0 screenView:@"Notes View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    [_toolBar toolBarButtonIsEnabled:NO];
    if (_ipod.beingSynchronized) {
        [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    [_mainBox setContentView:_detailView];
    if (_notesEntity != nil) {
        [_notesEntity release];
        _notesEntity = nil;
    }
    _notesEntity = [[IMBNoteModelEntity alloc] init];
    NSDateFormatter *dateFormater = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [_notesEntity setCreatDateStr:[dateFormater stringFromDate:[NSDate date]]];
    [_notesEntity setTitle:CustomLocalizedString(@"contact_id_91", nil)];
    [_notesEntity setContent:@""];
    [_notesEntity setAuthor:@""];
    [_notesEntity setIsNew:YES];
    if (!_isiCloudView) {
        [self getMobileSyncNotesManager];
    }
    if (_dataSourceArray == nil) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    [_dataSourceArray insertObject:_notesEntity atIndex:0];
    
    [_itemTableView reloadData];
    if (_dataSourceArray.count >= 1) {
        [_editButton setHidden:NO];
        [_cancelButton setHidden:NO];
    }
    [_itemTableView deselectAll:nil];
    [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [self tableViewSelectRow:0];
    [self setIsEditing];
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Notes Add" label:Finish transferCount:0 screenView:@"Notes View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}

- (void)generateNoteView{
    
}

- (void)actionWhenDone{
    _isEditing = NO;
//    [_editButton setTitleName:CustomLocalizedString(@"Calendar_id_10", nil)];
//    [_editButton setAction:@selector(setIsEditing)];
//    [_editButton setTarget:self];
    [_cancelButton setHidden:YES];
    [_editButton setHidden:YES];
    //设置noteContentView不能点击
    [_noteEditView setIsEditing:_isEditing];
}

- (void)actionWhenEditing{
    _isEditing = YES;
    [_editButton setHidden:NO];
    [_editButton setTitleName:CustomLocalizedString(@"contact_id_92", nil)];
    [_editButton setNeedsDisplay:YES];
    [_editButton setAction:@selector(setIsDone)];
    [_editButton setTarget:self];
    [_cancelButton setHidden:NO];
    [_cancelButton setNeedsDisplay:YES];
    //设置noteContentView可以点击
    [_noteEditView setIsEditing:_isEditing];
}

#pragma mark - NSTextView
- (void)configNoDataView {
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_note"]];
    [_textView setDelegate:self];
    NSString *promptStr = @"";
    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_60", nil)] ;
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

#pragma mark - NSTableView datasource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_dataSourceArray != nil) {
        //当前显示的数据源
        NSArray *displayArray = nil;
        if (_isSearch) {
            displayArray = _researchdataSourceArray;
        }
        else{
            displayArray = _dataSourceArray;
        }
        if (displayArray.count <= 0 ) {
            return 0;
        }
        return [displayArray count];
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <= 0 ) {
        return nil;
    }
    IMBNoteModelEntity *note = [displayArray objectAtIndex:row];
    if ([[tableColumn identifier] isEqualToString:@"Name"]) {
        if ([TempHelper stringIsNilOrEmpty:note.title]) {
            note.title = CustomLocalizedString(@"MenuItem_id_60",nil);
        }
        NSString *noteTitleString = note.title;
        NSCharacterSet *set = [NSCharacterSet newlineCharacterSet];
        if ([noteTitleString rangeOfCharacterFromSet:set].location != NSNotFound) {
            NSMutableString *string = [[note.title mutableCopy] autorelease];
            NSRange range = [string rangeOfCharacterFromSet:set];
            string = [[[string substringToIndex:range.location] mutableCopy] autorelease];
            [string appendString:@"..."];
            noteTitleString = string;
        }
        NSString *str = note.shortDateStr;
        if (noteTitleString.length>0) {
            return [NSString stringWithFormat:@"%@\n%@",noteTitleString,str];
        }else
        {
            return noteTitleString;
        }
    }
    if ([[tableColumn identifier] isEqualToString:@"Time"]) {
        NSString *shortDate = nil;
        if (![StringHelper stringIsNilOrEmpty:note.modifyDateStr]) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *tmpdate = [df dateFromString:note.modifyDateStr];
            [df setDateFormat:@"yyyy-MM-dd"];
            shortDate = [df stringFromDate:tmpdate];
            [df release];
            df = nil;
        }
        return shortDate;
    }if ([[tableColumn identifier] isEqualToString:@"CheckCol"]) {
        return [NSNumber numberWithInt:note.checkState];
    }

    return nil;

}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([[tableColumn identifier] isEqualToString:@"CheckCol"]) {
        IMBCheckBoxCell *boxCell = (IMBCheckBoxCell *)cell;
        boxCell.outlineCheck = YES;
    }else if ([[tableColumn identifier] isEqualToString:@"Name"]) {
         IMBMessageNameTextCell *messageCell = (IMBMessageNameTextCell *)cell;
        if (row == [_itemTableView selectedRow]) {
            [messageCell setIsAlwaysHighLight:YES];
        }else {
            [messageCell setIsAlwaysHighLight:NO];
        }
    }
}

#pragma mark - NSTableView delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 60;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    if (_isEditing) {
        [self setIsCanceling];
    }
//    if (_isiCloudView) {
//        NSInteger row = [_itemTableView selectedRow];
//        [self changeSonTableViewData:row];
//    }else{
        NSArray *displayArray = nil;
        if (_isSearch) {
            displayArray = _researchdataSourceArray;
        }
        else{
            displayArray = _dataSourceArray;
        }
        if (displayArray.count <= 0 ) {
            return ;
        }
        NSInteger row = [_itemTableView selectedRow];
        if(row == NSNotFound || row == -1){
            if (displayArray.count > 0) {
                [_noteEditView setHidden:NO];
                row = 0;
            }
        }
        if (_noteEditView.isHidden) {
            [_noteEditView setHidden:NO];
        }
        NSIndexSet *set = [_itemTableView selectedRowIndexes];
        
        
        IMBNoteModelEntity *note = nil;
        if (row == -1 && [displayArray count]>0&&[set count]==0)
        {
            note = nil;
            
        }else if(row < [displayArray count])
        {
            note = [displayArray objectAtIndex:row];
        }
        if (_notesEntity != nil) {
            [_notesEntity release];
            _notesEntity = nil;
        }
        _notesEntity = [note retain];
        [self settingNotesViewinRow];
        for (NSView *view in editNoteScrollView.subviews) {
            if ([view isKindOfClass:[NSScroller class]]) {
                NSScroller *scroller = (NSScroller *)view;
                [scroller setNeedsDisplay];
            }
        }
        [self.view.window makeFirstResponder:_itemTableView];
   // }
}

- (void)tableViewSelectRow:(int)selectRow {
    if (_isEditing) {
        [self setIsCanceling];
    }
//    if (_isiCloudView) {
//        NSInteger row = [_itemTableView selectedRow];
//        if (row > _dataSourceArray.count || row < 0) {
//            [self changeSonTableViewData:0];
//        }else {
//            [self changeSonTableViewData:row];
//        }
//        
//    }else{
        NSArray *displayArray = nil;
        if (_isSearch) {
            displayArray = _researchdataSourceArray;
        }
        else{
            displayArray = _dataSourceArray;
        }
        if (displayArray.count <= 0 ) {
            return ;
        }
        NSInteger row = [_itemTableView selectedRow];
        if(row == NSNotFound || row == -1){
            if (displayArray.count > 0) {
                [_noteEditView setHidden:NO];
                [_itemTableView deselectAll:nil];
                [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:YES];
                [self setIsEditing];
            }
            else{
                [_noteEditView setHidden:YES];
            }
            return;
        }
        if (_noteEditView.isHidden) {
            [_noteEditView setHidden:NO];
        }
        NSIndexSet *set = [_itemTableView selectedRowIndexes];
        
        IMBNoteModelEntity *note = nil;
        if (row == -1 && [displayArray count]>0&&[set count]==0)
        {
            note = nil;
            
        }else if(row < [displayArray count])
        {
            note = [displayArray objectAtIndex:row];
        }
        if (_notesEntity != nil) {
            [_notesEntity release];
            _notesEntity = nil;
        }
        _notesEntity = [note retain];
        [self settingNotesViewinRow];
        for (NSView *view in editNoteScrollView.subviews) {
            if ([view isKindOfClass:[NSScroller class]]) {
                NSScroller *scroller = (NSScroller *)view;
                [scroller setNeedsDisplay];
            }
        }
        [self.view.window makeFirstResponder:_itemTableView];
   // }
}

- (void)changeSonTableViewData:(NSInteger)countRow{
    NSArray *displayArr = nil;
    if (_isSearch) {
        displayArr = _researchdataSourceArray;
    }else{
        displayArr = _dataSourceArray;
    }
    if (_firstCount == 0&&_isEditing == NO) {
        [_noteEditView release];
        _noteEditView = nil;
        _noteEditView = [[IMBBackupNoteEditView alloc] initWithFrame:NSMakeRect(0, 0, editNoteScrollView.frame.size.width -15, editNoteScrollView.frame.size.height - 5)];
        [editNoteScrollView setDocumentView:_noteEditView];
        [_noteEditView setAutoresizesSubviews:YES];
        
        [_noteEditView setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin|NSViewWidthSizable|NSViewHeightSizable];
         [self initEditAndCancelButton];
    }

    _firstCount = (int)countRow;

    if(-1<countRow&&countRow<[displayArr count]){
        IMBNoteModelEntity *note = [displayArr objectAtIndex:countRow];
        [_noteEditView setTime:note.creatDateStr];
        if ([TempHelper stringIsNilOrEmpty:note.content]) {
            NSString *amosaicStr = @"";
            if (![IMBSoftWareInfo singleton].isRegistered) {
                NSString *endStr = note.summary;
                if (endStr != nil) {
                    amosaicStr = endStr;
                }else{
                    amosaicStr = note.title;
                }
            }else{
                amosaicStr = note.summary;
            }
            if (amosaicStr == nil) {
                amosaicStr = CustomLocalizedString(@"MenuItem_id_60",nil);
            }
            if (_isEditing) {
                [_noteEditView.contentField.cell setPlaceholderString:amosaicStr];
            }else {
                [_noteEditView setContent:amosaicStr];
            }
        }else{
            NSString *amosaicStr = @"";
            if (![IMBSoftWareInfo singleton].isRegistered) {
                //                if (note.isDeleted){
                NSString *endStr = nil;
                if (endStr != nil) {
                    amosaicStr = endStr;
                }else{
                    amosaicStr = note.content;
                }
            }else{
                amosaicStr = note.content;
            }
            [_noteEditView setContent:amosaicStr];
        }
   
        NSArray *views = [NSArray arrayWithArray:_noteEditView.subviews];
        for (NSView *view in views) {
            if ([view isKindOfClass:[NSImageView class]]) {
                [view removeFromSuperview];
            }
        }
         _noteEditView.noteHigh = 0;
        if (note.attachmentAry.count > 0) {
            for (IMBiCloudNoteAttachmentEntity  *attachmentData in note.attachmentAry) {
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
//
                    for (IMBAttachDetailEntity *attachDetail in array) {
                        [_noteEditView addAttachment:attachDetail.backUpFilePath];
                    }
                    [array release];
                }
            }
        }
    }else{
        [_noteEditView setTime:@"   "];
        [_noteEditView setContent:@"   "];
        
        NSArray *views = [NSArray arrayWithArray:_noteEditView.subviews];
        for (NSView *view in views) {
            if ([view isKindOfClass:[NSImageView class]]) {
                [view removeFromSuperview];
            }
        }
    }
}

- (void)settingNotesViewinRow{
    if (_notesEntity == nil) {
        NSString *createDate = @"";
        NSString *content = @"";
        [_noteEditView setBindingEntity:_notesEntity andPath:@"content"];
        [_noteEditView setTime:createDate];
        [_noteEditView setContent:content];
    }else{
        NSString *createDate = _notesEntity.creatDateStr;
        NSString *content = _notesEntity.content;
        [_noteEditView setBindingEntity:_notesEntity andPath:@"content"];
        [_noteEditView setTime:createDate];
        [_noteEditView setContent:content];
    }
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation {
    return NSDragOperationNone;
}

#pragma mark - IMBImageRefreshListListener
- (void)tableView:(NSTableView *)tableView row:(NSInteger)index{
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <= 0 ) {
        return ;
    }
    IMBNoteModelEntity *entity = [displayArray objectAtIndex:index];
    entity.checkState = !entity.checkState;
    [_itemTableView reloadData];
}

-(void)setAllselectState:(CheckStateEnum)sender{
    for (IMBNoteModelEntity *entity in _dataSourceArray) {
        entity.checkState = sender;
    }
    [_itemTableView  reloadData];
}

- (BOOL)resignClickByEvent:(NSEvent *)theEvent{
    NSInteger selectedRow = [_itemTableView selectedRow];
    if (selectedRow != -1) {
        [self tableViewSelectionDidChange:nil];
    }
    else{
        if (_dataSourceArray.count > 0) {
            [_itemTableView deselectAll:nil];
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }
        else{
            [_noteEditView setHidden:YES];
        }
    }
    return YES;
}

#pragma mark operationActions
- (void)reload:(id)sender {
    BOOL open = [self chekiCloud:@"Notes" withCategoryEnum:_category];
    if (!open) {
        return;
    }
    [self disableFunctionBtn:NO];
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [_mainBox setContentView:_loadingView];
    [_loadAnimationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            //刷新方式，重新读取
            [_information loadNote];
            if (_noteManagerInNormal != nil) {
                [_noteManagerInNormal release];
                _noteManagerInNormal = nil;
            }
            _noteManagerInNormal = [_information.notesManager retain];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self disableFunctionBtn:YES];
                if (_dataSourceArray != nil) {
                    [_dataSourceArray release];
                    _dataSourceArray = nil;
                }
                _dataSourceArray = [[_information noteArray] retain];
                [self refresh];
                if (_dataSourceArray.count == 0) {
                    [_mainBox setContentView:_noDataView];
                    [self configNoDataView];
                }else {
                    [_mainBox setContentView:_detailView];
                }
                if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                    [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
                }
                [_editButton setNeedsDisplay:YES];
                [_itemTableView reloadData];
                [_loadAnimationView endAnimation];
                
                
            });
        }
    });
}

- (IBAction)sortSelectedPopuBtn:(id)sender {
    
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray =  _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    NSMenuItem *item = [_selectSortBtn selectedItem];
    NSInteger tag = [_selectSortBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _selectSortBtn.itemArray) {
        [menuItem setState:NSOffState];
    }
    if (tag == 1) {
        for (IMBNoteModelEntity *note in displayArray) {
            note.checkState = Check;
        }
        
        //        [_sortRightPopuBtn setTitle:CustomLocalizedString(@"showMenu_id_1", nil)];
    }else if (tag == 2){
        for (IMBNoteModelEntity *note in displayArray) {
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

- (IBAction)sortRightPopuBtn:(id)sender {
    NSMenuItem *item = [_sortRightPopuBtn selectedItem];
    NSRect rect = [TempHelper calcuTextBounds:item.title fontSize:12];
    [_sortRightPopuBtn setFrame:NSMakeRect(_topWhiteView.frame.size.width - 30 - rect.size.width-12,_sortRightPopuBtn.frame.origin.y , rect.size.width +30, _sortRightPopuBtn.frame.size.height)];
    [_sortRightPopuBtn setTitle:[_sortRightPopuBtn titleOfSelectedItem]];
    NSInteger tag = [_sortRightPopuBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _sortRightPopuBtn.itemArray) {
        if (menuItem.tag != 1) {
            [menuItem setState:NSOffState];
        }
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
        [_dataSourceArray sortUsingDescriptors:sortDescriptors];
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
        [_dataSourceArray sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        //        [_topPopuBtn setTitle:[_topPopuBtn titleOfSelectedItem]];
    }else if (item.tag == 4){
        _isAscending = NO;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_dataSourceArray sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        //        //
    }
    NSString *str1 = CustomLocalizedString(@"SortBy_Name", nil);
    [_sortRightPopuBtn setTitle:str1];
    [_sortRightPopuBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSInteger row = [_itemTableView selectedRow];
    [self tableViewchangeCellData:row];
}

- (void)tableViewchangeCellData:(NSInteger)row{
    if(row == NSNotFound || row == -1){
        return;
    }
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <= 0 ) {
        return ;
    }
    if (_noteEditView.isHidden) {
        [_noteEditView setHidden:NO];
    }
    NSIndexSet *set = [_itemTableView selectedRowIndexes];
    
    IMBNoteModelEntity *note = nil;
    if (row == -1 && [displayArray count]>0&&[set count]==0)
    {
        note = nil;
        
    }else if(row < [displayArray count])
    {
        note = [displayArray objectAtIndex:row];
    }
    if (_notesEntity != nil) {
        [_notesEntity release];
        _notesEntity = nil;
    }
    _notesEntity = [note retain];
    [self settingNotesViewinRow];
    for (NSView *view in editNoteScrollView.subviews) {
        if ([view isKindOfClass:[IMBNoteScroller class]]) {
            IMBNoteScroller *scroller = (IMBNoteScroller *)view;
            [scroller setNeedsDisplay];
        }
    }
}

- (void)deleteItems:(id)sender {
    BOOL open = [self chekiCloud:@"Notes" withCategoryEnum:_category];
    if (!open) {
        return;
    }
    
    NSMutableArray *arrayM = [[NSMutableArray alloc]init];
    for (IMBNoteModelEntity *entity in _dataSourceArray) {
        if (entity.checkState == Check) {
            [arrayM addObject:entity];
        }
    }
    if (arrayM.count > 0) {
        NSString *str;
        if (arrayM.count > 1) {
            str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete", nil);
        }else {
            str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete_2", nil);
        }
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        int i = [_alertView showDeleteConfrimText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)  CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
        if (i == 0) {
            return;
        }
    }else {
        //弹出警告确认框
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_delete", nil),CustomLocalizedString(@"MenuItem_id_60", nil)];
        }else {
            str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        }

        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [_mainBox setContentView:_loadingView];
    [_loadAnimationView startAnimation];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_noteManagerInNormal openMobileSync];
        [_noteManagerInNormal delNotes:arrayM];
        [_noteManagerInNormal closeMobileSync];
        //重新加载内存数据
        [_information loadNote];
        if (_noteManagerInNormal != nil) {
            [_noteManagerInNormal release];
            _noteManagerInNormal = nil;
        }
        _noteManagerInNormal = [_information.notesManager retain];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (_dataSourceArray != nil) {
                [_dataSourceArray release];
                _dataSourceArray = nil;
            }
            _dataSourceArray = [[_information noteArray] retain];
            [self refresh];
            if (_dataSourceArray.count == 0) {
                [_mainBox setContentView:_noDataView];
                [self configNoDataView];
            }else {
                [_mainBox setContentView:_detailView];
                [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
            }
            [arrayM release];
            [_loadAnimationView endAnimation];
        });
    });
}

- (void)refresh {
    NSInteger selecteRow = [_itemTableView selectedRow];
    _isRefreshing = YES;
    [self setIsDone];
    _isRefreshing = NO;

    if (selecteRow < _dataSourceArray.count) {
        [_itemTableView deselectAll:nil];
        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selecteRow] byExtendingSelection:NO];
    }
    if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
        [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
    }
}

- (void)refreshData {
   /*
    _itemArray = (NSMutableArray *)[[_information noteArray] retain];
    [self rebuildingBindingArray:_itemArray];
    if ([_itemArray count]>0) {
        [_itemTableView deselectAll:nil];
        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    }
*/
}

- (void)changeNotesLanguage:(NSNotification *)notification {
 /*   if (_isEditing) {
        [_editButton setDrawString:CustomLocalizedString(@"contact_id_92", nil)];
    }
    else{
        [_editButton setDrawString:CustomLocalizedString(@"Calendar_id_10", nil)];
    }
    [_cancelButton setDrawString:CustomLocalizedString(@"Calendar_id_12", nil)];
    [_cancelButton setFrameOrigin:NSMakePoint(_editButton.frame.origin.x - 20 - _cancelButton.frame.size.width, _editButton.frame.origin.y)];

    [_itemTableView _setupHeaderCell];
    [_itemTableView reloadData];
    if ([_countDelegate respondsToSelector:@selector(reCaulateItemCount)]) {
        
        [_countDelegate reCaulateItemCount];
    }
*/
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    _searchFieldBtn = searchBtn;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
        if (_researchdataSourceArray.count <=0) {
            IMBNoteModelEntity *note = nil;
            note = nil;
            
            if (_notesEntity != nil) {
                [_notesEntity release];
                _notesEntity = nil;
            }
            _notesEntity = [note retain];
            [self settingNotesViewinRow];
            for (NSView *view in editNoteScrollView.subviews) {
                if ([view isKindOfClass:[NSScroller class]]) {
                    NSScroller *scroller = (NSScroller *)view;
                    [scroller setNeedsDisplay];
                }
            }

        }else{
            IMBNoteModelEntity *note = nil;
       
            note = [_researchdataSourceArray objectAtIndex:0];
       
            if (_notesEntity != nil) {
                [_notesEntity release];
                _notesEntity = nil;
            }
            _notesEntity = [note retain];
            [self settingNotesViewinRow];
            for (NSView *view in editNoteScrollView.subviews) {
                if ([view isKindOfClass:[NSScroller class]]) {
                    NSScroller *scroller = (NSScroller *)view;
                    [scroller setNeedsDisplay];
                }
            }
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }
    }else{
        IMBNoteModelEntity *note = nil;
        note = [_dataSourceArray objectAtIndex:0];
        
        if (_notesEntity != nil) {
            [_notesEntity release];
            _notesEntity = nil;
        }
        _notesEntity = [note retain];
        [self settingNotesViewinRow];
        for (NSView *view in editNoteScrollView.subviews) {
            if ([view isKindOfClass:[NSScroller class]]) {
                NSScroller *scroller = (NSScroller *)view;
                [scroller setNeedsDisplay];
            }
        }
        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
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
        IMBNoteModelEntity *noteMode = [disAry objectAtIndex:i];
        if (noteMode.checkState == NSOnState) {
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

- (void)refreshNote:(NSNotification *)noti {
    [_noteEditView.contentField becomeFirstResponder];
}

- (void)deviceToiCloud:(id)sender{
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        return;
    }
    
    
    NSMutableArray *arrayM = [[NSMutableArray alloc]init];
    OperationLImitation *imitation = [OperationLImitation singleton];
    for (IMBNoteModelEntity *entity in _dataSourceArray) {
        if (entity.checkState == Check) {
            
            if (imitation.remainderCount == 0) {
                break;
            }
            IMBUpdateNoteEntity *noteEntity = [[IMBUpdateNoteEntity alloc]init];
            if (![StringHelper stringIsNilOrEmpty:entity.content]) {
                noteEntity.noteContent = [entity.content stringByReplacingOccurrencesOfString:@"Ôøº" withString:@""];
            }else if (![StringHelper stringIsNilOrEmpty:entity.summary]) {
                noteEntity.noteContent = entity.summary;
            }else if (![StringHelper stringIsNilOrEmpty:entity.title]) {
                noteEntity.noteContent = entity.title;
            }else {
                continue;
            }
            noteEntity.timeStamp = entity.modifyDate;
            [arrayM addObject:noteEntity];
            
            [imitation reduceRedmainderCount];
            [noteEntity release];
        }
    }
    if (arrayM.count > 0) {
        _transtotalCount = (int)arrayM.count;
    }
    
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Device_Content action:ToiCloud actionParams:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] label:Start transferCount:_transtotalCount screenView:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    
    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }
    _transferController = [[IMBTransferViewController alloc] initWithType:Category_Notes withDelegate:self withTransfertype:TransferSync withIsicloudView:YES];
    [_transferController setDelegate:self];
    if (result>0) {
        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
    }else{
        [self animationAddTransferView:_transferController.view];
    }
    if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"contact_id_91", nil)]];
    }
    NSString *msgStr = CustomLocalizedString(@"ImportSync_id_1", nil);
    if ([_transferController respondsToSelector:@selector(transferFile:)]) {
        [_transferController transferFile:msgStr];
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_iCloudManager getNoteContent];
        [_iCloudManager addNoteData:arrayM];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Device_Content action:ToiCloud actionParams:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] label:Finish transferCount:0 screenView:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [arrayM  autorelease];
    });
}

#pragma mark - iCloud Actions
- (void)iCloudReload:(id)sender {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Notes Refresh" label:Start transferCount:0 screenView:@"Notes View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [[IMBLogManager singleton] writeInfoLog:@"icloud note reload Data start"];
    [_mainBox setContentView:_loadingView];
    [_loadAnimationView startAnimation];
    [_toolBar toolBarButtonIsEnabled:NO];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_iCloudManager getNoteContent];
        if (_dataSourceArray != nil) {
            [_dataSourceArray release];
            _dataSourceArray = nil;
        }
        _dataSourceArray = [_iCloudManager.noteArray retain];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_toolBar toolBarButtonIsEnabled:YES];
            if (_dataSourceArray.count == 0) {
                [_mainBox setContentView:_noDataView];
                [self configNoDataView];
            }else {
                [_mainBox setContentView:_detailView];
                [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                [_itemTableView reloadData];
            }
            if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
            }
            [_loadAnimationView endAnimation];
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Notes Refresh" label:Finish transferCount:0 screenView:@"Notes View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            IMBNoteModelEntity *note = nil;
            NSInteger row = [_itemTableView selectedRow];
            NSIndexSet *set = [_itemTableView selectedRowIndexes];
            if (row == -1 && [_dataSourceArray count]>0&&[set count]==0)
            {
                note = nil;
                
            }else if(row < [_dataSourceArray count])
            {
                note = [_dataSourceArray objectAtIndex:row];
            }
            if (_notesEntity != nil) {
                [_notesEntity release];
                _notesEntity = nil;
            }
            _notesEntity = [note retain];
            [self settingNotesViewinRow];
            [[IMBLogManager singleton] writeInfoLog:@"icloud note reload Data end"];
        });
    });
}

- (void)addiCloudItems:(id)sender {
    [self addItems:nil];
}

- (void)deleteiCloudItems:(id)sender {
    NSMutableArray *arrayM = [[NSMutableArray alloc]init];
    for (IMBNoteModelEntity *entity in _dataSourceArray) {
        if (entity.checkState == Check) {
            [arrayM addObject:entity];
        }
    }
    if (arrayM.count == 0) {
        NSString *str = nil;
        str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }else{
        [[IMBLogManager singleton] writeInfoLog:@"icloud note delete Data start"];
        [_alertViewController._removeprogressAnimationView setProgressWithOutAnimation:0];
        [_alertViewController._removeprogressAnimationView setProgress:0];
        NSLog(@"deleteiCloudItems");
        NSString *str = CustomLocalizedString(@"MSG_COM_Confirm_Before_Delete_2", nil);
        _alertViewController.isStopPan = NO;
        _alertViewController.isIcloudRemove = YES;
        if ([self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)] == 1) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{

                BOOL success = NO;
                if (arrayM.count >0) {
                    NSDictionary *dimensionDict = nil;
                    @autoreleasepool {
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Notes Delete" label:Start transferCount:arrayM.count screenView:@"Notes View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    success = [_iCloudManager deleteNote:arrayM];
                    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Notes Delete" label:Finish transferCount:arrayM.count screenView:@"Notes View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                }
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_alertViewController._removeprogressAnimationView setProgress:100];
                        double delayInSeconds = 2;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            [_alertViewController showRemoveSuccessViewAlertText:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil) withCount:(int)arrayM.count];
                            [self iCloudReload:nil];
                     
                            
                        });
                    });
                } else {
                    [self performSelectorOnMainThread:@selector(showDeleteErrorTip) withObject:nil waitUntilDone:NO];
                 
                }
                [arrayM release];
                [[IMBLogManager singleton] writeInfoLog:@"icloud note delete Data end"];
            });
        }
    }
}

- (void)doiClouditemEdit:(id)sender {
    NSLog(@"doiClouditemEdit");
}

- (void)iCloudSyncTransfer:(id)sender {
    
    IMBiCloudManager *otheriCloudManager = [self getOtheriCloudAccountManager];
    if (otheriCloudManager != nil) {
        NSDictionary *iCloudDic = [_delegate getiCloudAccountViewCollection];
        NSMutableArray *baseInfoArr = [NSMutableArray array];
        for (NSString *key in iCloudDic.allKeys) {
            if (![key isEqualToString:_iCloudManager.netClient.loginInfo.appleID]) {
                IMBBaseInfo *baseInfo = [[IMBBaseInfo alloc]init];
                IMBiCloudManager *otheriCloudManager = [[iCloudDic objectForKey:key] iCloudManager];
                baseInfo.deviceName = otheriCloudManager.netClient.loginInfo.loginInfoEntity.fullName;
                baseInfo.isicloudView = YES;
                baseInfo.uniqueKey = key;
                [baseInfoArr addObject:baseInfo];
                [baseInfo release];
            }
        }
        if (baseInfoArr.count == 1) {
            [[IMBLogManager singleton] writeInfoLog:@"icloud note syncTransfer Data start"];
            NSMutableArray *arrayM = [[NSMutableArray alloc]init];
            for (IMBiCloudNoteModelEntity *entity in _dataSourceArray) {
                if (entity.checkState == Check) {
                    IMBUpdateNoteEntity *noteEntity = [[IMBUpdateNoteEntity alloc] init];
                    if (![StringHelper stringIsNilOrEmpty:entity.content]) {
                        noteEntity.noteContent = [entity.content stringByReplacingOccurrencesOfString:@"Ôøº" withString:@""];
                    }else if (![StringHelper stringIsNilOrEmpty:entity.summary]) {
                        noteEntity.noteContent = entity.summary;
                    }else if (![StringHelper stringIsNilOrEmpty:entity.title]) {
                        noteEntity.noteContent = entity.title;
                    }else {
                        continue;
                    }
                    noteEntity.timeStamp = entity.modifyDate;
                    [arrayM addObject:noteEntity];
                    [noteEntity release];
                }
            }
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Notes To iCloud" label:Start transferCount:arrayM.count screenView:@"Notes View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            _transtotalCount = (int)arrayM.count;
            if (arrayM.count > 0) {
                if (_transferController != nil) {
                    [_transferController release];
                    _transferController = nil;
                }
                IMBBaseInfo *baseInfo = [baseInfoArr objectAtIndex:0];
                NSDictionary *iCloudDic = [_delegate getiCloudAccountViewCollection];
                _otheriCloudManager = [[iCloudDic objectForKey:baseInfo.uniqueKey] iCloudManager];
                [_otheriCloudManager setDelegate:self];
                _transferController = [[IMBTransferViewController alloc] initWithType:Category_Notes withDelegate:self withTransfertype:TransferSync withIsicloudView:YES];
                [_transferController setDelegate:self];
                _transferController.isicloudView = YES;
                if (![IMBSoftWareInfo singleton].isRegistered) {
//                    _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
                }
//                [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:nil];
                     [self animationAddTransferView:_transferController.view];
                if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
                    [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"contact_id_91", nil)]];
                }
                NSString *msgStr = CustomLocalizedString(@"ImportSync_id_1", nil);
                if ([_transferController respondsToSelector:@selector(transferFile:)]) {
                    [_transferController transferFile:msgStr];
                }
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [_otheriCloudManager getNoteContent];
                    [_otheriCloudManager addNoteData:arrayM];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSDictionary *dimensionDict = nil;
                        @autoreleasepool {
                            dimensionDict = [[TempHelper customDimension] copy];
                        }
                        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Notes To iCloud" label:Finish transferCount:arrayM.count screenView:@"Notes View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                        if (dimensionDict) {
                            [dimensionDict release];
                            dimensionDict = nil;
                        }
                    });
                    [arrayM  release];
                });
                [[IMBLogManager singleton] writeInfoLog:@"icloud note syncTransfer Data end"];
            }else {
                //弹出警告确认框
                NSString *str = nil;
                str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
                [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                [arrayM release];
            }

        }else {
            [self toDeviceWithSelectArray:baseInfoArr WithView:sender];
        }
    }else {
        //提示用户，没有其他iCloud账号登录
        NSString *str = nil;
        str = CustomLocalizedString(@"NoAcount_Tips", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
   
}

- (void)onItemiCloudClicked:(id)sender {
    [_toDevicePopover close];
    NSMutableArray *arrayM = [[NSMutableArray alloc]init];
    for (IMBiCloudNoteModelEntity *entity in _dataSourceArray) {
        if (entity.checkState == Check) {
            IMBUpdateNoteEntity *noteEntity = [[IMBUpdateNoteEntity alloc] init];
            if (![StringHelper stringIsNilOrEmpty:entity.content]) {
                noteEntity.noteContent = [entity.content stringByReplacingOccurrencesOfString:@"Ôøº" withString:@""];
            }else if (![StringHelper stringIsNilOrEmpty:entity.summary]) {
                noteEntity.noteContent = entity.summary;
            }else if (![StringHelper stringIsNilOrEmpty:entity.title]) {
                noteEntity.noteContent = entity.title;
            }else {
                continue;
            }
            noteEntity.timeStamp = entity.modifyDate;
            [arrayM addObject:noteEntity];
            [noteEntity release];
        }
    }
    _transtotalCount = (int)arrayM.count;
    if (arrayM.count > 0) {
        if (_transferController != nil) {
            [_transferController release];
            _transferController = nil;
        }
        IMBBaseInfo *baseInfo = (IMBBaseInfo *)sender;
        NSDictionary *iCloudDic = [_delegate getiCloudAccountViewCollection];
        _otheriCloudManager = [[iCloudDic objectForKey:baseInfo.uniqueKey] iCloudManager];
        [_otheriCloudManager setDelegate:self];
        _transferController = [[IMBTransferViewController alloc] initWithType:Category_iCloudDriver withDelegate:self withTransfertype:TransferSync];
        [_transferController setDelegate:self];
        _transferController.isicloudView = YES;
        if (![IMBSoftWareInfo singleton].isRegistered) {
//            _annoyTimer = [NSTimer scheduledTimerWithTimeInterval:progresstimer target:self selector:@selector(showAlert) userInfo:nil repeats:YES];
        }
//        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:nil];
        [self animationAddTransferView:_transferController.view];
        if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"contact_id_91", nil)]];
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [_otheriCloudManager getNoteContent];
            [_otheriCloudManager addNoteData:arrayM];
            [arrayM release];
        });
    }else {
        //弹出警告确认框
        NSString *str = nil;
        str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        [arrayM release];
    }
}

- (void)transfranDic:(NSDictionary *)noteDic {
  
    NSArray *dataAry = nil;
    int count = 0;
    if (noteDic != nil) {
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"%@",noteDic]];
        dataAry = [noteDic objectForKey:@"records"];
        count = (int)dataAry.count;
    }

    for (int i = 0; i <= 100; i++) {
        if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
            [_transferController transferProgress:i];
        }
    }
    double delayInSeconds = 2.0;

    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (_annoyTimer != nil) {
            [_annoyTimer invalidate];
            _annoyTimer = nil;
        }
        if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
            [_transferController transferComplete:count TotalCount:_transtotalCount];
        }
    });
}

- (void)showEditErrorTip {
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_Modify_Failed", nil),CustomLocalizedString(@"MenuItem_id_60", nil)];
    [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

- (void)showAddErrorTip {
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_Add_Failed", nil),CustomLocalizedString(@"MenuItem_id_60", nil)];
    [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

- (void)showDeleteErrorTip {
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_Delete_Failed", nil),CustomLocalizedString(@"MenuItem_id_60", nil)];
    [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

- (void)reloadTableView {
    _isSearch = NO;
    [_itemTableView reloadData];
    if (_dataSourceArray.count > 0) {
        NSInteger row = [_itemTableView selectedRow];
        if (row == 0) {
            [self changeSonTableViewData:0];
        }else {
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }
    }
}

- (void)netWorkFaultInterrupt {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertText:CustomLocalizedString(@"iCloudLogin_View_Tips2", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_REFRESH_NOTEVIEW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_noteEditView release],_noteEditView = nil;
    [_notesEntity release],_notesEntity = nil;
    [_noteManagerInNormal release],_noteManagerInNormal = nil;
    if (_editButton != nil) {
        [_editButton release],
        _editButton = nil;
    }
    if (_cancelButton != nil) {
        [_cancelButton release],
        _cancelButton = nil;
    }
    [super dealloc];
}

@end
