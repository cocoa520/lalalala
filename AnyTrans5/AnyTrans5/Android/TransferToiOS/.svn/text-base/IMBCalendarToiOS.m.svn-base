//
//  IMBCalendarToiOS.m
//  AnyTrans
//
//  Created by LuoLei on 2017-07-04.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBCalendarToiOS.h"
#import "IMBCalAndRemEntity.h"
@implementation IMBCalendarToiOS

- (void)setsourceBackupPath:(NSString *)sourceBackupPath desBackupPath:(NSString *)desBackupPath sourcerecordArray:(NSMutableArray *)sourcerecordArray targetrecordArray:(NSMutableArray *)targetrecordArray
{
    [super setsourceBackupPath:sourceBackupPath desBackupPath:desBackupPath sourcerecordArray:sourcerecordArray targetrecordArray:targetrecordArray];
    _sourceBackuppath = [sourceBackupPath retain];
    _targetBakcuppath = [desBackupPath retain];
    {
        sourceRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/Calendar/Calendar.sqlitedb" recordArray:_sourcerecordArray] retain];
        NSString *rstr = [sourceRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,sourceRecord.key];
        sourceRecord.relativePath = relativePath;
        _sourceSqlitePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"sourceSqlite"] fileRecord:sourceRecord backupfilePath:sourceBackupPath] retain];
    }
    {
        targetRecord = [[self getDBFileRecord:@"HomeDomain" path:@"Library/Calendar/Calendar.sqlitedb" recordArray:_targetrecordArray] retain];
        NSString *rstr = [targetRecord.key substringWithRange:NSMakeRange(0, 2)];
        NSString *relativePath = [NSString stringWithFormat:@"%@/%@",rstr,targetRecord.key];
        targetRecord.relativePath = relativePath;
        _targetSqlitePath = [[self copyIMBMBFileRecordTodesignatedPath:[[TempHelper getAppTempPath] stringByAppendingPathComponent:@"targetSqlite"] fileRecord:targetRecord backupfilePath:desBackupPath] retain];
    }
}

- (void)merge:(NSArray *)dataArray
{
    @try {
        if ([self openDataBase:_targetDBConnection]) {
            [_targetDBConnection beginTransaction];
            for (IMBCalAndRemEntity *entity in dataArray) {
                [self insertToCalendarItemRecords:entity withTargetFmdb:_targetDBConnection  isReminder:NO];
            }
            if (![_targetDBConnection commit]){
                [_targetDBConnection rollback];
            }
            [self closeDataBase:_targetDBConnection];
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"----Error----:Merge IMBCalendarToiOS error:%@", exception]];
    }
    @finally {
    }
    [self modifyHashAndManifest];
}


