//
//  IMBSelectedButton.m
//  AnyTransforCloud
//
//  Created by ding ming on 18/4/10.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBSelectedButton.h"

@implementation IMBSelectedButton
@synthesize isSelect = _isSelect;

- (void)drawRect:(NSRect)dirtyRect {
    NSColor *color = nil;
    if (_isSelect) {
        color = _selectColor;
    }else {
        if (_mouseType == MouseOut) {
            color = _exitColor;
        }else if (_mouseType == MouseDown) {
            color = _downColor;
        }else if (_mouseType == MouseEnter) {
            color = _enterColor;
        }else if (_mouseType == MouseUp) {
            color = _exitColor;
        }else {
            color = _exitColor;
        }
    }
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:NSCenterTextAlignment];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[_font, color, mutParaStyle] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName, NSParagraphStyleAttributeName]];
    [_buttonTitle drawInRect:dirtyRect withAttributes:dic];
    [mutParaStyle release];
    // Drawing code here.
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea == nil) {
        NSTrackingAreaOptions options =  (NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate);
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil] ;
        [self addTrackingArea:_trackingArea];
        [_trackingArea release];
    }
}

- (void)setEnterColor:(NSColor *)enterColor downColor:(NSColor *)downColor ExitColor:(NSColor *)exitColor SelectColor:(NSColor *)selectColor titleFont:(NSFont *)font buttonTitle:(NSString *)buttonTitle {
    if (_enterColor != nil) {
        [_enterColor release];
        _enterColor = nil;
    }
    _enterColor = [enterColor retain];
    
    if (_downColor != nil) {
        [_downColor release];
        _downColor = nil;
    }
    _downColor = [downColor retain];
    
    if (_exitColor != nil) {
        [_exitColor release];
        _exitColor = nil;
    }
    _exitColor = [exitColor retain];
    
    if (_selectColor != nil) {
        [_selectColor release];
        _selectColor = nil;
    }
    _selectColor = [selectColor retain];
    
    if (_font != nil) {
        [_font release];
        _font = nil;
    }
    _font = [font retain];
    
    if (_buttonTitle != nil) {
        [_buttonTitle release];
        _buttonTitle = nil;
    }
    _buttonTitle = [buttonTitle retain];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseType = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseType = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseType = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _mouseType = MouseUp;
    if (!_isSelect) {
        NSPoint localPoint = [self convertPoint:[[self window] convertScreenToBase:[NSEvent mouseLocation]] fromView:nil];
        BOOL mouseInside = NSPointInRect(localPoint, [self bounds]);
        if (mouseInside) {
            _isSelect = YES;
            if (self.target != nil && self.action != nil && self.isEnabled) {
                if ([self.target respondsToSelector:self.action]) {
                    [self.target performSelector:self.action withObject:self];
                }
            }
        }
    }
    [self setNeedsDisplay:YES];
}

- (void)dealloc {
    if (_enterColor != nil) {
        [_enterColor release];
        _enterColor = nil;
    }
    if (_exitColor != nil) {
        [_exitColor release];
        _exitColor = nil;
    }
    if (_selectColor != nil) {
        [_selectColor release];
        _selectColor = nil;
    }
    if (_font != nil) {
        [_font release];
        _font = nil;
    }
    if (_buttonTitle != nil) {
        [_buttonTitle release];
        _buttonTitle = nil;
    }
    if (_downColor != nil) {
        [_downColor release];
        _downColor = nil;
    }
    [super dealloc];
}

@end
