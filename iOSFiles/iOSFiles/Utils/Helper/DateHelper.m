//
//  DateHelper.m
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "DateHelper.h"
#import "IMBSoftWareInfo.h"
#import "NSString+Category.h"
#import "StringHelper.h"
@implementation DateHelper
+(NSDate*)dateFrom2001:(double)timeStamp{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *originDate = [dateFormatter dateFromString:@"2001-01-01 00:00:00"];
    if(originDate == nil || originDate == NULL) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        originDate = [dateFormatter dateFromString:@"2001-01-01 00:00:00"];
    }
    NSDate *returnDate = [[[NSDate alloc] initWithTimeInterval:timeStamp sinceDate:originDate] autorelease];
    [dateFormatter release];
    return returnDate;
}

+ (NSDate *)dateFromString2001 {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *date = nil;
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    date = [dateFormatter dateFromString:@"2001/01/01 00:00:00"];
    [dateFormatter release];
    return date;
}

+(NSDate*)dateFrom1970:(double)timeStamp
{
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


+(NSString *)dateFrom2001ToDate:(NSDate*)date withMode:(int)mode
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (mode == 0) {
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    }else if (mode == 1) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }else if (mode == 2) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else if (mode == 3) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }else if (mode == 4){
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    }else if(mode == 5){
        [dateFormatter setDateFormat:@"EEEE yy/MM/dd"];
    }else if (mode == 6) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    }else if (mode == 7) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    }
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    NSString *returnString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return returnString;
}

+(NSString *)dateFrom2001ToString:(double)timeStamp withMode:(int)mode
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (mode == 0) {
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    }else if (mode == 1) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }else if (mode == 2) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else if (mode == 3) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }else if (mode == 4){
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    }else if(mode == 5){
        [dateFormatter setDateFormat:@"EEEE yy/MM/dd"];
    }else if (mode == 6) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    }else if(mode == 7){
        [dateFormatter setDateFormat:@"yyyyMMdd"];
    }
    NSDate *date = [self dateFrom2001:timeStamp];
    NSString *returnString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return returnString;
}

+(NSString *)dateFrom1970ToString:(double)timeStamp withMode:(int)mode
{
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


+ (NSString *)longToDateString:(long)timeStamp withMode:(int)mode {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    NSString *_systemDateFormatter = @"";
    _systemDateFormatter = @"MM/dd/yyyy";
    NSDate *nowDate = [NSDate date];
    NSString *sDateStr = [NSDateFormatter localizedStringFromDate:nowDate dateStyle:NSDateFormatterMediumStyle timeStyle:0];
    if ([sDateStr contains:@"年"]) {
        _systemDateFormatter = @"yyyy/MM/dd";
    }else {
        _systemDateFormatter = @"MM/dd/yyyy";
    }
    if (mode == 0) {
        [dateFormatter setDateFormat:_systemDateFormatter];
    } else if (mode == 1) {
        [dateFormatter setDateFormat:_systemDateFormatter];
    } else if (mode == 2) {
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",_systemDateFormatter]];
    } else if (mode == 3) {
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm a",_systemDateFormatter]];
    }else if (mode == 4) {
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"EEEE %@",_systemDateFormatter]];
    }else if (mode == 6){
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"yyyy/MM/dd"]];
    }else if (mode == 7){
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ ",_systemDateFormatter]];
    }
    NSDate *date = [self getDateTimeFromTimeStamp2001:(uint)timeStamp];
    NSString *returnString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return returnString;
}

+ (NSUInteger)getDateLength:(long long)date {
    NSUInteger length = 10;
    NSString *dateStr = [NSString stringWithFormat:@"%lld",date];
    length = dateStr.length;
    return length;
}

+(NSString *)dateFrom1904ToString:(double)timeStamp withMode:(int)mode
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (mode == 0) {
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    }else if (mode == 1) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }else if (mode == 2) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else if (mode == 3) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    NSDate *date = [self dateFrom1904:timeStamp];
    NSString *returnString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return returnString;
}

