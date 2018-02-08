//
//  IMBVoiceMailEntity.h
//  PhoneRescue
//
//  Created by iMobie on 3/23/16.
//  Copyright (c) 2016 iMobie Inc. All rights reserved.
//

#import "IMBBaseEntity.h"
@class IMBMBFileRecord;
@interface IMBVoiceMailEntity : IMBBaseEntity {
@private
    int32_t _rowid;
    int32_t _remoteUid;
    int64_t _date;
    NSString *_token;
    NSString *_sender;
    NSString *_callbackNum;
    int32_t _duration;
    int32_t _expiration;
    int64_t _trashedDate;
    int32_t _flags;
    NSString *_stateStr;
    IMBMBFileRecord *_voicemailRecord;
    NSString *_dateStr;
    NSString *_trashedDateStr;
    NSString *_path;
    long long _size;
    BOOL _fileIsExist;
}
@property (nonatomic,assign,readwrite) BOOL fileIsExist;
@property (nonatomic,retain)IMBMBFileRecord *voicemailRecord;
@property (nonatomic,assign) int32_t rowid;
@property (nonatomic,assign,readwrite) int32_t remoteUid;
@property (nonatomic,assign,readwrite) int64_t date;
@property (nonatomic,retain,readwrite) NSString *token;
@property (nonatomic,retain,readwrite) NSString *sender;
@property (nonatomic,retain,readwrite) NSString *callbackNum;
@property (nonatomic,assign,readwrite) int32_t duration;
@property (nonatomic,assign,readwrite) int32_t expiration;
@property (nonatomic,assign,readwrite) int64_t trashedDate;
@property (nonatomic,assign,readwrite) int32_t flags;
@property (nonatomic,retain,readwrite) NSString *path;

@property (nonatomic,retain,readwrite) NSString *dateStr;
@property (nonatomic,retain,readwrite) NSString *trashedDateStr;
@property (nonatomic,retain,readwrite) NSString *stateStr;
@property (nonatomic,readwrite) long long size;

@end

@interface IMBVoiceMailAccountEntity : IMBBaseEntity {
    NSString *_contactName;
    NSImage *_iconImage;
    int _totalCount;
    NSString *_senderStr;
    NSMutableArray *_subArray;//装IMBVoiceMailEntity实体对象
}
@property (nonatomic,retain) NSString *contactName;
@property (nonatomic,retain) NSImage *iconImage;
@property (nonatomic,assign) int totalCount;
@property (nonatomic,retain) NSString *senderStr;
@property (nonatomic,retain) NSMutableArray *subArray;
@end
