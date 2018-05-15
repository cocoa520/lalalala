//
//  IMBTableRowView.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/25.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBTableRowView.h"
#import "StringHelper.h"
#import "IMBNotificationDefine.h"

@implementation IMBTableRowView

- (id)init {
    self = [super init];
    if (self) {
        //在弹出窗口时，屏蔽详细页面的进入状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableEnterState:) name:DISABLE_ENTER_STATE object:nil];
    }
    return self;
}

//绘制选中状态的背景
- (void)drawSelectionInRect:(NSRect)dirtyRect {
    if (self.selectionHighlightStyle != NSTableViewSelectionHighlightStyleNone) {
        NSRect selectionRect = NSMakeRect(0, 0, dirtyRect.size.width, dirtyRect.size.height);
        [[StringHelper getColorFromString:CustomColor(@"tableView_select_color", nil)] setFill];
        NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRect:selectionRect];
        [selectionPath fill];
        [selectionPath closePath];
    }
}

//绘制背景
- (void)drawBackgroundInRect:(NSRect)dirtyRect {
    [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
    NSBezierPath *bgPath = [NSBezierPath bezierPathWithRect:dirtyRect];
    [bgPath fill];
    [bgPath closePath];
    
    if (_buttonType == MouseEnter) {
        NSRect selectionRect = NSMakeRect(0, 0, dirtyRect.size.width, dirtyRect.size.height);
        [[StringHelper getColorFromString:CustomColor(@"tableView_enter_color", nil)] set];
        NSBezierPath *selectionPath = [NSBezierPath bezierPathWithRect:selectionRect];
        [selectionPath fill];
        [selectionPath closePath];
    }
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
        _trackingArea = nil;
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    if (!_isDisable) {
        if (_buttonType != MouseEnter) {
            _buttonType = MouseEnter;
            [self setNeedsDisplay:YES];
        }
    }
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (_buttonType != MouseOut) {
        _buttonType = MouseOut;
        [self setNeedsDisplay:YES];
    }
}

- (void)disableEnterState:(NSNotification *)notification {
    _isDisable = [notification.object boolValue];
}

- (void)dealloc {
    if(_trackingArea != nil) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
