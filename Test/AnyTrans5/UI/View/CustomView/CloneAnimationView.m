//
//  CloneAnimationView.m
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-8-12.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "CloneAnimationView.h"
#import "CALayer+Animation.h"
#import "StringHelper.h"
@implementation CloneAnimationView
@synthesize transfertype = _transferType;
@synthesize isAndroid = _isAndroid;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [self setWantsLayer:YES];
    _bglayer = [[CALayer layer] retain];
    [_bglayer setAnchorPoint:CGPointMake(0, 0)];
    [_bglayer setFrame:NSRectToCGRect(self.bounds)];
    
    _backupDeviceLayer = [[CALayer layer] retain];
    [_backupDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 116)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 116, 180)];
    
    _backupClipBgLayer = [[CALayer layer] retain];
    [_backupClipBgLayer setMasksToBounds:YES];
    [_backupClipBgLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_backupDeviceLayer.frame)) - 80)/2),ceil((NSHeight(NSRectFromCGRect(_backupDeviceLayer.frame)) - 130)/2), 80, 130)];
    
    _textLayer1 = [[CATextLayer layer] retain];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"00000001"];
    [string addAttribute:NSForegroundColorAttributeName
                   value:[NSColor colorWithDeviceRed:1.0/255 green:150.0/255 blue:235.0/255 alpha:1.0]
                   range:NSMakeRange(0, [string length])];
    [string addAttribute:NSFontAttributeName
                   value:[NSFont fontWithName:@"Helvetica Neue" size:12]
                   range:NSMakeRange(0, [string length])];
    [_textLayer1 setString:string];
    [string release];
    [_textLayer1 setFrame:CGRectMake(-60,10, 60, 22)];
    
    _textLayer2 = [[CATextLayer layer] retain];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"00000011"];
    [string2 addAttribute:NSForegroundColorAttributeName
                   value:[NSColor colorWithDeviceRed:1.0/255 green:150.0/255 blue:235.0/255 alpha:1.0]
                   range:NSMakeRange(0, [string2 length])];
    [string2 addAttribute:NSFontAttributeName
                   value:[NSFont fontWithName:@"Helvetica Neue" size:12]
                   range:NSMakeRange(0, [string2 length])];
    [_textLayer2 setString:string2];
    [string2 release];
    [_textLayer2 setFrame:CGRectMake(-60,30, 60, 22)];
    
    _textLayer3 = [[CATextLayer layer] retain];
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:@"00100010"];
    [string3 addAttribute:NSForegroundColorAttributeName
                    value:[NSColor colorWithDeviceRed:1.0/255 green:150.0/255 blue:235.0/255 alpha:1.0]
                    range:NSMakeRange(0, [string3 length])];
    [string3 addAttribute:NSFontAttributeName
                    value:[NSFont fontWithName:@"Helvetica Neue" size:12]
                    range:NSMakeRange(0, [string3 length])];
    [_textLayer3 setString:string3];
    [string3 release];
    [_textLayer3 setFrame:CGRectMake(-60,50, 60, 22)];
    
    _textLayer4 = [[CATextLayer layer] retain];
    NSMutableAttributedString *string4 = [[NSMutableAttributedString alloc] initWithString:@"00111010"];
    [string4 addAttribute:NSForegroundColorAttributeName
                    value:[NSColor colorWithDeviceRed:1.0/255 green:150.0/255 blue:235.0/255 alpha:1.0]
                    range:NSMakeRange(0, [string4 length])];
    [string4 addAttribute:NSFontAttributeName
                    value:[NSFont fontWithName:@"Helvetica Neue" size:12]
                    range:NSMakeRange(0, [string4 length])];
    [_textLayer4 setString:string4];
    [string4 release];
    [_textLayer4 setFrame:CGRectMake(-60,70, 60, 22)];
    
    _textLayer5 = [[CATextLayer layer] retain];
    NSMutableAttributedString *string5 = [[NSMutableAttributedString alloc] initWithString:@"10101010"];
    [string5 addAttribute:NSForegroundColorAttributeName
                    value:[NSColor colorWithDeviceRed:1.0/255 green:150.0/255 blue:235.0/255 alpha:1.0]
                    range:NSMakeRange(0, [string5 length])];
    [string5 addAttribute:NSFontAttributeName
                    value:[NSFont fontWithName:@"Helvetica Neue" size:12]
                    range:NSMakeRange(0, [string5 length])];
    [_textLayer5 setString:string5];
    [string5 release];
    [_textLayer5 setFrame:CGRectMake(-60,90, 60, 22)];
    
    _textLayer6 = [[CATextLayer layer] retain];
    NSMutableAttributedString *string6 = [[NSMutableAttributedString alloc] initWithString:@"00101011"];
    [string6 addAttribute:NSForegroundColorAttributeName
                    value:[NSColor colorWithDeviceRed:1.0/255 green:150.0/255 blue:235.0/255 alpha:1.0]
                    range:NSMakeRange(0, [string6 length])];
    [string6 addAttribute:NSFontAttributeName
                    value:[NSFont fontWithName:@"Helvetica Neue" size:12]
                    range:NSMakeRange(0, [string6 length])];
    [_textLayer6 setString:string6];
    [string6 release];
    [_textLayer6 setFrame:CGRectMake(-60,110, 60, 22)];
    
    _circleLayer = [[CALayer layer] retain];
    [_circleLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [_circleLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_backupDeviceLayer.frame)) - 48)/2),ceil((NSHeight(NSRectFromCGRect(_backupDeviceLayer.frame)) - 48)/2), 48, 48)];
    _circleLayer.contents = [StringHelper imageNamed:@"clone_Circle"];

 
    
    _sourceCloneDeviceLayer = [[CALayer layer] retain];
    [_sourceCloneDeviceLayer setAnchorPoint:CGPointMake(0, 0)];
