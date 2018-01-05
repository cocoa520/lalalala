//
//  IMBCalendarEntity.m
//  iMobieTrans
//
//  Created by iMobie on 14-2-24.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBCalendarEntity.h"

@implementation IMBCalendarEntity
@synthesize calendarID     = _calendarID;
@synthesize title          = _title;
@synthesize calendarRowID  = _calendarRowID;
@synthesize color          = _color;
@synthesize eventCalendatArray = _eventCalendatArray;
@synthesize isOnlyRead = _isOnlyRead;
@synthesize recordEntityName = _recordEntityName;
@synthesize tag = _tag;

- (id)init {
    self = [super init];
    if (self) {
        _tag = -1;
        _eventCalendatArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setCalendarID:(NSString *)calendarID {
    if (_calendarID != nil) {
        [_calendarID release];
        _calendarID = nil;
    }
    _calendarID = [calendarID retain];
}

- (void)setTitle:(NSString *)title {
    if (_title != nil) {
        [_title release];
        _title = nil;
    }
    _title = [title retain];
}

- (void)setCalendarRowID:(NSString *)calendarRowID {
    if (_calendarRowID != nil) {
        [_calendarRowID release];
        _calendarRowID = nil;
    }
    _calendarRowID = [calendarRowID retain];
}

- (void)setColor:(NSColor *)color {
    if (_color != nil) {
        [_color release];
        _color = nil;
    }
    _color = [color retain];
}

- (void)setRecordEntityName:(NSString *)recordEntityName {
    if (_recordEntityName != nil) {
        [_recordEntityName release];
        _recordEntityName = nil;
    }
    _recordEntityName = [recordEntityName retain];
}

- (void)dealloc
{
    if (_calendarID != nil) {
        [_calendarID release];
        _calendarID = nil;
    }
    if (_title != nil) {
        [_title release];
        _title = nil;
    }
    if (_calendarRowID != nil) {
        [_calendarRowID release];
        _calendarRowID = nil;
    }
    if (_color != nil) {
        [_color release];
        _color = nil;
    }
    if (_eventCalendatArray != nil) {
        [_eventCalendatArray release];
        _eventCalendatArray = nil;
    }
    if (_recordEntityName != nil) {
        [_recordEntityName release];
        _recordEntityName = nil;
    }
    [super dealloc];
}
@end
