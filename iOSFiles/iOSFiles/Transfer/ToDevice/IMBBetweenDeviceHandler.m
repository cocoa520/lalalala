//
//  IMBBetweenDeviceHandler.m
//  iMobieTrans
//
//  Created by iMobie on 8/8/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBetweenDeviceHandler.h"
#import "IMBPhotoEntity.h"
//#import "IMBContactEntity.h"
#import "IMBPlaylist.h"
#import "IMBLogManager.h"
#import "IMBDeviceInfo.h"
//#import "IMBContactManager.h"
//#import "IMBNotesManager.h"
//#import "IMBBookmarksManager.h"
#import "IMBBookEntity.h"
#import "IMBAppEntity.h"
//#import "IMBNoteDataEntity.h"
#import "NSString+Category.h"
#import "IMBPlaylistList.h"
#import "IMBInformation.h"
#import "IMBInformationManager.h"
@implementation IMBBetweenDeviceHandler
@synthesize threadBreak = _threadBreak;
@synthesize isClone = isClone;
- (id)initWithSelectedModels:(NSArray *)selectModels srcIpodKey:(NSString *)srcIpodKey desIpodKey:(NSString *)desIpodKey Delegate:(id)delegate {
    if (self = [super initWithIPodkey:desIpodKey withDelegate:delegate]) {
        _selectModels = [selectModels retain];
        _srcIpod = [[[IMBDeviceConnection singleton] getiPodByKey:srcIpodKey] retain];
        _convertedMediaDic = [[NSMutableDictionary alloc] init];
        _toDeviceInforDic = [[NSMutableDictionary alloc] init];
        nc = [NSNotificationCenter defaultCenter];
        _isAll = YES;
        isClone = NO;
        _infomationCount = 0;
    }
    return self;
}

- (id)initWithSelectedArray:(NSArray *)selectArrs categoryModel:(IMBCategoryInfoModel *)categoryModel srcIpodKey:(NSString *)srcIpodKey desIpodKey:(NSString *)desIpodKey withPlaylistArray:(NSArray *)playListArray albumEntity:(IMBPhotoEntity *)albumEntity Delegate:(id)delegate {
    if (self = [super initWithIPodkey:desIpodKey withDelegate:delegate]) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:categoryModel];
        //当包含playlist的处理
        if (playListArray.count > 0) {
            IMBCategoryInfoModel *categoryInfoModel1 = [[IMBCategoryInfoModel alloc] init];
            categoryInfoModel1.categoryNodes = Category_Playlist;
            [array addObject:categoryInfoModel1];
            [categoryInfoModel1 release];
            _playlistArray = [playListArray retain];
        }
        isClone = NO;
        _selectModels = [array retain];
        _srcIpod = [[[IMBDeviceConnection singleton] getiPodByKey:srcIpodKey] retain];
        _convertedMediaDic = [[NSMutableDictionary alloc] init];
        _toDeviceInforDic = [[NSMutableDictionary alloc] init];
        _selectedArr = [selectArrs retain];
        _isAll = NO;
        if (_albumEntity != nil) {
            _albumEntity = [albumEntity retain];
        }
        _infomationCount = 0;
    }
    return self;
}

- (void)setThreadBreak:(BOOL)threadBreak{
    _isStop = YES;
//    [_deviceTransfer setThreadBreak:YES];
}

//TODO:添加单个视图选择的个数导入
- (void)filterToNoRepeatItems{
    NSMutableDictionary *srcExportDic = [NSMutableDictionary dictionary];
    [self getDesipodContent:srcExportDic ipod:_srcIpod];
    NSMutableDictionary *desExportDic = [NSMutableDictionary dictionary];
    [self getDesipodContent:desExportDic ipod:_ipod];
    if ([srcExportDic.allKeys containsObject:[NSNumber numberWithInt:Category_Playlist]]) {
        [self verifyRepeatPlistBySrcDic:srcExportDic desDic:desExportDic];
    }
    if ([srcExportDic.allKeys containsObject:[NSNumber numberWithInt:Category_MyAlbums]]) {
        [self verifyRepeatAlbumsBySrcDic:srcExportDic desDic:desExportDic];
    }
    if ([srcExportDic.allKeys containsObject:[NSNumber numberWithInt:Category_Applications]]) {
        [self verifyRepeatAppBySrcDic:srcExportDic desDic:desExportDic];
    }
    if ([srcExportDic.allKeys containsObject:[NSNumber numberWithInt:Category_Contacts]]) {
        [self verifyContactsBySrcDic:srcExportDic desDic:desExportDic];
    }
    [self verifyTrackBySrcDic:srcExportDic desDic:desExportDic inSpecifyCategorys:[NSArray arrayWithObjects:[NSNumber numberWithInt:Category_Music],[NSNumber numberWithInt:Category_Ringtone],[NSNumber numberWithInt:Category_Audiobook],[NSNumber numberWithInt:Category_Movies],[NSNumber numberWithInt:Category_TVShow],[NSNumber numberWithInt:Category_MusicVideo],[NSNumber numberWithInt:Category_PodCasts],[NSNumber numberWithInt:Category_iTunesU],[NSNumber numberWithInt:Category_Ringtone], nil]];
    _srcExportDic = [srcExportDic retain];
    [self prepareToDeviceData];
}

- (void)filterToPartNoRepeatItems{
    NSMutableDictionary *srcExportDic = [NSMutableDictionary dictionary];
    if (_playlistArray.count > 0) {
        [srcExportDic setObject:_selectedArr forKey:[NSNumber numberWithInt:Category_Music]];
        [srcExportDic setObject:_playlistArray forKey:[NSNumber numberWithInt:Category_Playlist]];
    }
    else{
        IMBCategoryInfoModel *categoryInfoModel = [_selectModels objectAtIndex:0];
        [srcExportDic setObject:_selectedArr forKey:[NSNumber numberWithInt:categoryInfoModel.categoryNodes]];

    }
    NSMutableDictionary *desExportDic = [NSMutableDictionary dictionary];
    [self getDesipodContent:desExportDic ipod:_ipod];
    
    if ([srcExportDic.allKeys containsObject:[NSNumber numberWithInt:Category_Playlist]]) {
        [self verifyRepeatPlistBySrcDic:srcExportDic desDic:desExportDic];
    }
    if ([srcExportDic.allKeys containsObject:[NSNumber numberWithInt:Category_Applications]]) {
        [self verifyRepeatAppBySrcDic:srcExportDic desDic:desExportDic];
    }
    if ([srcExportDic.allKeys containsObject:[NSNumber numberWithInt:Category_Contacts]]) {
        [self verifyContactsBySrcDic:srcExportDic desDic:desExportDic];
    }
    NSMutableArray *carArray = [NSMutableArray array];
    for (NSNumber *number in srcExportDic.allKeys) {
        if (number.intValue == Category_Music||number.intValue == Category_Ringtone||number.intValue == Category_Audiobook||number.intValue == Category_Movies||number.intValue == Category_TVShow||number.intValue == Category_MusicVideo||number.intValue == Category_PodCasts||number.intValue == Category_iTunesU||number.intValue == Category_Ringtone) {
            [carArray addObject:number];
        }
    }
    if (carArray.count > 0) {
        [self verifyTrackBySrcDic:srcExportDic desDic:desExportDic inSpecifyCategorys:carArray];
    }
    _srcExportDic = [srcExportDic retain];
    [self prepareToDeviceData];
}

