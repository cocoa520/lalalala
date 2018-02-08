//
//  IMBBackupCalendarViewController.m
//  AnyTrans
//
//  Created by long on 16-7-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBackupCalendarViewController.h"
#import "IMBCalAndRemEntity.h"
#import "IMBCenterTextFieldCell.h"
#import "IMBCalendarSqliteManager.h"
#import "DateHelper.h"
#import "StringHelper.h"
#import "TempHelper.h"
#import "IMBCheckBoxCell.h"
@interface IMBBackupCalendarViewController ()

@end

@implementation IMBBackupCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithProductVersion:(SimpleNode *)node withDelegate:(id)delegate WithIMBBackupDecryptAbove4:(IMBBackupDecryptAbove4 *)abve4{
    if ([super initWithNibName:@"IMBBackupCalendarViewController" bundle:nil]) {
        _category = Category_Calendar;
        _delegate = delegate;
        _node = node;
        _decryptAbove4 = abve4;
    }
    return self;
}

- (id)initiCloudWithiCloudBackUp:(IMBiCloudBackup *)icloudBackup WithDelegate:(id)delegate{
    if ([super initWithNibName:@"IMBBackupCalendarViewController" bundle:nil]) {
        _category = Category_Calendar;
        _delegate = delegate;
        _iCloudBackup = icloudBackup;
        _isiCloud = YES;
        _isiCloudView = YES;
    }
    return self;
}

-(void)loadData:(NSMutableArray *)ary{

}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_62", nil)];
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [_noDataTextStr setAttributedStringValue:as];
        [_noDataTextStr setSelectable:NO];

        NSInteger row = [_itemTableView selectedRow];
        if (row < 0) {
            return ;
        }
        IMBCalAndRemEntity *entity = [_dataSourceArray objectAtIndex:row];
        [self showSingleCalendarAndReminderContent:entity];
    });

}

-(void)awakeFromNib{
    _isloadingPopBtn = YES;
    [super awakeFromNib];
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_rigthBgView setIsGradientColorNOCornerPart3:YES];
    [_nodataImageView setImage:[StringHelper imageNamed:@"noData_calendar"]];
//    [_itemTableView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_itemTableView setBackgroundColor:[NSColor clearColor]];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_loadingAnimationView startAnimation];
    [_calendarBox setContentView:_loadingView];
    [_topWhiteView setIsBommt:YES];
    [_topWhiteView setBackgroundColor:[NSColor clearColor]];
    _itemTableView.allowsMultipleSelection = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        IMBCalendarSqliteManager *bookMarkManager = nil;
        if (_isiCloud) {
            bookMarkManager = [[IMBCalendarSqliteManager alloc] initWithiCloudBackup:_iCloudBackup withType:_iCloudBackup.iOSVersion];
        }else{
            bookMarkManager = [[IMBCalendarSqliteManager alloc] initWithAMDevice:nil backupfilePath:_node.backupPath withDBType:_node.productVersion WithisEncrypted:_node.isEncrypt withBackUpDecrypt:_decryptAbove4];
        }
        
        [bookMarkManager querySqliteDBContent];
        dispatch_async(dispatch_get_main_queue(), ^{
            _dataSourceArray = [bookMarkManager.dataAry retain];
            if (_dataSourceArray != nil &&_dataSourceArray.count >0) {
                [_calendarBox setContentView:_calendarDataView];
                [_itemTableView reloadData];
            }else{
                [_calendarBox setContentView:_noDataView];
                NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_62", nil)];
                NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
                [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
                [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
                [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
                [_noDataTextStr setAttributedStringValue:as];
                [_noDataTextStr setSelectable:NO];
            }
        });
    });
    [(IMBWhiteView *) self.view setIsGradientColorNOCornerPart3:YES];
}

