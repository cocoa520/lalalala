//
//  IMBZipHelper.m
//  iMobieTrans
//
//  Created by Pallas on 1/27/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBZipHelper.h"

@implementation IMBZipHelper

+ (void)zipByPath:(NSString*)zipPath localPath:(NSString*)localPath {
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isFolder = NO;
    if ([fm fileExistsAtPath:localPath isDirectory:&isFolder]) {
        if (isFolder) {
            ZipFile *zipFile= [[ZipFile alloc] initWithFileName:zipPath mode:ZipFileModeCreate];
            [self recuZip:zipFile fileManager:fm folderPath:localPath baseFolder:localPath];
            [zipFile close];
            [zipFile release];
            zipFile = nil;
        } else {
            
            ZipFile *zipFile= [[ZipFile alloc] initWithFileName:zipPath mode:ZipFileModeCreate];
            NSString *zipName = [localPath lastPathComponent];
            
            ZipWriteStream *stream= [zipFile writeFileInZipWithName:zipName fileDate:[NSDate dateWithTimeIntervalSinceNow:-86400.0] compressionLevel:ZipCompressionLevelBest];
            [stream writeData:[NSData dataWithContentsOfFile:localPath]];
            
            [stream finishedWriting];
            [zipFile close];
            [zipFile release];
            zipFile = nil;
        }
    }
}

+ (void)recuZip:(ZipFile*)zipFile fileManager:(NSFileManager*)fm folderPath:(NSString*)folderPath baseFolder:(NSString*)baseFolder{
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:folderPath];
    NSString *path = nil;
    NSString *zipName = nil;
    NSString *localPath = nil;
    ZipWriteStream *stream = nil;
    while (path = [dirEnum nextObject]) {
        if ([path rangeOfString:@".DS_Store"].location != NSNotFound) {
            continue;
        }
        localPath = [baseFolder stringByAppendingPathComponent:path];
        if ([[fm attributesOfItemAtPath:localPath error:nil] fileType] == NSFileTypeDirectory) {
            [self recuZip:zipFile fileManager:fm folderPath:path baseFolder:baseFolder];
        } else if ([[fm attributesOfItemAtPath:localPath error:nil] fileType] == NSFileTypeRegular) {
            zipName = path;
            stream= [zipFile writeFileInZipWithName:zipName fileDate:[NSDate dateWithTimeIntervalSinceNow:-86400.0] compressionLevel:ZipCompressionLevelBest];
            [stream writeData:[NSData dataWithContentsOfFile:localPath]];
            [stream finishedWriting];
        }
    }
}

