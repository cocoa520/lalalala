//
//  IMBAndroidCalendarViewController.m
//  AnyTrans
//
//  Created by smz on 17/7/17.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBAndroidCalendarViewController.h"
#import "StringHelper.h"
#import "IMBCenterTextFieldCell.h"
#import "CalendarConversioniCloud.h"
#import "IMBADCalendarToiCloud.h"
#import "IMBAndroidMainPageViewController.h"
#import "IMBAndroidViewController.h"

@interface IMBAndroidCalendarViewController ()

@end

@implementation IMBAndroidCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initwithAndroid:(IMBAndroid *)android withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    if (self == [super initwithAndroid:android withCategoryNodesEnum:category withDelegate:delegate]) {
        _dataSourceArray = [[android getCalendarContent].reslutArray retain];
    }
    return self;
    
}

- (void)dealloc {
    if (_accountEntity != nil) {
        [_accountEntity release];
        _accountEntity = nil;
    }
    if (_currentEntity != nil) {
        [_currentEntity release];
        _currentEntity = nil;
    }
    if (_sonArray != nil) {
        [_sonArray release];
        _sonArray = nil;
    }
    [super dealloc];
}

#pragma mark - 多语言
- (void)doChangeLanguage:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [super doChangeLanguage:notification];
        if (_currentEntity != nil) {
            [self showSingleCalendarAndReminderContent:_currentEntity];
        }
        [self setNoDataViewImageAndText];
        [self setNoDataViewImageAndText2];
        
    });
    
}

