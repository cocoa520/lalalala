//
//  IMBCloneOrMergeManager.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-15.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBCloneOrMergeManager.h"
#import "IMBDeviceInfo.h"
#import "IMBCategoryInfoModel.h"
#import "NSString+Category.h"
#import "SystemHelper.h"
#import "IMBInformation.h"
#import "IMBInformationManager.h"
#import "StringHelper.h"
#import "IMBBaseTransfer.h"
#import "IMBPhotoFileExport.h"
#import "IMBBackAndRestore.h"
#import "IMBNotificationDefine.h"
#import "IMBBookmarkClone.h"
#import "IMBContactClone.h"
#import "IMBCallHistoryClone.h"
#import "IMBCalendarClone.h"
#import "IMBPhotoClone.h"
#import "IMBMessageClone.h"
#import "IMBNoteClone.h"
#import "IMBAppClone.h"
#import "IMBSystemSettingClone.h"
#import "IMBBookMarkSqliteManager.h"
#import "IMBContactSqliteManager.h"
#import "IMBCallHistorySqliteManager.h"
#import "IMBCalendarSqliteManager.h"
#import "IMBNoteSqliteManager.h"
#import "IMBBetweenDeviceHandler.h"
#import "IMBMergeOrCloneViewController.h"
#import "IMBVoicemailClone.h"
#import "IMBVoiceMailSqliteManager.h"
@implementation IMBCloneOrMergeManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(backupError:) name:NOTIFY_BACKUP_ERROR object:nil];
        [nc addObserver:self selector:@selector(backupError:) name:NOTIFY_RESTORE_ERROR object:nil];
        [nc addObserver:self selector:@selector(doBackUpProgress:) name:NOTIFY_BACKUP_PROGRESS object:nil];
        [nc addObserver:self selector:@selector(doBackUpProgress:) name:NOTIFY_RESTORE_PROGRESS object:nil];
        _logManager = [IMBLogManager singleton];

    }
    return self;
}

- (id)initWithiPod:(IMBiPod *)sourceiPod targetPod:(IMBiPod *)targetiPod categoryArray:(NSMutableArray *)categoryArray transferDelegate:(id<TransferDelegate>)tranferDelegate
{
    if (self = [self init]) {
        _sourceIpod = [sourceiPod retain];
        _targetIpod = [targetiPod retain];
        _categoryArr = [categoryArray retain];
        _tranferDelegate = tranferDelegate;
    }
    return self;
}

- (void)backupError:(NSNotification *)notification
{
    if (_errorCode != nil) {
        [_errorCode release];
        _errorCode = nil;
    }
    _errorCode = [[notification.userInfo objectForKey:NOTIFY_ERROR_CODE] retain];
    _hasError = YES;
}

- (void)doBackUpProgress:(NSNotification *)notification {
    
    NSDictionary *dic = [notification userInfo];
    if (dic != nil) {
        double progress = [[dic objectForKey:@"BRProgress"] doubleValue];
        if (progress >=100){
            progress = 100.0;
        }
        if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
            [_tranferDelegate transferProgress:progress];
        }
    }
}




