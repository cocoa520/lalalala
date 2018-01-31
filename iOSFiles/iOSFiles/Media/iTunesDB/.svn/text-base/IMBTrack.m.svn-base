//
//  IMBTrack.m
//  MediaTrans
//
//  Created by Pallas on 12/11/12.
//  Copyright (c) 2012 iMobie. All rights reserved.
//

#import "IMBTrack.h"
#import "IMBNewTrack.h"
#import "IMBIDGenerator.h"
#import "IMBFileSystem.h"
#import "StringHelper.h"
@class IMBTracklist;

@implementation IMBTrack
@synthesize mediaType = _mediaType;
@synthesize isprotected = _isprotected;
@synthesize startTime = _startTime;
@synthesize stopTime = _stopTime;
@synthesize bookmarkTime = _bookmarkTime;
@synthesize samplerateForSqlite = _samplerateForSqlite;
@synthesize durationFrame = _durationFrame;
@synthesize audioChannels = _audioChannels;
@synthesize item_artist_pid = _item_artist_pid;
@synthesize album_pid = _album_pid;
@synthesize album_artist_pid = _album_artist_pid;
@synthesize playlistPids = _playlistPids;
@synthesize srcFilePath = _srcFilePath;
@synthesize artworkCacheid = _artworkCacheid;
@synthesize artworkPath =_artworkPath;
@synthesize purchasesArtworkPath = _purchasesArtworkPath;
@synthesize fileIsExist = _fileIsExist;
@synthesize iD = _iD;
@synthesize fileSize = _fileSize;
@synthesize length = _trackLength;
@synthesize podcastFlag = _podcastFlag;
@synthesize artworkIdLink = _artworkIdLink;
@synthesize artwork = _artwork;
@synthesize isNew = _isNew;
@synthesize isDirty = _isDirty;
@synthesize isPurchase = _isPurchase;
@synthesize index = _index;
@synthesize children = _childSections;
@synthesize isVideo = _isVideoFile;
@synthesize artworkVesion = _artworkVesion;

@synthesize title = _title;

@synthesize packageHash = _packageHash;
@synthesize uuid =  _uuid;
@synthesize exactFolderIfEpubBook = _exactFolderIfEpubBook;

@synthesize photoFilePath = _photoFilePath;
@synthesize photoZpk = _photoZpk;
@synthesize albumZpk = _albumZpk;
@synthesize deviceWorkPath = _deviceArtorkPath;
@synthesize belongPlaylistName = _belongPlaylistName;
@synthesize isUnusual = _isUnusual;
@synthesize hexPersistentID = _hexPersistentID;
@synthesize thumbImage = _thumbImage;
@synthesize loadingImage = _loadingImage;
@synthesize catchName = _catchName;
@synthesize artworkData = _artworkData;
@synthesize titleAs = _titleAs;
@synthesize photoAlbumName = _photoAlbumName;
#pragma mark - 初始化和释放方法
-(id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:@"Change_Skin" object:nil];
        _requiredHeaderSize = 258;
        _headerSize = 584;
        _visible = 1;
        _rating = 0;
        _dateLastModified = [DateHelper getTimeStampFromDate:[NSDate date]];
        _fileSize = 0;
        _trackLength = 0;
        _dateLastPalyed = [DateHelper getTimeStampFromDate:[NSDate date]];
        _dateAdded = [DateHelper getTimeStampFromDate:[NSDate date]];
        _childSections = [[NSMutableArray alloc] init];
        _playlistPids = [[NSMutableArray alloc] init];
        _artwork = [[NSMutableArray alloc] init];
        
        _photoZpk = 0;
        _albumZpk = 0;
        _photoFilePath = @"";
    }
    return self;
}

