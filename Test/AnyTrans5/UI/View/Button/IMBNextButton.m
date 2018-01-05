//
//  IMBNextButton.m
//  iMobieTrans
//
//  Created by iMobie on 8/7/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBNextButton.h"
#import "StringHelper.h"

@implementation IMBNextButton
@synthesize mouseDownImage = _mouseDownImage;
@synthesize mouseEnableImage = _mouseEnableImage;
@synthesize mouseExitImage = _mouseExitImage;
@synthesize mouseEnteredImage = _mouseEnteredImage;
@synthesize isEnable = _isEnable;

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

- (void) setImageWithWithPrefixImageName:(NSString*)prefixImageName {
    _mouseEnableImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@1",prefixImageName]];
    _mouseExitImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@2",prefixImageName]];
    _mouseEnteredImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@3",prefixImageName]];
    _mouseDownImage = [StringHelper imageNamed:[NSString stringWithFormat:@"%@4",prefixImageName]];
    [self setBordered:NO];
    [self setImage:_mouseExitImage];
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (self.isEnabled) {
        [self setImage:_mouseDownImage];
    }else {
        [self setImage:_mouseEnableImage];
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (self.isEnabled) {
        [self setImage:_mouseExitImage];
        NSPoint localPoint = [self convertPoint:[[self window] convertScreenToBase:[NSEvent mouseLocation]] fromView:nil];
        BOOL mouseInside = NSPointInRect(localPoint, [self bounds]);
        if (mouseInside) {
            [NSApp sendAction:self.action to:self.target from:self];
        }
    }else {
        [self setImage:_mouseEnableImage];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    if (self.isEnabled) {
        [self setImage:_mouseEnteredImage];
    }else {
        [self setImage:_mouseEnableImage];
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (self.isEnabled) {
        [self setImage:_mouseExitImage];
    }else {
        [self setImage:_mouseEnableImage];
    }
}

@end
