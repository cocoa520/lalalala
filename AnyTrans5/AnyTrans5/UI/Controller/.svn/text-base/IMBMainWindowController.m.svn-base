//
//  IMBMainWindowController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBMainWindowController.h"
#import "IMBNavigationViewController.h"
#import "IMBitunesLibraryViewController.h"
#import "IMBDeviceViewController.h"
#import "IMBShoppingCarViewController.h"
#import "IMBBackupViewController.h"
#import "CALayer+Animation.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
#import "IMBSoftWareInfo.h"
#import "SystemHelper.h"
#import "IMBNoTitleBarWindow.h"
#import "RegexKitLite.h"
#import "IMBSearchFieldCell.h"
#import "NSColor+Category.h"
#import "ATTracker.h"
#import "CommonEnum.h"
#import "IMBSkinSwitchViewController.h"
#import "IMBVideoDownloadViewController.h"
#import "IMBiCloudMainPageViewController.h"
#import "DownLoadView.h"
#import "IMBAdConnectPopoverViewController.h"
#import "IMBAirWifiBackupViewController.h"
#import "IMBBackupViewController.h"
@interface IMBMainWindowController ()

@end

@implementation IMBMainWindowController
@synthesize appleID = _appleID;
@synthesize connectDic = _connectDic;
@synthesize connectiCloudTotalArray = _connectiCloudTotalArray;
@synthesize connectiPodTotalArray = _connectiPodTotalArray;
@synthesize curFunctionType = _curFunctionType;
@synthesize searchView = _searchView;
@synthesize buyView = _buyView;

- (id)initWithWindowNibName:(NSString *)windowNibName
{
    if (self = [super initWithWindowNibName:windowNibName]) {
        _isConnectDevice = NO;
        _contentDic = [[NSMutableDictionary dictionary] retain];
        _connectDic = [[NSMutableDictionary alloc] init];
        _connectiCloudTotalArray = [[NSMutableArray alloc] init];
        _connectiPodTotalArray = [[NSMutableArray alloc] init];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(doRegisterCheckFail:) name:NOTIFY_REGISTER_CHECK_FAIL object:nil];
        [nc addObserver:self selector:@selector(deviceBtnChange:) name:DeviceBtnChangeNotification object:nil];
        [nc addObserver:self selector:@selector(deviceNeedPassword:) name:DeviceNeedPasswordNotification object:nil];
        [nc addObserver:self selector:@selector(registSuccess) name:NOTIFY_BACK_MAINVIEW object:nil];
        [nc addObserver:self selector:@selector(registSuccess) name:ANNOY_REGIST_SUCCESS object:nil];
        [nc addObserver:self selector:@selector(disableMainFrameBtn:) name:NOTIFY_TRANSFERING object:nil];
        [nc addObserver:self selector:@selector(loadGuideView:) name:NOTIFY_LOAD_GUIDE_VIEW object:nil];
        [nc addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
        [nc addObserver:self selector:@selector(jumpToiCloudLoginView:) name:NOTIFY_JUMP_ICLOUD_VIEW object:nil];
        [nc addObserver:self selector:@selector(jumpToBackupView:) name:NOTIFY_JUMP_BACKUP_VIEW object:nil];
    }
    return self;
}

- (void)changeSkin:(NSNotification *)notification {
//    [_topView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
//    [_topView setIsGradientNoCornerPart1:YES];
    [_topLineView.layer setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)].toCGColor];
    [_mainframeButtonBar setNeedsDisplay:YES];
    [[(IMBNoTitleBarWindow *)self.window maxAndminView] setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [self changeSelectDeviceBtn:_curFunctionType];
    [_mainContentView setNeedsDisplay:YES];
    [_topView setNeedsDisplay:YES];
}

- (void)loadGuideView:(NSNotification *)notification {
    BOOL notfirst = [[[NSUserDefaults standardUserDefaults] objectForKey:@"first_open_guideView"] boolValue] ;
    if (_curFunctionType == DeviceModule && !notfirst) {
        [_guideBoxView setHidden:NO];
        _isDevice = YES;
        [IMBSoftWareInfo singleton].isLoadGuideView = YES;
         [_adPopover close];
        _guideViewController = [[IMBGuideViewController alloc] initWithDeviceWide:_selectDeviceBtn.frame.size.width];
        [_guideBoxView setContentView:_guideViewController.view];
        [_guideBoxView setWantsLayer:YES];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"first_open_guideView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GUIDEVIEW_OPEN object:_guideViewController];
    }
}

-(void)doChangeLanguage:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self changeSelectDeviceBtn:_curFunctionType];
    });
}

- (void)guideViewClose{
    [IMBSoftWareInfo singleton].isLoadGuideView = NO;
    [_guideBoxView setHidden:YES];
//    [self androidConnectPopoverView];
}

- (void)awakeFromNib {
    //毛玻璃效果暂时没用；
//    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
//        NSControl *effectView = [[NSClassFromString(@"NSVisualEffectView") alloc] initWithFrame:NSMakeRect(0, 0, _topView.frame.size.width, _topView.frame.size.height)];
//        effectView.autoresizesSubviews =YES;
//        effectView.autoresizingMask = 1 | 2 | 4 | 8 | 16 | 32;
//        [effectView setState:1];
//        
//        IMBWhiteView *bgView = [[IMBWhiteView alloc] initWithFrame:NSMakeRect(0, 0, _topView.frame.size.width, _topView.frame.size.height)];
//        [bgView setBackgroundColor:[NSColor colorWithDeviceRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:0.6]];
//        bgView.autoresizesSubviews =YES;
//        bgView.autoresizingMask = 1 | 2 | 4 | 8 | 16 | 32;
//        [effectView addSubview:bgView];
//        
//        [_topView addSubview:effectView positioned:NSWindowBelow relativeTo:_selectDeviceBtn];
//        
//        [bgView release];
//        [effectView release];
//    }
//    NSLog(@"self.window.frame1:%f,%f",self.window.frame.size.width,self.window.frame.size.height);
    _mainFrameBtnIsEnable = YES;
    if ([IMBSoftWareInfo singleton].isRegistered) {
        [_buyView setHidden:YES];
    }
    NSRect screenRect = [NSScreen mainScreen].frame;
    [self.window setMaxSize:NSMakeSize(screenRect.size.width, screenRect.size.height)];
    [self.window setMinSize:NSMakeSize(1060, 635)];
    
    [_guideBoxView setHidden:YES];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guideViewremove) name:NOTIFY_GUIDEVIEW_RELELE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshBuyView) name:CLOSE_SHOPPING_VIEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadiTunesData) name:NOTIFY_LOAD_ITUNES_DATA object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guideViewOpen:) name:NOTIFY_GUIDEVIEW_OPEN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guideViewClose) name:NOTIFY_GUIDEVIEW_CLOSE object:nil];


    [(NSView *)((IMBNoTitleBarWindow *)self.window).maxAndminView setFrameOrigin:NSMakePoint(10,NSHeight(_topView.frame) - 36)];
    [[(IMBNoTitleBarWindow *)self.window closeButton] setAction:@selector(closeWindow:)];
    [[(IMBNoTitleBarWindow *)self.window closeButton] setTarget:self];
    [_topView addSubview:((IMBNoTitleBarWindow *)self.window).maxAndminView];
    [_topView initWithLuCorner:YES LbCorner:NO RuCorner:YES RbConer:NO CornerRadius:5];
    [_topView setWantsLayer:YES];
    [_topView.layer setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)].toCGColor];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeLanguage:) name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    
    _deviceConnection = [IMBDeviceConnection singleton];
    _accountLogin = [[IMBiCloudNetClient alloc] init];
    [_topLineView setWantsLayer:YES];
    [_topLineView.layer setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)].toCGColor];
    _mainframeButtonBar = [[IMBMainFrameButtonBarView alloc] initwithFunctionModulBlock:^(FunctionType type) {
        [self changeViewController:type ];
    }];
