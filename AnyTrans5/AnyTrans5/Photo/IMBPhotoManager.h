//
//  IMBPhotoManager.h
//  iMobieTrans
//
//  Created by iMobie on 14-3-5.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBMBDBParse.h"
#import "MobileDeviceAccess.h"
#import "IMBPhotoEntity.h"
#import "IMBSqliteManager.h"
#import "IMBiPod.h"
@interface IMBPhotoManager : IMBSqliteManager {
    IMBiPod *_ipod;
    BOOL _isHaveCameraRollAlbum;
    BOOL _isBackup;
    NSMutableArray *_photoDataAry ;
    BOOL _isicloud;
    
    BOOL _isiCloudPhoto;
}
@property (nonatomic, readwrite) BOOL isiCloudPhoto;

- (id)initWithiPod:(IMBiPod *)iPod;

- (NSMutableArray *)getAlbumsInfo;
- (NSMutableArray *)queryAlbumPhotosCount:(NSMutableArray *)array;
- (NSMutableArray *)getPhotoInfoByAlbum:(IMBPhotoEntity *)entity;
- (NSMutableArray *)queryPhotoDetailedInfo:(FMResultSet *)rs withAlbumInfo:(IMBPhotoEntity *)albumInfo withSqlText:(NSString *)sqlText ;
- (id)initVersion:(NSString *)iosVersion;
//得到连拍相册的各个相册
- (NSMutableArray *)getContinuousShootingAlbum;
- (NSMutableArray *)getContinuousShootings:(IMBPhotoEntity *)photoEntity;
@end
