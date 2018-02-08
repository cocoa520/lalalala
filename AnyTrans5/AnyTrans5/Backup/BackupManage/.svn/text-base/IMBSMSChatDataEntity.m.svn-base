//
//  IMBSMSChatDataEntity.m
//  DataRecovery
//
//  Created by iMobie on 4/15/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBSMSChatDataEntity.h"
#import "StringHelper.h"
#import "DateHelper.h"
@implementation IMBSMSChatDataEntity
@synthesize sessionType = _sessionType;
@synthesize style = _style;
@synthesize state = _state;
@synthesize account_id = _account_id;
@synthesize properties = _properties;
@synthesize service_name = _service_name;
@synthesize room_name = _room_name;
@synthesize account_login = _account_login;
@synthesize is_archived = _is_archived;
@synthesize last_addressed_handle = _last_addressed_handle;
@synthesize display_name = _display_name;

@synthesize hand_country = _hand_country;
@synthesize hand_service = _hand_service;
@synthesize hand_uncanonicalized = _hand_uncanonicalized;

@synthesize rowId = _rowId;
@synthesize chatGuid = _chatGuid;
@synthesize handleId = _handleId;
@synthesize handle_id = _handle_id;
@synthesize handleService = _handleService;
@synthesize chatIdentifier = _chatIdentifier;
@synthesize contactName = _contactName;
@synthesize msgModelList = _msgModelList;

@synthesize messageCount = _messageCount;
@synthesize messageSize = _messageSize;
@synthesize attachmentCount = _attachmentCount;
@synthesize attachmentSize = _attachmentSize;
@synthesize groupID = _groupID;
@synthesize lastMsgText = _lastMsgText;
@synthesize msgDate = _msgDate;
@synthesize lastMsgTime = _lastMsgTime;

@synthesize isExistTwo = _isExistTwo;
@synthesize iMAccount_login = _iMAccount_login;
@synthesize iMChatGuid = _iMChatGuid;
@synthesize iMHandle_id = _iMHandle_id;
@synthesize iMHandleId = _iMHandleId;
@synthesize iMHandleService = _iMHandleService;
@synthesize iMRowId = _iMRowId;
@synthesize headImage = _headImage;

@synthesize groupHash = _groupHash;
@synthesize groupnewestMessage = _groupnewestMessage;
@synthesize groupType = _groupType;
@synthesize addressArray = _addressArray;
@synthesize groupROWIDArray = _groupROWIDArray;
@synthesize timeStr = _timeStr;

@synthesize lastMsgTimeWithSecond = _lastMsgTimeWithSecond;
- (id)init {
    self = [super init];
    if (self) {
        _groupHash = 0;
        _groupnewestMessage = 0;
        _groupType = 0;
        _rowId = 0;
        _groupID = 0;
        _chatGuid = @"";
        _handleId = @"";
        _handle_id = 0;
        _handleService = @"";
        _chatIdentifier = @"";
        _lastMsgText = @"";
        _lastMsgTime = @"";
        _msgModelList = [[NSMutableArray alloc] init];
        
        _messageCount = 0;
        _messageSize = 0;
        _attachmentCount = 0;
        _attachmentSize = 0;
        _headImage = nil;
        _lastMsgTimeWithSecond = @"";
    }
    return self;
}

- (void)dealloc {
    if (_msgModelList != nil) {
        [_msgModelList release];
        _msgModelList = nil;
    }
    [_addressArray release],_addressArray = nil;
    [_groupROWIDArray release],_groupROWIDArray = nil;
    [super dealloc];
}

- (NSMutableArray *)addressArray
{
    if (!_addressArray) {
        _addressArray = [[NSMutableArray array] retain];
    }
    return _addressArray;
}

- (NSMutableArray *)groupROWIDArray
{
    if (!_groupROWIDArray) {
        _groupROWIDArray = [[NSMutableArray array] retain];
    }
    return _groupROWIDArray;
}

- (int)contactRowID {
    return _rowId;
}

- (NSMutableArray *)messaline {
    return _msgModelList;
}

@end

@implementation IMBMessageDataEntity

@synthesize rowId = _rowId;
@synthesize msgText = _msgText;
@synthesize handleId = _handleId;
@synthesize subject = _subject;
@synthesize msgDate = _msgDate;
@synthesize msgShortDateStr = _msgShortDateStr;
@synthesize msgReadDate = _msgReadDate;
@synthesize msgDateText = _msgDateText;
@synthesize msgReadDateText = _msgReadDateText;
@synthesize isTextMedia = _isTextMedia;
@synthesize isDelivered = _isDelivered;
@synthesize isFinished = _isFinished;
@synthesize isAttachments = _isAttachments;
@synthesize isRead = _isRead;
@synthesize isSent = _isSent;
@synthesize attachmentInfoDic = _attachmentInfoDic;
@synthesize madridDateRead = _madridDateRead;
@synthesize madridDateDelivered = _madridDateDelivered;
@synthesize attachmentList = _attachmentList;

