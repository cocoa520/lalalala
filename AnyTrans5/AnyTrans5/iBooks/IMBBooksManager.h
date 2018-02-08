//
//  IMBBooksManager.h
//  iMobieTrans
//
//  Created by iMobie on 14-3-17.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileDeviceAccess.h"
#import "IMBSqliteManager.h"
#import "IMBiPod.h"
@interface IMBBooksManager : IMBSqliteManager
{
    @private
    IMBiPod *_ipod;
}
- (id)initWithIpod:(IMBiPod *)ipod;
//查询所有的书
- (NSMutableArray *)queryAllbooks;
//查询所有的collection
- (NSMutableArray *)queryAllcollections;
@end
