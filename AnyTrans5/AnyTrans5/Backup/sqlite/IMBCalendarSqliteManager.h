//
//  IMBCalendarSqliteManager.h
//  AnyTrans
//
//  Created by long on 16-7-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBSqliteManager.h"
@interface IMBCalendarSqliteManager : IMBSqliteManager
{
    BOOL _needQueryRedminder;
}
@property (nonatomic,assign)BOOL needQueryRedminder;
@end
