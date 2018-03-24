 //
//  IMBSignOutButton.m
//  PhoneClean
//
//  Created by iMobie023 on 15-7-8.
//  Copyright (c) 2015年 imobie.com. All rights reserved.
//

#import "IMBSignOutButton.h"
#import "StringHelper.h"
@implementation IMBSignOutButton
@synthesize isPhoto = _isPhoto;
@synthesize buttonType = _buttonType;
@synthesize enabledImage = _enabledImage;
@synthesize mouseDownImage = _mouseDownImage;
@synthesize mouseExitedImage = _mouseExitedImage;
@synthesize mouseEnteredImage = _mouseEnteredImage;
@synthesize isleftBtn = _isleftBtn;
@synthesize isDown = _isDown;
@synthesize isTuiTuBtn =_isTuiTuBtn;
@synthesize isDownBackgroundImg = _isDownBackgroundImg;
@synthesize titleStr = _titleStr;
@synthesize backGroudCol = _backGroudCol;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBezelStyle:NSTexturedSquareBezelStyle];
        [self setImagePosition:NSImageOnly];
        [self setBordered:NO];
    }
    return self;
}

- (BOOL)isFlipped {
    return NO;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
//    if (_mouseState == MouseEnter) {
//        [[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)] set];
//    }else if (_mouseState == MouseDown) {
//        [[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] set];
//    }else {
       [[NSColor clearColor] set];
//    }
    [path fill];
    if (_mouseState == MouseEnter && _mouseDownImage != nil) {
        [_mouseEnteredImage drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    }else if (_mouseState == MouseOut && _mouseExitedImage != nil) {
        [_mouseExitedImage drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    }else if (_mouseState == MouseDown && _mouseDownImage != nil) {
        [_mouseDownImage drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    }else {
        [_mouseExitedImage drawInRect:dirtyRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    }
}

- (void)drawLeftText:(NSString *)text withFrame:(NSRect)frame withFontSize:(float)withFontSize withColor:(NSColor *)color {
    if (text) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [paragraphStyle setAlignment:NSCenterTextAlignment];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName ,paragraphStyle,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:withFontSize],NSFontAttributeName, nil];
        NSSize textSize = [as.string sizeWithAttributes:attributes];
        NSRect f;
        if (_isleftBtn) {
            f = NSMakeRect((frame.size.width - textSize.width)/2, frame.size.height -30, textSize.width, textSize.height);
        }else{
            f = NSMakeRect((80 - textSize.width)/2, (80 - textSize.height)/2-3, textSize.width, textSize.height);
        }
        
        [as.string drawInRect:f withAttributes:attributes];
        [as release];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [super mouseEntered:theEvent];
    _mouseState = MouseEnter;
    [self setNeedsDisplay:YES];
}

//
- (void)updateTrackingAreas {
	[super updateTrackingAreas];
	if (_trackingArea) {
		[self removeTrackingArea:_trackingArea];
		[_trackingArea release];
        _trackingArea = nil;
	}
	
	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
	_trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
	[self addTrackingArea:_trackingArea];
}

- (void)dealloc {
    if (_trackingArea) {
		[self removeTrackingArea:_trackingArea];
		[_trackingArea release];
        _trackingArea = nil;
	}
    [super dealloc];
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (!_isleftBtn) {
        _buttonType = BackExitButton;
        [self setNeedsDisplay:YES];
    }
    _mouseState = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _buttonType = BackDownButton;
    _mouseState = MouseDown;
    [self setNeedsDisplay:YES];
}

-(void)mouseUp:(NSEvent *)theEvent{
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
    if (inner && self.isEnabled) {
        if (self.target != nil && self.action != nil) {
            if ([self.target respondsToSelector:self.action]) {
                if (_isDown != YES) {
                    _isDown = !_isDown;
                }
                [self.target performSelector:self.action withObject:self];
            }
        }
    }
    _buttonType = BackUpButton;
    [self setNeedsDisplay:YES];
}

@end
