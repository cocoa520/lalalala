//
//  IMBContactHelper.h
//  iMobieTrans
//
//  Created by iMobie on 2/24/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBContactEntity.h"


@interface IMBContactHelper : NSObject
+(void)arrayWithEnumeratedDic:(NSDictionary *)dic inArray:(NSMutableArray *)array;
+(void)arrayWithEnumeratedIMDic:(NSDictionary *)dic inArray:(NSMutableArray *)array;
+(void)arrayWithEnumeratedAddrDic:(NSDictionary *)dic inArray:(NSMutableArray *)array;
+(IMBContactEntity*)assemblyEntityToContactEntity:(IMBContactBaseEntity *)entity inToContactEntity:(IMBContactEntity*)contEntity;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;
@end
