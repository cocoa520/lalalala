//
//  IMBDriveImageSqltie.m
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/5/4.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBDriveImageSqltie.h"
#import "TempHelper.h"
@implementation IMBDriveImageSqltie
@synthesize accountArray = _accountArray;

- (id)initWithPath:(NSString *)savePath {
    self = [super init];
    if (self) {
        _savePath = [[savePath stringByAppendingPathComponent:@"DriveImage"] retain];
        _accountArray = [[NSMutableArray alloc] init];
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

- (void)selectAccountDatail {
    [_accountArray removeAllObjects];
    if ([self openDB]) {
        NSString *selectCmd = @"select *from DriveImage";
        FMResultSet *rs = [_db executeQuery:selectCmd];
        while ([rs next]) {
            IMBPhotoSqliteEntity *photoSqliteEntity = [[IMBPhotoSqliteEntity alloc]init];
            if (![rs columnIsNull:@"file_id"]) {
                photoSqliteEntity.fileID = [rs stringForColumn:@"file_id"];
            }
            photoSqliteEntity.md5Name = [rs stringForColumn:@"image_name"];
            photoSqliteEntity.firstBytesData = (NSMutableData *)[rs dataForColumn:@"first_bytes_data"];
            
            [_accountArray addObject:photoSqliteEntity];
            [photoSqliteEntity release];
            photoSqliteEntity = nil;
        }
        [rs close];
        [self closeDB];
    }
}

- (BOOL)createAccountTable {
    NSString *createCmd = nil;
    createCmd = @"create table \"main\".\"DriveImage\" (\"id\" integer primary key autoincrement not null, \"image_name\" text,\"file_id\" text,\"type\" text,\"create_time\" text,\"first_bytes_data\" BLOB);";
    return [_db executeUpdate:createCmd];
}

- (void)insertData:(NSString *)imageName fileID:(NSString *)fileID type:(NSString *)type  createTime:(NSString *)createTime imageFirstBytes:(NSData *)firstBytesStr {
    [_db executeUpdate: @"insert into DriveImage (image_name,file_id,type,create_time,first_bytes_data) values (?,?,?,?,?)",imageName,fileID,type,createTime,firstBytesStr];
}

- (void)deleteSqlite:(NSString *)fileId {
    if ([self openDB]) {
        NSString *deleteCmd = [NSString stringWithFormat:@"DELETE FROM DriveImage WHERE file_id = '%@'",fileId];
        BOOL ret = [_db executeUpdate:deleteCmd];
        if (ret) {
        }
        [self closeDB];
    }
}

@end