//    NSData *data  =  [NSData dataWithContentsOfFile:pdfFilePath];
//    NSImage *sourceImage1 = [[NSImage alloc] initWithData:data];
//    NSImage *simage1 = [[NSImage alloc]initWithContentsOfFile:pdfFilePath];
//    NSImage *image1 = [NSImage imageNamed:@"545587"];
//    [guideImg setImage:sourceImage];
    [_mainframeButtonBar setWantsLayer:YES];
    [_mainframeButtonBar setCanDrawConcurrently:NO];
    NSSetUncaughtExceptionHandler (&CrashHandlerExceptionHandler);
    [_mainframeButtonBar setFrameOrigin:NSMakePoint((_topView.frame.size.width - _mainframeButtonBar.frame.size.width ) / 2.0 + 32, (NSHeight(_topView.frame)-FunctionButtonHight)/2.0 + 2)];
    [_topView setAutoresizesSubviews:YES];
    [_mainframeButtonBar setAutoresizingMask:NSViewMinYMargin | NSViewMinXMargin | NSViewMaxXMargin];
    [_topView addSubview:_mainframeButtonBar];
    [_contentBoxView setWantsLayer:YES];
    [_selectDeviceBtn setWantsLayer:YES];
    [_topView setNeedsDisplay:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:REFREASH_TOPVIEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showInternetErrorAlert:) name:NOTIFY_CREAT_CIG_ERROR object:nil];
    _alertView = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
    _appleID = nil;
    [_searchView setTarget:self];
    [_searchView setAction:@selector(openSearchView:)];
    [self addMouseEventTracking];
    [_searchView.searchField setTarget:self];
    [_searchView.searchField setAction:@selector(doSearch:)];
    [_buyView setTarget:self];
    [_buyView setAction:@selector(doBuyClick:)];
    [_helpView setTarget:self];
    [_helpView setAction:@selector(doHelpClick:)];
    [_searchView.searchField addObserver:self forKeyPath:@"stringValue" options:NSKeyValueObservingOptionNew context:nil];
    [_searchView addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
    [_buyView setIsOpen:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(andriodDeviceDisconnect:) name:Andriod_Device_Disconnect object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"stringValue"]) {
        if ([StringHelper stringIsNilOrEmpty:_searchView.searchField.stringValue]) {
            [self closeSearchView];
        }
    }else if ([keyPath isEqualToString:@"hidden"]) {
        if (_searchView.isHidden) {
            [_helpView setHidden:NO];
            if (_buyView.frame.size.width < 108) {
                [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                    context.duration = 0.5;
                    NSRect newRect = NSMakeRect(_buyView.frame.origin.x, _buyView.frame.origin.y, 108, _buyView.frame.size.height);
                    [[_buyView animator] setFrame:newRect];
                    [_buyView setIsOpen:YES];
                    [_buyView setNeedsDisplay:YES];
                } completionHandler:^{
                    
                }];
            }
        }else {
            [_helpView setHidden:YES];
        }
    }
}

#pragma mark - 点击搜索按钮
- (void)doSearch:(id)sender {
    IMBBaseViewController *viewController = [_contentDic objectForKey:[FunctionTypeEnum functionTypeToString:_curFunctionType]];
    [(IMBBaseViewController*)[(IMBNavigationViewController *)viewController currentViewController] doSearchBtn:_searchView.stringValue withSearchBtn:_searchView];
}

#pragma mark - 点击buy按钮
- (void)doBuyClick:(id)sender {
    [_buyView setAlphaValue:0.3];
    if (_shopCarViewController == nil) {
        _shopCarViewController = [[IMBShoppingCarViewController alloc] init];
    }
    if ([_mainContentView.subviews containsObject:_shopCarViewController.view]) {
        return;
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [[OperationLImitation singleton] setLimitStatus:@"notactivate"];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:AnyTrans_Activation action:AdAnnoy actionParams:@"notactivate" label:LabelNone transferCount:0 screenView:@"AnyTrans Activation" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSDictionary *dimensionDicts = nil;
    @autoreleasepool {
        [[OperationLImitation singleton] setLimitStatus:@"notactivate"];
        dimensionDicts = [[TempHelper customDimension] copy];
    }
    [ATTracker event:AnyTrans_Activation action:ActionNone actionParams:@"notactivate" label:Activate transferCount:0 screenView:@"AnyTrans Activation" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDicts];
    if (dimensionDicts) {
        [dimensionDicts release];
        dimensionDicts = nil;
    }
    if (![StringHelper stringIsNilOrEmpty:_searchView.searchField.stringValue]) {
        [_searchView.searchField setStringValue:@""];
        [self doSearch:nil];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_shopCarViewController.view setWantsLayer:YES];
        [_mainContentView addSubview:_shopCarViewController.view];
        [_shopCarViewController.view setFrame:NSMakeRect(_mainContentView.frame.origin.x, _mainContentView.frame.origin.y, _mainContentView.frame.size.width, _mainContentView.frame.size.height - 60)];
        [_shopCarViewController.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [_shopCarViewController.view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-_shopCarViewController.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_buyView setIsClick:NO];
        });
    });
}

- (void)refreshBuyView {
    [_buyView setAlphaValue:1.0];
    [_buyView setIsClick:NO];
}

#pragma mark - 点击help按钮
- (void)doHelpClick:(id)sender {
    NSURL *url = [NSURL URLWithString:CustomLocalizedString(@"FAQ_Url", nil)];
    NSWorkspace *ws = [NSWorkspace sharedWorkspace];
    [ws openURL:url];
}

