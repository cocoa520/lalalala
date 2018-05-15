//
//  IMBMoreMenuView.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/23.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBMoreMenuView.h"
#import "StringHelper.h"
#import "IMBAnimation.h"

@implementation IMBMoreMenuView
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

@implementation IMBMoreItem
@synthesize action = _action;
@synthesize target = _target;
@synthesize itemTag = _itemTag;

- (void)setItemTag:(int)itemTag {
    _itemTag = itemTag;
}

- (void)drawRect:(NSRect)dirtyRect {
    if (_actionType == switchAction) {
        return;
    }
    
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
    
    //画图片
    NSRect imageFrame = NSMakeRect(16, (dirtyRect.size.height - 24)/2, 36, 24);
    NSImage *titleImage = [self getMenuImageWithActionTypeEnum:_actionType withMouseType:_mouseType];
    [titleImage drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    
    //画标题
    NSString *titleStr = @"";
    if (_actionType == downloadAction) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_2", nil);
    
    } else if (_actionType == copyAction) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_9", nil);
        
    } else if (_actionType == renameAction) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_5", nil);
        
    } else if (_actionType == moveAction) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_14", nil);
        
    } else if (_actionType == deleteAction) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_4", nil);
        
    } else if (_actionType == infoAction) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_15", nil);
        
    } else if (_actionType == syncAction) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_11", nil);
        
    }  else if (_actionType == shareAction) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_12", nil);
        
    } else if (_actionType == starAction) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_13", nil);
        
    } else if (_actionType == refreshAction) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_6", nil);
        
    } else if (_actionType == createFolder) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_7", nil);
        
    } else if (_actionType == uploadAction) {
        titleStr = CustomLocalizedString(@"Mouse_Right_Menu_3", nil);
        
    }
    
    NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:14.0];
    NSRect textRect = [StringHelper calcuTextBounds:titleStr font:font];
    textRect = NSMakeRect(60, (dirtyRect.size.height - textRect.size.height)/2.0, textRect.size.width, textRect.size.height);
    
    NSMutableAttributedString *attrTimeStr = [StringHelper setTextWordStyle:titleStr withFont:font withLineSpacing:0 withAlignment:NSTextAlignmentCenter withColor:titleColor];
    [attrTimeStr drawInRect:textRect];
}