#pragma mark - 切换皮肤
- (void)changeSkin:(NSNotification *)notification{

    [_topWhiteView setNeedsDisplay:YES];
    [_topwhiteView2 setNeedsDisplay:YES];
    [self setNoDataViewImageAndText];
    [self setNoDataViewImageAndText2];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [_loadingAnimationView setNeedsDisplay:YES];
    [_loadingView setNeedsDisplay:YES];
    [self.view setNeedsDisplay:YES];
    [_selectSortBtn setNeedsDisplay:YES];
    [_sortRightPopuBtn setNeedsDisplay:YES];
    [_rightLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_topLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_middleLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [rightTextView setNeedsDisplay:YES];
    if (_currentEntity != nil) {
        [self showSingleCalendarAndReminderContent:_currentEntity];;
    }
}

-(void)awakeFromNib {
     _isAndroid = YES;
    [_leftTableView setDelegate:self];
    [_leftTableView setDataSource:self];
    [_leftTableView setListener:self];
    [_middleTableView setDelegate:self];
    [_middleTableView setDataSource:self];
    [_middleTableView setListener:self];
    _middleTableView.menu.delegate = self;
    [_leftTableView setBackgroundColor:[NSColor clearColor]];
    [_middleTableView setBackgroundColor:[NSColor clearColor]];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [_rightLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_topLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_middleLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [rightTextView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    if (_dataSourceArray.count <= 0) {
        [self setNoDataViewImageAndText];
        [_mainBox setContentView:_noDataView];
    }else {
        [_mainBox setContentView:_detailView];
        NSInteger row = [_leftTableView selectedRow];
        [_leftTableView deselectRow:row];
    }
    _sonArray = [[NSMutableArray alloc] init];
    _searchArray = [[NSMutableArray alloc] init];
    _isloadingPopBtn = YES;
    [super awakeFromNib];
}

#pragma mark - noData界面加载
- (void)setNoDataViewImageAndText {
    [_noDataImage setImage:[StringHelper imageNamed:@"noData_calendar"]];
    [_noDataText setDelegate:self];
    [_noDataText setSelectable:YES];
    NSString *overStr1 = CustomLocalizedString(@"noData_subTitle1", nil);
    NSString *promptStr1 = [[[NSString stringWithFormat:CustomLocalizedString(@"noData_subTitle", nil),CustomLocalizedString(@"MenuItem_id_62", nil)] stringByAppendingString:@" "] stringByAppendingString:overStr1];
    NSString *promptStr = [[[NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_62", nil)] stringByAppendingString:@" "] stringByAppendingString:promptStr1];
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_noDataText setLinkTextAttributes:linkAttributes];
    
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
    [[_noDataText textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
}

- (void)setNoDataViewImageAndText2 {
    [_noDataImage2 setImage:[NSImage imageNamed:@"noData_calendar"]];
    NSString *promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_62", nil)];
    [_noDataText2 setDelegate:self];
    
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_noDataText2 setLinkTextAttributes:linkAttributes];
    [_noDataText2 setSelectable:NO];
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_noDataText2 textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
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

#pragma mark - NSTableViewDataSource,NSTableViewDelegate相关方法
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_isSearch) {
        if (tableView == _leftTableView) {
            return _researchdataSourceArray.count;
        } else {
            return _sonArray.count;
        }
    } else {
        if (tableView == _leftTableView) {
            return _dataSourceArray.count;
        } else {
            return _sonArray.count;
        }
    }
    return 0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSArray *displayArr = nil;
    if (tableView.tag == 0) {
        if (_isSearch) {
            displayArr = _researchdataSourceArray;
        }else{
            displayArr = _dataSourceArray;
        }
        IMBCalendarAccountEntity *accountEntity = [displayArr objectAtIndex:row];
        if ([tableColumn.identifier isEqualToString:@"Title"]) {
            if ([IMBHelper stringIsNilOrEmpty:accountEntity.displayName]) {
                return accountEntity.accountName;
            } else {
                return accountEntity.displayName;
            }
        }else if ([tableColumn.identifier isEqualToString:@"CheckCol"]) {
            
            return[NSNumber numberWithInt:accountEntity.checkState];
            
        } else if ([tableColumn.identifier isEqualToString:@"Count"]) {
            
            if (accountEntity.eventArray.count <= 0) {
                return @"--";
            } else {
                return [NSString stringWithFormat:@"%ld",accountEntity.eventArray.count];
                
            }
        }
        
    } else if (tableView.tag == 1 && _sonArray.count > 0) {
        
        IMBADCalendarEntity *calenderEntity = [_sonArray objectAtIndex:row];
        
        if ([tableColumn.identifier isEqualToString:@"Title"]) {
            if ([calenderEntity.calendarTitle isEqualToString:@""] || calenderEntity.calendarTitle == nil) {
                return CustomLocalizedString(@"Common_id_10", nil);
            } else {
                return calenderEntity.calendarTitle;
            }
            
        }else if ([tableColumn.identifier isEqualToString:@"CheckCol"]){
            return[NSNumber numberWithBool:calenderEntity.checkState];
        }
    }
    return @"";
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 40;
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSArray *displayArr = nil;
    if (tableView.tag == 0) {
        if (_isSearch) {
            displayArr = _researchdataSourceArray;
        }else{
            displayArr = _dataSourceArray;
        }
        if (displayArr.count <= 0) {
            return;
        }

        IMBCalendarAccountEntity *calenderEntity = [displayArr objectAtIndex:row];
        if (![@"CheckCol" isEqualToString:tableColumn.identifier]) {
            
            if ([@"Count" isEqualToString:tableColumn.identifier]) {
                IMBCenterTextFieldCell *centerTextCell = (IMBCenterTextFieldCell *)cell;
                centerTextCell.isRighVale = YES;
            }
            
            IMBCenterTextFieldCell *centerTextCell = (IMBCenterTextFieldCell *)cell;
            centerTextCell.isDeleted = calenderEntity.isDeleted;
        }
    } else if (tableView.tag == 1 && _sonArray.count > 0) {
        
        if (![@"CheckCol" isEqualToString:tableColumn.identifier]) {
            IMBADCalendarEntity *calenderEntity = [_sonArray objectAtIndex:row];
            IMBCenterTextFieldCell *centerTextCell = (IMBCenterTextFieldCell *)cell;
            centerTextCell.isDeleted = calenderEntity.isDeleted;
        }
    }
    
}

-(void)tableView:(NSTableView *)tableView row:(NSInteger)index{
    NSArray *displayArr = nil;
    if (tableView.tag == 0) {
        if (_isSearch) {
            displayArr = _researchdataSourceArray;
        }else{
            displayArr = _dataSourceArray;
        }
        IMBCalendarAccountEntity *calAndRemEntity = [displayArr objectAtIndex:index];
        if (calAndRemEntity.checkState == SemiChecked) {
            calAndRemEntity.checkState = Check;
        } else {
            calAndRemEntity.checkState = !calAndRemEntity.checkState;
        }
        for (IMBCalendarAccountEntity *calAndRemEntity  in displayArr) {
            
                for (IMBADCalendarEntity *calendarEntity in calAndRemEntity.eventArray) {
                    if (calAndRemEntity.checkState == Check) {
                        calendarEntity.checkState = Check;
                        
                    } else if (calAndRemEntity.checkState == UnChecked) {
                        calendarEntity.checkState = UnChecked;
                    }
                }
            
        }
        [_leftTableView reloadData];
        [_middleTableView reloadData];
        
    } else {
        
        float checkCount = 0;
        float unCheckCount = 0;
        IMBADCalendarEntity *calendarEntity = [_sonArray objectAtIndex:index];
        calendarEntity.checkState = !calendarEntity.checkState;
        
        for (IMBADCalendarEntity *calendarEntity in _sonArray) {
            if (calendarEntity.checkState == Check) {
                checkCount ++;
            } else if (calendarEntity.checkState == UnChecked) {
                unCheckCount ++;
            }
        }
        if (checkCount == _sonArray.count) {
            _accountEntity.checkState = Check;
        } else if (unCheckCount == _sonArray.count) {
            _accountEntity.checkState = UnChecked;
        } else {
            _accountEntity.checkState = SemiChecked;
        }
        [_middleTableView reloadData];
        [_leftTableView reloadData];
    }
    
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    NSTableView *atableView = [aNotification object];
    [self changeSonTableViewData:atableView];
}

- (void)changeSonTableViewData:(NSTableView *)tableView {
    if (tableView.tag == 0) {
        
        NSArray *displayArr = nil;
        if (_isSearch) {
            displayArr = _researchdataSourceArray;
        }else{
            displayArr = _dataSourceArray;
        }
        
        int row = 0;
        row = (int)[tableView selectedRow];
        if (row <= 0) {
            row = 0;
        }
        if (displayArr.count > 0) {
            IMBCalendarAccountEntity *accountEntity = [displayArr objectAtIndex:row];
            if (_accountEntity != nil) {
                [_accountEntity release];
                _accountEntity = nil;
            }
            _accountEntity = [accountEntity retain];
        } else {
            if (_accountEntity != nil) {
                [_accountEntity release];
                _accountEntity = nil;
            }
        }
        
        if (_sonArray != nil) {
            [_sonArray release];
            _sonArray = nil;
        }
        _sonArray = [_accountEntity.eventArray retain];
        if (_sonArray.count < 1) {
            [_noDataBox setHidden:NO];
            [self setNoDataViewImageAndText2];
            [_noDataBox setContentView:_noDataView2];
            return;
        }else {
            [_noDataBox setHidden:YES];
            [_middleTableView reloadData];
        }
        
    } else {
        float count = _sonArray.count;
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
            
            NSArray *displayArr = _sonArray;
            if (displayArr != nil && displayArr.count > 0) {
                if (row == -1) {
                    return;
                }
                IMBADCalendarEntity *entity = [displayArr objectAtIndex:row];
                if (_currentEntity != nil) {
                    [_currentEntity release];
                    _currentEntity = nil;
                }
                _currentEntity = [entity retain];
                [self showSingleCalendarAndReminderContent:entity];
            }
        }
    }
    
    
}

- (void)showSingleCalendarAndReminderContent:(IMBADCalendarEntity *)entity {
    float height = 0;
    int count = -1;
    NSArray *views = rightCustomView.subviews;
    if (views != nil && views.count > 0) {
        for (int i = (int)views.count - 1; i < views.count; i--) {
            NSView *view = [views objectAtIndex:i];
            [view removeFromSuperview];
        }
    }
    if (![entity.calendarTitle isEqualToString:@""] && entity.calendarTitle != nil) {
        [rightTextView setHidden:NO];
        [self setTextViewForStringDrawing:entity.calendarTitle withDelete:entity.isDeleted];
    }else {
        [rightTextView setHidden:NO];
        [self setTextViewForStringDrawing:CustomLocalizedString(@"Common_id_10", nil) withDelete:entity.isDeleted];
    }
    if (entity.calendarDateStart != 0) {
        count += 1;
        [self setHomeTextString:CustomLocalizedString(@"icloud_reminder_11", nil) withCounts:count withIsDelete:entity.isDeleted];
        if (entity.isDeleted == YES) {
            NSString *startStr = @"";
            if ([IMBSoftWareInfo singleton].isRegistered) {
                startStr = entity.calendarDateStart;
            }else{
                if (entity.isDeleted) {
                    startStr = [IMBHelper isaddMosaicTextStr:entity.calendarDateStart];
                }else{
                    startStr = entity.calendarDateStart;
                }
            }
            NSMutableAttributedString *whiteString = [[NSMutableAttributedString alloc]initWithString:startStr];
            NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:12];
            
            NSDictionary *dic = nil;
            if ([IMBSoftWareInfo singleton].isRegistered) {
                dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName, font,NSFontAttributeName, nil];
            }else{
                dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName,font,NSFontAttributeName, nil];
            }
            [whiteString addAttributes:dic range:NSMakeRange(0, whiteString.length)];
            
            [self setTextViewStringFromDeleted:whiteString withCounts:count withFrontTitle:CustomLocalizedString(@"icloud_reminder_11", nil)];
            [whiteString release];
        }else {
            [self setTextViewString:entity.calendarDateStart withCounts:count withfrontTitle:CustomLocalizedString(@"icloud_reminder_11", nil)];
        }
        if (entity.calendarEndTime == 0) {
            count += 1;
            [self setLineWhiteViewCount:count];
        }
    }
    if (entity.calendarEndTime != 0) {
        count += 1;
        NSString *startStr = @"";
        if ([IMBSoftWareInfo singleton].isRegistered) {
            startStr = entity.calendarDateEnd;
        }else{
            if (entity.isDeleted) {
                startStr = [IMBHelper isaddMosaicTextStr:entity.calendarDateEnd];
            }else{
                startStr = entity.calendarDateEnd;
            }
        }
        [self setHomeTextString:CustomLocalizedString(@"icloud_reminder_12", nil) withCounts:count withIsDelete:entity.isDeleted];
        if (entity.isDeleted == YES) {
            NSMutableAttributedString *whiteString = [[NSMutableAttributedString alloc]initWithString:startStr];
            
            NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:12];
            NSDictionary *dic = nil;
            if ([IMBSoftWareInfo singleton].isRegistered) {
                dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName,font,NSFontAttributeName, nil];
            }else{
                dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName,font,NSFontAttributeName, nil];
            }
            [whiteString addAttributes:dic range:NSMakeRange(0, whiteString.length)];
            
            [self setTextViewStringFromDeleted:whiteString withCounts:count withFrontTitle:CustomLocalizedString(@"icloud_reminder_12", nil)];
            [whiteString release];
        }else {
            [self setTextViewString:entity.calendarDateEnd withCounts:count withfrontTitle:CustomLocalizedString(@"icloud_reminder_12", nil)];
        }
        count += 1;
        [self setLineWhiteViewCount:count];
    }
    if (![entity.calendarDescription isEqualToString:@""] && entity.calendarDescription != nil) {
        count += 1;
        [self setHomeTextString:CustomLocalizedString(@"contact_id_91", nil) withCounts:count withIsDelete:entity.isDeleted];
        
        NSTextView *textView = [[NSTextView alloc] init];
        [textView setEditable:YES];
        [textView setSelectable:YES];
        [textView setDrawsBackground:NO];
        [textView setFrame:NSMakeRect(60,(count * 26), rightCustomView.frame.size.width - 120, 20)];
        [textView setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
        
        NSString *amosaicStr = @"";
        if (![IMBSoftWareInfo singleton].isRegistered) {
            NSString *endStr = @"";
            if (entity.isDeleted) {
                endStr = [IMBHelper isaddMosaicTextStr:entity.calendarDescription];
            }else{
                endStr = entity.calendarDescription;
            }
            
            if (endStr != nil) {
                amosaicStr = endStr;
            }else{
                amosaicStr = entity.calendarDescription;
            }
        }else{
            amosaicStr = entity.calendarDescription;
        }
        
        height = [self setTextViewForString:amosaicStr withTextVeiw:textView withDelete:entity.isDeleted];
        [textView setEditable:NO];
        [textView setSelectable:NO];
        float mainHeight = textView.frame.origin.y + height + 20;
        if (mainHeight > 480) {
            [rightCustomView setFrame:NSMakeRect(rightCustomView.frame.origin.x, rightCustomView.frame.origin.y, rightCustomView.frame.size.width, mainHeight)];
        } else {
            [rightCustomView setFrame:NSMakeRect(rightCustomView.frame.origin.x, rightCustomView.frame.origin.y, rightCustomView.frame.size.width, 480)];
        }
        [rightCustomView addSubview:textView];
        [textView release];
    }
}

