//
//  IMBADContact.m
//  PhoneRescue_Android
//
//  Created by iMobie on 4/7/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBADContact.h"

@implementation IMBADContact

- (void)dealloc
{
    if (_mimeTypeList != nil) {
        [_mimeTypeList release];
         _mimeTypeList = nil;
    }
    [super dealloc];
}

- (NSString *)getDatabasesPath {
    NSString *backup = [IMBHelper getSerialNumberPath:_serialNumber];
    self.dbPath = [backup stringByAppendingPathComponent:@"contact.db"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:_dbPath]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *lbDate = [dateFormatter stringFromDate:[NSDate date]];
        NSString *toPath = [backup stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-contact.db",lbDate]];
        [fm moveItemAtPath:_dbPath toPath:toPath error:nil];
        [dateFormatter release];
    }
    return _dbPath;
}

#pragma mark - Abstract Method
- (int)queryDetailContent {
    [_loghandle writeInfoLog:@"Contact queryDetailContent Begin"];
    int result = 0;
    dispatch_queue_t queue = dispatch_queue_create("scoket_queue", nil);
    GCDAsyncSocket *scoket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    BOOL ret = [IMBSocketFactory getAsyncSocket:_serialNumber withAsncSocket:scoket];
    if (ret) {
        IMBCoreAndriodSocket *coreSocket = [[IMBCoreAndriodSocket alloc] initWithDetegate:self WithAsyncSocket:scoket];
        [coreSocket setThread:[NSThread currentThread]];
        [coreSocket setIsSingleQuery:YES];
        NSDictionary *paramDic = [NSDictionary dictionary];
        NSString *jsonStr = [self createParamsjJsonCommand:CONTACT Operate:QUERY ParamDic:paramDic];
        if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
            ret = [coreSocket launchRequestContent:jsonStr FinishBlock:^(NSData *data) {
                NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(msg) {
                    NSLog(@"contact mag:%@",msg);
                    NSDictionary *msgDic = [IMBFileHelper dictionaryWithJsonString:msg];
                    if (msgDic != nil && [msgDic isKindOfClass:[NSDictionary class]]) {
                        IMBADContactEntity *contactEntity = [[IMBADContactEntity alloc] init];
                        [contactEntity dictionaryToObject:msgDic];
                        _reslutEntity.reslutCount ++;
                        _reslutEntity.scanType = ScanContactFile;
                        [_reslutEntity.reslutArray addObject:contactEntity];
                        [contactEntity release];
                    }
                }else {
                    NSLog(@"错误");
                    [_loghandle writeInfoLog:@"Contact queryDetailContent Error"];
                }
                [msg release];
            }];
            if (ret) {
                if (_reslutEntity.reslutCount > 0) {
                    for (IMBADContactEntity *entity in _reslutEntity.reslutArray) {
                        if (entity.isImage) {
                            NSDictionary *imageParamDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",entity.contactID], @"contactID", nil];
                            NSString *imageJsonStr = [self createParamsjJsonCommand:CONTACT Operate:THUMBNAIL ParamDic:imageParamDic];
                            if (entity.contactID == 2) {
                                NSLog(@"=======");
                            }
                            if (![IMBFileHelper stringIsNilOrEmpty:imageJsonStr]) {
                                ret = [coreSocket launchRequestContent:imageJsonStr FinishBlock:^(NSData *data) {
                                    if (data != nil && data.length > 4) {
                                        entity.imageData = data;
                                    }else {
                                        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                        if(msg) {
                                            NSLog(@"msg:%@",msg);
                                        }
                                        [msg release];
                                    }
                                }];
                            }
                        }
                    }
                }
            }else {
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
        for (IMBADContactEntity *entity in _reslutEntity.reslutArray) {
            [entity unifiedArrangementName:YES];
        }
    }
    
    [_loghandle writeInfoLog:@"Contact queryDetailContent End"];
    return result;
}

/**
 *查询删除数据
 */
- (void)queryDeleteContent {
    [_loghandle writeInfoLog:@"Contact queryDeleteContent Begin"];
    if (_mimeTypeList != nil) {
        [_mimeTypeList release];
        _mimeTypeList = nil;
    }
    _mimeTypeList = [[NSMutableArray alloc] init];
    if ([self openDBConnection]) {
        //查询mimetypes表
        NSString *selectCmd = @"select _id,mimetype from mimetypes";
        FMResultSet *rs = [_fmDB executeQuery:selectCmd];
        while ([rs next]) {
            IMBContactMimeTypeEntity *entity = [[IMBContactMimeTypeEntity alloc] init];
            entity.cid = [rs intForColumn:@"_id"];
            entity.type = [rs stringForColumn:@"mimetype"];
            [_mimeTypeList addObject:entity];
            [entity release];
        }
        [rs close];
        rs = nil;
        
        [self closeDBConnection];
    }
    
    [self queryDataTableExsitContent];
    
    [self queryDataTableDeleteContent];
    [_loghandle writeInfoLog:@"Contact queryDeleteContent End"];
}

- (void)queryDataTableExsitContent {
    [_loghandle writeInfoLog:@"Contact queryDataTableExsitContent Begin"];
    NSMutableArray *idArray = [NSMutableArray array];
    if ([self openDBConnection]) {
        NSString *selectCmd = @"select *from data";
        FMResultSet *rs = [_fmDB executeQuery:selectCmd];
        while ([rs next]) {
            int contactId = 0;
            if (![rs columnIsNull:@"raw_contact_id"]) {
                contactId = [rs intForColumn:@"raw_contact_id"];
            }
            BOOL isExist = NO;
            if (_reslutEntity.reslutArray.count > 0) {
                for (IMBADContactEntity *entity in _reslutEntity.reslutArray) {
                    if (entity.rawContactID == contactId) {
                        isExist = YES;
                        break;
                    }
                }
            }
            if (!isExist && contactId != 0) {
                if (![idArray containsObject:[NSNumber numberWithInt:contactId]]) {
                    [idArray addObject:[NSNumber numberWithInt:contactId]];
                }
            }
        }
        [rs close];
        rs = nil;
        
        if (idArray.count > 0) {
            for (NSNumber *number in idArray) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    _currentRealStopName = @"Contacts";
                    break;
                }
                selectCmd = [NSString stringWithFormat:@"select *from data where raw_contact_id = %d",number.intValue];
                rs = [_fmDB executeQuery:selectCmd];
                IMBADContactEntity *contactEntity = [[IMBADContactEntity alloc] init];
                contactEntity.contactID = number.intValue;
                contactEntity.rawContactID = number.intValue;
                contactEntity.isDeleted = YES;
                while ([rs next]) {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        break;
                    }
                    NSString *type = @"";
                    if (![rs columnIsNull:@"mimetype_id"]) {
                        int mimeType = [rs intForColumn:@"mimetype_id"];
                        if (_mimeTypeList.count > 0) {
                            for (IMBContactMimeTypeEntity *mimeEntity in _mimeTypeList) {
                                if (mimeEntity.cid == mimeType) {
                                    type = mimeEntity.type;
                                    break;
                                }
                            }
                        }
                    }
                    
                    if (![IMBHelper stringIsNilOrEmpty:type]) {
                        if ([type isEqualToString:@"vnd.android.cursor.item/name"]) {
                            if (![rs columnIsNull:@"data1"]) {
                                contactEntity.structuredName = [[IMBContactLabelValueEntity alloc] init];
                                contactEntity.structuredName.value = [rs stringForColumn:@"data1"];
                                    contactEntity.structuredName.isDeleted = YES;
                                contactEntity.contactName = [[IMBContactLabelValueEntity alloc] init];
                                contactEntity.contactName.value = contactEntity.structuredName.value;
                                contactEntity.contactName.isDeleted = YES;
                            }else if (![rs columnIsNull:@"data2"]) {
                                contactEntity.contactFirstName = [[IMBContactLabelValueEntity alloc] init];
                                contactEntity.contactFirstName.value = [rs stringForColumn:@"data2"];
                                contactEntity.contactFirstName.isDeleted = YES;
                            }else if (![rs columnIsNull:@"data3"]) {
                                contactEntity.contactLastName = [[IMBContactLabelValueEntity alloc] init];
                                contactEntity.contactLastName.value = [rs stringForColumn:@"data3"];
                                contactEntity.contactLastName.isDeleted = YES;
                            }else if (![rs columnIsNull:@"data4"]) {
                                contactEntity.contactPrefixName = [[IMBContactLabelValueEntity alloc] init];
                                contactEntity.contactPrefixName.value = [rs stringForColumn:@"data4"];
                                    contactEntity.contactPrefixName.isDeleted = YES;
                            }else if (![rs columnIsNull:@"data5"]) {
                                contactEntity.contactMiddleName = [[IMBContactLabelValueEntity alloc] init];
                                contactEntity.contactMiddleName.value = [rs stringForColumn:@"data5"];
                                contactEntity.contactMiddleName.isDeleted = YES;
                            }else if (![rs columnIsNull:@"data6"]) {
                                contactEntity.contactSuffixName = [[IMBContactLabelValueEntity alloc] init];
                                contactEntity.contactSuffixName.value = [rs stringForColumn:@"data6"];
                                contactEntity.contactSuffixName.isDeleted = YES;
                            }else if (![rs columnIsNull:@"data7"]) {//首名字拼音
                            }else if (![rs columnIsNull:@"data8"]) {//中间名字拼音
                            }else if (![rs columnIsNull:@"data9"]) {//尾名字拼音
                            }
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/nickname"]) {
                            if (![rs columnIsNull:@"data1"]) {
                                contactEntity.contactNickName = [[IMBContactLabelValueEntity alloc] init];
                                contactEntity.contactNickName.value = [rs stringForColumn:@"data1"];
                                contactEntity.contactNickName.isDeleted = YES;
                            }
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/phone_v2"]) {
                            [self addContentToContactEntity:contactEntity withRs:rs withItemType:@"phone"];
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/email_v2"]) {
                            [self addContentToContactEntity:contactEntity withRs:rs withItemType:@"email"];
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/photo"]) {
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/organization"]) {
                            if (![rs columnIsNull:@"data1"]) {
                                contactEntity.companyName = [[IMBContactLabelValueEntity alloc] init];
                                contactEntity.companyName.value = [rs stringForColumn:@"data1"];
                                contactEntity.companyName.isDeleted = YES;
                            }
                            if (![rs columnIsNull:@"data4"]) {
                                contactEntity.companyJob = [[IMBContactLabelValueEntity alloc] init];
                                contactEntity.companyJob.value = [rs stringForColumn:@"data4"];
                                contactEntity.companyJob.isDeleted = YES;
                            }
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/im"]) {
                            [self addContentToContactEntity:contactEntity withRs:rs withItemType:@"im"];
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/note"]) {
                            if (![rs columnIsNull:@"data1"]) {
                                contactEntity.contactNote = [[IMBContactLabelValueEntity alloc] init];
                                contactEntity.contactNote.value = [rs stringForColumn:@"data1"];
                                contactEntity.contactNote.isDeleted = YES;
                            }
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/postal-address_v2"]) {
                            [self addContentToContactEntity:contactEntity withRs:rs withItemType:@"address"];
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/group_membership"]) {
                            
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/website"]) {
                            if (![rs columnIsNull:@"data1"]) {
                                NSString *data1 = [rs stringForColumn:@"data1"];
                                IMBContactLabelValueEntity *item = [[IMBContactLabelValueEntity alloc] init];
                                item.isDeleted = YES;
                                item.value = data1;
                                item.lable = CustomLocalizedString(@"contact_id_43", nil);
                                [contactEntity.websiteData addObject:item];
                                [item release];
                            }
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/contact_event"]) {
                            [self addContentToContactEntity:contactEntity withRs:rs withItemType:@"event"];
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/relation"]) {
                            [self addContentToContactEntity:contactEntity withRs:rs withItemType:@"relation"];
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/sip_address"]) {
                            
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/identity"]) {
                            
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/photo_default"]) {
                            
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/vnd.com.whatsapp.profile"]) {
                            
                        }else if ([type isEqualToString:@"vnd.android.cursor.item/vnd.com.whatsapp.voip.call"]) {
                            
                        }
                    }
                }
                [rs close];
                rs = nil;
                
                _reslutEntity.deleteCount ++;
                _reslutEntity.reslutCount ++;
                _reslutEntity.selectedCount ++;
                if (_reslutEntity.reslutArray.count > 0) {
                    [_reslutEntity.reslutArray insertObject:contactEntity atIndex:0];
                }else {
                    [_reslutEntity.reslutArray addObject:contactEntity];
                }
                [contactEntity release];
            }
        }
        [self closeDBConnection];
    }
    [_loghandle writeInfoLog:@"Contact queryDataTableExsitContent End"];
}

