//
//  IMBUpgradeWindow.m
//  AnyTrans for Android
//
//  Created by iMobie on 12/27/17.
//  Copyright (c) 2017 iMobie. All rights reserved.
//

#import "IMBUpgradeWindow.h"
#import "_NSThemeWidgetCell.h"
#import <objc/runtime.h>
#import "StringHelper.h"
BOOL uphover=NO;

@implementation IMBUpgradeWindow
@synthesize closeButton = _closeButton;
@synthesize minButton = _minButton;
@synthesize maxButton = _maxButton;
@synthesize maxAndminView = _maxAndminView;
#pragma mark - NSWindow Overwritings 重载
- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    if ((self = [super initWithContentRect:contentRect styleMask:NSResizableWindowMask backing:bufferingType defer:YES])) {
        [self setMovableByWindowBackground:YES];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setHasShadow:YES];
    
    _closeButton=[NSWindow standardWindowButton:NSWindowCloseButton forStyleMask:0 ];
    _minButton=[NSWindow standardWindowButton:NSWindowMiniaturizeButton forStyleMask:0 ];
    _maxButton=[NSWindow standardWindowButton:NSWindowZoomButton forStyleMask:0 ];
    
    self.opaque = NO;
    self.backgroundColor=[NSColor clearColor];
    
    _maxAndminView = [[IMBBackGroundView alloc] initWithFrame:NSMakeRect(10, [self.contentView frame].size.height-31, 56, 16)];
    [_maxAndminView setWantsLayer:YES];
    [_maxAndminView.layer setAnchorPointZ:-1];
    
    [_maxAndminView setCanDrawConcurrently:NO];
    [_closeButton setFrameOrigin:NSPointFromCGPoint(CGPointMake(0, 0))];
    [_minButton setFrameOrigin:NSPointFromCGPoint(CGPointMake(20,0))];
    [_maxButton setFrameOrigin:NSPointFromCGPoint(CGPointMake(40, 0))];
    
    [_maxAndminView addSubview:_closeButton];
    [_maxAndminView addSubview:_minButton];
    [_maxAndminView addSubview:_maxButton];
    [_maxAndminView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [self.contentView addSubview:_maxAndminView];
    _maxAndminView.autoresizesSubviews =YES;
    _maxAndminView.autoresizingMask = 8;
    [_closeButton setAction:@selector(closeWindow:)];
    [_closeButton setTarget:self];
    [_minButton setAction:@selector(minWindow:)];
    [_minButton setTarget:self];
    _closeButton.autoresizesSubviews =YES;
    _closeButton.autoresizingMask = 8;
    _minButton.autoresizesSubviews =YES;
    _minButton.autoresizingMask = 8;
    _maxButton.autoresizesSubviews =YES;
    _maxButton.autoresizingMask = 8;
    NSTrackingArea *trackingArea=[[NSTrackingArea alloc]initWithRect:NSRectFromCGRect(CGRectMake(0, 0, _closeButton.frame.size.width*3+10, _closeButton.frame.size.height*1)) options:NSTrackingActiveAlways|NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    [_closeButton addTrackingArea:trackingArea];
    [trackingArea release];
}

- (void)changeSkin:(NSNotification *)notification {
    [_maxAndminView setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)]];
    [_maxAndminView setNeedsDisplay:YES];
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
    uphover=YES;
    [self setTitleButtonsNeedDisplay];
}

- (void)mouseExited:(NSEvent *)theEvent {
    uphover=NO;
    [self setTitleButtonsNeedDisplay];
}

- (void)setTitleButtonsNeedDisplay {
    [_closeButton setNeedsDisplay:YES];
    [_maxButton setNeedsDisplay:YES];
    [_minButton setNeedsDisplay:YES];
}

- (void)closeWindow:(id)sender {
    [self close];
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
//    NSView *contentView = self.contentView;
//    NSPoint point = [contentView convertPoint:theEvent.locationInWindow fromView:nil];
//    NSView *hitView = [contentView hitTest:point];
//    
//    if (theEvent.type == 2&&![hitView isKindOfClass:[NSClassFromString(@"NSButton") class]]&&![hitView isKindOfClass:[NSClassFromString(@"IMBTransparentView") class]]&&![hitView isKindOfClass:[NSClassFromString(@"IMBAlertSupeView") class]]) {
//        NSDictionary *infor = [NSDictionary dictionaryWithObjectsAndKeys:theEvent,@"theEvent",@"other",@"classType", nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"notify_close_popupview" object:nil userInfo:infor];
//    }
//    [self.contentView setNeedsDisplay:YES];
}

- (void)dealloc {
//    Method coreUIWidgetStateMethod=class_getInstanceMethod([_NSThemeWidgetCell class], @selector(coreUIState));
//    const char *encoding=method_getTypeEncoding(coreUIWidgetStateMethod);
//    class_replaceMethod([_NSThemeWidgetCell class], @selector(coreUIState), (IMP)originalIMP, encoding);
    [super dealloc];
}

@end

@implementation IMBBackGroundView

@synthesize backgroundColor = _backgroundColor;

- (void)dealloc{
    [_backgroundColor release],_backgroundColor = nil;
    [super dealloc];
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    if (_backgroundColor != backgroundColor) {
        [_backgroundColor release];
        _backgroundColor = [backgroundColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [_backgroundColor setFill];
    NSRectFill(dirtyRect);
}

@end
