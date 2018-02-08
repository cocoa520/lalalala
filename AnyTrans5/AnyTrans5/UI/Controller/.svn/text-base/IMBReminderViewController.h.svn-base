//
//  IMBReminderViewController.h
//  AnyTrans
//
//  Created by iMobie on 17/2/27.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBScrollView.h"
#import "IMBReminderEditView.h"
#import "LoadingView.h"
#import "IMBDatePicker.h"
#import "IMBPopupButton.h"
#import "DownloadTextFieldView.h"
#import "IMBCheckBtn.h"
#import "IMBCalendarContentView.h"
#import "IMBImageAndTitleButton.h"
#import "IMBCheckBoxCell.h"
#import "ASHDatePicker.h"
#import "IMBTextBoxView.h"
#import "IMBCalendarNoteEditView.h"

@interface IMBReminderViewController : IMBBaseViewController<ASHDatePickerDelegate> {
    
    IBOutlet NSBox *_contentBox;
    IBOutlet NSView *_contentMainView;
    IBOutlet IMBWhiteView *_reminderWhiteView;
    IBOutlet NSBox *_mainBox;
    //显示界面
    IMBCalendarContentView *_contentView;
    IBOutlet NSView *_reminderView;
    IBOutlet IMBCustomHeaderTableView *_collectionItemTableView;//reminder集合
    IBOutlet IMBDottedlLineView *_lineView;
    IBOutlet IMBScrollView *_reminderlistView;
    IBOutlet IMBScrollView *_reminderlistView2;
    IBOutlet IMBScrollView *_reminderDetailView;
    IBOutlet NSBox *_editBox;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    
    //edit界面
    IBOutlet IMBReminderEditView *_reminderEditView;
    IBOutlet NSTextField *_reminderTitle;
    IBOutlet NSTextField *_reminderCheckLb;
    IBOutlet IMBCheckBtn *_checkBtn;
    IBOutlet NSView *_otherView;
    IBOutlet NSView *_timeView;
    IBOutlet ASHDatePicker *_datePicker;
    IBOutlet IMBPopupButton *_listPopBtn;
    IBOutlet IMBPopupButton *priorityPopBtn;
    IBOutlet NSTextField *_listLb;
    IBOutlet NSTextField *_priorityLb;
    IBOutlet NSTextField *_descriptionLb;
    IBOutlet IMBTextBoxView *_borderView;
    IBOutlet IMBTextBoxView *_descriptionBorderView;
    IBOutlet IMBScrollView *_descripScrollView;
    IMBCalendarNoteEditView *_notesTextField;
    
    //nodata
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImage;
    IBOutlet NSTextView *_textView;
    IBOutlet NSView *_noCollectionDataView;
    IBOutlet NSImageView *_noCollectionDataImage;
    IBOutlet NSTextView *_noDataTextView;

    IBOutlet IMBWhiteView *_editLoadingView;
    IBOutlet LoadingView *_editLoadingAnimationView;
    BOOL isFinished;
    BOOL _isEdit;
    BOOL _isReminderAdd;
    IBOutlet IMBCheckBoxCell *_itemCheck;
    IBOutlet IMBCheckBoxCell *_collectionCheck;
    
    IBOutlet IMBWhiteView *_buttomView;
    IBOutlet IMBImageAndTitleButton *_addListBtn;
    
    IMBiCloudCalendarEventEntity *currentEditCalendarEntity;
    IMBiCloudCalendarEventEntity *currentShowCalendarEntity;
    IMBiCloudCalendarEventEntity *_currentShowiCloudCalendarEntity;
    NSMutableArray *_collectionArr;
    IMBAlertViewController *alerView;
    
    IBOutlet NSMenu *_deleteMenu;
    IBOutlet NSMenuItem *_deleteItem;
    IMBiCloudCalendarCollectionEntity *_collectionEntity;
    
}

@property (nonatomic,retain) NSMutableArray *collectionArr;
- (void)refeashBadgeConut:(int)badgeConut WithCategory:(CategoryNodesEnum)category;
- (void)retToolbar:(IMBToolBarView*)toolbarview;

@end
