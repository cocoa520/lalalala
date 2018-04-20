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

@implementation IMBGeneralButton
@synthesize bgColor = _bgColor;
@synthesize titleColor = _titleColor;
@synthesize hasBorder = _hasBorder;

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
        [_bgColor set];
        [path addClip];
        [path fill];
    }
    
    [path setLineWidth:2.f];
    [path addClip];
    if (_hasBorder) {
        [Progress_BgColor setStroke];
        [path stroke];
    }

    if (_titleColor) {
         NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[[NSFont fontWithName:IMBCommonFont size:12.0], _titleColor] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
        NSRect titleRect = [StringHelper calcuTextBounds:self.title fontSize:12];
        [self.title drawInRect:NSMakeRect(ceil((dirtyRect.size.width - titleRect.size.width)/2.0),(dirtyRect.size.height - titleRect.size.height) / 2.0 - 2, titleRect.size.width, titleRect.size.height) withAttributes:dic];
    }else {
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[[NSFont fontWithName:IMBCommonFont size:12.0], COLOR_TEXT_ORDINARY] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
        NSRect titleRect = [StringHelper calcuTextBounds:self.title fontSize:12];
        [self.title drawInRect:NSMakeRect(ceil((dirtyRect.size.width - titleRect.size.width)/2.0),(dirtyRect.size.height - titleRect.size.height) / 2.0 - 2, titleRect.size.width, titleRect.size.height) withAttributes:dic];
    }
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



@end
