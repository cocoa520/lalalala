//
//  IMBCalendarClone.m
//  iMobieTrans
//
//  Created by iMobie on 14-12-18.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBCalendarClone.h"
#import "IMBCalendarEventEntity.h"
#import "IMBCalAndRemEntity.h"
@implementation IMBCalendarClone


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
#pragma mark - Merge
- (void)merge:(NSArray *)calendarEventArray
{
    @try {
        NSMutableArray *calendarArray = [NSMutableArray array];
        NSMutableArray *redminderArray = [NSMutableArray array];
        for (IMBCalAndRemEntity *entity in calendarEventArray) {
            if (entity.entityType == 2) {
                [calendarArray addObject:entity];
            }else if (entity.entityType == 3){
                [redminderArray addObject:entity];
            }
        }
        if ([self openDataBase:_sourceDBConnection]&& [self openDataBase:_targetDBConnection]) {
            [_logHandle writeInfoLog:@"merge Calender enter"];
            [_sourceDBConnection beginTransaction];
            [_targetDBConnection beginTransaction];
           
            if (_targetVersion >= 6.0 && _sourceVersion>=6.0) {
                [self insertIdentityTable:_sourceDBConnection withTargetFmdb:_targetDBConnection];
            }
            NSDictionary *sourceTagetStoreIDs = [self insertStoreTable:_sourceDBConnection withTargetFmdb:_targetDBConnection ];
            NSDictionary *sourceTargetCalendarIDs = [self insertCalendarTable:_sourceDBConnection withTargetFmdb:_targetDBConnection  withDictionary:sourceTagetStoreIDs];
            NSDictionary *sourceTargetCategoryIDs = [self insertCategoryTable:_sourceDBConnection withTargetFmdb:_targetDBConnection];
            //插入calendar
            if ([calendarArray count] > 0) {
                [self insertSingleExiteData:calendarArray withCalendarDictionary:sourceTargetCalendarIDs withStoreDictionary:sourceTagetStoreIDs withCategoryDictionary:sourceTargetCategoryIDs isReminder:NO];
            }
            //插入reminder
            if ([redminderArray count] > 0) {
                [self insertSingleExiteData:redminderArray withCalendarDictionary:sourceTargetCalendarIDs   withStoreDictionary:sourceTagetStoreIDs withCategoryDictionary:sourceTargetCategoryIDs isReminder:YES];
            }
            if (![_sourceDBConnection commit]) {
                [_sourceDBConnection rollback];
            }
            if (![_targetDBConnection commit]) {
                [_targetDBConnection rollback];
            }
            [_sourceDBConnection close];
            [_targetDBConnection close];
        }
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"异常原因:%@",exception]];
    }
    [_logHandle writeInfoLog:@"merge Calender exit"];
    [self modifyHashAndManifest];
}

- (void)insertSingleExiteData:(NSMutableArray *)singleArray withCalendarDictionary:(NSDictionary *)calendarDic  withStoreDictionary:(NSDictionary *)sourceTagetStoreIDs withCategoryDictionary:(NSDictionary *)sourceTargetCategoryIDs isReminder:(BOOL)isReminder{
    for (IMBCalAndRemEntity *entity in singleArray) {
        @autoreleasepool {
            int item = entity.rowid;
            int newItemID = [self insertCalendarItemRecord:item withDictionary:calendarDic withSourceFMDB:_sourceDBConnection withTargetFmdb:_targetDBConnection  isReminder:isReminder];
            if (_targetVersion>=7.0 && _sourceVersion>=7.0) {
                [self insertScheduledTaskCacheRecord:item withNewItemID:newItemID withSourceFMDB:_sourceDBConnection withTargetFmdb:_targetDBConnection];
            }
            [self insertOccurrenceCacheRecord:item withNewItemID:newItemID withSourceFMDB:_sourceDBConnection withTargetFmdb:_targetDBConnection withCalendarDictionary:calendarDic withStoreDictionary:sourceTagetStoreIDs];
            [self insertRecurrenceRecord:item withNewItemID:newItemID withSourceFMDB:_sourceDBConnection withTargetFmdb:_targetDBConnection];
            int alarmID = [self insertAlarmRecord:item withNewItemID:newItemID  withSourceFMDB:_sourceDBConnection withTargetFmdb:_targetDBConnection];
            [self insertLocationRecord:item withNewItemID:newItemID  withSourceFMDB:_sourceDBConnection withTargetFmdb:_targetDBConnection alarmID:alarmID];
            [self insertCategoryLinkRecord:item withNewItemID:newItemID withSourceFMDB:_sourceDBConnection withTargetFmdb:_targetDBConnection withCategoryDictionary:sourceTargetCategoryIDs];
            [self insertExceptionDateRecord:item withNewItemID:newItemID withSourceFMDB:_sourceDBConnection withTargetFmdb:_targetDBConnection];

        }
    }
}

- (void)insertIdentityTable:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB {
    NSString *sourceCmd = @"SELECT display_name, address, first_name, last_name FROM Identity;";
    FMResultSet *rs = [sourceFMDB executeQuery:sourceCmd];
    while ([rs next]) {
        NSString *targetCmd = @"SELECT count(address) FROM Identity where address=:address;";
        NSString *address = nil;
        if ([rs columnIsNull:@"address"]) {
            address = @"";
        }else{
            address = [rs objectForColumnName:@"address"];
        }
        NSDictionary *parma = [NSDictionary dictionaryWithObjectsAndKeys:address, @"address", nil];
        FMResultSet *tarRs = [targetFMDB executeQuery:targetCmd withParameterDictionary:parma];
        while ([tarRs next]) {
            id objectId = [tarRs objectForColumnName:@"count(address)"];
            if (objectId != nil) {
                int addressCount = [objectId intValue];
                if (addressCount > 0) {
                    continue;
                }else {
                    NSString *insertCmd = @"insert into Identity(display_name, address, first_name, last_name) values(:display_name, :address, :first_name, :last_name)";
                    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
                    [paramDic setObject:[tarRs objectForColumnName:@"display_name"] forKey:@"display_name"];
                    [paramDic setObject:[tarRs objectForColumnName:@"address"] forKey:@"address"];
                    [paramDic setObject:[tarRs objectForColumnName:@"first_name"] forKey:@"first_name"];
                    [paramDic setObject:[tarRs objectForColumnName:@"last_name"] forKey:@"last_name"];
                    [targetFMDB executeUpdate:insertCmd withParameterDictionary:paramDic];
                    [paramDic release];
                    paramDic = nil;
                }
            }
        }
        [tarRs close];
    }
    [rs close];
}

- (NSDictionary *)insertStoreTable:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB  {
    NSString *IOS8InsertStr = @"insert into store(name, default_alarm_offset, type, constraint_path, disabled, external_id, persistent_id, flags, creator_bundle_id, creator_code_signing_identity, only_creator_can_modify, external_mod_tag,preferred_event_private_value,strictest_event_private_value) values(:name, :default_alarm_offset, :type, :constraint_path, :disabled, :external_id, :persistent_id, :flags, :creator_bundle_id, :creator_code_signing_identity, :only_creator_can_modify, :external_mod_tag ,:preferred_event_private_value, :strictest_event_private_value)";
    NSString *IOS7InsertStr = @"insert into store(name, default_alarm_offset, type, constraint_path, disabled, external_id, persistent_id, flags, creator_bundle_id, creator_code_signing_identity, only_creator_can_modify, external_mod_tag) values(:name, :default_alarm_offset, :type, :constraint_path, :disabled, :external_id, :persistent_id, :flags, :creator_bundle_id, :creator_code_signing_identity, :only_creator_can_modify, :external_mod_tag )";
    
    NSString *IOS6InsertStr = @"insert into store(name, default_alarm_offset, type, constraint_path, disabled, external_id, persistent_id, flags) values(:name, :default_alarm_offset, :type, :constraint_path, :disabled, :external_id, :persistent_id, :flags)";
    
    NSMutableDictionary *sourceTargetStoreIDDict = [[[NSMutableDictionary alloc] init] autorelease];
    int sourceNum = _sourceVersion;
    int targetNum = _targetVersion;
    NSString *sourceStr = @"";
    if (sourceNum >= 8) {
        sourceStr = @"SELECT ROWID, name, default_alarm_offset, type, constraint_path, disabled, external_id, persistent_id, flags, creator_bundle_id, creator_code_signing_identity, only_creator_can_modify, external_mod_tag,preferred_event_private_value,strictest_event_private_value FROM Store;";
    }else if (sourceNum == 7) {
        sourceStr = @"SELECT ROWID, name, default_alarm_offset, type, constraint_path, disabled, external_id, persistent_id, flags, creator_bundle_id, creator_code_signing_identity, only_creator_can_modify, external_mod_tag FROM Store;";
    }else if (sourceNum < 7) {
        sourceStr = @"SELECT ROWID, name, default_alarm_offset, type, constraint_path, disabled, external_id, persistent_id, flags FROM Store;";
    }
    
    FMResultSet *rs = [sourceFMDB executeQuery:sourceStr];
    while ([rs next]) {
        NSString *targetCmd = @"select rowid from store where name=:name";
        NSString *name = nil;
        if ([rs columnIsNull:@"name"]) {
            name = @"";
        }else{
            name = [rs stringForColumn:@"name"];
        }
        NSDictionary *parma = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", nil];
        FMResultSet *tarRs = [targetFMDB executeQuery:targetCmd withParameterDictionary:parma];
        if (tarRs) {
            BOOL isexists = NO;
            while ([tarRs next]) {
                isexists = YES;
                id rowObject = [tarRs objectForColumnName:@"rowid"];
                if (![tarRs columnIsNull:@"rowid"]) {
                    [sourceTargetStoreIDDict setObject:rowObject forKey:[rs objectForColumnName:@"rowid"]];
                }
            }
            [tarRs close];
            if (!isexists) {
                NSString *insertStr = @"";
                if (targetNum >= 8) {
                    insertStr = IOS8InsertStr;
                }else if (targetNum == 7) {
                    insertStr = IOS7InsertStr;
                }else if (targetNum < 7) {
                    insertStr = IOS6InsertStr;
                }
                NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
                [paramDic setObject:[rs objectForColumnName:@"name"] forKey:@"name"];
                [paramDic setObject:[rs objectForColumnName:@"default_alarm_offset"] forKey:@"default_alarm_offset"];
                [paramDic setObject:[rs objectForColumnName:@"type"] forKey:@"type"];
                [paramDic setObject:[rs objectForColumnName:@"constraint_path"] forKey:@"constraint_path"];
                [paramDic setObject:[rs objectForColumnName:@"disabled"] forKey:@"disabled"];
                [paramDic setObject:[rs objectForColumnName:@"external_id"] forKey:@"external_id"];
                [paramDic setObject:[rs objectForColumnName:@"persistent_id"] forKey:@"persistent_id"];
                [paramDic setObject:[rs objectForColumnName:@"flags"] forKey:@"flags"];
                
                if (targetNum >= 8) {
                    if (sourceNum >= 7) {
                        [paramDic setObject:[rs objectForColumnName:@"creator_bundle_id"] forKey:@"creator_bundle_id"];
                        [paramDic setObject:[rs objectForColumnName:@"creator_code_signing_identity"] forKey:@"creator_code_signing_identity"];
                        [paramDic setObject:[rs objectForColumnName:@"only_creator_can_modify"] forKey:@"only_creator_can_modify"];
                        [paramDic setObject:[rs objectForColumnName:@"external_mod_tag"] forKey:@"external_mod_tag"];
                        if (sourceNum >= 8) {
                            [paramDic setObject:[rs objectForColumnName:@"preferred_event_private_value"] forKey:@"preferred_event_private_value"];
                            [paramDic setObject:[rs objectForColumnName:@"strictest_event_private_value"] forKey:@"strictest_event_private_value"];
                        }else {
                            [paramDic setObject:[NSNull null] forKey:@"preferred_event_private_value"];
                            [paramDic setObject:[NSNull null] forKey:@"strictest_event_private_value"];
                        }
                    }else {
                        [paramDic setObject:[NSNull null] forKey:@"creator_bundle_id"];
                        [paramDic setObject:[NSNull null] forKey:@"creator_code_signing_identity"];
                        [paramDic setObject:[NSNull null] forKey:@"only_creator_can_modify"];
                        [paramDic setObject:[NSNull null] forKey:@"external_mod_tag"];
                        [paramDic setObject:[NSNull null] forKey:@"preferred_event_private_value"];
                        [paramDic setObject:[NSNull null] forKey:@"strictest_event_private_value"];
                    }
                }else if (targetNum == 7) {
                    if (sourceNum >= 7) {
                        [paramDic setObject:[rs objectForColumnName:@"creator_bundle_id"] forKey:@"creator_bundle_id"];
                        [paramDic setObject:[rs objectForColumnName:@"creator_code_signing_identity"] forKey:@"creator_code_signing_identity"];
                        [paramDic setObject:[rs objectForColumnName:@"only_creator_can_modify"] forKey:@"only_creator_can_modify"];
                        [paramDic setObject:[rs objectForColumnName:@"external_mod_tag"] forKey:@"external_mod_tag"];
                    }else {
                        [paramDic setObject:[NSNull null] forKey:@"creator_bundle_id"];
                        [paramDic setObject:[NSNull null] forKey:@"creator_code_signing_identity"];
                        [paramDic setObject:[NSNull null] forKey:@"only_creator_can_modify"];
                        [paramDic setObject:[NSNull null] forKey:@"external_mod_tag"];
                    }
                }
                BOOL reslut = [targetFMDB executeUpdate:insertStr withParameterDictionary:paramDic];
                [paramDic release];
                paramDic = nil;
                if (reslut) {
                    id rowNewObject = nil;
                    NSString *sql3 = @"select last_insert_rowid() from store";
                    FMResultSet *rs1 = [targetFMDB executeQuery:sql3];
                    while ([rs1 next]) {
                        rowNewObject = [rs1 objectForColumnName:@"last_insert_rowid()"];
                        
                    }
                    [rs1 close];
                    if (rowNewObject) {
                        [sourceTargetStoreIDDict setObject:rowNewObject forKey:[rs objectForColumnName:@"rowid"]];
                    }
                }
            }
        }
    }
    [rs close];
    return sourceTargetStoreIDDict;
}

