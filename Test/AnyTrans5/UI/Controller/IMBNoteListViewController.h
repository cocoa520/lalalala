//
//  IMBNoteListViewController.h
//  iMobieTrans
//
//  Created by iMobie on 14-6-18.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBScrollView.h"
#import "IMBTabTableView.h"
#import "IMBNoteContentView.h"
//#import "IMBNoHeaderTableView.h"
#import "SimpleNode.h"
#import "IMBNoteEditView.h"
#import "IMBEditButton.h"
#import "IMBiCloudMainPageViewController.h"
#import "IMBNotesManager.h"
#import "LoadingView.h"
#import "IMBBackupNoteEditView.h"
@interface IMBNoteListViewController : IMBBaseViewController
{
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSView *_detailView;
    IBOutlet IMBScrollView *editNoteScrollView;
//    IMBScrollView *noteScrollView;

    IBOutlet IMBScrollView *tabScrollView;
    IBOutlet NSBox *_mainBox;
//    IMBEditButton *_editButton;
//    IMBEditButton *_cancelButton;
    
    IMBMyDrawCommonly *_editButton;
    IMBMyDrawCommonly *_cancelButton;
    IMBBackupNoteEditView *_noteEditView;
    BOOL _isEditing;
    BOOL _isRefreshing;
    IMBNoteModelEntity *_notesEntity;
    IMBNotesManager *_noteManagerInNormal;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadAnimationView;
    IMBAlertViewController *_alertView;
    int _firstCount;
    int _transtotalCount;
}
- (void)retToolbar:(IMBToolBarView *)toolbar;
- (BOOL)resignClickByEvent:(NSEvent *)theEvent;
- (void)transfranDic:(NSDictionary *)noteDic;
@end
