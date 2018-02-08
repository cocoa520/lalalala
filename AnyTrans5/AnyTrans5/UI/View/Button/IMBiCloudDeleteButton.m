//
//  IMBiCloudDeleteButton.m
//  PhoneRescue
//
//  Created by 肖体华 on 14-9-24.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBiCloudDeleteButton.h"
#import "StringHelper.h"

@implementation IMBiCloudDeleteButton

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

- (void)dealloc
{
    if (_mouseEnableImage != nil) {
        [_mouseEnableImage release];
        _mouseEnableImage = nil;
    }
    if (_mouseExitImage != nil) {
        [_mouseExitImage release];
        _mouseExitImage = nil;
    }
    if (_mouseEnteredImage != nil) {
        [_mouseEnteredImage release];
        _mouseEnteredImage = nil;
    }
    if (_mouseDownImage != nil) {
        [_mouseDownImage release];
        _mouseDownImage = nil;
    }
    [super dealloc];
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
    if (_mouseEnableImage != nil) {
        [_mouseEnableImage release];
        _mouseEnableImage = nil;
    }
    _mouseEnableImage = [[StringHelper imageNamed:[NSString stringWithFormat:@"%@1",prefixImageName]] retain];
    if (_mouseExitImage != nil) {
        [_mouseExitImage release];
        _mouseExitImage = nil;
    }
    _mouseExitImage = [[StringHelper imageNamed:[NSString stringWithFormat:@"%@2",prefixImageName]] retain];
    if (_mouseEnteredImage != nil) {
        [_mouseEnteredImage release];
        _mouseEnteredImage = nil;
    }
    _mouseEnteredImage = [[StringHelper imageNamed:[NSString stringWithFormat:@"%@3",prefixImageName]] retain];
    if (_mouseDownImage != nil) {
        [_mouseDownImage release];
        _mouseDownImage = nil;
    }
    NSImage *image = [StringHelper imageNamed:[NSString stringWithFormat:@"%@4",prefixImageName]];
    if (image != nil) {
        _mouseDownImage = [image retain];
    }else {
        _mouseDownImage = [_mouseEnableImage retain];
    }
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
