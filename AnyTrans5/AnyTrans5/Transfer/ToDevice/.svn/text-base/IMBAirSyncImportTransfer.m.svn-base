//
//  IMBAirSyncImportTransfer.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-28.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBAirSyncImportTransfer.h"
#import "MediaHelper.h"
#import "IMBDeviceInfo.h"
#import "IMBZipHelper.h"
#import "IMBBooksHelperEntry.h"
#import "StringHelper.h"
#import "IMBTracklist.h"
#import "SystemHelper.h"
#import "IMBCreatePhotoSyncPlist.h"
#import "IMBSyncPhotoData.h"
#import "DateHelper.h"
#import "NSString+Category.h"
#import "IMBApplicationManager.h"
#import "IMBAppSyncModel.h"
#import "IMBFileSystem.h"
#import "IMBPlaylistList.h"
#import "IMBInformationManager.h"
#import "IMBInformation.h"
#import "IMBDeviceConnection.h"
#import "IMBNotificationDefine.h"
#import "NSString+Compare.h"
@implementation IMBAirSyncImportTransfer
@synthesize isRestore = _isRestore;

/**
 同步导入初始化方法
    ipodKey ---- 设备key；
    importFilePath ---- 需要导入的文件路劲数组；
    importcategory ---- 导入到设备的类别，Category_Summary代表所有类型导入；
    photoAlbum ---- 导入到指定相册的实体，可以传nil；
    playlistID ---- 导入到指定playlist的id，不需要导入到playlist中传0；
    delegate ---- 进度返回代理
 */
- (id)initWithIPodkey:(NSString *)ipodKey importFiles:(NSArray*)importFilePath CategoryNodesEnum:(CategoryNodesEnum)importcategory photoAlbum:(IMBPhotoEntity *)photoAlbum playlistID:(int64_t)playlistID delegate:(id)delegate
{
    self = [super initWithIPodkey:ipodKey withDelegate:delegate];
    if (self) {
        if (photoAlbum != nil) {
            _importPhotoAlbum = [photoAlbum retain];
        }
        _playlistID = playlistID;
        if (playlistID != 0 && _ipod.playlists != nil) {
            _plistItem = [[_ipod.playlists getPlaylistByID:_playlistID] retain];
        }
        if ([_ipod tracks] == nil) {
            _listTrack = [[IMBTracklist alloc] init];
        }else {
            _listTrack = [[_ipod tracks] retain];
        }
        _mediaConverter = [IMBMediaConverter singleton];
        [_mediaConverter reInitWithiPod:_ipod];
        _importFilePath = [importFilePath  retain];
        _toConvertFiles = [[NSMutableArray alloc] init];
        _toConvertCategoryEnums = [[NSMutableArray alloc] init];
        _importFiles = [[NSMutableArray alloc] init];
        _importcategoryNodes = [[NSMutableArray alloc] init];
        _importcategory = importcategory;
        if (_importcategory == Category_Summary) {
            _isSingleImport = NO;
        }else{
            _isSingleImport = YES;
        }
        _isNeedConversion = YES;
    }
    return self;
}

//android到iOS 时 调用
- (id)initWithIPodkey:(NSString *)ipodKey TransferDic:(NSMutableDictionary *)transferDic delegate:(id)delegate
{
    self = [super initWithIPodkey:ipodKey withDelegate:delegate];
    if (self) {
        _transferDic = [transferDic retain];
        if ([_ipod tracks] == nil) {
            _listTrack = [[IMBTracklist alloc] init];
        }else {
            _listTrack = [[_ipod tracks] retain];
        }
        _mediaConverter = [IMBMediaConverter singleton];
        [_mediaConverter reInitWithiPod:_ipod];
        _toConvertFiles = [[NSMutableArray alloc] init];
        _toConvertCategoryEnums = [[NSMutableArray alloc] init];
        _importFiles = [[NSMutableArray alloc] init];
        _importcategoryNodes = [[NSMutableArray alloc] init];
        _isSingleImport = NO;
        _isNeedConversion = YES;
    }
    return self;
}

//重命名相册
- (id)initWithIPodkey:(NSString *)ipodKey Rename:(NSString *)rename AlbumEntity:(IMBPhotoEntity *)albumEntity {
    self = [super initWithIPodkey:ipodKey withDelegate:nil];
    if (self) {
        if (albumEntity != nil) {
            _importPhotoAlbum = [albumEntity retain];
        }
        _rename = [rename retain];
    }
    return self;
}

- (void)startTransfer {
    _ipod.beingSynchronized = YES;
    [MediaHelper killiTunes];
    [_loghandle writeInfoLog:@"++++++++++++transfer start+++++++++"];
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transferDelegate transferPrepareFileStart:CustomLocalizedString(@"ImportSync_id_20", nil)];
    }
    [_ipod startSync];
    NSDictionary *dic = [self paraseFileType];
    //开始创建同步服务
    if (_athSync != nil) {
        [_athSync release];
        _athSync = nil;
    }
    NSArray *importcategoryNodes = [dic objectForKey:@"category"];
    
    if (!([importcategoryNodes containsObject:@(Category_Applications)]&&[importcategoryNodes count] == 1)) {
        if (_transferDic  != nil) {
            NSMutableArray *photoalbums = nil;
            if ([importcategoryNodes containsObject:@(Category_MyAlbums)]) {
                NSInteger index = [importcategoryNodes indexOfObject:@(Category_MyAlbums)];
                NSArray *supportKind = [dic objectForKey:@"names"];
                NSDictionary *dic = [supportKind objectAtIndex:index];
                photoalbums = [NSMutableArray array];
                for (NSString *key in [dic allKeys]) {
                    IMBPhotoEntity *entity = [[IMBPhotoEntity alloc] init];
                    entity.albumZpk = -4;
                    entity.albumKind = 1550;
                    entity.albumTitle = key;
                    entity.albumType = SyncAlbum;
                    [photoalbums addObject:entity];
                    [entity release];
                }
            }
            _athSync = [[IMBATHSync alloc] initWithiPod:_ipod SyncNodes:importcategoryNodes syncCtrType:SyncAddFile photoAlbums:photoalbums];
            
        }else{
            _athSync = [[IMBATHSync alloc] initWithiPod:_ipod SyncNodes:importcategoryNodes syncCtrType:SyncAddFile photoAlbum:_importPhotoAlbum];
        }
    }
    [_athSync setListener:self];
    [_athSync setCurrentThread:[NSThread currentThread]];
    [self prepareAndFilterConverterFiles:dic];
    if (_isNeedConversion) {
        [self conversionAndImportFiles];
    }
    NSLog(@"++++++++++++3");
    if ([_importFiles count]>0) {
         //刷新设备剩余空间
         [_listTrack freshFreeSpace];
        //创建所有的track对象
        NSMutableArray *allTracks = [self prepareAllTrack];
        //存储最大uuid
        if (_transferDic != nil) {
            [_athSync setMaxUUIDStr:_maxUUIDStr];
        }
        NSLog(@"++++++++++++4");
        
        NSString *msgStr1 = CustomLocalizedString(@"ImportSync_id_4", nil);
        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
            [_transferDelegate transferFile:msgStr1];
        }
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (!_isStop) {
            //如果只有app，则导入不需要开同步
            if ([importcategoryNodes containsObject:@(Category_Applications)]&&[importcategoryNodes count] == 1) {
                if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
                    [_transferDelegate transferPrepareFileEnd];
                }
                [self startTransferApps:allTracks];
            }else{
                //同步方式导入
                //开始同步传输前，设置需要同步传输的对象
                NSString *msgStr = CustomLocalizedString(@"ImportSync_id_2", nil);
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:msgStr];
                }
                [_athSync setSyncTasks:allTracks];
                msgStr = CustomLocalizedString(@"ImportSync_id_1", nil);
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:msgStr];
                }
                //开始同步
                if ([_athSync createAirSyncService]) { //开启服务 并监听设备
                    if ([_athSync sendRequestSync]) { //发送RequestSync 命令
                        //创建plist cig
                        if ([_athSync createPlistAndCigSendDataSync]) {
                            if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
                                [_transferDelegate transferPrepareFileEnd];
                            }
                            //开始拷贝文件
                            [_athSync startCopyData];
                            //等待同步结束
                            [_athSync waitSyncFinished];
                            //to do 开始核对文件是否传输成功
                            [_ipod saveChanges];
                        }else{
                            //直接结束
                            [_athSync waitSyncFinished];
                        }
                        //保存数据库
                    }
                }
                //开始导入app
                [self startTransferApps:allTracks];
            }
        }else {
            for (IMBTrack *track in allTracks) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:track.srcFilePath.lastPathComponent WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
            }
        }
    }
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
    [_ipod endSync];
    [_loghandle writeInfoLog:@"++++++++++++transfer end+++++++++"];
    _ipod.beingSynchronized = NO;
    _mediaConverter.isStop = NO;

}

- (void)setIsStop:(BOOL)isStop
{
    _isStop = isStop;
    _mediaConverter.isStop = isStop;
    [_athSync stopAirSync];
}

