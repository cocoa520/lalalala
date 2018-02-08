//
//  IMBBookmarkClone.m
//  iMobieTrans
//
//  Created by iMobie on 14-12-22.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBookmarkClone.h"
#import "IMBBookmarkEntity.h"
@implementation IMBBookmarkClone

- (void)setsourceBackupPath:(NSString *)sourceBackupPath desBackupPath:(NSString *)desBackupPath sourcerecordArray:(NSMutableArray *)sourcerecordArray targetrecordArray:(NSMutableArray *)targetrecordArray
{
    [super setsourceBackupPath:sourceBackupPath desBackupPath:desBackupPath sourcerecordArray:sourcerecordArray targetrecordArray:targetrecordArray];
    _sourceBackuppath = [sourceBackupPath retain];
    _targetBakcuppath = [desBackupPath retain];
    {
        sourceRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/Safari/Bookmarks.db" recordArray:_sourcerecordArray] retain];
        NSString *rstr = [sourceRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,sourceRecord.key];
        sourceRecord.relativePath = relativePath;
        _sourceSqlitePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"sourceSqlite"] fileRecord:sourceRecord backupfilePath:sourceBackupPath] retain];
    }
    {
        targetRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/Safari/Bookmarks.db" recordArray:_targetrecordArray] retain];
        NSString *rstr = [targetRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,targetRecord.key];
        targetRecord.relativePath = relativePath;
        _targetSqlitePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"targetSqlite"] fileRecord:targetRecord backupfilePath:desBackupPath] retain];
    }
}

#pragma - mark Merge
- (void)merge:(NSArray *)bookmarkArray
{
    [_logHandle writeInfoLog:[NSString stringWithFormat:@"merge bookmark count:%d",bookmarkArray.count]];
    @try {
        if ([self openDataBase:_sourceDBConnection]&& [self openDataBase:_targetDBConnection]) {
            [_logHandle writeInfoLog:@"mergeBookmark enter"];
            [_sourceDBConnection beginTransaction];
            [_targetDBConnection beginTransaction];
            int rootID = 0;
            NSString *rootselectSql = @"select id from bookmarks where title='Root' and parent is null";
            FMResultSet *rootRS = [_sourceDBConnection executeQuery:rootselectSql];
            while ([rootRS next]) {
                rootID = [rootRS intForColumn:@"id"];
            }
            [rootRS close];
            [self mergeBookmark:(NSMutableArray *)bookmarkArray targetParentId:rootID];
            if (![_sourceDBConnection commit]) {
                [_sourceDBConnection rollback];
            }
            if (![_targetDBConnection commit]) {
                [_targetDBConnection rollback];
            }
            [_sourceDBConnection close];
            [_targetDBConnection close];
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"异常原因:%@",exception]];
    }
    [_logHandle writeInfoLog:@"mergeBookmark exit"];
    [self modifyHashAndManifest];
}

