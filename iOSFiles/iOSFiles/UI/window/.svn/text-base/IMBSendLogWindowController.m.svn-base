//
//  IMBSendLogWindowController.m
//  PhoneRescue_Android
//
//  Created by long on 5/23/17.
//  Copyright (c) 2017 imobie. All rights reserved.
//

#import "IMBSendLogWindowController.h"
#import "StringHelper.h"
#import "IMBHelper.h"
#import "IMBSoftWareInfo.h"
#import "StringHelper.h"
#import "IMBZipHelper.h"
#import "SystemHelper.h"
#import "NSString+Compare.h"
#import <QuartzCore/QuartzCore.h>
#import "IMBSendLogFile.h"
#import "HoverButton.h"
#import "IMBCommonDefine.h"
#import "IMBiCloudNoTitleBarWinodw.h"
#import "IMBViewAnimation.h"

@interface IMBSendLogWindowController ()

@end

@implementation IMBSendLogWindowController

- (void)windowDidLoad{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)awakeFromNib {
    
    [[(IMBiCloudNoTitleBarWinodw *)self.window maxButton] setHidden:YES];
    [[(IMBiCloudNoTitleBarWinodw *)self.window minButton] setHidden:YES];
    
    [self.window center];
    logHandle = [IMBLogManager singleton];
    _logFolderPath = [[[IMBHelper getAppTempPath] stringByAppendingPathComponent:@"LogFile"] retain];
    _sendLogZipPath = [[[IMBHelper getAppTempPath] stringByAppendingPathComponent:@"LogFile.zip"] retain];
    fm = [NSFileManager defaultManager];
    [_titleStr setStringValue:CustomLocalizedString(@"Log_id_6", nil)];
    [_middleTitleStr setStringValue:CustomLocalizedString(@"Log_id_8", nil)];
    [_bottomTextStr setStringValue:CustomLocalizedString(@"Log_id_2", nil)];
    
    [_checkTitleStr setStringValue:CustomLocalizedString(@"log_id_7", nil)];
    [_titleStr setTextColor:COLOR_TEXT_ORDINARY];
    [_middleTitleStr setTextColor:COLOR_TEXT_EXPLAIN];
    [_bottomTextStr setTextColor:COLOR_TEXT_ORDINARY];
    [_checkTitleStr setTextColor:COLOR_TEXT_ORDINARY];
    [_dottedLineView setIsSendLogView:YES];
    
    [_canCelBtn setIsNoGridient:YES];
    [_canCelBtn setNormalFillColor:COLOR_CANCELBTN_NORMAL WithEnterFillColor:COLOR_CANCELBTN_ENTER WithDownFillColor:COLOR_CANCELBTN_DOWN];
    [_canCelBtn setButtonTitle:CustomLocalizedString(@"Button_Cancel", nil) withNormalTitleColor:COLOR_TEXT_ORDINARY withEnterTitleColor:COLOR_TEXT_ORDINARY withDownTitleColor:COLOR_TEXT_ORDINARY withForbiddenTitleColor:COLOR_TEXT_ORDINARY withTitleSize:12.0 WithLightAnimation:NO];
    [_canCelBtn setButtonBorder:YES withNormalBorderColor:COLOR_BTNBORDER_NORMAL withEnterBorderColor:COLOR_BTNBORDER_ENTER withDownBorderColor:COLOR_BTNBORDER_DOWN withForbiddenBorderColor:COLOR_BTNBORDER_NORMAL withBorderLineWidth:1];
    [_canCelBtn setTarget:self];
    [_canCelBtn setAction:@selector(canCel:)];
    [_canCelBtn setNeedsDisplay:YES];
    
    [_sendLogBtn setIsNoGridient:YES];
    [_sendLogBtn setNormalFillColor:COLOR_OKBTN_NORMAL WithEnterFillColor:COLOR_OKBTN_ENTER WithDownFillColor:COLOR_OKBTN_DOWN];
    [_sendLogBtn setButtonTitle:CustomLocalizedString(@"Button_Ok", nil) withNormalTitleColor:COLOR_View_NORMAL withEnterTitleColor:COLOR_View_NORMAL withDownTitleColor:COLOR_View_NORMAL withForbiddenTitleColor:COLOR_View_NORMAL withTitleSize:12.0 WithLightAnimation:NO];
    [_sendLogBtn setTarget:self];
    [_sendLogBtn setAction:@selector(sendLog:)];
    [_sendLogBtn setNeedsDisplay:YES];
    
    NSRect sendBtnRect = [IMBHelper calcuTextBounds:CustomLocalizedString(@"Button_Ok", nil) fontSize:12];
    NSRect cancelBtnRect = [IMBHelper calcuTextBounds:CustomLocalizedString(@"Button_Cancel", nil) fontSize:12];
    int width = 0;
    if (sendBtnRect.size.width > cancelBtnRect.size.width) {
        width = sendBtnRect.size.width + 40;
    }else{
        width = cancelBtnRect.size.width + 40;
    }
    [_canCelBtn setFrame:NSMakeRect(self.window.frame.size.width/2 - 5 - width, _sendLogBtn.frame.origin.y, width, _sendLogBtn.frame.size.height)];
    [_sendLogBtn setFrame:NSMakeRect(self.window.frame.size.width/2 +5, _canCelBtn.frame.origin.y, width, _canCelBtn.frame.size.height)];
    [_loadingString setHidden:YES];
    [_loadingImg setHidden:YES];
}

