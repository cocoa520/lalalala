//
//  IMBAllFileExport.m
//  iMobieTrans
//
//  Created by iMobie on 8/1/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBAllFileExport.h"
#import "IMBFileSystem.h"
#import "IMBDeviceInfo.h"
#import "IMBTransResult.h"
#import "IMBPlaylist.h"
//#import "IMBRecordingEntry.h"
#import "IMBPhotoEntity.h"
#import "IMBAppEntity.h"
#import "IMBAppConfig.h"
#import "IMBApplicationManager.h"
#import "IMBBookEntity.h"
#import "IMBZipHelper.h"
#import "IMBExportSetting.h"
//#import "IMBContactEntity.h"
//#import "IMBContactHelper.h"
//#import "IMBCalendarEventEntity.h"
//#import "IMBBookmarkEntity.h"
#import "IMBInformationManager.h"
#import "IMBInformation.h"
#import "StringHelper.h"
#import "TempHelper.h"
//#import "IMBSafariHistoryExport.h"
//#import "IMBMessageExport.h"
//#import "IMBNoteExport.h"
//#import "IMBContactExport.h"
//#import "IMBCalenderExport.h"
//#import "IMBBookMarkExport.h"
#import "IMBCategoryInfoModel.h"
//#import "IMBiCloudManager.h"
//#import "IMBCalendarEntity.h"
#import "IMBMediaInfo.h"
#import "IMBPhotoExportSettingConfig.h"
#import "IMBPhotoHeicManager.h"

@implementation IMBAllFileExport
@synthesize icloudManager = _icloudManager;
- (id)initWithIPodkey:(NSString *)ipodKey exportTracks:(NSArray *)exportTracks exportFolder:(NSString *)exportFolder withDelegate:(id)delegate {
    self = [super initWithIPodkey:ipodKey withDelegate:delegate];
    if (self) {
        _exportTracks = [exportTracks retain];
        _exportPath = [exportFolder retain];
        _infoMation = [[IMBInformationManager shareInstance].informationDic objectForKey:ipodKey];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)startTransfer {
    [_loghandle writeInfoLog:@"AllFileExport DoProgress enter"];
    if (_exportTracks != nil && _exportTracks.count > 0 && ![TempHelper stringIsNilOrEmpty:_exportPath]) {
        _currItemIndex = 0;
        _curSize = 0;
        _curCategory = 0;
        
        [self caculateTransferTotalCount];
        
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
        
        for (IMBCategoryInfoModel *model in _exportTracks) {
            _curCategory ++;
            NSString *stringKey = [IMBCommonEnum categoryNodesEnumToName:model.categoryNodes];
            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
                [_transferDelegate transferPrepareFileStart:[NSString stringWithFormat:@"Transferring %@...",stringKey]];
            }
            CategoryNodesEnum category = model.categoryNodes;
            NSString *exPath = [TempHelper createCategoryPath:_exportPath withString:stringKey];
            if (category == Category_Music||category == Category_CloudMusic||category == Category_Movies||category == Category_TVShow||category == Category_MusicVideo||category == Category_PodCasts||category == Category_iTunesU||category == Category_Ringtone||category == Category_Audiobook||category == Category_HomeVideo) {
                NSArray *mediaArray = nil;
                if (category == Category_CloudMusic) {
                    mediaArray = [_infoMation cloudTrackArray];
                }else {
                    mediaArray = [_infoMation getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:category]];
                }
//                if (_limitation.remainderCount == 0) {
//                    for (IMBTrack *track in mediaArray) {
//                       [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
//                    }
//                    break;
//                }
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    for (IMBTrack *track in mediaArray) {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:@"Skipped"];
                    }
                    break;
                }
                
                //计算改项大小;
                _curSize = 0;
                _totalSize = [[mediaArray valueForKeyPath:@"@sum.fileSize"] longLongValue];
                [_loghandle writeInfoLog:[NSString stringWithFormat:@"Begin export media:%@ ; count:%lu",stringKey,(unsigned long)mediaArray.count]];
                [self exportMediaTrack:mediaArray mediaExportPath:exPath];
                [_loghandle writeInfoLog:[NSString stringWithFormat:@"End export media:%@ ; count:%lu",stringKey,(unsigned long)mediaArray.count]];
            }
            else if (category == Category_Playlist) {
                NSArray *playlistArray = _infoMation.playlists.playlistArray;
                if (playlistArray != nil && playlistArray.count > 0) {
                    //计算该项大小
                    _curSize = 0;
                    for (IMBPlaylist *pl in playlistArray) {
                        _totalSize += [[pl.tracks valueForKeyPath:@"@sum.fileSize"] longLongValue];
                    }
                    for (IMBPlaylist *pl in playlistArray) {
                        [_condition lock];
                        if (_isPause) {
                            [_condition wait];
                        }
                        [_condition unlock];
                        if (!_isStop) {
                            NSString *playlistPath = [TempHelper createCategoryPath:exPath withString:pl.name];
                            [_loghandle writeInfoLog:[NSString stringWithFormat:@"Begin export media:%@ ; count:%lu",stringKey,(unsigned long)pl.tracks.count]];
                            [self exportMediaTrack:pl.tracks mediaExportPath:playlistPath];
                            [_loghandle writeInfoLog:[NSString stringWithFormat:@"End export media:%@ ; count:%lu",stringKey,(unsigned long)pl.tracks.count]];
                        }else {
                            for (IMBTrack *track in pl.tracks) {
                                [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:@"Skipped"];
                            }
                        }
                    }
                }
            }
