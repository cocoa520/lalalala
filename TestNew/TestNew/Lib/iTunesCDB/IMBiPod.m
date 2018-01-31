//
//  IMBiPod.m
//  AnyTrans
//
//  Created by iMobie on 7/19/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBiPod.h"
//#import "IMBUSBDeviceInfo.h"
//#import "IMBUSBFileSystem.h"
#import "IMBAMDeviceInfo.h"
#import "IMBAMFileSystem.h"
#import "IMBSession.h"
#import "IMBInformation.h"
#import "IMBInformationManager.h"
//#import "IMBConfig.h"
//#import "IMBAppConfig.h"
//#import "IMBExportSetting.h"

@implementation IMBiPod
@synthesize deviceHandle = _deviceHandle;
@synthesize transCodingConfig = _transCodingConfig;
@synthesize appConfig = _appConfig;
@synthesize exportSetting = _exportSetting;
@synthesize deviceInfo = _deviceInfo;
@synthesize fileSystem = _fileSystem;
@synthesize session = _session;
@synthesize uniqueKey = _uniqueKey;
@synthesize mediaDBPath = _mediaDBPath;
@synthesize mediaDamage = _mediaDamage;
@synthesize infoLoadFinished = _infoLoadFinished;
@synthesize beingSynchronized = _beingSynchronized;
@synthesize isAndroidToiOS = _isAndroidToiOS;
- (id)initWithDevice:(id)device {
    self = [super init];
    if (self) {
//        _logHandle = [IMBLogManager singleton];
        if ([device isKindOfClass:[AMDevice class]] == TRUE) {
            _deviceHandle = [device retain];
            _deviceInfo = [[IMBAMDeviceInfo alloc] initWithDevice:_deviceHandle];
            _fileSystem = [[IMBAMFileSystem alloc] initWithDevice:_deviceHandle];
        } else {
            _deviceHandle = [device retain];
//            _deviceInfo = [[IMBUSBDeviceInfo alloc] initWithDevice:_deviceHandle];
//            _fileSystem = [[IMBUSBFileSystem alloc] initWithDevice:_deviceHandle];
        }
        _session = [[IMBSession alloc] initWithIPod:self];
    }
    return self;
}

- (void)dealloc {
    if (_deviceHandle != nil) {
        [_deviceHandle release];
        _deviceHandle = nil;
    }
    if (_appConfig != nil) {
        [_appConfig release];
        _appConfig = nil;
    }
    if (_transCodingConfig != nil) {
        [_transCodingConfig release];
        _transCodingConfig = nil;
    }
    if (_exportSetting != nil) {
        [_exportSetting release];
        _exportSetting = nil;
    }
    if (_deviceInfo != nil) {
        [_deviceInfo release];
        _deviceInfo = nil;
    }
    if (_fileSystem != nil) {
        [_fileSystem release];
        _fileSystem = nil;
    }
    [_mediaDBPath release],_mediaDBPath = nil;
    [super dealloc];
}

- (void)startSync {
    [_fileSystem startSync:YES];
}

- (void)endSync {
    [_fileSystem endSync];
}

- (void)saveChanges
{
    //保存数据库
    IMBInformationManager *manager = [IMBInformationManager shareInstance];
    IMBInformation *infomation = [manager.informationDic objectForKey:_uniqueKey];
    [infomation saveChanges];
}

- (IMBPurchasesInfo *)purchasesInfo
{
    IMBInformationManager *manager = [IMBInformationManager shareInstance];
    IMBInformation *infomation = [manager.informationDic objectForKey:_uniqueKey];
    return infomation.purchasesInfo;
}

#pragma mark - 属性关联函数
- (IMBPlaylistList*)playlists {
    IMBInformationManager *manager = [IMBInformationManager shareInstance];
    IMBInformation *infomation = [manager.informationDic objectForKey:_uniqueKey];
    if (infomation) {
        return [infomation playlists];
    }else {
        return nil;
    }
}

- (IMBTracklist*)tracks {
    IMBInformationManager *manager = [IMBInformationManager shareInstance];
    IMBInformation *infomation = [manager.informationDic objectForKey:_uniqueKey];
    if (infomation) {
        return [infomation tracks];
    }else {
        return nil;
    }
}

- (NSArray*)getTrackArrayByMediaTypes:(NSArray*)mediaTypes {
    IMBInformationManager *manager = [IMBInformationManager shareInstance];
    IMBInformation *infomation = [manager.informationDic objectForKey:_uniqueKey];
    if (infomation) {
        return [infomation getTrackArrayByMediaTypes:mediaTypes];
    }else {
        return nil;
    }
}

- (NSArray*)playlistArray {
    IMBInformationManager *manager = [IMBInformationManager shareInstance];
    IMBInformation *infomation = [manager.informationDic objectForKey:_uniqueKey];
    if (infomation) {
        return [infomation playlistArray];
    }else {
        return nil;
    }
}

- (NSArray*)trackArray {
    IMBInformationManager *manager = [IMBInformationManager shareInstance];
    IMBInformation *infomation = [manager.informationDic objectForKey:_uniqueKey];
    if (infomation) {
        return [infomation trackArray];
    }else {
        return nil;
    }
}

- (IMBIDGenerator *)idGenerator {
    IMBInformationManager *manager = [IMBInformationManager shareInstance];
    IMBInformation *infomation = [manager.informationDic objectForKey:_uniqueKey];
    if (infomation) {
        return [infomation idGenerator];
    }else {
        return nil;
    }
}

- (IMBArtworkDB *)artworkDB {
    IMBInformationManager *manager = [IMBInformationManager shareInstance];
    IMBInformation *infomation = [manager.informationDic objectForKey:_uniqueKey];
    if (infomation) {
        return [infomation artworkDB];
    }else {
        return nil;
    }
}

- (IMBMusicDatabase *)mediaDatabase {
    IMBInformationManager *manager = [IMBInformationManager shareInstance];
    IMBInformation *infomation = [manager.informationDic objectForKey:_uniqueKey];
    if (infomation) {
        return [infomation mediaDatabase];
    }else {
        return nil;
    }
}

//- (IMBApplicationManager *)applicationManager
//{
//    IMBInformationManager *manager = [IMBInformationManager shareInstance];
//    IMBInformation *infomation = [manager.informationDic objectForKey:_uniqueKey];
//    if (infomation) {
//        return [infomation applicationManager];
//    }else {
//        return nil;
//    }
//}

//#pragma mark - 配置文件初始化以及取得函数
//-(IMBConfig*) transCodingConfig {
//    if (_transCodingConfig == nil) {
//        NSLog(@"init IMBConfig");
//        _transCodingConfig  = [[IMBConfig alloc] initWithIPod:self];
//    }
//    return _transCodingConfig;
//}
//
//-(IMBAppConfig*) appConfig {
//    if (_appConfig == nil) {
//        NSLog(@"init IMBAppConfig");
//        _appConfig  = [[IMBAppConfig alloc] initWithIPod:self];
//    }
//    return _appConfig;
//}
//
//- (IMBExportSetting *) exportSetting {
//    if (_exportSetting == nil) {
//        _exportSetting = [[IMBExportSetting alloc] initWithIPod:self];
//    }
//    return _exportSetting;
//}

@end