- (void)insertToCalendarItemRecords:(IMBCalAndRemEntity *)item withTargetFmdb:(FMDatabase *)targetFMDB   isReminder:(BOOL)isReminder {
    
    NSString *IOS11InsertStr = @"insert into CalendarItem (summary,location_id, description, start_date, start_tz, end_date, all_day, calendar_id, orig_item_id, orig_date, organizer_id, self_attendee_id, status, invitation_status, availability, privacy_level, url, last_modified, sequence_num, birthday_id, modified_properties, external_tracking_status, external_id, external_mod_tag, unique_identifier, external_schedule_id, external_rep, response_comment, hidden, has_recurrences, has_attendees, UUID, entity_type, priority, due_date, due_tz, due_all_day, completion_date, creation_date, display_order, created_by_id, modified_by_id, shared_item_created_date, shared_item_created_tz, shared_item_modified_date, shared_item_modified_tz, invitation_changed_properties, default_alarm_removed, phantom_master, participation_status_modified_date, calendar_scale, travel_time, travel_advisory_behavior, start_location_id,suggested_event_info_id,can_forward,location_prediction_state,fired_ttl,disallow_propose_new_time,junk_status) values(:summary, :location_id, :description, :start_date, :start_tz, :end_date, :all_day, :calendar_id, :orig_item_id, :orig_date, :organizer_id, :self_attendee_id, :status, :invitation_status, :availability, :privacy_level, :url, :last_modified, :sequence_num, :birthday_id, :modified_properties, :external_tracking_status, :external_id, :external_mod_tag, :unique_identifier, :external_schedule_id, :external_rep, :response_comment, :hidden, :has_recurrences, :has_attendees, :UUID, :entity_type, :priority, :due_date, :due_tz, :due_all_day, :completion_date, :creation_date, :display_order, :created_by_id, :modified_by_id, :shared_item_created_date, :shared_item_created_tz, :shared_item_modified_date, :shared_item_modified_tz, :invitation_changed_properties, :default_alarm_removed, :phantom_master, :participation_status_modified_date, :calendar_scale, :travel_time, :travel_advisory_behavior, :start_location_id, :suggested_event_info_id, :can_forward, :location_prediction_state, :fired_ttl, :disallow_propose_new_time, :junk_status)";
    
    NSString *IOS8InsertStr = @"insert into CalendarItem (summary,location_id, description, start_date, start_tz, end_date, all_day, calendar_id, orig_item_id, orig_date, organizer_id, self_attendee_id, status, invitation_status, availability, privacy_level, url, last_modified, sequence_num, birthday_id, modified_properties, external_tracking_status, external_id, external_mod_tag, unique_identifier, external_schedule_id, external_rep, response_comment, hidden, has_recurrences, has_attendees, UUID, entity_type, priority, due_date, due_tz, due_all_day, completion_date, creation_date, conference, display_order, created_by_id, modified_by_id, shared_item_created_date, shared_item_created_tz, shared_item_modified_date, shared_item_modified_tz, invitation_changed_properties, default_alarm_removed, phantom_master, participation_status_modified_date, calendar_scale, travel_time, travel_advisory_behavior, start_location_id) values(:summary, :location_id, :description, :start_date, :start_tz, :end_date, :all_day, :calendar_id, :orig_item_id, :orig_date, :organizer_id, :self_attendee_id, :status, :invitation_status, :availability, :privacy_level, :url, :last_modified, :sequence_num, :birthday_id, :modified_properties, :external_tracking_status, :external_id, :external_mod_tag, :unique_identifier, :external_schedule_id, :external_rep, :response_comment, :hidden, :has_recurrences, :has_attendees, :UUID, :entity_type, :priority, :due_date, :due_tz, :due_all_day, :completion_date, :creation_date, :conference, :display_order, :created_by_id, :modified_by_id, :shared_item_created_date, :shared_item_created_tz, :shared_item_modified_date, :shared_item_modified_tz, :invitation_changed_properties, :default_alarm_removed, :phantom_master, :participation_status_modified_date, :calendar_scale, :travel_time, :travel_advisory_behavior, :start_location_id)";
    NSString *IOS7InsertStr = @"insert into CalendarItem (summary, location_id, description, start_date, start_tz, end_date, all_day, calendar_id, orig_item_id, orig_date, organizer_id, self_attendee_id, status, invitation_status, availability, privacy_level, url, last_modified, sequence_num, birthday_id, modified_properties, external_tracking_status, external_id, external_mod_tag, unique_identifier, external_schedule_id, external_rep, response_comment, hidden, has_recurrences, has_attendees, UUID, entity_type, priority, due_date, due_tz, due_all_day, completion_date, creation_date, conference, display_order, created_by_id, modified_by_id, shared_item_created_date, shared_item_created_tz, shared_item_modified_date, shared_item_modified_tz, invitation_changed_properties, default_alarm_removed, phantom_master, participation_status_modified_date) values( :summary, :location_id, :description, :start_date, :start_tz, :end_date, :all_day, :calendar_id, :orig_item_id, :orig_date, :organizer_id, :self_attendee_id, :status, :invitation_status, :availability, :privacy_level, :url, :last_modified, :sequence_num, :birthday_id, :modified_properties, :external_tracking_status, :external_id, :external_mod_tag, :unique_identifier, :external_schedule_id, :external_rep, :response_comment, :hidden, :has_recurrences, :has_attendees, :UUID, :entity_type, :priority, :due_date, :due_tz, :due_all_day, :completion_date, :creation_date, :conference, :display_order, :created_by_id, :modified_by_id, :shared_item_created_date, :shared_item_created_tz, :shared_item_modified_date, :shared_item_modified_tz, :invitation_changed_properties, :default_alarm_removed, :phantom_master, :participation_status_modified_date)";
    
    NSString *IOS6InsertStr = @"insert into CalendarItem ( summary, location_id, description, start_date, start_tz, end_date, all_day, calendar_id, orig_item_id, orig_date, organizer_id, self_attendee_id, status, invitation_status, availability, privacy_level, url, last_modified, sequence_num, birthday_id, modified_properties, external_tracking_status, external_id, external_mod_tag, unique_identifier, external_schedule_id, external_rep, response_comment, hidden, has_recurrences, has_attendees, UUID, entity_type, priority, due_date, due_tz, due_all_day, completion_date, creation_date, conference, display_order, created_by_id, modified_by_id, shared_item_created_date, shared_item_created_tz, shared_item_modified_date, shared_item_modified_tz, invitation_changed_properties, default_alarm_removed, phantom_master) values( :summary, :location_id, :description, :start_date, :start_tz, :end_date, :all_day, :calendar_id, :orig_item_id, :orig_date, :organizer_id, :self_attendee_id, :status, :invitation_status, :availability, :privacy_level, :url, :last_modified, :sequence_num, :birthday_id, :modified_properties, :external_tracking_status, :external_id, :external_mod_tag, :unique_identifier, :external_schedule_id, :external_rep, :response_comment, :hidden, :has_recurrences, :has_attendees, :UUID, :entity_type, :priority, :due_date, :due_tz, :due_all_day, :completion_date, :creation_date, :conference, :display_order, :created_by_id, :modified_by_id, :shared_item_created_date, :shared_item_created_tz, :shared_item_modified_date, :shared_item_modified_tz, :invitation_changed_properties, :default_alarm_removed, :phantom_master)";
    NSString *IOS5InsertStr = @"insert into CalendarItem ( summary, location_id, description, start_date, start_tz, end_date, all_day, calendar_id, orig_item_id, orig_date, organizer_id, self_attendee_id, status, invitation_status, availability, privacy_level, url, last_modified, sequence_num, birthday_id, modified_properties, external_tracking_status, external_id, external_mod_tag, unique_identifier, external_schedule_id, external_rep, response_comment, hidden, has_recurrences, has_attendees, UUID, entity_type, priority, due_date, due_tz, due_all_day, completion_date, creation_date, conference) values( :summary, :location_id, :description, :start_date, :start_tz, :end_date, :all_day, :calendar_id, :orig_item_id, :orig_date, :organizer_id, :self_attendee_id, :status, :invitation_status, :availability, :privacy_level, :url, :last_modified, :sequence_num, :birthday_id, :modified_properties, :external_tracking_status, :external_id, :external_mod_tag, :unique_identifier, :external_schedule_id, :external_rep, :response_comment, :hidden, :has_recurrences, :has_attendees, :UUID, :entity_type, :priority, :due_date, :due_tz, :due_all_day, :completion_date, :creation_date, :conference)";
    int targetNum = (int)_targetVersion;
    NSString *insertStr = @"";
    if (targetNum>=11) {
        insertStr = IOS11InsertStr;
    }else if (targetNum >= 8) {
        insertStr = IOS8InsertStr;
    }else if (targetNum == 7) {
        insertStr = IOS7InsertStr;
    }else if (targetNum == 6) {
        insertStr = IOS6InsertStr;
    }else if (targetNum == 5) {
        insertStr = IOS5InsertStr;
    }
    NSMutableDictionary *parmaDic = [[NSMutableDictionary alloc] init];
    [parmaDic setObject:item.summary?:@"" forKey:@"summary"];
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"location_id"];
    [parmaDic setObject:item.description?:@"" forKey:@"description"];
    [parmaDic setObject:[NSNumber numberWithDouble:item.startTime] forKey:@"start_date"];
    [parmaDic setObject:[NSNumber numberWithDouble:item.endTime] forKey:@"end_date"];
    [parmaDic setObject:item.start_tz?:@"" forKey:@"start_tz"];
    [parmaDic setObject:[NSNumber numberWithInt:item.allDay] forKey:@"all_day"];
    if (isReminder) {
        [parmaDic setObject:@([self getDefaultRedminderID:targetFMDB]) forKey:@"calendar_id"];
    }else{
        [parmaDic setObject:@([self getDefaultCalenderID:targetFMDB]) forKey:@"calendar_id"];
    }
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"orig_item_id"];
    [parmaDic setObject:[NSNull null] forKey:@"orig_date"];
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"organizer_id"];
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"self_attendee_id"];
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"status"];
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"invitation_status"];
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"availability"];
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"privacy_level"];
    [parmaDic setObject:item.url?:@"" forKey:@"url"];
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"orig_item_id"];
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    [parmaDic setObject:[NSNumber numberWithDouble:time] forKey:@"last_modified"];
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"sequence_num"];
    [parmaDic setObject:[NSNumber numberWithInt:-1] forKey:@"birthday_id"];
    [parmaDic setObject:[NSNumber numberWithInt:12] forKey:@"modified_properties"];
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"external_tracking_status"];
    [parmaDic setObject:[NSNull null] forKey:@"external_id"];
    [parmaDic setObject:[NSNull null] forKey:@"external_mod_tag"];
    NSString *uniqueIdentifier = [self createGUID];
    [parmaDic setObject:uniqueIdentifier forKey:@"unique_identifier"];
    [parmaDic setObject:[NSNull null] forKey:@"external_schedule_id"];
    [parmaDic setObject:[NSNull null] forKey:@"external_rep"];
    [parmaDic setObject:[NSNull null] forKey:@"response_comment"];
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"hidden"];
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"has_recurrences"];
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"has_attendees"];
    NSString *uuidStr = [self createGUID];
    [parmaDic setObject:uuidStr forKey:@"UUID"];
    if (isReminder) {
        [parmaDic setObject:[NSNumber numberWithInt:3] forKey:@"entity_type"];
    }else{
        [parmaDic setObject:[NSNumber numberWithInt:2] forKey:@"entity_type"];
    }
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"priority"];
    [parmaDic setObject:[NSNull null] forKey:@"due_date"];
    [parmaDic setObject:[NSNull null] forKey:@"due_tz"];
    [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"due_all_day"];
    [parmaDic setObject:[NSNull null] forKey:@"completion_date"];
    [parmaDic setObject:[NSNumber numberWithDouble:time] forKey:@"creation_date"];
    if (targetNum<11) {
        [parmaDic setObject:[NSNull null] forKey:@"conference"];
    }else{
        [parmaDic setObject:@(0) forKey:@"suggested_event_info_id"];
        [parmaDic setObject:@(1) forKey:@"can_forward"];
        [parmaDic setObject:@(0) forKey:@"location_prediction_state"];
        [parmaDic setObject:@(0) forKey:@"fired_ttl"];
        [parmaDic setObject:@(0) forKey:@"disallow_propose_new_time"];
        [parmaDic setObject:@(0) forKey:@"junk_status"];
    }
    if (targetNum >= 6) {
        [parmaDic setObject:[NSNumber numberWithDouble:time] forKey:@"display_order"];
        [parmaDic setObject:[NSNumber numberWithInt:-1] forKey:@"created_by_id"];
        [parmaDic setObject:[NSNumber numberWithInt:-1] forKey:@"modified_by_id"];
        [parmaDic setObject:[NSNull null] forKey:@"shared_item_created_date"];
        [parmaDic setObject:[NSNull null] forKey:@"shared_item_created_tz"];
        [parmaDic setObject:[NSNull null] forKey:@"shared_item_modified_date"];
        [parmaDic setObject:[NSNull null] forKey:@"shared_item_modified_tz"];
        [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"invitation_changed_properties"];
        if (targetNum>=11) {
            [parmaDic setObject:[NSNumber numberWithInt:1] forKey:@"default_alarm_removed"];
        }else{
            [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"default_alarm_removed"];
        }
        [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"phantom_master"];
    }
    if (targetNum >= 7) {
        [parmaDic setObject:[NSNull null] forKey:@"participation_status_modified_date"];
        if (targetNum >= 8) {
            [parmaDic setObject:[NSNull null] forKey:@"calendar_scale"];
            [parmaDic setObject:[NSNull null] forKey:@"travel_time"];
            [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"travel_advisory_behavior"];
            [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"start_location_id"];
        }
    }
    BOOL result = [targetFMDB executeUpdate:insertStr withParameterDictionary:parmaDic];
    [parmaDic release];
    parmaDic = nil;
    if (result) {
        _succesCount += 1;
        NSString *sql3 = @"select last_insert_rowid() from CalendarItem";
        FMResultSet *rs1 = [targetFMDB executeQuery:sql3];
        int calendarItemID = -1;
        while ([rs1 next]) {
            calendarItemID = [[rs1 objectForColumnName:@"last_insert_rowid()"] intValue];
            
        }
        [rs1 close];
        if (calendarItemID != -1) {
            NSString *changeStr = @"insert into CalendarItemChanges(record,type,calendar_id,unique_identifier,uuid,entity_type,store_id,has_dirty_instance_attributes,old_calendar_id) values(:record,:type,:calendar_id,:unique_identifier,:uuid,:entity_type,:store_id,:has_dirty_instance_attributes,:old_calendar_id)";
            parmaDic = [[NSMutableDictionary alloc] init];
            [parmaDic setObject:[NSNumber numberWithInt:calendarItemID] forKey:@"record"];
            [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"type"];
            [parmaDic setObject:[NSNumber numberWithInt:[self getDefaultCalenderID:targetFMDB]] forKey:@"calendar_id"];
            [parmaDic setObject:uniqueIdentifier forKey:@"unique_identifier"];
            [parmaDic setObject:uuidStr forKey:@"uuid"];
            [parmaDic setObject:[NSNumber numberWithInt:2] forKey:@"entity_type"];
            [parmaDic setObject:[NSNumber numberWithInt:[self getDefaultStoreID:targetFMDB]] forKey:@"store_id"];
            [parmaDic setObject:[NSNumber numberWithInt:1] forKey:@"has_dirty_instance_attributes"];
            [parmaDic setObject:[NSNumber numberWithInt:0] forKey:@"old_calendar_id"];
            
            result = [targetFMDB executeUpdate:changeStr withParameterDictionary:parmaDic];
            [parmaDic release];
            parmaDic = nil;
            NSString *cacheStr = @"insert into OccurrenceCache(day, event_id, calendar_id, store_id, occurrence_date, occurrence_start_date, occurrence_end_date) values(:day, :event_id, :calendar_id, :store_id, :occurrence_date, :occurrence_start_date, :occurrence_end_date)";
            parmaDic = [[NSMutableDictionary alloc] init];
            [parmaDic setObject:[NSNumber numberWithDouble:time] forKey:@"day"];
            [parmaDic setObject:[NSNumber numberWithInt:calendarItemID] forKey:@"event_id"];
            [parmaDic setObject:[NSNumber numberWithInt:[self getDefaultCalenderID:targetFMDB]] forKey:@"calendar_id"];
            [parmaDic setObject:[NSNumber numberWithInt:[self getDefaultStoreID:targetFMDB]] forKey:@"store_id"];
            [parmaDic setObject:[NSNumber numberWithDouble:item.startTime] forKey:@"occurrence_date"];
            [parmaDic setObject:[NSNull null] forKey:@"occurrence_start_date"];
            [parmaDic setObject:[NSNumber numberWithDouble:item.endTime] forKey:@"occurrence_end_date"];
            result = [targetFMDB executeUpdate:cacheStr withParameterDictionary:parmaDic];
            [parmaDic release];
            parmaDic = nil;
        }
    }
}

