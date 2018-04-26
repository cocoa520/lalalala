//
//  IMBGrideView.m
//  PhoneRescue
//
//  Created by m on 3/22/18.
//  Copyright (c) 2018 iMobie Inc. All rights reserved.
//

#import "IMBGrideView.h"

@implementation IMBGrideView
@synthesize isUpWhiteToClear = _isUpWhiteToClear;
@synthesize isLeftToRight = _isLeftToRight;

- (void)drawRect:(NSRect)dirtyRect {
    CGColorRef color1 = nil;
    CGColorRef color2 = nil;
    if (_isUpWhiteToClear) {
        color1 = [[NSColor whiteColor] colorWithAlphaComponent:0.0].CGColor;
        color2 = [NSColor whiteColor].CGColor;
    }else {
        color2 = [[NSColor whiteColor] colorWithAlphaComponent:0.0].CGColor;
        color1 = [NSColor whiteColor].CGColor;
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGFloat gradLocs[] = {0, 1};

    CFArrayRef arr = (CFArrayRef)@[(id)color1, (id)color2];
    CGGradientRef grad = CGGradientCreateWithColors(colorSpace, arr, gradLocs);
    
    CGContextSaveGState(context);
    if (_isLeftToRight) {
        CGContextDrawLinearGradient(context, grad, CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x + dirtyRect.size.width, dirtyRect.origin.y), kCGGradientDrawsAfterEndLocation);
    }else {
        CGContextDrawLinearGradient(context, grad,  CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y+NSHeight(dirtyRect)), kCGGradientDrawsAfterEndLocation);
    }
    CGContextRestoreGState(context);
}

- (CGPathRef)quartzPath:(NSBezierPath *)bezierPath
    {
        int i, numElements;
        
        // Need to begin a path here.
        CGPathRef           immutablePath = NULL;
        
        // Then draw the path elements.
        numElements = (int)[bezierPath elementCount];
        if (numElements > 0)
        {
            CGMutablePathRef    path = CGPathCreateMutable();
            NSPoint             points[3];
            BOOL                didClosePath = YES;
            
            for (i = 0; i < numElements; i++)
            {
                switch ([bezierPath elementAtIndex:i associatedPoints:points])
                {
                    case NSMoveToBezierPathElement:
                        CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                        break;
                        
                    case NSLineToBezierPathElement:
                        CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                        didClosePath = NO;
                        break;
                        
                    case NSCurveToBezierPathElement:
                        CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                              points[1].x, points[1].y,
                                              points[2].x, points[2].y);
                        didClosePath = NO;
                        break;
                        
                    case NSClosePathBezierPathElement:
                        CGPathCloseSubpath(path);
                        didClosePath = YES;
                        break;
                }
            }
            
            // Be sure the path is closed or Quartz may not do valid hit detection.
            if (!didClosePath)
                CGPathCloseSubpath(path);
            
            immutablePath = CGPathCreateCopy(path);
            CGPathRelease(path);
        }
        
        return immutablePath;
    }

@end
