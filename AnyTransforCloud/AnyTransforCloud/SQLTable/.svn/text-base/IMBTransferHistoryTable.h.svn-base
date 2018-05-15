//
//  IMBTransferHistoryTable.h
//  AnyTransforCloud
//
//  Created by hym on 08/05/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class IMBDriveModel;
@interface IMBTransferHistoryTable : NSObject
{
    NSMutableArray *_upLoadFailAryM;///上传失败的任务
    NSMutableArray *_downLoadFailAryM;///下载失败的任务
    NSMutableArray *_completeAryM;///传输完成的任务
    NSString *_savePath;
}

@property (nonatomic, retain) NSMutableArray *upLoadFailAryM;
@property (nonatomic, retain) NSMutableArray *downLoadFailAryM;
@property (nonatomic, retain) NSMutableArray *completeAryM;

+ (IMBTransferHistoryTable *)singleton;
/**
 *  读取数据库内容
 */
- (void)readSqliteData;

/**
 *  保存到数据库
 *
 *  @param model 具体的model
 */
- (void)saveSqliteWithItem:(IMBDriveModel *)item;

/**
 *  删除数据库中某一行
 *
 */
- (void)deleteDataSqlite:(NSString *)fileId;
@end
