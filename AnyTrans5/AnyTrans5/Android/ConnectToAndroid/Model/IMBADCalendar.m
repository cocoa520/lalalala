//
//  IMBADCalendar.m
//  PhoneRescue_Android
//
//  Created by iMobie on 4/5/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBADCalendar.h"
#import "IMBSoftWareInfo.h"
@implementation IMBADCalendar
@synthesize accountList = _accountList;

- (id)initWithSerialNumber:(NSString *)serialNumber {
    self = [super initWithSerialNumber:serialNumber];
    if (self) {
        _accountList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_accountList release],_accountList = nil;
    [super dealloc];
}

- (NSString *)getDatabasesPath {
    NSString *backup = [IMBHelper getSerialNumberPath:_serialNumber];
    self.dbPath = [backup stringByAppendingPathComponent:@"calender.db"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:_dbPath]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm:ss",[IMBSoftWareInfo singleton].systemDateFormatter]];
        NSString *lbDate = [dateFormatter stringFromDate:[NSDate date]];
        NSString *toPath = [backup stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-calender.db",lbDate]];
        [fm moveItemAtPath:_dbPath toPath:toPath error:nil];
        [dateFormatter release];
    }
    return _dbPath;
}

#pragma mark - Abstract Method
- (int)queryDetailContent {
    [_loghandle writeInfoLog:@"Calendar queryDetailContent Begin"];
    int result = 0;
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        //查询event账户
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:@"calendar", @"tableName", nil];
        NSString *jsonStr = [self createParamsjJsonCommand:CALENDAR Operate:QUERY ParamDic:paramDic];
        if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
            ret = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg) {
                    NSLog(@"msg:%@",msg);
                    NSArray *msgArr = [IMBFileHelper dictionaryWithJsonString:msg];
                    if (msgArr != nil) {
                        for (NSDictionary *msgDic in msgArr) {
                            IMBCalendarAccountEntity *calendarAccount = [[IMBCalendarAccountEntity alloc] init];
                            if ([msgDic.allKeys containsObject:@"accountName"]) {
                                calendarAccount.accountName = [msgDic objectForKey:@"accountName"];
                            }
                            if ([msgDic.allKeys containsObject:@"displayName"]) {
                                calendarAccount.displayName = [msgDic objectForKey:@"displayName"];
                            }
                            if ([msgDic.allKeys containsObject:@"id"]) {
                                calendarAccount.accountId = [[msgDic objectForKey:@"id"] intValue];
                            }
                            [_reslutEntity.reslutArray addObject:calendarAccount];
                            [calendarAccount release];
                        }
                    }
                }else {
                    NSLog(@"错误");
                    [_loghandle writeInfoLog:@"Calendar Account queryDetailContent Error"];
                }
                [msg release];
            }];
        }else {
            result = -2;
        }
        //查询event
        NSDictionary *eventParamDic = [NSDictionary dictionaryWithObjectsAndKeys:@"event", @"tableName", nil];
        NSString *thumJsonStr = [self createParamsjJsonCommand:CALENDAR Operate:QUERY ParamDic:eventParamDic];
        if (![IMBFileHelper stringIsNilOrEmpty:thumJsonStr] && !_isStop) {
            ret = [coreSocket launchRequestContent:thumJsonStr FinishBlock:^(NSData *data) {
                NSString *msg1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg1) {
                    NSLog(@"msg:%@",msg1);
                    NSArray *eventArr = [IMBFileHelper dictionaryWithJsonString:msg1];
                    if (eventArr != nil && [eventArr isKindOfClass:[NSArray class]]) {
                        for (NSDictionary *msgDic in eventArr) {
                            int calendarId = 0;
                            if ([msgDic.allKeys containsObject:@"calendarId"]) {
                                calendarId = [[msgDic objectForKey:@"calendarId"] intValue];
                            }
                            IMBADCalendarEntity *calendarEntity = [[IMBADCalendarEntity alloc] init];
                            calendarEntity.parentID = calendarId;
                            if ([msgDic.allKeys containsObject:@"id"]) {
                                calendarEntity.calendarID = [[msgDic objectForKey:@"id"] intValue];
                            }
                            if ([msgDic.allKeys containsObject:@"dtend"]) {
                                calendarEntity.calendarEndTime = [[msgDic objectForKey:@"dtend"] longLongValue];
                                calendarEntity.calendarDateEnd = [calendarEntity dateFrom1970ToString:calendarEntity.calendarEndTime/1000.0 withMode:nil withTimeZone:nil];
                            }
                            if ([msgDic.allKeys containsObject:@"dtstart"]) {
                                calendarEntity.calendarStartTime = [[msgDic objectForKey:@"dtstart"] longLongValue];
                                calendarEntity.calendarDateStart = [calendarEntity dateFrom1970ToString:calendarEntity.calendarStartTime/1000.0 withMode:nil withTimeZone:nil];
                            }
                            if ([msgDic.allKeys containsObject:@"title"]) {
                                calendarEntity.calendarTitle = [msgDic objectForKey:@"title"];
                                calendarEntity.sortStr = [StringHelper getSortString:calendarEntity.calendarTitle];
                            }
                            if ([msgDic.allKeys containsObject:@"description"]) {
                                calendarEntity.calendarDescription = [msgDic objectForKey:@"description"];
                            }
                            if ([msgDic.allKeys containsObject:@"location"]) {
                                calendarEntity.calendarLocation = [msgDic objectForKey:@"location"];
                            }
                            _reslutEntity.reslutCount ++;
                            _reslutEntity.selectedCount ++;
                            _reslutEntity.scanType = ScanCalendarFile;
                            //增加到对应账户
                            for (IMBCalendarAccountEntity *entity in _reslutEntity.reslutArray) {
                                if (calendarId == entity.accountId) {
                                    [entity.eventArray addObject:calendarEntity];
                                    entity.selectedCount += 1;
                                    break;
                                }
                            }
                            [calendarEntity release];
                        }
                    }
                }else {
                    NSLog(@"错误");
                    [_loghandle writeInfoLog:@"Calendar queryDetailContent Error"];
                }
                [msg1 release];
            }];
            if (!ret) {
                result = -5;
            }
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
    [_loghandle writeInfoLog:@"Calendar queryDetailContent End"];
    return result; 
}

