//
//  IMBBackupCallHistoryViewController.h
//  AnyTrans
//
//  Created by long on 17-7-17.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCustomHeaderTableView.h"
#import "IMBBaseViewController.h"
#import "IMBScrollView.h"
#import "LoadingView.h"
@interface IMBAndroidCallHistoryViewController : IMBBaseViewController
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
    IBOutlet NSTextView *_textView;
    IBOutlet IMBWhiteView *_loadingView;

    IBOutlet LoadingView *_loadingAnmationView;
    BOOL _isSortByName;
}
@property (nonatomic, assign) BOOL isSortByName;
- (void)loadSonAryData;
@end
