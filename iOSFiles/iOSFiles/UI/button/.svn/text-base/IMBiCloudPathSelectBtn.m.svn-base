//
//  IMBiCloudPathSelectBtn.m
//  iOSFiles
//
//  Created by smz on 18/3/16.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBiCloudPathSelectBtn.h"
#import "IMBCommonDefine.h"

@implementation IMBiCloudPathSelectBtn

- (void)setButtonTitle:(NSString *)buttonName WithIsHomePage:(BOOL)isHomePage {
    if (_buttonName != nil) {
        [_buttonName release];
        _buttonName = nil;
    }
    _buttonName = [buttonName retain];
    _isHomePage = isHomePage;
    if (_isHomePage) {
        _leftImage = [NSImage imageNamed:@"symbols-apple"];
    } else {
        _leftImage = [NSImage imageNamed:@"device_name_icloud"];
    }
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    if (_trackingArea)
    {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

-(void)mouseDown:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = MouseDown;
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseUp:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = MouseUp;
        [self setNeedsDisplay:YES];
        NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
        BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
        if (inner&&theEvent.clickCount ==1) {
            [NSApp sendAction:self.action to:self.target from:self];
        }
    }
}

-(void)mouseExited:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = MouseOut;
        [self setNeedsDisplay:YES];
    }
    
}

-(void)mouseEntered:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = MouseEnter;
        [self setNeedsDisplay:YES];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    if (_buttonType == MouseDown || _buttonType == MouseEnter) {
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
        [path addClip];
        [path setWindingRule:NSEvenOddWindingRule];
        if (_buttonType == MouseEnter) {
            [COLOR_TEXT_BUTTON_PASSAFTER setFill];
        } else if (_buttonType == MouseDown) {
            [COLOR_TEXT_BUTTON_CELLCLICK setFill];
        }
        [path fill];
        [path closePath];
    }
    
    if (_leftImage) {
        [_leftImage drawInRect:NSMakeRect(5, (dirtyRect.size.height - _leftImage.size.height) / 2.0 - 1, _leftImage.size.width, _leftImage.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    }
    
    if (_buttonName) {
        NSRect titleRect = [self calcuTextBounds:_buttonName fontSize:12.0];
        NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[font, COLOR_TEXT_ORDINARY] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
        NSRect drawRect = NSMakeRect(_leftImage.size.width + 5 + 8,(dirtyRect.size.height - titleRect.size.height) / 2.0 - 1, titleRect.size.width, titleRect.size.height);
        [_buttonName drawInRect:drawRect withAttributes:dic];
    }
    
    
    
}

- (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize {
    NSRect textBounds = NSMakeRect(0, 0, 0, 0);
    if (text) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [paragraphStyle setAlignment:NSLeftTextAlignment];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                      [NSFont fontWithName:@"Helvetica Neue" size:fontSize], NSFontAttributeName,
                      paragraphStyle, NSParagraphStyleAttributeName,
                      nil];
        NSSize textSize = [text sizeWithAttributes:attributes];
        textBounds = NSMakeRect(0, 0, textSize.width, textSize.height);
        [as release];
    }
    return textBounds;
}

- (void)dealloc {
    if (_buttonName != nil) {
        [_buttonName release];
        _buttonName = nil;
    }
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

@end
