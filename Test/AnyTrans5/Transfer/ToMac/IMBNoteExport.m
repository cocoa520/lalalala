//
//  IMBNoteExport.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-7.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBNoteExport.h"
#import "IMBNoteDataEntity.h"
#import "IMBSMSChatDataEntity.h"
#import "DateHelper.h"
@implementation IMBNoteExport

-(void)startTransfer {
    [_loghandle writeInfoLog:@"noteExport DoProgress Enter"];
    if (!_isAllExport) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
    }
    if ([_mode isEqualToString:@"csv"]) {
        [_loghandle writeInfoLog:@"NotesExportToCSV Begin"];
        [self notesExportByCSV:_exportPath];
        [_loghandle writeInfoLog:@"NotesExportToCSV End"];
    }else if ([_mode isEqualToString:@"txt"]) {
        [_loghandle writeInfoLog:@"NotesExportToTXT Begin"];
        [self notesExportByTXT:_exportPath];
        [_loghandle writeInfoLog:@"NotesExportToTXT End"];
    }else if ([_mode isEqualToString:@"html"]){
        [self checkAndCopyHtmlImage];
        [self writeToFile];
    }
    if (!_isAllExport) {
        sleep(2);
        if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
            [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
        }
    }
    [_loghandle writeInfoLog:@"noteExport DoProgress Complete"];
}

#pragma mark - export Html
- (void)checkAndCopyHtmlImage {
    NSString *msgStr = CustomLocalizedString(@"ImportSync_id_20", nil);
    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
        [_transferDelegate transferFile:msgStr];
    }
    _htmlImgFolderPath = [_exportPath stringByAppendingPathComponent:@"img"];
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
    imgName = @"file";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"folder";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    
    imgName = @"folder2";
    imageFilePath = [_htmlImgFolderPath stringByAppendingPathComponent:[imgName stringByAppendingPathExtension:imgExt]];
    if (![_fileManager fileExistsAtPath:imageFilePath]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:imgExt];
        [_fileManager copyItemAtPath:path toPath:imageFilePath error:nil];
    }
    return;
}

