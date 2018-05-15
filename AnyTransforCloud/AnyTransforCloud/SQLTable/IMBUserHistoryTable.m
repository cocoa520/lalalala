//
//  IMBUserHistoryTable.m
//  AnyTransforCloud
//
//  Created by ding ming on 18/5/7.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBUserHistoryTable.h"
#import "TempHelper.h"
#import "IMBCloudManager.h"
#import "StringHelper.h"

@implementation IMBUserHistoryTable

- (id)initWithPath:(NSString *)savePath {
    self = [super init];
    if (self) {
        if (savePath) {
            _savePath = [savePath retain];
        }else {
            IMBCloudManager *manager = [IMBCloudManager singleton];
            _savePath = [[[TempHelper getPhotoSqliteConfigPath:manager.curEmail] stringByAppendingPathComponent:@"cloudHistory"] retain];
        }
        _fileHisArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)openDB {
    _db = [[FMDatabase databaseWithPath:_savePath] retain];
    BOOL ret = [_db open];
    if (ret) {
        [_db setShouldCacheStatements:NO];
        [_db setTraceExecution:NO];
    }
    return ret;
}

- (void)closeDB {
    if (_db != nil) {
        [_db close];
        [_db release];
        _db = nil;
    }
}

- (BOOL)createSqliteTable {
    BOOL ret = NO;
    if ([self openDB]) {
        //创建表account（不存在才创建）
        NSString *createCmd = nil;
        createCmd = @"CREATE TABLE if not exists history (id INTEGER PRIMARY KEY AUTOINCREMENT,cloud_id TEXT,path_id TEXT,item_name TEXT,is_folder BOOLEAN,server_name TEXT,path TEXT,size INTEGER,album_id TEXT,create_time INTEGER,user_id TEXT,is_sync BOOLEAN)";//sql语句表示account不存在才创建；
        ret = [_db executeUpdate:createCmd];
        [self closeDB];
    }
    return ret;
}

- (void)insertData:(IMBFilesHistoryEntity *)model {
    if ([self openDB]) {
        NSString *insertCmd = [NSString stringWithFormat:@"insert into history (cloud_id,path_id,item_name,is_folder,server_name,path,size,album_id,create_time,user_id,is_sync) values ('%@','%@','%@','%d','%@','%@','%@','%@','%@','%@','%d')",model.cloudID,model.pathID,model.itemName,model.isFolder,model.serverName,model.path,model.size,model.albumID,model.createTime,model.userID,model.isSync];
        [_db executeUpdate:insertCmd];
        [self closeDB];
    }
}

- (NSArray *)selectFilesHistory {
    NSMutableArray *array = [NSMutableArray array];
    if ([self openDB]) {
        NSString *selectCmd = @"select *from history ORDER BY create_time DESC";
        FMResultSet *rs = [_db executeQuery:selectCmd];
        while ([rs next]) {
            IMBFilesHistoryEntity *entity = [[IMBFilesHistoryEntity alloc] init];
            if (![rs columnIsNull:@"cloud_id"]) {
                entity.cloudID = [rs stringForColumn:@"cloud_id"];
            }
            if (![rs columnIsNull:@"path_id"]) {
                entity.pathID = [rs stringForColumn:@"path_id"];
            }
            if (![rs columnIsNull:@"item_name"]) {
                entity.itemName = [rs stringForColumn:@"item_name"];
            }
            if (![rs columnIsNull:@"is_folder"]) {
                entity.isFolder = [rs boolForColumn:@"is_folder"];
            }
            if (![rs columnIsNull:@"server_name"]) {
                entity.serverName = [rs stringForColumn:@"server_name"];
            }
            if (![rs columnIsNull:@"path"]) {
                entity.path = [rs stringForColumn:@"path"];
            }
            if (![rs columnIsNull:@"size"]) {
                entity.size = [rs stringForColumn:@"size"];
            }
            if (![rs columnIsNull:@"album_id"]) {
                entity.albumID = [rs stringForColumn:@"album_id"];
            }
            if (![rs columnIsNull:@"create_time"]) {
                entity.createTime = [rs stringForColumn:@"create_time"];
            }
            if (![rs columnIsNull:@"user_id"]) {
                entity.userID = [rs stringForColumn:@"user_id"];
            }
            if (![rs columnIsNull:@"is_sync"]) {
                entity.isSync = [rs boolForColumn:@"is_sync"];
            }
            [array addObject:entity];
            [entity release];
        }
        [rs close];
        [self closeDB];
    }
    return array;
}

- (void)updateSqlite:(IMBFilesHistoryEntity *)model {
    if ([self openDB]) {
        NSString *updateCmd = [NSString stringWithFormat:@"UPDATE history SET cloud_id = '%@',item_name = '%@',is_folder = '%d',server_name = '%@',path = '%@',size = '%@',album_id = '%@',create_time = '%@',user_id = '%@',is_sync = '%d' WHERE path_id = '%@'",model.cloudID,model.itemName,model.isFolder,model.serverName,model.path,model.size,model.albumID,model.createTime,model.userID,model.isSync,model.pathID];
        [_db executeUpdate:updateCmd];
        [self closeDB];
    }
}

- (void)deleteSqlite:(IMBFilesHistoryEntity *)model{
    if ([self openDB]) {
        NSString *deleteCmd = [NSString stringWithFormat:@"DELETE FROM history WHERE path_id = '%@'",model.pathID];
        BOOL ret = [_db executeUpdate:deleteCmd];
        if (ret) {
            for (IMBFilesHistoryEntity *entity in _fileHisArray) {
                if ([entity.pathID isEqualToString:model.pathID]) {
                    [_fileHisArray removeObject:entity];
                    break;
                }
            }
        }
        [self closeDB];
    }
}

- (void)saveOperationRecords:(IMBDriveModel *)model {
    IMBFilesHistoryEntity *entity = [[IMBFilesHistoryEntity alloc] init];
    IMBCloudManager *cloudManager = [IMBCloudManager singleton];
    BaseDrive *drive = [cloudManager getBindDrive:model.driveID];
    entity.cloudID = model.driveID;
    entity.pathID = model.itemIDOrPath;
    entity.itemName = model.fileName;
    entity.isFolder = model.isFolder;
    entity.serverName = drive.driveType;
    entity.path = model.filePath;
    entity.size = [StringHelper getFileSizeString:model.fileSize reserved:2];
//    entity.albumID =
    entity.createTime = [DateHelper dateFrom1970ToString:[[NSDate date] timeIntervalSince1970] withMode:2];
    entity.userID = cloudManager.curEmail;
    entity.isSync = NO;
    [self createSqliteTable];
    [self insertData:entity];
    [_fileHisArray insertObject:model atIndex:0];
    //上传到网页端
    [cloudManager addContent:[NSArray arrayWithObject:entity] Type:@"history" DriveID:model.driveID];
    [entity release];
    entity = nil;
}

- (void)analysisHistoryRecords:(NSArray *)dataAry {
    [_fileHisArray removeAllObjects];
    if (dataAry) {
        for (NSDictionary *dic in dataAry) {
            if (dic) {
                IMBDriveModel *driveModel = [[IMBDriveModel alloc] init];
                if ([dic.allKeys containsObject:@"created_at"]) {
                    driveModel.createdDateString = [dic objectForKey:@"created_at"];
                }
                if ([dic.allKeys containsObject:@"drive_id"]) {
                    driveModel.driveID = [dic objectForKey:@"drive_id"];
                }
                if ([dic.allKeys containsObject:@"is_folder"]) {
                    driveModel.isFolder = [[dic objectForKey:@"is_folder"] boolValue];
                }
                if ([dic.allKeys containsObject:@"path"]) {
                    driveModel.filePath = [dic objectForKey:@"path"];
                }
                if ([dic.allKeys containsObject:@"path_id"]) {
                    driveModel.itemIDOrPath = [dic objectForKey:@"path_id"];
                }
                if ([dic.allKeys containsObject:@"size"]) {
    //                driveModel.fileSize = [dic objectForKey:@"size"];
                }
                if ([dic.allKeys containsObject:@"user_id"]) {
    //                driveModel.user = [dic objectForKey:@"user_id"];
                }
                if ([dic.allKeys containsObject:@"album_id"]) {
                    
                }
                if ([dic.allKeys containsObject:@"file_extension"]) {
                    driveModel.extension = [dic objectForKey:@"file_extension"];
                }
                if ([dic.allKeys containsObject:@"name"]) {
                    driveModel.fileName = [dic objectForKey:@"name"];
                    driveModel.displayName = [driveModel.fileName stringByDeletingPathExtension];
                    if ([StringHelper stringIsNilOrEmpty:driveModel.extension]) {
                        driveModel.extension = [driveModel.fileName pathExtension];
                    }
                }
                if (driveModel.isFolder) {
                    driveModel.fileTypeEnum = Folder;
                    driveModel.extension = @"Folder";
                    if ([driveModel.fileName containsString:@".app" options:0]) {
                        driveModel.fileTypeEnum = AppFile;
                        driveModel.isFolder = NO;
                        driveModel.extension = @"app";
                    }
                }else{
                    driveModel.fileTypeEnum = [TempHelper getFileFormatWithExtension:driveModel.extension];
                }
                driveModel.iConimage = [TempHelper loadFileImage:driveModel.fileTypeEnum];
                driveModel.transferImage = [TempHelper loadFileTransferImage:driveModel.fileTypeEnum];
                [_fileHisArray addObject:driveModel];
                [driveModel release];
                driveModel = nil;
            }
        }
    }
    //获取本地数据库中的数据
    [self selectLocalFilesHistory];
}

- (void)selectLocalFilesHistory {
    if ([self openDB]) {
        NSString *selectCmd = @"select *from history ORDER BY create_time DESC";
        FMResultSet *rs = [_db executeQuery:selectCmd];
        while ([rs next]) {
            NSString *pathID = nil;
            if (![rs columnIsNull:@"path_id"]) {
                pathID = [rs stringForColumn:@"path_id"];
            }
            BOOL isAdd = YES;
            if (![StringHelper stringIsNilOrEmpty:pathID] && _fileHisArray) {
                for (IMBDriveModel *model in _fileHisArray) {
                    if ([model.itemIDOrPath isEqualToString:pathID]) {
                        isAdd = NO;
                        break;
                    }
                }
            }
            if (isAdd) {
                IMBDriveModel *entity = [[IMBDriveModel alloc] init];
                if (![rs columnIsNull:@"cloud_id"]) {
                    entity.driveID = [rs stringForColumn:@"cloud_id"];
                }
                entity.itemIDOrPath = pathID;
                if (![rs columnIsNull:@"item_name"]) {
                    entity.fileName = [rs stringForColumn:@"item_name"];
                    entity.displayName = [entity.fileName stringByDeletingPathExtension];
                    entity.extension = [entity.fileName pathExtension];
                }
                if (![rs columnIsNull:@"server_name"]) {
//                    entity. = [rs stringForColumn:@"server_name"];
                }
                if (![rs columnIsNull:@"path"]) {
                    entity.filePath = [rs stringForColumn:@"path"];
                }
                if (![rs columnIsNull:@"size"]) {
//                    entity.size = [rs stringForColumn:@"size"];
                }
                if (![rs columnIsNull:@"album_id"]) {
//                    entity.albumID = [rs stringForColumn:@"album_id"];
                }
                if (![rs columnIsNull:@"create_time"]) {
                    entity.createdDateString = [rs stringForColumn:@"create_time"];
                }
                if (![rs columnIsNull:@"user_id"]) {
//                    entity.userID = [rs stringForColumn:@"user_id"];
                }
                if (![rs columnIsNull:@"is_sync"]) {
//                    entity.isSync = [rs boolForColumn:@"is_sync"];
                }
                if (![rs columnIsNull:@"is_folder"]) {
                    entity.isFolder = [rs boolForColumn:@"is_folder"];
                }
                if (entity.isFolder) {
                    entity.fileTypeEnum = Folder;
                    entity.extension = @"Folder";
                    if ([entity.fileName containsString:@".app" options:0]) {
                        entity.fileTypeEnum = AppFile;
                        entity.isFolder = NO;
                        entity.extension = @"app";
                    }
                }else{
                    entity.fileTypeEnum = [TempHelper getFileFormatWithExtension:entity.extension];
                }
                entity.iConimage = [TempHelper loadFileImage:entity.fileTypeEnum];
                entity.transferImage = [TempHelper loadFileTransferImage:entity.fileTypeEnum];
                [_fileHisArray addObject:entity];
                [entity release];
                entity = nil;
            }
        }
        [rs close];
        [self closeDB];
    }
}

- (void)dealloc {
    [_fileHisArray release], _fileHisArray = nil;
    [_savePath release], _savePath = nil;
    [super dealloc];
}

@end

@implementation IMBFilesHistoryEntity
@synthesize cloudID = _cloudID;
@synthesize pathID = _pathID;
@synthesize itemName = _itemName;
@synthesize isFolder = _isFolder;
@synthesize serverName = _serverName;
@synthesize path = _path;
@synthesize size = _size;
@synthesize albumID = _albumID;
@synthesize createTime = _createTime;
@synthesize userID = _userID;
@synthesize isSync = _isSync;

@end
