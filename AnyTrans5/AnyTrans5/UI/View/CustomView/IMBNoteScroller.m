//
//  IMBNoteScroller.m
//  NewMacTestApp
//
//  Created by iMobie on 5/27/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import "IMBNoteScroller.h"
#import <Quartz/Quartz.h>
#import "NSBezierPath+BezierPathQuartzUtilities.h"

@implementation IMBNoteScroller

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

//- (void)setFrameOrigin:(NSPoint)newOrigin{
//    NSPoint originPoint = self.frame.origin;
//    [super setFrameOrigin:newOrigin];
//    if (originPoint.x != newOrigin.x || originPoint.y != newOrigin.y) {
//        [self setNeedsDisplay];
//    }
//}

- (void)awakeFromNib
{
    [self setAlphaValue:0.0];
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    if (_trackingArea == nil) {
        NSTrackingAreaOptions options =  (NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate);
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil] ;
        [self addTrackingArea:_trackingArea];
    }
}


- (void)drawRect:(NSRect)dirtyRect
{
//    [super drawRect:dirtyRect];
//    
//    // Drawing code here.
//    NSSize newSize = NSMakeSize(12,self.frame.size.height);
//    NSRect newRect = NSMakeRect(dirtyRect.origin.x + dirtyRect.size.width - 12, dirtyRect.origin.y, 12, dirtyRect.size.height);
//    dirtyRect = self.bounds;
//    [self drawBackground:dirtyRect];
    [self drawKnob];
   
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [self setAlphaValue:1.0];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [self setAlphaValue:0.0];

}

- (void) drawBackground:(NSRect) rect{
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:3 yRadius:3];
    [path setLineWidth:2.0];
    [[NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:0.3] set];

//    [path fill];
    if (!isAddLayer) {
        [self setWantsLayer:YES];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        [layer setShadowColor:CGColorCreateGenericRGB(242/255, 242/255, 242/255, 0.4)];
        [layer setShadowOffset:CGSizeMake(-2, 0)];
        [layer setShadowOpacity:0.1];
        [layer setShadowPath:[path quartzPath]];
        [layer setFillColor:CGColorCreateGenericRGB(1.0, 1.0, 1.0, 0)];
        [layer setPath:[path quartzPath]];
        [self.layer addSublayer:layer];
        isAddLayer = true;
    }
}

-(void)drawKnob {
    NSView *superView = self.superview;
    float scrollViewheight = 0;
    BOOL shouldShowKnob = true;
    while (superView != nil) {
        if([superView isKindOfClass:[NSScrollView class]]){
            scrollViewheight = superView.frame.size.height;
            NSView *documentView = [((NSScrollView *)superView) documentView];
            if (documentView.frame.size.height <= scrollViewheight) {
                shouldShowKnob = NO;
            }
            break;
        }
        superView = [superView superview];
    }
    if(shouldShowKnob)
        [super drawKnob];
}

- (void)dealloc
{
    [_trackingArea release],_trackingArea = nil;
    [super dealloc];
}

@end

