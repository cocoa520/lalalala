//
//  IMBSyncPlistBuilder.m
//  iMobieTrans
//
//  Created by zhang yang on 13-4-8.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBSyncPlistBuilder.h"
#import "IMBPlaylist.h"
#import "IMBPlaylistList.h"
#import "IMBSession.h"
#import "IMBCommonEnum.h"
#import "IMBFileSystem.h"
#import "IMBDeviceInfo.h"
#import "IMBBooksPlist.h"
#import "IMBSyncBookPlistBuilder.h"
#import "IMBSyncAppBuilder.h"
#import "NSString+Compare.h"
@implementation IMBSyncPlistBuilder

-(id)initWithIpod:(IMBiPod*)aIPod
{
    self = [super init];
    if (self) {
        iPod = [aIPod retain];
        sqliteTable_5 = [[IMBSqliteTables_5 alloc] initWithIPod:iPod];
        [sqliteTable_5 exactDeviceDBFiles];
        [sqliteTable_5 getInfoFromDirtyTracks];
        [sqliteTable_5 generateDeleteTracksInfo];
        [sqliteTable_5 closeDataBase];
        
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)aIPod operationDic:(NSMutableDictionary *)operationDic syncData:(IMBSyncDataEntiy *)syncData delPidList:(NSArray *)array
{
    if (self = [self initWithIpod:aIPod]) {
        _operationDic = operationDic;
        _database = iPod.mediaDatabase;
        _delTrackList = [self filterToTrackArray:[array retain] isIMBTrack:YES];
        _syncData = syncData;
        if (_database != nil) {
            aIPod = _database.IPod;
        }
    }
    return self;
}



- (id)initWithIpod:(IMBiPod *)aIPod opreationDic:(NSMutableDictionary *)operationDic syncData:(IMBSyncDataEntiy *)syncdata addTrackList:(NSArray *)addTrackList isAdd:(BOOL)isAdd{
    if (self = [self initWithIpod:aIPod]) {
        _operationDic = operationDic;
        _database = iPod.mediaDatabase;
        _syncData = syncdata;
        _isAdd = isAdd;
        if (_isAdd) {
            _tracks = [self filterToTrackArray:addTrackList isIMBTrack:YES];
        }
        else{
            _delTrackList = [self filterToTrackArray:addTrackList isIMBTrack:YES];
        }
    }
    return self;
}

- (id)initWithIpod:(IMBiPod *)aIPod opreationDic:(NSMutableDictionary *)operationDic syncData:(IMBSyncDataEntiy *)syncdata addTrackList:(NSArray *)addTrackList addAppList:(NSArray *)addAppList isAdd:(BOOL)isAdd{
    if (self = [self initWithIpod:aIPod]) {
        _operationDic = operationDic;
        _database = iPod.mediaDatabase;
        _syncData = syncdata;
        _isAdd = isAdd;
        _applications = addAppList;
        if (_isAdd) {
            _tracks = [self filterToTrackArray:addTrackList isIMBTrack:YES];
        }else{
            _delTrackList = [self filterToTrackArray:addTrackList isIMBTrack:YES];
        }
    }
    return self;
}

- (NSArray *)filterToTrackArray:(NSArray *)filterArray isIMBTrack:(BOOL)isTrack{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSObject *object = evaluatedObject;
        if ([object isKindOfClass:[IMBTrack class]]) {
            return isTrack;
        }
        return !isTrack;
    }];
    NSArray *array = [filterArray filteredArrayUsingPredicate:predicate];
    return array;
}


- (void)dealloc
{
    
    if (sqliteTable_5 != nil) {
        [sqliteTable_5 release];
        sqliteTable_5 = nil;
    }
    
    if (iPod != nil) {
        [iPod release];
        iPod = nil;
    }
    
    if (_delTrackList != nil) {
        [_delTrackList release];
        _delTrackList = nil;
    }
    
    [super dealloc];
}

//生成Media同步plist
-(void) createBinPlistWithPath:(NSString*) path WithRevision:(int)revision {
    NSMutableDictionary *rootDic = [[NSMutableDictionary alloc] init];
    [rootDic setObject:[self buildSyncPlist] forKey:@"operations"];
    //<key>revision</key>
    //<integer>92</integer>
    //<key>timestamp</key>
    //<date>2012-02-13T15:26:04Z</date>
    
    //是否需要
    [rootDic setObject:[NSNumber numberWithInt:revision] forKey:@"revision"];
    [rootDic setObject:[NSDate date] forKey:@"timestamp"];
    NSLog(@"rootDic: %@",[rootDic description]);
    
    //TODO 临时文件架
    //[rootDic writeToFile:@"/Users/hotdog19/Desktop/Sync.plist" atomically:NO];
    NSString *err = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:rootDic format:NSPropertyListBinaryFormat_v1_0 errorDescription:&err];
    
    
    if(plistData != nil) {
        [plistData writeToFile:path atomically:NO];
    } else {
        NSLog(@"NSPropertyListSerialization error: %@", err);
        
    }
    [rootDic release];
    //PListReadWrite.writeBinary(rootDic, path);
}

-(void) createBinRingToneHeadPlistWithPath:(NSString*) path WithRevision:(int)revision
{
    NSMutableDictionary *rootDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *dicArray = [[NSMutableArray alloc] init];
    [dicArray addObject:[self buildDBInfo]];
    [rootDic setObject:dicArray forKey:@"operations"];
    [dicArray release];
    //<key>revision</key>
    //<integer>92</integer>
    //<key>timestamp</key>
    //<date>2012-02-13T15:26:04Z</date>
    
    //是否需要
    //是否需要
    [rootDic setObject:[NSNumber numberWithInt:revision] forKey:@"revision"];
    [rootDic setObject:[NSDate date] forKey:@"timestamp"];
    NSLog(@"rootDic: %@",[rootDic description]);
    //[rootDic writeToFile:@"/Users/hotdog19/Desktop/SyncRTHeader.plist" atomically:NO];
    NSString *err = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:rootDic format:NSPropertyListBinaryFormat_v1_0 errorDescription:&err];
    
    
    if(plistData != nil) {
        [plistData writeToFile:path atomically:NO];
    } else {
        NSLog(@"NSPropertyListSerialization error: %@", err);
        
    }
    [rootDic release];
    
}

- (void)createVoiceMemoCigHeadPlistWithPath:(NSString *)path WithRevision:(int)revision{
    [self createBinRingToneHeadPlistWithPath:path WithRevision:revision];
}

- (void)createVoiceMemosContentPlist:(NSString*) path WithRevision:(int)revision{
    [self createBinOtherContentPlistWithPath:path WithRevision:revision];
}