- (NSMutableArray *)prepareAllTrack {
    NSMutableArray *tracks = [NSMutableArray array];
    _totalItemCount = [self totalItemscount];
    if (_isRestore) {
        NSMutableArray *allArray = [NSMutableArray array];
        for (int i = 0; i < _importcategoryNodes.count; i++) {
            CategoryNodesEnum categoryEnum = (CategoryNodesEnum)[[_importcategoryNodes objectAtIndex:i] unsignedIntegerValue];
            if (categoryEnum == Category_MyAlbums || categoryEnum == Category_PhotoLibrary) {
                if (_transferDic != nil) {
                    NSDictionary *dic = [_importFiles objectAtIndex:i];
                    for (NSString *key in [dic allKeys]) {
                        NSArray *pathArray = [dic objectForKey:key];
                        [allArray addObjectsFromArray:pathArray];
                    }
                }
            }
        }
        NSMutableArray *uuidArray = [self createImportImageInfo:allArray];
        [tracks addObjectsFromArray:uuidArray];
    }else {
        for (int i = 0; i < _importcategoryNodes.count; i++) {
            //to do 如果没有注册 需要要加数量限制
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                NSArray *array = [_importFiles objectAtIndex:i];
                for (NSString *url in array) {
                   [[IMBTransferError singleton] addAnErrorWithErrorName:url.lastPathComponent WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                }
                continue;
            }
            CategoryNodesEnum categoryEnum = (CategoryNodesEnum)[[_importcategoryNodes objectAtIndex:i] unsignedIntegerValue];
            switch (categoryEnum) {
                case Category_iBookCollections:
                case Category_iBooks:
                {
                    NSMutableArray* addArray = [self prepareIBooksWithBookArray:[_importFiles objectAtIndex:i]];
                    [tracks addObjectsFromArray:addArray];
                }
                    break;
                case Category_PhotoLibrary:
                case Category_MyAlbums:
                {
                    if (_transferDic != nil) {
                        NSMutableArray *allArray = [NSMutableArray array];
                        NSDictionary *dic = [_importFiles objectAtIndex:i];
                        for (NSString *key in [dic allKeys]) {
                            NSArray *pathArray = [dic objectForKey:key];
                            [allArray addObjectsFromArray:pathArray];
                        }
                        NSMutableArray *uuidArray = [self createImportImageInfo:allArray];
                        [tracks addObjectsFromArray:uuidArray];
                    }else{
                        NSMutableArray *uuidArray = [self createImportImageInfo:[_importFiles objectAtIndex:i]];
                        [tracks addObjectsFromArray:uuidArray];
                    }
                }
                    break;
                case Category_Applications:
                {
                    NSArray *applicationArr = [self prepareApplicationWithArray:[_importFiles objectAtIndex:i]];
                    [tracks addObjectsFromArray:applicationArr];
                }
                    break;
                default:
                {
                    BOOL supportConverter = YES;
                    NSMutableArray* addArray = [self prepareMediaWithMediaArray:[_importFiles objectAtIndex:i] isNeedConverting:supportConverter categoryEnum:categoryEnum];
                    [tracks addObjectsFromArray:addArray];
                }
                    break;
            }
        }
    }
    return tracks;
}

//根据后缀名解析文件类别 eg:是music ringtong voicememos app book photo
- (NSDictionary *)paraseFileType
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableArray *supportCategoray = [NSMutableArray array];
    NSMutableArray *supportKind = [NSMutableArray array];
    
    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
    if (_transferDic == nil) {
        if (_isSingleImport) {
            NSArray *supportExtension = [[MediaHelper getSupportFileTypeArray:_importcategory supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_ipod] componentsSeparatedByString:@";"];
            [self getFileNames:_importFilePath byFileExtensions:supportExtension toArray:fileArray];
            [supportCategoray addObject:[NSNumber numberWithInt:_importcategory]];
            [supportKind addObject:fileArray];
        }else {
            NSMutableArray *supportMusic = [NSMutableArray array];
            NSMutableArray *supportVideo = [NSMutableArray array];
            NSMutableArray *supportVoiceMemo = [NSMutableArray array];
            NSMutableArray *supportRingone = [NSMutableArray array];
            NSMutableArray *supportApplication = [NSMutableArray array];
            NSMutableArray *supportIBook = [NSMutableArray array];
            NSMutableArray *supportPhoto = [NSMutableArray array];
            NSArray *supportAllExtension = [MediaHelper filterSupportArrayWithIpod:_ipod isSingleImport:NO];
            NSArray *supportVoiceMemoExtension = [[MediaHelper getSupportFileTypeArray:Category_VoiceMemos supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:NO withiPod:_ipod] componentsSeparatedByString:@";"];
            NSArray *supportRingtoneExtension = [[MediaHelper getSupportFileTypeArray:Category_Ringtone supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:NO withiPod:_ipod] componentsSeparatedByString:@";"];
            NSArray *supportIBookExtension = [[MediaHelper getSupportFileTypeArray:Category_iBooks supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:NO withiPod:_ipod] componentsSeparatedByString:@";"];
            NSArray *supportApplicationExtension = [[MediaHelper getSupportFileTypeArray:Category_Applications supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_ipod] componentsSeparatedByString:@";"];
            NSArray *supportPhotoExtension = [[MediaHelper getSupportFileTypeArray:Category_PhotoLibrary supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_ipod] componentsSeparatedByString:@";"];
            NSArray *supportVideoExtension = [[MediaHelper getSupportFileTypeArray:Category_Movies supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_ipod] componentsSeparatedByString:@";"];
            [self getFileNames:_importFilePath byFileExtensions:supportAllExtension toArray:fileArray];
            for (NSString *string in fileArray) {
                NSString *extension = [[string pathExtension] lowercaseString];
                if([supportApplicationExtension containsObject:extension]){
                    [supportApplication addObject:string];
                }else if ([supportIBookExtension containsObject:extension]) {
                    [supportIBook addObject:string];
                }else if([supportRingtoneExtension containsObject:extension]){
                    [supportRingone addObject:string];
                }else if([supportVoiceMemoExtension containsObject:extension]){
                    [supportVoiceMemo addObject:string];
                }else if([supportVideoExtension containsObject:extension]){
                    [supportVideo addObject:string];
                }else if ([supportPhotoExtension containsObject:extension]) {
                    [supportPhoto addObject:string];
                }else if([supportAllExtension containsObject:extension]){
                    [supportMusic addObject:string];
                }
            }
            
            if (supportRingone.count > 0) {
                [supportCategoray addObject:[NSNumber numberWithInt:Category_Ringtone]];
                [supportKind addObject:supportRingone];
            }
            if (supportVoiceMemo.count > 0){
                [supportCategoray addObject:[NSNumber numberWithInt:Category_VoiceMemos]];
                [supportKind addObject:supportVoiceMemo];
            }
            if (supportVideo.count > 0){
                [supportCategoray addObject:[NSNumber numberWithInt:Category_Movies]];
                [supportKind addObject:supportVideo];
            }
            if (supportMusic.count > 0){
                [supportCategoray addObject:[NSNumber numberWithInt:Category_Music]];
                [supportKind addObject:supportMusic];
            }
            if (supportApplication.count > 0) {
                [supportCategoray addObject:[NSNumber numberWithInt:Category_Applications]];
                [supportKind addObject:supportApplication];
            }
            if (supportIBook.count > 0) {
                [supportCategoray addObject:[NSNumber numberWithInt:Category_iBooks]];
                [supportKind addObject:supportIBook];
            }
            if (supportPhoto.count > 0) {
                [supportCategoray addObject:[NSNumber numberWithInt:Category_PhotoLibrary]];
                [supportKind addObject:supportPhoto];
            }
        }

    }else{
        for (NSNumber *key in [_transferDic allKeys]) {
            switch (key.intValue) {
                case Category_Music:
                {
                    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
                    NSString *supportExStr = [MediaHelper getSupportFileTypeArray:Category_Music supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_ipod];
                    //追加m4v格式
                    supportExStr = [supportExStr stringByAppendingString:@";m4v"];
                    NSArray *supportExtension = [supportExStr componentsSeparatedByString:@";"];
                    NSString *musicPath = [_transferDic objectForKey:@(Category_Music)];
                    [self getFileNames:[NSArray arrayWithObject:musicPath] byFileExtensions:supportExtension toArray:fileArray];
                    [supportCategoray addObject:[NSNumber numberWithInt:Category_Music]];
                    [supportKind addObject:fileArray];
                    [fileArray release];
                }

                    break;
                case Category_Movies:
                {
                    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
                    NSArray *supportExtension = [[MediaHelper getSupportFileTypeArray:Category_Movies supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_ipod] componentsSeparatedByString:@";"];
                    NSString *moviesPath = [_transferDic objectForKey:@(Category_Movies)];
                    [self getFileNames:[NSArray arrayWithObject:moviesPath] byFileExtensions:supportExtension toArray:fileArray];
                    [supportCategoray addObject:[NSNumber numberWithInt:Category_Movies]];
                    [supportKind addObject:fileArray];
                    [fileArray release];
                }
                    break;
                case Category_Ringtone:
                {
                    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
                    NSArray *supportExtension = [[MediaHelper getSupportFileTypeArray:Category_Ringtone supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_ipod] componentsSeparatedByString:@";"];
                    NSString *ringtonePath = [_transferDic objectForKey:@(Category_Ringtone)];
                    [self getFileNames:[NSArray arrayWithObject:ringtonePath] byFileExtensions:supportExtension toArray:fileArray];
                    [supportCategoray addObject:[NSNumber numberWithInt:Category_Ringtone]];
                    [supportKind addObject:fileArray];
                    [fileArray release];
                }

                    break;
                case Category_iBooks:
                {
                    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
                    NSArray *supportExtension = [[MediaHelper getSupportFileTypeArray:Category_iBooks supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_ipod] componentsSeparatedByString:@";"];
                    NSString *iBooksPath = [_transferDic objectForKey:@(Category_iBooks)];
                    [self getFileNames:[NSArray arrayWithObject:iBooksPath] byFileExtensions:supportExtension toArray:fileArray];
                    [supportCategoray addObject:[NSNumber numberWithInt:Category_iBooks]];
                    [supportKind addObject:fileArray];
                    [fileArray release];
                }

                    break;
                case Category_MyAlbums:
                {
                    if (_isRestore) {
                        NSDictionary *myAlbumsDic = [_transferDic objectForKey:@(Category_MyAlbums)];
                        [supportCategoray addObject:[NSNumber numberWithInt:Category_MyAlbums]];
                        [supportKind addObject:myAlbumsDic];
                    }else {
                        NSArray *supportExtension = [[MediaHelper getSupportFileTypeArray:Category_MyAlbums supportVideo:_ipod.deviceInfo.isSupportVideo supportConvert:YES withiPod:_ipod] componentsSeparatedByString:@";"];
                        NSString *MyAlbumsPath = [_transferDic objectForKey:@(Category_MyAlbums)];
                        NSDictionary *dic = [self getPhotoAlbums:MyAlbumsPath byFileExtensions:supportExtension];
                        [supportCategoray addObject:[NSNumber numberWithInt:Category_MyAlbums]];
                        [supportKind addObject:dic];
                    }
                }
                    break;
                case Category_PhotoLibrary:
                {
                    if (_isRestore) {
                        NSArray *photoArr = [_transferDic objectForKey:@(Category_PhotoLibrary)];
                        if (photoArr) {
                            [supportCategoray addObject:[NSNumber numberWithInt:Category_PhotoLibrary]];
                            [supportKind addObject:[NSDictionary dictionaryWithObject:photoArr forKey:@"myPicture"]];
                        }
                    }
                }
                    break;
            }
        }
    }
    [dictionary setObject:supportCategoray forKey:@"category"];
    [dictionary setObject:supportKind forKey:@"names"];
    [fileArray release];
    return dictionary;
}

