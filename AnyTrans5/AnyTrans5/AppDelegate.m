//
//  AppDelegate.m
//  AnyTrans5
//
//  Created by LuoLei on 16-7-11.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "AppDelegate.h"
#import "IMBDeviceConnection.h"
#import "IMBMainWindowController.h"
#import "IMBBackupManager.h"
#import "IMBSoftWareInfo.h"
#import "StringHelper.h"
#import "TempHelper.h"
#import "IMBAboutWindowController.h"
#import "IMBChooseLanguagesWindowController.h"
#import "IMBUpgradeWindowController.h"
#import "IMBSendLogFile.h"
#import "IMBLogManager.h"
#import "MediaHelper.h"
#import "TempHelper.h"
#import "IMBNotificationDefine.h"
#import "IMBPreferencesSettingWindowController.h"
#import "OperationLImitation.h"
#import "IMBAlertViewController.h"
#import "NSString+Category.h"
#import <ServiceManager/ServiceManager.h>
#import "ATTracker.h"
#import "CommonEnum.h"
#import "NSDictionary+Category.h"
#import "IMBSendLogWindowController.h"
#import "SystemHelper.h"
#import "IMBSocketClient.h"

@implementation AppDelegate
@synthesize deviceSettingMenuItem;
@synthesize ProductMenuItem;
@synthesize AboutMenuItem;
@synthesize LanguageMenuItem;
@synthesize CheckUpdate;
@synthesize SendLogMenuItem;
@synthesize restoreMenuItem;
@synthesize HideMenuItem;
@synthesize hideOtherMenuItem;
@synthesize showAllMenuItem;
@synthesize quitMenuItem;
@synthesize editMenuItem;
@synthesize undoMenuItem;
@synthesize redoMenuItem;
@synthesize cutMenuItem;
@synthesize copyMenuitem;
@synthesize pasteMenuItem;
@synthesize pasteMatchMenuItem;
@synthesize deleteMenuItem;
@synthesize selectAllMenuItem;
@synthesize windowMenuItem;
@synthesize minimizeMenuItem;
@synthesize zoomMenuItem;
@synthesize bringAllToFrontMenuItem;
@synthesize helpMenuItem;
@synthesize HomeMenuItem;
@synthesize OnlineGuideMenuItem;
@synthesize FacebookMenuItem;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return TRUE;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    ProductMenuItem.title = CustomLocalizedString(@"Menu_Product", nil);
    AboutMenuItem.title = CustomLocalizedString(@"Menu_About", nil);
    LanguageMenuItem.title = CustomLocalizedString(@"Menu_ChooseLanguage", nil);
    CheckUpdate.title = CustomLocalizedString(@"Menu_Updates", nil);
    SendLogMenuItem.title = CustomLocalizedString(@"Menu_SendLog", nil);
    HideMenuItem.title = CustomLocalizedString(@"Menu_Hide", nil);
    hideOtherMenuItem.title = CustomLocalizedString(@"Menu_HideOthers", nil);
    showAllMenuItem.title = CustomLocalizedString(@"Menu_ShowAll", nil);
    quitMenuItem.title = CustomLocalizedString(@"Menu_Quit", nil);
    editMenuItem.title = CustomLocalizedString(@"Menu_Edit", nil);
    undoMenuItem.title = CustomLocalizedString(@"Menu_Undo", nil);
    redoMenuItem.title = CustomLocalizedString(@"Menu_Redo", nil);
    cutMenuItem.title = CustomLocalizedString(@"Menu_Cut", nil);
    copyMenuitem.title = CustomLocalizedString(@"Menu_Copy", nil);
    pasteMenuItem.title = CustomLocalizedString(@"Menu_Paste", nil);
    pasteMatchMenuItem.title = CustomLocalizedString(@"Menu_PasteAndMatchStyle", nil);
    deleteMenuItem.title = CustomLocalizedString(@"Menu_Delete", nil);
    selectAllMenuItem.title = CustomLocalizedString(@"Menu_SelectAll", nil);
    windowMenuItem.title = CustomLocalizedString(@"Menu_Window", nil);
    minimizeMenuItem.title = CustomLocalizedString(@"Menu_Minimize", nil);
    zoomMenuItem.title = CustomLocalizedString(@"Menu_Zoom", nil);
    bringAllToFrontMenuItem.title = CustomLocalizedString(@"Menu_BringAlltoFront", nil);
    helpMenuItem.title = CustomLocalizedString(@"Menu_Help", nil);
    HomeMenuItem.title = CustomLocalizedString(@"Menu_Home", nil);
    OnlineGuideMenuItem.title = CustomLocalizedString(@"Menu_Guide", nil);
    FacebookMenuItem.title = CustomLocalizedString(@"Menu_FaceBook", nil);
    restoreMenuItem.title = CustomLocalizedString(@"Menu_Restore", nil);
    deviceSettingMenuItem.title = CustomLocalizedString(@"SettingMenu_Name", nil);
    chooseThemeMenuItem.title = CustomLocalizedString(@"Menu_ChooseSkin", nil);
    FAQMenuItem.title = CustomLocalizedString(@"Menu_FAQ", nil);
    tologMenuItem.title = CustomLocalizedString(@"reques_menu_title", nil);
    
    PFMoveToApplicationsFolderIfNecessary();
    //连接服务器(后台守护进程)
