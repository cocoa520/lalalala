//
//  IMBBaseCommunicate.m
//  
//
//  Created by ding ming on 17/3/17.
//
//

#import "IMBBaseCommunicate.h"

@implementation IMBBaseCommunicate
@synthesize transDelegate = _transDelegate;
@synthesize reslutEntity = _reslutEntity;
@synthesize attachReslutEntity = _attachReslutEntity;
@synthesize dbPath = _dbPath;
@synthesize isStop = _isStop;
@synthesize isPause = _isPause;
@synthesize condition = _condition;
@synthesize isScanAttachment = _isScanAttachment;
@synthesize version = _version;

@synthesize currentRealStopName = _currentRealStopName;

- (id)initWithSerialNumber:(NSString *)serialNumber {
    if (self = [super init]) {
        _serialNumber = serialNumber;
        _reslutEntity = [[IMBResultEntity alloc] init];
        _fileManager = [NSFileManager defaultManager];
        _loghandle = [IMBLogManager singleton];
    }
    return self;
}

- (void)dealloc
{
    if (_reslutEntity != nil) {
        [_reslutEntity release];
        _reslutEntity = nil;
    }
    if (_attachReslutEntity != nil) {
        [_attachReslutEntity release];
        _attachReslutEntity = nil;
    }
    if (_dbPath != nil) {
        [_dbPath release];
        _dbPath = nil;
    }
    if (_currentRealStopName) {
        [_currentRealStopName release];
        _currentRealStopName = nil;
    }
    [_condition release],_condition = nil;
    [super dealloc];
}

- (void)setDbPath:(NSString *)dbPath {
    if (_dbPath != nil) {
        [_dbPath release];
        _dbPath = nil;
    }
    _dbPath = [dbPath retain];
}

- (NSString *)getDatabasesPath {
    return nil;
}

- (BOOL)openDBConnection {
    BOOL ret = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![StringHelper stringIsNilOrEmpty:_dbPath] && [fm fileExistsAtPath:_dbPath]) {
        _fmDB = [[FMDatabase databaseWithPath:_dbPath] retain];
        if ([_fmDB open]) {
            [_fmDB setShouldCacheStatements:YES];
            [_fmDB setTraceExecution:NO];
            ret = YES;
        } else {
            [_fmDB release];
            _fmDB = nil;
        }
    }
    return ret;
}

- (void)closeDBConnection {
    if (_fmDB != nil) {
        [_fmDB close];
        [_fmDB release];
        _fmDB = nil;
    }
}

#pragma mark - 公共方法
- (NSString *)createParamsjJsonCommand:(CommunicateCategoryEnum)category Operate:(OperateEnum)operate ParamDic:(NSDictionary *)paramDic {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[self CommunicateCategoryEnumToString:category], @"Category", [self OperateEnumToString:operate], @"Action", paramDic, @"Params", nil];
    return [IMBFileHelper dictionaryToJson:dic];
}

- (NSString *)CommunicateCategoryEnumToString:(CommunicateCategoryEnum)category {
    switch (category) {
        case RINGTONE:
            return @"RINGTONE";
        case AUDIO:
            return @"AUDIO";
        case DEVICE:
            return @"DEVICE";
        case VIDEO:
            return @"VIDEO";
        case IMAGE:
            return @"IMAGE";
        case CALLLOG:
            return @"CALLLOG";
        case CALENDAR:
            return @"CALENDAR";
        case CONTACT:
            return @"CONTACT";
        case SMS:
            return @"SMS";
        case DOUCMENT:
            return @"DOUCMENT";
        case RequestPermission:
            return @"RequestPermission";
        case ScanData:
            return @"ScanData";
        case RecoveryData:
            return @"RecoveryData";
        case LINE:
            return @"LINE";
        case APK:
            return @"APK";
        case SETAPKPERMISSION:
            return @"SETAPKPERMISSION";
        default:
            return @"";
    }
    return @"";
}

