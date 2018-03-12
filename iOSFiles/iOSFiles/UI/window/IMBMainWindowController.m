//
//  IMBMainWindowController.m
//  AnyTrans
//
//  Created by LuoLei on 16-7-13.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBMainWindowController.h"
#import "IMBNoTitleBarWindow.h"
#import "StringHelper.h"
#import "IMBDeviceViewController.h"
#import "IMBDeviceConnection.h"
#import "IMBiPod.h"
#import "IMBDevViewController.h"
#import "IMBCommonDefine.h"
#import "IMBWhiteView.h"


@interface IMBMainWindowController ()<NSPopoverDelegate>

@end

@implementation IMBMainWindowController


- (id)initWithWindowNibName:(NSString *)windowNibName {
    if (self = [super initWithWindowNibName:windowNibName]) {
     
    }
    return self;
}

/**
 *  初始化操作
 */
- (void)awakeFromNib {
//    NSRect screenRect = [NSScreen mainScreen].frame;
//    [self.window setMaxSize:screenRect.size];
    [_whiteView setBackgroundColor:COLOR_MAIN_WINDOW_BG];
    [self.window setContentSize:NSMakeSize(592, 430)];

    [(NSView *)((IMBNoTitleBarWindow *)self.window).maxAndminView setFrameOrigin:NSMakePoint(10,NSHeight(_topView.frame) - 22)];
    [[(IMBNoTitleBarWindow *)self.window closeButton] setAction:@selector(closeWindow:)];
    [[(IMBNoTitleBarWindow *)self.window closeButton] setTarget:self];
    [_topView addSubview:((IMBNoTitleBarWindow *)self.window).maxAndminView];
    [((IMBNoTitleBarWindow *)self.window).maxAndminView setBackgroundColor:COLOR_MAIN_WINDOW_BG];
    [_topView initWithLuCorner:YES LbCorner:NO RuCorner:YES RbConer:NO CornerRadius:5];
//    [_topView setWantsLayer:YES];
//    [_topView.layer setBackgroundColor:COLOR_MAIN_WINDOW_BG.CGColor];
    [_topView setBackgroundColor:COLOR_MAIN_WINDOW_BG];
    
    _deviceViewController = [[IMBDeviceViewController alloc]initWithNibName:@"IMBDeviceViewController" bundle:nil];
    [_rootBox addSubview:_deviceViewController.view];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window setContentSize:NSMakeSize(1060, 635)];
}
/**
 *  关闭window
 */
- (void)closeWindow:(id)sender {
    [self.window close];
    [_deviceViewController mainWindowClose];
}

- (void)dealloc {
    if (_deviceViewController) {
        [_deviceViewController release];
        _deviceViewController = nil;
    }
    //移除通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBSelectedDeviceDidChangeNotiWithParams object:nil];
    
    [super dealloc];
}


@end