- (NSDictionary *)insertCalendarTable:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB  withDictionary:(NSDictionary *)sourceTagetStoreIDs {
    NSMutableDictionary *sourceTargetCalendarIDDict = [[[NSMutableDictionary alloc] init] autorelease];
    int sourceNum = _sourceVersion;
    int targetNum = _targetVersion;
    NSString *IOS11InsertStr = @"insert into Calendar (store_id, title, flags, color, symbolic_color_name, color_is_display, type, supported_entity_types, external_id, external_mod_tag, external_id_tag, external_rep, display_order, UUID, shared_owner_name, sharing_status, sharing_invitation_response, published_URL, is_published, invitation_status, sync_token, self_identity_id, self_identity_email, owner_identity_id, owner_identity_email, notes, bulk_requests, subcal_account_id, push_key) values(:store_id, :title, :flags, :color, :symbolic_color_name, :color_is_display, :type, :supported_entity_types, :external_id, :external_mod_tag, :external_id_tag, :external_rep, :display_order, :UUID, :shared_owner_name, :sharing_status, :sharing_invitation_response, :published_URL, :is_published, :invitation_status, :sync_token, :self_identity_id, :self_identity_email, :owner_identity_id, :owner_identity_email, :notes, :bulk_requests, :subcal_account_id, :push_key)";
    
    NSString *IOS8InsertStr = @"insert into Calendar (store_id, title, flags, color, symbolic_color_name, color_is_display, type, supported_entity_types, external_id, external_mod_tag, external_id_tag, external_rep, display_order, UUID, shared_owner_name, shared_owner_email, sharing_status, sharing_invitation_response, published_URL, is_published, invitation_status, sync_token, self_identity_id, self_identity_email, owner_identity_id, owner_identity_email, notes, bulk_requests, subcal_account_id, push_key) values(:store_id, :title, :flags, :color, :symbolic_color_name, :color_is_display, :type, :supported_entity_types, :external_id, :external_mod_tag, :external_id_tag, :external_rep, :display_order, :UUID, :shared_owner_name, :shared_owner_email, :sharing_status, :sharing_invitation_response, :published_URL, :is_published, :invitation_status, :sync_token, :self_identity_id, :self_identity_email, :owner_identity_id, :owner_identity_email, :notes, :bulk_requests, :subcal_account_id, :push_key)";
    NSString *IOS6InsertStr = @"insert into Calendar (store_id, title, flags, color, color_is_display, type, supported_entity_types, external_id, external_mod_tag, external_id_tag, external_rep, display_order, UUID, shared_owner_name, shared_owner_email, sharing_status, sharing_invitation_response, published_URL, is_published, invitation_status, sync_token, self_identity_id, self_identity_email, owner_identity_id, owner_identity_email) values(:store_id, :title, :flags, :color, :color_is_display, :type, :supported_entity_types, :external_id, :external_mod_tag, :external_id_tag, :external_rep, :display_order, :UUID, :shared_owner_name, :shared_owner_email, :sharing_status, :sharing_invitation_response, :published_URL, :is_published, :invitation_status, :sync_token, :self_identity_id, :self_identity_email, :owner_identity_id, :owner_identity_email)";
    NSString *IOS5InsertStr = @"insert into Calendar (store_id, title, flags, color, color_is_display, type, supported_entity_types, external_id, external_mod_tag, external_id_tag, external_rep, display_order, UUID, shared_owner_name, shared_owner_email, sharing_status) values(:store_id, :title, :flags, :color, :color_is_display, :type, :supported_entity_types, :external_id, :external_mod_tag, :external_id_tag, :external_rep, :display_order, :UUID, :shared_owner_name, :shared_owner_email, :sharing_status)";
    
    NSString *selectStr = @"";
    if (sourceNum >= 11) {
        selectStr = @"SELECT ROWID, store_id, title, flags, color, symbolic_color_name, color_is_display, type, supported_entity_types, external_id, external_mod_tag, external_id_tag, external_rep, display_order, UUID, shared_owner_name, sharing_status, sharing_invitation_response, published_URL, is_published, invitation_status, sync_token, self_identity_id, self_identity_email, owner_identity_id, owner_identity_email, notes, bulk_requests, subcal_account_id, push_key FROM Calendar;";
    }else if (sourceNum >= 7) {
        selectStr = @"SELECT ROWID, store_id, title, flags, color, symbolic_color_name, color_is_display, type, supported_entity_types, external_id, external_mod_tag, external_id_tag, external_rep, display_order, UUID, shared_owner_name, shared_owner_email, sharing_status, sharing_invitation_response, published_URL, is_published, invitation_status, sync_token, self_identity_id, self_identity_email, owner_identity_id, owner_identity_email, notes, bulk_requests, subcal_account_id, push_key FROM Calendar;";
    }else if (sourceNum == 6) {
        selectStr = @"SELECT ROWID, store_id, title, flags, color,  color_is_display, type, supported_entity_types, external_id, external_mod_tag, external_id_tag, external_rep, display_order, UUID, shared_owner_name, shared_owner_email, sharing_status, sharing_invitation_response, published_URL, is_published, invitation_status, sync_token, self_identity_id, self_identity_email, owner_identity_id, owner_identity_email FROM Calendar;";
    }else if (sourceNum == 5) {
        selectStr = @"SELECT ROWID, store_id, title, flags, color,  color_is_display, type, supported_entity_types, external_id, external_mod_tag, external_id_tag, external_rep, display_order, UUID, shared_owner_name, shared_owner_email, sharing_status FROM Calendar;";
    }
    
    int storeID = 1;
    NSString *storeSql = @"select rowid from Store where name='Default'";
    FMResultSet *storeRS = [targetFMDB executeQuery:storeSql];
    while ([storeRS next]) {
        storeID = [storeRS intForColumn:@"rowid"];
    }
    [storeRS close];
    FMResultSet *sourceRs = [sourceFMDB executeQuery:selectStr];
    while ([sourceRs next]) {
        NSString *targetStr = @"select rowid from calendar where title=:title and flags=:flags";
        NSString *title = nil;
        if ([sourceRs columnIsNull:@"title"]) {
            title = @"";
        }else{
            title = [sourceRs stringForColumn:@"title"];
        }
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", [NSNumber numberWithInt:[sourceRs intForColumn:@"flags"]], @"flags", nil];
        FMResultSet *tarRs = [targetFMDB executeQuery:targetStr withParameterDictionary:param];
        if (tarRs) {
            BOOL isexists = NO;
            while ([tarRs next]) {
                isexists = YES;
                id rowObject = [tarRs objectForColumnName:@"rowid"];
                if (![tarRs columnIsNull:@"rowid"]) {
                    [sourceTargetCalendarIDDict setObject:rowObject forKey:[sourceRs objectForColumnName:@"rowid"]];
                }
            }
            [tarRs close];
            if (!isexists) {
                NSString *insertStr = @"";
                if (targetNum >= 11){
                    insertStr = IOS11InsertStr;
                }else if (targetNum >= 7) {
                    insertStr = IOS8InsertStr;
                }else if (targetNum == 6) {
                    insertStr = IOS6InsertStr;
                }else if (targetNum == 5) {
                    insertStr = IOS5InsertStr;
                }
                NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
                [paramDic setObject:@(storeID) forKey:@"store_id"];
                [paramDic setObject:[sourceRs objectForColumnName:@"title"] forKey:@"title"];
                [paramDic setObject:[sourceRs objectForColumnName:@"flags"] forKey:@"flags"];
                [paramDic setObject:[sourceRs objectForColumnName:@"color"] forKey:@"color"];
                if (targetNum >= 7) {
                    if (sourceNum >= 7) {
                        [paramDic setObject:[sourceRs objectForColumnName:@"symbolic_color_name"] forKey:@"symbolic_color_name"];
                    }else {
                        [paramDic setObject:[NSNull null] forKey:@"symbolic_color_name"];
                    }
                }
                [paramDic setObject:[sourceRs objectForColumnName:@"color_is_display"] forKey:@"color_is_display"];
                [paramDic setObject:[sourceRs objectForColumnName:@"type"] forKey:@"type"];
                [paramDic setObject:[sourceRs objectForColumnName:@"supported_entity_types"] forKey:@"supported_entity_types"];
                [paramDic setObject:[sourceRs objectForColumnName:@"external_id"] forKey:@"external_id"];
                [paramDic setObject:[sourceRs objectForColumnName:@"external_mod_tag"] forKey:@"external_mod_tag"];
                [paramDic setObject:[sourceRs objectForColumnName:@"external_id_tag"] forKey:@"external_id_tag"];
                [paramDic setObject:[sourceRs objectForColumnName:@"external_rep"] forKey:@"external_rep"];
                [paramDic setObject:[sourceRs objectForColumnName:@"display_order"] forKey:@"display_order"];
                [paramDic setObject:[sourceRs objectForColumnName:@"UUID"] forKey:@"UUID"];
                [paramDic setObject:[sourceRs objectForColumnName:@"shared_owner_name"] forKey:@"shared_owner_name"];
                if (targetNum<11) {
                    if (sourceNum<11) {
                        [paramDic setObject:[sourceRs objectForColumnName:@"shared_owner_email"] forKey:@"shared_owner_email"];
                    }else{
                        [paramDic setObject:[NSNull null] forKey:@"shared_owner_email"];
                    }
                }
                
                [paramDic setObject:[sourceRs objectForColumnName:@"sharing_status"] forKey:@"sharing_status"];
                if (targetNum >= 6) {
                    if (sourceNum >= 6) {
                        [paramDic setObject:[sourceRs objectForColumnName:@"sharing_invitation_response"] forKey:@"sharing_invitation_response"];
                        [paramDic setObject:[sourceRs objectForColumnName:@"published_URL"] forKey:@"published_URL"];
                        [paramDic setObject:[sourceRs objectForColumnName:@"is_published"] forKey:@"is_published"];
                        [paramDic setObject:[sourceRs objectForColumnName:@"invitation_status"] forKey:@"invitation_status"];
                        [paramDic setObject:[sourceRs objectForColumnName:@"sync_token"] forKey:@"sync_token"];
                        [paramDic setObject:[sourceRs objectForColumnName:@"self_identity_id"] forKey:@"self_identity_id"];
                        [paramDic setObject:[sourceRs objectForColumnName:@"self_identity_email"] forKey:@"self_identity_email"];
                        [paramDic setObject:[sourceRs objectForColumnName:@"owner_identity_id"] forKey:@"owner_identity_id"];
                        [paramDic setObject:[sourceRs objectForColumnName:@"owner_identity_email"] forKey:@"owner_identity_email"];
                    }else {
                        [paramDic setObject:[NSNull null] forKey:@"sharing_invitation_response"];
                        [paramDic setObject:[NSNull null] forKey:@"published_URL"];
                        [paramDic setObject:[NSNull null] forKey:@"is_published"];
                        [paramDic setObject:[NSNull null] forKey:@"invitation_status"];
                        [paramDic setObject:[NSNull null] forKey:@"sync_token"];
                        [paramDic setObject:[NSNull null] forKey:@"self_identity_id"];
                        [paramDic setObject:[NSNull null] forKey:@"self_identity_email"];
                        [paramDic setObject:[NSNull null] forKey:@"owner_identity_id"];
                        [paramDic setObject:[NSNull null] forKey:@"owner_identity_email"];
                    }
                }
                if (targetNum >= 7) {
                    if (sourceNum >= 7) {
                        [paramDic setObject:[sourceRs objectForColumnName:@"notes"] forKey:@"notes"];
                        [paramDic setObject:[sourceRs objectForColumnName:@"bulk_requests"] forKey:@"bulk_requests"];
                        [paramDic setObject:[sourceRs objectForColumnName:@"subcal_account_id"] forKey:@"subcal_account_id"];
                        [paramDic setObject:[sourceRs objectForColumnName:@"push_key"] forKey:@"push_key"];
                    }else {
                        [paramDic setObject:[NSNull null] forKey:@"notes"];
                        [paramDic setObject:[NSNull null] forKey:@"bulk_requests"];
                        [paramDic setObject:[NSNull null] forKey:@"subcal_account_id"];
                        [paramDic setObject:[NSNull null] forKey:@"push_key"];
                    }
                }
                BOOL reslut = [targetFMDB executeUpdate:insertStr withParameterDictionary:paramDic];
                [paramDic release];
                paramDic = nil;
                
                if (reslut) {
                    id rowNewObject = nil;
                    NSString *sql3 = @"select last_insert_rowid() from Calendar";
                    FMResultSet *rs = [targetFMDB executeQuery:sql3];
                    while ([rs next]) {
                        rowNewObject = [rs objectForColumnName:@"last_insert_rowid()"];
                    }
                    [rs close];
                    if (rowNewObject) {
                        [sourceTargetCalendarIDDict setObject:rowNewObject forKey:[sourceRs objectForColumnName:@"rowid"]];
                    }
                }
            }
        }
    }
    [sourceRs close];
    
    return sourceTargetCalendarIDDict;
}

- (NSDictionary *)insertCategoryTable:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB {
    NSMutableDictionary *sourceTargetCategoryIDs = [[[NSMutableDictionary alloc] init] autorelease];
    NSString *souceStr = @"SELECT ROWID, name, entity_type, hidden FROM Category;";
    FMResultSet *souceRs = [sourceFMDB executeQuery:souceStr];
    while ([souceRs next]) {
        NSString *targetCmd = @"select rowid from category where name=:name and entity_type=:entity_type";
        NSString *name = nil;
        if ([souceRs columnIsNull:@"title"]) {
            name = @"";
        }else{
            name = [souceRs stringForColumn:@"name"];
        }
        NSDictionary *parma = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", [NSNumber numberWithInt:[souceRs intForColumn:@"entity_type"]], @"entity_type", nil];
        
        FMResultSet *tarRs = [targetFMDB executeQuery:targetCmd withParameterDictionary:parma];
        if (tarRs) {
            BOOL isexists = NO;
            while ([tarRs next]) {
                isexists = YES;
                id rowObject = [tarRs objectForColumnName:@"rowid"];
                if (rowObject != nil) {
                    [sourceTargetCategoryIDs setObject:rowObject forKey:[souceRs objectForColumnName:@"rowid"]];
                }
            }
            [tarRs close];
            if (!isexists) {
                NSString *insertCmd = @"insert into Category(name, entity_type, hidden) values(:name, :entity_type, :hidden)";
                NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
                [paramDic setObject:[tarRs objectForColumnName:@"name"] forKey:@"name"];
                [paramDic setObject:[tarRs objectForColumnName:@"entity_type"] forKey:@"entity_type"];
                [paramDic setObject:[tarRs objectForColumnName:@"hidden"] forKey:@"hidden"];
                BOOL reslut = [targetFMDB executeUpdate:insertCmd withParameterDictionary:paramDic];
                [paramDic release];
                paramDic = nil;
                
                if (reslut) {
                    id rowNewObject = nil;
                    NSString *sql3 = @"select last_insert_rowid() from Category";
                    FMResultSet *rs = [targetFMDB executeQuery:sql3];
                    while ([rs next]) {
                        rowNewObject = [rs objectForColumnName:@"last_insert_rowid()"];
                        
                    }
                    [rs close];
                    if (rowNewObject) {
                        [sourceTargetCategoryIDs setObject:rowNewObject forKey:[souceRs objectForColumnName:@"rowid"]];
                    }
                }
            }
        }
    }
    [souceRs close];
    
    return sourceTargetCategoryIDs;
}

