//
//  IMBAirSyncImportBetweenDeviceTransfer.m
//  AnyTrans
//
//  Created by iMobie on 8/22/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBAirSyncImportBetweenDeviceTransfer.h"
#import "IMBDeviceInfo.h"
#import "IMBBookEntity.h"
#import "IMBNewTrack.h"
#import "IMBFileSystem.h"
#import "IMBPlaylistList.h"
#import "IMBIDGenerator.h"
#import "IMBCreatePhotoSyncPlist.h"
#import "IMBSyncPhotoData.h"
#import "IMBBetweenDeviceHandler.h"
#import "IMBCommonEnum.h"

@implementation IMBAirSyncImportBetweenDeviceTransfer
@synthesize infomationCount = _infomationCount;
@synthesize delegate = _delegate;
@synthesize driveItem = _driveItem;

- (void)setIsStop:(BOOL)isStop {
    if (_athSync != nil) {
        [_athSync setIsStop:isStop];
    }
    _isStop = isStop;
}

/**
 同步导入初始化方法
 srciPodKey ---- 原设备key；
 tariPodKey ---- 目的设备key；
 items ---- 需要传输的内容；
 photoAlbum ---- 导入到指定相册的实体，可以传nil；
 playlistID ---- 导入到指定playlist的id，不需要导入到playlist中传0；
 delegate ---- 进度返回代理
 */
- (id)initWithIPodkey:(NSString *)srciPodKey TarIPodKey:(NSString *)tariPodKey itemsToTransfer:(NSDictionary *)items photoAlbum:(IMBPhotoEntity *)photoAlbum playlistID:(long)playlistID delegate:(id)delegate {
    if (self = [super init]) {
        _transferDelegate = delegate;
        _ipod = [[[IMBDeviceConnection singleton] getiPodByKey:tariPodKey] retain];
        _srciPod = [[[IMBDeviceConnection singleton] getiPodByKey:srciPodKey] retain];
        _categoryNodesEnums = [[NSMutableArray alloc] init];
        _importFiles = [[NSMutableArray alloc] init];
        _transferItemsDic = [items retain];
        if (photoAlbum != nil) {
            _importPhotoAlbum = [photoAlbum retain];
        }
        [self getAllCategoryEnums];
        [[_ipod deviceInfo] availableFreeSpace];
        [_loghandle writeInfoLog:[NSString stringWithFormat:@"source ipod key %@", srciPodKey]];
    }
    return self;
}

- (void)dealloc
{
    if (_srciPod != nil) {
        [_srciPod release];
        _srciPod = nil;
    }
    [_categoryNodesEnums release],_categoryNodesEnums = nil;
    [_importFiles release],_importFiles = nil;
    [_transferItemsDic release],_transferItemsDic = nil;
    [_importPhotoAlbum release],_importPhotoAlbum = nil;
    [_athSync release],_athSync = nil;
    [super dealloc];
}

- (void)getAllCategoryEnums{
    //    _categoryNodesEnums = [[NSMutableArray alloc] init];
    if (_transferItemsDic.count > 0) {
        NSArray *array = [_transferItemsDic allKeys];
        if ([array containsObject:@"playlist"]) {
            NSArray *playlistArr = [_transferItemsDic objectForKey:@"playlist"];
            if (playlistArr.count > 0) {
                [_categoryNodesEnums addObject:[NSNumber numberWithInteger:Category_Playlist]];
            }
        }
        if ([array containsObject:@"media"]) {
            NSArray *trackArr = [_transferItemsDic objectForKey:@"media"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaType == %x",Ringtone];
            NSArray *compArr = [trackArr filteredArrayUsingPredicate:predicate];
            if (compArr.count > 0) {
                [_categoryNodesEnums addObject:[NSNumber numberWithInteger:Category_Ringtone]];
            }
            NSPredicate *musicPredicate = [NSPredicate predicateWithFormat:@"mediaType != %x && mediaType != %x && mediaType != %x && mediaType != %x && mediaType != %x",Ringtone,VoiceMemo,PDFBooks,Books,Photo];
            NSArray *musicArray =[trackArr filteredArrayUsingPredicate:musicPredicate];
            compArr = [musicArray filteredArrayUsingPredicate:musicPredicate];
            if (compArr.count > 0) {
                [_categoryNodesEnums addObject:[NSNumber numberWithInteger:Category_Music]];
            }
        }
        if ([array containsObject:@"media_book"]) {
            NSArray *bookArray = [_transferItemsDic objectForKey:@"media_book"];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"extension CONTAINS[cd] %@",@"pdf"];
            NSArray *results = [bookArray filteredArrayUsingPredicate:predicate];
            if (results.count > 0) {
                [_categoryNodesEnums addObject:[NSNumber numberWithInteger:Category_iBooks]];
            }
        }
        if ([array containsObject:@"media_voicememo"]) {
            [_categoryNodesEnums addObject:[NSNumber numberWithInteger:Category_VoiceMemos]];
        }
        if ([array containsObject:@"media_photo"]) {
            [_categoryNodesEnums addObject:[NSNumber numberWithInteger:Category_PhotoLibrary]];
        }
    }
}

- (void)startTransfer {
    _ipod.beingSynchronized = YES;
    [MediaHelper killiTunes];
    [_ipod startSync];
    [self prepareAllItemsAndCategories];
    _athSync = [[IMBATHSync alloc] initWithiPod:_srciPod desIpod:_ipod syncCtrType:SyncAddFile SyncNodes:_categoryNodesEnums];
    [_athSync setListener:self];
    [_athSync setIsStop:_isStop];
    [_athSync setCurrentThread:[NSThread currentThread]];
    //加上infomation的个数;
    _totalItemCount = [self totalItemscount] + _infomationCount;
    int allCount = _totalItemCount;
    if ([_importFiles count]>0) {
        if (_srciPod != nil && _ipod != nil) {
            [[_ipod tracks] freshFreeSpace];
            [[_srciPod tracks] freshFreeSpace];
            NSArray *allTracks = [self prepareAllTrack];
            if (allTracks.count > 0) {
                NSString *msgStr1 = @"Analyzing Completed";
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:msgStr1];
                }
                if (!_isStop) {
                    //如果只有app，则导入不需要开同步
                    if ([_categoryNodesEnums containsObject:@(Category_Applications)]&&[_categoryNodesEnums count] == 1) {
                        //                [self startTransferApps:allTracks];
                    }else{
                        //同步方式导入
                        //开始同步传输前，设置需要同步传输的对象
                        NSString *msgStr = @"Preparing Transfer...";
                        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                            [_transferDelegate transferFile:msgStr];
                        }
                        [_athSync setSyncTasks:allTracks];
                        msgStr = @"Preparing to sync, please wait...";
                        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                            [_transferDelegate transferFile:msgStr];
                        }
                        //开始同步
                        if ([_athSync createAirSyncService]) { //开启服务 并监听设备
                            if ([_athSync sendRequestSync]) { //发送RequestSync 命令
                                //创建plist cig
                                if ([_athSync createPlistAndCigSendDataSync]) {
                                    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
                                        [_transferDelegate transferPrepareFileEnd];
                                    }
                                    //开始拷贝文件
                                    [_athSync startCopyData];
                                    //等待同步结束
                                    [_athSync waitSyncFinished];
                                    //to do 开始核对文件是否传输成功
                                    //保存数据库
                                    [_ipod saveChanges];
                                }else{
                                    //直接结束
                                    [_athSync waitSyncFinished];
                                }
                                
                            }
                        }
                        //开始导入app
    //                [self startTransferApps:allTracks];
                    }
                }else {
                    for (IMBTrack *track in allTracks) {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:track.srcFilePath.lastPathComponent WithErrorReson:@"Skipped"];
                    }
                }
            }else {
                if (_infomationCount > 0) {
                    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
                        [_transferDelegate transferPrepareFileEnd];
                    }
                }
            }
        }
    }else {
        if (_infomationCount > 0) {
            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
                [_transferDelegate transferPrepareFileEnd];
            }
        }
    }
    
    if ([_delegate respondsToSelector:@selector(copyingNoneMediaData)]) {
        [_delegate copyingNoneMediaData];
    }
    
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:allCount];
    }
   dispatch_async(dispatch_get_main_queue(), ^{
       if (_successCount == 0) {
           _driveItem.fileSize = _totalSize;
           _driveItem.state = UploadStateError;
       }else {
           _driveItem.fileSize = _totalSize;
           _driveItem.state = UploadStateComplete;
       }
   });
    [_ipod endSync];
    _ipod.beingSynchronized = NO;
}

