//
//  IMBAndroidCalendarViewController.h
//  AnyTrans
//
//  Created by smz on 17/7/17.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBBaseViewController.h"
#import "IMBFilpedView.h"
#import "IMBCustomHeaderTableView.h"
#import "IMBADCalendarEntity.h"
#import "LoadingView.h"

@interface IMBAndroidCalendarViewController : IMBBaseViewController<NSTableViewDelegate,NSTableViewDataSource,IMBImageRefreshListListener, TransferDelegate> {
    
    IBOutlet NSBox *_mainBox;
    IBOutlet NSView *_noDataView;
    IBOutlet NSImageView *_noDataImage;
    IBOutlet NSTextView *_noDataText;
    IBOutlet NSView *_detailView;
    IBOutlet IMBCustomHeaderTableView *_leftTableView;
    IBOutlet IMBCustomHeaderTableView *_middleTableView;
    IBOutlet IMBFilpedView *rightCustomView;
    IBOutlet NSScrollView *rightScrollView;
    IBOutlet NSTextView *rightTextView;
    IBOutlet IMBWhiteView *_rightLineView;
    IBOutlet IMBWhiteView *_middleLineView;
    IMBADCalendarEntity *_currentEntity;
    IMBCalendarAccountEntity *_accountEntity;
    IBOutlet IMBWhiteView *_topLineView;
    NSMutableArray *_sonArray;
    IBOutlet IMBWhiteView *_loadingView;
    IBOutlet LoadingView *_loadingAnimationView;
    IBOutlet NSBox *_noDataBox;
    IBOutlet NSView *_noDataView2;
    IBOutlet NSImageView *_noDataImage2;
    IBOutlet NSTextView *_noDataText2;
    NSMutableArray *_searchArray;
}

@end
