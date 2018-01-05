//
//  IMBAndroidViewController.m
//  
//
//  Created by JGehry on 7/5/17.
//
//

#import "IMBAndroidViewController.h"
#import "IMBNavigationViewController.h"
#import "IMBAndroidDisconnectViewController.h"
#import "IMBBackgroundBorderView.h"
#import "IMBAndroidMainPageViewController.h"
#import "IMBNotificationDefine.h"
#import "IMBMainWindowController.h"

@interface IMBAndroidViewController ()

@end

@implementation IMBAndroidViewController

- (id)initWithDelegate:(id)delegete {
    if (self = [super init]) {
        _delegate = delegete;
        _nc = [NSNotificationCenter defaultCenter];
        [self addNotification];
        [self performSelectorOnMainThread:@selector(connectToAndroid) withObject:nil waitUntilDone:NO];
        _androidDeviceMainPageDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)connectToAndroid {
    _devAccessManager = [[DeviceAccessManager alloc] init];
    NSLog(@"%@", _devAccessManager);
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    if (_openUSBViewController != nil) {
        [_openUSBViewController release];
        _openUSBViewController = nil;
    }
    [_nc removeObserver:self name:Andriod_Device_USB_Message object:nil];
    [_nc removeObserver:self name:Andriod_Device_Connect object:nil];
    [_nc removeObserver:self name:Andriod_Device_Connect_Complete object:nil];
    [_nc removeObserver:self name:Andriod_Device_Connect_Software_Conflict object:nil];
    [_nc removeObserver:self name:Andriod_Device_Connect_Unauthorized object:nil];
    [_nc removeObserver:self name:Andriod_Device_Connect_Debugging object:nil];
    [_nc removeObserver:self name:Andriod_Device_Connect_Error object:nil];
    [_nc removeObserver:self name:Andriod_Device_Disconnect object:nil];
    [_nc removeObserver:self name:Andriod_Device_Connect_Media_Device object:nil];
    [_nc removeObserver:self name:Andriod_Device_ApkInstall object:nil];
    [_nc removeObserver:self name:Andriod_Device_ApkRunning object:nil];
    [_devAccessManager release],_devAccessManager = nil;
    [_androidDeviceMainPageDic release],_androidDeviceMainPageDic = nil;
    [super dealloc];
#endif
}

- (void)awakeFromNib {
    [((IMBBackgroundBorderView *)self.view) setIsGradientWithCornerPart4:YES];
    [((IMBBackgroundBorderView *)self.view) setXRadius:5.0 YRadius:5.0];
    [self changeViewController:@"AndroidDisconnected" withIsDevice:NO];
    [_searchFieldBtn setHidden:YES];
}

//切换视图
- (void)changeViewController:(NSString *)type withIsDevice:(BOOL)isDevice {
    IMBNavigationViewController *navigationController = [_androidDeviceMainPageDic objectForKey:type];
    IMBBaseViewController *viewController = nil;
    if (!navigationController) {
        if (isDevice) {
            viewController = [[IMBAndroidMainPageViewController alloc] initWithAndroid:_android withCategoryNodesEnum:Category_Summary withDelegate:self];
        }else {
            if ([type isEqualToString: @"AndroidDisconnected"]) {
                viewController = [[IMBAndroidDisconnectViewController alloc] init];
            }
        }

        if (viewController != nil && ![StringHelper stringIsNilOrEmpty:type]) {
            IMBNavigationViewController *navigationController = [[IMBNavigationViewController alloc] initWithRootViewController:viewController box:_deviceContentBox];
            [_androidDeviceMainPageDic setObject:navigationController forKey:type];
            [viewController setSearchFieldBtn:_searchFieldBtn];
            [self popViewController:viewController.view];
            
            [viewController release];
            [navigationController release];
        }
    }else{
        viewController = (IMBBaseViewController *)navigationController.currentViewController;
        [viewController setSearchFieldBtn:_searchFieldBtn];
        [self popViewController:viewController.view];
    }
    if ([(IMBMainWindowController *)_delegate curFunctionType] == AndroidModule) {
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

- (void)ShowWindowControllerCategory {
    if (_android) {
        IMBNavigationViewController *navigationController = [_androidDeviceMainPageDic objectForKey:_android.deviceInfo.devSerialNumber];
        if ([(IMBBaseViewController *)navigationController.currentViewController category] == Category_Summary) {
            [_searchFieldBtn setHidden:YES];
        }else{
            [_searchFieldBtn setHidden:NO];
        }
    }else{
        [_searchFieldBtn setHidden:YES];
    }
}

- (void)doSearchBtn:(NSString *)searchStr withSearchBtn:(IMBSearchView *)searchBtn{
    if (_android) {
        IMBNavigationViewController *navigationController = [_androidDeviceMainPageDic objectForKey:_android.deviceInfo.devSerialNumber];
        [(IMBBaseViewController *)navigationController.currentViewController doSearchBtn:searchStr withSearchBtn:searchBtn];
    }else{
        [searchBtn setHidden:YES];
    }
}

- (void)setMainTopLineView:(IMBBackgroundBorderView *)mainTopLineView {
    if (_android) {
        IMBNavigationViewController *navigationController = [_androidDeviceMainPageDic objectForKey:_android.deviceInfo.devSerialNumber];
        [(IMBBaseViewController *)navigationController.currentViewController setMainTopLineView:mainTopLineView];
    }
}

#pragma mark - 注册通知及实现方法
- (void)addNotification {
    [_nc addObserver:self selector:@selector(doAndriodDeviceUSBMessage:) name:Andriod_Device_USB_Message object:nil];
    [_nc addObserver:self selector:@selector(doAndriodDeviceConnect:) name:Andriod_Device_Connect object:nil];
    [_nc addObserver:self selector:@selector(doAndriodDeviceConnectComplete:) name:Andriod_Device_Connect_Complete object:nil];
    [_nc addObserver:self selector:@selector(doAndriodDeviceConnectSoftwareConflict:) name:Andriod_Device_Connect_Software_Conflict object:nil];//软件连接冲突
    [_nc addObserver:self selector:@selector(doAndriodDeviceConnectUnauthorized:) name:Andriod_Device_Connect_Unauthorized object:nil];//信任
    [_nc addObserver:self selector:@selector(doAndriodDeviceConnectMediaDevice:) name:Andriod_Device_Connect_Media_Device object:nil];//MTP模式
    [_nc addObserver:self selector:@selector(doAndriodDeviceConnectDebugging:) name:Andriod_Device_Connect_Debugging object:nil];//Debug 模式
    [_nc addObserver:self selector:@selector(doAndriodDeviceConnectError:) name:Andriod_Device_Connect_Error object:nil];
    [_nc addObserver:self selector:@selector(doAndriodDeviceDisconnect:) name:Andriod_Device_Disconnect object:nil];
    [_nc addObserver:self selector:@selector(doAndriodDeviceApkInstall:) name:Andriod_Device_ApkInstall object:nil];
    [_nc addObserver:self selector:@selector(doAndriodDeviceApkRunning:) name:Andriod_Device_ApkRunning object:nil];
}

- (void)doAndriodDeviceUSBMessage:(NSNotification *)notification {
    //提示用户有安卓设备连接  NavButton_MoveToiOS_Tips
    NSLog(@"doAndriodDeviceUSBMessage");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![IMBSoftWareInfo singleton].isLoadGuideView) {
            [_delegate androidConnectPopoverView];
        }
    });
}

