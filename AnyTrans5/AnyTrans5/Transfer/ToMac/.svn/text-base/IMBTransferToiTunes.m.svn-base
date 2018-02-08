//
//  IMBTransferToiTunes.m
//  AnyTrans
//
//  Created by iMobie on 8/12/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBTransferToiTunes.h"
#import "IMBCommonEnum.h"
#import "IMBiTunes.h"
#import "IMBPlaylist.h"
#import "StringHelper.h"
#import "IMBFileSystem.h"
#import "IMBBookEntity.h"
#import "IMBZipHelper.h"
#import "IMBInformationManager.h"
#import "IMBInformation.h"

@implementation IMBTransferToiTunes

- (id)initWithIPodkey:(NSString *)ipodKey exportDic:(NSDictionary *)exportDic withDelegate:(id)delegate {
    self = [super initWithIPodkey:ipodKey withDelegate:delegate];
    if (self) {
        _exportDic = [exportDic retain];
        _addCount = 0;
        _infoMation = [[IMBInformationManager shareInstance].informationDic objectForKey:ipodKey];
    }
    return self;
}

- (void)dealloc {
    if (_exportDic != nil) {
        [_exportDic release];
        _exportDic = nil;
    }
    if (_addItemDic != nil) {
        [_addItemDic release];
        _addItemDic = nil;
    }
    [super dealloc];
}

- (void)startTransfer {
    [_loghandle writeInfoLog:@"toiTunes DoProgress enter"];
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transferDelegate transferPrepareFileStart:CustomLocalizedString(@"ImportSync_id_20", nil)];
    }
    NSString *expFolderPath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"iTunes Cache"];
    if (![_fileManager fileExistsAtPath:expFolderPath]) {
        [_fileManager createDirectoryAtPath:expFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    _exportPath = [expFolderPath retain];
    IMBiTunes *itunesIns = [IMBiTunes singleton];
    [itunesIns parserLibrary];
    if (_exportDic != nil && _exportDic.count > 0) {
        //计算totalItemCount
        _totalSize = [self caculateTransferTotalSize:nil];
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
        [self copyContentToLocal];
        if (_addItemDic != nil && _addItemDic.count > 0) {
            _currItemIndex = 0;
            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                [_transferDelegate transferPrepareFileStart:CustomLocalizedString(@"MSG_Add_To_iTunes_id_1", nil)];
            }
            // 优先导入Playlist
            if ([_addItemDic.allKeys containsObject:[NSNumber numberWithInt:Category_Playlist]]) {
                [_loghandle writeInfoLog:@"Begin Create playlist to iTunes!"];
                NSArray *plArray = [_addItemDic objectForKey:[NSNumber numberWithInt:Category_Playlist]];
                if (plArray != nil && plArray.count > 0) {
                    for (IMBiTunesPlaylistInfo* plInfo in plArray) {
                        [_condition lock];
                        if (_isPause) {
                            [_condition wait];
                        }
                        [_condition unlock];
                        if (_isStop) {
                            break;
                        }
                        if (!plInfo.isExist) {
                            _currItemIndex ++;
                            if (![TempHelper stringIsNilOrEmpty:plInfo.playlistName]) {
                                NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_Add_To_iTunes", nil),plInfo.playlistName];
                                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                    [_transferDelegate transferFile:msgStr];
                                }
                            }
                            
                            if (_currItemIndex > _addCount) {
                                _currItemIndex = _addCount;
                            }
                            float progress = 50 + ((float)_currItemIndex / _addCount) * 50;
                            if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                                [_transferDelegate transferProgress:progress];
                            }
                            
                            plInfo.iTunesPlaylistID = [itunesIns createPlaylistByName:plInfo.playlistName];
                            if (plInfo.iTunesPlaylistID > 0) {
                                [plInfo setPlaylistStatues:iTunesPlaylistAddSuccess];
                            } else {
                                [plInfo setPlaylistStatues:iTunesPlaylistAddFailed];
                            }
//                            [self saveResult:plInfo];
                        }
                    }
                }
                [_loghandle writeInfoLog:@"End Create playlist to iTunes!"];
            }
            
            // 再导入媒体
            for (NSNumber *key in _addItemDic.allKeys) {
                [_loghandle writeInfoLog:@"Begin move media to iTunes!"];
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
//                if (_isStop) {
//                    break;
//                }
                if ([key intValue] == Category_Playlist || [key intValue] == Category_iBooks || [key intValue] == Category_iBooks || [key intValue] == Category_Applications) {
                    continue;
                }
                NSArray *trackArray = [_addItemDic objectForKey:key];
                if (trackArray != nil && trackArray.count > 0) {
                    [itunesIns importFilesToiTunes:trackArray containRatingAndPlayCount:YES withDelegate:self];
                }
                [_loghandle writeInfoLog:@"End move media to iTunes!"];
            }
            // 再导入ibook
            if ([_addItemDic.allKeys containsObject:[NSNumber numberWithInt:Category_iBooks]]) {
                [_loghandle writeInfoLog:@"Begin Create iBooks to iTunes!"];
                NSArray *ibookArray = [_addItemDic objectForKey:[NSNumber numberWithInt:Category_iBooks]];
                if (ibookArray != nil && ibookArray.count > 0) {
                    [itunesIns importFilesToiTunes:ibookArray containRatingAndPlayCount:YES withDelegate:self];
                }
                [_loghandle writeInfoLog:@"End Create iBooks to iTunes!"];
            }
            
            // 最有导入Application
            if ([_addItemDic.allKeys containsObject:[NSNumber numberWithInt:Category_Applications]]) {
                [_loghandle writeInfoLog:@"Begin Create app to iTunes!"];
                NSArray *appArray = [_addItemDic objectForKey:[NSNumber numberWithInt:Category_Applications]];
                if (appArray != nil && appArray.count > 0) {
                    [itunesIns importFilesToiTunes:appArray containRatingAndPlayCount:YES withDelegate:self];
                }
                [_loghandle writeInfoLog:@"End Creaste app to iTunes!"];
            }
        }
        if ([_fileManager fileExistsAtPath:_exportPath]) {
            [_fileManager removeItemAtPath:_exportPath error:nil];
        }
    }
    sleep(2);
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
    [_loghandle writeInfoLog:@"toiTunes DoProgress End"];
}

