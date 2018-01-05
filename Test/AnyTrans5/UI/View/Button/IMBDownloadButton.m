//
//  IMBDownloadButton.m
//  AnyTrans
//
//  Created by LuoLei on 16-12-20.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBDownloadButton.h"
#import "StringHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "IMBNotificationDefine.h"
@implementation IMBDownloadButton
@synthesize font = _font;
@synthesize fontColor = _fontColor;
@synthesize fontEnterColor = _fontEnterColor;
@synthesize fontDownColor = _fontDownColor;
@synthesize iconImage = _iconImage;
@synthesize variableWidth = _variableWidth;
@synthesize leftnormalFillColor = _leftnormalFillColor;
@synthesize rightnormalFillColor = _rightnormalFillColor;
@synthesize leftenterFillColor = _leftenterFillColor;
@synthesize rightenterFillColor = _rightenterFillColor;
@synthesize leftdownFillColor = _leftdownFillColor;
@synthesize rightdownFillColor = _rightdownFillColor;
@synthesize borderColor = _borderColor;
@synthesize isleftright = _isleftright;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setUp];

    }
    return self;
}

- (void)setUp
{
    _isleftright = YES;
    [self.cell setHighlightsBy:NSNoCellMask];
    self.font = [NSFont fontWithName:@"Helvetica Neue" size:14.0];
    self.fontEnterColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    self.fontDownColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    self.fontColor = [StringHelper getColorFromString:CustomColor(@"text_shopCar_buyColor", nil)];
    _minWidth = 100;
    _cornerRadius = 5;
    _parseLayer = [[CALayer layer] retain];
    [_parseLayer setFrame:CGRectMake(0, 0, 20, 40)];
    _parseLayer.contents = [StringHelper imageNamed:@"download_analying"];
    [_parseLayer setAnchorPoint:CGPointMake(0, 0)];
    [self setWantsLayer:YES];
    [self.layer setAnchorPoint:CGPointMake(0, 0)];
    _variableWidth = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
}

- (void)awakeFromNib
{
    [self setUp];
}

- (void)setIsleftright:(BOOL)isleftright
{
    _isleftright = isleftright;
    [self setNeedsDisplay:YES];
}

- (void)startParseAnimation
{
    [self setEnabled:NO];
    [self.layer addSublayer:_parseLayer];
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyframeAnimation.duration = 2.0;
    keyframeAnimation.repeatCount = NSIntegerMax;
    keyframeAnimation.removedOnCompletion = NO;
    keyframeAnimation.fillMode = kCAFillModeForwards;
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &transform, -20, 0);
    CGPathAddLineToPoint(path, &transform, NSWidth(self.frame) - 20, 0);
    keyframeAnimation.autoreverses = NO;
    keyframeAnimation.path = path;
    CGPathRelease(path);
    [_parseLayer addAnimation:keyframeAnimation forKey:@"animabar"];
}

