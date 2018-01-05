//
//  IMBiCloudCalendarEventEntity.h
//  AnyTrans
//
//  Created by iMobie on 2/6/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBCalendarEventEntity.h"

@class IMBiCloudManager;
@interface IMBiCloudCalendarEventEntity : IMBCalendarEventEntity {
    NSString *_guid;
    NSString *_pGuid;
    NSString *_eventStatus;
    NSString *_etag;
    int _duration;
    BOOL _isComplete;
    
    /*reminder 信息
     {
     alarms =             (
        {
            description = "Event reminder";
            guid = "5E23EDA5-10F9-4C34-886A-3ACD6CF1B973";
            isLocationBased = 0;
            measurement = "<null>";
            messageType = message;
            onDate =                     (
                20170208,
                2017,
                2,
                8,
                15,
                0,
                900
            );
            proximity = "<null>";
        }
     );
     completedDate = "<null>";
     createdDate =             (
        20170207,
        2017,
        2,
        7,
        13,
        2,
        782
     );
     createdDateExtended = 508165351;
     description = "<null>";
     dueDate =             (
        20170208,
        2017,
        2,
        8,
        15,
        0,
        900
     );
     dueDateIsAllDay = 0;
     etag = "C=5321@U=a85f1600-7029-4905-a5a2-301540befe54";
     guid = "087FC344-A1D1-47D6-B168-A3CB5783F0D5";
     lastModifiedDate =             (
        20170208,
        2017,
        2,
        8,
        6,
        15,
        375
     );
     order = "<null>";
     pGuid = "892EB6E7-4CCF-4978-9F61-71441E414BEB";
     priority = 0;
     recurrence =             {
        byDay = "<null>";
        byMonth = "<null>";
        count = "<null>";
        freq = daily;
        frequencyDays = "<null>";
        interval = 1;
        until = "<null>";
        weekDays = "<null>";
        weekStart = MO;
     };
     startDate = "<null>";
     startDateIsAllDay = 1;
     startDateTz = "<null>";
     title = ghjghjgjghjgjh;
     },
     */
    //Reminder
    long long _completeTime;
    long long _createdTime;
    long long _createdDateExtended;
    long long _dueTime;
    BOOL _dueDateIsAllDay;
    long long _lastModifiedTime;
    long long _order;
    int _priority;
    long long _startTime;
    BOOL _startDateIsAllDay;
    NSString *_startDateTz;
    //recurrence
    NSString *_byDay;
    NSString *_byMonth;
    NSString *_count;
    NSString *_freq;
    NSString *_frequencyDays;
    NSString *_interval;
    NSString *_until;
    NSString *_weekDays;
    NSString *_weekStart;
    
    /*{calendar 信息
        alarms =             (
                              "85a171c7-594c-4a37-9943-facb1d3ede8a__20171222T000000:04555A00-D8E9-45A9-817E-55101664C221"
                              );
        allDay = 1;
        birthdayBirthDate = "<null>";
        birthdayCompanyName = "<null>";
        birthdayFirstName = "<null>";
        birthdayIsYearlessBday = "<null>";
        birthdayLastName = "<null>";
        birthdayNickname = "<null>";
        birthdayShowAsCompany = "<null>";
        duration = 1440;
        endDate =             (
                               20171223,
                               2017,
                               12,
                               23,
                               0,
                               0,
                               0
                               );
        etag = "C=3491@U=a85f1600-7029-4905-a5a2-301540befe54";
        eventStatus = "<null>";
        extendedDetailsAreIncluded = 0;
        guid = "85a171c7-594c-4a37-9943-facb1d3ede8a__20171222T000000";
        hasAttachments = 0;
        icon = 0;
        localEndDate =             (
                                    20171223,
                                    2017,
                                    12,
                                    23,
                                    0,
                                    0,
                                    0
                                    );
        localStartDate =             (
                                      20171222,
                                      2017,
                                      12,
                                      22,
                                      0,
                                      0,
                                      0
                                      );
        location = "<null>";
        pGuid = "FE732190-C665-4E5C-8E84-33FFDA4D118C";
        readOnly = 0;
        recurrence = "85a171c7-594c-4a37-9943-facb1d3ede8a*MME-RID";
        recurrenceException = 0;
        recurrenceMaster = 0;
        shouldShowJunkUIWhenAppropriate = 1;
        startDate =             (
                                 20171222,
                                 2017,
                                 12,
                                 22,
                                 0,
                                 0,
                                 0
                                 );
        title = "Pappa's Birthday";
        tz = "<null>";
    }
     */
    //calendar
    int _extendedDetailsAreIncluded;
    BOOL _hasAttachments;
    int _icon;
    int _readOnly;
    int _recurrenceException;
    int _recurrenceMaster;
    int _shouldShowJunkUIWhenAppropriate;
    NSString *_tz;
    long long _endCalTime;
    long long _startCalTime;
    long long _loaclStartTime;
    long long _localEndTime;
    
