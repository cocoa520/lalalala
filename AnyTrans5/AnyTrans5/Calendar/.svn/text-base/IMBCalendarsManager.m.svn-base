//
//  IMBCalendarsManager.m
//  iMobieTrans
//
//  Created by iMobie on 14-2-20.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//
#define CalendarsDoMain     @"com.apple.Calendars"
#define CalendarsAnchorStr  @"Calendars-Device-Anchor"

#define CALENDARS_ENTITY_NAME @"com.apple.syncservices.RecordEntityName"

#define DOMAIN_CALENDAR @"com.apple.calendars.Calendar"
#define DOMAIN_CALENDARS_EVENT @"com.apple.calendars.Event"
#define DOMAIN_CALENDARS_DISPLAYALARM @"com.apple.calendars.DisplayAlarm"
#define DOMAIN_CALENDARS_RECURRENCE @"com.apple.calendars.Recurrence"

#define ITEM_CALENDAR_KEY @"calendar"
#define ITEM_OWNER_KEY @"owner"
#import "IMBCalendarsManager.h"
#import "IMBCalendarEventEntity.h"
#import "IMBCalendarEntity.h"
#import "DateHelper.h"
@implementation IMBCalendarsManager

- (NSMutableArray *)queryAllCalendarEvents
{
    NSMutableArray *calendarArray = [NSMutableArray array];
    //开始一个会话
    NSArray *retArray = [mobileSync startQuerySessionWithDomain:CalendarsDoMain];
    //此处处理数据
    for (id item in retArray) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            NSDictionary *tmpDic = item;
            NSArray *allKey = [tmpDic allKeys];
            if (allKey != nil && [allKey count] > 0) {
                NSMutableDictionary *noteDic = nil;
                int i = 0;
                for (NSString *key in allKey) {
                    noteDic = [tmpDic objectForKey:key];
                    
                    IMBCalendarEntity *calendar = [[IMBCalendarEntity alloc] init];
                    calendar.calendarID = key;
                    if ([noteDic.allKeys containsObject:@"colorComponents"]) {
                        NSArray *colorArr = [noteDic objectForKey:@"colorComponents"];
                        int red = [[colorArr objectAtIndex:0] intValue];
                        int green = [[colorArr objectAtIndex:1] intValue];
                        int blue = [[colorArr objectAtIndex:2] intValue];
                        int alpha = [[colorArr objectAtIndex:3] intValue];
                        
                        NSColor *color = [NSColor colorWithSRGBRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
                        if (red == -1 && green == -1 && blue == -1) {//默认颜色值
                            color = [NSColor colorWithSRGBRed:56/255.0 green:155/255.0 blue:248/255.0 alpha:alpha/255.0];
                        }
                        calendar.color = color;
                    }
                    
                    if ([noteDic.allKeys containsObject:@"title"]) {
                        calendar.title = [noteDic objectForKey:@"title"];
                    }
                    
                    if ([noteDic.allKeys containsObject:@"read only"]) {
                        calendar.isOnlyRead = [[noteDic objectForKey:@"read only"] boolValue];
                    }
                    
                    if ([noteDic.allKeys containsObject:@"com.apple.syncservices.RecordEntityName"]) {
                        calendar.recordEntityName = [noteDic objectForKey:@"com.apple.syncservices.RecordEntityName"];
                    }
                    calendar.tag = i;
                    i++;
                    
                    [calendarArray addObject:calendar];
                    [calendar release];
                }
            }
        }
    }
    
    NSArray *message = [NSArray arrayWithObjects:
               @"SDMessageAcknowledgeChangesFromDevice",
               @"com.apple.Calendars",
               nil];
    
    while (YES) {
        if (mobileSync == nil || _threadBreak) {
            break;
        }
        retArray = [mobileSync getData:message waitingReply:YES];
        if ([[retArray objectAtIndex:0] isEqualToString:@"SDMessageDeviceReadyToReceiveChanges"]) {
            break;
        } else {
            NSDictionary *allDetailDic = [self getDetailItem:retArray];
          
            NSArray *allDetailKey = [allDetailDic allKeys];
            
            for (NSString *akey in allDetailKey) {
                // 取出日历的信息资料
                NSDictionary *singleDetailDic = [allDetailDic valueForKey:akey];
                NSArray *allSingDicKeys = [singleDetailDic allKeys];
                NSString *calendarID = [[singleDetailDic objectForKey:@"calendar"] objectAtIndex:0];
                
                NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    IMBCalendarEntity *item = (IMBCalendarEntity *)evaluatedObject;
                    if ([[item calendarID] isEqualToString:calendarID]) {
                        return YES;
                    }else {
                        return NO;
                    }
                }];
                NSArray *preArray = [calendarArray filteredArrayUsingPredicate:pre];
                if (preArray != nil && preArray.count > 0) {
                    IMBCalendarEntity *calendarEntity = [preArray objectAtIndex:0];
                    //此处将日历事件字典转换成相应的对象
                    IMBCalendarEventEntity *calendarEvent = [[IMBCalendarEventEntity alloc] initWithDataDic:singleDetailDic];
                    
                    NSDate *startdate = [singleDetailDic objectForKey:@"start date"];
                    NSDate *enddate = [singleDetailDic objectForKey:@"end date"];
                    NSString *startdateStr = [self stringFromFomate:startdate formate:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *enddateStr = [self stringFromFomate:enddate formate:@"yyyy-MM-dd HH:mm:ss"];
                    
//                    if (calendarEvent.eventdescription == nil||[calendarEvent.eventdescription isEqualToString:@""]) {
//                        calendarEvent.eventdescription = CustomLocalizedString(@"Common_id_10", nil);;
//                    }
//                    if (calendarEvent.url == nil||[calendarEvent.url isEqualToString:@""]) {
//                        calendarEvent.url = CustomLocalizedString(@"Common_id_10", nil);;
//                    }
//                    if (calendarEvent.summary == nil||[calendarEvent.summary isEqualToString:@""]) {
//                        calendarEvent.summary =  CustomLocalizedString(@"Common_id_10", nil);;
//                    }
//                    if (calendarEvent.location == nil||[calendarEvent.location isEqualToString:@""]) {
//                        calendarEvent.location =  CustomLocalizedString(@"Common_id_10", nil);;
//                    }
//                    
//                    if (startdateStr == nil||[startdateStr isEqualToString:@""]) {
//                        startdateStr =  CustomLocalizedString(@"Common_id_10", nil);;
//                    }
//                    
//                    if (enddateStr == nil||[enddateStr isEqualToString:@""]) {
//                        enddateStr = CustomLocalizedString(@"Common_id_10", nil);;
//                    }
                    
                    calendarEvent.startCurDate = startdate;
                    calendarEvent.endCurDate = enddate;
                    calendarEvent.startdate = startdateStr;
                    calendarEvent.enddate = enddateStr;
                    calendarEvent.calendarEventID = akey;
                    calendarEvent.calendarID = calendarID;
                    if([allSingDicKeys containsObject:@"all day"]) {
                        calendarEvent.isallDay = [[singleDetailDic objectForKey:@"all day"] boolValue];
                    }
                    
                    [calendarEntity.eventCalendatArray addObject:calendarEvent];
                    [calendarEvent release];
                }
            }
        }
    }
   
    //结束会话
   [mobileSync endSessionWithDomain:CalendarsDoMain];
   return calendarArray;
}

