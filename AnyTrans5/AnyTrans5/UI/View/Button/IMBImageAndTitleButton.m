//
//  IMBImageAndTitleButton.m
//  AnyTrans
//
//  Created by iMobie on 8/6/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBImageAndTitleButton.h"
#import "StringHelper.h"
@implementation IMBImageAndTitleButton
@synthesize titleName = _titleName;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)setEnabled:(BOOL)flag {
    if (flag != self.isEnabled) {
        [super setEnabled:flag];
        _buttonType = 1;
        if (!self.isEnabled) {
            [self setAlphaValue:0.5];
        }else {
            [self setAlphaValue:1];
        }
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseDownImage:(NSImage*) mouseDownImg withMouseUpImg:(NSImage *) mouseUpImg withMouseExitedImg:(NSImage *) mouseExiteImg mouseEnterImg:(NSImage *) mouseEnterImg withButtonName:(NSString *)buttonName{
    _mouseDownImage = [mouseDownImg retain];
    _mouseUpImage = [mouseUpImg retain];
    _mouseExitedImage = [mouseExiteImg retain];
    _mouseEnteredImage = [mouseEnterImg retain];
    _titleName = [buttonName retain];
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
    if (_titleName != nil) {
        [_titleName release];
        _titleName = nil;
    }
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSRect sourceimageRect;
    NSRect desImageRect;
    float ox = 0;
    NSColor *color = [StringHelper getColorFromString:CustomColor(@"addplaylistBtn_title_normalColor", nil)];
    if (_buttonType == 1){
        color = [StringHelper getColorFromString:CustomColor(@"addplaylistBtn_title_normalColor", nil)];
        if (_mouseExitedImage !=nil) {
            sourceimageRect.origin = NSZeroPoint;
            sourceimageRect.size = NSMakeSize(_mouseExitedImage.size.width, _mouseExitedImage.size.height);
            desImageRect.origin = NSMakePoint(2, (dirtyRect.size.height - _mouseExitedImage.size.height)/2);
            desImageRect.size = _mouseExitedImage.size;
            [_mouseExitedImage drawInRect:desImageRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            ox = 8 + desImageRect.size.width;
        }
    }else if (_buttonType == 4){
        color = [StringHelper getColorFromString:CustomColor(@"addplaylistBtn_title_normalColor", nil)];
        if (_mouseUpImage != nil) {
            sourceimageRect.origin = NSZeroPoint;
            sourceimageRect.size = NSMakeSize(_mouseUpImage.size.width, _mouseUpImage.size.height);
            desImageRect.origin = NSMakePoint(2, (dirtyRect.size.height - _mouseUpImage.size.height)/2);
            desImageRect.size = _mouseUpImage.size;
            [_mouseUpImage drawInRect:desImageRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            ox = 8 + desImageRect.size.width;
        }
    }else if (_buttonType == 3){
        color = [StringHelper getColorFromString:CustomColor(@"addplaylistBtn_title_downColor", nil)];
        if (_mouseDownImage != nil) {
            sourceimageRect.origin = NSZeroPoint;
            sourceimageRect.size = NSMakeSize(_mouseDownImage.size.width, _mouseDownImage.size.height);
            desImageRect.origin = NSMakePoint(2, (dirtyRect.size.height - _mouseDownImage.size.height)/2);
            desImageRect.size = _mouseDownImage.size;
            [_mouseDownImage drawInRect:desImageRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            ox = 8 + desImageRect.size.width;
        }
    }else if (_buttonType == 2){
        color = [StringHelper getColorFromString:CustomColor(@"addplaylistBtn_title_enterColor", nil)];
        if (_mouseEnteredImage != nil) {
            sourceimageRect.origin = NSZeroPoint;
            sourceimageRect.size = NSMakeSize(_mouseEnteredImage.size.width, _mouseEnteredImage.size.height);
            desImageRect.origin = NSMakePoint(2, (dirtyRect.size.height - _mouseEnteredImage.size.height)/2);
            desImageRect.size = _mouseEnteredImage.size;
            [_mouseEnteredImage drawInRect:desImageRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            ox = 8 + desImageRect.size.width;
        }
    }else{
        color = [StringHelper getColorFromString:CustomColor(@"addplaylistBtn_title_normalColor", nil)];
        if (_mouseExitedImage != nil) {
            sourceimageRect.origin = NSZeroPoint;
            sourceimageRect.size = NSMakeSize(_mouseExitedImage.size.width, _mouseExitedImage.size.height);
            desImageRect.origin = NSMakePoint(2, (dirtyRect.size.height - _mouseExitedImage.size.height)/2);
            desImageRect.size = _mouseExitedImage.size;
            [_mouseExitedImage drawInRect:desImageRect fromRect:sourceimageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            ox = 8 + desImageRect.size.width;
        }
    }

    if (_titleName != nil) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:_titleName];
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setAlignment:NSCenterTextAlignment];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName ,paragraphStyle,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontAttributeName, nil];
        NSSize textSize = [as.string sizeWithAttributes:attributes];
        NSRect f;
        f = NSMakeRect(ox, (dirtyRect.size.height - textSize.height)/2-1, textSize.width, textSize.height);
        [as.string drawInRect:f withAttributes:attributes];
        [as release];
    }
}

-(void)mouseUp:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = 4;
        [self setNeedsDisplay:YES];
        NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
        BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
        if (inner) {
            [NSApp sendAction:self.action to:self.target from:self];
        }
    }
}

-(void)mouseDown:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = 3;
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseExited:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = 1;
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseEntered:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = 2;
        [self setNeedsDisplay:YES];
    }
}

@end
