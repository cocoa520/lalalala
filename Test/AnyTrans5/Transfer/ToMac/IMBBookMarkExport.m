//
//  IMBBookMarkExport.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-7.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBBookMarkExport.h"
#import "IMBBookmarkEntity.h"
@implementation IMBBookMarkExport

- (void)startTransfer {
    [_loghandle writeInfoLog:@"BookMarkExport DoProgress enter"];
    if (!_isAllExport) {
        if ([_transferDelegate respondsToSelector:@selector(transferPrepareFileEnd)]) {
            [_transferDelegate transferPrepareFileEnd];
        }
    }
    
    if ([_mode isEqualToString:@"csv"]) {
        [self safariBookmarkExportByCSV:_exportPath];
    }else if ([_mode isEqualToString:@"html"]) {
        if (_exportTracks != nil && _exportTracks.count > 0) {
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"self.isFolder = %d", 1];
            NSArray *tmpArray = [_exportTracks filteredArrayUsingPredicate:pre];
            if (tmpArray != nil && tmpArray.count > 0) {
                _hasHierarchy = YES;
            } else {
                _hasHierarchy = NO;
            }
        } else {
            _hasHierarchy = NO;
        }
        [self checkAndCopyHtmlImage];
        
        _exportName = [NSString stringWithFormat:@"%@.html",CustomLocalizedString(@"MenuItem_id_21", nil)];
        [self writeToMsgFileWithPageTitle:_exportName];
    }
    if (!_isAllExport) {
        sleep(2);
        if ([_transferDelegate respondsToSelector:@selector(transferComplete:TotalCount:)]) {
            [_transferDelegate transferComplete:_successCount TotalCount:_totalItemCount];
        }
    }
    
    [_loghandle writeInfoLog:@"BookMarkExport DoProgress Complete"];
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