- (int)totalItemscount{
    int i = 0;
    for (NSArray *array in _importFiles) {
        if ([array isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)array;
            for (NSString *key in [dic allKeys]) {
                NSArray *keyArray = [dic objectForKey:key];
                i += keyArray.count;
                
            }
        }else{
            i += array.count;
            
        }
    }
    return i;
}

#pragma mark - 准备所有的数据
- (void)prepareAllItemsAndCategories{
    int count = 0;
    for (NSString *keyString in _transferItemsDic.allKeys) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];

        if ([keyString isEqualToString:@"media"]) {
            //处理各种Track
            NSArray *tracks = [_transferItemsDic objectForKey:@"media"];
            for (IMBTrack *track in tracks) {
                if (![track isKindOfClass:[IMBTrack class]]) {
                }
                else{
                    if (_isStop) {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:@"Skipped"];
                        continue;
                    }
                    switch (track.mediaType) {
                        case Ringtone:
//                            if (count>= _limitation.remainderCount) {
//                                break;
//                            }
                            [self addCategory:Category_Ringtone WithItem:track];
                            count++;
                            break;
                        default:
//                            if (count>= _limitation.remainderCount) {
//                                break;
//                            }
                            [self addCategory:Category_Music WithItem:track];
                            count++;
                            break;
                    }
                }
            }
        }
        else if([keyString isEqualToString:@"media_photo"]){
            NSArray *items = [_transferItemsDic objectForKey:@"media_photo"];
            for (id item in items) {
                if ([item isKindOfClass:[IMBPhotoEntity class]]) {
                    IMBPhotoEntity *photo = (IMBPhotoEntity *)item;
                    if (_isStop) {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:photo.photoName WithErrorReson:@"Skipped"];
                        continue;
                    }
                    if (photo.photoType == PhotoVideoType || photo.photoType == TimeLapseType|| photo.photoType == SlowMoveType) {
//                        if (count>= _limitation.remainderCount) {
//                            break;
//                        }
                        [self addCategory:Category_Movies WithItem:item];
                        count++;


                    }else{
//                        if (count>= _limitation.remainderCount) {
//                            break;
//                        }
                        [self addCategory:Category_PhotoLibrary WithItem:item];
                        count++;


                    }
                }
            }
        }
        else if([keyString isEqualToString:@"media_book"]){
            NSArray *items = [_transferItemsDic objectForKey:@"media_book"];
            for (id item in items) {
                if ([item isKindOfClass:[IMBBookEntity class]]){
                    IMBBookEntity *newItem = item;
                    if (_isStop) {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:newItem.bookName WithErrorReson:@"Skipped"];
                        continue;
                    }
                    if ([newItem.extension.lowercaseString isEqualToString:@"pdf"]) {
                        NSString *bookName = nil;
                        NSString *bookPath = nil;
                        [self generateiBookName:&bookName bookPath:&bookPath extenion:@"pdf"];
                        IMBNewTrack *newTrack = [[IMBNewTrack alloc] init];
                        [newTrack setArtist:@""];
                        [newTrack setAlbumArtist:@""];
                        [newTrack setTitle:newItem.fullPath.lastPathComponent];
                        [newTrack setFilePath:newItem.fullPath];
                        [newTrack setIsVideo:NO];
                        [newTrack setDBMediaType:PDFBooks];
                        [newTrack setBookFileName:bookName];
                        [newTrack setPackageHashID:newItem.packageHash];
                        newTrack.fileSize = (uint)[[_srciPod fileSystem] getFolderSize:[_srciPod.fileSystem.driveLetter stringByAppendingPathComponent:newItem.fullPath]];
//                        if (count>= _limitation.remainderCount) {
//                            break;
//                        }
                        [self addCategory:Category_iBooks WithItem:newTrack];
                        count++;
                        [newTrack release];
                    }else if ([newItem.extension.lowercaseString isEqualToString:@"epub"]){
                        IMBNewTrack *newTrack = [[[IMBNewTrack alloc] init] autorelease];
                        [newTrack setArtist:newItem.author];
                        [newTrack setGenre:newItem.genre];
                        [newTrack setAlbumArtist:newItem.album];
                        [newTrack setTitle:newItem.bookTitle];
                        [newTrack setFilePath:newItem.fullPath];
                        [newTrack setIsVideo:NO];
                        [newTrack setDBMediaType:Books];
                        [newTrack setPackageHashID:newItem.packageHash];
                        [newTrack setBookFileName:newItem.bookName];
                        [newTrack setPublisherUniqueID:newItem.publisherUniqueID];
                        newTrack.fileSize= newItem.size;
//                        if (count>= _limitation.remainderCount) {
//                            break;
//                        }
                        [self addCategory:Category_iBooks WithItem:newTrack];
                        count++;
                    }
                }
            }
        }