- (void)doAndriodDeviceConnect:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_android == nil) {
            [self changeViewController:@"AndroidDisconnected" withIsDevice:NO];
            IMBNavigationViewController *navigationController = [_androidDeviceMainPageDic objectForKey:@"AndroidDisconnected"];
            if (navigationController) {
                IMBAndroidDisconnectViewController *disconnectController = (IMBAndroidDisconnectViewController *)(navigationController.currentViewController);
                NSString *deviceName = [notification.object valueForKey:@"deviceName"];
                [disconnectController loadingConnectingAndConnectedCompeleteLaguages:deviceName];
                [disconnectController addTimer];
            }
        }
    });
}

- (void)doAndriodDeviceConnectComplete:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        IMBAndroid *android = notification.object;
        if (_android == nil && android != nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:DeviceBtnChangeNotification object:[NSNumber numberWithBool:YES] userInfo:[notification userInfo]];
            _android = [android retain];
            //创建对应页面IMBAndroidMainPageViewController的IMBNavigationViewController 并保存在_deviceMainPageDic
            [self changeViewController:android.deviceInfo.devSerialNumber withIsDevice:YES];
            //注销未连接页面动画
            IMBNavigationViewController *navigationController = [_androidDeviceMainPageDic objectForKey:@"AndroidDisconnected"];
            if (navigationController) {
                IMBAndroidDisconnectViewController *disconnectController = (IMBAndroidDisconnectViewController *)(navigationController.currentViewController);
                [disconnectController loadingConnectingAndConnectedCompeleteLaguages:_android.deviceInfo.devName];
                [disconnectController killTimer];
            }
        }

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [_android sendAction:@"Connected" ResultText:0 TargetWord:@"Defalut"];
        });
        IMBLogManager *logHandle = [IMBLogManager singleton];
        if (_android == android) {//当前连接安卓设备设备信息
            [logHandle writeInfoLog:@"----------Current Device Baseinfo create success.-------------"];
        }else {//其他安卓设备的信息
            [logHandle writeInfoLog:@"----------Device Baseinfo create success.-------------"];
        }
        [logHandle writeInfoLog:[NSString stringWithFormat:@"DeviceName: %@", android.deviceInfo.devName]];
        [logHandle writeInfoLog:[NSString stringWithFormat:@"Device Model: %@", android.deviceInfo.devModel]];
        [logHandle writeInfoLog:[NSString stringWithFormat:@"Serial Number: %@", android.deviceInfo.devSerialNumber]];
        [logHandle writeInfoLog:[NSString stringWithFormat:@"Device Version : %@", android.deviceInfo.devVersion]];
        if (android.deviceInfo.storageArr.count > 0) {
            StorageInfo *storageInfo =[android.deviceInfo.storageArr objectAtIndex:0];
            [logHandle writeInfoLog:[NSString stringWithFormat:@"Device AvailableSize: %lld", storageInfo.availableSize]];
            [logHandle writeInfoLog:[NSString stringWithFormat:@"Device TotalSize: %lld", storageInfo.totalSize]];
            [logHandle writeInfoLog:[NSString stringWithFormat:@"Device StorageKind: %@", storageInfo.storageKind]];
        }
    });
}

