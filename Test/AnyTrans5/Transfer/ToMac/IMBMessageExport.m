//
//  IMBMessageExport.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-7.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBMessageExport.h"
#import "DateHelper.h"
#import "IMBSMSChatDataEntity.h"
#import "IMBMsgContentView.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"

@implementation IMBMessageExport

-(void)startTransfer {
    [_loghandle writeInfoLog:@"messageExport DoProgress Enter"];
    if (!_isAllExport) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
    }
    if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
        [_transferDelegate transferFile:CustomLocalizedString(@"ImportSync_id_20", nil)];
    }
    if ([_mode isEqualToString:@"txt"]) {
        [self messageExportByTXT:_exportPath];
    }else if([_mode isEqualToString:@"html"]) {
        [self checkAndCopyHtmlImage];
        [self writeMsgFileToPageTitle];
    }else if ([_mode isEqualToString:@"pdf"]) {
        [self printMessageToPdf:_exportPath printDataArray:_exportTracks];
    }
    if (!_isAllExport) {
        sleep(2);
        if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
            [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
        }
    }
    
    [_loghandle writeInfoLog:@"messageExport DoProgress Complete"];
}

- (void)checkAndCopyHtmlImage {
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

#pragma mark - export pdf 
- (void)printMessageToPdf:(NSString *)savePath  printDataArray:(NSArray *)dataArray
{
    [[IMBLogManager singleton] writeInfoLog:@"message export pdf"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    int totalItem = [dataArray count];
//    BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//    if (!isOutOfCount) {
//        [nc postNotificationName:COPYINGNOTIFICATION object:[NSNumber numberWithInt:FileTypeIcon]];
//        [nc postNotificationName:NOTIFY_TRANSCATEGORY object:CustomLocalizedString(@"Export_id_6", nil) userInfo:nil];
    if ([_limitation remainderCount] == 0) {
        return;
    }
    _currItemIndex = 0;
    _successCount = 0;
    _totalItemCount = (int)dataArray.count;
    for (int i = 0;i<totalItem;i++) {
        @autoreleasepool {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            IMBSMSChatDataEntity *entity = [dataArray objectAtIndex:i];
            if (_isStop) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:entity.contactName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                continue;
            }
            IMBMsgContentView *msgContentView = [[IMBMsgContentView alloc] initWithFrame:NSMakeRect(0, 0,630, 527)];
            [msgContentView setFrame:NSMakeRect(1, 1, 630, 527)];
            
            [msgContentView setSmsEntity:entity];
            [msgContentView setMsgArray:entity.msgModelList];
            [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"message pdf %@",entity.contactName]];
            //附件
            if (entity.msgModelList != nil && entity.msgModelList.count > 0) {
                //创建attachment文件夹
                NSString *attachDir = [savePath stringByAppendingPathComponent:@"Attachments"];
                if (![fileManager fileExistsAtPath:attachDir]) {
                    [fileManager createDirectoryAtPath:attachDir withIntermediateDirectories:NO attributes:nil error:nil];
                }
                NSString *contactAttachDir = [attachDir stringByAppendingFormat:@"/%@",entity.contactName];
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
                    [fileManager removeItemAtPath:contactAttachDir error:nil];
                }
            }
            
            
            
//            NSString *fileName = entity.contactName;
//            int currItemIndex = i+1;
            _currItemIndex += 1;
//            BOOL IsNeedAnimation = YES;
//            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                         fileName,@"Message",
//                                         [NSNumber numberWithInt:currItemIndex], @"CurItemIndex",
//                                         [NSNumber numberWithBool:IsNeedAnimation],@"IsNeedAnimation",
//                                         [NSNumber numberWithInt:totalItem], @"TotalItemCount",
//                                         nil];
//                [nc postNotificationName:NOTIFY_CURRENT_MESSAGE object:fileName];
//                [nc postNotificationName:NOTIFY_TRANSCOUNTPROGRESS object:@"MSG_COM_Total_Progress" userInfo:info];
            
            
            
            NSString *pdfFilePath = [savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",entity.contactName]];
            if ([fileManager fileExistsAtPath:pdfFilePath]) {
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
            [_limitation reduceRedmainderCount];
//                [_transResult setMediaSuccessCount:([_transResult mediaSuccessCount] + 1)];
//                [_transResult recordMediaResult:fileName resultStatus:TransSuccess messageID:@"MSG_PlaylistResult_Success"];
//                _progressCounter.prepareAnalysisSuccessCount++;
//                BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                if (isOutOfCount) {
//                    break;
//                }
            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                if (![StringHelper stringIsNilOrEmpty:entity.contactName]) {
                    [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),entity.contactName]];
                }
            }
            
            float progress = (((float)_currItemIndex / _totalItemCount) * 100) / _totalItem + _percent;
            if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                [_transferDelegate transferProgress:progress];
            }
            
            if (msgContentView != nil) {
                [msgContentView release];
                msgContentView = nil;
            }
            if (printInfo != nil) {
                [printInfo release];
                printInfo = nil;
            }
        }
        
    }
        sleep(2);
//        NSDictionary *infor = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:successNum],@"successNum",[NSNumber numberWithInt:FileResultTypeIcon],@"transferType", nil];
//        [nc postNotificationName:NOTIFY_TRANSCOMPLETE object:CustomLocalizedString(@"MSG_COM_Transfer_Completed", nil) userInfo:infor];
//    }
    
    
}