- (NSDictionary *)getPhotoAlbums:(NSString *)path byFileExtensions:(NSArray *)fileExtensions
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contentArray = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for (NSString *name in contentArray) {
        if (![name hasPrefix:@"."]) {
            NSString *filePath = [path stringByAppendingPathComponent:name];
            NSMutableArray *filePathArray = [self getfilePathInDir:filePath byFileExtensions:fileExtensions];
            [dic setObject:filePathArray forKey:name];
        }
    }
    return dic;
}

- (NSMutableArray *)getfilePathInDir:(NSString *)dirPath byFileExtensions:(NSArray *)fileExtensions
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *libraryArr = [NSMutableArray array];
    NSArray *arr = [fileManager contentsOfDirectoryAtPath:dirPath error:nil];
    for (NSString *name in arr) {
        if ([name hasPrefix:@"."]) {
            continue;
        }
        NSString *filePath = [dirPath stringByAppendingPathComponent:name];
        NSString *extension = [[filePath pathExtension] lowercaseString];
        if ([fileExtensions containsObject:extension]) {
            [libraryArr addObject:filePath];
        }
    }
    return libraryArr;
}

- (void)getFileNames:(NSArray *)fileNames byFileExtensions:(NSArray *)fileExtensions toArray:(NSMutableArray *)array{
    @autoreleasepool {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        for (NSString *string in fileNames) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            if ([[fileManager attributesOfItemAtPath:string error:nil] fileType] == NSFileTypeDirectory) {
                NSError *error = nil;
                NSArray *items = [fileManager subpathsOfDirectoryAtPath:string error:&error];
                for (NSString *path in items) {
                    path = [string stringByAppendingPathComponent:path];
                    if (array.count > _limitation.remainderCount) {
                        break;
                    }
                    NSString *extension = [path pathExtension].lowercaseString;
                    if ([fileExtensions containsObject:extension]) {
                        [array addObject:path];
                    }
                }
            }
            else{
                if (array.count > _limitation.remainderCount) {
                    break;
                }
                NSString *extension = [string pathExtension].lowercaseString;
                if(extension.length > 0 && [fileExtensions containsObject:extension]){
                    [array addObject:string];
                }
            }
        }
    }
}

#pragma mark - 检测所有需要转换的文件
- (void)prepareAndFilterConverterFiles:(NSDictionary *)dictionary{
    [_toConvertFiles removeAllObjects];
    [_toConvertCategoryEnums removeAllObjects];
    [_importFiles removeAllObjects];
    [_importcategoryNodes removeAllObjects];
    //分好类的文件 importFiles 与 categoryNodes是类型与文件的对应关系
    NSArray *importFiles = [dictionary objectForKey:@"names"];
    NSArray *importcategoryNodes = [dictionary objectForKey:@"category"];
    if (_isiTunesImport) {
        [_importFiles addObjectsFromArray:importFiles];
        [_importcategoryNodes addObjectsFromArray:importcategoryNodes];
        _isNeedConversion = false;
        return;
    }
    NSMutableArray *handledImportFiles = [NSMutableArray array];
    NSMutableArray *handledCategoryEnums = [NSMutableArray array];
    for (NSNumber *number in importcategoryNodes) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            break;
        }
        int i = (int)[importcategoryNodes indexOfObject:number];
        NSMutableArray *array = [importFiles objectAtIndex:i];
        CategoryNodesEnum category = (CategoryNodesEnum)[number integerValue];
        if (category == Category_iBooks ||
            category == Category_PhotoLibrary ||
            category == Category_MyAlbums ||
            category == Category_Applications ||
            category == Category_iBookCollections) {
            [handledImportFiles addObject:array];
            [handledCategoryEnums addObject:number];
            continue;
        }
        else{
            @autoreleasepool {
                NSMutableArray *compArr = [NSMutableArray array];
                NSArray *VideoExt = [[MediaHelper getSupportFileTypeArray:Category_Movies supportVideo:[[_ipod deviceInfo] isSupportVideo] supportConvert:YES withiPod:_ipod] componentsSeparatedByString:@";"];
                NSArray *supportMusicExt = [[MediaHelper getSupportFileTypeArray:Category_Music supportVideo:[[_ipod deviceInfo] isSupportVideo] supportConvert:NO withiPod:_ipod] componentsSeparatedByString:@";"];
                NSArray *supportVideoExt = [[MediaHelper getSupportFileTypeArray:Category_Movies supportVideo:[[_ipod deviceInfo] isSupportVideo] supportConvert:NO withiPod:_ipod] componentsSeparatedByString:@";"];
                BOOL isMusic = YES;
                for (NSString *filePath in array) {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        break;
                    }
                    BOOL supportExt = false;
                    isMusic = ![self checkFileSupport:VideoExt filePath:filePath];
                    if (isMusic) {
                        if (_isSingleImport) {
                            NSArray *supportPartExt = [[MediaHelper getSupportFileTypeArray:_importcategory supportVideo:[[_ipod deviceInfo] isSupportVideo] supportConvert:NO withiPod:_ipod] componentsSeparatedByString:@";"];
                            supportExt = [self checkFileSupport:supportPartExt filePath:filePath];
                        }
                        else{
                            if (_transferDic != nil) {
                                NSArray *supportPartExt = [[MediaHelper getSupportFileTypeArray:category supportVideo:[[_ipod deviceInfo] isSupportVideo] supportConvert:NO withiPod:_ipod] componentsSeparatedByString:@";"];
                                supportExt = [self checkFileSupport:supportPartExt filePath:filePath];
                            }else{
                                supportExt = [self checkFileSupport:supportMusicExt filePath:filePath];
                            }
                        }
                    }
                    else{
                        if (_isSingleImport) {
                            NSArray *supportPartExt = [[MediaHelper getSupportFileTypeArray:_importcategory supportVideo:[[_ipod deviceInfo] isSupportVideo] supportConvert:NO withiPod:_ipod] componentsSeparatedByString:@";"];
                            supportExt = [self checkFileSupport:supportPartExt filePath:filePath];
                        }else{
                            if (_transferDic != nil) {
                                NSArray *supportPartExt = [[MediaHelper getSupportFileTypeArray:category supportVideo:[[_ipod deviceInfo] isSupportVideo] supportConvert:NO withiPod:_ipod] componentsSeparatedByString:@";"];
                                supportExt = [self checkFileSupport:supportPartExt filePath:filePath];

                            }else{
                                supportExt = [self checkFileSupport:supportVideoExt filePath:filePath];
                            }
                        }
                    }
                    BOOL isNeedToConvert = false;
                    BOOL isCvtVideo = !_ipod.transCodingConfig.mediaNoConvert;
                    BOOL isCvtAudio = !_ipod.transCodingConfig.audioNoConvert;
                    if (_isSingleImport) {
                        isNeedToConvert = [_mediaConverter checkDeviceConvertWithiPod:_ipod Path:filePath IsCvtVideo:isCvtVideo IsCvtAudio:isCvtAudio SupportVideo:_ipod.deviceInfo.isSupportVideo SupportAudio:_ipod.deviceInfo.isSupportMusic SupportExt:supportExt withType:_importcategory];
                    }else{
                        isNeedToConvert = [_mediaConverter checkDeviceConvertWithiPod:_ipod Path:filePath IsCvtVideo:isCvtVideo IsCvtAudio:isCvtAudio SupportVideo:_ipod.deviceInfo.isSupportVideo SupportAudio:_ipod.deviceInfo.isSupportMusic SupportExt:supportExt withType:category];
                    }
                    if (isNeedToConvert) {
                        [compArr addObject:filePath];
                    }
                }
                if (compArr.count > 0) {
                    [_toConvertFiles addObject:compArr];
                    [_toConvertCategoryEnums addObject:number];
                    [array removeObjectsInArray:compArr];
                }
                if (array.count > 0) {
                    [handledImportFiles addObject:array];
                    [handledCategoryEnums addObject:number];
                }
            }
        }
    }
    [_importFiles addObjectsFromArray:handledImportFiles];
    [_importcategoryNodes addObjectsFromArray:handledCategoryEnums];
    if ([self totalItemsCountInArray:_toConvertFiles] == 0) {
        _isNeedConversion = false;
    }
}

#pragma mark - 处理需要转换文件的方法
- (BOOL)conversionAndImportFiles{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conversionProgress:) name:NOTIFY_CVT_PROGRESS_TRANSFER object:nil];
    BOOL isNeedToConvert = FALSE;
    //这里需要询问是否需要转换
    @autoreleasepool {
        //转换并导入文件到设备
        if([self totalItemsCountInArray:_toConvertFiles] == 0){
            return isNeedToConvert;
        }
       //to do 转换相关进度
        isNeedToConvert = YES;
        if (_importcategory == Category_Ringtone) {
            [self startConvertMedia:YES];
        }else{
            [self startConvertMedia:NO];
        }
        if (_mediaConverter.outputCvtMediaList.count > 0) {
            for (NSNumber *number in _toConvertCategoryEnums) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                @autoreleasepool {
                    NSInteger index = [_toConvertCategoryEnums indexOfObject:number];
                    NSArray *_convertArray = [_toConvertFiles objectAtIndex:index];
                    NSArray *_outputList = _mediaConverter.outputCvtMediaList;
                    NSMutableArray *specifyCategoryConvertFiles = [NSMutableArray array];
                    for (NSString *filePath in _convertArray) {
                        for (IMBCvtEncodedMedia *mediaFile in _outputList) {
                            [_condition lock];
                            if (_isPause) {
                                [_condition wait];
                            }
                            [_condition unlock];
                            if (_isStop) {
                                break;
                            }
                            if ([filePath isEqualToString:mediaFile.sourceMediaPath]) {
                                [specifyCategoryConvertFiles addObject:mediaFile.encodedMediaPath];
                                continue;
                            }
                        }
                    }
                    if ([_importcategoryNodes containsObject:number]) {
                        NSInteger index = [_importcategoryNodes indexOfObject:number];
                        NSMutableArray *trackArray = [_importFiles objectAtIndex:index];
                        [trackArray addObjectsFromArray:specifyCategoryConvertFiles];
                    }else{
                        [_importcategoryNodes addObject:number];
                        [_importFiles addObject:specifyCategoryConvertFiles];
                    }
                }
            }
        }
        [_toConvertFiles removeAllObjects];
        [_toConvertCategoryEnums removeAllObjects];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CVT_PROGRESS_TRANSFER object:nil];
    return isNeedToConvert;
}

