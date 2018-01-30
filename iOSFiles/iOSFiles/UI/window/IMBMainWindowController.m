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
    NSRect screenRect = [NSScreen mainScreen].frame;
    [self.window setMaxSize:screenRect.size];
    [self.window setMinSize:NSMakeSize(1060, 635)];

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
    
    [self addNotis];
    
}
/**
 *  关闭window
 */
- (void)closeWindow:(id)sender {
    [self.window close];
}

/**
 *  配置设备选择按钮
 *
 *  @param buttonName  按钮title
 *  @param textColor   按钮字体颜色
 *  @param size        按钮大小
 *  @param showIcon    是否显示icon
 *  @param showTrangle 是否显示右边的三角
 *  @param isDisable   是否可点击
 *  @param connectType 连接设备的type
 */
- (void)configButtonName:(NSString *)buttonName WithTextColor:(NSColor *)textColor WithTextSize:(float)size WithIsShowIcon:(BOOL)showIcon WithIsShowTrangle:(BOOL)showTrangle  WithIsDisable:(BOOL)isDisable withConnectType:(IPodFamilyEnum)connectType {
    
    [_selectedDeviceBtn configButtonName:buttonName WithTextColor:textColor WithTextSize:size WithIsShowIcon:showIcon WithIsShowTrangle:showTrangle WithIsDisable:isDisable withConnectType:connectType];
}

/**
 *  设备选择按钮点击
 *
 *  @param sender 按钮
 */
- (IBAction)selectedDeviceBtnClicked:(IMBSelecedDeviceBtn *)sender {
    IMBFFuncLog;
    
    IMBDeviceConnection *deviceConnection = [IMBDeviceConnection singleton];
    if (!_selectedDeviceBtn.isDisable) {
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
        
//        if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
            _devPopover.appearance = (NSPopoverAppearance)[NSAppearance appearanceNamed:NSAppearanceNameAqua];
//        }else {
//            _devPopover.appearance = NSPopoverAppearanceMinimal;
//        }
        
        _devPopover.animates = YES;
        _devPopover.behavior = NSPopoverBehaviorTransient;
        _devPopover.delegate = self;
        
        IMBDevViewController *devController = [[[IMBDevViewController alloc] initWithNibName:@"IMBDevViewController" bundle:nil] autorelease];
        CGFloat w = 300.0f;
        CGFloat h = 50.0f*deviceConnection.allDevices.count;
        h = h > 200.0f ? 200.0f : h;
        
        devController.view.frame = NSMakeRect(0, 0, w, h);
        
        NSMutableArray *allDevices = [[NSMutableArray alloc] init];
        
        if (deviceConnection.allDevices.count) {
            for (IMBBaseInfo *baseInfo in deviceConnection.allDevices) {
                [allDevices addObject:baseInfo];
            }
            
            if (_devPopover != nil) {
                _devPopover.contentViewController = devController;
            }
            devController.devices = allDevices;
//            [allDevices release];
//            allDevices = nil;
            NSRectEdge prefEdge = NSMaxYEdge;
            NSRect rect = NSMakeRect(sender.bounds.origin.x, sender.bounds.origin.y, sender.bounds.size.width, sender.bounds.size.height);
            [_devPopover showRelativeToRect:rect ofView:sender preferredEdge:prefEdge];
        }
    }
}
/**
 *  添加通知
 */
- (void)addNotis {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedDeviceDidChangeNoti:) name:IMBSelectedDeviceDidChangeNotiWithParams object:nil];
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMBSelectedDeviceDidChangeNotiWithParams object:nil];
    
    [super dealloc];
}

#pragma mark -- 通知响应方法

- (void)selectedDeviceDidChangeNoti:(NSNotification *)noti {
    if (_devPopover.isShown) {
        [_devPopover close];
    }
}

@end