- (NSImage *)getMenuImageWithActionTypeEnum:(ActionTypeEnum)actionType withMouseType:(MouseStatusEnum)mouseType {
    NSImage *menuImage = nil;
    if (actionType == downloadAction) {
        menuImage = [NSImage imageNamed:@"toolbar_download"];
        if (mouseType == MouseEnter || mouseType == MouseUp) {
            menuImage = [NSImage imageNamed:@"toolbar_download2"];
        } else if (mouseType == MouseDown) {
            menuImage = [NSImage imageNamed:@"toolbar_download3"];
        }
        
    } else if (actionType == copyAction) {
        menuImage = [NSImage imageNamed:@"toolbar_copy"];
        if (mouseType == MouseEnter || mouseType == MouseUp) {
            menuImage = [NSImage imageNamed:@"toolbar_copy2"];
        } else if (mouseType == MouseDown) {
            menuImage = [NSImage imageNamed:@"toolbar_copy3"];
        }
        
    } else if (actionType == renameAction) {
        menuImage = [NSImage imageNamed:@"toolbar_rename"];
        if (mouseType == MouseEnter || mouseType == MouseUp) {
            menuImage = [NSImage imageNamed:@"toolbar_rename2"];
        } else if (mouseType == MouseDown) {
            menuImage = [NSImage imageNamed:@"toolbar_rename3"];
        }
        
    } else if (actionType == moveAction) {
        menuImage = [NSImage imageNamed:@"toolbar_move"];
        if (mouseType == MouseEnter || mouseType == MouseUp) {
            menuImage = [NSImage imageNamed:@"toolbar_move2"];
        } else if (mouseType == MouseDown) {
            menuImage = [NSImage imageNamed:@"toolbar_move3"];
        }
        
    } else if (actionType == deleteAction) {
        menuImage = [NSImage imageNamed:@"toolbar_delete"];
        if (mouseType == MouseEnter || mouseType == MouseUp) {
            menuImage = [NSImage imageNamed:@"toolbar_delete2"];
        } else if (mouseType == MouseDown) {
            menuImage = [NSImage imageNamed:@"toolbar_delete3"];
        }
        
    } else if (actionType == infoAction) {
        menuImage = [NSImage imageNamed:@"toolbar_info"];
        if (mouseType == MouseEnter || mouseType == MouseUp) {
            menuImage = [NSImage imageNamed:@"toolbar_info2"];
        } else if (mouseType == MouseDown) {
            menuImage = [NSImage imageNamed:@"toolbar_info3"];
        }
        
    } else if (actionType == syncAction) {
        menuImage = [NSImage imageNamed:@"toolbar_sync"];
        if (mouseType == MouseEnter || mouseType == MouseUp) {
            menuImage = [NSImage imageNamed:@"toolbar_sync2"];
        } else if (mouseType == MouseDown) {
            menuImage = [NSImage imageNamed:@"toolbar_sync3"];
        }
        
    } else if (_actionType == shareAction) {
        menuImage = [NSImage imageNamed:@"toolbar_share"];
        if (mouseType == MouseEnter || mouseType == MouseUp) {
            menuImage = [NSImage imageNamed:@"toolbar_share2"];
        } else if (mouseType == MouseDown) {
            menuImage = [NSImage imageNamed:@"toolbar_share3"];
        }
        
    } else if (_actionType == starAction) {
        menuImage = [NSImage imageNamed:@"toolbar_star"];
        if (mouseType == MouseEnter || mouseType == MouseUp) {
            menuImage = [NSImage imageNamed:@"toolbar_star2"];
        } else if (mouseType == MouseDown) {
            menuImage = [NSImage imageNamed:@"toolbar_star3"];
        }
        
    } else if (_actionType == refreshAction) {
        menuImage = [NSImage imageNamed:@"toolbar_refresh"];
        if (mouseType == MouseEnter || mouseType == MouseUp) {
            menuImage = [NSImage imageNamed:@"toolbar_refresh2"];
        } else if (mouseType == MouseDown) {
            menuImage = [NSImage imageNamed:@"toolbar_refresh3"];
        }
        
    } else if (_actionType == createFolder) {
        menuImage = [NSImage imageNamed:@"toolbar_newfolder"];
        if (mouseType == MouseEnter || mouseType == MouseUp) {
            menuImage = [NSImage imageNamed:@"toolbar_newfolder2"];
        } else if (mouseType == MouseDown) {
            menuImage = [NSImage imageNamed:@"toolbar_newfolder3"];
        }
        
    } else if (_actionType == uploadAction) {
        menuImage = [NSImage imageNamed:@"toolbar_add"];
        if (mouseType == MouseEnter || mouseType == MouseUp) {
            menuImage = [NSImage imageNamed:@"toolbar_add2"];
        } else if (mouseType == MouseDown) {
            menuImage = [NSImage imageNamed:@"toolbar_add3"];
        }
        
    }
    return menuImage;
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
    [self setWantsLayer:YES];
    [self.layer removeAllAnimations];
    CABasicAnimation *animation = [IMBAnimation moveX:0.3 X:@3 repeatCount:0 beginTime:0.0];
    [self.layer addAnimation:animation forKey:@"2"];
}

- (void)mouseExited:(NSEvent *)theEvent {
    _mouseType = MouseOut;
    [self setNeedsDisplay:YES];
    [self setWantsLayer:YES];
    CABasicAnimation *animation = [IMBAnimation moveX:0.3 X:@0 repeatCount:0 beginTime:0.0];
    [self.layer addAnimation:animation forKey:@"1"];
}

@end
