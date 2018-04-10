//
//  IMBCalendarViewController.m
//  AnyTrans
//
//  Created by smz on 17/7/25.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBCalendarViewController.h"
#import "IMBImageAndTitleButton.h"
#import "IMBScrollView.h"
#import "LoadingView.h"
#import "IMBCalendarContentView.h"
#import "IMBCalendarEditView.h"
#import "DownloadTextFieldView.h"
#import "IMBDatePicker.h"
#import "IMBPopupButton.h"
#import "IMBAnimation.h"
#import "IMBNotificationDefine.h"
#import "IMBDeviceMainPageViewController.h"
#import "IMBCenterTextFieldCell.h"
#import "IMBiCloudManager.h"
#import "IMBiCloudMainPageViewController.h"
#import "DateHelper.h"
#import "IMBGroupMenuItem.h"
#import "IMBGroupMenu.h"

@interface IMBCalendarViewController ()

@end

@implementation IMBCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    if (self == [super initWithIpod:ipod withCategoryNodesEnum:category withDelegate:delegate]) {
        _dataSourceArray = [[_information calendarArray] retain];
        _calendarManager = [[IMBCalendarsManager alloc] initWithAMDevice:_ipod.deviceHandle] ;
    }
    return self;
}

- (void)awakeFromNib {
    _isloadingPopBtn = YES;
    [super awakeFromNib];
    _itemTableViewcanDrag = NO;
    _itemTableViewcanDrop = NO;
    _collectionViewcanDrag = NO;
    _collectionViewcanDrop = NO;
    [self ConfigTextAttributes];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_editLoadingView setIsGradientColorNOCornerPart3:YES];
    _logManger = [IMBLogManager singleton];
    [_middleTableView setListener:self];
    [_middleTableView setFocusRingType:NSFocusRingTypeNone];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    
    _contentView = [[IMBCalendarContentView alloc] initWithFrame:NSMakeRect(0, 0, _contentScrollView.frame.size.width -15, _contentScrollView.frame.size.height - 5) WithCategory:Category_Calendar];
    [_contentView setHasEditBtn:YES];
    [_contentView setAutoresizesSubviews:YES];
    [_contentView setAutoresizingMask:NSViewHeightSizable|NSViewWidthSizable];
    [_contentScrollView setDocumentView:_contentView];
    
    _researchItemArray = [[NSMutableArray alloc] init];
    
    if (_dataSourceArray.count < 1) {
        [self configNoDataView];
        [_mainBox setContentView:_noDataView];
    }else {
        [_mainBox setContentView:_detailView];
        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    }
    
    [self doEditDetailCalendar];
    [self doSaveAndCancalMethod];

    [_topWhiteView setIsBommt:YES];
    [_topWhiteView setBackgroundColor:[NSColor clearColor]];
    [_middleTopView setIsBommt:YES];
    [_middleTopView setBackgroundColor:[NSColor clearColor]];
    
    [_startTimePicker setDelegate:self];
    [_endTimePicker setDelegate:self];
    //popupBtn
    for (NSMenuItem *item in _middleSelectPopBtn.itemArray) {
        if (item.tag == 0) {
            [item setTitle:CustomLocalizedString(@"Menu_Select_All", nil)];
            [item setState:NSOffState];
        }else if (item.tag == 1){
            [item setTitle:CustomLocalizedString(@"Menu_Select_All", nil)];
            [item setState:NSOffState];
        }else if (item.tag == 2){
            [item setTitle:CustomLocalizedString(@"Menu_Unselect_All", nil)];
            [item setState:NSOnState];
        }
    }
    
    [_middleSelectPopBtn setNeedsDisplay:YES];
    [_middleSelectPopBtn setTitle:CustomLocalizedString(@"Menu_Unselect_All", nil)];
    
    NSRect rect1 = [TempHelper calcuTextBounds:CustomLocalizedString(@"Menu_Unselect_All", nil) fontSize:12];
    int wide = 0;
    if (rect1.size.width >170) {
        wide = 170;
    }else{
        wide = rect1.size.width;
    }
    [_middleSelectPopBtn setFrame:NSMakeRect(-2,_middleSelectPopBtn.frame.origin.y , wide +30, _middleSelectPopBtn.frame.size.height)];
    
    for (NSMenuItem *item in [[_middleSortPopBtn menu] itemArray])
    {
        if (item.tag == 0) {
            [item setTitle:CustomLocalizedString(@"SortBy_Name", nil)];
            [item setState:NSOnState];
        }else if (item.tag == 1)
        {
            [item setTitle:CustomLocalizedString(@"SortBy_Name", nil)];
            [item setState:NSOnState];
        }else if (item.tag == 2)
        {
            [item setTitle:CustomLocalizedString(@"SortBy_Date", nil)];
        }else if (item.tag == 3)
        {
            [item setTitle:CustomLocalizedString(@"Sort_Ascend", nil)];
        }else if (item.tag == 4)
        {
            [item setTitle:CustomLocalizedString(@"Sort_Descend", nil)];
        }
    }
    NSString *titleStr = CustomLocalizedString(@"SortBy_Name", nil);
    if (![TempHelper stringIsNilOrEmpty:titleStr]) {
        NSRect rect = [TempHelper calcuTextBounds:titleStr fontSize:12];
        int w = rect.size.width + 30;
        if ((rect.size.width + 30) < 50) {
            w = 50;
        }
        [_middleSortPopBtn setFrame:NSMakeRect(_middleTopView.frame.size.width  - w -12, _sortRightPopuBtn.frame.origin.y, w, _sortRightPopuBtn.frame.size.height)];
        [_middleSortPopBtn setTitle:titleStr];
    }
}