- (void)refreshView {
    [_mainContentView setNeedsDisplay:YES];
}
//切换视图
- (void)changeViewController:(FunctionType)functionType {
    if (functionType == iTunesLibraryModule) {
        [[IMBSoftWareInfo singleton] setBuyId:1];
    }else if (functionType == BackupModule) {
        [[IMBSoftWareInfo singleton] setBuyId:2];
    }else if (functionType == AirBackupModule) {
        [[IMBSoftWareInfo singleton] setBuyId:3];
    }else if (functionType == DeviceModule) {
        [[IMBSoftWareInfo singleton] setBuyId:4];
    }else if (functionType == AndroidModule) {
        [[IMBSoftWareInfo singleton] setBuyId:5];
    }else if (functionType == iCloudModule) {
        [[IMBSoftWareInfo singleton] setBuyId:6];
    }else if (functionType == VideoDownloadModule) {
        [[IMBSoftWareInfo singleton] setBuyId:7];
    }
    
    if ([_mainContentView.subviews containsObject:_shopCarViewController.view]) {
        [_shopCarViewController.view removeFromSuperview];
        [_buyView setAlphaValue:1.0];
    }
    [self closeSearchView];
    [_searchView.searchField setStringValue:@""];
    _curFunctionType = functionType;
    IMBNavigationViewController *navigationController = [_contentDic objectForKey:[FunctionTypeEnum functionTypeToString:functionType]];
    IMBBaseViewController *viewController = nil;
    if (!navigationController) {
        [_rightUpDownbgView setHidden:YES];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        if (functionType == iTunesLibraryModule) {
            [ATTracker event:iTunes_Library action:ActionNone actionParams:@"iTunes Library" label:Switch transferCount:0 screenView:@"iTunes Library" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            viewController = [[IMBitunesLibraryViewController alloc] init];
            [viewController setDelegate:self];
        }else if (functionType == BackupModule){
            [ATTracker event:iTunes_Backup action:ActionNone actionParams:@"Backup Manager" label:Switch transferCount:0 screenView:@"Backup Manager" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            viewController = [[IMBBackupViewController alloc] init];
            [viewController setDelegate:self];
            _backupVC = (IMBBackupViewController *)viewController;
        }else if (functionType == AirBackupModule) {
            [ATTracker event:Air_Backup action:ActionNone actionParams:@"Air Backup" label:Switch transferCount:0 screenView:@"Air Backup Manager" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            viewController = [[IMBAirWifiBackupViewController alloc] init];
            [viewController setDelegate:self];
            
        }else if (functionType == iCloudModule){
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Manager" label:Switch transferCount:0 screenView:@"iCloud Manager" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            viewController = [[IMBiCloudViewController alloc] init];
            [viewController setDelegate:self];
            ((IMBiCloudViewController *)viewController)->_selectDeviceButton = _selectDeviceBtn;
            _icloudVC = ((IMBiCloudViewController *)viewController);
        }else if (functionType == DeviceModule){
            [ATTracker event:Device_Content action:ActionNone actionParams:@"Device Content" label:Switch transferCount:0 screenView:@"Device Content" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            viewController = [[IMBDeviceViewController alloc] init];
            [viewController setDelegate:self];
            ((IMBBaseViewController *)viewController)->_mainWindow = self.window;
            //创建好Android设备的未连接页面
            IMBBaseViewController *androidViewController = [[IMBAndroidViewController alloc] initWithDelegate:self];
            ((IMBBaseViewController *)androidViewController)->_mainWindow = self.window;
            IMBNavigationViewController *androidNavigationController = [[IMBNavigationViewController alloc] initWithRootViewController:androidViewController box:_contentBoxView];
            [_contentDic setObject:androidNavigationController forKey:[FunctionTypeEnum functionTypeToString:AndroidModule]];
            [androidViewController setSearchFieldBtn:_searchView];
            [_hiddenView addSubview:androidViewController.view];
            [androidViewController release];
            [androidNavigationController release];
        }else if (functionType == SkinModule){
            [ATTracker event:Skin_Theme action:ActionNone actionParams:@"Appearance" label:Switch transferCount:0 screenView:@"Appearance" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            viewController = [[IMBSkinSwitchViewController alloc] init];
        }else if (functionType == VideoDownloadModule){
            [ATTracker event:Video_Download action:ActionNone actionParams:@"Media Downloader" label:Switch transferCount:0 screenView:@"Media Downloader" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            HoverButton *downloadButton = [[HoverButton alloc] init];
            [downloadButton setMouseEnteredImage:[StringHelper imageNamed:@"download_progress1"] mouseExitImage:[StringHelper imageNamed:@"download_progress1"] mouseDownImage:[StringHelper imageNamed:@"download_progress1"]];
            DownLoadView *bgView = [[DownLoadView alloc] initWithFrame:NSMakeRect(NSWidth(_topView.frame) - 48, (NSHeight(_topView.frame) - 26)/2, 38, 30)];
            [downloadButton setFrame:NSMakeRect(ceilf((NSWidth(bgView.frame) - 22)/2) , ceilf((NSHeight(bgView.frame) - 22)/2), 22, 22)];
            downloadButton.tag = 100;
            [bgView addSubview:downloadButton];
            [bgView addOBServer];
            [bgView setAutoresizesSubviews:YES];
            [bgView setAutoresizingMask:NSViewMinXMargin];
            [_topView addSubview:bgView];
            viewController = [[IMBVideoDownloadViewController alloc] init];
            [viewController setDelegate:self];
            ((IMBVideoDownloadViewController *)viewController)->_rightUpDownbgView = bgView;
            _rightUpDownbgView = bgView;
            [downloadButton release];
            [bgView release];
        }else if (functionType == AndroidModule){
            [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"iOS Mover" label:Switch transferCount:0 screenView:@"iOS Mover" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            [_adPopover close];
            viewController = [[IMBAndroidViewController alloc] initWithDelegate:self];
            ((IMBBaseViewController *)viewController)->_mainWindow = self.window;
        }
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        if (functionType == iCloudModule || functionType == SkinModule||functionType == VideoDownloadModule || functionType == AndroidModule || functionType == AirBackupModule)
        {
            [_searchView setHidden:YES];
        }else{
            [_searchView setHidden:NO];
        }
        
        navigationController = [[IMBNavigationViewController alloc] initWithRootViewController:viewController box:_contentBoxView];
        [_contentDic setObject:navigationController forKey:[FunctionTypeEnum functionTypeToString:functionType]];
        [viewController setSearchFieldBtn:_searchView];
        [viewController setMainTopLineView:_topLineView];
        [_contentBoxView setContentView:viewController.view];
        [viewController release];
        [navigationController release];
    }else{
        viewController = (IMBBaseViewController *)navigationController.currentViewController;
        [viewController setSearchFieldBtn:_searchView];
        [_rightUpDownbgView setHidden:YES];
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        if (functionType == DeviceModule) {
            [ATTracker event:Device_Content action:ActionNone actionParams:@"Device Content" label:Switch transferCount:0 screenView:@"Device Content" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            BOOL notfirst = [[[NSUserDefaults standardUserDefaults] objectForKey:@"first_open_guideView"] boolValue] ;
            if (_curFunctionType == DeviceModule && !notfirst&&_isDevice) {
                [_guideBoxView setHidden:NO];
                [IMBSoftWareInfo singleton].isLoadGuideView = YES;
                [_adPopover close];
                
                _guideViewController = [[IMBGuideViewController alloc] init];
                [_guideBoxView setContentView:_guideViewController.view];
                [_guideBoxView setWantsLayer:YES];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"first_open_guideView"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_GUIDEVIEW_OPEN object:_guideViewController];
            }
            [viewController ShowWindowControllerCategory];
            [_selectDeviceBtn setNeedsDisplay:YES];
        }else if (functionType == AndroidModule) {
            [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"iOS Mover" label:Switch transferCount:0 screenView:@"iOS Mover" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            [viewController ShowWindowControllerCategory];
            [_selectDeviceBtn setNeedsDisplay:YES];
        }else if (functionType == iCloudModule || functionType == SkinModule){
            if (functionType == iCloudModule){
                [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Manager" label:Switch transferCount:0 screenView:@"iCloud Manager" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }else{
                [ATTracker event:Skin_Theme action:ActionNone actionParams:@"Appearance" label:Switch transferCount:0 screenView:@"Appearance" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            }
            [_searchView setHidden:YES];
        }else if (functionType == VideoDownloadModule){
            [ATTracker event:Video_Download action:ActionNone actionParams:@"Media Downloader" label:Switch transferCount:0 screenView:@"Media Downloader" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            [_rightUpDownbgView setHidden:NO];
            [_searchView setHidden:YES];
            [_helpView setHidden:YES];
        }else if (functionType == AirBackupModule){
            [ATTracker event:Air_Backup action:ActionNone actionParams:@"Air Backup" label:Switch transferCount:0 screenView:@"Air Backup Manager" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            [_searchView setHidden:YES];
            [_helpView setHidden:NO];
            [(IMBAirWifiBackupViewController *)viewController setBackupGuideAlertView];
        }else{
            [_searchView setHidden:NO];
            if (functionType == BackupModule) {
                [ATTracker event:iTunes_Backup action:ActionNone actionParams:@"Backup Manager" label:Switch transferCount:0 screenView:@"Backup Manager" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                [viewController reloadTableView];
                [(IMBBackupViewController *)viewController changeViewController:YES];
            }else{
                [ATTracker event:iTunes_Library action:ActionNone actionParams:@"iTunes Library" label:Switch transferCount:0 screenView:@"iTunes Library" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                [viewController reloadTableView];
            }
            
        }
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        IMBiPod *ipod = nil;
        for (id obj in [_deviceConnection getConnectedIPods]) {
            if (obj && [obj isKindOfClass:[IMBiPod class]]) {
                ipod = (IMBiPod *)obj;
            }
            if (ipod) {
                IMBBaseInfo *base = [_deviceConnection getDeviceByKey:ipod.uniqueKey];
                if ([base isEqual:_curBaseInfo]) {
                    [_curBaseInfo setIsSelected:YES];
                }else {
                    [base setIsSelected:NO];
                }
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHANGE_IPOD object:ipod];
        [self doSearch:nil];
        if (functionType == iTunesLibraryModule && _isLoadiTunesData) {
            [(IMBitunesLibraryViewController *)viewController loadiTunesData];
            _isLoadiTunesData = NO;
        }
        [_contentBoxView setContentView:viewController.view];
    }
    
    IMBNavigationViewController *androidController = [_contentDic objectForKey:[FunctionTypeEnum functionTypeToString:AndroidModule]];
    if (functionType == iTunesLibraryModule) {
        [[IMBLogManager singleton] writeInfoLog:@"enter iTunesLibraryModule"];
        [self setTopLineViewIsHidden:![viewController isShowLineView]];
        if (androidController) {
            [(IMBAndroidViewController *)androidController.currentViewController pauseAndroidLoad];
        }
    }else if (functionType == BackupModule){
        [[IMBLogManager singleton] writeInfoLog:@"enter BackupModule"];
        if (androidController) {
            [(IMBAndroidViewController *)androidController.currentViewController pauseAndroidLoad];
        }
    }else if (functionType == iCloudModule){
        [[IMBLogManager singleton] writeInfoLog:@"enter iCloudModule"];
        [self setTopLineViewIsHidden:![viewController isShowLineView]];
        if (androidController) {
            [(IMBAndroidViewController *)androidController.currentViewController pauseAndroidLoad];
        }
    }else if (functionType == DeviceModule){
        [[IMBLogManager singleton] writeInfoLog:@"enter DeviceModule"];
        [self setTopLineViewIsHidden:![viewController isShowLineView]];
        if (androidController) {
            [(IMBAndroidViewController *)androidController.currentViewController pauseAndroidLoad];
        }
    }else if (functionType == SkinModule){
        [[IMBLogManager singleton] writeInfoLog:@"enter SkinModule"];
        [self setTopLineViewIsHidden:YES];
        if (androidController) {
            [(IMBAndroidViewController *)androidController.currentViewController pauseAndroidLoad];
        }
    }else if (functionType == VideoDownloadModule) {
        [[IMBLogManager singleton] writeInfoLog:@"enter VideoDownloadModule"];
        [self setTopLineViewIsHidden:![viewController isShowLineView]];
        if (androidController) {
            [(IMBAndroidViewController *)androidController.currentViewController pauseAndroidLoad];
        }
    }else if (functionType == AndroidModule){
        [[IMBLogManager singleton] writeInfoLog:@"enter AndroidModule"];
        [self setTopLineViewIsHidden:![viewController isShowLineView]];
        if (androidController) {
            [(IMBAndroidViewController *)androidController.currentViewController continueAndroidLoad];
        }
    }else if (functionType == AirBackupModule){
        [[IMBLogManager singleton] writeInfoLog:@"enter AirBackupModule"];
        [self setTopLineViewIsHidden:![viewController isShowLineView]];
        if (androidController) {
            [(IMBAndroidViewController *)androidController.currentViewController pauseAndroidLoad];
        }
    }
     //显示按钮文字
    [self changeSelectDeviceBtn:functionType];
}

void CrashHandlerExceptionHandler(NSException *exception) {
    [[IMBLogManager singleton] writeInfoLog:[NSString stringWithFormat:@"GlobalException:name:%@\nreason:%@\ncallstack:%@",exception.name,exception.reason,exception.callStackSymbols]];
}

- (void)changeViewButtonName:(FunctionType)functionType {
    for (IMBNavIconButton *button in [_mainframeButtonBar functionButtonsArray]) {
        if (button.tag == functionType) {
            [button setIsSelected:YES];
        }else {
            [button setIsSelected:NO];
        }
    }
}

- (void)changeSelectBaseInfo:(FunctionType)functionType {
    NSEnumerator *enumerator = [_connectDic objectEnumerator];
    id obj = nil;
    if (functionType == DeviceModule) {
        BOOL res = NO;
        IMBBaseInfo *baseInfo = nil;
        while (obj = [enumerator nextObject]) {
            if (obj && [obj isKindOfClass:[IMBBaseInfo class]]) {
                baseInfo = (IMBBaseInfo *)obj;
                if (([baseInfo connectType] != general_Android) && ([baseInfo connectType] != general_iCloud) && ([baseInfo connectType] != general_Add_Content)) {
                    res = YES;
                }
            }
        }
        if (_curBaseInfo) {
            [_curBaseInfo release];
            _curBaseInfo = nil;
        }
        if (res && [_connectiPodTotalArray count] > 0) {
            IMBBaseInfo *tmpBaseInfo = [_connectiPodTotalArray objectAtIndex:0];
            _curBaseInfo = [[_deviceConnection getDeviceByKey:tmpBaseInfo.uniqueKey] retain];
            IMBiPod *ipod = nil;
            for (id obj in [_deviceConnection getConnectedIPods]) {
                if (obj && [obj isKindOfClass:[IMBiPod class]]) {
                    ipod = (IMBiPod *)obj;
                }
                if (ipod) {
                    IMBBaseInfo *base = [_deviceConnection getDeviceByKey:ipod.uniqueKey];
                    if ([base isEqual:_curBaseInfo]) {
                        [_curBaseInfo setIsSelected:YES];
                    }else {
                        [base setIsSelected:NO];
                    }
                }
            }
        }
    }else if (functionType == AndroidModule) {
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        BOOL res = NO;
        IMBBaseInfo *baseInfo = nil;
        while (obj = [enumerator nextObject]) {
            if (obj && [obj isKindOfClass:[IMBBaseInfo class]]) {
                baseInfo = (IMBBaseInfo *)obj;
                if ([baseInfo connectType] == general_Android) {
                    [tmpArray addObject:baseInfo];
                    res = YES;
                }
            }
        }
        if (_curBaseInfo) {
            [_curBaseInfo release];
            _curBaseInfo = nil;
        }
        if (res && [tmpArray count] > 0) {
            _curBaseInfo = [[tmpArray objectAtIndex:0] retain];
            [_curBaseInfo setIsSelected:YES];
        }
        [tmpArray release];
        tmpArray = nil;
    }else if (functionType == iCloudModule) {
        BOOL res = NO;
        IMBBaseInfo *baseInfo = nil;
        while (obj = [enumerator nextObject]) {
            if (obj && [obj isKindOfClass:[IMBBaseInfo class]]) {
                baseInfo = (IMBBaseInfo *)obj;
                if ([baseInfo connectType] == general_iCloud || [baseInfo connectType] == general_Add_Content) {
                    res = YES;
                }
            }
        }
        if (_curBaseInfo) {
            [_curBaseInfo release];
            _curBaseInfo = nil;
        }
        if (res) {
            _curBaseInfo = [[_connectiCloudTotalArray lastObject] retain];
            for (IMBBaseInfo *baseInfo in _connectiCloudTotalArray) {
                if ([baseInfo isEqual:_curBaseInfo]) {
                    [_curBaseInfo setIsSelected:YES];
                }else {
                    [baseInfo setIsSelected:NO];
                }
            }
            IMBiCloudMainPageViewController *vc = [[_curBaseInfo accountiCloud] objectAtIndex:0];
            HoverButton *button1 = [vc.view viewWithTag:200];
            [button1 setHidden:button1.isHidden];
            HoverButton *button2 = [vc.view viewWithTag:201];
            [button2 setHidden:button2.isHidden];
            [_icloudVC setRootBoxContentView:vc];
            [_icloudVC setIsShowLineView:vc.isShowLineView];
            [_devPopover close];
        }
    }else {
        if (_curBaseInfo) {
            [_curBaseInfo release];
            _curBaseInfo = nil;
        }
        if (_appleID != nil) {
            [_appleID release];
            _appleID = nil;
        }
    }
}

//根据界面不同改变设备按钮上的文字；
- (void)changeSelectDeviceBtn:(FunctionType)functionType {
    [self changeViewButtonName:functionType];
    [self changeSelectBaseInfo:functionType];
    NSString *deviceName = @"";
    if (functionType == DeviceModule || functionType == AndroidModule || functionType == iCloudModule) {
        [_selectDeviceBtn setTarget:self];
        [_selectDeviceBtn setAction:@selector(clickDeviceSelectBtn:)];
        //判断有无设备连接，显示不同的文字
        if (_isConnectDevice) {
            if (_curFunctionType == DeviceModule) {
                if (_curBaseInfo && ([_curBaseInfo connectType] != general_Android) && ([_curBaseInfo connectType] != general_iCloud) && ([_curBaseInfo connectType] != general_Add_Content)) {
                    deviceName = _curBaseInfo.deviceName;
                }else {
                    deviceName = CustomLocalizedString(@"MainWindow_id_3", nil);
                    [_selectDeviceBtn configButtonName:deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:12 WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:0];
                    return;
                }
                if ([StringHelper stringIsNilOrEmpty:deviceName]) {
                    return;
                }
                [_selectDeviceBtn configButtonName:deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:12 WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:_curBaseInfo.connectType];
            }else if (_curFunctionType == AndroidModule) {
                if ([_curBaseInfo connectType] == general_Android) {
                    deviceName = _curBaseInfo.deviceName;
                }else {
                    deviceName = CustomLocalizedString(@"MainWindow_id_3", nil);
                    [_selectDeviceBtn configButtonName:deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:12 WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:0];
                    return;
                }
                if ([StringHelper stringIsNilOrEmpty:deviceName]) {
                    return;
                }
                [_selectDeviceBtn configButtonName:deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:12 WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:_curBaseInfo.connectType];
            }else if (_curFunctionType == iCloudModule) {
                if ([_curBaseInfo accountiCloud].count > 0) {
                    deviceName = _curBaseInfo.deviceName;
                }else {
                    deviceName = CustomLocalizedString(@"MainWindow_id_9", nil);
                    [_selectDeviceBtn configButtonName:deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:12 WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:7000];
                    return;
                }
                if ([StringHelper stringIsNilOrEmpty:deviceName]) {
                    return;
                }
                [_selectDeviceBtn configButtonName:deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:12 WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:_curBaseInfo.connectType];
            }else {
                if ([_connectiPodTotalArray count] > 0) {
                    IMBBaseInfo *tmpBaseInfo = [_connectiPodTotalArray objectAtIndex:0];
                    deviceName = tmpBaseInfo.deviceName;
                    if ([StringHelper stringIsNilOrEmpty:deviceName]) {
                        return;
                    }
                    [_selectDeviceBtn configButtonName:deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:12 WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:tmpBaseInfo.connectType];
                }else {
                    deviceName = CustomLocalizedString(@"MainWindow_id_3", nil);
                    [_selectDeviceBtn configButtonName:deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:12 WithIsShowIcon:YES WithIsShowTrangle:NO WithIsDisable:YES withConnectType:0];
                }
            }
        }else if (functionType == iCloudModule) {
            deviceName = CustomLocalizedString(@"MainWindow_id_9", nil);
            [_selectDeviceBtn configButtonName:deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:12 WithIsShowIcon:YES WithIsShowTrangle:NO WithIsDisable:YES withConnectType:7000];
        }else {
            deviceName = CustomLocalizedString(@"MainWindow_id_3", nil);
            [_selectDeviceBtn configButtonName:deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:12 WithIsShowIcon:YES WithIsShowTrangle:NO WithIsDisable:YES withConnectType:0];
        }
    }else {
        if ([[_deviceConnection allDevice] count] > 0) {
            if ([_deviceConnection deviceCount] > 0 && _connectiPodTotalArray.count > 0) {
                IMBBaseInfo *tmpBaseInfo = [_connectiPodTotalArray objectAtIndex:0];
                if (tmpBaseInfo) {
                    deviceName = tmpBaseInfo.deviceName;
                    [_selectDeviceBtn configButtonName:deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:12 WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:tmpBaseInfo.connectType];
                }
            }else {
                deviceName = CustomLocalizedString(@"MainWindow_id_3", nil);
                [_selectDeviceBtn configButtonName:deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:12 WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:0];
            }
        }else {
            deviceName = CustomLocalizedString(@"MainWindow_id_3", nil);
            [_selectDeviceBtn configButtonName:deviceName WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:12 WithIsShowIcon:YES WithIsShowTrangle:NO WithIsDisable:YES withConnectType:0];
        }
    }
    [_selectDeviceBtn setNeedsDisplay:YES];
    NSRect rect = [StringHelper calcuTextBounds:deviceName fontSize:14];
    if (rect.size.width > 200) {
        rect.size.width = 200;
    }
    
    if (_isConnectDevice && _curBaseInfo != nil) {
        NSString *pathString = [[TempHelper getAppiMobieConfigPath] stringByAppendingPathComponent:@"device.pdf"];
        [TempHelper exoprtPdfWithPath:pathString withcontrol:_selectDeviceBtn withmakeSizew:300 withhigh:300];
    }

}

- (void)windowDidLoad {
    [super windowDidLoad];
  
}

- (void)guideViewremove {
    [_guideBoxView setHidden:YES];
}
#pragma mark - DEVICE Notification
- (void)deviceBtnChange:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[IMBLogManager singleton] writeInfoLog:@"device Btn Change"];
        [_devPopover close];
        BOOL isConnect = [[notification object] boolValue];
        if (isConnect) {
            NSDictionary *deviceInfo = [notification userInfo];
            IMBBaseInfo *baseInfo = [deviceInfo objectForKey:@"DeviceInfo"];
            [_connectDic setObject:baseInfo forKey:[NSString stringWithFormat:@"%@", baseInfo.uniqueKey]];
            if (!_isConnectDevice) {
                _isConnectDevice = YES;
            }
            if ([baseInfo isiPod] && [[_deviceConnection getConnectedIPods] count] > 0 && !_isiOSDevice) {
                _isiOSDevice = YES;
                if (_curBaseInfo != nil) {
                    [_curBaseInfo release];
                    _curBaseInfo = nil;
                }
                _curBaseInfo = [baseInfo retain];
                if ([_connectiPodTotalArray count] > 0) {
                    [_connectiPodTotalArray removeAllObjects];
                }
                [_connectiPodTotalArray addObject:_curBaseInfo];
            }else if ([baseInfo isAndroid]) {
                if (_curBaseInfo != nil) {
                    [_curBaseInfo release];
                    _curBaseInfo = nil;
                }
                _curBaseInfo = [baseInfo retain];
            }else if ([baseInfo isicloudView]) {
                if (![_connectiCloudTotalArray containsObject:baseInfo]) {
                    [_connectiCloudTotalArray addObject:baseInfo];
                }
                if (_curBaseInfo != nil) {
                    [_curBaseInfo release];
                    _curBaseInfo = nil;
                }
                _curBaseInfo = [baseInfo retain];
            }
            [self changeSelectDeviceBtn:_curFunctionType];
        }else {
            NSDictionary *deviceInfo = [notification userInfo];
            NSString *uniqueKey = [deviceInfo objectForKey:@"UniqueKey"];
            IMBBaseInfo *tmpBaseInfo = [[_connectDic objectForKey:uniqueKey] retain];
            [_deviceConnection removeDeviceByKey:uniqueKey];
            if (uniqueKey) {
                [_connectDic removeObjectForKey:uniqueKey];
            }
            if (_curBaseInfo != nil && [tmpBaseInfo.uniqueKey isEqualToString:_curBaseInfo.uniqueKey]) {
                if (_curFunctionType == DeviceModule) {
                    [_searchView setHidden:YES];
                }
                [_curBaseInfo release];
                _curBaseInfo = nil;
            }
            if ([tmpBaseInfo isicloudView]) {
                [_connectiCloudTotalArray removeObject:tmpBaseInfo];
                if (tmpBaseInfo.uniqueKey) {
                    [[_deviceConnection iCloudDic] removeObjectForKey:tmpBaseInfo.uniqueKey];
                }
                if ([[_deviceConnection getAllDevice] count] == 0) {
                    _isConnectDevice = NO;
                }
            }else if ([tmpBaseInfo isAndroid]) {
                if (_curFunctionType == AndroidModule) {
                    [_searchView setHidden:YES];
                }
                if ([[_deviceConnection getAllDevice] count] == 0) {
                    _isConnectDevice = NO;
                }
            }else {
                if (_deviceConnection.deviceCount > 0) {
                    IMBiPod *tmpiPod = [_deviceConnection getNextConnectedIpod];
                    if (tmpiPod) {
                        _curBaseInfo = [[_deviceConnection getDeviceByKey:tmpiPod.uniqueKey] retain];
                        _curBaseInfo.isSelected = YES;
                        if ([_connectiPodTotalArray count] > 0) {
                            [_connectiPodTotalArray removeAllObjects];
                        }
                        [_connectiPodTotalArray addObject:_curBaseInfo];
                    }
                }else if ([[_deviceConnection getAllDevice] count] > 0) {
                    if (!_curBaseInfo) {
                        _curBaseInfo = [[_connectDic objectForKey:tmpBaseInfo.uniqueKey] retain];
                    }
                    _isiOSDevice = NO;
                }else {
                    _isConnectDevice = NO;
                    _isiOSDevice = NO;
                }
            }
            [self changeSelectDeviceBtn:_curFunctionType];
            [tmpBaseInfo release];
            tmpBaseInfo = nil;
        }
        [_selectDeviceBtn setNeedsDisplay:YES];

    });
    
}

- (void)deviceNeedPassword:(NSNotification *)notification {
}

- (void)jumpToiCloudLoginView:(NSNotification *)notification {
    [self changeViewController:iCloudModule];
}

- (void)jumpToBackupView:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    SimpleNode *node = [dic objectForKey:@"node"];
    [self changeViewController:BackupModule];
    [_backupVC setIsComeFormAirwifi:YES];
    [_backupVC enterView:node];
}

//注册验证失败弹框
- (void)doRegisterCheckFail:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        //软件启动时注册码验证失败，然后显示注册按钮，弹出提示窗口
        [_buyView setHidden:NO];
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        if (view) {
            [view setHidden:NO];
            NSString *errorStr = [notification object];
            [_alertView showAlertText:errorStr OKButton:CustomLocalizedString(@"Button_Ok", nil) SuperView:view];
        }
    });
}

#pragma mark - 设备选择按钮事件
- (IBAction)clickDeviceSelectBtn:(id)sender {
   
    if (!_selectDeviceBtn.isDisable) {
        if (_devPopover != nil) {
            if (_devPopover.isShown) {
                [_devPopover close];
                return;
            }
        }
        if (_devPopover != nil) {
            [_devPopover release];
            _devPopover = nil;
        }
        _devPopover = [[NSPopover alloc] init];

        if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
            _devPopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
        }else {
            _devPopover.appearance = NSPopoverAppearanceMinimal;
        }

        _devPopover.animates = YES;
        _devPopover.behavior = NSPopoverBehaviorTransient;
        _devPopover.delegate = self;
        NSMutableArray *allDevice = [[NSMutableArray alloc] init];
        if ([_deviceConnection.getAllDevice count] > 0) {
            for (IMBBaseInfo *baseInfo in _deviceConnection.getAllDevice) {
                [allDevice addObject:baseInfo];
            }
            devPopoverViewController = [[IMBPopoverViewController alloc] initWithNibName:@"IMBPopoverViewController" bundle:nil withSelectedValue:_curBaseInfo.uniqueKey WithDevice:allDevice withConnectType:_curBaseInfo.connectType];
            
            [devPopoverViewController setTarget:self];
            [devPopoverViewController setAction:@selector(onItemClicked:)];
            
            [devPopoverViewController setExitTarget:self];
            [devPopoverViewController setExitAction:@selector(onItemExitClicked:)];
            [devPopoverViewController setDelegate:self];
            if (_devPopover != nil) {
                _devPopover.contentViewController = devPopoverViewController;
            }
            
            [devPopoverViewController release];
            [allDevice release];
            allDevice = nil;
            NSButton *targetButton = (NSButton *)sender;
            NSRectEdge prefEdge = NSMaxYEdge;
            NSRect rect = NSMakeRect(targetButton.bounds.origin.x, targetButton.bounds.origin.y, targetButton.bounds.size.width, targetButton.bounds.size.height);
            [_devPopover showRelativeToRect:rect ofView:sender preferredEdge:prefEdge];
        }
    }
}

//切换设备
- (void)onItemClicked:(id)sender {
    IMBBaseInfo *baseInfo = nil;
    id obj = sender;
    if (obj && [obj isKindOfClass:[IMBBaseInfo class]]) {
        baseInfo = (IMBBaseInfo *)obj;
        if (_curFunctionType == DeviceModule) {
            if ([baseInfo.uniqueKey isEqualToString:_curBaseInfo.uniqueKey] && baseInfo.isSelected && (baseInfo.connectType != iPod_Unknown && baseInfo.connectType != general_Android && baseInfo.connectType != general_iCloud && baseInfo.connectType != general_Add_Content)) {
                return;
            }
        }else if (_curFunctionType == AndroidModule) {
            if ([baseInfo.uniqueKey isEqualToString:_curBaseInfo.uniqueKey] && baseInfo.isSelected && baseInfo.connectType == general_Android) {
                return;
            }
        }else if (_curFunctionType == iCloudModule) {
            if ([baseInfo.uniqueKey isEqualToString:_curBaseInfo.uniqueKey] && baseInfo.isSelected && (baseInfo.connectType == general_iCloud || baseInfo.connectType == general_Add_Content)) {
                return;
            }
        }
        [_devPopover close];
        NSString *curUniqieKey = nil;
        if (_curBaseInfo != nil) {
             curUniqieKey = [_curBaseInfo.uniqueKey retain];
            [_curBaseInfo release];
            _curBaseInfo = nil;
        }
        _curBaseInfo = [baseInfo retain];
        _curBaseInfo.isSelected = YES;
        if ([_curBaseInfo isicloudView]) {
            if ([[_curBaseInfo deviceName] isEqualToString:CustomLocalizedString(@"icloud_addAcount", nil)]) {
                [_curBaseInfo setConnectType:general_Add_Content];
                [_devPopover close];
                [_selectDeviceBtn configButtonName:CustomLocalizedString(@"MainWindow_id_9", nil) WithTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] WithTextSize:12 WithIsShowIcon:YES WithIsShowTrangle:YES WithIsDisable:NO withConnectType:_curBaseInfo.connectType];
                if (!_icloudVC) {
                    [self changeViewController:iCloudModule];
                }else {
                    [_icloudVC onItemClicked:_curBaseInfo.deviceName];
                    [_contentBoxView setContentView:_icloudVC.view];
                    _curFunctionType = iCloudModule;
                    [self changeViewButtonName:iCloudModule];
                    if (_appleID != nil) {
                        [_appleID release];
                        _appleID = nil;
                    }
                }
                [_rightUpDownbgView setHidden:YES];
                [_searchView setHidden:YES];
                [_helpView setHidden:NO];
                return;
            }
            if (_curBaseInfo.uniqueKey != nil && curUniqieKey != nil && [_curBaseInfo.uniqueKey isEqualToString:curUniqieKey]) {
                return;
            }
            if ([_connectiCloudTotalArray count] > 0) {
                [_connectiCloudTotalArray removeObject:_curBaseInfo];
                [_connectiCloudTotalArray addObject:_curBaseInfo];
            }
            if (_appleID != nil) {
                [_appleID release];
                _appleID = nil;
            }
            _appleID = [_curBaseInfo.uniqueKey retain];
            IMBiCloudMainPageViewController *vc = [[_curBaseInfo accountiCloud] objectAtIndex:0];
            HoverButton *button1 = [vc.view viewWithTag:200];
            [button1 setHidden:button1.isHidden];
            HoverButton *button2 = [vc.view viewWithTag:201];
            [button2 setHidden:button2.isHidden];
            [_icloudVC setRootBoxContentView:vc];
            [_icloudVC setIsShowLineView:vc.isShowLineView];
            [_devPopover close];
            [self changeViewController:iCloudModule];
        }else if ([_curBaseInfo isAndroid]) {
            if (_appleID != nil) {
                [_appleID release];
                _appleID = nil;
            }
            [self changeViewController:AndroidModule];
        }else {
            if (_appleID != nil) {
                [_appleID release];
                _appleID = nil;
            }
            if ([_connectiPodTotalArray count] > 0) {
                [_connectiPodTotalArray removeAllObjects];
            }
            [_connectiPodTotalArray addObject:_curBaseInfo];
            [self changeViewController:DeviceModule];
        }
        if (curUniqieKey) {
            [curUniqieKey release];
            curUniqieKey = nil;
        }
    }
    [_selectDeviceBtn setNeedsDisplay:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:DeviceChangeNotification object:_curBaseInfo userInfo:nil];
}

- (void)onItemExitClicked:(id)sender {
}
//弹出设备
- (void)backdrive:(IMBBaseInfo *)baseInfo{
    [_devPopover close];
    [_deviceConnection removeIPodByKey:baseInfo.uniqueKey];
    [_deviceConnection removeDeviceByKey:baseInfo.uniqueKey];
    IMBBaseInfo *tmpBaseInfo = nil;
    tmpBaseInfo = [_connectDic objectForKey:baseInfo.uniqueKey];
    if (baseInfo.uniqueKey) {
        [_connectDic removeObjectForKey:baseInfo.uniqueKey];
    }
    if (_curBaseInfo != nil && [baseInfo.uniqueKey isEqualToString:_curBaseInfo.uniqueKey]) {
        [_curBaseInfo release];
        _curBaseInfo = nil;
    }
    if ([baseInfo isicloudView]) {
        [_connectiCloudTotalArray removeObject:baseInfo];
        if (baseInfo.uniqueKey) {
            [[_deviceConnection iCloudDic] removeObjectForKey:baseInfo.uniqueKey];
        }
        if ([_connectiCloudTotalArray count] == 0) {
            [_icloudVC onItemClicked:CustomLocalizedString(@"icloud_addAcount", nil)];
            if (_curFunctionType == iCloudModule) {
                [_contentBoxView setContentView:_icloudVC.view];
            }
            [self changeViewButtonName:iCloudModule];
            if (_appleID != nil) {
                [_appleID release];
                _appleID = nil;
            }
        }
        if ([[_deviceConnection getAllDevice] count] == 0) {
            _isConnectDevice = NO;
        }
    }else if ([baseInfo isAndroid]) {
        if ([[_deviceConnection getAllDevice] count] == 0) {
            _isConnectDevice = NO;
        }
    }else {
        if (_deviceConnection.deviceCount > 0) {
            IMBiPod *tmpiPod = [_deviceConnection getNextConnectedIpod];
            if (tmpiPod) {
                _curBaseInfo = [[_deviceConnection getDeviceByKey:tmpiPod.uniqueKey] retain];
                _curBaseInfo.isSelected = YES;
                if ([_connectiPodTotalArray count] > 0) {
                    [_connectiPodTotalArray removeAllObjects];
                }
                [_connectiPodTotalArray addObject:_curBaseInfo];
            }
        }else if ([[_deviceConnection getAllDevice] count] > 0) {
            if (!_curBaseInfo) {
                _curBaseInfo = [[_connectDic objectForKey:baseInfo.uniqueKey] retain];
            }
        }else {
            _isConnectDevice = NO;
        }
    }
    [self changeSelectDeviceBtn:_curFunctionType];
    if ([baseInfo isAndroid]) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  baseInfo.uniqueKey, @"UniqueKey"
                                  , nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:Andriod_Device_Disconnect object:baseInfo.uniqueKey userInfo:userInfo];
    }else if ([baseInfo isiPod]) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  baseInfo.uniqueKey, @"UniqueKey"
                                  , nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:DeviceDisConnectedNotification object:baseInfo.uniqueKey userInfo:userInfo];
    }
}

- (void)showInfo:(IMBBaseInfo *)baseInfo {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    NSArray *array = [connection getConnectedIPods];
    for (IMBiPod *ipod in array ) {
        if ([ipod.uniqueKey isEqualToString:baseInfo.uniqueKey]) {
            if (_deviceInfoVC != nil) {
                [_deviceInfoVC release];
                _deviceInfoVC = nil;
            }
            _deviceInfoVC = [[IMBDeviceInfoViewController alloc] initWithNibName:@"IMBDeviceInfoViewController" bundle:nil];
            [_deviceInfoVC showInformationWithiPod:ipod WithSuperView:view];
            break;
        }
    }
    if (_devPopover != nil) {
        if (_devPopover.isShown) {
            [_devPopover close];
            return;
        }
    }
}

- (void)restartDeviceBase:(IMBBaseInfo *)baseInfo {
    [_devPopover close];
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    int i = [_alertView showDeleteConfrimText:CustomLocalizedString(@"RestartConfirmMsg", nil) OKButton:CustomLocalizedString(@"Button_Yes", nil) CancelButton:CustomLocalizedString(@"Button_No", nil) SuperView:view];
    if (i == 1) {
        NSArray *deviceAry = [[_deviceConnection getMobileDeviceAccess] devices];
        NSMutableArray *tmpAry = [[NSMutableArray alloc] init];
        for (AMDevice *adDevice in deviceAry) {
            if ([baseInfo.uniqueKey isEqualToString:adDevice.serialNumber]) {
                [tmpAry addObject:adDevice];
                break;
            }
        }
        if ([tmpAry count] > 0) {
            _mobileRelayServices = [[tmpAry objectAtIndex:0] newAMDiagnosticsRelayServices];
            BOOL res = [_mobileRelayServices restartDevice];
            if (res) {
                NSLog(@"Device is Restart");
            }
            [tmpAry release];
            tmpAry = nil;
        }
    }
}

- (void)shutdownDeviceBase:(IMBBaseInfo *)baseInfo {
    [_devPopover close];
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    int i = [_alertView showDeleteConfrimText:CustomLocalizedString(@"ShutdownConfirmMsg", nil) OKButton:CustomLocalizedString(@"Button_Yes", nil) CancelButton:CustomLocalizedString(@"Button_No", nil) SuperView:view];
    if (i == 1) {
        NSArray *deviceAry = [[_deviceConnection getMobileDeviceAccess] devices];
        NSMutableArray *tmpAry = [[NSMutableArray alloc] init];
        for (AMDevice *adDevice in deviceAry) {
            if ([baseInfo.uniqueKey isEqualToString:adDevice.serialNumber]) {
                [tmpAry addObject:adDevice];
                break;
            }
        }
        if ([tmpAry count] > 0) {
            _mobileRelayServices = [[tmpAry objectAtIndex:0] newAMDiagnosticsRelayServices];
            BOOL res = [_mobileRelayServices shutDownDevice];
            if (res) {
                NSLog(@"Device is Shutdown");
            }
            [tmpAry release];
            tmpAry = nil;
        }
    }
}

//跟踪鼠标事件
- (void)addMouseEventTracking {
    [NSEvent addLocalMonitorForEventsMatchingMask:NSLeftMouseDownMask | NSRightMouseDownMask | NSMouseMovedMask | NSLeftMouseDraggedMask | NSRightMouseDraggedMask | NSLeftMouseUpMask
                                          handler:^NSEvent*(NSEvent* event) {
                                              switch (event.type) {
                                                  case NSLeftMouseDown:
                                                  case NSRightMouseDown:
                                                  case NSLeftMouseDragged:
                                                  case NSRightMouseDragged:
                                                      [self getMouseDownPoint:event];
                                                      break;
                                                  default:
                                                      break;
                                              }
                                              //返回事件，让事件继续传递
                                              return event;
                                          }];
}

- (void)getMouseDownPoint:(NSEvent *)event {
    NSPoint point = [[self.window contentView] convertPoint:event.locationInWindow fromView:nil];
    NSView *superView = _searchView.superview;
    BOOL inSearchView = NSMouseInRect(point, NSMakeRect(_searchView.frame.origin.x, superView.frame.origin.y + _searchView.frame.origin.y, _searchView.frame.size.width, _searchView.frame.size.height), [[self.window contentView] isFlipped]);
    if (!inSearchView) {
        if ([StringHelper stringIsNilOrEmpty:_searchView.searchField.stringValue] && ![_searchView isHidden] && (_searchView.frame.size.width > 30)) {
            [self closeSearchView];
        }
    }
}

//展开searchView
- (void)openSearchView:(id)sender {
    if (_isLoadSearchView) {
        return;
    }
    if (_searchView.frame.size.width <= 26 && _searchView.searchField.isEnabled) {
        _isLoadSearchView = YES;
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 0.5;
            NSRect newRect = NSMakeRect(_searchView.frame.origin.x - 108 + 26, _searchView.frame.origin.y, 108, _searchView.frame.size.height);
            [[_searchView animator] setFrame:newRect];
            [_searchView setBackGroundColor:[StringHelper getColorFromString:CustomColor(@"popover_bgEnterColor", nil)]];
            [_searchView setIsOpen:YES];
        } completionHandler:^{
            [_searchView.searchField setHidden:NO];
            [_searchView.closeBtn setHidden:NO];
            _isLoadSearchView = NO;
        }];
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 0.5;
            NSRect newRect = NSMakeRect(_buyView.frame.origin.x, _buyView.frame.origin.y, 26, _buyView.frame.size.height);
            [[_buyView animator] setFrame:newRect];
            [_buyView setIsOpen:NO];
            [_buyView setNeedsDisplay:YES];
        } completionHandler:^{
            
        }];
        
    }
}