#pragma mark - draw text文本
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
    if ([IMBSoftWareInfo singleton].isRegistered) {
        if (isDeleted == YES) {
            fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, [NSColor redColor], NSForegroundColorAttributeName, [NSFont fontWithName:@"Helvetica Neue" size:18], NSFontAttributeName, nil];
        }else {
            fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:18],NSFontAttributeName,nil];
        }
    }else{
        if (isDeleted == YES) {
            fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, [NSColor redColor], NSForegroundColorAttributeName, [NSFont fontWithName:@"Helvetica Neue" size:18], NSFontAttributeName, nil];
        }else {
            fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:18],NSFontAttributeName,nil];
        }
    }
    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    [drawStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    float changeHeight = [layoutManager usedRectForTextContainer:textContainer].size.height + 20-4;
    [rightScrollView setFrameSize:NSMakeSize(rightScrollView.frame.size.width, changeHeight)];
    [[rightTextView textStorage] setAttributedString:drawStr];
    
    return changeHeight;
}

- (void)setHomeTextString:(NSString *)textString withCounts:(int)count withIsDelete:(BOOL) isDelete{
    NSTextField *homeText = [[NSTextField alloc] init];
    [homeText setBordered:NO];
    [homeText setAlignment:NSLeftTextAlignment];
    [homeText setDrawsBackground:NO];
    if (isDelete) {
        NSMutableAttributedString *whiteString = [[NSMutableAttributedString alloc]initWithString:textString];
        NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:12];
        NSDictionary *dic = nil;
        if ([IMBSoftWareInfo singleton].isRegistered) {
            dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName, font,NSFontAttributeName, nil];
        }else{
            dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName,font,NSFontAttributeName, nil];
        }
        [whiteString addAttributes:dic range:NSMakeRange(0, whiteString.length)];
        [homeText setAttributedStringValue:whiteString];
    }else{
        [homeText setStringValue:textString];
    }
    [homeText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [homeText setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [homeText setFrame:NSMakeRect(10, (count * 26)-4, 80, 24)];
    [homeText sizeToFit];
    [homeText setEditable:NO];
    
    [homeText setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
    float mainHeight = homeText.frame.origin.y + 24;
    if (mainHeight > 480) {
        [rightCustomView setFrame:NSMakeRect(rightCustomView.frame.origin.x, rightCustomView.frame.origin.y, rightCustomView.frame.size.width, mainHeight)];
    } else {
        [rightCustomView setFrame:NSMakeRect(rightCustomView.frame.origin.x, rightCustomView.frame.origin.y, rightCustomView.frame.size.width, 480)];
    }
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
    [textView setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSRect rect = [IMBHelper calcuTextBounds:@"111111111111111" fontSize:12];
    [textView setFrame:NSMakeRect(rect.size.width + 14, (count * 26), rightCustomView.frame.size.width - 100, 20)];
    [textView setEditable:NO];
    [textView setSelectable:NO];
    [textView setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
    float mainHeight = textView.frame.origin.y + 20;
    if (mainHeight > 480) {
        [rightCustomView setFrame:NSMakeRect(rightCustomView.frame.origin.x, rightCustomView.frame.origin.y, rightCustomView.frame.size.width, mainHeight)];
    } else {
        [rightCustomView setFrame:NSMakeRect(rightCustomView.frame.origin.x, rightCustomView.frame.origin.y, rightCustomView.frame.size.width, 480)];
    }
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
    NSRect rect = [IMBHelper calcuTextBounds:@"111111111111111" fontSize:12];
    [textView setFrame:NSMakeRect(rect.size.width +14,(count * 26), rightCustomView.frame.size.width - 100, 20)];
    [textView setEditable:NO];
    [textView setSelectable:NO];
    [textView setAutoresizingMask: NSViewMaxYMargin|NSViewMaxXMargin];
    float mainHeight = textView.frame.origin.y + 20;
    if (mainHeight > 480) {
        [rightCustomView setFrame:NSMakeRect(rightCustomView.frame.origin.x, rightCustomView.frame.origin.y, rightCustomView.frame.size.width, mainHeight)];
    } else {
        [rightCustomView setFrame:NSMakeRect(rightCustomView.frame.origin.x, rightCustomView.frame.origin.y, rightCustomView.frame.size.width, 480)];
    }
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
    if ([IMBSoftWareInfo singleton].isRegistered) {
        if (isDeleted == YES) {
            fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, [NSColor redColor], NSForegroundColorAttributeName,  [NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName, nil];
        }else {
            fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)],NSForegroundColorAttributeName,nil];
        }
    }else{
        if (isDeleted == YES) {
            fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, [NSColor redColor], NSForegroundColorAttributeName,  [NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName, nil];
        }else {
            fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)],NSForegroundColorAttributeName,nil];
        }
    }
    
    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:0.0];
    [drawStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    float changeHeight = [layoutManager usedRectForTextContainer:textContainer].size.height;
    NSRect rect = [IMBHelper calcuTextBounds:@"111111111111111" fontSize:12];
    [textView setFrame:NSMakeRect(rect.size.width - 20, textView.frame.origin.y, textView.frame.size.width, changeHeight)];
    [[textView textStorage] setAttributedString:drawStr];
    return changeHeight;
}