- (BOOL)createDelVoiceMemosSyncPlist:(NSString *)path WithRevision:(int)revision pidList:(NSArray *)list{
    BOOL result = false;
    NSMutableDictionary *rootDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *dicArr = [[NSMutableArray alloc]init];
    for (NSNumber *item in list) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@"delete_track" forKey:@"operation"];
        [dic setObject:item forKey:@"pid"];
        [dicArr addObject:dic];
        [dic release];
    }
    [rootDic setObject:dicArr forKey:@"operations"];
    [rootDic setObject:[NSNumber numberWithInt:revision] forKey:@"revision"];
    [rootDic setObject:[NSDate date] forKey:@"timestamp"];
    @try {
        [rootDic writeToFile:path atomically:YES];
        result = true;
    }
    @catch (NSException *exception) {
        NSLog(@"some erros happend");
        result = false;
    }
    @finally {
        
    }
    [dicArr release];
    [rootDic release];
    return result;
}

- (BOOL)syncVoiceMemoAfterDelete:(IMBiPod *)mipod
{
    BOOL ret = NO;
    NSString *localVmSyncPath = [[[mipod session] sessionFolderPath] stringByAppendingPathComponent:@"/Recoridings/syncVm.plist"];
    NSString *airSyncRemoteFilePath = nil;
    airSyncRemoteFilePath = [[[mipod fileSystem] driveLetter] stringByAppendingPathComponent:@"Recordings/Sync"]
    ;
    NSString *plistName = [NSString stringWithFormat:@"Sync_%08d.plist",0];
    if (![[mipod fileSystem] fileExistsAtPath:airSyncRemoteFilePath]) {
        [[mipod fileSystem] mkDir:airSyncRemoteFilePath];
    }
    airSyncRemoteFilePath = [airSyncRemoteFilePath stringByAppendingPathComponent:plistName];
    if ([[mipod fileSystem] fileExistsAtPath:airSyncRemoteFilePath]) {
        [[mipod fileSystem] unlink:airSyncRemoteFilePath];
    }
    [[mipod fileSystem] copyLocalFile:localVmSyncPath toRemoteFile:airSyncRemoteFilePath];
    ret = YES;
    return ret;
}

/// <summary>
/// 生成media的plist
/// </summary>
/// <param name="path"></param>
/// <param name="revision"></param>
-(void) createBinOtherContentPlistWithPath:(NSString*) path WithRevision:(int)revision
{
    
    NSMutableDictionary *rootDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *dicArray = [[NSMutableArray alloc] init];
    [self buildSyncPlistContent:dicArray];
    [rootDic setObject:dicArray forKey:@"operations"];
    [dicArray release];
    
    [rootDic setObject:[NSNumber numberWithInt:revision] forKey:@"revision"];
    [rootDic setObject:[NSDate date] forKey:@"timestamp"];
    NSLog(@"rootDic: %@",[rootDic description]);
    //[rootDic writeToFile:@"/Users/hotdog19/Desktop/SyncRTContent.plist" atomically:NO];
    NSString *err = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:rootDic format:NSPropertyListBinaryFormat_v1_0 errorDescription:&err];
    
    
    if(plistData != nil) {
        [plistData writeToFile:path atomically:NO];
    } else {
        NSLog(@"NSPropertyListSerialization error: %@", err);
        
    }
    [rootDic release];
    
}



//生成根目录下的plist
- (NSArray*)buildSyncPlist {
    NSMutableArray *dictArray = [[[NSMutableArray alloc] init] autorelease];
    //添加DBInfo等消息
    [dictArray addObject:[self buildDBInfo]];
    //添加SyncPlist的内容
    [self buildSyncPlistContent:dictArray];
    return dictArray;
}

//得到DBInfo的信息
- (NSDictionary*)buildDBInfo {
    //<dict>
    //    <key>db_info</key>
    //    <dict>
    //        <key>audio_language</key>
    //        <integer>-1</integer>
    //        <key>primary_container_pid</key>
    //        <integer>7812584384201629787</integer>
    //        <key>subtitle_language</key>
    //        <integer>-1</integer>
    //    </dict>
    //    <key>operation</key>
    //    <string>update_db_info</string>
    //    <key>pid</key>
    //    <integer>-6279556969602269472</integer>
    //</dict>
    
    NSMutableDictionary *dbInfoDic = [[[NSMutableDictionary alloc] init] autorelease];
    long long primary_container_pid = 1;
    IMBPlaylist *masterPl = nil;
    
    if (iPod.playlists != nil)
    {
        masterPl = [iPod.playlists getMasterPlaylist];
    }
    if (masterPl != nil)
    {
        primary_container_pid = masterPl.iD;
    }
    NSMutableDictionary *columDic = [[NSMutableDictionary alloc] init];
    [columDic setObject:[NSNumber numberWithInt:-1] forKey:@"audio_language"];
    [columDic setObject:[NSNumber numberWithInt:-1] forKey:@"subtitle_language"];
    [columDic setObject:[NSNumber numberWithLongLong:primary_container_pid] forKey:@"primary_container_pid"];
    
    [dbInfoDic setObject:columDic forKey:@"db_info"];
    [columDic release];
    [dbInfoDic setObject:@"update_db_info" forKey:@"operation"];
    [dbInfoDic setObject:[NSNumber numberWithLongLong:sqliteTable_5.dbPid] forKey:@"pid"];
    return dbInfoDic;
}

//生成Plist里面的内容
- (void) buildSyncPlistContent:(NSMutableArray*) dicArray {
    
    if ([sqliteTable_5 dirtyTracks] != nil) {
        for (int i=0; i < [sqliteTable_5.dirtyTracks count]; i++) {
            IMBTrack *track = [sqliteTable_5.dirtyTracks objectAtIndex:i];
            //添加新增Track部分
            [dicArray addObject:[self buildInsertTrack:track]];
        }
    }
    
    //1，删除track,album,artist
    //2, 找到相关的playlist并做更新
    if (sqliteTable_5.deletedTracks != nil && sqliteTable_5.deletedTracks.count > 0) {
        //编辑删除Track的部分
        NSArray *deltedTrackInfo = [self buildDeleteInfo:sqliteTable_5.deletedTracks];
        [dicArray addObjectsFromArray:deltedTrackInfo];
    }
    
    //1编辑删除delete的playlist部分
    NSArray *deletedPlaylists = iPod.session.deletedPlaylists;
    if (deletedPlaylists != nil && deletedPlaylists.count > 0)
    {
        for (int i=0; i<deletedPlaylists.count; i++) {
            [dicArray addObject:[self buildDeletedPlaylist:[deletedPlaylists objectAtIndex:i]]];
        }
    }
    
    //编辑其他变化过的playlist
    NSArray *playlistArray = iPod.playlists.playlistArray;
    if (playlistArray != nil && playlistArray.count > 0) {
        for (int i=0; i < playlistArray.count; i++) {
            IMBPlaylist *pl = [playlistArray objectAtIndex:i];
            if (pl.isDirty && pl.isUserDefinedPlaylist)
            {
                //编辑这个变化的playlist包括增加与内容添加部分
                [dicArray addObject:[self buildPlaylist:pl]];
            }
        }
    }
    
}

