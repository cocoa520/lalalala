  //
//  IMBAlertViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-15.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBAlertViewController.h"
#import "IMBAnimation.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
#import "IMBBackupViewController.h"
#import "IMBDeviceConnection.h"
#import "IMBDeviceViewController.h"
#import "customTextFiled.h"
#import "CapacityView.h"
#import "IMBiTunesSecureTextFieldCell.h"
#import "IMBColorDefine.h"
#import "IMBiCloudDriverViewController.h"
#import "IMBCheckBtn.h"
#import "IMBPopUpBtn.h"
#import "IMBRingtoneConfig.h"
#import "IMBAirWifiBackupViewController.h"
#import "IMBAirBackupDeviceItemView.h"
#import "SystemHelper.h"
#import "IMBSoftWareInfo.h"
#import "IMBSoftWareInfo.h"
#import "IMBiCloudViewController.h"
#import "OperationLImitation.h"

#define HEIGHT1 18
#define HEIGHT2 36

@implementation IMBAlertViewController
@synthesize isTwoICloud = _isTwoICloud;
@synthesize _removeprogressAnimationView;
@synthesize delegate = _delegate;
@synthesize reNameInputTextField = _reNameInputTextField;
@synthesize addEditBookMarkTitleInputTextFiled = _addEditBookMarkTitleInputTextFiled;
@synthesize addEditBookMarkURLInputTextFiled = _addEditBookMarkURLInputTextFiled;
@synthesize renameLoadingView = _renameLoadingView;
@synthesize reNameView = _reNameView;
@synthesize deleteAnimationView = _deleteAnimationView;
@synthesize addCustomLableInputTextFiled = _addCustomLableInputTextFiled;
@synthesize isStopPan = _isStopPan;
@synthesize isIcloudOneOpen = _isIcloudOneOpen;
@synthesize isIcloudRemove = _isIcloudRemove;
@synthesize is32 = _is32;
@synthesize is64 = _is64;
@synthesize isUnlockAccount = _isUnlockAccount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
    }
    return self;
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeOpenPanel:) name:DeviceDisConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editDoubleVerificationCode:) name:NOTIFY_EDIT_CODE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDoubleVerificationCode:) name:NOTIFY_DELETE_CODE object:nil];
    
    [_imageView1 setImage:[StringHelper imageNamed:@"alert_icon"]];
    [_imageView2 setImage:[StringHelper imageNamed:@"alert_icon"]];
    [_imageView3 setImage:[StringHelper imageNamed:@"alert_icon"]];
    [_imageView4 setImage:[StringHelper imageNamed:@"register_logo"]];
    [_imageView5 setImage:[StringHelper imageNamed:@"alert_icon"]];
    [_imageView6 setImage:[StringHelper imageNamed:@"alert_icon"]];
    [_imageView7 setImage:[StringHelper imageNamed:@"alert_icon"]];

    [((customTextFieldCell *)_activationloginStr.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [((customTextFieldCell *)_reNameInputTextField.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [((customTextFieldCell *)_addEditBookMarkTitleInputTextFiled.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [((customTextFieldCell *)_addEditBookMarkURLInputTextFiled.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [((customTextFieldCell *)_addCustomLableInputTextFiled.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [((IMBiTunesSecureTextFieldCell *)_unLockBackUpPassTitleStr.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [self setupAlertRect:_warningAlertView];
    [self setupAlertRect:_confirmAlertView];
    [self setupAlertRect:_unLockBackUpPassView];
    [self setupAlertRect:_icloudCloseView];
    [self setupAlertRect:_activationView];
    [self setupAlertRect:_removeprogressView];
    [self setupAlertRect:_airBackupSettingAlertView];
    [self setupAlertRect:_doubleVerificaView];
    [_activationBommotView setStringValue:@""];
    _confirmTextFieldInitPoint = _confirmTextField.frame.origin;
    _warningTextFieldInitPoint = _warningTextField.frame.origin;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repypass:) name:NOTIFY_ITUNES_TETY_PASS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successPass:) name:NOTIFY_ITUNES_SIGNIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(siginFail:) name:NOTIFY_ITUNES_SIGNIN_FAIL object:nil];
    [_unLockBackUpLandingstatusTitleStr setStringValue:CustomLocalizedString(@"backup_PasswordWindow_id_3", nil)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changBtnState) name:NOTIFY_TEXTFILED_INPUT_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changFindiPhoneTextFieldBtnState) name:NOTIFY_REGISTER_TEXTFILED_INPUT_CHANGE object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputCode) name:NOTIFY_TEXTFILED_INPUT_CHANGE object:nil];
}

- (void)changeSkin:(NSNotification *)notification {
    [_imageView1 setImage:[StringHelper imageNamed:@"alert_icon"]];
    [_imageView2 setImage:[StringHelper imageNamed:@"alert_icon"]];
    [_imageView3 setImage:[StringHelper imageNamed:@"alert_icon"]];
    [_imageView4 setImage:[StringHelper imageNamed:@"register_logo"]];
    [_imageView5 setImage:[StringHelper imageNamed:@"alert_icon"]];
    [_imageView6 setImage:[StringHelper imageNamed:@"alert_icon"]];
    [_imageView7 setImage:[StringHelper imageNamed:@"alert_icon"]];
    
    [((customTextFieldCell *)_activationloginStr.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [((customTextFieldCell *)_reNameInputTextField.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [((customTextFieldCell *)_addEditBookMarkTitleInputTextFiled.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [((customTextFieldCell *)_addEditBookMarkURLInputTextFiled.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [((customTextFieldCell *)_addCustomLableInputTextFiled.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [((IMBiTunesSecureTextFieldCell *)_unLockBackUpPassTitleStr.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [self setupAlertRect:_warningAlertView];
    [self setupAlertRect:_confirmAlertView];
    [self setupAlertRect:_unLockBackUpPassView];
    [self setupAlertRect:_icloudCloseView];
    [self setupAlertRect:_activationView];
    [self setupAlertRect:_removeprogressView];
    [self setupAlertRect:_iCloudOpenView];
    [_activationBommotView setStringValue:@""];
    _confirmTextFieldInitPoint = _confirmTextField.frame.origin;
    _warningTextFieldInitPoint = _warningTextField.frame.origin;

    [_unLockBackUpLandingstatusTitleStr setStringValue:CustomLocalizedString(@"backup_PasswordWindow_id_3", nil)];
    IMBSoftWareInfo *softinfo = [IMBSoftWareInfo singleton];
    if ([softinfo chooseLanguageType] == EnglishLanguage) {
        [_transImageView setImage:[StringHelper imageNamed:@"trust_english"]];
    }else if ([softinfo chooseLanguageType] == JapaneseLanguage){
        [_transImageView setImage:[StringHelper imageNamed:@"trust_japan"]];
    }else if ([softinfo chooseLanguageType] == FrenchLanguage){
        [_transImageView setImage:[StringHelper imageNamed:@"trust_French"]];
    }else if ([softinfo chooseLanguageType] == GermanLanguage){
        [_transImageView setImage:[StringHelper imageNamed:@"trust_German"]];
    }else if ([softinfo chooseLanguageType] == SpanishLanguage){
        [_transImageView setImage:[StringHelper imageNamed:@"trust_Spanish"]];
    }else if ([softinfo chooseLanguageType] == ArabLanguage){
        [_transImageView setImage:[StringHelper imageNamed:@"trust_arab"]];
    }
    [_iCloudToURLGuideBtn setNeedsDisplay:YES];
    [_iCloudToURLGuideBtn setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    
    [self loadDeviceInfoListView];
//    [_airBackupSettingAlertTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
//    [_airBackupSettingAlertSubTitle1 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
//    [_airBackupSettingAlertSubTitle2 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
//    [_airBackupSettingAlertSubTitle3 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
//    [_airBackupSettingAlertSubTitle4 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
//    [_airBackupSettingAlertSubTitle5 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
//    [_airBackupSettingAlertSubTitle6 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
//    
//    [_airBackupSettingAlertONStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
//    [_airBackupSettingAlertOFFStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
//    [_airBackupSettingAlertPathBorderView setBorderColor:[StringHelper getColorFromString:CustomColor(@"airWifi_popBtn_line_Color", nil)]];
//    [_airBackupSettingAlertPathText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    [_topLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"airWifi_popBtn_line_Color", nil)]];
    [_bottomLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"airWifi_popBtn_line_Color", nil)]];
    
    NSString *changeStr = CustomLocalizedString(@"AirBackupSettingAlert_ChangeBtn", nil);
    [_airBackupSettingAlertChangeBtn reSetInit:changeStr WithPrefixImageName:@"select_path"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:changeStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, changeStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, changeStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, changeStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    
    [_airBackupSettingAlertTurnPopBtn setTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_airBackupSettingAlertPromptStr1 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_airBackupSettingAlertPromptStr2 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    
    NSString *okBtnStr = CustomLocalizedString(@"Calendar_id_9", nil);
    [_airBackupSettingAlertSaveBtn reSetInit:okBtnStr WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles2 = [[[NSMutableAttributedString alloc]initWithString:okBtnStr]autorelease];
    [attributedTitles2 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles2.length)];
    [_airBackupSettingAlertSaveBtn setAttributedTitle:attributedTitles2];
    NSString *cancelStr = CustomLocalizedString(@"Button_Cancel", nil);
    [_airBackupSettingAlertCacelBtn reSetInit:cancelStr WithPrefixImageName:@"cancal"];
    [_airBackupSettingAlertCacelBtn setFontSize:12];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:cancelStr]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_airBackupSettingAlertCacelBtn setAttributedTitle:attributedTitles1];
    [_airBackupSettingAlertScrollView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
}

-(void)dealloc{
    if (_exportSetting != nil) {
        [_exportSetting release];
        _exportSetting = nil;
    }
    [super dealloc];
    [_iPod release], _iPod = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_TEXTFILED_INPUT_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_REGISTER_TEXTFILED_INPUT_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ITUNES_TETY_PASS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ITUNES_SIGNIN_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ITUNES_SIGNIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DeviceDisConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_EDIT_CODE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_DELETE_CODE object:nil];
}

- (void)setupAlertRect:(IMBBorderRectAndColorView *)alertView {
    [alertView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    NSRect rect = [alertView frame];
    [alertView setWantsLayer:YES];
    [alertView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - NSWidth(rect)) / 2), NSMaxY(self.view.bounds), NSWidth(rect), NSHeight(rect))];
}

- (void)loadAlertView:(NSView *)view alertView:(IMBBorderRectAndColorView *)alertView
{
    [self setupAlertRect:alertView];
    if (![self.view.subviews containsObject:alertView]) {
        [self.view addSubview:alertView];
    }
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [alertView.layer addAnimation:[IMBAnimation moveY:0.2 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-140] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [alertView.layer removeAnimationForKey:@"moveY"];
        [alertView setFrame:NSMakeRect(ceil((NSMaxX(view.bounds) - NSWidth(alertView.frame)) / 2), NSMaxY(view.bounds) - NSHeight(alertView.frame) + 10, NSWidth(alertView.frame), NSHeight(alertView.frame))];
    }];
}
//Alert高度为124
- (void)loadView:(NSView *)view alertView:(IMBBorderRectAndColorView *)alertView
{
    [self setupAlertRect:alertView];
    if (![self.view.subviews containsObject:alertView]) {
        [self.view addSubview:alertView];
    }
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [alertView.layer addAnimation:[IMBAnimation moveY:0.2 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-114] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [alertView.layer removeAnimationForKey:@"moveY"];
        [alertView setFrame:NSMakeRect(ceil((NSMaxX(view.bounds) - NSWidth(alertView.frame)) / 2), NSMaxY(view.bounds) - NSHeight(alertView.frame) + 10, NSWidth(alertView.frame), NSHeight(alertView.frame))];
    }];
}

- (void)unloadAlertView:(IMBBorderRectAndColorView *)alertView {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [alertView.layer addAnimation:[IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:150] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [alertView.layer removeAnimationForKey:@"moveY"];
        [alertView setFrame:NSMakeRect(ceil((NSMaxX(_mainView.bounds) - alertView.frame.size.width) / 2), NSMaxY(_mainView.bounds), alertView.frame.size.width, alertView.frame.size.height)];
        [self.view removeFromSuperview];
    }];
}

- (void)fastDriveExportWindow:(NSString *)titleText SuperView:(NSView *)superView {
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    
    [_removeprogressAnimationView startAnimation];
//    [_removeprogressView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - NSWidth(_removeprogressView.frame)) / 2), NSMaxY(self.view.bounds) - NSHeight(_removeprogressView.frame) + 10, NSWidth(_removeprogressView.frame), NSHeight(_removeprogressView.frame))];
    [_removeprogressViewTitle setStringValue:titleText];
    [_removeprogressViewTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [self loadAlertView:superView alertView:_removeprogressView];
//    _endRunloop = NO;
//    int result = -1;
//
//    NSSize size;
    //文本样式
//    NSMutableAttributedString *alertAttributedStr = [StringHelper measureForStringDrawing:alertText withFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0] withLineSpacing:0 withMaxWidth:294 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]  withAlignment:NSLeftTextAlignment];
//    [_warningTextField setAttributedStringValue:alertAttributedStr];
//    [_warningTextField setFrameOrigin:_warningTextFieldInitPoint];
//    if (size.height >= 34 && size.height < 48) {
//        [_warningTextField setFrameOrigin:NSMakePoint(_warningTextField.frame.origin.x, _warningTextField.frame.origin.y-16)];
//    }else if(size.height >= 48 && size.height < 68) {
//        [_warningTextField setFrameOrigin:NSMakePoint(_warningTextField.frame.origin.x, _warningTextField.frame.origin.y+4)];
//    }else if(size.height >= 68) {
//        [_warningTextField setFrameOrigin:NSMakePoint(_warningTextField.frame.origin.x, _warningTextField.frame.origin.y+16)];
//    }
    
    //按钮样式
//    if ([okButtonString isEqualToString:@""]) {
//        [_okBtn setHidden:YES];
//    }else {
//        [_okBtn setHidden:NO];
//        NSSize okBtnRectSize = [StringHelper calcuTextBounds:okButtonString fontSize:12.0].size;
//        int width = 0;
//        
//        [_okBtn reSetInit:okButtonString WithPrefixImageName:@"pop"];
//        NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okButtonString]autorelease];
//        [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okButtonString.length)];
//        [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, okButtonString.length)];
//        [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okButtonString.length)];
//        [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
//        [_okBtn setAttributedTitle:attributedTitles];
//        if (okBtnRectSize.width > 76) {
//            width = ceil(okBtnRectSize.width + 20);
//            [_okBtn setFrame:NSMakeRect(NSMaxX(_warningAlertView.bounds) - width - 25, NSMinY(_warningAlertView.bounds) + 18, width, _okBtn.frame.size.height)];
//        }else {
//            [_okBtn setFrame:NSMakeRect(NSMaxX(_warningAlertView.bounds) - _okBtn.frame.size.width - 25, NSMinY(_warningAlertView.bounds) + 18, _okBtn.frame.size.width, _okBtn.frame.size.height)];
//        }
//        
//    }
//    [_okBtn setTarget:self];
//    [_okBtn setAction:@selector(okBtnOperation:)];
    //加一个runloop
//    NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
//    NSInteger result1 = NSRunContinuesResponse;
//    
//    while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
//    {
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    }
//    [NSApp endModalSession:session];
//    result = _result;
//    return result;
}

- (void)showNoDataLoadingAlertText:(NSString *)alertText SuperView:(NSView *)superView{
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [_noDataLoadingViewLable setStringValue:alertText];
    [self loadAlertView:superView alertView:_onDataLoadingView];
//    _endRunloop = NO;
//    int result = -1;
//    //加一个runloop
//    NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
//    NSInteger result1 = NSRunContinuesResponse;
//    
//    while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
//    {
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    }
//    [NSApp endModalSession:session];
//    result = _result;
//    return result;
}

- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)okButtonString SuperView:(NSView *)superView {
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_warningAlertView];
    _endRunloop = NO;
    int result = -1;
    [_itunesTextView setHidden:YES];
    if (_isTwoICloud) {
        [_isTwoIcloudUrlLable setHidden:NO];
        [_isTwoIcloudUrlLable  WithMouseExitedfillColor:[NSColor clearColor] WithMouseUpfillColor:[NSColor clearColor] WithMouseDownfillColor:[NSColor clearColor] withMouseEnteredfillColor:[NSColor clearColor]];
        [_isTwoIcloudUrlLable WithMouseExitedLineColor:[NSColor clearColor] WithMouseUpLineColor:[NSColor clearColor] WithMouseDownLineColor:[NSColor clearColor] withMouseEnteredLineColor:[NSColor clearColor]];
        [_isTwoIcloudUrlLable WithMouseExitedtextColor:[NSColor colorWithDeviceRed:24.0/255 green:183.0/255 blue:165.0/255 alpha:1.000] WithMouseUptextColor:[NSColor colorWithDeviceRed:24.0/255 green:183.0/255 blue:165.0/255 alpha:1.000] WithMouseDowntextColor:[NSColor colorWithDeviceRed:30.0/255 green:161.0/255 blue:146.0/255 alpha:1] withMouseEnteredtextColor:[NSColor colorWithDeviceRed:26.0/255 green:198.0/255 blue:179.0/255 alpha:1.000]];
        
        [_isTwoIcloudUrlLable setTitleName:CustomLocalizedString(@"iCloud_Double_verification_guide", nil) WithDarwRoundRect:0 WithLineWidth:0 withFont:[NSFont fontWithName:@"Helvetica Neue" size:14]];
    }else if (_is64 || _is32){
        [_warningTextField setHidden:YES];
        [_isTwoIcloudUrlLable setHidden:YES];
        [_itunesTextView setHidden:NO];
        _itunesTextView.linkTextAttributes = [NSDictionary dictionaryWithObject:[NSColor colorWithDeviceRed:79.0/255 green:125.0/255 blue:196.0/255 alpha:1.000] forKey:NSForegroundColorAttributeName];
        _itunesTextView.delegate = self;
        
        NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"ituens_versiontip", nil),CustomLocalizedString(@"ituens_versiontip_download", nil)];
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange info = [str rangeOfString:CustomLocalizedString(@"ituens_versiontip_download", nil)];
        [attriStr addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14.0] range:NSMakeRange(0, attriStr.length)];
        [attriStr addAttribute:NSForegroundColorAttributeName
                         value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]
                         range:NSMakeRange(0, attriStr.length)];
        [attriStr addAttribute:NSLinkAttributeName value:CustomLocalizedString(@"ituens_versiontip_download", nil) range:info];
        NSMutableParagraphStyle *textParagraph = [[NSMutableParagraphStyle alloc] init];
        [textParagraph setAlignment:NSLeftTextAlignment];
        [textParagraph setLineBreakMode:NSLineBreakByWordWrapping];
        [attriStr addAttribute:NSParagraphStyleAttributeName value:textParagraph range:NSMakeRange(0, attriStr.length)];
        [attriStr addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:info];
        [[_itunesTextView textStorage] setAttributedString:attriStr];
        [attriStr release];
        
        

    }else{
        [_isTwoIcloudUrlLable setHidden:YES];
    }
    
    //文本样式
    NSSize size;
    NSMutableAttributedString *alertAttributedStr = [StringHelper measureForStringDrawing:alertText withFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0] withLineSpacing:0 withMaxWidth:294 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]  withAlignment:NSLeftTextAlignment];
    [_warningTextField setAttributedStringValue:alertAttributedStr];
    [_warningTextField setFrameOrigin:_warningTextFieldInitPoint];
    if (size.height >= 33 && size.height < 50) {
        [_warningTextField setFrameOrigin:NSMakePoint(_warningTextField.frame.origin.x, _warningTextField.frame.origin.y+10)];
    }else if(size.height >= 50 && size.height < 66) {
        [_warningTextField setFrameOrigin:NSMakePoint(_warningTextField.frame.origin.x, _warningTextField.frame.origin.y+19)];
    }else if(size.height >= 66) {
        [_warningTextField setFrameOrigin:NSMakePoint(_warningTextField.frame.origin.x, _warningTextField.frame.origin.y+30)];
    }
    
    //按钮样式
    if ([okButtonString isEqualToString:@""]) {
        [_okBtn setHidden:YES];
    }else {
        [_okBtn setHidden:NO];
        NSSize okBtnRectSize = [StringHelper calcuTextBounds:okButtonString fontSize:12.0].size;
        int width = 0;
        
        [_okBtn reSetInit:okButtonString WithPrefixImageName:@"pop"];
        NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okButtonString]autorelease];
        [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okButtonString.length)];
        [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, okButtonString.length)];
        [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okButtonString.length)];
        [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
        [_okBtn setAttributedTitle:attributedTitles];
        if (okBtnRectSize.width > 76) {
            width = ceil(okBtnRectSize.width + 20);
            [_okBtn setFrame:NSMakeRect(NSMaxX(_warningAlertView.bounds) - width - 25, NSMinY(_warningAlertView.bounds) + 18, width, _okBtn.frame.size.height)];
        }else {
            [_okBtn setFrame:NSMakeRect(NSMaxX(_warningAlertView.bounds) - _okBtn.frame.size.width - 25, NSMinY(_warningAlertView.bounds) + 18, _okBtn.frame.size.width, _okBtn.frame.size.height)];
        }
        
    }
    [_okBtn setTarget:self];
    [_okBtn setAction:@selector(okBtnOperation:)];
    //加一个runloop
//    NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
//    NSInteger result1 = NSRunContinuesResponse;
//    
//    while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
//    {
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    }
//    [NSApp endModalSession:session];
//    result = _result;
    return result;
}
- (IBAction)twoIcloudDown:(id)sender {
    if (_is32) {
        NSURL *url = nil;
        url = [NSURL URLWithString:@"http://dl.imobie.com/anytrans-mac.dmg"];
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        [ws openURL:url];
    }else if(_is64){
        NSURL *url = nil;
        url = [NSURL URLWithString:@"http://dl.imobie.com/anytrans-64-mac.dmg"];
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        [ws openURL:url];
    }else{
        NSURL *url = nil;
        url = [NSURL URLWithString:CustomLocalizedString(@"icloud_guide", nil)];
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        [ws openURL:url];
    }
    
}

#pragma mark - NSTextViewDelegate
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex{
    if([link isEqualToString:CustomLocalizedString(@"ituens_versiontip_download", nil)]){
        NSURL *url = nil;
        url = [NSURL URLWithString:@"http://dl.imobie.com/anytrans-64-mac.dmg"];
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        [ws openURL:url];
    } else if ([textView isEqualTo:_AirBackupGuideAlertClickTextView] && [link isEqualToString:CustomLocalizedString(@"AirbackPublicWifi_Guide", nil)]) {
        
    }else if ([textView isEqualTo:_airBackupPublicWiFiAlertClickText] && [link isEqualToString:CustomLocalizedString(@"AirbackPublicWifi_Guide", nil)]) {
        NSURL *url = nil;
        url = [NSURL URLWithString:CustomLocalizedString(@"AirWiFiBackup_samewifi_Url", nil)];
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        [ws openURL:url];
    }else if ([textView isEqualTo:_airBackupHotWiFiAlertClickText] && [link isEqualToString:CustomLocalizedString(@"AirbackPublicWifi_Guide", nil)]) {
        NSURL *url = nil;
        url = [NSURL URLWithString:CustomLocalizedString(@"AirWiFiBackup_hotspot_Url", nil)];
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        [ws openURL:url];
    }else if ([link isEqualToString:CustomLocalizedString(@"iCloudLogin_View_NotReceiveCode", nil)]) {
        [self showSendCodeMessageHelpView];
    }else if ([link isEqualToString:CustomLocalizedString(@"iCloudLogin_View_Resend", nil)]) {
        //点击重新发送验证码
        [_doubleVerificaSubTitle setHidden:NO];
        int statusCode = [_delegate reSendTwoStepAuthenticationCode];
        if (statusCode == 202) {
            [_doubleVerificaSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            [_doubleVerificaSubTitle setStringValue:CustomLocalizedString(@"iCloudLogin_View_SendCode_Success", nil)];
        }else {
            [_doubleVerificaSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)]];
            [_doubleVerificaSubTitle setStringValue:CustomLocalizedString(@"iCloudLogin_View_SendCode_Fail", nil)];
        }
    }else if ([link isEqualToString:CustomLocalizedString(@"iCloudLogin_View_SendByMessage", nil)]) {
        //点击重新发送短信
        [_doubleVerificaSubTitle setHidden:NO];
        int statusCode = [_delegate reSendTwoStepAuthenticationMessage];
        if (statusCode == 200) {
            [_doubleVerificaSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
            [_doubleVerificaSubTitle setStringValue:CustomLocalizedString(@"iCloudLogin_View_SendCode_Success", nil)];
        }else if (statusCode == 423) {
            [_doubleVerificaSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)]];
            [_doubleVerificaSubTitle setStringValue:CustomLocalizedString(@"iCloudLogin_View_Input_NewCode", nil)];
        }else {
            [_doubleVerificaSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)]];
            [_doubleVerificaSubTitle setStringValue:CustomLocalizedString(@"iCloudLogin_View_SendCode_Fail", nil)];
        }
    }else if ([link isEqualToString:CustomLocalizedString(@"iCloudLogin_View_Help", nil)]) {
        NSURL *url = [NSURL URLWithString:CustomLocalizedString(@"iCloudGetDoubleVerificationCodeHelp", nil)];
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        [ws openURL:url];
    }
    return YES;
}

//icloud骚扰
- (void)showiCloudAnnoyAlertTitleText:(NSString *)titleText withSubStr:(NSString *)subText withImageName:(NSString *)imageName buyButtonText:(NSString *)OkText CancelButton:(NSString *)cancelText SuperView:(NSView *)superView {
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    
    
    _iCloudAnnoyBuyBtn.isleftright = NO;
//    [_iCloudAnnoyBuyBtn setBorderColor:[StringHelper getColorFromString:CustomColor(@"general_border_color", nil)]];
    [_iCloudAnnoyBuyBtn setLeftnormalFillColor:[StringHelper getColorFromString:CustomColor(@"download_org_normal_leftColor", nil)]];
    [_iCloudAnnoyBuyBtn setLeftenterFillColor:[StringHelper getColorFromString:CustomColor(@"download_org_enter_leftColor", nil)]];
    [_iCloudAnnoyBuyBtn setLeftdownFillColor:[StringHelper getColorFromString:CustomColor(@"download_org_down_leftColor", nil)]];
    [_iCloudAnnoyBuyBtn setRightnormalFillColor:[StringHelper getColorFromString:CustomColor(@"download_org_normal_rightColor", nil)]];
    [_iCloudAnnoyBuyBtn setRightenterFillColor:[StringHelper getColorFromString:CustomColor(@"download_org_enter_rightColor", nil)]];
    [_iCloudAnnoyBuyBtn setRightdownFillColor:[StringHelper getColorFromString:CustomColor(@"download_org_down_rightColor", nil)]];
    _iCloudAnnoyBuyBtn.fontEnterColor = [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)];
    _iCloudAnnoyBuyBtn.fontDownColor = [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)];
    _iCloudAnnoyBuyBtn.fontColor = [StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)];
    _iCloudAnnoyBuyBtn.font = [NSFont fontWithName:@"Helvetica Neue" size:14.0];
    [_iCloudAnnoyBuyBtn setTitle:OkText];
    [_iCloudAnnoyBuyBtn setTarget:self];


    _iCloudAnnoyCancelBtn.isleftright = NO;
    [_iCloudAnnoyCancelBtn setBorderColor:[StringHelper getColorFromString:CustomColor(@"general_border_color", nil)]];
    [_iCloudAnnoyCancelBtn setLeftnormalFillColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_iCloudAnnoyCancelBtn setLeftenterFillColor:[StringHelper getColorFromString:CustomColor(@"general_enter_upFillColor", nil)]];
    [_iCloudAnnoyCancelBtn setLeftdownFillColor:[StringHelper getColorFromString:CustomColor(@"general_down_upFillColor", nil)]];
    [_iCloudAnnoyCancelBtn setRightnormalFillColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_iCloudAnnoyCancelBtn setRightenterFillColor:[StringHelper getColorFromString:CustomColor(@"general_enter_downFillColor", nil)]];
    [_iCloudAnnoyCancelBtn setRightdownFillColor:[StringHelper getColorFromString:CustomColor(@"general_down_downFillColor", nil)]];
    _iCloudAnnoyCancelBtn.fontEnterColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    _iCloudAnnoyCancelBtn.fontDownColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    _iCloudAnnoyCancelBtn.fontColor = [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)];
    _iCloudAnnoyCancelBtn.font = [NSFont fontWithName:@"Helvetica Neue" size:14.0];
    [_iCloudAnnoyCancelBtn setTitle:cancelText];
    [_iCloudAnnoyCancelBtn setTarget:self];
    [_iCloudAnnoyCancelBtn setAction:@selector(annoyCancelBtnDown:)];
    
    
    
    [_icloudAnnoyTextStr setStringValue:CustomLocalizedString(@"iclouddriver_annoyView_tipStr", nil)];
    [_icloudAnnoyTextStr setTextColor:IMBNODATA_LINKE_COLOR];
    
    [_iCloudAnnoyView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    NSRect rect = [_iCloudAnnoyView frame];
    [_iCloudAnnoyView setWantsLayer:YES];
    [_iCloudAnnoyView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - NSWidth(rect)) / 2), NSMaxY(self.view.bounds), NSWidth(rect), NSHeight(rect))];
    
    [_iCloudAnnoyImageView setImage:[NSImage imageNamed:imageName]];
    [_iCloudAnnoyTitleStr setStringValue:titleText];
    [_iCloudAnnoySubStr setStringValue:subText];
    [_iCloudAnnoySubStr setTextColor:COLOR_TEXT_EXPLAIN];
    
    if (![self.view.subviews containsObject:_iCloudAnnoyView]) {
        [self.view addSubview:_iCloudAnnoyView];
    }

    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_iCloudAnnoyView.layer addAnimation:[IMBAnimation moveY:0.2 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-310] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [_iCloudAnnoyView.layer removeAnimationForKey:@"moveY"];
        [_iCloudAnnoyView setFrame:NSMakeRect(ceil((NSMaxX(superView.bounds) - NSWidth(_iCloudAnnoyView.frame)) / 2), NSMaxY(superView.bounds) - NSHeight(_iCloudAnnoyView.frame) + 10, NSWidth(_iCloudAnnoyView.frame), NSHeight(_iCloudAnnoyView.frame))];
    }];
    NSSize cancelBtnRectSize = [StringHelper calcuTextBounds:cancelText fontSize:12.0].size;
    NSSize buyBtnRectSize = [StringHelper calcuTextBounds:OkText fontSize:12.0].size;
    int width = 0;
    if (cancelBtnRectSize.width > buyBtnRectSize.width) {
        width = cancelBtnRectSize.width +20;
    }else{
        width = buyBtnRectSize.width +20;
    }
    if (width < 80){
        width = 80;
    }
    [_iCloudAnnoyCancelBtn setFrame:NSMakeRect(ceil( _iCloudAnnoyView.frame.size.width/2 +10), ceil(_iCloudAnnoyCancelBtn.frame.origin.y), ceil(width), ceil(_iCloudAnnoyCancelBtn.frame.size.height))];
    [_iCloudAnnoyBuyBtn setFrame:NSMakeRect(_iCloudAnnoyView.frame.size.width/2 - width - 10, _iCloudAnnoyBuyBtn.frame.origin.y, width, _iCloudAnnoyBuyBtn.frame.size.height)];
}

