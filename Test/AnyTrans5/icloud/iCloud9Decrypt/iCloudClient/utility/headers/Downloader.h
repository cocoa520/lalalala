//
//  IMBDownloader.h
//  InstallClamAv
//
//  Created by yuan on 15/3/5.
//  Copyright (c) 2015年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    Download_Success = 0,
    Download_Falied = 1,
    Download_Cancel = 2,
    Download_NetworkError = -1,
    Download_GetFileError =-2,
    Download_Start = -3,
    Download_UnknownError = -9
};
typedef NSInteger DownloadStatus;

@protocol DownloadUpdaterDelegate <NSObject>
@required
- (void)UpdaterStatus:(DownloadStatus)status download:(NSURLDownload *)download;

@optional
- (void)downloadProgress:(uint64_t)received withTotal:(uint64_t)total;

@end

@interface Downloader : NSObject<NSURLDownloadDelegate>
{
    NSString *_downloadFileUrlPath;
    NSString *_localFilePath;
    id<DownloadUpdaterDelegate> _listender;
    NSURLDownload *_downloadConn;
    NSURLResponse *_downloadResponse;
    uint64_t bytesReceived;
    BOOL _threadBreak;
}

@property (nonatomic,retain) NSString *downloadFileUrlPath;
@property (nonatomic,retain) NSString *localFilePath;
@property (nonatomic,retain) NSURLResponse *downloadResponse;
@property (nonatomic,assign) id<DownloadUpdaterDelegate> listener;

- (void)startToDownload;
- (void)cancelDownload;

@end
