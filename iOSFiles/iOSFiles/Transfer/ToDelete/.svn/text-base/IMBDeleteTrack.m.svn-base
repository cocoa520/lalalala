//
//  IMBDeleteTrack.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-4.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBDeleteTrack.h"
#import "IMBDeviceInfo.h"
#import "IMBInformation.h"
#import "IMBInformationManager.h"
//#import "IMBBaseViewController.h"

@implementation IMBDeleteTrack

- (id)initWithIPod:(IMBiPod *)ipod deleteArray:(NSMutableArray *)deleteArray Category:(CategoryNodesEnum)category
{
    if (self = [super initWithIPod:ipod deleteArray:deleteArray]) {
        _categoryNodes = category;
        [self getAllKindCategoryNodes];
    }
    return self;
}

- (void)getAllKindCategoryNodes {
    _categoryNodesArray = [[NSMutableArray alloc] init];
    for (IMBTrack *track in _deleteArray) {
        if (track.mediaType == Ringtone && ![_categoryNodesArray containsObject:[NSNumber numberWithInt:Category_Ringtone]]) {
            [_categoryNodesArray addObject:[NSNumber numberWithInt:Category_Ringtone]];
        }
        else if ((track.mediaType == Books || track.mediaType == PDFBooks)&& ![_categoryNodesArray containsObject:[NSNumber numberWithInt:Category_iBooks]]) {
            [_categoryNodesArray addObject:[NSNumber numberWithInt:Category_iBooks]];
        }
        else if (track.mediaType == VoiceMemo && ![_categoryNodesArray containsObject:[NSNumber numberWithInt:Category_VoiceMemos]]){
            [_categoryNodesArray addObject:[NSNumber numberWithInt:Category_VoiceMemos]];
        }
        else if (track.mediaType == Photo && ![_categoryNodesArray containsObject:[NSNumber numberWithInt:Category_PhotoLibrary]] && (_categoryNodes == Category_PhotoLibrary||_categoryNodes == Category_LivePhoto||_categoryNodes == Category_Screenshot||_categoryNodes == Category_PhotoSelfies||_categoryNodes == Category_Location||_categoryNodes == Category_Favorite)) {
            [_categoryNodesArray addObject:[NSNumber numberWithInt:Category_PhotoLibrary]];
        }else if (track.mediaType == Photo && ![_categoryNodesArray containsObject:[NSNumber numberWithInt:Category_MyAlbums]] && _categoryNodes == Category_MyAlbums) {
            [_categoryNodesArray addObject:[NSNumber numberWithInt:Category_MyAlbums]];
        }else{
            if(track.mediaType != Ringtone && track.mediaType != Books&&track.mediaType!=PDFBooks&& track.mediaType != VoiceMemo && track.mediaType != Photo && ![_categoryNodesArray containsObject:[NSNumber numberWithInt:Category_Music]]){
                [_categoryNodesArray addObject:[NSNumber numberWithInt:Category_Music]];
            }
        }
    }
}