- (void) startConvertMedia:(bool) isConvToRingtone {
    [_mediaConverter convertMedia:_ipod.session.sessionFolderPath isRt:isConvToRingtone];
}

- (void)conversionProgress:(NSNotification *)notification {
    NSString *msgStr = [notification object];
    if (![TempHelper stringIsNilOrEmpty:msgStr]) {
        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
            [_transferDelegate transferFile:msgStr];
        }
    }
}

//检查文件格式是否支持
- (BOOL)checkFileSupport:(NSArray*)supportExt filePath:(NSString*)filePath {
    BOOL isSupport = FALSE;
    NSString *ext = [[filePath pathExtension] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[(NSString*)evaluatedObject stringByReplacingOccurrencesOfString:@"*." withString:@""] isEqualToString:[ext lowercaseString]];
    }];
    NSArray *preArray = [supportExt filteredArrayUsingPredicate:pre];
    if (preArray != nil && [preArray count] > 0) {
        isSupport = YES;
    } else {
        isSupport = NO;
    }
    return isSupport;
}

#pragma mark - 数据源查找数据处理
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

- (int)totalItemscount{
    int i = 0;
    for (NSArray *array in _importFiles) {
        if ([array isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)array;
            for (NSString *key in [dic allKeys]) {
                NSArray *keyArray = [dic objectForKey:key];
                i += keyArray.count;

            }
        }else{
            i += array.count;

        }
    }
    return i;
}

- (int)totalItemsCountInArray:(NSArray *)narray{
    int i = 0;
    for (NSArray *array in narray) {
        i += array.count;
    }
    return i;
}

#pragma mark - media处理方法  创建media的track对象
- (NSMutableArray *)prepareMediaWithMediaArray:(NSArray *)array isNeedConverting:(BOOL) isNeedCheckConverter categoryEnum:(CategoryNodesEnum)categoryEnum
{
    NSMutableArray *trackArray = [[[ NSMutableArray alloc] init] autorelease];
    NSString *filePath = nil;
    int successAnalyCount = 0;
    //如果是convert过的文件的话可能会有artwork
    NSString *artworkFilePath = nil;
    NSString *fileName = nil;
    IMBTrack *track = nil;
    
    int totalCount = (int)[array count];
    NSArray *supportExt = nil;
    if (!_isSingleImport) {
        supportExt = [NSArray array];
        if (categoryEnum == Category_Music && [[_ipod deviceInfo] isSupportVideo]) {
            supportExt = [[MediaHelper getSupportFile:Category_Movies supportVideo:[[_ipod deviceInfo] isSupportVideo] withiPod:_ipod]componentsSeparatedByString:@";"];
            
        }
        supportExt = [supportExt arrayByAddingObjectsFromArray:[[MediaHelper getSupportFile:categoryEnum supportVideo:[[_ipod deviceInfo] isSupportVideo] withiPod:_ipod]componentsSeparatedByString:@";"]];
        
    }else{
        supportExt = [[MediaHelper getSupportFile:_importcategory supportVideo:[[_ipod deviceInfo] isSupportVideo] withiPod:_ipod]componentsSeparatedByString:@";"];
    }
    
    for (int i = 0; i < totalCount; i++) {
        id curObject = [array objectAtIndex:i];
        filePath = (NSString*)curObject;
//        [_loghandle writeInfoLog:[NSString stringWithFormat:@"Current prepare FilePath is %@, current index is %d", filePath, i]];
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop == NO) {
            fileName = [[filePath pathComponents] lastObject];
            if (![TempHelper stringIsNilOrEmpty:fileName]) {
                NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"ImportSync_id_3", nil),fileName];
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:msgStr];
                }
            }
            
            if (![_fileManager fileExistsAtPath:filePath]) {
                //文件不存在
                if (![TempHelper stringIsNilOrEmpty:fileName]) {
                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_File_Not_Exist", nil),fileName];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
                [[IMBTransferError singleton] addAnErrorWithErrorName:filePath.lastPathComponent WithErrorReson:CustomLocalizedString(@"MSG_COM_NotExistDisk_Selected", nil)];
                continue;
            }

            bool isSupportedExt = [self checkFileSupport:supportExt filePath:filePath];
            //默认这里不需要转换,以前已经检测过了,单独对所有文件进行转换
            if (isSupportedExt) {
                BOOL isOutOfSpace = FALSE;
                //此处创建了
                if ([self createTrack:&successAnalyCount completedTrackArray:trackArray index:i filePath:filePath track:track isOutOfSpace:&isOutOfSpace artworkPath:artworkFilePath categoryEnum:categoryEnum] == NO) {
//                    for (int j = i; j < _totalItemCount; j++) {
//                        _ignoreCount += 1;
//                        filePath = [array objectAtIndex:j];
//                        fileName = [[filePath pathComponents] lastObject];
//                        [_transResult setMediaIgnoreCount:([_transResult mediaIgnoreCount] + 1)];
//                        [_transResult recordMediaResult:_fileName resultStatus:TransFailed messageID:(isOutOfSpace == YES ? @"MSG_TranResult_Failed_Device_OutofSpace" : @"IMBTransResult_SuccessAndSkip_Content3")];
//                    }
                    break;
                }
            } else {
                [[IMBTransferError singleton] addAnErrorWithErrorName:filePath.lastPathComponent WithErrorReson:CustomLocalizedString(@"Ex_Op_NotSupportConvert_File", nil)];

//                _ignoreCount += 1;
//                fileName = [[filePath pathComponents] lastObject];
//                [_transResult setMediaIgnoreCount:([_transResult mediaIgnoreCount] + 1)];
//                [_transResult recordMediaResult:_fileName resultStatus:TransIgnore messageID:@"MSG_TranResult_Skiped_MediaTpye_NotSupport"];
            }
        } else {
            
            [[IMBTransferError singleton] addAnErrorWithErrorName:filePath.lastPathComponent WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
//            _ignoreCount += 1;
//            fileName = [[filePath pathComponents] lastObject];
//            [_transResult setMediaIgnoreCount:([_transResult mediaIgnoreCount] + 1)];
//            [_transResult recordMediaResult:_fileName resultStatus:TransFailed messageID:@"IMBTransResult_SuccessAndSkip_Content3"];
        }
        // ToDo 判断未注册的设备是否允许还能继续导入
//        _progressCounter.prepareAnalysisSuccessCount ++;
//        BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//        if (isOutOfCount) {
//            break;
//        }
    }
    
    return trackArray;
}

//创建track
- (BOOL)createTrack:(int*)successAnalyCount completedTrackArray:(NSMutableArray*)completeTrackArray index:(int)index filePath:(NSString*)filePath track:(IMBTrack*)track isOutOfSpace:(BOOL*)isOutOfSpace artworkPath:(NSString*)artworkPath categoryEnum:(CategoryNodesEnum) category{
    IMBNewTrack *newTrack = nil;
    @try {
        [_loghandle writeInfoLog:@"createTrack in IMBAirSyncGeneralImport entered"];
        if (!_isSingleImport) {
            newTrack = [MediaHelper analyCreateTrack:filePath selectCategory:category];
        }else{
            newTrack = [MediaHelper analyCreateTrack:filePath selectCategory:_importcategory];
        }
        [_loghandle writeInfoLog:@"analy Create Track"];
        if (newTrack == nil) {
            return NO;
        }
    }
    @catch (NSException *exception) {
        // ToDo 用Taglib解析媒体文件失败的时候的媒体信息处理
        newTrack = [MediaHelper createBlankTrack:filePath selectCategory:category];
    }
    
    if (newTrack != nil) {
        //转换的时候，设置artwork的Path
        if (artworkPath != nil) {
            newTrack.artworkFile = artworkPath;
        }
        @try {
            track = [[_listTrack addTrack:newTrack copyToDevice:NO cacuTotalSize:_totalSize] retain];
            
            //判断创建的track的dbid是否有重复的
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dbID == %lld",track.dbID];
//            NSArray *array = [completeTrackArray filteredArrayUsingPredicate:predicate];
//            while (array.count > 0) {
//                [_listTrack removeTrack:track];
//                [self minusFolderSizeFormTotalSize:track.srcFilePath];
//                track = [_listTrack addTrack:newTrack copyToDevice:NO cacuTotalSize:_transTotalSize];
//                predicate = [NSPredicate predicateWithFormat:@"dbID == %lld",track.dbID];
//                array = [completeTrackArray filteredArrayUsingPredicate:predicate];
//            }
            _maxID = track.dbID;
        }
        @catch (NSException *exception) {
            if ([[exception name] isEqualToString:@"EX_OutOfDiskSpace"]) {
                NSString *msgStr = CustomLocalizedString(@"MSG_TranResult_Failed_Device_OutofSpace", nil);
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:msgStr];
                }
                return NO;
            } else if ([[exception name] isEqualToString:@"EX_Track_Already_Exists"]) {
                // 在这里主要是如果检测到Track下面存在，就把track加人Playlist里面
                if (![TempHelper stringIsNilOrEmpty:[newTrack title]]) {
                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_TranResult_Skiped_Existed", nil),[newTrack title]];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
//                NSString *_fileName = nil;
                if (_playlistID != 0) {
                    if (_plistItem != nil) {
                        track = [[exception userInfo] valueForKey:@"Exsit_Track"];
                        if (track != nil) {
                            [_plistItem addTrack:track];
                        }
                    }
                }
                return YES;
            } else {
                NSString *msgStr = CustomLocalizedString(@"ImportSync_id_14", nil);
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:msgStr];
                }
                return YES;
            }
        }
    }
    
    // 这里主要是对Track导入Playlist中的处理
    if (track != nil) {
        if (_plistItem != nil && !_plistItem.isMaster && !_plistItem.isPurchases) {
            @try {
                [_plistItem addTrack:track];
            }
            @catch (NSException *exception) {
//                if ([exception.name isEqualToString:@"EX_NotAllowed_Change_SmartPl"]) {
//                    _transResult.mediaFaildCount ++;
//                    [_transResult recordMediaResult:[track title] resultStatus:TransFailed messageID:CustomLocalizedString(@"Ex_Op_NotAllowed_Cannot_Change_SmartPl", nil)];
//                }
                [track release];
                return YES;
            }
        }
        else if(_specificPlistName.length > 0){
            IMBPlaylist *playlist = [_ipod.playlists getPlaylistByName:_specificPlistName];
            if (playlist == nil) {
                playlist = [_ipod.playlists addPlaylist:_specificPlistName];
            }
            if (playlist != nil) {
                [playlist addTrack:track];
            }
        }
        else if(_specificPlistNamses.count > 0){
            for (NSString *plistName in _specificPlistNamses.allKeys) {
                if (plistName.length > 0) {
                    NSArray *paths = [_specificPlistNamses objectForKey:plistName];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@",track.srcFilePath];
                    NSArray *result = [paths filteredArrayUsingPredicate:predicate];
                    if (result.count > 0) {
                        NSString *plistName = [result objectAtIndex:0];
                        IMBPlaylist *playlist = [_ipod.playlists getPlaylistByName:plistName];
                        if (playlist == nil) {
                            playlist = [_ipod.playlists addPlaylist:plistName];
                        }
                        if (playlist != nil) {
                            [playlist addTrack:track];
                            break;
                        }
                    }
                }
            }
        }
        _totalSize += track.fileSize;
        [completeTrackArray addObject:track];
//        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
//                              track, @"Track_Item"
//                              , nil];
//        [nc postNotificationName:NOTIFY_TRANSCREATETRACKCOMPLETE object:nil userInfo:info];
//        *successAnalyCount += 1;
        // ToDo分析完成后检查软件共享部分
        [track release];
    }
    [_loghandle writeInfoLog:@"createTrack in IMBAirSyncGeneralImport existed"];
    return YES;
}

