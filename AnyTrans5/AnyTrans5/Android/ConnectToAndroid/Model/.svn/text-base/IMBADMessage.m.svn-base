//
//  IMBADMessage.m
//  PhoneRescue_Android
//
//  Created by iMobie on 4/14/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBADMessage.h"
#import "DateHelper.h"
#import "IMBHelper.h"
#import "TempHelper.h"
#import "RegexKitLite.h"
#import "NSString+Category.h"

@implementation IMBADMessage
@synthesize journalPath = _journalPath;

- (id)initWithSerialNumber:(NSString *)serialNumber {
    if (self = [super initWithSerialNumber:serialNumber]) {
        _isScanAttachment = YES;
        _attachReslutEntity = [[IMBResultEntity alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (_journalPath != nil) {
        [_journalPath release];
        _journalPath = nil;
    }
    [_htmlImgFolderPath release],_htmlImgFolderPath = nil;
    [super dealloc];
}

- (void)setJournalPath:(NSString *)journalPath {
    if (_journalPath != nil) {
        [_journalPath release];
        _journalPath = nil;
    }
    _journalPath = [journalPath retain];
}

- (NSString *)getDatabasesPath {
    NSString *backup = [IMBHelper getSerialNumberPath:_serialNumber];
    self.dbPath = [backup stringByAppendingPathComponent:@"sms.db"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:_dbPath]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *lbDate = [dateFormatter stringFromDate:[NSDate date]];
        NSString *toPath = [backup stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-sms.db",lbDate]];
        [fm moveItemAtPath:_dbPath toPath:toPath error:nil];
        [dateFormatter release];
    }
    
    self.journalPath = [backup stringByAppendingPathComponent:@"journal_sms.db"];
    if ([fm fileExistsAtPath:_journalPath]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *lbDate = [dateFormatter stringFromDate:[NSDate date]];
        NSString *toPath = [backup stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-journal_sms.db",lbDate]];
        [fm moveItemAtPath:_journalPath toPath:toPath error:nil];
        [dateFormatter release];
    }
    
    return _dbPath;
}

#pragma mark - Abstract Method
- (int)queryDetailContent {
    [_loghandle writeInfoLog:@"Message queryDetailContent Begin"];
    int result = 0;
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        [coreSocket setIsSingleQuery:YES];
        NSDictionary *paramDic = [NSDictionary dictionary];
        NSString *jsonStr = [self createParamsjJsonCommand:SMS Operate:QUERY ParamDic:paramDic];
        if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
            ret = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg) {
                    NSDictionary *msgDic = [IMBFileHelper dictionaryWithJsonString:msg];
                    if (msgDic != nil) {
                        IMBThreadsEntity *threadsEntity = [[IMBThreadsEntity alloc] init];
                        [threadsEntity dictionaryToObject:msgDic];
                        
                        _reslutEntity.scanType = ScanMessageFile;
                        [_reslutEntity.reslutArray addObject:threadsEntity];
                         _reslutEntity.reslutCount += 1;
                        [threadsEntity release];
                    }
                }else {
                    NSLog(@"错误");
                    [_loghandle writeInfoLog:@"Message queryDetailContent Error"];
                }
                [msg release];
            }];
            /*if (ret && _isScanAttachment) {
                if (_reslutEntity.reslutArray.count > 0) {
                    [coreSocket setIsSingleQuery:NO];
                    for (IMBThreadsEntity *entity in _reslutEntity.reslutArray) {
                        if (entity.messageCount > 0) {
                            for (IMBADMessageEntity *mesEntity in entity.messageList) {
                                if (mesEntity.smsType == 1) {
                                    for (IMBSMSPartEntity *partEntity in mesEntity.partList) {
                                        if (![partEntity.ct hasPrefix:@"application/"] && ![partEntity.ct hasPrefix:@"text/"]) {
                                            IMBSMSPartEntity *attEntity = [[IMBSMSPartEntity alloc] init];
                                            attEntity.partId = partEntity.partId;
                                            attEntity.seq = partEntity.seq;
                                            attEntity.chset = partEntity.chset;
                                            if (![IMBHelper stringIsNilOrEmpty:partEntity.cid]) {
                                                attEntity.cid = partEntity.cid;
                                            }
                                            if (![IMBHelper stringIsNilOrEmpty:partEntity.cl]) {
                                                attEntity.cl = partEntity.cl;
                                            }
                                            if (![IMBHelper stringIsNilOrEmpty:partEntity.text]) {
                                                attEntity.text = partEntity.text;
                                            }
                                            if (![IMBHelper stringIsNilOrEmpty:partEntity.ct]) {
                                                attEntity.ct= partEntity.ct;
                                            }
                                            if (![IMBHelper stringIsNilOrEmpty:partEntity.partname]) {
                                                attEntity.partname = partEntity.partname;
                                            }
                                            
                                            _attachReslutEntity.scanType = ScanMessageAttachmentFile;
                                            _attachReslutEntity.selectedCount ++;
                                            _attachReslutEntity.reslutCount ++;
                                            [_attachReslutEntity.reslutArray addObject:attEntity];
                                            [attEntity release];
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }else {
                result = -3;
            }*/
        }else {
            result = -2;
        }
        
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
        [coreSocket release];
    }else {
        result = -1;
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
    }

    [self sortResultArray];

    [_loghandle writeInfoLog:@"Message queryDetailContent End"];
    return result;
}

/**
 *获得附件,path：导出时的路劲；不需要就传nil；
 */
- (BOOL)getAttachmentContent:(IMBSMSPartEntity *)partEntity withPath:(NSString *)path {
    BOOL result = NO;
    _currSize = 0;
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        [coreSocket setIsSingleQuery:YES];
         NSDictionary *attParamDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",partEntity.partId], @"attchmentId", nil];
         NSString *attJsonStr = [self createParamsjJsonCommand:SMS Operate:QUERY ParamDic:attParamDic];
         if (![IMBFileHelper stringIsNilOrEmpty:attJsonStr]) {
             NSFileManager *fm = [NSFileManager defaultManager];
             if (path == nil) {//默认写入缓存（tmp）路径
                 path = [IMBFileHelper getAppTempPath];
             }
             NSString *fileName = @"137847597394";
             if (![IMBHelper stringIsNilOrEmpty:partEntity.cl]) {
                 fileName = [partEntity.cl stringByReplacingOccurrencesOfString:@"/" withString:@" "];
             }
             NSString *filePath = [path stringByAppendingPathComponent:fileName];
             if ([fm fileExistsAtPath:filePath]) {
                filePath = [IMBFileHelper getFilePathAlias:filePath];
             }
             BOOL isSuccess = [fm createFileAtPath:filePath contents:nil attributes:nil];
             [partEntity setLocalPath:filePath];
             ret = [coreSocket launchRequestContent:attJsonStr FinishBlock:^(NSData *data) {
                 @synchronized(self) {
                    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    if(msg) {
                        NSLog(@"msg:%@",msg);
                    }
                     if (msg == nil) {
                         if (isSuccess) {
                             _currSize = data.length;
                             NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
                             [handle writeData:data];
                             [handle closeFile];
                         }
                     }
                     [msg release];
                 }
             }];
             if (ret && [fm fileExistsAtPath:filePath]) {
                 result = YES;
                 partEntity.isLoad = YES;
                 _attachReslutEntity.reslutSize += _currSize;
             }else {
                 if ([fm fileExistsAtPath:filePath]) {
                     [fm removeItemAtPath:filePath error:nil];
                 }
             }
         }
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
        [coreSocket release];
    }else {
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
    }
    
    return result;
}

/**
 *查询删除数据
 */
