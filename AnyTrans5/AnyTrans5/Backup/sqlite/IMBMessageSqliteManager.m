//
//  IMBMessageSqliteManager.m
//  AnyTrans
//
//  Created by long on 16-7-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBMessageSqliteManager.h"
#import "IMBBackupManager.h"
#import "NSString+Category.h"
#import "IMBSMSChatDataEntity.h"
#import "StringHelper.h"
#import "IMBCallHistoryDataEntity.h"
#import "DateHelper.h"
@implementation IMBMessageSqliteManager
- (id)initWithAMDevice:(AMDevice *)dev backupfilePath:(NSString *)backupfilePath  withDBType:(NSString *)type WithisEncrypted:(BOOL)isEncrypted withBackUpDecrypt:(IMBBackupDecrypt*)decypt{
    if ([super initWithAMDevice:dev backupfilePath:backupfilePath withDBType:type WithisEncrypted:isEncrypted withBackUpDecrypt:decypt]) {
        IMBBackupManager *manager = [IMBBackupManager shareInstance];
         _backUpPath = [backupfilePath retain];
        manager.iosVersion = type;
        if (isEncrypted) {
            [decypt decryptSingleFile:@"HomeDomain" withFilePath:@"Library/SMS/sms.db"];
            [decypt decryptSingleFile:@"MediaDomain" withFilePath:@"Library/SMS/Attachments"];
            manager.backUpPath = decypt.outputPath;
            if (_backUpPath != nil) {
                [_backUpPath release];
                _backUpPath = nil;
            }
            _backUpPath = [decypt.outputPath retain];
        }
        NSString *sqliteddPath = [manager copysqliteToApptempWithsqliteName:@"sms.db" backupfilePath:_backUpPath];
        if (sqliteddPath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
        }
        
        _contactManager = [[IMBContactBaseInfoManager alloc]initWithManifestManager:backupfilePath WithisEncrypted:isEncrypted withBackUpDecrypt:decypt];
    }
    return self;
}

- (id)initWithBackupfilePath:(NSString *)backupfilePath recordArray:(NSMutableArray *)recordArray{
    if (self = [super init]) {
        fm = [NSFileManager defaultManager];
        _logManger = [IMBLogManager singleton];
        _iOSVersion = [[IMBSqliteManager getBackupFileFloatVersion:backupfilePath] retain];
        _dataAry = [[NSMutableArray alloc] init];
        _backUpPath = [backupfilePath retain];
        NSString *sqliteddPath = [self copysqliteToApptempWithsqliteName:@"sms.db" backupfilePath:backupfilePath recordArray:recordArray];
        if (sqliteddPath != nil) {
            _databaseConnection = [[FMDatabase alloc] initWithPath:sqliteddPath];
        }
        _contactManager = [[IMBContactBaseInfoManager alloc]initWithManifestManager:backupfilePath WithisEncrypted:NO withBackUpDecrypt:nil];
    }
    return self;
}


- (id)initWithiCloudBackup:(IMBiCloudBackup*)iCloudBackup withType:(NSString *)type{
    if ([super initWithiCloudBackup:iCloudBackup withType:type]) {
        if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"9"]) {
          NSString *dbNPath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:@"HomeDomain/Library/SMS/sms.db"];
            if ([fm fileExistsAtPath:dbNPath]) {
                _databaseConnection = [[FMDatabase alloc] initWithPath:dbNPath];
            }
        }else{
            //遍历需要的文件，然后拷贝到指定的目录下
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.domain == %@ and self.path == %@", @"HomeDomain", @"Library/SMS/sms.db"];
            NSArray *tmpArray = [iCloudBackup.fileInfoArray filteredArrayUsingPredicate:pre];
            IMBiCloudFileInfo *smsFile = nil;
            if (tmpArray != nil && tmpArray.count > 0) {
                smsFile = [tmpArray objectAtIndex:0];
            }
            if (smsFile != nil) {
                NSString *sourcefilePath = nil;
                if ([iCloudBackup.iOSVersion isVersionMajorEqual:@"10"]) {
                    NSString *fd = @"";
                    if (smsFile.fileName.length > 2) {
                        fd = [smsFile.fileName substringWithRange:NSMakeRange(0, 2)];
                    }
                    sourcefilePath = [[_backUpPath stringByAppendingPathComponent:fd] stringByAppendingPathComponent:smsFile.fileName];
                }else{
                    sourcefilePath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:smsFile.fileName];
                }
//                NSString *dbNPath = [iCloudBackup.downloadFolderPath stringByAppendingPathComponent:smsFile.fileName];
                if (sourcefilePath != nil) {
                    _databaseConnection = [[FMDatabase alloc] initWithPath:sourcefilePath];
                }
            }

        }
            _contactManager = [[IMBContactBaseInfoManager alloc] initWithiCloudBackup:iCloudBackup];
    }
    return self;
}


#pragma mark - 查询数据库方法
- (void)querySqliteDBContent {
    if ([_iOSVersion isVersionMajorEqual:@"6"]) {
        @try {
            [self querySMSTableContentIos6];
        } @catch (NSException *exception) {
            [_logManger writeInfoLog:[NSString stringWithFormat:@"query SMS exception:%@ %@",exception.name,exception.reason]];
        } @finally {
            
        }
    }else {
        [self querySMSTableContentIos5];
    }
}

#pragma mark ---- ios6以上查询
- (void)querySMSTableContentIos6 {
    [_logManger writeInfoLog:@"query SMSTable Ios6 Content Begin"];
    if ([self openDataBase]) {
        NSMutableArray *SMSMessageArray = [[NSMutableArray alloc] init];
        [self queryChatTableIos6:SMSMessageArray];
        if (SMSMessageArray != nil && [SMSMessageArray count] > 0) {
            long _currentChatIndex = 0;
            for (IMBSMSChatDataEntity *item in SMSMessageArray) {
                @autoreleasepool {
                    _currentChatIndex += 1;
                    long attachmentCount = 0;
                    long attachmentSize = 0;
                    long textSize = 0;
                    NSMutableArray *chatMsgList = [[self queryChatMessageTableIos6:item textSize:&textSize attachmentCount:&attachmentCount attachmentSize:&attachmentSize] retain];
                    if (chatMsgList != nil && [chatMsgList count] > 0) {
                        [item setMsgModelList:chatMsgList];
                        [item setMessageCount:chatMsgList.count];
                        item.selectedCount = chatMsgList.count;
                        [item setMessageSize:(textSize + attachmentSize)];      // 消息大小等于文字大小加上附件的大小
                        //去msg最后的消息
                        IMBMessageDataEntity *msgEntity = [chatMsgList lastObject];
                        item.lastMsgText = msgEntity.msgText;
                        
                        [chatMsgList release];
                        chatMsgList = nil;
                    } else {
                        [item setMessageCount:0];
                        [item setMessageSize:0];
                        item.selectedCount = 0;
                    }
                    [item setAttachmentCount:attachmentCount];
                    [item setAttachmentSize:attachmentSize];
                    [_dataAry addObject:item];
                }
            }
        }
        [self closeDataBase];
        [SMSMessageArray release];
        SMSMessageArray = nil;
    }
    //排序
    [self sortResultArray];
    [_logManger writeInfoLog:@"query SMSTable Ios6 Content End"];
}