- (IBAction)annoyBuyBtn:(id)sender {
    IMBSoftWareInfo *softWare = [IMBSoftWareInfo singleton];
    NSURL *url = nil;
    NSString *str = CustomLocalizedString(@"Buy_Url", nil);
    NSString *ver = softWare.version;
    if (softWare.isIronsrc) {
        if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
            ver = @"ironsrc3";
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage){
            ver = @"ironsrc1";
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == FrenchLanguage) {
            ver = @"ironsrc2";
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage){
            ver = @"ironsrc";
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == SpanishLanguage){
            ver = @"ironsrc4";
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage){
            ver = @"ironsrc5";
        }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
            ver = @"ironsrc6";
        }else {
            ver = @"ironsrc";
        }
    }
    url = [NSURL URLWithString:[NSString stringWithFormat:str, ver, softWare.buyId]];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (IBAction)annoyCancelBtnDown:(id)sender {
    [_delegate continueloadData];
    _isIcloudOneOpen = YES;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_iCloudAnnoyView.layer addAnimation:[IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:310] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [_iCloudAnnoyView.layer removeAnimationForKey:@"moveY"];
        [_iCloudAnnoyView setFrame:NSMakeRect(ceil((NSMaxX(_mainView.bounds) - _iCloudAnnoyView.frame.size.width) / 2), NSMaxY(_mainView.bounds), _iCloudAnnoyView.frame.size.width, _iCloudAnnoyView.frame.size.height)];
        [self.view removeFromSuperview];
    }];
}

- (int)showAlertText:(NSString *)alertText OKButton:(NSString *)OkText CancelButton:(NSString *)cancelText SuperView:(NSView *)superView {
    
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_confirmAlertView];
    _endRunloop = NO;
    int result = -1;
    [_cancelBtn reSetInit:cancelText WithPrefixImageName:@"cancal"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelText]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_cancelBtn setAttributedTitle:attributedTitles];
    [_cancelBtn setIsReslutVeiw:YES];
    [_removeBtn reSetInit:OkText WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:OkText]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_removeBtn setAttributedTitle:attributedTitles1];
    
    [_removeBtn setTarget:self];
    [_removeBtn setAction:@selector(removeBtnOperation:)];
    [_cancelBtn setTarget:self];
    [_cancelBtn setAction:@selector(cancelBtnOperation:)];
    NSSize cancelBtnRectSize = [StringHelper calcuTextBounds:cancelText fontSize:12.0].size;
    NSSize removeBtnRectSize = [StringHelper calcuTextBounds:OkText fontSize:12.0].size;
    int width = 0;
    if (cancelBtnRectSize.width > 76 || removeBtnRectSize.width > 76) {
        if (cancelBtnRectSize.width > removeBtnRectSize.width) {
            width = ceil(cancelBtnRectSize.width + 30);
        }else {
            width = ceil(removeBtnRectSize.width + 30);
        }
        [_removeBtn setFrame:NSMakeRect(NSMaxX(_confirmAlertView.bounds) - width - 25, NSMinY(_confirmAlertView.bounds) + 18, width, _removeBtn.frame.size.height)];
        [_cancelBtn setFrame:NSMakeRect(ceil(NSMaxX(_confirmAlertView.bounds) - width*2 - 25 - 15), ceil(NSMinY(_confirmAlertView.bounds) + 18), ceil(width), ceil(_cancelBtn.frame.size.height))];
    }else {
        [_removeBtn setFrame:NSMakeRect(NSMaxX(_confirmAlertView.bounds) - _removeBtn.frame.size.width - 25, NSMinY(_confirmAlertView.bounds) + 18, _removeBtn.frame.size.width, _removeBtn.frame.size.height)];
        [_cancelBtn setFrame:NSMakeRect(ceil(NSMaxX(_confirmAlertView.bounds) - _removeBtn.frame.size.width - _cancelBtn.frame.size.width - 25 - 15),ceil( NSMinY(_confirmAlertView.bounds) + 18), ceil(_cancelBtn.frame.size.width), _cancelBtn.frame.size.height)];
    }
    //文字样式
    NSSize size;
    NSMutableAttributedString *alertAttributedStr = [StringHelper measureForStringDrawing:alertText withFont:[NSFont fontWithName:@"Helvetica Neue" size:14] withLineSpacing:0 withMaxWidth:294 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withAlignment:NSLeftTextAlignment];
    [_confirmTextField setAttributedStringValue:alertAttributedStr];
    [_confirmTextField setFrameOrigin:_confirmTextFieldInitPoint];
    if (size.height >= 33 && size.height < 50) {
        [_confirmTextField setFrameOrigin:NSMakePoint(_confirmTextField.frame.origin.x, _confirmTextField.frame.origin.y+8)];
    }else if(size.height >= 50 && size.height < 66) {
        [_confirmTextField setFrameOrigin:NSMakePoint(_confirmTextField.frame.origin.x, _confirmTextField.frame.origin.y+18)];
    }else if(size.height >= 66) {
        [_confirmTextField setFrameOrigin:NSMakePoint(_confirmTextField.frame.origin.x, _confirmTextField.frame.origin.y+28)];
    }
    //加一个runloop
    NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
    NSInteger result1 = NSRunContinuesResponse;
    while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [NSApp endModalSession:session];
    result = _result;
    return result;
}

//两个按钮和一个输入框的下拉窗口
- (int)showTitleName:(NSString *)string InputTextFiledString:(NSString *)inputString OkButton:(NSString *)OkText CancelButton:(NSString *)cancelText SuperView:(NSView *)superView {
    _mainView = superView;
    [_reNameOkBtn setEnabled:YES];
    [_reNameCancelBtn setEnabled:YES];
    [_renameLoadingView setHidden:YES];
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadView:superView alertView:_reNameView];
    _endRunloop = NO;
    int result = -1;
    [_reNameCancelBtn reSetInit:cancelText WithPrefixImageName:@"cancal"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelText]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_reNameCancelBtn setAttributedTitle:attributedTitles];

    [_reNameCancelBtn setIsReslutVeiw:YES];
    [_reNameOkBtn reSetInit:OkText WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:OkText]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_reNameOkBtn setAttributedTitle:attributedTitles1];

    if (inputString.length == 0 ) {
        [_reNameOkBtn setEnabled:NO];
    }else {
        [_reNameOkBtn setEnabled:YES];
    }

    [_reNameOkBtn setTarget:self];
    [_reNameOkBtn setAction:@selector(OkBtnClick:)];
    [_reNameOkBtn setTag:1];
    [_reNameCancelBtn setTarget:self];
    [_reNameCancelBtn setAction:@selector(cancelBtnClick:)];
    [_reNameCancelBtn setTag:1];
    NSSize cancelBtnRectSize = [StringHelper calcuTextBounds:cancelText fontSize:14.0].size;
    NSSize removeBtnRectSize = [StringHelper calcuTextBounds:OkText fontSize:14.0].size;
    int width = 0;
    if (cancelBtnRectSize.width > 76 || removeBtnRectSize.width > 76) {
        if (cancelBtnRectSize.width > removeBtnRectSize.width) {
            width = ceil(cancelBtnRectSize.width + 20);
        }else {
            width = ceil(removeBtnRectSize.width + 20);
        }
        [_reNameOkBtn setFrame:NSMakeRect(NSMaxX(_reNameView.bounds) - width - 25, 25, width, _reNameOkBtn.frame.size.height)];
        [_reNameCancelBtn setFrame:NSMakeRect(ceil(NSMaxX(_reNameView.bounds) - width*2 - 25 - 15),  25, width, _reNameCancelBtn.frame.size.height)];
    }else {
        [_reNameOkBtn setFrame:NSMakeRect(NSMaxX(_reNameView.bounds) - _reNameOkBtn.frame.size.width - 25,  25, _reNameOkBtn.frame.size.width, _reNameOkBtn.frame.size.height)];
        [_reNameCancelBtn setFrame:NSMakeRect(NSMaxX(_reNameView.bounds) - _reNameOkBtn.frame.size.width - _reNameCancelBtn.frame.size.width - 25 - 15,  25, _reNameCancelBtn.frame.size.width, _reNameCancelBtn.frame.size.height)];
    }
    [_reNameInputView setIsRegistedTextView:YES];
    [_reNameInputView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_reNameInputView setIsNOCanDraw:YES];
    [_reNameTitle setStringValue:string];
    [_reNameTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_reNameInputTextField setStringValue:inputString];
    [_reNameInputTextField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setAlignment:NSLeftTextAlignment];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:14.0],NSFontAttributeName,style,NSParagraphStyleAttributeName, nil];
    NSSize size = [string sizeWithAttributes:dic];
    [_reNameTitle setFrameSize:NSMakeSize(size.width+2, size.height)];
    [_reNameInputView setFrame:NSMakeRect(_reNameTitle.frame.origin.x+size.width+8, _reNameInputView.frame.origin.y, ceil(370-40-size.width-12) , ceil(_reNameInputView.frame.size.height))];
    [style release], style = nil;
    //加一个runloop
    NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
    NSInteger result1 = NSRunContinuesResponse;
    while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [NSApp endModalSession:session];
    result = _result;
    return result;
}

//两个按钮和两个输入框的下拉窗口
- (int)showfirstName:(NSString *)firstString SecondName:(NSString *)secondString FirstInputString:(NSString *)firstInputString SecondInputString:(NSString *)String OkButton:(NSString *)OkText CancelButton:(NSString *)cancelText SuperView:(NSView *)superView {
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_addEditBookMarkView];
    _endRunloop = NO;
    int result = -1;
    [_addEditBookMarkCancelBtn reSetInit:cancelText WithPrefixImageName:@"cancal"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelText]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_addEditBookMarkCancelBtn setAttributedTitle:attributedTitles];
    [_addEditBookMarkCancelBtn setIsReslutVeiw:YES];
    [_addEditBookMarkOkBtn reSetInit:OkText WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:OkText]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_addEditBookMarkOkBtn setAttributedTitle:attributedTitles1];
    
    if (firstInputString.length == 0 || String.length == 0) {
        [_addEditBookMarkOkBtn setEnabled:NO];
    }else {
        [_addEditBookMarkOkBtn setEnabled:YES];
    }
    
    [_addEditBookMarkOkBtn setTarget:self];
    [_addEditBookMarkOkBtn setAction:@selector(OkBtnClick:)];
    [_addEditBookMarkOkBtn setTag:2];
    [_addEditBookMarkCancelBtn setTarget:self];
    [_addEditBookMarkCancelBtn setAction:@selector(cancelBtnClick:)];
    [_addEditBookMarkCancelBtn setTag:2];
    NSSize cancelBtnRectSize = [StringHelper calcuTextBounds:cancelText fontSize:14.0].size;
    NSSize removeBtnRectSize = [StringHelper calcuTextBounds:OkText fontSize:14.0].size;
    int width = 0;
    if (cancelBtnRectSize.width > 76 || removeBtnRectSize.width > 76) {
        if (cancelBtnRectSize.width > removeBtnRectSize.width) {
            width = ceil(cancelBtnRectSize.width + 20);
        }else {
            width = ceil(removeBtnRectSize.width + 20);
        }
        [_addEditBookMarkOkBtn setFrame:NSMakeRect(NSMaxX(_addEditBookMarkView.bounds) - width - 25, 25, width, _addEditBookMarkOkBtn.frame.size.height)];
        [_addEditBookMarkCancelBtn setFrame:NSMakeRect(NSMaxX(_addEditBookMarkView.bounds) - width*2 - 25 - 15,25, width, _addEditBookMarkView.frame.size.height)];
    }else {
        [_addEditBookMarkOkBtn setFrame:NSMakeRect(NSMaxX(_addEditBookMarkView.bounds) - _addEditBookMarkOkBtn.frame.size.width - 25,25, _addEditBookMarkOkBtn.frame.size.width, _addEditBookMarkOkBtn.frame.size.height)];
        [_addEditBookMarkCancelBtn setFrame:NSMakeRect(NSMaxX(_addEditBookMarkView.bounds) - _addEditBookMarkOkBtn.frame.size.width - _addEditBookMarkCancelBtn.frame.size.width - 25 - 15, 25, _addEditBookMarkCancelBtn.frame.size.width, _addEditBookMarkCancelBtn.frame.size.height)];
    }
    
    [_addEditBookMarkTitle setStringValue:firstString];
    [_addEditBookMarkTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_addEditBookMarkURL setStringValue:secondString];
    [_addEditBookMarkURL setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_addEditBookMarkTitleInputTextFiled setStringValue:firstInputString];
    [_addEditBookMarkTitleInputTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_addEditBookMarkURLInputTextFiled setStringValue:String];
    [_addEditBookMarkURLInputTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_addEditBookMarkInputTiltleView setIsNOCanDraw:YES];
    [_addEditBookMarkInputTiltleView setIsRegistedTextView:YES];
    [_addEditBookMarkInputTiltleView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_addEditBookMarkInputURLView setIsNOCanDraw:YES];
    [_addEditBookMarkInputURLView setIsRegistedTextView:YES];
    [_addEditBookMarkInputURLView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setAlignment:NSLeftTextAlignment];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:14.0],NSFontAttributeName,style,NSParagraphStyleAttributeName, nil];
    NSSize size = [firstString sizeWithAttributes:dic];
    [_addEditBookMarkTitle setFrameSize:NSMakeSize(size.width+2, size.height)];
    [_addEditBookMarkInputTiltleView setFrame:NSMakeRect(ceil(_addEditBookMarkTitle.frame.origin.x+size.width+8),ceil( _addEditBookMarkInputTiltleView.frame.origin.y), ceil(370-40-size.width-12) ,ceil(_addEditBookMarkInputTiltleView.frame.size.height) )];
    
    NSSize size2 = [secondString sizeWithAttributes:dic];
    [_addEditBookMarkURL setFrameSize:NSMakeSize(size2.width+2, size2.height)];
    [_addEditBookMarkInputURLView setFrame:NSMakeRect( ceil(_addEditBookMarkURL.frame.origin.x+size.width+8), ceil(_addEditBookMarkInputURLView.frame.origin.y),ceil( 370-40-size.width-12), ceil(_addEditBookMarkInputURLView.frame.size.height))];
    [style release], style = nil;

    //加一个runloop
    NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
    NSInteger result1 = NSRunContinuesResponse;
    while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [NSApp endModalSession:session];
    result = _result;
    return result;
}
//删除确认窗口
- (int)showDeleteConfrimText:(NSString *)alertText OKButton:(NSString *)OkText CancelButton:(NSString *)cancelText SuperView:(NSView *)superView {
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_comfirmDeleteView];
    _endRunloop = NO;
    int result = -1;
    [_comfirmDeleteCancelBtn reSetInit:cancelText WithPrefixImageName:@"cancal"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelText]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]range:NSMakeRange(0, cancelText.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];

    [_comfirmDeleteCancelBtn setAttributedTitle:attributedTitles];
    [_comfirmDeleteCancelBtn setIsReslutVeiw:YES];
    [_comfirmDeleteOkBtn reSetInit:OkText WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:OkText]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_comfirmDeleteOkBtn setAttributedTitle:attributedTitles1];
    
    [_comfirmDeleteOkBtn setTarget:self];
    [_comfirmDeleteOkBtn setAction:@selector(confirmDeleteOkBtn:)];
    [_comfirmDeleteCancelBtn setTarget:self];
    [_comfirmDeleteCancelBtn setAction:@selector(confirmDeletecancelBtn:)];
    NSSize cancelBtnRectSize = [StringHelper calcuTextBounds:cancelText fontSize:12.0].size;
    NSSize removeBtnRectSize = [StringHelper calcuTextBounds:OkText fontSize:12.0].size;
    int width = 0;
    if (cancelBtnRectSize.width > 76 || removeBtnRectSize.width > 76) {
        if (cancelBtnRectSize.width > removeBtnRectSize.width) {
            width = ceil(cancelBtnRectSize.width + 20);
        }else {
            width = ceil(removeBtnRectSize.width + 20);
        }
        [_comfirmDeleteOkBtn setFrame:NSMakeRect(NSMaxX(_comfirmDeleteView.bounds) - width - 25, NSMinY(_comfirmDeleteView.bounds) + 18, width, _comfirmDeleteOkBtn.frame.size.height)];
        [_comfirmDeleteCancelBtn setFrame:NSMakeRect(NSMaxX(_comfirmDeleteView.bounds) - width*2 - 25 - 15, NSMinY(_comfirmDeleteView.bounds) + 18, width, _comfirmDeleteCancelBtn.frame.size.height)];
    }else {
        [_comfirmDeleteOkBtn setFrame:NSMakeRect(NSMaxX(_comfirmDeleteView.bounds) - _removeBtn.frame.size.width - 25, NSMinY(_comfirmDeleteView.bounds) + 18, _comfirmDeleteOkBtn.frame.size.width, _comfirmDeleteOkBtn.frame.size.height)];
        [_comfirmDeleteCancelBtn setFrame:NSMakeRect(NSMaxX(_comfirmDeleteView.bounds) - _comfirmDeleteOkBtn.frame.size.width - _comfirmDeleteCancelBtn.frame.size.width - 25 - 15, NSMinY(_comfirmDeleteView.bounds) + 18, _comfirmDeleteCancelBtn.frame.size.width, _comfirmDeleteCancelBtn.frame.size.height)];
    }
    
    //文字样式
    NSSize size;
    NSMutableAttributedString *alertAttributedStr = [StringHelper measureForStringDrawing:alertText withFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0] withLineSpacing:0 withMaxWidth:294 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] withAlignment:NSLeftTextAlignment];
    [_comfirmDeleteTitle setAttributedStringValue:alertAttributedStr];
    if (size.height >= 34 && size.height < 51) {
        [_comfirmDeleteTitle setFrameOrigin:NSMakePoint(_comfirmDeleteTitle.frame.origin.x, 23+8)];
    }else if(size.height >= 51 && size.height < 68) {
        [_comfirmDeleteTitle setFrameOrigin:NSMakePoint(_comfirmDeleteTitle.frame.origin.x, 23+18)];
    }else if(size.height >= 68) {
        [_comfirmDeleteTitle setFrameOrigin:NSMakePoint(_comfirmDeleteTitle.frame.origin.x, 23+28)];
    }
    
    NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
    NSInteger result1 = NSRunContinuesResponse;
    while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [NSApp endModalSession:session];
    result = _result;
    return result;
}

- (void)showDeleteAnimationViewAlertText:(NSString *)alertText SuperView:(NSView *)superView {
    _mainView = superView;

    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_deleteAnimationView];
    [_deleteAnimationCapacityBar initWithFrame:_deleteAnimationCapacityBar.frame WithFillColor:[StringHelper getColorFromString:CustomColor(@"progress_animation_Color", nil)] withPercent:1.0];
    [_deleteAnimationTitle setStringValue:alertText];
    [_deleteAnimationTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_deleteAnimationTitle setNeedsDisplay:YES];
    [_deleteAnimationCapacityBar setWantsLayer:YES];
    if (_animationlayer == nil) {
        _animationlayer = [CALayer layer];
        _animationlayer.name = @"lar";
        NSImage *image = [StringHelper imageNamed:@"transfer_light"];
        _animationlayer.contents = image;
        _animationlayer.frame = CGRectMake(0, 0, 60, 24);
        [_deleteAnimationCapacityBar.layer addSublayer:_animationlayer];
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"position"];
        animation1.duration = 2; // 持续时间
        animation1.repeatCount = NSIntegerMax; // 重复次数
        animation1.autoreverses = NO;
        animation1.fromValue = [NSValue valueWithPoint:NSMakePoint(-10, 0)]; // 起始帧
        animation1.toValue = [NSValue valueWithPoint:NSMakePoint(_deleteAnimationCapacityBar.bounds.size.width + 20,0)];
        animation1.removedOnCompletion = NO;
        animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation1.fillMode = kCAFillModeForwards;
        [_animationlayer addAnimation:animation1 forKey:@""];
    }
}

- (void)showRemoveProgressViewAlertText:(NSString *)alertText SuperView:(NSView *)superView
{
    [_confirmAlertView removeFromSuperview];
    [_removeprogressAnimationView startAnimation];
    [_removeprogressView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - NSWidth(_removeprogressView.frame)) / 2), NSMaxY(self.view.bounds) - NSHeight(_removeprogressView.frame) + 10, NSWidth(_removeprogressView.frame), NSHeight(_removeprogressView.frame))];
    [_removeprogressViewTitle setStringValue:alertText];
    [_removeprogressViewTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [self.view addSubview:_removeprogressView];
    
}

-(void)showChangeRemoveProgressViewTitle:(NSString *)str{
    [_removeprogressViewTitle setStringValue:str];
}

- (void)showRemoveSuccessViewAlertText:(NSString *)alertText withCount:(int)successCount
{
    [_removeprogressAnimationView pauseTimer];
    [_removeprogressView removeFromSuperview];
    [_removeprogressSuccessView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_removeprogressSuccessView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - NSWidth(_removeprogressView.frame)) / 2), NSMaxY(self.view.bounds) - NSHeight(_removeprogressSuccessView.frame) + 10, NSWidth(_removeprogressSuccessView.frame), NSHeight(_removeprogressSuccessView.frame))];
    [self.view addSubview:_removeprogressSuccessView];
    [self removeItemSuccessShowCountText:successCount];
    [_removeprogressSuccessViewTitle setStringValue:CustomLocalizedString(@"MSG_COM_Delete_Complete", nil)];
    [_removeprogressSuccessViewTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self unloadAlertView:_removeprogressSuccessView];
    });
}

- (void)showFastDriveSuccessViewAlertText:(NSString *)alertText withSuccessCountStr:(NSString *)successStr
{
    [_removeprogressAnimationView pauseTimer];
    [_removeprogressView removeFromSuperview];
    [_removeprogressSuccessView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_removeprogressSuccessView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - NSWidth(_removeprogressView.frame)) / 2), NSMaxY(self.view.bounds) - NSHeight(_removeprogressSuccessView.frame) + 10, NSWidth(_removeprogressSuccessView.frame), NSHeight(_removeprogressSuccessView.frame))];
    [self.view addSubview:_removeprogressSuccessView];
    
    NSString *promptStr = alertText;
    NSString *overStr = successStr;
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
//    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [promptStr rangeOfString:overStr];
    [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSLeftTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [_removeprogressSuccessViewSubTitle  setAttributedStringValue:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
    
    [_removeprogressSuccessViewTitle setStringValue:CustomLocalizedString(@"Transfer_text_id_4", nil)];
    [_removeprogressSuccessViewTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    double delayInSeconds = 2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self unloadAlertView:_removeprogressSuccessView];
    });
}

- (void)confirmDeleteOkBtn:(id)sender {
    _endRunloop = YES;
    _result = 1;
    [self unloadAlertView:_comfirmDeleteView];
}

- (void)confirmDeletecancelBtn:(id)sender {
    _endRunloop = YES;
    _result = 0;
    [self unloadAlertView:_comfirmDeleteView];
}

- (void)removeBtnOperation:(id)sender {
    _endRunloop = YES;
    _result = 1;
    if (_isUnlockAccount) {
        NSURL *url = nil;
        url = [NSURL URLWithString:CustomLocalizedString(@"iCloudLogin_View_Unlock_Accuont_URL", nil)];
        NSWorkspace *ws = [NSWorkspace sharedWorkspace];
        [ws openURL:url];
        _isUnlockAccount = NO;
        [self unloadAlertView:_confirmAlertView];
    }else if (!_isStopPan) {
        NSLog(@"_isStopPan:%d",_isOpen);
        [self showRemoveProgressViewAlertText:CustomLocalizedString(@"MSG_COM_Deleting", nil) SuperView:nil];
        if (!_isIcloudRemove) {
            _isIcloudRemove = NO;
            [_delegate deleteBackupSelectedItems:sender];
        }
    }else {
        _isStopPan = NO;
        [self unloadAlertView:_confirmAlertView];
    }
}

- (void)cancelBtnOperation:(id)sender {
    _endRunloop = YES;
    _result = 0;
    _isStopPan = NO;
    [self unloadAlertView:_confirmAlertView];
}

- (int)showTitleString:(NSString *)string InputTextFiledString:(NSString *)inputString OkButton:(NSString *)OkText CancelButton:(NSString *)cancelText SuperView:(NSView *)superView {
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_addCustomLableView];
    _endRunloop = NO;
    int result = -1;
    [_addCustomLableCancelBtn reSetInit:cancelText WithPrefixImageName:@"cancal"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelText]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelText.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_addCustomLableCancelBtn setAttributedTitle:attributedTitles];
    
    [_addCustomLableCancelBtn setIsReslutVeiw:YES];
    [_addCustomLableOkBtn reSetInit:OkText WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:OkText]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, OkText.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_addCustomLableOkBtn setAttributedTitle:attributedTitles1];
    
    if (inputString.length == 0 ) {
        [_addCustomLableOkBtn setEnabled:NO];
    }else {
        [_addCustomLableOkBtn setEnabled:YES];
    }
    
    [_addCustomLableOkBtn setTarget:self];
    [_addCustomLableOkBtn setAction:@selector(addOkBtnClick:)];
    [_addCustomLableOkBtn setTag:3];
    [_addCustomLableCancelBtn setTarget:self];
    [_addCustomLableCancelBtn setAction:@selector(addCancelBtnClick:)];
    [_addCustomLableCancelBtn setTag:3];
    NSSize cancelBtnRectSize = [StringHelper calcuTextBounds:cancelText fontSize:13.0].size;
    NSSize removeBtnRectSize = [StringHelper calcuTextBounds:OkText fontSize:13.0].size;
    int width = 0;
    if (cancelBtnRectSize.width > 76 || removeBtnRectSize.width > 76) {
        if (cancelBtnRectSize.width > removeBtnRectSize.width) {
            width = ceil(cancelBtnRectSize.width + 20);
        }else {
            width = ceil(removeBtnRectSize.width + 20);
        }
        [_addCustomLableOkBtn setFrame:NSMakeRect(NSMaxX(_addCustomLableView.bounds) - width - 25, 25, width, _addCustomLableOkBtn.frame.size.height)];
        [_addCustomLableCancelBtn setFrame:NSMakeRect(NSMaxX(_addCustomLableView.bounds) - width*2 - 25 - 15,  25, width, _addCustomLableCancelBtn.frame.size.height)];
    }else {
        [_addCustomLableOkBtn setFrame:NSMakeRect(NSMaxX(_addCustomLableView.bounds) - _addCustomLableOkBtn.frame.size.width - 25,  25, _addCustomLableOkBtn.frame.size.width, _addCustomLableOkBtn.frame.size.height)];
        [_addCustomLableCancelBtn setFrame:NSMakeRect(NSMaxX(_addCustomLableView.bounds) - _reNameOkBtn.frame.size.width - _addCustomLableCancelBtn.frame.size.width - 25 - 15,  25, _addCustomLableCancelBtn.frame.size.width, _addCustomLableCancelBtn.frame.size.height)];
    }
    [_addCustomLableInputView setIsRegistedTextView:YES];
    [_addCustomLableInputView setIsNOCanDraw:YES];
    [_addCustomLableInputView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_addCustomLableTitle setStringValue:string];
    [_addCustomLableTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_addCustomLableInputTextFiled setStringValue:inputString];
     [_addCustomLableInputTextFiled setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    [style setAlignment:NSLeftTextAlignment];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:13.0],NSFontAttributeName,style,NSParagraphStyleAttributeName, nil];
//    NSSize size = [string sizeWithAttributes:dic];
//    [_reNameTitle setFrameSize:NSMakeSize(size.width+2, size.height)];
    [_reNameInputView setFrame:NSMakeRect(28, _addCustomLableInputView.frame.origin.y,  330, ceil(_reNameInputView.frame.size.height))];
    [style release], style = nil;
    //加一个runloop
    NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
    NSInteger result1 = NSRunContinuesResponse;
    while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [NSApp endModalSession:session];
    result = _result;
    return result;
}

