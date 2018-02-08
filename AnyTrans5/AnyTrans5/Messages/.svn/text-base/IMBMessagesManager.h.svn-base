//
//  IMBMessagesManager.h
//  AnyTrans
//
//  Created by iMobie on 7/30/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBSqliteManager.h"
#import "IMBMessageSqliteManager.h"

@interface IMBMessagesManager : IMBSqliteManager {
    NSString *_backupFolder;
    NSString *_backupPath;
    NSString *_tmpPath;
    IMBMessageSqliteManager *_smsData;
    NSString *_decompressionFolder;
    NSTimeInterval _lastBackupScoend;
    BOOL _isRefresh;
    BOOL _needDePassword;
    IMBBackupDecrypt *_backupDecrypt;
    BOOL _isEncrypted;
    NSString *_iosVersion;
    BOOL _isFirst;
}

@property(nonatomic, readwrite, retain) IMBMessageSqliteManager *smsData;
@property (nonatomic, readwrite) NSTimeInterval lastBackupScoend;
@property (nonatomic, readwrite) BOOL isRefresh;
@property (nonatomic,assign)BOOL needDePassword;
@property (nonatomic, readwrite) BOOL isFirst;

- (void)queryAllSMSData;

@end
