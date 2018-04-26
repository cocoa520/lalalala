//
//  IMBDownloadService.m
//  iCloudDriveDemo
//
//  Created by iMobie on 2/6/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import "IMBDownloadService.h"
#import "TempHelper.h"
#import "IMBZipHelper.h"
#import "IMBNotificationDefine.h"
@implementation IMBDownloadService
@synthesize dataM = _dataM;
@synthesize cachePath = _cachePath;
@synthesize fileLength = _fileLength;
@synthesize currentLength = _currentLength;
//@synthesize progress = _progress;
@synthesize finished = _finished;
@synthesize docwsid = _docwsid;
@synthesize folderSize = _folderSize;
@synthesize isDownloadFolder = _isDownloadFolder;
@synthesize isDownloadSpecialFile = _isDownloadSpecialFile;
@synthesize specialSize = _specialSize;
@synthesize downloadName = _downloadName;
@synthesize downloadFolderName = _downloadFolderName;
@synthesize specialFileDownloadSize = _specialFileDownloadSize;
@synthesize isSuccess = _isSuccess;
@synthesize successStr =_successStr;

- (id)initWithPath:(NSString *)path {
    if (self = [super init]) {
        _cachePath = [[TempHelper getAppDownloadCachePath] retain];
        _fileLength = 0;
        _currentLength = 0;
        _downloadPath = [path retain];
        _isUpload = NO;
        _folderSize = 0;
        _isDownloadFolder = NO;
        _specialSize = 0;
        _isDownloadSpecialFile = NO;
        _downloadName = @"";
        _downloadFolderName = @"";
        nc = [NSNotificationCenter defaultCenter];
        _loghandle = [IMBLogManager singleton];
        fm = [NSFileManager defaultManager];
        _specialFileDownloadSize = 0;
        [nc addObserver:self selector:@selector(stopDownload:) name:NOTITY_ICLOUD_STOP_DOWNLOAD object:nil];
    }
    return self;
}

- (id)initWithUpload {
    if (self = [super init]) {
        _dataM= [[NSMutableData alloc] init];
        _fileLength = 0;
        _currentLength = 0;
        _isUpload = YES;
        fm = [NSFileManager defaultManager];
    }
    return self;
}

- (void)setDownloadPath:(NSString *)path {
    if (_downloadPath != nil) {
        [_downloadPath release];
        _downloadPath = nil;
    }
    _downloadPath = [path retain];
}

- (void)dealloc {
    [nc removeObserver:self name:NOTITY_ICLOUD_STOP_DOWNLOAD object:nil];
    if (_dataM != nil) {
        [_dataM release];
        _dataM = nil;
    }
    if (_downloadPath != nil) {
        [_downloadPath release];
        _downloadPath = nil;
    }
    if (_cachePath != nil) {
        [_cachePath release];
        _cachePath = nil;
    }
    if (_rangeStr != nil) {
        [_rangeStr release];
        _rangeStr = nil;
    }
    if (_successStr != nil) {
        [_successStr release];
        _successStr = nil;
    }
//    if (_progress != nil) {
//        Block_release(_progress);
//        _progress = nil;
//    }
    [super dealloc];
}

