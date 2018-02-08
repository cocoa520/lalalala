//
//  IMBCalAndRemEntity.m
//  PhoneRescue
//
//  Created by iMobie on 3/23/16.
//  Copyright (c) 2016 iMobie Inc. All rights reserved.
//

#import "IMBCalAndRemEntity.h"

@implementation IMBCalAndRemEntity
@synthesize rowid = _rowid;
@synthesize allDay = _allDay;
@synthesize calendarID = _calendarID;
@synthesize description = _description;
@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize url = _url;
@synthesize location = _location;
@synthesize summary = _summary;
@synthesize entityType = _entityType;
@synthesize completionDate = _completionDate;

@synthesize participation_status_modified_date = _participation_status_modified_date;
@synthesize phantom_master = _phantom_master;
@synthesize start_location_id = _start_location_id;
@synthesize calendar_scale = _calendar_scale;
@synthesize travel_advisory_behavior = _travel_advisory_behavior;
@synthesize invitation_changed_properties = _invitation_changed_properties;
@synthesize travel_time = _travel_time;
@synthesize location_id = _location_id;
@synthesize start_tz = _start_tz;
@synthesize all_day = _all_day;
@synthesize orig_item_id = _orig_item_id;
@synthesize organizer_id = _organizer_id;
@synthesize self_attendee_id = _self_attendee_id;
@synthesize status = _status;
@synthesize invitation_status = _invitation_status;
@synthesize availability = _availability;
@synthesize privacy_level = _privacy_level;
@synthesize orig_date = _orig_date;
@synthesize last_modified = _last_modified;
@synthesize sequence_num = _sequence_num;
@synthesize birthday_id = _birthday_id;
@synthesize modified_properties = _modified_properties;
@synthesize external_tracking_status = _external_tracking_status;
@synthesize external_id = _external_id;
@synthesize external_mod_tag = _external_mod_tag;
@synthesize external_schedule_id = _external_schedule_id;
@synthesize external_rep = _external_rep;
@synthesize response_comment = _response_comment;
@synthesize hidden = _hidden;
@synthesize has_attendees = _has_attendees;
@synthesize has_recurrences = _has_recurrences;
@synthesize uuid = _uuid;
@synthesize entity_type = _entity_type;
@synthesize priority = _priority;
@synthesize due_date = _due_date;
@synthesize due_tz = _due_tz;
@synthesize due_all_day = _due_all_day;
@synthesize creation_date = _creation_date;
@synthesize conference = _conference;
@synthesize display_order = _display_order;
@synthesize created_by_id = _created_by_id;
@synthesize modified_by_id = _modified_by_id;
@synthesize shared_item_created_date = _shared_item_created_date;
@synthesize shared_item_created_tz = _shared_item_created_tz;
@synthesize shared_item_modified_tz = _shared_item_modified_tz;
@synthesize shared_item_modified_date = _shared_item_modified_date;
@synthesize unique_identifier = _unique_identifier;
@synthesize default_alarm_removed = _default_alarm_removed;
@synthesize occurrDay = _occurrDay;


- (id)init
{
    self = [super init];
    if (self) {
        _description = @"";
        _url = @"";
        _location = @"";
        _summary = @"";
        
        _startTime = 0.0;
        _endTime = 0.0;
        _completionDate = 0.0;
        
        _location_id = 0;
        _allDay = 0;
        _calendarID = 2;
        _orig_item_id = 0;
        _organizer_id = 0;
        _self_attendee_id = 0;
        _status = 0;
        _invitation_status = 0;
        _availability = 0;
        _privacy_level = 0;
        _sequence_num = 0;
        _birthday_id = -1;
        _modified_properties = 12;
        _external_tracking_status = 0;
        _hidden = 0;
        _has_recurrences = 0;
        _entityType = 2;
        _priority = 0;
        _due_all_day = 0;
        _created_by_id = -1;
        _modified_by_id = -1;
        _invitation_changed_properties = 0;
        _default_alarm_removed = 0;
        _phantom_master = 0;
        _has_attendees = 0;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
