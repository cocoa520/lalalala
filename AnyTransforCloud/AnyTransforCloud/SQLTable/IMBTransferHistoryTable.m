//
//  IMBTransferHistoryTable.m
//  AnyTransforCloud
//
//  Created by hym on 08/05/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBTransferHistoryTable.h"
#import "TempHelper.h"
#import "IMBDriveModel.h"
#import "StringHelper.h"
#import "NSString+Category.h"
#import "DateHelper.h"

@implementation IMBTransferHistoryTable
+ (IMBTransferHistoryTable *)singleton {
    static IMBTransferHistoryTable *_singleton = nil;
    @synchronized(self) {
        if (_singleton == nil) {
            _singleton = [[IMBTransferHistoryTable alloc] init];
        }
    }
    return _singleton;
}

- (void)readSqliteData {
    if (!_upLoadFailAryM) {
        _upLoadFailAryM  = [[NSMutableArray alloc] init];
    }
    if (!_downLoadFailAryM) {
        _downLoadFailAryM = [[NSMutableArray alloc] init];
    }
    if (!_completeAryM) {
        _completeAryM = [[NSMutableArray alloc] init];
    }
    [_upLoadFailAryM removeAllObjects];
    [_downLoadFailAryM removeAllObjects];
    [_completeAryM removeAllObjects];
    
    sqlite3 *dbPoint;
    sqlite3_stmt *stmt=nil;
    NSString *tempPath = [TempHelper getAppiMobieConfigPath];
    NSString *documentPath= [tempPath stringByAppendingPathComponent:@"FileHistory.sqlite"];
    sqlite3_open([documentPath UTF8String], &dbPoint);
    NSString *sldsf = [self greadSqlite];
//    NSString *sldsf = @"create table \"main\".\"FileHistory\" (\"history_id\" integer primary key autoincrement not null, \"transfer_name\" text,\"transfer_exportPath\" text,\"transfer_time\" text,\"transfer_size\" integer, \"transfer_status\" integer, \"transfer_isdown\" integer, \"transfer_id\" text,\"transfer_isfolder\" integer);";
    

    sqlite3_exec(dbPoint, [sldsf UTF8String], nil, nil, nil);
    NSString *sqlStr=@"select * from FileHistory";
    sqlite3_prepare_v2(dbPoint, [sqlStr UTF8String], -1, &stmt, nil);
    while (sqlite3_step(stmt)==SQLITE_ROW) {
        IMBDriveModel *driveItem = [[IMBDriveModel alloc] init];
        const unsigned char *name =sqlite3_column_text(stmt, 1);
        NSString *stuName = nil;
        if (name) {
            stuName =[NSString stringWithUTF8String:(const char *)name];
            driveItem.fileName = stuName;
        }else {
           driveItem.fileName = @"";
        }
        const unsigned char *path =sqlite3_column_text(stmt, 2);
        if (path) {
            NSString *filePath=[NSString stringWithUTF8String:(const char *)path];
            driveItem.localPath = filePath;
        }else {
             driveItem.localPath = @"";
        }
       
         int time =sqlite3_column_int(stmt, 3);
        driveItem.completeInterval = time;
        
        int folder = sqlite3_column_int(stmt, 8);
        driveItem.isFolder = folder;
        
        const unsigned char *dID =sqlite3_column_text(stmt, 9);
        if (dID) {
            NSString *driveId =[NSString stringWithUTF8String:(const char *)dID];
            driveItem.driveID = driveId;
        }else {
            driveItem.driveID = @"";
        }
        
        const unsigned char *fileID =sqlite3_column_text(stmt, 10);
        if (fileID) {
            NSString *itemIDOrPath =[NSString stringWithUTF8String:(const char *)fileID];
            driveItem.itemIDOrPath = itemIDOrPath;
        }else {
            driveItem.itemIDOrPath = @"";
        }
        
        const unsigned char *docwsid =sqlite3_column_text(stmt, 11);
        if (docwsid) {
            NSString *docwsID =[NSString stringWithUTF8String:(const char *)docwsid];
            driveItem.docwsID = docwsID;
        }else {
            driveItem.docwsID = @"";
        }
        
        const unsigned char *zoneChar =sqlite3_column_text(stmt, 12);
        if (zoneChar) {
            NSString *zone =[NSString stringWithUTF8String:(const char *)zoneChar];
            driveItem.zone = zone;
        }else {
            driveItem.zone = @"";
        }
        
        
        NSString *extension = [driveItem.fileName pathExtension];
        if (![StringHelper stringIsNilOrEmpty:extension]) {
            extension = [extension lowercaseString];
        }
        if (folder) {
            driveItem.fileTypeEnum = Folder;
            driveItem.extension = @"Folder";
            driveItem.iConimage = [NSImage imageNamed:@"def_folder_mac"];
            if ([stuName containsString:@".app" options:0]) {
                driveItem.fileTypeEnum = AppFile;
                driveItem.isFolder = NO;
                driveItem.extension = @"app";
                driveItem.iConimage = [NSImage imageNamed:@"def_compress"];
            }
        }else{
            driveItem.fileTypeEnum = [TempHelper getFileFormatWithExtension:extension];
            driveItem.extension = extension;
        }
        
        
        int size =sqlite3_column_int(stmt, 4);
        driveItem.fileSize = size;
        int state =sqlite3_column_int(stmt, 5);
        int isdown =sqlite3_column_int(stmt, 6);
        if (state&&isdown) {
            driveItem.isDownLoad = YES;
            driveItem.state = DownloadStateComplete;
        }else if (state&&!isdown) {
            driveItem.isDownLoad = NO;
            driveItem.state = UploadStateComplete;
        }else if (!state&&isdown){
            driveItem.isDownLoad = YES;
            driveItem.state = DownloadStateError;
        }else if (!state&&!isdown){
            driveItem.isDownLoad = NO;
            driveItem.state = UploadStateError;
        }
        const unsigned char *idtext=sqlite3_column_text(stmt, 7);
        NSString *fileId =[NSString stringWithUTF8String:(const char *)idtext];
        driveItem.fileID = fileId;
        driveItem.transferImage = [TempHelper loadFileTransferImage:driveItem.fileTypeEnum];
        if (driveItem.state == DownloadStateError) {
            if (_downLoadFailAryM.count > 0) {
                [_downLoadFailAryM insertObject:driveItem atIndex:0];
            }else {
                [_downLoadFailAryM addObject:driveItem];
            }
        }else if(driveItem.state == UploadStateError) {
            if (_upLoadFailAryM.count > 0) {
                [_upLoadFailAryM insertObject:driveItem atIndex:0];
            }else {
                [_upLoadFailAryM addObject:driveItem];
            }
        }else if (driveItem.state == DownloadStateComplete || driveItem.state == UploadStateComplete) {
            if (_completeAryM.count > 0) {
                [_completeAryM insertObject:driveItem atIndex:0];
            }else {
                [_completeAryM addObject:driveItem];
            }
        }
    }
}

