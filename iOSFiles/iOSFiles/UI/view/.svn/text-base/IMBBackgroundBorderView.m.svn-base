//
//  IMBBackgroundBorderView.m
//  MacClean
//
//  Created by Gehry on 12/29/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import "IMBBackgroundBorderView.h"

@implementation IMBBackgroundBorderView

@synthesize backgroundColor = _backgroundColor;
@synthesize hasTopBorder = _hasTopBorder;
@synthesize hasLeftBorder = _hasLeftBorder;
@synthesize hasBottomBorder = _hasBottomBorder;
@synthesize hasRightBorder= _hasRightBorder;
@synthesize bottomBorderColor = _bottomBorderColor;
@synthesize topBorderColor = _topBorderColor;
@synthesize leftBorderColor = _leftBorderColor;
@synthesize rightBorderColor = _rightBorderColor;
@synthesize backgroundImage = _backgroundImage;
@synthesize borderColor = _borderColor;
@synthesize hasRadius = _hasRadius;

-(void)dealloc
{
    [_backgroundColor release],_backgroundColor = nil;
    [_topBorderColor release],_topBorderColor = nil;
    [_leftBorderColor release],_topBorderColor = nil;
    [_bottomBorderColor release],_topBorderColor = nil;
    [_rightBorderColor release],_topBorderColor = nil;
    [super dealloc];
}


