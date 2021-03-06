//
//  IMBGridientButton.m
//  FontTest
//
//  Created by m on 17/3/7.
//  Copyright (c) 2017年 iMobie. All rights reserved.
//

#import "IMBGridientButton.h"
#import "IMBAnimation.h"
#import "StringHelper.h"
@implementation IMBGridientButton

@synthesize isLeftRightGridient = _isleftRightGridient;
@synthesize hasBorder = _hasBorder;
@synthesize cornerRadius = _cornerRadius;
@synthesize borderLineWidth = _borderLineWidth;
@synthesize hasLeftImage = _hasLeftImage;
@synthesize hasRightImage = _hasRightImage;
@synthesize spaceWithText = _spaceWithText;
@synthesize leftImage = _leftImage;
@synthesize rightImage = _rightImage;
@synthesize dic = _dic;
@synthesize isAnimation = _isAnimation;
@synthesize isScanView = _isScanView;
@synthesize delegate = _delegate;
@synthesize isiCloudCompleteBtn = _isiCloudCompleteBtn;
@synthesize buttonTitle = _buttonTitle;
@synthesize isMoveToiOSBtn = _isMoveToiOSBtn;
@synthesize isAirBackupBtn = _isAirBackupBtn;
@synthesize isNoGridient = _isNoGridient;

- (void)setIsLeftRightGridient:(BOOL)isLeftRightGridient withLeftNormalBgColor:(NSColor *)leftNormalBgColor withRightNormalBgColor:(NSColor *)rightNormalBgColor  withLeftEnterBgColor:(NSColor *)leftEnterBgColor withRightEnterBgColor:(NSColor *)rightEnterBgColor withLeftDownBgColor:(NSColor *)leftDownBgColor withRightDownBgColor:(NSColor *)rightDownBgColor withLeftForbiddenBgColor:(NSColor *)leftForbiddenBgColor withRightForbiddenBgColor:(NSColor *)rightForbiddenBgColor {
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
    
    if (_leftEnterBgColor != nil) {
        [_leftEnterBgColor release];
        _leftEnterBgColor = nil;
    }
    _leftEnterBgColor = [leftEnterBgColor retain];
    
    if (_rightEnterBgColor != nil) {
        [_rightEnterBgColor release];
        _rightEnterBgColor = nil;
    }
    _rightEnterBgColor = [rightEnterBgColor retain];
    
    if (_leftDownBgColor != nil) {
        [_leftDownBgColor release];
        _leftDownBgColor = nil;
    }
    _leftDownBgColor = [leftDownBgColor retain];
    
    if (_rightDownBgColor != nil) {
        [_rightDownBgColor release];
        _rightDownBgColor = nil;
    }
    _rightDownBgColor = [rightDownBgColor retain];
    
    if (_leftForbiddenBgColor != nil) {
        [_leftForbiddenBgColor release];
        _leftForbiddenBgColor = nil;
    }
    _leftForbiddenBgColor = [leftForbiddenBgColor retain];
    
    if (_rightForbiddenBgColor != nil) {
        [_rightForbiddenBgColor release];
        _rightForbiddenBgColor = nil;
    }
    _rightForbiddenBgColor = [rightForbiddenBgColor retain];
    [self setNeedsDisplay:YES];
    
}

- (void)setButtonBorder:(BOOL)hasBorder withNormalBorderColor:(NSColor *)normalBorderColor withEnterBorderColor:(NSColor *)enterBorderColor withDownBorderColor:(NSColor *)downBorderColor withForbiddenBorderColor:(NSColor *)forbiddenBorderColor withBorderLineWidth:(float)borderLineWidth {
    _hasBorder = hasBorder;
    if (_normalBorderColor != nil) {
        [_normalBorderColor release];
        _normalBorderColor = nil;
    }
    _normalBorderColor = [normalBorderColor retain];
    
    if (_enterBorderColor != nil) {
        [_enterBorderColor release];
        _enterBorderColor = nil;
    }
    _enterBorderColor = [enterBorderColor retain];
    
    if (_downBorderColor != nil) {
        [_downBorderColor release];
        _downBorderColor = nil;
    }
    _downBorderColor = [downBorderColor retain];
    
    if (_forbiddenBorderColor != nil) {
        [_forbiddenBorderColor release];
        _forbiddenBorderColor = nil;
    }
    _forbiddenBorderColor = [forbiddenBorderColor retain];
    _borderLineWidth = borderLineWidth;
    [self setNeedsDisplay:YES];
}


