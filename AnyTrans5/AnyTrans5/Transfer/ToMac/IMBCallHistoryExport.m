//
//  IMBCallHistoryExport.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-7.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBCallHistoryExport.h"
#import "DateHelper.h"

@implementation IMBCallHistoryExport

- (void)startTransfer {
    _totalItemCount = 0;
    for (IMBCallContactModel *entity in _exportTracks) {
        if (entity.checkState == Check) {
            _totalItemCount += entity.callHistoryList.count;
        }else if (entity.checkState == SemiChecked) {
            for (IMBCallHistoryDataEntity *call in entity.callHistoryList) {
                if (call.checkState == Check) {
                    _totalItemCount ++;
                }
            }
        }
    }
    [_loghandle writeInfoLog:@"CallhistoryExport DoProgress enter"];
    if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
        [_transferDelegate transferPrepareFileEnd];
    }
    if ([_mode isEqualToString:@"txt"]) {
        [self callHistoryExportByTXT:_exportPath];
    }else if ([_mode isEqualToString:@"html"]) {
        [self writeCallFileToPageTitle];
    }
    sleep(2);
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
    [_loghandle writeInfoLog:@"CallhistoryExport DoProgress Complete"];
}

#pragma mark - export Html
- (void)writeCallFileToPageTitle {
    [_loghandle writeInfoLog:@"CallExportToHtm Begin"];
    if (_exportTracks != nil && _exportTracks.count > 0) {
        for (IMBCallContactModel *entity in _exportTracks) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                for (IMBCallHistoryDataEntity *model in entity.callHistoryList) {
                  [[IMBTransferError singleton] addAnErrorWithErrorName:model.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                }
                continue;
            }
            _callhistory = entity;
            if ([TempHelper stringIsNilOrEmpty:entity.contactName]) {
                entity.contactName = CustomLocalizedString(@"Common_id_10", nil);
            }
            _exportName = [NSString stringWithFormat:@"%@.html",entity.contactName];
            
            //日志打印
            [self writeToMsgFileWithPageTitle:_exportName];
        }
    }
    [_loghandle writeInfoLog:@"CallExportToHtm End"];
}

