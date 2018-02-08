//
//  IMBLrregularView.m
//  PhoneRescue
//
//  Created by iMobie on 4/6/16.
//  Copyright (c) 2016 iMobie Inc. All rights reserved.
//

#import "IMBLrregularView.h"
#define LINE 8

@implementation IMBLrregularView
@synthesize isMainNavigationView = _isMainNavigationView;
@synthesize backGroudColor = _backGroudColor;
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
    
    // Drawing code here.
    if (_isMainNavigationView) {
        NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:dirtyRect];
        [clipPath setWindingRule:NSEvenOddWindingRule];
        [clipPath addClip];
        [[NSColor whiteColor] set];
        [self setAlphaValue:0.96];
        [clipPath fill];
    }else {
        NSBezierPath *path = [NSBezierPath bezierPath];

        [path moveToPoint:NSMakePoint(NSMinX(dirtyRect) +LINE, NSMinY(dirtyRect))];
        [path lineToPoint:NSMakePoint(NSMaxX(dirtyRect)-LINE, NSMinY(dirtyRect))];
        [path lineToPoint:NSMakePoint(NSMaxX(dirtyRect)-LINE, NSMinY(dirtyRect)+LINE)];
        [path lineToPoint:NSMakePoint(NSMaxX(dirtyRect), NSMinY(dirtyRect)+LINE)];
        [path lineToPoint:NSMakePoint(NSMaxX(dirtyRect), NSMaxY(dirtyRect) - LINE)];
        [path lineToPoint:NSMakePoint(NSMaxX(dirtyRect) - LINE, NSMaxY(dirtyRect) - LINE)];
        [path lineToPoint:NSMakePoint(NSMaxX(dirtyRect) - LINE, NSMaxY(dirtyRect))];
        [path lineToPoint:NSMakePoint(NSMinX(dirtyRect) + LINE, NSMaxY(dirtyRect))];
        [path lineToPoint:NSMakePoint(NSMinX(dirtyRect) + LINE, NSMaxY(dirtyRect) - LINE)];
        [path lineToPoint:NSMakePoint(NSMinX(dirtyRect), NSMaxY(dirtyRect) - LINE)];
        [path lineToPoint:NSMakePoint(NSMinX(dirtyRect), NSMinY(dirtyRect)+LINE)];
        [path lineToPoint:NSMakePoint(NSMinX(dirtyRect)+LINE, NSMinY(dirtyRect)+LINE)];
        [path lineToPoint:NSMakePoint(NSMinX(dirtyRect)+LINE, NSMinY(dirtyRect))];
        [path closePath];
        if (_backGroudColor != nil) {
            [_backGroudColor set];
        }else{
            if (_isMainNavigationView) {
                [[NSColor whiteColor] set];
                [self setAlphaValue:0.96];
            }else{
                [[NSColor whiteColor] set];
            }
        }
        [path fill];
    }
}

-(void)mouseDown:(NSEvent *)theEvent{
    
}

- (void)mouseUp:(NSEvent *)theEvent
{
    
}

-(void)mouseExited:(NSEvent *)theEvent{
}

-(void)mouseMoved:(NSEvent *)theEvent{
}

-(void)mouseEntered:(NSEvent *)theEvent{
}

@end