//        else if([keyString isEqualToString:@"media_voicememo"]){
//            NSArray *items = [_transferItemsDic objectForKey:@"media_voicememo"];
//            for (int i = 0; i < items.count; i++) {
//                id item = [items objectAtIndex:i];
//                if ([item isKindOfClass:[IMBRecordingEntry class]]){
//                    IMBRecordingEntry *recordingEntry = [items objectAtIndex:i];
//                    if (_isStop) {
//                        [[IMBTransferError singleton] addAnErrorWithErrorName:recordingEntry.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
//                        continue;
//                    }
//                    IMBNewTrack *newTrack = [[IMBNewTrack alloc] init];
//                    newTrack.isToDevice = YES;
//                    newTrack.fileSize = (uint)recordingEntry.sizeLength;
//                    newTrack.filePath = recordingEntry.path;
//                    newTrack.trackNumber = 0;
//                    newTrack.totalDiscCount = 0;
//                    newTrack.albumTrackCount = 0;
//                    newTrack.title = recordingEntry.name;
//                    newTrack.album = ![MediaHelper stringIsNilOrEmpty:newTrack.title] ? newTrack.title : @"Voice Memos";
//                    newTrack.artist = @"Voice Memos";
//                    newTrack.genre = @"Voice Memos";
//                    newTrack.albumArtist = @"Voice Memeos";
//                    newTrack.isVideo = false;
//                    newTrack.dBMediaType = VoiceMemo;
//                    newTrack.discNumber = 0;
//                    if (count>= _limitation.remainderCount) {
//                        break;
//                    }
//                    [self addCategory:Category_VoiceMemos WithItem:newTrack];
//                    count++;
//                    
//                }
//            }
        else if([keyString isEqualToString:@"playlist"]){
            NSArray *plistItem = [_transferItemsDic objectForKey:@"playlist"];
            for (id item in plistItem) {
                IMBPlaylist *playlist = item;
//                if (count>= _limitation.remainderCount) {
//                    break;
//                }
                [self addCategory:Category_Playlist WithItem:playlist];
                count++;
            }
        }
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSArray *arr in _importFiles) {
        if (arr.count == 0) {
            NSInteger index = [_importFiles indexOfObject:arr];
            [_categoryNodesEnums removeObjectAtIndex:index];
            [array addObject:arr];
        }
    }
    [_importFiles removeObjectsInArray:array];
}

- (void)addCategory:(CategoryNodesEnum)category WithItem:(id)item{
    if (![_categoryNodesEnums containsObject:[NSNumber numberWithInt:category]]) {
        [_categoryNodesEnums addObject:[NSNumber numberWithInt:category]];
        NSInteger index = [_categoryNodesEnums indexOfObject:[NSNumber numberWithInt:category]];
        if (_importFiles.count <= index) {
            for (int i = 0; i <= index; i++) {
                if(i < _importFiles.count){
                    continue;
                }
                else if(i >= _importFiles.count && i < index){
                    NSArray *array = [NSArray array];
                    [_importFiles addObject:array];
                    
                }
                else if (i == index) {
                    NSArray *array = [NSArray arrayWithObject:item];
                    [_importFiles addObject:array];
                }
            }
        }
        else{
            NSMutableArray *array = [[_importFiles objectAtIndex:index] mutableCopy];
            [array addObject:item];
            [_importFiles replaceObjectAtIndex:index withObject:array];
            [array release];
        }
    }
    else{
        NSMutableArray *array = nil;
        NSUInteger index = [_categoryNodesEnums indexOfObject:[NSNumber numberWithInt:category]];
        if (index != NSNotFound) {
            if (_importFiles.count <= index) {
                for (int i = 0; i <= index; i++) {
                    if(i < _importFiles.count){
                        continue;
                    }
                    else if(i >= _importFiles.count && i < index){
                        NSArray *array = [NSArray array];
                        [_importFiles addObject:array];
                        
                    }
                    else if (i == index) {
                        NSArray *array = [NSArray arrayWithObject:item];
                        [_importFiles addObject:array];
                    }
                }
            }
            else{
                array = [[_importFiles objectAtIndex:index] mutableCopy];
                [array addObject:item];
                [_importFiles replaceObjectAtIndex:index withObject:array];
                [array release];
            }
        }
        else{
            [_categoryNodesEnums removeObject:[NSNumber numberWithInt:category]];
        }
    }
}

#pragma mark - 准备主流程
- (NSMutableArray *)prepareAllTrack{
    if ([_importFiles count] == 0) {
        return nil;
    }
    [_loghandle writeInfoLog:@"prepareTrack in IMBAirSyncImportBetweenDeviceTransfer entered"];
    NSMutableArray *_compeletedTrackArray = [[[NSMutableArray alloc] init] autorelease];
    
    NSMutableArray *_srcDesPlsitPairArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _categoryNodesEnums.count; i++) {
        CategoryNodesEnum categoryEnum = (CategoryNodesEnum)[[_categoryNodesEnums objectAtIndex:i] integerValue];
//        BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//        if (isOutOfCount || _counter.isOutOfStorage) {
//            break;
//        }
        
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            break;
        }
        switch (categoryEnum) {
            case Category_Playlist:
            {
                NSArray *plistArr = [_importFiles objectAtIndex:i];
                for (IMBPlaylist *item in plistArr) {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        break;
                    }
                    //playlist为目的设备的playlist
                    @try {
                        IMBPlaylist *playlist1 = [_ipod.playlists getPlaylistByName:item.name];
                        if (playlist1 == nil) {
                            //如果item为系统默认的playlist
                            if (item.isMaster) {
                                for (IMBPlaylist *playlist in _ipod.playlistArray) {
                                    if (playlist.isMaster) {
                                        SrcDesPlistPair srcdesPair;
                                        srcdesPair.SrcPlist = item;
                                        srcdesPair.DesPlist = nil;
                                        NSValue *value = [NSValue valueWithBytes:&srcdesPair objCType:@encode(SrcDesPlistPair)];
                                        [_srcDesPlsitPairArray addObject:value];
                                    }
                                }
                            }else
                            {
                                IMBPlaylist *playlist = [_ipod.playlists addPlaylist:item.name];
                                if (playlist != nil) {
                                    SrcDesPlistPair srcdesPair;
                                    srcdesPair.SrcPlist = item;
                                    srcdesPair.DesPlist = playlist;
                                    NSValue *value = [NSValue valueWithBytes:&srcdesPair objCType:@encode(SrcDesPlistPair)];
                                    [_srcDesPlsitPairArray addObject:value];
                                }
                            }
                        }else
                        {
                            if (item.isMaster) {
                                for (IMBPlaylist *playlist in _ipod.playlistArray) {
                                    if (playlist.isMaster) {
                                        SrcDesPlistPair srcdesPair;
                                        srcdesPair.SrcPlist = item;
                                        srcdesPair.DesPlist = nil;
                                        NSValue *value = [NSValue valueWithBytes:&srcdesPair objCType:@encode(SrcDesPlistPair)];
                                        [_srcDesPlsitPairArray addObject:value];
                                    }
                                }
                            }else
                            {
                                SrcDesPlistPair srcdesPair;
                                srcdesPair.SrcPlist = item;
                                srcdesPair.DesPlist = playlist1;
                                NSValue *value = [NSValue valueWithBytes:&srcdesPair objCType:@encode(SrcDesPlistPair)];
                                [_srcDesPlsitPairArray addObject:value];
                            }
                        }
                        
                    }
                    @catch (NSException *exception) {
                        if ([exception.name isEqualToString:@"EX_Playlist_Already_Exists"]) {
                            [_loghandle writeInfoLog:@"This playlist already exists"];
                            continue;
                        }
                    }
                }
            }
                break;
            case Category_iBookCollections:
            case Category_iBooks:
            {
                NSArray *pdfArr = [self preparePdfBooksWithBookArray:[_importFiles objectAtIndex:i]];
                [_compeletedTrackArray addObjectsFromArray:pdfArr];
            }
                break;
            case Category_VoiceMemos:
            {
                NSArray *voiceMemoArr = [self prepareVoicememoWithArray:[_importFiles objectAtIndex:i]];
                [_compeletedTrackArray addObjectsFromArray:voiceMemoArr];
            }
                break;
            case Category_Applications:
                
                break;
            case Category_Movies:
            {
                 NSMutableArray *uuidArray = [self createImportImageInfo:[_importFiles objectAtIndex:i] Category:categoryEnum];
                NSArray *mediaArr = [self prepareMediaWithTrackArray:uuidArray categoryEnum:categoryEnum withPlaylistArray:nil];
                [_compeletedTrackArray addObjectsFromArray:mediaArr];
            }
                break;
                
            case Category_PhotoLibrary:
            {
                NSMutableArray *uuidArray = [self createImportImageInfo:[_importFiles objectAtIndex:i] Category:categoryEnum];
                [_compeletedTrackArray addObjectsFromArray:uuidArray];
            }
                break;
            default:
            {
                NSArray *mediaArr = [self prepareMediaWithTrackArray:[_importFiles objectAtIndex:i] categoryEnum:categoryEnum withPlaylistArray:_srcDesPlsitPairArray];
                [_compeletedTrackArray addObjectsFromArray:mediaArr];
            }
                break;
        }
    }
    [_srcDesPlsitPairArray release];
    _srcDesPlsitPairArray = nil;
    return _compeletedTrackArray;
}

