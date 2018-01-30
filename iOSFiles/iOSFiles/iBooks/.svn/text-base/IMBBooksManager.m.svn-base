//
//  IMBBooksManager.m
//  iMobieTrans
//
//  Created by iMobie on 14-3-17.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBooksManager.h"
#import "TempHelper.h"
#import "IMBBookEntity.h"
#import "IMBBookCollection.h"
//#import "ZipWriteStream.h"
//#import "ZipFile.h"
#import "IMBIPod.h"
#import "StringHelper.h"

#define BookList                 @"Books/Books.plist"
#define PurchaseBookList         @"Books/Purchases/Purchases.plist"
#define OutstandingAssetsSqlite  @"Books/Sync/Database/OutstandingAssets_4.sqlite"
#define OutstandingAssetsSqlite_shm  @"Books/Sync/Database/OutstandingAssets_4.sqlite-shm"
#define OutstandingAssetsSqlite_wal  @"Books/Sync/Database/OutstandingAssets_4.sqlite-wal"
#define IBooksSqlite                @"Documents/BKLibrary_database/iBooks_v10252011_2152.sqlite"
#define IBooksSqlite_shm                @"Documents/BKLibrary_database/iBooks_v10252011_2152.sqlite-shm"
#define IBooksSqlite_wal                @"Documents/BKLibrary_database/iBooks_v10252011_2152.sqlite-wal"
@implementation IMBBooksManager

- (id)initWithIpod:(IMBiPod *)ipod
{
    if (self = [super init]) {
        _ipod = [ipod retain];
        _logManger = [IMBLogManager singleton];
        fm = [NSFileManager defaultManager];
    }
    return self;
}

