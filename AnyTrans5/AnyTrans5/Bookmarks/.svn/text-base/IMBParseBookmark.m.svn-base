//
//  IMBPaseBookmark.m
//  iMobieTrans
//
//  Created by iMobie on 14-11-27.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBParseBookmark.h"
#import "IMBChromeBookmarkEntity.h"
#import "TempHelper.h"
#import "IMBSafariBookmarkEntity.h"
#import "RegexKitLite.h"
#import "IMBFirefoxBookmarkEntity.h"

// @"/Users/iMobie/Library/Application Support/Google/Bookmarks"  //谷歌浏览器bookmark存放地址
// @"/Users/iMobie/Library/Safari/Bookmarks.plist"
@implementation IMBParseBookmark
//解析谷歌浏览器的bookmark
+ (NSMutableArray *)parseChromeBookmarkByJSON
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *bookmarkArray = [NSMutableArray array];
    NSString *libraryPath = [TempHelper getLibraryPath];
    NSString *chromeBookmarkPath = [libraryPath stringByAppendingString:@"/Application Support/Google/Chrome/Default/Bookmarks"];
    if ([fileManager fileExistsAtPath:chromeBookmarkPath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:chromeBookmarkPath];
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray *allkey = [result allKeys];
            for (NSString *key in allkey) {
                if ([key isEqualToString:@"roots"]) {
                    
                    NSDictionary *rootDic = [result objectForKey:key];
                    NSArray *rootKey = [rootDic allKeys];
                    for (NSString *bookmarkKey in rootKey) {
                        
                        NSDictionary *bookmarkDic = [rootDic objectForKey:bookmarkKey];
                        if ([bookmarkKey isEqualToString:@"bookmark_bar"]||[bookmarkKey isEqualToString:@"other"])
                        {
                            NSArray *bookmarkchildArray = [bookmarkDic objectForKey:@"children"];
                            for (NSDictionary *dic in bookmarkchildArray) {
                                IMBChromeBookmarkEntity *bookEntity = [[IMBChromeBookmarkEntity alloc] initWithDataDic:dic];
                                //使用递归实现
                                NSArray *subArray = [dic objectForKey:@"children"];
                                bookEntity.childBookmarkArray = [self getChromeChildBookmarkArray:subArray];
                                [bookmarkArray addObject:bookEntity];
                                [bookEntity release];
                            }
                        }
                    }
                }
            }
        }

    }else
    {
        NSLog(@"谷歌浏览器没有bookmark");
    }
    return bookmarkArray;
}

+ (NSMutableArray *)getChromeChildBookmarkArray:(NSArray *)arr
{
    NSMutableArray *childArray = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        IMBChromeBookmarkEntity *bookEntity = [[IMBChromeBookmarkEntity alloc] initWithDataDic:dic];
        //使用递归实现
        NSArray *subArray = [dic objectForKey:@"children"];
        bookEntity.childBookmarkArray = [self getChromeChildBookmarkArray:subArray];
        [childArray addObject:bookEntity];
        [bookEntity release];
    }
    return childArray;
}

//解析safari浏览器中的bookmark
+ (NSMutableArray *)parseSafariBookmarkByPlist
{
    NSMutableArray *safariBookmarkArray = [NSMutableArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *libraryPath = [TempHelper getLibraryPath];
    NSString *safariBookmarkPath = [libraryPath stringByAppendingString:@"/Safari/Bookmarks.plist"];
    if ([fileManager fileExistsAtPath:safariBookmarkPath]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:safariBookmarkPath];
        NSArray *array = [dic objectForKey:@"Children"];
        for (NSDictionary *bookmarkDic in array) {
            NSString *title = [bookmarkDic objectForKey:@"Title"];
             if ([title isEqualToString:@"com.apple.ReadingList"]||[title isEqualToString:@"BookmarksBar"]||[title isEqualToString:@"BookmarksMenu"]){
                NSArray *childArray = [bookmarkDic objectForKey:@"Children"];
                for (NSDictionary *childDic in childArray) {
                    IMBSafariBookmarkEntity *bookmarkEntity = [[IMBSafariBookmarkEntity alloc] initWithDataDic:childDic];
                    if (bookmarkEntity.isFolder) {
                        NSString *title = [childDic objectForKey:@"Title"];
                        [bookmarkEntity setName:title];
                        //给其孩子赋值
                        NSArray *childBookmarkArray = [childDic objectForKey:@"Children"];
                        bookmarkEntity.childBookmarkArray = [self getSafariChildBookmarkArray:childBookmarkArray];
                    }else
                    {
                        NSDictionary *titleDic = [childDic objectForKey:@"URIDictionary"];
                        NSString *title = [titleDic objectForKey:@"title"];
                        [bookmarkEntity setName:title];
                    }
                    [safariBookmarkArray addObject:bookmarkEntity];
                    [bookmarkEntity release];
                }
                
             }else if (![title isEqualToString:@"History"]&&![title isEqualToString:@"BookmarksBar"]&![title isEqualToString:@"BookmarksMenu"])
             {
                 IMBSafariBookmarkEntity *bookmarkEntity = [[IMBSafariBookmarkEntity alloc] initWithDataDic:bookmarkDic];
                 if (bookmarkEntity.isFolder) {
                     NSString *title = [bookmarkDic objectForKey:@"Title"];
                     [bookmarkEntity setName:title];
                     //给其孩子赋值
                     NSArray *childBookmarkArray = [bookmarkDic objectForKey:@"Children"];
                     bookmarkEntity.childBookmarkArray = [self getSafariChildBookmarkArray:childBookmarkArray];
                     [safariBookmarkArray addObject:bookmarkEntity];
                     [bookmarkEntity release];
                 }
             }
        }

    }
    return safariBookmarkArray;
}

