//
//  IMBDownloadFile.m
//  DataRecovery
//
//  Created by iMobie on 3/19/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBDownloadFile.h"
#import "TempHelper.h"
#import "IMBZipHelper.h"
#import "IMBLogManager.h"

@implementation IMBDownloadFile
@synthesize downFileName = _downFileName;

- (id)initWithDelegate:(id)delegate downloadUrlPath:(NSString *)downloadUrlPath isDownloadPlist:(BOOL)isDownloadPlist {
    if ([super init]) {
        fm = [NSFileManager defaultManager];
        _isDownloadPlist = isDownloadPlist;
        _delegate = delegate;
        _downFolderLocalPath = [[TempHelper getAppSkinPath] retain];
        _downFileName = [@"SkinConfig.plist" retain];
        _downloadFileUrlPath = [downloadUrlPath retain];
        _downFileLocalPath = [[_downFolderLocalPath stringByAppendingPathComponent:_downFileName] retain];
    }
    return self;
}

- (id)initWithDelegate:(id)delegate downloadUrlPath:(NSString *)downloadUrlPath isDownloadPlist:(BOOL)isDownloadPlist downFileName:(NSString *)downFileName {
    if ([super init]) {
        fm = [NSFileManager defaultManager];
        _isDownloadPlist = isDownloadPlist;
        _delegate = delegate;
        _downFolderLocalPath = [[TempHelper getAppSkinPath] retain];
        _downFileName = [downFileName retain];
        _downloadFileUrlPath = [downloadUrlPath retain];
        _downFileLocalPath = [[_downFolderLocalPath stringByAppendingPathComponent:_downFileName] retain];
    }
    return self;
}

- (void)dealloc {
    if (_downFolderLocalPath != nil) {
        [_downFolderLocalPath release];
        _downFolderLocalPath = nil;
    }
    if (_downloadFileUrlPath != nil) {
        [_downloadFileUrlPath release];
        _downloadFileUrlPath = nil;
    }
    if (_downFileName != nil) {
        [_downFileName release];
        _downFileName = nil;
    }
    if (_downFileLocalPath != nil) {
        [_downFileLocalPath release];
        _downFileLocalPath = nil;
    }
    if (_theDownload != nil) {
        [_theDownload release];
        _theDownload = nil;
    }
    [super dealloc];
}

//下载指定文件
-(BOOL)downloadSpecifiedFile{
    BOOL retVal = NO;
    if (![TempHelper stringIsNilOrEmpty:_downloadFileUrlPath] && ![TempHelper stringIsNilOrEmpty:_downFileLocalPath]) {
        if ([fm fileExistsAtPath:_downFileLocalPath]) {
            [fm removeItemAtPath:_downFileLocalPath error:nil];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_downloadFileUrlPath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        
        if (_theDownload != nil) {
            [_theDownload release];
            _theDownload = nil;
        }
        _theDownload = [[NSURLDownload alloc] initWithRequest:request delegate:self];
        if (_theDownload) {
            [_theDownload setDestination:_downFileLocalPath allowOverwrite:NO];
            retVal = YES;
        }
    }
    
    return retVal;
}

- (void)cancelDownload {
    if (_theDownload != nil) {
        [_theDownload cancel];
    }
}

-(void)downloadDidFinish:(NSURLDownload *)download{
    if (_isDownloadPlist) {
        if ([fm fileExistsAtPath:_downFileLocalPath]) {
            if (_delegate != nil && [_delegate respondsToSelector:@selector(downComplete:)]) {
                [_delegate downComplete:_downFileName];
            }
        }
    }else {
        //解压下载文件到指定文件，未确定文件名；
        if ([fm fileExistsAtPath:_downFileLocalPath]) {
            NSString *zipFolder = [_downFolderLocalPath stringByAppendingPathComponent:[_downFileName stringByDeletingPathExtension]];
            if ([fm fileExistsAtPath:zipFolder]) {
                [fm removeItemAtPath:zipFolder error:nil];
            }
            @try {
                [IMBZipHelper unZipByAllF:_downFileLocalPath decFolderPath:_downFolderLocalPath];
                //[IMBZipHelper unZipByFolder:_downFileLocalPath folderPath:[_downFileName stringByDeletingPathExtension] decFolderPath:_downFolderLocalPath];
            }
            @catch (NSException *exception) {
                [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"zip error:%@  %@",[exception name],[exception reason]]];
            }
            if (_delegate != nil && [_delegate respondsToSelector:@selector(downComplete:)]) {
                [_delegate downComplete:[_downFileName stringByDeletingPathExtension]];
            }
        }
    }
}

-(void)download:(NSURLDownload *)download didFailWithError:(NSError *)error{
    if ([fm fileExistsAtPath:_downFileLocalPath]) {
        [fm removeItemAtPath:_downFileLocalPath error:nil];
    }
    if (_delegate != nil && [_delegate respondsToSelector:@selector(downErrorWithFileName:withError:)]) {
        [_delegate downErrorWithFileName:_downFileName withError:nil];
    }
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response {
    if (!_isDownloadPlist) {
        _expectedContentLength = [response expectedContentLength];
        if (_expectedContentLength == -1) {
            _expectedContentLength = 60000000;
        }
    }
}

- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length {
    if (!_isDownloadPlist) {
        _bytesReceived = _bytesReceived + length;
        if (_expectedContentLength != NSURLResponseUnknownLength) {
            float percentComplete = (_bytesReceived / (float)_expectedContentLength) * 100.0;
            if (percentComplete >= 100) {
                percentComplete = 99;
            }
            if (_delegate != nil && [_delegate respondsToSelector:@selector(downProgressWithFileName:withProgress:)]) {
                [_delegate downProgressWithFileName:_downFileName withProgress:percentComplete];
            }
        } else {
            if (_delegate != nil && [_delegate respondsToSelector:@selector(downProgressWithFileName:withProgress:)]) {
                [_delegate downProgressWithFileName:_downFileName withProgress:100.f];
            }
        }
    }
}

@end