- (void)getDesipodContent:(NSMutableDictionary *)desDic ipod:(IMBiPod *)curIpod {
    if (curIpod == nil) {
        return;
    }
//    _totalItem = 0;
    if (_selectModels != nil && _selectModels.count > 0) {
        for (IMBCategoryInfoModel *model in _selectModels) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            if (model.categoryNodes == Category_Music || model.categoryNodes == Category_Movies || model.categoryNodes == Category_TVShow || model.categoryNodes == Category_MusicVideo || model.categoryNodes == Category_PodCasts || model.categoryNodes == Category_iTunesU || model.categoryNodes == Category_Audiobook || model.categoryNodes == Category_Ringtone||model.categoryNodes== Category_HomeVideo) {
                //mediaArray中存放的是对应类目的所有数据
                NSArray *mediaArray = [curIpod getTrackArrayByMediaTypes:[IMBCommonEnum categoryNodeToMediaTyps:model.categoryNodes]];
                if (mediaArray == nil) {
                    mediaArray = [NSArray array];
                }
                if (mediaArray.count > 0) {
                    [desDic setObject:mediaArray forKey:[NSNumber numberWithInt:model.categoryNodes]];
//                    _totalItem += mediaArray.count;
                }
            }
            else if (model.categoryNodes == Category_Playlist) {
                //存放的是各种playlist
                NSMutableArray *syncListArray = [[NSMutableArray alloc] init];
                NSArray *playlistArray = curIpod.playlists.playlistArray;
                for (IMBPlaylist *pl in playlistArray) {
                    if (isClone) {
                        if (pl.isUserDefinedPlaylist||pl.isMaster) {
                            [syncListArray addObject:pl];
                            if (pl.isMaster) {
                                for (IMBTrack *track in pl.tracks) {
                                    if ((track.mediaType == AudioAndVideo||track.mediaType == Audio)) {
//                                        _totalItem++;
                                    }
                                }
                                
                            }
                            
                        }
                    }else
                    {
                        if (pl.isUserDefinedPlaylist) {
                            [syncListArray addObject:pl];
//                            _totalItem += pl.tracks.count;
                        }
                        
                    }
                    
                }
                if (syncListArray.count > 0) {
                    [desDic setObject:syncListArray forKey:[NSNumber numberWithInt:model.categoryNodes]];
                }
                [syncListArray release];
            }
            else if (model.categoryNodes == Category_VoiceMemos) {
                //存放的是track
//                IMBInformation *infomation = [[[IMBInformationManager shareInstance] informationDic] objectForKey:curIpod.uniqueKey];
//                NSArray *vioceArray = [[infomation recording] recordingArray];
//                
//                if (vioceArray == nil) {
//                    vioceArray = [NSArray array];
//                }
//                if (vioceArray.count > 0) {
//                    [desDic setObject:vioceArray forKey:[NSNumber numberWithInt:model.categoryNodes]];
////                    _totalItem += vioceArray.count;
//                }
            }
            else if (model.categoryNodes == Category_Applications) {
                //存放的是IMBAppEntity
                IMBInformation *infomation = [[[IMBInformationManager shareInstance] informationDic] objectForKey:curIpod.uniqueKey];
                NSArray *appArray = infomation.applicationManager.appEntityArray;
                if (appArray == nil) {
                    appArray = [NSArray array];
                }
                if (appArray.count > 0) {
                    [desDic setObject:appArray forKey:[NSNumber numberWithInt:model.categoryNodes]];
//                    _totalItem += appArray.count;
                }
            }
            else if (model.categoryNodes == Category_CameraRoll || model.categoryNodes == Category_PhotoStream || model.categoryNodes == Category_PhotoLibrary || model.categoryNodes == Category_PhotoVideo || model.categoryNodes == Category_Panoramas||model.categoryNodes == Category_TimeLapse||model.categoryNodes == Category_SlowMove||model.categoryNodes == Category_LivePhoto||model.categoryNodes == Category_Screenshot||model.categoryNodes == Category_PhotoSelfies||model.categoryNodes == Category_Location||model.categoryNodes == Category_Favorite) {
                //存放的是各种IMBPhtotoEntity
                IMBInformation *infomation = [[[IMBInformationManager shareInstance] informationDic] objectForKey:curIpod.uniqueKey];
                NSArray *photoArray = nil;
                if (model.categoryNodes == Category_CameraRoll) {
                    photoArray = [infomation camerarollArray];
                }else if (model.categoryNodes == Category_PhotoStream) {
                    photoArray = [infomation photostreamArray];
                }else if (model.categoryNodes == Category_PhotoLibrary) {
                    photoArray = [infomation photolibraryArray];
                }else if (model.categoryNodes == Category_PhotoVideo) {
                    photoArray = [infomation photovideoArray];
                }else if (model.categoryNodes == Category_Panoramas) {
                    photoArray = [infomation panoramasArray];
                }else if (model.categoryNodes == Category_TimeLapse) {
                    photoArray = [infomation timelapseArray];
                }else if (model.categoryNodes == Category_SlowMove) {
                    photoArray = [infomation slowMoveArray];
                }else if (model.categoryNodes == Category_LivePhoto) {
                    photoArray = [infomation livePhotoArray];
                }else if (model.categoryNodes == Category_Screenshot) {
                    photoArray = [infomation screenshotArray];
                }else if (model.categoryNodes == Category_PhotoSelfies) {
                    photoArray = [infomation photoSelfiesArray];
                }else if (model.categoryNodes == Category_Location) {
                    photoArray = [infomation locationArray];
                }else if (model.categoryNodes == Category_Favorite) {
                    photoArray = [infomation favoriteArray];
                }
                if (photoArray != nil && photoArray.count > 0) {
                    [desDic setObject:photoArray forKey:[NSNumber numberWithInt:model.categoryNodes]];
//                    _totalItem += photoArray.count;
                }
            }else if (model.categoryNodes == Category_PhotoShare) {
                IMBInformation *infomation = [[[IMBInformationManager shareInstance] informationDic] objectForKey:curIpod.uniqueKey];
                
                if (infomation.shareAlbumDic == nil) {
                    infomation.shareAlbumDic = [NSMutableDictionary dictionary];
                }
                [desDic setObject:infomation.shareAlbumDic forKey:[NSNumber numberWithInt:model.categoryNodes]];
//                NSArray *allKeys = [infomation.shareAlbumDic allKeys];
//                
//                for (NSNumber *number in allKeys) {
//                    NSArray *singleArray = [infomation.shareAlbumDic objectForKey:number];
//                    _totalItem += singleArray.count;
//                }
            }
            else if (model.categoryNodes == Category_MyAlbums) {
                IMBInformation *infomation = [[[IMBInformationManager shareInstance] informationDic] objectForKey:curIpod.uniqueKey];
                
                if (infomation.albumsDic == nil) {
                    infomation.albumsDic = [NSMutableDictionary dictionary];
                }
                [desDic setObject:infomation.albumsDic forKey:[NSNumber numberWithInt:model.categoryNodes]];
//                NSArray *allKeys = [infomation.albumsDic allKeys];
//                
//                for (NSNumber *number in allKeys) {
//                    NSArray *singleArray = [infomation.albumsDic objectForKey:number];
//                    _totalItem += singleArray.count;
//                }
            }else if (model.categoryNodes == Category_ContinuousShooting)
            {
                IMBInformation *infomation = [[[IMBInformationManager shareInstance] informationDic] objectForKey:curIpod.uniqueKey];
                
                if (infomation.continuousShootingDic == nil) {
                    infomation.continuousShootingDic = [NSMutableDictionary dictionary];
                }
                
                [desDic setObject:infomation.continuousShootingDic forKey:[NSNumber numberWithInt:model.categoryNodes]];
//                NSArray *allKeys = [infomation.continuousShootingDic allKeys];
//                
//                for (NSNumber *number in allKeys) {
//                    NSArray *singleArray = [infomation.continuousShootingDic objectForKey:number];
//                    _totalItem += singleArray.count;
//                }
                
            }
//            else if (model.categoryNodes == Category_Notes) {
//                IMBInformation *infomation = [[[IMBInformationManager shareInstance] informationDic] objectForKey:curIpod.uniqueKey];
//                
//                if (infomation.noteArray && infomation.noteArray.count > 0) {
//                    [desDic setObject:infomation.noteArray forKey:[NSNumber numberWithInt:model.categoryNodes]];
////                    _totalItem += infomation.noteArray.count;
//                }
//            }
//            else if (model.categoryNodes == Category_Contacts) {
//                IMBInformation *infomation = [[[IMBInformationManager shareInstance] informationDic] objectForKey:curIpod.uniqueKey];
//                
//                if (infomation.contactArray && infomation.contactArray.count > 0) {
//                    [desDic setObject:infomation.contactArray forKey:[NSNumber numberWithInt:model.categoryNodes]];
////                    _totalItem += infomation.contactArray.count;
//                }
//            }
//            else if (model.categoryNodes == Category_Bookmarks) {
//                IMBInformation *infomation = [[[IMBInformationManager shareInstance] informationDic] objectForKey:curIpod.uniqueKey];
//                
//                if (infomation.bookmarkArray && infomation.bookmarkArray.count > 0) {
//                    [desDic setObject:infomation.bookmarkArray forKey:[NSNumber numberWithInt:model.categoryNodes]];
////                    _totalItem += infomation.bookmarkArray.count;
//                }
//            }
//            else if (model.categoryNodes == Category_Calendar) {
//                IMBInformation *infomation = [[[IMBInformationManager shareInstance] informationDic] objectForKey:curIpod.uniqueKey];
//                
//                if (infomation.calendarArray && infomation.calendarArray.count > 0) {
//                    [desDic setObject:infomation.calendarArray forKey:[NSNumber numberWithInt:model.categoryNodes]];
////                    _totalItem += infomation.calendarArray.count;
//                }
//            }
            else if (model.categoryNodes == Category_iBooks) {
                IMBInformation *infomation = [[[IMBInformationManager shareInstance] informationDic] objectForKey:curIpod.uniqueKey];
                
                if (infomation.allBooksArray && infomation.allBooksArray.count > 0) {
                    [desDic setObject:infomation.allBooksArray forKey:[NSNumber numberWithInt:model.categoryNodes]];
//                    _totalItem += infomation.allBooksArray.count;
                }
            }
        }
    }
}

