//
//  CalendarConversioniCloud.m
//  
//
//  Created by JGehry on 7/6/17.
//
//

#import "CalendarConversioniCloud.h"
#import "IMBADCalendarEntity.h"
#import "IMBiCloudCalendarEventEntity.h"
#import "DateHelper.h"

@implementation CalendarConversioniCloud
@synthesize conversionDict = _conversionDict;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    [self setConversionDict:nil];
    [super dealloc];
#endif
}

- (instancetype)init
{
    if (self = [super init]) {
        _conversionDict = [[NSMutableDictionary alloc] init];
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

//数据转化为iCloud支持的类型
- (void)conversionAccountToiCloud:(id)account {
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] init];
    IMBCalendarAccountEntity *entity = nil;
    if ([account isMemberOfClass:[IMBCalendarAccountEntity class]]) {
        entity = (IMBCalendarAccountEntity *)account;
    }
    for (IMBADCalendarEntity *eventEntity in entity.eventArray) {
        @autoreleasepool {
            [returnDic addEntriesFromDictionary:[self conversionToiCloud:eventEntity]];
        }
    }
    [returnDic setObject:entity.displayName forKey:@"accountName"];
    [_conversionDict setObject:returnDic forKey:[NSString stringWithFormat:@"%d", [entity accountId]]];
    [returnDic release];
    returnDic = nil;
}

- (NSMutableDictionary *)conversionToiCloud:(IMBADCalendarEntity *)entity {
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    IMBiCloudCalendarEventEntity *eventEntity = [[IMBiCloudCalendarEventEntity alloc] init];
    [eventEntity setCalendarEventID:[NSString stringWithFormat:@"%d", entity.calendarID]];
    [eventEntity setCalendarID:[NSString stringWithFormat:@"%d", entity.parentID]];
    [eventEntity setSummary:entity.calendarTitle];
    [eventEntity setEventdescription:entity.calendarDescription];
    NSDate *startDate = [DateHelper dateFromString:entity.calendarDateStart Formate:@"MM/dd/yyyy HH:mm:ss"];
    NSDate *endDate = [DateHelper dateFromString:entity.calendarDateEnd Formate:@"MM/dd/yyyy HH:mm:ss"];
    NSTimeInterval startTime = [startDate timeIntervalSince1970];
    NSTimeInterval endTime = [endDate timeIntervalSince1970];
    [eventEntity setStartCalTime:[[NSNumber numberWithDouble:startTime] longLongValue]];
    [eventEntity setEndCalTime:[[NSNumber numberWithDouble:endTime] longLongValue]];
    if ((eventEntity.startCalTime <= 0) && (eventEntity.endCalTime <= 0)) {
        NSDate *currentDate = [DateHelper getNowDateFromatAnDate:[NSDate date]];
        NSTimeInterval currentTime = [currentDate timeIntervalSince1970];
        [eventEntity setStartCalTime:[[NSNumber numberWithDouble:currentTime] longLongValue]];
        [eventEntity setEndCalTime:[[NSNumber numberWithDouble:currentTime] longLongValue]];
    }else if (eventEntity.startCalTime <= 0) {
        [eventEntity setStartCalTime:[[NSNumber numberWithDouble:endTime] longLongValue]];
    }else if (eventEntity.endCalTime <= 0) {
        [eventEntity setEndCalTime:[[NSNumber numberWithDouble:startTime] longLongValue]];
    }
    [eventEntity setLocation:entity.calendarLocation];
    [dict setObject:eventEntity forKey:[NSString stringWithFormat:@"%d", entity.calendarID]];
    [eventEntity release];
    eventEntity = nil;
    return dict;
}

@end