- (void)copyWithTrack:(IMBTrack *)track
{
    if (track == nil) {
        return;
    }
//属性值获得
    self.startTime = track.startTime;
    self.stopTime = track.stopTime;
    self.bookmarkTime = track.bookmarkTime;
    self.samplerateForSqlite = track.samplerateForSqlite;
    self.durationFrame = track.durationFrame;
    self.audioChannels = track.audioChannels;
    self.item_artist_pid = track.item_artist_pid;
    self.album_pid = track.album_pid;
    self.album_artist_pid = track.album_artist_pid;
    self.playlistPids = track.playlistPids;
    self.srcFilePath = track.srcFilePath;
    self.artworkCacheid = track.artworkCacheid;
    self.artworkPath =track.artworkPath;
    self.purchasesArtworkPath = track.purchasesArtworkPath;
    self.fileIsExist = track.fileIsExist;
    _iD = track.iD;
    self.fileSize = track.fileSize;
    _trackLength = track.length;
    self.podcastFlag = track.podcastFlag;
    self.artworkIdLink = track.artworkIdLink;
    self.artwork = track.artwork;
    _isNew = track.isNew;
    _isDirty = track.isDirty;
    self.isPurchase = track.isPurchase;
    _index = track.index;
    _childSections = track.children;
    _isVideoFile = track.isVideo;
    self.artworkVesion = track.artworkVesion;
//方法值获得
    self.title = track.title;
    self.artist = track.artist;
    self.album = track.album;
    self.comment = track.comment;
    self.composer = track.composer;
    self.albumArtist = track.albumArtist;
    self.descriptionText = track.descriptionText;
    self.filePath = track.filePath;
    self.fileTypeStr = track.fileTypeStr;
    self.genre = track.genre;
    self.dbID = track.dbID;
    self.hasArtwork = track.hasArtwork;
    self.isCompilation = track.isCompilation;
    self.rating = track.rating;
    self.dateLastModified = track.dateLastModified;
    self.trackNumber = track.trackNumber;
    self.albumTrackCount = track.albumTrackCount;
    self.year = track.year;
    self.bitrate = track.bitrate;
    _sampleRate = track.sampleRate;
    self.volumeAdjustment = track.volumeAdjustment;
    self.playCount = track.playCount;
    self.dateLastPalyed = track.dateLastPalyed;
    self.discNumber = track.discNumber;
    self.totalDiscCount = track.totalDiscCount;
    self.dateAdded = track.dateAdded;
    self.mediaType = track.mediaType;
    self.rememberPlaybackPosition = track.rememberPlaybackPosition;
    
}

-(void)dealloc{
    free(_identifier);
    free(_type);
    free(_unk1);
    free(_unk3);
    free(_unk4);
    free(_unk5);
    
    if (_playlistPids != nil) {
        [_playlistPids release];
        _playlistPids = nil;
    }
    if (_artwork != nil) {
        [_artwork release];
        _artwork = nil;
    }
    if (_srcFilePath != nil) {
        [_srcFilePath release];
        _srcFilePath = nil;
    }
    /*
    if (_artworkPath != nil) {
        [_artworkPath release];
        _artworkPath = nil;
    }
    */
    if (_purchasesArtworkPath != nil) {
        [_purchasesArtworkPath release];
        _purchasesArtworkPath=nil;
    }
    
    if (_childSections != nil) {
        [_childSections release];
        _childSections = nil;
    }
    
    if (_playlistPids != nil) {
        [_playlistPids release];
        _playlistPids = nil;
    }
    
    if (_deviceArtorkPath != nil) {
        [_deviceArtorkPath release];
        _deviceArtorkPath = nil;
    }
    
    if (_belongPlaylistName != nil) {
        [_belongPlaylistName release];
        _belongPlaylistName = nil;
    }
    
    if (_hexPersistentID != nil) {
        [_hexPersistentID release];
        _hexPersistentID = nil;
    }
    
    [_photoAlbumName release],_photoAlbumName = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Change_Skin" object:nil];
    [super dealloc];
}

#pragma mark - 属性方法
-(void)setTitle:(NSString *)title{
    if (title == nil || [title isEqualToString:@""]) {
        @throw [[NSException alloc] initWithName:@"EX_OP_NotAllowed_Title_Connot_Empty" reason:@"title isn't allow empty." userInfo:nil];
    }
    [self setDataElement:TITLE data:title];
    
    if ([title hasPrefix:@"The "] == YES) {
        [self setDataElement:TITLESORTBY data:[title substringWithRange:NSMakeRange(4, [title length] - 4)]];
    } else if ([title hasPrefix:@"A "]) {
        [self setDataElement:TITLESORTBY data:[title substringWithRange:NSMakeRange(2, [title length] - 2)]];
    }
}

-(NSString *)title{
   
    return [self getDataElement:TITLE];
}

-(void)setArtist:(NSString *)artist{
    [self setDataElement:ARTIST data:artist];
    if (artist == nil || [artist isEqualToString:@""]) {
        return;
    }
    
    if ([artist hasPrefix:@"The "]) {
        [self setDataElement:ARTISTSORTBY data:[artist substringWithRange:NSMakeRange(4, [artist length] - 4)]];
    } else if([artist hasPrefix:@"A "]) {
        [self setDataElement:ARTISTSORTBY data:[artist substringWithRange:NSMakeRange(2, [artist length] - 2)]];
    }
}