#pragma mark - 准备媒体文件
//构建即将传输设备中的track,并添加到目的设备的plist中去。
//准备媒体文件
- (NSMutableArray *)prepareMediaWithTrackArray:(NSArray *)array categoryEnum:(CategoryNodesEnum)categoryEnum withPlaylistArray:playlistArr{
    if (array.count == 0){
        return nil;
    }
    
    NSMutableArray *completedTrackArray = [[[NSMutableArray alloc] init] autorelease];
    NSUInteger totalCount = array.count;
    [_loghandle writeInfoLog:[NSString stringWithFormat:@"totalcount:%lu",(unsigned long)totalCount]];
    for (int i = 0; i < totalCount; i++) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
         IMBTrack *track = [array objectAtIndex:i];
        if (!_isStop) {
            if (![TempHelper stringIsNilOrEmpty:track.title]) {
                NSString *msgStr = [NSString stringWithFormat:@"Analyzing %@",track.title];
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:msgStr];
                }
            }
            if (![self checkSupportMediaType:track.mediaType IsVideo:track.isVideo]) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:@"Your device is not supported to transfer this file."];
                _skipCount += 1;
                [_loghandle writeInfoLog:[NSString stringWithFormat:@"%@ isn't support this mediatype(%u)",_ipod.uniqueKey,track.mediaType]];
                continue;
            }
            if ([_srciPod.fileSystem fileExistsAtPath:[_srciPod.fileSystem.driveLetter stringByAppendingPathComponent:track.filePath]]) {
                BOOL isOutOfSpace = false;
                //创建新Track
                [track setDbID:[_ipod.idGenerator getNewDBID]];
                [self createTrack:0 completedTrackArray:completedTrackArray track:track isOutOfSpace:&isOutOfSpace withPlaylistArr:playlistArr];
//                _counter.prepareAnalysisSuccessCount ++;
//                BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                if (isOutOfCount) {
//                    break;
//                }
            }else{
                [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:@"The file does not exist in your iPhone or your backups"];
                _failedCount += 1;
                [_loghandle writeInfoLog:@"This item doesn't exist."];
            }
        }else{
            //线程中断
            [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:@"Skipped"];
            _failedCount += 1;
            [_loghandle writeInfoLog:@"thread break in IMBAirSyncImportBetweenDeviceTransfer prepareTrack"];
        }
    }
    [_loghandle writeInfoLog:@"prepareTrack in IMBAirSyncImportBetweenDeviceTransfer exsisted"];
    return completedTrackArray;
}

//检查目的设备支持的媒体类型
- (bool) checkSupportMediaType:(MediaTypeEnum) mediaType IsVideo:(bool)isVideo
{
    switch (mediaType)
    {
        case AudioAndVideo:
        case Audio:
            if (_ipod.deviceInfo.isSupportMusic) {
                return true;
            }
            else
            {
//                [_ignoreMediaTypeSet addObject:@"Music"];
                return false;
            }
        case Video:
            if (_ipod.deviceInfo.isSupportMovie)
            { return true; }
            else
            {
//                [_ignoreMediaTypeSet addObject:@"Movie"];
                return false;
            }
            
        case HomeVideo:
            if (_ipod.deviceInfo.isSupportHomeVideo)
            { return true; }
            else
            {
//                [_ignoreMediaTypeSet addObject:@"HomeVideo"];
                return false;
            }
            break;
        case Podcast:
            if (_ipod.deviceInfo.isSupportPodcast)
            { return true; }
            else
            {
//                [_ignoreMediaTypeSet addObject:@"Podcast"];
                return false;
            }
        case VideoPodcast:
            if (_ipod.deviceInfo.isSupportPodcast && _ipod.deviceInfo.isSupportVideo)
            { return true; }
            else
            {
//                [_ignoreMediaTypeSet addObject:@"VideoPodcast"];
                return false;
            }
        case Audiobook:
            if (_ipod.deviceInfo.isSupportAudioBook)
            { return true; }
            else
            {
//                [_ignoreMediaTypeSet addObject:@"AudioBook"];
                return false;
            }
        case MusicVideo:
            if (_ipod.deviceInfo.isSupportMV)
            { return true; }
            else
            {
//                [_ignoreMediaTypeSet addObject:@"MusicVideo"];
                return false;
            }
        case TVShow:
        case TVAndMusic:
            if (_ipod.deviceInfo.isSupportTVShow)
            { return true; }
            else
            {
//                [_ignoreMediaTypeSet addObject:@"TVShow"];
                return false;
            }
        case Ringtone:
            if (_ipod.deviceInfo.isSupportRingtone)
            { return true; }
            else
            {
//                [_ignoreMediaTypeSet addObject:@"Ringtone"];
                return false;
            }
        case iTunesU:
        case iTunesUGroup:
        case iTunesUVideo:
            if (isVideo)
            {
                if (_ipod.deviceInfo.isSupportiTunesU)
                { return true; }
                else
                {
//                    [_ignoreMediaTypeSet addObject:@"iTunesUVideo"];
                    return false;
                }
            }
            else
            {
                if (_ipod.deviceInfo.isSupportiTunesU)
                { return true; }
                else
                {
//                    [_ignoreMediaTypeSet addObject:@"iTunesU"];
                    return false;
                }
            }
        case Books:
        case PDFBooks:
            if (_ipod.deviceInfo.isSupportiBook)
            { return true; }
            else
            {
//                [_ignoreMediaTypeSet addObject:@"iBook"];
                return false;
            }
        case VoiceMemo:
            if (_ipod.deviceInfo.isSupportVoiceMemo) {
                return true;
            }
            else{
//                [_ignoreMediaTypeSet addObject:@"Voice Memo"];
                return false;
            }
            break;
        default:
            return false;
    }
}

