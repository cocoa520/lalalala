//
//  IMBTransferViewController.m
//  AnyTrans
//
//  Created by iMobie on 8/1/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBAndroidTransferViewController.h"
#import "IMBAnimation.h"
#import "SystemHelper.h"
#import "IMBBaseViewController.h"
#import "IMBNotificationDefine.h"
#import "ATTracker.h"
#import "CommonEnum.h"
#import "ContactConversioniCloud.h"
#import "IMBADContactToiCloud.h"
#import "IMBAndroidTransferToiTunes.h"
#import "IMBADCalendarToiCloud.h"
#import "IMBADPhotoToiCloud.h"
#import "IMBTransferToiOS.h"
#import "MessageConversioniOS.h"
#import "ContactConversioniOS.h"
#import "CallLogConversioniOS.h"
#import "CalendarConversioniOS.h"
#import "IMBContactExport.h"
#import "IMBCalendarsToDevice.h"

@interface IMBTransferViewController ()

@end

@implementation IMBAndroidTransferViewController
@synthesize delegate = _delegate;
@synthesize isStop = _isStop;
#pragma mark - 初始化
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

//设备到设备初始化
- (id)initWithIpodKey:(IMBiPod *)ipod withAndroid:(IMBAndroid *)android SelectDic:(NSDictionary *)selectedDic withCategoryNodesEnum:(CategoryNodesEnum)categoryNodeEnum{
    if (self = [super initWithNibName:@"IMBAndroidTransferViewController" bundle:nil]) {
        _transferType = TransferToDevice;
        _iPod = ipod;
        _android = android;
        _category = categoryNodeEnum;
        _selectDic = [selectedDic retain];
    }
    return self;
}

//设备到iCloud
- (id)initWithAndroidToiCloud:(IMBiCloudManager *)iCloudManager withAndroid:(IMBAndroid *)android SelectDic:(NSDictionary *)selectedDic withDataAry:(NSArray*)dataAry withCategoryNodesEnum:(CategoryNodesEnum)categoryNodeEnum{
    if (self = [super initWithNibName:@"IMBAndroidTransferViewController" bundle:nil]) {
        _transferType = TransferToiCloud;
        _selectDic = [selectedDic retain];
        _category = categoryNodeEnum;
        _iCloudManager = iCloudManager;
        _android = android;
        _dataAry = dataAry;
    }
    return self;
}

//设备到iTunes
- (id)initWithAndroidToiTunesAndroid:(IMBAndroid *)android SelectDic:(NSDictionary *)selectedDic withCategoryNodesEnum:(CategoryNodesEnum)categoryNodeEnum{
    if (self = [super initWithNibName:@"IMBAndroidTransferViewController" bundle:nil]) {
        _transferType = TransferToiTunes;
        _selectDic = [selectedDic retain];
        _category = categoryNodeEnum;
        _android = android;
    }
    return self;
}

