//
//  IMBOneDriveManager.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/23.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBOneDriveManager.h"
#import "NSString+Category.h"
#import "OneDrive.h"

@implementation IMBOneDriveManager

#pragma mark -- 获取数据
- (void)loadData {
    [self recursiveDirectoryContentsDics:@"0"];
}

- (void)createDriveEntity:(IMBDriveModel *)drviceEntity ResDic:(NSDictionary *)resDic {
    //文件下载路径
    NSString *createdString = [self dateForm2001DateSting:[resDic objectForKey:@"createdDateTime"]];
    NSString *lastModifiedString = [self dateForm2001DateSting:[resDic objectForKey:@"lastModifiedDateTime"]];
    NSString *fileName = [resDic objectForKey:@"name"];
    NSString *extension = [fileName pathExtension];
    long long size = [[resDic objectForKey:@"size"] longLongValue];
    NSString *fileID = [resDic objectForKey:@"id"];
    
    drviceEntity.createdDateString = createdString;
    drviceEntity.lastModifiedDateString = lastModifiedString;
    drviceEntity.displayName = [fileName stringByDeletingPathExtension];
    drviceEntity.fileName = fileName;
    drviceEntity.fileSize = size;
    drviceEntity.fileID = fileID;
    drviceEntity.itemIDOrPath = fileID;
    if ([resDic.allKeys containsObject:@"folder"]) {
        drviceEntity.isFolder = YES;
        drviceEntity.fileTypeEnum = Folder;
        drviceEntity.extension = @"Folder";
        if ([fileName containsString:@".app" options:0]) {
            drviceEntity.fileTypeEnum = AppFile;
            drviceEntity.isFolder = NO;
            drviceEntity.extension = @"app";
        }
    }else{
        drviceEntity.fileTypeEnum = [TempHelper getFileFormatWithExtension:[extension lowercaseString]];
        drviceEntity.extension = extension;
    }
    drviceEntity.iConimage = [TempHelper loadFileImage:drviceEntity.fileTypeEnum];
    drviceEntity.transferImage = [TempHelper loadFileTransferImage:drviceEntity.fileTypeEnum];
}

- (void)recursiveDirectoryContentsDics:(NSString *)folerID {
    [_baseDrive getList:folerID success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        NSMutableArray *ary = [dic objectForKey:@"value"];
         NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        [self readSqlite];
        for (NSMutableDictionary *resDic in ary) {
            IMBDriveModel *drviceEntity = [[IMBDriveModel alloc]init];
            [drviceEntity setDriveID:self.baseDrive.driveID];
            [self createDriveEntity:drviceEntity ResDic:resDic];
            [dataAry addObject:drviceEntity];
            [self matchingSqlite:drviceEntity];
            [drviceEntity release];
            drviceEntity = nil;
        }
        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:dataAry WithEvent:loadAction];
        }
        [dataAry release];
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:loadAction];
        }
    }];
}

- (void)getAccount {
    [_baseDrive getAccount:@"0" success:^(DriveAPIResponse *response) {
        /*
        {
            "@odata.context" = "https://graph.microsoft.com/v1.0/$metadata#drives/$entity";
            driveType = personal;
            id = c2899f59dbfe234b;
            owner =     {
                user =         {
                    displayName = "\U4e01 \U660e";
                    id = c2899f59dbfe234b;
                };
            };
            quota =     {
                deleted = 0;
                remaining = 5368311037;
                state = normal;
                total = 5368709120;
                used = 398083;
            };
        }
        */
        NSMutableDictionary *dic = response.content;
        if (dic) {
            NSDictionary *ownerDic = [dic objectForKey:@"owner"];
            if (ownerDic) {
                NSDictionary *userDic = [ownerDic objectForKey:@"user"];
                if (userDic) {
                    NSString *displayName = [userDic objectForKey:@"displayName"];
                    _baseDrive.displayName = [TempHelper getCloudName:_baseDrive.driveType DriveName:displayName];
                }
            }
            NSDictionary *quotaDic = [dic objectForKey:@"quota"];
            if (quotaDic) {
                long long usedSize = [[quotaDic objectForKey:@"used"] longLongValue];
                long long allocatedSize = [[quotaDic objectForKey:@"total"] longLongValue];
                _baseDrive.usedCapacity = usedSize;
                _baseDrive.totalCapacity = allocatedSize;
            }
            [_nc postNotificationName:REFRESH_LOGIN_CLOUD object:_baseDrive];
        }
    } fail:^(DriveAPIResponse *response) {
        
    }];
}


