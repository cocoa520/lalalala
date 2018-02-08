//
//  IMBMessageViewController.h
//  AnyTrans
//
//  Created by long on 17-7-17.
//  Copyright (c) 2017年 imobie. All rights reserved.
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

@interface IMBAndroidMessageViewController : IMBBaseViewController
{
    IBOutlet NSImageView *_backupnodataImageView;
    IBOutlet IMBFilpedView *_msgContentCustomView;
    IMBMsgContentView *_msgContentView;
    IBOutlet IMBScrollView *_msgContentScrollView;
    IBOutlet IMBWhiteView *_lineView;
    IBOutlet NSBox *_mainBox;
    IBOutlet NSView *_detailView;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet IMBScrollView *_scrollView;
    IBOutlet NSScrollView *_noDataScrollView;
    IBOutlet NSView *_backupNoDataView;
    IBOutlet NSTextField *_backupNoDataTextStr;
    IBOutlet IMBWhiteView *_loadingView;
    
    IMBThreadsEntity *_androidEntity;
    IMBThreadsEntity *_androidSmsSonData;
    float _scrollheight ;
    float _scrollallHeight;
    IBOutlet LoadingView *_loadingAnmationView;
    IBOutlet NSBox *_loadingBox;
    NSNotificationCenter *nc;
    BOOL _isSortByName;

    IBOutlet IMBFilpedView *_customView;
    NSOperationQueue *_operationQueue;
    BOOL _isReload;
}
@end