@synthesize attachmentCount = _attachmentCount;
@synthesize attachmentSize = _attachmentSize;
@synthesize messageSize = _messageSize;
@synthesize flags = _flags;
@synthesize madridHandle = _madridHandle;


@synthesize guid = _guid;
@synthesize replace = _replace;
@synthesize service_center = _service_center;
@synthesize country = _country;
@synthesize attributedBody = _attributedBody;
@synthesize version = _version;
@synthesize type = _type;
@synthesize service = _service;
@synthesize account = _account;
@synthesize account_guid = _account_guid;
@synthesize error = _error;
@synthesize date_delivered = _date_delivered;
@synthesize is_emote = _is_emote;
@synthesize is_from_me = _is_from_me;
@synthesize is_empty = _is_empty;
@synthesize is_delayed = _is_delayed;
@synthesize is_auto_reply = _is_auto_reply;
@synthesize is_prepared = _is_prepared;
@synthesize is_system_message = _is_system_message;
@synthesize has_dd_results = _has_dd_results;
@synthesize is_service_message = _is_service_message;
@synthesize is_forward = _is_forward;
@synthesize was_downgraded = _was_downgraded;
@synthesize is_archive = _is_archive;
@synthesize cache_roomnames = _cache_roomnames;
@synthesize was_deduplicated = _was_deduplicated;
@synthesize was_data_detected = _was_data_detected;
@synthesize is_audio_message = _is_audio_message;
@synthesize mergeStruct = _mergeStruct;
@synthesize contactName = _contactName;
@synthesize chat = _chat;
@synthesize sessionType = _sessionType;
- (id)init {
    self = [super init];
    if (self) {
        _rowId = 0;
        _msgText = @"";
        _handleId = 0;
        _subject = @"";
        _msgDate = 0;
        _msgShortDateStr = nil;
        _msgReadDate = 0;
        _msgDateText = @"";
        _msgReadDateText = @"";
        _isTextMedia = NO;
        _isDelivered = NO;
        _isFinished = NO;
        _isAttachments = NO;
        _isRead = NO;
        _isSent = NO;
        _attachmentInfoDic = [[NSMutableDictionary alloc] init];
        _madridDateRead = 0;
        _madridDateDelivered = 0;
        _attachmentList = [[NSMutableArray alloc] init];
        _flags = 0;
        
        _attachmentCount = 0;
        _attachmentSize = 0;
        //        _cleanAttachmentCount = 0;
        //        _cleanAttachmentSize = 0;
        _messageSize = 0;
        _madridHandle = @"";
        _service = @"";
        _mergeStruct = (MessageMergeStruct *)malloc(sizeof(MessageMergeStruct));
    }
    return self;
}

- (void)dealloc {

    free(_mergeStruct);
    if (_msgShortDateStr != nil) {
        [_msgShortDateStr release];
        _msgShortDateStr = nil;
    }
    
    if (_attachmentInfoDic != nil) {
        [_attachmentInfoDic release];
        _attachmentInfoDic = nil;
    }
    
    if (_attachmentList != nil) {
        [_attachmentList release];
        _attachmentList = nil;
    }
    
    [super dealloc];
}

- (int)msgRowID {
    return _rowId;
}

- (NSString *)messageText {
    return _msgText;
}

- (int64_t)messageDate {
    return _msgDate;
}

- (NSString*)msgShortDateStr {
    if (![StringHelper stringIsNilOrEmpty:_msgShortDateStr]) {
        return _msgShortDateStr;
    } else {
        NSDate *date = [DateHelper getDateTimeFromTimeStamp2001:(uint)self.msgDate];
//        + (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate
        _msgShortDateStr = [[DateHelper stringFromFomate:date formate:@"yyyy/MM/dd HH:mm:ss"] retain];
        return _msgShortDateStr;
    }
}

- (int64_t)messageReadDate {
    return _msgReadDate;
}

- (NSMutableArray *)attachmentData {
    return _attachmentList;
}

@end