- (BOOL)prepareToDeviceData{
    BOOL result = true;
    
    NSMutableDictionary *newDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    if (_srcExportDic.allKeys.count > 0) {
        NSNumber *number = [NSNumber numberWithInt:Category_Playlist];
        if ([_srcExportDic.allKeys containsObject:number]) {
            [newDictionary setObject:[_srcExportDic objectForKey:number] forKey:number];
            for (NSNumber *nnumber in _srcExportDic.allKeys) {
                if (number != nnumber) {
                    [newDictionary setObject:[_srcExportDic objectForKey:nnumber] forKey:nnumber];
                }
            }
            if (_srcExportDic != nil) {
                [_srcExportDic release];
                _srcExportDic = nil;
            }
            _srcExportDic = [newDictionary retain];
        }
        result = true;
    }
    else{
        result = false;
    }

    return  result;
}

//media包含Audio,Video,Books,podCast,ItunesU
- (void)prepareDataWithSelectedModels {
    for (IMBCategoryInfoModel *model in _selectModels) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            break;
        }
        switch (model.categoryNodes) {
                //按照media方式进行处理,不用分类目,因为已经在Track中的mediaType中了
            //TODO:是否添加PodCast,iTunesU
            case Category_Music:
            case Category_Audiobook:
            case Category_Movies:
            case Category_TVShow:
            case Category_MusicVideo:
            case Category_Ringtone:
            case Category_HomeVideo:
            case Category_PodCasts:
            case Category_iTunesU:
                
                if ([_convertedMediaDic.allKeys containsObject:@"media"]) {
                    NSMutableArray *arr = [[_convertedMediaDic objectForKey:@"media"] mutableCopy];
                    [arr addObjectsFromArray:[_srcExportDic objectForKey:[NSNumber numberWithInt:model.categoryNodes]]];
                    [_convertedMediaDic setObject:arr forKey:@"media"];
                    [arr release];
                }
                else{
                    NSMutableArray *arr = [NSMutableArray array];
                    [arr addObjectsFromArray:[_srcExportDic objectForKey:[NSNumber numberWithInt:model.categoryNodes]]];
                    [_convertedMediaDic setObject:arr forKey:@"media"];
                }
                break;
                
                 //按照照片方式进行处理
            case Category_LivePhoto:
            case Category_Screenshot:
            case Category_PhotoSelfies:
            case Category_Location:
            case Category_Favorite:
            case Category_CameraRoll:
            case Category_PhotoStream:
            case Category_PhotoLibrary:
            case Category_PhotoShare:
            case Category_PhotoVideo:
            case Category_MyAlbums:
            case Category_Panoramas:
            case Category_ContinuousShooting:
            case Category_TimeLapse:
            case Category_SlowMove:
            {
                
                if ([_convertedMediaDic.allKeys containsObject:@"media_photo"]) {
                    NSArray *photoEntities = [_srcExportDic objectForKey:[NSNumber numberWithInt:model.categoryNodes]];
                    if (photoEntities.count == 0) {
                        break;
                    }
                    NSMutableArray *arr = [[_convertedMediaDic objectForKey:@"media_photo"] mutableCopy];
                    [arr addObjectsFromArray:photoEntities];
                    [_convertedMediaDic setObject:arr forKey:@"media_photo"];
                    [arr release];
                }
                else{
                    NSArray *photoEntities = [_srcExportDic objectForKey:[NSNumber numberWithInt:model.categoryNodes]];
                    if (photoEntities.count == 0) {
                        break;
                    }
                    NSMutableArray *arr = [NSMutableArray array];
                    [arr addObjectsFromArray:photoEntities];
                    [_convertedMediaDic setObject:arr forKey:@"media_photo"];
                }
            }
                break;
            case Category_VoiceMemos:
                if ([_convertedMediaDic.allKeys containsObject:@"media_voicememo"]) {
                    NSArray *photoEntities = [_srcExportDic objectForKey:[NSNumber numberWithInt:model.categoryNodes]];
                    if (photoEntities.count == 0) {
                        break;
                    }
                    NSMutableArray *arr = [[_convertedMediaDic objectForKey:@"media_voicememo"] mutableCopy];
                    [arr addObjectsFromArray:photoEntities];
                    [_convertedMediaDic setObject:arr forKey:@"media_voicememo"];
                    [arr release];
                }
                else{
                    NSArray *photoEntities = [_srcExportDic objectForKey:[NSNumber numberWithInt:model.categoryNodes]];
                    if (photoEntities.count == 0) {
                        break;
                    }
                    NSMutableArray *arr = [NSMutableArray array];
                    [arr addObjectsFromArray:photoEntities];
                    [_convertedMediaDic setObject:arr forKey:@"media_voicememo"];
                }
                break;
                //按照图书的方式进行处理
            case Category_iBooks:{
                NSArray *array = [_srcExportDic objectForKey:[NSNumber numberWithInt:Category_iBooks]];
                if(array != nil && array.count != 0){
                    if ([_convertedMediaDic.allKeys containsObject:@"media_book"]) {
                        NSArray *bookEntities = [_srcExportDic objectForKey:[NSNumber numberWithInt:model.categoryNodes]];
                        NSPredicate *bookPredicate = [NSPredicate predicateWithFormat:@"extension CONTAINS[cd] %@",@"pdf"];
                        NSArray *newPdfEntitites = [bookEntities filteredArrayUsingPredicate:bookPredicate];
                        if ([newPdfEntitites count]>0) {
                            NSMutableArray *arr = [[_convertedMediaDic objectForKey:@"media_book"] mutableCopy];
                            [arr addObjectsFromArray:newPdfEntitites];
                            
                            [_convertedMediaDic setObject:arr forKey:@"media_book"];
                            [arr release];
                        }
                       
                    }
                    else{
                        NSArray *bookEntities = [_srcExportDic objectForKey:[NSNumber numberWithInt:model.categoryNodes]];
                        NSPredicate *bookPredicate = [NSPredicate predicateWithFormat:@"extension CONTAINS[cd] %@",@"pdf"];
                        NSArray *newPdfEntitites = [bookEntities filteredArrayUsingPredicate:bookPredicate];
                        
                        if (newPdfEntitites.count > 0) {
                            NSMutableArray *arr = [NSMutableArray array];
                            [arr addObjectsFromArray:newPdfEntitites];
                            [_convertedMediaDic setObject:arr forKey:@"media_book"];                        }
                        
                    }
                    
                    if ([_convertedMediaDic.allKeys containsObject:@"media_book"]) {
                        NSArray *bookEntities = [_srcExportDic objectForKey:[NSNumber numberWithInt:model.categoryNodes]];
                        NSPredicate *bookPredicate = [NSPredicate predicateWithFormat:@"extension CONTAINS[cd] %@",@"epub"];
                        NSArray *newepubEntitites = [bookEntities filteredArrayUsingPredicate:bookPredicate];
                        if (newepubEntitites.count > 0) {
                            NSMutableArray *arr = [[_convertedMediaDic objectForKey:@"media_book"] mutableCopy];
                            [arr addObjectsFromArray:newepubEntitites];
                            [_convertedMediaDic setObject:arr forKey:@"media_book"];
                            [arr release];                        }
                        
                    }else{
                        NSArray *bookEntities = [_srcExportDic objectForKey:[NSNumber numberWithInt:model.categoryNodes]];
                        NSPredicate *bookPredicate = [NSPredicate predicateWithFormat:@"extension CONTAINS[cd] %@",@"epub"];
                        NSArray *newepubEntitites = [bookEntities filteredArrayUsingPredicate:bookPredicate];
                        
                        if (newepubEntitites.count > 0) {
                            NSMutableArray *arr = [NSMutableArray array];
                            [arr addObjectsFromArray:newepubEntitites];
                            [_convertedMediaDic setObject:arr forKey:@"media_book"];                        }
                       
                    }

                    
//                    NSPredicate *bookPredicate = [NSPredicate predicateWithFormat:@"extension CONTAINS[cd] %@",@"epub"];
//                    NSArray *epubArr = [array filteredArrayUsingPredicate:bookPredicate];
//                    _toDeviceBookArr = [epubArr mutableCopy];
                }
            }
                break;
                //按照playlist方式进行处理,率先处理playlist吗
            case Category_Playlist:
            {
                if (isClone) {
                    NSArray *playlists = [_srcExportDic objectForKey:[NSNumber numberWithInt:Category_Playlist]];
                    if (playlists.count > 0) {
                        //仅选择了playlist，没有选择track
                        if (_selectedArr.count != 0) {
                            if (![_convertedMediaDic.allKeys containsObject:@"media"]) {
                                NSMutableArray *trackList = [NSMutableArray array];
                                for (IMBPlaylist *item in playlists) {
                                    if (item.tracks != nil && item.tracks.count > 0) {
                                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@",_selectedArr];
                                        NSArray *result = [item.tracks filteredArrayUsingPredicate:predicate];
                                        [trackList addObjectsFromArray:result];
                                        
                                    }
                                }
                                [_convertedMediaDic setObject:trackList forKey:@"media"];
                            }
                            [_convertedMediaDic setObject:playlists forKey:@"playlist"];
                            
                        }
                        else{
                            //选择的是在某一个playlist中的track(仅限制在一个playlist列表)
                            if (isClone) {
                                
                                NSMutableArray *trackList = [NSMutableArray array];
                                for (IMBPlaylist *item in playlists) {
                                    [trackList addObjectsFromArray:item.betweenDeviceCopyableTrackList];
                                }
                                
                                NSArray *array = [_convertedMediaDic objectForKey:@"media"];
                                if ([array count]>0) {
                                    NSMutableArray *mediaArray = [NSMutableArray array];
                                    [mediaArray addObjectsFromArray:trackList];
                                    [mediaArray addObjectsFromArray:array];
                                    [_convertedMediaDic setObject:mediaArray forKey:@"media"];
                                }else
                                {
                                    [_convertedMediaDic setObject:trackList forKey:@"media"];
                                }
                            }else
                            {
                                NSMutableArray *trackList = [NSMutableArray array];
                                for (IMBPlaylist *item in playlists) {
                                    if (item.tracks != nil && item.tracks.count > 0) {
                                        for (IMBTrack *track in item.tracks) {
                                            [trackList addObject:track];
                                        }
                                    }
                                }
                                [_convertedMediaDic setObject:trackList forKey:@"media"];
                            }
                            [_convertedMediaDic setObject:playlists forKey:@"playlist"];
                        }
                    }

                }else
                {
                    NSArray *playlists = [_srcExportDic objectForKey:[NSNumber numberWithInt:Category_Playlist]];
                    if (playlists.count > 0) {
                        //仅选择了playlist，没有选择track
                        if (_selectedArr.count != 0) {
                            if (![_convertedMediaDic.allKeys containsObject:@"media"]) {
                                NSMutableArray *trackList = [NSMutableArray array];
                                for (IMBPlaylist *item in playlists) {
                                    if (item.tracks != nil && item.tracks.count > 0) {
                                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@",_selectedArr];
                                        NSArray *result = [item.tracks filteredArrayUsingPredicate:predicate];
                                        [trackList addObjectsFromArray:result];
                                        
                                    }
                                }
                                [_convertedMediaDic setObject:trackList forKey:@"media"];
                            }
                            [_convertedMediaDic setObject:playlists forKey:@"playlist"];
                            
                        }
                        else{
                            //选择的是在某一个playlist中的track(仅限制在一个playlist列表)
                            if (![_convertedMediaDic.allKeys containsObject:@"media"]) {
                                NSMutableArray *trackList = [NSMutableArray array];
                                if (isClone) {
                                    for (IMBPlaylist *item in playlists) {
                                        [trackList addObjectsFromArray:item.betweenDeviceCopyableTrackList];
                                    }
                                    
                                }else
                                {
                                    for (IMBPlaylist *item in playlists) {
                                        if (item.tracks != nil && item.tracks.count > 0) {
                                            for (IMBTrack *track in item.tracks) {
                                                [trackList addObject:track];
                                            }
                                        }
                                    }
                                }
                                
                                [_convertedMediaDic setObject:trackList forKey:@"media"];
                            }
                            [_convertedMediaDic setObject:playlists forKey:@"playlist"];
                            
                        }
                    }

                }
                
            }
                break;
                //按照application方式进行处理
            case Category_Applications:
                //暂时不处理
            {
                NSArray *applications = [_srcExportDic objectForKey:[NSNumber numberWithInt:Category_Applications]];
                _toDeviceAppArr = [applications mutableCopy];
            }
                break;
            case Category_Contacts:{
                NSArray *array = [_srcExportDic objectForKey:[NSNumber numberWithInt:Category_Contacts]];
                if (array.count > 0) {
                    [_toDeviceInforDic setObject:array forKey:@"contact"];
                }
            }
                break;
            case Category_Notes:
            {
                NSArray *array = [_srcExportDic objectForKey:[NSNumber numberWithInt:Category_Notes]];
                if (array.count > 0) {
                    [_toDeviceInforDic setObject:array forKey:@"note"];
                }
            }
                break;
            case Category_Bookmarks:
            {
                NSArray *array = [_srcExportDic objectForKey:[NSNumber numberWithInt:Category_Bookmarks]];
                if (array.count > 0) {
                    [_toDeviceInforDic setObject:array forKey:@"bookmarks"];
                }
            }
                break;
            default:
                break;
        }
    }
    _infomationCount = [self totalInforsItemCount] + [self totalAppsItemCount] + [self totalEpubBooksItemCount];
    _totalItem = [self totalMediasItemCount] + _infomationCount;
}

