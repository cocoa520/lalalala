//
//  IMBCheckUpdater.m
//  PhoneRescue
//
//  Created by zhang yang on 12-12-31.
//  Copyright (c) 2012年 zhang yang. All rights reserved.
//

#import "IMBCheckUpdater.h"
#import "TempHelper.h"
//#import "IMBDownloadIPSWConfig.h"
#import "IMBSoftWareInfo.h"

@implementation IMBCheckUpdater

- (id)initWithManual:(bool)isManual {
    self = [super init];
    if (self) {
        software = [IMBSoftWareInfo singleton];
        _updateFileUrlPath =  CustomLocalizedString(@"update_url_1", nil);
        _updateFileName = CustomLocalizedString(@"update_url_2", nil);
        NSString *tempPath = [TempHelper getAppTempPath];
        _updateFileLocalPath = [[tempPath stringByAppendingPathComponent:_updateFileName] retain];
        _isManual = isManual;
        _isMustUpdate = false;
    }
    return self;
}

- (void)checkUpdate {
    NSURL *url = [NSURL URLWithString:_updateFileUrlPath];
//    NSURLRequest* request = [NSURLRequest requestWithURL:[url copy]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    if (_urlDown) {
        [_urlDown release];
        _urlDown = nil;
    }
    _urlDown = [[NSURLDownload alloc] initWithRequest:request delegate:self];
    if (_urlDown) {
        NSFileManager* fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:_updateFileLocalPath]) {
            [fm removeItemAtPath:_updateFileLocalPath error:nil];
        }
        [_urlDown setDestination:_updateFileLocalPath allowOverwrite:NO];
    }
//    [urlDown release];
}