#pragma mark - CloneOrMerge
- (void)clone
{
    int sourceVersion = [_sourceIpod.deviceInfo getDeviceVersionNumber];
    int targetVersion = [_targetIpod.deviceInfo getDeviceVersionNumber];  //此版本返回大版本 列如 iOS8.1.1返回8
    NSString *sourceFloatVersion = [_sourceIpod.deviceInfo getDeviceFloatVersionNumber]; //此版本返回浮点型版本号 列如 iOS8.1.1返回8.1
    NSString *targetFloatVersion = [_targetIpod.deviceInfo getDeviceFloatVersionNumber];
    BOOL bookmarkNeedClone = NO;
    BOOL contactNeedClone = NO;
    BOOL callhistoryNeedClone = NO;
    BOOL calendarNeedClone = NO;
    BOOL messageNeedClone = NO;
    BOOL noteNeedClone = NO;
    BOOL photosNeedClone = NO;
    BOOL appNeedClone = NO;
    BOOL voicemail = NO;
    int  clonetypeCount = 0;
    int  currentcloneCount = 0;
    for (IMBCategoryInfoModel *model in _categoryArr) {
        if (model.categoryNodes == Category_Bookmarks) {
            bookmarkNeedClone = YES;
            clonetypeCount++;
        }else if (model.categoryNodes == Category_Contacts)
        {
            contactNeedClone = YES;
            clonetypeCount++;
        }else if (model.categoryNodes == Category_CallHistory)
        {
            callhistoryNeedClone = YES;
            clonetypeCount++;
        }else if (model.categoryNodes == Category_Calendar)
        {
            calendarNeedClone = YES;
            clonetypeCount++;
        }else if (model.categoryNodes == Category_Message)
        {
            messageNeedClone = YES;
            clonetypeCount++;
        }else if (model.categoryNodes == Category_Notes)
        {
            noteNeedClone= YES;
            clonetypeCount++;
        }else if (model.categoryNodes == Category_Photos)
        {
            photosNeedClone = YES;
            clonetypeCount++;
        }else if (model.categoryNodes == Category_Applications)
        {
            //源设备系统是8.3及以上的，还原app通过备份还原流程，否则用传输流程；
            if ([sourceFloatVersion isVersionMajorEqual:@"8.3"] || [targetFloatVersion isVersionMajorEqual:@"8.3"]) {
                appNeedClone = YES;
                clonetypeCount++;
            }
        }else if (model.categoryNodes == Category_Voicemail){
            voicemail = YES;
            clonetypeCount++;
        }
    }
    @autoreleasepool {
        //如果没有勾选了photos选项,则需要对photoLibrary,和自定义的albums进行备份
        //我们将photolibrary和albums备份在picture目录 的AnytransPhotoBackup目录下
        if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_tranferDelegate transferPrepareFileEnd];
        }
        if (sourceVersion<=targetVersion) {
            if ([sourceFloatVersion isVersionLessEqual:targetFloatVersion]) {
                if (!photosNeedClone) {
                    if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                        [_tranferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Message_Id_5", nil),_targetIpod.deviceInfo.deviceName]];
                    }
                    [self backupPhoto:_targetIpod];
                }else
                {
                    if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                        [_tranferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Message_Id_5", nil),_sourceIpod.deviceInfo.deviceName]];
                    }
                    [self backupPhoto:_sourceIpod];
                }
            }else
            {
                if (photosNeedClone) {
                    if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                        [_tranferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Message_Id_5", nil),_sourceIpod.deviceInfo.deviceName]];
                    }
                    [self backupPhoto:_sourceIpod];
                }else
                {
                    if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                        [_tranferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Message_Id_5", nil),_targetIpod.deviceInfo.deviceName]];
                    }
                    [self backupPhoto:_targetIpod];
                }
            }
        }else
        {
            [self backupPhoto:_targetIpod];
        }
    }
    @autoreleasepool {
        if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_tranferDelegate transferPrepareFileStart:@"backDevicesource"];
        }
        
        if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
             [_tranferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Backup_Message", nil),_sourceIpod.deviceInfo.deviceName]];
        }
        IMBBackAndRestore *sourcebackandstore = [[IMBBackAndRestore alloc] initWithIPod:_sourceIpod];
        [sourcebackandstore setIsServiceBackup:NO];
        [sourcebackandstore backUp];
        [sourcebackandstore release];
        sleep(1);
        if (_hasError) {
            if ([_errorCode isEqualToString:@"-30"]) {
                _retry = NO;
                [self performSelectorOnMainThread:@selector(transferError:) withObject:@"source-30" waitUntilDone:YES];
                if (_retry) {
                    //询问是否进行增量备份
                    IMBBackAndRestore *sourcebackandstore = [[IMBBackAndRestore alloc] initWithIPod:_sourceIpod];
                    [sourcebackandstore backupNSTask];
                    [sourcebackandstore release];
                    _hasError = NO;
                }else
                {
                    if ([_tranferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                        [_tranferDelegate cloneOrMergeComplete:NO];
                    }
                    return ;
                }
            }else if ([_errorCode isEqualToString:@"-35"])
            {
                [self performSelectorOnMainThread:@selector(transferError:) withObject:@"source-35" waitUntilDone:YES];
                if ([_tranferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                    [_tranferDelegate cloneOrMergeComplete:NO];
                }
                return;
            }else
            {
                [self performSelectorOnMainThread:@selector(transferError:) withObject:CustomLocalizedString(@"Clone_id_9", nil) waitUntilDone:YES];
                if ([_tranferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                    [_tranferDelegate cloneOrMergeComplete:NO];
                }
                return;
            }
        }
        if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_tranferDelegate transferPrepareFileStart:@"backDevicetarget"];
        }
        if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_tranferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Backup_Message", nil),_targetIpod.deviceInfo.deviceName]];
        }
        IMBBackAndRestore *targetbackandstore = [[IMBBackAndRestore alloc] initWithIPod:_targetIpod];
        [targetbackandstore setIsServiceBackup:NO];
        [targetbackandstore backUp];
        [targetbackandstore release];
        sleep(1);
        if (_hasError) {
            if ([_errorCode isEqualToString:@"-30"]) {
                _retry = NO;
                [self performSelectorOnMainThread:@selector(transferError:) withObject:@"target-30" waitUntilDone:YES];
                if (_retry) {
                    //询问是否进行增量备份
                    IMBBackAndRestore *targetbackandstore = [[IMBBackAndRestore alloc] initWithIPod:_targetIpod];
                    [targetbackandstore backupNSTask];
                    [targetbackandstore release];
                    _hasError = NO;
                }else
                {
                    if ([_tranferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                        [_tranferDelegate cloneOrMergeComplete:NO];
                    }
                    return ;
                }
            }else if ([_errorCode isEqualToString:@"-35"])
            {
                [self performSelectorOnMainThread:@selector(transferError:) withObject:@"target-35" waitUntilDone:YES];
                if ([_tranferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                    [_tranferDelegate cloneOrMergeComplete:NO];
                }
                return;
            }else
            {
                [self performSelectorOnMainThread:@selector(transferError:) withObject:CustomLocalizedString(@"Clone_id_9", nil) waitUntilDone:YES];
                if ([_tranferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                    [_tranferDelegate cloneOrMergeComplete:NO];
                }
                return;
            }
        }
    }
    if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_tranferDelegate transferPrepareFileStart:@"insertData"];
    }
    if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
         [_tranferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"CloneDevice_Message_Title", nil),_targetIpod.deviceInfo.deviceName]];
    }
    //解析manifest
    NSString *sourceBackupPath = [[[TempHelper getBackupFolderPath] stringByAppendingPathComponent:_sourceIpod.deviceHandle.udid] retain];
    NSString *targetBackupPath = [[[TempHelper getBackupFolderPath] stringByAppendingPathComponent:_targetIpod.deviceHandle.udid] retain];
    IMBMBDBParse *sourceparase = [[IMBMBDBParse alloc] initWithAMDevice:nil withbackupfilePath:sourceBackupPath];
    [sourceparase parseManifest];
    NSMutableArray *sourceRecordArray = [[sourceparase recordArray] retain];
    IMBMBDBParse *targetparase = [[IMBMBDBParse alloc] initWithAMDevice:nil withbackupfilePath:targetBackupPath];
    [targetparase parseManifest];
    NSMutableArray *targetRecordArray = [[targetparase recordArray] retain];
    //bookmark
    @autoreleasepool {
        IMBBookmarkClone *bookmarkClone = [[IMBBookmarkClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:YES];
        bookmarkClone.isneedClone = bookmarkNeedClone;
        [bookmarkClone clone];
        [bookmarkClone release];
        if (bookmarkNeedClone) {
            currentcloneCount++;
            if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
            }
        }
    }
    //contact
    @autoreleasepool {
        IMBContactClone *contactClone = [[IMBContactClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:YES];
        contactClone.isneedClone = contactNeedClone;
        [contactClone clone];
        [contactClone release];
        if (contactNeedClone) {
            currentcloneCount++;
            if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
            }
        }
    }
    //calHistory
    @autoreleasepool {
        if (_sourceIpod.deviceInfo.isiPhone&&_targetIpod.deviceInfo.isiPhone) {
            IMBCallHistoryClone *calHistoryClone = [[IMBCallHistoryClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:YES];
            calHistoryClone.isneedClone = callhistoryNeedClone;
            [calHistoryClone clone];
            [calHistoryClone release];
            if (callhistoryNeedClone) {
                currentcloneCount++;
                if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
                }
            }
        }
    }
    
    @autoreleasepool {
        IMBCalendarClone *calendarClone = [[IMBCalendarClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:YES];
        calendarClone.isneedClone = calendarNeedClone;
        [calendarClone clone];
        [calendarClone release];
        if (calendarNeedClone) {
            currentcloneCount++;
            if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
            }
        }
    }
    //photo
    @autoreleasepool {
        if (sourceVersion<=targetVersion) {
            if ([sourceFloatVersion isVersionLessEqual:targetFloatVersion]) {
                IMBPhotoClone *photoClone = [[IMBPhotoClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:YES];
                photoClone.isneedClone = photosNeedClone;
                [photoClone clone];
                [photoClone release];
                if (photosNeedClone) {
                    currentcloneCount++;
                    if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
                    }
                }
            }else
            {
                IMBPhotoClone *photoClone = [[IMBPhotoClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:YES];
                if (photosNeedClone) {
                    photoClone.isneedClone = NO;
                }else
                {
                    photoClone.isneedClone = YES;
                }
                [photoClone clone];
                [photoClone release];
                if (photosNeedClone) {
                    currentcloneCount++;
                    if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
                    }
                }
            }
        }
    }
    
    //message
    @autoreleasepool {
        IMBMessageClone *messageClone = [[IMBMessageClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:YES];
        messageClone.isneedClone = messageNeedClone;
        [messageClone clone];
        [messageClone release];
        if (messageNeedClone) {
            currentcloneCount++;
            if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
            }
        }
    }
    //note
    @autoreleasepool {
//        IMBNoteClone *noteClone = [[IMBNoteClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:YES];
//        noteClone.isneedClone = noteNeedClone;
//        [noteClone clone];
//        [noteClone release];
//        if (noteNeedClone) {
//            currentcloneCount++;
//            if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
//                [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
//            }
//        }
        if (noteNeedClone) {
            IMBNoteSqliteManager *noteManager = [[IMBNoteSqliteManager alloc] initWithBackupfilePath:sourceBackupPath recordArray:sourceRecordArray];
            [noteManager querySqliteDBContent];
            NSMutableArray *noteArray = noteManager.dataAry;
            IMBNoteClone *noteClone = [[IMBNoteClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:NO];
            [noteClone merge:noteArray];
            [noteClone release];
            if (noteNeedClone) {
                currentcloneCount++;
                if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
                }
            }
            [noteManager release];
        }
    }
    //clone app
    @autoreleasepool {
        if ((_sourceIpod.deviceInfo.isiPad&&_targetIpod.deviceInfo.isiPad)||(!_sourceIpod.deviceInfo.isiPad&&!_targetIpod.deviceInfo.isiPad)) {
            IMBAppClone *appClone = [[IMBAppClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:YES];
            appClone.sourceApp = [_sourceIpod.applicationManager appEntityArray];
            appClone.targetApp = [_targetIpod.applicationManager appEntityArray];
            appClone.isneedClone = appNeedClone;
            [appClone clone];
            [appClone release];
            if (appNeedClone) {
                currentcloneCount++;
                if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
                }
            }
        }
    }
    @autoreleasepool {
        if (_sourceIpod.deviceInfo.isiPhone && _targetIpod.deviceInfo.isiPhone) {
            IMBVoicemailClone *voicemailClone = [[IMBVoicemailClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:YES];
            voicemailClone.isneedClone = voicemail;
            [voicemailClone clone];
            [voicemailClone release];
            if (voicemail) {
                currentcloneCount++;
                if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
                }
            }

        }
    }
    @autoreleasepool {
        if (sourceVersion<10&&targetVersion<10) {
            IMBSystemSettingClone *systemSettingClone = [[IMBSystemSettingClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:YES];
            systemSettingClone.deviceName = _sourceIpod.deviceInfo.deviceName;
            systemSettingClone.isneedClone = YES;
            [systemSettingClone clone];
            [systemSettingClone release];
        }
    }
    if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_tranferDelegate transferPrepareFileStart:@"restoreDevice"];
    }
    if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_tranferDelegate transferPrepareFileStart:CustomLocalizedString(@"CloneMerge_Restor_Photo_Message", nil)];
    }
    @autoreleasepool {
        @try {
            ((IMBMergeOrCloneViewController *)_tranferDelegate).restoreiPodKey = _targetIpod.uniqueKey;
            if (sourceVersion>targetVersion) {
                IMBBackAndRestore *backupAndRestore = [[IMBBackAndRestore alloc] initWithIPod:_targetIpod];
                [backupAndRestore restoreNSTask:nil restoreType:@"restore"];
                
            }else
            {
                if ([sourceFloatVersion isVersionLessEqual:targetFloatVersion]) {
                    IMBBackAndRestore *backupAndRestore = [[IMBBackAndRestore alloc] initWithIPod:_targetIpod];
                    [backupAndRestore restoreNSTask:_sourceIpod.deviceHandle.udid restoreType:@"restore"];
                    [backupAndRestore release];
                }else
                {
                    IMBBackAndRestore *backupAndRestore = [[IMBBackAndRestore alloc] initWithIPod:_targetIpod];
                    [backupAndRestore restoreNSTask:nil restoreType:@"restore"];
                    [backupAndRestore release];
                }
            }
            sleep(1);
            [sourceBackupPath release];
            [sourceparase release];
            [sourceRecordArray release];
            [targetBackupPath release];
            [targetparase release];
            [targetRecordArray release];
            if (_hasError) {
                if ([_errorCode isEqualToString:@"-36"]) {
                    [self performSelectorOnMainThread:@selector(transferError:) withObject:@"restore-36" waitUntilDone:YES];
                }else
                {
                    [self performSelectorOnMainThread:@selector(transferError:) withObject:CustomLocalizedString(@"Clone_id_9", nil) waitUntilDone:YES];
                }
                if ([_tranferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                    [_tranferDelegate cloneOrMergeComplete:NO];
                }
                return;
            }
           
        }
        @catch (NSException *exception) {
            [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"还原异常原因:%@",exception]];
        }
    }
}



