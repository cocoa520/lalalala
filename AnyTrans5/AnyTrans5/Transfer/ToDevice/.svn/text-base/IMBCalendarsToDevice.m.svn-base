//
//  IMBCalendarsToDevice.m
//  AnyTrans
//
//  Created by iMobie on 7/27/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#define CalendarsDoMain     @"com.apple.Calendars"
#define CalendarsAnchorStr  @"Calendars-Device-Anchor"

#import "IMBCalendarsToDevice.h"
#import "IMBCalendarEventEntity.h"
#import "DateHelper.h"
#import "IMBSoftWareInfo.h"

@implementation IMBCalendarsToDevice

- (id)initWithCalendarID:(NSString *)calendarID selectedArray:(NSArray *)selectArrs desiPodKey:(NSString *)desiPodKey delegate:(id)delegate {
    if (self = [super initWithIPodkey:desiPodKey withDelegate:delegate]) {
        _selectedArr = [selectArrs retain];
        _calendarID = [calendarID retain];
        _calendarsManager = [[IMBCalendarsManager alloc] initWithAMDevice:_ipod.deviceHandle];
        _totalItemCount = (int)selectArrs.count;
    }
    return self;
}

- (void)dealloc {
    [_selectedArr release],_selectedArr = nil;
    [_calendarID release],_calendarID = nil;
    [_calendarsManager release],_calendarsManager = nil;
    [super dealloc];
}

- (void)startTransfer {
    _ipod.beingSynchronized = YES;
    NSString *msgStr = CustomLocalizedString(@"ImportSync_id_20", nil);
    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
        [_transferDelegate transferFile:msgStr];
    }
    [_calendarsManager openMobileSync];
    [self insertCalendarEvents:_selectedArr];
    [_calendarsManager closeMobileSync];
    
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
    _ipod.beingSynchronized = NO;
}

- (BOOL)insertCalendarEvents:(NSArray *)calendarEvents
{
    NSArray *retArray = nil;
    NSString *msgStr = CustomLocalizedString(@"ImportSync_id_2", nil);
    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
        [_transferDelegate transferFile:msgStr];
    }
    [_calendarsManager.mobileSync startModifySessionWithDomain:CalendarsDoMain withDomainAnchor:CalendarsAnchorStr];
    NSMutableArray *insertArray = [self prepareInsertArray:calendarEvents];
    msgStr = CustomLocalizedString(@"ImportSync_id_1", nil);
    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
        [_transferDelegate transferFile:msgStr];
    }
    retArray = [_calendarsManager.mobileSync getData:insertArray waitingReply:YES];
    [_calendarsManager.mobileSync endSessionWithDomain:CalendarsAnchorStr];
    if (retArray != nil && retArray.count > 0) {
        for (id item in retArray) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                _successCount = (int)[(NSDictionary *)item allKeys].count;
                [_limitation reduceRedmainderCount:_successCount];
            }
        }
    }else {
        _successCount = 0;
    }
    
    return YES;
}

- (NSMutableArray*)prepareInsertArray:(NSArray *)calendarEvents
{
    NSMutableArray *insertArray = [[[NSMutableArray alloc] init] autorelease];
    [insertArray addObject:@"SDMessageProcessChanges"];
    [insertArray addObject:@"com.apple.Calendars"];
    int i = 2147483647;
    NSMutableDictionary *calendarsDic =[[NSMutableDictionary alloc] init];
    long long remainderCount = _limitation.remainderCount;
    for (IMBCalendarEventEntity *entity in calendarEvents) {
        if (![IMBSoftWareInfo singleton].isRegistered && remainderCount <= 0) {
            break;
        }
        NSMutableDictionary *calendarDic = [[NSMutableDictionary alloc] init];
        if (entity.startCurDate != nil) {
            NSDate *startdate = [DateHelper getNowDateFromatAnDate:entity.startCurDate];
            [calendarDic setObject:startdate forKey:@"start date"];
        }
        if (entity.endCurDate != nil) {
            NSDate *enddate = [DateHelper getNowDateFromatAnDate:entity.endCurDate];
            [calendarDic setObject:enddate forKey:@"end date"];
        }
        [calendarDic setObject:@"com.apple.calendars.Event" forKey:@"com.apple.syncservices.RecordEntityName"];
        if (entity.summary != nil) {
            [calendarDic setObject:entity.summary forKey:@"summary"];
        }
        if (entity.location != nil) {
            [calendarDic setObject:entity.location forKey:@"location"];
        }
        if (entity.url != nil) {
            [calendarDic setObject:entity.url forKey:@"url"];
        }
        
        if (entity.eventdescription != nil) {
            [calendarDic setObject:entity.eventdescription forKey:@"description"];
        }
        [calendarDic setObject:[NSNumber numberWithBool:entity.isallDay] forKey:@"all day"];
        
        [calendarDic setObject:[NSArray arrayWithObject:_calendarID] forKey:@"calendar"];//calendar id
        [calendarsDic setObject:calendarDic forKey:[NSString stringWithFormat:@"%d",i]];//@"2147483647"---calendar event id
        i--;
        [calendarDic release];
        if (![IMBSoftWareInfo singleton].isRegistered) {
            remainderCount --;
        }
    }
    [insertArray addObject:calendarsDic];
    [calendarsDic release];
    
    [insertArray addObject:[NSNumber numberWithBool:false]];
    [insertArray addObject:@"___EmptyParameterString___"];
    
    return insertArray;
}

@end