- (void)sendLog:(id)sender {
    [_loadingImg setHidden:NO];
    [_canCelBtn setHidden:YES];
    [_sendLogBtn setHidden:YES];
    [_loadingString setHidden:NO];
    [_loadingString setStringValue:CustomLocalizedString(@"Log_loading_Str", nil)];
    NSSize size2 = [_loadingString.cell cellSizeForBounds:_loadingString.frame];
    [_loadingString setFrame:NSMakeRect((480 - size2.width - 10)/2, _loadingString.frame.origin.y, size2.width + 10, _loadingString.frame.size.height)];
    [_loadingView setFrame:NSMakeRect( _loadingString.frame.origin.x - 16 , _loadingString.frame.origin.y + 8 , _loadingImg.frame.size.width, _loadingImg.frame.size.height)];
    
    [_loadingImg setWantsLayer:YES];
    [IMBViewAnimation animationWithRotationWithLayer:_loadingImg.layer];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self sendFileLogToUs];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_canCelBtn setHidden:NO];
            [_sendLogBtn setHidden:NO];
            [_loadingString setHidden:YES];
            [_loadingImg setHidden:YES];
            NSMutableString *mailUrl = [[NSMutableString alloc] init];
            NSString *sup = CustomLocalizedString(@"mailto_sendLog_url", nil);
            [mailUrl appendString:sup];
            [mailUrl appendString:[NSString stringWithFormat:@"?body=%@",CustomLocalizedString(@"Log_id_5", nil)]];
            
            NSString *urlStr = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSWorkspace *ws = [NSWorkspace sharedWorkspace];
            NSURL *url = [NSURL URLWithString: urlStr];
            [ws openURL:url];
            [mailUrl release];
        });
    });
}

