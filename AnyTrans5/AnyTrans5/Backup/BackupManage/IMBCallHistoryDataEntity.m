//
//  IMBCallHistoryDataEntity.m
//  DataRecovery
//
//  Created by iMobie on 4/22/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBCallHistoryDataEntity.h"
//#import "IMBHelper.h"
#import "StringHelper.h"
#import "DateHelper.h"

@implementation IMBCallHistoryDataEntity
@synthesize  z_ent = _z_ent;
@synthesize zanswered = _zanswered;
@synthesize z_opt = _z_opt;
@synthesize zdisconnecten_cause = _zdisconnecten_cause;
@synthesize zface_time = _zface_time;
@synthesize zunmber_availa = _zunmber_availa;
@synthesize zoriginated = _zoriginated;
@synthesize zread = _zread;
@synthesize zdevice_id = _zdevice_id;
@synthesize ziso_country = _ziso_country;
@synthesize zname = _zname;
@synthesize zunique_id = _zunique_id;

@synthesize oTherName = _oTherName;
@synthesize countryCode = _countryCode;
@synthesize networkCode = _networkCode;
@synthesize read = _read;
@synthesize assisted = _assisted;
@synthesize faceTimeData = _faceTimeData;
@synthesize originalAddress = _originalAddress;
@synthesize answered = _answered;

@synthesize rowid = _rowid;
@synthesize address = _address;
@synthesize date = _date;
@synthesize callDateStr = _callDateStr;
@synthesize callTimeStr = _callTimeStr;
@synthesize callDate = _callDate;
@synthesize duration = _duration;
@synthesize flags = _flags;
@synthesize contactID = _contactID;
@synthesize callType = _callType;
@synthesize dateStr = _dateStr;
@synthesize name = _name;
@synthesize zlocation = _zlocation;
- (id)init {
    self = [super init];
    if (self) {
        _rowid = 0;
        _address = @"";
        _name = @"";
        _date = 0;
        _callDate = nil;
        _callDateStr = nil;
        _callTimeStr = nil;
        _flags = 0;
        _contactID = 0;
        _callType = CallingCall;
        
        _z_ent = 2;
        _z_opt = 1;
        _answered = 0;
        _zunmber_availa = 0;
        _zoriginated = 1;
        _read = 1;
        _zdevice_id = nil;
        _zname = nil;
        _callDateStr = @"";
        _callTimeStr = @"";
    }
    return self;
}

//- (NSString*)dateStr {
//    //这个地方用共通类来做
//    if (_dateStr != nil) {
//        return _dateStr;
//    } else {
//        //1.得到当前的时间
//        //2.与当前时间做对比，判断出星期1，2，3，4，5 6 7。
//        //3.时间偏移量等--在拿到ipod的那层添加
//        if (_date > 0)  {
//            NSDate *date = [IMBHelper getDateTimeFromTimeStamp1970:(long long)_date timeOffset:0];
//            _dateStr = [[IMBHelper getHistoryDateString:date] retain];
//            return _dateStr;
//            
//        }
//        return @"";
//    }
//}

- (NSDate*)callDate {
    if (_callDate != nil) {
        return _callDate;
    } else {
        if (_date > 0)  {
            _callDate = [[DateHelper getDateTimeFromTimeStamp1970:(long long)_date timeOffset:0] retain];
            return _callDate;
        } else {
            return nil;
        }
    }
}

//- (NSString*)callDateStr {
//    if (![StringHelper stringIsNilOrEmpty:_callDateStr]) {
//        return _callDateStr;
//    }
//    _callDateStr = [DateHelper dateFrom2001ToString:self.date withMode:1];
//    
//    return _callDateStr;
//}
//
//- (NSString*)callTimeStr {
//    if (![StringHelper stringIsNilOrEmpty:_callTimeStr]) {
//        return _callTimeStr;
//    }
//    _callTimeStr = [DateHelper dateFrom2001ToString:self.date withMode:6];
//    return _callTimeStr;
//}