//            else if (category == Category_VoiceMemos) {
//                NSArray *voicememosArray = [[_infoMation recording] recordingArray];
//                _curSize = 0;
//                _totalSize = [[voicememosArray valueForKeyPath:@"@sum.sizeLength"] longLongValue];
//                [_loghandle writeInfoLog:[NSString stringWithFormat:@"Begin export media:%@ ; count:%lu",stringKey,(unsigned long)voicememosArray.count]];
//                [self exportVoicememosTrack:voicememosArray voicememosExportPath:exPath];
//                [_loghandle writeInfoLog:[NSString stringWithFormat:@"End export media:%@ ; count:%lu",stringKey,(unsigned long)voicememosArray.count]];
//            }
            else if (category == Category_Applications) {
                NSArray *appArray = [[_infoMation applicationManager] appEntityArray];
                _curSize = 0;
                [_loghandle writeInfoLog:[NSString stringWithFormat:@"Begin export media:%@ ; count:%lu",stringKey,(unsigned long)appArray.count]];
                [self exportApp:appArray appExportPath:exPath];
                [_loghandle writeInfoLog:[NSString stringWithFormat:@"End export media:%@ ; count:%lu",stringKey,(unsigned long)appArray.count]];
            }
            else if (category == Category_CameraRoll||category == Category_PhotoStream||category == Category_PhotoLibrary||category == Category_PhotoVideo||category == Category_Panoramas||category == Category_TimeLapse||category == Category_SlowMove||category == Category_LivePhoto||category == Category_Screenshot||category == Category_PhotoSelfies||category == Category_Location||category == Category_Favorite) {
                if (_icloudManager != nil) {
//                    if (category == Category_PhotoVideo) {
//                        NSArray *array = [_icloudManager photoVideoAlbumArray];
//                        int i = 1;
//                        for (IMBToiCloudPhotoEntity *entity in array) {
//                            if (entity.subArray.count <= 0) {
//                                [_icloudManager getPhotoDetail:entity];
//                            }
//                            NSString *phPath = [TempHelper createCategoryPath:exPath withString:entity.albumTitle];
//                            [self exportiCloudPhoto:entity.subArray ExportPath:phPath withTotalCount:_icloudManager.photoVideoCount withCurCount:i];
//                            i += entity.subArray.count;
//                        }
//                    }
                }else {
                    NSArray *photoArray = nil;
                    if (category == Category_CameraRoll) {
                        photoArray = [_infoMation camerarollArray];
                    }else if (category == Category_PhotoStream) {
                        photoArray = [_infoMation photostreamArray];
                    }else if (category == Category_PhotoLibrary) {
                        photoArray = [_infoMation photolibraryArray];
                    }else if (category == Category_PhotoVideo) {
                        photoArray = [_infoMation photovideoArray];
                    }else if (category == Category_Panoramas) {
                        photoArray = [_infoMation panoramasArray];
                    }else if (category == Category_TimeLapse) {
                        photoArray = [_infoMation timelapseArray];
                    }else if (category == Category_SlowMove) {
                        photoArray = [_infoMation slowMoveArray];
                    }else if (category == Category_LivePhoto) {
                        photoArray = [_infoMation livePhotoArray];
                    }else if (category == Category_Screenshot) {
                        photoArray = [_infoMation screenshotArray];
                    }else if (category == Category_PhotoSelfies) {
                        photoArray = [_infoMation photoSelfiesArray];
                    }else if (category == Category_Location) {
                        photoArray = [_infoMation locationArray];
                    }else if (category == Category_Favorite) {
                        photoArray = [_infoMation favoriteArray];
                    }
                    _curSize = 0;
                    _totalSize = [[photoArray valueForKeyPath:@"@sum.photoSize"] longLongValue];
                    [_loghandle writeInfoLog:[NSString stringWithFormat:@"Begin export media:%@ ; count:%lu",stringKey,(unsigned long)photoArray.count]];
                    [self exportPhoto:photoArray photoExportPath:exPath];
                    [_loghandle writeInfoLog:[NSString stringWithFormat:@"End export media:%@ ; count:%lu",stringKey,(unsigned long)photoArray.count]];
                }
            }
            else if (category == Category_MyAlbums||category == Category_PhotoShare||category == Category_ContinuousShooting) {
                NSArray *albumArr = nil;
                if (category == Category_MyAlbums) {
                    albumArr = [_infoMation myAlbumsArray];
                }else if (category == Category_PhotoShare) {
                    albumArr = [_infoMation photoshareArray];
                }else if (category == Category_ContinuousShooting) {
                    albumArr = [_infoMation continuousShootingArray];
                }
                _curSize = 0;
                for (IMBPhotoEntity *entity in albumArr) {
                    NSArray *singleArray = nil;
                    if (category == Category_MyAlbums) {
                        singleArray = [_infoMation.albumsDic objectForKey:[NSNumber numberWithInt:entity.albumZpk]];
                    } else if (category == Category_PhotoShare) {
                        singleArray = [_infoMation.shareAlbumDic objectForKey:[NSNumber numberWithInt:entity.albumZpk]];
                    }else if (category == Category_ContinuousShooting) {
                        singleArray = [_infoMation.continuousShootingDic objectForKey:[NSNumber numberWithInt:entity.albumZpk]];
                    }
                    _totalSize += [[singleArray valueForKeyPath:@"@sum.photoSize"] longLongValue];
                }
                for (IMBPhotoEntity *entity in albumArr) {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (!_isStop) {
                        NSArray *singleArray = nil;
                        if (category == Category_MyAlbums) {
                            singleArray = [_infoMation.albumsDic objectForKey:[NSNumber numberWithInt:entity.albumZpk]];
                        } else if (category == Category_PhotoShare) {
                            singleArray = [_infoMation.shareAlbumDic objectForKey:[NSNumber numberWithInt:entity.albumZpk]];
                        }else if (category == Category_ContinuousShooting) {
                            singleArray = [_infoMation.continuousShootingDic objectForKey:[NSNumber numberWithInt:entity.albumZpk]];
                        }
                        
                        NSString *albumPath = @"";
                        if (singleArray.count == 0) {
                            continue;
                        }
                        for (IMBPhotoEntity *entity in singleArray) {
                            albumPath = entity.albumTitle;
                            if (![TempHelper stringIsNilOrEmpty:albumPath]) {
                                break;
                            }
                        }
                        albumPath = [TempHelper createCategoryPath:exPath withString:albumPath];
                        [_loghandle writeInfoLog:[NSString stringWithFormat:@"Begin export media:%@ ; count:%lu",stringKey,(unsigned long)singleArray.count]];
                        [self exportPhoto:singleArray photoExportPath:albumPath];
                        [_loghandle writeInfoLog:[NSString stringWithFormat:@"End export media:%@ ; count:%lu",stringKey,(unsigned long)singleArray.count]];
                    }else {
                        
                    }
                }
            }
//            else if (category == Category_Photo) {
//                NSArray *array = [_icloudManager albumArray];
//                int i = 1;
//                for (IMBToiCloudPhotoEntity *entity in array) {
//                    if (entity.subArray.count <= 0) {
//                        [_icloudManager getPhotoDetail:entity];
//                    }
//                    NSString *phPath = [TempHelper createCategoryPath:exPath withString:entity.albumTitle];
//                    [self exportiCloudPhoto:entity.subArray ExportPath:phPath withTotalCount:_icloudManager.photoCount withCurCount:i];
//                    i += entity.subArray.count;
//                }
//            }
//            else if (category == Category_Notes) {
//                NSArray *noteArray = nil;
//                if (_icloudManager == nil) {
//                     noteArray = [_infoMation noteArray];
//                }else{
//                     noteArray = [_icloudManager noteArray];
//                }
//                
//                [_loghandle writeInfoLog:[NSString stringWithFormat:@"Begin export media:%@ ; count:%lu",stringKey,(unsigned long)noteArray.count]];
//                [self exportNotes:noteArray notesExportPath:exPath];
//                [_loghandle writeInfoLog:[NSString stringWithFormat:@"End export media:%@ ; count:%lu",stringKey,(unsigned long)noteArray.count]];
//            }
//            else if (category == Category_Contacts) {
//                NSArray *contactArray = nil;
//                if (_icloudManager == nil) {
//                    contactArray = [_infoMation contactArray];
//                }else{
//                    contactArray = [_icloudManager contactArray];
//                }
//                [_loghandle writeInfoLog:[NSString stringWithFormat:@"Begin export media:%@ ; count:%lu",stringKey,(unsigned long)contactArray.count]];
//                [self exportContact:contactArray contactExportPath:exPath];
//                [_loghandle writeInfoLog:[NSString stringWithFormat:@"End export media:%@ ; count:%lu",stringKey,(unsigned long)contactArray.count]];
//            }
//            else if (category == Category_Bookmarks) {
//                NSArray *bookmarkArray = [_infoMation bookmarkArray];//[_exportDic objectForKey:nodesEnumNum];
//                [_loghandle writeInfoLog:[NSString stringWithFormat:@"Begin export media:%@ ; count:%lu",stringKey,(unsigned long)bookmarkArray.count]];
//                [self exportBookmark:bookmarkArray bookmarkExportPath:exPath];
//                [_loghandle writeInfoLog:[NSString stringWithFormat:@"End export media:%@ ; count:%lu",stringKey,(unsigned long)bookmarkArray.count]];
//            }
//            else if (category == Category_Calendar || category == Category_Reminder) {
//                
//                NSMutableArray *calenderArray = nil;
//                if (_icloudManager == nil) {
//                    calenderArray = [NSMutableArray array];
//                    for (IMBCalendarEntity *entity in [_infoMation calendarArray]) {
//                        [calenderArray addObjectsFromArray:entity.eventCalendatArray];
//                    }
//                }else{
//                    if (category == Category_Calendar) {
//                        calenderArray = [NSMutableArray array];
//                        calenderArray = [_icloudManager calendarArray];
//                    }else if (category == Category_Reminder){
//                        calenderArray = [_icloudManager reminderArray];
//                    }
//                }
//                [_loghandle writeInfoLog:[NSString stringWithFormat:@"Begin export media:%@ ; count:%lu",stringKey,(unsigned long)calenderArray.count]];
//                if (category == Category_Calendar) {
//                    [self exportCalender:calenderArray calenderExportPath:exPath];
//                }else if (category == Category_Reminder){
//                    [self exportReminder:calenderArray calenderExportPath:exPath];
//                }
//                [_loghandle writeInfoLog:[NSString stringWithFormat:@"End export media:%@ ; count:%lu",stringKey,(unsigned long)calenderArray.count]];
//            }
            else if (category == Category_iBooks || category == Category_iBookCollections) {
                NSArray *bookArray = [_infoMation allBooksArray];
                _curSize = 0;
                _totalSize += [[bookArray valueForKeyPath:@"@sum.size"] longLongValue];
                [_loghandle writeInfoLog:[NSString stringWithFormat:@"Begin export media:%@ ; count:%lu",stringKey,(unsigned long)bookArray.count]];
                [self exportiBook:bookArray iBookExportPath:exPath];
                [_loghandle writeInfoLog:[NSString stringWithFormat:@"End export media:%@ ; count:%lu",stringKey,(unsigned long)bookArray.count]];
            }