//添加新增Track部分 buildInsertTrack

- (NSDictionary*) buildInsertTrack:(IMBTrack*)track
{
    //编辑plist item section部分
    //<key>item</key>
    //<dict>
    //    <key>album</key>
    //    <string>Bob Acri</string>
    //    <key>album_artist</key>
    //    <string>Bob Acri</string>
    //    <key>album_pid</key>
    //    <integer>-1965953579177497240</integer>
    //    <key>artist</key>
    //    <string>Bob Acri</string>
    //    <key>artist_pid</key>
    //    <integer>-3923851590974489787</integer>
    //    <key>artwork_cache_id</key>
    //    <integer>104</integer>
    //    <key>comment</key>
    //    <string>Blujazz Productions</string>
    //    <key>composer</key>
    //    <string>Robert R. Acri</string>
    //    <key>date_created</key>
    //    <date>2012-01-29T02:07:37Z</date>
    //    <key>genre</key>
    //    <string>Jazz</string>
    //    <key>is_song</key>
    //    <true/>
    //    <key>remember_bookmark</key>
    //    <false/>
    //    <key>sort_album</key>
    //    <string>Bob Acri</string>
    //    <key>sort_album_artist</key>
    //    <string>Bob Acri</string>
    //    <key>sort_artist</key>
    //    <string>Bob Acri</string>
    //    <key>sort_composer</key>
    //    <string>Robert R. Acri</string>
    //    <key>sort_name</key>
    //    <string>Sleep Away</string>
    //    <key>title</key>
    //    <string>Sleep Away</string>
    //    <key>total_time_ms</key>
    //    <integer>200568</integer>
    //    <key>track_number</key>
    //    <integer>3</integer>
    //    <key>year</key>
    //    <integer>2004</integer>
    //</dict>
    NSMutableDictionary *itemDic = [[NSMutableDictionary alloc] init];
    if (track.mediaType == VoiceMemo) {
        NSString *deviceName = iPod.deviceInfo.deviceName;
        [itemDic setObject:deviceName forKey:@"artist"];
        [itemDic setObject:track.album forKey:@"album"];
        [itemDic setObject:[NSNumber numberWithLongLong:track.album_pid] forKey:@"album_pid"];
        [itemDic setObject:[NSNumber numberWithLongLong:track.item_artist_pid] forKey:@"artist_pid"];
        [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"remember_bookmark"];
    }
    else{
        [itemDic setObject:track.album forKey:@"album"];
        [itemDic setObject:track.albumArtist forKey:@"album_artist"];
        [itemDic setObject:track.artist forKey:@"artist"];
        [itemDic setObject:[NSNumber numberWithBool:track.rememberPlaybackPosition] forKey:@"remember_bookmark"];
    }
    //由于ios设备可以自动生成
    //[itemDic setObject:track.album_pid forKey:@"album_pid"];
    //[itemDic setObject:track.item_artist_pid forKey:@"artist_pid"];
    //需要编辑artwork_cache_id
    if (track.mediaType != VoiceMemo){
        if (track.artworkCacheid != 0)
        {
            [itemDic setObject:[NSNumber numberWithLongLong:track.artworkCacheid] forKey:@"artwork_cache_id"];
        }
        else
        {
            [itemDic setObject:[NSNumber numberWithLongLong:0] forKey:@"artwork_cache_id"];
        }
        [itemDic setObject:track.comment forKey:@"comment"];
        [itemDic setObject:track.composer forKey:@"composer"];
        
        //    <key>date_created</key>
        //    <date>2012-01-29T02:07:37Z</date>
        
        [itemDic setObject:track.genre?:@"" forKey:@"genre"];
    }
    else{
        [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"exclude_from_shuffle"];
        [itemDic setObject:track.album?:@"" forKey:@"genre"];
    }
    //TODO 是否是正确时间
    NSDate *date = [NSDate date];
    [itemDic setObject:date forKey:@"date_create"];
    //todo 需要编辑很多类似字段 这个地方is song等信息需要测试
    switch (track.mediaType)
    {
        case AudioAndVideo:
            break;
        case Audio:
            [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"is_song"];
            break;
        case Video:
            [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"is_movie"];
            break;
        case HomeVideo:
            [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"is_home_video"];
            break;
        case Podcast:
            [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"is_podcast"];
            break;
        case VideoPodcast:
            [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"is_podcast"];
            [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"is_movie"];
            break;
        case Audiobook:
            [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"is_audio_book"];
            break;
        case MusicVideo:
            [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"is_music_video"];
            break;
        case TVShow:
        case TVAndMusic:
            [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"is_tv_show"];
            break;
        case Ringtone:
            [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"is_ringtone"];
            break;
        case iTunesU:
        case iTunesUVideo:
            [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"is_itunes_u"];
            if (track.isVideo)
            {
                [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"is_movie"];
            }
            break;
        case Books:
        case PDFBooks:
            [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"is_book"];
            break;
        case VoiceMemo:
            [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"is_voice_memo"];
            break;
        default:
            [itemDic setObject:[NSNumber numberWithBool:true] forKey:@"is_song"];
            break;
    }
    //    [itemDic setObject:[NSNumber numberWithBool:track.rememberPlaybackPosition] forKey:@"remember_bookmark"];
    //    <key>remember_bookmark</key>
    //    <false/>
    //是否需要做类似sqlite3的工作
    if (track.mediaType == VoiceMemo) {
        NSString *deviceName = iPod.deviceInfo.deviceName;
        [itemDic setObject:track.album forKey:@"sort_album"];
        [itemDic setObject:deviceName forKey:@"sort_artist"];
        [itemDic setObject:track.title forKey:@"title"];
        [itemDic setObject:track.title forKey:@"sort_name"];
        
    }
    else{
        [itemDic setObject:track.album forKey:@"sort_album"];
        [itemDic setObject:track.albumArtist forKey:@"sort_album_artist"];
        [itemDic setObject:track.artist forKey:@"sort_artist"];
        [itemDic setObject:track.composer forKey:@"sort_composer"];
        [itemDic setObject:track.title forKey:@"sort_name"];
        [itemDic setObject:track.title forKey:@"title"];
    }
    //这里都是用的毫秒数
    [itemDic setObject:[NSNumber numberWithUnsignedInt:track.length] forKey:@"total_time_ms"];
    [itemDic setObject:[NSNumber numberWithUnsignedInt:track.trackNumber] forKey:@"track_number"];
    [itemDic setObject:[NSNumber numberWithUnsignedInt:track.year] forKey:@"year"];
    
    //TODO 可有可无的东东,应该能取到，歌词id
    //<key>lyrics</key>
    //<dict>
    //    <key>checksum</key>
    //    <integer>1554509473</integer>
    //</dict>
    
    //编辑plist location section部分
    //<key>location</key>
    //<dict>
    //    <key>date_created</key>
    //    <date>2012-01-29T02:07:37Z</date>
    //    <key>extension</key>
    //    <string>MP3 </string>
    //    <key>file_size</key>
    //    <integer>4842585</integer>
    //    <key>kind</key>
    //    <string>MPEG 音频文件</string>
    //    <key>location</key>
    //    <string>iTunes_Control/Music/F07/USPZ.mp3</string>
    //    <key>location_type</key>
    //    <string>FILE</string>
    //</dict>
    NSMutableDictionary *locationDic = [[NSMutableDictionary alloc] init];
    //这个地方由于ios设备会自己添加，所以注释这里的东东
    //locationDic.Add("date_created", DateTime.Now);
    //Ok
    //locationDic.Add("extension", Path.GetExtension(track.FilePath).Replace(".", ""));
    //locationDic.Add("file_size", track.FileSize.ByteCount);
    //ok
    //locationDic.Add("kind", track.FileType);
    switch (track.mediaType)
    {
        case Audio:
        case Books:
        case PDFBooks:
            //Todo: MPEG audio file
            [locationDic setObject:@"MPEG audio file" forKey:@"kind"];
            break;
        case Podcast:
        case VideoPodcast:
            [locationDic setObject:@"Podcast" forKey:@"kind"];
            break;
        case Audiobook:
            [locationDic setObject:@"Audio Book" forKey:@"kind"];
            break;
        case MusicVideo:
            [locationDic setObject:@"Music Video" forKey:@"kind"];
            break;
        case TVShow:
        case TVAndMusic:
            [locationDic setObject:@"TV Show" forKey:@"kind"];
            break;
        case Ringtone:
            [locationDic setObject:@"Ringtone" forKey:@"kind"];
            break;
        case iTunesU:
        case iTunesUVideo:
            [locationDic setObject:@"iTunes U" forKey:@"kind"];
            break;
        case VoiceMemo:
            [locationDic setObject:@"AAC audio file" forKey:@"kind"];
            break;
        default:
            [locationDic setObject:track.fileTypeStr forKey:@"kind"];
            break;
    }
    //这个地方由于ios设备会自己添加，所以注释这里的东东
    //locationDic.Add("location", track.FilePath.Replace("\\", "/"));
    //TODO暂时编辑为 FILE
    //locationDic.Add("location_type", "FILE");
    
    //plist item_stats section
    //<key>item_stats</key>
    //<dict>
    //    <key>has_been_played</key>
    //    <true/>
    //    <key>play_count_recent</key>
    //    <integer>0</integer>
    //    <key>play_count_user</key>
    //    <integer>0</integer>
    //    <key>skip_count_recent</key>
    //    <integer>0</integer>
    //    <key>skip_count_user</key>
    //    <integer>0</integer>
    //</dict>
    
    //region edit item_stats section
    NSMutableDictionary *itemStatsDic = [[NSMutableDictionary alloc] init];
    //这里编辑playCount与rating
    if (track.playCount > 0)
    {
        [itemStatsDic setObject:[NSNumber numberWithBool:true] forKey:@"has_been_played"];
        [itemStatsDic setObject:[NSNumber numberWithInt:track.playCount] forKey:@"play_count_recent"];
        [itemStatsDic setObject:[NSNumber numberWithInt:track.playCount] forKey:@"play_count_user"];
        //TODO 这里需要生成那些类吗
        [itemStatsDic setObject:[NSNumber numberWithUnsignedInt:track.dateLastPalyed] forKey:@"date_played"];
    }
    else
    {
        [itemStatsDic setObject:[NSNumber numberWithBool:false] forKey:@"has_been_played"];
        [itemStatsDic setObject:[NSNumber numberWithInt:0] forKey:@"play_count_recent"];
        [itemStatsDic setObject:[NSNumber numberWithInt:0] forKey:@"play_count_user"];
    }
    [itemStatsDic setObject:[NSNumber numberWithInt:0] forKey:@"skip_count_recent"];
    [itemStatsDic setObject:[NSNumber numberWithInt:0] forKey:@"skip_count_user"];
    
    //edit rating
    
    if (track.ratingInt > 0)
    {
        //这个地方是否需要IPodRating类
        [itemStatsDic setObject:[NSNumber numberWithInt:track.ratingInt] forKey:@"user_rating"];
    }
    else
    {
        [itemStatsDic setObject:[NSNumber numberWithInt:0] forKey:@"user_rating"];
    }
    
    //region plist avformat_info
    //<key>avformat_info</key>
    //<dict>
    //    <key>audio_format</key>
    //    <integer>301</integer>
    //    <key>bit_rate</key>
    //    <integer>192</integer>
    //    <key>duration</key>
    //    <integer>9587928</integer>
    //    <key>gapless_encoding_delay</key>
    //    <integer>528</integer>
    //    <key>gapless_encoding_drain</key>
    //    <integer>792</integer>
    //    <key>gapless_heuristic_info</key>
    //    <integer>33554435</integer>
    //    <key>gapless_last_frame_resynch</key>
    //    <integer>5205816</integer>
    //    <key>sample_rate</key>
    //    <real>44100</real>
    //</dict>
    //region avformat_info section
    NSMutableDictionary *avfDic = [[NSMutableDictionary alloc] init];
    //TODO 暂时为301,302,502
    int audio_format = 301;
    if (track.filePath != nil) {
        NSString *ext = [track.filePath stringByDeletingPathExtension];
        if (ext != nil && [ext isCaseInsensitiveLike:@"mp3"])
        {
            if (track.audioChannels < 2)
            {
                audio_format = 302;
            }
            else
            {
                audio_format = 301;
            }
        }
        else if (ext != nil && [ext isCaseInsensitiveLike:@"m4a"])
        {
            audio_format = 502;
        }
    }
    
    long long duration = (track.length*track.sampleRate);
    [avfDic setObject:[NSNumber numberWithInt:audio_format] forKey:@"audio_format"];
    [avfDic setObject:[NSNumber numberWithUnsignedInt:track.bitrate] forKey:@"bit_rate"];
    [avfDic setObject:[NSNumber numberWithUnsignedLongLong:duration] forKey:@"duration"];
    [avfDic setObject:[NSNumber numberWithUnsignedInt:track.sampleRate] forKey:@"sample_rate"];
    //这段需要对track对象进行修改,是否不需要进行编辑
    //avfDic.Add("gapless_encoding_delay", 1);
    //avfDic.Add("gapless_encoding_drain", 1);
    //avfDic.Add("gapless_heuristic_info", 1);
    //avfDic.Add("gapless_last_frame_resynch", 1);
    
    if (track.mediaType == VoiceMemo) {
        [avfDic setObject:[NSNumber numberWithInt:1] forKey:@"channels"];
        [avfDic setObject:[NSNumber numberWithInt:2112] forKey:@"gapless_encoding_delay"];
        [avfDic setObject:[NSNumber numberWithInt:960] forKey:@"gapless_encoding_drain"];
        [avfDic setObject:[NSNumber numberWithInt:1] forKey:@"gapless_heuristic_info"];
        [avfDic setObject:[NSNumber numberWithInt:0] forKey:@"gapless_last_frame_resynch"];
    }
    
    //这里对返回值进行编辑
    NSMutableDictionary *secDic = [[[NSMutableDictionary alloc] init] autorelease];
    [secDic setObject:avfDic forKey:@"avformat_info"];
    [secDic setObject:itemDic forKey:@"item"];
    [secDic setObject:itemStatsDic forKey:@"item_stats"];
    [secDic setObject:locationDic forKey:@"location"];
    
    //<key>operation</key>
    //<string>insert_track</string>
    //<key>pid</key>
    //<integer>-2643959488967719015</integer>
    [secDic setObject:@"insert_track" forKey:@"operation"];
    [secDic setObject:[NSNumber numberWithLongLong:track.dbID]  forKey:@"pid"];
    
    [avfDic release];
    [itemDic release];
    [itemStatsDic release];
    [locationDic release];
    
    
    //对Ringtone部分进行编辑 ringtone_info section
    //<key>ringtone_info</key>
    //<dict>
    //    <key>guid</key>
    //    <string>446B1139D8CF9A73</string>
    //</dict>
    if (track.mediaType == Ringtone)
    {
        NSMutableDictionary *ringtoneDic = [[NSMutableDictionary alloc] init];
        NSString *guid = [NSString stringWithFormat:@"%llx",track.dbID];
        [ringtoneDic setObject:guid forKey:@"guid"];
        [secDic setObject:ringtoneDic forKey:@"ringtone_info"];
        [ringtoneDic release];
    }
    
    return secDic;
    
}

