//
//  IMBiCloudPopViewController.m
//  AnyTrans
//
//  Created by LuoLei on 17-1-18.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBiCloudPopViewController.h"
#import "IMBiCloudItemView.h"
#import "IMBiCloudMainPageViewController.h"
#define DEVICEITEMHEIGHT 60
@interface IMBiCloudPopViewController ()

@end

@implementation IMBiCloudPopViewController
@synthesize target = _target;
@synthesize action = _action;
@synthesize isTitleBtn = _isTitleBtn;
@synthesize currentAppleID = _currentAppleID;
- (id)initWithNibName:(NSString *)nibNameOrNil iCloudAccountArr:(NSArray *)accountArr withCureentAppleID:(NSString *)curenntAppleID
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Initialization code here.
        _accountArr = [accountArr retain];
        if (curenntAppleID != nil) {
             _currentAppleID = [curenntAppleID retain];
        }
    }
    return self;
}

- (void)setCurrentAppleID:(NSString *)currentAppleID {
    if (_currentAppleID != nil) {
        [_currentAppleID release];
        _currentAppleID = nil;
    }
    if (currentAppleID != nil) {
        _currentAppleID = [_currentAppleID retain];
    }
}

- (void)awakeFromNib {
    [self.view setFrame:NSMakeRect(0, 0, 160, 160)];
    NSRect f = self.view.frame;
    f.size.height = (_accountArr.count + 1) * (DEVICEITEMHEIGHT) +12 ;
    f.size.width = 250;
    self.view.frame = f;
    [self loadiCloudInfo];
}

- (void)loadiCloudInfo {
    NSRect f = self.view.frame;
    NSRect itemRect;
    itemRect.origin.x = f.origin.x+6;
    itemRect.origin.y =  0 + 6;
    itemRect.size.width = f.size.width - 12;
    itemRect.size.height = DEVICEITEMHEIGHT;
//    if (_isTitleBtn) {
    IMBiCloudItemView *deviceItem = [[IMBiCloudItemView alloc] initWithFrame:itemRect];
    [deviceItem setTarget:self.target];
    [deviceItem setAction:self.action];
    [deviceItem setAccountName:CustomLocalizedString(@"icloud_addAcount", nil)];
    [deviceItem setIsAddContent:YES];
    [self.view addSubview:deviceItem];
//    }

//    NSArray *allAppleID = _accountDic.allKeys;
    int j = 0;
    IMBiCloudNetClient *currClient = nil;
     for (int i = 0; i < _accountArr.count; i++) {
         IMBiCloudNetClient *client = [_accountArr objectAtIndex:i];
         NSString *appleStr = client.loginInfo.appleID;
         if (![appleStr isEqualToString:_currentAppleID]) {
             itemRect.origin.x = f.origin.x+6;
             itemRect.origin.y = (j + 1) * DEVICEITEMHEIGHT + 6;
             itemRect.size.width = f.size.width - 12;
             itemRect.size.height = DEVICEITEMHEIGHT;
             IMBiCloudItemView *deviceItem = [[IMBiCloudItemView alloc] initWithFrame:itemRect];
             [deviceItem setTarget:self.target];
             [deviceItem setAction:self.action];
             [deviceItem setAccountName:appleStr];
             float i = 0;
             if (client.loginInfo.loginInfoEntity.totalStorageInBytes != 0) {
                 i = (client.loginInfo.loginInfoEntity.usedStorageInBytes) * 1.0 / client.loginInfo.loginInfoEntity.totalStorageInBytes;
             }
             
             [deviceItem loadCapacity:i];
             
             [deviceItem setClient:client];
             [self.view addSubview:deviceItem];
             [deviceItem release];
             j ++;
         }else {
             currClient = [client retain];
         }
     }
    
    itemRect.origin.x = f.origin.x+6;
    itemRect.origin.y = _accountArr.count * DEVICEITEMHEIGHT + 6;
    itemRect.size.width = f.size.width - 12;
    itemRect.size.height = DEVICEITEMHEIGHT;
    
    if (_currentAppleID != nil && currClient != nil) {
        IMBiCloudItemView *deviceItem2 = [[IMBiCloudItemView alloc] initWithFrame:itemRect];
        [deviceItem2 setTarget:self.target];
        [deviceItem2 setAction:self.action];
        [deviceItem2 setAccountName:_currentAppleID];
        [deviceItem2 setClient:currClient];
        float i = 0;
        if (currClient.loginInfo.loginInfoEntity.totalStorageInBytes != 0) {
             i = (currClient.loginInfo.loginInfoEntity.usedStorageInBytes) * 1.0 / currClient.loginInfo.loginInfoEntity.totalStorageInBytes;
        }
        [deviceItem2 loadCapacity:i];
        deviceItem2.isSelected = YES;
        deviceItem.isSelected = NO;
        [self.view addSubview:deviceItem2];
        [deviceItem2 release];
        [currClient release];
    }else {
        deviceItem.isSelected = YES;
    }
    [deviceItem release];
}

- (void)dealloc
{
    [_accountArr release],_accountArr = nil;
    [_currentAppleID release], _currentAppleID = nil;
    [super dealloc];
}
@end