//解密窗口
- (int)showAlertText:(NSString *)alertTitleText WithSubTitleStr:(NSString *)subString OKButton:(NSString *)okButtonString    canCelBtn:(NSString *)cancelString SuperView:(NSView *)superView
{
    
    [_unLockBackUpPassView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_unLockBackUpPassTitleStr setStringValue:@""];
    [_unLockBackUpPassTitleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_unLockBackUpPassTitleStr setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_unLockBackUpPassView];
    _endRunloop = NO;
    int result = -1;
    [_unLockBackUpOkBtn setTitle:okButtonString];
    [_unLockBackUpCancleBtn setTitle:cancelString];
    [_unLockBackupViewTitleStr setStringValue:alertTitleText];
    [_unLockBackupViewTitleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_unLockBackUpSubTitleStr setStringValue:subString];
    [_unLockBackUpSubTitleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_unLockBackUpLandingstatusTitleStr setHidden:YES];
    NSSize okBtnRectSize = [StringHelper calcuTextBounds:okButtonString fontSize:12.0].size;
    int width = 0;
    [_unLockBackUpOkBtn reSetInit:okButtonString WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:okButtonString]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_unLockBackUpOkBtn setAttributedTitle:attributedTitles1];
    
    [_unLockBackUpCancleBtn reSetInit:cancelString WithPrefixImageName:@"cancal"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelString]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelString.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, cancelString.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelString.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_unLockBackUpCancleBtn setAttributedTitle:attributedTitles];
    [_unLockBackUpCancleBtn setIsReslutVeiw:YES];
    if (okBtnRectSize.width > 76) {
        width = ceil(okBtnRectSize.width + 20);
        [_unLockBackUpOkBtn setFrame:NSMakeRect(NSMaxX(_unLockBackUpPassView.bounds) - width - 25, NSMinY(_unLockBackUpPassView.bounds) + 18, width, _okBtn.frame.size.height)];
        [_unLockBackUpCancleBtn setFrame:NSMakeRect(_unLockBackUpOkBtn.frame.origin.x - _unLockBackUpOkBtn.frame.size.width  - 10, NSMinY(_unLockBackUpPassView.bounds) + 18, _unLockBackUpOkBtn.frame.size.width , _unLockBackUpCancleBtn.frame.size.height)];
    }else {
        [_unLockBackUpOkBtn setFrame:NSMakeRect(NSMaxX(_unLockBackUpPassView.bounds) - _unLockBackUpOkBtn.frame.size.width - 25, NSMinY(_unLockBackUpPassView.bounds) + 18, _unLockBackUpOkBtn.frame.size.width, _unLockBackUpOkBtn.frame.size.height)];
        [_unLockBackUpCancleBtn setFrame:NSMakeRect(_unLockBackUpOkBtn.frame.origin.x - _unLockBackUpOkBtn.frame.size.width  - 10, NSMinY(_unLockBackUpPassView.bounds) + 18, _unLockBackUpOkBtn.frame.size.width , _unLockBackUpCancleBtn.frame.size.height)];
    }
    [_unLockBackUpCancleBtn setTarget:self];
    [_unLockBackUpCancleBtn setAction:@selector(secireCancelBtnDown:)];
    [_unLockBackUpOkBtn setTarget:self];
    [_unLockBackUpOkBtn setAction:@selector(secireOkBtn:)];
    //加一个runloop
    NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
    NSInteger result1 = NSRunContinuesResponse;
    while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [NSApp endModalSession:session];
    result = _result;
    return result;
    
}

-(void)changFindiPhoneTextFieldBtnState{
    [_activationBommotView setStringValue:@""];
}

//Icloud 关闭窗口
- (int)showAlertTextSuperView:(NSView *)superView withClosenodeEnum:(CategoryNodesEnum )nodeEnum withisIcloudClose:(BOOL)isiCloudClose
{
    NSView *bView = superView;
    [bView addSubview:self.view];
    [self.view setFrameSize:superView.frame.size];
    [self.view addSubview:_icloudCloseView];
    [_icloudCloseView setFrame:NSMakeRect(superView.frame.origin.x + floor((superView.frame.size.width - _icloudCloseView.frame.size.width) / 2), superView.frame.size.height, _icloudCloseView.frame.size.width, _icloudCloseView.frame.size.height)];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(bView.frame.origin.x + floor((bView.frame.size.width - _icloudCloseView.frame.size.width) / 2), bView.frame.size.height - _icloudCloseView.frame.size.height + 8, _icloudCloseView.frame.size.width, _icloudCloseView.frame.size.height);
        
        [context setDuration:0.3];
        [[_icloudCloseView animator] setFrame:rect];
    } completionHandler:^{
        [self.view setWantsLayer:YES];
    }];
    
    [_icloudCloseView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    NSString *enumStr = @"";
    NSString *enumStrS = @"";
    NSString *urlStr = @"";
    if (isiCloudClose) {
        if (nodeEnum ==  Category_Notes ) {
            enumStr = CustomLocalizedString(@"MenuItem_id_60", nil);
            enumStrS = CustomLocalizedString(@"MenuItem_id_17", nil);
        }else if (nodeEnum == Category_Calendar){
            enumStr = CustomLocalizedString(@"MenuItem_id_62", nil);
            enumStrS = CustomLocalizedString(@"MenuItem_id_22", nil);
        }else if (nodeEnum == Category_Contacts){
            enumStr = CustomLocalizedString(@"MenuItem_id_83", nil);
            enumStrS = CustomLocalizedString(@"MenuItem_id_20", nil);
        }else if (nodeEnum == Category_Bookmarks) {
            enumStrS = CustomLocalizedString(@"MenuItem_id_38", nil);
        }
        if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
            [_iCloudMiddleNubOneStr setFrameOrigin:NSMakePoint(130, _iCloudMiddleNubOneStr.frame.origin.y)];
            [_iCloudMiddleNubTwoStr setFrameOrigin:NSMakePoint(315, _iCloudMiddleNubTwoStr.frame.origin.y)];
            [_iCloudMiddleNubThreeStr setFrameOrigin:NSMakePoint(540, _iCloudMiddleNubThreeStr.frame.origin.y)];
            
            [_iCloudMiddleOneTitle setFrameOrigin:NSMakePoint(-32, _iCloudMiddleOneTitle.frame.origin.y)];
            [_iCloudMiddleTwoTitle setFrameOrigin:NSMakePoint(160, _iCloudMiddleTwoTitle.frame.origin.y)];
            [_iCloudMiddleThreeTitle setFrameOrigin:NSMakePoint(412, _iCloudMiddleThreeTitle.frame.origin.y)];
            
            [_icloudCloseTitleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"CloseiCloud_id_1", nil),enumStrS,enumStrS]];
            //    [_iCloudMiddleVIewTitle setStringValue:CustomLocalizedString(@"CloseiCloud_id_2", nil)];
            [_icloudCloseTitleStr setFrame:NSMakeRect(72, 370, _icloudCloseTitleStr.frame.size.width, _icloudCloseTitleStr.frame.size.height)];
            
            [_iCloudMiddleOneTitle setStringValue:[NSString stringWithFormat:
                                                   CustomLocalizedString(@"CloseiCloud_id_5", nil),enumStrS]];
            [_iCloudMiddleTwoTitle setStringValue:CustomLocalizedString(@"CloseiCloud_id_4", nil)];
            [_iCloudMiddleThreeTitle setStringValue:CustomLocalizedString(@"CloseiCloud_id_3", nil)];
            [_iCloudMiddleNubOneStr setStringValue:@"3."];
            [_iCloudMiddleNubTwoStr setStringValue:@"2."];
            [_iCloudMiddleNubThreeStr setStringValue:@"1."];
            [_icloudCloseOneImgVIew setImage:[StringHelper imageNamed:@"icloud_close_step3"]];
            [_iCloudCloseTwoImgView setImage:[StringHelper imageNamed:@"icloud_close_step2"]];
            [_icloudCloseThreeImgView setImage:[StringHelper imageNamed:@"icloud_close_step1"]];
            urlStr = CustomLocalizedString(@"CloseiCloud_id_6", nil);
 
        }else {
            [_icloudCloseTitleStr setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"CloseiCloud_id_1", nil),enumStrS,enumStrS]];
            //    [_iCloudMiddleVIewTitle setStringValue:CustomLocalizedString(@"CloseiCloud_id_2", nil)];
            [_icloudCloseTitleStr setFrame:NSMakeRect(72, 370, _icloudCloseTitleStr.frame.size.width, _icloudCloseTitleStr.frame.size.height)];
            
            [_iCloudMiddleOneTitle setStringValue:CustomLocalizedString(@"CloseiCloud_id_3", nil)];
            [_iCloudMiddleTwoTitle setStringValue:CustomLocalizedString(@"CloseiCloud_id_4", nil)];
            [_iCloudMiddleThreeTitle setStringValue:[NSString stringWithFormat:
                                                     CustomLocalizedString(@"CloseiCloud_id_5", nil),enumStrS]];
            [_iCloudMiddleNubOneStr setStringValue:@"1."];
            [_iCloudMiddleNubTwoStr setStringValue:@"2."];
            [_iCloudMiddleNubThreeStr setStringValue:@"3."];
            [_icloudCloseOneImgVIew setImage:[StringHelper imageNamed:@"icloud_close_step1"]];
            [_iCloudCloseTwoImgView setImage:[StringHelper imageNamed:@"icloud_close_step2"]];
            [_icloudCloseThreeImgView setImage:[StringHelper imageNamed:@"icloud_close_step3"]];
            urlStr = CustomLocalizedString(@"CloseiCloud_id_6", nil);
        }

    }else{
        if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
            [_iCloudMiddleNubOneStr setFrameOrigin:NSMakePoint(148, _iCloudMiddleNubOneStr.frame.origin.y)];
            [_iCloudMiddleNubTwoStr setFrameOrigin:NSMakePoint(315, _iCloudMiddleNubTwoStr.frame.origin.y)];
            [_iCloudMiddleNubThreeStr setFrameOrigin:NSMakePoint(540, _iCloudMiddleNubThreeStr.frame.origin.y)];
            
            [_iCloudMiddleOneTitle setFrameOrigin:NSMakePoint(-12, _iCloudMiddleOneTitle.frame.origin.y)];
            [_iCloudMiddleTwoTitle setFrameOrigin:NSMakePoint(160, _iCloudMiddleTwoTitle.frame.origin.y)];
            [_iCloudMiddleThreeTitle setFrameOrigin:NSMakePoint(412, _iCloudMiddleThreeTitle.frame.origin.y)];
            [_icloudCloseOneImgVIew setImage:[StringHelper imageNamed:@"findmyiphone"]];
            [_iCloudCloseTwoImgView setImage:[StringHelper imageNamed:@"icloud_close_step2"]];
            [_icloudCloseThreeImgView setImage:[StringHelper imageNamed:@"icloud_close_step1"]];//
            [_iCloudMiddleThreeTitle setStringValue:CustomLocalizedString(@"CloseiCloud_id_3", nil)];
            [_iCloudMiddleTwoTitle setStringValue:CustomLocalizedString(@"CloseiCloud_id_4", nil)];
            [_iCloudMiddleOneTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"CloseiCloud_id_5", nil),CustomLocalizedString(@"FindMyiPhone_Tips", nil)]];
            [_iCloudMiddleNubOneStr setStringValue:@"3."];
            [_iCloudMiddleNubTwoStr setStringValue:@"2."];
            [_iCloudMiddleNubThreeStr setStringValue:@"1."];
        }else {
            [_icloudCloseOneImgVIew setImage:[StringHelper imageNamed:@"icloud_close_step1"]];
            [_iCloudCloseTwoImgView setImage:[StringHelper imageNamed:@"icloud_close_step2"]];
            [_icloudCloseThreeImgView setImage:[StringHelper imageNamed:@"findmyiphone"]];
            [_iCloudMiddleOneTitle setStringValue:CustomLocalizedString(@"CloseiCloud_id_3", nil)];
            [_iCloudMiddleTwoTitle setStringValue:CustomLocalizedString(@"CloseiCloud_id_4", nil)];
            [_iCloudMiddleThreeTitle setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"CloseiCloud_id_5", nil),CustomLocalizedString(@"FindMyiPhone_Tips", nil)]];
            [_iCloudMiddleNubOneStr setStringValue:@"1."];
            [_iCloudMiddleNubTwoStr setStringValue:@"2."];
            [_iCloudMiddleNubThreeStr setStringValue:@"3."];
        }
        
        urlStr = CustomLocalizedString(@"CloseiCloud_id_6", nil);
        //to long 9.4 改图片
        [_icloudCloseTitleStr setStringValue:CustomLocalizedString(@"Recovery_View_Tips1", nil)];
        [_icloudCloseTitleStr setFrame:NSMakeRect(_icloudCloseTitleStr.frame.origin.x, 354, _icloudCloseTitleStr.frame.size.width, _icloudCloseTitleStr.frame.size.height)];

        //    [_iCloudMiddleVIewTitle setStringValue:CustomLocalizedString(@"CloseiCloud_id_2", nil)];

    }
    
    [_icloudCloseTitleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_iCloudMiddleNubOneStr setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_iCloudMiddleNubTwoStr setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_iCloudMiddleNubThreeStr setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_iCloudMiddleVIewTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_iCloudMiddleOneTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_iCloudMiddleTwoTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_iCloudMiddleThreeTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    [_iCloudToURLGuideBtn WithMouseExitedfillColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)] WithMouseUpfillColor:[NSColor clearColor] WithMouseDownfillColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)] withMouseEnteredfillColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_iCloudToURLGuideBtn WithMouseExitedLineColor:[NSColor clearColor] WithMouseUpLineColor:[NSColor clearColor] WithMouseDownLineColor:[NSColor clearColor] withMouseEnteredLineColor:[NSColor clearColor]];
    [_iCloudToURLGuideBtn WithMouseExitedtextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithMouseUptextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithMouseDowntextColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] withMouseEnteredtextColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)]];
    [_iCloudToURLGuideBtn setTitleName:urlStr WithDarwRoundRect:0 WithLineWidth:0 withFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];

     NSRect URlBtnRect = [StringHelper calcuTextBounds:urlStr fontSize:14.0];
    [_iCloudToURLGuideBtn setFrameSize:NSMakeSize(URlBtnRect.size.width +20, _iCloudToURLGuideBtn.frame.size.height)];
    [_iCloudToURLGuideBtn setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    
    NSString *okBtnStr = CustomLocalizedString(@"Button_IKnown", nil);
    NSSize okBtnRectSize = [StringHelper calcuTextBounds:okBtnStr fontSize:14.0].size;
    int width = 0;
    
    [_iCloudOKBtn reSetInit:okBtnStr WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okBtnStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_iCloudOKBtn setAttributedTitle:attributedTitles];
//    if (okBtnRectSize.width > 76) {
        width = ceil(okBtnRectSize.width + 20);
        [_iCloudOKBtn setFrame:NSMakeRect(NSMaxX(_icloudCloseView.bounds) - width - 32, _iCloudOKBtn.frame.origin.y, width, _okBtn.frame.size.height)];
//    }else {
//        [_iCloudOKBtn setFrame:NSMakeRect(NSMaxX(_icloudCloseView.bounds) - _iCloudOKBtn.frame.size.width - 32, _iCloudOKBtn.frame.origin.y, _iCloudOKBtn.frame.size.width, _iCloudOKBtn.frame.size.height)];
//    }
    [_iCloudOKBtn setTarget:self];
    [_iCloudOKBtn setAction:@selector(closeViewCloseOperation:)];
    return 0;
}