- (void)sortResultArray {
    if (_dataAry.count > 0) {
        NSMutableArray *resArray = [NSMutableArray arrayWithArray:_dataAry];
        for (IMBSMSChatDataEntity *chatEntity in resArray) {
            @autoreleasepool {
                if (chatEntity.msgModelList.count > 0) {
                    NSArray *sortedArray = nil;
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
                    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
                    sortedArray = [chatEntity.msgModelList sortedArrayUsingComparator:^(id obj1, id obj2){
                        IMBMessageDataEntity *msg1 = (IMBMessageDataEntity*)obj1;
                        IMBMessageDataEntity *msg2 = (IMBMessageDataEntity*)obj2;
                        if (msg1.msgDate < msg2.msgDate)
                            return NSOrderedAscending;
                        else if (msg1.msgDate > msg2.msgDate)
                            return NSOrderedDescending;
                        else
                            return NSOrderedSame;
                        //                        NSDate *date1 = [dateFormatter dateFromString:msg1.msgDateText];
                        //                        NSDate *date2 = [dateFormatter dateFromString:msg2.msgDateText];
                        //                        return [date1 compare:date2];
                    }];
                    [chatEntity.msgModelList removeAllObjects];
                    [chatEntity.msgModelList addObjectsFromArray:sortedArray];
                    [dateFormatter release];
                    dateFormatter = nil;
                    IMBMessageDataEntity *entity = [chatEntity.msgModelList objectAtIndex:chatEntity.msgModelList.count -1];
                    chatEntity.msgDate = entity.msgDate;
                    if (chatEntity.msgDate < 0) {
                        chatEntity.lastMsgTime = [DateHelper dateFrom1970ToString:[[NSDate date] timeIntervalSince1970] withMode:3];
                    }else {
                        if (chatEntity.msgDate > [[NSDate date] timeIntervalSince1970]) {
                            chatEntity.lastMsgTime = [DateHelper dateFrom1904ToString:(long)chatEntity.msgDate withMode:1];
                        }else {
                            if (chatEntity.msgDate > [[NSDate date] timeIntervalSinceDate:[DateHelper dateFromString2001]]) {
                                chatEntity.lastMsgTime = [DateHelper dateFrom1970ToString:(long)chatEntity.msgDate withMode:1];
                            }else {
                                chatEntity.lastMsgTime = [DateHelper dateFrom2001ToString:(long)chatEntity.msgDate withMode:1];
                            }
                        }
                    }
                    if (chatEntity.msgDate < 0) {
                        chatEntity.timeStr = [DateHelper dateFrom1970ToString:[[NSDate date] timeIntervalSince1970] withMode:3];
                    }else {
                        if (chatEntity.msgDate > [[NSDate date] timeIntervalSince1970]) {
                            chatEntity.timeStr = [DateHelper dateFrom1904ToString:(long)chatEntity.msgDate withMode:3];
                        }else {
                            if (chatEntity.msgDate > [[NSDate date] timeIntervalSinceDate:[DateHelper dateFromString2001]]) {
                                chatEntity.timeStr = [DateHelper dateFrom1970ToString:(long)chatEntity.msgDate withMode:6];
                            }else {
                                chatEntity.timeStr = [DateHelper dateFrom2001ToString:(long)chatEntity.msgDate withMode:6];
                            }
                        }
                    }
                    
                    if (chatEntity.isDeleted) {
                        //去msg最后的消息
                        IMBMessageDataEntity *msgEntity = [chatEntity.msgModelList lastObject];
                        chatEntity.lastMsgText = msgEntity.msgText;
                    }
                    
                }
                if (chatEntity.msgDate < 0) {
                    chatEntity.lastMsgTimeWithSecond = chatEntity.lastMsgTime;
                }else {
                    if (chatEntity.msgDate > [[NSDate date] timeIntervalSince1970]) {
                        chatEntity.lastMsgTimeWithSecond =  chatEntity.timeStr;
                    }else {
                        if (![TempHelper stringIsNilOrEmpty:chatEntity.lastMsgTime] && ![TempHelper stringIsNilOrEmpty:chatEntity.timeStr]) {
                            chatEntity.lastMsgTimeWithSecond = [chatEntity.lastMsgTime stringByAppendingString:chatEntity.timeStr];
                        }else if (![TempHelper stringIsNilOrEmpty:chatEntity.lastMsgTime] && [TempHelper stringIsNilOrEmpty:chatEntity.timeStr]) {
                            chatEntity.lastMsgTimeWithSecond = chatEntity.lastMsgTime;
                        }else if ([TempHelper stringIsNilOrEmpty:chatEntity.lastMsgTime] && ![TempHelper stringIsNilOrEmpty:chatEntity.timeStr]) {
                            chatEntity.lastMsgTimeWithSecond = chatEntity.timeStr;
                        }else {
                            chatEntity.lastMsgTimeWithSecond = @"";
                        }
                    }
                }
                if (chatEntity.isDeleted) {
                    //去msg最后的消息
                    IMBMessageDataEntity *msgEntity = [chatEntity.msgModelList lastObject];
                    chatEntity.lastMsgText = msgEntity.msgText;
                }
            }
        }
    }
}