- (void)startProgress{
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transferDelegate transferPrepareFileStart:CustomLocalizedString(@"iCloud_id_10", nil)];
    }
    if (_isAll) {
        [self filterToNoRepeatItems];
    }
    else{
        [self filterToPartNoRepeatItems];
    }
    [self prepareDataWithSelectedModels];
    [self prepareAndStartToDeviceDataMedia];
}

//程序入口
- (void)startTransfer
{
    if (isClone) {
        [self filterToNoRepeatItems];
        [self prepareDataWithSelectedModels];
        [self prepareAndStartToDeviceDataMedia];
    }else {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_transferDelegate transferPrepareFileStart:@"Preparing Transfer..."];
        }
        [self startProgress];
    }
}

- (void)prepareAndStartToDeviceDataMedia{
    [self toDeviceMedias];
    //书籍各种列表暂时未定
}

- (void)copyingNoneMediaData{
    if(_toDeviceInforDic != nil && _toDeviceInforDic.count > 0){
        if (!isClone) {
             [self toInformationDevice];
        }
       
    }
    if (_toDeviceAppArr != nil && _toDeviceAppArr.count > 0) {
        [self toAppDevice];
    }
    if (_toDeviceBookArr != nil && _toDeviceBookArr.count > 0) {
        [self toBookDevice];
    }
}

