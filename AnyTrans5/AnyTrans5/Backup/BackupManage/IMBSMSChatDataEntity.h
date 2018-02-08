//
//  IMBSMSChatDataEntity.h
//  DataRecovery
//
//  Created by iMobie on 4/15/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBBaseEntity.h"
#import "IMBMBDBParse.h"

@interface IMBSMSChatDataEntity : IMBBaseEntity {
@private
    int _rowId;
    NSString *_chatGuid;
    NSString *_handleId;
    NSString *_handleService;
    NSString *_contactName;                 // 匹配联系人的名字
    int _handle_id;
    NSString *_lastMsgText;                 //最后一条消息
    int64_t _msgDate;
    NSString *_lastMsgTime;                 //最后一条消息的时间;
    //IOS 5.0
    int _groupID;
    NSString *_chatIdentifier;              // 对应的是ContactName
    
    NSMutableArray *_msgModelList;          // Message Model Set,装的是IMBMessageDataEntity对象
    
    long _messageCount;
    long _messageSize;
    long _attachmentCount;
    long _attachmentSize;
    
    
    int _style;
    int _state;
    NSString *_account_id;
    NSData *_properties;
    NSString *_service_name;
    NSString *_room_name;
    NSString *_account_login;
    int _is_archived;
    NSString *_last_addressed_handle;
    NSString *_display_name;
    //handle
    NSString *_hand_country;
    NSString *_hand_service;
    NSString *_hand_uncanonicalized;
    
   //iMessage
    BOOL _isExistTwo;
    int _iMRowId;
    NSString *_iMChatGuid;
    NSString *_iMHandleId;
    NSString *_iMHandleService;
    int _iMHandle_id;
    NSString *_iMAccount_login;
    NSImage *_headImage;
    
    NSString *_timeStr;
    //ios5
    NSInteger _groupType;
    NSInteger _groupnewestMessage;
    NSInteger _groupHash;
    NSMutableArray  *_addressArray;
    NSMutableArray *_groupROWIDArray;
    
    NSString *_lastMsgTimeWithSecond;   //最后一条消息的时间;包含时分秒
    int _sessionType;     // imessage  0 为单聊   1为群聊
}
@property (nonatomic,assign)NSInteger groupType;
@property (nonatomic,assign)NSInteger groupnewestMessage;
@property (nonatomic,assign)NSInteger groupHash;
@property (nonatomic,retain)NSMutableArray *addressArray;
@property (nonatomic,retain)NSMutableArray *groupROWIDArray;

@property (nonatomic, retain) NSString *hand_country;
@property (nonatomic, retain) NSString *hand_service;
@property (nonatomic, retain) NSString *hand_uncanonicalized;
@property (nonatomic, assign) int sessionType;
@property (nonatomic, assign) int style;
@property (nonatomic, assign) int state;
@property (nonatomic, retain) NSString *account_id;
@property (nonatomic, retain) NSData *properties;
@property (nonatomic, retain) NSString *service_name;
@property (nonatomic, retain) NSString *room_name;
@property (nonatomic, retain) NSString *account_login;
@property (nonatomic, assign) int is_archived;
@property (nonatomic, retain) NSString *last_addressed_handle;
@property (nonatomic, retain) NSString *display_name;
@property (nonatomic, assign) int64_t msgDate;

@property (nonatomic, readwrite) int rowId;
@property (nonatomic, readwrite) int groupID;
@property (nonatomic, readwrite, retain) NSString *chatGuid;
@property (nonatomic, readwrite, retain) NSString *handleId;
@property (nonatomic, readwrite, retain) NSString *handleService;
@property (nonatomic, readwrite) int handle_id;
@property (nonatomic, readwrite, retain) NSString *chatIdentifier;
@property (nonatomic, readwrite, retain) NSMutableArray *msgModelList;

@property (nonatomic, getter = contactRowID, readonly) int contactRowID;
@property (nonatomic, readwrite, retain) NSString *contactName;
//@property (nonatomic, getter = contactName, readonly) NSString *contactName;
@property (nonatomic, readwrite) long messageCount;
@property (nonatomic, readwrite) long messageSize;
@property (nonatomic, readwrite) long attachmentCount;
@property (nonatomic, readwrite) long attachmentSize;
//@property (nonatomic, readwrite) long cleanMessageCount;
//@property (nonatomic, readwrite) long cleanMessageSize;
@property (nonatomic, getter = messaline, readonly) NSMutableArray *messaline;
@property (nonatomic, readwrite, retain) NSString *lastMsgText;
@property (nonatomic, readwrite, retain) NSString *lastMsgTime;

@property (nonatomic, retain) NSString *timeStr;

@property (nonatomic, readwrite) BOOL isExistTwo;
@property (nonatomic, readwrite) int iMRowId;
@property (nonatomic, readwrite, retain) NSString *iMChatGuid;
@property (nonatomic, readwrite, retain) NSString *iMHandleId;
@property (nonatomic, readwrite, retain) NSString *iMHandleService;
@property (nonatomic, readwrite) int iMHandle_id;
@property (nonatomic, readwrite, retain) NSString *iMAccount_login;
@property (nonatomic, readwrite, retain)  NSImage *headImage;
@property (nonatomic, readwrite, retain) NSString *lastMsgTimeWithSecond;
- (int)contactRowID;