- (void)queryChatTableIos6:(NSMutableArray *)SMSMessageArray {

    [_logManger writeInfoLog:@"queryChatTable: Begin"];
    NSMutableString *selectCmd = [[NSMutableString alloc] init];
    [selectCmd appendString:@"select a.ROWID,a.guid,a.style,b.id,b.service,a.account_login,a.chat_identifier,c.handle_id from chat as a,handle as b,chat_handle_join as c where a.ROWID = c.chat_id And b.ROWID = c.handle_id;"];
    FMResultSet *rs = nil;

    rs = [_databaseConnection executeQuery:selectCmd];
    
    while ([rs next]) {
        @autoreleasepool {
            IMBSMSChatDataEntity *SMSMessageItem = nil;
            NSString *chatidentifier = nil;
            if (![rs columnIsNull:@"chat_identifier"]) {
                chatidentifier = [rs stringForColumn:@"chat_identifier"];
            } else {
                chatidentifier = @"";
            }
            BOOL isExist = NO;
            if (SMSMessageArray.count > 0 && ![StringHelper stringIsNilOrEmpty:chatidentifier]) {
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"chatIdentifier == %@", chatidentifier];
                NSArray *filteredArray = [SMSMessageArray filteredArrayUsingPredicate:pred];
                if (filteredArray != nil && filteredArray.count > 0) {
                    SMSMessageItem = [filteredArray objectAtIndex:0];
                    isExist = YES;
                }
            }
            if (SMSMessageItem == nil) {
                isExist = NO;
                SMSMessageItem = [[IMBSMSChatDataEntity alloc] init];
            }
            int rowid = [rs intForColumn:@"ROWID"];
            NSString *chatguid = nil;
            if (![rs columnIsNull:@"guid"]) {
                chatguid = [rs stringForColumn:@"guid"];
            } else {
                chatguid = @"";
            }
            NSString *idstr = nil;
            if (![rs columnIsNull:@"id"]) {
                idstr = [rs stringForColumn:@"id"];
                if ([chatidentifier hasPrefix:@"chat"]&&![SMSMessageItem.addressArray containsObject:idstr]) {
                    [SMSMessageItem.addressArray addObject:idstr];
                }
            } else {
                idstr = @"";
            }
            int handleid = 0;
            if (![rs columnIsNull:@"handle_id"]) {
                handleid = [rs intForColumn:@"handle_id"];
            } else {
                handleid = 0;
            }
            NSString *servicename = nil;
            if (![rs columnIsNull:@"service"]) {
                servicename = [rs stringForColumn:@"service"];
            } else {
                servicename = @"";
            }
            int style = 0;
            if (![rs columnIsNull:@"style"]) {
                style = [rs intForColumn:@"style"];
            }
            [SMSMessageItem setSessionType:style];
            NSString *account_login = nil;
            if (![rs columnIsNull:@"account_login"]) {
                account_login = [rs stringForColumn:@"account_login"];
            }else{
                account_login = @"";
            }
            if (isExist) {
                [SMSMessageItem setIMRowId:rowid];
                [SMSMessageItem setIMAccount_login:account_login];
                [SMSMessageItem setIMChatGuid:chatguid];
                [SMSMessageItem setIMHandle_id:handleid];
                [SMSMessageItem setIMHandleId:idstr];
                [SMSMessageItem setIMHandleService:servicename];
                [SMSMessageItem setIsExistTwo:YES];
            }else {
                [SMSMessageItem setCheckState:UnChecked];
                [SMSMessageItem setRowId:rowid];
                [SMSMessageItem setAccount_login:account_login];
                [SMSMessageItem setChatGuid:chatguid];
                [SMSMessageItem setHandleId:idstr];
                [SMSMessageItem setHandle_id:handleid];
                [SMSMessageItem setHandleService:servicename];
                [SMSMessageItem setChatIdentifier:chatidentifier];
                
                IMBContactInfoModel *contactInfo = [_contactManager getContactinfoByIdentifier:chatidentifier];
                if (contactInfo != nil) {
                    [SMSMessageItem setContactName:contactInfo.displayName];
                    [SMSMessageItem setHeadImage:contactInfo.image];
                }else {
                    if (![StringHelper stringIsNilOrEmpty:chatidentifier]) {
                        [SMSMessageItem setContactName:chatidentifier];
                    }else {
                        [SMSMessageItem setContactName:CustomLocalizedString(@"Common_id_10", nil)];
                    }
                }
                [SMSMessageItem setSortStr:[StringHelper getStringFirstWord:SMSMessageItem.contactName]];
                [SMSMessageArray addObject:SMSMessageItem];
                [SMSMessageItem release];
                SMSMessageItem = nil;
            }
        }
    }
    [rs close];
    for (IMBSMSChatDataEntity *chat in SMSMessageArray) {
        @autoreleasepool {
            if ([chat.chatIdentifier hasPrefix:@"chat"]) {
                chat.contactName = @"";
                for (NSString *address in chat.addressArray) {
                    IMBContactInfoModel *contactInfo = [_contactManager getContactinfoByIdentifier:address];
                    if (contactInfo) {
                        if ([chat.contactName isEqualToString:@""]) {
                            chat.contactName = [chat.contactName stringByAppendingFormat:@"%@",contactInfo.displayName];
                        }else{
                            chat.contactName = [chat.contactName stringByAppendingFormat:@"、%@",contactInfo.displayName];
                        }
                        
                    }else{
                        if ([chat.contactName isEqualToString:@""]) {
                            chat.contactName = [chat.contactName stringByAppendingFormat:@"%@",address];
                        }else{
                            chat.contactName = [chat.contactName stringByAppendingFormat:@"、%@",address];
                        }
                    }
                }
            }
        }
    }
    [selectCmd release];
    [_logManger writeInfoLog:@"queryChatTable: End"];
}

- (NSMutableArray *)queryChatMessageTableIos6:(IMBSMSChatDataEntity *)chat textSize:(long *)textSize attachmentCount:(long *)attachmentCount attachmentSize:(long *)attachmentSize {
    NSMutableArray *messageArray = [[[NSMutableArray alloc] init] autorelease];
    NSString *selectCmd = nil;
    NSDictionary *param = nil;
    if (chat.isExistTwo) {
        selectCmd = @"select  ROWID,text,handle_id,subject,type,date,service,date_read,is_delivered,is_finished,cache_has_attachments,is_read,is_sent,(select id from handle where rowid = handle_id) as contact_id from Message where ROWID in (select message_id from chat_message_join where chat_id=:chatid or chat_id=:imchatid) order by date;";
        param = [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSNumber numberWithInt:chat.rowId], @"chatid",[NSNumber numberWithInt:chat.iMRowId], @"imchatid",
                 nil];
    }else {
        selectCmd = @"select  ROWID,text,handle_id,subject,type,date,service,date_read,is_delivered,is_finished,cache_has_attachments,is_read,is_sent,(select id from handle where rowid = handle_id) as contact_id from Message where ROWID in (select message_id from chat_message_join where chat_id=:chatid) order by date;";
        param = [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSNumber numberWithInt:chat.rowId], @"chatid",
                 nil];
    }
    FMResultSet *rs = nil;

    rs = [_databaseConnection executeQuery:selectCmd withParameterDictionary:param];

    IMBMessageDataEntity *messageItem = nil;
    while ([rs next]) {
        @autoreleasepool {
            messageItem = [[IMBMessageDataEntity alloc] init];
            int rowid = [rs intForColumn:@"ROWID"];
            NSString *text = nil;
            if (![rs columnIsNull:@"text"]) {
                text = [rs stringForColumn:@"text"];
            } else {
                text = @"";
            }
            int handleid = [rs intForColumn:@"handle_id"];
            NSString *subject = nil;
            if (![rs columnIsNull:@"subject"]) {
                subject = [rs stringForColumn:@"subject"];
            } else {
                subject = @"";
            }
            NSString *contactID = nil;
            if (![rs columnIsNull:@"contact_id"]) {
                contactID = [rs stringForColumn:@"contact_id"];
            } else {
                contactID = @"";
            }
            
            NSString *service = nil;
            if (![rs columnIsNull:@"service"]) {
                service = [rs stringForColumn:@"service"];
            }else {
                service = @"";
            }
            int64_t msgDate = [rs longLongIntForColumn:@"date"];
            int64_t dateread = [rs longLongIntForColumn:@"date_read"];
            BOOL isDelivered = [rs boolForColumn:@"is_delivered"];
            BOOL isFinished = [rs boolForColumn:@"is_finished"];
            BOOL isAttachments = [rs boolForColumn:@"cache_has_attachments"];
            
            NSString *type = [rs stringForColumn:@"type"];
            BOOL isRead = [rs boolForColumn:@"is_read"];
            BOOL isSent = [rs boolForColumn:@"is_sent"];
//            BOOL is_from_me = [rs boolForColumn:@"is_from_me"];
//            if (isSent == 1&&is_from_me ==0 ) {
//                isSent = is_from_me;
//            }
            IMBContactInfoModel *contactInfo = [_contactManager getContactinfoByIdentifier:contactID];
            if (contactInfo != nil) {
                [messageItem setContactName:contactInfo.displayName];
            }else {
                if (![StringHelper stringIsNilOrEmpty:contactID]) {
                    [messageItem setContactName:contactID];
                }else {
                    [messageItem setContactName:CustomLocalizedString(@"Common_id_4", nil)];
                }
            }

           
            [messageItem setRowId:rowid];
            [messageItem setMsgText:text];
            [messageItem setSessionType:type];
            if (![[messageItem msgText] isEqualToString:@""]) {
                messageItem.isTextMedia = YES;
            }
            // 获取文本的大小以字节计算
            NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
            [messageItem setMessageSize:[data length]];
            *textSize += messageItem.messageSize;
            [messageItem setCheckState:UnChecked];
            [messageItem setHandleId:handleid];
            [messageItem setSubject:subject];
            if ([DateHelper getDateLength:msgDate]>=18) {
                msgDate = msgDate/(1000*1000*1000*1.0);
            }
            
            
            [messageItem setMsgDate:msgDate];
            if ([DateHelper getDateLength:dateread]>=18) {
                dateread = dateread/(1000*1000*1000*1.0);
            }
            [messageItem setMsgReadDate:dateread];
            [messageItem setIsDelivered:isDelivered];
            [messageItem setIsFinished:isFinished];
            [messageItem setIsAttachments:isAttachments];
            [messageItem setIsRead:isRead];
            [messageItem setIsSent:isSent];
            [messageItem setService:service];
            if ([messageItem isAttachments]) {
                NSMutableArray *attachArray = [[self queryMessageAttachmentJoinTableIos6:rowid] retain];
                long attCount = 0;
                long attSize = 0;
                if (attachArray != nil) {
                    attCount = attachArray.count;
                    if (attCount > 0) {
                        for (IMBSMSAttachmentEntity *attItem in attachArray) {
                            attSize += attItem.totalFileSize;
                        }
                    }
                }
                [messageItem setAttachmentList:attachArray];
                [messageItem setAttachmentCount:attCount];
                [messageItem setAttachmentSize:attSize];
                *attachmentCount += attCount;
                *attachmentSize += attSize;
                [attachArray release];
                attachArray = nil;
            } else {
                [messageItem setAttachmentList:nil];
                [messageItem setAttachmentCount:0];
                [messageItem setAttachmentSize:0];
            }
            [messageItem setMsgDateText:[self formatDate:[messageItem msgDate]]];
            [messageItem setMsgReadDateText:[self formatDate:[messageItem msgReadDate]]];
            [messageArray addObject:messageItem];
            [messageItem release];
        }
    }
    [rs close];
    return messageArray;
}

