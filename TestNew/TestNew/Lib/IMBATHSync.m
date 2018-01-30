//
//  IMBATHSync.m
//  iMobieTrans
//
//  Created by zhang yang on 13-4-9.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBATHSync.h"
//#import "IMBAppSyncModel.h"
//#import "AirTrafficHost.h"
//#import "IMBDeviceInfo.h"
//#import "IMBSession.h"
//#import "IMBFileSystem.h"
//#import "IMBTrack.h"
//#import "IMBAirSyncImportTransfer.h"
//#import "IMBSyncPlistBuilder.h"
//#import "IMBAthServiceInfo.h"
//#import "IMBCreateSyncImage.h"
//#import "IMBExtractDeviceDBFiles.h"
//#import "StringHelper.h"
//#import "IMBSoftWareInfo.h"
//#import "IMBCreatePhotoSyncPlist.h"
//#import "NSString+Category.h"
//#import "OperationLImitation.h"
//#import "IMBNotificationDefine.h"
//#import "IMBDistantObject.h"
//#import "SystemHelper.h"
//#import "IMBTransferError.h"
#define Media_ @"Media"
#define Ringtone_ @"Ringtone"
#define Book_  @"Book"
#define VoiceMemo_ @"VoiceMemo"
#define Photo_ @"Photo"
#define Application_ @"Application"
#define CIG_CREATE_EXCEPTION @"cig_create_exception"

static NSString *_mediaSyncPath = @"/iTunes_Control/Sync/Media/";
static NSString *_toneSyncPath = @"/iTunes_Control/Ringtones/Sync";
static NSString *_recordingSyncPath = @"/Recordings/Sync";
static NSString *_bookSyncPath = @"/Books/Sync";
static NSString *_appSyncPath = @"/PublicStaging/ApplicationSync";