- (void)queryDeleteContent {
    [_loghandle writeInfoLog:@"Message queryDeleteContent Begin"];
#if Android_Google
//    self.dbPath = @"/Users/imobie/Desktop/安卓研究/PhoneRescue for Andriod/数据库/bugle_db.bugle_db";
    [self queryGoogleSMSDeleteContent];
#else 
    [self querySMSDeleteContent];
    
    [self queryMMSDeleteContent];
    
    [self queryThreadsDeletaContent];
#endif
    [_loghandle writeInfoLog:@"Message queryDeleteContent End"];
}

//查询threads表
- (void)queryThreadsDeletaContent {
    [_loghandle writeInfoLog:@"Message queryThreadsDeletaContent Begin"];
    NSMutableArray *columnArr = [NSMutableArray array];
    NSMutableDictionary *columnDic = [NSMutableDictionary dictionary];
    if ([self openDBConnection]) {
        NSString *selectCmd = @"PRAGMA table_info (threads)";
        FMResultSet *rs = [_fmDB executeQuery:selectCmd];
        while ([rs next]) {
            int cid = [rs intForColumn:@"cid"];
            NSString *name = [rs stringForColumn:@"name"];
            if ([name isEqualToString:@"read"] || [name isEqualToString:@"snippet"]) {
                [columnArr addObject:[NSNumber numberWithInt:cid]];
            }
            if (![IMBHelper stringIsNilOrEmpty:name]) {
                [columnDic setValue:name forKey:[NSString stringWithFormat:@"column-%d",cid]];
            }
        }
        [rs close];
        rs = nil;
        [self closeDBConnection];
    }

    [_loghandle writeInfoLog:@"Message queryThreadsDeletaContent End"];
}

//查询sms表
- (void)querySMSDeleteContent {
    [_loghandle writeInfoLog:@"Message querySMSDeleteContent Begin"];
    NSMutableArray *columnArr = [NSMutableArray array];
    NSMutableDictionary *columnDic = [NSMutableDictionary dictionary];
    if ([self openDBConnection]) {
        NSString *selectCmd = @"PRAGMA table_info (sms)";
        FMResultSet *rs = [_fmDB executeQuery:selectCmd];
        while ([rs next]) {
            int cid = [rs intForColumn:@"cid"];
            NSString *name = [rs stringForColumn:@"name"];
            if ([name isEqualToString:@"read"] || [name isEqualToString:@"send"] || [name isEqualToString:@"body"]) {
                [columnArr addObject:[NSNumber numberWithInt:cid]];
            }
            if (![IMBHelper stringIsNilOrEmpty:name]) {
                [columnDic setValue:name forKey:[NSString stringWithFormat:@"column-%d",cid]];
            }
        }
        [rs close];
        rs = nil;
        [self closeDBConnection];
    }
    [_loghandle writeInfoLog:@"Message querySMSDeleteContent End"];
}

- (void)parseSMSDeleteData:(NSArray *)smsArr withColumnDic:(NSDictionary *)columnDic withIsJournal:(BOOL)isJournal {
    for (NSDictionary *dic in smsArr) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            break;
        }
        if ([dic.allKeys containsObject:@"Value"]) {
            NSArray *valueArr = [dic objectForKey:@"Value"];
            if (valueArr != nil) {
                @autoreleasepool {
                    IMBADMessageEntity *smsEntity = [[IMBADMessageEntity alloc] init];
                    [smsEntity setIsDeleted:YES];
                    [smsEntity setSmsType:0];
                    for (NSDictionary *itemDic in valueArr){
                        [_condition lock];
                        if (_isPause) {
                            [_condition wait];
                        }
                        [_condition unlock];
                        if (_isStop) {
                            break;
                        }
                        if ([itemDic.allKeys containsObject:@"columnIndex"]) {
                            NSString *dataStr = @"";
                            if ([itemDic.allKeys containsObject:@"data"]) {
                                dataStr = [itemDic objectForKey:@"data"];
                            }
                            if (![IMBHelper stringIsNilOrEmpty:dataStr]) {
                                int columnIndex = [[itemDic objectForKey:@"columnIndex"] intValue];
                                NSString *column = [NSString stringWithFormat:@"column-%d",columnIndex];
                                if ([columnDic.allKeys containsObject:column]) {
                                    NSString *columnName = [columnDic objectForKey:column];
                                    if ([columnName isEqualToString:@"_id"]) {
                                        smsEntity.msId = dataStr.intValue;
                                    }else if ([columnName isEqualToString:@"thread_id"]) {
                                        smsEntity.threadId = dataStr.intValue;
                                    }else if ([columnName isEqualToString:@"address"]) {
                                        smsEntity.address = [IMBHelper stringReplaceNumber:[IMBHelper stringFromHexString:dataStr]];
                                    }else if ([columnName isEqualToString:@"date"]) {
                                        smsEntity.date = dataStr.longLongValue;
                                        if ([IMBHelper getDateLength:smsEntity.date] <= 10) {
                                            smsEntity.date = smsEntity.date*1000;
                                        }
                                        smsEntity.sortDate = smsEntity.date;
                                    }else if ([columnName isEqualToString:@"read"]) {
                                        smsEntity.read = dataStr.intValue;
                                    }else if ([columnName isEqualToString:@"status"]) {
                                        smsEntity.status = dataStr.intValue;
                                    }else if ([columnName isEqualToString:@"type"]) {
                                        smsEntity.type = dataStr.intValue;
                                    }else if ([columnName isEqualToString:@"body"]) {
                                        smsEntity.body = [IMBHelper stringFromHexString:dataStr];
                                    }
                                }
                            }
                        }
                    }
                    if ([IMBHelper stringIsNilOrEmpty:smsEntity.body]) {
                        [smsEntity release];
                        continue;
                    }
                    if (smsEntity.sortDate <= 0) {
                        smsEntity.date = [[NSDate date] timeIntervalSince1970]*1000;
                        smsEntity.sortDate = smsEntity.date;
                    }
                    //用address的后七位匹配会话的address，找到对应的会话；
                    IMBThreadsEntity *threadEntity = nil;
                    if (![IMBHelper stringIsNilOrEmpty:smsEntity.address]) {
                        NSString *subAddress = smsEntity.address;
                        BOOL compareMode = NO;//电话号码大于7位，则通过后七位相等比较；如果电话号码小于等于7位，就通过完全相等比较；
                        if (smsEntity.address.length > 7) {
                            compareMode = YES;
                            subAddress = [smsEntity.address substringFromIndex:smsEntity.address.length - 7];
                        }
                        if (![IMBHelper stringIsNilOrEmpty:subAddress] && _reslutEntity.reslutArray.count > 0) {
                            for (IMBThreadsEntity *item in _reslutEntity.reslutArray) {
                                if (item.type == 0 && item.recipients != nil) {
                                    for (NSString *addr in item.recipients) {
                                        if (compareMode) {
                                            if ([[IMBHelper stringReplaceNumber:addr] hasSuffix:subAddress]) {
                                                threadEntity = item;
                                                break;
                                            }
                                        }else {
                                            if ([[IMBHelper stringReplaceNumber:addr] isEqualToString:subAddress]) {
                                                threadEntity = item;
                                                break;
                                            }
                                        }
                                    }
                                }
                                if (threadEntity != nil) {
                                    break;
                                }
                            }
                        }
                    }
                    /*通过threadid匹配
                    NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                        IMBThreadsEntity *item = (IMBThreadsEntity *)evaluatedObject;
                        if ([item threadId] == smsEntity.threadId) {
                            return YES;
                        }else {
                            return NO;
                        }
                    }];
                    NSArray *preArray = [_reslutEntity.reslutArray filteredArrayUsingPredicate:pre];
                     */
                    if (threadEntity != nil) {
                        //通过时间、类型和文本内容完全相同去判断找到的删除数据是否已经在数组中存在，如果存在，则去掉该删除数据；
                        BOOL isExist = NO;
                        for (IMBADMessageEntity *mesEntity in threadEntity.messageList) {
                            if (mesEntity.sortDate == smsEntity.sortDate && [mesEntity.body isEqualToString:smsEntity.body] && mesEntity.type == smsEntity.type) {
                                isExist = YES;
                                break;
                            }
                        }
                        if (!isExist) {
                            threadEntity.messageCount ++;
                            threadEntity.selectedCount ++;
                            threadEntity.deleteCount ++;
                            threadEntity.isDeleted = YES;
                            if (threadEntity.messageCount != threadEntity.deleteCount) {
                                threadEntity.isHaveExistAndDeleted = YES;
                            }
                            _reslutEntity.reslutCount ++;
                            _reslutEntity.deleteCount ++;
                            _reslutEntity.selectedCount ++;
                            [threadEntity.messageList addObject:smsEntity];
                        }
                    }else {
                        threadEntity = [[IMBThreadsEntity alloc] init];
                        threadEntity.type = 0;
                        threadEntity.threadId = smsEntity.threadId;
                        threadEntity.date = smsEntity.sortDate;
                        if (!smsEntity.address) {
                            smsEntity.address = [NSString stringWithFormat:@"%lld",threadEntity.date];
                        }
                        threadEntity.threadsname = smsEntity.address;
                        BOOL isIgnore = NO;
                        if (isJournal) {
                            isIgnore = NO;
                            for (IMBThreadsEntity *entity in _reslutEntity.reslutArray) {
                                if (![IMBHelper stringIsNilOrEmpty:entity.threadsname] && [entity.threadsname isEqualToString:threadEntity.threadsname]) {
                                    if (entity.messageList.count > 0) {
                                        for (IMBADMessageEntity *sEntity in entity.messageList) {
                                            if (![IMBHelper stringIsNilOrEmpty:sEntity.body] && [sEntity.body isEqualToString:smsEntity.body]) {
                                                isIgnore = YES;
                                                break;
                                            }
                                        }
                                    }
                                    if (isIgnore) {
                                        break;
                                    }
                                }
                            }
                        }
                        
                        
                        if (!isJournal) {
                            [threadEntity.recipients addObject:smsEntity.address];
                            threadEntity.messageCount ++;
                            threadEntity.selectedCount ++;
                            threadEntity.deleteCount ++;
                            threadEntity.isDeleted = YES;
                            [threadEntity.messageList addObject:smsEntity];
                            _reslutEntity.deleteCount ++;
                            _reslutEntity.reslutCount ++;
                            _reslutEntity.selectedCount ++;
                            _reslutEntity.scanType = ScanMessageFile;
                            if (_reslutEntity.reslutArray.count > 0) {
                                [_reslutEntity.reslutArray insertObject:threadEntity atIndex:0];
                            }else {
                                [_reslutEntity.reslutArray addObject:threadEntity];
                            }
                        }
                        [threadEntity release];
                    }
                    [smsEntity release];
                }
            }
        }
    }
}

