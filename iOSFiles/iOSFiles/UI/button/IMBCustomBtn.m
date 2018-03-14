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

- (void)mouseDown:(NSEvent *)theEvent {
    [self setNeedsDisplay:YES];
    [NSApp sendAction:self.action to:self.target from:self];
}

@end
