//
//  LFButtn.m
//  NSDraw
//
//  Created by iMobie023 on 16-3-2.
//  Copyright (c) 2016年 iMobie023. All rights reserved.
//

#import "IMBMyDrawCommonly.h"
#import "StringHelper.h"

@implementation IMBMyDrawCommonly
@synthesize buttonType = _buttonType;
@synthesize mouseUpLineColor = _mouseUpLineColor;
@synthesize mouseDownLineColor = _mouseDownLineColor;
@synthesize mouseDownfillColor = _mouseDownfillColor;
@synthesize mouseExitedLineColor = _mouseExitedLineColor;
@synthesize mouseEnteredLineColor = _mouseEnteredLineColor;
@synthesize mouseUpfillColor = _mouseUpfillColor;
@synthesize mouseExitedfillColor = _mouseExitedfillColor;
@synthesize mouseEnteredfillColor = _mouseEnteredfillColor;
@synthesize lineWidth = _lineWidth;
@synthesize titleName = _titleName;
@synthesize darwRoundedRect = _darwRoundedRect;
@synthesize backgroundColor = _backgroundColor;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setBordered:NO];
        [self setAlignment:NSCenterTextAlignment];
        [self setImagePosition:NSNoImage];
    }
    return self;
}


-(void)dealloc{
    [super dealloc];
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    if (font != nil) {
        [font release];
        font = nil;
    }
    if (_titleName != nil) {
        [_titleName release];
        _titleName = nil;
    }
    if (_mouseExitedtextColor != nil) {
        [_mouseExitedtextColor release];
        _mouseExitedtextColor = nil;
    }
    if (_mouseEnteredtextColor != nil) {
        [_mouseEnteredtextColor release];
        _mouseEnteredtextColor = nil;
    }
    if (_mouseDowntextColor != nil) {
        [_mouseDowntextColor release];
        _mouseDowntextColor = nil;
    }
    if (_mouseUptextColor != nil) {
        [_mouseUptextColor release];
        _mouseUptextColor = nil;
    }
    
    if (_mouseExitedLineColor != nil) {
        [_mouseExitedLineColor release];
        _mouseExitedLineColor = nil;
    }
    if (_mouseEnteredLineColor != nil) {
        [_mouseEnteredLineColor release];
        _mouseEnteredLineColor = nil;
    }
    if (_mouseDownLineColor != nil) {
        [_mouseDownLineColor release];
        _mouseDownLineColor = nil;
    }
    if (_mouseUpLineColor != nil) {
        [_mouseUpLineColor release];
        _mouseUpLineColor = nil;
    }
    
    if (_mouseExitedfillColor != nil) {
        [_mouseExitedfillColor release];
        _mouseExitedfillColor = nil;
    }
    if (_mouseEnteredfillColor != nil) {
        [_mouseEnteredfillColor release];
        _mouseEnteredfillColor = nil;
    }
    if (_mouseDownfillColor != nil) {
        [_mouseDownfillColor release];
        _mouseDownfillColor = nil;
    }
    if (_mouseUpfillColor != nil) {
        [_mouseUpfillColor release];
        _mouseUpfillColor = nil;
    }
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

-(void)setTitleName:(NSString *)titleName WithDarwRoundRect:(float)roundRect WithLineWidth:(int) width withFont:(NSFont *)textFont{
    font = [textFont retain];
    _titleName = [titleName retain];
    _lineWidth = width;
    _darwRoundedRect = roundRect;
}

-(void)WithMouseExitedtextColor:(NSColor *)exitedtextColor WithMouseUptextColor:(NSColor *)uptextColor WithMouseDowntextColor:(NSColor *)downtextColor withMouseEnteredtextColor:(NSColor *)enteredtextColor{
    _mouseExitedtextColor = [exitedtextColor retain];
    _mouseEnteredtextColor = [enteredtextColor retain];
    _mouseDowntextColor = [downtextColor retain];
    _mouseUptextColor = [uptextColor retain];
}

-(void)WithMouseExitedLineColor:(NSColor *)exitedLineColor WithMouseUpLineColor:(NSColor *)upLineColor WithMouseDownLineColor:(NSColor *)downLineColor withMouseEnteredLineColor:(NSColor *)enteredLineColor{
    _mouseExitedLineColor = [exitedLineColor retain];
    _mouseEnteredLineColor = [enteredLineColor retain];
    _mouseDownLineColor = [downLineColor retain];
    _mouseUpLineColor = [upLineColor retain];
}

-(void)WithMouseExitedfillColor:(NSColor *)exitedfillColor WithMouseUpfillColor:(NSColor *)upfillColor WithMouseDownfillColor:(NSColor *)downfillColor withMouseEnteredfillColor:(NSColor *)enteredfillColor {
    _mouseExitedfillColor = [exitedfillColor retain];
    _mouseEnteredfillColor = [enteredfillColor retain];
    _mouseDownfillColor = [downfillColor retain];
    _mouseUpfillColor = [upfillColor retain];
}

- (void)drawRect:(NSRect)dirtyRect{
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    [path setWindingRule:NSEvenOddWindingRule];
    [path addClip];
    if (_backgroundColor != nil) {
        [_backgroundColor set];
    }else{
        [IMBGrayColor(255) set];
    }
    [path fill];
    [path closePath];
    
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:_darwRoundedRect yRadius:_darwRoundedRect];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    [clipPath addClip];
    [clipPath setLineWidth:_lineWidth];
     if (_buttonType == MouseOut){
         textColor = _mouseExitedtextColor;
         [_mouseExitedfillColor set];
         [clipPath fill];
         [_mouseExitedLineColor setStroke];
         [clipPath stroke];
     }else if (_buttonType == MouseUp){
         textColor = _mouseUptextColor;
         [_mouseUpfillColor set];
         [clipPath fill];
         [_mouseUpLineColor setStroke];
         [clipPath stroke];
     }else if (_buttonType == MouseDown){
         textColor = _mouseDowntextColor;
         [_mouseDownfillColor set];
         [clipPath fill];
         [_mouseDownLineColor setStroke];
         [clipPath stroke];
     }else if (_buttonType == MouseEnter){
         textColor = _mouseEnteredtextColor;
         
         [_mouseEnteredfillColor set];
         [clipPath fill];
         [_mouseEnteredLineColor setStroke];
         [clipPath stroke];
     }else{
        textColor = _mouseExitedtextColor;
        [_mouseExitedfillColor set];
        [clipPath fill];
        [_mouseExitedLineColor setStroke];
        [clipPath stroke];
     }
    [clipPath closePath];
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:[_titleName?_titleName:@"" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSCenterTextAlignment];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:textColor,NSForegroundColorAttributeName ,paragraphStyle,NSParagraphStyleAttributeName,font,NSFontAttributeName, nil];
    NSSize textSize = [as.string sizeWithAttributes:attributes];
    NSRect f;
    f = NSMakeRect((dirtyRect.size.width - textSize.width)/2, (dirtyRect.size.height - textSize.height)/2-2, textSize.width, textSize.height);
    [as.string drawInRect:f withAttributes:attributes];
}

-(void)mouseDown:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = MouseDown;
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseUp:(NSEvent *)theEvent{
    if (self.isEnabled) {
    _buttonType = MouseUp;
    [self setNeedsDisplay:YES];

        NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
        BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
        if (inner) {
            [NSApp sendAction:self.action to:self.target from:self];
        }
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
