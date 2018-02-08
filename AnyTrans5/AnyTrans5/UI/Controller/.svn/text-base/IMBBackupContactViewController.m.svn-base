//
//  IMBBackupContactViewController.m
//  AnyTrans
//
//  Created by long on 16-7-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBackupContactViewController.h"
#import "IMBContactSqliteManager.h"
#import "IMBAddressBookDataEntity.h"
#import "IMBCheckBoxCell.h"
#import "StringHelper.h"
#import "TempHelper.h"
#import "DateHelper.h"
#import "NSString+Category.h"
@interface IMBBackupContactViewController ()

@end

@implementation IMBBackupContactViewController
@synthesize contentCustomView = _contentCustomView;
@synthesize nameTextField = _nameTextField;
@synthesize companyTextField = _companyTextField;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithProductVersion:(SimpleNode *)node withDelegate:(id)delegate WithIMBBackupDecryptAbove4:(IMBBackupDecryptAbove4 *)abve4 {
    if ([super initWithNibName:@"IMBBackupContactViewController" bundle:nil]) {
        _delegate = delegate;
        _category = Category_Contacts;
        _simpleNode = node;
        _decryptAbove4 = abve4;
    
    }
    return self;
}

-(id)initiCloudWithiCloudBackUp:(IMBiCloudBackup *)icloudBackup WithDelegate:(id)delegate{
    if ([super initWithNibName:@"IMBBackupContactViewController" bundle:nil]) {
        _delegate = delegate;
        _category = Category_Contacts;
        _iCloudBackUp = icloudBackup;
        _isiCloud = YES;
        _isiCloudView = YES;
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        NSMutableArray *disAry = nil;
        if (_isSearch) {
            disAry = _researchdataSourceArray;
        }else{
            disAry = _dataSourceArray;
        }
        if (disAry.count <= 0) {
            NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_61", nil)];
            NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
            [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
            [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
            [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
            [_noDataTitle setAttributedStringValue:as];
            [_noDataTitle setSelectable:NO];
            [as release];
            as = nil;
            return ;
        }
        IMBAddressBookDataEntity *entity = [disAry objectAtIndex:[_itemTableView selectedRow]];
        [self showSingleContactContent:entity];

    });
 }

-(void)awakeFromNib{
    _isloadingPopBtn= YES;
    [super awakeFromNib];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_nodataImageView setImage:[StringHelper imageNamed:@"noData_contact"]];
    [_itemTableView setBackgroundColor:[NSColor clearColor]];
    _isloadingPopBtn = YES;
    [_rightBgView setIsGradientColorNOCornerPart3:YES];
    [_contactBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    _itemTableView.allowsMultipleSelection = NO;
    [_rightLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_topWhiteView setIsBommt:YES];
    [_topWhiteView setBackgroundColor:[NSColor clearColor]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        IMBContactSqliteManager *contactMarkManager = nil;
        if (_isiCloud) {
            contactMarkManager = [[IMBContactSqliteManager alloc] initWithiCloudBackup:_iCloudBackUp withType:_iCloudBackUp.iOSVersion];
        }else{
            contactMarkManager = [[IMBContactSqliteManager alloc] initWithAMDevice:nil backupfilePath:_simpleNode.backupPath withDBType:_simpleNode.productVersion WithisEncrypted:_simpleNode.isEncrypt withBackUpDecrypt:_decryptAbove4];
        }
        [contactMarkManager querySqliteDBContent] ;
        dispatch_async(dispatch_get_main_queue(), ^{
            _dataSourceArray = [contactMarkManager.dataAry retain];
            if (_dataSourceArray != nil && _dataSourceArray.count > 0) {
                 [_contactBox setContentView:_dataView];
                [_itemTableView reloadData];
            }else{
                [_contactBox setContentView:_noDataView];
                NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_61", nil)];
                NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
                [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
                [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
                [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
                [_noDataTitle setAttributedStringValue:as];
                [_noDataTitle setSelectable:NO];
                [as release];
                as = nil;
            }
            [self changeSonTableViewData:0];
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        });
    });
}

- (void)changeSkin:(NSNotification *)notification
{
//    [_loadingView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [_nodataImageView setImage:[StringHelper imageNamed:@"noData_contact"]];
    [_itemTableView setBackgroundColor:[NSColor clearColor]];
    [_rightBgView setIsGradientColorNOCornerPart3:YES];
    [_rightLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_61", nil)];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)] range:NSMakeRange(0, as.length)];
    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, as.length)];
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_noDataTitle setAttributedStringValue:as];
    [_noDataTitle setSelectable:NO];
    [as release];
    as = nil;
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count > [_itemTableView selectedRow]) {
        IMBAddressBookDataEntity *entity = [disAry objectAtIndex:[_itemTableView selectedRow]];
        [self showSingleContactContent:entity];
    }
    [_topWhiteView setNeedsDisplay:YES];
    [_rightBgView setNeedsDisplay:YES];
    [_sortRightPopuBtn setNeedsDisplay:YES];
    [_selectSortBtn setNeedsDisplay:YES];
    [_loadingAnimationView setNeedsDisplay:YES];
    [self.view setNeedsDisplay:YES];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <=0) {
        return 0;
    }
    if (disAry != nil) {
        return [disAry count];
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return nil;
    }
    IMBAddressBookDataEntity *entity = [disAry objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:@"Title"]) {
        return entity.allName;
    }else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
        return [NSNumber numberWithBool:entity.checkState];
    }
    return nil;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    NSTableView *atableView = [aNotification object];
    NSInteger row = [atableView selectedRow];
    if (row != -1) {
        [self changeSonTableViewData:row];
    }
}

