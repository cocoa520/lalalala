//
//  IMBBaseTransfer.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-28.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBaseTransfer.h"
#import "IMBDeviceInfo.h"
#import "IMBFileSystem.h"
#import "StringHelper.h"
#import "DriveItem.h"
#include <sys/stat.h>
#import "NSString+Compare.h"
@implementation IMBBaseTransfer
@synthesize isAllExport = _isAllExport;
@synthesize percent = _percent;
@synthesize totalItem = _totalItem;
@synthesize isStop = _isStop;
@synthesize currItemIndex = _currItemIndex;
@synthesize isPause = _isPause;
@synthesize condition = _condition;
@synthesize isReminder = _isReminder;
- (void)setCondition:(NSCondition *)condition {
    if (_condition != nil) {
        [_condition release];
        _condition = nil;
    }
    _condition = [condition retain];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        _limitation = [OperationLImitation singleton];
        _loghandle = [IMBLogManager singleton];
        _fileManager = [NSFileManager defaultManager];
        _condition = [[NSCondition alloc] init];
        _isStop = NO;
        _isPause = NO;
        _totalItemCount = 0;
        _currItemIndex = 0;
        _failedCount = 0;
        _successCount = 0;
//        _transTotalSize = 0;
        _skipCount = 0;
        _totalSize = 0;
        _curSize = 0;
        _isAllExport = NO;
        _percent = 0;
        _totalItem = 1;
    }
    return self;
}

- (id)initWithIPodkey:(NSString *)ipodKey withDelegate:(id)delegate {
    if (self = [self init]) {
        _ipod = [[[IMBDeviceConnection singleton] getiPodByKey:ipodKey] retain];
        _transferDelegate = delegate;
    }
    return self;
}

#pragma mark - 导出磁盘文件初始化函数
- (id)initWithIPodkey:(NSString *)ipodKey exportTracks:(NSArray *)exportTracks exportFolder:(NSString *)exportFolder withDelegate:(id)delegate {
    self = [self initWithIPodkey:ipodKey withDelegate:delegate];
    if (self) {
        _exportTracks = [exportTracks retain];
        _exportPath = [exportFolder retain];
        _totalItemCount = (int)_exportTracks.count;
    }
    return self;
}
#pragma mark - 导出infomation文件初始化函数
- (id)initWithPath:(NSString *)exportPath exportTracks:(NSArray *)exportTracks withMode:(NSString *)mode withDelegate:(id)delegate {
    if (self = [self init]) {
        _exportPath = [exportPath retain];
        _transferDelegate = delegate;
        _exportTracks = [exportTracks retain];
        _totalItemCount = (int)_exportTracks.count;
        _mode = mode;
    }
    return self;
}
#pragma mark - 导入file system文件初始化函数
- (id)initWithIPodkey:(NSString *)ipodKey importTracks:(DriveItem *)importTracks withCurrentPath:(NSString *)curPath withDelegate:(id)delegate {
    if (self = [self initWithIPodkey:ipodKey withDelegate:delegate]) {
        _currentDriveItem = [importTracks retain];
        _exportTracks = [importTracks.childArray retain];
        _exportPath = [curPath retain];
    }
    return self;
}

- (void)startTransfer {
    _curSize = 0;
    _totalSize = 0;
    [self importFileToDevice:_exportPath withsourcePathArray:_exportTracks];
}

+ (BOOL)checkIosIsHighVersion:(IMBiPod *)ipod{
    NSString *version = ipod.deviceInfo.productVersion;
    int charnum = 0;
    @try {
        if ([version isVersionMajorEqual:@"10"]) {
            charnum = [[version substringToIndex:2] intValue];
        }else {
            charnum = [[version substringToIndex:1] intValue];
        }
    }
    @catch (NSException *exception) {
        charnum = 0;
    }
    @finally {
        if (charnum > 7) {
            return YES;
        }
        else{
            return NO;
        }
    }
}

