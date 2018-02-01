//
//  IMBTrack.h
//  MediaTrans
//
//  Created by Pallas on 12/11/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBBaseDatabaseElement.h"
#import "IMBStringMHOD.h"
#import "IMBBaseMHODElement.h"
#import "IMBMHODFactory.h"
#import "DateHelper.h"
#import "MediaHelper.h"
#import "IMBArtworkDB.h"
#import "IMBCommonEnum.h"

@class IMBNewTrack;
@interface IMBTrack : IMBBaseDatabaseElement{
@private
    int _dataObjectCount;
    int _iD;
    int _visible;
    int _fileType;
    Byte *_type;
    int typeLength;
    Byte _compilationFlag;
    Byte _rating;
    uint _dateLastModified;
    uint _fileSize;
    uint _trackLength;
    uint _trackNumber;
    uint _albumTrackCount;
    uint _year;
    uint _bitrate;
    uint _sampleRate;
    int _volumeAdjustment;
    uint _startTime;
    uint _stopTime;
    Byte *_unk1;
    int unk1Length;
    int _playCount;
    int _playCount2;
    uint _dateLastPalyed;
    uint _discNumber;
    uint _totalDiscCount;
    int _userID;
    uint _dateAdded;
    uint _bookmarkTime;
    int64_t _dbID;
    BOOL _isChecked;
    Byte _unk2;
    short _bpm;
    short _artworkCount;
    Byte *_unk3;
    int unk3Length;
    Byte _hasArtworkByte;
    BOOL _skipWhenShuffling;
    BOOL _rememberPlaybackPosition;
    BOOL _podcastFlag;
    uint64 _dbID2;
    BOOL _hasLyrics;
    BOOL _isVideoFile;
    Byte *_unk4;
    int unk4Length;
    Byte *_unk5;
    int unk5Length;
    MediaTypeEnum _mediaType;
    uint _artworkIdLink;
    int16_t _hasGaplessData;
    NSMutableArray *_childSections;
    
    BOOL _isDirty;
    BOOL _isPurchase;
    BOOL _isNew;
    int _index;
    int _samplerateForSqlite;
    long _durationFrame;
    int _audioChannels;
    long long _item_artist_pid;
    long long _album_pid;
    long long _album_artist_pid;
    
    NSMutableArray *_playlistPids;
    NSString *_srcFilePath;
    long long _artworkCacheid;
    NSMutableArray *_artwork;
    NSString *_artworkPath;
    NSString *_purchasesArtworkPath;
    NSString *_packageHash;
    NSString *_uuid;
    NSString *_exactFolderIfEpubBook;
    BOOL _fileIsExist;
    BOOL _isprotected;
    int _artworkVesion;
    
    NSString *_title;
    
    NSString *_photoFilePath;
    int _photoZpk;
    int _albumZpk;
    NSString *_deviceArtorkPath;
    
    //itunes导入时使用，用于获取指定的playlist的name
    NSString *_belongPlaylistName;
    //Ibooks删除时使用，表示不正常pid的book
    BOOL _isUnusual;
    NSString *_hexPersistentID;
    
    NSImage *_thumbImage;
    BOOL _loadingImage;
    NSString *_catchName;
    
    NSData *_artworkData;
    NSAttributedString *_titleAs;
    //luolei add 2017 7月21
    NSString *_photoAlbumName;
}

