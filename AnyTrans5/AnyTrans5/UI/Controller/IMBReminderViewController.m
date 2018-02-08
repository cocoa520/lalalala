//
//  IMBReminderViewController.m
//  AnyTrans
//
//  Created by iMobie on 17/2/27.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBReminderViewController.h"
#import "IMBCenterTextFieldCell.h"
#import "IMBCalendarsManager.h"
#import "IMBCustomCornerView.h"
#import <QuartzCore/QuartzCore.h>
#import "IMBCustomHeaderCell.h"
#import "DateHelper.h"
#import "IMBCheckBoxCell.h"
#import "IMBiCloudReminberEntity.h"
#import "IMBDatePicker.h"
#import "IMBiCloudMainPageViewController.h"
#import "IMBBaseViewController.h"
#import "IMBCalendarContentView.h"
#import "IMBCalendarEditView.h"
#import "IMBAnimation.h"
#import "IMBAddPlaylist.h"
#import "IMBNotificationDefine.h"

typedef enum {
    none = 0,
    Low = 9,
    Medium = 5,
    High = 1,
}PriorityEnum;

@interface IMBReminderViewController ()

@end

@implementation IMBReminderViewController
@synthesize collectionArr = _collectionArr;

#pragma mark - life

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"IMBReminderViewController" bundle:nil];
    if (self) {
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)ipod withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    if (self = [super initWithIpod:ipod withCategoryNodesEnum:category withDelegate:delegate]) {
        
    }
    return self;
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super doChangeLanguage:notification];
        
        [self configNoDataView];
        [self configEditView];
        [_contentView setEnddate:CustomLocalizedString(@"iCloud_NoDate", nil)];
        [_contentView setNeedsDisplay:YES];
        for (NSMenuItem *item in priorityPopBtn.menu.itemArray) {
            if (item.tag == 501) {
                [priorityPopBtn setTitle:CustomLocalizedString(@"icloud_reminder_1", nil)];
            }else if (item.tag == 502) {
                [priorityPopBtn setTitle:CustomLocalizedString(@"icloud_reminder_2", nil)];
            }else  if (item.tag == 503) {
                [priorityPopBtn setTitle:CustomLocalizedString(@"icloud_reminder_3", nil)];
            }else if (item.tag == 504) {
                [priorityPopBtn setTitle:CustomLocalizedString(@"icloud_reminder_4", nil)];
            }
        }
        NSString *addStr = CustomLocalizedString(@"iCloud_add_newList", nil);
        NSRect rect = [StringHelper calcuTextBounds:addStr fontSize:14];
        float w = 110;
        if (rect.size.width > 80) {
            w = rect.size.width + 30;
        }
        [_addListBtn setFrame:NSMakeRect((_buttomView.frame.size.width - w)/2, _addListBtn.frame.origin.y, w, _addListBtn.frame.size.height)];
        [_addListBtn mouseDownImage:[StringHelper imageNamed:@"add_item3"] withMouseUpImg:[StringHelper imageNamed:@"add_item1"]  withMouseExitedImg:[StringHelper imageNamed:@"add_item1"]  mouseEnterImg:[StringHelper imageNamed:@"add_item2"]  withButtonName:addStr];
        [_addListBtn setNeedsDisplay:YES];
    });
}

- (void)changeSkin:(NSNotification *)notification {
    [_itemTableView setBackgroundColor:[NSColor clearColor]];
    [_collectionItemTableView setBackgroundColor:[NSColor clearColor]];
    [self configNoDataView];
    [_reminderDetailView setNeedsDisplay:YES];
    [_topWhiteView setNeedsDisplay:YES];
    [_topwhiteView2 setNeedsDisplay:YES];
    [_sortRightPopuBtn setNeedsDisplay:YES];
    [_selectSortBtn setNeedsDisplay:YES];
    [_sortRightPopuBtn2 setNeedsDisplay:YES];
    [_selectSortBtn2 setNeedsDisplay:YES];
    [_loadingAnimationView setNeedsDisplay:YES];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_loadingView setNeedsDisplay:YES];
    [_editLoadingView setIsGradientColorNOCornerPart3:YES];
    [_editLoadingView setNeedsDisplay:YES];
    [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
    [_reminderlistView setNeedsDisplay:YES];
    [_reminderlistView2 setNeedsDisplay:YES];
    [self.view setNeedsDisplay:YES];
    [self configEditView];
    [_notesTextField.contentField setNeedsDisplay:YES];
    [_reminderTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_reminderCheckLb setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    NSString *addStr = CustomLocalizedString(@"iCloud_add_newList", nil);
    NSRect rect = [StringHelper calcuTextBounds:addStr fontSize:14];
    float w = 110;
    if (rect.size.width > 80) {
        w = rect.size.width + 30;
    }
    [_addListBtn setFrame:NSMakeRect((_buttomView.frame.size.width - w)/2, _addListBtn.frame.origin.y, w, _addListBtn.frame.size.height)];
    [_addListBtn mouseDownImage:[StringHelper imageNamed:@"add_item3"] withMouseUpImg:[StringHelper imageNamed:@"add_item1"]  withMouseExitedImg:[StringHelper imageNamed:@"add_item1"]  mouseEnterImg:[StringHelper imageNamed:@"add_item2"]  withButtonName:addStr];
    [_addListBtn setNeedsDisplay:YES];
}

- (void)awakeFromNib {
    _isloadingPopBtn = YES;
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkFaultInterrupt) name:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
    _itemTableViewcanDrag = NO;
    _itemTableViewcanDrop = NO;
    _collectionViewcanDrag = NO;
    _collectionViewcanDrop = NO;
    
    [_collectionItemTableView setListener:self];
    [_collectionItemTableView setFocusRingType:NSFocusRingTypeNone];
    
    _collectionArr = [[NSMutableArray alloc] init];
    _dataSourceArray = [[NSMutableArray alloc] init];
    alerView = [[IMBAlertViewController alloc]initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_loadingView setIsGradientColorNOCornerPart3:YES];
    [_editLoadingView setIsGradientColorNOCornerPart3:YES];
    [_mainBox setAutoresizesSubviews:YES];
    if (_isiCloudView) {
        [_mainBox setContentView:_loadingView];
        [_loadingAnimationView startAnimation];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            _collectionArr = [_iCloudManager.reminderCollectionArray retain];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_loadingAnimationView endAnimation];
                
                //addBtn
                [_buttomView setBackgroundColor:[NSColor clearColor]];
                NSString *addStr = CustomLocalizedString(@"iCloud_add_newList", nil);
                NSRect rect = [StringHelper calcuTextBounds:addStr fontSize:14];
                float w = 110;
                if (rect.size.width > 80) {
                    w = rect.size.width + 30;
                }
                [_addListBtn setFrame:NSMakeRect((_buttomView.frame.size.width - w)/2, _addListBtn.frame.origin.y, w, _addListBtn.frame.size.height)];
                [_addListBtn mouseDownImage:[StringHelper imageNamed:@"add_item3"] withMouseUpImg:[StringHelper imageNamed:@"add_item1"]  withMouseExitedImg:[StringHelper imageNamed:@"add_item1"]  mouseEnterImg:[StringHelper imageNamed:@"add_item2"]  withButtonName:addStr];
                
                [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
                
                _itemTableView.allowsMultipleSelection = NO;
                _collectionItemTableView.allowsMultipleSelection = NO;
                isFinished = YES;
                [_reminderDetailView setHastopBorder:NO leftBorder:YES BottomBorder:NO rightBorder:NO];
                _contentView = [[IMBCalendarContentView alloc] initWithFrame:NSMakeRect(0, 0, _reminderDetailView.frame.size.width -15, _reminderDetailView.frame.size.height - 5) WithCategory:_category];
                [_contentView setHasEditBtn:YES];
                [_contentView setAutoresizesSubviews:YES];
                [_contentView setAutoresizingMask:NSViewHeightSizable|NSViewWidthSizable];
                
                
                if (_collectionArr.count <= 0) {
                    [_mainBox setContentView:_noDataView];
                    [self configNoDataView];
                }  else {
                    
                    IMBiCloudCalendarCollectionEntity *entity = [_collectionArr objectAtIndex:0];
                    if (_dataSourceArray != nil) {
                        [_dataSourceArray release];
                        _dataSourceArray = nil;
                    }
                    _dataSourceArray = [entity.subArray retain];
                    
                    [_collectionItemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                    if (_dataSourceArray.count <= 0) {
                        [self configNoCollectionDataView];
                        [_contentBox setContentView:_noCollectionDataView];
                    } else {
                        [_contentBox setContentView:_contentMainView];
                        [_reminderDetailView setDocumentView:_contentView];
                        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                    }
                    [_mainBox setContentView:_reminderView];
                }
                
                [_reminderEditView setFrame:NSMakeRect(0, 0, _reminderDetailView.frame.size.width -15, _reminderDetailView.frame.size.height - 5)];
                _topWhiteView.isBommt = YES;
                [_topWhiteView setBackgroundColor:[NSColor clearColor]];
                _topwhiteView2.isBommt = YES;
                [_topwhiteView2 setBackgroundColor:[NSColor clearColor]];
                [_itemTableView setGridStyleMask:NSTableViewGridNone];
                
                //编辑界面
                [self showEditView];
                //保存或者取消编辑
                [self saveOrCancelEditView];
                
                [_itemTableView setAllowsEmptySelection:NO];
                
                if (_dataSourceArray.count>0) {
                    [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                }
                [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
            });
        });
    }
    else {
        if (_dataSourceArray.count <= 0) {
            [_mainBox setContentView:_noDataView];
        }else {
            [_mainBox setContentView:_reminderView];
        }
        
        [self configNoDataView];
        _itemTableView.allowsMultipleSelection = NO;
        isFinished = YES;
        [_reminderDetailView setHastopBorder:NO leftBorder:YES BottomBorder:NO rightBorder:NO];
        _contentView = [[IMBCalendarContentView alloc] initWithFrame:NSMakeRect(0, 0, _reminderDetailView.frame.size.width -15, _reminderDetailView.frame.size.height - 5)];
        [_contentView setHasEditBtn:NO];
        [_contentView setAutoresizesSubviews:YES];
        [_contentView setAutoresizingMask:NSViewHeightSizable|NSViewWidthSizable];
        [_reminderDetailView setDocumentView:_contentView];
        
        
        _topWhiteView.isBommt = YES;
        [_topWhiteView setBackgroundColor:[NSColor clearColor]];
        _topwhiteView2.isBommt = YES;
        [_topwhiteView2 setBackgroundColor:[NSColor clearColor]];
        [_itemTableView setGridStyleMask:NSTableViewGridNone];
        
        
        if (_dataSourceArray.count>0) {
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }
        
        [_buttomView setBackgroundColor:[NSColor clearColor]];
        NSString *addStr = CustomLocalizedString(@"Button_id_1", nil);
        NSRect rect = [StringHelper calcuTextBounds:addStr fontSize:14];
        float w = 110;
        if (rect.size.width > 80) {
            w = rect.size.width + 30;
        }
        [_addListBtn setFrame:NSMakeRect((_buttomView.frame.size.width - w)/2, _addListBtn.frame.origin.y, w, _addListBtn.frame.size.height)];
        [_addListBtn mouseDownImage:[StringHelper imageNamed:@"add_item3"] withMouseUpImg:[StringHelper imageNamed:@"add_item1"]  withMouseExitedImg:[StringHelper imageNamed:@"add_item1"]  mouseEnterImg:[StringHelper imageNamed:@"add_item2"]  withButtonName:addStr];
        
        [(IMBWhiteView *)self.view setIsGradientColorNOCornerPart3:YES];
        
    }
}

