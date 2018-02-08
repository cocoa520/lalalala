//
//  IMBPhotoExportSettingConfig.m
//  AnyTrans
//
//  Created by long on 10/16/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBPhotoExportSettingConfig.h"
#import "TempHelper.h"
#import "StringHelper.h"
@implementation IMBPhotoExportSettingConfig
@synthesize exportPath = _exportPath;
@synthesize isHEICState = _isHEICState;
@synthesize chooseLivePhotoExportType = _chooseLivePhotoExportType;
@synthesize sureSaveCheckBtnState = _sureSaveCheckBtnState;
@synthesize isCreadPhotoDate = _isCreadPhotoDate;
+ (IMBPhotoExportSettingConfig*)singleton {
    static IMBPhotoExportSettingConfig *_singleton = nil;
    @synchronized(self) {
        if (_singleton == nil) {
            _singleton = [[IMBPhotoExportSettingConfig alloc] init];
        }
    }
    return _singleton;
}

- (id)init {
    self = [super init];
    if (self) {
        _chooseLivePhotoExportType = 6;
        _isHEICState = NO;
        _sureSaveCheckBtnState = YES;
        _isCreadPhotoDate = NO;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _exportPath = [[paths objectAtIndex:0] retain];
        _configLocalPath = [[[TempHelper getAppiMobieConfigPath] stringByAppendingPathComponent:@"PhotoSettingConfig.plist"] retain];
        _fm = [NSFileManager defaultManager];
        if ([_fm fileExistsAtPath:_configLocalPath]) {
            [self parseConfigFile];
        }
    }
    return self;
}

- (void)parseConfigFile{
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:_configLocalPath];
    if (dic != nil && dic.count > 0) {
        NSArray *allKeys = [dic allKeys];
        if (allKeys.count > 0) {
            if ([allKeys containsObject:@"LivePhoto"]) {
                NSNumber *ctType = [dic objectForKey:@"LivePhoto"];
                _chooseLivePhotoExportType = [ctType intValue];
            }
            if ([allKeys containsObject:@"PhotoHEICType"]) {
                NSNumber *ctType = [dic objectForKey:@"PhotoHEICType"];
                _isHEICState = [ctType intValue];
            }
            if ([allKeys containsObject:@"sureSaveState"]) {
                NSNumber *ctType = [dic objectForKey:@"sureSaveState"];
                _sureSaveCheckBtnState = [ctType intValue];
            }
            if ([allKeys containsObject:@"sureSaveState"]) {
                NSNumber *ctType = [dic objectForKey:@"sureSaveState"];
                _sureSaveCheckBtnState = [ctType intValue];
            }
            if ([allKeys containsObject:@"PhotoExportPath"]) {
                NSString *ctType = [dic objectForKey:@"PhotoExportPath"];
                if (_exportPath !=nil) {
                    [_exportPath release];
                    _exportPath = nil;
                }
                _exportPath = [ctType retain] ;
            }
            if ([allKeys containsObject:@"isCreadPhotoDate"]) {
                NSNumber *ctType = [dic objectForKey:@"isCreadPhotoDate"];
                _isCreadPhotoDate = [ctType intValue];
            }
        }
    }
    [dic release];
    dic = nil;
}

- (void)saveData{
    NSMutableDictionary *cvtConfigDic = [[NSMutableDictionary alloc] init];
    [cvtConfigDic setObject:[NSNumber numberWithDouble:_chooseLivePhotoExportType] forKey:@"LivePhoto"];
    [cvtConfigDic setObject:[NSNumber numberWithDouble:_isHEICState] forKey:@"PhotoHEICType"];
    [cvtConfigDic setObject:[NSNumber numberWithDouble:_sureSaveCheckBtnState] forKey:@"sureSaveState"];
    [cvtConfigDic setObject:_exportPath forKey:@"PhotoExportPath"];
    [cvtConfigDic setObject:[NSNumber numberWithDouble:_isCreadPhotoDate] forKey:@"isCreadPhotoDate"];
    [cvtConfigDic writeToFile:_configLocalPath atomically:YES];
    [cvtConfigDic release];
    cvtConfigDic = nil;
}

- (void)dealloc{
    if (_exportPath != nil){
        [_exportPath release];
        _exportPath = nil;
    }
    [super dealloc];
}

@end
