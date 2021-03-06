//
//  IMBSearchView.m
//  AnyTrans
//
//  Created by m on 17/8/18.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBSearchView.h"
#import "StringHelper.h"
#import "PocketSVG.h"
#import <QuartzCore/QuartzCore.h>
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
#import "IMBWhiteView.h"
#import "IMBSearchFieldCell.h"
@implementation IMBSearchView
@synthesize searchField = _searchField;
@synthesize closeBtn = _closeBtn;
@synthesize action = _action;
@synthesize target = _target;
@synthesize stringValue = _stringValue;
@synthesize backGroundColor = _backGroundColor;
@synthesize isOpen = _isOPen;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setAutoresizesSubviews:YES];
    _searchField = [[IMBSearchTextField alloc] initWithFrame:NSMakeRect(18, 0, self.frame.size.width -19.6, self.frame.size.height - 6)];
    [_searchField setBordered:NO];
    [_searchField setDrawsBackground:YES];
    [[_searchField cell] setBackgroundColor:[NSColor grayColor]];
    [_searchField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [_searchField setFocusRingType:NSFocusRingTypeNone];
    [[_searchField cell] setLineBreakMode:NSLineBreakByTruncatingTail];
    [_searchField setAutoresizingMask:NSViewWidthSizable|NSViewMaxXMargin];
    [_searchField setHidden:YES];
    [[_searchField cell] setPlaceholderString:@""];
    [[[_searchField cell] searchButtonCell] setImagePosition:NSImageOnly];
    [[_searchField cell] setLineBreakMode:NSLineBreakByClipping];
    [[[_searchField cell] searchButtonCell] setTitle:@""];
    [[[_searchField cell] cancelButtonCell] setImagePosition:NSNoImage];

    [((IMBSearchFieldCell *)_searchField.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [self addSubview:_searchField];
    NSImage *closeImage = [StringHelper imageNamed:@"fastdriver_close1"];
    _closeBtn = [[HoverButton alloc] initWithFrame:NSMakeRect(self.frame.size.width - closeImage.size.width - 6, (self.frame.size.height - closeImage.size.height)/2.0, closeImage.size.width, closeImage.size.height)];
    [_closeBtn setAutoresizingMask:NSViewMinXMargin];
    [_closeBtn setHidden:YES];
    [_closeBtn setTarget:self];
    [_closeBtn setAction:@selector(clearInputString:)];
    [_closeBtn setMouseEnteredImage:closeImage mouseExitImage:closeImage mouseDownImage:closeImage];
    [self addSubview:_closeBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea)
    {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited| NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)changeSkin:(NSNotification *)notification {
    [_searchField setTextColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [((IMBSearchFieldCell *)_searchField.cell) setCursorColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:dirtyRect.size.height / 2.0 yRadius:dirtyRect.size.height / 2.0];
    [path setWindingRule:NSEvenOddWindingRule];
    [path addClip];
    if (_isOPen) {
        [path closePath];
        if (_backGroundColor) {
            [_backGroundColor setFill];
            [path fill];
        }
        [[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] setStroke];
        [path stroke];
    }else {
        if (_mouseState == MouseDown) {
            [[StringHelper getColorFromString:CustomColor(@"popover_bgDownColor", nil)] setFill];
            [path fill];
        }else if (_mouseState == MouseEnter) {
            [[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)] setFill];
            [path fill];
        }else {
            [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] setFill];
            [path fill];
        }
        [[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] setStroke];
        [path stroke];
    }
    NSImage *image = [StringHelper imageNamed:@"nav_search"];
    [image drawInRect:NSMakeRect(0, (dirtyRect.size.height - image.size.height) / 2.0, image.size.width, image.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    
}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    _mouseState = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [super mouseEntered:theEvent];
    _mouseState = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [NSApp sendAction:self.action to:self.target from:self];
    _mouseState = MouseUp;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
    _mouseState = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)setStringValue:(NSString *)stringValue {
    [_searchField setStringValue:stringValue];
}

- (void)setBackGroundColor:(NSColor *)backGroundColor {
    if (_backGroundColor != nil) {
        [_backGroundColor release];
        _backGroundColor = nil;
    }
    _backGroundColor = [backGroundColor retain];
    [self setNeedsDisplay:YES];
}

- (NSString *)stringValue {
    return _searchField.stringValue;
}

- (BOOL)mouseDownCanMoveWindow {
    return NO;
}

- (void)setIsOpen:(BOOL)isOpen {
    _isOPen = isOpen;
    [self setNeedsDisplay:YES];
}

- (void)clearInputString:(id)sender {
    [[_searchField cell] setStringValue:@""];
    [_searchField sendAction:_searchField.action to:_searchField.target];
}

- (void)dealloc {
    if (_searchField != nil) {
        [_searchField release];
        _searchField = nil;
    }
    if (_closeBtn != nil) {
        [_closeBtn release];
        _closeBtn = nil;
    }
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}

@end

@implementation IMBSearchTextField
#import "IMBNotificationDefine.h"

- (id)initWithFrame:(NSRect)frameRect {
    if (self == [super initWithFrame:frameRect]) {
        IMBSearchFieldCell *cell = [[IMBSearchFieldCell alloc] init];
        [cell setStringValue:@""];
        [cell setEditable:YES];
        [self setCell:cell];
        [cell release];
    }
    return self;
}

@end

