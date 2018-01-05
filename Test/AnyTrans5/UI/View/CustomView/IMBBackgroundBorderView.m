//
//  IMBBackgroundBorderView.m
//  MacClean
//
//  Created by Gehry on 12/29/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import "IMBBackgroundBorderView.h"
#import "ColorHelper.h"
@implementation IMBBackgroundBorderView
@synthesize controller = _controller;
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
@synthesize hasStrokeRadius = _hasStrokeRadius;
@synthesize isGradientWithCornerPart1 = _isGradientWithCornerPart1;
@synthesize isGradientNoCornerPart1 = _isGradientNoCornerPart1;
@synthesize isGradientWithCornerPart2 = _isGradientWithCornerPart2;
@synthesize isGradientNoCornerPart2 = _isGradientNoCornerPart2;
@synthesize isGradientWithCornerPart3 = _isGradientWithCornerPart3;
@synthesize isGradientNoCornerPart3 = _isGradientNoCornerPart3;
@synthesize isGradientWithCornerPart4 = _isGradientWithCornerPart4;
@synthesize isGradientNoCornerPart4 = _isGradientNoCornerPart4;
@synthesize hasStrokeRadiusAndBgColor = _hasStrokeRadiusAndBgColor;
-(void)dealloc
{
    [_backgroundColor release],_backgroundColor = nil;
    [_topBorderColor release],_topBorderColor = nil;
    [_leftBorderColor release],_topBorderColor = nil;
    [_bottomBorderColor release],_topBorderColor = nil;
    [_rightBorderColor release],_topBorderColor = nil;
    [trackingArea release],trackingArea = nil;
    [super dealloc];
    
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    return NSDragOperationNone;
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
    return NSDragOperationNone;
}

- (void)awakeFromNib
{
    _canScroll = YES;
    _canClick = YES;
    [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilesPromisePboardType,NSFilenamesPboardType,nil]];
}

- (void)setCanScroll:(BOOL)canScroll
{
    if (_canScroll != canScroll) {
        _canScroll = canScroll;
    }
}

- (void)setCanClick:(BOOL)canClick
{
    if (_canClick != canClick) {
        _canClick = canClick;
    }
}