- (BOOL)isMovieWithPath:(NSString *)path{
    NSArray *supportExt = [[MediaHelper getSupportFile:Category_Movies supportVideo:[[_ipod deviceInfo] isSupportVideo] withiPod:_ipod]componentsSeparatedByString:@";"];
    NSString *pathExtension = [path pathExtension];
    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[(NSString*)evaluatedObject stringByReplacingOccurrencesOfString:@"*." withString:@""] isEqualToString:[pathExtension lowercaseString]];
    }];
    NSArray *preArray = [supportExt filteredArrayUsingPredicate:pre];
    if (preArray.count > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - book 处理方法 创建book的track对象
- (NSMutableArray *)prepareIBooksWithBookArray:(NSArray *)array{
    [_loghandle writeInfoLog:@"parepareTrack in importBooksImport entered"];
    NSMutableArray *completedBookArray = [[NSMutableArray alloc] init];
    if ( [array count] > 0) {
        //媒体转换文件的数量大于0
        NSMutableArray *epubBookArray = [[NSMutableArray alloc] init];
        NSMutableArray *pdfBookArray = [[NSMutableArray alloc] init];
        NSPredicate *epubPre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [((NSString*)evaluatedObject).lowercaseString hasSuffix:@".epub"];
        }];
        NSPredicate *pdfPre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return [((NSString*)evaluatedObject).lowercaseString hasSuffix:@".pdf"];
        }];
        NSArray *tmpArray = [array filteredArrayUsingPredicate:epubPre];
        if (tmpArray != nil && [tmpArray count] > 0) {
            [epubBookArray addObjectsFromArray:tmpArray];
        }
        tmpArray = [array filteredArrayUsingPredicate:pdfPre];
        if (tmpArray != nil && [tmpArray count] > 0) {
            [pdfBookArray addObjectsFromArray:tmpArray];
        }
        BOOL goOn = YES;
        BOOL isOutOfSpace = NO;
        NSMutableArray *extractInfoArray = [[NSMutableArray alloc] init];
        if ([epubBookArray count] > 0) {
            //解析epub信息
            [self extractingFile:epubBookArray extractInfoArray:extractInfoArray];
        }
        // Epub电子书的Track构建
        NSString *_fileName = nil;
        if ([extractInfoArray count] > 0) {
            NSString *bookName = nil;
            NSString *bookPath = nil;
            NSMutableArray *existedFilePathArr = [[NSMutableArray alloc] init];
            for (IMBEpubBookInfo *epubItem in extractInfoArray) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    goOn = NO;
                }
                if (goOn) {
                    _fileName = [epubItem bookName];
//                    [_loghandle writeInfoLog:[NSString stringWithFormat:@"parepareTrack in importBooksImport fileName:%@",_fileName]];
                    if (![TempHelper stringIsNilOrEmpty:_fileName]) {
                        NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"ImportSync_id_3", nil),_fileName];
                        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                            [_transferDelegate transferFile:msgStr];
                        }
                    }
                    BOOL isDir = NO;
                    if ([_fileManager fileExistsAtPath:[epubItem extractFolderPath] isDirectory:&isDir]) {
                        if (isDir) {
                            NSDictionary *bookInfoDic = [self getBookInfo:[epubItem extractFolderPath] bookName:&bookName bookPath:&bookPath extenion:@"epub"];
                            if (![StringHelper stringIsNilOrEmpty:bookPath]) {
                                if (bookInfoDic != nil && [bookInfoDic count] > 0) {
                                    IMBNewTrack *newTrack = [self createTrack:bookInfoDic bookFilePath:[epubItem epubLocalPath] bookName:bookName];
                                    IMBTrack *track = nil;
                                    @try {
                                        //创建track对象
                                        track = [_listTrack addTrack:newTrack copyToDevice:NO cacuTotalSize:0];
//                                        int64_t dbID = track.dbID;
//                                        while ([existedFilePathArr containsObject:track.filePath] || maxID == dbID) {
//                                            [[iPod tracks] removeTrack:track];
//                                            [self minusFolderSizeFormTotalSize:[epubItem extractFolderPath]];
//                                            track = [[iPod tracks] addTrack:newTrack copyToDevice:NO cacuTotalSize:_transTotalSize];
//                                        }
                                        _maxID = track.dbID;
                                        [existedFilePathArr addObject:track.filePath];
                                    }
                                    @catch (NSException *exception) {
                                        [_loghandle writeInfoLog:[NSString stringWithFormat:@"parepareTrack in importBooksImport error:%@",exception.description]];
                                        
                                        if ([[exception name] isEqualToString:@"EX_OutOfDiskSpace"]) {
                                            NSString *msgStr = CustomLocalizedString(@"MSG_TranResult_Failed_Device_OutofSpace", nil);
                                            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                                [_transferDelegate transferFile:msgStr];
                                            }
                                            goOn = NO;
                                            isOutOfSpace = YES;
                                            break;
                                        } else if ([[exception name] isEqualToString:@"EX_Track_Already_Exists"]) {
                                            if (![TempHelper stringIsNilOrEmpty:_fileName]) {
                                                NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_TranResult_Skiped_Existed", nil),_fileName];
                                                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                                    [_transferDelegate transferFile:msgStr];
                                                }
                                            }
                                            continue;
                                        } else {
                                            NSString *msgStr = CustomLocalizedString(@"ImportSync_id_14", nil);
                                            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                                [_transferDelegate transferFile:msgStr];
                                            }
                                            continue;
                                        }
                                    }
                                    NSMutableDictionary *detailInfo = [[[NSMutableDictionary alloc] init] autorelease];
                                    [MediaHelper getEpubDetailInfo:[epubItem extractFolderPath] inDic:detailInfo];
                                    NSString *publisherUniqueId = [detailInfo objectForKey:@"uuid"];
                                    NSString *filePackageHash =[detailInfo objectForKey:@"file-package-hash"];
                                    NSString *name = [detailInfo objectForKey:@"name"];
                                    NSString *artist = [detailInfo objectForKey:@"artist"];
                                    NSString *album = [detailInfo objectForKey:@"album"];
                                    NSString *genre = [detailInfo objectForKey:@"genre"];
                                    
                                    if (![StringHelper stringIsNilOrEmpty:name]) {
                                        [track setTitle:name];
                                    }
                                    if (![StringHelper stringIsNilOrEmpty:artist]) {
                                        [track setArtist:artist];
                                    }
                                    if (![StringHelper stringIsNilOrEmpty:album]) {
                                        [track setAlbum:album];
                                    }
                                    if (![StringHelper stringIsNilOrEmpty:genre]) {
                                        [track setGenre:genre];
                                    }
                                    [track setPackageHash:filePackageHash];
                                    [track setTitle:bookName];
                                    [track setExactFolderIfEpubBook:[epubItem extractFolderPath]];
                                    NSString *version = _ipod.deviceInfo.productVersion;
                                    int charnum = 8;
                                    @try {
                                        if ([version isVersionMajorEqual:@"10"]) {
                                            charnum = [[version substringToIndex:2] intValue];
                                        }else {
                                            charnum = [[version substringToIndex:1] intValue];
                                        }
                                    } @catch (NSException *exception) {
                                        charnum = 8;
                                    }
                                    if(charnum>7){
                                        [track setSrcFilePath:[epubItem extractFolderPath]];
                                    }
                                    [track setUuid:publisherUniqueId];
                                    [track setMediaType:Books];
                                    _totalSize += track.fileSize;
                                    [completedBookArray addObject:track];
                                    // ToDo 判断未注册的设备是否允许还能继续导入
                                    
//                                    _progressCounter.prepareAnalysisSuccessCount ++;
//                                    
//                                    BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                                    if (isOutOfCount) {
//                                        break;
//                                    }
                                    
                                }
                            }
                        } else {
                            _failedCount += 1;
//                            [_transResult setMediaFaildCount:([_transResult mediaFaildCount] + 1)];
//                            [_transResult recordMediaResult:[epubItem bookName] resultStatus:TransError messageID:@"IMBTransResult_SuccessAndSkip_Content3"];
                        }
                    } else {
                        _failedCount += 1;
//                        [_transResult setMediaFaildCount:([_transResult mediaFaildCount] + 1)];
//                        [_transResult recordMediaResult:[epubItem bookName] resultStatus:TransError messageID:@"IMBTransResult_SuccessAndSkip_Content3"];
                    }
                } else {
                    _skipCount += 1;
//                    _fileName = [[epubItem epubLocalPath] lastPathComponent];
//                    [_transResult setMediaIgnoreCount:([_transResult mediaIgnoreCount] + 1)];
//                    [_transResult recordMediaResult:_fileName resultStatus:TransFailed messageID:(isOutOfSpace == YES ? @"MSG_TranResult_Failed_Device_OutofSpace" : @"IMBTransResult_SuccessAndSkip_Content3")];
                }
            }
            [existedFilePathArr release];
        }
        
        // Pdf电子书的Track构建
        if ([pdfBookArray count] > 0) {
            NSString *bookName = nil;
            NSString *bookPath = nil;
            NSMutableArray *existedFilePathArr = [[NSMutableArray alloc] init];
            for (NSString *pdfItem in pdfBookArray) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    goOn = NO;
                }
                _fileName = [pdfItem lastPathComponent];
                if (goOn) {
                    if (![TempHelper stringIsNilOrEmpty:_fileName]) {
                        NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"ImportSync_id_3", nil),_fileName];
                        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                            [_transferDelegate transferFile:msgStr];
                        }
                    }
                    if ([_fileManager fileExistsAtPath:pdfItem]) {
                        [self generateiBookName:&bookName bookPath:&bookPath extenion:@"pdf"];
                        IMBNewTrack *newTrack = [[IMBNewTrack alloc] init];
                        [newTrack setArtist:@""];
                        [newTrack setAlbumArtist:@""];
                        [newTrack setTitle:[pdfItem lastPathComponent]];
                        [newTrack setFilePath:pdfItem];
                        [newTrack setIsVideo:NO];
                        [newTrack setDBMediaType:PDFBooks];
                        [newTrack setBookFileName:bookName];
                        newTrack.fileSize= (uint)[[_fileManager attributesOfItemAtPath:pdfItem error:nil] fileSize];
                       // [self calculateItemSize:pdfItem];
                        IMBTrack *track = nil;
                        @try {
                            track = [_listTrack addTrack:newTrack copyToDevice:NO cacuTotalSize:_totalSize];
//                            while ([existedFilePathArr containsObject:track.filePath] || track.dbID == maxID) {
//                                [[iPod tracks] removeTrack:track];
//                                [self minusFolderSizeFormTotalSize:pdfItem];
//                                track = [[iPod tracks] addTrack:newTrack copyToDevice:NO cacuTotalSize:_transTotalSize];
//                            }
                            _maxID = track.dbID;
                            [existedFilePathArr addObject:track.filePath];
                        }
                        @catch (NSException *exception) {
                            if ([[exception name] isEqualToString:@"EX_OutOfDiskSpace"]) {
                                NSString *msgStr = CustomLocalizedString(@"MSG_TranResult_Failed_Device_OutofSpace", nil);
                                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                    [_transferDelegate transferFile:msgStr];
                                }
                                goOn = NO;
                                isOutOfSpace = YES;
                                break;
                            } else if ([[exception name] isEqualToString:@"EX_Track_Already_Exists"]) {
                                if (![TempHelper stringIsNilOrEmpty:_fileName]) {
                                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_TranResult_Skiped_Existed", nil),_fileName];
                                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                        [_transferDelegate transferFile:msgStr];
                                    }
                                }
                                continue;
                            } else {
                                NSString *msgStr = CustomLocalizedString(@"ImportSync_id_14", nil);
                                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                                    [_transferDelegate transferFile:msgStr];
                                }
                                continue;
                            }
                        }
                        [track setPackageHash:[self getFileMd5Hash:track.srcFilePath]];
                        [track setMediaType:PDFBooks];
                        _totalSize += track.fileSize;
                        [completedBookArray addObject:track];
                        [newTrack release];
                        