- (void)tableView:(NSTableView *)tableView row:(NSInteger)index{
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return ;
    }
    IMBAddressBookDataEntity *entity = [disAry objectAtIndex:index];
    entity.checkState = !entity.checkState;
    int checkCount = 0;
    for (IMBAddressBookDataEntity *entity in disAry) {
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
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([[tableColumn identifier] isEqualToString:@"CheckCol"]) {
        IMBCheckBoxCell *boxCell = (IMBCheckBoxCell *)cell;
        boxCell.outlineCheck = YES;
    }
}

- (NSDragOperation)tableView:(NSTableView *)tableView validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
    return NSDragOperationNone;
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
        for (IMBAddressBookDataEntity *entity in disAry) {
            entity.checkState = Check;
        }
    }else if ( sender == UnChecked){
        for (IMBAddressBookDataEntity *entity in disAry) {
            entity.checkState = UnChecked;
        }
    }
    [_itemTableView  reloadData];
}

- (void)changeSonTableViewData:(NSInteger)row {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return ;
    }

    NSInteger count = disAry.count;
    if (count == 0) {
        [_companyTextField setHidden:YES];
        [_nameTextField setHidden:YES];
        NSArray *views = _contentCustomView.subviews;
        if (views != nil && views.count > 0) {
            for (long i = views.count - 1; i >= 0; i--) {
                NSView *view = [views objectAtIndex:i];
                [view removeFromSuperview];
            }
        }
    } else {
        if (disAry != nil && disAry.count > 0) {
                IMBAddressBookDataEntity *entity = [disAry objectAtIndex:row];
                [self showSingleContactContent:entity];
        }
    }
}