//合拢searchView
- (void)closeSearchView {
    if (_isLoadSearchView) {
        return;
    }
    if (_searchView.frame.size.width > 26 && _searchView.searchField.isEnabled && [StringHelper stringIsNilOrEmpty:_searchView.searchField.stringValue]) {
        _isLoadSearchView = YES;
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 0.5;
            NSRect newRect = NSMakeRect(_searchView.frame.origin.x + 108 - 26, _searchView.frame.origin.y, 26, _searchView.frame.size.height);
            [[_searchView animator] setFrame:newRect];
            [_searchView setBackGroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
            [_searchView setIsOpen:NO];
            [_searchView.searchField setHidden:YES];
            [_searchView.closeBtn setHidden:YES];
        } completionHandler:^{
            _isLoadSearchView = NO;
            [_searchView mouseExited:nil];
            [_searchView setNeedsDisplay:YES];
            NSRect newRect = NSMakeRect(_topView.frame.origin.x+_topView.frame.size.width - 38, _searchView.frame.origin.y, 26, _searchView.frame.size.height);
            [_searchView setFrame:newRect];
        }];
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 0.5;
            NSRect newRect = NSMakeRect(_buyView.frame.origin.x, _buyView.frame.origin.y, 108, _buyView.frame.size.height);
            [[_buyView animator] setFrame:newRect];
            [_buyView setIsOpen:YES];
            [_buyView setNeedsDisplay:YES];
        } completionHandler:^{
            NSRect newRect = NSMakeRect(_topView.frame.origin.x+_topView.frame.size.width - 160, _buyView.frame.origin.y, 108, _buyView.frame.size.height);
            [_buyView setFrame:newRect];
        }];
    }
}