- (void)awakeFromNib{
    _androidAlertViewController = [[IMBAndroidAlertViewController alloc] initWithNibName:@"IMBAndroidAlertViewController" bundle:nil];
    [_androidAlertViewController setDelegate:self];
    
    if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"roseSkin"]) {
        [_bellImgView setHidden:YES];
        [_roseProgressBgImageView setHidden:NO];
        [_roseProgressBgImageView setImage:[StringHelper imageNamed:@"rose_progress_bg"]];
    }else if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
        [_bellImgView setHidden:NO];
        [_bellImgView setImage:[StringHelper imageNamed:@"christmas_bell"]];
        [_bellImgView setFrameOrigin:NSMakePoint(340, _bellImgView.frame.origin.y)];
        [_roseProgressBgImageView setHidden:YES];
        [_animateProgressView setDelegate:self];
    }else {
        [_bellImgView setHidden:YES];
        [_roseProgressBgImageView setHidden:YES];
    }
    NSString *str = @"close";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_alertViewController setDelegate:self];
    _isTransferComplete = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:NO]];
    _closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil(_contentView.frame.origin.y + _contentView.frame.size.height - 12), 32, 32)];
    [_closebutton setTarget:self];
    [_closebutton setAction:@selector(closeWindow:)];
    [_closebutton setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin|NSViewNotSizable];
    [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_contentProView addSubview:_closebutton];
    [_contentProView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor_top", nil)]];
    _textView.delegate = self;
    [_contentView addSubview:_proContentView];
    [_contentBox setContentView:_contentProView];
    [self addAnimationView];
    [self configTitle];
    [_titleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    if (_transferType == TransferToDevice) {
        [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),[IMBCommonEnum categoryNodesEnumToName:_category]]];
        if (_category == Category_Message||_category == Category_CallHistory) {
            _baseTransfer = [[IMBTransferToiOS alloc] initWithIPodkey:_iPod.uniqueKey Android:_android TransferDataDic:_selectDic TransferDelegate:self];
            ContactConversioniOS *contactConversion = [[ContactConversioniOS alloc] init];
            MessageConversioniOS *messageConversion = [[MessageConversioniOS alloc] init];
            messageConversion.android = _android;
            CallLogConversioniOS *callLogConversion = [[CallLogConversioniOS alloc] init];
            CalendarConversioniOS *calendarConversion = [[CalendarConversioniOS alloc] init];
            [(IMBTransferToiOS *)_baseTransfer setMessagConversion:messageConversion ContactConversion:contactConversion CallHistoryConversion:callLogConversion CalendarConversion:calendarConversion];
            [contactConversion release];
            [messageConversion release];
            [callLogConversion release];
            [calendarConversion release];
        }else if (_category == Category_Calendar) {
            NSArray *selectAry = [_selectDic objectForKey:[NSNumber numberWithInt:_category]];
            _calendarsBaseTransfer = [[IMBCalendarsToDevice alloc] initWithCalendarID:[_selectDic objectForKey:@"calendarID"] selectedArray:selectAry desiPodKey:_iPod.uniqueKey delegate:self];
        }else if (_category == Category_Contacts){
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                ContactConversioniOS *contactConversion = [[ContactConversioniOS alloc] init];
                NSMutableArray *ary = [_selectDic objectForKey:[NSNumber numberWithInt:Category_Contacts]];
                NSMutableArray *contactSelecAry = [[NSMutableArray alloc]init];
                for (IMBADContactEntity *entity in ary) {
                    [contactSelecAry addObject:[contactConversion conversionContactEntity:entity]];
                }
                IMBContactExport *contactExport = [[IMBContactExport alloc]initWithIPodkey:_iPod.uniqueKey withDelegate:self];
                contactExport.contactManager = [[IMBContactManager alloc]initWithAMDevice:_iPod.deviceHandle];
                [contactExport importContact:contactSelecAry];
                [contactConversion release];
                [contactExport release];
                contactExport = nil;
                [contactSelecAry release];
                contactSelecAry = nil;
            });
        }else{
            _baseTransfer = [[IMBTransferToiOS alloc] initWithIPodkey:_iPod.uniqueKey Android:_android TransferDataDic:_selectDic TransferDelegate:self];
        }
    }else if (_transferType == TransferToiCloud) {
        [_titleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"Transfer_Item_Title", nil),[IMBCommonEnum categoryNodesEnumToName:_category]]];
        ContactConversioniCloud *contactConversion = [[ContactConversioniCloud alloc] init];
        CalendarConversioniCloud *calendarConversion = [[CalendarConversioniCloud alloc] init];
        PhotoConversioniCloud *photoConversion = [[PhotoConversioniCloud alloc] init];
        _baseTransfer = [[IMBTransferToiCloud alloc] initWithTransferDataDic:_selectDic TransferDelegate:self iCloudManager:_iCloudManager withAndroid:_android];
        [(IMBTransferToiCloud*)_baseTransfer setContactConversion:contactConversion calendarConversion:calendarConversion photoConversion:photoConversion];
        [contactConversion release];
        contactConversion = nil;
        [calendarConversion release];
        calendarConversion = nil;
        [photoConversion release];
        photoConversion = nil;
    }else if (_transferType == TransferToiTunes) {
        _baseTransfer = [[IMBAndroidTransferToiTunes alloc] initWithAndroid:_android TransferDataDic:_selectDic TransferDelegate:self];
    }
    [self performSelector:@selector(startTransfer) withObject:nil afterDelay:0.5];
    [self reSetTransferTitleAndSubTitleFrameOrign];
}

- (void)addAnimationView{
    if (_category == Category_Music||_category == Category_Movies||_category == Category_Ringtone) {
        _animationType = MediaAnimation;
        [_mediaAnimationView setFrameOrigin:NSMakePoint(50, 188)];
        [_contentView addSubview:_mediaAnimationView];
    }else {
        int value = arc4random() % 3;
        if (value == 0) {
            _animationType = CustomAnimation;
            [self setBoatAnimationImage:_customAnimationView];
            [_customAnimationView setFrameOrigin:NSMakePoint(50, 188)];
            [_contentView addSubview:_customAnimationView];
        }else if (value == 1) {
            _animationType = CarAnimation;
            [self setBoatAnimationImage:_carAnimationView];
            if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"] || [[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
                [_carAnimationView setFrameOrigin:NSMakePoint(50, 238)];
            }else {
                [_carAnimationView setFrameOrigin:NSMakePoint(50, 198)];
            }
            [_contentView addSubview:_carAnimationView];
        }else if (value == 2) {
            _animationType = BoatAnimation;
            [self setBoatAnimationImage:_boatAnimationView];
            if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
                [_boatAnimationView setFrameOrigin:NSMakePoint(50, 238)];
            }else if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"thanksgivingSkin"]) {
                [_boatAnimationView setFrameOrigin:NSMakePoint(50, 214)];
            }else {
                [_boatAnimationView setFrameOrigin:NSMakePoint(50, 198)];
            }
            [_contentView addSubview:_boatAnimationView];
        }else {
            _animationType = CustomAnimation;
            [self setBoatAnimationImage:_carAnimationView];
            [_customAnimationView setFrameOrigin:NSMakePoint(50, 188)];
            [_contentView addSubview:_customAnimationView];
        }
    }
}

