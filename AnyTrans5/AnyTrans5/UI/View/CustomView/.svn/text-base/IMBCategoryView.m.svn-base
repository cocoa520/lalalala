//
//  IMBCategoryView.m
//  iMobieTrans
//
//  Created by Pallas on 7/30/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBCategoryView.h"
#import "IMBNotificationDefine.h"
#import "StringHelper.h"
@implementation IMBCategoryView
@synthesize delegate = _delegate;
@synthesize toolTip = _toolTip;
@synthesize isSelected = _isSelected;
@synthesize isEntered = _isEntered;
@synthesize categoryName = _categoryName;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _delegate = nil;
        _categoryName = nil;
        _toolTip = [[NSString alloc] initWithString:@""];
        _hasIdentify = NO;
        _isSelected = NO;
    }
    return self;
}

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

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
    if (!_hasIdentify) {
        [self getCategoryName];
        
        if (_hasIdentify && ![StringHelper stringIsNilOrEmpty:_categoryName]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:COLLECTION_ITEM_CREATED object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_categoryName, @"CategoryName", nil]];
        }
    }
    
    if (self.isSelected) {
        NSBezierPath *bezier = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
        NSColor *redCol = [StringHelper getColorFromString:CustomColor(@"category_enterColor", nil)];
        [redCol set];
        [bezier fill];
    }else if (_isEntered ) {
        NSBezierPath *bezier = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
        NSColor *redCol = [StringHelper getColorFromString:CustomColor(@"category_enterColor", nil)];
        [redCol set];
        [bezier fill];
    }
    if (_isDown ) {
        NSBezierPath *bezier = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:3 yRadius:3];
        NSColor *redCol = [StringHelper getColorFromString:CustomColor(@"category_downColor", nil)];
        [redCol set];
        [bezier fill];
    }

}

- (void)mouseEntered:(NSEvent *)theEvent {
    if (!_hasIdentify) {
        [self getCategoryName];
    }
    
    if (_hasIdentify && ![StringHelper stringIsNilOrEmpty:_categoryName]) {
        int64_t delayInSeconds = 0.00005;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSPoint localPoint = [self convertPoint:[[self window] convertScreenToBase:[NSEvent mouseLocation]] fromView:nil];
            BOOL mouseInside = NSPointInRect(localPoint, [self bounds]);
            if (mouseInside) {
                _isEntered = YES;
                [self setNeedsDisplay:YES];
                if (self.delegate && [self.delegate respondsToSelector:@selector(showToolTip:withToolTip:)]) {
                    [self.delegate showToolTip:self withToolTip:self.toolTip];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(mouseOnCategory:withObject:)]) {
                    [self.delegate mouseOnCategory:self withObject:_categoryName];
                }
            }
        });
    }
}

- (void)setToolTip:(NSString *)toolTip{
    if (![_toolTip isEqualToString:toolTip]) {
        if (_toolTip != nil) {
            [_toolTip release];
            _toolTip = nil;
        }
        _toolTip = [toolTip retain];
    }
}

-(void)mouseDown:(NSEvent *)theEvent{
    _isDown = YES;
     [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    if (_isEntered) {
        _isEntered = NO;
        _isDown = NO;
        [self setNeedsDisplay:YES];
        if (!_hasIdentify) {
            [self getCategoryName];
        }
        
        if (_hasIdentify && ![StringHelper stringIsNilOrEmpty:_categoryName]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(closeToolTip:)]) {
                [self.delegate closeToolTip:self];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(mouseExiteCategory:withObject:)]) {
                [self.delegate mouseExiteCategory:self withObject:_categoryName];
            }

        }
    }
}

- (void)mouseUp:(NSEvent *)theEvent {
    NSPoint localPoint = [self convertPoint:[[self window] convertScreenToBase:[NSEvent mouseLocation]] fromView:nil];
    BOOL mouseInside = NSPointInRect(localPoint, [self bounds]);
    _isDown = NO;
    if (mouseInside && ![StringHelper stringIsNilOrEmpty:_categoryName]) {
        int64_t delayInSeconds = 0.00005;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            _isSelected = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(categoryClick:withObject:)]) {
                [self.delegate categoryClick:self withObject:_categoryName];
            }
        });
    }
}

- (void)getCategoryName {
    NSArray *views = self.subviews;
    for (NSView *subview in views) {
        if ([subview isKindOfClass:[NSImageView class]]) {
            NSImageView *imageV = (NSImageView *)subview;
            imageV.image = [StringHelper imageNamed:@""];
        }
        
        if ([subview isKindOfClass:[NSTextField class]]) {
            NSTextField *field = (NSTextField *)subview;
            if (field.tag == 1) {
                _categoryName = [field stringValue];
                _hasIdentify = YES;
                break;
            }
        }
    }
}

- (void)dealloc{
    [_delegate release],_delegate = nil;
    [_categoryName release],_categoryName = nil;
    [_toolTip release],_toolTip = nil;
    [super dealloc];
}

@end
