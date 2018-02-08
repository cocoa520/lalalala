//
//  IMBCalendarViewController.h
//  AnyTrans
//
//  Created by smz on 17/7/25.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBCalendarEntity.h"
#import "IMBColorButton.h"
#import "ASHDatePicker.h"
#import "IMBCalendarNoteEditView.h"
#import "IMBTextBoxView.h"

@class IMBImageAndTitleButton;
@class IMBScrollView;
@class LoadingView;
@class IMBCalendarContentView;
@class IMBCalendarEditView;
@class DownloadTextFieldView;
@class IMBDatePicker;
@class IMBPopupButton;
@interface IMBCalendarViewController : IMBBaseViewController<NSMenuDelegate,ASHDatePickerDelegate> {
    
    IBOutlet NSBox *_mainBox;
    IBOutlet NSBox *_rightBox;
    IBOutlet NSView *_noDataView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSView *_detailView;
    IBOutlet IMBCustomHeaderTableView *_middleTableView;
    IBOutlet IMBWhiteView *_middleTopView;
    IBOutlet IMBPopUpBtn *_middleSelectPopBtn;
    IBOutlet IMBPopUpBtn *_middleSortPopBtn;
    IBOutlet IMBScrollView *_contentScrollView;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_animationView;
    IBOutlet IMBWhiteView *_editLoadingView;
    IBOutlet LoadingView *_editAnimationView;
    IBOutlet IMBWhiteView *_leftLineView;
    IBOutlet IMBWhiteView *_middleLineView;
    IBOutlet IMBCalendarEditView *_calendarEditView;
    
    IBOutlet NSTextField *_locationLable;
    IBOutlet NSTextField *_locationTextField;
    IBOutlet NSTextField *_urlLable;
    IBOutlet NSTextField *_urlTextFiled;
    IBOutlet NSTextField *_notesLable;
    IMBCalendarNoteEditView *_notesTextField;
    IBOutlet NSTextField *_summaryLable;
    IBOutlet NSTextField *_summaryTextField;
    IBOutlet NSTextField *_startTimeLable;
    IBOutlet NSTextField *_endTimeLable;
    IBOutlet ASHDatePicker *_startTimePicker;
    IBOutlet ASHDatePicker *_endTimePicker;
    IBOutlet NSView *_middleDetailView;
    IBOutlet NSBox *_editBox;
    IBOutlet NSMenuItem *_addListMenuItem;
    IBOutlet IMBColorButton *_groupButton;
    IBOutlet IMBTextBoxView *_noteView;
    IBOutlet IMBScrollView *_noteScrollView;
    IBOutlet IMBTextBoxView *_textBoxOne;
    IBOutlet IMBTextBoxView *_textBoxTwo;
    IBOutlet IMBTextBoxView *_textBoxThree;
    IBOutlet IMBTextBoxView *_textBoxFour;
    NSMutableArray *_itemArray;
    IMBCalendarContentView *_contentView;
    BOOL _isCalendarAdd;
    BOOL _isEdit;
    IMBCalendarEventEntity *_currentShowCalendarEntity;
    IMBLogManager *_logManger;
    IMBCalendarEntity *_rightDownCollectionEntity;
    IMBCalendarsManager *_calendarManager;
    IMBCalendarEntity *_collectionEntity;
    NSString *_curCalendarID;
    NSMutableArray *_researchItemArray;
    
}
- (NSArray *)selectItems;

@end