#pragma mark - 导出html格式用到
- (BOOL)writeToMsgFileWithPageTitle:(NSString*)pageTitle {
    NSString *exportFilePath = nil;
    exportFilePath = [_exportPath stringByAppendingPathComponent:_exportName];
    if ([_fileManager fileExistsAtPath:exportFilePath]) {
        exportFilePath = [TempHelper getFilePathAlias:exportFilePath];
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
            data = [self createHtmBody];
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
- (NSData*)createHtmHeader:(NSString*)title {
    return nil;
}

- (NSData*)createHtmFooter {
    return nil;
}

- (NSData*)createHtmBody {
    return nil;
}

#pragma mark - copy device to local
- (BOOL)copyRemoteFile:(NSString*)path1 toLocalFile:(NSString*)path2
{
	BOOL result = NO;
    if (_ipod.deviceInfo.isIOSDevice) {
        if ([[_ipod.fileSystem afcMediaDirectory] ensureConnectionIsOpen]) {
            // open remote file for read
            AFCFileReference *in = [_ipod.fileSystem openForRead:path1];
            if (in) {
                uint32_t bufsz = 10240;
                uint64_t filesize = [_ipod.fileSystem getFileLength:path1];
                if (filesize>102400*5) {
                    bufsz = 102400*5;
                }else if (filesize<=102400*5&&filesize>102400){
                    bufsz = 102400*5;
                }else if (filesize<=102400){
                    bufsz = 102400;
                }
                // open local file for write - stupidly we need to create it before
                // we can make an NSFileHandle
                [_fileManager createFileAtPath:path2 contents:nil attributes:nil];
                NSFileHandle *out = [NSFileHandle fileHandleForWritingAtPath:path2];
                if (out) {
                    char *buff = (char*)malloc(bufsz);
                    while (1) {
                        uint64_t n = [in readN:bufsz bytes:buff];
                        if (n==0) {
                            break;
                        }
                        NSData *b2 = [[NSData alloc]
                                      initWithBytesNoCopy:buff length:n freeWhenDone:NO];
                        [out writeData:b2];
                        [b2 release];
                        [self sendCopyProgress:n];
                    }
                    free(buff);
                    [out closeFile];
                    result = YES;
                }
                [in closeFile];
            }
        }
    }else {
        NSFileHandle *file1,*file2;
        
        file1 = [NSFileHandle fileHandleForReadingAtPath:path1];
        if (file1 == nil) {
            return result;
        }
        [_fileManager createFileAtPath:path2 contents:nil attributes:nil];
        file2 = [NSFileHandle fileHandleForWritingAtPath:path2];
        if (file2 == nil) {
            return result;
        }
        [file2 truncateFileAtOffset:0];
        uint64 offset = 0;
        
        uint32_t bufsz = 10240;
        uint64_t filesize = [_ipod.fileSystem getFileLength:path1];
        if (filesize>102400*5) {
            bufsz = 102400*5;
        }else if (filesize<=102400*5&&filesize>102400){
            bufsz = 102400*5;
        }else if (filesize<=102400){
            bufsz = 102400;
        }
        while (1) {
            @autoreleasepool {
                NSData *nextblock = [file1 readDataOfLength:bufsz];
                uint32_t n = (uint32_t)[nextblock length];
                if (n==0) break;
                [file2 writeData:nextblock];
                offset += n;
                [self sendCopyProgress:n];
            }
        }
        [file1 closeFile];
        [file2 closeFile];
        result = YES;
    }
	return result;
}

- (BOOL)asyncCopyRemoteFile:(NSString *)path1 toLocalFile:(NSString *)path2 {
    BOOL result = NO;
    if (_ipod.deviceInfo.isIOSDevice) {
        if ([[_ipod.fileSystem afcMediaDirectory] ensureConnectionIsOpen]) {
            AFCFileReference *in = [_ipod.fileSystem openForRead:path1];
            if (in) {
                [_fileManager createFileAtPath:path2 contents:nil attributes:nil];
                NSFileHandle *out = [NSFileHandle fileHandleForWritingAtPath:path2];
                if (out) {
                    //创建一个Buffer，用于存放读出的Byte字节
                    uint32_t bufsz = 10240;
                    uint64_t filesize = [_ipod.fileSystem getFileLength:path1];
                    if (filesize>102400*5) {
                        bufsz = 102400*5;
                    }else if (filesize<=102400*5&&filesize>102400){
                        bufsz = 102400*5;
                    }else if (filesize<=102400){
                        bufsz = 102400;
                    }
                    char *buff = (char*)malloc(bufsz);
                    
                    //创建一个AsyncState实体类，用于存在文件信息
                    AsyncState *state = [[AsyncState alloc] init];
                    state.fileHandle = out;
                    state.dfHandle = in;
                    state.fileLength = filesize;
                    state.buff = buff;
                    state.bufsz = bufsz;
                    uint64_t length = [in readN:bufsz bytes:buff];
                    if (length > 0) {
                        NSData *data = [[NSData alloc]
                                        initWithBytesNoCopy:buff length:length freeWhenDone:NO];
                        [state.bufferList addObject:data];
                        [data release];
                        [state.readLengthList addObject:[NSNumber numberWithLongLong:length]];
                        //开启一个线程读取文件内容
                        [NSThread detachNewThreadSelector:@selector(doReadFile:) toTarget:self withObject:state];
                        
                        //开始异步写入文件
                        [NSThread detachNewThreadSelector:@selector(doWriteFile:) toTarget:self withObject:state];
                        [state.condition lock];
                        [state.condition wait];
                        [state.condition unlock];
                    }
                    
                    free(buff);
                    [out closeFile];
                    [state.bufferList removeAllObjects];
                    [state.readLengthList removeAllObjects];
                    [state release];
                    state = nil;
                    result = YES;
                }
                [in closeFile];
            }
        }
    }else {
        NSFileHandle *file1,*file2;
        
        file1 = [NSFileHandle fileHandleForReadingAtPath:path1];
        if (file1 == nil) {
            return result;
        }
        [_fileManager createFileAtPath:path2 contents:nil attributes:nil];
        file2 = [NSFileHandle fileHandleForWritingAtPath:path2];
        if (file2 == nil) {
            return result;
        }
        [file2 truncateFileAtOffset:0];
        uint64 offset = 0;
        
        uint32_t bufsz = 10240;
        uint64_t filesize = [_ipod.fileSystem getFileLength:path1];
        if (filesize>102400*5) {
            bufsz = 102400*5;
        }else if (filesize<=102400*5&&filesize>102400){
            bufsz = 102400*5;
        }else if (filesize<=102400){
            bufsz = 102400;
        }
        
        while (1) {
            @autoreleasepool {
                NSData *nextblock = [file1 readDataOfLength:bufsz];
                uint32_t n = (uint32_t)[nextblock length];
                if (n==0) break;
                [file2 writeData:nextblock];
                offset += n;
                [self sendCopyProgress:n];
            }
        }
        
        [file1 closeFile];
        [file2 closeFile];
        result = YES;
    }
    return result;
}

- (void)doReadFile:(AsyncState *)state {
    while (1) {
        //        memset(state.buff, 0, state.bufsz);
        uint64_t n = [state.dfHandle readN:state.bufsz bytes:state.buff];
        if (n==0) {
            state.isReaded = YES;
            break;
        }
        NSData *data = [[NSData alloc]
                        initWithBytesNoCopy:state.buff length:n freeWhenDone:NO];
        [state.bufferList addObject:data];
        [data release];
        [state.readLengthList addObject:[NSNumber numberWithLongLong:n]];
    }
}

- (void)doWriteFile:(AsyncState *)state {
    @try {
        @synchronized(state.bufferList) {
            uint64_t length = [[state.readLengthList objectAtIndex:0] longLongValue];
            [self sendCopyProgress:length];
            NSData *data = [state.bufferList objectAtIndex:0];
            [state.fileHandle writeData:data];
            [state.bufferList removeObjectAtIndex:0];
            [state.readLengthList removeObjectAtIndex:0];
        }
    }
    @catch (NSException *exception) {
        //IO出错
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"error:%@",exception.reason]];
        [state.condition lock];
        [state.condition signal];
        [state.condition unlock];
        return;
    }
    if (state.isReaded && state.bufferList.count == 0)
    {
        //写完发出完成信号
        //        SuccessCount = SuccessCount + 1;
        [state.condition lock];
        [state.condition signal];
        [state.condition unlock];
    }else {
        @synchronized(state.bufferList) {
            while (1)
            {
                if (state.bufferList.count > 0)
                {
                    if (state.readLengthList.count > 0)
                    {
                        [self doWriteFile:state];
                        break;
                    }
                }
                else if (state.isReaded && state.bufferList.count == 0)
                {
                    //                    SuccessCount = SuccessCount + 1;
                    [state.condition lock];
                    [state.condition signal];
                    [state.condition unlock];
                    break;
                }
                [NSThread sleepForTimeInterval:0.005];
            }
        }
    }
}