//                        _progressCounter.prepareAnalysisSuccessCount ++;
//                        BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                        if (isOutOfCount) {
//                            break;
//                        }
                        
                    }
                } else {
//                    _ignoreCount += 1;
//                    _fileName = [pdfItem lastPathComponent];
//                    [_transResult setMediaIgnoreCount:([_transResult mediaIgnoreCount] + 1)];
//                    [_transResult recordMediaResult:_fileName resultStatus:TransFailed messageID:(isOutOfSpace == YES ? @"MSG_TranResult_Failed_Device_OutofSpace" :@"MSG_TranResult_Cancelled")];
                }
            }
            [existedFilePathArr release];
        }
        [extractInfoArray release];
    }
    return [completedBookArray autorelease];
}

- (BOOL)importBookToDevice:(IMBTrack *)completedBook desPath:(NSString *)despath{
    [_loghandle writeInfoLog:@"importBookToDevice in importBooksImport entered"];
    BOOL reslut = NO;
    if (completedBook != nil) {
        if (!_isStop) {
            if (completedBook.mediaType == Books) {
                if ([_fileManager fileExistsAtPath:completedBook.srcFilePath]) {
                    if ([IMBAirSyncImportTransfer checkIosIsHighVersion:_ipod]) {
                        if (![_ipod.fileSystem fileExistsAtPath:despath]) {
                            [_ipod.fileSystem mkDir:despath];
                        }
                        [self copyEpubBookWithPath:completedBook.srcFilePath toDevicePath:despath];
                        reslut = YES;
                    }
                    else{
                        reslut = [self copyLocalFile:completedBook.srcFilePath toRemoteFile:despath];
                    }
                    NSString *filePathInDevice = [despath lastPathComponent];
                    if ([filePathInDevice rangeOfString:@".epub"].location == NSNotFound) {
                        filePathInDevice = [filePathInDevice stringByAppendingString:@".epub"];
                    }
                    completedBook.filePath = [completedBook.filePath stringByReplacingOccurrencesOfString:completedBook.filePath.lastPathComponent withString:filePathInDevice];
                }
            } else if (completedBook.mediaType == PDFBooks) {
                @try {
                    if ([_fileManager fileExistsAtPath:completedBook.srcFilePath]) {
                        reslut = [self copyLocalFile:completedBook.srcFilePath toRemoteFile:despath];
                        NSString *filePathInDevice = [despath lastPathComponent];
                        if ([filePathInDevice rangeOfString:@".pdf"].location == NSNotFound) {
                            filePathInDevice = [filePathInDevice stringByAppendingString:@".pdf"];
                        }
                        completedBook.filePath = [completedBook.filePath stringByReplacingOccurrencesOfString:completedBook.filePath.lastPathComponent withString:filePathInDevice];
                    }
                }
                @catch (NSException *exception) {
                    [_loghandle writeInfoLog:[NSString stringWithFormat:@"IMBAirSyncImportTransfer copy pdf %@",exception]];
                }
            }
        }
    }
    return reslut;
}

- (void)copyEpubBookWithPath:(NSString*)localPath toDevicePath:(NSString*)remotingPath {
    NSArray *tempArray = [_fileManager contentsOfDirectoryAtPath:localPath error:nil];
    if (tempArray != nil && [tempArray count] > 0) {
        NSString *temPath = @"";
        for (NSString *item in tempArray) {
            if (_isStop) {
                break;
            }
            temPath = [localPath stringByAppendingPathComponent:item];
            NSDictionary *fileInfoDic = [_fileManager attributesOfItemAtPath:temPath error:nil];
            if (fileInfoDic != nil && [fileInfoDic count] > 0) {
                NSString *fileType = [fileInfoDic objectForKey:NSFileType];
                if ([NSFileTypeRegular isEqualToString:fileType]) {
                    NSString *remotingFilePath = [remotingPath stringByAppendingPathComponent:item];
                    @try {
                        [self copyLocalFile:temPath toRemoteFile:remotingFilePath];
                    }
                    @catch (NSException *exception) {
                        [_loghandle writeInfoLog:[NSString stringWithFormat:@"IMBAirSyncImportTransfer NSFileTypeRegular copy epub %@",exception]];
                    }
                } else if ([NSFileTypeDirectory isEqualToString:fileType]) {
                    NSString *newRemotingPath = nil;
                    newRemotingPath = [remotingPath stringByAppendingPathComponent:item];
                    @try {
                        if (![[_ipod fileSystem] fileExistsAtPath:newRemotingPath]) {
                            [[_ipod fileSystem] mkDir:newRemotingPath];
                        }
                        [self copyEpubBookWithPath:temPath toDevicePath:newRemotingPath];
                    }
                    @catch (NSException *exception) {
                        [_loghandle writeInfoLog:[NSString stringWithFormat:@"IMBAirSyncImportTransfer NSFileTypeDirectory copy epub %@",exception]];
                    }
                }
            }
        }
    }
}

- (NSString *)getFileMd5Hash:(NSString *)path{
    if (![_fileManager fileExistsAtPath:path]) {
        NSLog(@"no file was found");
        return @"";
    }
    else{
        NSData *data = [NSData dataWithContentsOfFile:path];
        //        NSString *fileString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSError *error = nil;
        if (error != nil) {
            NSLog(@"error:%@",error);
            return @"";
        }
        else{
            NSString *md5 = [[NSString MD5FromData:data] uppercaseString];
            return md5;
        }
    }
}

