//
//  IMBTransferToiCloud.m
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBTransferToiCloud.h"
#import "IMBiCloudContactEntity.h"
#import "IMBiCloudCalendarEventEntity.h"
#import "StringHelper.h"

@implementation IMBTransferToiCloud

- (void)dealloc{
#if !__has_feature(objc_arc)
    [_icloudManager release],_icloudManager = nil;
    [super dealloc];
#endif
}

- (id)initWithTransferDataDic:(NSDictionary *)dataDic TransferDelegate:(id<TransferDelegate>)transferDelegate iCloudManager:(IMBiCloudManager *)icloudManager withAndroid:(IMBAndroid *)android
{
    if (self = [super initWithTransferDataDic:dataDic TransferDelegate:transferDelegate]) {
        _icloudManager = [icloudManager retain];
        _transferDic = [dataDic retain];
        _android = [android retain];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)setContactConversion:(ContactConversioniCloud *)contactConversion calendarConversion:(CalendarConversioniCloud *)calendarConversion photoConversion:(PhotoConversioniCloud *)photoConversion {
    _contactConversion = [contactConversion retain];
    _calendarConversion = [calendarConversion retain];
    _photoConversion = [photoConversion retain];
    NSArray *allkey = [_transferDic allKeys];
    if ([allkey count] > 0) {
        for (NSNumber *category in allkey) {
            NSArray *selectedAry = [_transferDic objectForKey:category];
            if (category.intValue == Category_Photo) {
                for (IMBADAlbumEntity *entity in selectedAry) {
                    photoCount = (int)[[entity photoArray] count];
                    _totalItemCount += photoCount;
                }
            }else if (category.intValue == Category_Calendar){
                for (IMBCalendarAccountEntity *entity in selectedAry) {
                    calendarCount = (int)[[entity eventArray] count];
                    _totalItemCount += calendarCount;
                }
            }else {
                contactCount = (int)selectedAry.count;
                _totalItemCount += contactCount;
            }
        }
    }
}

- (void)setIsStop:(BOOL)isStop
{
    _isStop = isStop;
    [_android setIsStop:isStop];
    [self stopScan];
}

- (void)setIsPause:(BOOL)isPause
{
    _isPause = !isPause;
    [_android setIsPause:isPause];
    if (!isPause) {
        [self resumeScan];
    }else{
        [self pauseScan];
    }
}

#pragma mark -- Move to iCloud：Contact、Calendar、Photos
- (void)startTransfer
{
    NSArray *allkey = [_transferDic allKeys];
    if ([allkey count] > 0) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
        NSString *iCloudImageCache = nil;
        for (NSNumber *category in allkey) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                NSArray *selectedAry = [_transferDic objectForKey:category];
                if (category.intValue == Category_Contacts) {
                    for (IMBADContactEntity *entity in selectedAry) {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:entity.contactName.value WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    }
                }else if (category.intValue == Category_Calendar) {
                    for (IMBCalendarAccountEntity *entity in selectedAry) {
                        for (IMBADCalendarEntity *calendarEntity in entity.eventArray) {
                            [[IMBTransferError singleton] addAnErrorWithErrorName:calendarEntity.calendarTitle WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                        }
                    }
                }else if (category.intValue == Category_Photo) {
                    for (IMBADAlbumEntity *album in selectedAry) {
                        for (IMBADPhotoEntity *photo in album.photoArray) {
                            [[IMBTransferError singleton] addAnErrorWithErrorName:photo.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                        }
                    }
                }
                continue;
            }
            NSArray *selectedAry = [_transferDic objectForKey:category];
            if (category.intValue == Category_Contacts) {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:Move_To_iOS action:ToiCloud actionParams:@"Contacts" label:Start transferCount:contactCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                int selectCount = 0;
                BOOL flag = NO;
                for (id entity in selectedAry) {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        if ([entity isKindOfClass:[IMBADContactEntity class]]) {
                            IMBADContactEntity *iCloudContact = (IMBADContactEntity *)entity;
                            [[IMBTransferError singleton] addAnErrorWithErrorName:iCloudContact.contactName.value WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                        }
                        if (!flag) {
                            [ATTracker event:Move_To_iOS action:ToiCloud actionParams:@"Contacts" label:Stop transferCount:selectCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                            flag = YES;
                        }
                        continue;
                    }
                    [_contactConversion conversionToiCloud:entity];
                    selectCount++;
                }
                contactCount = 0;
                NSArray *contactAllKey = [[_contactConversion conversionDict] allKeys];
                if ([contactAllKey count] > 0) {
                    BOOL flag = NO;
                    for (NSString *contactStr in contactAllKey) {
                        [_condition lock];
                        if (_isPause) {
                            [_condition wait];
                        }
                        [_condition unlock];
                        if (_isStop) {
                            IMBiCloudContactEntity *entity = [[_contactConversion conversionDict] objectForKey:contactStr];
                            [[IMBTransferError singleton] addAnErrorWithErrorName:entity.allName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                            if (!flag) {
                                [ATTracker event:Move_To_iOS action:ToiCloud actionParams:@"Contacts" label:Stop transferCount:contactCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                                flag = YES;
                            }
                            continue;
                        }
                        _currItemIndex++;
                        IMBiCloudContactEntity *entity = [[_contactConversion conversionDict] objectForKey:contactStr];
                        if (![IMBHelper stringIsNilOrEmpty:entity.fullName] && [_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                            [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),[entity fullName]]];
                        }
                        CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
                        NSString *addGuid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
                        [entity setContactId:addGuid];
                        
                        //每次都必须请求一次数据
                        [_icloudManager getContactContent];
                        //To iCloud
                       BOOL success = [_icloudManager importAndroidContact:entity];
                        if (success) {
                            contactCount += 1;
                            _successCount += 1;
                        }
                        if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                            [_transferDelegate transferProgress:_currItemIndex/(_totalItemCount*1.0)*100];
                        }
                    }
                }
                [ATTracker event:Move_To_iOS action:ToiCloud actionParams:@"Contacts" label:Finish transferCount:contactCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
            }else if (category.intValue == Category_Calendar) {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:Move_To_iOS action:ToiCloud actionParams:@"Calendars" label:Start transferCount:calendarCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                int selectCount = 0;
                BOOL flag = NO;
                for (id entity in selectedAry) {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        if ([entity isKindOfClass:[IMBCalendarAccountEntity class]]) {
                            IMBCalendarAccountEntity *accountEntity = (IMBCalendarAccountEntity *)entity;
                            for (IMBADCalendarEntity *calendarEntity in accountEntity.eventArray) {
                                [[IMBTransferError singleton] addAnErrorWithErrorName:calendarEntity.calendarTitle WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                            }
                        }
                        if (!flag) {
                            [ATTracker event:Move_To_iOS action:ToiCloud actionParams:@"Calendars" label:Stop transferCount:selectCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                            flag = YES;
                        }
                        continue;
                    }
                    [_calendarConversion conversionAccountToiCloud:entity];
                    selectCount++;
                }
                calendarCount = 0;
                NSArray *eventAllKey = [[_calendarConversion conversionDict] allKeys];
                if ([eventAllKey count] > 0) {
                    BOOL flag = NO;
                    for (NSString *acountID in eventAllKey) {
                        [_condition lock];
                        if (_isPause) {
                            [_condition wait];
                        }
                        [_condition unlock];
                        if (_isStop) {
                            NSMutableDictionary *acountDict = [[_calendarConversion conversionDict] objectForKey:acountID];
                            for (NSString *eventID in [acountDict allKeys]) {
                                if ([eventID isEqualToString:@"accountName"]) {
                                    continue;
                                }
                                id item = [acountDict objectForKey:eventID];
                                if ([item isKindOfClass:[IMBiCloudCalendarEventEntity class]]) {
                                    IMBiCloudCalendarEventEntity *entity = (IMBiCloudCalendarEventEntity *)item;
                                    [[IMBTransferError singleton] addAnErrorWithErrorName:entity.summary WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                                }
                            }
                            if (!flag) {
                                [ATTracker event:Move_To_iOS action:ToiCloud actionParams:@"Calendars" label:Stop transferCount:calendarCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                                flag = YES;
                            }
                            continue;
                        }
                        NSMutableDictionary *acountDict = [[_calendarConversion conversionDict] objectForKey:acountID];
                        if (acountDict) {
                            BOOL success = NO;
                            if ([_icloudManager getCalendarCollectionContentName:[acountDict objectForKey:@"accountName"]]) {
                                success = YES;
                            }else {
                                //创建Calendar Conllection
                                success = [_icloudManager addCalenderCollection:[acountDict objectForKey:@"accountName"]];
                            }
                            if (success) {
                                BOOL flag = NO;
                                for (NSString *eventID in [acountDict allKeys]) {
                                    [_condition lock];
                                    if (_isPause) {
                                        [_condition wait];
                                    }
                                    [_condition unlock];
                                    if (_isStop) {
                                        if ([eventID isEqualToString:@"accountName"]) {
                                            continue;
                                        }
                                        id item = [acountDict objectForKey:eventID];
                                        if ([item isKindOfClass:[IMBiCloudCalendarEventEntity class]]) {
                                            IMBiCloudCalendarEventEntity *entity = (IMBiCloudCalendarEventEntity *)item;
                                            [[IMBTransferError singleton] addAnErrorWithErrorName:entity.summary WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                                        }
                                        if (!flag) {
                                           [ATTracker event:Move_To_iOS action:ToiCloud actionParams:@"Calendars" label:Stop transferCount:calendarCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                                            flag = YES;
                                        }
                                        continue;
                                    }
                                    if ([eventID isEqualToString:@"accountName"]) {
                                        continue;
                                    }
                                    _currItemIndex++;
                                    IMBiCloudCalendarEventEntity *entity = [acountDict objectForKey:eventID];
                                    for (IMBiCloudCalendarCollectionEntity *colleciton in _icloudManager.calendarCollectionArray) {
                                        if ([colleciton.title isEqualToString:[acountDict objectForKey:@"accountName"]]) {
                                            CFUUIDRef guidref = CFUUIDCreate(kCFAllocatorDefault);
                                            NSString *addGuid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, guidref);
                                            entity.guid = addGuid;
                                            entity.pGuid = colleciton.guid;
                                            break;
                                        }
                                    }
                                    if (![IMBHelper stringIsNilOrEmpty:entity.summary] && [_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                        [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil), entity.summary]];
                                    }
                                    
                                    //To iCloud
                                    BOOL success = [_icloudManager addCalender:entity];
                                    if (success) {
                                        calendarCount += 1;
                                        _successCount += 1;
                                    }
                                    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                                        [_transferDelegate transferProgress:_currItemIndex/(_totalItemCount*1.0)*100];
                                    }
                                }
                            }else {
                                NSLog(@"创建日历组失败");
                            }
                        }
                    }
                    [_icloudManager getCalendarContent];
                }
                [ATTracker event:Move_To_iOS action:ToiCloud actionParams:@"Calendars" label:Finish transferCount:calendarCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
            }else if (category.intValue == Category_Photo) {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:Move_To_iOS action:ToiCloud actionParams:@"Photo Library" label:Start transferCount:photoCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                iCloudImageCache = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"iCloudImageCache"];
                if ([[NSFileManager defaultManager] fileExistsAtPath:iCloudImageCache]) {
                    [[NSFileManager defaultManager] removeItemAtPath:iCloudImageCache error:nil];
                }
                if (![[NSFileManager defaultManager] fileExistsAtPath:iCloudImageCache]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:iCloudImageCache withIntermediateDirectories:YES attributes:nil error:nil];
                }
                //导出Photo到iCloudImageCache临时目录下
                [[_android adGallery] setTransDelegate:self];
                [[_android adGallery] exportContent:iCloudImageCache ContentList:selectedAry];
                
                int selectCount = 0;
                BOOL flag = NO;
                for (id entity in selectedAry) {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        if ([entity isKindOfClass:[IMBADAlbumEntity class]]) {
                            IMBADAlbumEntity *album = (IMBADAlbumEntity *)entity;
                            for (IMBADPhotoEntity *photoEntity in album.photoArray) {
                                [[IMBTransferError singleton] addAnErrorWithErrorName:photoEntity.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                            }
                        }
                        if (!flag) {
                            [ATTracker event:Move_To_iOS action:ToiCloud actionParams:@"Photo Library" label:Stop transferCount:selectCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                            flag = YES;
                        }
                        continue;
                    }
                    IMBADAlbumEntity *albumEntity = nil;
                    if ([entity isMemberOfClass:[IMBADAlbumEntity class]]) {
                        albumEntity = (IMBADAlbumEntity *)entity;
                    }
                    [_photoConversion conversionAlbumToiCloud:entity];
                    selectCount++;
                }
                float index = _copyPhotoItem * 0.2;
                float copyProgress = (index/(_totalItemCount*1.0))*_copyProgressPercent*0.2*100;
                float photoProgressPercent = 1 - (copyProgress / 100);
                _copyPhotoItem = 0;
                photoCount = 0;
                NSArray *albumAllKey = [[_photoConversion conversionDict] allKeys];
                if ([albumAllKey count] > 0) {
                    BOOL flag = NO;
                    for (NSString *albumID in albumAllKey) {
                        [_condition lock];
                        if (_isPause) {
                            [_condition wait];
                        }
                        [_condition unlock];
                        if (_isStop) {
                             NSMutableArray *albumAry = [[_photoConversion conversionDict] objectForKey:albumID];
                            for (id item in albumAry) {
                                if ([item isKindOfClass:[IMBToiCloudPhotoEntity class]]) {
                                    IMBToiCloudPhotoEntity *entity = (IMBToiCloudPhotoEntity *)item;
                                    [[IMBTransferError singleton] addAnErrorWithErrorName:entity.photoTitle WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                                }
                            }
                            if (!flag) {
                                [ATTracker event:Move_To_iOS action:ToiCloud actionParams:@"Photo Library" label:Stop transferCount:photoCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                                flag = YES;
                            }
                            continue;
                        }
                        NSMutableArray *albumAry = [[_photoConversion conversionDict] objectForKey:albumID];
                        if (albumAry) {
                            [_icloudManager getPhotosContent];
                            //创建Photo Album
                            BOOL success = [_icloudManager addPhotoAlbum:albumID];
                            if (success) {
                                BOOL flag=FALSE;
                                for (IMBToiCloudPhotoEntity *entity in albumAry) {
                                    [_condition lock];
                                    if (_isPause) {
                                        [_condition wait];
                                    }
                                    [_condition unlock];
                                    if (_isStop) {
                                        [[IMBTransferError singleton] addAnErrorWithErrorName:entity.photoTitle WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                                        if (!flag) {
                                            [ATTracker event:Move_To_iOS action:ToiCloud actionParams:@"Photo Library" label:Stop transferCount:photoCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                                            flag = YES;
                                        }
                                        continue;
                                    }
                                    
                                    if (![IMBHelper stringIsNilOrEmpty:entity.photoName] && [_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                        [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil), [entity photoName]]];
                                    }
                                    _currItemIndex++;
                                    IMBToiCloudPhotoEntity *photoEntity = [_icloudManager.albumArray lastObject];
                                    NSString *containerId = nil;
                                    if (photoEntity != nil && ![photoEntity.clientId isEqualToString:@"CPLAssetByAddedDate"]) {
                                        containerId = [photoEntity recordName];
                                    }
                                    if (containerId) {
                                        NSString *filePathFolder = [iCloudImageCache stringByAppendingPathComponent:albumID];
                                        NSString *filePath = [filePathFolder stringByAppendingPathComponent:entity.photoTitle];
                                        NSString *pathExtension = [[filePath lastPathComponent] pathExtension];
                                        
                                        /**
                                         *  文件格式转换：png --> jpg
                                         */
                                        if ([pathExtension isEqualToString:@"png"]) {
                                            NSString *stringPathExtension = [filePath stringByDeletingPathExtension];
                                            BOOL success = [self startConvert:stringPathExtension withConvetPath:stringPathExtension withPathExtension:pathExtension];
                                            if (success) {
                                                [_fileManager removeItemAtPath:filePath error:nil];
                                                NSString *entityPathExtension = [[entity photoTitle] stringByDeletingPathExtension];
                                                NSString *convertEntityPathExtension = [NSString stringWithFormat:@"%@.jpg", entityPathExtension];
                                                filePath = [filePathFolder stringByAppendingPathComponent:convertEntityPathExtension];
                                            }
                                        }
                                        
                                        //To iCloud
                                        BOOL result = [_icloudManager uploadPhoto:filePath withContainerId:containerId];
                                        if (result) {
                                            photoCount += 1;
                                            _successCount += 1;
                                        }
                                        if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                                            [_transferDelegate transferProgress:(copyProgress + ((_currItemIndex)/(_totalItemCount*1.0))*photoProgressPercent*100)];
                                        }
                                    }
                                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                        [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),CustomLocalizedString(@"MenuItem_id_77", nil)]];
                                    }
                                    
                                }
                            }else {
                                for (IMBToiCloudPhotoEntity *entity in albumAry) {
                                    [[IMBTransferError singleton] addAnErrorWithErrorName:entity.photoTitle WithErrorReson:CustomLocalizedString(@"Ex_Op_AddAlbumFail_ToiCloud", nil)];
                                }
                                
                                NSLog(@"创建相册失败，请打开图片库");
                            }
                        }
                    }
                }
                [ATTracker event:Move_To_iOS action:ToiCloud actionParams:@"Photo Library" label:Finish transferCount:photoCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
            }
        }
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
        [self resetTrackCount];
        if ([_fileManager fileExistsAtPath:iCloudImageCache]) {
            [_fileManager removeItemAtPath:iCloudImageCache error:nil];
        }
    }
}

- (void)resetTrackCount {
    contactCount = 0;
    calendarCount = 0;
    photoCount = 0;
}

/**
 *  格式转换
 *
 *  @param sourPath      源文件路径
 *  @param conPath       目标文件路径
 *  @param pathExtension 源文件后缀名
 *
 *  @return return YES or NO
 */
- (BOOL)startConvert:(NSString *)sourPath withConvetPath:(NSString *)conPath withPathExtension:(NSString *)pathExtension {
    [_loghandle writeInfoLog:@"start Convert"];
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-i",[NSString stringWithFormat:@"%@.%@",sourPath,pathExtension],[NSString stringWithFormat:@"%@.jpg",conPath],nil];
    return [self runFFMpeg:params];
}

- (BOOL)runFFMpeg:(NSArray*)params {
    [_loghandle writeInfoLog:@"ffmpeg Start"];
    NSString* ffmpegPath = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:@""];
    
    if (params != nil) {
        NSTask *task = [[NSTask alloc] init];
        //Todo这里需要异步操作!!
        [task setLaunchPath: ffmpegPath];
        [task setArguments: params];
        
        [task launch];
        [task waitUntilExit];
        sleep(1);
        int status = [task terminationStatus];
        [task release];
        if (status == 0) {
            NSLog(@"Task succeeded.");
            [_loghandle writeInfoLog:@"ConvertMov succeeded"];
            return YES;
        } else {
            NSLog(@"Task failed.");
            [_loghandle writeInfoLog:@"ConvertMov failed"];
            return NO;
        }
    }
    return NO;
}

//传输准备进度开始
- (void)transferPrepareFileStart:(NSString *)file {
}

//传输准备进度结束
- (void)transferPrepareFileEnd {
}

//传输进度
- (void)transferProgress:(float)progress {
    float otherProgress = (_currItemIndex/(_totalItemCount*1.0))*100;
    _copyProgressPercent = 1 - (otherProgress / 100);
    _copyPhotoItem++;
    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
        float index = _copyPhotoItem * 0.2;
        [_transferDelegate transferProgress:(otherProgress + (index/(_totalItemCount*1.0))*_copyProgressPercent*0.2*100)];
    }
}

//当前传输文件的名字或者路径
- (void)transferFile:(NSString *)file {
    if (![StringHelper stringIsNilOrEmpty:file]) {
        [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil), file]];
    }
}

//分析进度
- (void)parseProgress:(float)progress {
}

//当前分析文件的名字或者路径
- (void)parseFile:(NSString *)file {
}

//全部传输成功
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
}

@end
