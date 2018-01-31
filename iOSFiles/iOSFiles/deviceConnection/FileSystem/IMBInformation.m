//
//  IMBInformation.m
//  iMobieTrans
//
//  Created by iMobie on 14-8-7.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBInformation.h"
#import "IMBInformationManager.h"

#import "IMBPlayCounts.h"
//#import "IMBISyncPlaylistToCDB.h"
#import "IMBDeviceInfo.h"
#import "NSString+Category.h"
#import "IMBSession.h"
#import "TempHelper.h"

//#import "IMBSyncPlaylistFactory.h"
#import "IMBBookCollection.h"
//#import "RegexKitLite.h"
#import "IMBBookEntity.h"


@implementation IMBInformation

//@synthesize voicemailArray = _voicemailArray;
@synthesize ipod = _ipod;
@synthesize recordDic = _recordDic;
//@synthesize noteArray = _noteArray;
//@synthesize messageArray = _messageArray;
//@synthesize calendarArray = _calendarArray;
//@synthesize bookmarkArray = _bookmarkArray;
//@synthesize phoneArray = _phoneArray;
//@synthesize contactArray = _contactArray;
@synthesize camerarollArray = _camerarollArray;
@synthesize photostreamArray = _photostreamArray;
@synthesize photolibraryArray = _photolibraryArray;
@synthesize photoshareArray = _photoshareArray;
@synthesize photovideoArray = _photovideoArray;
@synthesize myAlbumsArray = _myAlbumsArray;
@synthesize albumsDic = _albumsDic;
@synthesize allBooksArray = _allBooksArray;
@synthesize collecitonArray = _collecitonArray;
//@synthesize safariHistoryArray = _safariHistoryArray;
@synthesize continuousShootingArray = _continuousShootingArray;
//@synthesize iCloud = _iCloud;
@synthesize shareAlbumDic = _shareAlbumDic;
@synthesize passwordDic = _passwordDic;
//@synthesize notesManager = _notesManager;
@synthesize timelapseArray = _timelapseArray;
@synthesize panoramasArray = _panoramasArray;
@synthesize livePhotoArray = _livePhotoArray;
@synthesize screenshotArray = _screenshotArray;
@synthesize photoSelfiesArray = _photoSelfiesArray;
@synthesize locationArray = _locationArray;
@synthesize favoriteArray = _favoriteArray;
@synthesize continuousShootingDic = _continuousShootingDic;
@synthesize slowMoveArray = _slowMoveArray;
//@synthesize noteNeedReload = noteNeedReload;
//@synthesize calendarNeedReload = calendarNeedReload;
//@synthesize bookmarkNeedReload = bookmarkNeedReload;
//@synthesize contactNeedReload = contactNeedReload;
@synthesize mediaDatabase = _mediaDatabase;
@synthesize CDBCorrupted = _CDBCorrupted;
@synthesize artworkDB = _artworkDB;
@synthesize idGenerator = _idGenerator;
@synthesize purchasesInfo = _purchasesInfo;
//@synthesize messageManager = _messageManager;
//@synthesize safariManager = _safariManager;
//@synthesize voicemailManager = _voicemailManager;
@synthesize isiCloudPhoto = _isiCloudPhoto;

- (id)initWithiPod:(IMBiPod *)ipod
{
    self = [super init];
    if (self) {
        _ipod = [ipod retain];
        _logHandle = [IMBLogManager singleton];
    }
    return self;
}

#pragma mark - media数据
- (void)refreshMedia
{
    [_logHandle writeInfoLog:@"refresh media"];
    if (_mediaDatabase != nil) {
        [_mediaDatabase release];
        _mediaDatabase = nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"parse music database strart: %@", [dateFormatter stringFromDate:[NSDate date]]]];
    _mediaDatabase = [[IMBMusicDatabase alloc] initWithIPod:_ipod];
    @try {
        [_mediaDatabase parse];
    }
    @catch (NSException *exception) {
        if ([@"EX_InvalidiPodDriver_DB_Not_Found" isEqualToString:exception.name]) {
            [_logHandle writeInfoLog:@"your device database is corrupted (CDB)"];
            _CDBCorrupted = YES;
            return;
        }
    }
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"parse music database end: %@", [dateFormatter stringFromDate:[NSDate date]]]];
    
    if (_artworkDB != nil) {
        [_artworkDB release];
        _artworkDB = nil;
    }
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"parse artwork database strart: %@", [dateFormatter stringFromDate:[NSDate date]]]];
    _artworkDB = [[IMBArtworkDB alloc] initWithIPod:_ipod];
    @try {
        [_artworkDB parse];
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"parse artwork database end: %@", [dateFormatter stringFromDate:[NSDate date]]]];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"parse artwork failed, reason is %@", exception.reason]];
    }
    @finally {
        _idGenerator = [[IMBIDGenerator alloc]initWithIPod:_ipod];
    }
    
    if (_mediaDatabase != nil) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"merge playcount strart: %@", [dateFormatter stringFromDate:[NSDate date]]]];
        IMBPlayCounts *playCounts = [[IMBPlayCounts alloc] initWithMusicDB:_mediaDatabase];
        [playCounts mergeChanges];
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"merge playcount end: %@", [dateFormatter stringFromDate:[NSDate date]]]];
    }
    
    [dateFormatter release];
    dateFormatter = nil;
}

