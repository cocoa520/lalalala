//
//  IMBNoteDataEntity.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-3-23.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBNoteDataEntity.h"

@implementation IMBNoteDataEntity
@synthesize zpk = _zpk;
@synthesize contentType = _contentType;
@synthesize deleteFlag = _deleteFlag;
@synthesize creationDate = _creationDate;
@synthesize modificationDate = _modificationDate;
@synthesize author = _author;
@synthesize serverID = _serverID;
@synthesize summary = _summary;
@synthesize content = _content;
@synthesize title = _title;
@synthesize guid =_guid;
@synthesize contentData = _contentData;
@synthesize attachmentList = _attachmentList;

- (id)init {
    self = [super init];
    if (self) {
        _zpk = 0;
        _contentType = 0;
        _deleteFlag = 0;
        _creationDate = 0;
        _modificationDate = 0;
        _contentData = nil;
        _attachmentList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (_author != nil) {
        [_author release];
    }
    if (_serverID != nil) {
        [_serverID release];
    }
    if (_summary != nil) {
        [_summary release];
    }
    if (_content != nil) {
        [_content release];
    }
    if (_title != nil) {
        [_title release];
    }
    if (_guid != nil) {
        [_guid release];
    }
    if (_attachmentList != nil) {
        [_attachmentList release];
        _attachmentList = nil;
    }
    [super dealloc];
}

@end

@implementation IMBNoteAttachmentEntity
@synthesize attachmentId = _attachmentId;
@synthesize mediaId = _mediaId;
@synthesize fileSize = _fileSize;
@synthesize date = _date;
@synthesize fileName = _fileName;
@synthesize attachDetailList = _attachDetailList;
@synthesize identifier = _identifier;
@synthesize allAttachId = _allAttachId;
@synthesize allPreviewId = _allPreviewId;
@synthesize zpk = _zpk;
- (id)init {
    if (self = [super init]) {
        _attachmentId = 0;
        _mediaId = 0;
        _fileSize = 0;
        _date = 0;
        _fileName = @"";
        _attachDetailList = [[NSMutableArray alloc] init];
        _allAttachId  = [[NSMutableArray alloc] init];
        _allPreviewId = [[NSMutableArray alloc] init];
        _identifier = @"";
    }
    return self;
}

- (void)dealloc
{
    if (_attachDetailList != nil) {
        [_attachDetailList release];
        _attachDetailList = nil;
    }
    if (_allAttachId != nil) {
        [_allAttachId release];
        _allAttachId = nil;
    }
    if (_allPreviewId != nil) {
        [_allPreviewId release];
        _allPreviewId = nil;
    }
    [super dealloc];
}

@end

//    Z_ENT, Z_OPT, ZCONTAINSCJK, ZCONTENTTYPE,ZDELETEDFLAG,ZISBOOKKEEPINGENTRY,ZBODY, ZSTORE, ZCREATIONDATE, ZMODIFICATIONDATE,ZGUID, ZTITLE

@implementation IMBNoteModelEntity
@synthesize noteKey = _noteKey;
@synthesize contentType = _contentType;
@synthesize serverID = _serverID;
@synthesize rowID = _rowID;
@synthesize mediaId = _mediaId;
@synthesize modifyDate = _modifyDate;
@synthesize attachmentAry = _attachmentAry;
@synthesize title = _title;
@synthesize content = _content;
@synthesize contentData = _contentData;
@synthesize noteSize = _noteSize;
@synthesize zpk = _zpk;
@synthesize zcontentType = _zcontentType;
@synthesize zdeletedFlag = _zdeletedFlag;
@synthesize zcreaTionDate = _zcreaTionDate;
@synthesize zmodificationDate = _zmodificationDate;
@synthesize ztitle = _ztitle;
@synthesize creatDate = _creatDate;
@synthesize zaccount = _zaccount;
@synthesize summary = _summary;
@synthesize zidentifier = _zidentifier;
@synthesize zsnippet = _zsnippet;

@synthesize zcloudsyncingobject = _zcloudsyncingobject;
@synthesize ZLOCALVERSIONDATE = _ZLOCALVERSIONDATE;
@synthesize author = _author;
@synthesize guid = _guid;
@synthesize creatDateStr = _creatDateStr;
@synthesize modifyDateStr = _modifyDateStr;
@synthesize isNew = _isNew;
@synthesize shortDateStr = _shortDateStr;

-(id)init{
    if ([super init]) {
        _attachmentAry = [[NSMutableArray alloc]init];
        _modifyDateStr = @"";
        _creatDateStr = @"";
        _shortDateStr = @"";
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    if (_attachmentAry != nil) {
        [_attachmentAry release];
        _attachmentAry = nil;
    }
}
@end