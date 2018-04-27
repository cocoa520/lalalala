//
//  DateHelper.h
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject
+(NSDate*)dateFrom2001:(double)timeStamp;
+(NSDate*)dateFrom1970:(double)timeStamp;
+ (NSDate *)dateFromString2001;
+(NSString *)dateFrom2001ToDate:(NSDate*)date withMode:(int)mode;
+(NSString *)dateFrom2001ToString:(double)timeStamp withMode:(int)mode;
+(NSString *)dateFrom1970ToString:(double)timeStamp withMode:(int)mode;
+(NSTimeInterval)timeIntervalFrom2001To1970:(double)timeStamp;
+(NSTimeInterval)timeIntervalFrom1970To2001:(double)timeStamp;
+(NSTimeInterval)getTimeStampFromDate:(NSDate*)date;
+(NSTimeInterval)getTimeStampFrom1970Date:(NSDate*)date;
+(NSTimeInterval)getTimeStampFrom1970Date:(NSDate*)date withTimezone:(NSTimeZone *)timeZone;
//@"yyyy-MM-dd HH:mm:ss"
+ (NSDate *)dateFromString:(NSString *)dateString Formate:(NSString *)formate;
+ (NSDate *)dateFromString:(NSString *)dateString Formate:(NSString *)formate withTimeZone:(NSTimeZone *)timeZone;
+(NSTimeInterval)getTimeIntervalSince2001:(NSDate *)date;
+(NSString*)stringFromFomate:(NSDate*) date formate:(NSString*)formate;
+(NSDate*)getDateTimeFromTimeStamp2001:(long)timeStamp;
+(NSString*)getHistoryDateString:(NSDate*)historyDate;
+(NSDate*)getDateTimeFromTimeStamp1970:(long long)times timeOffset:(int64_t)offset ;
+(NSString *)dateFrom1904ToString:(double)timeStamp withMode:(int)mode;
+(NSDate*)dateFrom1904:(double)timeStamp;
+(NSString*)getTimeAutoShowHourString:(long)totalLength ;
+ (NSString *)longToHourDateString:(long)timeStamp;
+ (NSString*)getShortDateString:(NSDate*)date;
+(double)getTotalSecondsFromHHMMSSMS:(NSString*)timeStr;
+ (NSString *)getTempNameByDateTime;
+ (NSString *)longToDateString1970:(long)timeStamp withMode:(int)mode;
+ (NSString *)longToDateString:(long)timeStamp withMode:(int)mode;
+ (NSUInteger)getDateLength:(long long)date;
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
+ (NSString *)dateForm2001DateSting:(NSString *) dateSting;
@end
