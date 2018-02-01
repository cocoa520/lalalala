//
//  IMBSyncAppBuilder.m
//  iMobieTrans
//
//  Created by iMobie on 8/21/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBSyncAppBuilder.h"
#import "IMBAppSyncModel.h"
#import "TempHelper.h"
#import "MediaHelper.h"
#define APPSYNCPATH @"/PublicStaging/ApplicationSync/"
#define APPROOTPATH @"/PublicStaging"

@implementation IMBSyncAppBuilder
@synthesize appSyncPath = _appSyncPath;
@synthesize sbIconStatePath = _sbIconStatePath;
@synthesize operation = _operation;

- (id)init{
    if (self = [super init]) {
//        _logManager = [IMBLogManager singleton];
        _appSyncPath = @"/PublicStaging/ApplicationSync/";
    }
    return self;
}

+ (IMBSyncAppBuilder*)singletone{
    static IMBSyncAppBuilder *token = nil;
    @synchronized(self){
        token = [[IMBSyncAppBuilder alloc] init];
    }
    return token;
}

- (NSString *)operationString{
    switch (_operation) {
        case Install:
            return @"install";
            break;
        case Remove:
            return @"remove";
            break;
        default:
            break;
    }
}

- (BOOL)createAppSyncPlist:(IMBiPod *)ipod appSyncs:(NSArray *)appSyncs appSyncPath:(NSString *)appSyncPath appIconStatePath:(NSString *)appIconStatePath{
    if (_ipod != nil) {
        [_ipod release];
        _ipod = nil;
    }
    _ipod = [ipod retain];
    BOOL result =false;
    NSFileManager *fileManger = [NSFileManager defaultManager];
    NSMutableArray *appDics = [[NSMutableArray alloc] init];
    for (IMBAppSyncModel *item in appSyncs) {
        NSMutableDictionary *appDic = [[NSMutableDictionary alloc] init];
        [appDic setObject:item.identifier forKey:@"identifier"];
        [appDic setObject:item.appName forKey:@"name"];
        [appDic setObject:[self operationString] forKey:@"operation"];
        [appDic setObject:item.appVersion forKey:@"version"];
        [appDics addObject:appDic];
        [appDic release];
    }
    if ([fileManger fileExistsAtPath:appSyncPath]) {
        [fileManger removeItemAtPath:appSyncPath error:nil];
    }
    NSString *nErr = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:appDics format:NSPropertyListBinaryFormat_v1_0 errorDescription:&nErr];
    result = [plistData writeToFile:appSyncPath atomically:YES];
    
    if (nErr.length > 0) {
//        [_logManager writeErrorLog:[NSString stringWithFormat:@"write book data to plist error:%@",nErr]];
        result = FALSE;
    }
    
    if (result) {
        if ([MediaHelper stringIsNilOrEmpty:_sbIconStatePath] || ![fileManger fileExistsAtPath:_sbIconStatePath]) {
            NSString *appTemp = [TempHelper getAppCachePathInPath:_ipod.session.sessionFolderPath];
            _sbIconStatePath = [IMBSyncAppBuilder tempPathOfIconState:appTemp inIpod:ipod];
        }
        result = [self appendAppIconStatePlist:appSyncs iconStatePath:appIconStatePath];
    }
    else{
//        [_logManager writeErrorLog:@"Create AppSync Plist Error"];
    }
    
    [appDics release];
    return result;
}