- (void)stopParseAnimation
{
    [self setEnabled:YES];
    [_parseLayer removeAllAnimations];
    [_parseLayer removeFromSuperlayer];
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    if (_trackingArea == nil) {
        NSTrackingAreaOptions options =  (NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate);
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil] ;
        [self addTrackingArea:_trackingArea];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    
//    NSBezierPath *rightPath = [NSBezierPath bezierPath];
//    [rightPath setWindingRule:NSEvenOddWindingRule];
//    [rightPath moveToPoint:NSMakePoint(0, 0)];
//    [rightPath lineToPoint:NSMakePoint(dirtyRect.size.width - _cornerRadius, 0)];
//    [rightPath appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.size.width - _cornerRadius, _cornerRadius) radius:_cornerRadius startAngle:270 endAngle:0 clockwise:NO];
//    [rightPath lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height - _cornerRadius)];
//    [rightPath appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.size.width - _cornerRadius, dirtyRect.size.height - _cornerRadius) radius:_cornerRadius startAngle:0 endAngle:90 clockwise:NO];
//    [rightPath lineToPoint:NSMakePoint(0, dirtyRect.size.height)];
//    [rightPath lineToPoint:NSMakePoint(0, 0)];
//    [rightPath setLineWidth:2];
//    [rightPath addClip];
//    [rightPath closePath];
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5.0 yRadius:5.0];
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (NSWidth(dirtyRect)>0) {
        CGContextAddPath(context, [path quartzPath]);
        CGContextClip(context);
        CGContextSaveGState(context);
        {
            const CGFloat glossGradientLocations[] = {0.1,1.0};
            //创建颜色渐变对象
            if (_mouseDown) {
                const CGFloat glossGradientComponents[] = {_leftdownFillColor.redComponent,_leftdownFillColor.greenComponent,_leftdownFillColor.blueComponent,1.0f,_rightdownFillColor.redComponent,_rightdownFillColor.greenComponent,_rightdownFillColor.blueComponent,1.0f};
                
                CGGradientRef glossCradient = CGGradientCreateWithColorComponents(colorSpace, glossGradientComponents, glossGradientLocations,2);
                if (_isleftright) {
                    CGContextDrawLinearGradient(context, glossCradient, CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x + dirtyRect.size.width, dirtyRect.origin.y), kCGGradientDrawsAfterEndLocation);
                }else{
                    CGContextDrawLinearGradient(context, glossCradient, CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y+NSHeight(dirtyRect)), kCGGradientDrawsAfterEndLocation);
                }
                CGGradientRelease(glossCradient);
            }else if (_mouseEnter){
                const CGFloat glossGradientComponents[] = {_leftenterFillColor.redComponent,_leftenterFillColor.greenComponent,_leftenterFillColor.blueComponent,1.0f,_rightenterFillColor.redComponent,_rightenterFillColor.greenComponent,_rightenterFillColor.blueComponent,1.0f};
                
                CGGradientRef glossCradient = CGGradientCreateWithColorComponents(colorSpace, glossGradientComponents, glossGradientLocations,2);
                if (_isleftright) {
                    CGContextDrawLinearGradient(context, glossCradient, CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x + dirtyRect.size.width, dirtyRect.origin.y), kCGGradientDrawsAfterEndLocation);
                }else{
                    CGContextDrawLinearGradient(context, glossCradient, CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y+NSHeight(dirtyRect)), kCGGradientDrawsAfterEndLocation);
                }

                CGGradientRelease(glossCradient);
            }else{
                const CGFloat glossGradientComponents[] = {_leftnormalFillColor.redComponent,_leftnormalFillColor.greenComponent,_leftnormalFillColor.blueComponent,1.0f,_rightnormalFillColor.redComponent,_rightnormalFillColor.greenComponent,_rightnormalFillColor.blueComponent,1.0f};
                
                CGGradientRef glossCradient = CGGradientCreateWithColorComponents(colorSpace, glossGradientComponents, glossGradientLocations,2);
                if (_isleftright) {
                    CGContextDrawLinearGradient(context, glossCradient, CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x + dirtyRect.size.width, dirtyRect.origin.y), kCGGradientDrawsAfterEndLocation);
                }else{
                    CGContextDrawLinearGradient(context, glossCradient, CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y+NSHeight(dirtyRect)), kCGGradientDrawsAfterEndLocation);
                }

                CGGradientRelease(glossCradient);
            }
        }
        CGContextRestoreGState(context);
    }
    CGColorSpaceRelease(colorSpace);
    
    /**
     *  文字垂直居中
     */
    NSString *str = self.title;
    NSColor *color = nil;
    color = self.fontColor;
    if (_mouseEnter) {
        color = self.fontEnterColor;
    }else if (_mouseDown){
        color = self.fontDownColor;
    }
    NSRect drawRect = dirtyRect;
    NSRect iconRect = NSMakeRect(0, ceilf((NSHeight(dirtyRect) - _iconImage.size.height)/2) , _iconImage.size.width, _iconImage.size.height);
    NSRect titleRect = [StringHelper calcuTextBounds:str fontSize:_font.pointSize];
    
    
    if (titleRect.size.width<dirtyRect.size.width-4) {
        drawRect.size.width = titleRect.size.width;
        if (_iconImage != nil) {
            iconRect.origin.x = ceil((dirtyRect.size.width - titleRect.size.width - _iconImage.size.width-4)/2);
            drawRect.origin.x = ceil((dirtyRect.size.width - titleRect.size.width - _iconImage.size.width)/2) + _iconImage.size.width+4;

        }else{
            drawRect.origin.x = ceil((dirtyRect.size.width - titleRect.size.width)/2);
        }
        
        if (self.font.pointSize == 12.0||self.font.pointSize == 14.0) {
            drawRect.origin.y = ceil((dirtyRect.size.height - titleRect.size.height - 5)/2);
        }else if (self.font.pointSize == 16.0||self.font.pointSize == 24.0) {
            drawRect.origin.y = ceil((dirtyRect.size.height - titleRect.size.height)/2-2);
        }
    }else {
        drawRect.size.width = dirtyRect.size.width-4;
        drawRect.origin.x = 2;
        drawRect.origin.y = ceil((dirtyRect.size.height - titleRect.size.height)/2);
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[_font, color] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
    [str drawInRect:drawRect withAttributes:dic];
    if (_iconImage != nil) {
        [_iconImage drawInRect:iconRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    }
    if (!_mouseEnter&&_borderColor != nil) {
        [_borderColor setStroke];
        [path stroke];
    }else{
        [[NSColor clearColor] setStroke];
        [path stroke];
    }
}

- (void)setEnabled:(BOOL)flag
{
    [super setEnabled:flag];
    if (flag) {
        [self setAlphaValue:1.0];
    }else {
        [self setAlphaValue:0.7];

    }
}


- (void)setTitle:(NSString *)aString {
    [super setTitle:aString];
    if (_variableWidth) {
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:(aString?aString:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName,nil]];
        int lengthInt = 0;
        if (title.size.width < 56) {
            lengthInt = 56;
        }else {
            lengthInt = title.size.width;
            if (lengthInt % 2 != 0) {
                lengthInt = title.size.width + 1;
            }
        }
        if (self.font.pointSize == 14.0) {
            lengthInt += 4;
            if (lengthInt<80) {
                lengthInt = 80;
            }
        }else if (self.font.pointSize == 16.0) {
            lengthInt += 16;
            if (lengthInt<100) {
                lengthInt = 100;
            }
        }else if (self.font.pointSize == 18.0) {
            lengthInt += 20;
            if (lengthInt<100) {
                lengthInt = 100;
            }
        }else if (self.font.pointSize == 24.0) {
            lengthInt += 52;
            if (lengthInt<200) {
                lengthInt = 200;
            }
        }else if (self.font.pointSize == 12.0) {
            lengthInt += 10;
            if (lengthInt<60) {
                lengthInt = 60;
            }else{
                lengthInt += 10;
            }
        }
        if (lengthInt<_minWidth) {
            lengthInt = _minWidth;
        }
        if (_iconImage != nil) {
            lengthInt+= _iconImage.size.width+4;
        }
        [self setFrameSize:NSMakeSize(lengthInt, self.frame.size.height)];
        [self setNeedsDisplay:YES];
        [title release];
        title = nil;
     }
}



