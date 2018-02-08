//
//  IMBAndroidMainPageViewController.m
//  AnyTrans
//
//  Created by imobie on 17-07-10.
//  Copyright (c) 2017年 imobie. All rights reserved.
//
#import "IMBAndroidMainPageViewController.h"
#import "ColorHelper.h"
#import "IMBAnimation.h"
#import "IMBSegmentedBtn.h"
#import "IMBNotificationDefine.h"
#import "IMBCategoryInfoModel.h"
#import "SystemHelper.h"
#import "IMBPopViewController.h"
#import "ATTracker.h"
#import "ContactConversioniCloud.h"
#import "CalendarConversioniCloud.h"
#import "PhotoConversioniCloud.h"
#import "IMBTransferToiCloud.h"
#import "IMBADContactToiCloud.h"
#import "IMBADCalendarToiCloud.h"
#import "IMBADPhotoToiCloud.h"
#import "IMBTransferToiOS.h"
#import "MessageConversioniOS.h"
#import "ContactConversioniOS.h"
#import "CallLogConversioniOS.h"
#import "CalendarConversioniOS.h"
#import "IMBAndroidTransferToiTunes.h"
#import "IMBAndroidMessageViewController.h"
#import "IMBAndroidContactViewController.h"
#import "IMBAndroidCallHistoryViewController.h"
#import "IMBAndroidCalendarViewController.h"
#import "IMBAndroidVdoAndAdoViewController.h"
#import "IMBAndroidDcAndCpAndBkViewController.h"
#import "IMBAndroidAlbumsViewController.h"
#import "IMBBackgroundBorderView.h"
#import "IMBAndroidMergeViewController.h"
#import "IMBTipPopoverViewController.h"
#import "IMBAndroidViewController.h"

@interface IMBAndroidMainPageViewController ()

@end

@implementation IMBAndroidMainPageViewController
@synthesize popUpButton = _popUpButton;

- (id)initWithAndroid:(IMBAndroid *)android withCategoryNodesEnum:(CategoryNodesEnum)category withDelegate:(id)delegate {
    if (self = [self init]) {
        _android = [android retain];
        _category = category;
        _delegate = delegate;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeTipPopover) name:NOTIFY_CLOSE_TIP object:nil];
    [_arrowImageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
    [(IMBBackgroundBorderView *)self.view setIsGradientWithCornerPart4:YES];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:CustomLocalizedString(@"MSG_Loading_devicedata", nil)];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.length)];
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_loadLabel setAttributedStringValue:as];
    [as release], as = nil;
    
    [_toolBar setHidden:YES];
    _detailPageDic = [[NSMutableDictionary dictionary] retain];
    _displayModeDic = [[NSMutableDictionary dictionary] retain];
    [self.view setWantsLayer:YES];
    [self.view.layer setCornerRadius:5];
    NSView *swbuttonView = [[NSView alloc] initWithFrame:NSMakeRect(NSWidth(self.view.frame)-34 - 25, ceil(NSHeight(self.view.frame)/2.0)-30, 34, 34*2+20)];
    swbuttonView.autoresizesSubviews = YES;
    swbuttonView.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewMaxYMargin;
    HoverButton *detailCategoryBtn = [[HoverButton alloc] initWithFrame:NSMakeRect(0,0,34, 34)];
    detailCategoryBtn.tag = 201;
    [detailCategoryBtn setTarget:self];
    [detailCategoryBtn setAction:@selector(switchView:)];
    [detailCategoryBtn setMouseEnteredImage:[StringHelper imageNamed:@"mainFrame_switch2"] mouseExitImage:[StringHelper imageNamed:@"mainFrame_switch1"] mouseDownImage:[StringHelper imageNamed:@"mainFrame_switch3"]];
    [detailCategoryBtn setIsSelected:NO];
    HoverButton *summaryCategoryBtn = [[HoverButton alloc] initWithFrame:NSMakeRect(0,34+20,34, 34)];
    summaryCategoryBtn.tag = 200;
    [summaryCategoryBtn setTarget:self];
    [summaryCategoryBtn setAction:@selector(switchView:)];
    [summaryCategoryBtn setMouseEnteredImage:[StringHelper imageNamed:@"mainFrame_tool2"] mouseExitImage:[StringHelper imageNamed:@"mainFrame_tool1"] mouseDownImage:[StringHelper imageNamed:@"mainFrame_tool3"]];
    [summaryCategoryBtn setIsSelected:YES];
    [swbuttonView addSubview:detailCategoryBtn];
    [swbuttonView addSubview:summaryCategoryBtn];
    [detailCategoryBtn release];
    [summaryCategoryBtn release];
    [self.view addSubview:swbuttonView];
    [_scrollView setDelegate:self];
    [_scrollView setIsdown:NO];
    
    [_androidToiCloud setComponentColor:[ColorHelper getColorFromColorString:@"android_toicloud_downColor" WithIndex:0] withG1:[ColorHelper getColorFromColorString:@"android_toicloud_downColor" WithIndex:1] withB1:[ColorHelper getColorFromColorString:@"android_toicloud_downColor" WithIndex:2] withAlpha1:[ColorHelper getColorFromColorString:@"android_toicloud_downColor" WithIndex:3] withR2:[ColorHelper getColorFromColorString:@"android_toicloud_upColor" WithIndex:0] withG2:[ColorHelper getColorFromColorString:@"android_toicloud_upColor" WithIndex:1] withB2:[ColorHelper getColorFromColorString:@"android_toicloud_upColor" WithIndex:2] withAlpha2:[ColorHelper getColorFromColorString:@"android_toicloud_upColor" WithIndex:3]];
    
    [_androidToiCloud setTitleName:CustomLocalizedString(@"Android_to_iCloud", nil) WithDarwInterval:24 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iostool_toicloud"] withTextColor:[NSColor whiteColor]];
    [_androidToiOS setIsToiOSBtn:YES];
    [_androidToiOS setComponentColor:[ColorHelper getColorFromColorString:@"android_toiOS_downColor" WithIndex:0] withG1:[ColorHelper getColorFromColorString:@"android_toiOS_downColor" WithIndex:1] withB1:[ColorHelper getColorFromColorString:@"android_toiOS_downColor" WithIndex:2] withAlpha1:[ColorHelper getColorFromColorString:@"android_toiOS_downColor" WithIndex:3] withR2:[ColorHelper getColorFromColorString:@"android_toiOS_upColor" WithIndex:0] withG2:[ColorHelper getColorFromColorString:@"android_toiOS_upColor" WithIndex:1] withB2:[ColorHelper getColorFromColorString:@"android_toiOS_upColor" WithIndex:2] withAlpha2:[ColorHelper getColorFromColorString:@"android_toiOS_upColor" WithIndex:3]];
    [_androidToiOS setTitleName:CustomLocalizedString(@"Android_to_iOS", nil) WithDarwInterval:28 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iostool_toios"] withTextColor:[NSColor whiteColor]];
    
    
    [_androidToiTunes setComponentColor:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:0] withG1:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:1] withB1:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:2] withAlpha1:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:3] withR2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:0] withG2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:1] withB2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:2] withAlpha2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:3]];
    [_androidToiTunes setTitleName:CustomLocalizedString(@"Android_to_iTunes", nil) WithDarwInterval:27 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iostool_toitunes"] withTextColor:[NSColor whiteColor]];
    
    [_detailBox setContentView:_firstCustomView];
    [_contentBox setWantsLayer:YES];
    [_contentBox setContentView:_functionView];
    [_detailBox setFrameSize:self.view.frame.size];
    [_androidToiCloud setHidden:YES];
    [_androidToiOS setHidden:YES];
    [_androidToiTunes setHidden:YES];
    [self performSelector:@selector(moveMainViewBtnAnimation) withObject:nil afterDelay:0.1];
    [_categoryBarView initializationCategoryAndroid:_android withCategoryBlock:^(CategoryNodesEnum category, IMBFunctionButton *button) {
        NSString *countStr = @"";
        if (button.badgeCount == 0) {
            countStr = button.title;
        }else if (button.badgeCount > 1) {
            if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                countStr = [NSString stringWithFormat:@"%@ ( %d )",button.title,(int)button.badgeCount];
            }else {
                countStr = [NSString stringWithFormat:@"%@ (%d %@)",button.title,(int)button.badgeCount,CustomLocalizedString(@"MSG_Item_id_4", nil)];
            }
        }else {
            if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                countStr = [NSString stringWithFormat:@"%@ ( %d )",button.title,(int)button.badgeCount];
            }else {
                countStr = [NSString stringWithFormat:@"%@ (%d %@)",button.title,(int)button.badgeCount,CustomLocalizedString(@"MSG_Item_id_3", nil)];
            }
        }
        _selectedBtn = button;
        _selectedItem = (IMBMenuItem *)_popUpButton.selectedItem;
        [_popUpButton setTitle:countStr];
        [_occlusionView setFrameOrigin:NSMakePoint(_popUpButton.frame.size.width-_occlusionView.frame.size.width-2, 4)];
        [_popUpButton setNeedsDisplay:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self changeView:category];
        });
    }];
    
    [_androidToiTunes setTarget:self];
    [_androidToiTunes setAction:@selector(doAndroidToiTunes:)];
    [_androidToiOS setTarget:self];
    [_androidToiOS setAction:@selector(doAndroidToiOS:)];
    [_androidToiCloud setTarget:self];
    [_androidToiCloud setAction:@selector(doAndroidToiCloud:)];
    [self loadAndroidData];
    [self configMainTitle];
    [_popUpButton setMenu:[self createNavagationMenu]];
    [_popUpButton setFrame:NSMakeRect(16+4+36, ceil((NSHeight(_toolBar.frame) - NSHeight(_popUpButton.frame))/2.0),100,22)];
    [_occlusionView setFrameOrigin:NSMakePoint(_popUpButton.frame.size.width-_occlusionView.frame.size.width-2, 4)];
    [_popUpButton addSubview:_occlusionView];
    [_toolBar addSubview:_popUpButton];
    [_iCloudBgView setImage:[StringHelper imageNamed:@"device_bg"]];
}