-(NSString *)artist{
    return [self getDataElement:ARTIST];
}

-(void)setAlbum:(NSString *)album{
    [self setDataElement:ALBUM data:album];
    if (album == nil || [album isEqualToString:@""]) {
        return;
    }
    
    if ([album hasPrefix:@"The "]) {
        [self setDataElement:ARTISTSORTBY data:[album substringWithRange:NSMakeRange(4, [album length] - 4)]];
    } else if([album hasPrefix:@"A "]) {
        [self setDataElement:ARTISTSORTBY data:[album substringWithRange:NSMakeRange(2, [album length] - 2)]];
    }
}

-(NSString *)album{
    return [self getDataElement:ALBUM];
}

-(void)setComment:(NSString *)comment{
    [self setDataElement:COMMENT data:comment];
}

-(NSString *)comment{
    return [self getDataElement:COMMENT];
}

-(void)setComposer:(NSString *)composer{
    [self setDataElement:COMPOSER data:composer];
}

-(NSString *)composer{
    return [self getDataElement:COMPOSER];
}

-(void)setAlbumArtist:(NSString *)albumArtist{
    [self setDataElement:ALUMARTIST data:albumArtist];
}

-(NSString *)albumArtist{
    NSString *artistStr = [self getDataElement:ALUMARTIST];
    if ([artistStr isEqualToString:@""]) {
        artistStr = self.artist;
    }
    return artistStr;
}

-(void)setDescriptionText:(NSString *)descriptionText{
    [self setDataElement:DESCRIPTIONTEXT data:descriptionText];
}

-(NSString *)descriptionText{
    return [self getDataElement:DESCRIPTIONTEXT];
}

-(void)setFilePath:(NSString *)filePath{
    NSString *newPath = @":";
    NSString *path = [MediaHelper getStandardPathToiPodPath:filePath];
//    NSLog(@"path %@", path);
    if ([path length] > 1) {
        if ([[path substringWithRange:NSMakeRange(0, 1)] isNotEqualTo:@":"]) {
            newPath = [newPath stringByAppendingString:path];
        }
        [self setDataElement:FILEPATH data:newPath];
        IMBUnicodeMHOD *mhod = (IMBUnicodeMHOD*)[self getchildByType:FILEPATH];
        mhod.position = 1;
    }
}

-(NSString *)filePath{
    NSString *newPath = nil;
    NSString *path = [self getDataElement:FILEPATH];
    if ([path length] > 1) {
        if ([[path substringWithRange:NSMakeRange(0, 1)] isEqualToString:@":"]) {
            path = [path substringWithRange:NSMakeRange(1, [path length] - 1)];
        }
    }
    newPath = [MediaHelper getiPodPathToStandardPath:path];
    return newPath;
}

- (NSString *)getTrackArtworkPath{
    NSString *artworkPath = @"";
    if (_artwork.count > 0) {
        IMBArtworkEntity *artworkItem = nil;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"formatType == %@",268500717];
        NSArray *artworkItems = [_artwork filteredArrayUsingPredicate:predicate];
        if (artworkItems.count > 0) {
            if (artworkItem == nil) {
                artworkItem = [_artwork objectAtIndex:0];
            }
        }
        if (![MediaHelper stringIsNilOrEmpty:artworkItem.filePath]) {
            artworkPath = artworkItem.filePath;
        }
    }
    return artworkPath;
}

-(void)setFileTypeStr:(NSString *)fileTypeStr{
    [self setDataElement:FILETYPE data:fileTypeStr];
}

-(NSString *)fileTypeStr{
    return [self getDataElement:FILETYPE];
}

-(void)setGenre:(NSString *)genre{
    
    [self setDataElement:GENRE data:genre];
}


-(NSString *)genre{
    return [self getDataElement:GENRE];
}

-(void)setDbID:(int64_t)dbID{
    _dbID = dbID;
    _isDirty = TRUE;
}

-(int64_t)dbID{
    return _dbID;
}

-(void)setHasArtwork:(BOOL)hasArtwork{
    if (hasArtwork == TRUE) {
        _hasArtworkByte = 1;
    } else {
        _hasArtworkByte = 0;
    }
}

-(BOOL)hasArtwork{
    if (_hasArtworkByte == 1) {
        return TRUE;
    } else {
        return FALSE;
    }
}

-(void)setIsCompilation:(BOOL)isCompilation{
    if (isCompilation == YES) {
        _compilationFlag = 1;
    }else{
        _compilationFlag = 0;
    }
    _isDirty = TRUE;
}