- (void)downloadWithHeaders:(NSDictionary *)headers withHost:(NSString *)host withPath:(NSString *)path withRange:(NSString *)rangeStr progress:(void (^)(float))progress {
    // 0. 记录块代码
    if (_dataM != nil) {
        [_dataM release];
        _dataM = nil;
    }
    _dataM= [[NSMutableData alloc] init];
//    if (self.progress != nil) {
//        NSLog(@"self.progress:%@",self.progress);
//        Block_release(self.progress);
//        self.progress = nil;
//    }
//    self.progress = progress;
    
    NSString *url = [NSString stringWithFormat:@"%@%@",host,path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest addValue:[host stringByReplacingOccurrencesOfString:@"https://" withString:@""] forHTTPHeaderField:@"Host"];
    if (headers != nil && headers.allKeys.count > 0) {
        NSArray *allkeys = headers.allKeys;
        for (NSString *key in allkeys) {
            [urlRequest addValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    //设置请求实体的字节范围
    if (_rangeStr != nil) {
        [_rangeStr release];
        _rangeStr = nil;
    }
    _rangeStr = [rangeStr retain];
    [urlRequest addValue:rangeStr forHTTPHeaderField:@"Range"];
    
    _connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
    [_connection setDelegateQueue:[[NSOperationQueue alloc] init]];
    
    [_connection start];
    _finished = NO;
    while (!_finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
    
}

- (void)uploadWithData:(NSData *)body withHeaders:(NSDictionary *)headers withHost:(NSString *)host withPath:(NSString *)path progress:(void (^)(float))progress {
    // 记录块代码
//    self.progress = progress;
    
    NSString *url = [NSString stringWithFormat:@"%@%@", host, path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:[host stringByReplacingOccurrencesOfString:@"https://" withString:@""] forHTTPHeaderField:@"Host"];
    [urlRequest setHTTPBody:body];
    if (headers != nil && headers.allKeys.count > 0) {
        NSArray *allkeys = headers.allKeys;
        for (NSString *key in allkeys) {
            id value = [headers objectForKey:key];
            [urlRequest addValue:value forHTTPHeaderField:key];
        }
    }

//    [urlRequest addValue:@"multipart/form-data; boundary=----WebKitFormBoundary1IR5qsBwtCYcLQaJ" forHTTPHeaderField:@"Content-Type"];
    
//    [urlRequest setHTTPBodyStream:[NSInputStream inputStreamWithData:body]];
    
    _connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
//    [_connection setDelegateQueue:[[NSOperationQueue alloc] init]];
    
    [_connection start];
    _finished = NO;
    while (!_finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)uploadWithDataFromPhoto:(NSString *)filePath withHeaders:(NSDictionary *)headers withHost:(NSString *)host withPath:(NSString *)path progress:(void (^)(float))progress {
    // 记录块代码
//    self.progress = progress;
    
    NSString *url = [NSString stringWithFormat:@"%@%@", host, path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest addValue:[host stringByReplacingOccurrencesOfString:@"https://" withString:@""] forHTTPHeaderField:@"Host"];
//    [urlRequest setHTTPBody:body];
    if (headers != nil && headers.allKeys.count > 0) {
        NSArray *allkeys = headers.allKeys;
        for (NSString *key in allkeys) {
            id value = [headers objectForKey:key];
            [urlRequest addValue:value forHTTPHeaderField:key];
        }
    }
    
//    [urlRequest addValue:@"multipart/form-data; boundary=---------------------------7e02b72d104ac" forHTTPHeaderField:@"Content-Type"];
    
    [urlRequest setHTTPBodyStream:[NSInputStream inputStreamWithFileAtPath:filePath]];
    
    _connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
    //    [_connection setDelegateQueue:[[NSOperationQueue alloc] init]];
    
    [_connection start];
    _finished = NO;
    while (!_finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

//取消连接
- (void)cancelConnection {
    if (_connection != nil) {
        _finished = YES;
        [_connection cancel];
        if ([fm fileExistsAtPath:_cachePath]) {
            [fm removeItemAtPath:_cachePath error:nil];
        }
        if (![TempHelper stringIsNilOrEmpty:self.cachePath.pathExtension]) {
            if (self.dataM != nil && (self.dataM.length < self.fileLength)) {
                [self.dataM writeToFile:self.cachePath atomically:YES];
            }
        }
        _connection = nil;
        if (_cachePath != nil) {
            [_cachePath release];
            _cachePath = nil;
        }
        _cachePath = [[TempHelper getAppDownloadCachePath] retain];
        
        NSDictionary *dic = nil;
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:self.dataM.length], @"DataLength",_downloadName, @"DownloadName", _downloadFolderName, @"DownloadFolderName", @"Cancel", @"Error",[NSNumber numberWithBool:_isUpload],@"Upload", nil];
        
        [nc postNotificationName:ICLOUD_DOWMLOAD_ERROR object:_docwsid userInfo:dic];
        
        if (_dataM != nil) {
            [_dataM release];
            _dataM = nil;
        }
        if (_rangeStr != nil) {
            [_rangeStr release];
            _rangeStr = nil;
        }
//        if (self.progress != nil) {
//            Block_release(self.progress);
//            self.progress = nil;
//        }
    }
}

#pragma mark - 代理方法
// 1. 接收到服务器的响应，服务器执行完请求，向客户端回传数据
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (self.fileLength == -1) {
        _specialFileDownloadSize = 0;
    }
    if (_isDownloadFolder) {
        if (_cachePath != nil) {
            [_cachePath release];
            _cachePath = nil;
        }
        self.cachePath = [[TempHelper getAppDownloadCachePath] stringByAppendingPathComponent:response.suggestedFilename];
        // 2. 文件总长度
        self.fileLength = response.expectedContentLength;
        // 清空数据
        if (_dataM != nil) {
            [self.dataM setData:nil];
        }
        
        //初始化上次下载的
        if ([fm fileExistsAtPath:_cachePath] && self.fileLength != -1) {
            if (_rangeStr != nil && ![_rangeStr isEqualToString:@"bytes=0-"]) {
                if (_dataM != nil) {
                    [self.dataM appendData:[NSData dataWithContentsOfFile:_cachePath]];
                }
            }
        }
    }else {
        self.cachePath = [_cachePath stringByAppendingPathComponent:response.suggestedFilename];
        // 2. 文件总长度
        self.fileLength = response.expectedContentLength;
        // 3. 当前下载的文件长度
        self.currentLength = 0;
        
        // 清空数据
        if (_dataM != nil) {
            [self.dataM setData:nil];
        }
        
        //初始化上次下载的
        if ([fm fileExistsAtPath:_cachePath] && self.fileLength != -1) {
            if (_rangeStr != nil && ![_rangeStr isEqualToString:@"bytes=0-"]) {
                if (_dataM != nil) {
                    [self.dataM appendData:[NSData dataWithContentsOfFile:_cachePath]];
                    self.currentLength = [self.dataM length];
                    self.fileLength += [self.dataM length];
                }
            }
        }
    }
}

// 2. 接收数据，从服务器接收到数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (_isStop) {
        if (connection != nil) {
            [connection cancel];
            _finished = YES;
            _connection = nil;
        }
    }
    // 拼接数据
    if (_dataM != nil) {
        [self.dataM appendData:data];
    }
    
    // 根据data的长度增加当前下载的文件长度
    self.currentLength += data.length;
    if (self.fileLength == -1) {
        _specialFileDownloadSize += data.length;
    }
    
    NSLog(@"currentLength:%lld;  fileLength:%lld;  data.length:%lu;  folderSize:%lld;  specialSize:%lld",self.currentLength,self.fileLength,(unsigned long)data.length,_folderSize,_specialSize);
    
    float progress = 0.0;
    if (_isDownloadFolder) {
        progress = (float)self.currentLength / _folderSize;
    }else {
        if (_isDownloadSpecialFile) {
            progress = (float)self.currentLength / _specialSize;
        }else {
            progress = (float)self.currentLength / self.fileLength;
        }
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.currentLength], @"DownFileSize",[NSNumber numberWithFloat:self.fileLength],@"onefileSize", nil];
    [nc postNotificationName:ICLOUD_DOWMLOAD_Progress object:_docwsid userInfo:dic];
    // 判断是否定义了块代码
//    if (self.progress) {
//        self.progress(progress);
//    }
}

// 3. 完成接收
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    if (_isDownloadSpecialFile) {
//        float progress = 1.0;
//        if (self.progress) {
//            self.progress(progress);
//        }
    }
    
    if (_isUpload) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.dataM, @"dataM", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:ICLOUD_GetUpload_ReturnValue object:nil userInfo:dic];
        if (_successStr != nil) {
            [_successStr release];
            _successStr = nil;
        }
        _successStr = [[NSString alloc] initWithData:self.dataM encoding:NSUTF8StringEncoding];
        _isSuccess = YES;
    }else {
        if ([fm fileExistsAtPath:_downloadPath]) {
            _downloadPath = [[TempHelper getFilePathAlias:_downloadPath] retain];
        }
        
        if ([fm fileExistsAtPath:_cachePath]) {
            [fm removeItemAtPath:_cachePath error:nil];
        }
        
        if (self.fileLength == -1) {
            [self.dataM writeToFile:self.cachePath atomically:YES];
        }
        if (self.fileLength != -1) {
            [self.dataM writeToFile:_downloadPath atomically:YES];
        }else {
            if ([fm fileExistsAtPath:self.cachePath]) {
                @try {
                    [IMBZipHelper unZipByAll:self.cachePath decFolderPath:[_downloadPath stringByDeletingLastPathComponent]];
                }
                @catch (NSException *exception) {
                    [_loghandle writeInfoLog:[NSString stringWithFormat:@"zip error:%@  %@",[exception name],[exception reason]]];
                }
                @finally {
                    
                }
                [fm removeItemAtPath:self.cachePath error:nil];
            }
        }
        
        if (!_isDownloadSpecialFile && !_isDownloadFolder) {
            if (self.dataM.length < self.fileLength) {//文件没有下载完
                [_loghandle writeInfoLog:[NSString stringWithFormat:@"%@ download fail!",_docwsid]];
                NSString *error = NSLocalizedString(@"网络异常，导致文件没有下载完成", nil);
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_downloadName, @"DownloadName", _downloadFolderName, @"DownloadFolderName", error, @"Error", nil];
                
                [nc postNotificationName:ICLOUD_DOWMLOAD_COMPLETE object:_docwsid userInfo:dic];
                _finished = YES;
                _connection = nil;
                if (_dataM != nil) {
                    [_dataM release];
                    _dataM = nil;
                }
//                if (self.progress != nil) {
//                    Block_release(self.progress);
//                    self.progress = nil;
//                }
                return;
            }
        }
    }
    _finished = YES;
    _connection = nil;
 
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:_isDownloadFolder], @"DownloadFolder", nil];
    [nc postNotificationName:ICLOUD_DOWMLOAD_COMPLETE object:_docwsid userInfo:dic];
    if (_dataM != nil) {
        [_dataM release];
        _dataM = nil;
    }