//编辑删除的Track信息
- (NSArray*) buildDeleteInfo:(NSArray*)deletedTracks {
    
    NSMutableArray *deletedInfoArray = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *trackIds = [[NSMutableArray alloc] init];
    NSMutableArray *albumPids = [[NSMutableArray alloc] init];
    NSMutableArray *artistPids = [[NSMutableArray alloc] init];
    NSMutableArray *playlistPids = [[NSMutableArray alloc] init];
    
    for (int i=0; i < deletedTracks.count; i++) {
        IMBTrack *track = [deletedTracks objectAtIndex:i];
        
        if (![trackIds containsObject:[NSNumber numberWithLongLong:track.dbID]]) {
            [trackIds addObject:[NSNumber numberWithLongLong:track.dbID]];
        }
        
        if (track.album_pid != 0 && ![albumPids containsObject:[NSNumber numberWithLongLong:track.album_pid]]) {
            [albumPids addObject:[NSNumber numberWithLongLong:track.album_pid]];
        }
        
        if (track.item_artist_pid != 0 && ![artistPids containsObject:[NSNumber numberWithLongLong:track.album_artist_pid]]) {
            [artistPids addObject:[NSNumber numberWithLongLong:track.album_artist_pid]];
        }
        
        for (int j=0; j < track.playlistPids.count;j++) {
            if (![playlistPids containsObject:[track.playlistPids objectAtIndex:j]]) {
                [playlistPids addObject:[track.playlistPids objectAtIndex:j]];
            }
        }
    }
    
    //编辑删除track的文字
    for (int i=0; i < trackIds.count; i++) {
        [deletedInfoArray addObject:[self buildDeletedTrackInfo:[trackIds objectAtIndex:i]]];
    }
    
    //编辑删除album的文字
    for (int i=0; i < albumPids.count; i++) {
        [deletedInfoArray addObject:[self buildDeletedAlbumInfo:[albumPids objectAtIndex:i]]];
    }
    
    //编辑删除artist的文字
    for (int i=0; i < artistPids.count; i++) {
        [deletedInfoArray addObject:[self buildDeletedArtistInfo:[artistPids objectAtIndex:i]]];
    }
    
    //编辑从playlist删除track的文字
    for (int i=0; i < playlistPids.count; i++) {
        [deletedInfoArray addObject:[self buildUpdatedPlaylistInfo:[playlistPids objectAtIndex:i]]];
    }
    
    [trackIds release];
    [albumPids release];
    [artistPids release];
    [playlistPids release];
    
    return deletedInfoArray;
}