#pragma mark - 配置文本属性
- (void)ConfigTextAttributes {
    
    [_summaryLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_summaryTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_locationLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_locationTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_urlLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_urlTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_notesLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_startTimeLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_endTimeLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_leftLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_middleLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_startTimePicker setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_endTimePicker setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
}

#pragma mark - 编辑
- (void)doEditDetailCalendar {
    
    _contentView.editBlock = ^{
        
        _isCalendarAdd = NO;
        [_calendarEditView setFrame:NSMakeRect(0, 0, _contentScrollView.frame.size.width -15, _contentScrollView.frame.size.height - 5)];
        [self disableFunctionBtn:NO];
        [_summaryLable setStringValue:CustomLocalizedString(@"Calendar_id_4", nil)];
        [_locationLable setStringValue:CustomLocalizedString(@"Calendar_id_5", nil)];
        [_urlLable setStringValue:CustomLocalizedString(@"Bookmark_id_2", nil)];
        [_notesLable setStringValue:[CustomLocalizedString(@"Calendar_id_11", nil) stringByReplacingOccurrencesOfString:@":" withString:@""]];
        [_startTimeLable setStringValue:[CustomLocalizedString(@"icloud_reminder_11", nil) stringByAppendingString:@":"]];
        [_endTimeLable setStringValue:[CustomLocalizedString(@"icloud_reminder_12", nil) stringByAppendingString:@":"]];
        
        if (_notesTextField != nil) {
            [_notesTextField release];
            _notesTextField = nil;
        }
        [_noteScrollView setHastopBorder:NO leftBorder:NO BottomBorder:NO rightBorder:NO];
        _notesTextField = [[IMBCalendarNoteEditView alloc] initWithFrame:NSMakeRect(0, 0, _noteScrollView.frame.size.width, _noteScrollView.frame.size.height)];
        [_noteScrollView setDocumentView:_notesTextField];
        [_notesTextField setAutoresizesSubviews:YES];
        [_notesTextField setIsEditing:YES];
        [_notesTextField setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin|NSViewWidthSizable|NSViewHeightSizable];
        
        //设置选组按钮
        [_groupButton setNewTag:_collectionEntity.tag];
        [_groupButton setFillColor:_collectionEntity.color];
        [_groupButton setIsHasBorder:YES];
        [_groupButton setBorderWidth:2];
        [_groupButton setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_groupButton setNeedsDisplay:YES];
        [_groupButton setMenu:[self createNavagationMenu]];
        
        [_textBoxOne setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_textBoxOne setIsHaveCorner:YES];
        [_textBoxThree setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_textBoxThree setIsHaveCorner:YES];
        [_textBoxTwo setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_textBoxTwo setIsHaveCorner:YES];
        [_textBoxFour setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_textBoxFour setIsHaveCorner:YES];
        
         //时间日历属性设置
         _startTimePicker.preferredPopoverEdge = NSMaxXEdge;
         _endTimePicker.preferredPopoverEdge = NSMaxXEdge;
        [_startTimePicker setFrameSize:NSMakeSize(160, 27)];
        [_startTimePicker setNeedsDisplay:YES];
        [_endTimePicker setFrameSize:NSMakeSize(160 ,27)];
        [_endTimePicker setNeedsDisplay:YES];
        
        NSInteger row = [_middleTableView selectedRow];
        NSArray *array = nil;
        if (_isSearch) {
            array = _researchItemArray;
        }else {
            array = _itemArray;
        }
        
        IMBCalendarEventEntity *calendarEvent = nil;
        if (row == -1) {
            return;
            
        }else if(row < [array count])
        {
            calendarEvent = [array objectAtIndex:row];
        }
        if (_currentShowCalendarEntity != nil) {
            [_currentShowCalendarEntity release],_currentShowCalendarEntity = nil;
        }
        _currentShowCalendarEntity = [calendarEvent retain];
        [_summaryTextField setStringValue:calendarEvent.summary?:@""];
        [_locationTextField setStringValue:calendarEvent.location?:@""];
        [_urlTextFiled setStringValue:calendarEvent.url?:@""];
        [_notesTextField.contentField setStringValue:calendarEvent.eventdescription?:@""];
        [_startTimePicker setDateValue:[DateHelper dateFromString:calendarEvent.startdate Formate:nil]];
        [_endTimePicker setDateValue:[DateHelper dateFromString:calendarEvent.enddate Formate:nil]];
        
        [_contentScrollView.layer removeAllAnimations];
        CATransition *transition = [CATransition animation];
        transition.delegate = self;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"moveIn";
        transition.subtype = kCATransitionFromBottom;
        [_contentScrollView setDocumentView:_calendarEditView];
        [_contentScrollView.layer addAnimation:transition forKey:@"transiton"];
        _isEdit = YES;
    };
    
}

#pragma mark - 保存和取消
- (void)doSaveAndCancalMethod {
    _calendarEditView.saveBlock = ^(IMBMyDrawCommonly *button){
        NSMutableArray *groupAry = nil;
        NSMutableArray *sonAry = nil;
        if (_isSearch) {
            groupAry = _researchdataSourceArray;
            sonAry = _researchItemArray;
        }else {
            groupAry = _dataSourceArray;
            sonAry = _itemArray;
        }
        
        [_calendarEditView setFrame:NSMakeRect(0, 0, _contentScrollView.frame.size.width -15, _contentScrollView.frame.size.height - 5)];
        if (button.tag == 601) {
            [self disableFunctionBtn:YES];
            int selectListRow = 0;
            if (_isCalendarAdd) {
                if (sonAry.count > 0) {
                    [sonAry removeObjectAtIndex:0];
                }
            }else {
                selectListRow = (int)[sonAry indexOfObject:_currentShowCalendarEntity];
            }
            if (sonAry.count <1) {
                [self configNoDataView];
                [_rightBox setContentView:_noDataView];
                [_contentScrollView setDocumentView:_contentView];
                [_itemTableView reloadData];
                _isEdit = NO;
                _isCalendarAdd = NO;
                return ;
            }
            
            [self selectMiddleTableViewWithRow:selectListRow];
            
            [_middleTableView reloadData];
            [_itemTableView reloadData];
            [_contentScrollView.layer removeAllAnimations];
            CATransition *transition = [CATransition animation];
            transition.delegate = self;
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = @"moveIn";
            transition.subtype = kCATransitionFromBottom;
            [_contentScrollView setDocumentView:_contentView];
            [_contentView setFrame:NSMakeRect(0, 0, _contentScrollView.frame.size.width -15, _contentScrollView.frame.size.height - 5)];
            
            [_contentScrollView.layer addAnimation:transition forKey:@"transiton"];
            _isEdit = NO;
            _isCalendarAdd = NO;
        }else if (button.tag == 600) {
            if (_curCalendarID != nil) {
                [_curCalendarID release];
                _curCalendarID = nil;
            }
            if (_summaryTextField.stringValue == nil ||[_summaryTextField.stringValue isEqualToString:@""]) {
                [self disableFunctionBtn:YES];
                return ;
            }
            if(_isCalendarAdd) {
                [_mainBox setContentView:_loadingView];
                [_animationView startAnimation];
            }else {
                [_editBox setContentView:_editLoadingView];
                [_editAnimationView startAnimation];
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                BOOL success = NO;
                if (_isCalendarAdd) {
                    IMBCalendarEventEntity *entity = [sonAry objectAtIndex:0];
                    entity.summary = _summaryTextField.stringValue;
                    entity.url = _urlTextFiled.stringValue;
                    entity.eventdescription = _notesTextField.contentField.stringValue;
                    entity.location = _locationTextField.stringValue;
                    entity.endCurDate = _endTimePicker.dateValue;
                    entity.startCurDate = _startTimePicker.dateValue;
                    
                    for (IMBCalendarEntity *colleciton in groupAry) {
                        if (_groupButton.newTag == colleciton.tag) {
                            entity.calendarID = colleciton.calendarID;
                            _curCalendarID = [colleciton.calendarID retain];
                            break;
                        }
                    }
                    [_calendarManager openMobileSync];
                    success = [_calendarManager insertCalendarEvent:entity];
                    [_calendarManager closeMobileSync];
                    if (success) {
                        [_searchFieldBtn setStringValue:@""];
                        _isSearch = NO;
                        [_information loadCalendar];
                        if (_dataSourceArray != nil) {
                            [_dataSourceArray release];
                            _dataSourceArray = nil;
                        }
                        _dataSourceArray = [[_information calendarArray] retain];
                    }
                }else{
                    _currentShowCalendarEntity.summary = _summaryTextField.stringValue;
                    _currentShowCalendarEntity.location = _locationTextField.stringValue;
                    _currentShowCalendarEntity.eventdescription = _notesTextField.contentField.stringValue;
                    _currentShowCalendarEntity.url = _urlTextFiled.stringValue;
                    _currentShowCalendarEntity.endCurDate = _endTimePicker.dateValue;
                    _currentShowCalendarEntity.startCurDate = _startTimePicker.dateValue;
                    _currentShowCalendarEntity.startdate = [_calendarManager stringFromFomate:_currentShowCalendarEntity.startCurDate formate:@"yyyy-MM-dd HH:mm:ss"];
                    _currentShowCalendarEntity.enddate = [_calendarManager stringFromFomate:_currentShowCalendarEntity.endCurDate formate:@"yyyy-MM-dd HH:mm:ss"];
                    for (IMBCalendarEntity *colleciton in groupAry) {
                        if (_groupButton.newTag == colleciton.tag) {
                            _currentShowCalendarEntity.calendarID = colleciton.calendarID;
                            _curCalendarID = [colleciton.calendarID retain];
                            break;
                        }
                    }
                    [_calendarManager openMobileSync];
                    success = [_calendarManager modifyCalendarEvent:_currentShowCalendarEntity];
                    [_calendarManager closeMobileSync];
                    if (success) {
                        [_searchFieldBtn setStringValue:@""];
                        _isSearch = NO;
                        [_information loadCalendar];
                        if (_dataSourceArray != nil) {
                            [_dataSourceArray release];
                            _dataSourceArray = nil;
                        }
                        _dataSourceArray = [[_information calendarArray] retain];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_isCalendarAdd) {
                        [_mainBox setContentView:_detailView];
                        [_animationView endAnimation];
                    }else {
                        [_editBox setContentView:nil];
                        [_editAnimationView endAnimation];
                    }
                    [self disableFunctionBtn:YES];
                    if (success) {
                        if (_isCalendarAdd) {
                            int selectListRow = 0;
                            //                            IMBCalendarEventEntity *addEntity = nil;
                            for (IMBCalendarEntity *colleciton in _dataSourceArray) {
                                if ([_curCalendarID isEqualToString:colleciton.calendarID]) {
                                    selectListRow = (int)[_dataSourceArray indexOfObject:colleciton];
                                    if (_itemArray != nil) {
                                        [_itemArray release];
                                        _itemArray = nil;
                                    }
                                    _itemArray = [colleciton.eventCalendatArray retain];
                                    //                                    for (IMBCalendarEventEntity *entity in _itemArray) {
                                    //                                        if ([entity.calendarEventID isEqualTo:_addGuid]) {
                                    //                                            addEntity = entity;
                                    //                                            break;
                                    //                                        }
                                    //                                    }
                                    break;
                                }
                            }
                            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectListRow] byExtendingSelection:NO];
                            [_middleTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                            [self selectMiddleTableViewWithRow:0];
                            if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                                [_delegate refeashBadgeConut:(int)_dataSourceArray.count WithCategory:_category];
                            }
                            _isCalendarAdd = NO;
                            _isEdit = NO;
                        }else{
                            BOOL isChange = NO;
                            int selectListRow = 0;
                            NSInteger row = 0;
                            for (IMBCalendarEntity *calEntity in _dataSourceArray) {
                                row = 0;
                                for (IMBCalendarEventEntity *eveEntity in calEntity.eventCalendatArray) {
                                    if ([eveEntity.calendarEventID isEqualToString:_currentShowCalendarEntity.calendarEventID]) {
                                        if (_itemArray != nil) {
                                            [_itemArray release];
                                            _itemArray = nil;
                                        }
                                        _itemArray = [calEntity.eventCalendatArray retain];
                                        if (_currentShowCalendarEntity != nil) {
                                            [_currentShowCalendarEntity release];
                                            _currentShowCalendarEntity = nil;
                                        }
                                        _currentShowCalendarEntity = [eveEntity retain];
                                        isChange = YES;
                                        break;
                                    }
                                    row ++;
                                }
                                if (isChange) {
                                    break;
                                }
                                selectListRow ++;
                            }
                            
                            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectListRow] byExtendingSelection:NO];
                            [_middleTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
                            [_middleTableView reloadData];
                            [_contentView setTitle:_currentShowCalendarEntity.summary];
                            [_contentView setLocation:_currentShowCalendarEntity.location];
                            [_contentView setStartdate:_currentShowCalendarEntity.startdate];
                            [_contentView setEnddate:_currentShowCalendarEntity.enddate];
                            [_contentView setDescription:_currentShowCalendarEntity.eventdescription];
                            [_contentView setUrl:_currentShowCalendarEntity.url];
                            _isEdit = NO;
                        }
                        [_contentScrollView setDocumentView:_contentView];
                        [_contentView setFrame:NSMakeRect(0, 0, _contentScrollView.frame.size.width -15, _contentScrollView.frame.size.height - 5)];
                        [_itemTableView reloadData];
                        [_middleTableView reloadData];
                    }else{
                        if (_isCalendarAdd) {
                            [self performSelectorOnMainThread:@selector(showAddErrorTip) withObject:nil waitUntilDone:NO];
                        } else {
                            [self performSelectorOnMainThread:@selector(showEditErrorTip) withObject:nil waitUntilDone:NO];
                        }
                    }
                });
            });
        }
    };
    
}

