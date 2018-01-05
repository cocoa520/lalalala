//
//  IMBiCloudCalendarViewController.m
//  AnyTrans
//
//  Created by m on ٢٧‏/٢‏/٢٠١٧.
//  Copyright (c) ٢٠١٧ imobie. All rights reserved.
//

#import "IMBiCloudCalendarViewController.h"
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
#import "ColorHelper.h"

@implementation IMBiCloudCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

- (id)initWithiCloudManager:(IMBiCloudManager *)iCloudManager withDelegate:(id)delegate withiCloudView:(BOOL)isiCloudView withCategory:(CategoryNodesEnum)Category {
    if (self == [super initWithiCloudManager:iCloudManager withDelegate:delegate withiCloudView:isiCloudView withCategory:Category]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkFaultInterrupt) name:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
        _dataSourceArray = [[NSMutableArray alloc] initWithArray:_iCloudManager.calendarCollectionArray];
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
    _alerView = [[IMBAlertViewController alloc]initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_middleTableView setListener:self];
    [_middleTableView setFocusRingType:NSFocusRingTypeNone];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    _itemArray = [[NSMutableArray alloc] init];
   
    _contentView = [[IMBCalendarContentView alloc] initWithFrame:NSMakeRect(0, 0, _contentScrollView.frame.size.width -15, _contentScrollView.frame.size.height - 5) WithCategory:Category_Calendar];
    [_contentView setHasEditBtn:YES];
    [_contentView setAutoresizesSubviews:YES];
    [_contentView setAutoresizingMask:NSViewHeightSizable|NSViewWidthSizable];
    [_contentScrollView setDocumentView:_contentView];
    
    if (_dataSourceArray.count < 1) {
        [self configNoDataView];
        [_mainBox setContentView:_noDataView];
    }else {
        [_mainBox setContentView:_detailView];
        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    }
    [self saveChange];
    [self editIcloudCalendar];
    
    [_topWhiteView setIsBommt:YES];
    [_topWhiteView setBackgroundColor:[NSColor clearColor]];
    [_middleTopView setIsBommt:YES];
    [_middleTopView setBackgroundColor:[NSColor clearColor]];
    
    NSString *addStr = CustomLocalizedString(@"iCloud_add_newList", nil);
    NSRect rect = [StringHelper calcuTextBounds:addStr fontSize:14];
    float w = 110;
    if (rect.size.width > 80) {
        w = rect.size.width + 30;
    }
    [_addListBtn setFrame:NSMakeRect((_leftBottomView.frame.size.width - w)/2, _addListBtn.frame.origin.y, w, _addListBtn.frame.size.height)];
    [_addListBtn mouseDownImage:[StringHelper imageNamed:@"add_item3"] withMouseUpImg:[StringHelper imageNamed:@"add_item1"]  withMouseExitedImg:[StringHelper imageNamed:@"add_item1"]  mouseEnterImg:[StringHelper imageNamed:@"add_item2"]  withButtonName:addStr];

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

- (void)retToolbar:(IMBToolBarView*)toolbarview{
    _toolBar = toolbarview;
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
    [_addListMenuItem setTitle:CustomLocalizedString(@"iCloud_add_newList", nil)];
    
    [_leftLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_middleLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
}

#pragma mark - save 
- (void)saveChange {
    _calendarEditView.saveBlock = ^(IMBMyDrawCommonly *button){
        [_calendarEditView setFrame:NSMakeRect(0, 0, _contentScrollView.frame.size.width -15, _contentScrollView.frame.size.height - 5)];
        if (button.tag == 601) {
            [_toolBar toolBarButtonIsEnabled:YES];
            if (_isCalendarAdd) {
                if (_itemArray.count > 0) {
                    [_itemArray removeObjectAtIndex:0];
                }
            }
            if (_itemArray.count <1) {
                [self configNoDataView];
                [_rightBox setContentView:_noDataView];
                [_contentScrollView setDocumentView:_contentView];
                [_itemTableView reloadData];
                _isEdit = NO;
                return ;
            }
            
            [self selectMiddleTableViewWithRow:0];
            
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
        }else if (button.tag == 600) {
            if (_summaryTextField.stringValue == nil ||[_summaryTextField.stringValue isEqualToString:@""]) {
                [_toolBar toolBarButtonIsEnabled:YES];
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
                    IMBiCloudCalendarEventEntity *entity = [_itemArray objectAtIndex:0];
                    CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
                    _addGuid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
                    entity.guid = _addGuid;
                    entity.summary = _summaryTextField.stringValue;
                    entity.url = _urlTextFiled.stringValue;
                    entity.eventdescription = _notesTextField.contentField.stringValue;
                    entity.location = _locationTextField.stringValue;
                    entity.startCalTime = [_startTimePicker.dateValue timeIntervalSince1970];
                    entity.endCalTime = [_endTimePicker.dateValue timeIntervalSince1970];
                    for (IMBiCloudCalendarCollectionEntity *colleciton in _dataSourceArray) {
                        if (_groupButton.newTag == colleciton.tag) {
                            entity.pGuid = colleciton.guid;
                            break;
                        }
                    }
                    success = [_iCloudManager addCalender:entity];
                    if (success) {
                        [_iCloudManager getCalendarContent];
                        if (_dataSourceArray != nil) {
                            [_dataSourceArray release];
                            _dataSourceArray = nil;
                        }
                        _dataSourceArray = [_iCloudManager.calendarCollectionArray retain];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_itemTableView reloadData];
                            [_middleTableView reloadData];
                        });
                    }
                }else{
                    _currentShowCalendarEntity.summary = _summaryTextField.stringValue;
                    _currentShowCalendarEntity.location = _locationTextField.stringValue;
                    _currentShowCalendarEntity.eventdescription = _notesTextField.contentField.stringValue;
                    _currentShowCalendarEntity.url = _urlTextFiled.stringValue;
                    _currentShowCalendarEntity.startCalTime = [_startTimePicker.dateValue timeIntervalSince1970];
                    _currentShowCalendarEntity.endCalTime = [_endTimePicker.dateValue timeIntervalSince1970];
                    _currentShowCalendarEntity.startdate = [DateHelper dateFrom1970ToString:_currentShowCalendarEntity.startCalTime withMode:2];
                    _currentShowCalendarEntity.enddate = [DateHelper dateFrom1970ToString:_currentShowCalendarEntity.endCalTime withMode:2];

                    for (IMBiCloudCalendarCollectionEntity *colleciton in _dataSourceArray) {
                        if (_groupButton.newTag == colleciton.tag) {
                            _currentShowCalendarEntity.pGuid = colleciton.guid;
                            break;
                        }
                    }
                    success = [_iCloudManager editCalender:_currentShowCalendarEntity];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_isCalendarAdd) {
                        [_mainBox setContentView:_detailView];
                        [_animationView endAnimation];
                    }else {
                        [_editBox setContentView:nil];
                        [_editAnimationView endAnimation];
                    }
                    [_toolBar toolBarButtonIsEnabled:YES];
                    if (success) {
                        if (_isCalendarAdd) {
                            int selectListRow = 0;
                            IMBiCloudCalendarEventEntity *addEntity = nil;
                            for (IMBiCloudCalendarCollectionEntity *colleciton in _iCloudManager.calendarCollectionArray) {
                                if (_groupButton.newTag == colleciton.tag) {
                                    selectListRow = (int)[_dataSourceArray indexOfObject:colleciton];
                                    if (_itemArray != nil) {
                                        [_itemArray release];
                                        _itemArray = nil;
                                    }
                                    _itemArray = [colleciton.subArray retain];;
                                    for (IMBiCloudCalendarEventEntity *entity in colleciton.subArray) {
                                        if ([entity.guid isEqualTo:_addGuid]) {
                                            addEntity = entity;
                                        }
                                    }
                                    
                                    break;
                                }
                            }
                            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectListRow] byExtendingSelection:NO];
                            
                            //                            int selectMiddleRow = [_itemArray indexOfObject:addEntity];
                            [_middleTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                            [self selectMiddleTableViewWithRow:0];
                            if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                                [_delegate refeashBadgeConut:(int)_iCloudManager.calendarArray.count WithCategory:_category];
                            }
                            _isCalendarAdd = NO;
                            _isEdit = NO;
                        }else{
                            NSInteger row = [_itemArray indexOfObject:_currentShowCalendarEntity];
                            if (row < 0 || row > _itemArray.count){
                                row = 0;
                            }
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

#pragma mark - Edit Method
- (void)editIcloudCalendar {
    _contentView.editBlock = ^{
        [_calendarEditView setFrame:NSMakeRect(0, 0, _contentScrollView.frame.size.width -15, _contentScrollView.frame.size.height - 5)];
        [_toolBar toolBarButtonIsEnabled:NO];
        [_summaryLable setStringValue:CustomLocalizedString(@"Calendar_id_4", nil)];
        [_locationLable setStringValue:CustomLocalizedString(@"Calendar_id_5", nil)];
        [_urlLable setStringValue:CustomLocalizedString(@"Bookmark_id_2", nil)];
        [_notesLable setStringValue:[CustomLocalizedString(@"Calendar_id_11", nil) stringByReplacingOccurrencesOfString:@":" withString:@""]];
        [_startTimeLable setStringValue:[CustomLocalizedString(@"icloud_reminder_11", nil) stringByAppendingString:@":"]];
        [_endTimeLable setStringValue:[CustomLocalizedString(@"icloud_reminder_12", nil) stringByAppendingString:@":"]];
        
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Calendar Edit" label:Click transferCount:0 screenView:@"Calendar View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        
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
        [_groupButton setFillColor:[ColorHelper colorWithHexString:_collectionEntity.color]];
        [_groupButton setIsHasBorder:YES];
        [_groupButton setBorderWidth:2];
        [_groupButton setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_groupButton setNeedsDisplay:YES];
        [_groupButton setMenu:[self createNavagationMenu]];
        [_textBoxOne setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_tetxBoxThree setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_textBoxTwo setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_textBoxFour setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        //时间日历属性设置
        _startTimePicker.preferredPopoverEdge = NSMaxXEdge;
        _endTimePicker.preferredPopoverEdge = NSMaxXEdge;
        [_startTimePicker setFrameSize:NSMakeSize(160, 27)];
        [_startTimePicker setNeedsDisplay:YES];
        [_endTimePicker setFrameSize:NSMakeSize(160 ,27)];
        [_endTimePicker setNeedsDisplay:YES];
        
        NSInteger row = [_middleTableView selectedRow];
        IMBiCloudCalendarEventEntity *calendarEvent = nil;
        if (row == -1) {
            return;
            
        }else if(row < [_itemArray count])
        {
            calendarEvent = [_itemArray objectAtIndex:row];
        }
        if (_currentShowCalendarEntity != nil) {
            [_currentShowCalendarEntity release],_currentShowCalendarEntity = nil;
        }
        _currentShowCalendarEntity = [calendarEvent retain];
        [_summaryTextField setStringValue:calendarEvent.summary?:@""];
        [_locationTextField setStringValue:calendarEvent.location?:@""];
        [_urlTextFiled setStringValue:calendarEvent.url?:@""];
        [_notesTextField.contentField setStringValue:calendarEvent.eventdescription?:@""];
        [_startTimePicker setDateValue:[DateHelper dateFrom1970:calendarEvent.startCalTime]];
        [_endTimePicker setDateValue:[DateHelper dateFrom1970:calendarEvent.endCalTime]];
        
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

#pragma mark - NSTableView datasource
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView == _itemTableView) {
        if (_dataSourceArray.count < 1) {
            return 0;
        }else {
            return _dataSourceArray.count;
        }
    }else {
        if (_itemArray.count < 1) {
            return 0;
        }else {
            return _itemArray.count;
        }
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableView == _itemTableView) {
        if (_dataSourceArray.count > 0) {
            IMBiCloudCalendarCollectionEntity *collectionEntity = [_dataSourceArray objectAtIndex:row];
            if ([[tableColumn identifier] isEqualToString:@"Name"]) {
                return collectionEntity.title;
            }
            if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
                return [NSNumber numberWithInt:collectionEntity.checkState];
            }else if ([@"Count" isEqualToString:tableColumn.identifier]) {
                if (collectionEntity.subArray.count == 0) {
                    return @"--";
                }else {
                    return [NSNumber numberWithInt:(int)collectionEntity.subArray.count];
                }
            }
        }
    }else {
        if (_itemArray.count > 0) {
            IMBiCloudCalendarEventEntity *entity = [_itemArray objectAtIndex:row];
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
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 30;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    if (_isEdit) {
        [_toolBar toolBarButtonIsEnabled:YES];
        if (_isCalendarAdd) {
            if(_itemArray.count > 0) {
                [_itemArray removeObjectAtIndex:0];
            }
        }
        
        if (_itemArray.count <1) {
            [self configNoDataView];
            [_rightBox setContentView:_noDataView];
            return ;
        }
        [self selectMiddleTableViewWithRow:0];
        
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
    }
    [_toolBar toolBarButtonIsEnabled:YES];
    NSTableView *tableView = notification.object;
    if (tableView == _itemTableView) {
        int row = (int)[_itemTableView selectedRow];
        if (row >= 0 && row < _dataSourceArray.count) {
            IMBiCloudCalendarCollectionEntity *collectionEntity = [_dataSourceArray objectAtIndex:row];
            if (_itemArray != nil) {
                [_itemArray release];
                _itemArray = nil;
            }
            _itemArray = [collectionEntity.subArray retain];
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
            IMBiCloudCalendarEventEntity *entity = [_itemArray objectAtIndex:row];
            [_contentView setLocation:entity.location];
            [_contentView setUrl:entity.url];
            [_contentView setStartdate:entity.startdate];
            [_contentView setEnddate:entity.enddate];
            [_contentView setTitle:entity.summary];
            [_contentView setDescription:entity.eventdescription];
            
            if (!entity.addDetailContent) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [_iCloudManager loadCalendarDetailContent:entity];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (_itemArray.count > 0 && row < _itemArray.count) {
                            IMBCalendarEventEntity *calendarEvent = [_itemArray objectAtIndex:row];
                            if (calendarEvent == entity) {
                                [_contentView setDescription:calendarEvent.eventdescription];
                                [_contentView setUrl:calendarEvent.url];
                            }
                        }
                    });
                });
            }
            
            if (_currentShowCalendarEntity != nil) {
                [_currentShowCalendarEntity release];
                _currentShowCalendarEntity = nil;
            }
            _currentShowCalendarEntity = [entity retain];
        }
    }
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if (tableView == _itemTableView) {
        if ([@"Count" isEqualToString:tableColumn.identifier]){
            IMBCenterTextFieldCell *cell1 = (IMBCenterTextFieldCell *)cell;
            cell1.isRighVale = YES;
        }
    }
}

