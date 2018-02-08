//
//  IMBSafariHistoryExport.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-7.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBSafariHistoryExport.h"
//#import "IMBHelper.h"
#import "IMBSafariHistoryEntity.h"
//#import "IMBPageEntriesList.h
@implementation IMBSafariHistoryExport

- (void)startTransfer {
    [_loghandle writeInfoLog:@"SafariHistoryExport DoProgress enter"];
    if (!_isAllExport) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
    }
    if ([_mode isEqualToString:@"csv"]) {
        [self safariHistoryExportByCSV:_exportPath];
    }else if ([_mode isEqualToString:@"html"]){
        _exportName =  [NSString stringWithFormat:@"%@.html",CustomLocalizedString(@"MenuItem_id_37", nil)];
        [self writeToMsgFileWithPageTitle:_exportName];
    }
    if (!_isAllExport) {
        sleep(2);
        if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
            [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
        }
    }
    [_loghandle writeInfoLog:@"SafariHistoryExport DoProgress Complete"];
}

#pragma mark - export Html
- (NSData*)createHtmHeader:(NSString *)title {
    NSString *headerContent = [NSString stringWithFormat:@"<head><meta charset=\"utf-8\"/><title>%@</title><style type=\"text/css\">*{margin: 0;padding: 0; font:normal 12px \"Lucida Sans Unicode\", \"Helvetica Neue\", \"Arial\";color:#333;}body{ background: #eee}.wrap{ width: 640px; margin: 0 auto;}.top{ width: 100%%; height: 42px; background: #3dc79c; text-align: center; font-size: 18px; color: #fff; font-weight: bolder; line-height: 42px;}.cont{ background: #fff;}.cont_block{padding:10px  0;}.date{width: 604px; height: 32px; color: #3dc79c; font-size: 12px; font-weight: 12px; line-height: 32px; background: #f6f6f6; padding: 0 18px;}.cont_block ul{ padding:  0 18px; list-style: none;}.cont_block  li{ border-bottom: 1px solid #f4f4f4; padding: 10px 0;}.cont_block  li span{ display: block;   color: #000;}.cont_block  li a{display:block;width:604px; word-wrap: break-word; color: #a3a3a3; text-decoration: none;}.cont_block  li a:hover{ color: #3dc79c;}</style></head>", title];
    return [headerContent dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData*)createHtmBody {
    NSData *retData = nil;
    NSMutableString *bodyContent = [[NSMutableString alloc] init];
    [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"wrap\"><div class=\"top\">%@</div><div class=\"cont\">", CustomLocalizedString(@"MenuItem_id_37", nil)]];
    
    if (_exportTracks != nil && _exportTracks.count > 0) {
        NSMutableArray *webHistorys = [[NSMutableArray alloc] init];
        NSMutableArray *pageEntries = [[NSMutableArray alloc] init];
        NSMutableArray *dateArray = [[NSMutableArray alloc] init];
        for (id item in _exportTracks) {
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
            if ([item isKindOfClass:[IMBSafariHistoryEntity class]]) {
                if (![dateArray containsObject:[(IMBSafariHistoryEntity*)item visitedDateStr]]) {
                    [dateArray addObject:[(IMBSafariHistoryEntity*)item visitedDateStr]];
                }
                [webHistorys addObject:item];
            }
        }
        
        if (dateArray.count > 0) {
            for (NSString *item in dateArray) {
                @autoreleasepool {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        break;
                    }
                    [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"cont_block\"><p class=\"date\">%@</p><ul>", item]];
                    
                    if (webHistorys.count > 0) {
                        NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.visitedDateStr = %@", item];
                        NSArray *tmpArray = [webHistorys filteredArrayUsingPredicate:pre];
                        if (tmpArray != nil && tmpArray.count > 0) {
                            for (IMBSafariHistoryEntity *webhistory in tmpArray) {
                                [_condition lock];
                                if (_isPause) {
                                    [_condition wait];
                                }
                                [_condition unlock];
                                if (_isStop) {
                                    [[IMBTransferError singleton] addAnErrorWithErrorName:webhistory.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                                    continue;
                                }
                                _currItemIndex += 1;
                                [bodyContent appendString:[NSString stringWithFormat:@"<li><span>%1$@</span><a href=\"%2$@\" target=\"_blank\">%2$@</a></li>", webhistory.title, webhistory.forwardURL]];
                                if (_currItemIndex < _totalItemCount) {
                                    _currItemIndex = _totalItemCount;
                                }
                                float progress = (((float)_currItemIndex / _totalItemCount) * 100) / _totalItem + _percent;
                                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                                    [_transferDelegate transferProgress:progress];
                                }
                                _successCount += 1;
                                [_limitation reduceRedmainderCount];
                            }
                        }
                    }
                   
                    [bodyContent appendString:@"</ul></div>"];
                }
            }
        }
        [dateArray release];
        dateArray = nil;
        [webHistorys release];
        webHistorys = nil;
        [pageEntries release];
        pageEntries = nil;
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

#pragma mark - export CSV
- (void)safariHistoryExportByCSV:(NSString *)exportPath {
    if (_exportTracks != nil && _exportTracks.count > 0) {
        NSString *exPath = [exportPath stringByAppendingPathComponent:[CustomLocalizedString(@"MenuItem_id_37", nil) stringByAppendingString:@".csv"]];
        if ([_fileManager fileExistsAtPath:exPath]) {
            exPath = [TempHelper getFilePathAlias:exPath];
        }
        
        [_fileManager createFileAtPath:exPath contents:nil attributes:nil];
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exPath];
        
        NSString *conString = @"";
        conString = [conString stringByAppendingString:[[CustomLocalizedString(@"List_Header_id_Title", nil) stringByAppendingString:@","] stringByAppendingString:@"List_Header_id_URL"]];
        for (IMBSafariHistoryEntity *item in _exportTracks) {
            if (_limitation.remainderCount == 0) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:item.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                continue;
            }
            @autoreleasepool {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    [[IMBTransferError singleton] addAnErrorWithErrorName:item.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    continue;
                }
                _currItemIndex += 1;
                
                conString = [conString stringByAppendingString:@"\r\n"];
                conString = [conString stringByAppendingString:[self eachSafariHistoryInfoByCSV:item]];
                NSData *retData = [conString dataUsingEncoding:NSUTF8StringEncoding];
                [handle writeData:retData];
                conString = @"";
                
                if (_currItemIndex < _totalItemCount) {
                    _currItemIndex = _totalItemCount;
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

- (NSString *)eachSafariHistoryInfoByCSV:(IMBSafariHistoryEntity *)item {
    NSString *itemString = @"";
    if (item != nil) {
        if (![TempHelper stringIsNilOrEmpty:[(IMBSafariHistoryEntity *)item title]]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:[(IMBSafariHistoryEntity *)item title]]];
        }
        itemString = [itemString stringByAppendingString:@","];
        if (![TempHelper stringIsNilOrEmpty:[(IMBSafariHistoryEntity *)item forwardURL]]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:[(IMBSafariHistoryEntity *)item forwardURL]]];
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
