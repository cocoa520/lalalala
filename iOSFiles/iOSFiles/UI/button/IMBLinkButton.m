//
//  IMBLinkButton.m
//  iMobieTrans
//
//  Created by Pallas on 9/11/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBLinkButton.h"
#import "StringHelper.h"
#import "IMBCommonDefine.h"
@implementation IMBLinkButton
@synthesize textColor = _textColor;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _textColor = [COLOR_TEXT_PASSAFTER retain];
    }
    return self;
}

- (void)updateTrackingAreas {
	[super updateTrackingAreas];
	if (_trackingArea) {
		[self removeTrackingArea:_trackingArea];
		[_trackingArea release];
        _trackingArea = nil;
	}
	
	NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
	_trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
	[self addTrackingArea:_trackingArea];
}

- (void)dealloc {
    if (_trackingArea) {
		[self removeTrackingArea:_trackingArea];
		[_trackingArea release];
        _trackingArea = nil;
	}
    if (_textColor != nil) {
        [_textColor release];
        _textColor = nil;
    }
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [[NSCursor pointingHandCursor] set];
    [self setUnderlineLink];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [[NSCursor arrowCursor] set];
    [self setNoUnderlineLink];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [NSApp sendAction:self.action to:self.target from:self];
    int64_t delayInSeconds = 0.00005;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setNoUnderlineLink];
    });
}

- (void)setNoUnderlineLink {
    NSString *title = self.title;
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: title];
    NSRange range = NSMakeRange(0, [attrString length]);
    // make the text appear in blue
    [attrString addAttribute:NSForegroundColorAttributeName value:self.textColor range:range];
    
    // next make the text appear with an underline
    [attrString addAttribute:
     NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSNoUnderlineStyle] range:range];
    [attrString setAlignment:NSLeftTextAlignment range:range];
    [self setAttributedTitle:attrString];
}

- (void)setUnderlineLink {
    NSString *title = self.title;
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: title];
    NSRange range = NSMakeRange(0, [attrString length]);
    // make the text appear in blue
    [attrString addAttribute:NSForegroundColorAttributeName value:self.textColor range:range];
    
    // next make the text appear with an underline
    [attrString addAttribute:
     NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];
    [attrString setAlignment:NSLeftTextAlignment range:range];
//    [attrString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:range];
    [self setAttributedTitle:attrString];
}

@end