- (void)refreshCloudMusic
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"parse Purchases strart: %@", [dateFormatter stringFromDate:[NSDate date]]]];
    @try {
        if (_purchasesInfo != nil) {
            [_purchasesInfo refreshPurchases];
        }
        else{
            _purchasesInfo = [[IMBPurchasesInfo alloc] initWithiPod:_ipod];
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"error:%@",exception.description]];
    }
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"parse Purchases end: %@", [dateFormatter stringFromDate:[NSDate date]]]];
    [dateFormatter release];
    dateFormatter = nil;
}

- (void)saveChanges
{
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"music database save strart: %@", [dateFormatter stringFromDate:[NSDate date]]]];
        if ([_mediaDatabase isDirty] == YES) {
            [_ipod startSync];
            [_mediaDatabase save];
            [_ipod.session clear];
        }
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"music database save end: %@", [dateFormatter stringFromDate:[NSDate date]]]];
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"artwork save strart: %@", [dateFormatter stringFromDate:[NSDate date]]]];
        if ([_artworkDB isDirty] == YES) {
            [_ipod startSync];
            [_artworkDB save];
        }
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"artwork save end: %@", [dateFormatter stringFromDate:[NSDate date]]]];
        [dateFormatter release];
        dateFormatter = nil;
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"saveChange failed, reason is %@.", exception.reason]];
    }
}

- (IMBPlaylistList*)playlists
{
    @try {
        if (_mediaDatabase == nil) {
            [self refreshMedia];
        }
        
        return [_mediaDatabase playlistList];
    }
    @catch (NSException *exception) {
        return nil;
    }
}

- (IMBTracklist*)tracks
{
    @try {
        if (_mediaDatabase == nil) {
            [self refreshMedia];
        }
        return [_mediaDatabase tracklist];
    }
    @catch (NSException *exception) {
        return nil;
    }
}

