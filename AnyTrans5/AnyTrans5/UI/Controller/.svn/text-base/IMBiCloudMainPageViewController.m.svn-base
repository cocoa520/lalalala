//
//  IMBiCloudMainPageViewController.m
//  AnyTrans
//
//  Created by LuoLei on 17-1-16.
//  Copyright (c) 2017年 imobie. All rights reserved.
//
#import "IMBiCloudMainPageViewController.h"
#import "ColorHelper.h"
#import "IMBAnimation.h"
#import "IMBNoteListViewController.h"
#import "IMBContactViewController.h"
#import "IMBReminderViewController.h"
#import "IMBPhotosCollectionViewController.h"
#import "IMBPhotosListViewController.h"
#import "IMBSegmentedBtn.h"
#import "IMBiCloudBackUpViewController.h"
#import "IMBiCloudDriverViewController.h"
#import "IMBiCloudViewController.h"
#import "IMBNotificationDefine.h"
#import "IMBCategoryInfoModel.h"
#import "IMBToMacViewController.h"
#import "IMBAddContentViewController.h"
#import "IMBMergeOrCloneViewController.h"
#import "SystemHelper.h"
#import "IMBPopViewController.h"
#import "ATTracker.h"
#import "IMBiCloudPhotoVideoViewController.h"
#import "IMBiCloudCalendarViewController.h"
#import "IMBTipPopoverViewController.h"

@interface IMBiCloudMainPageViewController ()

@end

@implementation IMBiCloudMainPageViewController
@synthesize isFail = _isFail;
@synthesize popUpButton = _popUpButton;
- (id)initWithClient:(IMBiCloudManager *)iCloudManager withDelegate:(id)delegate {
    if (self = [super init]) {
        _iCloudManager = [iCloudManager retain];
        _delegate = delegate;
    }
    return self;
}

- (NSDictionary *)getiCloudAccountViewCollection {
    if (_delegate != nil) {
        return [(IMBiCloudViewController *)_delegate getiCloudDic];
    }
    return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeTipPopover) name:NOTIFY_CLOSE_TIP object:nil];
    [_arrowImageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
    [(IMBBackgroundBorderView *)self.view setIsGradientWithCornerPart4:YES];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:CustomLocalizedString(@"MSG_Loading_iclouddata", nil)];
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
    
    [_icloudDriver setComponentColor:[ColorHelper getColorFromColorString:@"toMac_upColor" WithIndex:0] withG1:[ColorHelper getColorFromColorString:@"toMac_upColor" WithIndex:1] withB1:[ColorHelper getColorFromColorString:@"toMac_upColor" WithIndex:2] withAlpha1:[ColorHelper getColorFromColorString:@"toMac_upColor" WithIndex:3] withR2:[ColorHelper getColorFromColorString:@"toMac_downColor" WithIndex:0] withG2:[ColorHelper getColorFromColorString:@"toMac_downColor" WithIndex:1] withB2:[ColorHelper getColorFromColorString:@"toMac_downColor" WithIndex:2] withAlpha2:[ColorHelper getColorFromColorString:@"toMac_downColor" WithIndex:3]];
    [_icloudDriver setTitleName:CustomLocalizedString(@"icloud_drive", nil) WithDarwInterval:24 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iCloud_driver"] withTextColor:[NSColor whiteColor]];
    
    [_icloudSync setComponentColor:[ColorHelper getColorFromColorString:@"toDevice_upColor" WithIndex:0] withG1:[ColorHelper getColorFromColorString:@"toDevice_upColor" WithIndex:1] withB1:[ColorHelper getColorFromColorString:@"toDevice_upColor" WithIndex:2] withAlpha1:[ColorHelper getColorFromColorString:@"toDevice_upColor" WithIndex:3] withR2:[ColorHelper getColorFromColorString:@"toDevice_downColor" WithIndex:0] withG2:[ColorHelper getColorFromColorString:@"toDevice_downColor" WithIndex:1] withB2:[ColorHelper getColorFromColorString:@"toDevice_downColor" WithIndex:2] withAlpha2:[ColorHelper getColorFromColorString:@"toDevice_downColor" WithIndex:3]];
    [_icloudSync setTitleName:CustomLocalizedString(@"icloud_sync", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iCloud_sync"] withTextColor:[NSColor whiteColor]];
    
    [_icloudImport setComponentColor:[ColorHelper getColorFromColorString:@"mergeBtn_upColor" WithIndex:0] withG1:[ColorHelper getColorFromColorString:@"mergeBtn_upColor" WithIndex:1] withB1:[ColorHelper getColorFromColorString:@"mergeBtn_upColor" WithIndex:2] withAlpha1:[ColorHelper getColorFromColorString:@"mergeBtn_upColor" WithIndex:3] withR2:[ColorHelper getColorFromColorString:@"mergeBtn_downColor" WithIndex:0] withG2:[ColorHelper getColorFromColorString:@"mergeBtn_downColor" WithIndex:1] withB2:[ColorHelper getColorFromColorString:@"mergeBtn_downColor" WithIndex:2] withAlpha2:[ColorHelper getColorFromColorString:@"mergeBtn_downColor" WithIndex:3]];
    [_icloudImport setTitleName:CustomLocalizedString(@"icloud_import", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iCloud_import"] withTextColor:[NSColor whiteColor]];
    
    [_icloudExport setComponentColor:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:0] withG1:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:1] withB1:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:2] withAlpha1:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:3] withR2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:0] withG2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:1] withB2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:2] withAlpha2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:3]];
    [_icloudExport setTitleName:CustomLocalizedString(@"icloud_export", nil) WithDarwInterval:27 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iCloud_fileexport"] withTextColor:[NSColor whiteColor]];
    
    [_detailBox setContentView:_firstCustomView];
    [_contentBox setWantsLayer:YES];
    [_contentBox setContentView:_functionView];
    [_detailBox setFrameSize:self.view.frame.size];
    [_icloudDriver setHidden:YES];
    [_icloudSync setHidden:YES];
    [_icloudImport setHidden:YES];
    [_icloudExport setHidden:YES];
    [self performSelector:@selector(moveMainViewBtnAnimation) withObject:nil afterDelay:0.1];
    __block IMBiCloudMainPageViewController *this = self;
    [_categoryBarView initializationCategoryBlock:^(CategoryNodesEnum category, IMBFunctionButton *button) {
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
        
        [this changeView:category];
    }];
    
    [_icloudDriver setTarget:self];
    [_icloudDriver setAction:@selector(popUpiCloudDriver:)];
    [_icloudSync setTarget:self];
    [_icloudSync setAction:@selector(iCloudSync:)];
    [_icloudImport setTarget:self];
    [_icloudImport setAction:@selector(iCloudImport:)];
    [_icloudExport setTarget:self];
    [_icloudExport setAction:@selector(iCloudExport:)];
    
    
    [self loadiCloudData];
    [self configMainTitle];
    
    [_popUpButton setMenu:[self createNavagationMenu]];
    [_popUpButton setFrame:NSMakeRect(16+4+36, ceil((NSHeight(_toolBar.frame) - NSHeight(_popUpButton.frame))/2.0),100,22)];
    [_occlusionView setFrameOrigin:NSMakePoint(_popUpButton.frame.size.width-_occlusionView.frame.size.width-2, 4)];
    [_popUpButton addSubview:_occlusionView];
    [_toolBar addSubview:_popUpButton];
    [_iCloudBgView setImage:[StringHelper imageNamed:@"device_bg"]];
    
    [self performSelector:@selector(promptiCloudAppleIDIsNew) withObject:nil afterDelay:0.1];
}