- (void)mergeBookmark:(NSMutableArray *)bookmarkArray targetParentId:(int)targetParentID
{
    for (IMBBookmarkEntity *entity in bookmarkArray) {
        @autoreleasepool {
            NSString *sql1 = @"select * from bookmarks where id=:bookmarkID";
            NSString *sql2 = @"insert into bookmarks(special_id,parent,type,title,url,num_children,editable,deletable,hidden,hidden_ancestor_count,order_index,external_uuid,read,last_modified,server_id,sync_key,sync_data,added,deleted,extra_attributes,local_attributes,fetched_icon,icon,dav_generation) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            //执行sql语句,返回结果集
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:entity.bookId] forKey:@"bookmarkID"];
            FMResultSet *rs = [_sourceDBConnection executeQuery:sql1 withParameterDictionary:dic];
            while ([rs next]) {
                NSInteger special_id = [rs intForColumn:@"special_id"];
                NSInteger parent = targetParentID;
                NSInteger type = [rs intForColumn:@"type"];
                NSString *title = [rs stringForColumn:@"title"];
                NSString *url = [rs stringForColumn:@"url"];
                NSInteger num_children = 0;
                if (type == 1) {
                    //判断文件夹是否存在
                    int bookmarkId = [self checkTitle:title parentID:targetParentID targetDB:_targetDBConnection];
                    if (bookmarkId !=-1) {
                        //如果存在进行递归
                        [self mergeBookmark:entity.childBookmarkArray targetParentId:bookmarkId];
                        break;
                    }
                }else{
                    //验重
                    if ([self checkTitle:title url:url parentID:targetParentID targetDB:_targetDBConnection] != -1) {
                        break;
                    }
                }
                NSInteger editable = [rs intForColumn:@"editable"];
                NSInteger deletable = [rs intForColumn:@"deletable"];
                NSInteger hidden = [rs intForColumn:@"hidden"];
                NSInteger hidden_ancestor_count = [rs intForColumn:@"hidden_ancestor_count"];
                NSInteger order_index = [rs intForColumn:@"order_index"];
                NSString *external_uuid = [rs stringForColumn:@"external_uuid"];
                NSInteger read = [rs intForColumn:@"read"];
                double last_modified = [rs doubleForColumn:@"last_modified"];
                NSString *server_id = [rs stringForColumn:@"server_id"];
                NSString *sync_key = [rs stringForColumn:@"sync_key"];
                NSData *sync_data = [rs dataForColumn:@"sync_data"];
                NSInteger added = [rs intForColumn:@"added"];
                NSInteger deleted = [rs intForColumn:@"deleted"];
                NSData *extra_attributes = [rs dataForColumn:@"extra_attributes"];
                NSData *local_attributes = [rs dataForColumn:@"local_attributes"];
                BOOL fetched_icon = [rs boolForColumn:@"fetched_icon"];
                NSData *icon = [rs dataForColumn:@"icon"];
                NSInteger dav_generation = [rs intForColumn:@"dav_generation"];
                BOOL success = [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInteger:special_id],[NSNumber numberWithInteger:parent],[NSNumber numberWithInteger:type],title,url,[NSNumber numberWithInteger:num_children],[NSNumber numberWithInteger:editable],[NSNumber numberWithInteger:deletable],[NSNumber numberWithInteger:hidden],[NSNumber numberWithInteger:hidden_ancestor_count],[NSNumber numberWithInteger:order_index],external_uuid,[NSNumber numberWithInteger:read],[NSNumber numberWithDouble:last_modified],server_id,sync_key,sync_data,[NSNumber numberWithInteger:added],[NSNumber numberWithInteger:deleted],extra_attributes,local_attributes,[NSNumber numberWithBool:fetched_icon],icon,[NSNumber numberWithInteger:dav_generation]];
                if (success) {
                    int newbookmarkID = -1;
                    NSString *sql3 = @"select last_insert_rowid() from bookmarks";
                    FMResultSet *rs1 = [_targetDBConnection executeQuery:sql3];
                    while ([rs1 next]) {
                        newbookmarkID = [rs1 intForColumn:@"last_insert_rowid()"];
                    }
                    [rs1 close];
                    //使其父目录 num_children + 1
                    NSString *sql4 = @"update bookmarks set num_children=num_children+1  where id=:parentID";
                    NSDictionary *params2 = [NSDictionary dictionaryWithObject:@(targetParentID) forKey:@"parentID"];
                    [_targetDBConnection executeUpdate:sql4 withParameterDictionary:params2];
                    if (type == 1 && newbookmarkID != -1) {
                        //如果是目录 进行递归
                        [self mergeBookmark:entity.childBookmarkArray targetParentId:newbookmarkID];
                        break;
                    }else{
                        
                    }
                }
            }
            [rs close];
        }
    }
}
//文件夹进行验重判断
- (int)checkTitle:(NSString *)title parentID:(int)parentID targetDB:(FMDatabase *)targetDB
{
    int bookmarkID = -1;
    NSString *sql = @"select id from bookmarks where title=:title and parent=:parentID";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:title?:@"" ,@"title",[NSNumber numberWithInt:parentID],@"parentID",nil];
    FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:params];
    while ([rs next]) {
        bookmarkID = [rs intForColumnIndex:0];
        break;
    }
    [rs close];
    return bookmarkID;
}
//非文件夹 进行验重
- (int)checkTitle:(NSString *)title url:(NSString *)url parentID:(int)parentID targetDB:(FMDatabase *)targetDB
{
    int bookmarkID = -1;
    NSString *sql = @"select id from bookmarks where title=:title and url=:url and parent=:parentID";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:title?:@"" ,@"title",url?:@"" ,@"url",[NSNumber numberWithInt:parentID],@"parentID",nil];
    FMResultSet *rs = [targetDB executeQuery:sql withParameterDictionary:params];
    while ([rs next]) {
        bookmarkID = [rs intForColumnIndex:0];
        break;
    }
    [rs close];
    return bookmarkID;
}

