//
//  IMBVoicemailManager.h
//  iMobieTrans
//
//  Created by iMobie on 14-3-5.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBSqliteManager.h"
#import "IMBVoiceMailEntity.h"
#import "IMBVoiceMailSqliteManager.h"

@interface IMBVoicemailManager : IMBSqliteManager
{
    NSString *_backupFolder;
    NSString *_backupPath;
    NSString *_tmpPath;
    IMBVoiceMailSqliteManager *_voicemailData;
    NSString *_decompressionFolder;
    NSTimeInterval _lastBackupScoend;
    BOOL _isRefresh;
    BOOL _needDePassword;
    IMBBackupDecrypt *_backupDecrypt;
    BOOL _isEncrypted;
    NSString *_iosVersion;
    BOOL _isFirst;
}

@property(nonatomic, readwrite, retain) IMBVoiceMailSqliteManager *voicemailData;
@property (nonatomic, readwrite) NSTimeInterval lastBackupScoend;
@property (nonatomic, readwrite) BOOL isRefresh;
@property (nonatomic,assign)BOOL needDePassword;
@property (nonatomic, readwrite) BOOL isFirst;

//查询所有的voicemail
- (void)queryAllVoicemail;
+ (NSString *)getVoicemailDatabasePathFileRelaySqlitPath:(AMDevice *)device;

@end
