//
//  IMBAccountItemView.m
//  AnyTransforCloud
//
//  Created by hym on 16/04/2018.
//  Copyright © 2018 IMB. All rights reserved.
//

#import "IMBAccountItemView.h"
#import "StringHelper.h"
#import "IMBCurrencySvgButton.h"
@implementation IMBAccountItemView
@synthesize action = _action;
@synthesize target = _target;
@synthesize removeAction = _removeAction;
@synthesize accountEntity = _accountEntity;


- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea)
    {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)setAccountEntity:(IMBAccountEntity *)accountEntity {
    if (_accountEntity) {
        [_accountEntity release];
        _accountEntity = nil;
    }
    _accountEntity = [accountEntity retain];
    
    IMBCurrencySvgButton *signOutBtn = [[IMBCurrencySvgButton alloc] initWithFrame:NSMakeRect(self.bounds.size.width - 50, (self.frame.size.height - 40)/ 2.0, 40, 40)];
    [signOutBtn setSvgFileName:@"menu_close" withUseFillColor:NO withSVGSize:NSMakeSize(12, 12) withEnterColor:[StringHelper getColorFromString:CustomColor(@"text_click_enterColor", nil)] withOutColor:[StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)] withDownColor:[StringHelper getColorFromString:CustomColor(@"text_click_downColor", nil)]];
    [signOutBtn setTarget:self];
    [signOutBtn setAction:@selector(removeAccout)];
    [self addSubview:signOutBtn];
    [signOutBtn release];
}

- (IMBAccountEntity *)accountEntity {
    return _accountEntity;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    if (_buttonType == MouseEnter || _buttonType == MouseUp) {
        [[StringHelper getColorFromString:CustomColor(@"tableView_enter_color", nil)] setFill];
        [path fill];
    }else if (_buttonType == MouseDown) {
        [[StringHelper getColorFromString:CustomColor(@"tableView_select_color", nil)] setFill];
        [path fill];
    }
    if (![StringHelper stringIsNilOrEmpty:_accountEntity.account]) {
        NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:_accountEntity.account];
        [as addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0,as.length)];
        [as setAlignment:NSLeftTextAlignment range:NSMakeRange(0,as.length)];
        [as addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)] range:NSMakeRange(0,as.length)];
        [as drawWithRect:NSMakeRect(dirtyRect.origin.x + 10, dirtyRect.origin.y + 16, dirtyRect.size.width - 12, dirtyRect.size.height - 10) options:NSStringDrawingTruncatesLastVisibleLine];
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    _buttonType = MouseUp;
    if (_target != nil && _action != nil) {
        if ([_target respondsToSelector:_action]) {
            [_target performSelector:_action withObject:_accountEntity];
        }
    }
    [self setNeedsDisplay:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    _buttonType = MouseEnter;
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    _buttonType = MouseDown;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _buttonType = MouseOut;
    [self setNeedsDisplay:YES];
}

- (void)removeAccout {
    [self.target performSelector:_removeAction withObject:_accountEntity];
}

- (void)dealloc {
    if (_trackingArea) {
        [_trackingArea release];
        _trackingArea = nil;
    }
    if (_accountEntity) {
        [_accountEntity release];
        _accountEntity = nil;
    }
    [super dealloc];
}
@end
