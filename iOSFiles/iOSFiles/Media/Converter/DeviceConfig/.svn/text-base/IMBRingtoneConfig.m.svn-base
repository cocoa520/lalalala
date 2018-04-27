//
//  IMBRingtoneConfig.m
//  iMobieTrans
//
//  Created by zhang yang on 13-5-11.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBRingtoneConfig.h"
#import "TempHelper.h"
#import "NSString+Category.h"
@implementation IMBRingtoneConfig
@synthesize allSkip = _allSkip;
@synthesize convertSize = _convertSize;
@synthesize startSecond = _startSecond;
@synthesize exportPath = _exportPath;

+ (IMBRingtoneConfig*)singleton {
    static IMBRingtoneConfig *_singleton = nil;
    @synchronized(self) {
        if (_singleton == nil) {
            _singleton = [[IMBRingtoneConfig alloc] init];
        }
    }
    return _singleton;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
        _startSecond = 0;
        /// 转换的大小
        _convertSize = RT_Sec40;
        //下次不再提醒
        _allSkip = TRUE;
        //导出路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _exportPath = [[paths objectAtIndex:0] retain];
        
        _configLocalPath = [[[TempHelper getAppiMobieConfigPath] stringByAppendingPathComponent:RtCvtConfigName] retain];
        fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:_configLocalPath]) {
            [self parseConfigFile];
        }
    }
    return self;
}

- (void)applicationWillTerminate:(NSNotification*)notification {
    [self dealloc];
}

- (void)dealloc
{
    if (_exportPath != nil) {
        [_exportPath release];
        _exportPath = nil;
    }
    if (_configLocalPath != nil) {
        [_configLocalPath release];
        _configLocalPath = nil;
    }
    
    [super dealloc];
}

- (void) parseConfigFile {
    NSDictionary *convertDic = [[NSDictionary alloc] initWithContentsOfFile:_configLocalPath];
    if (convertDic != nil && convertDic.count > 0) {
        if ([convertDic.allKeys containsObject:@"RingtoneSize"]) {
            NSString *RingtoneSize = [convertDic objectForKey:@"RingtoneSize"];
            if ([RingtoneSize containsString:@"Sec25" options:NSCaseInsensitiveSearch]) {
                _convertSize = RT_Sec25;
            } else if ([RingtoneSize containsString:@"Sec40" options:NSCaseInsensitiveSearch]) {
                _convertSize = RT_Sec40;
            } else if ([RingtoneSize containsString:@"SecRest" options:NSCaseInsensitiveSearch]) {
                _convertSize = RT_SecRest;
            }
        }
        if ([convertDic.allKeys containsObject:@"StartTime"]) {
            _startSecond = [(NSNumber*)[convertDic objectForKey:@"StartTime"] intValue];
        }
        if ([convertDic.allKeys containsObject:@"AllSkip"]) {
            _allSkip = [(NSNumber*)[convertDic objectForKey:@"AllSkip"] boolValue];
        }
        if ([convertDic.allKeys containsObject:@"ExportPath"]) {
            if (_exportPath) {
                [_exportPath release];
                _exportPath = nil;
            }
            _exportPath = [[convertDic objectForKey:@"ExportPath"] retain];
        }
    }
    [convertDic release];
}



- (NSString*) convertRtSecsEnumToString:(CvtRingtoneSizeEnum)format {
    switch (format) {
        case RT_Sec25:
            return @"Sec25";
        case RT_Sec40:
            return @"Sec40";
        case RT_SecRest:
            return @"SecRest";
        default:
            return @"Sec40";
    }
}

- (void) saveToDevice {
    [self createConfigFile:_startSecond RingtoneSize:_convertSize IsSkip:_allSkip];
}

- (void) createConfigFile:(double)startSec RingtoneSize:(CvtRingtoneSizeEnum)rtSize IsSkip:(BOOL)isSkip {
    NSMutableDictionary *cvtConfigDic = [[NSMutableDictionary alloc] init];
    [cvtConfigDic setObject:[NSNumber numberWithDouble:startSec] forKey:@"StartTime"];
    [cvtConfigDic setObject:[self convertRtSecsEnumToString:rtSize] forKey:@"RingtoneSize"];
    [cvtConfigDic setObject:[NSNumber numberWithBool:isSkip] forKey:@"AllSkip"];
    [cvtConfigDic setObject:_exportPath forKey:@"ExportPath"];
    [cvtConfigDic writeToFile:_configLocalPath atomically:YES];
    [cvtConfigDic release];
}

@end