- (void)setBoatAnimationImage:(NSView *)animationView {
    if (_animationType == CarAnimation) {
        if (_category == Category_Photo) {
            [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_iCloud_photoNew1"]];
        }else if (_category == Category_iBooks) {
            [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"toios_books"]];
        }else if (_category == Category_Message) {
            [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"toios_message"]];
        }else if (_category == Category_Calendar){
            [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"toios_calendar"]];
        }else if (_category == Category_Bookmarks) {
            [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_bookmarksnew1"]];
        }else if (_category == Category_Contacts){
            [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"toios_contact"]];
        }else if (_category == Category_CallHistory){
            [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"toios_callhistory"]];
        }else if (_category == Category_Reminder){
            [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_remindernew1"]];
        }else {
            [(CarAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photolibrarynew1"]];
        }
    }else {
        if (_category == Category_Photo) {
            [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_iCloud_photoNew1"]];
        }else if (_category == Category_System) {
            [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_systemnew1"]];
        }else if (_category == Category_Storage) {
            [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_storage1"]];
        }else if (_category == Category_iBooks) {
            [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_ibooknew1"]];
        }else if (_category == Category_Notes) {
            [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_notenew1"]];
        }else if (_category == Category_Message) {
            [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_messagenew1"]];
        }else if (_category == Category_Calendar){
            [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_calendarnew1"]];
        }else if (_category == Category_Reminder){
            [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_remindernew1"]];
        }else if (_category == Category_Bookmarks) {
            [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_bookmarksnew1"]];
        }else if (_category == Category_Contacts){
            [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_contactsnew1"]];
        }else if (_category == Category_CallHistory){
            [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_callhistory1"]];
        }else {
            [(BoatAnimationView *)animationView setCategoryImage:[StringHelper imageNamed:@"btn_photolibrarynew1"]];
        }
        
    }
}

- (void)configTitle {
    [_noteImageView setImage:[StringHelper imageNamed:@"transfer_note"]];
    [_backUpProgressLable setStringValue:@""];
    NSString *str = nil;
    str = CustomLocalizedString(@"TransferDevice_Message_Caution", nil);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init] ;
    [style setAlignment:NSLeftTextAlignment];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontNameAttribute,style,NSParagraphStyleAttributeName, nil];
    NSSize size = [str sizeWithAttributes:dic];
    [_noteImageView setFrameOrigin:NSMakePoint((1060- (22+ size.width))/2.0 , _noteImageView.frame.origin.y)];
    [_promptLabel setFrameOrigin:NSMakePoint((1060- (22+ size.width))/2.0 + 22, _promptLabel.frame.origin.y)];
    
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc] initWithString:str?:@""];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_warningColor", nil)] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSLeftTextAlignment range:NSMakeRange(0, as2.length)];
    [_promptLabel setAttributedStringValue:as2];
    [as2 release], as2 = nil;
    [style release], style = nil;
}

- (void)continueloadData{
    [_condition lock];
    if(_isPause)
    {
        _isPause = NO;
        [_condition signal];
    }
    [_condition unlock];
}

#pragma mark - NSTextDelegate
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex {
    if (_successCount < _totalCount && [IMBTransferError singleton].errorArrayM.count > 0) {
        
        if ([link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil)] ) {
            [self closeWindow:nil];
            
        } else if ([link isEqualToString:CustomLocalizedString(@"Show_ResultWindow_linkTips", nil)]) {
            //传输失败原因弹框
            NSView *view = nil;
            for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
                if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                    view = subView;
                    break;
                }
            }
            if (view) {
                [view setHidden:NO];
                [_androidAlertViewController showATtransferFailAlertViewWithSuperView:view WithFailReasonArray:[IMBTransferError singleton].errorArrayM];
            }
        }
        
    } else {
        if ([link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil)] || [link isEqualToString:CustomLocalizedString(@"Transfer_text_complete_viewfile_3", nil)]) {
            NSLog(@"%@",CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil));
            [self closeWindow:nil];
        }
    }
    
    return YES;
}

#pragma mark - 进度
//传输准备进度开始
- (void)transferPrepareFileStart:(NSString *)file {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([file isEqualToString:@"needDisClose"]) {
            [_closebutton setEnabled:NO];
            return ;
        }else if ([file isEqualToString:@"needEnClose"]){
            [_closebutton setEnabled:YES];
            return ;
        }
        NSMenu *menu = self.view.window.menu;
        NSMenuItem *item = [menu itemWithTag:205];
        [item setEnabled:NO];
        if (![TempHelper stringIsNilOrEmpty:file]) {
            [_titleStr setStringValue:file];
            [_titleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            [self reSetTransferTitleAndSubTitleFrameOrign];
        }
    });
}
//传输准备进度结束
- (void)transferPrepareFileEnd {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_animateProgressView removeAnimationImgView];
        [_animateProgressView startAnimation];
    });
}

