//
//  IMBCustomBtn.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/14.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBCustomBtn.h"

@implementation IMBCustomBtn

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
    _state = NO;
    [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:0];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [self setNeedsDisplay:YES];
    [NSApp sendAction:self.action to:self.target from:self];
    _state = !_state;
//    给的图片尺寸太小了，必须得等图片大了之后再设置这个功能
    if (_state) {
        [self setImage:[NSImage imageNamed:@"symbols-eye-hover"]];
    }else {
        [self setImage:[NSImage imageNamed:@"symbols-eye"]];
    }
    
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [[NSCursor arrowCursor] set];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [[NSCursor IBeamCursor] set];
}

@end
