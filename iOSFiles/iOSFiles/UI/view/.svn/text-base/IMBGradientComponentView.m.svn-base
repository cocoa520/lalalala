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


static CGFloat const IMBGradientViewMidiumiCloudViewOriginalHeight = 180.f;
static CGFloat const IMBGradientViewMidiumDevicesViewOriginalHeight = 376.0f;
static CGFloat const IMBGradientViewMidiumViewShadow = 4.0f;


@interface IMBGradientComponentView()
{
    @private
    BOOL _isMouseEntered;
}

@end

@implementation IMBGradientComponentView

@synthesize isOriginalFrame = _isOriginalFrame;
@synthesize isDevicesOriginalFrame = _isDevicesOriginalFrame;
@synthesize disable = _disable;
@synthesize loginStatus = _loginStatus;


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
    
    
    NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
    [shadow setShadowColor:COLOR_MAIN_WINDOW_VIEW_SHADOW];
    [shadow setShadowOffset:NSMakeSize(0.0, -2.0)];
    [shadow setShadowBlurRadius:5];
    [shadow set];
    
    dirtyRect.origin.x = 0;
    dirtyRect.origin.y = 0;
    dirtyRect.size.width = self.frame.size.width;
    dirtyRect.size.height = self.frame.size.height;
//    NSRect newRect = NSMakeRect(dirtyRect.origin.x+5, dirtyRect.origin.y+5, dirtyRect.size.width-10, dirtyRect.size.height -20);
    NSBezierPath *text = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    [[NSColor whiteColor] set];
    [text fill];
}

- (void)awakeFromNib {
    [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
    _isMouseEntered = NO;
    _loginStatus = NO;
    _shadowSize = NSMakeSize(0.5f, -0.5f);
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
    if (_disable) return;
    if (_isOriginalFrame) {
//        if (_loginStatus) return;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.mouseClicked) {
                self.mouseClicked();
            }
        });
    }else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.mouseClicked) {
                self.mouseClicked();
            }
        });
    }
    
    
}

- (void)mouseUp:(NSEvent *)theEvent {
    
}

- (void)mouseEntered:(NSEvent *)theEvent {
    if (_isMouseEntered == NO && _isOriginalFrame) {
        
        _isMouseEntered = YES;
        NSRect f = self.frame;
        if (f.size.height == IMBGradientViewMidiumiCloudViewOriginalHeight) {
            f.size.height = IMBGradientViewMidiumiCloudViewOriginalHeight + IMBGradientViewMidiumViewShadow;
            [IMBViewAnimation animationMouseEnteredExitedWithView:self frame:f timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
        }
        if (f.size.height == IMBGradientViewMidiumDevicesViewOriginalHeight) {
            f.size.height = IMBGradientViewMidiumDevicesViewOriginalHeight + IMBGradientViewMidiumViewShadow;
            [IMBViewAnimation animationMouseEnteredExitedWithView:self frame:f timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
        }
        if (self.mouseEntered) {
            self.mouseEntered();
        }
    }
    
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (_isMouseEntered && _isOriginalFrame) {
        
        _isMouseEntered = NO;
        NSRect f = self.frame;
        if (f.size.height <= IMBGradientViewMidiumiCloudViewOriginalHeight + IMBGradientViewMidiumViewShadow && f.size.height >= IMBGradientViewMidiumiCloudViewOriginalHeight) {
            f.size.height = IMBGradientViewMidiumiCloudViewOriginalHeight;
//            self.frame = f;
        }
        
        if (f.size.height <= IMBGradientViewMidiumDevicesViewOriginalHeight + IMBGradientViewMidiumViewShadow && f.size.height >= IMBGradientViewMidiumDevicesViewOriginalHeight) {
            f.size.height = IMBGradientViewMidiumDevicesViewOriginalHeight;
//            self.frame = f;
        }
        [IMBViewAnimation animationMouseEnteredExitedWithView:self frame:f timeInterval:MidiumSizeAnimationTimeInterval disable:NO completion:nil];
        if (self.mouseExited) {
            self.mouseExited();
        }
    }
    
    
}

- (void)setViewShadow:(CGFloat)bottom left:(CGFloat)left{
    _shadowSize = NSMakeSize(left, bottom);
}
@end