- (void)queryDataTableDeleteContent {
    [_loghandle writeInfoLog:@"Contact queryDataTableDeleteContent Begin"];
    NSMutableArray *columnArr = [NSMutableArray array];
    NSMutableDictionary *columnDic = [NSMutableDictionary dictionary];
    if ([self openDBConnection]) {
        NSString *selectCmd = @"PRAGMA table_info (data)";
        FMResultSet *rs = [_fmDB executeQuery:selectCmd];
        while ([rs next]) {
            int cid = [rs intForColumn:@"cid"];
            NSString *name = [rs stringForColumn:@"name"];
            if ([name isEqualToString:@"raw_contact_id"] || [name isEqualToString:@"data1"]) {
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
    [_loghandle writeInfoLog:@"Contact queryDataTableDeleteContent End"];
}

- (IMBADContactEntity *)createContactEntity:(NSString **)type withValueArray:(NSArray *)valueArr withColumnDic:(NSDictionary *)columnDic {
    IMBADContactEntity *contactEntity = nil;
    for (NSDictionary *itemDic in valueArr){
        if ([itemDic.allKeys containsObject:@"columnIndex"]) {
            int columnIndex = [[itemDic objectForKey:@"columnIndex"] intValue];
            NSString *column = [NSString stringWithFormat:@"column-%d",columnIndex];
            if ([columnDic.allKeys containsObject:column]) {
                NSString *dataStr = @"";
                if ([itemDic.allKeys containsObject:@"data"]) {
                    dataStr = [itemDic objectForKey:@"data"];
                }
                NSString *columnName = [columnDic objectForKey:column];
                if ([columnName isEqualToString:@"raw_contact_id"]) {
                    int cid = dataStr.intValue;
                    for (IMBADContactEntity *entity in _reslutEntity.reslutArray) {
                        if (entity.rawContactID == cid) {
                            contactEntity = entity;
                            break;
                        }
                    }
                }else if ([columnName isEqualToString:@"mimetype_id"]) {
                    int cid = dataStr.intValue;
                    for (IMBContactMimeTypeEntity *entity in _mimeTypeList) {
                        if (entity.cid == cid) {
                            *type = entity.type;
                            break;
                        }
                    }
                }
            }
        }
    }
    return contactEntity;
}

//解析删除数据名字的行
- (BOOL)parseDeleteContactName:(IMBADContactEntity *)contactEntity withValueArray:(NSArray *)valueArr withColumnDic:(NSDictionary *)columnDic withIsNewContact:(BOOL)isNewContact {
    BOOL isChange = NO;
    for (NSDictionary *itemDic in valueArr){
        if ([itemDic.allKeys containsObject:@"columnIndex"]) {
            NSString *dataStr = @"";
            if ([itemDic.allKeys containsObject:@"data"]) {
                dataStr = [itemDic objectForKey:@"data"];
                NSLog(@"dataStr:%@",dataStr);
            }
            if (![IMBHelper stringIsNilOrEmpty:dataStr]) {
                int columnIndex = [[itemDic objectForKey:@"columnIndex"] intValue];
                NSString *column = [NSString stringWithFormat:@"column-%d",columnIndex];
                if ([columnDic.allKeys containsObject:column]) {
                    NSString *columnName = [columnDic objectForKey:column];
                    NSLog(@"columnName:%@",columnName);
                    if (isNewContact) {
                        if ([columnName isEqualToString:@"raw_contact_id"]) {
                            contactEntity.contactID = dataStr.intValue;
                            contactEntity.rawContactID = dataStr.intValue;
                        }
                    }
                    if ([columnName isEqualToString:@"data1"]) {
                        if (contactEntity.structuredName == nil) {
                            contactEntity.structuredName = [[IMBContactLabelValueEntity alloc] init];
                        }
                        if ([IMBHelper stringIsNilOrEmpty:contactEntity.structuredName.value]) {
                            contactEntity.structuredName.value = [IMBHelper stringCorrectFormat:[IMBHelper stringFromHexString:dataStr]];
                            isChange = YES;
                            contactEntity.structuredName.isDeleted = YES;
                            if (contactEntity.contactName == nil) {
                                contactEntity.contactName = [[IMBContactLabelValueEntity alloc] init];
                            }
                            if ([IMBHelper stringIsNilOrEmpty:contactEntity.contactName.value]) {
                                contactEntity.contactName.value = [IMBHelper stringCorrectFormat:[IMBHelper stringFromHexString:dataStr]];
                                contactEntity.contactName.isDeleted = YES;
                            }
                        }
                    }else if ([columnName isEqualToString:@"data2"]) {
                        if (contactEntity.contactFirstName == nil) {
                            contactEntity.contactFirstName = [[IMBContactLabelValueEntity alloc] init];
                        }
                        if ([IMBHelper stringIsNilOrEmpty:contactEntity.contactFirstName.value]) {
//                            isChange = YES;
                            contactEntity.contactFirstName.value = [IMBHelper stringCorrectFormat:[IMBHelper stringFromHexString:dataStr]];
                            contactEntity.contactFirstName.isDeleted = YES;
                        }
                    }else if ([columnName isEqualToString:@"data3"]) {
                        if (contactEntity.contactLastName == nil) {
                            contactEntity.contactLastName = [[IMBContactLabelValueEntity alloc] init];
                        }
                        if ([IMBHelper stringIsNilOrEmpty:contactEntity.contactLastName.value]) {
//                            isChange = YES;
                            contactEntity.contactLastName.value = [IMBHelper stringCorrectFormat:[IMBHelper stringFromHexString:dataStr]];
                            contactEntity.contactLastName.isDeleted = YES;
                        }
                    }else if ([columnName isEqualToString:@"data4"]) {
                        if (contactEntity.contactPrefixName == nil) {
                            contactEntity.contactPrefixName = [[IMBContactLabelValueEntity alloc] init];
                        }
                        if ([IMBHelper stringIsNilOrEmpty:contactEntity.contactPrefixName.value]) {
//                            isChange = YES;
                            contactEntity.contactPrefixName.value = [IMBHelper stringCorrectFormat:[IMBHelper stringFromHexString:dataStr]];
                            contactEntity.contactPrefixName.isDeleted = YES;
                        }
                    }else if ([columnName isEqualToString:@"data5"]) {
                        if (contactEntity.contactMiddleName == nil) {
                            contactEntity.contactMiddleName = [[IMBContactLabelValueEntity alloc] init];
                        }
                        if ([IMBHelper stringIsNilOrEmpty:contactEntity.contactMiddleName.value]) {
//                            isChange = YES;
                            contactEntity.contactMiddleName.value = [IMBHelper stringCorrectFormat:[IMBHelper stringFromHexString:dataStr]];
                            contactEntity.contactMiddleName.isDeleted = YES;
                        }
                    }else if ([columnName isEqualToString:@"data6"]) {
                        if (contactEntity.contactSuffixName == nil) {
                            contactEntity.contactSuffixName = [[IMBContactLabelValueEntity alloc] init];
                        }
                        if ([IMBHelper stringIsNilOrEmpty:contactEntity.contactSuffixName.value]) {
//                            isChange = YES;
                            contactEntity.contactSuffixName.value = [IMBHelper stringCorrectFormat:[IMBHelper stringFromHexString:dataStr]];
                            contactEntity.contactSuffixName.isDeleted = YES;
                        }
                    }else if ([columnName isEqualToString:@"data7"]) {//首名字拼音
                    }else if ([columnName isEqualToString:@"data8"]) {//中间名字拼音
                    }else if ([columnName isEqualToString:@"data9"]) {//尾名字拼音
                    }
                }
            }
        }
    }
    return isChange;
}

//解析删除数据phone、email、im、address、event、relation的行
- (BOOL)parseDeleteContactItemArray:(IMBADContactEntity *)contactEntity withValueArray:(NSArray *)valueArr withColumnDic:(NSDictionary *)columnDic withIsNewContact:(BOOL)isNewContact withItemType:(NSString *)itemType {
    BOOL isChange = NO;
    NSString *data1 = @"";
    NSString *data2 = @"";
    NSString *data3 = @"";
    for (NSDictionary *itemDic in valueArr){
        if ([itemDic.allKeys containsObject:@"columnIndex"]) {
            NSString *dataStr = @"";
            if ([itemDic.allKeys containsObject:@"data"]) {
                dataStr = [itemDic objectForKey:@"data"];
                NSLog(@"dataStr:%@",dataStr);
            }
            if (![IMBHelper stringIsNilOrEmpty:dataStr]) {
                int columnIndex = [[itemDic objectForKey:@"columnIndex"] intValue];
                NSString *column = [NSString stringWithFormat:@"column-%d",columnIndex];
                if ([columnDic.allKeys containsObject:column]) {
                    NSString *columnName = [columnDic objectForKey:column];
                    NSLog(@"columnName:%@",columnName);
                    if (isNewContact) {
                        if ([columnName isEqualToString:@"raw_contact_id"]) {
                            contactEntity.contactID = dataStr.intValue;
                            contactEntity.rawContactID = dataStr.intValue;
                        }
                    }
                    if ([columnName isEqualToString:@"data1"]) {
                        data1 = [IMBHelper stringCorrectFormat:[IMBHelper stringFromHexString:dataStr]];
                    }else if ([columnName isEqualToString:@"data2"]) {
                        data2 = [IMBHelper stringCorrectFormat:[IMBHelper stringFromHexString:dataStr]];
                    }else if ([columnName isEqualToString:@"data3"]) {
                        data3 = [IMBHelper stringCorrectFormat:[IMBHelper stringFromHexString:dataStr]];
                    }
                }
            }
        }
    }
    if (![IMBHelper stringIsNilOrEmpty:data1]) {
        IMBContactLabelValueEntity *labelEntity = [[IMBContactLabelValueEntity alloc] init];
        if (![IMBHelper stringIsNilOrEmpty:data3]) {
            labelEntity.lable = data3;
        }else {
            if ([itemType isEqualToString:@"phone"]) {
                labelEntity.lable = CustomLocalizedString(@"contactLable_iphone",nil);
            }else if ([itemType isEqualToString:@"email"]) {
                labelEntity.lable = CustomLocalizedString(@"contact_id_42",nil);
            }else if ([itemType isEqualToString:@"im"]) {
                labelEntity.lable = CustomLocalizedString(@"contactLable_im",nil);
            }else if ([itemType isEqualToString:@"address"]) {
                labelEntity.lable = CustomLocalizedString(@"contact_id_81",nil);
            }else if ([itemType isEqualToString:@"event"]) {
                labelEntity.lable = CustomLocalizedString(@"contactLable_event",nil);
            }else if ([itemType isEqualToString:@"relation"]) {
                labelEntity.lable = CustomLocalizedString(@"contactLable_relation",nil);
            }else {
                labelEntity.lable = CustomLocalizedString(@"contactLable_iphone",nil);
            }
        }
        labelEntity.lacleType = data2.intValue;
        labelEntity.value = data1;
        
        NSPredicate *pre = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            IMBContactLabelValueEntity *item = (IMBContactLabelValueEntity *)evaluatedObject;
            if ([[item value] isEqualToString:labelEntity.value]) {
                return YES;
            }else {
                return NO;
            }
        }];
        
        if ([itemType isEqualToString:@"phone"]) {
            NSArray *preArray = [contactEntity.phoneData filteredArrayUsingPredicate:pre];
            if (preArray == nil || preArray.count == 0) {
                isChange = YES;
                IMBContactLabelValueEntity *item = [contactEntity.phoneData lastObject];
                if (item != nil) {
                    labelEntity.lable = item.lable;
                    labelEntity.lacleType = item.lacleType;
                }
                labelEntity.isDeleted = YES;
                if (!contactEntity.isDeleted) {
                    contactEntity.isHaveExistAndDeleted = YES;
                }
                [contactEntity.phoneData addObject:labelEntity];
            }
        }else if ([itemType isEqualToString:@"email"]) {
            NSArray *preArray = [contactEntity.emailData filteredArrayUsingPredicate:pre];
            if (preArray == nil || preArray.count == 0) {
                isChange = YES;
                IMBContactLabelValueEntity *item = [contactEntity.emailData lastObject];
                if (item != nil) {
                    labelEntity.lable = item.lable;
                    labelEntity.lacleType = item.lacleType;
                }
                labelEntity.isDeleted = YES;
                if (!contactEntity.isDeleted) {
                    contactEntity.isHaveExistAndDeleted = YES;
                }
                [contactEntity.emailData addObject:labelEntity];
            }
        }else if ([itemType isEqualToString:@"im"]) {
            NSArray *preArray = [contactEntity.imData filteredArrayUsingPredicate:pre];
            if (preArray == nil || preArray.count == 0) {
                isChange = YES;
                IMBContactLabelValueEntity *item = [contactEntity.imData lastObject];
                if (item != nil) {
                    labelEntity.lable = item.lable;
                    labelEntity.lacleType = item.lacleType;
                }
                labelEntity.isDeleted = YES;
                if (!contactEntity.isDeleted) {
                    contactEntity.isHaveExistAndDeleted = YES;
                }
                [contactEntity.imData addObject:labelEntity];
            }
        }else if ([itemType isEqualToString:@"address"]) {
            NSArray *preArray = [contactEntity.addressData filteredArrayUsingPredicate:pre];
            if (preArray == nil || preArray.count == 0) {
                isChange = YES;
                IMBContactLabelValueEntity *item = [contactEntity.addressData lastObject];
                if (item != nil) {
                    labelEntity.lable = item.lable;
                    labelEntity.lacleType = item.lacleType;
                }
                labelEntity.isDeleted = YES;
                if (!contactEntity.isDeleted) {
                    contactEntity.isHaveExistAndDeleted = YES;
                }
                [contactEntity.addressData addObject:labelEntity];
            }
        }else if ([itemType isEqualToString:@"event"]) {
            NSArray *preArray = [contactEntity.eventData filteredArrayUsingPredicate:pre];
            if (preArray == nil || preArray.count == 0) {
                isChange = YES;
                IMBContactLabelValueEntity *item = [contactEntity.eventData lastObject];
                if (item != nil) {
                    labelEntity.lable = item.lable;
                    labelEntity.lacleType = item.lacleType;
                }
                labelEntity.isDeleted = YES;
                if (!contactEntity.isDeleted) {
                    contactEntity.isHaveExistAndDeleted = YES;
                }
                [contactEntity.eventData addObject:labelEntity];
            }
        }else if ([itemType isEqualToString:@"relation"]) {
            NSArray *preArray = [contactEntity.relationData filteredArrayUsingPredicate:pre];
            if (preArray == nil || preArray.count == 0) {
                isChange = YES;
                IMBContactLabelValueEntity *item = [contactEntity.relationData lastObject];
                if (item != nil) {
                    labelEntity.lable = item.lable;
                    labelEntity.lacleType = item.lacleType;
                }
                labelEntity.isDeleted = YES;
                if (!contactEntity.isDeleted) {
                    contactEntity.isHaveExistAndDeleted = YES;
                }
                [contactEntity.relationData addObject:labelEntity];
            }
        }
        
        [labelEntity release];
    }
    return isChange;
}

- (void)addContentToContactEntity:(IMBADContactEntity *)contactEntity withRs:(FMResultSet *)rs withItemType:(NSString *)itemType {
    NSString *data1 = nil;
    NSString *data2 = nil;
    NSString *data3 = nil;
    if (![rs columnIsNull:@"data1"]) {
        data1 = [rs stringForColumn:@"data1"];
    }else if (![rs columnIsNull:@"data2"]) {
        data2 = [rs stringForColumn:@"data2"];
    }else if (![rs columnIsNull:@"data3"]) {
        data3 = [rs stringForColumn:@"data3"];
    }
    if (![IMBHelper stringIsNilOrEmpty:data1]) {
        IMBContactLabelValueEntity *labelEntity = [[IMBContactLabelValueEntity alloc] init];
        if (![IMBHelper stringIsNilOrEmpty:data3]) {
            labelEntity.lable = data3;
        }else {
            if ([itemType isEqualToString:@"phone"]) {
                labelEntity.lable = CustomLocalizedString(@"contactLable_iphone",nil);
            }else if ([itemType isEqualToString:@"email"]) {
                labelEntity.lable = CustomLocalizedString(@"contact_id_42",nil);
            }else if ([itemType isEqualToString:@"im"]) {
                labelEntity.lable = CustomLocalizedString(@"contactLable_im",nil);
            }else if ([itemType isEqualToString:@"address"]) {
                labelEntity.lable = CustomLocalizedString(@"contact_id_81",nil);
            }else if ([itemType isEqualToString:@"event"]) {
                labelEntity.lable = CustomLocalizedString(@"contactLable_event",nil);
            }else if ([itemType isEqualToString:@"relation"]) {
                labelEntity.lable = CustomLocalizedString(@"contactLable_relation",nil);
            }else {
                labelEntity.lable = CustomLocalizedString(@"contactLable_iphone",nil);
            }
        }
        labelEntity.lacleType = data2.intValue;
        labelEntity.value = data1;
        
        if ([itemType isEqualToString:@"phone"]) {
            labelEntity.isDeleted = YES;
            [contactEntity.phoneData addObject:labelEntity];
        }else if ([itemType isEqualToString:@"email"]) {
            labelEntity.isDeleted = YES;
            [contactEntity.emailData addObject:labelEntity];
        }else if ([itemType isEqualToString:@"im"]) {
            labelEntity.isDeleted = YES;
            [contactEntity.imData addObject:labelEntity];
        }else if ([itemType isEqualToString:@"address"]) {
            labelEntity.isDeleted = YES;
            [contactEntity.addressData addObject:labelEntity];
        }else if ([itemType isEqualToString:@"event"]) {
            labelEntity.isDeleted = YES;
            [contactEntity.eventData addObject:labelEntity];
        }else if ([itemType isEqualToString:@"relation"]) {
            labelEntity.isDeleted = YES;
            [contactEntity.relationData addObject:labelEntity];
        }
        [labelEntity release];
    }
}

#pragma mark - export
- (int)exportContent:(NSString *)targetPath ContentList:(NSArray *)exportArr exportType:(NSString *)type{
    [_loghandle writeInfoLog:@"ContactExport DoProgress enter"];
    int result = 0;
    if ([IMBFileHelper stringIsNilOrEmpty:targetPath]) {
        return -2;
    }
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"MenuItem_id_61", nil)];
    }
    _currCount = 0;
    _currSize = 0;
    _successCount = 0;
    _failedCount = 0;
    _totalCount = (int)exportArr.count;
    if ([_transDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transDelegate transferPrepareFileEnd];
    }
    if ([type isEqualToString:@"vcf"]) {
        [_loghandle writeInfoLog:@"ContactExport vcf DoProgress enter"];
        [self contactExportVCF:targetPath exportArray:exportArr];
        [_loghandle writeInfoLog:@"ContactExport vcf DoProgress Complete"];

    }else if ([type isEqualToString:@"csv"]) {
        [_loghandle writeInfoLog:@"ContactExport csv DoProgress enter"];
        [self contactExportCSV:targetPath exportArray:exportArr];
        [_loghandle writeInfoLog:@"ContactExport csv DoProgress Complete"];

    }
    sleep(1);
    if ([_transDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transDelegate transferComplete:_successCount TotalCount:_totalCount];
    }
    [_loghandle writeInfoLog:@"ContactExport DoProgress Complete"];
    return result;
}

