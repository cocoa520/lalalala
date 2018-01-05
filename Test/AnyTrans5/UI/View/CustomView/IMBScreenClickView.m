//
//  IMBScreenClickView.m
//  MacClean
//
//  Created by JGehry on 4/1/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBScreenClickView.h"

@implementation IMBScreenClickView
@synthesize backgroundImage = _backgroundImage;
@synthesize backGroundColor = _backGroundColor;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    if (_backGroundColor != nil) {
        [_backGroundColor setFill];
        NSRectFill(dirtyRect);
    }
    NSRect imageRect;
    imageRect.size = _backgroundImage.size;
    [_backgroundImage drawInRect:dirtyRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
}

- (void)awakeFromNib {
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilesPromisePboardType,NSFilenamesPboardType,nil]];
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
	NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:options owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
    [trackingArea release];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    return NSDragOperationNone;
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
    return NSDragOperationNone;
}

- (void)updateTrackingAreas{
}
- (void)rightMouseDown:(NSEvent *)theEvent {
    
}

-(void)mouseDown:(NSEvent *)theEvent {
}

- (void)mouseUp:(NSEvent *)theEvent {
}

-(void)mouseExited:(NSEvent *)theEvent {
    [self becomeFirstResponder];
}

-(void)mouseMoved:(NSEvent *)theEvent {
    [self becomeFirstResponder];
}

-(void)mouseEntered:(NSEvent *)theEvent {
    [self becomeFirstResponder];
}


@end
