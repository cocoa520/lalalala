//
//  IMBMainPageViewController.m
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/18.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBMainPageViewController.h"
#import "IMBDriveBaseManage.h"
#import "IMBiPod.h"
#import "IMBiCloudDriverViewController.h"
#import "IMBDevicePageViewController.h"
#import "IMBDrawOneImageBtn.h"
#import "IMBDeviceViewController.h"
#import "SystemHelper.h"
#import "IMBMainWindowController.h"
#import "IMBViewManager.h"
#import "IMBCommonTool.h"
#import "IMBCommonDefine.h"
#import "IMBTranferViewController.h"
#import "IMBAnimation.h"
#import "IMBSearchView.h"
#import "IMBPurchaseOrAnnoyController.h"
#import "IMBViewAnimation.h"
#import "IMBLimitation.h"
#import "IMBTranferBtnManager.h"

#import <objc/runtime.h>


static CGFloat const kSelectedBtnfontSize = 14.0f;

@interface IMBMainPageViewController ()

@end

@implementation IMBMainPageViewController
@synthesize isShowTranfer = _isShowTranfer;
@synthesize chooseModelEnum = _chooseModelEnum;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (id)initWithiPod:(IMBiPod *)iPod withMedleEnum:(ChooseLoginModelEnum )logMedleEnum withiCloudDrvieBase:(IMBDriveBaseManage*)baseManage withDelegate:(id)delegate{
    if ([super initWithNibName:@"IMBMainPageViewController" bundle:nil]) {
        _chooseModelEnum = logMedleEnum;
        _iPod = [iPod retain];
        _driveBaseManage = baseManage;
        _delegate = delegate;
    }
    return self;
}
- (void)dealloc {
    [super dealloc];
    
    [IMBNotiCenter removeObserver:self name:NOTIFY_HIDE_ICLOUDDETAIL object:nil];
    [IMBNotiCenter removeObserver:self name:IMBDeviceDisconnectedNoti object:nil];
    [IMBNotiCenter removeObserver:self name:IMBRegisteredSuccessfulNoti object:nil];
    [IMBNotiCenter removeObserver:self name:IMBLimitationNoti object:nil];
    
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    [IMBNotiCenter addObserver:self selector:@selector(disconnectedDevice:) name:IMBDeviceDisconnectedNoti object:nil];
    
    if (_alertSuperView) {
        NSMutableArray *obArr = objc_getAssociatedObject([NSApplication sharedApplication], &kIMBMainPageWindowAlertView);
        NSMutableArray *newObArr = [NSMutableArray array];
        if (!obArr) {
            obArr = [NSMutableArray array];
        }
        
        NSString *key = nil;
        switch (_chooseModelEnum) {
            case iCloudLogEnum:
            {
                key = IMBAlertViewiCloudKey;
                for (NSDictionary *dic in obArr) {
                    if ([dic[@"key"] isEqualToString:IMBAlertViewiCloudKey]) {
                        continue;
                    }
                    [newObArr addObject:dic];
                }
            }
                break;
            case DropBoxLogEnum:
            {
                key = IMBAlertViewDropBoxKey;
                for (NSDictionary *dic in obArr) {
                    if ([dic[@"key"] isEqualToString:IMBAlertViewDropBoxKey]) {
                        continue;
                    }
                    [newObArr addObject:dic];
                }
            }
                break;
            case DeviceLogEnum:
            {
                key = _iPod.uniqueKey;
                for (NSDictionary *dic in obArr) {
                    [newObArr addObject:dic];
                }
            }
                break;
                
            default:
                break;
        }
        if (key) {
            [newObArr addObject:@{@"key" : key, @"alertView" : _alertSuperView}];
            objc_setAssociatedObject([NSApplication sharedApplication], &kIMBMainPageWindowAlertView, newObArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else {
            IMBFLog(@"Warning----alertView associated failed----");
        }
    }
    IMBTranferBtnManager *tranferBtnManager = [IMBTranferBtnManager singleton];
    [[tranferBtnManager tranferAry] addObject:_transferBtn];
    IMBTranferViewController *tranferVC = [IMBTranferViewController singleton];
    [tranferVC transferBtn:_transferBtn];
    tranferVC.showWindowDelegate = self;
    [_rootBox setWantsLayer:YES];
    [_lineView1 setLineColor:COLOR_MAIN_WINDOW_LINE_COLOR];
    [_lineView2 setLineColor:COLOR_MAIN_WINDOW_LINE_COLOR];
    
    //设置toolbar上右上角3个按钮的高亮图片
    [_shoppingCartBtn setHoverImage:@"navbar_icon_cart_big_hover" withSelfImage:[NSImage imageNamed:@"navbar_icon_cart_big"]];
    [_transferBtn setHoverImage:@"navbar_icon_transtion_hover" withSelfImage:[NSImage imageNamed:@"navbar_icon_transtion"]];
    
    IMBDrawOneImageBtn *button = [[IMBDrawOneImageBtn alloc]initWithFrame:NSMakeRect(12, 18, 12, 12)];
    [button mouseDownImage:[NSImage imageNamed:@"windowclose3"] withMouseUpImg:[NSImage imageNamed:@"windowclose"] withMouseExitedImg:[NSImage imageNamed:@"windowclose"] mouseEnterImg:[NSImage imageNamed:@"windowclose2"]];
    [button setEnabled:YES];
    [button setTarget:self];
    [button setAction:@selector(closeWindow:)];
    [button setBordered:NO];
    
    IMBDrawOneImageBtn *minButton = [[IMBDrawOneImageBtn alloc]initWithFrame:NSMakeRect(32, 18, 12, 12)];
    [minButton mouseDownImage:[NSImage imageNamed:@"windowmin3"] withMouseUpImg:[NSImage imageNamed:@"windowmin"] withMouseExitedImg:[NSImage imageNamed:@"windowmin"] mouseEnterImg:[NSImage imageNamed:@"windowmin2"]];
    [minButton setEnabled:YES];
    [minButton setTarget:self];
    [minButton setAction:@selector(minWindow:)];
    [minButton setBordered:NO];
    
    [_topView initWithLuCorner:YES LbCorner:NO RuCorner:YES RbConer:NO CornerRadius:5];
    [_topView setBackgroundColor:COLOR_DEVICE_Main_WINDOW_TOPVIEW_COLOR];
    [_topView addSubview:button];
    [_topView addSubview:minButton];
//    [_topView setBackgroundColor:COLOR_MAIN_WINDOW_BG];
    [_selectedDeviceBtn setHidden:NO];
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    IMBBaseInfo *deviceBaseInfo = nil;
    if (_chooseModelEnum == iCloudLogEnum) {
        for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
            if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                deviceBaseInfo = baseInfo;
            }
        }
        [_selectedDeviceBtn setTitle:deviceBaseInfo.deviceName titleColor:COLOR_TEXT_ORDINARY titleSize:kSelectedBtnfontSize leftIcon:nil rightIcon:@"navbar_icon_dropdown_triangle"];

        _baseViewController = [[IMBiCloudDriverViewController alloc] initWithDrivemanage:_driveBaseManage withDelegete:_delegate withChooseLoginModelEnum:_chooseModelEnum];
        IMBiCloudDriverViewController *icloudVC = (IMBiCloudDriverViewController *)_baseViewController;
        [icloudVC setBaseInfo:deviceBaseInfo];
        [_baseViewController transferBtn:_transferBtn];
        [_rootBox setContentView:_baseViewController.view];
    
    }else if (_chooseModelEnum == DropBoxLogEnum) {
        for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
            if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                deviceBaseInfo = baseInfo;
            }
        }
        [_selectedDeviceBtn setTitle:deviceBaseInfo.deviceName titleColor:COLOR_TEXT_ORDINARY titleSize:kSelectedBtnfontSize leftIcon:nil rightIcon:@"navbar_icon_dropdown_triangle"];
        _baseViewController = [[IMBiCloudDriverViewController alloc] initWithDrivemanage:_driveBaseManage withDelegete:_delegate withChooseLoginModelEnum:_chooseModelEnum];
        IMBiCloudDriverViewController *icloudVC = (IMBiCloudDriverViewController *)_baseViewController;
        [icloudVC setBaseInfo:deviceBaseInfo];
        [_baseViewController transferBtn:_transferBtn];
        [_rootBox setContentView:_baseViewController.view];
    }else if (_chooseModelEnum == DeviceLogEnum) {
        for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
            if ([baseInfo.uniqueKey isEqualToString:_iPod.uniqueKey]) {
                deviceBaseInfo = baseInfo;
            }
        }
        [_selectedDeviceBtn setTitle:deviceBaseInfo.deviceName titleColor:COLOR_TEXT_ORDINARY titleSize:kSelectedBtnfontSize leftIcon:nil rightIcon:@"navbar_icon_dropdown_triangle"];
        _baseViewController = [[IMBDevicePageViewController alloc]initWithiPod:_iPod withDelegate:_delegate];
        [_baseViewController transferBtn:_transferBtn];
        [_rootBox setContentView:_baseViewController.view];
    }
    
    [_searchView setTarget:self];
    [_searchView setAction:@selector(openSearchView:)];
    [_searchView.searchField addObserver:self forKeyPath:@"stringValue" options:NSKeyValueObservingOptionNew context:nil];
    [self addMouseEventTracking];
    
    [_searchView.searchField setTarget:self];
    [_searchView.searchField setAction:@selector(toolbarSearchClicked:)];
    
    [self.view setWantsLayer:YES];
    [self.view.layer setMasksToBounds:YES];
    [self.view.layer setCornerRadius:5];
    
    if ([[IMBLimitation sharedLimitation] registerStatus]) {
        _searchView.imb_x = 986.f;
        _topViewSepLine1.hidden = YES;
        _shoppingCartBtn.hidden = YES;
    }else {
        _searchView.imb_x = 915.f;
        _topViewSepLine1.hidden = NO;
        _shoppingCartBtn.hidden = NO;
    }
    _originalSearchViewF = _searchView.frame;
    [IMBNotiCenter addObserver:self selector:@selector(hideFileDetailView:) name:NOTIFY_HIDE_ICLOUDDETAIL object:nil];
    [IMBNotiCenter addObserver:self selector:@selector(registerSuccess) name:IMBRegisteredSuccessfulNoti object:nil];
    [IMBNotiCenter addObserver:self selector:@selector(achieveLimitation:) name:IMBLimitationNoti object:nil];
}

