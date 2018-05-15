//
//  IMBUserHistoryTable.h
//  AnyTransforCloud
//
//  Created by ding ming on 18/5/7.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "IMBDriveModel.h"
@class IMBFilesHistoryEntity;

//记录上传、下载、同步、重命名、新建文件夹操作记录
@interface IMBUserHistoryTable : NSObject {
    NSString *_savePath;
    FMDatabase *_db;
    NSMutableArray *_fileHisArray;
}
/**保存的历史文件数组*/
@property (nonatomic, retain) NSMutableArray *fileHisArray;

/**
 *  初始化函数
 *
 *  @param savePath 数据库保存路径
 *
 *  @return self
 */
- (id)initWithPath:(NSString *)savePath;

/**
 *  创建数据库
 */
- (BOOL)createSqliteTable;

/**
 *  查询保存的历史文件
 *
 *  @return 数组
 */
- (NSArray *)selectFilesHistory;

/**
 *  插入数据
 *
 *  @param model  插入的文件实体
 */
- (void)insertData:(IMBFilesHistoryEntity *)model;

/**
 *  更新数据
 *
 *  @param model  保存的文件实体
 */
- (void)updateSqlite:(IMBFilesHistoryEntity *)model;

/**
 *  删除数据
 *
 *  @param model  删除的文件实体
 */
- (void)deleteSqlite:(IMBFilesHistoryEntity *)model;

/**
 *  保存操作的记录
 *
 *  @param model 文件及文件夹实体
 */
- (void)saveOperationRecords:(IMBDriveModel *)model;

/**
 *  解析服务端返回的数据
 *
 *  @param dataAry 返回的数据
 */
- (void)analysisHistoryRecords:(NSArray *)dataAry;

@end

@interface IMBFilesHistoryEntity : NSObject {
    NSString *_cloudID;
    NSString *_pathID;
    NSString *_itemName;
    BOOL _isFolder;
    NSString *_serverName;
    NSString *_path;
    NSString *_size;
    NSString *_albumID;
    NSString *_createTime;
    NSString *_userID;
    BOOL _isSync;
}

@property (nonatomic, retain) NSString *cloudID;
@property (nonatomic, retain) NSString *pathID;
@property (nonatomic, retain) NSString *itemName;
@property (nonatomic, assign) BOOL isFolder;
@property (nonatomic, retain) NSString *serverName;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *size;
@property (nonatomic, retain) NSString *albumID;
@property (nonatomic, retain) NSString *createTime;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, assign) BOOL isSync;

@end
