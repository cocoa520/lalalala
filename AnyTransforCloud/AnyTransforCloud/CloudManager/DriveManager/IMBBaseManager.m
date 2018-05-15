//
//  IMBBaseCloudManager.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/23.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBBaseManager.h"
#import "IMBSearchManager.h"

@implementation IMBBaseManager
@synthesize baseDrive = _baseDrive;
@synthesize delegate = _delegete;
@synthesize searchDelegete = _searchDelegete;
- (id)initWithDrive:(BaseDrive *)drive {
    if ([super init]) {
        _baseDrive = drive;
        _photoSqlitePath = [[TempHelper getPhotoSqliteConfigPath:_baseDrive.driveID] retain];
        _storePhotoPath = [[TempHelper getPhotoSqliteConfigPath:_baseDrive.driveID] retain];
        _nc = [NSNotificationCenter defaultCenter];
    }
    return self;
}

#pragma mark -- 获取数据
- (void)loadData {
    
}

- (void)recursiveDirectoryContentsDics:(NSString *)folerID {
    
}

- (void)getAccount {
    
}

#pragma mark -- 功能方法
- (void)downloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    [_baseDrive downloadItem:item];
}

- (void)downloadItems:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items {
    [_baseDrive downloadItems:items];
}

- (void)cancelDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    [_baseDrive cancelDownloadItem:item];
}

- (void)uploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    [_baseDrive uploadItem:item];
}

- (void)uploadItems:(NSArray <id<DownloadAndUploadDelegate>>* _Nonnull)items {
    [_baseDrive uploadItems:items];
}

- (void)deleteDriveItem:(NSMutableArray *_Nonnull)deleteItemAry {
}

- (void)reName:(NSString *_Nonnull)newName idOrPathArray:(NSArray *_Nonnull)idOrPathArray withEntity:(nullable IMBDriveModel *)drviceEntity {
    //    [_baseDrive reName:newName idOrPathArray:idOrPathArray success:^(DriveAPIResponse *response) {
    //        NSLog(@"");
    //    } fail:^(DriveAPIResponse *response) {
    //        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
    //            [_delegete loadDriveDataFail:renameAction];
    //        }
    //    }];
}

- (void)searchContent:(NSString *_Nonnull)query withLimit:(NSString *_Nonnull)limit withPageIndex:(NSString *_Nonnull)pageIndex {
    [_baseDrive searchContent:query withLimit:limit withPageIndex:pageIndex success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = [response content];
        id nextPageStr = nil;
        if (dic.count >0) {
            if ([dic.allKeys containsObject:@"next_page_token"]) {
                nextPageStr = [dic objectForKey:@"next_page_token"] ;
            }
            
            NSMutableArray *ary = [dic objectForKey:@"data"];
            NSMutableArray *dataAry = [[NSMutableArray alloc]init];
            for (NSDictionary *dataDic in ary) {
                IMBDriveModel *drviceEntity = [[IMBDriveModel alloc]init];
                drviceEntity.sreachSize = [dataDic objectForKey:@"size"];
                [self createSreachEntity:drviceEntity ResDic:dataDic];
                [dataAry addObject:drviceEntity];
                [drviceEntity release];
                drviceEntity = nil;
            }
            [(IMBSearchManager *)_searchDelegete loadDriveComplete:dataAry withNextPageToken:nextPageStr withManager:self];
            [dataAry release];
            dataAry = nil;
        }
    } fail:^(DriveAPIResponse *response) {
        [(IMBSearchManager *)_searchDelegete loadDriveDataFail];
    }];
}

- (void)getFolderInfo:(NSString *_Nonnull)folerID {
    [_baseDrive getFolderInfo:folerID success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        NSMutableArray *fileIDAry = [[NSMutableArray alloc]init];
        NSString *fatherFileID = [dic objectForKey:@"parents"];
        [fileIDAry addObject:fatherFileID];
        [(IMBSearchManager *)_searchDelegete getFolderComplete:fileIDAry];
        [fileIDAry release];
        fileIDAry = nil;
    } fail:^(DriveAPIResponse *response) {
        [(IMBSearchManager *)_searchDelegete getFolderFail];
    }];
}