- (void)changeSkin:(NSNotification *)notification
{
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
//    [_itemTableView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_rigthBgView setIsGradientColorNOCornerPart3:YES];
    [_rigthBgView setNeedsDisplay:YES];
    [_itemTableView setBackgroundColor:[NSColor clearColor]];
    [_lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_62", nil)];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_noDataTextStr setAttributedStringValue:as];
    [_noDataTextStr setSelectable:NO];
    [_nodataImageView setImage:[StringHelper imageNamed:@"noData_calendar"]];
    NSInteger row = [_itemTableView selectedRow];
    if (_dataSourceArray.count > row) {
        IMBCalAndRemEntity *entity = [_dataSourceArray objectAtIndex:row];
        [self showSingleCalendarAndReminderContent:entity];
    }
    [_topWhiteView setNeedsDisplay:YES];
    [_rigthBgView setNeedsDisplay:YES];
    [_sortRightPopuBtn setNeedsDisplay:YES];
    [_selectSortBtn setNeedsDisplay:YES];
    [_loadingAnimationView setNeedsDisplay:YES];
    [(IMBWhiteView *) self.view setIsGradientColorNOCornerPart3:YES];
    [self.view setNeedsDisplay:YES];
    [_loadingView setNeedsDisplay:YES];
}

#pragma mark - NSTableViewDataSource,NSTableViewDelegate相关方法
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return 0;
    }
    if (disAry.count != 0) {
        return disAry.count;
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return @"";
    }
    IMBCalAndRemEntity *calenderEntity = [disAry objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:@"Title"]) {
        return calenderEntity.summary;
    }else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
        return[NSNumber numberWithBool:calenderEntity.checkState];
    }
    return @"";
}


-(void)tableView:(NSTableView *)tableView row:(NSInteger)index{
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return ;
    }
    IMBCalAndRemEntity *calAndRemEntity = [disAry objectAtIndex:index];
    calAndRemEntity.checkState = !calAndRemEntity.checkState;
    int checkCount = 0;
    for (IMBCalAndRemEntity *entity in disAry) {
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
    [_itemTableView reloadData];
}

-(void)setAllselectState:(CheckStateEnum)sender{
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return ;
    }
    if (sender == Check||sender == SemiChecked ) {
        for (IMBCalAndRemEntity *entity in disAry) {
            entity.checkState = Check;
        }
    }else if (sender == UnChecked){
        for (IMBCalAndRemEntity *entity in disAry) {
            entity.checkState = UnChecked;
        }
    }
    [_itemTableView  reloadData];
}


- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    NSTableView *atableView = [aNotification object];
    [self changeSonTableViewData:atableView];
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([[tableColumn identifier] isEqualToString:@"CheckCol"]) {
        IMBCheckBoxCell *boxCell = (IMBCheckBoxCell *)cell;
        boxCell.outlineCheck = YES;
    }
}

- (void)changeSonTableViewData:(NSTableView *)tableView {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return ;
    }
    NSInteger count = 0;
    count = disAry.count;
    int row = 0;
    row = (int)[tableView selectedRow];
    if (count == 0) {
        NSArray *views = rightCustomView.subviews;
        if (views != nil && views.count > 0) {
            for (int i = (int)views.count - 1; i < views.count; i--) {
                NSView *view = [views objectAtIndex:i];
                [view removeFromSuperview];
            }
        }
        [rightTextView setHidden:YES];
    }else{
    
        if (disAry != nil && disAry.count > 0) {
            if (row == -1) {
                return;
            }
            IMBCalAndRemEntity *entity = [disAry objectAtIndex:row];
            [self showSingleCalendarAndReminderContent:entity];
        }
    }
}