//查询mms
- (void)queryMMSDeleteContent {
    [_loghandle writeInfoLog:@"Message queryMMSDeleteContent Begin"];
    NSMutableArray *pduColumnArr = [NSMutableArray array];
    NSMutableDictionary *pduColumnDic = [NSMutableDictionary dictionary];
    NSMutableArray *partColumnArr = [NSMutableArray array];
    NSMutableDictionary *partColumnDic = [NSMutableDictionary dictionary];
    if ([self openDBConnection]) {
        NSString *selectCmd = @"PRAGMA table_info (pdu)";
        FMResultSet *rs = [_fmDB executeQuery:selectCmd];
        while ([rs next]) {
            int cid = [rs intForColumn:@"cid"];
            NSString *name = [rs stringForColumn:@"name"];
            if ([name isEqualToString:@"date"] || [name isEqualToString:@"read"]) {
                [pduColumnArr addObject:[NSNumber numberWithInt:cid]];
            }
            if (![IMBHelper stringIsNilOrEmpty:name]) {
                [pduColumnDic setValue:name forKey:[NSString stringWithFormat:@"column-%d",cid]];
            }
        }
        [rs close];
        rs = nil;
        
        selectCmd = @"PRAGMA table_info (part)";
        rs = [_fmDB executeQuery:selectCmd];
        while ([rs next]) {
            int cid = [rs intForColumn:@"cid"];
            NSString *name = [rs stringForColumn:@"name"];
            if ([name isEqualToString:@"ct"] || [name isEqualToString:@"cid"] || [name isEqualToString:@"cl"]) {
                [partColumnArr addObject:[NSNumber numberWithInt:cid]];
            }
            if (![IMBHelper stringIsNilOrEmpty:name]) {
                [partColumnDic setValue:name forKey:[NSString stringWithFormat:@"column-%d",cid]];
            }
        }
        [rs close];
        rs = nil;
        
        [self closeDBConnection];
    }
    [_loghandle writeInfoLog:@"Message queryMMSDeleteContent End"];
}

- (NSString *)parseMMSSmilext:(NSString *)oriStr {
    if ([IMBHelper stringIsNilOrEmpty:oriStr]) {
        return @"";
    }
    NSArray *newArr = [oriStr componentsMatchedByRegex:@"co=.[\\s\\S]*?/></par>"];
    NSMutableString *retStr = [NSMutableString string];
    for (NSString *item in newArr) {
        NSString *str = [item stringByReplacingOccurrencesOfString:@"&#10;" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"co=\"" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\"/></par>" withString:@"\n\n"];
        [retStr appendString:str];
    }
    NSLog(@"retStr:%@",retStr);
    return retStr;
}

//查询google设备message数据库删除数据
- (void)queryGoogleSMSDeleteContent {
    [_loghandle writeInfoLog:@"Message queryGoogleSMSDeleteContent Begin"];
    NSMutableArray *columnArr = [NSMutableArray array];
    NSMutableDictionary *columnDic = [NSMutableDictionary dictionary];
    NSMutableArray *msgColumnArr = [NSMutableArray array];
    NSMutableDictionary *msgColumnDic = [NSMutableDictionary dictionary];
    if ([self openDBConnection]) {
        NSString *selectCmd = @"PRAGMA table_info (parts)";
        FMResultSet *rs = [_fmDB executeQuery:selectCmd];
        while ([rs next]) {
            int cid = [rs intForColumn:@"cid"];
            NSString *name = [rs stringForColumn:@"name"];
            if ([name isEqualToString:@"text"] || [name isEqualToString:@"timestamp"]) {
                [columnArr addObject:[NSNumber numberWithInt:cid]];
            }
            if (![IMBHelper stringIsNilOrEmpty:name]) {
                [columnDic setValue:name forKey:[NSString stringWithFormat:@"column-%d",cid]];
            }
        }
        [rs close];
        rs = nil;
        
        selectCmd = @"PRAGMA table_info (messages)";
        rs = [_fmDB executeQuery:selectCmd];
        while ([rs next]) {
            int cid = [rs intForColumn:@"cid"];
            NSString *name = [rs stringForColumn:@"name"];
            if ([name isEqualToString:@"received_timestamp"] || [name isEqualToString:@"message_status"]) {
                [msgColumnArr addObject:[NSNumber numberWithInt:cid]];
            }
            if (![IMBHelper stringIsNilOrEmpty:name]) {
                [msgColumnDic setValue:name forKey:[NSString stringWithFormat:@"column-%d",cid]];
            }
        }
        [rs close];
        rs = nil;
        
        [self closeDBConnection];
    }
    [_loghandle writeInfoLog:@"Message queryGoogleSMSDeleteContent End"];
}