- (void)setBorderColor:(NSColor *)borderColor{
    if (_borderColor != borderColor) {
        if (_borderColor) {
             [_borderColor release];
        }
        _borderColor = [borderColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)setBackgroundColor:(NSColor *)backgroundColor{
    if (_backgroundColor != backgroundColor) {
        if (_backgroundColor) {
            [_backgroundColor release];
        }
        _backgroundColor = [backgroundColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)setBottomBorderColor:(NSColor *)bottomBorderColor{
    if (_bottomBorderColor != bottomBorderColor) {
        if (_bottomBorderColor) {
            [_bottomBorderColor release];
        }
        _bottomBorderColor = [bottomBorderColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)setLeftBorderColor:(NSColor *)leftBorderColor{
    if (_leftBorderColor != leftBorderColor) {
        if (_leftBorderColor) {
            [_leftBorderColor release];
        }
        _leftBorderColor = [leftBorderColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)setTopBorderColor:(NSColor *)topBorderColor{
    if (_topBorderColor != topBorderColor) {
        if (_topBorderColor) {
            [_topBorderColor release];
        }
        _topBorderColor = [topBorderColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)setRightBorderColor:(NSColor *)rightBorderColor{
    if (_rightBorderColor != rightBorderColor) {
        if (_rightBorderColor) {
            [_rightBorderColor release];
        }
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

- (void)setHasStrokeRadiusAndBgColor:(BOOL)hasStrokeRadiusAndBgColor
{
    if (_hasStrokeRadiusAndBgColor != hasStrokeRadiusAndBgColor) {
        _hasStrokeRadiusAndBgColor = hasStrokeRadiusAndBgColor;
        [self setNeedsDisplay:YES];
    }
}

- (void)setBackgroundImage:(NSImage *)backgroundImage{
    if (_backgroundImage != backgroundImage) {
        if (_backgroundImage) {
            [_backgroundImage release];
        }
        _backgroundImage = [backgroundImage retain];
        [self setNeedsDisplay:YES];
    }
}

+ (NSImage*) imageFromCGImageRef:(CGImageRef)image

{
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
    
    imageContext = (CGContextRef)[[NSGraphicsContext currentContext]
                                  
                                  graphicsPort];
    
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


- (void)drawRect:(NSRect)dirtyRect{
    @autoreleasepool {
       
        //画圆角
        if (_hasRadius) {
             NSBezierPath *roundRect = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:_xRadius yRadius:_yRadius];
            [[NSColor clearColor] setFill];
            [roundRect addClip];
            [roundRect fill];
            [_backgroundColor setFill];
            [roundRect addClip];
            [roundRect fill];
            return;
        }
        
        if (_hasStrokeRadius) {
            NSBezierPath *roundRect = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:_xRadius yRadius:_yRadius];
            [_borderColor setStroke];
            [roundRect addClip];
            [roundRect stroke];
            return;
        }
        
        if (_hasStrokeRadiusAndBgColor) {
            NSBezierPath *roundRect1 = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:_xRadius yRadius:_yRadius];
            [[NSColor clearColor] setFill];
            [roundRect1 addClip];
            [roundRect1 fill];
            [_backgroundColor setFill];
            [roundRect1 addClip];
            [roundRect1 fill];
            
            NSBezierPath *roundRect = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:_xRadius yRadius:_yRadius];
            [_borderColor setStroke];
            [roundRect addClip];
            [roundRect stroke];
            return;
        }
        
        //画背景
        NSBezierPath *backgroundPath = [NSBezierPath bezierPathWithRect:dirtyRect];
        if (_backgroundColor) {
            [[NSColor clearColor] setFill];
            NSRectFill(dirtyRect);
            [_backgroundColor setFill];
        }else
        {
            [[NSColor clearColor] setFill];
        }
        if (_isGradientWithCornerPart1) {
            [ColorHelper setGrientColorWithRect:dirtyRect withCorner:YES withPart:1];
        }else if (_isGradientNoCornerPart1) {
            [ColorHelper setGrientColorWithRect:dirtyRect withCorner:NO withPart:1];
        }else if (_isGradientWithCornerPart2) {
            [ColorHelper setGrientColorWithRect:dirtyRect withCorner:YES withPart:2];
        }else if (_isGradientNoCornerPart2) {
            [ColorHelper setGrientColorWithRect:dirtyRect withCorner:NO withPart:2];
        }else if (_isGradientWithCornerPart3) {
            [ColorHelper setGrientColorWithRect:dirtyRect withCorner:YES withPart:3];
        }else if (_isGradientNoCornerPart3) {
            [ColorHelper setGrientColorWithRect:dirtyRect withCorner:NO withPart:3];
        }else if (_isGradientWithCornerPart4) {
            [ColorHelper setGrientColorWithRect:dirtyRect withCorner:YES withPart:4];
        }else if (_isGradientNoCornerPart4) {
            [ColorHelper setGrientColorWithRect:dirtyRect withCorner:NO withPart:4];
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
            [rightBorderPath setLineWidth:2.0];
            [rightBorderPath moveToPoint:NSMakePoint(dirtyRect.size.width, 0)];
            [rightBorderPath lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height)];
            [[NSColor clearColor] setStroke];
            [rightBorderPath stroke];
            [_rightBorderColor setStroke];
            [rightBorderPath stroke];
            
        }
    }
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
	if (trackingArea == nil) {
        NSTrackingAreaOptions options =   ( NSTrackingActiveAlways  | NSTrackingCursorUpdate|NSTrackingMouseEnteredAndExited);
        trackingArea = [[NSTrackingArea alloc]initWithRect:self.bounds options:options owner:self userInfo:nil];
        [self addTrackingArea:trackingArea];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent
{

}

- (void)mouseExited:(NSEvent *)theEvent
{

}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (_canClick) {
        [super mouseDown:theEvent];
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (_canClick) {
        [super mouseUp:theEvent];
    }
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    if (_canScroll) {
        [super scrollWheel:theEvent];
    }
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    [super mouseDragged:theEvent];
    [self setNeedsDisplay:YES];
}

//- (void)setGrientColorWithRect:(NSRect) dirtyRect withCorner:(BOOL)hasCorner {
//    int c = NSWidth(dirtyRect) / 2;
//    
//    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
//    //在计算机设置中，直接选择rgb即可，其他颜色空间暂时不用考虑。
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    //1.创建渐变
//    /*
//     1.<#CGColorSpaceRef space#> : 颜色空间 rgb
//     2.<#const CGFloat *components#> ： 数组 每四个一组 表示一个颜色 ｛r,g,b,a ,r,g,b,a｝
//     3.<#const CGFloat *locations#>:表示渐变的开始位置
//     
//     */
//    float r1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:0];
//    float g1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:1];
//    float b1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:2];
//    float a1 = [self getColorFromColorString:@"mainView_bgColor_down" WithIndex:3];
//    float r2 = [self getColorFromColorString:@"mainView_bgColor" WithIndex:0];
//    float g2 = [self getColorFromColorString:@"mainView_bgColor" WithIndex:1];
//    float b2 = [self getColorFromColorString:@"mainView_bgColor" WithIndex:2];
//    float a2 = [self getColorFromColorString:@"mainView_bgColor" WithIndex:3];
//    
//    
//    CGFloat components[8] = {r1,g1,b1,a1,r2,g2,b2,a2};
//    CGFloat locations[2] = {0.0,1.0};
//    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
//    //渐变区域裁剪
//    if (hasCorner) {
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
//    }else {
//        CGContextAddRect(context, CGRectMake(dirtyRect.origin.x, dirtyRect.origin.y, dirtyRect.size.width, dirtyRect.size.height));
//    }
//    
//
//    
//    //绘制渐变
//    CGContextDrawLinearGradient(context, gradient, CGPointMake(c, 0), CGPointMake(c, NSHeight(dirtyRect) - 46), kCGGradientDrawsAfterEndLocation);
//    //释放对象
//    CGColorSpaceRelease(colorSpace);
//    CGGradientRelease(gradient);
//}
//
//- (float)getColorFromColorString:(NSString *)str WithIndex:(int)index {
//    NSString *string = CustomColor(str, nil);
//    NSArray *array = [string componentsSeparatedByString:@","];
//    if (index <= 2) {
//        return [[array objectAtIndex:index] floatValue]/255.0;
//    }else {
//        return [[array objectAtIndex:index] floatValue];
//    }
//}


@end