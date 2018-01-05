//
//  IMBCalendars.m
//  iMobieTrans
//
//  Created by iMobie on 14-2-20.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBCalendarEventEntity.h"

@implementation IMBCalendarEventEntity

@synthesize calendarEventID = _calendarEventID;
@synthesize calendarID      = _calendarID;
@synthesize eventdescription     = _eventdescription;
@synthesize enddate         = _enddate;
@synthesize startdate       = _startdate;
@synthesize location        = _location;
@synthesize summary         = _summary;
@synthesize url             = _url;
@synthesize isallDay        = _isallDay;
@synthesize startCurDate    = _startCurDate;
@synthesize endCurDate      = _endCurDate;
//将对象与字典建立一个对应关系
- (NSDictionary *)attributeMapDictionary
{
    NSDictionary *mapAtt = @{
                             @"eventdescription":@"description",
                             @"location":@"location",
                             @"summary":@"summary",
                             @"url":@"url",
                          };
    return mapAtt;
}

- (NSString *)description
{
     return [NSString stringWithFormat:@"**************************\ntitle:%@\nhome:%@\nstartDate:%@\nendDate:%@\nurl:%@\nNotes:%@\n**************************\n",_summary,_location,_startdate,_enddate,_url,_eventdescription];
}

- (NSString *)descriptionCSV {
    return [NSString stringWithFormat:@"title,home,startDate,endDate,url,Notes\n%@,%@,%@,%@,%@,%@\n",_summary,_location,_startdate,_enddate,_url,_eventdescription];
}

- (NSString *)descriptionCSV1 {
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@\n",_summary,_location,_startdate,_enddate,_url,_eventdescription];
}

-(void)dealloc
{
    [_calendarEventID release];
    [_calendarID      release];
    [_eventdescription release];
    [_enddate release];
    [_startdate release];
    [_location release];
    [_summary release];
    [_url release];
    [_startCurDate release];
    [_endCurDate release];
    
    
    [super dealloc];
}
@end
