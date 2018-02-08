//
//  IMBADCalendarEntity.m
//  AnytransForAndroid
//
//  Created by JGehry on 2/22/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import "IMBADCalendarEntity.h"
#import "IMBSoftWareInfo.h"
@implementation IMBADCalendarEntity
@synthesize calendarTitle = _calendarTitle;
@synthesize calendarLocation = _calendarLocation;
@synthesize calendarDescription = _calendarDescription;
@synthesize calendarDateStart = _calendarDateStart;
@synthesize calendarDateEnd = _calendarDateEnd;
@synthesize calendarID = _calendarID;
@synthesize calendarEndTime = _calendarEndTime;
@synthesize calendarStartTime = _calendarStartTime;
@synthesize parentID = _parentID;

- (void)dealloc
{
#if !__has_feature(objc_arc)
    if (_calendarTitle != nil) {
        [_calendarTitle release];
        _calendarTitle = nil;
    }
    if (_calendarLocation != nil) {
        [_calendarLocation release];
        _calendarLocation = nil;
    }
    if (_calendarDescription != nil) {
        [_calendarDescription release];
        _calendarDescription = nil;
    }
    if (_calendarDateStart != nil) {
        [_calendarDateStart release];
        _calendarDateStart = nil;
    }
    if (_calendarDateEnd != nil) {
        [_calendarDateEnd release];
        _calendarDateEnd = nil;
    }
    [super dealloc];
#endif
}

- (instancetype)init
{
    if (self = [super init]) {
        return self;
    }else {
#if !__has_feature(objc_arc)
        [self release];
#endif
        return nil;
    }
}

- (void)setCalendarTitle:(NSString *)calendarTitle {
    if (_calendarTitle != nil) {
        [_calendarTitle release];
        _calendarTitle = nil;
    }
    _calendarTitle = [calendarTitle retain];
}

- (void)setCalendarLocation:(NSString *)calendarLocation {
    if (_calendarLocation != nil) {
        [_calendarLocation release];
        _calendarLocation = nil;
    }
    _calendarLocation = [calendarLocation retain];
}

- (void)setCalendarDescription:(NSString *)calendarDescription {
    if (_calendarDescription != nil) {
        [_calendarDescription release];
        _calendarDescription = nil;
    }
    _calendarDescription = [calendarDescription retain];
}

- (void)setCalendarDateStart:(NSString *)calendarDateStart {
    if (_calendarDateStart != nil) {
        [_calendarDateStart release];
        _calendarDateStart = nil;
    }
    _calendarDateStart = [calendarDateStart retain];
}

- (void)setCalendarDateEnd:(NSString *)calendarDateEnd {
    if (_calendarDateEnd != nil) {
        [_calendarDateEnd release];
        _calendarDateEnd = nil;
    }
    _calendarDateEnd = [calendarDateEnd retain];
}

//mode为nil，则默认为@"yyyy-MM-dd HH:mm:ss"；   timeZone为nil，则默认为@"Africa/Bamako"
- (NSString *)dateFrom1970ToString:(double)timeStamp withMode:(NSString *)mode withTimeZone:(NSTimeZone *)timeZone {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (mode != nil) {
        [dateFormatter setDateFormat:mode];
    }else {
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
    }
    NSDate *date = [self dateFrom1970:timeStamp withTimeZone:timeZone];
    NSString *returnString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return returnString;
}

- (NSDate*)dateFrom1970:(double)timeStamp withTimeZone:(NSTimeZone *)timeZone {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (timeZone == nil) {
        timeZone = [NSTimeZone timeZoneWithName:@"Africa/Bamako"];
    }
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *originDate = [dateFormatter dateFromString:@"1970-01-01 00:00:00"];
    if(originDate == nil || originDate == NULL) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        originDate = [dateFormatter dateFromString:@"1970-01-01 00:00:00"];
    }
    NSDate *returnDate = [[[NSDate alloc] initWithTimeInterval:timeStamp sinceDate:originDate] autorelease];
    [dateFormatter release];
    return returnDate;
}


@end

@implementation IMBCalendarAccountEntity
@synthesize displayName = _displayName;
@synthesize accountId = _accountId;
@synthesize accountName = _accountName;
@synthesize eventArray = _eventArray;

- (id)init {
    if (self = [super init]) {
        _accountId = 0;
        _accountName = nil;
        _displayName = nil;
        _eventArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (_accountName != nil) {
        [_accountName release];
        _accountName = nil;
    }
    if (_displayName != nil) {
        [_displayName release];
        _displayName = nil;
    }
    if (_eventArray != nil) {
        [_eventArray release];
        _eventArray = nil;
    }
    [super dealloc];
}

- (void)setAccountName:(NSString *)accountName {
    if (_accountName != nil) {
        [_accountName release];
        _accountName = nil;
    }
    _accountName = [accountName retain];
}

- (void)setDisplayName:(NSString *)displayName {
    if (_displayName != nil) {
        [_displayName release];
        _displayName = nil;
    }
    _displayName = [displayName retain];
}

@end