#pragma - mark Clone
- (void)clone
{
    //开启数据库
    //如果是从高到底去插入数据库
    [_logHandle writeInfoLog:@"cloneBookmark enter"];
    if (_sourceVersion<=_targetVersion) {
        int version = _sourceVersion;
        _sourceVersion = _targetVersion;
        _targetVersion = version;
        if ([_sourceFloatVersion isVersionLessEqual:_targetFloatVersion]) {
            if (isneedClone) {
                return;
            }
            IMBMBFileRecord *record = sourceRecord;
            sourceRecord = targetRecord;
            targetRecord = record;
            
            NSString *backupPath = _sourceBackuppath;
            _sourceBackuppath = _targetBakcuppath;
            _targetBakcuppath = backupPath;
            
            NSString *sqlitePath = _sourceSqlitePath;
            _sourceSqlitePath = _targetSqlitePath;
            _targetSqlitePath = sqlitePath;
            
            NSMutableArray *recordArray = _sourcerecordArray;
            _sourcerecordArray = _targetrecordArray;
            _targetrecordArray = recordArray;
            
            FMDatabase *dataCo = _sourceManifestDBConnection;
            _sourceManifestDBConnection = _targetManifestDBConnection;
            _targetManifestDBConnection = dataCo;
            
            NSString *version = _sourceFloatVersion;
            _sourceFloatVersion = _targetFloatVersion;
            _targetFloatVersion = version;

        }else
        {
            if (!isneedClone) {
                return;
            }
        }
    }else
    {
        if (!isneedClone) {
            return;
        }
    }
    @try {
        if ([self openDataBase:_sourceDBConnection]&& [self openDataBase:_targetDBConnection]){
            [_sourceDBConnection beginTransaction];
            [_targetDBConnection beginTransaction];
            [self deletebookmarksData:_targetDBConnection];
            if (_sourceVersion>=_targetVersion) {
                if (_targetVersion==5) {
                    [self insertbookmarksWithiOS5];
                }else
                {
                    [self insertbookmarks];
                }
            }
            [self insertbookmark_title_words];
            [self insertfolder_ancestors];
            [self insertgenerations];
            [self insertsync_properties];
            if (![_sourceDBConnection commit]) {
                [_sourceDBConnection rollback];
            }
            if (![_targetDBConnection commit]) {
                [_targetDBConnection rollback];
            }
            
            [self closeDataBase:_sourceDBConnection];
            [self closeDataBase:_targetDBConnection];
        }

    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"异常原因:%@",exception]];
    }
    [_logHandle writeInfoLog:@"cloneBookmark exit"];
    //修改HashandManifest
    [self modifyHashAndManifest];
}

- (void)deletebookmarksData:(FMDatabase *)database
{
    NSString *sql2 = @"delete from bookmarks where id!=0";
    [database executeUpdate:sql2];
    NSString *sql4 = @"delete from generations";
    NSString *sql5 = @"delete from sync_properties";
    [database executeUpdate:sql4];
    [database executeUpdate:sql5];
}

- (void)insertbookmark_title_words
{
    NSString *sql1 = @"select * from bookmark_title_words";
    NSString *sql2 = @"insert into bookmark_title_words(id, bookmark_id,word,word_index) values(?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger id1 = [rs intForColumn:@"id"];
        NSInteger bookmark_id = [rs intForColumn:@"bookmark_id"];
        NSString *word = [rs stringForColumn:@"word"];
        NSInteger word_index = [rs intForColumn:@"word_index"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:id1],[NSNumber numberWithInt:bookmark_id],word,[NSNumber numberWithInt:word_index]];
    }
    [rs close];
}

