//
//  IMBDrawOneImageBtn.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-4-8.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBDrawOneImageBtn.h"
#import "StringHelper.h"
#import "IMBAnimation.h"
#import "IMBMainNavigationView.h"
#import "BaseDrive.h"
#import "IMBCloudManager.h"
@implementation IMBDrawOneImageBtn
@synthesize isEnble = _isEnble;
@synthesize longTimeDown = _longTimeDown;
@synthesize longTimeImage = _longTimeImage;
@synthesize cloudEntity = _cloudEntity;
@synthesize isDownOtherBtn = _isDownOtherBtn;
@synthesize delegate = _delegate;
@synthesize toolTipStr = _toolTipStr;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code here.
    }
    return self;
}

- (void)mouseDownImage:(NSImage*) mouseDownImg withMouseUpImg:(NSImage *) mouseUpImg withMouseExitedImg:(NSImage *) mouseExiteImg mouseEnterImg:(NSImage *) mouseEnterImg {
    if (_mouseDownImage != nil) {
        [_mouseDownImage release];
        _mouseDownImage = nil;
    }
    if (_mouseUpImage != nil) {
        [_mouseUpImage release];
        _mouseUpImage = nil;
    }
    if (_mouseExitedImage != nil) {
        [_mouseExitedImage release];
        _mouseExitedImage = nil;
    }
    if (_mouseEnteredImage != nil) {
        [_mouseEnteredImage release];
        _mouseEnteredImage = nil;
    }
    _mouseDownImage = [mouseDownImg retain];
    _mouseUpImage = [mouseUpImg retain];
    _mouseExitedImage = [mouseExiteImg retain];
    _mouseEnteredImage = [mouseEnterImg retain];
    [self setWantsLayer:YES];
    _backgroundLayer = [[CALayer alloc]init];
    [_backgroundLayer setBackgroundColor:[StringHelper getColorFromString:CustomColor(@"tableView_select_color", nil)].CGColor];
    [_backgroundLayer setCornerRadius:46];
    [_backgroundLayer setFrame:NSMakeRect(-20, -20, self.frame.size.width + 40, self.frame.size.height +40)];
    _imageLayer = [[CALayer alloc]init];
    [_imageLayer setContents:_mouseExitedImage];
    int width = 0;
    int height = 0;
//    if (_mouseExitedImage.size.width == 72 && _mouseExitedImage.size.height ==72) {
        width = 40;
        height = 40;
//    }else {
//        width = _mouseExitedImage.size.width;
//        height = _mouseExitedImage.size.height;
//    }
//    [_imageLayer setAnchorPoint:NSMakePoint(0, 0)];
    [_imageLayer setFrame:NSMakeRect((self.frame.size.width - width)/2, (self.frame.size.height - height)/2, width, height)];
    if (_mouseExitedImage.size.width == 30 && _mouseExitedImage.size.height ==20) {
       [_imageLayer setFrame:NSMakeRect((self.frame.size.width - width)/2, (self.frame.size.height - height)/2 +6, width, height)];
    }

    [self.layer addSublayer:_backgroundLayer];
    [self.layer addSublayer:_imageLayer];
    [_backgroundLayer setHidden:YES];
}