#pragma mark - 设备中track的各种处理
- (BOOL)createTrack:(int*)successAnalyCount completedTrackArray:(NSMutableArray*)completeTrackArray track:(IMBTrack*)srcTrack isOutOfSpace:(BOOL*)isOutOfSpace withPlaylistArr:(NSArray *)playlistArr{
    [_loghandle writeInfoLog:[NSString stringWithFormat:@"createTrack in IMBAirSyncImportBetweenDeviceTransfer trackname:%@",srcTrack.title]];
    IMBNewTrack *newTrack = [[MediaHelper createTrackByIMBTrack:srcTrack containRatingAndPlayCount:NO] retain];
    //如果是ios设备，则获取封面
    [self getArtworkFromTrack:srcTrack newTrack:newTrack];
    
    IMBTrack *track = nil;
    @try {
        IMBTracklist *trackList = _ipod.tracks;
        track = [trackList addTrack:newTrack copyToDevice:NO calcuTotalSize:_totalSize WithSrciPod:_srciPod];
        [track setDeviceWorkPath:newTrack.artworkFile];
    }
    @catch (NSException *exception) {
        [_loghandle writeInfoLog:[NSString stringWithFormat:@"createTrack in IMBAirSyncImportBetweenDeviceTransfer error in addTrack exception:%@",exception.description]];
        
        if ([[exception name] isEqualToString:@"EX_OutOfDiskSpace"]) {
            NSString *msgStr = @"Transfer failed due to insufficient free space on your device.";
            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transferDelegate transferFile:msgStr];
            }
            [newTrack release];
            return NO;
        } else if ([[exception name] isEqualToString:@"EX_Track_Already_Exists"]) {
            // 在这里主要是如果检测到Track下面存在，就把track加人Playlist里面
            if (![TempHelper stringIsNilOrEmpty:[newTrack title]]) {
                NSString *msgStr = [NSString stringWithFormat:@"This %@ already exists.",[newTrack title]];
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:msgStr];
                }
            }
            [newTrack release];
            return YES;
            
        } else {
            NSString *msgStr = @"Analyzing Failed";
            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transferDelegate transferFile:msgStr];
            }
            [newTrack release];
            return YES;
        }
    }
    [newTrack release];
    
    if (track != nil) {
        // 这里主要是对Track导入Playlist中的处理
        if (playlistArr != nil && playlistArr.count > 0) {
            [self addTrackToPlaylist:track withSrcTrack:srcTrack withPlaylistArr:playlistArr];
        }
        [completeTrackArray addObject:track];
        _totalSize += track.fileSize;
        _totalItemCount += 1;
    }
    return YES;
}

//从track中获取artwork.
- (void)getArtworkFromTrack:(IMBTrack *)srcTrack newTrack:(IMBNewTrack *)newTrack {
    @try {
        // 添加Purchase的artwork的处理
        [_loghandle writeInfoLog:[NSString stringWithFormat:@"getArtworkFromTrack in IMBAirSyncImportBetweenDeviceTransfer entered"]];
        
        if (![MediaHelper stringIsNilOrEmpty:[srcTrack purchasesArtworkPath]]) {
            if ([[_srciPod fileSystem] fileExistsAtPath:[_srciPod.fileSystem.driveLetter stringByAppendingPathComponent:[srcTrack purchasesArtworkPath]]]) {
                NSString *localTempPath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:[DateHelper getTempNameByDateTime]];
                [_srciPod.fileSystem copyRemoteFile:[_srciPod.fileSystem.driveLetter stringByAppendingPathComponent:[srcTrack purchasesArtworkPath]] toLocalFile:localTempPath];
                if ([_fileManager fileExistsAtPath:localTempPath]) {
                    [newTrack setArtworkFile:localTempPath];
                }
            }
        }
        
        //1.判断原始的Track里面是否有Artwork.
        //2.导出Artwork到临时文件。
        //  1.如果是IOS设备，通过MediaTool拷贝meta到本地,然后用Taglib转换。
        //  2.如果是Pod设备，直接用Taglib进行转换。
        if ([srcTrack hasArtwork] > 0) {
            if ([[_srciPod deviceInfo] isIOSDevice]) {
                NSString *localTempPath = [[[TempHelper getAppTempPath] stringByAppendingPathComponent:
                                            [NSString stringWithFormat:@"%lld", [srcTrack dbID]]]
                                           stringByAppendingPathExtension:[[srcTrack filePath] pathExtension]];
                //TODO:仔细阅读一下此处
                //废弃，此处不用拆分
                //                [IMBMediaFileWrapper wrapperFileToLocal:[_srciPod.fileSystem afcMediaDirectory] remoteFilePath:[[_desiPod.fileSystem driveLetter] stringByAppendingPathComponent:[srcTrack filePath]] toLoaclFilePath:localTempPath];
                
                if (srcTrack.artwork.count > 0) {
                    id artworkEntity = [srcTrack.artwork objectAtIndex:0];
                    if ([artworkEntity isKindOfClass:[IMBArtworkEntity class]]) {
                        IMBArtworkEntity *newArtworkEntity = artworkEntity;
                        if(newArtworkEntity.filePath.length > 0)
                        {
                            [newTrack setArtworkFile:newArtworkEntity.filePath];
                        }
                    }
                    @try {
                        [_fileManager removeItemAtPath:localTempPath error:nil];
                    }
                    @catch (NSException *exception) {
                    }
                }
            } else if (![_srciPod.deviceInfo isIOSDevice]) {
                //非ios设备直接读取磁盘数据
                [newTrack setArtworkFile:[MediaHelper getMediaArtwork:[_srciPod.fileSystem.driveLetter stringByAppendingPathComponent:[srcTrack filePath]]]];
            }
        }
    }
    @catch (NSException *exception) {
        [newTrack setArtworkFile:@""];
        [_loghandle writeInfoLog:[NSString stringWithFormat:@"getArtworkFromTrack in IMBAirSyncImportBetweenDeviceTransfer error:%@",exception.description]];
    }
    [_loghandle writeInfoLog:[NSString stringWithFormat:@"getArtworkFromTrack in IMBAirSyncImportBetweenDeviceTransfer existed"]];
}

- (void) addTrackToPlaylist:(IMBTrack*)track withSrcTrack:(id)srcTrack withPlaylistArr:(NSArray *)playlistArr{
    [_loghandle writeInfoLog:[NSString stringWithFormat:@"addTrackToPlaylist in IMBAirSyncImportBetweenDeviceTransfer entered"]];
    
    //1.过滤出包含原Track的playlist
    if (playlistArr != nil && playlistArr.count > 0) {
        for (NSValue *value in playlistArr) {
            SrcDesPlistPair srcDesPair;
            [value getValue:&srcDesPair];
            IMBPlaylist *srcplayList = srcDesPair.SrcPlist;
            IMBPlaylist *desplayList = srcDesPair.DesPlist;
            NSLog(@"%@",desplayList.name);
            if (srcplayList.betweenDeviceCopyableTrackList != nil && srcplayList.betweenDeviceCopyableTrackList.count > 0) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@ && artist == %@ && genre == %@",[srcTrack title],[srcTrack artist],[srcTrack genre]];
                NSArray *findTracks = [srcplayList.betweenDeviceCopyableTrackList filteredArrayUsingPredicate:predicate];
                if (findTracks.count > 0) {
                    [desplayList addTrack:track];
                }
            }
        }
    }
    
    [_loghandle writeInfoLog:[NSString stringWithFormat:@"addTrackToPlaylist in IMBAirSyncImportBetweenDeviceTransfer existed"]];
}

#pragma mark - 准备书籍(PDF)
//设备间book导入流程为pdf文件 直接拷贝文件，然后修改plist文件
//准备ibook文件
- (NSMutableArray *)preparePdfBooksWithBookArray:(NSArray *)array{
    NSMutableArray *completedMutableBooks = [self prepareNewTracksWithArray:array categoryEnum:Category_iBooks];
    return completedMutableBooks;
}