- (void)registSuccess {
    [_buyView setHidden:YES];
}

- (void)disableMainFrameBtn:(NSNotification *)notification {
    BOOL isDisable = [notification.object boolValue];
    _mainFrameBtnIsEnable = isDisable;//记录之前的状态
    HoverButton *selectBtn = nil;
    for (NSView *view in _topView.subviews) {
        if ([view isKindOfClass:[IMBMainFrameButtonBarView class]]) {
            for (NSView *view1 in view.subviews) {
                HoverButton *btn = (HoverButton *)view1;
                if (!btn.isSelected) {
                    [btn setEnabled:isDisable];
                }else {
                    selectBtn = btn;
                }
            }
        }
    }
   
    if (isDisable) {
        [_buyView setAlphaValue:1];
    }else{
        [_buyView setAlphaValue:0.3];
    }
    [_buyView setIsClick:!isDisable];
    
    if ([[_deviceConnection getAllDevice] count] > 0) {
        if (selectBtn.tag == DeviceModule && _isConnectDevice) {
            [_selectDeviceBtn setIsDisable:!isDisable];
        }
        
        if (selectBtn.tag == iCloudModule){
            [_selectDeviceBtn setIsDisable:!isDisable];
        }
        
        if (selectBtn.tag == AndroidModule){
            [_selectDeviceBtn setIsDisable:!isDisable];
        }
    }
    [_searchView.searchField setEnabled:isDisable];
    [_selectDeviceBtn setEnabled:isDisable];
    [_selectDeviceBtn setIsDisable:!isDisable];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mainContentView setNeedsDisplay:YES];
        [_topLineView.layer setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)].toCGColor];
        [_topLineView setNeedsDisplay:YES];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_mainContentView setNeedsDisplay:YES];
        [_topLineView.layer setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)].toCGColor];
        [_topLineView setNeedsDisplay:YES];
    });
}

