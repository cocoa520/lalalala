//
//  IMBSafariHistoryViewController.h
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/27.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBScrollView.h"
#import "LoadingView.h"
#import "IMBRefreshButton.h"
#import "IMBLackCornerView.h"
#import "IMBBackupAnimationViewController.h"
@interface IMBSafariHistoryViewController : IMBBaseViewController

{
    IBOutlet NSImageView *_backupNodataImageView;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImageView;
    IBOutlet NSTextView *_textView;
    IBOutlet NSView *_containTableView;
    IBOutlet NSBox *_mainBox;
    BOOL _isBackup;
    IBOutlet IMBScrollView *_scrollView;
    IBOutlet NSScrollView *_noDataScrollView;
    IBOutlet NSView *_backupNodataView;
    IBOutlet NSTextField *_backupNodataTextStr;
    SimpleNode *_node;
    IMBBackupDecryptAbove4 *_decryptAbove4;
    IMBiCloudBackup *_iCloudBackup;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnmationView;
    
    IBOutlet IMBLackCornerView *_refreshView;
    IMBRefreshButton *_refreshBtn;
    NSTextField *_refreshTitle;
    NSNotificationCenter *_nc;
    IMBBackupAnimationViewController *_backupAnimationVC;
    
}
@property (nonatomic, assign) BOOL isBackup;

@end