- (NSDictionary*)getDetailItem:(NSArray*)message
{
    NSDictionary *detailDic = nil;
    for (id item in message) {
        if ([item isKindOfClass:[NSDictionary class]]) {
            detailDic = item;
        }
    }
    return detailDic;
}

- (BOOL)deleteCalendars:(NSArray*)calendarsEvent
{
    NSMutableArray *arr = [NSMutableArray array];
    for (IMBCalendarEventEntity *event in calendarsEvent) {
        NSString *calendarEventID = event.calendarEventID;
        [arr addObject:calendarEventID];
    }
    //开启会话
    [mobileSync startDeleteSessionWithDomain:CalendarsDoMain withDomainAnchor:CalendarsAnchorStr];
    
    //此处处理数据
    NSArray *delContent = [self prepareDelData:arr];
    [mobileSync getData:delContent waitingReply:NO];
    
    // 结束会话
    [mobileSync endSessionWithDomain:CalendarsAnchorStr];

    return YES;
}

- (NSArray*)prepareDelData:(NSArray*)contentIDArray
{
    NSMutableArray *delArray = [[NSMutableArray alloc] init];
    [delArray addObject:@"SDMessageProcessChanges"];
    [delArray addObject:@"com.apple.Calendars"];
    
    NSMutableDictionary *delDetail = [[NSMutableDictionary alloc] init];
    for (NSString *cid in contentIDArray) {
        [delDetail setValue:@"___EmptyParameterString___" forKey:cid];
    }
    [delArray addObject:delDetail];
    
    [delArray addObject:[NSNumber numberWithBool:NO]];
    
    [delArray addObject:@"___EmptyParameterString___"];
    
    [delArray autorelease];
    return delArray;
}

- (BOOL)modifyCalendarEvent:(IMBCalendarEventEntity *)calendarEvent
{
    NSArray *retArray = nil;
    [mobileSync startModifySessionWithDomain:CalendarsDoMain withDomainAnchor:CalendarsAnchorStr];
    NSMutableArray *modifyArray = [self prepareModifyData:calendarEvent];
    retArray = [mobileSync getData:modifyArray waitingReply:YES];
    [mobileSync endSessionWithDomain:CalendarsAnchorStr];
    
    return YES;
}