// 拷贝日志文件夹临时日志目录中去
- (void)copyLogFileToFolder {
    NSString *logsFolderPath = logHandle.logsFolderPath;
    if (![StringHelper stringIsNilOrEmpty:logsFolderPath] && [fm fileExistsAtPath:logsFolderPath]) {
        NSArray *logs = [fm contentsOfDirectoryAtPath:logsFolderPath error:nil];
        if (logs != nil && logs.count > 0) {
            NSString *targetFolderPath = [_logFolderPath stringByAppendingPathComponent:logsFolderPath.lastPathComponent];
            if (![fm fileExistsAtPath:targetFolderPath]) {
                [fm createDirectoryAtPath:targetFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            for (NSString *fn in logs) {
                NSString *sorceFilePath = [logsFolderPath stringByAppendingPathComponent:fn];
                NSString *targetFilePath = [targetFolderPath stringByAppendingPathComponent:fn];
                [fm copyItemAtPath:sorceFilePath toPath:targetFilePath error:nil];
            }
            NSString *softwareInfoPath = [[IMBHelper getAppSupportPath] stringByAppendingPathComponent:@"IMBSoftware-Info.plist"];
            if ([fm fileExistsAtPath:softwareInfoPath]) {
                [fm copyItemAtPath:softwareInfoPath toPath:[_logFolderPath stringByAppendingPathComponent:@"IMBSoftware-Info.plist"] error:nil];
            }
            
            //拷贝备份文件
            if (_checkBoxBtn.state) {
                NSString *backupPath = [IMBHelper getBackupPath];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSError *error = nil;
                NSArray *fileList = [[NSArray alloc] init];
                fileList = [fileManager contentsOfDirectoryAtPath:backupPath error:&error];
                NSString *backuppathk = [_logFolderPath stringByAppendingPathComponent:@"backupPath"];
                if(![fileManager fileExistsAtPath:backuppathk]){
                    [fileManager createDirectoryAtPath:backuppathk withIntermediateDirectories:YES attributes:nil error:nil];
                }
                for (NSString *path in fileList) {
                    NSArray *sonFileList = [[NSArray alloc] init];
                    
                    NSString *newPath = [backuppathk stringByAppendingPathComponent:path];
                    if(![fileManager fileExistsAtPath:newPath]){
                        [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    NSString *claenPath = [backupPath stringByAppendingPathComponent:path];
                    sonFileList = [fileManager contentsOfDirectoryAtPath:claenPath error:&error];
                    for (NSString *DBPath in sonFileList) {
                        if ([DBPath isEqualToString:@"calender.db"]||[DBPath isEqualToString:@"contact.db"]||[DBPath isEqualToString:@"journal_sms.db"]||[DBPath isEqualToString:@"sms.db"]||[DBPath isEqualToString:@"calllog.db"]||[DBPath isEqualToString:@"whatsapp.db"]||[DBPath isEqualToString:@"wa_contact.db"]||[DBPath isEqualToString:@"line.db"]) {
                            NSString *copyDBPath = [newPath stringByAppendingPathComponent:DBPath];
                            NSString *copyItemAtPath = [claenPath stringByAppendingPathComponent:DBPath];
                            if ([fm fileExistsAtPath:copyItemAtPath]) {
                                [fm copyItemAtPath:copyItemAtPath toPath:copyDBPath error:nil];
                            }
                        }
                    }
                    [sonFileList release];
                    sonFileList = nil;
                }
                [fileList release];
                fileList = nil;
            }
        }
    }
}

- (void)canCel:(id)sender{
    [self.window close];
}

- (void)sendFileLogToUs {
    IMBSendLogFile *sendLog = [[IMBSendLogFile alloc] init];
    @try {
        [sendLog sendLogFile];
        NSFileManager *fm1 = [NSFileManager defaultManager];
        NSString *logFilePath = sendLog.sendLogZipPath;
        if ([fm1 fileExistsAtPath:logFilePath]) {
            // 当日志文件已经存在了就将他移动到一个位置进行弹出
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *logZipFolder = [documentPath stringByAppendingPathComponent:@"SendLogs"];
            if (![fm1 fileExistsAtPath:logZipFolder]) {
                [fm1 createDirectoryAtPath:logZipFolder withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *targetFilePath = [logZipFolder stringByAppendingPathComponent:logFilePath.lastPathComponent];
            if ([fm1 fileExistsAtPath:targetFilePath]) {
                [fm1 removeItemAtPath:targetFilePath error:nil];
            }
            [fm1 moveItemAtPath:logFilePath toPath:targetFilePath error:nil];
            [[NSWorkspace sharedWorkspace] selectFile:targetFilePath inFileViewerRootedAtPath:nil];
        }
    }
    @catch (NSException *exception) {
        [logHandle writeInfoLog:@"Send Log-File failed!"];
    }
    [sendLog release];
    sendLog = nil;
}

- (void)dealloc {
    if (_logFolderPath != nil) {
        [_logFolderPath release];
        _logFolderPath = nil;
    }
    if (_sendLogZipPath != nil) {
        [_sendLogZipPath release];
        _sendLogZipPath = nil;
    }
    [super dealloc];
}

- (void)windowWillClose:(NSNotification *)notification {
    [NSApp stopModal];
}

- (void)closeWindow:(id)sender {
    [self.window close];
}

@end
