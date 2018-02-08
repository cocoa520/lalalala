//
//  IMBiTunesPrefs.h
//  iMobieTrans
//
//  Created by Pallas on 10/20/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBiPod.h"

@interface IMBiTunesPrefs : NSObject {
@private
    IMBiPod *_iPod;
    NSString *remoteiTunesPrefsPath;
    NSString *localiTunesPrefsPath;
    NSFileManager *fm;
    NSFileHandle *_fHandle;
    // 4 bit frpd
    NSData *_headerIdentifier;
    NSData *_unk1;
    NSData *_unk2;
    // 00 iTunes has not set up iPod,01 iTunes has not set up iPod.
    // Checked by iTunes to determine whether to present iPod set up dialog box.
    NSData *_iPodSetUpByte;
    // Open iTunes when iPod is Attached, 01 for checked.
    NSData *_openiTunesWhenAttachByte;
    // 00 appears to be "Manually manage my songs", 01 appears to be "Automatic Sync"
    NSData *_manualAutomaticSyncFlagByte;
    // 01 Entire Library, 02 Selected Playlists
    NSData *_syncTypeByte;
    // 8 byte identifier of the last iTunes library synced to this iPod. Checked by iTunes to prevent automatic updates when you connect the iPod to other computers with iTunes/Libraries
    NSData *_iTunesMusicLibraryLinkIdentifier;
    NSData *_unk3;
    NSData *_unk4;
    NSData *_unk5;
    NSData *_unk6;
    NSData *_unk7;
    NSData *_enableDiskUseByte;
    NSData *_unk8;
    NSData *_unk9;
    NSData *_updateCheckedByte;
    NSData *_unk10;
    NSData *_unk11;
    // 12 zero padding?
    NSData *_padding1;
    // 1 for Show Artwork in Ipod
    NSData *_showArtworkByte;
    // 2 zero padding?
    NSData *_padding2;
    // Synchronize Photos with iPod
    NSData *_synchronizePhotosByte;
    NSData *_unk12;
    // 1 for yes, 0 for no.
    NSData *_storeHiresPhotosOniPodByte;
    // 16 zero padding?
    NSData *_padding3;
    // 01 For Transcode higher bitrate songs to 128 AAC (Shuffle only)
    NSData *_transcodeByte;
    // Keep this ipod in the source list, 1 for true (Shuffle only?)
    NSData *_keepiPodInTheSourceListByte;
    // 15 A bunch of other flags?
    NSData *_unk13;
    // 0x01 = Sync All Podcasts, 0x02 = Sync Selected Podcasts Only
    NSData *_selectedPodcastSyncOnlyByte;
    // 0x00 = Manually Manage Podcasts (selected flag is meaningless in this case), 0x01 = Autosync podcasts
    NSData *_manualAutomaticPodcastSyncByte;
    // Five other flags?
    NSData *_unk14;
    // Same 8 byte ID as before
    NSData *_identifier;
    // Somehow related to the songs / disc space allowed on the shuffle. Setting filespace to 0 sets this to 0. (0x0000 for non-shuffles?)
    NSData *_songsOniPod;
    // Somehow related to the songs / disc space allowed on the shuffle. Setting filespace to 0 sets this to 0. (0x0000 for non-shuffles?)
    NSData *_filespaceSavedOniPod;
    // 8 zero padding?
    NSData *_padding4;
    // Various flags set when user checks
    NSData *_doNotAskAgainFlags;
    // 4 zero padding?
    NSData *_padding5;
    // Use sound Check (shuffle only setting? Perhaps for transcoding purposes?)
    NSData *_soundCheck;
    // 111 zero padding? undetermined flags?
    NSData *_padding6;
    
    BOOL _iPodSetUp;
    BOOL _openiTunesWhenAttach;
    BOOL _manualSyncFlag;
    int _syncType;
    BOOL _enableDiskUse;
    BOOL _updateChecked;
    BOOL _showArtwork;
    BOOL _synchronizePhotos;
    BOOL _storeHiresPhotosOniPod;
    BOOL _transcode;
    BOOL _keepiPodInTheSourceList;
    int _selectedPodcastSyncOnly;
    BOOL _manualPodcastSync;
}

@property (nonatomic, setter=setIPodSetUp:, getter=iPodSetUp) BOOL iPodSetUp;
@property (nonatomic, setter=setOpeniTunesWhenAttach:, getter=openiTunesWhenAttach) BOOL openiTunesWhenAttach;
@property (nonatomic, setter=setManualSyncFlag:, getter=manualSyncFlag) BOOL manualSyncFlag;
@property (nonatomic, setter=setSyncType:, getter=syncType) int syncType;
@property (nonatomic, setter=setEnableDiskUse:, getter=enableDiskUse) BOOL enableDiskUse;
@property (nonatomic, setter=setUpdateChecked:, getter=updateChecked) BOOL updateChecked;
@property (nonatomic, setter=setShowArtwork:, getter=showArtwork) BOOL showArtwork;
@property (nonatomic, setter=setSynchronizePhotos:, getter=synchronizePhotos) BOOL synchronizePhotos;
@property (nonatomic, setter=setStoreHiresPhotosOniPod:, getter=storeHiresPhotosOniPod) BOOL storeHiresPhotosOniPod;
@property (nonatomic, setter=setTranscode:, getter=transcode) BOOL transcode;
@property (nonatomic, setter=setKeepiPodInTheSourceList:, getter=keepiPodInTheSourceList) BOOL keepiPodInTheSourceList;
@property (nonatomic, setter=setSelectedPodcastSyncOnly:, getter=selectedPodcastSyncOnly) int selectedPodcastSyncOnly;
@property (nonatomic, setter=setManualPodcastSync:, getter=manualPodcastSync) BOOL manualPodcastSync;

- (id)initWithiPod:(IMBiPod*)ipod;

- (BOOL)saveiTunesPrefs;

- (void)setIPodSetUp:(BOOL)iPodSetUp;
- (BOOL)iPodSetUp;

//连接设备时是否打开iTunes
- (void)setOpeniTunesWhenAttach:(BOOL)openiTunesWhenAttach;
- (BOOL)openiTunesWhenAttach;

//设置手动管理
- (void)setManualSyncFlag:(BOOL)manualSyncFlag;
- (BOOL)manualSyncFlag;

- (void)setSyncType:(int)syncType;
- (int)syncType;

//用作磁盘
- (void)setEnableDiskUse:(BOOL)enableDiskUse;
- (BOOL)enableDiskUse;

- (void)setUpdateChecked:(BOOL)updateChecked;
- (BOOL)updateChecked;

- (void)setShowArtwork:(BOOL)showArtwork;
- (BOOL)showArtwork;

- (void)setSynchronizePhotos:(BOOL)synchronizePhotos;
- (BOOL)synchronizePhotos;

- (void)setStoreHiresPhotosOniPod:(BOOL)storeHiresPhotosOniPod;
- (BOOL)storeHiresPhotosOniPod;

- (void)setTranscode:(BOOL)transcode;
- (BOOL)transcode;

- (void)setKeepiPodInTheSourceList:(BOOL)keepiPodInTheSourceList;
- (BOOL)keepiPodInTheSourceList;

- (void)setSelectedPodcastSyncOnly:(int)selectedPodcastSyncOnly;
- (int)selectedPodcastSyncOnly;

- (void)setManualPodcastSync:(BOOL)manualPodcastSync;
- (BOOL)manualPodcastSync;

@end