- (void)sortResultArray {
    if (_reslutEntity.reslutArray.count > 0) {
        NSMutableArray *resArray = [NSMutableArray arrayWithArray:_reslutEntity.reslutArray];
        for (IMBThreadsEntity *threadEntity in resArray) {
            if (threadEntity.messageList.count > 0) {
                @autoreleasepool {
                    NSArray *sortedArray = nil;
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
                    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
                    sortedArray = [threadEntity.messageList sortedArrayUsingComparator:^(id obj1, id obj2){
                        IMBADMessageEntity *msg1 = (IMBADMessageEntity*)obj1;
                        IMBADMessageEntity *msg2 = (IMBADMessageEntity*)obj2;
                        if (msg1.sortDate < msg2.sortDate)
                            return NSOrderedAscending;
                        else if (msg1.sortDate > msg2.sortDate)
                            return NSOrderedDescending;
                        else
                            return NSOrderedSame;
                    }];
                    
                    [threadEntity.messageList removeAllObjects];
                    [threadEntity.messageList addObjectsFromArray:sortedArray];
                    [dateFormatter release];
                    dateFormatter = nil;
                }
                IMBADMessageEntity *entity = [threadEntity.messageList objectAtIndex:threadEntity.messageList.count -1];
                threadEntity.date = entity.sortDate;
                if (threadEntity.date <= 0) {
                    threadEntity.date = [[NSDate date] timeIntervalSince1970]*1000;
                    threadEntity.lastMsgTime = [IMBHelper longToDateStringFrom1970:threadEntity.date/1000 withMode:1];
                    threadEntity.sortStr = [self sortDateStr:threadEntity.date/1000 withMode:1];
                }else {
                    if (threadEntity.date > [[NSDate date] timeIntervalSince1970]*1000) {
                        threadEntity.lastMsgTime = [IMBHelper longToDateStringFrom1904:(long)threadEntity.date/1000 withMode:1];
                        threadEntity.sortStr = [self sortDateStr:threadEntity.date/1000 withMode:3];
                    }else {
                        if (threadEntity.date > [[NSDate date] timeIntervalSinceDate:[IMBHelper dateFromString2001]]*1000) {
                            threadEntity.lastMsgTime = [IMBHelper longToDateStringFrom1970:(long)threadEntity.date/1000 withMode:1];
                            threadEntity.sortStr = [self sortDateStr:threadEntity.date/1000 withMode:1];
                        }else {
                            threadEntity.lastMsgTime = [IMBHelper longToDateString:(long)threadEntity.date/1000 withMode:1];
                            threadEntity.sortStr = [self sortDateStr:threadEntity.date/1000 withMode:2];
                        }
                    }
                }
                if (entity.sortDate <= 0) {
                    entity.sortDate = [[NSDate date] timeIntervalSince1970]*1000;
                }

                //取msg最后的消息
                IMBADMessageEntity *msgEntity = [threadEntity.messageList lastObject];
                if (msgEntity.smsType == 0) {
                    threadEntity.snippet = msgEntity.body;
                }else {
                    if (msgEntity.partList != nil && msgEntity.partList.count > 0) {
                        for (IMBSMSPartEntity *partEntity in msgEntity.partList) {
                            if (![IMBHelper stringIsNilOrEmpty:partEntity.text] && ![partEntity.ct hasPrefix:@"application/"]) {
                                threadEntity.snippet = partEntity.text;
                                break;
                            }
                        }
                        if ([IMBHelper stringIsNilOrEmpty:threadEntity.snippet]) {
                            for (IMBSMSPartEntity *partEntity in msgEntity.partList) {
                                if (![partEntity.ct hasPrefix:@"application/"]) {
                                    if ([partEntity.ct hasPrefix:@"image/"]) {
                                        threadEntity.snippet = CustomLocalizedString(@"MSG_Last_Photo", nil);
                                        break;
                                    }else if ([partEntity.ct hasPrefix:@"audio/"]) {
                                        threadEntity.snippet = CustomLocalizedString(@"MSG_Last_Voice", nil);
                                        break;
                                    }else if ([partEntity.ct hasPrefix:@"video/"]) {
                                        threadEntity.snippet = CustomLocalizedString(@"MSG_Last_Video", nil);
                                        break;
                                    }else {
                                        threadEntity.snippet = CustomLocalizedString(@"MSG_Last_Contact", nil);
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (threadEntity.isDeleted) {
                [_reslutEntity.reslutArray removeObject:threadEntity];
                if (_reslutEntity.reslutArray.count > 0) {
                    [_reslutEntity.reslutArray insertObject:threadEntity atIndex:0];
                }else {
                    [_reslutEntity.reslutArray addObject:threadEntity];
                }
            }
            if ([IMBHelper stringIsNilOrEmpty:threadEntity.threadsname]) {
                threadEntity.threadsname = [NSString stringWithFormat:@"%lld",threadEntity.date];
            }
            threadEntity.sortNameStr = [StringHelper getSortString:threadEntity.threadsname];
        }
    }
}

//时间排序字符串，不要修改日期格式
- (NSString *)sortDateStr:(long long)timeStamp withMode:(int)mode {
    NSString *returnString = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *originDate = [dateFormatter dateFromString:@"1970-01-01 00:00:00"];
    if (mode == 1) {//1970
        originDate = [dateFormatter dateFromString:@"1970-01-01 00:00:00"];
    }else if (mode == 2) {//2001
        originDate = [dateFormatter dateFromString:@"2001-01-01 00:00:00"];
    }else if (mode == 3) {//1904
        originDate = [dateFormatter dateFromString:@"1904-01-01 00:00:00"];
    }
    if(originDate == nil || originDate == NULL) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        if (mode == 1) {//1970
            originDate = [dateFormatter dateFromString:@"1970-01-01 00:00:00"];
        }else if (mode == 2) {//2001
            originDate = [dateFormatter dateFromString:@"2001-01-01 00:00:00"];
        }else if (mode == 3) {//1904
            originDate = [dateFormatter dateFromString:@"1904-01-01 00:00:00"];
        }
    }
    
    NSDate *date = [NSDate dateWithTimeInterval:(double)timeStamp sinceDate:originDate];
    returnString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return returnString;
}

- (int)exportContent:(NSString *)targetPath ContentList:(NSArray *)exportArr exportType:(NSString *)type
{
    [_loghandle writeInfoLog:@"MessageExport DoProgress enter"];
    int result = 0;
    if ([IMBFileHelper stringIsNilOrEmpty:targetPath]) {
        return -2;
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"MenuItem_id_76", nil)];
    }
    _currCount = 0;
    _currSize = 0;
    _successCount = 0;
    _failedCount = 0;
    _totalCount = 0;
    _totalCount = 0;
    for (IMBThreadsEntity *entity in exportArr) {
        _totalCount += entity.messageList.count;
    }
    if ([_transDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transDelegate transferPrepareFileEnd];
    }
    if ([type isEqualToString:@"pdf"]) {
        [self printMessageToPdf:targetPath printDataArray:exportArr];
    }else if ([type isEqualToString:@"html"]) {
        [self checkAndCopyHtmlImage:targetPath];
        [self writeMessageToPageTitle:exportArr exportPath:targetPath];
    }else if ([type isEqualToString:@"txt"]){
        [self messageExportByTXT:targetPath DataArray:exportArr];
    }
    if ([_transDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transDelegate transferComplete:_successCount TotalCount:_totalCount];
    }
    [_loghandle writeInfoLog:@"MessageExport DoProgress Complete"];

    return result;
}

#pragma mark - Text
- (void)messageExportByTXT:(NSString *)savePath  DataArray:(NSArray *)dataArray
{
    if (dataArray.count>0) {
        NSString *exPath = nil;
        NSString *attachmentPath = [savePath stringByAppendingPathComponent:@"Attachment"];
        if ([_fileManager fileExistsAtPath:attachmentPath]) {
            attachmentPath = [TempHelper getFolderPathAlias:attachmentPath];
        }
        [_fileManager createDirectoryAtPath:attachmentPath withIntermediateDirectories:YES attributes:nil error:nil];
        for (IMBThreadsEntity *item in dataArray ) {
            @autoreleasepool {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                
                if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transDelegate transferFile:[item threadsname]];
                }
                if ([IMBFileHelper stringIsNilOrEmpty:item.threadsname]) {
                    item.threadsname = CustomLocalizedString(@"Common_id_10", nil);
                }
                exPath = [savePath stringByAppendingPathComponent:[item.threadsname stringByAppendingString:@".txt"]];
                if ([_fileManager fileExistsAtPath:exPath]) {
                    exPath = [IMBFileHelper getFilePathAlias:exPath];
                }
                [_fileManager createFileAtPath:exPath contents:nil attributes:nil];
                NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exPath];
                NSString *conString = [self eachMessageInfoByTXT:item withFileHandle:handle AttachmentPath:attachmentPath];
                NSData *retData = [conString dataUsingEncoding:NSUTF8StringEncoding];
                [handle writeData:retData];
                
                [handle closeFile];
            }
        }
    }
}

- (NSString *)eachMessageInfoByTXT:(IMBThreadsEntity *)item withFileHandle:(NSFileHandle *)handle AttachmentPath:(NSString *)attachmentPath{
    NSString *itemString = @"";
    if (item != nil) {
        if (![IMBFileHelper stringIsNilOrEmpty:item.threadsname]) {
            itemString = [[itemString stringByAppendingString:item.threadsname] stringByAppendingString:@":"];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@":"];
        }
        for (NSString *address in item.recipients) {
            itemString = [[itemString stringByAppendingString:address] stringByAppendingString:@"\r"];
        }
        itemString = [itemString stringByAppendingString:@"\n"];
        
        itemString = [itemString stringByAppendingString:@"------------------------------------------------------------------------------------------\r\n"];
        
        NSString *toobStr = [[[[[CustomLocalizedString(@"List_Header_id_Date", nil) stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"List_Header_id_Type", nil)] stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"MenuItem_id_76", nil)]  stringByAppendingString:@"\r\n"];
        itemString = [itemString stringByAppendingString:toobStr];
        if (item.messageList.count>0) {
            int i = 0;
            for (IMBADMessageEntity *msgItem in item.messageList) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                i ++;
                _successCount ++;
                _currCount++;
                float progress = (((float)_currCount / _totalCount) * 100);
                if ([_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_transDelegate transferProgress:progress];
                }
                if (i > 1000) {
                    @autoreleasepool {
                        NSData *data = [itemString dataUsingEncoding:NSUTF8StringEncoding];
                        [handle writeData:data];
                        itemString = @"";
                        i = 0;
                    }
                }
                if (msgItem.date != 0) {
                    NSString *dateStr = nil;
                    if ([IMBHelper getDateLength:msgItem.date] <= 10) {
                        NSDate *date = [DateHelper dateFrom1970:msgItem.date];
                        NSDateFormatter *df=[[NSDateFormatter alloc] init];
                        [df setDateFormat:@"EEEE,MMM dd,yyyy,HH:mm"];
                        dateStr = [df stringFromDate:date];
                        [df release];
                    }else{
                        NSDate *date = [DateHelper dateFrom1970:msgItem.date/1000.0];
                        NSDateFormatter *df=[[NSDateFormatter alloc] init];
                        [df setDateFormat:@"EEEE,MMM dd,yyyy,HH:mm"];
                        dateStr = [df stringFromDate:date];
                        [df release];
                    }
                    itemString = [[itemString stringByAppendingString:dateStr] stringByAppendingString:@" \t "];
                }else {
                    itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
                }
                
                BOOL isSent = YES;
                if (msgItem.smsType == 0) {
                    if (msgItem.type == 1) {
                        isSent = NO;
                    }
                    if (isSent == YES) {
                        itemString = [[itemString stringByAppendingString:CustomLocalizedString(@"message_id_2", nil)] stringByAppendingString:@" \t "];
                    }else {
                        itemString = [[itemString stringByAppendingString:CustomLocalizedString(@"message_id_1", nil)] stringByAppendingString:@" \t "];
                    }
                    if (![IMBFileHelper stringIsNilOrEmpty:msgItem.body]) {
                        itemString = [[itemString stringByAppendingString:[self covertSpecialChar:msgItem.body]]stringByAppendingString:@" \t "];
                    }else {
                        itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
                    }
                }else if (msgItem.smsType == 1){
                    
                    if (msgItem.type == 1) {
                        isSent = NO;
                    }
                    if (isSent == YES) {
                        itemString = [[itemString stringByAppendingString:CustomLocalizedString(@"message_id_2", nil)] stringByAppendingString:@" \t "];
                    }else {
                        itemString = [[itemString stringByAppendingString:CustomLocalizedString(@"message_id_1", nil)] stringByAppendingString:@" \t "];
                    }
                    for (IMBSMSPartEntity *part in msgItem.partList) {
                        if ([part.ct hasPrefix:@"text"]) {
                            if (![IMBFileHelper stringIsNilOrEmpty:msgItem.body]) {
                                itemString = [[itemString stringByAppendingString:[self covertSpecialChar:part.text]]stringByAppendingString:@" \t "];
                            }else {
                                itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
                            }
                        }else if ([part.ct hasPrefix:@"image"]||[part.ct hasPrefix:@"audio"]||[part.ct hasPrefix:@"video"]){
                            //开始拷贝附件
                            if ([_fileManager fileExistsAtPath:part.localPath]) {
                                NSString *fileName = [part.localPath lastPathComponent];
                                NSString *attachPath = [attachmentPath stringByAppendingPathComponent:fileName];
                                if ([_fileManager fileExistsAtPath:attachPath]) {
                                    attachPath = [IMBFileHelper getFilePathAlias:attachPath];
                                }
                                [_fileManager copyItemAtPath:part.localPath toPath:attachPath error:nil];
                            }else{
                                [self getAttachmentContent:part withPath:attachmentPath];
                            }
                        }
                    }
                }
                itemString = [itemString stringByAppendingString:@"\r\n"];
            }
        }
    }
    return itemString;
}