- (void) generateiBookName:(NSString**)bookName bookPath:(NSString**)bookPath extenion:(NSString*)extenion {
    NSString *randomName = [[MediaHelper getRandomBookName] stringByAppendingPathExtension:extenion];
    NSString *filePath = [[[[_srciPod fileSystem] driveLetter] stringByAppendingPathComponent:@"Books"] stringByAppendingPathComponent:randomName];
    if (![[_srciPod fileSystem] fileExistsAtPath:filePath]) {
        *bookName = randomName;
        *bookPath = filePath;
    } else {
        [self generateiBookName:&*bookName bookPath:&*bookPath extenion:extenion];
    }
}

- (BOOL)importBookToDevice:(IMBTrack *)completedBook srcPath:(NSString *)srcPath desPath:(NSString *)despath{
    [_loghandle writeInfoLog:@"importBookToDevice in importBooksImport entered"];
    BOOL reslut = NO;
    if (completedBook != nil) {
        if (!_isStop) {
            @try {
                NSString *filePathInDevice = nil;
                if (completedBook.mediaType == PDFBooks) {
                    reslut = [[_ipod fileSystem] copyFileBetweenDevice:srcPath sourDriverLetter:_srciPod.fileSystem.driveLetter targFileName:despath targDriverLetter:_ipod.fileSystem.driveLetter sourDevice:_srciPod];
                    filePathInDevice = [despath lastPathComponent];
                    if ([filePathInDevice rangeOfString:@".pdf"].location == NSNotFound) {
                        filePathInDevice = [filePathInDevice stringByAppendingString:@".pdf"];
                    }
                }else{
                    if ([IMBBaseTransfer checkIosIsHighVersion:_ipod]) {
                        [self copyEpubBookWithPath:completedBook.srcFilePath toDevicePath:despath tarPod:_ipod];
                        reslut = YES;
                    }
                    else{
                        reslut = [self copyLocalFile:completedBook.srcFilePath toRemoteFile:despath];
                    }
                    filePathInDevice = [despath lastPathComponent];
                    if ([filePathInDevice rangeOfString:@".epub"].location == NSNotFound) {
                        filePathInDevice = [filePathInDevice stringByAppendingString:@".epub"];
                    }
                }
                completedBook.filePath = [completedBook.filePath stringByReplacingOccurrencesOfString:completedBook.filePath.lastPathComponent withString:filePathInDevice];
                [[_ipod tracks] removeTrack:completedBook];
                [completedBook setFileIsExist:YES];
            }
            @catch (NSException *exception) {
                NSLog(@"exception:%@",exception.description);
            }
        }
        else{
            [_loghandle writeInfoLog:@"importBookToDevice in importBooksImport exsited"];
        }
    }
    return reslut;
}

- (void)copyEpubBookWithPath:(NSString*)localPath toDevicePath:(NSString*)remotingPath tarPod:(IMBiPod *)taripod{
    if (![taripod.fileSystem fileExistsAtPath:remotingPath]) {
        [taripod.fileSystem mkDir:remotingPath];
    }
    NSArray *tempArray = [_srciPod.fileSystem getItemInDirectory:localPath];
    if (tempArray != nil && [tempArray count] > 0) {
        NSString *scrPath = @"";
        for (AMFileEntity *item in tempArray) {
            if (_isStop) {
                break;
            }
            scrPath = [localPath stringByAppendingPathComponent:item.Name];
            NSString *remotingFilePath = [remotingPath stringByAppendingPathComponent:item.Name];
            if (item.FileType == AMDirectory) {
                [self copyEpubBookWithPath:scrPath toDevicePath:remotingFilePath tarPod:taripod];
            }else{
                [[taripod fileSystem] copyFileBetweenDevice:scrPath sourDriverLetter:_srciPod.fileSystem.driveLetter targFileName:remotingFilePath targDriverLetter:taripod.fileSystem.driveLetter sourDevice:_srciPod];
            }
        }
    }
}


#pragma mark - 准备VoiceMemo中的各种处理
- (NSMutableArray *)prepareVoicememoWithArray:(NSArray *)voicememoArr{
    NSMutableArray *nvoiceMemoArr = [self prepareNewTracksWithArray:voicememoArr categoryEnum:Category_VoiceMemos];
    return nvoiceMemoArr;
}

#pragma mark - 准备所有的NewTrack数据(包括pdf和voicememo)
- (NSMutableArray *)prepareNewTracksWithArray:(NSArray *)array categoryEnum:(CategoryNodesEnum)category{
    MediaTypeEnum mediaType = Audio;
    switch (category) {
        case Category_VoiceMemos:
            mediaType = VoiceMemo;
            break;
        case Category_iBookCollections:
        case Category_iBooks:
            mediaType = PDFBooks;
            break;
            
        default:
            break;
    }
    if (mediaType == Audio || array.count == 0) {
        return nil;
    }
    
    if(![self checkSupportMediaType:mediaType IsVideo:false]){
//        _transResult.mediaIgnoreCount += array.count;
//        [_transResult recordMediaResult:@"Books ignored" resultStatus:TransNotSupport messageID:@"IMBTransResult_SuccessAndSkip_Content3"];
        [_loghandle writeInfoLog:[NSString stringWithFormat:@"%@ isn't support this mediatype(%u)",_ipod.uniqueKey,mediaType]];
        return nil;
    }
    [_loghandle writeInfoLog:[NSString stringWithFormat:@"parepareTrack in IMBAirSyncImportBetweenDeviceTransfer entered"]];
    
    NSMutableArray *completedBookArray = [[NSMutableArray alloc] init];
    if (array != nil && [array count] > 0) {
        BOOL isOutOfSpace = NO;
        if (array != nil && [array count] > 0) {
            for (IMBNewTrack *newTrack in array) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (!_isStop){
                    if (![TempHelper stringIsNilOrEmpty:newTrack.title]) {
                        NSString *msgStr = [NSString stringWithFormat:@"Analyzing %@",newTrack.title];
                        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                            [_transferDelegate transferFile:msgStr];
                        }
                    }
//                    NSMutableArray *exsitedFilePathArr = [NSMutableArray array];
                    if ([_srciPod.fileSystem fileExistsAtPath:[_srciPod.fileSystem.driveLetter stringByAppendingPathComponent:newTrack.filePath]]){
                        IMBTrack *track = nil;
                        @try {
                            track = [[_ipod tracks] addTrack:newTrack copyToDevice:NO calcuTotalSize:_totalSize WithSrciPod:_srciPod];
                            if (track.mediaType == Books) {
                                track.exactFolderIfEpubBook = track.srcFilePath;
                                track.uuid = newTrack.publisherUniqueID;
                                if (track.uuid.length == 0) {
                                    track.uuid = [IMBAirSyncImportBetweenDeviceTransfer createGUID];
                                }
                                [track setTitle:newTrack.title];
                                [track setArtist:newTrack.artist];
                                [track setAlbum:newTrack.album];
                                [track setGenre:newTrack.genre];
                            }
//                            int64_t dbID = track.dbID;
//                            while ([exsitedFilePathArr containsObject:track.filePath] || maxID == dbID) {
//                                [[_desiPod tracks] removeTrack:track];
//                                [self minusFolderSizeFormTotalSize:newTrack.filePath];
//                                track = [[_srciPod tracks] addTrack:newTrack copyToDevice:NO cacuTotalSize:_transTotalSize];
//                            }
//                            maxID = track.dbID;
                            if(track != nil){
//                                [exsitedFilePathArr addObject:track.filePath];
                                [completedBookArray addObject:track];
                                _totalSize += track.fileSize;
                                _totalItemCount += 1;
                            }
                        }
                        @catch (NSException *exception) {
                            [_loghandle writeInfoLog:[NSString stringWithFormat:@"parepareTrack in importBooksImport error:%@",exception.description]];
                            if ([[exception name] isEqualToString:@"EX_OutOfDiskSpace"]) {
                                NSString *msgStr = @"Transfer failed due to insufficient free space on your device.";
                                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                    [_transferDelegate transferFile:msgStr];
                                }
                                isOutOfSpace = YES;
                                break;
                            } else if ([[exception name] isEqualToString:@"EX_Track_Already_Exists"]) {
                                _failedCount += 1;
                                if (![TempHelper stringIsNilOrEmpty:newTrack.title]) {
                                    NSString *msgStr = [NSString stringWithFormat:@"This %@ already exists.",newTrack.title];
                                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                    [_transferDelegate transferFile:msgStr];
                                }
                            }
                                continue;
                            } else {
                                _failedCount += 1;
                                NSString *msgStr = @"Analyzing Failed";
                                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                    [_transferDelegate transferFile:msgStr];
                                }
                                continue;
                            }
                        }
//                        BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                        if (isOutOfCount) {
//                            break;
//                        }
                    }
                    else{
                        _failedCount += 1;
                        [_loghandle writeInfoLog:@"This item doesn't exist.(book/voicemomes)"];
                    }
                }
                else{
                    //线程中断
                    _skipCount += 1;
                    [_loghandle writeInfoLog:@"thread break in IMBAbstractBetweenDevices prepareTrack"];
                }
            }
        }
        [_loghandle writeInfoLog:@"prepareTrack in IMBAbstractBetweenDevices exsisted"];
        return completedBookArray;
        
    }
    return [completedBookArray autorelease];
}