- (BOOL)copyLocalFile:(NSString*)path1 toRemoteFile:(NSString*)path2 {
    BOOL result = NO;
    if (_ipod.deviceInfo.isIOSDevice) {
        if ([[_ipod.fileSystem afcMediaDirectory] ensureConnectionIsOpen]) {
            // ok, make sure the input file opens before creating the
            // output file
            struct stat s;
            stat([path1 fileSystemRepresentation],&s);
            int64_t filesize = (int64_t)s.st_size;
//            if (filesize>1024*1024*500) {
//                @autoreleasepool {
//                    //如果大于100M采用内存映射方式读取
//                    int fd;
//                    size_t size;
//                    struct stat stat_buf;
//                    void *addr = NULL;
//                    fd = open([path1 UTF8String], O_RDWR | O_CREAT);
//                    if (fd == -1) {
//                        return NO;
//                    }
//                    fstat(fd, &stat_buf);
//                    size = stat_buf.st_size;
//                    // 映射到内存－可读写
//                    int64_t inSize = 4096*10240;
//                    int64_t product1 = (filesize/inSize);
//                    int64_t remainder1 = (filesize%inSize);
//                    AFCFileReference *out = [_ipod.fileSystem openForWrite:path2];
//                    if (out) {
//                        for (int i=0;i<product1;i++) {
//                            @autoreleasepool {
//                                addr = mmap(NULL, inSize, PROT_READ, MAP_PRIVATE, fd, i*inSize);
//                                [out writeN:inSize bytes:addr];
//                                munmap(addr, inSize);
//                                [self sendCopyProgress:inSize];
//                            }
//                        }
//                        if (remainder1 != 0) {
//                            @autoreleasepool {
//                                addr = mmap(0, remainder1, PROT_READ, MAP_PRIVATE, fd, product1*inSize);
//                                [out writeN:remainder1 bytes:addr];
//                                munmap(addr, remainder1);
//                                [self sendCopyProgress:remainder1];
//                            }
//                        }
//                        result = YES;
//                        [out closeFile];
//                        close(fd);
//                    }else{
//                        return NO;
//                    }
//                }
//            }else{
                NSFileHandle *in = [NSFileHandle fileHandleForReadingAtPath:path1];
                if (in) {
                    uint32_t bufsz = 10240;
                    if (filesize>102400*5) {
                        bufsz = 102400*5;
                    }else if (filesize<=102400*5&&filesize>102400){
                        bufsz = 102400*5;
                    }else if (filesize<=102400){
                        bufsz = 102400;
                    }
                    // open remote file for write
                    AFCFileReference *out = [_ipod.fileSystem openForWrite:path2];
                    if (out) {
                        //copy all content across 10K at a time
                        uint64_t done = 0;
                        while (1) {
                            @autoreleasepool {
                                if (_isStop) {
                                    break;
                                }
                                NSData *nextblock = [in readDataOfLength:bufsz];
                                uint64_t n = [nextblock length];
                                if (n==0) break;
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    _currentDriveItem.currentSize = n;
//                                    _currentDriveItem.progress = (double)_currentDriveItem.currentSize/_totalSize *100;
//                                    _currentDriveItem.currentSizeStr = [NSString stringWithFormat:@"%@/%@",[self getFileSizeString:n reserved:2],[self getFileSizeString:_totalSize reserved:2]];
//                                    _currentDriveItem.fileSize = _totalSize;
//
//                                });
//                                
                                [out writeNSData:nextblock];
                                done += n;
                                [self sendCopyProgress:n];
                            }
                        }
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            _currentDriveItem.progress = (double)_currentDriveItem.currentSize/_currentDriveItem.fileSize *100;
//                            _currentDriveItem.currentSizeStr = [NSString stringWithFormat:@"%@/%@",[self getFileSizeString:_curSize reserved:2],[self getFileSizeString:_currentDriveItem.fileSize reserved:2]];
//
//                            
////                            _currentDriveItem.currentSize = 0;
////                            _currentDriveItem.progress = 100;
////                            _currentDriveItem.currentSizeStr = [NSString stringWithFormat:@"%@/%@",[self getFileSizeString:_currentDriveItem.fileSize reserved:2],[self getFileSizeString:_currentDriveItem.fileSize reserved:2]];
////                            _currentDriveItem.state = DownloadStateComplete;
//                        });
                        [out closeFile];
                        result = YES;
                    }
                    // close input file regardless
                    [in closeFile];
                }
            //}
        }
    }else {
        NSFileHandle *file1,*file2;
        file1 = [NSFileHandle fileHandleForReadingAtPath:path1];
        if (file1 == nil) {
            return result;
        }
        
        [_fileManager createFileAtPath:path2 contents:nil attributes:nil];
        file2 = [NSFileHandle fileHandleForWritingAtPath:path2];
        if (file2 == nil) {
            return result;
        }
        [file2 truncateFileAtOffset:0];
        uint64 offset = 0;
        
        struct stat s;
        stat([path1 fileSystemRepresentation],&s);
        uint32_t bufsz = 10240;
        long long filesize = (long long)s.st_size;
        if (filesize>102400*5) {
            bufsz = 102400*5;
        }else if (filesize<=102400*5&&filesize>102400){
            bufsz = 102400*5;
        }else if (filesize<=102400){
            bufsz = 102400;
        }
        while (1) {
            @autoreleasepool {
                NSData *nextblock = [file1 readDataOfLength:bufsz];
                uint32_t n = (int32_t)[nextblock length];
                if (n==0) break;
                [file2 writeData:nextblock];
                offset += n;
                [self sendCopyProgress:n];
            }
        }
        [file1 closeFile];
        [file2 closeFile];
        result = YES;
    }
	return result;
}