- (void)dealloc {
    if (_collectionArr != nil) {
        [_collectionArr release];
        _collectionArr = nil;
    }
    if (_contentView != nil) {
        [_contentView release];
        _contentView = nil;
    }
    if (_dataSourceArray != nil) {
        [_dataSourceArray release];
        _dataSourceArray = nil;
    }
    if (_notesTextField != nil) {
        [_notesTextField release];
        _notesTextField = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTITY_NETWORK_FAULT_INTERRUPT object:nil];
    [super dealloc];
}

#pragma mark - 点击进入编辑界面
- (void)showEditView {
    _contentView.editBlock = ^{
        
        _contentView.frame = NSMakeRect(0, 0, _reminderDetailView.frame.size.width -15, _reminderDetailView.frame.size.height - 5);
        [_reminderEditView setFrame:NSMakeRect(0, 0, _reminderDetailView.frame.size.width -15, _reminderDetailView.frame.size.height - 5)];
        
        _isEdit = YES;
        [_toolBar toolBarButtonIsEnabled:NO];
        _isReminderAdd = NO;
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Reminder Edit" label:Click transferCount:0 screenView:@"Reminder View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        
        [self configEditView];
        
        if ([_dataSourceArray count] == 0) {
            isFinished = YES;
            return ;
        }
        if (isFinished) {
            isFinished = NO;
            NSInteger row = [_itemTableView selectedRow];
            IMBiCloudCalendarEventEntity *entity = nil;
            if (row == -1) {
                isFinished = YES;
                return;
            } else if(row < [_dataSourceArray count]) {
                entity = [_dataSourceArray objectAtIndex:row];
            }
            [self configEditViewPopButton:entity];
            if (_currentShowiCloudCalendarEntity != nil) {
                [_currentShowiCloudCalendarEntity release],_currentShowiCloudCalendarEntity = nil;
            }
            _currentShowiCloudCalendarEntity = [entity retain];;
            
            if (![StringHelper stringIsNilOrEmpty:entity.summary]) {
                [_reminderTitle setStringValue:entity.summary];
            }
            if (![StringHelper stringIsNilOrEmpty:entity.eventdescription]) {
                [_notesTextField.contentField setStringValue:entity.eventdescription];
            } else {
                [_notesTextField.contentField setStringValue:@""];
            }
            if (![StringHelper stringIsNilOrEmpty:entity.startdate]) {
                [_datePicker setDateValue:[DateHelper dateFromString:entity.startdate Formate:nil]];
            }
            
            int priority = entity.priority;
            for (NSMenuItem *item in priorityPopBtn.menu.itemArray ) {
                if (priority == none) {
                    if (item.tag == 501) {
                        [item setState:NSOnState];
                        [priorityPopBtn selectItem:item];
                        [priorityPopBtn setTitle:CustomLocalizedString(@"icloud_reminder_1", nil)];
                        
                    }else {
                        [item setState:NSOffState];
                    }
                    
                }else if (priority == Low) {
                    if (item.tag == 502) {
                        [item setState:NSOnState];
                        [priorityPopBtn selectItem:item];
                        [priorityPopBtn setTitle:CustomLocalizedString(@"icloud_reminder_2", nil)];
                    }else {
                        [item setState:NSOffState];
                    }
                }else if (priority == Medium) {
                    if (item.tag == 503) {
                        [item setState:NSOnState];
                        [priorityPopBtn selectItem:item];
                        [priorityPopBtn setTitle:CustomLocalizedString(@"icloud_reminder_3", nil)];
                    }else {
                        [item setState:NSOffState];
                    }
                }else if (priority == High) {
                    if (item.tag == 504) {
                        [item setState:NSOnState];
                        [priorityPopBtn selectItem:item];
                        [priorityPopBtn setTitle:CustomLocalizedString(@"icloud_reminder_4", nil)];
                    }else {
                        [item setState:NSOffState];
                    }
                }
                [priorityPopBtn setNeedsDisplay:YES];
            }
            
            
            NSString *groupGuid = entity.pGuid;
            NSArray *listArray = [NSArray arrayWithArray:_iCloudManager.reminderCollectionArray];
            
            for (IMBiCloudCalendarCollectionEntity *collectionEntity in listArray) {
                if ([collectionEntity.guid isEqualToString:groupGuid]) {
                    for (NSMenuItem *item in _listPopBtn.menu.itemArray) {
                        if (item.tag == collectionEntity.tag) {
                            [item setState:NSOnState];
                            [_listPopBtn selectItem:item];
                            [_listPopBtn setTitle:item.title];
                        }else {
                            [item setState:NSOffState];
                        }
                    }
                }
            }
            NSDate *dueDate = [DateHelper dateFrom1970:entity.dueTime];
            [_datePicker setDateValue:dueDate];
            
            [_listPopBtn setHasBorderLine:YES];
            [_listPopBtn setNoMaxWidth:YES];
            [_listPopBtn setNeedsDisplay:YES];
            [priorityPopBtn setHasBorderLine:YES];
            [priorityPopBtn setNoMaxWidth:YES];
            [priorityPopBtn setNeedsDisplay:YES];
            [_reminderDetailView.layer removeAllAnimations];
            CATransition *transition = [CATransition animation];
            transition.delegate = self;
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = @"moveIn";
            transition.subtype = kCATransitionFromBottom;
            [_reminderDetailView setDocumentView:_reminderEditView];
            [_reminderDetailView.layer addAnimation:transition forKey:@"transiton"];
            
        }
        
    };
}

