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
    [self.window setContentSize:NSMakeSize(1060, 635)];

    [(NSView *)((IMBNoTitleBarWindow *)self.window).maxAndminView setFrameOrigin:NSMakePoint(10,NSHeight(_topView.frame) - 36)];
    [[(IMBNoTitleBarWindow *)self.window closeButton] setAction:@selector(closeWindow:)];
    [[(IMBNoTitleBarWindow *)self.window closeButton] setTarget:self];
    [_topView addSubview:((IMBNoTitleBarWindow *)self.window).maxAndminView];
    [_topView initWithLuCorner:YES LbCorner:NO RuCorner:YES RbConer:NO CornerRadius:5];
    [_topView setWantsLayer:YES];
    [_topView.layer setBackgroundColor:IMBGrayColor(255).CGColor];
    
    IMBDeviceViewController *deviceViewController = [[IMBDeviceViewController alloc]initWithNibName:@"IMBDeviceViewController" bundle:nil];
    [_rootBox addSubview:deviceViewController.view];
    [deviceViewController release];
    deviceViewController = nil;
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
}

- (void)dealloc {
    //移除通知
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBSelectedDeviceDidChangeNotiWithParams object:nil];
    
    [super dealloc];
}


@end