- (void)extractingFile:(NSArray*)epubBookArray extractInfoArray:(NSMutableArray*)extractInfoArray {
    if ([epubBookArray count] > 0) {
        NSString *filePath = nil;
        NSString *fileName = nil;
        NSString *folderCachePath = nil;
        int epubCount = [epubBookArray count];
        for (int i = 0; i < epubCount; i++) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            NSString *defaultBookLocalFolderPath = [[[_ipod session] sessionFolderPath] stringByAppendingPathComponent:@"Book"];
            filePath = [epubBookArray objectAtIndex:i];
            fileName = [[filePath lastPathComponent] stringByDeletingPathExtension];
            if (![_fileManager fileExistsAtPath:defaultBookLocalFolderPath]) {
                [_fileManager createDirectoryAtPath:defaultBookLocalFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            folderCachePath = [defaultBookLocalFolderPath stringByAppendingPathComponent:fileName];
            @try {
                [IMBZipHelper unZipByAll:filePath decFolderPath:defaultBookLocalFolderPath];
            }
            @catch (NSException *exception) {
                [_loghandle writeInfoLog:[NSString stringWithFormat:@"Unzip failed, reason is %@", exception.reason]];
            }
            IMBEpubBookInfo *epubInfo = [[IMBEpubBookInfo alloc] init];
            [epubInfo setExtractFolderPath:folderCachePath];
            [epubInfo setEpubLocalPath:filePath];
            [epubInfo setBookName:[filePath lastPathComponent]];
            [extractInfoArray addObject:epubInfo];
            [epubInfo release];
            epubInfo = nil;
        }
    }
}

- (NSDictionary*)getBookInfo:(NSString*)extractFolderPath bookName:(NSString**)bookName bookPath:(NSString**)bookPath extenion:(NSString*)extenion{
    *bookName = nil;
    NSString *plistPath = [extractFolderPath stringByAppendingPathComponent:@"iTunesMetadata.plist"];
    NSDictionary *plistDic = nil;
    if ([_fileManager fileExistsAtPath:plistPath]) {
        plistDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        if (plistDic != nil && [plistDic count] > 0) {
            if ([[plistDic allKeys] containsObject:@"title"]) {
                *bookName = [plistDic valueForKey:@"title"];
                if (![StringHelper stringIsNilOrEmpty:*bookName]) {
                    *bookName = [*bookName stringByAppendingPathExtension:extenion];
                }
            }
            if ([StringHelper stringIsNilOrEmpty:*bookName]) {
                *bookName = [[[extractFolderPath pathComponents] lastObject] stringByAppendingPathExtension:extenion];
            }
        } else {
            *bookName = [[[extractFolderPath pathComponents] lastObject] stringByAppendingPathExtension:extenion];
        }
        *bookPath = [[[[_ipod fileSystem] driveLetter] stringByAppendingPathComponent:@"Books"] stringByAppendingPathComponent:*bookName];
    } else {
        *bookName = [[[extractFolderPath pathComponents] lastObject] stringByAppendingPathExtension:extenion];
        plistDic = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"", @"artistName",
                    @"", @"genre",
                    *bookName, @"title"
                    , nil];
        *bookPath = [[[[_ipod fileSystem] driveLetter] stringByAppendingPathComponent:@"Books"] stringByAppendingPathComponent:*bookName];
    }
    return plistDic;
}

//创建book的track对象
- (IMBNewTrack*)createTrack:(NSDictionary*)bookInfoDic bookFilePath:(NSString*)bookFilePath bookName:(NSString*)bookName {
    IMBNewTrack *newTrack = [[[IMBNewTrack alloc] init] autorelease];
    [newTrack setArtist:[self getDicValueByKey:bookInfoDic key:@"artistName"]];
    [newTrack setGenre:[self getDicValueByKey:bookInfoDic key:@"genre"]];
    [newTrack setAlbumArtist:[self getDicValueByKey:bookInfoDic key:@"title"]];
    [newTrack setTitle:bookName];
    [newTrack setFilePath:bookFilePath];
    [newTrack setIsVideo:NO];
    [newTrack setDBMediaType:Books];
    [newTrack setBookFileName:bookName];
    newTrack.fileSize= (uint)[[_fileManager attributesOfItemAtPath:bookFilePath error:nil] fileSize];
    return newTrack;
}

- (id)getDicValueByKey:(NSDictionary*)bookInfo key:(NSString*)key {
    id keyValue = nil;
    if ([key isEqualToString:@"package-file-hash"]) {
        if ([[bookInfo allKeys] containsObject:@"book-info"]) {
            keyValue = [self getBookinfoElement:bookInfo key:key];
        }
    } else if ([key isEqualToString:@"publisher-unique-id"]) {
        keyValue = [self getBookinfoElement:bookInfo key:key];
    } else if ([key isEqualToString:@"unique-id"]) {
        keyValue = [self getBookinfoElement:bookInfo key:key];
    } else {
        if ([[bookInfo allKeys] containsObject:key]) {
            keyValue = [bookInfo objectForKey:key];
        } else {
            keyValue = @"unknown";
        }
    }
    return keyValue;
}

- (id)getBookinfoElement:(NSDictionary*)bookInfo key:(NSString*)key {
    id elementValue = nil;
    if ([[bookInfo allKeys] containsObject:@"book-info"]) {
        NSDictionary *infoDic = [bookInfo objectForKey:@"book-info"];
        if ([[infoDic allKeys] containsObject:key]) {
            elementValue = [infoDic objectForKey:key];
        }
    }
    return elementValue;
}

- (void) generateiBookName:(NSString**)bookName bookPath:(NSString**)bookPath extenion:(NSString*)extenion {
    NSString *randomName = [[MediaHelper getRandomBookName] stringByAppendingPathExtension:extenion];
    NSString *filePath = [[[[_ipod fileSystem] driveLetter] stringByAppendingPathComponent:@"Books"] stringByAppendingPathComponent:randomName];
    if (![[_ipod fileSystem] fileExistsAtPath:filePath]) {
        *bookName = randomName;
        *bookPath = filePath;
    } else {
        [self generateiBookName:&*bookName bookPath:&*bookPath extenion:extenion];
    }
}

#pragma mark - photo处理方法 创建photo的track对象
//创建导入图片的Info
- (NSMutableArray *)createImportImageInfo:(NSArray *)array {
    //得到最大photo的uuid
    IMBCreatePhotoSyncPlist *cp = [[IMBCreatePhotoSyncPlist alloc] initWithiPod:_ipod];
    NSData *maxUUID = [cp getMaxZ_PKUUID];
    Byte bit[maxUUID.length];
    [maxUUID getBytes:bit length:maxUUID.length];
    int int16last = bit[maxUUID.length - 1]&0xff;
    int int16 = bit[maxUUID.length - 2]&0xff;
    [cp release];
    
    NSMutableArray *uuidArray = [[[NSMutableArray alloc] init] autorelease];
    //得到uuid形如00000000-0000-0000-0000-000000000000，并依次递增
    NSString *uuid = nil;
    for (int idx=0; idx<array.count; idx++) {
        @autoreleasepool {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop == NO) {
                NSString *path = [array objectAtIndex:idx];
                if (![TempHelper stringIsNilOrEmpty:path]) {
                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"ImportSync_id_3", nil),[path lastPathComponent]];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
                
                long long photoSize = [SystemHelper folderOrfileSize:path];
                PrepareStatus status = [self checkFileSizeIsOutOfSpace:photoSize fileName:[path lastPathComponent]];
                if (status == OutOfSpace) {
                    NSString *msgStr = CustomLocalizedString(@"MSG_TranResult_Failed_Device_OutofSpace", nil);
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                    break;
                }
                else if(status == AlreadyExisted){
                    if (![TempHelper stringIsNilOrEmpty:path]) {
                        NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_TranResult_Skiped_Existed", nil),[path lastPathComponent]];
                        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                            [_transferDelegate transferFile:msgStr];
                        }
                    }
                    continue;
                }
                else if(status == FileErrorUnknown){
                    NSString *msgStr = CustomLocalizedString(@"ImportSync_id_14", nil);
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                    continue;
                }
                
                IMBSyncPhotoData *pd = [[IMBSyncPhotoData alloc] init];
                int16last += 1;
                if (int16last == 0x100) {
                    int16 = int16 + 1;
                    int16last = 0x00;
                }
                NSString *hexStr = @"";
                for (int idu=0; idu<maxUUID.length-2; idu++) {
                    NSString *newHexStr = [NSString stringWithFormat:@"%x",bit[idu]&0xff];
                    if ([newHexStr length] == 1) {
                        hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
                    }else{
                        hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
                    }
                }
                NSString *newStr = [NSString stringWithFormat:@"%x",int16];
                if ([newStr length] == 1) {
                    hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newStr];
                }else{
                    hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newStr];
                }
                NSString *newStr1 = [NSString stringWithFormat:@"%x",int16last];
                if ([newStr1 length] == 1) {
                    hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newStr1];
                }else{
                    hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newStr1];
                }
                uuid = [MediaHelper createPhotoUUID:hexStr];
                pd.photoUUID = uuid;
                pd.photoName = path;
                
                //按当前时间导入图片
                NSDate *now = [NSDate date];
                uint64 timeStamp = (uint64)[DateHelper getTimeStampFromDate:now];
                pd.photoDate = timeStamp - array.count - 10 + idx;
                NSString *photoAlbumName = nil;
                NSArray *albumArr = [path pathComponents];
                if (albumArr.count > 1) {
                    photoAlbumName = [albumArr objectAtIndex:albumArr.count - 2];
                }
//            //按图片创建时间导入设备
//            NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[IMBHelper fileCreateTimeAtPath:path]];
//            pd.photoDate = [IMBHelper getTimeStampFromDate:date] + idx;
//            [date release];
                
                NSString *fileName = nil;
                fileName = [[pd.photoName pathComponents] lastObject];
                IMBTrack *tracks = [[IMBTrack alloc] init];
                [tracks setDateAdded:(uint)pd.photoDate];
                [tracks setPhotoFilePath:pd.photoName];
                [tracks setSrcFilePath:pd.photoName];
                [tracks setFilePath:pd.photoName];
                [tracks setFileSize:(uint)photoSize];
                [tracks setMediaType:Photo];
                [tracks setPhotoAlbumName:photoAlbumName];
                [tracks setTitle:fileName];
                [tracks setDbID:pd.photoUUID];
                [tracks setUuid:pd.photoUUID];
                _totalSize += tracks.fileSize;
                [uuidArray addObject:tracks];
                [tracks release];
                [pd release];
                
