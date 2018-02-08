//
//  IMBMessageSqliteManager.h
//  AnyTrans
//
//  Created by long on 16-7-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBSqliteManager.h"
#import "IMBContactBaseInfoManager.h"

@interface IMBMessageSqliteManager : IMBSqliteManager
{
    IMBContactBaseInfoManager *_contactManager;
    BOOL _isOther;
    
}
@end