- (void)toBookDevice{
    if (_isStop) {
        return;
    }
    if (_toDeviceBookArr.count > 0) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
            [_transferDelegate transferPrepareFileStart:CustomLocalizedString(@"ImportSync_id_18", nil)];
        }
        _bookTransProgress = [[IMBBookToDevice alloc] initWithSrcIpod:_srcIpod desIpod:_ipod bookList:_toDeviceBookArr Delegate:_deviceTransfer];
        if ([_bookTransProgress prepareData]) {
            [_bookTransProgress startTransfer];
        }
    }
}

- (void)toAppDevice{
    if (_isStop) {
        return;
    }
    //app导入方式暂时未定
//    if (_toDeviceAppArr.count > 0 && _appsTransProgress != nil) {
//            _appsTransProgress = [[IMBAppBetweenDeviceInstall alloc] initWithIPodKey:_srcIpod.uniqueKey TariPodKey:_desIpod.uniqueKey AppInfos:toDeviveApps ArchiveType:appConfig.appExportToDeviceType];
//        if ([_appsTransProgress beforeProgress]) {
//            [self postChangeToCopyingPage];
//            [_appsTransProgress doProgress];
//        }
//    }
}

- (void)toInformationDevice{
    for (NSString *item in _toDeviceInforDic.allKeys) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            break;
        }
        NSArray *infoArr = [_toDeviceInforDic objectForKey:item];
        if (infoArr.count == 0){
            continue;
        }
    }