-(BOOL)isCompilation{
    if (_compilationFlag == 1) {
        return TRUE;
    }else{
        return FALSE;
    }
}

-(void)setRating:(Byte)rating{
    _rating = rating;
    _isDirty = TRUE;
}

-(Byte)rating{
    return _rating;
}

-(int)ratingInt{
    return (int)_rating;
}

-(void)setDateLastModified:(uint)dateLastModified{
    _dateLastModified = dateLastModified;
    _isDirty = TRUE;
}

-(uint)dateLastModified{
    return _dateLastModified;
}

-(void)setTrackNumber:(uint)trackNumber{
    _trackNumber = trackNumber;
    _isDirty = TRUE;
}

-(uint)trackNumber{
    return _trackNumber;
}

-(void)setAlbumTrackCount:(uint)albumTrackCount{
    _albumTrackCount = albumTrackCount;
    _isDirty = TRUE;
}

-(uint)albumTrackCount{
    return _albumTrackCount;
}

-(void)setYear:(uint)year{
    _year = year;
    _isDirty = TRUE;
}

-(uint)year{
    return _year;
}

-(void)setBitrate:(uint)bitrate{
    _bitrate = bitrate;
    _isDirty = TRUE;
}

-(uint)bitrate{
    return _bitrate;
}

-(uint)sampleRate{
    return _sampleRate / 0x10000;
}

-(void)setVolumeAdjustment:(int)volumeAdjustment{
    if (volumeAdjustment < -255 || volumeAdjustment > 255) {
        @throw [[NSException alloc] initWithName:@"InvalidValue" reason:@"The volume adjustment field should be between -255 and 255" userInfo:nil];
    }
    _volumeAdjustment = volumeAdjustment;
    _isDirty = TRUE;
}

-(int)volumeAdjustment{
    return _volumeAdjustment;
}

-(void)setPlayCount:(int)playCount{
    _playCount = playCount;
    _isDirty = TRUE;
}

-(int)playCount{
    return _playCount;
}

-(void)setDateLastPalyed:(uint)dateLastPalyed{
    _dateLastPalyed = dateLastPalyed;
    _isDirty = TRUE;
}

-(uint)dateLastPalyed{
    return _dateLastPalyed;
}

-(void)setDiscNumber:(uint)discNumber{
    _discNumber = discNumber;
    _isDirty = TRUE;
}

-(uint)discNumber{
    return _discNumber;
}

-(void)setTotalDiscCount:(uint)totalDiscCount{
    _totalDiscCount = totalDiscCount;
    _isDirty = TRUE;
}

-(uint)totalDiscCount{
    return _totalDiscCount;
}

-(void)setDateAdded:(uint)dateAdded{
    _dateAdded = dateAdded;
    _isDirty = TRUE;
}

-(uint)dateAdded{
    return _dateAdded;
}

-(void)setMediaType:(MediaTypeEnum)mediaType{
    _mediaType = (int)mediaType;
    _isDirty = TRUE;
}

-(MediaTypeEnum)mediaType{
    if(_mediaType==1024)
    {
        return HomeVideo;
    }else
    {
        return (MediaTypeEnum)_mediaType;
    }
}

-(void)setRememberPlaybackPosition:(BOOL)rememberPlaybackPosition{
    _rememberPlaybackPosition = rememberPlaybackPosition;
    _isDirty = TRUE;
}

-(BOOL)rememberPlaybackPosition{
    return _rememberPlaybackPosition;
}

-(NSString *)sortTitle{
    NSString *tempTitle = [self getDataElement:TITLESORTBY];
    if ([tempTitle isNotEqualTo:@""]) {
        return tempTitle;
    }
    return self.title;
}


-(NSString *)sortAlbum{
    NSString *tempAlum = [self getDataElement:ALBUMSORTBY];
    if ([tempAlum isNotEqualTo:@""]) {
        return tempAlum;
    }
    return self.album;
}

-(NSString *)sortArtist{
    NSString *tempArtist = [self getDataElement:ARTISTSORTBY];
    if ([tempArtist isNotEqualTo:@""]) {
        return tempArtist;
    }
    return self.artist;
}

