//
//  IMBADCallHistory.m
//  PhoneRescue_Android
//
//  Created by iMobie on 4/5/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBADCallHistory.h"

@implementation IMBADCallHistory

- (NSString *)getDatabasesPath {
    NSString *backup = [IMBHelper getSerialNumberPath:_serialNumber];
    self.dbPath = [backup stringByAppendingPathComponent:@"calllog.db"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:_dbPath]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *lbDate = [dateFormatter stringFromDate:[NSDate date]];
        NSString *toPath = [backup stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-calllog.db",lbDate]];
        [fm moveItemAtPath:_dbPath toPath:toPath error:nil];
        [dateFormatter release];
    }
    return _dbPath;
}

#pragma mark - Abstract Method
- (int)queryDetailContent {
    [_loghandle writeInfoLog:@"Call History queryDetailContent Begin"];
    int result = 0;
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        NSDictionary *paramDic = [NSDictionary dictionary];
        NSString *jsonStr = [self createParamsjJsonCommand:CALLLOG Operate:QUERY ParamDic:paramDic];
        if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
            ret = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg) {
                    NSArray *msgArr = [IMBFileHelper dictionaryWithJsonString:msg];
                    if (msgArr != nil) {
                        for (NSDictionary *msgDic in msgArr) {
                            IMBADCallHistoryEntity *callHistory = [[IMBADCallHistoryEntity alloc] init];
                            [callHistory dictionaryToObject:msgDic];
                            
                            NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                IMBADCallContactEntity *item = (IMBADCallContactEntity *)evaluatedObject;
                                if ([[item phoneNumber] isEqualToString:callHistory.phoneNumber]) {
                                    return YES;
                                }else {
                                    return NO;
                                }
                            }];
                            NSArray *preArray = [_reslutEntity.reslutArray filteredArrayUsingPredicate:pre];
                            if (preArray != nil && preArray.count > 0) {
                                IMBADCallContactEntity *callContact = [preArray objectAtIndex:0];
                                if (![IMBHelper stringIsNilOrEmpty:callHistory.contactName]) {
                                    callContact.callName = callHistory.contactName;
                                    callContact.sortStr = [StringHelper getSortString:callContact.callName];
                                }
                                callContact.callCount += 1;
                                callContact.selectedCount += 1;
                                _reslutEntity.reslutCount ++;
                                _reslutEntity.selectedCount ++;
                                [callContact.callArray addObject:callHistory];
                            }else {
                                IMBADCallContactEntity *call = [[IMBADCallContactEntity alloc] init];
                                call.callName = callHistory.contactName;
                                call.sortStr = [StringHelper getSortString:call.callName];
                                call.phoneNumber = callHistory.phoneNumber;
                                call.callCount += 1;
                                call.selectedCount += 1;
                                [call.callArray addObject:callHistory];
                                _reslutEntity.reslutCount ++;
                                _reslutEntity.selectedCount ++;
                                _reslutEntity.scanType = ScanCallHistoryFile;
                                [_reslutEntity.reslutArray addObject:call];
                                
                                [call release];
                            }
                            [callHistory release];
                        }
                    }
                }else {
                    NSLog(@"错误");
                    [_loghandle writeInfoLog:@"Call History queryDetailContent Error"];
                }
                [msg release];
            }];
            if (!ret) {
                result = -3;
            }
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
    if (_reslutEntity.reslutArray.count > 0) {
        for (IMBADCallContactEntity *entity in _reslutEntity.reslutArray) {
            if ([IMBHelper stringIsNilOrEmpty:entity.callName]) {
                entity.callName = entity.phoneNumber;
                entity.sortStr = [StringHelper getSortString:entity.callName];
            }
        }
    }

    [_loghandle writeInfoLog:@"Call History queryDetailContent End"];
    return result;
}

/**
 *查询删除数据
 */