- (void)startTransAnimation{
    [_animateProgressView setLoadAnimation];
}
//传输进度
- (void)transferProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_animateProgressView setProgress:progress];
    });
}
//当前传输文件的名字或者路径
- (void)transferFile:(NSString *)file {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:file?:@""];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.length)];
        [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
        [_backUpProgressLable setAttributedStringValue:as];
        [self reSetTransferTitleAndSubTitleFrameOrign];
        [as release], as = nil;
    });
}
//分析进度
- (void)parseProgress:(float)progress {
    
}
//当前分析文件的名字或者路径
- (void)parseFile:(NSString *)file {
    
}
//全部传输成功
- (void)transferComplete:(int)successCount TotalCount:(int)totalCount {
    _successCount = successCount;
    _totalCount = totalCount;
    [_android sendAction:@"RecoveryFinished" ResultText:_successCount TargetWord:@"Defalut"];
    if (_annoyTimer != nil) {
        [_annoyTimer invalidate];
        _annoyTimer = nil;
    }
    OperationLImitation *oeprtionlimit = [OperationLImitation singleton];
    [oeprtionlimit setNeedlimit:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_transferType == TransferToiTunes) {
            if (successCount > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_LOAD_ITUNES_DATA object:nil];
            }
        }
        _isTransferComplete = YES;
        [_closebutton setEnabled:YES];
        
        [_animateProgressView stopAnimation];
        if (_animationType == CustomAnimation) {
            [_customAnimationView stopAnimation];
        }else if (_animationType == MediaAnimation) {
            [_mediaAnimationView stopAnimation];
        }else if (_animationType == CarAnimation) {
            [_carAnimationView stopAnimation];
        }else if (_animationType == BoatAnimation) {
            [_boatAnimationView stopAnimation];
        }
        [_proContentView removeFromSuperview];
        
        
        if (![IMBSoftWareInfo singleton].isRegistered && ![IMBSoftWareInfo singleton].isNOAdvertisement) {
            if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
                
                [self configEnMoveToiOSCompleteView];
                [_contentBox setContentView:_enmoveToiOSCompleteView];
            } else {
                
                [self configMoveToiOSCompleteView];
                [_contentBox setContentView:_moveToiOSCompleteView];
            }
            
        } else {
            NSString *str3 = CustomLocalizedString(@"Transfer_text_id_4", nil);
            NSMutableAttributedString *as3 = [[NSMutableAttributedString alloc] initWithString:str3?:@""];
            if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"9"]) {
                [as3 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue thin" size:30] range:NSMakeRange(0, as3.length)];
            }else {
                [as3 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:30] range:NSMakeRange(0, as3.length)];
            }
            [as3 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as3.length)];
            [as3 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as3.length)];
            [_resultMainStr setAttributedStringValue:as3];
            [as3 release], as3 = nil;
            
            NSString *transfercountStr = nil;
            NSString *str;
            if (successCount > 1) {
                transfercountStr = [NSString stringWithFormat:@"%d/%d",successCount,totalCount];
                str = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_tips", nil),transfercountStr];
            }else {
                transfercountStr = [NSString stringWithFormat:@"%d/%d",successCount,totalCount];
                str = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_tip", nil),transfercountStr];
            }
            NSMutableAttributedString *as4 = [[NSMutableAttributedString alloc] initWithString:str?:@""];
            [as4 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as4.length)];
            [as4 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, as4.length)];
            [as4 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:NSMakeRange(0, as4.length)];
            [as4 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as4.length)];
            [[_resultSubTextView textStorage] setAttributedString:as4];
            [as4 autorelease], as4 = nil;
            
            if (_successCount < totalCount && [IMBTransferError singleton].errorArrayM.count > 0) {
                
                NSString *promptStr = @"";
                NSString *overStr1 = @"";
                NSString *overStr2 = @"";
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"Transfer_text_complete_viewfile", nil), CustomLocalizedString(@"Show_ResultWindow_linkTips", nil),CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil)];
                overStr1 = CustomLocalizedString(@"Show_ResultWindow_linkTips", nil);
                overStr2 = CustomLocalizedString(@"Transfer_text_complete_viewfile_2", nil);
                
                
                NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
                [_textView setLinkTextAttributes:linkAttributes];
                
                NSMutableAttributedString *promptAs = [[NSMutableAttributedString alloc] initWithString:promptStr?:@""];
                [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, promptAs.length)];
                [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
                
                NSRange infoRange1 = [promptStr rangeOfString:overStr1];
                [promptAs addAttribute:NSLinkAttributeName value:overStr1 range:infoRange1];
                [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange1];
                [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange1];
                [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange1];
                
                NSRange infoRange2 = [promptStr rangeOfString:overStr2];
                [promptAs addAttribute:NSLinkAttributeName value:overStr2 range:infoRange2];
                [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange2];
                [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange2];
                [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange2];
                
                
                NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
                [mutParaStyle setAlignment:NSCenterTextAlignment];
                [mutParaStyle setLineSpacing:5.0];
                [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
                [[_textView textStorage] setAttributedString:promptAs];
                [promptAs release], promptAs =nil;
                [mutParaStyle release];
                mutParaStyle = nil;
                
            } else {
                
                NSString *promptStr = @"";
                NSString *overStr1 = @"";
                promptStr = CustomLocalizedString(@"Transfer_text_complete_viewfile_3", nil);
                overStr1 = CustomLocalizedString(@"Transfer_text_complete_viewfile_3", nil);
                NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
                [_textView setLinkTextAttributes:linkAttributes];
                
                NSMutableAttributedString *promptAs = [[NSMutableAttributedString alloc] initWithString:promptStr?:@""];
                [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, promptAs.length)];
                [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
                
                NSRange infoRange1 = [promptStr rangeOfString:overStr1];
                [promptAs addAttribute:NSLinkAttributeName value:overStr1 range:infoRange1];
                [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange1];
                [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange1];
                [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange1];
                
                NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
                [mutParaStyle setAlignment:NSCenterTextAlignment];
                [mutParaStyle setLineSpacing:5.0];
                [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
                [[_textView textStorage] setAttributedString:promptAs];
                [promptAs release], promptAs =nil;
                [mutParaStyle release];
                mutParaStyle = nil;
                
            }
            [_contentView addSubview:_resultContentView];
        }
        
        EventAction action = ActionNone;
        if (_transferType == TransferToiTunes) {
            action = ToiTunes;
        }else if (_transferType == TransferImport) {
            action = Import;
        }else if (_transferType == TransferToDevice) {
            action = ToDevice;
        }else if (_transferType == TransferToiCloud) {
            action = ToiCloud;
        }
        NSString *params = [IMBCommonEnum attrackerCategoryNodesEnumToString:_category];
        if ([params isEqualToString:@"Summary"]) {
            params = @"Content";
        }
        [_baseTransfer setIsStop:NO];
        [_baseTransfer setIsPause:NO];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:_eventCategory action:action actionParams:params label:Finish transferCount:successCount screenView:[IMBCommonEnum attrackerCategoryNodesEnumToString:_category] userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
    });
}

