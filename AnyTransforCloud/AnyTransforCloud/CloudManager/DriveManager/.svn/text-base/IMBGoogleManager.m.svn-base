//
//  IMBGoogleManager.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/23.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBGoogleManager.h"
#import "GoogleDrive.h"

@implementation IMBGoogleManager

#pragma mark -- 获取数据
- (void)loadData {
    [self recursiveDirectoryContentsDics:@"0"];
}

- (void)recursiveDirectoryContentsDics:(NSString *)folerID {
    [_baseDrive getList:folerID success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        [self readSqlite];
        if ([dic.allKeys containsObject:@"files"]) {
            NSMutableArray *ary = [dic objectForKey:@"files"];
            for (NSMutableDictionary *resDic in ary) {
                IMBDriveModel *drviceEntity = [[IMBDriveModel alloc]init];
                [drviceEntity setDriveID:self.baseDrive.driveID];
                [self createDriveEntity:drviceEntity ResDic:resDic];
                [self matchingSqlite:drviceEntity];
                [dataAry addObject:drviceEntity];
                [drviceEntity release];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
                [_delegete loadDriveComplete:dataAry WithEvent:loadAction];
            }
            [dataAry release];
        });
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:loadAction];
        }
    }];
}

- (void)createDriveEntity:(IMBDriveModel *)drviceEntity ResDic:(NSDictionary *)resDic {
    //文件下载路径
    NSString *downFileLoadURL = [resDic objectForKey:@"webViewLink"];
    NSString *thumbnailUrl = [resDic objectForKey:@"thumbnailLink"];
//    NSString *createdString = [self dateForm2001DateSting:[resDic objectForKey:@"modifiedTime"]];
    NSString *lastModifiedString = [self dateForm2001DateSting:[resDic objectForKey:@"modifiedTime"]];
    
    NSString *fileName = [resDic objectForKey:@"name"];
    long long size = [[resDic objectForKey:@"size"] longLongValue];
    NSString *fileID = [resDic objectForKey:@"id"];
    NSString *mimeType = [resDic objectForKey:@"mimeType"];
    BOOL isTrash = [[resDic objectForKey:@"trashed"] boolValue];
    NSString *extension = [fileName pathExtension];
    if (![StringHelper stringIsNilOrEmpty:extension]) {
        extension = [extension lowercaseString];
    }
    if (downFileLoadURL) {
        drviceEntity.fileLoadURL = downFileLoadURL;
    }
    if (thumbnailUrl) {
        drviceEntity.thumbnailURL = thumbnailUrl;
    }
//    if (createdString) {
//        drviceEntity.createdDateString = createdString;
//    }
    if (lastModifiedString) {
        drviceEntity.lastModifiedDateString = lastModifiedString;
    }
    if (fileName) {
        drviceEntity.displayName = [fileName stringByDeletingPathExtension];
        drviceEntity.fileName = fileName;
    }
    drviceEntity.fileSize = size;
    drviceEntity.fileID = fileID;
    drviceEntity.itemIDOrPath = fileID;
    drviceEntity.docwsID = fileID;
    drviceEntity.isTrashed = isTrash;
    if ([mimeType contains:@"folder"]) {
        drviceEntity.isFolder = YES;
        drviceEntity.fileTypeEnum = Folder;
        drviceEntity.extension = @"Folder";
        if ([fileName containsString:@".app" options:0]) {
            drviceEntity.fileTypeEnum = AppFile;
            drviceEntity.isFolder = NO;
            drviceEntity.extension = @"app";
        }
    }else{
        drviceEntity.fileTypeEnum = [TempHelper getFileFormatWithExtension:extension];
        drviceEntity.extension = extension;
    }
    drviceEntity.iConimage = [TempHelper loadFileImage:drviceEntity.fileTypeEnum];
    drviceEntity.transferImage = [TempHelper loadFileTransferImage:drviceEntity.fileTypeEnum];
}

- (void)getAccount {
    [_baseDrive getAccount:@"0" success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        if (dic) {
            if ([dic.allKeys containsObject:@"user"]) {
                NSDictionary *userDic = [dic objectForKey:@"user"];
                /*
                user =     {
                    displayName = "\U4e01\U660e";
                    emailAddress = "ydingm18@gmail.com";
                    isAuthenticatedUser = 1;
                    kind = "drive#user";
                    permissionId = 08732455870698142475;
                };
                 */
                if (userDic) {
                    if ([userDic.allKeys containsObject:@"displayName"]) {
                        NSString *displayName = [userDic objectForKey:@"displayName"];
                        _baseDrive.displayName = [TempHelper getCloudName:_baseDrive.driveType DriveName:displayName];
                    }
                    if ([userDic.allKeys containsObject:@"emailAddress"]) {
                        NSString *email = [userDic objectForKey:@"emailAddress"];
                        _baseDrive.driveEmail = email;
                    }
                }
            }
            /*
             quotaBytesTotal = 16106127360;
             quotaBytesUsed = 0;
             quotaBytesUsedAggregate = 0;
             quotaBytesUsedInTrash = 0;
             quotaType = LIMITED;
             rootFolderId = "0AL4yXAXj9JS-Uk9PVA";
             selfLink = "https://www.googleapis.com/drive/v2/about";
             */
            if ([dic.allKeys containsObject:@"quotaBytesTotal"]) {
                long long totalSize = [[dic objectForKey:@"quotaBytesTotal"] longLongValue];
                _baseDrive.totalCapacity = totalSize;
            }
            if ([dic.allKeys containsObject:@"quotaBytesUsed"]) {
                long long usedSize = [[dic objectForKey:@"quotaBytesUsed"] longLongValue];
                _baseDrive.usedCapacity = usedSize;
            }
            [_nc postNotificationName:REFRESH_LOGIN_CLOUD object:_baseDrive];
        }
    } fail:^(DriveAPIResponse *response) {
    }];
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
    [(GoogleDrive *)_baseDrive deleteFilesOrFolders:deleteItemAry success:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:deleteItemAry WithEvent:deleteAction];
        }
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:deleteAction];
        }
    }];
}

