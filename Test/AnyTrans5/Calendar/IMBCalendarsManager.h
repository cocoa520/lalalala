//
//  IMBCalendarsManager.h
//  iMobieTrans
//
//  Created by iMobie on 14-2-20.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBMobileSyncManager.h"
@class IMBCalendarEventEntity;
@interface IMBCalendarsManager : IMBMobileSyncManager

//查询所有的日历事件对象，返回是包含所有日历事件对象的数组
- (NSMutableArray *)queryAllCalendarEvents;
//删除指定的日历事件对象，参数含日历事件Id的数组
- (BOOL)deleteCalendars:(NSArray*)calendarEvents;
//修改日历事件
- (BOOL)modifyCalendarEvent:(IMBCalendarEventEntity *)calendarEvent;
//增加新的日历事件
- (BOOL)insertCalendarEvent:(IMBCalendarEventEntity *)calendarEvent;

@end