#pragma -- mark  Actions
- (void)achieveLimitation:(NSNotification *)noti {
    NSString *key = [noti object];
    if (_chooseModelEnum == DeviceLogEnum) {
        if ([key isEqualToString:_iPod.uniqueKey]) {
            [self beforeShowAnnoyView];
        }
    }else if (_chooseModelEnum == DropBoxLogEnum) {
        if ([key isEqualToString:@"DropBox"]) {
            [self beforeShowAnnoyView];
        }
    }else {
        if ([key isEqualToString:@"iCloud"]) {
            [self beforeShowAnnoyView];
        }
    }
    
}

- (void)beforeShowAnnoyView {
    IMBFLog(@"current thread1 -- %@",[NSThread currentThread]);
    if ([NSThread currentThread] == [NSThread mainThread]) {
        [self showAnnoyView];
        return;
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self showAnnoyView];
    });
}

- (void)showAnnoyView {
    if (_annoyVc) {
        [_annoyVc release];
        _annoyVc = nil;
    }
    _isShowTranfer = NO;
    
    _topcoverView.hidden = NO;
    CGFloat timeInterval = 0.45f;
    _annoyVc = [IMBPurchaseOrAnnoyController annoyWithToMacLeftNum:[[IMBLimitation sharedLimitation] leftToMacNums] toDeviceLeftNum:[[IMBLimitation sharedLimitation] leftToDeviceNums] toCloudLeftNum:[[IMBLimitation sharedLimitation] leftToCloudNums]];
    _annoyVc.view.frame = NSMakeRect(0, -590.f, 1096.f, 590.f);
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBTranferBackgroundView") class]]) {
            view = subView;
            break;
        }
    }
    for (NSView *subView in view.subviews) {
        [subView removeFromSuperview];
    }
    
    view.hidden = NO;
    [view addSubview:_annoyVc.view];
    _annoyVc.closeClicked = ^{
        //关闭按钮点击
        [IMBViewAnimation animationPositionYWithView:_annoyVc.view toY:-590.f timeInterval:timeInterval completion:^{
            NSString *key = nil;
            if (_chooseModelEnum == DeviceLogEnum) {
                key = _iPod.uniqueKey;
            }else if (_chooseModelEnum == DropBoxLogEnum) {
                key = @"DropBox";
            }else {
                key = @"iCloud";
            }
            [IMBLimitation sharedLimitation].isShownAnnoyView = YES;
            [IMBNotiCenter postNotificationName:IMBLimitationViewClosedNoti object:key];
            _topcoverView.hidden = YES;
            [_annoyVc.view removeFromSuperview];
            [_annoyVc release];
            _annoyVc = nil;
        }];
    };
    
    [IMBViewAnimation animationPositionYWithView:_annoyVc.view toY:0 timeInterval:timeInterval completion:^{
        //        _topcoverView.hidden = NO;
    }];
}
- (void)registerSuccess {
    if (_purchaseVc) {
        [IMBViewAnimation animationPositionYWithView:_purchaseVc.view toY:-590.f timeInterval:.35f completion:^{
            _topcoverView.hidden = YES;
            [_purchaseVc release];
            _purchaseVc = nil;
        }];
    }
    if (_annoyVc) {
        //关闭按钮点击
        [IMBViewAnimation animationPositionXWithView:_annoyVc.view toX:1096.f timeInterval:0.45f completion:^{
            [_annoyVc.view removeFromSuperview];
            [_annoyVc release];
            _annoyVc = nil;
        }];
    }
    
    _searchView.imb_x = 986.f;
    _topViewSepLine1.hidden = YES;
    _shoppingCartBtn.hidden = YES;
    
}
- (void)toMac:(IMBInformation *)information {

}

