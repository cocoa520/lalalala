//
//  IMBMainFunctionButton.m
//  AnyTrans
//
//  Created by iMobie on 7/18/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBMainFunctionButton.h"
#import "CALayer+Animation.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"
@implementation IMBMainFunctionButton
@synthesize titleName = _titleName;
@synthesize interval = _interval;
@synthesize buttonType = _buttonType;
@synthesize backgroundColor = _backgroundColor;
@synthesize buttonImage = _buttonImage;
@synthesize oringalFrame = _oringalFrame;
@synthesize isDown = _isDown;
@synthesize isToiOSBtn = _isToiOSBtn;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(void)dealloc{
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    if (_font != nil) {
        [_font release];
        _font = nil;
    }
    if (_titleName != nil) {
        [_titleName release];
        _titleName = nil;
    }
    if (_buttonImage != nil) {
        [_buttonImage release];
        _buttonImage = nil;
    }
    if (_textColor != nil) {
        [_textColor release];
        _textColor = nil;
    }
    [_backgroundView release],_backgroundView = nil;
//    [_maskLayer release],_maskLayer = nil;
    [_imageTitleView release],_imageTitleView = nil;
    [super dealloc];
}

- (void)awakeFromNib
{
    [self setWantsLayer:YES];
    _isDown = YES;
    [self.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [self.layer setMasksToBounds:NO];
    _backgroundView = [[IMBMainFunctionBackgroundView alloc] initWithFrame:self.bounds];
    [_backgroundView setWantsLayer:YES];
    [_backgroundView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_backgroundView.layer setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [_backgroundView.layer setGeometryFlipped:YES];
    [self.layer addSublayer:_backgroundView.layer];
//    [self addSubview:_backgroundView];
    
    _imageTitleView = [[IMBMainFunctionBackgroundView alloc] initWithFrame:self.bounds];
    
    [_imageTitleView setWantsLayer:YES];
    [_imageTitleView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_imageTitleView.layer setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [_imageTitleView.layer setGeometryFlipped:YES];
    [self.layer addSublayer:_imageTitleView.layer];
    
//    [self addSubview:_imageTitleView];
}

- (void)viewWillDraw
{
    if (![_backgroundView.layer superlayer]) {
        [self.layer addSublayer:_backgroundView.layer];
        [self.layer addSublayer:_imageTitleView.layer];
    }
}


- (void)setTitleName:(NSString *)titleName
{
    if (![_titleName isEqualToString:titleName]) {
        [_titleName release];
        _titleName = [titleName retain];
    }
}

- (void)setButtonImage:(NSImage *)buttonImage
{
    if (_buttonImage != buttonImage) {
        [_buttonImage release];
        _buttonImage = [buttonImage retain];
    }
}

- (void)updateTrackingAreas{
	[super updateTrackingAreas];
    if (_trackingArea == nil) {
               NSTrackingAreaOptions options =   ( NSTrackingActiveAlways  | NSTrackingCursorUpdate|NSTrackingMouseEnteredAndExited);
        _trackingArea = [[NSTrackingArea alloc]initWithRect:self.bounds options:options owner:self userInfo:nil];
        [self addTrackingArea:_trackingArea];
    }
}

- (void)setTrackingAreaEnable:(BOOL)trackingAreaEnable
{
    if (trackingAreaEnable) {
        if (_trackingArea != nil) {
            [_trackingArea release];
            _trackingArea = nil;
        }
        [self updateTrackingAreas];
        
    }else{
        if (_buttonType == MouseUp) {
            [self mouseExited:nil];
        }
        [self removeTrackingArea:_trackingArea];
    }
}

-(void)setTitleName:(NSString *)titleName WithDarwInterval:(float)interval withFont:(NSFont *)textFont withButtonImage:(NSImage *)image withTextColor:(NSColor *)color {
    if (_font != nil) {
        [_font release];
        _font = nil;
    }
    _font = [textFont retain];
    [self setTitleName:titleName];
    [self setButtonImage:image];
    _interval = interval;
    _textColor = [color retain];
    
    [_imageTitleView setTitleName:titleName WithDarwInterval:interval withFont:textFont withButtonImage:image withTextColor:color withIsImage:YES withIsToiOSBtn:_isToiOSBtn];
    [_imageTitleView setNeedsDisplay:YES];
}

- (void)setComponentColor:(float)r1 withG1:(float)g1 withB1:(float)b1 withAlpha1:(float)a1 withR2:(float)r2 withG2:(float)g2 withB2:(float)b2 withAlpha2:(float)a2 {
    _r1 = r1;
    _g1 = g1;
    _b1 = b1;
    _a1 = a1;
    _r2 = r2;
    _g2 = g2;
    _b2 = b2;
    _a2 = a2;
    
    _backgroundView.r1 = r1;
    _backgroundView.g1 = g1;
    _backgroundView.b1 = b1;
    _backgroundView.a1 = a1;
    _backgroundView.r2 = r2;
    _backgroundView.g2 = g2;
    _backgroundView.b2 = b2;
    _backgroundView.a2 = a2;
    
    [_backgroundView setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
//    int c = NSWidth(dirtyRect) / 2;
//    int r = (NSWidth(dirtyRect) - 10) / 2;
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
//    CGFloat components[8] = {_r1,_g1,_b1,_a1,_r2,_g2,_b2,_a2};
//    CGFloat locations[2] = {0.2,1.0};
//    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
//    CGContextMoveToPoint(context, c, 5);
//    CGContextAddArc(context, c, c, r, 0, 2*M_PI, 0);
//    CGContextClip(context);//context裁剪路径,后续操作的路径
//    
//    //绘制渐变
//    CGContextDrawLinearGradient(context, gradient, CGPointMake(c, 5.0), CGPointMake(c, NSHeight(dirtyRect) - 5), kCGGradientDrawsAfterEndLocation);
//    
//    
//    //释放对象
//    CGColorSpaceRelease(colorSpace);
//    CGGradientRelease(gradient);
    

//    if (_titleName != nil) {
//        NSAttributedString *as = [[NSAttributedString alloc] initWithString:[_titleName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
//        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//        [paragraphStyle setAlignment:NSCenterTextAlignment];
//        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:_textColor,NSForegroundColorAttributeName ,paragraphStyle,NSParagraphStyleAttributeName,_font,NSFontAttributeName, nil];
//        NSSize textSize = [as.string sizeWithAttributes:attributes];
//        NSRect f = NSMakeRect(ceil((dirtyRect.size.width - textSize.width)/2),ceil((dirtyRect.size.height - textSize.height)/2)  +_interval, ceil(textSize.width) , ceil(textSize.height));
//        NSLog(@"titleRect:%@",NSStringFromRect(f));
//        [as.string drawInRect:f withAttributes:attributes];
//        [paragraphStyle release];
//        [as release];
//    }
//    
//    //    Group-80
//    NSImage *image = _buttonImage;
//    float w = image.size.width;
//    float h = image.size.height;
//    NSRect drawrect = NSMakeRect(ceil((NSWidth(dirtyRect) - w) / 2.0), ceil(NSHeight(dirtyRect)/2.0) - h + (_interval - 14), w, h);
//    NSRect imageRect;
//    imageRect.origin = NSZeroPoint;
//    imageRect.size = image.size;
//    [image drawInRect:drawrect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
}

-(void)mouseDown:(NSEvent *)theEvent{
    if (_isDown) {
        _buttonType = MouseDown;
        _backgroundView.buttonType = MouseDown;
        _evNum = theEvent.eventNumber;
        [self setNeedsDisplay:YES];
        [_backgroundView setNeedsDisplay:YES];
        [_imageTitleView setAlphaValue:0.6];
    }
}

-(void)mouseUp:(NSEvent *)theEvent{
    if (_isDown) {
        _buttonType = MouseUp;
        _backgroundView.buttonType = MouseUp;
        [self setNeedsDisplay:YES];
        [_backgroundView setNeedsDisplay:YES];
        [_imageTitleView setAlphaValue:1.0];
        if (self.isEnabled && _evNum == theEvent.eventNumber && [theEvent clickCount] == 1) {
            NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
            NSRect rect = NSMakeRect(5, 5, self.bounds.size.width - 10, self.bounds.size.height - 10);
            BOOL inner = NSMouseInRect(point, rect, [self isFlipped]);
            if (inner) {
                [NSApp sendAction:self.action to:self.target from:self];
            }
        }
    }
}

-(void)mouseExited:(NSEvent *)theEvent{
    if (_isDown) {
        _buttonType = MouseOut;
        _backgroundView.buttonType = MouseOut;
        [self setNeedsDisplay:YES];
        [_backgroundView setNeedsDisplay:YES];
        [_imageTitleView setAlphaValue:1.0];
        [_backgroundView.layer removeAllAnimations];
        [_backgroundView.layer animateKey:@"transform" fromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)] toValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)] customize:^(CABasicAnimation *animation) {
            animation.delegate = self;
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            animation.duration = 0.2;
            animation.autoreverses = NO;
            animation.repeatCount = 1;
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
        }];
    }

}