- (void)sendCopyProgress:(uint64_t)curSize {
    _curSize += curSize;
    float progress = ((float)_curSize / _totalSize) * 100;
    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
        [_transferDelegate transferProgress:progress];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _currentDriveItem.currentSize = _curSize;
        _currentDriveItem.progress = (double)_currentDriveItem.currentSize/_currentDriveItem.fileSize *100;
        _currentDriveItem.currentSizeStr = [NSString stringWithFormat:@"%@/%@",[self getFileSizeString:_curSize reserved:2],[self getFileSizeString:_currentDriveItem.fileSize reserved:2]];
    });
    if ([_transferDelegate respondsToSelector:@selector(transferCurrentSize:)]) {
        [_transferDelegate transferCurrentSize:_curSize];
    }
}

- (int64_t)caculateTransferTotalSize:(NSArray *)array {
    return 0;
}

- (void)dealloc {
    if (_exportTracks != nil) {
        [_exportTracks release];
        _exportTracks = nil;
    }
    if (_exportPath != nil) {
        [_exportPath release];
        _exportPath = nil;
    }
    [_ipod release],_ipod = nil;
    [super dealloc];
}

#pragma mark - add file system
- (void)importFileToDevice:(NSString *)destinationFolder withsourcePathArray:(NSArray *)sourcePathArray
{
    if (![[_ipod.fileSystem afcMediaDirectory] fileExistsAtPath:destinationFolder]) {
        [[_ipod.fileSystem afcMediaDirectory] mkdir:@"Preparing Transfer..."];
    }
    [self caculateTotalFileCount:sourcePathArray];
    _currentDriveItem.fileSize = _totalSize;
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transferDelegate transferPrepareFileEnd];
    }

    for (int i = 0;i<[sourcePathArray count];i++) {
//        if (_limitation.remainderCount == 0) {
//            break;
//        }
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            _skipCount += sourcePathArray.count - i - 1;
            break;
        }
        _currentDriveItem.currentSize = 0;
        NSString *sourcePath = [sourcePathArray objectAtIndex:i];
        NSString *fileName = [sourcePath lastPathComponent];
        
        NSString *destinationPath = nil;
        if ([destinationFolder isEqualToString:@"/"]) {
            destinationPath = [destinationFolder stringByAppendingString:fileName];
        }else
        {
            destinationPath = [destinationFolder stringByAppendingPathComponent:fileName];
        }
        BOOL isDir = NO;
        if ([_fileManager fileExistsAtPath:sourcePath isDirectory:&isDir]) {
            if (isDir) {
                if ([[_ipod.fileSystem afcMediaDirectory] fileExistsAtPath:destinationPath]) {
                    destinationPath = [IMBBaseTransfer getFolderPathAlias:destinationPath iPod:_ipod];
                }
                //创建文件夹
                [[_ipod.fileSystem afcMediaDirectory] mkdir:destinationPath];
                NSArray *subArr = [_fileManager contentsOfDirectoryAtPath:sourcePath error:nil];
                NSMutableArray *subSoucePathArray = [NSMutableArray array];
                for (NSString *url in subArr) {
                    NSString *filePath = [sourcePath stringByAppendingPathComponent:url];
                    [subSoucePathArray addObject:filePath];
                }
                [self copyFileToDevice:destinationPath withsourcePathArray:subSoucePathArray];
                _currentDriveItem.state = UploadStateComplete;
            }else
            {
                if ([[_ipod.fileSystem afcMediaDirectory] fileExistsAtPath:destinationPath]) {
                    destinationPath = [IMBBaseTransfer getFilePathAlias:destinationPath iPod:_ipod];
                }
                _currItemIndex++;
                if (![TempHelper stringIsNilOrEmpty:fileName]) {
                    NSString *msgStr = [NSString stringWithFormat:@"Copying %@...",fileName];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
                BOOL success = [self copyLocalFile:sourcePath toRemoteFile:destinationPath];
                if (success) {
//                    [_limitation reduceRedmainderCount];
                    _successCount++;
                    _currentDriveItem.state = UploadStateComplete;
                }else
                {
                    _failedCount ++;
                    _currentDriveItem.state = UploadStateError;
                    continue;
                    
                }
            }
        }
//         _curSize = 1;
    }
   
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
}