#pragma mark - Action
- (IBAction)closeWindow:(id)sender {
    if (!_isTransferComplete) {
        [_baseTransfer setIsPause:YES];
        [_alertViewController setIsStopPan:YES];
        int result = [self showAlertText:CustomLocalizedString(@"Main_Window_Stop_Tips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) CancelButton:CustomLocalizedString(@"Button_Cancel", nil)];
        [_alertViewController setIsStopPan:NO];
        if (result) {
            OperationLImitation *oeprtionlimit = [OperationLImitation singleton];
            [oeprtionlimit setNeedlimit:YES];
            _isStop = YES;
            if (_baseTransfer != nil) {
                [_closebutton setEnabled:NO];
                [_baseTransfer setIsStop:YES];
                [_baseTransfer setIsPause:NO];//此处一定要赋值为NO，不然会影响到记录传输错误信息
                [_titleStr setStringValue:CustomLocalizedString(@"ImportSync_id_5", nil)];
            }
        }else {
            [_baseTransfer setIsPause:NO];
        }
    }else {
        [[IMBTransferError singleton] removeAllError];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
        [self animationRemoveTransferView];
    }
}

- (void)startTransfer {
    if (_animationType == CustomAnimation) {
        [_customAnimationView startAnimation];
    }else if (_animationType == MediaAnimation) {
        [_mediaAnimationView startAnimation];
    }else if (_animationType == CarAnimation) {
        [_carAnimationView startAnimation];
    }else if (_animationType == BoatAnimation) {
        [_boatAnimationView startAnimation];
    }
    
    if (_transferType == TransferToDevice) {
        if (_category == Category_Calendar) {
             dispatch_async(dispatch_get_global_queue(0, 0), ^{
                 if (_iPod.deviceInfo.isiPad) {
                     [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPad"];
                 }else if (_iPod.deviceInfo.isiPhone) {
                     [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPhone"];
                 }else {
                     [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPodTouch"];
                 }
                 [_calendarsBaseTransfer startTransfer];
             });
        }else{
            if (_category != Category_CallHistory && _category != Category_Contacts) {//message在toDevice时可能需要从安卓设备下载附件
                [self checkDeviceGreantedPermission];
            }else {
                 dispatch_async(dispatch_get_global_queue(0, 0), ^{
                     if (_iPod.deviceInfo.isiPad) {
                         [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPad"];
                     }else if (_iPod.deviceInfo.isiPhone) {
                         [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPhone"];
                     }else {
                         [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPodTouch"];
                     }
                    [_baseTransfer startTransfer];
                 });
            }
        }
    }else{
        if (_category != Category_Contacts && _category != Category_Calendar) {
            [self checkDeviceGreantedPermission];
        }else {
             dispatch_async(dispatch_get_global_queue(0, 0), ^{
                 if (_transferType == TransferToiTunes) {
                     [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iTunes"];
                 }else if (_transferType == TransferToiCloud) {
                     [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iCloud"];
                 }
                 [_baseTransfer startTransfer];
             });
        }
    }
}

- (void)animationRemoveTransferView {
    //放开语言设置按钮-----long
    NSString *str = @"open";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    [_contentView setAutoresizingMask:NSViewMinYMargin];
    [self.view setFrame:NSMakeRect(0, -20, self.view.frame.size.width, self.view.frame.size.height + 20)];
    [self.view setWantsLayer:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0 ]Y:[NSNumber numberWithInt:20] repeatCount:1];
        anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [self.view.layer addAnimation:anima1 forKey:@"deviceImageView"];
    } completionHandler:^{
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:20] Y:[NSNumber numberWithInt:-self.view.frame.size.height] repeatCount:1];
        anima1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.view.layer addAnimation:anima1 forKey:@"deviceImageView"];
    }];
    [self performSelector:@selector(removeAnimationView) withObject:nil afterDelay:0.6];
}

- (IBAction)doBack:(id)sender {
    [self.view setWantsLayer:YES];
    [self.view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-self.view.frame.size.height] repeatCount:1] forKey:@"moveY"];
    [self performSelector:@selector(removeAnimationView) withObject:nil afterDelay:0.5];
}

- (void)removeAnimationView {
    [self.view removeFromSuperview];
}

#pragma mark - Alert
- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText CancelButton:(NSString *)cancelText{
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

#pragma mark - 辅助方法
- (EventAction) categorytransferTypeToString:(TransferModeType)categoryEnum{
    switch (_transferType) {
        case TransferToDevice:
            return ToDevice;
            break;
        case TransferToiTunes:
            return ToiTunes;
            break;
        case TransferToContact:
            return ContentToMac;
            break;
        case TransferToiCloud:
            return iCloud_Import;
            break;
        default:
            return ContentToMac;
            break;
    }
}

- (void)moveBellImageView:(int)moveX {
    if (_bellImgView != nil) {
        [_bellImgView setFrameOrigin:NSMakePoint(340 + moveX, _bellImgView.frame.origin.y)];
    }
}

#pragma mark - 检查设备是否赋予权限
- (void)checkDeviceGreantedPermission {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_android != nil) {
            //判断apk是否启动,没有启动就重新启动；
            IMBAdbManager *adbManager = [IMBAdbManager singleton];
            NSString *runStr = [adbManager runADBCommand:[adbManager checkApkIsRunning:_android.deviceInfo.devSerialNumber]];
            BOOL isRet = YES;
            if ([runStr rangeOfString:@"android.imobie.com.anytransservice"].location == NSNotFound) {
                if (![_android checkIsInstallApk:_android.deviceInfo.devSerialNumber]) {
                    isRet = [_android installAPK:_android.deviceInfo.devSerialNumber];
                }
                if (isRet) {
                    [adbManager runADBCommand:[adbManager clearServiceLogcat:_android.deviceInfo.devSerialNumber]];
                    [adbManager runADBCommand:[adbManager startIntent:_android.deviceInfo.devSerialNumber]];
                    [adbManager runGrepCommand:[adbManager checkServiceIsRunning:_android.deviceInfo.devSerialNumber]];//检查apk服务是否启动成功，会阻塞等待
                    //与服务器进行3次握手操作
                    int i = 3;
                    BOOL isSuccess = NO;
                    while (i--) {
                        if ([_android.adPermisson shakehandApk]) {
                            isSuccess = YES;
                            break;
                        }
                    }
                }
            }
            if (isRet) {
                [self greantedPermission];
            }else {
                if (_transferType == TransferToDevice) {
                    if (_iPod.deviceInfo.isiPad) {
                        [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPad"];
                    }else if (_iPod.deviceInfo.isiPhone) {
                        [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPhone"];
                    }else {
                        [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPodTouch"];
                    }
                }else if (_transferType == TransferToiTunes) {
                    [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iTunes"];
                }else if (_transferType == TransferToiCloud) {
                    [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iCloud"];
                }
                [_baseTransfer startTransfer];
            }
        }
    });
}
//判断读取设备权限是否足够
- (void)greantedPermission {
    BOOL isGreanted = [_android checkDevicePermisson];
    if (!isGreanted) {
        [self performSelectorOnMainThread:@selector(setGreantedPermission) withObject:nil waitUntilDone:0];
    }else {
        if (_transferType == TransferToDevice) {
            if (_iPod.deviceInfo.isiPad) {
                [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPad"];
            }else if (_iPod.deviceInfo.isiPhone) {
                [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPhone"];
            }else {
                [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iPodTouch"];
            }
        }else if (_transferType == TransferToiTunes) {
            [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iTunes"];
        }else if (_transferType == TransferToiCloud) {
            [_android sendAction:@"RecoveryStart" ResultText:0 TargetWord:@"iCloud"];
        }
        [_baseTransfer startTransfer];
    }
}
//弹出窗口，提示用户到设备上进行权限允许
- (void)setGreantedPermission {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]) {
            view = subView;
            break;
        }
    }
    if (view) {
        [view setHidden:NO];
        BOOL versionResult = [ _android.deviceInfo.devVersion isVersionMajorEqual:@"6.0"];
        [_androidAlertViewController setAndroid:_android];
        int result = [_androidAlertViewController showImproveAuthorityAlertView:view isVersionHighThan6:versionResult];
        if (result) {
            [self performSelector:@selector(checkDeviceGreantedPermission) withObject:nil afterDelay:0.6];
        }else {
            //取消就结束传输，关闭传输窗口
            [self animationRemoveTransferView];
        }
    }
}

#pragma mark - move to iOS 完成活动界面 - 其他语言
- (void)configMoveToiOSCompleteView {
    
    if (_closebutton != nil) {
        [_closebutton release];
        _closebutton = nil;
    }
    _closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil(_atContentView.frame.origin.y + _atContentView.frame.size.height - 32), 32, 32)];
    [_closebutton setTarget:self];
    [_closebutton setAction:@selector(closeWindow:)];
    [_closebutton setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin|NSViewNotSizable];
    [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_moveToiOSCompleteView addSubview:_closebutton];
    
    //配置文字和图片
    NSString *overStr = nil;
    NSString *promptStr = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        if (_successCount > 1) {
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Titles", nil),overStr];
        } else if (_successCount == 1) {
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Title", nil),overStr];
        } else {
            promptStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_FailTitle", nil);
        }
    } else if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        
        if (_successCount > 1) {
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            if (_transferType == TransferToDevice) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Titles", nil),overStr];
            } else if (_transferType == TransferToiTunes) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_iTCompleteActivity_Titles", nil),overStr];
            } else if (_transferType == TransferToiCloud) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_iCCompleteActivity_Titles", nil),overStr];
            }
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_2", nil)];
            
        } else if (_successCount == 1){
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            if (_transferType == TransferToDevice) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Title", nil),overStr];
            } else if (_transferType == TransferToiTunes) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_iTCompleteActivity_Title", nil),overStr];
            } else if (_transferType == TransferToiCloud) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_iCCompleteActivity_Title", nil),overStr];
            }
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_1", nil)];
        } else {
            promptStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_FailTitle", nil);
        }
        
    } else {
        
        if (_successCount > 1) {
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            if (_transferType == TransferToDevice) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Titles", nil),overStr,CustomLocalizedString(@"contact_id_4", nil)];
            } else if (_transferType == TransferToiTunes) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Titles", nil),overStr,CustomLocalizedString(@"ToTransfer_Title_TOiTunes", nil)];
            } else if (_transferType == TransferToiCloud) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Titles", nil),overStr,CustomLocalizedString(@"MenuItem_id_39", nil)];
            }
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_2", nil)];
        } else if (_successCount == 1) {
            overStr = [NSString stringWithFormat:@"%d",_successCount];
            if (_transferType == TransferToDevice) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Title", nil),overStr,CustomLocalizedString(@"contact_id_4", nil)];
            } else if (_transferType == TransferToiTunes) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Title", nil),overStr,CustomLocalizedString(@"ToTransfer_Title_TOiTunes", nil)];
            } else if (_transferType == TransferToiCloud) {
                promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Title", nil),overStr,CustomLocalizedString(@"MenuItem_id_39", nil)];
            }
            overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"MSG_Item_id_1", nil)];
        } else {
            promptStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_FailTitle", nil);
        }
    }
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] withColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    if (![IMBHelper stringIsNilOrEmpty:overStr]) {
        NSRange infoRange = [promptStr rangeOfString:overStr];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] range:infoRange];
    }
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_moveToiOSCompleteTitle textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    
    [_moveToiOSCompleteSubTitle setStringValue:CustomLocalizedString(@"MoveToiOS_CompleteActivity_SubTitle", nil)];
    [_moveToiOSCompleteSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    NSMutableAttributedString *promptAs1 = [StringHelper setSingleTextAttributedString:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Description", nil) withFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0] withColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
    NSMutableParagraphStyle *mutParaStyle1 =[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle1 setAlignment:NSCenterTextAlignment];
    [mutParaStyle1 setLineSpacing:5.0];
    [promptAs1 addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle1 forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs1 string] length])];
    [[_moveToiOSCompleteDetailStr textStorage] setAttributedString:promptAs1];
    [mutParaStyle1 release], mutParaStyle1 = nil;
    
    [_moveToiOSCompleteImageView setImage:[StringHelper imageNamed:@"ad_toios_fr"]];
    
    //配置按钮
    [_moveToiOSCompleteBtn setButtonTitle:CustomLocalizedString(@"MoveToiOS_CompleteActivity_BtnTitle", nil) withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withTitleSize:14.0 WithLightAnimation:NO];
    [_moveToiOSCompleteBtn setNormalFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_normalColor", nil)] WithEnterFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_enterColor", nil)] WithDownFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_downColor", nil)]];
    [_moveToiOSCompleteBtn setBgNormalFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_bg_normalColor", nil)] WithBgEnterFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_bg_enterColor", nil)] WithBgDownFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_bg_downColor", nil)]];
    [_moveToiOSCompleteBtn setHasLeftImage:YES];
    [_moveToiOSCompleteBtn setLeftImage:[StringHelper imageNamed:@"toios_btngift_la"]];
    [_moveToiOSCompleteBtn setHasBorder:NO];
    [_moveToiOSCompleteBtn setIsMoveToiOSBtn:YES];
    [_moveToiOSCompleteBtn setTarget:self];
    [_moveToiOSCompleteBtn setAction:@selector(moveToiOSCompleteBtnClick)];
    [_moveToiOSCompleteBtn setNeedsDisplay:YES];
}

