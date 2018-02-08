//
//  BackupViewAnimation.m
//  AnyTrans5Animation
//
//  Created by LuoLei on 16-8-10.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "BackupViewAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import "StringHelper.h"
@implementation BackupViewAnimation

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setWantsLayer:YES];
    _bglayer = [[CALayer layer] retain];
    [_bglayer setAnchorPoint:CGPointMake(0, 0)];
    [_bglayer setFrame:NSRectToCGRect(NSMakeRect((self.frame.size.width - 604)/2, 0, 604, 304))];
    _bglayer.contents = [StringHelper imageNamed:@"backup_Animation_bg"];
    
    _itemBglayer = [[CALayer layer] retain];
    [_itemBglayer setAnchorPoint:CGPointMake(0, 0)];
    [_itemBglayer setFrame:CGRectMake(0,ceil(NSHeight(NSRectFromCGRect(_bglayer.frame)))-172, 604,164)];
    [_itemBglayer setMasksToBounds:YES];
    
    _boxlayer = [[CALayer layer] retain];
    [_boxlayer setAnchorPoint:CGPointMake(0, 0)];
    [_boxlayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_bglayer.frame)) - 124)/2),46, 126, 86)];
    _boxlayer.contents = [StringHelper imageNamed:@"backup_Animation_box"];
    
    _booklayer = [[CALayer layer] retain];
    [_booklayer setAnchorPoint:CGPointMake(0, 0)];
    [_booklayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_itemBglayer.frame)) - 46)/2),164, 46, 66)];
    _booklayer.contents = [StringHelper imageNamed:@"backup_Animation_app"];
    
    _cameralayer = [[CALayer layer] retain];
    [_cameralayer setAnchorPoint:CGPointMake(0, 0)];
    [_cameralayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_itemBglayer.frame)) - 46)/2),164, 46, 66)];
    _cameralayer.contents = [StringHelper imageNamed:@"backup_Animation_calendar"];
    
    _contactlayer = [[CALayer layer] retain];
    [_contactlayer setAnchorPoint:CGPointMake(0, 0)];
    [_contactlayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_itemBglayer.frame)) - 46)/2),164, 46, 66)];
    _contactlayer.contents = [StringHelper imageNamed:@"backup_Animation_callhistory"];
    
    _messagelayer = [[CALayer layer] retain];
    [_messagelayer setAnchorPoint:CGPointMake(0, 0)];
    [_messagelayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_itemBglayer.frame)) - 46)/2),164, 46, 66)];
    _messagelayer.contents = [StringHelper imageNamed:@"backup_Animation_contact"];
    
    _musiclayer = [[CALayer layer] retain];
    [_musiclayer setAnchorPoint:CGPointMake(0, 0)];
    [_musiclayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_itemBglayer.frame)) - 46)/2),164, 46, 66)];
    _musiclayer.contents = [StringHelper imageNamed:@"backup_Animation_message"];
    
    _playlistlayer = [[CALayer layer] retain];
    [_playlistlayer setAnchorPoint:CGPointMake(0, 0)];
    [_playlistlayer setFrame:CGRectMake(ceil((NSWidth(NSRectFromCGRect(_itemBglayer.frame)) - 46)/2),164, 46, 66)];
    _playlistlayer.contents = [StringHelper imageNamed:@"backup_Animation_note"];


    [_bglayer addSublayer:_itemBglayer];
    [_bglayer addSublayer:_boxlayer];
    [self.layer addSublayer:_bglayer];
}

- (void)startAnimation
{
   
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1.0);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, &transform, ceil((NSWidth(NSRectFromCGRect(_itemBglayer.frame)) - 46)/2), 164);
    CGPathAddLineToPoint(path, &transform, ceil((NSWidth(NSRectFromCGRect(_itemBglayer.frame)) - 46)/2), -164*5);
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation1.duration = 6.0;
    animation1.fillMode = kCAFillModeForwards;
    animation1.repeatCount = NSIntegerMax;
    animation1.removedOnCompletion = NO;
    animation1.autoreverses = NO;
    animation1.path = path;
    CGPathRelease(path);
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = @(0.0);
    animation2.toValue = @(1.0);
    [animation2 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    animation2.duration = 1.4;
    animation2.autoreverses = NO;
    animation2.removedOnCompletion = YES;
    animation2.repeatCount = NSIntegerMax;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = YES;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    group.duration = 6.0;
    group.autoreverses = NO;
    group.removedOnCompletion = YES;
    group.repeatCount = NSIntegerMax;
    group.animations = [NSArray arrayWithObjects:animation1,animation2, nil];
    [_itemBglayer addSublayer:_booklayer];
    [_booklayer addAnimation:group forKey:@"book"];
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_itemBglayer addSublayer:_cameralayer];
        [_cameralayer addAnimation:group forKey:@"camera"];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_itemBglayer addSublayer:_contactlayer];
        [_contactlayer addAnimation:group forKey:@"contact"];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_itemBglayer addSublayer:_messagelayer];
        [_messagelayer addAnimation:group forKey:@"message"];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_itemBglayer addSublayer:_musiclayer];
        [_musiclayer addAnimation:group forKey:@"music"];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_itemBglayer addSublayer:_playlistlayer];
        [_playlistlayer addAnimation:group forKey:@"playlist"];
    });
    
}

- (void)stopAnimation
{
    _boxlayer.contents = [StringHelper imageNamed:@"backup_compelete_box"];
    [_booklayer removeAllAnimations];
    [_cameralayer removeAllAnimations];
    [_contactlayer removeAllAnimations];
    [_messagelayer removeAllAnimations];
    [_musiclayer removeAllAnimations];
    [_playlistlayer removeAllAnimations];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
}

- (void)dealloc
{
    [_bglayer release],_bglayer = nil;
    [_itemBglayer release],_itemBglayer = nil;
    [_boxlayer release],_boxlayer = nil;
    [_booklayer release],_booklayer = nil;
    [_cameralayer release],_cameralayer = nil;
    [_contactlayer release],_contactlayer = nil;
    [_messagelayer release],_messagelayer = nil;
    [_musiclayer release],_musiclayer = nil;
    [_playlistlayer release],_playlistlayer = nil;
    [super dealloc];
}

@end