+ (NSMutableArray *)getSafariChildBookmarkArray:(NSArray *)arr
{
    NSMutableArray *childArray = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        IMBSafariBookmarkEntity *bookmarkEntity = [[IMBSafariBookmarkEntity alloc] initWithDataDic:dic];
        if (bookmarkEntity.isFolder) {
            NSString *title = [dic objectForKey:@"Title"];
            [bookmarkEntity setName:title];
            //给其孩子赋值
            NSArray *childBookmarkArray = [dic objectForKey:@"Children"];
            bookmarkEntity.childBookmarkArray = [self getSafariChildBookmarkArray:childBookmarkArray];
            
        }else
        {
            NSDictionary *titleDic = [dic objectForKey:@"URIDictionary"];
            NSString *title = [titleDic objectForKey:@"title"];
            [bookmarkEntity setName:title];
            
        }
        [childArray addObject:bookmarkEntity];
        [bookmarkEntity release];
        
    }
    return childArray;
}

//解析火狐浏览器中的bookmark
+ (NSMutableArray *)parseFirefoxBookmarkByJSON
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableArray *firefoxBookmarkArray = [NSMutableArray array];
    NSString *reg = @"\\w+.default";
    NSString *firefoxPath1 =  [[TempHelper getLibraryPath] stringByAppendingPathComponent:@"Application Support/Firefox/Profiles"];
    NSString *chromeBookmarkPath = nil;
    NSString *firefoxPath2 = nil;
    NSDate *latestDate = nil;
    NSArray *dirArr = [fileManager contentsOfDirectoryAtPath:firefoxPath1 error:nil];
    for (NSString *dirName in dirArr) {
        BOOL isMatched = [dirName isMatchedByRegex:reg];
        if (isMatched) {
            firefoxPath2 = [firefoxPath1 stringByAppendingString:[NSString stringWithFormat:@"/%@/bookmarkbackups",dirName]] ;
        }
    }
    
    if (firefoxPath2 != nil) {
        NSArray *bookMarkNameArr = [fileManager contentsOfDirectoryAtPath:firefoxPath2 error:nil];
        //找出日期最近的bookmark文件
        for (NSString *bookmarkName in bookMarkNameArr) {
            NSString *firefoxPath = [firefoxPath2 stringByAppendingPathComponent:bookmarkName];
            NSDictionary *dic = [fileManager attributesOfItemAtPath:firefoxPath error:nil];
            NSDate *createDate = [dic objectForKey:@"NSFileCreationDate"];
            if (latestDate == nil) {
                latestDate = createDate;
                chromeBookmarkPath = [firefoxPath2 stringByAppendingPathComponent:bookmarkName];
            }else
            {
                NSComparisonResult result = [latestDate compare:createDate];
                if (result == NSOrderedAscending) {
                    latestDate = createDate;
                    chromeBookmarkPath = [firefoxPath2 stringByAppendingPathComponent:bookmarkName];
                }
            }
        }
        
        
    }else
    {
        return firefoxBookmarkArray;
    }
    
    if ([fileManager fileExistsAtPath:chromeBookmarkPath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:chromeBookmarkPath];
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSArray *childArray = [result objectForKey:@"children"];
            for (NSDictionary *dic in childArray) {
                NSString *root = [dic objectForKey:@"root"];
                if ([root isEqualToString:@"bookmarksMenuFolder"]||[root isEqualToString:@"toolbarFolder"]||[root isEqualToString:@"unfiledBookmarksFolder"]) {
                    NSArray *bookmarkchildArray = [dic objectForKey:@"children"];
                    for (NSDictionary *childDic in bookmarkchildArray) {
                        IMBFirefoxBookmarkEntity *bookmarkEntity = [[IMBFirefoxBookmarkEntity alloc] initWithDataDic:childDic];
                        if (bookmarkEntity.isFolder) {
                            
                            NSArray *firefoxArray = [childDic objectForKey:@"children"];
                            bookmarkEntity.childBookmarkArray = [self getFirefoxChildBookmarkArray:firefoxArray];
                            
                            
                        }
                        [firefoxBookmarkArray addObject:bookmarkEntity];
                        [bookmarkEntity release];
                        
                    }
                    
                    
                }
                
            }
            
        }
        
    }else
    {
       return firefoxBookmarkArray;
    }


    return firefoxBookmarkArray;
}

