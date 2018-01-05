//
//  IMBBookMarkViewController.h
//  AnyTrans
//
//  Created by long on 16-7-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "IMBScrollView.h"
#import "IMBOutlineView.h"
#import "LoadingView.h"
#import "AnimationView.h"
@class IMBOutlineView;
@class IMBBackgroundBorderView;
@class IMBScrollView;
@class IMBAlertViewController;
@class IMBBrowserBookMarkViewController;
@interface IMBBookMarkViewController : IMBBaseViewController<NSOutlineViewDataSource,NSOutlineViewDelegate,NSMenuDelegate,OutlineViewSingleClick>
{
    IBOutlet IMBOutlineView *_outlineView;
    IBOutlet NSView *_containTableOutlineView;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSMenu *_outlineViewMenu;
    IBOutlet NSMenuItem *_editMenuItem;
    IBOutlet NSMenuItem *_addFolderMenuItem;
    IBOutlet NSMenuItem *_addBookMarkMenuItem;
    IBOutlet NSMenuItem *_deletMenuItem;
    
    IBOutlet IMBWhiteView *_lineView;
    IBOutlet IMBScrollView *_scrollView;
    IBOutlet NSBox *_rightMainBox;
    IBOutlet IMBScrollView *_rightScrollView;
    IMBBookmarkEntity *_rootBookmark;
    IMBBookmarksManager *_bookmarkManager;
    IBOutlet NSScrollView *_noDaScrollView;
    BOOL _isBackUp;
    IMBBackupDecryptAbove4 *_backupDecryptAbove4;
    SimpleNode *_node;
    IMBiCloudBackup *_iCloudBackup;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnmationView;
    IBOutlet IMBWhiteView *_deviceLoadingView;
    IBOutlet LoadingView *_deviceAnimationView;
    IBOutlet NSBox *_loadingBox;
    IMBAlertViewController *alerView;
    IBOutlet IMBWhiteView *_backUpNodataView;
    IBOutlet NSTextField *_noDataTitle;
    
    IBOutlet NSView *_deleteView;
    IBOutlet NSTextField *_deleteTitle;
    
    IBOutlet AnimationView *_animationBgView;
    IBOutlet NSView *_animtionView;
    IMBBrowserBookMarkViewController *_broBookVC;
}
@end