- (void)showSingleCalendarAndReminderContent:(IMBCalAndRemEntity *)entity {
    float height = 0;
    int count = -1;
    NSArray *views = rightCustomView.subviews;
    if (views != nil && views.count > 0) {
        for (int i = (int)views.count - 1; i < views.count; i--) {
            NSView *view = [views objectAtIndex:i];
            [view removeFromSuperview];
        }
    }
    if (entity.summary != nil) {
        [rightTextView setHidden:NO];
        [self setTextViewForStringDrawing:entity.summary withDelete:entity.isDeleted];
    }else {
        [rightTextView setString:@""];
    }
    if (![entity.location isEqualToString:@""] && entity.location != nil) {
        count += 1;
        [self setHomeTextString:CustomLocalizedString(@"backup_id_text_5", nil) withCounts:count withIsDelete:entity.isDeleted];
        
        if (entity.isDeleted == YES) {
            NSMutableAttributedString *whiteString = [[NSMutableAttributedString alloc]initWithString:entity.location];
            NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:13];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName, [NSNumber numberWithInt:1], NSStrikethroughStyleAttributeName,font,NSFontAttributeName, nil];
            [whiteString addAttributes:dic range:NSMakeRange(0, whiteString.length)];
            [self setTextViewStringFromDeleted:whiteString withCounts:count withFrontTitle:CustomLocalizedString(@"backup_id_text_5", nil)];
            [whiteString release];
        }else {
            [self setTextViewString:entity.location withCounts:count withfrontTitle:CustomLocalizedString(@"backup_id_text_5", nil)];
        }
        count += 1;
        [self setLineWhiteViewCount:count];
    }
    if (entity.startTime != 0) {
        count += 1;
        [self setHomeTextString:CustomLocalizedString(@"backup_id_text_4", nil) withCounts:count withIsDelete:entity.isDeleted];

        [self setTextViewString:[DateHelper dateFrom2001ToString:entity.startTime withMode:2] withCounts:count withfrontTitle:CustomLocalizedString(@"backup_id_text_4", nil)];
        
        if (entity.endTime == 0) {
            count += 1;
            [self setLineWhiteViewCount:count];
        }
    }
    if (entity.endTime != 0) {
        count += 1;
        [self setHomeTextString:CustomLocalizedString(@"backup_id_text_3", nil) withCounts:count withIsDelete:entity.isDeleted];

        [self setTextViewString:[DateHelper dateFrom2001ToString:entity.endTime withMode:2] withCounts:count withfrontTitle:CustomLocalizedString(@"backup_id_text_3", nil)];

        count += 1;
        [self setLineWhiteViewCount:count];
    }
    if (entity.completionDate != 0) {
        count += 1;
        [self setHomeTextString:CustomLocalizedString(@"backup_id_text_2", nil) withCounts:count withIsDelete:entity.isDeleted];

        [self setTextViewString:[DateHelper longToHourDateString:entity.completionDate] withCounts:count withfrontTitle:CustomLocalizedString(@"backup_id_text_2", nil)];
    
    }
    if (![entity.url isEqualToString:@""] && entity.url != nil) {
        count += 1;
        [self setHomeTextString:CustomLocalizedString(@"List_Header_id_URL", nil) withCounts:count withIsDelete:entity.isDeleted];
        if (entity.isDeleted == YES) {
            //            NSMutableAttributedString *deleteStr = [IMBHelper stringStyle:entity.url];
            NSMutableAttributedString *whiteString = [[NSMutableAttributedString alloc]initWithString:entity.url];
            NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:13];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName, [NSNumber numberWithInt:1], NSStrikethroughStyleAttributeName,font,NSFontAttributeName, nil];
            [whiteString addAttributes:dic range:NSMakeRange(0, whiteString.length)];
            
            [self setTextViewStringFromDeleted:whiteString withCounts:count withFrontTitle:CustomLocalizedString(@"List_Header_id_URL", nil)];
            [whiteString release];
        }else {
            [self setTextViewString:entity.url withCounts:count withfrontTitle:CustomLocalizedString(@"List_Header_id_URL", nil)];
        }
    }
    if (![entity.description isEqualToString:@""] && entity.description != nil) {
        count += 1;
        [self setHomeTextString:CustomLocalizedString(@"MenuItem_id_17", nil) withCounts:count withIsDelete:entity.isDeleted];
        
        NSTextView *textView = [[NSTextView alloc] init];
        [textView setEditable:YES];
        [textView setSelectable:YES];
        [textView setDrawsBackground:NO];
        [textView setFrame:NSMakeRect(60, (count * 26), 370, 20)];
        [textView setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
        height = [self setTextViewForString:entity.description withTextVeiw:textView withDelete:entity.isDeleted];
        [textView setEditable:NO];
        [textView setSelectable:NO];
        [rightCustomView addSubview:textView];
        [textView release];
    }
    
    //    [rightCustomView setFrameSize:NSMakeSize(rightCustomView.frame.size.width, (count * 36) + height)];
}

