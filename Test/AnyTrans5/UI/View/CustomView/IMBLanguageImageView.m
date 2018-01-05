//
//  IMBLanguageImageView.m
//  iMobieTrans
//
//  Created by iMobie on 8/29/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBLanguageImageView.h"
#import "IMBNotificationDefine.h"
#import "IMBSoftWareInfo.h"
#import "StringHelper.h"

@implementation IMBLanguageImageView
@synthesize isClicked = _isClicked;

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
	if (_trackingArea)
	{
		[self removeTrackingArea:_trackingArea];
		[_trackingArea release];
	}
	
	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
	_trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
	[self addTrackingArea:_trackingArea];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	if (_isEntered) {
        NSImage *image = _mouseEnteredImage;
        NSRect drawingRect;
        drawingRect.size = image.size;
        drawingRect.origin = NSZeroPoint;
        
        NSRect imageRect;
        imageRect.origin = NSZeroPoint;
        imageRect.size = image.size;
        
        [image drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
    }
    
    if (_isClicked) {
        NSImage *image = _mouseDownImage;
        NSRect drawingRect;
        drawingRect.size = image.size;
        drawingRect.origin = NSMakePoint(0, 0);
        
        NSRect imageRect;
        imageRect.origin = NSZeroPoint;
        imageRect.size = image.size;
        
        [image drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
    }
    // Drawing code here.
}

- (void)dealloc
{
    if (_category != nil) {
        [_category release];
        _category = nil;
    }
    if (_mouseEnteredImage) {
        [_mouseDownImage release];
        _mouseDownImage = nil;
    }
    if (_mouseEnteredImage) {
        [_mouseEnteredImage release];
        _mouseEnteredImage = nil;
    }
    [super dealloc];
}

- (void)setIsEntered:(BOOL)isEntered {
    if (_isEntered != isEntered) {
        _isEntered = isEntered;
        [self setNeedsDisplay:YES];
    }
}

- (void)setIsClicked:(BOOL)isClicked {
    if (_isClicked != isClicked) {
        _isClicked = isClicked;
        [self setNeedsDisplay:YES];
    }
}

- (void)setChangeEnteredImageAndDownImage:(NSString *)imageName withCategory:(NSString *)category {
    if (_mouseEnteredImage) {
        [_mouseDownImage release];
        _mouseDownImage = nil;
    }
    _mouseDownImage = [[StringHelper imageNamed:[NSString stringWithFormat:@"%@2",imageName]] retain];
    if (_mouseEnteredImage) {
        [_mouseEnteredImage release];
        _mouseEnteredImage = nil;
    }
    _mouseEnteredImage = [[StringHelper imageNamed:[NSString stringWithFormat:@"%@1",imageName]] retain];
    _category = [category retain];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [self setIsClicked:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CHANGE_LANGUAGE object:_category userInfo:nil];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [self setIsEntered:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [self setIsEntered:NO];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [super mouseUp:theEvent];
}

@end
