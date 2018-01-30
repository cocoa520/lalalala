//
//  IMBAppConfig.m
//  iMobieTrans
//
//  Created by zhang yang on 13-5-16.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBAppConfig.h"
#import "IMBFileSystem.h"
#import "IMBSession.h"
#import "NSString+Category.h"

//TODO 没有保存plist的方法
@implementation IMBAppConfig
@synthesize appExportToDeviceType = _appExportToDeviceType;
@synthesize appExportToiTunesType = _appExportToiTunesType;
@synthesize appExportToMacType = _appExportToMacType;
@synthesize isAppDowngrade = _isAppDowngrade;
@synthesize isAppUpgrade = _isAppUpgrade;
@synthesize isAppImportJustData = _isAppImportJustData;

- (id)initWithIPod:(IMBiPod*)iPod
{
    self = [super init];
    if (self) {
        _ipod = iPod;
        _appExportToiTunesType = AppTransferType_All;
        _appExportToMacType = AppTransferType_All;
        _appExportToDeviceType = AppTransferType_All;
        _isAppImportJustData = true;
        _isAppUpgrade = true;
        _isAppDowngrade = false;
        
        if (_ipod != nil)
        {
            
            _configDevicePath = [iPod.fileSystem.iPodControlPath stringByAppendingPathComponent:AppDeviceConfigPath];
            //NSLog(@"_configDevicePath %@", _configLocalPath);
            if (![_ipod.fileSystem fileExistsAtPath:_configDevicePath]) {
                [iPod.fileSystem mkDir:_configDevicePath];
                NSLog(@"make dir ");

            }
            //NSLog(@"_configDevicePath1");
            _configDevicePath = [[_configDevicePath stringByAppendingPathComponent:AppConfigName] retain];
            //NSLog(@"_configDevicePath2");
            _configLocalPath = [_ipod.session.sessionFolderPath stringByAppendingPathComponent:AppDeviceConfigPath];
            //NSLog(@"_configLocalPath %@", _configLocalPath);
            //NSLog(@"_configDevicePath %@", _configDevicePath);

            NSFileManager *fm = [NSFileManager defaultManager];
            if (![fm fileExistsAtPath:_configLocalPath]) {
                [fm createDirectoryAtPath:_configLocalPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            _configLocalPath = [[_configLocalPath stringByAppendingPathComponent:AppConfigName] retain];
            [self parseConfigFile];
        }
    }
    return self;
}

- (void)dealloc
{
    if (_configDevicePath != nil) {
        [_configDevicePath release];
        _configDevicePath = nil;
    }
    if (_configLocalPath != nil) {
        [_configLocalPath release];
        _configLocalPath = nil;
    }
    
    [super dealloc];
}

- (void) parseConfigFile {
    bool configExsit = false;
    configExsit = [_ipod.fileSystem fileExistsAtPath:_configDevicePath];
    
    if (configExsit) {
        [_ipod.fileSystem copyRemoteFile:_configDevicePath toLocalFile:_configLocalPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:_configLocalPath]) {
            NSLog(@"_configLocalPath2 %@", _configLocalPath);
            NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:_configLocalPath];
            if (dic != nil && dic.count > 0) {
                NSDictionary *convertDic = [dic objectForKey:@"iMobieAppConfig"];
                if (convertDic != nil && convertDic.count > 0) {
                    NSString *toDeviceStr = [convertDic objectForKey:@"AppExportToDeviceType"];
                    if (toDeviceStr != nil) {
                        _appExportToDeviceType = [self convertAppTransferTypeToEnum:toDeviceStr];
                    }
                    NSString *toITunesStr = [convertDic objectForKey:@"AppExportToiTunesType"];
                    if (toITunesStr != nil) {
                        _appExportToiTunesType = [self convertAppTransferTypeToEnum:toITunesStr];
                    }
                    NSString *toMacStr = [convertDic objectForKey:@"AppExportToPCType"];
                    if (toMacStr != nil) {
                        _appExportToMacType = [self convertAppTransferTypeToEnum:toMacStr];
                    }
                    
                    
                    /*
                     <key>IsAppDowngrade</key>
                     <string>False</string>
                     <key>IsAppImportJustData</key>
                     <string>False</string>
                     <key>IsAppUpgrade</key>
                     <string>False</string>
                    */
                    NSString *isAppDowngrade = [convertDic objectForKey:@"IsAppDowngrade"];
                    if (isAppDowngrade != nil && [isAppDowngrade containsString:@"True" options:NSCaseInsensitiveSearch]) {
                        _isAppDowngrade = true;
                    } else {
                        _isAppDowngrade = false;
                    }
                    NSString *isAppImportJustData = [convertDic objectForKey:@"IsAppImportJustData"];
                    if (isAppImportJustData != nil && [isAppImportJustData containsString:@"True" options:NSCaseInsensitiveSearch]) {
                        _isAppImportJustData = true;
                    } else {
                        _isAppImportJustData = false;
                    }
                    NSString *isAppUpgrade = [convertDic objectForKey:@"IsAppUpgrade"];
                    if (isAppUpgrade != nil && [isAppUpgrade containsString:@"True" options:NSCaseInsensitiveSearch]) {
                        _isAppUpgrade = true;
                    } else {
                        _isAppUpgrade = false;
                    }
                    
                }
            }
        }
    }
    
}