- (void)setButtonTitle:(NSString *)buttonTitle withNormalTitleColor:(NSColor *)normalTitleColor withEnterTitleColor:(NSColor *)enterTitleColor withDownTitleColor:(NSColor *)downTitleColor withForbiddenTitleColor:(NSColor *)forbiddenTitleColor withTitleSize:(float)titleSize WithLightAnimation:(BOOL)isAnimation{
    
    _isAnimation = isAnimation;
    if (_buttonTitle != nil) {
        [_buttonTitle release];
        _buttonTitle = nil;
    }
    _buttonTitle = [buttonTitle retain];
    
    if (_normalTitleColor != nil) {
        [_normalTitleColor release];
        _normalTitleColor = nil;
    }
    _normalTitleColor = [normalTitleColor retain];
    
    if (_enterTitleColor != nil) {
        [_enterTitleColor release];
        _enterTitleColor = nil;
    }
    _enterTitleColor = [enterTitleColor retain];
    
    if (_downTitleColor != nil) {
        [_downTitleColor release];
        _downTitleColor = nil;
    }
    _downTitleColor = [downTitleColor retain];
    
    if (_forbiddenTitleColor != nil) {
        [_forbiddenTitleColor release];
        _forbiddenTitleColor = nil;
    }
    _forbiddenTitleColor = [forbiddenTitleColor retain];
    _titleSize = titleSize;
    if (_isAnimation) {
        [self lightMoveAnimation];
    }
    [self setNeedsDisplay:YES];
}

- (void)setNormalFillColor:(NSColor *)normalFillColor WithEnterFillColor:(NSColor *)enterFillColor WithDownFillColor:(NSColor *)downFillColor {
    if (_normalFillColor != nil) {
        [_normalFillColor release];
        _normalFillColor = nil;
    }
    _normalFillColor = [normalFillColor retain];
    if (_enterFillColor != nil) {
        [_enterFillColor release];
        _enterFillColor = nil;
    }
    _enterFillColor = [enterFillColor retain];
    if (_downFillColor != nil) {
        [_downFillColor release];
        _downFillColor = nil;
    }
    _downFillColor = [downFillColor retain];
}

- (void)setBgNormalFillColor:(NSColor *)bgNormalFillColor WithBgEnterFillColor:(NSColor *)bgEnterFillColor WithBgDownFillColor:(NSColor *)BgDownFillColor {
    if (_bgNormalFillColor != nil) {
        [_bgNormalFillColor release];
        _bgNormalFillColor = nil;
    }
    _bgNormalFillColor = [bgNormalFillColor retain];
    if (_bgEnterFillColor != nil) {
        [_bgEnterFillColor release];
        _bgEnterFillColor = nil;
    }
    _bgEnterFillColor = [bgEnterFillColor retain];
    if (_bgDownFillColor != nil) {
        [_bgDownFillColor release];
        _bgDownFillColor = nil;
    }
    _bgDownFillColor = [BgDownFillColor retain];
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

-(void)mouseDown:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = MouseDown;
        [self setNeedsDisplay:YES];
    }
}

-(void)mouseUp:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = MouseUp;
        [_delegate mouseUpTag:(int)self.tag];
        [self setNeedsDisplay:YES];
        NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
        BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
        if (inner&&theEvent.clickCount ==1) {
            [NSApp sendAction:self.action to:self.target from:self];
        }
    }
}

-(void)mouseExited:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = MouseOut;
        [self setNeedsDisplay:YES];
        [_delegate mouseUpTag:(int)self.tag];
    }
    
}

-(void)mouseEntered:(NSEvent *)theEvent{
    if (self.isEnabled) {
        _buttonType = MouseEnter;
         [self setNeedsDisplay:YES];
        [_delegate mouseEnterTag:(int)self.tag];
    }
}

- (void)setEnabled:(BOOL)flag{
    [super setEnabled:flag];
    if (self.isEnabled) {
        [_lightImageView setHidden:NO];
    }else{
        [_lightImageView setHidden:YES];
    }
}

///将NSImage转换为CGImageRef
- (CGImageRef)NSImageToCGImageRef:(NSImage*)image;
{
    NSData * imageData = [image TIFFRepresentation];
    CGImageRef imageRef;
    if(imageData)
    {
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData,  NULL);
        
        imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    }
    return imageRef;
}

