//
//  IMBBoxManager.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/23.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBBoxManager.h"
#import "Box.h"
#import "IMBBaseManager.h"
@implementation IMBBoxManager

#pragma mark -- 获取数据
- (void)loadData {
    [self recursiveDirectoryContentsDics:@"0"];
}

- (void)createDriveEntity:(IMBDriveModel *)drviceEntity ResDic:(NSDictionary *)resDic {
//    NSString *createdString = [self dateForm2001DateSting:[resDic objectForKey:@"client_modified"]];
    NSString *folderStr = [resDic objectForKey:@"type"];
    NSString *fileName = [resDic objectForKey:@"name"];
//    long long size = [[resDic objectForKey:@"size"] longLongValue];
    NSString *fileID = [resDic objectForKey:@"id"];
    NSString *extension = [fileName pathExtension];
    drviceEntity.displayName = [fileName stringByDeletingPathExtension];
    drviceEntity.fileName = fileName;
    drviceEntity.fileID = fileID;
    drviceEntity.itemIDOrPath = fileID;
    drviceEntity.createdDateString = [self dateForm2001DateSting:[resDic objectForKey:@"created_at"]];
    drviceEntity.lastModifiedDateString = [self dateForm2001DateSting:[resDic objectForKey:@"modified_at"]];
    drviceEntity.fileSize = [[resDic objectForKey:@"size"] longLongValue];
    if ([folderStr.lowercaseString isEqualToString:@"folder"]) {
        drviceEntity.isFolder = YES;
        drviceEntity.fileTypeEnum = Folder;
        drviceEntity.extension = @"Folder";
        drviceEntity.iConimage = [NSImage imageNamed:@"def_folder_mac"];
        if ([fileName containsString:@".app" options:0]) {
            drviceEntity.fileTypeEnum = AppFile;
            drviceEntity.isFolder = NO;
            drviceEntity.extension = @"app";
            drviceEntity.iConimage = [NSImage imageNamed:@"def_compress"];
        }
    }else{
        drviceEntity.fileTypeEnum = [TempHelper getFileFormatWithExtension:extension];
        drviceEntity.extension = extension;
    }
    drviceEntity.iConimage = [TempHelper loadFileImage:drviceEntity.fileTypeEnum];
    drviceEntity.transferImage = [TempHelper loadFileTransferImage:drviceEntity.fileTypeEnum];
}

- (void)recursiveDirectoryContentsDics:(NSString *)folerID {
    [_baseDrive getList:folerID success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
//        NSMutableDictionary *itemDic = [dic objectForKey:@"item_collection"];
        NSMutableArray *ary = [dic objectForKey:@"entries"];
        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        [self readSqlite];
        for (NSMutableDictionary *resDic in ary) {
            IMBDriveModel *drviceEntity = [[IMBDriveModel alloc]init];
            [self createDriveEntity:drviceEntity ResDic:resDic];
            [drviceEntity setDriveID:self.baseDrive.driveID];
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
        NSMutableDictionary *dic = response.content;
        if (dic && [[dic allKeys] count] > 0) {
            if ([dic.allKeys containsObject:@"name"]) {
                NSString *displayName = [dic objectForKey:@"name"];
                _baseDrive.displayName = [TempHelper getCloudName:_baseDrive.driveType DriveName:displayName];
            }
            if ([dic.allKeys containsObject:@"login"]) {
                NSString *email = [dic objectForKey:@"login"];
                _baseDrive.driveEmail = email;
            }
            if ([dic.allKeys containsObject:@"space_amount"]) {
                long long totalSize = [[dic objectForKey:@"space_amount"] longLongValue];
                _baseDrive.totalCapacity = totalSize;
            }
            if ([dic.allKeys containsObject:@"space_used"]) {
                long long usedSize = [[dic objectForKey:@"space_used"] longLongValue];
                _baseDrive.usedCapacity = usedSize;
            }
            [_nc postNotificationName:REFRESH_LOGIN_CLOUD object:_baseDrive];
        }
    } fail:^(DriveAPIResponse *response) {
        
    }];
}

#pragma mark -- 功能方法
//删除  数组装的是字典
- (void)deleteDriveItem:(NSMutableArray *)deleteItemAry {
    [(Box *)_baseDrive deleteFilesOrFolders:deleteItemAry success:^(DriveAPIResponse *response) {
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
        NSMutableDictionary *dic = response.content;
        NSString *fileName = [dic objectForKey:@"name"];
        drviceEntity.fileName = fileName;
        drviceEntity.displayName = [fileName stringByDeletingPathExtension];
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

//移动文件   idOrPaths 装的是字典
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
        NSMutableArray *dicAry = response.content;
        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in dicAry) {
            IMBDriveModel *drviceEntity = [[IMBDriveModel alloc]init];
            [self createDriveEntity:drviceEntity ResDic:dic];
            [dataAry addObject:drviceEntity];
            [drviceEntity release];
            drviceEntity = nil;

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



@end