- (NSArray*)playlistArray
{
    @try {
        if (_playlistArray != nil) {
            [_playlistArray release];
            _playlistArray = nil;
        }
        _playlistArray = [[NSMutableArray alloc] init];
        if (_mediaDatabase == nil) {
            [self refreshMedia];
        }
        [_playlistArray addObjectsFromArray:_mediaDatabase.playlistList.playlistArray];
        return _playlistArray;
    }
    @catch (NSException *exception) {
        return nil;
    }
}
//
- (NSArray*)trackArray
{
    @try {
        if (_trackArray != nil) {
            [_trackArray release];
            _trackArray = nil;
        }
        _trackArray = [[NSMutableArray alloc] init];
        if (_mediaDatabase == nil) {
            [self refreshMedia];
        }
        [_trackArray addObjectsFromArray:_mediaDatabase.tracklist.trackArray] ;
//        if (_purchasesInfo != nil) {
//            [trackArray addObjectsFromArray:_purchasesInfo.purchasesTracks];
//        }
        return _trackArray;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

- (NSMutableArray *)cloudTrackArray
{
    @try {
        if (_cloudTrackArray != nil) {
            [_cloudTrackArray release];
            _cloudTrackArray = nil;
        }
        _cloudTrackArray = [[NSMutableArray alloc] init];
        if (_purchasesInfo == nil) {
            [self refreshCloudMusic];
        }
        
        [_cloudTrackArray addObjectsFromArray:_purchasesInfo.purchasesTracks];
        return _cloudTrackArray;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

- (NSArray*)getTrackArrayByMediaTypes:(NSArray*)mediaTypes
{
    NSArray *trackArray = [self trackArray];
    if ([mediaTypes count] == 1) {
        long long mediaT = [((NSNumber *)[mediaTypes objectAtIndex:0]) intValue];
        if (mediaT == 16384) {
            if ( trackArray != nil && mediaTypes != nil) {
                NSArray *tracks = [trackArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"mediaType IN %@",mediaTypes]];
                //读取purchase下的ringtong
                NSMutableArray *array = [NSMutableArray array];
                [array addObjectsFromArray:tracks];
                NSArray *purchaseArray = [self getPurchaseRingtong];
                [array addObjectsFromArray:purchaseArray];
                return array;
            }
        } else {

            NSArray *tracks = [trackArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"mediaType IN %@",mediaTypes]];
            return tracks;
        }
        
    } else {
        if ( trackArray != nil && mediaTypes != nil) {
            NSArray *tracks = [trackArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"mediaType IN %@",mediaTypes]];
            return tracks;
        }
    }
    return nil;
}

- (NSMutableArray *)getPurchaseRingtong
{
    // /Purchases/Ringtones.plist
    NSMutableArray *trackArray = [NSMutableArray array];
    NSString *destinationPath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"Ringtones.plist"];
    NSString *sourcePath = @"/Purchases/Ringtones.plist";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:destinationPath]) {
        
        [fileManager removeItemAtPath:destinationPath error:nil];
    }
    if ([_ipod.fileSystem fileExistsAtPath:sourcePath]) {
        BOOL success = [_ipod.fileSystem copyRemoteFile:sourcePath toLocalFile:destinationPath];
        if (success) {
            //读取plist文件
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:destinationPath];
            NSDictionary *ringtongDic = [dic objectForKey:@"Ringtones"];
            [ringtongDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSDictionary *objectDic = (NSDictionary *)obj;
                IMBTrack *track = [[IMBTrack alloc] init];
                track.album = [objectDic objectForKey:@"Album"];
                track.artist = [objectDic objectForKey:@"Artist"];
                track.genre = [objectDic objectForKey:@"Genre"];
                track.mediaType = Category_Ringtone;
                track.title = [objectDic objectForKey:@"Name"];
                track.length = [[objectDic objectForKey:@"Total Time"] intValue];
                track.isPurchase = [[objectDic objectForKey:@"Purchased"] boolValue];
                track.isprotected = [[objectDic objectForKey:@"Protected Content"] boolValue];
                track.dbID = [[objectDic objectForKey:@"PID"] longLongValue];
                
                track.filePath = key;
                if ([_ipod.fileSystem fileExistsAtPath:[@"/Purchases" stringByAppendingPathComponent:key]]) {
                    track.fileIsExist = YES;
                }
                [trackArray addObject:track];
                [track release];
                
            }];
        }
    }
    return trackArray;
}