- (void)selectiTemTableViewWithRow:(int)row {
    if (row >= 0 && row < _dataSourceArray.count) {
        IMBiCloudCalendarCollectionEntity *collectionEntity = [_dataSourceArray objectAtIndex:row];
        if (_itemArray != nil) {
            [_itemArray release];
            _itemArray = nil;
        }
        _itemArray = [collectionEntity.subArray retain];
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
    if ((row >_itemArray.count || row < 0)) {
        row = 0;
    }
    if (_itemArray.count > 0) {
        IMBiCloudCalendarEventEntity *entity = [_itemArray objectAtIndex:row];
        [_contentView setLocation:entity.location];
        [_contentView setUrl:entity.url];
        [_contentView setStartdate:entity.startdate];
        [_contentView setEnddate:entity.enddate];
        [_contentView setTitle:entity.summary];
        [_contentView setDescription:entity.eventdescription];
        
        if (!entity.addDetailContent) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [_iCloudManager loadCalendarDetailContent:entity];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_itemArray.count > 0 && row < _itemArray.count) {
                        IMBCalendarEventEntity *calendarEvent = [_itemArray objectAtIndex:row];
                        if (calendarEvent == entity) {
                            [_contentView setDescription:calendarEvent.eventdescription];
                            [_contentView setUrl:calendarEvent.url];
                        }
                    }
                });
            });
        }
        
        if (_currentShowCalendarEntity != nil) {
            [_currentShowCalendarEntity release];
            _currentShowCalendarEntity = nil;
        }
        _currentShowCalendarEntity = [entity retain];
    }
}
#pragma mark - IMBImageRefreshListListener
- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    if (tableView == _itemTableView) {
        IMBiCloudCalendarCollectionEntity *collectionEntity = [_dataSourceArray objectAtIndex:index];
        if (collectionEntity.checkState == SemiChecked) {
            collectionEntity.checkState = Check;
        } else {
            collectionEntity.checkState = !collectionEntity.checkState;
        }
        for (IMBiCloudCalendarEventEntity *entity in collectionEntity.subArray) {
            entity.checkState = collectionEntity.checkState;
        }
        if (_itemArray != nil) {
            [_itemArray release];
            _itemArray = nil;
        }
        _itemArray = [collectionEntity.subArray retain];
        
    }else {
        IMBiCloudCalendarEventEntity *entity = [_itemArray objectAtIndex:index];
        entity.checkState = !entity.checkState;
        IMBiCloudCalendarCollectionEntity *collectionEntity = nil;
        for (IMBiCloudCalendarCollectionEntity *cEntity in _dataSourceArray) {
            if ([cEntity.guid isEqualToString:entity.pGuid]) {
                collectionEntity = cEntity;
                break;
            }
        }
        int i = 0;
        for (IMBiCloudCalendarEventEntity *entity in collectionEntity.subArray) {
            if (entity.checkState == Check) {
                i ++;
            }
        }
        if (i == collectionEntity.subArray.count && collectionEntity.subArray.count > 0) {
            collectionEntity.checkState = Check;
        }else if (i == 0 && collectionEntity.subArray.count > 0) {
            collectionEntity.checkState = UnChecked;
        }else {
            collectionEntity.checkState = SemiChecked;
        }
    }
    [_middleTableView reloadData];
    [_itemTableView reloadData];
}

