//
//  IMBSafariHistoryEntity.m
//  PhoneRescue
//
//  Created by iMobie on 3/23/16.
//  Copyright (c) 2016 iMobie Inc. All rights reserved.
//

#import "IMBSafariHistoryEntity.h"
#import "DateHelper.h"
#import "StringHelper.h"
@implementation IMBSafariHistoryEntity
@synthesize keyId = _keyId;
@synthesize forwardURL = _forwardURL;
@synthesize lastVisitedDate = _lastVisitedDate;
@synthesize visitedDate = _visitedDate;
@synthesize visitedDateStr = _visitedDateStr;
@synthesize visitedTimeStr = _visitedTimeStr;
@synthesize lastVisiteDateStr = _lastVisiteDateStr;
@synthesize title = _title;
@synthesize visitCount = _visitCount;
@synthesize historyItem = _historyItem;
@synthesize loadSuccessful = _loadSuccessful;
@synthesize httpNonGet = _httpNonGet;
@synthesize synthesized = _synthesized;
@synthesize redirectSource = _redirectSource;
@synthesize redirectDestination = _redirectDestination;
@synthesize origin =_origin;
@synthesize generation = _generation;
@synthesize domainExpansion = _domainExpansion;
@synthesize dailyVisitCounts = _dailyVisitCounts;
@synthesize weeklyVisitCounts = _weeklyVisitCounts;
@synthesize autocompleteTriggers = _autocompleteTriggers;
@synthesize shouldRecomputeDerivedVisitCounts = _shouldRecomputeDerivedVisitCounts;
@synthesize redirectSourceUrl = _redirectSourceUrl;

- (id)init {
    self = [super init];
    if (self) {
        _keyId = 0;
        _forwardURL = @"";
        _lastVisitedDate = 0;
        _visitedDate = nil;
        _visitedDateStr = nil;
        _visitedTimeStr = nil;
        _lastVisiteDateStr = @"";
        _title = @"";
        _visitCount = 0;
        
        _historyItem = -1;
        _loadSuccessful = 1;
        _httpNonGet = 0;
        _synthesized = 0;
        _redirectSource = 0;
        _redirectDestination = 0;
        _origin = 0;
        _generation = 0;
        _domainExpansion = nil;
        _dailyVisitCounts = nil;
        _weeklyVisitCounts = nil;
        _autocompleteTriggers = nil;
        _shouldRecomputeDerivedVisitCounts = 0;
        _redirectSourceUrl = nil;
    }
    return self;
}

- (void)dealloc {
    if (_visitedDate != nil) {
        [_visitedDate release];
        _visitedDate = nil;
    }
    if (_visitedDateStr != nil) {
        [_visitedDateStr release];
        _visitedDateStr = nil;
    }
    if (_visitedTimeStr != nil) {
        [_visitedTimeStr release];
        _visitedTimeStr = nil;
    }
    if (_lastVisiteDateStr != nil) {
        [_lastVisiteDateStr release];
        _lastVisiteDateStr = nil;
    }
    if (_redirectSourceUrl != nil) {
        [_redirectSourceUrl release];
        _redirectSourceUrl = nil;
    }
    [super dealloc];
}

- (NSDate*)visitedDate {
    if (_visitedDate != nil) {
        return _visitedDate;
    } else {
        if (self.lastVisitedDate > 0)  {
            _visitedDate = [[DateHelper getDateTimeFromTimeStamp2001:(uint)self.lastVisitedDate] retain];
            return _visitedDate;
        } else {
            return nil;
        }
    }
}

- (NSString*)visitedDateStr {
    if (![StringHelper stringIsNilOrEmpty:_visitedDateStr]) {
        return _visitedDateStr;
    }
    if (self.visitedDate != nil) {
        NSDateFormatter *df=[[NSDateFormatter alloc] init];
        [df setDateFormat:@"EEEE,MMM dd,yyyy,HH:mm"];
        _visitedDateStr = [[df stringFromDate:self.visitedDate] retain];
        [df release];
        df = nil;
    } else {
        _visitedDateStr = @"";
    }
    return _visitedDateStr;
}

- (NSString*)visitedTimeStr {
    if (![StringHelper stringIsNilOrEmpty:_visitedTimeStr]) {
        return _visitedTimeStr;
    }
    if (self.visitedDate != nil) {
        NSDateFormatter *df=[[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm"];
        _visitedTimeStr = [[df stringFromDate:self.visitedDate] retain];
        [df release];
        df = nil;
    } else {
        _visitedTimeStr = @"";
    }
    return _visitedTimeStr;
}

@end