//    IMBSocketClient *socketClient = [IMBSocketClient singleton];
//    if ([socketClient connectServer]) {
//        socketClient.isConnect = YES;
//        [socketClient recvData];
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"AnyTransStart", @"MsgType", nil];
//        NSString *str = [IMBHelper dictionaryToJson:dic];
//        [socketClient sendData:str];
//    }else {
//        [socketClient closeSocketdfd];
//    }
//    //发送选择的语言
//    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
//    NSString *chooseStr = [NSString stringWithFormat:@"ChooseLanguage_%@",[array objectAtIndex:0]];
//    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:chooseStr, @"MsgType", nil];
//    NSString *str2 = [IMBHelper dictionaryToJson:dic2];
//    [socketClient sendData:str2];

    [ATTracker setupWithTrackingID:@"UA-85655135-1"];//UA-85655135-1   UA-85633510-3(测试)  UA-84363639-1
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:AnyTrans_OpenOrClose action:ActionNone actionParams:@"Open" label:Open transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *infoP = [[bundlePath stringByAppendingPathComponent:@"Contents"] stringByAppendingPathComponent:@"Info.plist"];
    NSMutableDictionary *infoDict = [[NSDictionary dictionaryWithContentsOfFile:infoP] mutableCopy];
    if ([[infoDict allKeys] containsObject:@"IsFirstLaunch"]) {
        if ([[infoDict objectForKey:@"IsFirstLaunch"] intValue] == 0) {
            [infoDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsFirstLaunch"];
            [infoDict writeToFile:infoP atomically:YES];
            [ATTracker event:AnyTrans_OpenOrClose action:ActionNone actionParams:@"First Launch" label:FirstLaunch transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(disableMainFrameBtn:) name:NOTIFY_TRANSFERING object:nil];

//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"first_open_guideView"];
    
    // 程序入口
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"first_launch"];
    id notfirst = [[NSUserDefaults standardUserDefaults] objectForKey:@"first_launch"];
    if (notfirst == nil) {
        IMBChooseLanguagesWindowController *chooseLanguagesWindow = [[IMBChooseLanguagesWindowController alloc]init];
        [chooseLanguagesWindow.window center];
        [NSApp runModalForWindow:chooseLanguagesWindow.window];
        [chooseLanguagesWindow  release];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"first_launch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    _mainWindowController = [[IMBMainWindowController alloc] initWithWindowNibName:@"IMBMainWindowController"];
    [_mainWindowController showWindow:nil];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_global_queue(0, 0), ^{
        if ([TempHelper checkInternetAvailble]) {
            NSString *strPath = [[TempHelper getAppSkinPath] stringByAppendingPathComponent:@"SkinConfig.plist"];
            NSString *desPath = [[TempHelper getAppSkinPath] stringByAppendingPathComponent:@"SkinConfig_default.plist"];
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:strPath]) {
                if ([fm fileExistsAtPath:desPath]) {
                    [fm removeItemAtPath:desPath error:nil];
                }
                [fm moveItemAtPath:strPath toPath:desPath error:nil];
            }
            //下载skinConfig.plist文件http://dl.imobie.com/skin/anytrans_newskin/SkinConfig.plist
            NSString *downloadUrlPath = @"http://dl.imobie.com/skin/anytrans_newskin/SkinConfig.plist";
            if (_downloadFile != nil) {
                [_downloadFile release];
                _downloadFile = nil;
            }
            _downloadFile = [[IMBDownloadFile alloc] initWithDelegate:self downloadUrlPath:downloadUrlPath isDownloadPlist:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_downloadFile downloadSpecifiedFile];
            });
        }
    });
    
    delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.7/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_global_queue(0, 0), ^{
        //软件启动就自动检查是否有更新
        [self checkForUpdateOnbackground];
    });
    
    if ([IMBSoftWareInfo singleton].isRegistered) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self softwareVerification];
        });
    }
}

