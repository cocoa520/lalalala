//
//  IMBPhotoManager.m
//  iMobieTrans
//
//  Created by iMobie on 14-3-5.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBPhotoManager.h"
#import "StringHelper.h"
#import "DateHelper.h"
#import "IMBSession.h"
#import "IMBFileSystem.h"
#import "IMBDeviceInfo.h"
#import "NSString+Category.h"
//#import "IMBBackupManager.h"
#define Photosqlite        @"PhotoData/Photos.sqlite"
#define Photosqliteshm     @"PhotoData/Photos.sqlite-shm"
#define Photosqlitewal     @"PhotoData/Photos.sqlite-wal"

@implementation IMBPhotoManager
@synthesize isiCloudPhoto = _isiCloudPhoto;

- (id)initWithAMDevice:(AMDevice *)dev {
    self = [super init];
    if (self) {
        _device = [dev retain];
        _logManger = [IMBLogManager singleton];
        fm = [NSFileManager defaultManager];
        _iOSVersion = [_device.productVersion retain];
        //现将数据库拷贝到临时目录
        NSString *filePath = [self copySqliteToTemp];
        _databaseConnection = [[FMDatabase alloc] initWithPath:filePath];
    }
    return self;
}

//- (id)initWithAMDevice:(AMDevice *)dev backupfilePath:(NSString *)backupfilePath  withDBType:(NSString *)type WithisEncrypted:(BOOL)isEncrypted withBackUpDecrypt:(IMBBackupDecrypt*)decypt {
//    if ([super initWithAMDevice:dev backupfilePath:backupfilePath withDBType:type WithisEncrypted:isEncrypted withBackUpDecrypt:decypt]) {
//        _isBackup = YES;
//        
//        _backUpPath = backupfilePath;
//        IMBBackupManager *manager = [IMBBackupManager shareInstance];
//        manager.iosVersion = type;
//        NSString *sqliteStr = nil;
//        if (isEncrypted) {
//            [_logManger writeInfoLog:@"Photo Encrypted"];
//            [decypt decryptDomainFile:@"CameraRollDomain"];
//            [decypt decryptSingleFile:@"HomeDomain" withFilePath:@"Media/PhotoStreamsData"];
//            manager.backUpPath = decypt.outputPath;
//            _backUpPath = decypt.outputPath;
//        }
//        sqliteStr = @"Media/PhotoData/Photos.sqlite";
//        NSString *sqliteddPath = [manager copysqliteImageToApptempWithsqliteName:sqliteStr backupfilePath:_backUpPath];
//        if (sqliteddPath != nil) {
//            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
//        }
//        _photoDataAry = [[NSMutableArray alloc]init];
//    }
//    return self;
//}

//-(id)initWithiCloudBackup:(IMBiCloudBackup *)iCloudBackup withType:(NSString *)type{
//    if ([super initWithiCloudBackup:iCloudBackup withType:type]) {
//        //遍历需要的文件，然后拷贝到指定的目录下
//        _isicloud = YES;
//        _isBackup = YES;
//        NSString *_dbPath = nil;
//        if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"9"]) {
//            _dbPath = [[iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"CameraRollDomain/Media/PhotoData/Photos.sqlite"] retain];
// 
//        }else{
//            NSString *sqlPath = [TempHelper getSoftwareBackupFolderPath:@"iCloud" withUuid:iCloudBackup.uuid];
//            NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"CameraRollDomain", @"Media/PhotoData/Photos.sqlite"];
//            //遍历需要的文件，然后拷贝到指定的目录下
//            NSArray *tmpArray = [_iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
//            IMBiCloudFileInfo *photosFile = nil;
//            if (tmpArray != nil && tmpArray.count > 0) {
//                photosFile = [tmpArray objectAtIndex:0];
//            }
//            if (photosFile != nil) {
//                NSString *dbPPath = @""; //= [_iCloudBackup.downloadFolderPath stringByAppendingPathComponent:photosFile.fileName];
//                NSString *filePath  = @"";//= [sqlPath stringByAppendingPathComponent:photosFile.fileName];
//                if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"10"]) {
//                    NSString *fd = @"";
//                    if (photosFile.fileName.length > 2) {
//                        fd = [photosFile.fileName substringWithRange:NSMakeRange(0, 2)];
//                    }
//                    dbPPath = [_iCloudBackup.downloadFolderPath stringByAppendingPathComponent:photosFile.fileName];
//                    filePath = [[sqlPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:photosFile.fileName];
//                }else{
//                    dbPPath = [_iCloudBackup.downloadFolderPath stringByAppendingPathComponent:photosFile.fileName];
//                    filePath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:photosFile.fileName];
//                }
//                
//                if ([fm fileExistsAtPath:filePath]) {
//                    [fm removeItemAtPath:filePath error:nil];
//                }
//                if ([fm fileExistsAtPath:dbPPath]) {
//                    [fm copyItemAtPath:dbPPath toPath:filePath error:nil];
//                }
//                _dbPath = [filePath retain];
//            }
//        }
//        if (_dbPath != nil) {
//            _databaseConnection = [[FMDatabase alloc] initWithPath:_dbPath];
//            [_dbPath release];
//        }
//    }
//    return self;
//}

- (id)initWithiPod:(IMBiPod *)iPod {
    self = [super init];
    if (self) {
        _isHaveCameraRollAlbum = NO;
        _ipod = [iPod retain];
        _device = [iPod.deviceHandle retain];
        _logManger = [IMBLogManager singleton];
        fm = [NSFileManager defaultManager];
        _iOSVersion = [_ipod.deviceInfo.productVersion retain];
        //现将数据库拷贝到临时目录
        NSString *filePath = [self copySqliteToTemp];
        _databaseConnection = [[FMDatabase alloc] initWithPath:filePath];
    }
    return self;
}

- (id)initVersion:(NSString *)iosVersion{
    self = [super init];
    if (self) {
//        logHandle = [IMBLogManager singleton];
        fm = [NSFileManager defaultManager];
        _iOSVersion = [iosVersion retain];
    }
    return self;
}


- (NSString *)copySqliteToTemp {
    NSString *filePath = nil;
    //将数据库拷贝指定的路径
    if ([_ipod.fileSystem fileExistsAtPath:Photosqlite]) {
        
        filePath = [[_ipod.session sessionFolderPath] stringByAppendingPathComponent:@"Photos.sqlite"];
        
        if ([fm fileExistsAtPath:filePath]) {
            [fm removeItemAtPath:filePath error:nil];
        }
        
        BOOL issuccess = [_ipod.fileSystem copyRemoteFile:Photosqlite toLocalFile:filePath];
        if (issuccess) {
            if ([_ipod.fileSystem fileExistsAtPath:Photosqliteshm]) {
                
                NSString *filePath = [[_ipod.session sessionFolderPath] stringByAppendingPathComponent:@"Photos.sqlite-shm"];
                if ([fm fileExistsAtPath:filePath]) {
                    [fm removeItemAtPath:filePath error:nil];
                }
                [_ipod.fileSystem copyRemoteFile:Photosqliteshm toLocalFile:filePath];
            }
            if ([_ipod.fileSystem fileExistsAtPath:Photosqlitewal]) {
                
                NSString *filePath = [[_ipod.session sessionFolderPath] stringByAppendingPathComponent:@"Photos.sqlite-wal"];
                if ([fm fileExistsAtPath:filePath]) {
                    [fm removeItemAtPath:filePath error:nil];
                }
                [_ipod.fileSystem copyRemoteFile:Photosqlitewal toLocalFile:filePath];
                
                
            }
        }
    }
    return filePath;
    
}