#pragma mark - export CSV
-(void)contactExportCSV:(NSString *)exportPath exportArray:(NSArray *)exportArr{
    if (exportArr != nil) {
        NSString *exPath = [exportPath stringByAppendingPathComponent:[CustomLocalizedString(@"MenuItem_id_61", nil) stringByAppendingString:@".csv"]];
        if ([_fileManager fileExistsAtPath:exPath]) {
            exPath = [IMBFileHelper getFilePathAlias:exPath];
        }
        
        [_fileManager createFileAtPath:exPath contents:nil attributes:nil];
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exPath];
        NSString *conString = [self tableTitleString];
        for (IMBADContactEntity *entity in exportArr) {
            @autoreleasepool {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }

                _currCount++;
                if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transDelegate transferFile:[entity contactSortName]];
                }
                conString = [conString stringByAppendingString:@"\r\n"];
                conString = [conString stringByAppendingString:[self eachContactInfoByCSVOther:entity]];
                
                NSData *retData = [conString dataUsingEncoding:NSUTF8StringEncoding];
                [handle writeData:retData];
                conString = @"";
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

- (NSString *)eachContactInfoByCSVOther:(IMBADContactEntity *)item {
    NSString *itemString = @"";
    if (item != nil) {
        if (item.contactName != nil && ![IMBFileHelper stringIsNilOrEmpty:item.contactName.value]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.contactName.value]];
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.phoneData.count > 0) {
            for (int i = 0; i < item.phoneData.count; i++) {
                if (_isStop) {
                    break;
                }
                IMBContactLabelValueEntity *entity = [item.phoneData objectAtIndex:i];
                if (entity.lable == nil) {
                    entity.lable = @"";
                }
                if (entity.value == nil) {
                    entity.value = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.lable]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.value]];
                if (i < item.phoneData.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
                
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.emailData.count > 0) {
            for (int i = 0; i < item.emailData.count - 1; i++) {
                if (_isStop) {
                    break;
                }
                IMBContactLabelValueEntity *entity = [item.emailData objectAtIndex:i];
                if (entity.lable == nil) {
                    entity.lable = @"";
                }
                if (entity.value == nil) {
                    entity.value = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.lable]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.value]];
                if (i < item.emailData.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.websiteData.count > 0) {
            for (int i = 0; i < item.websiteData.count - 1; i++) {
                if (_isStop) {
                    break;
                }
                IMBContactLabelValueEntity *entity = [item.websiteData objectAtIndex:i];
                if (entity.lable == nil) {
                    entity.lable = @"";
                }
                if (entity.value == nil) {
                    entity.value = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.lable]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.value]];
                if (i < item.websiteData.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.addressData.count > 0) {
            for (int i = 0; i < item.addressData.count - 1; i++) {
                if (_isStop) {
                    break;
                }
                IMBContactLabelValueEntity *entity = [item.addressData objectAtIndex:i];
                if (entity.lable == nil) {
                    entity.lable = @"";
                }
                if (entity.value == nil) {
                    entity.value = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.lable]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.value]];
                if (i < item.addressData.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
            }
        }
        
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.eventData.count > 0) {
            for (int i = 0; i < item.eventData.count - 1; i++) {
                if (_isStop) {
                    break;
                }
                IMBContactLabelValueEntity *entity = [item.eventData objectAtIndex:i];
                if (entity.lable == nil) {
                    entity.lable = @"";
                }
                if (entity.value == nil) {
                    entity.value = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.lable]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.value]];
                if (i < item.eventData.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
            }
        }

        itemString = [itemString stringByAppendingString:@","];
        
        if (item.relationData.count > 0) {
            for (int i = 0; i < item.relationData.count - 1; i++) {
                if (_isStop) {
                    break;
                }
                IMBContactLabelValueEntity *entity = [item.relationData objectAtIndex:i];
                if (entity.lable == nil) {
                    entity.lable = @"";
                }
                if (entity.value == nil) {
                    entity.value = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.lable]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.value]];
                if (i < item.relationData.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.imData.count > 0) {
            for (int i = 0; i < item.imData.count - 1; i++) {
                if (_isStop) {
                    break;
                }
                IMBContactLabelValueEntity *entity = [item.imData objectAtIndex:i];
                if (entity.lable == nil) {
                    entity.lable = @"";
                }
                if (entity.value == nil) {
                    entity.value = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.lable]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.value]];
                if (i < item.imData.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        if (item.contactNote != nil && ![IMBFileHelper stringIsNilOrEmpty:item.contactNote.value]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:[item.contactNote.value stringByReplacingOccurrencesOfString:@"\n" withString:@" "]]];
        }
    }
    return itemString;
}

