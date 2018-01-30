//
//  IMBAppEntity.m
//  iMobieTrans
//
//  Created by zhang yang on 13-5-16.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBAppEntity.h"
#import "StringHelper.h"
@implementation IMBAppEntity
@synthesize appIconImage = _appIconImage;
@synthesize appKey = _appKey;
@synthesize appName = _appName;
@synthesize appSize = _appSize;
@synthesize appStoreID = _appStoreID;
@synthesize copyright = _copyright;
@synthesize dtplatformName = _dtplatformName;
@synthesize minimunOSVerison = _minimunOSVerison;
@synthesize purchaseDate = _purchaseDate;
@synthesize version = _version;
@synthesize uiDeviceFamily = _uiDeviceFamily;
@synthesize documentSize = _documentSize;
@synthesize srcFilePath = _srcFilePath;
@synthesize groupArray = _groupArray;
@synthesize set;
@synthesize currentDevicePath = _currentDevicePath;
@synthesize appNameAs = _appNameAs;
- (id)init
{
    self = [super init];
    if (self) {
        _uiDeviceFamily = AppUIDeviceFamily_All;
        _groupArray = nil;
    }
    return self;
}

- (void)dealloc
{
    /*
    NSString *_appName;
    NSString *_appStoreID;
    long long _appSize;
    NSImage *_appIconImage;
    //App bundle ID
    NSString *_appKey;
    NSString *_version;
    NSString *_minimunOSVerison;
    //这个地方需要读取平台的版本号吗
    NSString *_dtplatformName;
    //
    NSString *_purchaseDate;
    NSString *_copyright;
    */
    if (_appName != nil) {
        [_appName release];
    }
    if (_appStoreID != nil) {
        [_appStoreID release];
    }
    if (_appIconImage != nil) {
        [_appIconImage release];
    }
    if (_appKey != nil) {
        [_appKey release];
    }
    if (_copyright != nil) {
        [_copyright release];
    }
    if (_minimunOSVerison != nil) {
        [_minimunOSVerison release];
    }
    if (_dtplatformName) {
        [_dtplatformName release];
    }
    if (_purchaseDate != nil) {
        [_purchaseDate release];
    }
    if (_version != nil) {
        [_version release];
    }
    if (_srcFilePath != nil){
        [_srcFilePath release];
    }
    if (_groupArray != nil) {
        [_groupArray release];
        _groupArray = nil;
    }
    [super dealloc];
}

- (void)setAppNameAttributedString {
    if (_appName) {
        NSMutableAttributedString *as = [[[NSMutableAttributedString alloc] initWithString:_appName] autorelease];
        [as addAttribute:NSForegroundColorAttributeName value:IMBGrayColor(51) range:NSMakeRange(0, as.length)];
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [self setAppNameAs:as];
    }
}

@end