- (void)downComplete:(NSString*)fileName {
    if (_downloadFile != nil) {
        [_downloadFile release];
        _downloadFile = nil;
    }
    [logHandle writeInfoLog:@"download skincomfig file complete!!!"];
}

- (void)downErrorWithFileName:(NSString*)fileName withError:(NSString*)error {
    if (_downloadFile != nil) {
        [_downloadFile release];
        _downloadFile = nil;
    }
    [logHandle writeInfoLog:@"download skincomfig file error!!!"];
}

-(void)dealloc {
    if (_iPod != nil) {
        [_iPod release];
        _iPod = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ENTER_CHANGELAGUG_IPOD object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [super dealloc];
}

- (void)doChangeLanguage:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        ProductMenuItem.title = CustomLocalizedString(@"Menu_Product", nil);
        AboutMenuItem.title = CustomLocalizedString(@"Menu_About", nil);
        LanguageMenuItem.title = CustomLocalizedString(@"Menu_ChooseLanguage", nil);
        CheckUpdate.title = CustomLocalizedString(@"Menu_Updates", nil);
        SendLogMenuItem.title = CustomLocalizedString(@"Menu_SendLog", nil);
        HideMenuItem.title = CustomLocalizedString(@"Menu_Hide", nil);
        hideOtherMenuItem.title = CustomLocalizedString(@"Menu_HideOthers", nil);
        showAllMenuItem.title = CustomLocalizedString(@"Menu_ShowAll", nil);
        quitMenuItem.title = CustomLocalizedString(@"Menu_Quit", nil);
        editMenuItem.title = CustomLocalizedString(@"Menu_Edit", nil);
        undoMenuItem.title = CustomLocalizedString(@"Menu_Undo", nil);
        redoMenuItem.title = CustomLocalizedString(@"Menu_Redo", nil);
        cutMenuItem.title = CustomLocalizedString(@"Menu_Cut", nil);
        copyMenuitem.title = CustomLocalizedString(@"Menu_Copy", nil);
        pasteMenuItem.title = CustomLocalizedString(@"Menu_Paste", nil);
        pasteMatchMenuItem.title = CustomLocalizedString(@"Menu_PasteAndMatchStyle", nil);
        deleteMenuItem.title = CustomLocalizedString(@"Menu_Delete", nil);
        selectAllMenuItem.title = CustomLocalizedString(@"Menu_SelectAll", nil);
        windowMenuItem.title = CustomLocalizedString(@"Menu_Window", nil);
        minimizeMenuItem.title = CustomLocalizedString(@"Menu_Minimize", nil);
        zoomMenuItem.title = CustomLocalizedString(@"Menu_Zoom", nil);
        bringAllToFrontMenuItem.title = CustomLocalizedString(@"Menu_BringAlltoFront", nil);
        helpMenuItem.title = CustomLocalizedString(@"Menu_Help", nil);
        HomeMenuItem.title = CustomLocalizedString(@"Menu_Home", nil);
        OnlineGuideMenuItem.title = CustomLocalizedString(@"Menu_Guide", nil);
        FacebookMenuItem.title = CustomLocalizedString(@"Menu_FaceBook", nil);
        restoreMenuItem.title = CustomLocalizedString(@"Menu_Restore", nil);
        deviceSettingMenuItem.title = CustomLocalizedString(@"SettingMenu_Name", nil);
        chooseThemeMenuItem.title = CustomLocalizedString(@"Menu_ChooseSkin", nil);
        FAQMenuItem.title = CustomLocalizedString(@"Menu_FAQ", nil);
        tologMenuItem.title = CustomLocalizedString(@"reques_menu_title", nil);
    });
}

