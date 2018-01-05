//
//  IMBTransferToiOS.m
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBTransferToiOS.h"
#import "IMBAirSyncImportTransfer.h"
#import "IMBMessageToiOS.h"
#import "IMBContactToiOS.h"
#import "IMBCallLogToiOS.h"
#import "IMBCalendarToiOS.h"
#import "IMBBackAndRestore.h"
#import "IMBNotificationDefine.h"
#import "IMBSMSChatDataEntity.h"
#import "SystemHelper.h"
#import "IMBPhotoFileExport.h"
#import "IMBContactExport.h"
#import "IMBCalendarsToDevice.h"
#import "IMBCalendarEntity.h"
#import "IMBCalendarEventEntity.h"
@implementation IMBTransferToiOS

- (id)initWithIPodkey:(NSString *)ipodKey Android:(IMBAndroid *)android  TransferDataDic:(NSDictionary *)dataDic TransferDelegate:(id<TransferDelegate>)transferDelegate
{
    if (self = [super initWithIPodkey:ipodKey withDelegate:transferDelegate]) {
        _transferDic = [dataDic retain];
        _android = [android retain];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backupError:) name:NOTIFY_BACKUP_ERROR object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backupError:) name:NOTIFY_RESTORE_ERROR object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doBackUpProgress:) name:NOTIFY_BACKUP_PROGRESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doBackUpProgress:) name:NOTIFY_RESTORE_PROGRESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadFinish:) name:NOTIFY_INFORMATIONDATA_LOADFINISH object:nil];
    }
    return self;
}

- (void)setMessagConversion:(id <DataConversion>) messageConversion ContactConversion:(id <DataConversion>)contactConversion CallHistoryConversion:(id <DataConversion>) callHistoryConversion CalendarConversion:(id <DataConversion>)calendarConversion
{
    _messageConversion = [messageConversion retain];
    _contactConversion = [contactConversion retain];
    _callHistoryConversion = [callHistoryConversion retain];
    _calendarConversion = [calendarConversion retain];
}


- (void)setIsStop:(BOOL)isStop
{
    _isStop = isStop;
    [_android setIsStop:isStop];
    [_baseTransfer setIsStop:isStop];
}

- (void)setIsPause:(BOOL)isPause
{
    _isPause = isPause;
    [_android setIsPause:isPause];
    if (!isPause) {
        [_baseTransfer resumeScan];
    }else{
        [_baseTransfer pauseScan];
    }
}