- (void)doAndriodDeviceConnectSoftwareConflict:(NSNotification *)notification {
    sleep(2);
    IMBAdbManager *adbManager = [IMBAdbManager singleton];
    [adbManager runADBCommand:[adbManager killServer]];
    NSString *str = [adbManager runADBCommand:[adbManager startServer]];
    if ([str rangeOfString:@"* daemon started successfully *"].location != NSNotFound) {
        [_devAccessManager deviceConnected:notification.userInfo];
    }else {
        [self doAndriodDeviceConnectSoftwareConflict:notification];
    }
}

- (void)doAndriodDeviceConnectUnauthorized:(NSNotification *)notification {
    IMBAdbManager *adbManager = [IMBAdbManager singleton];
    [adbManager runADBCommand:[adbManager killServer]];
    [adbManager runADBCommand:[adbManager startServer]];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSView *view = nil;
        for (NSView *subView in ((NSView *)_mainWindow.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        if (view) {
            [view setHidden:NO];
            [_androidAlertViewController showAlertTrustView:view withDic:notification.userInfo withEnum:1];
        }
    });
}

- (void)doAndriodDeviceConnectMediaDevice:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSView *view = nil;
        for (NSView *subView in ((NSView *)_mainWindow.contentView).subviews) {
            if ([subView isKindOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]) {
                view = subView;
                break;
            }
        }
        if (view) {
            [view setHidden:NO];
            [_androidAlertViewController showMediaDeviceMTPAlertView:view withDic:notification.userInfo];
        }
    });
}

- (void)doAndriodDeviceConnectDebugging:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_openUSBViewController != nil) {
            [_openUSBViewController release];
            _openUSBViewController = nil;
        }
        _openUSBViewController = [[IMBOpenUSBDeugViewController alloc] initWithNibName:@"IMBOpenUSBDeugViewController" bundle:nil];
        [_deviceContentBox setContentView:_openUSBViewController.view];
        CABasicAnimation *animation = [IMBAnimation opacityChange_Animation:0 fromValue:@0.2 toValue:@1.0 durTimes:2];
        [_openUSBViewController.view setWantsLayer:YES];
        [_openUSBViewController.view.layer addAnimation:animation forKey:@""];
    });
}

