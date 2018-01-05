//
//  IMBMainFrameButtonBarView.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBMainFrameButtonBarView.h"
#import "IMBSoftWareInfo.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
#import "SystemHelper.h"
#import "NSString+Category.h"
#import "IMBSkinPopoverWindowController.h"
#import "IMBAnimation.h"
#import "IMBNavPopSuperView.h"
//#import "JNWAnimatableWindow.h"

@implementation IMBMainFrameButtonBarView
@synthesize hasNavPopover = _hasNavPopover;
@synthesize functionButtonsArray = _functionButtonsArray;
@synthesize navPopWindow = _navPopWindow;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initwithFunctionModulBlock:(FunctionModuleBlock)block {
    if (self = [super init]) {
        _currentType = -1;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNavWindowState:) name:NOTIFY_MOUSEENTER_NAVWINDOW object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNavWindowState:) name:NOTIFY_MOUSEEXIT_NAVWINDOW object:nil];
        _buttonblock = [block copy];
        _functionButtonsArray = [[NSMutableArray array] retain];
        _navPopView = [[IMBPopOverView alloc] initWithFrame:NSMakeRect(50, 50, 150, 180)];
        [self loadButtons];
        _navPopSuperView = [[IMBNavPopSuperView alloc] initWithFrame:self.window.frame];
        [self preLoadNavWindow];
    }
    return self;
}

- (void)preLoadNavWindow {
    if (_navPopWindow == nil) {
        _navPopWindow = [[IMBNavPopoverWindowController alloc] initWithWindowNibName:@"IMBNavPopoverWindowController"];
    }
    _navPopWindow.window.viewsNeedDisplay = YES;
    [_navPopWindow.window orderOut:nil];
    [_navPopWindow setIsUP:NO];
    [_navPopWindow.window setAlphaValue:0.0];
}