#pragma mark  - 传输入口方法
- (void)startTransfer
{
    //流程:如果有info数据 则需要先备份，然后进行merge，设备重启之后再导入music。如果没有info数据，则直接导入。
    //导入media，需要现将media数据从android设备导入到电脑，然后再进行传输。导入info，需要先备份，然后把android数据类型转化为相对应的iOS数据类型
    [_loghandle writeInfoLog:@"IMBTransferToiOS enter"];
    OperationLImitation *operationLimitation = [OperationLImitation singleton];
    [operationLimitation setNeedlimit:NO];
    BOOL needBackup = NO;
    _successCount = 0;
    _failedCount = 0;
    _currItemIndex = 0;
    _totalItemCount = 0;
    _totalCount = 0;
    _currCount = 0;
    int infoCount = 0;
    _messageCount = 0;
    for (NSNumber *category in _transferDic.allKeys) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            if (category.intValue == Category_Message) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Messages" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (category.intValue == Category_Contacts) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Contacts" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (category.intValue == Category_Calendar) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Calendars" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (category.intValue == Category_CallHistory) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"CallHistory" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (category.intValue == Category_Music) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Music" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (category.intValue == Category_Movies) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Movies" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (category.intValue == Category_Ringtone) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Ringtones" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (category.intValue == Category_MyAlbums) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Albums" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (category.intValue == Category_iBooks) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Books" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (category.intValue == Category_Document) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Document" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (category.intValue == Category_Compressed) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Compressed File" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            for (id item in [_transferDic objectForKey:@(category.intValue)]) {
                if (category.intValue == Category_Message) {
                    IMBThreadsEntity *thread = (IMBThreadsEntity *)item;
                    [[IMBTransferError singleton] addAnErrorWithErrorName:thread.threadsname WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                }else if (category.intValue == Category_CallHistory){
                     IMBADCallContactEntity *adcontact = (IMBADCallContactEntity *)item;
                    for (IMBCallHistoryDataEntity *entity in adcontact.callArray) {
                         [[IMBTransferError singleton] addAnErrorWithErrorName:entity.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    }
                }else if (category.intValue == Category_Music || category.intValue == Category_Movies || category.intValue == Category_Ringtone){
                     IMBADAudioTrack *track = (IMBADAudioTrack *)item;
                    [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                }else if (category.intValue == Category_MyAlbums){
                    IMBADAlbumEntity *albumEntity = (IMBADAlbumEntity *)item;
                    for (IMBADPhotoEntity *entity in albumEntity.photoArray) {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:entity.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    }
                }else if (category.intValue == Category_iBooks || category.intValue == Category_Compressed || category.intValue == Category_Document){
                    IMBADFileEntity *file = (IMBADFileEntity *)item;
                    [[IMBTransferError singleton] addAnErrorWithErrorName:file.fileName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    
                }
            }

            
            break;
        }
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        if (category.intValue == Category_Message) {
            //有其中任何一个,都需要进行备份
            needBackup = YES;
            infoCount += 1;
            for (IMBThreadsEntity *thread in [_transferDic objectForKey:@(Category_Message)]) {
                _totalItemCount += [thread.messageList count];
                _messageCount += [thread.messageList count];
            }
            [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Messages" label:Start transferCount:_messageCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (category.intValue == Category_Contacts){
            NSArray *contactArray = [_transferDic objectForKey:@(Category_Contacts)];
            _totalItemCount += [contactArray count];
            _contactCount += [contactArray count];
            [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Contacts" label:Start transferCount:_contactCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (category.intValue == Category_Calendar){
            NSArray *calendarArray = [_transferDic objectForKey:@(Category_Calendar)];
            for (IMBCalendarAccountEntity *account in calendarArray) {
                _totalItemCount += [account.eventArray count];
                _calendarCount += [account.eventArray count];
            }
            [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Calendars" label:Start transferCount:_calendarCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (category.intValue == Category_CallHistory){
            needBackup = YES;
            infoCount += 1;
            for (IMBADCallContactEntity *adcontact in [_transferDic objectForKey:@(Category_CallHistory)]) {
                _totalItemCount += [adcontact.callArray count];
                _callHistoryCount += [adcontact.callArray count];
            }
            [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"CallHistory" label:Start transferCount:_callHistoryCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (category.intValue == Category_Music){
            _totalCount += 1;
            NSArray *musicArray = [_transferDic objectForKey:@(Category_Music)];
            _totalItemCount += [musicArray count];
            _musicCount += [musicArray count];
            [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Music" label:Start transferCount:_musicCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (category.intValue == Category_Movies){
            _totalCount += 1;
            NSArray *moviesArray = [_transferDic objectForKey:@(Category_Movies)];
            _totalItemCount += [moviesArray count];
            _moviesCount += [moviesArray count];
            [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Movies" label:Start transferCount:_moviesCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (category.intValue == Category_Ringtone){
            _totalCount += 1;
            NSArray *ringtoneArray = [_transferDic objectForKey:@(Category_Ringtone)];
            _totalItemCount += [ringtoneArray count];
            _ringtoneCount += [ringtoneArray count];
            [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Ringtones" label:Start transferCount:_ringtoneCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (category.intValue == Category_MyAlbums){
            _totalCount += 1;
            NSArray *photoArray = [_transferDic objectForKey:@(Category_MyAlbums)];
            for (IMBADAlbumEntity *album in photoArray) {
                _totalItemCount += [album.photoArray count];
                _myAblumsCount += [album.photoArray count];
            }
            [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Albums" label:Start transferCount:_myAblumsCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (category.intValue == Category_iBooks){
            _totalCount += 1;
            NSArray *iBooksArray = [_transferDic objectForKey:@(Category_iBooks)];
            _totalItemCount += [iBooksArray count];
            _iBookCount += [iBooksArray count];
            [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Books" label:Start transferCount:_iBookCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (category.intValue == Category_Document){
            _totalCount += 2;
            NSArray *documentArray = [_transferDic objectForKey:@(Category_Document)];
            _totalItemCount += [documentArray count];
            _documentCount += [documentArray count];
            [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Document" label:Start transferCount:_documentCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (category.intValue == Category_Compressed){
            _totalCount += 2;
            NSArray *compressedArray = [_transferDic objectForKey:@(Category_Compressed)];
            _totalItemCount += [compressedArray count];
            _compressedCount += [compressedArray count];
            [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Compressed File" label:Start transferCount:_compressedCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    }
    if (needBackup) {
        @autoreleasepool {
            [_loghandle writeInfoLog:@"IMBTransferToiOS needbackup"];
            _isToPC = NO;
            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                [_transferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Message_Id_5", nil),_ipod.deviceInfo.deviceName]];
            }
            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
                [_transferDelegate transferPrepareFileEnd];
            }
            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                [_transferDelegate transferPrepareFileStart:@"needDisClose"];
            }
            [self backupPhoto:_ipod];
            [_loghandle writeInfoLog:@"IMBTransferToiOS backupPhoto"];
            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transferDelegate transferFile:@""];
            }
        }
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_transferDelegate transferPrepareFileStart:@"backDevicesource"];
        }
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_transferDelegate transferPrepareFileStart:CustomLocalizedString(@"Transfer_text_id_1", nil)];
        }
        if (_isStop) {
            if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
                [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
            }
            return;
        }
        if ([self backup]) {
            //解析manfiest
            [_loghandle writeInfoLog:@"IMBTransferToiOS backup"];
            int infoCuCount = 0;
            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                [_transferDelegate transferPrepareFileStart:@"insertData"];
            }
            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                [_transferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"MergeDevice_Message_Title", nil),_ipod.deviceInfo.deviceName]];
            }
            NSString *backupPath = [[[TempHelper getBackupFolderPath] stringByAppendingPathComponent:_ipod.deviceHandle.udid] retain];
            IMBMBDBParse *backupparase = [[IMBMBDBParse alloc] initWithAMDevice:nil withbackupfilePath:backupPath];
            [backupparase parseManifest];
            [_loghandle writeInfoLog:@"IMBTransferToiOS parseManifest"];
            NSMutableArray *recordArray = [backupparase recordArray];
            
            @autoreleasepool {
                NSArray *messageArray = [_transferDic objectForKey:@(Category_Message)];
                if (messageArray.count>0) {
                    [_loghandle writeInfoLog:@"IMBTransferToiOS message enter"];
                    infoCuCount += 1;
                    IMBMessageToiOS *messageToiOS = [[IMBMessageToiOS alloc] initWithSourceBackupPath:nil desBackupPath:backupPath sourcerecordArray:nil targetrecordArray:recordArray isClone:NO];
                    [messageToiOS merge:[self messageConverison:messageArray]];
                    _successCount += _messageCount;
                    [messageToiOS release];
                    [_loghandle writeInfoLog:@"IMBTransferToiOS message quit"];

                }

            }
           
            @autoreleasepool {
                NSArray *callLogArray = [_transferDic objectForKey:@(Category_CallHistory)];
                if (callLogArray.count>0) {
                    [_loghandle writeInfoLog:@"IMBTransferToiOS calllog enter"];
                    infoCuCount += 1;
                    IMBCallLogToiOS *callLogToiOS = [[IMBCallLogToiOS alloc] initWithSourceBackupPath:nil desBackupPath:backupPath sourcerecordArray:nil targetrecordArray:recordArray isClone:NO];
                    [callLogToiOS merge:[self callhistoryConverison:callLogArray]];
                    _successCount += callLogToiOS.succesCount;
                    [callLogToiOS release];
                    [_loghandle writeInfoLog:@"IMBTransferToiOS calllog quit"];
                }

            }
            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                [_transferDelegate transferPrepareFileStart:@"restoreDevice"];
            }
            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                [_transferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"ToDevice_Message_Title", nil),_ipod.deviceInfo.deviceName]];
            }
            _ipod.isAndroidToiOS = YES;
            [_loghandle writeInfoLog:@"IMBTransferToiOS start restore"];

            IMBBackAndRestore *backupAndRestore = [[IMBBackAndRestore alloc] initWithIPod:_ipod];
            [backupAndRestore restoreNSTask:nil restoreType:@"restore"];
            [backupAndRestore release];
            [backupparase release];
            [_loghandle writeInfoLog:@"IMBTransferToiOS restore end"];
            //设备重启之后,在进行传输media和图片
        }
    }else{
        //需要调用android中的方法 将媒体文件传输到电脑
        //直接传输
        [self transferMedia:_ipod];
    }
}