//编辑删除部分的track信息
- (NSDictionary*) buildDeletedTrackInfo:(NSNumber*)pid {
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    //<dict>
    //<key>operation</key>
    //<string>delete_track</string>
    //<key>pid</key>
    //<integer>7442072117974672808</integer>
    // </dict>
    [dic setObject:@"delete_track" forKey:@"operation"];
    [dic setObject:pid forKey:@"pid"];
    return dic;
}

//编辑删除部分的album信息
- (NSDictionary*) buildDeletedAlbumInfo:(NSNumber*)pid {
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    //<dict>
    //    <key>operation</key>
    //    <string>delete_album</string>
    //    <key>pid</key>
    //    <integer>-5348399467991810065</integer>
    //</dict>
    [dic setObject:@"delete_album" forKey:@"operation"];
    [dic setObject:pid forKey:@"pid"];
    return dic;
}

//编辑删除部分的artist信息
- (NSDictionary*) buildDeletedArtistInfo:(NSNumber*)pid {
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    //<dict>
    //    <key>operation</key>
    //    <string>delete_artist</string>
    //    <key>pid</key>
    //    <integer>-7720769327798482568</integer>
    //</dict>
    [dic setObject:@"delete_artist" forKey:@"operation"];
    [dic setObject:pid forKey:@"pid"];
    return dic;
}