#pragma mark PopupButton  AllSelect Sort
- (IBAction)leftSelectPopBtnClick:(id)sender {
    NSMenuItem *item = [_selectSortBtn selectedItem];
    NSInteger tag = [_selectSortBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _selectSortBtn.itemArray) {
        [menuItem setState:NSOffState];
    }
    if (tag == 1) {
        for (IMBiCloudCalendarCollectionEntity *collectionEntity in _dataSourceArray) {
            collectionEntity.checkState = Check;
            for (IMBiCloudCalendarEventEntity *entity in collectionEntity.subArray) {
                entity.checkState = Check;
            }
        }
    }else if (tag == 2){
        for (IMBiCloudCalendarCollectionEntity *collectionEntity in _dataSourceArray) {
            collectionEntity.checkState = UnChecked;
            for (IMBiCloudCalendarEventEntity *entity in collectionEntity.subArray) {
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
        for (IMBiCloudCalendarEventEntity *entity in _itemArray) {
            entity.checkState = Check;
            pguid = entity.pGuid;
        }
        for (IMBiCloudCalendarCollectionEntity *collectionEntity in _dataSourceArray) {
            if ([collectionEntity.guid isEqualToString:pguid]) {
                collectionEntity.checkState = Check;
                break;
            }
        }
    }else if (tag == 2){
        for (IMBiCloudCalendarEventEntity *entity in _itemArray) {
            entity.checkState = UnChecked;
            pguid = entity.pGuid;
        }
        for (IMBiCloudCalendarCollectionEntity *collectionEntity in _dataSourceArray) {
            if ([collectionEntity.guid isEqualToString:pguid]) {
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

#pragma mark addCalendarCollection deleteCalendarCollection
- (IBAction)addCalendarCollection:(id)sender {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    NSInteger result = [_alerView showTitleName:CustomLocalizedString(@"iCloud_add_newListName", nil) InputTextFiledString:@"" OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
    if (result == 1) {
        //进行增加操作
        [_logManger writeInfoLog:@"Do Add Playlist Strat"];
        [_alerView.renameLoadingView setHidden:NO];
        [_alerView.renameLoadingView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [_alerView.renameLoadingView setImage:[StringHelper imageNamed:@"registedLoading"]];
        [_alerView.renameLoadingView.layer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:-2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
        NSString *inputName = [[_alerView reNameInputTextField] stringValue];
        if (![TempHelper stringIsNilOrEmpty:inputName]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                BOOL success =  [_iCloudManager addCalenderCollection:inputName];
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_alerView unloadAlertView:_alerView.reNameView];
                        [_alerView.renameLoadingView setHidden:YES];
                        if (_dataSourceArray != nil) {
                            [_dataSourceArray release];
                            _dataSourceArray = nil;
                        }
                        _dataSourceArray = [_iCloudManager.calendarCollectionArray retain];
                        [_itemTableView reloadData];
                        int listSelectRow = (int)_dataSourceArray.count - 1;
                        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:listSelectRow] byExtendingSelection:NO];
                        [self selectiTemTableViewWithRow:listSelectRow];
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_alerView unloadAlertView:_alerView.reNameView];
                        [self performSelector:@selector(addCalendarCollectionErrorTip) withObject:nil afterDelay:0.2];
                    });
                }
            });
        }
    }
}

