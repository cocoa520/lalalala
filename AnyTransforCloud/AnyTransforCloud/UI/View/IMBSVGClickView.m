//
//  IMBSVGClickView.m
//  AnyTransforCloud
//
//  Created by hym on 24/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBSVGClickView.h"
#import "SVGKit.h"
@implementation IMBSVGClickView

- (void)setSVGImageName:(NSString *)svgName {
    if (![svgName.pathExtension containsString:@"svg"]) {
        svgName = [svgName stringByAppendingString:@".svg"];
    }
    SVGKImage *image =[SVGKImage imageNamed:svgName];
    NSSize size;
    if ([image hasSize]) {
        size = image.size;
    }else {
        size = NSMakeSize(32, 32);
    }
    SVGKFastImageView *imageView = [[SVGKFastImageView alloc] initWithSVGKImage:image];
    imageView.frame = NSMakeRect(ceil((self.frame.size.width - size.width)/2.0), ceil((self.frame.size.height - size.height)/2.0), size.width, size.height);
    [self addSubview:imageView];
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea)
    {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited| NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];
    _mouseState = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [super mouseEntered:theEvent];
    _mouseState = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [NSApp sendAction:self.action to:self.target from:self];
    _mouseState = MouseUp;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [super mouseExited:theEvent];
    _mouseState = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)dealloc {
    if (_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

@end
