//  IMBWhiteView.m
//  DataRecovery
//
//  Created by iMobie on 5/7/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBWhiteView.h"
#import "StringHelper.h"
@implementation IMBWhiteView
@synthesize isHaveLine = _isHaveLine;
@synthesize isNOCanDraw = _isNOCanDraw;
@synthesize isBommt = _isBommt;
@synthesize isUpline = _isUpline;
@synthesize isRegistedTextView = _isRegistedTextView;
@synthesize isDrawFrame = _isDrawFrame;
@synthesize hasCorner = _hasCorner;
@synthesize isGradientColorNOCornerPart3 = _isGradientColorNOCornerPart3;
@synthesize isGradientColorNOCornerPart4 = _isGradientColorNOCornerPart4;
@synthesize isMove = _isMove;
@synthesize isDeviceMain = _isDeviceMain;
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)dealloc {
    if (_backgroundColor != nil) {
        [_backgroundColor release];
        _backgroundColor = nil;
    }
    if (_borderColor != nil) {
        [_borderColor release];
        _borderColor = nil;
    }
    [super dealloc];
}

- (void)viewWillDraw {
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

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:dirtyRect];
    if (_backgroundColor != nil) {
        //[NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5.0 yRadius:5.0];
        [clipPath setWindingRule:NSEvenOddWindingRule];
        [clipPath addClip];
        [_backgroundColor set];
        [clipPath fill];
    }else {
        // Drawing code here.
        //NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5.0 yRadius:5.0];
 
        [clipPath setWindingRule:NSEvenOddWindingRule];
        [clipPath addClip];
        [[NSColor colorWithDeviceRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1] set];
        [clipPath fill];
        
    }
    [clipPath closePath];
    
    if (_isHaveLine) {
        NSRect rect = dirtyRect;
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(0, 0)];
        [path lineToPoint:NSMakePoint(rect.size.width,0)];
        [[NSColor colorWithDeviceRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1] setStroke];
        [path stroke];
    }
    //draw top line
    if (_isUpline) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(NSMinX(dirtyRect), NSMaxY(dirtyRect))];
        [path lineToPoint:NSMakePoint(NSMaxX(dirtyRect), NSMaxY(dirtyRect))];
        [path setLineWidth:2.f];
        [[NSColor colorWithDeviceRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1] set];
        [path stroke];
        [path closePath];
        _isUpline = NO;
    }
    //draw fillet
    if (_isRegistedTextView) {
        NSBezierPath *cPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5.0 yRadius:5.0];
        [cPath setLineWidth:2];
        [cPath addClip];
        [[NSColor colorWithDeviceRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1] set];
        [cPath stroke];
        [cPath closePath];
    }
    
    //最下面的线
    if (_isBommt) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(NSMinX(dirtyRect), NSMinY(dirtyRect))];
        [path lineToPoint:NSMakePoint(NSMaxX(dirtyRect), NSMinY(dirtyRect))];
        [path setLineWidth:2.f];
        [[NSColor colorWithDeviceRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1] set];
        [path stroke];
        [path closePath];
        //        _isBommt = NO;
    }
    
    //画四条线
    if (_isDrawFrame) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(NSMinX(dirtyRect), NSMaxY(dirtyRect))];
        [path lineToPoint:NSMakePoint(NSMaxX(dirtyRect), NSMaxY(dirtyRect))];
        [path lineToPoint:NSMakePoint(NSMaxX(dirtyRect), NSMinY(dirtyRect))];
        [path lineToPoint:NSMakePoint(NSMinX(dirtyRect), NSMinY(dirtyRect))];
        [path lineToPoint:NSMakePoint(NSMinX(dirtyRect), NSMaxY(dirtyRect))];
        [path setLineWidth:2.f];
        if (_borderColor) {
            [_borderColor set];
        }else {
            [[NSColor colorWithDeviceRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1] set];
        }
        [path stroke];
        [path closePath];
    }
    if (_hasCorner) {
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:2 yRadius:2];
        [[NSColor colorWithDeviceRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1] set];
        [path addClip];
        [path setLineWidth:2];
        [path stroke];
        [path closePath];
    }
}

-(BOOL)mouseDownCanMoveWindow {
    if (_isNOCanDraw) {
        return NO;
    }else{
        return YES;
    }
    
}

- (void)setIsDrawFrame:(BOOL)isDrawFrame {
    if (_isDrawFrame != isDrawFrame) {
        _isDrawFrame = isDrawFrame;
        [self setNeedsDisplay:YES];
    }
}

- (void)setBorderColor:(NSColor *)borderColor {
    _borderColor = [borderColor retain];
}

-(void)mouseDown:(NSEvent *)theEvent  {
    if (!_isMove) {
        [super mouseDown:theEvent];
    }
}

-(void)mouseExited:(NSEvent *)theEvent {
    if (!_isMove) {
        [super mouseExited:theEvent];
    }
}

-(void)mouseEntered:(NSEvent *)theEvent {
    if (!_isMove) {
        [super mouseEntered:theEvent];
    }
    
}

@end

