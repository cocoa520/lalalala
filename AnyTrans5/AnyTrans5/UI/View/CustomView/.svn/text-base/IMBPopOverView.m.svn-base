//
//  IMBPopOverView.m
//  AnyTrans
//
//  Created by m on 11/8/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBPopOverView.h"
#import "StringHelper.h"
#import "SystemHelper.h"
#import "NSString+Compare.h"
#import "IMBNotificationDefine.h"
#import "NSBezierPath+BezierPathQuartzUtilities.h"
#import <QuartzCore/QuartzCore.h>
#import "SystemHelper.h"
@implementation IMBPopOverView
@synthesize isUP = _isUP;
@synthesize hasSet = _hasSet;
- (void)drawRect:(NSRect)dirtyRect {
    if (_hasSet&&!_isUP) {
        NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
        [shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"popover_shadowColor", nil)]];
        [shadow setShadowOffset:NSMakeSize(0.0, -1)];
        [shadow setShadowBlurRadius:3];
        [shadow set];
        
        [super drawRect:dirtyRect];
        
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(dirtyRect.size.width/2.0, 1)];
        [path lineToPoint:NSMakePoint(6, 1)];
        [path appendBezierPathWithArcWithCenter:NSMakePoint(6, 6) radius:5 startAngle:270 endAngle:180 clockwise:YES];
        [path lineToPoint:NSMakePoint(1, dirtyRect.size.height - 13)];
        [path appendBezierPathWithArcWithCenter:NSMakePoint(6, dirtyRect.size.height  - 13) radius:5 startAngle:180 endAngle:90 clockwise:YES];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width/2.0 - 6, dirtyRect.size.height-8)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width/2.0, dirtyRect.size.height - 2)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width/2.0+6, dirtyRect.size.height - 8)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width - 6, dirtyRect.size.height - 8)];
        
        [path appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.size.width - 6,  dirtyRect.size.height - 13) radius:5 startAngle:90 endAngle:0 clockwise:YES];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width - 1 , 6)];
        [path appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.size.width - 6, 6) radius:5 startAngle:0 endAngle:270 clockwise:YES];
        [path closePath];
        [[StringHelper getColorFromString:CustomColor(@"popover_bgColor", nil)] setFill];
        [path fill];
        
        [[StringHelper getColorFromString:CustomColor(@"popover_shadowColor", nil)] set];
        if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
            [path setLineWidth:0.4];
        }else {
            [path setLineWidth:1];
        }
        [path stroke];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [path quartzPath];
        shapeLayer.backgroundColor = [NSColor redColor].CGColor;
        [self setWantsLayer:YES];
        [self.layer setMask:shapeLayer];
        [self.layer setMasksToBounds:YES];
        
    }else {
        NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
        [shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"popover_shadowColor", nil)]];
        [shadow setShadowOffset:NSMakeSize(0, -1)];
        [shadow setShadowBlurRadius:3];
        [shadow set];
        
        [super drawRect:dirtyRect];
        
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(dirtyRect.size.width/2.0, 2)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width/2.0 - 6, 8)];
        [path lineToPoint:NSMakePoint(6, 8)];
        [path appendBezierPathWithArcWithCenter:NSMakePoint(6, 13) radius:5 startAngle:270 endAngle:180 clockwise:YES];
        [path lineToPoint:NSMakePoint(1, dirtyRect.size.height - 6)];
        [path appendBezierPathWithArcWithCenter:NSMakePoint(6, dirtyRect.size.height  - 6) radius:5 startAngle:180 endAngle:90 clockwise:YES];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width - 6, dirtyRect.size.height - 1)];
        [path appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.size.width - 6,  dirtyRect.size.height - 6) radius:5 startAngle:90 endAngle:0 clockwise:YES];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width - 1 , 13)];
        [path appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.size.width - 6, 13) radius:5 startAngle:0 endAngle:270 clockwise:YES];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width/2.0 + 6, 8)];
        [path closePath];
//        [path addClip];
        [[StringHelper getColorFromString:CustomColor(@"popover_bgColor", nil)] setFill];
        [path fill];
        
        [[StringHelper getColorFromString:CustomColor(@"popover_shadowColor", nil)] set];
        [path setLineWidth:0.4];
        [path stroke];
    }
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea)
    {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    
    NSTrackingAreaOptions options =  NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveAlways;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)mouseMoved:(NSEvent *)theEvent {
    NSPoint localPoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL mouseInside = NSMouseInRect(localPoint, [self bounds], [self isFlipped]);
    if (mouseInside) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MOUSEENTER_NAVWINDOW object:nil userInfo:@{@"state":@"mouseEnter"}];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MOUSEEXIT_NAVWINDOW object:nil userInfo:@{@"state":@"mouseExite"}];
        NSLog(@"======mouseOut");
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MOUSEEXIT_NAVWINDOW object:nil userInfo:@{@"state":@"mouseExite"}];
}

- (void)setIsUP:(BOOL)isUP {
    _isUP = isUP;
    _hasSet = YES;
    [self setNeedsDisplay:YES];
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    if (_backgroundColor != nil) {
        [_backgroundColor release];
        _backgroundColor = nil;
    }
    _backgroundColor = [backgroundColor retain];
    [self setNeedsDisplay:YES];
}



-(void)dealloc {
    if (_backgroundColor != nil) {
        [_backgroundColor release];
        _backgroundColor = nil;
    }
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

@end
