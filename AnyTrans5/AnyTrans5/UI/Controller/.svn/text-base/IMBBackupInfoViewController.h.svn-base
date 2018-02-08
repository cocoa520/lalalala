//
//  IMBBackupInfoViewController.h
//  AnyTrans
//
//  Created by smz on 17/10/27.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBScrollView.h"
#import "PopoverRootView.h"
#import "IMBDeviceConnection.h"
#import "IMBWhiteView.h"
@class IMBBackupRecord;
@interface IMBBackupInfoViewController : NSViewController<NSTableViewDataSource,NSTableViewDelegate> {
    id _delegete;
    NSMutableArray *_dataArr;
    IBOutlet IMBScrollView *_detailScrollView;
    id _target;
    SEL _action;
    int _itemCount;
    id _delegate;
    IMBBackupRecord *_backupRecord;
    IMBWhiteView *_contentView;
}
@property (nonatomic, assign) id delegete;
@property (nonatomic, readwrite, retain) id target;
@property (nonatomic, readwrite) SEL action;
- (id)initWithDataArray:(NSMutableArray *)dataArray withDelegate:(id)delegate;

@end