- (void)promptiCloudAppleIDIsNew {
    if (_iCloudManager.netClient.loginInfo.loginInfoEntity.statusCode == 4 && _iCloudManager.netClient.loginInfo.loginInfoEntity.hasICloudQualifyingDevice == 0) {
        if (_alertViewController != nil) {
            [_alertViewController release];
            _alertViewController = nil;
        }
        _alertViewController = [[IMBAlertViewController alloc] initWithNibName:@"IMBAlertViewController" bundle:nil];
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        if (view) {
            [view setHidden:NO];
            [_alertViewController showiCloudOpenViewWithSuperView:view];
        }
    }
}

- (void)loadiCloudData {
    for (IMBFunctionButton *button in _categoryBarView.allcategoryArr) {
        switch (button.tag) {
            case Category_Photo:
            {
                [button addLoadingView];
            }
                break;
            case Category_PhotoVideo:
            {
                [button addLoadingView];
            }
                break;
            case Category_ContinuousShooting:
            {
                [button addLoadingView];
            }
                break;
            case Category_Notes:
            {
                [button addLoadingView];
            }
                break;
            case Category_Contacts:
            {
                [button addLoadingView];
            }
                break;
            case Category_Calendar:
            {
                [button addLoadingView];
            }
                break;
            case Category_Reminder:
            {
                [button addLoadingView];
            }
                break;
            case Category_iCloudBackup:
            {
                [button addLoadingView];
            }
                break;
                
            default:
                break;
        }
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            for (IMBFunctionButton *button in _categoryBarView.allcategoryArr) {
                switch (button.tag) {
                    case Category_Photo:
                    {
                        [_iCloudManager getPhotosContent];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            button.badgeCount = _iCloudManager.photoCount;
                            [button showloading:NO];
                        });
                    }
                        break;
                    case Category_PhotoVideo:
                    {
//                        [_iCloudManager getPhotosContent];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            button.badgeCount = _iCloudManager.photoVideoCount;
                            [button showloading:NO];
                        });
                    }
                        break;
                    case Category_ContinuousShooting:
                    {
//                        [_iCloudManager getPhotosContent];
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            button.badgeCount = _iCloudManager.photoVideoCount;
                            [button showloading:NO];
                        });
                    }
                        break;
                    case Category_Notes:
                    {
                        [_iCloudManager getNoteContent];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            button.badgeCount = _iCloudManager.noteArray.count;
                            [button showloading:NO];
                        });
                    }
                        break;
                    case Category_Contacts:
                    {
                        [_iCloudManager getContactContent];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            button.badgeCount = _iCloudManager.contactArray.count;
                            [button showloading:NO];
                        });
                    }
                        break;
                    case Category_Calendar:
                    {
                        [_iCloudManager getCalendarContent];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            button.badgeCount = _iCloudManager.calendarArray.count;
                            [button showloading:NO];
                        });
                    }
                        break;
                    case Category_Reminder:
                    {
                        [_iCloudManager getReminderContent];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            button.badgeCount = _iCloudManager.reminderArray.count;
                            [button showloading:NO];
                        });
                    }
                        break;
                    case Category_iCloudBackup:
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [button showloading:NO];
                        });
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            _loadFinish = YES;
            _iCloudManager.netClient.loginInfo.loginInfoEntity.isLoadFinish = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_loadLabel setHidden:YES];
                if (_loadPopover != nil) {
                    [_loadPopover close];
                }
            });
        }
    });
}

- (void)loadicloudCount:(int)count{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            for (IMBFunctionButton *button in _categoryBarView.allcategoryArr) {
                switch (button.tag) {
                    case Category_Photo:
                    {
//                        [_iCloudManager getPhotosContent];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            button.badgeCount = _iCloudManager.photoArray.count;
                            [button showloading:NO];
                        });
                    }
                        break;
                    case Category_Notes:
                    {
//                        [_iCloudManager getNoteContent];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            button.badgeCount = _iCloudManager.noteArray.count;
                            [button showloading:NO];
                        });
                    }
                        break;
                    case Category_Contacts:
                    {
//                        [_iCloudManager getContactContent];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            button.badgeCount = _iCloudManager.contactArray.count;
                            [button showloading:NO];
                        });
                    }
                        break;
                    case Category_Calendar:
                    {
//                        [_iCloudManager getCalendarContent];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            button.badgeCount = _iCloudManager.calendarArray.count;
                            [button showloading:NO];
                        });
                    }
                        break;
                    case Category_Reminder:
                    {
//                        [_iCloudManager getReminderContent];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            button.badgeCount = _iCloudManager.reminderArray.count;
                            [button showloading:NO];
                        });
                    }
                        break;
                    case Category_iCloudBackup:
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            button.badgeCount = count;
                            [button showloading:NO];
                        });
                    }
                        break;
                        
                    default:
                        break;
                }
            }
//            _loadFinish = YES;
//            _iCloudManager.netClient.loginInfo.loginInfoEntity.isLoadFinish = YES;
////            dispatch_async(dispatch_get_main_queue(), ^{
//                [_loadLabel setHidden:YES];
//                if (_loadPopover != nil) {
//                    [_loadPopover close];
//                }
                [_popUpButton setNeedsDisplay:YES];
//            });
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

//    });

}

- (void)setCookieStorage {
    if (_iCloudManager.netClient != nil) {
        [_iCloudManager.netClient setCookiesStorage];
    }
}

