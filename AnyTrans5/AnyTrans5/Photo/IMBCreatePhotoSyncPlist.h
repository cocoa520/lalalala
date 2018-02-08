//
//  IMBCreatePhotoSyncPlist.h
//  iMobieTrans
//
//  Created by iMobie on 7/11/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "IMBiPod.h"
#import "IMBLogManager.h"

@interface IMBCreatePhotoSyncPlist : NSObject {
    BOOL isDelete;
    BOOL isDeleteAlbum;
    NSMutableDictionary *removeAlbums;
    NSMutableArray *removePhotos;
    NSMutableArray *uuidArray;
    NSString *sqlPath;
    NSFileManager *fm;
    FMDatabase *db;
    IMBiPod *_iPod;
    IMBLogManager *logHandle;
    NSString *_tmpPath;
    NSMutableArray *_dateArray;
}
@property (nonatomic, retain) NSMutableArray *dateArray;

- (id)initWithiPod:(IMBiPod *)ipod;
- (id)initWithiPod:(IMBiPod *)ipod deleteArray:(NSArray *)delArray isDeletePhoto:(BOOL)delPhoto isDeleteAlbum:(BOOL)delAlbum ;

- (NSString *)createPhotoSyncPlistFile;
//plist文件存放的到指定路径
-(NSString *)savePlistToPath:(NSDictionary *)plistDic;
//获取的plist文件dictionary
-(NSMutableDictionary *)getPlistDictionary;
//得到photo最大的uuid
-(NSData *)getMaxZ_PKUUID;
//得到album最大的uuid+1的nsstring
-(NSString *)getMaxAlbumUUID;
//maxuuid+1
-(NSString *)getMaxUUIDAdd1:(NSData *)maxUUID;
//获得photo中已存在的UUID
- (NSMutableArray *)getAllUUID;
//创建空相册
-(NSMutableDictionary *)createNullAlbumInfo:(NSString *)albumName MaxAlbumUUID:(NSString *)albumUUID ;
@end