- (void)exportAttachmentsToLacol:(NSArray *)attachArray attachSavePath:(NSString *)attachmentSavePath {
    NSString *lacolPath = @"";
    NSFileManager *fm = [NSFileManager defaultManager];
    for (IMBSMSAttachmentEntity *attachEntity in attachArray) {
        lacolPath = attachmentSavePath;
        if (![fm fileExistsAtPath:lacolPath]) {
            [fm createDirectoryAtPath:lacolPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        for (IMBAttachDetailEntity *detailEntity in attachEntity.attachDetailList) {
            if (detailEntity.isPerviewImage == NO) {
                lacolPath = [lacolPath stringByAppendingPathComponent:detailEntity.fileName];
                if ([fm fileExistsAtPath:lacolPath]) {
                    [TempHelper getFilePathAlias:lacolPath];
                }
                [fm copyItemAtPath:detailEntity.backUpFilePath toPath:lacolPath error:nil];
            }
        }
    }
}

#pragma mark - export Html
- (void)writeMsgFileToPageTitle {
    [_loghandle writeInfoLog:@"MessageExportToHtm Begin"];
    if (_exportTracks != nil && _exportTracks .count > 0) {
        for (IMBSMSChatDataEntity *entity in _exportTracks ) {
            if (_limitation.remainderCount == 0) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:entity.contactName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                continue;
            }
            _msgChat = entity;
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:entity.contactName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                continue;
            }
            _currItemIndex ++;
            
            _exportName = [NSString stringWithFormat:@"%@.html",entity.contactName];
            [self writeToMsgFileWithPageTitle:_exportName];
            
            if (_currItemIndex > _totalItemCount) {
                _currItemIndex = _totalItemCount;
            }
            
//            NSString * exporPath = [_exportPath stringByAppendingPathComponent:_exportName];
//            IMBExportSetting *exportSetting = [[IMBExportSetting alloc]initWithIPod:_ipod];
//            [exportSetting readDictionary];
//            if (exportSetting.isCreadPhotoDate) {
//                NSTask *task;
//                task = [[NSTask alloc] init];
//                [task setLaunchPath: @"/usr/bin/touch"];
//                NSArray *arguments;
//                NSString *str = [DateHelper dateFrom2001ToString:entity.msgDate withMode:3];
//                NSString *strData = [TempHelper replaceSpecialChar:str];
//                strData = [strData stringByReplacingOccurrencesOfString:@" " withString:@""];
//                strData = [strData stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                arguments = [NSArray arrayWithObjects: @"-mt", strData, exporPath, nil];
//                [task setArguments: arguments];
//                NSPipe *pipe;
//                pipe = [NSPipe pipe];
//                [task setStandardOutput: pipe];
//                NSFileHandle *file;
//                file = [pipe fileHandleForReading];
//                [task launch];
//
//            }
            
            if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                if (![StringHelper stringIsNilOrEmpty:entity.contactName]) {
                    [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),entity.contactName]];
                }
            }
       
            float progress = (((float)_currItemIndex / _totalItemCount) * 100) / _totalItem + _percent;
            if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                [_transferDelegate transferProgress:progress];
            }
            _successCount ++;
            [_limitation reduceRedmainderCount];
        }
    }
    [_loghandle  writeInfoLog:@"MessageExportToHtm End"];
}