- (BOOL)getSkinBtnEnable {
    BOOL isReslut = NO;
    for (NSView *view in _topView.subviews) {
        if ([view isKindOfClass:[IMBMainFrameButtonBarView class]]) {
            for (NSView *view1 in view.subviews) {
                IMBNavIconButton *btn = (IMBNavIconButton *)view1;
                if (btn.tag == SkinModule) {
                    isReslut = btn.isEnabled;
                    if (isReslut && !btn.isSelected) {
                        [_mainframeButtonBar clickFunctionButton:btn];
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"SkinSpot"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    break;
                }
            }
        }
    }
    return isReslut;
}

- (void)mouseUp:(NSEvent *)theEvent {
    [[NSNotificationCenter defaultCenter] postNotificationName:FRAMESELECT_MOUSEUP object:nil userInfo:nil];
}

- (void)loadiTunesData{
    _isLoadiTunesData = YES;
}

- (void)showInternetErrorAlert:(NSNotification *)noti {
    [self performSelectorOnMainThread:@selector(popUPNointernet) withObject:nil waitUntilDone:YES];
}

- (void)popUPNointernet {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
            view = subView;
            break;
        }
    }
    [view setHidden:NO];
    [_alertView showAlertText:CustomLocalizedString(@"Transfer_error_id_1", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil) SuperView:view];
}

