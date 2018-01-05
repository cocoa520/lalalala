//
//  IMBHistorySqliteManager.h
//  AnyTrans
//
//  Created by long on 16-7-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBSqliteManager.h"
@interface IMBHistorySqliteManager : IMBSqliteManager
{
    BOOL _isSqlite;
    NSString *_dbPath;
    NSString *_devicebackupFolderName;
    NSString *_backupFolderPath;
}
@end
