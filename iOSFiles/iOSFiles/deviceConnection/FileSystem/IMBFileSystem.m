//
//  IMBFileSystem.m
//  iMobieTrans
//
//  Created by Pallas on 4/1/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBFileSystem.h"

@implementation IMBFileSystem

- (id)initWithDevice:(id)device {
    self = [super init];
    if (self) {
        _device = [device retain];
    }
    return self;
}

- (void)dealloc {
    if (_device != nil) {
        [_device release];
        _device = nil;
    }
    [super dealloc];
}

- (NSString*)driveLetter {
    return _driveLetter;
}

- (NSDictionary *)getFileInfo:(NSString *)filePath {
    return nil;
}

- (void)setDriveLetter:(NSString*)value {
    if ([_driveLetter isEqualToString:value] == NO) {
        [_driveLetter release];
        _driveLetter = [value copy];
    }
}

- (NSString*)iPodControlPath {
    //iPodControlPath = [_driveLetter stringByAppendingPathComponent:_ipodControlFolderPath];
    return [_driveLetter stringByAppendingPathComponent:_ipodControlFolderPath];
}

- (void)setiPodControlPath:(NSString*)value {
    if ([_ipodControlFolderPath isEqualToString:value] == NO) {
        [_ipodControlFolderPath release];
        _ipodControlFolderPath = [value copy];
    }
}

- (NSString*)iTunesFolderPath {
    return [_driveLetter stringByAppendingPathComponent:_itunesFolderPath];
}

- (void)setiTunesFolderPath:(NSString*)value {
    if ([_itunesFolderPath isEqualToString:value] == NO) {
        [_itunesFolderPath release];
        _itunesFolderPath = [value copy];
    }
}

- (NSString*)artworkFolderPath {
    return [_driveLetter stringByAppendingPathComponent:_artworkFolderPath];
}

- (void)setArtworkFolderPath:(NSString*)value {
    if ([_artworkFolderPath isEqualToString:value] == NO) {
        [_artworkFolderPath release];
        _artworkFolderPath = [value copy];
    }
}

- (NSString*)photoFolderPath {
    return [_driveLetter stringByAppendingPathComponent:_photoFolderPath];
    //return _photoFolderPath;
}

- (void)setPhotoFolderPath:(NSString*)value {
    if ([_photoFolderPath isEqualToString:value] == NO) {
        [_photoFolderPath release];
        _photoFolderPath = [value copy];
    }
}

- (NSString*)artworkDBPath {
    return [[_driveLetter stringByAppendingPathComponent:_artworkFolderPath] stringByAppendingPathComponent:@"ArtworkDB"];
    //return _artworkDBPath;
}

- (NSString*)photoDBPath {
    return [[_driveLetter stringByAppendingPathComponent:_photoFolderPath] stringByAppendingPathComponent:@"Photo Database"];
    //return _photoDBPath;
}

- (NSString*)iTunesSDPath {
    return [[_driveLetter stringByAppendingPathComponent:_itunesFolderPath] stringByAppendingPathComponent:@"iTunesSD"];
    //return _iTunesSDPath;
}

- (NSString*)playCountPath {    
    if (_isIOSDevice) {
        return [[_driveLetter stringByAppendingPathComponent:_itunesFolderPath] stringByAppendingPathComponent:@"Play Counts"];
    } else {
        return [[_driveLetter stringByAppendingPathComponent:_itunesFolderPath] stringByAppendingPathComponent:@"PlayCounts.plist"];
    }
    return _playCountsPath;
}

- (NSString*)iTunesLockPath {
    return [[_driveLetter stringByAppendingPathComponent:_itunesFolderPath] stringByAppendingPathComponent:@"iTunesLock"];
}

- (BOOL)fileExistsAtPath:(NSString*)filePath {
    return NO;
}

- (long long)getFileLength:(NSString*)filePath {
    return 0;
}

- (int64_t)getFolderSize:(NSString *)folderPath {
    return 0;
}


- (BOOL)unlink:(NSString*)filePath {
    return NO;
}

- (BOOL)unlinkFolder:(NSString *)path {
    return NO;
}

- (NSArray*)getItemInDirectory:(NSString*)filePath {
    return nil;
}

- (NSArray*)getItemInDirWithoutRootDir:(NSString*)filePath {
    return nil;
}

- (BOOL)copyRemoteFile:(NSString*)remoteFile toLocalFile:(NSString*)toLocalFile {
    return NO;
}

- (BOOL)asyncCopyRemoteFile:(NSString *)remoteFile toLocalFile:(NSString *)toLocalFile {
    return NO;
}

- (BOOL)exportZipFile:(NSString*)zipFilePath fromRemoteFilePath:(NSString*)remoteFilePath {
    return NO;
}

- (BOOL)copyLocalFile:(NSString*)localPath toRemoteFile:(NSString*)toRemoteFile {
    return NO;
}

- (BOOL)copyDataToFile:(NSData *)localdata toRemoteFile:(NSString *)toRemoteFile {
    return NO;
}

- (BOOL)copyFileBetweenDevice:(NSString*)srcFileName srcDriverLetter:(NSString*)sourceDriverLetter targFileName:(NSString*)
  targFileName targDriverLetter:(NSString*)targDriverLetter sourDevice:(id)srcDevice {
    return NO;
}

- (BOOL)copyFileBetweenDevice:(NSString *)sourFileName sourDriverLetter:(NSString *)sourDriverLetter targFileName:(NSString *)targFileName targDriverLetter:(NSString *)targDriverLetter sourDevice:(id)sourDevice{
    return NO;
}

- (BOOL)moveFileToDestPath:(NSString*)sourPath destPath:(NSString*)destPath {
    return NO;
}

- (BOOL)copyFile:(NSString *)sourPath copyTo:(NSString *)copyTo {
    return NO;
}

- (BOOL)mkDir:(NSString*)dirPath {
    return NO;
}

- (BOOL)rename:(NSString*)oldPath newPath:(NSString*)newPath {
    return NO;
}

- (void)eject {
    
}

- (void)startSync:(BOOL)openStatus {
    
}

- (void)endSync {
    
}

- (NSString*)combinePath:(NSString*)path pathComponent:(NSString*)Component {
    return nil;
}

- (id)openForRead:(NSString*)path {
    return nil;
}

- (NSArray*)recursiveDirectoryContentsDics:(NSString*)path{
    return nil;
}


- (id)openForWrite:(NSString*)path {
    return nil;
}

- (id)openForReadWrite:(NSString*)path {
    return nil;
}

-(id) afcMediaDirectory {
    return nil;
}

- (id)afcCrashlogsDirectory {
    return nil;
}

- (BOOL)recursiveCopyFileBetweenDevice:(NSString*)srcPath tarPath:(NSString*)tarPath sourDevice:(id)srcDevice {
    return true;
}

- (BOOL)stringIsNilOrEmpty:(NSString*)string {
    if (string == nil || [string isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

@end