- (void)closeWindow:(id)sender {
    if (_mainframeButtonBar) {
        if (_mainframeButtonBar.navPopWindow) {
            [_mainframeButtonBar.navPopWindow close];
        }
    }
    [self.window close];
}

- (void)setTopLineViewIsHidden:(BOOL)isHidden {
    [_topLineView setHidden:isHidden];
}

#pragma mark - android设备连接气泡
- (void)androidConnectPopoverView {
    if (_curFunctionType == AndroidModule) {
        return;
    }
    if (_adPopover != nil) {
        [_adPopover close];
        [_adPopover release];
        _adPopover = nil;
    }
    _adPopover = [[NSPopover alloc] init];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
        _adPopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
    }else {
        _adPopover.appearance = NSPopoverAppearanceMinimal;
    }
    
    _adPopover.animates = YES;
    _adPopover.behavior = NSPopoverBehaviorTransient;
    _adPopover.delegate = self;
    IMBAdConnectPopoverViewController *PopoverViewController = [[IMBAdConnectPopoverViewController alloc] initWithNibName:@"IMBAdConnectPopoverViewController" bundle:nil];
    if (_adPopover != nil) {
        _adPopover.contentViewController = PopoverViewController;
    }
    [PopoverViewController release];
    NSButton *targetButton = [_mainframeButtonBar.functionButtonsArray objectAtIndex:4];
    NSRectEdge prefEdge = NSMaxYEdge;
    NSRect rect = NSMakeRect(targetButton.bounds.origin.x, targetButton.bounds.origin.y, targetButton.bounds.size.width, targetButton.bounds.size.height);
    [_adPopover showRelativeToRect:rect ofView:targetButton preferredEdge:prefEdge];
}

