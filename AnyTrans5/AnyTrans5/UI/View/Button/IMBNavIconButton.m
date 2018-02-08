//
//  IMBNavIconButton.m
//  AnyTrans
//
//  Created by m on 17/8/15.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBNavIconButton.h"
#import "IMBAnimation.h"
#import "StringHelper.h"
#import "IMBMainFrameButtonBarView.h"
@implementation IMBNavIconButton
@synthesize MouseDownImage=_mouseDownImage;
@synthesize MouseEnteredImage=_mouseEnteredImage;
@synthesize MouseExitImage=_mouseExitImage;
@synthesize forBidImage = _forBidImage;
@synthesize isSelected = _isSelected;
@synthesize status = _status;
@synthesize hasPopover = _hasPopover;
@synthesize delegate = _delegate;
@synthesize isShowTips = _isShowTips;
@synthesize hasSpot = _hasSpot;
@synthesize isDrawRectLine = _isDrawRectLine;
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTitle:@""];
        [self setButtonType:NSMomentaryPushInButton];
        [self setAlignment:NSCenterTextAlignment];
        [self setImagePosition:NSImageOnly];
        [self setBordered:NO];
        [self.cell setHighlightsBy:NSNoCellMask];
        [self setNeedsDisplay:YES];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setTitle:@""];
        [self setButtonType:NSMomentaryPushInButton];
        [self setAlignment:NSCenterTextAlignment];
        [self setImagePosition:NSImageOnly];
        [self setBordered:NO];
        [self.cell setHighlightsBy:NSNoCellMask];
        [self setNeedsDisplay:YES];
    }
    return self;
}