- (NSString *)covertSpecialChar:(NSString *)str {
    if (![IMBFileHelper stringIsNilOrEmpty:str]) {
        NSString *string = [str stringByReplacingOccurrencesOfString:@"￼" withString:@"<&c;a&>"];
        return string;
    }else {
        return str;
    }
}

#pragma mark - export pdf
- (void)printMessageToPdf:(NSString *)savePath  printDataArray:(NSArray *)dataArray
{/*
    [[IMBLogManager singleton] writeInfoLog:@"message export pdf"];
    _currCount = 0;
    _successCount = 0;
    _totalCount = dataArray.count;
    for (int i = 0;i<_totalCount;i++) {
        @autoreleasepool {
            if (_isStop) {
                break;
            }
            NSView *msgContentView = nil;
//            IMBMsgContentView *msgContentView = [[IMBMsgContentView alloc] initWithFrame:NSMakeRect(0, 0,630, 527)];
//            [msgContentView setFrame:NSMakeRect(1, 1, 630, 527)];
            IMBThreadsEntity *chat = [dataArray objectAtIndex:i];
//            [msgContentView setSmsEntity:entity];
//            [msgContentView setMsgArray:entity.msgModelList];
            [_loghandle writeInfoLog:[NSString stringWithFormat:@"message pdf %@",chat.threadsname]];
            
            for (IMBMessageEntity *message in chat.messageList ) {
                if (message.smsType == 1) {
                    //彩信
                    for (IMBSMSPartEntity *part in message) {
                        if ([part.ct hasPrefix:@"image"]||[part.ct hasPrefix:@"audio"]||[part.ct hasPrefix:@"video"]) {
                            NSString *attachDir = [savePath stringByAppendingPathComponent:@"Attachments"];
                            if (![_fileManager fileExistsAtPath:attachDir]) {
                                [_fileManager createDirectoryAtPath:attachDir withIntermediateDirectories:NO attributes:nil error:nil];
                            }
                            NSString *contactAttachDir = [attachDir stringByAppendingFormat:@"/%@",chat.threadsname];
                            if (![_fileManager fileExistsAtPath:contactAttachDir]) {
                                [_fileManager createDirectoryAtPath:contactAttachDir withIntermediateDirectories:NO attributes:nil error:nil];
                            }
                            NSString *fileName = [part.localPath lastPathComponent];
                            NSString *attachPath = [contactAttachDir stringByAppendingPathComponent:fileName];
                            if ([_fileManager fileExistsAtPath:attachPath]) {
                                attachPath = [IMBFileHelper getFilePathAlias:attachPath];
                            }
                            [_fileManager copyItemAtPath:part.localPath toPath:attachPath error:nil];
                        }
                    }
                }
            }
            
            //附件
            if (entity.msgModelList != nil && entity.msgModelList.count > 0) {
                //创建attachment文件夹
                NSString *attachDir = [savePath stringByAppendingPathComponent:@"Attachments"];
                if (![fileManager fileExistsAtPath:attachDir]) {
                    [fileManager createDirectoryAtPath:attachDir withIntermediateDirectories:NO attributes:nil error:nil];
                }
                NSString *contactAttachDir = [attachDir stringByAppendingFormat:@"/%@",chat.contactName];
                if (![fileManager fileExistsAtPath:contactAttachDir]) {
                    [fileManager createDirectoryAtPath:contactAttachDir withIntermediateDirectories:NO attributes:nil error:nil];
                }else
                {
                    contactAttachDir = [StringHelper createDifferentfileName:contactAttachDir];
                }
                BOOL hasAttachment = NO;
                for (IMBMessageDataEntity *msgItem in entity.msgModelList) {
                    @autoreleasepool {
                        if (msgItem.isAttachments == YES) {
                            if (msgItem.attachmentList != nil && msgItem.attachmentList.count > 0) {
                                hasAttachment = YES;
                                [self exportAttachmentsToLacol:msgItem.attachmentList attachSavePath:contactAttachDir];
                            }
                        }
                    }
                }
                if (!hasAttachment) {
                    [_fileManager removeItemAtPath:contactAttachDir error:nil];
                }
            }
            
            _currCount += 1;
            
            NSString *pdfFilePath = [savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",entity.threadsname]];
            if ([_fileManager fileExistsAtPath:pdfFilePath]) {
                pdfFilePath = [StringHelper createDifferentfileName:pdfFilePath];
            }
            NSPrintInfo *sharedInfo = nil;
            NSMutableDictionary *sharedDict = nil;
            NSPrintInfo *printInfo = nil;
            NSMutableDictionary *printInfoDict = nil;
            sharedInfo = [NSPrintInfo sharedPrintInfo];
            sharedDict = [sharedInfo dictionary];
            printInfoDict = [NSMutableDictionary dictionaryWithDictionary:
                             sharedDict];
            [printInfoDict setObject:NSPrintSaveJob
                              forKey:NSPrintJobDisposition];
            [printInfoDict setObject:[NSDate date] forKey:NSPrintTime];
            [printInfoDict setObject:pdfFilePath forKey:NSPrintSavePath];
            printInfo = [[NSPrintInfo alloc] initWithDictionary: printInfoDict];
            [printInfo setHorizontalPagination: NSFitPagination];
            [printInfo setVerticalPagination: NSAutoPagination];
            [printInfo setVerticallyCentered:NO];
            [printInfo setPaperSize:NSMakeSize(700, 527)];
            [printInfo setLeftMargin:20];
            [printInfo setRightMargin:20];
            [printInfo setTopMargin:20];
            [printInfo setBottomMargin:20];
            NSPrintOperation *printOp = [NSPrintOperation printOperationWithView:msgContentView
                                                                       printInfo:printInfo];
            [printOp setShowsPrintPanel:NO];
            [printOp setShowsProgressPanel:NO];
            [printOp runOperation];
            _successCount ++;
            float progress = (((float)_currCount / _totalCount) * 100);
            if ([_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                [_transDelegate transferProgress:progress];
            }
//            if (msgContentView != nil) {
//                [msgContentView release];
//                msgContentView = nil;
//            }
            if (printInfo != nil) {
                [printInfo release];
                printInfo = nil;
            }
        }
    }*/
}