//            else if (category == Category_Message) {
//                NSArray *messageArray = [_infoMation messageArray];
//                [_loghandle writeInfoLog:[NSString stringWithFormat:@"Begin export media:%@ ; count:%lu",stringKey,(unsigned long)messageArray.count]];
//                [self exportMessage:messageArray bookmarkExportPath:exPath];
//                [_loghandle writeInfoLog:[NSString stringWithFormat:@"End export media:%@ ; count:%lu",stringKey,(unsigned long)messageArray.count]];
//            }
//            else if (category == Category_Voicemail) {
//                NSArray *voicemailArray = [_infoMation voicemailArray];
//                _curSize = 0;
//                 [_loghandle writeInfoLog:[NSString stringWithFormat:@"Begin export media:%@ ; count:%lu",stringKey,(unsigned long)voicemailArray.count]];
//                for (IMBVoiceMailAccountEntity *entity in voicemailArray) {
//                    _totalSize += [[entity.subArray valueForKeyPath:@"@sum.size"]longLongValue];
//                    [self exportVoiceMail:entity.subArray photoExportPath:exPath];
//                }
////                _totalSize += [[voicemailArray valueForKeyPath:@"@sum.size"] longLongValue];
//                [_loghandle writeInfoLog:[NSString stringWithFormat:@"End export media:%@ ; count:%lu",stringKey,(unsigned long)voicemailArray.count]];
//            }
//            else if (category == Category_SafariHistory) {
//                NSArray *safariArray = [_infoMation safariHistoryArray];
//                [_loghandle writeInfoLog:[NSString stringWithFormat:@"Begin export media:%@ ; count:%lu",stringKey,(unsigned long)safariArray.count]];
//                [self exportSafariHistory:safariArray bookmarkExportPath:exPath];
//                [_loghandle writeInfoLog:[NSString stringWithFormat:@"End export media:%@ ; count:%lu",stringKey,(unsigned long)safariArray.count]];
//            }
        }
    }
    sleep(2);
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
    [_loghandle writeInfoLog:@"AllFileExport DoProgress End"];
}

#pragma mark - 导出media
- (void)exportMediaTrack:(NSArray *)mediaArray mediaExportPath:(NSString *)exPath {
    if (mediaArray != nil && mediaArray.count > 0) {
        for (IMBTrack *track in mediaArray) {
//            if (_limitation.remainderCount == 0) {
//                [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
//                continue;
//            }
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (!_isStop) {
                _currItemIndex++;
                //获得设备中的文件路径
                NSString *remotingFilePath = [[[_ipod fileSystem] driveLetter] stringByAppendingPathComponent:[track filePath]];
                if (![TempHelper stringIsNilOrEmpty:track.title]) {
                    NSString *msgStr = [NSString stringWithFormat:@"Copying %@...",track.title];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
//                float progress = ((float)_currItemIndex / _totalItemCount) * 100;
//                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
//                    [_transferDelegate transferProgress:progress];
//                }
                
                if ([[_ipod fileSystem] fileExistsAtPath:remotingFilePath]) {
                    NSString *fileName = [[TempHelper replaceSpecialChar:[track title]] stringByAppendingPathExtension:[[track filePath] pathExtension]];
                    NSString *destFilePath = [exPath stringByAppendingPathComponent:fileName];
                    if ([_fileManager fileExistsAtPath:destFilePath]) {
                        destFilePath = [TempHelper getFilePathAlias:destFilePath];
                    }
                    if ([self copyRemoteFile:remotingFilePath toLocalFile:destFilePath]) {
//                    if ([self asyncCopyRemoteFile:remotingFilePath toLocalFile:destFilePath]) {
                        _successCount += 1;
//                        [_limitation reduceRedmainderCount];
                    }else {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:@"Coping file failed."];
                        _failedCount += 1;
                    }
                } else {
                     [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:@"The file does not exist in your iPhone or your backups"];
                    _failedCount += 1;
                }
            }else {
                 [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:@"Skipped"];
                _skipCount ++;
            }
        }
    }
}

#pragma mark - 导出VoiceMemos
//- (void)exportVoicememosTrack:(NSArray *)moicememosArray voicememosExportPath:(NSString *)exPath {
//    if (moicememosArray != nil && moicememosArray.count > 0) {
//        for (IMBRecordingEntry *recordingEntry in moicememosArray) {
//            if (_limitation.remainderCount == 0) {
//                [[IMBTransferError singleton] addAnErrorWithErrorName:recordingEntry.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
//                continue;
//            }
//            [_condition lock];
//            if (_isPause) {
//                [_condition wait];
//            }
//            [_condition unlock];
//            if (!_isStop) {
//                _currItemIndex++;
//                //获得设备中的文件路径
//                NSString *remotingFilePath = [[[_ipod fileSystem] driveLetter] stringByAppendingPathComponent:[recordingEntry path]];
//                if (![TempHelper stringIsNilOrEmpty:recordingEntry.path]) {
//                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),[recordingEntry.path lastPathComponent]];
//                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
//                        [_transferDelegate transferFile:msgStr];
//                    }
//                }
////                float progress = ((float)_currItemIndex / _totalItemCount) * 100;
////                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
////                    [_transferDelegate transferProgress:progress];
////                }
//                
//                if ([[_ipod fileSystem] fileExistsAtPath:remotingFilePath]) {
//                    NSString *fileName = [[TempHelper replaceSpecialChar:[recordingEntry name]] stringByAppendingPathExtension:[[recordingEntry path] pathExtension]];
//                    NSString *destFilePath = [exPath stringByAppendingPathComponent:fileName];
//                    
//                    if ([_fileManager fileExistsAtPath:destFilePath]) {
//                        destFilePath = [TempHelper getFilePathAlias:destFilePath];
//                    }
//                    if ([self copyRemoteFile:remotingFilePath toLocalFile:destFilePath]) {
////                    if ([self asyncCopyRemoteFile:remotingFilePath toLocalFile:destFilePath]) {
//                        _successCount += 1;
//                        [_limitation reduceRedmainderCount];
//                    }else {
//                        [[IMBTransferError singleton] addAnErrorWithErrorName:recordingEntry.name WithErrorReson:CustomLocalizedString(@"Ex_Op_file_copy_error", nil)];
//                        _failedCount += 1;
//                    }
//                } else {
//                    [[IMBTransferError singleton] addAnErrorWithErrorName:recordingEntry.name WithErrorReson:CustomLocalizedString(@"Ex_Op_file_no_exist", nil)];
//                    _failedCount += 1;
//                }
//            }else {
//                [[IMBTransferError singleton] addAnErrorWithErrorName:recordingEntry.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
//                _skipCount ++;
//            }
//        }
//    }
//}