-(void)mouseEntered:(NSEvent *)theEvent{
    if (_isDown) {
        _buttonType = MouseEnter;
        _backgroundView.buttonType = MouseEnter;
        [_backgroundView setNeedsDisplay:YES];
        [self setNeedsDisplay:YES];
        [_backgroundView.layer removeAllAnimations];
        [_imageTitleView setAlphaValue:1.0];
        [_backgroundView.layer animateKey:@"transform" fromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1.0)] toValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)] customize:^(CABasicAnimation *animation) {
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            animation.duration = 0.2;
            animation.delegate = self;
            animation.autoreverses = NO;
            animation.repeatCount = 1;
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
        }];
    }
}


@end

@implementation IMBMainFunctionBackgroundView
@synthesize r1= _r1;
@synthesize g1 = _g1;
@synthesize b1 = _b1;
@synthesize a1 = _a1;
@synthesize r2 = _r2;
@synthesize g2 = _g2;
@synthesize b2 = _b2;
@synthesize a2 = _a2;
@synthesize titleName = _titleName;
@synthesize buttonImage = _buttonImage;
@synthesize buttonType = _buttonType;
@synthesize isToiOSBtn = _isToiOSBtn;

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    if (_isImage) {
        if (_titleName != nil) {
            NSAttributedString *as = [[NSAttributedString alloc] initWithString:[_titleName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [paragraphStyle setAlignment:NSCenterTextAlignment];
            [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
            [paragraphStyle setLineSpacing:0];
            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:_textColor,NSForegroundColorAttributeName ,paragraphStyle,NSParagraphStyleAttributeName,_font,NSFontAttributeName, nil];
//            NSSize textSize = [as.string sizeWithAttributes:attributes];
            
            NSSize size = NSMakeSize(NSWidth(dirtyRect) - 18, 38);
            //文本样式
//           [StringHelper measureForStringDrawing:_titleName withFont:_font withLineSpacing:0 withMaxWidth:NSWidth(dirtyRect) - 4 withSize:&size withColor:_textColor withAlignment:NSCenterTextAlignment];
            if ([_titleName isEqualToString:@"Gerät zusammenführen"]) {
                    NSRect f = NSMakeRect(ceil((dirtyRect.size.width - NSWidth(dirtyRect) + 18)/2),ceil((dirtyRect.size.height - size.height-10)/2)  -_interval, ceil(NSWidth(dirtyRect) - 18) , size.height);
                    [as.string drawInRect:f withAttributes:attributes];
                    [paragraphStyle release];
                    [as release];
            }else{
                NSRect f = NSMakeRect(ceil((dirtyRect.size.width - NSWidth(dirtyRect) + 18)/2),ceil((dirtyRect.size.height - size.height-28)/2)  -_interval, ceil(NSWidth(dirtyRect) - 18) , size.height);
                [as.string drawInRect:f withAttributes:attributes];
                [paragraphStyle release];
                [as release];
            }
        }
        NSImage *image = _buttonImage;
        float w = image.size.width;
        float h = image.size.height;
        NSRect drawrect = NSMakeRect(0, 0, 0, 0);;
        if (_isToiOSBtn) {
            drawrect = NSMakeRect(ceil((NSWidth(dirtyRect) - w) / 2.0) - 6, ceil((NSHeight(dirtyRect) - h)/2.0) + (_interval - 10), w, h);
        }else{
            drawrect = NSMakeRect(ceil((NSWidth(dirtyRect) - w) / 2.0), ceil((NSHeight(dirtyRect) - h)/2.0) + (_interval - 10), w, h);
        }
        NSRect imageRect;
        imageRect.origin = NSZeroPoint;
        imageRect.size = image.size;
        [image drawInRect:drawrect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        
        if (_buttonType == MouseDown) {
            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height) xRadius:self.frame.size.width/2 yRadius:self.frame.size.height];
            [[StringHelper getColorFromString:CustomColor(@"DeviceMain_sixBtnDown_BgColor", nil)] setFill];
            [path fill];
            [path closePath];
        }
    }else {
        int c = NSWidth(dirtyRect) / 2;
    //    int r = ceil((NSWidth(dirtyRect) - 10) / 2);
        int r = (NSWidth(dirtyRect) - 4) / 2;
        
        CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
        //在计算机设置中，直接选择rgb即可，其他颜色空间暂时不用考虑。
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        //1.创建渐变
        /*
         1.<#CGColorSpaceRef space#> : 颜色空间 rgb
         2.<#const CGFloat *components#> ： 数组 每四个一组 表示一个颜色 ｛r,g,b,a ,r,g,b,a｝
         3.<#const CGFloat *locations#>:表示渐变的开始位置
         
         */
        CGFloat components[8] = {_r1,_g1,_b1,_a1,_r2,_g2,_b2,_a2};
        CGFloat locations[2] = {0.2,1.0};
        CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
        //渐变区域裁剪
        //    CGContextClipToRect(context, CGRectMake(0, 360, 200, 100));
        //    CGRect rect[1] = {CGRectMake(0, 0, 100, 100)};
        //    CGContextClipToRects(context, rect, 1);
        
        //    CGContextSaveGState(context);
        CGContextMoveToPoint(context, c, 2);
        CGContextAddArc(context, c, c, r, 0, 2*M_PI, 0);
        CGContextClip(context);//context裁剪路径,后续操作的路径
        
        //绘制渐变
        CGContextDrawLinearGradient(context, gradient, CGPointMake(c, 2), CGPointMake(c, NSHeight(dirtyRect) - 2), kCGGradientDrawsAfterEndLocation);
        //释放对象
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
        
//        if (_titleName != nil) {
//            NSAttributedString *as = [[NSAttributedString alloc] initWithString:[_titleName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
//            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//            [paragraphStyle setAlignment:NSCenterTextAlignment];
//            NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:_textColor,NSForegroundColorAttributeName ,paragraphStyle,NSParagraphStyleAttributeName,_font,NSFontAttributeName, nil];
//            NSSize textSize = [as.string sizeWithAttributes:attributes];
//            NSRect f = NSMakeRect(ceil((dirtyRect.size.width - textSize.width)/2),ceil((dirtyRect.size.height - textSize.height)/2)  -_interval, ceil(textSize.width) , ceil(textSize.height));
//            [as.string drawInRect:f withAttributes:attributes];
//            [paragraphStyle release];
//            [as release];
//        }
//        
//        NSImage *image = _buttonImage;
//        float w = image.size.width;
//        float h = image.size.height;
//        NSRect drawrect = NSMakeRect(ceil((NSWidth(dirtyRect) - w) / 2.0), ceil((NSHeight(dirtyRect) - h)/2.0) + (_interval - 10), w, h);
//        NSRect imageRect;
//        imageRect.origin = NSZeroPoint;
//        imageRect.size = image.size;
//        [image drawInRect:drawrect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        
        if (_buttonType == MouseDown) {
            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height) xRadius:self.frame.size.width/2 yRadius:self.frame.size.height];
            [[StringHelper getColorFromString:CustomColor(@"DeviceMain_sixBtnDown_BgColor", nil)] setFill];
            [path fill];
            [path closePath];
        }
    }
}

