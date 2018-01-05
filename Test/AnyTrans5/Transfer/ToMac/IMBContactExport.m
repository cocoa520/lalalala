//
//  IMBContactExport.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-7.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBContactExport.h"
#import "DateHelper.h"
#import "IMBAddressBookDataEntity.h"
#import "IMBContactEntity.h"
#import <AddressBook/AddressBook.h>
#import "RegexKitLite.h"
#import "StringHelper.h"
#import "IMBTransferError.h"

@implementation IMBContactExport
@synthesize contactManager = _contactManager;

- (void)startTransfer {
    [_loghandle writeInfoLog:@"ContactExport DoProgress enter"];
    if (!_isAllExport) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
    }
    if ([_mode isEqualToString:@"vcf"]) {
        [self contactExportVCF:_exportPath];
    }else if ([_mode isEqualToString:@"csv"]) {
        [self contactExportCSV:_exportPath];
    }
    if (!_isAllExport) {
        sleep(2);
        if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
            [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
        }
    }
    [_loghandle writeInfoLog:@"ContactExport DoProgress Complete"];
}

#pragma mark - export VCF
-(void)contactExportVCF:(NSString *)exportPath{
    if (_exportTracks.count != 0&&_exportTracks != nil) {
        for (IMBAddressBookDataEntity *entity in _exportTracks) {
            if (_limitation.remainderCount == 0) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:entity.allName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                continue;
            }
            @autoreleasepool {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                     [[IMBTransferError singleton] addAnErrorWithErrorName:entity.allName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    continue;
                }
                _currItemIndex ++;
                NSString *exFilePath = nil;
                entity.allName = [entity.allName stringByReplacingOccurrencesOfString:@"/" withString:@""];
                if (![TempHelper stringIsNilOrEmpty:entity.allName]) {
                    exFilePath = [exportPath stringByAppendingPathComponent:[entity.allName stringByAppendingPathExtension:@"vcf"]];
                } else if (![TempHelper stringIsNilOrEmpty:entity.companyName]) {
                    exFilePath = [exportPath stringByAppendingPathComponent:[entity.companyName stringByAppendingPathExtension:@"vcf"]];
                }else {
                     exFilePath = [exportPath stringByAppendingPathComponent:[CustomLocalizedString(@"contact_id_48", nil) stringByAppendingPathExtension:@"vcf"]];
                }
                if ([_fileManager fileExistsAtPath:exFilePath]) {
                    exFilePath = [TempHelper getFilePathAlias:exFilePath];
                }
                BOOL success  = [_fileManager createFileAtPath:exFilePath contents:nil attributes:nil];
                NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exFilePath];
                NSString *contentString = @"";
                contentString = [contentString stringByAppendingString:@"BEGIN:VCARD\r\n"];
                contentString = [contentString stringByAppendingString:@"VERSION:3.0\r\n"];
                if ([entity isKindOfClass:[IMBAddressBookDataEntity class]]) {
                    contentString = [contentString stringByAppendingString:[self eachContactInfoByVCF:entity]];
                }else if ([entity isKindOfClass:[IMBContactEntity class]]) {
                    contentString = [contentString stringByAppendingString:[self eachContactInfoByVCFOther:(IMBContactEntity *)entity]];
                }
                contentString = [contentString stringByAppendingString:@"END:VCARD"];
                
                NSData *retData = [contentString dataUsingEncoding:NSUTF8StringEncoding];
                [handle writeData:retData];
                [handle closeFile];
                
                
                if (_currItemIndex > _totalItemCount) {
                    _currItemIndex = _totalItemCount;
                }
                
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),entity.allName]];
                }
                float progress = (((float)_currItemIndex / _totalItemCount) * 100) / _totalItem + _percent;
                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_transferDelegate transferProgress:progress];
                }
                if (success ) {
                     _successCount ++;
                }else {
                    NSLog(@"**********************contactToMacErrorrName:=%@",entity.allName);
                    [[IMBLogManager singleton] writeErrorLog:[@"contactToMacErrorrName:" stringByAppendingString:entity.allName?:@""]];
                }
                [_limitation reduceRedmainderCount];
            }
        }
    }
}

- (NSString *)eachContactInfoByVCF:(IMBAddressBookDataEntity *)item {
    NSString *contactString = @"";
    if (item != nil) {
        contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"FN;CHARSET=utf-8:%@\r\n",item.allName]];
        contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"N;CHARSET=utf-8:%@;%@;%@;\r\n",item.firstName,item.lastName,item.middleName]];
        if (item.birthdayDate != 0) {
            contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"BDAY:%@\r\n",[DateHelper dateFrom2001ToString:item.birthdayDate withMode:1]]];
        }
        if (![TempHelper stringIsNilOrEmpty:item.notes]) {
            NSString *note = [item.notes stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"NOTE;CHARSET=utf-8:%@\r\n",note]];
        }
        if (![TempHelper stringIsNilOrEmpty:item.companyName]) {
            contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"ORG;CHARSET=utf-8:%@;%@\r\n",item.companyName,item.department]];
        }
        if (![TempHelper stringIsNilOrEmpty:item.jobTitle]) {
            contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"TITLE;CHARSET=utf-8:%@\r\n",item.jobTitle]];
        }
        if (item.numberArray != nil && item.numberArray.count > 0) {
            for (IMBAddressBookMultDataEntity *entity in item.numberArray) {
                
                
                contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"TEL;TYPE=%@:%@\r\n",entity.lableType,entity.multValue]];
            }
        }
        if (item.emailArray != nil && item.emailArray.count > 0) {
            for (IMBAddressBookMultDataEntity *entity in item.emailArray) {
                contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"EMAIL;TYPE=%@:%@\r\n",entity.lableType,entity.multValue]];
            }
        }
        if (item.URLArray != nil && item.URLArray.count > 0) {
            for (IMBAddressBookMultDataEntity *entity in item.URLArray) {
                contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"URL;TYPE=%@:%@\r\n",entity.lableType,entity.multValue]];
            }
        }
        if (item.streetArray != nil && item.streetArray.count > 0) {
            for (IMBAddressBookMultDataEntity *entity in item.streetArray) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                if (entity.multiArray != nil && entity.multiArray.count > 0) {
                    NSString *streetStr = @"";
                    NSString *cityStr = @"";
                    NSString *stateStr = @"";
                    NSString *postalCodeStr = @"";
                    NSString *countryStr = @"";
                    NSString *countryCodeStr = @"";
                    for (IMBAddressBookDetailEntity *detail in entity.multiArray) {
                        if ([detail.entityType isEqualToString:@"country"]) {
                            countryStr = detail.detailValue;
                        }else if ([detail.entityType isEqualToString:@"street"]) {
                            streetStr = [detail.detailValue stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
//                            streetStr = detail.detailValue;
                        }else if ([detail.entityType isEqualToString:@"postal code"]) {
                            postalCodeStr = detail.detailValue;
                        }else if ([detail.entityType isEqualToString:@"city"]) {
                            cityStr = detail.detailValue;
                        }else if ([detail.entityType isEqualToString:@"country code"]) {
                            countryCodeStr = detail.detailValue;
                        }else if ([detail.entityType isEqualToString:@"state"]) {
                            stateStr = detail.detailValue;
                        }
                    }
                    contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"ADR;TYPE=%@:;%@;%@;%@;%@;%@;%@\n",entity.lableType,countryStr,stateStr,cityStr,streetStr,postalCodeStr,countryCodeStr]];
                }
            }
        }
        if (item.IMArray != nil && item.IMArray.count > 0) {
            for (IMBAddressBookMultDataEntity *entity in item.IMArray) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                if (entity.multiArray != nil && entity.multiArray.count > 0) {
                    NSString *serverStr = @"";
                    NSString *userStr = @"";
                    for (IMBAddressBookDetailEntity *detail in entity.multiArray) {
                        if ([detail.entityType isEqualToString:@"user"]) {
                            userStr = detail.detailValue;
                        }else if ([detail.entityType isEqualToString:@"service"]) {
                            serverStr =  detail.detailValue;
                        }
                    }
                    contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"X-%@;TYPE=%@:%@\r\n",serverStr,entity.lableType,userStr]];
                }
            }
        }
        if (item.specialURLArray != nil && item.specialURLArray.count > 0) {
            for (IMBAddressBookMultDataEntity *entity in item.specialURLArray) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                if (entity.multiArray != nil && entity.multiArray.count > 0) {
                    NSString *serverStr = @"";
                    NSString *userStr = @"";
                    for (IMBAddressBookDetailEntity *detail in entity.multiArray) {
                        if ([detail.entityType isEqualToString:@"user"]) {
                            userStr = detail.detailValue;
                        }else if ([detail.entityType isEqualToString:@"service"]) {
                            serverStr =  detail.detailValue;
                        }
                    }
                    contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"X-%@;TYPE=%@:%@\r\n",serverStr,entity.lableType,userStr]];
                }
            }
        }
        if (item.relatedArray != nil && item.relatedArray.count > 0) {
            for (IMBAddressBookMultDataEntity *entity in item.relatedArray) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"X-%@;TYPE=%@:%@\r\n",entity.lableType,entity.lableType,entity.multValue]];
            }
        }
        if (item.dateArray != nil && item.dateArray.count > 0) {
            for (IMBAddressBookMultDataEntity *entity in item.dateArray) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"X-DATE;TYPE=%@:%@\r\n",entity.lableType,[DateHelper dateFrom2001ToString:(long)[entity.multValue longLongValue] withMode:1]]];
            }
        }
    }
    return contactString;
}