//        if ([item isEqualToString:@"contact"]) {
//            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
//                [_transferDelegate transferPrepareFileStart:CustomLocalizedString(@"ImportSync_id_15", nil)];
//            }
//            IMBContactManager *contactManager = [[IMBContactManager alloc] initWithAMDevice:_ipod.deviceHandle];
//            for (IMBContactEntity *contactEntity in infoArr) {
//                [_condition lock];
//                if (_isPause) {
//                    [_condition wait];
//                }
//                [_condition unlock];
//                if (_isStop) {
//                    break;
//                }
//                if (_limitation.remainderCount == 0) {
//                    break;
//                }
//                [_deviceTransfer sendCopyProgress:0];
//                if (![TempHelper stringIsNilOrEmpty:contactEntity.allName]) {
//                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),contactEntity.allName];
//                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
//                        [_transferDelegate transferFile:msgStr];
//                    }
//                }
//                [contactManager openMobileSync];
//                [contactManager insertContact:contactEntity];
//                [contactManager closeMobileSync];
//                [_limitation reduceRedmainderCount];
//                [_deviceTransfer setSuccessCount];
//            }
//            [contactManager release];
//        }
//        else if([item isEqualToString:@"note"]){
//            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
//                [_transferDelegate transferPrepareFileStart:CustomLocalizedString(@"ImportSync_id_16", nil)];
//            }
//            IMBNotesManager *noteManger = [[IMBNotesManager alloc] initWithAMDevice:_ipod.deviceHandle];
//            for (IMBNoteModelEntity *notesEntity in infoArr) {
//                [_condition lock];
//                if (_isPause) {
//                    [_condition wait];
//                }
//                [_condition unlock];
//                if (_isStop) {
//                    break;
//                }
//                if (_limitation.remainderCount == 0) {
//                    break;
//                }
//                [_deviceTransfer sendCopyProgress:0];
//                if (![TempHelper stringIsNilOrEmpty:notesEntity.title]) {
//                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),notesEntity.title];
//                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
//                        [_transferDelegate transferFile:msgStr];
//                    }
//                }
//
//                [noteManger openMobileSync];
//                [noteManger insertNote:notesEntity];
//                [noteManger closeMobileSync];
//                [_limitation reduceRedmainderCount];
//                [_deviceTransfer setSuccessCount];
//            }
//            [noteManger release];
//        }
//        else if([item isEqualToString:@"bookmarks"]){
//            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
//                [_transferDelegate transferPrepareFileStart:CustomLocalizedString(@"ImportSync_id_17", nil)];
//            }
//            IMBBookmarksManager *bookmarkManager = [[IMBBookmarksManager alloc] initWithAMDevice:_ipod.deviceHandle];
//            for (IMBBookmarkEntity *bookmarkEntity in infoArr) {
//                [_condition lock];
//                if (_isPause) {
//                    [_condition wait];
//                }
//                [_condition unlock];
//                if (_isStop) {
//                    break;
//                }
//                if (_limitation.remainderCount == 0) {
//                    break;
//                }
//
//                [_deviceTransfer sendCopyProgress:0];
//                if (![TempHelper stringIsNilOrEmpty:bookmarkEntity.name]) {
//                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),bookmarkEntity.name];
//                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
//                        [_transferDelegate transferFile:msgStr];
//                    }
//                }
//                [bookmarkManager openMobileSync];
//                if (_isAll) {
//                    [bookmarkManager insertBookmarks:[NSArray arrayWithObject:bookmarkEntity]];
//                }else{
//                    [bookmarkManager insertBookmark:bookmarkEntity NeedParent:NO];
//
//                }
//                [bookmarkManager closeMobileSync];
//                [_deviceTransfer setSuccessCount];
//                [_limitation reduceRedmainderCount];
//
//            }
//            [bookmarkManager release];
//        }
//    }
    sleep(1);
}

- (int)totalMediasItemCount{
    /*这里不包含epub的数量*/
    int i = 0;
    NSMutableDictionary *dictionary = [_convertedMediaDic mutableCopy];
    [dictionary removeObjectsForKeys:@[@"playlist"]];
    NSArray *mediaArr = dictionary.allValues;
    for (NSArray *itemsArr in mediaArr) {
        i += itemsArr.count;
    }
    return i;
}

- (int)totalInforsItemCount{
    int i = 0;
    NSArray *infoArr = _toDeviceInforDic.allValues;
    for (NSArray *itemArr in infoArr) {
        i+= itemArr.count;
    }
    return i;
}

- (int)totalEpubBooksItemCount{
    return _toDeviceBookArr.count;
}

- (int)totalAppsItemCount{
    return _toDeviceAppArr.count;
}

- (void)toDeviceMedias{
    BOOL isSyncDevice = [self CheckIsSyncDevice];
    [_loghandle writeInfoLog:[NSString stringWithFormat:@"is Sync Device:%d",isSyncDevice]];
    if (isSyncDevice) {
        _deviceTransfer = [[IMBAirSyncImportBetweenDeviceTransfer alloc] initWithIPodkey:_srcIpod.uniqueKey TarIPodKey:_ipod.uniqueKey itemsToTransfer:_convertedMediaDic photoAlbum:_albumEntity playlistID:0 delegate:_transferDelegate];
        [_deviceTransfer setCondition:_condition];
        [_deviceTransfer setTotalItem:_totalItem];
        [_deviceTransfer setInfomationCount:_infomationCount];
        [_deviceTransfer setDelegate:self];
    }
    else{
        _deviceTransfer = [[IMBNotAirSyncImportBetweenDeviceTransfer alloc] initWithIPodkey:_srcIpod.uniqueKey TarIPodKey:_ipod.uniqueKey itemsToTransfer:_convertedMediaDic photoAlbum:_albumEntity playlistID:0 delegate:_transferDelegate];
        [_deviceTransfer setCondition:_condition];
        [_deviceTransfer setDelegate:self];
    }
    [_deviceTransfer startTransfer];
}

- (BOOL)CheckIsSyncDevice
{
    if (_ipod == nil)
    {
        return false;
    }
    if (_ipod.deviceInfo.isIOSDevice)
    {
        return [_ipod.deviceInfo.productVersion isVersionMajorEqual:@"5.0"];
    }
    else
    {
        return false;
    }
}

#pragma mark - 各种释放
- (void)dealloc{
    if (_albumEntity != nil) {
        [_albumEntity release];
        _albumEntity = nil;
    }
    if (_selectModels != nil) {
        [_selectModels release];
        _selectModels = nil;
    }
    if (_srcIpod != nil) {
        [_srcIpod release];
        _srcIpod = nil;
    }
    if (_convertedMediaDic != nil) {
        [_convertedMediaDic release];
        _convertedMediaDic = nil;
    }
    if (_srcExportDic != nil){
        [_srcExportDic release];
        _srcExportDic = nil;
    }
    
    if(_toDeviceInforDic != nil){
        [_toDeviceInforDic release];
        _toDeviceInforDic = nil;
    }
    
    if (_selectedArr != nil) {
        [_selectedArr release];
        _selectedArr = nil;
    }
    
    if (_toDeviceAppArr != nil){
        [_toDeviceAppArr release];
        _toDeviceAppArr = nil;
    }
    
    if (_toDeviceBookArr != nil) {
        [_toDeviceBookArr release];
        _toDeviceBookArr = nil;
    }
    
    if (_bookTransProgress != nil) {
        [_bookTransProgress release];
        _bookTransProgress = nil;
    }
    
    if (_playlistArray != nil) {
        [_playlistArray release];
        _playlistArray = nil;
    }
    if (_deviceTransfer != nil) {
        [_deviceTransfer release];
        _deviceTransfer = nil;
    }
    [super dealloc];
}