- (void)tableView:(NSTableView *)tableView rightDownrow:(NSInteger)index {
    if (index >=0 && index < _dataSourceArray.count) {
        IMBiCloudCalendarCollectionEntity *collEntity = [_dataSourceArray objectAtIndex:index];
        if (_rightDownCollectionEntity != nil) {
            [_rightDownCollectionEntity release];
            _rightDownCollectionEntity = nil;
        }
        _rightDownCollectionEntity = [collEntity retain];
        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
    }
}


- (IBAction)deleteCalendarCollection:(id)sender {
    
    NSMutableArray *collectArray = [[[NSMutableArray alloc] init] autorelease];
    for (IMBiCloudCalendarCollectionEntity *collectionEntity in _dataSourceArray) {
        if (collectionEntity.checkState == Check) {
            [collectArray addObject:collectionEntity];
        }
    }
    
    if (_dataSourceArray.count == 1) {
        NSString *str = CustomLocalizedString(@"iCloudCalendar_DeletePromptOnlyOne", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    if (_dataSourceArray.count == collectArray.count){
        NSString *str = CustomLocalizedString(@"iCloudCalendar_DeletePrompt", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    int result = 1;
    if (_rightDownCollectionEntity.subArray.count > 0) {
        _alerView.isStopPan = YES;
        result = [_alerView showAlertText:CustomLocalizedString(@"iCloud_delete_calanderList", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
    }
    
    if (result == 1) {
        [_mainBox setContentView:_loadingView];
        [_animationView startAnimation];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            BOOL success = NO;
            success = [_iCloudManager deleteCalenderCollection:_rightDownCollectionEntity];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    if (_dataSourceArray != nil) {
                        [_dataSourceArray release];
                        _dataSourceArray = nil;
                    }
                    _dataSourceArray = [_iCloudManager.calendarCollectionArray retain];
                    [_animationView endAnimation];
                    if (_dataSourceArray.count == 0) {
                        [self configNoDataView];
                        [_mainBox setContentView:_noDataView];
                    }else {
                        [_mainBox setContentView:_detailView];
                        [_itemTableView reloadData];
                        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                        [self selectiTemTableViewWithRow:0];
                        if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                            int count = 0;
                            for (IMBiCloudCalendarCollectionEntity *entity in _dataSourceArray) {
                                count += entity.subArray.count;
                            }
                            [_delegate refeashBadgeConut:count WithCategory:_category];
                        }
                    }
                }else {
                    [_animationView endAnimation];
                    if (_dataSourceArray == 0) {
                        [self configNoDataView];
                        [_mainBox setContentView:_noDataView];
                    }else {
                        [_mainBox setContentView:_detailView];
                    }
                    [self performSelector:@selector(deleteCalendarCollectionErrorTip) withObject:nil afterDelay:0.2];
                } 
            });
        });
    }
}

