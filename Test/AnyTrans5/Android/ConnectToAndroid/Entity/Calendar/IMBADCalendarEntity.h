//
//  IMBADCalendarEntity.h
//  AnytransForAndroid
//
//  Created by JGehry on 2/22/17.
//  Copyright © 2017 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBaseEntity.h"

@interface IMBADCalendarEntity : IMBBaseEntity {
 @private
    int _calendarID;
    int _parentID;
    NSString *_calendarTitle;
    NSString *_calendarLocation;
    NSString *_calendarDescription;
    NSString *_calendarDateStart;
    long long _calendarStartTime;
    NSString *_calendarDateEnd;
    long long _calendarEndTime;
}

/**
 *  calendarID                      事件ID
 *  parentID                        组ID
 *  calendarTitle                   事件名称
 *  calendarLocation                事件地点
 *  calendarDescription             事件描述
 *  calendarDateStart               开始时间
 *  calendarStartTime               开始时间戳
 *  calendarDateEnd                 结束时间
 *  calendarEndTime                 结束时间戳
 */
@property (nonatomic, readwrite) int calendarID;
@property (nonatomic, readwrite) int parentID;
@property (nonatomic, readwrite, retain) NSString *calendarTitle;
@property (nonatomic, readwrite, retain) NSString *calendarLocation;
@property (nonatomic, readwrite, retain) NSString *calendarDescription;
@property (nonatomic, readwrite, retain) NSString *calendarDateStart;
@property (nonatomic, readwrite, retain) NSString *calendarDateEnd;
@property (nonatomic, readwrite) long long calendarStartTime;
@property (nonatomic, readwrite) long long calendarEndTime;

- (void)setCalendarTitle:(NSString *)calendarTitle;
- (void)setCalendarLocation:(NSString *)calendarLocation;
- (void)setCalendarDescription:(NSString *)calendarDescription;
- (void)setCalendarDateStart:(NSString *)calendarDateStart;
- (void)setCalendarDateEnd:(NSString *)calendarDateEnd;
- (NSString *)dateFrom1970ToString:(double)timeStamp withMode:(NSString *)mode withTimeZone:(NSTimeZone *)timeZone;

@end

@interface IMBCalendarAccountEntity : IMBBaseEntity {
@private
    NSString *_accountName;
    NSString *_displayName;
    int _accountId;
    NSMutableArray *_eventArray;
}

@property (nonatomic, readwrite, retain) NSString *accountName;
@property (nonatomic, readwrite, retain) NSString *displayName;
@property (nonatomic, readwrite) int accountId;
@property (nonatomic, readwrite, retain) NSMutableArray *eventArray;

@end
