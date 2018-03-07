//
//  IMBBackupAnimationViewController.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/9/2.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBBackupAnimationViewController.h"
#import "IMBAMDeviceInfo.h"
#import "TempHelper.h"
#import "IMBNotificationDefine.h"
#import "IMBAnimation.h"
#import "IMBBackupManager.h"
#import "StringHelper.h"

@implementation IMBBackupAnimationViewController
@synthesize tag = _tag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Withipod:(IMBiPod *)ipod  withViewTag:(int)tag{
    if (self) {
        [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        _ipod = [ipod retain];
        _tag = tag;
    }
    return self;
}


- (void)awakeFromNib {
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
        [_bellImgView setHidden:NO];
        [_bellImgView setImage:[StringHelper imageNamed:@"christmas_bell"]];
        [_bellImgView setFrameOrigin:NSMakePoint(340, _bellImgView.frame.origin.y)];
        [_roseProgressBgImageView setHidden:YES];
        [_animateProgressView setDelegate:self];
    }else {
        [_bellImgView setHidden:YES];
        [_roseProgressBgImageView setHidden:YES];
    }
    [_noteImageView setImage:[StringHelper imageNamed:@"transfer_note"]];
    [self.view addSubview:_backupProView];
    [_backupViewProgressView setContentView:_backupProgressView];
    [self configTitle];
    [self addAllObserver];
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_alertViewController setDelegate:self];
    _closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil(_backupProView.frame.size.height - 40), 32, 32)];
    [_closebutton setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin|NSViewNotSizable];
    [_closebutton setTarget:self];
    [_closebutton setAction:@selector(closeWindow:)];
    [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_backupProView addSubview:_closebutton];
    
    [_backupCompleteViewTitel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_backupCompleteViewTitel setStringValue:CustomLocalizedString(@"Transfer_text_Backup_complete", nil)];
//    [_completeTextView setDelegate:self];
    
    NSString *promptStr = CustomLocalizedString(@"Backup_id_4", nil);
    [_toBackupPathBtn WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    //线的颜色
    [_toBackupPathBtn WithMouseExitedLineColor:[NSColor clearColor] WithMouseUpLineColor:[NSColor clearColor] WithMouseDownLineColor:[NSColor clearColor] withMouseEnteredLineColor:[NSColor clearColor]];
    //填充的颜色
    [_toBackupPathBtn WithMouseExitedfillColor:[NSColor clearColor] WithMouseUpfillColor:[NSColor clearColor] WithMouseDownfillColor:[NSColor clearColor] withMouseEnteredfillColor:[NSColor clearColor]];
    [_toBackupPathBtn setTitleName:promptStr WithDarwRoundRect:5 WithLineWidth:2 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [_contentView setIsGradientColorNOCornerPart3:YES];
}

- (void)configTitle {
    [_titleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Backup_Message", nil),_ipod.deviceInfo.deviceName]];
    
    NSString *strla = CustomLocalizedString(@"CloneMerge_Analyse_Message", nil);
    [self setProgressLable:strla];
    
    NSString *str = CustomLocalizedString(@"BackupDevice_Message_Caution", nil);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init] ;
    [style setAlignment:NSLeftTextAlignment];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontNameAttribute,style,NSParagraphStyleAttributeName, nil];
    NSSize size = [str sizeWithAttributes:dic];
    [_noteImageView setFrameOrigin:NSMakePoint((1000- (22+ size.width))/2.0 , _noteImageView.frame.origin.y)];
    [_promptLabel setFrameOrigin:NSMakePoint((1000- (22+ size.width))/2.0 + 22, _promptLabel.frame.origin.y)];
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc] initWithString:str];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_warningColor", nil)] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as2.length)];
    [_promptLabel setAttributedStringValue:as2];
    [as2 release], as2 = nil;
    [style release], style = nil;
}

- (void)setProgressLable:(NSString *)strla {
    if (![TempHelper stringIsNilOrEmpty:strla]) {
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:strla];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.length)];
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [_backUpProgressLable setAttributedStringValue:as];
        [as release], as = nil;
    }
}

