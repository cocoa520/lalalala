//
//  IMBBackupCallHistoryViewController.h
//  AnyTrans
//
//  Created by long on 16-7-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCustomHeaderTableView.h"
#import "IMBBaseViewController.h"
#import "IMBScrollView.h"
#import "LoadingView.h"
@interface IMBBackupCallHistoryViewController : IMBBaseViewController
{

    IBOutlet NSImageView *_nodataImageView;
    IBOutlet IMBCustomHeaderTableView *_rightTableView;
     NSMutableArray *_sonAry;
    IBOutlet IMBScrollView *_leftNoteScrollView;
    IBOutlet IMBScrollView *_rightNoteScrollView;
    IBOutlet IMBWhiteView *_lineView;
    IBOutlet NSView *_noData;
    IBOutlet NSBox *_callHistoryBox;
    IBOutlet NSView *_callHistoryDataView;
    IBOutlet NSTextField *_textView;
    SimpleNode *_node;
    IMBBackupDecryptAbove4 *_decryptAbove4;
    IMBiCloudBackup *_iCloudBackup;
    IBOutlet IMBWhiteView *_loadingView;

    IBOutlet LoadingView *_loadingAnmationView;
    BOOL _isSortByName;
}
@property (nonatomic, assign) BOOL isSortByName;
@end
