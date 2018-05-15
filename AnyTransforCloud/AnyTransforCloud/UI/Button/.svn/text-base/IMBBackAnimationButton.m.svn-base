//
//  IMBBackAnimationButton.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/19.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBBackAnimationButton.h"
#import "StringHelper.h"
#import "IMBAnimation.h"

@implementation IMBBackAnimationButton

- (void)dealloc {
    if (_mouseDownImage) {
        [_mouseDownImage release];
        _mouseDownImage = nil;
    }
    if (_mouseExitedImage) {
        [_mouseExitedImage release];
        _mouseExitedImage = nil;
    }
    if (_mouseEnteredImage) {
        [_mouseEnteredImage release];
        _mouseEnteredImage = nil;
    }
    if (_buttonTitle != nil) {
        [_buttonTitle release];
        _buttonTitle = nil;
    }
    if (_titleNormalColor != nil) {
        [_titleNormalColor release];
        _titleNormalColor = nil;
    }
    if (_titleEnterColor != nil) {
        [_titleEnterColor release];
        _titleEnterColor = nil;
    }
    if (_titleDownColor != nil) {
        [_titleDownColor release];
        _titleDownColor = nil;
    }
    
    [super dealloc];
}

- (void)awakeFromNib {
    [self setWantsLayer:YES];
    _imageLayer = [[CALayer alloc] init];
    [self.layer addSublayer:_imageLayer];
}

- (void)setMouseExitedImg:(NSImage *)mouseExiteImg withMouseEnterImg:(NSImage *)mouseEnterImg withMouseDownImage:(NSImage *)mouseDownImg {
    if (_mouseDownImage) {
        [_mouseDownImage release];
        _mouseDownImage = nil;
    }
    if (_mouseExitedImage) {
        [_mouseExitedImage release];
        _mouseExitedImage = nil;
    }
    if (_mouseEnteredImage) {
        [_mouseEnteredImage release];
        _mouseEnteredImage = nil;
    }
    _mouseDownImage = [mouseDownImg retain];
    _mouseExitedImage = [mouseExiteImg retain];
    _mouseEnteredImage = [mouseEnterImg retain];
    _imageLayer.contents = _mouseExitedImage;
    NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:14.0];
    NSRect titleRect = [StringHelper calcuTextBounds:_buttonTitle font:font];
    [_imageLayer setFrame:NSMakeRect(self.frame.size.width - titleRect.size.width - 3 - _mouseExitedImage.size.width,(self.frame.size.height - _mouseExitedImage.size.height) / 2.0 + 2, _mouseExitedImage.size.width, _mouseExitedImage.size.height)];
    
    [self setNeedsDisplay:YES];
}

- (void)setButtonWithTitle:(NSString *)buttonTitle WithTitleNormalColor:(NSColor *)titleNormalColor WithTitleEnterColor:(NSColor *)titleEnterColor WithTitleDownColor:(NSColor *)titleDownColor {
    if (_buttonTitle != nil) {
        [_buttonTitle release];
        _buttonTitle = nil;
    }
    _buttonTitle = [buttonTitle retain];
    if (_titleNormalColor != nil) {
        [_titleNormalColor release];
        _titleNormalColor = nil;
    }
    _titleNormalColor = [titleNormalColor retain];
    if (_titleEnterColor != nil) {
        [_titleEnterColor release];
        _titleEnterColor = nil;
    }
    _titleEnterColor = [titleEnterColor retain];
    if (_titleDownColor != nil) {
        [_titleDownColor release];
        _titleDownColor = nil;
    }
    _titleDownColor = [titleDownColor retain];
    _mouseType = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (_buttonTitle != nil) {
        NSColor *titleColor = nil;
        if (_mouseType == MouseOut || _mouseType == MouseUp) {
            titleColor = _titleNormalColor;
        } else if (_mouseType == MouseEnter) {
            titleColor = _titleEnterColor;
        } else if (_mouseType == MouseDown) {
            titleColor = _titleDownColor;
        } else {
            titleColor = _titleNormalColor;
        }
        NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:14.0];
        NSRect titleRect = [StringHelper calcuTextBounds:_buttonTitle font:font];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[font, titleColor] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
        titleRect = NSMakeRect(dirtyRect.size.width - titleRect.size.width,(dirtyRect.size.height - titleRect.size.height) / 2.0, titleRect.size.width, titleRect.size.height);
        [_buttonTitle drawInRect:titleRect withAttributes:dic];
    }
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

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseType = MouseEnter;
    [super mouseEntered:theEvent];
    [self setNeedsDisplay:YES];
    [_imageLayer removeAllAnimations];
    _imageLayer.contents = _mouseEnteredImage;
    CABasicAnimation *animation = [IMBAnimation moveX:0.5 X:@(-5) repeatCount:0 beginTime:0];
    [_imageLayer addAnimation:animation forKey:@"an1"];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseType = MouseOut;
    [super mouseExited:theEvent];
    [self setNeedsDisplay:YES];
    [_imageLayer removeAllAnimations];
    _imageLayer.contents = _mouseExitedImage;
    CABasicAnimation *animation = [IMBAnimation moveX:0.5 fromX:@(-5) toX:0 repeatCount:0 beginTime:0];
    [_imageLayer addAnimation:animation forKey:@"an2"];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseType = MouseDown;
    _imageLayer.contents = _mouseDownImage;
    [super mouseDown:theEvent];
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _mouseType = MouseUp;
    _imageLayer.contents = _mouseExitedImage;
    [super mouseUp:theEvent];
    [self setNeedsDisplay:YES];
}

@end
