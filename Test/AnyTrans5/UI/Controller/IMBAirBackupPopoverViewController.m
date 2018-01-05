//
//  IMBAirBackupPopoverViewController.m
//  AnyTrans
//
//  Created by smz on 17/10/20.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBAirBackupPopoverViewController.h"
#import "IMBAirBackupDeviceItemView.h"
#import "StringHelper.h"
#import "IMBAirWifiBackupViewController.h"
#define DEVICEITEMHEIGHT 56


@implementation IMBAirBackupPopoverViewController
@synthesize delegate = _delegate;
@synthesize target = _target;
@synthesize action = _action;
@synthesize connectType = _connectType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSelectedValue:(NSString*)selectedValue WithDevice:(NSMutableArray *)ary withConnectType:(IPodFamilyEnum)connectType {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        deviceInfoArray = [ary copy];
        _connectType = connectType;
        if (deviceInfoArray != nil && deviceInfoArray.count > 0) {
            itemCount += (int) deviceInfoArray.count;
        }
    }
    return self;
}

- (void)awakeFromNib {
    NSRect f = self.view.frame;
    f.size.height = itemCount * (DEVICEITEMHEIGHT + 12) ;
    f.size.width = 264;
    self.view.frame = f;
    [self loadDeviceInfo];
}

- (void)loadDeviceInfo {
    NSRect f = self.view.frame;
    baseInfo = nil;
    if (deviceInfoArray != nil && deviceInfoArray.count > 0) {
        int deviceCount = (int)deviceInfoArray.count;
        for (int i = 0; i < deviceCount; i++) {
            baseInfo = [deviceInfoArray objectAtIndex:i];
            NSRect itemRect;
            itemRect.origin.x = f.origin.x+6;
            itemRect.origin.y = (deviceCount - i - 1) * (DEVICEITEMHEIGHT + 12) + 6;
            itemRect.size.width = f.size.width - 12;
            itemRect.size.height = DEVICEITEMHEIGHT;
            IMBAirBackupDeviceItemView *deviceItem = [[IMBAirBackupDeviceItemView alloc] initWithFrame:itemRect];
            [deviceItem setDelegate:_delegate];
            deviceItem.isSelected = baseInfo.isSelected;
            [deviceItem setBaseInfo:baseInfo];
            [deviceItem setTarget:self.target];
            [deviceItem setAction:self.action];
            [self.view addSubview:deviceItem];
            
            if (i > 0 && i < deviceCount) {
                IMBWhiteView *lineView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(deviceItem.frame.origin.x,deviceItem.frame.origin.y + 62, deviceItem.frame.size.width, 1)];
                [lineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
                [self.view addSubview:lineView];
                [lineView release];
                lineView = nil;
            }
            
            [deviceItem release];
            deviceItem = nil;
        }
    }
}

- (void)dealloc {
    [super dealloc];
}
@end