#pragma mark - photo数据
- (void)loadphotoData
{
    _isiCloudPhoto = NO;
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    NSMutableArray *albumInfo = [photoManager getAlbumsInfo];
    albumInfo = [photoManager queryAlbumPhotosCount:albumInfo];
    if (albumInfo != nil && albumInfo.count > 0) {
        self.myAlbumsArray = [NSMutableArray array];
        self.albumsDic = [NSMutableDictionary dictionary];
        self.photoshareArray = [NSMutableArray array];
        self.shareAlbumDic = [NSMutableDictionary dictionary];
        for (IMBPhotoEntity *entity in albumInfo) {
            
            if (entity.albumType == CameraRoll) {
                if (entity.albumSubType == OtherType) {
                    self.camerarollArray = [photoManager getPhotoInfoByAlbum:entity];
                }else if (entity.albumSubType == Panoramas)
                {
                    self.panoramasArray = [photoManager getPhotoInfoByAlbum:entity];
                }
                _isiCloudPhoto = photoManager.isiCloudPhoto;
            }else if (entity.albumType == PhotoStream) {
                self.photostreamArray = [photoManager getPhotoInfoByAlbum:entity];
            }else if (entity.albumType == PhotoLibrary) {
                self.photolibraryArray = [photoManager getPhotoInfoByAlbum:entity];
            }else if (entity.albumType == SyncAlbum || entity.albumType == CreateAlbum) {
//                
//                if (entity.albumType == LivePhoto || entity.albumType == PhotoSelfies || entity.albumType == Screenshot || entity.albumType == Location || entity.albumType == Favorite) {
//                    if (entity.photoCounts > 0) {
//                        [self.myAlbumsArray addObject:entity];
//                        NSMutableArray *singleAlbum = [photoManager getPhotoInfoByAlbum:entity];
//                        if (singleAlbum != nil) {
//                            [self.albumsDic setObject:singleAlbum forKey:[NSNumber numberWithInt:entity.albumZpk]];
//                        }
//                    }
//                }else {
                    [self.myAlbumsArray addObject:entity];
                    NSMutableArray *singleAlbum = [photoManager getPhotoInfoByAlbum:entity];
                    if (singleAlbum != nil) {
                        [self.albumsDic setObject:singleAlbum forKey:[NSNumber numberWithInt:entity.albumZpk]];
                    }
//                }
            }else if (entity.albumType == LivePhoto) {
                self.livePhotoArray = [photoManager getPhotoInfoByAlbum:entity];
            }else if (entity.albumType == PhotoSelfies) {
                self.photoSelfiesArray = [photoManager getPhotoInfoByAlbum:entity];
            }else if (entity.albumType == Screenshot) {
                self.screenshotArray = [photoManager getPhotoInfoByAlbum:entity];
            }else if (entity.albumType == Location) {
                self.locationArray = [photoManager getPhotoInfoByAlbum:entity];
            }else if (entity.albumType == Favorite) {
                self.favoriteArray = [photoManager getPhotoInfoByAlbum:entity];
            }else if (entity.albumType == VideoAlbum) {
                if (entity.albumSubType == OtherType) {
                    self.photovideoArray = [photoManager getPhotoInfoByAlbum:entity];
                }else if (entity.albumSubType == TimeLapse)
                {
                    self.timelapseArray = [photoManager getPhotoInfoByAlbum:entity];
                }else if (entity.albumSubType == SlowMove)
                {
                    self.slowMoveArray = [photoManager getPhotoInfoByAlbum:entity];
                }
            }
            
            
            if (entity.albumType == PhotoShare) {
                [self.photoshareArray addObject:entity];
                NSMutableArray *singleShareArray = [photoManager getPhotoInfoByAlbum:entity];
                if (singleShareArray != nil) {
                    [self.shareAlbumDic setObject:singleShareArray forKey:[NSNumber numberWithInt:entity.albumZpk]];
                }
            }
            
        }
//        [_camerarollArray addObjectsFromArray:_panoramasArray];
//        [_camerarollArray addObjectsFromArray:_photovideoArray];
//        [_camerarollArray addObjectsFromArray:_timelapseArray];
//        [_camerarollArray addObjectsFromArray:_slowMoveArray];
    }
    
    //连拍查询
    NSMutableArray *continuousArray = nil;
    NSMutableArray *continuousCameraRoll = [photoManager getContinuousShootingAlbum];
    self.continuousShootingDic = [NSMutableDictionary dictionary];
    self.continuousShootingArray = continuousCameraRoll;
    for (IMBPhotoEntity *photoEntity in continuousCameraRoll) {
        
        continuousArray = [photoManager getContinuousShootings:photoEntity];
        if (continuousArray != nil) {
            [self.continuousShootingDic setObject:continuousArray forKey:[NSNumber numberWithInt:photoEntity.albumZpk]];
        }
    }

    [photoManager release];
}

- (void)refreshCameraRoll
{
    _isiCloudPhoto = NO;
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    NSMutableArray *albumInfo = [photoManager getAlbumsInfo];
    albumInfo = [photoManager queryAlbumPhotosCount:albumInfo];
    if (albumInfo != nil && albumInfo.count > 0) {
        for (IMBPhotoEntity *entity in albumInfo) {
            
            if (entity.albumType == CameraRoll) {
                if (entity.albumSubType == OtherType) {
                    if (_camerarollArray) {
                        [_camerarollArray release];
                        _camerarollArray = nil;
                    }
                    self.camerarollArray = [photoManager getPhotoInfoByAlbum:entity];
                }
                
            }
        }
    }
    [photoManager release];
}

- (void)refreshPhotoStream
{
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    NSMutableArray *albumInfo = [photoManager getAlbumsInfo];
    albumInfo = [photoManager queryAlbumPhotosCount:albumInfo];
    if (albumInfo != nil && albumInfo.count > 0) {
        for (IMBPhotoEntity *entity in albumInfo) {
            
            if (entity.albumType == PhotoStream) {
                if (_photostreamArray) {
                    [_photostreamArray release];
                    _photostreamArray = nil;
                }
                self.photostreamArray = [photoManager getPhotoInfoByAlbum:entity];
            }
        }
    }
    [photoManager release];
}

- (void)refreshPhotoLibrary
{
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    NSMutableArray *albumInfo = [photoManager getAlbumsInfo];
    albumInfo = [photoManager queryAlbumPhotosCount:albumInfo];
    if (albumInfo != nil && albumInfo.count > 0) {
        for (IMBPhotoEntity *entity in albumInfo) {
            
            if (entity.albumType == PhotoLibrary) {
                if (_photolibraryArray) {
                    [_photolibraryArray release];
                    _photolibraryArray = nil;
                }
                self.photolibraryArray = [photoManager getPhotoInfoByAlbum:entity];
            }
        }
    }
    [photoManager release];
}