- (void)createSreachEntity:(IMBDriveModel *_Nonnull)drviceEntity ResDic:(NSDictionary *_Nonnull)dic {
    NSString *file_extension = [dic objectForKey:@"file_extension"];
    NSString *file_ID = [dic objectForKey:@"id"];
    NSString *name = [dic objectForKey:@"name"];
    NSString *sizeStr = [dic objectForKey:@"size"];
    NSString *type = [dic objectForKey:@"type"];
    drviceEntity.fileName = name;
    drviceEntity.displayName = [name stringByDeletingPathExtension];
    drviceEntity.extension = file_extension;
    drviceEntity.itemIDOrPath = file_ID;
    drviceEntity.fileID = file_ID;
    drviceEntity.driveID = self.baseDrive.driveID;
    drviceEntity.createdDateString = [self dateForm2001DateSting:[dic objectForKey:@"created_at"]];
    drviceEntity.sreachSize = sizeStr;
    if ([type.lowercaseString isEqualToString:@"folder"]) {
        drviceEntity.isFolder = YES;
        if ([name containsString:@".app" options:0]) {
            drviceEntity.fileTypeEnum = AppFile;
        }
    }else {
        if ([StringHelper stringIsNilOrEmpty:file_extension]) {
            drviceEntity.fileTypeEnum = CommonFile;
        }else {
             drviceEntity.fileTypeEnum = [TempHelper getFileFormatWithExtension:file_extension];
        }
    }
}

- (void)createFolder:(NSString *_Nonnull)folderName parent:(NSString *_Nonnull)parentID withEntity:(nullable IMBDriveModel *)drviceEntity {
    
}

- (void)copyToNewParentIDOrPath:(NSString * _Nonnull)newParentIdOrPath idOrPathArray:(NSArray * _Nonnull)idOrPathArray {
    [_baseDrive copyToNewParentIDOrPath:newParentIdOrPath idOrPathArray:idOrPathArray success:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:[NSMutableArray array] WithEvent:copyAction];
        }
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:copyAction];
        }
    }];
}

- (void)moveToNewParent:(NSString *_Nonnull)newParent idOrPaths:(NSArray *_Nonnull)idOrPaths {
    
}

- (void)toDrive:(BaseDrive * _Nonnull)targetDrive item:(NSMutableArray *)item {
    for (IMBDriveModel *driveItem in item) {
        [_baseDrive toDrive:targetDrive item:driveItem];
    }
}

- (void)cancelUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    [_baseDrive cancelUploadItem:item];
}

- (void)setDownloadPath:(NSString * _Nonnull)downloadPath {
    [_baseDrive setDownloadPath:downloadPath];
}

// 暂停正在下载的项
- (void)pauseDownloadItem:(_Nonnull id <DownloadAndUploadDelegate>)item {
    [_baseDrive pauseDownloadItem:item];
}

// 暂停所有的下载项
- (void)pauseAllDownloadItems {
    [_baseDrive pauseAllDownloadItems];
}

// 恢复下载项
- (void)resumeDownloadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    [_baseDrive resumeDownloadItem:item];
}

//恢复所有下载项
- (void)resumeAllDownloadItems {
    [_baseDrive resumeAllDownloadItems];
}

//暂停正在上传的项
- (void)pauseUploadItem:(_Nonnull id <DownloadAndUploadDelegate>)item {
    [_baseDrive pauseDownloadItem:item];
}

// 暂停所有的上传项
- (void)pauseAllUploadItems {
    [_baseDrive pauseAllUploadItems];
}

// 恢复上传项
- (void)resumeUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item {
    [_baseDrive resumeUploadItem:item];
}

// 恢复所有上传项
- (void)resumeAllUploadItems {
    [_baseDrive resumeAllUploadItems];
}

//取消所有下载
- (void)cancelAllDownloadItems {
    [_baseDrive cancelAllDownloadItems];
}

// 取消所有上传项
- (void)cancelAllUploadItems {
    [_baseDrive cancelAllUploadItems];
}

