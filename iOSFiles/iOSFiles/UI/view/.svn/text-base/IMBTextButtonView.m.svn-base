//
//  IMBTextButtonView.m
//  MacClean
//
//  Created by LuoLei on 15-12-25.
//  Copyright (c) 2015年 imobie. All rights reserved.
//

#import "IMBTextButtonView.h"
#import "StringHelper.h"

@implementation IMBTextButtonView
@synthesize font = _font;
@synthesize fontColor = _fontColor;
@synthesize fontEnterColor = _fontEnterColor;
@synthesize fontDownColor = _fontDownColor;
@synthesize isAlertView = _isAlertView;
@synthesize buttonTitle = _buttonTitle;
@synthesize isPromptView = _isPromptView;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    if (_isAlertView) {
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:self.alignment];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[_font, _fontColor,mutParaStyle] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName, NSParagraphStyleAttributeName]];
        [_buttonTitle drawInRect:dirtyRect withAttributes:dic];
        [mutParaStyle release];
    } else if (_isPromptView) {
        NSColor *titleColor = nil;
        if (_mouseType == MouseUp || _mouseType == MouseOut) {
            titleColor = _fontColor;
        } else if (_mouseType == MouseEnter) {
            titleColor = _fontEnterColor;
        } else if (_mouseType == MouseDown) {
            titleColor = _fontDownColor;
        } else {
            titleColor = _fontColor;
        }
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:NSLeftTextAlignment];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[_font, titleColor,mutParaStyle,[NSNumber numberWithInt:NSUnderlineStyleSingle]] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName, NSParagraphStyleAttributeName,NSUnderlineStyleAttributeName]];
        [_buttonTitle drawInRect:dirtyRect withAttributes:dic];
        [mutParaStyle release];
    }
}

- (void)setFontColor:(NSColor *)fontColor {
    if (_fontColor != nil) {
        [_fontColor release];
        _fontColor = nil;
    }
    _fontColor = [fontColor retain];
}

- (void)setFontEnterColor:(NSColor *)fontEnterColor {
    if (_fontEnterColor != nil) {
        [_fontEnterColor release];
        _fontEnterColor = nil;
    }
    _fontEnterColor = [fontEnterColor retain];
}

- (void)setFontDownColor:(NSColor *)fontDownColor {
    if (_fontDownColor != nil) {
        [_fontDownColor release];
        _fontDownColor = nil;
    }
    _fontDownColor = [fontDownColor retain];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
}

- (void)resizeWithOldSuperviewSize:(NSSize)oldSize
{

}

-(void)awakeFromNib
{
    [self setBordered:NO];
    [self setImagePosition:NSNoImage];
    [self.cell setHighlightsBy:NSNoCellMask];
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    if (_trackingArea == nil) {
        NSTrackingAreaOptions options =  (NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate);
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil] ;
        [self addTrackingArea:_trackingArea];
        [_trackingArea release];
    }
}

- (void)setTitle:(NSString *)aString {
    if (!_isAlertView || !_isPromptView) {
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:self.alignment];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:(aString?aString:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName,_fontColor,NSForegroundColorAttributeName,mutParaStyle,NSParagraphStyleAttributeName,nil]];
        [mutParaStyle release];
        NSInteger length = ceil(title.size.width);
        if (length%2 != 0) {
            length += 1;
        }
        [self setFrame:NSMakeRect(NSMinX(self.frame), NSMinY(self.frame), length+4, NSHeight(self.frame))];
        [super setAttributedTitle:title];
        [title release];
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseType = MouseEnter;
    if (!_isAlertView || !_isPromptView) {
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:self.alignment];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:(self.attributedTitle.string?self.attributedTitle.string:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName,_fontEnterColor,NSForegroundColorAttributeName,mutParaStyle,NSParagraphStyleAttributeName,nil]];
        [mutParaStyle release];
        [self setAttributedTitle:title];
        [title release];
        [self setNeedsDisplay:YES];
    } else {
        [super mouseEntered:theEvent];
    }
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseType = MouseOut;
    if (!_isAlertView || !_isPromptView) {
        NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
        [mutParaStyle setAlignment:self.alignment];
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:(self.attributedTitle.string?self.attributedTitle.string:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName,_fontColor,NSForegroundColorAttributeName,mutParaStyle,NSParagraphStyleAttributeName,nil]];
        [mutParaStyle release];
        [self setAttributedTitle:title];
        [title release];
    }
    [super mouseExited:theEvent];
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseType = MouseDown;
    
    NSMutableParagraphStyle *mutParaStyle=[[NSMutableParagraphStyle alloc] init];
    [mutParaStyle setAlignment:self.alignment];
    NSAttributedString *titledown = [[NSAttributedString alloc] initWithString:(self.attributedTitle.string?self.attributedTitle.string:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName,_fontDownColor,NSForegroundColorAttributeName,mutParaStyle,NSParagraphStyleAttributeName,nil]];
    [mutParaStyle release];
    [self setAttributedTitle:titledown];
    [titledown release];
    
//    [super mouseDown:theEvent];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:(self.attributedTitle.string?self.attributedTitle.string:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName,_fontColor,NSForegroundColorAttributeName,mutParaStyle,NSParagraphStyleAttributeName,nil]];
    [self setAttributedTitle:title];
    [title release];
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
    if (inner) {
        [NSApp sendAction:self.action to:self.target from:self];
    }
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [super mouseUp:theEvent];
    _mouseType = MouseUp;
    [self setNeedsDisplay:YES];
}

- (void)dealloc
{
    if (_fontColor != nil) {
        [_fontColor release];
        _fontColor = nil;
    }
    if (_fontDownColor != nil) {
        [_fontDownColor release];
        _fontDownColor  = nil;
    }
    if (_fontEnterColor != nil) {
        [_fontEnterColor release];
        _fontEnterColor = nil;
    }
    [super dealloc];
}

@end