- (void)refreshMyAlbum
{
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    NSMutableArray *albumInfo = [photoManager getAlbumsInfo];
    albumInfo = [photoManager queryAlbumPhotosCount:albumInfo];
    if (albumInfo != nil && albumInfo.count > 0) {
        if (_albumsDic != nil) {
            [_albumsDic release];
            _albumsDic = nil;
        }
        if (_myAlbumsArray != nil) {
            [_myAlbumsArray release];
            _myAlbumsArray = nil;
        }
        self.myAlbumsArray = [NSMutableArray array];
        self.albumsDic = [NSMutableDictionary dictionary];
        for (IMBPhotoEntity *entity in albumInfo) {
            if (entity.albumType == SyncAlbum || entity.albumType == CreateAlbum) {
                [self.myAlbumsArray addObject:entity];
                NSMutableArray *singleAlbum = [photoManager getPhotoInfoByAlbum:entity];
                if (singleAlbum != nil) {
                    [self.albumsDic setObject:singleAlbum forKey:[NSNumber numberWithInt:entity.albumZpk]];
                }
            }
        }
    }
    [photoManager release];
}

- (void)refreshcontinuousShootings
{
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    //连拍查询
    NSMutableArray *continuousCameraRoll = [photoManager getContinuousShootingAlbum];
    if (_continuousShootingArray) {
        [_continuousShootingArray release];
        _continuousShootingArray = nil;
    }
    if (_continuousShootingDic) {
        [_continuousShootingDic release];
        _continuousShootingDic = nil;
    }
    self.continuousShootingDic = [NSMutableDictionary dictionary];
    self.continuousShootingArray = continuousCameraRoll;
    for (IMBPhotoEntity *photoEntity in continuousCameraRoll) {
        
        NSMutableArray *continuousArray = [photoManager getContinuousShootings:photoEntity];
        if (continuousArray != nil) {
            [self.continuousShootingDic setObject:continuousArray forKey:[NSNumber numberWithInt:photoEntity.albumZpk]];
        }
    }
    [photoManager release];
}

- (void)refreshVideoAlbum
{
    _isiCloudPhoto = NO;
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    NSMutableArray *albumInfo = [photoManager getAlbumsInfo];
    albumInfo = [photoManager queryAlbumPhotosCount:albumInfo];
    if (albumInfo != nil && albumInfo.count > 0) {
        for (IMBPhotoEntity *entity in albumInfo) {
            
            if (entity.albumType == VideoAlbum) {
                if (entity.albumSubType == OtherType) {
                    if (_photovideoArray) {
                        [_photovideoArray release];
                        _photovideoArray = nil;
                    }
                    self.photovideoArray = [photoManager getPhotoInfoByAlbum:entity];
                }
            }
        }
    }
    [photoManager release];
}

- (void)refreshTimeLapse
{
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    NSMutableArray *albumInfo = [photoManager getAlbumsInfo];
    albumInfo = [photoManager queryAlbumPhotosCount:albumInfo];
    if (albumInfo != nil && albumInfo.count > 0) {
        for (IMBPhotoEntity *entity in albumInfo) {
            
            if (entity.albumType == VideoAlbum&&entity.albumSubType == TimeLapse) {
                if (_timelapseArray) {
                    [_timelapseArray release];
                    _timelapseArray = nil;
                }
                self.timelapseArray = [photoManager getPhotoInfoByAlbum:entity];
            }
        }
    }
    [photoManager release];
}

- (void)refreshSlowMove
{
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    NSMutableArray *albumInfo = [photoManager getAlbumsInfo];
    albumInfo = [photoManager queryAlbumPhotosCount:albumInfo];
    if (albumInfo != nil && albumInfo.count > 0) {
        for (IMBPhotoEntity *entity in albumInfo) {
            
            if (entity.albumType == VideoAlbum&&entity.albumSubType == SlowMove) {
                if (_slowMoveArray) {
                    [_slowMoveArray release];
                    _slowMoveArray = nil;
                }
                self.slowMoveArray = [photoManager getPhotoInfoByAlbum:entity];
            }
        }
    }
    [photoManager release];
}

