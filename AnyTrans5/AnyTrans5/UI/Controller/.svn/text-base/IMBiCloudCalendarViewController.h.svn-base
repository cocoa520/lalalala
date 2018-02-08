//
//  IMBiCloudCalendarViewController.h
//  AnyTrans
//
//  Created by m on ٢٧‏/٢‏/٢٠١٧.
//  Copyright (c) ٢٠١٧ imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "ASHDatePicker.h"
#import "IMBColorButton.h"
#import "IMBTextBoxView.h"
#import "IMBCalendarNoteEditView.h"
#import "IMBGroupMenu.h"
@class IMBImageAndTitleButton;
@class IMBScrollView;
@class LoadingView;
@class IMBCalendarContentView;
@class IMBCalendarEditView;
@class DownloadTextFieldView;
@class IMBDatePicker;
@class IMBPopupButton;
@interface IMBiCloudCalendarViewController : IMBBaseViewController<ASHDatePickerDelegate,NSMenuDelegate>
{
    IBOutlet NSBox *_mainBox;
    IBOutlet NSBox *_rightBox;
    IBOutlet NSView *_noDataView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSView *_detailView;
    IBOutlet NSView *_leftBottomView;
    IBOutlet IMBImageAndTitleButton *_addListBtn;
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
    IBOutlet IMBTextBoxView *_textBoxTwo;
    IBOutlet NSTextField *_locationTextField;
    IBOutlet NSTextField *_urlLable;
    IBOutlet IMBTextBoxView *_tetxBoxThree;
    IBOutlet NSTextField *_urlTextFiled;
    IBOutlet NSTextField *_notesLable;
    IBOutlet IMBTextBoxView *_textBoxFour;
    IBOutlet IMBScrollView *_noteScrollView;
    IMBCalendarNoteEditView *_notesTextField;
    IBOutlet NSTextField *_summaryLable;
    IBOutlet IMBTextBoxView *_textBoxOne;
    IBOutlet NSTextField *_summaryTextField;
    IBOutlet NSTextField *_startTimeLable;
    IBOutlet NSTextField *_endTimeLable;
    IBOutlet ASHDatePicker *_startTimePicker;
    IBOutlet ASHDatePicker *_endTimePicker;
    IBOutlet IMBColorButton *_groupButton;
    IBOutlet NSView *_middleDetailView;
    IBOutlet NSBox *_editBox;
    IBOutlet NSMenuItem *_addListMenuItem;
    NSMutableArray *_itemArray;
    IMBCalendarContentView *_contentView;
    BOOL _isCalendarAdd;
    BOOL _isEdit;
    IMBiCloudCalendarEventEntity *_currentShowCalendarEntity;
    NSString *_addGuid;
    IMBAlertViewController *_alerView;
    IMBLogManager *_logManger;
    IMBiCloudCalendarCollectionEntity *_rightDownCollectionEntity;
    IMBiCloudCalendarCollectionEntity *_collectionEntity;
}
@end