- (void)copyContentToLocal {
    [_loghandle writeInfoLog:@"copy Content To Local enter"];
    _addItemDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *importFileInfoArray = [[NSMutableArray alloc] init];
    for (NSNumber *type in _exportDic.allKeys) {
        NSString *stringKey = [IMBCommonEnum categoryNodesEnumToName:type.intValue];
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_transferDelegate transferPrepareFileStart:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),stringKey]];
        }
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
//        if (_isStop) {
//            break;
//        }
        switch (type.intValue) {
            case Category_Playlist: {
                [_loghandle writeInfoLog:@"copy playlisy data begin (to iTunes)"];
                NSArray *pls = nil;
                NSArray *tracks = nil;
                if (_isAllExport) {
                    pls = _infoMation.playlists.playlistArray;
                }else {
                    NSDictionary *playListDic = [_exportDic objectForKey:type];
                    pls = [playListDic objectForKey:@"PlaylistArray"];
                    tracks = [playListDic objectForKey:@"TracksArray"];
                }
                NSMutableArray *expPlaylistArray = [[NSMutableArray alloc] init];
                IMBiTunesPlaylistInfo *playlistInfo = nil;
                IMBiTunes *itunes = [IMBiTunes singleton];
                if (pls != nil && [pls count] > 0) {
                    for (IMBPlaylist *plItem in pls) {
                        [_condition lock];
                        if (_isPause) {
                            [_condition wait];
                        }
                        [_condition unlock];
                        if (_isStop) {
                            for (IMBTrack *track in plItem.tracks) {
                                [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                            }
                            break;
                        }
                        if (!plItem.isMaster) {
                            playlistInfo = [[IMBiTunesPlaylistInfo alloc] init];
                            [playlistInfo setPlaylistName:[plItem name]];
                            IMBiTLPlaylist *itlPl = [itunes getUserPlaylistByName:plItem.name];
                            if (itlPl != nil) {
                                //playlist已经在itunes里面存在。
                                playlistInfo.iTunesPlaylistID = itlPl.playlistID;
                                playlistInfo.playlistStatues = iTunesPlaylistExsit;
                                playlistInfo.isExist = YES;
                            } else {
                                // 这些Playlist都是需要导入的Playlist。
                                [playlistInfo setPlaylistID:[plItem iD]];
                                if (plItem.isUserDefinedPlaylist) {
                                    playlistInfo.isExist = NO;
                                    [expPlaylistArray addObject:playlistInfo];
                                    _addCount ++;
                                }
                            }
                        }
                        //再遍历Playlist的Track，需要判断重及其分类到Playlist中去。
                        if (plItem.trackCount > 0) {
                            for (IMBTrack *track in plItem.tracks) {
                                [_condition lock];
                                if (_isPause) {
                                    [_condition wait];
                                }
                                [_condition unlock];
                                if (_isStop) {
                                    [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                                    continue;
                                }
                                if (track.mediaType == Books || track.mediaType == PDFBooks) {
                                    [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                                    continue;
                                }
                                if (tracks != nil && ![tracks containsObject:track]) {
                                    [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"Ex_Op_file_exist", nil)];
                                    continue;
                                }
                                _currItemIndex += 1;
                                if (![TempHelper stringIsNilOrEmpty:track.title]) {
                                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),track.title];
                                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                        [_transferDelegate transferFile:msgStr];
                                    }
                                }
                                
                                if (_currItemIndex > _totalItemCount) {
                                    _currItemIndex = _totalItemCount;
                                }
                                float progress = ((float)_currItemIndex / _totalItemCount) * 50;
                                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                                    [_transferDelegate transferProgress:progress];
                                }
                                
                                IMBiTunesImportFileInfo *impInfo = nil;
                                for (IMBiTunesImportFileInfo *item in importFileInfoArray) {
                                    if (item.trackID == track.iD && [item.oriName isEqualToString:track.title]) {
                                        impInfo = item;
                                        break;
                                    }
                                }
                                
                                if (impInfo == nil) {
                                    impInfo = [self createImportFileInfo:track];
                                    if (impInfo != nil) {
                                        [importFileInfoArray addObject:impInfo];
                                    }
//                                    BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                                    if (isOutOfCount) {
//                                        break;
//                                    }
                                }else {
                                    _successCount ++;
                                }
                                if (!plItem.isMaster) {
                                    [impInfo.playlistArray addObject:playlistInfo];
                                }
                            }
                        }
                        if (playlistInfo != nil) {
                            [playlistInfo release];
                            playlistInfo = nil;
                        }
                        
                    }
                }
                if (expPlaylistArray != nil && expPlaylistArray.count > 0) {
                    [_addItemDic setObject:expPlaylistArray forKey:[NSNumber numberWithInt:Category_Playlist]];
                }
                [expPlaylistArray release];
                [_loghandle writeInfoLog:@"copy playlisy data end (to iTunes)"];
                break;
            }
            case Category_Music:
            case Category_Movies:
            case Category_TVShow:
            case Category_MusicVideo:
            case Category_HomeVideo:
            case Category_VoiceMemos:
            case Category_PodCasts:
            case Category_iTunesU:
            case Category_Audiobook:
            case Category_Ringtone: {
                [_loghandle writeInfoLog:@"copy media data begin (to iTunes)"];
                NSArray *tracks = nil;
                if (_isAllExport) {
                    tracks = [_infoMation getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:type.intValue]];
                }else {
                    tracks = [_exportDic objectForKey:type];
                }
                for (IMBTrack *track in tracks) {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                        continue;
                    }
                    if (track.mediaType == Books || track.mediaType == PDFBooks) {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                        continue;
                    }
                    _currItemIndex += 1;
                    if (![TempHelper stringIsNilOrEmpty:track.title]) {
                        NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),track.title];
                        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                            [_transferDelegate transferFile:msgStr];
                        }
                    }
                    
                    if (_currItemIndex > _totalItemCount) {
                        _currItemIndex = _totalItemCount;
                    }
                    float progress = ((float)_currItemIndex / _totalItemCount) * 50;
                    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_transferDelegate transferProgress:progress];
                    }
                    // 检查Track是否已经被分析过了
                    IMBiTunesImportFileInfo *impInfo = nil;
                    for (IMBiTunesImportFileInfo *item in importFileInfoArray) {
                        if (item.trackID == track.iD && [item.oriName isEqualToString:track.title]) {
                            impInfo = item;
                            break;
                        }
                    }
                    if (impInfo == nil) {
                        impInfo = [self createImportFileInfo:track];
                        if (impInfo != nil) {
                            [importFileInfoArray addObject:impInfo];
                        }
                    }
                }
                [_loghandle writeInfoLog:@"copy media data end (to iTunes)"];
                break;
            }
            case Category_iBooks:
            case Category_iBookCollections: {
                [_loghandle writeInfoLog:@"copy iBooks data Begin (to iTunes)"];
                NSMutableArray *booksArray = nil;
                if (_isAllExport) {
                    booksArray = [_infoMation allBooksArray];
                }else {
                    booksArray = [_exportDic objectForKey:type];
                }
                if (booksArray != nil && booksArray.count > 0) {
                    IMBiTunes *itunes = [IMBiTunes singleton];
                    IMBiTLPlaylist *ibookPlaylist = [itunes getBookCategoryiTLPlaylist];
                    
                    NSMutableArray *categoryArray = nil;
                    CategoryNodesEnum categoryNodes= Category_iBooks;
                    if ([_addItemDic.allKeys containsObject:[NSNumber numberWithInt:categoryNodes]]) {
                        categoryArray = [[_addItemDic objectForKey:[NSNumber numberWithInt:categoryNodes]] retain];
                    } else {
                        categoryArray = [[NSMutableArray alloc] init];
                        [_addItemDic setObject:categoryArray forKey:[NSNumber numberWithInt:categoryNodes]];
                    }
                    
                    for (IMBBookEntity *book in booksArray) {
                        [_condition lock];
                        if (_isPause) {
                            [_condition wait];
                        }
                        [_condition unlock];
                        if (_isStop) {
                            [[IMBTransferError singleton] addAnErrorWithErrorName:book.bookName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                            continue;
                        }
                        _currItemIndex += 1;
                        if (![TempHelper stringIsNilOrEmpty:book.bookName]) {
                            NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),book.bookName];
                            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                [_transferDelegate transferFile:msgStr];
                            }
                        }
                        
                        if (_currItemIndex > _totalItemCount) {
                            _currItemIndex = _totalItemCount;
                        }
                        float progress = ((float)_currItemIndex / _totalItemCount) * 50;
                        if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                            [_transferDelegate transferProgress:progress];
                        }
                        IMBiBookImportItemInfo *impInfo = nil;
                        BOOL isExsit = NO;
                        if (ibookPlaylist != nil) {
                            NSArray *itunesBooks = [ibookPlaylist playlistItems];
                            if (itunesBooks != nil && itunesBooks.count > 0) {
                                for (IMBiTLTrack *track in itunesBooks) {
                                    if ([book.bookName isEqualToString:track.name]) {
                                        isExsit = YES;
                                        [[IMBTransferError singleton] addAnErrorWithErrorName:book.bookName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_exist", nil)];
                                        break;
                                    }
                                }
                            }
                        }
                        
                        if (!isExsit) {
                            impInfo = [[IMBiBookImportItemInfo alloc] init];
                            impInfo.bookID = book.bookID;
                            impInfo.bookName = book.bookName;
                            impInfo.extension = book.extension;
                            if ([[book.extension lowercaseString] rangeOfString:@"epub"].location != NSNotFound) {
                                impInfo.mediaType = Books;
                            } else {
                                impInfo.mediaType = PDFBooks;
                            }
                            impInfo.isNeedCopy = YES;
                            impInfo.sourceFilePath = book.fullPath;
                            impInfo.desFilePath = [NSString stringWithFormat:@"%@/%@.%@", _exportPath, book.bookName, book.extension];
                            
                            //copy ibook to local
                            [self copyiBooksToLoacl:book withDesPath:impInfo.desFilePath];
                            
                            [categoryArray addObject:impInfo];
                            [impInfo release];
                            impInfo = nil;
                            
//                            BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                            if (isOutOfCount) {
//                                break;
//                            }
                        } else {
                            impInfo.isNeedCopy = NO;
                            impInfo.trackStatues = iTunesTrackExsit;
                        }
                    }
                    if (categoryArray != nil) {
                        [categoryArray release];
                        categoryArray = nil;
                    }
                }
                [_loghandle writeInfoLog:@"copy iBooks data end (to iTunes)"];
                break;
            }
            case Category_Applications: {
                [_loghandle writeInfoLog:@"copy app data begin (to iTunes)"];
                IMBiTunes *itunes = [IMBiTunes singleton];
                NSArray *appArray = nil;
                if (_isAllExport) {
                    appArray = [[_infoMation applicationManager] appEntityArray];
                }else {
                    appArray = [_exportDic objectForKey:type];
                }
                
                if (appArray != nil && appArray.count > 0) {
                    IMBiTLPlaylist *appPlaylist = [itunes getAppCategoryiTLPlaylist];
                    NSMutableArray *categoryArray = nil;
                    CategoryNodesEnum categoryNodes= [IMBCommonEnum categoryNodesByMediaType:Application];
                    if ([_addItemDic.allKeys containsObject:[NSNumber numberWithInt:categoryNodes]]) {
                        categoryArray = [[_addItemDic objectForKey:[NSNumber numberWithInt:categoryNodes]] retain];
                    } else {
                        categoryArray = [[NSMutableArray alloc] init];
                        [_addItemDic setObject:categoryArray forKey:[NSNumber numberWithInt:categoryNodes]];
                    }
                    for (IMBAppEntity *app in appArray) {
                        [_condition lock];
                        if (_isPause) {
                            [_condition wait];
                        }
                        [_condition unlock];
                        if (_isStop) {
                            [[IMBTransferError singleton] addAnErrorWithErrorName:app.appName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                            continue;
                        }
                        _currItemIndex += 1;
                        if (![TempHelper stringIsNilOrEmpty:app.appName]) {
                            NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),app.appName];
                            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                [_transferDelegate transferFile:msgStr];
                            }
                        }
                        
                        if (_currItemIndex > _totalItemCount) {
                            _currItemIndex = _totalItemCount;
                        }
                        float progress = ((float)_currItemIndex / _totalItemCount) * 50;
                        if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                            [_transferDelegate transferProgress:progress];
                        }
                        IMBiTunesImportAppInfo *impInfo = nil;
                        BOOL isExsit = NO;
                        if (appPlaylist != nil) {
                            NSArray *itunesApps = [appPlaylist playlistItems];
                            if (itunesApps != nil && itunesApps.count > 0) {
                                for (IMBiTLTrack *track in itunesApps) {
                                    if ([app.appKey isEqualToString:track.persistentID]) {
                                        isExsit = YES;
                                        [[IMBTransferError singleton] addAnErrorWithErrorName:app.appName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_exist", nil)];
                                        break;
                                    }
                                }
                            }
                        }
                        
                        if (!isExsit) {
                            impInfo = [[IMBiTunesImportAppInfo alloc] init];
                            impInfo.appKey = app.appKey;
                            impInfo.appName = app.appName;
                            impInfo.isNeedCopy = YES;
                            impInfo.desFilePath = [NSString stringWithFormat:@"%@/%@(v%@).ipa", _exportPath, app.appName, app.version];
                            impInfo.appEntity = app;
                            
                            //copy app to local
                            [self copyAppToLocal:app withDesPath:impInfo.desFilePath];
                            
                            [categoryArray addObject:impInfo];
                            [impInfo release];
                            impInfo = nil;

//                            BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                            if (isOutOfCount) {
//                                break;
//                            }
                        } else {
                            impInfo.isNeedCopy = NO;
                            impInfo.trackStatues = iTunesTrackExsit;
                        }
                    }
                    if (categoryArray != nil) {
                        [categoryArray release];
                        categoryArray = nil;
                    }
                }
                [_loghandle writeInfoLog:@"copy app data end (to iTunes)"];
                break;
            }
            default:
                break;
        }
    }
    [_loghandle writeInfoLog:@"copy Content To Local End"];
}

