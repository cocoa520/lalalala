//
//  IMBGradientComponentView.m
//  iOSFiles
//
//  Created by JGehry on 3/7/18.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "IMBGradientComponentView.h"
#import "IMBCommonDefine.h"
#import "IMBViewAnimation.h"


@interface IMBGradientComponentView()
{
    @private
    BOOL _isMouseEntered;
}

@end

@implementation IMBGradientComponentView

@synthesize isOriginalFrame = _isOriginalFrame;


- (void)setIsLeftRightGridient:(BOOL)isLeftRightGridient withLeftNormalBgColor:(NSColor *)leftNormalBgColor withRightNormalBgColor:(NSColor *)rightNormalBgColor {
    _isleftRightGridient = isLeftRightGridient;
    if (_leftNormalBgColor != nil) {
        [_leftNormalBgColor release];
        _leftNormalBgColor = nil;
    }
    _leftNormalBgColor = [leftNormalBgColor retain];
    
    if (_rightNormalBgColor != nil) {
        [_rightNormalBgColor release];
        _rightNormalBgColor = nil;
    }
    _rightNormalBgColor = [rightNormalBgColor retain];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5.0 yRadius:5.0];
    [clipPath setWindingRule:NSEvenOddWindingRule];
    [clipPath addClip];
    [COLOR_TEXT_TABLEVIEW_CELLLOSEFOCUS set];
    [clipPath fill];
    
    
    NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
    [shadow setShadowColor:COLOR_TEXT_LINE];
    [shadow setShadowOffset:_shadowSize];
    [shadow setShadowBlurRadius:4];
    [shadow set];
    dirtyRect.origin.x = 0;
    dirtyRect.origin.y = 0;
    dirtyRect.size.width = self.frame.size.width;
    dirtyRect.size.height = self.frame.size.height;
    NSRect newRect = NSMakeRect(dirtyRect.origin.x+5, dirtyRect.origin.y+5, dirtyRect.size.width-10, dirtyRect.size.height -10);
    NSBezierPath *text = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:5 yRadius:5];
    [[NSColor whiteColor] set];
    [text fill];
    
    [[NSColor colorWithCalibratedWhite:0.9 alpha:0.0] set];
    [text stroke];
//    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    NSBezierPath *path = nil;
//    CGContextAddPath(context, [self quartzPath:path]);
//    CGContextClip(context);
//    CGContextSaveGState(context);
//    const CGFloat glossGradientLocations[] = {0.1,1.0};
//    const CGFloat glossGradientComponents[] = {_leftNormalBgColor.redComponent,_leftNormalBgColor.greenComponent,_leftNormalBgColor.blueComponent,1.0f,_rightNormalBgColor.redComponent,_rightNormalBgColor.greenComponent,_rightNormalBgColor.blueComponent,1.0f};
//    
//    CGGradientRef glossCradient = CGGradientCreateWithColorComponents(colorSpace, glossGradientComponents, glossGradientLocations,2);
//    if (_isleftRightGridient) {
//        int radius = 5;
//        CGContextMoveToPoint(context, NSWidth(dirtyRect)- radius, 0);
//        CGContextAddLineToPoint(context, radius, 0);
//        CGContextAddArc(context, radius, radius, radius, M_PI_2 , M_PI , YES);
//        CGContextAddLineToPoint(context,  0, NSHeight(dirtyRect) - radius);
//        CGContextAddArc(context, radius, NSHeight(dirtyRect) - radius,radius, M_PI, M_PI_2, YES);
//        CGContextAddLineToPoint(context, NSWidth(dirtyRect) - radius, NSHeight(dirtyRect));
//        CGContextAddArc(context, NSWidth(dirtyRect) - radius, NSHeight(dirtyRect) - radius, radius, M_PI_2, 0, YES);
//        CGContextAddLineToPoint(context, NSWidth(dirtyRect), radius);
//        CGContextAddArc(context, NSWidth(dirtyRect) - radius, radius, radius, 0, M_PI_2, YES);
//        CGContextClip(context);//context裁剪路径,后续操作的路径
//        CGContextDrawLinearGradient(context, glossCradient, CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y+NSHeight(dirtyRect)), kCGGradientDrawsAfterEndLocation);
//    }else{
//        CGContextDrawLinearGradient(context, glossCradient, CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y+NSHeight(dirtyRect)), kCGGradientDrawsAfterEndLocation);
//    }
//    CGGradientRelease(glossCradient);
}

- (void)awakeFromNib {
    [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
    _isMouseEntered = NO;
    _shadowSize = NSMakeSize(0, 0);
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

-(void)dealloc {
    if (_leftNormalBgColor != nil) {
        [_leftNormalBgColor release];
        _leftNormalBgColor = nil;
    }
    if (_rightNormalBgColor != nil) {
        [_rightNormalBgColor release];
        _rightNormalBgColor = nil;
    }
    [super dealloc];
}


- (void)mouseDown:(NSEvent *)theEvent {
    if (self.mouseClicked) {
        self.mouseClicked();
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    IMBFLog(@"IMBGradientComponentView--mouseEntered");
    if (_isMouseEntered == NO && _isOriginalFrame) {
        
        _isMouseEntered = YES;
        IMBFLog(@"IMBGradientComponentView--mouseEntered");
        NSRect f = self.frame;
        if (f.size.height == 180) {
            f.size.height = 185.0f;
            self.frame = f;
            [self setViewShadow:-5];
        }
        if (f.size.height == 376) {
            f.size.height = 381.0f;
            self.frame = f;
            [self setViewShadow:-5];
        }
        if (self.mouseEntered) {
            self.mouseEntered();
        }
    }
    
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (_isMouseEntered && _isOriginalFrame) {
        
        _isMouseEntered = NO;
        IMBFLog(@"IMBGradientComponentView--mouseExited");
        NSRect f = self.frame;
        if (f.size.height == 185) {
            f.size.height = 180.0f;
            self.frame = f;
            [self setViewShadow:0];
        }
        
        if (f.size.height == 381) {
            f.size.height = 376.0f;
            self.frame = f;
            [self setViewShadow:0];
        }
        
        if (self.mouseExited) {
            self.mouseExited();
        }
    }
    
    
}

- (void)setViewShadow:(CGFloat)bottom {
    _shadowSize = NSMakeSize(0, bottom);
}
@end