- (void)showSingleContactContent:(IMBAddressBookDataEntity *)entity {
    if (entity != nil) {
        if (entity.image != nil) {
            NSImage *newImage = [[NSImage alloc]initWithData:[TempHelper createHeadThumbnail:entity.image withWidth:62 withHeight:62]];
            //            NSImage *newImage = [[NSImage alloc]initWithData:[IMBHelper scalingImage:entity.image withLenght:200]];
            [_headImgView setWantsLayer:YES];
            [_headImgView.layer setCornerRadius:32];
            [_headImgView setImage:newImage];
//            [_headBgImgView setImage:[StringHelper imageNamed:@"contactBg"]];
        }else {
            [_headImgView setImage:[StringHelper imageNamed:@"contact_show"]];
        }
        [_nameTextField setHidden:NO];
        [_nameTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [_nameTextField setStringValue:entity.allName];
        if ([StringHelper stringIsNilOrEmpty:entity.companyName]) {
            [_companyTextField setHidden:YES];
        }else {
            [_companyTextField setHidden:NO];
            [_companyTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            [_companyTextField setStringValue:entity.companyName];
            //                [_companyTextField sizeToFit];
        }

        [self showContentVeiw:entity];
    }else{
        NSArray *views = _contentCustomView.subviews;
        if (views != nil && views.count > 0) {
            for (long i = views.count - 1; i < views.count; i--) {
                NSView *view = [views objectAtIndex:i];
                [view removeFromSuperview];
            }
        }
        [_nameTextField setStringValue:@"  "];
        [_companyTextField setStringValue:@" "];
    }
}

- (void)showContentVeiw:(IMBAddressBookDataEntity *)entity {
    float height = 0;
    int count = -1;
    NSArray *views = _contentCustomView.subviews;
    if (views != nil && views.count > 0) {
        for (long i = views.count - 1; i < views.count; i--) {
            NSView *view = [views objectAtIndex:i];
            [view removeFromSuperview];
        }
    }
    if (entity.birthdayDate != 0) {
        count += 1;
        [self setHomeTextString:CustomLocalizedString(@"contact_id_89", nil) withCounts:count];
        count += 1;
       
        [self setTextViewString:[DateHelper dateFrom2001ToString:entity.birthdayDate withMode:0] withCounts:count];
    
        if (entity.creationDate == 0) {
            count += 1;
            [self setLineWhiteViewCount:count];
        }
    }
    if (entity.creationDate != 0) {
        count += 1;
        [self setHomeTextString:CustomLocalizedString(@"backup_id_text_1", nil) withCounts:count];
        count += 1;
        [self setTextViewString:[DateHelper dateFrom2001ToString:entity.creationDate withMode:0] withCounts:count];
        count += 1;
        [self setLineWhiteViewCount:count];
    }
    if (entity.numberArray != nil && entity.numberArray.count > 0) {
        for (IMBAddressBookMultDataEntity *multe in entity.numberArray) {
            count += 1;
            NSString *str = nil;
            if ([multe.lableType isEqualToString:@"mobile"]) {
                str = CustomLocalizedString(@"contact_id_40", nil);
            }else if ([multe.lableType isEqualToString:@"other"]){
                str = CustomLocalizedString(@"MenuItem_id_30", nil);
            }else if ([multe.lableType isEqualToString:@"main"]){
                str = CustomLocalizedString(@"contact_id_7", nil);
            }else if ([multe.lableType isEqualToString:@"home fax"]){
                str = CustomLocalizedString(@"contact_id_10", nil);
            }else if ([multe.lableType isEqualToString:@"work fax"]){
                str = CustomLocalizedString(@"contact_id_11", nil);
            }else if ([multe.lableType isEqualToString:@"other fax"]){
                str = CustomLocalizedString(@"contact_id_12", nil);
            }else if ([multe.lableType isEqualToString:@"Notes"]){
                str = CustomLocalizedString(@"contact_id_91", nil);
            }
            [self setHomeTextString:str withCounts:count];
            count += 1;
            [self setTextViewString:multe.multValue withCounts:count];
        }
        count += 1;
        [self setLineWhiteViewCount:count];
    }
    if (entity.emailArray != nil && entity.emailArray.count > 0) {
        for (IMBAddressBookMultDataEntity *multe in entity.emailArray) {
            count += 1;
            [self setHomeTextString:multe.lableType withCounts:count];
            count += 1;
            [self setTextViewString:multe.multValue withCounts:count];
        }
        count += 1;
        [self setLineWhiteViewCount:count];
    }
    if (entity.URLArray != nil && entity.URLArray.count > 0) {
        for (IMBAddressBookMultDataEntity *multe in entity.URLArray) {
            count += 1;
            [self setHomeTextString:multe.lableType withCounts:count];
            count += 1;
            [self setTextViewString:multe.multValue withCounts:count];
        }
        count += 1;
        [self setLineWhiteViewCount:count];
    }
    //todo 地址
    if (entity.streetArray != nil && entity.streetArray.count > 0) {
        for (IMBAddressBookMultDataEntity *multe in entity.streetArray) {
            if (multe.multiArray != nil && multe.multiArray.count > 0) {
                count += 1;
                [self setHomeTextString:multe.lableType withCounts:count];
                for (IMBAddressBookDetailEntity *detail in multe.multiArray) {
                    count += 1;
                    if ([detail.entityType isEqualToString:@"country"]) {
                        [self setTextViewString:detail.detailValue withCounts:count];
                    }else if ([detail.entityType isEqualToString:@"street"]) {
                        [self setTextViewString:detail.detailValue withCounts:count];
                    }else if ([detail.entityType isEqualToString:@"postal code"]) {
                        [self setTextViewString:detail.detailValue withCounts:count];
                    }else if ([detail.entityType isEqualToString:@"city"]) {
                        [self setTextViewString:detail.detailValue withCounts:count];
                    }else if ([detail.entityType isEqualToString:@"country code"]) {
                        [self setTextViewString:detail.detailValue withCounts:count];
                    }else if ([detail.entityType isEqualToString:@"state"]) {
                        [self setTextViewString:detail.detailValue withCounts:count];
                    }
                }
                count += 1;
                [self setLineWhiteViewCount:count];
            }
        }
    }
    //dateArray
    if (entity.dateArray != nil && entity.dateArray.count > 0) {
        for (IMBAddressBookMultDataEntity *multe in entity.dateArray) {
            count += 1;
            [self setHomeTextString:multe.lableType withCounts:count];
            count += 1;
            [self setTextViewString:[DateHelper dateFrom2001ToString:[multe.multValue doubleValue] withMode:0] withCounts:count];
        }
        count += 1;
        [self setLineWhiteViewCount:count];
    }
    //relatedArray
    if (entity.relatedArray != nil && entity.relatedArray.count > 0) {
        for (IMBAddressBookMultDataEntity *multe in entity.relatedArray) {
            count += 1;
            [self setHomeTextString:multe.lableType withCounts:count];
            count += 1;
            [self setTextViewString:multe.multValue withCounts:count];
        }
        count += 1;
        [self setLineWhiteViewCount:count];
    }
    //specialURLArray
    if (entity.specialURLArray != nil && entity.specialURLArray.count > 0) {
        for (IMBAddressBookMultDataEntity *multe in entity.specialURLArray) {
            if (multe.multiArray != nil && multe.multiArray.count > 0) {
                count += 1;
                for (IMBAddressBookDetailEntity *detail in multe.multiArray) {
                    count += 1;
                    if ([detail.entityType isEqualToString:@"user"]) {
                        [self setTextViewString:detail.detailValue withCounts:count];
                    }else if ([detail.entityType isEqualToString:@"service"]) {
                        [self setHomeTextString:detail.detailValue withCounts:count];
                    }
                }
            }
        }
        count += 1;
        [self setLineWhiteViewCount:count];
    }
    //imArray
    if (entity.IMArray != nil && entity.IMArray.count > 0) {
        for (IMBAddressBookMultDataEntity *multe in entity.IMArray) {
            if (multe.multiArray != nil && multe.multiArray.count > 0) {
                count += 1;
                [self setHomeTextString:multe.lableType withCounts:count];
                NSString *textString = @"";
                count += 1;
                for (IMBAddressBookDetailEntity *detail in multe.multiArray) {
                    if ([detail.entityType isEqualToString:@"user"]) {
                        if ([StringHelper stringIsNilOrEmpty:textString]) {
                            textString = detail.detailValue;
                        }else {
                            textString = [detail.detailValue stringByAppendingString:textString];
                        }
                    }else if ([detail.entityType isEqualToString:@"service"]) {
                        textString = [textString stringByAppendingString:[NSString stringWithFormat:@"(%@)",detail.detailValue]];
                    }
                }
                [self setTextViewString:textString withCounts:count];
            }
        }
        count += 1;
        [self setLineWhiteViewCount:count];
    }
    if (![StringHelper stringIsNilOrEmpty:entity.notes]) {
        count += 1;
        [self setHomeTextString:CustomLocalizedString(@"Calendar_id_11", nil) withCounts:count];
        count += 1;
        NSTextView *textView = [[NSTextView alloc] init];
        [textView setEditable:YES];
        [textView setSelectable:YES];
        [textView setDrawsBackground:NO];
        [textView setFrame:NSMakeRect(40, (count * 20), 330, 40)];
        height = [self setTextViewForString:[entity.notes stringByReplacingOccurrencesOfString:@"\n" withString:@" "] withTextVeiw:textView withDelete:entity.isDeleted];
        
        [textView setEditable:NO];
        [textView setSelectable:NO];
        [textView setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
        [_contentCustomView addSubview:textView];
        [textView release];
    }
    
    [_contentCustomView setFrameSize:NSMakeSize(_contentCustomView.frame.size.width, (count * 21) + height)];
}

- (void)setHomeTextString:(NSString *)textString withCounts:(int)count {
    if ([StringHelper stringIsNilOrEmpty:textString]) {
        return;
    }
    NSTextField *homeText = [[NSTextField alloc] init];
    [homeText setBordered:NO];
    [homeText setAlignment:NSLeftTextAlignment];
    [homeText setDrawsBackground:NO];
    [homeText setStringValue:textString];
    [homeText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [homeText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [homeText setFrame:NSMakeRect(10, (count * 20) -2, 80, 16)];
    [homeText sizeToFit];
    [homeText setEditable:NO];
    [homeText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
    [_contentCustomView addSubview:homeText];
    [homeText release];
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
        fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, [StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)], NSForegroundColorAttributeName, [NSNumber numberWithInt:1], NSStrikethroughStyleAttributeName, [NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName, nil];
    }else {
        fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, [NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName, [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,nil];
    }
    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    [drawStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    float changeHeight = [layoutManager usedRectForTextContainer:textContainer].size.height;
    [textView setFrameSize:NSMakeSize(textView.frame.size.width, changeHeight)];
    [[textView textStorage] setAttributedString:drawStr];
    
    return changeHeight;
}

- (void)setTextViewString:(NSString *)textString withCounts:(int)count {
    if ([textString contains:@"\n"]) {
        textString = [textString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    }
    NSTextView *textView = [[NSTextView alloc] init];
    [textView setEditable:YES];
    [textView setSelectable:YES];
    [textView setAlignment:NSLeftTextAlignment];
    [textView setDrawsBackground:NO];
    [textView setString:textString];
    [textView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [textView setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [textView setFrame:NSMakeRect(8, (count * 20)+4, 330, 40)];
    [textView setEditable:NO];
    [textView setSelectable:NO];
    [textView setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
    [_contentCustomView addSubview:textView];
    [textView release];
}

- (void)setLineWhiteViewCount:(int)count {
    IMBWhiteView *whiteView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(0, (count * 20)+4  +6, _contentCustomView.frame.size.width - 60, 1)];
    [whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [whiteView setAutoresizingMask: NSViewMaxYMargin|NSViewMinXMargin|NSViewWidthSizable];
    [_contentCustomView addSubview:whiteView];
    [whiteView release];
}

- (NSMutableAttributedString *)stringStyle:(NSString *)string {
    NSMutableAttributedString *deleteString = [[[NSMutableAttributedString alloc] initWithString:string] autorelease];
    
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingMiddle];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)], NSForegroundColorAttributeName, textParagraph, NSParagraphStyleAttributeName, [NSNumber numberWithInt:1], NSStrikethroughStyleAttributeName, [NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName, nil];
    [deleteString addAttributes:dic range:NSMakeRange(0, deleteString.length)];
    return deleteString;
}

- (IBAction)sortRightPopuBtn:(id)sender {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return ;
    }
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
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"allName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
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
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"allName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [disAry sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        //        [_topPopuBtn setTitle:[_topPopuBtn titleOfSelectedItem]];
    }else if (item.tag == 4){
        _isAscending = NO;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"allName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
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
    [self changeSonTableViewData:row];
}
- (IBAction)sortSelectedPopuBtn:(id)sender {
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    if (disAry.count <= 0) {
        return ;
    }
    NSMenuItem *item = [_selectSortBtn selectedItem];
    NSInteger tag = [_selectSortBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _selectSortBtn.itemArray) {
        [menuItem setState:NSOffState];
    }
    if (tag == 1) {
        for (IMBAddressBookDataEntity *note in disAry) {
            note.checkState = Check;
        }
        
        //        [_sortRightPopuBtn setTitle:CustomLocalizedString(@"showMenu_id_1", nil)];
    }else if (tag == 2){
        for (IMBAddressBookDataEntity *note in disAry) {
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
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"allName CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray filteredArrayUsingPredicate:predicate]];
        if (_researchdataSourceArray.count <=0) {
            [_companyTextField setHidden:YES];
            [_nameTextField setHidden:YES];
            NSArray *views = _contentCustomView.subviews;
            if (views != nil && views.count > 0) {
                for (long i = views.count - 1; i >= 0; i--) {
                    NSView *view = [views objectAtIndex:i];
                    [view removeFromSuperview];
                }
            }
        }
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
    }
    [self changeSonTableViewData:0];;
    [_itemTableView reloadData];
}

@end