#pragma mark - 导出Photo
- (void)exportPhoto:(NSArray *)photoArray photoExportPath:(NSString *)exPath {
    if (photoArray != nil && photoArray.count > 0) {
        for (IMBPhotoEntity *pe in photoArray) {
//            if (_limitation.remainderCount == 0) {
//                [[IMBTransferError singleton] addAnErrorWithErrorName:pe.photoName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
//            }
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (!_isStop) {
                _currItemIndex += 1;
                //获得设备中的文件路径
                NSString *remotingFilePath = pe.allPath;
                if (![TempHelper stringIsNilOrEmpty:pe.photoName]) {
                    NSString *msgStr = [NSString stringWithFormat:@"Copying %@...",pe.photoName];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
                
                NSString *filePath = [exPath stringByAppendingPathComponent:pe.photoName];
                NSString *nowPath = @"";
                //用户用设备修改过的图片导出
                  BOOL success = NO;
                if (![pe.photoPath contains:@"Sync"]) {
                    if ([_fileManager fileExistsAtPath:filePath]) {
                        filePath = [TempHelper getFilePathAlias:filePath];
                    }
                    
                    NSString *deviceCutImagePath = [@"PhotoData/Metadata/" stringByAppendingPathComponent:remotingFilePath];
                    if ([_ipod.fileSystem fileExistsAtPath:deviceCutImagePath]) {
                        [_loghandle writeInfoLog:[NSString stringWithFormat:@"cut photo exist:%@",deviceCutImagePath]];
                        [_ipod.fileSystem copyRemoteFile:deviceCutImagePath toLocalFile:filePath];
                    }else {
                        deviceCutImagePath = [@"PhotoData/Mutations/" stringByAppendingPathComponent:[[remotingFilePath stringByDeletingPathExtension] stringByAppendingPathComponent:@"Adjustments/FullSizeRender.jpg"]];
                        if ([_ipod.fileSystem fileExistsAtPath:deviceCutImagePath]) {
                            [_ipod.fileSystem copyRemoteFile:deviceCutImagePath toLocalFile:filePath];
                            if (pe.kindSubType == 2) {
                                NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-i",filePath,[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"11.jpg"],nil];
                                [self runFFMpeg:params];
                                
                                NSImage *mediaInfo = [[NSImage alloc]initWithContentsOfFile:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"11.jpg"]];

                                NSString *imageSizeString =  [NSString stringWithFormat:@"%d*%d",(int)mediaInfo.size.width ,(int)mediaInfo.size.height];
                                IMBPhotoExportSettingConfig *exportSeetingConfig = [IMBPhotoExportSettingConfig singleton];
                                NSString *path = @"";
                                if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_MP4) {
                                    path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"mp4"];
                                    success = [self startVideoConvert:filePath withConvetPath:path withFormat:imageSizeString];
                                }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_M4V){
                                    path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"m4v"];
                                    success = [self startVideoConvert:filePath withConvetPath:path withFormat:imageSizeString];
                                }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_GifHigh){
                                    path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"gif"];
                                    success = [self startGifConvert:filePath withConvetPath:path withFormat:imageSizeString];
                                }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_GifMiddle){
                                    imageSizeString =  [NSString stringWithFormat:@"%d*%d",(int)mediaInfo.size.width/2 ,(int)mediaInfo.size.height/2];
                                path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"gif"];
                                    success = [self startGifConvert:filePath withConvetPath:path withFormat:imageSizeString];//1/2倍转换
                                }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_GifLow){
                                    imageSizeString =  [NSString stringWithFormat:@"%d*%d",(int)mediaInfo.size.width/4 ,(int)mediaInfo.size.height/4];
                                    path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"gif"];
                                    success = [self startGifConvert:filePath withConvetPath:path withFormat:imageSizeString];//1/4倍转换
                                }
                                if (exportSeetingConfig.chooseLivePhotoExportType != ExportLivePhoto_GifOriginal){
                                    nowPath = path;
                                }else{
                                    nowPath = filePath;
                                }
                                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
                                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                    if (exportSeetingConfig.chooseLivePhotoExportType != ExportLivePhoto_GifOriginal){
                                        [_fileManager removeItemAtPath:filePath error:nil];
                                    }
                                });
                            }else{
                                nowPath = filePath;
                            }
                            if (success) {
                                IMBPhotoExportSettingConfig *photoExportConfig = [IMBPhotoExportSettingConfig singleton];
                                if (photoExportConfig.isCreadPhotoDate) {
                                    NSTask *task;
                                    task = [[NSTask alloc] init];
                                    [task setLaunchPath: @"/usr/bin/touch"];
                                    NSArray *arguments;
                                    NSString *str = [DateHelper dateFrom2001ToString:pe.photoDateData withMode:3];
                                    NSString *strData = [TempHelper replaceSpecialChar:str];
                                    strData = [strData stringByReplacingOccurrencesOfString:@" " withString:@""];
                                    strData = [strData stringByReplacingOccurrencesOfString:@"-" withString:@""];
                                    arguments = [NSArray arrayWithObjects: @"-mt", strData, nowPath, nil];
                                    [task setArguments: arguments];
                                    NSPipe *pipe;
                                    pipe = [NSPipe pipe];
                                    [task setStandardOutput: pipe];
                                    NSFileHandle *file;
                                    file = [pipe fileHandleForReading];
                                    [task launch];
                                }

                            }
                        }
                    }
                }
     
                //导出设备存在的图片
                if (![_ipod.fileSystem fileExistsAtPath:remotingFilePath]) {
                    remotingFilePath = pe.thumbPath;
                }
                if ([_ipod.fileSystem fileExistsAtPath:remotingFilePath]) {
                    if ([_fileManager fileExistsAtPath:filePath]) {
                        filePath = [TempHelper getFilePathAlias:filePath];
                    }
                    //判断是否是live photo
                    if (pe.kindSubType == 2) {
                            success = [_ipod.fileSystem copyRemoteFile:[pe.photoPath stringByAppendingPathComponent:pe.photoName] toLocalFile:filePath];
                        NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-i",filePath,[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"11.jpg"],nil];
                        [self runFFMpeg:params];
                    
                        NSImage *mediaInfo = [[NSImage alloc]initWithContentsOfFile:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"11.jpg"]];
//                            NSImage *mediaInfo = [[NSImage alloc]initWithContentsOfFile:filePath];
                            NSString *imageSizeString =  [NSString stringWithFormat:@"%d*%d",(int)mediaInfo.size.width ,(int)mediaInfo.size.height];
                            IMBPhotoExportSettingConfig *exportSeetingConfig = [IMBPhotoExportSettingConfig singleton];
                            NSString *path = @"";
                            if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_MP4) {
                                path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"mp4"];
                                success = [self startVideoConvert:filePath withConvetPath:path withFormat:imageSizeString];
                            }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_M4V){
                                path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"m4v"];
                                success = [self startVideoConvert:filePath withConvetPath:path withFormat:imageSizeString];
                            }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_GifHigh){
                                path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"gif"];
                                success = [self startGifConvert:filePath withConvetPath:path withFormat:imageSizeString];
                            }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_GifMiddle){
                                imageSizeString =  [NSString stringWithFormat:@"%d*%d",(int)mediaInfo.size.width/2 ,(int)mediaInfo.size.height/2];
                                path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"gif"];
                                success = [self startGifConvert:filePath withConvetPath:path withFormat:imageSizeString];//1/2倍转换
                            }else if (exportSeetingConfig.chooseLivePhotoExportType == ExportLivePhoto_GifLow){
                                imageSizeString =  [NSString stringWithFormat:@"%d*%d",(int)mediaInfo.size.width/4 ,(int)mediaInfo.size.height/4];
                                path = [[filePath stringByDeletingPathExtension]stringByAppendingPathExtension:@"gif"];
                                success = [self startGifConvert:filePath withConvetPath:path withFormat:imageSizeString];//1/4倍转换
                            }
                            if (exportSeetingConfig.chooseLivePhotoExportType != ExportLivePhoto_GifOriginal){
                                nowPath = path;
                            }else{
                                nowPath = filePath;
                            }
                            [mediaInfo release];
                            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
                            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                if (exportSeetingConfig.chooseLivePhotoExportType != ExportLivePhoto_GifOriginal){
                                    [_fileManager removeItemAtPath:filePath error:nil];
                                }
                            });
                        
                        if([_fileManager fileExistsAtPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"11.jpg"]]){
                            [_fileManager removeItemAtPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"11.jpg"] error:nil];
                        }
                    }else if ([[[pe.photoName pathExtension] lowercaseString] isEqualToString:@"heic"]){
                        success = [_ipod.fileSystem copyRemoteFile:[pe.photoPath stringByAppendingPathComponent:pe.photoName] toLocalFile:filePath];
                        IMBPhotoExportSettingConfig *exportSeetingConfig = [IMBPhotoExportSettingConfig singleton];
                        nowPath = filePath;
                        if (!exportSeetingConfig.isHEICState) {
                            IMBPhotoHeicManager *pM = [IMBPhotoHeicManager singleton];
                            NSString *heicFilePath = filePath;
                            NSString *inputFilePath = [TempHelper getAppTempPath];
                            NSString *outputFilePath = [filePath stringByDeletingLastPathComponent];
                            NSString *fileType = @"jpg";
                            [pM initParamsWithHeic:heicFilePath withInputPath:inputFilePath withOutputPath:outputFilePath withFileType:fileType];
                            [pM startConvert];
                            nowPath = [[filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"jpg"];
                            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2/*延迟执行时间*/ * NSEC_PER_SEC));
                            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                if([_fileManager fileExistsAtPath:heicFilePath]){
                                    [_fileManager removeItemAtPath:heicFilePath error:nil];
                                }
                            });
                        }
                    }else{
                        nowPath = filePath;
                        success = [self copyRemoteFile:remotingFilePath toLocalFile:filePath];
                    }
                    if (success) {
                        IMBPhotoExportSettingConfig *photoExportConfig = [IMBPhotoExportSettingConfig singleton];
                        if (photoExportConfig.isCreadPhotoDate) {
                            NSTask *task;
                            task = [[NSTask alloc] init];
                            [task setLaunchPath: @"/usr/bin/touch"];
                            NSArray *arguments;
                            NSString *str = [DateHelper dateFrom2001ToString:pe.photoDateData withMode:3];
                            NSString *strData = [TempHelper replaceSpecialChar:str];
                            strData = [strData stringByReplacingOccurrencesOfString:@" " withString:@""];
                            strData = [strData stringByReplacingOccurrencesOfString:@"-" withString:@""];
                            arguments = [NSArray arrayWithObjects: @"-mt", strData, nowPath, nil];
                            [task setArguments: arguments];
                            NSPipe *pipe;
                            pipe = [NSPipe pipe];
                            [task setStandardOutput: pipe];
                            NSFileHandle *file;
                            file = [pipe fileHandleForReading];
                            [task launch];
                        }
                        _successCount += 1;
//                        [_limitation reduceRedmainderCount];
                    }else {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:pe.photoName WithErrorReson:@"Coping file failed."];
                        _failedCount += 1;
                    }
                }else {
                    [[IMBTransferError singleton] addAnErrorWithErrorName:pe.photoName WithErrorReson:@"The file does not exist in your iPhone or your backups"];
                    [_loghandle writeInfoLog:[NSString stringWithFormat:@"photo isn't exist:%@",pe.allPath]];
                    _failedCount += 1;
                }
            }else {
                [[IMBTransferError singleton] addAnErrorWithErrorName:pe.photoName WithErrorReson:@"Skipped"];
                _skipCount ++;
            }
            if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                float progress = (float)_successCount/(float)photoArray.count*100;
                [_transferDelegate transferProgress:progress];
            }
        }
    }
}