#pragma mark - export Html
- (NSData*)createHtmHeader:(NSString *)title {
    NSString *headerContent = nil;
    if (_hasHierarchy) {
        headerContent = [NSString stringWithFormat:@"<head><meta charset=\"utf-8\" /><title>%@</title><style type=\"text/css\">*{margin: 0;padding: 0; font:normal 12px \"Lucida Sans Unicode\", \"Lucida Grande\", \"Arial\";color:#333;}body{ background: #eee}.wrap{ width: 700px; margin: 0 auto;}.top{ width: 100%%; height: 42px; background: #3dc79c; text-align: center; font-size: 18px; color: #fff; font-weight: bolder; line-height: 42px;}.cont{ background: #fff;padding: 10px 18px 0 18px;}.cont p a{ text-decoration:none;}.cont p a:hover{ text-decoration: underline; color: #3DC79C;}.cont_block{padding: 5px 0 0 0; cursor:pointer;}.fileder{ background: url(img/folder2.png) 0 5px no-repeat; line-height: 24px; padding: 0 0 0 48px;}.li_p{background: url(img/folder2.png) 0 5px no-repeat; line-height: 24px; padding: 0 0 0 48px; margin: -15px 0 0 -46px;}.cont_block_ul{ margin: 0 0 0 54px; display: none;}.cont_block_ul_block{margin: 0 0 0 5px; display: none;}#show{ display: block;}.cont_block ul li { list-style:none; background: url(img/file.png) 0 3px no-repeat; padding: 0 0 0 25px; margin: 6px 0 8px 0;}.cont_block ul li a{ text-decoration: none;}.cont_block ul li a:hover{ text-decoration: underline; color: #3DC79C;}.file{ background: url(img/file.png) 20px 5px no-repeat; line-height: 24px; padding: 0 0 0 48px;}.list_fileder{background-image: url() !important;}</style></head>", title];
    } else {
        headerContent = [NSString stringWithFormat:@"<head><meta charset=\"utf-8\" /><title>%@</title><style type=\"text/css\">*{margin: 0;padding: 0; font:normal 12px \"Lucida Sans Unicode\", \"Lucida Grande\", \"Arial\";color:#333;}body{ background: #eee}.wrap{ width: 700px; margin: 0 auto;}.top{ width: 100%%; height: 42px; background: #3dc79c; text-align: center; font-size: 18px; color: #fff; font-weight: bolder; line-height: 42px;}.cont{ background: #fff;}.cont_block{padding:10px  0;}.date{width: 640px; height: 32px; color: #3dc79c; font-size: 12px; font-weight: 12px; line-height: 32px; background: #f6f6f6; padding: 0 18px;}.cont_block ul{ padding:  0 18px; list-style: none;}.cont_block  li{ border-bottom: 1px solid #f4f4f4; padding: 10px 0;}.cont_block  li span{ display: block;   color: #000;}.cont_block  li a{color: #a3a3a3; text-decoration: none;}.cont_block  li a:hover{ color: #3dc79c;}</style></head>", title];
    }
    return [headerContent dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData*)createHtmBody {
    [_loghandle writeInfoLog:@"BookmarkExportHtm Begin"];
    NSData *retData = nil;
    NSMutableString *bodyContent = [[NSMutableString alloc] init];
    if (_hasHierarchy) {
        [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"wrap\">\r\n<div class=\"top\">%@</div>\r\n<div class=\"cont\">\r\n", [NSString stringWithFormat:@"%@",CustomLocalizedString(@"MenuItem_id_21", nil)]]];
        if (_exportTracks != nil && _exportTracks.count > 0) {
            @autoreleasepool {
                for (IMBBookmarkEntity *bookmark in _exportTracks) {
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
                    if (bookmark.isFolder) {
                        [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"cont_block\">\r\n<p class=\"fileder tree\" id=\"show\">%@</p>\r\n", bookmark.name]];
                        [bodyContent appendString:@"<ul class=\"cont_block_ul\">\r\n"];
                        [bodyContent appendString:@"<li class=\"list_fileder\">\r\n"];
                        [self createChildFileHtm:bookmark withBodyContent:bodyContent];
                        [bodyContent appendString:@"</li>\r\n"];
                        [bodyContent appendString:@"</ul>\r\n"];
                        [bodyContent appendString:@"</div>\r\n"];
                    }else {
                        NSString *urlString = bookmark.url;
                        if (![bookmark.url rangeOfString:@"http://"].length > 0 && ![bookmark.url rangeOfString:@"feed://"].length > 0 && ![bookmark.url rangeOfString:@"https://"].length > 0) {
                            if (bookmark.url != nil) {
                                urlString =[@"http://" stringByAppendingString:bookmark.url];
                            }
                        }
                        [bodyContent appendString:[NSString stringWithFormat:@"<p class=\"file\"><a href=\"%@\" target=\"_blank\">%@</a></p>\r\n", urlString, bookmark.name]];
                    }
                    _currItemIndex += 1;
                    if (_currItemIndex > _totalItemCount) {
                        _currItemIndex = _totalItemCount;
                    }
                    float progress = (((float)_currItemIndex / _totalItemCount) * 100) / _totalItem + _percent;
                    if ([_transferDelegate respondsToSelector:@selector(transferProgress:)]) {
                        [_transferDelegate transferProgress:progress];
                    }
//                    BOOL isOutOfCount = [IMBHelper determinWhetherIsOutOfTransferCount];
//                    if (isOutOfCount) {
//                        break;
//                    }
                }
            }
            [bodyContent appendString:@"</div>\r\n</div>\r\n<script type=\"text/javascript\">\r\nfunction getClass(tagName, classStr)\r\n{\r\nif (document.getElementsByClassName)\r\n{\r\nreturn document.getElementsByClassName(classStr)\r\n}else{\r\nvar nodes = document.getElementsByTagName(tagName),\r\nret = []\r\nfor (var i = 0; i < nodes.length; i++)\r\n{\r\nif (hasClass(nodes[i], classStr))\r\n{\r\nret.push(nodes[i]);\r\n}\r\n}\r\nreturn ret;\r\n}\r\n}\r\nfunction hasClass(tagStr, classStr) {\r\nvar arr = tagStr.className.split(/\\s+/);\r\nfor (var i = 0; i < arr.length; i++) {\r\nif (arr[i] == classStr) {\r\nreturn true;\r\n}\r\n}\r\nreturn false;\r\n}\r\nwindow.onload = function() {\r\nvar show = document.getElementById(\"show\");\r\nshow.style.background = \"url(img/folder.png) 0 5px no-repeat\";\r\nshow.parentNode.children[1].style.display = \"block\"\r\n}\r\nvar o = getClass(\"p\",\"tree\");\r\nvar len = o.length;\r\nfor (var i = 0; i < len; i++) {\r\no[i].onclick = function() {\r\nif (this.parentNode.children[1].style.display == \"none\" || this.parentNode.children[1].style.display == \"\") {\r\nthis.parentNode.children[1].style.display = \"block\";\r\nthis.style.background = \"url(img/folder.png) 0 5px no-repeat\";\r\n} else {\r\nthis.parentNode.children[1].style.display = \"none\";\r\nthis.style.background = \"url(img/folder2.png) 0 5px no-repeat\";\r\n}\r\n}\r\n}</script>\r\n</body>"];
                
                
        }
    } else {
        NSString *safarHistory = [CustomLocalizedString(@"SettingView_id_8", nil) stringByReplacingOccurrencesOfString:@":" withString:@""];
        [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"wrap\">\r\n<div class=\"top\">%@</div>\r\n<div class=\"cont\">\r\n<div class=\"cont_block\">\r\n", safarHistory]];
        if (_exportTracks!= nil && _exportTracks.count > 0) {
            [bodyContent appendString:@"<ul>\r\n"];
            for (IMBBookmarkEntity *bookmark in _exportTracks) {
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
                @autoreleasepool {
                    NSString *urlString = bookmark.url;
                    if (![bookmark.url rangeOfString:@"http://"].length > 0 && ![bookmark.url rangeOfString:@"feed://"].length > 0 && ![bookmark.url rangeOfString:@"https://"].length > 0 && bookmark.url != nil) {
                        if (bookmark.url != nil) {
                            urlString =[@"http://" stringByAppendingString:bookmark.url];
                        }
                    }
                    _currItemIndex += 1;
                    NSLog(@"curitemcount:%d",_currItemIndex);
                    [bodyContent appendString:[NSString stringWithFormat:@"<li><span title=\"%1$@\">%1$@</span><a href=\"%1$@\" target=\"_blank\" title=\"%2$@\">%2$@</a></li>\r\n", urlString, bookmark.name]];
                    
                    if (_currItemIndex > _totalItemCount) {
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
            [bodyContent appendString:@"</ul>\r\n"];
        }
        [bodyContent appendString:@"</div>\r\n</div>\r\n</div>\r\n</body>"];
    }
    retData = [bodyContent dataUsingEncoding:NSUTF8StringEncoding];
    [bodyContent release];
    bodyContent = nil;
    [_loghandle writeInfoLog:@"BookmarkExportHtm End"];
    return retData;
}

- (void)createChildFileHtm:(IMBBookmarkEntity *)bookmark withBodyContent:(NSMutableString *)bodyContent {
    if (bookmark.childBookmarkArray.count > 0) {
        for (IMBBookmarkEntity *item in bookmark.childBookmarkArray) {
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
            if (item.isFolder) {
                [bodyContent appendString:[NSString stringWithFormat:@"<div class=\"cont_block\">\r\n<p class=\"fileder tree\" id=\"show\">%@</p>\r\n", item.name]];
                [bodyContent appendString:@"<ul class=\"cont_block_ul\">\r\n"];
                [bodyContent appendString:@"<li class=\"list_fileder\">\r\n"];
                [self createChildFileHtm:item withBodyContent:bodyContent];
                [bodyContent appendString:@"</li>\r\n"];
                [bodyContent appendString:@"</ul>\r\n"];
                [bodyContent appendString:@"</div>\r\n"];
            }else {
                NSString *urlString = item.url;
                if (![item.url rangeOfString:@"http://"].length > 0 && ![item.url rangeOfString:@"feed://"].length > 0 && ![item.url rangeOfString:@"https://"].length > 0) {
                    if (item.url != nil) {
                        urlString =[@"http://" stringByAppendingString:item.url];
                    }
                }
                _currItemIndex ++;
                [bodyContent appendString:[NSString stringWithFormat:@"<li><a href=\"%@\" target=\"_blank\">%@</a></li>\r\n", urlString, item.name]];
                
                if (_currItemIndex > _totalItemCount) {
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
}

- (NSData*)createHtmFooter {
    NSString *footerContent = @"";
    return [footerContent dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - export CSV
- (void)safariBookmarkExportByCSV:(NSString *)exportPath {
//    NSDictionary *userDic = nil;
    if (_exportTracks != nil && _exportTracks.count > 0) {
        NSString *exPath = nil;
        exPath = [exportPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.csv",CustomLocalizedString(@"MenuItem_id_21", nil)]];
                                                             
        if ([_fileManager fileExistsAtPath:exPath]) {
            exPath = [TempHelper getFilePathAlias:exPath];
        }
       
        [_fileManager createFileAtPath:exPath contents:nil attributes:nil];
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:exPath];
        NSString *conString = @"";
        conString = [conString stringByAppendingString:@"Title,URL"];
        for (IMBBookmarkEntity *item in _exportTracks) {
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
                conString = [conString stringByAppendingString:@"\r\n"];
                conString = [conString stringByAppendingString:[self eachSafariBookmarkInfoByCSV:item]];

                NSData *retData = [conString dataUsingEncoding:NSUTF8StringEncoding];
                [handle writeData:retData];
                conString = @"";
                
                if (_currItemIndex > _totalItemCount) {
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

- (NSString *)eachSafariBookmarkInfoByCSV:(IMBBookmarkEntity *)item {
    NSString *itemString = @"";
    if (item != nil) {
        if (![TempHelper stringIsNilOrEmpty:item.name]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.name]];
        }
        itemString = [itemString stringByAppendingString:@","];
        if (![TempHelper stringIsNilOrEmpty:item.url]) {
            itemString = [itemString stringByAppendingString:[self covertSpecialChar:item.url]];
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