- (NSMutableArray *)queryAllbooks
{
    _logManger = [IMBLogManager singleton];
    [_logManger writeInfoLog:@"begin query All books"];
     //查询之前，现将Book目录下的plist文件考到指定的tmp目录下
    NSMutableArray *bookArray = [NSMutableArray array];
    if ([[_ipod fileSystem] fileExistsAtPath:BookList]) {
        
        NSString *filePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"Books.plist"];
        if ([fm fileExistsAtPath:filePath]) {
            //如果存在则先删除掉
            [fm removeItemAtPath:filePath error:nil];
        }
        BOOL issuccess = [[_ipod fileSystem] copyRemoteFile:BookList  toLocalFile:filePath];
        if (issuccess) {
            
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
            NSArray *arr = [dic objectForKey:@"Books"];
            for (NSDictionary *bookDic in arr) {
                IMBBookEntity *book = [[IMBBookEntity alloc] initWithDataDic:bookDic];
                if (![TempHelper stringIsNilOrEmpty:book.path]) {
                    book.extension = [[book.path pathExtension] lowercaseString];
                } else {
                    book.extension = @"";
                }
                
                if (![TempHelper stringIsNilOrEmpty:book.bookName]) {
                    NSString *bookName = [book.bookName lowercaseString];
                    if ([bookName hasSuffix:@".pdf"] || [bookName hasSuffix:@".epub"]) {
                        book.bookName = [book.bookName stringByDeletingPathExtension];
                    }
                }
                
                
                if ([book.extension caseInsensitiveCompare:@"epub"] == NSOrderedSame) {
                    
                    book.coverPath = [NSString stringWithFormat:@"Books/%@/iTunesArtwork",book.path];
                    
                }else if([book.extension caseInsensitiveCompare:@"pdf"] == NSOrderedSame)
                {
                    
                }
                book.fullPath = [NSString stringWithFormat:@"Books/%@",book.path];
                book.isProtected = [[bookDic objectForKey:@"Is Protected"] boolValue];
                book.hasArtwork = [[bookDic objectForKey:@"Has Artwork"] boolValue];
                [bookArray addObject:book];
                [book release];
                
            }
        }else
        {
        
            NSLog(@"拷贝失败");
        }
    }
    
    if ([[_ipod fileSystem] fileExistsAtPath:PurchaseBookList]) {
        
        NSString *filePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"Purchases.plist"];
        if ([fm fileExistsAtPath:filePath]) {
            //如果存在则先删除掉
            [fm removeItemAtPath:filePath error:nil];
        }
        BOOL issuccess = [[_ipod fileSystem] copyRemoteFile:PurchaseBookList  toLocalFile:filePath];
        if (issuccess) {
            
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
            NSArray *arr = [dic objectForKey:@"Books"];
            for (NSDictionary *bookDic in arr) {
                
                IMBBookEntity *book = [[IMBBookEntity alloc] initWithDataDic:bookDic];
                
                if (![TempHelper stringIsNilOrEmpty:book.path]) {
                    book.extension = [[book.path pathExtension] lowercaseString];
                } else {
                    book.extension = @"";
                }
                
                if (![TempHelper stringIsNilOrEmpty:book.bookName]) {
                    NSString *bookName = [book.bookName lowercaseString];
                    if ([bookName hasSuffix:@".pdf"] || [bookName hasSuffix:@".epub"]) {
                        book.bookName = [book.bookName stringByDeletingPathExtension];
                    }
                }
                book.isPurchase = YES;
                if ([book.extension caseInsensitiveCompare:@"epub"] == NSOrderedSame) {
                    
                    book.coverPath = [NSString stringWithFormat:@"Books/Purchases/%@/iTunesArtwork",book.path];
                    
                }else if([book.extension caseInsensitiveCompare:@"pdf"] == NSOrderedSame)
                {
                
                }
                book.fullPath = [NSString stringWithFormat:@"Books/Purchases/%@",book.path];
                [bookArray addObject:book];
                [book release];
                
            }
        }else
        {
            
            NSLog(@"拷贝失败");
            
        }
    }
    //将数据库拷贝指定的路径
    if ([[_ipod fileSystem] fileExistsAtPath:OutstandingAssetsSqlite]) {
        
        NSString *filePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"OutstandingAssets_4.sqlite"];
        
        if ([fm fileExistsAtPath:filePath]) {
            [fm removeItemAtPath:filePath error:nil];
        }
        BOOL issuccess = [[_ipod fileSystem] copyRemoteFile:OutstandingAssetsSqlite toLocalFile:filePath];
        if (issuccess) {
            if ([[_ipod fileSystem] fileExistsAtPath:OutstandingAssetsSqlite_shm]) {
                
                  NSString *filePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"OutstandingAssets_4.sqlite-shm"];
                if ([fm fileExistsAtPath:filePath]) {
                    [fm removeItemAtPath:filePath error:nil];
                }
                [[_ipod fileSystem] copyRemoteFile:OutstandingAssetsSqlite_shm toLocalFile:filePath];

            }
            if ([[_ipod fileSystem] fileExistsAtPath:OutstandingAssetsSqlite_wal]) {
                
                NSString *filePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"OutstandingAssets_4.sqlite-wal"];
                if ([fm fileExistsAtPath:filePath]) {
                    [fm removeItemAtPath:filePath error:nil];
                }
                [[_ipod fileSystem] copyRemoteFile:OutstandingAssetsSqlite_wal toLocalFile:filePath];
                
                
            }
            
            _databaseConnection = [[FMDatabase alloc] initWithPath:filePath];
            //开启数据库连接
            [self openDataBase];
            
            for (IMBBookEntity *book in bookArray) {
                
                NSString *sql = @"select ZCOMPUTEDSIZE from ZBCINSTALLEDASSET where ZPERSISTENTID=:persistenceID";
                NSDictionary *parms = nil;
                FMResultSet *rs = nil;
                if (book.bookID != nil) {
                    parms = [NSDictionary dictionaryWithObject:book.bookID forKey:@"persistenceID"];
                    rs = [_databaseConnection executeQuery:sql withParameterDictionary:parms];
                }
             
                while ([rs next]) {
                    
                    int size = [rs intForColumn:@"ZCOMPUTEDSIZE"];
                    book.size = size;
                    
                    
                }

                [rs close];
            }
            //关闭数据库连接
            [self closeDataBase];
            
        }else
        {
            NSLog(@"拷贝失败");
        }
    }
    //通过连接iBooks应用程序目录，获取book对象所属的集合
    AFCApplicationDirectory *applicationDir = [_device newAFCApplicationDirectory:@"com.apple.iBooks"];
    if (applicationDir == nil) {
        NSLog(@"没有安装iBooks软件");
    }else
    {
        if ([applicationDir fileExistsAtPath:IBooksSqlite]) {
            
            NSString *filePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"iBooks_v10252011_2152.sqlite"];
            
            if ([fm fileExistsAtPath:filePath]) {
                [fm removeItemAtPath:filePath error:nil];
            }
            
            
            BOOL issuccess = [applicationDir copyRemoteFile:IBooksSqlite toLocalFile:filePath];
            if (issuccess) {
                if ([applicationDir fileExistsAtPath:IBooksSqlite_shm]) {
                    
                    NSString *filePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"iBooks_v10252011_2152.sqlite-shm"];
                    if ([fm fileExistsAtPath:filePath]) {
                        [fm removeItemAtPath:filePath error:nil];
                    }
                    [applicationDir copyRemoteFile:IBooksSqlite_shm toLocalFile:filePath];
                    
                }
                if ([applicationDir fileExistsAtPath:IBooksSqlite_wal]) {
                    
                    NSString *filePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"iBooks_v10252011_2152.sqlite-wal"];
                    if ([fm fileExistsAtPath:filePath]) {
                        [fm removeItemAtPath:filePath error:nil];
                    }
                    [applicationDir copyRemoteFile:IBooksSqlite_wal toLocalFile:filePath];
                    
                    
                }
                
                if (_databaseConnection != nil) {
                    [_databaseConnection release];
                    _databaseConnection = nil;
                }
                
                _databaseConnection = [[FMDatabase alloc] initWithPath:filePath];
                
                //开启数据库连接
                [self openDataBase];
                
                
                for (IMBBookEntity *book in bookArray) {
                    
                    NSString *sql = @"select ZCOLLECTION from  (select ZDATABASEKEY from ZBKBOOKINFO where ZTEMPORARYITEMIDENTIFIER=:persistenceID) as a left join ZBKCOLLECTIONMEMBER on  a.ZDATABASEKEY=ZBKCOLLECTIONMEMBER.ZDATABASEKEY";
                    NSDictionary *parms = nil;
                    FMResultSet *rs = nil;
                    if (book.bookID != nil && !book.isPurchase) {
                        sql = @"select ZCOLLECTION from  (select ZDATABASEKEY from ZBKBOOKINFO where ZTEMPORARYITEMIDENTIFIER=:persistenceID) as a left join ZBKCOLLECTIONMEMBER on  a.ZDATABASEKEY=ZBKCOLLECTIONMEMBER.ZDATABASEKEY";
                        parms = [NSDictionary dictionaryWithObject:book.bookID?book.bookID:@"" forKey:@"persistenceID"];
                        rs = [_databaseConnection executeQuery:sql withParameterDictionary:parms];
                    }else
                    {
                        sql = @"select ZCOLLECTION from ZBKCOLLECTIONMEMBER where ZBKCOLLECTIONMEMBER.ZDATABASEKEY=:persistenceID";
                        if ([book.dataBaseKey isKindOfClass:[NSNumber class]]) {
                             parms = [NSDictionary dictionaryWithObject:[book.dataBaseKey stringValue]?[book.dataBaseKey stringValue]:@"" forKey:@"persistenceID"];
                        }else
                        {
                             parms = [NSDictionary dictionaryWithObject:@"" forKey:@"persistenceID"];
                        }
                       
                        rs = [_databaseConnection executeQuery:sql withParameterDictionary:parms];

                    
                    }

                    while ([rs next]) {
                        
                       
                        book.collectionID = [rs stringForColumn:@"ZCOLLECTION"];
                        
                    }
                    
                    [rs close];
                    
                }

                //关闭数据库连接
                [self closeDataBase];
        }else
        {
        
            NSLog(@"数据库文件拷贝失败");
        }
    
    
       }
    }
    NSImage *coverImage = [StringHelper imageNamed:@"ibook_bookback"];
    for (IMBBookEntity *book in bookArray) {
        
        book.coverImage = coverImage;
    }
    [applicationDir close];
    [_logManger writeInfoLog:@"end query All books"];
    return bookArray;
    
}