#pragma mark - NSTableView datasource
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_isSearch) {
        if (tableView == _itemTableView) {
            return _researchdataSourceArray.count;
        }else {
            return _researchItemArray.count;
        }
    }else {
        if (tableView == _itemTableView) {
            return _dataSourceArray.count;
        }else {
            return _itemArray.count;
        }
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSArray *dataAry = nil;
    NSArray *sonAry = nil;
    if (_isSearch) {
        dataAry = _researchdataSourceArray;
        sonAry = _researchItemArray;
    }else {
        dataAry = _dataSourceArray;
        sonAry = _itemArray;
    }
    
    if (tableView == _itemTableView) {
        if (dataAry.count > 0) {
            IMBCalendarEntity *collectionEntity = [dataAry objectAtIndex:row];
            if ([[tableColumn identifier] isEqualToString:@"Name"]) {
                return collectionEntity.title;
            }
            if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
                return [NSNumber numberWithInt:collectionEntity.checkState];
            }else if ([@"Count" isEqualToString:tableColumn.identifier]) {
                if (collectionEntity.eventCalendatArray.count == 0) {
                    return @"--";
                }else {
                    return [NSNumber numberWithInt:(int)collectionEntity.eventCalendatArray.count];
                }
            }
        }
    }else {
        if (sonAry.count > 0) {
            IMBCalendarEventEntity *entity = [sonAry objectAtIndex:row];
            if ([[tableColumn identifier] isEqualToString:@"Name"]) {
                return entity.summary;
            }
            if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
                return [NSNumber numberWithInt:entity.checkState];
            }
        }
    }
    return nil;
}

