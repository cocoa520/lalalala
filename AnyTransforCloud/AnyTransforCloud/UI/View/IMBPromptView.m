//
//  IMBPromptView.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/5/3.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBPromptView.h"
#import "StringHelper.h"
#import <Quartz/Quartz.h>

@implementation IMBPromptView

- (void)awakeFromNib {

}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if ([super initWithFrame:frameRect]) {
        _loadImageLayer = [[CALayer alloc] init];
        [self setWantsLayer:YES];
        [self.layer addSublayer:_loadImageLayer];
    }
    return self;
}

- (void)setFillColor:(NSColor *)fillColor withBorderColor:(NSColor *)borderColor {
    if (_fillColor) {
        [_fillColor release];
        _fillColor = nil;
    }
    _fillColor = [fillColor retain];
    if (_borderColor) {
        [_borderColor release];
        _borderColor = nil;
    }
    _borderColor = [borderColor retain];
    
}

- (void)setImage:(NSImage *)image WithTextString:(NSString *)textString withIsLoading:(BOOL)isLoading withIsState:(promptTypeEnum)promptEnum {
    _image = [image retain];
    _textString = [textString retain];
    _promptEnum = promptEnum;
    _isLoading = isLoading;
    _loadImageLayer.contents = _image;
    _loadImageLayer.frame = NSMakeRect(14, 12, 14, 14);
    [self setNeedsDisplay:YES];
    if (!_isLoading) {
        [_loadImageLayer removeAllAnimations];
    }else {
        [self animationWithRotationWithLayer:_loadImageLayer];
    }
}

- (void)dealloc {
    if (_fillColor) {
        [_fillColor release];
        _fillColor = nil;
    }
    if (_borderColor) {
        [_borderColor release];
        _borderColor = nil;
    }
    if (_textString) {
        [_textString release];
        _textString = nil;
    }
    if (_loadImageLayer) {
        [_loadImageLayer release];
        _loadImageLayer = nil;
    }
    if (_image) {
        [_image release];
        _image = nil;
    }
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    [path setLineWidth:1];
    [path addClip];
    [path setWindingRule:NSEvenOddWindingRule];
    [_fillColor setFill];
    [_borderColor setStroke];
    [path fill];
    [path stroke];
    [path closePath];
    
    NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
    NSRect titleRect = [StringHelper calcuTextBounds:_textString font:font];
    NSColor *titileColor = [StringHelper getColorFromString:CustomColor(@"prompt_success_title_Color", )];
    if (_promptEnum == failedType) {
        titileColor = [StringHelper getColorFromString:CustomColor(@"prompt_fail_title_Color", )];
    }else if (_promptEnum == successedType){
        titileColor = [StringHelper getColorFromString:CustomColor(@"prompt_success_title_Color", )];
    }else {
        titileColor = [StringHelper getColorFromString:CustomColor(@"prompt_wait_title_Color", )];
    }

    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[font, titileColor] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
    titleRect = NSMakeRect(_loadImageLayer.frame.size.width + _loadImageLayer.frame.origin.x + 14,(dirtyRect.size.height - titleRect.size.height) / 2.0 + 2, titleRect.size.width, titleRect.size.height);
    [_textString drawInRect:titleRect withAttributes:dic];
}

- (void)animationWithRotationWithLayer:(CALayer *)layer {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    animation.fromValue = @(2*M_PI);
    animation.toValue = 0;
    animation.repeatCount = MAXFLOAT;
    animation.duration = 1.f;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [layer setAnchorPoint:NSMakePoint(0.5, 0.5)];
    [layer addAnimation:animation forKey:@"rotationZ"];
}


@end