//                _progressCounter.prepareAnalysisSuccessCount ++;
//                // ToDo 判断未注册的设备是否允许还能继续导入
//                BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                if (isOutOfCount) {
//                    break;
//                }
                
            } else {
//                _ignoreCount += 1;
//                fileName = [[pd.photoName pathComponents] lastObject];
//                [_transResult setMediaIgnoreCount:([_transResult mediaIgnoreCount] + 1)];
//                [_transResult recordMediaResult:fileName resultStatus:TransFailed messageID:@"IMBTransResult_SuccessAndSkip_Content3"];
            }
        }
    }
    if (uuid != nil) {
        if (_maxUUIDStr) {
            [_maxUUIDStr release];
            _maxUUIDStr = nil;
        }
        _maxUUIDStr = [uuid retain];
    }
    return uuidArray;
}

- (PrepareStatus)checkFileSizeIsOutOfSpace:(long long)size fileName:(NSString *)fileName {
    PrepareStatus status = Normal;
    @try {
        [_listTrack setFreespace:_listTrack.freespace - size];
        if (_listTrack.freespace <= 10000000) {//设备空间小于10M
            NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:[[_ipod deviceHandle] deviceName], @"DeviceName", nil];
            @throw [NSException exceptionWithName:@"EX_OutOfDiskSpace" reason:CustomLocalizedString(@"MSG_TranResult_Failed_Device_OutofSpace", nil)  userInfo:userDic];
        }
    }
    @catch (NSException *exception) {
        [_loghandle writeInfoLog:[NSString stringWithFormat:@"parepareTrack in importBooksImport error:%@",exception.description]];
        
        if ([[exception name] isEqualToString:@"EX_OutOfDiskSpace"]) {
            status = OutOfSpace;
        } else if ([[exception name] isEqualToString:@"EX_Track_Already_Exists"]) {
            status = AlreadyExisted;
        } else {
            status = FileErrorUnknown;
        }
    }
    return status;
}

#pragma mark - application处理方法 创建IMBAppSyncModel 对象
- (NSArray *)prepareApplicationWithArray:(NSArray *)array{
    [_loghandle writeInfoLog:[NSString stringWithFormat:@"prepareTrack in ApplicationImport entered"]];
    IMBApplicationManager *applicationManager = [[IMBApplicationManager alloc] initWithiPod:_ipod];
    NSMutableArray *appArr = [NSMutableArray array];
    
    NSString *appTmpPath = [_ipod.session.sessionFolderPath stringByAppendingPathComponent:@"Application"];
    if ([_fileManager fileExistsAtPath:appTmpPath]) {
        [_fileManager removeItemAtPath:appTmpPath error:nil];
    }
    if (array.count > 0) {
        for (NSString *string in array) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            NSString *path = string;
            if (![TempHelper stringIsNilOrEmpty:path]) {
                NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"ImportSync_id_3", nil),[path lastPathComponent]];
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:msgStr];
                }
            }
           
            NSString *cachePath = [MediaHelper getAppCachePathInIpod:_ipod];
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
            [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
            NSString *fileName = [dateFormater stringFromDate:[NSDate date]];
            cachePath = [cachePath stringByAppendingPathComponent:fileName];
            if (![_fileManager fileExistsAtPath:cachePath]){
                [_fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [dateFormater release];
            IMBAppEntity *entity = [applicationManager getAppInfoAndCopySyncFileToLocal:path withAppTempPath:cachePath];
            if(entity == nil){
                continue;
            }
            NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            entity.appSize = [[dictionary objectForKey:NSFileSize] unsignedLongLongValue];
            PrepareStatus status = [self checkFileSizeIsOutOfSpace:entity.appSize fileName:entity.appName];
            if (status == OutOfSpace) {
                NSString *msgStr = CustomLocalizedString(@"MSG_TranResult_Failed_Device_OutofSpace", nil);
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:msgStr];
                }
                break;
            }
            else if(status == AlreadyExisted){
                if (![TempHelper stringIsNilOrEmpty:[path lastPathComponent]]) {
                    NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_TranResult_Skiped_Existed", nil),[path lastPathComponent]];
                    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transferDelegate transferFile:msgStr];
                    }
                }
                continue;
            }
            else if(status == FileErrorUnknown){
                NSString *msgStr = CustomLocalizedString(@"ImportSync_id_14", nil);
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:msgStr];
                }
                continue;
            }
            
            IMBAppSyncModel *syncModel = [[IMBAppSyncModel alloc] init];
            syncModel.identifier = entity.appKey;
            syncModel.appName = entity.appName;
            syncModel.appVersion = entity.version;
            syncModel.appFilePath = entity.srcFilePath;
            syncModel.appCachePath = cachePath;
            _totalSize += entity.appSize;
            [appArr addObject:entity];
            [syncModel release];
           
//            usleep(200);
//            //判断是否超出将要导入的个数
//            _progressCounter.prepareAnalysisSuccessCount ++;
//            BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//            if (isOutOfCount) {
//                break;
//            }
            
        }
    }
    [applicationManager release];
    applicationManager = nil;
    return appArr;
}

- (void)startTransferApps:(NSArray *)tracks
{
    NSArray *applications = [self filterToTrackArray:tracks isIMBTrack:NO];
    IMBApplicationManager *applicationManager = [[IMBApplicationManager alloc] initWithiPod:_ipod];
    for (IMBAppEntity *app in applications) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            return;
        }
        NSString *filePath = app.srcFilePath;
        if (![TempHelper stringIsNilOrEmpty:app.appName]) {
            NSString *msgStr1 = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),app.appName];
            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transferDelegate transferFile:msgStr1];
            }
        }
        if ([applicationManager InstallApplication:AppTransferType_All LocalFilePath:filePath]) {
            NSLog(@"%@导入成功",[_fileManager displayNameAtPath:filePath]);
            _successCount ++;
        }
        [self sendCopyProgress:app.appSize];
    }
}

#pragma mark - ATHCopyFileToDeviceListener
- (BOOL)copyFileFromSrcPath:(NSString *)srcPath ToDesPath:(NSString *)desPath WithTrack:(IMBTrack *)track WithAssetID:(NSString *)assetID {
    BOOL reslut = NO;
    if (_ipod != nil) {
        if (![TempHelper stringIsNilOrEmpty:srcPath]) {
            NSString *msgStr1 = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),[srcPath lastPathComponent]];
            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transferDelegate transferFile:msgStr1];
            }
        }
        if (track.mediaType == VoiceMemo) {
            reslut = [self copyLocalFile:srcPath toRemoteFile:desPath];
            track.filePath = [NSString stringWithFormat:@"Recordings/%@.m4a",[desPath lastPathComponent]];
            [track setFileIsExist:YES];
        }
        else if(track.mediaType == Books || track.mediaType == PDFBooks){
            if (_ipod != nil) {
                reslut = [self importBookToDevice:track desPath:desPath];
                [track setFileIsExist:YES];
            }
        }
        else{
            reslut = [self copyLocalFile:srcPath toRemoteFile:desPath];
            [track setFileIsExist:YES];
        }
    }
    if (reslut) {
        _successCount ++;
    }
    return reslut;
}

- (BOOL)copyDataFromSrcPath:(NSData *)srcData ToDesPath:(NSString *)desPath WithTrack:(IMBTrack *)track WithAssetID:(NSString *)assetID {
    BOOL reslut = NO;
    if (_ipod != nil) {
        if (![TempHelper stringIsNilOrEmpty:track.title]) {
            NSString *msgStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Copying", nil),track.title];
            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transferDelegate transferFile:msgStr];
            }
        }
        if (srcData != nil) {
//            [_loghandle writeInfoLog:[NSString stringWithFormat:@"Transfering %@ (IMBAirSyncImportTransfer photo)", track.photoFilePath]];
            reslut = [_ipod.fileSystem copyDataToFile:srcData toRemoteFile:desPath];
            [self sendCopyProgress:track.fileSize];
            [track setFileIsExist:YES];
        }
        else{
            [track setFileIsExist:NO];
        }
    }
    if (reslut) {
        _successCount ++;
    }
    return reslut;
}

- (void)completedCopyTrack:(IMBTrack*)track {
    //开始计数
    [_limitation reduceRedmainderCount];
     [_loghandle writeInfoLog:[NSString stringWithFormat:@"File exsit filePath:%@ (IMBAirSyncImportTransfer)",[_ipod.fileSystem.driveLetter stringByAppendingPathComponent:[track filePath]]]];
}

#pragma mark - 重命名相册
-(void)renameAlbum {
    //开始同步
    if (_athSync != nil) {
        [_athSync release];
        _athSync = nil;
    }
    _athSync = [[IMBATHSync alloc] initWithiPod:_ipod syncCtrType:SyncRename photoAlbum:_importPhotoAlbum Rename:_rename];
    [_athSync setListener:self];
    [_athSync setCurrentThread:[NSThread currentThread]];
    
    if ([_athSync createAirSyncService]) { //开启服务 并监听设备
        if ([_athSync sendRequestSync]) { //发送RequestSync 命令
            //创建plist cig
            if ([_athSync createPlistAndCigSendDataSync]) {
//                [_athSync startCopyData];
            }
            //等待同步结束
            [_athSync waitSyncFinished];
        }
    }
    [_loghandle writeInfoLog:@"AirSyncRenameAlbum RenameAlbum complete"];
}

- (void)stopScan {
    [_condition lock];
    _isStop = YES;
    if (_athSync != nil) {
        [_athSync setIsStop:YES];
    }
    if (_mediaConverter != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CANCELPREPAREFILENOTIFICATION object:nil userInfo:nil];
    }
    [_condition signal];
    [_condition unlock];
}

- (void)dealloc {
    if (_maxUUIDStr) {
        [_maxUUIDStr release];
        _maxUUIDStr = nil;
    }
    [_transferDic release],_transferDic = nil;
    [_importFilePath release],_importFilePath = nil;
    [_toConvertFiles release],_toConvertFiles = nil;
    [_toConvertCategoryEnums release],_toConvertCategoryEnums = nil;
    [_importFiles release],_importFiles = nil;
    [_importcategoryNodes release],_importcategoryNodes = nil;
    [_importPhotoAlbum release],_importPhotoAlbum = nil;
    [_plistItem release],_plistItem = nil;
    [_specificPlistName release],_specificPlistName = nil;
    [_specificPlistNamses release],_specificPlistNamses = nil;
    [_athSync release];_athSync = nil;
    [_rename release];_rename = nil;
    [_listTrack release];_listTrack = nil;
    [super dealloc];
}
@end
