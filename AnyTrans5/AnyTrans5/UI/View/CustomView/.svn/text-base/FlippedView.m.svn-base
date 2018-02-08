//
//  FlippedView.m
//  iMobieTrans
//
//  Created by apple on 6/21/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "FlippedView.h"
#import "StringHelper.h"

@implementation FlippedView
@synthesize drawDivider = _drawDivider;
@synthesize backgroundColor = _backGroundColor;
@synthesize isListVeiw = _isListView;
@synthesize isDrawRightLine = _isDrawRightLine;
@synthesize isDrawTopLine = _isDrawTopLine;
@synthesize isDrawBroderLine = _isDrawBroderLine;
@synthesize isDrawImageBroder = _isDrawImageBroder;
@synthesize isDrawLeftLine = _isDrawLeftLine;
@synthesize allRightLine = _allRightLine;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _drawDivider = false;
        _isListView = NO;
        _isDrawTopLine = NO;
        _isDrawRightLine = NO;
        _isListView = NO;
        _isDrawBroderLine = NO;
        _isDrawLeftLine = NO;
        _allRightLine = NO;
    }
    return self;
}

- (BOOL)isFlipped{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
//    [[NSColor colorWithDeviceRed:1.0 green:0 blue:0 alpha:0.3] setFill];
//    NSRectFill(dirtyRect);
    if (_backGroundColor != nil) {
        if (_isListView) {
            NSRect drRect = NSMakeRect(0, 0, dirtyRect.size.width, dirtyRect.size.height);
            NSBezierPath *path = [NSBezierPath bezierPath];
            [_backGroundColor set];
            
            [path moveToPoint:NSMakePoint(16, 0)];
            [path lineToPoint:NSMakePoint(10, 6)];
            [path lineToPoint:NSMakePoint(0, 6)];
            [path lineToPoint:NSMakePoint(0, drRect.size.height)];
            [path lineToPoint:NSMakePoint(drRect.size.width, drRect.size.height)];
            [path lineToPoint:NSMakePoint(drRect.size.width, 6)];
            [path lineToPoint:NSMakePoint(22, 6)];
            [path lineToPoint:NSMakePoint(16, 0)];
            
            [path fill];
            [path closePath];
        }else {
            [_backGroundColor set];
            NSRectFill(dirtyRect);
        }
    }
    if (_drawDivider) {
        [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] set];
        NSBezierPath *topBezier = [NSBezierPath bezierPath];
        [topBezier moveToPoint:NSMakePoint(0, 1)];
        [topBezier lineToPoint:NSMakePoint(dirtyRect.size.width, 1)];
        [topBezier setLineWidth:0.2];
        [topBezier stroke];
        [topBezier closePath];
        
        NSBezierPath *bottomBezier = [NSBezierPath bezierPath];
        [bottomBezier moveToPoint:NSMakePoint(0, dirtyRect.size.height - 1)];
        [bottomBezier lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height - 1)];
        [bottomBezier setLineWidth:0.2];
        [bottomBezier stroke];
        [bottomBezier closePath];
        
    }
    if (_isDrawRightLine&&!_allRightLine) {
        [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] set];
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(dirtyRect.size.width, 0)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height - 33)];
        [path setLineWidth:1];
        [path stroke];
        [path closePath];
    }else if (_isDrawRightLine&&_allRightLine)
    {
        [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] set];
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(dirtyRect.size.width, 0)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height)];
        [path setLineWidth:1];
        [path stroke];
        [path closePath];
    }
    
    if (_isDrawLeftLine) {
        [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] set];
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(0, 0)];
        [path lineToPoint:NSMakePoint(0, dirtyRect.size.height)];
        [path setLineWidth:1];
        [path stroke];
        [path closePath];
    }
    
    if (_isDrawTopLine) {
        [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] set];
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(0, 0)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width, 0)];
        [path setLineWidth:1];
        [path stroke];
        [path closePath];
    }
    
    if (_isDrawBroderLine) {
        [[StringHelper getColorFromString:CustomColor(@"line_windowColor", nil)] set];
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(0, 0)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width, 0)];
        [path moveToPoint:NSMakePoint(dirtyRect.size.width, 1)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height)];
        [path moveToPoint:NSMakePoint(dirtyRect.size.width - 1, dirtyRect.size.height)];
        [path lineToPoint:NSMakePoint(0, dirtyRect.size.height)];
        [path moveToPoint:NSMakePoint(0, dirtyRect.size.height - 1)];
        [path lineToPoint:NSMakePoint(0, 1)];
        [path setLineWidth:1];
        [path stroke];
        [path closePath];
    }
    
    if (_isDrawImageBroder) {
        //draw top
        NSImage *imageTop = [StringHelper imageNamed:@"qt_box_top"];
        NSRect drawRect;
        drawRect.origin = NSMakePoint(0, 0);
        drawRect.size = imageTop.size;
        NSRect imageRect;
        imageRect.origin = NSMakePoint(0, 0);
        imageRect.size = imageTop.size;
        
        [imageTop drawInRect:drawRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        
        //draw bottom
        NSImage *imagebottom = [StringHelper imageNamed:@"qt_box_bottom"];
        drawRect.origin = NSMakePoint(0, dirtyRect.size.height - imagebottom.size.height);
        drawRect.size = imagebottom.size;
        
        imageRect.origin = NSMakePoint(0, 0);
        imageRect.size = imagebottom.size;
        
        [imagebottom drawInRect:drawRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        
        //draw middle
        NSImage *imageMid = [StringHelper imageNamed:@"qt_box_middle"];
        int yCount = ceil((dirtyRect.size.height - imagebottom.size.height - imageTop.size.height) / imageMid.size.height);
        for (int i = 0; i < yCount; i ++) {
            drawRect.origin = NSMakePoint(0, (i+1) * imageMid.size.height);
            drawRect.size = imageMid.size;
            
            imageRect.origin = NSMakePoint(0, 0);
            imageRect.size = imageMid.size;
            
            [imageMid drawInRect:drawRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
        
    }
    
    if (_borderColor != nil) {
        [_borderColor set];
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(0, 0)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width, 0)];
        [path moveToPoint:NSMakePoint(dirtyRect.size.width, 1)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height)];
        [path moveToPoint:NSMakePoint(dirtyRect.size.width - 1, dirtyRect.size.height)];
        [path lineToPoint:NSMakePoint(0, dirtyRect.size.height)];
        [path moveToPoint:NSMakePoint(0, dirtyRect.size.height - 1)];
        [path lineToPoint:NSMakePoint(0, 1)];
        [path setLineWidth:1];
        [path stroke];
        [path closePath];
    }
}

