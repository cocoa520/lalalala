//
//  IMBCalendars.h
//  iMobieTrans
//
//  Created by iMobie on 14-2-20.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBBaseModel.h"

@interface IMBCalendarEventEntity : IMBBaseModel
{
    NSString    *_calendarEventID;     //日历事件的ID
    NSString    *_calendarID;          //日历ID 事件所属日历的ID
    NSString    *_eventdescription;    //事件描述
    NSString    *_enddate;             //事件结束时间
    NSString    *_startdate;           //事件开始时间
    NSString    *_location;            //事件的地点
    NSString    *_summary;             //事件的概述
    NSString    *_url;   //url
    BOOL        _isallDay;            //事件是否重复发生 YES即为在一段时间内重复发生 NO只发生一天
    NSDate      *_startCurDate;
    NSDate      *_endCurDate;
}

@property(nonatomic,copy)   NSString *calendarEventID;
@property(nonatomic,copy)   NSString *calendarID;
@property(nonatomic,copy)   NSString *eventdescription;
@property(nonatomic,copy)   NSString *enddate;
@property(nonatomic,copy)   NSString *startdate;
@property(nonatomic,copy)   NSString *location;
@property(nonatomic,copy)   NSString *summary;
@property(nonatomic,copy)   NSString *url;
@property(nonatomic,assign) BOOL isallDay;
@property(nonatomic,copy)   NSDate *startCurDate;
@property(nonatomic,copy)   NSDate *endCurDate;

- (NSString *)descriptionCSV;
- (NSString *)descriptionCSV1;

@end
