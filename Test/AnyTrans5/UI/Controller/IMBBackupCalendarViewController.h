//
//  IMBBackupCalendarViewController.h
//  AnyTrans
//
//  Created by long on 16-7-21.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBFilpedView.h"
#import "IMBBaseViewController.h"
#import "LoadingView.h"
@interface IMBBackupCalendarViewController : IMBBaseViewController<NSTableViewDelegate,NSTableViewDataSource,IMBImageRefreshListListener>
{
    IBOutlet NSScrollView *rightScrollView;
    IBOutlet IMBFilpedView *rightCustomView;
    IBOutlet NSTextView *rightTextView;
    IBOutlet IMBWhiteView *_lineView;
    IBOutlet NSView *_calendarDataView;
    IBOutlet NSView *_noDataView;
    IBOutlet NSBox *_calendarBox;
    IBOutlet NSTextField *_noDataTextStr;
    SimpleNode *_node;
    IMBiCloudBackup *_iCloudBackup;
    IMBBackupDecryptAbove4 *_decryptAbove4;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;

    IBOutlet NSImageView *_nodataImageView;
    IBOutlet IMBWhiteView *_rigthBgView;
}
@end
