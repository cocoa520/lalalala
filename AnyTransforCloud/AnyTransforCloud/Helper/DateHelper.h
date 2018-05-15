//
//  DateHelper.h
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

/**
 *  NSString 转换成 NSDate
 *  @param dateString 需要转换的时间字符串
 *  @param formate 需要转换的格式 如 yyyy/MM/dd
 *  @param timeZone 时区
 */
+ (NSDate *)dateFromString:(NSString *)dateString Formate:(NSString *)formate withTimeZone:(NSTimeZone *)timeZone;

/**
 *  NSDate 转换成 时间戳
 *  @param date NSDate
 *  @param timeZone 时区
 */
+(NSTimeInterval)getTimeStampFrom1970Date:(NSDate*)date withTimezone:(NSTimeZone *)timeZone;

/**
 *  时间戳 转换成 NSString
 *  @param timeStamp 时间戳
 *  @param mode 需要转换的格式 如 yyyy/MM/dd
 */
+(NSString *)dateFrom1970ToString:(double)timeStamp withMode:(int)mode;
/**
 *  今天的时间
 *
 *  @return
 */
+(NSString *)toDayDateString;


/**
 *  获取两个时间段之间的时间天数差
 *
 *  @param serverDate 原始时间
 *  @param endDate    现在时间
 *
 *  @return
 */
+ (NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;
@end
