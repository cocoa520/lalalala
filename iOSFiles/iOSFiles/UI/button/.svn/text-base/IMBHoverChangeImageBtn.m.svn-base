//
//  IMBHoverChangeImageBtn.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/22.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBHoverChangeImageBtn.h"

@implementation IMBHoverChangeImageBtn

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
    [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:0];
}

- (void)setHoverImage:(NSString *)hoverImage {
    _hoverImage = [NSImage imageNamed:hoverImage];
    _normalImage = self.image;
}

#pragma mark - mouseAction

- (void)mouseEntered:(NSEvent *)theEvent {
    if (_hoverImage) {
        [self setImage:_hoverImage];
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (_hoverImage) {
        [self setImage:_normalImage];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    
}

- (void)mouseUp:(NSEvent *)theEvent {
    [NSApp sendAction:self.action to:self.target from:self];
}
@end
