//
//  IMBBGColoerView.m
//  iMobieTrans
//
//  Created by zhang yang on 13-8-13.
//  Copyright (c) 2013年 iMobie Inc. All rights reserved.
//

#import "IMBBGColoerView.h"

@implementation IMBBGColoerView
@synthesize background = _background;
@synthesize isBorder = _isBorder;
@synthesize topBorder = _topBorder;
@synthesize bottomBorder = _bottomBorder;
@synthesize rightBorder = _rightBorder;
@synthesize leftBorder = _leftBorder;
- (void)dealloc
{
    if (_background != nil) {
        [_background release];
    }
    [super dealloc];
}


-(void)setBackground:(NSColor *)aColor
{
    if([_background isEqual:aColor]) return;
    [_background release];
    _background = [aColor retain];
    
    //This is the most crucial thing you're missing: make the view redraw itself
    [self setNeedsDisplay:YES];
}

- (void)awakeFromNib
{
     _isBorder = NO;
    [super awakeFromNib];
   
}

- (void)setIsBorder:(BOOL)isBorder
{
    if (_isBorder != isBorder) {
        _isBorder = isBorder;
        [self setNeedsDisplay:YES];
    }
}
- (void)drawRect:(NSRect)dirtyRect
{
   NSBezierPath *textViewSurround = [NSBezierPath bezierPathWithRect:dirtyRect];
    if (_background == nil) {
        _background = [[NSColor colorWithCalibratedRed:240.0/256.0 green:240.0/256.0 blue:240.0/256.0 alpha:1 ] retain];
    }
        [_background set];
        [textViewSurround fill];
    
    //边框
    if (!_isBorder) {
        [_background set];
        [textViewSurround fill];
       

    }else
    {
//        NSBezierPath *path2 = [NSBezierPath bezierPath];
//       [path2 moveToPoint:NSMakePoint(dirtyRect.size.width - 22, 0)];
//        [path2 lineToPoint:NSMakePoint(dirtyRect.size.width - 22,dirtyRect.size.height)];
//        [[NSColor colorWithCalibratedRed:227.0/255 green:226.0/255 blue:226.0/255 alpha:1.0] setStroke];
//        [path2 stroke];
//        NSBezierPath *path3 = [NSBezierPath bezierPath];
//        [path3 moveToPoint:NSMakePoint(dirtyRect.size.width - 44, 0)];
//        [path3 lineToPoint:NSMakePoint(dirtyRect.size.width - 44,dirtyRect.size.height)];
//        [[NSColor colorWithCalibratedRed:227.0/255 green:226.0/255 blue:226.0/255 alpha:1.0] setStroke];
//        [path3 stroke];
    }
    
    if (_topBorder) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path setLineWidth:2.0];
        [path moveToPoint:NSMakePoint(dirtyRect.origin.x, dirtyRect.size.height)];
        [path lineToPoint:NSMakePoint(dirtyRect.origin.x+dirtyRect.size.width,dirtyRect.size.height)];
        [[NSColor colorWithCalibratedRed:227.0/255 green:226.0/255 blue:226.0/255 alpha:1.0] setStroke];
        [path stroke];
    }
    if (_rightBorder) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path setLineWidth:2.0];
        [path moveToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width,0)];
         [[NSColor colorWithCalibratedRed:227.0/255 green:226.0/255 blue:226.0/255 alpha:1.0] setStroke];
        [path stroke];
    }
    if (_bottomBorder) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path setLineWidth:2.0];
        [path moveToPoint:NSMakePoint(0, 0)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width,0)];
        [[NSColor colorWithCalibratedRed:227.0/255 green:226.0/255 blue:226.0/255 alpha:1.0] setStroke];
        //[[NSColor redColor] setStroke];
        [path stroke];
    }
    if (_leftBorder) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path setLineWidth:2.0];
        [path moveToPoint:NSMakePoint(0, 0)];
        [path lineToPoint:NSMakePoint(0,dirtyRect.size.height)];
        [[NSColor colorWithCalibratedRed:227.0/255 green:226.0/255 blue:226.0/255 alpha:1.0] setStroke];
        [path stroke];
    }

    
}

@end