- (NSData*)createHtmHeader:(NSString *)title {
    
    NSString *headerContent = [NSString stringWithFormat:@"<head><meta charset=\"utf-8\" /><title>%@</title><style type=\"text/css\">*{margin: 0;padding: 0; font:normal 12px \"Helvetica Neue\", \"Lucida Sans Unicode\", \"Arial\";color:#333;}body{ background: #eee}.wrap{ width: 640px; margin: 0 auto;}.top{ width: 100%%; height: 42px; background: #3dc79c; text-align: center; font-size: 18px; color: #fff; font-weight: bolder; line-height: 42px;}.cont{ background: #fff; padding: 18px;min-height:500px;}.cont h1{ height: 32px; font-size:20px; color: #000;}.cont p{ font-size: 14px;  line-height:24px; color: #000; margin: 14px 0 0 0;}.cont table td{ font-size: 14px; text-align: left; line-height: 18px; padding: 30px 0 0 0;}.cont table td img{ max-width:300px;}</style></head>",title];
    
    return [headerContent dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData*)createHtmBody:(IMBNoteModelEntity *)note {
    NSData *retData = nil;
    NSMutableString *bodyContent = [[NSMutableString alloc] init];
    NSString *str = CustomLocalizedString(@"MenuItem_id_17", nil);
    [bodyContent appendString:[NSString stringWithFormat:@"<body><div class=\"wrap\"><div class=\"top\">%@</div><div class=\"cont\">",str]];
    NSString *name = @"";
    if (note.title.length > 30) {
        name = [note.title substringToIndex:30];
    }else {
        name = note.title;
    }
    if ([name isEqualToString:@""]) {
        name = CustomLocalizedString(@"Common_id_10", nil);
    }
    [bodyContent appendString:[NSString stringWithFormat:@"<div style=\"height: 32px; border-bottom: 1px solid #e5e5e5;\"><h1 style=\"float: left;\">%@</h1><span style=\"float: right; margin: 10px 0 0 0;\">%@</span></div>",name,note.modifyDateStr]];
    
    [bodyContent appendString:@"<br/>"];
    //    [bodyContent appendString:[NSString stringWithFormat:@"<p class=\"date\">%@</p>",[DateHelper dateFrom2001ToString:note.creatDate withMode:2]]];
    [bodyContent appendString:[NSString stringWithFormat:@"<p class=\"date\">%@</p>",note.modifyDateStr]];
    if (note.attachmentAry != nil && note.attachmentAry.count > 0) {
        for (IMBNoteAttachmentEntity  *attachmentData in note.attachmentAry) {
            [self createAttachemntHtml:attachmentData withBodyContent:bodyContent];
        }
    }
    
    [bodyContent appendString:[NSString stringWithFormat:@"<div>%@</div></div></div></body></html>",note.content]];
    
    //    NSData *retData = nil;
    //    NSMutableString *bodyContent = [[NSMutableString alloc] init];
    //    [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"wrap\"><div class=\"top\">%@</div><div class=\"cont\">", CustomLocalizedString(@"Calendar_id_11", nil)]];
    //    [bodyContent appendString:@"<div class=\"cont_block\"><ul>"];
    //    [bodyContent appendString:[NSString stringWithFormat:@"<li><span>%1$@ %2$@</span><a target=\"_blank\">%3$@</a></li>",note.title,[IMBHelper longToDateString:note.creatDate withMode:2], note.content]];
    //    [bodyContent appendString:@"</ul></div>"];
    //    [bodyContent appendString:@"</div></div></body>"];
    
    retData = [bodyContent dataUsingEncoding:NSUTF8StringEncoding];
    [bodyContent release];
    bodyContent = nil;
    return retData;
}

- (void)createAttachemntHtml:(IMBNoteAttachmentEntity *)attItem withBodyContent:(NSMutableString *)bodyContent {
    NSString *path = [self exportAttachmentsToLacol:attItem withPath:_htmlImgFolderPath];
    [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"block_table\"><div class=\"block_table\"><div class=\"block_table\"><table width=\"auto\" height=\"auto\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td><a href=\"img/%1$@\" target=\"_blank\"><img src=\"img/%1$@\" /></a></td></tr></table></div></div></div>",[path lastPathComponent]]];
}

