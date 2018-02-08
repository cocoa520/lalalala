//
//  IMBBookmarksManager.m
//  iMobieTrans
//
//  Created by iMobie on 14-2-18.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#define BookMarksDoMain     @"com.apple.Bookmarks"
#define BookMarksAnchorStr  @"Bookmarks-Device-Anchor"
#import "IMBBookmarksManager.h"

@implementation IMBBookmarksManager
static int randIncrease=0;
@synthesize allkeys = _allkeys;
- (NSArray *)queryAllBookmarks
{
    if (_allItemDic != nil) {
        [_allItemDic release];
        _allItemDic = nil;
    }
    _allItemDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *bookMarksArr = [NSMutableArray array];
    //开始一个会话
    NSArray *retArray = [mobileSync startQuerySessionWithDomain:BookMarksDoMain];
    
    //此处对数据进行处理
    for (id item in retArray) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *tmpDic = item;
            NSArray *allKey = [tmpDic allKeys];
            if (allKey != nil && [allKey count] > 0) {
                NSMutableDictionary *bookmarksDic = nil;
                for (NSString *key in allKey) {
                    bookmarksDic = [[tmpDic objectForKey:key] retain];
                    [_allItemDic setValue:bookmarksDic forKey:key];
                    IMBBookmarkEntity *bookMarks = [[IMBBookmarkEntity alloc] initWithDataDic:bookmarksDic];
                    if (bookMarks.name == nil||[bookMarks.name isEqualToString:@""]) {
                        bookMarks.name = CustomLocalizedString(@"Common_id_10", nil);
                    }
                    if (bookMarks.url == nil||[bookMarks.url isEqualToString:@""]) {
                        bookMarks.url = CustomLocalizedString(@"Common_id_10", nil);
                    }

                    if ([[bookmarksDic objectForKey:@"com.apple.syncservices.RecordEntityName"] isEqualToString:@"com.apple.bookmarks.Bookmark"]) {
                        bookMarks.isFolder = NO;
                        
                    }else
                    {
                        bookMarks.isFolder = YES;
                    }
                    bookMarks.bookMarksId = key;
                    [bookMarksArr addObject:bookMarks];
                    [bookMarks release];
                    [bookmarksDic release];
                }
            }
        }
    }
    //此处给其孩子赋值
    for ( IMBBookmarkEntity *bookmark in bookMarksArr) {
        if (bookmark.isFolder) {
            NSMutableArray *childArr = [NSMutableArray array];
            for ( IMBBookmarkEntity *mark in   bookMarksArr)
            {
                if (mark.parent.count>0) {
                    
                    if ([[mark.parent objectAtIndex:0] isEqualToString:bookmark.bookMarksId])
                    {
                        [childArr addObject:mark];
                       
                    }
                }
            }
            
            if (childArr.count>0) {
                
                bookmark.childBookmarkArray = childArr;
            }
            
           
        }
    }
    NSArray *message = [NSArray arrayWithObjects:
                        @"SDMessageAcknowledgeChangesFromDevice",
                        @"com.apple.Bookmarks",
                        nil];
    
    while (YES) {
        retArray = [mobileSync getData:message waitingReply:YES];
        if ([[retArray objectAtIndex:0] isEqualToString:@"SDMessageDeviceReadyToReceiveChanges"] || _threadBreak) {
            break;
        } else {
            
        }
    }
    //结束会话
    [mobileSync endSessionWithDomain:BookMarksDoMain];
    
    
    return bookMarksArr;
}

