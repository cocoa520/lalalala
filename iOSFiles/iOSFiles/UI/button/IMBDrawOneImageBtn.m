//
//  IMBDrawOneImageBtn.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-8.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBDrawOneImageBtn.h"

@implementation IMBDrawOneImageBtn
@synthesize isDFUGuide = _isDFUGuide;
@synthesize isEnble = _isEnble;
@synthesize longTimeDown = _longTimeDown;
@synthesize longTimeImage = _longTimeImage;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code here.
    }
    return self;
}

-(void)mouseDownImage:(NSImage*) mouseDownImg withMouseUpImg:(NSImage *) mouseUpImg withMouseExitedImg:(NSImage *) mouseExiteImg mouseEnterImg:(NSImage *) mouseEnterImg{
    if (_mouseDownImage != nil) {
        [_mouseDownImage release];
        _mouseDownImage = nil;
    }
    if (_mouseUpImage != nil) {
        [_mouseUpImage release];
        _mouseUpImage = nil;
    }
    if (_mouseExitedImage != nil) {
        [_mouseExitedImage release];
        _mouseExitedImage = nil;
    }
    if (_mouseEnteredImage != nil) {
        [_mouseEnteredImage release];
        _mouseEnteredImage = nil;
    }
    _mouseDownImage = [mouseDownImg retain];
    _mouseUpImage = [mouseUpImg retain];
    _mouseExitedImage = [mouseExiteImg retain];
    _mouseEnteredImage = [mouseEnterImg retain];
}

- (void)updateTrackingAreas{
	[super updateTrackingAreas];
	if (_trackingArea) {
		[self removeTrackingArea:_trackingArea];
        [_trackingArea release];
        _trackingArea = nil;
	}
	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
	_trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
	[self addTrackingArea:_trackingArea];
}


-(void)dealloc{
    if (_mouseDownImage != nil) {
        [_mouseDownImage release];
        _mouseDownImage = nil;
    }
    if (_mouseUpImage != nil) {
        [_mouseUpImage release];
        _mouseUpImage = nil;
    }
    if (_mouseExitedImage != nil) {
        [_mouseExitedImage release];
        _mouseExitedImage = nil;
    }
    if (_mouseEnteredImage != nil) {
        [_mouseEnteredImage release];
        _mouseEnteredImage = nil;
    }
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

- (void)setEnabled:(BOOL)flag {
    if (flag != self.isEnabled) {
        [super setEnabled:flag];
        if (!self.isEnabled) {
            [self setAlphaValue:0.5];
        }else {
            [self setAlphaValue:1];
        }
        [self setNeedsDisplay:YES];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    NSRect sourceimageRect;
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:dirtyRect];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    [clipPath addClip];
    [[NSColor whiteColor] set];
    [clipPath fill];
    
    if (_longTimeDown) {
        sourceimageRect.origin = NSZeroPoint;
        sourceimageRect.size = NSMakeSize(_longTimeImage.size.width, _longTimeImage.size.height);
        //            [_mouseExitedImage drawInRect:dirtyRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0];
        [_longTimeImage drawInRect:dirtyRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    }else{
        if (_buttonType == MouseOut){
            if (_mouseExitedImage !=nil) {
                sourceimageRect.origin = NSZeroPoint;
                sourceimageRect.size = NSMakeSize(_mouseExitedImage.size.width, _mouseExitedImage.size.height);
                //            [_mouseExitedImage drawInRect:dirtyRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0];
                [_mouseExitedImage drawInRect:dirtyRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            }
        }else if (_buttonType == MouseUp){
            if (_mouseUpImage != nil) {
                sourceimageRect.origin = NSZeroPoint;
                sourceimageRect.size = NSMakeSize(_mouseUpImage.size.width, _mouseUpImage.size.height);
                //            [_mouseUpImage drawInRect:dirtyRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0];
                [_mouseUpImage drawInRect:dirtyRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            }
        }else if (_buttonType == MouseDown){
            if (_mouseDownImage != nil) {
                sourceimageRect.origin = NSZeroPoint;
                sourceimageRect.size = NSMakeSize(_mouseDownImage.size.width, _mouseDownImage.size.height);
                //            [_mouseDownImage drawInRect:dirtyRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0];
                [_mouseDownImage drawInRect:dirtyRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            }
        }else if (_buttonType == MouseEnter){
            if (_mouseEnteredImage != nil) {
                sourceimageRect.origin = NSZeroPoint;
                sourceimageRect.size = NSMakeSize(_mouseEnteredImage.size.width, _mouseEnteredImage.size.height);
                //            [_mouseEnteredImage drawInRect:dirtyRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0];
                [_mouseEnteredImage drawInRect:dirtyRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            }
        }else{
            if (_mouseExitedImage != nil) {
                sourceimageRect.origin = NSZeroPoint;
                sourceimageRect.size = NSMakeSize(_mouseExitedImage.size.width, _mouseExitedImage.size.height);
                //            [_mouseExitedImage drawInRect:dirtyRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0];
                [_mouseExitedImage drawInRect:dirtyRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            }
        }

    }
     if (_isDFUGuide) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:[self.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setAlignment:NSCenterTextAlignment];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor whiteColor],NSForegroundColorAttributeName ,paragraphStyle,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue Light" size:28],NSFontAttributeName, nil];
        NSSize textSize = [as.string sizeWithAttributes:attributes];
        NSRect f;
        f = NSMakeRect((dirtyRect.size.width - textSize.width)/2, (dirtyRect.size.height - textSize.height)/2-1, textSize.width, textSize.height);
        [as.string drawInRect:f withAttributes:attributes];
        [as release];
    }else if(_isEnble){
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:[self.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setAlignment:NSCenterTextAlignment];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor colorWithDeviceRed:24.0/255 green:183.0/255 blue:165.0/255 alpha:1.000],NSForegroundColorAttributeName ,paragraphStyle,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue Light" size:28],NSFontAttributeName, nil];
        NSSize textSize = [as.string sizeWithAttributes:attributes];
        NSRect f;
        f = NSMakeRect((dirtyRect.size.width - textSize.width)/2, (dirtyRect.size.height - textSize.height)/2-1, textSize.width, textSize.height);
        [as.string drawInRect:f withAttributes:attributes];
        [as release];
    }


}



-(void)mouseUp:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = MouseUp;
        [self setNeedsDisplay:YES];
        if (self.isEnabled) {
            NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
            BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
            if (inner) {
                [NSApp sendAction:self.action to:self.target from:self];
            }
        }

    }
}

-(void)mouseDown:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = MouseDown;
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseExited:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = MouseOut;
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseEntered:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = MouseEnter;
        [self setNeedsDisplay:YES];
    }
}
@end