#pragma mark - 各种验证重复性
//验证album是否重复
//不验重
- (void)verifyRepeatAlbumsBySrcDic:(NSMutableDictionary *)srcExportDic desDic:(NSMutableDictionary *)desExportDic{
    return;
    NSDictionary *srcDic = [srcExportDic objectForKey:[NSNumber numberWithInt:Category_MyAlbums]];
    NSDictionary *desDic = [desExportDic objectForKey:[NSNumber numberWithInt:Category_MyAlbums]];
    if (srcDic.count == 0) {
        return;
    }
    
    //TODO:判断album是否重复。比较album的名字
    NSArray *srcKeyArray = srcDic.allKeys;
    NSArray *desKeyArray = desDic.allKeys;
    NSMutableArray *tarArray = [NSMutableArray array];
    for (NSNumber *srcNumber in srcKeyArray) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            break;
        }
        NSArray *srcArray = [srcExportDic objectForKey:srcNumber];
        IMBPhotoEntity *srcEntity = [srcArray objectAtIndex:0];
        BOOL canBeAdded = YES;
        for (NSNumber *desNumber in desKeyArray) {
            if (!canBeAdded) {
                break;
            }
            NSArray *desArray = [desExportDic objectForKey:desNumber];
            IMBPhotoEntity *desEntity = [desArray objectAtIndex:0];
            if ([srcEntity.albumTitle isEqualToString:desEntity.albumTitle]) {
//                canBeAdded = NO;//两个设备用相同名字的相册，过滤掉；
                canBeAdded = YES; //不过滤;
            }
        }
        if (canBeAdded) {
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:srcArray,srcNumber, nil];
            [tarArray addObject:dictionary];
        }
    }
    [srcExportDic setObject:tarArray forKey:[NSNumber numberWithInt:Category_MyAlbums]];
}

//验证app是否重复
- (void)verifyRepeatAppBySrcDic:(NSMutableDictionary *)srcExportDic desDic:(NSMutableDictionary *)desExportDic{
    NSArray *srcAppEntities = [srcExportDic objectForKey:[NSNumber numberWithInt:Category_Applications]];
    NSArray *desAppEntities = [desExportDic objectForKey:[NSNumber numberWithInt:Category_Applications]];
    if (srcAppEntities.count == 0) {
        return;
    }
    
    NSMutableArray *tarAppEntities = [NSMutableArray array];
    for (IMBAppEntity *srcAppEntity in srcAppEntities) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            break;
        }
        BOOL canBeAdded = true;
         /*
        for (IMBAppEntity *desAppEntity in desAppEntities) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
          
             if ([srcAppEntity.appName isEqualToString:desAppEntity.appName] && [srcAppEntity.appKey isEqualToString:desAppEntity.appKey]) {
             canBeAdded = false;
             break;
             //                _transResult.mediaIgnoreCount ++;
             //                [_transResult recordMediaResult:srcAppEntity.appName resultStatus:TransIgnore messageID:[NSString stringWithFormat:CustomLocalizedString(@"MSG_TranResult_Skiped_Existed", nil),srcAppEntity.appName]];
             
             }
           
        }
         */
        if (canBeAdded) {
            [tarAppEntities addObject:srcAppEntity];
        }
    }
    [srcExportDic setObject:tarAppEntities forKey:[NSNumber numberWithInt:Category_Applications]];
}

//验证联系人是否重复
//- (void)verifyContactsBySrcDic:(NSMutableDictionary *)srcExportDic desDic:(NSMutableDictionary *)desExportDic{
//    NSArray *srcContactEntities = [srcExportDic objectForKey:[NSNumber numberWithInt:Category_Contacts]];
//    NSArray *desContactEntities = [desExportDic objectForKey:[NSNumber numberWithInt:Category_Contacts]];
//    if (srcContactEntities.count == 0) {
//        return;
//    }
//    
//    
//    NSMutableArray *tarContactsArray = [NSMutableArray array];
//    for (IMBContactEntity *srcEntity in srcContactEntities) {
//        [_condition lock];
//        if (_isPause) {
//            [_condition wait];
//        }
//        [_condition unlock];
//        if (_isStop) {
//            break;
//        }
//        BOOL canBeAdded = YES;
//        for (IMBContactEntity *desEntity in desContactEntities) {
//            [_condition lock];
//            if (_isPause) {
//                [_condition wait];
//            }
//            [_condition unlock];
//            if (_isStop) {
//                break;
//            }
//            if ([srcEntity.firstName isEqualToString:desEntity.firstName] && [srcEntity.middleName isEqualToString:desEntity.middleName] && [srcEntity.lastName isEqualToString:desEntity.lastName]) {
//                canBeAdded = YES;
//                break;
//            }
//        }
//        if (canBeAdded) {
//            [tarContactsArray addObject:srcEntity];
//        }
//    }
//    [srcExportDic setObject:tarContactsArray forKey:[NSNumber numberWithInt:Category_Contacts]];
//}

//验证指定类目的track是否重复
- (void)verifyTrackBySrcDic:(NSMutableDictionary *)srcExportDic desDic:(NSMutableDictionary *)desExportDic inSpecifyCategorys:(NSArray *)categorys{
    for (NSNumber *number in categorys) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            break;
        }
        NSArray *_srcTracks = [srcExportDic objectForKey:number];
        NSArray *_desTracks = [desExportDic objectForKey:number];
        if (_srcTracks.count == 0) {
            continue;
        }
        
        NSMutableArray *tarArray = [NSMutableArray array];
        for (IMBTrack *track in _srcTracks) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"title == %@ && album == %@ && artist == %@", track.title, track.album, track.artist];
            NSArray *newArr = [_desTracks filteredArrayUsingPredicate:pre];
            if (newArr.count == 0) {
                [tarArray addObject:track];
            }
            else{
//                _transResult.mediaIgnoreCount ++;
//                [_transResult recordMediaResult:track.title resultStatus:TransIgnore messageID:[NSString stringWithFormat:CustomLocalizedString(@"MSG_TranResult_Skiped_Existed", nil),track.title]];

            }
        }
        [srcExportDic setObject:tarArray forKey:number];
    }
}