/**
 *查询删除数据
 */
- (void)queryDeleteContent {
    [_loghandle writeInfoLog:@"Calendar queryDeleteContent Begin"];
    [self queryEventsTableExsitContent];
    [self queryEventsTableDeleteContent];
    [_loghandle writeInfoLog:@"Calendar queryDeleteContent End"];
}

- (void)queryEventsTableExsitContent {
    [_loghandle writeInfoLog:@"Calendar queryEventsTableDeleteContent Begin"];
    if ([self openDBConnection]) {
        NSString *selectCmd = @"select title,description,calendar_id,dtstart,dtend from Events";
        FMResultSet *rs = [_fmDB executeQuery:selectCmd];
        while ([rs next]) {
            IMBADCalendarEntity *entity = [[IMBADCalendarEntity alloc] init];
            entity.parentID = 1;
            if (![rs columnIsNull:@"title"]) {
                entity.calendarTitle = [rs stringForColumn:@"title"];
                entity.sortStr = [StringHelper getSortString:entity.calendarTitle];
            }
            if (![rs columnIsNull:@"description"]) {
                entity.calendarDescription = [rs stringForColumn:@"description"];
            }
            if (![rs columnIsNull:@"calendar_id"]) {
                entity.parentID = [rs intForColumn:@"calendar_id"];
            }
            if (![rs columnIsNull:@"dtstart"]) {
                entity.calendarStartTime = [rs longLongIntForColumn:@"dtstart"];
                entity.calendarDateStart = [entity dateFrom1970ToString:entity.calendarStartTime/1000.0 withMode:nil withTimeZone:nil];
            }
            if (![rs columnIsNull:@"dtend"]) {
                entity.calendarEndTime = [rs longLongIntForColumn:@"dtend"];
                entity.calendarDateEnd = [entity dateFrom1970ToString:entity.calendarEndTime/1000.0 withMode:nil withTimeZone:nil];
            }
            BOOL isExist = NO;
            if (_reslutEntity.reslutArray.count > 0) {
                for (IMBADCalendarEntity *item in _reslutEntity.reslutArray) {
                    if ([item.calendarTitle isEqualToString:entity.calendarTitle] && item.calendarStartTime == entity.calendarStartTime) {
                        isExist = YES;
                        break;
                    }
                }
            }
            if (!isExist) {
                entity.isDeleted = YES;
                _reslutEntity.reslutCount ++;
                _reslutEntity.selectedCount ++;
                _reslutEntity.deleteCount ++;
                _reslutEntity.scanType = ScanCalendarFile;
                if (_reslutEntity.reslutArray.count > 0) {
                    [_reslutEntity.reslutArray insertObject:entity atIndex:0];
                }else {
                    [_reslutEntity.reslutArray addObject:entity];
                }
            }
            [entity release];
        }
        [rs close];
        rs = nil;
        [self closeDBConnection];
    }
    [_loghandle writeInfoLog:@"Calendar queryEventsTableDeleteContent End"];
}

