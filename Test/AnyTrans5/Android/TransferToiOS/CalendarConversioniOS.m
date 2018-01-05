//
//  CalendarConversioniOS.m
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "CalendarConversioniOS.h"
#import "DateHelper.h"
#import "IMBADCalendarEntity.h"
#import "IMBCalAndRemEntity.h"
@implementation CalendarConversioniOS
- (id)dataConversion:(id)entity
{
    IMBADCalendarEntity *adEntity = (IMBADCalendarEntity *)entity;
    IMBCalAndRemEntity *calendar = [[IMBCalAndRemEntity alloc] init];
    calendar.summary = adEntity.calendarTitle;
    calendar.description = adEntity.calendarDescription;
    calendar.location = adEntity.calendarLocation;
    calendar.startTime = [DateHelper timeIntervalFrom1970To2001:adEntity.calendarStartTime/1000.0];
    calendar.endTime = [DateHelper timeIntervalFrom1970To2001:adEntity.calendarEndTime/1000.0];
    return [calendar autorelease];
}
@end
