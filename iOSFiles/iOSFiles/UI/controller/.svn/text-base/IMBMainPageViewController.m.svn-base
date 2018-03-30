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
#import <objc/runtime.h>
#import "IMBSearchView.h"

static CGFloat const kSelectedBtnfontSize = 15.0f;

@interface IMBMainPageViewController ()

@end

@implementation IMBMainPageViewController

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

-(void)awakeFromNib {
    [super awakeFromNib];
    if (_alertSuperView) {
        NSMutableArray *obArr = objc_getAssociatedObject([NSApplication sharedApplication], &kIMBMainPageWindowAlertView);
        if (!obArr) {
            obArr = [NSMutableArray array];
        }
        switch (_chooseModelEnum) {
            case iCloudLogEnum:
            {
                [obArr addObject:@{@"key" : @"iCloud", @"alertView" : _alertSuperView}];
                objc_setAssociatedObject([NSApplication sharedApplication], &kIMBMainPageWindowAlertView, obArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
                break;
            case DropBoxLogEnum:
            {
                [obArr addObject:@{@"key" : @"DropBox", @"alertView" : _alertSuperView}];
                objc_setAssociatedObject([NSApplication sharedApplication], &kIMBMainPageWindowAlertView, obArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
                break;
            case DeviceLogEnum:
            {
                [obArr addObject:@{@"key" : _iPod.uniqueKey, @"alertView" : _alertSuperView}];
                objc_setAssociatedObject([NSApplication sharedApplication], &kIMBMainPageWindowAlertView, obArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
                break;
                
            default:
                break;
        }
        
    }
    [_rootBox setWantsLayer:YES];
    [_lineView1 setLineColor:COLOR_MAIN_WINDOW_LINE_COLOR];
    [_lineView2 setLineColor:COLOR_MAIN_WINDOW_LINE_COLOR];
    
    //设置toolbar上右上角3个按钮的高亮图片
    [_shoppingCartBtn setHoverImage:@"navbar_icon_cart_big_hover"];
    [_transferBtn setHoverImage:@"navbar_icon_transtion_hover"];
   
    IMBDrawOneImageBtn *button = [[IMBDrawOneImageBtn alloc]initWithFrame:NSMakeRect(12, 18, 12, 12)];
    [button mouseDownImage:[NSImage imageNamed:@"windowclose3"] withMouseUpImg:[NSImage imageNamed:@"windowclose"] withMouseExitedImg:[NSImage imageNamed:@"windowclose"] mouseEnterImg:[NSImage imageNamed:@"windowclose2"]];
    [button setEnabled:YES];
    [button setTarget:self];
    [button setAction:@selector(closeWindow:)];
    [button setBordered:NO];
    [_topView initWithLuCorner:YES LbCorner:NO RuCorner:YES RbConer:NO CornerRadius:5];
    [_topView setBackgroundColor:COLOR_DEVICE_Main_WINDOW_TOPVIEW_COLOR];
    [_topView addSubview:button];
    [_topView setBackgroundColor:COLOR_MAIN_WINDOW_BG];
    [_selectedDeviceBtn setHidden:NO];
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    IMBBaseInfo *deviceBaseInfo = nil;
    if (_chooseModelEnum == iCloudLogEnum) {
        for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
            if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                deviceBaseInfo = baseInfo;
            }
        }
        [_selectedDeviceBtn setTitle:deviceBaseInfo.deviceName titleColor:COLOR_MAINWINDOW_TITLE_TEXT titleSize:kSelectedBtnfontSize leftIcon:@"device_name_icloud" rightIcon:@"arrow"];

        _baseViewController = [[IMBiCloudDriverViewController alloc] initWithDrivemanage:_driveBaseManage withDelegete:_delegate withChooseLoginModelEnum:_chooseModelEnum];
        [_rootBox setContentView:_baseViewController.view];
        
    }else if (_chooseModelEnum == DropBoxLogEnum) {
        for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
            if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                deviceBaseInfo = baseInfo;
            }
        }
        
        [_selectedDeviceBtn setTitle:deviceBaseInfo.deviceName titleColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT titleSize:kSelectedBtnfontSize leftIcon:@"device_name_icloud" rightIcon:@"arrow"];
        _baseViewController = [[IMBiCloudDriverViewController alloc] initWithDrivemanage:_driveBaseManage withDelegete:_delegate withChooseLoginModelEnum:_chooseModelEnum];
        [_rootBox setContentView:_baseViewController.view];
    }else if (_chooseModelEnum == DeviceLogEnum) {
        for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
            if ([baseInfo.uniqueKey isEqualToString:_iPod.uniqueKey]) {
                deviceBaseInfo = baseInfo;
            }
        }
        [_selectedDeviceBtn setTitle:deviceBaseInfo.deviceName titleColor:COLOR_MAIN_WINDOW_SELECTEDBTN_TEXT titleSize:kSelectedBtnfontSize leftIcon:@"device_icon_iPhone_selected" rightIcon:@"popup_icon_arrow"];
        _baseViewController = [[IMBDevicePageViewController alloc]initWithiPod:_iPod withDelegate:_delegate];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideFileDetailView:) name:NOTIFY_HIDE_ICLOUDDETAIL object:nil];
}
#pragma -- mark  Actions
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

