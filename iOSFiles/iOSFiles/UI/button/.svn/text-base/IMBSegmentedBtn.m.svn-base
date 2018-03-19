//
//  IMBSegmentedBtn.m
//  AnyTrans
//
//  Created by iMobie on 7/30/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBSegmentedBtn.h"
#import "StringHelper.h"
#import "IMBCommonDefine.h"
@implementation IMBSegmentedBtn

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)updateTrackingAreas
{
	[super updateTrackingAreas];
	if (trackingArea)
	{
		[self removeTrackingArea:trackingArea];
		[trackingArea release];
	}
	
	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
	trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
}

-(void)setMouseEnteredImage:(NSImage *)image1 mouseExitImage:(NSImage *)image2 mouseDownImage:(NSImage *)image3 rightMouseEnteredImage:(NSImage *)image4 rightMouseExitImage:(NSImage *)image5 rightMouseDownImage:(NSImage *)image6
{
    _leftMouseEnteredImage=[image1 retain];
    _leftMouseExitImage=[image2 retain];
    _leftMouseDownImage=[image3 retain];
    _rightMouseEnteredImage = [image4 retain];
    _rightMouseExitImage = [image5 retain];
    _rightMouseDownImage = [image6 retain];
    //    [self setImage:image2];
    [self setNeedsDisplay:YES];
}