#pragma mark - NSTableView delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 30;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    if (_isSearch) {
        if (_isEdit) {
            [self disableFunctionBtn:YES];
            int selectListRow = 0;
            if (_isCalendarAdd) {
                if(_researchItemArray.count > 0) {
                    [_researchItemArray removeObjectAtIndex:0];
                }
            }else {
                selectListRow = (int)[_researchItemArray indexOfObject:_currentShowCalendarEntity];
            }
            
            if (_researchItemArray.count <1) {
                [self configNoDataView];
                [_rightBox setContentView:_noDataView];
                [_contentScrollView setDocumentView:_contentView];
                [_itemTableView reloadData];
                _isEdit = NO;
                _isCalendarAdd = NO;
                return ;
            }
            [self selectMiddleTableViewWithRow:selectListRow];
            
            [_middleTableView reloadData];
            [_contentScrollView.layer removeAllAnimations];
            CATransition *transition = [CATransition animation];
            transition.delegate = self;
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = @"moveIn";
            transition.subtype = kCATransitionFromBottom;
            [_contentScrollView setDocumentView:_contentView];
            [_contentView setFrame:NSMakeRect(0, 0, _contentScrollView.frame.size.width -15, _contentScrollView.frame.size.height - 5)];
            [_contentScrollView.layer addAnimation:transition forKey:@"transiton"];
            _isEdit = NO;
            _isCalendarAdd = NO;
        }
        [self disableFunctionBtn:YES];
        NSTableView *tableView = notification.object;
        if (tableView == _itemTableView) {
            int row = (int)[_itemTableView selectedRow];
            if (row < 0 && _researchdataSourceArray.count > 0) {
                row = 0;
            }
            if (row >= 0 && row < _researchdataSourceArray.count) {
                IMBCalendarEntity *collectionEntity = [_researchdataSourceArray objectAtIndex:row];
                [_researchItemArray removeAllObjects];
                [_researchItemArray addObjectsFromArray:collectionEntity.eventCalendatArray];
                _collectionEntity = [collectionEntity retain];
                if (_researchItemArray.count < 1) {
                    [self configNoDataView];
                    [_rightBox setContentView:_noDataView];
                }else {
                    [_rightBox setContentView:_middleDetailView];
                    [_middleTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                    [self selectMiddleTableViewWithRow:0];
                }
            }
            [_middleTableView reloadData];
        }else {
            int row = (int)[_middleTableView selectedRow];
            if ((row >_researchItemArray.count || row < 0)) {
                row = 0;
            }
            if (_researchItemArray.count > 0) {
                IMBCalendarEventEntity *entity = [_researchItemArray objectAtIndex:row];
                [_contentView setLocation:entity.location];
                [_contentView setUrl:entity.url];
                [_contentView setStartdate:entity.startdate];
                [_contentView setEnddate:entity.enddate];
                [_contentView setTitle:entity.summary];
                [_contentView setDescription:entity.eventdescription];
                
            }
        }
    }else {
        if (_isEdit) {
            [self disableFunctionBtn:YES];
            int selectListRow = 0;
            if (_isCalendarAdd) {
                if(_itemArray.count > 0) {
                    [_itemArray removeObjectAtIndex:0];
                }
            }else {
                selectListRow = (int)[_itemArray indexOfObject:_currentShowCalendarEntity];
            }
            
            if (_itemArray.count <1) {
                [self configNoDataView];
                [_rightBox setContentView:_noDataView];
                [_contentScrollView setDocumentView:_contentView];
                [_itemTableView reloadData];
                _isEdit = NO;
                _isCalendarAdd = NO;
                return ;
            }
            [self selectMiddleTableViewWithRow:selectListRow];
            [_middleTableView reloadData];
            [_contentScrollView.layer removeAllAnimations];
            CATransition *transition = [CATransition animation];
            transition.delegate = self;
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = @"moveIn";
            transition.subtype = kCATransitionFromBottom;
            [_contentScrollView setDocumentView:_contentView];
            [_contentView setFrame:NSMakeRect(0, 0, _contentScrollView.frame.size.width -15, _contentScrollView.frame.size.height - 5)];
            [_contentScrollView.layer addAnimation:transition forKey:@"transiton"];
            _isEdit = NO;
            _isCalendarAdd = NO;
        }
        [self disableFunctionBtn:YES];
        NSTableView *tableView = notification.object;
        if (tableView == _itemTableView) {
            int row = (int)[_itemTableView selectedRow];
            if (row >= 0 && row < _dataSourceArray.count) {
                IMBCalendarEntity *collectionEntity = [_dataSourceArray objectAtIndex:row];
                if (_itemArray != nil) {
                    [_itemArray release];
                    _itemArray = nil;
                }
                _itemArray = [collectionEntity.eventCalendatArray retain];
                _collectionEntity = [collectionEntity retain];
                if (_itemArray.count < 1) {
                    [self configNoDataView];
                    [_rightBox setContentView:_noDataView];
                }else {
                    [_rightBox setContentView:_middleDetailView];
                    [_middleTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                    [self selectMiddleTableViewWithRow:0];
                }
            }
            [_middleTableView reloadData];
        }else {
            int row = (int)[_middleTableView selectedRow];
            if ((row >_itemArray.count || row < 0)) {
                row = 0;
            }
            if (_itemArray.count > 0) {
                IMBCalendarEventEntity *entity = [_itemArray objectAtIndex:row];
                [_contentView setLocation:entity.location];
                [_contentView setUrl:entity.url];
                [_contentView setStartdate:entity.startdate];
                [_contentView setEnddate:entity.enddate];
                [_contentView setTitle:entity.summary];
                [_contentView setDescription:entity.eventdescription];
                
            }
        }
    }
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (_isEdit) {
        [self disableFunctionBtn:NO];
    } else {
        [self disableFunctionBtn:YES];
    }
    if (tableView == _itemTableView) {
        if ([@"Count" isEqualToString:tableColumn.identifier]){
            IMBCenterTextFieldCell *cell1 = (IMBCenterTextFieldCell *)cell;
            cell1.isRighVale = YES;
        }
    }
}

- (void)selectiTemTableViewWithRow:(int)row {
    if (row >= 0 && row < _dataSourceArray.count) {
        IMBCalendarEntity *collectionEntity = [_dataSourceArray objectAtIndex:row];
        if (_itemArray != nil) {
            [_itemArray release];
            _itemArray = nil;
        }
        _itemArray = [collectionEntity.eventCalendatArray retain];
        if (_itemArray.count < 1) {
            [self configNoDataView];
            [_rightBox setContentView:_noDataView];
        }else {
            [_rightBox setContentView:_middleDetailView];
            int middleRow = (int)[_middleTableView selectedRow];
            if (middleRow <0 || middleRow >= _itemArray.count) {
                middleRow = 0;
            }
            [_middleTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:middleRow] byExtendingSelection:NO];
            [self selectMiddleTableViewWithRow:middleRow];
        }
    }
    [_middleTableView reloadData];
}

- (void)selectMiddleTableViewWithRow:(int)row {
    NSArray *ary = nil;
    if (_isSearch) {
        ary = _researchItemArray;
    }else {
        ary = _itemArray;
    }
    
    if ((row >ary.count || row < 0)) {
        row = 0;
    }
    if (_itemArray.count > 0) {
        IMBCalendarEventEntity *entity = [ary objectAtIndex:row];
        [_contentView setLocation:entity.location];
        [_contentView setUrl:entity.url];
        [_contentView setStartdate:entity.startdate];
        [_contentView setEnddate:entity.enddate];
        [_contentView setTitle:entity.summary];
        [_contentView setDescription:entity.eventdescription];
    }
}

#pragma mark - IMBImageRefreshListListener
- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    NSArray *dataAry = nil;
    NSArray *sonAry = nil;
    if (_isSearch) {
        dataAry = _researchdataSourceArray;
        sonAry = _researchItemArray;
    }else {
        dataAry = _dataSourceArray;
        sonAry = _itemArray;
    }
    if (tableView == _itemTableView) {
        IMBCalendarEntity *collectionEntity = [dataAry objectAtIndex:index];
        collectionEntity.checkState = !collectionEntity.checkState;
        for (IMBCalendarEventEntity *entity in collectionEntity.eventCalendatArray) {
            entity.checkState = collectionEntity.checkState;
        }
    }else {
        IMBCalendarEventEntity *entity = [sonAry objectAtIndex:index];
        entity.checkState = !entity.checkState;
        IMBCalendarEntity *collectionEntity = nil;
        for (IMBCalendarEntity *cEntity in dataAry) {
            if ([cEntity.calendarID isEqualToString:entity.calendarID]) {
                collectionEntity = cEntity;
                break;
            }
        }
        int i = 0;
        for (IMBCalendarEventEntity *entity in collectionEntity.eventCalendatArray) {
            if (entity.checkState == Check) {
                i ++;
            }
        }
        if (i == collectionEntity.eventCalendatArray.count && collectionEntity.eventCalendatArray.count > 0) {
            collectionEntity.checkState = Check;
        }else if (i == 0 && collectionEntity.eventCalendatArray.count > 0) {
            collectionEntity.checkState = UnChecked;
        }else {
            collectionEntity.checkState = SemiChecked;
        }
    }
    [_middleTableView reloadData];
    [_itemTableView reloadData];
}