#pragma mark - export HTML
- (void)checkAndCopyHtmlImage:(NSString *)targetPath {
    if (_htmlImgFolderPath != nil) {
        [_htmlImgFolderPath release];
    }
    _htmlImgFolderPath = [[targetPath stringByAppendingPathComponent:@"img"] retain];
    BOOL isDir = NO;
    if ([_fileManager fileExistsAtPath:_htmlImgFolderPath isDirectory:&isDir]) {
        if (!isDir) {
            [_fileManager removeItemAtPath:_htmlImgFolderPath error:nil];
            [_fileManager createDirectoryAtPath:_htmlImgFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    } else {
        [_fileManager createDirectoryAtPath:_htmlImgFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *imageFilePath = nil;
    NSString *imgName = nil;
    NSString *imgExt = @"png";
    imgName = @"left_bottom";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"left_bottom2";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"left_bottom3";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"left_top";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"left_top2";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"left_top3";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"right_bottom";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"right_bottom2";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"right_bottom3";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"right_mid";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"right_mid2";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"right_mid3";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"right_top";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"right_top2";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"right_top3";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    return;
}

- (void)writeMessageToPageTitle:(NSArray *)exportArray exportPath:(NSString *)exportPath{
    [_loghandle writeInfoLog:@"MessageExportToHtm Begin"];
    if (exportArray.count > 0) {
        for (IMBThreadsEntity *entity in exportArray) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            if ([IMBFileHelper stringIsNilOrEmpty:entity.threadsname]) {
                entity.threadsname = CustomLocalizedString(@"Common_id_10", nil);
            }
            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transDelegate transferFile:entity.threadsname];
            }
            NSString *exportName = [NSString stringWithFormat:@"%@.html",entity.threadsname];
            [self writeToMsgFileWithPageTitle:exportName exportPath:exportPath Entity:entity];
        }
    }
    [_loghandle writeInfoLog:@"MessageExportToHtm End"];
}

- (NSData*)createHtmHeader:(NSString *)title {
     NSString *headerContent = [NSString stringWithFormat:@"<head><meta charset=\"utf-8\" /><title>%@</title><style type=\"text/css\">*{margin: 0;padding: 0;font: normal 12px \"Helvetica Neue\" , \"Lucida Sans Unicode\" , \"Arial\";color: #333;}body{background: #eee;}img{border: none;}.wrap{width: 640px;margin: 0 auto;}.top{width: 100%%;height: 42px;background: #d5e7fb;text-align: center;font-size: 18px;color: #000;font-weight: bolder;line-height: 42px;}.cont{background: #fff;padding: 18px;min-height: 300px;float: left;}.cont h1{width: 600px;height: auto;font-size: 20px;color: #000;border-bottom: 1px solid #e5e5e5;}.date{width: 110px;font-size: 14px;color: #919191;margin: 20px 0 0 250px;}.imessage{font-size: 14px;color: #919191;text-align: center;margin: 20px 0 -10px 0;}.right{float: right;}.left{float: left;}.left_top{width: 14px;background: url(img/left_top.png) no-repeat;}.right_top{width: 14px;background: url(img/right_top.png) no-repeat;}.right_mid{background: url(img/right_mid.png) repeat-y;}.left_bottom{background: url(img/left_bottom.png) no-repeat;}.right_bottom{width: 20px;height: 14px;background: url(img/right_bottom.png) no-repeat;}.block_table{width: 604px;float: left;margin: 12px 0 0 0;}.block_table tr td{max-width: 302px; word-wrap: break-word;}.left_top2{width: 22px;background: url(img/left_top2.png) no-repeat right;}.right_top2{width: 14px;height: 14px;background: url(img/right_top2.png) no-repeat;}.right_mid2{background: url(img/right_mid2.png) repeat-y right;}.left_bottom2{background: url(img/left_bottom2.png) no-repeat left;width: 22px;height: 14px;}.right_bottom2{background: url(img/right_bottom2.png) no-repeat;}.left_top3{width: 14px;background: url(img/left_top3.png) no-repeat;}.right_top3{width: 14px;background: url(img/right_top3.png) no-repeat;}.right_mid3{background: url(img/right_mid3.png) repeat-y;}.left_bottom3{background: url(img/left_bottom3.png) no-repeat;}.right_bottom3{width: 20px;height: 14px;background: url(img/right_bottom3.png) no-repeat;}.bg_color{background: #20a8fe;color: #fff;}.bg_color2{background: #E1E6EB;}.bg_color3{background: #D8E9FC;color: #000;}.right tr td a img { max-width:302px; float:right;}.left tr td a img { max-width:302px; float:left;}</style></head>", title];
    return [headerContent dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData*)createHtmBody:(id)entity {
    IMBThreadsEntity *chat = (IMBThreadsEntity *)entity;
    NSData *retData = nil;
    NSMutableString *bodyContent = [[NSMutableString alloc] init];
    [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"wrap\"><div class=\"top\">%@</div><div class=\"cont\">", CustomLocalizedString(@"MenuItem_id_76", nil)]];
    if (chat != nil) {
        [bodyContent appendString:[NSString stringWithFormat:@"<h1>%@</h1>", chat.threadsname]];
        if (chat.messageList.count > 0) {
            NSArray *msgArray = chat.messageList;
            for (IMBADMessageEntity *msgItem in msgArray) {
                @autoreleasepool {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        break;
                    }
                    _successCount ++;
                    _currCount++;
                    float progress = (((float)_currCount / _totalCount) * 100);
                    if ([_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_transDelegate transferProgress:progress];
                    }
                    NSString *dateStr = nil;
                    if ([IMBHelper getDateLength:msgItem.date] <= 10) {
                        NSDate *date = [DateHelper dateFrom1970:msgItem.date];
                        NSDateFormatter *df=[[NSDateFormatter alloc] init];
                        [df setDateFormat:@"EEEE,MMM dd,yyyy,HH:mm"];
                        dateStr = [df stringFromDate:date];
                        [df release];
                    }else{
                        NSDate *date = [DateHelper dateFrom1970:msgItem.date/1000.0];
                        NSDateFormatter *df=[[NSDateFormatter alloc] init];
                        [df setDateFormat:@"EEEE,MMM dd,yyyy,HH:mm"];
                        dateStr = [df stringFromDate:date];
                        [df release];
                    }
                    [bodyContent appendString:[NSString stringWithFormat:@"<p class=\"date\">%@</p>", dateStr]];
                    if (_isStop) {
                        break;
                    }
                    BOOL isSent = YES;
                    if (msgItem.smsType == 0) {
                        //短信
                        if (msgItem.type == 1) {
                            isSent = NO;
                        }
                        if (isSent) {
                            // 蓝色 Message
                            [bodyContent appendString:@"<div class=\"cont_block\">"];
                            [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"block_table\">"]];
                            [bodyContent appendString:@"<table class=\"right\" width=\"auto\" height=\"auto\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td class=\"left_top3\"></td><td width=\"auto\" class=\"bg_color3\" height=\"12\"></td><td class=\"right_top3\"></td></tr>"];
                            [bodyContent appendString:@"<tr><td height=\"auto\"  class=\"bg_color3\" width=\"14\">&nbsp;</td><td class=\"bg_color3\">"];
                            
                            [bodyContent appendString:[NSString stringWithFormat:@"%@", msgItem.body]];
                            
                            [bodyContent appendString:@"</td><td class=\"right_mid3\"></td></tr>"];
                            [bodyContent appendString:@"<tr><td class=\"left_bottom3\"></td><td  class=\"bg_color3\"></td><td class=\"right_bottom3\"></td></tr></table>"];
                            [bodyContent appendString:@"</div>"];
                        } else {
                            // 灰色
                            [bodyContent appendString:@"<div class=\"cont_block\">"];
                            [bodyContent appendString:@"<div class=\"block_table\">"];
                            [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"block_table\">"]];
                            [bodyContent appendString:@"<table class=\"left\" width=\"auto\" height=\"auto\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td class=\"left_top2\"></td><td width=\"auto\" class=\"bg_color2\" height=\"12\"></td><td class=\"right_top2\"></td></tr>"];
                            [bodyContent appendString:@"<tr><td height=\"auto\"  class=\"right_mid2\"></td><td class=\"bg_color2\">"];
                            
                            [bodyContent appendString:[NSString stringWithFormat:@"%@", msgItem.body]];
                            
                            [bodyContent appendString:@"</td><td class=\"bg_color2\" width=\"14\"></td></tr>"];
                            [bodyContent appendString:@"<tr><td class=\"left_bottom2\"></td><td  class=\"bg_color2\"></td><td class=\"right_bottom2\"></td></tr></table>"];
                            [bodyContent appendString:@"</div>"];
                        }

                    }else if (msgItem.smsType == 1){
                        //todo 需要重新写彩信的html布局
                        //拷贝附件
                        if (msgItem.type == 1) {
                            isSent = NO;
                        }
                        if (isSent) {
                            [bodyContent appendString:@"<div class=\"cont_block\">"];
                            [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"block_table\">"]];
                            [bodyContent appendString:@"<table class=\"right\" width=\"auto\" height=\"auto\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td class=\"left_top3\"></td><td width=\"auto\" class=\"bg_color3\" height=\"12\"></td><td class=\"right_top3\"></td></tr>"];
                            [bodyContent appendString:@"<tr><td height=\"auto\"  class=\"bg_color3\" width=\"14\">&nbsp;</td><td class=\"bg_color3\">"];
                            for (IMBSMSPartEntity *entity in msgItem.partList) {
                                if ([entity.ct hasPrefix:@"image"]||[entity.ct hasPrefix:@"audio"]||[entity.ct hasPrefix:@"video"]) {
                                    if ([_fileManager fileExistsAtPath:entity.localPath]) {
                                        NSString *fileName = [entity.localPath lastPathComponent];
                                        NSString *attachPath = [_htmlImgFolderPath stringByAppendingPathComponent:fileName];
                                        if ([_fileManager fileExistsAtPath:attachPath]) {
                                            attachPath = [IMBFileHelper getFilePathAlias:attachPath];
                                        }
                                        [_fileManager copyItemAtPath:entity.localPath toPath:attachPath error:nil];
                                        [bodyContent appendString:[NSString stringWithFormat:@"<a href=\"img/%1$@\" target=\"_blank\"><img src=\"img/%1$@\" /></a>", [attachPath lastPathComponent]]];
                                    }else{
                                        [self getAttachmentContent:entity withPath:_htmlImgFolderPath];
                                        [bodyContent appendString:[NSString stringWithFormat:@"<a href=\"img/%1$@\" target=\"_blank\"><img src=\"img/%1$@\" /></a>", [entity.localPath lastPathComponent]]];
                                        
                                    }
                                }else if ([entity.ct hasPrefix:@"text"]){
                                    [bodyContent appendString:[NSString stringWithFormat:@"%@", entity.text]];
                                }
                            }
                            [bodyContent appendString:@"</td><td class=\"right_mid3\"></td></tr>"];
                            [bodyContent appendString:@"<tr><td class=\"left_bottom3\"></td><td  class=\"bg_color3\"></td><td class=\"right_bottom3\"></td></tr></table>"];
                            [bodyContent appendString:@"</div>"];
                        } else {
                            //
                            [bodyContent appendString:@"<div class=\"cont_block\">"];
                            [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"block_table\">"]];
                            [bodyContent appendString:@"<table class=\"left\" width=\"auto\" height=\"auto\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td class=\"left_top2\"></td><td width=\"auto\" class=\"bg_color2\" height=\"12\"></td><td class=\"right_top2\"></td></tr>"];
                            [bodyContent appendString:@"<tr><td height=\"auto\"  class=\"right_mid2\"></td><td class=\"bg_color2\">"];
                            for (IMBSMSPartEntity *entity in msgItem.partList) {
                                if ([entity.ct hasPrefix:@"image"]||[entity.ct hasPrefix:@"audio"]||[entity.ct hasPrefix:@"video"]) {
                                    if ([_fileManager fileExistsAtPath:entity.localPath]) {
                                        NSString *fileName = [entity.localPath lastPathComponent];
                                        NSString *attachPath = [_htmlImgFolderPath stringByAppendingPathComponent:fileName];
                                        if ([_fileManager fileExistsAtPath:attachPath]) {
                                            attachPath = [IMBFileHelper getFilePathAlias:attachPath];
                                        }
                                        [_fileManager copyItemAtPath:entity.localPath toPath:attachPath error:nil];
                                        [bodyContent appendString:[NSString stringWithFormat:@"<a href=\"img/%1$@\" target=\"_blank\"><img src=\"img/%1$@\" /></a>", [attachPath lastPathComponent]]];
                                    }else{
                                        [self getAttachmentContent:entity withPath:_htmlImgFolderPath];
                                        [bodyContent appendString:[NSString stringWithFormat:@"<a href=\"img/%1$@\" target=\"_blank\"><img src=\"img/%1$@\" /></a>", [entity.localPath lastPathComponent]]];
                                        
                                    }
                                }else if ([entity.ct hasPrefix:@"text"]){
                                    [bodyContent appendString:[NSString stringWithFormat:@"%@", entity.text]];
                                }
                            }
                            [bodyContent appendString:@"</td><td class=\"bg_color2\" width=\"14\"></td></tr>"];
                            [bodyContent appendString:@"<tr><td class=\"left_bottom2\"></td><td class=\"bg_color2\"></td><td class=\"right_bottom2\"></td></tr></table>"];
                            [bodyContent appendString:@"</div>"];
                        }
                    }
                }
            }
        }
    }
    [bodyContent appendString:@"</div></div></body>"];
    retData = [bodyContent dataUsingEncoding:NSUTF8StringEncoding];
    [bodyContent release];
    bodyContent = nil;
    return retData;
}