- (NSData*)createHtmHeader:(NSString *)title {
    NSString *headerContent = [NSString stringWithFormat:@"<head><meta charset=\"utf-8\" /><title>%@</title><style type=\"text/css\">*{margin: 0;padding: 0; font:normal 12px \"Helvetica Neue\", \"Lucida Sans Unicode\", \"Arial\";color:#333;}body{ background: #eee}.wrap{ width: 640px; margin: 0 auto;}.top{ width: 100%%; height: 42px; background: #3dc79c; text-align: center; font-size: 18px; color: #fff; font-weight: bolder; line-height: 42px;}.cont{ background: #fff; padding: 18px;}.cont h1{ height: 32px; font-size:20px; color: #000;  border-bottom: 1px solid #e5e5e5;}.cont p{ font-size: 14px;  line-height:24px; color: #000; margin: 14px 0 0 0;}.cont table td{ font-size: 14px; text-align: left; line-height: 18px; padding: 30px 0 0 0;}</style></head>", title] ;
    return [headerContent dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData*)createHtmBody {
    NSData *retData = nil;
    NSMutableString *bodyContent = [[NSMutableString alloc] init];
    [bodyContent appendString:[NSString stringWithFormat:@"<body><div class=\"wrap\"><div class=\"top\">%@</div>", CustomLocalizedString(@"MenuItem_id_18", nil)]];
    [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"cont\"><h1>%@</h1>", _callhistory.contactName]];
    if (_callhistory != nil) {
        NSArray *historyList = _callhistory.callHistoryList;
        NSPredicate *tmppre = [NSPredicate predicateWithFormat:@"self.checkState == %d", YES];
        historyList = [historyList filteredArrayUsingPredicate:tmppre];
        if (historyList != nil && historyList.count > 0) {
            NSMutableArray *dateArray = [[NSMutableArray alloc] init];
            NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
            for (IMBCallHistoryDataEntity *item in historyList) {
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
                if (item.checkState != Check) {
                    break;
                }
                if (![dateArray containsObject:item.callDateStr]) {
                    [dateArray addObject:item.callDateStr];
                    [tmpArray addObject:item];
                }
            }
            [dateArray release];
            dateArray = nil;
            
            NSArray *sortedArray = [tmpArray sortedArrayUsingComparator:^(id obj1, id obj2){
                IMBCallHistoryDataEntity *msg1 = (IMBCallHistoryDataEntity*)obj1;
                IMBCallHistoryDataEntity *msg2 = (IMBCallHistoryDataEntity*)obj2;
                if (msg1.date > msg2.date)
                    return NSOrderedAscending;
                else if (msg1.date < msg2.date)
                    return NSOrderedDescending;
                else
                    return NSOrderedSame;
            }];
            [tmpArray release];
            tmpArray = nil;
            
            if (sortedArray.count > 0) {
                for (IMBCallHistoryDataEntity *item in sortedArray) {
                    @autoreleasepool {
                        [_condition lock];
                        if (_isPause) {
                            [_condition wait];
                        }
                        [_condition unlock];
                        if (_isStop) {
                            break;
                        }
                        if (item.checkState != Check) {
                            break;
                        }

                        [bodyContent appendString:[NSString stringWithFormat:@"<p>%@</p>", item.callDateStr]];
                        NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.callDateStr = %@", item.callDateStr];
                        NSArray *tmpArray = [historyList filteredArrayUsingPredicate:pre];
                        if (tmpArray != nil && tmpArray.count > 0) {
                            [bodyContent appendString:@"<table cellpadding=\"0\" cellspacing=\"0\" width=\"604\" >"];
                            for (IMBCallHistoryDataEntity *callhistory in tmpArray) {
                                if (callhistory.checkState == YES) {
                                    [_condition lock];
                                    if (_isPause) {
                                        [_condition wait];
                                    }
                                    [_condition unlock];
                                    if (_isStop) {
                                        [[IMBTransferError singleton] addAnErrorWithErrorName:callhistory.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                                        continue;
                                    }
                                    _currItemIndex += 1;
                                    [bodyContent appendString:@"<tr>"];
                                    [bodyContent appendString:[NSString stringWithFormat:@"<td width=\"150\">%@</td>", callhistory.callTimeStr]];
                                    [bodyContent appendString:[NSString stringWithFormat:@"<td width=\"220\">%@</td>", callhistory.callTypeString]];
                                    [bodyContent appendString:[NSString stringWithFormat:@"<td width=\"192\">%@</td>", [DateHelper getTimeAutoShowHourString:callhistory.duration]]];
                                    [bodyContent appendString:@"</tr>"];

                                    float progress = ((float)_currItemIndex / _totalItemCount) * 100;
                                    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                                        [_transferDelegate transferProgress:progress];
                                    }
                                    _successCount += 1;
                                    [_limitation reduceRedmainderCount];
                                }
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

#pragma mark - export TXT
- (void)callHistoryExportByTXT:(NSString *)exportPath {
    if (_exportTracks != nil && _exportTracks.count > 0) {
        NSString *exPath = [exportPath stringByAppendingPathComponent:[CustomLocalizedString(@"MenuItem_id_18", nil) stringByAppendingString:@".txt"]];
        if ([_fileManager fileExistsAtPath:exPath]) {
            exPath = [TempHelper getFilePathAlias:exPath];
        }
        [_fileManager createFileAtPath:exPath contents:nil attributes:nil];
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exPath];
        NSString *conString = @"";
        for (IMBCallContactModel *entity in _exportTracks) {
            for (IMBCallHistoryDataEntity *item in entity.callHistoryList) {
                if (item.checkState != Check) {
                    continue;
                }
                if (_limitation.remainderCount == 0) {
                    [[IMBTransferError singleton] addAnErrorWithErrorName:item.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    continue;
                }
                @autoreleasepool {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        [[IMBTransferError singleton] addAnErrorWithErrorName:item.name WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                        continue;
                    }
                    _currItemIndex += 1;
                    conString = [conString stringByAppendingString:[self eachCallHistoryInfoByTXT:item]];
                    conString = [conString stringByAppendingString:@"\r\n"];
                    
                    NSData *retData = [conString dataUsingEncoding:NSUTF8StringEncoding];
                    [handle writeData:retData];
                    conString= @"";
                    
//                    NSTask *task;
//                    task = [[NSTask alloc] init];
//                    [task setLaunchPath: @"/usr/bin/touch"];
//                    NSArray *arguments;
//                    NSString *str = [DateHelper dateFrom2001ToString:item.creationDate withMode:3];
//                    NSString *strData = [TempHelper replaceSpecialChar:str];
//                    strData = [strData stringByReplacingOccurrencesOfString:@" " withString:@""];
//                    strData = [strData stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                    arguments = [NSArray arrayWithObjects: @"-mt", strData, exFilePath, nil];
//                    [task setArguments: arguments];
                    
                    float progress = ((float)_currItemIndex / _totalItemCount) * 100;
                    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_transferDelegate transferProgress:progress];
                    }
                    _successCount += 1;
                    [_limitation reduceRedmainderCount];
                }
            }
        }
        [handle closeFile];
    }
}

- (NSString *)eachCallHistoryInfoByTXT:(IMBCallHistoryDataEntity *)item {
    NSString *itemString = @"";
    if (item != nil) {
        if (![TempHelper stringIsNilOrEmpty:item.name]) {
            itemString = [[itemString stringByAppendingString:item.name] stringByAppendingString:@":"];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@":"];
        }
        
        if (![TempHelper stringIsNilOrEmpty:item.address]) {
            itemString = [[itemString stringByAppendingString:item.address] stringByAppendingString:@"\r\n"];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@"\r\n"];
        }
        
        itemString = [itemString stringByAppendingString:@"------------------------------------------------------------------------------------------\r\n"];
        
        NSString *toobStr = [[[[[CustomLocalizedString(@"List_Header_id_Date", nil) stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"List_Header_id_Duration", nil)] stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"List_Header_id_Type", nil)] stringByAppendingString:@"\r\n"];
        itemString = [itemString stringByAppendingString:toobStr];
        
        if (item.date != 0) {
            itemString = [[itemString stringByAppendingString:item.dateStr] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        if (item.duration != 0) {
            itemString = [[itemString stringByAppendingString:[DateHelper getTimeAutoShowHourString:item.duration]] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"0"] stringByAppendingString:@" \t "];
        }
        
        if (![TempHelper stringIsNilOrEmpty:item.callTypeString]) {
            itemString = [itemString stringByAppendingString:item.callTypeString];
        }else {
            itemString = [itemString stringByAppendingString:@"-"];
        }
        
        itemString = [itemString stringByAppendingString:@"\r\n"];
        
    }
    return itemString;
}

@end