- (int)insertCalendarItemRecord:(int)item withDictionary:(NSDictionary *)sourceTargetCalendarIDs withSourceFMDB:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB isReminder:(BOOL)isReminder{
    int newID = -1;
    
    NSString *IOS11SelectStr = @"SELECT ROWID, summary,location_id, description, start_date, start_tz, end_date, all_day, calendar_id, orig_item_id, orig_date, organizer_id, self_attendee_id, status, invitation_status, availability, privacy_level, url, last_modified, sequence_num, birthday_id, modified_properties, external_tracking_status, external_id, external_mod_tag, unique_identifier, external_schedule_id, external_rep, response_comment, hidden, has_recurrences, has_attendees, UUID, entity_type, priority, due_date, due_tz, due_all_day, completion_date, creation_date, display_order, created_by_id, modified_by_id, shared_item_created_date, shared_item_created_tz, shared_item_modified_date, shared_item_modified_tz, invitation_changed_properties, default_alarm_removed, phantom_master, participation_status_modified_date, calendar_scale, travel_time, travel_advisory_behavior, start_location_id,suggested_event_info_id,can_forward,location_prediction_state,fired_ttl,disallow_propose_new_time,junk_status FROM CalendarItem where rowid=:rowid";
    
    NSString *IOS9SelectStr = @"SELECT ROWID, summary, location_id, description, start_date, start_tz, end_date, all_day, calendar_id, orig_item_id, orig_date, organizer_id, self_attendee_id, status, invitation_status, availability, privacy_level, url, last_modified, sequence_num, birthday_id, modified_properties, external_tracking_status, external_id, external_mod_tag, unique_identifier, external_schedule_id, external_rep, response_comment, hidden, has_recurrences, has_attendees, UUID, entity_type, priority, due_date, due_tz, due_all_day, completion_date, creation_date, conference, display_order, created_by_id, modified_by_id, shared_item_created_date, shared_item_created_tz, shared_item_modified_date, shared_item_modified_tz, invitation_changed_properties, default_alarm_removed, phantom_master, participation_status_modified_date, calendar_scale, travel_time, travel_advisory_behavior, start_location_id FROM CalendarItem where rowid=:rowid";
    
    NSString *IOS7SelectStr = @"SELECT ROWID, summary, location_id, description, start_date, start_tz, end_date, all_day, calendar_id, orig_item_id, orig_date, organizer_id, self_attendee_id, status, invitation_status, availability, privacy_level, url, last_modified, sequence_num, birthday_id, modified_properties, external_tracking_status, external_id, external_mod_tag, unique_identifier, external_schedule_id, external_rep, response_comment, hidden, has_recurrences, has_attendees, UUID, entity_type, priority, due_date, due_tz, due_all_day, completion_date, creation_date, conference, display_order, created_by_id, modified_by_id, shared_item_created_date, shared_item_created_tz, shared_item_modified_date, shared_item_modified_tz, invitation_changed_properties, default_alarm_removed, phantom_master, participation_status_modified_date FROM CalendarItem where rowid=:rowid";
    
    NSString *IOS6SelectStr = @"SELECT ROWID, summary, location_id, description, start_date, start_tz, end_date, all_day, calendar_id, orig_item_id, orig_date, organizer_id, self_attendee_id, status, invitation_status, availability, privacy_level, url, last_modified, sequence_num, birthday_id, modified_properties, external_tracking_status, external_id, external_mod_tag, unique_identifier, external_schedule_id, external_rep, response_comment, hidden, has_recurrences, has_attendees, UUID, entity_type, priority, due_date, due_tz, due_all_day, completion_date, creation_date, conference, display_order, created_by_id, modified_by_id, shared_item_created_date, shared_item_created_tz, shared_item_modified_date, shared_item_modified_tz, invitation_changed_properties, default_alarm_removed, phantom_master FROM CalendarItem where rowid=:rowid;";
    
    NSString *IOS5SelectStr = @"SELECT ROWID, summary, location_id, description, start_date, start_tz, end_date, all_day, calendar_id, orig_item_id, orig_date, organizer_id, self_attendee_id, status, read_status, availability, privacy_level, url, last_modified, sequence_num, birthday_id, modified_properties, external_tracking_status, external_id, external_mod_tag, unique_identifier, external_schedule_id, external_rep, response_comment, hidden, has_recurrences, has_attendees, UUID, entity_type, priority, due_date, due_tz, due_all_day, completion_date, creation_date, conference FROM CalendarItem where rowid=:rowid";
    
    NSString *IOS11InsertStr = @"insert into CalendarItem (summary,location_id, description, start_date, start_tz, end_date, all_day, calendar_id, orig_item_id, orig_date, organizer_id, self_attendee_id, status, invitation_status, availability, privacy_level, url, last_modified, sequence_num, birthday_id, modified_properties, external_tracking_status, external_id, external_mod_tag, unique_identifier, external_schedule_id, external_rep, response_comment, hidden, has_recurrences, has_attendees, UUID, entity_type, priority, due_date, due_tz, due_all_day, completion_date, creation_date, display_order, created_by_id, modified_by_id, shared_item_created_date, shared_item_created_tz, shared_item_modified_date, shared_item_modified_tz, invitation_changed_properties, default_alarm_removed, phantom_master, participation_status_modified_date, calendar_scale, travel_time, travel_advisory_behavior, start_location_id,suggested_event_info_id,can_forward,location_prediction_state,fired_ttl,disallow_propose_new_time,junk_status) values(:summary, :location_id, :description, :start_date, :start_tz, :end_date, :all_day, :calendar_id, :orig_item_id, :orig_date, :organizer_id, :self_attendee_id, :status, :invitation_status, :availability, :privacy_level, :url, :last_modified, :sequence_num, :birthday_id, :modified_properties, :external_tracking_status, :external_id, :external_mod_tag, :unique_identifier, :external_schedule_id, :external_rep, :response_comment, :hidden, :has_recurrences, :has_attendees, :UUID, :entity_type, :priority, :due_date, :due_tz, :due_all_day, :completion_date, :creation_date, :display_order, :created_by_id, :modified_by_id, :shared_item_created_date, :shared_item_created_tz, :shared_item_modified_date, :shared_item_modified_tz, :invitation_changed_properties, :default_alarm_removed, :phantom_master, :participation_status_modified_date, :calendar_scale, :travel_time, :travel_advisory_behavior, :start_location_id, :suggested_event_info_id, :can_forward, :location_prediction_state, :fired_ttl, :disallow_propose_new_time, :junk_status)";
    
    NSString *IOS9InsertStr = @"insert into CalendarItem (summary, location_id, description, start_date, start_tz, end_date, all_day, calendar_id, orig_item_id, orig_date, organizer_id, self_attendee_id, status, invitation_status, availability, privacy_level, url, last_modified, sequence_num, birthday_id, modified_properties, external_tracking_status, external_id, external_mod_tag, unique_identifier, external_schedule_id, external_rep, response_comment, hidden, has_recurrences, has_attendees, UUID, entity_type, priority, due_date, due_tz, due_all_day, completion_date, creation_date, conference, display_order, created_by_id, modified_by_id, shared_item_created_date, shared_item_created_tz, shared_item_modified_date, shared_item_modified_tz, invitation_changed_properties, default_alarm_removed, phantom_master, participation_status_modified_date, calendar_scale, travel_time, travel_advisory_behavior, start_location_id) values(:summary, :location_id, :description, :start_date, :start_tz, :end_date, :all_day, :calendar_id, :orig_item_id, :orig_date, :organizer_id, :self_attendee_id, :status, :invitation_status, :availability, :privacy_level, :url, :last_modified, :sequence_num, :birthday_id, :modified_properties, :external_tracking_status, :external_id, :external_mod_tag, :unique_identifier, :external_schedule_id, :external_rep, :response_comment, :hidden, :has_recurrences, :has_attendees, :UUID, :entity_type, :priority, :due_date, :due_tz, :due_all_day, :completion_date, :creation_date, :conference, :display_order, :created_by_id, :modified_by_id, :shared_item_created_date, :shared_item_created_tz, :shared_item_modified_date, :shared_item_modified_tz, :invitation_changed_properties, :default_alarm_removed, :phantom_master, :participation_status_modified_date, :calendar_scale, :travel_time, :travel_advisory_behavior, :start_location_id)";
    
    NSString *IOS7InsertStr = @"insert into CalendarItem (summary, location_id, description, start_date, start_tz, end_date, all_day, calendar_id, orig_item_id, orig_date, organizer_id, self_attendee_id, status, invitation_status, availability, privacy_level, url, last_modified, sequence_num, birthday_id, modified_properties, external_tracking_status, external_id, external_mod_tag, unique_identifier, external_schedule_id, external_rep, response_comment, hidden, has_recurrences, has_attendees, UUID, entity_type, priority, due_date, due_tz, due_all_day, completion_date, creation_date, conference, display_order, created_by_id, modified_by_id, shared_item_created_date, shared_item_created_tz, shared_item_modified_date, shared_item_modified_tz, invitation_changed_properties, default_alarm_removed, phantom_master, participation_status_modified_date) values(:summary, :location_id, :description, :start_date, :start_tz, :end_date, :all_day, :calendar_id, :orig_item_id, :orig_date, :organizer_id, :self_attendee_id, :status, :invitation_status, :availability, :privacy_level, :url, :last_modified, :sequence_num, :birthday_id, :modified_properties, :external_tracking_status, :external_id, :external_mod_tag, :unique_identifier, :external_schedule_id, :external_rep, :response_comment, :hidden, :has_recurrences, :has_attendees, :UUID, :entity_type, :priority, :due_date, :due_tz, :due_all_day, :completion_date, :creation_date, :conference, :display_order, :created_by_id, :modified_by_id, :shared_item_created_date, :shared_item_created_tz, :shared_item_modified_date, :shared_item_modified_tz, :invitation_changed_properties, :default_alarm_removed, :phantom_master, :participation_status_modified_date)";
    
    NSString *IOS6InsertStr = @"insert into CalendarItem ( summary, location_id, description, start_date, start_tz, end_date, all_day, calendar_id, orig_item_id, orig_date, organizer_id, self_attendee_id, status, invitation_status, availability, privacy_level, url, last_modified, sequence_num, birthday_id, modified_properties, external_tracking_status, external_id, external_mod_tag, unique_identifier, external_schedule_id, external_rep, response_comment, hidden, has_recurrences, has_attendees, UUID, entity_type, priority, due_date, due_tz, due_all_day, completion_date, creation_date, conference, display_order, created_by_id, modified_by_id, shared_item_created_date, shared_item_created_tz, shared_item_modified_date, shared_item_modified_tz, invitation_changed_properties, default_alarm_removed, phantom_master) values( :summary, :location_id, :description, :start_date, :start_tz, :end_date, :all_day, :calendar_id, :orig_item_id, :orig_date, :organizer_id, :self_attendee_id, :status, :invitation_status, :availability, :privacy_level, :url, :last_modified, :sequence_num, :birthday_id, :modified_properties, :external_tracking_status, :external_id, :external_mod_tag, :unique_identifier, :external_schedule_id, :external_rep, :response_comment, :hidden, :has_recurrences, :has_attendees, :UUID, :entity_type, :priority, :due_date, :due_tz, :due_all_day, :completion_date, :creation_date, :conference, :display_order, :created_by_id, :modified_by_id, :shared_item_created_date, :shared_item_created_tz, :shared_item_modified_date, :shared_item_modified_tz, :invitation_changed_properties, :default_alarm_removed, :phantom_master)";
    
    NSString *IOS5InsertStr = @"insert into CalendarItem ( summary, location_id, description, start_date, start_tz, end_date, all_day, calendar_id, orig_item_id, orig_date, organizer_id, self_attendee_id, status,read_status, availability, privacy_level, url, last_modified, sequence_num, birthday_id, modified_properties, external_tracking_status, external_id, external_mod_tag, unique_identifier, external_schedule_id, external_rep, response_comment, hidden, has_recurrences, has_attendees, UUID, entity_type, priority, due_date, due_tz, due_all_day, completion_date, creation_date, conference) values( :summary, :location_id, :description, :start_date, :start_tz, :end_date, :all_day, :calendar_id, :orig_item_id, :orig_date, :organizer_id, :self_attendee_id, :status, :invitation_status, :availability, :privacy_level, :url, :last_modified, :sequence_num, :birthday_id, :modified_properties, :external_tracking_status, :external_id, :external_mod_tag, :unique_identifier, :external_schedule_id, :external_rep, :response_comment, :hidden, :has_recurrences, :has_attendees, :UUID, :entity_type, :priority, :due_date, :due_tz, :due_all_day, :completion_date, :creation_date, :conference)";
    
    int sourceNum = _sourceVersion;
    int targetNum = _targetVersion;
    NSString *selectStr = @"";
    if (sourceNum >= 11) {
        selectStr = IOS11SelectStr;
    } else if (sourceNum >= 8) {
        selectStr = IOS9SelectStr;
    }else if (sourceNum == 7) {
        selectStr = IOS7SelectStr;
    }else if (sourceNum == 6) {
        selectStr = IOS6SelectStr;
    }else if (sourceNum == 5) {
        selectStr = IOS5SelectStr;
    }
    NSDictionary *parma = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:item], @"rowid", nil];
    FMResultSet *souceRs = [sourceFMDB executeQuery:selectStr withParameterDictionary:parma];
    while ([souceRs next]) {
        NSString *insertStr = @"";
        if (targetNum >= 11) {
            insertStr = IOS11InsertStr;
        }else if (targetNum >= 8) {
            insertStr = IOS9InsertStr;
        }else if (targetNum == 7) {
            insertStr = IOS7InsertStr;
        }else if (targetNum == 6) {
            insertStr = IOS6InsertStr;
        }else if (targetNum == 5) {
            insertStr = IOS5InsertStr;
        }
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
        [paramDic setObject:[souceRs objectForColumnName:@"summary"] forKey:@"summary"];
        [paramDic setObject:[souceRs objectForColumnName:@"location_id"] forKey:@"location_id"];
        [paramDic setObject:[souceRs objectForColumnName:@"description"] forKey:@"description"];
        [paramDic setObject:[souceRs objectForColumnName:@"start_date"] forKey:@"start_date"];
        [paramDic setObject:[souceRs objectForColumnName:@"start_tz"] forKey:@"start_tz"];
        [paramDic setObject:[souceRs objectForColumnName:@"end_date"] forKey:@"end_date"];
        [paramDic setObject:[souceRs objectForColumnName:@"all_day"] forKey:@"all_day"];
        int sourceCalendarID = [souceRs intForColumn:@"calendar_id"];
        if ([sourceTargetCalendarIDs.allKeys containsObject:[NSNumber numberWithInt:sourceCalendarID]]) {
            [paramDic setObject:[sourceTargetCalendarIDs objectForKey:[NSNumber numberWithInt:sourceCalendarID]] forKey:@"calendar_id"];
            
        }else {
            if (isReminder) {
                [paramDic setObject:@([self getDefaultRedminderID:targetFMDB]) forKey:@"calendar_id"];
            }else{
                [paramDic setObject:@([self getDefaultCalenderID:targetFMDB]) forKey:@"calendar_id"];
            }
            
        }
        [paramDic setObject:[souceRs objectForColumnName:@"orig_item_id"] forKey:@"orig_item_id"];
        [paramDic setObject:[souceRs objectForColumnName:@"orig_date"] forKey:@"orig_date"];
        [paramDic setObject:[souceRs objectForColumnName:@"organizer_id"] forKey:@"organizer_id"];
        [paramDic setObject:[souceRs objectForColumnName:@"self_attendee_id"] forKey:@"self_attendee_id"];
        [paramDic setObject:[souceRs objectForColumnName:@"status"] forKey:@"status"];
        if (targetNum>5) {
            [paramDic setObject:@(0) forKey:@"invitation_status"];
        }else{
            [paramDic setObject:@(0) forKey:@"read_status"];
        }
        
        [paramDic setObject:[souceRs objectForColumnName:@"availability"] forKey:@"availability"];
        [paramDic setObject:[souceRs objectForColumnName:@"privacy_level"] forKey:@"privacy_level"];
        [paramDic setObject:[souceRs objectForColumnName:@"url"] forKey:@"url"];
        [paramDic setObject:[souceRs objectForColumnName:@"last_modified"] forKey:@"last_modified"];
        [paramDic setObject:[souceRs objectForColumnName:@"sequence_num"] forKey:@"sequence_num"];
        [paramDic setObject:[souceRs objectForColumnName:@"birthday_id"] forKey:@"birthday_id"];
        [paramDic setObject:[souceRs objectForColumnName:@"modified_properties"] forKey:@"modified_properties"];
        
        [paramDic setObject:[souceRs objectForColumnName:@"external_tracking_status"] forKey:@"external_tracking_status"];
        [paramDic setObject:[souceRs objectForColumnName:@"external_id"] forKey:@"external_id"];
        [paramDic setObject:[souceRs objectForColumnName:@"external_mod_tag"] forKey:@"external_mod_tag"];
        [paramDic setObject:[souceRs objectForColumnName:@"unique_identifier"] forKey:@"unique_identifier"];
        [paramDic setObject:[souceRs objectForColumnName:@"external_schedule_id"] forKey:@"external_schedule_id"];
        [paramDic setObject:[souceRs objectForColumnName:@"external_rep"] forKey:@"external_rep"];
        [paramDic setObject:[souceRs objectForColumnName:@"response_comment"] forKey:@"response_comment"];
        [paramDic setObject:[souceRs objectForColumnName:@"hidden"] forKey:@"hidden"];
        [paramDic setObject:[souceRs objectForColumnName:@"has_recurrences"] forKey:@"has_recurrences"];
        [paramDic setObject:[souceRs objectForColumnName:@"has_attendees"] forKey:@"has_attendees"];
        [paramDic setObject:[souceRs objectForColumnName:@"UUID"] forKey:@"UUID"];
        if (isReminder) {
            [paramDic setObject:[NSNumber numberWithInt:3] forKey:@"entity_type"];
        }else{
            [paramDic setObject:[NSNumber numberWithInt:2] forKey:@"entity_type"];
        }
        [paramDic setObject:[souceRs objectForColumnName:@"priority"] forKey:@"priority"];
        [paramDic setObject:[souceRs objectForColumnName:@"due_date"] forKey:@"due_date"];
        [paramDic setObject:[souceRs objectForColumnName:@"due_tz"] forKey:@"due_tz"];
        [paramDic setObject:[souceRs objectForColumnName:@"due_all_day"] forKey:@"due_all_day"];
        [paramDic setObject:[souceRs objectForColumnName:@"completion_date"] forKey:@"completion_date"];
        [paramDic setObject:[souceRs objectForColumnName:@"creation_date"] forKey:@"creation_date"];
        
        if (targetNum >= 6) {
            if (sourceNum >= 6) {
                [paramDic setObject:[souceRs objectForColumnName:@"display_order"] forKey:@"display_order"];
                [paramDic setObject:[souceRs objectForColumnName:@"created_by_id"] forKey:@"created_by_id"];
                [paramDic setObject:[souceRs objectForColumnName:@"modified_by_id"] forKey:@"modified_by_id"];
                [paramDic setObject:[souceRs objectForColumnName:@"shared_item_created_date"] forKey:@"shared_item_created_date"];
                [paramDic setObject:[souceRs objectForColumnName:@"shared_item_created_tz"] forKey:@"shared_item_created_tz"];
                [paramDic setObject:[souceRs objectForColumnName:@"shared_item_modified_date"] forKey:@"shared_item_modified_date"];
                [paramDic setObject:[souceRs objectForColumnName:@"shared_item_modified_tz"] forKey:@"shared_item_modified_tz"];
                [paramDic setObject:[souceRs objectForColumnName:@"invitation_changed_properties"] forKey:@"invitation_changed_properties"];
                if (targetNum>=11) {
                    [paramDic setObject:@(1) forKey:@"default_alarm_removed"];

                }else{
                    [paramDic setObject:@(0) forKey:@"default_alarm_removed"];

                }
                [paramDic setObject:[souceRs objectForColumnName:@"phantom_master"] forKey:@"phantom_master"];
            }else {
                [paramDic setObject:[NSNull null] forKey:@"display_order"];
                [paramDic setObject:[NSNull null] forKey:@"created_by_id"];
                [paramDic setObject:[NSNull null] forKey:@"modified_by_id"];
                [paramDic setObject:[NSNull null] forKey:@"shared_item_created_date"];
                [paramDic setObject:[NSNull null] forKey:@"shared_item_created_tz"];
                [paramDic setObject:[NSNull null] forKey:@"shared_item_modified_date"];
                [paramDic setObject:[NSNull null] forKey:@"shared_item_modified_tz"];
                [paramDic setObject:[NSNull null] forKey:@"invitation_changed_properties"];
                if (targetNum>=11) {
                    [paramDic setObject:@(1) forKey:@"default_alarm_removed"];
                    
                }else{
                    [paramDic setObject:@(0) forKey:@"default_alarm_removed"];
                    
                }
                [paramDic setObject:[NSNull null] forKey:@"phantom_master"];
            }
        }
        if (targetNum >= 7) {
            if (sourceNum >= 7) {
                [paramDic setObject:[souceRs objectForColumnName:@"participation_status_modified_date"] forKey:@"participation_status_modified_date"];
            }else {
                [paramDic setObject:[NSNull null] forKey:@"participation_status_modified_date"];
            }
            if (targetNum >= 8) {
                if (sourceNum >= 8) {
                    [paramDic setObject:[souceRs objectForColumnName:@"calendar_scale"] forKey:@"calendar_scale"];
                    [paramDic setObject:[souceRs objectForColumnName:@"travel_time"] forKey:@"travel_time"];
                    [paramDic setObject:[souceRs objectForColumnName:@"travel_advisory_behavior"] forKey:@"travel_advisory_behavior"];
                    [paramDic setObject:[souceRs objectForColumnName:@"start_location_id"] forKey:@"start_location_id"];
                }else {
                    [paramDic setObject:[NSNull null] forKey:@"calendar_scale"];
                    [paramDic setObject:[NSNull null] forKey:@"travel_time"];
                    [paramDic setObject:[NSNull null] forKey:@"travel_advisory_behavior"];
                    [paramDic setObject:[NSNull null] forKey:@"start_location_id"];
                }
            }
        }
        
        if (targetNum<11) {
            [paramDic setObject:[NSNull null] forKey:@"conference"];
        }else{
            [paramDic setObject:@(0) forKey:@"suggested_event_info_id"];
            [paramDic setObject:@(1) forKey:@"can_forward"];
            [paramDic setObject:@(0) forKey:@"location_prediction_state"];
            [paramDic setObject:@(0) forKey:@"fired_ttl"];
            [paramDic setObject:@(0) forKey:@"disallow_propose_new_time"];
            [paramDic setObject:@(0) forKey:@"junk_status"];
        }
        BOOL reslut = [targetFMDB executeUpdate:insertStr withParameterDictionary:paramDic];
        [paramDic release];
        paramDic = nil;
        
        if (reslut) {
            NSString *sql3 = @"select last_insert_rowid() from CalendarItem";
            FMResultSet *rs = [targetFMDB executeQuery:sql3];
            while ([rs next]) {
                newID = [rs intForColumn:@"last_insert_rowid()"];
            }
            [rs close];
        }
    }
    [souceRs close];
    return newID;
}