- (void)updateTrackingAreas {
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

- (void)dealloc {
    if (_mouseDownImage != nil) {
        [_mouseDownImage release];
        _mouseDownImage = nil;
    }
    if (_mouseUpImage != nil) {
        [_mouseUpImage release];
        _mouseUpImage = nil;
    }
    if (_mouseExitedImage != nil) {
        [_mouseExitedImage release];
        _mouseExitedImage = nil;
    }
    if (_mouseEnteredImage != nil) {
        [_mouseEnteredImage release];
        _mouseEnteredImage = nil;
    }
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    if (_backgroundLayer != nil) {
        [_backgroundLayer release];
        _backgroundLayer = nil;
    }
    if (_imageLayer != nil) {
        [_imageLayer release];
        _imageLayer = nil;
    }
    [super dealloc];
}

- (void)setEnabled:(BOOL)flag {
    if (flag != self.isEnabled) {
        [super setEnabled:flag];
        if (!self.isEnabled) {
            [self setAlphaValue:0.5];
        }else {
            [self setAlphaValue:1];
        }
        [self setNeedsDisplay:YES];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
//    [_imageLayer removeAllAnimations];
//    [_imageLayer setAnchorPoint:NSMakePoint(0.5, 0.5)];
//    if (!_longTimeDown &&!_isDownOtherBtn) {
//        if (_buttonType == MouseEnter) {
//            CAAnimation *animation = [IMBAnimation scale:@1 orgin:@1.1 durTimes:0.2 Rep:0];
//            animation.autoreverses = NO;
//            [_imageLayer addAnimation:animation forKey:@"enter"];
//        }else if (_buttonType == MouseOut) {
//            CAAnimation *animation = [IMBAnimation scale:@1.1 orgin:@1 durTimes:0.2 Rep:0];
//            animation.autoreverses = NO;
//            [_imageLayer addAnimation:animation forKey:@"out"];
//        }else if (_buttonType == MouseDown) {
//            CAAnimation *animation1 = [IMBAnimation scale:@1.1 orgin:@0.6 durTimes:0.2 Rep:0];
//            animation1.autoreverses = NO;
//            animation1.beginTime = 0.0;
//            [_imageLayer addAnimation:animation1 forKey:@"down"];
//        }else if (_buttonType == MouseUp) {
//            CAAnimation *animation1 = [IMBAnimation scale:@0.6 orgin:@1.4 durTimes:0.2 Rep:0];
//            animation1.autoreverses = NO;
//            animation1.beginTime = 0;
//            CAAnimation *animation2 = [IMBAnimation scale:@1.4 orgin:@1.1 durTimes:0.2 Rep:0];
//            animation2.autoreverses = NO;
//            animation2.beginTime = 0.2;
//            CAAnimationGroup *group = [CAAnimationGroup animation];
//            group.animations = @[animation1,animation2];
//            group.duration = 0.4;
//            group.autoreverses = NO;
//            group.removedOnCompletion=NO;
//            group.fillMode=kCAFillModeForwards;
//            group.beginTime = 0.0;
//            group.repeatCount = 0;
//            [_imageLayer addAnimation:group forKey:@"up"];
//        }else {
//            [_imageLayer removeAllAnimations];
//        }
//    }
//    if (!_longTimeDown) {
//        _isFristAnimation = NO;
//        [_backgroundLayer setHidden:YES];
//    }
//    if (_longTimeDown&&!_isFristAnimation) {
//        _isFristAnimation = YES;
//        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
//        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//            NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:dirtyRect];
//            [clipPath setWindingRule:NSEvenOddWindingRule];
//            [clipPath addClip];
//            [[StringHelper getColorFromString:CustomColor(@"tableView_select_color", nil)] set];
//            [clipPath fill];
//            [_backgroundLayer removeAllAnimations];
//            [_imageLayer removeAllAnimations];
//            [_backgroundLayer setAnchorPoint:NSMakePoint(0.5, 0.5)];
//            [_imageLayer setAnchorPoint:NSMakePoint(0.5, 0.5)];
//            CAAnimation *animation = [IMBAnimation scale:@0 orgin:@1.0 durTimes:0.3 Rep:0];
//            animation.autoreverses = NO;
//            [_backgroundLayer addAnimation:animation forKey:@"enter"];
//            [_backgroundLayer setHidden:NO];
//            CAAnimation *animation2 = [IMBAnimation scale:@0 orgin:@1.0 durTimes:0.1 Rep:0];
//            animation2.autoreverses = NO;
//            [_imageLayer addAnimation:animation2 forKey:@"enter1"];
//        });
//    }
//
    if (!_longTimeDown) {
        [_backgroundLayer setHidden:YES];
    }else {
    [_backgroundLayer setHidden:NO];
    }
    if(_isEnble){
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:[self.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setAlignment:NSCenterTextAlignment];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor colorWithDeviceRed:24.0/255 green:183.0/255 blue:165.0/255 alpha:1.000],NSForegroundColorAttributeName ,paragraphStyle,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue Light" size:28],NSFontAttributeName, nil];
        NSSize textSize = [as.string sizeWithAttributes:attributes];
        NSRect f;
        f = NSMakeRect((dirtyRect.size.width - textSize.width)/2, (dirtyRect.size.height - textSize.height)/2-1, textSize.width, textSize.height);
        [as.string drawInRect:f withAttributes:attributes];
        [as release];
        [paragraphStyle release];
        paragraphStyle = nil;
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    if (self.isEnabled&& !_longTimeDown) {
        _buttonType = MouseUp;
        [self setNeedsDisplay:YES];
        if (self.isEnabled) {
            NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
            BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
            if (inner) {
                [NSApp sendAction:self.action to:self.target from:self];
            }
        }
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (self.isEnabled && !_longTimeDown) {
        [_backgroundLayer removeAllAnimations];
        [_imageLayer removeAllAnimations];
        [_backgroundLayer setAnchorPoint:NSMakePoint(0.5, 0.5)];
        [_imageLayer setAnchorPoint:NSMakePoint(0.5, 0.5)];
        CAAnimation *animation3 = [IMBAnimation scale:@1.0 orgin:@0.4 durTimes:0.1 Rep:0];
        animation3.autoreverses = NO;
        [_imageLayer addAnimation:animation3 forKey:@"enter1"];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            CAAnimation *animation = [IMBAnimation scale:@0.4 orgin:@1.0 durTimes:0.3 Rep:0];
            animation.autoreverses = NO;
            [_backgroundLayer addAnimation:animation forKey:@"enter"];
            [_backgroundLayer setHidden:NO];
            CAAnimation *animation2 = [IMBAnimation scale:@0.4 orgin:@1.0 durTimes:0.1 Rep:0];
            animation2.autoreverses = NO;
            [_imageLayer addAnimation:animation2 forKey:@"enter1"];
        });

        _buttonType = MouseDown;
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (self.isEnabled && !_longTimeDown) {
        CAAnimation *animation = [IMBAnimation scale:@1.1 orgin:@1 durTimes:0.2 Rep:0];
        animation.autoreverses = NO;
        [_imageLayer addAnimation:animation forKey:@"out"];
        _buttonType = MouseOut;
        [self setNeedsDisplay:YES];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(toolTipViewClose)]) {
        [self.delegate toolTipViewClose];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    if (self.isEnabled && !_longTimeDown ) {
        CAAnimation *animation = [IMBAnimation scale:@1 orgin:@1.1 durTimes:0.2 Rep:0];
        animation.autoreverses = NO;
        [_imageLayer addAnimation:animation forKey:@"enter"];
        _isDownOtherBtn = NO;
        _buttonType = MouseEnter;
        [self setNeedsDisplay:YES];
    }
    int64_t delayInSeconds = 0.00005;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
        BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
        if (inner) {
            [self setNeedsDisplay:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(showToolTip:withToolTip:)]) {
                NSString *name = nil;
                if (_cloudEntity) {
                    BaseDrive *baseDrive = [[IMBCloudManager singleton] getBindDrive:_cloudEntity.driveID];
                    if (baseDrive) {
                        name = baseDrive.displayName;
                    }
                    if ([StringHelper stringIsNilOrEmpty:name]) {
                        name = _cloudEntity.name;
                    }
                }else {
                    name = _toolTipStr;
                }
                [self.delegate showToolTip:self withToolTip:name];
            }
        }
    });

}
@end
