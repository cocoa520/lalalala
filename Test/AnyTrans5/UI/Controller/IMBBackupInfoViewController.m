//
//  IMBBackupInfoViewController.m
//  AnyTrans
//
//  Created by smz on 17/10/27.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBBackupInfoViewController.h"
#import "IMBAirBackupDeviceItemView.h"
#import "StringHelper.h"
#import "IMBAirWifiBackupViewController.h"
#define DEVICEITEMHEIGHT 36

@interface IMBBackupInfoViewController ()

@end

@implementation IMBBackupInfoViewController
@synthesize delegete = _delegete;
@synthesize target = _target;
@synthesize action = _action;

- (id)initWithDataArray:(NSMutableArray *)dataArray withDelegate:(id)delegate {
    if (self = [super initWithNibName:@"IMBBackupInfoViewController" bundle:nil]) {
        _dataArr = [dataArray retain];
        _delegete = delegate;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [_detailScrollView setDrawsBackground:YES];
    [_detailScrollView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    if (_dataArr.count * DEVICEITEMHEIGHT < 192) {
        _contentView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(0, 0, 266, 192)];
    } else {
        _contentView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(0, 0, 266, _dataArr.count * DEVICEITEMHEIGHT)];
    }
    
    [_contentView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_detailScrollView setDocumentView:_contentView];
    [_detailScrollView.contentView scrollToPoint:NSMakePoint(0, _contentView.frame.size.height)];
    [self loadDeviceInfo];
}

- (void)loadDeviceInfo {
    _backupRecord = nil;
    if (_dataArr != nil && _dataArr.count > 0) {
        int deviceCount = (int)_dataArr.count;
        for (int i = 1; i <= deviceCount; i++) {
            _backupRecord = [_dataArr objectAtIndex:i-1];
            NSRect itemRect;
            itemRect.origin.x = 0;
            if (deviceCount * DEVICEITEMHEIGHT < 192) {
                itemRect.origin.y = 192 - i * DEVICEITEMHEIGHT;
            } else {
                itemRect.origin.y = deviceCount * DEVICEITEMHEIGHT - i * DEVICEITEMHEIGHT;
            }
            
            itemRect.size.width = 266 + 30;
            itemRect.size.height = DEVICEITEMHEIGHT;
            IMBAirBackupDeviceItemView *deviceItem = [[IMBAirBackupDeviceItemView alloc] initWithFrame:itemRect];
            [deviceItem setIsBackupInfo:YES];
            [deviceItem setDelegate:_delegate];
            [deviceItem setBackupRecord:_backupRecord];
            [deviceItem setTarget:self.target];
            [deviceItem setAction:self.action];
            [_contentView addSubview:deviceItem];
            [deviceItem release];
            deviceItem = nil;
        }
    }
}

- (void)dealloc {
    if (_dataArr != nil) {
        [_dataArr release];
        _dataArr = nil;
    }
    if (_contentView != nil) {
        [_contentView release];
        _contentView = nil;
    }
    [super dealloc];
}

@end
