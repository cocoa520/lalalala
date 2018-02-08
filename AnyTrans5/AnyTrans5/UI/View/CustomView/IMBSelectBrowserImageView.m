//
//  IMBSelectBrowserImageView.m
//  iMobieTrans
//
//  Created by iMobie on 14-12-3.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBSelectBrowserImageView.h"
#import "StringHelper.h"

@implementation IMBSelectBrowserImageView
@synthesize backgroundView = _backgroundView;
@synthesize isSelected = _isSelected;
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
}

-(void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (trackingArea == nil) {
        NSTrackingAreaOptions options =   ( NSTrackingActiveAlways  | NSTrackingCursorUpdate|NSTrackingMouseEnteredAndExited);
        trackingArea = [[NSTrackingArea alloc]initWithRect:self.bounds options:options owner:self userInfo:nil];
        [self addTrackingArea:trackingArea];
        [trackingArea release];
    }
}


- (void)setIsSelected:(BOOL)isSelected
{
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        if (_isSelected) {
            [_backgroundView setImage:[StringHelper imageNamed:@"bookmark_choice3"]];
        }else
        {
           [_backgroundView setImage:nil];
        }
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (self.isEnabled) {
       
        
        _eventNumber = theEvent.eventNumber;
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
   if (theEvent.clickCount == 1 &&theEvent.eventNumber == _eventNumber&&self.isEnabled) {
        
        [NSApp sendAction:self.action to:self.target from:self];
    }
    
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    if (!_isSelected) {
        [_backgroundView setImage:[StringHelper imageNamed:@"bookmark_choice2"]];
    }

}

- (void)mouseExited:(NSEvent *)theEvent
{
    if (!_isSelected) {
        [_backgroundView setImage:nil];
    }
}

- (void)dealloc
{
    //[trackingArea release],trackingArea = nil;
    [super dealloc];
}
@end