- (NSMutableArray*)prepareModifyData:(IMBCalendarEventEntity *)calendarEvent
{
    NSMutableArray *modifyArray = [[[NSMutableArray alloc] init] autorelease];
    [modifyArray addObject:@"SDMessageProcessChanges"];
    [modifyArray addObject:@"com.apple.Calendars"];
    NSMutableDictionary *calendarsDic =[[NSMutableDictionary alloc] init];
    NSMutableDictionary *calendarDic = [[NSMutableDictionary alloc] init];
    if (calendarEvent.startCurDate != nil) {
        NSDate *startdate = [DateHelper getNowDateFromatAnDate:calendarEvent.startCurDate];
        [calendarDic setObject:startdate forKey:@"start date"];
    }
    if (calendarEvent.endCurDate != nil) {
        NSDate *enddate = [DateHelper getNowDateFromatAnDate:calendarEvent.endCurDate];
        [calendarDic setObject:enddate forKey:@"end date"];
    }
    [calendarDic setObject:@"com.apple.calendars.Event" forKey:@"com.apple.syncservices.RecordEntityName"];
    if (calendarEvent.summary != nil) {
        [calendarDic setObject:calendarEvent.summary forKey:@"summary"];
    }
    if (calendarEvent.location != nil) {
        [calendarDic setObject:calendarEvent.location forKey:@"location"];
    }
    if (calendarEvent.url != nil) {
        [calendarDic setObject:calendarEvent.url forKey:@"url"];
    }
    if (calendarEvent.eventdescription != nil) {
        [calendarDic setObject:calendarEvent.eventdescription forKey:@"description"];
    }
    [calendarDic setObject:[NSNumber numberWithBool:calendarEvent.isallDay] forKey:@"all day"];
    [calendarDic setObject:[NSArray arrayWithObject:calendarEvent.calendarID] forKey:@"calendar"];//calendar id
    [calendarsDic setObject:calendarDic forKey:calendarEvent.calendarEventID];
    [calendarDic release];
    
    [modifyArray addObject:calendarsDic];
    [calendarsDic release];
    
    [modifyArray addObject:[NSNumber numberWithBool:NO]];
    [modifyArray addObject:@"___EmptyParameterString___"];
    
    return modifyArray;
}

- (BOOL)insertCalendarEvent:(IMBCalendarEventEntity *)calendarEvent
{
    NSArray *retArray = nil;
    [mobileSync startModifySessionWithDomain:CalendarsDoMain withDomainAnchor:CalendarsAnchorStr];
    NSMutableArray *insertArray = [self prepareInsertData:calendarEvent];
    retArray = [mobileSync getData:insertArray waitingReply:YES];
    [mobileSync endSessionWithDomain:CalendarsAnchorStr];
    
    return YES;
}

- (NSMutableArray*)prepareInsertData:(IMBCalendarEventEntity *)calendarEvent
{
    NSMutableArray *insertArray = [[[NSMutableArray alloc] init] autorelease];
    [insertArray addObject:@"SDMessageProcessChanges"];
    [insertArray addObject:@"com.apple.Calendars"];
    NSMutableDictionary *calendarsDic =[[NSMutableDictionary alloc] init];
    NSMutableDictionary *calendarDic = [[NSMutableDictionary alloc] init];
    if (calendarEvent.startCurDate) {
        NSDate *startdate = [DateHelper getNowDateFromatAnDate:calendarEvent.startCurDate];
        [calendarDic setObject:startdate forKey:@"start date"];
    }
    if (calendarEvent.endCurDate) {
        NSDate *enddate = [DateHelper getNowDateFromatAnDate:calendarEvent.endCurDate];
        [calendarDic setObject:enddate forKey:@"end date"];
    }
    [calendarDic setObject:@"com.apple.calendars.Event" forKey:@"com.apple.syncservices.RecordEntityName"];
    if (calendarEvent.summary) {
        [calendarDic setObject:calendarEvent.summary forKey:@"summary"];
    }
    if (calendarEvent.location) {
        [calendarDic setObject:calendarEvent.location forKey:@"location"];
    }
    if (calendarEvent.url) {
        [calendarDic setObject:calendarEvent.url forKey:@"url"];
    }
    if (calendarEvent.eventdescription) {
        [calendarDic setObject:calendarEvent.eventdescription forKey:@"description"];
    }
    [calendarDic setObject:[NSNumber numberWithBool:calendarEvent.isallDay] forKey:@"all day"];
    
    [calendarDic setObject:[NSArray arrayWithObject:calendarEvent.calendarID] forKey:@"calendar"];//calendar id
    [calendarsDic setObject:calendarDic forKey:@"2147483647"];//@"2147483647"---calendar event id
    [calendarDic release];
    
    [insertArray addObject:calendarsDic];
    [calendarsDic release];
    
    [insertArray addObject:[NSNumber numberWithBool:false]];
    [insertArray addObject:@"___EmptyParameterString___"];
    
    return insertArray;
}

@end