+(NSString*)getFilePathAlias:(NSString*)filePath iPod:(IMBiPod *)ipod{
    NSString *newPath = filePath;
    int i = 1;
    NSString *filePathWithOutExt = [filePath stringByDeletingPathExtension];
    NSString *fileExtension = [filePath pathExtension];
    while ([[ipod.fileSystem afcMediaDirectory]  fileExistsAtPath:newPath]) {
        newPath = [NSString stringWithFormat:@"%@(%d).%@",filePathWithOutExt,i++,fileExtension];
    }
    return newPath;
}

//文件夹存在，生成别名
+ (NSString *)getFolderPathAlias:(NSString *)folderPath iPod:(IMBiPod *)ipod{
    NSString *newPath = folderPath;
    int i = 1;
    while ([[ipod.fileSystem afcMediaDirectory]  fileExistsAtPath:newPath]) {
        newPath = [NSString stringWithFormat:@"%@-%d",folderPath,i++];
    }
    return newPath;
}


- (void)copyFileToDevice:(NSString *)destinationFolder withsourcePathArray:(NSArray *)sourcePathArray
{
    for (int i = 0;i<[sourcePathArray count];i++) {
//        if (_limitation.remainderCount == 0) {
//            break;
//        }
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            break;
        }
        NSString *sourcePath = [sourcePathArray objectAtIndex:i];
        NSString *fileName = [sourcePath lastPathComponent];
        
        NSString *destinationPath = nil;
        if ([destinationFolder isEqualToString:@"/"]) {
            
            destinationPath = [destinationFolder stringByAppendingString:fileName];
        }else
        {
            destinationPath = [destinationFolder stringByAppendingPathComponent:fileName];
        }
        if ([[_ipod.fileSystem afcMediaDirectory] fileExistsAtPath:destinationPath]) {
            
            destinationPath = [StringHelper createDifferentfileName:destinationPath];
        }
        BOOL isDir = NO;
        if ([_fileManager fileExistsAtPath:sourcePath isDirectory:&isDir]) {
            
            if (isDir) {
                //创建文件夹
                [[_ipod.fileSystem afcMediaDirectory] mkdir:destinationPath];
                NSArray *subArr = [_fileManager contentsOfDirectoryAtPath:sourcePath error:nil];
                NSMutableArray *subSoucePathArray = [NSMutableArray array];
                for (NSString *url in subArr) {
                    NSString *filePath = [sourcePath stringByAppendingPathComponent:url];
                    [subSoucePathArray addObject:filePath];
                }
                [self copyFileToDevice:destinationPath withsourcePathArray:subSoucePathArray];
                
            }else
            {
                _currItemIndex++;
                if (![TempHelper stringIsNilOrEmpty:fileName]) {
                    NSString *msgStr = [NSString stringWithFormat:@"Copying %@...",fileName];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
                BOOL success = [self copyLocalFile:sourcePath toRemoteFile:destinationPath];
                if (success) {
//                    [_limitation reduceRedmainderCount];
                    _successCount ++;
                }else
                {
                    _failedCount ++;
                    continue;
                    
                }
            }
        }
    }
}