//    [_sourceCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 116)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 116, 180)];
    
    _targetCloneDeviceLayer = [[CALayer layer] retain];
    [_targetCloneDeviceLayer setAnchorPoint:CGPointMake(0, 0)];
//    [_targetCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 116)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 116, 180)];
 
    
    if (_isAndroid) {
        if (_transferType == ToDeviceType) {
            [_sourceCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 164)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 164, 180)];
            [_targetCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 116)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 116, 180)];
        }else if (_transferType == ToiTunesType){
            [_sourceCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 164)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 164, 180)];
            [_targetCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 122)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 122)/2), 122, 122)];
        }else{
            [_sourceCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 164)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 164, 180)];
            [_targetCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 164)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2) , 164, 180)];
        }
    }else{
        [_sourceCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 116)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 116, 180)];
        [_targetCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 116)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 116, 180)];
    }
    
    
    _dataLayer1 = [[CALayer layer] retain];
    [_dataLayer1 setAnchorPoint:CGPointMake(0, 0)];
    [_dataLayer1 setFrame:CGRectMake(32,ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 28)/2)+40 , 68, 28)];
    _dataLayer1.contents = [StringHelper imageNamed:@"clone_data1"];
    
    _dataLayer2 = [[CALayer layer] retain];
    [_dataLayer2 setAnchorPoint:CGPointMake(0, 0)];
    [_dataLayer2 setFrame:CGRectMake(32,ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 28)/2), 68, 28)];
    _dataLayer2.contents = [StringHelper imageNamed:@"clone_data2"];

    _dataLayer3 = [[CALayer layer] retain];
    [_dataLayer3 setAnchorPoint:CGPointMake(0, 0)];
    [_dataLayer3 setFrame:CGRectMake(32,ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 28)/2)-40 , 68, 28)];
    _dataLayer3.contents = [StringHelper imageNamed:@"clone_data3"];

    [_bglayer addSublayer:_dataLayer1];
    [_bglayer addSublayer:_dataLayer2];
    [_bglayer addSublayer:_dataLayer3];
    [_dataLayer1 setHidden:YES];
    [_dataLayer2 setHidden:YES];
    [_dataLayer3 setHidden:YES];

    [_backupClipBgLayer addSublayer:_textLayer1];
    [_backupClipBgLayer addSublayer:_textLayer2];
    [_backupClipBgLayer addSublayer:_textLayer3];
    [_backupClipBgLayer addSublayer:_textLayer4];
    [_backupClipBgLayer addSublayer:_textLayer5];
    [_backupClipBgLayer addSublayer:_textLayer6];
    [_backupDeviceLayer addSublayer:_backupClipBgLayer];
    [_backupDeviceLayer addSublayer:_circleLayer];
    [_bglayer addSublayer:_backupDeviceLayer];
    [self.layer addSublayer:_bglayer];
}

