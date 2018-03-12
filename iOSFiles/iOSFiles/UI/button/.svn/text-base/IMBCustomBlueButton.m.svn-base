//
//  IMBCustomBlueButton.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/12.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBCustomBlueButton.h"
#import "IMBCommonDefine.h"


@interface IMBCustomBlueButton()
{
    
}

@end

@implementation IMBCustomBlueButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    
}

- (void)awakeFromNib {
    
    [self setWantsLayer:YES];
    [self.layer setBackgroundColor:COLOR_BTN_BLUE_BG.CGColor];
    [self.layer setCornerRadius:2.0f];
    
    [self setTextColor:[NSColor whiteColor]];
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:options owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (void)setTextColor:(NSColor *)textColor
{
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc]
                                            initWithAttributedString:[self attributedTitle]];
    NSUInteger len = [attrTitle length];
    NSRange range = NSMakeRange(0, len);
    [attrTitle addAttribute:NSForegroundColorAttributeName
                      value:textColor
                      range:range];
    [attrTitle fixAttributesInRange:range];
    [self setAttributedTitle:attrTitle];
    [attrTitle release];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [self setAlphaValue:0.75f];
    [super mouseDown:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent {
    [self setAlphaValue:0.85f];
    [super mouseUp:theEvent];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [self setAlphaValue:0.85f];
    [super mouseEntered:theEvent];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [self setAlphaValue:1.f];
    [super mouseExited:theEvent];
}
@end