#pragma mark - 配置编辑界面文字颜色
- (void)configEditView {
    [_reminderTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_reminderCheckLb setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_reminderCheckLb setStringValue:CustomLocalizedString(@"icloud_reminder_8", nil)];
    [_descriptionLb setStringValue:[CustomLocalizedString(@"DeviceDetailed_Description", nil) stringByAppendingString:@":"]];
    [_descriptionLb setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_listLb setStringValue:[CustomLocalizedString(@"icloud_reminder_9", nil) stringByAppendingString:@":"]];
    [_listLb setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_priorityLb setStringValue:[CustomLocalizedString(@"icloud_reminder_10", nil) stringByAppendingString:@":"]];
    [_priorityLb setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_checkBtn setUnCheckImg:[StringHelper imageNamed:@"sel_non" ]];
    [_checkBtn setCheckImg:[StringHelper imageNamed:@"sel_all" ]];
    [_checkBtn setNeedsDisplay:YES];
    
    [_datePicker setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    _datePicker.preferredPopoverEdge = NSMaxXEdge;
    [_datePicker setNeedsDisplay:YES];
    
    [_borderView setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_borderView setIsHaveCorner:YES];
    
    [_descriptionBorderView setBorderColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_descriptionBorderView setIsHaveCorner:YES];
    
    if (_notesTextField != nil) {
        [_notesTextField release];
        _notesTextField = nil;
    }
    [_descripScrollView setHastopBorder:NO leftBorder:NO BottomBorder:NO rightBorder:NO];
    _notesTextField = [[IMBCalendarNoteEditView alloc] initWithFrame:NSMakeRect(0, 0, _descripScrollView.frame.size.width, _descripScrollView.frame.size.height)];
    [_descripScrollView setDocumentView:_notesTextField];
    [_notesTextField setAutoresizesSubviews:YES];
    [_notesTextField setIsEditing:YES];
    [_notesTextField setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin|NSViewWidthSizable|NSViewHeightSizable];
    
}

#pragma mark - 编辑完成后点击保存或者取消
- (void)saveOrCancelEditView {
    _reminderEditView.saveBlock = ^(IMBMyDrawCommonly *button){
        if (isFinished) {
            
            if (button.tag == 102) {//取消操作
                [_toolBar toolBarButtonIsEnabled:YES];
                _isEdit = NO;
                isFinished = YES;
                [_reminderDetailView.layer removeAllAnimations];
                CATransition *transition = [CATransition animation];
                transition.delegate = self;
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = @"moveIn";
                transition.subtype = kCATransitionFromBottom;
                _contentView.frame = NSMakeRect(0, 0, _reminderDetailView.frame.size.width -15, _reminderDetailView.frame.size.height - 5);
                [_reminderEditView setFrame:NSMakeRect(0, 0, _reminderDetailView.frame.size.width -15, _reminderDetailView.frame.size.height - 5)];
                [_reminderDetailView setDocumentView:_contentView];
                [_reminderDetailView.layer addAnimation:transition forKey:@"transiton"];
                
                //reminderAdd页面
                if (_isReminderAdd) {
                    [_dataSourceArray removeObjectAtIndex:0];
                    
                    if (_dataSourceArray.count <1) {
                        [self configNoCollectionDataView];
                        [_contentBox setContentView:_noCollectionDataView];
                        return ;
                    }
                    
                    int row = (int)[_itemTableView selectedRow];
                    if (row == 0) {
                        [self tableViewSelectRow:0];
                    }else {
                        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                    }
                    [_itemTableView reloadData];
                    [_collectionItemTableView reloadData];
                    
                } else {// reminder Edit页面
                    NSInteger row = [_itemTableView selectedRow];
                    [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
                }
            }
            else if (button.tag == 101){//done操作
                
                _contentView.frame = NSMakeRect(0, 0, _reminderDetailView.frame.size.width -15, _reminderDetailView.frame.size.height - 5);
                
                [_reminderEditView setFrame:NSMakeRect(0, 0, _reminderDetailView.frame.size.width -15, _reminderDetailView.frame.size.height - 5)];
                
                isFinished = YES;
                _isEdit = NO;
                if (_reminderTitle.stringValue == nil ||[_reminderTitle.stringValue isEqualToString:@""]) {
                    [self showAlertText:CustomLocalizedString(@"Calendar_id_8", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
                    isFinished = YES;
                    [_toolBar toolBarButtonIsEnabled:YES];
                    return ;
                }
                
                if (_isReminderAdd) {
                    [_mainBox setContentView:_loadingView];
                    [_loadingAnimationView startAnimation];
                    ReminderAddModel *addEntity = [[[ReminderAddModel alloc] init] autorelease];
                    addEntity.dataModel.title = _reminderTitle.stringValue;
                    addEntity.dataModel.description = _notesTextField.contentField.stringValue;
                    
                    int selectTag = (int)[_listPopBtn selectedItem].tag;
                    NSString *pguid = nil;
                    for (IMBiCloudCalendarCollectionEntity *collectionEntity in _iCloudManager.reminderCollectionArray) {
                        if (collectionEntity.tag == selectTag) {
                            pguid = collectionEntity.guid;
                            break;
                        }
                    }
                    addEntity.dataModel.pGuid = pguid;
                    
                    int priorityTag = (int)[priorityPopBtn selectedItem].tag;
                    if (priorityTag == 501) {
                        addEntity.dataModel.priority = 0;
                    }else if (priorityTag == 502) {
                        addEntity.dataModel.priority = 9;
                    }else if (priorityTag == 503) {
                        addEntity.dataModel.priority = 5;
                    }else if (priorityTag == 504) {
                        addEntity.dataModel.priority = 1;
                    }else {
                        addEntity.dataModel.priority = 0;
                    }
                    if (_checkBtn.state == 0) {
                        addEntity.dataModel.dueDateIsAllDay = NO;
                    }else {
                        addEntity.dataModel.dueDateIsAllDay = YES;
                    }
                    addEntity.dataModel.completedDate = @"";
                    addEntity.dataModel.recurrence = @"";
                    addEntity.dataModel.startDateIsAllDay = NO;
                    
                    CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
                    NSString *guid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
                    
                    addEntity.dataModel.guid = guid;
                    
                    NSString *date1 = [DateHelper dateFrom2001ToDate:_datePicker.dateValue withMode:2];
                    NSString *dueStr1 = [[date1 substringWithRange:NSMakeRange(0, 10)] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    [addEntity.dataModel.dueDate addObject:[NSNumber numberWithInt:[dueStr1 intValue]]];
                    NSString *dueStr2 = [date1 substringWithRange:NSMakeRange(0, 4)];
                    [addEntity.dataModel.dueDate addObject:[NSNumber numberWithInt:[dueStr2 intValue]]];
                    NSString *dueStr3 = [date1 substringWithRange:NSMakeRange(5, 2)];
                    [addEntity.dataModel.dueDate addObject:[NSNumber numberWithInt:[dueStr3 intValue]]];
                    NSString *dueStr4 = [date1 substringWithRange:NSMakeRange(8, 2)];
                    [addEntity.dataModel.dueDate addObject:[NSNumber numberWithInt:[dueStr4 intValue]]];
                    NSString *dueStr5 = [date1 substringWithRange:NSMakeRange(11, 2)];
                    [addEntity.dataModel.dueDate addObject:[NSNumber numberWithInt:[dueStr5 intValue]]];
                    NSString *dueStr6 = [date1 substringWithRange:NSMakeRange(14, 2)];
                    [addEntity.dataModel.dueDate addObject:[NSNumber numberWithInt:[dueStr6 intValue]]];
                    NSString *dueStr7 = [date1 substringWithRange:NSMakeRange(17, 2)];
                    [addEntity.dataModel.dueDate addObject:[NSNumber numberWithInt:[dueStr7 intValue]]];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        BOOL success = [_iCloudManager addReminder:addEntity withPguid:pguid];
                        [_iCloudManager getReminderContent];
                        
                        if (_collectionArr != nil) {
                            [_collectionArr release];
                            _collectionArr = nil;
                        }
                        _collectionArr = [_iCloudManager.reminderCollectionArray retain];
                        if (_collectionArr.count < 1) {
                            [_mainBox setContentView:_noDataView];
                            return ;
                        }
                        NSInteger row = [_collectionItemTableView selectedRow];
                        if (row > _collectionArr.count || row < 0) {
                            row = 0;
                        }
                        IMBiCloudCalendarCollectionEntity *entity = [_collectionArr objectAtIndex:row];
                        if (_dataSourceArray != nil) {
                            [_dataSourceArray release];
                            _dataSourceArray = nil;
                        }
                        _dataSourceArray = [entity.subArray retain];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_mainBox setContentView:_reminderView];
                            [_loadingAnimationView endAnimation];
                            [_toolBar toolBarButtonIsEnabled:YES];
                            if (success) {
                                
                                [_itemTableView reloadData];
                                IMBiCloudCalendarEventEntity *iCloudEntity = [_dataSourceArray objectAtIndex:0];
                                
                                iCloudEntity.summary = addEntity.dataModel.title;
                                iCloudEntity.eventdescription = addEntity.dataModel.description;
                                NSTimeInterval time = [_datePicker.dateValue timeIntervalSince1970];
                                long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
                                iCloudEntity.dueTime = dTime;
                                [_itemTableView reloadData];
                                [self tableViewSelectRow:0];
                                
                            } else {
                                
                                isFinished = YES;
                                [self performSelectorOnMainThread:@selector(showAddErrorTip) withObject:nil waitUntilDone:NO];
                                
                            }
                        });
                        
                    });
                }else {
                    [_editBox setContentView:_editLoadingView];
                    [_editLoadingAnimationView startAnimation];
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        
                        NSInteger selectTag = 0;
                        for (NSMenuItem *item in _listPopBtn.menu.itemArray) {
                            if (item.state == NSOnState) {
                                selectTag = item.tag;
                                break;
                            }
                        }
                        NSString *selectedPGuid = nil;
                        for (IMBiCloudCalendarCollectionEntity *collectionEntity in _iCloudManager.reminderCollectionArray) {
                            if (collectionEntity.tag == selectTag) {
                                selectedPGuid = collectionEntity.guid;
                                break;
                            }
                        }
                        if ([StringHelper stringIsNilOrEmpty:selectedPGuid]) {
                            isFinished = YES;
                            return ;
                        }
                        //初始化
                        ReminderEditModel *editModel = [[ReminderEditModel alloc] init];
                        editModel.dataModel.title = _reminderTitle.stringValue;
                        if (![StringHelper stringIsNilOrEmpty:_notesTextField.contentField.stringValue]) {
                            editModel.dataModel.description = _notesTextField.contentField.stringValue;
                        }else {
                            editModel.dataModel.description = @"";
                            
                        }
                        
                        editModel.dataModel.pGuid = selectedPGuid;
                        if (![_currentShowiCloudCalendarEntity.pGuid isEqualToString:selectedPGuid]) {
                            editModel.oldpGuid = _currentShowiCloudCalendarEntity.pGuid;
                        }
                        
                        int priorityTag = (int)[priorityPopBtn selectedItem].tag;
                        if (priorityTag == 501) {
                            editModel.dataModel.priority = 0;
                        }else if (priorityTag == 502) {
                            editModel.dataModel.priority = 9;
                        }else if (priorityTag == 503) {
                            editModel.dataModel.priority = 5;
                        }else if (priorityTag == 504) {
                            editModel.dataModel.priority = 1;
                        }else {
                            editModel.dataModel.priority = 0;
                        }
                        if (_checkBtn.state == 0) {
                            editModel.dataModel.dueDateIsAllDay = NO;
                        }else {
                            editModel.dataModel.dueDateIsAllDay = YES;
                        }
                        editModel.dataModel.completedDate = @"";
                        editModel.dataModel.recurrence = @"";
                        editModel.dataModel.startDateIsAllDay = NO;
                        
                        editModel.dataModel.guid = _currentShowiCloudCalendarEntity.guid;
                        NSString *date1 = [DateHelper dateFrom2001ToDate:_datePicker.dateValue withMode:2];
                        NSString *dueStr1 = [[date1 substringWithRange:NSMakeRange(0, 10)] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                        [editModel.dataModel.dueDate addObject:[NSNumber numberWithInt:[dueStr1 intValue]]];
                        NSString *dueStr2 = [date1 substringWithRange:NSMakeRange(0, 4)];
                        [editModel.dataModel.dueDate addObject:[NSNumber numberWithInt:[dueStr2 intValue]]];
                        NSString *dueStr3 = [date1 substringWithRange:NSMakeRange(5, 2)];
                        [editModel.dataModel.dueDate addObject:[NSNumber numberWithInt:[dueStr3 intValue]]];
                        NSString *dueStr4 = [date1 substringWithRange:NSMakeRange(8, 2)];
                        [editModel.dataModel.dueDate addObject:[NSNumber numberWithInt:[dueStr4 intValue]]];
                        NSString *dueStr5 = [date1 substringWithRange:NSMakeRange(11, 2)];
                        [editModel.dataModel.dueDate addObject:[NSNumber numberWithInt:[dueStr5 intValue]]];
                        NSString *dueStr6 = [date1 substringWithRange:NSMakeRange(14, 2)];
                        [editModel.dataModel.dueDate addObject:[NSNumber numberWithInt:[dueStr6 intValue]]];
                        NSString *dueStr7 = [date1 substringWithRange:NSMakeRange(17, 2)];
                        [editModel.dataModel.dueDate addObject:[NSNumber numberWithInt:[dueStr7 intValue]]];
                        
                        editModel.creatDate = [NSMutableArray arrayWithArray:_currentShowiCloudCalendarEntity.createDate];
                        editModel.order = _currentShowiCloudCalendarEntity.order;
                        editModel.startdate = _currentShowiCloudCalendarEntity.startdate;
                        editModel.startDateTz = _currentShowiCloudCalendarEntity.startDateTz;
                        editModel.createdDateExtended = _currentShowiCloudCalendarEntity.createdDateExtended;
                        NSDate *currentDate = [NSDate date];
                        NSString *currentDateString= [DateHelper stringFromFomate:currentDate formate:@"yyyy/MM/dd HH:mm:ss"];
                        
                        NSString *dStr1 = [[currentDateString substringWithRange:NSMakeRange(0, 10)] stringByReplacingOccurrencesOfString:@"/" withString:@""];
                        [editModel.lastModifiedDate addObject:[NSNumber numberWithInt:[dStr1 intValue]]];
                        NSString *dStr2 = [currentDateString substringWithRange:NSMakeRange(0, 4)];
                        [editModel.lastModifiedDate addObject:[NSNumber numberWithInt:[dStr2 intValue]]];
                        NSString *dStr3 = [currentDateString substringWithRange:NSMakeRange(5, 2)];
                        [editModel.lastModifiedDate addObject:[NSNumber numberWithInt:[dStr3 intValue]]];
                        NSString *dStr4 = [currentDateString substringWithRange:NSMakeRange(8, 2)];
                        [editModel.lastModifiedDate addObject:[NSNumber numberWithInt:[dStr4 intValue]]];
                        NSString *dStr5 = [currentDateString substringWithRange:NSMakeRange(11, 2)];
                        [editModel.lastModifiedDate addObject:[NSNumber numberWithInt:[dStr5 intValue]]];
                        NSString *dStr6 = [currentDateString substringWithRange:NSMakeRange(14, 2)];
                        [editModel.lastModifiedDate addObject:[NSNumber numberWithInt:[dStr6 intValue]]];
                        NSString *dStr7 = [currentDateString substringWithRange:NSMakeRange(17, 2)];
                        [editModel.lastModifiedDate addObject:[NSNumber numberWithInt:[dStr7 intValue]]];
                        
                        BOOL success = [_iCloudManager editReminder:editModel withPguid:selectedPGuid];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_editBox setContentView:nil];
                            [_editLoadingAnimationView endAnimation];
                            [_toolBar toolBarButtonIsEnabled:YES];
                            if (success) {
                                [_iCloudManager getReminderContent];
                                if (_collectionArr != nil) {
                                    [_collectionArr release];
                                    _collectionArr = nil;
                                }
                                _collectionArr = [_iCloudManager.reminderCollectionArray retain];
                                for (IMBiCloudCalendarCollectionEntity *collentity in _collectionArr) {
                                    for (IMBiCloudCalendarEventEntity *entity in collentity.subArray) {
                                        if ([entity.guid isEqualToString:editModel.dataModel.guid]) {
                                            if (_dataSourceArray != nil) {
                                                [_dataSourceArray release];
                                                _dataSourceArray = nil;
                                            }
                                            _dataSourceArray = [collentity.subArray retain];
                                        }
                                    }
                                }
                                NSInteger row = [_itemTableView selectedRow];
                                if (row < 0 || row >= _dataSourceArray.count){
                                    row = 0;
                                }
                                [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
                                [_itemTableView reloadData];
                                [_contentView setTitle:editModel.dataModel.title];
                                
                                [_contentView setStartdate:[DateHelper dateFrom2001ToDate:_datePicker.dateValue withMode:2]];
                                [_contentView setEnddate:CustomLocalizedString(@"iCloud_NoDate", nil)];
                                [_contentView setDescription:editModel.dataModel.description];
                                
                                _isEdit = NO;
                                
                                [_reminderDetailView setDocumentView:_contentView];
                                [_contentView setFrame:NSMakeRect(0, 0, _reminderDetailView.frame.size.width -15, _reminderDetailView.frame.size.height - 5)];
                                [_itemTableView reloadData];
                                
                            }else {
                                isFinished = YES;
                                NSInteger row = [_itemTableView selectedRow];
                                [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
                                [self performSelectorOnMainThread:@selector(showEditErrorTip) withObject:nil waitUntilDone:NO];
                                
                            }
                        });
                        
                    });
                }
                if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                    [_delegate refeashBadgeConut:(int)_iCloudManager.reminderArray.count WithCategory:_category];
                }
            }
            isFinished = YES;
        }
    };
}