@implementation IMBSMSAttachmentEntity
@synthesize msgID = _msgID;
@synthesize rowID = _rowID;
@synthesize attGUID = _attGUID;
@synthesize createDate = _createDate;
@synthesize createDateText = _createDateText;
@synthesize startDate = _startDate;
@synthesize fileName = _fileName;
@synthesize utiName = _utiName;
@synthesize mimeType = _mimeType;
@synthesize transferState = _transferState;
@synthesize isOutgoing = _isOutgoing;
@synthesize attachDetailList = _attachDetailList;
@synthesize transferName = _transferName;
@synthesize totalBytes = _totalBytes;
@synthesize parentPathArray = _parentPathArray;
@synthesize attachLoaction = _attachLoaction;
- (id)init {
    self = [super init];
    if (self) {
        _msgID = 0;
        _rowID = 0;
        _attGUID = @"";
        _createDate = 0;
        _createDateText = @"";
        _startDate = 0;
        _fileName = @"";
        _utiName = @"";
        _mimeType = @"";
        _transferState = 0;
        _isOutgoing = NO;
        _attachDetailList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableArray *)parentPathArray
{
    if (_parentPathArray == nil) {
        _parentPathArray = [[NSMutableArray alloc] init];
    }
    return _parentPathArray;
}

- (void)dealloc {
    if (_attachDetailList != nil) {
        [_attachDetailList release];
        _attachDetailList = nil;
    }
    [_parentPathArray release],_parentPathArray = nil;
    [_transferName release],_transferName = nil;
    [_fileName release],_fileName = nil;
    [_utiName release],_utiName = nil;
    [_mimeType release],_mimeType = nil;
    [_attachLoaction release],_attachLoaction = nil;
    [super dealloc];
}

- (int)attachmentID {
    return _rowID;
}

- (int64_t)totalFileSize {
    int totalFileSize = 0;
    if (_attachDetailList != nil && [_attachDetailList count] > 0) {
        for (IMBAttachDetailEntity *adm in _attachDetailList) {
            totalFileSize += adm.fileSize;
        }
    }
    return totalFileSize;
}

- (NSString *)filePath {
    NSString *fp = @"";
    if (_attachDetailList != nil && [_attachDetailList count] > 0) {
        fp = [[_attachDetailList objectAtIndex:0] filePath];
    }
    return fp;
}

- (NSString *)perviewFilePath {
    NSString *fp = @"";
    if (_attachDetailList != nil && [_attachDetailList count] > 0) {
        fp = [[_attachDetailList objectAtIndex:1] filePath];
    }
    return fp;
}

@end

@implementation IMBAttachDetailEntity
@synthesize isPerviewImage = _isPerviewImage;
@synthesize fileName = _fileName;
@synthesize fileSize = _fileSize;
@synthesize backUpFilePath = _backUpFilePath;
@synthesize backFileName = _backFileName;
@synthesize mbFileRecord = _mbFileRecord;
@synthesize thumbImage = _thumbImage;
@synthesize rowID = _rowID;
@synthesize isLoad = _isLoad;
@synthesize attachType = _attachType;
@synthesize mimeType = _mimeType;

#define THUMBNAIL_HEIGHT 180.0
//luolei add 2016 12 12
static NSImage *ATThumbnailImageFromImage(NSImage *image) {
    NSSize imageSize = [image size];
    CGFloat imageAspectRatio = imageSize.width / imageSize.height;
    // Create a thumbnail image from this image (this part of the slow operation)
    NSSize thumbnailSize = NSMakeSize(THUMBNAIL_HEIGHT * imageAspectRatio, THUMBNAIL_HEIGHT);
    NSImage *thumbnailImage = [[NSImage alloc] initWithSize:thumbnailSize];
    [thumbnailImage lockFocus];
    [image drawInRect:NSMakeRect(0, 0, thumbnailSize.width, thumbnailSize.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    [thumbnailImage unlockFocus];
    return [thumbnailImage autorelease];
}

- (void)setBackUpFilePath:(NSString *)backUpFilePath
{
    if (_backUpFilePath != backUpFilePath) {
        [_backUpFilePath release];
        _backUpFilePath = [backUpFilePath retain];
        @autoreleasepool {
             NSImage *image = [[NSImage alloc] initWithContentsOfFile:_backUpFilePath];
            if (image != nil) {
                
                NSImage *thumbnailImage = ATThumbnailImageFromImage(image);
                @synchronized (self){
                    _thumbImage = [thumbnailImage retain];
                }
            }else{
                @synchronized (self) {
                    if ([_mimeType rangeOfString:@"location"].location != NSNotFound) {//位置
                         _thumbImage = [[NSImage imageNamed:@"default_listlocation"] retain];
                    }else if ([_mimeType rangeOfString:@"vcard"].location != NSNotFound) {//联系人
                        _thumbImage = [[NSImage imageNamed:@"default_listcontact"] retain];
                    }else if ([_mimeType rangeOfString:@"audio"].location != NSNotFound || [_mimeType rangeOfString:@"amr"].location != NSNotFound) {//语音
                        _thumbImage = [[NSImage imageNamed:@"message_audio"] retain];
                    }else if ([_mimeType rangeOfString:@"video"].location != NSNotFound || [_mimeType rangeOfString:@"quicktime"].location != NSNotFound) {//视频
                        _thumbImage = [[NSImage imageNamed:@"default_listvideo"] retain];
                    }else {
                        _thumbImage = [[[NSWorkspace sharedWorkspace] iconForFile:backUpFilePath] retain];
                    }
                }
            }
            [image release];
        }
    }
}


- (id)init {
    self = [super init];
    if (self) {
        _isPerviewImage = NO;
        _fileName = [@"" retain];
        _fileSize = 0;
        _backUpFilePath = [@"" retain];
        _thumbImage = nil;
        _backFileName = [@"" retain];
        _mbFileRecord = nil;
        _rowID = 0;
        _attachType = -1;
    }
    return self;
}

- (void)dealloc {
    if (_thumbImage != nil) {
        [_thumbImage release];
        _thumbImage = nil;
    }
    [_fileName release],_fileName = nil;
    [_backUpFilePath release],_backUpFilePath = nil;
    [_backFileName release],_backFileName = nil;
    [super dealloc];
}

@end