- (int)getDefaultCalenderID:(FMDatabase *)targetDB
{
    int defaultCalednerID = 1;
    NSString *defaultCalendarStr = @"select rowid from calendar where title='DEFAULT_CALENDAR_NAME'";
    FMResultSet *rs = [targetDB executeQuery:defaultCalendarStr];
    while ([rs next]) {
        defaultCalednerID = [rs intForColumn:@"rowid"];
    }
    [rs close];
    return defaultCalednerID;
}

- (int)getDefaultRedminderID:(FMDatabase *)targetDB
{
    int defaultCalednerID = 1;
    NSString *defaultCalendarStr = @"select rowid from calendar where title='DEFAULT_TASK_CALENDAR_NAME'";
    FMResultSet *rs = [targetDB executeQuery:defaultCalendarStr];
    while ([rs next]) {
        defaultCalednerID = [rs intForColumn:@"rowid"];
    }
    [rs close];
    return defaultCalednerID;
}

- (int)getDefaultStoreID:(FMDatabase *)targetDB
{
    int defaultStoreID = 1;
    NSString *defaultCalendarStr = @"select rowid from Store where name='Default'";
    FMResultSet *rs = [targetDB executeQuery:defaultCalendarStr];
    while ([rs next]) {
        defaultStoreID = [rs intForColumn:@"rowid"];
    }
    [rs close];
    return defaultStoreID;
}
@end
