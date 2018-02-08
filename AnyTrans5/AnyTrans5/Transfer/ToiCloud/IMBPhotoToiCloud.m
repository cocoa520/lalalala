//
//  IMBPhotoToiCloud.m
//  AnyTrans
//
//  Created by LuoLei on 2017-02-22.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBPhotoToiCloud.h"
#import "IMBPhotoEntity.h"
#import "IMBToiCloudPhotoEntity.h"
#import "IMBiCloudManager.h"
#import "ATTracker.h"
#import "IMBSoftWareInfo.h"
@implementation IMBPhotoToiCloud

- (id)initWithIPodkey:(NSString *)ipodKey importTracks:(NSArray *)importTracks withiCloudManager:(IMBiCloudManager *)iCloudManager CategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate
{
    if (self = [super init]) {
        _category = category;
        _transferDelegate = delegate;
        _ipod = [[[IMBDeviceConnection singleton] getIPodByKey:ipodKey] retain];
        _iCloudManager = iCloudManager;
        _photoArray = [importTracks retain];
        _totalItemCount =  [_photoArray count];
        _successCount = 0;
        _currItemIndex = 0;
    }
    return self;
}

- (void)startTransfer
{
//    [_iCloudManager getPhotosContent];
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transferDelegate transferPrepareFileEnd];
    }
    
    for (IMBPhotoEntity *entity in _photoArray) {
        @autoreleasepool {
            if (_limitation.remainderCount == 0) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:entity.photoName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                continue;
            }
            _currItemIndex++;
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:entity.photoName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                continue;
            }
            IMBToiCloudPhotoEntity *icloudEntity = [[IMBToiCloudPhotoEntity alloc] init];
            icloudEntity.photoName =  entity.photoName;
            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transferDelegate transferFile:icloudEntity.photoName];
            }
            
            if ([[[entity.photoName pathExtension] lowercaseString] isEqualToString:@"png"]) {
                NSString *filePath = [[[TempHelper getAppSupportPath] stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:entity.photoName];
                [_ipod.fileSystem copyRemoteFile:[entity.photoPath stringByAppendingPathComponent:entity.photoName] toLocalFile:filePath];
                [self startConvert:filePath withConvetPath:[filePath stringByDeletingPathExtension] withPathExtension:[[entity.photoName pathExtension] lowercaseString]];
                NSString *filePath1 = [[[TempHelper getAppSupportPath] stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:[entity.photoName stringByDeletingPathExtension]];
                NSString *jpgPath = [NSString stringWithFormat:@"%@.jpg",filePath1];
                icloudEntity.photoImageData = [NSData dataWithContentsOfFile:jpgPath];
            }else{
                icloudEntity.photoImageData = [self readFileData:entity.allPath];
            }

            if ([_iCloudManager syncTransferPhoto:icloudEntity]) {
                _successCount += 1;
                [_limitation reduceRedmainderCount];
                if ([[[entity.photoName pathExtension] lowercaseString] isEqualToString:@"png"]) {
                     NSString *filePath = [[[TempHelper getAppSupportPath] stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:entity.photoName];
                    NSString *filePath1 = [[[TempHelper getAppSupportPath] stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:[entity.photoName stringByDeletingPathExtension]];
                    NSString *jpgPath = [NSString stringWithFormat:@"%@.jpg",filePath1];
                    if ([_fileManager fileExistsAtPath:filePath]) {
                        [_fileManager removeItemAtPath:filePath error:nil];
                    }
                    if ([_fileManager fileExistsAtPath:jpgPath]) {
                        [_fileManager removeItemAtPath:jpgPath error:nil];
                    }
                }
            }
            if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                [_transferDelegate transferProgress:_currItemIndex/(_totalItemCount*1.0)*100];
            }
        }
    }
    [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
}

- (BOOL)startConvert:(NSString *)sourPath withConvetPath:(NSString *)conPath withPathExtension:(NSString *)pathExtension {
    [_loghandle writeInfoLog:@"start Convert"];
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-i",[NSString stringWithFormat:@"%@",sourPath],[NSString stringWithFormat:@"%@.jpg",conPath],nil];
    return [self runFFMpeg:params];
}

- (BOOL)runFFMpeg:(NSArray*)params {
    [_loghandle writeInfoLog:@"ffmpeg Start"];
    NSString* ffmpegPath = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:@""];
    
    if (params != nil) {
        NSTask *task = [[NSTask alloc] init];
        //Todo这里需要异步操作!!
        [task setLaunchPath: ffmpegPath];
        [task setArguments: params];
        
        [task launch];
        [task waitUntilExit];
        sleep(1);
        int status = [task terminationStatus];
        [task release];
        if (status == 0) {
            NSLog(@"Task succeeded.");
            [_loghandle writeInfoLog:@"ConvertMov succeeded"];
            return YES;
        } else {
            NSLog(@"Task failed.");
            [_loghandle writeInfoLog:@"ConvertMov failed"];
            return NO;
        }
    }
    return NO;
}

- (NSData *)readFileData:(NSString *)filePath  {
    if (![_ipod.fileSystem fileExistsAtPath:filePath]) {
        return nil;
    }
    else{
        long long fileLength = [_ipod.fileSystem getFileLength:filePath];
        AFCFileReference *openFile = [_ipod.fileSystem openForRead:filePath];
        const uint32_t bufsz = 10240;
        char *buff = (char*)malloc(bufsz);
        NSMutableData *totalData = [[[NSMutableData alloc] init] autorelease];
        while (1) {
            
            uint64_t n = [openFile readN:bufsz bytes:buff];
            if (n==0) break;
            //将字节数据转化为NSdata
            NSData *b2 = [[NSData alloc]
                          initWithBytesNoCopy:buff length:n freeWhenDone:NO];
            [totalData appendData:b2];
            [b2 release];
        }
        if (totalData.length == fileLength) {
            // NSLog(@"success readData 1111");
        }
        free(buff);
        [openFile closeFile];
        return totalData;
    }
}

- (void)dealloc
{
    [_photoArray release],_photoArray = nil;
    [super dealloc];
}
@end