+ (NSString *)tempPathOfIconState:(NSString*)localFolderPath inIpod:(IMBiPod *)ipod{
    BOOL result = false;
    AMSpringboardServices *springboard = [[ipod.deviceHandle newAMSpringboardServices] retain];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if (![fileManger fileExistsAtPath:localFolderPath]){
        [fileManger createDirectoryAtPath:localFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [localFolderPath stringByAppendingPathComponent:@"SpringboardIconState.plist"];
    if ([fileManger fileExistsAtPath:filePath]) {
        NSError *error;
        [fileManger removeItemAtPath:filePath error:&error];
        if (error != nil) {
            return nil;
        }
    }
    if (springboard != nil) {
        NSDictionary *iconStateDic = [springboard getIconState];
        NSString *nErr = nil;
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:iconStateDic format:NSPropertyListBinaryFormat_v1_0 errorDescription:&nErr];
        result = [plistData writeToFile:filePath atomically:YES];
        
        if (nErr.length > 0) {
//            IMBLogManager *logManager = [IMBLogManager singleton];
//            [logManager writeErrorLog:[NSString stringWithFormat:@"write book data to plist error:%@",nErr]];
        }
        
    }
    [springboard release];
    springboard = nil;
    return filePath;
}

- (BOOL)appendAppIconStatePlist:(NSArray *)appSyncs iconStatePath:(NSString *)appIconStatePath{
    BOOL result = false;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *appObjects = [NSArray arrayWithContentsOfFile:_sbIconStatePath];
    if (appObjects != nil && [appObjects isKindOfClass:[NSArray class]]) {
        NSMutableArray *displayList = [appObjects mutableCopy];
        if (displayList.count > 0) {
            NSMutableArray *arrayObjects = [[displayList lastObject] mutableCopy];
            [displayList replaceObjectAtIndex:[displayList count]-1 withObject:arrayObjects];
            if (arrayObjects.count > 0) {
                NSMutableArray *lastArray = [[arrayObjects lastObject] mutableCopy];
                [arrayObjects replaceObjectAtIndex:[arrayObjects count]-1 withObject:lastArray];
                if (lastArray.count > 0) {
                    if (lastArray.count > 4) {
                        NSMutableArray *newRowApp = [NSMutableArray new];
                        for (IMBAppSyncModel *item in appSyncs) {
                            NSMutableDictionary *dictItem = [NSMutableDictionary dictionary];
                            [dictItem setObject:item.identifier forKey:@"displayIdentifier"];
                            [dictItem setObject:item.appName forKey:@"displayName"];
                            [newRowApp addObject:dictItem];
                        }
                        [arrayObjects addObject:newRowApp];
                    }
                    else{
                        for (IMBAppSyncModel *item in appSyncs) {
                            NSMutableDictionary *dictItem = [NSMutableDictionary dictionary];
                            [dictItem setObject:item.identifier forKey:@"displayIdentifer"];
                            [dictItem setObject:item.appName forKey:@"displayName"];
                            [lastArray addObject:dictItem];
                        }
                    }
                }
                [lastArray release];
            }
            [arrayObjects release];
        }
        NSError *error = nil;
        if ([fm fileExistsAtPath:appIconStatePath]) {
            [fm removeItemAtPath:appIconStatePath error:&error];
        }
        
        NSString *plistErr;
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:displayList format:NSPropertyListBinaryFormat_v1_0 errorDescription:&plistErr];
        result = YES;
        result = [plistData writeToFile:appIconStatePath atomically:YES];
        if (plistErr.length > 0) {
            result = FALSE;
        }
        [displayList release];
    }
    if (result) {
        [self copyAppFileToDevice:appSyncs];
    }
    return result;
}

- (void)copyAppFileToDevice:(NSArray *)appSyncs{
    NSFileManager *fm = [NSFileManager defaultManager];
    for (IMBAppSyncModel *item in appSyncs) {
        NSString *appSync = [_appSyncPath stringByAppendingString:item.identifier];
        if (![_ipod.fileSystem fileExistsAtPath:APPROOTPATH]) {
            [_ipod.fileSystem mkDir:APPROOTPATH];
        }
        if (![_ipod.fileSystem fileExistsAtPath:APPSYNCPATH]) {
            [_ipod.fileSystem mkDir:APPSYNCPATH];
        }
        if (![_ipod.fileSystem fileExistsAtPath:appSync]) {
            [_ipod.fileSystem mkDir:appSync];
        }
        if ([fm fileExistsAtPath:item.appCachePath]) {
            NSError *error = nil;
            NSArray *items = [fm subpathsOfDirectoryAtPath:item.appCachePath error:&error];
            if (error != nil) {
                NSLog(@"error:%@",error);
            }
            for (NSString *path in items) {
                if (![_ipod.fileSystem fileExistsAtPath:appSync]) {
                    [_ipod.fileSystem mkDir:appSync];
                }
                path = [item.appCachePath stringByAppendingPathComponent:path];
                NSString *fileName = [path lastPathComponent];
                NSString *targetPath = [appSync stringByAppendingPathComponent:fileName];
                [_ipod.fileSystem copyLocalFile:path toRemoteFile:targetPath];
            }
        }
    }
}

- (NSString *)getAppCachePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tmpPath = @"";
    if (_ipod != nil) {
        tmpPath = _ipod.session.sessionFolderPath;
        if (![fileManager fileExistsAtPath:tmpPath]) {
            [fileManager createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *appTmpPath = [tmpPath stringByAppendingPathComponent:@"Application"];
        if (![fileManager fileExistsAtPath:appTmpPath]) {
            [fileManager createDirectoryAtPath:appTmpPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        return appTmpPath;
    }
    return tmpPath;
}

- (void)dealloc{
    if (_appSyncPath != nil) {
        [_appSyncPath release];
        _appSyncPath = nil;
    }
    if (_sbIconStatePath != nil) {
        [_sbIconStatePath release];
        _sbIconStatePath = nil;
    }
    if (_ipod != nil) {
        [_ipod release];
        _ipod = nil;
    }
    [super dealloc];
}

@end