#pragma mark -- 图片sqlite
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    IMBDriveModel *item = object;
    if (item.state == DownloadStateComplete) {
        NSString *str = [_storePhotoPath stringByAppendingPathComponent:item.fileName];
        NSImage *dataImage = [[NSImage alloc ]initWithContentsOfFile:str];
        NSString *dataStr = @"";
        NSString *fileID = [NSString stringWithFormat:@"%@",item.itemIDOrPath];
        NSString *mdd5Name = [self md5:[_storePhotoPath stringByAppendingPathComponent:fileID]];
        if (dataImage.size.width < 88 && dataImage.size.height < 88) {
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:[_storePhotoPath stringByAppendingPathComponent:str]];
            item.image = [image retain];
            dataStr = str;
            if (image) {
                [image release];
                image = nil;
            }
        }else {
            NSImage *image12 =[[NSImage alloc]initWithData: [TempHelper scalingImage:dataImage withLenght:88]];
            NSData *endData = [image12 TIFFRepresentation];
            dataStr = mdd5Name;
            [endData writeToFile:[_storePhotoPath stringByAppendingPathComponent:dataStr] atomically:YES];
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:[_storePhotoPath stringByAppendingPathComponent:dataStr]];
            item.image = [image retain];
            [image12 release];
            image12 = nil;
            if (image) {
                [image release];
                image = nil;
            }
        }
        if (dataImage) {
            [dataImage release];
            dataImage = nil;
        }
        NSMutableData *otherData = [[NSMutableData alloc]initWithContentsOfFile:[_storePhotoPath stringByAppendingPathComponent:dataStr]];
        NSData *foruData = [otherData subdataWithRange:NSMakeRange(0, 32)];
        [otherData replaceBytesInRange:NSMakeRange(0, 32) withBytes:NULL length:0];
        [[NSFileManager defaultManager] removeItemAtPath:str error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[_storePhotoPath stringByAppendingPathComponent:dataStr] error:nil];
        [otherData writeToFile:[_storePhotoPath stringByAppendingPathComponent:dataStr] atomically:YES];
        [otherData release];
        otherData = nil;
        
        [_driveSqlite openDB];
        [_driveSqlite createAccountTable];
        [_driveSqlite insertData:mdd5Name fileID:fileID type:item.extension createTime:item.fileSystemCreatedDate imageFirstBytes:foruData];
        [_driveSqlite closeDB];
    }
}

- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (void)readSqlite {
    if (_driveSqlite) {
        [_driveSqlite release];
        _driveSqlite = nil;
    }
    _driveSqlite = [[IMBDriveImageSqltie alloc]initWithPath:_photoSqlitePath];
    [_driveSqlite selectAccountDatail];
}

- (void)matchingSqlite:(IMBDriveModel *)drviceEntity {
    if (drviceEntity.fileTypeEnum == ImageFile) {
        BOOL isHave = NO;
        IMBPhotoSqliteEntity *currentSqliteEntity =  nil;
        for (IMBPhotoSqliteEntity *sqltieEntity in _driveSqlite.accountArray) {
            if ([sqltieEntity.fileID isEqualToString:drviceEntity.itemIDOrPath]) {
                isHave = YES;
                currentSqliteEntity = sqltieEntity;
                break;
            }
        }
        if (!isHave) {
            [drviceEntity addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
            [self setDownloadPath:_storePhotoPath];
            [self downloadItem:drviceEntity];
        }else {
            NSData *imageData = [[NSMutableData alloc]initWithContentsOfFile:[_storePhotoPath stringByAppendingPathComponent:currentSqliteEntity.md5Name]];
            [currentSqliteEntity.firstBytesData appendData:imageData];
            NSImage *dataImage = [[NSImage alloc] initWithData:currentSqliteEntity.firstBytesData];
            drviceEntity.image = [dataImage retain];
            if (!dataImage) {
                [_driveSqlite openDB];
                [_driveSqlite deleteSqlite:currentSqliteEntity.fileID];
                [drviceEntity addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
                [self setDownloadPath:_storePhotoPath];
                [self downloadItem:drviceEntity];
                [_driveSqlite closeDB];
            }
            [dataImage release];
            dataImage = nil;
            [imageData release];
            imageData = nil;
        }
    }
}

//时间转换
- (NSString *)dateForm2001DateSting:(NSString *)dateSting {
    if ((![StringHelper stringIsNilOrEmpty:dateSting])) {
        if(dateSting.length >= 19) {
            NSString *str = [dateSting substringToIndex:19];
            str = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            NSDate *date = [DateHelper dateFromString:str Formate:@"yyyy-MM-dd HH:mm:ss" withTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
            NSTimeInterval interval1 = [DateHelper getTimeStampFrom1970Date:date withTimezone:[NSTimeZone localTimeZone]];
            NSString *str2 = [DateHelper dateFrom1970ToString:interval1 withMode:2];
            return str2;
        }else {
            return @"--";
        }
    }else {
        return @"--";
    }
}

-(void)dealloc {
    if (_photoSqlitePath) {
        [_photoSqlitePath release];
        _photoSqlitePath = nil;
    }
    if (_storePhotoPath) {
        [_storePhotoPath release];
        _storePhotoPath = nil;
    }
    if (_driveSqlite) {
        [_driveSqlite release];
        _driveSqlite = nil;
    }
    
    [super dealloc];
}

@end