- (NSString *)eachContactInfoByVCFOther:(IMBContactEntity *)item {
    NSString *contactString = @"";
    if (item != nil) {
        contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"FN;CHARSET=utf-8:%@\r\n",item.allName]];
        contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"N;CHARSET=utf-8:%@;%@;%@;\r\n",item.firstName?:@"",item.lastName?:@"",item.middleName?:@""]];
        if (item.birthday != nil) {
            contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"BDAY:%@\r\n",[DateHelper stringFromFomate:item.birthday formate:@"yyyy-MM-dd"]]];
        }
        if (![TempHelper stringIsNilOrEmpty:item.notes]) {
            if (item.notes ) {
               NSString *note = [item.notes stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"NOTE;CHARSET=utf-8:%@\r\n",note]];
            }
        }
        if (![TempHelper stringIsNilOrEmpty:item.companyName]) {
            contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"ORG;CHARSET=utf-8:%@;%@\r\n",item.companyName,item.department]];
        }
        if (![TempHelper stringIsNilOrEmpty:item.jobTitle]) {
            contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"TITLE;CHARSET=utf-8:%@\r\n",item.jobTitle]];
        }
        int j = 0;
        if (item.phoneNumberArray != nil && item.phoneNumberArray.count > 0) {
            for (IMBContactKeyValueEntity *numberEntity in item.phoneNumberArray) {
                NSString *type = numberEntity.type;
                if ([type.lowercaseString isEqualToString:@"mobile"]) {
                    type = @"cell;voice".uppercaseString;
                }
                else if([type.lowercaseString isEqualToString:@"home fax"]){
                    type = @"home;fax".uppercaseString;
                }
                else if([type.lowercaseString isEqualToString:@"work fax"]){
                    type = @"work;fax".uppercaseString;
                }
                else if([type.lowercaseString isEqualToString:@"other fax"]){
                    type = @"other;fax".uppercaseString;
                }
                else if([type.lowercaseString isEqualToString:@"main"]){
                    type =  @"main".uppercaseString;
                }
                else if([type.lowercaseString isEqualToString:@"home"]){
                    type = @"home;voice".uppercaseString;
                }
                else if([type.lowercaseString isEqualToString:@"work"]){
                    type = @"work;voice".uppercaseString;
                }
                else if([type.lowercaseString isEqualToString:@"pager"]){
                    type = @"pager".uppercaseString;
                }
                else {
                    type = [[NSString stringWithFormat:@"other;voice"] uppercaseString];
                    
                }
                if(numberEntity.label != nil && ![numberEntity.label isEqualToString:@""]){
                    NSString *string = [NSString stringWithFormat:@"item%d.TEL:%@\n",j,numberEntity.value];
                    NSString *string1 = [NSString stringWithFormat:@"item%d.X-ABLabel:%@\n",j,numberEntity.label];
                    contactString = [contactString stringByAppendingString:string];
                    contactString = [contactString stringByAppendingString:string1];
                    j++;
                }
                else{
                    contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"TEL;TYPE=%@:%@\n",type,numberEntity.value]];
                }
            }
        }
        if (item.emailAddressArray != nil && item.emailAddressArray.count > 0) {
            for (IMBContactKeyValueEntity *emailEntity in item.emailAddressArray) {
                NSString *type = [emailEntity.type.uppercaseString stringByReplacingOccurrencesOfString:@" " withString:@""];
                if(emailEntity.label != nil && ![emailEntity.label isEqualToString:@""]){
                    NSString *string = [NSString stringWithFormat:@"item%d.EMAIL;TYPE=OTHER;INTERNET:%@\n",j,emailEntity.value];
                    NSString *string1 = [NSString stringWithFormat:@"item%d.X-ABLabel:%@\n",j,emailEntity.label];
                    contactString = [contactString stringByAppendingString:string];
                    contactString = [contactString stringByAppendingString:string1];
                    j++;
                }
                else{
                    contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"EMAIL;TYPE=%@;INTERNET:%@\n",type,emailEntity.value]];
                }
            }
        }
        if (item.urlArray != nil && item.urlArray.count > 0) {
            for (IMBContactKeyValueEntity *urlEntity in item.urlArray) {
                NSString *type = [urlEntity.type.uppercaseString stringByReplacingOccurrencesOfString:@" " withString:@""];
                if(urlEntity.label != nil && ![urlEntity.label isEqualToString:@""]){
                    NSString *string = [NSString stringWithFormat:@"item%d.URL:%@\n",j,urlEntity.value];
                    NSString *string1 = [NSString stringWithFormat:@"item%d.X-ABLabel:%@\n",j,urlEntity.label];
                    contactString = [contactString stringByAppendingString:string];
                    contactString = [contactString stringByAppendingString:string1];
                    j++;
                    
                }
                else{
                    contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"URL;TYPE=%@:%@\n",type,urlEntity.value]];
                }
            }
        }
        if (item.addressArray != nil && item.addressArray.count > 0) {
            for (IMBContactAddressEntity *addrEntity in item.addressArray) {
                NSString *type = [addrEntity.type.uppercaseString stringByReplacingOccurrencesOfString:@" " withString:@""];
                if(addrEntity.label != nil && ![addrEntity.label isEqualToString:@""]){
                    NSString *street = [addrEntity.street stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                    NSString *string = [NSString stringWithFormat:@"item%d.ADR:;;%@;%@;%@;%@;%@\n",j,addrEntity.street==nil?@"":street,addrEntity.city==nil?@"":addrEntity.city,addrEntity.state==nil?@"":addrEntity.state,addrEntity.postalCode==nil?@"":addrEntity.postalCode,addrEntity.country==nil?@"":addrEntity.country];
                    NSString *string1 = [NSString stringWithFormat:@"item%d.X-ABLabel:%@\n",j,addrEntity.label];
                    contactString = [contactString stringByAppendingString:string];
                    contactString = [contactString stringByAppendingString:string1];
                    j++;
                }
                else{
                    contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"ADR;TYPE=%@;CHARSET=utf-8:;;%@;%@;%@;%@;%@\n",type,addrEntity.street==nil?@"":addrEntity.street,addrEntity.city==nil?@"":addrEntity.city,addrEntity.state==nil?@"":addrEntity.state,addrEntity.postalCode==nil?@"":addrEntity.postalCode,addrEntity.country==nil?@"":addrEntity.country]];
                }
            }
        }
        if (item.IMArray != nil && item.IMArray.count > 0) {
            for (IMBContactIMEntity *imEntity in item.IMArray) {
                NSString *type = [imEntity.type.uppercaseString stringByReplacingOccurrencesOfString:@" " withString:@""];
                if(imEntity.label != nil && ![imEntity.label isEqualToString:@""]){
                    contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"item%d.IMPP;X-SERVICE-TYPE=%@;:%@\n",j,imEntity.service,imEntity.user]];
                    NSString *string1 = [NSString stringWithFormat:@"item%d.X-ABLabel:%@\n",j,imEntity.label];
                    contactString = [contactString stringByAppendingString:string1];
                    j++;
                }
                else{
                    contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"IMPP;X-SERVICE-TYPE=%@;TYPE=%@:%@\n",imEntity.service,type,imEntity.user]];
                }
            }
        }
