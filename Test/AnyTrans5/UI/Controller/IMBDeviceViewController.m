//
//  IMBDeviceViewController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBDeviceViewController.h"
#import "IMBNotificationDefine.h"
#import "IMBDeviceMainPageViewController.h"
#import "IMBNavigationViewController.h"
#import "IMBDisconnectViewController.h"
#import "IMBInformationManager.h"
#import "IMBInformation.h"
#import "IMBBackgroundBorderView.h"
#import "SystemHelper.h"
#import "IMBFileSystem.h"
#import "IMBMainWindowController.h"
@interface IMBDeviceViewController ()

@end

@implementation IMBDeviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        _logHandle = [IMBLogManager singleton];
        _deviceConnection = [IMBDeviceConnection singleton];
        _deviceMainPageDic = [[NSMutableDictionary dictionary] retain];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(deviceConnected:) name:DeviceConnectedNotification object:nil];
        [nc addObserver:self selector:@selector(deviceDisconnected:) name:DeviceDisConnectedNotification object:nil];
        [nc addObserver:self selector:@selector(deviceChange:) name:DeviceChangeNotification object:nil];
        [nc addObserver:self selector:@selector(deviceNeedPassword:) name:DeviceNeedPasswordNotification object:nil];
        [nc addObserver:self selector:@selector(deviceIpodLoadComplete:) name:DeviceIpodLoadCompleteNotification object:nil];
        [_deviceConnection startListen];
    }
    return self;
}

- (void)awakeFromNib {
    _alertViewController = [[IMBAlertViewController alloc]initWithNibName:@"IMBAlertViewController" bundle:nil];
    [_alertViewController setDelegate:self];
//    [((IMBBackgroundBorderView *)self.view) setHasRadius:YES];
    [((IMBBackgroundBorderView *)self.view) setIsGradientWithCornerPart4:YES];
//    [((IMBBackgroundBorderView *)self.view) setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
//    [((IMBBackgroundBorderView *)self.view) setIsGradient:YES];

    
    [((IMBBackgroundBorderView *)self.view) setXRadius:5.0 YRadius:5.0];
    [self changeViewController:@"Disconnected" withIsDevice:NO withIsConnected:NO];
    [_searchFieldBtn setHidden:YES];
}

- (void)changeSkin:(NSNotification *)notification
{
//    [((IMBBackgroundBorderView *)self.view) setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [((IMBBackgroundBorderView *)self.view) setIsGradientWithCornerPart3:YES];
}

//切换视图
- (void)changeViewController:(NSString *)type withIsDevice:(BOOL)isDevice withIsConnected:(BOOL)isConnected
{
    IMBNavigationViewController *navigationController = [_deviceMainPageDic objectForKey:type];
    IMBBaseViewController *viewController = nil;
    if (!navigationController) {
        if (isDevice) {
            viewController = [[IMBDeviceMainPageViewController alloc] initWithIpod:_ipod withCategoryNodesEnum:Category_Summary withDelegate:self];
        }else {
            if ([type isEqualToString: @"Disconnected"]) {
                viewController = [[IMBDisconnectViewController alloc] init];
            }
        }
        if (viewController != nil && ![StringHelper stringIsNilOrEmpty:type]) {
            IMBNavigationViewController *navigationController = [[IMBNavigationViewController alloc] initWithRootViewController:viewController box:_deviceContentBox];
            [_deviceMainPageDic setObject:navigationController forKey:type];
            [viewController setSearchFieldBtn:_searchFieldBtn];
            //            [_deviceContentBox setContentView:viewController.view];
            //            if (!isConnected) {
            [self popViewController:viewController.view];
            //            }
            
            [viewController release];
            [navigationController release];
        }
    }else{
        viewController = (IMBBaseViewController *)navigationController.currentViewController;
        [viewController setSearchFieldBtn:_searchFieldBtn];
        [self popViewController:viewController.view];
    }
    if (!_isRestoreDisconnect && [(IMBMainWindowController *)_delegate curFunctionType] == DeviceModule) {
        [self setIsShowLineView:viewController.isShowLineView];
    }
}

//将视图渐变的显示到当前页面
- (void)popViewController:(NSView *)curView {
    CATransition *transition = [CATransition animation];
    transition.delegate = self;
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"fade";
    [_deviceContentBox.layer removeAllAnimations];
    [_deviceContentBox.layer addAnimation:transition forKey:@"animation"];
    [_deviceContentBox setContentView:curView];
}

- (void)ShowWindowControllerCategory
{
    if (_ipod) {
        IMBNavigationViewController *navigationController = [_deviceMainPageDic objectForKey:_ipod.uniqueKey];
        if ([(IMBBaseViewController *)navigationController.currentViewController category] == Category_Summary) {
            [_searchFieldBtn setHidden:YES];
        }else{
            [_searchFieldBtn setHidden:NO];
        }
    }else{
        [_searchFieldBtn setHidden:YES];
    }
}