- (void)queryDeleteContent {
    [_loghandle writeInfoLog:@"Call History queryDeleteContent Begin"];
    NSMutableArray *columnArr = [NSMutableArray array];
    NSMutableDictionary *columnDic = [NSMutableDictionary dictionary];
    if ([self openDBConnection]) {
        NSString *selectCmd = @"PRAGMA table_info (calls)";
        FMResultSet *rs = [_fmDB executeQuery:selectCmd];
        while ([rs next]) {
            int cid = [rs intForColumn:@"cid"];
            NSString *name = [rs stringForColumn:@"name"];
            if ([name isEqualToString:@"date"] || [name isEqualToString:@"type"]) {
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
    [_loghandle writeInfoLog:@"Call History queryDeleteContent End"];
}

- (int)exportContent:(NSString *)targetPath ContentList:(NSArray *)exportArr exportType:(NSString *)type{
    [_loghandle writeInfoLog:@"CallhistoryExport DoProgress enter"];
    int result = 0;
    if ([IMBFileHelper stringIsNilOrEmpty:targetPath]) {
        return -2;
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"MenuItem_CallLog", nil)];
    }
    _currCount = 0;
    _currSize = 0;
    _successCount = 0;
    _failedCount = 0;
    _totalCount = 0;
    for (IMBADCallContactEntity *entity in exportArr) {
        _totalCount += [entity.callArray count];
    }
    if ([_transDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transDelegate transferPrepareFileEnd];
    }
    
    if ([type isEqualToString:@"txt"]) {
        [self callHistoryExportByTXT:targetPath  exportArray:exportArr];
    }else if ([type isEqualToString:@"html"]) {
        [self writeCallFileToPageTitle:exportArr exportPath:targetPath];
    }
    if ([_transDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transDelegate transferComplete:_successCount TotalCount:_totalCount];
    }
    [_loghandle writeInfoLog:@"CallhistoryExport DoProgress Complete"];
    return result;
}

#pragma mark - export TXT
- (void)callHistoryExportByTXT:(NSString *)exportPath exportArray:(NSArray *)exportArray{
    if (exportArray != nil && exportArray.count > 0) {
        NSString *exPath = [exportPath stringByAppendingPathComponent:[CustomLocalizedString(@"MenuItem_id_18", nil) stringByAppendingString:@".txt"]];
        if ([_fileManager fileExistsAtPath:exPath]) {
            exPath = [IMBFileHelper getFilePathAlias:exPath];
        }
        [_fileManager createFileAtPath:exPath contents:nil attributes:nil];
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exPath];
        NSString *conString = @"";
        for (IMBADCallContactEntity *entity in exportArray) {
            for (IMBADCallHistoryEntity *item in entity.callArray) {

                @autoreleasepool {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        break;
                    }

                    _currCount += 1;
                    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                        [_transDelegate transferFile:item.contactName];
                    }
                    conString = [conString stringByAppendingString:[self eachCallHistoryInfoByTXT:item]];
                    conString = [conString stringByAppendingString:@"\r\n"];
                    NSData *retData = [conString dataUsingEncoding:NSUTF8StringEncoding];
                    [handle writeData:retData];
                    conString= @"";
                    float progress = ((float)_currCount / _totalCount) * 100;
                    if ([_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_transDelegate transferProgress:progress];
                    }
                    _successCount += 1;
                }
            }
        }
        [handle closeFile];
    }
}

- (NSString *)eachCallHistoryInfoByTXT:(IMBADCallHistoryEntity *)item {
    NSString *itemString = @"";
    if (item != nil) {
        if (![IMBFileHelper stringIsNilOrEmpty:item.contactName]) {
            itemString = [[itemString stringByAppendingString:item.contactName] stringByAppendingString:@":"];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@":"];
        }
        
        if (![IMBFileHelper stringIsNilOrEmpty:item.phoneNumber]) {
            itemString = [[itemString stringByAppendingString:item.phoneNumber] stringByAppendingString:@"\r\n"];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@"\r\n"];
        }
        itemString = [itemString stringByAppendingString:@"------------------------------------------------------------------------------------------\r\n"];
        
        NSString *toobStr = [[[[[CustomLocalizedString(@"List_Header_id_Date", nil) stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"List_Header_id_Duration", nil)] stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"List_Header_id_Type", nil)] stringByAppendingString:@"\r\n"];
        itemString = [itemString stringByAppendingString:toobStr];
        if (item.callTime != 0) {
            itemString = [[itemString stringByAppendingString:item.callDateStr] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        if (item.duration != 0) {
            itemString = [[itemString stringByAppendingString:[IMBHelper getTimeAutoShowHourString:item.duration*1000]] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"0"] stringByAppendingString:@" \t "];
        }
        
        if (item.callType == INCOMING_TYPE) {
            itemString = [itemString stringByAppendingString:CustomLocalizedString(@"callhistory_id_4", nil)];
        }else if (item.callType == OUTGOING_TYPE){
            itemString = [itemString stringByAppendingString:CustomLocalizedString(@"callhistory_id_6", nil)];
        }else if (item.callType == MISSED_TYPE){
            itemString = [itemString stringByAppendingString:CustomLocalizedString(@"callhistory_id_3", nil)];
        }else if (item.callType == REJECTED_TYPE){
            itemString = [itemString stringByAppendingString:CustomLocalizedString(@"Analysis_View_MediaData_CallType_10", nil)];
        }else{
             itemString = [itemString stringByAppendingString:CustomLocalizedString(@"Common_id_10", nil)];
        }
        itemString = [itemString stringByAppendingString:@"\r\n"];
        
    }
    return itemString;
}