#pragma mark - move to iOS 完成活动界面 - 英语版
- (void)configEnMoveToiOSCompleteView {
    
    if (_closebutton != nil) {
        [_closebutton release];
        _closebutton = nil;
    }
    _closebutton = [[HoverButton alloc] initWithFrame:NSMakeRect(24, ceil(_enAtContentView.frame.origin.y + _enAtContentView.frame.size.height - 32), 32, 32)];
    [_closebutton setTarget:self];
    [_closebutton setAction:@selector(closeWindow:)];
    [_closebutton setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin|NSViewNotSizable];
    [_closebutton setMouseEnteredImage:[StringHelper imageNamed:@"clone_close_enter"] mouseExitImage:[StringHelper imageNamed:@"clone_close_normal"] mouseDownImage:[StringHelper imageNamed:@"clone_close_down"]];
    [_enmoveToiOSCompleteView addSubview:_closebutton];
    
    //配置文字和图片
    NSString *overStr = nil;
    NSString *promptStr = nil;
    if (_successCount > 1) {//先暂时不修改，等文字确认之后在修改
        overStr = [NSString stringWithFormat:@"%d/%d",_successCount,_totalCount];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Titles", nil),overStr];
        overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"complete_items", nil)];
    } else if (_successCount == 1) {
        overStr = [NSString stringWithFormat:@"%d/%d",_successCount,_totalCount];
        promptStr = [NSString stringWithFormat:CustomLocalizedString(@"MoveToiOS_CompleteActivity_Title", nil),overStr];
        overStr = [[overStr stringByAppendingString:@" "] stringByAppendingString:CustomLocalizedString(@"complete_item", nil)];
    } else {
        promptStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_FailTitle", nil);
    }
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    if (![IMBHelper stringIsNilOrEmpty:overStr]) {
        NSRange infoRange = [promptStr rangeOfString:overStr];
        [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
        [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:26.0] range:infoRange];
    }
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_enmoveToiOSCompleteTitle textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    
    IMBSoftWareInfo *soft = [IMBSoftWareInfo singleton];
    NSString *subTitle = CustomLocalizedString(@"MoveToiOS_CompleteActivity_SubTitle", nil);
    if (![StringHelper stringIsNilOrEmpty:soft.activityInfo.iosSubTitleWord]) {
        subTitle = soft.activityInfo.iosSubTitleWord;
    }
    [_enmoveToiOSCompleteSubTitle setStringValue:subTitle];
    [_enmoveToiOSCompleteSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"at_text_normalColor", nil)]];
    
    NSString *detailStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_Description", nil);
    if (![StringHelper stringIsNilOrEmpty:soft.activityInfo.iosDescriptionWord]) {
        detailStr = soft.activityInfo.iosDescriptionWord;
    }
    NSMutableAttributedString *promptAs1 = [StringHelper setSingleTextAttributedString:detailStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0] withColor:[StringHelper getColorFromString:CustomColor(@"at_text_explainColor", nil)]];
    NSMutableParagraphStyle *mutParaStyle1 =[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle1 setAlignment:NSCenterTextAlignment];
    [mutParaStyle1 setLineSpacing:5.0];
    [promptAs1 addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle1 forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs1 string] length])];
    [[_enmoveToiOSCompleteDetailStr textStorage] setAttributedString:promptAs1];
    [mutParaStyle1 release], mutParaStyle1 = nil;
    
    [_enmoveToiOSCompleteImageView setImage:[StringHelper imageNamed:@"ad_toios_en"]];

    //配置按钮
    NSString *btnStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_BtnTitle", nil);
    if (![StringHelper stringIsNilOrEmpty:soft.activityInfo.iosBtnWord]) {
        btnStr = soft.activityInfo.iosBtnWord;
    }
    [_enmoveToiOSCompleteBtn setButtonTitle:btnStr withNormalTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withEnterTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withDownTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withForbiddenTitleColor:[StringHelper getColorFromString:CustomColor(@"generalBtn_exitColor", nil)] withTitleSize:14.0 WithLightAnimation:NO];
    [_enmoveToiOSCompleteBtn setNormalFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_normalColor", nil)] WithEnterFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_enterColor", nil)] WithDownFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_downColor", nil)]];
    [_enmoveToiOSCompleteBtn setBgNormalFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_bg_normalColor", nil)] WithBgEnterFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_bg_enterColor", nil)] WithBgDownFillColor:[StringHelper getColorFromString:CustomColor(@"moveToiOSBtn_bg_downColor", nil)]];
    [_enmoveToiOSCompleteBtn setHasLeftImage:YES];
    [_enmoveToiOSCompleteBtn setLeftImage:[StringHelper imageNamed:@"toios_btngift_la"]];
    [_enmoveToiOSCompleteBtn setHasBorder:NO];
    [_enmoveToiOSCompleteBtn setIsMoveToiOSBtn:YES];
    [_enmoveToiOSCompleteBtn setTarget:self];
    [_enmoveToiOSCompleteBtn setAction:@selector(moveToiOSCompleteBtnClick)];
    [_enmoveToiOSCompleteBtn setNeedsDisplay:YES];
}