- (void)refreshPanoramas
{
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    NSMutableArray *albumInfo = [photoManager getAlbumsInfo];
    albumInfo = [photoManager queryAlbumPhotosCount:albumInfo];
    if (albumInfo != nil && albumInfo.count > 0) {
        for (IMBPhotoEntity *entity in albumInfo) {
            
            if (entity.albumType == CameraRoll&&entity.albumSubType == Panoramas) {
                if (_panoramasArray) {
                    [_panoramasArray release];
                    _panoramasArray = nil;
                }
                self.panoramasArray = [photoManager getPhotoInfoByAlbum:entity];
            }
        }
    }
    [photoManager release];
}

- (void)refreshPhotoShare
{
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    NSMutableArray *albumInfo = [photoManager getAlbumsInfo];
    albumInfo = [photoManager queryAlbumPhotosCount:albumInfo];
    if (albumInfo != nil && albumInfo.count > 0) {
        if (_photoshareArray != nil) {
            [_photoshareArray release];
            _photoshareArray = nil;
        }
        if (_shareAlbumDic != nil) {
            [_shareAlbumDic release];
            _shareAlbumDic = nil;
        }
        self.photoshareArray = [NSMutableArray array];
        self.shareAlbumDic = [NSMutableDictionary dictionary];
        for (IMBPhotoEntity *entity in albumInfo) {
            
            if (entity.albumType == PhotoShare) {
                [self.photoshareArray addObject:entity];
                NSMutableArray *singleShareArray = [photoManager getPhotoInfoByAlbum:entity];
                if (singleShareArray != nil) {
                    [self.shareAlbumDic setObject:singleShareArray forKey:[NSNumber numberWithInt:entity.albumZpk]];
                }
            }
        }
    }
    [photoManager release];
}

- (void)refreshLivePhoto
{
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    NSMutableArray *albumInfo = [photoManager getAlbumsInfo];
    albumInfo = [photoManager queryAlbumPhotosCount:albumInfo];
    if (albumInfo != nil && albumInfo.count > 0) {
        for (IMBPhotoEntity *entity in albumInfo) {
            
            if (entity.albumType == LivePhoto) {
                if (_livePhotoArray) {
                    [_livePhotoArray release];
                    _livePhotoArray = nil;
                }
                self.livePhotoArray = [photoManager getPhotoInfoByAlbum:entity];
            }
        }
    }
    [photoManager release];
}

- (void)refreshPhotoSelfies
{
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    NSMutableArray *albumInfo = [photoManager getAlbumsInfo];
    albumInfo = [photoManager queryAlbumPhotosCount:albumInfo];
    if (albumInfo != nil && albumInfo.count > 0) {
        for (IMBPhotoEntity *entity in albumInfo) {
            
            if (entity.albumType == PhotoSelfies) {
                if (_photoSelfiesArray) {
                    [_photoSelfiesArray release];
                    _photoSelfiesArray = nil;
                }
                self.photoSelfiesArray = [photoManager getPhotoInfoByAlbum:entity];
            }
        }
    }
    [photoManager release];
}

- (void)refreshScreenshot
{
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    NSMutableArray *albumInfo = [photoManager getAlbumsInfo];
    albumInfo = [photoManager queryAlbumPhotosCount:albumInfo];
    if (albumInfo != nil && albumInfo.count > 0) {
        for (IMBPhotoEntity *entity in albumInfo) {
            
            if (entity.albumType == Screenshot) {
                if (_screenshotArray) {
                    [_screenshotArray release];
                    _screenshotArray = nil;
                }
                self.screenshotArray = [photoManager getPhotoInfoByAlbum:entity];
            }
        }
    }
    [photoManager release];
}

- (void)refreshLocation
{
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    NSMutableArray *albumInfo = [photoManager getAlbumsInfo];
    albumInfo = [photoManager queryAlbumPhotosCount:albumInfo];
    if (albumInfo != nil && albumInfo.count > 0) {
        for (IMBPhotoEntity *entity in albumInfo) {
            
            if (entity.albumType == Location) {
                if (_locationArray) {
                    [_locationArray release];
                    _locationArray = nil;
                }
                self.locationArray = [photoManager getPhotoInfoByAlbum:entity];
            }
        }
    }
    [photoManager release];
}

- (void)refreshFavorite
{
    IMBPhotoManager *photoManager = [[IMBPhotoManager alloc] initWithiPod:_ipod];
    NSMutableArray *albumInfo = [photoManager getAlbumsInfo];
    albumInfo = [photoManager queryAlbumPhotosCount:albumInfo];
    if (albumInfo != nil && albumInfo.count > 0) {
        for (IMBPhotoEntity *entity in albumInfo) {
            
            if (entity.albumType == Favorite) {
                if (_favoriteArray) {
                    [_favoriteArray release];
                    _favoriteArray = nil;
                }
                self.favoriteArray = [photoManager getPhotoInfoByAlbum:entity];
            }
        }
    }
    [photoManager release];
}