- (IBAction)doAddListItem:(id)sender {
    [self addCalendarCollection:nil];
}

#pragma mark iCloudReload iCloudAdd iCloudedit iCloudToMac

- (void)iCloudReload:(id)sender {
    [_mainBox setContentView:_loadingView];
    [_animationView startAnimation];
    [_toolBar toolBarButtonIsEnabled:NO];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Calendar Refresh" label:Start transferCount:0 screenView:@"Calendar View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [_iCloudManager getCalendarContent];
        if (_dataSourceArray != nil) {
            [_dataSourceArray release];
            _dataSourceArray = nil;
        }
        _dataSourceArray = [_iCloudManager.calendarCollectionArray retain];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_toolBar toolBarButtonIsEnabled:YES];
            if (_dataSourceArray.count == 0) {
                [self configNoDataView];
                [_mainBox setContentView:_noDataView];
            }else {
                [_mainBox setContentView:_detailView];
                NSNotification *noti = [NSNotification notificationWithName:@"" object:_itemTableView];
                [self tableViewSelectionDidChange:noti];
                [_itemTableView reloadData];
                [_middleTableView reloadData];
            }
            if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                [_delegate refeashBadgeConut:(int)_iCloudManager.calendarArray.count WithCategory:_category];
            }
            [_animationView endAnimation];
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Calendar Refresh" label:Finish transferCount:0 screenView:@"Calendar View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
        });
    });
}

- (void)deleteiCloudItems:(id)sender {
    NSMutableArray *arrayM = [[NSMutableArray alloc]init];
    NSMutableArray *collectArray = [[[NSMutableArray alloc] init] autorelease];
    for (IMBiCloudCalendarCollectionEntity *collectionEntity in _dataSourceArray) {
        if (collectionEntity.checkState == Check) {
            [collectArray addObject:collectionEntity];
        }else if (collectionEntity.checkState == SemiChecked) {
            for (IMBiCloudCalendarEventEntity *entity in collectionEntity.subArray) {
                if (entity.checkState == Check) {
                    [arrayM addObject:entity];
                }
            }
        }
    }
    if (_dataSourceArray.count == 1 && collectArray.count == 1) {
        NSString *str = CustomLocalizedString(@"iCloudCalendar_DeletePromptOnlyOne", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            return;
    }
    if (collectArray.count == _dataSourceArray.count) {
        NSString *str = CustomLocalizedString(@"iCloudCalendar_DeletePrompt", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    
    if (arrayM.count > 0 || collectArray.count > 0) {
        int y = 0;
        for (IMBiCloudCalendarCollectionEntity *entity in collectArray) {
            y += entity.subArray.count;
        }
        NSString *str;
        if ((arrayM.count + y) > 1 ) {
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
        if (_itemArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_delete", nil),CustomLocalizedString(@"MenuItem_id_62", nil)];
        }else {
            str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        }
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
        
    [_mainBox setContentView:_loadingView];
    [_animationView startAnimation];
    __block BOOL success;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int i = 0;
        for (IMBiCloudCalendarEventEntity *entity in arrayM) {
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Calendar Delete" label:Start transferCount:arrayM.count screenView:@"Calendar View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            success = [_iCloudManager deleteCalender:entity];
            if (success) {
                i ++;
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Calendar Delete" label:Finish transferCount:arrayM.count screenView:@"Calendar View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            
        }
        for (IMBiCloudCalendarCollectionEntity *collectionEntity in collectArray) {
             success = [_iCloudManager deleteCalenderCollection:collectionEntity];
            if (success) {
                if (collectionEntity.subArray.count < 1) {
                    i ++;
                }else {
                    i += collectionEntity.subArray.count;
                }
            }
        }
        
        if (i > 0) {
            [_iCloudManager getCalendarContent];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (_dataSourceArray != nil) {
                    [_dataSourceArray release];
                    _dataSourceArray = nil;
                }
                _dataSourceArray = [_iCloudManager.calendarCollectionArray retain];
                if (_dataSourceArray.count == 0) {
                    [self configNoDataView];
                    [_mainBox setContentView:_noDataView];
                }else {
                    [_mainBox setContentView:_detailView];
                }
                if (_dataSourceArray.count > 0) {
                    [_itemTableView reloadData];
                    int selectList = (int)[_itemTableView selectedRow];
                    if (selectList < 0 || selectList >= _dataSourceArray.count) {
                        selectList = 0;
                    }
                    [self selectiTemTableViewWithRow:selectList];
                }
                if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                    [_delegate refeashBadgeConut:(int)_iCloudManager.calendarArray.count WithCategory:_category];
                }
                [_animationView endAnimation];
            });
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (_dataSourceArray.count == 0) {
                     [self configNoDataView];
                    [_mainBox setContentView:_noDataView];
                }else {
                    [_mainBox setContentView:_detailView];
                }
                [_animationView endAnimation];
                [_itemTableView reloadData];
                [self performSelectorOnMainThread:@selector(showDeleteErrorTip) withObject:nil waitUntilDone:NO];
            });
        }
    });
    [arrayM autorelease];
}