- (void)setBackupImage:(NSImage *)backupImage sourceImage:(NSImage *)sourceImage targetImage:(NSImage *)targetImage
{
    _backupDeviceLayer.contents = backupImage;
    _sourceCloneDeviceLayer.contents = sourceImage;
    _targetCloneDeviceLayer.contents = targetImage;
    if ([backupImage.name isEqualToString:@"cloning_iPhone"]) {
        //75 130
        [_backupClipBgLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_backupDeviceLayer.frame)) - 75)/2),ceil((NSHeight(NSRectFromCGRect(_backupDeviceLayer.frame)) - 130)/2), 75, 130)];
        
    }else if ([backupImage.name isEqualToString:@"cloning_iPad"]){
        //100 135
         [_backupClipBgLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_backupDeviceLayer.frame)) - 100)/2),ceil((NSHeight(NSRectFromCGRect(_backupDeviceLayer.frame)) - 135)/2), 100, 135)];
    }else if ([backupImage.name isEqualToString:@"cloning_iPodTouch"]){
        //75 125
        [_backupClipBgLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_backupDeviceLayer.frame)) - 75)/2),ceil((NSHeight(NSRectFromCGRect(_backupDeviceLayer.frame)) - 125)/2), 70, 125)];
    }else if ([backupImage.name isEqualToString:@"clone_iPhonex_def"]){
        //75 125
        [_backupClipBgLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_backupDeviceLayer.frame)) - 116)/2),ceil((NSHeight(NSRectFromCGRect(_backupDeviceLayer.frame)) - 180)/2), 116, 180)];
    }
}

- (void)reLayerSize
{
    if (_isAndroid) {
        if (_transferType == ToDeviceType) {
            [_sourceCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 116)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 164, 180)];
            [_targetCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 164)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 116, 180)];
        }else if (_transferType == ToiTunesType){
            [_sourceCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 164)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 164, 180)];
            [_targetCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 122)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 122)/2), 122, 122)];
        }else{
            [_sourceCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 164)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 164, 180)];
            [_targetCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 164)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 164, 180)];
        }
    }else{
        if (_transferType == ToiCloudType) {
            [_sourceCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 164)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 164, 180)];
            [_targetCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 164)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 164, 180)];
        }else {
            [_sourceCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 116)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 116, 180)];
            [_targetCloneDeviceLayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 116)/2),ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 180)/2), 116, 180)];
        }

    }

    
    [_dataLayer1 setFrame:CGRectMake(32,ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 28)/2)+35 , 68, 28)];
    [_dataLayer3 setFrame:CGRectMake(32,ceil((NSHeight(NSRectFromCGRect(_bglayer.frame)) - 28)/2)-35 , 68, 28)];
    _reset = YES;

}

/*
 开始准备备份动画
 **/
- (void)startPrepareBackupAnimation
{
    [_circleLayer animateKey:@"transform.rotation.z"  fromValue:@0 toValue:@(-2*M_PI) customize:^(CABasicAnimation *animation) {
        animation.repeatCount = NSIntegerMax;
        animation.duration = 1.0;
    }];
}
/*
 开始备份动画
 **/