//        if (item.specialURLArray != nil && item.specialURLArray.count > 0) {
//            for (IMBAddressBookMultDataEntity *entity in item.specialURLArray) {
//                //                [_condition lock];
//                //                if ([ScanStatus shareInstance].isPause) {
//                //                    [_condition wait];
//                //                }
//                //                [_condition unlock];
//                if ([ScanStatus shareInstance].stopScan) {
//                    break;
//                }
//                if (entity.multiArray != nil && entity.multiArray.count > 0) {
//                    NSString *serverStr = @"";
//                    NSString *userStr = @"";
//                    for (IMBAddressBookDetailEntity *detail in entity.multiArray) {
//                        if ([detail.entityType isEqualToString:@"user"]) {
//                            userStr = detail.detailValue;
//                        }else if ([detail.entityType isEqualToString:@"service"]) {
//                            serverStr =  detail.detailValue;
//                        }
//                    }
//                    contactString = [contactString stringByAppendingString:[NSString stringWithFormat:@"X-%@;TYPE=%@:%@\r\n",serverStr,entity.lableType,userStr]];
//                }
//            }
//        }
        if (item.relatedNameArray != nil && item.relatedNameArray.count > 0) {
            for (IMBContactKeyValueEntity *relatedEntity in item.relatedNameArray) {
                if (relatedEntity.label != nil &&![relatedEntity.label isEqualToString:@""]) {
                    NSString *string = [NSString stringWithFormat:@"item%d.X-ABRELATEDNAMES:%@\n",j,relatedEntity.value];
                    NSString *string1 = [NSString stringWithFormat:@"item%d.X-ABLabel:%@\n",j,relatedEntity.label];
                    contactString = [contactString stringByAppendingString:string];
                    contactString = [contactString stringByAppendingString:string1];
                    j++;
                }else
                {
                    NSString *string = [NSString stringWithFormat:@"item%d.X-ABRELATEDNAMES:%@\n",j,relatedEntity.value];
                    NSString *string1 = [NSString stringWithFormat:@"item%d.X-ABLabel:%@\n",j,relatedEntity.type];
                    contactString = [contactString stringByAppendingString:string];
                    contactString = [contactString stringByAppendingString:string1];
                    j++;
                    
                }
                
            }
        }
        if (item.dateArray != nil && item.dateArray.count > 0) {
            for (IMBContactKeyValueEntity *dateEntity in item.dateArray) {
                if (dateEntity.value != nil) {
                    NSString *type = nil;
                    type = [dateEntity.type.uppercaseString stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
                    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Africa/Bamako"]];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                    
                    NSString *destDateString = [dateFormatter stringFromDate:dateEntity.value];
                    
                    [dateFormatter release];
                    
                    
                    if (dateEntity.label != nil) {
                        NSString *string = [NSString stringWithFormat:@"item%d.X-ABDATE:%@\n",j,destDateString];
                        NSString *string1 = [NSString stringWithFormat:@"item%d.X-ABLabel:%@\n",j,dateEntity.label];
                        contactString = [contactString stringByAppendingString:string];
                        contactString = [contactString stringByAppendingString:string1];
                        j++;
                    }
                    else{
                        NSString *string = [NSString stringWithFormat:@"X-ABDATE;type=%@:%@\n",dateEntity.type,destDateString];
                        contactString = [contactString stringByAppendingString:string];
                    }
                }
            }
        }
    }
    return contactString;
}