- (void)queryEventsTableDeleteContent {
    [_loghandle writeInfoLog:@"Calendar queryEventsTableDeleteContent Begin"];
    NSMutableArray *columnArr = [NSMutableArray array];
    NSMutableDictionary *columnDic = [NSMutableDictionary dictionary];
    if ([self openDBConnection]) {
        NSString *selectCmd = @"PRAGMA table_info (Events)";
        FMResultSet *rs = [_fmDB executeQuery:selectCmd];
        while ([rs next]) {
            int cid = [rs intForColumn:@"cid"];
            NSString *name = [rs stringForColumn:@"name"];
            if ([name isEqualToString:@"calendar_id"] || [name isEqualToString:@"dtstart"]) {
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
    [_loghandle writeInfoLog:@"Calendar queryEventsTableDeleteContent End"];
}

- (int)exportContent:(NSString *)targetPath ContentList:(NSArray *)exportArr exportType:(NSString *)type{
    [_loghandle writeInfoLog:@"export calendar start"];
    int result = 0;
    if ([IMBFileHelper stringIsNilOrEmpty:targetPath]) {
        return -2;
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"MenuItem_id_62", nil)];
    }
    _currCount = 0;
    _currSize = 0;
    _successCount = 0;
    _failedCount = 0;
    _totalCount = (int)[exportArr count];
    if ([_transDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transDelegate transferPrepareFileEnd];
    }
    if ([type isEqualToString:@"csv"]) {
        [_loghandle writeInfoLog:@"export csv calendar start"];
        [self calendarExportByCSV:targetPath exportArray:exportArr];
        [_loghandle writeInfoLog:@"export csv calendar end"];
    }else if ([type isEqualToString:@"txt"]) {
        [_loghandle writeInfoLog:@"export txt calendar start"];
        [self calendarExportByTXT:targetPath exportArray:exportArr];
        [_loghandle writeInfoLog:@"export txt calendar start"];
    }
    if ([_transDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transDelegate transferComplete:_successCount TotalCount:_totalCount];
    }
    [_loghandle writeInfoLog:@"export calendar start"];

    return result;
}

#pragma mark export CSV
- (void)calendarExportByCSV:(NSString *)exportPath exportArray:(NSArray *)exportArr{
    if (exportArr.count > 0) {
        NSString *exPath;
        exPath = [exportPath stringByAppendingPathComponent:[CustomLocalizedString(@"MenuItem_id_62", nil) stringByAppendingString:@".csv"]];
        if ([_fileManager fileExistsAtPath:exPath]) {
            exPath = [IMBFileHelper getFilePathAlias:exPath];
        }
        [_fileManager createFileAtPath:exPath contents:nil attributes:nil];
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exPath];
        int i = 0;
        for (IMBADCalendarEntity *item in exportArr) {
            @autoreleasepool {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }

                NSString *titleString = @"";
                if (i == 0) {
                    titleString = [self tableTitleString];
                }
                _currCount += 1;
                if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transDelegate transferFile:item.calendarTitle];
                }
                NSString *conString = @"";
                conString = [self eachCalendarInfoByCSVOther:item];
                titleString = [titleString stringByAppendingString:@"\r\n"];
                titleString = [titleString stringByAppendingString:conString];
                NSData *data = [titleString dataUsingEncoding:NSUTF8StringEncoding];
                [handle writeData:data];
                float progress = (((float)_currCount / _totalCount) * 100);
                if ([_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_transDelegate transferProgress:progress];
                }
                _successCount += 1;
                i++;
            }
        }
        [handle closeFile];
    }
}

- (NSString *)eachCalendarInfoByCSVOther:(IMBADCalendarEntity *)item {
    NSString *itemString = @"";
    if (item != nil) {
        if (![IMBFileHelper stringIsNilOrEmpty:item.calendarTitle]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.calendarTitle]];
        }
        itemString = [itemString stringByAppendingString:@","];
        if (item.calendarStartTime != 0) {
            itemString = [itemString stringByAppendingString:item.calendarDateStart];
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.calendarEndTime != 0) {
            itemString = [itemString stringByAppendingString:item.calendarDateEnd];
        }
        itemString = [itemString stringByAppendingString:@","];
        
        itemString = [itemString stringByAppendingString:@","];
        if (![IMBFileHelper stringIsNilOrEmpty:item.calendarDescription]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.calendarDescription]];
        }
        
    }
    return itemString;
}

- (NSString *)covertSpecialChar:(NSString *)str {
    if (![IMBFileHelper stringIsNilOrEmpty:str]) {
        NSString *string = [str stringByReplacingOccurrencesOfString:@"," withString:@"&c;a&"];
        return string;
    }else {
        return str;
    }
}

- (NSString *)tableTitleString {
    NSString *titleString = @"";
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"Calender_Title", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"Calender_StartTime", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"Calender_EndTime", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"contact_id_91", nil)];
    return titleString;
}