- (void)addItems:(id)sender {

}

- (void)backAction:(id)sender {
    [(IMBDevicePageViewController *)_baseViewController backAction:sender];
}

- (void)doSwitchView:(id)sender {
    [_baseViewController doSwitchView:sender];
}
//设备断开连接
- (void)disconnectedDevice:(NSNotification *)noti {
    NSString *serNum = [noti object];
    if ([serNum isEqualToString:_iPod.uniqueKey]) {
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBTranferBackgroundView") class]]) {
                view = subView;
                break;
            }
        }
        for (NSView *subView in view.subviews) {
            [subView removeFromSuperview];
        }
    }
}
#pragma mark - toolbar上 搜索、购物车 和 传输  按钮点击事件
- (IBAction)toolbarSearchClicked:(IMBHoverChangeImageBtn *)sender {
    [(IMBBaseViewController*)_baseViewController doSearchBtn:_searchView.stringValue withSearchBtn:_searchView];
}

- (IBAction)toolbarShoppingCartClicked:(IMBHoverChangeImageBtn *)sender {
    IMBFFuncLog
    _isShowTranfer = NO;
    CGFloat timeInterval = 0.45f;
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBTranferBackgroundView") class]]) {
            view = subView;
            break;
        }
    }
    for (NSView *subView in view.subviews) {
        [subView removeFromSuperview];
    }
    
    if (_purchaseVc) {
        [_purchaseVc release];
        _purchaseVc = nil;
    }
    view.hidden = NO;
    _topcoverView.hidden = NO;
    
    _purchaseVc = [IMBPurchaseOrAnnoyController purchase];
    _purchaseVc.view.frame = NSMakeRect(0, -590.f, 1096.f, 590.f);
    [view addSubview:_purchaseVc.view];
    _purchaseVc.closeClicked = ^{
        [IMBViewAnimation animationPositionYWithView:_purchaseVc.view toY:-590.f timeInterval:timeInterval completion:^{
            _topcoverView.hidden = YES;
        }];
    };
    
    [IMBViewAnimation animationPositionYWithView:_purchaseVc.view toY:0 timeInterval:timeInterval completion:^{
        
    }];
    
}

