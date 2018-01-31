//
//  IMBCustomButton.m
//  PhoneClean3.0
//
//  Created by Pallas on 8/7/13.
//  Copyright (c) 2013 iMobie Inc. All rights reserved.
//

#import "IMBCustomButton.h"
#import "IMBCommonButtonCell.h"

@implementation IMBCustomButton
@synthesize currUniqueKey = _currUniqueKey;
@synthesize buttonWight = _buttonWight;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setMinWight:0];
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setMinWight:0];
    }
    
    return self;
}

- (void)setTitle:(NSString *)aString {
    if (aString.length >= 15) {
        aString = [aString substringToIndex:15];
        aString = [aString stringByAppendingString:@"..."];
    }
    [super setTitle:aString];
    if (self.minWight == 0) {
        [self setMinWight:self.frame.size.width];
    }
    NSAttributedString *attrTitle = [self attributedTitle];
    [self setButtonWight:(ceil(attrTitle.size.width) + 40)];
    if (self.buttonWight < self.minWight) {
        [self setButtonWight:self.minWight];
    }
    [self setFrameSize:NSMakeSize(self.buttonWight, self.frame.size.height)];
}

- (void)setMinWight:(float)minWight {
    if (_minWight != minWight) {
        _minWight = minWight;
    }
}

- (float)minWight {
    return _minWight;
}

- (void)updateTrackingAreas {
	[super updateTrackingAreas];
	
	if (trackingArea)
	{
		[self removeTrackingArea:trackingArea];
		[trackingArea release];
	}
	
	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
	trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:options owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    if ([self.cell respondsToSelector:@selector(setMouseStatus:)]) {
        [self.cell setMouseStatus:MouseEnter];
    }
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
    if ([self.cell respondsToSelector:@selector(setMouseStatus:)]) {
        [self.cell setMouseStatus:MouseOut];
    }
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    if (theEvent.clickCount > 1) {
        return;
    }
    if ([self.cell respondsToSelector:@selector(setMouseStatus:)]) {
        [self.cell setMouseStatus:MouseDown];
    }
    [self setNeedsDisplay:YES];
    if (!self.isEnabled) {
        return;
    }
    mouseDownCount += 1;
    //[NSApp sendAction:self.action to:self.target from:self];
    /*int64_t delayInSeconds = 0.00005;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if ([self.cell respondsToSelector:@selector(setMouseStatus:)]) {
            [self.cell setMouseStatus:MouseOut];
        }
        [self setNeedsDisplay:YES];

    });*/
}

- (void)mouseUp:(NSEvent *)theEvent {
    if ([self.cell respondsToSelector:@selector(setMouseStatus:)]) {
        [self.cell setMouseStatus:MouseEnter];
    }
    [self setNeedsDisplay:YES];
    if (self.target != nil && self.action != nil) {
        if ([self.target respondsToSelector:self.action] && (theEvent.clickCount == 1)) {
            [self.target performSelector:self.action withObject:self];
        }
    }
}

-(void)setArttbulte:(NSString *)string {
    if (string != nil) {
        NSMutableAttributedString *atString = [[[NSMutableAttributedString alloc] initWithString:string]autorelease];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
        [style setLineBreakMode:NSLineBreakByTruncatingTail];
        [atString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [atString length])];
        [self setAttributedTitle:atString];
        [style release];
    }
}

@end