//live photo 转Video
- (BOOL)startVideoConvert:(NSString *)sourPath withConvetPath:(NSString *)conPath withFormat:(NSString *)format {
    NSLog(@"start Convert");
    NSArray *params = [NSArray arrayWithObjects:@"-i",[NSString stringWithFormat:@"%@",sourPath], @"-y",@"-vcodec",@"mpeg4",@"-r",@"30000/1001",@"-q",@"2",@"-b:v",@"2500",@"-ab",@"128k", @"-s",format,@"-strict",@"-2",[NSString stringWithFormat:@"%@",conPath], nil];
    return [self runFFMpeg:params];
}
//live photo 转gif
- (BOOL)startGifConvert:(NSString *)sourPath withConvetPath:(NSString *)conPath withFormat:(NSString *)format {
    NSLog(@"start Convert");
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-ss",@"0",@"-t",@"2",@"-i",[NSString stringWithFormat:@"%@",sourPath],@"-s",format,@"-f",@"gif",[NSString stringWithFormat:@"%@",conPath],nil];
    return [self runFFMpeg:params];
}


- (BOOL)startConvert:(NSString *)sourPath withConvetPath:(NSString *)conPath {
    [_loghandle writeInfoLog:@"start Convert"];
    NSMutableArray *params = [NSMutableArray arrayWithObjects:@"-ss",@"0",@"-t",@"10",@"-i",[NSString stringWithFormat:@"%@",sourPath],@"-s",@"480*620",@"-f",@"gif",[NSString stringWithFormat:@"%@",conPath],nil];
    return [self runFFMpeg:params];
}

- (BOOL) runFFMpeg:(NSArray*)params {
    [_loghandle writeInfoLog:@"ffmpeg Start"];
    NSString* ffmpegPath = [[NSBundle mainBundle] pathForResource:@"ffmpeg" ofType:@""];
    
    if (params != nil) {
        NSLog(@"params:%@",params);
        NSTask *task = [[NSTask alloc] init];
        //Todo这里需要异步操作!!
        [task setLaunchPath: ffmpegPath];
        [task setArguments: params];
        //        NSPipe *errorPipe = [NSPipe pipe];
        //        [task setStandardError:errorPipe];
        //        NSFileHandle *errFile = [errorPipe fileHandleForReading];
        //        [errFile waitForDataInBackgroundAndNotify];
        
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

#pragma mark - 导出App
- (void)exportApp:(NSArray *)appArray appExportPath:(NSString *)exPath {
    _currItemIndex = 0;
    if (appArray != nil && appArray.count > 0 && _ipod != nil) {
        _archiveType = _ipod.appConfig.appExportToMacType;
        _singleStep = 3; //分为 加压，考出与删除App三部分
        _totalStep = (int)appArray.count * _singleStep;
        _curStep = 0;
        IMBInformation *mation = [[IMBInformationManager shareInstance].informationDic objectForKey:_ipod.uniqueKey];
        IMBApplicationManager *appManager = [mation applicationManager];
        [appManager setListener:self];
        for (IMBAppEntity *app in appArray) {
//            if (_limitation.remainderCount == 0) {
//                [[IMBTransferError singleton] addAnErrorWithErrorName:app.appName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
//                continue;
//            }
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (!_isStop) { //appManager.StartServiceStatus可以不用哈
                _currItemIndex += 1;
                if (![TempHelper stringIsNilOrEmpty:app.appName]) {
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:[NSString stringWithFormat:@"Copying %@...",app.appName]];
                    }
                }
//                NSString *expInfo = @"";
//                if (_archiveType == AppTransferType_All || _archiveType == AppTransferType_DocumentsOnly)
//                { expInfo = @"including docs"; }
//                else
//                { expInfo = @"app only"; }
                NSString *appFilePath = @"";
                appFilePath = [NSString stringWithFormat:@"%@/%@(v%@).ipa",exPath,app.appName,app.version];
                if ([appManager backupAppTolocal:app ArchiveType:_archiveType LocalFilePath:appFilePath]) {
                    _successCount += 1;
//                    [_limitation reduceRedmainderCount];
                } else {
                    _failedCount +=1;
                }
            } else {
                [[IMBTransferError singleton] addAnErrorWithErrorName:app.appName WithErrorReson:@"Skipped"];
                _skipCount += 1;
            }
        }
        [appManager removeListener];
    }
}