- (IBAction)toolbarTransfefClicked:(IMBHoverChangeImageBtn *)sender {
    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
    [tranferView setDelegate:self];
    tranferView.unlimitClicked = ^{
        _isShowTranfer = NO;
        
        if (_annoyVc) {
            [_annoyVc release];
            _annoyVc = nil;
        }
        
        _annoyVc = [IMBPurchaseOrAnnoyController annoyWithToMacLeftNum:[[IMBLimitation sharedLimitation] leftToMacNums] toDeviceLeftNum:[[IMBLimitation sharedLimitation] leftToDeviceNums] toCloudLeftNum:[[IMBLimitation sharedLimitation] leftToCloudNums]];
        _annoyVc.view.imb_x = 1096.f - tranferView.view.imb_width;
        [tranferView.view.superview addSubview:_annoyVc.view];
        [tranferView.view removeFromSuperview];
        
        _annoyVc.closeClicked = ^{
            //关闭按钮点击
            [IMBViewAnimation animationPositionXWithView:_annoyVc.view toX:1096.f timeInterval:0.45f completion:^{
                [_annoyVc.view removeFromSuperview];
                [_annoyVc release];
                _annoyVc = nil;
            }];
        };
        
        [IMBViewAnimation animationPositionXWithView:_annoyVc.view toX:0 timeInterval:0.35f completion:^{
            
        }];
    };
    [tranferView transferBtn:_transferBtn];
    if (!_isShowTranfer) {
        
        _isShowCompleteView = NO;
        _isShowTranfer = YES;
        [tranferView reparinitialization];
        [tranferView.view setFrame:NSMakeRect([_delegate window].contentView.frame.size.width - 360 + 4 , -6, 360, tranferView.view.frame.size.height)];
        
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBTranferBackgroundView") class]]) {
                view = subView;
                break;
            }
        }
        
        
        [tranferView.view setWantsLayer:YES];
        [view setHidden:NO];
        [view setWantsLayer:YES];
        [view addSubview:tranferView.view];
        [tranferView.view.layer addAnimation:[IMBAnimation moveX:0.5 fromX:[NSNumber numberWithInt:tranferView.view.frame.size.width] toX:[NSNumber numberWithInt:0] repeatCount:1 beginTime:0]  forKey:@"moveX"];
        
        if ([[IMBLimitation sharedLimitation] registerStatus]) {
            [tranferView setLimitViewShowing:NO];
        }else {
            [tranferView setLimitViewShowing:YES];
        }
    }else {
        if (_isShowCompleteView) {
            _isShowCompleteView = NO;
            _isShowTranfer = NO;
             IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
            [tranferView setDelegate:self];
            [tranferView transferBtn:_transferBtn];
            [tranferView closeCompleteView:nil];
        }else{
            _isShowTranfer = NO;
            [tranferView.view setFrame:NSMakeRect([_delegate window].contentView.frame.size.width - tranferView.view.frame.size.width +8, -8, 360, tranferView.view.frame.size.height)];
            NSView *view = nil;
            for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
                if ([subView isMemberOfClass:[NSClassFromString(@"IMBTranferBackgroundView") class]]) {
                    view = subView;
                    break;
                }
            }
            for (NSView *subView in view.subviews) {
                [subView removeFromSuperview];
            }
            [view setHidden:NO];
            [view setWantsLayer:YES];
            [view addSubview:tranferView.view];
            [tranferView.view setWantsLayer:YES];
            [tranferView.view.layer addAnimation:[IMBAnimation moveX:0.5 fromX:[NSNumber numberWithInt:0] toX:[NSNumber numberWithInt:tranferView.view.frame.size.width] repeatCount:1 beginTime:0]  forKey:@"moveX"];
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [view setHidden:YES];
                [view.layer removeAllAnimations];
                [tranferView.view.layer removeAllAnimations];
                [tranferView.view removeFromSuperview];
                [tranferView.view setFrame:NSMakeRect([_delegate window].contentView.frame.size.width +8, -8, 360, tranferView.view.frame.size.height)];
            });
        }
    }
}

- (void)setIsShowCompletView:(BOOL)isShowCompleteView {
    _isShowCompleteView = isShowCompleteView;
}


#pragma -- mark  DeviceBtn Actions
- (IBAction)selectedDeviceBtnDown:(id)sender {
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
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    IMBBaseInfo *deviceBaseInfo = nil;
    for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
        if ([baseInfo.uniqueKey isEqualToString:_iPod.uniqueKey]) {
            deviceBaseInfo = baseInfo;
        }
    }
    if (deviceConnection.allDevices) {
        _popoverViewController = [[IMBPopoverViewController alloc] initWithNibName:@"IMBPopoverViewController" bundle:nil withSelectedValue:deviceBaseInfo.uniqueKey WithDevice:deviceConnection.allDevices withConnectType:deviceBaseInfo.connectType];
        [_popoverViewController setTarget:self];
        [_popoverViewController setAction:@selector(onItemClicked:)];
        
        [_popoverViewController setExitTarget:self];
        [_popoverViewController setExitAction:@selector(onItemExitClicked:)];
        [_popoverViewController setDelegate:self];
        if (_devPopover != nil) {
            _devPopover.contentViewController = _popoverViewController;
        }
        
        [_popoverViewController release];
        
        NSButton *targetButton = (NSButton *)sender;
        NSRectEdge prefEdge = NSMaxYEdge;
        NSRect rect = NSMakeRect(targetButton.bounds.origin.x, targetButton.bounds.origin.y, targetButton.bounds.size.width, targetButton.bounds.size.height);
        [_devPopover showRelativeToRect:rect ofView:sender preferredEdge:prefEdge];
    }
}