- (void)setSelectedSegment:(NSInteger)selectedSegment {
    if (super.selectedSegment != selectedSegment) {
        super.selectedSegment = selectedSegment;
        if (super.selectedSegment == 0) {
            _leftStatus = 3;
            _rightStatus = 1;
        }else {
            _leftStatus = 1;
            _rightStatus = 3;
        }
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseDown:(NSEvent *)theEvent{
    if (self.isEnabled) {
        NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
        NSRect leftRect = NSMakeRect(0, 0, [self bounds].size.width / 2, [self bounds].size.height);
        NSRect rightRect = NSMakeRect([self bounds].size.width / 2, 0, [self bounds].size.width / 2, [self bounds].size.height);
        BOOL inner = NSMouseInRect(point, leftRect, [self isFlipped]);
        if (inner) {
            [self setSelectedSegment:0];
            [NSApp sendAction:self.action to:self.target from:self];
        }else {
            BOOL rightInner = NSMouseInRect(point, rightRect, [self isFlipped]);
            if (rightInner) {
                [self setSelectedSegment:1];
                [NSApp sendAction:self.action to:self.target from:self];
            }
        }
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    [clipPath addClip];
    [clipPath setLineWidth:2];
    [clipPath closePath];
    
    [[NSColor whiteColor] setFill];
    [clipPath fill];
    [COLOR_TEXT_BUTTON_PERMANENT setStroke];
    [clipPath stroke];

    if (super.selectedSegment == 0) {
        NSImage *rightImage = nil;
        if (_rightStatus == 1) {
            rightImage = _rightMouseExitImage;
        }else if (_rightStatus == 2) {
            rightImage = _rightMouseEnteredImage;
        }else if (_rightStatus == 3) {
            rightImage = _rightMouseDownImage;
        }
        
        if (rightImage) {
            NSRect souRect;
            souRect.origin = NSZeroPoint;
            souRect.size = rightImage.size;
            NSRect tarRect;
            tarRect.origin = NSMakePoint((dirtyRect.size.width / 2 - rightImage.size.width) / 2 + dirtyRect.size.width / 2, (dirtyRect.size.height - rightImage.size.height) / 2);
            tarRect.size = rightImage.size;
            [rightImage drawInRect:tarRect fromRect:souRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
        
        if (_leftStatus == 3) {
            NSBezierPath *leftPath = [NSBezierPath bezierPath];
            [leftPath moveToPoint:NSMakePoint(dirtyRect.size.width/2, 0)];
            [leftPath lineToPoint:NSMakePoint(5, 0)];
            [leftPath appendBezierPathWithArcWithCenter:NSMakePoint(5, 5) radius:5 startAngle:-90 endAngle:-180 clockwise:YES];
            [leftPath lineToPoint:NSMakePoint(0, dirtyRect.size.height - 5)];
            [leftPath appendBezierPathWithArcWithCenter:NSMakePoint(5, dirtyRect.size.height - 5) radius:5 startAngle:-180 endAngle:-270 clockwise:YES];
            [leftPath lineToPoint:NSMakePoint(dirtyRect.size.width/2, dirtyRect.size.height)];
            [leftPath lineToPoint:NSMakePoint(dirtyRect.size.width/2, 0)];
            [leftPath setLineWidth:2];
            [leftPath addClip];
            [leftPath closePath];
            [COLOR_BUTTON_SEG setFill];
            [leftPath fill];
            [COLOR_BUTTON_SEGDOWN setStroke];
            [leftPath stroke];
        }else if (_leftStatus == 4) {
            NSBezierPath *leftPath = [NSBezierPath bezierPath];
            [leftPath moveToPoint:NSMakePoint(dirtyRect.size.width/2, 0)];
            [leftPath lineToPoint:NSMakePoint(5, 0)];
            [leftPath appendBezierPathWithArcWithCenter:NSMakePoint(5, 5) radius:5 startAngle:-90 endAngle:-180 clockwise:YES];
            [leftPath lineToPoint:NSMakePoint(0, dirtyRect.size.height -5)];
            [leftPath appendBezierPathWithArcWithCenter:NSMakePoint(5, dirtyRect.size.height - 5) radius:5 startAngle:-180 endAngle:-270 clockwise:YES];
            [leftPath lineToPoint:NSMakePoint(dirtyRect.size.width/2, dirtyRect.size.height)];
            [leftPath lineToPoint:NSMakePoint(dirtyRect.size.width/2, 0)];
            [leftPath setLineWidth:2];
            [leftPath addClip];
            [leftPath closePath];
            [COLOR_TEXT_DISABLE setFill];
            [leftPath fill];
            [COLOR_TEXT_LINE setStroke];
            [leftPath stroke];
        }
        NSImage *leftImage = nil;
        if (_leftStatus == 1) {
            leftImage = _leftMouseExitImage;
        }else if (_leftStatus == 2) {
            leftImage = _leftMouseEnteredImage;
        }else if (_leftStatus == 3) {
            leftImage = _leftMouseDownImage;
        }
        
        if (leftImage) {
            NSRect souRect;
            souRect.origin = NSZeroPoint;
            souRect.size = leftImage.size;
            NSRect tarRect;
            tarRect.origin = NSMakePoint((dirtyRect.size.width / 2 - leftImage.size.width) / 2, (dirtyRect.size.height - leftImage.size.height) / 2);
            tarRect.size = leftImage.size;
            [leftImage drawInRect:tarRect fromRect:souRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
    }else {
        NSImage *leftImage = nil;
        if (_leftStatus == 1) {
            leftImage = _leftMouseExitImage;
        }else if (_leftStatus == 2) {
            leftImage = _leftMouseEnteredImage;
        }else if (_leftStatus == 3) {
            leftImage = _leftMouseDownImage;
        }
        
        if (leftImage) {
            NSRect souRect;
            souRect.origin = NSZeroPoint;
            souRect.size = leftImage.size;
            NSRect tarRect;
            tarRect.origin = NSMakePoint((dirtyRect.size.width / 2 - leftImage.size.width) / 2, (dirtyRect.size.height - leftImage.size.height) / 2);
            tarRect.size = leftImage.size;
            [leftImage drawInRect:tarRect fromRect:souRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
        
        if (_rightStatus == 3) {
            NSBezierPath *rightPath = [NSBezierPath bezierPath];
            [rightPath setWindingRule:NSEvenOddWindingRule];
            [rightPath moveToPoint:NSMakePoint(dirtyRect.size.width/2, 0)];
            [rightPath lineToPoint:NSMakePoint(dirtyRect.size.width - 5, 0)];
            [rightPath appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.size.width - 5, 5) radius:5 startAngle:270 endAngle:0 clockwise:NO];
            [rightPath lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height - 5)];
            [rightPath appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.size.width - 5, dirtyRect.size.height - 5) radius:5 startAngle:0 endAngle:90 clockwise:NO];
            [rightPath lineToPoint:NSMakePoint(dirtyRect.size.width/2, dirtyRect.size.height)];
            [rightPath lineToPoint:NSMakePoint(dirtyRect.size.width/2, 0)];
            [rightPath setLineWidth:2];
            [rightPath addClip];
            [clipPath closePath];
            [COLOR_BUTTON_SEG setFill];
            [rightPath fill];
            [COLOR_BUTTON_SEGDOWN setStroke];
            [rightPath stroke];
        }else if (_rightStatus == 4) {
            NSBezierPath *rightPath = [NSBezierPath bezierPath];
            [rightPath setWindingRule:NSEvenOddWindingRule];
            [rightPath moveToPoint:NSMakePoint(dirtyRect.size.width/2, 0)];
            [rightPath lineToPoint:NSMakePoint(dirtyRect.size.width - 5, 0)];
            [rightPath appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.size.width - 5, 5) radius:5 startAngle:270 endAngle:0 clockwise:NO];
            [rightPath lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height - 5)];
            [rightPath appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.size.width - 5, dirtyRect.size.height - 5) radius:5 startAngle:0 endAngle:90 clockwise:NO];
            [rightPath lineToPoint:NSMakePoint(dirtyRect.size.width/2, dirtyRect.size.height)];
            [rightPath lineToPoint:NSMakePoint(dirtyRect.size.width/2, 0)];
            [rightPath setLineWidth:2];
            [rightPath addClip];
            [clipPath closePath];
            
            [COLOR_TEXT_DISABLE setFill];
            [rightPath fill];
            [COLOR_TEXT_LINE setStroke];
            [rightPath stroke];
        }
        NSImage *rightImage = nil;
        if (_rightStatus == 1) {
            rightImage = _rightMouseExitImage;
        }else if (_rightStatus == 2) {
            rightImage = _rightMouseEnteredImage;
        }else if (_rightStatus == 3) {
            rightImage = _rightMouseDownImage;
        }
        
        if (rightImage) {
            NSRect souRect;
            souRect.origin = NSZeroPoint;
            souRect.size = rightImage.size;
            NSRect tarRect;
            tarRect.origin = NSMakePoint((dirtyRect.size.width / 2 - rightImage.size.width) / 2 + dirtyRect.size.width / 2, (dirtyRect.size.height - rightImage.size.height) / 2);
            tarRect.size = rightImage.size;
            [rightImage drawInRect:tarRect fromRect:souRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        }
    }
}

- (void)dealloc{
    if (_leftMouseDownImage) {
        [_leftMouseDownImage release];
        _leftMouseDownImage = nil;
    }
    if (_leftMouseEnteredImage) {
        [_leftMouseEnteredImage release];
        _leftMouseEnteredImage = nil;
    }
    if (_leftMouseExitImage) {
        [_leftMouseExitImage release];
        _leftMouseExitImage = nil;
    }
    if (_rightMouseDownImage) {
        [_rightMouseDownImage release];
        _rightMouseDownImage = nil;
    }
    if (_rightMouseEnteredImage) {
        [_rightMouseEnteredImage release];
        _rightMouseEnteredImage = nil;
    }
    if (_rightMouseExitImage) {
        [_rightMouseExitImage release];
        _rightMouseExitImage = nil;
    }
    [super dealloc];
}

@end