#pragma mark - properties
@property (nonatomic,readwrite) uint startTime;
@property (nonatomic,readwrite) uint stopTime;
@property (nonatomic,readwrite) uint bookmarkTime;
@property (nonatomic,readwrite) int samplerateForSqlite;
@property (nonatomic,readwrite) long durationFrame;
@property (nonatomic,readwrite) int audioChannels;
@property (nonatomic,readwrite) long long item_artist_pid;
@property (nonatomic,readwrite) long long album_pid;
@property (nonatomic,readwrite) long long album_artist_pid;
@property (nonatomic,readwrite,retain) NSMutableArray *playlistPids;
@property (nonatomic,readwrite,retain) NSString *srcFilePath;
@property (nonatomic,readwrite) long long artworkCacheid;
@property (nonatomic,readwrite,retain) NSString *artworkPath;
@property (nonatomic,readwrite,retain) NSString *purchasesArtworkPath;
@property (nonatomic,readwrite,retain) NSString *packageHash;
@property (nonatomic,readwrite,retain) NSString *uuid;
@property (nonatomic,readwrite,retain) NSString *photoAlbumName;
@property (nonatomic,readwrite,retain) NSString *exactFolderIfEpubBook;
@property (nonatomic,readwrite) BOOL fileIsExist;
@property (nonatomic,readonly) BOOL isNew;
@property (nonatomic,readonly) BOOL isDirty;
@property (nonatomic,assign) BOOL isPurchase;
@property (nonatomic,assign)BOOL isprotected;
@property (nonatomic,readonly) int index;
@property (nonatomic,readonly) NSMutableArray *children;

@property (nonatomic,readwrite,retain) NSString *photoFilePath;
@property (nonatomic,readwrite) int photoZpk;
@property (nonatomic,readwrite) int albumZpk;
@property (nonatomic,readwrite,retain) NSString *belongPlaylistName;
@property (nonatomic,readwrite,retain) NSData *artworkData;

#pragma mark - track between device

@property (nonatomic,copy) NSString *deviceWorkPath;

#pragma mark - track properties
@property (getter = title,setter = setTitle:,readwrite,retain) NSString *title;
@property (getter = artist,setter = setArtist:,readwrite,retain) NSString *artist;
@property (getter = album,setter = setAlbum:,readwrite,retain) NSString *album;
@property (getter = comment,setter = setComment:,readwrite,retain) NSString *comment;
@property (getter = composer,setter = setComposer:,readwrite,retain) NSString *composer;
@property (getter = albumArtist,setter = setAlbumArtist:,readwrite,retain) NSString *albumArtist;
@property (getter = descriptionText,setter = setDescriptionText:,readwrite,retain) NSString *descriptionText;
@property (getter = filePath,setter = setFilePath:,retain) NSString *filePath;
@property (getter = fileTypeStr,setter = setFileTypeStr:,readwrite,retain) NSString *fileTypeStr;
@property (getter = genre,setter = setGenre:,readwrite,retain) NSString *genre;
@property (nonatomic,readonly) int iD;
@property (getter = dbID,setter = setDbID:,readwrite) int64_t dbID;
@property (nonatomic,readwrite) BOOL hasArtwork;
@property (getter = isCompilation,setter = setIsCompilation:,readwrite) BOOL isCompilation;
@property (getter = rating,setter = setRating:,readwrite) Byte rating;
@property (getter = ratingInt,readonly) int ratingInt;
@property (getter = dateLastModified,setter = setDateLastModified:,readwrite) uint dateLastModified;
@property (nonatomic,assign) uint fileSize;
@property (nonatomic,assign) uint length;
@property (getter = trackNumber,setter = setTrackNumber:) uint trackNumber;
@property (getter = albumTrackCount,setter = setAlbumTrackCount:,readwrite) uint albumTrackCount;
@property (getter = year,setter = setYear:,readwrite) uint year;
@property (getter = bitrate,setter = setBitrate:,readwrite) uint bitrate;
@property (getter = sampleRate,readonly) uint sampleRate;
@property (getter = volumeAdjustment,setter = setVolumeAdjustment:,readwrite) int volumeAdjustment;
@property (getter = playCount,setter = setPlayCount:,readwrite) int playCount;
@property (getter = dateLastPalyed,setter = setDateLastPalyed:,readwrite) uint dateLastPalyed;
@property (getter = discNumber,setter = setDiscNumber:,readwrite) uint discNumber;
@property (getter = totalDiscCount,setter = setTotalDiscCount:,readwrite) uint totalDiscCount;
@property (getter = dateAdded,setter = setDateAdded:,readwrite) uint dateAdded;
@property (getter = mediaType,setter = setMediaType:,readwrite) MediaTypeEnum mediaType;
@property (getter = rememberPlaybackPosition,setter = setRememberPlaybackPosition:,readwrite) BOOL rememberPlaybackPosition;
@property (nonatomic,readwrite) BOOL podcastFlag;
@property (nonatomic,readwrite) uint artworkIdLink;
@property (nonatomic,readwrite,retain) NSMutableArray *artwork;
@property (getter = sortTitle,readonly) NSString *sortTitle;
@property (getter = sortAlbum,readonly) NSString *sortAlbum;
@property (getter = sortArtist,readonly) NSString *sortArtist;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, readwrite) int artworkVesion;

