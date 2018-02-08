//
//  IMBMessageView.m
//  DataRecovery
//
//  Created by iMobie on 6/3/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBMessageView.h"

@implementation IMBMessageView
@synthesize isMMS = _isMMS;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)dealloc
{
    if (_backgroundColor != nil) {
        [_backgroundColor release];
        _backgroundColor = nil;
    }
    [super dealloc];
}

- (BOOL)isFlipped {
    return YES;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    _backgroundColor = [backgroundColor retain];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSBezierPath *clipPath = nil;
    if (_isMMS) {
        clipPath = [NSBezierPath bezierPathWithRect:dirtyRect];
    }else{
        clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:10.0 yRadius:10.0];
    }
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
        [[NSColor whiteColor] set];
        [clipPath fill];
    }
    [clipPath closePath];
	[super drawRect:dirtyRect];
}


@end
