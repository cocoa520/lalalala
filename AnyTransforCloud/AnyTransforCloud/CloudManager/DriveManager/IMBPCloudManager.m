//
//  IMBPCloudManager.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/4/23.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBPCloudManager.h"
#import "pCloud.h"

@implementation IMBPCloudManager

#pragma mark -- 获取数据
- (void)loadData {
    [self recursiveDirectoryContentsDics:@"0"];
}

- (void)recursiveDirectoryContentsDics:(NSString *)folerID {
    [_baseDrive getList:folerID success:^(DriveAPIResponse *response) {
        NSMutableDictionary *dic = response.content;
        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        if ([dic.allKeys containsObject:@"metadata"]) {
            NSDictionary *metaDic = [dic objectForKey:@"metadata"];
            if (metaDic) {
                if ([metaDic.allKeys containsObject:@"contents"]) {
                    NSArray *contentAry = [metaDic objectForKey:@"contents"];
                    [self readSqlite];
                    for (NSMutableDictionary *resDic in contentAry) {
                        IMBDriveModel *drviceEntity = [[IMBDriveModel alloc]init];
                        [drviceEntity setDriveID:self.baseDrive.driveID];
                        [self createDriveEntity:drviceEntity ResDic:resDic];
                        [self matchingSqlite:drviceEntity];
                        if (![drviceEntity.fileName isEqualToString:@".DS_Store"]) {//剔除隐藏文件
                            [dataAry addObject:drviceEntity];
                        }
                        [drviceEntity release];
                    }
                }
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

- (void)copyDriveEntity:(IMBDriveModel *)drviceEntity ResDic:(NSDictionary *)resDic {
    NSString *fileName = [resDic objectForKey:@"name"];
    if ([fileName isEqualToString:@".DS_Store"]) {//剔除隐藏文件
        drviceEntity.fileName = fileName;
        drviceEntity.displayName = [fileName stringByDeletingPathExtension];
        return;
    }
    BOOL isFolder = [[resDic objectForKey:@"isfolder"] boolValue];
    NSString *fileID = nil;
    if (isFolder) {
        fileID = [resDic objectForKey:@"folderid"];
    }else {
        fileID = [resDic objectForKey:@"fileid"];
    }
    NSString *path = [resDic objectForKey:@"path"];
    NSString *createdString = [resDic objectForKey:@"created"];//Tue, 24 Apr 2018 12:00:46 +0000 转换方式不对
    NSString *lastModifiedString = [self dateForm2001DateSting:[resDic objectForKey:@"modified"]];
    long long size = [[resDic objectForKey:@"size"] longLongValue];
    NSString *extension = [fileName pathExtension];
    if (![StringHelper stringIsNilOrEmpty:extension]) {
        extension = [extension lowercaseString];
    }
    if (path) {
        drviceEntity.filePath = path;
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
    drviceEntity.fileSize = size;
    drviceEntity.fileID = fileID;
    drviceEntity.itemIDOrPath = fileID;
    drviceEntity.docwsID = fileID;
    if (isFolder) {
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

- (void)createDriveEntity:(IMBDriveModel *)drviceEntity ResDic:(NSDictionary *)resDic {
    NSString *fileName = [resDic objectForKey:@"name"];
    if ([fileName isEqualToString:@".DS_Store"]) {//剔除隐藏文件
        drviceEntity.fileName = fileName;
        drviceEntity.displayName = [fileName stringByDeletingPathExtension];
        return;
    }
    BOOL isFolder = [[resDic objectForKey:@"isfolder"] boolValue];
    NSString *fileID = nil;
    if (isFolder) {
        fileID = [resDic objectForKey:@"folderid"];
    }else {
        fileID = [resDic objectForKey:@"fileid"];
    }
    NSString *path = [resDic objectForKey:@"path"];
    NSString *createdString = [self dateForm2001DateSting:[resDic objectForKey:@"created"]];//Tue, 24 Apr 2018 12:00:46 +0000 转换方式不对
    NSString *lastModifiedString = [self dateForm2001DateSting:[resDic objectForKey:@"modified"]];
    long long size = [[resDic objectForKey:@"size"] longLongValue];
    NSString *extension = [fileName pathExtension];
    if (![StringHelper stringIsNilOrEmpty:extension]) {
        extension = [extension lowercaseString];
    }
    if (path) {
        drviceEntity.filePath = path;
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
    drviceEntity.fileSize = size;
    drviceEntity.fileID = fileID;
    drviceEntity.itemIDOrPath = fileID;
    drviceEntity.docwsID = fileID;
    if (isFolder) {
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
            /*
             {
                business = 0;
                cryptolifetime = 0;
                cryptosetup = 0;
                cryptosubscription = 0;
                email = "ydingm@yeah.net";
                emailverified = 0;
                journey =     {
                    claimed = 0;
                    steps =         {
                        autoupload = 0;
                        downloadapp = 0;
                        downloaddrive = 1;
                        uploadfile = 1;
                        verifymail = 0;
                    };
                };
                language = zh;
                plan = 0;
                premium = 0;
                premiumlifetime = 0;
                publiclinkquota = 53687091200;
                quota = 10737418240;
                registered = "Tue, 24 Apr 2018 12:00:46 +0000";
                result = 0;
                trashrevretentiondays = 15;
                usedquota = 100435323;
                userid = 11205808;
            }
             */
            if ([dic.allKeys containsObject:@"email"]) {
                NSString *email = [dic objectForKey:@"email"];
                _baseDrive.driveEmail = email;
            }
            if ([dic.allKeys containsObject:@"quota"]) {
                long long totalSize = [[dic objectForKey:@"quota"] longLongValue];
                _baseDrive.totalCapacity = totalSize;
            }
            if ([dic.allKeys containsObject:@"usedquota"]) {
                long long usedSize = [[dic objectForKey:@"usedquota"] longLongValue];
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
    [(pCloud *)_baseDrive deleteFilesOrFolders:deleteItemAry success:^(DriveAPIResponse *response) {
        /*
        {
            metadata =     {
                category = 4;
                comments = 0;
                contenttype = "text/plain";
                created = "Tue, 17 Apr 2018 05:13:48 +0000";
                fileid = 6288301103;
                hash = 7464502817390099350;
                icon = document;
                id = f6288301103;
                isdeleted = 1;
                isfolder = 0;
                ismine = 1;
                isshared = 0;
                modified = "Wed, 25 Apr 2018 06:32:45 +0000";
                name = "602D62D4-3F4B-4fce-A516-04394CA4B286.txt";
                parentfolderid = 0;
                size = 17526;
                thumb = 0;
            };
            result = 0;
        }
        */
        if ([_delegete respondsToSelector:@selector(loadDriveComplete:WithEvent:)]) {
            [_delegete loadDriveComplete:deleteItemAry WithEvent:deleteAction];
        }
    } fail:^(DriveAPIResponse *response) {
        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
            [_delegete loadDriveDataFail:deleteAction];
        }
    }];
}

//- (void)reName:(NSString *_Nonnull)newName idOrPath:(NSString *_Nonnull)idOrPath isFolder:(BOOL)isFolder {
//    [(pCloud *)_baseDrive reName:newName idOrPath:idOrPath isFolder:isFolder success:^(DriveAPIResponse *response) {
//        /*
//         文件夹
//        {
//            metadata =     {
//                comments = 0;
//                created = "Wed, 25 Apr 2018 02:08:35 +0000";
//                folderid = 1690138948;
//                icon = folder;
//                id = d1690138948;
//                isfolder = 1;
//                ismine = 1;
//                isshared = 0;
//                modified = "Wed, 25 Apr 2018 06:47:53 +0000";
//                name = success;
//                parentfolderid = 0;
//                thumb = 0;
//            };
//            result = 0;
//        }*
//         文件
//        {
//            metadata =     {
//                category = 0;
//                comments = 0;
//                contenttype = "application/octet-stream";
//                created = "Thu, 15 Mar 2018 09:06:47 +0000";
//                fileid = 6288301104;
//                hash = 8805461693653212474;
//                icon = file;
//                id = f6288301104;
//                isfolder = 0;
//                ismine = 1;
//                isshared = 0;
//                modified = "Thu, 15 Mar 2018 09:06:47 +0000";
//                name = 6288301104;
//                parentfolderid = 0;
//                size = 17089;
//                thumb = 0;
//            };
//            result = 0;
//        }
//        */
//        NSMutableDictionary *dic = response.content;
//        NSMutableDictionary *dataDic = [dic objectForKey:@"metadata"];
//    } fail:^(DriveAPIResponse *response) {
//        if ([_delegete respondsToSelector:@selector(loadDriveDataFail:)]) {
//            [_delegete loadDriveDataFail:renameAction];
//        }
//    }];
//}

- (void)createFolder:(NSString *_Nonnull)folderName parent:(NSString *_Nonnull)parentID withEntity:(nullable IMBDriveModel *)drviceEntity {
    [_baseDrive createFolder:folderName parent:parentID success:^(DriveAPIResponse *response) {
        /*
        {
            metadata =     {
                created = "Wed, 25 Apr 2018 06:55:55 +0000";
                folderid = 1690846086;
                icon = folder;
                id = d1690846086;
                isfolder = 1;
                ismine = 1;
                isshared = 0;
                modified = "Wed, 25 Apr 2018 06:55:55 +0000";
                name = doucment;
                parentfolderid = 0;
                path = "/doucment";
                thumb = 0;
            };
            result = 0;
        }
        */
        NSDictionary *resDic = response.content;
        NSDictionary *dataDic = [resDic objectForKey:@"metadata"];
        NSString *fileName = [dataDic objectForKey:@"name"];
        drviceEntity.fileName = fileName;
        drviceEntity.displayName = [fileName stringByDeletingPathExtension];
        drviceEntity.fileID = [dataDic objectForKey:@"id"];
        drviceEntity.docwsID  = [dataDic objectForKey:@"id"];
        drviceEntity.filePath = [dataDic objectForKey:@"path"];
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

- (void)moveToNewParent:(NSString *)newParent idOrPaths:(NSArray *)idOrPaths {
     [_baseDrive moveToNewParentIDOrPath:newParent idOrPathArray:idOrPaths success:^(DriveAPIResponse *response) {
        /*
        {
            metadata =     {
                category = 4;
                comments = 0;
                contenttype = "application/pdf";
                created = "Fri, 23 Mar 2018 04:04:00 +0000";
                fileid = 6288301937;
                hash = 3985823776277493294;
                icon = document;
                id = f6288301937;
                isfolder = 0;
                ismine = 1;
                isshared = 0;
                modified = "Fri, 23 Mar 2018 04:04:00 +0000";
                name = "\U667a\U8054\U62db\U8058\U4e92\U8054\U7f51\U884c\U4e1a\U85aa\U916c\U5927\U6570\U636e\U5206\U6790\U62a5\U544a-2018\U5e74\U6625\U5b63.pdf";
                parentfolderid = 1686499726;
                size = 1379684;
                thumb = 0;
            };
            result = 0;
        }
        */
        NSMutableArray *dataAry = [[NSMutableArray alloc]init];
        NSMutableArray *dicAry = response.content;
         for (NSDictionary *dic in dicAry) {
             NSDictionary *newDic = [dic objectForKey:@"metadata"];
             NSString *isFolder = [newDic objectForKey:@"icon"];
             NSString *fileID = @"";
             if ([isFolder.lowercaseString isEqualToString:@"folder"] ) {
                 fileID = [newDic objectForKey:@"folderid"];
             }else {
                 fileID = [newDic objectForKey:@"fileid"];
             }
             [dataAry addObject:fileID];
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
            NSDictionary *newDic = [dic objectForKey:@"metadata"];
            IMBDriveModel *drviceEntity = [[IMBDriveModel alloc]init];
            [self copyDriveEntity:drviceEntity ResDic:newDic];
            [self matchingSqlite:drviceEntity];
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

//重命名
- (void)reName:(NSString *_Nonnull)newName idOrPathArray:(NSArray *_Nonnull)idOrPathArray withEntity:(nullable IMBDriveModel *)drviceEntity{
    [_baseDrive reName:newName idOrPathArray:idOrPathArray success:^(DriveAPIResponse *response) {
        NSDictionary *dic = [response.content objectForKey:@"metadata"];
        NSString *name = [dic objectForKey:@"name"];
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

- (void)toDrive:(BaseDrive * _Nonnull)targetDrive item:(NSMutableArray *)item{
    for (IMBDriveModel *driveItem in item) {
        [_baseDrive toDrive:targetDrive item:driveItem];
    }
}

- (void)cancelUploadItem:(_Nonnull id<DownloadAndUploadDelegate>)item{
    [_baseDrive cancelUploadItem:item];
}

@end