- (NSString *)covertSpecialChar:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        if (![IMBFileHelper stringIsNilOrEmpty:str]) {
            NSString *string = [str stringByReplacingOccurrencesOfString:@"," withString:@"&c;a&"];
            return string;
        }else {
            return str;
        }
    }else {
        return [NSString stringWithFormat:@"%@",str];
    }
    return str;
}

- (NSString *)tableTitleString {
    NSString *titleString = @"";
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"List_Header_id_Name", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"List_Header_id_Phone", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"contact_id_42", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"List_Header_id_URL", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"contact_id_81", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"List_Header_id_Date", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"contactLable_relation", nil)];
        titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"contactLable_im", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"contact_id_91", nil)];
    return titleString;
}

#pragma mark export vcf
-(void)contactExportVCF:(NSString *)exportPath  exportArray:(NSArray *)exportArr{
    if (exportArr.count>0) {
        for (IMBADContactEntity *entity in exportArr) {
            @autoreleasepool {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                _currCount ++;
                if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transDelegate transferFile:[entity contactSortName]];
                }
                NSString *exFilePath = nil;
                entity.contactName.value = [entity.contactName.value stringByReplacingOccurrencesOfString:@"/" withString:@""];
                if (![IMBFileHelper stringIsNilOrEmpty:entity.contactSortName]) {
                    exFilePath = [exportPath stringByAppendingPathComponent:[entity.contactSortName stringByAppendingPathExtension:@"vcf"]];
                } else {
                    exFilePath = [exportPath stringByAppendingPathComponent:[entity.companyName.value stringByAppendingPathExtension:@"vcf"]];
                }
                if ([_fileManager fileExistsAtPath:exFilePath]) {
                    exFilePath = [IMBFileHelper getFilePathAlias:exFilePath];
                }
                BOOL success  = [_fileManager createFileAtPath:exFilePath contents:nil attributes:nil];
                NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exFilePath];
                NSString *contentString = @"";
                contentString = [contentString stringByAppendingString:@"BEGIN:VCARD\r\n"];
                contentString = [contentString stringByAppendingString:@"VERSION:3.0\r\n"];
                contentString = [contentString stringByAppendingString:[self eachContactInfoByVCFOther:(IMBADContactEntity *)entity]];
                contentString = [contentString stringByAppendingString:@"END:VCARD"];
                NSData *retData = [contentString dataUsingEncoding:NSUTF8StringEncoding];
                [handle writeData:retData];
                [handle closeFile];
                
                float progress = (((float)_currCount / _totalCount) * 100);
                if ([_transDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_transDelegate transferProgress:progress];
                }
                if (success) {
                    _successCount ++;
                }else {
                    [_loghandle writeErrorLog:[@"contactToMacErrorrName:" stringByAppendingString:entity.contactName.value?:@""]];
                }
            }
        }
    }
}