- (void)startBackupAnimation
{
    [_circleLayer removeAllAnimations];
    [_circleLayer removeFromSuperlayer];
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
    CGMutablePathRef path1 = CGPathCreateMutable();
    CGPathMoveToPoint(path1, &transform, -(_textLayer1.frame.size.width), _textLayer1.frame.origin.y);
    CGPathAddLineToPoint(path1, &transform,_backupClipBgLayer.frame.size.width+_textLayer1.frame.size.width, _textLayer1.frame.origin.y);
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation1.duration = 1.8;
    animation1.fillMode = kCAFillModeForwards;
    animation1.repeatCount = NSIntegerMax;
    animation1.removedOnCompletion = NO;
    animation1.autoreverses = NO;
    animation1.path = path1;
    CGPathRelease(path1);
    [_textLayer1 addAnimation:animation1 forKey:@"text1"];
    
    CGMutablePathRef path2 = CGPathCreateMutable();
    CGPathMoveToPoint(path2, &transform, -(_textLayer2.frame.size.width), _textLayer2.frame.origin.y);
    CGPathAddLineToPoint(path2, &transform,_backupClipBgLayer.frame.size.width+_textLayer2.frame.size.width, _textLayer2.frame.origin.y);
    CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation2.duration = 1.8;
    animation2.fillMode = kCAFillModeForwards;
    animation2.repeatCount = NSIntegerMax;
    animation2.removedOnCompletion = NO;
    animation2.autoreverses = NO;
    animation2.path = path2;
    CGPathRelease(path2);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_textLayer2 addAnimation:animation2 forKey:@"text2"];
    });
    
    CGMutablePathRef path3 = CGPathCreateMutable();
    CGPathMoveToPoint(path3, &transform, -(_textLayer3.frame.size.width), _textLayer3.frame.origin.y);
    CGPathAddLineToPoint(path3, &transform,_backupClipBgLayer.frame.size.width+_textLayer3.frame.size.width, _textLayer3.frame.origin.y);
    CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation3.duration = 1.8;
    animation3.fillMode = kCAFillModeForwards;
    animation3.repeatCount = NSIntegerMax;
    animation3.removedOnCompletion = NO;
    animation3.autoreverses = NO;
    animation3.path = path3;
    CGPathRelease(path3);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_textLayer3 addAnimation:animation3 forKey:@"text3"];
    });
    
    CGMutablePathRef path4 = CGPathCreateMutable();
    CGPathMoveToPoint(path4, &transform, -(_textLayer4.frame.size.width), _textLayer4.frame.origin.y);
    CGPathAddLineToPoint(path4, &transform,_backupClipBgLayer.frame.size.width+_textLayer4.frame.size.width, _textLayer4.frame.origin.y);
    CAKeyframeAnimation *animation4 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation4.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation4.duration = 1.8;
    animation4.fillMode = kCAFillModeForwards;
    animation4.repeatCount = NSIntegerMax;
    animation4.removedOnCompletion = NO;
    animation4.autoreverses = NO;
    animation4.path = path4;
    CGPathRelease(path4);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_textLayer4 addAnimation:animation4 forKey:@"text4"];
        
    });
    
    CGMutablePathRef path5 = CGPathCreateMutable();
    CGPathMoveToPoint(path5, &transform, -(_textLayer5.frame.size.width), _textLayer5.frame.origin.y);
    CGPathAddLineToPoint(path5, &transform,_backupClipBgLayer.frame.size.width+_textLayer5.frame.size.width, _textLayer5.frame.origin.y);
    CAKeyframeAnimation *animation5 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation5.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation5.duration = 1.8;
    animation5.fillMode = kCAFillModeForwards;
    animation5.repeatCount = NSIntegerMax;
    animation5.removedOnCompletion = NO;
    animation5.autoreverses = NO;
    animation5.path = path5;
    CGPathRelease(path5);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_textLayer5 addAnimation:animation5 forKey:@"text5"];
        
    });
    
    CGMutablePathRef path6 = CGPathCreateMutable();
    CGPathMoveToPoint(path6, &transform, -(_textLayer6.frame.size.width), _textLayer6.frame.origin.y);
    CGPathAddLineToPoint(path6, &transform,_backupClipBgLayer.frame.size.width+_textLayer6.frame.size.width, _textLayer6.frame.origin.y);
    CAKeyframeAnimation *animation6 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation6.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation6.duration = 1.8;
    animation6.fillMode = kCAFillModeForwards;
    animation6.repeatCount = NSIntegerMax;
    animation6.removedOnCompletion = NO;
    animation6.autoreverses = NO;
    animation6.path = path6;
    CGPathRelease(path6);
    [_textLayer6 addAnimation:animation6 forKey:@"text5"];
}
/*
 开始clone数据
 **/
