//
//  IMBCreatePhotoSyncPlist.m
//  iMobieTrans
//
//  Created by iMobie on 7/11/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBCreatePhotoSyncPlist.h"
#import "FMDatabase.h"
#import "IMBSyncPhotoData.h"
#import "IMBDeviceInfo.h"
#import "IMBTrack.h"
#import "TempHelper.h"
#import "NSString+Category.h"
#import "MediaHelper.h"
#import "StringHelper.h"
#import "NSData+Category.h"
#define Photosqlite        @"PhotoData/Photos.sqlite"
#define Photosqliteshm     @"PhotoData/Photos.sqlite-shm"
#define Photosqlitewal     @"PhotoData/Photos.sqlite-wal"

@implementation IMBCreatePhotoSyncPlist
@synthesize dateArray = _dateArray;

- (id)initWithiPod:(IMBiPod *)ipod {
    self = [super init];
    if (self) {
        _iPod = ipod;
        logHandle = [IMBLogManager singleton];
        fm = [NSFileManager defaultManager];
        _tmpPath = [TempHelper getAppTempPath];
        sqlPath = [self copySqliteToTemp];
        [self openConnectSQLiteDB];
        _dateArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithiPod:(IMBiPod *)ipod deleteArray:(NSArray *)delArray isDeletePhoto:(BOOL)delPhoto isDeleteAlbum:(BOOL)delAlbum {
    self = [self initWithiPod:ipod];
    if (self) {
        isDelete = delPhoto;
        isDeleteAlbum = delAlbum;
        [self getDeleteDicOrArray:delArray];
    }
    return self;
}

- (void)getDeleteDicOrArray:(NSArray *)delArray {
    if (isDelete) {
        if (delArray != nil && delArray.count > 0) {
            if (removePhotos != nil) {
                [removePhotos release];
                removePhotos = nil;
            }
            removePhotos = [[NSMutableArray alloc] init];
            for (IMBTrack *track in delArray) {
                [removePhotos addObject:[NSNumber numberWithInt:track.photoZpk]];
            }
        }
    }
    if (isDeleteAlbum) {
        if (delArray != nil && delArray.count > 0) {
            if (removeAlbums != nil) {
                [removeAlbums release];
                removeAlbums = nil;
            }
            removeAlbums = [[NSMutableDictionary alloc] init];
            NSMutableArray *albumZpkArray = [[NSMutableArray alloc] init];
            NSMutableArray *photoZpkArray = [[NSMutableArray alloc] init];
            for (IMBTrack *track in delArray) {
                [albumZpkArray addObject:[NSNumber numberWithInt:track.albumZpk]];
                NSMutableArray *pArray = [self queryPhotoKeyData:track.albumZpk];
                [photoZpkArray addObjectsFromArray:pArray];
            }
            [removeAlbums setObject:albumZpkArray forKey:@"albumZpks"];
            [removeAlbums setObject:photoZpkArray forKey:@"photoZpks"];
            [albumZpkArray release];
            [photoZpkArray release];
        }
    }
}

- (void)dealloc
{
    [self closeDataBase];
    if (db != nil) {
        [db release];
        db = nil;
    }
    if (removePhotos != nil) {
        [removePhotos release];
        removePhotos = nil;
    }
    if (removeAlbums != nil) {
        [removeAlbums release];
        removeAlbums = nil;
    }
    if (_dateArray != nil) {
        [_dateArray release];
        _dateArray = nil;
    }
    [super dealloc];
}

- (BOOL)openConnectSQLiteDB {
    BOOL result = NO;
    if ([fm fileExistsAtPath:sqlPath]) {
        db = [[FMDatabase databaseWithPath:sqlPath] retain];
        if ([db open]) {
            [db setShouldCacheStatements:NO];
            [db setTraceExecution:NO];
            result = YES;
        }else {
            db = nil;
        }
    }else {
        db = nil;
    }
    return result;
}

- (void)closeDataBase {
    if (db != nil) {
        [db close];
        [db release];
        db = nil;
    }
}

- (NSString *)copySqliteToTemp {
    AFCMediaDirectory *afcMeadia = [_iPod.deviceHandle newAFCMediaDirectory];
    NSString *filePath = nil;
    //将数据库拷贝指定的路径
    if ([afcMeadia fileExistsAtPath:Photosqlite]) {
        filePath = [_tmpPath stringByAppendingPathComponent:@"Photos.sqlite"];
        if ([fm fileExistsAtPath:filePath]) {
            [fm removeItemAtPath:filePath error:nil];
        }
        BOOL issuccess = [afcMeadia copyRemoteFile:Photosqlite toLocalFile:filePath];
        if (issuccess) {
            if ([afcMeadia fileExistsAtPath:Photosqliteshm]) {
                NSString *filePathSHM = [_tmpPath stringByAppendingPathComponent:@"Photos.sqlite-shm"];
                if ([fm fileExistsAtPath:filePathSHM]) {
                    [fm removeItemAtPath:filePathSHM error:nil];
                }
                [afcMeadia copyRemoteFile:Photosqliteshm toLocalFile:filePathSHM];
            }
            if ([afcMeadia fileExistsAtPath:Photosqlitewal]) {
                NSString *filePathWAL = [_tmpPath stringByAppendingPathComponent:@"Photos.sqlite-wal"];
                if ([fm fileExistsAtPath:filePathWAL]) {
                    [fm removeItemAtPath:filePathWAL error:nil];
                }
                [afcMeadia copyRemoteFile:Photosqlitewal toLocalFile:filePathWAL];
            }
        }
    }
    [afcMeadia close];
    return filePath;
}

- (NSString *)createPhotoSyncPlistFile {
    NSDictionary *plistDic = nil;
    @autoreleasepool {
        plistDic = [[self getPlistDictionary] retain];
    }
    NSString *outPutTemp = [self savePlistToPath:plistDic];
    [plistDic release];
    return  outPutTemp;
}

//plist文件存放的到指定路径
-(NSString *)savePlistToPath:(NSDictionary *)plistDic {
    NSString *outPutTemp = [_tmpPath stringByAppendingPathComponent:@"PhotoLibrary.plist"];
    if ([fm fileExistsAtPath:outPutTemp]) {
        [fm removeItemAtPath:outPutTemp error:nil];
    }
    if (plistDic != nil) {
        NSString *err = nil;
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDic format:NSPropertyListBinaryFormat_v1_0 errorDescription:&err];
        if(plistData != nil) {
            [plistData writeToFile:outPutTemp atomically:NO];
        } else {
            [logHandle writeInfoLog:[NSString stringWithFormat:@"NSPropertyListSerialization error: %@", err]];
        }
    }else{
        [logHandle writeInfoLog:@"plist file is nil"];
        outPutTemp = nil;
    }
    return  outPutTemp;
}

//获取的plist文件dictionary
-(NSMutableDictionary *)getPlistDictionary {
    NSMutableDictionary *plistDictionary = [[[NSMutableDictionary alloc]init]autorelease];
    [plistDictionary setObject:@"Folder" forKey:@"libraryKind"];
    NSString *libraryUUID = [self getPhotoLibraryUUID];
    [logHandle writeInfoLog:[NSString stringWithFormat:@"Library UUID: %@", libraryUUID]];
    if (libraryUUID != nil) {
        [plistDictionary setObject:libraryUUID forKey:@"libraryUUID"];
        NSArray *updatesData = [self getPhotoPlistData];
        if (updatesData != nil && updatesData.count > 0) {
            [plistDictionary setObject:updatesData forKey:@"updates"];
        }else {
            [logHandle writeInfoLog:@"updatesData is nil"];
            plistDictionary = nil;
        }
    }else {
        [logHandle writeInfoLog:@"libraryUUID is nil"];
        plistDictionary = nil;
    }
    return plistDictionary;
}

//获取libraryuuid
-(NSString *)getPhotoLibraryUUID {
    AFCMediaDirectory *mediaDir = [_iPod.deviceHandle newAFCMediaDirectory];
    NSString *libraryUUID = nil;
    NSString *libraryUUIDTemp = @"/Photos/Sync/CurrentLibraryUUID.plist";
    if ([mediaDir fileExistsAtPath:libraryUUIDTemp]) {
        NSString *temp = [_tmpPath stringByAppendingPathComponent:@"CurrentLibraryUUID.plist"];
        if ([fm fileExistsAtPath:temp]) {
            [fm removeItemAtPath:temp error:nil];
        }
        [mediaDir copyRemoteFile:libraryUUIDTemp toLocalFile:temp];
        if ([fm fileExistsAtPath:temp]) {
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:temp];
            if (dic != nil) {
                libraryUUID = [dic objectForKey:@"libraryUUID"];
            }
        }
    }else{
        //从数据库中读取
        libraryUUID = [self getSQliteLibraryUUID];
    }
    [mediaDir close];
    return libraryUUID;
}