+(NSDate*)dateFrom1904:(double)timeStamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *originDate = [dateFormatter dateFromString:@"1904-01-01 00:00:00"];
    if(originDate == nil || originDate == NULL) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        originDate = [dateFormatter dateFromString:@"1904-01-01 00:00:00"];
    }
    NSDate *returnDate = [[[NSDate alloc] initWithTimeInterval:timeStamp sinceDate:originDate] autorelease];
    [dateFormatter release];
    return returnDate;
}

+(NSDate*)getDateTimeFromTimeStamp1904:(long long)times timeOffset:(int64_t)offset {
    NSDate *returnDate = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    NSDate *originDate;
    if (times != 3130000000) {
        originDate = [dateFormatter dateFromString:@"1904/01/01 00:00:00"];
        returnDate = [NSDate dateWithTimeInterval:(double)(times + offset) sinceDate:originDate];
    }else{
        originDate = [dateFormatter dateFromString:@"1904/01/01 00:00:00"];
        returnDate = [NSDate dateWithTimeInterval:0 sinceDate:originDate];
    }
    [dateFormatter release];
    return returnDate;
}

+(NSTimeInterval)timeIntervalFrom2001To1970:(double)timeStamp
{
    NSDate *returnDate = [self dateFrom2001:timeStamp];
    NSTimeInterval timeInterval = [returnDate timeIntervalSince1970];
    return timeInterval;

}

+(NSTimeInterval)timeIntervalFrom1970To2001:(double)timeStamp
{
    NSDate *returnDate = [self dateFrom1970:timeStamp];
    NSDate *originDate = [self dateFrom2001:0];
    NSTimeInterval timeInterval = [returnDate timeIntervalSinceDate:originDate];
    return timeInterval;
}

+(NSTimeInterval)getTimeStampFromDate:(NSDate*)date
{
    NSTimeInterval timestamp;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *originDate = [dateFormatter dateFromString:@"1904-01-01 00:00:00"];
    if(originDate == nil || originDate == NULL) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        originDate = [dateFormatter dateFromString:@"1904-01-01 00:00:00"];
    }
    timestamp = [date timeIntervalSinceDate:originDate];
    [dateFormatter release];
    return timestamp;
}