- (void)doiClouditemEdit:(id)sender {
    NSInteger row = [_middleTableView selectedRow];
    if (row>=0&&row < [_itemArray count]) {
        IMBiCloudCalendarEventEntity *entity = [_itemArray objectAtIndex:row];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [_iCloudManager editCalender:entity];
        });
    }
}

- (void)addiCloudItems:(id)sender {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Calendar Add" label:Start transferCount:0 screenView:@"Calendar View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
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
    
    
    IMBiCloudCalendarEventEntity *icloudEntity = [[[IMBiCloudCalendarEventEntity alloc] init] autorelease];
    [icloudEntity setSummary:CustomLocalizedString(@"contact_id_48", nil)];
    
    [_itemArray insertObject:icloudEntity atIndex:0];
    [_summaryTextField  setStringValue:@""];
    [_locationTextField  setStringValue:@""];
    [_notesTextField.contentField  setStringValue:@""];
    [_urlTextFiled  setStringValue:@""];
    [_startTimePicker setDateValue:[NSDate date]];
    [_endTimePicker setDateValue:[NSDate date]];
    [_textBoxOne setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_textBoxOne setIsHaveCorner:YES];
    [_tetxBoxThree setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_tetxBoxThree setIsHaveCorner:YES];
    [_textBoxTwo setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_textBoxTwo setIsHaveCorner:YES];
    [_textBoxFour setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_textBoxFour setIsHaveCorner:YES];
    
    if (_dataSourceArray.count > 0) {
        //设置选组按钮
        [_groupButton setNewTag:_collectionEntity.tag];
        [_groupButton setFillColor:[ColorHelper colorWithHexString:_collectionEntity.color]];
        [_groupButton setIsHasBorder:YES];
        [_groupButton setBorderWidth:2];
        [_groupButton setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
        [_groupButton setNeedsDisplay:YES];
        [_groupButton setMenu:[self createNavagationMenu]];
    }
    [_middleTableView reloadData];
    [_middleTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [_contentScrollView setDocumentView:_calendarEditView];
    [_mainBox setContentView:_detailView];
    [_rightBox setContentView:_middleDetailView];
    _isCalendarAdd = YES;
    [_toolBar toolBarButtonIsEnabled:NO];
    _isEdit = YES;
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Calendar Add" label:Finish transferCount:0 screenView:@"Calendar View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}

- (void)iClouditemtoMac:(id)sender{
    NSMutableArray *arrayM = [[[NSMutableArray alloc] init] autorelease];
    for (IMBiCloudCalendarCollectionEntity *collectionEntity in _dataSourceArray) {
        if (collectionEntity.checkState == Check) {
            [arrayM addObjectsFromArray:collectionEntity.subArray];
        }else if (collectionEntity.checkState == SemiChecked) {
            for (IMBiCloudCalendarEventEntity *entity in collectionEntity.subArray) {
                if (entity.checkState == Check) {
                    [arrayM addObject:entity];
                }
            }
        }
    }
    if (arrayM.count <= 0) {
        //弹出警告确认框
        NSString *str = nil;
        if (_dataSourceArray.count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_transfer", nil),[StringHelper getCategeryStr:_category]];
        }else {
            str = CustomLocalizedString(@"Export_View_Selected_Tips", nil);
        }
        
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }else {
        //弹出路径选择框
        _openPanel = [NSOpenPanel openPanel];
        _isOpen = YES;
        [_openPanel setAllowsMultipleSelection:NO];
        [_openPanel setCanChooseFiles:NO];
        [_openPanel setCanChooseDirectories:YES];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Calendar Send to Mac" label:Start transferCount:0 screenView:@"Calendar View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [_openPanel beginSheetModalForWindow:[(IMBDeviceMainPageViewController *)_delegate view].window completionHandler:^(NSInteger result) {
            if (result== NSFileHandlingPanelOKButton) {
                [self performSelector:@selector(infortoMacDelay:) withObject:_openPanel afterDelay:0.1];

            }else{
                NSLog(@"other other other");
            }
        }];
    }
}

- (void)infortoMacDelay:(NSOpenPanel *)openPanel {
    NSMutableArray *arrayM = [[[NSMutableArray alloc] init] autorelease];
    for (IMBiCloudCalendarCollectionEntity *collectionEntity in _dataSourceArray) {
        if (collectionEntity.checkState == Check) {
            [arrayM addObjectsFromArray:collectionEntity.subArray];
        }else if (collectionEntity.checkState == SemiChecked) {
            for (IMBiCloudCalendarEventEntity *entity in collectionEntity.subArray) {
                if (entity.checkState == Check) {
                    [arrayM addObject:entity];
                }
            }
        }
    }

    NSViewController *annoyVC = nil;

    NSString *path = [[openPanel URL] path];
    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:_category]];
    [self copyInfomationToMac:filePath WithArray:arrayM Result:10 AnnoyVC:annoyVC];
}