- (void)onItemClicked:(id)sender {
    IMBViewManager *viewManager = [IMBViewManager singleton];
    IMBDeviceConnection *connection = [IMBDeviceConnection singleton];
    IMBBaseInfo *baseInfo = (IMBBaseInfo *)sender;
    IMBMainWindowController *windowController = nil;
    [_devPopover close];
    if (baseInfo.connectType == general_Add_Content) {
        NSDictionary *dimensionDict = nil;
        @autoreleasepool {
            [TempHelper customViewType:_chooseModelEnum withCategoryEnum:_baseViewController.category];
            dimensionDict = [[TempHelper customDimension] copy];
        }
        if (_chooseModelEnum == iCloudLogEnum) {
            [ATTracker event:CiCloud action:AAddAccount label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (_chooseModelEnum == DropBoxLogEnum) {
            [ATTracker event:CDropbox action:AAddAccount label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else {
            [ATTracker event:CDevice action:AAddAccount label:LNone labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
        if (dimensionDict) {
            [dimensionDict release];
            dimensionDict = nil;
        }
        if (!viewManager.mainWindowController) {
            viewManager.mainWindowController = [[IMBMainWindowController alloc] initWithNewWindow];
            [viewManager.mainWindowController.window setContentSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
        }
        [viewManager.mainWindowController showWindow:self];
    }else {
        if (_chooseModelEnum == iCloudLogEnum || _chooseModelEnum == DropBoxLogEnum) {
            if (_chooseModelEnum == baseInfo.chooseModelEnum) {
                return;
            }else if (_chooseModelEnum == iCloudLogEnum){
                if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                    windowController = [viewManager.windowDic objectForKey:@"DropBox"];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:nil withKey:@"DropBox" withCloud:@"iCloud"];
                    }
                }else {
                    IMBiPod *ipod = [connection getiPodByKey:baseInfo.uniqueKey];
                    windowController = [viewManager.windowDic objectForKey:baseInfo.uniqueKey];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:ipod withKey:baseInfo.uniqueKey withCloud:@"iCloud"];
                    }
                }
            }else {
                if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                    windowController = [viewManager.windowDic objectForKey:@"iCloud"];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:nil withKey:@"iCloud" withCloud:@"DropBox"];
                    }
                }else {
                    IMBiPod *ipod = [connection getiPodByKey:baseInfo.uniqueKey];
                    windowController = [viewManager.windowDic objectForKey:baseInfo.uniqueKey];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:ipod withKey:baseInfo.uniqueKey withCloud:@"DropBox"];
                    }
                }
            }
        }else if ([baseInfo.uniqueKey isEqualToString:_iPod.uniqueKey]) {
            return;
        }else {
            IMBiPod *ipod = [connection getiPodByKey:baseInfo.uniqueKey];
            NSDictionary *dimensionDict = nil;
            
            if (_chooseModelEnum == iCloudLogEnum) {
                if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                    return;
                }else if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                    @autoreleasepool {
                        [TempHelper customViewType:baseInfo.chooseModelEnum withCategoryEnum:0];
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:CiCloud action:AJump label:LNone labelParameters:@"Dropbox" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    windowController = [viewManager.windowDic objectForKey:@"DropBox"];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:nil withKey:@"DropBox" withCloud:@"iCloud"];
                    }
                }else if (baseInfo.chooseModelEnum == DeviceLogEnum) {
                    @autoreleasepool {
                        [TempHelper customViewType:baseInfo.chooseModelEnum withCategoryEnum:0];
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:CiCloud action:AJump label:LNone labelParameters:@"Device" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    windowController = [viewManager.windowDic objectForKey:baseInfo.uniqueKey];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:ipod withKey:baseInfo.uniqueKey withCloud:@"iCloud"];
                    }
                }
            }else if (_chooseModelEnum == DropBoxLogEnum) {
                if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                    @autoreleasepool {
                        [TempHelper customViewType:baseInfo.chooseModelEnum withCategoryEnum:0];
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:CDropbox action:AJump label:LNone labelParameters:@"iCloud" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    windowController = [viewManager.windowDic objectForKey:@"iCloud"];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:nil withKey:@"iCloud" withCloud:@"DropBox"];
                    }
                }else if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                    return;
                }else if (baseInfo.chooseModelEnum == DeviceLogEnum) {
                    @autoreleasepool {
                        [TempHelper customViewType:baseInfo.chooseModelEnum withCategoryEnum:0];
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:CDropbox action:AJump label:LNone labelParameters:@"Device" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    windowController = [viewManager.windowDic objectForKey:baseInfo.uniqueKey];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:ipod withKey:baseInfo.uniqueKey withCloud:@"DropBox"];
                    }
                }
            }else if (_chooseModelEnum == DeviceLogEnum) {
                if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                    @autoreleasepool {
                        [TempHelper customViewType:baseInfo.chooseModelEnum withCategoryEnum:0];
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:CDevice action:AJump label:LNone labelParameters:@"iCloud" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                    windowController = [viewManager.windowDic objectForKey:@"iCloud"];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:nil withKey:@"iCloud" withCloud:_iPod.uniqueKey];
                    }
                }else if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                    @autoreleasepool {
                        [TempHelper customViewType:baseInfo.chooseModelEnum withCategoryEnum:0];
                        dimensionDict = [[TempHelper customDimension] copy];
                    }
                    [ATTracker event:CDevice action:AJump label:LNone labelParameters:@"Dropbox" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
                     windowController = [viewManager.windowDic objectForKey:@"DropBox"];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:nil withKey:@"DropBox" withCloud:_iPod.uniqueKey];
                    }
                }else if (baseInfo.chooseModelEnum == DeviceLogEnum) {
                    windowController = [viewManager.windowDic objectForKey:@"DropBox"];
                    if (!windowController) {
                        IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
                        [_delegate switchMainPageViewControllerWithiPod:[deviceConnection getiPodByKey:baseInfo.uniqueKey] withKey:baseInfo.uniqueKey withCloud:_iPod.uniqueKey];
                    }
                }
            }
            if (dimensionDict) {
                [dimensionDict release];
                dimensionDict = nil;
            }
            if (windowController) {
                [windowController showWindow:self];
            }
        }
    }
}

- (void)onItemExitClicked:(id)sender {
    
}