- (NSMutableArray *)queryAllcollections
{
    [_logManger writeInfoLog:@"begin query All collections"];
    NSMutableArray *collectionArray = [NSMutableArray array];
    
    fm = [NSFileManager defaultManager];
    
    //通过连接iBooks应用程序目录，获取book对象所属的集合
    AFCApplicationDirectory *applicationDir = [_device newAFCApplicationDirectory:@"com.apple.iBooks"];
    if (applicationDir == nil) {
//        NSLog(@"没有安装iBooks软件");
        [_logManger writeInfoLog:@"no iBooks software"];
    }else
    {
        if ([applicationDir fileExistsAtPath:IBooksSqlite]) {
            
            NSString *filePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"iBooks_v10252011_2152.sqlite"];
            
            if ([fm fileExistsAtPath:filePath]) {
                [fm removeItemAtPath:filePath error:nil];
            }
            
            
            BOOL issuccess = [applicationDir copyRemoteFile:IBooksSqlite toLocalFile:filePath];
            if (issuccess) {
                if ([applicationDir fileExistsAtPath:IBooksSqlite_shm]) {
                    
                    NSString *filePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"iBooks_v10252011_2152.sqlite-shm"];
                    if ([fm fileExistsAtPath:filePath]) {
                        [fm removeItemAtPath:filePath error:nil];
                    }
                    [applicationDir copyRemoteFile:IBooksSqlite_shm toLocalFile:filePath];
                    
                }
                if ([applicationDir fileExistsAtPath:IBooksSqlite_wal]) {
                    
                    NSString *filePath = [[TempHelper getAppTempPath] stringByAppendingPathComponent:@"iBooks_v10252011_2152.sqlite-wal"];
                    if ([fm fileExistsAtPath:filePath]) {
                        [fm removeItemAtPath:filePath error:nil];
                    }
                    [applicationDir copyRemoteFile:IBooksSqlite_wal toLocalFile:filePath];
                    
                    
                }
                
                if (_databaseConnection != nil) {
                    [_databaseConnection release];
                    _databaseConnection = nil;
                }
                
                _databaseConnection = [[FMDatabase alloc] initWithPath:filePath];
                
                //开启数据库连接
                [self openDataBase];
                NSString *sql = @"select Z_PK,ZTITLE from ZBKCOLLECTION";
                
                FMResultSet *rs = [_databaseConnection executeQuery:sql];
                while ([rs next]) {
                    IMBBookCollection *collection = [[IMBBookCollection alloc] init];
                    collection.collectionID = [rs stringForColumn:@"Z_PK"];
                    collection.collectionName = [rs stringForColumn:@"ZTITLE"];
                   
                    [collectionArray addObject:collection];
                    [collection release];
                    
                }

                [rs close];
                //关闭数据库连接
                [self closeDataBase];

            }


       }
    }
    [applicationDir close];
    
    [_logManger writeInfoLog:@"end query All collections"];
    return collectionArray;
}

-(void)dealloc
{
    [_ipod release],_ipod = nil;
    [super dealloc];
}
@end