//编辑playlist中被删除歌曲部分的信息
- (NSDictionary*) buildUpdatedPlaylistInfo:(NSNumber*)pid {
    //<dict>
    //<key>container</key>
    //<dict>
    //    <key>date_modified</key>
    //    <date>2012-02-13T15:24:58Z</date>
    //</dict>
    //<key>operation</key>
    //<string>update_playlist</string>
    //<key>pid</key>
    //<integer>-3726335822411404359</integer>
    //</dict>
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    NSMutableDictionary *dateDic = [[NSMutableDictionary alloc] init];
    [dateDic setObject:[NSDate date] forKey:@"date_modified"];
    [dic setObject:@"update_playlist" forKey:@"operation"];
    [dic setObject:dateDic forKey:@"container"];
    [dateDic release];
    [dic setObject:pid forKey:@"pid"];
    
    return dic;
}

//编辑删除部分的playlist的信息。
- (NSDictionary*) buildDeletedPlaylist:(IMBPlaylist*)pl {
    // <dict>
    //    <key>operation</key>
    //    <string>delete_playlist</string>
    //    <key>pid</key>
    //    <integer>4649545740367775707</integer>
    //</dict>
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    [dic setObject:@"delete_playlist" forKey:@"operation"];
    [dic setObject:[NSNumber numberWithLongLong:pl.iD] forKey:@"pid"];
    return dic;
}

//编辑其他创建，修改等playlist的信息
- (NSDictionary*) buildPlaylist:(IMBPlaylist*)pl {
    //    <dict>
    //    <key>container</key>
    //    <dict>
    //        <key>date_created</key>
    //        <date>2012-05-21T12:00:04Z</date>
    //        <key>date_modified</key>
    //        <date>2012-05-21T12:00:05Z</date>
    //        <key>name</key>
    //        <string>NEWPLAYLIST</string>
    //    </dict>
    //    <key>container_ui</key>
    //    <dict>
    //        <key>has_been_shuffled</key>
    //        <false/>
    //        <key>is_reversed</key>
    //        <false/>
    //        <key>play_order</key>
    //        <integer>1</integer>
    //        <key>shuffle_items</key>
    //        <false/>
    //    </dict>
    //    <key>item_to_container</key>
    //    <array>
    //    <integer>4886987475409295970</integer>
    //    <integer>5686798621732625013</integer>
    //    <integer>5035799777159010952</integer>
    //    <integer>4615786335348578991</integer>
    //    <integer>5250987396854307542</integer>
    //    <integer>5518969166868896547</integer>
    //    </array>
    //    <key>operation</key>
    //    <string>insert_playlist</string>
    //    <key>pid</key>
    //    <integer>4649545740367775707</integer>
    //</dict>
    bool isExistPlaylist = [sqliteTable_5 isExistPlaylist:pl];
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    NSMutableDictionary *colDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *uiDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *itemArray;
    
    if (!isExistPlaylist)
    {
        [colDic setObject:[NSDate date] forKey:@"date_created"];
    }
    [colDic setObject:[NSDate date] forKey:@"date_modified"];
    [colDic setObject:pl.name forKey:@"name"];
    [dic setObject:colDic forKey:@"container"];
    [colDic release];
    
    [uiDic setObject:[NSNumber numberWithBool:false] forKey:@"has_been_shuffled"];
    [uiDic setObject:[NSNumber numberWithBool:false] forKey:@"is_reversed"];
    [uiDic setObject:[NSNumber numberWithInt:1] forKey:@"play_order"];
    [uiDic setObject:[NSNumber numberWithBool:false] forKey:@"shuffle_items"];
    [dic setObject:uiDic forKey:@"container_ui"];
    [uiDic release];
    
    //item_to_container
    if (pl.trackCount > 0)
    {
        itemArray = [[NSMutableArray alloc] init];
        for (int i=0; i < pl.tracks.count; i++) {
            long long trackDBID = [[pl.tracks objectAtIndex:i] dbID];
            [itemArray addObject:[NSNumber numberWithLongLong:trackDBID]];
        }
        [dic setObject:itemArray forKey:@"item_to_container"];
        [itemArray release];
    }
    
    if (isExistPlaylist)
    {
        [dic setObject:@"update_playlist" forKey:@"operation"];
    }
    else
    {
        [dic setObject:@"insert_playlist" forKey:@"operation"];
    }
    [dic setObject:[NSNumber numberWithLongLong:pl.iD] forKey:@"pid"];
    
    return dic;
}

#pragma mark - 新增方法
- (NSMutableDictionary *)startCreateCigPlist{
    //    NSString *path = [_syncData sourceMediaPath];
    int revision = [_syncData.cigName integerValue];
    NSMutableArray *dicList = [[NSMutableArray alloc] init];
    NSMutableDictionary *rootDic = [[NSMutableDictionary alloc] init];
    
    NSDictionary *DBDic = [self buildDBInfo];
    if (DBDic == nil) {
        return nil;
    }
    [dicList addObject:DBDic];
    [rootDic setObject:dicList forKey:@"operations"];
    [rootDic setObject:[NSNumber numberWithInt:revision] forKey:@"revision"];
    [rootDic setObject:[NSDate date] forKey:@"timestamp"];
    [dicList release];
    [rootDic autorelease];
    return rootDic;
}