- (NSMutableArray *)queryMessageAttachmentJoinTableIos6:(int)msgID {
    NSMutableArray *attachmentArray = [[[NSMutableArray alloc] init] autorelease];
    NSString *selectCmd = @"SELECT ROWID,guid,created_date,start_date,filename,uti,mime_type,transfer_state,is_outgoing FROM attachment where ROWID in (select attachment_id from message_attachment_join where message_id=:messageid);";
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithInt:msgID], @"messageid",
                           nil];
    FMResultSet *rs = nil;

    rs = [_databaseConnection executeQuery:selectCmd withParameterDictionary:param];

    IMBSMSAttachmentEntity *attachItem = nil;
    while ([rs next]) {

        @autoreleasepool {
            int rowid = [rs intForColumn:@"ROWID"];
            NSString *attGUID = nil;
            if (![rs columnIsNull:@"guid"]) {
                attGUID = [rs stringForColumn:@"guid"];
            } else {
                attGUID = @"";
            }
            
            int64_t createDate = [rs longLongIntForColumn:@"created_date"];
            int64_t startDate = [rs longLongIntForColumn:@"start_date"];
            
            NSString *fileName = nil;
            if (![rs columnIsNull:@"filename"]) {
                fileName = [rs stringForColumn:@"filename"];
            } else {
                fileName = @"";
            }
            NSString *utiName = nil;
            if (![rs columnIsNull:@"uti"]) {
                utiName = [rs stringForColumn:@"uti"];
            } else {
                utiName = @"";
            }
            NSString *mimeType = nil;
            if (![rs columnIsNull:@"mime_type"]) {
                mimeType = [rs stringForColumn:@"mime_type"];
            } else {
                mimeType = @"";
            }
            int transferState = 0;
            if ([rs columnIsNull:@"transfer_state"]) {
                transferState = [rs intForColumn:@"transfer_state"];
            }
            BOOL isOutgoing = NO;
            if ([rs columnIsNull:@"is_outgoing"]) {
                [rs boolForColumn:@"is_outgoing"];
            }
            
            attachItem = [[IMBSMSAttachmentEntity alloc] init];
            [attachItem setCheckState:UnChecked];
            [attachItem setMsgID:msgID];
            [attachItem setRowID:rowid];
            [attachItem setAttGUID:attGUID];
            [attachItem setCreateDate:createDate];
            [attachItem setStartDate:startDate];
            [attachItem setFileName:fileName];
            [attachItem setUtiName:utiName];
            [attachItem setMimeType:mimeType];
            [attachItem setTransferState:transferState];
            [attachItem setIsOutgoing:isOutgoing];
            [attachItem setCreateDateText:[self formatDate:[attachItem createDate]]];
            [attachmentArray addObject:attachItem];
            [attachItem release];


        }
    }
    if (attachmentArray.count > 0) {
        IMBBackupManager *backupmanager = [IMBBackupManager shareInstance];
        NSMutableArray * attachAry = [[NSMutableArray alloc]init];
        [backupmanager matchAttachmentManifestDBattachmentList:attachmentArray withAttachData:attachAry];
    }
    //获得附件原文件，加入到_attachDetailList中；
    if (!_isOther) {
     
//            IMBSMSBackUpAttachment *manifestMach = [IMBSMSBackUpAttachment singleton];
//            IMBManifestManager *manifest = nil;
//     
//            manifest = _manifestManager;
//        
//            [manifestMach matchAttachmentManifestDB:manifest.manifestHandle attachmentArray:attachmentArray isRefreshDB:!_isOther withAttachData:_attachmentReslutEntity];
        
    }
    return attachmentArray;
}