/*
@implementation IMBATHSync
@synthesize isStop = _isStop;
@synthesize opeateTypeDic = _opeateTypeDic;
@synthesize syncTasks = _syncTasks;
@synthesize applicationSyncArr = _applicationSyncArr;
@synthesize currentThread = _currentThread;
@synthesize maxUUIDStr = _maxUUIDStr;
- (id)initWithiPod:(IMBiPod *)iPod syncCtrType:(SyncCtrTypeEnum)ctrType
{
    self = [super init];
    if (self) {
        _limitation = [OperationLImitation singleton];
        _allAssetDic = [[NSMutableDictionary dictionary] retain];
        _srcIpod = [iPod retain];
        _threadValue = 0;
        nc = [NSNotificationCenter defaultCenter];
        logHandle = [IMBLogManager singleton];
        _opeateTypeDic = [[NSMutableDictionary alloc] init];
        _isSyncMedia = NO;
        _isSyncPhoto = NO;
        _isSyncRingTone = NO;
        _isSyncIBook = NO;
        _isSyncVoiceMemo = NO;
        CtrType = ctrType;
        _athServiceInfo = [[IMBAthServiceInfo alloc] init];
        if (_isBetweenDevice) {
            _curIpod = _tarIpod;
        }
        else{
            _curIpod = _srcIpod;
        }
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(airSyncServiceStartSuccess:) name:Notify_AirSyncServiceStartSuccess object:nil];
        runloopThread = [[NSThread alloc] initWithTarget:self
                                                         selector:@selector(threadMain)
                                                           object:nil];
        [runloopThread start];
    }
    return self;
}

- (void)setIsStop:(BOOL)isStop
{
    _isStop = isStop;
    if (_isStop) {
        [self sendAirSyncStop];
        _stopWaitairSyncResult = YES;
        [self performSelector:@selector(wakeUp:) onThread:_currentThread withObject:@(_syncState) waitUntilDone:NO];
    }
}

- (void)threadMain
{
    NSAutoreleasePool * pool = [NSAutoreleasePool new];
    _serverConnection = [[NSConnection alloc] init] ;
    [_serverConnection setRootObject:self];
    [_serverConnection registerName:AirSyncServiceDistantObject];
	NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
    while (!_isStop) {
        [myRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
	[pool release];
}

- (id)initWithiPod:(IMBiPod *)iPod SyncDeleteCategory:(SyncDeleteCategory)syncDelteCategory
{
    self = [self initWithiPod:iPod syncCtrType:SyncDelFile];
    if (self) {
        _syncDelteCategory = syncDelteCategory;
        if (_syncDelteCategory == SyncDelteRingTone) {
            _isSyncRingTone = YES;
        }else if (_syncDelteCategory == SyncDelteBook){
            _isSyncIBook = YES;
        }else if (_syncDelteCategory == SyncDeltePhotoLibrary || _syncDelteCategory == SyncDeltePhotoAlbums){
            _isSyncPhoto = YES;
        }else if (_syncDelteCategory == SyncDelteVoiceMemo){
            _isSyncVoiceMemo = YES;
        }else if (_syncDelteCategory == SyncDelteMedia){
            _isSyncMedia = YES;
        }
    }
    return self;
}

- (id)initWithiPod:(IMBiPod *)iPod SyncDeleteCategoryArray:(NSMutableArray *)syncDelteCategoryArray
{
    self = [self initWithiPod:iPod syncCtrType:SyncDelFile];
    if (self) {
        for (NSNumber *syncDelteCategory in syncDelteCategoryArray) {
            if (syncDelteCategory.intValue == SyncDelteRingTone) {
                _isSyncRingTone = YES;
            }else if (syncDelteCategory.intValue == SyncDelteBook){
                _isSyncIBook = YES;
            }else if (syncDelteCategory.intValue == SyncDeltePhotoLibrary || syncDelteCategory.intValue == SyncDeltePhotoAlbums){
                _isSyncPhoto = YES;
            }else if (syncDelteCategory.intValue == SyncDelteVoiceMemo){
                _isSyncVoiceMemo = YES;
            }else if (syncDelteCategory.intValue == SyncDelteMedia){
                _isSyncMedia = YES;
            }

        }
    }
    return self;
}




- (id)initWithiPod:(IMBiPod *)iPod syncCtrType:(SyncCtrTypeEnum)ctrType photoAlbum:(IMBPhotoEntity *)photoAlbum Rename:(NSString *)rename {
    self = [self initWithiPod:iPod syncCtrType:ctrType];
    if (self) {
        if (photoAlbum != nil) {
            _importPhotoAlbum = [photoAlbum retain];
        }
        _rename = rename;
        _isSyncPhoto = YES;
    }
    return self;
}

- (id)initWithiPod:(IMBiPod *)iPod SyncNodes:(NSArray *)syncNodes syncCtrType:(SyncCtrTypeEnum)ctrType photoAlbum:(IMBPhotoEntity *)photoAlbum {
    if(self = [self initWithiPod:iPod syncCtrType:ctrType])
    {
        if (photoAlbum != nil) {
            _importPhotoAlbum = [photoAlbum retain];
        }
        _isSyncMedia = false;
        if ([syncNodes containsObject:[NSNumber numberWithInt:Category_iBooks]]) {
            _isSyncIBook = true;
        }
        if ([syncNodes containsObject:[NSNumber numberWithInt:Category_VoiceMemos]]) {
            _isSyncVoiceMemo = true;
        }
        if ([syncNodes containsObject:[NSNumber numberWithInt:Category_Ringtone]]) {
            _isSyncRingTone = true;
        }
        if ([syncNodes containsObject:[NSNumber numberWithInt:Category_MyAlbums]] || [syncNodes containsObject:[NSNumber numberWithInt:Category_PhotoLibrary]]) {
            _isSyncPhoto = true;
        }
        for (NSNumber *number in syncNodes) {
            CategoryNodesEnum cateNodes = [number unsignedIntValue];
            if (cateNodes != Category_iBooks && cateNodes != Category_Ringtone && cateNodes != Category_VoiceMemos && cateNodes != Category_PhotoLibrary && cateNodes != Category_MyAlbums && cateNodes != Category_Applications) {
                _isSyncMedia = true;
            }
        }
    }
    return self;
}


- (id)initWithiPod:(IMBiPod *)iPod SyncNodes:(NSArray *)syncNodes syncCtrType:(SyncCtrTypeEnum)ctrType photoAlbums:(NSArray *)photoAlbums
{
    if (self = [self initWithiPod:iPod SyncNodes:syncNodes syncCtrType:ctrType photoAlbum:nil]) {
        _photoAlbums = [photoAlbums retain];
    }
    return self;
}

- (id)initWithiPod:(IMBiPod *)srcIpod desIpod:(IMBiPod *)desIpod syncCtrType:(SyncCtrTypeEnum)ctrType SyncNodes:(NSArray *)syncNodes{
    if (self = [self initWithiPod:desIpod SyncNodes:syncNodes syncCtrType:ctrType photoAlbum:nil]) {
        _srcIpod = [srcIpod retain];
        _tarIpod = [desIpod retain];
        ctrType = ctrType;
        _isBetweenDevice = YES;
    }
    return self;
}


- (void) setListener:(id<ATHCopyFileToDeviceListener>)listener {
    _listener = listener;
}

- (void)dealloc
{
    [_importPhotoAlbum release],_importPhotoAlbum = nil;
    if (_srcIpod != nil) {
        [_srcIpod release];
        _srcIpod = nil;
    }
    [_photoAlbums release],_photoAlbums = nil;
    if (_tarIpod != nil) {
        [_tarIpod release];
        _tarIpod = nil;
    }
    if (_maxUUIDStr != nil) {
        [_maxUUIDStr release];
        _maxUUIDStr = nil;
    }
    if (_typeDic != nil) {
        [_typeDic release];
        _typeDic = nil;
    }
    
    if (_syncTasks != nil) {
        [_syncTasks release];
        _syncTasks = nil;
    }
    
    if (_opeateTypeDic != nil) {
        [_opeateTypeDic release];
        _opeateTypeDic = nil;
    }
    
    if (_athServiceInfo != nil) {
        [_athServiceInfo release];
        _athServiceInfo = nil;
    }
    
    if (_applicationSyncArr != nil){
        [_applicationSyncArr release];
        _applicationSyncArr = nil;
    }
    if (_currentThread != nil) {
        [_currentThread release];
        _currentThread = nil;
    }
    [_grappaDic release],_grappaDic = nil;
    [_allAssetDic release],_allAssetDic = nil;
    [super dealloc];
}



//删除playlist时使用本方法
- (int) sendMetaDataSync:(NSDictionary*)readyDic WithPlistPaths:(NSArray*)paths  {
    NSDictionary *paras = [readyDic objectForKey:@"Params"];
    NSString *mediaAnchors = [[paras objectForKey:@"DataclassAnchors"] objectForKey:Media_];
    NSString *ringtoneAnchors = nil;
    if (_isSyncRingTone) {
        ringtoneAnchors = [[paras objectForKey:@"DataclassAnchors"] objectForKey:Ringtone_];
    }
    NSDictionary *deviceInfo = [paras objectForKey:@"DeviceInfo"];
    NSData *grappaData = [deviceInfo objectForKey:@"Grappa"];
    //1.生成plist
    //2.生成cig文件
    @try {
        [self createCigToDeviceWithGrappa:grappaData WithPlistPath:[paths objectAtIndex:0] WithDataAnchors:mediaAnchors WithType:Media_];

    }
    @catch (NSException *exception) {
        if ([exception.name isEqualToString:CIG_CREATE_EXCEPTION]) {
            [logHandle writeErrorLog:@"create cig failed"];
            return 0;
        }
    }
    //由于RingTone不需要这里注释掉
 
//     if (_isSyncRingTone) {
//    [self createCigToDeviceWithGrappa:grappaData WithPlistPath:[paths objectAtIndex:1] WithDataAnchors:ringtoneAnchors   WithType:Ringtone];
//    }
 
    
    if (_isSyncRingTone) {
        NSString *syncMeiaPath = @"/iTunes_Control/Ringtones/Sync/";
        NSString *plistName = [NSString stringWithFormat:@"Sync_%08d.plist",[ringtoneAnchors intValue]];
        if (![_srcIpod.fileSystem fileExistsAtPath:syncMeiaPath]) {
            [_srcIpod.fileSystem mkDir:syncMeiaPath];
        }
        NSString *ringtonePlistPath = [syncMeiaPath stringByAppendingPathComponent:plistName];
        if ([_srcIpod.fileSystem fileExistsAtPath:ringtonePlistPath]) {
            [_srcIpod.fileSystem unlink:ringtonePlistPath];
        }
        [_srcIpod.fileSystem copyLocalFile:[paths objectAtIndex:1] toRemoteFile:ringtonePlistPath];
    }
    //[self stopReadMessageQueue];
    //3.发送同步命令
    int res = 0;
    if (_threadValue == 0) {
        [logHandle writeErrorLog:@"treadValue is 0!!! in sendMetaDataSync part1"];

        return 0;
    }
    res = ATHostConnectionSendPowerAssertion(_threadValue, (void *)kCFBooleanTrue);
    if (res == 0) {
        //KeyBag
        //lpdic1 = keybagDic, lpdic2 = mediaSesiongDic
        NSMutableDictionary *keybagDict = [[NSMutableDictionary alloc] init];
        int var1 = 1;
        [keybagDict setValue:(id)CFNumberCreate(kCFAllocatorDefault, 3, &var1) forKey:@"Keybag"];
        [keybagDict setValue:(id)CFNumberCreate(kCFAllocatorDefault, 3, &var1) forKey:Media_];
        if (_isSyncRingTone) {
            [keybagDict setValue:(id)CFNumberCreate(kCFAllocatorDefault, 3, &var1) forKey:Ringtone_];
        }
        
        NSMutableDictionary *mediaSessionDict = [[NSMutableDictionary alloc] init];
        [mediaSessionDict setValue:mediaAnchors forKey:Media_];
        if (_isSyncRingTone) {
            [mediaSessionDict setValue:mediaAnchors forKey:Ringtone_];
        }
        
//        [logHandle writeInfoLog:[NSString stringWithFormat:@"keybagDict: %@", [(NSDictionary*)keybagDict description]]];
//        [logHandle writeInfoLog:[NSString stringWithFormat:@"mediaSessionDict: %@", [(NSDictionary*)mediaSessionDict description]]];
        
        //int msgid = ATHostConnectionReadMessage(_threadValue);
        if (_threadValue == 0) {
            [logHandle writeErrorLog:@"treadValue is 0!!! in sendMetaDataSync part2"];
            return 0;
        }
        res = ATHostConnectionSendMetadataSyncFinished(_threadValue, (id)(CFDictionaryRef)keybagDict, (id)(CFDictionaryRef)mediaSessionDict);
        //TODO 这个地方可能会读到 AssetManifest 或者 SyncFinished,
        return res;
    }
    return res;
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

- (void)copyPlistLogFloder {
    if ([[NSFileManager defaultManager] fileExistsAtPath:_syncDataItem.sourceMediaPath]) {
        NSString *plistPath = [logHandle.logsFolderPath stringByAppendingPathComponent:[_syncDataItem.sourceMediaPath lastPathComponent]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            plistPath = [TempHelper getFilePathAlias:plistPath];
        }
        [[NSFileManager defaultManager] copyItemAtPath:_syncDataItem.sourceMediaPath toPath:plistPath error:nil];
        [logHandle writeInfoLog:[NSString stringWithFormat:@"sync plist path:%@", plistPath]];
    }
}


- (BOOL) createCigToDeviceWithGrappa:(NSData*)grappaData WithPlistPath:(NSString*)plistPath  {
    BOOL isSuccess = NO;
    [logHandle writeInfoLog:@"+++++++++++create cig Begin+++++"];
    
    NSData* data = [MediaHelper cigFromWebserviceWithPath:plistPath withUUID:_curIpod.deviceInfo.serialNumberForHashing withGrappaData:grappaData isSuccess:&isSuccess];
    
    if (!isSuccess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CREAT_CIG_ERROR object:nil];
    }
    [logHandle writeInfoLog:@"+++++++++++create cig end++++++"];
    //Todo 用session的值来做处理
    NSString *cigTempPath = [plistPath stringByAppendingString:@".cig"];
    [data writeToFile:cigTempPath atomically:NO];
    return isSuccess;
}

- (BOOL) createCigToDeviceWithGrappa:(NSData*)grappaData WithPlistPath:(NSString*)plistPath WithDataAnchors:(NSString*)anchors WithType:(NSString*)type  {
    BOOL isSuccess = NO;
    NSData* data = [MediaHelper cigFromWebserviceWithPath:plistPath withUUID:_curIpod.deviceInfo.serialNumberForHashing withGrappaData:grappaData isSuccess:&isSuccess];
    if (!isSuccess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CREAT_CIG_ERROR object:nil];
    }

    
    //Todo 用session的值来做处理
    NSString *cigTempPath = [plistPath stringByAppendingString:@".cig"];
    [data writeToFile:cigTempPath atomically:NO];
    //Sync_00000025.plist
    NSString *plistName = [NSString stringWithFormat:@"Sync_%08d.plist",[anchors intValue]];
    NSString *plistCigName = [NSString stringWithFormat:@"Sync_%08d.plist.cig",[anchors intValue]];

    NSString *syncMeiaPath = @"";
    syncMeiaPath = @"/iTunes_Control/Sync/Media";
    if (![_curIpod.fileSystem fileExistsAtPath:syncMeiaPath]) {
        [_curIpod.fileSystem mkDir:syncMeiaPath];
    }
    NSString *plistFiePath = [syncMeiaPath stringByAppendingPathComponent:plistName];
    if ([_curIpod.fileSystem fileExistsAtPath:plistFiePath]) {
        [_curIpod.fileSystem unlink:plistFiePath];
    }
    NSString *cigFiePath = [syncMeiaPath stringByAppendingPathComponent:plistCigName];
    if ([_curIpod.fileSystem fileExistsAtPath:cigFiePath]) {
        [_curIpod.fileSystem unlink:cigFiePath];
    }
    
    isSuccess = [_curIpod.fileSystem copyLocalFile:plistPath toRemoteFile:plistFiePath];
    isSuccess = [_curIpod.fileSystem copyLocalFile:cigTempPath toRemoteFile:cigFiePath];
    return isSuccess;
    
}

- (NSArray*) CreateAseetArray:(NSDictionary*)assetManifestDic {
    NSMutableArray *assetArray = [[[NSMutableArray alloc] init] autorelease];
    NSArray *mediaArray = [assetManifestDic objectForKey:Media_];
    if (mediaArray != nil && mediaArray.count > 0) {
        for (int i=0; i<mediaArray.count; i++) {
            IMBATHSyncAssetEntity *assetEntity = [[IMBATHSyncAssetEntity alloc] init];
            NSDictionary *mediaDic = [mediaArray objectAtIndex:i];
            NSString *assetID = [mediaDic objectForKey:@"AssetID"];
            assetEntity.assetID = assetID;
            assetEntity.assetType = Media_;
            [assetArray addObject:assetEntity];
            [assetEntity release];
        }
    }
    NSArray *ringtoneArray = [assetManifestDic objectForKey:Ringtone_];
    if (ringtoneArray != nil && ringtoneArray.count > 0) {
        for (int i=0; i<ringtoneArray.count; i++) {
            IMBATHSyncAssetEntity *assetEntity = [[IMBATHSyncAssetEntity alloc] init];
            NSDictionary *mediaDic = [ringtoneArray objectAtIndex:i];
            NSString *assetID = [mediaDic objectForKey:@"AssetID"];
            assetEntity.assetID = assetID;
            assetEntity.assetType = Ringtone_;
            [assetArray addObject:assetEntity];
            [assetEntity release];
        }
    }
    NSArray *iBookArray = [assetManifestDic objectForKey:Book_];
    if (iBookArray != nil && iBookArray.count > 0) {
        for (int i = 0; i < iBookArray.count; i++) {
            IMBATHSyncAssetEntity *assetEntity = [[IMBATHSyncAssetEntity alloc] init];
            NSDictionary *mediaDic = [iBookArray objectAtIndex:i];
            NSString *assetID = [mediaDic objectForKey:@"AssetID"];
            assetEntity.assetID = assetID;
            assetEntity.assetType = Book_;
            [assetArray addObject:assetEntity];
            [assetEntity release];
        }
    }
    NSArray *voiceMemoArray = [assetManifestDic objectForKey:VoiceMemo_];
    if (voiceMemoArray != nil && voiceMemoArray.count >0) {
        for (int i = 0;  i < voiceMemoArray.count; i++) {
            IMBATHSyncAssetEntity *assetEntity = [[IMBATHSyncAssetEntity alloc] init];
            NSDictionary *mediaDic = [voiceMemoArray objectAtIndex:i];
            NSString *assetID = [mediaDic objectForKey:@"AssetID"];
            assetEntity.assetID = assetID;
            assetEntity.assetType = VoiceMemo_;
            [assetArray addObject:assetEntity];
            [assetEntity release];
        }
    }
    NSArray *photoArray = [assetManifestDic objectForKey:Photo_];
    if (photoArray != nil && photoArray.count > 0) {
        for (int i=0; i<photoArray.count; i++) {
            IMBATHSyncAssetEntity *assetEntity = [[IMBATHSyncAssetEntity alloc] init];
            NSDictionary *mediaDic = [photoArray objectAtIndex:i];
            NSString *assetID = [mediaDic objectForKey:@"AssetID"];
            assetEntity.assetID = assetID;
            assetEntity.assetType = Photo_;
            [assetArray addObject:assetEntity];
            [assetEntity release];
        }
    }
    NSArray *applicationArray = [assetManifestDic objectForKey:Application_];
    if (applicationArray != nil && applicationArray.count > 0) {
        for (int i = 0; i < applicationArray.count; i++) {
            IMBATHSyncAssetEntity *assetEntity = [[IMBATHSyncAssetEntity alloc] init];
            NSDictionary *applicationDic = [applicationArray objectAtIndex:i];
            NSString *assetID= [applicationDic objectForKey:@"AssetID"];
            assetEntity.assetID = assetID;
            assetEntity.assetType = Application_;
            [assetArray addObject:assetEntity];
            [assetEntity release];
        }
    }
    return assetArray;
    
}

- (int) addTracks:(NSArray*) newtracks ByAssetManifest:(NSDictionary*)assetManifestDic {
    //1.读出AssetManifest的消息
    //2.对manifestDic中的mediaArray进行遍历。如果不存在于tracks那就发送 sendfileError的命令。
    //3.如果存在的话，就开始拷贝。拷贝完成时发送sendFileCompletedByAssetID消息
    //Todo，拷贝时，有回调函数来通知设备当前进度。
    NSArray *tracks = [self filterToTrackArray:newtracks isIMBTrack:YES];
    NSArray *totalAssetArray = [self CreateAseetArray:assetManifestDic];
    NSPredicate *mediaPre = [NSPredicate predicateWithFormat:@"assetType != %@",Application_];
    NSArray *mediaArray = [totalAssetArray filteredArrayUsingPredicate:mediaPre];
    int value = 0;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (mediaArray.count > 0) {
        NSMutableArray *typeArr = [[[NSMutableArray alloc] init] autorelease];
        if ([assetManifestDic.allKeys containsObject:Media_]) {
            [typeArr addObject:Media_];
        }
        if ([assetManifestDic.allKeys containsObject:Ringtone_]) {
            [typeArr addObject:Ringtone_];
        }
        if ([assetManifestDic.allKeys containsObject:Book_]) {
            [typeArr addObject:Book_];
        }
        if ([assetManifestDic.allKeys containsObject:VoiceMemo_]) {
            [typeArr addObject:VoiceMemo_];
        }
        if ([assetManifestDic.allKeys containsObject:Photo_]) {
            [typeArr addObject:Photo_];
        }
        //Media 可以Ringtone
        for (NSString *type in typeArr) {
            NSString *syncPath = [NSString stringWithFormat:@"/Airlock/%@", type];
            NSString *syncArtworkPath = [NSString stringWithFormat:@"/Airlock/%@/Artwork", type];
            if ([_curIpod.fileSystem fileExistsAtPath:syncPath]) {
                [_curIpod.fileSystem unlink:syncPath];
            }
            [_curIpod.fileSystem mkDir:syncPath];
            if (![_curIpod.fileSystem fileExistsAtPath:syncArtworkPath] && ![type isEqualToString:Book_] && ![type isEqualToString:Photo_]) {
                [_curIpod.fileSystem mkDir:syncArtworkPath];
            }
        }
        int curentItem = 0;
        for (int i=0; i < mediaArray.count; i++) {
            IMBATHSyncAssetEntity *assetEntity = [mediaArray objectAtIndex:i];
            NSString *assetID = assetEntity.assetID;
            if (tracks.count > 0) {
                NSPredicate *predict = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    return (((IMBTrack*)evaluatedObject).dbID == [assetID longLongValue] || [((IMBTrack*)evaluatedObject).uuid isEqualToString:assetID]);
                }];
                NSArray *preArray = [tracks filteredArrayUsingPredicate:predict];
                IMBTrack *track = nil;
                if (preArray != 0 && preArray.count > 0) {
                    track = [preArray objectAtIndex:0];
                    if (_limitation.remainderCount == 0) {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:track.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                        [self sendAirSyncStop];
                        _isStop = YES;
                    }
                    if (track != nil && _isStop == FALSE) {
                        BOOL isExist = false;
                        if (_isBetweenDevice) {
                            isExist = [_srcIpod.fileSystem fileExistsAtPath:track.filePath];
                        }
                        else{
                            isExist = [fm fileExistsAtPath:track.srcFilePath];
                        }
                        NSString *syncPath = nil;
                        NSString *syncArtworkPath = nil;
                        NSString *currentFileName = assetEntity.assetID;
                        NSData *newData = nil;
                        if (track.mediaType == PDFBooks || track.mediaType == Books) {
                            syncPath = [NSString stringWithFormat:@"/Airlock/%@", Book_];
                        }
                        else if(track.mediaType == Ringtone){
                            syncPath = [NSString stringWithFormat:@"/Airlock/%@", Ringtone_];
                            syncArtworkPath = [NSString stringWithFormat:@"/Airlock/%@/Artwork", Ringtone_];
                        }
                        else if(track.mediaType == VoiceMemo){
                            syncPath = [NSString stringWithFormat:@"/Airlock/%@", VoiceMemo_];
                            syncArtworkPath = [NSString stringWithFormat:@"/Airlock/%@/Artwork", VoiceMemo_];
                        }
                        else if (track.mediaType == Photo) {
                            @autoreleasepool {
                                IMBCreateSyncImage *createImage = [[IMBCreateSyncImage alloc] initWithImage:_srcIpod];
                                newData = [[createImage createImageDataByTract:track withType:_isBetweenDevice] retain];
                                [createImage release];
                            }
                            syncPath = [NSString stringWithFormat:@"/Airlock/%@", Photo_];
                        }else{
                            syncPath = [NSString stringWithFormat:@"/Airlock/%@", Media_];
                            syncArtworkPath = [NSString stringWithFormat:@"/Airlock/%@/Artwork", Media_];
                        }
                        
                        NSString *srcFilePath = @"";
                        if (_isBetweenDevice) {
                            srcFilePath = [_srcIpod.fileSystem.driveLetter stringByAppendingPathComponent:track.srcFilePath];
                        }
                        else{
                            srcFilePath = track.srcFilePath;
                        }
                        curentItem++;
                        //设备间传输区别对比
                        NSFileManager *fm = nil;
                        fm = [NSFileManager defaultManager];
                        
                        if (_isBetweenDevice) {
                            if (![StringHelper stringIsNilOrEmpty:track.deviceWorkPath] && track.mediaType != VoiceMemo) {
                                NSString *syncArtworkPath1 = [syncArtworkPath stringByAppendingPathComponent:currentFileName];
                                @try {
                                    [_tarIpod.fileSystem copyFileBetweenDevice:track.deviceWorkPath sourDriverLetter:_srcIpod.fileSystem.driveLetter targFileName:syncArtworkPath1 targDriverLetter:_tarIpod.fileSystem.driveLetter sourDevice:_srcIpod];
                                }
                                @catch (NSException *exception) {
                                    [logHandle writeInfoLog:[NSString stringWithFormat:@"StactTrace:%@",exception.description]];
                                }
                            }
                        }
                        else{
                            if (track.artworkPath != nil) {
                                [_curIpod.fileSystem copyLocalFile:track.artworkPath toRemoteFile:[syncArtworkPath stringByAppendingPathComponent:assetID]];
                            }
                        }
                        BOOL isSuccess = NO;
                        if (track.mediaType == Photo) {
                            if (_listener && [_listener respondsToSelector:@selector(copyDataFromSrcPath:ToDesPath:WithTrack:WithAssetID:)]) {
                                isSuccess = [_listener copyDataFromSrcPath:newData ToDesPath:[syncPath stringByAppendingPathComponent:assetID] WithTrack:track WithAssetID:assetID];
                            }
                        }else {
                            if (_listener && [_listener respondsToSelector:@selector(copyFileFromSrcPath:ToDesPath:WithTrack:WithAssetID:)]) {
                                NSString *srcPath = track.srcFilePath;
                                NSString *desPath = [syncPath stringByAppendingPathComponent:assetID];
                                isSuccess = [_listener copyFileFromSrcPath:srcPath ToDesPath:desPath WithTrack:track WithAssetID:assetID];
                            }
                        }
                        if (newData != nil) {
                            [newData release];
                            newData = nil;
                        }
                        if (isSuccess) {
                            //TODO: 修正IBook同步消息
                            if (track.mediaType != PDFBooks && track.mediaType != Books && track.mediaType != Photo) {
                                [self sendFileCompletedByAssetID:assetID WithType:assetEntity.assetType WithPath:track.filePath];
                            }else if (track.mediaType == Photo) {
                                NSString *thumbsPath = [NSString stringWithFormat:@"Photos/Thumbs/%@.mthmb",track.uuid];
                                [self sendFileCompletedByAssetID:assetID WithType:assetEntity.assetType WithPath:thumbsPath];
                            }
                            else if(track.mediaType == PDFBooks || track.mediaType == Books){
                                //filePath Books/6244909729990460280.epub
                                if (track.mediaType == PDFBooks) {
                                    NSString *booksTargetPath = [NSString stringWithFormat:@"Books/%@",[assetID stringByAppendingString:@".pdf"]];
                                    
                                    [self sendFileCompletedByAssetID:assetID WithType:assetEntity.assetType WithPath:booksTargetPath];
                                }
                                else{
                                    NSString *booksTargetPath = [NSString stringWithFormat:@"Books/%@",[assetID stringByAppendingString:@".epub"]];
                                    
                                    if([self checkIosIsHighVersion:_curIpod]){
                                        [self sendFileCompletedByAssetID:assetID WithType:assetEntity.assetType WithPath:booksTargetPath];
                                    }
                                    else{
                                        NSString *booksTargetPath = [NSString stringWithFormat:@"Airlock/Book/%@", [assetID stringByAppendingString:@".epub"]];
                                        [self sendFileCompletedByAssetID:assetID WithType:assetEntity.assetType WithPath:booksTargetPath];
                                        int i = 0;
                                        while (![_curIpod.fileSystem fileExistsAtPath:booksTargetPath] && i < 5) {
                                            i ++;
                                            sleep(1);
                                        }
                                    }
                                }
                            }
                            [logHandle writeInfoLog:[NSString stringWithFormat:@"sendFileCompleted assetID: %@", assetID]];
                            if (_listener && [_listener respondsToSelector:@selector(completedCopyTrack:)]) {
                                [_listener completedCopyTrack:(id)track];
                            }
                            continue;
                        }else {
                            [self sendFileErrorWithAssetID:assetID WithType:assetEntity.assetType];
                            [logHandle writeInfoLog:[NSString stringWithFormat:@"trackcount>0  sendFileError assetID: %@", assetID]];
                        }
                        continue;
                    }else {
                        if (track != nil) {
                            [self sendFileErrorWithAssetID:assetID WithType:assetEntity.assetType];
                            [logHandle writeInfoLog:[NSString stringWithFormat:@"track1>0  sendFileError assetID: %@", assetID]];
                        }
                    }
                }else{
                    [self sendFileErrorWithAssetID:assetID WithType:assetEntity.assetType];
                    [logHandle writeInfoLog:[NSString stringWithFormat:@"trackcount==0  sendFileError assetID: %@", assetID]];
                }
            }else{
                [self sendFileErrorWithAssetID:assetID WithType:assetEntity.assetType];
                [logHandle writeInfoLog:[NSString stringWithFormat:@"tracks==0  sendFileError assetID: %@", assetID]];
            }
        }
        value = 1;
    }
    return value;
}

//参数为 assetID与mediaType如 meida，ringtone等
- (int) sendFileErrorWithAssetID:(NSString*) assetID WithType:(NSString*) mediaType {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:assetID,@"assetID",mediaType,@"mediaType",nil];
    _stopWaitairSyncResult = NO;
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:Notify_AirSyncServiceMessage object:@"7" userInfo:dic deliverImmediately:YES];
    while (!_stopWaitairSyncResult&&!_isStop) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return 1;
//    return ATHostConnectionSendFileError(_threadValue, (id)(CFStringRef)assetID, (id)(CFStringRef)mediaType, 3);
}
//传输文件的进度信息等
-(int)sendFileProgressByAssetID:(NSString*) assetID WithType:(NSString*)mediaType Progress:(float)progress{
    
    //1,threadid, 2,AssetID， 3，MediaType, 4,0初始值，5，当前进度，6，0未知。
    if (_threadValue == 0) {
        return 0;
    }
    long curProgress = (long)(0x3FA00000 + (0x3FF00000 - 0x3FA00000) * progress);
    int ret = ATHostConnectionSendFileProgress(_threadValue, (id)(CFStringRef)assetID, (id)(CFStringRef)mediaType, 0, curProgress, 0);
    return ret;
 
//     ++limitTime;
 //    if (limitTime % 3 == 0)
//     {
//     String TypeStr = base._selectedNode == Nodes.Category_Ringtone ? "Ringtone" : "Media";
//     iTunesAPI.ATHostConnectionSendFileProgress(athEntity.ThreadValue, (void*)iTunesAPI.StringToCFString(currFileName), (void*)iTunesAPI.StringToCFString(TypeStr), 0, (long)(0x3FA00000 + ((0x3FF00000 - 0x3FA00000) * ((double)copiedsize / (double)totalsize))), 0);
//     }
 
}

//传输文件的结束等
-(int)sendFileCompletedByAssetID:(NSString*) assetID WithType:(NSString*)mediaType WithPath:(NSString*)filePath {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:assetID,@"assetID",mediaType,@"mediaType",filePath,@"filePath", nil];
    _stopWaitairSyncResult = NO;
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:Notify_AirSyncServiceMessage object:@"4" userInfo:dic deliverImmediately:YES];
    while (!_stopWaitairSyncResult&&!_isStop) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return 1;
}

#pragma mark - helper方法
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

- (CFStringRef) ConverToCFStringIntPrt:(NSString *)keyName
{
    return (CFStringRef)keyName;
}

- (NSString *) ConverStringRefToString:(const void *)strRef
{
    CFStringRef stringRef = (CFStringRef)strRef;
    NSString *string = (NSString *)stringRef;
    return string;
}

- (int)convertSyncName:(NSString *)syncName{
    int value = 0;
    @try {
        value = [syncName integerValue];
    }
    @catch (NSException *exception) {
        value = 0;
    }
    return value;
}

- (void) deleteDeviceFile:(NSString*) filePath
{
    if ([_curIpod.fileSystem fileExistsAtPath:filePath])
    {
        [_curIpod.fileSystem unlink:filePath];
    }
}


- (void) deleteLocalFile:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    @try {
        if ([fileManager fileExistsAtPath:filePath]) {
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
    @catch (NSException *exception) {
        [logHandle writeInfoLog:[NSString stringWithFormat:@"error in deleteLocalFile:%@",filePath]];
    }
}

- (NSString *)getSyncFileTempName:(void *)paramValue KeyName:(NSString*)keyName{
    NSString *tempName =@"";
   const void *lpmedia = CFDictionaryGetValue((void *)paramValue, [self ConverToCFStringIntPrt:keyName]);
    if (lpmedia != nil) {
        @try {
            tempName = [self ConverStringRefToString:lpmedia];
        }
        @catch (NSException *exception) {
            tempName = @"0";
        }
    }
    return tempName;
}

- (void)createSyncCigFilePath:(IMBSyncDataEntiy *)syncDataItem{
    if (![_curIpod.fileSystem fileExistsAtPath:_mediaSyncPath]) {
        [_curIpod.fileSystem mkDir:_mediaSyncPath];
    }
    NSString *fileTempName = @"";
    NSString *syncPlistPath = @"";
    NSString *syncPlistCigPath = @"";
    NSString *cigName = syncDataItem.cigName;
    @try {
        fileTempName = [NSString stringWithFormat:@"%08ld",(long)[cigName integerValue]];
    }
    @catch (NSException *exception) {
        cigName = @"0";
    }
    syncPlistPath = [NSString stringWithFormat:@"Sync_%@.plist",fileTempName];
    syncPlistCigPath = [NSString stringWithFormat:@"Sync_%@.plist.cig",fileTempName];
    
    NSString *targetPlistPath = [_mediaSyncPath stringByAppendingPathComponent:syncPlistPath];
    NSString *targetCigPath = [_mediaSyncPath stringByAppendingPathComponent:syncPlistCigPath];
    
    [self deleteDeviceFile:targetPlistPath];
    [self deleteDeviceFile:targetCigPath];
    
    syncDataItem.targetMediaPath = targetPlistPath;
    syncDataItem.targetCigPath = targetCigPath;
    
    syncDataItem.localTempFolder  = _curIpod.session.sessionFolderPath;
    NSString *localFolder = [syncDataItem.localTempFolder stringByAppendingPathComponent:@"Cig"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:localFolder]) {
        [fileManager createDirectoryAtPath:localFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *sourcePlistPath = [localFolder stringByAppendingPathComponent:syncPlistPath];
    NSString *sourceCigPath = [localFolder stringByAppendingPathComponent:syncPlistCigPath];
    [self deleteLocalFile:sourcePlistPath];
    [self deleteLocalFile:sourceCigPath];
    syncDataItem.sourceMediaPath = sourcePlistPath;
    syncDataItem.sourceCigPath = sourceCigPath;
}

- (void) createSyncFilePath:(IMBSyncDataEntiy *)syncDataItem categoryNode:(CategoryNodesEnum)node{
    NSString *syncfileName = @"";
    int fileValue = 0;
    switch (node) {
        case Category_Ringtone:
            fileValue = [self convertSyncName:syncDataItem.ringtoneName];
            syncfileName = [NSString stringWithFormat:@"Sync_%08d.plist",fileValue];
            syncDataItem.targetRingtonPath = [self createSyncTargetPath:_toneSyncPath syncFileName:syncfileName];
            syncDataItem.sourceRingtonePath = [self createSyncLocalTempPath:syncDataItem.localTempFolder syncItemName:@"Ringtone" syncFileName:syncfileName];
            break;
        case Category_VoiceMemos:
            fileValue = [self convertSyncName:syncDataItem.voiceMemoName];
            syncfileName = [NSString stringWithFormat:@"Sync_%08d.plist",fileValue];
            syncDataItem.targetVoiceMemoPath = [self createSyncTargetPath:_recordingSyncPath syncFileName:syncfileName];
            syncDataItem.sourceVoiceMemoPath = [self createSyncLocalTempPath:syncDataItem.localTempFolder syncItemName:@"Recordings" syncFileName:syncfileName];
            break;
        case Category_iBookCollections:
        case Category_iBooks:
            syncfileName = @"Books.plist";
            syncDataItem.targetBookPath = [self createSyncTargetPath:_bookSyncPath syncFileName:syncfileName];
            syncDataItem.sourceBookPath = [self createSyncLocalTempPath:syncDataItem.localTempFolder syncItemName:@"Book" syncFileName:syncfileName];
            break;
        case Category_Applications:
        {
            NSString *publicStaging = @"/PublicStaging";
            if (![_curIpod.fileSystem fileExistsAtPath:[[_curIpod.fileSystem driveLetter] stringByAppendingPathComponent:publicStaging]]) {
                [_curIpod.fileSystem mkDir:[[_curIpod.fileSystem driveLetter] stringByAppendingPathComponent:publicStaging]];
            }
            syncfileName = @"ApplicationsSync.plist";
            syncDataItem.targetApplicationPath = [self createSyncTargetPath:_appSyncPath syncFileName:syncfileName];
            syncDataItem.sourceApplicationPath = [self createSyncLocalTempPath:syncDataItem.localTempFolder syncItemName:@"Application" syncFileName:syncfileName];
            
            syncfileName = @"SpringboardIconState.plist";
            syncDataItem.targetAppIconStatePath = [self createSyncTargetPath:_appSyncPath syncFileName:syncfileName];
            syncDataItem.sourceAppIconStatePath = [self createSyncLocalTempPath:syncDataItem.localTempFolder syncItemName:@"Application" syncFileName:syncfileName];
        }
            break;
        default:
            break;
    }
}

- (NSString *)createSyncTargetPath:(NSString *)syncFolderName syncFileName:(NSString *)syncFileName{
    if (![_curIpod.fileSystem fileExistsAtPath:syncFolderName]) {
        [_curIpod.fileSystem mkDir:syncFolderName];
    }
    NSString *syncFilePath = [syncFolderName stringByAppendingPathComponent:syncFileName];
    if ([_curIpod.fileSystem fileExistsAtPath:syncFilePath]){
        @try {
            [_curIpod.fileSystem unlink:syncFilePath];
        }
        @catch (NSException *exception) {
            [logHandle writeInfoLog:@"Delete Device Sync Target path is Error"];
        }
    }
    return syncFilePath;
}

- (NSString *)createSyncLocalTempPath:(NSString *)localTempPath syncItemName:(NSString *)syncItemName syncFileName:(NSString *)syncFileName{
    if (localTempPath == nil || localTempPath == 0) {
        
    }
    NSString *localTempFolder = [localTempPath stringByAppendingPathComponent:syncItemName];
    NSFileManager *filemanger = [NSFileManager defaultManager];
    if (![filemanger fileExistsAtPath:localTempFolder]) {
        [filemanger createDirectoryAtPath:localTempFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *localTempFile = [localTempFolder stringByAppendingPathComponent:syncFileName];
    @try {
        if ([filemanger fileExistsAtPath:localTempFile]) {
            [filemanger removeItemAtPath:localTempFile error:nil];
        }
    }
    @catch (NSException *exception) {
        [logHandle writeInfoLog:[NSString stringWithFormat:@"Delete %@ is failed",localTempFile]];
    }
    return localTempFile;
}

- (BOOL) copyLocalTempFileToDevice:(NSString *)sourcePath tarpath:(NSString *)targetPath{
    if (_curIpod == nil) {
        return false;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:sourcePath]) {
        BOOL result = false;
        @try {
            if ([_curIpod.fileSystem fileExistsAtPath:[[_curIpod.fileSystem driveLetter] stringByAppendingPathComponent:targetPath]]) {
                [_curIpod.fileSystem unlink:[[_curIpod.fileSystem driveLetter] stringByAppendingPathComponent:targetPath]];
            }
               result = [_curIpod.fileSystem copyLocalFile:sourcePath toRemoteFile:[[_curIpod.fileSystem driveLetter] stringByAppendingPathComponent:targetPath]];
        }
        @catch (NSException *exception) {
            result = false;
            
        }
        @finally {
            return result;
        }
    }
    else{
        return false;
    }
}

- (BOOL)checkMediaDBExistInTempPath{
    if ([StringHelper stringIsNilOrEmpty:_curIpod.mediaDBPath]) {
        IMBExtractDeviceDBFiles *extractFile = [[[IMBExtractDeviceDBFiles alloc] initWithToIpod:_curIpod extractType:MediaLibrary] autorelease];
        [extractFile startExtract];
        if ([StringHelper stringIsNilOrEmpty:_curIpod.mediaDBPath]) {
            return false;
        }
        else{
            return true;
        }
    }
    else{
        return true;
    }
}

+ (BOOL)copyMediaDBToTmepPathWithIpod:(IMBiPod *)ipod{
    IMBExtractDeviceDBFiles *extractFile = [[[IMBExtractDeviceDBFiles alloc] initWithToIpod:ipod extractType:MediaLibrary] autorelease];
    [extractFile startExtract];
    if ([StringHelper stringIsNilOrEmpty:ipod.mediaDBPath]) {
        return false;
    }
    else{
        return true;
    }
}


- (void)matchOperationType:(CategoryNodesEnum)node SyncCtrType:(SyncCtrTypeEnum)ctrType{

    if (ctrType == SyncDelFile) {
        switch (node) {
            case Category_iBookCollections:
            case Category_iBooks:
                [_opeateTypeDic setObject:[NSNumber numberWithUnsignedInt:Books] forKey:[NSString stringWithFormat:@"%d",Books]];
                break;
            case Category_Ringtone:
                [_opeateTypeDic setObject:[NSNumber numberWithUnsignedInt:Ringtone] forKey:[NSString stringWithFormat:@"%d",Ringtone]];
                break;
            case Category_VoiceMemos:
                [_opeateTypeDic setObject:[NSNumber numberWithUnsignedInt:VoiceMemo] forKey:[NSString stringWithFormat:@"%d",VoiceMemo]];
                break;
            case Category_PhotoLibrary:
            case Category_MyAlbums:
                [_opeateTypeDic setObject:[NSNumber numberWithUnsignedInt:Photo] forKey:[NSString stringWithFormat:@"%d",Photo]];
                break;
            case Category_Applications:
                [_opeateTypeDic setObject:[NSNumber numberWithUnsignedInt:Application] forKey:[NSString stringWithFormat:@"%d",Application]];
                break;
            default:
                [_opeateTypeDic setObject:[NSNumber numberWithUnsignedInt:Audio] forKey:[NSString stringWithFormat:@"%d",Audio]];
                break;
        }
    }
    else if(ctrType == SyncAddFile){
        switch (node) {
            case Category_iBookCollections:
            case Category_iBooks:
                [_opeateTypeDic setObject:[NSNumber numberWithUnsignedInt:Books] forKey:[NSString stringWithFormat:@"%d",Books]];
                break;
            case Category_Ringtone:
                [_opeateTypeDic setObject:[NSNumber numberWithUnsignedInt:Ringtone] forKey:[NSString stringWithFormat:@"%d",Ringtone]];
                break;
            case Category_VoiceMemos:
                [_opeateTypeDic setObject:[NSNumber numberWithUnsignedInt:VoiceMemo] forKey:[NSString stringWithFormat:@"%d",VoiceMemo]];
                break;
            case Category_Applications:
                [_opeateTypeDic setObject:[NSNumber numberWithUnsignedInt:Application] forKey:[NSString stringWithFormat:@"%d",Application]];
                break;
            case Category_PhotoLibrary:
            case Category_MyAlbums:
                [_opeateTypeDic setObject:[NSNumber numberWithUnsignedInt:Photo] forKey:[NSString stringWithFormat:@"%d",Photo]];
                break;
            default:
                [_opeateTypeDic setObject:[NSNumber numberWithUnsignedInt:Audio] forKey:[NSString stringWithFormat:@"%d",Audio]];
                break;
        }
    }
}

- (NSData *)readFileData:(NSString *)filePath withIpod:(IMBiPod *)ipod {
    if (![ipod.fileSystem fileExistsAtPath:filePath]) {
        return nil;
    }else {
        long long fileLength = [ipod.fileSystem getFileLength:filePath];
        AFCFileReference *openFile = [ipod.fileSystem openForRead:filePath];
        const uint32_t bufsz = 10240;
        char *buff = (char*)malloc(bufsz);
        NSMutableData *totalData = [[[NSMutableData alloc] init] autorelease];
        while (1) {
            
            uint32_t n = [openFile readN:bufsz bytes:buff];
            if (n==0) break;
            //将字节数据转化为NSdata
            NSData *b2 = [[NSData alloc]
                          initWithBytesNoCopy:buff length:n freeWhenDone:NO];
            [totalData appendData:b2];
            [b2 release];
        }
        if (totalData.length == fileLength) {
            // NSLog(@"success readData 1111");
        }
        free(buff);
        [openFile closeFile];
        return totalData;
    }
}
#pragma mark - 同步流程方法
- (BOOL)createAirSyncService
{
    [SystemHelper runningApplicationTerminateIdentifier:@"com.imobie.ATHHostSync64"];
    [SystemHelper runningApplicationTerminateIdentifier:@"com.imobie.ATHHostSync32"];
    _syncState = SyncNoneState;
    NSString *iTunesVersion = [IMBSoftWareInfo singleton].iTunesVersion;
    if (iTunesVersion.length == 0) {
        iTunesVersion = @"11.3";
    }
    
    
    NSString *appPath  = nil;
    if ([iTunesVersion isVersionMajorEqual:@"12.6"]) {
        //启动app
        appPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/MacOS/ATHHostSync64.app"];
    }else{
        //启动app
        appPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/MacOS/ATHHostSync32.app"];
    }
    BOOL virusDefenseSuccess = [[NSWorkspace sharedWorkspace] launchApplication:appPath];
    if (virusDefenseSuccess) {
        _stopWaitairSyncResult = NO;
        while (!_stopWaitairSyncResult&&!_isStop) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }else{
        return NO;
    }
    [logHandle writeInfoLog:@"createAirSyncService"];
    NSString *serialNumberForHashing = _curIpod.deviceInfo.serialNumberForHashing;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:iTunesVersion,@"iTunesVersion",serialNumberForHashing,@"serialNumberForHashing", nil];
    _stopWaitairSyncResult = NO;
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:Notify_AirSyncServiceMessage object:@"1" userInfo:dic deliverImmediately:YES];
    while (!_stopWaitairSyncResult&&!_isStop) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    return _airSyncResult;
}

- (void)airSyncServiceStartSuccess:(NSNotification *)notification
{
    NSLog(@"airSyncServiceStartSuccess");
    [self airSyncResult:YES];
}

#pragma mark - AirSyncDelegate
- (void)airSyncResult:(BOOL)isSuccess
{
    _airSyncResult = isSuccess;
    _stopWaitairSyncResult = YES;
    [self performSelector:@selector(wakeUp:) onThread:_currentThread withObject:@(_syncState) waitUntilDone:NO];
}
- (void)deviceBackMessage:(NSString *)msg MessageID:(id)msgid
{
    if (msgid != 0) {
        if ([msg isEqualToString:@"SyncAllowed"]) {
            [logHandle writeInfoLog:@"deviceSyncMessage:SyncAllowed"];
            [self performSelector:@selector(wakeUp:) onThread:_currentThread withObject:@(SyncAllowed) waitUntilDone:NO];
        }else if ([msg isEqualToString:@"ReadyForSync"]){
            [logHandle writeInfoLog:@"deviceSyncMessage:ReadyForSync"];
            if (_grappaDic != nil) {
                [_grappaDic release];
            }
            _grappaDic = [(NSDictionary *)msgid retain];
            [self performSelector:@selector(wakeUp:) onThread:_currentThread withObject:@(ReadyForSync) waitUntilDone:NO];
        }else if ([msg isEqualToString:@"AssetManifest"]){
            CFDictionaryRef dic = (CFDictionaryRef)msgid;
            NSDictionary *msgDic = (NSDictionary*)dic;
            NSDictionary *manifestDic = [[msgDic objectForKey:@"Params"] objectForKey:@"AssetManifest"];
            [logHandle writeInfoLog:[NSString stringWithFormat:@"deviceSyncMessage:AssetManifest\n%@",[manifestDic description]]];
            [_allAssetDic addEntriesFromDictionary:manifestDic];
            if ([manifestDic.allKeys containsObject:@"Book"])
            {
                if ([_opeateTypeDic.allKeys containsObject:[NSString stringWithFormat:@"%d",Books]]) {
                    [_opeateTypeDic removeObjectForKey:[NSString stringWithFormat:@"%d",Books]];
                }
            }
            else if([manifestDic.allKeys containsObject:@"Media"]) {
                if ([_opeateTypeDic.allKeys containsObject:[NSString stringWithFormat:@"%d",Audio]]) {
                    [_opeateTypeDic removeObjectForKey:[NSString stringWithFormat:@"%d",Audio]];
                }
            }
            else if([manifestDic.allKeys containsObject:@"Ringtone"]) {
                if ([_opeateTypeDic.allKeys containsObject:[NSString stringWithFormat:@"%d",Ringtone]]) {
                    [_opeateTypeDic removeObjectForKey:[NSString stringWithFormat:@"%d",Ringtone]];
                }
            }
            else if([manifestDic.allKeys containsObject:@"VoiceMemo"] ) {
                if ([_opeateTypeDic.allKeys containsObject:[NSString stringWithFormat:@"%d",VoiceMemo]]) {
                    [_opeateTypeDic removeObjectForKey:[NSString stringWithFormat:@"%d",VoiceMemo]];
                }
            }
            
            else if ([manifestDic.allKeys containsObject:@"Photo"]) {
                if ([_opeateTypeDic.allKeys containsObject:[NSString stringWithFormat:@"%d",Photo]]) {
                    [_opeateTypeDic removeObjectForKey:[NSString stringWithFormat:@"%d",Photo]];
                }
            }
            else if([manifestDic.allKeys containsObject:@"Application"]){
                if ([_opeateTypeDic.allKeys containsObject:[NSString stringWithFormat:@"%d",Application]]) {
                    [_opeateTypeDic removeObjectForKey:[NSString stringWithFormat:@"%d",Application]];
                }
            }
            if ([_opeateTypeDic count] == 0 || CtrType == SyncDelFile) {
                [self performSelector:@selector(wakeUp:) onThread:_currentThread withObject:@(AssetManifest) waitUntilDone:NO];
            }
        }else if ([msg isEqualToString:@"SyncFinished"]){
            [logHandle writeInfoLog:@"deviceSyncMessage:SyncFinished"];
            //需要发送结束同步消息
            [self sendAirSyncStop];
            _isStop = YES;
            [self performSelector:@selector(wakeUp:) onThread:_currentThread withObject:@(AssetManifest) waitUntilDone:NO];
        }else if ([msg isEqualToString:@"SyncFailed"]){
            [logHandle writeInfoLog:@"deviceSyncMessage:SyncFailed"];
            //需要发送结束同步消息
            [self sendAirSyncStop];
            _isStop = YES;
            [self performSelector:@selector(wakeUp:) onThread:_currentThread withObject:@(AssetManifest) waitUntilDone:NO];
        }else if ([msg isEqualToString:@"ConnectionInvalid"]){
            [logHandle writeInfoLog:@"deviceSyncMessage:ConnectionInvalid"];
            //需要发送结束同步消息
            [self sendAirSyncStop];
            _isStop = YES;
            [self performSelector:@selector(wakeUp:) onThread:_currentThread withObject:@(AssetManifest) waitUntilDone:NO];
        }
    }
}

//发送停止同步消息
- (void)sendAirSyncStop
{
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:Notify_AirSyncServiceMessage object:@"5" userInfo:nil deliverImmediately:YES];
}


- (void)wakeUp:(NSNumber *)number
{
    _syncState = number.intValue;
}

- (BOOL)sendRequestSync
{
    //等待设备SyncAllowed消息
    while (_syncState != SyncAllowed&&!_isStop) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    if (_isStop) {
        return NO;
    }
    [logHandle writeInfoLog:@"sendRequestSync"];
    NSString *iTunesVersion = [IMBSoftWareInfo singleton].iTunesVersion;
    if (iTunesVersion.length == 0) {
        iTunesVersion = @"11.3";
    }
    //RootDic > HostInfo
    NSMutableDictionary *dicRoot = [[NSMutableDictionary alloc] init];
    [dicRoot setValue:iTunesVersion forKey:@"LibraryID"];
    NSString *hostName =  [[NSHost currentHost] localizedName];
    [dicRoot setValue:hostName forKey:@"SyncHostName"];
    //Data Array
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    [dataArray addObject:@"Data"];
    [dicRoot setValue:dataArray forKey:@"SyncedDataclasses"];
    [dicRoot setValue:iTunesVersion forKey:@"Version"];
    
    //获得grappaData，这个可以写死在程序里面
    NSString *hostGrappaPath = [[NSBundle mainBundle] pathForResource:@"host_grappa"
                                                               ofType:@""];
    NSData *grappaData = [[NSData alloc] initWithContentsOfFile:hostGrappaPath];
    //int length = [textData length];
    char* grappaDataPtr = nil;
    grappaDataPtr = (char *)[grappaData bytes];
    [dicRoot setValue:grappaData forKey:@"Grappa"];
    //Todo 生成 media dic,这个地方如果有Ringtone应该另作安排 >> DataclassAnchors
    NSMutableDictionary *mediaDic = [[NSMutableDictionary alloc] init];
    if (_isSyncIBook || _isSyncVoiceMemo || _isSyncRingTone || _isSyncMedia) {
        [mediaDic setValue:@"1" forKey:Media_];
    }
    if (_isSyncVoiceMemo) {
        [mediaDic setValue:@"2" forKey:VoiceMemo_];
    }
    if (_isSyncRingTone) {
        [mediaDic setValue:@"2" forKey:Ringtone_];
    }
    if (_isSyncIBook) {
        [mediaDic setValue:@"0" forKey:Book_];
    }
    if (_isSyncPhoto) {
        [mediaDic setValue:@"2" forKey:Photo_];
    }
    //生成mediaArray >> Dataclasses
    NSMutableArray *mediaArray = [[NSMutableArray alloc] init];
    [mediaArray addObject:@"Keybag"];
    [mediaArray addObject:Media_];
    if (_isSyncVoiceMemo) {
        [mediaArray addObject:VoiceMemo_];
    }
    if (_isSyncRingTone) {
        [mediaArray addObject:Ringtone_];
    }
    if (_isSyncIBook) {
        [mediaArray addObject:Book_];
    }
    if (_isSyncPhoto) {
        [mediaArray addObject:Photo_];
    }
    NSArray *inmutableMediaArrary = [NSArray arrayWithArray:mediaArray];
    //同步的Dictionary
    NSMutableDictionary *syncDict = [[NSMutableDictionary alloc] init];
    [syncDict setValue:inmutableMediaArrary forKey:@"Dataclasses"];
    [syncDict setValue:mediaDic forKey:@"DataclassAnchors"];
    [syncDict setValue:dicRoot forKey:@"HostInfo"];
    NSDictionary *inmutableSyncDict = [NSDictionary dictionaryWithDictionary:syncDict];
    if (_isStop) {
        [logHandle writeErrorLog:@"stop in startSync part3"];
        return NO;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:inmutableSyncDict forKey:@"inmutableSyncDict"];
    _stopWaitairSyncResult = NO;
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:Notify_AirSyncServiceMessage object:@"2" userInfo:dic deliverImmediately:YES];
    while (!_stopWaitairSyncResult&&!_isStop) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [syncDict release];
    [dataArray release];
    [mediaArray release];
    [mediaDic release];
    [dicRoot release];
    return _airSyncResult;
   
}

- (BOOL)createPlistAndCigSendDataSync
{
    while (_syncState != ReadyForSync&&!_isStop) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    if (_isStop) {
        return NO;
    }
    [logHandle writeInfoLog:@"createPlistAndCigSendDataSync"];
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:Notify_AirSyncServiceMessage object:@"6" userInfo:[NSDictionary dictionaryWithObject:@(YES) forKey:@"pingValue"] deliverImmediately:YES];
    NSDictionary *paras = [_grappaDic objectForKey:@"Params"];
    NSDictionary *deviceInfo = [paras objectForKey:@"DeviceInfo"];
    NSData *grappaData = [deviceInfo objectForKey:@"Grappa"];
    
    NSString *mediaAnchors = [[paras objectForKey:@"DataclassAnchors"] objectForKey:Media_];
    NSString *ringtoneAnchors = [[paras objectForKey:@"DataclassAnchors"] objectForKey:Ringtone_];
    NSString *iBookAnchors = [[paras objectForKey:@"DataclassAnchors"] objectForKey:Book_];
    NSString *voiceMemoAnchors = [[paras objectForKey:@"DataclassAnchors"] objectForKey:VoiceMemo_];
    NSString *photoAnchors = [[paras objectForKey:@"DataclassAnchors"] objectForKey:Photo_];
    BOOL result = true;
    if (CtrType == SyncRefresh) {
        return NO;
    }
    NSMutableDictionary *keybagDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *mediaSessionDict = [[NSMutableDictionary alloc] init];
    if (_isSyncMedia || _isSyncVoiceMemo || _isSyncRingTone || _isSyncIBook || CtrType == SyncOther) {
        _syncDataItem = [[[IMBSyncDataEntiy alloc] init] autorelease];
        _syncDataItem.cigName = mediaAnchors == nil ? @"0" : mediaAnchors;
        _syncDataItem.ringtoneName = ringtoneAnchors == nil ? @"0" : ringtoneAnchors;
        _syncDataItem.voiceMemoName = voiceMemoAnchors == nil ? @"0" : voiceMemoAnchors;
        _syncDataItem.bookName = iBookAnchors == nil ? @"0":iBookAnchors;
        if (_isStop) {
            result = false;
        }
        if (result) {
            [self createSyncCigFilePath:_syncDataItem];
            if ([_opeateTypeDic.allKeys containsObject:[NSString stringWithFormat:@"%d",Ringtone]]) {
                [self createSyncFilePath:_syncDataItem categoryNode:Category_Ringtone];
            }
            if ([_opeateTypeDic.allKeys containsObject:[NSString stringWithFormat:@"%d",VoiceMemo]]) {
                [self createSyncFilePath:_syncDataItem categoryNode:Category_VoiceMemos];
            }
            if ([_opeateTypeDic.allKeys containsObject:[NSString stringWithFormat:@"%d",Books]]) {
                [self createSyncFilePath:_syncDataItem categoryNode:Category_iBooks];
            }
            if (_isStop) {
                result = false;
            }
            if (result) {
                IMBSyncPlistBuilder *syncBuilder = nil;
                BOOL isAdd = false;
                if (CtrType == SyncAddFile || CtrType == PlaylistsType) {
                    if (CtrType == PlaylistsType) {
                        [_opeateTypeDic setObject:[NSNumber numberWithInt:Audio] forKey:[NSString stringWithFormat:@"%d",PlaylistsType]];
                    }
                    isAdd = true;
                }
                // App没有通过同步来进行添加删除
                NSMutableDictionary *resultDic = nil;
                if (CtrType == SyncOther) {
                    //生成plist
                    NSString *plistTempPath = [_curIpod.session.sessionFolderPath stringByAppendingPathComponent:@"sync.plist"];
                    NSFileManager *fm = [NSFileManager defaultManager];
                    if ([fm fileExistsAtPath:plistTempPath]) {
                        [fm removeItemAtPath:plistTempPath error:nil];
                    }
                    IMBSyncPlistBuilder *builder = [[IMBSyncPlistBuilder alloc] initWithIpod:_curIpod];
                    [builder createBinPlistWithPath:plistTempPath WithRevision:0];
                    [builder release];
                    //2.生成cig文件
                    @try {
                        [logHandle writeInfoLog:@"+++Create Cig start"];
                        [self createCigToDeviceWithGrappa:grappaData WithPlistPath:plistTempPath WithDataAnchors:mediaAnchors WithType:Media_];
                        [logHandle writeInfoLog:@"+++Create Cig End"];
                    }
                    @catch (NSException *exception) {
                        if ([exception.name isEqualToString:CIG_CREATE_EXCEPTION]) {
                            [logHandle writeErrorLog:@"create cig failed"];
                            return 0;
                        }
                    }
                    result = YES;
                }else {
                    syncBuilder = [[IMBSyncPlistBuilder alloc] initWithIpod:_curIpod opreationDic:_opeateTypeDic syncData:_syncDataItem addTrackList:_syncTasks addAppList:nil isAdd:isAdd];
                    if (syncBuilder != nil && [syncBuilder InitSyncDataBaseInfo]) {
                        resultDic  = [[[NSMutableDictionary alloc] initWithDictionary:[syncBuilder startCreateSyncDataPlist]] autorelease];
                    }
                    if (resultDic != nil && [resultDic.allKeys containsObject:@"CigType"]) {
                        result = [[resultDic objectForKey:@"CigType"] boolValue];
                        result = [self createCigToDeviceWithGrappa:grappaData WithPlistPath:_syncDataItem.sourceMediaPath];
                    }
                    else{
                        result = false;
                    }
                    if (result == true) {
                        result = [self copyLocalTempFileToDevice:_syncDataItem.sourceMediaPath tarpath:_syncDataItem.targetMediaPath];
                        if ([IMBSoftWareInfo singleton].isCopySyncPlistFile) {
                            [self copyPlistLogFloder];
                        }
                        
                        if (result) {
                            result = [self copyLocalTempFileToDevice:_syncDataItem.sourceCigPath tarpath:_syncDataItem.targetCigPath];
                        }
                        if (result) {
                            if ([resultDic.allKeys containsObject:@"Ringtone"]) {
                                result = [self copyLocalTempFileToDevice:_syncDataItem.sourceRingtonePath tarpath:_syncDataItem.targetRingtonPath];
                            }
                            if ([resultDic.allKeys containsObject:@"VoiceMemo"]) {
                                result = [self copyLocalTempFileToDevice:_syncDataItem.sourceVoiceMemoPath tarpath:_syncDataItem.targetVoiceMemoPath];
                            }
                            if ([resultDic.allKeys containsObject:@"Books"]) {
                                result = [self copyLocalTempFileToDevice:_syncDataItem.sourceBookPath tarpath:_syncDataItem.targetBookPath];
                            }
                        }
                    }
                }
                if (result) {
                    int val1 = 1;
                    [keybagDict setObject:(id)CFNumberCreate(kCFAllocatorDefault, 3, &val1) forKey:@"Keybag"];
                    [keybagDict setObject:(id)CFNumberCreate(kCFAllocatorDefault, 3, &val1) forKey:Media_];
                    [mediaSessionDict setObject:mediaAnchors == nil?@"0":mediaAnchors forKey:Media_];
                    
                    if ([_opeateTypeDic.allKeys containsObject:[NSString stringWithFormat:@"%d",Ringtone]]) {
                        
                        [keybagDict setObject:(id)CFNumberCreate(kCFAllocatorDefault, 3, &val1) forKey:Ringtone_];
                        
                        [mediaSessionDict setObject:ringtoneAnchors == nil?@"0":ringtoneAnchors forKey:Ringtone_];
                        
                    }
                    if ([_opeateTypeDic.allKeys containsObject:[NSString stringWithFormat:@"%d",VoiceMemo]]) {
                        [keybagDict setObject:(id)CFNumberCreate(kCFAllocatorDefault, 3, &val1) forKey:VoiceMemo_];
                        
                        [mediaSessionDict setObject:voiceMemoAnchors == nil?@"0":voiceMemoAnchors forKey:VoiceMemo_];
                        
                    }
                    if ([_opeateTypeDic.allKeys containsObject:[NSString stringWithFormat:@"%d",Books]]) {
                        [keybagDict setObject:(id)CFNumberCreate(kCFAllocatorDefault, 3, &val1) forKey:Book_];
                        [mediaSessionDict setObject:iBookAnchors == nil?@"0":iBookAnchors forKey:Book_];
                    }
                }else{
                    result = false;
                    [logHandle writeErrorLog:@"Copy Sync Plist Error! Sync Cancel."];
                }
            }
        }
    }
    if (_isSyncPhoto) {
        if ([_opeateTypeDic.allKeys containsObject:[NSString stringWithFormat:@"%d",Photo]] || CtrType == SyncRename) {
            NSPredicate *appPre = [NSPredicate predicateWithFormat:@"mediaType == %d",Photo];
            NSArray *photoArray = [_syncTasks filteredArrayUsingPredicate:appPre];
            NSString *photoPlistPath = nil;
            if (CtrType == SyncAddFile) {
                if (_importPhotoAlbum != nil) {
                    photoPlistPath = [self createImportPlistFile:(NSMutableArray *)photoArray Album:_importPhotoAlbum];
                }else {//_photoAlbums
                    photoPlistPath = [self createImportPlistFileMoreAlbum:(NSMutableArray *)photoArray Album:_photoAlbums];
                }
            }else if (CtrType == SyncDelFile){
                photoPlistPath = [self createPhotoDeletePlist:photoArray];
            }else if (CtrType == SyncRename) {
                photoPlistPath = [self createPhotoRenamePlist];
            }
            //创建photo的plist
            if (photoPlistPath != nil) {
                NSString *syncPhotoPath = @"/Photos/Sync/";
                if (![_curIpod.fileSystem fileExistsAtPath:syncPhotoPath]) {
                    [_curIpod.fileSystem mkDir:syncPhotoPath];
                }
                NSString *syncPlistFilePath = [syncPhotoPath stringByAppendingPathComponent:@"PhotoLibrary.plist"];
                result = [self copyLocalTempFileToDevice:photoPlistPath tarpath:syncPlistFilePath];
                if (result) {
                    int val1 = 1;
                    [keybagDict setValue:(id)CFNumberCreate(kCFAllocatorDefault, 3, &val1) forKey:@"Keybag"];
                    [keybagDict setValue:(id)CFNumberCreate(kCFAllocatorDefault, 3, &val1) forKey:Photo_];
                    [mediaSessionDict setObject:photoAnchors == nil?@"0":photoAnchors forKey:Photo_];
                }else{
                    result = false;
                    [logHandle writeErrorLog:@"Copy Sync Plist Error! Sync Cancel."];
                }
            }
        }
    }
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:Notify_AirSyncServiceMessage object:@"6" userInfo:[NSDictionary dictionaryWithObject:@(NO) forKey:@"pingValue"] deliverImmediately:YES];
    if (keybagDict != nil && mediaSessionDict != nil && result) {
        NSDictionary *inmutableKeyBagDic = [NSDictionary dictionaryWithDictionary:keybagDict];
        NSDictionary *inmutableMediaSessionDic = [NSDictionary dictionaryWithDictionary:mediaSessionDict];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:inmutableKeyBagDic,@"inmutableKeyBagDic",inmutableMediaSessionDic,@"inmutableMediaSessionDic", nil];
        _stopWaitairSyncResult = NO;
        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:Notify_AirSyncServiceMessage object:@"3" userInfo:dic deliverImmediately:YES];
        while (!_stopWaitairSyncResult&&!_isStop) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        return _airSyncResult;
    }else{
        return NO;
    }
    
}

- (void)startCopyData
{
    while (_syncState != AssetManifest&&!_isStop) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [logHandle writeInfoLog:@"startCopyData"];
    if (CtrType == SyncAddFile) {
        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:Notify_AirSyncServiceMessage object:@"6" userInfo:[NSDictionary dictionaryWithObject:@(YES) forKey:@"pingValue"] deliverImmediately:YES];
        [self addTracks:_syncTasks ByAssetManifest:_allAssetDic];
        [[NSDistributedNotificationCenter defaultCenter] postNotificationName:Notify_AirSyncServiceMessage object:@"6" userInfo:[NSDictionary dictionaryWithObject:@(NO) forKey:@"pingValue"] deliverImmediately:YES];
    }else if (CtrType == SyncDelFile || CtrType == SyncOther) {
        [_curIpod saveChanges];
        [self addTracks:nil ByAssetManifest:_allAssetDic];
    }
}

- (void)waitSyncFinished
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //如果6秒钟 收不到finished消息就强制结束
        if (!_isStop) {
            [self sendAirSyncStop];
            _isStop = YES;
            [self performSelector:@selector(wakeUp:) onThread:_currentThread withObject:@(SyncFinished) waitUntilDone:NO];
        }
    });
    while (!_isStop) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [self sendAirSyncStop];
    usleep(200);
    _isStop = YES;
    [self performSelector:@selector(wakeUp:) onThread:runloopThread withObject:@(_syncState) waitUntilDone:NO];
    usleep(200);

    [_serverConnection setRootObject:nil];
    [_serverConnection.sendPort invalidate];
    [_serverConnection.receivePort invalidate];
    [_serverConnection invalidate];
    [_serverConnection release],_serverConnection = nil;
    [runloopThread release],runloopThread = nil;
    [logHandle writeInfoLog:@"waitSyncFinished"];
    [SystemHelper runningApplicationTerminateIdentifier:@"com.imobie.ATHHostSync64"];
    [SystemHelper runningApplicationTerminateIdentifier:@"com.imobie.ATHHostSync32"];
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:Notify_AirSyncServiceStartSuccess object:nil];
}

- (void)stopAirSync
{
    //停止同步
    [self sendAirSyncStop];
    _isStop = YES;
    [self performSelector:@selector(wakeUp:) onThread:_currentThread withObject:@(SyncFinished) waitUntilDone:NO];
}


#pragma mark - 创建photo的plist
- (NSString *)createImportPlistFile:(NSMutableArray *)uuidArray Album:(IMBPhotoEntity *)photoAlbum{
    BOOL isDic1 = NO;
    BOOL isDic2 = NO;
    BOOL isExistAlbum = NO;
    //生成设备已有图片的plist文件
    IMBCreatePhotoSyncPlist *createAlbumPlist = [[IMBCreatePhotoSyncPlist alloc] initWithiPod:_curIpod];
    NSMutableDictionary *plistDictionary = [createAlbumPlist getPlistDictionary];
    NSMutableArray *updatesArray = [plistDictionary objectForKey:@"updates"];
    //plist对应相册
    NSMutableDictionary *albumDic = nil;
    if (updatesArray != nil && photoAlbum != nil) {
        NSString *uuidString = nil;
        uuidString = @"";
        if ([_curIpod.deviceInfo.productVersion isVersionMajorEqual:@"8"]) {
            uuidString = photoAlbum.albumUUIDString;
        }else {
            uuidString = [MediaHelper createPhotoUUID:photoAlbum.albumUUIDString];
        }
        for (NSMutableDictionary *item in updatesArray) {
            if ([[item objectForKey:@"albumName"] isEqualToString:photoAlbum.albumTitle] && [[item objectForKey:@"uuid"] isEqualToString:uuidString]) {
                albumDic = item;
                isExistAlbum = YES;
            }
        }
    }
    if (albumDic == nil && photoAlbum != nil) {
        albumDic = [createAlbumPlist createNullAlbumInfo:photoAlbum.albumTitle MaxAlbumUUID:nil];
        isExistAlbum = NO;
    }
    //plist中的library
    NSMutableDictionary *photoLibraryDic = nil;
    if (updatesArray != nil) {
        for (NSMutableDictionary *item in updatesArray) {
            if ([[item objectForKey:@"albumName"] isEqualToString:@"My Pictures"] && [[item objectForKey:@"uuid"] isEqualToString:@"00000000-0000-0000-0000-000000000064"]) {
                photoLibraryDic = item;
            }
        }
    }
    //加入导入图片到plist中
    NSMutableArray *uuid = [[NSMutableArray alloc]init];
    if (uuidArray != nil && uuidArray.count > 0) {
        for (int idx=0; idx<uuidArray.count; idx++) {
            IMBTrack *importInfo = [uuidArray objectAtIndex:idx];
            //判断plist表中是否已经包含这个时间了
            long long dateTime = importInfo.dateAdded;
            if (createAlbumPlist.dateArray.count > 0) {
                if ([createAlbumPlist.dateArray containsObject:[NSString stringWithFormat:@"%lld",dateTime]]) {
                    NSDate *now = [NSDate date];
                    uint64 timeStamp = [DateHelper getTimeStampFromDate:now];
                    dateTime = timeStamp  + 1;
                }
            }
            NSMutableDictionary *newPhotoDic = [[NSMutableDictionary alloc]init];
            [newPhotoDic setObject:@"" forKey:@"caption"];
            [newPhotoDic setObject:[NSNumber numberWithBool:NO] forKey:@"isVideo"];
            [newPhotoDic setObject:@"Asset" forKey:@"itemType"];
            [newPhotoDic setObject:[NSNumber numberWithDouble:1.0/0.0] forKey:@"latitude"];
            [newPhotoDic setObject:[NSNumber numberWithDouble:1.0/0.0] forKey:@"longitude"];
            [newPhotoDic setObject:[NSNumber numberWithLongLong:dateTime] forKey:@"modificationDate"];
            [newPhotoDic setObject:importInfo.uuid forKey:@"uuid"];
            [newPhotoDic setObject:[NSNumber numberWithLongLong:dateTime] forKey:@"exposureDate"];
            
            [uuid addObject:importInfo.uuid];
            //插入uuid到pootolibrary相册里
            if (photoLibraryDic != nil && isDic1 == NO) {
                NSArray *allKey = [photoLibraryDic allKeys];
                if ([allKey containsObject:@"assetUUIDs"]) {
                    NSMutableArray *assetID = [photoLibraryDic objectForKey:@"assetUUIDs"];
                    if (assetID != nil) {
                        [assetID addObject:importInfo.uuid];
                    }
                }else{
                    [photoLibraryDic setObject:uuid forKey:@"assetUUIDs"];
                    isDic1 = YES;
                }
            }
            //插入uuid到albumDic中
            if (albumDic != nil && isDic2 == NO) {
                NSArray *allKey = [albumDic allKeys];
                if ([allKey containsObject:@"assetUUIDs"]) {
                    NSMutableArray *assetID = [albumDic objectForKey:@"assetUUIDs"];
                    if (assetID != nil) {
                        [assetID addObject:importInfo.uuid];
                    }
                }else{
                    [albumDic setObject:uuid forKey:@"assetUUIDs"];
                    isDic2 = YES;
                }
            }
            //在plist文件中插入newphotodic，若没有这个key不会插入
            //          [plistDictionary insertValue:newPhotoDic inPropertyWithKey:@"updates"];
            [updatesArray addObject:newPhotoDic];
            [newPhotoDic release];
        }
    }
    if (isExistAlbum == NO && albumDic != nil) {
        [updatesArray addObject:albumDic];
    }
    NSString *plistAlbumPath = [createAlbumPlist savePlistToPath:plistDictionary];
    [createAlbumPlist release];
    [uuid release];
    return plistAlbumPath;
}

- (NSString *)createImportPlistFileMoreAlbum:(NSMutableArray *)uuidArray Album:(NSArray *)photoAlbums {
    BOOL isDic1 = NO;
    //生成设备已有图片的plist文件
    IMBCreatePhotoSyncPlist *createAlbumPlist = [[IMBCreatePhotoSyncPlist alloc] initWithiPod:_curIpod];
    NSMutableDictionary *plistDictionary = [createAlbumPlist getPlistDictionary];
    NSMutableArray *updatesArray = [plistDictionary objectForKey:@"updates"];
    //plist对应相册
    NSMutableDictionary *allAlbumDic = [[NSMutableDictionary alloc] init];
    NSString *maxUUID = nil;
    if (photoAlbums != nil && photoAlbums.count > 0) {
        for (IMBPhotoEntity *album in photoAlbums) {
            NSMutableDictionary *albumDic = nil;
            if (updatesArray != nil && photoAlbums != nil) {
                NSString *uuidString = @"";
                if ([_curIpod.deviceInfo.productVersion isVersionMajorEqual:@"8"]) {
                    uuidString = album.albumUUIDString;
                }else {
                    uuidString = [MediaHelper createPhotoUUID:album.albumUUIDString];
                }
                for (NSMutableDictionary *item in updatesArray) {
                    if ([[item objectForKey:@"albumName"] isEqualToString:album.albumTitle] && [[item objectForKey:@"uuid"] isEqualToString:uuidString]) {
                        albumDic = item;
                    }
                }
            }
            if (albumDic == nil && album != nil) {
                if (maxUUID == nil) {
                    maxUUID = _maxUUIDStr;
                    if (_maxUUIDStr == nil) {
                        maxUUID = [createAlbumPlist getMaxAlbumUUID];
                    }
                }
                maxUUID = [maxUUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
                NSData *data = [MediaHelper My16NSStringToNSData:maxUUID];
                maxUUID = [createAlbumPlist getMaxUUIDAdd1:data];
                albumDic = [createAlbumPlist createNullAlbumInfo:album.albumTitle MaxAlbumUUID:maxUUID];
            }
            if (albumDic != nil) {
                [allAlbumDic setObject:albumDic forKey:album.albumTitle];
            }
        }
    }
    
    //plist中的library
    NSMutableDictionary *photoLibraryDic = nil;
    if (updatesArray != nil) {
        for (NSMutableDictionary *item in updatesArray) {
            if ([[item objectForKey:@"albumName"] isEqualToString:@"My Pictures"] && [[item objectForKey:@"uuid"] isEqualToString:@"00000000-0000-0000-0000-000000000064"]) {
                photoLibraryDic = item;
            }
        }
    }
    //加入导入图片到plist中
    NSMutableArray *uuid = [[NSMutableArray alloc]init];
    if (uuidArray != nil && uuidArray.count > 0) {
        for (int idx=0; idx<uuidArray.count; idx++) {
            IMBTrack *importInfo = [uuidArray objectAtIndex:idx];
            //判断plist表中是否已经包含这个时间了
            long long dateTime = importInfo.dateAdded;
            if (createAlbumPlist.dateArray.count > 0) {
                if ([createAlbumPlist.dateArray containsObject:[NSString stringWithFormat:@"%lld",dateTime]]) {
                    NSDate *now = [NSDate date];
                    uint64 timeStamp = [DateHelper getTimeStampFromDate:now];
                    dateTime = timeStamp  + 1;
                }
            }
            
            NSMutableDictionary *newPhotoDic = [[NSMutableDictionary alloc]init];
            [newPhotoDic setObject:@"" forKey:@"caption"];
            [newPhotoDic setObject:[NSNumber numberWithBool:NO] forKey:@"isVideo"];
            [newPhotoDic setObject:@"Asset" forKey:@"itemType"];
            [newPhotoDic setObject:[NSNumber numberWithDouble:1.0/0.0] forKey:@"latitude"];
            [newPhotoDic setObject:[NSNumber numberWithDouble:1.0/0.0] forKey:@"longitude"];
            [newPhotoDic setObject:[NSNumber numberWithLongLong:dateTime] forKey:@"modificationDate"];
            [newPhotoDic setObject:importInfo.uuid forKey:@"uuid"];
            [newPhotoDic setObject:[NSNumber numberWithLongLong:dateTime] forKey:@"exposureDate"];
            
            
            [uuid addObject:importInfo.uuid];
            //插入uuid到pootolibrary相册里
            if (photoLibraryDic != nil && isDic1 == NO) {
                NSArray *allKey = [photoLibraryDic allKeys];
                if ([allKey containsObject:@"assetUUIDs"]) {
                    NSMutableArray *assetID = [photoLibraryDic objectForKey:@"assetUUIDs"];
                    if (assetID != nil) {
                        [assetID addObject:importInfo.uuid];
                    }
                }else{
                    [photoLibraryDic setObject:uuid forKey:@"assetUUIDs"];
                    isDic1 = YES;
                }
            }
            //插入uuid到albumDic中
            if (importInfo.photoAlbumName != nil && [allAlbumDic.allKeys containsObject:importInfo.photoAlbumName]) {
                NSMutableDictionary *albumDic = [allAlbumDic objectForKey:importInfo.photoAlbumName];
                if (albumDic != nil) {
                    NSArray *allKey = [albumDic allKeys];
                    if (![allKey containsObject:@"assetUUIDs"]) {
                        [albumDic setObject:[NSMutableArray array] forKey:@"assetUUIDs"];
                        if (![updatesArray containsObject:albumDic]) {
                            [updatesArray addObject:albumDic];
                        }
                    }
                    NSMutableArray *assetID = [albumDic objectForKey:@"assetUUIDs"];
                    if (assetID != nil) {
                        [assetID addObject:importInfo.uuid];
                    }
                }
            }
            
            [updatesArray addObject:newPhotoDic];
            [newPhotoDic release];
        }
    }
    NSString *plistAlbumPath = [createAlbumPlist savePlistToPath:plistDictionary];
    [createAlbumPlist release];
    [uuid release];
    [allAlbumDic release];
    return plistAlbumPath;
}

- (NSString *)createPhotoDeletePlist:(NSArray *)delArray{
    NSString *plistPath = nil;
    if (_syncDelteCategory == SyncDeltePhotoLibrary) {
        IMBCreatePhotoSyncPlist *createPlist = [[IMBCreatePhotoSyncPlist alloc] initWithiPod:_curIpod deleteArray:delArray isDeletePhoto:YES isDeleteAlbum:NO];
        plistPath = [createPlist createPhotoSyncPlistFile];
        [createPlist release];
    }else if (_syncDelteCategory == SyncDeltePhotoAlbums) {
        IMBCreatePhotoSyncPlist *createPlist = [[IMBCreatePhotoSyncPlist alloc] initWithiPod:_curIpod deleteArray:delArray isDeletePhoto:NO isDeleteAlbum:YES];
        plistPath = [createPlist createPhotoSyncPlistFile];
        [createPlist release];
    }
    return plistPath;
}

- (NSString *)createPhotoRenamePlist {
    [logHandle writeInfoLog:@"AirSyncRenameAlbum RenameAlbum enter"];
    IMBCreatePhotoSyncPlist *createAlbumPlist = [[IMBCreatePhotoSyncPlist alloc] initWithiPod:_curIpod];
    NSMutableDictionary *plistDictionary = [createAlbumPlist getPlistDictionary];
    NSMutableArray *updatesArray = [plistDictionary objectForKey:@"updates"];
    //找到plist中对应相册
    NSMutableDictionary *albumDic = nil;
    NSString *uuidString = nil;
    if (updatesArray != nil && _importPhotoAlbum != nil) {
        if ([_curIpod.deviceInfo.productVersion isVersionMajorEqual:@"8"]) {
            uuidString = _importPhotoAlbum.albumUUIDString;
        }else {
            uuidString = [MediaHelper createPhotoUUID:_importPhotoAlbum.albumUUIDString];
        }
        for (NSMutableDictionary *item in updatesArray) {
            if ([[item objectForKey:@"uuid"] isEqualToString:uuidString] && [[item objectForKey:@"albumName"] isEqualToString:_importPhotoAlbum.albumTitle]) {
                albumDic = item;
            }
        }
        [albumDic setObject:_rename forKey:@"albumName"];
    }
    NSString *plistAlbumPath = [createAlbumPlist savePlistToPath:plistDictionary];
    [createAlbumPlist release];
    return plistAlbumPath;
}

#pragma mark - 设置同步的数据源
- (void)setSyncTasks:(NSArray *)syncTasks
{
    NSMutableArray *trackArray = [NSMutableArray array];
    for (id item in syncTasks) {
        if ([item isKindOfClass:[IMBTrack class]]) {
            [trackArray addObject:item];
        }
    }
    if (_syncTasks != syncTasks) {
        [_syncTasks release];
        _syncTasks = [trackArray retain];
        [_opeateTypeDic release];
        _opeateTypeDic = [[self getMediaTypeDic:trackArray] retain];
    }
}

- (NSMutableDictionary *)getMediaTypeDic:(NSArray *)trackArray
{
    NSMutableDictionary *medidaTypeDic = [[NSMutableDictionary alloc] init];
    for (id item in trackArray) {
        @try {
            [self checkImportFileType:item withTypeDic:medidaTypeDic];
        }
        @catch (NSException *exception) {
            [logHandle writeInfoLog:[NSString stringWithFormat:@"MediaTypeDic exception:%@",exception]];
        }
        @finally {
        }
    }
    return [medidaTypeDic autorelease];
}

- (void)checkImportFileType:(id)item withTypeDic:(NSMutableDictionary *)dic{
    if ([item isKindOfClass:[IMBTrack class]]) {
        IMBTrack *newTrack = item;
        switch (newTrack.mediaType) {
            case Ringtone:
                if(![dic.allKeys containsObject:[NSString stringWithFormat:@"%d",newTrack.mediaType]]){
                    [dic setObject:[NSNumber numberWithInt:newTrack.mediaType] forKey:[NSString stringWithFormat:@"%d",newTrack.mediaType]];
                }
                break;
            case VoiceMemo:
                if(![dic.allKeys containsObject:[NSString stringWithFormat:@"%d",newTrack.mediaType]]){
                    [dic setObject:[NSNumber numberWithInt:newTrack.mediaType] forKey:[NSString stringWithFormat:@"%d",newTrack.mediaType]];
                }
                break;
            case PDFBooks:
            case Books:
                if (![dic.allKeys containsObject:[NSString stringWithFormat:@"%d",Books]]){
                    [dic setObject:[NSNumber numberWithInt:newTrack.mediaType] forKey:[NSString stringWithFormat:@"%d",Books]];
                }
                break;
            case Photo:
                if (![dic.allKeys containsObject:[NSString stringWithFormat:@"%d",Photo]]) {
                    [dic setObject:[NSNumber numberWithInt:newTrack.mediaType] forKey:[NSString stringWithFormat:@"%d",Photo]];
                }
                break;
            default:
                if (![dic.allKeys containsObject:[NSString stringWithFormat:@"%d",Audio]]){
                    [dic setObject:[NSNumber numberWithInt:newTrack.mediaType] forKey:[NSString stringWithFormat:@"%d",Audio]];
                }
                break;
        }
    }
}

- (void)setCurrentThread:(NSThread *)currentThread {
    if (_currentThread != nil) {
        [_currentThread release];
        _currentThread = nil;
    }
    _currentThread = [currentThread retain];
}


@end

@implementation IMBATHSyncAssetEntity

@synthesize assetID = _assetID;
@synthesize assetType = _assetType;

- (void)dealloc
{
    if (_assetID != nil) {
        [_assetID release];
    }
    if (_assetType != nil) {
        [_assetType release];
    }
    
    [super dealloc];
}


@end
*/