//弹出设备
- (void)backdrive:(IMBBaseInfo *)baseInfo{
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:baseInfo.chooseModelEnum withCategoryEnum:_baseViewController.category];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if (baseInfo.chooseModelEnum == iCloudLogEnum) {
        [ATTracker event:CiCloud action:ALogout label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }else if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
        [ATTracker event:CDropbox action:ALogout label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }else if (baseInfo.chooseModelEnum == DeviceLogEnum) {
        [ATTracker event:CDevice action:ALogout label:LSuccess labelParameters:@"1" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    [_devPopover close];
    NSMutableArray *deviceAry = [[NSMutableArray alloc]init];;
     IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    
//    [deviceConnection removeIPodByKey:baseInfo.uniqueKey];
    [deviceConnection removeDeviceByKey:baseInfo.uniqueKey];
    for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
        if (baseInfo.chooseModelEnum == DeviceLogEnum) {
            [deviceAry addObject:baseInfo];
        }
    }
    IMBViewManager *viewManager = [IMBViewManager singleton];
    if (baseInfo.chooseModelEnum == DeviceLogEnum) {
        if (_chooseModelEnum == DeviceLogEnum) {
            if ([_iPod.uniqueKey isEqualToString:baseInfo.uniqueKey]) {
                if (viewManager.windowDic.count >1) {
                    NSWindow *window = [viewManager.windowDic objectForKey:baseInfo.uniqueKey];
                    [window close];
                    [viewManager.windowDic removeObjectForKey:baseInfo.uniqueKey];
                    [viewManager.allMainControllerDic removeObjectForKey:baseInfo.uniqueKey];
                }else {
                    [self backMainView:nil];
                    [viewManager.allMainControllerDic removeObjectForKey:baseInfo.uniqueKey];
                }
            }else {
                NSWindow *window = [viewManager.windowDic objectForKey:baseInfo.uniqueKey];
                if (window) {
                    [window close];
                    [viewManager.windowDic removeObjectForKey:baseInfo.uniqueKey];
                    [viewManager.allMainControllerDic removeObjectForKey:baseInfo.uniqueKey];
                }else {
                    if ([viewManager.allMainControllerDic objectForKey:baseInfo.uniqueKey]) {
                        [viewManager.allMainControllerDic removeObjectForKey:baseInfo.uniqueKey];
                    }
                }
            }
        }else if (_chooseModelEnum == DropBoxLogEnum) {
            NSWindow *window = [viewManager.windowDic objectForKey:baseInfo.uniqueKey];
            if (window) {
                [window close];
                [viewManager.windowDic removeObjectForKey:baseInfo.uniqueKey];
                [viewManager.allMainControllerDic removeObjectForKey:baseInfo.uniqueKey];
            }else {
                if ([viewManager.allMainControllerDic objectForKey:baseInfo.uniqueKey]) {
                    [viewManager.allMainControllerDic removeObjectForKey:baseInfo.uniqueKey];
                }
            }
        }else if (_chooseModelEnum == iCloudLogEnum) {
            NSWindow *window = [viewManager.windowDic objectForKey:baseInfo.uniqueKey];
            if (window) {
                [window close];
                [viewManager.windowDic removeObjectForKey:baseInfo.uniqueKey];
                [viewManager.allMainControllerDic removeObjectForKey:baseInfo.uniqueKey];
            }else {
                if ([viewManager.allMainControllerDic objectForKey:baseInfo.uniqueKey]) {
                    [viewManager.allMainControllerDic removeObjectForKey:baseInfo.uniqueKey];
                }
            }
        }
        if (deviceAry.count >0) {
            IMBBaseInfo *baseInfo = [deviceAry objectAtIndex:0];
            [viewManager.mainViewController chooseDeviceBtn:baseInfo];
        }else {
            [viewManager.mainViewController chooseDeviceBtn:nil];
        }
    }else if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
        if (_chooseModelEnum == DeviceLogEnum) {
            NSWindow *window = [viewManager.windowDic objectForKey:@"DropBox"];
            if (window) {
                [window close];
                [viewManager.windowDic removeObjectForKey:@"DropBox"];
                [viewManager.allMainControllerDic removeObjectForKey:@"DropBox"];
            }else {
                if ([viewManager.allMainControllerDic objectForKey:@"DropBox"]) {
                    [viewManager.allMainControllerDic removeObjectForKey:@"DropBox"];
                }
            }
        }else if (_chooseModelEnum == DropBoxLogEnum) {
            if (viewManager.windowDic.count >1) {
                NSWindow *window = [viewManager.windowDic objectForKey:@"DropBox"];
                if (window) {
                    [window close];
                    [viewManager.windowDic removeObjectForKey:@"DropBox"];
                    [viewManager.allMainControllerDic removeObjectForKey:@"DropBox"];
                }else {
                    if ([viewManager.allMainControllerDic objectForKey:@"DropBox"]) {
                        [viewManager.allMainControllerDic removeObjectForKey:@"DropBox"];
                    }
                }
            }else {
                [self backMainView:nil];
                NSWindow *window = [viewManager.windowDic objectForKey:@"DropBox"];
                if (window) {
                    [viewManager.windowDic removeObjectForKey:@"DropBox"];
                    [viewManager.allMainControllerDic removeObjectForKey:@"DropBox"];
                }else {
                    if ([viewManager.allMainControllerDic objectForKey:@"DropBox"]) {
                        [viewManager.allMainControllerDic removeObjectForKey:@"DropBox"];
                    }
                }
                
            }
        }else if (_chooseModelEnum == iCloudLogEnum) {
            NSWindow *window = [viewManager.windowDic objectForKey:@"DropBox"];
            if (window) {
                [window close];
                [viewManager.windowDic removeObjectForKey:@"DropBox"];
                [viewManager.allMainControllerDic removeObjectForKey:@"DropBox"];
            }else {
                if ([viewManager.allMainControllerDic objectForKey:@"DropBox"]) {
                    [viewManager.allMainControllerDic removeObjectForKey:@"DropBox"];
                }
            }
        }
        [viewManager.mainViewController signoutDropboxClicked];
    }else if (baseInfo.chooseModelEnum == iCloudLogEnum) {
        if (_chooseModelEnum == DeviceLogEnum) {
            NSWindow *window = [viewManager.windowDic objectForKey:@"iCloud"];
            if (window) {
                [window close];
                [viewManager.windowDic removeObjectForKey:@"iCloud"];
                [viewManager.allMainControllerDic removeObjectForKey:@"iCloud"];
            }else {
                if ([viewManager.allMainControllerDic objectForKey:@"iCloud"]) {
                    [viewManager.allMainControllerDic removeObjectForKey:@"iCloud"];
                }
            }
        }else if (_chooseModelEnum == DropBoxLogEnum) {
            NSWindow *window = [viewManager.windowDic objectForKey:@"iCloud"];
            if (window) {
                [window close];
                [viewManager.windowDic removeObjectForKey:@"iCloud"];
                [viewManager.allMainControllerDic removeObjectForKey:@"iCloud"];
            }else {
                if ([viewManager.allMainControllerDic objectForKey:@"iCloud"]) {
                    [viewManager.allMainControllerDic removeObjectForKey:@"iCloud"];
                }
            }
        }else if (_chooseModelEnum == iCloudLogEnum) {
            if  (viewManager.windowDic.count > 1) {
                NSWindow *window = [viewManager.windowDic objectForKey:@"iCloud"];
                if (window) {
                    [window close];
                    [viewManager.windowDic removeObjectForKey:@"iCloud"];
                    [viewManager.allMainControllerDic removeObjectForKey:@"iCloud"];
                }else {
                    if ([viewManager.allMainControllerDic objectForKey:@"iCloud"]) {
                        [viewManager.allMainControllerDic removeObjectForKey:@"iCloud"];
                    }
                }
            }else {
                [self backMainView:nil];
                NSWindow *window = [viewManager.windowDic objectForKey:@"iCloud"];
                if (window) {
                    [viewManager.windowDic removeObjectForKey:@"iCloud"];
                    [viewManager.allMainControllerDic removeObjectForKey:@"iCloud"];
                }else {
                    if ([viewManager.allMainControllerDic objectForKey:@"iCloud"]) {
                        [viewManager.allMainControllerDic removeObjectForKey:@"iCloud"];
                    }
                }
            }
        }
        [viewManager.mainViewController signoutiCloudClicked];
    }
    [deviceAry release];
    deviceAry = nil;
//    [self changeSelectDeviceBtn:_curFunctionType];

//        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                                  baseInfo.uniqueKey, @"UniqueKey"
//                                  , nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:DeviceDisConnectedNotification object:baseInfo.uniqueKey userInfo:userInfo];
    
}

