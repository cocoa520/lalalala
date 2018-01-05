//
//  IMBiCloudReminberEntity.m
//  AnyTrans
//
//  Created by m on 17/2/9.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBiCloudReminberEntity.h"

@implementation IMBiCloudReminberEntity
@synthesize guid = _guid;
@synthesize pGuid = _pGuid;
@synthesize etag = _etag;
@synthesize ctag = _ctag;
@synthesize lastModifiedDate  = _lastModifiedDate;
@synthesize createdDate = _createdDate;
@synthesize createdDateExtended = _createdDateExtended;
@synthesize priority = _priority;
@synthesize completedDate= _completedDate;
@synthesize order = _order;
@synthesize dueDate = _dueDate;
@synthesize dueDateIsAllDay = _dueDateIsAllDay;
@synthesize startDate = _startDate;
@synthesize startDateIsAllDay = _startDateIsAllDay;
@synthesize startDateTz = _startDateTz;
@synthesize recurrence = _recurrence;
@synthesize completedCount = _completedCount;
@synthesize alarms = _alarms;
- (id)init {
    if (self = [super init]) {
        _guid = @"";
        _pGuid = @"";
        _etag = @"";
        _ctag = @"";
        _lastModifiedDate = [[NSMutableArray alloc] init];
        _createdDate = [[NSMutableArray alloc] init];
        _priority = @"";
        _completedDate = [[NSMutableArray alloc] init];
        _order = @"";
        _dueDate = [[NSMutableArray alloc] init];
        _startDate = [[NSMutableArray alloc] init];
        _startDateTz = @"";
        _recurrence = [[RecurrenceModel alloc] init];
        _alarms = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_lastModifiedDate != nil) {
        [_lastModifiedDate release];
        _lastModifiedDate = nil;
    }
    if (_createdDate != nil) {
        [_createdDate release];
        _createdDate = nil;
    }
    if (_completedDate != nil) {
        [_completedDate release];
        _completedDate = nil;
    }
    if (_dueDate != nil) {
        [_dueDate release];
        _dueDate = nil;
    }
    if (_startDate != nil) {
        [_startDate release];
        _startDate = nil;
    }
    if (_alarms != nil) {
        [_alarms release];
        _alarms = nil;
    }
    if (_recurrence != nil) {
        [_recurrence release];
        _recurrence = nil;
    }
    [super dealloc];
}
@end


@implementation RecurrenceModel
@synthesize weekDays = _weekDays;
@synthesize freq = _freq;
@synthesize count = _count;
@synthesize interval = _interval;
@synthesize byDay = _byDay;
@synthesize byMonth = _byMonth;
@synthesize until = _until;
@synthesize frequencyDays = _frequencyDays;
@synthesize weekStart = _weekStart;
@synthesize alarm = _alarm;
- (id)init {
    if(self = [super init]) {
        _weekStart = @"";
        _freq = @"";
        _count = @"";
        _byDay = @"";
        _byMonth = @"";
        _until = [[NSMutableArray alloc] init];
        _frequencyDays = @"";
        _weekDays = [[NSMutableArray alloc] init];
        _alarm = [[AlarmsModel alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_until != nil) {
        [_until release];
        _until = nil;
    }
    if (_weekDays != nil) {
        [_weekDays release];
        _weekDays = nil;
    }
    if (_alarm != nil) {
        [_alarm release];
        _alarm = nil;
    }
    [super dealloc];
}
@end

@implementation AlarmsModel
@synthesize messageType = _messageType;
@synthesize onDate = _onDate;
@synthesize measurement = _measurement;
@synthesize description = _description;
@synthesize guid = _guid;
@synthesize isLocationBased = _isLocationBased;
@synthesize proximity = _proximity;
- (id)init {
    if (self = [super init]) {
        _messageType = @"";
        _onDate = [[NSMutableArray alloc] init];
        _measurement = @"";
        _description = @"";
        _guid = @"";
        _proximity = @"";
    }
    return self;
}

- (void)dealloc {
    if (_onDate != nil) {
        [_onDate release];
        _onDate = nil;
    }
    [super dealloc];
}
@end

@implementation RedminderDataModel
@synthesize title = _title;
@synthesize description = _description;
@synthesize pGuid = _pGuid;
@synthesize etag = _etag;
@synthesize order = _order;
@synthesize priority = _priority;
@synthesize recurrence = _recurrence;
@synthesize createdDateExtended = _createdDateExtended;
@synthesize guid = _guid;
@synthesize startDate = _startDate;
@synthesize startDateTz = _startDateTz;
@synthesize startDateIsAllDay = _startDateIsAllDay;
@synthesize completedDate = _completedDate;
@synthesize dueDate = _dueDate;
@synthesize dueDateIsAllDay = _dueDateIsAllDay;
@synthesize lastModifiedDate = _lastModifiedDate;
@synthesize createdDate = _createdDate;
@synthesize alarms = _alarms;
@synthesize groupTitle = _groupTitle;
- (id)init {
    if (self = [super init]) {
        _title = @"";
        _description = @"";
        _pGuid = @"";
        _etag = @"";
        _order = @"";
        _recurrence = @"";
        _guid = @"";
        _startDate = @"";
        _startDateTz = @"";
        _completedDate = @"";
        _dueDate = [[NSMutableArray alloc] init];
        _lastModifiedDate = @"";
        _createdDate = @"";
        _alarms = [[NSMutableArray alloc] init];
        _groupTitle = @"";
    }
    return self;
}

- (void)dealloc {
    if (_dueDate != nil) {
        [_dueDate release];
        _dueDate = nil;
    }
    if (_alarms != nil) {
        [_alarms release];
        _alarms = nil;
    }
    [super dealloc];
}
@end

@implementation CollectionData
@synthesize guid = _guid;
@synthesize ctag = _ctag;
- (id)init {
    if (self = [super init]) {
        _guid = @"";
        _ctag = @"";
    }
    return self;
}
@end


@implementation ClientStateModel
@synthesize Collections = _Collections;
- (id)init {
    if (self = [super init]) {
        _Collections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_Collections != nil) {
        [_Collections release];
        _Collections = nil;
    }
    [super dealloc];
}
@end

@implementation ReminderAddModel
@synthesize dataModel = _dataModel;
@synthesize stateModel= _stateModel;
- (id)init {
    if (self = [super init]) {
        _dataModel = [[RedminderDataModel alloc] init];
        _stateModel = [[ClientStateModel alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_dataModel != nil) {
        [_dataModel release];
        _dataModel = nil;
    }
    if (_stateModel != nil) {
        [_stateModel release];
        _stateModel = nil;
    }
    [super dealloc];
}
@end

@implementation ReminderEditModel
@synthesize creatDate = _creatDate;
@synthesize lastModifiedDate = _lastModifiedDate;
@synthesize order = _order;
@synthesize startDateTz = _startDateTz;
@synthesize createdDateExtended = _createdDateExtended;
@synthesize oldpGuid = _oldpGuid;
- (id)init {
    if (self = [super init]) {
        _creatDate = [[NSMutableArray alloc] init];
        _lastModifiedDate = [[NSMutableArray alloc] init];
        _startDateTz = @"";
        _oldpGuid = @"";
    }
    return self;
}

- (void)dealloc {
    if (_creatDate != nil) {
        [_creatDate release];
        _creatDate = nil;
    }
    if (_lastModifiedDate != nil) {
        [_lastModifiedDate release];
        _lastModifiedDate = nil;
    }
    [super dealloc];
}


@end