@implementation IMBSyncDataEntiy
@synthesize cigName = _cigName;
@synthesize ringtoneName = _ringtoneName;
@synthesize voiceMemoName = _voiceMemoName;
@synthesize bookName = _bookName;
@synthesize applicationName = _applicationName;
@synthesize localTempFolder = _localTempFolder;
@synthesize targetMediaPath = _targetMediaPath;
@synthesize targetCigPath = _targetCigPath;
@synthesize sourceMediaPath = _sourceMediaPath;
@synthesize sourceCigPath = _sourceCigPath;
@synthesize targetRingtonPath = _targetRingtonePath;
@synthesize sourceRingtonePath = _sourceRingtonePath;
@synthesize targetVoiceMemoPath = _targetVoiceMemoPath;
@synthesize sourceVoiceMemoPath = _sourceVoiceMemoPath;
@synthesize targetBookPath = _targetBookPath;
@synthesize sourceBookPath = _sourceBookPath;
@synthesize sourcePlistPath = _sourcePlistPath;
@synthesize targetPlistPath = _targetPlistPath;
@synthesize sourceApplicationPath = _sourceApplicationPath;
@synthesize targetApplicationPath = _targetApplicationPath;
@synthesize sourceAppIconStatePath = _sourceAppIconStatePath;
@synthesize targetAppIconStatePath = _targetAppIconStatePath;


@end

/*
@implementation IMBParamsAssetEntity
@synthesize mediaTypeStr = _mediaTypeStr;
@synthesize assetID = _assetID;
@end
 */