- (void)loadAndroidData {
    for (IMBFunctionButton *button in _categoryBarView.allcategoryArr) {
        [button addAndroidLoadingView];
    }
    
    //检查是否赋予设备读取信息权限
    [self performSelector:@selector(checkDeviceGreantedPermission:) withObject:nil afterDelay:0];
}

- (void)loadDeviceData {
    @autoreleasepool {
        [_android sendAction:@"ScanStart" ResultText:0 TargetWord:@"Defalut"];
        __block int totalCount = 0;
        //扫描磁盘得到磁盘下的music，video，book,Doucment,Compressed
        [_android setCategory:Category_Summary];
        [_android queryDoucmentDetailInfo];
        for (IMBFunctionButton *button in _categoryBarView.allcategoryArr) {
            switch (button.tag) {
                case Category_Music:
                {
                    [_android queryAudioDetailInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getAudioContent.reslutCount;
                        [button showloading:NO];
                        totalCount += button.badgeCount;
                    });
                }
                    break;
                case Category_Movies:
                {
                    [_android queryVideoDetailInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getVideoContent.reslutCount;
                        [button showloading:NO];
                        totalCount += button.badgeCount;
                    });
                }
                    break;
                case Category_Ringtone:
                {
                    [_android queryRingtoneDetailInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getRingtoneContent.reslutCount;
                        [button showloading:NO];
                        totalCount += button.badgeCount;
                    });
                }
                    break;
                case Category_Photo:
                {
                    [_android queryGalleryDetailInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getGalleryContent.reslutCount;
                        [button showloading:NO];
                        totalCount += button.badgeCount;
                    });
                }
                    break;
                case Category_iBooks:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getiBooksContent.reslutCount;
                        [button showloading:NO];
                        totalCount += button.badgeCount;
                    });
                }
                    break;
                case Category_Contacts:
                {
                    [_android queryContactDetailInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getContactContent.reslutCount;
                        [button showloading:NO];
                        totalCount += button.badgeCount;
                    });
                }
                    break;
                case Category_Message:
                {
                    [_android querySMSDetailInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getSMSContent.reslutCount;
                        [button showloading:NO];
                        totalCount += button.badgeCount;
                    });
                }
                    break;
                case Category_CallHistory:
                {
                    [_android queryCallHistoryDetailInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getCallHistoryContent.reslutCount;
                        [button showloading:NO];
                        totalCount += button.badgeCount;
                    });
                }
                    break;
                case Category_Calendar:
                {
                    [_android queryCalendarDetailInfo];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getCalendarContent.reslutCount;
                        [button showloading:NO];
                        totalCount += button.badgeCount;
                    });
                }
                    break;
                case Category_Compressed:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getCompressedContent.reslutCount;
                        [button showloading:NO];
                        totalCount += button.badgeCount;
                    });
                }
                    break;
                case Category_Document:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getAppDoucmentContent.reslutCount;
                        [button showloading:NO];
                        totalCount += button.badgeCount;
                    });
                }
                    break;
                    
                default:
                    break;
            }
        }
        _loadFinish = YES;
        [_android sendAction:@"ScanFinished" ResultText:totalCount TargetWord:@"Defalut"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_loadLabel setHidden:YES];
            if (_loadPopover != nil) {
                [_loadPopover close];
            }
        });
    }
}

- (void)loadAndroidDataCount:(int)count {
    @autoreleasepool {
        for (IMBFunctionButton *button in _categoryBarView.allcategoryArr) {
            switch (button.tag) {
                case Category_Music:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getAudioContent.reslutCount;
                        [button showloading:NO];
                    });
                }
                    break;
                case Category_Movies:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getVideoContent.reslutCount;
                        [button showloading:NO];
                    });
                }
                    break;
                case Category_Ringtone:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getRingtoneContent.reslutCount;
                        [button showloading:NO];
                    });
                }
                    break;
                case Category_Photo:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getGalleryContent.reslutCount;
                        [button showloading:NO];
                    });
                }
                    break;
                case Category_iBooks:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getiBooksContent.reslutCount;
                        [button showloading:NO];
                    });
                }
                    break;
                case Category_Contacts:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getContactContent.reslutCount;
                        [button showloading:NO];
                    });
                }
                    break;
                case Category_Message:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getSMSContent.reslutCount;
                        [button showloading:NO];
                    });
                }
                    break;
                case Category_CallHistory:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getCallHistoryContent.reslutCount;
                        [button showloading:NO];
                    });
                }
                    break;
                case Category_Calendar:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getCalendarContent.reslutCount;
                        [button showloading:NO];
                    });
                }
                    break;
                case Category_Compressed:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getCompressedContent.reslutCount;
                        [button showloading:NO];
                    });
                }
                    break;
                case Category_Document:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        button.badgeCount = _android.getAppDoucmentContent.reslutCount;
                        [button showloading:NO];
                    });
                }
                    break;
                    
                default:
                    break;
            }
        }
        [_popUpButton setNeedsDisplay:YES];
    }
    for (IMBFunctionButton *btn in _categoryBarView.allcategoryArr) {
        if (btn.tag == _category) {
            [btn setNeedsDisplay:YES];
            
            NSString *countStr = @"";
            if (count == 0) {
                countStr = btn.buttonName;
            }else if (count > 1) {
                if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                    countStr = [NSString stringWithFormat:@"%@ (%d)",btn.title,count];
                }else {
                    countStr = [NSString stringWithFormat:@"%@ (%d %@)",btn.buttonName,count,CustomLocalizedString(@"MSG_Item_id_4", nil)];
                }
                
            }else {
                if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                    countStr = [NSString stringWithFormat:@"%@ (%d)",btn.title,count];
                }else {
                    countStr = [NSString stringWithFormat:@"%@ (%d %@)",btn.buttonName,count,CustomLocalizedString(@"MSG_Item_id_3", nil)];
                }
            }
            [_popUpButton setTitle:countStr];
            [_occlusionView setFrameOrigin:NSMakePoint(_popUpButton.frame.size.width-_occlusionView.frame.size.width-2, 4)];
            [_popUpButton setNeedsDisplay:YES];
            break;
        }
    }
}

#pragma mark - 检查设备是否赋予权限
- (void)checkDeviceGreantedPermission:(NSNumber *)functionType {
    if (_android != nil) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
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
                [self greantedPermission:functionType];
            }else {
                if (_category == Category_Summary) {
                    [self loadDeviceData];
                }else {
                    IMBBaseViewController *viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:_category]];
                    if (viewController) {
                        if (functionType.intValue == ReloadFunctionType) {
                            [viewController reloadData];
                        }
                    }
                }
            }
        });
    }
}
//判断读取设备权限是否足够
- (void)greantedPermission:(NSNumber *)functionType {
    BOOL isGreanted = [_android checkDevicePermisson];
    if (!isGreanted) {
        [self performSelectorOnMainThread:@selector(setGreantedPermission:) withObject:functionType waitUntilDone:0];
    }else {
        if (_category == Category_Summary) {
            [self loadDeviceData];
        }else {
            IMBBaseViewController *viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:_category]];
            if (viewController) {
                if (functionType.intValue == ReloadFunctionType) {
                    [viewController reloadData];
                }
            }
        }
    }
}
//弹出窗口，提示用户到设备上进行权限允许
- (void)setGreantedPermission:(NSNumber *)functionType {
    NSView *view = nil;
    for (NSView *subView in ((NSView *)((IMBAndroidViewController *)_delegate)->_mainWindow.contentView).subviews) {
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
            [self performSelector:@selector(checkDeviceGreantedPermission:) withObject:functionType afterDelay:0.6];
        }else {
            if (_category == Category_Summary) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [self loadDeviceData];
                });
            }else {
                IMBBaseViewController *viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:_category]];
                if (viewController) {
                    if (functionType.intValue == ReloadFunctionType) {
                        [viewController cancelReload];
                    }
                }
            }
        }
    }
}