#pragma mark - export CSV
-(void)contactExportCSV:(NSString *)exportPath{
    if (_exportTracks.count != 0 &&_exportTracks != nil) {
        NSString *exPath = [exportPath stringByAppendingPathComponent:[CustomLocalizedString(@"MenuItem_id_20", nil) stringByAppendingString:@".csv"]];
        if ([_fileManager fileExistsAtPath:exPath]) {
            exPath = [TempHelper getFilePathAlias:exPath];
        }
        
        [_fileManager createFileAtPath:exPath contents:nil attributes:nil];
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exPath];
        NSString *conString = [self tableTitleString];
        for (IMBAddressBookDataEntity *entity in _exportTracks) {
            if (_limitation.remainderCount == 0) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:entity.allName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                continue;
            }
            @autoreleasepool {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                     [[IMBTransferError singleton] addAnErrorWithErrorName:entity.allName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    continue;
                }
                _currItemIndex ++;
                conString = [conString stringByAppendingString:@"\r\n"];
                if ([entity isKindOfClass:[IMBAddressBookDataEntity class]]) {
                    if ([self eachContactInfoByCSV:entity] != nil) {
                        conString = [conString stringByAppendingString:[self eachContactInfoByCSV:entity]];
                    }
                    
                }else if ([entity isKindOfClass:[IMBContactEntity class]]) {
                    if ([self eachContactInfoByCSVOther:(IMBContactEntity *)entity] != nil) {
                        conString = [conString stringByAppendingString:[self eachContactInfoByCSVOther:(IMBContactEntity *)entity]];
                    }
                }
                NSData *retData = [conString dataUsingEncoding:NSUTF8StringEncoding];
                [handle writeData:retData];
                conString = @"";
                
                if (_currItemIndex > _totalItemCount) {
                    _currItemIndex = _totalItemCount;
                }
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),entity.allName]];
                }
                float progress = (((float)_currItemIndex / _totalItemCount) * 100) / _totalItem + _percent;
                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_transferDelegate transferProgress:progress];
                }
                _successCount += 1;
                [_limitation reduceRedmainderCount];
            }
        }
        [handle closeFile];
    }
}
- (NSString *)eachContactInfoByCSV:(IMBAddressBookDataEntity *)item {
    NSString *itemString = @"";
    if (item != nil) {
        if (![TempHelper stringIsNilOrEmpty:item.allName]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.allName]];
        }
        itemString = [itemString stringByAppendingString:@","];
        if (item.birthdayDate != 0) {
            itemString = [itemString stringByAppendingString:[DateHelper dateFrom2001ToString:item.birthdayDate withMode:1]];
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.creationDate != 0) {
            itemString = [itemString stringByAppendingString:[DateHelper dateFrom2001ToString:item.creationDate withMode:1]];
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.numberArray != nil && item.numberArray.count > 0) {
            for (int i = 0; i < item.numberArray.count; i++) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                IMBAddressBookMultDataEntity *entity = [item.numberArray objectAtIndex:i];
                if (entity.lableType == nil) {
                    entity.lableType = @"";
                }
                if (entity.multValue == nil) {
                    entity.multValue = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.lableType]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.multValue]];
                if (i < item.numberArray.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
                
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.emailArray != nil && item.emailArray.count > 0) {
            for (int i = 0; i < item.emailArray.count - 1; i++) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                IMBAddressBookMultDataEntity *entity = [item.emailArray objectAtIndex:i];
                if (entity.lableType == nil) {
                    entity.lableType = @"";
                }
                if (entity.multValue == nil) {
                    entity.multValue = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.lableType]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.multValue]];
                if (i < item.emailArray.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.URLArray != nil && item.URLArray.count > 0) {
            for (int i = 0; i < item.URLArray.count - 1; i++) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                IMBAddressBookMultDataEntity *entity = [item.URLArray objectAtIndex:i];
                if (entity.lableType == nil) {
                    entity.lableType = @"";
                }
                if (entity.multValue == nil) {
                    entity.multValue = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.lableType]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.multValue]];
                if (i < item.URLArray.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.streetArray != nil && item.streetArray.count > 0) {
            for (IMBAddressBookMultDataEntity *entity in item.streetArray) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                if (entity.multiArray != nil && entity.multiArray.count > 0) {
                    NSString *streetStr = @"";
                    NSString *cityStr = @"";
                    NSString *stateStr = @"";
                    NSString *postalCodeStr = @"";
                    NSString *countryStr = @"";
                    NSString *countryCodeStr = @"";
                    for (IMBAddressBookDetailEntity *detail in entity.multiArray) {
                        if ([detail.entityType isEqualToString:@"country"]) {
                            countryStr = detail.detailValue;
                        }else if ([detail.entityType isEqualToString:@"street"]) {
                            streetStr = [detail.detailValue stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                        }else if ([detail.entityType isEqualToString:@"postal code"]) {
                            postalCodeStr = detail.detailValue;
                        }else if ([detail.entityType isEqualToString:@"city"]) {
                            cityStr = detail.detailValue;
                        }else if ([detail.entityType isEqualToString:@"country code"]) {
                            countryCodeStr = detail.detailValue;
                        }else if ([detail.entityType isEqualToString:@"state"]) {
                            stateStr = detail.detailValue;
                        }
                    }
                    itemString = [itemString stringByAppendingString:[NSString stringWithFormat:@"%@:%@ %@ %@ %@ %@ %@;  ",entity.lableType,countryStr,stateStr,cityStr,streetStr,postalCodeStr,countryCodeStr]];
                }
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.dateArray != nil && item.dateArray.count > 0) {
            for (int i = 0; i < item.dateArray.count - 1; i++) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                IMBAddressBookMultDataEntity *entity = [item.dateArray objectAtIndex:i];
                if (entity.lableType == nil) {
                    entity.lableType = @"";
                }
                if (entity.multValue == nil) {
                    entity.multValue = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.lableType]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.multValue]];
                if (i < item.dateArray.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.relatedArray != nil && item.relatedArray.count > 0) {
            for (int i = 0; i < item.relatedArray.count - 1; i++) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                IMBAddressBookMultDataEntity *entity = [item.relatedArray objectAtIndex:i];
                if (entity.lableType == nil) {
                    entity.lableType = @"";
                }
                if (entity.multValue == nil) {
                    entity.multValue = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.lableType]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.multValue]];
                if (i < item.relatedArray.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.specialURLArray != nil && item.specialURLArray.count > 0) {
            
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.IMArray != nil && item.IMArray.count > 0) {
            
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (![TempHelper stringIsNilOrEmpty:item.notes]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:[item.notes stringByReplacingOccurrencesOfString:@"\n" withString:@" "]]];
        }
        
    }
    return itemString;
}
- (NSString *)eachContactInfoByCSVOther:(IMBContactEntity *)item {
    NSString *itemString = @"";
    if (item != nil) {
        if (![TempHelper stringIsNilOrEmpty:item.allName]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.allName]];
        }
        itemString = [itemString stringByAppendingString:@","];
        if (item.birthday != nil) {
            if ([DateHelper stringFromFomate:item.birthday formate:@"yyyy-MM-dd"] != nil) {
                itemString = [itemString stringByAppendingString:[DateHelper stringFromFomate:item.birthday formate:@"yyyy-MM-dd"]];
            }
            
        }
        itemString = [itemString stringByAppendingString:@","];
        
//        if (item.creationDate != 0) {
//            itemString = [itemString stringByAppendingString:[DateHelper dateFrom2001ToString:item.creationDate withMode:1]];
//        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.phoneNumberArray != nil && item.phoneNumberArray.count > 0) {
            for (int i = 0; i < item.phoneNumberArray.count; i++) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                IMBContactKeyValueEntity *entity = [item.phoneNumberArray objectAtIndex:i];
                if (entity.type == nil) {
                    entity.type = @"";
                }
                if (entity.value == nil) {
                    entity.value = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.type]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.value]];
                if (i < item.phoneNumberArray.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
                
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.emailAddressArray != nil && item.emailAddressArray.count > 0) {
            for (int i = 0; i < item.emailAddressArray.count - 1; i++) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                IMBContactKeyValueEntity *entity = [item.emailAddressArray objectAtIndex:i];
                if (entity.type == nil) {
                    entity.type = @"";
                }
                if (entity.value == nil) {
                    entity.value = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.type]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.value]];
                if (i < item.emailAddressArray.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.urlArray != nil && item.urlArray.count > 0) {
            for (int i = 0; i < item.urlArray.count - 1; i++) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                IMBContactKeyValueEntity *entity = [item.urlArray objectAtIndex:i];
                if (entity.type == nil) {
                    entity.type = @"";
                }
                if (entity.value == nil) {
                    entity.value = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.type]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.value]];
                if (i < item.urlArray.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.addressArray != nil && item.addressArray.count > 0) {
            
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.dateArray != nil && item.dateArray.count > 0) {
            for (int i = 0; i < item.dateArray.count - 1; i++) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                IMBContactKeyValueEntity *entity = [item.dateArray objectAtIndex:i];
                if (entity.type == nil) {
                    entity.type = @"";
                }
                if (entity.value == nil) {
                    entity.value = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.type]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.value]];
                if (i < item.dateArray.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.relatedNameArray != nil && item.relatedNameArray.count > 0) {
            for (int i = 0; i < item.relatedNameArray.count - 1; i++) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                IMBContactKeyValueEntity *entity = [item.relatedNameArray objectAtIndex:i];
                if (entity.type == nil) {
                    entity.type = @"";
                }
                if (entity.value == nil) {
                    entity.value = @"";
                }
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.type]];
                itemString = [itemString stringByAppendingString:@" : "];
                itemString = [itemString stringByAppendingString:[self covertSpecialChar:entity.value]];
                if (i < item.relatedNameArray.count - 1) {
                    itemString = [itemString stringByAppendingString:@" ; "];
                }
            }
        }
        itemString = [itemString stringByAppendingString:@","];
        