#pragma mark - deviceIpodLoadComplete
- (void)dataLoadFinish:(NSNotification *)notification
{
    IMBiPod *ipod = notification.object;
    if ([ipod.uniqueKey isEqualToString:_ipod.uniqueKey] && ipod.deviceInfo.isIOSDevice&&!_hasError) {
        [MediaHelper killiTunes];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @autoreleasepool {
                if (_hasPhotoBack) {
                    //首先检测photolibrary
                    OperationLImitation *operationLimitation = [OperationLImitation singleton];
                    [operationLimitation setNeedlimit:NO];
                    BOOL readySync = NO;
                    for (int i=0;i<3;i++) {
                        if ([self readySync:ipod]) {
                            readySync= YES;
                            break;
                        }
                    }

                    NSMutableDictionary *allDic = [NSMutableDictionary dictionary];
                    //没有在相册中的photo library图片
                    NSString *photoBackupPath = [[SystemHelper userPicturePath] stringByAppendingPathComponent:@"AnytransPhotoBackup"];
                    NSString *libraryPath = [photoBackupPath stringByAppendingPathComponent:@"myPicture"];
                    NSMutableArray *photoLibraryArr = [self getfilePathInDir:libraryPath];
                    if ([photoLibraryArr count]>0) {
                        [allDic setObject:photoLibraryArr forKey:[NSNumber numberWithInt:Category_PhotoLibrary]];
                    }
                    //相册中的photo library图片
                    NSMutableDictionary *albumDic = [NSMutableDictionary dictionary];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    NSArray *contentArray = [fileManager contentsOfDirectoryAtPath:photoBackupPath error:nil];
                    for (NSString *name in contentArray) {
                        if (![name isEqualToString:@"myPicture"]&&![name isEqualToString:@".DS_Store"]) {
                            NSString *filePath = [photoBackupPath stringByAppendingPathComponent:name];
                            NSMutableArray *filePathArray = [self getfilePathInDir:filePath];
                            if ([filePathArray count]>0) {
                                [albumDic setObject:filePathArray forKey:name];
                            }
                        }
                    }
                    if (albumDic.allKeys.count > 0) {
                        [allDic setObject:albumDic forKey:[NSNumber numberWithInt:Category_MyAlbums]];
                    }
                    
                    if (allDic.allKeys.count > 0) {
                        _baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:ipod.uniqueKey TransferDic:allDic delegate:self];
                        [(IMBAirSyncImportTransfer *)_baseTransfer setIsRestore:YES];
                        _baseTransfer.isStop = _isStop;
                        [_baseTransfer startTransfer];
                        [_baseTransfer release];
                        _baseTransfer = nil;

                    }
                }
                _hasPhotoBack = NO;
                if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                    [_transferDelegate transferPrepareFileStart:@"needEnClose"];
                }
                [self transferMedia:ipod];
            }
        });
    }
}