- (void)setLineWhiteViewCount:(int)count {
    IMBWhiteView *whiteView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(4, (count * 26)+4, rightCustomView.frame.size.width - 24, 1)];
    [whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [whiteView setAutoresizingMask: NSViewMaxYMargin|NSViewWidthSizable|NSViewMinXMargin];
    [rightCustomView addSubview:whiteView];
    [whiteView release];
}

#pragma mark - 中间的tableView的排序 、全选
- (IBAction)sortSelectedPopuBtn:(id)sender {
    NSMenuItem *item = [_selectSortBtn selectedItem];
    NSInteger tag = [_selectSortBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _selectSortBtn.itemArray) {
        [menuItem setState:NSOffState];
    }
    
    NSMutableArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <= 0) {
        return ;
    }
    
    if (tag == 1) {
        for (IMBCalendarAccountEntity *dataEntity in displayArray) {
            for (IMBADCalendarEntity *calendarEntity in dataEntity.eventArray) {
                calendarEntity.checkState = Check;
                if (dataEntity.accountId == calendarEntity.parentID) {
                    dataEntity.checkState = Check;
                }
            }
        }
    }else if (tag == 2){
        for (IMBCalendarAccountEntity *dataEntity in displayArray) {
            for (IMBADCalendarEntity *calendarEntity in dataEntity.eventArray) {
                calendarEntity.checkState = UnChecked;
                if (dataEntity.accountId == calendarEntity.parentID) {
                    dataEntity.checkState = UnChecked;
                }
            }
        }
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
    [_leftTableView reloadData];
    [_middleTableView reloadData];
}