- (void)setBorderColor:(NSColor *)borderColor{
    if (_borderColor != borderColor) {
        [_borderColor release];
        _borderColor = [borderColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)setBackgroundColor:(NSColor *)backgroundColor{
    if (_backgroundColor != backgroundColor) {
        [_backgroundColor release];
        _backgroundColor = [backgroundColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)setBottomBorderColor:(NSColor *)bottomBorderColor{
    if (_bottomBorderColor != bottomBorderColor) {
        [_bottomBorderColor release];
        _bottomBorderColor = [bottomBorderColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)setLeftBorderColor:(NSColor *)leftBorderColor{
    if (_leftBorderColor != leftBorderColor) {
        [_leftBorderColor release];
        _leftBorderColor = [leftBorderColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)setTopBorderColor:(NSColor *)topBorderColor{
    if (_topBorderColor != topBorderColor) {
        [_topBorderColor release];
        _topBorderColor = [topBorderColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)setRightBorderColor:(NSColor *)rightBorderColor{
    if (_rightBorderColor != rightBorderColor) {
        [_rightBorderColor release];
        _rightBorderColor = [rightBorderColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)setHasTopBorder:(BOOL)hasTopBorder{
    if (_hasTopBorder != hasTopBorder) {
        _hasTopBorder = hasTopBorder;
        [self setNeedsDisplay:YES];
    }
}

- (void)setHasLeftBorder:(BOOL)hasLeftBorder{
    
    if (_hasLeftBorder != hasLeftBorder) {
        _hasLeftBorder = hasLeftBorder;
        [self setNeedsDisplay:YES];
    }
}

- (void)setHasBottomBorder:(BOOL)hasBottomBorder{
    if (_hasBottomBorder != hasBottomBorder) {
        _hasBottomBorder = hasBottomBorder;
        [self setNeedsDisplay:YES];
    }
}

- (void)setHasRightBorder:(BOOL)hasRightBorder{
    if (_hasRightBorder != hasRightBorder) {
        _hasRightBorder = hasRightBorder;
        [self setNeedsDisplay:YES];
    }
}

- (void)setBackgroundImage:(NSImage *)backgroundImage{
    if (_backgroundImage != backgroundImage) {
        
        [_backgroundImage release];
        _backgroundImage = [backgroundImage retain];
        [self setNeedsDisplay:YES];
    }
}

+ (NSImage*) imageFromCGImageRef:(CGImageRef)image {
    NSRect imageRect = NSMakeRect(0.0, 0.0, 0.0, 0.0);
    CGContextRef imageContext = nil;
    NSImage* newImage = nil;
    
    // Get the image dimensions.
    imageRect.size.height = CGImageGetHeight(image);
    imageRect.size.width = CGImageGetWidth(image);
    
    // Create a new image to receive the Quartz image data.
    newImage = [[NSImage alloc] initWithSize:imageRect.size];
    [newImage lockFocus];
    
    // Get the Quartz context and draw.
    imageContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    CGContextDrawImage(imageContext, *(CGRect*)&imageRect, image);
    [newImage unlockFocus];
    return newImage;
}

- (void)setXRadius:(CGFloat)xRadius YRadius:(CGFloat)yRadius
{
    _xRadius = xRadius;
    _yRadius = yRadius;
    [self setNeedsDisplay:YES];
}

- (void)awakeFromNib
{
    _xRadius = 5.0;
    _yRadius = 5.0;
}

- (void)drawRect:(NSRect)dirtyRect{
    @autoreleasepool {
        
        //画圆角
        if (_hasRadius) {
            NSBezierPath *roundRect = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:_xRadius yRadius:_yRadius];
            [[NSColor clearColor] setFill];
            //  [roundRect addClip];
            [roundRect fill];
            [_backgroundColor setFill];
            //[roundRect addClip];
            [roundRect fill];
            return;
        }
        //画背景、边框
        NSBezierPath *backgroundPath = [NSBezierPath bezierPathWithRect:dirtyRect];
        if (_backgroundColor) {
            [[NSColor clearColor] setFill];
            NSRectFill(dirtyRect);
            [_backgroundColor setFill];
        }else {
            [[NSColor clearColor] setFill];
        }
        [backgroundPath fill];
        
        if (_backgroundImage) {
            float xPos = 0;
            float yPos = 0;
            NSRect drawingRect;
            NSRect imageRect;
            // 开始绘制左边的部分
            imageRect.origin = NSZeroPoint;
            imageRect.size = _backgroundImage.size;
            int drawCount = ceil((dirtyRect.size.width ) / imageRect.size.width);
            for (int i = 0; i < drawCount; i++) {
                drawingRect.origin.x = xPos;
                drawingRect.origin.y = yPos;
                drawingRect.size = imageRect.size;
                xPos += imageRect.size.width;
                if (drawingRect.size.width > 0) {
                    [_backgroundImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
                }
            }
        }
        
        //画
        if (_hasTopBorder&&_topBorderColor&&NSEqualSizes(self.frame.size, dirtyRect.size)) {
            NSBezierPath *topBorderPath = [NSBezierPath bezierPath];
            [topBorderPath setLineWidth:2.0];
            [topBorderPath moveToPoint:NSMakePoint(0, dirtyRect.size.height)];
            [topBorderPath lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height)];
            [[NSColor clearColor] setStroke];
            [topBorderPath stroke];
            [_topBorderColor setStroke];
            [topBorderPath stroke];
        }
        if (_hasLeftBorder&&_leftBorderColor) {
            NSBezierPath *leftBorderPath = [NSBezierPath bezierPath];
            [leftBorderPath moveToPoint:NSMakePoint(0, dirtyRect.size.height)];
            [leftBorderPath lineToPoint:NSMakePoint(0, 0)];
            [[NSColor clearColor] setStroke];
            [leftBorderPath stroke];
            [_leftBorderColor setStroke];
            [leftBorderPath stroke];
        }
        if (_hasBottomBorder&&_bottomBorderColor) {
            NSBezierPath *bottomBorderPath = [NSBezierPath bezierPath];
            [bottomBorderPath setLineWidth:2.0];
            [bottomBorderPath moveToPoint:NSMakePoint(0, 0)];
            [bottomBorderPath lineToPoint:NSMakePoint(dirtyRect.size.width, 0)];
            [[NSColor clearColor] setStroke];
            [bottomBorderPath stroke];
            [_bottomBorderColor setStroke];
            [bottomBorderPath stroke];
        }
        if (_hasRightBorder&&_rightBorderColor) {
            NSBezierPath *rightBorderPath = [NSBezierPath bezierPath];
            [rightBorderPath moveToPoint:NSMakePoint(dirtyRect.size.width, 0)];
            [rightBorderPath lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height)];
            [[NSColor clearColor] setStroke];
            [rightBorderPath stroke];
            [_rightBorderColor setStroke];
            [rightBorderPath stroke];
        }
    }
}
@end