- (void)startCloneDataAnimation
{
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [_backupDeviceLayer animateKey:@"opacity" fromValue:@1.0 toValue:@0.0 customize:^(CABasicAnimation *animation) {
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.duration = 0.3;
        }];
    } completionHandler:^{
        [_textLayer1 removeAllAnimations];
        [_textLayer2 removeAllAnimations];
        [_textLayer3 removeAllAnimations];
        [_textLayer4 removeAllAnimations];
        [_textLayer5 removeAllAnimations];
        [_textLayer6 removeAllAnimations];
        [_textLayer1 removeFromSuperlayer];
        [_textLayer2 removeFromSuperlayer];
        [_textLayer3 removeFromSuperlayer];
        [_textLayer4 removeFromSuperlayer];
        [_textLayer5 removeFromSuperlayer];
        [_textLayer6 removeFromSuperlayer];
        [_backupDeviceLayer removeAllAnimations];
        [_backupDeviceLayer removeFromSuperlayer];
        [_bglayer addSublayer:_sourceCloneDeviceLayer];
        [_bglayer addSublayer:_targetCloneDeviceLayer];
        CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacity.fromValue = @(0.0);
        opacity.toValue = @(1.0);
        [opacity setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        opacity.duration = 1.0;
        opacity.autoreverses = NO;
        opacity.removedOnCompletion = NO;
        opacity.repeatCount = 1;
        opacity.fillMode = kCAFillModeForwards;
        
        CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
        CGMutablePathRef pathtoleft = CGPathCreateMutable();
        CGPathMoveToPoint(pathtoleft, &transform, _sourceCloneDeviceLayer.frame.origin.x, _sourceCloneDeviceLayer.frame.origin.y);
        CGPathAddLineToPoint(pathtoleft, &transform,0, _sourceCloneDeviceLayer.frame.origin.y);
        CAKeyframeAnimation *animationtoleft = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animationtoleft.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animationtoleft.duration = 1.0;
        animationtoleft.fillMode = kCAFillModeForwards;
        animationtoleft.repeatCount = 1;
        animationtoleft.removedOnCompletion = NO;
        animationtoleft.autoreverses = NO;
        animationtoleft.path = pathtoleft;
        CGPathRelease(pathtoleft);
        
        CGMutablePathRef pathtoright = CGPathCreateMutable();
        CGPathMoveToPoint(pathtoright, &transform, _targetCloneDeviceLayer.frame.origin.x, _targetCloneDeviceLayer.frame.origin.y);
        CGPathAddLineToPoint(pathtoright, &transform,_bglayer.frame.size.width - _targetCloneDeviceLayer.frame.size.width , _targetCloneDeviceLayer.frame.origin.y);
        CAKeyframeAnimation *animationtoright = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animationtoright.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animationtoright.duration = 1.0;
        animationtoright.fillMode = kCAFillModeForwards;
        animationtoright.repeatCount = 1;
        animationtoright.removedOnCompletion = NO;
        animationtoright.autoreverses = NO;
        animationtoright.path = pathtoright;
        CGPathRelease(pathtoright);
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [_sourceCloneDeviceLayer addAnimation:opacity forKey:@"opacity"];
            [_sourceCloneDeviceLayer addAnimation:animationtoleft forKey:@"position"];
            [_targetCloneDeviceLayer addAnimation:opacity forKey:@"opacity"];
            [_targetCloneDeviceLayer addAnimation:animationtoright forKey:@"position"];
        } completionHandler:^{
            [_dataLayer1 setHidden:NO];
            [_dataLayer2 setHidden:NO];
            [_dataLayer3 setHidden:NO];
            CGMutablePathRef path2 = CGPathCreateMutable();
            CGPathMoveToPoint(path2, &transform, 30, _dataLayer2.frame.origin.y);
            if (_reset) {
                CGPathAddLineToPoint(path2, &transform,_bglayer.frame.size.width-110, _dataLayer2.frame.origin.y);

            }else{
                CGPathAddLineToPoint(path2, &transform,_bglayer.frame.size.width-80, _dataLayer2.frame.origin.y);

            }
            CAKeyframeAnimation *animation2 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            animation2.duration = 1.8;
            animation2.fillMode = kCAFillModeForwards;
            animation2.repeatCount = NSIntegerMax;
            animation2.removedOnCompletion = NO;
            animation2.autoreverses = NO;
            animation2.path = path2;
            CGPathRelease(path2);
            [_dataLayer2 addAnimation:animation2 forKey:@"data2"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
                CGMutablePathRef path1 = CGPathCreateMutable();
                CGPathMoveToPoint(path1, &transform, 30, _dataLayer1.frame.origin.y);
                if (_reset) {
                    CGPathAddLineToPoint(path1, &transform,_bglayer.frame.size.width-110, _dataLayer1.frame.origin.y);

                }else{
                    CGPathAddLineToPoint(path1, &transform,_bglayer.frame.size.width-80, _dataLayer1.frame.origin.y);

                }
                CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                animation1.duration = 1.8;
                animation1.fillMode = kCAFillModeForwards;
                animation1.repeatCount = NSIntegerMax;
                animation1.removedOnCompletion = NO;
                animation1.autoreverses = NO;
                animation1.path = path1;
                CGPathRelease(path1);
                [_dataLayer1 addAnimation:animation1 forKey:@"data1"];
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CGMutablePathRef path3 = CGPathCreateMutable();
                CGPathMoveToPoint(path3, &transform, 30, _dataLayer3.frame.origin.y);
                if (_reset) {
                    CGPathAddLineToPoint(path3, &transform,_bglayer.frame.size.width-110, _dataLayer3.frame.origin.y);

                }else{
                    CGPathAddLineToPoint(path3, &transform,_bglayer.frame.size.width-80, _dataLayer3.frame.origin.y);

                }
                CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
                animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                animation3.duration = 1.8;
                animation3.fillMode = kCAFillModeForwards;
                animation3.repeatCount = NSIntegerMax;
                animation3.removedOnCompletion = NO;
                animation3.autoreverses = NO;
                animation3.path = path3;
                CGPathRelease(path3);
                [_dataLayer3 addAnimation:animation3 forKey:@"data3"];
            });
        }];
    }];
}