- (void)startDelete
{
    if ([_delegate respondsToSelector:@selector(setDeleteProgress:withWord:)]) {
        [_delegate setDeleteProgress:0 withWord:CustomLocalizedString(@"MSG_COM_Deleting", nil)];
    }
    int curIndex = 0;
    int success = 0;
    if ([_categoryNodesArray count] == 0) {
        return;
    }
    @try {
        for (IMBTrack *track in _deleteArray) {
            if (_isStop) {
                break;
            }
            curIndex ++;
            if (![TempHelper stringIsNilOrEmpty:track.title]) {
                if ([_delegate respondsToSelector:@selector(setDeleteProgress:withWord:)]) {
                    [_delegate setDeleteProgress:((float)curIndex/_deleteArray.count)*96 withWord:[NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Delete_Item", nil),track.title]];
                }
            }
            [self removeTrackByTrack:track];
            success++;
        }
        [_ipod startSync];
        if ([[_ipod deviceInfo] airSync]) {
            if (_isStop) {
                return;
            }
            success = [self startSyncDelete:((float)curIndex/_deleteArray.count)*96];
        }else{
            [_ipod saveChanges];
        }
        [_ipod endSync];
        if ([_delegate respondsToSelector:@selector(setDeleteProgress:withWord:)]) {
            [_delegate setDeleteProgress:100 withWord:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil)];
        }
    }
    @catch (NSException *exception) {
        [_logManager writeInfoLog:[NSString stringWithFormat:@"Category:%d DeleteTrack exception:%@",_categoryNodes,exception]];
    }
    if ([_delegate respondsToSelector:@selector(setDeleteComplete:totalCount:)]) {
        [_delegate setDeleteComplete:success totalCount:(int)_deleteArray.count];
    }
}

- (int)startSyncDelete:(float)pro
{
    BOOL _isDelRingtone = false;
    BOOL _isDelVoiceMemo = false;
    BOOL _isDelBook =false;
    BOOL _isDelMusic = false;
    BOOL _isDelPhoto = false;
    BOOL _isDelAlbum = false;
    IMBATHSync *athSync = nil;
    if ([_categoryNodesArray containsObject:[NSNumber numberWithInt:Category_Ringtone]] && _categoryNodesArray.count == 1) {
        athSync = [[IMBATHSync alloc] initWithiPod:_ipod SyncDeleteCategory:SyncDelteRingTone];
        _isDelRingtone = true;
    }
    else if([_categoryNodesArray containsObject:[NSNumber numberWithInt:Category_VoiceMemos]] && _categoryNodesArray.count == 1){
        athSync = [[IMBATHSync alloc] initWithiPod:_ipod SyncDeleteCategory:SyncDelteVoiceMemo];
        _isDelVoiceMemo = true;
    }
    else if([_categoryNodesArray containsObject:[NSNumber numberWithInt:Category_iBooks]] && _categoryNodesArray.count == 1){
        athSync = [[IMBATHSync alloc] initWithiPod:_ipod SyncDeleteCategory:SyncDelteBook];
        _isDelBook = true;
    }
    else if([_categoryNodesArray containsObject:[NSNumber numberWithInt:Category_Music]] && _categoryNodesArray.count == 1){
        athSync = [[IMBATHSync alloc] initWithiPod:_ipod SyncDeleteCategory:SyncDelteMedia];
        _isDelMusic = true;
    }
    else if ([_categoryNodesArray containsObject:[NSNumber numberWithInt:Category_PhotoLibrary]] && _categoryNodesArray.count == 1) {
        athSync = [[IMBATHSync alloc] initWithiPod:_ipod SyncDeleteCategory:SyncDeltePhotoLibrary];
        _isDelPhoto = true;
    }
    else if (([_categoryNodesArray containsObject:[NSNumber numberWithInt:Category_MyAlbums]]) && _categoryNodesArray.count == 1) {
        athSync = [[IMBATHSync alloc] initWithiPod:_ipod SyncDeleteCategory:SyncDeltePhotoAlbums];
        _isDelAlbum = true;
    }
    else{
        //to do 多个类型删除
        if(_categoryNodesArray.count > 1){
            //暂时不做
            NSMutableArray *array = [NSMutableArray array];
            for (NSNumber *categoryNode in _categoryNodesArray) {
                switch (categoryNode.intValue) {
                    case Category_Ringtone:
                        [array addObject:@(SyncDelteRingTone)];
                        break;
                    case Category_VoiceMemos:
                        [array addObject:@(SyncDelteVoiceMemo)];
                        break;
                    case Category_iBooks:
                        [array addObject:@(SyncDelteBook)];
                        break;
                    case Category_Music:
                        [array addObject:@(SyncDelteMedia)];
                        break;
                    case Category_PhotoLibrary:
                        [array addObject:@(SyncDeltePhotoLibrary)];
                        break;
                    case Category_MyAlbums:
                        [array addObject:@(SyncDeltePhotoAlbums)];
                        break;
                    case Category_LivePhoto:
                        [array addObject:@(SyncDeltePhotoLibrary)];
                        break;
                    case Category_Screenshot:
                        [array addObject:@(SyncDeltePhotoLibrary)];
                        break;
                    case Category_PhotoSelfies:
                        [array addObject:@(SyncDeltePhotoLibrary)];
                        break;
                    case Category_Location:
                        [array addObject:@(SyncDeltePhotoLibrary)];
                        break;
                    case Category_Favorite:
                        [array addObject:@(SyncDeltePhotoLibrary)];
                        break;
                        
                    default:
                        break;
                }
            }
            athSync = [[IMBATHSync alloc] initWithiPod:_ipod SyncDeleteCategoryArray:array];
        }
    }
    if (athSync == nil) {
        return 0;
    }
    if ([_delegate respondsToSelector:@selector(setDeleteProgress:withWord:)]) {
        [_delegate setDeleteProgress:pro withWord:CustomLocalizedString(@"ImportSync_id_1", nil)];
    }
    [athSync setCurrentThread:[NSThread currentThread]];
    [athSync setSyncTasks:_deleteArray];
    //开始同步
    int success = 0;
    if ([athSync createAirSyncService]) {
        if ([athSync sendRequestSync]) {
            if ([athSync createPlistAndCigSendDataSync]) {
                for (IMBTrack *track in _deleteArray) {
                    if (_isStop) {
                        break;
                    }
                    success ++;
                }
                [athSync startCopyData];
                [athSync waitSyncFinished];
                [_ipod saveChanges];
            }else{
                [athSync waitSyncFinished];
            }
        }
    }
    return success;
}

- (void)dealloc{
    [_categoryNodesArray release],_categoryNodesArray = nil;
    [super dealloc];
}
@end