-(void)setCurStep:(int)curStep {
    _curStep = (_currItemIndex - 1) * _singleStep + curStep;
    float progress = (((float)_curStep / _totalStep) * 100) / _exportTracks.count + ((((float)_curCategory - 1) / _exportTracks.count)) * 100;
    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
        [_transferDelegate transferProgress:progress];
    }
}

#pragma mark - 导出iBook
- (void)exportiBook:(NSArray *)iBookArray iBookExportPath:(NSString *)expath {
    if (iBookArray != nil && iBookArray.count > 0) {
        AFCMediaDirectory *afcDir = [_ipod.fileSystem afcMediaDirectory];
        for (IMBBookEntity *book in iBookArray) {
//            if (_limitation.remainderCount == 0) {
//                break;
//            }
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (!_isStop) {
                _currItemIndex ++;
                if (![TempHelper stringIsNilOrEmpty:book.bookName]) {
                    NSString *msgStr = [NSString stringWithFormat:@"Copying %@...",book.bookName];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
//                    float progress = ((float)_currItemIndex / _totalItemCount) * 100;
//                    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
//                        [_transferDelegate transferProgress:progress];
//                    }
                if ([book.extension caseInsensitiveCompare:@"pdf"] == NSOrderedSame) {
                    NSString *filePath = [@"Books" stringByAppendingPathComponent:book.path];
                    if ([afcDir fileExistsAtPath:filePath]) {
                        //将电子书考到指定的目录下
                        NSString *desfilePath = [expath stringByAppendingFormat:@"/%@.pdf",book.bookName];
                        //如果此目录下存在此书，则先删除在导出
                        if ([_fileManager fileExistsAtPath:desfilePath]) {
                            //如果存在，创建一个新的名字
                            desfilePath = [StringHelper createDifferentfileName:desfilePath];
                            
                        }
                        BOOL issuccess = [self copyRemoteFile:filePath toLocalFile:desfilePath];
                        if (issuccess) {
                            _successCount ++;
//                            [_limitation reduceRedmainderCount];
                        }else {
                            _failedCount ++;
                        }
                    }else
                    {
                        _failedCount ++;
                    }
                }else if ([book.extension caseInsensitiveCompare:@"epub"] == NSOrderedSame || [book.extension caseInsensitiveCompare:@"ibooks"] == NSOrderedSame ) {
                    NSString *filePath = [expath stringByAppendingFormat:@"/%@.epub",book.bookName];
                    if ([book.extension caseInsensitiveCompare:@"epub"] == NSOrderedSame) {
                        filePath = [expath stringByAppendingFormat:@"/%@.epub",book.bookName];
                    }else if ([book.extension caseInsensitiveCompare:@"ibooks"] == NSOrderedSame) {
                        filePath = [expath stringByAppendingFormat:@"/%@.ibooks",book.bookName];
                    }
                    if ([_fileManager fileExistsAtPath:filePath]) {
                        //如果存在，创建一个新的名字
                        filePath = [StringHelper createDifferentfileName:filePath];
                    }
                    //创建此文件
                    BOOL issuccess = [_fileManager createFileAtPath:filePath contents:nil attributes:nil];
                    if (issuccess) {
                        NSString *rootPath = nil;
                        if (book.isPurchase) {
                            rootPath = [@"Books/Purchases" stringByAppendingFormat:@"/%@",book.path];
                        }else {
                            rootPath = [@"Books" stringByAppendingPathComponent:book.path];
                        }
                        if ([afcDir fileExistsAtPath:rootPath]) {
                            _successCount ++;
                            ZipFile *zipFile= [[ZipFile alloc] initWithFileName:filePath mode:ZipFileModeCreate];
                            [self exportepubBook:afcDir zipFile:zipFile rootPath:rootPath basefolder:@""];
                            
                            [zipFile close];
                            [zipFile release];
                            zipFile = nil;
//                            [_limitation reduceRedmainderCount];
                        }else {
                            _failedCount ++;
                        }
                        
                    }else {
                        _failedCount ++;
                    }
                }
            }else {
                _skipCount ++;
            }
        }
    }
}

- (void)exportepubBook:(AFCMediaDirectory *)afcDir zipFile:(ZipFile *)zipFile rootPath:(NSString *)rootPath basefolder:(NSString *)basefolder {
    NSArray *arr = [afcDir getItemInDirWithoutRootDir:rootPath];
    for (AMFileEntity *file in arr) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            break;
        }
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
                        [self sendCopyProgress:n];
                    }
                    free(buff);
                    [stream finishedWriting];
                }
                [read closeFile];
            }
        }
    }
}

#pragma mark - 导出notes
//- (void)exportNotes:(NSArray *)notesArray notesExportPath:(NSString *)exPath {
//    if (notesArray != nil && notesArray.count > 0) {
//        NSString *mode = nil;
//        if (_icloudManager == nil) {
//           mode = [_ipod.exportSetting getExportExtension:_ipod.exportSetting.notesType];
//        }else{
//            IMBExportSetting *setting = [[IMBExportSetting alloc] initWithIPod:nil];
//            [setting readDictionary];
//            mode =  [setting getExportExtension:setting.notesType];
//            [setting release];
//        }
//
//        
//        IMBNoteExport *noteExport = [[IMBNoteExport alloc] initWithPath:exPath exportTracks:notesArray withMode:mode withDelegate:_transferDelegate];
//        [noteExport setIsAllExport:YES];
//        [noteExport setPercent:((((float)_curCategory - 1)/_exportTracks.count))*100];
//        [noteExport setTotalItem:(int)_exportTracks.count];
//        [noteExport startTransfer];
//        _isStop = noteExport.isStop;
//        [noteExport release];
//        if (_isStop) {
//            _skipCount += notesArray.count;
//        }else {
//            _successCount += notesArray.count;
//        }
//    }
//}

#pragma mark - 导出contact
//- (void)exportContact:(NSArray *)contactArray contactExportPath:(NSString *)expath {
//    if (contactArray != nil && contactArray.count >0) {
//        NSString *mode = nil;
//        if (_icloudManager == nil) {
//            mode = [_ipod.exportSetting getExportExtension:_ipod.exportSetting.contactType];
//        }else{
//            IMBExportSetting *setting = [[IMBExportSetting alloc] initWithIPod:nil];
//            [setting readDictionary];
//            mode =  [setting getExportExtension:setting.contactType];
//            [setting release];
//        }
//
//        IMBContactExport *contactExport = [[IMBContactExport alloc] initWithPath:expath exportTracks:contactArray withMode:mode withDelegate:_transferDelegate];
//        [contactExport setIsAllExport:YES];
//        [contactExport setPercent:((((float)_curCategory - 1)/_exportTracks.count))*100];
//        [contactExport setTotalItem:(int)_exportTracks.count];
//        [contactExport startTransfer];
//        _isStop = contactExport.isStop;
//        [contactExport release];
//        if (_isStop) {
//            _skipCount += contactArray.count;
//        }else {
//            _successCount += contactArray.count;
//        }
//    }
//}

