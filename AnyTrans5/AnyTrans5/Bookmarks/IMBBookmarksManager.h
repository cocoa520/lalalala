//
//  IMBBookmarksManager.h
//  iMobieTrans
//
//  Created by iMobie on 14-2-18.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBMobileSyncManager.h"
#import "IMBBookmarkEntity.h"
@interface IMBBookmarksManager : IMBMobileSyncManager
{
    NSMutableArray *_allkeys;
}
@property(nonatomic,retain)NSMutableArray *allkeys;
//查询所有的IMBBookmarks对象
- (NSArray *)queryAllBookmarks;
//返回树形结构的rootarray
- (NSArray *)queryRootArray;
//to do按平板展现或者按层次结构展现，展现出来最好有排序

//删除指定的Bookmarks对象
//*****************delContent是包含IMBBookmarks对象ID的数组
//*****************如果该书签包含子书签则全部删完
- (BOOL)deleteBookmarks:(NSArray *)delBookmarksID;

//修改Bookmarks对象
- (BOOL)modifyBookmark:(IMBBookmarkEntity *)BookMark;

//插入新的书签
- (NSString *)insertBookmark:(IMBBookmarkEntity *)BookMark;

- (NSString *)insertBookmark:(IMBBookmarkEntity *)BookMark NeedParent:(BOOL)needParent;
//插入多个书签，包括书签的子书签
- (void)insertBookmarks:(NSArray *)bookmarkArray;
- (BOOL)exportAllBookmarksToFile:(NSString *)stringPath withIpod:(IMBiPod *)ipod;
- (BOOL)exportTofolderPath:(NSString *)folderPath bookmarkArray:(NSArray *)bookmarkArray fileName:(NSString *)fileName;

//通过rootArray 得到所有的keys
- (NSMutableArray *)getAllkeys:(NSArray *)rootArray;

@end