- (void)awakeFromNib {
    logHandle = [IMBLogManager singleton];
    [logHandle writeInfoLog:@"Product Start!!!"];
    
    //启动守护进程
    [SystemHelper createLaunchDaemon];
    
    [self checkLanguage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getIpod:) name:NOTIFY_CHANGE_IPOD object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenLanguageButton:) name:NOTIFY_ENTER_CHANGELAGUG_IPOD object:nil];
    [deviceSettingMenuItem setEnabled:NO];
    [deviceSettingMenuItem.menu setAutoenablesItems:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [IMBSoftWareInfo singleton];
}

-(void)getIpod:(NSNotification *)notification {
    IMBDeviceConnection *deviceConntection = [IMBDeviceConnection singleton];
    NSMutableArray *ary = [deviceConntection getAllDevice];
    if (ary.count >0 &&_mainWindowController.curFunctionType == DeviceModule) {
        [deviceSettingMenuItem setEnabled:YES];
        [deviceSettingMenuItem.menu setAutoenablesItems:YES];
    }else {
        [deviceSettingMenuItem setEnabled:NO];
        [deviceSettingMenuItem.menu setAutoenablesItems:NO];
    }
}

- (void)softwareVerification {
    IMBSoftWareInfo *softInfo = [IMBSoftWareInfo singleton];
    //    [logHandle writeInfoLog:[NSString stringWithFormat:@"software RegisteredStatus:%d",softInfo.RegisteredStatus]];
    //    if (softInfo.RegisteredStatus == Activate_Temporary) {
    if (softInfo.RegisteredStatus == Activate_OnLine) {
        BOOL result = NO;
       
        NSString *errorStr = @"";
        NSString *machineCode = [[IMBHWInfo singleton] platformSerialNumber];
        //        int i = arc4random() % 10;
        if (softInfo.verificationCount >= 10 && [TempHelper isInternetAvail]) {//在线认证
            sleep(3);
            machineCode = [[IMBHWInfo singleton] platformSerialNumber];
            NSURL *url = [TempHelper getHashWebserviceUrl];
            NSString *nameSpace = [TempHelper getHashWebserviceNameSpace];
            NSString *valStr = [self getHashByWebservice:url nameSpace:nameSpace methodName:@"validation_licence" sha1:softInfo.registeredCode sha2:machineCode];
            [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"verification reslut:%@",valStr]];
            if ([valStr isEqualToString:@"000"]) {
                result = YES;
            }else if ([valStr isEqualToString:@"001"]) {
                result = NO;
                errorStr = NSLocalizedString(@"activate_error_code_1", nil);
            }else if ([valStr isEqualToString:@"002"]) {
                result = NO;
                errorStr = NSLocalizedString(@"activate_error_expired", nil);
            }
            else if ([valStr isEqualToString:@"016"]) {//机器码解绑
                result = NO;
                errorStr = NSLocalizedString(@"activate_error_code_10", nil);
            }
            else {
                result = NO;
                errorStr = NSLocalizedString(@"activate_error_onlineFailed", nil);
            }
            softInfo.verificationCount = 0;
            if (result == NO) {//验证失败后，未对界面上做出相应处理
                //主线程中弹出提示框
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_REGISTER_CHECK_FAIL object:errorStr];
                softInfo.isRegistered = YES;
            }
            [self savePlist];
        }else {//本地认证
            softInfo.verificationCount ++;
            if (![StringHelper stringIsNilOrEmpty:softInfo.registeredCode]) {
                KeyStateStruct *ks = [softInfo.verifyLicense verifyProductLicense:softInfo.registeredCode];
                if (ks->valid == NO) {
                    softInfo.isRegistered = YES;
                    result = NO;
                    errorStr = CustomLocalizedString(@"activate_error_onlineFailed", nil);
                }else {
                    result = YES;
                    softInfo.isRegistered = YES;
                }
            }else {
                softInfo.isRegistered = YES;
                result = NO;
                errorStr = CustomLocalizedString(@"activate_error_onlineFailed", nil);
            }
            if (result == NO) {
                //主线程中弹出提示框
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_REGISTER_CHECK_FAIL object:errorStr];
            }
            [self savePlist];
        }
    }else {
        softInfo.verificationCount ++;
        if (![StringHelper stringIsNilOrEmpty:softInfo.registeredCode]) {
            KeyStateStruct *ks = [softInfo.verifyLicense verifyProductLicense:softInfo.registeredCode];
            if (ks->valid == NO) {
                softInfo.isRegistered = YES;
            }
        }else {
            softInfo.isRegistered = YES;
        }
        if (softInfo.isRegistered == NO) {
            NSString *errorStr = CustomLocalizedString(@"activate_error_onlineFailed", nil);
            //主线程中弹出提示框
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_REGISTER_CHECK_FAIL object:errorStr];
        }
        [self savePlist];
    }
}