- (void)lightMoveAnimation{
    [self setWantsLayer:YES];
    CALayer *oneLayer = [CALayer layer];
    oneLayer.name = @"one";
    NSImage *image1 = [StringHelper imageNamed:@"next_light"];
    oneLayer.contents = (id)[self NSImageToCGImageRef:image1];
    oneLayer.frame = CGRectMake(-20, -6, 52, 80);
    
    [self.layer addSublayer:oneLayer];
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSNumber numberWithInt:-52];
    animation.toValue=[NSNumber numberWithInt:self.frame.size.width];
    animation.duration=2.0;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.autoreverses = NO;
    animation.repeatCount = FLT_MAX;
    [oneLayer addAnimation:animation forKey:@"move"];
}

- (void)drawRect:(NSRect)dirtyRect {
    
    NSString *str = _buttonTitle;
    NSColor *color = nil;
    if (self.isEnabled) {
        if (_buttonType == MouseUp) {
            color = _normalTitleColor;
        }else if (_buttonType == MouseEnter ) {
            color = _enterTitleColor;
        }else if (_buttonType == MouseDown){
            color = _downTitleColor;
        }else{
            color = _normalTitleColor;
        }
    }else {
        color = _forbiddenTitleColor;
    }

    NSRect drawRect = dirtyRect;
    NSRect titleRect = [self calcuTextBounds:str fontSize:_titleSize];

    if (titleRect.size.width<dirtyRect.size.width-4) {
        drawRect.size.width = titleRect.size.width;
        if (_hasLeftImage) {
            if (_leftImage) {
                drawRect.origin.x = ceil((dirtyRect.size.width - titleRect.size.width - _leftImage.size.width - _spaceWithText)/2) + _leftImage.size.width + _spaceWithText ;
            }
        }else if (_hasRightImage) {
            if (_rightImage) {
                drawRect.origin.x = ceil((dirtyRect.size.width - titleRect.size.width - _rightImage.size.width - _spaceWithText)/2);
            }
        }else {
            drawRect.origin.x = ceil((dirtyRect.size.width - titleRect.size.width)/2);
            drawRect.origin.y = ceil((dirtyRect.size.height - titleRect.size.height)/2-1);
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
    NSBezierPath *path = nil;
    NSBezierPath *btnPath = nil;
    NSRect btnRect = drawRect;
    if (_isMoveToiOSBtn) {
        if (_cornerRadius) {
            path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:_cornerRadius yRadius:_cornerRadius];
        }else {
            path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5.0 yRadius:5.0];
        }
        [path addClip];
        [path setWindingRule:NSEvenOddWindingRule];
        NSColor *bottomColor = nil;
        if (_buttonType == MouseEnter) {
            bottomColor = _bgEnterFillColor;
        } else if (_buttonType == MouseUp) {
            bottomColor = _bgNormalFillColor;
        } else if (_buttonType == MouseDown) {
            bottomColor = _bgDownFillColor;
        } else if (_buttonType == MouseOut) {
            bottomColor = _bgNormalFillColor;
        } else {
            bottomColor = _bgNormalFillColor;
        }
        [bottomColor setFill];
        [path fill];
        [path closePath];
        
        btnRect = NSMakeRect(dirtyRect.origin.x, dirtyRect.origin.y - 2, dirtyRect.size.width, dirtyRect.size.height - 2);
        drawRect = NSMakeRect(drawRect.origin.x, btnRect.origin.y, drawRect.size.width, drawRect.size.height);
        if (_cornerRadius) {
            btnPath = [NSBezierPath bezierPathWithRoundedRect:btnRect xRadius:_cornerRadius yRadius:_cornerRadius];
        }else {
            btnPath = [NSBezierPath bezierPathWithRoundedRect:btnRect xRadius:5.0 yRadius:5.0];
        }
        [btnPath addClip];
        [btnPath setWindingRule:NSEvenOddWindingRule];
        NSColor *fillColor = nil;
        if (_buttonType == MouseEnter) {
            fillColor = _enterFillColor;
        } else if (_buttonType == MouseUp) {
            fillColor = _normalFillColor;
        } else if (_buttonType == MouseDown) {
            fillColor = _downFillColor;
        } else if (_buttonType == MouseOut) {
            fillColor = _normalFillColor;
        } else {
            fillColor = _normalFillColor;
        }
        [fillColor setFill];
        [btnPath fill];
        [btnPath closePath];
        
    } else {
        if (_cornerRadius) {
            path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:_cornerRadius yRadius:_cornerRadius];
        }else {
            path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5.0 yRadius:5.0];
        }
        if (_borderLineWidth) {
            [path setLineWidth:_borderLineWidth];
        }
        if (_isNoGridient) {
            [path addClip];
            [path setWindingRule:NSEvenOddWindingRule];
            NSColor *fillColor = nil;
            if (_buttonType == MouseEnter) {
                fillColor = _enterFillColor;
            } else if (_buttonType == MouseUp) {
                fillColor = _normalFillColor;
            } else if (_buttonType == MouseDown) {
                fillColor = _downFillColor;
            } else if (_buttonType == MouseOut) {
                fillColor = _normalFillColor;
            } else {
                fillColor = _normalFillColor;
            }
            [fillColor setFill];
            [path fill];
            [path closePath];
        } else {
            CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            if (NSWidth(dirtyRect)>0) {
                CGContextAddPath(context, [self quartzPath:path]);
                CGContextClip(context);
                CGContextSaveGState(context);
                {
                    const CGFloat glossGradientLocations[] = {0.1,1.0};
                    //创建颜色渐变对象
                    if (self.isEnabled) {
                        if (_buttonType == MouseDown) {
                            const CGFloat glossGradientComponents[] = {_leftDownBgColor.redComponent,_leftDownBgColor.greenComponent,_leftDownBgColor.blueComponent,1.0f,_rightDownBgColor.redComponent,_rightDownBgColor.greenComponent,_rightDownBgColor.blueComponent,1.0f};
                            
                            CGGradientRef glossCradient = CGGradientCreateWithColorComponents(colorSpace, glossGradientComponents, glossGradientLocations,2);
                            if (_isleftRightGridient) {
                                CGContextDrawLinearGradient(context, glossCradient, CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x + dirtyRect.size.width, dirtyRect.origin.y), kCGGradientDrawsAfterEndLocation);
                            }else{
                                CGContextDrawLinearGradient(context, glossCradient, CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y+NSHeight(dirtyRect)), kCGGradientDrawsAfterEndLocation);
                            }
                            CGGradientRelease(glossCradient);
                        }else if (_buttonType == MouseEnter){
                            const CGFloat glossGradientComponents[] = {_leftEnterBgColor.redComponent,_leftEnterBgColor.greenComponent,_leftEnterBgColor.blueComponent,1.0f,_rightEnterBgColor.redComponent,_rightEnterBgColor.greenComponent,_rightEnterBgColor.blueComponent,1.0f};
                            
                            CGGradientRef glossCradient = CGGradientCreateWithColorComponents(colorSpace, glossGradientComponents, glossGradientLocations,2);
                            if (_isleftRightGridient) {
                                CGContextDrawLinearGradient(context, glossCradient, CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x + dirtyRect.size.width, dirtyRect.origin.y), kCGGradientDrawsAfterEndLocation);
                            }else{
                                CGContextDrawLinearGradient(context, glossCradient, CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y+NSHeight(dirtyRect)), kCGGradientDrawsAfterEndLocation);
                            }
                            
                            CGGradientRelease(glossCradient);
                        }else{
                            if (_leftNormalBgColor) {
                                const CGFloat glossGradientComponents[] = {_leftNormalBgColor.redComponent,_leftNormalBgColor.greenComponent,_leftNormalBgColor.blueComponent,1.0f,_rightNormalBgColor.redComponent,_rightNormalBgColor.greenComponent,_rightNormalBgColor.blueComponent,1.0f};
                                
                                CGGradientRef glossCradient = CGGradientCreateWithColorComponents(colorSpace, glossGradientComponents, glossGradientLocations,2);
                                if (_isleftRightGridient) {
                                    CGContextDrawLinearGradient(context, glossCradient, CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x + dirtyRect.size.width, dirtyRect.origin.y), kCGGradientDrawsAfterEndLocation);
                                }else{
                                    CGContextDrawLinearGradient(context, glossCradient, CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y), CGPointMake(dirtyRect.origin.x, dirtyRect.origin.y+NSHeight(dirtyRect)), kCGGradientDrawsAfterEndLocation);
                                }
                                
                                CGGradientRelease(glossCradient);
                            }
                        }
                    }else {
                        const CGFloat glossGradientComponents[] = {_leftForbiddenBgColor.redComponent,_leftForbiddenBgColor.greenComponent,_leftForbiddenBgColor.blueComponent,1.0f,_rightForbiddenBgColor.redComponent,_rightForbiddenBgColor.greenComponent,_rightForbiddenBgColor.blueComponent,1.0f};
                        
                        CGGradientRef glossCradient = CGGradientCreateWithColorComponents(colorSpace, glossGradientComponents, glossGradientLocations,2);
                        if (_isleftRightGridient) {
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
        }
        
    }
    
    NSFont *font = nil;
    if (_isiCloudCompleteBtn) {
        font = [NSFont fontWithName:@"Helvetica Neue Bold" size:_titleSize];
    } else if (_isMoveToiOSBtn){
        font = [NSFont fontWithName:@"Helvetica Neue Medium" size:_titleSize];
    } else {
        font = [NSFont fontWithName:@"Helvetica Neue" size:_titleSize];
    }
    
    if (color) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[font, color] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
        if (_hasRightImage) {
            [_buttonTitle drawInRect:NSMakeRect(drawRect.origin.x - 5,(drawRect.size.height - titleRect.size.height) / 2.0 - 2, titleRect.size.width, titleRect.size.height) withAttributes:dic];
        } else if (_hasLeftImage) {
            if (_isAirBackupBtn) {
                [_buttonTitle drawInRect:NSMakeRect(drawRect.origin.x + 2,(drawRect.size.height - titleRect.size.height) / 2.0 - 1, titleRect.size.width, titleRect.size.height) withAttributes:dic];
            } else {
                [_buttonTitle drawInRect:NSMakeRect(drawRect.origin.x,(drawRect.size.height - titleRect.size.height) / 2.0 - 4, titleRect.size.width, titleRect.size.height) withAttributes:dic];
            }
            
        } else {
            if (_isAirBackupBtn) {
                [_buttonTitle drawInRect:NSMakeRect(drawRect.origin.x,(drawRect.size.height - titleRect.size.height) / 2.0 - 2, titleRect.size.width, titleRect.size.height) withAttributes:dic];
            } else {
                [_buttonTitle drawInRect:drawRect withAttributes:dic];
            }
            
        }
        
    }
    
    //draw 文字旁边的图片
    if(_hasLeftImage) {
        if (_leftImage) {
            if (_isAirBackupBtn) {
                [_leftImage drawInRect:NSMakeRect(drawRect.origin.x - _leftImage.size.width - _spaceWithText - 3, (drawRect.size.height - _leftImage.size.height) / 2.0 + 1, _leftImage.size.width, _leftImage.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            } else {
                [_leftImage drawInRect:NSMakeRect(drawRect.origin.x - _leftImage.size.width - _spaceWithText - 3, (drawRect.size.height - _leftImage.size.height) / 2.0 - 2, _leftImage.size.width, _leftImage.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
            }
            
        }
    }else if (_hasRightImage) {
        if (_rightImage) {
            [_rightImage drawInRect:NSMakeRect(drawRect.origin.x + titleRect.size.width + _spaceWithText,(drawRect.size.height - _rightImage.size.height) / 2.0, _rightImage.size.width, _rightImage.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        }
    }

    if (_hasBorder) {
        if (self.isEnabled) {
            if (_buttonType == MouseOut && _normalBorderColor != nil) {
                [_normalBorderColor setStroke];
            }else if (_buttonType == MouseEnter && _enterBorderColor != nil) {
                [_enterBorderColor setStroke];
            }else if (_buttonType == MouseUp && _enterBorderColor != nil) {
                [_normalBorderColor setStroke];
            }else if (_buttonType == MouseDown && _downBorderColor != nil) {
                [_downBorderColor setStroke];
            }else {
                [_normalBorderColor setStroke];
            }
        }else {
             [_forbiddenBorderColor setStroke];
        }
        [path stroke];
    }else{
        [[NSColor clearColor] setStroke];
        [path stroke];
    }
}

- (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize {
    NSRect textBounds = NSMakeRect(0, 0, 0, 0);
    if (text) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [paragraphStyle setAlignment:NSLeftTextAlignment];
        NSDictionary *attributes = nil;
        if (_isiCloudCompleteBtn) {
            attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSFont fontWithName:@"Helvetica Neue Bold" size:fontSize], NSFontAttributeName,
                          paragraphStyle, NSParagraphStyleAttributeName,
                          nil];
        } else if (_isMoveToiOSBtn) {
            attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSFont fontWithName:@"Helvetica Neue Medium" size:fontSize], NSFontAttributeName,
                          paragraphStyle, NSParagraphStyleAttributeName,
                          nil];
        } else {
            attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSFont fontWithName:@"Helvetica Neue" size:fontSize], NSFontAttributeName,
                          paragraphStyle, NSParagraphStyleAttributeName,
                          nil];
        }
        NSSize textSize = [text sizeWithAttributes:attributes];
        textBounds = NSMakeRect(0, 0, textSize.width, textSize.height);
        [as release];
    }
    return textBounds;
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