//设置窗口
- (void)showAlertSettingSuperView:(NSView *)superView withIpod:(IMBiPod *)ipod {
    if (_iPod != nil) {
        [_iPod release];
        _iPod = nil;
    }
    if (ipod != nil) {
        _iPod = [ipod retain];
    }
    
    if (_exportSetting != nil) {
        [_exportSetting release];
        _exportSetting = nil;
    }
    if (ipod) {
        _exportSetting = [ipod.exportSetting retain];
    }else {
        _exportSetting = [[IMBExportSetting alloc] initWithIPod:nil];
    }
    NSView *bView = superView;
    [bView addSubview:self.view];
    [self.view setWantsLayer:YES];
    [self.view setFrameSize:superView.frame.size];
    [self.view addSubview:_settingView];
    [_settingView setFrame:NSMakeRect(superView.frame.origin.x + floor((superView.frame.size.width - _settingView.frame.size.width) / 2), superView.frame.size.height, _settingView.frame.size.width, _settingView.frame.size.height)];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(bView.frame.origin.x + floor((bView.frame.size.width - _settingView.frame.size.width) / 2), bView.frame.size.height - _settingView.frame.size.height + 8, _settingView.frame.size.width, _settingView.frame.size.height);
        [context setDuration:0.3];
        [[_settingView animator] setFrame:rect];
    } completionHandler:^{
        [self.view setWantsLayer:YES];
    }];
    
    [_settingViewTitleStr setStringValue:CustomLocalizedString(@"SettingView_id_1", nil)];
    [_settingViewTitleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_settingSafariHistoryTitle setStringValue:CustomLocalizedString(@"SettingView_id_7", nil)];
    [_settingSafariHistoryTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_settingContactTitle setStringValue:CustomLocalizedString(@"SettingView_id_3", nil)];
    [_settingContactTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_settingCallhistoryTitle setStringValue:CustomLocalizedString(@"SettingView_id_2", nil)];
    [_settingCallhistoryTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_settingCalendarTitle setStringValue:CustomLocalizedString(@"SettingView_id_5", nil)];
    [_settingCalendarTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_settingReminderTitle setStringValue:CustomLocalizedString(@"SettingView_id_11", nil)];
    [_settingReminderTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_settingMessageTitle setStringValue:CustomLocalizedString(@"SettingView_id_4", nil)];
    [_settingMessageTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_settingNoteTitle setStringValue:CustomLocalizedString(@"SettingView_id_6", nil)];
    [_settingNoteTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_settingBookmarkTitle setStringValue:CustomLocalizedString(@"SettingView_id_8", nil)];
    [_settingBookmarkTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_settingExporStr setStringValue:CustomLocalizedString(@"SettingView_id_9", nil)];
    [_settingExporStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_settingBackStr setStringValue:CustomLocalizedString(@"SettingView_id_10", nil)];
    [_settingBackStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSString *cancelStr = CustomLocalizedString(@"Button_Cancel", nil);
    [_settingCancelBtn reSetInit:cancelStr WithPrefixImageName:@"cancal"];
    [_settingCancelBtn setFontSize:12];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_settingCancelBtn setAttributedTitle:attributedTitles];
    [_settingCancelBtn setIsReslutVeiw:YES];
    [_settingCancelBtn setTarget:self];
    [_settingCancelBtn setAction:@selector(settingViewCancelBtn:)];
    [_settingCancelBtn setNeedsDisplay:YES];
    NSRect rect1 = [TempHelper calcuTextBounds:cancelStr fontSize:14];
    NSString *saveStr = CustomLocalizedString(@"Button_Save", nil);
    NSRect rect2 = [TempHelper calcuTextBounds:saveStr fontSize:14];
    NSRect rect;
    if (rect1.size.width > rect2.size.width) {
        rect = rect1;
    }else{
        rect = rect2;
    }
    [_settingCancelBtn setFrame:NSMakeRect(_settingMiddleView.frame.size.width/2 - (int)rect.size.width - 20 - 5, _settingCancelBtn.frame.origin.y, (int)rect.size.width + 20, _settingCancelBtn.frame.size.height)];
    
    [_photoSubLable setStringValue:CustomLocalizedString(@"setting_id_38", nil)];
    [_photoSubLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSSize size = [_photoSubLable.cell cellSizeForBounds:_photoSubLable.frame];
    [_photoCheckBtn  setUnCheckImg:[NSImage imageNamed:@"checkbox1" ]];
    [_photoCheckBtn setCheckImg:[NSImage imageNamed:@"checkbox2" ]];
    [_photoSubLable setFrame:NSMakeRect(ceil((_settingMiddleView.frame.size.width - size.width -20)/2), ceil(_photoSubLable.frame.origin.y), ceil(size.width +20), ceil(_photoSubLable.frame.size.height))];
    if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        [_photoCheckBtn setFrame:NSMakeRect(_photoSubLable.frame.origin.x + _photoSubLable.frame.size.width + 10, _photoCheckBtn.frame.origin.y, _photoCheckBtn.frame.size.width,_photoCheckBtn.frame.size.height)];
    }else {
        [_photoCheckBtn setFrame:NSMakeRect(_photoSubLable.frame.origin.x - 24, _photoCheckBtn.frame.origin.y, _photoCheckBtn.frame.size.width,_photoCheckBtn.frame.size.height)];
    }
    if ([IMBSoftWareInfo singleton].isKeepPhotoDate) {
        [_photoCheckBtn setState:NSOnState];
    }else{
        [_photoCheckBtn setState:NSOffState];
    }
    
    [_settingSaveBtn reSetInit:saveStr WithPrefixImageName:@"pop"];
    [_settingSaveBtn setFontSize:12];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:saveStr]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, saveStr.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, saveStr.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, saveStr.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_settingSaveBtn setAttributedTitle:attributedTitles1];
    [_settingSaveBtn setTarget:self];
    [_settingSaveBtn setAction:@selector(saveBtnOperation:)];

    [_settingSaveBtn setFrame:NSMakeRect(_settingMiddleView.frame.size.width/2 + 5, _settingSaveBtn.frame.origin.y, (int)rect.size.width + 20, _settingSaveBtn.frame.size.height)];
    
    NSString *exportBtnStr = CustomLocalizedString(@"Button_Select", nil);
    [_settingExportBtn reSetInit:exportBtnStr WithPrefixImageName:@"cancal"];
    [_settingExportBtn setFontSize:12];
    [_settingExportBtn setIsReslutVeiw:YES];
    NSMutableAttributedString *attributedTitles2 = [[[NSMutableAttributedString alloc]initWithString:exportBtnStr]autorelease];
    [attributedTitles2 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, exportBtnStr.length)];
    [attributedTitles2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, exportBtnStr.length)];
    [attributedTitles2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, exportBtnStr.length)];
    [attributedTitles2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles2.length)];
    [_settingExportBtn setAttributedTitle:attributedTitles2];
    [_settingExportBtn setIsReslutVeiw:YES];
    [_settingExportBtn setTarget:self];
    [_settingExportBtn setAction:@selector(exportBtnDown:)];
    NSRect rect3 = [TempHelper calcuTextBounds:exportBtnStr fontSize:14];
    [_settingExportBtn setFrame:NSMakeRect(_settingExportBtn.frame.origin.x, _settingExportBtn.frame.origin.y, ceil(rect3.size.width +20), _settingExportBtn.frame.size.height)];
    
    NSString *backupBtnStr = CustomLocalizedString(@"Button_Select", nil);
    [_settingBackBtn reSetInit:backupBtnStr WithPrefixImageName:@"cancal"];
    [_settingBackBtn setFontSize:12];
    NSMutableAttributedString *attributedTitles3 = [[[NSMutableAttributedString alloc]initWithString:backupBtnStr]autorelease];
    [attributedTitles3 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, attributedTitles3.length)];
    [attributedTitles3 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, attributedTitles3.length)];
    [attributedTitles3 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, attributedTitles3.length)];
    [attributedTitles3 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles3.length)];
    [_settingBackBtn setAttributedTitle:attributedTitles3];
    [_settingBackBtn setIsReslutVeiw:YES];
    [_settingBackBtn setTarget:self];
    [_settingBackBtn setAction:@selector(backBtnDown:)];
    [_settingBackBtn setFrame:NSMakeRect(_settingBackBtn.frame.origin.x, _settingBackBtn.frame.origin.y, ceil(rect3.size.width +20) , _settingBackBtn.frame.size.height)];
    [self removePopBtn];
    [self addPopBtn];
    [_settingView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    
    [_settingPathStr setStringValue:_exportSetting.exportPath];
    [_settingPathStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_settingbackPathStr setStringValue:_exportSetting.backupPath];
    [_settingbackPathStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
}

- (void)showRingToneAlertSettingSuperView:(NSView *)superView withContinue:(BOOL)isContinue {
    _isContinue = isContinue;
    NSView *bView = superView;
    [bView addSubview:self.view];
    [self.view setWantsLayer:YES];
    [self.view setFrameSize:superView.frame.size];
    [self.view addSubview:_ringtoneSettingView];
    [_ringtoneSettingView setFrame:NSMakeRect(superView.frame.origin.x + floor((superView.frame.size.width - _ringtoneSettingView.frame.size.width) / 2), superView.frame.size.height, _ringtoneSettingView.frame.size.width, _ringtoneSettingView.frame.size.height)];
    __block NSRect newRect;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        newRect = NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _ringtoneSettingView.frame.size.width) / 2), self.view.frame.size.height - _ringtoneSettingView.frame.size.height + 8, _ringtoneSettingView.frame.size.width, _ringtoneSettingView.frame.size.height);
        [context setDuration:0.3];
        [[_ringtoneSettingView animator] setFrame:newRect];
    } completionHandler:^{
        [_ringtoneSettingView setFrame:newRect];
        [self.view setWantsLayer:YES];
    }];
    
    IMBRingtoneConfig *conFig = [IMBRingtoneConfig singleton];
    [_ringtoneDuraTionTitle setStringValue:CustomLocalizedString(@"ringtone_setting_window_1", nil)];
    [_ringtoneDurationThirdLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_ringtoneDurationFirstLabel setStringValue:CustomLocalizedString(@"ringtone_setting_window_2", nil)];
    [_ringtoneDurationFirstLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_ringtoneDurationFirstBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1"]];
    [_ringtoneDurationFirstBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2"]];
    [_ringtoneDurationFirstBtn setState:NSOffState];
    [_ringtoneDurationFirstBtn setTarget:self];
    [_ringtoneDurationFirstBtn setTag:101];
    [_ringtoneDurationFirstBtn setAction:@selector(setRingtoneDurationTime:)];
    [_ringtoneDurationSecondLabel setStringValue:CustomLocalizedString(@"ringtone_setting_window_3", nil)];
    [_ringtoneDurationSecondLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_ringtoneDurationSecondBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1"]];
    [_ringtoneDurationSecondBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2"]];
    [_ringtoneDurationSecondBtn setState:NSOffState];
    [_ringtoneDurationSecondBtn setTarget:self];
    [_ringtoneDurationSecondBtn setTag:102];
    [_ringtoneDurationSecondBtn setAction:@selector(setRingtoneDurationTime:)];
    [_ringtoneDurationThirdLabel setStringValue:CustomLocalizedString(@"ringtone_setting_window_4", nil)];
    [_ringtoneDurationThirdLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_ringtoneDurationThirdBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1"]];
    [_ringtoneDurationThirdBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2"]];
    [_ringtoneDurationThirdBtn setState:NSOffState];
    [_ringtoneDurationThirdBtn setTarget:self];
    [_ringtoneDurationThirdBtn setTag:103];
    [_ringtoneDurationThirdBtn setAction:@selector(setRingtoneDurationTime:)];
    CvtRingtoneSizeEnum convertSize = conFig.convertSize;
    if (convertSize == RT_Sec25) {
        [_ringtoneDurationFirstBtn setState:NSOnState];
    }else if (convertSize == RT_Sec40){
        [_ringtoneDurationSecondBtn setState:NSOnState];
    }else {
        [_ringtoneDurationThirdBtn setState:NSOnState];
    }
    
    [_ringtoneConverTitle setStringValue:CustomLocalizedString(@"ringtone_setting_window_5", nil)];
    [_ringtoneConverTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_ringtoneInterceptLabelOne setStringValue:CustomLocalizedString(@"ringtone_setting_window_6", nil)];
    [_ringtoneInterceptLabelOne setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys: [NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName,nil];
    NSRect rect1 = [CustomLocalizedString(@"ringtone_setting_window_6", nil) boundingRectWithSize:NSMakeSize(645, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic];
    [_ringtoneInterceptLabelTwo setStringValue:CustomLocalizedString(@"ringtone_setting_window_7", nil)];
    [_ringtoneInterceptLabelTwo setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSRect rect2 = [CustomLocalizedString(@"ringtone_setting_window_7", nil) boundingRectWithSize:NSMakeSize(645, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:fontDic];
    [_ringtoneInterceptLabelThree setStringValue:CustomLocalizedString(@"ringtone_setting_window_8", nil)];
    [_ringtoneInterceptLabelThree setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_ringtoneMinutePopBtn setFrameOrigin:NSMakePoint(_ringtoneInterceptLabelOne.frame.origin.x + rect1.size.width + 4, _ringtoneMinutePopBtn.frame.origin.y)];
    [_ringtoneInterceptLabelTwo setFrameOrigin:NSMakePoint(_ringtoneInterceptLabelOne.frame.origin.x + rect1.size.width + _ringtoneMinutePopBtn.frame.size.width+2, _ringtoneInterceptLabelTwo.frame.origin.y)];
    [_ringtoneSecondPopBtn setFrameOrigin:NSMakePoint(_ringtoneInterceptLabelOne.frame.origin.x + rect1.size.width+_ringtoneMinutePopBtn.frame.size.width + rect2.size.width + 4, _ringtoneMinutePopBtn.frame.origin.y)];
    [_ringtoneInterceptLabelThree setFrameOrigin:NSMakePoint(_ringtoneInterceptLabelOne.frame.origin.x + rect1.size.width+_ringtoneMinutePopBtn.frame.size.width + rect2.size.width + _ringtoneSecondPopBtn.frame.size.width+2, _ringtoneInterceptLabelThree.frame.origin.y)];
    for (int i = 0 ;i < 60 ;i ++) {
        [_ringtoneMinutePopBtn addItemWithTitle:[NSString stringWithFormat:@"%02d",i]];
        [_ringtoneSecondPopBtn addItemWithTitle:[NSString stringWithFormat:@"%02d",i]];
    }
    
    [_ringtoneMinutePopBtn setTitle:[NSString stringWithFormat:@"%02d",conFig.startSecond/60]];
    [_ringtoneSecondPopBtn setTitle:[NSString stringWithFormat:@"%02d",conFig.startSecond%60]];

    [_ringtoneConverNoteLabel setStringValue:CustomLocalizedString(@"ringtone_setting_window_9", nil)];
    [_ringtoneConverNoteLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_ringtoneConverRemindLabel setStringValue:CustomLocalizedString(@"ringtone_setting_window_10", nil)];
    [_ringtoneConverRemindLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_ringtoneConverRemindBtn setUnCheckImg:[StringHelper imageNamed:@"checkbox1" ]];
    [_ringtoneConverRemindBtn setCheckImg:[StringHelper imageNamed:@"checkbox2" ]];
    if (conFig.allSkip) {
        [_ringtoneConverRemindBtn setState:NSOffState];
    }else {
        [_ringtoneConverRemindBtn setState:NSOnState];
    }
    [_ringtoneExportPathTitle setStringValue:CustomLocalizedString(@"SettingView_id_9", nil)];
    [_ringtoneExportPathTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_ringtoneChooseExportPathLabel setStringValue:conFig.exportPath];
    [_ringtoneChooseExportPathLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    NSString *cancelStr = CustomLocalizedString(@"Button_Cancel", nil);
    [_ringtoneCancelBtn reSetInit:cancelStr WithPrefixImageName:@"cancal"];
    [_ringtoneCancelBtn setFontSize:12];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_ringtoneCancelBtn setAttributedTitle:attributedTitles];
    [_ringtoneCancelBtn setIsReslutVeiw:YES];
    [_ringtoneCancelBtn setTarget:self];
    [_ringtoneCancelBtn setAction:@selector(cancelRingtoneConfig:)];
    [_ringtoneCancelBtn setNeedsDisplay:YES];
    
    NSRect cancelRect = [TempHelper calcuTextBounds:cancelStr fontSize:14];
    NSString *saveStr = CustomLocalizedString(@"Button_Save", nil);
    NSRect saveRect = [TempHelper calcuTextBounds:saveStr fontSize:14];
    NSRect rect;
    if (saveRect.size.width > cancelRect.size.width) {
        rect = saveRect;
    }else{
        rect = cancelRect;
    }
    [_ringtoneCancelBtn setFrame:NSMakeRect(_ringtoneSettingView.frame.size.width/2 - (int)cancelRect.size.width - 20 - 5, _ringtoneCancelBtn.frame.origin.y, (int)cancelRect.size.width + 20, _ringtoneCancelBtn.frame.size.height)];
    
    [_ringtoneSaveBtn reSetInit:saveStr WithPrefixImageName:@"pop"];
    [_ringtoneSaveBtn setFontSize:12];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:saveStr]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, saveStr.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, saveStr.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, saveStr.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_ringtoneSaveBtn setAttributedTitle:attributedTitles1];
    [_ringtoneSaveBtn setTarget:self];
    [_ringtoneSaveBtn setAction:@selector(saveRingtoneConfig:)];
    
    [_ringtoneSaveBtn setFrame:NSMakeRect(_ringtoneSettingView.frame.size.width/2 + 5, _ringtoneSaveBtn.frame.origin.y, (int)rect.size.width + 20, _ringtoneSaveBtn.frame.size.height)];
    
    NSString *exportBtnStr = CustomLocalizedString(@"Button_Select", nil);
    [_ringtoneChooseExportPathBtn reSetInit:exportBtnStr WithPrefixImageName:@"pop"];
    [_ringtoneChooseExportPathBtn setFontSize:12];
    NSMutableAttributedString *attributedTitles2 = [[[NSMutableAttributedString alloc]initWithString:exportBtnStr]autorelease];
    [attributedTitles2 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, exportBtnStr.length)];
    [attributedTitles2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, exportBtnStr.length)];
    [attributedTitles2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, exportBtnStr.length)];
    [attributedTitles2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles2.length)];
    [_ringtoneChooseExportPathBtn setAttributedTitle:attributedTitles2];
    [_ringtoneChooseExportPathBtn setTarget:self];
    [_ringtoneChooseExportPathBtn setAction:@selector(ringtoneChoosePath:)];
    NSRect rect3 = [TempHelper calcuTextBounds:exportBtnStr fontSize:14];
    [_ringtoneChooseExportPathBtn setFrame:NSMakeRect(_ringtoneChooseExportPathBtn.frame.origin.x, _ringtoneChooseExportPathBtn.frame.origin.y, ceil(rect3.size.width +20), _ringtoneChooseExportPathBtn.frame.size.height)];
}

- (void)showPhotoAlertSettingSuperView:(NSView *)superView withContinue:(BOOL)isContinue
{
    _isPhotoContinue = isContinue;
    _photoExportConfig = [IMBPhotoExportSettingConfig singleton];
    NSView *bView = superView;
    [bView addSubview:self.view];
    [self.view setWantsLayer:YES];
    [self.view setFrameSize:superView.frame.size];
    [self.view addSubview:_photoSettingView];
    [_photoSettingView setFrame:NSMakeRect(superView.frame.origin.x + floor((superView.frame.size.width - _photoSettingView.frame.size.width) / 2), superView.frame.size.height, _photoSettingView.frame.size.width, _photoSettingView.frame.size.height)];
    __block NSRect newRect;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        newRect = NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _photoSettingView.frame.size.width) / 2), self.view.frame.size.height - _photoSettingView.frame.size.height + 8, _photoSettingView.frame.size.width, _photoSettingView.frame.size.height);
        [context setDuration:0.3];
        [[_photoSettingView animator] setFrame:newRect];
    } completionHandler:^{
        [_photoSettingView setFrame:newRect];
        [self.view setWantsLayer:YES];
    }];
    
    [_photoHEICTitle setStringValue:CustomLocalizedString(@"Photo_Export_Set_id_1", nil)];
    
    [_photoHEICOneLabel setStringValue:CustomLocalizedString(@"Photo_Export_Set_id_2", nil)];
    [_photoHEICTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_photoHEICOneLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_photoHEICOneLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_photoHEICOneCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1"]];
    [_photoHEICOneCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2"]];
    [_photoHEICOneCheckBtn setState:NSOffState];
    [_photoHEICOneCheckBtn setTarget:self];
    [_photoHEICOneCheckBtn setTag:1];
    [_photoHEICOneCheckBtn setAction:@selector(setPhotoCheckBtnDown:)];
   
    [_photoHEICTwoLabel setStringValue:CustomLocalizedString(@"Photo_Export_Set_id_3", nil)];
    [_photoHEICTwoLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_photoHEICTwoCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1"]];
    [_photoHEICTwoCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2"]];
    [_photoHEICTwoCheckBtn setState:NSOffState];
    [_photoHEICTwoCheckBtn setTarget:self];
    [_photoHEICTwoCheckBtn setTag:2];
    [_photoHEICTwoCheckBtn setAction:@selector(setPhotoCheckBtnDown:)];
    
    if (_photoExportConfig.isHEICState == YES) {
        _photoHEICOneCheckBtn.state = NSOnState;
    }else{
        _photoHEICTwoCheckBtn.state = NSOnState;
    }
    
    [_photoLivePhotoTitle setStringValue:CustomLocalizedString(@"Photo_Export_Set_id_4", nil)];
    [_photoLivePhotoTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_photoLiveMP4Label setStringValue:CustomLocalizedString(@"Photo_Export_Set_id_11", nil)];
    [_photoLiveMP4Label setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_photoLiveMP4ChenkBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1"]];
    [_photoLiveMP4ChenkBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2"]];
    [_photoLiveMP4ChenkBtn setState:NSOffState];
    [_photoLiveMP4ChenkBtn setTarget:self];
    [_photoLiveMP4ChenkBtn setTag:3];
    [_photoLiveMP4ChenkBtn setAction:@selector(setPhotoCheckBtnDown:)];
    
    [_photoLiveM4VLabel setStringValue:CustomLocalizedString(@"Photo_Export_Set_id_12", nil)];
    [_photoLiveM4VLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_photoM4VCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1"]];
    [_photoM4VCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2"]];
    [_photoM4VCheckBtn setState:NSOffState];
    [_photoM4VCheckBtn setTarget:self];
    [_photoM4VCheckBtn setTag:4];
    [_photoM4VCheckBtn setAction:@selector(setPhotoCheckBtnDown:)];
    
    [_photoLiveGifHighLable setStringValue:CustomLocalizedString(@"Photo_Export_Set_id_8", nil)];
    [_photoLiveGifHighLable setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_photoLiveGifHighCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1"]];
    [_photoLiveGifHighCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2"]];
    [_photoLiveGifHighCheckBtn setState:NSOffState];
    [_photoLiveGifHighCheckBtn setTarget:self];
    [_photoLiveGifHighCheckBtn setTag:5];
    [_photoLiveGifHighCheckBtn setAction:@selector(setPhotoCheckBtnDown:)];
    
    [_photoLiveMediumLabel setStringValue:CustomLocalizedString(@"Photo_Export_Set_id_9", nil)];
    [_photoLiveMediumLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_photoLiveMediumCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1"]];
    [_photoLiveMediumCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2"]];
    [_photoLiveMediumCheckBtn setState:NSOffState];
    [_photoLiveMediumCheckBtn setTarget:self];
    [_photoLiveMediumCheckBtn setTag:6];
    [_photoLiveMediumCheckBtn setAction:@selector(setPhotoCheckBtnDown:)];
    
    [_photoLiveLowLabel setStringValue:CustomLocalizedString(@"Photo_Export_Set_id_10", nil)];
    [_photoLiveLowLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_photoLiveLowCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1"]];
    [_photoLiveLowCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2"]];
    [_photoLiveLowCheckBtn setState:NSOffState];
    [_photoLiveLowCheckBtn setTarget:self];
    [_photoLiveLowCheckBtn setTag:7];
    [_photoLiveLowCheckBtn setAction:@selector(setPhotoCheckBtnDown:)];
    
    [_photoLiveOriginalLabel setStringValue:CustomLocalizedString(@"Photo_Export_Set_id_7", nil)];
    [_photoLiveOriginalLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_photoLiveOriginalCheckBtn setUnCheckImg:[StringHelper imageNamed:@"preferBtn1"]];
    [_photoLiveOriginalCheckBtn setCheckImg:[StringHelper imageNamed:@"preferBtn2"]];
    [_photoLiveOriginalCheckBtn setState:NSOffState];
    [_photoLiveOriginalCheckBtn setTarget:self];
    [_photoLiveOriginalCheckBtn setTag:8];
    [_photoLiveOriginalCheckBtn setAction:@selector(setPhotoCheckBtnDown:)];
    _photoLiveMP4ChenkBtn.state = NSOffState;
    _photoM4VCheckBtn.state = NSOffState;
    _photoLiveGifHighCheckBtn.state = NSOffState;
    _photoLiveMediumCheckBtn.state = NSOffState;
    _photoLiveLowCheckBtn.state = NSOffState;
    _photoLiveOriginalCheckBtn.state = NSOffState;
    if (_photoExportConfig.chooseLivePhotoExportType == 1) {
        _photoLiveMP4ChenkBtn.state = NSOnState;
    }else if (_photoExportConfig.chooseLivePhotoExportType == 2){
        _photoM4VCheckBtn.state = NSOnState;
    }else if (_photoExportConfig.chooseLivePhotoExportType == 3){
        _photoLiveGifHighCheckBtn.state = NSOnState;
    }else if (_photoExportConfig.chooseLivePhotoExportType == 4){
        _photoLiveMediumCheckBtn.state = NSOnState;
    }else if (_photoExportConfig.chooseLivePhotoExportType == 5){
        _photoLiveLowCheckBtn.state = NSOnState;
    }else if (_photoExportConfig.chooseLivePhotoExportType == 6){
        _photoLiveOriginalCheckBtn.state = NSOnState;
    }
    
    [_photoSureSaveLabel setStringValue:CustomLocalizedString(@"Photo_Export_Set_id_13", nil)];
    [_photoSureSaveLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_photoSureSaveCheckBtn setUnCheckImg:[StringHelper imageNamed:@"checkbox1" ]];
    [_photoSureSaveCheckBtn setCheckImg:[StringHelper imageNamed:@"checkbox2" ]];
    if (!_photoExportConfig.sureSaveCheckBtnState) {
        [_photoSureSaveCheckBtn setState:NSOffState];
    }else {
        [_photoSureSaveCheckBtn setState:NSOnState];
    }
    
    [_keepDataLabelString setStringValue:CustomLocalizedString(@"setting_id_38", nil)];
    [_keepDataLabelString setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_keepDataCheckBtn setUnCheckImg:[StringHelper imageNamed:@"checkbox1" ]];
    [_keepDataCheckBtn setCheckImg:[StringHelper imageNamed:@"checkbox2" ]];
    if (_photoExportConfig.isCreadPhotoDate) {
        [_keepDataCheckBtn setState:NSOnState];
    }else {
        [_keepDataCheckBtn setState:NSOffState];
    }
    
    [_photoChoosePathLabel setStringValue:CustomLocalizedString(@"SettingView_id_9", nil)];
    [_photoChoosePathLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_photoChoosePathString setStringValue:_photoExportConfig.exportPath];
    [_photoChoosePathString setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    NSString *cancelStr = CustomLocalizedString(@"Button_Cancel", nil);
    [_photoCancelDataBtn reSetInit:cancelStr WithPrefixImageName:@"cancal"];
    [_photoCancelDataBtn setFontSize:12];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:cancelStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_photoCancelDataBtn setAttributedTitle:attributedTitles];
    [_photoCancelDataBtn setIsReslutVeiw:YES];
    [_photoCancelDataBtn setTarget:self];
    [_photoCancelDataBtn setAction:@selector(cancelPhotoBtnDown)];
    [_photoCancelDataBtn setNeedsDisplay:YES];

    NSRect cancelRect = [TempHelper calcuTextBounds:cancelStr fontSize:14];
    NSString *saveStr = CustomLocalizedString(@"Button_Save", nil);
    NSRect saveRect = [TempHelper calcuTextBounds:saveStr fontSize:14];
    NSRect rect;
    if (saveRect.size.width < 60 && cancelRect.size.width < 60) {
        rect.size.width = 60;
    }else{
        if (saveRect.size.width > cancelRect.size.width) {
            rect = saveRect;
        }else{
            rect = cancelRect;
        }
    }

    [_photoCancelDataBtn setFrame:NSMakeRect(_photoSettingView.frame.size.width/2 - (int)rect.size.width - 20 - 5, _photoCancelDataBtn.frame.origin.y, (int)rect.size.width + 20, _photoCancelDataBtn.frame.size.height)];
    
    
    [_photoSaveDataBtn reSetInit:saveStr WithPrefixImageName:@"pop"];
    [_photoSaveDataBtn setFontSize:12];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:saveStr]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, saveStr.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, saveStr.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, saveStr.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_photoSaveDataBtn setAttributedTitle:attributedTitles1];
    [_photoSaveDataBtn setTarget:self];
    [_photoSaveDataBtn setAction:@selector(savePhotoBtnDown)];
    
    [_photoSaveDataBtn setFrame:NSMakeRect(_photoSettingView.frame.size.width/2 + 5, _photoSaveDataBtn.frame.origin.y, (int)rect.size.width + 20, _photoSaveDataBtn.frame.size.height)];
    
    NSString *exportBtnStr = CustomLocalizedString(@"Button_Select", nil);
    [_photoChooesPathBtn reSetInit:exportBtnStr WithPrefixImageName:@"pop"];
    [_photoChooesPathBtn setFontSize:12];
    NSMutableAttributedString *attributedTitles2 = [[[NSMutableAttributedString alloc]initWithString:exportBtnStr]autorelease];
    [attributedTitles2 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, exportBtnStr.length)];
    [attributedTitles2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, exportBtnStr.length)];
    [attributedTitles2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, exportBtnStr.length)];
    [attributedTitles2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles2.length)];
    [_photoChooesPathBtn setAttributedTitle:attributedTitles2];
    [_photoChooesPathBtn setTarget:self];
    [_photoChooesPathBtn setAction:@selector(photoChoosePath:)];
    NSRect rect3 = [TempHelper calcuTextBounds:exportBtnStr fontSize:14];
    if (rect3.size.width < 60) {
        rect3.size.width = 60;
    }
    [_photoChooesPathBtn setFrame:NSMakeRect(_ringtoneChooseExportPathBtn.frame.origin.x - 40, _photoChooesPathBtn.frame.origin.y, ceil(rect3.size.width +20), _photoChooesPathBtn.frame.size.height)];
}

- (void)setPhotoCheckBtnDown:(id)sender{
    IMBCheckBtn *btn = (IMBCheckBtn *)sender;
    if (btn.tag == 1) {
        _photoHEICOneCheckBtn.state = NSOnState;
        _photoHEICTwoCheckBtn.state = NSOffState;
    }else if (btn.tag == 2){
        _photoHEICOneCheckBtn.state = NSOffState;
        _photoHEICTwoCheckBtn.state = NSOnState;
    }else if (btn.tag == 3){
        _photoLiveMP4ChenkBtn.state = NSOnState;
        _photoM4VCheckBtn.state = NSOffState;
        _photoLiveGifHighCheckBtn.state = NSOffState;
        _photoLiveMediumCheckBtn.state = NSOffState;
        _photoLiveLowCheckBtn.state = NSOffState;
        _photoLiveOriginalCheckBtn.state = NSOffState;
    }else if (btn.tag == 4){
        _photoLiveMP4ChenkBtn.state = NSOffState;
        _photoM4VCheckBtn.state = NSOnState;
        _photoLiveGifHighCheckBtn.state = NSOffState;
        _photoLiveMediumCheckBtn.state = NSOffState;
        _photoLiveLowCheckBtn.state = NSOffState;
        _photoLiveOriginalCheckBtn.state = NSOffState;
    }else if (btn.tag == 5){
        _photoLiveMP4ChenkBtn.state = NSOffState;
        _photoM4VCheckBtn.state = NSOffState;
        _photoLiveGifHighCheckBtn.state = NSOnState;
        _photoLiveMediumCheckBtn.state = NSOffState;
        _photoLiveLowCheckBtn.state = NSOffState;
        _photoLiveOriginalCheckBtn.state = NSOffState;
    }else if (btn.tag == 6){
        _photoLiveMP4ChenkBtn.state = NSOffState;
        _photoM4VCheckBtn.state = NSOffState;
        _photoLiveGifHighCheckBtn.state = NSOffState;
        _photoLiveMediumCheckBtn.state = NSOnState;
        _photoLiveLowCheckBtn.state = NSOffState;
        _photoLiveOriginalCheckBtn.state = NSOffState;
    }else if (btn.tag == 7){
        _photoLiveMP4ChenkBtn.state = NSOffState;
        _photoM4VCheckBtn.state = NSOffState;
        _photoLiveGifHighCheckBtn.state = NSOffState;
        _photoLiveMediumCheckBtn.state = NSOffState;
        _photoLiveLowCheckBtn.state = NSOnState;
        _photoLiveOriginalCheckBtn.state = NSOffState;
    }else if (btn.tag == 8){
        _photoLiveMP4ChenkBtn.state = NSOffState;
        _photoM4VCheckBtn.state = NSOffState;
        _photoLiveGifHighCheckBtn.state = NSOffState;
        _photoLiveMediumCheckBtn.state = NSOffState;
        _photoLiveLowCheckBtn.state = NSOffState;
        _photoLiveOriginalCheckBtn.state = NSOnState;
    }
    [_photoLiveMP4ChenkBtn setNeedsDisplay:YES];
    [_photoM4VCheckBtn setNeedsDisplay:YES];
    [_photoLiveGifHighCheckBtn setNeedsDisplay:YES];
    [_photoLiveMediumCheckBtn setNeedsDisplay:YES];
    [_photoLiveLowCheckBtn setNeedsDisplay:YES];
    [_photoLiveOriginalCheckBtn setNeedsDisplay:YES];
}

- (void)photoChoosePath:(id)sender{
    _openPanel = [NSOpenPanel openPanel];
    _isOpen = YES;
    //设置默认的路径
    [_openPanel setDirectory:_photoChoosePathString.stringValue];
    [_openPanel setAllowsMultipleSelection:NO];
    [_openPanel setCanChooseFiles:NO];
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result== NSFileHandlingPanelOKButton) {
            NSString * path =[[_openPanel URL] path];
            [_photoChoosePathString setStringValue:path];
        }else{
            NSLog(@"other other other");
        }
        _isOpen = NO;
        [_photoChoosePathString setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [_photoChoosePathString setWantsLayer:YES];
        
    }];

}

- (void)cancelPhotoBtnDown{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _photoSettingView.frame.size.width) / 2), self.view.frame.size.height, _photoSettingView.frame.size.width, _photoSettingView.frame.size.height);
        
        [context setDuration:0.3];
        [[_photoSettingView animator] setFrame:rect];
    } completionHandler:^{
        [_photoSettingView removeFromSuperview];
        [self.view removeFromSuperview];
        if (_isPhotoContinue && _delegate != nil && [_delegate respondsToSelector:@selector(photoToMac)]) {
            [_delegate photoToMac];
        }
    }];
}

- (void)savePhotoBtnDown{
    _photoExportConfig.exportPath = _photoChoosePathString.stringValue;
    _photoExportConfig.isCreadPhotoDate = _keepDataCheckBtn.state;
    _photoExportConfig.sureSaveCheckBtnState = _photoSureSaveCheckBtn.state;
    if (_photoLiveMP4ChenkBtn.state == NSOnState) {
        _photoExportConfig.chooseLivePhotoExportType = 1;
    }else if (_photoM4VCheckBtn.state == NSOnState){
        _photoExportConfig.chooseLivePhotoExportType = 2;
    }else if (_photoLiveGifHighCheckBtn.state == NSOnState){
        _photoExportConfig.chooseLivePhotoExportType = 3;
    }else if (_photoLiveMediumCheckBtn.state == NSOnState){
        _photoExportConfig.chooseLivePhotoExportType = 4;
    }else if (_photoLiveLowCheckBtn.state == NSOnState){
        _photoExportConfig.chooseLivePhotoExportType = 5;
    }else if (_photoLiveOriginalCheckBtn.state == NSOnState){
        _photoExportConfig.chooseLivePhotoExportType = 6;
    }
    if (_photoHEICOneCheckBtn.state == NSOnState) {
        _photoExportConfig.isHEICState = YES;
    }else if (_photoHEICTwoCheckBtn.state == NSOnState){
        _photoExportConfig.isHEICState = NO;
    }
    [_photoExportConfig saveData];

    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _photoSettingView.frame.size.width) / 2), self.view.frame.size.height, _photoSettingView.frame.size.width, _photoSettingView.frame.size.height);
        
        [context setDuration:0.3];
        [[_photoSettingView animator] setFrame:rect];
    } completionHandler:^{
        [_photoSettingView removeFromSuperview];
        [self.view removeFromSuperview];
        if (_isPhotoContinue && _delegate != nil && [_delegate respondsToSelector:@selector(photoToMac)]) {
            [_delegate photoToMac];
        }
    }];
}

- (IBAction)isKeepDateBtnDown:(id)sender {
//    _photoExportConfig.isCreadPhotoDate = _keepDataCheckBtn.state;
}

- (IBAction)sureSaveDataBtnDown:(id)sender {
//    _photoExportConfig.sureSaveCheckBtnState = _photoSureSaveCheckBtn.state;
}

- (void)setRingtoneDurationTime:(id)sender {
    IMBCheckBtn *btn = (IMBCheckBtn *)sender;
    if (btn.tag == 101) {
        [_ringtoneDurationFirstBtn setState:NSOnState];
        [_ringtoneDurationSecondBtn setState:NSOffState];
        [_ringtoneDurationThirdBtn setState:NSOffState];
    }else if (btn.tag == 102) {
        [_ringtoneDurationFirstBtn setState:NSOffState];
        [_ringtoneDurationSecondBtn setState:NSOnState];
        [_ringtoneDurationThirdBtn setState:NSOffState];
    }else if (btn.tag == 103) {
        [_ringtoneDurationFirstBtn setState:NSOffState];
        [_ringtoneDurationSecondBtn setState:NSOffState];
        [_ringtoneDurationThirdBtn setState:NSOnState];
    }
}
//设置RingTone 导出路径
-(void)ringtoneChoosePath:(id)sender {
    _openPanel = [NSOpenPanel openPanel];
    _isOpen = YES;
    //设置默认的路径
    [_openPanel setDirectory:_ringtoneChooseExportPathLabel.stringValue];
    [_openPanel setAllowsMultipleSelection:NO];
    [_openPanel setCanChooseFiles:NO];
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result== NSFileHandlingPanelOKButton) {
            NSString * path =[[_openPanel URL] path];
            [_ringtoneChooseExportPathLabel setStringValue:path];
        }else{
            NSLog(@"other other other");
        }
        _isOpen = NO;
        [_ringtoneChooseExportPathLabel setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [_ringtoneChooseExportPathLabel setWantsLayer:YES];
    }];
}

- (void)saveRingtoneConfig:(id)sender {
    IMBRingtoneConfig *conFig = [IMBRingtoneConfig singleton];
//    [self createConfigFile:_startSecond RingtoneSize:_convertSize IsSkip:_allSkip];
    conFig.startSecond = [_ringtoneMinutePopBtn.title intValue] * 60 + [_ringtoneSecondPopBtn.title intValue];
    if (_ringtoneDurationFirstBtn.state == NSOnState) {
        conFig.convertSize = RT_Sec25;
    }else if (_ringtoneDurationSecondBtn.state == NSOnState) {
        conFig.convertSize = RT_Sec40;
    }else if (_ringtoneDurationThirdBtn.state == NSOnState) {
        conFig.convertSize = RT_SecRest;
    }
    if (_ringtoneConverRemindBtn.state == NSOnState) {
        conFig.allSkip = NO;
    }else {
        conFig.allSkip = YES;
    }
    conFig.exportPath = _ringtoneChooseExportPathLabel.stringValue;
    [conFig saveToDevice];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _ringtoneSettingView.frame.size.width) / 2), self.view.frame.size.height, _ringtoneSettingView.frame.size.width, _ringtoneSettingView.frame.size.height);
        
        [context setDuration:0.3];
        [[_ringtoneSettingView animator] setFrame:rect];
    } completionHandler:^{
        [_ringtoneSettingView removeFromSuperview];
        [self.view removeFromSuperview];
        if (_isContinue && _delegate != nil && [_delegate respondsToSelector:@selector(addItemContent)]) {
            [_delegate addItemContent];
        }
    }];
}

- (void)cancelRingtoneConfig:(id)sender {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _ringtoneSettingView.frame.size.width) / 2), self.view.frame.size.height, _ringtoneSettingView.frame.size.width, _ringtoneSettingView.frame.size.height);
        
        [context setDuration:0.3];
        [[_ringtoneSettingView animator] setFrame:rect];
    } completionHandler:^{
        [_ringtoneSettingView removeFromSuperview];
        [self.view removeFromSuperview];
        if (_isContinue && _delegate != nil && [_delegate respondsToSelector:@selector(addItemContent)]) {
            [_delegate addItemContent];
        }
    }];
}

- (int)showAlertTrustView:(NSView *)superView{
    NSView *bView = superView;
    [bView addSubview:self.view];
    [self.view setWantsLayer:YES];
    [self.view setFrameSize:superView.frame.size];
    [self.view addSubview:_trustView];
    
    IMBSoftWareInfo *softinfo = [IMBSoftWareInfo singleton];
    if ([softinfo chooseLanguageType] == EnglishLanguage) {
        [_transImageView setImage:[StringHelper imageNamed:@"trust_english"]];
    }else if ([softinfo chooseLanguageType] == JapaneseLanguage){
        [_transImageView setImage:[StringHelper imageNamed:@"trust_japan"]];
    }else if ([softinfo chooseLanguageType] == FrenchLanguage){
        [_transImageView setImage:[StringHelper imageNamed:@"trust_French"]];
    }else if ([softinfo chooseLanguageType] == GermanLanguage){
        [_transImageView setImage:[StringHelper imageNamed:@"trust_German"]];
    }else if ([softinfo chooseLanguageType] == SpanishLanguage){
        [_transImageView setImage:[StringHelper imageNamed:@"trust_Spanish"]];
    }else if ([softinfo chooseLanguageType] == ArabLanguage){
        [_transImageView setImage:[StringHelper imageNamed:@"trust_arab"]];
    }
    
    _endRunloop = NO;
    int result = -1;
    [_trustView setFrame:NSMakeRect(superView.frame.origin.x + floor((superView.frame.size.width - _trustView.frame.size.width) / 2), superView.frame.size.height, _trustView.frame.size.width, _trustView.frame.size.height)];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(bView.frame.origin.x + floor((bView.frame.size.width - _trustView.frame.size.width) / 2), bView.frame.size.height - _trustView.frame.size.height + 8, _trustView.frame.size.width, _trustView.frame.size.height);
        [context setDuration:0.3];
        [[_trustView animator] setFrame:rect];
    } completionHandler:^{
        [self.view setWantsLayer:YES];
    }];
    [_trustView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    NSString *str = CustomLocalizedString(@"TrustView_id_2", nil);
    [_trustBtn reSetInit:str WithPrefixImageName:@"pop"];
    [_trustTitle setStringValue:CustomLocalizedString(@"TrustView_id_1", nil)];
    [_trustTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_trustBtn setTarget:self];
    [_trustBtn setAction:@selector(trustViewBtn:)];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:str]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, str.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, str.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, str.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_trustBtn setAttributedTitle:attributedTitles];
    //加一个runloop
//    NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
//    NSInteger result1 = NSRunContinuesResponse;
//    while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
//    {
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    }
//    [NSApp endModalSession:session];
    result = _result;
    return result;
}

- (void)addOkBtnClick:(id)sender {
    _endRunloop = YES;
    _result = 1;
    [self unloadAlertView:_addCustomLableView];
//    if (_delegate != nil && [_delegate respondsToSelector:@selector(addCustomLable:)]) {
//        [_delegate addCustomLable:_addCustomLableInputTextFiled];
//    }
}

- (void)addCancelBtnClick:(id)sender {
    _endRunloop = YES;
    _result = 0;
    [self unloadAlertView:_addCustomLableView];
}