- (void)insertScheduledTaskCacheRecord:(int)item withNewItemID:(int)newItemID withSourceFMDB:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB {
    NSString *sourceStr = @"SELECT day, date_for_sorting, completed, task_id, count FROM ScheduledTaskCache where task_id=:task_id;";
    NSDictionary *sourceParma = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:item], @"task_id", nil];
    
    NSString *targetStr = @"SELECT Count(day) FROM ScheduledTaskCache where task_id=:task_id";
    NSDictionary *targetParma = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:newItemID], @"task_id", nil];
    FMResultSet *tarRs = [targetFMDB executeQuery:targetStr withParameterDictionary:targetParma];
    while ([tarRs next]) {
        id scalarResult = [tarRs objectForColumnName:@"Count(day)"];
        if (scalarResult != nil) {
            int result = [scalarResult intValue];
            if (result == 0) {
                FMResultSet *sourceRs = [sourceFMDB executeQuery:sourceStr withParameterDictionary:sourceParma];
                while ([sourceRs next]) {
                    NSString *targetInsertStr = @"insert into ScheduledTaskCache(day, date_for_sorting, completed, task_id, count) values(:day, :date_for_sorting, :completed, :task_id, :count)";
                    NSMutableDictionary *parmaDic = [[NSMutableDictionary alloc] init];
                    [parmaDic setObject:[sourceRs objectForColumnName:@"day"] forKey:@"day"];
                    [parmaDic setObject:[sourceRs objectForColumnName:@"date_for_sorting"] forKey:@"date_for_sorting"];
                    [parmaDic setObject:[sourceRs objectForColumnName:@"completed"] forKey:@"completed"];
                    [parmaDic setObject:[sourceRs objectForColumnName:@"task_id"] forKey:@"task_id"];
                    [parmaDic setObject:[sourceRs objectForColumnName:@"count"] forKey:@"count"];
                    [targetFMDB executeUpdate:targetInsertStr withParameterDictionary:parmaDic];
                    
                    [parmaDic release];
                    parmaDic = nil;
                }
                [sourceRs close];
            }
        }
    }
    [tarRs close];
}

- (void)insertOccurrenceCacheRecord:(int)item withNewItemID:(int)newItemID withSourceFMDB:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB withCalendarDictionary:(NSDictionary *)sourceTargetCalendarIDs withStoreDictionary:(NSDictionary *)storeDIC{
    NSString *sourceStr = @"SELECT day, event_id, calendar_id, store_id, occurrence_date, occurrence_start_date, occurrence_end_date FROM OccurrenceCache where event_id=:event_id;";
    NSDictionary *sourceParma = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:item], @"event_id", nil];
    FMResultSet *sourceRs = [sourceFMDB executeQuery:sourceStr withParameterDictionary:sourceParma];
    while ([sourceRs next]) {
        int store_id = -1;
        int calendar_id = -1;
        NSString *targetStr = @"select rowid,store_id from calendar where rowid in (select calendar_id from CalendarItem where rowid=:rowid)";
        NSDictionary *targetParma = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:newItemID], @"rowid", nil];
        FMResultSet *tarRs = [targetFMDB executeQuery:targetStr withParameterDictionary:targetParma];
        while ([tarRs next]) {
            calendar_id = [tarRs intForColumn:@"rowid"];
            store_id = [tarRs intForColumn:@"store_id"];
        }
        [tarRs close];
        
        NSString *targetInsertStr = @"insert into OccurrenceCache(day, event_id, calendar_id, store_id, occurrence_date, occurrence_start_date, occurrence_end_date) values(:day, :event_id, :calendar_id, :store_id, :occurrence_date, :occurrence_start_date, :occurrence_end_date)";
        
        NSMutableDictionary *parmaDic = [[NSMutableDictionary alloc] init];
        [parmaDic setObject:[sourceRs objectForColumnName:@"day"] forKey:@"day"];
        [parmaDic setObject:@(newItemID) forKey:@"event_id"];
        id calenderID = [sourceTargetCalendarIDs objectForKey:[sourceRs objectForColumnName:@"calendar_id"]];
        [parmaDic setObject:calenderID?:[NSNull null] forKey:@"calendar_id"];
        id storeID = [storeDIC objectForKey:[sourceRs objectForColumnName:@"store_id"]];
        [parmaDic setObject:storeID?:[NSNull null] forKey:@"store_id"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"occurrence_date"] forKey:@"occurrence_date"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"occurrence_start_date"] forKey:@"occurrence_start_date"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"occurrence_end_date"] forKey:@"occurrence_end_date"];
        [targetFMDB executeUpdate:targetInsertStr withParameterDictionary:parmaDic];
        
        [parmaDic release];
        parmaDic = nil;
    }
    [sourceRs close];
}

- (void)insertRecurrenceRecord:(int)item withNewItemID:(int)newItemID withSourceFMDB:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB {
    NSString *sourceStr = @"SELECT ROWID, frequency, interval, week_start, count, cached_end_date, cached_end_date_tz, end_date, specifier, by_month_months, owner_id, external_id, external_mod_tag, external_id_tag, external_rep, UUID FROM Recurrence where owner_id=:owner_id;";
    NSDictionary *sourceParma = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:item], @"owner_id", nil];
    FMResultSet *sourceRs = [sourceFMDB executeQuery:sourceStr withParameterDictionary:sourceParma];
    while ([sourceRs next]) {
        NSString *insertStr = @"insert into Recurrence (frequency, interval, week_start, count, cached_end_date, cached_end_date_tz, end_date, specifier, by_month_months, owner_id, external_id, external_mod_tag, external_id_tag, external_rep, UUID) values( :frequency, :interval, :week_start, :count, :cached_end_date, :cached_end_date_tz, :end_date, :specifier, :by_month_months, :owner_id, :external_id, :external_mod_tag, :external_id_tag, :external_rep, :UUID)";
        
        NSMutableDictionary *parmaDic = [[NSMutableDictionary alloc] init];
        [parmaDic setObject:[sourceRs objectForColumnName:@"frequency"] forKey:@"frequency"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"interval"] forKey:@"interval"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"week_start"] forKey:@"week_start"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"count"] forKey:@"count"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"cached_end_date"] forKey:@"cached_end_date"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"cached_end_date_tz"] forKey:@"cached_end_date_tz"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"end_date"] forKey:@"end_date"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"specifier"] forKey:@"specifier"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"by_month_months"] forKey:@"by_month_months"];
        [parmaDic setObject:@(newItemID) forKey:@"owner_id"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"external_id"] forKey:@"external_id"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"external_mod_tag"] forKey:@"external_mod_tag"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"external_id_tag"] forKey:@"external_id_tag"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"external_rep"] forKey:@"external_rep"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"UUID"] forKey:@"UUID"];
        [targetFMDB executeUpdate:insertStr withParameterDictionary:parmaDic];
        
        [parmaDic release];
        parmaDic = nil;
    }
    [sourceRs close];
}

- (void)insertLocationRecord:(int)item withNewItemID:(int)newItemID  withSourceFMDB:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB alarmID:(int)alarmID {
    NSString *IOS8SelectStr = @"SELECT ROWID, title, address, latitude, longitude, address_book_id, radius,routing, item_owner_id, alarm_owner_id FROM Location where item_owner_id=:item_owner_id;";
    NSString *IOS6SelectStr = @"SELECT ROWID, title, latitude, longitude, address_book_id, radius, item_owner_id, alarm_owner_id FROM Location where item_owner_id=:item_owner_id;";
    
    int sourceNum = _sourceVersion;
    int targetNum = _targetVersion;
    
    NSString *selectStr = @"";
    if (sourceNum >= 8) { selectStr = IOS8SelectStr; }
    else { selectStr = IOS6SelectStr; }
    
    NSString *IOS8InsertStr = @"insert into Location( title, address, latitude, longitude, address_book_id, radius,routing, item_owner_id, alarm_owner_id) values( :title, :address, :latitude, :longitude, :address_book_id, :radius,:routing, :item_owner_id, :alarm_owner_id)";
    NSString *IOS6InsertStr = @"insert into Location( title,  latitude, longitude, address_book_id, radius, item_owner_id, alarm_owner_id) values( :title, :latitude, :longitude, :address_book_id, :radius, :item_owner_id, :alarm_owner_id)";
    
    NSDictionary *sourceParma = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:item], @"item_owner_id", nil];
    FMResultSet *sourceRs = [sourceFMDB executeQuery:selectStr withParameterDictionary:sourceParma];
    BOOL isexists = NO;
    while ([sourceRs next]) {
        isexists = YES;
        NSString *insertStr = @"";
        if (targetNum >= 8) { insertStr = IOS8InsertStr; }
        else{ insertStr = IOS6InsertStr; }
        NSMutableDictionary *parmaDic = [[NSMutableDictionary alloc] init];
        [parmaDic setObject:[sourceRs objectForColumnName:@"title"] forKey:@"title"];
        if (targetNum >= 8) {
            if (sourceNum >= 8) {
                [parmaDic setObject:[sourceRs objectForColumnName:@"address"] forKey:@"address"];
            }else{
                [parmaDic setObject:[NSNull null] forKey:@"address"];
            }
        }
        [parmaDic setObject:[sourceRs objectForColumnName:@"latitude"] forKey:@"latitude"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"longitude"] forKey:@"longitude"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"address_book_id"] forKey:@"address_book_id"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"radius"] forKey:@"radius"];
        if (targetNum >= 8) {
            if (sourceNum >= 8) {
                [parmaDic setObject:[sourceRs objectForColumnName:@"routing"] forKey:@"routing"];
            }else {
                [parmaDic setObject:[NSNull null] forKey:@"routing"];
            }
        }
        [parmaDic setObject:@(newItemID) forKey:@"item_owner_id"];
        [parmaDic setObject:@(0) forKey:@"alarm_owner_id"];
        if ([targetFMDB executeUpdate:insertStr withParameterDictionary:parmaDic]) {
            NSString *sql3 = @"select last_insert_rowid() from Calendar";
            FMResultSet *rs = [targetFMDB executeQuery:sql3];
            id rowNewObject = nil;
            while ([rs next]) {
                rowNewObject = [rs objectForColumnName:@"last_insert_rowid()"];
            }
            [rs close];
            if (rowNewObject) {
                NSString *sql = @"update CalendarItem set location_id=:location_id where ROWID=:ROWID";
                [targetFMDB executeUpdate:sql withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:rowNewObject,@"location_id",@(newItemID),@"ROWID",nil]];
            }
        }
        [parmaDic release];
        parmaDic = nil;
    }
    [sourceRs close];
    if (!isexists) {
        NSString *selectStr = nil;
        if (sourceNum >= 8) {
            if ([self checkCalendarItemOwnerIdExist:sourceFMDB]) {
                selectStr = @"SELECT aa.ROWID, aa.title, aa.address, aa.latitude, aa.longitude, aa.address_book_id, aa.radius,aa.routing, aa.item_owner_id, aa.alarm_owner_id,bb.calendaritem_owner_id FROM Location as aa left join Alarm as bb on aa.alarm_owner_id=bb.ROWID where bb.calendaritem_owner_id = :sourceitemID";
            }else{
                selectStr = @"SELECT aa.ROWID, aa.title, aa.address, aa.latitude, aa.longitude, aa.address_book_id, aa.radius,aa.routing, aa.item_owner_id, aa.alarm_owner_id,bb.owner_id FROM Location as aa left join Alarm as bb on aa.alarm_owner_id=bb.ROWID where bb.owner_id = :sourceitemID";
            }
        }else{
            selectStr = @"SELECT aa.ROWID, aa.title, aa.latitude, aa.longitude, aa.address_book_id, aa.radius, aa.item_owner_id, aa.alarm_owner_id,bb.owner_id FROM Location as aa left join Alarm as bb on aa.alarm_owner_id=bb.ROWID where bb.owner_id = :sourceitemID";
        }
        NSDictionary *sourceParma = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:item], @"sourceitemID", nil];
        FMResultSet *sourceRs = [sourceFMDB executeQuery:selectStr withParameterDictionary:sourceParma];
        while ([sourceRs next]) {
            NSString *insertStr = @"";
            if (targetNum >= 8) { insertStr = IOS8InsertStr; }
            else { insertStr = IOS6InsertStr; }
            NSMutableDictionary *parmaDic = [[NSMutableDictionary alloc] init];
            [parmaDic setObject:[sourceRs objectForColumnName:@"title"] forKey:@"title"];
            if (targetNum >= 8) {
                if (sourceNum >= 8) {
                    [parmaDic setObject:[sourceRs objectForColumnName:@"address"] forKey:@"address"];
                }else {
                    [parmaDic setObject:[NSNull null] forKey:@"address"];
                }
            }
            [parmaDic setObject:[sourceRs objectForColumnName:@"latitude"] forKey:@"latitude"];
            [parmaDic setObject:[sourceRs objectForColumnName:@"longitude"] forKey:@"longitude"];
            [parmaDic setObject:[sourceRs objectForColumnName:@"address_book_id"] forKey:@"address_book_id"];
            [parmaDic setObject:[sourceRs objectForColumnName:@"radius"] forKey:@"radius"];
            if (targetNum >= 8) {
                if (sourceNum >= 8) {
                    [parmaDic setObject:[sourceRs objectForColumnName:@"routing"] forKey:@"routing"];
                }else {
                    [parmaDic setObject:[NSNull null] forKey:@"routing"];
                }
            }
            [parmaDic setObject:@(0) forKey:@"item_owner_id"];
            [parmaDic setObject:@(alarmID) forKey:@"alarm_owner_id"];
            if ([targetFMDB executeUpdate:insertStr withParameterDictionary:parmaDic]) {
                NSString *sql3 = @"select last_insert_rowid() from Calendar";
                FMResultSet *rs = [targetFMDB executeQuery:sql3];
                id rowNewObject = nil;
                while ([rs next]) {
                    rowNewObject = [rs objectForColumnName:@"last_insert_rowid()"];
                }
                [rs close];
                //更新alarm
                NSString *updateAlarm = nil;
                updateAlarm = @"update Alarm set location_id=:loactionID where ROWID=:alarmID";
                [targetFMDB executeUpdate:updateAlarm withParameterDictionary:[NSDictionary dictionaryWithObjectsAndKeys:rowNewObject?:@(0),@"loactionID",@(alarmID),@"alarmID", nil]];
            }
            [parmaDic release];
            parmaDic = nil;
        }
        [sourceRs close];
    }
}

- (void)insertCategoryLinkRecord:(int)item withNewItemID:(int)newItemID withSourceFMDB:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB withCategoryDictionary:(NSDictionary *)sourceTargetCategoryIDs{
    NSString *selectStr = @"SELECT ROWID, owner_id, category_id FROM CategoryLink where owner_id=:owner_id;";
    NSDictionary *sourceParma = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:item], @"owner_id", nil];
    FMResultSet *sourceRs = [sourceFMDB executeQuery:selectStr withParameterDictionary:sourceParma];
    while ([sourceRs next]) {
        NSString *insertStr = @"insert into CategoryLink(owner_id, category_id) values(:owner_id, :category_id )";
        NSMutableDictionary *parmaDic = [[NSMutableDictionary alloc] init];
        [parmaDic setObject:@(newItemID) forKey:@"owner_id"];
        id categoryid = [sourceTargetCategoryIDs objectForKey:[sourceRs objectForColumnName:@"category_id"]];
        [parmaDic setObject:categoryid?:[NSNull null] forKey:@"category_id"];
        [targetFMDB executeUpdate:insertStr withParameterDictionary:parmaDic];
        [parmaDic release];
        parmaDic = nil;
    }
    [sourceRs close];
}

