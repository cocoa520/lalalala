//
//  IMBAMFileSystem.m
//  iMobieTrans
//
//  Created by Pallas on 4/1/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBAMFileSystem.h"
#import "IMBiPod.h"
#import "IMBDeviceInfo.h"
@implementation IMBAMFileSystem

- (id)initWithDevice:(id)device {
    self = [super initWithDevice:device];
    if (self) {
        _isIOSDevice = YES;
        _mediaDirectory = [[(AMDevice*)_device newAFCMediaDirectory] retain];
        _notifications = [[(AMDevice*)_device newAMNotificationProxy] retain];
        _crashLogDirectory = [[(AMDevice *)_device newAFCCrashLogDirectory] retain];
        _driveLetter = @"/";
        _itunesFolderPath = AM_iTunes_Folder_Path;
        _ipodControlFolderPath = @"iTunes_Control/";
        _artworkFolderPath = @"iTunes_Control/Artwork/";
        _photoFolderPath = @"Photos/";
        
        _artworkDBPath = [[_driveLetter stringByAppendingPathComponent:_artworkFolderPath]
                          stringByAppendingPathComponent:@"ArtworkDB"];
        _itunesLockPath = [[_driveLetter stringByAppendingPathComponent:_itunesFolderPath] stringByAppendingPathComponent:@"iTunesLock"];
        _playCountsPath = [[_driveLetter stringByAppendingPathComponent:_itunesFolderPath] stringByAppendingPathComponent:@"Play Counts"];
    }
    return self;
}

- (void)closeMediaDirService
{
    [_mediaDirectory close];
    [_mediaDirectory release];
    _mediaDirectory = nil;
}

- (void)dealloc {
    if (_crashLogDirectory != nil) {
        [_crashLogDirectory close];
        [_crashLogDirectory release];
        _crashLogDirectory = nil;
    }
    if (_mediaDirectory != nil) {
        [_mediaDirectory close];
        [_mediaDirectory release];
        _mediaDirectory = nil;
    }
    if (_syncLockFile != nil){
        [_syncLockFile release];
        _syncLockFile = nil;
    }
    [super dealloc];
}

- (BOOL)fileExistsAtPath:(NSString*)filePath {
    return [_mediaDirectory fileExistsAtPath:filePath];
}

- (int64_t)getFolderSize:(NSString *)folderPath {
    return [_mediaDirectory getFolderSize:folderPath];
}

- (long long)getFileLength:(NSString*)filePath {
    return [[[_mediaDirectory getFileInfo:filePath] valueForKey:@"st_size"] longLongValue];
}

- (NSDictionary *)getFileInfo:(NSString *)filePath
{
    return [_mediaDirectory getFileInfo:filePath];
}

- (BOOL)unlink:(NSString*)filePath {
    return [_mediaDirectory unlink:filePath];
}

- (BOOL)unlinkFolder:(NSString *)path {
    return [_mediaDirectory unlinkFolder:path];
}

- (NSArray*)getItemInDirectory:(NSString*)filePath {
    return [_mediaDirectory getItemInDirectory:filePath];
}

- (NSArray*)getItemInDirWithoutRootDir:(NSString*)filePath {
    return [_mediaDirectory getItemInDirWithoutRootDir:filePath];
}

- (BOOL)copyRemoteFile:(NSString*)remoteFile toLocalFile:(NSString*)toLocalFile {
    return [_mediaDirectory copyRemoteFile:remoteFile toLocalFile:toLocalFile];
}

- (BOOL)asyncCopyRemoteFile:(NSString *)remoteFile toLocalFile:(NSString *)toLocalFile {
    return [_mediaDirectory asyncCopyRemoteFile:remoteFile toLocalFile:toLocalFile];
}

- (BOOL)exportZipFile:(NSString*)zipFilePath fromRemoteFilePath:(NSString*)remoteFilePath {
    return NO;//[_mediaDirectory exportZipFile:zipFilePath fromRemoteFilePath:remoteFilePath];
}

- (BOOL)copyLocalFile:(NSString*)localPath toRemoteFile:(NSString*)toRemoteFile {
    return [_mediaDirectory copyLocalFile:localPath toRemoteFile:toRemoteFile];
}

- (BOOL)copyDataToFile:(NSData *)localdata toRemoteFile:(NSString *)toRemoteFile {
    return [_mediaDirectory copyDataToFile:localdata toRemoteFile:toRemoteFile];
}