- (IMBAppTransferTypeEnum) convertAppTransferTypeToEnum:(NSString*)type {
    if ([type containsString:@"All" options:NSCaseInsensitiveSearch]) {
        return AppTransferType_All;
    } else if ([type containsString:@"ApplicationOnly" options:NSCaseInsensitiveSearch]) {
        return AppTransferType_ApplicationOnly;
    } else if ([type containsString:@"DocumentsOnly" options:NSCaseInsensitiveSearch]) {
        return AppTransferType_DocumentsOnly;
    } else {
        return AppTransferType_All;
    }
}

- (NSString*) convertAppTransferEnumToString:(IMBAppTransferTypeEnum)type {
    switch (type) {
        case AppTransferType_All:
            return @"All";
        case AppTransferType_ApplicationOnly:
            return @"ApplicationOnly";
        case AppTransferType_DocumentsOnly:
            return @"DocumentsOnly";
        default:
            return @"All";
    }
}

- (void) saveToDevice {
    [self createConfigFile:_appExportToiTunesType ExToMac:_appExportToMacType ExToDevice:_appExportToDeviceType IsImportJustData:_isAppImportJustData IsUpgrade:_isAppUpgrade IsDowngrade:_isAppDowngrade];
}

- (void) createConfigFile:(IMBAppTransferTypeEnum) exToiTunes ExToMac:(IMBAppTransferTypeEnum)exToMac ExToDevice:(IMBAppTransferTypeEnum)exToDevice IsImportJustData:(bool)isImportJustData IsUpgrade:(bool)isUpgrade IsDowngrade:(bool)isDowngrade {
    
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc] init];
    [configDic setObject:[self convertAppTransferEnumToString:exToDevice] forKey:@"AppExportToDeviceType"];
    [configDic setObject:[self convertAppTransferEnumToString:exToMac] forKey:@"AppExportToPCType"];
    [configDic setObject:[self convertAppTransferEnumToString:exToiTunes] forKey:@"AppExportToiTunesType"];
                 
    if (isImportJustData) {
        [configDic setObject:@"True" forKey:@"IsAppImportJustData"];
    } else {
        [configDic setObject:@"False" forKey:@"IsAppImportJustData"];
    }
    
    if (isUpgrade) {
        [configDic setObject:@"True" forKey:@"IsAppUpgrade"];
    } else {
        [configDic setObject:@"False" forKey:@"IsAppUpgrade"];
    }
    
    if (isDowngrade) {
        [configDic setObject:@"True" forKey:@"IsAppDowngrade"];
    } else {
        [configDic setObject:@"False" forKey:@"IsAppDowngrade"];
    }
    
    NSMutableDictionary *plistDic = [[NSMutableDictionary alloc] init];
    [plistDic setObject:configDic forKey:@"iMobieAppConfig"];
    if (_ipod != nil) {
        NSLog(@"_configLocalPath %@", _configLocalPath);
        [plistDic writeToFile:_configLocalPath atomically:YES];
        if ([_ipod.fileSystem fileExistsAtPath:_configDevicePath]) {
            [_ipod.fileSystem unlink:_configDevicePath];
        }
        [_ipod.fileSystem copyLocalFile:_configLocalPath toRemoteFile:_configDevicePath];
    }
    [configDic release];
    [plistDic release];
}

@end