- (NSMutableArray *)getAlbumsInfo {
    [_logManger writeInfoLog:@"Begin query AlbumsInfo"];
    _isiCloudPhoto = NO;
    NSMutableArray *lItmes = [[[NSMutableArray alloc] init] autorelease];
    NSString *string = nil;

    string = @"select Z_PK,ZKIND,ZCACHEDPHOTOSCOUNT,ZCACHEDVIDEOSCOUNT,ZTITLE,ZUUID FROM ZGENERICALBUM where zkind in (1000,1500,1505,1552,2,1550)";


    if ([self openDataBase]) {
        FMResultSet *rs = [_databaseConnection executeQuery:string];
        IMBPhotoEntity *entity = nil;
        while ([rs next]) {
            entity = [[IMBPhotoEntity alloc] init];
            if (![rs columnIsNull:@"Z_PK"]) {
                entity.albumZpk = [rs intForColumn:@"Z_PK"];
            }
            if (![rs columnIsNull:@"ZKIND"]) {
                entity.albumKind = [rs intForColumn:@"ZKIND"];
            }
            if (![rs columnIsNull:@"ZUUID"]) {
                if ([_iOSVersion isVersionMajorEqual:@"8"]) {
                    entity.albumUUIDString = [rs stringForColumn:@"ZUUID"];
                }else {
                    entity.albumUUID = [rs dataForColumn:@"ZUUID"];
//                    entity.albumUUIDString = [StringHelper NSDatatoNSString:entity.albumUUID];
                }
            }
            switch (entity.albumKind) {
                case 1000:
                    _isHaveCameraRollAlbum = YES;
                    entity.albumType = CameraRoll;
                    entity.albumSubType = OtherType;
//                    entity.albumTitle = CustomLocalizedString(@"MenuItem_id_10", nil);
                    break;
                case 1500:
                    entity.albumType = PhotoStream;
//                    entity.albumTitle = CustomLocalizedString(@"MenuItem_id_11", nil);
                    break;
                case 1505:
                    entity.albumType = PhotoShare;
                    if (![rs columnIsNull:@"ZTITLE"]) {
                        entity.albumTitle = [rs stringForColumn:@"ZTITLE"];
                    }else {
                        entity.albumTitle = @"";
                    }
                    break;
                case 1501:
                    entity.albumType = WallPaper;
//                    entity.albumTitle = CustomLocalizedString(@"MenuItem_id_68", nil);
                    break;
                case 1552:
                    entity.albumType = PhotoLibrary;
//                    entity.albumTitle = CustomLocalizedString(@"MenuItem_id_12", nil);
                    break;
                case 1550:
                    entity.albumType = SyncAlbum;
                    if (![rs columnIsNull:@"ZTITLE"]) {
                        entity.albumTitle = [rs stringForColumn:@"ZTITLE"];
                    }else {
                        entity.albumTitle = @"";
                    }
                    break;
                case 2:
                    entity.albumType = CreateAlbum;
                    if (![rs columnIsNull:@"ZTITLE"]) {
                        entity.albumTitle = [rs stringForColumn:@"ZTITLE"];
                    }else {
                        entity.albumTitle = @"";
                    }
                    break;
                default:
                    entity.albumType = OtherAlbum;
                    break;
            }
            [lItmes addObject:entity];
            [entity release];
            entity = nil;
        }
        [rs close];
        [self closeDataBase];
    }
    
    if (!_isHaveCameraRollAlbum) {//如果数据库中没有cameraRoll相册，就自己创建
        IMBPhotoEntity *cameraRoll = [[IMBPhotoEntity alloc] init];
        cameraRoll.albumType = CameraRoll;
//        cameraRoll.albumTitle = CustomLocalizedString(@"MenuItem_id_10", nil);
        cameraRoll.albumZpk = 1000;
        cameraRoll.albumKind = 1000;
        cameraRoll.albumSubType = OtherType;
        [lItmes addObject:cameraRoll];
        [cameraRoll release];
    }
    
    IMBPhotoEntity *vAlbum = [[IMBPhotoEntity alloc] init];
    vAlbum.albumType = VideoAlbum;
//    vAlbum.albumTitle = CustomLocalizedString(@"MenuItem_id_24", nil);
    vAlbum.albumZpk = -1;
    vAlbum.albumKind = -1;
    vAlbum.albumSubType = OtherType;
    [lItmes addObject:vAlbum];
    [vAlbum release];
    
    if ([_iOSVersion isVersionMajorEqual:@"7"]) {
        if ([_iOSVersion isVersionMajorEqual:@"8"]) {
            IMBPhotoEntity *timelapseAlbum = [[IMBPhotoEntity alloc] init];
            timelapseAlbum.albumType = VideoAlbum;
//            timelapseAlbum.albumTitle = CustomLocalizedString(@"MenuItem_id_48", nil);
            timelapseAlbum.albumZpk = -1;
            timelapseAlbum.albumKind = -1;
            timelapseAlbum.albumSubType = TimeLapse;
            [lItmes addObject:timelapseAlbum];
            [timelapseAlbum release];
            
            IMBPhotoEntity *slowMoveAlbum = [[IMBPhotoEntity alloc] init];
            slowMoveAlbum.albumType = VideoAlbum;
//            slowMoveAlbum.albumTitle = CustomLocalizedString(@"MenuItem_id_51", nil);
            slowMoveAlbum.albumZpk = -1;
            slowMoveAlbum.albumKind = -1;
            slowMoveAlbum.albumSubType = SlowMove;
            [lItmes addObject:slowMoveAlbum];
            [slowMoveAlbum release];
        }
        
        IMBPhotoEntity *panoramasAlbum = [[IMBPhotoEntity alloc] init];
        panoramasAlbum.albumType = CameraRoll;
//        panoramasAlbum.albumTitle = CustomLocalizedString(@"MenuItem_id_49", nil);
        for (IMBPhotoEntity *entity in lItmes) {
            if (entity.albumType == CameraRoll) {
                panoramasAlbum.albumZpk = entity.albumZpk;
                break;
            }
        }
        
        panoramasAlbum.albumKind = 1000;
        panoramasAlbum.albumSubType = Panoramas;
        [lItmes addObject:panoramasAlbum];
        [panoramasAlbum release];
    }
    
    //设备自己分出来的相册
    IMBPhotoEntity *livePhoto = [[IMBPhotoEntity alloc] init];
    livePhoto.albumType = LivePhoto;
//    livePhoto.albumTitle = CustomLocalizedString(@"MenuItem_id_63", nil);
    livePhoto.albumZpk = -70;
    livePhoto.albumKind = -70;
    livePhoto.albumSubType = OtherType;
    [lItmes addObject:livePhoto];
    [livePhoto release];
    
    IMBPhotoEntity *photoScreenshot = [[IMBPhotoEntity alloc] init];
    photoScreenshot.albumType = Screenshot;
//    photoScreenshot.albumTitle = CustomLocalizedString(@"MenuItem_id_64", nil);
    photoScreenshot.albumZpk = -80;
    photoScreenshot.albumKind = -80;
    photoScreenshot.albumSubType = OtherType;
    [lItmes addObject:photoScreenshot];
    [photoScreenshot release];
    
    IMBPhotoEntity *photoSelfies = [[IMBPhotoEntity alloc] init];
    photoSelfies.albumType = PhotoSelfies;
//    photoSelfies.albumTitle = CustomLocalizedString(@"MenuItem_id_65", nil);
    photoSelfies.albumZpk = -90;
    photoSelfies.albumKind = -90;
    photoSelfies.albumSubType = OtherType;
    [lItmes addObject:photoSelfies];
    [photoSelfies release];
    
    IMBPhotoEntity *photoLocation = [[IMBPhotoEntity alloc] init];
    photoLocation.albumType = Location;
//    photoLocation.albumTitle = CustomLocalizedString(@"MenuItem_id_66", nil);
    photoLocation.albumZpk = -100;
    photoLocation.albumKind = -100;
    photoLocation.albumSubType = OtherType;
    [lItmes addObject:photoLocation];
    [photoLocation release];
    
    IMBPhotoEntity *photoFavorite = [[IMBPhotoEntity alloc] init];
    photoFavorite.albumType = Favorite;
//    photoFavorite.albumTitle = CustomLocalizedString(@"MenuItem_id_67", nil);
    photoFavorite.albumZpk = -110;
    photoFavorite.albumKind = -110;
    photoFavorite.albumSubType = OtherType;
    [lItmes addObject:photoFavorite];
    [photoFavorite release];
    
    [_logManger writeInfoLog:@"end query AlbumInfo"];
    return lItmes;
}

