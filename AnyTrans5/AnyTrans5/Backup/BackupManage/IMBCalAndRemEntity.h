//
//  IMBCalAndRemEntity.h
//  PhoneRescue
//
//  Created by iMobie on 3/23/16.
//  Copyright (c) 2016 iMobie Inc. All rights reserved.
//

#import "IMBBaseEntity.h"

@interface IMBCalAndRemEntity : IMBBaseEntity {
@private
    int _rowid;
    NSString *_summary;
    NSString *_description;
    NSString *_location;
    NSString *_url;
    double _startTime;
    double _endTime;
    int _allDay;//判断是否整天
    int _calendarID;
    int _entityType;//判断是否是提醒（==3就是提醒）
    double _completionDate;//判断是否完成
    
    
    int _location_id;//0
    NSString *_start_tz;
    int _all_day;//0
    int _orig_item_id;//0
    int _organizer_id;//0
    int _self_attendee_id;//0
    int _status;//0
    int _invitation_status;//0
    int _availability;//0
    int _privacy_level;//0
    double _orig_date;
    double _last_modified;
    int _sequence_num;//0
    int _birthday_id;//-1
    int _modified_properties;//12
    int _external_tracking_status;//0
    NSString *_external_id; //null
    int _external_mod_tag; //null
    NSString *_unique_identifier;//uuid
    int _external_schedule_id;//null
    NSData *_external_rep;//null
    NSString *_response_comment;//null
    int _hidden;//0
    int _has_recurrences;//0
    int _has_attendees;//0
    NSString *_uuid;
    int _entity_type;//2
    int _priority;//0
    double _due_date;
    NSString *_due_tz;//null
    int _due_all_day;//0
    double _creation_date;//时间
    NSString *_conference;//null
    double _display_order;//480968252
    int _created_by_id;//-1
    int _modified_by_id;//-1
    double _shared_item_created_date;//null
    NSString *_shared_item_created_tz;//null
    double _shared_item_modified_date;//null
    NSString *_shared_item_modified_tz;//null
    int _invitation_changed_properties;//0
    int _default_alarm_removed;//0
    int _phantom_master;//0
    double _participation_status_modified_date;//null
    NSString *_calendar_scale;//null
    int _travel_time;
    int _travel_advisory_behavior;//0
    int _start_location_id;//0
    
    double _occurrDay; //一天的开始时间

}

@property (nonatomic, assign) double occurrDay;
@property (nonatomic, assign) int location_id;
@property (nonatomic, assign) NSString *start_tz;
@property (nonatomic, assign) int all_day;
@property (nonatomic, assign) int orig_item_id;
@property (nonatomic, assign) int organizer_id;
@property (nonatomic, assign) int self_attendee_id;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int invitation_status;
@property (nonatomic, assign) int availability;
@property (nonatomic, assign) int privacy_level;
@property (nonatomic, assign) double orig_date;
@property (nonatomic, assign) double last_modified;
@property (nonatomic, assign) int sequence_num;
@property (nonatomic, assign) int birthday_id;
@property (nonatomic, assign) int modified_properties;
@property (nonatomic, assign) int external_tracking_status;
@property (nonatomic, retain) NSString *external_id;
@property (nonatomic, assign) int external_mod_tag;
@property (nonatomic, retain) NSString *unique_identifier;
@property (nonatomic, assign) int external_schedule_id;
@property (nonatomic, retain) NSData *external_rep;
@property (nonatomic, retain) NSString *response_comment;
@property (nonatomic, assign) int hidden;
@property (nonatomic, assign) int has_recurrences;
@property (nonatomic, assign) int has_attendees;
@property (nonatomic, retain) NSString *uuid;
@property (nonatomic, assign) int entity_type;
@property (nonatomic, assign) int priority;
@property (nonatomic, assign) double due_date;
@property (nonatomic, retain) NSString *due_tz;
@property (nonatomic, assign) int due_all_day;
@property (nonatomic, assign) double creation_date;
@property (nonatomic, retain) NSString *conference;
@property (nonatomic, assign) double display_order;
@property (nonatomic, assign) int created_by_id;
@property (nonatomic, assign) int modified_by_id;
@property (nonatomic, assign) double shared_item_created_date;
@property (nonatomic, retain) NSString *shared_item_created_tz;
@property (nonatomic, assign) double shared_item_modified_date;
@property (nonatomic, retain) NSString *shared_item_modified_tz;
@property (nonatomic, assign) int invitation_changed_properties;
@property (nonatomic, assign) int default_alarm_removed;
@property (nonatomic, assign) int phantom_master;
@property (nonatomic, assign) double participation_status_modified_date;
@property (nonatomic, retain) NSString *calendar_scale;
@property (nonatomic, assign) int travel_time;
@property (nonatomic, assign) int travel_advisory_behavior;
@property (nonatomic, assign) int start_location_id;


@property (nonatomic, readwrite) int rowid;
@property (nonatomic, readwrite) int allDay;
@property (nonatomic, readwrite) int calendarID;
@property (nonatomic, readwrite) double startTime;
@property (nonatomic, readwrite) double endTime;
@property (nonatomic, readwrite, retain) NSString *summary;
@property (nonatomic, readwrite, retain) NSString *description;
@property (nonatomic, readwrite, retain) NSString *location;
@property (nonatomic, readwrite, retain) NSString *url;
@property (nonatomic, readwrite) int entityType;
@property (nonatomic, readwrite) double completionDate;

@end