- (NSData*)createHtmBody {
//    [_loghandle  writeInfoLog:[NSString stringWithFormat:@"create htm body begin, memory:%f",[IMBHelper usedMemory]]];
    NSData *retData = nil;
    NSMutableString *bodyContent = [[NSMutableString alloc] init];
    [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"wrap\"><div class=\"top\">%@</div><div class=\"cont\">", CustomLocalizedString(@"MenuItem_id_19", nil)]];
    if (_msgChat != nil) {
        [bodyContent appendString:[NSString stringWithFormat:@"<h1>%@</h1>", _msgChat.contactName]];
        [bodyContent appendString:[NSString stringWithFormat:@"<p class=\"imessage\">%@</p>", _msgChat.handleService]];
        if (_msgChat.msgModelList != nil && _msgChat.msgModelList.count > 0) {
            NSArray *msgArray = _msgChat.msgModelList;
            NSMutableArray *dateArray = [[NSMutableArray alloc] init];
            NSPredicate *pre = nil;
            for (IMBMessageDataEntity *msgItem in msgArray) {
                @autoreleasepool {
                    [_condition lock];
                    if (_isPause) {
                        [_condition wait];
                    }
                    [_condition unlock];
                    if (_isStop) {
                        break;
                    }
                    pre = [NSPredicate predicateWithFormat:@"self.msgShortDateStr = %@", msgItem.msgShortDateStr];
                    NSArray *tmpArray = [dateArray filteredArrayUsingPredicate:pre];
                    if (tmpArray != nil && tmpArray.count > 0) {
                        continue;
                    } else {
                        [dateArray addObject:msgItem];
                    }
                }
            }
            
            NSArray *sortedArray = nil;
            sortedArray = [dateArray sortedArrayUsingComparator:^(id obj1, id obj2){
                IMBMessageDataEntity *msg1 = (IMBMessageDataEntity*)obj1;
                IMBMessageDataEntity *msg2 = (IMBMessageDataEntity*)obj2;
                if (msg1.msgDate < msg2.msgDate)
                    return NSOrderedAscending;
                else if (msg1.msgDate > msg2.msgDate)
                    return NSOrderedDescending;
                else
                    return NSOrderedSame;
            }];
            
            if (sortedArray != nil && sortedArray.count > 0) {
                if ([_msgChat.handleService isEqualToString:@"iMessage"]) {
                    for (IMBMessageDataEntity *msgItem in sortedArray) {
                        @autoreleasepool {
                            [_condition lock];
                            if (_isPause) {
                                [_condition wait];
                            }
                            [_condition unlock];
                            if (_isStop) {
                                break;
                            }
                            pre = [NSPredicate predicateWithFormat:@"self.msgShortDateStr = %@", msgItem.msgShortDateStr];
                            NSArray *tmpArray = [msgArray filteredArrayUsingPredicate:pre];
                            if (tmpArray != nil && tmpArray.count > 0) {
                                NSArray *showMsgDate = [tmpArray sortedArrayUsingComparator:^(id obj1, id obj2){
                                    IMBMessageDataEntity *msg1 = (IMBMessageDataEntity*)obj1;
                                    IMBMessageDataEntity *msg2 = (IMBMessageDataEntity*)obj2;
                                    if (msg1.msgDate < msg2.msgDate)
                                        return NSOrderedAscending;
                                    else if (msg1.msgDate > msg2.msgDate)
                                        return NSOrderedDescending;
                                    else
                                        return NSOrderedSame;
                                }];
                                
                                IMBMessageDataEntity *firstMsg = [showMsgDate objectAtIndex:0];
                                NSDate *date = [DateHelper getDateTimeFromTimeStamp2001:(uint)firstMsg.msgDate];
                                NSDateFormatter *df=[[NSDateFormatter alloc] init];
                                [df setDateFormat:@"EEEE,MMM dd,yyyy,HH:mm"];
                                NSString *dateStr = [df stringFromDate:date];
                                [df release];
                                df = nil;
                                
                                [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"cont_block\"><p class=\"date\">%@</p>", dateStr]];
                                
                                for (IMBMessageDataEntity *item in showMsgDate) {
                                    [_condition lock];
                                    if (_isPause) {
                                        [_condition wait];
                                    }
                                    [_condition unlock];
                                    if (_isStop) {
                                        break;
                                    }
                                    if (item.isSent) {
                                        // 绿色 iMessage
                                        [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"block_table\">"]];
                                        if (!msgItem.isSent){
                                            if (![TempHelper stringIsNilOrEmpty:item.contactName]&&![item.contactName isEqualToString:CustomLocalizedString(@"Common_id_4", nil)]&&_msgChat.sessionType == 43) {
                                                [bodyContent appendString:[NSString stringWithFormat:@"<p class=\"textright\">%@</p>", item.contactName]];
                                            }
                                        }
                                        [bodyContent appendString:@"<table class=\"right\" width=\"auto\" height=\"auto\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td class=\"left_top\"></td><td width=\"auto\" class=\"bg_color\" height=\"12\"></td><td class=\"right_top\"></td></tr>"];
                                        [bodyContent appendString:@"<tr><td height=\"auto\"  class=\"bg_color\" width=\"14\">&nbsp;</td><td class=\"bg_color\">"];
                                        
                                        if ([item.messageText rangeOfString:@"￼"].location != NSNotFound) {
                                            NSString *textStr = [item.messageText stringByReplacingOccurrencesOfString:@"￼" withString:@"☼☆☼"];
                                            NSArray *stringArray = [textStr componentsSeparatedByString:@"☼"];
                                            int index = 0;
                                            int strIndex = 0;
                                            for (NSString *string in stringArray) {
                                                [_condition lock];
                                                if (_isPause) {
                                                    [_condition wait];
                                                }
                                                [_condition unlock];
                                                if (_isStop) {
                                                    break;
                                                }
                                                if ([string isEqualToString:@"☆"]) {
                                                    if (item.attachmentList != nil && item.attachmentList.count > 0) {
                                                        NSInteger totalAttCount = item.attachmentList.count;
                                                        if (index >= totalAttCount) {
                                                            continue;
                                                        }
                                                        
                                                        IMBSMSAttachmentEntity *attach = [item.attachmentList objectAtIndex:index];
//                                                        NSString *extension = [[[attach fileName] lastPathComponent] pathExtension];
//                                                        NSString *attchFileName = [[[attach fileName] lastPathComponent] stringByDeletingPathExtension];
//                                                        NSString *thumbnailName = [NSString stringWithFormat:@"%@%@.%@",attchFileName,@"thumbnail",extension];
                                                        if ([attach.mimeType rangeOfString:@"image"].location != NSNotFound) {
                                                            [bodyContent appendString:[NSString stringWithFormat:@"<a href=\"img/%1$@\" target=\"_blank\"><img src=\"img/%1$@\" /></a>", [attach.fileName lastPathComponent]]];
                                                        } else {
                                                            [bodyContent appendString:[NSString stringWithFormat:@"<a href=\"img/%1$@\" target=\"_blank\">%1$@</a>", [attach.fileName lastPathComponent]]];
                                                        }
                                                        index += 1;
                                                    }
                                                } else {
                                                    if (![TempHelper stringIsNilOrEmpty:string]) {
                                                        [bodyContent appendString:[NSString stringWithFormat:@"%@", string]];
                                                    }
                                                }
                                                
                                                if (index < stringArray.count - 1) {
                                                    [bodyContent appendString:@"<br />"];
                                                }
                                                strIndex += 1;
                                            }
                                        } else {
                                            [bodyContent appendString:[NSString stringWithFormat:@"%@", item.messageText]];
                                        }
                                        [bodyContent appendString:@"</td><td class=\"right_mid\"></td></tr>"];
                                        [bodyContent appendString:@"<tr><td class=\"left_bottom\"></td><td  class=\"bg_color\"></td><td class=\"right_bottom\"></td></tr></table>"];
                                        [bodyContent appendString:@"</div>"];
                                    } else {
                                        // 灰色
                                        [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"block_table\">"]];
                                        if (!msgItem.isSent){
                                            if (![TempHelper stringIsNilOrEmpty:item.contactName]&&![item.contactName isEqualToString:CustomLocalizedString(@"Common_id_4", nil)]&&_msgChat.sessionType == 43) {
                                                [bodyContent appendString:[NSString stringWithFormat:@"<p class=\"textright\">%@</p>", item.contactName]];
                                            }
                                        }
                                   
                                        [bodyContent appendString:@"<table class=\"left\" width=\"auto\" height=\"auto\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td class=\"left_top2\"></td><td width=\"auto\" class=\"bg_color2\" height=\"12\"></td><td class=\"right_top2\"></td></tr>"];
                                        [bodyContent appendString:@"<tr><td height=\"auto\"  class=\"right_mid2\"></td><td class=\"bg_color2\">"];
                                        
                                        if ([item.messageText rangeOfString:@"￼"].location != NSNotFound) {
                                            NSString *textStr = [item.messageText stringByReplacingOccurrencesOfString:@"￼" withString:@"☼☆☼"];
                                            NSArray *stringArray = [textStr componentsSeparatedByString:@"☼"];
                                            int index = 0;
                                            int strIndex = 0;
                                            for (NSString *string in stringArray) {
                                                [_condition lock];
                                                if (_isPause) {
                                                    [_condition wait];
                                                }
                                                [_condition unlock];
                                                if (_isStop) {
                                                    break;
                                                }
                                                if ([string isEqualToString:@"☆"]) {
                                                    if (item.attachmentList != nil && item.attachmentList.count > 0) {
                                                        NSInteger totalAttCount = item.attachmentList.count;
                                                        if (index >= totalAttCount) {
                                                            continue;
                                                        }
                                                        
                                                        IMBSMSAttachmentEntity *attach = [item.attachmentList objectAtIndex:index];
                                                        if ([attach.mimeType rangeOfString:@"image"].location != NSNotFound) {
                                                            [bodyContent appendString:[NSString stringWithFormat:@"<a href=\"img/%1$@\" target=\"_blank\"><img src=\"img/%1$@\" /></a>", [attach.fileName lastPathComponent]]];
                                                        } else {
                                                            [bodyContent appendString:[NSString stringWithFormat:@"<a href=\"img/%1$@\" target=\"_blank\">%1$@</a>", [attach.fileName lastPathComponent]]];
                                                        }
                                                        index += 1;
                                                    }
                                                }else {
                                                    if (![TempHelper stringIsNilOrEmpty:string]) {
                                                        [bodyContent appendString:[NSString stringWithFormat:@"%@", string]];
                                                    }
                                                }
                                                
                                                if (index < stringArray.count - 1) {
                                                    [bodyContent appendString:@"<br />"];
                                                }
                                                strIndex += 1;
                                            }
                                        } else {
                                            [bodyContent appendString:[NSString stringWithFormat:@"%@", item.messageText]];
                                        }
                                        
                                        [bodyContent appendString:@"</td><td class=\"bg_color2\" width=\"14\"></td></tr>"];
                                        [bodyContent appendString:@"<tr><td class=\"left_bottom2\"></td><td class=\"bg_color2\"></td><td class=\"right_bottom2\"></td></tr></table>"];
                                        [bodyContent appendString:@"</div>"];
                                    }
                                    
                                    if (item.isAttachments == YES) {
                                        if (item.attachmentList != nil && item.attachmentList.count > 0) {
                                            ////iCloud和DFU和备份文件的附件都一样在本地，所以用统一方法；
                                            [self exportAttachmentsToLacol:item.attachmentList withPath:_htmlImgFolderPath];
                                        }
                                    }
                                }
                                [bodyContent appendString:@"</div>"];
                            }
                            
//                            if (msgItem.isAttachments == YES) {
//                                if (msgItem.attachmentList != nil && msgItem.attachmentList.count > 0) {
//                                    ////iCloud和DFU和备份文件的附件都一样在本地，所以用统一方法；
//                                    [self exportAttachmentsToLacol:msgItem.attachmentList withPath:_htmlImgFolderPath];
//                                }
//                            }
                        }
                    }
                    
                }
                else {
                    for (IMBMessageDataEntity *msgItem in sortedArray) {
                        @autoreleasepool {
                            [_condition lock];
                            if (_isPause) {
                                [_condition wait];
                            }
                            [_condition unlock];
                            if (_isStop) {
                                break;
                            }
                            pre = [NSPredicate predicateWithFormat:@"self.msgShortDateStr = %@", msgItem.msgShortDateStr];
                            NSArray *tmpArray = [msgArray filteredArrayUsingPredicate:pre];
                            if (tmpArray != nil && tmpArray.count > 0) {
                                NSArray *showMsgDate = [tmpArray sortedArrayUsingComparator:^(id obj1, id obj2){
                                    IMBMessageDataEntity *msg1 = (IMBMessageDataEntity*)obj1;
                                    IMBMessageDataEntity *msg2 = (IMBMessageDataEntity*)obj2;
                                    if (msg1.msgDate < msg2.msgDate)
                                        return NSOrderedAscending;
                                    else if (msg1.msgDate > msg2.msgDate)
                                        return NSOrderedDescending;
                                    else
                                        return NSOrderedSame;
                                }];
                                
                                IMBMessageDataEntity *firstMsg = [showMsgDate objectAtIndex:0];
                                NSDate *date = [DateHelper getDateTimeFromTimeStamp2001:(uint)firstMsg.msgDate];
                                NSDateFormatter *df=[[NSDateFormatter alloc] init];
                                [df setDateFormat:@"EEEE,MMM dd,yyyy,HH:mm"];
                                NSString *dateStr = [df stringFromDate:date];
                                [df release];
                                df = nil;
                                [bodyContent appendString:[NSString stringWithFormat:@"<p class=\"date\">%@</p>", dateStr]];
                                for (IMBMessageDataEntity *item in showMsgDate) {
                                    [_condition lock];
                                    if (_isPause) {
                                        [_condition wait];
                                    }
                                    [_condition unlock];
                                    if (_isStop) {
                                        break;
                                    }
                                    NSString *currentTime = nil;
                                    currentTime = item.contactName;

                                    if (item.isSent) {
                                        // 蓝色 Message
                                        [bodyContent appendString:@"<div class=\"cont_block\">"];
                                        [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"block_table\">"]];
                                        if (!msgItem.isSent){
                                            if (![TempHelper stringIsNilOrEmpty:item.contactName]&&![item.contactName isEqualToString:CustomLocalizedString(@"Common_id_4", nil)]&&_msgChat.sessionType == 43) {
                                                [bodyContent appendString:[NSString stringWithFormat:@"<p class=\"textright\">%@</p>", item.contactName]];
                                            }
                                        }
                           
                                        [bodyContent appendString:@"<table class=\"right\" width=\"auto\" height=\"auto\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td class=\"left_top3\"></td><td width=\"auto\" class=\"bg_color3\" height=\"12\"></td><td class=\"right_top3\"></td></tr>"];
                                        [bodyContent appendString:@"<tr><td height=\"auto\"  class=\"bg_color3\" width=\"14\">&nbsp;</td><td class=\"bg_color3\">"];
                                        
                                        if ([item.messageText rangeOfString:@"￼"].location != NSNotFound) {
                                            NSString *textStr = [item.messageText stringByReplacingOccurrencesOfString:@"￼" withString:@"☼☆☼"];
                                            NSArray *stringArray = [textStr componentsSeparatedByString:@"☼"];
                                            int index = 0;
                                            int strIndex = 0;
                                            for (NSString *string in stringArray) {
                                                [_condition lock];
                                                if (_isPause) {
                                                    [_condition wait];
                                                }
                                                [_condition unlock];
                                                if (_isStop) {
                                                    break;
                                                }
                                                if ([string isEqualToString:@"☆"]) {
                                                    if (item.attachmentList != nil && item.attachmentList.count > 0) {
                                                        NSInteger totalAttCount = item.attachmentList.count;
                                                        if (index >= totalAttCount) {
                                                            continue;
                                                        }
                                                        
                                                        IMBSMSAttachmentEntity *attach = [item.attachmentList objectAtIndex:index];
                                                        if ([attach.mimeType rangeOfString:@"image"].location != NSNotFound) {
                                                            [bodyContent appendString:[NSString stringWithFormat:@"<a href=\"img/%1$@\" target=\"_blank\"><img src=\"img/%1$@\" /></a>", [attach.fileName lastPathComponent]]];
                                                        } else {
                                                            [bodyContent appendString:[NSString stringWithFormat:@"<a href=\"img/%1$@\" target=\"_blank\">%1$@</a>", [attach.fileName lastPathComponent]]];
                                                        }
                                                        index += 1;
                                                    }
                                                }else {
                                                    if (![TempHelper stringIsNilOrEmpty:string]) {
                                                        [bodyContent appendString:[NSString stringWithFormat:@"%@", string]];
                                                    }
                                                }
                                                
                                                if (index < stringArray.count - 1) {
                                                    [bodyContent appendString:@"<br />"];
                                                }
                                                strIndex += 1;
                                            }
                                        } else {
                                            [bodyContent appendString:[NSString stringWithFormat:@"%@", item.messageText]];
                                        }
                                        
                                        [bodyContent appendString:@"</td><td class=\"right_mid3\"></td></tr>"];
                                        [bodyContent appendString:@"<tr><td class=\"left_bottom3\"></td><td  class=\"bg_color3\"></td><td class=\"right_bottom3\"></td></tr></table>"];
                                        [bodyContent appendString:@"</div>"];
                                    } else {
                                        // 灰色
                                        [bodyContent appendString:@"<div class=\"block_table\">"];
                                        [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"block_table\">"]];
                                        if (!msgItem.isSent){
                                            if (![TempHelper stringIsNilOrEmpty:item.contactName]&&![item.contactName isEqualToString:CustomLocalizedString(@"Common_id_4", nil)]&&_msgChat.sessionType == 43) {
                                                [bodyContent appendString:[NSString stringWithFormat:@"<p class=\"textright\">%@</p>", item.contactName]];
                                            }

                                        }
                                        [bodyContent appendString:@"<table class=\"left\" width=\"auto\" height=\"auto\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\"><tr><td class=\"left_top2\"></td><td width=\"auto\" class=\"bg_color2\" height=\"12\"></td><td class=\"right_top2\"></td></tr>"];
                                        [bodyContent appendString:@"<tr><td height=\"auto\"  class=\"right_mid2\"></td><td class=\"bg_color2\">"];
                                        
                                        if ([item.messageText rangeOfString:@"￼"].location != NSNotFound) {
                                            NSString *textStr = [item.messageText stringByReplacingOccurrencesOfString:@"￼" withString:@"☼☆☼"];
                                            NSArray *stringArray = [textStr componentsSeparatedByString:@"☼"];
                                            int index = 0;
                                            int strIndex = 0;
                                            for (NSString *string in stringArray) {
                                                [_condition lock];
                                                if (_isPause) {
                                                    [_condition wait];
                                                }
                                                [_condition unlock];
                                                if (_isStop) {
                                                    break;
                                                }
                                                if ([string isEqualToString:@"☆"]) {
                                                    if (item.attachmentList != nil && item.attachmentList.count > 0) {
                                                        NSInteger totalAttCount = item.attachmentList.count;
                                                        if (index >= totalAttCount) {
                                                            continue;
                                                        }
                                                        
                                                        IMBSMSAttachmentEntity *attach = [item.attachmentList objectAtIndex:index];
                                                        if ([attach.mimeType rangeOfString:@"image"].location != NSNotFound) {
                                                            [bodyContent appendString:[NSString stringWithFormat:@"<a href=\"img/%1$@\" target=\"_blank\"><img src=\"img/%1$@\" /></a>", [attach.fileName lastPathComponent]]];
                                                        } else {
                                                            [bodyContent appendString:[NSString stringWithFormat:@"<a href=\"img/%1$@\" target=\"_blank\">%1$@</a>", [attach.fileName lastPathComponent]]];
                                                        }
                                                        index += 1;
                                                    }
                                                }else {
                                                    if (![TempHelper stringIsNilOrEmpty:string]) {
                                                        [bodyContent appendString:[NSString stringWithFormat:@"%@", string]];
                                                    }
                                                }
                                                
                                                if (index < stringArray.count - 1) {
                                                    [bodyContent appendString:@"<br />"];
                                                }
                                                strIndex += 1;
                                            }
                                        } else {
                                            [bodyContent appendString:[NSString stringWithFormat:@"%@", item.messageText]];
                                        }
                                        
                                        [bodyContent appendString:@"</td><td class=\"bg_color2\" width=\"14\"></td></tr>"];
                                        [bodyContent appendString:@"<tr><td class=\"left_bottom2\"></td><td  class=\"bg_color2\"></td><td class=\"right_bottom2\"></td></tr></table>"];
                                        [bodyContent appendString:@"</div>"];
                                    }
                                    
                                    if (item.isAttachments == YES) {
                                        if (item.attachmentList != nil && item.attachmentList.count > 0) {
                                            ////iCloud和DFU和备份文件的附件都一样在本地，所以用统一方法；
                                            [self  exportAttachmentsToLacol:item.attachmentList withPath:_htmlImgFolderPath];
                                        }
                                    }
                                }
                                [bodyContent appendString:@"</div>"];
                            }
//                            if (msgItem.isAttachments == YES) {
//                                if (msgItem.attachmentList != nil && msgItem.attachmentList.count > 0) {
//                                    ////iCloud和DFU和备份文件的附件都一样在本地，所以用统一方法；
//                                    [self  exportAttachmentsToLacol:msgItem.attachmentList withPath:_htmlImgFolderPath];
//                                }
//                            }
                        }
                    }
                }
            }
            
            [dateArray release];
            dateArray = nil;
        }
    }
    [bodyContent appendString:@"</div></div></body>"];
    retData = [bodyContent dataUsingEncoding:NSUTF8StringEncoding];
    [bodyContent release];
    bodyContent = nil;