- (NSData*)createHtmFooter {
    NSString *footerContent = @"";
    return [footerContent dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)writeToFile {
    [_loghandle writeInfoLog:@"export notes html begin"];
    for (IMBNoteModelEntity *note in _exportTracks) {
        if (_limitation.remainderCount == 0) {
             [[IMBTransferError singleton] addAnErrorWithErrorName:note.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
            continue;
        }
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            [[IMBTransferError singleton] addAnErrorWithErrorName:note.title WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
            continue;
        }
        NSString *name = @"";
        if (note.title.length > 30) {
            name = [note.title substringToIndex:30];
        }else {
            name = note.title;
        }
        if ([name isEqualToString:@""]) {
            name = CustomLocalizedString(@"Common_id_10", nil);
        }
        name = [name stringByReplacingOccurrencesOfString:@"/" withString:@","];
        name = [name stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *exportFilePath = [_exportPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.html",name]];
        if ([_fileManager fileExistsAtPath:exportFilePath]) {
            exportFilePath = [TempHelper getFilePathAlias:exportFilePath];
        }
        [_fileManager createFileAtPath:exportFilePath contents:nil attributes:nil];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:exportFilePath];
        if (fileHandle == nil) {
            continue;
        }
        [fileHandle truncateFileAtOffset:0];
        NSData *data = [@"<!DOCTYPE html><html>" dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandle writeData:data];
        data = [self createHtmHeader:CustomLocalizedString(@"MenuItem_id_17", nil)];
        if (data == nil) {
            [fileHandle closeFile];
            [_fileManager removeItemAtPath:exportFilePath error:nil];
            continue;
        }
        [fileHandle writeData:data];
        
        data = [self createHtmBody:note];
        if (data == nil) {
            [fileHandle closeFile];
            [_fileManager removeItemAtPath:exportFilePath error:nil];
            
            continue;
        }
        [fileHandle writeData:data];
        
        data = [self createHtmFooter];
        if (data == nil) {
            [fileHandle closeFile];
            [_fileManager removeItemAtPath:exportFilePath error:nil];
            
            continue;
        }
        [fileHandle writeData:data];
        data = [@"</html>" dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandle closeFile];
        _currItemIndex += 1;
        
        if (_currItemIndex > _totalItemCount) {
            _currItemIndex = _totalItemCount;
        }
        //        IMBExportSetting *exportSetting = [[IMBExportSetting alloc]initWithIPod:_ipod];
        //        [exportSetting readDictionary];
        //        if (exportSetting.isCreadPhotoDate) {
        //            NSTask *task;
        //            task = [[NSTask alloc] init];
        //            [task setLaunchPath: @"/usr/bin/touch"];
        //            NSArray *arguments;
        //            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        //            [formatter setDateFormat:@"yyyy年MM月dd日"];
        //            NSLog(@"%@",note.creatDateStr);
        //            NSDate *date=[formatter dateFromString:note.creatDateStr];
        //            NSString *str = [DateHelper dateFrom2001ToDate:date withMode:3];
        //            NSString *strData = [TempHelper replaceSpecialChar:str];
        //            strData = [strData stringByReplacingOccurrencesOfString:@" " withString:@""];
        //            strData = [strData stringByReplacingOccurrencesOfString:@"-" withString:@""];
        //            arguments = [NSArray arrayWithObjects: @"-mt", strData, exportFilePath, nil];
        //            [task setArguments: arguments];
        //            NSPipe *pipe;
        //            pipe = [NSPipe pipe];
        //            [task setStandardOutput: pipe];
        //            NSFileHandle *file;
        //            file = [pipe fileHandleForReading];
        //            [task launch];
        //
        //        }
        
        float progress = (((float)_currItemIndex / _totalItemCount) * 100) / _totalItem + _percent;
        if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
            [_transferDelegate transferProgress:progress];
        }
        [_limitation reduceRedmainderCount];
        _successCount += 1;
    }
    [_loghandle writeInfoLog:@"export note html end"];
}

#pragma mark - export CSV
- (void)notesExportByCSV:(NSString *)exportPath {
    if (_exportTracks != nil && _exportTracks.count > 0) {
        [self createExportAttachmentPath:exportPath];
        NSString *exPath = nil;
        exPath = [exportPath stringByAppendingPathComponent:[CustomLocalizedString(@"MenuItem_id_17", nil) stringByAppendingString:@".csv"]];
        if ([_fileManager fileExistsAtPath:exPath]) {
            exPath = [TempHelper getFilePathAlias:exPath];
        }
        
        [_fileManager createFileAtPath:exPath contents:nil attributes:nil];
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exPath];
        
        NSString *titleString = [self tableTitleString];
        for (IMBNoteModelEntity *item in _exportTracks) {
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
                NSString *conString = [self eachNotesInfoByCSV:item];
                titleString = [titleString stringByAppendingString:@"\r\n"];
                titleString = [titleString stringByAppendingString:conString];
                
                if (_currItemIndex > _totalItemCount) {
                    _currItemIndex = _totalItemCount;
                }
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),item.title]];
                }
                
                float progress = (((float)_currItemIndex / _totalItemCount) * 100) / _totalItem + _percent;
                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_transferDelegate transferProgress:progress];
                }
                _successCount += 1;
                [_limitation reduceRedmainderCount];
                //                IMBExportSetting *exportSetting = [[IMBExportSetting alloc]initWithIPod:_ipod];
                //                [exportSetting readDictionary];
                //
                //                if (exportSetting.isCreadPhotoDate) {
                //                    NSTask *task;
                //                    task = [[NSTask alloc] init];
                //                    [task setLaunchPath: @"/usr/bin/touch"];
                //                    NSArray *arguments;
                //                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
                //                    [formatter setDateFormat:@"yyyy年MM月dd日"];
                //                    NSDate *date=[formatter dateFromString:item.creatDateStr];
                //                    NSString *str = [DateHelper dateFrom2001ToDate:date withMode:3];
                //                    NSString *strData = [TempHelper replaceSpecialChar:str];
                //                    strData = [strData stringByReplacingOccurrencesOfString:@" " withString:@""];
                //                    strData = [strData stringByReplacingOccurrencesOfString:@"-" withString:@""];
                //                    arguments = [NSArray arrayWithObjects: @"-mt", strData, exPath, nil];
                //                    [task setArguments: arguments];
                //                    NSPipe *pipe;
                //                    pipe = [NSPipe pipe];
                //                    [task setStandardOutput: pipe];
                //                    NSFileHandle *file;
                //                    file = [pipe fileHandleForReading];
                //                    [task launch];
                //
                //                }
                
                
                NSData *retData = [titleString dataUsingEncoding:NSUTF8StringEncoding];
                [handle writeData:retData];
                titleString= @"";
            }
        }
        [handle closeFile];
    }
}

