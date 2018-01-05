//
//  IMBUSBFileSystem.m
//  iMobieTrans
//
//  Created by Pallas on 4/1/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBUSBFileSystem.h"
#import "IMBiPod.h"
#import "IMBDeviceInfo.h"
#import "ZipFile.h"
#import "ZipWriteStream.h"

#define chunckSize 131072

@implementation IMBUSBFileSystem

- (id)initWithDevice:(id)device {
    self = [super initWithDevice:device];
    if (self) {
        _driveLetter = (NSString*)device;
        _itunesFolderPath = USB_iTunes_Folder_Path;
        _ipodControlFolderPath = @"iPod_Control/";
        _artworkFolderPath = @"iPod_Control/Artwork/";
        _photoFolderPath = @"Photos/";
        
        _artworkDBPath = [[_driveLetter stringByAppendingPathComponent:_artworkFolderPath]
                          stringByAppendingPathComponent:@"ArtworkDB"];
        _itunesLockPath = [[_driveLetter stringByAppendingPathComponent:_itunesFolderPath] stringByAppendingPathComponent:@"iTunesLock"];
        _playCountsPath = [[_driveLetter stringByAppendingPathComponent:_itunesFolderPath] stringByAppendingPathComponent:@"Play Counts"];
        fm = [NSFileManager defaultManager];
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
}

- (BOOL)fileExistsAtPath:(NSString*)filePath {
    return [fm fileExistsAtPath:filePath];
}

- (long long)getFileLength:(NSString*)filePath {
    long fileSize = 0;
    NSDictionary *fileInfo = [fm attributesOfItemAtPath:filePath error:nil];
    if (fileInfo != nil) {
        fileSize = [[fileInfo valueForKey:NSFileSize] longValue];
    }
    return fileSize;
}

- (int64_t)getFolderSize:(NSString*)filePath {
    int64_t totalSize = 0;
    
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:filePath isDirectory:&isDir]) {
        if (isDir) {
            [self recuFolderSize:filePath withCurrSize:&totalSize];
        } else {
            NSDictionary *fileAttributeDic=[fm attributesOfItemAtPath:filePath error:nil];
            totalSize += fileAttributeDic.fileSize;
        }
    }
    return totalSize;
}