- (void)setForBidImage:(NSImage *)forBidImage {
    if (_forBidImage != forBidImage) {
        [_forBidImage release];
        _forBidImage = [forBidImage retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)setEnabled:(BOOL)flag {
    [super setEnabled:flag];
    if (flag) {
        _status = 1;
        [self setAlphaValue:1.0];
    }else
    {
        _status = 4;
        [self setAlphaValue:0.3];
    }
    [self setNeedsDisplay:YES];
}

- (void)setIsDrawBorder:(BOOL)isDraw {
    if (_isDrawBorder != isDraw) {
        _isDrawBorder = isDraw;
        [self setNeedsDisplay:YES];
    }
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (trackingArea)
    {
        [self removeTrackingArea:trackingArea];
        [trackingArea release];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited |NSTrackingMouseMoved| NSTrackingActiveInKeyWindow;
    trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

-(void)setMouseEnteredImage:(NSImage *)image1 mouseExitImage:(NSImage *)image2 mouseDownImage:(NSImage *)image3 forBidImage:(NSImage *)forBidImage{
    
    if (_status != 1 && _status != 2 && _status != 3 && _status != 4) {
        _status = 1;
    }
    [self setTitle:@""];
    [self setButtonType:NSMomentaryPushInButton];
    [self setAlignment:NSCenterTextAlignment];
    [self setImagePosition:NSImageOnly];
    [self setBordered:NO];
    [self.cell setHighlightsBy:NSNoCellMask];
    _mouseEnteredImage=[image1 retain];
    _mouseExitImage=[image2 retain];
    _mouseDownImage=[image3 retain];
    _forBidImage = [forBidImage retain];
    [self setNeedsDisplay:YES];
}

-(void)setMouseEnteredImage:(NSImage *)image1 mouseExitImage:(NSImage *)image2 mouseDownImage:(NSImage *)image3 {
    if (_status != 1 && _status != 2 && _status != 3 && _status != 4) {
        _status = 1;
    }
    [self setTitle:@""];
    [self setButtonType:NSMomentaryPushInButton];
    [self setAlignment:NSCenterTextAlignment];
    [self setImagePosition:NSImageOnly];
    [self setBordered:NO];
    [self.cell setHighlightsBy:NSNoCellMask];
    self.MouseEnteredImage=[image1 retain];
    self.MouseExitImage=[image2 retain];
    self.MouseDownImage=[image3 retain];
    [self setNeedsDisplay:YES];
}

- (void)setIsSelected:(BOOL)isSelected {
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        if (_isSelected) {
            _status = 2;
            if (_isSelected) {
                [_subLayer removeFromSuperlayer];
            }
        }else
        {
            _status = 1;
            [self.layer addSublayer:_subLayer];
        }
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseEntered:(NSEvent *)event {
    _hasExite = YES;
    if (self.isSelected) {
        return;
    }
    if (self.isEnabled) {
        _status = 2;
        [self addAnimationLayer];
    }else
    {
        _status = 4;
    }
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)event {
     _hasExite = YES;
    [self removeAnimationLayer];
    if (self.isSelected) {
        return;
    }
    if (self.isEnabled) {
        _status = 1;
    }else
    {
        _status = 4;
    }
    
    [self setNeedsDisplay:YES];
}

-(void)mouseDown:(NSEvent *)theEvent{
    [self removeAnimationLayer];
    if (_navPopWindow) {
        [_navPopWindow.window setAlphaValue:0.0];
        [_navPopWindow close];
    }
    if (_isShowTips) {
        _isShowTips = NO;
        if (_hasPopover) {
            if ([_delegate respondsToSelector:@selector(closeNavPopover:)]) {
                [_delegate closeNavPopover:self];
            }
        }
    }
    _hasExite = NO;

    if (self.isSelected) {
        return;
    }
    if (self.isEnabled) {
        [self setStatus:3];
    }else
    {
        _status = 4;
    }

    [self setNeedsDisplay:YES];
}

-(void)mouseUp:(NSEvent *)theEvent{
    [self removeAnimationLayer];
    if (_navPopWindow) {
        [_navPopWindow.window setAlphaValue:0.0];
        [_navPopWindow close];
    }
    if (self.isSelected) {
        return;
    }
    if (self.isEnabled) {
        [self setStatus:1];
    }else
    {
        _status = 4;
    }
    [self setNeedsDisplay:YES];
    
    if (self.isEnabled &&theEvent.clickCount == 1) {
        NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
        BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
        if (inner) {
            [NSApp sendAction:self.action to:self.target from:self];
        }
    }
}

- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
    NSBezierPath *clipPath = nil;
    if (_isDrawBorder) {
        if (!_isDrawRectLine) {
            clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
            [clipPath setWindingRule:NSEvenOddWindingRule];
            [clipPath addClip];
            
            [clipPath setLineWidth:2];
        }else{
            clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:15 yRadius:15];
            [clipPath setWindingRule:NSEvenOddWindingRule];
            [clipPath addClip];
            [clipPath setLineWidth:0];
        }
        [clipPath closePath];
        
        if (_status == 1) {
            [[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] setFill];
            [clipPath fill];
            [[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] setStroke];
            [clipPath stroke];
        }else if (_status == 2) {
            [[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)] setFill];
            [clipPath fill];
            [[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] setStroke];
            [clipPath stroke];
        }else if (_status == 3) {
            [[StringHelper getColorFromString:CustomColor(@"hoverBtn_down_bgColor", nil)] setFill];
            [clipPath fill];
            [[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] setStroke];
            [clipPath stroke];
        }else if (_status == 4) {
            [[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_bgColor", nil)] setFill];
            [clipPath fill];
            [[StringHelper getColorFromString:CustomColor(@"hoverBtn_normal_borderColor", nil)] setStroke];
            [clipPath stroke];
        }
    }

    NSImage *image = nil;
    if (_isSelected) {
        image = _mouseDownImage;
    }
    if (image) {
        NSRect souRect;
        souRect.origin = NSZeroPoint;
        souRect.size = image.size;
        NSRect tarRect;
        tarRect.origin = NSMakePoint((dirtyRect.size.width - image.size.width) / 2, (dirtyRect.size.height - image.size.height) / 2);
        tarRect.size = image.size;
        [image drawInRect:tarRect fromRect:souRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    }
    //判断是否显示Skin的小圆点
//    if ((![[[NSUserDefaults standardUserDefaults] objectForKey:@"SkinSpot"] boolValue] && _hasSpot) ||(![[[NSUserDefaults standardUserDefaults] objectForKey:@"VideoSpot"] boolValue] && _hasSpot) ) {
//        NSBezierPath *spotPath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(dirtyRect.origin.x+dirtyRect.size.width-11, dirtyRect.origin.y+dirtyRect.size.height - 23, 6, 6) xRadius:3 yRadius:3];
//        [[StringHelper getColorFromString:CustomColor(@"skin_newSpot", nil)] setFill];
//        [spotPath fill];
//    }
}

- (void)scrollWheel:(NSEvent *)theEvent {
    [self mouseExited:theEvent];
    [super scrollWheel:theEvent];
}

- (void)setSvgFileName:(NSString *)svgName {
    _svgAnimationName = [svgName retain];
    _myVectorDrawing = [[PocketSVG alloc] initFromSVGFileNamed:svgName];
    _subLayer = [[CALayer alloc] init];
    [self setWantsLayer:YES];
    [self.layer addSublayer:_subLayer];
    if ([svgName isEqualToString:@"btn_buy"]) {
        [_subLayer setFrame:NSMakeRect(3, 3, 36, 36)];
    }else if ([svgName isEqualToString:@"nav_backup"]) {
        [_subLayer setFrame:NSMakeRect(6, 8, 36, 36)];
    }else if ([svgName isEqualToString:@"nav_airbackup"]) {
        [_subLayer setFrame:NSMakeRect(7, 8, 36, 36)];
    }else if ([svgName isEqualToString:@"nav_device"]) {
        [_subLayer setFrame:NSMakeRect(12.5, 8.5, 36, 36)];
    }else if ([svgName isEqualToString:@"nav_download"]) {
        [_subLayer setFrame:NSMakeRect(8, 8, 36, 36)];
    }else if ([svgName isEqualToString:@"nav_icloud"]) {
        [_subLayer setFrame:NSMakeRect(6, 10, 36, 36)];
    }else if ([svgName isEqualToString:@"nav_itunes"]) {
        [_subLayer setFrame:NSMakeRect(8, 8.5, 36, 36)];
    }else if ([svgName isEqualToString:@"nav_skin"]) {
        [_subLayer setFrame:NSMakeRect(11, 10, 36, 36)];
    }else if ([svgName isEqualToString:@"nav_toios"]) {
        [_subLayer setFrame:NSMakeRect(5, 8.5, 36, 36)];
    }
    
    for (NSBezierPath *bezier in _myVectorDrawing.bezierAry) {
        //2: Its bezier property is the corresponding NSBezierPath:
        NSBezierPath *myBezierPath2 = bezier;
        
        //3: To display it on screen, create a CAShapeLayer:
        //   and call getCGPathFromNSBezierPath to get the
        //   SVG's CGPath
        CAShapeLayer *myShapeLayer2 = [CAShapeLayer layer];
        myShapeLayer2.frame = NSMakeRect(0, 0, 34.6, 34.6);
        CGPathRef path2 = [_myVectorDrawing getCGPathFromNSBezierPath:myBezierPath2];
        myShapeLayer2.path = path2;
        
//        [myShapeLayer2 setValue:@1.f forKey:@"strokeEnd"];
//        CABasicAnimation *pathAnimation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        pathAnimation2.duration = 1;
//        pathAnimation2.repeatCount = 1;
//        pathAnimation2.removedOnCompletion = NO;
//        pathAnimation2.fromValue = [NSNumber numberWithFloat:0.0f];
//        pathAnimation2.toValue = [NSNumber numberWithFloat:1.f];
//        pathAnimation2.fillMode = kCAFillModeForwards;
//        [myShapeLayer2 addAnimation:pathAnimation2 forKey:@"strokeEnd"];
        
        //4: Fiddle with it using CAShapeLayer's properties:
        NSArray *array = [CustomColor(@"svg_button_normal_color", nil) componentsSeparatedByString:@","];
        float r = [[array objectAtIndex:0] floatValue];
        float g = [[array objectAtIndex:1] floatValue];
        float b = [[array objectAtIndex:2] floatValue];
        float a = [[array objectAtIndex:3] floatValue];
        myShapeLayer2.strokeColor = CGColorCreateGenericRGB(r/255.0, g/255.0, b/255.0, a);
        myShapeLayer2.lineWidth = 1.4;
        myShapeLayer2.fillColor = [NSColor clearColor].CGColor;//CGColorCreateGenericRGB(0.0, 0.0, 0.0, 0);
        [_subLayer addSublayer:myShapeLayer2];
    }
}

- (void)addAnimationLayer {
    if (!_isAnimation) {
        _isAnimation = YES;
        [self setWantsLayer:YES];
        if (_animationLayer == nil) {
            _animationLayer = [[CALayer alloc] init];
            if ([_svgAnimationName isEqualToString:@"btn_buy"]) {
                [_animationLayer setFrame:NSMakeRect(3, 3, 36, 36)];
            }else if ([_svgAnimationName isEqualToString:@"nav_backup"]) {
                [_animationLayer setFrame:NSMakeRect(6, 8, 36, 36)];
            }else if ([_svgAnimationName isEqualToString:@"nav_airbackup"]) {
                [_animationLayer setFrame:NSMakeRect(7, 8, 36, 36)];
            }else if ([_svgAnimationName isEqualToString:@"nav_device"]) {
                [_animationLayer setFrame:NSMakeRect(12.5, 8.5, 36, 36)];
            }else if ([_svgAnimationName isEqualToString:@"nav_download"]) {
                [_animationLayer setFrame:NSMakeRect(8, 8, 36, 36)];
            }else if ([_svgAnimationName isEqualToString:@"nav_icloud"]) {
                [_animationLayer setFrame:NSMakeRect(6, 10, 36, 36)];
            }else if ([_svgAnimationName isEqualToString:@"nav_itunes"]) {
                [_animationLayer setFrame:NSMakeRect(8, 8.5, 36, 36)];
            }else if ([_svgAnimationName isEqualToString:@"nav_skin"]) {
                [_animationLayer setFrame:NSMakeRect(11, 10, 36, 36)];
            }else if ([_svgAnimationName isEqualToString:@"nav_toios"]) {
                [_animationLayer setFrame:NSMakeRect(5, 8.5, 36, 36)];
            }
        }else {
            [_animationLayer removeAllAnimations];
            [_animationLayer removeFromSuperlayer];
            NSArray *array = [NSArray arrayWithArray:[_animationLayer sublayers]];
            for (CALayer *layer in array) {
                [layer removeAllAnimations];
                [layer removeFromSuperlayer];
            }
        }
//        [self.layer addSublayer:_animationLayer];
        
        if (_gradientLayer) {
            [_gradientLayer removeAllAnimations];
            [_gradientLayer removeFromSuperlayer];
            [_gradientLayer release];
            _gradientLayer = nil;
        }
        _gradientLayer = [[CAGradientLayer layer] retain];
        NSColor *fromColor = nil;
        NSColor *toColor = nil;
        if ([_svgAnimationName isEqualToString:@"btn_buy"]) {
            fromColor = [StringHelper getColorFromString:CustomColor(@"iTunes_gradient_leftColor", nil)];
            toColor = [StringHelper getColorFromString:CustomColor(@"iTunes_gradient_rightColor", nil)];
        }else if ([_svgAnimationName isEqualToString:@"nav_backup"]) {
            fromColor = [StringHelper getColorFromString:CustomColor(@"backup_gradient_leftColor", nil)];
            toColor = [StringHelper getColorFromString:CustomColor(@"backup_gradient_rightColor", nil)];
        }else if ([_svgAnimationName isEqualToString:@"nav_device"]) {
            fromColor = [StringHelper getColorFromString:CustomColor(@"device_gradient_leftColor", nil)];
            toColor = [StringHelper getColorFromString:CustomColor(@"device_gradient_rightColor", nil)];
        }else if ([_svgAnimationName isEqualToString:@"nav_download"]) {
            fromColor = [StringHelper getColorFromString:CustomColor(@"download_gradient_leftColor", nil)];
            toColor = [StringHelper getColorFromString:CustomColor(@"download_gradient_rightColor", nil)];
        }else if ([_svgAnimationName isEqualToString:@"nav_icloud"]) {
            fromColor = [StringHelper getColorFromString:CustomColor(@"iCloud_gradient_leftColor", nil)];
            toColor = [StringHelper getColorFromString:CustomColor(@"iCloud_gradient_rightColor", nil)];
        }else if ([_svgAnimationName isEqualToString:@"nav_itunes"]) {
            fromColor = [StringHelper getColorFromString:CustomColor(@"iTunes_gradient_leftColor", nil)];
            toColor = [StringHelper getColorFromString:CustomColor(@"iTunes_gradient_rightColor", nil)];
        }else if ([_svgAnimationName isEqualToString:@"nav_skin"]) {
            fromColor = [StringHelper getColorFromString:CustomColor(@"skin_gradient_leftColor", nil)];
            toColor = [StringHelper getColorFromString:CustomColor(@"skin_gradient_rightColor", nil)];
        }else if ([_svgAnimationName isEqualToString:@"nav_toios"]) {
            fromColor = [StringHelper getColorFromString:CustomColor(@"android_gradient_leftColor", nil)];
            toColor = [StringHelper getColorFromString:CustomColor(@"android_gradient_rightColor", nil)];
        }else if([_svgAnimationName isEqualToString:@"nav_airbackup"]) {
            fromColor = [StringHelper getColorFromString:CustomColor(@"airBackup_gradient_leftColor", nil)];
            toColor = [StringHelper getColorFromString:CustomColor(@"airBackup_gradient_rightColor", nil)];
        }
        _gradientLayer.colors = @[(__bridge id)fromColor.CGColor,  (__bridge id)toColor.CGColor];
        _gradientLayer.locations = @[@0, @1.0];
        _gradientLayer.startPoint = CGPointMake(0.5, 1);
        _gradientLayer.endPoint = CGPointMake(0.5, 0);
        _gradientLayer.frame = CGRectMake(0, 0, self.layer.frame.size.width, self.layer.frame.size.height);
        [self.layer addSublayer:_gradientLayer];
        
        for (NSBezierPath *bezier in _myVectorDrawing.bezierAry) {
            //2: Its bezier property is the corresponding NSBezierPath:
            NSBezierPath *myBezierPath = bezier;
            
            //3: To display it on screen, create a CAShapeLayer:
            //   and call getCGPathFromNSBezierPath to get the
            //   SVG's CGPath
            CAShapeLayer *myShapeLayer = [CAShapeLayer layer];
            myShapeLayer.frame = NSMakeRect(0, 0, 34.6, 34.6);
            CGPathRef path = [_myVectorDrawing getCGPathFromNSBezierPath:myBezierPath];
            myShapeLayer.path = path;
            
            [myShapeLayer setValue:@1.f forKey:@"strokeEnd"];
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = 0.5;
            pathAnimation.repeatCount = 1;
            pathAnimation.removedOnCompletion = NO;
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:1.f];
            pathAnimation.fillMode = kCAFillModeForwards;
            [myShapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
            
            //4: Fiddle with it using CAShapeLayer's properties:
            NSArray *array = [CustomColor(@"svg_button_normal_color", nil) componentsSeparatedByString:@","];
            float r = [[array objectAtIndex:0] floatValue];
            float g = [[array objectAtIndex:1] floatValue];
            float b = [[array objectAtIndex:2] floatValue];
            float a = [[array objectAtIndex:3] floatValue];
            myShapeLayer.strokeColor = CGColorCreateGenericRGB(r/255.0, g/255.0, b/255.0, a);
            myShapeLayer.lineWidth = 1.4;
            myShapeLayer.fillColor = [NSColor clearColor].CGColor;//CGColorCreateGenericRGB(0.0, 0.0, 0.0, 0);
            [_animationLayer addSublayer:myShapeLayer];
        }
        [_gradientLayer setMask:_animationLayer];
    }else {
        if (_gradientLayer) {
            [_gradientLayer removeAllAnimations];
            [_gradientLayer removeFromSuperlayer];
        }
        if (_animationLayer) {
            _isAnimation = NO;
            [_animationLayer removeAllAnimations];
            [_animationLayer removeFromSuperlayer];
            NSArray *array = [NSArray arrayWithArray:[_animationLayer sublayers]];
            for (CALayer *layer in array) {
                [layer removeAllAnimations];
                [layer removeFromSuperlayer];
            }
        }
    }
}

- (void)removeAnimationLayer {
    if (_isAnimation) {
        _isAnimation = NO;
        if (_gradientLayer) {
            [_gradientLayer removeAllAnimations];
            [_gradientLayer removeFromSuperlayer];
        }
        if (_animationLayer) {
            [_animationLayer removeAllAnimations];
            [_animationLayer removeFromSuperlayer];
            NSArray *array = [NSArray arrayWithArray:[_animationLayer sublayers]];
            for (CALayer *layer in array) {
                [layer removeAllAnimations];
                [layer removeFromSuperlayer];
            }
        }
    }
}

- (void)dealloc{
    if (_mouseEnteredImage) {
        [_mouseEnteredImage release];
        _mouseEnteredImage = nil;
    }
    if (_mouseExitImage) {
        [_mouseExitImage release];
        _mouseExitImage = nil;
    }
    if (_mouseDownImage) {
        [_mouseDownImage release];
        _mouseDownImage = nil;
    }
    if (_subLayer != nil) {
        [_subLayer release];
        _subLayer = nil;
    }
    if (_myVectorDrawing) {
        [_myVectorDrawing release];
        _myVectorDrawing = nil;
    }
    if (_svgAnimationName) {
        [_svgAnimationName release];
        _svgAnimationName = nil;
    }
    [_forBidImage release],_forBidImage = nil;
    [super dealloc];
}

@end