#pragma mark - Mouse Actions
- (void)mouseEntered:(NSEvent *)theEvent
{
    if (self.isEnabled) {
        _mouseEnter = YES;
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseExited:(NSEvent *)theEvent
{
    if (self.isEnabled) {
        _mouseEnter = NO;
        _mouseDown = NO;
        [super mouseExited:theEvent];
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (self.isEnabled) {
        _mouseDown = YES;
        _mouseEnter = NO;
        [self setNeedsDisplay:YES];
        [super mouseDown:theEvent];
        _mouseDown = NO;
        _mouseEnter = NO;
        [self setNeedsDisplay:YES];
    }
}

- (void)changeSkin:(NSNotification *)noti {
    _parseLayer.contents = [StringHelper imageNamed:@"download_analying"];
    [self setNeedsDisplay:YES];
}

- (void)dealloc
{
    [_leftnormalFillColor release],_leftnormalFillColor = nil;
    [_rightnormalFillColor release],_rightnormalFillColor = nil;
    [_leftenterFillColor release],_leftenterFillColor = nil;
    [_rightenterFillColor release],_rightenterFillColor = nil;
    [_leftdownFillColor release],_leftdownFillColor = nil;
    [_rightdownFillColor release],_rightdownFillColor = nil;
    [_trackingArea release];_trackingArea = nil;
    [_font release],_font = nil;
    [_fontColor release],_fontColor = nil;
    [_fontDownColor release],_fontDownColor = nil;
    [_fontEnterColor release],_fontEnterColor = nil;
    [_parseLayer release],_parseLayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}
@end
