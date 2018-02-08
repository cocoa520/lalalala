//
//  IMBVoiceMailEntity.m
//  PhoneRescue
//
//  Created by iMobie on 3/23/16.
//  Copyright (c) 2016 iMobie Inc. All rights reserved.
//

#import "IMBVoiceMailEntity.h"
#import "DateHelper.h"

@implementation IMBVoiceMailEntity
@synthesize rowid = _rowid;
@synthesize remoteUid = _remoteUid;
@synthesize date = _date;
@synthesize token = _token;
@synthesize sender = _sender;
@synthesize callbackNum = _callbackNum;
@synthesize duration = _duration;
@synthesize expiration = _expiration;
@synthesize trashedDate = _trashedDate;
@synthesize flags = _flags;
@synthesize dateStr = _dateStr;
@synthesize trashedDateStr = _trashedDateStr;
@synthesize path = _path;
@synthesize stateStr = _stateStr;
@synthesize size = _size;
@synthesize voicemailRecord = _voicemailRecord;
@synthesize fileIsExist = _fileIsExist;
- (id)init{
    self = [super init];
    if (self) {
        _rowid = 0;
        _remoteUid = 0;
        _date = 0;
        _token = 0;
        _sender = @"";
        _callbackNum = @"";
        _path = @"";
        _stateStr = @"";
        _duration = 0;
        _expiration = 0;
        _trashedDate = 0;
        _flags = 0;
        _size = 0;
    }
    return self;
}

//- (NSString *)dateStr{
//    if (_date > 0)
//    {
//        NSDate *date = [DateHelper getDateTimeFromTimeStamp1970:(long long)_date timeOffset:0];
//        _dateStr = [[DateHelper getHistoryDateString:date] retain];
//        return _dateStr;
//    }
//    return nil;
//}
//
//- (NSString *)trashedDateStr{
//    if (_trashedDate > 0) {
//        NSDate *trashedDate = [DateHelper getDateTimeFromTimeStamp1970:(long long)_date timeOffset:0];
//        _trashedDateStr = [[DateHelper getHistoryDateString:trashedDate] retain];
//        return _trashedDateStr;
//    }
//    return nil;
//}

- (void)setVoicemailRecord:(IMBMBFileRecord *)voicemailRecord
{
    if (_voicemailRecord != voicemailRecord) {
        [_voicemailRecord release];
        _voicemailRecord = [voicemailRecord retain];
    }
}

- (void)dealloc
{
    [_voicemailRecord release],_voicemailRecord = nil;
    [super dealloc];
}


@end

@implementation IMBVoiceMailAccountEntity
@synthesize contactName = _contactName;
@synthesize iconImage = _iconImage;
@synthesize totalCount = _totalCount;
@synthesize subArray = _subArray;
@synthesize senderStr = _senderStr;
- (id)init {
    if (self = [super init]) {
        _contactName = @"";
        _iconImage = [[NSImage alloc] init];
        _subArray = [[NSMutableArray alloc] init];
        _totalCount = 0;
        _senderStr = @"";
    }
    return self;
}

- (void)dealloc {
    
    if (_iconImage != nil) {
        [_iconImage release];
        _iconImage = nil;
    }
    if (_subArray != nil) {
        [_subArray release];
        _subArray = nil;
    }
    [super dealloc];
}

@end