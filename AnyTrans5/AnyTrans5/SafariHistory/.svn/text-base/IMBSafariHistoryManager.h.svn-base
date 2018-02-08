//
//  IMBSafariHistoryManager.h
//  AnyTrans
//
//  Created by iMobie on 7/30/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBSqliteManager.h"
#import "IMBHistorySqliteManager.h"

@interface IMBSafariHistoryManager : IMBSqliteManager {
    NSString *_backupFolder;
    NSString *_backupPath;
    NSString *_tmpPath;
    IMBHistorySqliteManager *_safariData;
    NSString *_decompressionFolder;
    NSTimeInterval _lastBackupScoend;
    BOOL _isRefresh;
    BOOL _needDePassword;
    IMBBackupDecrypt *_backupDecrypt;
    BOOL _isEncrypted;
    NSString *_iosVersion;
    BOOL _isFirst;
}

@property(nonatomic, readwrite, retain) IMBHistorySqliteManager *safariData;
@property (nonatomic, readwrite) NSTimeInterval lastBackupScoend;
@property (nonatomic, readwrite) BOOL isRefresh;
@property (nonatomic,assign)BOOL needDePassword;
@property (nonatomic, readwrite) BOOL isFirst;

- (void)queryAllSMSData;

@end
