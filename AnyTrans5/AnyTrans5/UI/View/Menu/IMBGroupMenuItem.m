//
//  IMBGroupMenuItem.m
//  AnyTrans
//
//  Created by smz on 17/7/27.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBGroupMenuItem.h"
#import "StringHelper.h"
#import "NSString+Compare.h"
#import "IMBHelper.h"

@implementation IMBGroupMenuItem
@synthesize action = _action;
@synthesize target = _target;
@synthesize menuItem = _menuItem;
@synthesize isMouseEnter = _isMouseEnter;
@synthesize groupColor = _groupColor;
@synthesize tag = _tag;
@synthesize isThis = _isThis;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _mouseEnterColor = [[NSColor colorWithDeviceRed:218.0/255 green:236.0/255 blue:250.0/255 alpha:1.0] retain];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
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
    [NSApp sendAction:self.action to:self.target from:_menuItem];
    
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
    [self setWantsLayer:YES];
    if (_isMouseEnter) {
        [_mouseEnterColor setFill];
    }else{
        
        [[NSColor clearColor] setFill];
        
    }
    
    NSRectFill(dirtyRect);
    NSMutableParagraphStyle *textParagraph = [[NSMutableParagraphStyle alloc] init];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
    [textParagraph setAlignment:NSLeftTextAlignment];
        
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:(_title?_title:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:12.0], NSFontAttributeName,[NSColor blackColor],NSForegroundColorAttributeName,textParagraph,NSParagraphStyleAttributeName,nil]];
    float width = 0;
    NSRect titleRect = [IMBHelper calcuTextBounds:title.string fontSize:12.0];
    if (titleRect.size.width > 135) {
        width = 135;
    } else {
        width = titleRect.size.width;
    }
    NSRect trect = NSMakeRect(45,(self.bounds.size.height  - 18)/2.0 + 1,width, 18);
    [title drawInRect:trect];
    [title release];
    [textParagraph release];
    
    if (_isThis) {
        
        NSImage *image = [NSImage imageNamed:@"calendar_select"];
        NSRect iRect = NSMakeRect(10,(self.bounds.size.height  - 12)/2.0,14, 12);
        [image drawInRect:iRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    }
    
    if (_shapeLayer != nil) {
        [_shapeLayer removeFromSuperlayer];
        [_shapeLayer release];
        _shapeLayer = nil;
    }
    _shapeLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef ref = CGPathCreateMutable();
    CGPathAddEllipseInRect(ref, NULL, CGRectMake(27,(self.bounds.size.height - 10)/2.0,10,10));
    _shapeLayer.frame = self.bounds;
    _shapeLayer.path = ref;
    _shapeLayer.fillColor = _groupColor.CGColor;
    [self.layer addSublayer:_shapeLayer];
    CGPathRelease(ref);
    
    
}

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        [_title release];
        _title = [title retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)setGroupColor:(NSColor *)groupColor {
    if (_groupColor != groupColor) {
        [_groupColor release];
        _groupColor = [groupColor retain];
        [self setNeedsDisplay:YES];
    }
}

- (void)dealloc
{
    [_mouseEnterColor release],_mouseEnterColor = nil;
    [_trackingArea release],_trackingArea = nil;
    [_title release],_title = nil;
    [_groupColor release],_groupColor = nil;
    [_shapeLayer release],_shapeLayer = nil;
    [super dealloc];
}

@end
