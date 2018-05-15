//
//  IMBDriveImageSqltie.h
//  AnyTransforCloud
//
//  Created by 龙凡 on 2018/5/4.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "IMBDriveModel.h"
#import "IMBPhotoSqliteEntity.h"
@interface IMBDriveImageSqltie : NSObject
{
    NSString *_savePath;
    FMDatabase *_db;
    NSMutableArray *_accountArray;
}
///**保存的账号数组*/
@property (nonatomic, retain) NSMutableArray *accountArray;
- (id)initWithPath:(NSString *)savePath;
- (BOOL)createAccountTable;
- (BOOL)openDB;
- (void)closeDB;
/**
 *  插入数据
 *
 *  @param imageName     名字
 *  @param fileID
 *  @param type
 *  @param createTime
 *  @param firstBytesStr 前几个字节
 */
- (void)insertData:(NSString *)imageName fileID:(NSString *)fileID type:(NSString *)type  createTime:(NSString *)createTime imageFirstBytes:(NSData *)firstBytesStr ;
/**
 *  查询数据库
 */
- (void)selectAccountDatail;
/**
 *  删除字段
 *
 *  @param fileId
 */
- (void)deleteSqlite:(NSString *)fileId;
@end