    NSString *_recurrence;
    NSArray *_alarm;    //属性alarm
    NSArray *_invitees;  //属性invitees
    NSArray *_Recurrences; //编辑时需要用到 recurrence的详细信息
    NSArray *_Alarms; //编辑时需要用到 alarm的详细信息
    NSArray *_Invitee; //编辑时需要用到 invitees的详细信息
    BOOL _addDetailContent;//是否加载详细信息
    NSMutableArray *_createDate;// 里面是int类型
    NSMutableArray *_dueDate; // 里面是int类型
    
    NSString *_groupTitle;

    IMBiCloudManager *_icloudManager;
}

@property (nonatomic, assign) IMBiCloudManager *icloudManager;
@property (nonatomic, assign) BOOL addDetailContent;
@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSArray *alarm;
@property (nonatomic, retain) NSArray *invitees;
@property (nonatomic, retain) NSArray *Recurrences;
@property (nonatomic, retain) NSArray *Alarms;
@property (nonatomic, retain) NSArray *Invitee;

@property (nonatomic, retain) NSString *pGuid;
@property (nonatomic, retain) NSString *eventStatus;
@property (nonatomic, retain) NSString *etag;
@property (nonatomic, assign) int duration;
@property (nonatomic, assign) BOOL isComplete;
//Reminder
@property (nonatomic, assign) long long completeTime;
@property (nonatomic, assign) long long createdTime;
@property (nonatomic, assign) long long createdDateExtended;
@property (nonatomic, assign) long long dueTime;
@property (nonatomic, assign) BOOL dueDateIsAllDay;
@property (nonatomic, assign) long long lastModifiedTime;
@property (nonatomic, assign) long long order;
@property (nonatomic, assign) int priority;
@property (nonatomic, assign) long long startTime;
@property (nonatomic, assign) BOOL startDateIsAllDay;
@property (nonatomic, retain) NSString *startDateTz;
//recurrence
@property (nonatomic, retain) NSString *byDay;
@property (nonatomic, retain) NSString *byMonth;
@property (nonatomic, retain) NSString *count;
@property (nonatomic, retain) NSString *freq;
@property (nonatomic, retain) NSString *frequencyDays;
@property (nonatomic, retain) NSString *interval;
@property (nonatomic, retain) NSString *until;
@property (nonatomic, retain) NSString *weekDays;
@property (nonatomic, retain) NSString *weekStart;
//calendar
@property (nonatomic, assign) int extendedDetailsAreIncluded;
@property (nonatomic, assign) BOOL hasAttachments;
@property (nonatomic, assign) int icon;
@property (nonatomic, assign) int readOnly;
@property (nonatomic, assign) int recurrenceException;
@property (nonatomic, assign) int recurrenceMaster;
@property (nonatomic, assign) int shouldShowJunkUIWhenAppropriate;
@property (nonatomic, retain) NSString *tz;
@property (nonatomic, assign) long long endCalTime;
@property (nonatomic, assign) long long startCalTime;
@property (nonatomic, assign) long long localStartTime;
@property (nonatomic, assign) long long localEndTime;
@property (nonatomic, retain) NSString *recurrence;
@property (nonatomic, retain) NSMutableArray *createDate;
@property (nonatomic, retain) NSMutableArray *dueDate;
@property (nonatomic, retain) NSString *groupTitle;

- (void)loadDetailContent;
@end

@interface IMBiCloudCalendarCollectionEntity : IMBBaseModel {
    NSString *_guid;
    NSString *_title;
    NSString *_ctag;
    NSString *_modifiedDateStr;
    NSString *_createdDataStr;
    NSString *_description;
    NSInteger _tag;
    int _order;
    NSString *_color;
    NSString *_symbolicColor;
    BOOL _enabled;
    NSString *_emailNotification;
    NSMutableArray *_createdDate;//里面是String
    BOOL _isFamily;
    NSString *_collectionShareType;
    NSString *_createdDateExtended;
    int _completedCount;
    NSMutableArray *_participants;//里面是ParticipantModel
    NSMutableArray *_subArray;

}
@property (nonatomic, retain) NSMutableArray *subArray;
@property (nonatomic, retain) NSString *guid;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *ctag;
@property (nonatomic, retain) NSString *modifiedDateStr;
@property (nonatomic, retain) NSString *createdDataStr;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) int order;
@property (nonatomic, retain) NSString *color;
@property (nonatomic, retain) NSString *symbolicColor;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, retain) NSString *emailNotification;
@property (nonatomic, retain) NSMutableArray *createdDate;
@property (nonatomic, assign) BOOL isFamily;
@property (nonatomic, retain) NSString *collectionShareType;
@property (nonatomic, retain) NSString *createdDateExtended;
@property (nonatomic, assign) int completedCount;
@property (nonatomic, retain) NSMutableArray *participants;
@end

@interface ParticipantModel : NSObject
{
    BOOL _isMe;
    NSString *_commonName;
    NSString *_status;
    NSString *_email;
    NSString *_dsid;
    NSString *_participantShareType;
}
@property (nonatomic, assign) BOOL isMe;
@property (nonatomic, retain) NSString *commonName;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *dsid;
@property (nonatomic, retain) NSString *participantShareType;



@end