- (void)saveSqliteWithItem:(IMBDriveModel *)item {
    sqlite3 *dbPoint;
    NSString *tempPath = [TempHelper getAppiMobieConfigPath];
    NSString *documentPath= [tempPath stringByAppendingPathComponent:@"FileHistory.sqlite"];
    sqlite3_open([documentPath UTF8String], &dbPoint);
    
    NSString *sldsf = [self greadSqlite];
    sqlite3_exec(dbPoint, [sldsf UTF8String], nil, nil, nil);

    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    item.completeInterval = interval;
    
    if (item.state == DownloadStateComplete) {
        NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],item.fileName,item.localPath,item.completeInterval,item.fileSize,1,1,item.fileID,item.isFolder,item.driveID,item.itemIDOrPath,item.docwsID,item.zone];
        sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
        item.toDriveName = CustomLocalizedString(@"TransferCompelete", nil);
    }else if (item.state == DownloadStateError){
        NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],item.fileName,item.localPath,item.completeInterval,item.fileSize,0,1,item.fileID,item.isFolder,item.driveID,item.itemIDOrPath,item.docwsID,item.zone];
        sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
        item.toDriveName = CustomLocalizedString(@"TransferFailed", nil);
    }else if (item.state == UploadStateComplete) {
        NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],item.fileName,item.localPath,item.completeInterval,item.fileSize,1,0,item.fileID,item.isFolder,item.driveID,item.itemIDOrPath,item.docwsID,item.zone];
        sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
        item.toDriveName = CustomLocalizedString(@"Transfer_completeView_transferState_Upload_Complete", nil);
    }else if (item.state == UploadStateError) {
        NSString *insertData = [NSString stringWithFormat:[self insertDataSqlite],item.fileName,item.localPath,item.completeInterval,item.fileSize,0,0,item.fileID,item.isFolder,item.driveID,item.itemIDOrPath,item.docwsID,item.zone];
        sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
        item.toDriveName = CustomLocalizedString(@"TransferFailed", nil);
    }
    sqlite3_close(dbPoint);
}

- (NSString *)greadSqlite {
    return  @"create table \"main\".\"FileHistory\" (\"history_id\" integer primary key autoincrement not null, \"transfer_name\" text,\"transfer_exportPath\" text,\"transfer_time\" integer,\"transfer_size\" integer, \"transfer_status\" integer, \"transfer_isdown\" integer, \"transfer_id\" text,\"transfer_isfolder\" integer ,\"transfer_driveId\" text,\"transfer_itemIDOrPath\" text ,\"transfer_docwsID\" text,\"transfer_zone\" text);";
}

//transfer_status 表示下载是否成功 1是成功 0是错误   transfer_isdown  表示是否为下载，1下载 0 上传
- (NSString*)insertDataSqlite {
    NSString *insertData = @"insert into \"main\".\"FileHistory\" (\"transfer_name\",\"transfer_exportPath\",\"transfer_time\",\"transfer_size\",\"transfer_status\",\"transfer_isdown\",\"transfer_id\",\"transfer_isfolder\",\"transfer_driveId\",\"transfer_itemIDOrPath\",\"transfer_docwsID\",\"transfer_zone\") values ('%@','%@','%lld','%lld','%d','%d','%@','%d','%@','%@','%@','%@');";
    return insertData;
}

- (void)deleteDataSqlite:(NSString *)fileId {
    sqlite3 *dbPoint;
    NSString *tempPath = [TempHelper getAppiMobieConfigPath];
    NSString *documentPath= [tempPath stringByAppendingPathComponent:@"FileHistory.sqlite"];
    sqlite3_open([documentPath UTF8String], &dbPoint);

    NSString *insertData = [NSString stringWithFormat:@"DELETE FROM FileHistory WHERE transfer_id = '%@'",fileId];
    sqlite3_exec(dbPoint, [insertData UTF8String], nil, nil, nil);
    sqlite3_close(dbPoint);
}

@end
