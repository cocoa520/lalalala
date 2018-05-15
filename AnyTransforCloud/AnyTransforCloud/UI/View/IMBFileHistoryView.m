//
//  IMBFileHistoryView.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/24.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBFileHistoryView.h"
#import "StringHelper.h"
#import "IMBAnimation.h"
#import "IMBToolBarButton.h"

@implementation IMBFileHistoryView

- (void)dealloc {
    if (_shadow) {
        [_shadow release];
        _shadow = nil;
    }
    if (_trackingArea) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self setWantsLayer:YES];
    }
    return self;
}

- (void)setIsOpenMenu:(BOOL)isOpenMenu {
    _isOpenMenu = isOpenMenu;
    if (!_isOpenMenu) {
        [IMBAnimation animationMouseEnteredExitedWithView:self fromValue:@(-3) toValue:0 timeInterval:0.3];
    }
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    
    //投影效果
    if (_mouseType == MouseEnter || _mouseType == MouseDown || _mouseType == MouseUp || _isOpenMenu) {
        if (_shadow) {
            [_shadow release];
            _shadow = nil;
        }
        _shadow = [[NSShadow alloc] init];
        [_shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_Color", nil)]];
        [_shadow setShadowOffset:NSMakeSize(0.0, -2.0)];
        [_shadow setShadowBlurRadius:5.0];
        [_shadow set];
    }
    
    NSRect newRect = NSMakeRect(dirtyRect.origin.x + 5, dirtyRect.origin.y + 5, self.frame.size.width-10, self.frame.size.height - 10);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:3 yRadius:3];
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    [path fill];
    [path closePath];
    
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea == nil) {
        NSTrackingAreaOptions options =  (NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate);
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil] ;
    }
    [self addTrackingArea:_trackingArea];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseType = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _mouseType = MouseUp;
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
    if (inner&&theEvent.clickCount <= 1) {
        if (self.action && self.target) {
            [NSApp sendAction:self.action to:self.target from:self];
        }else {
            [super mouseUp:theEvent];
        }
    }
    [self setNeedsDisplay:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseType = MouseEnter;
    [self setNeedsDisplay:YES];
    [IMBAnimation animationMouseEnteredExitedWithView:self fromValue:0 toValue:@(-3) timeInterval:0.3];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseType = MouseOut;
    [self setNeedsDisplay:YES];
    if (!_isOpenMenu) {
        [IMBAnimation animationMouseEnteredExitedWithView:self fromValue:@(-3) toValue:0 timeInterval:0.3];
    }
}

@end

@implementation IMBFileItemView

- (void)awakeFromNib {
    NSColor *color = [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)];
    [_titleTextField setTextColor:color];
    color = [StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)];
    [_subTextField setTextColor:color];
    
    _mouseType = MouseOut;
}

- (void)setBottomBtn {
    for (NSView *view in self.subviews) {
        if ([view isKindOfClass:[IMBToolBarButton class]]) {
            IMBToolBarButton *btn = (IMBToolBarButton *)view;
            if (btn.tag == 1001 && !btn.mouseExitedImage) {
                [btn setMouseExitedImg:[NSImage imageNamed:@"list_star"] withMouseEnterImg:[NSImage imageNamed:@"list_star2"] withMouseDownImage:[NSImage imageNamed:@"list_star3"] withMouseDisableImage:[NSImage imageNamed:@"list_star4"]];
                [btn setToolTip:CustomLocalizedString(@"Common_id_1", nil)];
            }else if (btn.tag == 1002 && !btn.mouseExitedImage) {
                [btn setMouseExitedImg:[NSImage imageNamed:@"list_share"] withMouseEnterImg:[NSImage imageNamed:@"list_share2"] withMouseDownImage:[NSImage imageNamed:@"list_share3"] withMouseDisableImage:[NSImage imageNamed:@"list_share4"]];
                [btn setToolTip:CustomLocalizedString(@"Common_id_1", nil)];
            }else if (btn.tag == 1003 && !btn.mouseExitedImage) {
                [btn setMouseExitedImg:[NSImage imageNamed:@"list_sync"] withMouseEnterImg:[NSImage imageNamed:@"list_sync2"] withMouseDownImage:[NSImage imageNamed:@"list_sync3"] withMouseDisableImage:[NSImage imageNamed:@"list_sync4"]];
                [btn setToolTip:CustomLocalizedString(@"Common_id_1", nil)];
            }else if (btn.tag == 1004 && !btn.mouseExitedImage) {
                [btn setMouseExitedImg:[NSImage imageNamed:@"list_more"] withMouseEnterImg:[NSImage imageNamed:@"list_more2"] withMouseDownImage:[NSImage imageNamed:@"list_more3"] withMouseDisableImage:[NSImage imageNamed:@"list_more4"]];
                [btn setToolTip:CustomLocalizedString(@"Common_id_1", nil)];
            }
        }
    }
}

- (void)dealloc {
    if (_trackingArea) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

- (void)setIsOpenMenu:(BOOL)isOpenMenu {
    _isOpenMenu = isOpenMenu;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    BOOL loadBtn = YES;
    for (NSView *view in self.subviews) {
        if ([view isKindOfClass:[NSTextField class]] && view.tag == 99) {
            if ([[(NSTextField *)view stringValue] isEqualToString:@"moreHistoryID"]) {
                loadBtn = NO;
                break;
            }
        }
    }
    if (loadBtn) {
        //画底部按钮
        [self setBottomBtn];
        if (_mouseType == MouseEnter || _mouseType == MouseDown || _mouseType == MouseUp || _isOpenMenu) {
            NSRect pathRect = NSMakeRect(0, 0, dirtyRect.size.width, 34);
            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:pathRect xRadius:3 yRadius:3];
            [[StringHelper getColorFromString:CustomColor(@"AddCloud_bg_AnimationColor", nil)] set];
            [path fill];
            [path closePath];
            
            pathRect = NSMakeRect(0, 4, dirtyRect.size.width, 30);
            NSBezierPath *path1 = [NSBezierPath bezierPathWithRect:pathRect];
            [[StringHelper getColorFromString:CustomColor(@"AddCloud_bg_AnimationColor", nil)] set];
            [path1 fill];
            [path1 closePath];
            
            for (NSView *view in self.subviews) {
                if ([view isKindOfClass:[NSTextField class]] && view.tag == 100) {
                    [view setHidden:YES];
                }else if ([view isKindOfClass:[IMBToolBarButton class]]) {
                    [view setHidden:NO];
                }
            }
        } else {
            for (NSView *view in self.subviews) {
                if ([view isKindOfClass:[NSTextField class]] && view.tag == 100) {
                    [view setHidden:NO];
                }else if ([view isKindOfClass:[IMBToolBarButton class]]) {
                    [view setHidden:YES];
                }
            }
        }
    }
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea == nil) {
        NSTrackingAreaOptions options =  (NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate);
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil] ;
    }
    [self addTrackingArea:_trackingArea];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseType = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _mouseType = MouseUp;
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
    if (inner&&theEvent.clickCount <=1) {
        if (self.action && self.target) {
            [NSApp sendAction:self.action to:self.target from:self];
        }else {
            [super mouseUp:theEvent];
        }
    }
    [self setNeedsDisplay:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseType = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseType = MouseOut;
    [self setNeedsDisplay:YES];
}

@end