-(void)setTitleName:(NSString *)titleName WithDarwInterval:(float)interval withFont:(NSFont *)textFont withButtonImage:(NSImage *)image withTextColor:(NSColor *)color withIsImage:(BOOL)isImage withIsToiOSBtn:(BOOL) isToiOSBtn{
    if (_font != nil) {
        [_font release];
        _font = nil;
    }
    _font = [textFont retain];
    [self setTitleName:titleName];
    [self setButtonImage:image];
    _interval = interval;
    _textColor = [color retain];
    _isImage = isImage;
    _isToiOSBtn = isToiOSBtn;
    [self setNeedsDisplay:YES];
}

- (void)setTitleName:(NSString *)titleName
{
    if (![_titleName isEqualToString:titleName]) {
        [_titleName release];
        _titleName = [titleName retain];
    }
    [self setNeedsDisplay:YES];
}

- (void)setButtonImage:(NSImage *)buttonImage
{
    if (_buttonImage != buttonImage) {
        [_buttonImage release];
        _buttonImage = [buttonImage retain];
    }
    [self setNeedsDisplay:YES];
}

- (void)dealloc
{
    [_titleName release];_titleName = nil;
    [_buttonImage release];_buttonImage = nil;
    [_font release];_font = nil;

    [super dealloc];
}

@end

