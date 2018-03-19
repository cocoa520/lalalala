//
//  IMBiCloudNoTitleBarWinodw.m
//  iOSFiles
//
//  Created by smz on 18/3/14.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBiCloudNoTitleBarWinodw.h"
#import "_NSThemeWidgetCell.h"
#import "IMBCommonDefine.h"
#import <objc/runtime.h>
IMBiCloudNoTitleBarWinodw *iCloudWindow;
CFStringRef (* ioriginalIMP)(id self, SEL _cmd);
BOOL ihover=NO;

static CFStringRef myCoreUIWidgetState(id self, SEL _cmd) {
    if (self==iCloudWindow.maxButton.cell || self==iCloudWindow.minButton.cell || self==iCloudWindow.closeButton.cell) {
        if (((NSButtonCell *)self).isHighlighted) {
            return (__bridge CFStringRef)@"pressed";
        }
        return ihover?(__bridge CFStringRef)@"rollover":(__bridge CFStringRef)@"normal";
    }
    
    return ioriginalIMP(self,_cmd);
}

@implementation IMBiCloudNoTitleBarWinodw
@synthesize closeButton = _closeButton;
@synthesize minButton = _minButton;
@synthesize maxButton = _maxButton;
@synthesize maxAndminView = _maxAndminView;

#pragma mark - NSWindow Overwritings 重载

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    if ((self = [super initWithContentRect:contentRect styleMask:NSResizableWindowMask backing:bufferingType defer:YES])) {
        [self setMovableByWindowBackground:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:@"Change_Skin" object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    iCloudWindow = self;
    [self setHasShadow:YES];
    Method coreUIWidgetStateMethod=class_getInstanceMethod([_NSThemeWidgetCell class], @selector(coreUIState));
    const char *encoding=method_getTypeEncoding(coreUIWidgetStateMethod);
    ioriginalIMP=(void*)method_getImplementation(coreUIWidgetStateMethod);
    class_replaceMethod([_NSThemeWidgetCell class], @selector(coreUIState), (IMP)myCoreUIWidgetState, encoding);
    
//    _closeButton=[NSWindow standardWindowButton:NSWindowCloseButton forStyleMask:0 ];
//    _minButton=[NSWindow standardWindowButton:NSWindowMiniaturizeButton forStyleMask:0 ];
//    _maxButton=[NSWindow standardWindowButton:NSWindowZoomButton forStyleMask:0 ];
    
    self.opaque = NO;
    self.backgroundColor=[NSColor clearColor];
    
//    _maxAndminView = [[BackGroundView alloc] initWithFrame:NSMakeRect(10, [self.contentView frame].size.height-31, 56, 16)];
//    [_maxAndminView setWantsLayer:YES];
//    [_maxAndminView.layer setAnchorPointZ:-1];
    
//    [_maxAndminView setCanDrawConcurrently:NO];
//    [_closeButton setFrameOrigin:NSPointFromCGPoint(CGPointMake(0, 0))];
//    [_minButton setFrameOrigin:NSPointFromCGPoint(CGPointMake(20,0))];
//    [_maxButton setFrameOrigin:NSPointFromCGPoint(CGPointMake(40, 0))];
//    
//    [_maxAndminView addSubview:_closeButton];
//    [_maxAndminView addSubview:_minButton];
//    [_maxAndminView addSubview:_maxButton];
//    [_maxAndminView setBackgroundColor:COLOR_DEVICE_Main_WINDOW_TOPVIEW_COLOR];
//    [self.contentView addSubview:_maxAndminView];
//    _maxAndminView.autoresizesSubviews =YES;
//    _maxAndminView.autoresizingMask = 8;
//    [_closeButton setAction:@selector(closeWindow:)];
//    [_closeButton setTarget:self];
//    [_minButton setAction:@selector(minWindow:)];
//    [_minButton setTarget:self];
//    _closeButton.autoresizesSubviews =YES;
//    _closeButton.autoresizingMask = 8;
    _minButton.autoresizesSubviews =YES;
    _minButton.autoresizingMask = 8;
    _maxButton.autoresizesSubviews =YES;
    _maxButton.autoresizingMask = 8;
    NSTrackingArea *trackingArea=[[NSTrackingArea alloc]initWithRect:NSRectFromCGRect(CGRectMake(0, 0, _closeButton.frame.size.width*3+10, _closeButton.frame.size.height*1)) options:NSTrackingActiveAlways|NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    [_closeButton addTrackingArea:trackingArea];
    [trackingArea release];
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (BOOL)canBecomeMainWindow {
    return YES;
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (void)becomeKeyWindow {
    [super becomeKeyWindow];
    [self setTitleButtonsNeedDisplay];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MainWindowBecomeKeyWindow" object:nil];
}

- (void)resignKeyWindow {
    [super resignKeyWindow];
    [self setTitleButtonsNeedDisplay];
}

#pragma mark - Actions

- (void)mouseEntered:(NSEvent *)theEvent {
    ihover=YES;
    [self setTitleButtonsNeedDisplay];
}


- (void)mouseExited:(NSEvent *)theEvent {
    ihover=NO;
    [self setTitleButtonsNeedDisplay];
}


- (void)setTitleButtonsNeedDisplay {
    [_closeButton setNeedsDisplay:YES];
    [_maxButton setNeedsDisplay:YES];
    [_minButton setNeedsDisplay:YES];
}

- (void)minWindow:(id)sender {
    [self miniaturize:sender];
}

- (void)mouseDragged:(NSEvent *)theEvent {
    [super mouseDragged:theEvent];
    [self.contentView setNeedsDisplay:YES];
}

- (void)sendEvent:(NSEvent *)theEvent {
    [theEvent.window setViewsNeedDisplay:YES];
    [super sendEvent:theEvent];
    NSView *contentView = self.contentView;
    NSPoint point = [contentView convertPoint:theEvent.locationInWindow fromView:nil];
    NSView *hitView = [contentView hitTest:point];
    
    if (theEvent.type == 2 && ![hitView isKindOfClass:[NSClassFromString(@"NSButton") class]] && ![hitView isKindOfClass:[NSClassFromString(@"IMBTransparentView") class]] && ![hitView isKindOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]) {
        NSDictionary *infor = [NSDictionary dictionaryWithObjectsAndKeys:theEvent,@"theEvent",@"other",@"classType", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notify_close_popupview" object:nil userInfo:infor];
    }
    [self.contentView setNeedsDisplay:YES];
}

- (void)dealloc {
    Method coreUIWidgetStateMethod=class_getInstanceMethod([_NSThemeWidgetCell class], @selector(coreUIState));
    const char *encoding=method_getTypeEncoding(coreUIWidgetStateMethod);
    class_replaceMethod([_NSThemeWidgetCell class], @selector(coreUIState), (IMP)ioriginalIMP, encoding);
    [super dealloc];
}

@end