+(NSTimeInterval)getTimeStampFrom1970Date:(NSDate*)date
{
    NSTimeInterval timestamp;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
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

+(NSTimeInterval)getTimeStampFrom1970Date:(NSDate*)date withTimezone:(NSTimeZone *)timeZone
{
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

+(NSTimeInterval)getTimeIntervalSince2001:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSDate *originDate = [dateFormatter dateFromString:@"01/01/2001 00:00:00"];
    if(originDate == nil || originDate == NULL) {
        [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
        originDate = [dateFormatter dateFromString:@"01/01/2001 00:00:00"];
    }
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:originDate];
    [dateFormatter release];
    return timeInterval;
}
//@"yyyy-MM-dd HH:mm:ss"
+ (NSDate *)dateFromString:(NSString *)dateString Formate:(NSString *)formate{
    if (formate == nil) {
        formate = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    [dateFormatter setDateFormat:formate];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    return destDate;
}

+ (NSDate *)dateFromString:(NSString *)dateString Formate:(NSString *)formate withTimeZone:(NSTimeZone *)timeZone {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:formate];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    return destDate;
}

+ (NSString*) stringFromFomate:(NSDate*)date formate:(NSString*)formate {
	
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	[formatter release];
    return str;
}

+(NSDate*)getDateTimeFromTimeStamp2001:(long)timeStamp{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *originDate = nil;
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    originDate = [dateFormatter dateFromString:@"2001/01/01 00:00:00"];
    if(originDate == nil || originDate == NULL) {
        [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
        originDate = [dateFormatter dateFromString:@"2001/01/01 00:00:00"];
    }
    NSDate *returnDate = [NSDate dateWithTimeInterval:(uint)timeStamp sinceDate:originDate];
    [dateFormatter release];
    return returnDate;
}

+(NSString*)getHistoryDateString:(NSDate*)historyDate {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
    
    //NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    [components setHour:+24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *tomorrow = [cal dateByAddingComponents:components toDate: today options:0];
    
    components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
    
    [components setDay:([components day] - 6)];
    NSDate *lastWeek  = [cal dateFromComponents:components];
    
    NSString* _lastcallStr = @"";
    if ( [historyDate isGreaterThanOrEqualTo:today] && [historyDate isLessThan:tomorrow]) {
        //只显示时间
        _lastcallStr = [NSDateFormatter localizedStringFromDate:historyDate
                                                      dateStyle:0
                                                      timeStyle:NSDateFormatterMediumStyle];
    } else if ([historyDate isGreaterThanOrEqualTo: yesterday] && [historyDate isLessThan:today]) {
        
        //显示星期与时间
        NSString *timeStr = [NSDateFormatter localizedStringFromDate:historyDate
                                                           dateStyle:0
                                                           timeStyle:NSDateFormatterMediumStyle];
//        NSString *yesterdayStr = CustomLocalizedString(@"text_id_262", nil);
        
//        _lastcallStr = [NSString stringWithFormat:@"%@ %@", yesterdayStr, timeStr];
        
        
        
    } else if ([historyDate isGreaterThanOrEqualTo:lastWeek]){
        //显示星期与时间
        NSString *timeStr = [NSDateFormatter localizedStringFromDate:historyDate
                                                           dateStyle:0
                                                           timeStyle:NSDateFormatterMediumStyle];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEE" options:0 locale:[NSLocale currentLocale]];
        NSString *weekDayStr = [dateFormatter stringFromDate:historyDate];
        _lastcallStr = [NSString stringWithFormat:@"%@ %@", weekDayStr, timeStr];
        [dateFormatter release];
    } else {
        //显示日期与时间
        _lastcallStr = [NSDateFormatter localizedStringFromDate:historyDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    }
    return _lastcallStr;
}

+(NSDate*)getDateTimeFromTimeStamp1970:(long long)times timeOffset:(int64_t)offset {
    NSDate *returnDate = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    NSDate *originDate = [NSDate dateWithTimeIntervalSince1970:0];
    if (times != 3130000000) {
        if ([[IMBSoftWareInfo singleton].systemDateFormatter isEqualToString:@"MM/dd/yyyy"]) {
            originDate = [dateFormatter dateFromString:@"01/01/1970 00:00:00"];
        }else {
            originDate = [dateFormatter dateFromString:@"1970/01/01 00:00:00"];
        }
        returnDate = [NSDate dateWithTimeInterval:(double)(times + offset) sinceDate:originDate];
    }else{
        if ([[IMBSoftWareInfo singleton].systemDateFormatter isEqualToString:@"MM/dd/yyyy"]) {
            originDate = [dateFormatter dateFromString:@"01/01/1970 08:00:00"];
        }else {
            originDate = [dateFormatter dateFromString:@"1970/01/01 08:00:00"];
        }
        returnDate = [NSDate dateWithTimeInterval:0 sinceDate:originDate];
    }
    [dateFormatter release];
    return returnDate;
}

+(NSString*)getTimeAutoShowHourString:(long)totalLength {
    if (totalLength < 1000) {
        return @"-";
    }
    int hours = (int)(totalLength / 3600000 );
    int remain = totalLength % 3600000;
    int minutes = (int)(remain / 60000);
    int seconds = (remain % 60000) / 1000;
    NSString *timeStr = @"";
    if (hours > 0) {
        timeStr = [NSString stringWithFormat:@"%02d:%02d:%02d", hours,minutes, seconds] ;
    } else {
        timeStr = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds] ;
    }
    
    
    return timeStr;
}

+ (NSString *)longToHourDateString:(long)timeStamp {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    NSDate *date = [self getDateTimeFromTimeStamp2001:(uint)timeStamp];
    NSString *returnString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return returnString;
}

+ (NSString*)getShortDateString:(NSDate*)date {
    NSString* retVal = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay;
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    NSDate *today = [NSDate date];
    
    NSDateComponents *comp = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:today];
    [comp setHour:-24];
    [comp setMinute:0];
    [comp setSecond:0];
    NSDate *yesterday = [calendar dateByAddingComponents:comp toDate:today options:0];
    [comp setHour:+24];
    [comp setMinute:0];
    [comp setSecond:0];
    NSDate *tomorrow = [calendar dateByAddingComponents:comp toDate:today options:0];
    
    comp = [calendar components:unit fromDate:today];
    BOOL isToday = (selfCmps.year == comp.year) && (selfCmps. month == comp.month) && (selfCmps.day == comp.day);
    if (isToday) {
        NSDateFormatter *df=[[NSDateFormatter alloc] init];
        [df setDateFormat:@"hh:mm a"];
        NSString *timeStr = [df stringFromDate:date];
        [df release];
        df = nil;
//        retVal = [NSString stringWithFormat:@"%@ %@", CustomLocalizedString(@"MSG_Date_Today", nil), timeStr];
        return retVal;
    }
    
    comp = [calendar components:unit fromDate:yesterday];
    BOOL isYesterday = (selfCmps.year == comp.year ) && (selfCmps.month == comp.month ) && (selfCmps.day == comp.day);
    if (isYesterday) {
        NSDateFormatter *df=[[NSDateFormatter alloc] init];
        [df setTimeZone:[NSTimeZone systemTimeZone]];
        [df setDateFormat:@"hh:mm a"];
        NSString *timeStr = [df stringFromDate:date];
        [df release];
        df = nil;
//        retVal = [NSString stringWithFormat:@"%@ %@",CustomLocalizedString(@"MSG_Date_Yesterday", nil) , timeStr];
        return retVal;
    }
    
    comp = [calendar components:unit fromDate:tomorrow];
    BOOL isTomorrow = (selfCmps.year == comp.year) && (selfCmps.month == comp.month) && (selfCmps.day == comp.day);
    if (isTomorrow) {
        NSDateFormatter *df=[[NSDateFormatter alloc] init];
        [df setTimeZone:[NSTimeZone systemTimeZone]];
        [df setDateFormat:@"hh:mm a"];
        NSString *timeStr = [df stringFromDate:date];
        [df release];
        df = nil;
//        retVal = [NSString stringWithFormat:@"%@ %@", CustomLocalizedString(@"MSG_Date_Tomorrow", nil), timeStr];
        return retVal;
    }
    
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"yyyy-MM-dd hh:mm a"];
    retVal = [df stringFromDate:date];
    [df release];
    df = nil;
    
    return retVal;
}

