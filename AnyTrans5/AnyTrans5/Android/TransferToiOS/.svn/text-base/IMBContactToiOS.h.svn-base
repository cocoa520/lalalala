//
//  IMBContactToiOS.h
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBBaseClone.h"
/**
 此类是contact 插入iOS数据库逻辑
 */
@interface IMBContactToiOS : IMBBaseClone
{
    IMBMBFileRecord *_sourceContactImageRecord;  ///<源联系人头像数据库record对象
    IMBMBFileRecord *_targetContactImageRecord;  ///<目标联系人头像数据库record对象
    NSString *_sourceSqliteContactImagePath;   ///<源联系人头像数据库路径
    NSString *_targetSqliteContactImagePath;  ///<目标联系人头像数据库路径
    FMDatabase *_sourceImageDBConnection;  ///<源联系人头像数据库句柄
    FMDatabase *_targetImageDBConnection;  ///<目标联系人头像数据库句柄
}
@end