- (int)insertAlarmRecord:(int)item withNewItemID:(int)newItemID  withSourceFMDB:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB {
    int newAlarmId = 0;
    NSString *selectStrNine = @"SELECT ROWID, trigger_date, trigger_interval, type, calendar_owner_id,calendaritem_owner_id, external_id, external_mod_tag, external_id_tag, external_rep, UUID, proximity, disabled, location_id, acknowledgedDate, default_alarm, orig_alarm_id FROM Alarm where calendaritem_owner_id=:owner_id;";
    NSString *commonSelectStr = @"SELECT ROWID, trigger_date, trigger_interval, type, owner_id, external_id, external_mod_tag, external_id_tag, external_rep, UUID, proximity, disabled, location_id, acknowledgedDate, default_alarm, orig_alarm_id FROM Alarm where owner_id=:owner_id;";
    NSString *IOS5SelectStr = @"SELECT ROWID, trigger_date, trigger_interval, type, owner_id, external_id, external_mod_tag, external_id_tag, external_rep, UUID, proximity, disabled, location_id FROM Alarm where owner_id=:owner_id;";
    
    NSString *nineInsertStr = @"insert into Alarm ( trigger_date, trigger_interval, type, calendar_owner_id,calendaritem_owner_id, external_id, external_mod_tag, external_id_tag, external_rep, UUID, proximity, disabled, location_id, acknowledgedDate, default_alarm, orig_alarm_id) values( :trigger_date, :trigger_interval, :type, :calendar_owner_id, :calendaritem_owner_id, :external_id, :external_mod_tag, :external_id_tag, :external_rep,:UUID, :proximity, :disabled, :location_id, :acknowledgedDate, :default_alarm, :orig_alarm_id )";
    NSString *commonInsertStr = @"insert into Alarm ( trigger_date, trigger_interval, type, owner_id, external_id, external_mod_tag, external_id_tag, external_rep, UUID, proximity, disabled, location_id, acknowledgedDate, default_alarm, orig_alarm_id) values( :trigger_date, :trigger_interval, :type, :owner_id, :external_id, :external_mod_tag, :external_id_tag, :external_rep, :UUID, :proximity, :disabled, :location_id, :acknowledgedDate, :default_alarm, :orig_alarm_id )";
    NSString *IOS5InsertStr = @"insert into Alarm ( trigger_date, trigger_interval, type, owner_id, external_id, external_mod_tag, external_id_tag, external_rep, UUID, proximity, disabled, location_id) values( :trigger_date, :trigger_interval, :type, :owner_id, :external_id, :external_mod_tag, :external_id_tag, :external_rep, :UUID, :proximity, :disabled, :location_id)";
    
    int sourceNum = _sourceVersion;
    int targetNum = _targetVersion;
    
    NSString *sourceStr = @"";
    NSDictionary *sourceParma = nil;
    if (sourceNum == 5) {
        sourceStr = IOS5SelectStr;
        sourceParma = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:item], @"owner_id", nil];
    }else if ([self checkCalendarItemOwnerIdExist:sourceFMDB]) {
        sourceStr = selectStrNine;
        sourceParma = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:item], @"owner_id", nil];
    }else {
        sourceStr = commonSelectStr;
        sourceParma = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:item], @"owner_id", nil];
    }
    
    FMResultSet *sourceRs = [sourceFMDB executeQuery:sourceStr withParameterDictionary:sourceParma];
    while ([sourceRs next]) {
        NSString *insertStr = @"";
        if (targetNum == 5) { insertStr = IOS5InsertStr; }
        else if (targetNum >= 9) { insertStr = nineInsertStr; }
        else { insertStr = commonInsertStr; }
        NSMutableDictionary *parmaDic = [[NSMutableDictionary alloc] init];
        [parmaDic setObject:[sourceRs objectForColumnName:@"trigger_date"] forKey:@"trigger_date"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"trigger_interval"] forKey:@"trigger_interval"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"type"] forKey:@"type"];
        if ([self checkCalendarItemOwnerIdExist:targetFMDB]) {
            [parmaDic setObject:[NSNumber numberWithInt:-1] forKey:@"calendar_owner_id"];
            [parmaDic setObject:[NSNumber numberWithInt:newItemID] forKey:@"calendaritem_owner_id"];
        }else {
            [parmaDic setObject:[NSNumber numberWithInt:newItemID] forKey:@"owner_id"];
        }
        [parmaDic setObject:[sourceRs objectForColumnName:@"external_id"] forKey:@"external_id"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"external_mod_tag"] forKey:@"external_mod_tag"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"external_id_tag"] forKey:@"external_id_tag"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"external_rep"] forKey:@"external_rep"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"UUID"] forKey:@"UUID"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"proximity"] forKey:@"proximity"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"disabled"] forKey:@"disabled"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"location_id"] forKey:@"location_id"];
        if (targetNum >= 6) {
            if (sourceNum >= 6) {
                [parmaDic setObject:[sourceRs objectForColumnName:@"acknowledgedDate"] forKey:@"acknowledgedDate"];
                [parmaDic setObject:[sourceRs objectForColumnName:@"default_alarm"] forKey:@"default_alarm"];
                [parmaDic setObject:[sourceRs objectForColumnName:@"orig_alarm_id"] forKey:@"orig_alarm_id"];
            }else {
                [parmaDic setObject:[NSNull null] forKey:@"acknowledgedDate"];
                [parmaDic setObject:[NSNull null] forKey:@"default_alarm"];
                [parmaDic setObject:[NSNull null] forKey:@"orig_alarm_id"];
            }
        }
        if ([targetFMDB executeUpdate:insertStr withParameterDictionary:parmaDic]) {
            NSString *sql3 = @"select last_insert_rowid() from Alarm";
            FMResultSet *rs1 = [targetFMDB executeQuery:sql3];
            while ([rs1 next]) {
                newAlarmId = [rs1 intForColumn:@"last_insert_rowid()"];
            }
            [rs1 close];
        }
        [parmaDic release];
        parmaDic = nil;
    }
    [sourceRs close];
    return newAlarmId;
}

- (BOOL)checkCalendarItemOwnerIdExist:(FMDatabase *)targetDB
{
    NSString *sql = @"select name from sqlite_master where name = 'Alarm' and sql like '%calendaritem_owner_id%'";
    FMResultSet *set = [targetDB executeQuery:sql];
    NSString *name = nil;
    while ([set next]) {
        name = [set stringForColumn:@"name"];
    }
    if (name) {
        return YES;
    }else{
        return NO;
    }
    [set close];
}

- (void)insertExceptionDateRecord:(int)item withNewItemID:(int)newItemID withSourceFMDB:(FMDatabase *)sourceFMDB withTargetFmdb:(FMDatabase *)targetFMDB {
    NSString *sourceStr = @"SELECT date, sync_order FROM ExceptionDate where owner_id=:owner_id;";
    NSDictionary *sourceParma = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:item], @"owner_id", nil];
    FMResultSet *sourceRs = [sourceFMDB executeQuery:sourceStr withParameterDictionary:sourceParma];
    while ([sourceRs next]) {
        NSString *insertStr = @"insert into ExceptionDate (owner_id,date, sync_order)values(:owner_id, :date, :sync_order)";
        NSMutableDictionary *parmaDic = [[NSMutableDictionary alloc] init];
        [parmaDic setObject:[NSNumber numberWithInt:newItemID] forKey:@"owner_id"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"date"] forKey:@"date"];
        [parmaDic setObject:[sourceRs objectForColumnName:@"sync_order"] forKey:@"sync_order"];
        
        [targetFMDB executeUpdate:insertStr withParameterDictionary:parmaDic];
        [parmaDic release];
        parmaDic = nil;
    }
    [sourceRs close];
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

#pragma mark - Clone
- (void)clone
{
    [_logHandle writeInfoLog:@"clone calender enter"];
    if (_sourceVersion<=_targetVersion) {
        int version = _sourceVersion;
        _sourceVersion = _targetVersion;
        _targetVersion = version;
        if ([_sourceFloatVersion isVersionLessEqual:_targetFloatVersion]) {
            if (isneedClone) {
                return;
            }
            IMBMBFileRecord *record = sourceRecord;
            sourceRecord = targetRecord;
            targetRecord = record;
            
            NSString *backupPath = _sourceBackuppath;
            _sourceBackuppath = _targetBakcuppath;
            _targetBakcuppath = backupPath;
            
            NSString *sqlitePath = _sourceSqlitePath;
            _sourceSqlitePath = _targetSqlitePath;
            _targetSqlitePath = sqlitePath;
            
            NSMutableArray *recordArray = _sourcerecordArray;
            _sourcerecordArray = _targetrecordArray;
            _targetrecordArray = recordArray;
            
            FMDatabase *dataCo = _sourceManifestDBConnection;
            _sourceManifestDBConnection = _targetManifestDBConnection;
            _targetManifestDBConnection = dataCo;
            
            NSString *version = _sourceFloatVersion;
            _sourceFloatVersion = _targetFloatVersion;
            _targetFloatVersion = version;

        }else
        {
            if (!isneedClone) {
                return;
            }
        }
        
    }else
    {
        if (!isneedClone) {
            return;
        }
    }
    //主要包括iOS8->iOS7,iOS6;iOS7->iOS6
    @try {
        if ([self openDataBase:_sourceDBConnection]&& [self openDataBase:_targetDBConnection]) {
            [_sourceDBConnection beginTransaction];
            [_targetDBConnection beginTransaction];
            [self deleteCalendarData];
            [self insertAlarmChanges];
            [self insertAttachment];
            [self insertAttachmentChanges];
            [self insertCalendarItemChanges];
            [self insertCategory];
            [self insertCategoryLink];
            [self insertEventAction];
            [self insertEventActionChanges];
            [self insertExceptionDate];
            //[self insertIdentity];此表ios5不一样
            //[self insertNotification];此表ios5不存在
            //[self insertNotificationChanges];此表ios5不存在
            [self insertOccurrenceCache];
            [self insertOccurrenceCacheDays];
            [self insertRecurrence];
            [self insertRecurrenceChanges];
            //[self insertResourceChange];没有
            //[self insertSharee];没有
            //[self insertShareeChanges];没有
            if (_targetVersion<=5) {
                [self insertAlarmWithiOS5];
                [self insertCalendarChangesWithiOS5];
                [self insertCalendarItemWithiOS5];
            }else
            {
                [self insertAlarm];
                [self insertCalendarChanges];
                [self insertCalendarItem];
                [self insertIdentity];
                [self insertNotification];
                [self insertNotificationChanges];
                [self insertResourceChange];
                [self insertSharee];
                [self insertShareeChanges];
            }
            
            
            if (_targetVersion>=7) {
                [self insertCalendarWithiOS7];
                [self insertLocationWithiOS7];
                [self insertParticipantWithiOS7];
                [self insertParticipantChangesWithiOS7];
                [self insertStoreWithiOS7];
            }else if (_targetVersion==6)
            {
                [self insertCalendarWithiOS6];
                [self insertLocationWithiOS6];
                [self insertParticipantWithiOS6];
                [self insertParticipantChangesWithiOS6];
                [self insertStoreWithiOS6];
            }else if (_targetVersion==5)
            {
                [self insertCalendarWithiOS5];
                [self insertLocationWithiOS6];
                [self insertParticipantWithiOS5];
                [self insertParticipantChangesWithiOS5];
                [self insertStoreWithiOS6];
                
            }
        }
        if (![_sourceDBConnection commit]) {
            [_sourceDBConnection rollback];
        }
        if (![_targetDBConnection commit]) {
            [_targetDBConnection rollback];
        }
        [self closeDataBase:_sourceDBConnection];
        [self closeDataBase:_targetDBConnection];
    }
    @catch (NSException *exception) {
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"异常原因:%@",exception]];
    }
    [_logHandle writeInfoLog:@"clone calender exit"];
    //修改HashandManifest
    [self modifyHashAndManifest];
}