//- (NSString *)contactName;

- (NSMutableArray *)messaline;

@end
#import "IMBCheckBtn.h"

typedef struct MessageMergeStruct
{
    int imnewchatRowID;
    int imhandRowID;
    int newchatRowID;
    int handRowID;
}MessageMergeStruct;
@interface IMBMessageDataEntity : IMBBaseEntity {
@private
    int _rowId;                 // Message Table Row ID
    NSString *_msgText;         // 消息内容
    int _handleId;
    NSString *_subject;         // 主题
    int64_t _msgDate;           // 消息时间
    NSString *_msgShortDateStr;
    int64_t _msgReadDate;       // 消息Read时间
    NSString *_msgDateText;     // 消息时间 - 字符格式
    NSString *_msgReadDateText; // 消息Read时间 - 字符格式
    BOOL _isTextMedia;          // 是否文本媒体
    BOOL _isDelivered;          // 是否发送
    BOOL _isFinished;           // 是否完成
    BOOL _isAttachments;        // 是否有附件
    BOOL _isRead;               // 是否已经阅读
    BOOL _isSent;               // 是否已经发送
    
    // IOS 5.0
    //#pragma IOS 5.0的属性
    NSMutableDictionary *_attachmentInfoDic;
    int64_t _madridDateRead;
    int64_t _madridDateDelivered;
    int _flags;
    NSString *_madridHandle;
    
    NSMutableArray *_attachmentList;   // 附件列表,存储的是IMBSMSAttachmentEntity对象
    
    long _attachmentCount;
    long _attachmentSize;
    long _messageSize;
    
    
    NSString *_guid;
    int _replace;
    NSString *_service_center;
    NSString *_country;
    NSData *_attributedBody;
    int _version;
    int _type;
    NSString *_service;
    NSString *_account;
    NSString *_account_guid;
    int _error;
    int64_t _date_delivered;
    int _is_emote;
    int _is_from_me;
    int _is_empty;
    int _is_delayed;
    int _is_auto_reply;
    int _is_prepared;
    int _is_system_message;
    int _has_dd_results;
    int _is_service_message;
    int _is_forward;
    int _was_downgraded;
    int _is_archive;
    NSString *_cache_roomnames;
    int _was_data_detected;
    int _was_deduplicated;
    int _is_audio_message;
    id _chat;
    MessageMergeStruct *_mergeStruct;
    NSString *_contactName;     // 每条消息所对应联系人
    NSString *_sessionType;     // imessage  0 为单聊   1为群聊
}
@property (nonatomic,assign)id chat;
@property (nonatomic,assign)MessageMergeStruct *mergeStruct;
@property (nonatomic, readwrite) int is_audio_message;
@property (nonatomic, readwrite, retain) NSString *guid;
@property (nonatomic, readwrite) int replace;
@property (nonatomic, readwrite, retain) NSString *service_center;
@property (nonatomic, readwrite, retain)  NSString *country;
@property (nonatomic, readwrite, retain)  NSData *attributedBody;;
@property (nonatomic, readwrite) int version;
@property (nonatomic, readwrite) int type;
@property (nonatomic, readwrite, retain)  NSString *service;
@property (nonatomic, readwrite, retain)  NSString *account;
@property (nonatomic, readwrite, retain)  NSString *account_guid;
@property (nonatomic, readwrite) int error;
@property (nonatomic, readwrite) int64_t date_delivered;
@property (nonatomic, readwrite) int is_emote;
@property (nonatomic, readwrite) int is_from_me;
@property (nonatomic, readwrite) int is_empty;
@property (nonatomic, readwrite) int is_delayed;
@property (nonatomic, retain) NSString *sessionType;
@property (nonatomic, readwrite) int is_auto_reply;
@property (nonatomic, readwrite) int is_prepared;
@property (nonatomic, readwrite) int is_system_message;
@property (nonatomic, readwrite) int has_dd_results;
@property (nonatomic, readwrite) int is_service_message;
@property (nonatomic, readwrite) int is_forward;
@property (nonatomic, readwrite) int was_downgraded;
@property (nonatomic, readwrite) int is_archive;
@property (nonatomic, readwrite, retain) NSString *cache_roomnames;
@property (nonatomic, readwrite) int was_data_detected;
@property (nonatomic, readwrite) int was_deduplicated;
@property (nonatomic, readwrite, retain) NSString *contactName;

