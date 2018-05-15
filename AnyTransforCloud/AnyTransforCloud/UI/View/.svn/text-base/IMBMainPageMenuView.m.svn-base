//
//  IMBMainPageMenuView.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/18.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBMainPageMenuView.h"
#import "StringHelper.h"
#import "IMBCloudManager.h"

@implementation IMBMainPageMenuView
@synthesize action = _action;
@synthesize target = _target;

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

@implementation IMBMainPageItem
@synthesize action = _action;
@synthesize target = _target;
@synthesize itemTag = _itemTag;

- (void)drawRect:(NSRect)dirtyRect {
    if (_itemTag == 1) {
        NSColor *bgColor = nil;
        if (_mouseType == MouseEnter) {
            bgColor = [StringHelper getColorFromString:CustomColor(@"tableView_enter_color", nil)];
        } else if (_mouseType == MouseDown) {
            bgColor = [StringHelper getColorFromString:CustomColor(@"tableView_select_color", nil)];
        }
        if (bgColor) {
            NSRect bgRect = NSMakeRect(10, 5, dirtyRect.size.width - 20, dirtyRect.size.height - 8);
            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:bgRect xRadius:3 yRadius:3];
            [bgColor set];
            [path fill];
            [path closePath];
        }
        
        LoginAuthorizationDriveEntity *userInfoEntity = [IMBCloudManager singleton].driveManager.loginEntity;
        NSImage *headImage = nil;
        if (![StringHelper stringIsNilOrEmpty:userInfoEntity.avatar] && ![userInfoEntity.avatar isKindOfClass:[NSNull class]]) {
            NSURL *imageUrl = [NSURL URLWithString:userInfoEntity.avatar];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
            NSImage *image = [[NSImage alloc] initWithData:imageData];
            headImage = [image retain];
            [image release];
        } else {
            headImage = [[NSImage imageNamed:@"def_person"] retain];
        }
        //画图片
        NSRect imageFrame = NSMakeRect(168, 21, 34, 34);
        [headImage drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
        [headImage release];
        
        //画标题
        NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:14.0];
        NSColor *color = [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)];
        
        NSString *homePageTitle = @"";
        if (![StringHelper stringIsNilOrEmpty:userInfoEntity.nickName]) {
            homePageTitle = userInfoEntity.nickName;
        } else {
            homePageTitle = CustomLocalizedString(@"unknown_id", nil);
        }
        
        NSAttributedString *title = [StringHelper setTextWordStyle:homePageTitle withFont:font withAlignment:NSTextAlignmentCenter withLineBreakMode:NSLineBreakByTruncatingMiddle withColor:color];
        
        float width = 0;
        NSRect titleRect = [StringHelper calcuTextBounds:homePageTitle font:font];
        if (titleRect.size.width > 130) {
            width = 130;
        } else {
            width = titleRect.size.width;
        }
        NSRect drawRect = NSMakeRect(24, 39, width, titleRect.size.height);
        [title drawInRect:drawRect];
        
        //画副标题
        NSFont *font1 = [NSFont fontWithName:@"Helvetica Neue" size:12.0];
        NSColor *color1 = [StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)];
        NSString *freeSpace = [NSString stringWithFormat:CustomLocalizedString(@"AccountHomePage_FreeSize", nil),@"2GB"];
        
        NSAttributedString *title1 = [StringHelper setTextWordStyle:freeSpace withFont:font1 withAlignment:NSTextAlignmentCenter withLineBreakMode:NSLineBreakByTruncatingMiddle withColor:color1];
        
        float width1 = 0;
        NSRect titleRect1 = [StringHelper calcuTextBounds:freeSpace font:font1];
        if (titleRect1.size.width > 130) {
            width1 = 130;
        } else {
            width1 = titleRect1.size.width;
        }
        NSRect drawRect1 = NSMakeRect(24, 16, width1, titleRect1.size.height);
        [title1 drawInRect:drawRect1];
        
        NSRect lineRect = NSMakeRect(10, 0, dirtyRect.size.width - 20, 1);
        NSBezierPath *linePath = [NSBezierPath bezierPathWithRect:lineRect];
        [[StringHelper getColorFromString:CustomColor(@"text_lineColor", nil)] set];
        [linePath fill];
        [linePath closePath];
    } else {
        
        NSColor *bgColor = nil;
        if (_mouseType == MouseEnter) {
            bgColor = [StringHelper getColorFromString:CustomColor(@"tableView_enter_color", nil)];
        } else if (_mouseType == MouseDown) {
            bgColor = [StringHelper getColorFromString:CustomColor(@"tableView_select_color", nil)];
        }
        if (bgColor) {
            NSRect bgRect = NSMakeRect(10, 2, dirtyRect.size.width - 20, dirtyRect.size.height - 4);
            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:bgRect xRadius:3 yRadius:3];
            [bgColor set];
            [path fill];
            [path closePath];
        }
        
        NSString *titleStr = @"";
        if (_itemTag == 2) {
            titleStr = CustomLocalizedString(@"Menu_HomePage", nil);
        } else if (_itemTag == 3) {
            titleStr = CustomLocalizedString(@"AccountHomePage_Upgreate", nil);
            NSRect lineRect = NSMakeRect(10, 0, dirtyRect.size.width - 20, 1);
            NSBezierPath *linePath = [NSBezierPath bezierPathWithRect:lineRect];
            [[StringHelper getColorFromString:CustomColor(@"text_lineColor", nil)] set];
            [linePath fill];
            [linePath closePath];
        } else if (_itemTag == 4) {
            titleStr = CustomLocalizedString(@"Menu_Setting", nil);
        } else if (_itemTag == 5) {
            titleStr = CustomLocalizedString(@"Menu_ChangePass", nil);
        } else if (_itemTag == 6) {
            titleStr = CustomLocalizedString(@"Menu_Help", nil);
        } else if (_itemTag == 7) {
            titleStr = CustomLocalizedString(@"Menu_About", nil);
            NSRect lineRect = NSMakeRect(10, 0, dirtyRect.size.width - 20, 1);
            NSBezierPath *linePath = [NSBezierPath bezierPathWithRect:lineRect];
            [[StringHelper getColorFromString:CustomColor(@"text_lineColor", nil)] set];
            [linePath fill];
            [linePath closePath];
        } else if (_itemTag == 8) {
            titleStr = CustomLocalizedString(@"Menu_SingOut", nil);
        }
        
        //画标题
        NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:14.0];
        
        NSMutableAttributedString *attrTimeStr = [StringHelper setTextWordStyle:titleStr withFont:font withLineSpacing:0 withAlignment:NSTextAlignmentCenter withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
        NSRect textRect = [StringHelper calcuTextBounds:titleStr font:font];
        textRect = NSMakeRect(24, (dirtyRect.size.height - textRect.size.height)/2.0, textRect.size.width, textRect.size.height);
        [attrTimeStr drawInRect:textRect];
    }
}

- (void)updateTrackingAreas {
    [super updateTrackingAreas];
    if (_trackingArea == nil) {
        NSTrackingAreaOptions options =  (NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate);
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil] ;
        [self addTrackingArea:_trackingArea];
        [_trackingArea release];
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
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseType = MouseOut;
    [self setNeedsDisplay:YES];
}

@end
