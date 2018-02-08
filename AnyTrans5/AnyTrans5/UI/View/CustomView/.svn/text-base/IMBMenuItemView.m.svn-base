//
//  IMBMenuItemView.m
//  AnyTrans
//
//  Created by LuoLei on 16-8-5.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "IMBMenuItemView.h"
#import "SystemHelper.h"
#import "NSString+Category.h"
@implementation IMBMenuItemView
@synthesize action = _action;
@synthesize target = _target;
@synthesize menuItem = _menuItem;
@synthesize isMouseEnter = _isMouseEnter;
@synthesize enable= _enable;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _mouseEnterColor = [[NSColor colorWithDeviceRed:218.0/255 green:236.0/255 blue:250.0/255 alpha:1.0] retain];
        _enable = NO;
    }
    return self;
}


- (void)setEnable:(BOOL)enable
{
    if (_enable != enable) {
        _enable = enable;
        [self setNeedsDisplay:YES];
    }
}

-(void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (_trackingArea == nil) {
        NSTrackingAreaOptions options =   ( NSTrackingActiveAlways  | NSTrackingCursorUpdate|NSTrackingMouseEnteredAndExited);
        _trackingArea = [[NSTrackingArea alloc]initWithRect:self.bounds options:options owner:self userInfo:nil];
        [self addTrackingArea:_trackingArea];
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [super mouseUp:theEvent];
    if (_enable) {
        [NSApp sendAction:self.action to:self.target from:_menuItem];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent
{
   
    NSPoint mousePt = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    BOOL overClose = NSMouseInRect(mousePt,[self bounds], [self isFlipped]);
    if (overClose) {
        _isMouseEnter= YES;
    }else{
        _isMouseEnter = NO;
    }
    [self setNeedsDisplay:YES];
    [super mouseEntered:theEvent];
}


- (void)mouseExited:(NSEvent *)theEvent
{
    if ([_menuItem.submenu.itemArray count] == 0) {
        _isMouseEnter= NO;
    }
    [self setNeedsDisplay:YES];
    [super mouseExited:theEvent];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    if (_isMouseEnter&&_enable) {
        [_mouseEnterColor setFill];
    }else{
        if ([[SystemHelper getSystemLastNumberString] isVersionMajorEqual:@"10"]) {
            [[NSColor clearColor] setFill];
        }else {
            [[NSColor whiteColor] setFill];
        }
    }
    NSRectFill(dirtyRect);
    NSMutableParagraphStyle *textParagraph = [[NSMutableParagraphStyle alloc] init];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
    [textParagraph setAlignment:NSRightTextAlignment];
    if (_enable) {
        [_iconImage drawInRect:NSMakeRect(14, ceilf((NSHeight(self.frame) - 20)/2.0 - 1), _iconImage.size.width, _iconImage.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        [_triangleImage drawInRect:NSMakeRect(NSWidth(self.frame)-14-6, ceilf((NSHeight(self.frame) - 8)/2.0), _triangleImage.size.width, _triangleImage.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];

        NSAttributedString *title = [[NSAttributedString alloc] initWithString:(_title?_title:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:12.0], NSFontAttributeName,[NSColor blackColor],NSForegroundColorAttributeName,nil]];
        NSRect trect = NSMakeRect(42, ceilf((NSHeight(self.frame) - 18)/2.0), 100, 18);
        [title drawInRect:trect];
        if (_countText != nil) {
            NSAttributedString *count = [[NSAttributedString alloc] initWithString:(_countText?_countText:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:12.0], NSFontAttributeName,textParagraph,NSParagraphStyleAttributeName,[NSColor blackColor],NSForegroundColorAttributeName,nil]];
            NSRect crect = NSMakeRect(NSWidth(self.frame)-14-50, ceilf((NSHeight(self.frame) - 18)/2.0), 50, 18);
            [count drawInRect:crect];
            [count release];
        }
        [title release];

    }else{
        [_iconImage drawInRect:NSMakeRect(14, ceilf((NSHeight(self.frame) - 20)/2.0 - 1), _iconImage.size.width, _iconImage.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.5];
        [_triangleImage drawInRect:NSMakeRect(NSWidth(self.frame)-14-6, ceilf((NSHeight(self.frame) - 8)/2.0), _triangleImage.size.width, _triangleImage.size.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:0.5];

        NSAttributedString *title = [[NSAttributedString alloc] initWithString:(_title?_title:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:12.0], NSFontAttributeName,[NSColor grayColor],NSForegroundColorAttributeName,nil]];
        NSRect trect = NSMakeRect(42, ceilf((NSHeight(self.frame) - 18)/2.0), 100, 18);
        [title drawInRect:trect];
        if (_countText != nil) {
            NSAttributedString *count = [[NSAttributedString alloc] initWithString:(_countText?_countText:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:12.0], NSFontAttributeName,[NSColor grayColor],NSForegroundColorAttributeName,textParagraph,NSParagraphStyleAttributeName,nil]];
            NSRect crect = NSMakeRect(NSWidth(self.frame)-14-50, ceilf((NSHeight(self.frame) - 18)/2.0), 50, 18);
            [count drawInRect:crect];
            [count release];
        }
        [title release];
    }
}


#pragma mark - setter
- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        [_title release];
        _title = [title retain];
        [self setNeedsDisplay:YES];
    }
}
- (void)setIcon:(NSImage *)image
{
    if (_iconImage != image) {
        [_iconImage release];
        _iconImage = [image retain];
        [self setNeedsDisplay:YES];
    }
}
- (void)setCount:(NSString *)count
{
    if (_countText != count) {
        [_countText release];
        _countText = [count retain];
        [self setNeedsDisplay:YES];
    }
}
- (void)setTriangle:(NSImage *)image
{
    if (_triangleImage != image) {
        [_triangleImage release];
        _triangleImage = [image retain];
        [self setNeedsDisplay:YES];
    }
}
- (void)dealloc
{
    [_triangleImage release],_triangleImage = nil;
    [_iconImage release],_iconImage = nil;
    [_mouseEnterColor release],_mouseEnterColor = nil;
    [_trackingArea release],_trackingArea = nil;
    [_title release],_title = nil;
    [_countText release],_countText = nil;
    [super dealloc];
}
@end