//    if (self.progress != nil) {
//        Block_release(self.progress);
//        self.progress = nil;
//    }
}

// 4. 出现错误
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _finished = YES;
    _connection = nil;
    NSLog(@"error:%@", error.localizedDescription);

    
    if (_isUpload) {
        [_loghandle writeInfoLog:[NSString stringWithFormat:@"%@, %@ upload fail!  reason:%@",_downloadName ,_docwsid,error.localizedDescription]];
    }else {
        [_loghandle writeInfoLog:[NSString stringWithFormat:@"%@, %@ download fail!  reason:%@",_downloadName ,_docwsid,error.localizedDescription]];
        if ([fm fileExistsAtPath:_cachePath]) {
            [fm removeItemAtPath:_cachePath error:nil];
        }
    }
    
    NSDictionary *dic = nil;
    dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:self.dataM.length], @"DataLength",_downloadName, @"DownloadName", _downloadFolderName, @"DownloadFolderName", error.localizedDescription, @"Error",[NSNumber numberWithBool:_isUpload],@"Upload", nil];
    
    [nc postNotificationName:ICLOUD_DOWMLOAD_ERROR object:_docwsid userInfo:dic];

    if (_dataM != nil) {
        [_dataM release];
        _dataM = nil;
    }
//    if (self.progress != nil) {
//        Block_release(self.progress);
//        self.progress = nil;
//    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
    NSLog(@"bytesWritten:%ld",(long)bytesWritten);
    NSLog(@"totalBytesWritten:%ld",(long)totalBytesWritten);
    NSLog(@"totalBytesExpectedToWrite:%ld",(long)totalBytesExpectedToWrite);
    
//    float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:totalBytesWritten], @"progress", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ICLOUD_GetUpload_Progress object:nil userInfo:dic];
}

//设置证书权限问题
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [[challenge sender] useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

- (void)stopDownload:(NSNotification *)notification {
    _isStop = YES;
}

@end
