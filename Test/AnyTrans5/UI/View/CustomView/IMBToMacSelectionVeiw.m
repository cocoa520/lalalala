//
//  IMBToMacSelectionVeiw.m
//  iMobieTrans
//
//  Created by iMobie on 7/24/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBToMacSelectionVeiw.h"

@implementation IMBToMacSelectionVeiw
@synthesize isEntered = _isEntered;
@synthesize delegate = _delegate;
@synthesize isClicked = _isClicked;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        [self addObserver];
    }
    return self;
}

- (void)updateTrackingAreas
{
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

- (void)setIsClicked:(BOOL)isClicked {
    if (_isClicked != isClicked) {
        _isClicked = isClicked;
        [self setNeedsDisplay:YES];
    }
}

- (void)setIsEntered:(BOOL)isEntered {
    if (_isEntered != isEntered) {
        _isEntered = isEntered;
        [self setNeedsDisplay:YES];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    if (_isEntered) {
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
        [[StringHelper getColorFromString:CustomColor(@"hoverBtn_enter_bgColor", nil)] setFill];
        [path fill];
    }
    if (_isClicked) {
//        NSImage *image = [StringHelper imageNamed:@"sel_all"];
//        NSRect drawingRect;
//        drawingRect.size = image.size;
//        drawingRect.origin = NSMakePoint(61, 73);
//        NSRect imageRect;
//        imageRect.origin = NSZeroPoint;
//        imageRect.size = image.size;
//        [image drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
    }else {
//        NSImage *image = [StringHelper imageNamed:@"sel_non"];
//        NSRect drawingRect;
//        drawingRect.size = image.size;
//        drawingRect.origin = NSMakePoint(61, 73);
//        
//        NSRect imageRect;
//        imageRect.origin = NSZeroPoint;
//        imageRect.size = image.size;
//        
//        [image drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
    }
	
    // Drawing code here.
}


- (void)mouseEntered:(NSEvent *)theEvent {
    NSLog(@"entered");
    _isEntered = YES;
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    NSLog(@"exit");
    _isEntered = NO;
    [self setNeedsDisplay:YES];
}

//- (void)scrollWheel:(NSEvent *)theEvent {
//    [super scrollWheel:theEvent];
//    
//    NSPoint point = [self convertPoint:[[self window] convertScreenToBase:[NSEvent mouseLocation]] fromView:nil];
//    BOOL mouseInside = NSPointInRect(point, [self bounds]);
//    if (mouseInside) {
//        NSLog(@"mous in");
//        [self setIsEntered:true];
//    }else {
//        NSLog(@"mous out");
//        
//        [self setIsEntered:false];
//    }
//
//}

- (void)mouseUp:(NSEvent *)theEvent{
    [super mouseUp:theEvent];
}

/*
- (void)mouseDown:(NSEvent *)theEvent {
}

- (void)mouseUp:(NSEvent *)theEvent {
    NSPoint localPoint = [self convertPoint:[[self window] convertScreenToBase:[NSEvent mouseLocation]] fromView:nil];
    BOOL mouseInside = NSPointInRect(localPoint, [self bounds]);
    
    if (mouseInside) {
        NSString *stringTest = nil;
        if ([self.identifier isEqualToString:@"fileCollection"]) {
            NSArray *views = self.subviews;
            for (NSView *view in views) {
                if ([view isKindOfClass:[NSTextField class]]) {
                    NSTextField *field = (NSTextField *)view;
                    if (field.tag == 2) {
                        stringTest = [field stringValue];
                    }
                } else if ([view isKindOfClass:[NSButton class]]) {
                    localPoint = [view convertPoint:[[view window] convertScreenToBase:[NSEvent mouseLocation]] fromView:nil];
                    BOOL inside = NSPointInRect(localPoint, [view bounds]);
                    if (inside) {
                        mouseInside = NO;
                    }
                } else {
                    continue;
                }
            }
        }
        
        if (mouseInside && ![IMBHelper stringIsNilOrEmpty:stringTest]) {
            int64_t delayInSeconds = 0.00005;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [[NSNotificationCenter defaultCenter] postNotificationName:COLLECTION_FILE_ITEM_CLICKUP object:stringTest userInfo:nil];
            });
        }
    }
}
*/

@end
