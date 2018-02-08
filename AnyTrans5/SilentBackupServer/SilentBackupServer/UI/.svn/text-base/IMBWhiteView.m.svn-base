//  IMBWhiteView.m
//  DataRecovery
//
//  Created by iMobie on 5/7/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBWhiteView.h"

@implementation IMBWhiteView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)viewWillDraw {
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    [clipPath addClip];

    [[NSColor colorWithDeviceRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0] set];

    [clipPath fill];
    [clipPath closePath];
}

@end

