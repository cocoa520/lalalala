//
//  IMBDropBoxManager.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/23.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBDropBoxManager.h"
#import "TempHelper.h"
#import "Dropbox.h"
#import "IMBDriveImageSqltie.h"
#import "IMBCloudManager.h"
#import "IMBSearchManager.h"

@implementation IMBDropBoxManager

#pragma mark -- 获取数据
- (void)loadData {
    [self recursiveDirectoryContentsDics:@"0"];
}

//获取dropbox 空间和名字
- (void)getAccount {
    [(Dropbox *)_baseDrive getSpaceUsage:@"0" success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        if (dic) {
            NSDictionary *allocationDic = [dic objectForKey:@"allocation"];
            long long usedSize = [[dic objectForKey:@"used"] longLongValue];
            if (allocationDic) {
                long long allocatedSize = [[allocationDic objectForKey:@"allocated"] longLongValue];
                _baseDrive.totalCapacity = allocatedSize;
            }
            _baseDrive.usedCapacity = usedSize;
            [_nc postNotificationName:REFRESH_LOGIN_CLOUD object:_baseDrive];
        }
    } fail:^(DriveAPIResponse *response) {
        
    }];
    
    [_baseDrive getAccount:@"0" success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        if (dic) {
            NSDictionary *nameDic = [dic objectForKey:@"name"];
            if (nameDic) {
                NSString *displayName = [nameDic objectForKey:@"display_name"];
                _baseDrive.displayName = [TempHelper getCloudName:_baseDrive.driveType DriveName:displayName];
            }
            [_nc postNotificationName:REFRESH_LOGIN_CLOUD object:_baseDrive];
        }
    } fail:^(DriveAPIResponse *response) {

    }];
}

