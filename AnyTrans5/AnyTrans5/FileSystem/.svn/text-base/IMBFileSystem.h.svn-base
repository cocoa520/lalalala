//
//  IMBFileSystem.h
//  iMobieTrans
//
//  Created by Pallas on 4/1/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileDeviceAccess.h"

#define AM_iTunes_Folder_Path @"/iTunes_Control/iTunes"
#define USB_iTunes_Folder_Path @"iPod_Control/iTunes/"
@interface IMBFileSystem : NSObject {
    id _device;
    BOOL _isSyncing;
@protected
    BOOL _isIOSDevice;
    NSString *_driveLetter;                     
    NSString *_itunesFolderPath;               
    NSString *_ipodControlFolderPath;           
    NSString *_artworkFolderPath;               
    NSString *_photoFolderPath;
    
    NSString *_iPodControlPath;
    NSString *_artworkDBPath;
    NSString *_itunesLockPath;
    NSString *_playCountsPath;
    NSString *_photoDBPath;
    NSString *_iTunesSDPath;
}

@property (nonatomic, getter = driveLetter, setter = setDriveLetter:, readwrite, copy) NSString *driveLetter;
- (NSString*)driveLetter;
- (void)setDriveLetter:(NSString*)value;
@property (nonatomic, getter = iPodControlPath, setter = setiPodControlPath:, readwrite, copy) NSString *iPodControlPath;
- (NSString*)iPodControlPath;
- (void)setiPodControlPath:(NSString*)value;
@property (nonatomic, getter = iTunesFolderPath, setter = setiTunesFolderPath:, readwrite, copy) NSString *iTunesFolderPath;
- (NSString*)iTunesFolderPath;
- (void)setiTunesFolderPath:(NSString*)value;
@property (nonatomic, getter = artworkFolderPath, setter = setArtworkFolderPath:, readwrite, copy) NSString *artworkFolderPath;
- (NSString*)artworkFolderPath;
- (void)setArtworkFolderPath:(NSString*)value;
@property (nonatomic, getter = photoFolderPath, setter = setPhotoFolderPath:, readwrite, copy) NSString *photoFolderPath;
- (NSString*)photoFolderPath;
- (void)setPhotoFolderPath:(NSString*)value;
@property (nonatomic, getter = artworkDBPath, readonly, copy) NSString *artworkDBPath;
- (NSString*)artworkDBPath;
@property (nonatomic, getter = photoDBPath, readonly, copy) NSString *photoDBPath;
- (NSString*)photoDBPath;
@property (nonatomic, getter = iTunesSDPath, readonly, copy) NSString *iTunesSDPath;
- (NSString*)iTunesSDPath;
@property (nonatomic, getter = playCountPath, readonly, copy) NSString *playCountPath;
- (NSString*)playCountPath;
@property (nonatomic, getter = iTunesLockPath, readonly, copy) NSString *iTunesLockPath;
- (NSString*)iTunesLockPath;

- (id)initWithDevice:(id)device;
- (NSDictionary *)getFileInfo:(NSString *)filePath;
// 判断文件是否存在
- (BOOL)fileExistsAtPath:(NSString*)filePath;
// 得到文件信息
- (long long)getFileLength:(NSString*)filePath;
//获取文件夹的大小
- (int64_t)getFolderSize:(NSString *)folderPath;
// 删除一个文件
- (BOOL)unlink:(NSString*)filePath;
// 删除一个目录
- (BOOL)unlinkFolder:(NSString *)path;
// 得到文件夹下的所有文件信息
- (NSArray*)getItemInDirectory:(NSString*)filePath;
//不要根目录的信息
- (NSArray*)getItemInDirWithoutRootDir:(NSString*)filePath;
// 将一个设备文件拷贝到本地磁盘
- (BOOL)copyRemoteFile:(NSString*)remoteFile toLocalFile:(NSString*)toLocalFile;
- (BOOL)asyncCopyRemoteFile:(NSString *)remoteFile toLocalFile:(NSString *)toLocalFile;
//将远程文件或者文件夹导出到本地压缩文件中去
- (BOOL)exportZipFile:(NSString*)zipFilePath fromRemoteFilePath:(NSString*)remoteFilePath;
// 将本地文件拷贝进设备中
- (BOOL)copyLocalFile:(NSString*)localPath toRemoteFile:(NSString*)toRemoteFile;
//将photo data拷贝到设备中
- (BOOL)copyDataToFile:(NSData *)localdata toRemoteFile:(NSString *)toRemoteFile;
// 将源设备的文件拷贝到目标设备当中去
- (BOOL)copyFileBetweenDevice:(NSString*)sourFileName sourDriverLetter:(NSString*)sourDriverLetter targFileName:(NSString*)targFileName targDriverLetter:(NSString*)targDriverLetter sourDevice:(id)sourDevice;
// 将设备中的文件移动到指定的目标路径
- (BOOL)moveFileToDestPath:(NSString*)sourPath destPath:(NSString*)destPath;
// 将设备中的文件拷贝到指定的路径下去
- (BOOL)copyFile:(NSString *)sourPath copyTo:(NSString *)copyTo;
// 创建一个文件夹
- (BOOL)mkDir:(NSString*)dirPath;
// 将设备中的文件重命名
- (BOOL)rename:(NSString*)oldPath newPath:(NSString*)newPath;
// 退出设备
- (void)eject;
// 开始同步
- (void)startSync:(BOOL)openStatus;
// 结束同步
- (void)endSync;
// 组合路径
- (NSString*)combinePath:(NSString*)path pathComponent:(NSString*)pathComponent;
// 打开文件的读取句柄
- (id)openForRead:(NSString*)path;

//遍历文件内容，获取文件信息
- (NSArray*)recursiveDirectoryContentsDics:(NSString*)path;

// 打开文件的写句柄
- (id)openForWrite:(NSString*)path;
// 打开文件的读写句柄
- (id)openForReadWrite:(NSString*)path;
// 得到媒体的Directory
-(id) afcMediaDirectory;

- (id)afcCrashlogsDirectory;
//递归拷贝一个目录到另外一个设备 现在的情况只有ios设备才有此需求
- (BOOL)recursiveCopyFileBetweenDevice:(NSString*)srcPath tarPath:(NSString*)tarPath sourDevice:(id)srcDevice;

- (BOOL)stringIsNilOrEmpty:(NSString*)string;

- (void)closeMediaDirService;
@end