- (void)tableView:(NSTableView *)tableView rightDownrow:(NSInteger)index {
    if (index >=0 && index < _dataSourceArray.count) {
        IMBCalendarEntity *collEntity = [_dataSourceArray objectAtIndex:index];
        if (_rightDownCollectionEntity != nil) {
            [_rightDownCollectionEntity release];
            _rightDownCollectionEntity = nil;
        }
        _rightDownCollectionEntity = [collEntity retain];
        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
    }
}

#pragma mark PopupButton  AllSelect Sort
- (IBAction)leftSelectPopBtnClick:(id)sender {
    NSMenuItem *item = [_selectSortBtn selectedItem];
    NSInteger tag = [_selectSortBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _selectSortBtn.itemArray) {
        [menuItem setState:NSOffState];
    }
    if (tag == 1) {
        for (IMBCalendarEntity *collectionEntity in _dataSourceArray) {
            collectionEntity.checkState = Check;
            for (IMBCalendarEventEntity *entity in collectionEntity.eventCalendatArray) {
                entity.checkState = Check;
            }
        }
    }else if (tag == 2){
        for (IMBCalendarEntity *collectionEntity in _dataSourceArray) {
            collectionEntity.checkState = UnChecked;
            for (IMBCalendarEventEntity *entity in collectionEntity.eventCalendatArray) {
                entity.checkState = UnChecked;
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
    [_itemTableView reloadData];
    [_middleTableView reloadData];
}

- (IBAction)leftSortPopBtnClick:(id)sender {
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
    }else if (item.tag == 4){
        _isAscending = NO;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_dataSourceArray sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }
    NSString *str1 = CustomLocalizedString(@"SortBy_Name", nil);
    [_sortRightPopuBtn setTitle:str1];
    [_sortRightPopuBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    if(_dataSourceArray.count >0) {
        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        [self selectiTemTableViewWithRow:0];
    }
}

- (IBAction)middleSelectPopBtnClick:(id)sender {
    NSMenuItem *item = [_middleSelectPopBtn selectedItem];
    NSInteger tag = [_middleSelectPopBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _middleSelectPopBtn.itemArray) {
        [menuItem setState:NSOffState];
    }
    NSString *pguid = nil;
    if (tag == 1) {
        for (IMBCalendarEventEntity *entity in _itemArray) {
            entity.checkState = Check;
            pguid = entity.calendarID;
        }
        for (IMBCalendarEntity *collectionEntity in _dataSourceArray) {
            if ([collectionEntity.calendarID isEqualToString:pguid]) {
                collectionEntity.checkState = Check;
                break;
            }
        }
    }else if (tag == 2){
        for (IMBCalendarEventEntity *entity in _itemArray) {
            entity.checkState = UnChecked;
            pguid = entity.calendarID;
        }
        for (IMBCalendarEntity *collectionEntity in _dataSourceArray) {
            if ([collectionEntity.calendarID isEqualToString:pguid]) {
                collectionEntity.checkState = UnChecked;
                break;
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
    [_middleSelectPopBtn setFrame:NSMakeRect(-2,_middleSelectPopBtn.frame.origin.y , wide +30, _middleSelectPopBtn.frame.size.height)];
    [_middleSelectPopBtn setTitle:[_middleSelectPopBtn titleOfSelectedItem]];
    [_middleTableView reloadData];
    [_itemTableView reloadData];
}

- (IBAction)middleSortPopBtnClick:(id)sender {
    NSMenuItem *item = [_middleSortPopBtn selectedItem];
    NSRect rect = [TempHelper calcuTextBounds:item.title fontSize:12];
    [_middleSortPopBtn setFrame:NSMakeRect(_middleTopView.frame.size.width - 30 - rect.size.width-12,_middleSortPopBtn.frame.origin.y , rect.size.width +30, _middleSortPopBtn.frame.size.height)];
    [_middleSortPopBtn setTitle:[_middleSortPopBtn titleOfSelectedItem]];
    NSInteger tag = [_middleSortPopBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _middleSortPopBtn.itemArray) {
        if (menuItem.tag != 1) {
            [menuItem setState:NSOffState];
        }
    }
    
    if (item.tag == 1) {
        for (NSMenuItem *menuItem in _middleSortPopBtn.itemArray) {
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
        [_itemArray sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        [_sortRightPopuBtn setTitle:[_middleSortPopBtn titleOfSelectedItem]];
    }else if (tag == 2){
        
    }else if (item.tag == 3){
        _isAscending = YES;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"summary" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_itemArray sortUsingDescriptors:sortDescriptors];
        [_middleTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }else if (item.tag == 4){
        _isAscending = NO;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"summary" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_itemArray sortUsingDescriptors:sortDescriptors];
        [_middleTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }
    NSString *str1 = CustomLocalizedString(@"SortBy_Name", nil);
    [_middleSortPopBtn setTitle:str1];
    [_middleSortPopBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    if(_itemArray.count >0) {
        [_middleTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        [self selectMiddleTableViewWithRow:0];
    }
}

#pragma mark - OperationActions
- (void)reload:(id)sender {
    BOOL open = [self chekiCloud:@"Calendars" withCategoryEnum:_category];
    if (!open) {
        return;
    }
    [self disableFunctionBtn:NO];
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [_mainBox setContentView:_loadingView];
    [_animationView startAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            //刷新方式，重新读取
            [_information loadCalendar];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self disableFunctionBtn:YES];
                if (_dataSourceArray != nil) {
                    [_dataSourceArray release];
                    _dataSourceArray = nil;
                }
                _dataSourceArray = [[_information calendarArray] retain];
                if (_dataSourceArray.count <= 0) {
                    [_mainBox setContentView:_noDataView];
                    [self configNoDataView];
                }else {
                    [_mainBox setContentView:_detailView];
                    IMBCalendarEntity *collectionEntity = [_dataSourceArray objectAtIndex:0];
                    if (_itemArray != nil) {
                        [_itemArray release];
                        _itemArray = nil;
                    }
                    _itemArray = [collectionEntity.eventCalendatArray retain];
                    if (_itemArray.count < 1) {
                        [self configNoDataView];
                        [_rightBox setContentView:_noDataView];
                    }else {
                        [_rightBox setContentView:_middleDetailView];
                        [_middleTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                        [self selectMiddleTableViewWithRow:0];
                    }
                    [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                }
                [_itemTableView reloadData];
                [_middleTableView reloadData];
                int count = 0;
                for (IMBCalendarEntity *collectionEntity in _dataSourceArray) {
                    count += collectionEntity.eventCalendatArray.count;
                }
                if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                    [_delegate refeashBadgeConut:count WithCategory:_category];
                }
                [_animationView endAnimation];
            });
        }
    });
}

- (NSArray *)selectItems {
    NSArray *dataAry = nil;
    if (_isSearch) {
        dataAry = _researchdataSourceArray;
    }else {
        dataAry = _dataSourceArray;
    }
    NSMutableArray *arrayM = [NSMutableArray array];
    for (IMBCalendarEntity *entity in dataAry) {
        if (entity.checkState == Check) {
            [arrayM addObjectsFromArray:entity.eventCalendatArray];
        }else if (entity.checkState == SemiChecked) {
            for (IMBCalendarEventEntity *eventEntity in entity.eventCalendatArray) {
                if (eventEntity.checkState == Check) {
                    [arrayM addObject:eventEntity];
                }
            }
        }
    }
    return arrayM;
}

- (void)deleteItems:(id)sender {
    NSArray *arrayM = [self selectItems];
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
        int i = [_alertViewController showDeleteConfrimText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)  CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
        if (i == 0) {
            return;
        }
    }else {
        //弹出警告确认框
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_delete", nil),CustomLocalizedString(@"MenuItem_id_62", nil)];
        }else {
            str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        }
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    
    BOOL open = [self chekiCloud:@"Calendars" withCategoryEnum:_category];
    if (!open) {
        return;
    }
    _isSearch = NO;
    [_searchFieldBtn setStringValue:@""];
    [_mainBox setContentView:_loadingView];
    [_animationView startAnimation];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_calendarManager openMobileSync];
        [_calendarManager deleteCalendars:arrayM];
        [_calendarManager closeMobileSync];
        //重新加载内存数据
        [_information loadCalendar];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (_dataSourceArray != nil) {
                [_dataSourceArray release];
                _dataSourceArray = nil;
            }
            _dataSourceArray = [[_information calendarArray] retain];
            if (_dataSourceArray.count == 0) {
                [_mainBox setContentView:_noDataView];
                [self configNoDataView];
            }else {
                [_mainBox setContentView:_detailView];
                IMBCalendarEntity *collectionEntity = [_dataSourceArray objectAtIndex:0];
                if (_itemArray != nil) {
                    [_itemArray release];
                    _itemArray = nil;
                }
                _itemArray = [collectionEntity.eventCalendatArray retain];
                if (_itemArray.count < 1) {
                    [self configNoDataView];
                    [_rightBox setContentView:_noDataView];
                }else {
                    [_rightBox setContentView:_middleDetailView];
                    [_middleTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                    [self selectMiddleTableViewWithRow:0];
                }
                [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
            }
            [_itemTableView reloadData];
            [_middleTableView reloadData];
            int count = 0;
            for (IMBCalendarEntity *collectionEntity in _dataSourceArray) {
                count += collectionEntity.eventCalendatArray.count;
            }
            if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                [_delegate refeashBadgeConut:count WithCategory:_category];
            }
            [_animationView endAnimation];
        });
    });
}

- (void)addItems:(id)sender {
    BOOL open = [self chekiCloud:@"Calendars" withCategoryEnum:_category];
    if (!open) {
        return;
    }
    [_calendarEditView setFrame:NSMakeRect(0, 0, _contentScrollView.frame.size.width -15, _contentScrollView.frame.size.height - 5)];
    [_summaryLable setStringValue:CustomLocalizedString(@"Calendar_id_4", nil)];
    [_locationLable setStringValue:CustomLocalizedString(@"Calendar_id_5", nil)];
    [_urlLable setStringValue:CustomLocalizedString(@"Bookmark_id_2", nil)];
    [_notesLable setStringValue:[CustomLocalizedString(@"Calendar_id_11", nil) stringByReplacingOccurrencesOfString:@":" withString:@""]];
    [_startTimeLable setStringValue:[CustomLocalizedString(@"icloud_reminder_11", nil) stringByAppendingString:@":"]];
    [_endTimeLable setStringValue:[CustomLocalizedString(@"icloud_reminder_12", nil) stringByAppendingString:@":"]];
    
    if (_notesTextField != nil) {
        [_notesTextField release];
        _notesTextField = nil;
    }
    [_noteScrollView setHastopBorder:NO leftBorder:NO BottomBorder:NO rightBorder:NO];
    _notesTextField = [[IMBCalendarNoteEditView alloc] initWithFrame:NSMakeRect(0, 0, _noteScrollView.frame.size.width, _noteScrollView.frame.size.height)];
    [_noteScrollView setDocumentView:_notesTextField];
    [_notesTextField setAutoresizesSubviews:YES];
    [_notesTextField setIsEditing:YES];
    [_notesTextField setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin|NSViewWidthSizable|NSViewHeightSizable];
    
    //时间日历属性设置
    _startTimePicker.preferredPopoverEdge = NSMaxXEdge;
    _endTimePicker.preferredPopoverEdge = NSMaxXEdge;
    [_startTimePicker setFrameSize:NSMakeSize(160, 27)];
    [_startTimePicker setNeedsDisplay:YES];
    [_endTimePicker setFrameSize:NSMakeSize(160 ,27)];
    [_endTimePicker setNeedsDisplay:YES];
    
    IMBCalendarEventEntity *eventEntity = [[[IMBCalendarEventEntity alloc] init] autorelease];
    [eventEntity setSummary:CustomLocalizedString(@"contact_id_48", nil)];
    
    NSArray *groupAry = nil;
    if (_isSearch) {
        groupAry = _researchdataSourceArray;
         [_researchItemArray insertObject:eventEntity atIndex:0];
    }else {
        groupAry = _dataSourceArray;
        [_itemArray insertObject:eventEntity atIndex:0];
    }
    
   
    [_summaryTextField  setStringValue:@""];
    [_locationTextField  setStringValue:@""];
    [_notesTextField.contentField  setStringValue:@""];
    [_urlTextFiled  setStringValue:@""];
    [_startTimePicker setDateValue:[NSDate date]];
    [_endTimePicker setDateValue:[NSDate date]];
    [_textBoxOne setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_textBoxThree setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_textBoxTwo setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_textBoxFour setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    
    if (groupAry.count > 0) {
        //设置选组按钮
        [_groupButton setNewTag:_collectionEntity.tag];
        [_groupButton setFillColor:_collectionEntity.color];
        [_groupButton setIsHasBorder:YES];
        [_groupButton setBorderWidth:2];
        [_groupButton setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_groupButton setNeedsDisplay:YES];
        [_groupButton setMenu:[self createNavagationMenu]];
    }
    [_middleTableView reloadData];
    [_middleTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [_mainBox setContentView:_detailView];
    [_rightBox setContentView:_middleDetailView];
    
    [_contentScrollView.layer removeAllAnimations];
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"moveIn";
    transition.subtype = kCATransitionFromBottom;
    [_contentScrollView setDocumentView:_calendarEditView];
    [_calendarEditView setNeedsDisplay:YES];
    [_contentScrollView.layer addAnimation:transition forKey:@"transiton"];
    _isCalendarAdd = YES;
    [self disableFunctionBtn:NO];
    _isEdit = YES;
    
}

- (void)deviceToiCloud:(id)sender {
    if ([self selectedItems].count <= 0) {
        //弹出警告确认框
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_transfer", nil),[StringHelper getCategeryStr:_category]];
        }else {
            str = CustomLocalizedString(@"Export_View_Selected_Tips", nil);
        }
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    
    NSViewController *annoyVC = nil;
    long long result = [self checkNeedAnnoy:&(annoyVC)];
    if (result == 0) {
        return;
    }
    
    if (_category == Category_Calendar) {
        NSArray *selectArray = [self selectItems];
        //IMBCalendarEventEntity转换为IMBiCloudCalendarEventEntity
        NSMutableArray *iCloudArray = [[[NSMutableArray alloc] init] autorelease];
        for (IMBCalendarEventEntity *entity in selectArray) {
            IMBiCloudCalendarEventEntity *iCloudEntity = [[IMBiCloudCalendarEventEntity alloc] init];
            CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
            NSString *guid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
            iCloudEntity.guid = guid;
            iCloudEntity.summary = entity.summary;
            iCloudEntity.url = entity.url;
            iCloudEntity.eventdescription = entity.eventdescription;
            iCloudEntity.location = entity.location;
            
            NSDate *startDate = [DateHelper dateFromString:entity.startdate Formate:@"yyyy-MM-dd HH:mm:ss"];
            NSTimeInterval startTime = [startDate timeIntervalSince1970];
            iCloudEntity.startCalTime = [[NSNumber numberWithDouble:startTime] longLongValue];
            
            NSDate *endDate = [DateHelper dateFromString:entity.enddate Formate:@"yyyy-MM-dd HH:mm:ss"];
            NSTimeInterval endTime = [endDate timeIntervalSince1970];
            iCloudEntity.endCalTime = [[NSNumber numberWithDouble:endTime] longLongValue];
            for (IMBiCloudCalendarCollectionEntity *colleciton in _iCloudManager.calendarCollectionArray) {
                if (colleciton.tag == 1) {
                    if (![StringHelper stringIsNilOrEmpty:colleciton.guid] ) {
                        iCloudEntity.pGuid = colleciton.guid;
                        break;
                    }
                }else {
                    if (![StringHelper stringIsNilOrEmpty:colleciton.guid] ) {
                        iCloudEntity.pGuid = colleciton.guid;
                        break;
                    }
                }
            }
            [iCloudArray addObject:iCloudEntity];
            [iCloudEntity release], iCloudEntity = nil;
        }
        
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Device_Content action:ToiCloud actionParams:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] label:Start transferCount:selectArray.count screenView:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        //传输
        if (_transferController != nil) {
            [_transferController release];
            _transferController = nil;
        }
        _transferController = [[IMBTransferViewController alloc] initWithType:Category_Calendar withDelegate:self withTransfertype:TransferSync withIsicloudView:NO];
        [_transferController setDelegate:self];
        if (result>0) {
            [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
        }else{
            [self animationAddTransferView:_transferController.view];
        }
        if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_62", nil)]];
        }
        
        NSString *msgStr = CustomLocalizedString(@"ImportSync_id_1", nil);
        if ([_transferController respondsToSelector:@selector(transferFile:)]) {
            [_transferController transferFile:msgStr];
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            int i = 0 ;
            int curCount = 0;
            BOOL success = NO;
            for (IMBiCloudCalendarEventEntity *entity in iCloudArray) {
                NSString *msgStr = entity.summary;
                if ([_transferController respondsToSelector:@selector(transferFile:)]) {
                    [_transferController transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),msgStr]];
                }
                success = [_iCloudManager addCalender:entity];
                if (success) {
                    i++;
                }
                curCount ++;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [_transferController transferPrepareFileEnd];
                    if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
                        [_transferController transferProgress:curCount/iCloudArray.count *100];
                    }
                });
            }
            double delayInSeconds =2;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                    [_transferController startTransAnimation];
                    [_transferController transferComplete:i TotalCount:(int)iCloudArray.count];
                    NSDictionary *dimensionDict = nil;
                    @autoreleasepool {
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:Device_Content action:ToiCloud actionParams:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] label:Finish transferCount:i screenView:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                }
            });
        });
    }
}

