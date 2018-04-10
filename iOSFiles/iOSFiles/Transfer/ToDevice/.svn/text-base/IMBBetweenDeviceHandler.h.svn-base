//
//  IMBBetweenDeviceHandler.h
//  iMobieTrans
//
//  Created by iMobie on 8/8/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "IMBBookToDevice.h"
#import "IMBCategoryInfoModel.h"
//#import "IMBAppBetweenDeviceInstall.h"
#import "IMBAirSyncImportBetweenDeviceTransfer.h"
#import "IMBNotAirSyncImportBetweenDeviceTransfer.h"
#import "IMBBookToDevice.h"

@class IMBPhotoEntity;

@interface IMBBetweenDeviceHandler : IMBBaseTransfer
{
    IMBAirSyncImportBetweenDeviceTransfer *_deviceTransfer;
    IMBBookToDevice *_bookTransProgress;
    BOOL _threadBreak;
    IMBiPod *_srcIpod;
    NSArray *_selectModels;
    NSMutableDictionary *_convertedMediaDic;
    NSMutableDictionary *_srcExportDic;
    NSMutableDictionary *_toDeviceInforDic;
    NSMutableArray *_toDeviceAppArr;
    NSMutableArray *_toDeviceBookArr;
    //部分导入时使用
    NSNotificationCenter *nc;
    NSArray *_selectedArr;
//    NSOperationQueue *_processQueue;
    BOOL _isAll;
    NSArray *_playlistArray;
    IMBPhotoEntity *_albumEntity;
//    IMBAppBetweenDeviceInstall *_appsTransProgress;
    int _infomationCount;
    BOOL isClone;
}

@property (assign,nonatomic,setter = setThreadBreak:) BOOL threadBreak;
@property (assign,nonatomic) BOOL isClone;
- (id)initWithSelectedModels:(NSArray *)selectModels srcIpodKey:(NSString *)srcIpodKey desIpodKey:(NSString *)desIpodKey Delegate:(id)delegate;
- (id)initWithSelectedArray:(DriveItem *)selectArrs categoryModel:(IMBCategoryInfoModel*)categoryModel srcIpodKey:(NSString *)srcIpodKey desIpodKey:(NSString *)desIpodKey withPlaylistArray:(NSArray *)playListArray albumEntity:(IMBPhotoEntity *)albumEntity Delegate:(id)delegate;
- (void)startProgress;

- (void)setThreadBreak:(BOOL)threadBreak;
- (void)filterToNoRepeatItems;
- (void)copyingNoneMediaData;

@end