- (void)insertbookmarks
{
    
    NSString *sql1 = @"select * from bookmarks";
    NSString *sql2 = @"insert into bookmarks(id, special_id,parent,type,title,url,num_children,editable,deletable,hidden,hidden_ancestor_count,order_index,external_uuid,read,last_modified,server_id,sync_key,sync_data,added,deleted,extra_attributes,local_attributes,fetched_icon,icon,dav_generation,locally_added,archive_status) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
   
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger id1 = [rs intForColumn:@"id"];
        if (id1==0) {
            NSInteger num_children = [rs intForColumn:@"num_children"];
            NSString *sql = @"update bookmarks set num_children=:numchildren where id=0";
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:num_children],@"numchildren", nil];
            [_targetDBConnection executeUpdate:sql withParameterDictionary:dic];
            continue;
        }
        NSInteger special_id = [rs intForColumn:@"special_id"];
        NSInteger parent = [rs intForColumn:@"parent"];
        NSInteger type = [rs intForColumn:@"type"];
        NSString *title = [rs stringForColumn:@"title"];
        NSString *url = [rs stringForColumn:@"url"];
        NSInteger num_children = [rs intForColumn:@"num_children"];
        NSInteger editable = [rs intForColumn:@"editable"];
        NSInteger deletable = [rs intForColumn:@"deletable"];
        NSInteger hidden = [rs intForColumn:@"hidden"];
        NSInteger hidden_ancestor_count = [rs intForColumn:@"hidden_ancestor_count"];
        NSInteger order_index = [rs intForColumn:@"order_index"];
        NSString *external_uuid = [rs stringForColumn:@"external_uuid"];
        NSInteger read = [rs intForColumn:@"read"];
        double last_modified = [rs doubleForColumn:@"last_modified"];
        NSString *server_id = [rs stringForColumn:@"server_id"];
        NSString *sync_key = [rs stringForColumn:@"sync_key"];
        NSData *sync_data = [rs dataForColumn:@"sync_data"];
        NSInteger added = [rs intForColumn:@"added"];
        NSInteger deleted = [rs intForColumn:@"deleted"];
        NSData *extra_attributes = [rs dataForColumn:@"extra_attributes"];
        NSData *local_attributes = [rs dataForColumn:@"local_attributes"];
        BOOL fetched_icon = [rs boolForColumn:@"fetched_icon"];
        NSData *icon = [rs dataForColumn:@"icon"];
        NSInteger dav_generation = [rs intForColumn:@"dav_generation"];
        BOOL locally_added = [rs boolForColumn:@"locally_added"];
        NSInteger archive_status = [rs intForColumn:@"archive_status"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:id1],[NSNumber numberWithInt:special_id],[NSNumber numberWithInt:parent],[NSNumber numberWithInt:type],title,url,[NSNumber numberWithInt:num_children],[NSNumber numberWithInt:editable],[NSNumber numberWithInt:deletable],[NSNumber numberWithInt:hidden],[NSNumber numberWithInt:hidden_ancestor_count],[NSNumber numberWithInt:order_index],external_uuid,[NSNumber numberWithInt:read],[NSNumber numberWithDouble:last_modified],server_id,sync_key,sync_data,[NSNumber numberWithInt:added],[NSNumber numberWithInt:deleted],extra_attributes,local_attributes,[NSNumber numberWithBool:fetched_icon],icon,[NSNumber numberWithInt:dav_generation],[NSNumber numberWithBool:locally_added],[NSNumber numberWithInt:archive_status]];
      }
    [rs close];
}

