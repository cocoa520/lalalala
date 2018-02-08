//
//  IMBADCallHistoryEntity.m
//  PhoneRescue_Android
//
//  Created by iMobie on 4/5/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBADCallHistoryEntity.h"
#import "IMBHelper.h"
#import "IMBSoftWareInfo.h"

@implementation IMBADCallHistoryEntity
@synthesize contactName = _contactName;
@synthesize phoneNumber = _phoneNumber;
@synthesize callId = _callId;
@synthesize callTime = _callTime;
@synthesize callType = _callType;
@synthesize callDateStr = _callDateStr;
@synthesize duration = _duration;
@synthesize callTimeStr = _callTimeStr;
@synthesize dateStr = _dateStr;
- (id)init {
    if (self = [super init]) {
        _contactName = nil;
        _phoneNumber = nil;
        _callDateStr = nil;
        _callId = 0;
        _callTime = 0;
        _duration = 0;
        _callType = UNKNOW_TYPE;
    }
    return self;
}

- (void)dealloc {
    if (_contactName != nil) {
        [_contactName release];
        _contactName = nil;
    }
    if (_phoneNumber != nil) {
        [_phoneNumber release];
        _phoneNumber = nil;
    }
    if (_callDateStr != nil) {
        [_callDateStr release];
        _callDateStr = nil;
    }
    [_callTimeStr release],_callTimeStr = nil;
    [_dateStr release],_dateStr = nil;
    [super dealloc];
}

- (void)dictionaryToObject:(NSDictionary *)msgDic {
    if ([msgDic.allKeys containsObject:@"number"]) {
        self.phoneNumber = [msgDic objectForKey:@"number"];
    }
    if ([msgDic.allKeys containsObject:@"cachedname"]) {
        self.contactName = [msgDic objectForKey:@"cachedname"];
    }else {
        self.contactName = self.phoneNumber;
    }
    if ([msgDic.allKeys containsObject:@"id"]) {
        self.callId = [[msgDic objectForKey:@"id"] intValue];
    }
    if ([msgDic.allKeys containsObject:@"type"]) {
        self.callType = [[msgDic objectForKey:@"type"] intValue];
    }
    if ([msgDic.allKeys containsObject:@"duration"]) {
        self.duration = [[msgDic objectForKey:@"duration"] intValue];
    }
    if ([msgDic.allKeys containsObject:@"date"]) {
        self.callTime = [[msgDic objectForKey:@"date"] longLongValue];
        self.dateStr = [self dateFrom1970ToString:self.callTime/1000.0 withMode:nil withTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
        self.callDateStr = [self dateFrom1970ToString:self.callTime/1000.0 withMode:[IMBSoftWareInfo singleton].systemDateFormatter withTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
        self.callTimeStr = [self dateFrom1970ToString:self.callTime/1000.0 withMode:@"HH:mm:ss" withTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
    }
}

- (NSDictionary *)objectToDictionary:(IMBADCallHistoryEntity *)entity {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (entity.contactName != nil) {
        [dic setObject:entity.contactName forKey:@"cachedname"];
    }
    if (entity.phoneNumber != nil) {
        [dic setObject:entity.phoneNumber forKey:@"number"];
    }
    [dic setObject:[NSNumber numberWithInt:entity.duration] forKey:@"duration"];
    [dic setObject:[NSNumber numberWithLongLong:entity.callTime] forKey:@"date"];
    [dic setObject:[NSNumber numberWithInt:entity.callType] forKey:@"type"];
    return dic;
}

- (void)setContactName:(NSString *)contactName {
    if (_contactName != nil) {
        [_contactName release];
        _contactName = nil;
    }
    _contactName = [contactName retain];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    if (_phoneNumber != nil) {
        [_phoneNumber release];
        _phoneNumber = nil;
    }
    _phoneNumber = [phoneNumber retain];
}

- (void)setCallDateStr:(NSString *)callDateStr {
    if (_callDateStr != nil) {
        [_callDateStr release];
        _callDateStr = nil;
    }
    _callDateStr = [callDateStr retain];
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
    if (returnString == nil) {
        if (mode != nil) {
            [dateFormatter setDateFormat:mode];
        }else {
            [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ hh:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
        }
        returnString = [dateFormatter stringFromDate:date];
    }
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

@implementation IMBADCallContactEntity
@synthesize callArray = _callArray;
@synthesize callCount = _callCount;
@synthesize callName = _callName;
@synthesize phoneNumber = _phoneNumber;

- (id)init {
    if (self = [super init]) {
        _callCount = 0;
        _callArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (_callArray != nil) {
        [_callArray release];
        _callArray = nil;
    }
    if (_callName != nil) {
        [_callName release];
        _callName = nil;
    }
    if (_phoneNumber != nil) {
        [_phoneNumber release];
        _phoneNumber = nil;
    }
    [super dealloc];
}

- (void)setCallName:(NSString *)callName {
    if (_callName != nil) {
        [_callName release];
        _callName = nil;
    }
    _callName = [callName retain];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    if (_phoneNumber != nil) {
        [_phoneNumber release];
        _phoneNumber = nil;
    }
    _phoneNumber = [phoneNumber retain];
}
@end