#pragma mark - DEVICE Notification
- (void)deviceConnected:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        IMBNavigationViewController *navigationController = [_deviceMainPageDic objectForKey:@"Disconnected"];
        if (navigationController) {
            IMBDisconnectViewController *disconnectController = (IMBDisconnectViewController *)(navigationController.currentViewController);
            NSString *msgStr = CustomLocalizedString(@"noconnect_connecting", nil);
            [disconnectController setPromptTextString:msgStr];
            [disconnectController addTimer];
        }
        
    });
}

- (void)deviceDisconnected:(NSNotification *)notification
{
    //从_deviceMainPageDic移除对应页面的navigationController
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *uniqueKey = [notification object];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_IPOD_DISCONTENT object:uniqueKey];
        [_logHandle writeInfoLog:[NSString stringWithFormat:@"'%@' device disconnected!",uniqueKey]];
        if (_ipod) {
            _isRestoreDisconnect = _ipod.isAndroidToiOS;
        }
        if (_deviceConnection.deviceCount > 0) {
            if ([uniqueKey isEqualToString:_ipod.uniqueKey]) {
                IMBiPod *ipod = [_deviceConnection getNextConnectedIpod];
                if (ipod) {                    
                    if (!_ipod.isAndroidToiOS) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
                    }
                    if (_ipod != nil) {
                        [_ipod release];
                        _ipod = nil;
                    }
                    _ipod = [ipod retain];
                    if (_ipod.deviceInfo.isIOSDevice) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHANGE_IPOD object:_ipod];
                    }
                    
                    [self changeViewController:ipod.uniqueKey withIsDevice:YES withIsConnected:NO];
                }
            }
        }else {
            if (!_ipod.isAndroidToiOS) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TRANSFERING object:[NSNumber numberWithBool:YES]];
            }
            if (_ipod != nil) {
                [_ipod release];
                _ipod = nil;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHANGE_IPOD object:nil];
            
            
            IMBNavigationViewController *navigationController = [_deviceMainPageDic objectForKey:@"Disconnected"];
            if (navigationController) {
                IMBDisconnectViewController *disconnectController = (IMBDisconnectViewController *)(navigationController.currentViewController);
                for (NSView *view in [_deviceContentBox subviews]) {
                    if (view == disconnectController.view) {
                        double delayInSeconds = 3.0;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            NSString *msgStr = CustomLocalizedString(@"noconnect_plugindevice", nil);
                            [disconnectController setPromptTextString:msgStr];
                            [disconnectController killTimer];
                            [disconnectController setTimerNil];
                        });
                        break;
                    }else{
                        NSString *msgStr = CustomLocalizedString(@"noconnect_plugindevice", nil);
                        [disconnectController setPromptTextString:msgStr];
                    }
                }
            }
            [self changeViewController:@"Disconnected" withIsDevice:NO withIsConnected:NO];
            
        }
        if ([_deviceMainPageDic.allKeys containsObject:uniqueKey]) {
            [_deviceMainPageDic removeObjectForKey:uniqueKey];
        }
    });
}