#pragma mark - 导出calender
//- (void)exportCalender:(NSArray *)calenderArray calenderExportPath:(NSString *)exPath {
//    if (calenderArray != nil && calenderArray.count > 0) {
//        NSString *mode = nil;
//        if (_icloudManager == nil) {
//            mode = [_ipod.exportSetting getExportExtension:_ipod.exportSetting.calenderType];
//        }else{
//            IMBExportSetting *setting = [[IMBExportSetting alloc] initWithIPod:nil];
//            [setting readDictionary];
//            mode =  [setting getExportExtension:setting.calenderType];
//            [setting release];
//        }
//        IMBCalenderExport *calenderExport = [[IMBCalenderExport alloc] initWithPath:exPath exportTracks:calenderArray withMode:mode withDelegate:_transferDelegate];
//        [calenderExport setIsAllExport:YES];
//        [calenderExport setPercent:((((float)_curCategory - 1)/_exportTracks.count))*100];
//        [calenderExport setTotalItem:(int)_exportTracks.count];
//        [calenderExport startTransfer];
//        _isStop = calenderExport.isStop;
//        [calenderExport release];
//        if (_isStop) {
//            _skipCount += calenderArray.count;
//        }else {
//            _successCount += calenderArray.count;
//        }
//    }
//}

//- (void)exportReminder:(NSArray *)calenderArray calenderExportPath:(NSString *)exPath
//{
//    if (calenderArray != nil && calenderArray.count > 0) {
//        NSString *mode = nil;
//        if (_icloudManager == nil) {
//            mode = [_ipod.exportSetting getExportExtension:_ipod.exportSetting.reminderType];
//        }else{
//            IMBExportSetting *setting = [[IMBExportSetting alloc] initWithIPod:nil];
//            [setting readDictionary];
//            mode =  [setting getExportExtension:setting.reminderType];
//            [setting release];
//        }
//        IMBCalenderExport *calenderExport = [[IMBCalenderExport alloc] initWithPath:exPath exportTracks:calenderArray withMode:mode withDelegate:_transferDelegate];
//        [calenderExport setIsReminder:YES];
//        [calenderExport setIsAllExport:YES];
//        [calenderExport setPercent:((((float)_curCategory - 1)/_exportTracks.count))*100];
//        [calenderExport setTotalItem:(int)_exportTracks.count];
//        [calenderExport startTransfer];
//        _isStop = calenderExport.isStop;
//        [calenderExport release];
//        if (_isStop) {
//            _skipCount += calenderArray.count;
//        }else {
//            _successCount += calenderArray.count;
//        }
//    }
//
//}

#pragma mark 
//- (void)exportiCloudPhoto:(NSArray *)photoArray ExportPath:(NSString *)exPath withTotalCount:(int)totalCount withCurCount:(int)curCount {
//    if ([photoArray count]>0) {
//        for (IMBToiCloudPhotoEntity *entity in photoArray) {
//            float progress = (((float)curCount / totalCount*1.0) * 100) / _exportTracks.count + ((((float)_curCategory - 1)/_exportTracks.count))*100;
//            NSLog(@"icloud progress:%f",progress);
//            if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
//                [_transferDelegate transferProgress:progress];
//            }
//            if (_isStop) {
//                [[IMBTransferError singleton] addAnErrorWithErrorName:entity.photoName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
//                continue;
//            }
//            BOOL success = [_icloudManager downloadPhoto:entity withDownloadPath:exPath];
//            curCount++;
//            if (success) {
//                _successCount += 1;
//            }
//        }
//    }
//}

#pragma mark - 导出bookmark
//- (void)exportBookmark:(NSArray *)bookmarkArray bookmarkExportPath:(NSString *)exPath {
//    if (bookmarkArray != nil && bookmarkArray.count > 0) {
//        NSString *mode = nil;
//        mode = [_ipod.exportSetting getExportExtension:_ipod.exportSetting.safariType];
//        IMBBookMarkExport *bookmarkExport = [[IMBBookMarkExport alloc] initWithPath:exPath exportTracks:bookmarkArray withMode:mode withDelegate:_transferDelegate];
//        [bookmarkExport setIsAllExport:YES];
//        [bookmarkExport setPercent:((((float)_curCategory - 1)/_exportTracks.count))*100];
//        [bookmarkExport setTotalItem:(int)_exportTracks.count];
//        [bookmarkExport startTransfer];
//        _isStop = bookmarkExport.isStop;
//        [bookmarkExport release];
//        if (_isStop) {
//            _skipCount += bookmarkArray.count;
//        }else {
//            _successCount += bookmarkArray.count;
//        }
//    }
//}

#pragma mark - 导出Message
//- (void)exportMessage:(NSArray *)messageArray bookmarkExportPath:(NSString *)exPath {
//    if (messageArray != nil && messageArray.count > 0) {
//        NSString *mode = [_ipod.exportSetting getExportExtension:_ipod.exportSetting.messageType];
//        IMBMessageExport *messageExport = [[IMBMessageExport alloc] initWithPath:exPath exportTracks:messageArray withMode:mode withDelegate:_transferDelegate];
//        [messageExport setIsAllExport:YES];
//        [messageExport setPercent:((((float)_curCategory - 1)/_exportTracks.count))*100];
//        [messageExport setTotalItem:(int)_exportTracks.count];
//        [messageExport startTransfer];
//        _isStop = messageExport.isStop;
//        [messageExport release];
//        if (_isStop) {
//            _skipCount += messageArray.count;
//        }else {
//            _successCount += messageArray.count;
//        }
//    }
//}

#pragma mark - 导出SafariHistory
//- (void)exportSafariHistory:(NSArray *)historyArray bookmarkExportPath:(NSString *)exPath {
//    if (historyArray != nil && historyArray.count > 0) {
//        NSString *mode = [_ipod.exportSetting getExportExtension:_ipod.exportSetting.safariHistoryType];
//        IMBSafariHistoryExport *historyExport = [[IMBSafariHistoryExport alloc] initWithPath:exPath exportTracks:historyArray withMode:mode withDelegate:_transferDelegate];
//        [historyExport setIsAllExport:YES];
//        [historyExport setPercent:((((float)_curCategory - 1)/_exportTracks.count))*100];
//        [historyExport setTotalItem:(int)_exportTracks.count];
//        [historyExport startTransfer];
//        _isStop = historyExport.isStop;
//        [historyExport release];
//        if (_isStop) {
//            _skipCount += historyArray.count;
//        }else {
//            _successCount += historyArray.count;
//        }
//    }
//}

#pragma mark - 导出voiceMail
//- (void)exportVoiceMail:(NSArray *)voiceMailArray photoExportPath:(NSString *)exPath {
//    _currItemIndex = 0;
//    if (voiceMailArray != nil && voiceMailArray.count > 0) {
//        
//        for (IMBVoiceMailEntity *entity in voiceMailArray) {
//            if (_limitation.remainderCount == 0) {
//                break;
//            }
//            [_condition lock];
//            if (_isPause) {
//                [_condition wait];
//            }
//            [_condition unlock];
//            if (!_isStop) {
//                _currItemIndex ++;
//                if (![TempHelper stringIsNilOrEmpty:entity.path]) {
//                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),[entity.path lastPathComponent]];
//                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
//                        [_transferDelegate transferFile:msgStr];
//                    }
//                }
//                float progress = ((float)_currItemIndex / _totalItemCount) * 100 * ((float)_curCategory / _exportTracks.count);
//                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
//                    [_transferDelegate transferProgress:progress];
//                }
//                if ([_fileManager fileExistsAtPath:entity.path]) {
//                    NSString *destFilePath = [exPath stringByAppendingPathComponent:[entity.sender stringByAppendingPathExtension:@"amr"]];
//                    if ([_fileManager fileExistsAtPath:destFilePath]) {
//                        destFilePath = [TempHelper getFilePathAlias:destFilePath];
//                    }
//                    if ([_fileManager copyItemAtPath:entity.path toPath:destFilePath error:nil]) {
//                        _successCount += 1;
//                        [_limitation reduceRedmainderCount];
//                    }else {
//                        _failedCount += 1;
//                    }
//                } else {
//                    _failedCount += 1;
//                }
//            }else {
//                _skipCount ++;
//            }
//        }
//    }
//}