//        if (item.specialURLArray != nil && item.specialURLArray.count > 0) {
//            
//        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.IMArray != nil && item.IMArray.count > 0) {
            
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (![TempHelper stringIsNilOrEmpty:item.notes]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:[item.notes stringByReplacingOccurrencesOfString:@"\n" withString:@" "]]];
        }
        
    }
    return itemString;
}
- (NSString *)covertSpecialChar:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        if (![TempHelper stringIsNilOrEmpty:str]) {
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
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"contact_id_89", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"backup_id_text_1", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"Calendar_id_15", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"Calendar_id_16", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"List_Header_id_URL", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"Calendar_id_17", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"List_Header_id_Date", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"Calendar_id_18", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"Calendar_id_19", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"Calendar_id_20", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"MenuItem_id_17", nil)];
    return titleString;
}

#pragma mark - export To Contacts
- (void)exportToContacts {
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transferDelegate transferPrepareFileEnd];
    }
    for (int i = 0;i<_exportTracks.count;i++) {
        if (_limitation.remainderCount == 0) {
            break;
        }
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            break;
        }
        IMBContactEntity *contact = [_exportTracks objectAtIndex:i];
        
        _currItemIndex ++;
        ABPerson *person = [[ABPerson alloc] init];
        if (contact.firstName != nil) {
            [person setValue:contact.firstName forProperty:kABFirstNameProperty];
        }
        if (contact.middleName != nil) {
            [person setValue:contact.middleName forProperty:kABMiddleNameProperty];
        }
        if (contact.lastName != nil) {
            [person setValue:contact.lastName forProperty:kABLastNameProperty];
        }
        if (contact.firstNameYomi != nil) {
            [person setValue:contact.firstNameYomi forProperty:kABFirstNamePhoneticProperty];
        }
        if (contact.lastNameYomi != nil) {
            [person setValue:contact.lastNameYomi forProperty:kABLastNamePhoneticProperty];
        }
        if (contact.birthday != nil) {
            [person setValue:contact.birthday forProperty:kABBirthdayProperty];
        }
        if (contact.jobTitle != nil) {
            [person setValue:contact.jobTitle forProperty:kABJobTitleProperty];
        }
        if (contact.nickname != nil) {
            [person setValue:contact.nickname forProperty:kABNicknameProperty];
        }
        if (contact.title != nil) {
            [person setValue:contact.title forProperty:kABTitleProperty];
        }
        if (contact.suffix != nil) {
            [person setValue:contact.suffix forProperty:kABSuffixProperty];
        }
        if (contact.notes != nil) {
            [person setValue:contact.notes forProperty:kABNoteProperty];
        }
        if (contact.companyName != nil) {
            [person setValue:contact.companyName forProperty:kABOrganizationProperty];
        }
        if (contact.department != nil) {
            [person setValue:contact.department forProperty:kABDepartmentProperty];
        }
        ABMutableMultiValue *phone = [[ABMutableMultiValue alloc] init];
        //其他数据phoneNumber
        for (IMBContactKeyValueEntity *phoneNumber in contact.phoneNumberArray) {
            
            if (phoneNumber.label != nil) {
                
                [phone addValue:phoneNumber.value?phoneNumber.value:@"" withLabel:phoneNumber.label];
            }else
            {
                [phone addValue:phoneNumber.value?phoneNumber.value:@"" withLabel:phoneNumber.type];
            }
            
        }
        
        if (phone.count>0) {
            [person setValue:phone forProperty:kABPhoneProperty];
        }
        [phone release];
        ////email
        ABMutableMultiValue *memail = [[ABMutableMultiValue alloc] init];
        for (IMBContactKeyValueEntity *email in contact.emailAddressArray) {
            
            if (email.label != nil) {
                
                [memail addValue:email.value?email.value:@"" withLabel:email.label];
            }else
            {
                [memail addValue:email.value?email.value:@"" withLabel:email.type];
            }
            
        }
        if (memail.count>0) {
            [person setValue:memail forProperty:kABEmailProperty];
        }
        [memail release];
        //related
        ABMutableMultiValue *mrelated = [[ABMutableMultiValue alloc] init];
        for (IMBContactKeyValueEntity *relate in contact.relatedNameArray) {
            
            if (relate.label != nil) {
                
                [mrelated addValue:relate.value?relate.value:@"" withLabel:relate.label];
            }else
            {
                [mrelated addValue:relate.value?relate.value:@"" withLabel:relate.type];
            }
            
        }
        if (mrelated.count>0) {
            [person setValue:mrelated forProperty:kABRelatedNamesProperty];
        }
        [mrelated release];
        //url
        ABMutableMultiValue *murl = [[ABMutableMultiValue alloc] init];
        for (IMBContactKeyValueEntity *url in contact.urlArray) {
            
            if (url.label != nil) {
                
                [murl addValue:url.value?url.value:@"" withLabel:url.label];
            }else
            {
                [murl addValue:url.value?url.value:@"" withLabel:url.type];
            }
            
        }
        if (murl.count>0) {
            [person setValue:murl forProperty:kABURLsProperty];
        }
        [murl release];
        //date
        ABMutableMultiValue *mdate = [[ABMutableMultiValue alloc] init];
        for (IMBContactKeyValueEntity *date in contact.dateArray) {
            
            if (date.label != nil) {
                
                [mdate addValue:date.value?date.value:@"" withLabel:date.label];
            }else
            {
                [mdate addValue:date.value?date.value:@"" withLabel:date.type];
            }
            
        }
        if (mdate.count>0) {
            [person setValue:mdate forProperty:kABOtherDatesProperty];
        }
        [mdate release];
        //address
        ABMutableMultiValue *contactValue = [[ABMutableMultiValue alloc] init];
        for (IMBContactAddressEntity *addressEntity in contact.addressArray) {
            NSMutableDictionary *address = [[NSMutableDictionary alloc] initWithCapacity:0];
            if (addressEntity.street != nil) {
                [address setObject:addressEntity.street forKey:kABAddressStreetKey];
            }
            if (addressEntity.city != nil) {
                [address setObject:addressEntity.city forKey:kABAddressCityKey];
            }
            if (addressEntity.state != nil) {
                [address setObject:addressEntity.state forKey:kABAddressStateKey];
            }
            if (addressEntity.postalCode != nil) {
                [address setObject:addressEntity.postalCode forKey:kABAddressZIPKey];
            }
            if (addressEntity.country != nil) {
                [address setObject:addressEntity.country forKey:kABAddressCountryKey];
            }
            
            if (addressEntity.label != nil) {
                [contactValue addValue:address withLabel:addressEntity.label];
                [address release];
            }else
            {
                [contactValue addValue:address withLabel:addressEntity.type];
                [address release];
            }
        }
        if ([contactValue count]>0) {
            [person setValue:contactValue forKey:kABAddressProperty];
        }
        [contactValue release];
        //IM
        ABMutableMultiValue *imValue = [[ABMutableMultiValue alloc] init];
        for (IMBContactIMEntity *imEntity in contact.IMArray) {
            NSMutableDictionary *im = [[NSMutableDictionary alloc] initWithCapacity:0];
            if (imEntity.user != nil) {
                [im setObject:imEntity.user forKey:kABInstantMessageUsernameKey];
            }
            if (imEntity.service != nil) {
                [im setObject:imEntity.service forKey:kABInstantMessageServiceKey];
            }
            if (imEntity.label != nil) {
                [imValue addValue:im withLabel:imEntity.label];
                
            }else
            {
                [imValue addValue:im withLabel:imEntity.type];
            }
            [im release];
        }
        if (imValue.count>0) {
            [person setValue:imValue forKey:kABInstantMessageProperty];
        }
        [imValue release];
        
        if (_currItemIndex > _totalItemCount) {
            _currItemIndex = _totalItemCount;
        }
        float progress = (((float)_currItemIndex / _totalItemCount) * 100) / _totalItem + _percent;
        if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
            [_transferDelegate transferProgress:progress];
        }
        
        if ( [[ABAddressBook sharedAddressBook] addRecord:person]) {
            if ([[ABAddressBook sharedAddressBook] save]) {
                [_limitation reduceRedmainderCount];
                _successCount++;
            }else {
                _failedCount++;
            }
        }else {
            _failedCount ++;
        }
    }
    sleep(2);
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }

}