//注册下拉窗口
- (int)showAlertActivationView:(NSView *)superView {
    [_activationBommotView setStringValue:@""];
    [_activationloginStr setStringValue:@""];
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_activationView];
    [_textFieldView setIsRegistedTextView:YES];
    [_textFieldView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_activationloginStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    _endRunloop = NO;
    int result = -1;
    
    [_activationTitle setStringValue:CustomLocalizedString(@"annoy_id_1", nil)];
    [_activationTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_activationSubTitle setStringValue:[CustomLocalizedString(@"register_text_eg", nil) stringByAppendingString:@":"]];
    [_activationSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    NSString *str = CustomLocalizedString(@"Button_Cancel", nil);
    [_activationCancelBtn reSetInit:str WithPrefixImageName:@"cancal"];
    [_activationCancelBtn setTarget:self];
    [_activationCancelBtn setAction:@selector(activationCancelViewBtn:)];
    [_activationCancelBtn setIsReslutVeiw:YES];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:str]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, str.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, str.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, str.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_activationCancelBtn setAttributedTitle:attributedTitles];

    
    NSString *str2 = CustomLocalizedString(@"Button_Ok", nil);
    [_activationOkBtn reSetInit:str2 WithPrefixImageName:@"pop"];
    [_activationOkBtn setTarget:self];
    [_activationOkBtn setAction:@selector(activationOKBtn:)];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:str2]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, str2.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, str2.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, str2.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_activationOkBtn setAttributedTitle:attributedTitles1];
    
    //加一个runloop
//    NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
//    NSInteger result1 = NSRunContinuesResponse;
//    while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
//    {
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    }
//    [NSApp endModalSession:session];
    result = _result;
    return result;
}

#pragma mark - Air Backup骚扰注册弹窗
- (int)showAlertActivationView:(NSView *)superView WithIsBackupNow:(BOOL)isBackupNow {
    [_activationBommotView setStringValue:@""];
    [_activationloginStr setStringValue:@""];
    _isBackupNow = isBackupNow;
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    [self loadAlertView:superView alertView:_activationView];
    [_textFieldView setIsRegistedTextView:YES];
    [_textFieldView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_activationloginStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    _endRunloop = NO;
    int result = -1;
    
    [_activationTitle setStringValue:CustomLocalizedString(@"annoy_id_1", nil)];
    [_activationTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_activationSubTitle setStringValue:[CustomLocalizedString(@"register_text_eg", nil) stringByAppendingString:@":"]];
    [_activationSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    NSString *str = CustomLocalizedString(@"Button_Cancel", nil);
    [_activationCancelBtn reSetInit:str WithPrefixImageName:@"cancal"];
    [_activationCancelBtn setTarget:self];
    [_activationCancelBtn setAction:@selector(activationCancelViewBtn:)];
    [_activationCancelBtn setIsReslutVeiw:YES];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:str]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, str.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, str.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, str.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_activationCancelBtn setAttributedTitle:attributedTitles];
    
    
    NSString *str2 = CustomLocalizedString(@"Button_Ok", nil);
    [_activationOkBtn reSetInit:str2 WithPrefixImageName:@"pop"];
    [_activationOkBtn setTarget:self];
    [_activationOkBtn setAction:@selector(activationOKBtn:)];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:str2]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, str2.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, str2.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, str2.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_activationOkBtn setAttributedTitle:attributedTitles1];
    NSModalSession session =  [NSApp beginModalSessionForWindow:self.view.window];
    NSInteger result1 = NSRunContinuesResponse;
    while ((result1 = [NSApp runModalSession:session]) == NSRunContinuesResponse&&!_endRunloop)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [NSApp endModalSession:session];
    result = _result;
    return result;
}

-(void)closeTrustView{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_trustView.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:456] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [_trustView.layer removeAnimationForKey:@"moveY"];
        [_trustView setFrame:NSMakeRect(ceil((NSMaxX(self.view.bounds) - _trustView.frame.size.width) / 2), NSMaxY(self.view.bounds), _trustView.frame.size.width, _trustView.frame.size.height)];
        [self.view removeFromSuperview];
    }];
}

- (void)activationOKBtn:(id)sender {
    [_activationBommotView setStringValue:@""];
    [_activationLoadingImageView setHidden:NO];
    [_activationLoadingImageView setWantsLayer:YES];
    [_activationLoadingImageView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_activationLoadingImageView setImage:[StringHelper imageNamed:@"registedLoading"]];
    [_activationLoadingImageView.layer addAnimation:[IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:-2*M_PI] durTimes:2.0] forKey:@"circularLayerRotation"];
    if ([_activationloginStr.stringValue isEqualToString:@""] || _activationloginStr.stringValue.length == 0) {
        [_activationLoadingImageView setHidden:YES];
        [_activationBommotView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)]];
        [_activationBommotView setStringValue:CustomLocalizedString(@"activate_error_discorrect", nil)];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            OperationLImitation *limit = [OperationLImitation singleton];
            if (limit.remainderCount <= 0) {
                [limit setLimitStatus:@"noquote"];
            }else {
                [limit setLimitStatus:@"completed"];
            }
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"Registration code is empty"] label:Register transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        return;
    }
    
    if (![_activationloginStr.stringValue contains:@"-"] || _activationloginStr.stringValue.length < 18) {
        [_activationLoadingImageView setHidden:YES];
        [_activationBommotView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)]];
        [_activationBommotView setStringValue:CustomLocalizedString(@"activate_error_discorrect", nil)];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            OperationLImitation *limit = [OperationLImitation singleton];
            if (limit.remainderCount <= 0) {
                [limit setLimitStatus:@"noquote"];
            }else {
                [limit setLimitStatus:@"completed"];
            }
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:False",_activationloginStr.stringValue] label:Register transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        return;
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (![TempHelper isInternetAvail]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_activationLoadingImageView setHidden:YES];
                [_activationBommotView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)]];
                [_activationBommotView setStringValue:CustomLocalizedString(@"activate_error_disinternet", nil)];
                NSDictionary *dimensionDict = nil;
                @autoreleasepool {
                    OperationLImitation *limit = [OperationLImitation singleton];
                    if (limit.remainderCount <= 0) {
                        [limit setLimitStatus:@"noquote"];
                    }else {
                        [limit setLimitStatus:@"completed"];
                    }
                    dimensionDict = [[TempHelper customDimension] copy];
                }
                [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:False",CustomLocalizedString(@"activate_error_disinternet", nil)] label:Register transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                if (dimensionDict) {
                    [dimensionDict release];
                    dimensionDict = nil;
                }
                return;
            });
        }
        IMBSoftWareInfo *software = [IMBSoftWareInfo singleton];
        [software setIsIllegal:NO];
        BOOL registerSuccess = [software registerSoftware:_activationloginStr.stringValue];
       dispatch_sync(dispatch_get_main_queue(), ^{
           if (registerSuccess) {
               NSDictionary *dimensionDict = nil;
               @autoreleasepool {
                   OperationLImitation *limit = [OperationLImitation singleton];
                   if (limit.remainderCount <= 0) {
                       [limit setLimitStatus:@"noquote"];
                   }else {
                       [limit setLimitStatus:@"completed"];
                   }
                   dimensionDict = [[TempHelper customDimension] copy];
               }
                [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:True",_activationloginStr.stringValue] label:Register transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
               if (dimensionDict) {
                   [dimensionDict release];
                   dimensionDict = nil;
               }
               if (_isBackupNow) {
                   _result = 2;
               } else {
                   _result = 1;
               }
               _endRunloop = YES;
               
               [self unloadAlertView:_activationView];
               if ([_delegate respondsToSelector:@selector(activateSuccess)]) {
                   [_delegate activateSuccess];
               }
               
           }else{
               if (software.isIllegal) {
                   NSString *str = [NSString stringWithFormat:CustomLocalizedString(@"https://www.imobie.com/landing/anytrans-official-xmas-offer.htm?%@", nil),[_activationloginStr.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""]];
                   NSURL *url = [NSURL URLWithString:str];
                   
                   NSWorkspace *ws = [NSWorkspace sharedWorkspace];
                   [ws openURL:url];
               }
               NSString *errorStr = @"";
               if (![TempHelper stringIsNilOrEmpty:software.rigisterErrorCode]) {
                   if ([software.rigisterErrorCode isEqualToString:@"002"]) {
                       errorStr = CustomLocalizedString(@"activate_error_expired", nil);
                   }else if ([software.rigisterErrorCode isEqualToString:@"003"]) {
                       errorStr = CustomLocalizedString(@"activate_error_overPC", nil);
                   }else if ([software.rigisterErrorCode isEqualToString:@"012"]) {
                       errorStr = CustomLocalizedString(@"activate_error_timeOutofPeriod", nil);
                   }else {
                       errorStr = [NSString stringWithFormat:CustomLocalizedString(@"activate_error_registerFailed", nil),[software.rigisterErrorCode intValue]];
                   }
               }else {
                   errorStr = [NSString stringWithFormat:CustomLocalizedString(@"activate_error_registerFailed", nil),-1];
               }
               NSDictionary *dimensionDict = nil;
               @autoreleasepool {
                   OperationLImitation *limit = [OperationLImitation singleton];
                   if (limit.remainderCount <= 0) {
                       [limit setLimitStatus:@"noquote"];
                   }else {
                       [limit setLimitStatus:@"completed"];
                   }
                   dimensionDict = [[TempHelper customDimension] copy];
               }
               [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:[NSString stringWithFormat:@"%@ register result:False",_activationloginStr.stringValue] label:Register transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
               if (dimensionDict) {
                   [dimensionDict release];
                   dimensionDict = nil;
               }
               [_activationLoadingImageView setHidden:YES];
               [_activationBommotView setStringValue:errorStr];
               [_activationBommotView setTextColor:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)]];
           }
        });
    });
  }
//activation  cancel 按钮
- (void)activationCancelViewBtn:(id)sender {
    _endRunloop = YES;
    _result = 0;
    [self unloadAlertView:_activationView];
}

//信任窗口按钮事件
- (void)trustViewBtn:(id)sender {
    _endRunloop = YES;
    _result = 1;
    [self closeTrustView];
    if (_delegate != nil && [_delegate respondsToSelector:@selector(trustBtnOperation:)]) {
        [_delegate trustBtnOperation:self];
    }
}

-(void)addPopBtn{
    NSMenuItem *itemDes7 = [[NSMenuItem alloc] init];
    [itemDes7 setTag:-202];
    
    [itemDes7 setTitle:@".csv"];
    [_settingSafariHistoryPopBtn.menu addItem:itemDes7];
    [itemDes7 release];
    NSMenuItem *itemPic7 = [[NSMenuItem alloc] init];
    [itemPic7 setTag:-201];
    [itemPic7 setTitle:@".html"];
    [_settingSafariHistoryPopBtn.menu addItem:itemPic7];
    [itemPic7 release];
    
    [_settingSafariHistoryPopBtn selectItemWithTitle:_exportSetting.safariHistoryType];
    NSMenuItem *itemPic4 = [[NSMenuItem alloc] init];
    [itemPic4 setTag:-201];
    [itemPic4 setTitle:@".csv"];
    [_settingContactPopBtn.menu addItem:itemPic4];
    [itemPic4 release];
    NSMenuItem *itemDes4 = [[NSMenuItem alloc] init];
    [itemDes4 setTag:-202];
    [itemDes4 setTitle:@".vcf"];
    [_settingContactPopBtn.menu addItem:itemDes4];
    [itemDes4 release];
    
    [_settingContactPopBtn selectItemWithTitle:_exportSetting.contactType];
    NSMenuItem *itemPic = [[NSMenuItem alloc] init];
    [itemPic setTag:-201];
    [itemPic setTitle:@".html"];
    [_settingCallHistoryPopBtn.menu addItem:itemPic];
    [itemPic release];
    NSMenuItem *itemDes = [[NSMenuItem alloc] init];
    [itemDes setTag:-202];
    [itemDes setTitle:@".text"];
    [_settingCallHistoryPopBtn.menu addItem:itemDes];
    [itemDes release];
    
    [_settingCallHistoryPopBtn selectItemWithTitle:_exportSetting.callHistoryType];
    
    NSMenuItem *itemPic5 = [[NSMenuItem alloc] init];
    [itemPic5 setTag:-201];
    [itemPic5 setTitle:@".csv"];
    [_settingCalendarPopBtn.menu addItem:itemPic5];
    [itemPic5 release];
    NSMenuItem *itemDes5 = [[NSMenuItem alloc] init];
    [itemDes5 setTag:-202];
    [itemDes5 setTitle:@".text"];
    [_settingCalendarPopBtn.menu addItem:itemDes5];
    [itemDes5 release];
    
    [_settingCalendarPopBtn selectItemWithTitle:_exportSetting.calenderType];
    
    NSMenuItem *itemPic1 = [[NSMenuItem alloc] init];
    [itemPic1 setTag:-201];
    [itemPic1 setTitle:@".html"];
    [_settingMessagePopBtn.menu addItem:itemPic1];
    [itemPic1 release];
    NSMenuItem *itemDes1 = [[NSMenuItem alloc] init];
    [itemDes1 setTag:-202];
    [itemDes1 setTitle:@".text"];
    [_settingMessagePopBtn.menu addItem:itemDes1];
    [itemDes1 release];
    NSMenuItem *itemPdf1 = [[NSMenuItem alloc] init];
    [itemPdf1 setTag:-203];
    [itemPdf1 setTitle:@".pdf"];
    [_settingMessagePopBtn.menu addItem:itemPdf1];
    [itemPdf1 release];
    
    [_settingMessagePopBtn selectItemWithTitle:_exportSetting.messageType];
    
    NSMenuItem *itemfdf6 = [[NSMenuItem alloc] init];
    [itemfdf6 setTag:-203];
    [itemfdf6 setTitle:@".html"];
    [_settingNotePopBtn.menu addItem:itemfdf6];
    [itemfdf6 release];
    NSMenuItem *itemPic6 = [[NSMenuItem alloc] init];
    [itemPic6 setTag:-201];
    [itemPic6 setTitle:@".csv"];
    [_settingNotePopBtn.menu addItem:itemPic6];
    [itemPic6 release];
    NSMenuItem *itemDes6 = [[NSMenuItem alloc] init];
    [itemDes6 setTag:-202];
    [itemDes6 setTitle:@".text"];
    [_settingNotePopBtn.menu addItem:itemDes6];
    [itemDes6 release];
    [_settingNotePopBtn selectItemWithTitle:_exportSetting.notesType];
    
    NSMenuItem *itemPic3 = [[NSMenuItem alloc] init];
    [itemPic3 setTag:-201];
    [itemPic3 setTitle:@".html"];
    [_settingSafariBookmarkPopBtn.menu addItem:itemPic3];
    [itemPic3 release];
    NSMenuItem *itemDes3 = [[NSMenuItem alloc] init];
    [itemDes3 setTag:-202];
    [itemDes3 setTitle:@".csv"];
    [_settingSafariBookmarkPopBtn.menu addItem:itemDes3];
    [itemDes3 release];
    [_settingSafariBookmarkPopBtn selectItemWithTitle:_exportSetting.safariType];
    
    NSMenuItem *itemReminder1 = [[NSMenuItem alloc] init];
    [itemReminder1 setTag:-201];
    [itemReminder1 setTitle:@".csv"];
    [_settingReminderPopBtn.menu addItem:itemReminder1];
    [itemReminder1 release];
    NSMenuItem *itemReminder2 = [[NSMenuItem alloc] init];
    [itemReminder2 setTag:-202];
    [itemReminder2 setTitle:@".text"];
    [_settingReminderPopBtn.menu addItem:itemReminder2];
    [itemReminder2 release];
    [_settingReminderPopBtn selectItemWithTitle:_exportSetting.reminderType];
}

- (void)removePopBtn {
    [_settingSafariBookmarkPopBtn removeAllItems];
    [_settingSafariHistoryPopBtn removeAllItems];
    [_settingReminderPopBtn removeAllItems];
    [_settingNotePopBtn removeAllItems];
    [_settingMessagePopBtn removeAllItems];
    [_settingContactPopBtn removeAllItems];
    [_settingCallHistoryPopBtn removeAllItems];
    [_settingCalendarPopBtn removeAllItems];
}

- (void)exportBtnDown:(id)sender{
    _openPanel = [NSOpenPanel openPanel];
    _isOpen = YES;
    //设置默认的路径
    [_openPanel setDirectory:_settingPathStr.stringValue];
    [_openPanel setAllowsMultipleSelection:NO];
    [_openPanel setCanChooseFiles:NO];
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result== NSFileHandlingPanelOKButton) {
            NSString * path =[[_openPanel URL] path];
            _exportSetting.exportPath = path;
            [_settingPathStr setStringValue:path];
        }else{
            NSLog(@"other other other");
        }
        _isOpen = NO;
        [_settingPathStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [_settingPathStr setWantsLayer:YES];
    }];
}

- (void)backBtnDown:(id)sender{
    _openPanel = [NSOpenPanel openPanel];
    _isOpen = YES;
    //设置默认的路径
    [_openPanel setDirectory:_settingbackPathStr.stringValue];
    [_openPanel setAllowsMultipleSelection:NO];
    [_openPanel setCanChooseFiles:NO];
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result== NSFileHandlingPanelOKButton) {
            NSString * path =[[_openPanel URL] path];
//            [dic setObject:path forKey:EXPORT_BACKUPPATH_CATEGORY];
            _exportSetting.backupPath = path;
            //            [_exportConfig.settingDic setObject:path forKey:EXPORT_BACKUPPATH_CATEGORY];
            [_settingbackPathStr setStringValue:path];
        }else{
            NSLog(@"other other other");
        }
        _isOpen = NO;
        [_settingbackPathStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [_settingbackPathStr setWantsLayer:YES];
    }];
}

//设置界面pop按钮
- (IBAction)popDownBtn:(id)sender {
    NSPopUpButton *btn = (NSPopUpButton *)sender;
    NSMenuItem *item = [btn selectedItem];
    if (btn.tag == 1) {//safariHistoryType
        if (item.tag == -201) {
            // .html
            _exportSetting.safariHistoryType = @".html";
        }else{
            //   .text
            _exportSetting.safariHistoryType = @".csv";
        }
    }else if (btn.tag == 2){//contact
        if (item.tag == -201) {
            //.csv
            _exportSetting.contactType = @".csv";
        }else{
            //.vcf
             _exportSetting.contactType = @".vcf";
        }
    }else if (btn.tag == 3){//callHistory
        if (item.tag == -201) {
            //.html
            _exportSetting.callHistoryType = @".html";
        }else{
            //.text
            _exportSetting.callHistoryType = @".text";
        }
    }else if (btn.tag == 4){//calendar
        if (item.tag == -201) {
            //.csv
            _exportSetting.calenderType = @".csv";
        }else{
            //.text
            _exportSetting.calenderType = @".text";
        }
    }else if (btn.tag == 5){//messageType
        if (item.tag == -201) {
            // .csv
            _exportSetting.messageType = @".html";
        }else if (item.tag == -203) {
            // .pdf
            _exportSetting.messageType = @".pdf";
        }else{
            //.text
            _exportSetting.messageType = @".text";
        }
    }else if (btn.tag == 6){//note
        if (item.tag == -201) {
            //.csv
            _exportSetting.notesType = @".csv";
        }else if (item.tag == -202){
            //.text
            _exportSetting.notesType = @".text";
        }else{
            //.html
            _exportSetting.notesType = @".html";
        }
    }else if (btn.tag == 7){//safaribookmark
        if (item.tag == -201) {
            //.html
            _exportSetting.safariType = @".html";
        }else{
            //.csv
            _exportSetting.safariType = @".csv";
        }
    }else if (btn.tag == 8) {
        if (item.tag == -201) {
            //.csv
            _exportSetting.reminderType = @".csv";
        }else{
            //.text
            _exportSetting.reminderType = @".text";
        }
    }
}
//设置界面取消按钮
- (void)settingViewCancelBtn:(id)sender{
    [self closeSettingViewCloseOperation];
}
//设置界面保存按钮
- (void)saveBtnOperation:(id)sender{
    if (_photoCheckBtn.state){
        [IMBSoftWareInfo singleton].isKeepPhotoDate = YES;
    }else {
        [IMBSoftWareInfo singleton].isKeepPhotoDate = NO;
    }
    [_exportSetting saveToDeviceOrLocal];
    [self closeSettingViewCloseOperation];
}
//关闭closeIcloud 页面动画
- (void)closeSettingViewCloseOperation{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect =NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _settingView.frame.size.width) / 2), self.view.frame.size.height, _settingView.frame.size.width, _settingView.frame.size.height);
        
        [context setDuration:0.3];
        [[_settingView animator] setFrame:rect];
    } completionHandler:^{
        [_settingView removeFromSuperview];
        [self.view removeFromSuperview];
    }];
}
//关闭closeIcloud 动画
- (void)closeViewCloseOperation:(id)sender{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect =NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _icloudCloseView.frame.size.width) / 2), self.view.frame.size.height, _icloudCloseView.frame.size.width, _icloudCloseView.frame.size.height);
        
        [context setDuration:0.3];
        [[_icloudCloseView animator] setFrame:rect];
    } completionHandler:^{
        [_icloudCloseView removeFromSuperview];
        [self.view removeFromSuperview];
    }];
}

- (void)OkBtnClick:(id)sender {
    IMBGeneralButton *btn = (IMBGeneralButton *)sender;
    _endRunloop = YES;
    _result = 1;
    if (btn.tag == 1) {
        [_reNameOkBtn setEnabled:NO];
        [_reNameCancelBtn setEnabled:NO];
//       [self unloadAlertView:_reNameView];
    }else if (btn.tag == 2) {
        [self unloadAlertView:_addEditBookMarkView];
    }else if (btn.tag == 3) {
        [self unloadAlertView:_addCustomLableView];
    }
}

- (void)cancelBtnClick:(id)sender {
    IMBGeneralButton *btn = (IMBGeneralButton *)sender;
    _endRunloop = YES;
    _result = 0;
    if (btn.tag == 1) {
        [self unloadAlertView:_reNameView];
    }else if (btn.tag == 2) {
        [self unloadAlertView:_addEditBookMarkView];
    }else if (btn.tag == 3) {
        [self unloadAlertView:_addCustomLableView];
    }
}

- (void)okBtnOperation:(id)sender {
    _endRunloop = YES;
    _result = 1;
    [self unloadAlertView:_warningAlertView];
    if (_delegate != nil && [_delegate respondsToSelector:@selector(secireOkBtnOperation:with:)]) {
        [_delegate doOkBtnOperation:sender];
    }else if (_delegate != nil && [_delegate respondsToSelector:@selector(doOkBtnOperation:)]) {
        [_delegate doOkBtnOperation:sender];
    }
}

- (void)cancleNoDataLoadingViewOperation:(id)sender {
    _endRunloop = YES;
    _result = 1;
    [self unloadAlertView:_onDataLoadingView];
}
//界面页面回车
- (IBAction)entersigin:(id)sender {
    [_unLockBackUpPassTitleStr setEditable:NO];
    [_unLockBackUpCancleBtn setEnabled:NO];
    [_unLockBackUpOkBtn setEnabled:NO];
    [_unLockBackUpLandingstatusTitleStr setHidden:YES];
//    NSString *str = [_unLockBackUpPassTitleStr.cell stringValue];//_secireTextField.stringValue;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ITUNES_ENTER_SIGNIN object:nil userInfo:nil];
    if (_delegate != nil && [_delegate respondsToSelector:@selector(secireOkBtnOperation:with:)]) {
        [_delegate secireOkBtnOperation:self with:_iTunesPassString];
    }
    //    [self signDown:sender];
}

//解密失败 重新输入 要隐藏失败提示语
-(void)repypass:(NSNotification *)obj{
    _iTunesPassString = obj.object;
    [_unLockBackUpLandingstatusTitleStr setHidden:YES];
}

//解密窗口ok按钮事件
- (IBAction)secireOkBtn:(id)sender {
    if ([IMBHelper stringIsNilOrEmpty:_iTunesPassString])
        return;
    [_unLockBackUpPassTitleStr setEditable:NO];
    [_unLockBackUpCancleBtn setEnabled:NO];
    [_unLockBackUpOkBtn setEnabled:NO];
    [_unLockBackUpLandingstatusTitleStr setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ITUNES_SIGNINBTN_DOWN object:self userInfo:nil];
//    NSString *str = [_unLockBackUpPassTitleStr.cell stringValue];//_secireTextField.stringValue;

    if (_delegate != nil && [_delegate respondsToSelector:@selector(secireOkBtnOperation:with:)]) {
        [_delegate secireOkBtnOperation:self with:_iTunesPassString];
    }
}

-(void)successPass:(NSNotification *)obj{
    dispatch_async(dispatch_get_main_queue(), ^{
        _result = 1;
        _endRunloop = YES;
        [_unLockBackUpPassTitleStr setEditable:YES];
        [_unLockBackUpLandingstatusTitleStr setHidden:NO];
        [_unLockBackUpLandingstatusTitleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)]];
        [_unLockBackUpPassTitleStr setStringValue:@""];
        [_unLockBackUpCancleBtn setEnabled:YES];
        [_unLockBackUpOkBtn setEnabled:YES];
        [self unloadAlertView:_unLockBackUpPassView];
    });
}

-(void)siginFail:(NSNotification *)obj{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_unLockBackUpPassTitleStr setEditable:YES];
        [_unLockBackUpLandingstatusTitleStr setHidden:NO];
        [_unLockBackUpLandingstatusTitleStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)]];
        [_unLockBackUpCancleBtn setEnabled:YES];
        [_unLockBackUpOkBtn setEnabled:YES];
    });
}

- (IBAction)secireCancelBtnDown:(id)sender {
    _endRunloop = YES;
    _result = 0;
    [self unloadAlertView:_unLockBackUpPassView];
}

- (IBAction)guideURL:(id)sender {
    //to long 9.4 改链接
    NSString *hoStr = CustomLocalizedString(@"url_guild_id_1", nil);
    NSURL *url = [NSURL URLWithString:hoStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
    [_iCloudToURLGuideBtn setNeedsDisplay:YES];
}

- (void)changBtnState {
    if (_reNameInputTextField.stringValue.length == 0 || _reNameInputTextField.stringValue == nil) {
        [_reNameOkBtn setEnabled:NO];
    }else {
        [_reNameOkBtn setEnabled:YES];
    }
    
    if (_addEditBookMarkTitleInputTextFiled.stringValue.length == 0 || _addEditBookMarkURLInputTextFiled.stringValue.length == 0) {
        [_addEditBookMarkOkBtn setEnabled:NO];
    }else {
        [_addEditBookMarkOkBtn setEnabled:YES];
    }
    
    if (_addCustomLableInputTextFiled.stringValue.length == 0) {
        [_addCustomLableOkBtn setEnabled:NO];
    }else {
        [_addCustomLableOkBtn setEnabled:YES];
    }
    
}

-(void)removeItemSuccessShowCountText:(int )count{
    NSString *selectCountStr = nil;
    if (count >1) {
        selectCountStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Delete_Complete_Description_ComPlex", nil),count];
    }else{
        selectCountStr = [NSString stringWithFormat:CustomLocalizedString(@"MSG_COM_Delete_Complete_Description", nil),count];
    }

    NSString *promptStr = @"";
    NSString *overStr =[NSString stringWithFormat:@"%d",count];
    promptStr = selectCountStr;
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [promptStr rangeOfString:overStr];
    [promptAs addAttribute:NSLinkAttributeName value:overStr range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSLeftTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [_removeprogressSuccessViewSubTitle  setAttributedStringValue:promptAs];
    [mutParaStyle release];
    mutParaStyle = nil;
}

- (void)inputCode {
    if (_activationloginStr.stringValue.length > 30) {
        _activationloginStr.stringValue = [_activationloginStr.stringValue substringToIndex:30];
    }
}

- (void)closeOpenPanel:(NSNotification *)noti {
    if ( _iPod != nil &&  [noti.object isEqualToString:_iPod.uniqueKey] && _openPanel != nil && _isOpen ) {
        [_openPanel cancel:nil];
        _openPanel = nil;
    }
    [self closeSettingViewCloseOperation];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _ringtoneSettingView.frame.size.width) / 2), self.view.frame.size.height, _ringtoneSettingView.frame.size.width, _ringtoneSettingView.frame.size.height);
        
        [context setDuration:0.3];
        [[_ringtoneSettingView animator] setFrame:rect];
    } completionHandler:^{
        [_ringtoneSettingView removeFromSuperview];
        [self.view removeFromSuperview];
    }];
}

