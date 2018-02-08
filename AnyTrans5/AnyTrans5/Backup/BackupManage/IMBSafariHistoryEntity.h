//
//  IMBSafariHistoryEntity.h
//  PhoneRescue
//
//  Created by iMobie on 3/23/16.
//  Copyright (c) 2016 iMobie Inc. All rights reserved.
//

#import "IMBBaseEntity.h"

@interface IMBSafariHistoryEntity : IMBBaseEntity {
@private
    int _keyId;
    NSString *_forwardURL;
    double _lastVisitedDate;
    NSDate *_visitedDate;//打电话的时间
    NSString *_visitedDateStr;
    NSString *_visitedTimeStr;
    NSString *_lastVisiteDateStr;
    NSString *_title;
    int _visitCount;
    
    
    int _historyItem;
    BOOL _loadSuccessful;
    BOOL _httpNonGet;
    BOOL _synthesized;
    int _redirectSource;
    int _redirectDestination;
    int _origin;
    int _generation;
    NSString *_domainExpansion;
    NSData *_dailyVisitCounts;
    NSData *_weeklyVisitCounts;
    NSData *_autocompleteTriggers;
    int _shouldRecomputeDerivedVisitCounts;
    
    NSArray *_redirectSourceUrl;
}

@property (nonatomic, readwrite) int keyId;
@property (nonatomic, readwrite, retain) NSString *forwardURL;
@property (nonatomic, readwrite) double lastVisitedDate;
@property (nonatomic, readwrite, retain) NSDate *visitedDate;
@property (nonatomic, readwrite, retain) NSString *visitedDateStr;
@property (nonatomic, readwrite, retain) NSString *visitedTimeStr;
@property (nonatomic, readwrite, retain) NSString *lastVisiteDateStr;
@property (nonatomic, readwrite, retain) NSString *title;
@property (nonatomic, readwrite) int visitCount;

@property (nonatomic, readwrite) int historyItem;
@property (nonatomic, readwrite) BOOL loadSuccessful;
@property (nonatomic, readwrite) BOOL httpNonGet;
@property (nonatomic, readwrite) BOOL synthesized;
@property (nonatomic, readwrite) int redirectSource;
@property (nonatomic, readwrite) int redirectDestination;
@property (nonatomic, readwrite) int origin;
@property (nonatomic, readwrite) int generation;
@property (nonatomic, readwrite, retain) NSString *domainExpansion;
@property (nonatomic, readwrite, retain) NSData *dailyVisitCounts;
@property (nonatomic, readwrite, retain) NSData *weeklyVisitCounts;
@property (nonatomic, readwrite, retain) NSData *autocompleteTriggers;
@property (nonatomic, readwrite) int shouldRecomputeDerivedVisitCounts;
@property (nonatomic, readwrite, retain) NSArray *redirectSourceUrl;

@end

