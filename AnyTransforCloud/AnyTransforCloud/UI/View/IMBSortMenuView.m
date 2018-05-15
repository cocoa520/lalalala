//
//  IMBSortMenuView.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/5/2.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBSortMenuView.h"
#import "StringHelper.h"
#import "IMBAnimation.h"

@implementation IMBSortMenuView

- (void)dealloc {
    if (_shadow) {
        [_shadow release];
        _shadow = nil;
    }
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    if (_shadow) {
        [_shadow release];
        _shadow = nil;
    }
    _shadow = [[NSShadow alloc] init];
    [_shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"shadow_deepColor", nil)]];
    [_shadow setShadowOffset:NSMakeSize(0.0, 0.0)];
    [_shadow setShadowBlurRadius:5.0];
    [_shadow set];
    NSRect newRect = NSMakeRect(dirtyRect.origin.x + 5, dirtyRect.origin.y + 5, self.frame.size.width-10, self.frame.size.height - 10);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:3 yRadius:3];
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    [path fill];
    [path closePath];
}

@end

@implementation IMBSortItem

- (void)dealloc {
    if (_trackingArea) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [super dealloc];
}

- (void)setItemTag:(int)itemTag {
    _itemTag = itemTag;
    _mouseType = MouseOut;
}

- (void)drawRect:(NSRect)dirtyRect {
    
    NSColor *titleColor = nil;
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    if (_mouseType == MouseEnter || _mouseType == MouseUp) {
        
        [[StringHelper getColorFromString:CustomColor(@"tableView_enter_color", nil)] set];
        titleColor = [StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)];
    }else if (_mouseType == MouseDown) {
        
        [[StringHelper getColorFromString:CustomColor(@"tableView_select_color", nil)] set];
        titleColor = [StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)];
    }else {
        
        [[NSColor clearColor] set];
        titleColor = [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)];
    }
    [path fill];
    [path closePath];
    
    //画标题
    NSString *titleStr = @"";
    if (_itemTag == 1) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_17", nil);
    } else if (_itemTag == 2) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_18", nil);
        NSRect lineRect = NSMakeRect(10, 0, dirtyRect.size.width - 20, 1);
        NSBezierPath *linePath = [NSBezierPath bezierPathWithRect:lineRect];
        [[StringHelper getColorFromString:CustomColor(@"text_lineColor", nil)] set];
        [linePath fill];
        [linePath closePath];
    } else if (_itemTag == 3) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_19", nil);
    } else if (_itemTag == 4) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_20", nil);
    } else if (_itemTag == 5) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_21", nil);
    }
    NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:13.0];
    NSRect textRect = [StringHelper calcuTextBounds:titleStr font:font];
    textRect = NSMakeRect(20, (dirtyRect.size.height - textRect.size.height)/2.0, textRect.size.width, textRect.size.height);
    
    NSAttributedString *attrTimeStr = [StringHelper setTextWordStyle:titleStr withFont:font withAlignment:NSTextAlignmentLeft withLineBreakMode:NSLineBreakByTruncatingTail withColor:titleColor];
    [attrTimeStr drawInRect:textRect];
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea == nil) {
        NSTrackingAreaOptions options =  (NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate);
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil] ;
        [self addTrackingArea:_trackingArea];
    }
}

- (void)mouseDown:(NSEvent *)theEvent {
    _mouseType = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent {
    _mouseType = MouseUp;
    [self setNeedsDisplay:YES];
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    BOOL inner = NSMouseInRect(point, [self bounds], [self isFlipped]);
    if (inner&&theEvent.clickCount ==1) {
        [NSApp sendAction:self.action to:self.target from:self];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _mouseType = MouseEnter;
    [self setNeedsDisplay:YES];
    //    [self setWantsLayer:YES];
    //    [self.layer removeAllAnimations];
    //    CABasicAnimation *animation = [IMBAnimation moveX:0.3 X:@3 repeatCount:0 beginTime:0.0];
    //    [self.layer addAnimation:animation forKey:@"2"];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseType = MouseOut;
    [self setNeedsDisplay:YES];
    //    [self setWantsLayer:YES];
    //    CABasicAnimation *animation = [IMBAnimation moveX:0.3 X:@0 repeatCount:0 beginTime:0.0];
    //    [self.layer addAnimation:animation forKey:@"1"];
}

@end