- (NSArray *)queryRootArray
{
    if (_allItemDic != nil) {
        [_allItemDic release];
        _allItemDic = nil;
    }
    _allItemDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *bookMarksArr = [NSMutableArray array];
    //开始一个会话
    NSArray *retArray = [mobileSync startQuerySessionWithDomain:BookMarksDoMain];
    
    //此处对数据进行处理
    for (id item in retArray) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *tmpDic = item;
            NSArray *allKey = [tmpDic allKeys];
            if (allKey != nil && [allKey count] > 0) {
                NSMutableDictionary *bookmarksDic = nil;
                for (NSString *key in allKey) {
                    bookmarksDic = [[tmpDic objectForKey:key] retain];
                    [_allItemDic setValue:bookmarksDic forKey:key];
                    IMBBookmarkEntity *bookMarks = [[IMBBookmarkEntity alloc] initWithDataDic:bookmarksDic];
                    if (bookMarks.name == nil||[bookMarks.name isEqualToString:@""]) {
                        bookMarks.name =CustomLocalizedString(@"Common_id_10", nil);
                    }
                    if (bookMarks.url == nil||[bookMarks.url isEqualToString:@""]) {
                        bookMarks.url = CustomLocalizedString(@"Common_id_10", nil);
                    }

                    if ([[bookmarksDic objectForKey:@"com.apple.syncservices.RecordEntityName"] isEqualToString:@"com.apple.bookmarks.Bookmark"]) {
                        
                        
                        bookMarks.isFolder = NO;
                    }else
                    {
                        bookMarks.isFolder = YES;
                    }
                    bookMarks.bookMarksId = key;
                    [bookMarksArr addObject:bookMarks];
                    [bookMarks release];
                    [bookmarksDic release];
                }
            }
        }
    }
    //此处给其孩子赋值
    NSMutableArray *rootArray = [NSMutableArray array];
    for ( IMBBookmarkEntity *bookmark in bookMarksArr) {
        
        if (bookmark.parent == nil) {
            
            [rootArray addObject:bookmark];
             bookmark.parentNode = nil;
            
        }
        
        if (bookmark.isFolder) {
            NSMutableArray *childArr = [NSMutableArray array];
            NSMutableArray *subFolderArr = [NSMutableArray array];
            for ( IMBBookmarkEntity *mark in   bookMarksArr)
            {
                if (mark.parent.count>0) {
                    
                    if ([[mark.parent objectAtIndex:0] isEqualToString:bookmark.bookMarksId])
                    {
                       
                            
                       [childArr addObject:mark];
                        mark.parentNode = bookmark;
                        
                        if (mark.isFolder) {
                            bookmark.hassubFolder = YES;
                            [subFolderArr addObject:mark];
                            
                        }
                        
                    }
                }
            }
            
            if (childArr.count>0) {
                
                bookmark.childBookmarkArray = childArr;
            }
            //得到目录下的目录
            if (subFolderArr.count>0) {
                bookmark.subFolderArray = subFolderArr;
            }
            
        }
    }
    
    for (IMBBookmarkEntity *bookmark in bookMarksArr) {
        
        if (bookmark.isFolder&&[bookmark.childBookmarkArray count]>0) {
            
            for (IMBBookmarkEntity *entity in bookmark.childBookmarkArray) {
                if (!entity.isFolder) {
                    
                    [bookmark.allBookmarkArray addObject:entity];
                }
            }
            
            
        }
    }
    NSArray *message = [NSArray arrayWithObjects:
                        @"SDMessageAcknowledgeChangesFromDevice",
                        @"com.apple.Bookmarks",
                        nil];
    int k=0;
    while (YES) {
        if (mobileSync == nil || _threadBreak) {
            break;
        }
        retArray = [mobileSync getData:message waitingReply:YES];
        if (retArray == nil) {
            if (k==5) {
                break;
            }
            sleep(1);
            k++;
            retArray = [mobileSync getData:message waitingReply:YES];
            
        }
        if ([[retArray objectAtIndex:0] isEqualToString:@"SDMessageDeviceReadyToReceiveChanges"]) {
            break;
        } else {
            
        }
    }
    
    //结束会话
    [mobileSync endSessionWithDomain:BookMarksDoMain];
    //对rootarray进行排序
    NSArray *resultArray = [rootArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
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


-(BOOL)deleteBookmarks:(NSArray*)delBookmarksID
{
    //开启会话
    [mobileSync startDeleteSessionWithDomain:BookMarksDoMain withDomainAnchor:BookMarksAnchorStr];
    
    //此处处理数据
    NSArray *delContent = [self prepareDelData:delBookmarksID];
    [mobileSync getData:delContent waitingReply:NO];
    
    // 结束会话
    [mobileSync endSessionWithDomain:BookMarksDoMain];


    return YES;
}

- (NSArray*)prepareDelData:(NSArray*)contentIDArray {
    NSMutableArray *delArray = [[NSMutableArray alloc] init];
    [delArray addObject:@"SDMessageProcessChanges"];
    [delArray addObject:@"com.apple.Bookmarks"];
    
    NSMutableDictionary *delDetail = [[NSMutableDictionary alloc] init];
    for (NSString *cid in contentIDArray) {
        [delDetail setValue:@"___EmptyParameterString___" forKey:cid];
    }
    [delArray addObject:delDetail];
    
    [delArray addObject:[NSNumber numberWithBool:NO]];
    
    [delArray addObject:@"___EmptyParameterString___"];
    
    [delArray autorelease];
    return delArray;
}

- (BOOL)modifyBookmark:(IMBBookmarkEntity*)BookMark
{
    //开启会话
    [mobileSync startModifySessionWithDomain:BookMarksDoMain withDomainAnchor:BookMarksAnchorStr];
    NSMutableArray *modifyArray = [self prepareModifyData:BookMark];
    [mobileSync getData:modifyArray waitingReply:YES];
    
    [mobileSync endSessionWithDomain:BookMarksDoMain];
    
    return YES;
}

- (NSMutableArray *)prepareModifyData:(IMBBookmarkEntity *)bookMarks
{
    NSMutableArray *modifyArray = [[[NSMutableArray alloc] init] autorelease];
    [modifyArray addObject:@"SDMessageProcessChanges"];
    [modifyArray addObject:@"com.apple.Bookmarks"];
    NSString *key = bookMarks.bookMarksId;
    NSMutableDictionary *bookMarksDic =[[NSMutableDictionary alloc] init];
    if ([_allkeys containsObject:key]) {
        NSMutableDictionary *bookMarkDic = [NSMutableDictionary dictionary];
        if (!bookMarks.isFolder) {
            [bookMarkDic setObject:bookMarks.url forKey:@"url"];
            [bookMarkDic setObject: @"com.apple.bookmarks.Bookmark" forKey:@"com.apple.syncservices.RecordEntityName"];
        }else
        {
            
            [bookMarkDic setObject: @"com.apple.bookmarks.Folder" forKey:@"com.apple.syncservices.RecordEntityName"];
        }
        [bookMarkDic setObject:bookMarks.name forKey:@"name"];
        if (bookMarks.parent != nil) {
            [bookMarkDic setObject:bookMarks.parent forKey:@"parent"];
        }
        [bookMarksDic setObject:bookMarkDic forKey:key];
    }
    
    [modifyArray addObject:bookMarksDic];
    [bookMarksDic release];
    [modifyArray addObject:[NSNumber numberWithBool:NO]];
    [modifyArray addObject:@"___EmptyParameterString___"];
    return modifyArray;

}

- (NSString *)insertBookmark:(IMBBookmarkEntity *)BookMark
{
    NSDictionary *retDic = nil;
    [mobileSync startModifySessionWithDomain:BookMarksDoMain withDomainAnchor:BookMarksAnchorStr];
    NSArray *addNoteContent = [self prepareInsertData:BookMark NeedParent:YES];
    retDic = [mobileSync getData:addNoteContent waitingReply:YES];
    [mobileSync endSessionWithDomain:BookMarksDoMain];
    NSString *key = nil;
    for (id element in addNoteContent) {
        if ([element isKindOfClass:[NSDictionary class]]) {
            if ([element count] > 0) {
                key = [((NSDictionary *)element).allKeys objectAtIndex:0];
            }
        }
    }
    if (key != nil && retDic != nil) {
        return key;
    }
    return nil;
}

- (NSString *)insertBookmark:(IMBBookmarkEntity *)BookMark NeedParent:(BOOL)needParent
{
    NSDictionary *retDic = nil;
    [mobileSync startModifySessionWithDomain:BookMarksDoMain withDomainAnchor:BookMarksAnchorStr];
    NSArray *addNoteContent = [self prepareInsertData:BookMark NeedParent:needParent];
    retDic = [mobileSync getData:addNoteContent waitingReply:YES];
    [mobileSync endSessionWithDomain:BookMarksDoMain];
    NSString *key = nil;
    for (id element in addNoteContent) {
        if ([element isKindOfClass:[NSDictionary class]]) {
            if ([element count] > 0) {
                key = [((NSDictionary *)element).allKeys objectAtIndex:0];
            }
        }
    }
    if (key != nil && retDic != nil) {
        return key;
    }
    return nil;
}

- (void)insertBookmarks:(NSArray *)bookmarkArray
{
   
    for (IMBBookmarkEntity *entity in bookmarkArray) {
        if (!entity.isFolder) {
           [self openMobileSync];
            [self insertBookmark:entity];
            [self closeMobileSync];
        }else
        {
             [self openMobileSync];
            NSString *key = [self insertBookmark:entity];
            NSArray *children = entity.childBookmarkArray;
            [self insertFolder:children parentKey:key];
            [self closeMobileSync];
        }
    }
    
}

- (void)insertFolder:(NSArray *)childArray parentKey:(NSString *)parentKey
{
    
    for (IMBBookmarkEntity *entity in childArray) {
        entity.parent = [NSArray arrayWithObject:parentKey];
        if (!entity.isFolder) {
            [self openMobileSync];
            [self insertBookmark:entity];
            [self closeMobileSync];
            
        }else
        {
            [self openMobileSync];
            NSString *key = [self insertBookmark:entity];
            [self closeMobileSync];
            NSArray *children = entity.childBookmarkArray;
            if (key != nil) {
              [self insertFolder:children parentKey:key];
            }
        }
    }
}
- (NSArray*)prepareInsertData:(IMBBookmarkEntity *)bookMark   NeedParent:(BOOL)needParent
{
    NSMutableArray *addNoteArr = [[NSMutableArray alloc] init];
    [addNoteArr addObject:@"SDMessageProcessChanges"];
    [addNoteArr addObject:@"com.apple.Bookmarks"];
    srandom((unsigned int)time((time_t *)NULL));
    
    NSMutableDictionary *bookMarksDic = [[NSMutableDictionary alloc] init];
    NSString *nRandID = [NSString stringWithFormat:@"Note/%ld", random()+randIncrease];
    randIncrease++;
    if (![_allkeys containsObject:nRandID]) {
         NSMutableDictionary *detailDic = [[NSMutableDictionary alloc] init];
        if (bookMark.name != nil) {
            [detailDic setObject:bookMark.name forKey:@"name"];
        }
        
        if (bookMark.isFolder) {
            NSLog(@"insert folder%@",bookMark.name);
            NSLog(@"parent%lu",(unsigned long)[bookMark.parent count]);
            [detailDic setObject:@"com.apple.bookmarks.Folder" forKey:@"com.apple.syncservices.RecordEntityName"];
        }
        else
        {   NSLog(@"insert bookmark%@",bookMark.name);
            NSLog(@"parent%lu",(unsigned long)[bookMark.parent count]);
            [detailDic setObject:@"com.apple.bookmarks.Bookmark" forKey:@"com.apple.syncservices.RecordEntityName"];
            [detailDic setObject:bookMark.url forKey:@"url"];
        }
        [detailDic setObject:[NSNumber numberWithInt:100] forKey:@"position"];
        if (needParent) {
            if (bookMark.parent.count>0) {
                NSMutableArray *parent = [NSMutableArray array];
                for (NSString *var in bookMark.parent) {
                    [parent addObject:var];
                }
                [detailDic setObject:parent forKey:@"parent"];
            }
        }
        [bookMarksDic setObject:detailDic forKey:nRandID];
        [detailDic release];
    }
   
    [addNoteArr addObject:bookMarksDic];
    [bookMarksDic release];
    
    [addNoteArr addObject:[NSNumber numberWithBool:NO]];
    [addNoteArr addObject:@"___EmptyParameterString___"];
    
    return addNoteArr;
}

- (NSMutableArray *)getAllkeys:(NSArray *)rootArray
{
    NSMutableArray *keysArray = [NSMutableArray array];
    for (IMBBookmarkEntity *bookmark in rootArray ) {
        [keysArray addObject:bookmark.bookMarksId];
        if ([bookmark.childBookmarkArray count]>0) {
             [self getsubKeys:bookmark.childBookmarkArray keysArray:keysArray];
        }
    }
    return keysArray;
}

- (void)getsubKeys:(NSArray *)childArray keysArray:(NSMutableArray *)keysArray
{
    for (IMBBookmarkEntity *bookmark in childArray ) {
        [keysArray addObject:bookmark.bookMarksId];
        if ([bookmark.childBookmarkArray count]>0) {
            
            [self getsubKeys:bookmark.childBookmarkArray keysArray:keysArray];
        }
    }
}
/*
 @property(nonatomic,retain)NSMutableArray    *childBookmarkArray;
 @property(nonatomic,copy)NSString            *bookMarksId;
 @property(nonatomic,copy)NSString            *url;
 @property(nonatomic,copy)NSString            *name;
 @property(nonatomic,retain)NSNumber          *position;
 @property(nonatomic,retain)NSArray           *parent;
 @property(nonatomic,assign)BOOL              isFolder;
 @property(nonatomic,assign)BOOL              isEditable;
 @property(nonatomic,assign)BOOL              isHidden;
 @property(nonatomic,assign)BOOL              isDeletable;
 @property(nonatomic,assign)int               orderIndex;

 */

- (BOOL)exportAllBookmarksToFile:(NSString *)stringPath withIpod:(IMBiPod *)ipod{
    BOOL isSuccess = YES;
    [self openMobileSync];
    NSArray *_allBookmarks = [self queryAllBookmarks];
    [self closeMobileSync];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:stringPath]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_INVALID_EXPORT_PATH object:nil];
        NSLog(@"invalid export path");
        return NO;
    }
    NSMutableString *stringBuilder = [[NSMutableString alloc]init];
    [stringBuilder appendString:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@\n",@"book marks id",@"url",@"name",@"position",@"isFolder",@"isEditable",@"isHidden",@"isDeletable",@"orderIndex"]];
    for (IMBBookmarkEntity *entity in _allBookmarks) {
        [stringBuilder appendString:[NSString stringWithFormat:@"%@,%@,%@,%@,%hhd,%hhd,%hhd,%hhd,%d\n",entity.bookMarksId,entity.url,entity.name,entity.position,entity.isFolder,entity.isEditable,entity.isHidden,entity.isDeletable,entity.orderIndex]];
        
    }
    NSError *error = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    
    NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter release];
    
    NSString *suffix = [NSString stringWithFormat:@"BookMarks%@",destDateString];
    [stringBuilder writeToFile:[NSString stringWithFormat:@"%@/%@.txt",stringPath,suffix] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    if (error != nil) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_EXPORT_ERROR object:nil];
        isSuccess = NO;
    }
    if (error != nil) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_EXPORT_ERROR object:nil];
        isSuccess = NO;
    }
    [stringBuilder release];
    return isSuccess;
}