- (void)insertbookmarksWithiOS5
{

    NSString *sql1 = @"select * from bookmarks where  id!=0";
    NSString *sql2 = @"insert into bookmarks(id, special_id,parent,type,title,url,num_children,editable,deletable,hidden,hidden_ancestor_count,order_index,external_uuid,read,last_modified,server_id,sync_key,sync_data,added,deleted,extra_attributes,fetched_icon,icon,dav_generation) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger id1 = [rs intForColumn:@"id"];
        NSInteger special_id = [rs intForColumn:@"special_id"];
        NSInteger parent = [rs intForColumn:@"parent"];
        NSInteger type = [rs intForColumn:@"type"];
        NSString *title = [rs stringForColumn:@"title"];
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"insert bookmark title:%@ enter",title]];
        NSString *url = [rs stringForColumn:@"url"];
        NSInteger num_children = [rs intForColumn:@"num_children"];
        NSInteger editable = [rs intForColumn:@"editable"];
        NSInteger deletable = [rs intForColumn:@"deletable"];
        NSInteger hidden = [rs intForColumn:@"hidden"];
        NSInteger hidden_ancestor_count = [rs intForColumn:@"hidden_ancestor_count"];
        NSInteger order_index = [rs intForColumn:@"order_index"];
        NSString *external_uuid = [rs stringForColumn:@"external_uuid"];
        NSInteger read = [rs intForColumn:@"read"];
        double last_modified = [rs doubleForColumn:@"last_modified"];
        NSString *server_id = [rs stringForColumn:@"server_id"];
        NSString *sync_key = [rs stringForColumn:@"sync_key"];
        NSData *sync_data = [rs dataForColumn:@"sync_data"];
        NSInteger added = [rs intForColumn:@"added"];
        NSInteger deleted = [rs intForColumn:@"deleted"];
        NSData *extra_attributes = [rs dataForColumn:@"extra_attributes"];
        //NSData *local_attributes = [rs dataForColumn:@"local_attributes"];
        BOOL fetched_icon = [rs boolForColumn:@"fetched_icon"];
        NSData *icon = [rs dataForColumn:@"icon"];
        NSInteger dav_generation = [rs intForColumn:@"dav_generation"];
//        BOOL locally_added = [rs boolForColumn:@"locally_added"];
//        NSInteger archive_status = [rs intForColumn:@"archive_status"];
        BOOL success = [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:id1],[NSNumber numberWithInt:special_id],[NSNumber numberWithInt:parent],[NSNumber numberWithInt:type],title,url,[NSNumber numberWithInt:num_children],[NSNumber numberWithInt:editable],[NSNumber numberWithInt:deletable],[NSNumber numberWithInt:hidden],[NSNumber numberWithInt:hidden_ancestor_count],[NSNumber numberWithInt:order_index],external_uuid,[NSNumber numberWithInt:read],[NSNumber numberWithDouble:last_modified],server_id,sync_key,sync_data,[NSNumber numberWithInt:added],[NSNumber numberWithInt:deleted],extra_attributes,[NSNumber numberWithBool:fetched_icon],icon,[NSNumber numberWithInt:dav_generation]];
        if (success) {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"insert bookmark title:%@ success",title]];
        }else
        {
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"insert bookmark title:%@ failure",title]];
        }
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"insert bookmark title:%@ exit",title]];
    }
    [rs close];
}

- (void)insertfolder_ancestors
{
    NSString *sql1 = @"select * from folder_ancestors";
    NSString *sql2 = @"insert into folder_ancestors(id, folder_id,ancestor_id) values(?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger id1 = [rs intForColumn:@"id"];
        NSInteger folder_id = [rs intForColumn:@"folder_id"];
        NSInteger ancestor_id = [rs intForColumn:@"ancestor_id"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:id1],[NSNumber numberWithInt:folder_id],[NSNumber numberWithInt:ancestor_id]];
    }
    [rs close];
}

- (void)insertgenerations
{
    NSString *sql1 = @"select * from generations";
    NSString *sql2 = @"insert into generations(rowid, generation) values(?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger rowid = [rs intForColumn:@"rowid"];
          NSInteger generation = [rs intForColumn:@"generation"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:rowid],[NSNumber numberWithInt:generation]];
    }
    [rs close];
}

- (void)insertsync_properties
{
    NSString *sql1 = @"select * from sync_properties";
    NSString *sql2 = @"insert into sync_properties(key,value) values(?,?)";
   //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSString *key = [rs stringForColumn:@"key"];
        NSData *data = [rs dataForColumn:@"value"];
        NSString *value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (value == nil) {
             [_targetDBConnection executeUpdate:sql2,key,data];
        }else
        {
            [_targetDBConnection executeUpdate:sql2,key,value];
        }
    }
    [rs close];
}
@end