+ (NSMutableArray *)getFirefoxChildBookmarkArray:(NSArray *)arr
{
    NSMutableArray *childArray = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        IMBFirefoxBookmarkEntity *bookmarkEntity = [[IMBFirefoxBookmarkEntity alloc] initWithDataDic:dic];
        if (bookmarkEntity.isFolder) {
            
            NSArray *childBookmarkArray = [dic objectForKey:@"children"];
            bookmarkEntity.childBookmarkArray = [self getFirefoxChildBookmarkArray:childBookmarkArray];
            
        }
        [childArray addObject:bookmarkEntity];
        [bookmarkEntity release];
        
    }
    return childArray;
}

//解析火狐浏览器中的bookmark
- (NSMutableArray *)parseFirefoxBookmarkByDB {
    NSMutableArray *rootBookmarks = [[NSMutableArray alloc]init];
    NSString *bookmarkConnStr =  [[TempHelper getLibraryPath] stringByAppendingPathComponent:@"Application Support/Firefox/Profiles/rnoqn111.default/places.sqlite"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:bookmarkConnStr]) {
        
        _SQLiteConnection = [[FMDatabase databaseWithPath:bookmarkConnStr] retain];
        //开启数据库
        [self openDataBase];
        FMResultSet *rs = nil;
        NSDictionary *parms = nil;
        NSString *sql = @"select id,title from moz_bookmarks where type=2 and parent=1 and title is not null order by position";
        rs = [_SQLiteConnection executeQuery:sql withParameterDictionary:parms];
        while ([rs next]) {
            IMBBookmarkEntity *bookmark = [[IMBBookmarkEntity alloc]init];
            bookmark.bookId = [rs intForColumn:@"id"];
            if (![rs columnIsNull:@"title"]){
                bookmark.Name = [rs stringForColumn:@"title"];
            }else{
                bookmark.Name = @"";
            }

            bookmark.IsFolder = true;
            if (bookmark.name.length == 0 || bookmark.name == NULL)
            {
                continue;
            }
            [rootBookmarks addObject:bookmark];
            [bookmark release], bookmark = nil;
        }
    }
    for (IMBBookmarkEntity *bookMark in rootBookmarks) {
        bookMark.childBookmarkArray = [self getFolderBookmarks:bookMark.bookId];
    }
    
    return rootBookmarks;
}

- (NSMutableArray *)getFolderBookmarks:(int)id {
    NSMutableArray *folderItems = [[NSMutableArray alloc] init];
    NSString *queryFolderStr = [@"select b.id,b.title from moz_bookmarks as b left join moz_places as p on b.fk=p.id where b.type=2 and b.parent=" stringByAppendingString:[NSString stringWithFormat:@"%d",id]];
    NSDictionary *parms = nil;
    FMResultSet *rs = nil;
    rs = [_SQLiteConnection executeQuery:queryFolderStr withParameterDictionary:parms];
    while ([rs next]) {
        IMBBookmarkEntity *bookMark = [[IMBBookmarkEntity alloc] init];
        bookMark.bookId = [rs intForColumn:@"id"];
        if (![rs columnIsNull:@"title"]){
            bookMark.Name = [rs stringForColumn:@"title"];
        }else{
            bookMark.Name = @"";
        }
        bookMark.IsFolder = YES;
        [folderItems addObject:bookMark];
        [bookMark release], bookMark = nil;
    }
    
    NSString *queryItemStr = [@"select b.id,b.title,p.url from moz_bookmarks as b left join moz_places as p on b.fk=p.id where b.type=1 and b.parent=" stringByAppendingString:[NSString stringWithFormat:@"%d",id]];
    FMResultSet *rs1 = nil;
    rs1 = [_SQLiteConnection executeQuery:queryItemStr withParameterDictionary:parms];
    while ([rs1 next]) {
        IMBBookmarkEntity *bookMark = [[IMBBookmarkEntity alloc] init];
        bookMark.bookId = [rs1 intForColumn:@"id"];
        if (![rs1 columnIsNull:@"title"]){
           bookMark.Name = [rs1 stringForColumn:@"title"];
        }else{
          bookMark.Name = @"";
        }
        bookMark.url = [rs1 stringForColumn:@"url"];
        bookMark.IsFolder = NO;
        [folderItems addObject:bookMark];
        [bookMark release], bookMark = nil;
    }
    
    return folderItems;
}

- (BOOL)openDataBase {
    if ([_SQLiteConnection open]) {
        [_SQLiteConnection setShouldCacheStatements:NO];
        [_SQLiteConnection setTraceExecution:NO];
        return true;
    }
    return false;
}


@end
