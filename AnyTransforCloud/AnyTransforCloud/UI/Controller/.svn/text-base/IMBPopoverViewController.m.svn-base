//
//  IMBPopoverViewController.m
//  PrimoMusic
//
//  Created by iMobie_Market on 16/4/7.
//  Copyright (c) 2016年 IMB. All rights reserved.
//

#import "IMBPopoverViewController.h"
#import "IMBDeviceItem.h"
#import "IMBCloudManager.h"
#import "StringHelper.h"
#define DEVICEITEMTITLEHEIGHT 0 //Title高度
#define DEVICEITEMHEIGHT 42
 
@interface IMBPopoverViewController ()

@end

@implementation IMBPopoverViewController
@synthesize delegate = _delegate;
@synthesize target = _target;
@synthesize action = _action;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithAllAry:(NSMutableArray *)ary  {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        _deviceInfoArray = [ary retain];
        _deviceItemDic = [[NSMutableDictionary alloc] init];
        if (_deviceInfoArray != nil && _deviceInfoArray.count > 0) {
            itemCount += (int)_deviceInfoArray.count;
        }
    }
    return self;
}

- (void)awakeFromNib {
    NSRect f = self.view.frame;
    int cloudSize = 0;
    for (IMBCloudEntity *cloudEntity in _deviceInfoArray) {
        NSRect rect = [StringHelper calcuTextBounds:cloudEntity.name font:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
        if (rect.size.width > cloudSize) {
            cloudSize = rect.size.width;
        }
    }
    if (cloudSize > 88) {
        f.size.width = 200 + cloudSize - 88 + 20;
    }else {
        f.size.width = 200;
    }
    if (f.size.width > 220) {
        f.size.width = 220;
    }
    f.size.height = itemCount *DEVICEITEMHEIGHT +16 ;
    
    self.view.frame = f;
    [self loadDeviceInfo];
}

- (void)recountHeight{
    if (_deviceInfoArray != nil && _deviceInfoArray.count > 0) {
        itemCount = (int)_deviceInfoArray.count + 1;
    } else {
        itemCount = 1;
    }
    NSRect f = self.view.frame;
    f.size.height = itemCount * DEVICEITEMHEIGHT  +16 ;
    f.size.width = 60;
    self.view.frame = f;
    [self loadDeviceInfo];
}

- (void)loadDeviceInfo {
    NSRect f = self.view.frame;
    if (_deviceInfoArray != nil && _deviceInfoArray.count > 0) {
        int roiginY = 0;
        if (_deviceInfoArray != nil && _deviceInfoArray.count > 0) {
            int deviceCount = (int)_deviceInfoArray.count;
            for (int i = 0; i < deviceCount; i++) {
                IMBCloudEntity *cloudEntity = [_deviceInfoArray objectAtIndex:i];
                NSRect itemRect;
                itemRect.origin.x = f.origin.x ;
                itemRect.origin.y = (deviceCount - i - 1) * DEVICEITEMHEIGHT + roiginY +8;
                itemRect.size.width = f.size.width;
                itemRect.size.height = DEVICEITEMHEIGHT;
                
                IMBDeviceItem *deviceItem = [[IMBDeviceItem alloc] initWithFrame:itemRect];
                [deviceItem setDelegate:_delegate];
                [deviceItem setIndex:(i + 1)];
                [deviceItem setCloudEntity:cloudEntity];
                deviceItem.isSelected = cloudEntity.isClick;
                
                [deviceItem setTarget:self.target];
                [deviceItem setAction:self.action];
                [self.view addSubview:deviceItem];
                [deviceItem release];
                deviceItem = nil;
            }
        }
    }
 }

- (void)dealloc {
    if (_deviceItemDic != nil) {
        [_deviceItemDic release];
        _deviceItemDic = nil;
    }
    if (_deviceInfoArray) {
        [_deviceInfoArray release];
        _deviceInfoArray = nil;
    }
    [super dealloc];
}

@end