- (void)openWindow:(IMBBaseInfo *)baseInfo {
    NSDictionary *dimensionDict = nil;
    @autoreleasepool {
        [TempHelper customViewType:_chooseModelEnum withCategoryEnum:_baseViewController.category];
        dimensionDict = [[TempHelper customDimension] copy];
    }
    if (_chooseModelEnum == iCloudLogEnum) {
        if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
            [ATTracker event:CiCloud action:AJump label:LNone labelParameters:@"Dropbox" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (baseInfo.chooseModelEnum == DeviceLogEnum) {
            [ATTracker event:CiCloud action:AJump label:LNone labelParameters:@"Device" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
    }else if (_chooseModelEnum == DropBoxLogEnum) {
        if (baseInfo.chooseModelEnum == iCloudLogEnum) {
            [ATTracker event:CDropbox action:AJump label:LNone labelParameters:@"iCloud" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (baseInfo.chooseModelEnum == DeviceLogEnum) {
            [ATTracker event:CDropbox action:AJump label:LNone labelParameters:@"Device" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
    }else {
        if (baseInfo.chooseModelEnum == iCloudLogEnum) {
            [ATTracker event:CDevice action:AJump label:LNone labelParameters:@"iCloud" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
            [ATTracker event:CDevice action:AJump label:LNone labelParameters:@"Dropbox" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }else if (![baseInfo.uniqueKey isEqualToString:_iPod.uniqueKey]) {
            [ATTracker event:CDevice action:AJump label:LNone labelParameters:@"Device" transferCount:0 screenView:@"" userLanguageName:[TempHelper currentSelectionLanguage] customParameters:dimensionDict];
        }
    }
    if (dimensionDict) {
        [dimensionDict release];
        dimensionDict = nil;
    }
    if (_devPopover) {
        [_devPopover close];
    }
    IMBViewManager *viewManager = [IMBViewManager singleton];
    IMBMainWindowController *windowController = nil;
    if ([viewManager.windowDic objectForKey:@"iCloud"] && baseInfo.chooseModelEnum == iCloudLogEnum) {
        windowController = [viewManager.windowDic objectForKey:@"iCloud"];
        [windowController showWindow:self];
    }else if ([viewManager.windowDic objectForKey:@"DropBox"] && baseInfo.chooseModelEnum == DropBoxLogEnum) {
        windowController = [viewManager.windowDic objectForKey:@"DropBox"];
        [windowController showWindow:self];
    }else if ([viewManager.windowDic objectForKey:baseInfo.uniqueKey] && baseInfo.chooseModelEnum == DeviceLogEnum) {
        windowController = [viewManager.windowDic objectForKey:baseInfo.uniqueKey];
        [windowController showWindow:self];
    }else {
        IMBiPod *newiPod = [[IMBDeviceConnection singleton] getiPodByKey:baseInfo.uniqueKey];
        IMBMainWindowController *mainwindow = [[IMBMainWindowController alloc] initWithNewWindowiPod:newiPod WithNewWindow:YES withLogMedleEnum:baseInfo.chooseModelEnum];
        [mainwindow showWindow:self];
    }
}

- (void)closeWindow:(id)sender {
    [_delegate closeWindow:nil];
}

- (void)minWindow:(id)sender {
    [_delegate minWindow:nil];
}

- (IBAction)backMainView:(id)sender {
    _isShowTranfer = NO;
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBTranferBackgroundView") class]]) {
            view = subView;
            break;
        }
    }
    [view setHidden:YES];
    for (NSView *view1 in view.subviews) {
        [view1 removeFromSuperview];
    }
    [_delegate backMainViewChooseLoginModelEnum];
}

- (void)hideFileDetailView:(id)sender {
    if (_isShowTranfer && !_isShowCompleteView) {
        IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
        [tranferView setDelegate:self];
        [tranferView transferBtn:_transferBtn];
        _isShowTranfer = NO;
        [tranferView.view setFrame:NSMakeRect([_delegate window].contentView.frame.size.width - tranferView.view.frame.size.width +8, -8, 360, tranferView.view.frame.size.height)];
        NSView *view = nil;
        for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBTranferBackgroundView") class]]) {
                view = subView;
                break;
            }
        }
        [view setHidden:NO];
        [view setWantsLayer:YES];
        [view addSubview:tranferView.view];
        [tranferView.view setWantsLayer:YES];
        
        [tranferView.view.layer addAnimation:[IMBAnimation moveX:0.5 fromX:[NSNumber numberWithInt:0] toX:[NSNumber numberWithInt:tranferView.view.frame.size.width] repeatCount:1 beginTime:0]  forKey:@"moveX"];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [view setHidden:YES];
            [view.layer removeAllAnimations];
            [tranferView.view removeFromSuperview];
            [tranferView.view.layer removeAllAnimations];
            [tranferView.view setFrame:NSMakeRect([_delegate window].contentView.frame.size.width +8, -8, 360, tranferView.view.frame.size.height)];
        });
    }
}

- (void)closeCompteleTranferView {
    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
    [tranferView setDelegate:self];
    [tranferView transferBtn:_transferBtn];
    _isShowTranfer = NO;
    
    [tranferView.view.layer addAnimation:[IMBAnimation moveX:0.5 fromX:[NSNumber numberWithInt:0] toX:[NSNumber numberWithInt:tranferView.view.frame.size.width] repeatCount:1 beginTime:0]  forKey:@"moveX"];
    [self performSelector:@selector(closeCompleteOver) withObject:self afterDelay:0.5];
}

- (void)closeCompleteOver {
    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
    [tranferView.view removeFromSuperview];
    [tranferView transferBtn:_transferBtn];
    [tranferView.view.layer removeAllAnimations];
    [tranferView.view setFrame:NSMakeRect([_delegate window].contentView.frame.size.width - tranferView.view.frame.size.width +8, -8, 360, tranferView.view.frame.size.height)];

}

#pragma mark - 展开，收拢搜索框
- (void)openSearchView:(id)sender {
    if (_isLoadSearchView) {
        return;
    }
    if (_searchView.frame.size.width <= 21 && _searchView.searchField.isEnabled) {
        _isLoadSearchView = YES;
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 0.5;
            NSRect newRect = NSMakeRect(_searchView.frame.origin.x - 130 + 21, _searchView.frame.origin.y, 130, _searchView.frame.size.height);
            [[_searchView animator] setFrame:newRect];
            [_searchView setBackGroundColor:[NSColor whiteColor]];
            [_searchView setIsOpen:YES];
        } completionHandler:^{
            [_searchView.searchField setHidden:NO];
            [_searchView.closeBtn setHidden:NO];
            _isLoadSearchView = NO;
        }];
        
    }
}

//合拢searchView
- (void)closeSearchView {
    if (_isLoadSearchView) {
        return;
    }
    if (_searchView.frame.size.width > 21 && _searchView.searchField.isEnabled && [StringHelper stringIsNilOrEmpty:_searchView.searchField.stringValue]) {
        _isLoadSearchView = YES;
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 0.5;
            NSRect newRect = NSMakeRect(_searchView.frame.origin.x + 130 - 21, _searchView.frame.origin.y, 21, _searchView.frame.size.height);
            [[_searchView animator] setFrame:newRect];
            [_searchView setBackGroundColor:COLOR_MAIN_WINDOW_BG];
            [_searchView.searchField setHidden:YES];
            [_searchView.closeBtn setHidden:YES];
        } completionHandler:^{
            [_searchView setIsOpen:NO];
            _isLoadSearchView = NO;
            [_searchView mouseExited:nil];
            [_searchView setNeedsDisplay:YES];
//            NSRect newRect = NSMakeRect(_topView.frame.origin.x+_topView.frame.size.width - 180, _searchView.frame.origin.y, 21, _searchView.frame.size.height);
            [_searchView setFrame:_originalSearchViewF];
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"stringValue"]) {
        if ([StringHelper stringIsNilOrEmpty:_searchView.searchField.stringValue]) {
            [self closeSearchView];
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
    NSPoint point = [[self.view.window contentView] convertPoint:event.locationInWindow fromView:nil];
    NSView *superView = _searchView.superview;
    BOOL inSearchView = NSMouseInRect(point, NSMakeRect(_searchView.frame.origin.x, superView.frame.origin.y + _searchView.frame.origin.y, _searchView.frame.size.width, _searchView.frame.size.height), [[self.view.window contentView] isFlipped]);
    if (!inSearchView) {
        if ([StringHelper stringIsNilOrEmpty:_searchView.searchField.stringValue] && ![_searchView isHidden] && (_searchView.frame.size.width > 21)) {
            [self closeSearchView];
        }
    }
}


@end