//    [_loghandle  writeInfoLog:[NSString stringWithFormat:@"create htm body end,memory:%f",[IMBHelper usedMemory]]];
    return retData;
}
- (NSData*)createHtmFooter {
    NSString *footerContent = @"";
    return [footerContent dataUsingEncoding:NSUTF8StringEncoding];
}
- (NSData*)createHtmHeader:(NSString *)title {
    NSString *headerContent = [NSString stringWithFormat:@"<head><meta charset=\"utf-8\" /><title>%@</title><style type=\"text/css\">*{margin: 0;padding: 0;font: normal 12px \"Helvetica Neue\" , \"Lucida Sans Unicode\" , \"Arial\";color: #333;}body{background: #eee;}img{border: none;}.wrap{width: 640px;margin: 0 auto;}.top{width: 100%%;height: 42px;background: #3dc79c;text-align: center;font-size: 18px;color: #fff;font-weight: bolder;line-height: 42px;}.cont{background: #fff;padding: 18px;min-height: 300px;float: left;}.cont h1{width: 600px;height: auto;font-size: 20px;color: #000;border-bottom: 1px solid #e5e5e5;}.date{width: 110px;font-size: 14px;color: #919191;margin: 20px 0 0 250px;}.imessage{font-size: 14px;color: #919191;text-align: center;margin: 20px 0 -10px 0;}.right{float: right;}.left{float: left;}.left_top{width: 14px;background: url(img/left_top.png) no-repeat;}.right_top{width: 14px;background: url(img/right_top.png) no-repeat;}.right_mid{background: url(img/right_mid.png) repeat-y;}.left_bottom{background: url(img/left_bottom.png) no-repeat;}.right_bottom{width: 20px;height: 14px;background: url(img/right_bottom.png) no-repeat;}.block_table{width: 604px;float: left;margin: 12px 0 0 0;}.block_table tr td{max-width: 302px;}.left_top2{width: 22px;background: url(img/left_top2.png) no-repeat right;}.right_top2{width: 14px;height: 14px;background: url(img/right_top2.png) no-repeat;}.right_mid2{background: url(img/right_mid2.png) repeat-y right;}.left_bottom2{background: url(img/left_bottom2.png) no-repeat left;width: 22px;height: 14px;}.right_bottom2{background: url(img/right_bottom2.png) no-repeat;}.left_top3{width: 14px;background: url(img/left_top3.png) no-repeat;}.right_top3{width: 14px;background: url(img/right_top3.png) no-repeat;}.right_mid3{background: url(img/right_mid3.png) repeat-y;}.left_bottom3{background: url(img/left_bottom3.png) no-repeat;}.right_bottom3{width: 20px;height: 14px;background: url(img/right_bottom3.png) no-repeat;}.bg_color{background: #20a8fe;color: #fff;}.bg_color2{background: #e9e9ed;}.bg_color3{background: #79eb60;color: #fff;}.right tr td a img { max-width:302px; float:right;}.left tr td a img { max-width:302px; float:left;}</style></head>", title];
    return [headerContent dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - export TXT
- (void)messageExportByTXT:(NSString *)exportPath {
    if (_exportTracks .count != 0 && _exportTracks  != nil) {
        NSString *exPath = nil;
        [self createExportAttachmentPath:exportPath];
        for (IMBSMSChatDataEntity *item in _exportTracks ) {
            if (_limitation.remainderCount == 0) {
                [[IMBTransferError singleton] addAnErrorWithErrorName:item.contactName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                continue;
            }
            @autoreleasepool {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    [[IMBTransferError singleton] addAnErrorWithErrorName:item.contactName WithErrorReson:CustomLocalizedString(@"ResultWindow_result_2", nil)];
                    continue;
                }
                
                _currItemIndex ++;
                exPath = [exportPath stringByAppendingPathComponent:[item.contactName stringByAppendingString:@".txt"]];
                if ([_fileManager fileExistsAtPath:exPath]) {
                    exPath = [TempHelper getFilePathAlias:exPath];
                }
                [_fileManager createFileAtPath:exPath contents:nil attributes:nil];
                NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exPath];
                NSString *conString = [self eachMessageInfoByTXT:item withFileHandle:handle];
//                conString = [conString stringByAppendingString:@"\r\n"];
                NSData *retData = [conString dataUsingEncoding:NSUTF8StringEncoding];
                [handle writeData:retData];
                
                [handle closeFile];
                
                if ([_transferDelegate respondsToSelector:@selector(transferFile:)]) {
                    if (![StringHelper stringIsNilOrEmpty:item.contactName]) {
                        [_transferDelegate transferFile:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),item.contactName]];
                    }
                }
                
                if (_currItemIndex > _totalItemCount) {
                    _currItemIndex = _totalItemCount;
                }
                float progress = (((float)_currItemIndex / _totalItemCount) * 100) / _totalItem + _percent;
                if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                    [_transferDelegate transferProgress:progress];
                }
                _successCount ++;
                [_limitation reduceRedmainderCount];
            }
        }
    }
}