#pragma mark - BoxActions
- (IBAction)iCloudExport:(id)sender {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Export" label:Click transferCount:0 screenView:@"iCloud Export View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    if (!_loadFinish) {
        [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_iclouddata", nil) withSuperView:sender];
        return;
    }
    NSMutableArray *cagetoryArray = [[NSMutableArray alloc] init];
    if (_categoryBarView.allcategoryArr.count > 0) {
        for (IMBFunctionButton *btn in _categoryBarView.allcategoryArr) {
            if (btn.tag == Category_iCloudBackup) {
                continue;
            }
            IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
            model.categoryName = btn.buttonName;
            [model setCategoryNameAttributedString];
            model.categoryImage = btn.selectIcon;
            model.categoryNodes = (CategoryNodesEnum)btn.tag;
            model.isSelected = YES;
            if (btn.tag == Category_Photo && _iCloudManager.photoCount>0) {
                [cagetoryArray addObject:model];
            }else if (btn.tag == Category_Contacts && [_iCloudManager.contactArray count]>0){
                [cagetoryArray addObject:model];
            }else if (btn.tag == Category_Notes && [_iCloudManager.noteArray count]>0){
                [cagetoryArray addObject:model];
            }else if (btn.tag == Category_Calendar && [_iCloudManager.calendarArray count]>0){
                [cagetoryArray addObject:model];
            }else if (btn.tag == Category_Reminder && [_iCloudManager.reminderArray count]>0){
                [cagetoryArray addObject:model];
            }else if (btn.tag == Category_PhotoVideo && _iCloudManager.photoVideoCount>0) {
                [cagetoryArray addObject:model];
            }

            [model release];
        }
    }
    
    IMBToMacViewController *controller = [[IMBToMacViewController alloc] initWithiPod:_ipod CategoryInfoModelArrary:cagetoryArray isToMac:YES WithIsiCoudView:YES];
    [controller setDelegate:self];
    [self setShowTopLineView:YES];
    controller.icloudManager = _iCloudManager;
    [controller.view setFrameSize:NSMakeSize(NSWidth(self.view.frame), NSHeight(self.view.frame))];
    [controller.view setWantsLayer:YES];
    [self.view addSubview:controller.view];
    [controller.view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-controller.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
    [cagetoryArray release];
    [self setTrackingAreaEnable:NO];
}

- (void)iCloudSync:(id)sender {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Sync" label:Click transferCount:0 screenView:@"iCloud Sync View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    if (!_loadFinish) {
        [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_iclouddata", nil) withSuperView:sender];
        return;
    }
    NSDictionary *dic = [self getiCloudAccountViewCollection];
    if ([dic.allKeys count]>=2) {
        NSMutableArray *cagetoryArray = [[NSMutableArray alloc] init];
        if (_categoryBarView.allcategoryArr.count > 0) {
            for (IMBFunctionButton *btn in _categoryBarView.allcategoryArr) {
                if (btn.tag == Category_iCloudBackup) {
                    continue;
                }
                IMBCategoryInfoModel *model = [[IMBCategoryInfoModel alloc] init];
                model.categoryName = btn.buttonName;
                [model setCategoryNameAttributedString];
                model.categoryImage = btn.selectIcon;
                model.categoryNodes = (CategoryNodesEnum)btn.tag;
                model.isSelected = YES;
                if (btn.tag == Category_Photo && _iCloudManager.photoCount>0) {
                    [cagetoryArray addObject:model];
                }else if (btn.tag == Category_Contacts && [_iCloudManager.contactArray count]>0){
                    [cagetoryArray addObject:model];
                }else if (btn.tag == Category_Notes && [_iCloudManager.noteArray count]>0){
                    [cagetoryArray addObject:model];
                }else if (btn.tag == Category_Calendar && [_iCloudManager.calendarArray count]>0){
                    [cagetoryArray addObject:model];
                }else if (btn.tag == Category_Reminder && [_iCloudManager.reminderArray count]>0){
                    [cagetoryArray addObject:model];
                }
                [model release];
            }
        }
        
        IMBMergeOrCloneViewController *controller = [[IMBMergeOrCloneViewController alloc] initWithiCloudManager:_iCloudManager CategoryInfoModelArrary:cagetoryArray TransferType:ToiCloudType AccountDic:[self getiCloudAccountViewCollection]];
        [controller setDelegate:self];
        [self setShowTopLineView:YES];
        [controller.view setWantsLayer:YES];
        [controller.view setFrame:NSMakeRect(0, 0, _firstCustomView.frame.size.width, _firstCustomView.frame.size.height)];
        [self.view addSubview:controller.view];
        [controller.view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-controller.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
        [cagetoryArray release];
        [self setTrackingAreaEnable:NO];
    }else{
        //提示用户需要再登陆一个账号
        NSString *str = nil;
        str = CustomLocalizedString(@"NoAcount_Tips", nil);
        [self showAlertText:str OKButton:CustomLocalizedString(@"Button_Ok", nil)];
    }
}

- (IBAction)popUpiCloudDriver:(id)sender {
    [[IMBLogManager singleton] writeInfoLog:@"enter iCloud Driver"];
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Drive" label:Click transferCount:0 screenView:@"iCloud Drive View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    IMBiCloudDriverViewController *viewController = [[IMBiCloudDriverViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:self withiCloudView:YES withCategory:Category_iCloudDriver];
    [self setShowTopLineView:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:NO]];
    NSString *str = @"close";
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ENTER_CHANGELAGUG_IPOD object:str];
    [viewController.view setFrameOrigin:NSMakePoint(0, 0)];
    [viewController.view setFrameSize:NSMakeSize(NSWidth(self.view.frame), NSHeight(self.view.frame))];
    [viewController.view setWantsLayer:YES];
    [self.view addSubview:viewController.view];
    [viewController.view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-viewController.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
    [self setTrackingAreaEnable:NO];
}

- (void)iCloudImport:(id)sender {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Import" label:Click transferCount:0 screenView:@"iCloud Import View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    if (!_loadFinish) {
        [self showLoadPromptPopover:CustomLocalizedString(@"MSG_Loading_iclouddata", nil) withSuperView:sender];
        return;
    }
    NSArray *supportFiles = [NSArray arrayWithObjects:@"vcf",@"csv",@"jpg",nil];
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel setAllowedFileTypes:supportFiles];
    [openPanel beginSheetModalForWindow:[self view].window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSFileHandlingPanelOKButton) {
            NSArray *urlArr = [openPanel URLs];
            NSMutableArray *paths = [NSMutableArray array];
            for (NSURL *url in urlArr) {
                [paths addObject:url.path];
            }
            [self performSelector:@selector(addItemsDelay:) withObject:paths afterDelay:0.1];
        }
    }];
}

- (void)addItemsDelay:(NSMutableArray *)paths {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:NO]];
    IMBAddContentViewController *addController = [[IMBAddContentViewController alloc ]initWithiPod:nil withAllPaths:paths WithPhotoAlbum:nil playlistID:0];
    [self setShowTopLineView:YES];
    addController.icloudManager = _iCloudManager;
    addController.isiCloudAdd = YES;
    addController.delegate = self;
    [addController.view setFrame:NSMakeRect(0, 0, _firstCustomView.frame.size.width, _firstCustomView.frame.size.height)];
    [self.view addSubview:addController.view];
    [addController.view.layer addAnimation:[IMBAnimation moveY:0.5 X:[NSNumber numberWithInt:-addController.view.frame.size.height] Y:[NSNumber numberWithInt:0] repeatCount:1] forKey:@"moveY"];
    [self setTrackingAreaEnable:NO];
}