- (float)setTextViewForStringDrawing:(NSString *)myString withDelete:(BOOL)isDeleted {
    NSMutableAttributedString *drawStr = [[[NSMutableAttributedString alloc] initWithString:myString] autorelease];
    
    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(rightTextView.frame.size.width, FLT_MAX)] autorelease];
    
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:4.0f];
    [textParagraph setAlignment:NSLeftTextAlignment];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingMiddle];
    
    NSDictionary *fontDic = nil;
    if (isDeleted == YES) {
        fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, [StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)], NSForegroundColorAttributeName, [NSNumber numberWithInt:1], NSStrikethroughStyleAttributeName, [NSFont fontWithName:@"Helvetica Neue light" size:18], NSFontAttributeName, nil];
    }else {
        fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName, [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName, [NSFont fontWithName:@"Helvetica Neue light" size:18],NSFontAttributeName,nil];
    }
    //[NSColor colorWithDeviceRed:87.f/255 green:87.f/255 blue:87.f/255 alpha:1.0],NSForegroundColorAttributeName,
    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    [drawStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    float changeHeight = [layoutManager usedRectForTextContainer:textContainer].size.height + 20;
    [rightScrollView setFrameSize:NSMakeSize(rightScrollView.frame.size.width, changeHeight)];
    [[rightTextView textStorage] setAttributedString:drawStr];
    
    return changeHeight;
}

- (void)setHomeTextString:(NSString *)textString withCounts:(int)count withIsDelete:(BOOL) isDelete{
    if ([StringHelper stringIsNilOrEmpty:textString]) {
        return;
    }
    NSTextField *homeText = [[NSTextField alloc] init];
    [homeText setBordered:NO];
    [homeText setAlignment:NSLeftTextAlignment];
    [homeText setDrawsBackground:NO];
    if (isDelete) {
        NSMutableAttributedString *whiteString = [[NSMutableAttributedString alloc]initWithString:textString];
        
        NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:13];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName, [NSNumber numberWithInt:1], NSStrikethroughStyleAttributeName,font,NSFontAttributeName, nil];
        [whiteString addAttributes:dic range:NSMakeRange(0, whiteString.length)];
        [homeText setAttributedStringValue:whiteString];
    }else{
        [homeText setStringValue:textString];
    }
    [homeText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [homeText setFont:[NSFont fontWithName:@"Helvetica Neue" size:13]];
    [homeText setFrame:NSMakeRect(10, (count * 26)-4, 80, 24)];
    [homeText sizeToFit];
    [homeText setEditable:NO];
    
    [homeText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
    [rightCustomView addSubview:homeText];
    [homeText release];
    
}

- (void)setTextViewString:(NSString *)textString withCounts:(int)count withfrontTitle:(NSString *)str{
    NSTextView *textView = [[NSTextView alloc] init];
    [textView setEditable:YES];
    [textView setSelectable:YES];
    [textView setAlignment:NSLeftTextAlignment];
    [textView setDrawsBackground:NO];
    [textView setString:textString];
    [textView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [textView setFont:[NSFont fontWithName:@"Helvetica Neue" size:13]];
    NSRect rect = [TempHelper calcuTextBounds:@"111111111111111" fontSize:13];
    [textView setFrame:NSMakeRect(rect.size.width +14, (count * 26), rightCustomView.frame.size.width - 100, 20)];
    [textView setEditable:NO];
    [textView setSelectable:NO];
    [textView setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
    [rightCustomView addSubview:textView];
    [textView release];
}

- (void)setTextViewStringFromDeleted:(NSMutableAttributedString *)textString withCounts:(int)count withFrontTitle:(NSString*)str{
    NSTextView *textView = [[NSTextView alloc] init];
    [textView setEditable:YES];
    [textView setSelectable:YES];
    [textView setAlignment:NSLeftTextAlignment];
    [textView setDrawsBackground:NO];
    [[textView textStorage] setAttributedString:textString];
    NSRect rect = [TempHelper calcuTextBounds:@"111111111111111" fontSize:13];
    [textView setFrame:NSMakeRect(rect.size.width +14, (count * 26), rightCustomView.frame.size.width - 100, 20)];
    //    [textView setTextColor:[NSColor redColor]];
    [textView setEditable:NO];
    [textView setSelectable:NO];
    [textView setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
    [rightCustomView addSubview:textView];
    [textView release];
}

- (float)setTextViewForString:(NSString *)myString withTextVeiw:(NSTextView *)textView withDelete:(BOOL)isDeleted {
    NSMutableAttributedString *drawStr = [[[NSMutableAttributedString alloc] initWithString:myString] autorelease];
    
    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(textView.frame.size.width, FLT_MAX)] autorelease];
    
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:2.0f];
    [textParagraph setAlignment:NSLeftTextAlignment];
    [textParagraph setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *fontDic = nil;
    if (isDeleted == YES) {
        fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, [NSColor redColor], NSForegroundColorAttributeName, [NSNumber numberWithInt:1], NSStrikethroughStyleAttributeName, [NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName, nil];
    }else {
        
        fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)],NSForegroundColorAttributeName,nil];
    }
    //[NSColor colorWithDeviceRed:87.f/255 green:87.f/255 blue:87.f/255 alpha:1.0],NSForegroundColorAttributeName,
    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    [drawStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    float changeHeight = [layoutManager usedRectForTextContainer:textContainer].size.height;
    //[textView setFrameOrigin:NSMakePoint(textView.frame.origin.x, textView.frame.origin.y - changeHeight + 14)];
    NSRect rect = [TempHelper calcuTextBounds:@"111111111111111" fontSize:13];
    [textView setFrame:NSMakeRect(rect.size.width +14, textView.frame.origin.y, textView.frame.size.width, changeHeight)];
    [[textView textStorage] setAttributedString:drawStr];
    
    return changeHeight;
}

