//
//  IMBConfigPlist.m
//  iMobieTrans
//
//  Created by zhang yang on 13-5-11.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBConfig.h"
#import "IMBFileSystem.h"
#import "IMBSession.h"
#import "NSString+Category.h"

@implementation IMBConfig
@synthesize audioFormat = _audioFormat;
@synthesize audioNoConvert = _audioNoConvert;
@synthesize mediaNoConvert = _mediaNoConvert;
@synthesize quality = _quality;
@synthesize mediaFormat = _mediaFormat;
@synthesize autoSize = _autoSize;


- (id)initWithIPod:(IMBiPod*)iPod
{
    self = [super init];
    if (self) {
        _ipod = iPod;
        _mediaFormat = CvtMediaFormat_MPEG4;
        _autoSize = true;
        _audioFormat = CvtMediaFormat_AAC;
        _mediaNoConvert = false;
        _audioNoConvert = false;
        _quality = CvtMediaQuality_HighQuality;
        if (_ipod != nil)
        {
            _configDevicePath = [iPod.fileSystem.iPodControlPath stringByAppendingPathComponent:DeviceConfigPath];
            if (![_ipod.fileSystem fileExistsAtPath:_configDevicePath]) {
                [iPod.fileSystem mkDir:_configDevicePath];
            }
            _configDevicePath = [[_configDevicePath stringByAppendingPathComponent :CvtConfigName] retain];
            _configLocalPath = [_ipod.session.sessionFolderPath stringByAppendingPathComponent:DeviceConfigPath];
            NSFileManager *fm = [NSFileManager defaultManager];
            if (![fm fileExistsAtPath:_configLocalPath]) {
                [fm createDirectoryAtPath:_configLocalPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            _configLocalPath = [[_configLocalPath stringByAppendingPathComponent:CvtConfigName] retain];
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
    NSLog(@"convert file path is %@, file exsit %d", _configDevicePath,configExsit);
    if (configExsit) {
        [_ipod.fileSystem copyRemoteFile:_configDevicePath toLocalFile:_configLocalPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:_configLocalPath]) {
            NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:_configLocalPath];
            if (dic != nil && dic.count > 0) {
                NSDictionary *convertDic = [dic objectForKey:@"iMobieConvertConfig"];
                if (convertDic != nil && convertDic.count > 0) {
                    NSString *mediaFormat = [convertDic objectForKey:@"MediaFormat"];
                    if (mediaFormat != nil) {
                        if ([mediaFormat containsString:@"mpeg4" options:NSCaseInsensitiveSearch]) {
                            _mediaFormat = CvtMediaFormat_MPEG4;
                        } else if ([mediaFormat containsString:@"h264" options:NSCaseInsensitiveSearch]) {
                            _mediaFormat = CvtMediaFormat_H264;
                        } else if ([mediaFormat containsString:@"nomediaconvert" options:NSCaseInsensitiveSearch]) {
                            _mediaFormat = CvtMediaFormat_noMediaConvert;
                        }
                    }
                    if ([convertDic objectForKey:@"AutoSize"] != nil) {
                        _autoSize = [(NSNumber*)[convertDic objectForKey:@"AutoSize"] boolValue];
                    }
                    NSString *audioFormat = [convertDic objectForKey:@"AudioFormat"];
                    if (audioFormat != nil) {
                        if ([audioFormat containsString:@"aac" options:NSCaseInsensitiveSearch]) {
                            _audioFormat = CvtMediaFormat_AAC;
                        } else if ([audioFormat containsString:@"mp" options:NSCaseInsensitiveSearch]) {
                            _audioFormat = CvtMediaFormat_MP;
                        } else if ([audioFormat containsString:@"noaudiaconvert" options:NSCaseInsensitiveSearch]) {
                            _audioFormat = CvtMediaFormat_noAudiaConvert;
                        }
                    }
                    
                    NSString *qt = [convertDic objectForKey:@"Quality"];
                    if (qt != nil) {
                        if ([qt containsString:@"HighQuality" options:NSCaseInsensitiveSearch]) {
                            _quality = CvtMediaQuality_HighQuality;
                        } else if ([qt containsString:@"lowquality" options:NSCaseInsensitiveSearch]) {
                            _quality = CvtMediaQuality_LowQuality;
                        }
                    }
                    
                }
            }
        }
    }
    
}



- (NSString*) convertFormatEnumToString:(CvtMediaFormatEnum)format {
    switch (format) {
        case CvtMediaFormat_AAC:
            return @"AAC";
            break;
        case CvtMediaFormat_MP:
            return @"MP";
            break;
        case CvtMediaFormat_H264:
            return @"H264";
            break;
        case CvtMediaFormat_MPEG4:
            return @"MPEG4";
            break;
        case CvtMediaFormat_noAudiaConvert:
            return @"noAudiaConvert";
            break;
        case CvtMediaFormat_noMediaConvert:
            return @"noMediaConvert";
            break;
        case CvtMediaFormat_Unknown:
            return @"Unknown";
            break;
        default:
            return @"Unknown";
            break;
    }
}


- (void) saveToDevice {
    [self createConfigFile:_mediaFormat AutoSize:_autoSize AudioFmt:_audioFormat Qt:_quality];
}
- (void) createConfigFile:(CvtMediaFormatEnum)converFormat AutoSize:(BOOL)autoSize AudioFmt:(CvtMediaFormatEnum)audioFormat Qt:(CvtQualityTypeEnum)qt {
    NSMutableDictionary *cvtConfigDic = [[NSMutableDictionary alloc] init];
    [cvtConfigDic setObject:[self convertFormatEnumToString:converFormat] forKey:@"MediaFormat"];
    [cvtConfigDic setObject:[NSNumber numberWithBool:autoSize] forKey:@"AutoSize"];
    [cvtConfigDic setObject:[self convertFormatEnumToString:audioFormat] forKey:@"AudioFormat"];
    if (qt == CvtMediaQuality_HighQuality) {
        [cvtConfigDic setObject:@"HighQuality" forKey:@"Quality"];
    } else {
        [cvtConfigDic setObject:@"LowQuality" forKey:@"Quality"];
    }
    NSMutableDictionary *plistDic = [[NSMutableDictionary alloc] init];
    [plistDic setObject:cvtConfigDic forKey:@"iMobieConvertConfig"];
    if (_ipod != nil) {
        [plistDic writeToFile:_configLocalPath atomically:YES];
        if ([_ipod.fileSystem fileExistsAtPath:_configDevicePath]) {
            [_ipod.fileSystem unlink:_configDevicePath];
        }
        [_ipod.fileSystem copyLocalFile:_configLocalPath toRemoteFile:_configDevicePath];
    }
    [cvtConfigDic release];
    [plistDic release];
    
}


@end