#pragma mark - Nodata-NSTextView
- (void)configNoDataView {
    NSString *promptStr = @"";
    [_noDataImage setImage:[StringHelper imageNamed:@"noData_reminder"]];
    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"Reminders_id", nil)];
    
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

- (void)configNoCollectionDataView {
    NSString *promptStr = @"";
    [_noCollectionDataImage setImage:[StringHelper imageNamed:@"noData_reminder"]];
    promptStr = [NSString stringWithFormat:CustomLocalizedString(@"NO_DATA_TITLE_1", nil),CustomLocalizedString(@"Reminders_id", nil)];
    
    [_noDataTextView setDelegate:self];
    
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_noDataTextView setLinkTextAttributes:linkAttributes];
    [_noDataTextView setSelectable:NO];
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_noDataTextView textStorage] setAttributedString:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
}

#pragma mark - NSTableView datasource
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    
    if (tableView == _collectionItemTableView) {
        if (_collectionArr.count < 1) {
            return 0;
        }else {
            return _collectionArr.count;
        }
    }else {
        if (_dataSourceArray.count < 1) {
            return 0;
        }else {
            return _dataSourceArray.count;
        }
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableView == _collectionItemTableView) {
        IMBiCloudCalendarCollectionEntity *collectionEntity = [_collectionArr objectAtIndex:row];
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
    }else {
        IMBiCloudCalendarEventEntity *entity = [_dataSourceArray objectAtIndex:row];
        if ([[tableColumn identifier] isEqualToString:@"Name"]) {
            return entity.summary;
        }
        if ([@"CheckCol" isEqualToString:tableColumn.identifier]) {
            return [NSNumber numberWithInt:entity.checkState];
        }
    }
    return nil;
    
}