- (IMBiTunesImportFileInfo*)createImportFileInfo:(IMBTrack*)track {
    IMBiTunes *itunes = [IMBiTunes singleton];
    NSMutableArray *categoryArray = nil;
    CategoryNodesEnum categoryNodes= [IMBCommonEnum categoryNodesByMediaType:track.mediaType];
    if ([_addItemDic.allKeys containsObject:[NSNumber numberWithInt:categoryNodes]]) {
        categoryArray = [[_addItemDic objectForKey:[NSNumber numberWithInt:categoryNodes]] retain];
    } else {
        categoryArray = [[NSMutableArray alloc] init];
        [_addItemDic setObject:categoryArray forKey:[NSNumber numberWithInt:categoryNodes]];
    }
    
    IMBiTunesImportFileInfo *impInfo = [[[IMBiTunesImportFileInfo alloc] init] autorelease];
    IMBiTLTrack *itlTrack = [self checkTrackExsit:track itunesTracks:itunes.getiTLTracks];
    
    [impInfo setSourceFilePath:[track filePath]];
    //ToDo这个地方需要album,artist等信息
    NSString *fileName = [TempHelper replaceSpecialChar:track.title];
    [impInfo setDesFilePath:[[_exportPath stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:[[track filePath] pathExtension]]];
    impInfo.trackName = fileName;
    impInfo.oriName = track.title;
    impInfo.trackID = track.iD;
    impInfo.mediaType = track.mediaType;
    impInfo.playedCount = track.playCount;
    impInfo.rating= track.ratingInt;
    impInfo.album = track.album;
    impInfo.artist = track.artist;
    if (itlTrack != nil) {
        [[IMBTransferError singleton] addAnErrorWithErrorName:fileName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_exist", nil)];
        [_loghandle writeInfoLog:[NSString stringWithFormat:@"itunes %@ is always exist", fileName]];
        _failedCount ++;
        impInfo.isNeedCopy = NO;
        impInfo.itunesFileUrl = itlTrack.location;
        impInfo.trackStatues = iTunesTrackExsit;
        impInfo.trackiTunesID = (int)itlTrack.databaseID;
    }else {
        NSString *remotingFilePath = nil;
        if (_limitation.remainderCount > 0) {
            remotingFilePath = [[[_ipod fileSystem] driveLetter] stringByAppendingPathComponent:[track filePath]];
        }else {
           [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
        }
        if ([[_ipod fileSystem] fileExistsAtPath:remotingFilePath]) {
            _addCount ++;
            _successCount ++;
            //累加需要传输的文件总大小
            impInfo.isNeedCopy = YES;
            impInfo.trackiTunesID = 0;
//            _transTotalSize += [[_ipod fileSystem] getFileLength:remotingFilePath];
            
            //获取文件路径别名
            NSString *checkedFilePath = [TempHelper getFilePathAlias:impInfo.desFilePath];
            //复制文件到本地.
            [[_ipod fileSystem] copyRemoteFile:remotingFilePath toLocalFile:checkedFilePath];
            
            impInfo.desFilePath = checkedFilePath;
            impInfo.itunesFileUrl =  [NSURL fileURLWithPath:impInfo.desFilePath];
            [_limitation reduceRedmainderCount];
        } else {
            [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"Ex_Op_file_no_exist", nil)];
            _failedCount ++;
            impInfo.isNeedCopy = NO;
            impInfo.trackiTunesID = 0;
            [_loghandle writeInfoLog:[NSString stringWithFormat:@"DeviceFileNotExsit : %@ ", remotingFilePath]];
            impInfo.trackStatues = DeviceFileNotExsit;
        }
    }
    
    [_loghandle writeInfoLog:[NSString stringWithFormat:@"_importFileInfo curIndex: %d, name: %@, trackStatues: %d, filepath: %@", _currItemIndex, fileName, impInfo.trackStatues, impInfo.sourceFilePath]];
    if (impInfo != nil) {
        if (_limitation.remainderCount > 0) {
            [categoryArray addObject:impInfo];
        }else{
            return nil;
        }
    }
    if (categoryArray != nil) {
        [categoryArray release];
        categoryArray = nil;
    }
    return impInfo;
}

- (IMBiTLTrack*)checkTrackExsit:(IMBTrack*)track itunesTracks:(NSArray*)itlTracks {
    IMBiTLTrack *itrack =nil;
    for (IMBiTLTrack *aTrack in itlTracks) {
        if ([aTrack.name isEqualToString:track.title] && [aTrack.artist isEqualToString:track.artist]) {
            
            if (aTrack.size == track.fileSize) {
                NSString *filePath = [aTrack.location path];
                //  aTrack.location = [NSURL fileURLWithPath:[IMBHelper getFilePathAlias:filePath]];
                
                track.title = [StringHelper createDifferentfileName:track.title];
                return nil;
                
                if (filePath == nil) {
                    return nil;//修改
                }
                [_loghandle writeInfoLog:[NSString stringWithFormat:@"this %@ already exsit in iTunes",track.title]];
                itrack = aTrack;
                break;
            }
        }
    }
    return itrack;
}

- (void)copyiBooksToLoacl:(IMBBookEntity *)book withDesPath:(NSString *)desfilePath {
    if ([book.extension caseInsensitiveCompare:@"pdf"] == NSOrderedSame) {
        NSString *filePath = [@"Books" stringByAppendingPathComponent:book.path];
        if ([[_ipod.fileSystem afcMediaDirectory] fileExistsAtPath:filePath]) {
            //将电子书考到指定的目录下
//            NSString *desfilePath = [_exportPath stringByAppendingFormat:@"/%@.pdf",book.bookName];
            //如果此目录下存在此书，则先删除在导出
            if ([_fileManager fileExistsAtPath:desfilePath]) {
                //如果存在，创建一个新的名字
                desfilePath = [StringHelper createDifferentfileName:desfilePath];
                
            }
            
            BOOL issuccess = NO;
            if (_limitation.remainderCount > 0) {
                issuccess = [[_ipod.fileSystem afcMediaDirectory] copyRemoteFile:filePath toLocalFile:desfilePath];
            }
            if (issuccess) {
                _addCount ++;
                _successCount ++;
                [_limitation reduceRedmainderCount];
            }else {
                [[IMBTransferError singleton] addAnErrorWithErrorName:book.bookName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_copy_error", nil)];
                _failedCount ++;
            }
        }else
        {
            [[IMBTransferError singleton] addAnErrorWithErrorName:book.bookName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_no_exist", nil)];
            _failedCount ++;
        }
    }else if ([book.extension caseInsensitiveCompare:@"epub"] == NSOrderedSame || [book.extension caseInsensitiveCompare:@"ibooks"] == NSOrderedSame ) {
//        NSString *filePath = [_exportPath stringByAppendingFormat:@"/%@.epub",book.bookName];
//        if ([book.extension caseInsensitiveCompare:@"epub"] == NSOrderedSame) {
//            filePath = [_exportPath stringByAppendingFormat:@"/%@.epub",book.bookName];
//        }else if ([book.extension caseInsensitiveCompare:@"ibooks"] == NSOrderedSame) {
//            filePath = [_exportPath stringByAppendingFormat:@"/%@.ibooks",book.bookName];
//        }
        if ([_fileManager fileExistsAtPath:desfilePath]) {
            //如果存在，创建一个新的名字
            desfilePath = [StringHelper createDifferentfileName:desfilePath];
        }
        //创建此文件
        BOOL issuccess = NO;
        if (_limitation.remainderCount > 0) {
            issuccess = [_fileManager createFileAtPath:desfilePath contents:nil attributes:nil];
        }else {
            [[IMBTransferError singleton] addAnErrorWithErrorName:book.bookName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
        }
        if (issuccess) {
            NSString *rootPath = nil;
            if (book.isPurchase) {
                rootPath = [@"Books/Purchases" stringByAppendingFormat:@"/%@",book.path];
            }else {
                rootPath = [@"Books" stringByAppendingPathComponent:book.path];
            }
            if ([[_ipod.fileSystem afcMediaDirectory] fileExistsAtPath:rootPath]) {
                 [_limitation reduceRedmainderCount];
                _addCount ++;
                _successCount ++;
                ZipFile *zipFile= [[ZipFile alloc] initWithFileName:desfilePath mode:ZipFileModeCreate];
                [self exportepubBook:[_ipod.fileSystem afcMediaDirectory] zipFile:zipFile rootPath:rootPath basefolder:@""];
                
                [zipFile close];
                [zipFile release];
                zipFile = nil;
                
                //                        BOOL isOuntOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
                //                        if (isOuntOfCount) {
                //                            break;
                //                        }
            }else {
                [[IMBTransferError singleton] addAnErrorWithErrorName:book.bookName WithErrorReson:CustomLocalizedString(@"Ex_Op_file_no_exist", nil)];
                _failedCount ++;
            }
            
        }else {
            _failedCount ++;
        }
    }
}

- (void)exportepubBook:(AFCMediaDirectory *)afcDir zipFile:(ZipFile *)zipFile rootPath:(NSString *)rootPath basefolder:(NSString *)basefolder {
    NSArray *arr = [afcDir getItemInDirWithoutRootDir:rootPath];
    for (AMFileEntity *file in arr) {
        NSString *fileName = [file.FilePath lastPathComponent];
        NSString *filePathinzip = [basefolder stringByAppendingPathComponent:fileName];
        //如果是目录
        if (file.FileType == AMDirectory) {
            [self exportepubBook:afcDir zipFile:zipFile rootPath:file.FilePath basefolder:filePathinzip];
        }else {
            AFCFileReference *read = [afcDir openForRead:file.FilePath];
            if (read) {
                ZipWriteStream *stream= [zipFile writeFileInZipWithName:filePathinzip fileDate:[NSDate dateWithTimeIntervalSinceNow:-86400.0] compressionLevel:ZipCompressionLevelBest];
                if (stream) {
                    const uint32_t bufsz = 10240;
                    char *buff = (char*)malloc(bufsz);
                    while (1) {
                        uint64_t n = [read readN:bufsz bytes:buff];
                        if (n==0) break;
                        //将字节数据转化为NSdata
                        NSData *b2 = [[NSData alloc]
                                      initWithBytesNoCopy:buff length:n freeWhenDone:NO];
                        
                        //输入流写数据
                        [stream writeData:b2];
                        [b2 release];
                    }
                    free(buff);
                    [stream finishedWriting];
                }
                [read closeFile];
            }
        }
    }
}

- (void)copyAppToLocal:(IMBAppEntity *)app withDesPath:(NSString *)desfilePath {
    IMBAppTransferTypeEnum archiveType = AppTransferType_All;
    IMBInformation *mation = [[IMBInformationManager shareInstance].informationDic objectForKey:_ipod.uniqueKey];
    IMBApplicationManager *appManager = [mation applicationManager];
    [appManager setListener:self];
    

    if ([_limitation remainderCount]>0) {
        BOOL success = [appManager backupAppTolocal:app ArchiveType:archiveType LocalFilePath:desfilePath];
        if (success) {
            [_limitation reduceRedmainderCount];
            _addCount ++;
            _successCount += 1;
        }else{
            _failedCount +=1;

        }
    }
    [appManager removeListener];
}

- (int64_t)caculateTransferTotalSize:(NSArray *)array {
    int64_t size = 0;
    if (_exportDic != nil) {
        for (NSNumber *type in _exportDic.allKeys) {
            switch (type.intValue) {
                case Category_Playlist: {
                    if (_isAllExport) {
                        NSArray *playlistArray = _infoMation.playlists.playlistArray;
                        for (IMBPlaylist *pl in playlistArray) {
                            _totalItemCount += pl.tracks.count;
                        }
                    }else {
                        NSDictionary *playListDic = [_exportDic objectForKey:type];
                        NSArray *tracks = [playListDic objectForKey:@"TracksArray"];
                        _totalItemCount += tracks.count;
                    }
                    break;
                }
                case Category_Music:
                case Category_Movies:
                case Category_TVShow:
                case Category_MusicVideo:
                case Category_VoiceMemos:
                case Category_HomeVideo:
                case Category_PodCasts:
                case Category_iTunesU:
                case Category_Audiobook:
                case Category_Ringtone: {
                    if (_isAllExport) {
                        NSArray *mediaArray = [_infoMation getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:type.intValue]];
                        _totalItemCount += mediaArray.count;
                    }else {
                        NSArray *tracks = [_exportDic objectForKey:type];
                        _totalItemCount += tracks.count;
                    }
                    break;
                }
                case Category_iBooks:
                case Category_iBookCollections: {
                    if (_isAllExport) {
                        NSArray *bookArray = [_infoMation allBooksArray];
                        _totalItemCount += bookArray.count;
                    }else {
                        NSMutableArray *booksArray = [_exportDic objectForKey:type];
                        _totalItemCount += booksArray.count;
                    }
                    break;
                }
                case Category_Applications: {
                    if (_isAllExport) {
                        NSArray *appArray = [[_infoMation applicationManager] appEntityArray];
                        _totalItemCount += appArray.count;
                    }else {
                        NSArray *appArray = [_exportDic objectForKey:type];
                        _totalItemCount += appArray.count;
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
    float progress = 50 + ((float)_currItemIndex / _addCount) * 50;
    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
        [_transferDelegate transferProgress:progress];
    }
}

@end