- (IBAction)sortRightPopuBtn:(id)sender {
    
    if (_sonArray.count <= 0) {
        return ;
    }
    NSMenuItem *item = [_sortRightPopuBtn selectedItem];
    
    NSString *titleStr = CustomLocalizedString(@"SortBy_Name", nil);
    if (![TempHelper stringIsNilOrEmpty:titleStr]) {
        NSRect rect = [TempHelper calcuTextBounds:titleStr fontSize:12];
        int w = rect.size.width + 30;
        if ((rect.size.width + 30) < 50) {
            w = 50;
        }
        
        [_sortRightPopuBtn setFrame:NSMakeRect(_topWhiteView.frame.size.width  - w -12, _sortRightPopuBtn.frame.origin.y, w, _sortRightPopuBtn.frame.size.height)];
        [_sortRightPopuBtn setTitle:titleStr];
    }
    
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
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"calendarTitle" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_sonArray sortUsingDescriptors:sortDescriptors];
        [_middleTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        [_sortRightPopuBtn setTitle:[_sortRightPopuBtn titleOfSelectedItem]];
    }else if (tag == 2){
        
    }else if (item.tag == 3){
        _isAscending = YES;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"calendarTitle" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_sonArray sortUsingDescriptors:sortDescriptors];
        [_middleTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }else if (item.tag == 4){
        _isAscending = NO;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"calendarTitle" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_sonArray sortUsingDescriptors:sortDescriptors];
        [_middleTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }
    NSString *str1 = CustomLocalizedString(@"SortBy_Name", nil);
    [_sortRightPopuBtn setTitle:str1];
    [_sortRightPopuBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSInteger row = [_middleTableView selectedRow];
    IMBADCalendarEntity *entity = [_sonArray objectAtIndex:row];
    [self showSingleCalendarAndReminderContent:entity];
}

