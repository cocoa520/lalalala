//
//  IMBHoverChangeImageBtn.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/22.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBHoverChangeImageBtn.h"
#import "IMBAnimation.h"
#import "NSView+Extension.h"
@implementation IMBHoverChangeImageBtn

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
    [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:0];
}

- (void)setHoverImage:(NSString *)hoverImage withSelfImage:(NSImage *)image{
    _hoverImage = [NSImage imageNamed:hoverImage];
    _normalImage = image;
    _selfImage = image;
}

- (void)startTranfering {
    _istranferBtn = YES;
    _loadLayer = [[CALayer alloc]init];
    _loadLayer.contents = [NSImage imageNamed:@"navbar_icon_transtion_runing_circle"];
    [_loadLayer setFrame:NSMakeRect((self.frame.size.width - 44)/2 , (self.frame.size.height -44)/2 +1, 44, 44)];
    _normalImage = [NSImage imageNamed:@"navbar_icon_transtion_runing"];
    _hoverImage = [NSImage imageNamed:@"navbar_icon_transtion_runing"];
    self.image = _hoverImage;
    [self setWantsLayer:YES];
    [self.layer addSublayer:_loadLayer];
    [_loadLayer setAnchorPoint:NSMakePoint(0.51, 0.53)];
    CABasicAnimation *animation = [IMBAnimation rotation:FLT_MAX toValue:[NSNumber numberWithFloat:2*M_PI] durTimes:1.0];//[IMBAnimation moveY:2 X:[NSNumber numberWithInt:0] Y:[NSNumber numberWithInt:-40] repeatCount:1 beginTime:0 isAutoreverses:NO];
    [_loadLayer addAnimation:animation forKey:@"loadLayer"];
    [self setWantsLayer:YES];
}

- (void)endTranfering {
    _istranferBtn = NO;
    _hoverImage =[NSImage imageNamed:@"navbar_icon_transtion_hover"] ;
    _normalImage = _selfImage;
    [_loadLayer removeAllAnimations];
    [_loadLayer removeFromSuperlayer];
    [_loadLayer release];
    _loadLayer = nil;
    self.image = _normalImage;
    [self setWantsLayer:YES];
}

#pragma mark - mouseAction

- (void)mouseEntered:(NSEvent *)theEvent {
    if (_hoverImage && !_istranferBtn) {
        [self setImage:_hoverImage];
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (_hoverImage && !_istranferBtn) {
        [self setImage:_normalImage];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    
}

- (void)mouseUp:(NSEvent *)theEvent {
    [NSApp sendAction:self.action to:self.target from:self];
}

-(void)dealloc {
    [super dealloc];
    if (_loadLayer) {
        [_loadLayer release];
        _loadLayer = nil;
    }
}
@end