- (void)createExportAttachmentPath:(NSString *)path {
    _attachmentsPath = [path stringByAppendingPathComponent:CustomLocalizedString(@"MenuItem_id_56", nil)];
    if ([_fileManager fileExistsAtPath:_attachmentsPath]) {
        _attachmentsPath = [TempHelper getFolderPathAlias:_attachmentsPath];
    }
    [_fileManager createDirectoryAtPath:_attachmentsPath withIntermediateDirectories:YES attributes:nil error:nil];
}

- (NSString *)eachMessageInfoByTXT:(IMBSMSChatDataEntity *)item withFileHandle:(NSFileHandle *)handle {
    NSString *itemString = @"";
    if (item != nil) {
        if (![TempHelper stringIsNilOrEmpty:item.contactName]) {
            itemString = [[itemString stringByAppendingString:item.contactName] stringByAppendingString:@":"];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@":"];
        }
        
        if (![TempHelper stringIsNilOrEmpty:item.chatIdentifier]) {
            itemString = [[itemString stringByAppendingString:item.chatIdentifier] stringByAppendingString:@"\r\n"];
        }else {
            itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@"\r\n"];
        }
        
        itemString = [itemString stringByAppendingString:@"------------------------------------------------------------------------------------------\r\n"];
        
        NSString *toobStr = [[[[[[[[[CustomLocalizedString(@"List_Header_id_Date", nil) stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"List_Header_id_Type", nil)] stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"MenuItem_id_61", nil)] stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"MenuItem_id_19", nil)]  stringByAppendingString:@" \t "] stringByAppendingString:CustomLocalizedString(@"MenuItem_id_56", nil)] stringByAppendingString:@"\r\n"];
        itemString = [itemString stringByAppendingString:toobStr];
        if (item.msgModelList != nil && item.msgModelList.count > 0) {
            int i = 0;
            for (IMBMessageDataEntity *msgItem in item.msgModelList) {
                [_condition lock];
                if (_isPause) {
                    [_condition wait];
                }
                [_condition unlock];
                if (_isStop) {
                    break;
                }
                i ++;
                if (i > 1000) {
                    @autoreleasepool {
                        NSData *data = [itemString dataUsingEncoding:NSUTF8StringEncoding];
                        [handle writeData:data];
                        itemString = @"";
                        i = 0;
                    }
                }
                if (msgItem.msgDate != 0) {
                    itemString = [[itemString stringByAppendingString:[DateHelper dateFrom2001ToString:(long)msgItem.msgDate withMode:2]] stringByAppendingString:@" \t "];
                }else {
                    itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
                }
                
                if (msgItem.isSent == YES) {
                    itemString = [[itemString stringByAppendingString:CustomLocalizedString(@"MenuItem_id_57", nil)] stringByAppendingString:@" \t "];
                }else {
                    itemString = [[itemString stringByAppendingString:CustomLocalizedString(@"Common_id_11", nil)] stringByAppendingString:@" \t "];
                }
                
                if (![TempHelper stringIsNilOrEmpty:msgItem.contactName]) {
                    itemString = [[itemString stringByAppendingString:[self covertSpecialChar:msgItem.contactName]]stringByAppendingString:@" \t "];
                }else {
                    itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
                }
                
                if (![TempHelper stringIsNilOrEmpty:msgItem.msgText]) {
                    itemString = [[itemString stringByAppendingString:[self covertSpecialChar:msgItem.msgText]]stringByAppendingString:@" \t "];
                }else {
                    itemString = [[itemString stringByAppendingString:@"-"] stringByAppendingString:@" \t "];
                }
                
                if (msgItem.isAttachments == YES) {
                    if (msgItem.attachmentList != nil && msgItem.attachmentList.count > 0) {
                        NSString *filePath = [self exportAttachmentsToLacol:msgItem.attachmentList withPath:_attachmentsPath];//iCloud和DFU和备份文件的附件都一样在本地，所以用统一方法；
                        if (![TempHelper stringIsNilOrEmpty:filePath]) {
                            itemString = [itemString stringByAppendingString:filePath];
                        }else {
                            itemString = [itemString stringByAppendingString:@"-"];
                        }
                    }else {
                        itemString = [itemString stringByAppendingString:@"-"];
                    }
                }else {
                    itemString = [itemString stringByAppendingString:@"-"];
                }
                
                itemString = [itemString stringByAppendingString:@"\r\n"];
            }
        }
    }
    return itemString;
}