- (void)copyInfomationToMac:(NSString *)filePath WithArray:(NSMutableArray *)selectedArray Result:(int)result AnnoyVC:(NSViewController *)annoyVC {

    NSString *mode = @"";
    if (_exportSetting != nil) {
        [_exportSetting release];
        _exportSetting = nil;
    }
    _exportSetting = [[IMBExportSetting alloc] initWithIPod:nil];
    mode = [_exportSetting getExportExtension:_exportSetting.calenderType];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Calendar Send to Mac" label:Finish transferCount:0 screenView:@"Calendar View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    
    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }

    _transferController =[[IMBTransferViewController alloc] initWithType:_category SelectItems:selectedArray ExportFolder:filePath Mode:mode IsicloudView:YES];
    
    if (result>0) {
        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
    }else{
        [self animationAddTransferView:_transferController.view];
        
    }
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
            NSMutableArray *arrayM = [[NSMutableArray alloc]init];
            for (IMBiCloudCalendarCollectionEntity *collectionEntity in _dataSourceArray) {
                if (collectionEntity.checkState == Check) {
                    [arrayM addObjectsFromArray:collectionEntity.subArray];
                }else if (collectionEntity.checkState == SemiChecked) {
                    for (IMBiCloudCalendarEventEntity *entity in collectionEntity.subArray) {
                        if (entity.checkState == Check) {
                            [arrayM addObject:entity];
                        }
                    }
                    
                }
            }
            if (arrayM.count > 0) {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Calendar To iCloud" label:Start transferCount:arrayM.count screenView:@"Calendar View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                if (_transferController != nil) {
                    [_transferController release];
                    _transferController = nil;
                }
                IMBBaseInfo *baseInfo = [baseInfoArr objectAtIndex:0];
//                NSDictionary *iCloudDic = [_delegate getiCloudAccountViewCollection];
                
                _otheriCloudManager = [[iCloudDic objectForKey:baseInfo.uniqueKey] iCloudManager];
                _transferController = [[IMBTransferViewController alloc] initWithType:_category withDelegate:self withTransfertype:TransferSync withIsicloudView:YES];
                
                [_transferController setDelegate:self];
                //                    [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:nil];
                [self animationAddTransferView:_transferController.view];
                if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
                    [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_62", nil)]];
                }
                
                NSString *msgStr = CustomLocalizedString(@"ImportSync_id_1", nil);
                if ([_transferController respondsToSelector:@selector(transferFile:)]) {
                    [_transferController transferFile:msgStr];
                }
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //每次都必须请求一次数据；
//                    [_otheriCloudManager getCalendarContent];
                    
                    /*如果传输实体的组的名字和另一个iCloud中Calendar的组名字,就传到对应名字下面，
                     否则新建一个组,
                     如果创建成功在将实体添加进去，
                     如果失败，就添加到第一个组里面*/
                    int i = 0 ;
                    for (IMBiCloudCalendarEventEntity *entity in arrayM) {
                        BOOL success = NO;
                        NSString *oriGuid = [entity.guid retain];
                        NSString *oriRtag = [entity.etag retain];
                        CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
                        NSString *guid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
                        [entity setGuid:guid];
                        [entity setEtag:@""];
                        BOOL _hasSetPguid = NO;
                        for (IMBiCloudCalendarCollectionEntity *otherCollenEntity in _otheriCloudManager.calendarCollectionArray) {
                            if ([otherCollenEntity.title isEqualToString:entity.groupTitle]) {
                                entity.pGuid = otherCollenEntity.guid;
                                _hasSetPguid = YES;
                                break;
                            }
                        }
                        BOOL AddGroupSuccess = NO;
                        if (!_hasSetPguid) {
                           AddGroupSuccess = [_otheriCloudManager addCalenderCollection:entity.groupTitle];
                            if (AddGroupSuccess && _otheriCloudManager.calendarCollectionArray.count > 0) {
                                for (IMBiCloudCalendarCollectionEntity *addCollectionentity in _otheriCloudManager.calendarCollectionArray) {
                                    if ([addCollectionentity.title isEqualToString:entity.groupTitle]) {
                                        entity.pGuid = addCollectionentity.guid;
                                    }
                                }
                                
                            }else {
                                if (_otheriCloudManager.calendarCollectionArray.count > 0) {
                                    IMBiCloudCalendarEventEntity *collectionEntity = [_otheriCloudManager.calendarCollectionArray objectAtIndex:0];
                                    entity.pGuid = collectionEntity.guid;
                                }
                            }
                        }

                        success = [_otheriCloudManager addCalender:entity];
                        [entity setGuid:oriGuid];
                        [entity setEtag:oriRtag];
                        [oriGuid release];
                        [oriRtag release];
                        if (success) {
                            i++;
                        }
                        

                        dispatch_sync(dispatch_get_main_queue(), ^{
                            NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),entity.summary];
                            if ([_transferController respondsToSelector:@selector(transferFile:)]) {
                                [_transferController transferFile:msgStr];
                            }
                            
                            [_transferController transferPrepareFileEnd];
                            if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
                                [_transferController transferProgress:i/arrayM.count *100];
                            }
                        });
                    }
                    double delayInSeconds =2;
                    
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                            NSDictionary *dimensionDict = nil;
                            @autoreleasepool {
                                dimensionDict = [[TempHelper customDimension] copy];
                            }
                            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Calendar To iCloud" label:Finish transferCount:arrayM.count screenView:@"Calendar View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                            if (dimensionDict) {
                                [dimensionDict release];
                                dimensionDict = nil;
                            }
                            [_transferController startTransAnimation];
                            [_transferController transferComplete:i TotalCount:(int)arrayM.count];
                            [arrayM autorelease];
                        }
                    });
                });
            }else {
                //弹出警告确认框
                NSString *str = nil;
                str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
                [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            }
        }else{
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

    for (IMBiCloudCalendarCollectionEntity *collectionEntity in _dataSourceArray) {
        if (collectionEntity.checkState == Check) {
            [arrayM addObjectsFromArray:collectionEntity.subArray];
        }else if (collectionEntity.checkState == SemiChecked) {
            for (IMBiCloudCalendarEventEntity *entity in collectionEntity.subArray) {
                if (entity.checkState == Check) {
                    [arrayM addObject:entity];
                }
            }
        }
    }
    if (arrayM.count > 0) {
        if (_transferController != nil) {
            [_transferController release];
            _transferController = nil;
        }
        IMBBaseInfo *baseInfo = (IMBBaseInfo *)sender;
        NSDictionary *iCloudDic = [_delegate getiCloudAccountViewCollection];
        _otheriCloudManager = [[iCloudDic objectForKey:baseInfo.uniqueKey] iCloudManager];
        _transferController = [[IMBTransferViewController alloc] initWithType:Category_Calendar withDelegate:self withTransfertype:TransferSync];
        [_transferController setIsicloudView:YES];
        [_transferController setDelegate:self];
        //            [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:nil];
        [self animationAddTransferView:_transferController.view];
        if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_62", nil)]];
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //每次都必须请求一次数据；
            [_otheriCloudManager getCalendarContent];
            int i = 0 ;
            for (IMBiCloudCalendarEventEntity *entity in arrayM) {
                BOOL success = NO;
                NSString *oriGuid = [entity.guid retain];
                NSString *oriRtag = [entity.etag retain];
                CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
                NSString *guid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
                [entity setGuid:guid];
                [entity setEtag:@""];
                if (_otheriCloudManager.calendarCollectionArray.count > 0) {
                    IMBiCloudCalendarEventEntity *collectionEntity = [_otheriCloudManager.calendarCollectionArray objectAtIndex:0];
                    entity.pGuid = collectionEntity.guid;
                }

                success = [_otheriCloudManager addCalender:entity];
                [entity setGuid:oriGuid];
                [entity setEtag:oriRtag];
                [oriGuid release];
                [oriRtag release];
                if (success) {
                    i++;
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
                        [_transferController transferProgress:i/arrayM.count *100];
                    }
                });
            }
            double delayInSeconds =2;
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                    [_transferController transferComplete:i TotalCount:(int)arrayM.count];
                    [arrayM release];
                }
            });
        });
        
    }else {
        //弹出警告确认框
        NSString *str = nil;
        str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
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

- (void)addCalendarCollectionErrorTip {
    [self showAlertText:[NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_AddCollection_Failed", nil),CustomLocalizedString(@"MenuItem_id_62", nil)] OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

- (void)deleteCalendarCollectionErrorTip {
    [self showAlertText:[NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_DeleteCollection_Failed", nil),CustomLocalizedString(@"MenuItem_id_62", nil)] OKButton:CustomLocalizedString(@"Button_Ok", nil)];
}

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
        
        NSString *addStr = CustomLocalizedString(@"iCloud_add_newList", nil);
        [_addListBtn mouseDownImage:[StringHelper imageNamed:@"add_item3"] withMouseUpImg:[StringHelper imageNamed:@"add_item1"]  withMouseExitedImg:[StringHelper imageNamed:@"add_item1"]  mouseEnterImg:[StringHelper imageNamed:@"add_item2"]  withButtonName:addStr];
        [_addListBtn setNeedsDisplay:YES];
        [_contentView setNeedsDisplay:YES];
        [_addListMenuItem setTitle:CustomLocalizedString(@"iCloud_add_newList", nil)];
    });
}

- (void)changeSkin:(NSNotification *)notification {
    [_leftLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_middleLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [self configNoDataView];
    [_topWhiteView setNeedsDisplay:YES];
    [_middleTopView setNeedsDisplay:YES];
    [_sortRightPopuBtn setNeedsDisplay:YES];
    [_selectSortBtn setNeedsDisplay:YES];
    [_middleSelectPopBtn setNeedsDisplay:YES];
    [_middleSortPopBtn setNeedsDisplay:YES];
    [_animationView setNeedsDisplay:YES];
    [_editAnimationView setNeedsDisplay:YES];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [_editLoadingView setIsGradientColorNOCornerPart3:YES];
    [_editLoadingView setNeedsDisplay:YES];

    NSString *addStr = CustomLocalizedString(@"iCloud_add_newList", nil);
    [_addListBtn mouseDownImage:[StringHelper imageNamed:@"add_item3"] withMouseUpImg:[StringHelper imageNamed:@"add_item1"]  withMouseExitedImg:[StringHelper imageNamed:@"add_item1"]  mouseEnterImg:[StringHelper imageNamed:@"add_item2"]  withButtonName:addStr];
    [_addListBtn setNeedsDisplay:YES];
    [_contentView setNeedsDisplay:YES];
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
    [_groupButton setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_textBoxOne setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_tetxBoxThree setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_textBoxTwo setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_textBoxFour setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];

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
    for (IMBiCloudCalendarCollectionEntity *entity in _dataSourceArray) {
        IMBGroupMenu *item = [[IMBGroupMenu alloc] init];
        [item setAction:@selector(navigateTo:)];
        [item setTarget:self];
        [item setTitle:entity.title];
        [item setGroupColor:[ColorHelper colorWithHexString:entity.color]];
        [item setTag:entity.tag];
        [mainMenu addItem:item];
        [item release];
    }
    
    return [mainMenu autorelease];
}
#pragma mark - 是否会弹出日历框
- (BOOL)datePickerShouldShowPopover:(ASHDatePicker *)datepicker {
    return YES;
}

- (void)netWorkFaultInterrupt {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertText:CustomLocalizedString(@"iCloudLogin_View_Tips2", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    });
}

- (void)dealloc {
    if (_itemArray != nil) {
        [_itemArray release];
        _itemArray = nil;
    }
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    if (_collectionEntity != nil) {
        [_collectionEntity release];
        _collectionEntity = nil;
    }
    if (_notesTextField != nil) {
        [_notesTextField release];
        _notesTextField = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
    [super dealloc];
}

@end
