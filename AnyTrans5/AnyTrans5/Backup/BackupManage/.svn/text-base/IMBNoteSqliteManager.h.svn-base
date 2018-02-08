//
//  IMBNoteSqliteManager.h
//  iMobieTrans
//
//  Created by iMobie on 14-2-21.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBNotesEntity.h"
#import "IMBSqliteManager.h"
@interface IMBNoteSqliteManager : IMBSqliteManager
{
    BOOL _isScanOldSql;
    NSString *_backUpPath;
    BOOL _dbType;
    NSMutableArray *noteAry;
}
@property (nonatomic, retain) NSMutableArray *noteAry;
//通过数据库查询所有的IMBNoteEntity对象
- (NSMutableArray *)queryAllNotes;
- (BOOL)exportTofolderPath:(NSString *)folderPath noteArray:(NSMutableArray *)noteArray withExportMode:(NSString *)type;
- (void)querySqliteDBContent;
@end