- (void)setDic:(NSMutableDictionary *)dic {
    if (_dic != nil) {
        [_dic release];
        _dic = nil;
    }
    _dic = [[NSMutableDictionary alloc] initWithDictionary:dic];
}
- (void)dealloc {
    if (_leftNormalBgColor != nil) {
        [_leftNormalBgColor release];
        _leftNormalBgColor = nil;
    }
    if (_rightNormalBgColor != nil) {
        [_rightNormalBgColor release];
        _rightNormalBgColor = nil;
    }
    if (_leftEnterBgColor != nil) {
        [_leftEnterBgColor release];
        _leftEnterBgColor = nil;
    }
    if (_rightEnterBgColor != nil) {
        [_rightEnterBgColor release];
        _rightEnterBgColor = nil;
    }
    if (_leftDownBgColor != nil) {
        [_leftDownBgColor release];
        _leftDownBgColor = nil;
    }
    if (_rightDownBgColor != nil) {
        [_rightDownBgColor release];
        _rightDownBgColor = nil;
    }
    if (_leftForbiddenBgColor != nil) {
        [_leftForbiddenBgColor release];
        _leftForbiddenBgColor = nil;
    }
    if (_rightForbiddenBgColor != nil) {
        [_rightForbiddenBgColor release];
        _rightForbiddenBgColor = nil;
    }
    if (_normalBorderColor != nil) {
        [_normalBorderColor release];
        _normalBorderColor = nil;
    }
    if (_enterBorderColor != nil) {
        [_enterBorderColor release];
        _enterBorderColor = nil;
    }
    if (_downBorderColor != nil) {
        [_downBorderColor release];
        _downBorderColor = nil;
    }
    if (_forbiddenBorderColor != nil) {
        [_forbiddenBorderColor release];
        _forbiddenBorderColor = nil;
    }
    if (_buttonTitle != nil) {
        [_buttonTitle release];
        _buttonTitle = nil;
    }
    if (_normalTitleColor != nil) {
        [_normalTitleColor release];
        _normalTitleColor = nil;
    }
    if (_enterTitleColor != nil) {
        [_enterTitleColor release];
        _enterTitleColor = nil;
    }
    if (_downTitleColor != nil) {
        [_downTitleColor release];
        _downTitleColor = nil;
    }
    if (_forbiddenTitleColor != nil) {
        [_forbiddenTitleColor release];
        _forbiddenTitleColor = nil;
    }
    if(_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    if(_lightImageView != nil) {
        [_lightImageView release];
        _lightImageView = nil;
    }
    if (_dic != nil) {
        [_dic release];
        _dic = nil;
    }
    if (_normalFillColor != nil) {
        [_normalFillColor release];
        _normalFillColor = nil;
    }
    if (_enterFillColor != nil) {
        [_enterFillColor release];
        _enterFillColor = nil;
    }
    if (_downFillColor != nil) {
        [_downFillColor release];
        _downFillColor = nil;
    }
    if (_bgNormalFillColor != nil) {
        [_bgNormalFillColor release];
        _bgNormalFillColor = nil;
    }
    if (_bgEnterFillColor != nil) {
        [_bgEnterFillColor release];
        _bgEnterFillColor = nil;
    }
    if (_bgDownFillColor != nil) {
        [_bgDownFillColor release];
        _bgDownFillColor = nil;
    }
    [super dealloc];
}

@end
