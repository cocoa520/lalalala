//
//  IMBMessageViewController.h
//  AnyTrans
//
//  Created by long on 16-7-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "IMBMsgContentView.h"
#import "IMBFilpedView.h"
#import "IMBScrollView.h"
#import "IMBMessageView.h"
#import "LoadingView.h"
#import "IMBRefreshButton.h"
#import "IMBLackCornerView.h"
#import "IMBBackupAnimationViewController.h"

@interface IMBMessageViewController : IMBBaseViewController
{
    IBOutlet NSImageView *_backupnodataImageView;
    IBOutlet IMBFilpedView *_msgContentCustomView;
//    IBOutlet IMBFilpedView *_msgContentCustomView;
    IMBMsgContentView *_msgContentView;
    IBOutlet IMBScrollView *_msgContentScrollView;
    IBOutlet IMBWhiteView *_lineView;
    IBOutlet NSBox *_mainBox;
    IBOutlet NSView *_detailView;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    BOOL _isBackup;
    IBOutlet IMBScrollView *_scrollView;
    IBOutlet NSScrollView *_noDataScrollView;
    IBOutlet NSView *_backupNoDataView;
    IBOutlet NSTextField *_backupNoDataTextStr;
    SimpleNode *_node;
    IMBBackupDecryptAbove4 *_decryptAbove4;
    IMBiCloudBackup *_iCloudBackup;
    IBOutlet IMBWhiteView *_loadingView;
    IMBSMSChatDataEntity *entity;
    IMBSMSChatDataEntity *_smsSonData;

    float _scrollheight ;
    float _scrollallHeight;
    IBOutlet LoadingView *_loadingAnmationView;
    IBOutlet NSBox *_loadingBox;
    
    IBOutlet IMBLackCornerView *_refreshView;
    IMBBackupAnimationViewController *_backupAnimationVC;
    IMBRefreshButton *_refreshBtn;
    NSTextField *_refreshTitle;
    NSNotificationCenter *nc;
    BOOL _isSortByName;
}

@end
