//
//  IMBiCloudCalendarEventEntity.m
//  AnyTrans
//
//  Created by iMobie on 2/6/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBiCloudCalendarEventEntity.h"
#import "IMBiCloudManager.h"
@implementation IMBiCloudCalendarEventEntity
@synthesize guid = _guid;
@synthesize pGuid = _pGuid;
@synthesize eventStatus = _eventStatus;
@synthesize etag = _etag;
@synthesize duration = _duration;
@synthesize isComplete = _isComplete;
//Reminder
@synthesize completeTime = _completeTime;
@synthesize createdTime = _createdTime;
@synthesize createdDateExtended = _createdDateExtended;
@synthesize dueTime = _dueTime;
@synthesize dueDateIsAllDay = _dueDateIsAllDay;
@synthesize lastModifiedTime = _lastModifiedTime;
@synthesize order = _order;
@synthesize priority = _priority;
@synthesize startTime = _startTime;
@synthesize startDateIsAllDay = _startDateIsAllDay;
@synthesize startDateTz = _startDateTz;
//recurrence
@synthesize  byDay = _byDay;
@synthesize  byMonth = _byMonth;
@synthesize  count = _count;
@synthesize  freq = _freq;
@synthesize  frequencyDays = _frequencyDays;
@synthesize  interval = _interval;
@synthesize  until = _until;
@synthesize  weekDays = _weekDays;
@synthesize  weekStart = _weekStart;
//calendar
@synthesize extendedDetailsAreIncluded = _extendedDetailsAreIncluded;
@synthesize hasAttachments = _hasAttachments;
@synthesize icon = _icon;
@synthesize readOnly = _readOnly;
@synthesize recurrenceException = _recurrenceException;
@synthesize recurrenceMaster =  _recurrenceMaster;
@synthesize shouldShowJunkUIWhenAppropriate = _shouldShowJunkUIWhenAppropriate;
@synthesize tz = _tz;
@synthesize endCalTime = _endCalTime;
@synthesize startCalTime = _startCalTime;
@synthesize localEndTime = _localEndTime;
@synthesize localStartTime = _loaclStartTime;
@synthesize recurrence = _recurrence;
@synthesize alarm = _alarm;
@synthesize invitees = _invitees;
@synthesize Recurrences = _Recurrences;
@synthesize Invitee = _Invitee;
@synthesize Alarms = _Alarms;
@synthesize addDetailContent = _addDetailContent;
@synthesize icloudManager = _icloudManager;
@synthesize createDate = _createDate;
@synthesize dueDate = _dueDate;
@synthesize groupTitle = _groupTitle;
- (id)init {
    if (self = [super init]) {
        _guid = @"";
        _pGuid = @"";
        _eventStatus = @"";
        _etag = @"";
        _duration = 0;
        _isComplete = NO;
        _completeTime = 0;
        _createdTime = 0;
        _createdDateExtended = 0;
        _dueTime = 0;
        _dueDateIsAllDay = NO;
        _lastModifiedTime = 0;
        _order = 0;
        _priority = 0;
        _startTime = 0;
        _startDateIsAllDay = NO;
        _startDateTz = @"";
        _byDay = @"";
        _byMonth = @"";
        _count = @"";
        _freq = @"";
        _frequencyDays = @"";
        _interval = @"";
        _until = @"";
        _weekDays = @"";
        _weekStart = @"";
        _extendedDetailsAreIncluded = 0;
        _hasAttachments = NO;
        _icon = 0;
        _readOnly = 0;
        _recurrenceException = 0;
        _recurrenceMaster = 0;
        _shouldShowJunkUIWhenAppropriate = 0;
        _tz = @"";
        _endCalTime = 0;
        _startCalTime = 0;
        _loaclStartTime = 0;
        _localEndTime = 0;
        _recurrence = @"";
        _createDate = [[NSMutableArray alloc] init];
        _dueDate = [[NSMutableArray alloc] init];
        _groupTitle = @"";
    }
    return self;
}

- (void)loadDetailContent
{
    [_icloudManager loadCalendarDetailContent:self];
}

- (void)dealloc
{
    [_dueDate release], _dueDate = nil;
    [_createDate release], _createDate = nil;
    [_recurrence release],_recurrence = nil;
    [_alarm release],_alarm = nil;
    [_invitees release],_invitees = nil;
    [_Recurrences release],_Recurrences = nil;
    [_Invitee release],_Invitee = nil;
    [_Alarms release],_Alarms = nil;
    
    [super dealloc];
}


@end

@implementation IMBiCloudCalendarCollectionEntity
@synthesize guid = _guid;
@synthesize title = _title;
@synthesize ctag = _ctag;
@synthesize modifiedDateStr = _modifiedDateStr;
@synthesize createdDataStr = _createdDataStr;
@synthesize description = _description;
@synthesize tag = _tag;
@synthesize order = _order;
@synthesize color = _color;
@synthesize symbolicColor = _symbolicColor;
@synthesize enabled = _enabled;
@synthesize emailNotification = _emailNotification;
@synthesize createdDate = _createdDate;
@synthesize isFamily = _isFamily;
@synthesize collectionShareType = _collectionShareType;
@synthesize createdDateExtended = _createdDateExtended;
@synthesize completedCount = _completedCount;
@synthesize participants = _participants;
@synthesize subArray = _subArray;

- (id)init {
    if (self = [super init]) {
        _guid = @"";
        _title = @"";
        _ctag = @"";
        _modifiedDateStr = @"";
        _createdDataStr = @"";
        _description = @"";
        _color = @"";
        _symbolicColor = @"";
        _emailNotification = @"";
        _createdDate = [[NSMutableArray alloc] init];
        _collectionShareType = @"";
        _createdDateExtended = @"";
        _participants = [[NSMutableArray alloc] init];
        _subArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    if (_createdDate != nil) {
        [_createdDate release];
        _createdDate = nil;
    }
    if (_participants != nil) {
        [_participants release];
        _participants = nil;
    }
    if (_subArray != nil) {
        [_subArray release];
         _subArray = nil;
    }
    
    [super dealloc];
}

@end

@implementation ParticipantModel
@synthesize isMe = _isMe;
@synthesize commonName = _commonName;
@synthesize status = _status;
@synthesize email = _email;
@synthesize dsid = _dsid;
@synthesize participantShareType = _participantShareType;
- (id)init {
    if (self = [super init]) {
        _commonName = @"";
        _status = @"";
        _email = @"";
        _dsid = @"";
        _participantShareType = @"";
    }
    return self;
}

@end;




