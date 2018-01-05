//
//  IMBBookMarkSqliteManager.m
//  AnyTrans
//
//  Created by long on 16-7-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBookMarkSqliteManager.h"
#import "IMBBackupManager.h"
#import "IMBBookmarkEntity.h"
@implementation IMBBookMarkSqliteManager
- (id)initWithAMDevice:(AMDevice *)dev backupfilePath:(NSString *)backupfilePath  withDBType:(NSString *)type WithisEncrypted:(BOOL)isEncrypted withBackUpDecrypt:(IMBBackupDecrypt*)decypt{
    if ([super initWithAMDevice:dev backupfilePath:backupfilePath withDBType:type WithisEncrypted:isEncrypted withBackUpDecrypt:decypt]) {
        _backUpPath = [backupfilePath retain];
        IMBBackupManager *manager = [IMBBackupManager shareInstance];
        if (isEncrypted) {
            [decypt decryptSingleFile:@"HomeDomain" withFilePath:@"Library/Safari/Bookmarks.db"];
            manager.backUpPath = decypt.outputPath;
            if (_backUpPath != nil) {
                [_backUpPath release];
                _backUpPath = nil;
            }
            _backUpPath = [decypt.outputPath retain];
        }
        NSString *sqliteddPath = [manager copysqliteToApptempWithsqliteName:@"Bookmarks.db" backupfilePath:_backUpPath];
        if (sqliteddPath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
        }
    }
    return self;
}

- (id)initWithBackupfilePath:(NSString *)backupfilePath recordArray:(NSMutableArray *)recordArray{
    if (self = [super init]) {
        fm = [NSFileManager defaultManager];
        _logManger = [IMBLogManager singleton];
        _iOSVersion = [[IMBSqliteManager getBackupFileFloatVersion:backupfilePath] retain];
        _backUpPath = [backupfilePath retain];
        NSString *sqliteddPath = [self copysqliteToApptempWithsqliteName:@"Bookmarks.db" backupfilePath:backupfilePath recordArray:recordArray];
        if (sqliteddPath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
        }
    }
    return self;
}

- (id)initWithiCloudBackup:(IMBiCloudBackup*)iCloudBackup withType:(NSString *)type{
    if ([super initWithiCloudBackup:iCloudBackup withType:type]) {
        if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"9"]) {
            NSString *dbNPath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"HomeDomain/Library/Safari/Bookmarks.db"];
            if ([fm fileExistsAtPath:dbNPath]) {
                _databaseConnection = [[FMDatabase alloc] initWithPath:dbNPath];
            }
        }else{
            //遍历需要的文件，然后拷贝到指定的目录下
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", @"Library/Safari/Bookmarks.db"];
            NSArray *tmpArray = [iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
            IMBiCloudFileInfo *bookmarksFile = nil;
            if (tmpArray != nil && tmpArray.count > 0) {
                bookmarksFile = [tmpArray objectAtIndex:0];
            }
            if (bookmarksFile != nil) {
                NSString *sourcefilePath = nil;
                if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"9"]) {
                    NSString *fd = @"";
                    if (bookmarksFile.fileName.length > 2) {
                        fd = [bookmarksFile.fileName substringWithRange:NSMakeRange(0, 2)];
                    }
                    sourcefilePath = [[_backUpPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:bookmarksFile.fileName];
                }else{
                    sourcefilePath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:bookmarksFile.fileName];
                }
                
                if (sourcefilePath != nil) {
                    _databaseConnection = [[FMDatabase alloc] initWithPath:sourcefilePath];
                }
            }
        }
    }
    return self;
}