#pragma mark - 重写方法
- (long)read:(IMBiPod *)ipod reader:(NSData *)reader currPosition:(long)currPosition {
    iPod = ipod;
    currPosition = [super read:iPod reader:reader currPosition:currPosition];
    long startOfElement = currPosition;
    
    int readLength = 0;
    readLength = 4;
    identifierLength = readLength;
    _identifier = (char*)malloc(readLength + 1);
    memset(_identifier, 0, malloc_size(_identifier));
    [reader getBytes:_identifier range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_headerSize);
    [reader getBytes:&_headerSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    [self validateHeader:@"mhit"];
    
    readLength = sizeof(_sectionSize);
    [reader getBytes:&_sectionSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_dataObjectCount);
    [reader getBytes:&_dataObjectCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_iD);
    [reader getBytes:&_iD range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_visible);
    [reader getBytes:&_visible range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_fileType);
    [reader getBytes:&_fileType range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = 2;
    typeLength = readLength;
    _type = (Byte*)malloc(readLength + 1);
    memset(_type, 0, malloc_size(_type));
    [reader getBytes:_type range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = 1;
    [reader getBytes:&_compilationFlag range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_rating);
    [reader getBytes:&_rating range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_dateLastModified);
    [reader getBytes:&_dateLastModified range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_fileSize);
    [reader getBytes:&_fileSize range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_trackLength);
    [reader getBytes:&_trackLength range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_trackNumber);
    [reader getBytes:&_trackNumber range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_albumTrackCount);
    [reader getBytes:&_albumTrackCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_year);
    [reader getBytes:&_year range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_bitrate);
    [reader getBytes:&_bitrate range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_sampleRate);
    [reader getBytes:&_sampleRate range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_volumeAdjustment);
    [reader getBytes:&_volumeAdjustment range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_startTime);
    [reader getBytes:&_startTime range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_stopTime);
    [reader getBytes:&_stopTime range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = 4;
    unk1Length = readLength;
    _unk1 = (Byte*)malloc(readLength + 1);
    memset(_unk1, 0, malloc_size(_unk1));
    [reader getBytes:_unk1 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_playCount);
    [reader getBytes:&_playCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_playCount2);
    [reader getBytes:&_playCount2 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_dateLastPalyed);
    [reader getBytes:&_dateLastPalyed range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_discNumber);
    [reader getBytes:&_discNumber range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_totalDiscCount);
    [reader getBytes:&_totalDiscCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_userID);
    [reader getBytes:&_userID range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_dateAdded);
    [reader getBytes:&_dateAdded range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_bookmarkTime);
    [reader getBytes:&_bookmarkTime range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_dbID);
    [reader getBytes:&_dbID range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_isChecked);
    [reader getBytes:&_isChecked range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_unk2);
    [reader getBytes:&_unk2 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_bpm);
    [reader getBytes:&_bpm range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_artworkCount);
    [reader getBytes:&_artworkCount range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = 38;
    unk3Length = readLength;
    _unk3 = (Byte*)malloc(readLength + 1);
    memset(_unk3, 0, malloc_size(_unk3));
    [reader getBytes:_unk3 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_hasArtworkByte);
    [reader getBytes:&_hasArtworkByte range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_skipWhenShuffling);
    [reader getBytes:&_skipWhenShuffling range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_rememberPlaybackPosition);
    [reader getBytes:&_rememberPlaybackPosition range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_podcastFlag);
    [reader getBytes:&_podcastFlag range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_dbID2);
    [reader getBytes:&_dbID2 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_hasLyrics);
    [reader getBytes:&_hasLyrics range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_isVideoFile);
    [reader getBytes:&_isVideoFile range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = 30;
    unk4Length = readLength;
    _unk4 = (Byte*)malloc(readLength + 1);
    memset(_unk4, 0, malloc_size(_unk4));
    [reader getBytes:_unk4 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_mediaType);
    [reader getBytes:&_mediaType range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    

    
    readLength = 44;
    unk5Length = readLength;
    _unk5 = (Byte*)malloc(readLength + 1);
    memset(_unk5, 0, malloc_size(_unk5));
    [reader getBytes:_unk5 range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    readLength = sizeof(_hasGaplessData);
    [reader getBytes:&_hasGaplessData range:NSMakeRange(currPosition, readLength)];
    currPosition += readLength;
    
    if (_headerSize > 352) {
        long previousPostion = currPosition;
        currPosition = startOfElement +352;
        readLength = sizeof(_artworkIdLink);
        [reader getBytes:&_artworkIdLink range:NSMakeRange(currPosition, readLength)];
        currPosition += readLength;
        currPosition = previousPostion;
    }
    currPosition = [self readToHeaderEnd:reader currPosition:currPosition];
    
    for (int i = 0; i < _dataObjectCount; i++) {
        IMBBaseMHODElement *mhod = [IMBMHODFactory readMHOD:iPod reader:reader currPosition:&currPosition];
        [_childSections addObject:mhod];
    }
    
    _fileIsExist = [self checkFileIsExsit];
    return currPosition;
}

-(void)write:(NSMutableData *)writer{
    long startOfElement = [writer length];
    _sectionSize = [self getSectionSize];
    
    identifierLength = 4;
    _identifier = (char*)malloc(identifierLength + 1);
    memset(_identifier, 0, malloc_size(_identifier));
    memcpy(_identifier, "mhit", malloc_size(_identifier));
    [writer appendBytes:_identifier length:identifierLength];
    [writer appendBytes:&_headerSize length:sizeof(_headerSize)];
    [writer appendBytes:&_sectionSize length:sizeof(_sectionSize)];
    int childCount = (int)[_childSections count];
    [writer appendBytes:&childCount length:sizeof(childCount)];
    [writer appendBytes:&_iD length:sizeof(_iD)];
    [writer appendBytes:&_visible length:sizeof(_visible)];
    [writer appendBytes:&_fileType length:sizeof(_fileType)];
    [writer appendBytes:_type length:typeLength];
    [writer appendBytes:&_compilationFlag length:sizeof(_compilationFlag)];
    [writer appendBytes:&_rating length:sizeof(_rating)];
    [writer appendBytes:&_dateLastModified length:sizeof(_dateLastModified)];
    [writer appendBytes:&_fileSize length:sizeof(_fileSize)];
    [writer appendBytes:&_trackLength length:sizeof(_trackLength)];
    [writer appendBytes:&_trackNumber length:sizeof(_trackNumber)];
    [writer appendBytes:&_albumTrackCount length:sizeof(_albumTrackCount)];
    [writer appendBytes:&_year length:sizeof(_year)];
    [writer appendBytes:&_bitrate length:sizeof(_bitrate)];
    [writer appendBytes:&_sampleRate length:sizeof(_sampleRate)];
    [writer appendBytes:&_volumeAdjustment length:sizeof(_volumeAdjustment)];
    [writer appendBytes:&_startTime length:sizeof(_startTime)];
    [writer appendBytes:&_stopTime length:sizeof(_stopTime)];
    [writer appendBytes:_unk1 length:unk1Length];
    [writer appendBytes:&_playCount length:sizeof(_playCount)];
    [writer appendBytes:&_playCount2 length:sizeof(_playCount2)];
    [writer appendBytes:&_dateLastPalyed length:sizeof(_dateLastPalyed)];
    [writer appendBytes:&_discNumber length:sizeof(_discNumber)];
    [writer appendBytes:&_totalDiscCount length:sizeof(_totalDiscCount)];
    [writer appendBytes:&_userID length:sizeof(_userID)];
    [writer appendBytes:&_dateAdded length:sizeof(_dateAdded)];
    [writer appendBytes:&_bookmarkTime length:sizeof(_bookmarkTime)];
    [writer appendBytes:&_dbID length:sizeof(_dbID)];
    
    [writer appendBytes:&_isChecked length:sizeof(_isChecked)];
    [writer appendBytes:&_unk2 length:sizeof(_unk2)];
    [writer appendBytes:&_bpm length:sizeof(_bpm)];
    [writer appendBytes:&_artworkCount length:sizeof(_artworkCount)];
    [writer appendBytes:_unk3 length:unk3Length];
    [writer appendBytes:&_hasArtworkByte length:sizeof(_hasArtworkByte)];
    [writer appendBytes:&_skipWhenShuffling length:sizeof(_skipWhenShuffling)];
    [writer appendBytes:&_rememberPlaybackPosition length:sizeof(_rememberPlaybackPosition)];
    [writer appendBytes:&_podcastFlag length:sizeof(_podcastFlag)];
    [writer appendBytes:&_dbID2 length:sizeof(_dbID2)];
    [writer appendBytes:&_hasLyrics length:sizeof(_hasLyrics)];
    [writer appendBytes:&_isVideoFile length:sizeof(_isVideoFile)];
    [writer appendBytes:_unk4 length:unk4Length];
    [writer appendBytes:&_mediaType length:sizeof(_mediaType)];
    [writer appendBytes:_unk5 length:unk5Length];
    [writer appendBytes:&_hasGaplessData length:sizeof(_hasGaplessData)];
    
    [writer appendBytes:_unusedHeader length:unusedHeaderLength];
    if (_headerSize > 352) {
        long replacePosition = startOfElement + 352;
        int _getLength = sizeof(_artworkIdLink);
        [writer replaceBytesInRange:NSMakeRange(replacePosition, _getLength) withBytes:&_artworkIdLink];
    }
    
    IMBBaseMHODElement *mhod = nil;
    for (int i = 0; i < [_childSections count]; i++) {
        mhod = [[_childSections objectAtIndex:i] retain];
        [mhod write:writer];
        [mhod release];
        mhod = nil;
    }
    _isDirty = FALSE;
}

-(int)getSectionSize{
    int size = _headerSize;
    IMBBaseMHODElement *mhod = nil;
    for (int i = 0; i < [_childSections count]; i++) {
        mhod = [_childSections objectAtIndex:i];
        size += [mhod getSectionSize];
    }
    return size;
}

#pragma mark - 实现声明方法
-(BOOL)checkFileIsExsit{
    if ([[iPod fileSystem] fileExistsAtPath:[iPod.fileSystem.driveLetter stringByAppendingPathComponent:[self filePath]]]  == YES) {
        return TRUE;
    } else {
        return FALSE;
    }
}

-(IMBStringMHOD *)getchildByType:(int)type{
    IMBStringMHOD *strmhod = nil;
    IMBBaseMHODElement *mhod = nil;
    for (int i = 0; i < [_childSections count]; i++) {
        mhod = [_childSections objectAtIndex:i];
        if ([[mhod superclass] isSubclassOfClass:[IMBStringMHOD class]] && [mhod type] == type) {
            strmhod = (IMBStringMHOD*)mhod;
            break;
        }
    }
    return strmhod;
}

-(NSString *)getDataElement:(int)type{
    NSString *retStr = nil;
    IMBStringMHOD *mhod = [self getchildByType:type];
    if (mhod != nil) {
        retStr = [mhod data];
    } else {
        retStr = @"";
    }
    
    return retStr;
}

-(void)setDataElement:(int)type data:(NSString *)data{
    IMBStringMHOD *mhod = [self getchildByType:type];
    if (mhod != nil) {
        if (data == nil || [data isEqual:@""]) {
            [_childSections removeObject:mhod];
            return;
        }
        mhod.data = data;
    } else {
        if ([MediaHelper stringIsNilOrEmpty:data] == NO) {
            IMBStringMHOD *newSection = [[IMBUnicodeMHOD alloc] initWithElementType:type];
            [newSection setData:data];
            [_childSections addObject:newSection];
            [newSection release];
            newSection = nil;
        }
    }
}

- (void)create:(IMBiPod *)ipod newTrack:(IMBNewTrack *)newTrack srciPod:(IMBiPod*)srciPod{
    iPod = ipod;
    if ([[newTrack title] isEqualToString:@""] || [newTrack title] == nil) {
        @throw [NSException exceptionWithName:@"EX_NotAllowed_TrackTitle_Empty" reason:@"Track title dosn't allowed empty!" userInfo:nil];
    }
    
    if ([[newTrack filePath] isEqualToString:@""] || [newTrack filePath] == nil) {
        @throw [NSException exceptionWithName:@"EX_NotAllowed_FilePath_Invalided" reason:@"Local filepath is invalide!" userInfo:nil];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (srciPod == nil) {
        if ([fileManager fileExistsAtPath:[newTrack filePath]] == NO) {
            @throw [NSException exceptionWithName:@"EX_LoacalFile_Not_Exist" reason:@"Local file dose'nt exist!" userInfo:nil];
        }
    }
    
    [self setTitle:[newTrack title]];
    if ([MediaHelper stringIsNilOrEmpty:[newTrack album]] == NO) {
        [self setAlbum:[newTrack album]];
    }
    if ([MediaHelper stringIsNilOrEmpty:[newTrack artist]] == NO) {
        [self setArtist:[newTrack artist]];
    }
    if ([MediaHelper stringIsNilOrEmpty:[newTrack comments]] == NO) {
        [self setComment:[newTrack comments]];
    }
    if ([MediaHelper stringIsNilOrEmpty:[newTrack genre]] == NO) {
        [self setGenre:[newTrack genre]];
    }
    if ([MediaHelper stringIsNilOrEmpty:[newTrack composer]] == NO) {
        [self setComposer:[newTrack composer]];
    }
    if ([MediaHelper stringIsNilOrEmpty:[newTrack albumArtist]] == NO) {
        [self setAlbumArtist:[newTrack albumArtist]];
    }
    if ([MediaHelper stringIsNilOrEmpty:[newTrack descriptionText]] == NO) {
        [self setDescriptionText:[newTrack descriptionText]];
    }
    if ([MediaHelper stringIsNilOrEmpty:[newTrack filePath]] == NO) {
        [self setSrcFilePath:[newTrack filePath]];
    }
    if ([MediaHelper stringIsNilOrEmpty:[newTrack packageHashID]] == NO) {
        [self setPackageHash:[newTrack packageHashID]];
    }
    
    _year = [newTrack year];
    _bitrate = [newTrack bitrate];
    //Todo minisec有问题
    _trackLength = [newTrack length];
    _fileSize = newTrack.fileSize;
    
    _trackNumber = [newTrack trackNumber];
    _albumTrackCount = [newTrack albumTrackCount];
    _discNumber = [newTrack discNumber];
    _totalDiscCount = [newTrack totalDiscCount];
    _durationFrame = [newTrack durationFrame];
    _samplerateForSqlite = [newTrack sampleRate];
    _sampleRate = newTrack.sampleRate * 0x10000;
    _audioChannels = [newTrack audioChannels];
    _playCount = [newTrack playCount];
    _rating = [newTrack rating];
    _dateLastPalyed = [newTrack lastPalyed];
    _isVideoFile = [newTrack isVideo];
    
    [self setFileTypeStr:[MediaHelper getFileTypeDescription:newTrack.fileExtension]];
    if (_isVideoFile) {
        _rememberPlaybackPosition = TRUE;
    }
    [self setMediaType:[newTrack dBMediaType]];
    
    if ([self mediaType] == Podcast || [self mediaType] == Audiobook || [self mediaType] == iTunesU) {
        _rememberPlaybackPosition = TRUE;
    }
    
    // Todo生成DBID
    _dbID = [[iPod idGenerator] getNewDBID];
    NSString *ipodFilePath;
    while (TRUE) {
        _iD = [[iPod idGenerator] getNewTrackID];
        NSString *path = nil;
        NSArray *resultArr = nil;
        //去掉重复的path;
        do{
            path = [[iPod idGenerator] getNewIPodFilePath:self fileExtension:[[newTrack filePath] pathExtension]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"filePath == %@",path];
            resultArr = [[ipod.tracks trackArray] filteredArrayUsingPredicate:predicate];
            usleep(20);
        }while (resultArr.count > 0);
        [self setFilePath:path];
        ipodFilePath = [[[iPod fileSystem] driveLetter] stringByAppendingPathComponent:[self filePath]];
        if (![[iPod fileSystem] fileExistsAtPath:ipodFilePath]) {
            break;
        }
    }
    NSString *folderPath = [MediaHelper getDirectory:ipodFilePath];
    if (![[iPod fileSystem] fileExistsAtPath:folderPath]) {
        [[iPod fileSystem] mkDir:folderPath];
    }
    _unk1 = malloc(5);
    memset(_unk1, 0, malloc_size(_unk1));
    unk1Length = 4;
    _unk3 = malloc(39);
    memset(_unk3, 0, malloc_size(_unk3));
    unk3Length = 38;
    _unk4 = malloc(31);
    memset(_unk4, 0, malloc_size(_unk4));
    unk4Length = 30;
    _unk5 = malloc(45);
    memset(_unk5, 0, malloc_size(_unk5));
    unk5Length = 44;
    _unusedHeader = malloc((_headerSize - _requiredHeaderSize) + 1);
    memset(_unusedHeader, 0, malloc_size(_unusedHeader));
    unusedHeaderLength = _headerSize - _requiredHeaderSize;
    _type = malloc(3);
    memset(_type, 0, malloc_size(_type));
    typeLength = 2;
    _hasGaplessData = 1;
    _isNew = TRUE;
    _isDirty = TRUE;
}

- (void)create:(IMBiPod *)ipod newTrack:(IMBNewTrack *)newTrack {
    [self create:ipod newTrack:newTrack srciPod:nil];
}

-(void)setArtworkByPath:(NSString*)filePath {
    @autoreleasepool {
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:filePath];
        [[iPod artworkDB] setArtwork:self image:image];
        [image release];
        _hasArtworkByte = 1;
        _artworkCount = 1;
        _isDirty = TRUE;
    }
}

-(void)removeArtWork {
    [[iPod artworkDB] removeArtwork:self];
    _hasArtworkByte = 2;
    _artworkCount = 0;
    _artworkIdLink = 0;
    _isDirty = TRUE;
}

- (void)setTitleAttributedString {
    if (self.title) {
        NSMutableAttributedString *as = [[[NSMutableAttributedString alloc] initWithString:self.title] autorelease];
        [as addAttribute:NSForegroundColorAttributeName value:IMBGrayColor(51) range:NSMakeRange(0, as.length)];
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [self setTitleAs:as];
    }

}

- (void)changeSkin:(NSNotification *)notification
{
    [self setTitleAttributedString];
}

@end