//#pragma mark - recording数据
//- (IMBRecording*) recording
//{
//    if (_recording != nil) {
//        return _recording;
//    }
//    if ([_ipod.deviceInfo isIOSDevice]) {
//        _recording = [[IMBRecording alloc] initWithIPod:_ipod];
//        return _recording;
//    }
//    return nil;
//}
//
#pragma mark - app数据
- (IMBApplicationManager*)applicationManager
{
    if (_appManager != nil) {
        return _appManager;
    }
    if ([_ipod.deviceInfo isIOSDevice]) {
        _appManager = [[IMBApplicationManager alloc] initWithiPod:_ipod];
        return _appManager;
    }
    return nil;
}

#pragma mark - ibook数据
- (void)loadiBook
{
    IMBBooksManager *bookmanager = [[IMBBooksManager alloc] initWithIpod:_ipod];
    NSMutableArray *booksArray = [bookmanager queryAllbooks];
    NSMutableArray *collecitonArray = [bookmanager queryAllcollections];
    if (collecitonArray == nil) {
        collecitonArray = [NSMutableArray array];
    }
    IMBBookCollection *collection = [[IMBBookCollection alloc] init];
//    collection.collectionName = CustomLocalizedString(@"iBook_id_1", nil);
    [collecitonArray insertObject:collection atIndex:0];
    [collection release];
    self.allBooksArray = booksArray;
    self.collecitonArray = collecitonArray;
    [bookmanager release];
}

//#pragma mark - note数据
//- (void)loadNote
//{
//    IMBNotesManager *noteManager = [[IMBNotesManager alloc] initWithAMDevice:_ipod.deviceHandle];
//    [noteManager openMobileSync];
//    [noteManager queryAllNotes];
//    self.noteArray = [noteManager allNotesArray];
//    [noteManager closeMobileSync];
//    self.notesManager = noteManager;
//    [noteManager release];
//}
//
//#pragma mark - bookmark数据
//- (void)loadBookmark
//{
//    IMBBookmarksManager *bookmarkmanager = [[IMBBookmarksManager alloc] initWithAMDevice:_ipod.deviceHandle];
//    [bookmarkmanager openMobileSync];
//    self.bookmarkArray = (NSMutableArray *)[bookmarkmanager queryRootArray];
//    [bookmarkmanager closeMobileSync];
//    [bookmarkmanager release];
//}
//
//#pragma mark - calendar数据
//- (void)loadCalendar
//{
//    //获取calendar数据
//    IMBCalendarsManager *calendarManager = [[IMBCalendarsManager alloc] initWithAMDevice:_ipod.deviceHandle] ;
//    [calendarManager openMobileSync];
//    self.calendarArray = [calendarManager queryAllCalendarEvents];
//    [calendarManager closeMobileSync];
//    [calendarManager release];
//}
//
//#pragma mark - message数据
//- (void)loadMessage:(BOOL)isFirst
//{
//    //message
//    if (_messageManager == nil) {
//        _messageManager = [[IMBMessagesManager alloc] initWithAMDevice:_ipod.deviceHandle];
//    }
//    [_messageManager setIsFirst:isFirst];
//    [_messageManager queryAllSMSData];
//    self.messageArray = _messageManager.smsData.dataAry;
//}
//
//#pragma mark - contact数据
//- (void)loadContact
//{
//    IMBContactManager *contactManager = [[IMBContactManager alloc] initWithAMDevice:_ipod.deviceHandle];
//    [contactManager openMobileSync];
//    [contactManager queryAllContact];
//    self.contactArray = contactManager.allContactArray;
//    [contactManager closeMobileSync];
//    [contactManager release];
//}
//
//- (void)loadSafariHistory:(BOOL)isFirst
//{
//    if (_safariManager == nil) {
//        _safariManager = [[IMBSafariHistoryManager alloc] initWithAMDevice:_ipod.deviceHandle];
//    }
//    [_safariManager setIsFirst:isFirst];
//    [_safariManager queryAllSMSData];
//    self.safariHistoryArray = _safariManager.safariData.dataAry;
//}
//
//#pragma mark - voicemail数据
//- (void)loadVoicemail:(BOOL)isFirst;
//{
//    if (_voicemailManager == nil) {
//        _voicemailManager = [[IMBVoicemailManager alloc] initWithAMDevice:_ipod.deviceHandle];
//    }
//    [_voicemailManager setIsFirst:isFirst];
//    [_voicemailManager queryAllVoicemail];
//    self.voicemailArray = _voicemailManager.voicemailData.dataAry;
//}
//
- (NSMutableDictionary *)passwordDic
{
    if (_passwordDic == nil) {
        _passwordDic = [[NSMutableDictionary dictionary] retain];
    }
    return _passwordDic;
}