+ (NSString *)createGUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}


#pragma mark - photo处理方法 创建photo的track对象
//创建导入图片的Info
- (NSMutableArray *)createImportImageInfo:(NSArray *)array  Category:(CategoryNodesEnum)category{
    //得到最大photo的uuid
    IMBCreatePhotoSyncPlist *cp = [[IMBCreatePhotoSyncPlist alloc] initWithiPod:_ipod];
    NSData *maxUUID = [cp getMaxZ_PKUUID];
    Byte bit[maxUUID.length];
    [maxUUID getBytes:bit length:maxUUID.length];
    int int16last = bit[maxUUID.length - 1]&0xff;
    int int16 = bit[maxUUID.length - 2]&0xff;
    [cp release];
    
    NSMutableArray *uuidArray = [[[NSMutableArray alloc] init] autorelease];
    //得到uuid形如00000000-0000-0000-0000-000000000000，并依次递增
    for (int idx=0; idx<array.count; idx++) {
        @autoreleasepool {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop == NO) {
                IMBPhotoEntity *pe = [array objectAtIndex:idx];
                if (![TempHelper stringIsNilOrEmpty:pe.photoName]) {
                    NSString *msgStr = [NSString stringWithFormat:@"Analyzing %@",pe.photoName];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
                
                PrepareStatus status = [self checkFileSizeIsOutOfSpace:pe.photoSize fileName:pe.photoName];
                if (status == OutOfSpace) {
                    NSString *msgStr = @"Transfer failed due to insufficient free space on your device.";
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                    break;
                }
                else if(status == AlreadyExisted){
                    if (![TempHelper stringIsNilOrEmpty:pe.photoName]) {
                        NSString *msgStr = [NSString stringWithFormat:@"This %@ already exists.",pe.photoName];
                        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                            [_transferDelegate transferFile:msgStr];
                        }
                    }
                    continue;
                }
                else if(status == FileErrorUnknown){
                    NSString *msgStr = @"Analyzing Failed";
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                    continue;
                }
                
                IMBSyncPhotoData *pd = [[IMBSyncPhotoData alloc] init];
                int16last += 1;
                if (int16last == 0x100) {
                    int16 = int16 + 1;
                    int16last = 0x00;
                }
                NSString *hexStr = @"";
                for (int idu=0; idu<maxUUID.length-2; idu++) {
                    NSString *newHexStr = [NSString stringWithFormat:@"%x",bit[idu]&0xff];
                    if ([newHexStr length] == 1) {
                        hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
                    }else{
                        hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
                    }
                }
                NSString *newStr = [NSString stringWithFormat:@"%x",int16];
                if ([newStr length] == 1) {
                    hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newStr];
                }else{
                    hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newStr];
                }
                NSString *newStr1 = [NSString stringWithFormat:@"%x",int16last];
                if ([newStr1 length] == 1) {
                    hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newStr1];
                }else{
                    hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newStr1];
                }
                NSString *uuid = [MediaHelper createPhotoUUID:hexStr];
                pd.photoUUID = uuid;
                pd.photoName = pe.allPath;
                
                //按当前时间导入图片
                NSDate *now = [NSDate date];
                uint64 timeStamp = [DateHelper getTimeStampFromDate:now];
                pd.photoDate = timeStamp - array.count - 10 + idx;
                
                //            //按图片创建时间导入设备
                //            NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[IMBHelper fileCreateTimeAtPath:path]];
                //            pd.photoDate = [IMBHelper getTimeStampFromDate:date] + idx;
                //            [date release];
                
                NSString *fileName = nil;
                fileName = [[pd.photoName pathComponents] lastObject];
                IMBTrack *tracks = [[IMBTrack alloc] init];
                [tracks setDateAdded:(uint)pd.photoDate];
                [tracks setPhotoFilePath:pd.photoName];
                [tracks setSrcFilePath:pd.photoName];
                [tracks setFilePath:pd.photoName];
                [tracks setFileSize:(uint)pe.photoSize];
                if (category == Category_PhotoLibrary) {
                    [tracks setDbID:pd.photoUUID];
                    [tracks setUuid:pd.photoUUID];
                    [tracks setMediaType:Photo];
                    _totalItemCount += 1;
                }else{
                    [tracks setMediaType:Video];
                }
                [tracks setTitle:fileName];
                _totalSize += tracks.fileSize;
                [uuidArray addObject:tracks];
                [tracks release];
                [pd release];
                
//                _progressCounter.prepareAnalysisSuccessCount ++;
//                // ToDo 判断未注册的设备是否允许还能继续导入
//                BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                if (isOutOfCount) {
//                    break;
//                }
                
            } else {
//                _ignoreCount += 1;
//                fileName = [[pd.photoName pathComponents] lastObject];
//                [_transResult setMediaIgnoreCount:([_transResult mediaIgnoreCount] + 1)];
//                [_transResult recordMediaResult:fileName resultStatus:TransFailed messageID:@"IMBTransResult_SuccessAndSkip_Content3"];
            }
        }
    }
    return uuidArray;
}

