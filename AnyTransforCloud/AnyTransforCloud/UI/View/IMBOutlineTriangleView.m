//
//  IMBOutlineTriangleView.m
//  AnyTransforCloud
//
//  Created by hym on 01/05/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBOutlineTriangleView.h"
#import "IMBAnimation.h"
@implementation IMBOutlineTriangleView
@synthesize action = _action;
@synthesize target = _target;
@synthesize showType = _showType;


- (void)awakeFromNib {
    [self setWantsLayer:YES];
    _loadImageLayer = [[CALayer alloc] init];
    [self.layer addSublayer:_loadImageLayer];
    NSImage *image = [NSImage imageNamed:@"detail_loading"];
    _loadImageLayer.contents = [NSImage imageNamed:@"detail_loading"];
    _loadImageLayer.frame = NSMakeRect(ceil((self.bounds.size.width - image.size.width) / 2.0), ceil((self.bounds.size.height - image.size.height) / 2.0), image.size.width, image.size.height);
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if (_showType == expandType) {
        [_loadImageLayer removeFromSuperlayer];
        NSImage *image = [NSImage imageNamed:@"detail_arrow2"];
        [image drawInRect:NSMakeRect(ceil((self.bounds.size.width - image.size.width) / 2.0), ceil((self.bounds.size.height - image.size.height) / 2.0), image.size.width, image.size.height) fromRect:NSZeroRect operation:NSCompositeDestinationOver fraction:1.0];
    }else if (_showType == collapseType) {
        [_loadImageLayer removeFromSuperlayer];
        NSImage *image = [NSImage imageNamed:@"detail_arrow1"];
        [image drawInRect:NSMakeRect(ceil((self.bounds.size.width - image.size.width) / 2.0), ceil((self.bounds.size.height - image.size.height) / 2.0), image.size.width, image.size.height) fromRect:NSZeroRect operation:NSCompositeDestinationOver fraction:1.0];
    }else if (_showType == nodataType) {
        [_loadImageLayer removeFromSuperlayer];
    }else {
        [self.layer addSublayer:_loadImageLayer];
        [_loadImageLayer removeAllAnimations];
        CAAnimation *animation = [IMBAnimation rotation:NSIntegerMax toValue:@(-M_PI) durTimes:1.5];
        [_loadImageLayer addAnimation:animation forKey:@"rotation"];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    
}

- (void)mouseUp:(NSEvent *)theEvent {
    [super mouseUp:theEvent];
    if (_showType != loadingType) {
       [NSApp sendAction:self.action to:self.target from:self];
    }
}

- (void)dealloc {
    if (_loadImageLayer) {
        [_loadImageLayer release];
        _loadImageLayer = nil;
    }

    [super dealloc];
    
}

@end