- (NSDictionary *)startCreateSyncDataPlist{
    NSString *contentPath = @"";
    int revision = 0;
    BOOL result = false;
    bool createMediaPlist = false;
    NSMutableDictionary *resultDic = [[[NSMutableDictionary alloc] init] autorelease];
    NSMutableDictionary *rootDic = [self startCreateCigPlist];
    if (rootDic == nil) {
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([_operationDic.allKeys containsObject:[NSString stringWithFormat:@"%d",Audio]]) {
        contentPath = _syncData.sourceMediaPath;
        revision = [_syncData.cigName integerValue];
        //创建plist文件
        result = [self createMediaSyncPlist:contentPath revision:revision rootDic:rootDic mediaType:Audio];
        createMediaPlist = result;
        [resultDic setObject:[NSNumber numberWithBool:result] forKey:@"Audio"];
    }
    if ([_operationDic.allKeys containsObject:[NSString stringWithFormat:@"%d",VoiceMemo]]) {
        contentPath = _syncData.sourceVoiceMemoPath;
        revision = [_syncData.voiceMemoName integerValue];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaType == %d",VoiceMemo];
        NSArray *VoiceMemoTracks = [_delTrackList filteredArrayUsingPredicate:predicate];
        NSMutableArray *delPidList = [NSMutableArray new];
        for (IMBTrack *track in VoiceMemoTracks) {
            [delPidList addObject:[NSNumber numberWithLongLong:track.dbID]];
        }
        if (delPidList != nil && delPidList.count > 0) {
            result = [self createDelVoiceMemosSyncPlist:contentPath WithRevision:revision pidList:delPidList];
        }
        else{
            result = [self createMediaSyncPlist:contentPath revision:revision rootDic:nil mediaType:VoiceMemo];
        }
        [resultDic setObject:[NSNumber numberWithBool:result] forKey:@"VoiceMemo"];
    }
    if ([_operationDic.allKeys containsObject:[NSString stringWithFormat:@"%d",Books]]) {
        contentPath = _syncData.sourceBookPath;
        if (_delTrackList != nil && _delTrackList.count > 0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaType == %d OR mediaType == %d",Books,PDFBooks];
            NSArray *bookTracks = [_delTrackList filteredArrayUsingPredicate:predicate];
            NSMutableArray *delPidList = [NSMutableArray new];
            for (IMBTrack *track in bookTracks) {
                if (!track.isUnusual) {
                    [delPidList addObject:[NSString stringWithFormat:@"%lld",track.dbID]];
                }
                else{
                    [delPidList addObject:[NSString stringWithFormat:@"%@",track.hexPersistentID]];
                }
            }
            result = [self createDelBookContentPlist:contentPath delPidList:delPidList];
        }
        else{
            result = [self createBookContentPlist:contentPath];
        }
        [resultDic setObject:[NSNumber numberWithBool:result] forKey:@"Books"];
    }
    if ([_operationDic.allKeys containsObject:[NSString stringWithFormat:@"%d",Ringtone]]) {
        contentPath = _syncData.sourceRingtonePath;
        revision = [_syncData.ringtoneName integerValue];
        result = [self createMediaSyncPlist:contentPath revision:revision rootDic:nil mediaType:Ringtone];
        [resultDic setObject:[NSNumber numberWithBool:result] forKey:@"Ringtone"];
    }
    if ([_operationDic.allKeys containsObject:[NSString stringWithFormat:@"%d",Application]]) {
        NSArray *appSyncs = _applications;
        if (appSyncs != nil && appSyncs.count > 0) {
            IMBSyncAppBuilder *syncAppBuilder = [IMBSyncAppBuilder singletone];
            if (_isAdd) {
                [syncAppBuilder setOperation:Install];
            }
            else{
                [syncAppBuilder setOperation:Remove];
            }
            
            result = [syncAppBuilder createAppSyncPlist:iPod appSyncs:appSyncs appSyncPath:_syncData.sourceApplicationPath appIconStatePath:_syncData.sourceAppIconStatePath];
            [resultDic setObject:[NSNumber numberWithBool:result] forKey:@"Application"];
        }
    }
    if (!createMediaPlist) {
        @try {
            [rootDic writeToFile:_syncData.sourceMediaPath atomically:YES];
            result = true;
        }
        @catch (NSException *exception) {
            result = false;
        }
        [resultDic setObject:[NSNumber numberWithBool:result] forKey:@"CigType"];
    }
    else{
        [resultDic setObject:[NSNumber numberWithBool:true] forKey:@"CigType"];
    }
    if (![fileManager fileExistsAtPath:_syncData.sourceMediaPath]) {
        result = false;
    }
    return resultDic;
    
}

- (BOOL)createMediaSyncPlist:(NSString *)path revision:(int)revision rootDic:(NSMutableDictionary *)rootDic mediaType:(MediaTypeEnum)mediaType{
    BOOL result = false;
    NSMutableDictionary *rootDict = rootDic;
    if (rootDict == nil) {
        rootDict = [[NSMutableDictionary alloc] init];
        NSMutableArray *dicList = [[NSMutableArray alloc] init];
        [self buildSyncPlistContent:dicList mediaType:mediaType];
        [rootDict setObject:dicList forKey:@"operations"];
        [rootDict setObject:[NSNumber numberWithInt:revision] forKey:@"revision"];
        [rootDict setObject:[NSDate date] forKey:@"timestamp"];
        [dicList release];
    }
    else{
        if ([rootDict.allKeys containsObject:@"operations"]) {
            NSMutableArray *operationLists = [[NSMutableArray alloc]initWithArray:[rootDic objectForKey:@"operations"]];
            [rootDict setObject:operationLists forKey:@"operations"];
            
            [self buildSyncPlistContent:operationLists mediaType:mediaType];
            [operationLists release];
        }
    }
    @try {
        NSString *error = NULL;
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:rootDict format:NSPropertyListBinaryFormat_v1_0 errorDescription:&error];
        if (error != nil) {
            NSLog(@"create plist throw sqliteexception stacktracce");
            result = false;
            return result;
        }
        [plistData writeToFile:path atomically:YES];
        result = true;
    }
    @catch (NSException *exception) {
        NSLog(@"create plist throw sqliteexception stacktracce");
    }
}

- (BOOL)createDelBookContentPlist:(NSString *)path delPidList:(NSArray *)delPidList
{
    BOOL result = false;
    NSMutableDictionary *bookDic = nil;
    IMBSyncBookPlistBuilder *syncBookPlist = [[IMBSyncBookPlistBuilder alloc] initWithIpod:iPod delPidList:delPidList];
    bookDic = [syncBookPlist loadBookDataToDictionary];
    @try {
        if (bookDic != nil && bookDic.count != 0) {
            [bookDic writeToFile:path atomically:YES];
            result = true;
        }
        else{
            result = false;
        }
    }
    @catch (NSException *exception) {
        result = false;
    }
    @finally {
        [syncBookPlist release];
        return result;
    }
}


