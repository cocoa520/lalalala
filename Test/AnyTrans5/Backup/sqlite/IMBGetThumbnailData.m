//
//  IMBGetThumbnailData.m
//  iMobieTrans
//
//  Created by long on 16-9-14.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBGetThumbnailData.h"
#import "IMBBackupManager.h"
#import "IMBPhotoEntity.h"
#import "StringHelper.h"
@implementation IMBGetThumbnailData

- (id)initWithAMDevice:(AMDevice *)dev backupfilePath:(NSString *)backupfilePath  withDBType:(NSString *)type WithisEncrypted:(BOOL)isEncrypted withBackUpDecrypt:(IMBBackupDecrypt*)decypt{
    if ([super initWithAMDevice:dev backupfilePath:backupfilePath withDBType:type WithisEncrypted:isEncrypted withBackUpDecrypt:decypt]) {
        _isbackup = YES;
        _backUpPath = [backupfilePath retain];
        IMBBackupManager *manager = [IMBBackupManager shareInstance];
        manager.iosVersion = type;
        if (isEncrypted) {
            [decypt decryptSingleFile:@"CameraRollDomain" withFilePath:@"Media/PhotoData/Thumbnails/V2"];
            if (_backUpPath != nil) {
                [_backUpPath release];
                _backUpPath = nil;
            }
            _backUpPath = [decypt.outputPath retain];
        }
    }
    return self;
}

- (void)querySqliteDBContent {
    //扫描/PhotoData/Thumbnails/V2
    IMBBackupManager *manager = [IMBBackupManager shareInstance];
    [manager parseManifest:_backUpPath];
  
    for (IMBMBFileRecord *fr in manager.backFileArray) {
        if (fr.is_regular_file) {
            if ([StringHelper checkFileIsPicture:fr.path]) {
                IMBPhotoEntity *photoEntity = [[IMBPhotoEntity alloc] init];
                photoEntity.photoName = [fr.path lastPathComponent];
                photoEntity.allPath = [_backUpPath stringByAppendingPathComponent:fr.key];
                photoEntity.photoSize = fr.fileLength;
                photoEntity.thumbImagePath = photoEntity.allPath;
                photoEntity.oriPath = photoEntity.allPath;
                if ([fm fileExistsAtPath:photoEntity.oriPath]) {
                    [_dataAry addObject:photoEntity];
                }
                [photoEntity release];
                photoEntity = nil;
            }
        }
    }
}


@end