+ (NSString *)dateForm2001DateSting:(NSString *) dateSting {
    if ([StringHelper stringIsNilOrEmpty:dateSting] ) {
        return @"";
    }
    NSString *replacString = [dateSting stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString * replacString1 = [replacString substringToIndex:19];
    NSDate *replacDate = [DateHelper dateFromString:replacString1 Formate:nil];
    NSString *replacDateString = [DateHelper dateFrom2001ToDate:replacDate withMode:2];
    return replacDateString;
}

+(double)getTotalSecondsFromHHMMSSMS:(NSString*)timeStr {
    double duration = 0.0;
    NSRange range = [timeStr rangeOfString:@"."];
    if (range.length > 0) {
        NSString *hhmmss = [timeStr substringToIndex:range.location];
        NSString *mis = [timeStr substringFromIndex:range.location];
        NSArray *hmsArray = [hhmmss componentsSeparatedByString:@":"];
        if (hmsArray != nil && hmsArray.count == 3) {
            duration = [[hmsArray objectAtIndex:0] intValue] * 60 * 60 + [[hmsArray objectAtIndex:1 ] intValue] * 60 + [[hmsArray objectAtIndex:2] intValue];
        }
        duration += [mis doubleValue];
    }
    return duration;
}

+ (NSString *)getTempNameByDateTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssfff"];
    NSString *fileName = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return fileName;
}

+ (NSString *)longToDateString1970:(long)timeStamp withMode:(int)mode {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (mode == 0) {
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    }else if (mode == 1) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }else if (mode == 2) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }else if (mode == 3) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    NSDate *date = [self getDateTimeFromTimeStamp1970:(uint)timeStamp timeOffset:0];
    NSString *returnString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return returnString;
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate {
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate] autorelease];
    return destinationDateNow;
}

@end
