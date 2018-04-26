//
//  IMBPopoverViewController.m
//  PrimoMusic
//
//  Created by iMobie_Market on 16/4/7.
//  Copyright (c) 2016年 IMB. All rights reserved.
//

#import "IMBPopoverViewController.h"
#import "IMBDeviceItem.h"

#define DEVICEITEMTITLEHEIGHT 0 //Title高度
#define DEVICEITEMHEIGHT 42

@interface IMBPopoverViewController ()

@end

@implementation IMBPopoverViewController
@synthesize delegate = _delegate;
@synthesize exitAction = _exitAction;
@synthesize target = _target;
@synthesize action = _action;
@synthesize exitTarget = _exitTarget;
@synthesize connectType = _connectType;
@synthesize isHasiPod = _isHasiPod;
@synthesize isHasAndroid = _isHasAndroid;
@synthesize isHasiCloud = _isHasiCloud;
@synthesize isHasAddiCloud = _isHasAddiCloud;
@synthesize isFirstiPod = _isFirstiPod;
@synthesize isFirstAndroid = _isFirstAndroid;
@synthesize isFirstiCloud = _isFirstiCloud;

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
        _isHasiPod = NO;
        _isHasAndroid = NO;
        _isHasiCloud = NO;
        _isHasAddiCloud = YES;
        _isFirstiPod = YES;
        _isFirstAndroid = YES;
        _isFirstiCloud = YES;
        _selectValue = [selectedValue retain];
        deviceInfoArray = [ary copy];
        _deviceItemDic = [[NSMutableDictionary alloc] init];
        _connectType = connectType;
        if (deviceInfoArray != nil && deviceInfoArray.count > 0) {
            itemCount += (int) deviceInfoArray.count;
        }
        if (itemCount > 0) {
            ++itemCount;
        }
    }
    return self;
}

- (void)awakeFromNib {
    NSRect f = self.view.frame;
    f.size.height = itemCount * (DEVICEITEMHEIGHT + 8) ;
    f.size.width = 304;
    self.view.frame = f;
    [self loadDeviceInfo];
}

- (void)recountHeight{
    if (deviceInfoArray != nil && deviceInfoArray.count > 0) {
        itemCount = (int)deviceInfoArray.count + 1;
    } else {
        itemCount = 1;
    }
    NSRect f = self.view.frame;
    f.size.height = itemCount * (DEVICEITEMHEIGHT + 8) ;
    f.size.width = 142;
    self.view.frame = f;
    [self loadDeviceInfo];
}

- (void)setSelectValue:(NSString *)selectValue {
    _selectValue = selectValue;
    for (id view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self.view setNeedsDisplay:YES];
    [self recountHeight];
}

- (NSString *)selectValue{
    return _selectValue;
}

- (void)loadDeviceInfo {
    NSRect f = self.view.frame;
    baseInfo = nil;
    NSMutableArray *deviceMutbAry = [[NSMutableArray alloc]init];;
    if (deviceInfoArray != nil && deviceInfoArray.count > 0) {
        for (IMBBaseInfo *baseinfonew in deviceInfoArray) {
            if ([baseinfonew isiPod] && baseinfonew.uniqueKey) {
                _isHasiPod = YES;
                [deviceMutbAry addObject:baseinfonew];
            }
        }
        for (IMBBaseInfo *baseinfonew in deviceInfoArray) {
            if ([baseinfonew isicloudView] && baseinfonew.uniqueKey) {
                _isHasiCloud = YES;
                [deviceMutbAry addObject:baseinfonew];
            }
        }
    }
    IMBBaseInfo *addBaseInfo = [[IMBBaseInfo alloc] init];
    [addBaseInfo setIsicloudView:YES];
    [addBaseInfo setDeviceName:CustomLocalizedString(@"icloud_addAcount", nil)];
    [addBaseInfo setConnectType:general_Add_Content];
    
    [deviceMutbAry addObject:addBaseInfo];
    deviceInfoArray = [deviceMutbAry copy];
    [deviceMutbAry release];
    [addBaseInfo release];
    int roiginY = 8;
    if (deviceInfoArray != nil && deviceInfoArray.count > 0) {
        int deviceCount = (int)deviceInfoArray.count;
        for (int i = 0; i < deviceCount; i++) {
            baseInfo = [deviceInfoArray objectAtIndex:i];
            NSRect itemRect;
            itemRect.origin.x = f.origin.x+4;
            itemRect.origin.y = (deviceCount - i - 1) * DEVICEITEMHEIGHT + roiginY;
            itemRect.size.width = f.size.width - 8;
            itemRect.size.height = DEVICEITEMHEIGHT;
            
            IMBDeviceItem *deviceItem = [[IMBDeviceItem alloc] initWithFrame:itemRect];
            [deviceItem setDelegate:_delegate];
            [deviceItem setIndex:(i + 1)];
            if (i < deviceCount  && i!=0) {
                [deviceItem setIsShowLine:YES];
            }
            [deviceItem setIsiCloudView:NO];
            deviceItem.isSelected = baseInfo.isSelected;
            [deviceItem setBaseInfo:baseInfo];
            [deviceItem setTarget:self.target];
            [deviceItem setAction:self.action];
            [self.view addSubview:deviceItem];
            
            [deviceItem release];
            deviceItem = nil;
        }
        if (_isHasAddiCloud) {
            NSRect itemRect;
            itemRect.origin.x = f.origin.x+8;
//            itemRect.origin.y = DEVICEITEMTITLEHEIGHT * 2;
            itemRect.size.width = f.size.width - 16;
            itemRect.size.height = DEVICEITEMTITLEHEIGHT;
            IMBDeviceItem *deviceItem = [[IMBDeviceItem alloc] initWithFrame:itemRect];
            [deviceItem setIsiCloudView:YES];
            [deviceItem setIsTitle:YES];
            if (_isHasiCloud) {
                [deviceItem setIsShowLine:NO];
            }else {
                [deviceItem setIsShowLine:YES];
            }
            [self.view addSubview:deviceItem];
        }
        _isHasiPod = NO;
        _isHasAndroid = NO;
        _isHasiCloud = NO;
        _isHasAddiCloud = YES;
    }
}

- (void)iPodLoadComplete:(NSString*)uniqueKey {
    NSArray* allKey = _deviceItemDic.allKeys;
    if (allKey != nil && allKey.count > 0) {
        if ([allKey containsObject:uniqueKey]) {
            IMBDeviceItem *deviceItem = [_deviceItemDic objectForKey:uniqueKey];
            if (deviceItem != nil) {
                deviceItem.baseInfo.isLoaded = NO;
                [deviceItem refresh];
            }
        }
    }
}

- (void)dealloc {
    if (_deviceItemDic != nil) {
        [_deviceItemDic release];
        _deviceItemDic = nil;
    }
    if (_selectValue) {
        [_selectValue release];
        _selectValue = nil;
    }
    [super dealloc];
}

@end