- (IMBUpdateInfo*) parsePlistContent:(NSString*)parseFilePath {
    IMBUpdateInfo *updateInfo = [[IMBUpdateInfo alloc] init];
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:parseFilePath] == YES) {
        NSMutableDictionary *rootDic =[NSMutableDictionary dictionaryWithContentsOfFile:parseFilePath];
        if ([rootDic.allKeys containsObject:@"mac"]) {
            NSDictionary *macRootDic = [rootDic objectForKey:@"mac"];
            if (macRootDic != nil) {
                NSDictionary *macUpdateDic = [macRootDic objectForKey:@"update"];
                if (macUpdateDic != nil) {
                    NSDictionary *updateProductDic = [macUpdateDic objectForKey:@"product"];
                    if (updateProductDic) {
                        updateInfo.buildDate = [NSString stringWithFormat:@"%@", [updateProductDic objectForKey:@"build"]];
                        updateInfo.minBuildDate = [NSString stringWithFormat:@"%@", [updateProductDic objectForKey:@"min"]];
                        updateInfo.version = [updateProductDic objectForKey:@"version"];
                        updateInfo.iOSversion = [updateProductDic objectForKey:@"ios"];
                        updateInfo.itunesVersion = [updateProductDic objectForKey:@"itunes"];
                        if ([updateProductDic objectForKey:@"isauto"]) {
                            updateInfo.isauto = [[updateProductDic objectForKey:@"isauto"] boolValue];
                        }
                    }
                    
                    NSArray *updateTextArray = [macUpdateDic objectForKey:@"text"];
                    if (updateTextArray != nil) {
                        for (int i = 0; i < updateTextArray.count; i++) {
                            NSDictionary *textDic = [updateTextArray objectAtIndex:i];
                            IMBUpdateLogDetail *detail = [[IMBUpdateLogDetail alloc] init];
                            detail.language = [textDic objectForKey:@"language"];
                            detail.updateLogs = [textDic objectForKey:@"text"];
                            detail.updateUrl = [textDic objectForKey:@"url"];
                            [updateInfo.updateLogArray addObject:detail];
                            [detail release];
                        }
                    }
                }
            }
            if ([macRootDic.allKeys containsObject:@"activity"]) {
                IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
                NSDictionary *activityDic = [macRootDic objectForKey:@"activity"];
                if (activityDic != nil) {
                    if ([activityDic.allKeys containsObject:@"iosmover"]) {
                        NSDictionary *iosDic = [activityDic objectForKey:@"iosmover"];
                        if (iosDic) {
                            if ([iosDic.allKeys containsObject:@"URL"]) {
                                NSArray *urlArr = [iosDic objectForKey:@"URL"];
                                if (urlArr) {
                                    [soft.activityInfo.iosmoverArray addObjectsFromArray:urlArr];
                                }
                            }
                            if ([iosDic.allKeys containsObject:@"ButtonContent"]) {
                                NSString *btnStr = [iosDic objectForKey:@"ButtonContent"];
                                [soft.activityInfo setIosBtnWord:btnStr];
                            }
                            if ([iosDic.allKeys containsObject:@"ViewDescription"]) {
                                NSString *descriptiontr = [iosDic objectForKey:@"ViewDescription"];
                                [soft.activityInfo setIosDescriptionWord:descriptiontr];
                            }
                            if ([iosDic.allKeys containsObject:@"ViewTitle"]) {
                                NSString *titleStr = [iosDic objectForKey:@"ViewTitle"];
                                [soft.activityInfo setIosTitleWord:titleStr];
                            }
                            if ([iosDic.allKeys containsObject:@"ViewSubTitle"]) {
                                NSString *subTitleStr = [iosDic objectForKey:@"ViewSubTitle"];
                                [soft.activityInfo setIosSubTitleWord:subTitleStr];
                            }
                        }
                    }
                    if ([activityDic.allKeys containsObject:@"download"]) {
                        NSDictionary *downDic = [activityDic objectForKey:@"download"];
                        if (downDic) {
                            if ([downDic.allKeys containsObject:@"ListTitle1_URL"]) {
                                soft.activityInfo.downloadUrlInfo.moveVideoUrl = [downDic objectForKey:@"ListTitle1_URL"];
                            }
                            if ([downDic.allKeys containsObject:@"ListTitle2_URL"]) {
                                soft.activityInfo.downloadUrlInfo.convertVideoUrl = [downDic objectForKey:@"ListTitle2_URL"];
                            }
                            if ([downDic.allKeys containsObject:@"ListTitle3_URL"]) {
                                soft.activityInfo.downloadUrlInfo.migrateMediaUrl = [downDic objectForKey:@"ListTitle3_URL"];
                            }
                            if ([downDic.allKeys containsObject:@"ListTitle4_URL"]) {
                                soft.activityInfo.downloadUrlInfo.transferUrl = [downDic objectForKey:@"ListTitle4_URL"];
                            }
                            if ([downDic.allKeys containsObject:@"ListTitle5_URL"]) {
                                soft.activityInfo.downloadUrlInfo.gatherUrl = [downDic objectForKey:@"ListTitle5_URL"];
                            }
                            if ([downDic.allKeys containsObject:@"donwloadCount"]) {
                                soft.activityInfo.downloadUrlInfo.downloadCount = [[downDic objectForKey:@"donwloadCount"] intValue];
                            }
                        }
                    }
                    if ([activityDic.allKeys containsObject:@"icloud"]) {
                        NSDictionary *icloudDic = [activityDic objectForKey:@"icloud"];
                        if (icloudDic) {
                            if ([icloudDic.allKeys containsObject:@"ListTitle1_URL"]) {
                                soft.activityInfo.icloudUrlInfo.moveVideoUrl = [icloudDic objectForKey:@"ListTitle1_URL"];
                            }
                            if ([icloudDic.allKeys containsObject:@"ListTitle2_URL"]) {
                                soft.activityInfo.icloudUrlInfo.convertVideoUrl = [icloudDic objectForKey:@"ListTitle2_URL"];
                            }
                            if ([icloudDic.allKeys containsObject:@"ListTitle3_URL"]) {
                                soft.activityInfo.icloudUrlInfo.migrateMediaUrl = [icloudDic objectForKey:@"ListTitle3_URL"];
                            }
                            if ([icloudDic.allKeys containsObject:@"ListTitle4_URL"]) {
                                soft.activityInfo.icloudUrlInfo.transferUrl = [icloudDic objectForKey:@"ListTitle4_URL"];
                            }
                            if ([icloudDic.allKeys containsObject:@"ListTitle5_URL"]) {
                                soft.activityInfo.icloudUrlInfo.gatherUrl = [icloudDic objectForKey:@"ListTitle5_URL"];
                            }
                        }
                    }
                }
            }
        }
    }
    if (!_isManual) {
        updateInfo.isauto = YES;
    } else {
        updateInfo.isauto = NO;
    }
    return updateInfo;
}