#pragma mark - iCloudOpenView
- (void)showiCloudOpenViewWithSuperView:(NSView *)superView {
    NSView *bView = superView;
    [bView addSubview:self.view];
    [self.view setWantsLayer:YES];
    [self.view setFrameSize:superView.frame.size];
    [self.view addSubview:_iCloudOpenView];
    [_iCloudOpenView setFrame:NSMakeRect(superView.frame.origin.x + floor((superView.frame.size.width - _iCloudOpenView.frame.size.width) / 2), superView.frame.size.height, _iCloudOpenView.frame.size.width, _iCloudOpenView.frame.size.height)];
    [self.view setWantsLayer:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(bView.frame.origin.x + floor((bView.frame.size.width - _iCloudOpenView.frame.size.width) / 2), bView.frame.size.height - _iCloudOpenView.frame.size.height + 8, _iCloudOpenView.frame.size.width, _iCloudOpenView.frame.size.height);
        [context setDuration:0.3];
        [[_iCloudOpenView animator] setFrame:rect];
    } completionHandler:^{
        [self.view setWantsLayer:YES];
    }];
    
    [_iCloudOpenView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_iCloudOpenMainTitle setStringValue:CustomLocalizedString(@"InitCloud_account_title", nil)];
    [_openPromptStr1 setStringValue:CustomLocalizedString(@"CloseiCloud_id_3", nil)];
    [_openPromptStr2 setStringValue:CustomLocalizedString(@"CloseiCloud_id_4", nil)];
    [_openPromptStr3 setStringValue:CustomLocalizedString(@"InitCloud_account_item_content", nil)];
    if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        [_PromptNumber1 setStringValue:@"3."];
        [_PromptNumber2 setStringValue:@"2."];
        [_PromptNumber3 setStringValue:@"1."];
    } else {
        [_PromptNumber1 setStringValue:@"1."];
        [_PromptNumber2 setStringValue:@"2."];
        [_PromptNumber3 setStringValue:@"3."];
    }
    
    [_openPromptImageView1 setImage:[StringHelper imageNamed:@"step1"]];
    [_openPromptImageView2 setImage:[StringHelper imageNamed:@"step2_new"]];
    [_openPromptImageView3 setImage:[StringHelper imageNamed:@"step3"]];
    
    
    [_PromptNumber1 setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_PromptNumber2 setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_PromptNumber3 setTextColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    
    [_openPromptStr1 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_openPromptStr2 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_openPromptStr3 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_iCloudOpenMainTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    //配置按钮
    [_highVersionBtn setButtonTitle:CustomLocalizedString(@"InitCloud_account_new",nil)];
    [_lowVersionBtn setButtonTitle:CustomLocalizedString(@"InitCloud_account_old",nil)];
    [_highVersionBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_highVersionBtn setFontColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_highVersionBtn setFontEnterColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_highVersionBtn setFontDownColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    _highVersionBtn.isAlertView = YES;
    [_highVersionBtn setTarget:self];
    [_highVersionBtn setEnabled:NO];
    [_highVersionBtn setAction:@selector(changeHighVersionPhoto)];
    
    [_lowVersionBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_lowVersionBtn setFontColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_lowVersionBtn setFontEnterColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_lowVersionBtn setFontDownColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    _lowVersionBtn.isAlertView = YES;
    [_lowVersionBtn setTarget:self];
    [_lowVersionBtn setEnabled:YES];
    [_lowVersionBtn setAction:@selector(changeLowVersionPhoto)];
    
    
    NSString *okBtnStr = CustomLocalizedString(@"TrustView_id_2", nil);
    [_iCloudOpenBtn reSetInit:okBtnStr WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okBtnStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_iCloudOpenBtn setAttributedTitle:attributedTitles];
    [_iCloudOpenBtn setTarget:self];
    [_iCloudOpenBtn setAction:@selector(closeiCloudOpenViewOperation:)];
    
}

//关闭 iCloudOpenView
- (void)closeiCloudOpenViewOperation:(id)sender{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect =NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _iCloudOpenView.frame.size.width) / 2), self.view.frame.size.height, _iCloudOpenView.frame.size.width, _iCloudOpenView.frame.size.height);
        
        [context setDuration:0.3];
        [[_iCloudOpenView animator] setFrame:rect];
    } completionHandler:^{
        [_iCloudOpenView removeFromSuperview];
        [self.view removeFromSuperview];
    }];
}

#pragma mark - 10.0及以上 与 10.0以下的图片切换
- (void)changeHighVersionPhoto {
    [_openPromptImageView2 setImage:[StringHelper imageNamed:@"step2_new"]];
    [_highVersionBtn setButtonTitle:CustomLocalizedString(@"InitCloud_account_new",nil)];
    [_lowVersionBtn setButtonTitle:CustomLocalizedString(@"InitCloud_account_old",nil)];
    [_highVersionBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_highVersionBtn setFontColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_highVersionBtn setFontEnterColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_highVersionBtn setFontDownColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    _highVersionBtn.isAlertView = YES;
    [_highVersionBtn setNeedsDisplay:YES];
    
    [_lowVersionBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_lowVersionBtn setFontColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_lowVersionBtn setFontEnterColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_lowVersionBtn setFontDownColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    _lowVersionBtn.isAlertView = YES;
    [_lowVersionBtn setTarget:self];
    [_lowVersionBtn setEnabled:YES];
    [_lowVersionBtn setAction:@selector(changeLowVersionPhoto)];
    [_lowVersionBtn setNeedsDisplay:YES];
    [_iCloudOpenView setNeedsDisplay:YES];
}

- (void)changeLowVersionPhoto {
    
    [_openPromptImageView2 setImage:[StringHelper imageNamed:@"step2_old"]];
    
    [_highVersionBtn setButtonTitle:CustomLocalizedString(@"InitCloud_account_new",nil)];
    [_highVersionBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_highVersionBtn setFontColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_highVersionBtn setFontEnterColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    [_highVersionBtn setFontDownColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)]];
    _highVersionBtn.isAlertView = YES;
    [_highVersionBtn setTarget:self];
    [_highVersionBtn setEnabled:YES];
    [_highVersionBtn setAction:@selector(changeHighVersionPhoto)];
    [_highVersionBtn setNeedsDisplay:YES];
    
    [_lowVersionBtn setButtonTitle:CustomLocalizedString(@"InitCloud_account_old",nil)];
    [_lowVersionBtn setFont:[NSFont fontWithName:@"Helvetica Neue" size:14.0]];
    [_lowVersionBtn setFontColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_lowVersionBtn setFontEnterColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    [_lowVersionBtn setFontDownColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    _lowVersionBtn.isAlertView = YES;
    [_lowVersionBtn setNeedsDisplay:YES];
    [_iCloudOpenView setNeedsDisplay:YES];
    
}

#pragma mark - Airbackup 高级设置弹窗
- (void)showAirBackupSettingAlertViewWithSuperView:(NSView *)superView WithDelegete:(id)delegete {
    NSString *str = @"close";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    _delegate = delegete;
    NSView *bView = superView;
    [bView addSubview:self.view];
    [self.view setWantsLayer:YES];
    [self.view setFrameSize:superView.frame.size];
    [self.view addSubview:_airBackupSettingAlertView];
    [_airBackupSettingAlertView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_airBackupSettingAlertView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_airBackupSettingAlertView setFrame:NSMakeRect(superView.frame.origin.x + floor((superView.frame.size.width - _airBackupSettingAlertView.frame.size.width) / 2), superView.frame.size.height, _airBackupSettingAlertView.frame.size.width, _airBackupSettingAlertView.frame.size.height)];
    [self.view setWantsLayer:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(bView.frame.origin.x + floor((bView.frame.size.width - _airBackupSettingAlertView.frame.size.width) / 2), bView.frame.size.height - _airBackupSettingAlertView.frame.size.height + 14, _airBackupSettingAlertView.frame.size.width, _airBackupSettingAlertView.frame.size.height);
        [context setDuration:0.4];
        [[_airBackupSettingAlertView animator] setFrame:rect];
    } completionHandler:^{
        [self.view setWantsLayer:YES];
    }];
    
    _dataArr = [[NSMutableArray alloc] init];
    [self readConfigFile];
    //配置文字及颜色
    [_airBackupSettingAlertTitle setStringValue:CustomLocalizedString(@"AirBackupSettingAlert_Title", nil)];
    [_airBackupSettingAlertSubTitle1 setStringValue:CustomLocalizedString(@"AirBackupSettingAlert_SubTitle1", nil)];
    [_airBackupSettingAlertSubTitle2 setStringValue:CustomLocalizedString(@"SettingView_id_10", nil)];
    [_airBackupSettingAlertSubTitle3 setStringValue:CustomLocalizedString(@"AirBackupSettingAlert_SubTitle2", nil)];
    [_airBackupSettingAlertSubTitle4 setStringValue:CustomLocalizedString(@"AirBackupSettingAlert_SubTitle3", nil)];
    [_airBackupSettingAlertSubTitle5 setStringValue:CustomLocalizedString(@"AirBackupSettingFrogetDevice", nil)];
    [_airBackupSettingAlertSubTitle6 setStringValue:CustomLocalizedString(@"AirBackupSettingAlert_BackMediaPhoto", nil)];
    
    [_airBackupSettingAlertONStr setStringValue:CustomLocalizedString(@"AirBackupWiFiState_ON", nil)];
    [_airBackupSettingAlertOFFStr setStringValue:CustomLocalizedString(@"AirBackupWiFiState_OFF", nil)];
    
    if (![StringHelper stringIsNilOrEmpty:_backupPath]) {
        [_airBackupSettingAlertPathText setStringValue:_backupPath];
    } else {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *path = [[[manager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] objectAtIndex:0] path];
        NSString *backPath = [[path stringByAppendingPathComponent:@"MobileSync"] stringByAppendingPathComponent:@"Backup"];
        [_airBackupSettingAlertPathText setStringValue:backPath];
    }
    
    [_airBackupSettingAlertTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_airBackupSettingAlertSubTitle1 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_airBackupSettingAlertSubTitle2 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_airBackupSettingAlertSubTitle3 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_airBackupSettingAlertSubTitle4 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_airBackupSettingAlertSubTitle5 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_airBackupSettingAlertSubTitle6 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_airBackupSettingAlertONStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_airBackupSettingAlertOFFStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    
    //备份路径
    [_airBackupSettingAlertPathBorderView setIsHaveCorner:YES];
    [_airBackupSettingAlertPathBorderView setBorderColor:[StringHelper getColorFromString:CustomColor(@"airWifi_popBtn_line_Color", nil)]];
    [_airBackupSettingAlertPathText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    [_topLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"airWifi_popBtn_line_Color", nil)]];
    [_bottomLineView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"airWifi_popBtn_line_Color", nil)]];
    
    //switch 按钮
    [_airBackupSettingAlertSwitchBtn setTarget:self];
    [_airBackupSettingAlertSwitchBtn setAction:@selector(switchButtonClick)];
    
    //change按钮
    NSString *changeStr = CustomLocalizedString(@"AirBackupSettingAlert_ChangeBtn", nil);
    [_airBackupSettingAlertChangeBtn reSetInit:changeStr WithPrefixImageName:@"select_path"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:changeStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, changeStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, changeStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, changeStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_airBackupSettingAlertChangeBtn setAttributedTitle:attributedTitles];
    [_airBackupSettingAlertChangeBtn setFontSize:12.0];
    [_airBackupSettingAlertChangeBtn setTarget:self];
    [_airBackupSettingAlertChangeBtn setAction:@selector(changeButtonClick)];
    
    //低电量popbutton
    [self configPopButtonWithBatteryStr:[NSString stringWithFormat:@"%d",_lowBatteryStr] WithPopButton:_airBackupSettingAlertBatteryPopBtn1 WithIsLowBattery:YES];
    [_airBackupSettingAlertBatteryPopBtn1 setNeedsDisplay:YES];
    
    //高电量popButton
    [self configPopButtonWithBatteryStr:[NSString stringWithFormat:@"%d",_highBatteryStr] WithPopButton:_airBackupSettingAlertBatteryPopBtn2 WithIsLowBattery:NO];
    [_airBackupSettingAlertBatteryPopBtn2 setNeedsDisplay:YES];
    
    //是否备份photo 和 media
    [_airBackupSettingAlertTurnPopBtn setHasMinWidth:YES];
    [_airBackupSettingAlertTurnPopBtn setMinWidth:112];
    [_airBackupSettingAlertTurnPopBtn setBtnHeight:24];
    [_airBackupSettingAlertTurnPopBtn setTitleSpaceWidth:20];
    [_airBackupSettingAlertTurnPopBtn setArrowSpace:8];
    [_airBackupSettingAlertTurnPopBtn setIsAlertView:YES];
    [_airBackupSettingAlertTurnPopBtn setTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_airBackupSettingAlertTurnPopBtn setFontSize:12.0];
    [_airBackupSettingAlertTurnPopBtn setArrowImage:[StringHelper imageNamed:@"arrow"]];
    [_airBackupSettingAlertTurnPopBtn setHasBorder:YES];
    [_airBackupSettingAlertTurnPopBtn.menu removeAllItems];
    NSMenuItem *proItem1 = [[NSMenuItem alloc] init];
    [proItem1 setTitle:CustomLocalizedString(@"AirBackupPhotoMedia_ON", nil)];
    [proItem1 setState:NSOffState];
    [proItem1 setTag:501];
    [proItem1 setTarget:self];
    [proItem1 setAction:@selector(changePhotoAndMediaIsBackup)];
    [_airBackupSettingAlertTurnPopBtn.menu addItem:proItem1];
    
    NSMenuItem *proItem2 = [[NSMenuItem alloc] init];
    [proItem2 setTitle:CustomLocalizedString(@"AirBackupPhotoMedia_Off", nil)];
    [proItem2 setState:NSOffState];
    [proItem2 setTag:502];
    [proItem2 setTarget:self];
    [proItem2 setAction:@selector(changePhotoAndMediaIsBackup)];
    [_airBackupSettingAlertTurnPopBtn.menu addItem:proItem2];
    
    if (_photoMediaCanBackup) {
        [proItem1 setState:NSOnState];
        [_airBackupSettingAlertTurnPopBtn selectItem:proItem1];
        [_airBackupSettingAlertTurnPopBtn setTitle:proItem1.title];
    } else {
        [proItem2 setState:NSOnState];
        [_airBackupSettingAlertTurnPopBtn selectItem:proItem2];
        [_airBackupSettingAlertTurnPopBtn setTitle:proItem2.title];
    }
    [proItem1 release];
    [proItem2 release];
    
    if ([_airBackupSettingAlertBatteryPopBtn1.title isEqualToString:CustomLocalizedString(@"AirBackupBatteery_Never", nil)]) {
        [_airBackupSettingAlertPromptStr1 setStringValue:CustomLocalizedString(@"AirBackupSettingAlert_SubTitle2_Never", nil)];
    } else {
        [_airBackupSettingAlertPromptStr1 setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"AirBackupSettingAlert_SubTitle2_1", nil),_airBackupSettingAlertBatteryPopBtn1.title]];
    }
    
    [_airBackupSettingAlertPromptStr2 setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"AirBackupSettingAlert_SubTitle3_1", nil),_airBackupSettingAlertBatteryPopBtn2.title]];
    [_airBackupSettingAlertPromptStr1 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_airBackupSettingAlertPromptStr2 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    //保存按钮
    NSString *okBtnStr = CustomLocalizedString(@"Calendar_id_9", nil);
    [_airBackupSettingAlertSaveBtn reSetInit:okBtnStr WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles2 = [[[NSMutableAttributedString alloc]initWithString:okBtnStr]autorelease];
    [attributedTitles2 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles2.length)];
    [_airBackupSettingAlertSaveBtn setAttributedTitle:attributedTitles2];
    [_airBackupSettingAlertSaveBtn setFontSize:12.0];
    [_airBackupSettingAlertSaveBtn setTarget:self];
    [_airBackupSettingAlertSaveBtn setAction:@selector(closeAndSaveConfigAirBackupAlertView)];
    
    //取消按钮
    NSString *cancelStr = CustomLocalizedString(@"Button_Cancel", nil);
    [_airBackupSettingAlertCacelBtn reSetInit:cancelStr WithPrefixImageName:@"cancal"];
    [_airBackupSettingAlertCacelBtn setFontSize:12];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:cancelStr]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_airBackupSettingAlertCacelBtn setAttributedTitle:attributedTitles1];
    [_airBackupSettingAlertCacelBtn setIsReslutVeiw:YES];
    [_airBackupSettingAlertCacelBtn setFontSize:12.0];
    [_airBackupSettingAlertCacelBtn setTarget:self];
    [_airBackupSettingAlertCacelBtn setAction:@selector(closeAirBackupAlerView)];
    [_airBackupSettingAlertCacelBtn setNeedsDisplay:YES];
    
    //已缓存设备列表
    [_airBackupSettingAlertDeviceInfoView setBackgroundColor:[NSColor clearColor]];
    [_airBackupSettingAlertDeviceInfoView setHasCorner:YES];
    
    [_airBackupSettingAlertScrollView setDrawsBackground:YES];
    [_airBackupSettingAlertScrollView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [self setAirBackupSettingViewFrame];
    [self loadDeviceInfoListView];
    
}

#pragma mark - 计算文字长短设置界面显示
- (void)setAirBackupSettingViewFrame {
    NSRect rect1;
    NSRect rect2;
    NSRect rect3;
    NSRect rect4;
    rect1 = [StringHelper calcuTextBounds:_airBackupSettingAlertPromptStr1.stringValue fontSize:12.0];
    rect2 = [StringHelper calcuTextBounds:_airBackupSettingAlertPromptStr2.stringValue fontSize:12.0];
    rect3 = [StringHelper calcuTextBounds:_airBackupSettingAlertOFFStr.stringValue fontSize:14.0];
    rect4 = [StringHelper calcuTextBounds:_airBackupSettingAlertONStr.stringValue fontSize:14.0];
    [_airBackupSettingAlertOFFStr setFrame:NSMakeRect(_airBackupSettingAlertOFFStr.frame.origin.x, 430 + 2, rect3.size.width + 2, rect3.size.height)];
    [_airBackupSettingAlertSwitchBtn setFrame:NSMakeRect(_airBackupSettingAlertOFFStr.frame.origin.x + _airBackupSettingAlertOFFStr.frame.size.width + 4, _airBackupSettingAlertSwitchBtn.frame.origin.y, _airBackupSettingAlertSwitchBtn.frame.size.width, _airBackupSettingAlertSwitchBtn.frame.size.height)];
    [_airBackupSettingAlertONStr setFrame:NSMakeRect(_airBackupSettingAlertSwitchBtn.frame.origin.x + _airBackupSettingAlertSwitchBtn.frame.size.width + 4, 430 + 2, rect4.size.width + 2, rect4.size.height)];
    
    if (rect1.size.width >= 300 && rect2.size.width >= 300) {
        
        [_airBackupSettingAlertSubTitle4 setFrameOrigin:NSMakePoint(_airBackupSettingAlertSubTitle4.frame.origin.x, 289 - HEIGHT1)];
        [_airBackupSettingAlertBatteryPopBtn2 setFrameOrigin:NSMakePoint(_airBackupSettingAlertBatteryPopBtn2.frame.origin.x, 283 - HEIGHT1)];
        [_airBackupSettingAlertPromptStr2 setFrameOrigin:NSMakePoint(_airBackupSettingAlertPromptStr2.frame.origin.x, 241 - HEIGHT1)];
        [_airBackupSettingAlertSubTitle6 setFrameOrigin:NSMakePoint(_airBackupSettingAlertSubTitle6.frame.origin.x, 225 - HEIGHT2)];
        [_airBackupSettingAlertTurnPopBtn setFrameOrigin:NSMakePoint(_airBackupSettingAlertTurnPopBtn.frame.origin.x, 219 - HEIGHT2)];
        [_airBackupSettingAlertSubTitle5 setFrameOrigin:NSMakePoint(_airBackupSettingAlertSubTitle5.frame.origin.x, 182 - HEIGHT2)];
        [_airBackupSettingAlertDeviceInfoView setFrame:NSMakeRect(272, 73, 280, 124 - HEIGHT2)];
        [_airBackupSettingAlertScrollView setFrame:NSMakeRect(273, 76, 278, 120 - HEIGHT2)];
        
    } else if (rect1.size.width >= 300 && rect2.size.width < 300) {
        
        [_airBackupSettingAlertSubTitle4 setFrameOrigin:NSMakePoint(_airBackupSettingAlertSubTitle4.frame.origin.x, 289 - HEIGHT1)];
        [_airBackupSettingAlertBatteryPopBtn2 setFrameOrigin:NSMakePoint(_airBackupSettingAlertBatteryPopBtn2.frame.origin.x, 283 - HEIGHT1)];
        [_airBackupSettingAlertPromptStr2 setFrameOrigin:NSMakePoint(_airBackupSettingAlertPromptStr2.frame.origin.x, 241 - HEIGHT1)];
        [_airBackupSettingAlertSubTitle6 setFrameOrigin:NSMakePoint(_airBackupSettingAlertSubTitle6.frame.origin.x, 225 - HEIGHT1)];
        [_airBackupSettingAlertTurnPopBtn setFrameOrigin:NSMakePoint(_airBackupSettingAlertTurnPopBtn.frame.origin.x, 219 - HEIGHT1)];
        [_airBackupSettingAlertSubTitle5 setFrameOrigin:NSMakePoint(_airBackupSettingAlertSubTitle5.frame.origin.x, 182 - HEIGHT1)];
        [_airBackupSettingAlertDeviceInfoView setFrame:NSMakeRect(272, 73, 280, 124 - HEIGHT1)];
        [_airBackupSettingAlertScrollView setFrame:NSMakeRect(273, 76, 278, 120 - HEIGHT1)];
        
    } else if (rect1.size.width < 300 && rect2.size.width >= 300) {
        
        [_airBackupSettingAlertSubTitle4 setFrameOrigin:NSMakePoint(_airBackupSettingAlertSubTitle4.frame.origin.x, 289)];
        [_airBackupSettingAlertBatteryPopBtn2 setFrameOrigin:NSMakePoint(_airBackupSettingAlertBatteryPopBtn2.frame.origin.x, 283)];
        [_airBackupSettingAlertPromptStr2 setFrameOrigin:NSMakePoint(_airBackupSettingAlertPromptStr2.frame.origin.x, 241)];
        [_airBackupSettingAlertSubTitle6 setFrameOrigin:NSMakePoint(_airBackupSettingAlertSubTitle6.frame.origin.x, 225 - HEIGHT1)];
        [_airBackupSettingAlertTurnPopBtn setFrameOrigin:NSMakePoint(_airBackupSettingAlertTurnPopBtn.frame.origin.x, 219 - HEIGHT1)];
        [_airBackupSettingAlertSubTitle5 setFrameOrigin:NSMakePoint(_airBackupSettingAlertSubTitle5.frame.origin.x, 182 - HEIGHT1)];
        [_airBackupSettingAlertDeviceInfoView setFrame:NSMakeRect(272, 73, 280, 124 - HEIGHT1)];
        [_airBackupSettingAlertScrollView setFrame:NSMakeRect(273, 76, 278, 120 - HEIGHT1)];
        
    } else if (rect1.size.width < 300 && rect2.size.width < 300){
        
        [_airBackupSettingAlertSubTitle4 setFrameOrigin:NSMakePoint(_airBackupSettingAlertSubTitle4.frame.origin.x, 289)];
        [_airBackupSettingAlertBatteryPopBtn2 setFrameOrigin:NSMakePoint(_airBackupSettingAlertBatteryPopBtn2.frame.origin.x, 283)];
        [_airBackupSettingAlertPromptStr2 setFrameOrigin:NSMakePoint(_airBackupSettingAlertPromptStr2.frame.origin.x, 241)];
        [_airBackupSettingAlertSubTitle6 setFrameOrigin:NSMakePoint(_airBackupSettingAlertSubTitle6.frame.origin.x, 225)];
        [_airBackupSettingAlertTurnPopBtn setFrameOrigin:NSMakePoint(_airBackupSettingAlertTurnPopBtn.frame.origin.x, 219)];
        [_airBackupSettingAlertSubTitle5 setFrameOrigin:NSMakePoint(_airBackupSettingAlertSubTitle5.frame.origin.x, 182)];
        [_airBackupSettingAlertDeviceInfoView setFrame:NSMakeRect(272, 73, 280, 124)];
        [_airBackupSettingAlertScrollView setFrame:NSMakeRect(273, 76, 278, 120)];
    }
    
}

#pragma mark - switch 按钮方法
- (void)switchButtonClick {
    _isOn = _airBackupSettingAlertSwitchBtn.isOn;
    NSString *switchButtonStatus = nil;
    if (_isOn) {
        switchButtonStatus = @"Enabled";
        [_airBackupSettingAlertONStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [_airBackupSettingAlertOFFStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
    } else {
        switchButtonStatus = @"Disabled";
        [_airBackupSettingAlertONStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_disableColor", nil)]];
        [_airBackupSettingAlertOFFStr setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Air_Backup action:ActionNone actionParams:[NSString stringWithFormat:@"Air Backup Option %@", switchButtonStatus] label:Click transferCount:0 screenView:@"Advanced Settings View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}

#pragma mark - 读取高级设置基本配置文件
- (void)readConfigFile {
    //设为默认值
    _isOn = NO;
    _isFirstOn = NO;
    [_airBackupSettingAlertSwitchBtn setOn:NO];
    _backupPath = [TempHelper getBackupFolderPath];
    _lowBatteryStr = 10;
    _highBatteryStr = 20;
    _photoMediaCanBackup = YES;
    NSString *configPath = [[IMBHelper getBackupServerSupportConfigPath] stringByAppendingPathComponent:@"airBackupConfig.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:configPath]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:configPath];
        if (dic != nil) {
            if ([dic.allKeys containsObject:@"AirBackupMasterSwitch"]) {
                _isOn = [[dic objectForKey:@"AirBackupMasterSwitch"] boolValue];
                _isFirstOn = [[dic objectForKey:@"AirBackupMasterSwitch"] boolValue];
            }
            [_airBackupSettingAlertSwitchBtn setOn:_isOn];
            if ([dic.allKeys containsObject:@"PhotoMediaBackupIsOn"]) {
                _photoMediaCanBackup = [[dic objectForKey:@"PhotoMediaBackupIsOn"] boolValue];
            }
            if ([dic.allKeys containsObject:@"BackupPath"]) {
                _backupPath = [dic objectForKey:@"BackupPath"];
            }
            if ([dic.allKeys containsObject:@"LowElectricityTip"]) {
                _lowBatteryStr = [[dic objectForKey:@"LowElectricityTip"] intValue];
            }
            if ([dic.allKeys containsObject:@"ElectricityReminder"]) {
                _highBatteryStr = [[dic objectForKey:@"ElectricityReminder"] intValue];
            }
            [dic release];
        }
    }
    [self readBackupConfig];
}

#pragma mark - 读取已备份信息
- (void)readBackupConfig {
    NSString *recordPath = [[IMBHelper getBackupServerSupportConfigPath] stringByAppendingPathComponent:@"backupRecord.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:recordPath]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:recordPath];
        if (dic != nil) {
            for (NSString *str in dic.allKeys) {
                id ary = [dic objectForKey:str];
                if ([ary isKindOfClass:[NSArray class]]) {
                    NSDictionary *lastDic = [ary lastObject];
                    if ([lastDic isKindOfClass:[NSDictionary class]]) {
                        IMBBaseInfo *baseInfo = [[IMBBaseInfo alloc] init];
                        baseInfo.backupSize = [lastDic objectForKey:@"BackupSize"];
                        baseInfo.backupTime = [lastDic objectForKey:@"BackupTime"];
                        baseInfo.deviceName = [lastDic objectForKey:@"DeviceName"];
                        baseInfo.uniqueKey = [lastDic objectForKey:@"SerialNumber"];
                        baseInfo.connectType = [IMBHelper family:[lastDic objectForKey:@"DeviceType"]];
                        [_dataArr addObject:baseInfo];
                        [baseInfo release], baseInfo = nil;
                    }
                }
            }
        }
    }
}

#pragma mark - 保存配置文件
- (void)saveConFigFile {
    NSString *configPath = [[IMBHelper getBackupServerSupportConfigPath] stringByAppendingPathComponent:@"airBackupConfig.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableDictionary *dic = nil;
    if ([fm fileExistsAtPath:configPath]) {
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:configPath];
    }else {
        dic = [[NSMutableDictionary alloc] init];
    }
    [dic setObject:[NSNumber numberWithBool:_airBackupSettingAlertSwitchBtn.isOn] forKey:@"AirBackupMasterSwitch"];
    [dic setObject:[NSNumber numberWithBool:_photoMediaCanBackup] forKey:@"PhotoMediaBackupIsOn"];
    [dic setObject:_backupPath forKey:@"BackupPath"];
    [dic setObject:[NSNumber numberWithInt:_lowBatteryStr] forKey:@"LowElectricityTip"];
    [dic setObject:[NSNumber numberWithInt:_highBatteryStr] forKey:@"ElectricityReminder"];
    [dic writeToFile:configPath atomically:YES];
    [dic release];
    
    if (_airBackupSettingAlertSwitchBtn.isOn) {
        [[IMBSoftWareInfo singleton] setIsStartUpAirBackup:YES];
        [[IMBSoftWareInfo singleton] save];
    }
    
    NSString *configLocalPath = [[TempHelper getAppSupportPath] stringByAppendingPathComponent:DeviceConfigPath];
    if (![fm fileExistsAtPath:configLocalPath]) {
        [fm createDirectoryAtPath:configLocalPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    configLocalPath = [configLocalPath stringByAppendingPathComponent:ExportConfigName];
    NSMutableDictionary *dic2 = nil;
    if ([fm fileExistsAtPath:configLocalPath]) {
        dic2 = [[NSMutableDictionary alloc] initWithContentsOfFile:configLocalPath];
        [dic2 setObject:_backupPath forKey:@"BackUp Path"];
        [dic2 writeToFile:configLocalPath atomically:YES];
        [dic2 release];
    }
    
}

#pragma mark - 删除配置文件
- (void)deleteConfigFileWithDeviceKey:(NSString *)devcieKey {
    NSString *recordPath = [[IMBHelper getBackupServerSupportConfigPath] stringByAppendingPathComponent:@"backupRecord.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:recordPath]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:recordPath];
        if (dic != nil) {
            for (int i = 0;i < dic.allKeys.count;i++) {
                NSString *str = [dic.allKeys objectAtIndex:i];
                id ary = [dic objectForKey:str];
                if ([ary isKindOfClass:[NSArray class]] && [str isEqualToString:devcieKey]) {
                    [dic removeObjectForKey:str];
                    [dic writeToFile:recordPath atomically:YES];
                }
            }
        }
        [dic release];
    }
    [_delegate removeAirBackupConfigWith:devcieKey];
    [_dataArr removeAllObjects];
    [self readBackupConfig];
    [self loadDeviceInfoListView];
}

#pragma mark - 配置popButton
- (void)configPopButtonWithBatteryStr:(NSString *)batteryStr WithPopButton:(IMBCustomPopBtn *)popButton WithIsLowBattery:(BOOL)isLowBattery {
    [popButton setHasMinWidth:YES];
    [popButton setMinWidth:112];
    [popButton setBtnHeight:24];
    [popButton setTitleSpaceWidth:20];
    [popButton setArrowSpace:8];
    [popButton setIsAlertView:YES];
    [popButton setTitleColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [popButton setFontSize:12.0];
    [popButton setArrowImage:[StringHelper imageNamed:@"arrow"]];
    NSString *titleStr = @"";
    if (isLowBattery) {
        titleStr = CustomLocalizedString(@"AirBackupSettingAlert_BatteryPopBtn_Lower", nil);
    } else {
        titleStr = CustomLocalizedString(@"AirBackupSettingAlert_BatteryPopBtn_Over", nil);
    }
    [popButton.menu removeAllItems];
    NSMenuItem *proItem1 = [[NSMenuItem alloc] init];
    if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        [proItem1 setTitle:[@"10% " stringByAppendingString:titleStr]];
    }else {
        [proItem1 setTitle:[titleStr stringByAppendingString:@" 10%"]];
    }
    
    [proItem1 setState:NSOffState];
    [proItem1 setTarget:self];
    if (isLowBattery) {
        [proItem1 setAction:@selector(changeLowBatteryStr)];
    } else {
        [proItem1 setAction:@selector(changeHighBatteryStr)];
    }
    [popButton.menu addItem:proItem1];
    
    NSMenuItem *proItem2 = [[NSMenuItem alloc] init];
    if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        [proItem2 setTitle:[@"20% " stringByAppendingString:titleStr]];
    }else {
        [proItem2 setTitle:[titleStr stringByAppendingString:@" 20%"]];
    }
    
    [proItem2 setState:NSOffState];
    [proItem2 setTarget:self];
    if (isLowBattery) {
        [proItem2 setAction:@selector(changeLowBatteryStr)];
    } else {
        [proItem2 setAction:@selector(changeHighBatteryStr)];
    }
    [popButton.menu addItem:proItem2];
    
    NSMenuItem *proItem3 = [[NSMenuItem alloc] init];
    if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        [proItem3 setTitle:[@"30% " stringByAppendingString:titleStr]];
    }else {
        [proItem3 setTitle:[titleStr stringByAppendingString:@" 30%"]];
    }
    
    [proItem3 setState:NSOffState];
    [proItem3 setTarget:self];
    if (isLowBattery) {
        [proItem3 setAction:@selector(changeLowBatteryStr)];
    } else {
        [proItem3 setAction:@selector(changeHighBatteryStr)];
    }
    [popButton.menu addItem:proItem3];
    
    NSMenuItem *proItem4 = [[NSMenuItem alloc] init];
    if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        [proItem4 setTitle:[@"50% " stringByAppendingString:titleStr]];
    }else {
        [proItem4 setTitle:[titleStr stringByAppendingString:@" 50%"]];
    }

    [proItem4 setState:NSOffState];
    [proItem4 setTarget:self];
    if (isLowBattery) {
        [proItem4 setAction:@selector(changeLowBatteryStr)];
    } else {
        [proItem4 setAction:@selector(changeHighBatteryStr)];
    }
    [popButton.menu addItem:proItem4];
    
    NSMenuItem *proItem5 = [[NSMenuItem alloc] init];
    if (isLowBattery) {
        [proItem5 setTitle:CustomLocalizedString(@"AirBackupBatteery_Never", nil)];
        [proItem5 setState:NSOffState];
        [proItem5 setTarget:self];
        [proItem5 setAction:@selector(changeLowBatteryStr)];
        [popButton.menu addItem:proItem5];
    }
    
    if (![StringHelper stringIsNilOrEmpty:batteryStr]) {
        if ([batteryStr isEqualToString:@"10"]) {
            [proItem1 setState:NSOnState];
            [popButton selectItem:proItem1];
            if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
                [popButton setTitle:[@"10% " stringByAppendingString:titleStr]];
            }else {
                [popButton setTitle:[titleStr stringByAppendingString:@" 10%"]];
            }
        } else if ([batteryStr isEqualToString:@"20"]) {
            [proItem2 setState:NSOnState];
            [popButton selectItem:proItem2];
            if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
                [popButton setTitle:[@"20% " stringByAppendingString:titleStr]];
            }else {
                [popButton setTitle:[titleStr stringByAppendingString:@" 20%"]];
            }
        } else if ([batteryStr isEqualToString:@"30"]) {
            [proItem3 setState:NSOnState];
            [popButton selectItem:proItem3];
            if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
                [popButton setTitle:[@"30% " stringByAppendingString:titleStr]];
            }else {
                [popButton setTitle:[titleStr stringByAppendingString:@" 30%"]];
            }
        } else if ([batteryStr isEqualToString:@"50"]) {
            [proItem4 setState:NSOnState];
            [popButton selectItem:proItem4];
            if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
                [popButton setTitle:[@"50% " stringByAppendingString:titleStr]];
            }else {
                [popButton setTitle:[titleStr stringByAppendingString:@" 50%"]];
            }
        } else if ([batteryStr isEqualToString:@"0"]) {
            [proItem5 setState:NSOnState];
            [popButton setTitle:CustomLocalizedString(@"AirBackupBatteery_Never", nil)];
            [popButton selectItem:proItem5];
        }
    } else {
        if (isLowBattery) {
            [proItem1 setState:NSOnState];
            [popButton selectItem:proItem1];
            if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
                [popButton setTitle:[@"10% " stringByAppendingString:titleStr]];
            }else {
                [popButton setTitle:[titleStr stringByAppendingString:@" 10%"]];
            }
            
        } else {
            [proItem2 setState:NSOnState];
            [popButton selectItem:proItem2];
            if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
                [popButton setTitle:[@"20% " stringByAppendingString:titleStr]];
            }else {
                [popButton setTitle:[titleStr stringByAppendingString:@" 20%"]];
            }
        }
        
    }
    
    [proItem1 release];
    [proItem2 release];
    [proItem3 release];
    [proItem4 release];
    [proItem5 release];
    [popButton setHasBorder:YES];
}