- (void)stopAnimation
{
    [_circleLayer removeAllAnimations];
    [_textLayer1 removeAllAnimations];
    [_textLayer2 removeAllAnimations];
    [_textLayer3 removeAllAnimations];
    [_textLayer4 removeAllAnimations];
    [_textLayer5 removeAllAnimations];
    [_textLayer6 removeAllAnimations];
    [_textLayer1 removeFromSuperlayer];
    [_textLayer2 removeFromSuperlayer];
    [_textLayer3 removeFromSuperlayer];
    [_textLayer4 removeFromSuperlayer];
    [_textLayer5 removeFromSuperlayer];
    [_textLayer6 removeFromSuperlayer];
    [_backupDeviceLayer removeAllAnimations];
    [_dataLayer1 removeAllAnimations];
    [_dataLayer2 removeAllAnimations];
    [_dataLayer3 removeAllAnimations];
    [_sourceCloneDeviceLayer removeAllAnimations];
    [_targetCloneDeviceLayer removeAllAnimations];
}


- (void)dealloc
{
    [_bglayer release],_bglayer = nil;
    [_backupDeviceLayer release],_backupDeviceLayer = nil;
    [_circleLayer release],_circleLayer = nil;
    [_sourceCloneDeviceLayer release],_sourceCloneDeviceLayer = nil;
    [_targetCloneDeviceLayer release],_targetCloneDeviceLayer = nil;
    [_backupClipBgLayer release],_backupClipBgLayer = nil;
    [_textLayer1 release],_textLayer1 = nil;
    [_textLayer2 release],_textLayer2 = nil;
    [_textLayer3 release],_textLayer3 = nil;
    [_textLayer4 release],_textLayer4 = nil;
    [_textLayer5 release],_textLayer5 = nil;
    [_textLayer6 release],_textLayer6 = nil;
    [_dataLayer1 release];_dataLayer1 = nil;
    [_dataLayer2 release],_dataLayer2 = nil;
    [_dataLayer3 release],_dataLayer3 = nil;
    [super dealloc];
}
@end