//- (void)download:(NSURLDownload *)aDownload decideDestinationWithSuggestedFilename:(NSString *)filename {
//    NSFileManager* fm = [NSFileManager defaultManager];
//    if ([fm fileExistsAtPath:_updateFileLocalPath]) {
//        [fm removeItemAtPath:_updateFileLocalPath error:nil];
//    }
//    [aDownload setDestination:_updateFileLocalPath allowOverwrite:NO];
//}

- (void)downloadDidFinish:(NSURLDownload *)download {
    NSLog(@"downloadDidFinish");
    IMBUpdateInfo *updateInfo = [self parsePlistContent:_updateFileLocalPath];
    if (updateInfo) {
        if (_listener && [_listener respondsToSelector:@selector(UpdaterStatus: UpdateInfo: Manual:)]) {
            if ([software.buildDate compare:updateInfo.buildDate options:NSNumericSearch] ==
                NSOrderedAscending) {
                if ([software.buildDate compare:updateInfo.minBuildDate options:NSNumericSearch] ==
                    NSOrderedAscending) {
                    software.mustUpdate = true;
                    updateInfo.isMustUpdate = true;
                    software.mustUpdateBuild = updateInfo.buildDate;
                    software.mustUpdateVersion = updateInfo.version;
                    if (updateInfo.updateLogArray) {
                        IMBUpdateLogDetail *detail =  [updateInfo.updateLogArray objectAtIndex:0];
                        software.mustUpdateURL = detail.updateUrl;
                    }
                } else {
                    software.mustUpdate = false;
                    software.mustUpdateBuild = @"";
                    software.mustUpdateVersion = @"";
                    software.mustUpdateURL = @"";
                    updateInfo.isMustUpdate = false;
                }
                [software save];
                
                //需要做过滤的判断
                if (!_isManual) {
                    NSString *skipBuildDate = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"skip_build_date"];
                    software.skipedVersion = skipBuildDate;
                    int result = [updateInfo.buildDate compare:software.skipedVersion options:NSNumericSearch];
                    //如果是skiped的话就不弹出界面
                    NSLog(@"software.skipedVersion %@", software.skipedVersion);
                    if (software.skipedVersion != nil && (result == NSOrderedAscending || result == NSOrderedSame)) {
                        [_listener UpdaterStatus:UpdaterStatus_UpToDate UpdateInfo:updateInfo Manual:_isManual];
                        return;
                    }
                }
                [_listener UpdaterStatus:UpdaterStatus_HasUpdate UpdateInfo:updateInfo Manual:_isManual];
            } else {
                software.mustUpdate = false;
                software.mustUpdateBuild = @"";
                software.mustUpdateVersion = @"";
                software.mustUpdateURL = @"";
                [software save];
                [_listener UpdaterStatus:UpdaterStatus_UpToDate UpdateInfo:updateInfo Manual:_isManual];
            }
        }
    } else {
        if (_listener && [_listener respondsToSelector:@selector(UpdaterStatus: UpdateInfo: Manual:)]) {
            [_listener UpdaterStatus:UpdaterStatus_GetFileError UpdateInfo:nil Manual:_isManual];
        }
    }
}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error {
    //这里可以循环3次来测试这个问题
    NSLog(@"download error");
    if (_listener && [_listener respondsToSelector:@selector(UpdaterStatus: UpdateInfo: Manual:)]) {
        [_listener UpdaterStatus:UpdaterStatus_NetworkError UpdateInfo:nil Manual:_isManual];
    }    
}

- (void) setListener:(id)listener {
    _listener = listener;
}

- (void)dealloc
{
    if (_urlDown) {
        [_urlDown release];
        _urlDown = nil;
    }
    [_updateFileLocalPath release];
    [super dealloc];
}


@end