- (NSString*) callTypeString {
    switch (_callType) {
        case CallingUnkonw:
            CustomLocalizedString(@"callhistory_id_2", nil);
        case CallingMissed:
            return CustomLocalizedString(@"callhistory_id_3", nil);
            break;
        case CallingReceive:
            return CustomLocalizedString(@"callhistory_id_4", nil);
            break;
        case CallingCanceled:
            return CustomLocalizedString(@"callhistory_id_5", nil);
        case CallingCall:
            return CustomLocalizedString(@"callhistory_id_6", nil);
            break;
        case CallingMissedFacetime:
            return CustomLocalizedString(@"callhistory_id_7", nil);
            break;
        case CallingCallFacetime:
            return CustomLocalizedString(@"callhistory_id_8", nil);
            break;
        case CallingReceiveFacetime:
            return CustomLocalizedString(@"callhistory_id_9", nil);
            break;
        case CallingCanceledFacetime:
            return CustomLocalizedString(@"callhistory_id_10", nil);
            break;
        default:
            return @"";
            break;
    }
}

- (void)dealloc {
    if (_callDate != nil) {
        [_callDate release];
        _callDate = nil;
    }
    if (_callDateStr != nil) {
        [_callDateStr release];
        _callDateStr = nil;
    }
    if (_callTimeStr != nil) {
        [_callTimeStr release];
        _callTimeStr = nil;
    }
    if (_dateStr != nil) {
        [_dateStr release];
        _dateStr = nil;
    }

    [super dealloc];
}

@end

@implementation IMBCallContactModel
@synthesize contactName = _contactName;
@synthesize callHistoryCount = _callHistoryCount;
@synthesize callHistoryList = _callHistoryList;
@synthesize Count = _Count;
@synthesize Size = _Size;
@synthesize lastcalldate = _lastcalldate;
@synthesize lastcallStr = _lastcallStr;
@synthesize lastCallStrForm2001 = _lastCallStrForm2001;
- (id)init {
    self = [super init];
    if (self) {
        _contactName = @"";
        _callHistoryCount = 0;
        _callHistoryList = [[NSMutableArray alloc] init];
        _Count = 0;
        _Size = 0;
        _lastcalldate = 0;
    }
    return self;
}

- (NSString*) lastcallStr {
    //这个地方用共通类来做
    if (_lastcallStr != nil) {
        return _lastcallStr;
    } else {
        //1.得到当前的时间
        //2.与当前时间做对比，判断出星期1，2，3，4，5 6 7。
        //3.时间偏移量等--在拿到ipod的那层添加
        if (_lastcalldate > 0)  {
            NSDate *lastcallDate = [DateHelper getDateTimeFromTimeStamp1970:(long)_lastcalldate timeOffset:0];
            _lastcallStr = [[DateHelper getHistoryDateString:lastcallDate] retain];
            return _lastcallStr;
            
            
        }
        return @"";
    }
}

- (NSMutableArray *)callHistoryList{
    if (_callHistoryList == nil) {
        _callHistoryList = [[NSMutableArray array] retain];
    }
    return _callHistoryList;

}

- (NSString *)lastCallStrForm2001 {
    if (_lastcalldate > 0)  {
        _lastCallStrForm2001 = [[DateHelper dateFrom2001ToString:_lastcalldate withMode:2] retain];
    }
    return _lastCallStrForm2001;
}

- (void)dealloc {
    if (_callHistoryList != nil) {
        [_callHistoryList release];
        _callHistoryList = nil;
    }
    
    if (_lastcallStr != nil) {
        [_lastcallStr release];
        _lastcallStr = nil;
    }
    if (_lastCallStrForm2001 != nil) {
        [_lastCallStrForm2001 release];
        _lastCallStrForm2001 = nil;
    }

    [super dealloc];
}

@end

@implementation IMBContactInfoModel
@synthesize rowID = _rowID;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize middleName = _middleName;
@synthesize displayName = _displayName;
@synthesize phoneContent = _phoneContent;
@synthesize image = _image;

- (id)init {
    self = [super init];
    if (self) {
        _rowID = 0;
        _firstName = @"";
        _lastName = @"";
        _middleName = @"";
        _displayName = @"";
        _phoneContent = @"";
        _image = nil;
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end