- (int)caculateTotalFileCount:(NSArray *)nodeArray {
    
    for (NSString *filePath in nodeArray) {
        BOOL isDir;
        if ([_fileManager fileExistsAtPath:filePath isDirectory:&isDir]) {
            if (!isDir) {
                _totalItemCount++;
                struct stat s;
                stat([filePath fileSystemRepresentation],&s);
                _totalSize += (int64_t)s.st_size;
            }else
            {
                NSArray *subArr = [_fileManager contentsOfDirectoryAtPath:filePath error:nil];
                NSMutableArray *subSoucePathArray = [NSMutableArray array];
                for (NSString *url in subArr) {
                    NSString *subfilePath = [filePath stringByAppendingPathComponent:url];
                    [subSoucePathArray addObject:subfilePath];
                }
                [self caculateTotalFileCount:subSoucePathArray];
            }
        }
        
    }
    return _totalItemCount;
}

- (NSString*)getFileSizeString:(long long)totalSize reserved:(int)decimalPoints {
    double mbSize = (double)totalSize / 1048576;
    double kbSize = (double)totalSize / 1024;
    if (totalSize < 1024) {
        return [NSString stringWithFormat:@" %.0f%@", (double)totalSize,@"B"];
    } else {
        if (mbSize > 1024) {
            double gbSize = (double)totalSize / 1073741824;
            return [self Rounding:gbSize reserved:decimalPoints capacityUnit:@"GB"];
        } else if (kbSize > 1024) {
            return [self Rounding:mbSize reserved:decimalPoints capacityUnit:@"MB"];
        } else {
            return [self Rounding:kbSize reserved:decimalPoints capacityUnit:@"KB"];
        }
    }
}

- (NSString*)Rounding:(double)numberSize reserved:(int)decimalPoints capacityUnit:(NSString*)unit {
    switch (decimalPoints) {
        case 1:
            return [NSString stringWithFormat:@"%.1f %@", numberSize, unit];
            break;
            
        case 2:
            return [NSString stringWithFormat:@"%.2f %@", numberSize, unit];
            break;
            
        case 3:
            return [NSString stringWithFormat:@"%.3f %@", numberSize, unit];
            break;
            
        case 4:
            return [NSString stringWithFormat:@"%.4f %@", numberSize, unit];
            break;
            
        default:
            return [NSString stringWithFormat:@"%.2f %@", numberSize, unit];
            break;
    }
}


#pragma mark - 暂停方法
- (void)pauseScan {
    [_condition lock];
    if(!_isPause)
    {
        _isPause = YES;
    }
    [_condition unlock];
}

- (void)resumeScan {
    [_condition lock];
    if(_isPause)
    {
        _isPause = NO;
        [_condition signal];
    }
    [_condition unlock];
}

- (void)stopScan {
    [_condition lock];
    _isStop = YES;
    [_condition signal];
    [_condition unlock];
}

@end