- (void)backupPhoto:(IMBiPod *)tariPod
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //创建AnytransPhotoBackup目录
    NSString *photoBackupPath = [[SystemHelper userPicturePath] stringByAppendingPathComponent:@"AnytransPhotoBackup"];
    BOOL isDir = NO;
    if ([fileManager fileExistsAtPath:photoBackupPath isDirectory:&isDir]) {
        [fileManager removeItemAtPath:photoBackupPath error:nil];
    }
    [self photoToMac:photoBackupPath fileManager:fileManager tariPod:tariPod];
}

//将photoLibrary和自定义的myalbums导出到本地备份
- (void)photoToMac:(NSString *)photoBackupPath fileManager:(NSFileManager *)fileManager tariPod:(IMBiPod *)tariPod
{
    if ([fileManager createDirectoryAtPath:photoBackupPath withIntermediateDirectories:NO attributes:nil error:nil]) {
        //创建photolibrary的导出目录
        IMBInformationManager *manager = [IMBInformationManager shareInstance];
        IMBInformation *information = [manager.informationDic objectForKey:tariPod.uniqueKey];
        NSString *photoLibraryPath = [photoBackupPath stringByAppendingPathComponent:@"myPicture"];
        if ([fileManager createDirectoryAtPath:photoLibraryPath withIntermediateDirectories:NO attributes:nil error:nil]) {
            //剔除photoliabrary含自定义album的照片
            NSMutableArray *libarray = [NSMutableArray arrayWithArray:information.photolibraryArray];
            NSMutableArray *nameEqual = [NSMutableArray array];
            for (IMBPhotoEntity *libentity in libarray) {
                for (IMBPhotoEntity *entity in information.myAlbumsArray) {
                    if (entity.albumType == SyncAlbum) {
                        NSArray *photoArray = [information.albumsDic objectForKey:[NSNumber numberWithInt:entity.albumZpk]];
                        for (IMBPhotoEntity *albumEntity in photoArray) {
                            if ([libentity.photoName isEqualToString:albumEntity.photoName]) {
                                [nameEqual addObject:libentity];
                            }
                        }
                    }
                }
            }
            [libarray removeObjectsInArray:nameEqual];
            if ([libarray count]>0) {
                ((IMBMergeOrCloneViewController *)_tranferDelegate).hasPhotoBack = YES;
                IMBBaseTransfer *baseTransfer = [[IMBPhotoFileExport alloc] initWithIPodkey:_targetIpod.uniqueKey exportTracks:libarray exportFolder:photoLibraryPath withDelegate:_tranferDelegate];
                [(IMBPhotoFileExport *)baseTransfer setExportType:1];
                [baseTransfer startTransfer];
                [baseTransfer release];
                sleep(1);

            }
        }
        for (IMBPhotoEntity *entity in information.myAlbumsArray) {
            if (entity.albumType == SyncAlbum) {
                //创建album自定义的相册目录
                NSString *albumPath = [photoBackupPath stringByAppendingPathComponent:entity.albumTitle];
                if ([fileManager fileExistsAtPath:albumPath]) {
                    albumPath = [StringHelper createDifferentfileName:albumPath];
                }
                if ([fileManager createDirectoryAtPath:albumPath withIntermediateDirectories:NO attributes:nil error:nil]) {
                    NSArray *photoArray = [information.albumsDic objectForKey:[NSNumber numberWithInt:entity.albumZpk]];
                    if ([photoArray count]>0) {
                        ((IMBMergeOrCloneViewController *)_tranferDelegate).hasPhotoBack = YES;
                        IMBBaseTransfer *baseTransfer = [[IMBPhotoFileExport alloc] initWithIPodkey:_targetIpod.uniqueKey exportTracks:photoArray exportFolder:albumPath withDelegate:_tranferDelegate];
                        [(IMBPhotoFileExport *)baseTransfer setExportType:1];
                        [baseTransfer startTransfer];
                        [baseTransfer release];
                        sleep(1);
                    }
                }
            }
        }
    }
}