- (void)addAllObserver {
    [self removeAllObserver];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(doBackUpStart:) name:NOTIFY_BACKUP_START object:nil];
    [nc addObserver:self selector:@selector(doBackUpComplete:) name:NOTIFY_BACKUP_COMPLETE object:nil];
    [nc addObserver:self selector:@selector(doBackUpProgress:) name:NOTIFY_BACKUP_PROGRESS object:nil];
    [nc addObserver:self selector:@selector(doBackUpError:) name:NOTIFY_BACKUP_ERROR object:nil];
}

- (void)removeAllObserver {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:NOTIFY_BACKUP_START object:nil];
    [nc removeObserver:self name:NOTIFY_BACKUP_PROGRESS object:nil];
    [nc removeObserver:self name:NOTIFY_BACKUP_COMPLETE object:nil];
    [nc removeObserver:self name:NOTIFY_BACKUP_ERROR object:nil];
}

- (void)startBackupDevice {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:NO]];
    [_animateProgressView startAnimation];
    [_backupAnimationView startAnimation];
    [_animateProgressView setLoadAnimation];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _backupProgress = 0.0;
        _isCanceled = NO;
        _isError = NO;
        _isProgressStard = NO;
        [ScanStatus shareInstance].stopScan = NO;
        [ScanStatus shareInstance].stopClean = NO;
        [ScanStatus shareInstance].isPause = NO;
        if (_backRestore != nil) {
            [_backRestore release];
            _backRestore = nil;
        }
        _backRestore = [[IMBBackAndRestore alloc] initWithIPod:_ipod];
        [_backRestore backUp];
    });
}


#pragma mark -- 备份过程中的通知方法
- (void)doBackUpStart:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)doBackUpProgress:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_isProgressStard) {
            [_animateProgressView removeAnimationImgView];
            _isProgressStard = YES;
        }
        NSDictionary *dic = [notification userInfo];
        if (dic != nil) {
            double progress = [[dic objectForKey:@"BRProgress"] doubleValue];
            if (progress >=100){
                progress = 100.0;
            }
            if (progress < _backupProgress) {
                progress = _backupProgress;
            }else {
                _backupProgress = progress;
            }
            if (progress == 100.0) {
                [_animateProgressView setProgressWithOutAnimation:progress];
            }else {
                [_animateProgressView setProgress:progress];
            }
            [self setProgressLable:[NSString stringWithFormat:CustomLocalizedString(@"backup_id_text_9", nil),(int)progress]];
        }
    });
}

- (void)doBackUpComplete:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_backupAnimationView stopAnimation];
        [_animateProgressView pauseTimer];
        [_animateProgressView removeAnimationImgView];

        if (!_isCanceled) {
            if (!_isError) {//备份完成
                [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_BACKUP_COMPELTE object:[NSNumber numberWithInt:_tag] userInfo:nil];
//                [_backupViewProgressView setContentView:_backupCompleteView];
//                IMBBackupManager *manager = [IMBBackupManager shareInstance];
//                SimpleNode *curNdoe = [manager getSingleBackupRootNode:_backRestore.deviceBackupPath];
//                if (curNdoe != nil) {
//                    if (_dataSourceArray == nil) {
//                        _dataSourceArray = [[NSMutableArray alloc] init];
//                    }
//                    [_dataSourceArray insertObject:curNdoe atIndex:0];
//                    [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
//                    [_tableView reloadData];
//                }
//                [self reload:nil];
                
            }
        }else {//备份取消，删除备份文件及对应phoneclean下的备份,返回主界面;
            NSString *backupPath = _backRestore.deviceBackupPath;
            NSFileManager *fm = [NSFileManager defaultManager];
            if (![StringHelper stringIsNilOrEmpty:_ipod.deviceInfo.serialNumberForHashing] && [fm fileExistsAtPath:backupPath]) {
                [fm removeItemAtPath:backupPath error:nil];
            }
            [_backRestore release];
            _backRestore = nil;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
        _isBackupComplete = YES;
        [self removeAllObserver];
    });
}

