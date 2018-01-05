//
//  IMBCallHistoryDataEntity.h
//  DataRecovery
//
//  Created by iMobie on 4/22/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBaseEntity.h"
#import "IMBCommonEnum.h"
@interface IMBCallHistoryDataEntity : IMBBaseEntity {
@private
    NSString *_name;
    int _rowid; //唯一ID
    NSString *_address;//号码
    double _date;//时间
    NSDate *_callDate;//打电话的时间
    NSString *_callDateStr;
    NSString *_callTimeStr;
    NSString *_dateStr;
    
    int _duration;//时长
    int _flags;//标示
    int _contactID;//联系人标示
    
    CallingTypeEnum _callType;//通话类别
    NSString *_zlocation;
    int _z_ent;
    int _z_opt;
    int _zanswered;
    int _zdisconnecten_cause;
    int _zface_time;
    int _zunmber_availa;
    int _zoriginated;
    int _zread;
    NSString *_zdevice_id;
    NSString *_ziso_country;
    NSString *_zname;
    NSString *_zunique_id;
    //8以下
    NSString *_oTherName;
    NSString *_countryCode;
    NSString *_networkCode;
    int _read;
    int _assisted;
    int _faceTimeData;
    NSString *_originalAddress;
    int _answered;
}
@property (nonatomic, retain) NSString *zlocation;
@property (nonatomic, readwrite) int z_ent;
@property (nonatomic, readwrite) int z_opt;
@property (nonatomic, readwrite) int zanswered;
@property (nonatomic, readwrite) int zdisconnecten_cause;
@property (nonatomic, readwrite) int zface_time;
@property (nonatomic, readwrite) int zunmber_availa;
@property (nonatomic, readwrite) int zoriginated;
@property (nonatomic, readwrite) int zread;
@property (nonatomic, readwrite,retain) NSString *zdevice_id;
@property (nonatomic, readwrite,retain) NSString *ziso_country;
@property (nonatomic, readwrite,retain) NSString *zname;
@property (nonatomic, readwrite,retain) NSString *zunique_id;
//8以下
@property (nonatomic, readwrite,retain) NSString *oTherName;
@property (nonatomic, readwrite,retain) NSString *countryCode;
@property (nonatomic, readwrite,retain) NSString *networkCode;
@property (nonatomic, readwrite) int read;
@property (nonatomic, readwrite) int assisted;
@property (nonatomic, readwrite) int faceTimeData;
@property (nonatomic, readwrite,retain) NSString *originalAddress;
@property (nonatomic, readwrite) int answered;


@property (nonatomic, readwrite) int rowid;
@property (nonatomic, readwrite, retain) NSString *address;
@property (nonatomic, readwrite) double date;
@property (nonatomic, readwrite, retain) NSDate *callDate;
@property (nonatomic, readwrite, retain) NSString *callDateStr;
@property (nonatomic, readwrite, retain) NSString *callTimeStr;
@property (nonatomic, readwrite, retain) NSString *name;
@property (nonatomic, readwrite) int duration;
@property (nonatomic, readwrite) int flags;
@property (nonatomic, readwrite) int contactID;
@property (nonatomic, readwrite) CallingTypeEnum callType;
@property (nonatomic, readwrite, retain) NSString *dateStr;

- (NSString*) callTypeString;

@end

@interface IMBCallContactModel : IMBBaseEntity {
@private
    NSString *_contactName;                     // 联系人姓名
    int _callHistoryCount;                      // 该联系人通话记录的个数
    NSMutableArray *_callHistoryList;           // IMBCallHistoryDataEntity数据列表记录
    NSString *_imageName;                       //测试用
    int _Count;                                 //测试用
    int _Size;                                  //测试用
    double _lastcalldate;                       //最近一次通话
    NSString *_lastcallStr;                     //最近一次通话字符
    
    NSString *_lastCallStrForm2001;
}

@property (nonatomic, readwrite, retain) NSString *contactName;
@property (nonatomic, readwrite) int callHistoryCount;
@property (nonatomic, readwrite, retain) NSMutableArray *callHistoryList;
@property (nonatomic, readwrite) int Count;
@property (nonatomic, readwrite) int Size;
@property (nonatomic, readwrite, retain) NSString *lastcallStr;
@property (nonatomic, readwrite) double lastcalldate;

@property (nonatomic, readwrite, retain) NSString *lastCallStrForm2001;
@end

@interface IMBContactInfoModel : NSObject {
@private
    int _rowID;
    NSString *_firstName;
    NSString *_lastName;
    NSString *_middleName;
    NSString *_displayName;
    NSString *_phoneContent;
    NSImage *_image;
}

@property (nonatomic, readwrite) int rowID;
@property (nonatomic, readwrite, retain) NSString *firstName;
@property (nonatomic, readwrite, retain) NSString *lastName;
@property (nonatomic, readwrite, retain) NSString *middleName;
@property (nonatomic, readwrite, retain) NSString *displayName;
@property (nonatomic, readwrite, retain) NSString *phoneContent;
@property (nonatomic, readwrite, retain) NSImage *image;

@end