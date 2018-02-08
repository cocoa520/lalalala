//
//  VolumViews.m
//  VolumTest1.1
//
//  Created by iMobie on 5/8/13.
//  Copyright (c) 2013 iMobie. All rights reserved.
//

#import "IMBVolumView.h"
#import "StringHelper.h"

@implementation IMBVolumView
@synthesize isFull = _isFull;
-(id)initWithImage:(NSImage *)image dialogView:(NSView *)dialogView{
    self = [super init];
    if (self) {
        _image = image ;
        //_dialogView = dialogView;
        [self setNeedsDisplay:YES];
    }
    return self;
}

-(id)initWithImageName:(NSString*)imageName currentCount:(int)i {
    self = [super init];
    if (self) {
        //NSLog(@"imageName %@",imageName );
        _image = [[StringHelper imageNamed:imageName] retain];
        _imageName = [imageName retain];
        currentCount = i;
        //_dialogView = dialogView;
        [self setNeedsDisplay:YES];
    }
    return self;
}
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
/*
-(void)updateTrackingAreas{
    [super updateTrackingAreas];
	
	if (trackingArea)
	{
		[self removeTrackingArea:trackingArea];
		[trackingArea release];
	}
	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
	trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
}
*/
- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    // Drawing code here.
    if (currentCount == 0) {
        
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path moveToPoint:NSMakePoint(4 , 0)];
        [path lineToPoint:NSMakePoint(3, 0)];
        [path appendBezierPathWithArcFromPoint:NSMakePoint(2, 0) toPoint:NSMakePoint(0, 2) radius:2];
        [path lineToPoint:NSMakePoint(0, 3)];
        [path lineToPoint:NSMakePoint(0, dirtyRect.size.height - 3)];
        [path appendBezierPathWithArcFromPoint:NSMakePoint(0, dirtyRect.size.height - 2) toPoint:NSMakePoint(2, dirtyRect.size.height) radius:2];
        [path lineToPoint:NSMakePoint(3, dirtyRect.size.height)];
        [path lineToPoint:NSMakePoint(0, dirtyRect.size.height)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height)];
        [path lineToPoint:NSMakePoint(dirtyRect.size.width, 0)];
        [path closePath];
        [path addClip];
        
        NSRect imageRect;
        imageRect.origin=NSZeroPoint;
        imageRect.size=[_image size];
        //NSRect drawingRect=[self currentRect];
        [_image drawInRect:dirtyRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
        
        
        
    }else
    {
        if (_isFull) {
            NSBezierPath *path = [NSBezierPath bezierPath];
            [path moveToPoint:NSMakePoint(dirtyRect.size.width-4 , 0)];
            [path lineToPoint:NSMakePoint(dirtyRect.size.width-3, 0)];
            [path appendBezierPathWithArcFromPoint:NSMakePoint(dirtyRect.size.width-2, 0) toPoint:NSMakePoint(dirtyRect.size.width, 2) radius:2];
            [path lineToPoint:NSMakePoint(dirtyRect.size.width, 3)];
            [path lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height - 3)];
            [path appendBezierPathWithArcFromPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height - 2) toPoint:NSMakePoint(dirtyRect.size.width-2, dirtyRect.size.height) radius:2];
            [path lineToPoint:NSMakePoint(dirtyRect.size.width-3, dirtyRect.size.height)];
            [path lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height)];
            [path lineToPoint:NSMakePoint(0, dirtyRect.size.height)];
            [path lineToPoint:NSMakePoint(0, 0)];
            [path closePath];
            [path addClip];
            
            NSRect imageRect;
            imageRect.origin=NSZeroPoint;
            imageRect.size=[_image size];
            //NSRect drawingRect=[self currentRect];
            [_image drawInRect:dirtyRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
        }else {
            NSRect imageRect;
            imageRect.origin=NSZeroPoint;
            imageRect.size=[_image size];
            NSRect drawingRect=[self currentRect];
            [_image drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0];
        }
    }
     
}
-(NSRect)currentRect{
    return self.bounds;
}

/*
-(void)mouseEntered:(NSEvent *)theEvent{
    NSLog(@"audio_mouseEntered");
    float x =self.frame.origin.x+self.frame.size.width/2.0-_dialogView.frame.size.width/2.0;
    float y =self.frame.origin.y+self.frame.size.height;
    [_dialogView setFrameOrigin:NSMakePoint(x, y)];
    [self.superview addSubview:_dialogView];
}
-(void)mouseExited:(NSEvent *)theEvent{
    NSLog(@"audio_mouseExited");
    [_dialogView removeFromSuperview];
 
}
*/

- (void)dealloc
{
    [_image release],_image = nil;
    [_imageName release],_imageName = nil;
    [super dealloc];
}
@end