- (void)deleteCalendarData
{
    NSString *sql1 = @"delete from CalendarItem";
    NSString *sql2 = @"delete from Location";
    NSString *sql3 = @"delete from Calendar";
    NSString *sql4 = @"delete from Alarm";
    NSString *sql5 = @"delete from Recurrence";
    NSString *sql6 = @"delete from Store";
    NSString *sql7 = @"delete from OccurrenceCache";
    NSString *sql8 = @"delete from Category";
    NSString *sql9 = @"delete from CategoryLink";
    NSString *sql10 = @"delete from EventAction";
    NSString *sql11 = @"delete from ExceptionDate";
    NSString *sql12 = @"delete from OccurrenceCache";
    NSString *sql13 = @"delete from Recurrence";
    [_targetDBConnection executeUpdate:sql1];
    [_targetDBConnection executeUpdate:sql2];
    [_targetDBConnection executeUpdate:sql3];
    [_targetDBConnection executeUpdate:sql4];
    [_targetDBConnection executeUpdate:sql5];
    [_targetDBConnection executeUpdate:sql6];
    [_targetDBConnection executeUpdate:sql7];
    [_targetDBConnection executeUpdate:sql8];
    [_targetDBConnection executeUpdate:sql9];
    [_targetDBConnection executeUpdate:sql10];
    [_targetDBConnection executeUpdate:sql11];
    [_targetDBConnection executeUpdate:sql12];
    [_targetDBConnection executeUpdate:sql13];
    
}
//表Alarm
- (void)insertAlarm
{
    [_logHandle writeInfoLog:@"insert Calendar table Alarm enter"];
    NSString *sql1 = @"select * from Alarm";
    NSString *sql2 = nil;
    if (_targetVersion>=9) {
       
        sql2 = @"insert into Alarm(ROWID,trigger_date,trigger_interval,type,calendaritem_owner_id,calendar_owner_id,external_id,external_mod_tag,external_id_tag,external_rep,UUID,proximity,disabled,location_id,acknowledgedDate,default_alarm,orig_alarm_id) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }else
    {
        sql2 = @"insert into Alarm(ROWID,trigger_date,trigger_interval,type,owner_id,external_id,external_mod_tag,external_id_tag,external_rep,UUID,proximity,disabled,location_id,acknowledgedDate,default_alarm,orig_alarm_id) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        double trigger_date = [rs doubleForColumn:@"trigger_date"];
        NSInteger trigger_interval = [rs intForColumn:@"trigger_interval"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        if (_sourceVersion>=9) {
            owner_id = [rs intForColumn:@"calendaritem_owner_id"];
        }
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *external_mod_tag = [rs stringForColumn:@"external_mod_tag"];
        NSString *external_id_tag = [rs stringForColumn:@"external_id_tag"];
        NSData *external_rep = [rs dataForColumn:@"external_rep"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSInteger proximity = [rs intForColumn:@"proximity"];
        NSInteger disabled = [rs intForColumn:@"disabled"];
        NSInteger location_id = [rs intForColumn:@"location_id"];
        double acknowledgedDate = [rs doubleForColumn:@"acknowledgedDate"];
        NSInteger default_alarm = [rs intForColumn:@"default_alarm"];
        NSInteger orig_alarm_id = [rs intForColumn:@"orig_alarm_id"];
        if (_targetVersion>=9) {
             [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithDouble:trigger_date],[NSNumber numberWithInt:trigger_interval],[NSNumber numberWithInt:type],[NSNumber numberWithInt:owner_id],[NSNumber numberWithInt:1],external_id,external_mod_tag,external_id_tag,external_rep,UUID,[NSNumber numberWithInt:proximity],[NSNumber numberWithInt:disabled],[NSNumber numberWithInt:location_id],[NSNumber numberWithDouble:acknowledgedDate],[NSNumber numberWithInt:default_alarm],[NSNumber numberWithInt:orig_alarm_id]];
        }else
        {
             [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithDouble:trigger_date],[NSNumber numberWithInt:trigger_interval],[NSNumber numberWithInt:type],[NSNumber numberWithInt:owner_id],external_id,external_mod_tag,external_id_tag,external_rep,UUID,[NSNumber numberWithInt:proximity],[NSNumber numberWithInt:disabled],[NSNumber numberWithInt:location_id],[NSNumber numberWithDouble:acknowledgedDate],[NSNumber numberWithInt:default_alarm],[NSNumber numberWithInt:orig_alarm_id]];
        }
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Alarm exit"];
}

- (void)insertAlarmWithiOS5
{
    [_logHandle writeInfoLog:@"insert Calendar table Alarm iOS5 enter"];
    NSString *sql1 = @"select * from Alarm";
    NSString *sql2 = @"insert into Alarm(ROWID,trigger_date,trigger_interval,type,owner_id,external_id,external_mod_tag,external_id_tag,external_rep,UUID,proximity,disabled,location_id) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        double trigger_date = [rs doubleForColumn:@"trigger_date"];
        NSInteger trigger_interval = [rs intForColumn:@"trigger_interval"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *external_mod_tag = [rs stringForColumn:@"external_mod_tag"];
        NSString *external_id_tag = [rs stringForColumn:@"external_id_tag"];
        NSData *external_rep = [rs dataForColumn:@"external_rep"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSInteger proximity = [rs intForColumn:@"proximity"];
        NSInteger disabled = [rs intForColumn:@"disabled"];
        NSInteger location_id = [rs intForColumn:@"location_id"];
//        double acknowledgedDate = [rs doubleForColumn:@"acknowledgedDate"];
//        NSInteger default_alarm = [rs intForColumn:@"default_alarm"];
//        NSInteger orig_alarm_id = [rs intForColumn:@"orig_alarm_id"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithDouble:trigger_date],[NSNumber numberWithInt:trigger_interval],[NSNumber numberWithInt:type],[NSNumber numberWithInt:owner_id],external_id,external_mod_tag,external_id_tag,external_rep,UUID,[NSNumber numberWithInt:proximity],[NSNumber numberWithInt:disabled],[NSNumber numberWithInt:location_id]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Alarm iOS5 exit"];
}
//表AlarmChanges
- (void)insertAlarmChanges
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table AlarmChanges enter"];
    NSString *sql1 = @"select * from AlarmChanges";
    NSString *sql2 = @"insert into AlarmChanges(record,type,owner_id,external_id,store_id,calendar_id,UUID) values(?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger record = [rs intForColumn:@"record"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record],[NSNumber numberWithInt:type],[NSNumber numberWithInt:owner_id],external_id,[NSNumber numberWithInt:store_id],[NSNumber numberWithInt:calendar_id],UUID];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table AlarmChanges exit"];
}

- (void)insertAttachment
{
    [_logHandle writeInfoLog:@"insert Calendar table Attachment enter"];
    NSString *sql1 = @"select * from Attachment";
    NSString *sql2 = @"insert into Attachment(ROWID,owner_id,external_id,external_mod_tag,external_rep,url,UUID,data,format,is_binary,filename,local_url,file_size) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *external_mod_tag = [rs stringForColumn:@"external_mod_tag"];
        NSData *external_rep = [rs dataForColumn:@"external_rep"];
        NSString *url = [rs stringForColumn:@"url"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSData *data = [rs dataForColumn:@"data"];
        NSString *format = [rs stringForColumn:@"format"];
        NSInteger is_binary = [rs intForColumn:@"is_binary"];
        NSString *filename = [rs stringForColumn:@"filename"];
        NSString *local_url = [rs stringForColumn:@"local_url"];
        NSInteger file_size = [rs intForColumn:@"file_size"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:owner_id],external_id,external_mod_tag,external_rep,url,UUID,data,format,[NSNumber numberWithInt:is_binary],filename,local_url,[NSNumber numberWithInt:file_size]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Attachment exit"];
}

//表AttachmentChanges
- (void)insertAttachmentChanges
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table AttachmentChanges enter"];
    NSString *sql1 = @"select * from AttachmentChanges";
    NSString *sql2 = @"insert into AttachmentChanges(record,type,owner_id,external_id,external_mod_tag,UUID,store_id,calendar_id) values(?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger record = [rs intForColumn:@"record"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *external_mod_tag = [rs stringForColumn:@"external_mod_tag"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
      
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record],[NSNumber numberWithInt:type],[NSNumber numberWithInt:owner_id],external_id,external_mod_tag,UUID,[NSNumber numberWithInt:store_id],[NSNumber numberWithInt:calendar_id]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table AttachmentChanges exit"];
}

//表Calendar
- (void)insertCalendarWithiOS7
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table Calendar iOS7 enter"];
    NSString *sql1 = @"select * from Calendar";
    NSString *sql2 = @"insert into Calendar(ROWID,store_id,title,flags,color,symbolic_color_name,color_is_display,type,supported_entity_types,external_id,external_mod_tag,external_id_tag,external_rep,display_order,UUID,shared_owner_name,sharing_status,sharing_invitation_response,published_URL,is_published,invitation_status,sync_token,self_identity_id,self_identity_email,owner_identity_id,owner_identity_email,notes,bulk_requests,subcal_account_id,push_key,digest) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        NSString *title = [rs stringForColumn:@"title"];
        NSInteger flags = [rs intForColumn:@"flags"];
        NSString *color = [rs stringForColumn:@"color"];
        NSString *symbolic_color_name = [rs stringForColumn:@"symbolic_color_name"];
        NSInteger color_is_display = [rs intForColumn:@"color_is_display"];
        NSString *type = [rs stringForColumn:@"type"];
        NSInteger supported_entity_types = [rs intForColumn:@"supported_entity_types"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *external_mod_tag = [rs stringForColumn:@"external_mod_tag"];
        NSString *external_id_tag = [rs stringForColumn:@"external_id_tag"];
        NSData *external_rep = [rs dataForColumn:@"external_rep"];
        NSInteger display_order = [rs intForColumn:@"display_order"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSString *shared_owner_name = [rs stringForColumn:@"shared_owner_name"];
        NSInteger sharing_status = [rs intForColumn:@"sharing_status"];
        NSInteger sharing_invitation_response = [rs intForColumn:@"sharing_invitation_response"];
        NSString *published_URL = [rs stringForColumn:@"published_URL"];
        NSInteger is_published = [rs intForColumn:@"is_published"];
        NSInteger invitation_status = [rs intForColumn:@"invitation_status"];
        NSString *sync_token = [rs stringForColumn:@"sync_token"];
        NSInteger self_identity_id = [rs intForColumn:@"self_identity_id"];
        NSString *self_identity_email = [rs stringForColumn:@"self_identity_email"];
        NSInteger owner_identity_id = [rs intForColumn:@"owner_identity_id"];
        NSString *owner_identity_email = [rs stringForColumn:@"owner_identity_email"];
        NSString *notes = [rs stringForColumn:@"notes"];
        NSData *bulk_requests = [rs dataForColumn:@"bulk_requests"];
        NSString *subcal_account_id = [rs stringForColumn:@"subcal_account_id"];
        NSString *push_key = [rs stringForColumn:@"push_key"];
        NSData *digest = [rs dataForColumn:@"digest"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:store_id],title,[NSNumber numberWithInt:flags],color,symbolic_color_name,[NSNumber numberWithInt:color_is_display],type,[NSNumber numberWithInt:supported_entity_types],external_id,external_mod_tag,external_id_tag,external_rep,[NSNumber numberWithInt:display_order],UUID,shared_owner_name,[NSNumber numberWithInt:sharing_status],[NSNumber numberWithInt:sharing_invitation_response],published_URL,[NSNumber numberWithInt:is_published],[NSNumber numberWithInt:invitation_status],sync_token,[NSNumber numberWithInt:self_identity_id],self_identity_email,[NSNumber numberWithInt:owner_identity_id],owner_identity_email,notes,bulk_requests,subcal_account_id,push_key,digest];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Calendar iOS7 exit"];
}

- (void)insertCalendarWithiOS6
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table Calendar iOS6 enter"];
    NSString *sql1 = @"select * from Calendar";
    NSString *sql2 = @"insert into Calendar(ROWID,store_id,title,flags,color,color_is_display,type,supported_entity_types,external_id,external_mod_tag,external_id_tag,external_rep,display_order,UUID,shared_owner_name,sharing_status,sharing_invitation_response,published_URL,is_published,invitation_status,sync_token,self_identity_id,self_identity_email,owner_identity_id,owner_identity_email) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        NSString *title = [rs stringForColumn:@"title"];
        NSInteger flags = [rs intForColumn:@"flags"];
        NSString *color = [rs stringForColumn:@"color"];
        NSInteger color_is_display = [rs intForColumn:@"color_is_display"];
        NSString *type = [rs stringForColumn:@"type"];
        NSInteger supported_entity_types = [rs intForColumn:@"supported_entity_types"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *external_mod_tag = [rs stringForColumn:@"external_mod_tag"];
        NSString *external_id_tag = [rs stringForColumn:@"external_id_tag"];
        NSData *external_rep = [rs dataForColumn:@"external_rep"];
        NSInteger display_order = [rs intForColumn:@"display_order"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSString *shared_owner_name = [rs stringForColumn:@"shared_owner_name"];
        NSInteger sharing_status = [rs intForColumn:@"sharing_status"];
        NSInteger sharing_invitation_response = [rs intForColumn:@"sharing_invitation_response"];
        NSString *published_URL = [rs stringForColumn:@"published_URL"];
        NSInteger is_published = [rs intForColumn:@"is_published"];
        NSInteger invitation_status = [rs intForColumn:@"invitation_status"];
        NSString *sync_token = [rs stringForColumn:@"sync_token"];
        NSInteger self_identity_id = [rs intForColumn:@"self_identity_id"];
        NSString *self_identity_email = [rs stringForColumn:@"self_identity_email"];
        NSInteger owner_identity_id = [rs intForColumn:@"owner_identity_id"];
        NSString *owner_identity_email = [rs stringForColumn:@"owner_identity_email"];
       [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:store_id],title,[NSNumber numberWithInt:flags],color,[NSNumber numberWithInt:color_is_display],type,[NSNumber numberWithInt:supported_entity_types],external_id,external_mod_tag,external_id_tag,external_rep,[NSNumber numberWithInt:display_order],UUID,shared_owner_name,[NSNumber numberWithInt:sharing_status],[NSNumber numberWithInt:sharing_invitation_response],published_URL,[NSNumber numberWithInt:is_published],[NSNumber numberWithInt:invitation_status],sync_token,[NSNumber numberWithInt:self_identity_id],self_identity_email,[NSNumber numberWithInt:owner_identity_id],owner_identity_email];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Calendar iOS6 exit"];
}

- (void)insertCalendarWithiOS5
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table Calendar iOS5 enter"];
    NSString *sql1 = @"select * from Calendar";
    NSString *sql2 = @"insert into Calendar(ROWID,store_id,title,flags,color,color_is_display,type,supported_entity_types,external_id,external_mod_tag,external_id_tag,external_rep,display_order,UUID,shared_owner_name,sharing_status) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        NSString *title = [rs stringForColumn:@"title"];
        NSInteger flags = [rs intForColumn:@"flags"];
        NSString *color = [rs stringForColumn:@"color"];
        NSInteger color_is_display = [rs intForColumn:@"color_is_display"];
        NSString *type = [rs stringForColumn:@"type"];
        NSInteger supported_entity_types = [rs intForColumn:@"supported_entity_types"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *external_mod_tag = [rs stringForColumn:@"external_mod_tag"];
        NSString *external_id_tag = [rs stringForColumn:@"external_id_tag"];
        NSData *external_rep = [rs dataForColumn:@"external_rep"];
        NSInteger display_order = [rs intForColumn:@"display_order"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSString *shared_owner_name = [rs stringForColumn:@"shared_owner_name"];
        NSInteger sharing_status = [rs intForColumn:@"sharing_status"];
//        NSInteger sharing_invitation_response = [rs intForColumn:@"sharing_invitation_response"];
//        NSString *published_URL = [rs stringForColumn:@"published_URL"];
//        NSInteger is_published = [rs intForColumn:@"is_published"];
//        NSInteger invitation_status = [rs intForColumn:@"invitation_status"];
//        NSString *sync_token = [rs stringForColumn:@"sync_token"];
//        NSInteger self_identity_id = [rs intForColumn:@"self_identity_id"];
//        NSString *self_identity_email = [rs stringForColumn:@"self_identity_email"];
//        NSInteger owner_identity_id = [rs intForColumn:@"owner_identity_id"];
//        NSString *owner_identity_email = [rs stringForColumn:@"owner_identity_email"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:store_id],title,[NSNumber numberWithInt:flags],color,[NSNumber numberWithInt:color_is_display],type,[NSNumber numberWithInt:supported_entity_types],external_id,external_mod_tag,external_id_tag,external_rep,[NSNumber numberWithInt:display_order],UUID,shared_owner_name,[NSNumber numberWithInt:sharing_status]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Calendar iOS5 exit"];
    
}
//表CalendarChanges
- (void)insertCalendarChanges
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table CalendarChanges enter"];
    NSString *sql1 = @"select * from CalendarChanges";
    NSString *sql2 = @"insert into CalendarChanges(record,type,store_id,flags,external_id,external_id_tag,UUID) values(?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger record = [rs intForColumn:@"record"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        NSInteger flags = [rs intForColumn:@"flags"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *external_id_tag = [rs stringForColumn:@"external_id_tag"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
       [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record],[NSNumber numberWithInt:type],[NSNumber numberWithInt:store_id],[NSNumber numberWithInt:flags],external_id,external_id_tag,UUID];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table CalendarChanges exit"];
}

- (void)insertCalendarChangesWithiOS5
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table CalendarChanges enter"];
    NSString *sql1 = @"select * from CalendarChanges";
    NSString *sql2 = @"insert into CalendarChanges(record,type,store_id,external_id,external_id_tag,UUID) values(?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger record = [rs intForColumn:@"record"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *external_id_tag = [rs stringForColumn:@"external_id_tag"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record],[NSNumber numberWithInt:type],[NSNumber numberWithInt:store_id],external_id,external_id_tag,UUID];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table CalendarChanges exit"];
}