- (BOOL)exportTofolderPath:(NSString *)folderPath bookmarkArray:(NSArray *)bookmarkArray fileName:(NSString *)fileName
{
    if (fileName == nil) {
        fileName = [NSString stringWithFormat:@"%@.csv",CustomLocalizedString(@"MenuItem_id_21", nil)];
    }else
    {
        fileName = [NSString stringWithFormat:@"%@.csv",fileName];
    }
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
       filePath = [self createDifferentfileNameinfolder:folderPath filePath:filePath fileManager:fileManager];
    }
//    int successCount = 0;
    BOOL success = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    if (success) {
        NSFileHandle *fhandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        NSArray *bookmarkArr = bookmarkArray;
        int successNum = 0;
        BOOL isOutOfCount = NO;//[IMBHelper determinWhetherIsOutOfTransferCount];
        int itemCount = (int)[bookmarkArr count];
        if (!isOutOfCount) {
//          [nc postNotificationName:COPYINGNOTIFICATION object:[NSNumber numberWithInt:FileTypeIcon]];
//            [nc postNotificationName:NOTIFY_TRANSCATEGORY object:CustomLocalizedString(@"Export_id_2", nil) userInfo:nil];
            for (int i=0;i<itemCount; i++) {
                if (_threadBreak == YES) {
                    break;
                }
                IMBBookmarkEntity *bookmark = [bookmarkArr objectAtIndex:i];
                NSString *fileName = bookmark.name;
//                int currItemIndex = i+1;
//                BOOL IsNeedAnimation = YES;
//                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                             fileName,@"Message",
//                                             [NSNumber numberWithInt:currItemIndex], @"CurItemIndex",
//                                             [NSNumber numberWithBool:IsNeedAnimation],@"IsNeedAnimation",
//                                             [NSNumber numberWithInteger:[bookmarkArr count]], @"TotalItemCount",
//                                             nil];
//                [nc postNotificationName:NOTIFY_CURRENT_MESSAGE object:fileName];
//                [nc postNotificationName:NOTIFY_TRANSCOUNTPROGRESS object:@"MSG_COM_Total_Progress" userInfo:info];
                
                NSData *data = nil;
                if (![bookmark isFolder]) {
                    if (i == 0) {
                        data = [[bookmark descriptionCSV1] dataUsingEncoding:NSUTF8StringEncoding];
                    }else {
                        data = [[bookmark descriptionCSV] dataUsingEncoding:NSUTF8StringEncoding];
                    }
                    
                    [fhandle writeData:data];
                }
                successNum++;
                [_transResult setMediaSuccessCount:([_transResult mediaSuccessCount] + 1)];
                [_transResult recordMediaResult:fileName resultStatus:TransSuccess messageID:@"MSG_PlaylistResult_Success"];
                _progressCounter.prepareAnalysisSuccessCount++;
//                BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                if (isOutOfCount) {
//                    break;
//                }
            }
            
        }
        [fhandle closeFile];
//        if (_softWareInfo != nil && _softWareInfo.isNeedRegister &&_softWareInfo.isRegistered == false) {
//            [_softWareInfo addLimitCount:_transResult.mediaSuccessCount];
//        }
        sleep(2);
//        NSDictionary *infor = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:successNum] forKey:@"successNum"];
//        [nc postNotificationName:NOTIFY_TRANSCOMPLETE object:CustomLocalizedString(@"MSG_COM_Transfer_Completed", nil) userInfo:infor];
        return YES;
    }else
    {
        sleep(2);
//        NSDictionary *infor = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"successNum"];
//        [nc postNotificationName:NOTIFY_TRANSCOMPLETE object:CustomLocalizedString(@"MSG_COM_Transfer_Completed", nil) userInfo:infor];
        return NO;
        
    }
}

- (void)dealloc
{
    [_allkeys release],_allkeys = nil;
    [super dealloc];
}

@end