- (NSString *)tableTitleString {
    NSString *titleString = @"";
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"List_Header_id_Title", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"backup_id_text_1", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"MenuItem_id_17", nil)];
    titleString = [titleString stringByAppendingString:@","];
    titleString = [titleString stringByAppendingString:CustomLocalizedString(@"MenuItem_id_56", nil)];
    return titleString;
}

- (NSString *)eachNotesInfoByCSV:(IMBNoteModelEntity *)item {
    NSString *itemString = @"";
    if (item != nil) {
        itemString = [itemString stringByAppendingString:@";Separator;"];
        if (![TempHelper stringIsNilOrEmpty:item.title]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.title]];
        }
        itemString = [itemString stringByAppendingString:@",element,"];
        if (item.modifyDateStr != nil) {
            itemString = [itemString stringByAppendingString:item.modifyDateStr];
        }
        itemString = [itemString stringByAppendingString:@",element,"];
        if (![TempHelper stringIsNilOrEmpty:item.content]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.content]];
        }
        itemString = [itemString stringByAppendingString:@",element,"];
        if (item.attachmentAry != nil && item.attachmentAry.count > 0) {
            for (IMBNoteAttachmentEntity  *attachmentData in item.attachmentAry) {
                NSString *path = [self exportAttachmentsToLacol:attachmentData withPath:_attachmentsPath];
                itemString = [itemString stringByAppendingString:path];
            }
        }else {
            itemString = [itemString stringByAppendingString:@"-"];
        }
    }
    return itemString;
}

#pragma mark - export TXT
- (void)notesExportByTXT:(NSString *)exportPath {
    if (_exportTracks != nil && _exportTracks.count > 0) {
        [self createExportAttachmentPath:exportPath];
        NSString *exPath = nil;
        exPath = [exportPath stringByAppendingPathComponent:[CustomLocalizedString(@"MenuItem_id_17", nil) stringByAppendingString:@".txt"]];
        if ([_fileManager fileExistsAtPath:exPath]) {
            exPath = [TempHelper getFilePathAlias:exPath];
        }
        
        [_fileManager createFileAtPath:exPath contents:nil attributes:nil];
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exPath];
        
        NSString *conString = @"";
        for (IMBNoteModelEntity *item in _exportTracks) {
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
                conString = [conString stringByAppendingString:[self eachNotesInfoByTXT:item]];
                conString = [conString stringByAppendingString:@"\r\n"];
                NSData *retData = [conString dataUsingEncoding:NSUTF8StringEncoding];
                [handle writeData:retData];
                conString = @"";
                
                if (_currItemIndex > _totalItemCount) {
                    _currItemIndex = _totalItemCount;
                }
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),item.title]];
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