//表CalendarItem
- (void)insertCalendarItem
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table CalendarItem enter"];
    NSString *sql1 = @"select * from CalendarItem";
    NSString *insertSql = @"";
    if (_targetVersion>=11) {
        insertSql = @"insert into CalendarItem(ROWID,summary,location_id,description,start_date,start_tz,end_date,all_day,calendar_id,orig_item_id,orig_date,organizer_id,self_attendee_id,status,invitation_status,availability,privacy_level,url,last_modified,sequence_num,birthday_id,modified_properties,external_tracking_status,external_id,external_mod_tag,unique_identifier,external_schedule_id,external_rep,response_comment,hidden,has_recurrences,has_attendees,UUID,entity_type,priority,due_date,due_tz,due_all_day,completion_date,creation_date,display_order,created_by_id,modified_by_id,shared_item_created_date,shared_item_created_tz,shared_item_modified_date,shared_item_modified_tz,invitation_changed_properties,default_alarm_removed,phantom_master,suggested_event_info_id,can_forward,location_prediction_state,fired_ttl,disallow_propose_new_time,junk_status) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }else{
         insertSql = @"insert into CalendarItem(ROWID,summary,location_id,description,start_date,start_tz,end_date,all_day,calendar_id,orig_item_id,orig_date,organizer_id,self_attendee_id,status,invitation_status,availability,privacy_level,url,last_modified,sequence_num,birthday_id,modified_properties,external_tracking_status,external_id,external_mod_tag,unique_identifier,external_schedule_id,external_rep,response_comment,hidden,has_recurrences,has_attendees,UUID,entity_type,priority,due_date,due_tz,due_all_day,completion_date,creation_date,display_order,created_by_id,modified_by_id,shared_item_created_date,shared_item_created_tz,shared_item_modified_date,shared_item_modified_tz,invitation_changed_properties,default_alarm_removed,phantom_master) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }
    
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
       
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSString *summary = [rs stringForColumn:@"summary"];
        NSInteger location_id = [rs intForColumn:@"location_id"];
        NSString *description = [rs stringForColumn:@"description"];
        double start_date = [rs doubleForColumn:@"start_date"];
        NSString *start_tz = [rs stringForColumn:@"start_tz"];
        double end_date = [rs doubleForColumn:@"end_date"];
        NSInteger all_day = [rs intForColumn:@"all_day"];
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
        NSInteger orig_item_id = [rs intForColumn:@"orig_item_id"];
        double orig_date = [rs doubleForColumn:@"orig_date"];
        NSInteger organizer_id = [rs intForColumn:@"organizer_id"];
        NSInteger self_attendee_id = [rs intForColumn:@"self_attendee_id"];
        NSInteger status = [rs intForColumn:@"status"];
        NSInteger invitation_status = [rs intForColumn:@"invitation_status"];
        NSInteger availability = [rs intForColumn:@"availability"];
        NSInteger privacy_level = [rs intForColumn:@"privacy_level"];
        NSString *url = [rs stringForColumn:@"url"];
        double last_modified = [rs doubleForColumn:@"last_modified"];
        NSInteger sequence_num = [rs intForColumn:@"sequence_num"];
        NSInteger birthday_id = [rs intForColumn:@"birthday_id"];
        NSInteger modified_properties = [rs intForColumn:@"modified_properties"];
        NSInteger external_tracking_status = [rs intForColumn:@"external_tracking_status"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *external_mod_tag = [rs stringForColumn:@"external_mod_tag"];
        NSString *unique_identifier = [rs stringForColumn:@"unique_identifier"];
        NSString *external_schedule_id = [rs stringForColumn:@"external_schedule_id"];
        NSData *external_rep = [rs dataForColumn:@"external_rep"];
        NSString *response_comment = [rs stringForColumn:@"response_comment"];
        NSInteger hidden = [rs intForColumn:@"hidden"];
        NSInteger has_recurrences = [rs intForColumn:@"has_recurrences"];
        NSInteger has_attendees = [rs intForColumn:@"has_attendees"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSInteger entity_type = [rs intForColumn:@"entity_type"];
        NSInteger priority = [rs intForColumn:@"priority"];
        double due_date = [rs doubleForColumn:@"due_date"];
        NSString *due_tz = [rs stringForColumn:@"due_tz"];
        NSInteger due_all_day = [rs intForColumn:@"due_all_day"];
        double completion_date = [rs doubleForColumn:@"completion_date"];
        double creation_date = [rs doubleForColumn:@"creation_date"];
        NSInteger display_order = [rs intForColumn:@"display_order"];
        NSInteger created_by_id = [rs intForColumn:@"created_by_id"];
        NSInteger modified_by_id = [rs intForColumn:@"modified_by_id"];
        double shared_item_created_date = [rs doubleForColumn:@"shared_item_created_date"];
        NSString *shared_item_created_tz = [rs stringForColumn:@"shared_item_created_tz"];
        double shared_item_modified_date = [rs doubleForColumn:@"shared_item_modified_date"];
        NSString *shared_item_modified_tz = [rs stringForColumn:@"shared_item_modified_tz"];
        NSInteger invitation_changed_properties = [rs intForColumn:@"invitation_changed_properties"];
        NSInteger default_alarm_removed = [rs intForColumn:@"default_alarm_removed"];
        if (_targetVersion>=11) {
            default_alarm_removed = 1;
        }else{
            default_alarm_removed = 0;
        }
        NSInteger phantom_master = [rs intForColumn:@"phantom_master"];
        if (_targetVersion>=11) {
            [_targetDBConnection executeUpdate:insertSql,[NSNumber numberWithInt:ROWID],summary,[NSNumber numberWithInt:location_id],description,[NSNumber numberWithDouble:start_date],start_tz,[NSNumber numberWithDouble:end_date],[NSNumber numberWithInt:all_day],[NSNumber numberWithInt:calendar_id],[NSNumber numberWithInt:orig_item_id],[NSNumber numberWithDouble:orig_date],[NSNumber numberWithInt:organizer_id],[NSNumber numberWithInt:self_attendee_id],[NSNumber numberWithInt:status],[NSNumber numberWithInt:invitation_status],[NSNumber numberWithInt:availability],[NSNumber numberWithInt:privacy_level],url,[NSNumber numberWithDouble:last_modified],[NSNumber numberWithInt:sequence_num],[NSNumber numberWithInt:birthday_id],[NSNumber numberWithInt:modified_properties],[NSNumber numberWithInt:external_tracking_status],external_id,external_mod_tag,unique_identifier,external_schedule_id,external_rep,response_comment,[NSNumber numberWithInt:hidden],[NSNumber numberWithInt:has_recurrences],[NSNumber numberWithInt:has_attendees],UUID,[NSNumber numberWithInt:entity_type],[NSNumber numberWithInt:priority],[NSNumber numberWithDouble:due_date],due_tz,[NSNumber numberWithInt:due_all_day],[NSNumber numberWithDouble:completion_date],[NSNumber numberWithDouble:creation_date],[NSNumber numberWithInt:display_order],[NSNumber numberWithInt:created_by_id],[NSNumber numberWithInt:modified_by_id],[NSNumber numberWithDouble:shared_item_created_date],shared_item_created_tz,[NSNumber numberWithDouble:shared_item_modified_date],shared_item_modified_tz,[NSNumber numberWithInt:invitation_changed_properties],[NSNumber numberWithInt:default_alarm_removed],[NSNumber numberWithInt:phantom_master],@(0),@(1),@(0),@(0),@(0),@(0)];
        }else{
            [_targetDBConnection executeUpdate:insertSql,[NSNumber numberWithInt:ROWID],summary,[NSNumber numberWithInt:location_id],description,[NSNumber numberWithDouble:start_date],start_tz,[NSNumber numberWithDouble:end_date],[NSNumber numberWithInt:all_day],[NSNumber numberWithInt:calendar_id],[NSNumber numberWithInt:orig_item_id],[NSNumber numberWithDouble:orig_date],[NSNumber numberWithInt:organizer_id],[NSNumber numberWithInt:self_attendee_id],[NSNumber numberWithInt:status],[NSNumber numberWithInt:invitation_status],[NSNumber numberWithInt:availability],[NSNumber numberWithInt:privacy_level],url,[NSNumber numberWithDouble:last_modified],[NSNumber numberWithInt:sequence_num],[NSNumber numberWithInt:birthday_id],[NSNumber numberWithInt:modified_properties],[NSNumber numberWithInt:external_tracking_status],external_id,external_mod_tag,unique_identifier,external_schedule_id,external_rep,response_comment,[NSNumber numberWithInt:hidden],[NSNumber numberWithInt:has_recurrences],[NSNumber numberWithInt:has_attendees],UUID,[NSNumber numberWithInt:entity_type],[NSNumber numberWithInt:priority],[NSNumber numberWithDouble:due_date],due_tz,[NSNumber numberWithInt:due_all_day],[NSNumber numberWithDouble:completion_date],[NSNumber numberWithDouble:creation_date],[NSNumber numberWithInt:display_order],[NSNumber numberWithInt:created_by_id],[NSNumber numberWithInt:modified_by_id],[NSNumber numberWithDouble:shared_item_created_date],shared_item_created_tz,[NSNumber numberWithDouble:shared_item_modified_date],shared_item_modified_tz,[NSNumber numberWithInt:invitation_changed_properties],[NSNumber numberWithInt:default_alarm_removed],[NSNumber numberWithInt:phantom_master]];
        }
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table CalendarItem exit"];
}

- (void)insertCalendarItemWithiOS5
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table CalendarItem enter"];
    NSString *sql1 = @"select * from CalendarItem";
    NSString *sql2 = @"insert into CalendarItem(ROWID,summary,location_id,description,start_date,start_tz,end_date,all_day,calendar_id,orig_item_id,orig_date,organizer_id,self_attendee_id,status,invitation_status,availability,privacy_level,url,last_modified,sequence_num,birthday_id,modified_properties,external_tracking_status,external_id,external_mod_tag,unique_identifier,external_schedule_id,external_rep,response_comment,hidden,has_recurrences,has_attendees,UUID,entity_type,priority,due_date,due_tz,due_all_day,completion_date,creation_date,conference) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSString *summary = [rs stringForColumn:@"summary"];
        NSInteger location_id = [rs intForColumn:@"location_id"];
        NSString *description = [rs stringForColumn:@"description"];
        double start_date = [rs doubleForColumn:@"start_date"];
        NSString *start_tz = [rs stringForColumn:@"start_tz"];
        double end_date = [rs doubleForColumn:@"end_date"];
        NSInteger all_day = [rs intForColumn:@"all_day"];
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
        NSInteger orig_item_id = [rs intForColumn:@"orig_item_id"];
        double orig_date = [rs doubleForColumn:@"orig_date"];
        NSInteger organizer_id = [rs intForColumn:@"organizer_id"];
        NSInteger self_attendee_id = [rs intForColumn:@"self_attendee_id"];
        NSInteger status = [rs intForColumn:@"status"];
        NSInteger invitation_status = [rs intForColumn:@"invitation_status"];
        NSInteger availability = [rs intForColumn:@"availability"];
        NSInteger privacy_level = [rs intForColumn:@"privacy_level"];
        NSString *url = [rs stringForColumn:@"url"];
        double last_modified = [rs doubleForColumn:@"last_modified"];
        NSInteger sequence_num = [rs intForColumn:@"sequence_num"];
        NSInteger birthday_id = [rs intForColumn:@"birthday_id"];
        NSInteger modified_properties = [rs intForColumn:@"modified_properties"];
        NSInteger external_tracking_status = [rs intForColumn:@"external_tracking_status"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *external_mod_tag = [rs stringForColumn:@"external_mod_tag"];
        NSString *unique_identifier = [rs stringForColumn:@"unique_identifier"];
        NSString *external_schedule_id = [rs stringForColumn:@"external_schedule_id"];
        NSData *external_rep = [rs dataForColumn:@"external_rep"];
        NSString *response_comment = [rs stringForColumn:@"response_comment"];
        NSInteger hidden = [rs intForColumn:@"hidden"];
        NSInteger has_recurrences = [rs intForColumn:@"has_recurrences"];
        NSInteger has_attendees = [rs intForColumn:@"has_attendees"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSInteger entity_type = [rs intForColumn:@"entity_type"];
        NSInteger priority = [rs intForColumn:@"priority"];
        double due_date = [rs doubleForColumn:@"due_date"];
        NSString *due_tz = [rs stringForColumn:@"due_tz"];
        NSInteger due_all_day = [rs intForColumn:@"due_all_day"];
        double completion_date = [rs doubleForColumn:@"completion_date"];
        double creation_date = [rs doubleForColumn:@"creation_date"];
//        NSInteger display_order = [rs intForColumn:@"display_order"];
//        NSInteger created_by_id = [rs intForColumn:@"created_by_id"];
//        NSInteger modified_by_id = [rs intForColumn:@"modified_by_id"];
//        double shared_item_created_date = [rs doubleForColumn:@"shared_item_created_date"];
//        NSString *shared_item_created_tz = [rs stringForColumn:@"shared_item_created_tz"];
//        double shared_item_modified_date = [rs doubleForColumn:@"shared_item_modified_date"];
//        NSString *shared_item_modified_tz = [rs stringForColumn:@"shared_item_modified_tz"];
//        NSInteger invitation_changed_properties = [rs intForColumn:@"invitation_changed_properties"];
//        NSInteger default_alarm_removed = [rs intForColumn:@"default_alarm_removed"];
//        NSInteger phantom_master = [rs intForColumn:@"phantom_master"];
        //        double participation_status_modified_date = [rs doubleForColumn:@"participation_status_modified_date"];
        
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],summary,[NSNumber numberWithInt:location_id],description,[NSNumber numberWithDouble:start_date],start_tz,[NSNumber numberWithDouble:end_date],[NSNumber numberWithInt:all_day],[NSNumber numberWithInt:calendar_id],[NSNumber numberWithInt:orig_item_id],[NSNumber numberWithDouble:orig_date],[NSNumber numberWithInt:organizer_id],[NSNumber numberWithInt:self_attendee_id],[NSNumber numberWithInt:status],[NSNumber numberWithInt:invitation_status],[NSNumber numberWithInt:availability],[NSNumber numberWithInt:privacy_level],url,[NSNumber numberWithDouble:last_modified],[NSNumber numberWithInt:sequence_num],[NSNumber numberWithInt:birthday_id],[NSNumber numberWithInt:modified_properties],[NSNumber numberWithInt:external_tracking_status],external_id,external_mod_tag,unique_identifier,external_schedule_id,external_rep,response_comment,[NSNumber numberWithInt:hidden],[NSNumber numberWithInt:has_recurrences],[NSNumber numberWithInt:has_attendees],UUID,[NSNumber numberWithInt:entity_type],[NSNumber numberWithInt:priority],[NSNumber numberWithDouble:due_date],due_tz,[NSNumber numberWithInt:due_all_day],[NSNumber numberWithDouble:completion_date],[NSNumber numberWithDouble:creation_date],[NSNull null]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table CalendarItem exit"];
}


//表CalendarItemChanges
- (void)insertCalendarItemChanges
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table CalendarItemChanges enter"];
    NSString *sql1 = @"select * from CalendarItemChanges";
    NSString *sql2 = @"insert into CalendarItemChanges(record,type,calendar_id,external_id,unique_identifier,UUID,entity_type,store_id,has_dirty_instance_attributes,old_calendar_id,old_external_id) values(?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger record = [rs intForColumn:@"record"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *unique_identifier = [rs stringForColumn:@"unique_identifier"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSInteger entity_type = [rs intForColumn:@"entity_type"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        NSInteger has_dirty_instance_attributes = [rs intForColumn:@"has_dirty_instance_attributes"];
        NSInteger old_calendar_id = [rs intForColumn:@"old_calendar_id"];
        NSString *old_external_id = [rs stringForColumn:@"old_external_id"];
       
        
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record],[NSNumber numberWithInt:type],[NSNumber numberWithInt:calendar_id],external_id,unique_identifier,UUID,[NSNumber numberWithInt:entity_type],[NSNumber numberWithInt:store_id],[NSNumber numberWithInt:has_dirty_instance_attributes],[NSNumber numberWithInt:old_calendar_id],old_external_id];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table CalendarItemChanges exit"];
}

//表Category
- (void)insertCategory
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table Category enter"];
    NSString *sql1 = @"select * from Category";
    NSString *sql2 = @"insert into Category(ROWID,name,entity_type,hidden) values(?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSString *name = [rs stringForColumn:@"name"];
        NSInteger entity_type = [rs intForColumn:@"entity_type"];
        NSInteger hidden = [rs intForColumn:@"hidden"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],name,[NSNumber numberWithInt:entity_type],[NSNumber numberWithInt:hidden]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Category exit"];
}

//表CategoryLink
- (void)insertCategoryLink
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table CategoryLink enter"];
    NSString *sql1 = @"select * from CategoryLink";
    NSString *sql2 = @"insert into CategoryLink(ROWID,owner_id,category_id) values(?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        NSInteger category_id = [rs intForColumn:@"category_id"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:owner_id],[NSNumber numberWithInt:category_id]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table CategoryLink exit"];
}

//表EventAction
- (void)insertEventAction
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table EventAction enter"];
    NSString *sql1 = @"select * from EventAction";
    NSString *sql2 = @"insert into EventAction(ROWID,event_id,external_id,external_mod_tag,external_folder_id,external_schedule_id,external_rep) values(?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger event_id = [rs intForColumn:@"event_id"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *external_mod_tag= [rs stringForColumn:@"external_mod_tag"];
        NSString *external_folder_id = [rs stringForColumn:@"external_folder_id"];
        NSString *external_schedule_id = [rs stringForColumn:@"external_schedule_id"];
        NSData *external_rep = [rs dataForColumn:@"external_rep"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:event_id],external_id,external_mod_tag,external_folder_id,external_schedule_id,external_rep];
    }
    [rs close];
     [_logHandle writeInfoLog:@"insert Calendar table EventAction exit"];
}

//表EventActionChanges
- (void)insertEventActionChanges
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table EventActionChanges enter"];
    NSString *sql1 = @"select * from EventActionChanges";
    NSString *sql2 = @"insert into EventActionChanges(record,type,event_id,external_id,external_folder_id,external_schedule_id,store_id,calendar_id) values(?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger record = [rs intForColumn:@"record"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger event_id = [rs intForColumn:@"event_id"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *external_folder_id = [rs stringForColumn:@"external_folder_id"];
        NSString *external_schedule_id = [rs stringForColumn:@"external_schedule_id"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
       [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record],[NSNumber numberWithInt:type],[NSNumber numberWithInt:event_id],external_id,external_folder_id,external_schedule_id,[NSNumber numberWithInt:store_id],[NSNumber numberWithInt:calendar_id]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table EventActionChanges exit"];
}

//表ExceptionDate
- (void)insertExceptionDate
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table ExceptionDate enter"];
    NSString *sql1 = @"select * from ExceptionDate";
    NSString *sql2 = @"insert into ExceptionDate(ROWID,owner_id,date,sync_order) values(?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        double date = [rs doubleForColumn:@"date"];
        NSInteger sync_order = [rs intForColumn:@"sync_order"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:owner_id],[NSNumber numberWithDouble:date],[NSNumber numberWithInt:sync_order]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table ExceptionDate exit"];
}

//表Identity
- (void)insertIdentity
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table Identity enter"];
    NSString *sql1 = @"select * from Identity";
    NSString *sql2 = @"insert into Identity(display_name,address,first_name,last_name) values(?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSString *display_name = [rs stringForColumn:@"display_name"];
        NSString *address = [rs stringForColumn:@"address"];
        NSString *first_name = [rs stringForColumn:@"first_name"];
        NSString *last_name = [rs stringForColumn:@"last_name"];
        [_targetDBConnection executeUpdate:sql2,display_name,address,first_name,last_name];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Identity exit"];
}

//表Location
- (void)insertLocationWithiOS7
{
    [_logHandle writeInfoLog:@"insert Calendar table Location iOS7 enter"];
    NSString *sql1 = @"select * from Location";
    NSString *sql2 = @"insert into Location(ROWID,title,address,latitude,longitude,address_book_id,radius,item_owner_id,alarm_owner_id) values(?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSString *title = [rs stringForColumn:@"title"];
        NSString *address = [rs stringForColumn:@"address"];
        NSInteger latitude = [rs intForColumn:@"latitude"];
        NSInteger longitude = [rs intForColumn:@"longitude"];
        NSString *address_book_id = [rs stringForColumn:@"address_book_id"];
        NSInteger radius = [rs intForColumn:@"radius"];
        NSInteger item_owner_id = [rs intForColumn:@"item_owner_id"];
        NSInteger alarm_owner_id = [rs intForColumn:@"alarm_owner_id"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],title,address,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:latitude],[NSNumber numberWithInt:longitude],address_book_id,[NSNumber numberWithInt:radius],[NSNumber numberWithInt:item_owner_id],[NSNumber numberWithInt:alarm_owner_id]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Location iOS7 exit"];
}

- (void)insertLocationWithiOS6
{
    [_logHandle writeInfoLog:@"insert Calendar table Location iOS6 enter"];
    NSString *sql1 = @"select * from Location";
    NSString *sql2 = @"insert into Location(ROWID,title,latitude,longitude,address_book_id,radius,item_owner_id,alarm_owner_id) values(?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSString *title = [rs stringForColumn:@"title"];
        NSInteger latitude = [rs intForColumn:@"latitude"];
        NSInteger longitude = [rs intForColumn:@"longitude"];
        NSString *address_book_id = [rs stringForColumn:@"address_book_id"];
        NSInteger radius = [rs intForColumn:@"radius"];
        NSInteger item_owner_id = [rs intForColumn:@"item_owner_id"];
        NSInteger alarm_owner_id = [rs intForColumn:@"alarm_owner_id"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],title,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:latitude],[NSNumber numberWithInt:longitude],address_book_id,[NSNumber numberWithInt:radius],[NSNumber numberWithInt:item_owner_id],[NSNumber numberWithInt:alarm_owner_id]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Location iOS6 exit"];
}


//表Location
- (void)insertNotification
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table Notification enter"];
    NSString *sql1 = @"select * from Notification";
    NSString *sql2 = @"insert into Notification(ROWID,entity_type,calendar_id,external_id,external_mod_tag,UUID,summary,creation_date,last_modified,status,host_url,in_reply_to,identity_id,alerted) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger entity_type = [rs intForColumn:@"entity_type"];
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *external_mod_tag = [rs stringForColumn:@"external_mod_tag"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSString *summary = [rs stringForColumn:@"summary"];
        double creation_date = [rs doubleForColumn:@"creation_date"];
        double last_modified = [rs doubleForColumn:@"last_modified"];
        NSInteger status = [rs intForColumn:@"status"];
        NSString *host_url = [rs stringForColumn:@"host_url"];
        NSString *in_reply_to = [rs stringForColumn:@"in_reply_to"];
        NSInteger identity_id = [rs intForColumn:@"identity_id"];
        NSInteger alerted = [rs intForColumn:@"alerted"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:entity_type],[NSNumber numberWithInt:calendar_id],external_id,external_mod_tag,UUID,summary,[NSNumber numberWithDouble:creation_date],[NSNumber numberWithDouble:last_modified],[NSNumber numberWithInt:status],host_url,in_reply_to,[NSNumber numberWithInt:identity_id],[NSNumber numberWithInt:alerted]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Notification exit"];
}

//表NotificationChanges
- (void)insertNotificationChanges
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table NotificationChanges enter"];
    NSString *sql1 = @"select * from NotificationChanges";
    NSString *sql2 = @"insert into NotificationChanges(record,type,entity_type,calendar_id,external_id,UUID,store_id) values(?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger record = [rs intForColumn:@"record"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger entity_type = [rs intForColumn:@"entity_type"];
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record],[NSNumber numberWithInt:type],[NSNumber numberWithInt:entity_type],[NSNumber numberWithInt:calendar_id],external_id,UUID,store_id];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table NotificationChanges exit"];
}

//表OccurrenceCache
- (void)insertOccurrenceCache
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table OccurrenceCache enter"];
    NSString *sql1 = @"select * from OccurrenceCache";
    NSString *sql2 = @"insert into OccurrenceCache(day,event_id,calendar_id,store_id,occurrence_date,occurrence_start_date,occurrence_end_date) values(?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        double day = [rs doubleForColumn:@"day"];
        NSInteger event_id = [rs intForColumn:@"event_id"];
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        double occurrence_date = [rs doubleForColumn:@"occurrence_date"];
        double occurrence_start_date = [rs doubleForColumn:@"occurrence_start_date"];
        double occurrence_end_date = [rs doubleForColumn:@"occurrence_end_date"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithDouble:day],[NSNumber numberWithInt:event_id],[NSNumber numberWithInt:calendar_id],[NSNumber numberWithInt:store_id],[NSNumber numberWithDouble:occurrence_date],[NSNumber numberWithDouble:occurrence_start_date],[NSNumber numberWithDouble:occurrence_end_date]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table OccurrenceCache exit"];
}