#pragma mark - export import Contacts

- (void)importContact:(NSMutableArray *)contactArray
{
    _currItemIndex = 0;
    _percent = 0;
    _totalItem = 1;
    _totalItemCount = (int)[contactArray count];
    for (int i=0;i<[contactArray count];i++) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            IMBContactEntity *contact = [contactArray objectAtIndex:i];
            [[IMBTransferError singleton] addAnErrorWithErrorName:contact.allName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
            continue;
        }
        _currItemIndex ++;
        IMBContactEntity *contact = [contactArray objectAtIndex:i];
        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
            [_transferDelegate transferFile:contact.allName];
        }
        [_contactManager openMobileSync];
        BOOL success = [_contactManager modifyContact:contact];
        [_contactManager closeMobileSync];
        
        if (_currItemIndex > _totalItemCount) {
            _currItemIndex = _totalItemCount;
        }
        float progress = (((float)_currItemIndex / _totalItemCount) * 100) / _totalItem + _percent;
        if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
            [_transferDelegate transferProgress:progress];
        }
        if (success) {
            [_limitation reduceRedmainderCount];
            _successCount++;
        }else {
            _failedCount ++;
        }
        
    }
    sleep(2);
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
}


- (void)importContactVCF {
    //解析文件
    NSMutableArray *contactsArray = [NSMutableArray array];
    
    NSString *str = CustomLocalizedString(@"ImportSync_id_20", nil);
    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
        [_transferDelegate transferFile:str];
    }
    for (NSString *path in _exportTracks) {
        if (_limitation.remainderCount == 0) {
            break;
        }
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            break;
        }
        NSData *data = [_fileManager contentsAtPath:path];
        NSString *vcfStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSMutableArray *contactArray = [self parseVCF:vcfStr];
        [contactsArray addObjectsFromArray:contactArray];
        [vcfStr release];
    }
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transferDelegate transferPrepareFileEnd];
    }
    
    for (int i=0;i<[contactsArray count];i++) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            IMBContactEntity *contact = [contactsArray objectAtIndex:i];
            [[IMBTransferError singleton] addAnErrorWithErrorName:contact.allName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
            continue;
        }
        _currItemIndex ++;
        [_contactManager openMobileSync];
        IMBContactEntity *contact = [contactsArray objectAtIndex:i];
        BOOL success = [_contactManager modifyContact:contact];
        
        if (_currItemIndex > _totalItemCount) {
            _currItemIndex = _totalItemCount;
        }
        float progress = (((float)_currItemIndex / _totalItemCount) * 100) / _totalItem + _percent;
        if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
            [_transferDelegate transferProgress:progress];
        }
        NSString *str = nil;
        if (![StringHelper stringIsNilOrEmpty:contact.fullName]) {
            str = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),[contact.fullName stringByAppendingString:@".vcf"]];
        }
        if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
            [_transferDelegate transferFile:str];
        }
        
        if (success) {
            [_limitation reduceRedmainderCount];
            _successCount++;
        }else {
            _failedCount ++;
        }
        [_contactManager closeMobileSync];
    }
    sleep(2);
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
}

/*
 N: Last Name;FirstName;MiddleName;Prefix;Suffix;
 FN: fullName;
 NICKNAME:nickname
 X-PHONETIC-FIRST-NAME:phoneticFistName
 X-PHONETIC-LAST-NAME:phoneticlastName
 X-PHONETIC-MIDDLE-NAME:phoneticMiddleName
 ORG:companyName;department
 TITLE:job title
 NOTE:note
 BADY:birthday
 ADR:;;street;city;province;postal code;country
 IMPP;X-SERVICE-TYPE=MSN;type=HOME;type=pref:msnim:15665666
 IMPP;X-SERVICE-TYPE=QQ;type=WORK:x-apple:673651520
 自定义impp
 */
