//
//  IMBPopOverView.m
//  AnyTrans
//
//  Created by m on 11/8/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBPopOverView.h"

@implementation IMBPopOverView
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
    [shadow setShadowColor:[NSColor colorWithDeviceRed:204.f/255 green:204.f/255 blue:204.f/255 alpha:1.0]];
    [shadow setShadowOffset:NSMakeSize(0.0, -1)];
    [shadow setShadowBlurRadius:3];
    [shadow set];
    
    NSRect newRect = NSMakeRect(dirtyRect.origin.x+3, dirtyRect.origin.y+4, dirtyRect.size.width-6, dirtyRect.size.height-6);
    NSBezierPath *text = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:5 yRadius:5];

//    [[NSColor whiteColor] set];
//    [text fill];
    
    [[NSColor colorWithCalibratedWhite:0.9 alpha:0.0] set];
    [text stroke];
    [text closePath];
}

@end