- (NSMutableArray *)queryAllBookmarks
{
    
    NSMutableArray *allBookmarksArray = [NSMutableArray array];
    NSMutableArray *bookTreeArr = [NSMutableArray array];
    //开启数据库
    [self openDataBase];
    
    NSString *sql = @"select id,parent,type,title,url,editable,deletable,hidden,order_index,external_uuid from bookmarks";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_databaseConnection executeQuery:sql];
    while ([rs next]) {
        
        int bookId = [rs intForColumn:@"id"];
        NSString *bookmarkID = [rs stringForColumn:@"external_uuid"];
        BOOL     isFolder    = [rs boolForColumn:@"type"];
        BOOL     isEditable  = [rs boolForColumn:@"editable"];
        BOOL     isDeletble  = [rs boolForColumn:@"deletable"];
        BOOL     isHidden    = [rs boolForColumn:@"hidden"];
        NSString *url        = [rs stringForColumn:@"url"];
        NSString *title      = [rs stringForColumn:@"title"];
        int      orderIndex  = [rs intForColumn:@"order_index"];
        int      parent      = [rs intForColumn:@"parent"];
        
        if (parent == 0 && [title isEqualToString:@"Root"]) {
            //此为根书签不需要显示
            continue;
        }
        
        if (url == nil || [url isEqualToString:@""]) {
            url =CustomLocalizedString(@"Common_id_10", nil);
        }
        
        if (title == nil || [title isEqualToString:@""]) {
            title = CustomLocalizedString(@"Common_id_10", nil);
        }
        
        IMBBookmarkEntity *bookmark = [[IMBBookmarkEntity alloc] init];
        bookmark.bookId = bookId;
        bookmark.bookMarksId = bookmarkID;
        bookmark.isFolder    = isFolder;
        bookmark.isEditable  = isEditable;
        bookmark.isDeletable = isDeletble;
        bookmark.isHidden    = isHidden;
        bookmark.url         = url;
        bookmark.name        = title;
        bookmark.orderIndex  = orderIndex;
        bookmark.parentNum = parent;
        if (parent == 0) {
            bookmark.isFirstDir = YES;
        }
        //此处找出parent的external_uuid
        if (parent != 0) {
            
            NSString *sql = @"select external_uuid from bookmarks where id=:parent";
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithLongLong:parent], @"parent"
                                    , nil];
            
            FMResultSet *rs = [_databaseConnection executeQuery:sql withParameterDictionary:params];
            while ([rs next]) {
                NSString *parentBookmarkID = [rs stringForColumn:@"external_uuid"];
                bookmark.parent = [NSArray arrayWithObject:parentBookmarkID];
            }
            [rs close];
        }
        
        [allBookmarksArray addObject:bookmark];
        [bookmark release];
    }
    [rs close];
    
    //关闭数据库
    [self closeDataBase];
    
    //此处为boomark找到childArray
    
    for (IMBBookmarkEntity *book in allBookmarksArray) {
        
        if (book.parent == 0&&!book.isFolder) {
            
            [bookTreeArr addObject:book];
        }
        if (book.isFolder) {
            
            NSMutableArray *childArr = [NSMutableArray array];
            NSMutableArray *subFolderArr = [NSMutableArray array];
            for ( IMBBookmarkEntity *mark in  allBookmarksArray)
            {
                if (mark.parent.count>0) {
                    
                    if ([[mark.parent objectAtIndex:0] isEqualToString:book.bookMarksId])
                    {
                        [childArr addObject:mark];
                        if (mark.isFolder) {
                            book.hassubFolder = YES;
                            [subFolderArr addObject:mark];
                            
                        }
                    }
                }
            }
            
            if (childArr.count>0) {
                
                book.childBookmarkArray = childArr;
            }
            
            if (book.parent == nil&&book.isFolder) {
                
                [bookTreeArr addObject:book];
            }
            //得到目录下的目录
            if (subFolderArr.count>0) {
                book.subFolderArray = subFolderArr;
            }
            
            
        }
        
    }
    
    for ( IMBBookmarkEntity *bookmark in allBookmarksArray) {
        
        if (bookmark.isFolder) {
            
            //得到目录下所有的书签
            NSMutableArray *allbookMarksArray = [NSMutableArray array];
            [self getAllBookmarks:bookmark.childBookmarkArray allbookmarksArray:allbookMarksArray];
            bookmark.allBookmarkArray = allbookMarksArray;
            
        }else
        {
            bookmark.allBookmarkArray = [NSMutableArray arrayWithObject:bookmark];
        }
        
    }
    NSArray *resultArray = [bookTreeArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        IMBBookmarkEntity *entity1 = (IMBBookmarkEntity *)obj1;
        IMBBookmarkEntity *entity2 = (IMBBookmarkEntity *)obj2;
        if (entity1.isFolder&&!entity2.isFolder) {
            
            return NSOrderedAscending;
        }else
        {
            return NSOrderedDescending;
        }
        
    }];
    NSMutableArray *result = [NSMutableArray array];
    [result addObjectsFromArray:resultArray];
    
    
    return result;
}

//parms array是目录下的选项
- (void)getAllBookmarks:(NSMutableArray *)array allbookmarksArray:(NSMutableArray *)allbookmarksArray
{
    for (IMBBookmarkEntity* bookmark in array) {
        
        if (!bookmark.isFolder) {
            
            [allbookmarksArray addObject:bookmark];
            
        }else
        {
            [self getAllBookmarks:bookmark.childBookmarkArray allbookmarksArray:allbookmarksArray];
            
        }
        
    }
}


- (BOOL)exportTofolderPath:(NSString *)folderPath bookmarkArray:(NSArray *)bookmarkArray fileName:(NSString *)fileName
{
    //不知道用没用
    if (fileName == nil) {
        fileName = @"bookmark.txt";
    }else
    {
        fileName = [NSString stringWithFormat:@"%@.txt",fileName];
    }
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    if ([fm fileExistsAtPath:filePath]) {

        filePath = [self createDifferentfileNameinfolder:folderPath filePath:filePath fileManager:fm];
    }
    BOOL success = [fm createFileAtPath:filePath contents:nil attributes:nil];
    if (success) {
        NSFileHandle *fhandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        
        NSArray *bookmarkArr = bookmarkArray;
        for (int i=0;i<[bookmarkArr count]; i++) {
            IMBBookmarkEntity *bookmark = [bookmarkArr objectAtIndex:i];
            
            NSData *data = nil;
            if (![bookmark isFolder]) {
                data = [[bookmark description] dataUsingEncoding:NSUTF8StringEncoding];
                [fhandle writeData:data];
            }
        }
        return YES;
    }else
    {
        return NO;
        
    }
    
    
}


@end
