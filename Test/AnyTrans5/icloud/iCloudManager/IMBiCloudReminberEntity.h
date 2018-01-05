//
//  IMBiCloudReminberEntity.h
//  AnyTrans
//
//  Created by m on 17/2/9.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBCalendarEventEntity.h"
@class RecurrenceModel;
@class AlarmsModel;

@interface IMBiCloudReminberEntity : IMBCalendarEventEntity
{
    NSString *_guid;
    NSString *_pGuid;
    NSString *_etag;
    NSString *_ctag;
    NSMutableArray *_lastModifiedDate;
    NSMutableArray *_createdDate;
    long long _createdDateExtended;
    NSString *_priority;
    NSMutableArray *_completedDate;
    NSString *_order;
    NSMutableArray *_dueDate;
    BOOL _dueDateIsAllDay;
    NSMutableArray *_startDate;
    BOOL _startDateIsAllDay;
    NSString *_startDateTz;
    RecurrenceModel *_recurrence;
    int _completedCount;
    NSMutableArray *_alarms;//里面是AlarmsModel
}
@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSString *pGuid;
@property (nonatomic, retain) NSString *etag;
@property (nonatomic, retain) NSString *ctag;
@property (nonatomic, retain) NSMutableArray *lastModifiedDate;
@property (nonatomic, retain) NSMutableArray *createdDate;
@property (nonatomic, assign) long long createdDateExtended;
@property (nonatomic, retain) NSString *priority;
@property (nonatomic, retain) NSMutableArray *completedDate;
@property (nonatomic, retain) NSString *order;
@property (nonatomic, retain) NSMutableArray *dueDate;
@property (nonatomic, assign) BOOL dueDateIsAllDay;
@property (nonatomic, retain) NSMutableArray *startDate;
@property (nonatomic, assign) BOOL startDateIsAllDay;
@property (nonatomic, retain) NSString *startDateTz;
@property (nonatomic, retain) RecurrenceModel *recurrence;
@property (nonatomic, assign) int completedCount;
@property (nonatomic, retain) NSMutableArray *alarms;
@end


@interface RecurrenceModel : NSObject
{
    NSString *_weekStart;
    NSString *_freq;
    NSString *_count;
    int _interval;
    NSString *_byDay;
    NSString *_byMonth;
    NSMutableArray *_until;//里面是int类型
    NSString *_frequencyDays;
    NSMutableArray *_weekDays;
    AlarmsModel *_alarm;
}
@property (nonatomic, retain) NSString *weekStart;
@property (nonatomic, retain) NSString *freq;
@property (nonatomic, retain) NSString *count;
@property (nonatomic, assign) int interval;
@property (nonatomic, retain) NSString *byDay;
@property (nonatomic, retain) NSString *byMonth;
@property (nonatomic, retain) NSMutableArray *until;
@property (nonatomic, retain) NSString *frequencyDays;
@property (nonatomic, retain) NSMutableArray *weekDays;
@property (nonatomic, retain) AlarmsModel *alarm;
@end




@interface AlarmsModel : NSObject {
    NSString *_messageType;
    NSMutableArray *_onDate;
    NSString *_measurement;
    NSString *_description;
    NSString *_guid;
    BOOL _isLocationBased;
    NSString *_proximity;
}
@property (nonatomic, retain) NSString *messageType;
@property (nonatomic, retain) NSMutableArray *onDate;
@property (nonatomic, retain) NSString *measurement;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *guid;
@property (nonatomic, assign) BOOL isLocationBased;
@property (nonatomic, retain) NSString *proximity;
@end

@interface RedminderDataModel : NSObject
{
    NSString *_title;
    NSString *_description;
    NSString *_pGuid;
    NSString *_etag;
    NSString *_order;
    int _priority;
    NSString *_recurrence;
    long _createdDateExtended;
    NSString *_guid;
    NSString *_startDate;
    NSString *_startDateTz;
    BOOL _startDateIsAllDay;
    NSString *_completedDate;
    NSMutableArray *_dueDate;//里面是int类型
    BOOL _dueDateIsAllDay;
    NSString *_lastModifiedDate;
    NSString *_createdDate;
    NSMutableArray *_alarms;//里面是AlarmsModel
    NSString *_groupTitle;
}
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *pGuid;
@property (nonatomic, retain) NSString *etag;
@property (nonatomic, retain) NSString *order;
@property (nonatomic, assign) int priority;
@property (nonatomic, retain) NSString *recurrence;
@property (nonatomic, assign) long createdDateExtended;
@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *startDateTz;
@property (nonatomic, assign) BOOL startDateIsAllDay;
@property (nonatomic, retain) NSString *completedDate;
@property (nonatomic, retain) NSMutableArray *dueDate;
@property (nonatomic, assign) BOOL dueDateIsAllDay;
@property (nonatomic, retain) NSString *lastModifiedDate;
@property (nonatomic, retain) NSString *createdDate;
@property (nonatomic, retain) NSMutableArray *alarms;
@property (nonatomic, retain) NSString *groupTitle;
@end

@interface CollectionData : NSObject {
    NSString *_guid;
    NSString *_ctag;
}
@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSString *ctag;
@end

@interface ClientStateModel : NSObject {
    NSMutableArray *_Collections;//里面是CollectionData
}
@property (nonatomic, retain) NSMutableArray *Collections;

@end

@interface ReminderAddModel : IMBCalendarEventEntity {
    RedminderDataModel *_dataModel;
    ClientStateModel *_stateModel;
}
@property (nonatomic, retain) RedminderDataModel *dataModel;
@property (nonatomic, retain) ClientStateModel *stateModel;
@end

@interface ReminderEditModel : ReminderAddModel
{
    NSMutableArray *_creatDate;
    NSMutableArray *_lastModifiedDate;
    long long _order;
    NSString *_startDateTz;
    long long _createdDateExtended;
    NSString *_oldpGuid;
}
@property (nonatomic, retain) NSMutableArray *creatDate;
@property (nonatomic, retain) NSMutableArray *lastModifiedDate;
@property (nonatomic, assign) long long order;
@property (nonatomic, retain) NSString *startDateTz;
@property (nonatomic, assign) long long createdDateExtended;
@property (nonatomic, retain) NSString *oldpGuid;
@end



