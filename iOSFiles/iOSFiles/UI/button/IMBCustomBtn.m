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
    if (_state) {
        [self setImage:[NSImage imageNamed:@"mod_icon_psd_eye_hover"]];
    }else {
        [self setImage:[NSImage imageNamed:@"mod_icon_psd_eye"]];
    }
    
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [[NSCursor arrowCursor] set];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [[NSCursor IBeamCursor] set];
}

@end
