//
//  IMBCallLogToiOS.h
//  AnyTrans
//
//  Created by LuoLei on 2017-07-10.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBBaseClone.h"
/**
 此类是callhistory 插入iOS数据库逻辑
 */
@interface IMBCallLogToiOS : IMBBaseClone
{
    FMDatabase    *_targetContactDBConnection;  ///<目标数据库句柄
    IMBMBFileRecord  *_contactRecord;  ///<联系人数据库record对象
    NSString *_contactsqlitePath;  //联系人数据库路径
}
@end