#pragma mark - move to iOS 完成活动界面  - 按钮点击方法
- (void)moveToiOSCompleteBtnClick {
    if (!_hostUrl) {
        NSString *hoStr = nil;
        if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage || [IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
            
            if ([IMBSoftWareInfo singleton].iosMoverDiscountUrl) {
                hoStr = [IMBSoftWareInfo singleton].iosMoverDiscountUrl;
            }else {
                NSMutableArray *hostArr = [IMBSoftWareInfo singleton].activityInfo.iosmoverArray;
                if (hostArr.count == 1) {
                    hoStr = [hostArr objectAtIndex:0];
                } else if (hostArr.count > 1) {
                    int r = arc4random() % [hostArr count];
                    NSLog(@"arc4random:%d",r);
                    hoStr = [hostArr objectAtIndex:r];
                } else {
                    int r = arc4random() % 3;
                    NSLog(@"arc4random:%d",r);
                    NSString *numberStr = [NSString stringWithFormat:@"%d",r];
                    NSString *keyStr = [@"MoveToiOS_CompleteActivity_Url" stringByAppendingString:numberStr];
                    hoStr = CustomLocalizedString(keyStr, nil);
                }
                [[IMBSoftWareInfo singleton] setIosMoverDiscountUrl:hoStr];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [[IMBSoftWareInfo singleton] saveIosMoverUrl];
                });
            }
        } else {
            hoStr = CustomLocalizedString(@"MoveToiOS_CompleteActivity_Url", nil);
        }
        _hostUrl = [[NSURL URLWithString:hoStr] retain];
    }
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:_hostUrl];
}

- (void)reSetTransferTitleAndSubTitleFrameOrign {
    //如果传输的子标题为空，将传输的主标题下移
    if ([StringHelper stringIsNilOrEmpty:_backUpProgressLable.stringValue]) {
        [_titleStr setFrameOrigin:NSMakePoint(_titleStr.frame.origin.x, _backUpProgressLable.frame.origin.y + 10)];
    }else {
        [_titleStr setFrameOrigin:NSMakePoint(_titleStr.frame.origin.x, _backUpProgressLable.frame.origin.y + 28)];
    }
}

- (void)dealloc {
    if (_hostUrl) {
        [_hostUrl release];
        _hostUrl = nil;
    }
    [_androidAlertViewController release],_androidAlertViewController = nil;
    [_condition release],_condition = nil;
    [_alertViewController release],_alertViewController = nil;
    [_closebutton release],_closebutton = nil;
    [_selectedItems release],_selectedItems = nil;
    [_selectDic release],_selectDic = nil;
    [_baseTransfer release],_baseTransfer = nil;
    [super dealloc];
}

@end