- (NSMutableArray *)getContinuousShootingAlbum
{
    NSMutableArray *array = [NSMutableArray array];
    if ([self openDataBase]) {
        int i = 10;
        NSString *sql = @"select ZAVALANCHEUUID,ZDATECREATED from ZGENERICASSET where (ZAVALANCHEPICKTYPE=20 OR ZAVALANCHEPICKTYPE=2) AND ZTRASHEDDATE IS NULL";
        if ([_iOSVersion isVersionLessEqual:@"8"]) {
            sql = @"select ZAVALANCHEUUID,ZDATECREATED from ZGENERICASSET where (ZAVALANCHEPICKTYPE=20 OR ZAVALANCHEPICKTYPE=2)";
        }
        FMResultSet *rs = [_databaseConnection executeQuery:sql];
        while ([rs next]) {
            IMBPhotoEntity *entity = [[IMBPhotoEntity alloc] init];
            entity.photoBurstsID = [rs stringForColumn:@"ZAVALANCHEUUID"];
            entity.createdDate = [rs dateForColumn:@"ZDATECREATED"];
            entity.albumZpk = i;
            entity.albumType = CameraRoll;
            entity.albumSubType = ContinuousShooting;
            long timestamp = [rs longForColumn:@"ZDATECREATED"];
           
            entity.albumTitle = [DateHelper dateFrom2001ToString:timestamp withMode:4];
            BOOL isExsit = NO;
            for (IMBPhotoEntity *photoentity in array ) {
                if ([photoentity.photoBurstsID isEqualToString:entity.photoBurstsID]) {
                    isExsit = YES;
                    break;
                }
                
            }
            if (!isExsit) {
                [array addObject:entity];
            }
            [entity release];
            i++;
        }
        [rs close];
        [self closeDataBase];
    }
    return array;
}
- (NSMutableArray *)getContinuousShootings:(IMBPhotoEntity *)photoEntity
{
    NSMutableArray *array = nil;
    if ([self openDataBase]) {
        NSString *masterText = @"";
        if ([self CheckCloudMaster])
        {
            masterText = @"a.ZMASTER";
        }
        else
        {
            masterText = @"b.ZCLOUDMASTER";
        }
        NSString *sql = [NSString stringWithFormat:@"select a.Z_PK,ZDATECREATED,ZFILENAME,ZUUID,a.ZHEIGHT,a.ZWIDTH,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,ZAVALANCHEUUID,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where (ZAVALANCHEPICKTYPE=2 or ZAVALANCHEPICKTYPE=20) AND ZTRASHEDSTATE!=1 AND ZAVALANCHEUUID=:burstsID order by ZDATECREATED",masterText];
        if ([_iOSVersion isVersionLessEqual:@"8"]) {
//            sql = @"select a.Z_PK,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,ZAVALANCHEUUID,b.ZCLOUDMASTER FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where (ZAVALANCHEPICKTYPE=2 or ZAVALANCHEPICKTYPE=20) AND ZAVALANCHEUUID=:burstsID  order by ZDATECREATED";
            sql = @"select a.Z_PK,ZDATECREATED,ZFILENAME,a.ZHEIGHT,a.ZWIDTH,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,ZAVALANCHEUUID FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where (ZAVALANCHEPICKTYPE=2 or ZAVALANCHEPICKTYPE=20)  AND ZAVALANCHEUUID=:burstsID  order by ZDATECREATED";
        }
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                photoEntity.photoBurstsID, @"burstsID"
                                , nil];
        FMResultSet *rs = [_databaseConnection executeQuery:sql withParameterDictionary:params];
        array = [self queryPhotoDetailedInfo:rs withAlbumInfo:photoEntity withSqlText:sql];
        if (array.count > 0) {
            for (IMBPhotoEntity *entity in array) {
                entity.photoType = ContinuousShootingType;
            }
        }
        [rs close];
        [self closeDataBase];
    }
    return array;
}