#pragma mark - 最左边的tableView的排序 、全选
- (IBAction)newSortSelectedPopuBtn:(id)sender {
    NSMenuItem *item = [_selectSortBtn2 selectedItem];
    NSInteger tag = [_selectSortBtn2 selectedItem].tag;
    for (NSMenuItem *menuItem in _selectSortBtn2.itemArray) {
        [menuItem setState:NSOffState];
    }
    
    NSMutableArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <= 0) {
        return ;
    }
    
    if (tag == 1) {
        for (IMBCalendarAccountEntity *dataEntity in displayArray) {
            dataEntity.checkState = Check;
            for (IMBADCalendarEntity *calendarEntity in dataEntity.eventArray) {
                calendarEntity.checkState = Check;
            }
        }
    }else if (tag == 2){
        for (IMBCalendarAccountEntity *dataEntity in displayArray) {
            dataEntity.checkState = UnChecked;
            for (IMBADCalendarEntity *calendarEntity in dataEntity.eventArray) {
                calendarEntity.checkState = UnChecked;
            }
        }
    }
    [item setState:NSOnState];
    NSRect rect1 = [TempHelper calcuTextBounds:item.title fontSize:12];
    int wide = 0;
    if (rect1.size.width >170) {
        wide = 170;
    }else{
        wide = rect1.size.width;
    }
    [_selectSortBtn2 setFrame:NSMakeRect(-2,_selectSortBtn2.frame.origin.y , wide +30, _selectSortBtn2.frame.size.height)];
    [_selectSortBtn2 setTitle:[_selectSortBtn2 titleOfSelectedItem]];
    [_leftTableView reloadData];
    [_middleTableView reloadData];
}