- (NSData*)createHtmFooter {
    NSString *footerContent = @"";
    return [footerContent dataUsingEncoding:NSUTF8StringEncoding];
}

- (int)exportMessageAttachment:(NSString *)targetPath exportArray:(NSArray *)exportArray {
    [_loghandle writeInfoLog:@"SMS exportMessageAttachment Begin"];
    int result = 0;
    if ([IMBFileHelper stringIsNilOrEmpty:targetPath]) {
        return -2;
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"MenuItem_id_56", nil)];
    }
    _currCount = 0;
    _currSize = 0;
    _successCount = 0;
    _failedCount = 0;
    _totalCount = (int)exportArray.count;
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transDelegate transferPrepareFileEnd];
    }
    if (!_isStop) {
        for (IMBSMSPartEntity *entity in exportArray) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transDelegate transferFile:entity.cl];
            }
            _currCount ++;
            BOOL isSuccess = NO;
            if ([_fileManager fileExistsAtPath:entity.localPath]) {
                NSString *fileName = @"";
                if (![IMBHelper stringIsNilOrEmpty:entity.cl]) {
                    fileName = entity.cl;
                }
                NSString *attachPath = [targetPath stringByAppendingPathComponent:fileName];
                if ([_fileManager fileExistsAtPath:attachPath]) {
                    attachPath = [IMBFileHelper getFilePathAlias:attachPath];
                }
                isSuccess = [_fileManager copyItemAtPath:entity.localPath toPath:attachPath error:nil];
            }else{
                isSuccess = [self getAttachmentContent:entity withPath:targetPath];
            }
            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                float progress = (float)_currCount / _totalCount * 100;
                NSLog(@"progress:%f",progress);
                [_transDelegate transferProgress:progress];
            }
            if (isSuccess) {
                _successCount ++;
            }else {
                _failedCount ++;
            }
        }
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transDelegate transferComplete:_successCount TotalCount:_totalCount];
    }
    [_loghandle writeInfoLog:@"SMS exportMessageAttachment End"];
    return result;
}