-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    if (tableView == _collectionItemTableView) {
        if ([@"Count" isEqualToString:tableColumn.identifier]){
            IMBCenterTextFieldCell *cell1 = (IMBCenterTextFieldCell *)cell;
            cell1.isRighVale = YES;
        }
    }
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
        if (_isReminderAdd) {
            if(_dataSourceArray.count > 0) {
                [_dataSourceArray removeObjectAtIndex:0];
            }
        }
        
        if (_dataSourceArray.count <1) {
            [self configNoCollectionDataView];
            [_contentBox setContentView:_noCollectionDataView];
            return ;
        }
        [self selectMiddleTableViewWithRow:0];
        
        [_itemTableView reloadData];
        [_reminderDetailView.layer removeAllAnimations];
        CATransition *transition = [CATransition animation];
        transition.delegate = self;
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"moveIn";
        transition.subtype = kCATransitionFromBottom;
        [_reminderDetailView setDocumentView:_contentView];
        [_reminderDetailView.layer addAnimation:transition forKey:@"transiton"];
        _isEdit = NO;
    }
    
    
    NSTableView *tableView = notification.object;
    [_toolBar toolBarButtonIsEnabled:YES];
    if (tableView == _collectionItemTableView) {
        int row = (int)[_collectionItemTableView selectedRow];
        if (row >= 0 && row < _collectionArr.count) {
            IMBiCloudCalendarCollectionEntity *collectionEntity = [_collectionArr objectAtIndex:row];
            if (_dataSourceArray != nil) {
                [_dataSourceArray release];
                _dataSourceArray = nil;
            }
            _dataSourceArray = [collectionEntity.subArray retain];
            if (_dataSourceArray.count < 1) {
                [self configNoCollectionDataView];
                [_contentBox setContentView:_noCollectionDataView];
            }else {
                [_contentBox setContentView:_contentMainView];
                [_reminderDetailView setDocumentView:_contentView];
                [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                [self selectMiddleTableViewWithRow:row];
            }
        }
        [_itemTableView reloadData];
    }else {
        int row = (int)[_itemTableView selectedRow];
        [self selectMiddleTableViewWithRow:row];
    }
    
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
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
    if ( [@"Name" isEqualToString:identify]) {
        if ([cell isKindOfClass:[IMBCustomHeaderCell class]]) {
            IMBCustomHeaderCell *customHeaderCell = (IMBCustomHeaderCell *)cell;
            if (customHeaderCell.ascending) {
                customHeaderCell.ascending = NO;
            }else
            {
                customHeaderCell.ascending = YES;
            }
            if (tableView == _itemTableView) {
                [self sort:customHeaderCell.ascending key:identify dataSource:_dataSourceArray];
            } else {
                [self sort:customHeaderCell.ascending key:identify dataSource:_collectionArr];
            }
            
        }
        
        if (_dataSourceArray.count > 0) {
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }
        if (_collectionArr.count > 0) {
            [_collectionItemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        }
    }
    [_collectionItemTableView reloadData];
    [_itemTableView reloadData];
}

- (void)sort:(BOOL)isAscending key:(NSString *)key dataSource:(NSMutableArray *)array {
    if ([key isEqualToString:@"Name"]) {
        key = @"summary";
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAscending];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [array sortUsingDescriptors:sortDescriptors];
    [_itemTableView reloadData];
    
    
    [sortDescriptor release];
    [sortDescriptors release];
}
//右键点击
- (void)tableView:(NSTableView *)tableView rightDownrow:(NSInteger)index {
    if (index >=0 && index < _collectionArr.count) {
        
        IMBiCloudCalendarCollectionEntity *collEntity = [_collectionArr objectAtIndex:index];
        _collectionEntity = [collEntity retain];
        [_collectionItemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
    }
}

#pragma mark - IMBImageRefreshListListener
- (void)tableView:(NSTableView *)tableView row:(NSInteger)index {
    
    if (tableView == _collectionItemTableView) {
        IMBiCloudCalendarCollectionEntity *collectionEntity = [_collectionArr objectAtIndex:index];
        collectionEntity.checkState = !collectionEntity.checkState;
        for (IMBiCloudCalendarEventEntity *entity in collectionEntity.subArray) {
            entity.checkState = collectionEntity.checkState;
        }
    }else {
        IMBiCloudCalendarEventEntity *entity = [_dataSourceArray objectAtIndex:index];
        entity.checkState = !entity.checkState;
        IMBiCloudCalendarCollectionEntity *collectionEntity = nil;
        for (IMBiCloudCalendarCollectionEntity *cEntity in _collectionArr) {
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
    [_collectionItemTableView reloadData];
    [_itemTableView reloadData];
    
    
}

#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    isFinished = YES;
}
#pragma mark OperationActions

- (void)iCloudReload:(id)sender {
    
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    [_toolBar toolBarButtonIsEnabled:NO];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Reminder Refresh" label:Start transferCount:0 screenView:@"Reminder View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        
        [_iCloudManager getReminderContent];
        
        if (_collectionArr != nil) {
            [_collectionArr release];
            _collectionArr = nil;
        }
        _collectionArr = [_iCloudManager.reminderCollectionArray retain];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_toolBar toolBarButtonIsEnabled:YES];
            if (_collectionArr.count <= 0) {
                [self configNoDataView];
                [_mainBox setContentView:_noDataView];
            }else {
                
                IMBiCloudCalendarCollectionEntity *entity = [_collectionArr objectAtIndex:0];
                if (_dataSourceArray != nil) {
                    [_dataSourceArray release];
                    _dataSourceArray = nil;
                }
                _dataSourceArray = [entity.subArray retain];
                
                [_collectionItemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                if (_dataSourceArray.count <= 0) {
                    [self configNoCollectionDataView];
                    [_contentBox setContentView:_noCollectionDataView];
                } else {
                    [_contentBox setContentView:_contentMainView];
                    [_reminderDetailView setDocumentView:_contentView];
                    [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                }
                [_mainBox setContentView:_reminderView];
                
                
            }
            if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                [_delegate refeashBadgeConut:(int)_iCloudManager.reminderArray.count WithCategory:_category];
            }
            [_loadingAnimationView endAnimation];
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Reminder Refresh" label:Finish transferCount:0 screenView:@"Reminder View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
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
    for (IMBiCloudCalendarCollectionEntity *collectionEntity in _collectionArr) {
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
    if (_collectionArr.count == collectArray.count && _collectionArr.count == 1) {
        NSString *str = CustomLocalizedString(@"iCloudReminder_DeletePromptOnlyOne", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    if (collectArray.count == _collectionArr.count) {
        NSString *str = CustomLocalizedString(@"iCloudReminder_DeletePrompt", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    
    if (arrayM.count > 0 || collectArray.count > 0) {
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
        int count = 0;
        for (IMBiCloudCalendarCollectionEntity *collectionEntity in _collectionArr) {
            count += collectionEntity.subArray.count;
        }
        NSString *str = nil;
        if (count == 0) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_delete", nil),CustomLocalizedString(@"MenuItem_id_62", nil)];
        }else {
            str = CustomLocalizedString(@"iCloudBackup_View_Selected_Tips", nil);
        }
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    __block BOOL success;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int i = 0;
        for (IMBiCloudCalendarEventEntity *entity in arrayM) {
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Reminder Delete" label:Start transferCount:arrayM.count screenView:@"Reminder View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            success = [_iCloudManager deleteReminder:arrayM withPguid:entity.pGuid];
            if (success) {
                i++;
            }
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Reminder Delete" label:Finish transferCount:arrayM.count screenView:@"Reminder View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
        }
        for (IMBiCloudCalendarCollectionEntity *entity in collectArray) {
            success = [_iCloudManager deleteReminderCollection:entity];
            if (success) {
                if (entity.subArray.count < 1) {
                    i ++;
                }else {
                    i += entity.subArray.count;
                }
            }
        }
        if (i>0) {
            [_iCloudManager getReminderContent];
            if (_collectionArr != nil) {
                [_collectionArr release];
                _collectionArr = nil;
            }
            _collectionArr = [_iCloudManager.reminderCollectionArray retain];
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (_collectionArr.count <= 0) {
                    [_mainBox setContentView:_noDataView];
                    [self configNoDataView];
                }else {
                    NSInteger row = [_collectionItemTableView selectedRow];
                    if (row >= _collectionArr.count || row < 0) {
                        row = 0;
                    }
                    IMBiCloudCalendarCollectionEntity *entity = [_collectionArr objectAtIndex:row];
                    if (_dataSourceArray != nil) {
                        [_dataSourceArray release];
                        _dataSourceArray = nil;
                    }
                    _dataSourceArray = [entity.subArray retain];
                    
                    [_mainBox setContentView:_reminderView];
                    [_collectionItemTableView reloadData];
                    if (_dataSourceArray.count <= 0) {
                        [self configNoCollectionDataView];
                        [_contentBox setContentView:_noCollectionDataView];
                    } else {
                        [_contentBox setContentView:_contentMainView];
                        [self tableViewSelectRow:0];
                        [_itemTableView reloadData];
                    }
                }
                if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                    [_delegate refeashBadgeConut:(int)_iCloudManager.reminderArray.count WithCategory:_category];
                }
                [_loadingAnimationView endAnimation];
            });
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (_collectionArr.count <= 0) {
                    [_mainBox setContentView:_noDataView];
                    [self configNoDataView];
                }else {
                    [_mainBox setContentView:_reminderView];
                    if (_dataSourceArray <= 0) {
                        [self configNoCollectionDataView];
                        [_contentBox setContentView:_noCollectionDataView];
                    } else {
                        [_contentBox setContentView:_contentMainView];
                    }
                    [_itemTableView reloadData];
                    
                }
                [_loadingAnimationView endAnimation];
                [self performSelectorOnMainThread:@selector(showDeleteErrorTip) withObject:nil waitUntilDone:NO];
            });
        }
    });
    if (arrayM != nil) {
        [arrayM release];
        arrayM = nil;
    }
}

- (void)retToolbar:(IMBToolBarView*)toolbarview{
    _toolBar = toolbarview;
}

- (void)addiCloudItems:(id)sender {
    
    if (_collectionArr.count < 1 ) {
        [self showAlertText:CustomLocalizedString(@"icloud_GetReminderGroupListFailed", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Reminder Add" label:Start transferCount:0 screenView:@"Reminder View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    [_reminderTitle setStringValue:CustomLocalizedString(@"contact_id_48", nil)];
    [self configEditView];
    [_notesTextField.contentField setStringValue:@""];
    [_datePicker setDateValue:[NSDate date]];
    IMBiCloudCalendarEventEntity *icloudEntity = [[[IMBiCloudCalendarEventEntity alloc] init] autorelease];
    [icloudEntity setSummary:CustomLocalizedString(@"contact_id_48", nil)];
    
    [_dataSourceArray insertObject:icloudEntity atIndex:0];
    [_checkBtn setState:NSOffState];
    [_timeView setHidden:YES];
    _otherView.frame = NSMakeRect(0,_timeView.frame.size.height + 20, _otherView.frame.size.width, _otherView.frame.size.height);
    [_listPopBtn.menu removeAllItems];
    
    if (_collectionArr.count > 0) {
        for (IMBiCloudCalendarCollectionEntity *collectionEntity in _collectionArr) {
            NSMenuItem *listItem = [[NSMenuItem alloc] init];
            [listItem setTitle:collectionEntity.title];
            listItem.tag = collectionEntity.tag;
            [_listPopBtn.menu addItem:listItem];
            [listItem release];
        }
        IMBiCloudCalendarCollectionEntity *collectionEntity = [_collectionArr objectAtIndex:0];
        [_listPopBtn selectItemWithTag:1];
        [_listPopBtn setTitle:collectionEntity.title];
    }
    [priorityPopBtn.menu removeAllItems];
    NSMenuItem *proItem1 = [[NSMenuItem alloc] init];
    [proItem1 setTitle:CustomLocalizedString(@"icloud_reminder_1", nil)];
    [proItem1 setState:NSOnState];
    [proItem1 setTag:501];
    [priorityPopBtn.menu addItem:proItem1];
    [priorityPopBtn setTitle:CustomLocalizedString(@"icloud_reminder_1", nil)];
    [proItem1 release];
    NSMenuItem *proItem2 = [[NSMenuItem alloc] init];
    [proItem2 setTitle:CustomLocalizedString(@"icloud_reminder_2", nil)];
    [proItem2 setState:NSOffState];
    [proItem2 setTag:502];
    [priorityPopBtn.menu addItem:proItem2];
    [proItem2 release];
    NSMenuItem *proItem3 = [[NSMenuItem alloc] init];
    [proItem3 setTitle:CustomLocalizedString(@"icloud_reminder_3", nil)];
    [proItem3 setState:NSOffState];
    [proItem3 setTag:503];
    [priorityPopBtn.menu addItem:proItem3];
    [proItem3 release];
    NSMenuItem *proItem4 = [[NSMenuItem alloc] init];
    [proItem4 setTitle:CustomLocalizedString(@"icloud_reminder_4", nil)];
    [proItem4 setState:NSOffState];
    [proItem4 setTag:504];
    [priorityPopBtn.menu addItem:proItem4];
    [proItem4 release];
    
    [priorityPopBtn setHasBorderLine:YES];
    [priorityPopBtn setNoMaxWidth:YES];
    [priorityPopBtn setNeedsDisplay:YES];
    
    [_itemTableView reloadData];
    [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
    [_mainBox setContentView:_reminderView];
    
    _contentView.frame = NSMakeRect(0, 0, _reminderDetailView.frame.size.width -15, _reminderDetailView.frame.size.height - 5);
    [_reminderEditView setFrame:NSMakeRect(0, 0, _reminderDetailView.frame.size.width -15, _reminderDetailView.frame.size.height - 5)];
    
    [_contentBox setContentView:_contentMainView];
    [_reminderDetailView setDocumentView:_reminderEditView];
    
    [_listPopBtn setHasBorderLine:YES];
    [_listPopBtn setNoMaxWidth:YES];
    [_listPopBtn setNeedsDisplay:YES];
    [priorityPopBtn setHasBorderLine:YES];
    [priorityPopBtn setNoMaxWidth:YES];
    [priorityPopBtn setNeedsDisplay:YES];
    _isEdit = YES;
    _isReminderAdd = YES;
    [_toolBar toolBarButtonIsEnabled:NO];
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Reminder Add" label:Finish transferCount:0 screenView:@"Reminder View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
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
            for (IMBiCloudCalendarCollectionEntity *collectionEntity in _collectionArr) {
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
                [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Reminder To iCloud" label:Start transferCount:arrayM.count screenView:@"Reminder View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                if (_transferController != nil) {
                    [_transferController release];
                    _transferController = nil;
                }
                IMBBaseInfo *baseInfo = [baseInfoArr objectAtIndex:0];
                
                
                _otheriCloudManager = [[iCloudDic objectForKey:baseInfo.uniqueKey] iCloudManager];
                _transferController = [[IMBTransferViewController alloc] initWithType:_category withDelegate:self withTransfertype:TransferSync withIsicloudView:YES];
                
                [_transferController setDelegate:self];
                
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
                    
                    /*如果传输实体的组的名字和另一个iCloud中Reminder的组名字相同,就传到对应名字下面，
                     否则新建一个组,
                     如果创建成功在将实体添加进去，
                     如果失败，就添加到第一个组里面*/
                    int i = 0 ;
                    for (IMBiCloudCalendarEventEntity *entity in arrayM) {
                        BOOL success = NO;
                        ReminderAddModel *addEntity = [[ReminderAddModel alloc] init];
                        
                        addEntity.dataModel.title = entity.summary;
                        addEntity.dataModel.description = entity.eventdescription;
                        addEntity.dataModel.priority = entity.priority;
                        if (addEntity.dataModel.priority != 0 && addEntity.dataModel.priority != 1 && addEntity.dataModel.priority != 5 && addEntity.dataModel.priority != 9) {
                            addEntity.dataModel.priority = 0;
                        }
                        
                        addEntity.dataModel.dueDateIsAllDay = entity.dueDateIsAllDay;
                        addEntity.dataModel.completedDate = @"";//entity.completedDate;
                        addEntity.dataModel.recurrence = @"";//entity.recurrence;
                        addEntity.dataModel.startDateIsAllDay = entity.startDateIsAllDay;
                        addEntity.dataModel.groupTitle = entity.groupTitle;
                        CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
                        NSString *guid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
                        addEntity.dataModel.guid = guid;
                        addEntity.dataModel.dueDate = entity.dueDate;
                        
                        
                        BOOL _hasSetPguid = NO;
                        for (IMBiCloudCalendarCollectionEntity *otherCollenEntity in _otheriCloudManager.reminderCollectionArray) {
                            if ([otherCollenEntity.title isEqualToString:addEntity.dataModel.groupTitle]) {
                                addEntity.dataModel.pGuid = otherCollenEntity.guid;
                                _hasSetPguid = YES;
                                break;
                            }
                        }
                        BOOL AddGroupSuccess = NO;
                        if (!_hasSetPguid) {
                            AddGroupSuccess = [_otheriCloudManager addReminderCollection:addEntity.dataModel.groupTitle];
                            if (_otheriCloudManager.reminderCollectionArray.count > 0) {
                                if (AddGroupSuccess) {
                                    for (IMBiCloudCalendarCollectionEntity *addCollectionentity in _otheriCloudManager.reminderCollectionArray) {
                                        if ([addCollectionentity.title isEqualToString:addEntity.dataModel.groupTitle]) {
                                            addEntity.dataModel.pGuid = addCollectionentity.guid;
                                        }
                                    }
                                    
                                }else {
                                    
                                    IMBiCloudCalendarEventEntity *collectionEntity = [_otheriCloudManager.reminderCollectionArray objectAtIndex:0];
                                    addEntity.dataModel.pGuid = collectionEntity.guid;
                                    
                                }
                            }
                            
                        }
                        
                        
                        success = [_otheriCloudManager addReminder:addEntity withPguid:addEntity.dataModel.pGuid];
                        [addEntity release];
                        
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
                            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Reminder To iCloud" label:Finish transferCount:arrayM.count screenView:@"Reminder View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
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

- (void)iClouditemtoMac:(id)sender {
    NSLog(@"iClouditemtoMac");
    NSIndexSet *selectedSet = [self selectedItems];
    if ([selectedSet count] <= 0) {
        //弹出警告确认框
        int count = 0;
        for (IMBiCloudCalendarCollectionEntity *collectionEntity in _collectionArr) {
            count += collectionEntity.subArray.count;
        }
        NSString *str = nil;
        if (count == 0) {
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
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Reminder Send to Mac" label:Start transferCount:0 screenView:@"Reminder View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        
        [_openPanel beginSheetModalForWindow:[self view].window completionHandler:^(NSInteger result) {
            if (result== NSFileHandlingPanelOKButton) {
                [self performSelector:@selector(infortoMacDelay:) withObject:_openPanel afterDelay:0.1];
            }else{
                NSLog(@"other other other");
            }
        }];
        
    }
}

- (void)infortoMacDelay:(NSOpenPanel *)openPanel
{
    NSIndexSet *selectedSet = [self selectedItems];
    NSViewController *annoyVC = nil;
    long long result1 = 10;
    if (!_isiCloudView) {
        result1 = [self checkNeedAnnoy:&(annoyVC)];
        if (result1 == 0) {
            return;
        }
    }
    NSString *path = [[openPanel URL] path];
    NSString *filePath = [TempHelper createCategoryPath:[TempHelper createExportPath:path] withString:[IMBCommonEnum categoryNodesEnumToName:_category]];
    [self copyInfomationToMac:filePath indexSet:selectedSet Result:result1 AnnoyVC:annoyVC];
}

- (void)copyInfomationToMac:(NSString *)filePath indexSet:(NSIndexSet *)set Result:(long long)result AnnoyVC:(NSViewController *)annoyVC{
    
    NSMutableArray *selectedArr = [[NSMutableArray alloc] init];
    for (IMBiCloudCalendarCollectionEntity *collectionEntity in _collectionArr) {
        for (IMBiCloudCalendarEventEntity *entity in collectionEntity.subArray) {
            [selectedArr addObject:entity];
        }
    }
    NSIndexSet *selectedSet = set;
    NSMutableArray *selectedArray = [NSMutableArray array];
    [selectedSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [selectedArray addObject:[selectedArr objectAtIndex:idx]];
    }];
    
    NSString *mode = @"";
    if (_ipod != nil) {
        
        mode = [_ipod.exportSetting getExportExtension:_ipod.exportSetting.reminderType];
    }else {
        if (_exportSetting != nil) {
            [_exportSetting release];
            _exportSetting = nil;
        }
        _exportSetting = [[IMBExportSetting alloc] initWithIPod:nil];
        
        mode = [_exportSetting getExportExtension:_exportSetting.reminderType];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Reminder Send to Mac" label:Finish transferCount:0 screenView:@"Reminder View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        
    }
    if (_transferController != nil) {
        [_transferController release];
        _transferController = nil;
    }
    
    if (_isiCloudView) {
        _transferController =[[IMBTransferViewController alloc] initWithType:_category SelectItems:selectedArray ExportFolder:filePath Mode:mode IsicloudView:_isiCloudView];
    } else {
        _transferController = [[IMBTransferViewController alloc] initWithType:_category SelectItems:selectedArray ExportFolder:filePath Mode:mode];
    }
    
    if (result>0) {
        [self animationAddTransferViewfromRight:_transferController.view AnnoyVC:annoyVC];
    }else{
        [self animationAddTransferView:_transferController.view];
    }
    if (selectedArr != nil) {
        [selectedArr release];
        selectedArr = nil;
    }
}

- (NSIndexSet *)selectedItems {
    NSMutableIndexSet *sets = [NSMutableIndexSet indexSet];
    NSMutableArray *selectedArr = [[NSMutableArray alloc] init];
    for (IMBiCloudCalendarCollectionEntity *collectionEntity in _collectionArr) {
        for (IMBiCloudCalendarEventEntity *entity in collectionEntity.subArray) {
            [selectedArr addObject:entity];
        }
    }
    for (int i=0;i<[selectedArr count]; i++) {
        IMBBaseEntity *entity = [selectedArr objectAtIndex:i];
        if (entity.checkState == Check) {
            [sets addIndex:i];
        }
    }
    if (selectedArr != nil) {
        [selectedArr release];
        selectedArr = nil;
    }
    return sets;
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
}

- (void)onItemiCloudClicked:(id)sender
{
    [_toDevicePopover close];
    NSMutableArray *arrayM = [[NSMutableArray alloc]init];
    if (_category == Category_Reminder) {
        for (IMBiCloudCalendarEventEntity *entity in _dataSourceArray) {
            if (entity.checkState == Check) {
                [arrayM addObject:entity];
            }
        }
        if (arrayM.count > 0) {
            
            if (_transferController != nil) {
                [_transferController release];
                _transferController = nil;
            }
            IMBBaseInfo *baseInfo = (IMBBaseInfo *)sender;
            NSDictionary *iCloudDic = [_delegate getiCloudAccountViewCollection];
            _otheriCloudManager = [[iCloudDic objectForKey:baseInfo.uniqueKey] iCloudManager];            _transferController = [[IMBTransferViewController alloc] initWithType:Category_iCloudDriver withDelegate:self withTransfertype:TransferSync];
            [_transferController setDelegate:self];
            [_transferController setIsicloudView:YES];
            [self animationAddTransferView:_transferController.view];
            if ([_transferController respondsToSelector:@selector(transferPrepareFileStart:)]) {
                [_transferController transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"Reminders_id", nil)]];
            }
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                int i = 0 ;
                //每次都必须请求一次数据；
                
                [_otheriCloudManager getReminderContent];
                for (IMBiCloudCalendarEventEntity *entity in arrayM) {
                    ReminderAddModel *addEntity = [[ReminderAddModel alloc] init];
                    addEntity.dataModel.title = entity.summary;
                    addEntity.dataModel.description = entity.eventdescription;
                    
                    NSString *pguid = @"";
                    if (_otheriCloudManager.reminderCollectionArray.count > 0) {
                        IMBiCloudCalendarCollectionEntity *collectionEntity = [_otheriCloudManager.reminderCollectionArray objectAtIndex:0];
                        pguid = collectionEntity.guid;
                        addEntity.dataModel.pGuid = pguid;
                    }
                    
                    addEntity.dataModel.priority = entity.priority;
                    if (addEntity.dataModel.priority != 0 && addEntity.dataModel.priority != 1 && addEntity.dataModel.priority != 5 && addEntity.dataModel.priority != 9) {
                        addEntity.dataModel.priority = 0;
                    }
                    
                    addEntity.dataModel.dueDateIsAllDay = entity.dueDateIsAllDay;
                    addEntity.dataModel.completedDate = @"";//entity.completedDate;
                    addEntity.dataModel.recurrence = @"";//entity.recurrence;
                    addEntity.dataModel.startDateIsAllDay = entity.startDateIsAllDay;
                    
                    CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
                    NSString *guid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
                    addEntity.dataModel.guid = guid;
                    
                    addEntity.dataModel.dueDate = entity.dueDate;
                    
                    [_otheriCloudManager addReminder:addEntity withPguid:pguid];
                    [addEntity release];
                    i++;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if ([_transferController respondsToSelector:@selector(transferProgress:)]) {
                            [_transferController transferProgress:i/arrayM.count *100];
                        }
                    });
                }
                double delayInSeconds = 2;
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    if ([_transferController respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                        [_transferController transferComplete:(int)arrayM.count TotalCount:(int)arrayM.count];
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
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    _isSearch = YES;
    _searchFieldBtn = searchBtn ;
    if (searchStr != nil && ![searchStr isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"summary CONTAINS[cd] %@ ",searchStr];
        [_researchdataSourceArray removeAllObjects];
        [_researchdataSourceArray addObjectsFromArray:[_dataSourceArray  filteredArrayUsingPredicate:predicate]];
        if (_researchdataSourceArray.count > 0) {
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]byExtendingSelection:NO];
            [self tableViewSelectionDidChange:nil];
        }else{
            [self tableViewSelectionDidChange:nil];
        }
    }else{
        _isSearch = NO;
        [_researchdataSourceArray removeAllObjects];
        [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0]byExtendingSelection:NO];
        [self tableViewSelectionDidChange:nil];
    }
    [_itemTableView reloadData];
}

#pragma mark - 配置编辑界面 popButton
- (void)configEditViewPopButton:(IMBiCloudCalendarEventEntity *)entity {
    [priorityPopBtn setIsEditView:YES];
    [_listPopBtn setIsEditView:YES];
    [priorityPopBtn.menu removeAllItems];
    NSMenuItem *proItem1 = [[NSMenuItem alloc] init];
    [proItem1 setTitle:CustomLocalizedString(@"icloud_reminder_1", nil)];
    [proItem1 setState:NSOffState];
    [proItem1 setTag:501];
    [priorityPopBtn.menu addItem:proItem1];
    [proItem1 release];
    NSMenuItem *proItem2 = [[NSMenuItem alloc] init];
    [proItem2 setTitle:CustomLocalizedString(@"icloud_reminder_2", nil)];
    [proItem2 setState:NSOffState];
    [proItem2 setTag:502];
    [priorityPopBtn.menu addItem:proItem2];
    [proItem2 release];
    NSMenuItem *proItem3 = [[NSMenuItem alloc] init];
    [proItem3 setTitle:CustomLocalizedString(@"icloud_reminder_3", nil)];
    [proItem3 setState:NSOffState];
    [proItem3 setTag:503];
    [priorityPopBtn.menu addItem:proItem3];
    [proItem3 release];
    NSMenuItem *proItem4 = [[NSMenuItem alloc] init];
    [proItem4 setTitle:CustomLocalizedString(@"icloud_reminder_4", nil)];
    [proItem4 setState:NSOffState];
    [proItem4 setTag:504];
    [priorityPopBtn.menu addItem:proItem4];
    [proItem4 release];
    
    [_listPopBtn.menu removeAllItems];
    NSArray *listArray = [NSArray arrayWithArray:_iCloudManager.reminderCollectionArray];
    for (IMBiCloudCalendarCollectionEntity *collectionEntity in listArray) {
        NSMenuItem *listItem = [[NSMenuItem alloc] init];
        [listItem setTitle:collectionEntity.title];
        listItem.tag = collectionEntity.tag;
        [_listPopBtn.menu addItem:listItem];
        [listItem release];
    }
}

- (IBAction)checkBtnClick:(id)sender {
    IMBCheckBtn *btn = (IMBCheckBtn*)sender;
    int state = (int)btn.state;
    if (state == 1) {
        [_timeView setHidden:NO];
        _otherView.frame = NSMakeRect(0,30, _otherView.frame.size.width, _otherView.frame.size.height);
    } else {
        [_timeView setHidden:YES];
        _otherView.frame = NSMakeRect(0,_timeView.frame.size.height + 30, _otherView.frame.size.width, _otherView.frame.size.height);
    }
    
}

#pragma mark reminder error

- (void)showAddErrorTip {
    
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_Add_Failed", nil),CustomLocalizedString(@"Reminders_id", nil)];
    [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    
}

- (void)showAddCollectionErrorTip {
    
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_AddCollection_Failed", nil),CustomLocalizedString(@"Reminders_id", nil)];
    [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    
}

- (void)showEditErrorTip {
    
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_Modify_Failed", nil),CustomLocalizedString(@"Reminders_id", nil)];
    [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    
}

- (void)showDeleteErrorTip {
    
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_Delete_Failed", nil),CustomLocalizedString(@"Reminders_id", nil)];
    [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    
    
}

- (void)showDeleteCollectionErrorTip {
    
    NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"MSG_iCloud_DeleteCollection_Failed", nil),CustomLocalizedString(@"Reminders_id", nil)];
    [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    
    
}

- (void)tableViewChangeDisplay {
    _isReminderAdd = NO;
    [_reminderDetailView setDocumentView:_contentView];
    NSArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <= 0) {
        [_contentView setTitle:@""];
        [_contentView setLocation:@""];
        [_contentView setStartdate:@""];
        [_contentView setEnddate:CustomLocalizedString(@"iCloud_NoDate", nil)];
        [_contentView setDescription:@""];
        [_contentView setUrl:@""];
        return ;
    }
    NSInteger row = 0;
    IMBiCloudCalendarEventEntity *calendarEvent = nil;
    if (row == -1 ) {
        [_contentView setTitle:@""];
        [_contentView setLocation:@""];
        [_contentView setStartdate:@""];
        [_contentView setEnddate:CustomLocalizedString(@"iCloud_NoDate", nil)];
        [_contentView setDescription:@""];
        [_contentView setUrl:@""];
        return;
        
        
    }else if(row < [displayArray count])
    {
        calendarEvent = [displayArray objectAtIndex:row];
    }
    
    [_contentView setStartdate:[DateHelper dateFrom1970ToString:calendarEvent.dueTime withMode:2 ]];
    [_contentView setTitle:calendarEvent.summary];
    [_contentView setDescription:calendarEvent.eventdescription];
    
}

- (void)tableViewSelectRow:(int)selectRow {
    if (selectRow > _dataSourceArray.count) {
        return;
    }
    if (_isEdit) {
        [_dataSourceArray removeObjectAtIndex:0];
        [_itemTableView reloadData];
        _isEdit = NO;
    }
    
    _isReminderAdd = NO;
    [_reminderDetailView setDocumentView:_contentView];
    
    NSArray *displayArray = nil;
    displayArray = _dataSourceArray;
    
    IMBiCloudCalendarEventEntity *calendarEvent = nil;
    if (selectRow < 0) {
        selectRow = 0;
    }
    calendarEvent = [displayArray objectAtIndex:selectRow];
    [_contentView setStartdate:[DateHelper dateFrom1970ToString:calendarEvent.dueTime withMode:2 ]];
    [_contentView setTitle:calendarEvent.summary];
    [_contentView setDescription:calendarEvent.eventdescription];
    
}

- (void)selectiTemTableViewWithRow:(int)row {
    if (row >= 0 && row < _collectionArr.count) {
        IMBiCloudCalendarCollectionEntity *collectionEntity = [_collectionArr objectAtIndex:row];
        if (_dataSourceArray != nil) {
            [_dataSourceArray release];
            _dataSourceArray = nil;
        }
        _dataSourceArray = [collectionEntity.subArray retain];
        if (_dataSourceArray.count < 1) {
            [_contentBox setContentView:_noDataView];
        }else {
            [_contentBox setContentView:_contentMainView];
            int middleRow = (int)[_itemTableView selectedRow];
            if (middleRow <0 || middleRow >= _dataSourceArray.count) {
                middleRow = 0;
            }
            [_itemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:middleRow] byExtendingSelection:NO];
            [self selectMiddleTableViewWithRow:middleRow];
        }
    }
    [_itemTableView reloadData];
}

- (void)selectMiddleTableViewWithRow:(int)row {
    if ((row >= _dataSourceArray.count || row < 0)) {
        row = 0;
    }
    if (_dataSourceArray.count > 0) {
        IMBiCloudCalendarEventEntity *entity = [_dataSourceArray objectAtIndex:row];
        [_contentView setStartdate:[DateHelper dateFrom1970ToString:entity.dueTime withMode:2 ]];
        [_contentView setTitle:entity.summary];
        [_contentView setDescription:entity.eventdescription];
        
    }
}

#pragma mark - Sort 、Select
- (IBAction)sortSelectedPopuBtn:(id)sender {
    NSMenuItem *item = [_selectSortBtn selectedItem];
    NSInteger tag = [_selectSortBtn selectedItem].tag;
    for (NSMenuItem *menuItem in _selectSortBtn.itemArray) {
        [menuItem setState:NSOffState];
    }
    NSString *pguid = nil;
    if (tag == 1) {
        for (IMBiCloudCalendarEventEntity *entity in _dataSourceArray) {
            entity.checkState = Check;
            pguid = entity.pGuid;
        }
        for (IMBiCloudCalendarCollectionEntity *collectionEntity in _collectionArr) {
            if ([collectionEntity.guid isEqualToString:pguid]) {
                collectionEntity.checkState = Check;
                break;
            }
        }
    }else if (tag == 2){
        for (IMBiCloudCalendarEventEntity *entity in _dataSourceArray) {
            entity.checkState = UnChecked;
            pguid = entity.pGuid;
        }
        for (IMBiCloudCalendarCollectionEntity *collectionEntity in _collectionArr) {
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
    [_selectSortBtn setFrame:NSMakeRect(-2,_selectSortBtn.frame.origin.y , wide +30, _selectSortBtn.frame.size.height)];
    [_selectSortBtn setTitle:[_selectSortBtn titleOfSelectedItem]];
    [_itemTableView reloadData];
    [_collectionItemTableView reloadData];
}

- (IBAction)sortRightPopuBtn:(id)sender {
    NSMutableArray *displayArray = nil;
    if (_isSearch) {
        displayArray = _researchdataSourceArray;
    }else{
        displayArray = _dataSourceArray;
    }
    if (displayArray.count <= 0) {
        return ;
    }
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
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"summary" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [displayArray sortUsingDescriptors:sortDescriptors];
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
        [displayArray sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        //        [_topPopuBtn setTitle:[_topPopuBtn titleOfSelectedItem]];
    }else if (item.tag == 4){
        _isAscending = NO;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"summary" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [displayArray sortUsingDescriptors:sortDescriptors];
        [_itemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        //        //
    }
    NSString *str1 = CustomLocalizedString(@"SortBy_Name", nil);
    [_sortRightPopuBtn setTitle:str1];
    [_sortRightPopuBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    NSInteger row = [_itemTableView selectedRow];
    IMBCalendarEventEntity *entity = [displayArray objectAtIndex:row];
    [self showSingleReminderContent:entity];
    
}

- (IBAction)collectionSortSelectedPopuBtn:(id)sender {
    
    NSMenuItem *item = [_selectSortBtn2 selectedItem];
    NSInteger tag = [_selectSortBtn2 selectedItem].tag;
    
    for (NSMenuItem *menuItem in _selectSortBtn2.itemArray) {
        [menuItem setState:NSOffState];
    }
    if (tag == 1) {
        for (IMBNoteModelEntity *note in _collectionArr) {
            note.checkState = Check;
        }
        for (IMBiCloudCalendarCollectionEntity *collectionEntity in _collectionArr) {
            for (IMBNoteModelEntity *note in collectionEntity.subArray) {
                note.checkState = Check;
            }
        }
    } else if (tag == 2){
        for (IMBNoteModelEntity *note in _collectionArr) {
            note.checkState = UnChecked;
        }
        
        for (IMBiCloudCalendarCollectionEntity *collectionEntity in _collectionArr) {
            for (IMBNoteModelEntity *note in collectionEntity.subArray) {
                note.checkState = UnChecked;
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
    [_collectionItemTableView reloadData];
    
    
    [_selectSortBtn setFrame:NSMakeRect(-2,_selectSortBtn2.frame.origin.y , wide +30, _selectSortBtn2.frame.size.height)];
    [_selectSortBtn setTitle:[_selectSortBtn2 titleOfSelectedItem]];
    [_itemTableView reloadData];
    
}

- (IBAction)collectionsortRightPopuBtn:(id)sender {
    NSMenuItem *item = [_sortRightPopuBtn2 selectedItem];
    NSRect rect = [TempHelper calcuTextBounds:item.title fontSize:12];
    [_sortRightPopuBtn2 setFrame:NSMakeRect(_topwhiteView2.frame.size.width - 30 - rect.size.width-12,_sortRightPopuBtn2.frame.origin.y , rect.size.width +30, _sortRightPopuBtn2.frame.size.height)];
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
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_collectionArr sortUsingDescriptors:sortDescriptors];
        [_collectionItemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
        [_sortRightPopuBtn2 setTitle:[_sortRightPopuBtn2 titleOfSelectedItem]];
    }else if (tag == 2){
        
    }else if (item.tag == 3){
        _isAscending = YES;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_collectionArr sortUsingDescriptors:sortDescriptors];
        [_collectionItemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }else if (item.tag == 4){
        _isAscending = NO;
        [item setState:NSOnState];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:_isAscending selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
        [_collectionArr sortUsingDescriptors:sortDescriptors];
        [_collectionItemTableView reloadData];
        [sortDescriptor release];
        [sortDescriptors release];
    }
    NSString *str1 = CustomLocalizedString(@"SortBy_Name", nil);
    [_sortRightPopuBtn2 setTitle:str1];
    [_sortRightPopuBtn2 setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    if(_collectionArr.count >0) {
        [_collectionItemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        [self selectiTemTableViewWithRow:0];
    }
}

#pragma mark - collection add and delete
//addCollection
- (IBAction)addBtnClick:(id)sender {
    
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    NSString *string = [NSString stringWithFormat:@"%@",CustomLocalizedString(@"iCloud_add_newListName", nil)];
    NSInteger result = [alerView showTitleName:string InputTextFiledString:@"" OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
    if (result == 1) {
        //进行增加操作
        
        [alerView.renameLoadingView setHidden:NO];
        [alerView.renameLoadingView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [alerView.renameLoadingView setImage:[StringHelper imageNamed:@"registedLoading"]];
        [alerView.renameLoadingView.layer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:-2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
        NSString *inputName = [[alerView reNameInputTextField] stringValue];
        if (![TempHelper stringIsNilOrEmpty:inputName]) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                BOOL success = [_iCloudManager addReminderCollection:inputName];
                if (success) {
                    //刷新当前view, TODO也可以在回调事件中从tableview中删除
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [alerView unloadAlertView:alerView.reNameView];
                        [alerView.renameLoadingView setHidden:YES];
                        [_collectionItemTableView reloadData];
                    });
                } else {
                    
                    [self performSelectorOnMainThread:@selector(showAddCollectionErrorTip) withObject:nil waitUntilDone:NO];
                }
                
            });
        }
    }
}

- (IBAction)toCollectionDeleteClick:(id)sender {
    
    if (_collectionArr.count == 1) {
        NSString *str = CustomLocalizedString(@"iCloudReminder_DeletePrompt", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    NSMutableArray *collectArray = [[[NSMutableArray alloc] init] autorelease];
    for (IMBiCloudCalendarCollectionEntity *collectionEntity in _collectionArr) {
        if (collectionEntity.checkState == Check) {
            [collectArray addObject:collectionEntity];
        }
    }
    if (_collectionArr.count == collectArray.count){
        NSString *str = CustomLocalizedString(@"iCloudCalendar_DeletePrompt", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    
    if (_collectionEntity.subArray.count > 0) {
        NSString *str = CustomLocalizedString(@"iCloud_delete_reminderList", nil);
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
    }
    
    [_mainBox setContentView:_loadingView];
    [_loadingAnimationView startAnimation];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        BOOL success = [_iCloudManager deleteReminderCollection:_collectionEntity];
        
        if (success) {
            
            [_iCloudManager getReminderContent];
            
            if (_collectionArr != nil) {
                [_collectionArr release];
                _collectionArr = nil;
            }
            _collectionArr = [_iCloudManager.reminderCollectionArray retain];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (_collectionArr.count <= 0) {
                    [_mainBox setContentView:_noDataView];
                    [self configNoDataView];
                }else {
                    
                    IMBiCloudCalendarCollectionEntity *entity = [_collectionArr objectAtIndex:0];
                    [_collectionItemTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
                    if (_dataSourceArray != nil) {
                        [_dataSourceArray release];
                        _dataSourceArray = nil;
                    }
                    _dataSourceArray = [entity.subArray retain];
                    [_mainBox setContentView:_reminderView];
                    if (_dataSourceArray.count <= 0) {
                        [self configNoCollectionDataView];
                        [_contentBox setContentView:_noCollectionDataView];
                    } else {
                        
                        [_contentBox setContentView:_contentMainView];
                        [self tableViewSelectRow:0];
                        [_itemTableView reloadData];
                        
                    }
                }
                if (_delegate != nil && [_delegate respondsToSelector:@selector(refeashBadgeConut:WithCategory:)] ) {
                    int i = 0;
                    for (IMBiCloudCalendarCollectionEntity *collectionEntity in _collectionArr) {
                        i += collectionEntity.subArray.count;
                    }
                    [_delegate refeashBadgeConut:i WithCategory:_category];
                }
                [_loadingAnimationView endAnimation];
            });
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (_collectionArr.count <= 0) {
                    [_mainBox setContentView:_noDataView];
                    [self configNoDataView];
                }else {
                    
                    if (_dataSourceArray <= 0) {
                        [self configNoCollectionDataView];
                        [_contentBox setContentView:_noCollectionDataView];
                    } else {
                        [_contentBox setContentView:_contentMainView];
                    }
                    [_itemTableView reloadData];
                    [_mainBox setContentView:_reminderView];
                }
                [_loadingAnimationView endAnimation];
                
                [self performSelectorOnMainThread:@selector(showDeleteCollectionErrorTip) withObject:nil waitUntilDone:NO];
            });
            
        }
        
    });
    
}

- (IBAction)menuAddCollectionClick:(id)sender {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    NSString *string = [NSString stringWithFormat:@"%@",CustomLocalizedString(@"Playlist_id_2", nil)];
    NSInteger result = [alerView showTitleName:string InputTextFiledString:@"" OkButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
    if (result == 1) {
        //进行增加操作
        
        [alerView.renameLoadingView setHidden:NO];
        [alerView.renameLoadingView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [alerView.renameLoadingView setImage:[StringHelper imageNamed:@"registedLoading"]];
        [alerView.renameLoadingView.layer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:-2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
        NSString *inputName = [[alerView reNameInputTextField] stringValue];
        if (![TempHelper stringIsNilOrEmpty:inputName]) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                BOOL success = [_iCloudManager addReminderCollection:inputName];
                if (success) {
                    //刷新当前view, TODO也可以在回调事件中从tableview中删除
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [alerView unloadAlertView:alerView.reNameView];
                        [alerView.renameLoadingView setHidden:YES];
                        [_collectionItemTableView reloadData];
                    });
                } else {
                    
                }
                
            });
        }
    }
}

- (void)showSingleReminderContent:(IMBCalendarEventEntity *)entity {
    [self tableViewSelectionDidChange:nil];
}

- (void)showSingleReminderCollectionContent:(IMBiCloudCalendarCollectionEntity *)entity {
    [self tableViewSelectionDidChange:nil];
}

- (void)refeashBadgeConut:(int)badgeConut WithCategory:(CategoryNodesEnum)category {
    
}

- (void)netWorkFaultInterrupt {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertText:CustomLocalizedString(@"iCloudLogin_View_Tips2", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    });
}

#pragma mark - 是否会弹出日历框
- (BOOL)datePickerShouldShowPopover:(ASHDatePicker *)datepicker {
    return YES;
}

@end
