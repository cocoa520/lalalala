//
//  IMBBaseDatabase.m
//  MediaTrans
//
//  Created by Pallas on 12/16/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBBaseDatabase.h"
#import "IMBiTunesCDBRoot.h"

@implementation IMBBaseDatabase
@synthesize IPod = iPod;
@synthesize version = _version;

#pragma mark - 初始化和释放方法
-(id)init{
    self = [super init];
    if (self) {
        //初始化对象的值
    }
    return self;
}

-(void)dealloc{
    //执行释放的值
    [super dealloc];
}

#pragma mark - 实现声明方法
-(void)readDatabase:(IMBBaseDatabaseElement *)root {
    NSString *parseFilePath = [self getParseFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:parseFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:parseFilePath error:nil];
    }
    [[iPod fileSystem] copyRemoteFile:databaseFilePath toLocalFile:parseFilePath];
    reader = [NSData dataWithContentsOfFile:parseFilePath];
    @try {
        [root read:iPod reader:reader currPosition:0];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        [self cleanParseFile:parseFilePath];
    }
}

- (void)writeDatabase:(IMBBaseDatabaseElement*)root {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *saveFilePath = [self getParseFilePath];
    NSMutableData *writer = [[NSMutableData alloc] init];
    [root write:writer];
    [writer writeToFile:saveFilePath atomically:YES];
    [self doActionOnWriteDatabase:saveFilePath];
    if ([[fileManager attributesOfItemAtPath:saveFilePath error:nil] fileSize] > 0) {
        if ([[iPod fileSystem] fileExistsAtPath:databaseFilePath] == YES) {
            [[iPod fileSystem] unlink:databaseFilePath];
        }
        [[iPod fileSystem] copyLocalFile:saveFilePath toRemoteFile:databaseFilePath];
    }
    
    if ([fileManager fileExistsAtPath:saveFilePath] == YES) {
        [fileManager removeItemAtPath:saveFilePath error:nil];
    }
    [writer release];
    
    if ([root isKindOfClass:[IMBiTunesCDBRoot class]]) {
        if ([root respondsToSelector:@selector(iTunesDB_DatabaseWritten:parms:)] == YES) {
            [(IMBiTunesCDBRoot*)root iTunesDB_DatabaseWritten:self parms:nil];

        }
    }
}

-(void)parse{
    //子类实现
}

-(void)save{
    //子类实现
}

-(void)doActionOnWriteDatabase:(NSString*)filePath {
    //子类实现
}

- (NSString*)getParseFilePath{
    NSString *parseFilePath =nil;
    srandom((unsigned int)time((time_t *)NULL));
    parseFilePath = [[iPod.session sessionFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%qi", (long long)random()]];
    return parseFilePath;
}

- (void)cleanParseFile:(NSString*)parseFilePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:parseFilePath] == YES) {
        [fileManager removeItemAtPath:parseFilePath error:nil];
    }
}

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

@end