- (void)merge
{
    NSString *sourceFloatVersion = [_sourceIpod.deviceInfo getDeviceFloatVersionNumber]; //此版本返回浮点型版本号 列如 iOS8.1.1返回8.1
    NSString *targetFloatVersion = [_targetIpod.deviceInfo getDeviceFloatVersionNumber];
    BOOL needBackup = NO;
    for (IMBCategoryInfoModel *model in _categoryArr)
    {
        if (model.categoryNodes == Category_Bookmarks) {
            needBackup = YES;
            
        }
        if (model.categoryNodes == Category_Contacts)
        {
            needBackup = YES;
            
        }
        if (model.categoryNodes == Category_CallHistory)
        {
            needBackup = YES;
            
        }
        if (model.categoryNodes == Category_Calendar)
        {
            needBackup = YES;
            
        }
        if (model.categoryNodes == Category_Message)
        {
            needBackup = YES;
            
        }
        if (model.categoryNodes == Category_Notes)
        {
            needBackup = YES;
        }
        if (model.categoryNodes == Category_Applications) {
            if ([sourceFloatVersion isVersionMajorEqual:@"8.3"] || [targetFloatVersion isVersionMajorEqual:@"8.3"]) {
                needBackup = YES;
            }
        }
        if (model.categoryNodes == Category_Voicemail)
        {
            needBackup = YES;
        }
    }
    if (needBackup) {
        BOOL bookmarkNeedClone = NO;
        BOOL contactNeedClone = NO;
        BOOL callhistoryNeedClone = NO;
        BOOL calendarNeedClone = NO;
        BOOL messageNeedClone = NO;
        BOOL noteNeedClone = NO;
        BOOL appNeedClone = NO;
        BOOL voicemail = NO;
        int  clonetypeCount = 0;
        int  currentcloneCount = 0;
        for (IMBCategoryInfoModel *model in _categoryArr) {
            if (model.categoryNodes == Category_Bookmarks) {
                bookmarkNeedClone = YES;
                clonetypeCount++;
            }else if (model.categoryNodes == Category_Contacts)
            {
                contactNeedClone = YES;
                clonetypeCount++;
            }else if (model.categoryNodes == Category_CallHistory)
            {
                callhistoryNeedClone = YES;
                clonetypeCount++;
            }else if (model.categoryNodes == Category_Calendar)
            {
                calendarNeedClone = YES;
                clonetypeCount++;
            }else if (model.categoryNodes == Category_Message)
            {
                messageNeedClone = YES;
                clonetypeCount++;
            }else if (model.categoryNodes == Category_Notes)
            {
                noteNeedClone= YES;
                clonetypeCount++;
            }else if (model.categoryNodes == Category_Applications) {
                if ([sourceFloatVersion isVersionMajorEqual:@"8.3"] || [targetFloatVersion isVersionMajorEqual:@"8.3"]) {
                    appNeedClone = YES;
                    clonetypeCount++;
                }
            }else if (model.categoryNodes == Category_Voicemail)
            {
                voicemail = YES;
                clonetypeCount++;
            }
        }
        @autoreleasepool {
            if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                [_tranferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Message_Id_5", nil),_targetIpod.deviceInfo.deviceName]];
            }
            if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
                [_tranferDelegate transferPrepareFileEnd];
            }
            [self backupPhoto:_targetIpod];
        }
        @autoreleasepool {
            if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                [_tranferDelegate transferPrepareFileStart:@"backDevicesource"];
            }
            if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                [_tranferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Backup_Message", nil),_sourceIpod.deviceInfo.deviceName]];
            }
            IMBBackAndRestore *sourcebackandstore = [[IMBBackAndRestore alloc] initWithIPod:_sourceIpod];
            sourcebackandstore.isServiceBackup = NO;
            [sourcebackandstore backUp];
            [sourcebackandstore release];
            sleep(1);
            if (_hasError) {
                if ([_errorCode isEqualToString:@"-30"]) {
                    _retry = NO;
                    [self performSelectorOnMainThread:@selector(transferError:) withObject:@"source-30" waitUntilDone:YES];
                    if (_retry) {
                        IMBBackAndRestore *sourcebackandstore = [[IMBBackAndRestore alloc] initWithIPod:_sourceIpod];
                        [sourcebackandstore backupNSTask];
                        [sourcebackandstore release];
                        //询问是否进行增量备份
                        _hasError = NO;
                    }else
                    {
                        if ([_tranferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                            [_tranferDelegate cloneOrMergeComplete:NO];
                        }
                        return ;
                    }
                }else if ([_errorCode isEqualToString:@"-35"])
                {
                    [self performSelectorOnMainThread:@selector(transferError:) withObject:@"source-35" waitUntilDone:YES];
                    if ([_tranferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                        [_tranferDelegate cloneOrMergeComplete:NO];
                    }
                    return;
                }else
                {
                    [self performSelectorOnMainThread:@selector(transferError:) withObject:CustomLocalizedString(@"Clone_id_9", nil) waitUntilDone:YES];
                    if ([_tranferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                        [_tranferDelegate cloneOrMergeComplete:NO];
                    }
                    return;
                }
            }
            if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                [_tranferDelegate transferPrepareFileStart:@"backDevicetarget"];
            }
            if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                [_tranferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Backup_Message", nil),_targetIpod.deviceInfo.deviceName]];
            }
            IMBBackAndRestore *targetbackandstore = [[IMBBackAndRestore alloc] initWithIPod:_targetIpod];
            targetbackandstore.isServiceBackup = NO;
            [targetbackandstore backUp];
            [targetbackandstore release];
            sleep(1);
            if (_hasError) {
                if ([_errorCode isEqualToString:@"-30"]) {
                    _retry = NO;
                    [self performSelectorOnMainThread:@selector(transferError:) withObject:@"target-30" waitUntilDone:YES];
                    if (_retry) {
                        //询问是否进行增量备份
                        IMBBackAndRestore *targetbackandstore = [[IMBBackAndRestore alloc] initWithIPod:_targetIpod];
                        [targetbackandstore backupNSTask];
                        [targetbackandstore release];
                        _hasError = NO;
                    }else
                    {
                        if ([_tranferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                            [_tranferDelegate cloneOrMergeComplete:NO];
                        }
                        return ;
                    }
                }else if ([_errorCode isEqualToString:@"-35"])
                {
                    [self performSelectorOnMainThread:@selector(transferError:) withObject:@"target-35" waitUntilDone:YES];
                    if ([_tranferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                        [_tranferDelegate cloneOrMergeComplete:NO];
                    }
                    return;
                }else
                {
                    [self performSelectorOnMainThread:@selector(transferError:) withObject:CustomLocalizedString(@"Clone_id_9", nil) waitUntilDone:YES];
                    if ([_tranferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                        [_tranferDelegate cloneOrMergeComplete:NO];
                    }
                    return;
                }
            }
        }
        if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_tranferDelegate transferPrepareFileStart:@"insertData"];
        }
        if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_tranferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"MergeDevice_Message_Title", nil),_targetIpod.deviceInfo.deviceName]];
        }
        //解析manifest
        NSString *sourceBackupPath = [[[TempHelper getBackupFolderPath] stringByAppendingPathComponent:_sourceIpod.deviceHandle.udid] retain];
        NSString *targetBackupPath = [[[TempHelper getBackupFolderPath] stringByAppendingPathComponent:_targetIpod.deviceHandle.udid] retain];
        IMBMBDBParse *sourceparase = nil;
        sourceparase = [[IMBMBDBParse alloc] initWithAMDevice:nil withbackupfilePath:sourceBackupPath];
        [sourceparase parseManifest];
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"sourceManifest count:%lu",(unsigned long)[[sourceparase recordArray] count]]];
        IMBMBDBParse *targetparase = nil;
        targetparase = [[IMBMBDBParse alloc] initWithAMDevice:nil withbackupfilePath:targetBackupPath];
        [targetparase parseManifest];
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"targetManifest count:%lu",(unsigned long)[[targetparase recordArray] count]]];

        NSMutableArray *sourceRecordArray = [[sourceparase recordArray] retain];
        NSMutableArray *targetRecordArray = [[targetparase recordArray] retain];
        //bookmark
        @autoreleasepool {
            if (bookmarkNeedClone) {
                [[IMBLogManager singleton] writeInfoLog:@"bookmark merge"];
                IMBBookMarkSqliteManager *bookMarkManager = [[IMBBookMarkSqliteManager alloc] initWithBackupfilePath:sourceBackupPath recordArray:sourceRecordArray];
                NSMutableArray *bookmarkArray =  [bookMarkManager queryAllBookmarks];
                IMBBookmarkClone *bookmarkClone = [[IMBBookmarkClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:NO];
                [bookmarkClone merge:bookmarkArray];
                [bookmarkClone release];
                if (bookmarkNeedClone) {
                    currentcloneCount++;
                    if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
                    }
                }
                [bookMarkManager release];
            }
        }
        //contact
        @autoreleasepool {
            if (contactNeedClone) {
                [[IMBLogManager singleton] writeInfoLog:@"contact merge"];
                IMBContactSqliteManager *contactManager = [[IMBContactSqliteManager alloc] initWithBackupfilePath:sourceBackupPath recordArray:sourceRecordArray];
                [contactManager querySqliteDBContent];
                NSMutableArray *contactArray = contactManager.dataAry;
                IMBContactClone *contactClone = [[IMBContactClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:NO];
                [contactClone merge:contactArray];
                [contactClone release];
                if (contactNeedClone) {
                    currentcloneCount++;
                    if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
                    }
                }
                [contactManager release];
            }
        }
        //calHistory
        @autoreleasepool {
            if (_sourceIpod.deviceInfo.isiPhone&&_targetIpod.deviceInfo.isiPhone) {
                if (callhistoryNeedClone) {
                    [[IMBLogManager singleton] writeInfoLog:@"callhistory merge"];
                    IMBCallHistorySqliteManager *callhitoryManager = [[IMBCallHistorySqliteManager alloc] initWithBackupfilePath:sourceBackupPath recordArray:sourceRecordArray];
                    [callhitoryManager querySqliteDBContent] ;
                    NSMutableArray *callhistory = callhitoryManager.dataAry;
                    IMBCallHistoryClone *calHistoryClone = [[IMBCallHistoryClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:NO];
                    [calHistoryClone merge:callhistory];
                    [calHistoryClone release];
                    if (callhistoryNeedClone) {
                        currentcloneCount++;
                        if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                            [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
                        }
                    }
                    [callhitoryManager release];

                }
            }
        }
        @autoreleasepool {
            if (calendarNeedClone) {
                [[IMBLogManager singleton] writeInfoLog:@"calendar merge"];
                IMBCalendarSqliteManager *calendarManager = [[IMBCalendarSqliteManager alloc] initWithBackupfilePath:sourceBackupPath recordArray:sourceRecordArray];
                calendarManager.needQueryRedminder = YES;
                [calendarManager querySqliteDBContent];
                NSMutableArray *calendarArray = calendarManager.dataAry;
                IMBCalendarClone *calendarClone = [[IMBCalendarClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:NO];
                [calendarClone merge:calendarArray];
                [calendarClone release];
                if (calendarNeedClone) {
                    currentcloneCount++;
                    if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
                    }
                }
                [calendarManager release];
            }
        }
        @autoreleasepool {
            if (messageNeedClone) {
                [[IMBLogManager singleton] writeInfoLog:@"message merge"];
                IMBMessageSqliteManager *messageManager = [[IMBMessageSqliteManager alloc] initWithBackupfilePath:sourceBackupPath recordArray:sourceRecordArray];
                [messageManager querySqliteDBContent];
                NSMutableArray *messageArray = messageManager.dataAry;
                [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"message count:%lu",(unsigned long)[messageArray count]]];
                IMBMessageClone *messageClone = [[IMBMessageClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:NO];
                [messageClone merge:messageArray];
                [messageClone release];
                if (messageNeedClone) {
                    currentcloneCount++;
                    if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
                    }
                }
                [messageManager release];
            }
        }
        //note
        @autoreleasepool {
            if (noteNeedClone) {
                [[IMBLogManager singleton] writeInfoLog:@"note merge"];
                IMBNoteSqliteManager *noteManager = [[IMBNoteSqliteManager alloc] initWithBackupfilePath:sourceBackupPath recordArray:sourceRecordArray];
                [noteManager querySqliteDBContent];
                NSMutableArray *noteArray = noteManager.dataAry;
                IMBNoteClone *noteClone = [[IMBNoteClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:NO];
                [noteClone merge:noteArray];
                [noteClone release];
                if (noteNeedClone) {
                    currentcloneCount++;
                    if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
                    }
                }
                [noteManager release];
            }
        }
        
        @autoreleasepool {
            if (voicemail) {
                [[IMBLogManager singleton] writeInfoLog:@"voicemail merge"];
                IMBVoiceMailSqliteManager *voicemalManager = [[IMBVoiceMailSqliteManager alloc] initWithBackupfilePath:sourceBackupPath recordArray:sourceRecordArray];
                [voicemalManager querySqliteDBContent];
                NSMutableArray *voimailArray = [NSMutableArray array];//voicemalManager.dataAry;
                for (IMBVoiceMailAccountEntity *entity in voicemalManager.dataAry) {
                    if (entity.subArray.count > 0) {
                        [voimailArray addObjectsFromArray:entity.subArray];
                    }
                }
                IMBVoicemailClone *voicemailClone = [[IMBVoicemailClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:NO];
                [voicemailClone merge:voimailArray];
                [voicemailClone release];
                if (voicemail) {
                    currentcloneCount++;
                    if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
                    }
                }
                [voicemalManager release];
            }
        }
        
        @autoreleasepool {
            if (appNeedClone) {
                [[IMBLogManager singleton] writeInfoLog:@"app merge"];
                IMBAppClone *appClone = [[IMBAppClone alloc] initWithSourceBackupPath:sourceBackupPath desBackupPath:targetBackupPath sourcerecordArray:sourceRecordArray targetrecordArray:targetRecordArray isClone:NO];
                appClone.sourceApp = [_sourceIpod.applicationManager appEntityArray];
                appClone.targetApp = [_targetIpod.applicationManager appEntityArray];
                [appClone merge];
                [appClone release];
                currentcloneCount++;
                if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_tranferDelegate transferProgress:currentcloneCount/(1.0*clonetypeCount)*100];
                }
            }
        }
        if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_tranferDelegate transferPrepareFileStart:@"restoreDevice"];
        }
        if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_tranferDelegate transferPrepareFileStart:CustomLocalizedString(@"CloneMerge_Restor_Photo_Message", nil)];
        }
        @try {
             [[IMBLogManager singleton] writeInfoLog:@"start restore"];
            ((IMBMergeOrCloneViewController *)_tranferDelegate).restoreiPodKey = _targetIpod.uniqueKey;
            IMBBackAndRestore *backupAndRestore = [[IMBBackAndRestore alloc] initWithIPod:_targetIpod];
            [backupAndRestore restoreNSTask:nil restoreType:@"restore"];
            [backupAndRestore release];
            sleep(1);
        }
        @catch (NSException *exception) {
            [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"异常原因:%@",exception]];
        }
        [sourceBackupPath release];
        [sourceparase release];
        [sourceRecordArray release];
        [targetBackupPath release];
        [targetparase release];
        [targetRecordArray release];
        if (_hasError) {
            if ([_errorCode isEqualToString:@"-36"]) {
                [self performSelectorOnMainThread:@selector(transferError:) withObject:@"restore-36" waitUntilDone:YES];
            }else
            {
                [self performSelectorOnMainThread:@selector(transferError:) withObject:CustomLocalizedString(@"Clone_id_9", nil) waitUntilDone:YES];
            }
            if ([_tranferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                [_tranferDelegate cloneOrMergeComplete:NO];
            }
            return;
        }
    }else{
        if ([_tranferDelegate respondsToSelector:@selector(transferProgress:)]) {
            [_tranferDelegate transferProgress:100];
        }
        if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_tranferDelegate transferPrepareFileStart:@"insertData"];
        }
        if ([_tranferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_tranferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"MergeDevice_Message_Title", nil),_targetIpod.deviceInfo.deviceName]];
        }
        //直接进行to device
        IMBBetweenDeviceHandler *betweenTransfer = [[IMBBetweenDeviceHandler alloc] initWithSelectedModels:_categoryArr srcIpodKey:_sourceIpod.uniqueKey desIpodKey:_targetIpod.uniqueKey Delegate:_tranferDelegate];
        betweenTransfer.isClone = YES;
        [betweenTransfer startTransfer];
        [betweenTransfer release];
        if ([_tranferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
            [_tranferDelegate cloneOrMergeComplete:YES];
        }
    }
}

- (void)transferError:(NSString *)error
{
    if ([_tranferDelegate respondsToSelector:@selector(transferOccurError:)]) {
        _retry = [_tranferDelegate transferOccurError:error];
    }
}
- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:NOTIFY_BACKUP_ERROR object:nil];
    [nc removeObserver:self name:NOTIFY_RESTORE_ERROR object:nil];
    [nc removeObserver:self name:NOTIFY_BACKUP_PROGRESS object:nil];
    [nc removeObserver:self name:NOTIFY_RESTORE_PROGRESS object:nil];
    [_sourceIpod release],_sourceIpod = nil;
    [_targetIpod release],_targetIpod = nil;
    [_categoryArr release],_categoryArr = nil;
    [super dealloc];
}
@end