-(void)backupError:(id)sender
{
    _isError = YES;
    NSDictionary *userInfo = [sender userInfo];
   if (userInfo != nil) {
        NSNumber *errorid = nil;
        if ([userInfo.allKeys containsObject:@"errorId"]) {
            errorid = [userInfo objectForKey:@"errorId"];
        }
        NSString *errorStr = nil;
        if ([userInfo.allKeys containsObject:@"errorReason"]) {
            errorStr = [userInfo objectForKey:@"errorReason"];
        }
        [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"errorid:%d   errorReason:%@",errorid.intValue,errorStr]];
        _isOkAction = YES;
        if ((errorid.intValue == -36)) {
            NSString *errMsg = CustomLocalizedString(@"Common_id_13", nil);
            [self showAlertText:errMsg OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        }else{
            NSString *errMsg = [NSString stringWithFormat:CustomLocalizedString(@"CloneMerge_Message_Id_3", nil),_ipod.deviceInfo.deviceName];
            [self showAlertText:errMsg OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        }
    }
}

- (void)doBackUpError:(NSNotification *)notification {
//    dispatch_async(dispatch_get_main_queue(), ^{
    
    [self performSelectorOnMainThread:@selector(backupError:) withObject:notification waitUntilDone:YES];
   //        }
//    });
}

- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText {
    if (_alertViewController == nil) {
        return 0;
    }
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    return [_alertViewController showAlertText:alertText OKButton:OkText SuperView:view];
}

- (void)closeWindow:(id)sender {
    if (_isBackupComplete) {
        [self animationRemoveBackupView];
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_BACKUP_COMPELTE object:[NSNumber numberWithInt:_tag] userInfo:nil];
    }else {
        if (_backRestore != nil) {
            [_backRestore pauseScan];
        }
        [_alertViewController setIsStopPan:YES];
        int result = [self showAlertText:CustomLocalizedString(@"Main_Window_Stop_WhileBackup", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)];
        [_alertViewController setIsStopPan:NO];
        if (result) {
            if (_backRestore != nil) {
                _isCanceled = YES;
                [_backRestore stopScan];
                [_backRestore resumeScan];
            }
            [self animationRemoveBackupView];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_BACKUP_ERROE object:[NSNumber numberWithInt:_tag] userInfo:nil];
        }else {
            if (_backRestore != nil) {
                [_backRestore resumeScan];
            }
        }
    }

}

- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText CancelButton:(NSString *)cancelText {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            [view setHidden:NO];
            break;
        }
    }
    [view setHidden:NO];
    return [_alertViewController showAlertText:alertText OKButton:OkText CancelButton:cancelText SuperView:view];
}

- (void)animationRemoveBackupView {
    [_contentView setAutoresizingMask:NSViewMinYMargin];
    [_backupProView setFrame:NSMakeRect(0, -10, _backupProView.frame.size.width, _backupProView.frame.size.height + 10)];
    [_backupProView setWantsLayer:YES];
    //    [_backupProView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-_backupProView.frame.size.height] repeatCount:1] forKey:@"moveY"];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:10] repeatCount:1];
        [_backupProView.layer addAnimation:anima1 forKey:@"deviceImageView"];
    } completionHandler:^{
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:10] Y:[NSNumber numberWithInt:-_backupProView.frame.size.height] repeatCount:1];
        [_backupProView.layer addAnimation:anima1 forKey:@"deviceImageView"];
    }];
    
    [self performSelector:@selector(removeAnimationView) withObject:nil afterDelay:0.6];
}

- (void)removeAnimationView {
    [self.view removeFromSuperview];
}

- (void)doOkBtnOperation:(id)sender {
    if (_isOkAction) {
        //移除进度界面;
        if (_backRestore != nil) {
            NSString *backupPath = _backRestore.deviceBackupPath;
            NSFileManager *fm = [NSFileManager defaultManager];
            if (![StringHelper stringIsNilOrEmpty:_ipod.deviceInfo.serialNumberForHashing] && [fm fileExistsAtPath:backupPath]) {
                [fm removeItemAtPath:backupPath error:nil];
            }
            [_backRestore release];
            _backRestore = nil;
        }
        [self animationRemoveBackupView];
        [self removeAllObserver];
        _isOkAction = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
        [self closeWindow:nil];
    }
}

-(void)secireOkBtnOperation:(id)sender with:(NSString *)pass {
    
}

- (void)moveBellImageView:(int)moveX {
    if (_bellImgView != nil) {
        [_bellImgView setFrameOrigin:NSMakePoint(340 + moveX, _bellImgView.frame.origin.y)];
    }
}

-(void)dealloc
{
    if (_backRestore != nil) {
        [_backRestore release];
        _backRestore = nil;
    }
    [_ipod release],_ipod = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [super dealloc];
}

@end