#pragma mark export txt
- (void)calendarExportByTXT:(NSString *)exportPath exportArray:(NSArray *)exportArr{
    if (exportArr.count > 0) {
        NSString *exPath;
        exPath = [exportPath stringByAppendingPathComponent:[CustomLocalizedString(@"MenuItem_id_62", nil) stringByAppendingString:@".txt"]];
        if ([_fileManager fileExistsAtPath:exPath]) {
            exPath = [IMBFileHelper getFilePathAlias:exPath];
        }
        
        [_fileManager createFileAtPath:exPath contents:nil attributes:nil];
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exPath];
        for (IMBADCalendarEntity *item in exportArr) {
            
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
                    [_transDelegate transferFile:item.calendarTitle];
                }
                NSString *conString = @"";
                conString = [conString stringByAppendingString:[self eachCalendarInfoByTXTOther:item]];
                conString = [conString stringByAppendingString:@"\r\n"];
                NSData *data = [conString dataUsingEncoding:NSUTF8StringEncoding];
                [handle writeData:data];
                float progress = (((float)_currCount / _totalCount) * 100);
                if ([_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_transDelegate transferProgress:progress];
                }
                _successCount += 1;
            }
        }
        [handle closeFile];
    }
}

- (NSString *)eachCalendarInfoByTXTOther:(IMBADCalendarEntity *)item {
    NSString *itemString = @"";
    if (item != nil) {
        if (![IMBFileHelper stringIsNilOrEmpty:item.calendarTitle]) {
            itemString = [[itemString stringByAppendingString:item.calendarTitle] stringByAppendingString:@"\r\n"];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@"\r\n"];
        }
        
        itemString = [itemString stringByAppendingString:@"------------------------------------------------------------------------------------------\r\n"];
        NSString *toobStr = [[[[[[[CustomLocalizedString(@"Calender_Title", nil) stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"Calender_StartTime", nil)] stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"Calender_EndTime", nil)] stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"contact_id_91", nil)]stringByAppendingString:@"\r\n"];
        
        itemString = [itemString stringByAppendingString:toobStr];
        
        if (![IMBFileHelper stringIsNilOrEmpty:item.calendarTitle]) {
            itemString = [[itemString stringByAppendingString:item.calendarTitle] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        if (item.calendarStartTime != 0) {
            itemString = [[itemString stringByAppendingString:item.calendarDateStart] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        if (item.calendarEndTime != 0) {
            itemString = [[itemString stringByAppendingString:item.calendarDateEnd] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }

        if (![IMBFileHelper stringIsNilOrEmpty:item.calendarDescription]) {
            itemString = [[itemString stringByAppendingString:item.calendarDescription] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        itemString = [itemString stringByAppendingString:@"\r\n"];
    }
    
    return itemString;
}



#pragma mark  - import
- (int)importContent:(NSArray *)importArr {
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:@"import content start"];
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
        for (IMBADCalendarEntity *eventEntity in importArr) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }

            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transDelegate transferFile:eventEntity.calendarTitle];
            }
            _currCount ++;
            BOOL isSuccess = NO;
            NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
            if (eventEntity.calendarTitle) {
                [paramDic setObject:eventEntity.calendarTitle forKey:@"title"];
            }
            if (eventEntity.calendarDescription) {
                [paramDic setObject:eventEntity.calendarDescription forKey:@"description"];
            }
            [paramDic setObject:[NSString stringWithFormat:@"%d",1] forKey:@"calendarid"];
            [paramDic setObject:[NSString stringWithFormat:@"%lld",eventEntity.calendarStartTime] forKey:@"dtstart"];
            [paramDic setObject:[NSString stringWithFormat:@"%lld",eventEntity.calendarEndTime] forKey:@"dtend"];
            NSString *jsonStr = [self createParamsjJsonCommand:CALENDAR Operate:IMPORT ParamDic:paramDic];
            if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
                isSuccess = [coreSocket launchSyncRequestContent:jsonStr FinishBlock:^(NSData *data) {
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
                    result = -4;
                    NSLog(@"import launch request failed");
                }
            }else {
                result = -1;
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
        [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"MenuItem_id_62", nil)];
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
        //        for (IMBPhotoEntity *entity in deleteArr) {
        //            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
        //                [_transDelegate transferFile:entity.name];
        //            }
        //            _currCount ++;
        //            BOOL isSuccess = NO;
        //            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",entity.photoId], @"imageId", entity.url, @"imageUrl", [NSString stringWithFormat:@"%d",entity.thumbnilId], @"thumbnailId", entity.thumbnilUrl, @"thumbnailUrl", nil];
        //            NSString *jsonStr = [self createParamsjJsonCommand:IMAGE Operate:DELETE ParamDic:paramDic];
        //            if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
        //                isSuccess = [coreSocket launchDeleteRequestContent:jsonStr FinishBlock:^(NSData *data) {
        //                    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //                    NSLog(@"sync msg:%@",msg);
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