- (void)setLineWhiteViewCount:(int)count {
    IMBWhiteView *whiteView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(0, (count * 26) + 4, rightCustomView.frame.size.width - 60, 1)];
    [whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [whiteView setAutoresizingMask: NSViewMaxYMargin|NSViewWidthSizable|NSViewMinXMargin];
    [rightCustomView addSubview:whiteView];
    [whiteView release];
}

- (IBAction)sortRightPopuBtn:(id)sender {
    NSMenuItem *item = [_sortRightPopuBtn selectedItem];
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
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"summary" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
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
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"summary" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_dataSourceArray sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        //        [_topPopuBtn setTitle:[_topPopuBtn titleOfSelectedItem]];
    }else if (item.tag == 4){
        _isAscending = NO;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"summary" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
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
    NSRect rect = [TempHelper calcuTextBounds:str1 fontSize:12];
    [_sortRightPopuBtn setFrame:NSMakeRect(_topWhiteView.frame.size.width - 30 - rect.size.width-12,_sortRightPopuBtn.frame.origin.y , rect.size.width +30, _sortRightPopuBtn.frame.size.height)];
    [_sortRightPopuBtn setTitle:str1];
    
    NSInteger row = [_itemTableView selectedRow];
    IMBCalAndRemEntity *entity = [_dataSourceArray objectAtIndex:row];
    [self showSingleCalendarAndReminderContent:entity];
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

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"summary CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray filteredArrayUsingPredicate:predicate]];
        if (_researchdataSourceArray.count <= 0) {
            NSArray *views = rightCustomView.subviews;
            if (views != nil && views.count > 0) {
                for (int i = (int)views.count - 1; i < views.count; i--) {
                    NSView *view = [views objectAtIndex:i];
                    [view removeFromSuperview];
                }
            }
            [rightTextView setHidden:YES];
        }
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
    }
    [self changeSonTableViewData:0];;
    [_itemTableView reloadData];
}


@end