- (NSString *)getHashByWebservice:(NSURL*)url nameSpace:(NSString*)nameSpace methodName:(NSString*)methodName sha1:(NSString *)sha1 sha2:(NSString *)sha2 {
    WSMethodInvocationRef mySoapRef = WSMethodInvocationCreate((CFURLRef)url, (CFStringRef)methodName, kWSSOAP2001Protocol);
    
    if (sha1 != nil && sha2 == nil) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:sha1, @"fileSha1", nil];
        NSArray *paramOrder = [NSArray arrayWithObjects:@"fileSha1", nil];
        WSMethodInvocationSetParameters(mySoapRef, (CFDictionaryRef)params, (CFArrayRef)paramOrder);
    }
    
    if (sha1 != nil && sha2 != nil) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:sha1, @"fileSha1", sha2, @"fileSha2", nil];
        NSArray *paramOrder = [NSArray arrayWithObjects:@"fileSha1", @"fileSha2", nil];
        WSMethodInvocationSetParameters(mySoapRef, (CFDictionaryRef)params, (CFArrayRef)paramOrder);
    }
    
    NSDictionary *reqHeaders = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@#validation# %@", nameSpace, methodName] forKey:@"SOAPAction"];
    WSMethodInvocationSetProperty(mySoapRef, kWSSOAPMethodNamespaceURI,
                                  (CFStringRef)nameSpace);
    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPExtraHeaders,
                                  (CFDictionaryRef)reqHeaders);
    WSMethodInvocationSetProperty(mySoapRef, kWSHTTPFollowsRedirects,
                                  kCFBooleanTrue);
    // set debug props
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingBody,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugIncomingHeaders,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingBody,
                                  kCFBooleanTrue);
    WSMethodInvocationSetProperty(mySoapRef, kWSDebugOutgoingHeaders,
                                  kCFBooleanTrue);
    
    NSDictionary *result = (NSDictionary *)WSMethodInvocationInvoke(mySoapRef);
    // get HTTP response from SOAP request so we can see the status code
    //    CFHTTPMessageRef res = (CFHTTPMessageRef)[result objectForKey:(id)kWSHTTPResponseMessage];
    NSDictionary *resultDir = [result objectForKey:@"/Result"];
    NSLog(@"hash72 result: %@",[resultDir description]);
    NSArray *keyArr = [resultDir allKeys];
    NSString *hashStr = nil;
    for (NSString *key in keyArr) {
        hashStr = [resultDir valueForKey:key];
    }
    return hashStr;
}