#pragma mark - android设备断开连接
- (void)andriodDeviceDisconnect:(NSNotification *)noti {
    if (_curFunctionType == AndroidModule) {
       [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
    }
}

- (void)dealloc {
    [_searchView.searchField removeObserver:self forKeyPath:@"stringValue"];
    [_searchView removeObserver:self forKeyPath:@"hidden"];
    [_shopCarViewController release], _shopCarViewController = nil;
    [_mainframeButtonBar release], _mainframeButtonBar = nil;
    [_deviceInfoVC release], _deviceInfoVC = nil;
    [_curBaseInfo release],_curBaseInfo = nil;
    [_contentDic release],_contentDic = nil;
    [_alertView release], _alertView = nil;
    [_appleID release]; _appleID = nil;
    [self setConnectDic:nil];
    [self setConnectiCloudTotalArray:nil];
    [self setConnectiPodTotalArray:nil];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:NOTIFY_REGISTER_CHECK_FAIL object:nil];
    [nc removeObserver:self name:NOTIFY_CREAT_CIG_ERROR object:nil];
    [nc removeObserver:self name:DeviceBtnChangeNotification object:nil];
    [nc removeObserver:self name:DeviceNeedPasswordNotification object:nil];
    [nc removeObserver:self name:REFREASH_TOPVIEW object:nil];
    [nc removeObserver:self name:NOTIFY_CHANGE_ALLANGUAGE object:nil];
    [nc removeObserver:self name:NOTIFY_BACK_MAINVIEW object:nil];
    [nc removeObserver:self name:NOTIFY_TRANSFERING object:nil];
    [nc removeObserver:self name:NOTIFY_LOAD_GUIDE_VIEW object:nil];
    [nc removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [nc removeObserver:self name:ANNOY_REGIST_SUCCESS object:nil];
    [nc removeObserver:self name:CLOSE_SHOPPING_VIEW object:nil];
    [nc removeObserver:self name:NOTIFY_LOAD_ITUNES_DATA object:nil];
    [nc removeObserver:self name:NOTIFY_JUMP_ICLOUD_VIEW object:nil];
    [nc removeObserver:self name:Andriod_Device_Disconnect object:nil];
    [nc removeObserver:self name:NOTIFY_JUMP_BACKUP_VIEW object:nil];
    [super dealloc];
}

@end