//进行plist验证是否重复
//TODO:效率问题如何提升
- (void)verifyRepeatPlistBySrcDic:(NSMutableDictionary *)srcExportDic desDic:(NSMutableDictionary *)desExportDic{
   
    if ([srcExportDic.allKeys containsObject:[NSNumber numberWithInt:Category_Playlist]]) {
        
        NSArray *srcplistArr = [srcExportDic objectForKey:[NSNumber numberWithInt:Category_Playlist]];
        NSArray *desplistArr = [desExportDic objectForKey:[NSNumber numberWithInt:Category_Playlist]];
        NSMutableArray *totalExistingTrack = [NSMutableArray array];
        if (desplistArr.count != 0) {
            //目标数组,存放的是IMBPlayList
            NSMutableArray *targetArr = [NSMutableArray array];
            for (IMBPlaylist *srcplist in srcplistArr) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                //验证playlist的名字是否相同
                NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    IMBPlaylist *playlist = evaluatedObject;
                    if ([playlist.name isEqualToString:srcplist.name]) {
                        return YES;
                    }else
                    {
                        return NO;
                    }
                   
                }];
                //目的设备中的同名数组
                NSArray *sameNameArr = [desplistArr filteredArrayUsingPredicate:predicate];
               if (sameNameArr.count == 0) {
                    //存放可以被添加到playlist中的track
                    NSMutableArray *tarArr = [NSMutableArray array];
                    for (IMBTrack *track in srcplist.tracks) {
                        if (isClone) {
                            [tarArr addObject:track];
                            [totalExistingTrack addObject:track];
                        }else
                        {
                            NSPredicate *pre = [NSPredicate predicateWithFormat:@"title == %@ && album == %@ && artist == %@", track.title, track.album, track.artist];
                            NSArray *compArr = [totalExistingTrack filteredArrayUsingPredicate:pre];
                            if (compArr.count == 0) {
                                [tarArr addObject:track];
                                [totalExistingTrack addObject:track];
                            }
                        }
                   }
                   if (srcplist.isMaster) {
//                       for (IMBPlaylist *srcplist in srcplistArr){
                           if (srcplist.isUserDefinedPlaylist) {
                               [tarArr removeObjectsInArray:srcplist.tracks];
                           }
//                        }
                       

                        for (IMBTrack *track in srcplist.tracks) {
                            if (!(track.mediaType == AudioAndVideo||track.mediaType == Audio)) {
                                [tarArr removeObject:track];
                            }
                         
                         }
                    }
                   
                   [srcplist setBetweenDeviceCopyableTrackList:tarArr];
                   [targetArr addObject:srcplist];
               }
                else{
                    //存放可以被添加到playlist中的track
                    NSMutableArray *copyAbleTrackList = [[NSMutableArray alloc] init];
                    for (IMBTrack *track in srcplist.tracks) {
                        BOOL canCopy = YES;
                        for (IMBPlaylist *desplist in sameNameArr) {
                            if (!canCopy) {
//                                _transResult.mediaIgnoreCount ++;
//                                [_transResult recordPlaylistReult:track.title resultStatus:TransIgnore messageID:[NSString stringWithFormat:CustomLocalizedString(@"MSG_TranResult_Skiped_Existed", nil),track.title]];
                                break;
                            }
                            //比较的是同名playlist中的Track是否相同
                            NSPredicate *trackPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                IMBTrack *desTrack = evaluatedObject;
                                if ([desTrack.artist isEqualToString:track.artist] && [desTrack.album isEqualToString:track.album] && [desTrack.title isEqualToString:track.title]) {
                                    return YES;
                                }
                                return NO;
                            }];
                            
                            
                            NSArray *trackArr = [desplist.tracks filteredArrayUsingPredicate:trackPredicate];
                            if (trackArr.count > 0) {
                                canCopy = NO;
                            }
                        }
                        //不相同
                        if (canCopy) {
                            //比较是否已经添加
                            NSPredicate *pre = [NSPredicate predicateWithFormat:@"title == %@ && album == %@ && artist == %@", track.title, track.album, track.artist];
                            NSArray *compArr = [totalExistingTrack filteredArrayUsingPredicate:pre];
                            if (compArr.count == 0 ) {
                                //没有添加,则添加到可以被复制的列表中去。
                                [copyAbleTrackList addObject:track];
                                [totalExistingTrack addObject:track];
                            }
                        }
                    }
                    if (isClone) {
                        if (srcplist.isMaster) {
                            for (IMBPlaylist *srcplist in srcplistArr){
                                if (srcplist.isUserDefinedPlaylist) {
                                    [copyAbleTrackList removeObjectsInArray:srcplist.tracks];
                                }
                            }
                            for (IMBTrack *track in srcplist.tracks) {
                                if (!(track.mediaType == AudioAndVideo||track.mediaType == Audio)) {
                                    [copyAbleTrackList removeObject:track];
                                }
                                
                            }
                        }else
                        {
                            [copyAbleTrackList addObjectsFromArray:srcplist.tracks];
                        }
                    }
                    
                    [srcplist setBetweenDeviceCopyableTrackList:copyAbleTrackList];
                    [targetArr addObject:srcplist];
                    [copyAbleTrackList release];
                }
            }
            if (targetArr.count > 0) {
                [srcExportDic setObject:targetArr forKey:[NSNumber numberWithInt:Category_Playlist]];
            }
        }else
        {
             for (IMBPlaylist *srcplist in srcplistArr) {
                 [_condition lock];
                 if (_isPause) {
                     [_condition wait];
                 }
                 [_condition unlock];
                 if (_isStop) {
                     break;
                 }
                 if (srcplist.isMaster) {
                     NSMutableArray *copyAbleTracList = [NSMutableArray array];
                     if (!srcplist.isUserDefinedPlaylist) {//修改过后的
                         [copyAbleTracList addObjectsFromArray:srcplist.tracks];
                     }
//                     for (IMBPlaylist *srcplist in srcplistArr){
//                         if (srcplist.isUserDefinedPlaylist) {
//                             [copyAbleTracList removeObjectsInArray:srcplist.tracks];
//                         }
//                     }
                     
                     
                     for (IMBTrack *track in srcplist.tracks) {
                         if (!(track.mediaType == AudioAndVideo||track.mediaType == Audio)) {
                             [copyAbleTracList removeObject:track];
                         }
                         
                     }
                     [srcplist setBetweenDeviceCopyableTrackList:copyAbleTracList];

                     
                 }else
                 {
                     [srcplist setBetweenDeviceCopyableTrackList:srcplist.tracks];
                 }
                 
             }
        }
    }
}

- (void)pauseScan {
    [_condition lock];
    if(!_isPause)
    {
        _isPause = YES;
        if (_deviceTransfer != nil) {
            [_deviceTransfer setIsPause:YES];
        }
    }
    [_condition unlock];
}

- (void)resumeScan {
    [_condition lock];
    if(_isPause)
    {
        _isPause = NO;
        if (_deviceTransfer != nil) {
            [_deviceTransfer setIsPause:NO];
        }
        [_condition signal];
    }
    [_condition unlock];
}

- (void)stopScan {
    [_condition lock];
    _isStop = YES;
    if (_deviceTransfer != nil) {
        [_deviceTransfer setIsStop:YES];
    }
    if (_bookTransProgress != nil) {
        [_bookTransProgress setIsStop:YES];
    }
    [_condition signal];
    [_condition unlock];
}

@end