#pragma mark - toolbar上 搜索、购物车 和 传输  按钮点击事件
- (IBAction)toolbarSearchClicked:(id)sender {
    [(IMBBaseViewController*)_baseViewController doSearchBtn:_searchView.stringValue withSearchBtn:_searchView];
}

- (IBAction)toolbarShoppingCartClicked:(id)sender {
    IMBFFuncLog
}

- (IBAction)toolbarTransfefClicked:(id)sender {
    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
    [tranferView setDelegate:self];
    if (!_isShowTranfer) {
        _isShowCompleteView = NO;
        _isShowTranfer = YES;
        [tranferView reparinitialization];
        [tranferView.view setFrame:NSMakeRect([_delegate window].contentView.frame.size.width - 360+4 , -6, 360, tranferView.view.frame.size.height)];
        
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
        [tranferView.view setWantsLayer:YES];
        [view setHidden:NO];
        [view setWantsLayer:YES];
        [view addSubview:tranferView.view];
        [tranferView.view.layer addAnimation:[IMBAnimation moveX:0.5 fromX:[NSNumber numberWithInt:tranferView.view.frame.size.width] toX:[NSNumber numberWithInt:0] repeatCount:1 beginTime:0]  forKey:@"moveX"];
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8/*延迟执行时间*/ * NSEC_PER_SEC));
//        
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            [self.view setWantsLayer:YES];
//            [self.view.layer setMasksToBounds:YES];
//            [self.view.layer setCornerRadius:5];
//        });

        
    }else {
        if (_isShowCompleteView) {
            _isShowCompleteView = NO;
            _isShowTranfer = NO;
             IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
            [tranferView closeCompleteView:nil];
//            [tranferView.view setFrame:NSMakeRect([_delegate window].contentView.frame.size.width - tranferView.view.frame.size.width +8, -8, 360, tranferView.view.frame.size.height)];
//            NSView *view = nil;
//            for (NSView *subView in ((NSView *)self.view.window.contentView).subviews) {
//                if ([subView isMemberOfClass:[NSClassFromString(@"IMBTranferBackgroundView") class]]) {
//                    view = subView;
//                    break;
//                }
//            }
//            for (NSView *subView in view.subviews) {
//                [subView removeFromSuperview];
//            }
//            [view setHidden:NO];
//            [view setWantsLayer:YES];
//            [view addSubview:tranferView.view];
//            [tranferView.view setWantsLayer:YES];
//            [tranferView.view.layer addAnimation:[IMBAnimation moveX:0.5 fromX:[NSNumber numberWithInt:0] toX:[NSNumber numberWithInt:tranferView.view.frame.size.width] repeatCount:1 beginTime:0]  forKey:@"moveX"];

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
                [tranferView.view removeFromSuperview];
                [tranferView.view.layer removeAllAnimations];
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
        if (!viewManager.mainWindowController) {
            viewManager.mainWindowController = [[IMBMainWindowController alloc] initWithNewWindow];
            [viewManager.mainWindowController.window setContentSize:NSMakeSize(WindowMinSizeWidth, WindowMinSizeHigh)];
        }
        [viewManager.mainWindowController showWindow:self];
    }else {
        if (_chooseModelEnum == iCloudLogEnum || _chooseModelEnum == DropBoxLogEnum) {
            if (_chooseModelEnum == baseInfo.chooseModelEnum) {
                return;
            }
        }
        if ([baseInfo.uniqueKey isEqualToString:_iPod.uniqueKey] || _chooseModelEnum == baseInfo.chooseModelEnum) {
            return;
        }else {
            IMBiPod *ipod = [connection getiPodByKey:baseInfo.uniqueKey];
            if (_chooseModelEnum == iCloudLogEnum) {
                if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                    return;
                }else if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                    windowController = [viewManager.windowDic objectForKey:@"DropBox"];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:nil withKey:@"DropBox" withCloud:@"iCloud"];
                    }
                }else if (baseInfo.chooseModelEnum == DeviceLogEnum) {
                    windowController = [viewManager.windowDic objectForKey:baseInfo.uniqueKey];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:ipod withKey:baseInfo.uniqueKey withCloud:@"iCloud"];
                    }
                }
            }else if (_chooseModelEnum == DropBoxLogEnum) {
                if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                    windowController = [viewManager.windowDic objectForKey:@"iCloud"];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:nil withKey:@"iCloud" withCloud:@"DropBox"];
                    }
                }else if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                    return;
                }else if (baseInfo.chooseModelEnum == DeviceLogEnum) {
                    windowController = [viewManager.windowDic objectForKey:baseInfo.uniqueKey];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:ipod withKey:baseInfo.uniqueKey withCloud:@"DropBox"];
                    }
                }
            }else if (_chooseModelEnum == DeviceLogEnum) {
                if (baseInfo.chooseModelEnum == iCloudLogEnum) {
                    windowController = [viewManager.windowDic objectForKey:@"iCloud"];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:nil withKey:@"iCloud" withCloud:_iPod.uniqueKey];
                    }
                }else if (baseInfo.chooseModelEnum == DropBoxLogEnum) {
                     windowController = [viewManager.windowDic objectForKey:@"DropBox"];
                    if (!windowController) {
                        [_delegate switchMainPageViewControllerWithiPod:nil withKey:@"DropBox" withCloud:_iPod.uniqueKey];
                    }
                }else if (baseInfo.chooseModelEnum == DeviceLogEnum) {
                    return;
                }
            }
            if (windowController) {
                [windowController showWindow:self];
            }
        }
    }
}

