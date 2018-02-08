//
//  IMBContactViewController.h
//  NewMacTestApp
//
//  Created by iMobie on 6/11/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBPopupButton.h"
#import "IMBContactEntity.h"
#import "IMBBasicInfoView.h"
#import "IMBBlockView.h"
#import "FlippedView.h"
#import "IMBScrollView.h"
#import "IMBCommonEnum.h"
#import "IMBiPod.h"
#import "IMBContactManager.h"
#import "IMBBaseViewController.h"
#import "IMBPopupKindButton.h"
#import "IMBFilpedView.h"
#import "IMBMyDrawCommonly.h"
#import "LoadingView.h"
#import "AnimationView.h"
#import "IMBiCloudMainPageViewController.h"
@class IMBContactEditView;
@class IMBAlertViewController;
@interface IMBContactViewController : IMBBaseViewController<InternalLayoutChange>{
    IMBContactEntity *_contactEntity;
    IMBiCloudContactEntity *_contactiCloudEntity;
    IMBMyDrawCommonly *_editButton;
    FlippedView *_showFlippedView;
    IMBContactEditView *_editFlippedView;

    IBOutlet IMBScrollView *_scrollView;
    IBOutlet IMBScrollView *_tableViewBackScroll;
    IBOutlet NSBox *_mainBox;
    IBOutlet NSView *_detailView;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IMBContactManager *_contactManager;
    BOOL _isEditing;
    BOOL _firstEnter;
    BOOL _isRefreshing;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    IBOutlet NSBox *_editBox;
    IBOutlet IMBWhiteView *_editLoadingView;
    IBOutlet LoadingView *_editLoadingAnimationView;
    
    IBOutlet IMBWhiteView *_animationView;
    IBOutlet NSTextField *_animationTitle;
    IBOutlet AnimationView *_animationBgView;
    IBOutlet NSView *_animtionView;
    IMBAlertViewController *_alertView;
    BOOL _isDeviceAdd;
    BOOL _isDeviceAddEditView;
    int _selecteRow;
    NSData *_noteImageData;
    BOOL _iCloudAdd;
    BOOL _isiCloudAddEditView;
    BOOL _onlySelectedRow;
    int _icloudTransCount;
    BOOL _isClickCancel;
}
- (void)retToolbar:(IMBToolBarView *)toolbar;
@end