- (BOOL)copyFileBetweenDevice:(NSString*)srcFileName sourDriverLetter:(NSString*)srcDriverLetter targFileName:(NSString*)targFileName targDriverLetter:(NSString*)targDriverLetter sourDevice:(id)srcDevice {
    NSString* sourceFileFullPath = [srcDriverLetter stringByAppendingPathComponent:srcFileName];
    NSString* targetFileFullPath = [targDriverLetter stringByAppendingPathComponent:targFileName];
    //如果两个都是USB设备的话就直接拷贝
    IMBiPod *sourceiPod = (IMBiPod*)srcDevice;
    if (sourceiPod != nil && !sourceiPod.deviceInfo.isIOSDevice) {
        return [self copyLocalFile:sourceFileFullPath toRemoteFile:targetFileFullPath];
    } else {
        return [_mediaDirectory copyFile:sourceFileFullPath sourcAFCDir:[sourceiPod.fileSystem afcMediaDirectory] toFile:targetFileFullPath];
    }
}

- (BOOL)recursiveCopyFileBetweenDevice:(NSString*)srcPath tarPath:(NSString*)tarPath sourDevice:(id)srcDevice {
    //如果两个都是USB设备的话就直接拷贝
    IMBiPod *sourceiPod = (IMBiPod*)srcDevice;
    if (sourceiPod != nil && !sourceiPod.deviceInfo.isIOSDevice) {
        return false;
    } else {
        [_mediaDirectory recursiveCopyFile:srcPath sourcAFCDir:[sourceiPod.fileSystem afcMediaDirectory] toPath:tarPath];
    }
    return true;
}

- (BOOL)moveFileToDestPath:(NSString*)sourPath destPath:(NSString*)destPath {
    return [_mediaDirectory rename:sourPath to:destPath];;
}

- (BOOL)copyFile:(NSString *)sourPath copyTo:(NSString *)copyTo {
    return [_mediaDirectory copyFile:sourPath toFile:copyTo];
}

- (BOOL)mkDir:(NSString*)dirPath {
    return [_mediaDirectory mkdir:dirPath];
}

- (BOOL)rename:(NSString*)oldPath newPath:(NSString*)newPath {
    return [_mediaDirectory rename:oldPath to:newPath];
}

- (void)eject {
    
}

- (void)startSync:(BOOL)openStatus {
    if (_isSyncing == NO) {
        if (_mediaDirectory != nil) {
            if ([self fileExistsAtPath:@"/com.apple.itunes.lock_sync"]) {
                [self unlink:@"/com.apple.itunes.lock_sync"];
            }
            if (openStatus == YES) {
                if (_syncLockFile != nil) {
                    [_syncLockFile lock:480];
                    [_syncLockFile unLock];
                    [_syncLockFile closeFile];
                    _syncLockFile = nil;
                    _isSyncing = NO;
                }
            }
            /*
            else {
                if ([self fileExistsAtPath:@"/com.apple.itunes.lock_sync"]) {
                    [self unlink:@"/com.apple.itunes.lock_sync"];
                }
            }
            */
            usleep(1000);
            _isSyncing = YES;
            if (_syncLockFile != nil) return;
            [_notifications postNotification:@"com.apple.itunes-mobdev.syncWillStart"];
            _syncLockFile = [[_mediaDirectory openForReadWrite:@"/com.apple.itunes.lock_sync"] retain];
            [_notifications postNotification:@"com.apple.itunes-mobdev.syncLockRequest"];
            [_syncLockFile lock:40];
        }
    }
}

- (void)endSync {
    if (_mediaDirectory != nil) {
        if (_isSyncing == YES) {
            if (_syncLockFile != nil) {
                [_syncLockFile unLock];
                [_syncLockFile closeFile];
                _syncLockFile = nil;
            }
            _isSyncing = NO;
            [_notifications postNotification:@"com.apple.itunes-mobdev.syncDidFinish"];
        }
    }
}

- (NSString*)combinePath:(NSString*)path pathComponent:(NSString*)pathComponent {
    NSString *combined = [path stringByAppendingPathComponent:pathComponent];
    return [combined stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
}

- (id)openForRead:(NSString*)path {
    return [_mediaDirectory openForRead:path];
}

- (NSArray*)recursiveDirectoryContentsDics:(NSString*)path{
    return [_mediaDirectory recursiveDirectoryContentsDics:path];
}

- (id)openForWrite:(NSString*)path {
    return [_mediaDirectory openForWrite:path];
}

- (id)openForReadWrite:(NSString*)path {
    return [_mediaDirectory openForReadWrite:path];
}

-(id) afcMediaDirectory {
    return _mediaDirectory;
}

- (id)afcCrashlogsDirectory {
    return _crashLogDirectory;
}

@end
