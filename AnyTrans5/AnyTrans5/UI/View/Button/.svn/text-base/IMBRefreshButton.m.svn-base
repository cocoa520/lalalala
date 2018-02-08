//
//  IMBRefreshButton.m
//  iMobieTrans
//
//  Created by iMobie on 7/11/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBRefreshButton.h"
#import "StringHelper.h"
@implementation IMBRefreshButton
@synthesize titleName;

- (id)initWithFrame:(NSRect)frame withName:(NSString *)name
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [self setButtonType:NSMomentaryChangeButton];
        [self setBezelStyle:NSRoundedBezelStyle];
        [self setAlignment:NSCenterTextAlignment];
        [self setImagePosition:NSNoImage];
        [self setEnabled:YES];
        [self setBordered:NO];
        titleName = [name retain];
        [self setAttributedTitle:[self mutableAttributeString:ExitButton]];
    }
    
    return self;
}

- (void)dealloc
{
    if (titleName != nil) {
        [titleName release];
        titleName = nil;
    }
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)theEvent {
    [self setAttributedTitle:[self mutableAttributeString:DownButton]];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [self setAttributedTitle:[self mutableAttributeString:UpButton]];
    
    NSPoint localPoint = [self convertPoint:[[self window] convertScreenToBase:[NSEvent mouseLocation]] fromView:nil];
    BOOL mouseInside = NSPointInRect(localPoint, [self bounds]);
    if (mouseInside) {
        if (self.target != nil && self.action != nil && self.isEnabled) {
            if ([self.target respondsToSelector:self.action]) {
                [self.target performSelector:self.action withObject:self];
            }
        }
    }
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [self setAttributedTitle:[self mutableAttributeString:EnteredButton]];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [self setAttributedTitle:[self mutableAttributeString:ExitButton]];
}

- (NSMutableAttributedString *)mutableAttributeString:(ButtonType)buttonType {
    if (titleName != nil) {
        NSMutableAttributedString *attributedTitles = [[[NSMutableAttributedString alloc]initWithString:titleName] autorelease];
        [attributedTitles addAttribute:NSBackgroundColorAttributeName value:[NSColor clearColor] range:NSMakeRange(0, titleName.length)];
        if (buttonType == UpButton) {
            [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, titleName.length)];
            [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"textBtn_enterColor", nil)] range:NSMakeRange(0, titleName.length)];
        }else if (buttonType == DownButton) {
            [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, titleName.length)];
            [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"textBtn_downColor", nil)]  range:NSMakeRange(0, titleName.length)];
        }else if (buttonType == EnteredButton) {
            [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, titleName.length)];
            [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"textBtn_enterColor", nil)] range:NSMakeRange(0, titleName.length)];
        }else {
            [attributedTitles addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:14] range:NSMakeRange(0, titleName.length)];
            [attributedTitles addAttribute:NSForegroundColorAttributeName value:[StringHelper getColorFromString:CustomColor(@"textBtn_normalColor", nil)] range:NSMakeRange(0, titleName.length)];
        }
        return attributedTitles;
    }
    return nil;
}

-(void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (trackingArea != nil) {
        [self removeTrackingArea:trackingArea];
        [trackingArea release];
        trackingArea = nil;
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    trackingArea = [[NSTrackingArea alloc]initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

@end