- (IBAction)newSortRightPopuBtn:(id)sender {
    
    NSMutableArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }
    else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <= 0) {
        return ;
    }
    NSMenuItem *item = [_sortRightPopuBtn2 selectedItem];
    
    NSString *titleStr = CustomLocalizedString(@"SortBy_Name", nil);
    if (![TempHelper stringIsNilOrEmpty:titleStr]) {
        NSRect rect = [TempHelper calcuTextBounds:titleStr fontSize:12];
        int w = rect.size.width + 30;
        if ((rect.size.width + 30) < 50) {
            w = 50;
        }
        
        [_sortRightPopuBtn2 setFrame:NSMakeRect(_topwhiteView2.frame.size.width  - w -12, _sortRightPopuBtn2.frame.origin.y, w, _sortRightPopuBtn2.frame.size.height)];
        [_sortRightPopuBtn2 setTitle:titleStr];
    }
    
    [_sortRightPopuBtn2 setTitle:[_sortRightPopuBtn2 titleOfSelectedItem]];
    NSInteger tag = [_sortRightPopuBtn2 selectedItem].tag;
    for (NSMenuItem *menuItem in _sortRightPopuBtn2.itemArray) {
        if (menuItem.tag != 1) {
            [menuItem setState:NSOffState];
        }
    }
    
    if (item.tag == 1) {
        for (NSMenuItem *menuItem in _sortRightPopuBtn2.itemArray) {
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
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [displayArray sortUsingDescriptors:sortDescriptors];
        [_leftTableView reloadData];
        [_middleTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        [_sortRightPopuBtn2 setTitle:[_sortRightPopuBtn2 titleOfSelectedItem]];
    }else if (tag == 2){
        
    }else if (item.tag == 3){
        _isAscending = YES;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [displayArray sortUsingDescriptors:sortDescriptors];
        [_leftTableView reloadData];
        [_middleTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }else if (item.tag == 4){
        _isAscending = NO;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [displayArray sortUsingDescriptors:sortDescriptors];
        [_leftTableView reloadData];
        [_middleTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }
    NSString *str1 = CustomLocalizedString(@"SortBy_Name", nil);
    [_sortRightPopuBtn2 setTitle:str1];
    [_sortRightPopuBtn2 setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSInteger row = [_leftTableView selectedRow];
    IMBCalendarAccountEntity *entity = [displayArray objectAtIndex:row];
    if (_sonArray != nil) {
        [_sonArray release];
        _sonArray = nil;
    }
    _sonArray = [entity.eventArray retain];;
    [_leftTableView reloadData];
    [_middleTableView reloadData];
    
}

#pragma mark - search
- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn {
    _isSearch = YES;
    _searchFieldBtn = searchBtn;
    [_researchdataSourceArray removeAllObjects];
    
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSMutableArray *allEvnentAryM = [[[NSMutableArray alloc] init] autorelease];
        for (IMBCalendarAccountEntity *entity in _dataSourceArray) {
            [allEvnentAryM addObjectsFromArray:entity.eventArray];
        }
        
        NSMutableArray *searchArym = [[[NSMutableArray alloc] init] autorelease];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"calendarTitle CONTAINS[cd] %@ ",searchStr];
        [searchArym addObjectsFromArray:[allEvnentAryM  filteredArrayUsingPredicate:predicate]];
        for (IMBADCalendarEntity *evnetEntity in searchArym) {
            int checkCount = 0;
            int unCheckCount = 0;
            if (evnetEntity.checkState == Check) {
                checkCount ++;
            } else if (evnetEntity.checkState == UnChecked) {
                unCheckCount ++;
            }
            
            IMBCalendarAccountEntity *newEntity = [[IMBCalendarAccountEntity alloc] init];
            for (int i = 0; i < _dataSourceArray.count; i ++) {
                IMBCalendarAccountEntity *entity = [_dataSourceArray objectAtIndex:i];
                if (entity.accountId == evnetEntity.parentID) {
                    newEntity.accountId = entity.accountId;
                    newEntity.displayName = entity.displayName;
                    newEntity.accountName = entity.accountName;
                    [newEntity.eventArray addObjectsFromArray:entity.eventArray];
                    [newEntity.eventArray removeAllObjects];
                    [newEntity.eventArray addObject:evnetEntity];
                    break;
                }
            }
            if (checkCount == searchArym.count) {
                newEntity.checkState = Check;
            } else if (unCheckCount == searchArym.count) {
                newEntity.checkState = UnChecked;
            } else {
                newEntity.checkState = SemiChecked;
            }
            BOOL haveSameGroup = NO;
            for (int y = 0; y < _researchdataSourceArray.count ; y ++) {
                IMBCalendarAccountEntity *_reEntity = [_researchdataSourceArray objectAtIndex:y];
                if (newEntity.accountId == _reEntity.accountId) {
                    haveSameGroup = YES;
                    [_reEntity.eventArray addObjectsFromArray:newEntity.eventArray];
                    break;
                }
            }
            if (!haveSameGroup) {
                [_researchdataSourceArray addObject:newEntity];
            }
            [newEntity release], newEntity = nil;
        }
        if (searchArym.count == 0) {
            [self setNoDataViewImageAndText];
            [_mainBox setContentView:_noDataView];
        }
        NSNotification *noti = [NSNotification notificationWithName:@"" object:_leftTableView];
        NSNotification *noti1 = [NSNotification notificationWithName:@"" object:_middleTableView];
        [self tableViewSelectionDidChange:noti];
        [self tableViewSelectionDidChange:noti1];
        [_mainBox setContentView:_detailView];
        
    }else{
        _isSearch = NO;
        NSNotification *noti = [NSNotification notificationWithName:@"" object:_leftTableView];
        NSNotification *noti1 = [NSNotification notificationWithName:@"" object:_middleTableView];
        [self tableViewSelectionDidChange:noti];
        [self tableViewSelectionDidChange:noti1];
        [self loadCheckBoxState];
        [_mainBox setContentView:_detailView];
    }
    [_leftTableView reloadData];
    [_middleTableView reloadData];
}

#pragma mark - 刷新
- (void)androidReload:(id)sender {
    [self disableFunctionBtn:NO];
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [_searchFieldBtn.searchField setEnabled:NO];
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];

    //检查apk是否赋予权限
    if (_delegate != nil && [_delegate respondsToSelector:@selector(checkDeviceGreantedPermission:)] ) {
        [_delegate checkDeviceGreantedPermission:ReloadFunctionType];
    }
}

- (void)reloadData {
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    if (_category == Category_Calendar) {
        
        [_android queryCalendarDetailInfo];
        _dataSourceArray = [[_android getCalendarContent].reslutArray retain];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self disableFunctionBtn:YES];
            [_searchFieldBtn.searchField setEnabled:YES];
            if (_dataSourceArray.count <= 0) {
                [self setNoDataViewImageAndText];
                [_mainBox setContentView:_noDataView];
            } else {
                
                NSNotification *noti = [NSNotification notificationWithName:@"" object:_leftTableView];
                NSNotification *noti1 = [NSNotification notificationWithName:@"" object:_middleTableView];
                [self tableViewSelectionDidChange:noti];
                [self tableViewSelectionDidChange:noti1];
                [_mainBox setContentView:_detailView];
                [_leftTableView reloadData];
                [_middleTableView reloadData];
            }
            [_loadingAnimationView endAnimation];
            if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                [_delegate refeashBadgeConut:(int)[_android getCalendarContent].reslutCount WithCategory:_category];
            }
            
        });
    }
}