- (void)doAndriodDeviceConnectError:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        //安卓设备连接错误消息
        NSView *view = nil;
        for (NSView *subView in ((NSView *)_mainWindow.contentView).subviews) {
            if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]&& [subView.subviews count] == 0) {
                view = subView;
                break;
            }
        }
        if (view) {
            [view setHidden:NO];
            NSString *errorStr = [notification object];
            if ([IMBHelper stringIsNilOrEmpty:errorStr]) {
                errorStr = CustomLocalizedString(@"UNABLE_READ_DEVICEINFO", nil);
            }
            [_androidAlertViewController showAlertText:errorStr OKButton:CustomLocalizedString(@"Button_Ok", nil) SuperView:view];
        }
    });
}

- (void)doAndriodDeviceDisconnect:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *servailNumber = notification.object;
        if (servailNumber != nil) {
            if (_android != nil) {
                [_android release];
                _android = nil;
            }
            IMBNavigationViewController *navigationController = [_androidDeviceMainPageDic objectForKey:@"AndroidDisconnected"];
            if (navigationController) {
                IMBAndroidDisconnectViewController *disconnectController = (IMBAndroidDisconnectViewController *)(navigationController.currentViewController);
                for (NSView *view in [_deviceContentBox subviews]) {
                    if (view == disconnectController.view) {
                        double delayInSeconds = 3.0;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            NSString *msgStr = CustomLocalizedString(@"AndroidNoConnect", nil);
                            [disconnectController setPromptTextString:msgStr];
                            [disconnectController killTimer];
                            [disconnectController setTimerNil];
                        });
                        break;
                    }else{
                        NSString *msgStr = CustomLocalizedString(@"AndroidNoConnect", nil);
                        [disconnectController setPromptTextString:msgStr];
                    }
                }
            }
            [self changeViewController:@"AndroidDisconnected" withIsDevice:NO];
            if ([_androidDeviceMainPageDic.allKeys containsObject:servailNumber]) {
                if (servailNumber) {
                    [_androidDeviceMainPageDic removeObjectForKey:servailNumber];
                }
            }
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      servailNumber, @"UniqueKey"
                                      , nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:DeviceBtnChangeNotification object:[NSNumber numberWithBool:NO] userInfo:userInfo];
        }
    });
}

- (void)doAndriodDeviceApkInstall:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        IMBNavigationViewController *navigationController = [_androidDeviceMainPageDic objectForKey:@"AndroidDisconnected"];
        if (navigationController) {
            IMBAndroidDisconnectViewController *disconnectController = (IMBAndroidDisconnectViewController *)(navigationController.currentViewController);
            NSString *msgStr = CustomLocalizedString(@"Connecting_Install_Apk", nil);
            [disconnectController setPromptTextString:msgStr];
        }

    });
}

- (void)doAndriodDeviceApkRunning:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        IMBNavigationViewController *navigationController = [_androidDeviceMainPageDic objectForKey:@"AndroidDisconnected"];
        if (navigationController) {
            IMBAndroidDisconnectViewController *disconnectController = (IMBAndroidDisconnectViewController *)(navigationController.currentViewController);
            NSString *msgStr = CustomLocalizedString(@"Connecting_Start_Apk", nil);
            [disconnectController setPromptTextString:msgStr];
        }

    });
}

#pragma mark - 信任窗口按钮事件
- (void)trustBtnOperation:(id)sender {
    NSDictionary *dict = (NSDictionary *)sender;
    [_devAccessManager performSelector:@selector(isUnauthorizedDevice:) withObject:dict afterDelay:0.2];
}

#pragma mark - 暂停安卓设备连接（不在move to ios界面时）
- (void)pauseAndroidLoad {
    if (_devAccessManager != nil) {
        [_devAccessManager setIsDevicePause:YES];
    }
}

- (void)continueAndroidLoad {
    if (_devAccessManager != nil) {
        [_devAccessManager setIsDevicePause:NO];
    }
}

@end
