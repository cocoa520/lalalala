//
//  IMBAndroidTransferToiTunes.m
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBAndroidTransferToiTunes.h"
#import "IMBiTunes.h"
#import "IMBNotificationDefine.h"
#import "IMBTransferError.h"
@implementation IMBAndroidTransferToiTunes

- (id)initWithAndroid:(IMBAndroid *)android TransferDataDic:(NSDictionary *)dataDic TransferDelegate:(id<TransferDelegate>)transferDelegate {
    if (self = [super initWithTransferDataDic:dataDic TransferDelegate:transferDelegate]) {
        _mediaConverter = [IMBMediaConverter singleton];
        [_mediaConverter reInitWithiPod:nil];
        _addItemDic = [[NSMutableDictionary alloc] init];
        _addCount = 0;
        _curPro = 0;
        _android = [android retain];
    }
    return self;
}

- (void)dealloc {
    if (_addItemDic != nil) {
        [_addItemDic release];
        _addItemDic = nil;
    }
    [super dealloc];
}

- (void)startTransfer {
    [[IMBTransferError singleton].errorArrayM removeAllObjects];
    [_loghandle writeInfoLog:@"Android to iTunes DoProgress enter"];
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transferDelegate transferPrepareFileStart:CustomLocalizedString(@"ImportSync_id_20", nil)];
    }
    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
        [_transferDelegate transferFile:CustomLocalizedString(@"MSG_COM_Prepare", nil)];
    }
    if (_transferDic != nil && _transferDic.count > 0) {
        NSString *expFolderPath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"iTunes Cache"];
        if (![_fileManager fileExistsAtPath:expFolderPath]) {
            [_fileManager createDirectoryAtPath:expFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        _exportPath = [expFolderPath retain];
        IMBiTunes *itunesIns = [IMBiTunes singleton];
        BOOL isOpeniTunes = [itunesIns parserLibrary];
        if (isOpeniTunes) {
            //计算totalItemCount
            _totalSize = [self caculateTransferTotalSize:nil];
            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
                [_transferDelegate transferPrepareFileEnd];
            }
            [self copyContentToLocal];
            [self resetTrackCount];     //跟踪统计个数重置
            if (_addItemDic != nil && _addItemDic.count > 0) {
                _currItemIndex = 0;
                if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                    [_transferDelegate transferPrepareFileStart:CustomLocalizedString(@"MSG_Add_To_iTunes_id_1", nil)];
                }
                
                // 再导入媒体
                for (NSNumber *key in _addItemDic.allKeys) {
                    [_loghandle writeInfoLog:@"Begin move media to iTunes!"];
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
                        if (key.intValue == 3) {
                            [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Music" label:Stop transferCount:musicCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                        }else if (key.intValue == 4) {
                            [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Movies" label:Stop transferCount:movieCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                        }else if (key.intValue == 11) {
                            [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Ringtones" label:Stop transferCount:ringtoneCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                        }
                        if (dimensionDict) {
                            [dimensionDict release];
                            dimensionDict = nil;
                        }
                        NSArray *trackArray = [_addItemDic objectForKey:key];
                        for (id item in trackArray) {
                            if ([item isKindOfClass:[IMBiTunesImportAppInfo class]]) {
                                IMBiTunesImportAppInfo *track = (IMBiTunesImportAppInfo *)item;
                                [[IMBTransferError singleton] addAnErrorWithErrorName:track.appName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                            }else if ([item isKindOfClass:[IMBiTunesImportFileInfo class]]) {
                                IMBiTunesImportFileInfo *track = (IMBiTunesImportFileInfo *)item;
                                [[IMBTransferError singleton] addAnErrorWithErrorName:track.trackName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                            }
                        }
                        break;
                    }
                    if ([key intValue] == Category_iBooks) {
                        continue;
                    }
                    NSArray *trackArray = [_addItemDic objectForKey:key];
                    if (trackArray != nil && trackArray.count > 0) {
                        NSDictionary *dimensionDict = nil;
                        @autoreleasepool {
                            dimensionDict = [[TempHelper customDimension] copy];
                        }
                        if (key.intValue == 3) {
                            musicCount = [itunesIns importFilesToiTunes:trackArray containRatingAndPlayCount:YES withDelegate:self];
                            _successCount += musicCount;
                            [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Music" label:Finish transferCount:musicCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                        }else if (key.intValue == 4) {
                            movieCount = [itunesIns importFilesToiTunes:trackArray containRatingAndPlayCount:YES withDelegate:self];
                            _successCount += movieCount;
                            [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Movies" label:Finish transferCount:movieCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                        }else if (key.intValue == 11) {
                            ringtoneCount = [itunesIns importFilesToiTunes:trackArray containRatingAndPlayCount:YES withDelegate:self];
                            _successCount += ringtoneCount;
                            [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Ringtones" label:Finish transferCount:ringtoneCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                        }
                        if (dimensionDict) {
                            [dimensionDict release];
                            dimensionDict = nil;
                        }
                    }
                    [_loghandle writeInfoLog:@"End move media to iTunes!"];
                }
                // 再导入ibook
                if ([_addItemDic.allKeys containsObject:[NSNumber numberWithInt:Category_iBooks]]) {
                    [_loghandle writeInfoLog:@"Begin Create iBooks to iTunes!"];
                    NSArray *ibookArray = [_addItemDic objectForKey:[NSNumber numberWithInt:Category_iBooks]];
                    if (ibookArray != nil && ibookArray.count > 0) {
                         iBookCount = [itunesIns importFilesToiTunes:ibookArray containRatingAndPlayCount:YES withDelegate:self];
                        _successCount += iBookCount;
                        NSDictionary *dimensionDict = nil;
                        @autoreleasepool {
                            dimensionDict = [[TempHelper customDimension] copy];
                        }
                        [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Books" label:Finish transferCount:iBookCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                        if (dimensionDict) {
                            [dimensionDict release];
                            dimensionDict = nil;
                        }
                    }
                    [_loghandle writeInfoLog:@"End Create iBooks to iTunes!"];
                }
            }
            if ([_fileManager fileExistsAtPath:_exportPath]) {
                [_fileManager removeItemAtPath:_exportPath error:nil];
            }
        }
    }
    sleep(2);
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
        [self resetTrackCount];     //跟踪统计个数重置
    }
    [_loghandle writeInfoLog:@"Android to iTunes DoProgress End"];
}

- (void)copyContentToLocal {
    [_loghandle writeInfoLog:@"copy Content To Local enter"];
    IMBiTunes *itunes = [IMBiTunes singleton];
    for (NSNumber *type in _transferDic.allKeys) {
        NSString *stringKey = [IMBCommonEnum categoryNodesEnumToName:type.intValue];
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_transferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),stringKey]];
        }
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
            if (type.intValue == 3) {
                [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Music" label:Stop transferCount:musicCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (type.intValue == 4) {
                [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Movies" label:Stop transferCount:movieCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (type.intValue == 11) {
                [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Ringtones" label:Stop transferCount:ringtoneCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (type.intValue == 9) {
                [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Books" label:Stop transferCount:iBookCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else if (type.intValue == 65) {
                [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Photo Library" label:Stop transferCount:photoCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            NSArray *tracks = [_transferDic objectForKey:type];
            for (IMBADAudioTrack *track in tracks) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
            }
            break;
        }
        BOOL isConvet = NO;
        switch (type.intValue) {
            case Category_Music:
            case Category_Ringtone: {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                if (type.intValue == 3) {
                    [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Music" label:Start transferCount:musicCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                }else if (type.intValue == 11) {
                    [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Ringtones" label:Start transferCount:ringtoneCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                }
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                [_loghandle writeInfoLog:@"copy Music data begin (to iTunes)"];
                NSArray *tracks = [_transferDic objectForKey:type];
                NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
                NSMutableArray *existArray = [[NSMutableArray alloc] init];
                for (IMBADAudioTrack *track in tracks) {
                    IMBiTLTrack *itlTrack = nil;
                    for (IMBiTLTrack *aTrack in itunes.getiTLTracks) {
                        if ([aTrack.name isEqualToString:track.title] && [aTrack.artist isEqualToString:track.singer]) {
                            if (aTrack.size == track.size) {
                                NSString *filePath = [aTrack.location path];
                                track.title = [StringHelper createDifferentfileName:track.title];
                                if (filePath != nil) {
                                    itlTrack = aTrack;
                                }
                                break;
                            }
                        }
                    }
                    if (itlTrack == nil) {//该音乐在iTunes中不存在
                        [existArray addObject:track];
                    }else {
                        IMBiTunesImportFileInfo *impInfo = [[IMBiTunesImportFileInfo alloc] init];
                        [impInfo setSourceFilePath:[track url]];
                        //ToDo这个地方需要album,artist等信息
                        NSString *fileName = [TempHelper replaceSpecialChar:track.title];
                        [impInfo setDesFilePath:[[_exportPath stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:[[track url] pathExtension]]];
                        impInfo.trackName = fileName;
                        impInfo.oriName = track.title;
                        impInfo.trackID = track.trackId;
                        if (type.intValue == Category_Music) {
                            impInfo.mediaType = Audio;
                        }else {
                            impInfo.mediaType = Ringtone;
                        }
                        impInfo.playedCount = 0;
                        //                      impInfo.rating= track.ratingInt;
                        impInfo.album = track.album;
                        impInfo.artist = track.singer;
                        impInfo.isNeedCopy = NO;
                        impInfo.itunesFileUrl = itlTrack.location;
                        impInfo.trackStatues = iTunesTrackExsit;
                        impInfo.trackiTunesID = (int)itlTrack.databaseID;
                        [categoryArray addObject:impInfo];
                        [impInfo release];
                        impInfo = nil;
                        
                        _currItemIndex ++;
                        _failedCount ++;
                    }
                }
                //导出iTunes中不存在的音乐到本地缓存文件夹下
                if (type.intValue == Category_Music) {
                    NSString *exPath = [_exportPath stringByAppendingPathComponent:@"Music"];
                    [_android.adAudio setTransDelegate:self];
                    [_android exportAudioContent:exPath ContentList:existArray];
                }else {
                    NSString *exPath = [_exportPath stringByAppendingPathComponent:@"Ringtone"];
                    [_android.adRingtone setTransDelegate:self];
                    [_android exportRingtoneContent:exPath ContentList:existArray];
                }
                
                //检查文件是否需要转换,并转换
                isConvet = [self convertFile:existArray withType:type.intValue];
                
                //创建IMBiTunesImportFileInfo这个实体;
                for (IMBADAudioTrack *track in existArray) {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                        continue;
                    }
                    
                    if (isConvet) {
                        NSArray *_outputList = _mediaConverter.outputCvtMediaList;
                        for (IMBCvtEncodedMedia *mediaFile in _outputList) {
                            if ([track.localPath isEqualToString:mediaFile.sourceMediaPath]) {
                                [track setLocalPath:mediaFile.encodedMediaPath];
                                break;
                            }
                        }
                    }
                    
                    if ([_fileManager fileExistsAtPath:track.localPath]) {
                        _addCount ++;
                        //                        _successCount ++;
                        IMBiTunesImportFileInfo *impInfo = [[IMBiTunesImportFileInfo alloc] init];
                        [impInfo setSourceFilePath:[track url]];
                        //ToDo这个地方需要album,artist等信息
                        NSString *fileName = [TempHelper replaceSpecialChar:track.title];
                        [impInfo setDesFilePath:track.localPath];
                        impInfo.trackName = fileName;
                        impInfo.oriName = track.title;
                        impInfo.trackID = track.trackId;
                        if (type.intValue == Category_Music) {
                            impInfo.mediaType = Audio;
                        }else {
                            impInfo.mediaType = Ringtone;
                        }
                        impInfo.playedCount = 0;
                        //                      impInfo.rating= track.ratingInt;
                        impInfo.album = track.album;
                        impInfo.artist = track.singer;
                        impInfo.isNeedCopy = YES;
                        impInfo.trackiTunesID = 0;
                        impInfo.itunesFileUrl =  [NSURL fileURLWithPath:impInfo.desFilePath];
                        [categoryArray addObject:impInfo];
                        [impInfo release];
                        impInfo = nil;
                    }else {
                        _failedCount ++;
                    }
                }
                
                if (categoryArray.count > 0) {
                    [_addItemDic setObject:categoryArray forKey:type];
                }
                if (categoryArray != nil) {
                    [categoryArray release];
                    categoryArray = nil;
                }
                if (existArray != nil) {
                    [existArray release];
                    existArray = nil;
                }
                [_loghandle writeInfoLog:@"copy Music data end (to iTunes)"];
            }
                break;
            case Category_Movies: {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Movies" label:Start transferCount:movieCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                [_loghandle writeInfoLog:@"copy Video data begin (to iTunes)"];
                NSArray *videoTracks = [_transferDic objectForKey:type];
                NSMutableArray *categoryVideoArray = [[NSMutableArray alloc] init];
                NSMutableArray *existVidoeArray = [[NSMutableArray alloc] init];
                for (IMBADVideoTrack *track in videoTracks) {
                    IMBiTLTrack *itlTrack = nil;
                    for (IMBiTLTrack *aTrack in itunes.getiTLTracks) {
                        if ([aTrack.name isEqualToString:track.title] && [aTrack.artist isEqualToString:track.singer]) {
                            if (aTrack.size == track.size) {
                                NSString *filePath = [aTrack.location path];
                                track.title = [StringHelper createDifferentfileName:track.title];
                                if (filePath != nil) {
                                    itlTrack = aTrack;
                                }
                                break;
                            }
                        }
                    }
                    if (itlTrack == nil) {//该音乐在iTunes中不存在
                        [existVidoeArray addObject:track];
                    }else {
                        IMBiTunesImportFileInfo *impInfo = [[IMBiTunesImportFileInfo alloc] init];
                        [impInfo setSourceFilePath:[track url]];
                        //ToDo这个地方需要album,artist等信息
                        NSString *fileName = [TempHelper replaceSpecialChar:track.title];
                        [impInfo setDesFilePath:[[_exportPath stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:[[track url] pathExtension]]];
                        impInfo.trackName = fileName;
                        impInfo.oriName = track.title;
                        impInfo.trackID = track.trackId;
                        impInfo.mediaType = Video;
                        impInfo.playedCount = 0;
                        //                      impInfo.rating= track.ratingInt;
                        impInfo.album = track.album;
                        impInfo.artist = track.singer;
                        impInfo.isNeedCopy = NO;
                        impInfo.itunesFileUrl = itlTrack.location;
                        impInfo.trackStatues = iTunesTrackExsit;
                        impInfo.trackiTunesID = (int)itlTrack.databaseID;
                        [categoryVideoArray addObject:impInfo];
                        [impInfo release];
                        impInfo = nil;
                        
                        _currItemIndex ++;
                        _failedCount ++;
                    }
                }
                //导出iTunes中不存在的视频到本地缓存文件夹下
                NSString *exPath = [_exportPath stringByAppendingPathComponent:@"Video"];
                [_android.adVideo setTransDelegate:self];
                [_android exportVideoContent:exPath ContentList:existVidoeArray];
                
                //检查文件是否需要转换,并转换
                isConvet = [self convertFile:existVidoeArray withType:type.intValue];
                
                //创建IMBiTunesImportFileInfo这个实体;
                for (IMBADVideoTrack *track in existVidoeArray) {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                        continue;
                    }
                    
                    if (isConvet) {
                        NSArray *_outputList = _mediaConverter.outputCvtMediaList;
                        for (IMBCvtEncodedMedia *mediaFile in _outputList) {
                            if ([track.localPath isEqualToString:mediaFile.sourceMediaPath]) {
                                [track setLocalPath:mediaFile.encodedMediaPath];
                                break;
                            }
                        }
                    }
                    
                    if ([_fileManager fileExistsAtPath:track.localPath]) {
                        _addCount ++;
                        //                        _successCount ++;
                        IMBiTunesImportFileInfo *impInfo = [[IMBiTunesImportFileInfo alloc] init];
                        [impInfo setSourceFilePath:[track url]];
                        //ToDo这个地方需要album,artist等信息
                        NSString *fileName = [TempHelper replaceSpecialChar:track.title];
                        [impInfo setDesFilePath:track.localPath];
                        impInfo.trackName = fileName;
                        impInfo.oriName = track.title;
                        impInfo.trackID = track.trackId;
                        impInfo.mediaType = Audio;
                        impInfo.playedCount = 0;
                        //                      impInfo.rating= track.ratingInt;
                        impInfo.album = track.album;
                        impInfo.artist = track.singer;
                        impInfo.isNeedCopy = YES;
                        impInfo.trackiTunesID = 0;
                        impInfo.itunesFileUrl =  [NSURL fileURLWithPath:impInfo.desFilePath];
                        [categoryVideoArray addObject:impInfo];
                        [impInfo release];
                        impInfo = nil;
                    }else {
                        _failedCount ++;
                    }
                }
                
                if (categoryVideoArray.count > 0) {
                    [_addItemDic setObject:categoryVideoArray forKey:type];
                }
                if (categoryVideoArray != nil) {
                    [categoryVideoArray release];
                    categoryVideoArray = nil;
                }
                if (existVidoeArray != nil) {
                    [existVidoeArray release];
                    existVidoeArray = nil;
                }
                [_loghandle writeInfoLog:@"copy Video data end (to iTunes)"];
            }
                break;
            case Category_iBooks: {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Books" label:Start transferCount:iBookCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                [_loghandle writeInfoLog:@"copy iBooks data Begin (to iTunes)"];
                NSMutableArray *booksArray = [_transferDic objectForKey:type];
                if (booksArray != nil && booksArray.count > 0) {
                    IMBiTLPlaylist *ibookPlaylist = [itunes getBookCategoryiTLPlaylist];
                    NSMutableArray *categoryBookArray = [[NSMutableArray alloc] init];
                    NSMutableArray *existBookArray = [[NSMutableArray alloc] init];
                    
                    for (IMBADFileEntity *book in booksArray) {
                        //判断iTunes是否存在
                        BOOL isExsit = NO;
                        if (ibookPlaylist != nil) {
                            NSArray *itunesBooks = [ibookPlaylist playlistItems];
                            if (itunesBooks != nil && itunesBooks.count > 0) {
                                for (IMBiTLTrack *track in itunesBooks) {
                                    if ([book.fileName isEqualToString:track.name]) {
                                        isExsit = YES;
                                        break;
                                    }
                                }
                            }
                        }
                        if (isExsit) {
                            IMBiBookImportItemInfo *impInfo = [[IMBiBookImportItemInfo alloc] init];
                            impInfo.isNeedCopy = NO;
                            impInfo.trackStatues = iTunesTrackExsit;
                            [categoryBookArray addObject:impInfo];
                            [impInfo release];
                            impInfo = nil;
                            _currItemIndex ++;
                            _failedCount ++;
                        }else {
                            [existBookArray addObject:book];
                        }
                    }
                    
                    //导出iTunes中不存在的视频到本地缓存文件夹下
                    NSString *exPath = [_exportPath stringByAppendingPathComponent:@"Book"];
                    [_android.adDoucment setTransDelegate:self];
                    [_android exportDoucmentContent:exPath ContentList:existBookArray];
                    
                    //创建IMBiTunesImportFileInfo这个实体;
                    for (IMBADFileEntity *book in existBookArray) {
                        [_condition lock];
                        if (_isPause) {
                            [_condition wait];
                        }
                        [_condition unlock];
                        if (_isStop) {
                            [[IMBTransferError singleton] addAnErrorWithErrorName:book.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                            continue;
                        }
                        
                        if ([_fileManager fileExistsAtPath:book.localPath]) {
                            _addCount ++;
                            //                            _successCount ++;
                            IMBiBookImportItemInfo *impInfo = [[IMBiBookImportItemInfo alloc] init];
                            impInfo.bookName = book.fileName;
                            impInfo.extension = book.fileExtension;
                            if ([[book.fileExtension lowercaseString] rangeOfString:@"epub"].location != NSNotFound) {
                                impInfo.mediaType = Books;
                            } else {
                                impInfo.mediaType = PDFBooks;
                            }
                            impInfo.isNeedCopy = YES;
                            impInfo.sourceFilePath = book.filePath;
                            impInfo.desFilePath = book.localPath;
                            [categoryBookArray addObject:impInfo];
                            [impInfo release];
                            impInfo = nil;
                        }else {
                            _failedCount ++;
                        }
                    }
                    if (categoryBookArray.count > 0) {
                        [_addItemDic setObject:categoryBookArray forKey:type];
                    }
                    if (categoryBookArray != nil) {
                        [categoryBookArray release];
                        categoryBookArray = nil;
                    }
                    if (existBookArray != nil) {
                        [existBookArray release];
                        existBookArray = nil;
                    }
                }
                [_loghandle writeInfoLog:@"copy iBooks data end (to iTunes)"];
            }
                break;
            case Category_Photo: {
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Photo Library" label:Start transferCount:photoCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                photoCount = 0;
                [_loghandle writeInfoLog:@"copy Photo data begin (to iTunes)"];
                NSArray *photoArray = [_transferDic objectForKey:type];
                _isPhoto = YES;
                if (photoArray != nil && photoArray.count > 0) {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES);
                    NSString *desFilePath = [paths objectAtIndex:0];
                    desFilePath = [desFilePath stringByAppendingPathComponent:CustomLocalizedString(@"MenuItem_id_77", nil)];
                    if (![_fileManager fileExistsAtPath:desFilePath]) {
                        [_fileManager createDirectoryAtPath:desFilePath withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    [_android.adGallery setTransDelegate:self];
                    [_android exportGalleryContent:desFilePath ContentList:photoArray];
                }
                [ATTracker event:Move_To_iOS action:ToiTunes actionParams:@"Photo Library" label:Finish transferCount:photoCount screenView:@"MoveToiOS Transfer View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                photoCount = 0;
                _isPhoto = NO;
                [_loghandle writeInfoLog:@"copy Photo data end (to iTunes)"];
                break;
            }
            default:
                break;
        }
    }
    [_loghandle writeInfoLog:@"copy Content To Local End"];
}

- (BOOL)convertFile:(NSMutableArray *)existArray withType:(CategoryNodesEnum)type {
    //检查文件是否需要转换
    [_mediaConverter reInit];
    BOOL isConvet = NO;
    NSArray *supportExt = [[MediaHelper getSupportFileTypeArray:type supportVideo:YES supportConvert:NO withiPod:_ipod] componentsSeparatedByString:@";"];
    for (id track in existArray) {
        NSString *path = nil;
        if (type == Category_Movies) {
            path = [(IMBADVideoTrack *)track localPath];
        }else {
            path = [(IMBADAudioTrack *)track localPath];
        }
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            break;
        }
        BOOL isCvtVideo = YES;
        BOOL isCvtAudio = YES;
        BOOL isSupportExt = [self checkFileSupport:supportExt filePath:path];
        BOOL isNeedToConvert = [_mediaConverter checkDeviceConvertWithiPod:nil Path:path IsCvtVideo:isCvtVideo IsCvtAudio:isCvtAudio SupportVideo:YES SupportAudio:YES SupportExt:isSupportExt withType:type];
        if (isNeedToConvert) {
            isConvet = YES;
        }
    }
    //开始转换文件
    if (isConvet) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conversionProgress:) name:NOTIFY_CVT_PROGRESS_TRANSFER object:nil];
        if (type == Category_Ringtone) {
            [_mediaConverter convertMedia:nil isRt:YES];
        }else{
            [_mediaConverter convertMedia:nil isRt:NO];
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CVT_PROGRESS_TRANSFER object:nil];
    }
    return isConvet;
}

- (void)conversionProgress:(NSNotification *)notification {
    NSString *msgStr = [notification object];
    if (![TempHelper stringIsNilOrEmpty:msgStr]) {
        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
            [_transferDelegate transferFile:msgStr];
        }
    }
}

//检查文件格式是否支持
- (BOOL)checkFileSupport:(NSArray*)supportExt filePath:(NSString*)filePath {
    BOOL isSupport = FALSE;
    NSString *ext = [[filePath pathExtension] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[(NSString*)evaluatedObject stringByReplacingOccurrencesOfString:@"*." withString:@""] isEqualToString:[ext lowercaseString]];
    }];
    NSArray *preArray = [supportExt filteredArrayUsingPredicate:pre];
    if (preArray != nil && [preArray count] > 0) {
        isSupport = YES;
    } else {
        isSupport = NO;
    }
    return isSupport;
}
                                         
- (int64_t)caculateTransferTotalSize:(NSArray *)array {
    int64_t size = 0;
    if (_transferDic != nil) {
        for (NSNumber *type in _transferDic.allKeys) {
            switch (type.intValue) {
                case Category_Music:
                case Category_Movies:
                case Category_Ringtone: {
                    NSArray *tracks = [_transferDic objectForKey:type];
                    if (type.intValue == 3) {
                        musicCount = (int)tracks.count;
                    }else if (type.intValue == 4) {
                        movieCount = (int)tracks.count;
                    }else  {
                        ringtoneCount = (int)tracks.count;
                    }
                    _totalItemCount += tracks.count;
                    break;
                }
                case Category_iBooks: {
                    NSMutableArray *booksArray = [_transferDic objectForKey:type];
                    iBookCount = (int)booksArray.count;
                    _totalItemCount += booksArray.count;
                    break;
                }
                case Category_Photo: {
                    NSArray *appArray = [_transferDic objectForKey:type];
                    for (IMBADAlbumEntity *entity in appArray) {
                        photoCount += (int)entity.photoArray.count;
                        _totalItemCount += entity.photoArray.count;
                    }
                    break;
                }
                default:
                    break;
            }
        }
    }
    return size;
}

- (void)sendItemProgressToView:(NSString *)name {
    _currItemIndex ++;
    if (![TempHelper stringIsNilOrEmpty:name]) {
        NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_Add_To_iTunes", nil),name];
        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
            [_transferDelegate transferFile:msgStr];
        }
    }
    
    if (_addCount == 0) {
        return;
    }
    NSLog(@"_cur:%d   total:%d",_currItemIndex,_addCount);
    if (_currItemIndex > _addCount) {
        _currItemIndex = _addCount;
    }
    float progress = 80 + ((float)_currItemIndex / _addCount) * 20;
    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
        [_transferDelegate transferProgress:progress];
    }
}

- (void)resetTrackCount {
    musicCount = 0;
    movieCount = 0;
    ringtoneCount = 0;
    iBookCount = 0;
}

#pragma mark - TransferDelegate
- (void)transferPrepareFileStart:(NSString *)file {
    
}

- (void)transferPrepareFileEnd {
    
}

- (void)transferProgress:(float)progress {
    float pro = _curPro;
    if (_transferDic.allKeys.count == 1 && [_transferDic.allKeys containsObject:[NSNumber numberWithInt:Category_Photo]]) {
        pro += progress;
        NSLog(@"to itunes progress:%f",pro);
        if (pro > 100) {
            pro = 100;
        }
    }else {
        pro += (progress * 0.8 / _transferDic.allKeys.count);
        NSLog(@"to itunes progress:%f",pro);
        if (pro > 80) {
            pro = 80;
        }
    }
    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
        [_transferDelegate transferProgress:pro];
    }
}

- (void)transferFile:(NSString *)file {
    if (![StringHelper stringIsNilOrEmpty:file]) {
        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
            NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),file];
            [_transferDelegate transferFile:msgStr];
        }
    }
}

- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
    _curPro += 80.0/_transferDic.allKeys.count;
    if (_isPhoto) {
        photoCount += successCount;
        _successCount += successCount;
        _isPhoto = NO;
    }
}

- (void)parseProgress:(float)progress {
    
}

- (void)parseFile:(NSString *)file {
    
}

- (void)setIsPause:(BOOL)isPause {
    [_android setIsPause:isPause];
    if (!isPause) {
        [self resumeScan];
    }else{
        [self pauseScan];
    }
}

- (void)setIsStop:(BOOL)isStop {
    [_android setIsStop:isStop];
    [self stopScan];
}

@end