- (void)savePlist {
    NSString *path = [TempHelper resourcePathOfAppDir:@"IMBSoftware-Info" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    IMBSoftWareInfo *softInfo = [IMBSoftWareInfo singleton];
    if (softInfo.RegisteredStatus == Activate_OnLine) {
        [dic setValue:[NSNumber numberWithInt:softInfo.verificationCount] forKey:@"verificationCount"];
    }
    
    if (softInfo.isRegistered == NO) {
        [dic setValue:[NSNumber numberWithBool:softInfo.isRegistered] forKey:@"IsRegistered"];
    }
    [dic writeToFile:path atomically:TRUE];
    [dic release];
}

- (IBAction)deviceSettingMenuDown:(id)sender {
    IMBDeviceConnection *deviceConntection = [IMBDeviceConnection singleton];
    NSMutableArray *ary = [deviceConntection getAllDevice];
    NSString *uniqueKey = nil;
    for (IMBBaseInfo *baseInfo in ary) {
        if (baseInfo.isSelected) {
            uniqueKey = baseInfo.uniqueKey;
        }
    }
    if (_iPod != nil) {
        [_iPod release];
        _iPod = nil;
    }
    _iPod = [[deviceConntection getIPodByKey:uniqueKey] retain];
    IMBPreferencesSettingWindowController *preferencesSetting = [[IMBPreferencesSettingWindowController alloc]initWithIpod:_iPod];
    [NSApp runModalForWindow:preferencesSetting.window];
}

- (IBAction)aboutAnyTransMenuClick:(id)sender {
    IMBAboutWindowController *abouWd = [[IMBAboutWindowController alloc]initWithWindowNibName:@"IMBAboutWindowController"];
    NSWindow *mainWindow = [NSApp mainWindow];
    NSRect rect = mainWindow.frame;
    NSPoint point = mainWindow.frame.origin;
    float height = abouWd.window.frame.size.height;
    float width = abouWd.window.frame.size.width;
    [abouWd.window setFrameOrigin:NSMakePoint(point.x+(rect.size.width-width)/2, point.y+(rect.size.height-height)/2)];
    [NSApp runModalForWindow:[abouWd window]];
}

- (IBAction)chooseLanguageMenuClick:(id)sender {
    IMBChooseLanguagesWindowController *chooseLanguagesWindow = [[IMBChooseLanguagesWindowController alloc]init];
    NSWindow *mainWindow = [NSApp mainWindow];
    NSRect rect = mainWindow.frame;
    NSPoint point = mainWindow.frame.origin;
    float height = chooseLanguagesWindow.window.frame.size.height;
    float width = chooseLanguagesWindow.window.frame.size.width;
    [chooseLanguagesWindow.window setFrameOrigin:NSMakePoint(point.x+(rect.size.width-width)/2, point.y+(rect.size.height-height)/2)];
    [NSApp runModalForWindow:chooseLanguagesWindow.window];
    [chooseLanguagesWindow  release];
}

- (IBAction)checkUpdateMenuClick:(id)sender {
    [self showUpgradeWindow];
}

- (IBAction)sendLogMenuClick:(id)sender {
    IMBSendLogWindowController *abouWd = [[IMBSendLogWindowController alloc]initWithWindowNibName:@"IMBSendLogWindowController"];
    NSWindow *mainWindow = [NSApp mainWindow];
    NSRect rect = mainWindow.frame;
    NSPoint point = mainWindow.frame.origin;
    float height = abouWd.window.frame.size.height;
    float width = abouWd.window.frame.size.width;
    [abouWd.window setFrameOrigin:NSMakePoint(point.x+(rect.size.width-width)/2, point.y+(rect.size.height-height)/2)];
    [NSApp runModalForWindow:[abouWd window]];

//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self sendFileLogToUs];
//    });
}

- (IBAction)restoreMediaLibMenuClick:(id)sender {
}

- (IBAction)anyTransHomeMenuClick:(id)sender {
    NSURL *url = nil;
    url = [NSURL URLWithString:CustomLocalizedString(@"Product_Url", nil)];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (IBAction)onlineGuideMenuClick:(id)sender {
    NSURL *url = nil;
    url = [NSURL URLWithString:CustomLocalizedString(@"anytrans_guide", nil)];
    
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (IBAction)facebookMenuClick:(id)sender {
    NSString *faceStr = @"";
    faceStr = @"http://www.facebook.com/iMobie";
    NSURL *url = [NSURL URLWithString:faceStr];;
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (IBAction)doChooseTheme:(id)sender {
    [_mainWindowController getSkinBtnEnable];
}

- (IBAction)doFAQ:(id)sender {
    NSString *FAQStr = CustomLocalizedString(@"FAQ_Url", nil);
    NSURL *url = [NSURL URLWithString:FAQStr];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (IBAction)toLogMenuClick:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://my.imobie.com/support/create_ticket.php"];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)disableMainFrameBtn:(NSNotification *)notification {
    BOOL isDisable = [notification.object boolValue];
    [chooseThemeMenuItem setEnabled:isDisable];
}

#pragma mark - check update
- (void)showUpgradeWindow {
    _hasCheckUpdateBymanual = YES;
    if (_checkUpdateController != nil) {
        [_checkUpdateController release];
        _checkUpdateController = nil;
    }
    _checkUpdateController = [[IMBUpgradeWindowController alloc] init];
    if (_checkUpdater) {
        [_checkUpdater release];
        _checkUpdater = nil;
    }
    _checkUpdater = [[IMBCheckUpdater alloc] initWithManual:YES];
    [_checkUpdater setListener:self];
    [_checkUpdater checkUpdate];
    NSModalSession session =  [NSApp beginModalSessionForWindow:[_checkUpdateController window]];
    NSInteger result = NSRunContinuesResponse;
    while ((result= [NSApp runModalSession:session]) == NSRunContinuesResponse) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    [NSApp endModalSession:session];
    [self checkIfMustUpdate];
}

-(void)checkForUpdateOnbackground {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_checkUpdater) {
            [_checkUpdater release];
            _checkUpdater = nil;
        }
        _checkUpdater = [[IMBCheckUpdater alloc] initWithManual:NO];
        [_checkUpdater setListener:self];
        [_checkUpdater checkUpdate];
    });
}

- (void)showUpdatewindowByBackGround:(IMBUpdateInfo *)info{
    if (_checkUpdateController != nil) {
        [_checkUpdateController release];
        _checkUpdateController = nil;
    }
    _checkUpdateController = [[IMBUpgradeWindowController alloc] initWithUpdateInfo:info];
    [NSApp runModalForWindow:[_checkUpdateController window]];
}

- (void)UpdaterStatus:(UpdaterStatus)status UpdateInfo:(IMBUpdateInfo *)info Manual:(BOOL)isManual {
    if (isManual) {
        [_checkUpdateController updaterStatus:status UpdateInfo:info];
    } else {
        if (status == UpdaterStatus_Skip_Version && !_hasCheckUpdateBymanual && info.isauto == YES) {
            return;
        } else if (status == UpdaterStatus_HasUpdate && !_hasCheckUpdateBymanual && info.isauto == YES) {
            [self showUpdatewindowByBackGround:info];
        } else {
            BOOL result = [self checkIfMustUpdate];
            if (result) {
                // Todo other handle
                [self showUpdatewindowByBackGround:info];
            }
        }
    }
}

- (BOOL)checkIfMustUpdate {
    //检查当前是否是必须更新，如果是则回到设备未链接界面。
    IMBSoftWareInfo *software = [IMBSoftWareInfo singleton];
    if (software.mustUpdate) {
        return YES;
    }
    return NO;
}

#pragma mark _ sendLog
- (void)sendFileLogToUs {
    IMBSendLogFile *sendLog = [[IMBSendLogFile alloc] init];
    @try {
        [sendLog sendLogFile];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *logFilePath = sendLog.sendLogZipPath;
        if ([fm fileExistsAtPath:logFilePath]) {
            // 当日志文件已经存在了就将他移动到一个位置进行弹出
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *logZipFolder = [documentPath stringByAppendingPathComponent:@"iMobieSendLogs"];
            if (![fm fileExistsAtPath:logZipFolder]) {
                [fm createDirectoryAtPath:logZipFolder withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *targetFilePath = [logZipFolder stringByAppendingPathComponent:logFilePath.lastPathComponent];
            if ([fm fileExistsAtPath:targetFilePath]) {
                [fm removeItemAtPath:targetFilePath error:nil];
            }
            [fm moveItemAtPath:logFilePath toPath:targetFilePath error:nil];
            [[NSWorkspace sharedWorkspace] selectFile:targetFilePath inFileViewerRootedAtPath:nil];
        }
        

    }
    @catch (NSException *exception) {
        [logHandle writeInfoLog:@"Send Log-File failed!"];
    }
    [sendLog release];
    sendLog = nil;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [logHandle writeInfoLog:@"application exit normally!!!"];
    [SystemHelper runningApplicationTerminateIdentifier:@"com.imobie.ATHHostSync64"];
    [SystemHelper runningApplicationTerminateIdentifier:@"com.imobie.ATHHostSync32"];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:AnyTrans_OpenOrClose action:ActionNone actionParams:@"Exit" label:Exit transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:NOTIFY_TRANSFERING object:nil];
    [[IMBAdbManager singleton] runADBCommand:[[IMBAdbManager singleton] killServer]];
    // 应用程序关闭前对某些目录进行清空
    OperationLImitation *Limit = [OperationLImitation singleton];
    [Limit save];
    NSString *appTempPath = [TempHelper getAppTempPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:appTempPath]) {
        [fm removeItemAtPath:appTempPath error:nil];
    }
    
    //关闭socket
    IMBSocketClient *socketClient = [IMBSocketClient singleton];
    if (socketClient.isConnect) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"CloseSocketd", @"MsgType", nil];
        NSString *str = [IMBHelper dictionaryToJson:dic];
        [socketClient sendData:str];
        [socketClient closeSocketdfd];
    }
    
    //释放所有的单例
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    [self destroyDealloc:deviceConnection];
}

