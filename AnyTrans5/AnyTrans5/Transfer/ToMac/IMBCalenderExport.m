//
//  IMBCalenderExport.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-7.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBCalenderExport.h"
#import "IMBCalAndRemEntity.h"
#import "DateHelper.h"
#import "IMBCalendarEventEntity.h"
#import "StringHelper.h"
#import "IMBiCloudCalendarEventEntity.h"
@implementation IMBCalenderExport
@synthesize isCalender = _isCalender;

-(void)startTransfer {
    [_loghandle writeInfoLog:@"calenderExport DoProgress enter"];
    if (!_isAllExport) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
    }
    if ([_mode isEqualToString:@"csv"]) {
        [self calendarExportByCSV:_exportPath];
    }else if([_mode isEqualToString:@"txt"]) {
        [self calendarExportByTXT:_exportPath];
    }
    if (!_isAllExport) {
        sleep(2);
        if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
            [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
        }
    }
    [_loghandle writeInfoLog:@"calenderExport DoProgress Complete"];
}

#pragma mark - export TXT
- (void)calendarExportByTXT:(NSString *)exportPath {
    if (_exportTracks != nil && _exportTracks.count > 0) {
        NSString *exPath;
        if(_isReminder) {
            exPath = [exportPath stringByAppendingPathComponent:[CustomLocalizedString(@"Reminders_id", nil) stringByAppendingString:@".txt"]];
        }else {
            exPath = [exportPath stringByAppendingPathComponent:[CustomLocalizedString(@"MenuItem_id_22", nil) stringByAppendingString:@".txt"]];
        }
        
        if ([_fileManager fileExistsAtPath:exPath]) {
            exPath = [TempHelper getFilePathAlias:exPath];
        }
        
        [_fileManager createFileAtPath:exPath contents:nil attributes:nil];
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exPath];
        for (IMBCalAndRemEntity *item in _exportTracks) {
            if (_limitation.remainderCount == 0) {
                if ([item isKindOfClass:[IMBiCloudCalendarEventEntity class]]) {
                    IMBiCloudCalendarEventEntity *event = (IMBiCloudCalendarEventEntity *)item;
                    [[IMBTransferError singleton] addAnErrorWithErrorName:event.summary WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                }else {
                    [[IMBTransferError singleton] addAnErrorWithErrorName:item.summary WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                }
                continue;
            }
            @autoreleasepool {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    if ([item isKindOfClass:[IMBiCloudCalendarEventEntity class]]) {
                        IMBiCloudCalendarEventEntity *event = (IMBiCloudCalendarEventEntity *)item;
                        [[IMBTransferError singleton] addAnErrorWithErrorName:event.summary WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    }else {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:item.summary WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    }
                    continue;
                }
                _currItemIndex += 1;
                NSString *conString = @"";
                if ([item isKindOfClass:[IMBiCloudCalendarEventEntity class]]) {
                    IMBiCloudCalendarEventEntity *event = (IMBiCloudCalendarEventEntity *)item;
                    [event loadDetailContent];
                }
                if ([item isKindOfClass:[IMBCalAndRemEntity class]]) {
                    conString = [conString stringByAppendingString:[self eachCalendarInfoByTXT:item]];
                }else if ([item isKindOfClass:[IMBCalendarEventEntity class]]||[item isKindOfClass:[IMBiCloudCalendarEventEntity class]]) {
                    conString = [conString stringByAppendingString:[self eachCalendarInfoByTXTOther:(IMBCalendarEventEntity *)item]];
                }
                conString = [conString stringByAppendingString:@"\r\n"];
                NSData *data = [conString dataUsingEncoding:NSUTF8StringEncoding];
                [handle writeData:data];
//                NSTask *task;
//                task = [[NSTask alloc] init];
//                [task setLaunchPath: @"/usr/bin/touch"];
//                NSArray *arguments;
//                NSString *str = [DateHelper dateFrom2001ToString:item.startTime withMode:3];
//                NSString *strData = [TempHelper replaceSpecialChar:str];
//                strData = [strData stringByReplacingOccurrencesOfString:@" " withString:@""];
//                strData = [strData stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                arguments = [NSArray arrayWithObjects: @"-mt", strData, exPath, nil];
//                [task setArguments: arguments];
//                NSPipe *pipe;
//                pipe = [NSPipe pipe];
//                [task setStandardOutput: pipe];
//                NSFileHandle *file;
//                file = [pipe fileHandleForReading];
//                [task launch];
                
                if (_currItemIndex > _totalItemCount) {
                    _currItemIndex = _totalItemCount;
                }
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),item.summary]];
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

- (NSString *)eachCalendarInfoByTXT:(IMBCalAndRemEntity *)item {
    NSString *itemString = @"";
    if (item != nil) {
        if (![TempHelper stringIsNilOrEmpty:item.summary]) {
            itemString = [[itemString stringByAppendingString:item.summary] stringByAppendingString:@"\r\n"];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@"\r\n"];
        }
        
        itemString = [itemString stringByAppendingString:@"------------------------------------------------------------------------------------------\r\n"];
        NSString *toobStr = [[[[[[[[[[[[[CustomLocalizedString(@"List_Header_id_Title", nil) stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"common_id_16", nil)] stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"Calendar_id_13", nil)] stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"Calendar_id_14", nil)]stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"Calendar_id_15", nil)]stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"List_Header_id_URL", nil)]stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"contact_id_91", nil)] stringByAppendingString:@"\r\n"];
        
        itemString = [itemString stringByAppendingString:toobStr];
        
        if (![TempHelper stringIsNilOrEmpty:item.summary]) {
            itemString = [[itemString stringByAppendingString:item.summary] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        if (![TempHelper stringIsNilOrEmpty:item.location]) {
            itemString = [[itemString stringByAppendingString:item.location] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        if (item.startTime != 0) {
            itemString = [[itemString stringByAppendingString:[DateHelper longToHourDateString:item.startTime]] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        if (item.endTime != 0) {
            itemString = [[itemString stringByAppendingString:[DateHelper longToHourDateString:item.endTime]] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        if (item.completionDate != 0) {
            itemString = [[itemString stringByAppendingString:[DateHelper longToHourDateString:item.completionDate]] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        if (![TempHelper stringIsNilOrEmpty:item.url]) {
            itemString = [[itemString stringByAppendingString:item.url] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        if (![TempHelper stringIsNilOrEmpty:item.description]) {
            itemString = [[itemString stringByAppendingString:item.description] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        itemString = [itemString stringByAppendingString:@"\r\n"];
    }
    
    return itemString;
}

- (NSString *)eachCalendarInfoByTXTOther:(IMBCalendarEventEntity *)item {
    NSString *itemString = @"";
    if (item != nil) {
        if (![TempHelper stringIsNilOrEmpty:item.summary]) {
            itemString = [[itemString stringByAppendingString:item.summary] stringByAppendingString:@"\r\n"];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@"\r\n"];
        }
        
        itemString = [itemString stringByAppendingString:@"------------------------------------------------------------------------------------------\r\n"];
        NSString *toobStr = [[[[[[[[[[[[[CustomLocalizedString(@"List_Header_id_Title", nil) stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"common_id_16", nil)] stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"Calendar_id_13", nil)] stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"Calendar_id_14", nil)]stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"Calendar_id_15", nil)]stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"List_Header_id_URL", nil)]stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"contact_id_91", nil)] stringByAppendingString:@"\r\n"];
        
        itemString = [itemString stringByAppendingString:toobStr];
        
        if (![TempHelper stringIsNilOrEmpty:item.summary]) {
            itemString = [[itemString stringByAppendingString:item.summary] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        if (![TempHelper stringIsNilOrEmpty:item.location]) {
            itemString = [[itemString stringByAppendingString:item.location] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        if (item.startdate != 0) {
            itemString = [[itemString stringByAppendingString:item.startdate] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        if (item.enddate != 0) {
            itemString = [[itemString stringByAppendingString:item.enddate] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
//        if (item.completionDate != 0) {
//            itemString = [[itemString stringByAppendingString:[DateHelper longToHourDateString:item.completionDate]] stringByAppendingString:@" \t "];
//        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
//        }
        
        if (![TempHelper stringIsNilOrEmpty:item.url]) {
            itemString = [[itemString stringByAppendingString:item.url] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        if (![TempHelper stringIsNilOrEmpty:item.description]) {
            itemString = [[itemString stringByAppendingString:item.description] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        itemString = [itemString stringByAppendingString:@"\r\n"];
    }
    
    return itemString;
}

#pragma mark - export CSV
- (void)calendarExportByCSV:(NSString *)exportPath {
    if (_exportTracks != nil && _exportTracks.count > 0) {
        NSString *exPath;
        if(_isReminder) {
            exPath = [exportPath stringByAppendingPathComponent:[CustomLocalizedString(@"Reminders_id", nil) stringByAppendingString:@".csv"]];
        }else {
            exPath = [exportPath stringByAppendingPathComponent:[CustomLocalizedString(@"MenuItem_id_22", nil) stringByAppendingString:@".csv"]];
        }
        
        if ([_fileManager fileExistsAtPath:exPath]) {
            exPath = [TempHelper getFilePathAlias:exPath];
        }
        [_fileManager createFileAtPath:exPath contents:nil attributes:nil];
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exPath];
        for (int i=0;i<_exportTracks.count;i++) {
            if (_limitation.remainderCount == 0) {
                IMBCalAndRemEntity *item = [_exportTracks objectAtIndex:i];
                if ([item isKindOfClass:[IMBiCloudCalendarEventEntity class]]) {
                    IMBiCloudCalendarEventEntity *event = (IMBiCloudCalendarEventEntity *)item;
                    [[IMBTransferError singleton] addAnErrorWithErrorName:event.summary WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                }else {
                    [[IMBTransferError singleton] addAnErrorWithErrorName:item.summary WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                }
                continue;
            }
            @autoreleasepool {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    IMBCalAndRemEntity *item = [_exportTracks objectAtIndex:i];
                    if ([item isKindOfClass:[IMBiCloudCalendarEventEntity class]]) {
                        IMBiCloudCalendarEventEntity *event = (IMBiCloudCalendarEventEntity *)item;
                        [[IMBTransferError singleton] addAnErrorWithErrorName:event.summary WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    }else {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:item.summary WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    }
                    continue;
                }
                IMBCalAndRemEntity *item = [_exportTracks objectAtIndex:i];
                if ([item isKindOfClass:[IMBiCloudCalendarEventEntity class]]) {
                    IMBiCloudCalendarEventEntity *event = (IMBiCloudCalendarEventEntity *)item;
                    [event loadDetailContent];
                }
                NSString *titleString = @"";
                if (i == 0) {
                    titleString = [self tableTitleString];
                }
                
                _currItemIndex += 1;
                NSString *conString = @"";
                if ([item isKindOfClass:[IMBCalAndRemEntity class]]) {
                    conString = [self eachCalendarInfoByCSV:item];
                }else if ([item isKindOfClass:[IMBCalendarEventEntity class]]) {
                    conString = [self eachCalendarInfoByCSVOther:(IMBCalendarEventEntity *)item];
                }
                
                titleString = [titleString stringByAppendingString:@"\r\n"];
                titleString = [titleString stringByAppendingString:conString];
                NSData *data = [titleString dataUsingEncoding:NSUTF8StringEncoding];
                [handle writeData:data];
                
//                NSTask *task;
//                task = [[NSTask alloc] init];
//                [task setLaunchPath: @"/usr/bin/touch"];
//                NSArray *arguments;
//                NSString *str = [DateHelper dateFrom2001ToString:item.startTime withMode:3];
//                NSString *strData = [TempHelper replaceSpecialChar:str];
//                strData = [strData stringByReplacingOccurrencesOfString:@" " withString:@""];
//                strData = [strData stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                arguments = [NSArray arrayWithObjects: @"-mt", strData, exPath, nil];
//                [task setArguments: arguments];
//                NSPipe *pipe;
//                pipe = [NSPipe pipe];
//                [task setStandardOutput: pipe];
//                
//                NSFileHandle *file;
//                file = [pipe fileHandleForReading];
//                
//                [task launch];
                
                if (_currItemIndex > _totalItemCount) {
                    _currItemIndex = _totalItemCount;
                }
                

                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),item.summary]];
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

- (NSString *)tableTitleString {
    NSString *titleString = @"";
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"List_Header_id_Title", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"contact_id_5", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"Calendar_id_13", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"Calendar_id_14", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"Calendar_id_15", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"List_Header_id_URL", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"MenuItem_id_17", nil)];
    return titleString;
}

- (NSString *)eachCalendarInfoByCSV:(IMBCalAndRemEntity *)item {
    NSString *itemString = @"";
    if (item != nil) {
        if (![TempHelper stringIsNilOrEmpty:item.summary]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.summary]];
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (![TempHelper stringIsNilOrEmpty:item.location]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.location]];
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.startTime != 0) {
            NSString *stringDate = [DateHelper longToHourDateString:item.startTime];
            itemString = [itemString stringByAppendingString:stringDate];
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.endTime != 0) {
            NSString *stringDate = [DateHelper longToHourDateString:item.endTime];
            itemString = [itemString stringByAppendingString:stringDate];
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.completionDate != 0) {
            NSString *stringDate = [DateHelper longToHourDateString:item.completionDate];
            itemString = [itemString stringByAppendingString:stringDate];
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (![TempHelper stringIsNilOrEmpty:item.url]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.url]];
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (![TempHelper stringIsNilOrEmpty:item.description]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.description]];
        }
    }
    return itemString;
}

- (NSString *)eachCalendarInfoByCSVOther:(IMBCalendarEventEntity *)item {
    NSString *itemString = @"";
    if (item != nil) {
        if (![TempHelper stringIsNilOrEmpty:item.summary]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.summary]];
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (![TempHelper stringIsNilOrEmpty:item.location]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.location]];
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.startdate != nil) {
            itemString = [itemString stringByAppendingString:item.startdate];
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (item.enddate != nil) {
            itemString = [itemString stringByAppendingString:item.enddate];
        }
        itemString = [itemString stringByAppendingString:@","];
        
//        if (item.completionDate != 0) {
//            NSString *stringDate = [DateHelper longToHourDateString:item.completionDate];
//            itemString = [itemString stringByAppendingString:stringDate];
//        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (![TempHelper stringIsNilOrEmpty:item.url]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.url]];
        }
        itemString = [itemString stringByAppendingString:@","];
        
        if (![TempHelper stringIsNilOrEmpty:item.eventdescription]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.eventdescription]];
        }
    }
    return itemString;
}

- (NSString *)covertSpecialChar:(NSString *)str {
    if (![TempHelper stringIsNilOrEmpty:str]) {
        NSString *string = [str stringByReplacingOccurrencesOfString:@"," withString:@"&c;a&"];
        return string;
    }else {
        return str;
    }
}
@end