- (long long)calulatePhotoSize
{
    long long size = 0;
    for (IMBPhotoEntity *photo in _camerarollArray) {
        size = size + photo.photoSize;
    }
    for (IMBPhotoEntity *photo in _photostreamArray) {
        size = size + photo.photoSize;
    }
    for (IMBPhotoEntity *photo in _photolibraryArray) {
        size = size + photo.photoSize;
    }
    for (IMBPhotoEntity *photo in _photovideoArray) {
        size = size + photo.photoSize;
    }
    for (IMBPhotoEntity *photo in _photoshareArray) {
        size = size + photo.photoSize;
    }
    for (IMBPhotoEntity *photo in _panoramasArray) {
        size = size + photo.photoSize;
    }
    for (IMBPhotoEntity *photo in _timelapseArray) {
        size = size + photo.photoSize;
    }
    for (IMBPhotoEntity *photo in _slowMoveArray) {
        size = size + photo.photoSize;
    }
    for (IMBPhotoEntity *photo in _continuousShootingArray) {
        for (IMBPhotoEntity *entity in [_continuousShootingDic objectForKey:[NSNumber numberWithInt:photo.albumZpk]]) {
            size = size + entity.photoSize;
        }
    }
    return size;
}

- (long long)calulateiBookSize
{
    long long size = 0;
    for (IMBBookEntity *book in _allBooksArray) {
        size = size + book.size;
    }
    return size;
}

- (void)dealloc
{
//    [_messageManager release],_messageManager = nil;
    [_recordDic release],_recordDic = nil;
    [_ipod release],_ipod = nil;
//    [_noteArray release],_noteArray = nil;
//    [_messageArray release],_messageArray = nil;
    [_camerarollArray release],_camerarollArray = nil;
//    [_calendarArray release],_calendarArray = nil;
//    [_bookmarkArray release],_bookmarkArray = nil;
//    [_contactArray release],_contactArray = nil;
//    [_phoneArray release],_phoneArray = nil;
    [_panoramasArray release],_panoramasArray = nil;
    [_timelapseArray release],_timelapseArray = nil;
    [_continuousShootingArray release],_continuousShootingArray = nil;
    [_continuousShootingDic release],_continuousShootingDic = nil;
    [_photolibraryArray release],_photolibraryArray = nil;
    [_photostreamArray release],_photostreamArray = nil;
    [_livePhotoArray release],_livePhotoArray = nil;
    [_locationArray release],_locationArray = nil;
    [_photoSelfiesArray release],_photoSelfiesArray = nil;
    [_screenshotArray release],_screenshotArray = nil;
    [_favoriteArray release], _favoriteArray = nil;
//    [_voicemailArray release],_voicemailArray = nil;
    [_myAlbumsArray release],_myAlbumsArray = nil;
    [_albumsDic release],_albumsDic = nil;
    [_shareAlbumDic release],_shareAlbumDic = nil;
//    [_safariHistoryArray release],_safariHistoryArray = nil;
    [_allBooksArray release],_allBooksArray = nil;
    [_photovideoArray release], _photovideoArray = nil;
    [_photoshareArray release], _photoshareArray = nil;
    [_passwordDic release],_passwordDic = nil;
//    [_notesManager release],_notesManager = nil;
    [_slowMoveArray release],_slowMoveArray = nil;
    [_mediaDatabase release],_mediaDatabase = nil;
    [_artworkDB release],_artworkDB = nil;
    [_purchasesInfo release],_purchasesInfo = nil;
    [_idGenerator release],_idGenerator = nil;
//    [_recording release],_recording = nil;
    [_collecitonArray release],_collecitonArray = nil;
//    [_voicemailManager release],_voicemailManager = nil;
    if (_playlistArray != nil) {
        [_playlistArray release];
        _playlistArray = nil;
    }
    if (_trackArray != nil) {
        [_trackArray release];
        _trackArray = nil;
    }
    if (_cloudTrackArray != nil) {
        [_cloudTrackArray release];
        _cloudTrackArray = nil;
    }
    [super dealloc];
}
@end