- (void)sendCopyProgress:(uint64_t)curSize {
    _curSize += curSize;
    if (_curSize > _totalSize) {
        _curSize = _totalSize;
    }
    float progress = (((float)_curSize / _totalSize) * 100) / _exportTracks.count + ((((float)_curCategory - 1) / _exportTracks.count)) * 100;
    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
        [_transferDelegate transferProgress:progress];
    }
}

- (void)caculateTransferTotalCount {
    for (IMBCategoryInfoModel *model in _exportTracks) {
        CategoryNodesEnum category = model.categoryNodes;
        if (category == Category_Music||category == Category_CloudMusic||category == Category_Movies||category == Category_TVShow||category == Category_MusicVideo||category == Category_PodCasts||category == Category_iTunesU||category == Category_Ringtone||category == Category_Audiobook||category == Category_HomeVideo) {
            NSArray *mediaArray = nil;
            if (category == Category_CloudMusic) {
                mediaArray = [_infoMation cloudTrackArray];
            }else {
                mediaArray = [_infoMation getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:category]];
            }
            _totalItemCount += mediaArray.count;
        }
        else if (category == Category_Playlist) {
            NSArray *playlistArray = _infoMation.playlists.playlistArray;
            if (playlistArray != nil && playlistArray.count > 0) {
                for (IMBPlaylist *pl in playlistArray) {
                    _totalItemCount += pl.tracks.count;
                }
            }
        }else if (category == Category_VoiceMemos) {
            NSArray *voicememosArray = [[_infoMation recording] recordingArray];
            _totalItemCount += voicememosArray.count;
        }
        else if (category == Category_Applications) {
            NSArray *appArray = [[_infoMation applicationManager] appEntityArray];
            _totalItemCount += appArray.count;
        }
        else if (category == Category_CameraRoll||category == Category_PhotoStream||category == Category_PhotoLibrary||category == Category_PhotoVideo||category == Category_Panoramas||category == Category_TimeLapse||category == Category_SlowMove||category == Category_LivePhoto||category == Category_Screenshot||category == Category_PhotoSelfies||category == Category_Location||category == Category_Favorite) {
            if (_icloudManager != nil) {
//                if (category == Category_PhotoVideo) {
//                    _totalItemCount += _icloudManager.photoVideoCount;
//                }
            }else {
                NSArray *photoArray = nil;
                if (category == Category_CameraRoll) {
                    photoArray = [_infoMation camerarollArray];
                }else if (category == Category_PhotoStream) {
                    photoArray = [_infoMation photostreamArray];
                }else if (category == Category_PhotoLibrary) {
                    photoArray = [_infoMation photolibraryArray];
                }else if (category == Category_PhotoVideo) {
                    photoArray = [_infoMation photovideoArray];
                }else if (category == Category_Panoramas) {
                    photoArray = [_infoMation panoramasArray];
                }else if (category == Category_TimeLapse) {
                    photoArray = [_infoMation timelapseArray];
                }else if (category == Category_SlowMove) {
                    photoArray = [_infoMation slowMoveArray];
                }else if (category == Category_LivePhoto) {
                    photoArray = [_infoMation livePhotoArray];
                }else if (category == Category_Screenshot) {
                    photoArray = [_infoMation screenshotArray];
                }else if (category == Category_PhotoSelfies) {
                    photoArray = [_infoMation photoSelfiesArray];
                }else if (category == Category_Location) {
                    photoArray = [_infoMation locationArray];
                }else if (category == Category_Favorite) {
                    photoArray = [_infoMation favoriteArray];
                }
                _totalItemCount += photoArray.count;
            }
        }
        else if (category == Category_MyAlbums||category == Category_PhotoShare||category == Category_ContinuousShooting) {
            NSArray *albumArr = nil;
            if (category == Category_MyAlbums) {
                albumArr = [_infoMation myAlbumsArray];
            }else if (category == Category_PhotoShare) {
                albumArr = [_infoMation photoshareArray];
            }else if (category == Category_ContinuousShooting) {
                albumArr = [_infoMation continuousShootingArray];
            }
            for (IMBPhotoEntity *entity in albumArr) {
                NSArray *singleArray = nil;
                if (category == Category_MyAlbums) {
                    singleArray = [_infoMation.albumsDic objectForKey:[NSNumber numberWithInt:entity.albumZpk]];
                } else if (category == Category_PhotoShare) {
                    singleArray = [_infoMation.shareAlbumDic objectForKey:[NSNumber numberWithInt:entity.albumZpk]];
                }else if (category == Category_ContinuousShooting) {
                    singleArray = [_infoMation.continuousShootingDic objectForKey:[NSNumber numberWithInt:entity.albumZpk]];
                }
                _totalItemCount += singleArray.count;
            }
        }
//        else if (category == Category_Notes) {
//            if (_icloudManager == nil) {
//                NSArray *noteArray = [_infoMation noteArray];
//                _totalItemCount += noteArray.count;
//            }else{
//                NSArray *noteArray = [_icloudManager noteArray];
//                _totalItemCount += noteArray.count;
//            }
//           
//        }
        else if (category == Category_Photo) {
//            NSArray *photoArray = [_icloudManager photoArray];
//            _totalItemCount += _icloudManager.photoCount;
        }
//        else if (category == Category_Contacts) {
//            if (_icloudManager == nil) {
//                NSArray *contactArray = [_infoMation contactArray];
//                _totalItemCount += contactArray.count;
//            }else{
//                NSArray *contactArray = [_icloudManager contactArray];
//                _totalItemCount += contactArray.count;
//            }
//           
//        }
//        else if (category == Category_Bookmarks) {
//            NSArray *bookmarkArray = [_infoMation bookmarkArray];
//            _totalItemCount += bookmarkArray.count;
//        }
//        else if (category == Category_Calendar) {
//            if (_icloudManager == nil) {
//                NSArray *calenderArray = [_infoMation calendarArray];
//                for (IMBCalendarEntity *entity in calenderArray) {
//                    _totalItemCount += entity.eventCalendatArray.count;
//                }
//            }else{
//                NSArray *calenderArray = [_icloudManager calendarArray];
//                _totalItemCount += calenderArray.count;
//            }
//        }
//        else if (category == Category_Reminder) {
//                NSArray *calenderArray = [_icloudManager reminderArray];
//                _totalItemCount += calenderArray.count;
//        }
        else if (category == Category_iBooks || category == Category_iBookCollections) {
            NSArray *bookArray = [_infoMation allBooksArray];
            _totalItemCount += bookArray.count;
        }
//        else if (category == Category_Message) {
//            NSArray *messageArray = [_infoMation messageArray];
//            _totalItemCount += messageArray.count;
//        }
//        else if (category == Category_Voicemail) {
//            NSArray *voicemailArray = [_infoMation voicemailArray];
//            _totalItemCount += voicemailArray.count;
//        }
//        else if (category == Category_SafariHistory) {
//            NSArray *safariArray = [_infoMation safariHistoryArray];
//            _totalItemCount += safariArray.count;
//        }
    }
}

@end