#pragma mark - export HTML
- (void)writeCallFileToPageTitle:(NSArray *)exportArray exportPath:(NSString *)exportPath{
    [_loghandle writeInfoLog:@"CallExportToHtm Begin"];
    if (exportArray.count > 0) {
        for (IMBADCallContactEntity *entity in exportArray) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            if ([IMBFileHelper stringIsNilOrEmpty:entity.callName]) {
                entity.callName = CustomLocalizedString(@"Common_id_10", nil);
                entity.sortStr = [StringHelper getSortString:entity.callName];
            }
            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transDelegate transferFile:entity.callName];
            }
            NSString *exportName = [NSString stringWithFormat:@"%@.html",entity.callName];
            [self writeToMsgFileWithPageTitle:exportName exportPath:exportPath Entity:entity];
        }
    }
    [_loghandle writeInfoLog:@"CallExportToHtm End"];
}

- (NSData*)createHtmHeader:(NSString *)title {
    NSString *headerContent = [NSString stringWithFormat:@"<head><meta charset=\"utf-8\" /><title>%@</title><style type=\"text/css\">*{margin: 0;padding: 0; font:normal 12px \"Helvetica Neue\", \"Lucida Sans Unicode\", \"Arial\";color:#333;}body{ background: #eee}.wrap{ width: 640px; margin: 0 auto;}.top{ width: 100%%; height: 42px; background: #3dc79c; text-align: center; font-size: 18px; color: #fff; font-weight: bolder; line-height: 42px;}.cont{ background: #fff; padding: 18px;}.cont h1{ height: 32px; font-size:20px; color: #000;  border-bottom: 1px solid #e5e5e5;}.cont p{ font-size: 14px;  line-height:24px; color: #000; margin: 14px 0 0 0;}.cont table td{ font-size: 14px; text-align: left; line-height: 18px; padding: 30px 0 0 0;}</style></head>", title] ;
    return [headerContent dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData*)createHtmBody:(id)entity {
    NSData *retData = nil;
    IMBADCallContactEntity *callhistory = (IMBADCallContactEntity *)entity;
    NSMutableString *bodyContent = [[NSMutableString alloc] init];
    [bodyContent appendString:[NSString stringWithFormat:@"<body><div class=\"wrap\"><div class=\"top\">%@</div>", CustomLocalizedString(@"Analysis_View_Call", nil)]];
    [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"cont\"><h1>%@</h1>", callhistory.callName]];
    if (callhistory != nil) {
        NSArray *historyList = callhistory.callArray;
      
        if (historyList != nil && historyList.count > 0) {
            NSMutableArray *dateArray = [[NSMutableArray alloc] init];
            NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
            for (IMBADCallHistoryEntity *item in historyList) {
                if (_isStop) {
                    break;
                }
                if (![dateArray containsObject:item.callDateStr]) {
                    [dateArray addObject:item.callDateStr?:@""];
                    [tmpArray addObject:item];
                }
            }
            [dateArray release];
            dateArray = nil;
            
            NSArray *sortedArray = [tmpArray sortedArrayUsingComparator:^(id obj1, id obj2){
                IMBADCallHistoryEntity *msg1 = (IMBADCallHistoryEntity*)obj1;
                IMBADCallHistoryEntity *msg2 = (IMBADCallHistoryEntity*)obj2;
                if (msg1.callTime > msg2.callTime)
                    return NSOrderedAscending;
                else if (msg1.callTime < msg2.callTime)
                    return NSOrderedDescending;
                else
                    return NSOrderedSame;
            }];
            [tmpArray release];
            tmpArray = nil;
            
            if (sortedArray.count > 0) {
                for (IMBADCallHistoryEntity *item in sortedArray) {
                    @autoreleasepool {
                        if (_isStop) {
                            break;
                        }
                        [bodyContent appendString:[NSString stringWithFormat:@"<p>%@</p>", item.callDateStr]];
                        NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.callDateStr = %@", item.callDateStr];
                        NSArray *tmpArray = [historyList filteredArrayUsingPredicate:pre];
                        if (tmpArray != nil && tmpArray.count > 0) {
                            [bodyContent appendString:@"<table cellpadding=\"0\" cellspacing=\"0\" width=\"604\" >"];
                            for (IMBADCallHistoryEntity *callhistory in tmpArray) {
                                if (_isStop) {
                                    break;
                                }
                                _currCount += 1;
                                [bodyContent appendString:@"<tr>"];
                                [bodyContent appendString:[NSString stringWithFormat:@"<td width=\"150\">%@</td>", callhistory.callTimeStr]];
                                NSString *callTypeStr = CustomLocalizedString(@"Common_id_10", nil);
                                
                                if (callhistory.callType == INCOMING_TYPE) {
                                    callTypeStr = CustomLocalizedString(@"callhistory_id_4", nil);
                                }else if (callhistory.callType == OUTGOING_TYPE){
                                    callTypeStr = CustomLocalizedString(@"callhistory_id_6", nil);
                                }else if (callhistory.callType == MISSED_TYPE){
                                    callTypeStr = CustomLocalizedString(@"callhistory_id_3", nil);
                                }else if (callhistory.callType == REJECTED_TYPE){
                                    callTypeStr = CustomLocalizedString(@"Analysis_View_MediaData_CallType_10", nil);
                                }else{
                                    callTypeStr = CustomLocalizedString(@"Common_id_10", nil);
                                }
                                [bodyContent appendString:[NSString stringWithFormat:@"<td width=\"220\">%@</td>", callTypeStr]];
                                [bodyContent appendString:[NSString stringWithFormat:@"<td width=\"192\">%@</td>", [IMBHelper getTimeAutoShowHourString:callhistory.duration*1000]]];
                                [bodyContent appendString:@"</tr>"];
                                
                                float progress = ((float)_currCount / _totalCount) * 100;
                                if ([_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                                    [_transDelegate transferProgress:progress];
                                }
                                _successCount += 1;
                                
                            }
                            [bodyContent appendString:@"</table>"];
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
#pragma mark -import
- (int)importContent:(NSArray *)importArr {
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"MenuItem_id_18", nil)];
    }
    int result = 0;
    _currCount = 0;
    _currSize = 0;
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
        for (IMBADCallHistoryEntity *entity in importArr) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }

            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transDelegate transferFile:entity.contactName];
            }
            _currCount ++;
            BOOL isSuccess = NO;
            NSDictionary *callDic = [entity objectToDictionary:entity];
            NSString *jsonStr = [self createParamsjJsonCommand:CALLLOG Operate:IMPORT ParamDic:callDic];
            if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
                isSuccess = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"sync msg:%@",msg);
                    [msg release];
                    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                        float progress = (float)_currCount / _totalCount * 100;
                        NSLog(@"progress:%f",progress);
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
    [self setTotalCount:deleteArr];
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transDelegate transferPrepareFileEnd];
    }
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        for (IMBADCallContactEntity *entity in deleteArr) {
            for (IMBADCallHistoryEntity *callEntity in entity.callArray) {
                if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transDelegate transferFile:callEntity.contactName];
                }
                _currCount ++;
                BOOL isSuccess = NO;
                NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",callEntity.callId], @"callId", nil];
                NSString *jsonStr = [self createParamsjJsonCommand:CALLLOG Operate:DELETE ParamDic:paramDic];
                if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
                    isSuccess = [coreSocket launchDeleteRequestContent:jsonStr FinishBlock:^(NSData *data) {
                        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"sync msg:%@",msg);
                        [msg release];
                    }];
                    if (!isSuccess){
                        NSLog(@"delete launch request failed");
                    }
                }else {
                    NSLog(@"create json failed");
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

- (void)setTotalCount:(NSArray *)deleteArr {
    _totalCount = 0;
    for (IMBADCallContactEntity *entity in deleteArr) {
        _totalCount += entity.callCount;
    }
}

@end
