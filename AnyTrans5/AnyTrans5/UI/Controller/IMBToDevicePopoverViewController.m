//
//  IMBToDevicePopoverViewController.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/8/24.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBToDevicePopoverViewController.h"
#import "ToDeviceViewItem.h"
#define DEVICEITEMHEIGHT 36

@implementation IMBToDevicePopoverViewController
@synthesize delegate = _delegate;
@synthesize exitAction = _exitAction;
@synthesize target = _target;
@synthesize action = _action;
@synthesize exitTarget = _exitTarget;
@synthesize selectValue = _selectValue;
@synthesize sender = _sender;
@synthesize needIcon = _needIcon;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithDevice:(NSMutableArray *)allDeviceArray{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        [_rootView setBackgroundColor:[[NSColor whiteColor] colorWithAlphaComponent:0.95]];
        deviceInfoArray = allDeviceArray;
        _deviceItemDic = [[NSMutableDictionary alloc] init];
        if (deviceInfoArray != nil && deviceInfoArray.count > 0) {
            itemCount = (int) deviceInfoArray.count;
        }
        _needIcon = YES;
    }
    return self;
}

- (void)awakeFromNib {
    NSRect f = self.view.frame;
    if (_needIcon) {
        f.size.height = itemCount * (DEVICEITEMHEIGHT) +12;
    }else{
        f.size.height = itemCount * (24) +12;
    }
    f.size.width = 130;
    self.view.frame = f;
    [self loadDeviceInfo];
}

- (void)loadDeviceInfo {
    NSRect f = self.view.frame;
    if (deviceInfoArray != nil && deviceInfoArray.count > 0) {
        int deviceCount = (int)deviceInfoArray.count;
        for (int i = 0; i < deviceCount; i++) {
            baseInfo = [deviceInfoArray objectAtIndex:i];
            NSRect itemRect;
            itemRect.origin.x = f.origin.x;
            if (_needIcon) {
                itemRect.origin.y = i * DEVICEITEMHEIGHT + 6;
            }else{
                itemRect.origin.y = i * 24 + 6;
            }
            itemRect.size.width = f.size.width;
            if (_needIcon) {
                itemRect.size.height = DEVICEITEMHEIGHT;
            }else{
                itemRect.size.height = 24;
            }
            ToDeviceViewItem *deviceItem = [[ToDeviceViewItem alloc] initWithFrame:itemRect];
            deviceItem.needIcon = _needIcon;
            deviceItem.baseInfo = baseInfo;
            [deviceItem setTarget:self.target];
            [deviceItem setAction:self.action];
            [_deviceItemDic setObject:deviceItem forKey:baseInfo.uniqueKey];
            [self.view addSubview:deviceItem];
            [deviceItem release];
            deviceItem = nil;
        }
    }
}

- (void)iPodLoadComplete:(NSString*)uniqueKey {
    NSArray* allKey = _deviceItemDic.allKeys;
    if (allKey != nil && allKey.count > 0) {
        if ([allKey containsObject:uniqueKey]) {
            ToDeviceViewItem *deviceItem = [_deviceItemDic objectForKey:uniqueKey];
            if (deviceItem != nil) {
//                deviceItem.baseInfo.isLoaded = NO;
//                [deviceItem refresh];
            }
        }
    }
}

- (NSString *)selectValue{
    return _selectValue;
}


- (void)dealloc {
    if (_deviceItemDic != nil) {
        [_deviceItemDic release];
        _deviceItemDic = nil;
    }
    [super dealloc];
}

@end