@property (nonatomic,assign) BOOL isUnusual;
@property (nonatomic,retain) NSString *hexPersistentID;

@property (nonatomic,retain) NSImage *thumbImage;
@property (nonatomic, readwrite) BOOL loadingImage;
@property (nonatomic, retain) NSString *catchName;
@property (nonatomic, retain) NSAttributedString *titleAs;
#pragma mark - properties accessor
-(void)setTitle:(NSString *)title;
-(NSString *)title;

-(void)setArtist:(NSString *)artist;
-(NSString *)artist;

-(void)setAlbum:(NSString *)album;
-(NSString *)album;

-(void)setComment:(NSString *)comment;
-(NSString *)comment;

-(void)setComposer:(NSString *)composer;
-(NSString *)composer;

-(void)setAlbumArtist:(NSString *)albumArtist;
-(NSString *)albumArtist;

-(void)setDescriptionText:(NSString *)descriptionText;
-(NSString *)descriptionText;

-(void)setFilePath:(NSString *)filePath;
-(NSString *)filePath;

-(void)setFileTypeStr:(NSString *)fileTypeStr;
-(NSString *)fileTypeStr;

-(void)setGenre:(NSString *)genre;
-(NSString *)genre;

-(void)setDbID:(int64_t)dbID;
-(int64_t)dbID;

-(void)setHasArtwork:(BOOL)hasArtwork;
-(BOOL)hasArtwork;

-(void)setIsCompilation:(BOOL)isCompilation;
-(BOOL)isCompilation;

-(void)setRating:(Byte)rating;
-(Byte)rating;

-(int)ratingInt;

-(void)setDateLastModified:(uint)dateLastModified;
-(uint)dateLastModified;

-(void)setTrackNumber:(uint)trackNumber;
-(uint)trackNumber;

-(void)setAlbumTrackCount:(uint)albumTrackCount;
-(uint)albumTrackCount;

-(void)setYear:(uint)year;
-(uint)year;

-(void)setBitrate:(uint)bitrate;
-(uint)bitrate;

-(uint)sampleRate;

-(void)setVolumeAdjustment:(int)volumeAdjustment;
-(int)volumeAdjustment;

-(void)setPlayCount:(int)playCount;
-(int)playCount;

-(void)setDateLastPalyed:(uint)dateLastPalyed;
-(uint)dateLastPalyed;

-(void)setDiscNumber:(uint)discNumber;
-(uint)discNumber;

-(void)setTotalDiscCount:(uint)totalDiscCount;
-(uint)totalDiscCount;

-(void)setDateAdded:(uint)dateAdded;
-(uint)dateAdded;

-(void)setMediaType:(MediaTypeEnum)mediaType;
-(MediaTypeEnum)mediaType;

-(void)setRememberPlaybackPosition:(BOOL)rememberPlaybackPosition;
-(BOOL)rememberPlaybackPosition;

-(NSString *)sortTitle;

-(NSString *)sortAlbum;

-(NSString *)sortArtist;

- (NSString *)getTrackArtworkPath;

#pragma mark - 需要实现的函数
-(BOOL)checkFileIsExsit;
-(IMBStringMHOD *)getchildByType:(int)type;
-(NSString *)getDataElement:(int)type;
-(void)setDataElement:(int)type data:(NSString*)data;
-(void)create:(IMBiPod*)ipod newTrack:(IMBNewTrack*)newTrack;
- (void)create:(IMBiPod *)ipod newTrack:(IMBNewTrack *)newTrack srciPod:(IMBiPod*)srciPod;
-(void)setArtworkByPath:(NSString*)filePath;
-(void)removeArtWork;
- (void)copyWithTrack:(IMBTrack *)track;
- (void)setTitleAttributedString;
@end