- (void)onItemExitClicked:(id)sender {
    
}

- (void)backdrive:(IMBBaseInfo *)baseInfo {
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
    }
}

- (void)closeCompteleTranferView {
    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
    [tranferView setDelegate:self];
    _isShowTranfer = NO;
//    [tranferView.view setFrame:NSMakeRect([_delegate window].contentView.frame.size.width - tranferView.view.frame.size.width +8, -8, 360, tranferView.view.frame.size.height)];
//    [[_delegate window].contentView addSubview:tranferView.view];
//    [tranferView.view setWantsLayer:YES];
    
    [tranferView.view.layer addAnimation:[IMBAnimation moveX:0.5 fromX:[NSNumber numberWithInt:0] toX:[NSNumber numberWithInt:tranferView.view.frame.size.width] repeatCount:1 beginTime:0]  forKey:@"moveX"];
    [self performSelector:@selector(closeCompleteOver) withObject:self afterDelay:0.5];
}

- (void)closeCompleteOver {
    IMBTranferViewController *tranferView = [IMBTranferViewController singleton];
    [tranferView.view setFrame:NSMakeRect([_delegate window].contentView.frame.size.width - tranferView.view.frame.size.width +8, -8, 360, tranferView.view.frame.size.height)];

}

#pragma mark - 展开，收拢搜索框
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
            [_searchView setBackGroundColor:[NSColor whiteColor]];
            [_searchView setIsOpen:YES];
        } completionHandler:^{
            [_searchView.searchField setHidden:NO];
            [_searchView.closeBtn setHidden:NO];
            _isLoadSearchView = NO;
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
        if ([StringHelper stringIsNilOrEmpty:_searchView.searchField.stringValue] && ![_searchView isHidden] && (_searchView.frame.size.width > 26)) {
            [self closeSearchView];
        }
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
            [_searchView setBackGroundColor:COLOR_MAIN_WINDOW_BG];
            [_searchView.searchField setHidden:YES];
            [_searchView.closeBtn setHidden:YES];
        } completionHandler:^{
            [_searchView setIsOpen:NO];
            _isLoadSearchView = NO;
            [_searchView mouseExited:nil];
            [_searchView setNeedsDisplay:YES];
            NSRect newRect = NSMakeRect(_topView.frame.origin.x+_topView.frame.size.width - 188, _searchView.frame.origin.y, 26, _searchView.frame.size.height);
            [_searchView setFrame:newRect];
        }];
    }
}

- (void)dealloc {
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_HIDE_ICLOUDDETAIL object:nil];
}

@end