//从数据库中读取libraryuuid
-(NSString *)getSQliteLibraryUUID{
    NSString *libraryUUID = nil;
    FMResultSet *rs = [db executeQuery:@"select Z_UUID from Z_METADATA"];
    while ([rs next]) {
        libraryUUID = [rs stringForColumn:@"Z_UUID"];
    }
    [rs close];
    
    return libraryUUID;
}

//获取photoplist数据
-(NSMutableArray *)getPhotoPlistData {
    int photoLibraryZpk = 0;
    NSMutableArray *plistArray = [[[NSMutableArray alloc] init] autorelease];
    if ([fm fileExistsAtPath:sqlPath]) {
        [logHandle writeInfoLog:@"Query Sync AlbumData"];
        NSMutableArray *albumDataArray = [self queryAlbumData];
        if (albumDataArray != nil && albumDataArray.count > 0) {
            [logHandle writeInfoLog:@"Query PhotoDataBase Album"];
            //查找其他相册数据
            NSMutableDictionary *allPhotoDictionary = [[NSMutableDictionary alloc]init];
            NSMutableArray *otherAlbumArray = [[NSMutableArray alloc]init];
            //得到同步导入（1550）的相册，装在otherAlbumArray数组中
            for (int i=0; i<albumDataArray.count; i++) {
                IMBSyncPhotoData *data = [albumDataArray objectAtIndex:i];
                if (data.albumKind != 1552) {
                    [otherAlbumArray addObject:data];
                }else{
                    photoLibraryZpk = data.albumZpk;
                }
            }
            
            if (otherAlbumArray != nil && otherAlbumArray.count > 0) {
                if (isDeleteAlbum) {
                    NSArray *delAlbumZpkArray = [removeAlbums objectForKey:@"albumZpks"];
                    for (int idx = (int)delAlbumZpkArray.count - 1; idx >= 0; idx--) {
                        int delAlbumZpk = [[delAlbumZpkArray objectAtIndex:idx] intValue];
                        for (int idy = (int)otherAlbumArray.count - 1; idy >= 0; idy --) {
                            IMBSyncPhotoData *data = [otherAlbumArray objectAtIndex:idy];
                            if (delAlbumZpk == data.albumZpk) {
                                [otherAlbumArray removeObject:data];
                                break;
                            }
                        }
                    }
                }
                for (int i = 0; i < otherAlbumArray.count; i++) {
                    IMBSyncPhotoData *data = [otherAlbumArray objectAtIndex:i];
                    //通过相册的zpk得到该相册下photo的zpk集
                    NSMutableArray *photoKeyArray = [self queryPhotoKeyData:data.albumZpk];
                    if (photoKeyArray != nil && photoKeyArray.count > 0) {
                        if (isDelete) {
                            if (removePhotos != nil && removePhotos.count > 0) {
                                for (int ide = (int)removePhotos.count - 1; ide >= 0; ide--) {
                                    int delPhotoZpk = [[removePhotos objectAtIndex:ide] intValue];
                                    for (int idf = (int)photoKeyArray.count - 1; idf >= 0; idf--) {
                                        IMBSyncPhotoData *pd = [photoKeyArray objectAtIndex:idf];
                                        if (delPhotoZpk == pd.photoZpk) {
                                            [photoKeyArray removeObject:pd];
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        //通过photo的zpk得到photo信息（uuid和date）
                        NSMutableArray *photoInfoArray = [self queryPhotoInfo:photoKeyArray];
                        if (photoInfoArray != nil && photoInfoArray.count > 0) {
                            [allPhotoDictionary setObject:photoInfoArray forKey:[NSString stringWithFormat:@"%d",data.albumZpk]];
                            NSArray *photoDicArray = [self createPhotoPlistDict:photoInfoArray];
                            if (photoDicArray != nil && photoDicArray.count > 0) {
                                for (int j = 0; j < photoDicArray.count; j++) {
                                    NSDictionary *photoDic = [photoDicArray objectAtIndex:j];
                                    [plistArray addObject:photoDic];
                                }
                            }
                        }else {
                            photoInfoArray = [[[NSMutableArray alloc] init] autorelease];
                            [allPhotoDictionary setObject:photoInfoArray forKey:[NSString stringWithFormat:@"%d", data.albumZpk]];
                        }
                    }
                }
            }
            [logHandle writeInfoLog:@"Query PhotoDataBase PhotoLibrary"];
            //查询photo library单独存在的照片的数据
            NSMutableArray *photoLibArray = [self queryPhotoLibraryInfo:otherAlbumArray];
            if (isDelete) {
                if (removePhotos != NULL && removePhotos.count > 0 && photoLibArray != NULL && photoLibArray.count > 0) {
                    for (int idj = (int)removePhotos.count - 1; idj >= 0; idj--) {
                        int delPhotoZpk = [[removePhotos objectAtIndex:idj] intValue];
                        for (int idk = (int)photoLibArray.count - 1; idk >= 0; idk--) {
                            IMBSyncPhotoData *pd = [photoLibArray objectAtIndex:idk];
                            if (delPhotoZpk == pd.photoZpk) {
                                [photoLibArray removeObject:pd];
                                break;
                            }
                        }
                    }
                }
            }else if(isDeleteAlbum) {
                //删除要被删除的相册里对应photolibrary的照片
                if (removeAlbums != nil && removeAlbums.count > 0) {
                    NSArray *photoZpkArray = [removeAlbums objectForKey:@"photoZpks"];
                    if (photoZpkArray != nil && photoZpkArray.count > 0) {
                        for (int k = (int)photoZpkArray.count - 1; k >= 0; k--) {
                            IMBSyncPhotoData *delZpk = [photoZpkArray objectAtIndex:k];
                            for (int m = (int)photoLibArray.count - 1;m >= 0;m--) {
                                IMBSyncPhotoData *photoInfo = [photoLibArray objectAtIndex:m];
                                if (delZpk.photoZpk == photoInfo.photoZpk) {
                                    [photoLibArray removeObject:photoInfo];
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            if (photoLibArray != nil && photoLibArray.count > 0) {
                NSArray *photoDicArray = [self createPhotoPlistDict:photoLibArray];
                if (photoDicArray != nil && photoDicArray.count > 0) {
                    for (int jdy = 0; jdy < photoDicArray.count; jdy++) {
                        NSDictionary *photoDictionary = [photoDicArray objectAtIndex:jdy];
                        [plistArray addObject:photoDictionary];
                    }
                }
            }
            //创建相册信息，将photo分别添加到相册的plist中
            if (isDeleteAlbum) {
                NSArray *albumZpkArray = [removeAlbums objectForKey:@"albumZpks"];
                for (int idl = 0; idl < albumZpkArray.count; idl++) {
                    int delAlbumZpk = [[albumZpkArray objectAtIndex:idl]intValue];
                    for (int idm = (int)albumDataArray.count - 1; idm >= 0; idm--) {
                        IMBSyncPhotoData *pd = [albumDataArray objectAtIndex:idm];
                        if (delAlbumZpk == pd.albumZpk) {
                            [albumDataArray removeObject:pd];
                            break;
                        }
                    }
                }
            }
            [logHandle writeInfoLog:@"Create Album Dictionary"];
            NSArray *albumDicArray = [self createAlbumDicrionary:albumDataArray allPhotoDictionary:allPhotoDictionary photoLibArray:photoLibArray];
            if (albumDicArray != nil && albumDicArray.count > 0) {
                for (int jdz = 0; jdz < albumDicArray.count; jdz++) {
                    NSDictionary *albumDictionary = [albumDicArray objectAtIndex:jdz];
                    [plistArray addObject:albumDictionary];
                }
            }
            [allPhotoDictionary release];
            [otherAlbumArray release];

        }
    }
    return plistArray;
}

//查询相册信息
-(NSMutableArray *)queryAlbumData {
    NSMutableArray *albumArray = [[[NSMutableArray alloc] init] autorelease];
    FMResultSet *rs = [db executeQuery:@"select Z_PK,ZTITLE,ZKIND,ZUUID from ZGENERICALBUM where ZKIND = 1550 or ZKIND =1552"];
    
    while ([rs next]) {
        IMBSyncPhotoData *info = [[IMBSyncPhotoData alloc]init];
        if (![rs columnIsNull:@"Z_PK"]) {
            info.albumZpk = [rs intForColumn:@"Z_PK"];
        }
        if (![rs columnIsNull:@"ZKIND"]) {
            info.albumKind = [rs intForColumn:@"ZKIND"];
        }
        if (info.albumKind == 1552) {
            info.albumName = @"Photo Library";
        }else {
            if (![rs columnIsNull:@"ZTITLE"]) {
                info.albumName = [rs stringForColumn:@"ZTITLE"];
            }
        }
        if ([_iPod.deviceHandle.productVersion isVersionMajorEqual:@"8"]) {
            if (![rs columnIsNull:@"ZUUID"]) {
                info.albumUUID = [rs stringForColumn:@"ZUUID"];
            }
        }else {
            if (![rs columnIsNull:@"ZUUID"]) {
                info.albumUUID = [MediaHelper createPhotoUUID:[StringHelper NSDatatoNSString:[rs dataForColumn:@"ZUUID"]]];
            }
        }
        [albumArray addObject:info];
        [info release];
    }
    [rs close];
    
    return albumArray;
}

//查询相册里相片对应的zpk
-(NSMutableArray *)queryPhotoKeyData:(int)albumZpk {
    NSMutableArray *pKeyArray = [[[NSMutableArray alloc]init]autorelease];
    NSString *version = _iPod.deviceHandle.productVersion;
    if (version == nil) {
        return nil;
    }
    if([version hasPrefix:@"5"]) {
        pKeyArray = [self getPhotoZpk:@"Z_6ASSETS" albumName:@"Z_6ALBUMS" albumZpk:albumZpk photoName:@"Z_11ASSETS"];
    }else if ([version hasPrefix:@"6"]) {
        pKeyArray = [self getPhotoZpk:@"Z_8ASSETS" albumName:@"Z_8ALBUMS" albumZpk:albumZpk photoName:@"Z_14ASSETS"];
    }else if ([version hasPrefix:@"7"]) {
        pKeyArray = [self getPhotoZpk:@"Z_11ASSETS" albumName:@"Z_11ALBUMS" albumZpk:albumZpk photoName:@"Z_17ASSETS"];
    }else if ([version isVersionMajorEqual:@"8"]) {
        if ([version hasPrefix:@"8.3"]) {
             pKeyArray = [self getPhotoZpk:@"Z_17ASSETS" albumName:@"Z_17ALBUMS" albumZpk:albumZpk photoName:@"Z_24ASSETS"];
        }else if ([version isVersionMajorEqual:@"9.2"] && [version isVersionLess:@"10"]) {
            pKeyArray = [self getPhotoZpk:@"Z_15ASSETS" albumName:@"Z_15ALBUMS" albumZpk:albumZpk photoName:@"Z_22ASSETS"];
        }else if ([version isVersionMajorEqual:@"10"]){
            if ([self checkASSETSIdExist:@"Z_19ASSETS"]) {
                pKeyArray = [self getPhotoZpk:@"Z_19ASSETS" albumName:@"Z_19ALBUMS" albumZpk:albumZpk photoName:@"Z_26ASSETS"];
            }else{
                if ([version isVersionMajorEqual:@"10.3"]) {
                    pKeyArray = [self getPhotoZpk:@"Z_20ASSETS" albumName:@"Z_20ALBUMS" albumZpk:albumZpk photoName:@"Z_27ASSETS"];
                }else {
                    pKeyArray = [self getPhotoZpk:@"Z_18ASSETS" albumName:@"Z_18ALBUMS" albumZpk:albumZpk photoName:@"Z_25ASSETS"];
                }
            }
        }else
        {
             pKeyArray = [self getPhotoZpk:@"Z_16ASSETS" albumName:@"Z_16ALBUMS" albumZpk:albumZpk photoName:@"Z_23ASSETS"];
        }
    }
    return pKeyArray;
}

- (BOOL)checkASSETSIdExist:(NSString *)tableName
{
    NSString *sql = @"select name from sqlite_master where name =:tableName and type = 'table'";
    FMResultSet *set = [db executeQuery:sql withParameterDictionary:[NSDictionary dictionaryWithObject:tableName forKey:@"tableName"]];
    NSString *name = nil;
    while ([set next]) {
        name = [set stringForColumn:@"name"];
    }
    if (name) {
        return YES;
    }else{
        return NO;
    }
    [set close];
}


//得到对应照片的zpk
-(NSMutableArray *)getPhotoZpk:(NSString *)tableName albumName:(NSString *)albumName albumZpk:(int)albumZpk photoName:(NSString *)photoName{
    NSMutableArray *zpkArray = [[[NSMutableArray alloc] init] autorelease];
    NSMutableString *string = [NSMutableString stringWithCapacity:50];
    [string appendString:@"SELECT * FROM "];
    [string appendString:tableName];
    [string appendString:@" WHERE "];
    [string appendString:albumName];
    [string appendString:@" = "];
    [string appendString:[NSString stringWithFormat:@"%d",albumZpk]];
    FMResultSet *rs = [db executeQuery:string];
    while ([rs next]) {
        IMBSyncPhotoData *info = [[IMBSyncPhotoData alloc] init];
        if (![rs columnIsNull:photoName]) {
            info.photoZpk = [rs intForColumn:photoName];
        }
        if (![rs columnIsNull:@"ZFILENAME"]) {
            info.photoName = [rs stringForColumn:@"ZFILENAME"];
        }
        [zpkArray addObject:info];
        [info release];
    }
    [rs close];
    return zpkArray;
}

//查询photo信息
-(NSMutableArray *)queryPhotoInfo:(NSMutableArray *)photoZpkArray {
    NSMutableArray *photoInfoArray = [[[NSMutableArray alloc] init] autorelease];
    if (photoZpkArray != nil && photoZpkArray.count > 0) {
        for (int idg = 0; idg < photoZpkArray.count; idg++) {
            IMBSyncPhotoData *data = [photoZpkArray objectAtIndex:idg];
            NSMutableString *string = [NSMutableString stringWithCapacity:50];
//            [string appendString:@"SELECT ZUUID,ZMODIFICATIONDATE,ZFILENAME,ZFAVORITE FROM ZGENERICASSET WHERE Z_PK="];
            [string appendString:@"SELECT ZUUID,ZMODIFICATIONDATE,ZFILENAME,ZORIGINALFILENAME,ZDATECREATED FROM ZGENERICASSET A LEFT OUTER JOIN ZADDITIONALASSETATTRIBUTES B WHERE A.Z_PK=B.ZASSET AND A.Z_PK="];
            [string appendString:[NSString stringWithFormat:@"%d",data.photoZpk]];
            FMResultSet *rs = [db executeQuery:string];
            while ([rs next]) {
                IMBSyncPhotoData *pd = [[IMBSyncPhotoData alloc]init];
                if (![rs columnIsNull:@"ZMODIFICATIONDATE"]) {
                    pd.photoDate = [rs longLongIntForColumn:@"ZMODIFICATIONDATE"] + 3061152000;
                }
                if (![rs columnIsNull:@"ZDATECREATED"]) {
                    pd.photoCreateDate = [rs longLongIntForColumn:@"ZDATECREATED"] + 3061152000;
                }
                if ([_iPod.deviceHandle.productVersion isVersionMajorEqual:@"8"]) {
                    if (![rs columnIsNull:@"ZUUID"]) {
                        pd.photoUUID = [rs stringForColumn:@"ZUUID"];
                    }
                }else {
                    if (![rs columnIsNull:@"ZUUID"]) {
                        pd.photoUUID = [MediaHelper createPhotoUUID:[StringHelper NSDatatoNSString:[rs dataForColumn:@"ZUUID"]]];
                    }
                }
                if (![rs columnIsNull:@"ZORIGINALFILENAME"]) {
                    pd.photoName = [rs stringForColumn:@"ZORIGINALFILENAME"];
                }
//                if (![rs columnIsNull:@"ZFAVORITE"]) {
//                    pd.isFavorite = [rs boolForColumn:@"ZFAVORITE"];
//                }
                [photoInfoArray addObject:pd];
                [pd release];
            }
            [rs close];
        }
    }
    return photoInfoArray;
}

//生成photoDict节点段
-(NSMutableArray *)createPhotoPlistDict:(NSArray *)photoInfoArray {
    NSMutableArray *plistDic = [[[NSMutableArray alloc] init] autorelease];
    for (int idh=0; idh<photoInfoArray.count; idh++) {
        IMBSyncPhotoData *data = [photoInfoArray objectAtIndex:idh];
        NSMutableDictionary *photoDic = [[NSMutableDictionary alloc] init];
        [photoDic setObject:@"Asset" forKey:@"itemType"];
        [photoDic setObject:@"" forKey:@"caption"];
        [photoDic setObject:[NSNumber numberWithLongLong: data.photoDate] forKey:@"modificationDate"];
        [photoDic setObject:[NSNumber numberWithBool:NO] forKey:@"isVideo"];
        [photoDic setObject:[NSNumber numberWithDouble:1.0/0.0] forKey:@"latitude"];
        [photoDic setObject:[NSNumber numberWithDouble:1.0/0.0] forKey:@"longitude"];
        [photoDic setObject:[NSNumber numberWithLongLong:data.photoCreateDate] forKey:@"exposureDate"];
//        [photoDic setObject:[NSNumber numberWithBool:data.isFavorite] forKey:@"isFavorite"];
        [photoDic setObject:data.photoUUID forKey:@"uuid"];
//        [photoDic setObject:data.photoName forKey:@"originalFileName"];
        [plistDic addObject:photoDic];
        [_dateArray addObject:[NSString stringWithFormat:@"%lld",data.photoDate]];
        [photoDic release];
    }
    return plistDic;
}

//查询photo library单独存在的照片
-(NSMutableArray *)queryPhotoLibraryInfo:(NSArray *)otherAlbumArray {
    NSString *version = _iPod.deviceHandle.productVersion;
    if (version == nil) {
        return nil;
    }
    NSMutableArray *plArray = [[[NSMutableArray alloc] init] autorelease];
    NSMutableString *string = [NSMutableString stringWithCapacity:150];
    NSString *albumField = @"";
//    [string appendString:@"SELECT Z_PK,ZUUID,ZMODIFICATIONDATE,ZFILENAME,ZFAVORITE FROM ZGENERICASSET WHERE ZSAVEDASSETTYPE=256"];
    [string appendString:@"SELECT A.Z_PK,ZUUID,ZMODIFICATIONDATE,ZFILENAME,ZORIGINALFILENAME,ZDATECREATED FROM ZGENERICASSET A LEFT OUTER JOIN ZADDITIONALASSETATTRIBUTES B WHERE A.Z_PK=B.ZASSET AND ZSAVEDASSETTYPE=256"];
    if (otherAlbumArray != nil && otherAlbumArray.count > 0) {
        if([version hasPrefix:@"5"]) {
            [string appendString:@" AND A.Z_PK NOT IN (SELECT Z_11ASSETS FROM Z_6ASSETS WHERE "];
            albumField = @"Z_6ALBUMS=";
        }else if ([version hasPrefix:@"6"]) {
            [string appendString:@" AND A.Z_PK NOT IN (SELECT Z_14ASSETS FROM Z_8ASSETS WHERE "];
            albumField = @"Z_8ALBUMS=";
        }else if ([version hasPrefix:@"7"]) {
            [string appendString:@" AND A.Z_PK NOT IN (SELECT Z_17ASSETS FROM Z_11ASSETS WHERE "];
            albumField = @"Z_11ALBUMS=";
        }else if ([version isVersionMajorEqual:@"8"]) {
            if ([version hasPrefix:@"8.3"]) {
                [string appendString:@" AND A.Z_PK NOT IN (SELECT Z_24ASSETS FROM Z_17ASSETS WHERE "];
                albumField = @"Z_17ALBUMS=";

            }else if ([version isVersionMajorEqual:@"9.2"] && [version isVersionLess:@"10"]) {
                [string appendString:@" AND A.Z_PK NOT IN (SELECT Z_22ASSETS FROM Z_15ASSETS WHERE "];
                albumField = @"Z_15ALBUMS=";
            }else if ([version isVersionMajorEqual:@"10"]) {
                if ([self checkASSETSIdExist:@"Z_19ASSETS"]) {
                    [string appendString:@" AND A.Z_PK NOT IN (SELECT Z_26ASSETS FROM Z_19ASSETS WHERE "];
                    albumField = @"Z_19ALBUMS=";
                }else{
                    if ([version isVersionMajorEqual:@"10.3"]) {
                        [string appendString:@" AND A.Z_PK NOT IN (SELECT Z_27ASSETS FROM Z_20ASSETS WHERE "];
                        albumField = @"Z_20ALBUMS=";
                    }else {
                        [string appendString:@" AND A.Z_PK NOT IN (SELECT Z_25ASSETS FROM Z_18ASSETS WHERE "];
                        albumField = @"Z_18ALBUMS=";
                    }
                }
                
            }else {
                [string appendString:@" AND A.Z_PK NOT IN (SELECT Z_23ASSETS FROM Z_16ASSETS WHERE "];
                albumField = @"Z_16ALBUMS=";
            }
            
           
        }
        for (int idi=0; idi<otherAlbumArray.count; idi++) {
            IMBSyncPhotoData *pd = [otherAlbumArray objectAtIndex:idi];
            [string appendString:albumField];
            [string appendString:[NSString stringWithFormat:@"%d",pd.albumZpk]];
            if (idi + 1 < otherAlbumArray.count) {
                [string appendString:@" OR "];
            }
        }
        [string appendString:@") AND ZTHUMBNAILINDEX>=0"];
    }
    NSLog(@"string:%@",string);
    FMResultSet *rs = [db executeQuery:string];
    while ([rs next]) {
        IMBSyncPhotoData *info = [[IMBSyncPhotoData alloc]init];
        if (![rs columnIsNull:@"Z_PK"]) {
            info.photoZpk = [rs intForColumn:@"Z_PK"];
        }
        if (![rs columnIsNull:@"ZMODIFICATIONDATE"]) {
            info.photoDate = [rs longLongIntForColumn:@"ZMODIFICATIONDATE"] + 3061152000;
        }
        if (![rs columnIsNull:@"ZDATECREATED"]) {
            info.photoCreateDate = [rs longLongIntForColumn:@"ZDATECREATED"] + 3061152000;
        }
        if ([version isVersionMajorEqual:@"8"]) {
            if (![rs columnIsNull:@"ZUUID"]) {
                info.photoUUID = [rs stringForColumn:@"ZUUID"];
            }
        }else {
            if (![rs columnIsNull:@"ZUUID"]) {
                info.photoUUID = [MediaHelper createPhotoUUID:[StringHelper NSDatatoNSString:[rs dataForColumn:@"ZUUID"]]];
            }
        }
        if (![rs columnIsNull:@"ZORIGINALFILENAME"]) {
            info.photoName = [rs stringForColumn:@"ZORIGINALFILENAME"];
        }
//        if (![rs columnIsNull:@"ZFAVORITE"]) {
//            info.isFavorite = [rs boolForColumn:@"ZFAVORITE"];
//        }
        [plArray addObject:info];
        [info release];
    }
    [rs close];
    return plArray;
}

//创建album的字典集合
-(NSMutableArray *)createAlbumDicrionary:(NSArray *)albumArray allPhotoDictionary:(NSDictionary *)allPhotoDic photoLibArray:(NSArray *)photoLibArray{
    NSMutableArray *plistDic = [[[NSMutableArray alloc] init] autorelease];
    if (albumArray != nil && albumArray.count > 0 && allPhotoDic != nil) {
        int subCladdNum = 0;
        for (int idn=0; idn<albumArray.count; idn++) {
            IMBSyncPhotoData *pd = [albumArray objectAtIndex:idn];
            if (pd.albumKind != 2) {
                NSMutableArray *photoListArray = [[NSMutableArray alloc] init];
                NSMutableDictionary *albumDic = [[NSMutableDictionary alloc] init];
                if (pd.albumKind == 1552) {
                    subCladdNum = 5;
                    pd.albumName = @"My Pictures";
                    pd.albumUUID = @"00000000-0000-0000-0000-000000000064";
                    if (photoLibArray != nil && photoLibArray.count > 0) {
                        [photoListArray addObject:photoLibArray];
                    }
                    for (int ido=0; ido<albumArray.count; ido++) {
                        IMBSyncPhotoData *pd1 = [albumArray objectAtIndex:ido];
                        if (pd1.albumZpk != pd.albumZpk) {
                            NSArray *allKey = [allPhotoDic allKeys];
                            for (int idp=0; idp<allKey.count; idp++) {
                                NSString *keyString = [allKey objectAtIndex:idp];
                                if ([keyString isEqualToString:[NSString stringWithFormat:@"%d",pd1.albumZpk]]) {
                                    [photoListArray addObject:[allPhotoDic objectForKey:[NSString stringWithFormat:@"%d",pd1.albumZpk]]];
                                }
                            }
                        }
                    }
                }else{
                    subCladdNum = 1;
                    NSArray *allKey = [allPhotoDic allKeys];
                    for (int idp=0; idp<allKey.count; idp++) {
                        NSString *keyString = [allKey objectAtIndex:idp];
                        if ([keyString isEqualToString:[NSString stringWithFormat:@"%d",pd.albumZpk]]) {
                            [photoListArray addObject:[allPhotoDic objectForKey:[NSString stringWithFormat:@"%d",pd.albumZpk]]];
                        }
                    }
                }
                [albumDic setObject:pd.albumName forKey:@"albumName"];
                [albumDic setObject:pd.albumUUID forKey:@"uuid"];
                [albumDic setObject:@"Album" forKey:@"itemType"];
                [albumDic setObject:[NSNumber numberWithInt: subCladdNum] forKey:@"subclass"];
                if (photoListArray != NULL && photoListArray.count > 0) {
                    NSArray *aArray = [self getPhotoUUID:photoListArray];
                    [albumDic setObject:aArray forKey:@"assetUUIDs"];
                }
                [plistDic addObject:albumDic];
                [photoListArray release];
                [albumDic release];
            }
        }
    }
    return plistDic;
}

//创建空相册
-(NSMutableDictionary *)createNullAlbumInfo:(NSString *)albumName MaxAlbumUUID:(NSString *)albumUUID {
    NSMutableDictionary *albumDictionary = [[[NSMutableDictionary alloc]init]autorelease];
    [albumDictionary setObject:albumName forKey:@"albumName"];
    [albumDictionary setObject:@"Album" forKey:@"itemType"];
    [albumDictionary setObject:[NSNumber numberWithInt:1] forKey:@"subclass"];
    if (albumUUID == nil) {
         albumUUID = [self getMaxAlbumUUID];
    }
    [albumDictionary setObject:albumUUID forKey:@"uuid"];
    return albumDictionary;
}

//得到pootos的uuid集合
-(NSArray *)getPhotoUUID:(NSArray *)photoListArray{
    NSMutableArray *aArray = [[[NSMutableArray alloc]init]autorelease];
    for (int i=0; i<photoListArray.count; i++) {
        NSArray *larray = [photoListArray objectAtIndex:i];
        for (int j=0; j<larray.count; j++) {
            IMBSyncPhotoData *pd = [larray objectAtIndex:j];
            if(pd.photoUUID != nil){
                [aArray addObject:pd.photoUUID];
            }
        }
    }
    return aArray;
}

//iOS8 读出的uuid就是string类型，还未区分
//得到album最大的uuid+1的nsstring
-(NSString *)getMaxAlbumUUID{
    NSString *string = nil;
    NSData *data = nil;
    FMResultSet *rs = [db executeQuery:@"select max(ZUUID) ZUUID from ZGENERICASSET where Z_PK in (select z_pk from ZGENERICASSET where ZDIRECTORY like '%Sync%')"];
    while([rs next]){
        if ([_iPod.deviceInfo.productVersion isVersionMajorEqual:@"8"]) {
            if (![rs columnIsNull:@"ZUUID"]) {
                string = [rs stringForColumn:@"ZUUID"];
            }else {
                string = @"";
            }
        }else {
            if (![rs columnIsNull:@"ZUUID"]) {
                data = [rs dataForColumn:@"ZUUID"];
                string = [self getMaxUUIDAdd1:data];
            }else {
                string = @"";
            }
        }
    }
    [rs close];
    if ([StringHelper stringIsNilOrEmpty:string]) {
        string = @"00000000-0000-0000-0000-000000000067";
    }
    return string;
}

//maxuuid+1
-(NSString *)getMaxUUIDAdd1:(NSData *)maxUUID{
    Byte bit[maxUUID.length];
    [maxUUID getBytes:bit length:maxUUID.length];
    int int16last = bit[maxUUID.length - 1]&0xff;
    int int16 = bit[maxUUID.length - 2]&0xff;
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
    NSString *uuid = [MediaHelper createPhotoUUID:hexStr];
    return uuid;
//    return hexStr;
}

//得到photo最大的uuid
-(NSData *)getMaxZ_PKUUID{
    NSData *data = nil;
    FMResultSet *rs = [db executeQuery:@"select max(ZUUID) ZUUID from ZGENERICASSET where Z_PK in (select z_pk from ZGENERICASSET where ZDIRECTORY like '%Sync%')"];
    while([rs next]){
        if ([_iPod.deviceInfo.productVersion isVersionMajorEqual:@"8"]) {
            if (![rs columnIsNull:@"ZUUID"]) {
                NSString *string = [rs stringForColumn:@"ZUUID"];
                string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
                data = [MediaHelper My16NSStringToNSData:string];
            }
        }else {
            if (![rs columnIsNull:@"ZUUID"]) {
                data = [rs dataForColumn:@"ZUUID"];
            }
        }
    }
    [rs close];
    if (data == nil||data.length == 0) {
        data = [NSData intToBytes:0x00000066];
    }
    return data;
}

//获得photo中已存在的UUID
- (NSMutableArray *)getAllUUID {
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    FMResultSet *rs = [db executeQuery:@"select ZDIRECTORY, ZFILENAME, ZUUID from ZGENERICASSET where Z_PK in (select z_pk from ZGENERICASSET where ZDIRECTORY like '%Sync%')"];
    while([rs next]){
        if ([_iPod.deviceInfo.productVersion isVersionMajorEqual:@"8"]) {
            IMBSyncPhotoData *pd = [[IMBSyncPhotoData alloc] init];
            if (![rs columnIsNull:@"ZUUID"]) {
                NSString *string = [rs stringForColumn:@"ZUUID"];
                [pd setPhotoUUID:string];
            }
            if (![rs columnIsNull:@"ZDIRECTORY"] && ![rs columnIsNull:@"ZFILENAME"]) {
                [pd setPhotoName:[[rs stringForColumn:@"ZDIRECTORY"] stringByAppendingPathComponent:[rs stringForColumn:@"ZFILENAME"]]];
            }
            [array addObject:pd];
            [pd release];
            pd = nil;
        }
    }
    [rs close];
    return array;
}

@end
