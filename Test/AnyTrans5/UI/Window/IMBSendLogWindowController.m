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
#import "IMBToolbarWindow.h"
@interface IMBSendLogWindowController ()

@end

@implementation IMBSendLogWindowController

- (void)windowDidLoad{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)awakeFromNib{
    if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"]) {
        [[self.window standardWindowButton:NSWindowCloseButton] setHidden:YES];
        [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
        [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
        HoverButton *closeBtn = [[HoverButton alloc] initWithFrame:NSMakeRect(7, 2, 12, 12)];
        [closeBtn setMouseEnteredImage:[NSImage imageNamed:@"close2"] mouseExitImage:[NSImage imageNamed:@"close"] mouseDownImage:[NSImage imageNamed:@"close3"]];
        [closeBtn setTarget:self];
        [closeBtn setAction:@selector(closeWindow:)];
        [[(IMBToolbarWindow *)self.window titleBarView] addSubview:closeBtn];
        [closeBtn release], closeBtn = nil;
    }
    [self.window center];
    logHandle = [IMBLogManager singleton];
    _logFolderPath = [[[IMBHelper getAppTempPath] stringByAppendingPathComponent:@"LogFile"] retain];
    _sendLogZipPath = [[[IMBHelper getAppTempPath] stringByAppendingPathComponent:@"LogFile.zip"] retain];
    fm = [NSFileManager defaultManager];
    [_titleStr setStringValue:CustomLocalizedString(@"Log_id_6", nil)];
    [_middleTitleStr setStringValue:CustomLocalizedString(@"Log_id_8", nil)];
    [_bottomTextStr setStringValue:CustomLocalizedString(@"Log_id_2", nil)];
    
    [_checkTitleStr setStringValue:CustomLocalizedString(@"log_id_7", nil)];
    [_titleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_middleTitleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_bottomTextStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_checkTitleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
        [_titleStr setFont:[NSFont fontWithName:@"Helvetica Neue Thin" size:26]];
    }else {
        [_titleStr setFont:[NSFont fontWithName:@"Helvetica Neue Light" size:26]];
    }
    [_dottedLineView setIsSendLogView:YES];
    [_canCelBtn setCornerRadius:5];
    [_canCelBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_left_otherNormalColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_right_otherNormalColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_left_enterColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_right_enterColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_left_downColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_right_downColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_left_forbiddenColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_right_forbiddenColor", nil)]];
    
    [_canCelBtn setButtonTitle:CustomLocalizedString(@"Calendar_id_12", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withTitleSize:12 WithLightAnimation:NO];
    [_canCelBtn setButtonBorder:YES withNormalBorderColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withEnterBorderColor:[NSColor clearColor] withDownBorderColor:[NSColor clearColor] withForbiddenBorderColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] withBorderLineWidth:1.0];
    [_canCelBtn setTarget:self];
    [_canCelBtn setAction:@selector(canCel:)];
    [_canCelBtn setNeedsDisplay:YES];
    
    [_sendLogBtn setCornerRadius:5];
    [_sendLogBtn setIsLeftRightGridient:YES withLeftNormalBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_left_normalColor", nil)] withRightNormalBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_right_normalColor", nil)] withLeftEnterBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_left_enterColor", nil)] withRightEnterBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_right_enterColor", nil)] withLeftDownBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_left_downColor", nil)] withRightDownBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_right_downColor", nil)] withLeftForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_left_forbiddenColor", nil)] withRightForbiddenBgColor:[StringHelper getColorFromString:CustomColor(@"grideBtn_right_forbiddenColor", nil)]];
    [_sendLogBtn setButtonTitle:CustomLocalizedString(@"Log_id_3", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)] withTitleSize:12 WithLightAnimation:NO];    [_sendLogBtn setTarget:self];
    [_sendLogBtn setAction:@selector(sendLog:)];
    [_sendLogBtn setNeedsDisplay:YES];
    
    NSRect sendBtnRect = [IMBHelper calcuTextBounds:CustomLocalizedString(@"Log_id_3", nil) fontSize:12];
    NSRect cancelBtnRect = [IMBHelper calcuTextBounds:CustomLocalizedString(@"button_id_5", nil) fontSize:12];
    int width = 0;
    if (sendBtnRect.size.width > cancelBtnRect.size.width) {
        width = sendBtnRect.size.width + 40;
    }else{
        width = cancelBtnRect.size.width + 40;
    }
    [_canCelBtn setFrame:NSMakeRect(560/2 - 5 - width, _sendLogBtn.frame.origin.y, width, _sendLogBtn.frame.size.height)];
    [_sendLogBtn setFrame:NSMakeRect(560/2 +5, _canCelBtn.frame.origin.y, width, _canCelBtn.frame.size.height)];
    [_loadingString setHidden:YES];
    [_loadingImg setHidden:YES];
    [_whiteView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
}

- (void)sendLog:(id)sender{
    [_loadingImg setHidden:NO];
    [_canCelBtn setHidden:YES];
    [_sendLogBtn setHidden:YES];
    [_loadingString setHidden:NO];
    [_loadingString setStringValue:CustomLocalizedString(@"Log_loading_Str", nil)];
    NSSize size2 = [_loadingString.cell cellSizeForBounds:_loadingString.frame];
    [_loadingString setFrame:NSMakeRect((_whiteView.frame.size.width - size2.width - 10)/2, _loadingString.frame.origin.y, size2.width + 10, _loadingString.frame.size.height)];
    [_loadingImg setFrame:NSMakeRect( _loadingString.frame.origin.x - 16 , _loadingString.frame.origin.y +7 , _loadingImg.frame.size.width, _loadingImg.frame.size.height)];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(2*M_PI);
    animation.toValue = 0;
    animation.repeatCount = MAXFLOAT;
    animation.duration = 2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_loadingImg setWantsLayer:YES];
    [_loadingImg.layer addAnimation:animation forKey:@""];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self sendFileLogToUs];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_canCelBtn setHidden:NO];
            [_sendLogBtn setHidden:NO];
            [_loadingString setHidden:YES];
            [_loadingImg setHidden:YES];
            NSMutableString *mailUrl = [[NSMutableString alloc] init];
            NSString *sup = CustomLocalizedString(@"support_url", nil);
            [mailUrl appendString:sup];
            //            NSArray *ccRecipients = @[@"1229436624@qq.com"];
            //            [mailUrl appendFormat:@"?cc=%@", ccRecipients[0]];
            //            [mailUrl appendString:@"&subject=myemail"];
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
                }
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
            NSString *logZipFolder = [documentPath stringByAppendingPathComponent:@"iMobieSendLogs"];
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

- (void)dealloc{
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