+ (void)unZipByAll:(NSString*)zipPath decFolderPath:(NSString*)decFolderPath {
    ZipFile *unZipFile= [[ZipFile alloc] initWithFileName:zipPath mode:ZipFileModeUnzip];
    NSArray *fileArray = [unZipFile listFileInZipInfos];
    if (fileArray != nil && [fileArray count] > 0) {
        [unZipFile goToFirstFileInZip];
        ZipReadStream *read = nil;
        FileInZipInfo *fileInfo = nil;
        NSMutableData *data = nil;
        decFolderPath = [decFolderPath stringByAppendingPathComponent:[[zipPath lastPathComponent] stringByDeletingPathExtension]];
        for (int i = 0; i < [fileArray count]; i++) {
            fileInfo = [unZipFile getCurrentFileInZipInfo];
            read = [unZipFile readCurrentFileInZip];
            data=  [[NSMutableData alloc] initWithLength:[fileInfo length]];
            int length = [read readDataWithBuffer:data];
            if (length != 0) {
                NSString *_folderPath = [decFolderPath stringByAppendingPathComponent:[[fileInfo name] stringByDeletingLastPathComponent]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:_folderPath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:_folderPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                [data writeToFile:[decFolderPath stringByAppendingPathComponent:[fileInfo name]] atomically:YES];
            }
            if (data != nil) {
                [data release];
                data = nil;
            }
            [read finishedReading];
            [unZipFile goToNextFileInZip];
        }
    }
    [unZipFile close];
    [unZipFile release];
    unZipFile = nil;
}

+ (void)unZipByAllF:(NSString*)zipPath decFolderPath:(NSString*)decFolderPath {
    ZipFile *unZipFile= [[ZipFile alloc] initWithFileName:zipPath mode:ZipFileModeUnzip];
    NSArray *fileArray = [unZipFile listFileInZipInfos];
    if (fileArray != nil && [fileArray count] > 0) {
        [unZipFile goToFirstFileInZip];
        ZipReadStream *read = nil;
        FileInZipInfo *fileInfo = nil;
        NSMutableData *data = nil;
        decFolderPath = [decFolderPath stringByAppendingPathComponent:[[zipPath lastPathComponent] stringByDeletingPathExtension]];
        for (int i = 0; i < [fileArray count]; i++) {
            fileInfo = [unZipFile getCurrentFileInZipInfo];
            read = [unZipFile readCurrentFileInZip];
            data=  [[NSMutableData alloc] initWithLength:[fileInfo length]];
            int length = [read readDataWithBuffer:data];
            if (length != 0) {
                NSString *_folderPath = [decFolderPath stringByAppendingPathComponent:[[fileInfo name] stringByDeletingLastPathComponent]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:_folderPath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:_folderPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                [data writeToFile:[decFolderPath stringByAppendingPathComponent:[[fileInfo name] lastPathComponent]] atomically:YES];
            }
            if (data != nil) {
                [data release];
                data = nil;
            }
            [read finishedReading];
            [unZipFile goToNextFileInZip];
        }
    }
    [unZipFile close];
    [unZipFile release];
    unZipFile = nil;
}



+ (void)unZipByFolder:(NSString*)zipPath folderPath:(NSString*)folderPath decFolderPath:(NSString*)decFolderPath {
    ZipFile *unZipFile= [[ZipFile alloc] initWithFileName:zipPath mode:ZipFileModeUnzip];
    NSArray *fileArray = [unZipFile listFileInZipInfos];
    if (fileArray != nil && [fileArray count] > 0) {
        [unZipFile goToFirstFileInZip];
        ZipReadStream *read = nil;
        FileInZipInfo *fileInfo = nil;
        NSMutableData *data = nil;
        decFolderPath = [decFolderPath stringByAppendingPathComponent:[folderPath lastPathComponent]];
        for (int i = 0; i < [fileArray count]; i++) {
            fileInfo = [unZipFile getCurrentFileInZipInfo];
            if ([[fileInfo name] hasPrefix:folderPath] == NO) {
                [unZipFile goToNextFileInZip];
                continue;
            }
            read = [unZipFile readCurrentFileInZip];
            data=  [[NSMutableData alloc] initWithLength:[fileInfo length]];
            int length = [read readDataWithBuffer:data];
            if (length != 0) {
                NSString *_folderPath = [decFolderPath stringByAppendingPathComponent:[[[fileInfo name] stringByReplacingOccurrencesOfString:folderPath withString:@""] stringByDeletingLastPathComponent]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:_folderPath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:_folderPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                [data writeToFile:[decFolderPath stringByAppendingPathComponent:[[fileInfo name] stringByReplacingOccurrencesOfString:folderPath withString:@""]] atomically:YES];
            }
            if (data != nil) {
                [data release];
                data = nil;
            }
            [read finishedReading];
            [unZipFile goToNextFileInZip];
        }
    }
    [unZipFile close];
    [unZipFile release];
    unZipFile = nil;
}

+ (void)unzipByFile:(NSString*)zipPath filePath:(NSString*)filePath decFolderPath:(NSString*)decFolderPath {
    ZipFile *unZipFile= [[ZipFile alloc] initWithFileName:zipPath mode:ZipFileModeUnzip];
    NSArray *fileArray = [unZipFile listFileInZipInfos];
    if (fileArray != nil && [fileArray count] > 0) {
        [unZipFile goToFirstFileInZip];
        ZipReadStream *read = nil;
        FileInZipInfo *fileInfo = nil;
        NSMutableData *data = nil;
        for (int i = 0; i < [fileArray count]; i++) {
            fileInfo = [unZipFile getCurrentFileInZipInfo];
            //NSLog(@"file Info name: %@ filePath: %@", fileInfo.name, filePath);
            if ([[fileInfo name] hasPrefix:filePath] == NO) {
                [unZipFile goToNextFileInZip];
                continue;
            }
            read = [unZipFile readCurrentFileInZip];
            data=  [[NSMutableData alloc] initWithLength:[fileInfo length]];
            int length = [read readDataWithBuffer:data];
            if (length != 0) {
                NSString *_filePath = [decFolderPath stringByAppendingPathComponent:[filePath lastPathComponent]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:decFolderPath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:decFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                [data writeToFile:_filePath atomically:YES];
            }
            if (data != nil) {
                [data release];
                data = nil;
            }
            [read finishedReading];
            [unZipFile goToNextFileInZip];
        }
    }
    [unZipFile close];
    [unZipFile release];
    unZipFile = nil;
}

+ (void)unzipByFile:(NSString*)zipPath filePaths:(NSArray*)filePaths decFolderPath:(NSString*)decFolderPath {
    ZipFile *unZipFile= [[ZipFile alloc] initWithFileName:zipPath mode:ZipFileModeUnzip];
    NSArray *fileArray = [unZipFile listFileInZipInfos];
    if (fileArray != nil && [fileArray count] > 0) {
        [unZipFile goToFirstFileInZip];
        ZipReadStream *read = nil;
        FileInZipInfo *fileInfo = nil;
        NSMutableData *data = nil;
        for (int i = 0; i < [fileArray count]; i++) {
            fileInfo = [unZipFile getCurrentFileInZipInfo];
            //NSLog(@"file Info name: %@ filePath: %@", fileInfo.name, filePath);
            NSString *suffixFilePath = nil;
            BOOL fileInfoNameHasSuffix = NO;
            for (NSString *pathStr in filePaths) {
                if([[fileInfo name] hasPrefix:pathStr]){
                    fileInfoNameHasSuffix = YES;
                    suffixFilePath = pathStr;
                    break;
                }
            }
            if (fileInfoNameHasSuffix == NO) {
                [unZipFile goToNextFileInZip];
                continue;
            }
            read = [unZipFile readCurrentFileInZip];
            data=  [[NSMutableData alloc] initWithLength:[fileInfo length]];
            int length = [read readDataWithBuffer:data];
            if (length != 0) {
                NSString *_filePath = [decFolderPath stringByAppendingPathComponent:[suffixFilePath lastPathComponent]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:decFolderPath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:decFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                [data writeToFile:_filePath atomically:YES];
            }
            if (data != nil) {
                [data release];
                data = nil;
            }
            [read finishedReading];
            [unZipFile goToNextFileInZip];
        }
    }
    [unZipFile close];
    [unZipFile release];
    unZipFile = nil;
}

+(NSArray *)unZipAppSyncFile:(NSString *)filePath tmpPath:(NSString *)tmpPath passWord:(NSString *)password{
    NSMutableArray *iconPaths = [NSMutableArray array];
    ZipFile *unZipFile= [[ZipFile alloc] initWithFileName:filePath mode:ZipFileModeUnzip];
    NSArray *fileArray = [unZipFile listFileInZipInfos];
    if (fileArray != nil && [fileArray count] > 0) {
        [unZipFile goToFirstFileInZip];
        ZipReadStream *read = nil;
        FileInZipInfo *fileInfo = nil;
        NSMutableData *data = nil;
        for (int i = 0; i < [fileArray count]; i++) {
            fileInfo = [unZipFile getCurrentFileInZipInfo];
            //NSLog(@"file Info name: %@ filePath: %@", fileInfo.name, filePath);
            NSString *fileName = [[fileInfo name] lastPathComponent];
            NSString *checkName = [fileName lowercaseString];
            NSString *suffixFilePath = nil;
            BOOL fileInfoNameHasSuffix = NO;
            BOOL needFile = [IMBZipHelper checkNeedFiles:checkName];
            if ([checkName isEqualToString:@"info.plist"] || [checkName isEqualToString:@"itunesmetadata.plist"] || [checkName isEqualToString:@"itunesartwork"] || needFile) {
                fileInfoNameHasSuffix = YES;
                suffixFilePath = [[fileInfo name] lastPathComponent];

            }
            if (fileInfoNameHasSuffix == NO) {
                [unZipFile goToNextFileInZip];
                continue;
            }
            read = [unZipFile readCurrentFileInZip];
            data=  [[NSMutableData alloc] initWithLength:[fileInfo length]];
            int length = [read readDataWithBuffer:data];
            if (length != 0) {
                NSString *_filePath = [tmpPath stringByAppendingPathComponent:[suffixFilePath lastPathComponent]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:tmpPath]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                [data writeToFile:_filePath atomically:YES];
            }
            if (data != nil) {
                [data release];
                data = nil;
            }
            if (needFile) {
                [iconPaths addObject:[fileInfo name]];
            }
            [read finishedReading];
            [unZipFile goToNextFileInZip];
        }
    }
    [unZipFile close];
    [unZipFile release];
    unZipFile = nil;
    return iconPaths;
}

+ (BOOL)checkNeedFiles:(NSString *)fileName{
    BOOL result = true;

    NSMutableString *mutFileName = [fileName mutableCopy];
    if ([mutFileName rangeOfString:@"icon-"].location != NSNotFound) {
        return true;
    }
    else{
        [mutFileName replaceOccurrencesOfString:@".png" withString:@"" options:nil range:NSMakeRange(0, mutFileName.length)];
        [mutFileName replaceOccurrencesOfString:@".jpg" withString:@"" options:nil range:NSMakeRange(0, mutFileName.length)];
        [mutFileName replaceOccurrencesOfString:@".jpeg" withString:@"" options:nil range:NSMakeRange(0, mutFileName.length)];
        if (mutFileName.length == 0) {
            result = false;
        }
        else{
            for (int i = 0; i < mutFileName.length; i++) {
                int charValue = [mutFileName characterAtIndex:i];
                if (charValue >= '0' && charValue <= '9'){
                    continue;
                }
                else{
                    result = false;
                    break;
                }
                return result;
            }
        }
    }
    [mutFileName release];
    return result;
}

@end