- (PrepareStatus)checkFileSizeIsOutOfSpace:(long long)size fileName:(NSString *)fileName {
    PrepareStatus status = Normal;
    @try {
        [[_ipod tracks] setFreespace:[_ipod tracks].freespace - size];
        if ([_ipod tracks].freespace <= 10000000) {//设备空间小于10M
            NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:[[_ipod deviceHandle] deviceName], @"DeviceName", nil];
            @throw [NSException exceptionWithName:@"EX_OutOfDiskSpace" reason:@"Transfer failed due to insufficient free space on your device."  userInfo:userDic];
        }
    }
    @catch (NSException *exception) {
        [_loghandle writeInfoLog:[NSString stringWithFormat:@"parepareTrack in importBooksImport error:%@",exception.description]];
        
        if ([[exception name] isEqualToString:@"EX_OutOfDiskSpace"]) {
            status = OutOfSpace;
        } else if ([[exception name] isEqualToString:@"EX_Track_Already_Exists"]) {
            status = AlreadyExisted;
        } else {
            status = FileErrorUnknown;
        }
    }
    return status;
}

#pragma mark - ATHCopyFileToDeviceListener
- (BOOL)copyFileFromSrcPath:(NSString *)srcPath ToDesPath:(NSString *)desPath WithTrack:(IMBTrack *)track WithAssetID:(NSString *)assetID {
    BOOL reslut = NO;
    _currItemIndex ++;
    if (_currItemIndex > _totalItemCount) {
        _currItemIndex = _totalItemCount;
    }
    float progress = ((float)_currItemIndex / _totalItemCount) * 100;
    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
        [_transferDelegate transferProgress:progress];
    }
    if (_ipod != nil) {
        if (![TempHelper stringIsNilOrEmpty:srcPath]) {
            NSString *msgStr1 = [NSString stringWithFormat:@"Copying %@...",[srcPath lastPathComponent]];
            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transferDelegate transferFile:msgStr1];
            }
        }
        NSString *finalPath = desPath;
        if (track.mediaType == VoiceMemo) {
            finalPath = desPath;
            [_loghandle writeInfoLog:[NSString stringWithFormat:@"Transfering %@ (IMBAirSyncImportBetweenDeviceTransfer)", finalPath]];
            reslut = [_ipod.fileSystem copyFileBetweenDevice:srcPath sourDriverLetter:_srciPod.fileSystem.driveLetter targFileName:finalPath targDriverLetter:_ipod.fileSystem.driveLetter sourDevice:_srciPod];
            track.filePath = [NSString stringWithFormat:@"Recordings/%@.m4a",[desPath lastPathComponent]];
            [track setFileIsExist:YES];
        }
        else if(track.mediaType == Books || track.mediaType == PDFBooks){
            if (_ipod != nil) {
                [_loghandle writeInfoLog:[NSString stringWithFormat:@"Transfering %@ (IMBAirSyncImportBetweenDeviceTransfer)", srcPath]];
                reslut = [self importBookToDevice:track srcPath:srcPath desPath:desPath];
                [track setFileIsExist:YES];
            }
        }
        else{
            [_loghandle writeInfoLog:[NSString stringWithFormat:@"Transfering %@ (IMBAirSyncImportBetweenDeviceTransfer)", srcPath]];
            reslut = [_ipod.fileSystem copyFileBetweenDevice:srcPath sourDriverLetter:_srciPod.fileSystem.driveLetter targFileName:finalPath targDriverLetter:_ipod.fileSystem.driveLetter sourDevice:_srciPod];
            [track setFileIsExist:YES];
        }
    }
    if (reslut) {
        _successCount ++;
    }
    return reslut;
}

- (BOOL)copyDataFromSrcPath:(NSData *)srcData ToDesPath:(NSString *)desPath WithTrack:(IMBTrack *)track WithAssetID:(NSString *)assetID {
    BOOL reslut = NO;
    _currItemIndex ++;
    if (_currItemIndex > _totalItemCount) {
        _currItemIndex = _totalItemCount;
    }
    float progress = ((float)_currItemIndex / _totalItemCount) * 100;
    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
        [_transferDelegate transferProgress:progress];
    }
    if (_ipod != nil && _srciPod != nil) {
        if (![TempHelper stringIsNilOrEmpty:track.title]) {
            NSString *msgStr = [NSString stringWithFormat:@"Copying %@...",track.title];
            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transferDelegate transferFile:msgStr];
            }
        }
        if (srcData != nil) {
            [_loghandle writeInfoLog:[NSString stringWithFormat:@"Transfering %@ (IMBAirSyncImportBetweenDeviceTransfer)", track.photoFilePath]];
            
            reslut = [_ipod.fileSystem copyDataToFile:srcData toRemoteFile:desPath];
            [track setFileIsExist:YES];
        }
    }
    if (reslut) {
        _successCount ++;
        _currentDriveItem.currentSize = _successCount;
        _currentDriveItem.progress = (double)_successCount/_currentDriveItem.speed *100;
    }
    return reslut;
}

- (void) completedCopyTrack:(IMBTrack*)track {
//    [_limitation reduceRedmainderCount];
//    if (_desiPod != nil && _srciPod != nil) {
//        NSString *desPath = [_desiPod.fileSystem.driveLetter stringByAppendingPathComponent:[track filePath]];
//        if ([_desiPod.fileSystem fileExistsAtPath:desPath]) {
//            if (track.mediaType == PDFBooks) {
//                NSString *bookPathInDevice = [_desiPod.fileSystem.driveLetter stringByAppendingPathComponent:[[track filePath] lastPathComponent]];
//                if ([_desiPod.fileSystem fileExistsAtPath:bookPathInDevice]) {
//                    [_desiPod.fileSystem unlink:bookPathInDevice];
//                }
//            }
//            [logHandle writeInfoLog:[NSString stringWithFormat:@"File %lld exsit status is True (IMBAirSyncImportBetweenDeviceTransfer)",track.dbID]];
//        } else  {
    _driveItem.fileSize = _totalSize;
    _driveItem.state = UploadStateComplete;
            [_loghandle writeInfoLog:[NSString stringWithFormat:@"File %lld exsit status is False (IMBAirSyncImportBetweenDeviceTransfer)",track.dbID]];
//        }
//        if ([_succeedTracks containsObject:track]) {
//            [track setFileIsExist:YES];
//        }
//        else{
//            [track setFileIsExist:NO];
//        }
//        [_mediaSet addObject:[NSNumber numberWithInt:track.mediaType]];
//    }

}

- (void)sendCopyProgress:(uint64_t)curSize {
    _currItemIndex ++;
    if (_currItemIndex > _totalItemCount) {
        _currItemIndex = _totalItemCount;
    }
    float progress = ((float)_currItemIndex / _totalItemCount) * 100;
    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
        [_transferDelegate transferProgress:progress];
    }
}

- (void)copyWordProgress:(NSString *)workStr {
    if (![TempHelper stringIsNilOrEmpty:workStr]) {
        NSString *msgStr = [NSString stringWithFormat:@"Copying %@...",workStr];
        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
            [_transferDelegate transferFile:msgStr];
        }
    }
}

- (void)setSuccessCount {
    _successCount ++;
}

@end