- (void)recursiveDirectoryContentsDics:(NSString *)folerID {
    [_baseDrive getList:folerID success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        NSMutableArray *ary = [dic objectForKey:@"entries"];
        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        [self readSqlite];
        for (NSMutableDictionary *resDic in ary) {
            IMBDriveModel *drviceEntity = [[IMBDriveModel alloc]init];
            [drviceEntity setDriveID:self.baseDrive.driveID];
            [self createDriveEntity:drviceEntity ResDic:resDic];
            [self matchingSqlite:drviceEntity];
            [dataAry addObject:drviceEntity];
            [drviceEntity release];
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

- (void)createDriveEntity:(IMBDriveModel *)drviceEntity ResDic:(NSDictionary *)resDic {
    //文件下载路径
    NSString *downFileLoadURL = [resDic objectForKey:@"@microsoft.graph.downloadUrl"];
    NSString *createdString = [self dateForm2001DateSting:[resDic objectForKey:@"server_modified"]];
    NSString *lastModifiedString = [self dateForm2001DateSting:[resDic objectForKey:@"client_modified"]];
    
    NSString *fileName = [resDic objectForKey:@"name"];
    long long size = [[resDic objectForKey:@"size"] longLongValue];
    NSMutableDictionary *fileSystemInfo = [resDic objectForKey:@"fileSystemInfo"];
    NSString *fileSystemCreatedDate = [self dateForm2001DateSting:[fileSystemInfo objectForKey:@"createdDateTime"]];
    NSString *fileSystemLastDate = [self dateForm2001DateSting:[fileSystemInfo objectForKey:@"lastModifiedDateTime"]];
    NSString *fileID = [resDic objectForKey:@"id"];
    NSString *isFolder = [resDic objectForKey:@".tag"];
    NSString *extension = [fileName pathExtension];
    NSString *path = [resDic objectForKey:@"path_display"];
    if (![StringHelper stringIsNilOrEmpty:extension]) {
        extension = [extension lowercaseString];
    }
    if (downFileLoadURL) {
        drviceEntity.fileLoadURL = downFileLoadURL;
    }
    if (createdString) {
        drviceEntity.createdDateString = createdString;
    }
    if (lastModifiedString) {
        drviceEntity.lastModifiedDateString = lastModifiedString;
    }
    if (fileName) {
        drviceEntity.displayName = [fileName stringByDeletingPathExtension];
        drviceEntity.fileName = fileName;
    }
    if (fileSystemCreatedDate) {
        drviceEntity.fileSystemCreatedDate = fileSystemCreatedDate;
    }
    drviceEntity.fileSize = size;
    if (fileSystemLastDate) {
        drviceEntity.fileSystemLastDate = fileSystemLastDate;
    }
    drviceEntity.fileID = fileID;
    drviceEntity.itemIDOrPath = fileID;
    drviceEntity.filePath = [resDic objectForKey:@"path_display"];
    if (path) {
        drviceEntity.filePath = path;
    }
    if ([isFolder isEqualToString:@"folder"]) {
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

#pragma mark -- 功能方法
//删除
- (void)deleteDriveItem:(NSMutableArray *)deleteItemAry {
    [(Dropbox *)_baseDrive deleteFilesOrFolders:deleteItemAry success:^(DriveAPIResponse *response) {
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
        NSDictionary *dataDic = [response.content objectForKey:@"metadata"];
        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        if (dataDic) {
            NSString *fileName = [dataDic objectForKey:@"name"];
            drviceEntity.fileName = fileName;
            drviceEntity.displayName = [fileName stringByDeletingPathExtension];
            [dataAry addObject:drviceEntity];
        }
        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:dataAry WithEvent:renameAction];
        }
        [dataAry release];
        dataAry = nil;
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
        NSDictionary *dataDic = [resDic objectForKey:@"metadata"];
        NSString *fileName = [dataDic objectForKey:@"name"];
        drviceEntity.fileName = fileName;
        drviceEntity.displayName = [fileName stringByDeletingPathExtension];
        drviceEntity.fileID = [dataDic objectForKey:@"id"];
        drviceEntity.docwsID  = [dataDic objectForKey:@"id"];
        drviceEntity.filePath = [dataDic objectForKey:@"path_display"];
        drviceEntity.itemIDOrPath = [dataDic objectForKey:@"id"];
        [drviceEntity setDriveID:self.baseDrive.driveID];
        drviceEntity.isFolder = YES;
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
        }else {
            [(IMBSearchManager *)_searchDelegete loadDriveComplete:[NSMutableArray array] withNextPageToken:@"" withManager:self];
        }
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:sreachAction];
        }
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
    drviceEntity.filePath = [dic objectForKey:@"path"];
    drviceEntity.sreachSize = sizeStr;
    if ([type.lowercaseString isEqualToString:@"folder"]) {
        drviceEntity.isFolder = YES;
        drviceEntity.createdDateString = [DateHelper toDayDateString];
        if ([name containsString:@".app" options:0]) {
            drviceEntity.fileTypeEnum = AppFile;
        }
    }else {
        drviceEntity.fileTypeEnum = [TempHelper getFileFormatWithExtension:file_extension];
    }
}

//移动文件
- (void)moveToNewParent:(NSString *)newParent idOrPaths:(NSArray *)idOrPaths {
//    if ([idOrPaths count] == 1) {
        [_baseDrive moveToNewParentIDOrPath:newParent idOrPathArray:idOrPaths success:^(DriveAPIResponse *response) {
            NSMutableDictionary *dic = response.content;
            NSMutableArray *entriesDataAry = [dic objectForKey:@"entries"];
             NSMutableArray *dataAry = [[NSMutableArray alloc]init];
            if (entriesDataAry.count >0) {
                for (int i = 0;i<entriesDataAry.count;i++) {
                    NSMutableDictionary *dic = [entriesDataAry objectAtIndex:i];
                    NSMutableDictionary *dataDic = [dic objectForKey:@"metadata"];
                    if ([dataDic.allKeys containsObject:@"id"]) {
                        [dataAry addObject:[dataDic objectForKey:@"id"]];
                    }
                }
            }else {
                NSMutableDictionary *dataDic = [dic objectForKey:@"metadata"];
                if ([dataDic.allKeys containsObject:@"id"]) {
                    [dataAry addObject:[dataDic objectForKey:@"id"]];
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
        NSMutableDictionary *dic = response.content;
        NSMutableArray *entriesDataAry = [dic objectForKey:@"entries"];
        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        if (entriesDataAry.count >0) {
            for (int i = 0;i<entriesDataAry.count;i++) {
                NSMutableDictionary *dic = [entriesDataAry objectAtIndex:i];
                NSMutableDictionary *dataDic = [dic objectForKey:@"metadata"];
                IMBDriveModel *drviceEntity = [[IMBDriveModel alloc]init];
                [self createDriveEntity:drviceEntity ResDic:dataDic];
                [dataAry addObject:drviceEntity];
                [drviceEntity release];
                drviceEntity = nil;
            }
        }else {
            NSMutableDictionary *dataDic = [dic objectForKey:@"metadata"];
            IMBDriveModel *drviceEntity = [[IMBDriveModel alloc]init];
            [self createDriveEntity:drviceEntity ResDic:dataDic];
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