- (NSMutableArray *)queryAlbumPhotosCount:(NSMutableArray *)array {
    [_logManger writeInfoLog:@"begin query Album's photo count"];
    NSString *string = @"";
    FMResultSet *rs = nil;
    NSString *iosVersion = _iOSVersion;
    if ([self openDataBase]) {
        for (IMBPhotoEntity *entity in array) {
            if (entity.albumZpk < 0) {
                if (entity.albumType == VideoAlbum) {
                    string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where a.ZKIND = 1 AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                }else {
                    if (entity.albumType == LivePhoto) {
                        if ([_iOSVersion isVersionMajorEqual:@"9"]) {
//                            string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a, ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and ZKINDSUBTYPE=2 order by ZDATECREATED";
                            string = @"select count(a.Z_PK) FROM ZGENERICASSET a, ZADDITIONALASSETATTRIBUTES b, ZSIDECARFILE as c WHERE  a.Z_PK=c.ZASSET AND a.zadditionalattributes=b.Z_PK and ZDIRECTORY IS NOT NULL AND c.ZFILENAME IS NOT NULL and a.ZKINDSUBTYPE=2 order by ZDATECREATED";
                        }
                    }else if (entity.albumType == Screenshot) {
                        if ([_iOSVersion isVersionMajorEqual:@"9.3.0"])
                        {
                            string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a, ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and ZKINDSUBTYPE=10 order by ZDATECREATED";
                        }
                    }else if (entity.albumType == PhotoSelfies) {
                        if ([_iOSVersion isVersionMajorEqual:@"9.3.0"])
                        {
                            string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a, ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and b.ZCAMERACAPTUREDEVICE = 1 order by ZDATECREATED";
                        }
                    }else if (entity.albumType == Favorite) {
                        string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a, ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and a.zfavorite = 1 order by ZDATECREATED";
                    }else if (entity.albumType == Location) {
                        if ([_iOSVersion isVersionMajorEqual:@"10"])
                        {
                            string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a, ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and b.ZREVERSELOCATIONDATA not null order by ZDATECREATED";
                        }
                    }
                    
                }
                rs = [_databaseConnection executeQuery:string];
                while ([rs next]) {
                    entity.photoCounts = [rs intForColumn:@"Count(a.Z_PK)"];
                }
                [rs close];
            }else {
                if (entity.albumType == PhotoLibrary) {
                    string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where a.ZSAVEDASSETTYPE=256 AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                    rs = [_databaseConnection executeQuery:string];
                    while ([rs next]) {
                        entity.photoCounts = [rs intForColumn:@"Count(a.Z_PK)"];
                    }
                    [rs close];
                }else {
                    if ([iosVersion hasPrefix:@"4"])
                    {
                        string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where a.Z_PK IN(select Z_5ASSETS FROM Z_6ASSETS WHERE Z_5ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                    }
                    else if ([iosVersion hasPrefix:@"5"])
                    {
                        string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where a.Z_PK IN(select Z_11ASSETS FROM Z_6ASSETS WHERE Z_6ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                    }
                    else if ([iosVersion hasPrefix:@"6"])
                    {
                        string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where a.Z_PK IN(select Z_14ASSETS FROM Z_8ASSETS WHERE Z_8ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                    }
                    else if ([iosVersion hasPrefix:@"7"])
                    {
                        string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where a.Z_PK IN(select Z_17ASSETS FROM Z_11ASSETS WHERE Z_11ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                    }
                    else if ([iosVersion hasPrefix:@"8"]||[iosVersion hasPrefix:@"9"])
                    {
                        string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where a.Z_PK IN(select Z_23ASSETS FROM Z_16ASSETS WHERE Z_16ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                    }
                    else if ([iosVersion isVersionMajorEqual:@"10"])
                    {
                        if (entity.albumKind == 1000) {
                            if (_isHaveCameraRollAlbum) {
                                if ([self checkASSETSIdExist:@"Z_19ASSETS"]) {
                                    string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where a.Z_PK IN(select Z_26ASSETS FROM Z_19ASSETS WHERE Z_19ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                                }else{
                                    if ([iosVersion isVersionMajorEqual:@"10.3"]) {
                                        string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where a.Z_PK IN(select Z_27ASSETS FROM Z_20ASSETS WHERE Z_20ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                                    }else {
                                        string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where a.Z_PK IN(select Z_25ASSETS FROM Z_18ASSETS WHERE Z_18ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                                    }
                                }
                            }else {
                                string = @"SELECT  Count(a.Z_PK) FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK WHERE (ZSAVEDASSETTYPE =3 OR ZSAVEDASSETTYPE=6) and ZTRASHEDSTATE!=1";
                            }
                        }else {
                            if ([self checkASSETSIdExist:@"Z_19ASSETS"]) {
                                string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where a.Z_PK IN(select Z_26ASSETS FROM Z_19ASSETS WHERE Z_19ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                            }else{
                                if ([iosVersion isVersionMajorEqual:@"10.3"]) {
                                    string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where a.Z_PK IN(select Z_27ASSETS FROM Z_20ASSETS WHERE Z_20ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                                }else {
                                    string = @"select Count(a.Z_PK) FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where a.Z_PK IN(select Z_25ASSETS FROM Z_18ASSETS WHERE Z_18ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                                }
                            }
                        }
                    }
                    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",entity.albumZpk], @"albumZpk", nil];
                    rs = [_databaseConnection executeQuery:string withParameterDictionary:param];
                    while ([rs next]) {
                        entity.photoCounts = [rs intForColumn:@"Count(a.Z_PK)"];
                    }
                    [rs close];
                }
            }
        }
        [self closeDataBase];
    }
    [_logManger writeInfoLog:@"end query Album's photo count"];
    return array;
}

- (NSMutableArray *)getPhotoInfoByAlbum:(IMBPhotoEntity *)entity {
    [_logManger writeInfoLog:@"begin query single Album's photo info"];
    NSMutableArray *mutArray = [[[NSMutableArray alloc] init] autorelease];
    NSString *string = @"";
    FMResultSet *rs = nil;
    NSString *iosVersion = _iOSVersion;
    if ([self openDataBase]) {
        if (entity.albumZpk > 0) {
            if (entity.albumType == PhotoLibrary) {
                string  = @"select a.Z_PK,ZKIND,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.ZSAVEDASSETTYPE=256 AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                rs = [_databaseConnection executeQuery:string];
                mutArray = [self queryPhotoDetailedInfo:rs withAlbumInfo:entity withSqlText:string];
                [rs close];
            }else {
                if ([iosVersion hasPrefix:@"4"])
                {
                    string = @"select a.Z_PK,ZKIND,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH, b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_5ASSETS FROM Z_6ASSETS WHERE Z_5ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                }
                else if ([iosVersion hasPrefix:@"5"])
                {
                    string  = @"select a.Z_PK,ZKIND,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH, b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_11ASSETS FROM Z_6ASSETS WHERE Z_6ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                }
                else if ([iosVersion hasPrefix:@"6"])
                {
                    string = @"select a.Z_PK,ZKIND,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH, b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_14ASSETS FROM Z_8ASSETS WHERE Z_8ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                }
                else if ([iosVersion hasPrefix:@"7"])
                {
                    if (entity.albumType == CameraRoll&&entity.albumSubType == Panoramas) {
                        //查询全景图
                         string = @"select a.Z_PK,ZKIND,ZKINDSUBTYPE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZKINDSUBTYPE,a.ZHEIGHT,a.ZWIDTH, b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET  as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_17ASSETS FROM Z_11ASSETS WHERE Z_11ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and a.ZKINDSUBTYPE=1";
                    }else
                    {
                        if (entity.albumType == CameraRoll) {
                           
                            //剔除在cameraRoll中的全景图
                            string = @"select a.Z_PK,ZDATECREATED,a.ZKIND,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,a.ZKINDSUBTYPE,b.ZORIGINALWIDTH,ZAVALANCHEUUID FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where a.Z_PK IN(select Z_17ASSETS FROM Z_11ASSETS WHERE Z_11ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL AND a.ZKINDSUBTYPE!=1 order by ZDATECREATED";
                        }else {
                            string = @"select a.Z_PK,ZKIND,ZKINDSUBTYPE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH, b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_17ASSETS FROM Z_11ASSETS WHERE Z_11ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL AND a.ZKINDSUBTYPE!=1";
                        }
                    }
                    
                }
                else if ([iosVersion hasPrefix:@"8"])
                {
                    if (entity.albumType == CameraRoll&&entity.albumSubType == Panoramas) {
                        //查询全景图
                        if ([iosVersion hasPrefix:@"8.3"]||[iosVersion hasPrefix:@"8.4"]) {
                             string = @"select a.Z_PK,ZKIND,ZKINDSUBTYPE,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE,a.ZHEIGHT,a.ZWIDTH,,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_24ASSETS FROM Z_17ASSETS WHERE Z_17ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and a.ZKINDSUBTYPE=1";
                        }else
                        {
                            string = @"select a.Z_PK,ZKIND,ZKINDSUBTYPE,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_23ASSETS FROM Z_16ASSETS WHERE Z_16ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and a.ZKINDSUBTYPE=1";
                        }
                        
                       
                    }else if (entity.albumType == CameraRoll&&entity.albumSubType == OtherType)
                    {   //剔除在cameraRoll中连拍的图片和全景图
                         if ([iosVersion hasPrefix:@"8.3"]||[iosVersion hasPrefix:@"8.4"]) {
                              string = @"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_24ASSETS FROM Z_17ASSETS WHERE Z_17ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL AND (a.ZAVALANCHEPICKTYPE!=16) AND (a.ZAVALANCHEPICKTYPE!=20) AND a.ZKINDSUBTYPE!=1";
                         }else
                         {
                            string = @"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE,a.ZHEIGHT,a.ZWIDTH, b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_23ASSETS FROM Z_16ASSETS WHERE Z_16ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                         }
                    }else
                    {
                        if ([iosVersion hasPrefix:@"8.3"]||[iosVersion hasPrefix:@"8.4"]) {
                            string = @"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH, b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_24ASSETS FROM Z_17ASSETS WHERE Z_17ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                        }else
                        {
                            string = @"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH, b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_23ASSETS FROM Z_16ASSETS WHERE Z_16ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL";
                        }
                    }
                }
                else if ([iosVersion hasPrefix:@"9"])
                {
                    NSString *masterText = @"";
                    if ([self CheckCloudMaster])
                    {
                        masterText = @"a.ZMASTER";
                    }
                    else
                    {
                        masterText = @"b.ZCLOUDMASTER";
                    }
                    if (entity.albumType == CameraRoll&&entity.albumSubType == Panoramas) {
                        //查询全景图
                        NSString *version = nil;
                        if(_isBackup){
                            version = _iOSVersion;
                        }else{
                            version = [_ipod.deviceInfo getDeviceFloatVersionNumber];
                        }
                 
                        if ([version isVersionMajorEqual:@"9.2"]) {
                            string = [NSString stringWithFormat:@"select a.Z_PK,ZKIND,ZKINDSUBTYPE,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_22ASSETS FROM Z_15ASSETS WHERE Z_15ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and a.ZKINDSUBTYPE=1",masterText];
                        }else{
                            
                            string = [NSString stringWithFormat:@"select a.Z_PK,ZKIND,ZKINDSUBTYPE,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_23ASSETS FROM Z_16ASSETS WHERE Z_16ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and a.ZKINDSUBTYPE=1",masterText];
                        }
                    }else if (entity.albumType == CameraRoll&&entity.albumSubType == OtherType)
                    {   //剔除在cameraRoll中连拍的图片和全景图
                        NSString *version =  _iOSVersion;
                        if ([version isVersionMajorEqual:@"9.2"]) {
                            string = [NSString stringWithFormat:@"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_22ASSETS FROM Z_15ASSETS WHERE Z_15ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL AND (a.ZAVALANCHEPICKTYPE!=16) AND (a.ZAVALANCHEPICKTYPE!=20) AND a.ZKINDSUBTYPE!=1",masterText];
                        }else{
                            
                            string = [NSString stringWithFormat:@"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_23ASSETS FROM Z_16ASSETS WHERE Z_16ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL AND (a.ZAVALANCHEPICKTYPE!=16) AND (a.ZAVALANCHEPICKTYPE!=20) AND a.ZKINDSUBTYPE!=1",masterText];
                        }
                    }else
                    {
                        NSString *version = nil;
                        if(_isBackup){
                            version = _iOSVersion;
                        }else{
                            version = [_ipod.deviceInfo getDeviceFloatVersionNumber];
                        }
                        if ([version isVersionMajorEqual:@"9.2"]) {
                            string = [NSString stringWithFormat:@"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_22ASSETS FROM Z_15ASSETS WHERE Z_15ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL",masterText];
                        }else{
                            
                            string = [NSString stringWithFormat:@"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_23ASSETS FROM Z_16ASSETS WHERE Z_16ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL",masterText];
                        }
                    }
                }
                else if ([iosVersion isVersionMajorEqual:@"10"])
                {
                    NSString *masterText = @"";
                    if ([self CheckCloudMaster])
                    {
                        masterText = @"a.ZMASTER";
                    }
                    else
                    {
                        masterText = @"b.ZCLOUDMASTER";
                    }
                    if (entity.albumType == CameraRoll&&entity.albumSubType == Panoramas) {
                        //查询全景图
                        if (_isHaveCameraRollAlbum) {
                            if ([self checkASSETSIdExist:@"Z_19ASSETS"]) {
                                string = [NSString stringWithFormat:@"select a.Z_PK,ZKIND,ZKINDSUBTYPE,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_26ASSETS FROM Z_19ASSETS WHERE Z_19ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and a.ZKINDSUBTYPE=1",masterText];
                            }else{
                                if ([iosVersion isVersionMajorEqual:@"10.3"]) {
                                    string = [NSString stringWithFormat:@"select a.Z_PK,ZKIND,ZKINDSUBTYPE,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_27ASSETS FROM Z_20ASSETS WHERE Z_20ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and a.ZKINDSUBTYPE=1",masterText];
                                }else {
                                    string = [NSString stringWithFormat:@"select a.Z_PK,ZKIND,ZKINDSUBTYPE,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_25ASSETS FROM Z_18ASSETS WHERE Z_18ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and a.ZKINDSUBTYPE=1",masterText];
                                }
                            }
                            
                            
                            
                        }else {
                            string = [NSString stringWithFormat:@"SELECT a.Z_PK,ZDATECREATED,a.ZKIND,ZFILENAME,a.ZHEIGHT,a.ZWIDTH,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE, a.ZDURATION,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,a.ZKINDSUBTYPE,ZAVALANCHEUUID,a.ZCLOUDLOCALSTATE,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK WHERE (ZSAVEDASSETTYPE =3 OR ZSAVEDASSETTYPE=6) and ZTRASHEDSTATE!=1 and a.ZKINDSUBTYPE=1",masterText];
                        }
                    }else if (entity.albumType == CameraRoll&&entity.albumSubType == OtherType)
                    {   //剔除在cameraRoll中连拍的图片和全景图
                        if (_isHaveCameraRollAlbum) {
                            if ([self checkASSETSIdExist:@"Z_19ASSETS"]) {
                                string = [NSString stringWithFormat:@"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_26ASSETS FROM Z_19ASSETS WHERE Z_19ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL AND (a.ZAVALANCHEPICKTYPE!=16) AND (a.ZAVALANCHEPICKTYPE!=20) AND a.ZKINDSUBTYPE!=1",masterText];
                            }else{
                                if ([iosVersion isVersionMajorEqual:@"10.3"]) {
                                    string = [NSString stringWithFormat:@"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_27ASSETS FROM Z_20ASSETS WHERE Z_20ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL AND (a.ZAVALANCHEPICKTYPE!=16) AND (a.ZAVALANCHEPICKTYPE!=20) AND a.ZKINDSUBTYPE!=1",masterText];
                                }else {
                                    string = [NSString stringWithFormat:@"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_25ASSETS FROM Z_18ASSETS WHERE Z_18ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL AND (a.ZAVALANCHEPICKTYPE!=16) AND (a.ZAVALANCHEPICKTYPE!=20) AND a.ZKINDSUBTYPE!=1",masterText];
                                }
                            }
                            
                        }else {
                            string = [NSString stringWithFormat:@"SELECT a.Z_PK,ZDATECREATED,a.ZKIND,ZFILENAME,ZUUID,ZDIRECTORY,a.ZHEIGHT,a.ZWIDTH,ZSAVEDASSETTYPE,a.ZAVALANCHEPICKTYPE,a.ZDURATION,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,a.ZKINDSUBTYPE,ZAVALANCHEUUID,a.ZCLOUDLOCALSTATE,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK WHERE (ZSAVEDASSETTYPE =3 OR ZSAVEDASSETTYPE=6) and ZTRASHEDSTATE!=1 AND (a.ZAVALANCHEPICKTYPE!=16) AND (a.ZAVALANCHEPICKTYPE!=20) AND a.ZKINDSUBTYPE!=1",masterText];
                        }
                    }else
                    {
                        if ([self checkASSETSIdExist:@"Z_19ASSETS"]) {
                            string = [NSString stringWithFormat:@"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_26ASSETS FROM Z_19ASSETS WHERE Z_19ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL",masterText];
                        }else{
                            if ([iosVersion isVersionMajorEqual:@"10.3"]) {
                                string = [NSString stringWithFormat:@"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_27ASSETS FROM Z_20ASSETS WHERE Z_20ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL",masterText];
                            }else {
                                string = [NSString stringWithFormat:@"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.Z_PK IN(select Z_25ASSETS FROM Z_18ASSETS WHERE Z_18ALBUMS=:albumZpk) AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL",masterText];
                            }
                        }
                    }
                }
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",entity.albumZpk], @"albumZpk", nil];
                rs = [_databaseConnection executeQuery:string withParameterDictionary:param];
                mutArray = [self queryPhotoDetailedInfo:rs withAlbumInfo:entity withSqlText:string];
                [rs close];
            }
        }else if (entity.albumZpk < 0) {
            if (entity.albumType == VideoAlbum) {
                if ([iosVersion isVersionMajorEqual:@"8"]) {
                    if ([iosVersion isVersionMajorEqual:@"9"])
                    {
                        NSString *masterText = @"";
                        if ([self CheckCloudMaster])
                        {
                            masterText = @"a.ZMASTER";
                        }
                        else
                        {
                            masterText = @"b.ZCLOUDMASTER";
                        }
                        
                        if (entity.albumSubType == TimeLapse) {
                            //查询微速摄影
                            string = [NSString stringWithFormat:@"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.ZKIND = 1 AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and a.ZKINDSUBTYPE=102",masterText];
                        }else if (entity.albumSubType == SlowMove)
                        {
                            string = [NSString stringWithFormat:@"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.ZKIND = 1 AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and a.ZKINDSUBTYPE=101",masterText];
                        }
                        else
                        {
                            string = [NSString stringWithFormat:@"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH,a.ZCLOUDLOCALSTATE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,%@ FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.ZKIND = 1 AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL AND a.ZKINDSUBTYPE!=102 AND a.ZKINDSUBTYPE!=101 AND ZSAVEDASSETTYPE!=4",masterText];
                        }
                    }else {
                        if (entity.albumSubType == TimeLapse) {
                            //查询微速摄影
                            string = @"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.ZKIND = 1 AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and a.ZKINDSUBTYPE=102";
                        }else if (entity.albumSubType == SlowMove)
                        {
                            string = @"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.ZKIND = 1 AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and a.ZKINDSUBTYPE=101";
                        }
                        else
                        {
                            string = @"select a.Z_PK,ZKINDSUBTYPE,ZKIND,ZTRASHEDSTATE,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.ZKIND = 1 AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL AND a.ZKINDSUBTYPE!=102 AND a.ZKINDSUBTYPE!=101 AND ZSAVEDASSETTYPE!=4";
                        }
                    }
                    
                }else {
                    string = @"select a.Z_PK,ZKIND,ZDATECREATED,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,a.ZHEIGHT,a.ZWIDTH,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH FROM ZGENERICASSET as a left join ZADDITIONALASSETATTRIBUTES b ON a.ZADDITIONALATTRIBUTES=b.Z_PK where a.ZKIND = 1 AND ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL AND ZSAVEDASSETTYPE!=4";
                }
                
                rs = [_databaseConnection executeQuery:string];
                mutArray = [self queryPhotoDetailedInfo:rs withAlbumInfo:entity withSqlText:string];
                [rs close];
            }else {
                if (entity.albumType == LivePhoto) {
                    if ([iosVersion isVersionMajorEqual:@"9"]) {
                        NSString *masterText = @"";
                        if ([self CheckCloudMaster])
                        {
                            masterText = @"a.ZMASTER";
                        }
                        else
                        {
                            masterText = @"b.ZCLOUDMASTER";
                        }
                        string = [NSString stringWithFormat:@"select a.Z_PK,a.ZDATECREATED,a.ZKIND,a.ZUUID,a.ZTRASHEDSTATE,a.ZHEIGHT,a.ZWIDTH,a.ZDIRECTORY,a.ZSAVEDASSETTYPE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,a.ZAVALANCHEUUID,a.ZKINDSUBTYPE,c.ZFILENAME,a.ZDURATION,a.ZCLOUDLOCALSTATE,%@ FROM ZGENERICASSET a, ZADDITIONALASSETATTRIBUTES b, ZSIDECARFILE as c WHERE  a.Z_PK=c.ZASSET AND a.zadditionalattributes=b.Z_PK and ZDIRECTORY IS NOT NULL AND c.ZFILENAME IS NOT NULL and a.ZKINDSUBTYPE=2 order by ZDATECREATED",masterText];
                    }
                }
                else if (entity.albumType == Screenshot)
                {
                    if ([iosVersion isVersionMajorEqual:@"9.3.0"])
                    {
                        NSString *masterText = @"";
                        if ([self CheckCloudMaster])
                        {
                            masterText = @"a.ZMASTER";
                        }
                        else
                        {
                            masterText = @"b.ZCLOUDMASTER";
                        }
                        string = [NSString stringWithFormat:@"select a.Z_PK,ZDATECREATED,a.ZKIND,a.ZTRASHEDSTATE,a.ZHEIGHT,a.ZWIDTH,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,a.ZAVALANCHEUUID,a.ZKINDSUBTYPE,a.ZDURATION,a.ZCLOUDLOCALSTATE,%@ FROM ZGENERICASSET as a, ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and ZKINDSUBTYPE=10 order by ZDATECREATED",masterText];
                    }
                }
                else if (entity.albumType == PhotoSelfies)
                {
                    if ([iosVersion isVersionMajorEqual:@"9.3.0"])
                    {
                        NSString *masterText = @"";
                        if ([self CheckCloudMaster])
                        {
                            masterText = @"a.ZMASTER";
                        }
                        else
                        {
                            masterText = @"b.ZCLOUDMASTER";
                        }
                        string = [NSString stringWithFormat:@"select a.Z_PK,ZDATECREATED,a.ZKIND,a.ZTRASHEDSTATE,ZFILENAME,a.ZHEIGHT,a.ZWIDTH,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,a.ZAVALANCHEUUID,a.ZKINDSUBTYPE,a.ZDURATION,a.ZCLOUDLOCALSTATE,%@ FROM ZGENERICASSET as a, ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and b.ZCAMERACAPTUREDEVICE = 1 order by ZDATECREATED",masterText];
                    }
                }
                else if (entity.albumType == Location)
                {
                    if ([iosVersion isVersionMajorEqual:@"10"])
                    {
                        NSString *masterText = @"";
                        if ([self CheckCloudMaster])
                        {
                            masterText = @"a.ZMASTER";
                        }
                        else
                        {
                            masterText = @"b.ZCLOUDMASTER";
                        }
                        string = [NSString stringWithFormat:@"select a.Z_PK,ZDATECREATED,a.ZKIND,a.ZTRASHEDSTATE,a.ZHEIGHT,a.ZWIDTH,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,a.ZAVALANCHEUUID,a.ZKINDSUBTYPE,a.ZDURATION,a.ZCLOUDLOCALSTATE,%@ FROM ZGENERICASSET as a, ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and b.ZREVERSELOCATIONDATA not null order by ZDATECREATED",masterText];
                    }
                }
                else if (entity.albumType == Favorite)
                {
                    
                    NSString *masterText = @"";
                    if ([self CheckCloudMaster])
                    {
                        masterText = @"a.ZMASTER";
                    }
                    else
                    {
                        masterText = @"b.ZCLOUDMASTER";
                    }
                    string = [NSString stringWithFormat:@"select a.Z_PK,ZDATECREATED,a.ZKIND,a.ZTRASHEDSTATE,a.ZHEIGHT,a.ZWIDTH,ZFILENAME,ZUUID,ZDIRECTORY,ZSAVEDASSETTYPE,b.ZORIGINALFILESIZE,b.ZORIGINALHEIGHT,b.ZORIGINALWIDTH,a.ZAVALANCHEUUID,a.ZKINDSUBTYPE,a.ZDURATION,a.ZCLOUDLOCALSTATE,%@ FROM ZGENERICASSET as a, ZADDITIONALASSETATTRIBUTES b ON a.zadditionalattributes=b.Z_PK where ZDIRECTORY IS NOT NULL AND ZFILENAME IS NOT NULL and a.zfavorite = 1 order by ZDATECREATED",masterText];
                }
                
                rs = [_databaseConnection executeQuery:string];
                mutArray = [self queryPhotoDetailedInfo:rs withAlbumInfo:entity withSqlText:string];
                [rs close];
            }
        }
        [self closeDataBase];
    }
    [_logManger writeInfoLog:@"end query single Album's photo info"];
    return mutArray;
}

- (BOOL)checkASSETSIdExist:(NSString *)tableName
{
    BOOL result = NO;
    NSString *sql = @"select name from sqlite_master where name =:tableName and type = 'table'";
    FMResultSet *set = [_databaseConnection executeQuery:sql withParameterDictionary:[NSDictionary dictionaryWithObject:tableName forKey:@"tableName"]];
    NSString *name = nil;
    while ([set next]) {
        name = [set stringForColumn:@"name"];
    }
    if (name) {
        result = YES;
    }else{
        result = NO;
    }
    [set close];
    return result;
}


- (NSMutableArray *)queryPhotoDetailedInfo:(FMResultSet *)rs withAlbumInfo:(IMBPhotoEntity *)albumInfo withSqlText:(NSString *)sqlText {
    [_logManger writeInfoLog:@"begin query photo detail info"];
    BOOL ExistZCLOUDLOCALSTATE = [self CheckFieldIsExist:@"ZCLOUDLOCALSTATE" withCheckText:sqlText];
    BOOL ExistZCLOUDMASTER = [self CheckFieldIsExist:@"ZCLOUDMASTER" withCheckText:sqlText];
    BOOL ExistZMASTER = [self CheckFieldIsExist:@"ZMASTER" withCheckText:sqlText];
    NSMutableArray *lArray = [[[NSMutableArray alloc] init] autorelease];
    IMBPhotoEntity *entity = nil;
    while ([rs next]) {
        if ([_iOSVersion isVersionMajorEqual:@"8"] && albumInfo.albumType != PhotoLibrary) {
            if ([rs intForColumn:@"ZTRASHEDSTATE"] == 1) {//去除删除的图片（但图片还存在设备的最近删除的图片文件夹中）
                continue;
            }
        }
        entity = [[IMBPhotoEntity alloc] init];
        entity.photoImage = [NSImage imageNamed:@"photo_show"];
        if (![rs columnIsNull:@"ZKIND"]) {
            entity.photoKind = [rs intForColumn:@"ZKIND"];
        }
        //区分图片类型
        if ([_iOSVersion isVersionMajorEqual:@"7"]) {
            if ([rs intForColumn:@"ZKINDSUBTYPE"] == 1) {
                entity.photoType = PanoramasType;
            }else if ([rs intForColumn:@"ZKINDSUBTYPE"] == 101) {
                entity.photoType = SlowMoveType;
            }else if ([rs intForColumn:@"ZKINDSUBTYPE"] == 102) {
                entity.photoType = TimeLapseType;
            }else if (entity.photoKind == 1) {
                entity.photoType = PhotoVideoType;
            }else if (entity.photoKind == 0) {
                entity.photoType = CommonType;
            }
        }else {
            if (entity.photoKind == 1) {
                entity.photoType = PhotoVideoType;
            }else if (entity.photoKind == 0) {
                entity.photoType = CommonType;
            }
        }
        //取出cameraRoll中的photovideo
        if (albumInfo.albumType == CameraRoll && entity.photoKind == 1) {
            continue;
        }
        if (![rs columnIsNull:@"Z_PK"]) {
            entity.photoZpk = [rs intForColumn:@"Z_PK"];
        }
        if (![rs columnIsNull:@"ZDIRECTORY"]) {
            entity.photoPath = [rs stringForColumn:@"ZDIRECTORY"];
        }
        if (![rs columnIsNull:@"ZKINDSUBTYPE"]) {
            entity.kindSubType = [rs intForColumn:@"ZKINDSUBTYPE"];
        }
        if (entity.kindSubType == 2) {//判断是否是live photo
            NSString *cmd = [NSString stringWithFormat:@"select *from ZSIDECARFILE where ZASSET=%d",entity.photoZpk];
            FMResultSet *rs1 = [_databaseConnection executeQuery:cmd];
            while ([rs1 next]) {
                if (![rs1 columnIsNull:@"ZFILENAME"]) {
                    entity.photoName = [rs1 stringForColumn:@"ZFILENAME"];
                }
            }
            [rs1 close];
            if (!entity.photoName) {
                entity.kindSubType = 0;
                if (![rs columnIsNull:@"ZFILENAME"]) {
                    entity.photoName = [rs stringForColumn:@"ZFILENAME"];
                }
            }
        }else {
            if (![rs columnIsNull:@"ZFILENAME"]) {
                entity.photoName = [rs stringForColumn:@"ZFILENAME"];
            }
        }
        if (![rs columnIsNull:@"ZUUID"]) {
            if ([_iOSVersion isVersionMajorEqual:@"8"]) {
                entity.photoUUIDString = [rs stringForColumn:@"ZUUID"];
            }else {
                entity.photoUUID = [rs dataForColumn:@"ZUUID"];
                entity.photoUUIDString = [StringHelper NSDatatoNSString:entity.photoUUID];
            }
        }
        if (![rs columnIsNull:@"ZORIGINALFILESIZE"]) {
            long long size = [rs longLongIntForColumn:@"ZORIGINALFILESIZE"];
            if (size < 0) {
                entity.photoSize = [_ipod.fileSystem getFileLength:[entity.photoPath stringByAppendingPathComponent:entity.photoName]];
            }else {
                entity.photoSize = size;
            }
            
        }
        if (![rs columnIsNull:@"ZDATECREATED"]) {
            entity.photoDateData = [rs intForColumn:@"ZDATECREATED"];
        }
        if (![rs columnIsNull:@"ZORIGINALWIDTH"]) {
            if ((albumInfo.albumType == CameraRoll && albumInfo.albumSubType == ContinuousShooting) || albumInfo.albumType == LivePhoto) {
                entity.photoWidth = [rs intForColumn:@"ZORIGINALWIDTH"];
            }else
            {
                entity.photoWidth = [rs intForColumn:@"ZWIDTH"];
            }
           
        }
        if (![rs columnIsNull:@"ZORIGINALHEIGHT"]) {
            if ((albumInfo.albumType == CameraRoll && albumInfo.albumSubType == ContinuousShooting) || albumInfo.albumType == LivePhoto) {
                entity.photoHeight = [rs intForColumn:@"ZORIGINALHEIGHT"];
            }else
            {
                entity.photoHeight = [rs intForColumn:@"ZHEIGHT"];
            }
           
        }
        
        if (entity.photoKind == 1) {
            entity.videoPath = [[@"/PhotoData/Metadata" stringByAppendingPathComponent:entity.photoPath] stringByAppendingPathComponent:[[entity.photoName stringByDeletingPathExtension] stringByAppendingPathExtension:@"THM"]];
        }
        entity.allPath = [entity.photoPath stringByAppendingPathComponent:entity.photoName];
        if ([_ipod.fileSystem fileExistsAtPath:entity.allPath]) {
            entity.isexisted = YES;
        }else{
            entity.isexisted = NO;
        }
        
        NSString *filePath = [[@"PhotoData/Thumbnails/V2/" stringByAppendingPathComponent:entity.photoPath]stringByAppendingPathComponent:entity.photoName];
        if (![_ipod.fileSystem fileExistsAtPath:filePath]) {
            filePath =  [[@"PhotoData/Thumbnails/V2/" stringByAppendingPathComponent:entity.photoPath]stringByAppendingPathComponent:[[entity.photoName stringByDeletingPathExtension] stringByAppendingPathExtension:@"JPG"]];
            if (![_ipod.fileSystem fileExistsAtPath:filePath]) {
                filePath =  [[@"PhotoData/Thumbnails/V2/" stringByAppendingPathComponent:entity.photoPath]stringByAppendingPathComponent:[[entity.photoName stringByDeletingPathExtension] stringByAppendingPathExtension:@"HEIC"]];
            }
        }
    
        NSArray *thumbPathArray = [_ipod.fileSystem getItemInDirWithoutRootDir:filePath];
        long curSize = 0;
        for (AMFileEntity *fileEntity in thumbPathArray) {
            if (fileEntity.FileSize > curSize) {
                curSize = fileEntity.FileSize;
                entity.thumbPath = fileEntity.FilePath;
            }
        }
        if (_isBackup) {
            if (_isicloud) {
                if (entity.photoKind == 1) {
                    entity.videoPath = [[@"/PhotoData/Metadata" stringByAppendingPathComponent:entity.photoPath] stringByAppendingPathComponent:[[entity.photoName stringByDeletingPathExtension] stringByAppendingPathExtension:@"THM"]];
                }else {
//                     NSString *cameraPath = [_iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"CameraRollDomain"];
//                    NSString *endpath = [@"Media" stringByAppendingPathComponent:entity.allPath];
//                    NSString *filePath = [cameraPath stringByAppendingPathComponent:endpath];
//                    //        NSArray *thumbPathArray = [_ipod.fileSystem getItemInDirWithoutRootDir:filePath];
//                    //        for (AMFileEntity *fileEntity in thumbPathArray) {
//                    //            entity.thumbPath = fileEntity.FilePath;
//                    //            break;
//                    //        }
//                    entity.thumbPath = filePath;
                }
            }else{
                NSString *domainName = @"";
                domainName = @"CameraRollDomain";
                if (entity.photoKind == 1) {
                    entity.videoPath = [[@"/PhotoData/Metadata" stringByAppendingPathComponent:entity.photoPath] stringByAppendingPathComponent:[[entity.photoName stringByDeletingPathExtension] stringByAppendingPathExtension:@"THM"]];
                }else {
                    NSString *filePath = [[@"PhotoData/Thumbnails/V2/" stringByAppendingPathComponent:entity.photoPath]stringByAppendingPathComponent:entity.photoName];
                    //        NSArray *thumbPathArray = [_ipod.fileSystem getItemInDirWithoutRootDir:filePath];
                    //        for (AMFileEntity *fileEntity in thumbPathArray) {
                    //            entity.thumbPath = fileEntity.FilePath;
                    //            break;
                    //        }
                    entity.thumbPath = filePath;

                }
//                IMBBackupManager *manager = [IMBBackupManager shareInstance];
//                for (IMBMBFileRecord *allFileRecord in manager.backFileArray) {
//                    if ([StringHelper checkFileIsPicture:allFileRecord.path]) {
////                        for (IMBPhotoEntity *bd in carArray) {
//                            if ([allFileRecord.path contains:entity.allPath]) {
//                                NSLog(@"png:%@",entity.allPath);
//                                break;
//                            }
////                        }
//                    }else if([[[allFileRecord.path pathExtension] lowercaseString] isEqualToString:@"mov"]) {
//
////                        for (IMBPhotoEntity *bd in movArray) {
//                            if ([allFileRecord.path contains:entity.allPath]) {
//                               NSLog(@"mov:%@",entity.allPath);
//                                break;
//                            }
////                        }
//                    }
//                    
//                }
//                NSString *oriPath = [@"Media" stringByAppendingPathComponent:entity.allPath];
//                for (IMBMBFileRecord *item in manager.backFileArray) {
//                    if ([[item domain] isEqualToString:domainName] && [[item path] rangeOfString:oriPath].length > 0 && ![item.path isEqualToString:@"Media/PhotoData/Photos.sqlite.aside"]) {
//                        entity.oriPath = [_backUpPath stringByAppendingPathComponent:item.key];
//                        if (![fm fileExistsAtPath:entity.oriPath]) {
//                            NSString *fd = @"";
//                            if (item.key.length > 2) {
//                                fd = [item.key substringWithRange:NSMakeRange(0, 2)];
//                            }
//                            entity.oriPath = [[_backUpPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:item.key];
//                        }
//                        break;
//                    }
//                }

            }
        }

        entity.albumZpk = albumInfo.albumZpk;
        entity.albumTitle = albumInfo.albumTitle;
        entity.albumType = albumInfo.albumType;
        
        if (ExistZCLOUDLOCALSTATE) {
            entity.cloudLocalState = [rs intForColumn:@"ZSAVEDASSETTYPE"];
            if (entity.cloudLocalState == 1) {
                if (ExistZCLOUDMASTER) {
                    int cloudmaster = [rs intForColumn:@"ZCLOUDMASTER"];
                    if (cloudmaster > 0)
                    {
                        NSString *cloudPath = [self getCloudLoaclPath:cloudmaster];
                        if (![StringHelper stringIsNilOrEmpty:cloudPath])
                        {
                            [entity.cloudPathArray addObject:cloudPath];
                            if (![_ipod.fileSystem fileExistsAtPath:entity.allPath] && [_ipod.fileSystem fileExistsAtPath:cloudPath]) {
                                entity.allPath = cloudPath;
                            }
                        }
                    }
                }else if (ExistZMASTER) {
                    int cloudmaster = [rs intForColumn:@"ZMASTER"];
                    if (cloudmaster > 0)
                    {
                        NSMutableArray *array = [self getiOS9CloudLocalPath:cloudmaster];
                        [entity.cloudPathArray addObjectsFromArray:array];
                        NSString *string = @"";
                        for (NSString *path in array) {
                            if (![path contains:@"/PhotoData/Metadata"]) {
                                string = path;
                                break;
                            }
                            string = path;
                        }
                        if (![_ipod.fileSystem fileExistsAtPath:entity.allPath] && [_ipod.fileSystem fileExistsAtPath:string]) {
                            entity.allPath = string;
                        }
                    }
                }
            }else if (entity.cloudLocalState == 6) {
                _isiCloudPhoto = YES;
            }
        }
        if (_isBackup) {
            NSString *domainName = @"";
            if (albumInfo.albumType == CameraRoll || albumInfo.albumType == VideoAlbum) {
                domainName = @"CameraRollDomain";
            }else if (albumInfo.albumType == PhotoLibrary) {
                domainName = @"PhotoLibrary";
            }else if (albumInfo.albumType == PhotoStream) {
                domainName = @"MediaDomain";
            }
            [self getOriginalPhotosPath:entity withDomain:domainName];
        }
        
        if (_isicloud) {
            entity.thumbPath = entity.thumbImagePath;
            if ([fm fileExistsAtPath:entity.thumbPath]) {
                [lArray addObject:entity];
            }
        }else{
            [lArray addObject:entity];
        }
        
        [entity release];
        entity = nil;
    }
    [_logManger writeInfoLog:@"end query photo detail info"];
    return lArray;
}


- (void)getOriginalPhotosPath:(IMBPhotoEntity *)photoEntity withDomain:(NSString *)domainName {
    if (_isBackup) {
        NSString *thumbPath = nil;
        if (photoEntity.photoKind == 1) {
            thumbPath = photoEntity.videoPath;
        }else {
            thumbPath = [photoEntity.thumbPath stringByAppendingString:@"/"];
        }
//        IMBBackupManager *manager = [IMBBackupManager shareInstance];
//        NSString *sqliteddPath = [manager copyImageToApptempWithsqliteName:domainName backupfilePath:thumbPath withBackupstr:_backUpPath];
//        photoEntity.thumbPath = sqliteddPath;
//        if (_isicloud) {
//            if ([_iOSVersion isVersionMajorEqual:@"9"]) {
//                NSString *oriPath = [@"Media" stringByAppendingPathComponent:photoEntity.allPath];
//                NSString *cameraPath = [_iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"CameraRollDomain"];
//                photoEntity.oriPath = [cameraPath stringByAppendingPathComponent:oriPath];
//            }else{
//                NSString *oriPath = [@"Media" stringByAppendingPathComponent:photoEntity.allPath];
//                NSString *oriFrPath = [manager copyImageToApptempWithsqliteName:domainName backupfilePath:oriPath withBackupstr:_backUpPath];
//                photoEntity.oriPath = oriFrPath;
//            }
//
//        }
        BOOL isexistPhoto = NO;
        if (_isBackup) {
            if (_isicloud) {
                isexistPhoto = [fm fileExistsAtPath:photoEntity.oriPath];
            }else{
                isexistPhoto = [fm fileExistsAtPath:photoEntity.thumbPath];
            }
        }else {
            isexistPhoto = [fm fileExistsAtPath:photoEntity.oriPath];
        }
        if (isexistPhoto) {
            if (![fm fileExistsAtPath:photoEntity.thumbImagePath]) {
                if (_isBackup) {
                    if (_isicloud) {
                        photoEntity.thumbImagePath = photoEntity.oriPath;
                    }else{
                        photoEntity.thumbImagePath = photoEntity.thumbPath;
                    }
                }else {
                    photoEntity.thumbImagePath = photoEntity.oriPath;
                }
                
            }else{
                photoEntity.thumbImagePath = photoEntity.thumbPath;
            }
            if ([fm fileExistsAtPath:photoEntity.thumbImagePath]) {
                photoEntity.isexisted = YES;
            }else{
                photoEntity.isexisted = NO;
            }
            
            
            if (photoEntity.photoKind == 1) {
                if (photoEntity.isDeleted) {
//                        _photoVideoReslutEntity.deleteReslutCount += 1;
                }
//                    _photoVideoReslutEntity.reslutCount += 1;
//                    _photoVideoReslutEntity.selectedCount += 1;
//                    _photoVideoReslutEntity.reslutSize += photoEntity.photoSize;
                [_photoDataAry addObject:photoEntity];
            }else {
                if (photoEntity.isDeleted) {
//                        _reslutEntity.deleteReslutCount += 1;
                }
//                    _reslutEntity.reslutCount += 1;
//                    _reslutEntity.selectedCount += 1;
//                    _reslutEntity.reslutSize += photoEntity.photoSize;
                [_photoDataAry addObject:photoEntity];
            }
        }
    }
}

- (NSString *)getCloudLoaclPath:(int)cloudmaster
{
    NSString *cloudLocalPath = @"";
    NSString *string = @"SELECT ZCLOUDMASTERGUID,ZUNIFORMTYPEIDENTIFIER FROM ZCLOUDMASTER where z_pk=:z_pk";
    NSDictionary *parms = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:cloudmaster] forKey:@"z_pk"];
    FMResultSet *rs = [_databaseConnection executeQuery:string withParameterDictionary:parms];
    while ([rs next]) {
        NSString *cloudemasterguid = [rs stringForColumn:@"ZCLOUDMASTERGUID"];
        if ([StringHelper stringIsNilOrEmpty:cloudemasterguid])
        {
            break;
        }
        NSString *identifier = [rs stringForColumn:@"ZUNIFORMTYPEIDENTIFIER"];
        if ([StringHelper stringIsNilOrEmpty:identifier])
        {
            break;
        }
        NSString *formatText = [self matchPhotoFormat:identifier];
        if (![StringHelper stringIsNilOrEmpty:formatText])
        {
            cloudemasterguid = [cloudemasterguid stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            NSString *folderName = @"";
            if (cloudemasterguid.length >= 3) {
                folderName = [cloudemasterguid substringWithRange:NSMakeRange(0, 3)];
            }
            cloudLocalPath = [NSString stringWithFormat:@"/PhotoData/CPL/storage/filecache/%@/cpl%@.%@", folderName, cloudemasterguid, formatText];
        }
        break;
    }
    [rs close];
    return cloudLocalPath;
}

- (NSMutableArray *)getiOS9CloudLocalPath:(int)cloudmaster
{
    //SELECT ZFILEPATH FROM ZCLOUDRESOURCE WHERE  ZCLOUDMASTER  = 58
    NSMutableArray *array = [NSMutableArray array];
    NSString *string = @"SELECT ZFILEPATH FROM ZCLOUDRESOURCE WHERE ZCLOUDMASTER=:z_pk";
    NSDictionary *parms = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:cloudmaster] forKey:@"z_pk"];
    FMResultSet *rs = [_databaseConnection executeQuery:string withParameterDictionary:parms];
    while ([rs next]) {
        NSString *filePath = [rs stringForColumn:@"ZFILEPATH"];
        if (![StringHelper stringIsNilOrEmpty:filePath]) {
            filePath = [filePath stringByReplacingOccurrencesOfString:@"/var/mobile/Media" withString:@""];
            [array addObject:filePath];
        }
    }
    [rs close];
    return array;
}

- (NSString *)matchPhotoFormat:(NSString *)identifier
{
    if ([StringHelper stringIsNilOrEmpty:identifier])
    {
        return @"";
    }
    if ([identifier isEqualToString:@"com.apple.quicktime-movie"])
    {
        return @"mov";
    }
    else
    {
        NSArray *array = [identifier componentsSeparatedByString:@"."];
        if (array != nil && array.count > 0)
        {
            return [array objectAtIndex:0];
        }
        else
        {
            return @"";
        }
    }
    
}

//判断iCloud图片
- (BOOL)CheckCloudMaster {
    NSString *querySql = @"select name from sqlite_master where name = 'ZGENERICASSET' and sql like '%ZMASTER%'";
    FMResultSet *rs = [_databaseConnection executeQuery:querySql];
    while ([rs next]) {
        id scalar = [rs objectForColumnName:@"name"];
        if (scalar == nil)
        {
            [rs close];
            return NO;
        } else
        {
            [rs close];
            return YES;
        }
    }
    [rs close];
    return NO;
}

- (BOOL)CheckFieldIsExist:(NSString *)fieldName withCheckText:(NSString *)checkText {
    if ([checkText containsString:fieldName])
    {
        return true;
    }
    else
    {
        return false;
    }
}

- (void)dealloc {
    if (_ipod != nil) {
        [_ipod release];
        _ipod = nil;
    }
    
    if (_photoDataAry != nil) {
        [_photoDataAry release];
        _photoDataAry = nil;
    }
    [_iOSVersion release],_iOSVersion = nil;
    [super dealloc];
}
@end