#pragma mark - Error Tip
- (void)showAddErrorTip {
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_Add_Failed", nil),CustomLocalizedString(@"MenuItem_id_62", nil)];
    [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

- (void)showEditErrorTip {
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_Modify_Failed", nil),CustomLocalizedString(@"MenuItem_id_62", nil)];
    [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

- (void)showDeleteErrorTip {
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_Delete_Failed", nil),CustomLocalizedString(@"MenuItem_id_62", nil)];
    [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

#pragma mark - noData
- (void)configNoDataView {
    NSString *promptStr = @"";
    [_noDataImageView setImage:[StringHelper imageNamed:@"noData_calendar"]];
    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"MenuItem_id_62", nil)];
    [_textView setDelegate:self];
    
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_textView setLinkTextAttributes:linkAttributes];
    [_textView setSelectable:NO];
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

#pragma mark - doChangeLanguage
-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        [_summaryLable setStringValue:CustomLocalizedString(@"Calendar_id_4", nil)];
        [_locationLable setStringValue:CustomLocalizedString(@"Calendar_id_5", nil)];
        [_urlLable setStringValue:CustomLocalizedString(@"Bookmark_id_2", nil)];
        [_notesLable setStringValue:CustomLocalizedString(@"Calendar_id_11", nil)];
        [_startTimeLable setStringValue:CustomLocalizedString(@"icloud_reminder_11", nil)];
        [_endTimeLable setStringValue:CustomLocalizedString(@"icloud_reminder_12", nil)];
        [self configNoDataView];
        
        
        for (NSMenuItem *item in [[_middleSortPopBtn menu] itemArray])
        {
            if (item.tag == 0) {
                [item setTitle:CustomLocalizedString(@"SortBy_Name", nil)];
                [item setState:NSOnState];
            }else if (item.tag == 1)
            {
                [item setTitle:CustomLocalizedString(@"SortBy_Name", nil)];
                [item setState:NSOnState];
            }else if (item.tag == 2)
            {
                [item setTitle:CustomLocalizedString(@"SortBy_Date", nil)];
            }else if (item.tag == 3)
            {
                [item setTitle:CustomLocalizedString(@"Sort_Ascend", nil)];
            }else if (item.tag == 4)
            {
                [item setTitle:CustomLocalizedString(@"Sort_Descend", nil)];
            }
        }
        NSString *titleStr = CustomLocalizedString(@"SortBy_Name", nil);
        if (![TempHelper stringIsNilOrEmpty:titleStr]) {
            NSRect rect = [TempHelper calcuTextBounds:titleStr fontSize:12];
            int w = rect.size.width + 30;
            
            if ((rect.size.width + 30) < 50) {
                w = 50;
            }
            
            [_middleSortPopBtn setFrame:NSMakeRect(_middleTopView.frame.size.width  - w -12, _middleSortPopBtn.frame.origin.y, w, _middleSortPopBtn.frame.size.height)];
        }
        [_middleSortPopBtn setNeedsDisplay:YES];
        [_middleSortPopBtn setTitle:titleStr];
        
        
        for (NSMenuItem *item in _middleSelectPopBtn.itemArray) {
            if (item.tag == 0) {
                [item setTitle:CustomLocalizedString(@"Menu_Select_All", nil)];
                
            }else if (item.tag == 1){
                [item setTitle:CustomLocalizedString(@"Menu_Select_All", nil)];
                
            }else if (item.tag == 2){
                [item setTitle:CustomLocalizedString(@"Menu_Unselect_All", nil)];
                
            }
        }
        
        [_middleSelectPopBtn setNeedsDisplay:YES];
        [_middleSelectPopBtn setTitle:CustomLocalizedString(@"Menu_Unselect_All", nil)];
        
        NSRect rect1 = [TempHelper calcuTextBounds:CustomLocalizedString(@"Menu_Unselect_All", nil) fontSize:12];
        int wide = 0;
        if (rect1.size.width >170) {
            wide = 170;
        }else{
            wide = rect1.size.width;
        }
        [_middleSelectPopBtn setFrame:NSMakeRect(-2,_middleSelectPopBtn.frame.origin.y , wide +30, _middleSelectPopBtn.frame.size.height)];
        
        [_contentView setNeedsDisplay:YES];
    });
}

#pragma mark - changeSkin
- (void)changeSkin:(NSNotification *)notification {
    [_leftLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_middleLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [self configNoDataView];
    [_topWhiteView setNeedsDisplay:YES];
    [_middleTopView setNeedsDisplay:YES];
    [_sortRightPopuBtn setNeedsDisplay:YES];
    [_selectSortBtn setNeedsDisplay:YES];
    [_animationView setNeedsDisplay:YES];
    [_editAnimationView setNeedsDisplay:YES];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [_editLoadingView setIsGradientColorNOCornerPart3:YES];
    [_editLoadingView setNeedsDisplay:YES];
    
    [_textBoxOne setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_textBoxThree setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_textBoxTwo setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_textBoxFour setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_contentView setNeedsDisplay:YES];
    [_groupButton setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_summaryLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_summaryTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_locationLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_locationTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_urlLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_urlTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_notesLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_notesTextField.contentField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_startTimeLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_endTimeLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_startTimePicker setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_endTimePicker setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_notesTextField setNeedsDisplay:YES];
    
}

#pragma mark - NSMenuDelegate
- (void)menuDidClose:(NSMenu *)menu
{
    for (IMBGroupMenu *menuitem in menu.itemArray) {
        ((IMBGroupMenuItem *)menuitem.view).isMouseEnter = NO;
        ((IMBGroupMenuItem *)menuitem.view).isThis = NO;
    }
}

- (void)menuWillOpen:(NSMenu *)menu {
    
    for (IMBGroupMenu *menuitem in menu.itemArray) {
        if (((IMBGroupMenuItem *)menuitem.view).tag == _groupButton.newTag) {
            ((IMBGroupMenuItem *)menuitem.view).isMouseEnter = YES;
            ((IMBGroupMenuItem *)menuitem.view).isThis = YES;
        }else{
            ((IMBGroupMenuItem *)menuitem.view).isMouseEnter = NO;
            ((IMBGroupMenuItem *)menuitem.view).isThis = NO;
        }
    }
}

- (void)navigateTo:(IMBGroupMenu *)item
{
    ((IMBGroupMenuItem *)item.view).isMouseEnter = NO;
    ((IMBGroupMenuItem *)item.view).isThis = NO;
    [_groupButton.menu cancelTracking];
    [_groupButton setNewTag:((IMBGroupMenuItem *)item.view).tag];
    [_groupButton setFillColor:((IMBGroupMenuItem *)item.view).groupColor];
    [_groupButton setNeedsDisplay:YES];
   
}

#pragma mark - menu 赋值

- (NSMenu *)createNavagationMenu
{
    NSMenu *mainMenu = [[NSMenu alloc] init];
    [mainMenu setDelegate:self];
    for (IMBCalendarEntity *entity in _dataSourceArray) {
        IMBGroupMenu *item = [[IMBGroupMenu alloc] init];
        [item setAction:@selector(navigateTo:)];
        [item setTarget:self];
        [item setTitle:entity.title];
        [item setGroupColor:entity.color];
        [item setTag:entity.tag];
        [mainMenu addItem:item];
        [item release];
    }
    
    return [mainMenu autorelease];
}

#pragma mark - search
-(void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    if (_isEdit) {
        [self disableFunctionBtn:YES];
        int selectListRow = 0;
        if (_isCalendarAdd) {
            if(_itemArray.count > 0) {
                [_itemArray removeObjectAtIndex:0];
            }
        }else {
            selectListRow = (int)[_itemArray indexOfObject:_currentShowCalendarEntity];
        }
        
        if (_itemArray.count <1) {
            [self configNoDataView];
            [_rightBox setContentView:_noDataView];
            [_contentScrollView setDocumentView:_contentView];
            [_itemTableView reloadData];
            _isEdit = NO;
            _isCalendarAdd = NO;
            return ;
        }
        [self selectMiddleTableViewWithRow:selectListRow];
        [_middleTableView reloadData];
        [_contentScrollView.layer removeAllAnimations];
        CATransition *transition = [CATransition animation];
        transition.delegate = self;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"moveIn";
        transition.subtype = kCATransitionFromBottom;
        [_contentScrollView setDocumentView:_contentView];
        [_contentView setFrame:NSMakeRect(0, 0, _contentScrollView.frame.size.width -15, _contentScrollView.frame.size.height - 5)];
        [_contentScrollView.layer addAnimation:transition forKey:@"transiton"];
        _isEdit = NO;
        _isCalendarAdd = NO;
    }
    
    _isSearch = YES;
    [_researchdataSourceArray removeAllObjects];
    [_researchItemArray removeAllObjects];
    
    NSMutableArray *allEvnentAryM = [[[NSMutableArray alloc] init] autorelease];
    for (IMBCalendarEntity *entity in _dataSourceArray) {
        [allEvnentAryM addObjectsFromArray:entity.eventCalendatArray];
    }
    
    NSMutableArray *searchArym = [[[NSMutableArray alloc] init] autorelease];
    
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"summary CONTAINS[cd] %@ ",searchStr];
        [searchArym addObjectsFromArray:[allEvnentAryM  filteredArrayUsingPredicate:predicate]];
        for (IMBCalendarEventEntity *evnetEntity in searchArym) {
            IMBCalendarEntity *newEntity = [[IMBCalendarEntity alloc] init];
            for (int i = 0; i < _dataSourceArray.count; i ++) {
                IMBCalendarEntity *entity = [_dataSourceArray objectAtIndex:i];
                if ([entity.calendarID isEqualToString:evnetEntity.calendarID]) {
                    newEntity.calendarID = entity.calendarID;
                    newEntity.title = entity.title;
                    newEntity.calendarRowID = entity.calendarRowID;
                    newEntity.color = entity.color;
                    [newEntity.eventCalendatArray addObjectsFromArray:entity.eventCalendatArray];
                    newEntity.isOnlyRead = entity.isOnlyRead;
                    newEntity.recordEntityName = entity.recordEntityName;
                    newEntity.tag = entity.tag;
                    
                    [newEntity.eventCalendatArray removeAllObjects];
                    [newEntity.eventCalendatArray addObject:evnetEntity];
                    break;
                }
            }
            BOOL haveSameGroup = NO;
            for (int y = 0; y < _researchdataSourceArray.count ; y ++) {
                IMBCalendarEntity *_reEntity = [_researchdataSourceArray objectAtIndex:y];
                if ([newEntity.calendarID isEqualToString:_reEntity.calendarID]) {
                    haveSameGroup = YES;
                    [_reEntity.eventCalendatArray addObjectsFromArray:newEntity.eventCalendatArray];
                    break;
                }
            }
            if (!haveSameGroup) {
                [_researchdataSourceArray addObject:newEntity];
            }
            [newEntity release], newEntity = nil;
        }
        if (searchArym.count == 0) {
            [_rightBox setContentView:_noDataView];
        }
        
        NSNotification *noti = [NSNotification notificationWithName:@"" object:_itemTableView];
        [self tableViewSelectionDidChange:noti];
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
        [_researchItemArray removeAllObjects];
        if (_dataSourceArray.count > 0) {
            [self selectiTemTableViewWithRow:0];
        }
    }
    NSMutableArray *disAry = nil;
    if (_isSearch) {
        disAry = _researchdataSourceArray;
    }else{
        disAry = _dataSourceArray;
    }
    
    int checkCount = 0;
    for (int i=0; i<[disAry count]; i++) {
        IMBCalendarEntity *noteMode = [disAry objectAtIndex:i];
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
    [_middleTableView reloadData];
}

#pragma mark - 是否会弹出日历框
- (BOOL)datePickerShouldShowPopover:(ASHDatePicker *)datepicker {
    return YES;
}

- (void)reloadTableView{
    _isSearch = NO;
    [_itemTableView reloadData];
    NSNotification *noti = [NSNotification notificationWithName:@"" object:_itemTableView];
    [self tableViewSelectionDidChange:noti];

}

- (void)dealloc {
    if (_itemArray != nil) {
        [_itemArray release];
        _itemArray = nil;
    }
    if (_curCalendarID != nil) {
        [_curCalendarID release];
        _curCalendarID = nil;
    }
    if (_calendarManager != nil) {
        [_calendarManager release];
        _calendarManager = nil;
    }
    if (_collectionEntity != nil) {
        [_collectionEntity release];
        _collectionEntity = nil;
    }
    if (_researchItemArray != nil) {
        [_researchItemArray release];
        _researchItemArray = nil;
    }

    if (_notesTextField != nil) {
        [_notesTextField release];
        _notesTextField = nil;
    }

    [super dealloc];
}

@end

