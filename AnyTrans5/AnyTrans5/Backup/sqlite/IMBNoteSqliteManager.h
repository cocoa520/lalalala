//
//  IMBNoteSqliteManager.h
//  iMobieTrans
//
//  Created by iMobie on 14-2-21.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBSqliteManager.h"
@interface IMBNoteSqliteManager : IMBSqliteManager
{
    BOOL _isiCloud;
    BOOL _isScanOldSql;
    NSMutableArray *attachAry;
}

@end
