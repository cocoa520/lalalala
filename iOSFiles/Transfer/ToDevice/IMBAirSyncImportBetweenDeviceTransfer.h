//
//  IMBAirSyncImportBetweenDeviceTransfer.h
//  AnyTrans
//
//  Created by iMobie on 8/22/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBBaseTransfer.h"
#import "IMBPhotoEntity.h"
#import "IMBTrack.h"
#import "IMBPlaylist.h"
#import "IMBATHSync.h"
#import "DriveItem.h"
typedef struct {
    IMBPlaylist *SrcPlist;
    IMBPlaylist *DesPlist;
}SrcDesPlistPair;

@interface IMBAirSyncImportBetweenDeviceTransfer : IMBBaseTransfer<ATHCopyFileToDeviceListener> {
    IMBiPod *_srciPod;
    NSMutableArray *_importFiles;
    NSMutableArray *_categoryNodesEnums;
    int64_t _playlistID;
    IMBPhotoEntity *_importPhotoAlbum;
    NSDictionary *_transferItemsDic;
    //同步类
    IMBATHSync *_athSync;
    int _infomationCount;
    id _delegate;
    DriveItem *_driveItem;
}
@property (nonatomic, retain) DriveItem *driveItem;
@property (nonatomic, readwrite) int infomationCount;
@property (nonatomic, assign) id delegate;

- (id)initWithIPodkey:(NSString *)srciPodKey TarIPodKey:(NSString *)tariPodKey itemsToTransfer:(NSDictionary *)items photoAlbum:(IMBPhotoEntity *)photoAlbum playlistID:(long)playlistID delegate:(id)delegate;
- (void)prepareAllItemsAndCategories;
- (NSMutableArray *)prepareAllTrack;
- (void)setSuccessCount;
- (void)copyWordProgress:(NSString *)workStr;

@end