#pragma mark - BoxActions
- (void)doAndroidToiTunes:(id)sender {
    if (!_loadFinish) {
        [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_devicedata", nil) withSuperView:sender];
        return;
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"Content to iTunes" label:Click transferCount:0 screenView:@"Content to iTunes Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSMutableArray *cagetoryArray = [[NSMutableArray alloc] init];
    for (IMBFunctionButton *btn in _categoryBtnBarView.allcategoryArr) {
        if (btn.tag == Category_Music || btn.tag == Category_Movies || btn.tag == Category_Ringtone || btn.tag == Category_Photo ) {
            if (btn.tag == Category_Music) {
                NSArray *musicArray = [_android getAudioContent].reslutArray;
                if ((int)musicArray.count == 0) {
                    continue;
                }
            }else if (btn.tag == Category_Movies){
                NSArray *videoArray = [_android getVideoContent].reslutArray;
                if ((int)videoArray.count == 0) {
                    continue;
                }
            }else if (btn.tag == Category_Ringtone){
                NSArray *ringtoneArray = [_android getRingtoneContent].reslutArray;
                if ((int)ringtoneArray.count == 0) {
                    continue;
                }
            }else if (btn.tag == Category_iBooks){
                NSArray *bookArray = [_android getiBooksContent].reslutArray;
                if ((int)bookArray.count == 0) {
                    continue;
                }
            }else if (btn.tag == Category_Photo){
                NSArray *photoArray = [_android getGalleryContent].reslutArray;
                if ((int)photoArray.count == 0) {
                    continue;
                }
            }
            
            IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
            model.categoryName = btn.buttonName;
            [model setCategoryNameAttributedString];
            model.categoryImage = btn.selectIcon;
            model.categoryNodes = (CategoryNodesEnum)btn.tag;
            model.isSelected = YES;
            [cagetoryArray addObject:model];
            [model release];
        }
    }
    IMBAndroidMergeViewController *controller = [[IMBAndroidMergeViewController alloc] initToiTunesAndroid:_android CategoryInfoModelArrary:cagetoryArray];
    [controller setDelegate:self];
    [self setShowTopLineView:YES];
    [controller.view setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
    [controller.view setWantsLayer:YES];
    [self.view addSubview:controller.view];
    CABasicAnimation *anima1 = [IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-controller.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1];
    [controller.view.layer addAnimation:anima1 forKey:@"deviceImageView"];
    //    }
    [cagetoryArray release];
    [self setTrackingAreaEnable:NO];
}

- (void)doAndroidToiOS:(id)sender {
    //测试
    //获取iOS设备句柄
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    NSArray *devieArray = connection.getConnectedIPods;
    if ([devieArray count]==0) {
        [self showAlertText:CustomLocalizedString(@"android_toDevices_NoIOSDeviceTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
        return;
    }
    IMBiPod *ipod = [devieArray objectAtIndex:0];
    if (devieArray.count == 1) {
        if (![ipod.deviceInfo isIOSDevice]) {
            [self showAlertText:CustomLocalizedString(@"android_toDevices_NoIOSDeviceTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            return;
        }
    }
    if (ipod.infoLoadFinished&&_loadFinish) {
        if (ipod.beingSynchronized) {
            [self showAlertText:CustomLocalizedString(@"AirsyncTips", nil) OKButton:CustomLocalizedString(@"Button_Ok", nil)];
            return;
        }
    }else {
        [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_devicedata", nil) withSuperView:sender];
        return;
    }
    if (![self checkInternetAvailble]) {
        return;
    }
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"Content to iOS" label:Click transferCount:0 screenView:@"Content to iOS Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    NSMutableArray *cagetoryArray = [[NSMutableArray alloc] init];
    for (IMBFunctionButton *btn in _categoryBtnBarView.allcategoryArr) {
        if (![ipod.deviceInfo.deviceClass isEqualToString:@"iPhone"]) {
            if (btn.tag == Category_CallHistory) {
                continue;
            }
        }
        if (btn.tag == Category_Message) {
            IMBResultEntity *messageResult = [_android getSMSContent];
            NSArray *messageArray = messageResult.reslutArray;
            if (messageArray.count == 0) {
                continue;
            }
        }else if (btn.tag == Category_Contacts) {
            IMBResultEntity *contactResult = [_android getContactContent];
            NSArray *contactArray = contactResult.reslutArray;
            if (contactArray.count == 0) {
                continue;
            }
        }else if (btn.tag == Category_CallHistory) {
            IMBResultEntity *callLogResult = [_android getCallHistoryContent];
            NSArray *callLogArray = callLogResult.reslutArray;
            if (callLogArray.count == 0) {
                continue;
            }
        }else if (btn.tag == Category_Calendar) {
            IMBResultEntity *calendarResult = [_android getCalendarContent];
            NSArray *calendarArray = calendarResult.reslutArray;
            if (calendarArray.count == 0) {
                continue;
            }
        }else if (btn.tag == Category_Music) {
            IMBResultEntity *audioResult = [_android getAudioContent];
            NSArray *audioArray = audioResult.reslutArray;
            if (audioArray.count == 0) {
                continue;
            }
        }else if (btn.tag == Category_Movies) {
            IMBResultEntity *videoResult = [_android getVideoContent];
            NSArray *videoArray = videoResult.reslutArray;
            if (videoArray.count == 0) {
                continue;
            }
        }else if (btn.tag == Category_Ringtone) {
            IMBResultEntity *ringtoneResult = [_android getRingtoneContent];
            NSArray *ringtoneArray = ringtoneResult.reslutArray;
            if (ringtoneArray.count == 0) {
                continue;
            }
        }else if (btn.tag == Category_Photo) {
            IMBResultEntity *photoResult = [_android getGalleryContent];
            NSArray *photoArray = photoResult.reslutArray;
            if (photoArray.count == 0) {
                continue;
            }
        }else if (btn.tag == Category_iBooks) {
            IMBResultEntity *iBooksResult = [_android getiBooksContent];
            NSArray *iBooksArray = iBooksResult.reslutArray;
            if (iBooksArray.count == 0) {
                continue;
            }
        }else if (btn.tag == Category_Compressed) {
            continue;
        }else if (btn.tag == Category_Document) {
            continue;
        }
        IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
        model.categoryName = btn.buttonName;
        [model setCategoryNameAttributedString];
        model.categoryImage = btn.selectIcon;
        model.categoryNodes = (CategoryNodesEnum)btn.tag;
        model.isSelected = YES;
        [cagetoryArray addObject:model];
        [model release];
    }
    
    IMBAndroidMergeViewController *controller = [[IMBAndroidMergeViewController alloc] initWithiPod:ipod CategoryInfoModelArrary:cagetoryArray TransferType:ToDeviceType  WithAndroid:_android];
    [controller setDelegate:self];
    [self setShowTopLineView:YES];
    [controller.view setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
    [controller.view setWantsLayer:YES];
    [self.view addSubview:controller.view];
    CABasicAnimation *anima1 = [IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-controller.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1];
    [controller.view.layer addAnimation:anima1 forKey:@"deviceImageView"];
    //    }
    [cagetoryArray release];
    [self setTrackingAreaEnable:NO];
}

- (void)doAndroidToiCloud:(id)sender {
    if (!_loadFinish) {
        [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_devicedata", nil) withSuperView:sender];
        return;
    }
    //判断有没有icloud账号登陆
    BOOL success = [self checkIsLoginiCloud];
    if (success) {
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"Content to iCloud" label:Click transferCount:0 screenView:@"Content to iCloud Choose View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        IMBDeviceConnection *deviceConntection = [IMBDeviceConnection singleton];
        NSMutableArray *cagetoryArray = [[NSMutableArray alloc] init];
        
        //判断是否获取了相应数据
        IMBResultEntity *contactResult = [_android getContactContent];
        NSArray *contactArray = contactResult.reslutArray;
        
        IMBResultEntity *galleryResult = [_android getGalleryContent];
        NSArray *galleryArray = galleryResult.reslutArray;
        
        IMBResultEntity *calendarResult = [_android getCalendarContent];
        NSArray *calendarArray = calendarResult.reslutArray;
        
        for (IMBFunctionButton *btn in _categoryBtnBarView.allcategoryArr) {
            if (btn.tag == Category_Calendar || btn.tag == Category_Contacts || btn.tag == Category_Photo) {
                
                if (btn.tag == Category_Photo) {
                    if ((int)galleryArray.count == 0) {
                        continue;
                    }
                }else if (btn.tag == Category_Contacts){
                    if ((int)contactArray.count == 0) {
                        continue;
                    }
                }else if (btn.tag == Category_Calendar){
                    if ((int)calendarArray.count == 0) {
                        continue;
                    }
                }
                IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
                model.categoryName = btn.buttonName;
                [model setCategoryNameAttributedString];
                model.categoryImage = btn.selectIcon;
                model.categoryNodes = (CategoryNodesEnum)btn.tag;
                model.isSelected = YES;
                [cagetoryArray addObject:model];
                [model release];
            }
        }
        IMBAndroidMergeViewController *controller = [[IMBAndroidMergeViewController alloc] initWithiCloudManager:_iCloudManager WithAndroid:_android AccountDic:deviceConntection.iCloudDic CategoryInfoModelArrary:cagetoryArray];
        [controller setDelegate:self];
        [self setShowTopLineView:YES];
        [controller.view setFrameSize:NSMakeSize(NSWidth(_contentBox.frame), NSHeight(_contentBox.frame))];
        [controller.view setWantsLayer:YES];
        [self.view addSubview:controller.view];
        CABasicAnimation *anima1 = [IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-controller.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1];
        [controller.view.layer addAnimation:anima1 forKey:@"deviceImageView"];
        [self setTrackingAreaEnable:NO];
    }else {
        return;
    }
}

- (void)showLoadPromptPopover:(NSString *)promptName withSuperView:(NSView *)view{
    if (_loadPopover != nil) {
        [_loadPopover release];
        _loadPopover = nil;
    }
    _loadPopover = [[NSPopover alloc] init];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
        _loadPopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
    }else {
        _loadPopover.appearance = NSPopoverAppearanceMinimal;
    }
    
    _loadPopover.animates = YES;
    _loadPopover.behavior = NSPopoverBehaviorSemitransient;
    _loadPopover.delegate = self;
    
    IMBPopViewController *loadPopVC = [[IMBPopViewController alloc] initWithPromptName:promptName];
    [loadPopVC.view setFrameSize:NSMakeSize(180, loadPopVC.view.frame.size.height - 10)];
    if (_loadPopover != nil) {
        _loadPopover.contentViewController = loadPopVC;
    }
    [loadPopVC release];
    
    NSRectEdge prefEdge = NSMinYEdge;
    NSRect rect = NSMakeRect(view.bounds.origin.x+18, view.bounds.origin.y + view.bounds.size.height/2, view.bounds.size.width, view.bounds.size.height);
    [_loadPopover showRelativeToRect:rect ofView:view preferredEdge:prefEdge];
}

#pragma mark - chanageCategory View
- (void)changeView:(CategoryNodesEnum)categoryEnum {
    if (categoryEnum == Category_Summary) {
        [self setShowTopLineView:NO];
        [_detailBox setFrameSize:self.view.frame.size];
        [_toolBar addSubview:_popUpButton];
        [_toolBar setHidden:YES];
        [_searchFieldBtn setHidden:YES];
        [_mainTopLineView setHidden:YES];
        [_searchFieldBtn setStringValue:@""];
        _isSearch = NO;
        [_detailBox setContentView:_firstCustomView];
        _category = Category_Summary;
    }else {
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        if (categoryEnum == Category_Music) {
            [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"Music" label:Switch transferCount:0 screenView:@"MoveToiOS Music View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (categoryEnum == Category_Movies){
            [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"Movies" label:Switch transferCount:0 screenView:@"MoveToiOS Movies View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (categoryEnum == Category_Ringtone) {
            [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"Ringtones" label:Switch transferCount:0 screenView:@"MoveToiOS Ringtones View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (categoryEnum == Category_Photo){
            [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"Photo Library" label:Switch transferCount:0 screenView:@"MoveToiOS Photo Library View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (categoryEnum == Category_iBooks){
            [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"Books" label:Switch transferCount:0 screenView:@"MoveToiOS Books View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (categoryEnum == Category_Contacts) {
            [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"Contacts" label:Switch transferCount:0 screenView:@"MoveToiOS Contacts View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (categoryEnum == Category_Message) {
            [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"Messages" label:Switch transferCount:0 screenView:@"MoveToiOS Messages View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (categoryEnum == Category_Document) {
            [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"Document" label:Switch transferCount:0 screenView:@"MoveToiOS Document View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (categoryEnum == Category_Compressed) {
            [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"Compressed File" label:Switch transferCount:0 screenView:@"MoveToiOS Compressed File View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (categoryEnum == Category_CallHistory){
            [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"CallHistory" label:Switch transferCount:0 screenView:@"MoveToiOS CallHistory View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (categoryEnum == Category_Calendar){
            [ATTracker event:Move_To_iOS action:ActionNone actionParams:@"Calendars" label:Switch transferCount:0 screenView:@"MoveToiOS Calendars View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [self setShowTopLineView:YES];
        [_detailBox setFrameSize:NSMakeSize(self.view.frame.size.width, self.view.frame.size.height - 39)];
        [_toolBar setHidden:NO];
        [_searchFieldBtn setHidden:NO];
        [_mainTopLineView setHidden:NO];
        [_searchFieldBtn setStringValue:@""];
        IMBBaseViewController *viewController = nil;
        BOOL isViewDisplay = YES;
        int segSelect = 1;
        if (categoryEnum == Category_Photo) {
            if ([_displayModeDic.allKeys containsObject:[NSNumber numberWithInt:categoryEnum]]) {
                segSelect = [[_displayModeDic objectForKey:[NSNumber numberWithInt:categoryEnum]] intValue];
            }
            if (segSelect == 0) {
                isViewDisplay = NO;
            }else if (segSelect == 1) {
                isViewDisplay = YES;
            }
            
            [_toolBar addSubview:_popUpButton];
            viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:categoryEnum]];
        }else {
            [_toolBar addSubview:_popUpButton];
            isViewDisplay = NO;
            viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:categoryEnum]];
            viewController.isSearch = NO;
        }
        if (!viewController) {
            if (categoryEnum == Category_Music) {
                viewController = [[IMBAndroidVdoAndAdoViewController alloc] initwithAndroid:_android withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_Movies){
                viewController = [[IMBAndroidVdoAndAdoViewController alloc] initwithAndroid:_android withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_Ringtone) {
                viewController = [[IMBAndroidVdoAndAdoViewController alloc] initwithAndroid:_android withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_Photo){
                viewController = [[IMBAndroidAlbumsViewController alloc] initwithAndroid:_android withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_iBooks){
                viewController = [[IMBAndroidDcAndCpAndBkViewController alloc] initwithAndroid:_android withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_Contacts) {
                viewController = [[IMBAndroidContactViewController alloc] initwithAndroid:_android withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_Message) {
                viewController = [[IMBAndroidMessageViewController alloc] initwithAndroid:_android withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_Document) {
                viewController = [[IMBAndroidDcAndCpAndBkViewController alloc] initwithAndroid:_android withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_Compressed) {
                viewController = [[IMBAndroidDcAndCpAndBkViewController alloc] initwithAndroid:_android withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_CallHistory){
                viewController = [[IMBAndroidCallHistoryViewController alloc] initwithAndroid:_android withCategoryNodesEnum:categoryEnum withDelegate:self];
            }else if (categoryEnum == Category_Calendar){
                viewController = [[IMBAndroidCalendarViewController alloc] initwithAndroid:_android withCategoryNodesEnum:categoryEnum withDelegate:self];
            }
            
            if (viewController != nil) {
                HoverButton *button1 = [self.view viewWithTag:200];
                HoverButton *button2 = [self.view viewWithTag:201];
                [button1 setHidden:YES];
                [button2 setHidden:YES];
                _category = categoryEnum;
                [self loadToolBarButton:categoryEnum withIsViewDisplay:isViewDisplay withViewController:viewController];
                
                if (isViewDisplay) {
                    if(categoryEnum == Category_Photo) {
                        [_detailPageDic setObject:viewController forKey:[NSNumber numberWithInt:categoryEnum]];
                    }else {
                        [_detailPageDic setObject:viewController forKey:[NSString stringWithFormat:@"%d-%d",categoryEnum,segSelect]];
                    }
                }else {
                    [_detailPageDic setObject:viewController forKey:[NSNumber numberWithInt:categoryEnum]];
                }
                [viewController setToolBar:_toolBar];
                [_detailBox setContentView:viewController.view];
                [viewController release];
            }
        }else{
            HoverButton *button1 = [self.view viewWithTag:200];
            HoverButton *button2 = [self.view viewWithTag:201];
            [button1 setHidden:YES];
            [button2 setHidden:YES];
            _category = categoryEnum;
            if (categoryEnum == Category_Photo) {
                if ([(IMBAndroidAlbumsViewController *)viewController currentSelectView] == 0) {
                    [self loadToolBarButton:categoryEnum withIsViewDisplay:NO withViewController:viewController];
                }else {
                    [self loadToolBarButton:categoryEnum withIsViewDisplay:YES withViewController:viewController];
                }
            }else {
                [self loadToolBarButton:categoryEnum withIsViewDisplay:isViewDisplay withViewController:viewController];
            }
            [viewController setToolBar:_toolBar];
            [viewController reloadTableView];
//            if (categoryEnum == Category_CallHistory) {
//                [viewController setIsSearch:NO];
//                [(IMBAndroidCallHistoryViewController *)viewController loadSonAryData];
//            }
            [_detailBox setContentView:viewController.view];
        }
    }
}

- (void)doBack:(id)sender {
    [self changeView:Category_Summary];
}

#pragma mark - 切换视图模式
- (void)doSwitchView:(id)sender {
    IMBSegmentedBtn *segBtn = (IMBSegmentedBtn *)sender;
    [_displayModeDic setObject:[NSNumber numberWithInteger:segBtn.selectedSegment] forKey:[NSNumber numberWithInt:_category]];
    if (segBtn.selectedSegment == 0) {
        IMBBaseViewController *viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:_category]];
        if (viewController) {
            //加载工具栏按钮
            [self loadToolBarButton:_category withIsViewDisplay:NO withViewController:viewController];
            [viewController reloadTableView];
            [_detailBox setContentView:viewController.view];
            [viewController setTableViewHeadOrCollectionViewCheck];
        }else {
            if (viewController != nil) {
                //加载工具栏按钮
                [self loadToolBarButton:_category withIsViewDisplay:NO withViewController:viewController];
                [_detailPageDic setObject:viewController forKey:[NSNumber numberWithInt:_category]];
                [viewController setTableViewHeadOrCollectionViewCheck];
                [_detailBox setContentView:viewController.view];
                [viewController release];
            }
        }
    }else if (segBtn.selectedSegment == 1){
        NSString *key = [NSString stringWithFormat:@"%d-%ld",_category,(long)segBtn.selectedSegment];
        IMBBaseViewController *viewController = [_detailPageDic objectForKey:key];
        if (viewController) {
            //加载工具栏按钮
            [self loadToolBarButton:_category withIsViewDisplay:YES withViewController:viewController];
            [_detailBox setContentView:viewController.view];
            [viewController setTableViewHeadOrCollectionViewCheck];
        }else {
            if (viewController != nil) {
                //加载工具栏按钮
                [self loadToolBarButton:_category withIsViewDisplay:YES withViewController:viewController];
                [_detailPageDic setObject:viewController forKey:key];
                [_detailBox setContentView:viewController.view];
                [viewController setTableViewHeadOrCollectionViewCheck];
                [viewController release];
            }
        }
    }
}

- (void)loadToolBarButton:(CategoryNodesEnum)categoryEnum withIsViewDisplay:(BOOL)isViewDisplay withViewController:(id)viewController{
    if (categoryEnum == Category_Music) {
        [_toolBar loadAndriodButtons:[NSArray arrayWithObjects:@(0),@(3),@(5),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Movies){
        [_toolBar loadAndriodButtons:[NSArray arrayWithObjects:@(0),@(3),@(5),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Ringtone){
        [_toolBar loadAndriodButtons:[NSArray arrayWithObjects:@(0),@(3),@(5),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Photo){
        [_toolBar loadAndriodButtons:[NSArray arrayWithObjects:@(0),@(3),@(5),@(17),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];
    }else if (categoryEnum == Category_iBooks){
        [_toolBar loadAndriodButtons:[NSArray arrayWithObjects:@(0),@(5),@(13), nil] Target:viewController DisplayMode:isViewDisplay];
    }else if (categoryEnum == Category_Contacts){
        [_toolBar loadAndriodButtons:[NSArray arrayWithObjects:@(0),@(5),@(17),@(13), nil] Target:viewController DisplayMode:isViewDisplay];
    }else if (categoryEnum == Category_Message){
        [_toolBar loadAndriodButtons:[NSArray arrayWithObjects:@(0),@(5),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_CallHistory){
        [_toolBar loadAndriodButtons:[NSArray arrayWithObjects:@(0),@(5),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Calendar) {
        [_toolBar loadAndriodButtons:[NSArray arrayWithObjects:@(0),@(5),@(17),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Document) {
        [_toolBar loadAndriodButtons:[NSArray arrayWithObjects:@(0),@(5),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Compressed) {
        [_toolBar loadAndriodButtons:[NSArray arrayWithObjects:@(0),@(5),@(13), nil] Target:viewController DisplayMode:NO];
    }
}

- (void)doBackView:(id)sender {
    [self changeView:Category_Summary];
    if (_categoryBarView.popUpView.frame.size.height<= ArrowSize) {
        HoverButton *button1 = [self.view viewWithTag:200];
        HoverButton *button2 = [self.view viewWithTag:201];
        [button1 setHidden:NO];
        [button2 setHidden:NO];
    }
}

#pragma mark - 滑动上下切换 box和category视图
- (void)switchView:(HoverButton *)button {
    if (button.tag == 200) {
        [_scrollView setIsdown:NO];
        [self scrollerView:_scrollView withDown:NO];
    }else{
        [_scrollView setIsdown:YES];
        [self scrollerView:_scrollView withDown:YES];
    }
    [self configTipPopover:button];
}

- (void)configTipPopover:(id)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSNumber *number= [ user objectForKey:@"knownScroll"];
    BOOL isknown = [number boolValue];
    if (isknown) {
        return;
    }
    
    if (_tipPopover != nil) {
        [_tipPopover close];
        [_tipPopover release];
        _tipPopover = nil;
    }
    _tipPopover = [[NSPopover alloc] init];
    
    if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
        _tipPopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];//
        
    }else {
        _tipPopover.appearance = NSPopoverAppearanceMinimal;
    }
    _tipPopover.animates = YES;
    _tipPopover.behavior = NSPopoverBehaviorTransient;
    _tipPopover.delegate = self;
    
    IMBTipPopoverViewController *loadPopVC = [[IMBTipPopoverViewController alloc] initWithNibName:@"IMBTipPopoverViewController" bundle:nil];
    if (_tipPopover != nil) {
        _tipPopover.contentViewController = loadPopVC;
    }
    [loadPopVC release], loadPopVC = nil;
    
    NSRectEdge prefEdge = NSMinYEdge;
    HoverButton * btn = (HoverButton *)sender;
    
    NSRect rect = NSMakeRect(btn.bounds.origin.x, btn.bounds.origin.y - 20, btn.bounds.size.width, btn.bounds.size.height);
    [_tipPopover showRelativeToRect:rect ofView:btn preferredEdge:prefEdge];
}

- (void)closeTipPopover {
    BOOL isknown = YES;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:[NSNumber numberWithBool:isknown] forKey:@"knownScroll"];
    if (_tipPopover != nil) {
        [_tipPopover close];
    }
}

- (void)moveMainViewBtnAnimation {
    [_mainFunctionView setFrame:NSMakeRect(0, (self.view.frame.size.height - _mainFunctionView.frame.size.height)/2, self.view.frame.size.width, _mainFunctionView.frame.size.height)];
    [_androidToiCloud setFrameOrigin:NSMakePoint((self.view.frame.size.width-1060)/2 + 180 + 30, 161)];
    [_androidToiOS setFrameOrigin:NSMakePoint((self.view.frame.size.width-1060)/2 + 400 + 30, 150)];
    [_androidToiTunes setFrameOrigin:NSMakePoint((self.view.frame.size.width-1060)/2 + 660 + 30, 159)];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_androidToiCloud setHidden:NO];
        [_androidToiCloud setWantsLayer:YES];
        NSPoint point = _androidToiCloud.frame.origin;
        CGMutablePathRef fillPath = CGPathCreateMutable();
        CAKeyframeAnimation *animation = [IMBAnimation keyframeAniamtion:fillPath cp1x:-500 cp1y:point.y+100 cp2x:point.x/2 cp2y:_androidToiCloud.frame.origin.y endPointX:point.x endPointY:point.y layer:_androidToiCloud.layer];
        [animation setDuration:1];
        animation.autoreverses = NO;
        CABasicAnimation *opAnimation = [IMBAnimation opacityChange_Animation:1 fromValue:[NSNumber numberWithInt:0.2] toValue:[NSNumber numberWithInt:1] durTimes:1];
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        group.duration = 1;
        group.autoreverses = NO;
        group.removedOnCompletion = NO;
        group.repeatCount = 1;
        group.animations = [NSArray arrayWithObjects:animation,opAnimation,nil];
        [_androidToiCloud.layer addAnimation:group forKey:@"deviceImageView"];
        
        [_androidToiTunes setHidden:NO];
        [_androidToiTunes setWantsLayer:YES];
        NSPoint addpoint = _androidToiTunes.frame.origin;
        CGMutablePathRef fillPath1 = CGPathCreateMutable();
        CAKeyframeAnimation *animation1 = [IMBAnimation keyframeAniamtion:fillPath1 cp1x:self.view.frame.size.width cp1y:addpoint.y+100 cp2x:self.view.frame.size.width/2+addpoint.x/2 cp2y:addpoint.y endPointX:addpoint.x endPointY:addpoint.y layer:_androidToiTunes.layer];
        [animation1 setDuration:1];
        animation1.autoreverses = NO;
        CABasicAnimation *opAnimation1 = [IMBAnimation opacityChange_Animation:1 fromValue:[NSNumber numberWithInt:0.2] toValue:[NSNumber numberWithInt:1] durTimes:1];
        CAAnimationGroup *group1 = [CAAnimationGroup animation];
        group1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        group1.duration = 1;
        group1.autoreverses = NO;
        group1.removedOnCompletion = NO;
        group1.repeatCount = 1;
        group1.animations = [NSArray arrayWithObjects:animation1,opAnimation1,nil];
        [_androidToiTunes.layer addAnimation:group1 forKey:@"deviceImageView"];
        
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [_androidToiOS setHidden:NO];
            [_androidToiOS setWantsLayer:YES];
            NSPoint todevicepoint = _androidToiOS.frame.origin;
            CGMutablePathRef fillPath1 = CGPathCreateMutable();
            CAKeyframeAnimation *animation1 = [IMBAnimation keyframeAniamtion:fillPath1 cp1x:self.view.frame.size.width cp1y:todevicepoint.y-100 cp2x:self.view.frame.size.width/2+todevicepoint.x/2 cp2y:todevicepoint.y endPointX:todevicepoint.x endPointY:todevicepoint.y layer:_androidToiOS.layer];
            [animation1 setDuration:0.7];
            animation1.autoreverses = NO;
            CABasicAnimation *opAnimation1 = [IMBAnimation opacityChange_Animation:1 fromValue:[NSNumber numberWithInt:0.2] toValue:[NSNumber numberWithInt:1] durTimes:0.7];
            CAAnimationGroup *group1 = [CAAnimationGroup animation];
            group1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            group1.duration = 0.7;
            group1.autoreverses = NO;
            group1.removedOnCompletion = NO;
            group1.repeatCount = 1;
            group1.animations = [NSArray arrayWithObjects:animation1,opAnimation1,nil];
            [_androidToiOS.layer addAnimation:group1 forKey:@"deviceImageView"];
        });
    } completionHandler:^{
        [_mainFunctionView setFrame:NSMakeRect((self.view.frame.size.width-1060)/2, _mainFunctionView.frame.origin.y, 1060, _mainFunctionView.frame.size.height)];
        
        [_androidToiCloud setFrameOrigin:NSMakePoint(180 + 30, 161)];
        [_androidToiOS setFrameOrigin:NSMakePoint(400 + 30, 150)];
        [_androidToiTunes setFrameOrigin:NSMakePoint(660 + 30, 159)];
        
        [_androidToiCloud.layer removeAllAnimations];
        [_androidToiTunes.layer removeAllAnimations];
        [_androidToiOS.layer removeAllAnimations];
        [self startTestBtnAnimation];
    }];
}

- (void)startTestBtnAnimation {
    [_androidToiCloud.layer setMasksToBounds:NO];
    CABasicAnimation *anima2 = [IMBAnimation moveX:2.4 X:[NSNumber numberWithInt:-10] repeatCount:1 beginTime:0];
    anima2.beginTime=0;
    CABasicAnimation *anima22 = [IMBAnimation moveY:1.92 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-8] repeatCount:1 beginTime:1 isAutoreverses:NO];
    anima22.beginTime=2.4;
    CABasicAnimation *anima222 = [IMBAnimation moveX:2.16 X:[NSNumber numberWithInt:-19] repeatCount:1 beginTime:0];
    anima222.beginTime=4.32;
    CABasicAnimation *anima2222 = [IMBAnimation moveY:2.88 X:[NSNumber numberWithInt:-8] Y:[NSNumber numberWithInt:4] repeatCount:1 beginTime:0 isAutoreverses:NO];
    anima2222.beginTime=6.48;
    CABasicAnimation *anima22222 = [IMBAnimation moveX:2.64 X:[NSNumber numberWithInt:-30] repeatCount:1 beginTime:0];
    anima22222.beginTime=9.36;
    CAAnimationGroup *group2 = [CAAnimationGroup animation];
    group2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group2.duration = 12;
    group2.autoreverses = YES;
    group2.removedOnCompletion = NO;
    group2.repeatCount = NSIntegerMax;
    group2.animations = [NSArray arrayWithObjects:anima2,anima22,anima222,anima2222,anima22222, nil];
    [_androidToiCloud.layer addAnimation:group2 forKey:@"deviceImageView"];
    
    [_androidToiOS.layer setMasksToBounds:NO];
    CABasicAnimation *anima1 = [IMBAnimation moveY:3.12 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-13] repeatCount:1 beginTime:1 isAutoreverses:NO];
    anima1.beginTime=0;
    CABasicAnimation *anima11 = [IMBAnimation moveX:1.68 X:[NSNumber numberWithInt:-7] repeatCount:1 beginTime:0];
    anima11.beginTime=3.12;
    CABasicAnimation *anima111 = [IMBAnimation moveY:3.12 X:[NSNumber numberWithInt:-13] Y:[NSNumber numberWithInt:0] repeatCount:1 beginTime:0 isAutoreverses:NO];
    anima111.beginTime=4.8;
    CABasicAnimation *anima1111 = [IMBAnimation moveX:1.68 X:[NSNumber numberWithInt:7] repeatCount:1 beginTime:0];
    anima1111.beginTime=7.92;
    CAAnimationGroup *group1 = [CAAnimationGroup animation];
    group1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group1.duration = 9.6;
    group1.autoreverses = YES;
    group1.removedOnCompletion = NO;
    group1.repeatCount = NSIntegerMax;
    group1.animations = [NSArray arrayWithObjects:anima1,anima11,anima111,anima1111, nil];
    [_androidToiOS.layer addAnimation:group1 forKey:@"deviceImageView"];
    
    [_androidToiTunes.layer setMasksToBounds:NO];
    CABasicAnimation *anima5 = [IMBAnimation moveX:2.16 X:[NSNumber numberWithInt:9] repeatCount:1 beginTime:0];
    anima5.beginTime=0;
    CABasicAnimation *anima55 = [IMBAnimation moveY:1.44 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:6] repeatCount:1 beginTime:1 isAutoreverses:NO];
    anima55.beginTime=2.16;
    CABasicAnimation *anima555 = [IMBAnimation moveX:3.6 X:[NSNumber numberWithInt:24] repeatCount:1 beginTime:0];
    anima555.beginTime=3.6;
    CAAnimationGroup *group5 = [CAAnimationGroup animation];
    group5.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group5.duration = 7.2;
    group5.autoreverses = YES;
    group5.removedOnCompletion = NO;
    group5.repeatCount = NSIntegerMax;
    group5.animations = [NSArray arrayWithObjects:anima5,anima55,anima555,nil];
    [_androidToiTunes.layer addAnimation:group5 forKey:@"deviceImageView"];
}

#pragma mark - 搜索
-(void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    IMBBaseViewController *viewController = nil;
    viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:_category]];
    [viewController doSearchBtn:searchStr withSearchBtn:searchBtn];
}

#pragma mark - IMBScrollerProtocol delegate
- (void)scrollerView:(NSView *)scrollView withDown:(BOOL)isDown {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        HoverButton *button1 = [self.view viewWithTag:200];
        HoverButton *button2 = [self.view viewWithTag:201];
        if (isDown) {
            [button1 setIsSelected:NO];
            [button2 setIsSelected:YES];
            
            [_functionView removeFromSuperview];
            [self stopTestBtnAnimation];
            CATransition *transition = [self pushAnimation:kCATransitionPush withSubType:kCATransitionFromBottom durTimes:0.5];
            [_contentBox.layer removeAllAnimations];
            [_contentBox.layer addAnimation:transition forKey:@"animation"];
            [_contentBox setContentView:_contentView];
        }else {
            [button1 setIsSelected:YES];
            [button2 setIsSelected:NO];
            
            [_contentView removeFromSuperview];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startTestBtnAnimation];
            });
            CATransition *transition = [self pushAnimation:kCATransitionPush withSubType:kCATransitionFromTop durTimes:0.5];
            [_contentBox.layer removeAllAnimations];
            [_contentBox.layer addAnimation:transition forKey:@"animation"];
            [_contentBox setContentView:_functionView];
        }
    } completionHandler:^{
        [_scrollView setIsScroll:NO];
    }];
}

- (CATransition *)pushAnimation:(NSString *)type withSubType:(NSString *)subType durTimes:(float)time  {
    CATransition *transition = [CATransition animation];
    transition.duration = time;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = type;
    transition.subtype = subType;
    transition.startProgress = 0.0;
    transition.endProgress = 1.0;
    transition.removedOnCompletion = NO;
    transition.fillMode = kCAFillModeForwards;
    return transition;
}

- (void)setTrackingAreaEnable:(BOOL)enable {
    [_androidToiCloud setTrackingAreaEnable:enable];
    [_androidToiOS setTrackingAreaEnable:enable];
    [_androidToiTunes setTrackingAreaEnable:enable];
}

#pragma mark - popupMenuItem
- (void)refeashBadgeConut:(int)badgeConut WithCategory:(CategoryNodesEnum)category {
    for (IMBFunctionButton *btn in _categoryBarView.allcategoryArr) {
        if (btn.tag == category) {
            btn.badgeCount = badgeConut;
            [btn setNeedsDisplay:YES];
            
            NSString *countStr = @"";
            if (btn.badgeCount == 0) {
                countStr = btn.buttonName;
            }else if (btn.badgeCount > 1) {
                if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                    countStr = [NSString stringWithFormat:@"%@ (%d)",btn.title,(int)btn.badgeCount];
                }else {
                    countStr = [NSString stringWithFormat:@"%@ (%d %@)",btn.buttonName,(int)btn.badgeCount,CustomLocalizedString(@"MSG_Item_id_4", nil)];
                }
                
            }else {
                if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                    countStr = [NSString stringWithFormat:@"%@ (%d)",btn.title,(int)btn.badgeCount];
                }else {
                    countStr = [NSString stringWithFormat:@"%@ (%d %@)",btn.buttonName,(int)btn.badgeCount,CustomLocalizedString(@"MSG_Item_id_3", nil)];
                }
            }
            [_popUpButton setTitle:countStr];
            [_occlusionView setFrameOrigin:NSMakePoint(_popUpButton.frame.size.width-_occlusionView.frame.size.width-2, 4)];
            [_popUpButton setNeedsDisplay:YES];
            break;
        }
    }
}

- (NSMenu *)createNavagationMenu {
    NSMenu *mainMenu = [[NSMenu alloc] init];
    [mainMenu setDelegate:self];
    for (IMBFunctionButton *button in _categoryBarView.allcategoryArr) {
        IMBMenuItem *item = [[IMBMenuItem alloc] init];
        [item setAction:@selector(navigateTo:)];
        [item setTarget:self];
        [item setFunctionButton:button];
        [item setEnabled:NO];
        [mainMenu addItem:item];
        [item release];
    }
    return [mainMenu autorelease];
}

#pragma mark - NSMenuDelegate
- (void)menuDidClose:(NSMenu *)menu {
    for (IMBMenuItem *menuitem in menu.itemArray) {
        ((IMBMenuItemView *)menuitem.view).isMouseEnter = NO;
    }
}

- (void)menu:(NSMenu *)menu willHighlightItem:(NSMenuItem *)item {
    for (IMBMenuItem *menuitem in menu.itemArray) {
        if (menuitem == item) {
            ((IMBMenuItemView *)menuitem.view).isMouseEnter = YES;
        }else{
            ((IMBMenuItemView *)menuitem.view).isMouseEnter = NO;
        }
    }
}

- (void)navigateTo:(IMBMenuItem *)item {
    [_searchFieldBtn setStringValue:@""];
    ((IMBMenuItemView *)item.view).isMouseEnter = NO;
    _selectedItem = item;
    [_popUpButton.menu cancelTracking];
    NSString *countStr = @"";
    if (item.badgeCount == 0) {
        countStr = item.functionButton.buttonName;
    }else if (_selectedItem.badgeCount > 1) {
        if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
            countStr = [NSString stringWithFormat:@"%@ ( %d )",item.functionButton.buttonName,(int)item.functionButton.badgeCount];
        }else {
            countStr = [NSString stringWithFormat:@"%@ (%d %@)",item.functionButton.buttonName,(int)item.functionButton.badgeCount,CustomLocalizedString(@"MSG_Item_id_4", nil)];
        }
    }else {
        if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
            countStr = [NSString stringWithFormat:@"%@ ( %d )",item.functionButton.buttonName,(int)item.functionButton.badgeCount];
        }else {
            countStr = [NSString stringWithFormat:@"%@ (%d %@)",item.functionButton.buttonName,(int)item.functionButton.badgeCount,CustomLocalizedString(@"MSG_Item_id_3", nil)];
        }
    }
    [_popUpButton setTitle:countStr];
    [self changeView:(CategoryNodesEnum)item.FunctionButton.tag];
    [_occlusionView setFrameOrigin:NSMakePoint(_popUpButton.frame.size.width-_occlusionView.frame.size.width-2, 4)];
    [_popUpButton setNeedsDisplay:YES];
}

- (void)configMainTitle {
    NSString *str1 = CustomLocalizedString(@"Device_Main_id_9", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str1];
    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:24] range:NSMakeRange(0, as.length)];
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.string.length)];
    [_firstViewmainTitle setAttributedStringValue:as];
    [as release];
    as = nil;
    NSString *str2 = CustomLocalizedString(@"AndroidDevice_Main_id_1", nil);
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:24] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as2.length)];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as2.length)];
    [_secondViewMainTitle setAttributedStringValue:as2];
    [as2 release];
    as2 = nil;
}
- (void)stopTestBtnAnimation {
    [_androidToiOS.layer removeAllAnimations];
    [_androidToiCloud.layer removeAllAnimations];
    [_androidToiTunes.layer removeAllAnimations];
}
//屏蔽按钮
- (void)disableFunctionBtn:(BOOL)isDisable {
    NSArray *array = _toolBar.subviews;
    for (NSView *btn in array) {
        if (![btn isKindOfClass:[IMBMenuPopupButton class]] && btn.tag != 100) {
            if ([btn isKindOfClass:[IMBSegmentedBtn class]]) {
                IMBSegmentedBtn *segmentBtn = (IMBSegmentedBtn *)btn;
                [segmentBtn setEnabled:isDisable];
            }else {
                HoverButton *hoverBtn = (HoverButton *)btn;
                if (isDisable) {
                    [hoverBtn setStatus:1];
                }else {
                    [hoverBtn setStatus:4];
                }
                [hoverBtn setEnabled:isDisable];
                [hoverBtn setNeedsDisplay:YES];
            }
        }
    }
}

- (void)doChangeLanguage:(NSNotification *)notification {
    [super doChangeLanguage:notification];
    [self configMainTitle];
    
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:CustomLocalizedString(@"MSG_Loading_devicedata", nil)];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] range:NSMakeRange(0, as.length)];
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [_loadLabel setAttributedStringValue:as];
    [as release], as = nil;
    
    [_androidToiCloud setTitleName:CustomLocalizedString(@"Android_to_iCloud", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iostool_toicloud"] withTextColor:[NSColor whiteColor]];
    [_androidToiOS setTitleName:CustomLocalizedString(@"Android_to_iOS", nil) WithDarwInterval:28 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iostool_toios"] withTextColor:[NSColor whiteColor]];
    [_androidToiTunes setTitleName:CustomLocalizedString(@"Android_to_iTunes", nil) WithDarwInterval:36 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iostool_toitunes"] withTextColor:[NSColor whiteColor]];
    
    for (IMBFunctionButton *button in _categoryBarView.allcategoryArr){
        if (button.tag == Category_Music) {
            [button setImageWithImageName:@"toios_music" withButtonName:CustomLocalizedString(@"MenuItem_id_1", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navmusic"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectmusic"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_1", nil)];
        }else if (button.tag == Category_Movies) {
            [button setImageWithImageName:@"toios_movies" withButtonName:CustomLocalizedString(@"MenuItem_id_6", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navmovies"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectmovies"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_6", nil)];
        }else if (button.tag == Category_Ringtone) {
            [button setImageWithImageName:@"toios_ringtone" withButtonName:CustomLocalizedString(@"MenuItem_id_2", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navringtone"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectringtone"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_2", nil)];
        }else if (button.tag == Category_Photo) {
            [button setImageWithImageName:@"toios_photo" withButtonName:CustomLocalizedString(@"MenuItem_id_12", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navphoto"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectphoto"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_12", nil)];
        }else if (button.tag == Category_iBooks) {
            [button setImageWithImageName:@"toios_books" withButtonName:CustomLocalizedString(@"MenuItem_id_13", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navbooks"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectbooks"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_13", nil)];
        }else if (button.tag == Category_Contacts) {
            [button setImageWithImageName:@"toios_contact" withButtonName:CustomLocalizedString(@"MenuItem_id_20", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navcontact"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectcontact"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_20", nil)];
        }else if (button.tag == Category_Message) {
            [button setImageWithImageName:@"toios_message" withButtonName:CustomLocalizedString(@"MenuItem_id_19", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navmessage"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectmessage"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_19", nil)];
        }else if (button.tag == Category_CallHistory) {
            [button setImageWithImageName:@"toios_callhistory" withButtonName:CustomLocalizedString(@"MenuItem_CallLog", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navcallhistory"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectcallhistory"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_CallLog", nil)];
        }else if (button.tag == Category_Calendar) {
            [button setImageWithImageName:@"toios_calendar" withButtonName:CustomLocalizedString(@"MenuItem_id_22", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navcalendar"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectcalendar"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_22", nil)];
        }else if (button.tag == Category_Compressed) {
            [button setImageWithImageName:@"toios_compress" withButtonName:CustomLocalizedString(@"MenuItem_id_87", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navcompress"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectcompress"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_87", nil)];
        }else if (button.tag == Category_Document) {
            [button setImageWithImageName:@"toios_document" withButtonName:CustomLocalizedString(@"MenuItem_id_88", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navdocument"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectdocument"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_88", nil)];
        }
        [button setNeedsDisplay:YES];
        [_toolBar changeBtnTooltipStr];
        [_toolBar setNeedsDisplay:YES];
    }
    
    [_popUpButton.menu removeAllItems];
    [_popUpButton setMenu:[self createNavagationMenu]];
    
    for (IMBFunctionButton *btn in _categoryBarView.allcategoryArr) {
        if (btn.tag == _category) {
            [btn setNeedsDisplay:YES];
            
            NSString *countStr = @"";
            if (btn.badgeCount == 0) {
                countStr = btn.buttonName;
            }else if (btn.badgeCount > 1) {
                if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                    countStr = [NSString stringWithFormat:@"%@ (%d)",btn.title,(int)btn.badgeCount];
                }else {
                    countStr = [NSString stringWithFormat:@"%@ (%d %@)",btn.buttonName,(int)btn.badgeCount,CustomLocalizedString(@"MSG_Item_id_4", nil)];
                }
                
            }else {
                if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
                    countStr = [NSString stringWithFormat:@"%@ (%d)",btn.title,(int)btn.badgeCount];
                }else {
                    countStr = [NSString stringWithFormat:@"%@ (%d %@)",btn.buttonName,(int)btn.badgeCount,CustomLocalizedString(@"MSG_Item_id_3", nil)];
                }
            }
            [_popUpButton setTitle:countStr];
            [_occlusionView setFrameOrigin:NSMakePoint(_popUpButton.frame.size.width-_occlusionView.frame.size.width-2, 4)];
            [_popUpButton setNeedsDisplay:YES];
            break;
        }
    }
}

- (void)changeSkin:(NSNotification *)notification {
    [_arrowImageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
    [_scrollView setNeedsDisplay:YES];
    [(IMBBackgroundBorderView *)self.view setIsGradientWithCornerPart4:YES];
    
    [(IMBBackgroundBorderView *)self.view setNeedsDisplay:YES];
    [_firstCustomView setNeedsDisplay:YES];
    [_iCloudBgView setImage:[StringHelper imageNamed:@"device_bg"]];
    
    [_androidToiCloud setComponentColor:[ColorHelper getColorFromColorString:@"android_toicloud_downColor" WithIndex:0] withG1:[ColorHelper getColorFromColorString:@"android_toicloud_downColor" WithIndex:1] withB1:[ColorHelper getColorFromColorString:@"android_toicloud_downColor" WithIndex:2] withAlpha1:[ColorHelper getColorFromColorString:@"android_toicloud_downColor" WithIndex:3] withR2:[ColorHelper getColorFromColorString:@"android_toicloud_upColor" WithIndex:0] withG2:[ColorHelper getColorFromColorString:@"android_toicloud_upColor" WithIndex:1] withB2:[ColorHelper getColorFromColorString:@"android_toicloud_upColor" WithIndex:2] withAlpha2:[ColorHelper getColorFromColorString:@"android_toicloud_upColor" WithIndex:3]];
    [_androidToiCloud setTitleName:CustomLocalizedString(@"Android_to_iCloud", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iostool_toicloud"] withTextColor:[NSColor whiteColor]];
    
    [_androidToiOS setComponentColor:[ColorHelper getColorFromColorString:@"android_toiOS_downColor" WithIndex:0] withG1:[ColorHelper getColorFromColorString:@"android_toiOS_downColor" WithIndex:1] withB1:[ColorHelper getColorFromColorString:@"android_toiOS_downColor" WithIndex:2] withAlpha1:[ColorHelper getColorFromColorString:@"android_toiOS_downColor" WithIndex:3] withR2:[ColorHelper getColorFromColorString:@"android_toiOS_upColor" WithIndex:0] withG2:[ColorHelper getColorFromColorString:@"android_toiOS_upColor" WithIndex:1] withB2:[ColorHelper getColorFromColorString:@"android_toiOS_upColor" WithIndex:2] withAlpha2:[ColorHelper getColorFromColorString:@"android_toiOS_upColor" WithIndex:3]];
    [_androidToiOS setTitleName:CustomLocalizedString(@"Android_to_iOS", nil) WithDarwInterval:28 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iostool_toios"] withTextColor:[NSColor whiteColor]];
    
    [_androidToiTunes setComponentColor:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:0] withG1:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:1] withB1:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:2] withAlpha1:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:3] withR2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:0] withG2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:1] withB2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:2] withAlpha2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:3]];
    [_androidToiTunes setTitleName:CustomLocalizedString(@"Android_to_iTunes", nil) WithDarwInterval:36 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iostool_toitunes"] withTextColor:[NSColor whiteColor]];
    for (IMBFunctionButton *button in _categoryBarView.allcategoryArr){
        if (button.tag == Category_Music) {
            [button setImageWithImageName:@"toios_music" withButtonName:CustomLocalizedString(@"MenuItem_id_1", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navmusic"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectmusic"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_1", nil)];
        }else if (button.tag == Category_Movies) {
            [button setImageWithImageName:@"toios_movies" withButtonName:CustomLocalizedString(@"MenuItem_id_6", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navmovies"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectmovies"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_6", nil)];
        }else if (button.tag == Category_Ringtone) {
            [button setImageWithImageName:@"toios_ringtone" withButtonName:CustomLocalizedString(@"MenuItem_id_2", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navringtone"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectringtone"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_2", nil)];
        }else if (button.tag == Category_Photo) {
            [button setImageWithImageName:@"toios_photo" withButtonName:CustomLocalizedString(@"MenuItem_id_12", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navphoto"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectphoto"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_12", nil)];
        }else if (button.tag == Category_iBooks) {
            [button setImageWithImageName:@"toios_books" withButtonName:CustomLocalizedString(@"MenuItem_id_13", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navbooks"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectbooks"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_13", nil)];
        }else if (button.tag == Category_Contacts) {
            [button setImageWithImageName:@"toios_contact" withButtonName:CustomLocalizedString(@"MenuItem_id_20", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navcontact"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectcontact"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_20", nil)];
        }else if (button.tag == Category_Message) {
            [button setImageWithImageName:@"toios_message" withButtonName:CustomLocalizedString(@"MenuItem_id_19", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navmessage"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectmessage"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_19", nil)];
        }else if (button.tag == Category_CallHistory) {
            [button setImageWithImageName:@"toios_callhistory" withButtonName:CustomLocalizedString(@"MenuItem_CallLog", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navcallhistory"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectcallhistory"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_CallLog", nil)];
        }else if (button.tag == Category_Calendar) {
            [button setImageWithImageName:@"toios_calendar" withButtonName:CustomLocalizedString(@"MenuItem_id_22", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navcalendar"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectcalendar"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_22", nil)];
        }else if (button.tag == Category_Compressed) {
            [button setImageWithImageName:@"toios_compress" withButtonName:CustomLocalizedString(@"MenuItem_id_87", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navcompress"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectcompress"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_87", nil)];
        }else if (button.tag == Category_Document) {
            [button setImageWithImageName:@"toios_document" withButtonName:CustomLocalizedString(@"MenuItem_id_88", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"toios_navdocument"]];
            [button setSelectIcon:[StringHelper imageNamed:@"toios_selectdocument"]];
            [button setToolTip:CustomLocalizedString(@"MenuItem_id_88", nil)];
        }
        [button setNeedsDisplay:YES];
        [_toolBar changeBtnTooltipStr];
        [_toolBar setNeedsDisplay:YES];
    }
    [self configMainTitle];
    HoverButton *detailCategoryBtn = [self.view viewWithTag:200];
    [detailCategoryBtn setMouseEnteredImage:[StringHelper imageNamed:@"mainFrame_switch2"] mouseExitImage:[StringHelper imageNamed:@"mainFrame_switch1"] mouseDownImage:[StringHelper imageNamed:@"mainFrame_switch3"]];
    HoverButton *summaryCategoryBtn = [self.view viewWithTag:201];
    [summaryCategoryBtn setMouseEnteredImage:[StringHelper imageNamed:@"mainFrame_tool2"] mouseExitImage:[StringHelper imageNamed:@"mainFrame_tool1"] mouseDownImage:[StringHelper imageNamed:@"mainFrame_tool3"]];
    [_androidToiCloud setNeedsDisplay:YES];
    [_androidToiOS setNeedsDisplay:YES];
    [_androidToiTunes setNeedsDisplay:YES];
    [_popUpButton setNeedsDisplay:YES];
}

- (void)dealloc {
    [_android release],_android = nil;
    [_loadPopover release],_loadPopover = nil;
    [_detailPageDic removeAllObjects];
    [_detailPageDic release],_detailPageDic = nil;
    [_displayModeDic release],_displayModeDic = nil;
    [_tipPopover release], _tipPopover = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CLOSE_TIP object:nil];
    [super dealloc];
}

- (BOOL)checkIsLoginiCloud {
    BOOL result = NO;
    IMBDeviceConnection *deviceConntection = [IMBDeviceConnection singleton];
    NSMutableArray *baseInfoArr = [NSMutableArray array];
    NSArray *allKey = [[deviceConntection iCloudDic] allKeys];
    if ([allKey count] > 0) {
        for (NSString *key in deviceConntection.iCloudDic.allKeys) {
            IMBBaseInfo *baseInfo = [[IMBBaseInfo alloc]init];
            IMBiCloudManager *otheriCloudManager = [[deviceConntection.iCloudDic objectForKey:key] iCloudManager];
            baseInfo.deviceName = otheriCloudManager.netClient.loginInfo.loginInfoEntity.fullName;
            baseInfo.isicloudView = YES;
            baseInfo.uniqueKey = key;
            [baseInfoArr addObject:baseInfo];
            [baseInfo release];
        }
        IMBBaseInfo *baseInfo = [baseInfoArr objectAtIndex:0];
        _iCloudManager = [[deviceConntection.iCloudDic objectForKey:baseInfo.uniqueKey] iCloudManager];
        _iCloudManager.delegate = self;
        result = YES;
    }else {
        NSString *str = CustomLocalizedString(@"NoAcount_Tip", nil);
//        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
//        return result;
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        if (view) {
            [view setHidden:NO];
            int i = [_alertViewController showDeleteConfrimText:str OKButton:CustomLocalizedString(@"Button_Login", nil)  CancelButton:CustomLocalizedString(@"Button_Cancel", nil) SuperView:view];
            if (i == 1) {//跳转到iCloud登录页面
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_JUMP_ICLOUD_VIEW object:nil];
            }
        }
        return result;
    }
    return result;
}

- (void)setShowTopLineView:(BOOL)isShow {
    [self setIsShowLineView:isShow];
    [_delegate setIsShowLineView:isShow];
}

@end