@property (nonatomic, readwrite) int rowId;
@property (nonatomic, readwrite, retain) NSString *msgText;
@property (nonatomic, readwrite) int handleId;
@property (nonatomic, readwrite, retain) NSString *subject;
@property (nonatomic, readwrite) int64_t msgDate;
@property (nonatomic, readwrite, retain) NSString *msgShortDateStr;
@property (nonatomic, readwrite) int64_t msgReadDate;
@property (nonatomic, readwrite, retain) NSString *msgDateText;
@property (nonatomic, readwrite, retain) NSString *msgReadDateText;
@property (nonatomic, readwrite) BOOL isTextMedia;
@property (nonatomic, readwrite) BOOL isDelivered;
@property (nonatomic, readwrite) BOOL isFinished;
@property (nonatomic, readwrite) BOOL isAttachments;
@property (nonatomic, readwrite) BOOL isRead;
@property (nonatomic, readwrite) BOOL isSent;
@property (nonatomic, readwrite, retain) NSMutableDictionary *attachmentInfoDic;
@property (nonatomic, readwrite) int64_t madridDateRead;
@property (nonatomic, readwrite) int64_t madridDateDelivered;
@property (nonatomic, readwrite) int flags;
@property (nonatomic, readwrite, retain) NSMutableArray *attachmentList;

@property (nonatomic, getter = msgRowID, readonly) int msgRowID;
@property (nonatomic, getter = messageText, readonly) NSString *messageText;
@property (nonatomic, getter = messageDate, readonly) int64_t messageDate;
@property (nonatomic, getter = messageReadDate, readonly) int64_t messageReadDate;
@property (nonatomic, readwrite) long attachmentCount;
@property (nonatomic, readwrite) long attachmentSize;
@property (nonatomic, readwrite) long messageSize;
@property (nonatomic, getter = attachmentData, readonly) NSMutableArray *attachmentData;

@property (nonatomic, readwrite, retain) NSString *madridHandle;

- (int)msgRowID;

- (NSString *)messageText;

- (int64_t)messageDate;

- (int64_t)messageReadDate;

- (NSMutableArray *)attachmentData;

@end

@interface IMBSMSAttachmentEntity : IMBBaseEntity {
@private
    int _msgID;
    int _rowID;
    NSString *_attGUID;
    int64_t _createDate;
    NSString *_createDateText;
    int64_t _startDate;
    NSString *_fileName;
    NSString *_utiName;
    NSString *_mimeType;
    NSString *_transferName;
    int _transferState;
    BOOL _isOutgoing;
    //保存的是IMBAttachDetailEntity对象
    NSMutableArray *_attachDetailList;
    
    
    //新添加
    long long _totalBytes;
    NSMutableArray *_parentPathArray;//附件的父路径
    NSString *_attachLoaction;
}

@property (nonatomic, readwrite) int msgID;
@property (nonatomic, readwrite) int rowID;
@property (nonatomic, readwrite, retain) NSString *attGUID;
@property (nonatomic, readwrite) int64_t createDate;
@property (nonatomic, readwrite, retain) NSString *createDateText;
@property (nonatomic, readwrite) int64_t startDate;
@property (nonatomic, readwrite, retain) NSString *fileName;
@property (nonatomic, readwrite, retain) NSString *utiName;
@property (nonatomic, readwrite, retain) NSString *mimeType;
@property (nonatomic, readwrite, retain) NSString *transferName;
@property (nonatomic, readwrite, retain) NSString *attachLoaction;
@property (nonatomic, readwrite) int transferState;
@property (nonatomic, readwrite) BOOL isOutgoing;
@property (nonatomic, readwrite, retain) NSMutableArray *attachDetailList;
@property (nonatomic, readwrite, retain) NSMutableArray *parentPathArray;
@property (nonatomic, getter = attachmentID, readonly) int attachmentID;
@property (nonatomic, getter = totalFileSize, readonly) int64_t totalFileSize;
@property (nonatomic, getter = filePath, readonly) NSString *filePath;
@property (nonatomic, getter = perviewFilePath, readonly) NSString *perviewFilePath;
@property (nonatomic,assign)long long totalBytes;

- (int)attachmentID;

- (int64_t)totalFileSize;

- (NSString *)filePath;

- (NSString *)perviewFilePath;

@end

@interface IMBAttachDetailEntity : IMBBaseEntity {
@private
    BOOL _isPerviewImage;
    NSString *_fileName;
    int64_t _fileSize;
    NSString *_backUpFilePath;  //PerviewFilePath
    NSString *_backFileName;
    IMBMBFileRecord *_mbFileRecord;
    NSImage *_thumbImage;
    int _rowID;
    BOOL _isLoad;
    int _attachType;
    NSString *_mimeType;
}
@property (nonatomic, assign) BOOL isLoad;
@property (nonatomic, readwrite) BOOL isPerviewImage;
@property (nonatomic, readwrite, retain) NSString *fileName;
@property (nonatomic, readwrite) int64_t fileSize;
@property (nonatomic, readwrite, retain) NSString *backUpFilePath;
@property (nonatomic,retain) NSImage *thumbImage;
@property (nonatomic, readwrite, retain) NSString *backFileName;
@property (nonatomic, readwrite, retain) IMBMBFileRecord *mbFileRecord;
@property (nonatomic, readwrite) int rowID;
@property (nonatomic, readwrite) int attachType;
@property (nonatomic, readwrite, retain) NSString *mimeType;
@end