//表OccurrenceCacheDays
- (void)insertOccurrenceCacheDays
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table OccurrenceCacheDays enter"];
    NSString *sql1 = @"select * from OccurrenceCacheDays";
    NSString *sql2 = @"insert into OccurrenceCacheDays(calendar_id,store_id,day,count) values(?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        double day = [rs doubleForColumn:@"day"];
        NSInteger count = [rs intForColumn:@"count"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:calendar_id],[NSNumber numberWithInt:store_id],[NSNumber numberWithDouble:day],[NSNumber numberWithInt:count]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table OccurrenceCacheDays exit"];

}

//表Participant
- (void)insertParticipantWithiOS7
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table Participant iOS7 enter"];
    NSString *sql1 = @"select * from Participant";
    NSString *sql2 = @"insert into Participant(ROWID,entity_type,type,status,pending_status,role,identity_id,owner_id,external_rep,UUID,email,is_self,comment,schedule_agent,flags,last_modified) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger entity_type = [rs intForColumn:@"entity_type"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger status = [rs intForColumn:@"status"];
        NSInteger pending_status = [rs intForColumn:@"pending_status"];
        NSInteger role = [rs intForColumn:@"role"];
        NSInteger identity_id = [rs intForColumn:@"identity_id"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        NSData *external_rep = [rs dataForColumn:@"external_rep"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSString *email = [rs stringForColumn:@"email"];
        NSInteger is_self = [rs intForColumn:@"is_self"];
        NSString *comment = [rs stringForColumn:@"comment"];
        NSInteger schedule_agent = [rs intForColumn:@"schedule_agent"];
        NSInteger flags = [rs intForColumn:@"flags"];
        double last_modified = [rs doubleForColumn:@"last_modified"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:entity_type],[NSNumber numberWithInt:type],[NSNumber numberWithInt:status],[NSNumber numberWithInt:pending_status],[NSNumber numberWithInt:role],[NSNumber numberWithInt:identity_id],[NSNumber numberWithInt:owner_id],external_rep,UUID,email,[NSNumber numberWithInt:is_self],comment,[NSNumber numberWithInt:schedule_agent],[NSNumber numberWithInt:flags],[NSNumber numberWithDouble:last_modified]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Participant iOS7 exit"];
}

- (void)insertParticipantWithiOS6
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table Participant iOS6 enter"];
    NSString *sql1 = @"select * from Participant";
    NSString *sql2 = @"insert into Participant(ROWID,entity_type,type,status,pending_status,role,identity_id,owner_id,external_rep,UUID,email,is_self) values(?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger entity_type = [rs intForColumn:@"entity_type"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger status = [rs intForColumn:@"status"];
        NSInteger pending_status = [rs intForColumn:@"pending_status"];
        NSInteger role = [rs intForColumn:@"role"];
        NSInteger identity_id = [rs intForColumn:@"identity_id"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        NSData *external_rep = [rs dataForColumn:@"external_rep"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSString *email = [rs stringForColumn:@"email"];
        NSInteger is_self = [rs intForColumn:@"is_self"];
      
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:entity_type],[NSNumber numberWithInt:type],[NSNumber numberWithInt:status],[NSNumber numberWithInt:pending_status],[NSNumber numberWithInt:role],[NSNumber numberWithInt:identity_id],[NSNumber numberWithInt:owner_id],external_rep,UUID,email,[NSNumber numberWithInt:is_self]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Participant iOS6 exit"];
}

- (void)insertParticipantWithiOS5
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table Participant iOS5 enter"];
    NSString *sql1 = @"select * from Participant";
    NSString *sql2 = @"insert into Participant(ROWID,entity_type,type,status,pending_status,role,identity_id,owner_id,external_rep,UUID,is_self) values(?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger entity_type = [rs intForColumn:@"entity_type"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger status = [rs intForColumn:@"status"];
        NSInteger pending_status = [rs intForColumn:@"pending_status"];
        NSInteger role = [rs intForColumn:@"role"];
        NSInteger identity_id = [rs intForColumn:@"identity_id"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        NSData *external_rep = [rs dataForColumn:@"external_rep"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSInteger is_self = [rs intForColumn:@"is_self"];
        
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:entity_type],[NSNumber numberWithInt:type],[NSNumber numberWithInt:status],[NSNumber numberWithInt:pending_status],[NSNumber numberWithInt:role],[NSNumber numberWithInt:identity_id],[NSNumber numberWithInt:owner_id],external_rep,UUID,[NSNumber numberWithInt:is_self]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Participant iOS5 exit"];
}



//表ParticipantChanges
- (void)insertParticipantChangesWithiOS7
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table ParticipantChanges iOS7 enter"];
    NSString *sql1 = @"select * from ParticipantChanges";
    NSString *sql2 = @"insert into ParticipantChanges(record,type,entity_type,owner_id,UUID,email,comment,store_id,calendar_id) values(?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger record = [rs intForColumn:@"record"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger entity_type = [rs intForColumn:@"entity_type"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSString *email = [rs stringForColumn:@"email"];
        NSString *comment = [rs stringForColumn:@"comment"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record],[NSNumber numberWithInt:type],[NSNumber numberWithInt:entity_type],[NSNumber numberWithInt:owner_id],UUID,email,comment,store_id,calendar_id];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table ParticipantChanges iOS7 exit"];
}

- (void)insertParticipantChangesWithiOS6
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table ParticipantChanges iOS6 enter"];
    NSString *sql1 = @"select * from ParticipantChanges";
    NSString *sql2 = @"insert into ParticipantChanges(record,type,entity_type,owner_id,UUID,email,store_id,calendar_id) values(?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger record = [rs intForColumn:@"record"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger entity_type = [rs intForColumn:@"entity_type"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSString *email = [rs stringForColumn:@"email"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record],[NSNumber numberWithInt:type],[NSNumber numberWithInt:entity_type],[NSNumber numberWithInt:owner_id],UUID,email,store_id,calendar_id];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table ParticipantChanges iOS6 exit"];
}

- (void)insertParticipantChangesWithiOS5
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table ParticipantChanges iOS5 enter"];
    NSString *sql1 = @"select * from ParticipantChanges";
    NSString *sql2 = @"insert into ParticipantChanges(record,type,entity_type,owner_id,UUID,store_id,calendar_id) values(?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger record = [rs intForColumn:@"record"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger entity_type = [rs intForColumn:@"entity_type"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
       // NSString *email = [rs stringForColumn:@"email"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record],[NSNumber numberWithInt:type],[NSNumber numberWithInt:entity_type],[NSNumber numberWithInt:owner_id],UUID,store_id,calendar_id];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table ParticipantChanges iOS5 exit"];
}



//表Recurrence
- (void)insertRecurrence
{
    //face_time_data
     [_logHandle writeInfoLog:@"insert Calendar table Recurrence enter"];
    NSString *sql1 = @"select * from Recurrence";
    NSString *sql2 = @"insert into Recurrence(ROWID,frequency,interval,week_start,count,cached_end_date,cached_end_date_tz,end_date,specifier,by_month_months,owner_id,external_id,external_mod_tag,external_id_tag,external_rep,UUID) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger frequency = [rs intForColumn:@"frequency"];
        NSInteger interval = [rs intForColumn:@"interval"];
        NSInteger week_start = [rs intForColumn:@"week_start"];
        NSInteger count = [rs intForColumn:@"count"];
        double cached_end_date = [rs doubleForColumn:@"cached_end_date"];
        NSString *cached_end_date_tz = [rs stringForColumn:@"cached_end_date_tz"];
        double end_date = [rs doubleForColumn:@"end_date"];
        NSString *specifier = [rs stringForColumn:@"specifier"];
        NSInteger by_month_months = [rs intForColumn:@"by_month_months"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *external_mod_tag = [rs stringForColumn:@"external_mod_tag"];
        NSString *external_id_tag = [rs stringForColumn:@"external_id_tag"];
        NSData *external_rep = [rs dataForColumn:@"external_rep"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:frequency],[NSNumber numberWithInt:interval],[NSNumber numberWithInt:week_start],[NSNumber numberWithInt:count],[NSNumber numberWithDouble:cached_end_date],cached_end_date_tz,[NSNumber numberWithDouble:end_date],specifier,[NSNumber numberWithInt:by_month_months],[NSNumber numberWithInt:owner_id],external_id,external_mod_tag,external_id_tag,external_rep,UUID];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Recurrence exit"];
}

//表RecurrenceChanges
- (void)insertRecurrenceChanges
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table RecurrenceChanges enter"];
    NSString *sql1 = @"select * from RecurrenceChanges";
    NSString *sql2 = @"insert into RecurrenceChanges(record,type,external_id,store_id,event_id_tomb,calendar_id,end_date_tomb,UUID) values(?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger record = [rs intForColumn:@"record"];
        NSInteger type = [rs intForColumn:@"type"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        NSInteger event_id_tomb = [rs intForColumn:@"event_id_tomb"];
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
        double end_date_tomb = [rs doubleForColumn:@"end_date_tomb"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record],[NSNumber numberWithInt:type],external_id,[NSNumber numberWithInt:store_id],[NSNumber numberWithInt:event_id_tomb],[NSNumber numberWithInt:calendar_id],[NSNumber numberWithDouble:end_date_tomb],UUID];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table RecurrenceChanges exit"];
}

//表ResourceChange
- (void)insertResourceChange
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table ResourceChange enter"];
    NSString *sql1 = @"select * from ResourceChange";
    NSString *sql2 = @"insert into ResourceChange(ROWID,notification_id,calendar_id,calendar_item_id,identity_id,change_type,timestamp,changed_properties,create_count,update_count,delete_count,deleted_summary,deleted_start_date,alerted,public_status) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger notification_id = [rs intForColumn:@"notification_id"];
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
        NSInteger calendar_item_id = [rs intForColumn:@"calendar_item_id"];
        NSInteger identity_id = [rs intForColumn:@"identity_id"];
        NSInteger change_type = [rs intForColumn:@"change_type"];
        double timestamp = [rs doubleForColumn:@"timestamp"];
        NSInteger changed_properties = [rs intForColumn:@"changed_properties"];
        NSInteger create_count = [rs intForColumn:@"create_count"];
        NSInteger update_count = [rs intForColumn:@"update_count"];
        NSInteger delete_count = [rs intForColumn:@"delete_count"];
        NSString *deleted_summary = [rs stringForColumn:@"deleted_summary"];
        double deleted_start_date = [rs doubleForColumn:@"deleted_start_date"];
        NSInteger alerted = [rs intForColumn:@"alerted"];
        NSInteger public_status = [rs intForColumn:@"public_status"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],[NSNumber numberWithInt:notification_id],[NSNumber numberWithInt:calendar_id],[NSNumber numberWithInt:calendar_item_id],[NSNumber numberWithInt:identity_id],[NSNumber numberWithInt:change_type],[NSNumber numberWithDouble:timestamp],[NSNumber numberWithDouble:changed_properties],[NSNumber numberWithDouble:create_count],[NSNumber numberWithDouble:update_count],[NSNumber numberWithDouble:delete_count],deleted_summary,[NSNumber numberWithDouble:deleted_start_date],[NSNumber numberWithInt:alerted],[NSNumber numberWithInt:public_status]];
    }
    [rs close];
     [_logHandle writeInfoLog:@"insert Calendar table ResourceChange exit"];
}
//表ScheduledTaskCache
//- (void)insertScheduledTaskCache
//{
//    //face_time_data
//    NSString *sql1 = @"select * from ScheduledTaskCache";
//    NSString *sql2 = @"insert into ScheduledTaskCache(day,date_for_sorting,completed,task_id,count) values(?,?,?,?,?)";
//    //执行sql语句,返回结果集
//    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
//    while ([rs next]) {
//        double day = [rs doubleForColumn:@"day"];
//        double date_for_sorting = [rs doubleForColumn:@"date_for_sorting"];
//        NSInteger completed = [rs intForColumn:@"completed"];
//        NSInteger task_id = [rs intForColumn:@"task_id"];
//        NSInteger count = [rs intForColumn:@"count"];
//       [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithDouble:day],[NSNumber numberWithDouble:date_for_sorting],[NSNumber numberWithInt:completed],[NSNumber numberWithInt:task_id],[NSNumber numberWithInt:count]];
//    }
//    [rs close];
//}

//表Sharee
- (void)insertSharee
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table Sharee enter"];
    NSString *sql1 = @"select * from Sharee";
    NSString *sql2 = @"insert into Sharee(ROWID,owner_id,external_id,external_rep,UUID,identity_id,status,access_level) values(?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSData *external_rep = [rs dataForColumn:@"external_rep"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSInteger identity_id = [rs intForColumn:@"identity_id"];
        NSInteger status = [rs intForColumn:@"status"];
        NSInteger access_level = [rs intForColumn:@"access_level"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithDouble:ROWID],[NSNumber numberWithDouble:owner_id],external_id,external_rep,UUID,[NSNumber numberWithInt:identity_id],[NSNumber numberWithInt:status],[NSNumber numberWithInt:access_level]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Sharee exit"];
}

//表ShareeChanges
- (void)insertShareeChanges
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table ShareeChanges enter"];
    NSString *sql1 = @"select * from ShareeChanges";
    NSString *sql2 = @"insert into ShareeChanges(record,type,owner_id,UUID,status,access_level,display_name,address,store_id,calendar_id,first_name,last_name) values(?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger record = [rs intForColumn:@"record"];
        NSInteger type = [rs intForColumn:@"type"];
        NSInteger owner_id = [rs intForColumn:@"owner_id"];
        NSString *UUID = [rs stringForColumn:@"UUID"];
        NSInteger status = [rs intForColumn:@"status"];
        NSInteger access_level = [rs intForColumn:@"access_level"];
        NSString *display_name = [rs stringForColumn:@"display_name"];
        NSString *address = [rs stringForColumn:@"address"];
        NSInteger store_id = [rs intForColumn:@"store_id"];
        NSInteger calendar_id = [rs intForColumn:@"calendar_id"];
        NSString *first_name = [rs stringForColumn:@"first_name"];
        NSString *last_name = [rs stringForColumn:@"last_name"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:record],[NSNumber numberWithInt:type],[NSNumber numberWithInt:owner_id],UUID,[NSNumber numberWithInt:status],[NSNumber numberWithInt:access_level],display_name,address,[NSNumber numberWithInt:store_id],[NSNumber numberWithDouble:calendar_id],first_name,last_name];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table ShareeChanges exit"];
}

//表Store
- (void)insertStoreWithiOS7
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table Store iOS7 enter"];
    NSString *sql1 = @"select * from Store";
    NSString *sql2 = @"insert into Store(ROWID,name,default_alarm_offset,type,constraint_path,disabled,external_id,persistent_id,flags,creator_bundle_id,creator_code_signing_identity,only_creator_can_modify,external_mod_tag) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSString *name = [rs stringForColumn:@"name"];
        NSInteger default_alarm_offset = [rs intForColumn:@"default_alarm_offset"];
        NSInteger type = [rs intForColumn:@"type"];
        NSString *constraint_path = [rs stringForColumn:@"constraint_path"];
        NSInteger disabled = [rs intForColumn:@"disabled"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *persistent_id = [rs stringForColumn:@"persistent_id"];
        NSInteger flags = [rs intForColumn:@"flags"];
        NSString *creator_bundle_id = [rs stringForColumn:@"creator_bundle_id"];
        NSString *creator_code_signing_identity = [rs stringForColumn:@"creator_code_signing_identity"];
        NSInteger only_creator_can_modify = [rs intForColumn:@"only_creator_can_modify"];
        NSString *external_mod_tag = [rs stringForColumn:@"external_mod_tag"];
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],name,[NSNumber numberWithInt:default_alarm_offset],[NSNumber numberWithInt:type],constraint_path,[NSNumber numberWithInt:disabled],external_id,persistent_id,[NSNumber numberWithInt:flags],creator_bundle_id,creator_code_signing_identity,[NSNumber numberWithInt:only_creator_can_modify],external_mod_tag];
    }
    [rs close];
     [_logHandle writeInfoLog:@"insert Calendar table Store iOS7 exit"];
}

- (void)insertStoreWithiOS6
{
    //face_time_data
    [_logHandle writeInfoLog:@"insert Calendar table Store iOS6 enter"];
    NSString *sql1 = @"select * from Store";
    NSString *sql2 = @"insert into Store(ROWID,name,default_alarm_offset,type,constraint_path,disabled,external_id,persistent_id,flags,) values(?,?,?,?,?,?,?,?,?)";
    //执行sql语句,返回结果集
    FMResultSet *rs = [_sourceDBConnection executeQuery:sql1];
    while ([rs next]) {
        NSInteger ROWID = [rs intForColumn:@"ROWID"];
        NSString *name = [rs stringForColumn:@"name"];
        NSInteger default_alarm_offset = [rs intForColumn:@"default_alarm_offset"];
        NSInteger type = [rs intForColumn:@"type"];
        NSString *constraint_path = [rs stringForColumn:@"constraint_path"];
        NSInteger disabled = [rs intForColumn:@"disabled"];
        NSString *external_id = [rs stringForColumn:@"external_id"];
        NSString *persistent_id = [rs stringForColumn:@"persistent_id"];
        NSInteger flags = [rs intForColumn:@"flags"];
        
        [_targetDBConnection executeUpdate:sql2,[NSNumber numberWithInt:ROWID],name,[NSNumber numberWithInt:default_alarm_offset],[NSNumber numberWithInt:type],constraint_path,[NSNumber numberWithInt:disabled],external_id,persistent_id,[NSNumber numberWithInt:flags]];
    }
    [rs close];
    [_logHandle writeInfoLog:@"insert Calendar table Store iOS6 exit"];
}

@end