- (void)createFolder:(NSString *_Nonnull)folderName parent:(NSString *_Nonnull)parentID withEntity:(nullable IMBDriveModel *)drviceEntity {
    [_baseDrive createFolder:folderName parent:parentID success:^(DriveAPIResponse *response) {
        /*
        id = 1Q7t3BNKxapei9OTNFR9NEzfMwhFrK3Hm;
        kind = "drive#file";
        mimeType = "application/vnd.google-apps.folder";
        name = "\U4e34\U65f6\U6587\U6863";
         */
        NSDictionary *resDic = response.content;
//            NSDictionary *dataDic = [resDic objectForKey:@"metadata"];
        NSString *fileName = [resDic objectForKey:@"name"];
        drviceEntity.fileName = fileName;
        drviceEntity.displayName = [fileName stringByDeletingPathExtension];
        drviceEntity.fileID = [resDic objectForKey:@"id"];
        drviceEntity.docwsID  = [resDic objectForKey:@"id"];
        drviceEntity.itemIDOrPath = [resDic objectForKey:@"id"];
//            drviceEntity.filePath = [resDic objectForKey:@"path_display"];
        drviceEntity.isFolder = YES;
        [drviceEntity setDriveID:self.baseDrive.driveID];
        //        drviceEntity.image = [NSImage imageNamed:@"mac_cnt_fileicon_myfile"];
        drviceEntity.extension = @"Folder";
        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:[NSMutableArray arrayWithObject: drviceEntity] WithEvent:createFolder];
        }
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:createFolder];
        }
    }];
}

- (void)getFolderInfo:(NSString *_Nonnull)folerID {
    [_baseDrive getFolderInfo:folerID success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        NSMutableArray *fatherFileID = [dic objectForKey:@"parents"];
        [(IMBSearchManager *)_searchDelegete getFolderComplete:fatherFileID];
    } fail:^(DriveAPIResponse *response) {
        [(IMBSearchManager *)_searchDelegete getFolderFail];
    }];
}

//重命名
- (void)reName:(NSString *_Nonnull)newName idOrPathArray:(NSArray *_Nonnull)idOrPathArray withEntity:(nullable IMBDriveModel *)drviceEntity{
    [_baseDrive reName:newName idOrPathArray:idOrPathArray success:^(DriveAPIResponse *response) {
        NSString *name = [response.content objectForKey:@"name"];
        drviceEntity.fileName = name;
        drviceEntity.displayName = [name stringByDeletingPathExtension];
        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:[NSMutableArray array] WithEvent:renameAction];
        }
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:renameAction];
        }
    }];
}

- (void)moveToNewParent:(NSString *_Nonnull)newParent idOrPaths:(NSArray *_Nonnull)idOrPaths {
     [_baseDrive moveToNewParentIDOrPath:newParent idOrPathArray:idOrPaths success:^(DriveAPIResponse *response) {
        NSMutableArray *dicAry = response.content;
         NSMutableArray *dataAry = [[NSMutableArray alloc]init];
         for (NSDictionary *dic in dicAry) {
             if ([dic.allKeys containsObject:@"id"]) {
                 [dataAry addObject:[dic objectForKey:@"id"]];
             }
         }
        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:dataAry WithEvent:moveAction];
        }
        [dataAry release];
        dataAry = nil;
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:moveAction];
        }
    }];
}

- (void)copyToNewParentIDOrPath:(NSString * _Nonnull)newParentIdOrPath idOrPathArray:(NSArray * _Nonnull)idOrPathArray {
    [_baseDrive copyToNewParentIDOrPath:newParentIdOrPath idOrPathArray:idOrPathArray success:^(DriveAPIResponse *response) {
//        NSMutableDictionary *dic = response.content;
//         NSMutableArray *ary = [dic objectForKey:@"files"];
//         NSMutableArray *dataAry = [[NSMutableArray alloc]init];
//        for (NSMutableDictionary *resDic in ary) {
//            IMBDriveModel *drviceEntity = [[IMBDriveModel alloc]init];
//            [self createDriveEntity:drviceEntity ResDic:resDic];
//            [self matchingSqlite:drviceEntity];
//            [dataAry addObject:drviceEntity];
//            [drviceEntity release];
//            drviceEntity = nil;
//        }
        NSMutableArray *dicAry = response.content;
        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in dicAry) {
            if ([dic.allKeys containsObject:@"id"]) {
                [dataAry addObject:[dic objectForKey:@"id"]];
            }
        }

        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:dataAry WithEvent:copyAction];
        }
        [dataAry release];
        dataAry = nil;
        
        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:dataAry WithEvent:copyAction];
        }
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:copyAction];
        }
    }];
}

- (void)toDrive:(BaseDrive * _Nonnull)targetDrive item:(NSMutableArray *)item{
    for (IMBDriveModel *driveItem in item) {
        [_baseDrive toDrive:targetDrive item:driveItem];
    }
}

- (void)cancelUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item{
    [_baseDrive cancelUploadItem:item];
}

@end