- (NSString *)covertSpecialChar:(NSString *)str {
    if (![TempHelper stringIsNilOrEmpty:str]) {
        NSString *string = [str stringByReplacingOccurrencesOfString:@"￼" withString:@"<&c;a&>"];
        return string;
    }else {
        return str;
    }
}

- (NSString *) exportAttachmentsToLacol:(NSArray *)attachArray withPath:(NSString *)path {
    NSString *lacolPath = @"";
    for (IMBSMSAttachmentEntity *attachEntity in attachArray) {
//        @autoreleasepool {
            [_condition lock];
            if (_isPause) {
                [_condition wait];
            }
            [_condition unlock];
            if (_isStop) {
                break;
            }
            for (IMBAttachDetailEntity *detailEntity in attachEntity.attachDetailList) {
                lacolPath = [path stringByAppendingPathComponent:detailEntity.fileName] ;
                if ([_fileManager fileExistsAtPath:lacolPath]) {
                    lacolPath = [TempHelper getFilePathAlias:lacolPath];
                }
                if ([_fileManager fileExistsAtPath:detailEntity.backUpFilePath]) {
                    [_fileManager copyItemAtPath:detailEntity.backUpFilePath toPath:lacolPath error:nil];
                }
            }

//        }
        
    }
    return lacolPath;
}

#pragma mark - export 附件方法
- (NSString *)exportSingleAttachmentsToLacol:(NSArray *)attachArray withPath:(NSString *)path {
    NSString *lacolPath = @"";
    for (IMBAttachDetailEntity *detailEntity in attachArray) {
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
        _currItemIndex += 1;
        lacolPath = [path stringByAppendingPathComponent:detailEntity.fileName];
        if ([_fileManager fileExistsAtPath:lacolPath]) {
            lacolPath = [TempHelper getFilePathAlias:lacolPath];
        }
        if ([_fileManager fileExistsAtPath:detailEntity.backUpFilePath]) {
            if([_fileManager copyItemAtPath:detailEntity.backUpFilePath toPath:lacolPath error:nil]) {
                _successCount += 1;
                [_limitation reduceRedmainderCount];
            }
        }
        float progress = (((float)_currItemIndex / _totalItemCount) * 100) / _totalItem + _percent;
        if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
            [_transferDelegate transferProgress:progress];
        }
    }
    if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
        [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
    }
    return lacolPath;
}

@end