- (void)cancelReload {
    if (_dataSourceArray.count <= 0) {
        [self setNoDataViewImageAndText];
        [_mainBox setContentView:_noDataView];
    } else {
        [_mainBox setContentView:_detailView];
    }
    [self disableFunctionBtn:YES];
    [_searchFieldBtn.searchField setEnabled:YES];
    [_loadingAnimationView endAnimation];
}

- (void)reloadTableView {
    _isSearch = NO;
    if (_dataSourceArray.count > 0) {
        NSInteger row = [_leftTableView selectedRow];
        if (row == 0) {
            [self changeSonTableViewData:_leftTableView];
        }else {
            [_leftTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }
    }
}

#pragma mark - 更新CheckBox的状态
- (void)loadCheckBoxState {
        float checkCount = 0;
        float unCheckCount = 0;
    for (IMBADCalendarEntity *calendarEntity in _sonArray) {
            if (calendarEntity.checkState == Check) {
                checkCount ++;
            } else if (calendarEntity.checkState == UnChecked) {
                unCheckCount ++;
            }
        }
        if (checkCount == _sonArray.count) {
            _accountEntity.checkState = Check;
        } else if (unCheckCount == _sonArray.count) {
            _accountEntity.checkState = UnChecked;
        } else {
            _accountEntity.checkState = SemiChecked;
        }
    
    [_middleTableView reloadData];
    [_leftTableView reloadData];
}

#pragma mark - 返回按钮
- (void)doBack:(id)sender {
    [super doBack:sender];
    if (_searchFieldBtn != nil) {
        [self doSearchBtn:nil withSearchBtn:_searchFieldBtn];
    }
}

//传输准备进度开始
- (void)transferPrepareFileStart:(NSString *)file {
    NSLog(@"准备进度开始");
}

//传输准备进度结束
- (void)transferPrepareFileEnd {
    NSLog(@"准备进度结束");
}

//传输进度
- (void)transferProgress:(float)progress {
    NSLog(@"传输进度值：%f", progress);
}

//当前传输文件的名字或者路径
- (void)transferFile:(NSString *)file {
    NSLog(@"当前传输文件的名字或者路径");
}

//分析进度
- (void)parseProgress:(float)progress {
    NSLog(@"分析进度");
}

//当前分析文件的名字或者路径
- (void)parseFile:(NSString *)file {
    NSLog(@"当前分析文件的名字或者路径");
}

//全部传输成功
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
    NSLog(@"全部传输成功");
}

- (void)menuWillOpen:(NSMenu *)menu {
    [self initAndroidDeviceMenuItem];
    [self initAndroidiCloudMenuItem];
}
@end