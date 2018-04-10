//
//  LoadingViewTwo.m
//  AllFiles
//
//  Created by hym on 06/04/2018.
//  Copyright © 2018 iMobie. All rights reserved.
//

#import "LoadingViewTwo.h"
#import "IMBCommonDefine.h"
#import "IMBViewAnimation.h"
#import "StringHelper.h"

#import <QuartzCore/QuartzCore.h>


@implementation LoadingViewTwo


- (void)awakeFromNib {
    [self setWantsLayer:YES];
    
    
    NSImage *image = [NSImage imageNamed:@"loading"];
    _layer1 = [[CALayer alloc] init];
    _layer1.contents = image;
    _layer1.frame = NSMakeRect(ceil((self.bounds.size.width - image.size.width)/2.0), ceil((self.bounds.size.height - image.size.height)/2.0), image.size.width, image.size.height);
    [self.layer addSublayer:_layer1];

    NSTextField *msgTf=  [[NSTextField alloc] init];
    msgTf.bordered = NO;
    msgTf.editable = NO;
    msgTf.lineBreakMode = NSLineBreakByCharWrapping;
    msgTf.alignment = NSTextAlignmentCenter;
    msgTf.stringValue = CustomLocalizedString(@"LoadDataTips", nil);
    msgTf.textColor =  COLOR_ALERT_SHADOWCOLOR;
    NSRect msgFrame = [StringHelper calcuTextBounds:msgTf.stringValue fontSize:14.f];
    msgTf.frame = NSMakeRect(ceil((self.bounds.size.width - msgFrame.size.width)/2.0), ceil((self.bounds.size.height - image.size.height - 60.f)/2.0), msgFrame.size.width, msgFrame.size.height);
    
    [self addSubview:msgTf];
    
    [msgTf release];
    msgTf = nil;

}

- (void)startAnimation {
    [IMBViewAnimation animationWithRotationWithLayer:_layer1];
}

- (void)firstAnimationWithLayer:(CALayer *)rectLayer withBeginTime:(float)beginTime {
    _centerX = ceil((self.bounds.size.width - rectLayer.frame.size.width)/2.0);
    CAKeyframeAnimation *rectRunAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //设定关键帧位置，必须含起始与终止位置
    rectRunAnimation.values = @[[NSValue valueWithPoint:rectLayer.frame.origin],
    [NSValue valueWithPoint:CGPointMake(_centerX + rectLayer.frame.size.width/2.0 + 15,rectLayer.frame.origin.y)],[NSValue valueWithPoint:CGPointMake(_centerX + rectLayer.frame.size.width/2.0 ,rectLayer.frame.origin.y)],[NSValue valueWithPoint:CGPointMake(_centerX + rectLayer.frame.size.width/2.0,rectLayer.frame.origin.y)],[NSValue valueWithPoint:CGPointMake(_centerX + rectLayer.frame.size.width/2.0 - 15,rectLayer.frame.origin.y)],[NSValue valueWithPoint:CGPointMake(self.bounds.size.width - rectLayer.frame.size.width, rectLayer.frame.origin.y)]];
    //设定每个关键帧的时长，如果没有显式地设置，则默认每个帧的时间=总duration/(values.count - 1)
   rectRunAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.4], [NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:1]];
    
    rectRunAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
         rectRunAnimation.repeatCount = NSIntegerMax;
         rectRunAnimation.autoreverses = NO;
         rectRunAnimation.calculationMode = kCAAnimationLinear;
         rectRunAnimation.duration = 4;
    rectRunAnimation.beginTime = beginTime;
         [rectLayer addAnimation:rectRunAnimation forKey:@"rectRunAnimation"];
}

- (void)secondAnimationWithLayer:(CALayer *)rectLayer withBeginTime:(float)beginTime {
    _centerX = ceil((self.bounds.size.width - rectLayer.frame.size.width)/2.0);
    CAKeyframeAnimation *rectRunAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //设定关键帧位置，必须含起始与终止位置
    rectRunAnimation.values = @[[NSValue valueWithPoint:rectLayer.frame.origin],
                                [NSValue valueWithPoint:CGPointMake(_centerX + rectLayer.frame.size.width/2.0 + 15,rectLayer.frame.origin.y)],
                                    [NSValue valueWithPoint:CGPointMake(_centerX + rectLayer.frame.size.width/2.0,rectLayer.frame.origin.y)],
                                [NSValue valueWithPoint:CGPointMake(_centerX + rectLayer.frame.size.width/2.0+5,rectLayer.frame.origin.y)],
                                [NSValue valueWithPoint:CGPointMake(_centerX + rectLayer.frame.size.width/2.0,rectLayer.frame.origin.y)],
                                [NSValue valueWithPoint:CGPointMake(_centerX + rectLayer.frame.size.width/2.0 - 15,rectLayer.frame.origin.y)],
                                [NSValue valueWithPoint:CGPointMake(self.bounds.size.width - rectLayer.frame.size.width, rectLayer.frame.origin.y)]];
    //设定每个关键帧的时长，如果没有显式地设置，则默认每个帧的时间=总duration/(values.count - 1)
    rectRunAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.5] ,[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:1]];
    
    rectRunAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    rectRunAnimation.repeatCount = NSIntegerMax;
    rectRunAnimation.autoreverses = NO;
    rectRunAnimation.calculationMode = kCAAnimationLinear;
    rectRunAnimation.duration = 4;
    rectRunAnimation.beginTime = beginTime;
    [rectLayer addAnimation:rectRunAnimation forKey:@"rectRunAnimation"];
}

- (void)endAnimation {
    [_layer1 removeAllAnimations];
}

- (void)dealloc {
    if (_bgLayer) {
        [_bgLayer release];
        _bgLayer = nil;
    }
    if (_layer1) {
        [_layer1 release];
        _layer1 = nil;
    }
    if (_layer2) {
        [_layer2 release];
        _layer2 = nil;
    }
    if (_layer3) {
        [_layer3 release];
        _layer3 = nil;
    }
    [super dealloc];
}

@end