#pragma mark ---- ios5数据库查询
- (void)querySMSTableContentIos5 {
    [_logManger writeInfoLog:@"query SMSTableIos5 Content Begin"];
    if ([self openDataBase]) {
        NSMutableArray *SMSMessageArray = [[NSMutableArray alloc] init];
        [self queryChatTableIos5:SMSMessageArray];
        NSMutableArray *SMSGroupmemberArray = [[NSMutableArray alloc] init];
        [self queryGroupMemberTableIos5:SMSGroupmemberArray];
        if (SMSMessageArray != nil && [SMSMessageArray count] > 0) {
            for (IMBSMSChatDataEntity *item in SMSMessageArray) {
                @autoreleasepool {
                    long attachmentCount = 0;
                    long attachmentSize = 0;
                    long textSize = 0;
                    NSMutableArray *chatMsgList = [[self queryChatMessageTableIos5:item.chatIdentifier textSize:&textSize attachmentCount:&attachmentCount attachmentSize:&attachmentSize] retain];
                    if (chatMsgList != nil && chatMsgList.count > 0) {
                        [item setMsgModelList:chatMsgList];
                        [item setMessageCount:chatMsgList.count];
                        item.selectedCount = chatMsgList.count;
                        [item setMessageSize:(textSize + attachmentSize)];
                        //去msg最后的消息
                        IMBMessageDataEntity *msgEntity = [chatMsgList lastObject];
                        item.lastMsgText = msgEntity.msgText;
                        
                        [chatMsgList release];
                        chatMsgList = nil;
                    }else {
                        [item setMessageSize:0];
                        [item setMessageCount:0];
                        item.selectedCount = 0;
                    }
                    [item setAttachmentCount:attachmentCount];
                    [item setAttachmentSize:attachmentSize];
                    [_dataAry addObject:item];

            }
        }
        }
        if (SMSGroupmemberArray != nil && SMSGroupmemberArray.count > 0) {
            for (IMBSMSChatDataEntity *item in SMSGroupmemberArray) {
                @autoreleasepool {
                    long attachmentCount = 0;
                    long attachmentSize = 0;
                    long textSize = 0;
                    NSMutableArray *chatMsgList = [[self queryChatMessageByGroupmemberIos5:item textSize:&textSize attachmentCount:&attachmentCount attachmentSize:&attachmentSize] retain];
                    if (chatMsgList != nil && chatMsgList.count > 0) {
                        [item setMsgModelList:chatMsgList];
                        [item setMessageCount:chatMsgList.count];
                        item.selectedCount = chatMsgList.count;
                        [item setMessageSize:(textSize + attachmentSize)];
                        //去msg最后的消息
                        IMBMessageDataEntity *msgEntity = [chatMsgList lastObject];
                        item.lastMsgText = msgEntity.msgText;
                        
                        [chatMsgList release];
                        chatMsgList = nil;
                    }else {
                        [item setMessageSize:0];
                        [item setMessageCount:0];
                        item.selectedCount = 0;
                    }
                    [item setAttachmentCount:attachmentCount];
                    [item setAttachmentSize:attachmentSize];
                    [_dataAry addObject:item];
                }
            }
        }
        [self closeDataBase];
        [SMSMessageArray release];
        SMSMessageArray = nil;
        [SMSGroupmemberArray release];
        SMSGroupmemberArray = nil;
    }

    [_logManger writeInfoLog:@"query SMSTable Ios5 Content End"];
}

- (void)queryChatTableIos5:(NSMutableArray *)SMSMessageArray {
    
    [_logManger writeInfoLog:@"query Chat Table Ios5: Begin"];
    FMResultSet *rs = nil;
    NSString *selectCmd = @"select ROWID,chat_identifier,service_name,participants from madrid_chat";
    rs = [_databaseConnection executeQuery:selectCmd];
    IMBSMSChatDataEntity *SMSMessageItem = nil;
    while ([rs next]) {
        SMSMessageItem = [[IMBSMSChatDataEntity alloc] init];
        [SMSMessageItem setCheckState:UnChecked];
        int rowid = [rs intForColumn:@"ROWID"];
        NSString *chatIdentifier = nil;
        if (![rs columnIsNull:@"chat_identifier"]) {
            chatIdentifier = [rs stringForColumn:@"chat_identifier"];
        }else {
            chatIdentifier = @"";
        }
        NSString *serviceName = nil;
        if (![rs columnIsNull:@"service_name"]) {
            serviceName = [rs stringForColumn:@"service_name"];
        }else {
            serviceName = @"";
        }
        NSData *partData = [rs dataForColumn:@"participants"];
        CFPropertyListRef list = CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (CFDataRef)partData, kCFPropertyListImmutable, NULL);
        if ([(id)list isKindOfClass:[NSArray class]]) {
            [SMSMessageItem.addressArray addObjectsFromArray:list];
        }
        
        [SMSMessageItem setRowId:rowid];
        [SMSMessageItem setChatIdentifier:chatIdentifier];
        [SMSMessageItem setHandleId:[SMSMessageItem chatIdentifier]];
        [SMSMessageItem setHandleService:serviceName];
        IMBContactInfoModel *contactInfo = [_contactManager getContactinfoByIdentifier:chatIdentifier];
        if (contactInfo != nil) {
            [SMSMessageItem setContactName:contactInfo.displayName];
            [SMSMessageItem setHeadImage:contactInfo.image];
        }else {
            if (![StringHelper stringIsNilOrEmpty:chatIdentifier]) {
                [SMSMessageItem setContactName:chatIdentifier];
            }else {
                [SMSMessageItem setContactName:CustomLocalizedString(@"Common_id_10", nil)];
            }
        }
        [SMSMessageItem setSortStr:[StringHelper getStringFirstWord:SMSMessageItem.contactName]];
        [SMSMessageArray addObject:SMSMessageItem];
        [SMSMessageItem release];
    }
    [rs close];
    for (IMBSMSChatDataEntity *chat in SMSMessageArray) {
        if ([chat.chatIdentifier hasPrefix:@"chat"]) {
            chat.contactName = @"";
            for (NSString *address in chat.addressArray) {
                IMBContactInfoModel *contactInfo = [_contactManager getContactinfoByIdentifier:address];
                if (contactInfo) {
                    if ([chat.contactName isEqualToString:@""]) {
                        chat.contactName = [chat.contactName stringByAppendingFormat:@"%@",contactInfo.displayName];
                    }else{
                        chat.contactName = [chat.contactName stringByAppendingFormat:@"、%@",contactInfo.displayName];
                    }
                    
                }else{
                    if ([chat.contactName isEqualToString:@""]) {
                        chat.contactName = [chat.contactName stringByAppendingFormat:@"%@",address];
                    }else{
                        chat.contactName = [chat.contactName stringByAppendingFormat:@"、%@",address];
                    }
                    
                }
            }
        }
    }
    
    [_logManger writeInfoLog:@"query Chat Table Ios5: End"];
}

