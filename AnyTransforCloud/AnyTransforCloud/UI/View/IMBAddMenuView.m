//
//  IMBAddMenuView.m
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/4/22.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import "IMBAddMenuView.h"
#import "StringHelper.h"

@implementation IMBAddMenuView
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

- (void)scrollWheel:(NSEvent *)theEvent {
    
}

@end

@implementation IMBAddItem
@synthesize action = _action;
@synthesize target = _target;
@synthesize itemTag = _itemTag;

- (void)setItemTag:(int)itemTag {
    _itemTag = itemTag;
}

- (void)drawRect:(NSRect)dirtyRect {
    NSColor *bgColor = nil;
    if (_mouseType == MouseEnter) {
        bgColor = [StringHelper getColorFromString:CustomColor(@"tableView_enter_color", nil)];
    } else if (_mouseType == MouseDown) {
        bgColor = [StringHelper getColorFromString:CustomColor(@"tableView_select_color", nil)];
    }
    if (bgColor) {
        NSRect bgRect = NSMakeRect(0, 0, dirtyRect.size.width, dirtyRect.size.height);
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:bgRect];
        [bgColor set];
        [path fill];
        [path closePath];
    }
    
    //画图片
    NSImage *titleImage = nil;
    NSRect imageFrame = NSMakeRect(17, (dirtyRect.size.height - 28)/2, 28, 28);
    
    
    //画标题
    NSString *titleStr = @"";
    if (_itemTag == 1) {
        titleStr = CustomLocalizedString(@"TopControl_NewFolder", nil);
        titleImage = [NSImage imageNamed:@"new_folder"];
        
        NSRect lineRect = NSMakeRect(0, 0, dirtyRect.size.width, 1);
        NSBezierPath *linePath = [NSBezierPath bezierPathWithRect:lineRect];
        [[StringHelper getColorFromString:CustomColor(@"tableView_line_color", nil)] set];
        [linePath fill];
        [linePath closePath];
        
    } else if (_itemTag == 2) {
        titleStr = CustomLocalizedString(@"TopControl_FileUpload", nil);
        titleImage = [NSImage imageNamed:@"new_sharespace"];
        
    } else if (_itemTag == 3) {
        titleStr = CustomLocalizedString(@"TopControl_FolderUpload", nil);
        titleImage = [NSImage imageNamed:@"new_folderupload"];
        
        NSRect lineRect = NSMakeRect(0, 0, dirtyRect.size.width, 1);
        NSBezierPath *linePath = [NSBezierPath bezierPathWithRect:lineRect];
        [[StringHelper getColorFromString:CustomColor(@"tableView_line_color", nil)] set];
        [linePath fill];
        [linePath closePath];
    } else if (_itemTag == 4) {
        titleStr = CustomLocalizedString(@"TopControl_NewSync", nil);
        titleImage = [NSImage imageNamed:@"new_sync"];
        
    } else if (_itemTag == 5) {
        titleStr = CustomLocalizedString(@"TopControl_NewCloud", nil);
        titleImage = [NSImage imageNamed:@"new_cloud"];
    }
    
    [titleImage drawInRect:imageFrame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    
    //画标题
    NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:14.0];
    
    NSMutableAttributedString *attrTimeStr = [StringHelper setTextWordStyle:titleStr withFont:font withLineSpacing:0 withAlignment:NSTextAlignmentCenter withColor:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)]];
    NSRect textRect = [StringHelper calcuTextBounds:titleStr font:font];
    textRect = NSMakeRect(57, (dirtyRect.size.height - textRect.size.height)/2.0, textRect.size.width, textRect.size.height);
    [attrTimeStr drawInRect:textRect];
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
