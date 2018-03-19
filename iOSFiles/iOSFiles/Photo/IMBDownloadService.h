//
//  IMBDownloadService.h
//  iCloudDriveDemo
//
//  Created by iMobie on 2/6/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBLogManager.h"

typedef void(^ProgressBlock)(float percent);

@interface IMBDownloadService : NSObject <NSURLConnectionDataDelegate,NSURLConnectionDelegate> {
    NSMutableData *_dataM;
    NSString *_cachePath;
    long long _fileLength;
    long long _currentLength;
//    ProgressBlock _progress;
    NSString *_downloadPath;
    NSURLConnection *_connection;
    
    NSFileManager *fm;
    BOOL _finished;
    NSString *_docwsid;
    BOOL _isUpload;
    NSNotificationCenter *nc;
    long long _folderSize;
    BOOL _isDownloadFolder;
    NSString *_downloadName;
    NSString *_downloadFolderName;
    
    long long _specialSize;
    BOOL _isDownloadSpecialFile;
    IMBLogManager *_loghandle;
    long long _specialFileDownloadSize;
    
    BOOL _isStop;
    NSString *_rangeStr;
    
    BOOL _isSuccess;
    NSString *_successStr;
}
@property (nonatomic, retain) NSString *successStr;
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, assign) BOOL finished;
@property (nonatomic, assign) BOOL isDownloadFolder;
@property (nonatomic, assign) long long folderSize;
@property (nonatomic, assign) BOOL isDownloadSpecialFile;
@property (nonatomic, assign) long long specialSize;
@property (nonatomic, retain) NSString *docwsid;
@property (nonatomic, assign) long long specialFileDownloadSize;

@property (nonatomic, retain) NSMutableData *dataM;
@property (nonatomic, retain) NSString *downloadName;
@property (nonatomic, retain) NSString *downloadFolderName;
// 保存在沙盒中的文件路径
@property (nonatomic, retain) NSString *cachePath;
// 文件总长度
@property (nonatomic, assign) long long fileLength;
// 当前下载的文件长度
@property (nonatomic, assign) long long currentLength;
// 回调块代码
//@property (nonatomic, copy) ProgressBlock progress;

- (id)initWithPath:(NSString *)path;

- (id)initWithUpload;

- (void)cancelConnection;

- (void)setDownloadPath:(NSString *)path;

//异步下载
- (void)downloadWithHeaders:(NSDictionary *)headers withHost:(NSString *)host withPath:(NSString *)path withRange:(NSString *)rangeStr progress:(void (^)(float))progress;

//上传文件
- (void)uploadWithData:(NSData *)body withHeaders:(NSDictionary *)headers withHost:(NSString *)host withPath:(NSString *)path progress:(void (^)(float))progress;

- (void)uploadWithDataFromPhoto:(NSString *)filePath withHeaders:(NSDictionary *)headers withHost:(NSString *)host withPath:(NSString *)path progress:(void (^)(float))progress;

@end