#pragma mark - popButton method
//低电量设置
- (void)changeLowBatteryStr {
    for (NSMenuItem *item in _airBackupSettingAlertBatteryPopBtn1.menu.itemArray) {
        if (item.state == NSOnState) {
            [_airBackupSettingAlertBatteryPopBtn1 setTitle:item.title];
            NSString *titleStr = CustomLocalizedString(@"AirBackupSettingAlert_BatteryPopBtn_Lower", nil);
            if([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
                if ([item.title isEqualToString:[@"10% " stringByAppendingString:titleStr]]) {
                    _lowBatteryStr = 10;
                } else if ([item.title isEqualToString:[@"20% " stringByAppendingString:titleStr]]) {
                    _lowBatteryStr = 20;
                } else if ([item.title isEqualToString:[@"30% " stringByAppendingString:titleStr]]) {
                    _lowBatteryStr = 30;
                } else if ([item.title isEqualToString:[@"50% " stringByAppendingString:titleStr]]) {
                    _lowBatteryStr = 50;
                } else if ([item.title isEqualToString:CustomLocalizedString(@"AirBackupBatteery_Never", nil)]) {
                    _lowBatteryStr = 0;
                }
            }else {
                if ([item.title isEqualToString:[titleStr stringByAppendingString:@" 10%"]]) {
                    _lowBatteryStr = 10;
                } else if ([item.title isEqualToString:[titleStr stringByAppendingString:@" 20%"]]) {
                    _lowBatteryStr = 20;
                } else if ([item.title isEqualToString:[titleStr stringByAppendingString:@" 30%"]]) {
                    _lowBatteryStr = 30;
                } else if ([item.title isEqualToString:[titleStr stringByAppendingString:@" 50%"]]) {
                    _lowBatteryStr = 50;
                } else if ([item.title isEqualToString:CustomLocalizedString(@"AirBackupBatteery_Never", nil)]) {
                    _lowBatteryStr = 0;
                }
            }
            break;
        }
    }
    if ([_airBackupSettingAlertBatteryPopBtn1.title isEqualToString:CustomLocalizedString(@"AirBackupBatteery_Never", nil)]) {
        [_airBackupSettingAlertPromptStr1 setStringValue:CustomLocalizedString(@"AirBackupSettingAlert_SubTitle2_Never", nil)];
    } else {
        [_airBackupSettingAlertPromptStr1 setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"AirBackupSettingAlert_SubTitle2_1", nil),_airBackupSettingAlertBatteryPopBtn1.title]];
    }
}
//备份电量设置
- (void)changeHighBatteryStr {
    for (NSMenuItem *item in _airBackupSettingAlertBatteryPopBtn2.menu.itemArray) {
        if (item.state == NSOnState) {
            [_airBackupSettingAlertBatteryPopBtn2 setTitle:item.title];
            NSString *titleStr = CustomLocalizedString(@"AirBackupSettingAlert_BatteryPopBtn_Over", nil);
            if([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
                if ([item.title isEqualToString:[@"10% " stringByAppendingString:titleStr]]) {
                    _highBatteryStr = 10;
                } else if ([item.title isEqualToString:[@"20% " stringByAppendingString:titleStr]]) {
                    _highBatteryStr = 20;
                } else if ([item.title isEqualToString:[@"30% " stringByAppendingString:titleStr]]) {
                    _highBatteryStr = 30;
                } else if ([item.title isEqualToString:[@"50% " stringByAppendingString:titleStr]]) {
                    _highBatteryStr = 50;
                }
            }else {
                if ([item.title isEqualToString:[titleStr stringByAppendingString:@" 10%"]]) {
                    _highBatteryStr = 10;
                } else if ([item.title isEqualToString:[titleStr stringByAppendingString:@" 20%"]]) {
                    _highBatteryStr = 20;
                } else if ([item.title isEqualToString:[titleStr stringByAppendingString:@" 30%"]]) {
                    _highBatteryStr = 30;
                } else if ([item.title isEqualToString:[titleStr stringByAppendingString:@" 50%"]]) {
                    _highBatteryStr = 50;
                }
            }
            break;
        }
    }
    [_airBackupSettingAlertPromptStr2 setStringValue:[NSString stringWithFormat:CustomLocalizedString(@"AirBackupSettingAlert_SubTitle3_1", nil),_airBackupSettingAlertBatteryPopBtn2.title]];

}
//photo and media是否备份设置
- (void)changePhotoAndMediaIsBackup {
    for (NSMenuItem *item in _airBackupSettingAlertTurnPopBtn.menu.itemArray) {
        if (item.state == NSOnState) {
            [_airBackupSettingAlertTurnPopBtn setTitle:item.title];
            if (item.tag == 501) {
                _photoMediaCanBackup = YES;
            } else if (item.tag == 502) {
                _photoMediaCanBackup = NO;
            }
            break;
        }
    }
}

#pragma mark - airBackup 设备缓存列表
- (void)loadDeviceInfoListView {
    if (_contentView != nil) {
        [_contentView release];
        _contentView = nil;
    }
    if (_dataArr.count * 30 > _airBackupSettingAlertScrollView.frame.size.height) {
        _contentView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(0, 0, 278, _dataArr.count * 30)];
    } else {
        _contentView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(0, 0, 278, _airBackupSettingAlertScrollView.frame.size.height)];
    }
    [_contentView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [_airBackupSettingAlertScrollView setDocumentView:_contentView];
    if (_dataArr.count * 30 > _airBackupSettingAlertScrollView.frame.size.height) {
        [_airBackupSettingAlertScrollView.contentView scrollToPoint:NSMakePoint(0, 30)];
    }
    IMBBaseInfo *baseInfo = nil;
    if (_dataArr.count > 0) {
        int deviceCount = (int)_dataArr.count;
        for (int i = 1; i <= deviceCount; i++) {
            baseInfo = [_dataArr objectAtIndex:i-1];
            NSRect itemRect;
            itemRect.origin.x = 0;
            if (deviceCount * 30 < _airBackupSettingAlertScrollView.frame.size.height) {
                itemRect.origin.y = _airBackupSettingAlertScrollView.frame.size.height - i * 30;
            } else {
                itemRect.origin.y = deviceCount * 30 - i * 30;
            }
            itemRect.size.width = 278;
            itemRect.size.height = 30;
            IMBAirBackupDeviceItemView *deviceItem = [[IMBAirBackupDeviceItemView alloc] initWithFrame:itemRect];
            [deviceItem setIsSettingView:YES];
            [deviceItem setDelegate:self];
            [deviceItem setBaseInfo:baseInfo];
            [_contentView addSubview:deviceItem];
            [deviceItem release];
            deviceItem = nil;
        }
    } else {
        NSTextField *text = [[NSTextField alloc] init];
        [text setBordered:NO];
        [text setStringValue:CustomLocalizedString(@"AirBackupSettingNoBackup", nil)];
        [text setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [text setEnabled:NO];
        [text setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
        [text setEditable:NO];
        [text setSelectable:NO];
        [text setFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
        [text setAlignment:NSCenterTextAlignment];
        NSRect textRect = [StringHelper calcuTextBounds:text.stringValue fontSize:14.0];
        if (textRect.size.width > 238) {
            [text setFrame:NSMakeRect(20, (_contentView.frame.size.height - textRect.size.height*2)/2.0, 238, textRect.size.height * 2)];
        } else {
            [text setFrame:NSMakeRect(20, (_contentView.frame.size.height - textRect.size.height)/2.0, 238, textRect.size.height)];
        }
        
        [_contentView addSubview:text];
        [text release],text = nil;
    }
}

#pragma mark - AirBackup 修改备份路径
- (void)changeButtonClick {
    _openPanel = [NSOpenPanel openPanel];
    //设置默认的路径
    [_openPanel setDirectory:_airBackupSettingAlertPathText.stringValue];
    [_openPanel setAllowsMultipleSelection:NO];
    [_openPanel setCanChooseFiles:NO];
    [_openPanel setCanChooseDirectories:YES];
    [_openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result== NSFileHandlingPanelOKButton) {
            NSString * path =[[_openPanel URL] path];
            [_airBackupSettingAlertPathText setStringValue:path];
            _backupPath = path;
        }else{
            NSLog(@"other other other");
        }
        [_airBackupSettingAlertPathText setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        [_airBackupSettingAlertPathText setWantsLayer:YES];
    }];
}

#pragma mark - AirBackup 关闭窗口
- (void)closeAirBackupAlerView {
    NSString *str = @"open";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect =NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _airBackupSettingAlertView.frame.size.width) / 2), self.view.frame.size.height, _airBackupSettingAlertView.frame.size.width, _airBackupSettingAlertView.frame.size.height);
        
        [context setDuration:0.4];
        [[_airBackupSettingAlertView animator] setFrame:rect];
    } completionHandler:^{
        [_airBackupSettingAlertView removeFromSuperview];
        [self.view removeFromSuperview];
        if (_contentView != nil) {
            [_contentView release];
            _contentView = nil;
        }
        if (_dataArr != nil) {
            [_dataArr release];
            _dataArr = nil;
        }
    }];
}

#pragma mark - 关闭窗口并且保存配置
- (void)closeAndSaveConfigAirBackupAlertView {
    NSString *str = @"open";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    [self saveConFigFile];
    if (_isFirstOn) {
        if (!_airBackupSettingAlertSwitchBtn.isOn) {
            [SystemHelper stopLaunchDaemon];
        }
    } else {
        if (_airBackupSettingAlertSwitchBtn.isOn) {
            [SystemHelper startLaunchDaemon];
        }
    }
    if (!_airBackupSettingAlertSwitchBtn.isOn) {
        if([_delegate respondsToSelector:@selector(closeMasterAirBackSwitch)]) {
            [_delegate closeMasterAirBackSwitch];
        }
    }
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect =NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _airBackupSettingAlertView.frame.size.width) / 2), self.view.frame.size.height, _airBackupSettingAlertView.frame.size.width, _airBackupSettingAlertView.frame.size.height);
        
        [context setDuration:0.4];
        [[_airBackupSettingAlertView animator] setFrame:rect];
    } completionHandler:^{
        [_airBackupSettingAlertView removeFromSuperview];
        [self.view removeFromSuperview];
        if (_contentView != nil) {
            [_contentView release];
            _contentView = nil;
        }
        if (_dataArr != nil) {
            [_dataArr release];
            _dataArr = nil;
        }
    }];
}

#pragma mark - AirBackup引导用户使用弹框
- (void)showAirBackupGuideAlertViewWithSuperView:(NSView *)superView {
    NSString *str = @"close";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    NSView *bView = superView;
    [bView addSubview:self.view];
    [self.view setWantsLayer:YES];
    [self.view setFrameSize:superView.frame.size];
    [self.view addSubview:_AirBackupGuideAlertView];
    [_AirBackupGuideAlertView setFrame:NSMakeRect(superView.frame.origin.x + floor((superView.frame.size.width - _AirBackupGuideAlertView.frame.size.width) / 2), superView.frame.size.height, _AirBackupGuideAlertView.frame.size.width, _AirBackupGuideAlertView.frame.size.height)];
    [self.view setWantsLayer:YES];
    [_AirBackupGuideAlertView setBackground:[StringHelper getColorFromString:CustomColor(@"alert_bgColor", nil)]];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(bView.frame.origin.x + floor((bView.frame.size.width - _AirBackupGuideAlertView.frame.size.width) / 2), bView.frame.size.height - _AirBackupGuideAlertView.frame.size.height + 8, _AirBackupGuideAlertView.frame.size.width, _AirBackupGuideAlertView.frame.size.height);
        [context setDuration:0.3];
        [[_AirBackupGuideAlertView animator] setFrame:rect];
    } completionHandler:^{
        [self.view setWantsLayer:YES];
    }];
    
    //配置文字以及颜色
    [_AirBackupGuideAlertTitle setStringValue:CustomLocalizedString(@"AirbackRindme_Title", nil)];
    [_AirBackupGuideAlertTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_AirBackupGuideAlertSubTitle setStringValue:CustomLocalizedString(@"AirbackRindme_Title1", nil)];
    [_AirBackupGuideAlertSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_AirBackupGuideAlertDetailTitle1 setStringValue:CustomLocalizedString(@"AirbackRindme_step1", nil)];
    [_AirBackupGuideAlertDetailTitle1 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_AirBackupGuideAlertDetailTitle2 setStringValue:CustomLocalizedString(@"AirbackRindme_step2", nil)];
    [_AirBackupGuideAlertDetailTitle2 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    [_AirBackupGuideAlertDetailTitle3 setStringValue:CustomLocalizedString(@"AirbackRindme_step3", nil)];
    [_AirBackupGuideAlertDetailTitle3 setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    [_AirbackupGuideBgView setIsAirBackUpAlert:YES];
    
    NSString *promptStr = CustomLocalizedString(@"AirbackPublicWifi_Guide", nil);
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_AirBackupGuideAlertClickTextView setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [promptStr rangeOfString:promptStr];
    [promptAs addAttribute:NSLinkAttributeName value:promptStr range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSLeftTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_AirBackupGuideAlertClickTextView textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    [_AirBackupGuideAlertClickTextView setDelegate:self];
    [_AirBackupGuideAlertClickTextView setSelectable:YES];
    
    //配置图片
    [_AirBackupGuideAlertDetailImage1 setImage:[StringHelper imageNamed:@"airbackup_guide1"]];
    [_AirBackupGuideAlertDetailImage2 setImage:[StringHelper imageNamed:@"airbackup_guide2"]];
    [_AirBackupGuideAlertDetailImage3 setImage:[StringHelper imageNamed:@"airbackup_guide3"]];
    
    //配置按钮
    NSString *okBtnStr = CustomLocalizedString(@"AirbackRindme_YesButtonText", nil);
    [_AirBackupGuideAlertOkBtn reSetInit:okBtnStr WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okBtnStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_AirBackupGuideAlertOkBtn setAttributedTitle:attributedTitles];
    [_AirBackupGuideAlertOkBtn setFontSize:12.0];
    [_AirBackupGuideAlertOkBtn setTarget:self];
    [_AirBackupGuideAlertOkBtn setAction:@selector(AirBackupSaveGuideAlertView)];
    
    NSString *cancelStr = CustomLocalizedString(@"Button_Cancel", nil);
    [_AirBackupGuideAlertCancelBtn reSetInit:cancelStr WithPrefixImageName:@"cancal"];
    [_AirBackupGuideAlertCancelBtn setFontSize:12];
    NSMutableAttributedString *attributedTitles1 = [[[NSMutableAttributedString alloc]initWithString:cancelStr]autorelease];
    [attributedTitles1 addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles1 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles1 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancelStr.length)];
    [attributedTitles1 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles1.length)];
    [_AirBackupGuideAlertCancelBtn setAttributedTitle:attributedTitles1];
    [_AirBackupGuideAlertCancelBtn setIsReslutVeiw:YES];
    [_AirBackupGuideAlertCancelBtn setTarget:self];
    [_AirBackupGuideAlertCancelBtn setAction:@selector(closeAirBackupGuideAlertView)];
    [_AirBackupGuideAlertCancelBtn setNeedsDisplay:YES];
    
    NSRect rect1 = [TempHelper calcuTextBounds:okBtnStr fontSize:12];
    NSRect rect2 = [TempHelper calcuTextBounds:cancelStr fontSize:12];
    NSRect rect;
    if (rect1.size.width > rect2.size.width) {
        rect = rect1;
    }else{
        rect = rect2;
    }
    [_AirBackupGuideAlertCancelBtn setFrame:NSMakeRect(ceil(_AirBackupGuideAlertView.frame.size.width/2 - (int)rect.size.width - 20 - 5), _AirBackupGuideAlertCancelBtn.frame.origin.y, ceil((int)rect.size.width + 20), ceil(_AirBackupGuideAlertCancelBtn.frame.size.height))];
    [_AirBackupGuideAlertOkBtn setFrame:NSMakeRect(_AirBackupGuideAlertView.frame.size.width/2 + 5, _AirBackupGuideAlertOkBtn.frame.origin.y, (int)rect.size.width + 20, _AirBackupGuideAlertOkBtn.frame.size.height)];

}

#pragma mark - 关闭AirBackupGuide弹窗
- (void)closeAirBackupGuideAlertView {
    NSString *str = @"open";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Air_Backup action:ActionNone actionParams:@"Permission Denied" label:Click transferCount:0 screenView:@"Welcome to AirBackup View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect =NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _AirBackupGuideAlertView.frame.size.width) / 2), self.view.frame.size.height, _AirBackupGuideAlertView.frame.size.width, _AirBackupGuideAlertView.frame.size.height);
        
        [context setDuration:0.3];
        [[_AirBackupGuideAlertView animator] setFrame:rect];
    } completionHandler:^{
        [_AirBackupGuideAlertView removeFromSuperview];
        [self.view removeFromSuperview];
    }];
    [[IMBSoftWareInfo singleton] setIsStartUpAirBackup:NO];
}

- (void)AirBackupSaveGuideAlertView {
    NSString *str = @"open";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Air_Backup action:ActionNone actionParams:@"Permission Allowed" label:Click transferCount:0 screenView:@"Welcome to AirBackup View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect =NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _AirBackupGuideAlertView.frame.size.width) / 2), self.view.frame.size.height, _AirBackupGuideAlertView.frame.size.width, _AirBackupGuideAlertView.frame.size.height);
        
        [context setDuration:0.3];
        [[_AirBackupGuideAlertView animator] setFrame:rect];
    } completionHandler:^{
        [_AirBackupGuideAlertView removeFromSuperview];
        [self.view removeFromSuperview];
    }];
    [[IMBSoftWareInfo singleton] setIsStartUpAirBackup:YES];
    [[IMBSoftWareInfo singleton] save];
    
    //打开守护进程
    [SystemHelper createLaunchDaemon];
    
    NSString *configPath = [[IMBHelper getBackupServerSupportConfigPath] stringByAppendingPathComponent:@"airBackupConfig.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableDictionary *dic = nil;
    if ([fm fileExistsAtPath:configPath]) {
        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:configPath];
    }else {
        dic = [[NSMutableDictionary alloc] init];
    }
    [dic setObject:[NSNumber numberWithBool:YES] forKey:@"AirBackupMasterSwitch"];
    [dic writeToFile:configPath atomically:YES];
    [dic release];
}

#pragma mark - airBackup 公共WiFi使用弹窗
- (void)showAirBackupPublicWiFiAlertViewWithSuperView:(NSView *)superView {
    NSString *str = @"close";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    NSView *bView = superView;
    [bView addSubview:self.view];
    [self.view setWantsLayer:YES];
    [self.view setFrameSize:superView.frame.size];
    [self.view addSubview:_airBackupPublicWiFiAlertView];
    [_airBackupPublicWiFiAlertView setFrame:NSMakeRect(superView.frame.origin.x + floor((superView.frame.size.width - _airBackupPublicWiFiAlertView.frame.size.width) / 2), superView.frame.size.height, _airBackupPublicWiFiAlertView.frame.size.width, _airBackupPublicWiFiAlertView.frame.size.height)];
    [self.view setWantsLayer:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(bView.frame.origin.x + floor((bView.frame.size.width - _airBackupPublicWiFiAlertView.frame.size.width) / 2), bView.frame.size.height - _airBackupPublicWiFiAlertView.frame.size.height + 8, _airBackupPublicWiFiAlertView.frame.size.width, _airBackupPublicWiFiAlertView.frame.size.height);
        [context setDuration:0.3];
        [[_airBackupPublicWiFiAlertView animator] setFrame:rect];
    } completionHandler:^{
        [self.view setWantsLayer:YES];
    }];
    
    //配置文字及颜色
    [_airBackupPublicWiFiAlertTitle setStringValue:CustomLocalizedString(@"AirbackPublicWifi_Title1", nil)];
    [_airBackupPublicWiFiAlertTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_airBackupPublicWiFiAlertSubTitle setStringValue:CustomLocalizedString(@"AirbackPublicWifi_Title2", nil)];
    [_airBackupPublicWiFiAlertSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    NSString *promptStr = CustomLocalizedString(@"AirbackPublicWifi_Guide", nil);
    NSDictionary *linkAttributes = @{(id)kCTForegroundColorAttributeName: [StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)], (id)kCTUnderlineStyleAttributeName: [NSNumber numberWithInt:kCTUnderlineStyleNone]};
    [_airBackupPublicWiFiAlertClickText setLinkTextAttributes:linkAttributes];
    
    NSMutableAttributedString *promptAs = [StringHelper setSingleTextAttributedString:promptStr withFont:[NSFont fontWithName:@"Helvetica Neue" size:12] withColor:[StringHelper getColorFromString:CustomColor(@"nodata_nolinkeTitle_color", nil)]];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor arrowCursor] range:NSMakeRange(0, promptAs.length)];
    NSRange infoRange = [promptStr rangeOfString:promptStr];
    [promptAs addAttribute:NSLinkAttributeName value:promptStr range:infoRange];
    [promptAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] range:infoRange];
    [promptAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12.0] range:infoRange];
    [promptAs addAttribute:NSCursorAttributeName value:[NSCursor pointingHandCursor] range:infoRange];
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSLeftTextAlignment];
    [mutParaStyle setLineSpacing:5.0];
    [promptAs addAttributes:[NSDictionary dictionaryWithObject:mutParaStyle forKey:NSParagraphStyleAttributeName] range:NSMakeRange(0,[[promptAs string] length])];
    [[_airBackupPublicWiFiAlertClickText textStorage] setAttributedString:promptAs];
    [mutParaStyle release], mutParaStyle = nil;
    [_airBackupPublicWiFiAlertClickText setDelegate:self];
    [_airBackupPublicWiFiAlertClickText setSelectable:YES];
    
    //图片
    [_airBackupPublicWiFiAlertImage setImage:[StringHelper imageNamed:@"airbackup_publicbox"]];
    
    //配置按钮
    NSString *okBtnStr = CustomLocalizedString(@"TrustView_id_2", nil);
    [_airBackupPublicWiFiAlertOkBtn reSetInit:okBtnStr WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okBtnStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_airBackupPublicWiFiAlertOkBtn setAttributedTitle:attributedTitles];
    [_airBackupPublicWiFiAlertOkBtn setFontSize:12.0];
    [_airBackupPublicWiFiAlertOkBtn setTarget:self];
    [_airBackupPublicWiFiAlertOkBtn setAction:@selector(closeAirBackupPublicWiFiAlertView)];
}

#pragma mark - 关闭AirBackup-PublicWiFi弹窗
- (void)closeAirBackupPublicWiFiAlertView {
    NSString *str = @"open";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect =NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _airBackupPublicWiFiAlertView.frame.size.width) / 2), self.view.frame.size.height, _airBackupPublicWiFiAlertView.frame.size.width, _airBackupPublicWiFiAlertView.frame.size.height);
        
        [context setDuration:0.3];
        [[_airBackupPublicWiFiAlertView animator] setFrame:rect];
    } completionHandler:^{
        [_airBackupPublicWiFiAlertView removeFromSuperview];
        [self.view removeFromSuperview];
    }];
}