- (void)setBackgroundColor:(NSColor *)backgroundColor{
    if (_backGroundColor) {
        [_backGroundColor release];
        _backGroundColor = nil;
    }
    _backGroundColor = [backgroundColor retain];
    [self setNeedsDisplay:YES];
}

- (void)setBorderColor:(NSColor *)borderColor {
    if (_borderColor != nil) {
        [_borderColor release];
        _borderColor = nil;
    }
    _borderColor = [borderColor retain];
    [self setNeedsDisplay:YES];
}

- (void)setDrawDivider:(BOOL)drawDivider{
    _drawDivider = drawDivider;
    [self setNeedsDisplay:YES];
}

- (void)setDrawRightLine:(BOOL)isDrawRightLine {
    _isDrawRightLine = isDrawRightLine;
    [self setNeedsDisplay:YES];
}

- (void)setDrawLeftLine:(BOOL)isDrawLeftLine {
    _isDrawLeftLine = isDrawLeftLine;
    [self setNeedsDisplay:YES];
}

- (void)setDrawTopLine:(BOOL)isDrawTopLine {
    _isDrawTopLine = isDrawTopLine;
    [self setNeedsDisplay:YES];
}

- (void)setDrawBroderLine:(BOOL)isDrawBroderLine {
    _isDrawBroderLine = isDrawBroderLine;
    [self setNeedsDisplay:YES];
}

- (void)setDrawImageBroder:(BOOL)isDrawImageBroder {
    if (_isDrawImageBroder != isDrawImageBroder) {
        _isDrawImageBroder = isDrawImageBroder;
        [self setNeedsDisplay:YES];
    }
}

- (void)setAllRightLine:(BOOL)allRightLine
{
    if (_allRightLine != allRightLine) {
        _allRightLine = allRightLine;
        [self setNeedsDisplay:YES];
    }
}
- (void)dealloc{
    if (_backGroundColor) {
        [_backGroundColor release];
        _backGroundColor = nil;
    }
    if (_borderColor != nil) {
        [_borderColor release];
        _borderColor = nil;
    }
    [super dealloc];
}

@end
