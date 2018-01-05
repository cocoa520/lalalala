//
//  IMBDownloadFile.h
//  DataRecovery
//
//  Created by iMobie on 3/19/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMBDownLoadProgress
@required
- (void)downProgressWithFileName:(NSString*)fileName withProgress:(double)progress;
- (void)downErrorWithFileName:(NSString*)fileName withError:(NSString*)error;
- (void)downComplete:(NSString*)fileName;

@end

@interface IMBDownloadFile : NSObject <NSURLDownloadDelegate>{
@private
    id _delegate;
    NSString *_downFolderLocalPath;
    NSString *_downFileName;
    NSString *_downFileLocalPath;
    NSString *_downloadFileUrlPath;
    
    int64_t _expectedContentLength;
    int64_t _bytesReceived;
    NSFileManager *fm;
    
    NSURLDownload *_theDownload;
    BOOL _isDownloadPlist;
}
@property (nonatomic, retain) NSString *downFileName;

- (id)initWithDelegate:(id)delegate downloadUrlPath:(NSString *)downloadUrlPath isDownloadPlist:(BOOL)isDownloadPlist;
- (id)initWithDelegate:(id)delegate downloadUrlPath:(NSString *)downloadUrlPath isDownloadPlist:(BOOL)isDownloadPlist downFileName:(NSString *)downFileName;

//下载指定文件
- (BOOL)downloadSpecifiedFile;
- (void)cancelDownload;

@end
