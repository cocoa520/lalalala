//
//  DateHelper.m
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "DateHelper.h"
@implementation DateHelper

+ (NSDate *)dateFromString:(NSString *)dateString Formate:(NSString *)formate withTimeZone:(NSTimeZone *)timeZone {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:formate];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    return destDate;
}

+(NSTimeInterval)getTimeStampFrom1970Date:(NSDate*)date withTimezone:(NSTimeZone *)timeZone {
    NSTimeInterval timestamp;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *originDate = [dateFormatter dateFromString:@"1970-01-01 00:00:00"];
    if(originDate == nil || originDate == NULL) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        originDate = [dateFormatter dateFromString:@"1970-01-01 00:00:00"];
    }
    timestamp = [date timeIntervalSinceDate:originDate];
    [dateFormatter release];
    return timestamp;
}

+(NSString *)dateFrom1970ToString:(double)timeStamp withMode:(int)mode {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (mode == 0) {
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    }else if (mode == 1) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }else if (mode == 2) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else if (mode == 3) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }else if (mode == 4) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm"];
    }else if (mode == 5) {
        [dateFormatter setDateFormat:@"yyyyMMdd"];
    }
    NSDate *date = [self dateFrom1970:timeStamp];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    NSString *returnString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return returnString;
}

+(NSString *)toDayDateString {
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    [dateFormatter release];
    dateFormatter = nil;
    return currentDateString;
}

+ (NSDate*)dateFrom1970:(double)timeStamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *originDate = [dateFormatter dateFromString:@"1970-01-01 00:00:00"];
    if(originDate == nil || originDate == NULL) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        originDate = [dateFormatter dateFromString:@"1970-01-01 00:00:00"];
    }
    NSDate *returnDate = [[[NSDate alloc] initWithTimeInterval:timeStamp sinceDate:originDate] autorelease];
    [dateFormatter release];
    return returnDate;
}


+ (NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    [gregorian release];
    gregorian = nil;
    return dayComponents.day;
}
@end