#pragma mark - airBackup HotWiFi使用弹窗
- (void)showAirBackupHotWiFiAlertViewWithSuperView:(NSView *)superView {
    NSString *str = @"close";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    NSView *bView = superView;
    [bView addSubview:self.view];
    [self.view setWantsLayer:YES];
    [self.view setFrameSize:superView.frame.size];
    [self.view addSubview:_airBackupHotWiFiAlertView];
    [_airBackupHotWiFiAlertView setFrame:NSMakeRect(superView.frame.origin.x + floor((superView.frame.size.width - _airBackupHotWiFiAlertView.frame.size.width) / 2), superView.frame.size.height, _airBackupHotWiFiAlertView.frame.size.width, _airBackupHotWiFiAlertView.frame.size.height)];
    [self.view setWantsLayer:YES];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect = NSMakeRect(bView.frame.origin.x + floor((bView.frame.size.width - _airBackupHotWiFiAlertView.frame.size.width) / 2), bView.frame.size.height - _airBackupHotWiFiAlertView.frame.size.height + 8, _airBackupHotWiFiAlertView.frame.size.width, _airBackupHotWiFiAlertView.frame.size.height);
        [context setDuration:0.3];
        [[_airBackupHotWiFiAlertView animator] setFrame:rect];
    } completionHandler:^{
        [self.view setWantsLayer:YES];
    }];
    
    //配置文字及颜色
    [_airBackupHotWiFiAlertTitle setStringValue:CustomLocalizedString(@"AirbackWiFiConnect_Title", nil)];
    [_airBackupHotWiFiAlertTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_airBackupHotWiFiAlertSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)]];
    
    NSString *promptStr = CustomLocalizedString(@"AirbackPublicWifi_Guide", nil);
    [_airBackupHotWiFiAlertClickText setNormalString:promptStr WithLinkString:promptStr WithNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    [_airBackupHotWiFiAlertClickText setAlignment:NSLeftTextAlignment];
    [_airBackupHotWiFiAlertClickText setDelegate:self];
    [_airBackupHotWiFiAlertClickText setSelectable:YES];
    
    //配置按钮
    NSString *okBtnStr = CustomLocalizedString(@"TrustView_id_2", nil);
    [_airBackupHotWiFiAlertOkBtn reSetInit:okBtnStr WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okBtnStr]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okBtnStr.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_airBackupHotWiFiAlertOkBtn setAttributedTitle:attributedTitles];
    [_airBackupHotWiFiAlertOkBtn setFontSize:12.0];
    [_airBackupHotWiFiAlertOkBtn setTarget:self];
    [_airBackupHotWiFiAlertOkBtn setAction:@selector(closeAirBackupHotWiFiAlertView)];
    
    //上一步及下一步 按钮
    _airBackupHotWiFiAlertNextStepBtn.tag = 1;
    [_airBackupHotWiFiAlertNextStepBtn setTarget:self];
    [_airBackupHotWiFiAlertNextStepBtn setAction:@selector(nextStepBtnClick)];
    [_airBackupHotWiFiAlertNextStepBtn setMouseEnteredImage:[StringHelper imageNamed:@"airbackup_guide_right2"] mouseExitImage:[StringHelper imageNamed:@"airbackup_guide_right1"] mouseDownImage:[StringHelper imageNamed:@"airbackup_guide_right3"]];
    
    [_airBackupHotWiFiAlertBackStepBtn setTarget:self];
    [_airBackupHotWiFiAlertBackStepBtn setAction:@selector(backStepBtnClick)];
    [_airBackupHotWiFiAlertBackStepBtn setMouseEnteredImage:[StringHelper imageNamed:@"airbackup_guide_left2"] mouseExitImage:[StringHelper imageNamed:@"airbackup_guide_left1"] mouseDownImage:[StringHelper imageNamed:@"airbackup_guide_left3"]];
    
    //图片配置
    NSImage *image = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {
        image = [StringHelper imageNamed:@"airbackup_hot1"];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        image = [StringHelper imageNamed:@"airbackup_hot1ar"];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        image = [StringHelper imageNamed:@"airbackup_hot1ch"];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
        image = [StringHelper imageNamed:@"airbackup_hot1de"];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == FrenchLanguage) {
        image = [StringHelper imageNamed:@"airbackup_hot1fr"];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        image = [StringHelper imageNamed:@"airbackup_hot1jp"];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == SpanishLanguage) {
        image = [StringHelper imageNamed:@"airbackup_hot1sp"];
    }else {
        image = [StringHelper imageNamed:@"airbackup_hot1"];
    }
    [_airBackupHotWiFiAlertImageView setImage:image];
    [_airBackupHotWiFiAlertSubTitle setStringValue:CustomLocalizedString(@"AriBackup_wifi_guide_1", nil)];
    //底部圆点
    [_circleView1 setCircleRadius:_circleView1.frame.size.width/2.0];
    [_circleView1 setFillColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_circleView1 setHighLightColor:[StringHelper getColorFromString:CustomColor(@"animation_circleColor", nil)]];
    [_circleView1 setIsNowPage:YES];
    
    [_circleView2 setCircleRadius:_circleView1.frame.size.width/2.0];
    [_circleView2 setFillColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_circleView2 setHighLightColor:[StringHelper getColorFromString:CustomColor(@"animation_circleColor", nil)]];
    [_circleView2 setIsNowPage:NO];
    
    [_circleView3 setCircleRadius:_circleView1.frame.size.width/2.0];
    [_circleView3 setFillColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_circleView3 setHighLightColor:[StringHelper getColorFromString:CustomColor(@"animation_circleColor", nil)]];
    [_circleView3 setIsNowPage:NO];
    
    [_circleView4 setCircleRadius:_circleView1.frame.size.width/2.0];
    [_circleView4 setFillColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)]];
    [_circleView4 setHighLightColor:[StringHelper getColorFromString:CustomColor(@"animation_circleColor", nil)]];
    [_circleView4 setIsNowPage:NO];
    
    [_circleView1 setNeedsDisplay:YES];
    [_circleView2 setNeedsDisplay:YES];
    [_circleView3 setNeedsDisplay:YES];
    [_circleView4 setNeedsDisplay:YES];
}

#pragma mark - 下一步
- (void)nextStepBtnClick {
    if (_airBackupHotWiFiAlertNextStepBtn.tag < 4) {
        _airBackupHotWiFiAlertNextStepBtn.tag ++;
        if (_airBackupHotWiFiAlertNextStepBtn.tag == 2) {
            [self changeHaveNumber:2];
            [_circleView1 setIsNowPage:NO];
            [_circleView2 setIsNowPage:YES];
            [_circleView3 setIsNowPage:NO];
            [_circleView4 setIsNowPage:NO];
            [_airBackupHotWiFiAlertSubTitle setStringValue:CustomLocalizedString(@"AriBackup_wifi_guide_2", nil)];
        } else if (_airBackupHotWiFiAlertNextStepBtn.tag == 3) {
            [self changeHaveNumber:2];
            [_circleView1 setIsNowPage:NO];
            [_circleView2 setIsNowPage:NO];
            [_circleView3 setIsNowPage:YES];
            [_circleView4 setIsNowPage:NO];
            [_airBackupHotWiFiAlertSubTitle setStringValue:CustomLocalizedString(@"AriBackup_wifi_guide_3", nil)];
        } else if (_airBackupHotWiFiAlertNextStepBtn.tag == 4) {
            [self changeHaveNumber:3];
            [_circleView1 setIsNowPage:NO];
            [_circleView2 setIsNowPage:NO];
            [_circleView3 setIsNowPage:NO];
            [_circleView4 setIsNowPage:YES];
            [_airBackupHotWiFiAlertSubTitle setStringValue:CustomLocalizedString(@"AriBackup_wifi_guide_4", nil)];
        } else {
            [self changeHaveNumber:1];
            [_circleView1 setIsNowPage:YES];
            [_circleView2 setIsNowPage:NO];
            [_circleView3 setIsNowPage:NO];
            [_circleView4 setIsNowPage:NO];
            [_airBackupHotWiFiAlertSubTitle setStringValue:CustomLocalizedString(@"AriBackup_wifi_guide_1", nil)];
        }
        [_circleView1 setNeedsDisplay:YES];
        [_circleView2 setNeedsDisplay:YES];
        [_circleView3 setNeedsDisplay:YES];
        [_circleView4 setNeedsDisplay:YES];
    } else {
        return;
    }
    NSImage *image = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {
        image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ld",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ldar",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ldch",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
        image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ldde",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == FrenchLanguage) {
        image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ldfr",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ldjp",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == SpanishLanguage) {
        image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ldsp",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }else {
         image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ld",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }
    
    [_airBackupHotWiFiAlertImageView setWantsLayer:YES];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.removedOnCompletion = NO;
    transition.fillMode = kCAFillModeForwards;
    [_airBackupHotWiFiAlertImageView.layer addAnimation:transition forKey:@""];
    [_airBackupHotWiFiAlertImageView setImage:image];
}

#pragma mark - 上一步
- (void)backStepBtnClick {
    if (_airBackupHotWiFiAlertNextStepBtn.tag <= 4 && _airBackupHotWiFiAlertNextStepBtn.tag > 1) {
        _airBackupHotWiFiAlertNextStepBtn.tag --;
        if (_airBackupHotWiFiAlertNextStepBtn.tag == 2) {
            [self changeHaveNumber:2];
            [_circleView1 setIsNowPage:NO];
            [_circleView2 setIsNowPage:YES];
            [_circleView3 setIsNowPage:NO];
            [_circleView4 setIsNowPage:NO];
            [_airBackupHotWiFiAlertSubTitle setStringValue:CustomLocalizedString(@"AriBackup_wifi_guide_2", nil)];
        } else if (_airBackupHotWiFiAlertNextStepBtn.tag == 3) {
            [self changeHaveNumber:2];
            [_circleView1 setIsNowPage:NO];
            [_circleView2 setIsNowPage:NO];
            [_circleView3 setIsNowPage:YES];
            [_circleView4 setIsNowPage:NO];
            [_airBackupHotWiFiAlertSubTitle setStringValue:CustomLocalizedString(@"AriBackup_wifi_guide_3", nil)];
        } else if (_airBackupHotWiFiAlertNextStepBtn.tag == 4) {
            [self changeHaveNumber:3];
            [_circleView1 setIsNowPage:NO];
            [_circleView2 setIsNowPage:NO];
            [_circleView3 setIsNowPage:NO];
            [_circleView4 setIsNowPage:YES];
            [_airBackupHotWiFiAlertSubTitle setStringValue:CustomLocalizedString(@"AriBackup_wifi_guide_4", nil)];
        } else {
            [self changeHaveNumber:1];
            [_circleView1 setIsNowPage:YES];
            [_circleView2 setIsNowPage:NO];
            [_circleView3 setIsNowPage:NO];
            [_circleView4 setIsNowPage:NO];
            [_airBackupHotWiFiAlertSubTitle setStringValue:CustomLocalizedString(@"AriBackup_wifi_guide_1", nil)];
        }
        [_circleView1 setNeedsDisplay:YES];
        [_circleView2 setNeedsDisplay:YES];
        [_circleView3 setNeedsDisplay:YES];
        [_circleView4 setNeedsDisplay:YES];
       
    } else {
        return;
    }
    NSImage *image = nil;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == EnglishLanguage) {
        image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ld",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
        image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ldar",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == ChinaLanguage) {
        image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ldch",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == GermanLanguage) {
        image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ldde",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == FrenchLanguage) {
        image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ldfr",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == JapaneseLanguage) {
        image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ldjp",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }else if ([IMBSoftWareInfo singleton].chooseLanguageType == SpanishLanguage) {
        image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ldsp",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }else {
        image = [StringHelper imageNamed:[NSString stringWithFormat:@"airbackup_hot%ld",_airBackupHotWiFiAlertNextStepBtn.tag]];
    }
    [_airBackupHotWiFiAlertImageView setWantsLayer:YES];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.8;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    transition.removedOnCompletion = NO;
    transition.fillMode = kCAFillModeForwards;
    [_airBackupHotWiFiAlertImageView.layer addAnimation:transition forKey:@""];
    [_airBackupHotWiFiAlertImageView setImage:image];
}

- (void)changeHaveNumber:(int) number{
    if (number == 1) {
        [_airBackupHotWiFiAlertNextStepBtn setMouseEnteredImage:[StringHelper imageNamed:@"airbackup_guide_right2"] mouseExitImage:[StringHelper imageNamed:@"airbackup_guide_right1"] mouseDownImage:[StringHelper imageNamed:@"airbackup_guide_right3"]];
        [_airBackupHotWiFiAlertBackStepBtn setMouseEnteredImage:[StringHelper imageNamed:@"airbackup_guide_left1"] mouseExitImage:[StringHelper imageNamed:@"airbackup_guide_left1"] mouseDownImage:[StringHelper imageNamed:@"airbackup_guide_left1"]];
    }else if (number == 2){
        [_airBackupHotWiFiAlertNextStepBtn setMouseEnteredImage:[StringHelper imageNamed:@"airbackup_guide_right2"] mouseExitImage:[StringHelper imageNamed:@"airbackup_guide_right1"] mouseDownImage:[StringHelper imageNamed:@"airbackup_guide_right3"]];
        [_airBackupHotWiFiAlertBackStepBtn setMouseEnteredImage:[StringHelper imageNamed:@"airbackup_guide_left2"] mouseExitImage:[StringHelper imageNamed:@"airbackup_guide_left4"] mouseDownImage:[StringHelper imageNamed:@"airbackup_guide_left3"]];
    }else if (number == 3){
        [_airBackupHotWiFiAlertNextStepBtn setMouseEnteredImage:[StringHelper imageNamed:@"airbackup_guide_right4"] mouseExitImage:[StringHelper imageNamed:@"airbackup_guide_right4"] mouseDownImage:[StringHelper imageNamed:@"airbackup_guide_right4"]];
        [_airBackupHotWiFiAlertBackStepBtn setMouseEnteredImage:[StringHelper imageNamed:@"airbackup_guide_left2"] mouseExitImage:[StringHelper imageNamed:@"airbackup_guide_left4"] mouseDownImage:[StringHelper imageNamed:@"airbackup_guide_left3"]];
    }

}

#pragma mark - 关闭AirBackup-HotWiFi弹窗
- (void)closeAirBackupHotWiFiAlertView {
    NSString *str = @"open";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        NSRect rect;
        rect =NSMakeRect(self.view.frame.origin.x + floor((self.view.frame.size.width - _airBackupHotWiFiAlertView.frame.size.width) / 2), self.view.frame.size.height, _airBackupHotWiFiAlertView.frame.size.width, _airBackupHotWiFiAlertView.frame.size.height);
        
        [context setDuration:0.3];
        [[_airBackupHotWiFiAlertView animator] setFrame:rect];
    } completionHandler:^{
        [_airBackupHotWiFiAlertView removeFromSuperview];
        [self.view removeFromSuperview];
    }];
}

#pragma mark - 双重验证
- (void)showDoubleVerificationAlertView:(NSView *)superView {
    NSString *str = @"close";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    _mainView = superView;
    [superView setWantsLayer:YES];
    [self.view setFrameSize:NSMakeSize(NSWidth(superView.frame), NSHeight(superView.frame))];
    [superView addSubview:self.view];
    
    [self setupAlertRect:_doubleVerificaView];
    if (![self.view.subviews containsObject:_doubleVerificaView]) {
        [self.view addSubview:_doubleVerificaView];
    }
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_doubleVerificaView.layer addAnimation:[IMBAnimation moveY:0.2 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-_doubleVerificaView.frame.size.height] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [_doubleVerificaView.layer removeAnimationForKey:@"moveY"];
        [_doubleVerificaView setFrame:NSMakeRect(ceil((NSMaxX(superView.bounds) - NSWidth(_doubleVerificaView.frame)) / 2), NSMaxY(superView.bounds) - NSHeight(_doubleVerificaView.frame) + 10, NSWidth(_doubleVerificaView.frame), NSHeight(_doubleVerificaView.frame))];
    }];
    //文本样式
    [_doubleVerificaTitle setStringValue:CustomLocalizedString(@"iCloudLogin_SecurityView_codeTips", nil)];
    [_doubleVerificaTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    
    [_doubleVerificaFirstNum setStringValue:@""];
    [_doubleVerificaSecondNum setStringValue:@""];
    [_doubleVerificaThirdNum setStringValue:@""];
    [_doubleVerificaFourthNum setStringValue:@""];
    [_doubleVerificaFifthNum setStringValue:@""];
    [_doubleVerificaSixthNum setStringValue:@""];
    
    [_doubleVerificaSubTitle setHidden:YES];
    [_doubleVerificaSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)]];
    
    [_loadingBgView setHidden:YES];
    [_doubleVerificaVerfiyTitle setHidden:YES];
    
    [_numBox1 setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_numBox1 setBorderColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [_numBox1 setHasCorner:YES];
    
    [_numBox2 setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_numBox2 setBorderColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [_numBox2 setHasCorner:YES];
    
    [_numBox3 setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_numBox3 setBorderColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [_numBox3 setHasCorner:YES];
    
    [_numBox4 setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_numBox4 setBorderColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [_numBox4 setHasCorner:YES];
    
    [_numBox5 setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_numBox5 setBorderColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [_numBox5 setHasCorner:YES];
    
    [_numBox6 setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_numBox6 setBorderColor:[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)]];
    [_numBox6 setHasCorner:YES];
    
    [_doubleVerificaFirstNum setCodeTag:1];
    [_doubleVerificaSecondNum setCodeTag:2];
    [_doubleVerificaThirdNum setCodeTag:3];
    [_doubleVerificaFourthNum setCodeTag:4];
    [_doubleVerificaFifthNum setCodeTag:5];
    [_doubleVerificaSixthNum setCodeTag:6];
    [_doubleVerificaFirstNum becomeFirstResponder];
    
    [_doubleVerificaSendCodeScrollView setHidden:YES];
    [_doubleVerificaSendmsgScrollView setHidden:YES];
    [_doubleVerificaHelpScrollView setHidden:YES];
    [_doubleVerificaTextView setHidden:NO];
    [_doubleVerificaTextView setNormalString:CustomLocalizedString(@"iCloudLogin_View_NotReceiveCode", nil) WithLinkString:CustomLocalizedString(@"iCloudLogin_View_NotReceiveCode", nil) WithNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    [_doubleVerificaTextView setDelegate:self];
    [_doubleVerificaTextView setSelectable:YES];

    //按钮样式
    NSString *okButtonString = CustomLocalizedString(@"Button_Ok", nil);
    NSSize okBtnRectSize = [StringHelper calcuTextBounds:okButtonString fontSize:12.0].size;
    NSString *cancleString = CustomLocalizedString(@"Button_Cancel", nil);
    NSSize cancelSize = [StringHelper calcuTextBounds:cancleString fontSize:12.0].size;
    
    [_doubleVerificaOkBtn reSetInit:okButtonString  WithPrefixImageName:@"pop"];
    NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:okButtonString]autorelease];
    [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)] range:NSMakeRange(0, okButtonString.length)];
    [attributedTitles setAlignment:NSCenterTextAlignment range:NSMakeRange(0, attributedTitles.length)];
    [_doubleVerificaOkBtn setAttributedTitle:attributedTitles];
    [_doubleVerificaOkBtn setTarget:self];
    [_doubleVerificaOkBtn setAction:@selector(doubleVerificaOkBtnOperation:)];
    
    [_doubleVerificaCancelBtn reSetInit:cancleString  WithPrefixImageName:@"cancal"];
    [_doubleVerificaCancelBtn setFontSize:12];
    NSMutableAttributedString *cancelAs = [[[NSMutableAttributedString alloc]initWithString:cancleString] autorelease];
    [cancelAs addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, cancleString.length)];
    [cancelAs addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, cancleString.length)];
    [cancelAs addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, cancleString.length)];
    [cancelAs setAlignment:NSCenterTextAlignment range:NSMakeRange(0, cancelAs.length)];
    [_doubleVerificaCancelBtn setAttributedTitle:cancelAs];
    [_doubleVerificaCancelBtn setIsReslutVeiw:YES];
    int width = (int)MAX(okBtnRectSize.width, cancelSize.width) + 30;
    
    [_doubleVerificaOkBtn setFrame:NSMakeRect(_doubleVerificaView.frame.size.width - 20 - width,_doubleVerificaOkBtn.frame.origin.y,width,_doubleVerificaOkBtn.frame.size.height)];
    
    [_doubleVerificaCancelBtn setFrame:NSMakeRect(_doubleVerificaOkBtn.frame.origin.x - 10 - width, _doubleVerificaCancelBtn.frame.origin.y, width, _doubleVerificaCancelBtn.frame.size.height)];
    
    [_doubleVerificaCancelBtn setTarget:self];
    [_doubleVerificaCancelBtn setAction:@selector(doubleVerificaCancelBtnOperation:)];
    [_doubleVerificaOkBtn setEnabled:NO];
    
    NSString *codeStr = [CustomLocalizedString(@"iCloudLogin_View_Resend", nil) stringByAppendingString:@" | "];
    NSRect rect1 = [IMBHelper calcuTextBounds:codeStr fontSize:12];
    NSString *msgStr = [CustomLocalizedString(@"iCloudLogin_View_SendByMessage", nil) stringByAppendingString:@" | "];
    NSRect rect2 = [IMBHelper calcuTextBounds:msgStr fontSize:12];
    NSString *helpStr = CustomLocalizedString(@"iCloudLogin_View_Help", nil);
    NSRect rect3 = [IMBHelper calcuTextBounds:helpStr fontSize:12];
    [_doubleVerificaSendCodeTextView setLinkStrIsFront:YES];
    [_doubleVerificaSendmsgTextView setLinkStrIsFront:YES];
    [_doubleVerificaHelpTextView setLinkStrIsFront:YES];
    
    [_doubleVerificaSendCodeTextView setNormalString:codeStr WithLinkString:CustomLocalizedString(@"iCloudLogin_View_Resend", nil) WithNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    [_doubleVerificaSendmsgTextView setNormalString:msgStr WithLinkString:CustomLocalizedString(@"iCloudLogin_View_SendByMessage", nil) WithNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    [_doubleVerificaHelpTextView setNormalString:helpStr WithLinkString:helpStr WithNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkNormalColor:[StringHelper getColorFromString:CustomColor(@"nodata_linkeTitle_color", nil)] WithLinkEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] WithLinkDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)] WithFont:[NSFont fontWithName:@"Helvetica Neue" size:12.0]];
    
    [_doubleVerificaSendCodeScrollView setFrame:NSMakeRect(_doubleVerificaScrollView.frame.origin.x, _doubleVerificaScrollView.frame.origin.y, rect1.size.width + 20, _doubleVerificaScrollView.frame.size.height)];
    [_doubleVerificaSendmsgScrollView setFrame:NSMakeRect(_doubleVerificaSendCodeScrollView.frame.origin.x + rect1.size.width, _doubleVerificaScrollView.frame.origin.y, rect2.size.width + 20, _doubleVerificaScrollView.frame.size.height)];
    [_doubleVerificaHelpScrollView setFrame:NSMakeRect(_doubleVerificaSendmsgScrollView.frame.origin.x + rect2.size.width, _doubleVerificaScrollView.frame.origin.y, rect3.size.width + 20, _doubleVerificaScrollView.frame.size.height)];
    
    [_doubleVerificaSendCodeTextView setDelegate:self];
    [_doubleVerificaSendmsgTextView setDelegate:self];
    [_doubleVerificaHelpTextView setDelegate:self];
    [_doubleVerificaSendCodeTextView setNeedsDisplay:YES];
    [_doubleVerificaSendmsgTextView setNeedsDisplay:YES];
    [_doubleVerificaHelpTextView setNeedsDisplay:YES];
}

//显示sendCode、Text Me、Help的View
- (void)showSendCodeMessageHelpView {
    [_doubleVerificaTextView setHidden:YES];
    [_doubleVerificaSendCodeScrollView setHidden:NO];
    [_doubleVerificaSendmsgScrollView setHidden:NO];
    [_doubleVerificaHelpScrollView setHidden:NO];

}

- (void)editDoubleVerificationCode:(NSNotification *)notification {
    if (![StringHelper stringIsNilOrEmpty:_doubleVerificaFirstNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaSecondNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaThirdNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaFourthNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaFifthNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaSixthNum.stringValue]) {
        [_doubleVerificaOkBtn setEnabled:YES];
    }else {
        [_doubleVerificaOkBtn setEnabled:NO];
    }
    
    NSDictionary *dic = notification.object;
    int codeTag = [[dic objectForKey:@"codeTag"] intValue];
    if (codeTag == 1) {
        [_doubleVerificaSecondNum becomeFirstResponder];
    } else if (codeTag == 2) {
        [_doubleVerificaThirdNum becomeFirstResponder];
    } else if (codeTag == 3) {
        [_doubleVerificaFourthNum becomeFirstResponder];
    } else if (codeTag == 4) {
        [_doubleVerificaFifthNum becomeFirstResponder];
    } else if (codeTag == 5) {
        [_doubleVerificaSixthNum becomeFirstResponder];
    } else if (codeTag == 6) {
        return;
    }
}

- (void)deleteDoubleVerificationCode:(NSNotification *)notification {
    if (![StringHelper stringIsNilOrEmpty:_doubleVerificaFirstNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaSecondNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaThirdNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaFourthNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaFifthNum.stringValue] && ![StringHelper stringIsNilOrEmpty:_doubleVerificaSixthNum.stringValue]) {
        [_doubleVerificaOkBtn setEnabled:YES];
    }else {
        [_doubleVerificaOkBtn setEnabled:NO];
    }
    
    NSDictionary *dic = notification.object;
    int codeTag = [[dic objectForKey:@"codeTag"] intValue];
    if (codeTag == 6) {
        [_doubleVerificaFifthNum becomeFirstResponder];
    } else if (codeTag == 5) {
        [_doubleVerificaFourthNum becomeFirstResponder];
    } else if (codeTag == 4) {
        [_doubleVerificaThirdNum becomeFirstResponder];
    } else if (codeTag == 3) {
        [_doubleVerificaSecondNum becomeFirstResponder];
    } else if (codeTag == 2) {
        [_doubleVerificaFirstNum becomeFirstResponder];
    } else if (codeTag == 1) {
        return;
    }
}

- (void)doubleVerificaOkBtnOperation:(id)sender {
    if ([StringHelper stringIsNilOrEmpty:_doubleVerificaFirstNum.stringValue] || [StringHelper stringIsNilOrEmpty:_doubleVerificaSecondNum.stringValue] || [StringHelper stringIsNilOrEmpty:_doubleVerificaThirdNum.stringValue] || [StringHelper stringIsNilOrEmpty:_doubleVerificaFourthNum.stringValue] || [StringHelper stringIsNilOrEmpty:_doubleVerificaFifthNum.stringValue] || [StringHelper stringIsNilOrEmpty:_doubleVerificaSixthNum.stringValue]) {
        return;
    }
    [_doubleVerificaSubTitle setHidden:YES];
    [_doubleVerificaOkBtn setEnabled:NO];
    __block long statusCode = 0;
    __block NSString *sessiontoken = nil;
    [_loadingBgView setHidden:NO];
    [_doubleVerificaVerfiyTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_doubleVerificaVerfiyTitle setHidden:NO];
    _imageLayer = [[CALayer alloc] init];
    _imageLayer.contents = [StringHelper imageNamed:@"registedLoading"];
    [_imageLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_imageLayer setFrame:CGRectMake(1 , 1 ,20,20)];
    [_loadingBgView setWantsLayer:YES];
    if (![_loadingBgView.layer.sublayers containsObject:_imageLayer]) {
        [_loadingBgView.layer addSublayer:_imageLayer];
    }
    [_loadingBgView setBackgroundColor:[NSColor clearColor]];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(2*M_PI);
    animation.toValue = 0;
    animation.repeatCount = MAXFLOAT;
    animation.duration = 2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_imageLayer addAnimation:animation forKey:@""];
    [_doubleVerificaVerfiyTitle setStringValue:CustomLocalizedString(@"iCloudLogin_View_Verify", nil)];
    if ([_delegate respondsToSelector:@selector(verifiTwoStepAuthentication:)]) {
        NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@",_doubleVerificaFirstNum.stringValue,_doubleVerificaSecondNum.stringValue,_doubleVerificaThirdNum.stringValue,_doubleVerificaFourthNum.stringValue,_doubleVerificaFifthNum.stringValue,_doubleVerificaSixthNum.stringValue];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dic = [_delegate verifiTwoStepAuthentication:str];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([dic.allKeys containsObject:@"statusCode"]) {
                    statusCode = [[dic objectForKey:@"statusCode"] longValue];
                }
                if ([dic.allKeys containsObject:@"headerdic"]) {
                    NSDictionary *headerDic = [dic objectForKey:@"headerdic"];
                    if ([headerDic.allKeys containsObject:@"X-Apple-Session-Token"]) {
                        sessiontoken = [headerDic objectForKey:@"X-Apple-Session-Token"];
                    }
                }
                /*响应码为204 则表示安全码验证成功
                 401 长时间不输入验证码 导致会话失效 需要重新走登录流程
                 400 安全码验证失败
                 423 登录太频繁
                 */
                [_doubleVerificaVerfiyTitle setHidden:YES];
                [_loadingBgView setHidden:YES];
                if (statusCode == 204) {
                    [self unloaddoubleVerificaAlertView];
                    [_delegate loginiCloudWithSessiontoken:sessiontoken];
                }else if (statusCode == 400) {
                    [_doubleVerificaSubTitle setHidden:NO];
                    [_doubleVerificaSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)]];
                    [_doubleVerificaSubTitle setStringValue:CustomLocalizedString(@"iCloudLogin_View_codeTips3", nil)];
                }else if (statusCode == 401) {
                    [_doubleVerificaSubTitle setHidden:NO];
                    [_doubleVerificaSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)]];
                    [_doubleVerificaSubTitle setStringValue:CustomLocalizedString(@"iCloudLogin_View_codeTips2", nil)];
                }else if (statusCode == 423) {
                    [_doubleVerificaSubTitle setHidden:NO];
                    [_doubleVerificaSubTitle setTextColor:[StringHelper getColorFromString:CustomColor(@"text_deleteColor", nil)]];
                    [_doubleVerificaSubTitle setStringValue:CustomLocalizedString(@"iCloudLogin_View_Input_Toomany_ErrorCode", nil)];
                }else {//重新走登录流程
                    [self unloaddoubleVerificaAlertView];
                    [_delegate loginIsSuccess:NO withAppleID:@""];
                }
                [_doubleVerificaOkBtn setEnabled:YES];
                [_imageLayer removeFromSuperlayer];
                [_imageLayer release]; _imageLayer = nil;
            });
        });
    }
}

- (void)doubleVerificaCancelBtnOperation:(id)sender {
    [self unloaddoubleVerificaAlertView];
    [_delegate cancelTwoStepAuthenticationAlertView];
}

- (void)unloaddoubleVerificaAlertView {
    NSString *str = @"open";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_doubleVerificaView.layer addAnimation:[IMBAnimation moveY:0.3 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:_doubleVerificaView.frame.size.height] repeatCount:1] forKey:@"moveY"];
    } completionHandler:^{
        [_doubleVerificaView.layer removeAnimationForKey:@"moveY"];
        [_doubleVerificaView removeFromSuperview];
        [_doubleVerificaView setFrame:NSMakeRect(ceil((NSMaxX(_mainView.bounds) - _doubleVerificaView.frame.size.width) / 2), NSMaxY(_mainView.bounds), _doubleVerificaView.frame.size.width, _doubleVerificaView.frame.size.height)];
        [self.view removeFromSuperview];
    }];
}

@end
