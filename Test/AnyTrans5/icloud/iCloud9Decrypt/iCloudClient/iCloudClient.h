//
//  iCloudClient.h
//  iCloudClient
//
//  Created by long on 6/26/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonDefine.h"

@class Auth;
@class Account;
@class Backup;
@class Device;
@class SnapshotEx;

@protocol DownloadProgressCallback
@required
- (void)downloadProgress:(uint64_t)totalSize withCompleteSize:(uint64_t)completeSize;
- (void)downloadComplete;

@end

@interface iCloudClient : NSObject {
@private
    NSString *                      _outputFolder;
    id                              _delegate;
    Auth *                          _auth;
    Account *                       _account;
    NSMutableDictionary *           _deviceSnapshots;
    Backup *                        _backup;
    NSString *                     _downloadFolders;
}

- (void)setDelegate:(id)delegate;

- (NSString*)outputFolder;
- (void)setOutputFolder:(NSString*)outputFolder;

- (NSString *)downloadFolders;

// 使用令牌环进行登陆(格式: dsPrsID:mmeAuthToken -> 字符串)
- (BOOL)auth:(NSString*)token;
// 使用AppleID和Password进行登陆
- (BOOL)auth:(NSString*)appleID withPassword:(NSString*)password;
// 获取Device对应的Snapshot
- (NSMutableDictionary*)queryBackupInfo;
// 下载备份
- (void)downloadWithDevice:(Device*)device withSnapshot:(SnapshotEx*)snapshot withDomains:(NSArray*)domains withCancel:(BOOL*)cancel;

- (void)outputProgress:(uint64_t)totalSize withCompleteSize:(uint64_t)completeSize;

@end