- (void)destroyDealloc:(id)singleton {
    if ([singleton retainCount] != 1){
        return;
    }
    [singleton release];
    singleton = nil;
}

- (void)checkLanguage {
    NSArray *defineLang = @[@"en", @"ja", @"de", @"fr", @"es",@"ar",@"zh"];
    NSArray *checkLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSMutableArray *chooseLang = [[NSMutableArray alloc] init];
    NSString *_langStr = @"";
    for (NSString *langStr in checkLang) {
        if (![defineLang containsObject:langStr]) {
            continue;
        }
        _langStr = langStr;
        break;
    }
    NSString *langPath = [[NSBundle mainBundle] pathForResource:_langStr ofType:@".lproj"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:langPath]) {
        _langStr = @"en";
    }
    if ([StringHelper stringIsNilOrEmpty:_langStr]) {
        _langStr = @"en";
    }
    [chooseLang addObject:_langStr];
    [[NSUserDefaults standardUserDefaults] setObject:chooseLang forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];

#if !__has_feature(objc_arc)
    if (chooseLang) [chooseLang release]; chooseLang = nil;
#endif
    if ([_langStr isEqualToString:@"en"]) {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:EnglishLanguage];
    }else if ([_langStr isEqualToString:@"ja"]) {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:JapaneseLanguage];
    }else if ([_langStr isEqualToString:@"de"]) {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:GermanLanguage];
    }else if ([_langStr isEqualToString:@"fr"]) {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:FrenchLanguage];
    }else if ([_langStr isEqualToString:@"es"]) {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:SpanishLanguage];
    }else if ([_langStr isEqualToString:@"ar"]) {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:ArabLanguage];
    }else if ([_langStr isEqualToString:@"zh"]) {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:ChinaLanguage];
    }else {
        [[IMBSoftWareInfo singleton] setChooseLanguageType:EnglishLanguage];
    }
}

- (void)screenLanguageButton:(NSNotification *)obj{
    NSString *str = obj.object;
    if ([str isEqualToString:@"open"]) {
        [LanguageMenuItem setEnabled:YES];
        [LanguageMenuItem.menu setAutoenablesItems:YES];
    }else{
        [LanguageMenuItem setEnabled:NO];
        [LanguageMenuItem.menu setAutoenablesItems:NO];
    }
}
@end