- (void)applicationWillTerminate:(NSNotification*)notification {
    [self dealloc];
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea)
    {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    
    NSTrackingAreaOptions options = NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved ;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)loadButtons {
    IMBNavIconButton *itunesLibrary = [[IMBNavIconButton alloc] initWithFrame:NSMakeRect(0, 0, FunctionButtonWdith, FunctionButtonHight)];
    [itunesLibrary setDelegate:self];
    [itunesLibrary setHasPopover:YES];
    itunesLibrary.tag = iTunesLibraryModule;
    [itunesLibrary setCanDrawConcurrently:NO];
    [itunesLibrary setTarget:self];
    [itunesLibrary setAction:@selector(clickFunctionButton:)];
    [itunesLibrary setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_itunes"]];
    [itunesLibrary setSvgFileName:@"nav_itunes"];
    itunesLibrary->_navPopWindow = _navPopWindow;
    
    IMBNavIconButton *backup = [[IMBNavIconButton alloc] initWithFrame:NSMakeRect(0, 0, FunctionButtonWdith, FunctionButtonHight)];
    [backup setDelegate:self];
    [backup setHasPopover:YES];
    [backup setCanDrawConcurrently:NO];
    backup.tag = BackupModule;
    [backup setTarget:self];
    [backup setAction:@selector(clickFunctionButton:)];
    [backup setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_backup"]];
     [backup setSvgFileName:@"nav_backup"];
    backup->_navPopWindow = _navPopWindow;
    
    IMBNavIconButton *airBackupButton = [[IMBNavIconButton alloc] initWithFrame:NSMakeRect(0, 0, FunctionButtonWdith, FunctionButtonHight)];
    [airBackupButton setDelegate:self];
    [airBackupButton setHasPopover:YES];
    [airBackupButton setCanDrawConcurrently:NO];
    airBackupButton.tag = AirBackupModule;
    [airBackupButton setTarget:self];
    [airBackupButton setAction:@selector(clickFunctionButton:)];
    [airBackupButton setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_airbackup"]];
    [airBackupButton setSvgFileName:@"nav_airbackup"];
    airBackupButton->_navPopWindow = _navPopWindow;
    
    IMBNavIconButton *device = [[IMBNavIconButton alloc] initWithFrame:NSMakeRect(0, 0, FunctionButtonWdith, FunctionButtonHight)];
    [device setDelegate:self];
    [device setHasPopover:YES];
    [device setCanDrawConcurrently:NO];
    device.tag = DeviceModule;
    [device setTarget:self];
    [device setAction:@selector(clickFunctionButton:)];
    [device setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_device"]];
    [device setSvgFileName:@"nav_device"];
    device->_navPopWindow = _navPopWindow;
    
    IMBNavIconButton *androidbutton = [[IMBNavIconButton alloc] initWithFrame:NSMakeRect(0, 0, FunctionButtonWdith, FunctionButtonHight)];
    [androidbutton setDelegate:self];
    [androidbutton setHasPopover:YES];
    [androidbutton setCanDrawConcurrently:NO];
    androidbutton.tag = AndroidModule;
    [androidbutton setTarget:self];
    [androidbutton setAction:@selector(clickFunctionButton:)];
    [androidbutton setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_toios"]];
    [androidbutton setSvgFileName:@"nav_toios"];
    androidbutton->_navPopWindow = _navPopWindow;
    
    IMBNavIconButton *icloud = [[IMBNavIconButton alloc] initWithFrame:NSMakeRect(0, 0, FunctionButtonWdith, FunctionButtonHight)];
    [icloud setDelegate:self];
    [icloud setHasPopover:YES];
    [icloud setCanDrawConcurrently:NO];
    icloud.tag = iCloudModule;
    [icloud setTarget:self];
    [icloud setAction:@selector(clickFunctionButton:)];
    [icloud setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_icloud"]];
    [icloud setSvgFileName:@"nav_icloud"];
    icloud->_navPopWindow = _navPopWindow;
    
    IMBNavIconButton *videoDownload = [[IMBNavIconButton alloc] initWithFrame:NSMakeRect(0, 0, FunctionButtonWdith, FunctionButtonHight)];
    BOOL videodid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"VideoSpot"] boolValue];
    [videoDownload setHasSpot:!videodid];
    [videoDownload setDelegate:self];
    [videoDownload setHasPopover:YES];
    [videoDownload setCanDrawConcurrently:NO];
    videoDownload.tag = VideoDownloadModule;
    [videoDownload setTarget:self];
    [videoDownload setAction:@selector(clickFunctionButton:)];
    [videoDownload setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_download"]];
    [videoDownload setSvgFileName:@"nav_download"];
    videoDownload->_navPopWindow = _navPopWindow;
    
    IMBNavIconButton *skinbutton = [[IMBNavIconButton alloc] initWithFrame:NSMakeRect(0, 0, FunctionButtonWdith, FunctionButtonHight)];
    BOOL did = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SkinSpot"] boolValue];
    [skinbutton setHasSpot:!did];
    [skinbutton setDelegate:self];
    [skinbutton setHasPopover:YES];
    [skinbutton setCanDrawConcurrently:NO];
    skinbutton.tag = SkinModule;
    [skinbutton setTarget:self];
    [skinbutton setAction:@selector(clickFunctionButton:)];
    [skinbutton setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_skin"]];
    [skinbutton setSvgFileName:@"nav_skin"];
    skinbutton->_navPopWindow = _navPopWindow;
    
    [_functionButtonsArray addObject:itunesLibrary];
    [_functionButtonsArray addObject:backup];
    [_functionButtonsArray addObject:airBackupButton];
    [_functionButtonsArray addObject:device];
    [_functionButtonsArray addObject:androidbutton];
    [_functionButtonsArray addObject:icloud];
    [_functionButtonsArray addObject:videoDownload];
    [_functionButtonsArray addObject:skinbutton];
    [itunesLibrary release];
    [backup release];
    [icloud release];
    [device release];
    [videoDownload release];
    [skinbutton release];
    [androidbutton release];
    
    for (IMBNavIconButton *button in _functionButtonsArray) {
        [button setFrame:NSMakeRect(OriginPointX + button.tag*(FunctionButtonWdith+SeparationWidth), 0, FunctionButtonWdith, FunctionButtonHight)];
        [self addSubview:button];
    }
    
    [self setFrameSize:NSMakeSize(OriginPointX+[_functionButtonsArray count]*FunctionButtonWdith+([_functionButtonsArray count]-1)*SeparationWidth, FunctionButtonHight)];
    
    [self clickFunctionButton:videoDownload];
    //默认选中device
    [device setIsSelected:YES];
    [self clickFunctionButton:device];
    
}

//响应
- (void)clickFunctionButton:(IMBNavIconButton *)sender {
    _selectType = (FunctionType)sender.tag;
    IMBSoftWareInfo *softwareInfo = [IMBSoftWareInfo singleton];
    if (_selectType == iTunesLibraryModule) {
        [softwareInfo setSelectModular:@"iTunes Library"];
    }else if (_selectType == BackupModule) {
        [softwareInfo setSelectModular:@"Backup Manager"];
    }else if (_selectType == AirBackupModule) {
        [softwareInfo setSelectModular:@"Air Backup"];
    }else if (_selectType == DeviceModule) {
        [softwareInfo setSelectModular:@"Device Manager"];
    }else if (_selectType == AndroidModule) {
        [softwareInfo setSelectModular:@"iOS Mover"];
    }else if (_selectType == iCloudModule) {
        [softwareInfo setSelectModular:@"iCloud Manager"];
    }
    [sender setIsSelected:YES];
    for (IMBNavIconButton *button in _functionButtonsArray) {
        if (button != sender) {
            [button setIsSelected:NO];
        }
    }
    if (_buttonblock != nil) {
        _buttonblock(_selectType);
    }
}

- (void)changeSkin:(NSNotification *)notification {
    for (IMBNavIconButton *button in _functionButtonsArray) {
        if (button.tag == iTunesLibraryModule) {
            [button setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_itunes"]];
        }else if (button.tag == BackupModule) {
            [button setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_backup"]];
        }else if (button.tag == iCloudModule) {
            [button setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_icloud"]];
        }else if (button.tag == DeviceModule) {
            [button setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_device"]];
        }else if (button.tag == SkinModule) {
            [button setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_skin"]];
        }else if (button.tag == VideoDownloadModule) {
            [button setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_download"]];
        }else if (button.tag == AndroidModule) {
            [button setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_toios"]];
        }else if (button.tag == AirBackupModule) {
            [button setMouseEnteredImage:nil mouseExitImage:nil mouseDownImage:[StringHelper imageNamed:@"nav_airbackup"]];
        }
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [super mouseEntered:theEvent];
    if (_timer && _timer.isValid) {
        [_timer invalidate];
        [_timer release];
        _timer = nil;
    }
    _mouseOver = YES;
    _isTimer = YES;
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
    _currentType = -1;
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
     BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
    if (_timer && _timer.isValid) {
        [_timer invalidate];
        [_timer release];
        _timer = nil;
    }
    if (!inner) {
        _mouseOver = NO;
        [self closeNavPopover:nil];
        _hasNavPopover = NO;
    }else {
        _mouseOver = NO;
    }
    _isTimer = NO;
    [_navPopWindow close];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [_navPopWindow.window setAlphaValue:0.0];
    [_navPopWindow close];
    [super mouseDown:theEvent];
}

- (void)mouseMoved:(NSEvent *)theEvent {
    //有弹出窗口就不显示提示窗口；
    NSView *view = nil;
    for (NSView *subView in ((NSView *)self.window.contentView).subviews) {
        if ([subView isMemberOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]) {
            view = subView;
            break;
        }else if ([subView.identifier isEqualToString:@"Guide"] && !subView.isHidden) {
            view = subView;
            break;
        }
    }
    if (view && view.subviews.count > 0) {
        return;
    }
    _lastFuntionType = [self calculateCoordinatePosition:theEvent];
    if (_mouseOver) {
        if (_isTimer || _navPopWindow.window.alphaValue == 0.0) {
            _isTimer = NO;
            if (_timer && _timer.isValid) {
                [_timer invalidate];
                [_timer release];
                _timer = nil;
            }
            _timer = [[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerAction:) userInfo:theEvent repeats:NO] retain];
            _isShowing = YES;
        }else {
            if (!_isShowing) {
                if (_timer && _timer.isValid) {
                    [_timer invalidate];
                    [_timer release];
                    _timer = nil;
                }
                [self showPromptWindow:theEvent];
            }
        }
    }
}

- (void)timerAction:(NSTimer *)timer {
    NSEvent *theEvent = timer.userInfo;
    [self showPromptWindow:theEvent];
    _isShowing = NO;
}

- (void)showPromptWindow:(NSEvent *)theEvent {
    NSPoint localPoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
    NSPoint point;
    point.x = self.window.frame.origin.x + self.frame.origin.x ;
    point.y = self.window.frame.origin.y + self.window.frame.size.height - 50;
    
    BOOL isShow = NO;
    FunctionType funtionType = _currentType;
    if (localPoint.x <= OriginPointX + FunctionButtonWdith + SeparationWidth/2 && localPoint.x >= OriginPointX) {
        isShow = YES;
        point.x += OriginPointX + FunctionButtonWdith/2;
        funtionType = iTunesLibraryModule;
    }else if (localPoint.x <= OriginPointX + FunctionButtonWdith*2 + SeparationWidth*3/2 && localPoint.x > OriginPointX + FunctionButtonWdith + SeparationWidth/2){
        isShow = YES;
        point.x += OriginPointX + FunctionButtonWdith*3/2 + SeparationWidth;
        funtionType = BackupModule;
    }else if (localPoint.x <= OriginPointX + FunctionButtonWdith*3 + SeparationWidth*5/2 && localPoint.x > OriginPointX + FunctionButtonWdith*2 + SeparationWidth*3/2){
        isShow = YES;
        point.x += OriginPointX + FunctionButtonWdith*5/2 + SeparationWidth*2;
        funtionType = AirBackupModule;
    }else if (localPoint.x <= OriginPointX + FunctionButtonWdith*4 + SeparationWidth*7/2 && localPoint.x > OriginPointX + FunctionButtonWdith*3 + SeparationWidth*5/2){
        isShow = YES;
        point.x += OriginPointX + FunctionButtonWdith*7/2 + SeparationWidth*3;
        funtionType = DeviceModule;
    }else if (localPoint.x <= OriginPointX + FunctionButtonWdith*5 + SeparationWidth*9/2 && localPoint.x > OriginPointX + FunctionButtonWdith*4 + SeparationWidth*7/2){
        isShow = YES;
        point.x += OriginPointX + FunctionButtonWdith*9/2 + SeparationWidth*4;
        funtionType = AndroidModule;
    }else if (localPoint.x <= OriginPointX + FunctionButtonWdith*6 + SeparationWidth*11/2 && localPoint.x > OriginPointX + FunctionButtonWdith*5 + SeparationWidth*9/2){
        isShow = YES;
        point.x += OriginPointX + FunctionButtonWdith*11/2 + SeparationWidth*5;
        funtionType = iCloudModule;
    }else if (localPoint.x <= OriginPointX + FunctionButtonWdith*7 + SeparationWidth*13/2 && localPoint.x > OriginPointX + FunctionButtonWdith*6 + SeparationWidth*11/2){
        isShow = YES;
        point.x += OriginPointX + FunctionButtonWdith*13/2 + SeparationWidth*6;
        funtionType = VideoDownloadModule;
    }else if (localPoint.x <= OriginPointX + FunctionButtonWdith*8 + SeparationWidth*15/2 && localPoint.x > OriginPointX + FunctionButtonWdith*7 + SeparationWidth*13/2){
        isShow = YES;
        point.x += OriginPointX + FunctionButtonWdith*15/2 + SeparationWidth*7;
        funtionType = SkinModule;
    }
    
    if (isShow && (funtionType != _currentType || _navPopWindow.window.alphaValue == 0.0)) {
        NSLog(@"funtionType:%d  _selectType:%d  _lastFuntionType:%d",funtionType,_selectType,_lastFuntionType);
        if (funtionType != _selectType && _lastFuntionType != _selectType) {
            if (funtionType != _lastFuntionType) {
//                _lastFuntionType = funtionType;
//                if (_timer && _timer.isValid) {
//                    [_timer invalidate];
//                    [_timer release];
//                    _timer = nil;
//                }
//                _timer = [[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerAction:) userInfo:theEvent repeats:NO] retain];
//                _isShowing = YES;
//                return;
                point.x = self.window.frame.origin.x + self.frame.origin.x ;
                if (_lastFuntionType == iTunesLibraryModule) {
                    point.x += OriginPointX + FunctionButtonWdith/2;
                }else if (_lastFuntionType == BackupModule){
                    point.x += OriginPointX + FunctionButtonWdith*3/2 + SeparationWidth;
                }else if (_lastFuntionType == AirBackupModule){
                    point.x += OriginPointX + FunctionButtonWdith*5/2 + SeparationWidth*2;
                }else if (_lastFuntionType == DeviceModule) {
                    point.x += OriginPointX + FunctionButtonWdith*7/2 + SeparationWidth*3;
                }else if (_lastFuntionType == AndroidModule){
                    point.x += OriginPointX + FunctionButtonWdith*9/2 + SeparationWidth*4;
                }else if (_lastFuntionType == iCloudModule){
                    point.x += OriginPointX + FunctionButtonWdith*11/2 + SeparationWidth*5;
                }else if (_lastFuntionType == VideoDownloadModule){
                    point.x += OriginPointX + FunctionButtonWdith*13/2 + SeparationWidth*6;
                }else if (_lastFuntionType == SkinModule){
                    point.x += OriginPointX + FunctionButtonWdith*15/2 + SeparationWidth*7;
                }
            }
//                _currentType = funtionType;
            _currentType = _lastFuntionType;
            if (_navPopWindow && _navPopWindow.window.alphaValue >= 1.0) {
                _navPopWindow.window.viewsNeedDisplay = YES;
                [_navPopWindow.window setAlphaValue:1.0];
                [_navPopWindow showWindow:self];
                [_navPopWindow setCurrentType:_currentType];
                NSRect newRect = NSMakeRect(point.x - _navPopWindow.window.frame.size.width / 2.0, point.y - _navPopWindow.window.frame.size.height, _navPopWindow.window.frame.size.width, _navPopWindow.window.frame.size.height);
                [_navPopWindow.window setFrame:newRect display:YES animate:YES];
            }else {
                if (_navPopWindow == nil) {
                    _navPopWindow = [[IMBNavPopoverWindowController alloc] initWithWindowNibName:@"IMBNavPopoverWindowController"];
                }
                
                _navPopWindow.window.viewsNeedDisplay = YES;
                [_navPopWindow.window orderOut:nil];
                [_navPopWindow setCurrentType:_currentType];
                [_navPopWindow setIsUP:NO];
                [_navPopWindow.window setFrame:NSMakeRect(point.x - _navPopWindow.window.frame.size.width / 2.0, point.y - _navPopWindow.window.frame.size.height - 50, _navPopWindow.window.frame.size.width, _navPopWindow.window.frame.size.height) display:NO];
                [_navPopWindow.window setAlphaValue:0.0];
                
                __block NSRect newRect;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
                        context.duration = 0.3;
                        newRect = NSMakeRect(point.x - _navPopWindow.window.frame.size.width / 2.0, point.y - _navPopWindow.window.frame.size.height, _navPopWindow.window.frame.size.width, _navPopWindow.window.frame.size.height);
                        [[_navPopWindow.window animator] setFrame:newRect display:YES];
                        [[_navPopWindow.window animator] setAlphaValue:1.0];
                    } completionHandler:^{
                        
                    }];
                    [_navPopWindow.window makeKeyAndOrderFront:nil];
                    _navPopWindow.window.viewsNeedDisplay = YES;
                    [_navPopWindow showWindow:self];
                });
            }
        }else {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSRect newRect = NSMakeRect(_navPopWindow.window.frame.origin.x , _navPopWindow.window.frame.origin.y - 50, _navPopWindow.window.frame.size.width, _navPopWindow.window.frame.size.height);
//                [_navPopWindow.window setFrame:newRect display:NO];
            [_navPopWindow.window setAlphaValue:0.0];
            [_navPopWindow close];
//            });
        }
    }
}

- (FunctionType)calculateCoordinatePosition:(NSEvent *)theEvent {
    NSPoint localPoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
    FunctionType funtionType = -1;
    if (localPoint.x <= OriginPointX + FunctionButtonWdith + SeparationWidth/2 && localPoint.x >= OriginPointX) {
        funtionType = iTunesLibraryModule;
    }else if (localPoint.x <= OriginPointX + FunctionButtonWdith*2 + SeparationWidth*3/2 && localPoint.x > OriginPointX + FunctionButtonWdith + SeparationWidth/2){
        funtionType = BackupModule;
    }else if (localPoint.x <= OriginPointX + FunctionButtonWdith*3 + SeparationWidth*5/2 && localPoint.x > OriginPointX + FunctionButtonWdith*2 + SeparationWidth*3/2){
        funtionType = AirBackupModule;
    }else if (localPoint.x <= OriginPointX + FunctionButtonWdith*4 + SeparationWidth*7/2 && localPoint.x > OriginPointX + FunctionButtonWdith*3 + SeparationWidth*5/2){
        funtionType = DeviceModule;
    }else if (localPoint.x <= OriginPointX + FunctionButtonWdith*5 + SeparationWidth*9/2 && localPoint.x > OriginPointX + FunctionButtonWdith*4 + SeparationWidth*7/2){
        funtionType = AndroidModule;
    }else if (localPoint.x <= OriginPointX + FunctionButtonWdith*6 + SeparationWidth*11/2 && localPoint.x > OriginPointX + FunctionButtonWdith*5 + SeparationWidth*9/2){
        funtionType = iCloudModule;
    }else if (localPoint.x <= OriginPointX + FunctionButtonWdith*7 + SeparationWidth*13/2 && localPoint.x > OriginPointX + FunctionButtonWdith*6 + SeparationWidth*11/2){
        funtionType = VideoDownloadModule;
    }else if (localPoint.x <= OriginPointX + FunctionButtonWdith*8 + SeparationWidth*15/2 && localPoint.x > OriginPointX + FunctionButtonWdith*7 + SeparationWidth*13/2){
        funtionType = SkinModule;
    }
    return funtionType;
}

- (void)closeNavPopover:(id)sender {
    if (!_mouseOver && !_mouseOverWindow) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(_mouseOver || _mouseOverWindow){
                return ;
            }
//            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//                context.duration = 0.0;
                NSRect newRect = NSMakeRect(_navPopWindow.window.frame.origin.x , _navPopWindow.window.frame.origin.y - 50, _navPopWindow.window.frame.size.width, _navPopWindow.window.frame.size.height);
//                [[_navPopWindow.window animator] setFrame:newRect display:YES];
//                [[_navPopWindow.window animator] setAlphaValue:0.0];
            [_navPopWindow.window setFrame:newRect display:NO];
            [_navPopWindow.window setAlphaValue:0.0];
            [_navPopWindow close];
//            } completionHandler:^{
//                
//            }];
        });
    }
}

- (void)changeNavWindowState:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    if ([dic.allKeys containsObject:@"state"]) {
        NSString *str = [dic objectForKey:@"state"];
        if ([str isEqualToString:@"mouseEnter"]) {
            _mouseOverWindow = YES;
        }else if ([str isEqualToString:@"mouseExite"]) {
            _mouseOverWindow = NO;
            [self closeNavPopover:nil];
            _hasNavPopover = NO;
        }
    }
}

- (void)dealloc{
    if (_navPopWindow != nil) {
        [_navPopWindow close];
        [_navPopWindow release];
        _navPopWindow = nil;
    }
    if (_timer && _timer.isValid) {
        [_timer invalidate];
        [_timer release];
        _timer = nil;
    }
    
    [_functionButtonsArray release],_functionButtonsArray = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_MOUSEENTER_NAVWINDOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_MOUSEEXIT_NAVWINDOW object:nil];
    Block_release(_buttonblock);
    [super dealloc];
}
@end

@implementation FunctionTypeEnum
+(NSString *)functionTypeToString:(FunctionType)type
{
    switch (type) {
        case iTunesLibraryModule:
            return @"iTunesLibraryModule";
        case BackupModule:
            return @"BackupModule";
        case iCloudModule:
            return @"iCloudModule";
        case DeviceModule:
            return @"DeviceModule";
        case SkinModule:
            return @"SkinMoudle";
        case VideoDownloadModule:
            return @"VideoDownloadModule";
        case AndroidModule:
            return @"AndroidModule";
        case AirBackupModule:
            return @"AirBackupModule";
        default:
            return @"DeviceModule";
    }
}

@end