#pragma mark - import
- (int)importContent:(NSArray *)importArr {
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"MenuItem_id_76", nil)];
    }
    int result = 0;
    _currCount = 0;
    _successCount = 0;
    _failedCount = 0;
    _totalCount = (int)importArr.count;
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transDelegate transferPrepareFileEnd];
    }
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        for (IMBThreadsEntity *entity in importArr) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }

            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transDelegate transferFile:[entity threadsname]];
            }
            _currCount ++;
            BOOL isSuccess = NO;
            NSDictionary *entityDic = [entity objectToDictionary:entity];
            NSString *entityJson = [IMBFileHelper dictionaryToJson:entityDic];
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:entityJson, @"ADDSMS", nil];
            NSString *jsonStr = [self createParamsjJsonCommand:SMS Operate:IMPORT ParamDic:paramDic];
            if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
                isSuccess = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    [msg release];
                    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                        float progress = (float)_currCount / _totalCount * 100;
                        [_transDelegate transferProgress:progress];
                    }
                }];
                if (!isSuccess) {
                    NSLog(@"import launch request failed");
                }
            }else {
                NSLog(@"create json failed");
            }
            if (isSuccess) {
                _successCount ++;
            }else {
                _failedCount ++;
            }
        }
        if ([_version isVersionMajor:@"4.4"]) {
            //更改回默认短信App
            NSString *setJson = [self createParamsjJsonCommand:SMS Operate:SETSMSAPP ParamDic:[NSDictionary dictionary]];
            if (![IMBFileHelper stringIsNilOrEmpty:setJson]) {
                [coreSocket launchRequestContent:setJson FinishBlock:^(NSData *data) {
                    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"msg:%@",msg);
                    [msg release];
                }];
            }
            //通知到界面，然后弹出窗口，提示用户到设备上去操作；
            if ([_transDelegate respondsToSelector:@selector(transferOccurError:)]) {
                [_transDelegate transferOccurError:@"defaultsms"];
            }
        }
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
        [coreSocket release];
    }else {
        result = -3;
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transDelegate transferComplete:_successCount TotalCount:_totalCount];
    }
    return result;
}

- (int)deleteContent:(NSArray *)deleteArr {
    int result = 0;
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:@"delete content start"];
    }
    _currCount = 0;
    _successCount = 0;
    _failedCount = 0;
    _totalCount = (int)deleteArr.count;
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transDelegate transferPrepareFileEnd];
    }
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
//        for (IMBContactEntity *entity in deleteArr) {
//            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
//                [_transDelegate transferFile:entity.contactName];
//            }
//            _currCount ++;
//            BOOL isSuccess = NO;
//            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",entity.contactID], @"contactID", nil];
//            NSString *jsonStr = [self createParamsjJsonCommand:CONTACT Operate:DELETE ParamDic:paramDic];
//            if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
//                isSuccess = [coreSocket launchDeleteRequestContent:jsonStr FinishBlock:^(NSData *data) {
//                    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                    NSLog(@"delete msg:%@",msg);
//                    [msg release];
//                }];
//                if (!isSuccess){
//                    result = -1;
//                    NSLog(@"delete launch request failed");
//                }
//            }else {
//                result = -2;
//                NSLog(@"create json failed");
//            }
//            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferProgress:)]) {
//                float progress = (float)_currCount / _totalCount * 100;
//                NSLog(@"progress:%f",progress);
//                [_transDelegate transferProgress:progress];
//            }
//            if (isSuccess) {
//                _successCount ++;
//            }else {
//                _failedCount ++;
//            }
//        }
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
        [coreSocket release];
    }else {
        result = -3;
        //关闭连接并释放端口
        [IMBSocketFactory closeDisposeSocket:scoket serialNumber:_serialNumber];
        [scoket release];
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transDelegate transferComplete:_successCount TotalCount:_totalCount];
    }
    return result;
}

@end
