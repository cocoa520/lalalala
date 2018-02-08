//
//  IMBADCallHistoryEntity.h
//  PhoneRescue_Android
//
//  Created by iMobie on 4/5/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMBBaseEntity.h"

typedef enum CallHistoryType
{
    UNKNOW_TYPE = 0,
    INCOMING_TYPE = 1,
    OUTGOING_TYPE = 2,
    MISSED_TYPE = 3,
    REJECTED_TYPE = 10,
}CallHistoryTypeEnum;

@interface IMBADCallHistoryEntity : IMBBaseEntity {
@private
    NSString *_contactName;
    NSString *_phoneNumber;
    int _callId;
    CallHistoryTypeEnum _callType;
    long long _callTime;
    NSString *_callDateStr;//年月日
    NSString *_callTimeStr; //时分秒
    NSString *_dateStr;  //年月日 时分秒
    int _duration;
}

/**
 *    contactName              联系人名字
 *    phoneNumber              拨打号码
 *    callId                   唯一ID
 *    callType                 拨打记录类型
 *    callTime                 拨打时间戳
 *    callDateStr              拨打时间字符串
 *    duration                 拨打时长
 */

@property(nonatomic, retain) NSString *contactName;
@property(nonatomic, retain) NSString *phoneNumber;
@property(nonatomic, readwrite) int callId;
@property(nonatomic, readwrite) CallHistoryTypeEnum callType;
@property(nonatomic, readwrite) long long callTime;
@property(nonatomic, retain) NSString *callDateStr;
@property(nonatomic, retain) NSString *callTimeStr;
@property(nonatomic, retain) NSString *dateStr;
@property(nonatomic, readwrite) int duration;

- (void)dictionaryToObject:(NSDictionary *)msgDic;
- (NSDictionary *)objectToDictionary:(IMBADCallHistoryEntity *)entity;
- (NSString *)dateFrom1970ToString:(double)timeStamp withMode:(NSString *)mode withTimeZone:(NSTimeZone *)timeZone;

@end

@interface IMBADCallContactEntity : IMBBaseEntity {
@private
    NSString *_callName;
    NSString *_phoneNumber;
    NSMutableArray *_callArray;
    int _callCount;
}

@property(nonatomic, retain) NSString *callName;
@property(nonatomic, retain) NSString *phoneNumber;
@property(nonatomic, retain) NSMutableArray *callArray;
@property(nonatomic, readwrite) int callCount;

@end