- (void)recuFolderSize:(NSString*)rootPath withCurrSize:(int64_t*)currSize {
    NSArray* array = [fm contentsOfDirectoryAtPath:rootPath error:nil];
    for(int i = 0; i<[array count]; i++) {
        NSString *fullPath = [rootPath stringByAppendingPathComponent:[array objectAtIndex:i]];
        BOOL isDir = NO;
        if ([fm fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (isDir) {
                [self recuFolderSize:fullPath withCurrSize:currSize];
            } else {
                NSDictionary *fileAttributeDic=[fm attributesOfItemAtPath:fullPath error:nil];
                *currSize += fileAttributeDic.fileSize;
            }
        }
    }
}

- (BOOL)unlink:(NSString*)filePath {
    return [fm removeItemAtPath:filePath error:nil];
}

- (BOOL)unlinkFolder:(NSString *)path {
    return [fm removeItemAtPath:path error:nil];
}

- (NSArray*)getItemInDirectory:(NSString*)filePath {
    NSArray *result = nil;
    NSArray *tempArray = [fm contentsOfDirectoryAtPath:filePath error:nil];
    if (tempArray != nil && [tempArray count] > 0) {
        NSString *temPath = @"";
        AMFileEntity *fileEntity = nil;
        NSMutableArray *unsorted = [NSMutableArray new];
        for (NSString *item in tempArray) {
            temPath = [filePath stringByAppendingPathComponent:item];
            fileEntity= [[AMFileEntity new] autorelease];
            fileEntity.FilePath = temPath;
            fileEntity.Name = item;
            NSDictionary *fileInfoDic = [fm attributesOfItemAtPath:temPath error:nil];
            if (fileInfoDic != nil && [fileInfoDic count] > 0) {
                fileEntity.FileSize = [[fileInfoDic objectForKey:NSFileSize] longValue];
                NSString *fileType = [fileInfoDic objectForKey:NSFileType];
                if ([NSFileTypeRegular isEqualToString:fileType]) {
                    fileEntity.FileType = AMRegularFile;
                } else if ([NSFileTypeDirectory isEqualToString:fileType]) {
                    fileEntity.FileType = AMDirectory;
                } else if ([NSFileTypeSymbolicLink isEqualToString:fileType]) {
                    fileEntity.FileType = AMSymbolicLink;
                }
            }
            [unsorted addObject:fileEntity];
        }
        result = [NSArray arrayWithArray:unsorted];
        [unsorted release];
        unsorted = nil;
        return result;
    }
    return result;
}

- (BOOL)copyRemoteFile:(NSString*)remoteFile toLocalFile:(NSString*)toLocalFile {
    BOOL result = NO;
    if ([fm fileExistsAtPath:toLocalFile]) {
        
    } else {
        NSFileHandle *file1,*file2;
        
        file1 = [NSFileHandle fileHandleForReadingAtPath:remoteFile];
        if (file1 == nil) {
            return result;
        }

        [fm createFileAtPath:toLocalFile contents:nil attributes:nil];
        file2 = [NSFileHandle fileHandleForWritingAtPath:toLocalFile];
        if (file2 == nil) {
            return result;
        }
        [file2 truncateFileAtOffset:0];
        uint64 offset = 0;
        
        //NSData *fd = [file1 readDataOfLength:chunckSize];
        
        while (1) {
            @autoreleasepool {
                NSData *nextblock = [file1 readDataOfLength:chunckSize];
                uint32_t n = (uint32_t)[nextblock length];
                if (n==0) break;
                [file2 writeData:nextblock];
                offset += n;
            }
        }
        
        [file1 closeFile];
        [file2 closeFile];
        result = YES;
    }
    return result;
}

- (BOOL)exportZipFile:(NSString*)zipFilePath fromRemoteFilePath:(NSString*)remoteFilePath {
    if ([self stringIsNilOrEmpty:remoteFilePath] || [self stringIsNilOrEmpty:zipFilePath]) {
        return NO;
    }
    
    BOOL isFolder = NO;
    if (![fm fileExistsAtPath:remoteFilePath isDirectory:&isFolder]) {
        return NO;
    }
    
    if ([fm fileExistsAtPath:zipFilePath]) {
        [fm removeItemAtPath:zipFilePath error:nil];
    }
    BOOL ret = [fm createFileAtPath:zipFilePath contents:nil attributes:nil];
    if (ret) {
        ZipFile *zipFile= [[ZipFile alloc] initWithFileName:zipFilePath mode:ZipFileModeCreate];
        uint64_t totalSize = 0;
        if (isFolder) {
            totalSize = [self getFolderSize:remoteFilePath];
            uint64_t currCompressedSize = 0;
            [self recuZipFileWithRootPath:remoteFilePath withZipFile:zipFile withBaseFolder:@"" withCurrCompressedSize:currCompressedSize withTotolSize:totalSize];
        } else {
            totalSize = [self getFileLength:remoteFilePath];
            uint64_t currCompressedSize = 0;
            
            NSFileHandle *read = [NSFileHandle fileHandleForReadingAtPath:remoteFilePath];
            if (read) {
                NSString *fileName = [remoteFilePath lastPathComponent];
                NSString *innerPath = [@"" stringByAppendingPathComponent:fileName];
                ZipWriteStream *stream= [zipFile writeFileInZipWithName:innerPath fileDate:[NSDate dateWithTimeIntervalSinceNow:-86400.0] compressionLevel:ZipCompressionLevelBest];
                if (stream) {
                    while (1) {
                        @autoreleasepool {
                            NSData *nextblock = [read readDataOfLength:chunckSize];
                            uint32_t n = (uint32_t)[nextblock length];
                            if (n==0) break;
                            [stream writeData:nextblock];
                            currCompressedSize += n;
                        }
                    }
                    [stream finishedWriting];
                }
                [read closeFile];
            }
        }
        [zipFile close];
        [zipFile release];
        zipFile = nil;
    }
    return YES;
}

- (BOOL)recuZipFileWithRootPath:(NSString*)rootPath withZipFile:(ZipFile*)zipFile withBaseFolder:(NSString*)baseFolder withCurrCompressedSize:(int64_t)currCompressedSize withTotolSize:(int64_t)totalSize {
    NSArray* array = [fm contentsOfDirectoryAtPath:rootPath error:nil];
    for(int i = 0; i<[array count]; i++) {
        NSString *fileName = [array objectAtIndex:i];
        NSString *innerPath = [baseFolder stringByAppendingPathComponent:fileName];
        NSString *fullPath = [rootPath stringByAppendingPathComponent:[array objectAtIndex:i]];
        BOOL isDir = NO;
        if ([fm fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (isDir) {
                [self recuZipFileWithRootPath:fullPath withZipFile:zipFile withBaseFolder:innerPath withCurrCompressedSize:currCompressedSize withTotolSize:totalSize];
            } else {
                NSFileHandle *read = [NSFileHandle fileHandleForReadingAtPath:fullPath];
                if (read) {
                    ZipWriteStream *stream= [zipFile writeFileInZipWithName:innerPath fileDate:[NSDate dateWithTimeIntervalSinceNow:-86400.0] compressionLevel:ZipCompressionLevelBest];
                    if (stream) {
                        while (1) {
                            @autoreleasepool {
                                NSData *nextblock = [read readDataOfLength:chunckSize];
                                uint32_t n = (uint32_t)[nextblock length];
                                if (n==0) break;
                                [stream writeData:nextblock];
                                currCompressedSize += n;
                            }
                        }
                        [stream finishedWriting];
                    }
                    [read closeFile];
                }
            }
        }
    }
    return YES;
}


- (BOOL)copyLocalFile:(NSString*)localPath toRemoteFile:(NSString*)toRemoteFile {
    BOOL result = NO;
    if ([fm fileExistsAtPath:toRemoteFile]) {
        
    } else {
        NSFileHandle *file1,*file2;
        file1 = [NSFileHandle fileHandleForReadingAtPath:localPath];
        if (file1 == nil) {
            return result;
        }
        
        [fm createFileAtPath:toRemoteFile contents:nil attributes:nil];
        file2 = [NSFileHandle fileHandleForWritingAtPath:toRemoteFile];
        if (file2 == nil) {
            return result;
        }
        [file2 truncateFileAtOffset:0];
        uint64 offset = 0;
        //NSData *fd = [file1 readDataOfLength:chunckSize];
        while (1) {
            @autoreleasepool {
                NSData *nextblock = [file1 readDataOfLength:chunckSize];
                uint32_t n = (int32_t)[nextblock length];
                if (n==0) break;
                [file2 writeData:nextblock];
                offset += n;
            }
        }
        [file1 closeFile];
        [file2 closeFile];
        result = YES;
    }
    return result;
}

- (BOOL)copyDataToFile:(NSData *)localdata toRemoteFile:(NSString *)toRemoteFile {
	BOOL result = NO;
    // make sure remote file doesn't exist
    if ([self fileExistsAtPath:toRemoteFile]) {
//        [self setLastError:@"Won't overwrite existing file"];
    } else {
        if (localdata != nil) {
            // open remote file for write
            AFCFileReference *out = [self openForWrite:toRemoteFile];
            if (out) {
                // copy all content across 10K at a time
                uint32_t done = 0;
                [out writeNSData:localdata];
                done = (uint32_t)localdata.length;
                [out closeFile];
                result = YES;
                //NSLog(@"copyLocalFile Done");
            }
        } else {
            // hmmm, failed to open
//            [self setLastError:@"NSData is empty"];
        }
    }
    return result;
}

- (BOOL)copyFileBetweenDevice:(NSString*)srcFileName sourDriverLetter:(NSString*)srcDriverLetter targFileName:(NSString*)targFileName targDriverLetter:(NSString*)targDriverLetter sourDevice:(id)srcDevice {
  
    NSString* sourceFileFullPath = [srcDriverLetter stringByAppendingPathComponent:srcFileName];
    NSString* targetFileFullPath = [targDriverLetter stringByAppendingPathComponent:targFileName];
    //如果两个都是USB设备的话就直接拷贝
    IMBiPod *sourceiPod = (IMBiPod*)srcDevice;
    if (sourceiPod != nil && !sourceiPod.deviceInfo.isIOSDevice) {
        return [self copyLocalFile:sourceFileFullPath toRemoteFile:targetFileFullPath];
    } else {
        return [sourceiPod.fileSystem copyRemoteFile:sourceFileFullPath toLocalFile:targetFileFullPath];
    }
}

- (BOOL)moveFileToDestPath:(NSString*)sourPath destPath:(NSString*)destPath {
    return [fm moveItemAtPath:sourPath toPath:destPath error:nil];
}

- (BOOL)copyFile:(NSString *)sourPath copyTo:(NSString *)copyTo {
    return [fm copyItemAtPath:sourPath toPath:copyTo error:nil];
}

- (BOOL)mkDir:(NSString*)dirPath {
    BOOL isDir = NO;
    if ([fm fileExistsAtPath:dirPath isDirectory:&isDir]) {
        if (!isDir) {
            [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    } else {
        [fm createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return NO;
}

- (BOOL)rename:(NSString*)oldPath newPath:(NSString*)newPath {
    return [fm moveItemAtPath:oldPath toPath:newPath error:nil];
}

- (void)eject {
    
}

- (void)startSync {
    
}

- (void)endSync {
    
}

- (NSString*)combinePath:(NSString*)path pathComponent:(NSString*)pathComponent {
    return [path stringByAppendingPathComponent:pathComponent];
}

- (id)openForRead:(NSString*)path {
    return [NSFileHandle fileHandleForReadingAtPath:path];
}

- (id)openForWrite:(NSString*)path {
    return [NSFileHandle fileHandleForWritingAtPath:path];
}

- (id)openForReadWrite:(NSString*)path {
    return [NSFileHandle fileHandleForUpdatingAtPath:path];
}

@end
