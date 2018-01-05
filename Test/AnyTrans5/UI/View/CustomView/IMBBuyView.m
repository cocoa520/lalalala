//
//  IMBBuyView.m
//  AnyTrans
//
//  Created by m on 17/8/22.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBBuyView.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"

@implementation IMBBuyView
@synthesize isOpen = _isOpen;
@synthesize isClick = _isClick;

- (void)awakeFromNib {
    _normalColor = [[StringHelper getColorFromString:CustomColor(@"buy_normalColor", nil)] retain];
    _enterColor = [[StringHelper getColorFromString:CustomColor(@"buy_enterColor", nil)] retain];
    _downColor = [[StringHelper getColorFromString:CustomColor(@"buy_downColor", nil)] retain];
    count = 1;
    _image1 = [[StringHelper imageNamed:@"nav_buy1"] retain];
    _image2 = [[StringHelper imageNamed:@"nav_buy2"] retain];
    _image3 = [[StringHelper imageNamed:@"nav_buy3"] retain];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
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

- (void)changeImage {
    if (count == 1) {
        count = 2;
    }else if (count == 2) {
        count = 3;
    }else if (count == 3) {
        count = 4;
    }else if (count == 4) {
        count = 5;
    }else if (count == 5) {
        count = 6;
    }else if (count == 6) {
        count = 1;
    }
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:dirtyRect.size.height / 2.0 yRadius:dirtyRect.size.height / 2.0];
    if (_mouseState == MouseDown) {
        [_downColor setFill];
    }else if (_mouseState == MouseEnter) {
        [_enterColor setFill];
    }else {
        [_normalColor setFill];
    }
    [path fill];
    
    if (_isOpen) {
        //文字
        NSSize size ;
        NSMutableAttributedString *attrStr = [StringHelper TruncatingTailForStringDrawing:CustomLocalizedString(@"register_window_activateBtn", nil) withFont:[NSFont fontWithName:@"Helvetica Neue medium" size:12] withLineSpacing:0 withMaxWidth:135 withSize:&size withColor:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)] withAlignment:NSLeftTextAlignment];
        NSRect textRect2 = NSMakeRect(44 , 5, size.width, 20);
        [attrStr drawInRect:textRect2];
        if (count <= 5 && count % 2 == 0) {
            if (_image1) {
                [_image1 drawInRect:NSMakeRect(16, (dirtyRect.size.height - _image1.size.height) / 2.0, _image1.size.width, _image1.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
            }
        }else{
            if (_image2) {
                [_image2 drawInRect:NSMakeRect(16, (dirtyRect.size.height - _image2.size.height) / 2.0, _image2.size.width, _image2.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
            }
        }
    }else {
        if (_image3) {
            [_image3 drawInRect:NSMakeRect((dirtyRect.size.width - _image3.size.width) / 2.0, (dirtyRect.size.height - _image3.size.height) / 2.0, _image3.size.width, _image3.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        }
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [super mouseEntered:theEvent];
    _mouseState = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    _mouseState = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
     _mouseState = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (!_isClick) {
        _isClick = YES;
         [NSApp sendAction:self.action to:self.target from:self];
    }
    _mouseState = MouseUp;
    [self setNeedsDisplay:YES];
}

- (BOOL)mouseDownCanMoveWindow {
    return NO;
}

- (void)setIsOpen:(BOOL)isOpen {
    _isOpen = isOpen;
    [self setNeedsDisplay:YES];
}

- (void)changeSkin:(NSNotification *)notification{
    if (_normalColor != nil) {
        [_normalColor release];
        _normalColor = nil;
    }
    if (_enterColor != nil) {
        [_enterColor release];
        _enterColor = nil;
    }
    if (_downColor != nil) {
        [_downColor release];
        _downColor = nil;
    }
    if (_image1 != nil) {
        [_image1 release];
        _image1 = nil;
    }
    if (_image2 != nil) {
        [_image2 release];
        _image2 = nil;
    }
    if (_image3 != nil) {
        [_image3 release];
        _image3 = nil;
    }
    _normalColor = [[StringHelper getColorFromString:CustomColor(@"buy_normalColor", nil)] retain];
    _enterColor = [[StringHelper getColorFromString:CustomColor(@"buy_enterColor", nil)] retain];
    _downColor = [[StringHelper getColorFromString:CustomColor(@"buy_downColor", nil)] retain];
    _image1 = [[StringHelper imageNamed:@"nav_buy1"] retain];
    _image2 = [[StringHelper imageNamed:@"nav_buy2"] retain];
    _image3 = [[StringHelper imageNamed:@"nav_buy3"] retain];
    [self setNeedsDisplay:YES];
}


- (void)dealloc {
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    if (_normalColor != nil) {
        [_normalColor release];
        _normalColor = nil;
    }
    if (_enterColor != nil) {
        [_enterColor release];
        _enterColor = nil;
    }
    if (_downColor != nil) {
        [_downColor release];
        _downColor = nil;
    }
    if (_image1 != nil) {
        [_image1 release];
        _image1 = nil;
    }
    if (_image2 != nil) {
        [_image2 release];
        _image2 = nil;
    }
    if (_image3 != nil) {
        [_image3 release];
        _image3 = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    
    [super dealloc];
}

@end
