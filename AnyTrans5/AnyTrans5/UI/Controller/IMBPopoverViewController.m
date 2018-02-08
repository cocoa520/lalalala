//
//  IMBPopoverViewController.m
//  PrimoMusic
//
//  Created by iMobie_Market on 16/4/7.
//  Copyright (c) 2016年 IMB. All rights reserved.
//

#import "IMBPopoverViewController.h"
#import "IMBDeviceItem.h"

#define DEVICEITEMTITLEHEIGHT 30 //Title高度
#define DEVICEITEMHEIGHT 60

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
    f.size.height = itemCount * (DEVICEITEMHEIGHT + 12) ;
    f.size.width = 248;
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
    f.size.height = itemCount * (DEVICEITEMHEIGHT + 12) ;
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
            if ([baseinfonew isAndroid] && baseinfonew.uniqueKey) {
                _isHasAndroid = YES;
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
    if (deviceInfoArray != nil && deviceInfoArray.count > 0) {
        int deviceCount = (int)deviceInfoArray.count;
        int iPodY = 0;
        int androidY = 0;
        int iCloudY = 0;
        for (int i = 0; i < deviceCount; i++) {
            baseInfo = [deviceInfoArray objectAtIndex:i];
            NSRect itemRect;
            itemRect.origin.x = f.origin.x+4;
            if ([baseInfo isiPod]) {
                if (_isHasiPod && _isFirstiPod) {
                    f.size.height += 30;
                    self.view.frame = f;
                    iPodY = (deviceCount - i - 1) * (DEVICEITEMHEIGHT + 12) + 10;
                    _isFirstiPod = NO;
                }
                if (_isHasAndroid && _isHasAddiCloud) {
                    itemRect.origin.y = (deviceCount - i - 1) * (DEVICEITEMHEIGHT + 12) + 6 + DEVICEITEMTITLEHEIGHT * 2;
                }else if (_isHasAndroid || _isHasiCloud || _isHasAddiCloud) {
                    itemRect.origin.y = (deviceCount - i - 1) * (DEVICEITEMHEIGHT + 12) + 6 + DEVICEITEMTITLEHEIGHT;
                }else {
                    itemRect.origin.y = (deviceCount - i - 1) * (DEVICEITEMHEIGHT + 12) + 6 + DEVICEITEMTITLEHEIGHT;
                }
            }else if ([baseInfo isAndroid]) {
                if (_isHasAndroid && _isFirstAndroid) {
                    f.size.height += 30;
                    self.view.frame = f;
                    androidY = (deviceCount - i - 1) * (DEVICEITEMHEIGHT + 12) + 10 + DEVICEITEMTITLEHEIGHT;
                    _isFirstAndroid = NO;
                }
                if (_isHasiCloud || _isHasAddiCloud) {
                    itemRect.origin.y = (deviceCount - i - 1) * (DEVICEITEMHEIGHT + 12) + 6 + DEVICEITEMTITLEHEIGHT;
                }else {
                    itemRect.origin.y = (deviceCount - i - 1) * (DEVICEITEMHEIGHT + 12) + 6 + DEVICEITEMTITLEHEIGHT;
                }
            }else if ([baseInfo connectType] == general_Add_Content) {
                f.size.height += 30;
                self.view.frame = f;
                if (_isFirstiCloud) {
                    iCloudY = (deviceCount - i - 1) * (DEVICEITEMHEIGHT + 12) + 10;
                }
                itemRect.origin.y = 6;
            }else if ([baseInfo isicloudView]) {
                if (_isHasiCloud && _isFirstiCloud) {
                    iCloudY = (deviceCount - i - 1) * (DEVICEITEMHEIGHT + 12) + 10;
                    _isFirstiCloud = NO;
                }
                itemRect.origin.y = (deviceCount - i - 1) * (DEVICEITEMHEIGHT + 12) + 6;
            }
            itemRect.size.width = f.size.width - 8;
            itemRect.size.height = DEVICEITEMHEIGHT;
            IMBDeviceItem *deviceItem = [[IMBDeviceItem alloc] initWithFrame:itemRect];
            [deviceItem setDelegate:_delegate];
            [deviceItem setIndex:(i + 1)];
            if ([baseInfo connectType] == general_Add_Content) {
                [deviceItem setIsiCloudView:YES];
                [deviceItem setIsAddContent:YES];
            }else if ([baseInfo isicloudView]) {
                [deviceItem setIsiCloudView:YES];
                float i = 0;
                IMBiCloudNetClient *client = [[[[baseInfo accountiCloud] objectAtIndex:0] iCloudManager] netClient];
                [deviceItem setClient:client];
                if (client.loginInfo.loginInfoEntity.totalStorageInBytes != 0) {
                    i = (client.loginInfo.loginInfoEntity.usedStorageInBytes) * 1.0 / client.loginInfo.loginInfoEntity.totalStorageInBytes;
                }
                [deviceItem loadiCloudCapacity:i];
            }else {
                if ([baseInfo isAndroid]) {
                    [deviceItem setIsAndroidView:YES];
                }
                float i = (baseInfo.allDeviceSize - baseInfo.kyDeviceSize) * 1.0 / baseInfo.allDeviceSize;
                if (baseInfo.allDeviceSize == 0) {
                    i = 0;
                }
                [deviceItem loadCapacity:i];
            }
            
            deviceItem.isSelected = baseInfo.isSelected;
            [deviceItem setBaseInfo:baseInfo];
            [deviceItem setTarget:self.target];
            [deviceItem setAction:self.action];
            [self.view addSubview:deviceItem];
            
            [deviceItem release];
            deviceItem = nil;
        }
        
        if (_isHasiPod) {
            NSRect itemRect;
            itemRect.origin.x = f.origin.x+8;
            if (_isHasAndroid && _isHasAddiCloud) {
                itemRect.origin.y = iPodY + DEVICEITEMTITLEHEIGHT * 4;
            }else if (_isHasAndroid || _isHasiCloud) {
                itemRect.origin.y = iPodY + DEVICEITEMTITLEHEIGHT * 3;
            }else {
                itemRect.origin.y = iPodY + DEVICEITEMTITLEHEIGHT * 3;
            }
            itemRect.size.width = f.size.width - 16;
            itemRect.size.height = DEVICEITEMTITLEHEIGHT;
            IMBDeviceItem *deviceItem = [[IMBDeviceItem alloc] initWithFrame:itemRect];
            [deviceItem setIsTitle:YES];
            [self.view addSubview:deviceItem];
        }
        if (_isHasAndroid) {
            NSRect itemRect;
            itemRect.origin.x = f.origin.x+8;
            itemRect.origin.y = androidY + DEVICEITEMTITLEHEIGHT * 2;
            itemRect.size.width = f.size.width - 16;
            itemRect.size.height = DEVICEITEMTITLEHEIGHT;
            IMBDeviceItem *deviceItem = [[IMBDeviceItem alloc] initWithFrame:itemRect];
            [deviceItem setIsTitle:YES];
            [deviceItem setIsAndroidView:YES];
            if (_isHasiPod) {
                [deviceItem setIsShowLine:YES];
            }
            [self.view addSubview:deviceItem];
        }
        if (_isHasiCloud) {
            NSRect itemRect;
            itemRect.origin.x = f.origin.x+8;
            itemRect.origin.y = iCloudY + DEVICEITEMTITLEHEIGHT * 2;
            itemRect.size.width = f.size.width - 16;
            itemRect.size.height = DEVICEITEMTITLEHEIGHT;
            IMBDeviceItem *deviceItem = [[IMBDeviceItem alloc] initWithFrame:itemRect];
            [deviceItem setIsiCloudView:YES];
            [deviceItem setIsTitle:YES];
            if (_isHasiPod || _isHasAndroid) {
                [deviceItem setIsShowLine:YES];
            }
            [self.view addSubview:deviceItem];
            _isHasAddiCloud = NO;
        }
        if (_isHasAddiCloud) {
            NSRect itemRect;
            itemRect.origin.x = f.origin.x+8;
            itemRect.origin.y = iCloudY + DEVICEITEMTITLEHEIGHT * 2;
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