-(void)toiTunes:(id)sender{
    
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
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Back" label:Click transferCount:0 screenView:@"iCloud View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [self setShowTopLineView:NO];
        [_detailBox setFrameSize:self.view.frame.size];
        [_toolBar addSubview:_popUpButton];
        [_toolBar setHidden:YES];
        [_searchFieldBtn setHidden:YES];
        [_searchFieldBtn setStringValue:@""];
        _isSearch = NO;
        [_detailBox setContentView:_firstCustomView];
        _category = Category_Summary;
    }else {
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            dimensionDict = [[TempHelper customDimension] copy];
        }
        if (categoryEnum != Category_iCloudBackup) {
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Control Panel Content" label:Click transferCount:0 screenView:@"iCloud Control Panel Content View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            [_detailBox setFrameSize:NSMakeSize(self.view.frame.size.width, self.view.frame.size.height - 39)];
            [_toolBar setHidden:NO];
        }else{
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Backup Content" label:Click transferCount:0 screenView:@"iCloud Backup Content View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
            [_detailBox setFrameSize:NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)];
            [_toolBar setHidden:YES];
        }
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        [self setShowTopLineView:YES];
        
        IMBBaseViewController *viewController = nil;
        BOOL isViewDisplay = YES;
        int segSelect = 1;
        if (categoryEnum == Category_Photo) {
            if ([_displayModeDic.allKeys containsObject:[NSNumber numberWithInt:categoryEnum]]) {
                segSelect = [[_displayModeDic objectForKey:[NSNumber numberWithInt:categoryEnum]] intValue];
            }
            if (segSelect == 0) {
                isViewDisplay = NO;
                viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:categoryEnum]];
            }else if (segSelect == 1) {
                isViewDisplay = YES;
                NSString *key = [NSString stringWithFormat:@"%d-%d",categoryEnum,segSelect];
                viewController = [_detailPageDic objectForKey:key];
            }

            [_toolBar addSubview:_popUpButton];

        }else if (categoryEnum == Category_PhotoVideo) {
            if ([_displayModeDic.allKeys containsObject:[NSNumber numberWithInt:categoryEnum]]) {
                segSelect = [[_displayModeDic objectForKey:[NSNumber numberWithInt:categoryEnum]] intValue];
            }
            if (segSelect == 0) {
                isViewDisplay = NO;
                viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:categoryEnum]];
            }else if (segSelect == 1) {
                isViewDisplay = YES;
                NSString *key = [NSString stringWithFormat:@"%d-%d",categoryEnum,segSelect];
                viewController = [_detailPageDic objectForKey:key];
            }
            
            [_toolBar addSubview:_popUpButton];
            
        }else if (categoryEnum == Category_ContinuousShooting) {
            if ([_displayModeDic.allKeys containsObject:[NSNumber numberWithInt:categoryEnum]]) {
                segSelect = [[_displayModeDic objectForKey:[NSNumber numberWithInt:categoryEnum]] intValue];
            }
            if (segSelect == 0) {
                isViewDisplay = NO;
                viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:categoryEnum]];
            }else if (segSelect == 1) {
                isViewDisplay = YES;
                NSString *key = [NSString stringWithFormat:@"%d-%d",categoryEnum,segSelect];
                viewController = [_detailPageDic objectForKey:key];
            }
            
            [_toolBar addSubview:_popUpButton];
            
        }else if (categoryEnum == Category_iCloudDriver) {
            if ([_displayModeDic.allKeys containsObject:[NSNumber numberWithInt:categoryEnum]]) {
                segSelect = [[_displayModeDic objectForKey:[NSNumber numberWithInt:categoryEnum]] intValue];
            }
            if (segSelect == 0) {
                isViewDisplay = NO;
                viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:categoryEnum]];
            }else if (segSelect == 1) {
                isViewDisplay = YES;
                NSString *key = [NSString stringWithFormat:@"%d-%d",categoryEnum,segSelect];
                viewController = [_detailPageDic objectForKey:key];
            }
        }else {
             [_toolBar addSubview:_popUpButton];
                isViewDisplay = NO;
                viewController = [_detailPageDic objectForKey:[NSNumber numberWithInt:categoryEnum]];
            if (categoryEnum == Category_iCloudBackup &&_isFail){
                _isFail = NO;
                if (viewController != nil) {
                    [(IMBiCloudBackUpViewController *)viewController roladData];
                }
            }
            if (categoryEnum == Category_iCloudBackup)
            {
                [(IMBiCloudBackUpViewController *)viewController loadToolbar];
            }
           
        }
        if (!viewController) {
            if (categoryEnum == Category_Notes) {
                viewController = [[IMBNoteListViewController alloc]initWithiCloudManager:_iCloudManager withDelegate:self withiCloudView:YES withCategory:Category_Notes];
            }else if (categoryEnum == Category_Calendar){
                viewController = [[IMBiCloudCalendarViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:self withiCloudView:YES withCategory:Category_Calendar];
            }else if (categoryEnum == Category_Reminder) {
                viewController = [[IMBReminderViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:self withiCloudView:YES withCategory:Category_Reminder];
            }else if (categoryEnum == Category_Contacts){
                viewController = [[IMBContactViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:self withiCloudView:YES withCategory:Category_Contacts];
            }else if (categoryEnum == Category_Photo){
//                if (isViewDisplay) {
//                    viewController = [[IMBPhotosCollectionViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:self withiCloudView:YES withCategory:Category_Photo];
//                    [(IMBPhotosCollectionViewController*)viewController setToolBar:_toolBar];
//                }else {
//                    viewController = [[IMBPhotosListViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:self withiCloudView:YES withCategory:Category_Photo];
//                    [(IMBPhotosListViewController*)viewController setToolBar:_toolBar];
//                }
                 viewController = [[IMBiCloudPhotoVideoViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:self withiCloudView:YES withCategory:Category_Photo];
                [(IMBiCloudPhotoVideoViewController *)viewController repToolBarView:_toolBar];
            }else if (categoryEnum == Category_PhotoVideo) {
                viewController = [[IMBiCloudPhotoVideoViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:self withiCloudView:YES withCategory:Category_PhotoVideo];
                [(IMBiCloudPhotoVideoViewController *)viewController repToolBarView:_toolBar];
            }else if (categoryEnum == Category_ContinuousShooting) {
                viewController = [[IMBiCloudPhotoVideoViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:self withiCloudView:YES withCategory:Category_ContinuousShooting];
                [(IMBiCloudPhotoVideoViewController *)viewController repToolBarView:_toolBar];
            }else if (categoryEnum == Category_iCloudBackup){
                viewController = [[IMBiCloudBackUpViewController alloc]initWithClient:nil withDownloadComplete:NO withDelegate:self withIpod:nil with:@"IMBiCloudBackUpViewController" withappleId:[_iCloudManager.netClient loginInfo]];
//                [(IMBiCloudBackUpViewController *)viewController repToolBarView:_toolBar];
            }else if (categoryEnum == Category_iCloudDriver){
                if (isViewDisplay) {
                    viewController = [[IMBiCloudDriverViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:self withiCloudView:YES withCategory:Category_iCloudDriver];
                    [(IMBiCloudDriverViewController*)viewController setToolBar:_toolBar];
                }else {

                }
            }
            
            if (viewController != nil) {
                HoverButton *button1 = [self.view viewWithTag:200];
                HoverButton *button2 = [self.view viewWithTag:201];
                [button1 setHidden:YES];
                [button2 setHidden:YES];
                _category = categoryEnum;
                [self loadToolBarButton:categoryEnum withIsViewDisplay:isViewDisplay withViewController:viewController];
                if (isViewDisplay) {
                    [_detailPageDic setObject:viewController forKey:[NSString stringWithFormat:@"%d-%d",categoryEnum,segSelect]];
                }else {
                    [_detailPageDic setObject:viewController forKey:[NSNumber numberWithInt:categoryEnum]];
                }
                [_detailBox setContentView:viewController.view];
                [viewController release];
            }
        }else{
            HoverButton *button1 = [self.view viewWithTag:200];
            HoverButton *button2 = [self.view viewWithTag:201];
            [button1 setHidden:YES];
            [button2 setHidden:YES];
            _category = categoryEnum;
            [self loadToolBarButton:categoryEnum withIsViewDisplay:isViewDisplay withViewController:viewController];
            [_detailBox setContentView:viewController.view];
        }
    }
}

- (void)doBack:(id)sender {
    _isFail = NO;
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
            if (_category == Category_Photo) {
//                viewController = [[IMBPhotosListViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:self withiCloudView:YES withCategory:Category_Photo];
//                [(IMBPhotosListViewController*)viewController setToolBar:_toolBar];
                viewController = [[IMBiCloudPhotoVideoViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:self withiCloudView:YES withCategory:Category_Photo];
                [(IMBiCloudPhotoVideoViewController *)viewController repToolBarView:_toolBar];
            }else if (_category == Category_PhotoVideo) {
                viewController = [[IMBiCloudPhotoVideoViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:self withiCloudView:YES withCategory:Category_PhotoVideo];
                [(IMBiCloudPhotoVideoViewController *)viewController repToolBarView:_toolBar];
            }else if (_category == Category_ContinuousShooting) {
                viewController = [[IMBiCloudPhotoVideoViewController alloc] initWithiCloudManager:_iCloudManager withDelegate:self withiCloudView:YES withCategory:Category_ContinuousShooting];
                [(IMBiCloudPhotoVideoViewController *)viewController repToolBarView:_toolBar];
            }
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

- (void)loadToolBarButton:(CategoryNodesEnum)categoryEnum withIsViewDisplay:(BOOL)isViewDisplay withViewController:(id)viewController {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if (categoryEnum == Category_Notes) {
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Notes" label:Click transferCount:0 screenView:@"Notes View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [(IMBNoteListViewController *)viewController retToolbar:_toolBar];
        [_toolBar loadiCloudButtons:[NSArray arrayWithObjects:@(0),@(1),@(7),@(2),@(4),@(22),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Calendar||categoryEnum == Category_Reminder){
        [viewController retToolbar:_toolBar];
        if (categoryEnum == Category_Calendar) {
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Calendar" label:Click transferCount:0 screenView:@"Calendar View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (categoryEnum == Category_Reminder) {
            [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Reminder" label:Click transferCount:0 screenView:@"Reminder View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
        [_toolBar loadiCloudButtons:[NSArray arrayWithObjects:@(0),@(1),@(7),@(2),@(4),@(22),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Contacts){
        [viewController retToolbar:_toolBar];
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Contacts" label:Click transferCount:0 screenView:@"Contacts View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_toolBar loadiCloudButtons:[NSArray arrayWithObjects:@(0),@(1),@(7),@(2),@(4),@(22),@(13),nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_Photo){
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photo" label:Click transferCount:0 screenView:@"Photo View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_toolBar loadiCloudButtons:[NSArray arrayWithObjects:@(0),@(7),@(17),@(2),@(18),@(22),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];
    }else if (categoryEnum == Category_PhotoVideo){
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photo Video" label:Click transferCount:0 screenView:@"Photo Video View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_toolBar loadiCloudButtons:[NSArray arrayWithObjects:@(0),@(7),@(18),@(2),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];
    }else if (categoryEnum == Category_ContinuousShooting){
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"Photo ContinuousShooting" label:Click transferCount:0 screenView:@"Photo ContinuousShooting View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_toolBar loadiCloudButtons:[NSArray arrayWithObjects:@(0),@(17),@(18),@(2),@(22),@(12),@(13), nil] Target:viewController DisplayMode:isViewDisplay];
    }else if (categoryEnum == Category_iCloudDriver){
        //
        [_toolBar loadiCloudButtons:[NSArray arrayWithObjects:@(0),@(17),@(18),@(2),@(20),@(12),@(13), nil] Target:viewController DisplayMode:NO];
    }else if (categoryEnum == Category_iCloudBackup){
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud Backup" label:Click transferCount:0 screenView:@"iCloud Backup View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
}

- (void)doBackView:(id)sender {
    [self changeView:Category_Summary];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHANGE_IPOD object:_ipod];
    if (_categoryBarView.popUpView.frame.size.height<= ArrowSize) {
        HoverButton *button1 = [self.view viewWithTag:200];
        HoverButton *button2 = [self.view viewWithTag:201];
        [button1 setHidden:NO];
        [button2 setHidden:NO];
    }
}

#pragma mark - 滑动上下切换 box和category视图
- (void)switchView:(HoverButton *)button {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if (button.tag == 200) {
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud ToolView" label:Click transferCount:0 screenView:@"iCloud ToolView View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_scrollView setIsdown:NO];
        [self scrollerView:_scrollView withDown:NO];
    }else{
        [ATTracker event:iCloud_Content action:ActionNone actionParams:@"iCloud MenuView" label:Click transferCount:0 screenView:@"iCloud MenuView View" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        [_scrollView setIsdown:YES];
        [self scrollerView:_scrollView withDown:YES];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
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
    [_icloudDriver setFrameOrigin:NSMakePoint((self.view.frame.size.width-1000)/2 + 310, 94)];
    [_icloudExport setFrameOrigin:NSMakePoint((self.view.frame.size.width-1000)/2 + 465, 176)];
    [_icloudSync setFrameOrigin:NSMakePoint((self.view.frame.size.width-1000)/2 + 680, 120)];
    [_icloudImport setFrameOrigin:NSMakePoint((self.view.frame.size.width-1000)/2 + 146, 202)];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_icloudDriver setHidden:NO];
        [_icloudDriver setWantsLayer:YES];
        NSPoint point = _icloudDriver.frame.origin;
        CGMutablePathRef fillPath = CGPathCreateMutable();
        CAKeyframeAnimation *animation = [IMBAnimation keyframeAniamtion:fillPath cp1x:-500 cp1y:point.y+100 cp2x:point.x/2 cp2y:_icloudDriver.frame.origin.y endPointX:point.x endPointY:point.y layer:_icloudDriver.layer];
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
        [_icloudDriver.layer addAnimation:group forKey:@"deviceImageView"];
        
        [_icloudExport setHidden:NO];
        [_icloudExport setWantsLayer:YES];
        NSPoint addpoint = _icloudExport.frame.origin;
        CGMutablePathRef fillPath1 = CGPathCreateMutable();
        CAKeyframeAnimation *animation1 = [IMBAnimation keyframeAniamtion:fillPath1 cp1x:self.view.frame.size.width cp1y:addpoint.y+100 cp2x:self.view.frame.size.width/2+addpoint.x/2 cp2y:addpoint.y endPointX:addpoint.x endPointY:addpoint.y layer:_icloudExport.layer];
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
        [_icloudExport.layer addAnimation:group1 forKey:@"deviceImageView"];
        
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [_icloudImport setHidden:NO];
            [_icloudImport setWantsLayer:YES];
            //        [_toiTunesBtn.layer setMasksToBounds:NO];
            NSPoint point = _icloudImport.frame.origin;
            CGMutablePathRef fillPath = CGPathCreateMutable();
            CAKeyframeAnimation *animation = [IMBAnimation keyframeAniamtion:fillPath cp1x:-500 cp1y:point.y-100 cp2x:point.x/2 cp2y:point.y endPointX:point.x endPointY:point.y layer:_icloudImport.layer];
            [animation setDuration:0.7];
            animation.autoreverses = NO;
            CABasicAnimation *opAnimation = [IMBAnimation opacityChange_Animation:1 fromValue:[NSNumber numberWithInt:0.2] toValue:[NSNumber numberWithInt:1] durTimes:0.7];
            CAAnimationGroup *group = [CAAnimationGroup animation];
            group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            group.duration = 0.7;
            group.autoreverses = NO;
            group.removedOnCompletion = NO;
            group.repeatCount = 1;
            group.animations = [NSArray arrayWithObjects:animation,opAnimation,nil];
            [_icloudImport.layer addAnimation:group forKey:@"deviceImageView"];
            
            [_icloudSync setHidden:NO];
            [_icloudSync setWantsLayer:YES];
            NSPoint todevicepoint = _icloudSync.frame.origin;
            CGMutablePathRef fillPath1 = CGPathCreateMutable();
            CAKeyframeAnimation *animation1 = [IMBAnimation keyframeAniamtion:fillPath1 cp1x:self.view.frame.size.width cp1y:todevicepoint.y-100 cp2x:self.view.frame.size.width/2+todevicepoint.x/2 cp2y:todevicepoint.y endPointX:todevicepoint.x endPointY:todevicepoint.y layer:_icloudSync.layer];
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
            [_icloudSync.layer addAnimation:group1 forKey:@"deviceImageView"];
            
        });
    } completionHandler:^{
        [_mainFunctionView setFrame:NSMakeRect((self.view.frame.size.width-1000)/2, _mainFunctionView.frame.origin.y, 1000, _mainFunctionView.frame.size.height)];
        
        [_icloudDriver setFrameOrigin:NSMakePoint(310, 94)];
        [_icloudExport setFrameOrigin:NSMakePoint(465, 176)];
        [_icloudSync setFrameOrigin:NSMakePoint(680, 120)];
        [_icloudImport setFrameOrigin:NSMakePoint(146, 202)];
        
        [_icloudDriver.layer removeAllAnimations];
        [_icloudExport.layer removeAllAnimations];
        [_icloudSync.layer removeAllAnimations];
        [_icloudImport.layer removeAllAnimations];
        [self startTestBtnAnimation];
    }];
}

- (void)startTestBtnAnimation {
    
    [_icloudDriver.layer setMasksToBounds:NO];
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
    [_icloudDriver.layer addAnimation:group2 forKey:@"deviceImageView"];
    
    [_icloudSync.layer setMasksToBounds:NO];
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
    [_icloudSync.layer addAnimation:group1 forKey:@"deviceImageView"];
    
    
    [_icloudImport.layer setMasksToBounds:NO];
    CABasicAnimation *anima4 = [IMBAnimation moveY:1.92 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:8] repeatCount:1 beginTime:1 isAutoreverses:NO];
    anima4.beginTime=0;
    CABasicAnimation *anima44 = [IMBAnimation moveX:2.4 X:[NSNumber numberWithInt:10] repeatCount:1 beginTime:0];
    anima44.beginTime=1.92;
    CABasicAnimation *anima444 = [IMBAnimation moveY:2.88 X:[NSNumber numberWithInt:8] Y:[NSNumber numberWithInt:-4] repeatCount:1 beginTime:1 isAutoreverses:NO];
    anima444.beginTime=4.32;
    CABasicAnimation *anima4444 = [IMBAnimation moveX:2.4 X:[NSNumber numberWithInt:20] repeatCount:1 beginTime:0];
    anima4444.beginTime=7.2;
    CAAnimationGroup *group4 = [CAAnimationGroup animation];
    group4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group4.duration = 9.6;
    group4.autoreverses = YES;
    group4.removedOnCompletion = NO;
    group4.repeatCount = NSIntegerMax;
    group4.animations = [NSArray arrayWithObjects:anima4,anima44,anima444,anima4444,nil];
    [_icloudImport.layer addAnimation:group4 forKey:@"deviceImageView"];
    
    
    [_icloudExport.layer setMasksToBounds:NO];
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
    [_icloudExport.layer addAnimation:group5 forKey:@"deviceImageView"];
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

- (CATransition *)pushAnimation:(NSString *)type withSubType:(NSString *)subType durTimes:(float)time //推动动画
{
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

- (void)setTrackingAreaEnable:(BOOL)enable
{
    [self setShowTopLineView:!enable];
    [_icloudDriver setTrackingAreaEnable:enable];
    [_icloudSync setTrackingAreaEnable:enable];
    [_icloudImport setTrackingAreaEnable:enable];
    [_icloudExport setTrackingAreaEnable:enable];
}

- (void)doChangeLanguage:(NSNotification *)notification {
    [super doChangeLanguage:notification];
    [self configMainTitle];
    
    [_icloudDriver setTitleName:CustomLocalizedString(@"icloud_drive", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iCloud_driver"] withTextColor:[NSColor whiteColor]];
    [_icloudSync setTitleName:CustomLocalizedString(@"icloud_sync", nil) WithDarwInterval:25 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iCloud_sync"] withTextColor:[NSColor whiteColor]];
    [_icloudImport setTitleName:CustomLocalizedString(@"icloud_import", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iCloud_import"] withTextColor:[NSColor whiteColor]];
    [_icloudExport setTitleName:CustomLocalizedString(@"icloud_export", nil) WithDarwInterval:36 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iCloud_fileexport"] withTextColor:[NSColor whiteColor]];
    
    for (IMBFunctionButton *button in _categoryBarView.allcategoryArr){
        if (button.tag == Category_Photo) {
            [button setImageWithImageName:@"btn_iCloud_photoNew" withButtonName:CustomLocalizedString(@"MenuItem_id_9", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_iCloudphotos"]];
            [button setSelectIcon:[StringHelper imageNamed:@"select_photo"]];
        }else if (button.tag == Category_PhotoVideo) {
            [button setImageWithImageName:@"btn_photo_videosnew" withButtonName:CustomLocalizedString(@"MenuItem_id_24", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_video_photovideo"]];
            [button setSelectIcon:[StringHelper imageNamed:@"select_video_photovideo"]];
        }else if (button.tag == Category_ContinuousShooting) {
            [button setImageWithImageName:@"btn_burstnew" withButtonName:CustomLocalizedString(@"MenuItem_id_47", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_photo_bursts"]];
            [button setSelectIcon:[StringHelper imageNamed:@"select_photo_bursts"]];
        }else if (button.tag == Category_Contacts) {
            [button setImageWithImageName:@"btn_contactsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_20", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_contact"]];
            [button setSelectIcon:[StringHelper imageNamed:@"select_contact"]];
        }else if (button.tag == Category_Notes) {
            [button setImageWithImageName:@"btn_notenew" withButtonName:CustomLocalizedString(@"MenuItem_id_17", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_notes"]];
            [button setSelectIcon:[StringHelper imageNamed:@"select_note"]];
        }else if (button.tag == Category_Calendar) {
            [button setImageWithImageName:@"btn_calendarnew" withButtonName:CustomLocalizedString(@"MenuItem_id_62", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_calendar"]];
            [button setSelectIcon:[StringHelper imageNamed:@"select_calendar"]];
        }else if (button.tag == Category_Reminder) {
            [button setImageWithImageName:@"btn_remindernew" withButtonName:CustomLocalizedString(@"Reminders_id", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_iCloudreminder"]];
            [button setSelectIcon:[StringHelper imageNamed:@"select_reminder"]];
        }else if (button.tag == Category_iCloudDriver) {
//            [button setImageWithImageName:@"btn_iCloudDrivernew" withButtonName:CustomLocalizedString(@"iCloudDriver", nil)];
//            [button setNavagationIcon:[StringHelper imageNamed:@"nav_calendar"]];
//            [button setSelectIcon:[StringHelper imageNamed:@"select_calendar"]];
        }else if (button.tag == Category_iCloudBackup) {
            [button setImageWithImageName:@"btn_iCloud_backup" withButtonName:CustomLocalizedString(@"icloud_backup", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_iCloudbackup"]];
        }
        
        [button setNeedsDisplay:YES];
        [_toolBar changeBtnTooltipStr];
        [_toolBar setNeedsDisplay:YES];
        
//        for (IMBMenuItem *item in _popUpButton.menu.itemArray) {
//            [item setFunctionButton:button];
//        }
        
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

- (NSMenu *)createNavagationMenu
{
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
- (void)menuDidClose:(NSMenu *)menu
{
    for (IMBMenuItem *menuitem in menu.itemArray) {
        ((IMBMenuItemView *)menuitem.view).isMouseEnter = NO;
    }
}

- (void)menu:(NSMenu *)menu willHighlightItem:(NSMenuItem *)item
{
    for (IMBMenuItem *menuitem in menu.itemArray) {
        if (menuitem == item) {
            ((IMBMenuItemView *)menuitem.view).isMouseEnter = YES;
        }else{
            ((IMBMenuItemView *)menuitem.view).isMouseEnter = NO;
        }
    }
}

- (void)navigateTo:(IMBMenuItem *)item
{
   
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
    NSString *str1 = CustomLocalizedString(@"icloud_main_title_1", nil);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:str1];
    [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:24] range:NSMakeRange(0, as.length)];
    [as setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as.length)];
    [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as.string.length)];
    [_firstViewmainTitle setAttributedStringValue:as];
    [as release];
    as = nil;
    NSString *str2 = CustomLocalizedString(@"icloud_main_title_2", nil);
    NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [as2 addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue Light" size:24] range:NSMakeRange(0, as2.length)];
    [as2 setAlignment:NSCenterTextAlignment range:NSMakeRange(0, as2.length)];
    [as2 addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0, as2.length)];
    [_secondViewMainTitle setAttributedStringValue:as2];
    [as2 release];
    as2 = nil;
}

- (void)changeSkin:(NSNotification *)notification {
    [_arrowImageView setImage:[StringHelper imageNamed:@"mainFrame_arrow"]];
    [_scrollView setNeedsDisplay:YES];
    [(IMBBackgroundBorderView *)self.view setIsGradientWithCornerPart4:YES];
    [(IMBBackgroundBorderView *)self.view setNeedsDisplay:YES];
    [_firstCustomView setNeedsDisplay:YES];
    [_iCloudBgView setImage:[StringHelper imageNamed:@"device_bg"]];
    [_icloudDriver setComponentColor:[ColorHelper getColorFromColorString:@"toMac_upColor" WithIndex:0] withG1:[ColorHelper getColorFromColorString:@"toMac_upColor" WithIndex:1] withB1:[ColorHelper getColorFromColorString:@"toMac_upColor" WithIndex:2] withAlpha1:[ColorHelper getColorFromColorString:@"toMac_upColor" WithIndex:3] withR2:[ColorHelper getColorFromColorString:@"toMac_downColor" WithIndex:0] withG2:[ColorHelper getColorFromColorString:@"toMac_downColor" WithIndex:1] withB2:[ColorHelper getColorFromColorString:@"toMac_downColor" WithIndex:2] withAlpha2:[ColorHelper getColorFromColorString:@"toMac_downColor" WithIndex:3]];
    [_icloudDriver setTitleName:CustomLocalizedString(@"icloud_drive", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iCloud_driver"] withTextColor:[NSColor whiteColor]];
    
    [_icloudSync setComponentColor:[ColorHelper getColorFromColorString:@"toDevice_upColor" WithIndex:0] withG1:[ColorHelper getColorFromColorString:@"toDevice_upColor" WithIndex:1] withB1:[ColorHelper getColorFromColorString:@"toDevice_upColor" WithIndex:2] withAlpha1:[ColorHelper getColorFromColorString:@"toDevice_upColor" WithIndex:3] withR2:[ColorHelper getColorFromColorString:@"toDevice_downColor" WithIndex:0] withG2:[ColorHelper getColorFromColorString:@"toDevice_downColor" WithIndex:1] withB2:[ColorHelper getColorFromColorString:@"toDevice_downColor" WithIndex:2] withAlpha2:[ColorHelper getColorFromColorString:@"toDevice_downColor" WithIndex:3]];
    [_icloudSync setTitleName:CustomLocalizedString(@"icloud_sync", nil) WithDarwInterval:25 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iCloud_sync"] withTextColor:[NSColor whiteColor]];
    
    [_icloudImport setComponentColor:[ColorHelper getColorFromColorString:@"mergeBtn_upColor" WithIndex:0] withG1:[ColorHelper getColorFromColorString:@"mergeBtn_upColor" WithIndex:1] withB1:[ColorHelper getColorFromColorString:@"mergeBtn_upColor" WithIndex:2] withAlpha1:[ColorHelper getColorFromColorString:@"mergeBtn_upColor" WithIndex:3] withR2:[ColorHelper getColorFromColorString:@"mergeBtn_downColor" WithIndex:0] withG2:[ColorHelper getColorFromColorString:@"mergeBtn_downColor" WithIndex:1] withB2:[ColorHelper getColorFromColorString:@"mergeBtn_downColor" WithIndex:2] withAlpha2:[ColorHelper getColorFromColorString:@"mergeBtn_downColor" WithIndex:3]];
    [_icloudImport setTitleName:CustomLocalizedString(@"icloud_import", nil) WithDarwInterval:20 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iCloud_import"] withTextColor:[NSColor whiteColor]];
    
    [_icloudExport setComponentColor:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:0] withG1:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:1] withB1:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:2] withAlpha1:[ColorHelper getColorFromColorString:@"toiTunes_upColor" WithIndex:3] withR2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:0] withG2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:1] withB2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:2] withAlpha2:[ColorHelper getColorFromColorString:@"toiTunes_downColor" WithIndex:3]];
    [_icloudExport setTitleName:CustomLocalizedString(@"icloud_export", nil) WithDarwInterval:36 withFont:[NSFont fontWithName:@"Helvetica Neue" size:13] withButtonImage:[StringHelper imageNamed:@"iCloud_fileexport"] withTextColor:[NSColor whiteColor]];
    for (IMBFunctionButton *button in _categoryBarView.allcategoryArr){
        if (button.tag == Category_Photo) {
            [button setImageWithImageName:@"btn_iCloud_photoNew" withButtonName:CustomLocalizedString(@"MenuItem_id_9", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_iCloudphotos"]];
            [button setSelectIcon:[StringHelper imageNamed:@"select_photo"]];
        }else if (button.tag == Category_PhotoVideo) {
            [button setImageWithImageName:@"btn_photo_videosnew" withButtonName:CustomLocalizedString(@"MenuItem_id_24", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_video_photovideo"]];
            [button setSelectIcon:[StringHelper imageNamed:@"select_video_photovideo"]];
        }else if (button.tag == Category_ContinuousShooting) {
            [button setImageWithImageName:@"btn_burstnew" withButtonName:CustomLocalizedString(@"MenuItem_id_47", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_photo_bursts"]];
            [button setSelectIcon:[StringHelper imageNamed:@"select_photo_bursts"]];
        }else if (button.tag == Category_Contacts) {
            [button setImageWithImageName:@"btn_contactsnew" withButtonName:CustomLocalizedString(@"MenuItem_id_20", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_contact"]];
            [button setSelectIcon:[StringHelper imageNamed:@"select_contact"]];
        }else if (button.tag == Category_Notes) {
            [button setImageWithImageName:@"btn_notenew" withButtonName:CustomLocalizedString(@"MenuItem_id_17", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_notes"]];
            [button setSelectIcon:[StringHelper imageNamed:@"select_note"]];
        }else if (button.tag == Category_Calendar) {
            [button setImageWithImageName:@"btn_calendarnew" withButtonName:CustomLocalizedString(@"MenuItem_id_62", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_calendar"]];
            [button setSelectIcon:[StringHelper imageNamed:@"select_calendar"]];
        }else if (button.tag == Category_Reminder) {
            [button setImageWithImageName:@"btn_remindernew" withButtonName:CustomLocalizedString(@"Reminders_id", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_iCloudreminder"]];
            [button setSelectIcon:[StringHelper imageNamed:@"select_reminder"]];
        }else if (button.tag == Category_iCloudDriver) {
//            [button setImageWithImageName:@"btn_iCloudDrivernew" withButtonName:CustomLocalizedString(@"iCloudDriver", nil)];
//            [button setNavagationIcon:[StringHelper imageNamed:@"nav_calendar"]];
//            [button setSelectIcon:[StringHelper imageNamed:@"select_calendar"]];
        }else if (button.tag == Category_iCloudBackup) {
            [button setImageWithImageName:@"btn_iCloud_backup" withButtonName:CustomLocalizedString(@"icloud_backup", nil)];
            [button setNavagationIcon:[StringHelper imageNamed:@"nav_iCloudbackup"]];
        }
        [button setNeedsDisplay:YES];
    }
    [self configMainTitle];
    HoverButton *detailCategoryBtn = [self.view viewWithTag:200];
    [detailCategoryBtn setMouseEnteredImage:[StringHelper imageNamed:@"mainFrame_switch2"] mouseExitImage:[StringHelper imageNamed:@"mainFrame_switch1"] mouseDownImage:[StringHelper imageNamed:@"mainFrame_switch3"]];
    HoverButton *summaryCategoryBtn = [self.view viewWithTag:201];
    [summaryCategoryBtn setMouseEnteredImage:[StringHelper imageNamed:@"mainFrame_tool2"] mouseExitImage:[StringHelper imageNamed:@"mainFrame_tool1"] mouseDownImage:[StringHelper imageNamed:@"mainFrame_tool3"]];
    
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
    
    [_icloudDriver setNeedsDisplay:YES];
    [_icloudSync setNeedsDisplay:YES];
    [_icloudImport setNeedsDisplay:YES];
    [_icloudExport setNeedsDisplay:YES];
}

- (void)setShowTopLineView:(BOOL)isShow {
    [self setIsShowLineView:isShow];
    [_delegate setIsShowLineView:isShow];
}

- (void)dealloc
{
    [_loadPopover release],_loadPopover = nil;
    [_detailPageDic removeAllObjects];
    [_detailPageDic release],_detailPageDic = nil;
    [_displayModeDic release],_displayModeDic = nil;
    [_tipPopover release], _tipPopover = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CLOSE_TIP object:nil];
    [super dealloc];
}
@end
