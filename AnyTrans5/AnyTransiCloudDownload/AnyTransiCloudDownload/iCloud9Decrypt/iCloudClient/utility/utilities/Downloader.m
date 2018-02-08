//
//  Downloader.m
//  InstallClamAv
//
//  Created by Pallas on 15/3/5.
//  Copyright (c) 2015年 Pallas. All rights reserved.
//

#import "Downloader.h"

@implementation Downloader
@synthesize downloadFileUrlPath = _downloadFileUrlPath;
@synthesize localFilePath = _localFilePath;
@synthesize downloadResponse = _downloadResponse;
@synthesize listener = _listender;

- (void)startToDownload{
    dispatch_async(dispatch_queue_create("download queue", NULL), ^{
        @autoreleasepool {
            if (_downloadFileUrlPath == nil) {
                return;
            }
            _threadBreak = NO;
            NSFileManager *fm = [NSFileManager defaultManager];
            
            if ([fm fileExistsAtPath:_localFilePath]) {
                [fm removeItemAtPath:_localFilePath error:nil];
            }
            
            NSURL *url = [NSURL URLWithString:_downloadFileUrlPath];
            NSURL *tmpUrl = [url copy];
            NSURLRequest *request = [NSURLRequest requestWithURL:tmpUrl];
#if !__has_feature(objc_arc)
    if (tmpUrl) [tmpUrl release]; tmpUrl = nil;
#endif
            if (_downloadConn != nil) {
                [_downloadConn release];
                _downloadConn = nil;
            }
            
            _downloadConn = [[NSURLDownload alloc] initWithRequest:request delegate:self];
            
            while (!_threadBreak) {
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
            }
        }
    });
}

- (void)cancelDownload {
    if (_downloadConn != nil) {
        _threadBreak = YES;
        [_downloadConn cancel];
        [_listender UpdaterStatus:Download_Success download:_downloadConn];
    }
}

- (void)setDownloadResponse:(NSURLResponse *)downloadResponse {
    if (_downloadResponse != downloadResponse) {
        if (_downloadResponse != nil) [_downloadResponse release];
        _downloadResponse = [downloadResponse retain];
    }
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response {
    bytesReceived = 0;
    [self setDownloadResponse:response];
}

- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:_localFilePath]) {
        [fm removeItemAtPath:_localFilePath error:nil];
    }
    [_listender UpdaterStatus:Download_Start download:download];
    [download setDestination:_localFilePath allowOverwrite:NO];
}

- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length {
    uint64_t expectedLength = [[self downloadResponse] expectedContentLength];
    bytesReceived = bytesReceived + length;
    if (expectedLength != NSURLResponseUnknownLength) {
        if (self.listener != nil && [self.listener respondsToSelector:@selector(downloadProgress:withTotal:)]) {
            [self.listener downloadProgress:bytesReceived withTotal:expectedLength];
        }
    } else {
        if (self.listener != nil && [self.listener respondsToSelector:@selector(downloadProgress:withTotal:)]) {
            [self.listener downloadProgress:bytesReceived withTotal:0];
        }
    }
}

- (void)downloadDidFinish:(NSURLDownload *)download{
    _threadBreak = YES;
    [_listender UpdaterStatus:Download_Success download:download];
}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error{
    _threadBreak = YES;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:self.localFilePath]) {
        [fm removeItemAtPath:self.localFilePath error:nil];
    }
    if (_listender != nil && [_listender respondsToSelector:@selector(UpdaterStatus:download:)]) {
        [_listender UpdaterStatus:Download_Falied download:download];
    }
}

- (void)setListener:(id)listener{
    _listender = listener;
}

- (void)dealloc{
    if (_downloadConn != nil) [_downloadConn release]; _downloadConn = nil;
    if (_localFilePath != nil) [_localFilePath release], _localFilePath = nil;
    if (_downloadFileUrlPath != nil) [_downloadFileUrlPath release], _downloadFileUrlPath = nil;
    if (_downloadResponse != nil) [_downloadResponse release]; _downloadResponse = nil;
    [super dealloc];
}

@end
