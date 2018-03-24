//
//  IMBGeneralButton.m
//  PhoneClean
//
//  Created by iMobie on 6/17/15.
//  Copyright (c) 2015 imobie.com. All rights reserved.
//

#import "IMBGeneralButton.h"
#import "StringHelper.h"
#import "IMBCommonDefine.h"

@interface IMBGeneralButton()
{
    NSColor *_bgColor;
}

@end

@implementation IMBGeneralButton

- (id)initWithFrame:(NSRect)frame WithPrefixImageName:(NSString *)prefixImageName WithButtonName:(NSString *)buttonName {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)awakeFromNib {
    
    [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:0];
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5.f yRadius:5.f];
    if (_bgColor) {
        [COLOR_BTN_BLUE_BG set];
        [path addClip];
        [path fill];
    }
    
    [path setLineWidth:2.f];
    [path addClip];
    [Progress_BgColor setStroke];
    [path stroke];
}

#pragma mark - mouse action

- (void)mouseDown:(NSEvent *)theEvent {
    
}

- (void)mouseUp:(NSEvent *)theEvent {
    [NSApp sendAction:self.action to:self.target from:self];
}

- (void)mouseEntered:(NSEvent *)theEvent {
//    _bgColor = COLOR_BTN_BLUE_BG;
//    [self setNeedsDisplay];
//    [self setTitleAttrWithTitleColor:[NSColor whiteColor]];
}

- (void)mouseExited:(NSEvent *)theEvent {
//    [self setTitleAttrWithTitleColor:COLOR_MAINWINDOW_REMEMBENME_TEXT];
//    _bgColor = nil;
//    [self setNeedsDisplay];
}

#pragma mark - other methods
- (void)setTitleAttrWithTitleColor:(NSColor *)color {
    NSMutableParagraphStyle *pghStyle = [[NSMutableParagraphStyle alloc] init];
    pghStyle.alignment = NSTextAlignmentCenter;
    NSMutableDictionary *attrText = [[NSMutableDictionary alloc] init];
    [attrText setValue:color forKey:NSForegroundColorAttributeName];
    [attrText setValue:[NSFont fontWithName:IMBCommonFont size:12.0] forKey:NSFontAttributeName];
    [attrText setValue:pghStyle forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"OK" attributes:attrText];
    [self setAttributedTitle:attrString];
    
    [pghStyle release];
    pghStyle = nil;
    [attrText release];
    attrText = nil;
    [attrString release];
    attrString = nil;
}

@end
