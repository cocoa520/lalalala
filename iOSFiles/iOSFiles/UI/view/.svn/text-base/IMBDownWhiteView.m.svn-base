//
//  IMBDownWhiteView.m
//  iOSFiles
//
//  Created by 龙凡 on 2018/3/22.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBDownWhiteView.h"

@implementation IMBDownWhiteView
@synthesize haveBottomLine = _haveBottomLine;
@synthesize delegate = _delegate;
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:dirtyRect];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    [clipPath addClip];
    [[NSColor colorWithDeviceRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1] set];
    [clipPath fill];
    [clipPath closePath];
    
    if (_haveBottomLine) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(NSMinX(dirtyRect), NSMinY(dirtyRect))];
        [path lineToPoint:NSMakePoint(NSMaxX(dirtyRect), NSMinY(dirtyRect))];
        [path setLineWidth:2.f];
        [[NSColor colorWithDeviceRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1] set];
        [path stroke];
        [path closePath];
        //        _isBommt = NO;
    }
}

-(void)mouseDown:(NSEvent *)theEvent  {
    [super mouseDown:theEvent];
    _haveBottomLine = YES;
}
@end