- (NSString *)eachNotesInfoByTXT:(IMBNoteModelEntity *)item {
    NSString *itemString = @"";
    if (item != nil) {
        if (![TempHelper stringIsNilOrEmpty:item.title]) {
            itemString = [[itemString stringByAppendingString:item.title] stringByAppendingString:@"\r\n"];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@"\r\n"];
        }
        itemString = [itemString stringByAppendingString:@"------------------------------------------------------------------------------------------\r\n"];
        NSString *toobStr = [[[[[[[CustomLocalizedString(@"List_Header_id_Title", nil) stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"backup_id_text_1", nil)] stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"MenuItem_id_17", nil)] stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"MenuItem_id_56", nil)] stringByAppendingString:@"\r\n"];
        itemString = [itemString stringByAppendingString:toobStr];
        
        if (![TempHelper stringIsNilOrEmpty:item.title]) {
            itemString = [[itemString stringByAppendingString:item.title] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        if (item.modifyDate != 0) {
            itemString = [[itemString stringByAppendingString:item.modifyDateStr] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        if (![TempHelper stringIsNilOrEmpty:item.content]) {
            itemString = [[itemString stringByAppendingString:[self covertSpecialChar:item.content]] stringByAppendingString:@" \t "];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
        }
        
        if (item.attachmentAry != nil && item.attachmentAry.count > 0) {
            for (IMBNoteAttachmentEntity  *attachmentData in item.attachmentAry) {
                NSString *path = [self exportAttachmentsToLacol:attachmentData withPath:_attachmentsPath];
                itemString = [itemString stringByAppendingString:path];
            }
        }else {
            itemString = [itemString stringByAppendingString:@"-"];
        }
        
        itemString = [itemString stringByAppendingString:@"\r\n"];
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

- (void)createExportAttachmentPath:(NSString *)path {
    _attachmentsPath = [path stringByAppendingPathComponent:CustomLocalizedString(@"MenuItem_id_56", nil)];
    if ([_fileManager fileExistsAtPath:_attachmentsPath]) {
        _attachmentsPath = [TempHelper getFolderPathAlias:_attachmentsPath];
    }
    [_fileManager createDirectoryAtPath:_attachmentsPath withIntermediateDirectories:YES attributes:nil error:nil];
}

- (NSString *)exportAttachmentsToLacol:(IMBNoteAttachmentEntity *)attachItem withPath:(NSString *)path {
    NSString *lacolPath = @"";
    if (attachItem.attachDetailList.count > 0) {
        for (IMBAttachDetailEntity *attach in attachItem.attachDetailList) {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            lacolPath = [path stringByAppendingPathComponent:attach.fileName];
            if ([_fileManager fileExistsAtPath:lacolPath]) {
                lacolPath = [TempHelper getFilePathAlias:lacolPath];
            }
            if ([_fileManager fileExistsAtPath:attach.backUpFilePath]) {
                [_fileManager copyItemAtPath:attach.backUpFilePath toPath:lacolPath error:nil];
            }
        }
    }
    return lacolPath;
}

#pragma mark - export 附件方法
- (NSString *)exportSingleAttachmentsToLacol:(NSArray *)attachArray withPath:(NSString *)path {
    NSString *lacolPath = @"";
    for (IMBAttachDetailEntity *detailEntity in attachArray) {
        [_condition lock];
        if (_isPause) {
            [_condition wait];
        }
        [_condition unlock];
        if (_isStop) {
            break;
        }
        _currItemIndex += 1;
        lacolPath = [path stringByAppendingPathComponent:detailEntity.fileName];
        if ([_fileManager fileExistsAtPath:lacolPath]) {
            lacolPath = [TempHelper getFilePathAlias:lacolPath];
        }
        if ([_fileManager fileExistsAtPath:detailEntity.backUpFilePath]) {
            [_fileManager copyItemAtPath:detailEntity.backUpFilePath toPath:lacolPath error:nil];
            _successCount += 1;
        }
        if (_currItemIndex > _totalItemCount) {
            _currItemIndex = _totalItemCount;
        }
        float progress = (((float)_currItemIndex / _totalItemCount) * 100) / _totalItem + _percent;
        if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
            [_transferDelegate transferProgress:progress];
        }
    }
    if (!_isAllExport) {
        if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
            [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
        }
    }
    [_loghandle writeInfoLog:@"noteExport DoProgress Complete"];
    return lacolPath;
}

@end