- (void)deviceNeedPassword:(NSNotification *)notification
{
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        NSAlert *alert = [NSAlert alertWithMessageText:CustomLocalizedString(@"TrustView_id_1", nil) defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
    //        [alert.window setTitle:@"AnyTrans"];
    //        [alert.window center];
    //
    //        [alert beginSheetModalForWindow:nil modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)  contextInfo:nil];
    sleep(3);
    device = notification.object;
    [self performSelectorOnMainThread:@selector(showAlertTrust) withObject:self waitUntilDone:NO];
    //    if (conut == 1) {
    //        [_alertnewViewController closeTrustView];
    //        [_deviceConnection performSelector:@selector(resConnectDevice:) withObject:device afterDelay:0.4f];
    //    }
    //    });
}

- (void)showAlertTrust{
    [_contentView setHidden:NO];
    if (_contentView == nil) {
        for (NSView *subView in ((NSView *)_mainWindow.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                _contentView = subView;
                NSLog(@"_contentView:%@",_contentView);
                [_contentView setHidden:NO];
                break;
            }
        }
    }
    [_alertViewController showAlertTrustView:_contentView];
}

-(void)trustBtnOperation:(id)sender{
    [_deviceConnection performSelector:@selector(resConnectDevice:) withObject:device afterDelay:1.0f];
}

- (void)deviceIpodLoadComplete:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = [notification userInfo];
        IMBBaseInfo *baseInfo = [userInfo objectForKey:@"DeviceInfo"];
        NSString *uniqueKey = baseInfo.uniqueKey;
        IMBiPod *iPod = [_deviceConnection getIPodByKey:uniqueKey];
        if (iPod != nil) { 
            [_logHandle writeInfoLog:@"IPod create success."];
            [_logHandle writeInfoLog:@"-----------------------------------------------"];
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"DeviceName: %@", iPod.deviceInfo.deviceName]];
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"Family: %@", iPod.deviceInfo.getIPodFamilyString]];
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"Serial Number: %@", iPod.deviceInfo.serialNumber]];
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"UDID: %@", iPod.deviceInfo.serialNumberForHashing]];
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"Version: %@", iPod.deviceInfo.productVersion]];
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"WifiConnection: %@", iPod.deviceInfo.isWifiConnect ? @"True" : @"False"]];
            [_logHandle writeInfoLog:[NSString stringWithFormat:@"Jailbreaked: %@", iPod.deviceInfo.isJailbreak ? @"True" : @"False"]];
            [_logHandle writeInfoLog:@"-----------------------------------------------"];
            
            //            [_processingQueue addOperationWithBlock:^(void){
            //                [self backupIPodCDB:iPod];
            //            }];
            
            IMBInformation *information = [[IMBInformation alloc] initWithiPod:iPod];
            IMBInformationManager *manager = [IMBInformationManager shareInstance];
            [manager.informationDic setObject:information forKey:iPod.uniqueKey];
            [information release];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:DeviceBtnChangeNotification object:[NSNumber numberWithBool:YES] userInfo:userInfo];
            
            if (_ipod == nil) {
                _ipod = [iPod retain];
                if (_ipod.deviceInfo.isIOSDevice) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHANGE_IPOD object:_ipod];
                }
                
                if(baseInfo.isConnected||[iPod.deviceHandle isKindOfClass:[NSString class]]){
                    NSLog(@"-------*********------");
                    //创建对应页面IMBDeviceMainPageViewController的IMBNavigationViewController 并保存在_deviceMainPageDic
                    if ([iPod.deviceHandle isKindOfClass:[AMDevice class]]) {
                        [self changeViewController:iPod.uniqueKey withIsDevice:YES withIsConnected:*(baseInfo.isConnected)];
                        
                    }else{
                        [self changeViewController:iPod.uniqueKey withIsDevice:YES withIsConnected:YES];
                    }
                }
                IMBNavigationViewController *navigationController = [_deviceMainPageDic objectForKey:@"Disconnected"];
                if (navigationController) {
                    IMBDisconnectViewController *disconnectController = (IMBDisconnectViewController *)(navigationController.currentViewController);
                    [disconnectController killTimer];
                }
            }else {
                IMBBaseViewController *viewController = [[IMBDeviceMainPageViewController alloc] initWithIpod:iPod withCategoryNodesEnum:Category_Summary withDelegate:self];
                if (viewController != nil) {
                    IMBNavigationViewController *navigationController = [[IMBNavigationViewController alloc] initWithRootViewController:viewController box:_deviceContentBox];
                    [_deviceMainPageDic setObject:navigationController forKey:iPod.uniqueKey];
                    [viewController setSearchFieldBtn:_searchFieldBtn];
                    //                    [(IMBDeviceMainPageViewController *)viewController loadDeviceContent];
                    [_hiddenView addSubview:viewController.view];
                    [viewController.view removeFromSuperview];
                    [viewController release];
                    [navigationController release];
                }
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_IPOD_CONTENT object:_ipod];
    });
}

//设备切换通知
- (void)deviceChange:(NSNotification *)notification {
    IMBBaseInfo *baseInfo = notification.object;
    if (baseInfo.connectType != general_Android && baseInfo.connectType != general_iCloud && baseInfo.connectType != general_Add_Content) {
        if ((_ipod && ![_ipod.uniqueKey isEqualToString:baseInfo.uniqueKey]) || _ipod == nil) {
            if (_ipod != nil) {
                [_ipod release];
                _ipod = nil;
            }
            _ipod = [[_deviceConnection getIPodByKey:baseInfo.uniqueKey] retain];
            if (_ipod.deviceInfo.isIOSDevice) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHANGE_IPOD object:_ipod];
            }
            if (_ipod) {
                [self changeViewController:_ipod.uniqueKey withIsDevice:YES withIsConnected:NO];
            }
        }
    }
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    if (_ipod) {
        IMBNavigationViewController *navigationController = [_deviceMainPageDic objectForKey:_ipod.uniqueKey];
        [(IMBBaseViewController *)navigationController.currentViewController doSearchBtn:searchStr withSearchBtn:searchBtn];
    }else{
        [searchBtn setHidden:YES];
    }
}

- (void)setMainTopLineView:(IMBBackgroundBorderView *)mainTopLineView {
    [mainTopLineView setHidden:YES];
    if (_ipod) {
        IMBNavigationViewController *navigationController = [_deviceMainPageDic objectForKey:_ipod.uniqueKey];
        [(IMBBaseViewController *)navigationController.currentViewController setMainTopLineView:mainTopLineView];
    }
}

#pragma mark - 跳转到iCloud登录界面
- (void)goToiCloudView {
    [_delegate changeViewController:iCloudModule];
}

- (void)dealloc {
    [_deviceMainPageDic release],_deviceMainPageDic = nil;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:DeviceConnectedNotification object:nil];
    [nc removeObserver:self name:DeviceDisConnectedNotification object:nil];
    [nc removeObserver:self name:DeviceChangeNotification object:nil];
    [nc removeObserver:self name:DeviceNeedPasswordNotification object:nil];
    [nc removeObserver:self name:DeviceIpodLoadCompleteNotification object:nil];
    [super dealloc];
}
@end