- (NSString *)eachContactInfoByVCFOther:(IMBADContactEntity *)item {
    NSString *contactString = @"";
    if (item != nil) {
        contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"FN;CHARSET=utf-8:%@\r\n",item.contactName.value]];
        contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"N;CHARSET=utf-8:%@;%@;%@;\r\n",item.contactFirstName.value?:@"",item.contactLastName.value?:@"",item.contactMiddleName.value?:@""]];
       
        if (item.contactNote != nil && ![IMBFileHelper stringIsNilOrEmpty:item.contactNote.value]) {
                NSString *note = [item.contactNote.value stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"NOTE;CHARSET=utf-8:%@\r\n",note]];
        }
        if (item.companyName != nil && ![IMBFileHelper stringIsNilOrEmpty:item.companyName.value]) {
            contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"ORG;CHARSET=utf-8:%@\r\n",item.companyName.value]];
        }
        if (item.companyJob != nil && ![IMBFileHelper stringIsNilOrEmpty:item.companyJob.value]) {
            contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"TITLE;CHARSET=utf-8:%@\r\n",item.companyJob.value]];
        }
        if (item.contactNickName != nil && ![IMBFileHelper stringIsNilOrEmpty:item.contactNickName.value]) {
            contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"NICKNAME;CHARSET=utf-8:%@\r\n",item.contactNickName.value]];
        }
        int j = 0;
        if (item.phoneData.count > 0) {
            for (IMBContactLabelValueEntity *numberEntity in item.phoneData) {
                if(numberEntity.lable.length>0){
                    NSString *string = [NSString stringWithFormat:@"item%d.TEL:%@\n",j,numberEntity.value];
                    NSString *string1 = [NSString stringWithFormat:@"item%d.X-ABLabel:%@\n",j,numberEntity.lable];
                    contactString = [contactString stringByAppendingString:string];
                    contactString = [contactString stringByAppendingString:string1];
                    j++;
                }
            }
        }
        if (item.emailData.count > 0) {
            for (IMBContactLabelValueEntity *emailEntity in item.emailData) {
               
                if(emailEntity.lable.length > 0){
                    NSString *string = [NSString stringWithFormat:@"item%d.EMAIL;TYPE=OTHER;INTERNET:%@\n",j,emailEntity.value];
                    NSString *string1 = [NSString stringWithFormat:@"item%d.X-ABLabel:%@\n",j,emailEntity.lable];
                    contactString = [contactString stringByAppendingString:string];
                    contactString = [contactString stringByAppendingString:string1];
                    j++;
                }
            }
        }
        if (item.websiteData.count > 0) {
            for (IMBContactLabelValueEntity *entity in item.websiteData) {
                NSString *url = entity.value;
                if(url.length>0){
                    NSString *string = [NSString stringWithFormat:@"item%d.URL:%@\n",j,url];
                    NSString *string1 = [NSString stringWithFormat:@"item%d.X-ABLabel:%@\n",j,@"other"];
                    contactString = [contactString stringByAppendingString:string];
                    contactString = [contactString stringByAppendingString:string1];
                    j++;
                }
            }
        }
        if (item.addressData.count > 0) {
            for (IMBContactLabelValueEntity *addrEntity in item.addressData) {
                if(addrEntity.lable.length>0){
                    NSString *string = [NSString stringWithFormat:@"item%d.ADR:;;%@;%@;%@;%@;%@\n",j,addrEntity.value==nil?@"":addrEntity.value,@"",@"",@"",@""];
                    NSString *string1 = [NSString stringWithFormat:@"item%d.X-ABLabel:%@\n",j,addrEntity.lable];
                    contactString = [contactString stringByAppendingString:string];
                    contactString = [contactString stringByAppendingString:string1];
                    j++;
                }
            }
        }
        if (item.imData.count > 0) {
            for (IMBContactLabelValueEntity *imEntity in item.imData) {
                if(imEntity.lable.length>0){
                    contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"item%d.IMPP;X-SERVICE-TYPE=%@;:%@\n",j,imEntity.lable,imEntity.value]];
                    NSString *string1 = [NSString stringWithFormat:@"item%d.X-ABLabel:%@\n",j,imEntity.lable];
                    contactString = [contactString stringByAppendingString:string1];
                    j++;
                }
            }
        }
        
        if (item.relationData.count>0) {
            for (IMBContactLabelValueEntity *relatedEntity in item.relationData) {
                if (relatedEntity.lable.length>0) {
                    NSString *string = [NSString stringWithFormat:@"item%d.X-ABRELATEDNAMES:%@\n",j,relatedEntity.value];
                    NSString *string1 = [NSString stringWithFormat:@"item%d.X-ABLabel:%@\n",j,relatedEntity.lable];
                    contactString = [contactString stringByAppendingString:string];
                    contactString = [contactString stringByAppendingString:string1];
                    j++;
                }
            }
        }
        if (item.eventData.count > 0) {
            for (IMBContactLabelValueEntity *dateEntity in item.eventData) {
                if (dateEntity.value != nil) {
                    if (dateEntity.lable.length>0) {
                        NSString *string = [NSString stringWithFormat:@"item%d.X-ABDATE:%@\n",j,dateEntity.value];
                        NSString *string1 = [NSString stringWithFormat:@"item%d.X-ABLabel:%@\n",j,dateEntity.lable];
                        contactString = [contactString stringByAppendingString:string];
                        contactString = [contactString stringByAppendingString:string1];
                        j++;
                    }
                }
            }
        }
    }
    return contactString;
}


