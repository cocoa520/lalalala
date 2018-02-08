//
//  IMBVoiceMailViewController.h
//  AnyTrans
//
//  Created by long on 16-7-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBBaseViewController.h"
#import "IMBScrollView.h"
#import "LoadingView.h"
#import "IMBRefreshButton.h"
#import "IMBLackCornerView.h"
#import "IMBBackupAnimationViewController.h"

@interface IMBVoiceMailViewController : IMBBaseViewController
{
    IBOutlet NSImageView *_backupnodataImageView;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSView *_containTableView;
    IBOutlet NSBox *_mainBox;
    BOOL _isBackup;
    IBOutlet NSScrollView *_noDataTextScroll;
    IBOutlet NSView *_backUpNoDataView;
    IBOutlet NSTextField *_backUpNoDataTextStr;
    SimpleNode *_node;
    IMBBackupDecryptAbove4 *_decryptAbove4;
    IMBiCloudBackup *_iCloudBackUp;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    IBOutlet IMBLackCornerView *_refreshView;
    IBOutlet IMBCustomHeaderTableView *_rightTableView;
    IBOutlet IMBWhiteView *_middleLineView;
    NSMutableArray *_sonAry;
    IMBRefreshButton *_refreshBtn;
    NSTextField *_refreshTitle;
    NSNotificationCenter *_nc;
    IMBBackupAnimationViewController *_backupAnimationVC;
}

@end