- (BOOL)createBookContentPlist:(NSString *)path{
    BOOL result = false;
    if (sqliteTable_5.dirtyTracks == nil) {
        return result;
    }
    NSMutableDictionary *bookDic = nil;
    IMBSyncBookPlistBuilder *syncBookPlist = [[[IMBSyncBookPlistBuilder alloc] initWithIpod:iPod] autorelease];
    bookDic = [syncBookPlist loadBookDataToDictionary];
    if(bookDic == nil || bookDic.count == 0)
    {
        return false;
    }
    NSMutableArray *bookArray = nil;
    if ([bookDic.allKeys containsObject:@"Books"]) {
        bookArray = [[[NSMutableArray alloc] initWithArray:[bookDic objectForKey:@"Books"]] autorelease];
    }
    if (bookArray == nil) {
        bookArray = [[[NSMutableArray alloc] init] autorelease];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaType == %d OR mediaType == %d",PDFBooks,Books];
    NSArray *bookTracks = [sqliteTable_5.dirtyTracks filteredArrayUsingPredicate:predicate];
    if (bookTracks != nil) {
        for (IMBTrack *track in bookTracks) {
            NSMutableDictionary *detailedDict = [[NSMutableDictionary alloc] init];
            [detailedDict setObject:[track.filePath pathExtension] forKey:@"Extension"];
            [detailedDict setObject:[NSNumber numberWithBool:true] forKey:@"Has Artwork"];
            [detailedDict setObject:[NSNumber numberWithBool:false] forKey:@"Is Protected"];
            if ([[track.filePath pathExtension] isEqualToString:@"epub"]) {
                [detailedDict setObject:track.album==nil?@"":track.album forKey:@"Album"];
                [detailedDict setObject:track.artist==nil?@"":track.artist forKey:@"Artist"];
                [detailedDict setObject:track.genre==nil?@"":track.genre forKey:@"Genre"];
                [detailedDict setObject:track.uuid==nil?@"":track.uuid forKey:@"Publisher Unique ID"];
                [detailedDict setObject:@"ebook" forKey:@"Kind"];
                [detailedDict setObject:@"application/epub+zip" forKey:@"MIME Type"];
                if ([self checkIosIsHighVersion:iPod]) {
                    [detailedDict setObject:@"pluspub" forKey:@"Flavor"];
                    [detailedDict setObject:@"default" forKey:@"Page Progression Direction"];
                }
            }
            else if([[track.filePath pathExtension] isEqualToString:@"pdf"]){
                [detailedDict setObject:@"ebook" forKey:@"Kind"];
                
                [detailedDict setObject:@"unknown" forKey:@"Kind"];
                [detailedDict setObject:@"application/pdf" forKey:@"MIME Type"];
            }
            [detailedDict setObject:track.title forKey:@"Name"];
            [detailedDict setObject:track.packageHash.length == 0?@"":track.packageHash forKey:@"Package Hash"];
            [detailedDict setObject:[NSString stringWithFormat:@"%lld",track.dbID] forKey:@"Persistent ID"];
            [bookArray addObject:detailedDict];
            [detailedDict release];
        }
    }
    @try {
        if (bookArray == nil || bookArray.count == 0) {
            result = false;
        }
        else{
            [bookDic setObject:bookArray forKey:@"Books"];
            NSString *err = nil;
            NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:bookDic format:NSPropertyListBinaryFormat_v1_0 errorDescription:&err];
            if(err != nil)
            {
                NSLog(@"write plist data to file failed.");
            }
            [plistData writeToFile:path atomically:YES];
            result = true;
        }
    }
    @catch (NSException *exception) {
        result = false;
    }
    return result;
}


- (BOOL)checkIosIsHighVersion:(IMBiPod *)ipod{
    NSString *version = ipod.deviceInfo.productVersion;
    int charnum = 0;
    @try {
        if ([version isVersionMajorEqual:@"10"]) {
            charnum = [[version substringToIndex:2] intValue];
        }else {
            charnum = [[version substringToIndex:1] intValue];
        }
    }
    @catch (NSException *exception) {
        charnum = 0;
    }
    @finally {
        if (charnum > 7) {
            return YES;
        }
        else{
            return NO;
        }
    }
}


- (void) buildSyncPlistContent:(NSMutableArray*) dicArray mediaType:(MediaTypeEnum)mediaType{
    
    if ([sqliteTable_5 dirtyTracks] != nil) {
        NSArray *trackArr = nil;
        if (mediaType == Audio) {
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                IMBTrack *track = (IMBTrack *)evaluatedObject;
                BOOL result = false;
                result = (track.mediaType == Books) || (track.mediaType == PDFBooks) || (track.mediaType == VoiceMemo) || (track.mediaType == Ringtone) || track.mediaType == Photo;
                return !result;
            }];
            trackArr = [sqliteTable_5.dirtyTracks filteredArrayUsingPredicate:predicate];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                IMBTrack *track = (IMBTrack *)evaluatedObject;
                BOOL result = false;
                result = track.mediaType == mediaType;
                return result;
            }];
            trackArr = [sqliteTable_5.dirtyTracks filteredArrayUsingPredicate:predicate];
        }
        for (IMBTrack *track in trackArr) {
            [dicArray addObject:[self buildInsertTrack:track]];
        }
    }
    
    //1，删除track,album,artist
    //2, 找到相关的playlist并做更新
    if (sqliteTable_5.deletedTracks != nil && sqliteTable_5.deletedTracks.count > 0) {
        //编辑删除Track的部分
        NSArray *deltedTrackInfo = [self buildDeleteInfo:sqliteTable_5.deletedTracks];
        [dicArray addObjectsFromArray:deltedTrackInfo];
    }
    
    //1编辑删除delete的playlist部分
    NSArray *deletedPlaylists = iPod.session.deletedPlaylists;
    if (deletedPlaylists != nil && deletedPlaylists.count > 0)
    {
        for (int i=0; i<deletedPlaylists.count; i++) {
            [dicArray addObject:[self buildDeletedPlaylist:[deletedPlaylists objectAtIndex:i]]];
        }
    }
    
    //编辑其他变化过的playlist
    
    NSArray *playlistArray = iPod.playlists.playlistArray;
    if (playlistArray != nil && playlistArray.count > 0) {
        for (int i=0; i < playlistArray.count; i++) {
            
            IMBPlaylist *pl = [playlistArray objectAtIndex:i];
            
            if (pl.isDirty&&pl.isUserDefinedPlaylist)
            {
                //编辑这个变化的playlist包括增加与内容添加部分
                [dicArray addObject:[self buildPlaylist:pl]];
            }
        }
    }
    
}


- (BOOL)InitSyncDataBaseInfo{
    BOOL result = false;
    @try {
        if (sqliteTable_5 != nil) {
            [sqliteTable_5 release];
            sqliteTable_5 = nil;
        }
        sqliteTable_5 = [[IMBSqliteTables_5 alloc] initWithIPod:iPod];
        //        if (iPod.mediaDBPath == nil || iPod.mediaDBPath.length == 0) {
        [sqliteTable_5 exactDeviceDBFiles];
        //        }
        //        else{
        //            sqliteTable_5.localLibraryFile = iPod.mediaDBPath;
        //        }
        if ([sqliteTable_5 openDataBase]) {
            sqliteTable_5.dirtyTracks = _tracks;
            sqliteTable_5.deletedTracks = _delTrackList;
            [sqliteTable_5 getInfoFromDirtyTracks];
            [sqliteTable_5 generateDeleteTracksInfo];
            [sqliteTable_5 closeDataBase];
        }
        result = true;
    }
    @catch (NSException *exception) {
        result = false;
    }
    return result;
}


@end