#pragma mark - import
- (int)importContent:(NSArray *)importArr {
    if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferPrepareFileStart:)]) {
        [_transDelegate transferPrepareFileStart:CustomLocalizedString(@"MenuItem_id_61", nil)];
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
        for (IMBADContactEntity *entity in importArr) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }

            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transDelegate transferFile:[entity contactSortName]];
            }
            _currCount ++;
            BOOL isSuccess = NO;
            NSDictionary *entityDic = [entity objectToDictionary:entity];
            NSString *entityJson = [IMBFileHelper dictionaryToJson:entityDic];
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:entityJson, @"ADDCONTACT", nil];
            NSString *jsonStr = [self createParamsjJsonCommand:CONTACT Operate:IMPORT ParamDic:paramDic];
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
                    result = -2;
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
        for (IMBADContactEntity *entity in deleteArr) {
            if (_transDelegate != nil && [_transDelegate respondsToSelector:@selector(transferFile:)]) {
                [_transDelegate transferFile:entity.contactSortName];
            }
            _currCount ++;
            BOOL isSuccess = NO;
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",entity.contactID], @"contactID", nil];
            NSString *jsonStr = [self createParamsjJsonCommand:CONTACT Operate:DELETE ParamDic:paramDic];
            if (![IMBFileHelper stringIsNilOrEmpty:jsonStr]) {
                isSuccess = [coreSocket launchDeleteRequestContent:jsonStr FinishBlock:^(NSData *data) {
                    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"delete msg:%@",msg);
                    [msg release];
                }];
                if (!isSuccess){
                    result = -1;
                    NSLog(@"delete launch request failed");
                }
            }else {
                result = -2;
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
