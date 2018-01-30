//
//  IMBAMFileSystem.h
//  iMobieTrans
//
//  Created by Pallas on 4/1/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBFileSystem.h"

@interface IMBAMFileSystem : IMBFileSystem {
@private
    AFCMediaDirectory *_mediaDirectory;
    AMNotificationProxy *_notifications;
    AFCFileReference *_syncLockFile;
    AFCCrashLogDirectory *_crashLogDirectory;
}

- (id)initWithDevice:(id)device;

- (BOOL)fileExistsAtPath:(NSString*)filePath;
- (long long)getFileLength:(NSString*)filePath;
- (int64_t)getFolderSize:(NSString *)folderPath;
- (BOOL)unlink:(NSString*)filePath;
- (NSArray*)getItemInDirectory:(NSString*)filePath;
- (BOOL)copyRemoteFile:(NSString*)remoteFile toLocalFile:(NSString*)toLocalFile;
- (BOOL)exportZipFile:(NSString*)zipFilePath fromRemoteFilePath:(NSString*)remoteFilePath;
- (BOOL)copyLocalFile:(NSString*)localPath toRemoteFile:(NSString*)toRemoteFile;
- (BOOL)copyFileBetweenDevice:(NSString*)sourFileName sourDriverLetter:(NSString*)sourDriverLetter targFileName:(NSString*)targFileName targDriverLetter:(NSString*)targDriverLetter sourDevice:(id)sourDevice;
- (BOOL)moveFileToDestPath:(NSString*)sourPath destPath:(NSString*)destPath;
- (BOOL)mkDir:(NSString*)dirPath;
- (BOOL)rename:(NSString*)oldPath newPath:(NSString*)newPath;
- (void)eject;
- (void)startSync:(BOOL)openStatus;
- (void)endSync;
- (NSString*)combinePath:(NSString*)path pathComponent:(NSString*)pathComponent;
- (id)openForRead:(NSString*)path;
- (NSArray*)recursiveDirectoryContentsDics:(NSString*)path;
- (id)openForWrite:(NSString*)path;
- (id)openForReadWrite:(NSString*)path;
- (BOOL)recursiveCopyFileBetweenDevice:(NSString*)srcPath tarPath:(NSString*)tarPath sourDevice:(id)srcDevice;

@end