- (NSString *)OperateEnumToString:(OperateEnum)operate {
    switch (operate) {
        case IMPORT:
            return @"IMPORT";
        case EXPORT:
            return @"EXPORT";
        case QUERY:
            return @"QUERY";
        case DELETE:
            return @"DELETE";
        case SYNC:
            return @"SYNC";
        case THUMBNAIL:
            return @"THUMBNAIL";
        case STORAGE:
            return @"STORAGE";
        case SHAKEHAND:
            return @"SHAKEHAND";
        case SETSMSAPP:
            return @"SETSMSAPP";
        case CHECKSMSDEFAPP:
            return @"CHECKSMSDEFAPP";
        case COMPLETE:
            return @"COMPLETE";
        case START:
            return @"START";
        case ATTACHMENT:
            return @"ATTACHMENT";
        case ROOTSTATE:
            return @"ROOTSTATE";
        case SWITCH:
            return @"SWITCH";
        default:
            return @"";
    }
    return @"";
}

- (void)getLocalFileTotalSize:(NSArray *)array {
    for (NSString *path in array) {
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:path]) {
            NSDictionary *fileDic = [fm attributesOfItemAtPath:path error:nil];
            long long fileSize = [[fileDic objectForKey:NSFileSize] longLongValue];
            _totalSize += fileSize;
        }
    }
}

#pragma mark - Abstract Method
- (int)queryDetailContent {
    return 0;
}

- (int)exportContent:(NSString *)targetPath ContentList:(NSArray *)exportArr {
    return 0;
}

- (int)exportContent:(NSString *)targetPath ContentList:(NSArray *)exportArr exportType:(NSString *)type{
    return 0;
}

- (int)exportMessageAttachment:(NSString *)targetPath exportArray:(NSArray *)exportArray {
    return 0;
}

- (int)importContent:(NSArray *)importArr {
    return 0;
}

- (int)deleteContent:(NSArray *)deleteArr {
    return 0;
}

#pragma mark - HTML
- (BOOL)writeToMsgFileWithPageTitle:(NSString*)pageTitle exportPath:(NSString *)exportPath Entity:(id)entity{
    NSString *exportFilePath = nil;
    exportFilePath = [exportPath stringByAppendingPathComponent:pageTitle];
    if ([_fileManager fileExistsAtPath:exportFilePath]) {
        exportFilePath = [IMBFileHelper getFilePathAlias:exportFilePath];
    }
    [_fileManager createFileAtPath:exportFilePath contents:nil attributes:nil];
    NSFileHandle *fileHandle = nil;
    if ([_fileManager fileExistsAtPath:exportFilePath]) {
        fileHandle = [NSFileHandle fileHandleForWritingAtPath:exportFilePath];
        [fileHandle truncateFileAtOffset:0];
        NSData *data = [@"<!DOCTYPE html><html>" dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandle writeData:data];
        @autoreleasepool {
            data = [self createHtmHeader:pageTitle];
            if (data == nil) {
                [fileHandle closeFile];
                [_fileManager removeItemAtPath:exportFilePath error:nil];
                return NO;
            }
            [fileHandle writeData:data];
        }
        
        @autoreleasepool {
            data = [self createHtmBody:entity];
            if (data == nil) {
                [fileHandle closeFile];
                [_fileManager removeItemAtPath:exportFilePath error:nil];
                return NO;
            }
            [fileHandle writeData:data];
        }
        
        @autoreleasepool {
            data = [self createHtmFooter];
            if (data == nil) {
                [fileHandle closeFile];
                [_fileManager removeItemAtPath:exportFilePath error:nil];
                return NO;
            }
            [fileHandle writeData:data];
        }
        data = [@"</html>" dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandle writeData:data];
        [fileHandle closeFile];
        return YES;
    }
    return NO;
}

- (void)timerAction:(NSTimer *)timer {
    GCDAsyncSocket *scoket = timer.userInfo;
    if (scoket != nil) {
        [scoket disconnect];
    }
}

- (NSData*)createHtmHeader:(NSString*)title {
    return nil;
}

- (NSData*)createHtmFooter {
    return nil;
}

- (NSData*)createHtmBody:(id)entity {
    return nil;
}

@end