//解析
- (NSMutableArray *)parseVCF:(NSString *)vcgString
{
    NSArray *lines = [vcgString componentsSeparatedByString:@"\n"];
    NSMutableArray *contactArray = [NSMutableArray array];
    IMBContactEntity *entity = nil;
    int a1=0; //地址
    int b1=0;//电话
    int c1=0;//email
    int d1=0;//url
    int e1=0;//related
    int f1=0;//date
    int g1=0; //IMP
    for(int i = 0;i<[lines count];i++)
    {
        NSString *line = [lines objectAtIndex:i];
        
        if ([line hasPrefix:@"BEGIN:"]) {
            entity = [[IMBContactEntity alloc] init];
        }else if ([line hasPrefix:@"N:"]||[line hasPrefix:@"N;"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            if ([upperComponents count]>=2) {
                NSArray *names = [[upperComponents objectAtIndex:1] componentsSeparatedByString:@";"];
                for (int i = 0;i<[names count];i++) {
                    
                    if (i==0) {
                        NSString *name = [names objectAtIndex:i];
                        NSString *aname = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        [entity setLastName:[aname stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==1)
                    {
                        NSString *name = [names objectAtIndex:i];
                        NSString *aname = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        [entity setFirstName:[aname stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==2)
                    {
                        NSString *name = [names objectAtIndex:i];
                        NSString *aname = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        [entity setMiddleName:[aname stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==3)
                    {
                        NSString *name = [names objectAtIndex:i];
                        NSString *aname = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        [entity setTitle:[aname stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==4)
                    {
                        NSString *name = [names objectAtIndex:i];
                        NSString *aname = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
                        
                        [entity setSuffix:[aname stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }
                    
                }
                
            }
        }else if ([line hasPrefix:@"FN"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setFullName:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            
        }
        else if ([line hasPrefix:@"NOTE"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setNotes:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            
            
        }else if ([line hasPrefix:@"ORG"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            if ([upperComponents count]>=2) {
                NSArray *companys = [[upperComponents objectAtIndex:1] componentsSeparatedByString:@";"];
                for (int i = 0;i<[companys count];i++) {
                    
                    if (i==0) {
                        [entity setCompanyName:[[companys objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==1)
                    {
                        [entity setDepartment:[[companys objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }
                }
                
            }
        }else if ([line hasPrefix:@"BDAY:"])//基本数据
        {
            //取数组最后一个为birthday
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            id birthday = [upperComponents lastObject];
            if ([birthday isKindOfClass:[NSString class]]) {
                //将birthday转换成NSDate
                birthday = [birthday stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *date = [formatter dateFromString:birthday];
                [entity setBirthday:date];
            }
        }else if ([line hasPrefix:@"TITLE:"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setJobTitle:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        }else if ([line hasPrefix:@"NICKNAME:"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setNickname:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        }else if ([line hasPrefix:@"X-PHONETIC-FIRST-NAME:"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setFirstNameYomi:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        }else if ([line hasPrefix:@"X-PHONETIC-LAST-NAME:"])//基本数据
        {
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [entity setLastNameYomi:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        }else if ([line hasPrefix:@"ADR"])//地址 没有自定义 label为空
        {
            IMBContactAddressEntity *addressEntity = [[IMBContactAddressEntity alloc] init];
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            if ([upperComponents count]>=2) {
                
                NSArray *typeArray = [[upperComponents objectAtIndex:0] componentsSeparatedByString:@";"];
                if ([typeArray count]==0) {
                    [addressEntity setType:@"other"];
                }
                for (int i = 0;i< [typeArray count];i++) {
                    if (i == 1) {
                        NSArray *arr = [[typeArray objectAtIndex:i] componentsSeparatedByString:@"="];
                        if ([arr count]>=2) {
                            [addressEntity setType:((NSString *)[arr lastObject]).lowercaseString];
                        }else
                        {
                            [addressEntity setType:@"other"];
                        }
                    }
                }
                
                
                NSArray *addressArray = [[upperComponents objectAtIndex:1] componentsSeparatedByString:@";"];
                for (int i = 0;i<[addressArray count];i++) {
                    
                    if (i==2) {
                        [addressEntity setStreet:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==3)
                    {
                        [addressEntity setCity:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==4)
                    {
                        [addressEntity setState:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==5)
                    {
                        [addressEntity setPostalCode:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }else if (i==6)
                    {
                        [addressEntity setCountry:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }
                }
                [addressEntity setEntityID:[NSNumber numberWithInt:a1]];
                a1++;
                [addressEntity setContactCategory:Contact_StreetAddress];
                [entity.addressArray addObject:addressEntity];
                [addressEntity release];
                
            }
            
            
        }else if ([line hasPrefix:@"IMPP;"])//IM 没有自定义
        {
            IMBContactIMEntity *imentity = [[IMBContactIMEntity alloc] init];
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [imentity setUser:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            if ([upperComponents count]>0) {
                NSString *str = [upperComponents objectAtIndex:0];
                NSArray *arr = [str componentsSeparatedByString:@";"];
                for (int i=0;i<[arr count];i++) {
                    NSString *subStr = nil;
                    if (i==1) {
                        subStr = [arr objectAtIndex:i];
                        NSArray *subArray = [subStr componentsSeparatedByString:@"="];
                        [imentity setService:[subArray lastObject]];
                    }else if (i==2)
                    {
                        subStr = [arr objectAtIndex:i];
                        NSArray *subArray = [subStr componentsSeparatedByString:@"="];
                        [imentity setType:((NSString *)[subArray lastObject]).lowercaseString];
                    }
                }
            }
            [imentity setContactCategory:Contact_IM];
            [imentity setEntityID:[NSNumber numberWithInt:g1]];
            g1++;
            [entity.IMArray addObject:imentity];
            [imentity release];
            
        }else if([line hasPrefix:@"URL;"])//url 没有自定义
        {
            IMBContactKeyValueEntity *urlEntity = [[IMBContactKeyValueEntity alloc] init];
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [urlEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            if ([upperComponents count]>=1) {
                NSString *str = [upperComponents objectAtIndex:0];
                NSArray *arr = [str componentsSeparatedByString:@";"];
                for (int i=0;i<[arr count];i++) {
                    NSString *subStr = nil;
                    if (i==1) {
                        subStr = [arr objectAtIndex:i];
                        NSArray *subArray = [subStr componentsSeparatedByString:@"="];
                        [urlEntity setType:((NSString *)[subArray lastObject]).lowercaseString];
                    }
                }
                
            }
            [urlEntity setEntityID:[NSNumber numberWithInt:d1]];
            d1++;
            [urlEntity setContactCategory:Contact_URL];
            [entity.urlArray addObject:urlEntity];
            [urlEntity release];
            
        }else if ([line hasPrefix:@"TEL;"])
        {
            IMBContactKeyValueEntity *telEntity = [[IMBContactKeyValueEntity alloc] init];
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [telEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            
            if ([upperComponents count]>=1) {
                NSString *str = [upperComponents objectAtIndex:0];
                NSArray *arr = [str componentsSeparatedByString:@";"];
                for (int i=0;i<[arr count];i++) {
                    NSString *subStr = nil;
                    if (i==1) {
                        subStr = [arr objectAtIndex:i];
                        NSArray *subArray = [subStr componentsSeparatedByString:@"="];
                        NSString *type = [subArray lastObject];
                        if ([type isEqualToString:@"CELL"]||[type isEqualToString:@"IPHONE"]) {
                            [telEntity setType:@"mobile"];
                        }else
                        {
                            [telEntity setType:((NSString *)[subArray lastObject]).lowercaseString];
                        }
                        
                    }
                }
                
            }
            [telEntity setEntityID:[NSNumber numberWithInt:b1]];
            b1++;
            [telEntity setContactCategory:Contact_PhoneNumber];
            [entity.phoneNumberArray addObject:telEntity];
            [telEntity release];
            
        }else if ([line hasPrefix:@"EMAIL;"])
        {
            IMBContactKeyValueEntity *emailEntity = [[IMBContactKeyValueEntity alloc] init];
            NSArray *upperComponents = [line componentsSeparatedByString:@":"];
            [emailEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
            
            if ([upperComponents count]>=1) {
                NSString *str = [upperComponents objectAtIndex:0];
                NSArray *arr = [str componentsSeparatedByString:@";"];
                for (int i=0;i<[arr count];i++) {
                    NSString *subStr = nil;
                    if (i==2) {
                        subStr = [arr objectAtIndex:i];
                        NSArray *subArray = [subStr componentsSeparatedByString:@"="];
                        [emailEntity setType:((NSString *)[subArray lastObject]).lowercaseString];
                    }
                }
                
            }
            [emailEntity setContactCategory:Contact_EmailAddressNumber];
            [emailEntity setEntityID:[NSNumber numberWithInt:c1]];
            c1++;
            [entity.emailAddressArray addObject:emailEntity];
            [emailEntity release];
        }
        else if ([line hasPrefix:@"item"])
        {
            //地址
            NSString *adrReg = @"item\\w+.ADR:*";
            //电话
            NSString *phoneReg = @"item\\w+.TEL:*";
            //email
            NSString *emailReg = @"item\\w+.EMAIL:*";
            //url
            NSString *urlReg = @"item\\w+.URL:*";
            //related
            NSString *relatedReg = @"item\\w+.X-ABRELATEDNAMES:*";
            //date
            NSString *dateReg = @"item\\w+.X-ABDATE:*";
            //IMPP
            NSString *imppReg = @"item\\w+.IMPP:*";
            //date
            
            if ([line isMatchedByRegex:adrReg]) {
                IMBContactAddressEntity *addressEntity = [[IMBContactAddressEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                if ([upperComponents count]>=2) {
                    
                    NSArray *addressArray = [[upperComponents objectAtIndex:1] componentsSeparatedByString:@";"];
                    for (int i = 0;i<[addressArray count];i++) {
                        
                        if (i==2) {
                            [addressEntity setStreet:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                        }else if (i==3)
                        {
                            [addressEntity setCity:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                        }else if (i==4)
                        {
                            [addressEntity setState:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                        }else if (i==5)
                        {
                            [addressEntity setPostalCode:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                        }else if (i==6)
                        {
                            [addressEntity setCountry:[[addressArray objectAtIndex:i] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                        }
                    }
                    
                    
                }
                addressEntity.type = @"other";
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [addressEntity setLabel:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    
                    i++;
                }
                [addressEntity setContactCategory:Contact_StreetAddress];
                [addressEntity setEntityID:[NSNumber numberWithInt:a1]];
                a1++;
                [entity.addressArray addObject:addressEntity];
                
            }else if ([line isMatchedByRegex:phoneReg])
            {
                IMBContactKeyValueEntity *phoneEntity = [[IMBContactKeyValueEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                [phoneEntity setValue:[[upperComponents lastObject]stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [phoneEntity setLabel:[[arr lastObject]stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    i++;
                }
                [phoneEntity setType:@"other"];
                [phoneEntity setEntityID:[NSNumber numberWithInt:b1]];
                b1++;
                [phoneEntity setContactCategory:Contact_PhoneNumber];
                [entity.phoneNumberArray addObject:phoneEntity];
                [phoneEntity release];
                
            }else if ([line isMatchedByRegex:emailReg])
            {
                IMBContactKeyValueEntity *emailEntity = [[IMBContactKeyValueEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                [emailEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [emailEntity setLabel:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    i++;
                }
                [emailEntity setType:@"other"];
                [emailEntity setEntityID:[NSNumber numberWithInt:c1]];
                c1++;
                [emailEntity setContactCategory:Contact_EmailAddressNumber];
                [entity.emailAddressArray addObject:emailEntity];
                [emailEntity release];
                
            }else if ([line isMatchedByRegex:urlReg])
            {
                IMBContactKeyValueEntity *urlEntity = [[IMBContactKeyValueEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                [urlEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [urlEntity setLabel:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    i++;
                }
                [urlEntity setType:@"other"];
                [urlEntity setEntityID:[NSNumber numberWithInt:d1]];
                d1++;
                [urlEntity setContactCategory:Contact_URL];
                [entity.urlArray addObject:urlEntity];
                [urlEntity release];
                
            }else if ([line isMatchedByRegex:relatedReg])
            {
                //item17.X-ABRELATEDNAMES;type=pref:sister
                //item17.X-ABLabel:_$!<Sister>!$_
                IMBContactKeyValueEntity *relatedEntity = [[IMBContactKeyValueEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                [relatedEntity setValue:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [relatedEntity setLabel:[self getValueInangle:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]]];
                    i++;
                }
                [relatedEntity setType:@"other"];
                [relatedEntity setEntityID:[NSNumber numberWithInt:e1]];
                e1++;
                [relatedEntity setContactCategory:Contact_RelatedName];
                [entity.relatedNameArray addObject:relatedEntity];
                [relatedEntity release];
                
            }else if ([line isMatchedByRegex:dateReg])
            {
                //item5.X-ABDATE;X-APPLE-OMIT-YEAR=1604;type=pref:1604-11-17
                //item5.X-ABLabel:_$!<Other>!$_
                IMBContactKeyValueEntity *dateEntity = [[IMBContactKeyValueEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                NSString *strDate = [[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *date = [formatter dateFromString:strDate];
                [dateEntity setValue:date];
                [formatter release];
                //取下一行
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [dateEntity setLabel:[self getValueInangle:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]]];
                    
                    i++;
                }
                [dateEntity setType:@"other"];
                [dateEntity setEntityID:[NSNumber numberWithInt:f1]];
                f1++;
                [dateEntity setContactCategory:Contact_Date];
                [entity.dateArray addObject:dateEntity];
                [dateEntity release];
            }else if ([line isMatchedByRegex:imppReg])
            {
                //item15.IMPP;X-SERVICE-TYPE=AIM:aim:15665666
                //item15.X-ABLabel:luoluo
                IMBContactIMEntity *imEntity = [[IMBContactIMEntity alloc] init];
                NSArray *upperComponents = [line componentsSeparatedByString:@":"];
                [imEntity setUser:[[upperComponents lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];                if ([upperComponents count]>0) {
                    NSArray *subArr = [[upperComponents objectAtIndex:0] componentsSeparatedByString:@";"];
                    if ([subArr count]>=2) {
                        NSArray *subArr1 = [[subArr objectAtIndex:1] componentsSeparatedByString:@"="];
                        [imEntity setService:[[subArr1 lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
                    }
                }
                
                if (i+1<[lines count]) {
                    NSArray *arr = [[lines objectAtIndex:i+1] componentsSeparatedByString:@":"];
                    [imEntity setLabel:[self getValueInangle:[[arr lastObject] stringByReplacingOccurrencesOfString:@"\r" withString:@""]]];
                    
                    i++;
                }
                [imEntity setType:@"other"];
                [imEntity setEntityID:[NSNumber numberWithInt:g1]];
                g1++;
                [imEntity setContactCategory:Contact_IM];
                [entity.IMArray addObject:imEntity];
                [imEntity release];
                
            }
            
            
        }else if ([line hasPrefix:@"END:"]&&entity != nil)
        {
            [contactArray addObject:entity];
            [entity release];
            entity = nil;
        }
        
    }
    
    
    /* for (IMBContactEntity *entity in contactArray) {
     
     for (IMBContactKeyValueEntity *dateEntity in entity.dateArray) {
     
     
     }
     for (IMBContactKeyValueEntity *urlEntity in entity.urlArray) {
     
     
     }
     for (IMBContactKeyValueEntity *relatedEntity in entity.relatedNameArray) {
     
     
     }
     for (IMBContactKeyValueEntity *phoneEntity in entity.phoneNumberArray) {
     
     
     }
     for (IMBContactIMEntity *imEntity in entity.IMArray) {
     
     
     }
     for (IMBContactAddressEntity *addressEntity in entity.addressArray) {
     
     
     }
     for (IMBContactKeyValueEntity *emailEntity in entity.emailAddressArray) {
     
     
     }
     
     
     }*/
    
    return contactArray;
}

//去得<>里面的值
- (NSString *)getValueInangle:(NSString *)str
{
    NSScanner *theScanner = [NSScanner scannerWithString:str];
    NSString *text = nil;
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
    }
    if ([text hasPrefix:@"<"]) {
        text = [text stringByReplacingOccurrencesOfString:@"<" withString:@""];
        text = [text stringByReplacingOccurrencesOfString:@">" withString:@""];
        return text;
    }else
    {
        return str;
    }
}

- (void)dealloc{
    [super dealloc];
    if (_contactManager != nil) {
        [_contactManager release];
        _contactManager = nil;
    }
}

@end