#pragma mark - 判断同步是否准备好
- (BOOL)readySync:(IMBiPod *)ipod
{
    BOOL readySync = NO;
    IMBATHSync * athSync = [[IMBATHSync alloc] initWithiPod:ipod SyncNodes:nil syncCtrType:SyncAddFile photoAlbum:nil];
    [athSync setCurrentThread:[NSThread currentThread]];
    if ([athSync createAirSyncService]) {
        if ([athSync sendRequestSync]) {
            athSync.isStop = YES;
            [athSync waitSyncFinished];
            readySync = YES;
        }else{
            athSync.isStop = YES;
            [athSync waitSyncFinished];
        }
    }else{
        athSync.isStop = YES;
        [athSync waitSyncFinished];
        
    }
    [athSync release];
    return readySync;
}

- (NSMutableArray *)getfilePathInDir:(NSString *)dirPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *libraryArr = [NSMutableArray array];
    NSArray *arr = [fileManager contentsOfDirectoryAtPath:dirPath error:nil];
    for (NSString *name in arr) {
        if ([name hasSuffix:@"DS_Store"]) {
            continue;
        }
        NSString *filePath = [dirPath stringByAppendingPathComponent:name];
        [libraryArr addObject:filePath];
    }
    return libraryArr;
}

#pragma mark 传输媒体数据子方法
- (void)transferMedia:(IMBiPod *)ipod
{
    _isToPC = YES;
    _isTransMeida = YES;
    _mediaCount= 0;
    _cumediaCount = 0;
    NSMutableDictionary *mediaPathDic = [[NSMutableDictionary alloc] init];
    for (NSNumber *key in [_transferDic allKeys]) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            if (key.intValue == Category_Music) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Music" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (key.intValue == Category_Movies) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Movies" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (key.intValue == Category_Ringtone) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Ringtones" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (key.intValue == Category_MyAlbums) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Albums" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (key.intValue == Category_iBooks) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Books" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (key.intValue == Category_Compressed) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Compressed File" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (key.intValue == Category_Document) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Document" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (key.intValue == Category_Contacts) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Contacts" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (key.intValue == Category_Calendar) {
                [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Calendars" label:Stop transferCount:_totalItemCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            break;
        }

        switch (key.intValue) {
            case Category_Music:
            {
                @autoreleasepool {
                    _isToPC = YES;
                    NSString *audioPath = [self getLocalPath:@"AndroidAudioPath"];
                    NSArray *auidoArray = [_transferDic objectForKey:@(Category_Music)];
                    _android.adAudio.transDelegate = self;
                    [_android.adAudio exportContent:audioPath ContentList:auidoArray];
                    _currCount++;
                    [mediaPathDic setObject:audioPath forKey:@(Category_Music)];
                    NSDictionary *dimensionDict = nil;
                    @autoreleasepool {
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Music" label:Finish transferCount:_successCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                }
            }
                break;
            case Category_Movies:
            {
                @autoreleasepool {
                    _isToPC = YES;
                    NSString *moviesPath = [self getLocalPath:@"AndroidMoviesPath"];
                    NSArray *videoArray = [_transferDic objectForKey:@(Category_Movies)];
                    _android.adVideo.transDelegate = self;
                    [_android.adVideo exportContent:moviesPath ContentList:videoArray];
                    _currCount++;
                    [mediaPathDic setObject:moviesPath forKey:@(Category_Movies)];
                    NSDictionary *dimensionDict = nil;
                    @autoreleasepool {
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Movies" label:Finish transferCount:_successCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                }
            }
                break;
            case Category_Ringtone:
            {
                @autoreleasepool {
                    _isToPC = YES;
                    NSString *ringtonePath = [self getLocalPath:@"AndroidRingtonePath"];
                    NSArray *ringtoneArray = [_transferDic objectForKey:@(Category_Ringtone)];
                    _android.adRingtone.transDelegate = self;
                    [_android.adRingtone exportContent:ringtonePath ContentList:ringtoneArray];
                    _currCount++;
                    [mediaPathDic setObject:ringtonePath forKey:@(Category_Ringtone)];
                    NSDictionary *dimensionDict = nil;
                    @autoreleasepool {
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Ringtones" label:Finish transferCount:_successCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                }
            }
                break;
            case Category_MyAlbums:
            {
                @autoreleasepool {
                    _isToPC = YES;
                    NSString *photoPath = [self getLocalPath:@"AndroidPhotoPath"];
                    NSArray *photoArray = [_transferDic objectForKey:@(Category_MyAlbums)];
                    _android.adGallery.transDelegate = self;
                    [_android.adGallery exportContent:photoPath ContentList:photoArray];
                    _currCount++;
                    [mediaPathDic setObject:photoPath forKey:@(Category_MyAlbums)];
                    NSDictionary *dimensionDict = nil;
                    @autoreleasepool {
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Albums" label:Finish transferCount:_successCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                }
            }
                break;
            case Category_iBooks:
            {
                @autoreleasepool {
                    _isToPC = YES;
                    NSString *iBooksPath = [self getLocalPath:@"AndroidiBooksPath"];
                    NSArray *iBooksArray = [_transferDic objectForKey:@(Category_iBooks)];
                    _android.adDoucment.transDelegate = self;
                    [_android.adDoucment exportContent:iBooksPath ContentList:iBooksArray];
                    _currCount++;
                    [mediaPathDic setObject:iBooksPath forKey:@(Category_iBooks)];
                    NSDictionary *dimensionDict = nil;
                    @autoreleasepool {
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Books" label:Finish transferCount:_successCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                }
            }
                break;
                
            case Category_Compressed:
            {
                @autoreleasepool {
                    _isToPC = YES;
                    NSString *compressedPath = [self getLocalPath:@"AndroidCompressedPath"];
                    NSArray *compressArray = [_transferDic objectForKey:@(Category_Compressed)];
                    _android.adDoucment.transDelegate = self;
                    _android.adDoucment.isDocument = NO;
                    [_android.adDoucment exportContent:compressedPath ContentList:compressArray];
                    _currCount++;
                    NSArray *comArray = [self getfilePathInDir:compressedPath];
                    //进行导入
                    _isToPC = NO;
                    _transferDocument = YES;
                    _baseTransfer = [[IMBBaseTransfer alloc] initWithIPodkey:ipod.uniqueKey importTracks:comArray withCurrentPath:@"/general_storage" withDelegate:self];
                    _baseTransfer.isStop = _isStop;
                    [_baseTransfer startTransfer];
                    [_baseTransfer release];
                    _baseTransfer = nil;
                    _currCount++;
                    _transferDocument = NO;
                    NSDictionary *dimensionDict = nil;
                    @autoreleasepool {
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Compressed File" label:Finish transferCount:_successCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                }
            }
                break;
            case Category_Document:
            {
                @autoreleasepool {
                    _isToPC = YES;
                    NSString *documentPath = [self getLocalPath:@"AndroidDocumentPath"];
                    NSArray *documentArray = [_transferDic objectForKey:@(Category_Document)];
                    _android.adDoucment.transDelegate = self;
                    _android.adDoucment.isDocument = YES;
                    [_android.adDoucment exportContent:documentPath ContentList:documentArray];
                    _currCount++;
                    NSArray *docArray = [self getfilePathInDir:documentPath];
                    //进行导入
                    _isToPC = NO;
                    _transferDocument = YES;
                    _baseTransfer = [[IMBBaseTransfer alloc] initWithIPodkey:ipod.uniqueKey importTracks:docArray withCurrentPath:@"/general_storage" withDelegate:self];
                    _baseTransfer.isStop = _isStop;
                    [_baseTransfer startTransfer];
                    [_baseTransfer release];
                    _baseTransfer = nil;
                    _currCount++;
                    _transferDocument = NO;
                    NSDictionary *dimensionDict = nil;
                    @autoreleasepool {
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Document" label:Finish transferCount:_successCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    if (dimensionDict) {
                        [dimensionDict release];
                        dimensionDict = nil;
                    }
                }
            }
                break;
            case Category_Contacts:
            {
                _mediaCount++;
            }
                break;
            case Category_Calendar:
            {
                _mediaCount++;

            }
                break;
        }
    }
    _isToPC = NO;
    if ([mediaPathDic.allKeys count]>0) {
        _mediaCount += 1;
    }
    _cumeidaProgress = 0;
    NSArray *contactArray = [_transferDic objectForKey:@(Category_Contacts)];
    if (contactArray.count>0) {
        _cumediaCount++;
        IMBContactExport *contactExport = [[IMBContactExport alloc]initWithIPodkey:ipod.uniqueKey withDelegate:self];
        _baseTransfer = contactExport;
        contactExport.contactManager = [[IMBContactManager alloc]initWithAMDevice:ipod.deviceHandle];
        contactExport.isStop = _isStop;
        [contactExport importContact:[self contactConverison:contactArray]];
        [contactExport release];
        _cumeidaProgress = _cumediaCount*1.0/_mediaCount;
        _baseTransfer = nil;
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Contacts" label:Finish transferCount:_successCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    }
    
    NSArray *calendarArray = [_transferDic objectForKey:@(Category_Calendar)];
    if (calendarArray.count>0) {
        _cumediaCount++;
        IMBInformationManager *manager= [IMBInformationManager shareInstance];
        IMBInformation *information = [manager.informationDic objectForKey:ipod.uniqueKey];
        if (information.calendarArray.count > 0) {
            NSMutableArray *eventArray = [NSMutableArray array];
            for (IMBCalendarAccountEntity *account in calendarArray) {
                [eventArray addObjectsFromArray:account.eventArray];
            }
            IMBCalendarEntity *calendarEntity = [information.calendarArray objectAtIndex:0];
            _baseTransfer = [[IMBCalendarsToDevice alloc] initWithCalendarID:calendarEntity.calendarID selectedArray:[self calendarConverison:eventArray] desiPodKey:ipod.uniqueKey delegate:self];
            _baseTransfer.isStop = _isStop;
            [_baseTransfer startTransfer];
            _cumeidaProgress = _cumediaCount*1.0/_mediaCount;
            [_baseTransfer release];
            _baseTransfer = nil;
            NSDictionary *dimensionDict = nil;
            @autoreleasepool {
                dimensionDict = [[TempHelper customDimension] copy];
            }
            [ATTracker event:Move_To_iOS action:ToDevice actionParams:@"Calendars" label:Finish transferCount:_successCount screenView:@"MoveToiOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
        }
    }
    if ([mediaPathDic.allKeys count]>0) {
        _cumediaCount++;
        _baseTransfer = [[IMBAirSyncImportTransfer alloc] initWithIPodkey:ipod.uniqueKey TransferDic:mediaPathDic delegate:self];
        _baseTransfer.isStop = _isStop;
        [_baseTransfer startTransfer];
        [_baseTransfer release];
        _baseTransfer = nil;
    }
    [mediaPathDic release];
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
    _isTransMeida = NO;
    OperationLImitation *operationLimitation = [OperationLImitation singleton];
    [operationLimitation setNeedlimit:YES];
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
    _isToPC = NO;
    _transferDocument = NO;
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
                _hasPhotoBack = YES;
                _baseTransfer = [[IMBPhotoFileExport alloc] initWithIPodkey:tariPod.uniqueKey exportTracks:libarray exportFolder:photoLibraryPath withDelegate:nil];
                _baseTransfer.isStop = _isStop;
                [(IMBPhotoFileExport *)_baseTransfer setExportType:1];
                [_baseTransfer startTransfer];
                [_baseTransfer release];
                _baseTransfer = nil;
                sleep(1);
            }else{
                [fileManager removeItemAtPath:photoLibraryPath error:nil];
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
                        _hasPhotoBack = YES;
                        _baseTransfer = [[IMBPhotoFileExport alloc] initWithIPodkey:tariPod.uniqueKey exportTracks:photoArray exportFolder:albumPath withDelegate:nil];
                        _baseTransfer.isStop = _isStop;
                        [(IMBPhotoFileExport *)_baseTransfer setExportType:1];
                        [_baseTransfer startTransfer];
                        [_baseTransfer release];
                        _baseTransfer = nil;
                        sleep(1);
                    }
                }
            }
        }
    }
}

#pragma mark - TransferDelegate
- (void)transferPrepareFileStart:(NSString *)file
{
    if (![StringHelper stringIsNilOrEmpty:file]) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            if (_isToPC) {
                [_transferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Android_MSG_COM_Prepare", nil),file]];
            }else {
                [_transferDelegate transferPrepareFileStart:file];
            }
        }
    }
}

- (void)transferPrepareFileEnd
{
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transferDelegate transferPrepareFileEnd];
    }
}

- (void)transferFile:(NSString *)file
{
    if (![StringHelper stringIsNilOrEmpty:file]) {
        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
            if (_isToPC) {
                [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Android_MSG_COM_Prepare", nil),file]];
            }else {
                [_transferDelegate transferFile:file];
            }
        }
    }
}

- (BOOL)transferOccurError:(NSString *)error
{
    if ([_transferDelegate respondsToSelector:@selector(transferOccurError:)]) {
        [_transferDelegate transferOccurError:error];
    }
    return NO;
}

- (void)transferProgress:(float)progress
{
    if (_isToPC) {
        _progress = _currCount/(_totalCount*1.0)*100 + 1/(_totalCount*1.0)*progress;
    }else if (_isTransMeida){
        _progress = _cumeidaProgress*100 + (1.0/_mediaCount)*progress;
    }else{
        _progress = progress;
    }
    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
        [_transferDelegate transferProgress:_progress];
    }
}

- (void)transferComplete:(int)successCount TotalCount:(int)totalCount
{
    if ((!_isToPC||_transferDocument)&&!_hasPhotoBack) {
        _successCount += successCount;
    }
}

- (NSString *)getLocalPath:(NSString *)localName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *temPath = [IMBHelper getAppTempPath];
    NSString *path = [temPath stringByAppendingPathComponent:localName];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
    if ([fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
        return path;
    }else{
        return nil;
    }
}

#pragma mark - 数据转换类方法
- (NSMutableArray *)messageConverison:(NSArray *)message
{
    [_loghandle writeInfoLog:@"IMBTransferToiOS messageConverison enter"];
    NSMutableArray *messageArray = [NSMutableArray array];
    for (id entity in message) {
        IMBThreadsEntity *threadentity = entity;
        [_loghandle writeInfoLog:[NSString stringWithFormat:@"threadsname:%@ messageCount:%d recipients%@",threadentity.threadsname,threadentity.messageCount,threadentity.recipients]];
        id centity =[_messageConversion dataConversion:entity];
        [messageArray addObject:centity];
        [_loghandle writeInfoLog:@"dataConversion end"];
    }
    [_loghandle writeInfoLog:@"IMBTransferToiOS messageConverison quit"];
    return messageArray;
}

- (NSMutableArray *)contactConverison:(NSArray *)contact
{
    NSMutableArray *contactArray = [NSMutableArray array];
    for (id entity in contact) {
        id centity =[_contactConversion dataConversion:entity];
        [contactArray addObject:centity];
    }
    return contactArray;
}

- (NSMutableArray *)callhistoryConverison:(NSArray *)callhistory
{
    NSMutableArray *callhistoryArray = [NSMutableArray array];
    for (id entity in callhistory) {
        id centity =[_callHistoryConversion dataConversion:entity];
        [callhistoryArray addObject:centity];
    }
    return callhistoryArray;
}

- (NSMutableArray *)calendarConverison:(NSArray *)calendar
{
    NSMutableArray *calendarArray = [NSMutableArray array];
    for (IMBADCalendarEntity *entity in calendar) {
        IMBCalendarEventEntity *calendarEventEntity = [[IMBCalendarEventEntity alloc]init];
        
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:entity.calendarStartTime/1000 ];
        [calendarEventEntity setStartCurDate:startDate];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:entity.calendarEndTime/1000 ];
        [calendarEventEntity setEndCurDate:endDate];
        [calendarEventEntity setSummary:entity.calendarTitle];
        [calendarEventEntity setLocation:entity.calendarLocation];
        [calendarEventEntity setUrl:@""];
        [calendarEventEntity setEventdescription:entity.calendarDescription];
        [calendarArray addObject:calendarEventEntity];
        [calendarEventEntity release];
    }
    return calendarArray;
}

- (BOOL)backup
{
    @autoreleasepool {
        IMBBackAndRestore *backandstore = [[IMBBackAndRestore alloc] initWithIPod:_ipod];
        backandstore.isServiceBackup = NO;
        [backandstore backUp];
        [backandstore release];
        sleep(1);
        if (_hasError) {
            if ([_errorCode isEqualToString:@"-30"]) {
                _retry = NO;
                [self performSelectorOnMainThread:@selector(transferError:) withObject:@"source-30" waitUntilDone:YES];
                if ([_transferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                    [_transferDelegate cloneOrMergeComplete:NO];
                }
                return NO;
            }else if ([_errorCode isEqualToString:@"-35"])
            {
                [self performSelectorOnMainThread:@selector(transferError:) withObject:@"source-35" waitUntilDone:YES];
                if ([_transferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                    [_transferDelegate cloneOrMergeComplete:NO];
                }
                return NO;
            }else
            {
                [self performSelectorOnMainThread:@selector(transferError:) withObject:CustomLocalizedString(@"Clone_id_9", nil) waitUntilDone:YES];
                if ([_transferDelegate respondsToSelector:@selector(cloneOrMergeComplete:)]) {
                    [_transferDelegate cloneOrMergeComplete:NO];
                }
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - backup error
- (void)backupError:(NSNotification *)notification
{
    if (_errorCode != nil) {
        [_errorCode release];
        _errorCode = nil;
    }
    _errorCode = [[notification.userInfo objectForKey:NOTIFY_ERROR_CODE] retain];
    _hasError = YES;
}

- (void)transferError:(NSString *)error
{
    if ([_transferDelegate respondsToSelector:@selector(transferOccurError:)]) {
        _retry = [_transferDelegate transferOccurError:error];
    }
}

- (void)doBackUpProgress:(NSNotification *)notification {
    NSDictionary *dic = [notification userInfo];
    if (dic != nil) {
        double progress = [[dic objectForKey:@"BRProgress"] doubleValue];
        if (progress >=100){
            progress = 100.0;
        }
        if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
            [_transferDelegate transferProgress:progress];
        }
    }
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:NOTIFY_BACKUP_ERROR object:nil];
    [nc removeObserver:self name:NOTIFY_RESTORE_ERROR object:nil];
    [nc removeObserver:self name:NOTIFY_BACKUP_PROGRESS object:nil];
    [nc removeObserver:self name:NOTIFY_RESTORE_PROGRESS object:nil];
    [nc removeObserver:self name:NOTIFY_INFORMATIONDATA_LOADFINISH object:nil];
    [_errorCode release],_errorCode = nil;
    [_messageConversion release],_messageConversion = nil;
    [_contactConversion release],_contactConversion = nil;
    [_callHistoryConversion release],_callHistoryConversion = nil;
    [_calendarConversion release],_calendarConversion = nil;
    [super dealloc];
}
@end