- (NSMutableArray *)queryChatMessageByGroupmemberIos5:(IMBSMSChatDataEntity *)chat textSize:(long *)textSize attachmentCount:(long *)attachmenyCount attachmentSize:(long *)attachmentSize {
    
    [_logManger writeInfoLog:@"queryChatMessageByGroupmember: Begin"];
    NSMutableArray *messageArray = [[[NSMutableArray alloc] init] autorelease];
    FMResultSet *rs = nil;
    NSString *selectCmd = @"SELECT ROWID,flags,text,subject,date,madrid_date_read,madrid_date_delivered,madrid_attachmentInfo FROM message where group_id = :groupid and address=:address";
    NSString *address = @"";
    if ([chat.addressArray count]>0) {
        address = [chat.addressArray objectAtIndex:0];
    }
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:chat.groupID], @"groupid",address,@"address",nil];
    rs = [_databaseConnection executeQuery:selectCmd withParameterDictionary:param];
    IMBMessageDataEntity *messageItem = nil;
    while ([rs next]) {
        messageItem = [[IMBMessageDataEntity alloc] init];
        [messageItem setCheckState:UnChecked];
        int rowid = [rs intForColumn:@"ROWID"];
        int groupid = 0;
        if (![rs columnIsNull:@"group_id"]) {
            groupid = [rs intForColumn:@"group_id"];
        } else {
            groupid = 0;
        }
        NSString *text = nil;
        if (![rs columnIsNull:@"text"]) {
            text = [rs stringForColumn:@"text"];
        }else {
            text = @"";
        }
        NSString *subject = nil;
        if (![rs stringForColumn:@"subject"]) {
            subject = [rs stringForColumn:@"subject"];
        }else {
            subject = @"";
        }
        int64_t msgDate = [rs longLongIntForColumn:@"date"];
        int64_t madridDateRead = [rs longLongIntForColumn:@"madrid_date_read"];
        int64_t madridDateDelivered = [rs longLongIntForColumn:@"madrid_date_delivered"];
        id attchmentObj = nil;
        if (![rs columnIsNull:@"madrid_attachmentInfo"]) {
            attchmentObj = [rs objectForColumnName:@"madrid_attachmentInfo"];
        }else {
            attchmentObj = @"";
        }
        
        [messageItem setRowId:rowid];
        [messageItem setHandleId:groupid];
        [messageItem setMsgText:text];
        if (![[messageItem msgText] isEqualToString:@""]) {
            messageItem.isTextMedia = YES;
        }
        //获取文本的大小以字节计算
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        [messageItem setMessageSize:[data length]];
        *textSize += messageItem.messageSize;
        
        [messageItem setSubject:subject];
        [messageItem setMsgDate:msgDate];
        [messageItem setMadridDateRead:madridDateRead];
        [messageItem setMadridDateDelivered:madridDateDelivered];
        [messageItem setFlags:[rs intForColumn:@"flags"]];
        if ([rs intForColumn:@"flags"] == 0) {
            if ([messageItem madridDateDelivered] > 0) {
                [messageItem setIsSent:YES];
                [messageItem setIsFinished:YES];
            }else if ([messageItem madridDateRead] > 0 && [messageItem madridDateDelivered] == 0) {
                [messageItem setIsSent:NO];
                [messageItem setIsFinished:YES];
            }
        }else if ([rs intForColumn:@"flags"] == 2) {
            [messageItem setIsSent:NO];
        }else if ([rs intForColumn:@"flags"] == 3) {
            [messageItem setIsSent:YES];
        }
        
        if (attchmentObj != nil && ![@"" isEqualToString:attchmentObj]) {
            @try {
                NSMutableDictionary *dicContent = [self analyzeAttachmentInfoDataIos5:attchmentObj];
                if ([[dicContent allKeys] count] > 0) {
                    [messageItem setAttachmentInfoDic:dicContent];
                    NSString *whereSql = [self createSelectAttachmentWhereSQLIos5:dicContent];
                    if (whereSql != nil && ![@"" isEqualToString:whereSql]) {
                        NSMutableArray *attachArray = [[self queryMessageAttachmentJoinTableIos5:whereSql msgID:[messageItem rowId]] retain];
                        long attCount = 0;
                        long attSize = 0;
                        if (attachArray != nil) {
                            attCount = attachArray.count;
                            if (attCount > 0) {
                                for (IMBSMSAttachmentEntity *attItem in attachArray) {
                                    attSize += attItem.totalFileSize;
                                }
                            }
                        }
                        [messageItem setIsAttachments:YES];
                        [messageItem setAttachmentList:attachArray];
                        [messageItem setAttachmentCount:attCount];
                        [messageItem setAttachmentSize:attSize];
                        *attachmentSize += attSize;
                        *attachmenyCount += attCount;
                        [attachArray release];
                        attachArray = nil;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@", [exception reason]);
            }
        }
        [messageArray addObject:messageItem];
        [messageItem release];
        messageItem = nil;
    }
    [rs close];
    
    [_logManger writeInfoLog:@"queryChatMessageByGroupmember: End"];
    return messageArray;
    
}

- (NSMutableArray *)queryChatMessageTableIos5:(NSString *)chatIdentifier textSize:(long *)textSize attachmentCount:(long *)attachmenyCount attachmentSize:(long *)attachmentSize {
    
    [_logManger writeInfoLog:@"queryChatMessageTable: Begin"];
    NSMutableArray *messageArray = [[[NSMutableArray alloc] init] autorelease];
    FMResultSet *rs = nil;
    NSString *selectCmd = @"SELECT ROWID,flags,text,subject,date,madrid_handle,madrid_date_read,madrid_date_delivered,madrid_attachmentInfo FROM message where madrid_handle = :madridhandle or madrid_roomname=:madrid_roomname";
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:chatIdentifier, @"madridhandle",chatIdentifier,@"madrid_roomname", nil];

        rs = [_databaseConnection executeQuery:selectCmd withParameterDictionary:param];

    IMBMessageDataEntity *messageItem = nil;
    while ([rs next]) {
        messageItem = [[IMBMessageDataEntity alloc] init];
        [messageItem setCheckState:UnChecked];
        int rowid = [rs intForColumn:@"ROWID"];
        NSString *text = nil;
        if (![rs columnIsNull:@"text"]) {
            text = [rs stringForColumn:@"text"];
        }else {
            text = @"";
        }
        NSString *subject = nil;
        if (![rs columnIsNull:@"subject"]) {
            subject = [rs stringForColumn:@"subject"];
        }else {
            subject = @"";
        }
        NSString *madridHandle = nil;
        if (![rs columnIsNull:@"madrid_handle"]) {
            madridHandle = [rs stringForColumn:@"madrid_handle"];
        }else {
            madridHandle = @"";
        }
        int64_t msgDate = [rs longLongIntForColumn:@"date"];
        int64_t madridDateRead = [rs longLongIntForColumn:@"madrid_date_read"];
        int64_t madridDateDelivered = [rs longLongIntForColumn:@"madrid_date_delivered"];
        id attchmentObj = nil;
        if (![rs columnIsNull:@"madrid_attachmentInfo"]) {
            attchmentObj = [rs objectForColumnName:@"madrid_attachmentInfo"];
        }else {
            attchmentObj = @"";
        }
        
        [messageItem setRowId:rowid];
        [messageItem setMsgText:text];
        if (![[messageItem msgText] isEqualToString:@""]) {
            messageItem.isTextMedia = YES;
        }
        //获取文本的大小以字节计算
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        [messageItem setMessageSize:[data length]];
        *textSize += messageItem.messageSize;
        
        [messageItem setSubject:subject];
        [messageItem setMadridHandle:madridHandle];
        [messageItem setMsgDate:msgDate];
        [messageItem setMadridDateRead:madridDateRead];
        [messageItem setMadridDateDelivered:madridDateDelivered];
        [messageItem setFlags:[rs intForColumn:@"flags"]];
        
        if ([rs intForColumn:@"flags"] == 0) {
            if ([messageItem madridDateDelivered] > 0) {
                [messageItem setIsSent:YES];
                [messageItem setIsFinished:YES];
            }else if ([messageItem madridDateRead] > 0 && [messageItem madridDateDelivered] == 0) {
                [messageItem setIsSent:NO];
                [messageItem setIsFinished:YES];
            }
        }else if ([rs intForColumn:@"flags"] == 2) {//2是读取的
            [messageItem setIsSent:NO];
        }else if ([rs intForColumn:@"flags"] == 3) {//3是发送的
            [messageItem setIsSent:YES];
        }
        
        if (attchmentObj != nil && ![@"" isEqualToString:attchmentObj]) {
            @try {
                NSMutableDictionary *dicContent = [self analyzeAttachmentInfoDataIos5:attchmentObj];
                if ([[dicContent allKeys] count] > 0) {
                    [messageItem setAttachmentInfoDic:dicContent];
                    NSString *whereSql = [self createSelectAttachmentWhereSQLIos5:dicContent];
                    if (whereSql != nil && ![@"" isEqualToString:whereSql]) {
                        NSMutableArray *attachArray = [[self queryMessageAttachmentJoinTableIos5:whereSql msgID:[messageItem rowId]] retain];
                        long attCount = 0;
                        long attSize = 0;
                        if (attachArray != nil) {
                            attCount = attachArray.count;
                            if (attCount > 0) {
                                for (IMBSMSAttachmentEntity *attItem in attachArray) {
                                    attSize += attItem.totalFileSize;
                                }
                            }
                        }
                        [messageItem setIsAttachments:YES];
                        [messageItem setAttachmentList:attachArray];
                        [messageItem setAttachmentCount:attCount];
                        [messageItem setAttachmentSize:attSize];
                        *attachmentSize += attSize;
                        *attachmenyCount += attCount;
                        [attachArray release];
                        attachArray = nil;
                    }
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@", [exception reason]);
            }
        }
        [messageArray addObject:messageItem];
        [messageItem release];
        messageItem = nil;
    }
    [rs close];
    [_logManger writeInfoLog:@"queryChatMessageTable: End"];
    return messageArray;
}

- (NSMutableDictionary *)analyzeAttachmentInfoDataIos5:(id)attchmentObj {
    NSMutableDictionary *attachInfoDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    NSMutableData *rstData = (NSMutableData *)attchmentObj;
    Byte *rstByte = (Byte *)[rstData bytes];
    
    // Analyze - head
    Byte vabyte;
    [rstData getBytes:&vabyte range:NSMakeRange(66, 1)];
    NSString *val = [[NSString alloc] initWithBytes:&vabyte length:1 encoding:NSASCIIStringEncoding];
    Byte *header;
    int lastval = 0;
    if ([val isEqualToString:@"$"]) {
        lastval = 66;
    } else {
        lastval = 103;
    }
    header = malloc(lastval + 1);
    memset(header, 0, lastval + 1);
    memcpy(header, rstByte, lastval);
    [attachInfoDictionary setObject:[NSData dataWithBytes:header length:lastval] forKey:@"head"];
    free(header);
    
    NSString *attGuid = @"";
    
    int i = lastval;
    while (YES) {
        int bLength = 38;
        Byte *b = malloc(bLength + 1);
        memset(b, 0, bLength + 1);
        int j = 0;
        // Analyze - attachmentGUID
        while (YES) {
            if (j == bLength) {
                NSString *guid = [[NSString alloc] initWithBytes:b length:bLength encoding:NSASCIIStringEncoding];
                if (guid != nil && ![guid isEqualToString:@""]) {
                    guid = [[guid stringByReplacingOccurrencesOfString:@"$" withString:@""] stringByReplacingOccurrencesOfString:@"?" withString:@""];
                    [attachInfoDictionary setObject:[NSData dataWithBytes:b length:bLength] forKey:guid];
                    attGuid = guid;
                }
                break;
            }
            b[j] = rstByte[i];
            j++;
            i++;
        }
        free(b);
        
        // Analyze - separate
        if (i <= [rstData length] - 1) {
            Byte fbyte = rstByte[i];
            [attachInfoDictionary setObject:[NSData dataWithBytes:&fbyte length:1] forKey:@"f"];
            break;
        } else {
            int spacLength = 4;
            Byte *spacByte =malloc(spacLength + 1);
            memset(spacByte, 0, spacLength + 1);
            int num = 0;
            while (YES) {
                if (num ==  4) {
                    [attachInfoDictionary setObject:[NSData dataWithBytes:spacByte length:spacLength] forKey:[@"spac-" stringByAppendingString:attGuid]];
                    break;
                }
                spacByte[num] = rstByte[i];
                num++;
                i++;
            }
            free(spacByte);
        }
    }
    
    return attachInfoDictionary;
}

- (NSString *)createSelectAttachmentWhereSQLIos5:(NSMutableDictionary *)attDictionary {
    NSString *whereSql = @"";
    NSMutableString *builder = [[[NSMutableString alloc] init] autorelease];
    NSArray *aKeys = [attDictionary allKeys];
    for (NSString *aKey in aKeys) {
        if ([aKey length] > 10 && [aKey rangeOfString:@"-"].length > 0) {
            if ([aKey hasSuffix:@""]) {
                aKey = [aKey substringToIndex:[aKey length] - 1];
            }
            [builder appendString:@"'"];
            [builder appendString:aKey];
            [builder appendString:@"',"];
        }
    }
    if ([builder length] > 0) {
        whereSql = [builder substringToIndex:([builder length] - 1)];
    }
    return whereSql;
}

- (NSMutableArray *)queryMessageAttachmentJoinTableIos5:(NSString *)whereSql msgID:(int)msgID {
    
    [_logManger writeInfoLog:@"queryMessageAttachmentJoinTable Begin"];
    NSMutableArray *attachmentList = [[[NSMutableArray alloc] init] autorelease];
    NSMutableString *selectCmd = [[[NSMutableString alloc] init] autorelease];
    [selectCmd appendString:@"SELECT ROWID,attachment_guid,created_date,start_date,filename,uti_type,mime_type,transfer_state,is_incoming FROM madrid_attachment WHERE attachment_guid in ("];
    [selectCmd appendString:whereSql];
    [selectCmd appendString:@")"];
    FMResultSet *rs = nil;

    rs = [_databaseConnection executeQuery:selectCmd];
 
    IMBSMSAttachmentEntity *attachItem = nil;
    while ([rs next]) {
        int rowid = [rs intForColumn:@"ROWID"];
        NSString *attachmentGuid = nil;
        if (![rs columnIsNull:@"attachment_guid"]) {
            attachmentGuid = [rs stringForColumn:@"attachment_guid"];
        }else {
            attachmentGuid = @"";
        }
        int64_t createDate = [rs longLongIntForColumn:@"created_date"];
        int64_t startDate = [rs longLongIntForColumn:@"start_date"];
        NSString *fileName = nil;
        if (![rs columnIsNull:@"filename"]) {
            fileName = [rs stringForColumn:@"filename"];
        }else {
            fileName = @"";
        }
        NSString *utiName = nil;
        if (![rs columnIsNull:@"uti_type"]) {
            utiName = [rs stringForColumn:@"uti_type"];
        } else {
            utiName = @"";
        }
        NSString *mimeType = nil;
        if (![rs columnIsNull:@"mime_type"]) {
            mimeType = [rs stringForColumn:@"mime_type"];
        } else {
            mimeType = @"";
        }
        int transferState = [rs intForColumn:@"transfer_state"];
        
        attachItem = [[IMBSMSAttachmentEntity alloc] init];
        [attachItem setCheckState:UnChecked];
        [attachItem setMsgID:msgID];
        [attachItem setRowID:rowid];
        [attachItem setAttGUID:attachmentGuid];
        [attachItem setCreateDate:createDate];
        [attachItem setStartDate:startDate];
        [attachItem setFileName:fileName];
        [attachItem setUtiName:utiName];
        [attachItem setMimeType:mimeType];
        [attachItem setTransferState:transferState];
        [attachItem setCreateDateText:[self formatDate:[attachItem createDate]]];
        [attachItem setIsOutgoing:[rs boolForColumn:@"is_incoming"]];
        [attachmentList addObject:attachItem];
        [attachItem release];
        attachItem = nil;
    }
    if (attachmentList.count > 0) {
        IMBBackupManager *backupmanager = [IMBBackupManager shareInstance];
        NSMutableArray * attachAry = [[NSMutableArray alloc]init];
        [backupmanager matchAttachmentArray:attachmentList withReslutAry:attachAry];
    }
    //todo获得附件原文件,加入到_attachDetailList中；
//    if (!_isOther) {
//
//            IMBSMSBackUpAttachment *manifestMach = [IMBSMSBackUpAttachment singleton];
//            IMBManifestManager *manifest = nil;
//            if (_isCompare) {
//                manifest = _otherManifest;
//            }else{
//                manifest = _manifestManager;
//            }
//            [manifestMach matchAttachmentManifestDB:manifest.manifestHandle attachmentArray:attachmentList isRefreshDB:!_isOther withAttachData:_attachmentReslutEntity];
//    
//    }
    [_logManger writeInfoLog:@"queryMessageAttachmentJoinTable End"];
    return attachmentList;
}

- (void)queryGroupMemberTableIos5:(NSMutableArray *)groupmemberArray {
    
    [_logManger writeInfoLog:@"query GroupMember Table Ios5: Begin"];
    FMResultSet *rs = nil;
    NSString *selectCmd = @"select a.ROWID,a.group_id,a. address, a.country ,b.type,b.newest_message,b.hash from group_member as a left join msg_group as b on a.group_id = b.rowid";
    rs = [_databaseConnection executeQuery:selectCmd];
    IMBSMSChatDataEntity *item = nil;
    while ([rs next]) {
        int rowid = [rs intForColumn:@"ROWID"];
        int groupID = [rs intForColumn:@"group_id"];
        int groupType = [rs intForColumn:@"type"];
        int newest_message = [rs intForColumn:@"newest_message"];
        int hash = [rs intForColumn:@"hash"];
        NSString *chatIdentifier = nil;
        if (![rs columnIsNull:@"address"]) {
            chatIdentifier = [rs stringForColumn:@"address"];
        }else {
            chatIdentifier = @"";
        }
        NSString *serviceName = nil;
        if (![rs columnIsNull:@"service_name"]) {
            serviceName = [rs stringForColumn:@"service_name"];
        }else {
            serviceName = @"";
        }
        NSPredicate *cate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            IMBSMSChatDataEntity *chat = (IMBSMSChatDataEntity *)evaluatedObject;
            if (chat.groupID == groupID) {
                return YES;
            }else{
                return NO;
            }
        }];
        NSArray *chatArray = [groupmemberArray filteredArrayUsingPredicate:cate];
        if ([chatArray count]>0) {
            IMBSMSChatDataEntity *chat = [chatArray objectAtIndex:0];
            //重新构建chatIdentifier
            long long x = (arc4random() % 30000000000000000) + 60000000000000000;
            [chat.addressArray addObject:chatIdentifier];
            [chat.groupROWIDArray addObject:@(rowid)];
            chat.chatIdentifier = [NSString stringWithFormat:@"chat%lld",x];
        }else{
            item = [[IMBSMSChatDataEntity alloc] init];
            [item setGroupID:groupID];
            [item setRowId:rowid];
            [item setChatIdentifier:chatIdentifier];
            [item setGroupType:groupType];
            [item setGroupnewestMessage:newest_message];
            [item setGroupHash:hash];
            [item.addressArray addObject:chatIdentifier];
            [item.groupROWIDArray addObject:@(rowid)];
            IMBContactInfoModel *contactInfo = [_contactManager getContactinfoByIdentifier:chatIdentifier];
            if (contactInfo != nil) {
                [item setContactName:contactInfo.displayName];
                [item setHeadImage:contactInfo.image];
            }else {
                if (![StringHelper stringIsNilOrEmpty:chatIdentifier]) {
                    [item setContactName:chatIdentifier];
                }else {
                    [item setContactName:CustomLocalizedString(@"Common_id_10", nil)];
                }
            }
            [item setSortStr:[StringHelper getStringFirstWord:item.contactName]];
            //[SMSMessageItem setContactName:@""];
            [groupmemberArray addObject:item];
            [item release];
        }
    }
    [rs close];
    for (IMBSMSChatDataEntity *chat in groupmemberArray) {
        if ([chat.chatIdentifier hasPrefix:@"chat"]) {
            chat.contactName = @"";
            for (NSString *address in chat.addressArray) {
                IMBContactInfoModel *contactInfo = [_contactManager getContactinfoByIdentifier:address];
                if (contactInfo) {
                    if ([chat.contactName isEqualToString:@""]) {
                        chat.contactName = [chat.contactName stringByAppendingFormat:@"%@",contactInfo.displayName];
                    }else{
                        chat.contactName = [chat.contactName stringByAppendingFormat:@"、%@",contactInfo.displayName];
                    }
                    
                }else{
                    if ([chat.contactName isEqualToString:@""]) {
                        chat.contactName = [chat.contactName stringByAppendingFormat:@"%@",address];
                    }else{
                        chat.contactName = [chat.contactName stringByAppendingFormat:@"、%@",address];
                    }
                    
                }
            }
        }
    }
    [_logManger writeInfoLog:@"query GroupMember Table Ios5: End"];
}

- (NSString *)formatDate:(int64_t)date {
    NSString *dateString = @"";
    //    NSDate *date1 = [[[NSDate alloc] initWithTimeIntervalSinceReferenceDate:date]autorelease];
    //    dateString = [IMBHelper getHistoryDateString:date1];
    
    if (date < 0) {
        dateString = [DateHelper dateFrom1970ToString:[[NSDate date] timeIntervalSince1970] withMode:2];
    }else {
        if (date > [[NSDate date] timeIntervalSince1970]) {
            dateString = [DateHelper dateFrom1904ToString:(long)date withMode:3];
        }else {
            if (date > [[NSDate date] timeIntervalSinceDate:[DateHelper dateFromString2001]]) {
                dateString = [DateHelper dateFrom1970ToString:(long)date withMode:3];
            }else {
                dateString = [DateHelper dateFrom2001ToString:(long)date withMode:3];
            }
        }
    }
    return dateString;
}

- (void)dealloc {
    if (_contactManager != nil) {
        [_contactManager release];
        _contactManager = nil;
    }
    [super dealloc];
}

@end