#pragma mark -- 功能方法
//删除
- (void)deleteDriveItem:(NSMutableArray *)deleteItemAry {
    [(OneDrive *)_baseDrive deleteFilesOrFolders:deleteItemAry success:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:deleteItemAry WithEvent:deleteAction];
        }
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:deleteAction];
        }
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
//新建文件夹
- (void)createFolder:(NSString *)folderName parent:(NSString *)parentID withEntity:(nullable IMBDriveModel *)drviceEntity {
    [_baseDrive createFolder:folderName parent:parentID success:^(DriveAPIResponse *response) {
        NSDictionary *resDic = response.content;
        NSString *fileName = [resDic objectForKey:@"name"];
        drviceEntity.fileName = fileName;
        drviceEntity.displayName = [fileName stringByDeletingPathExtension];
        drviceEntity.fileID = [resDic objectForKey:@"id"];
        drviceEntity.docwsID  = [resDic objectForKey:@"id"];
        drviceEntity.filePath = [resDic objectForKey:@"path_display"];
        drviceEntity.itemIDOrPath = [resDic objectForKey:@"id"];
        [drviceEntity setDriveID:self.baseDrive.driveID];
        drviceEntity.isFolder = YES;
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

//移动文件
- (void)moveToNewParent:(NSString *)newParent idOrPaths:(NSArray *)idOrPaths {
    [_baseDrive moveToNewParentIDOrPath:newParent idOrPathArray:idOrPaths success:^(DriveAPIResponse *response) {
        NSMutableArray *dicAry = response.content;
        for (NSDictionary *dic in dicAry) {
            NSDictionary *newDic = [dic objectForKey:@"error"];
            if (newDic) {
                
            }
        }
//        NSMutableDictionary *dataDic = [dic objectForKey:@"metadata"];
//        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
//        
//        if ([dataDic.allKeys containsObject:@"id"]) {
//            [dataAry addObject:[dataDic objectForKey:@"id"]];
//        }
//        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
//            [_delegete loadDriveComplete:dataAry WithEvent:moveAction];
//        }
//        [dataAry release];
//        dataAry = nil;
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:moveAction];
        }
    }];
}

- (void)copyToNewParentIDOrPath:(NSString * _Nonnull)newParentIdOrPath idOrPathArray:(NSArray * _Nonnull)idOrPathArray {
    [_baseDrive copyToNewParentIDOrPath:newParentIdOrPath idOrPathArray:idOrPathArray success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
//        NSMutableArray *ary = [dic objectForKey:@"metadata"];
//        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
//        for (NSMutableDictionary *resDic in ary) {
//            IMBDriveModel *drviceEntity = [[IMBDriveModel alloc]init];
//            [self createDriveEntity:drviceEntity ResDic:resDic];
//            [self matchingSqlite:drviceEntity];
//            [dataAry addObject:drviceEntity];
//            [drviceEntity release];
//            drviceEntity = nil;
//        }
//        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
//            [_delegete loadDriveComplete:dataAry WithEvent:copyAction];
//        }
//        [dataAry release];
//        dataAry = nil;
        
//        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
//            [_delegete loadDriveComplete:dataAry WithEvent:copyAction];
//        }
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:copyAction];
        }
    }];
}

@end
