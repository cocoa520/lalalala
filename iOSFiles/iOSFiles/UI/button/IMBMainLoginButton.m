//
//  IMBMainLoginButton.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/20.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBMainLoginButton.h"
#import "IMBCommonDefine.h"


@implementation IMBMainLoginButton

#pragma mark - initialize
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
    
    [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:NO];
    
    [self setTitleAttrWithTitleColor:COLOR_MAINWINDOW_MESSAGE_TEXT];
}

#pragma mark - mouseEnvent
- (void)mouseEntered:(NSEvent *)theEvent {
    [self setTitleAttrWithTitleColor:COLOR_MAINWINDOW_MESSAGE_BLUE_TEXT];
}

- (void)mouseExited:(NSEvent *)theEvent {
    [self setTitleAttrWithTitleColor:COLOR_MAINWINDOW_MESSAGE_TEXT];
    
}
- (void)mouseDown:(NSEvent *)theEvent {
    
}

- (void)mouseUp:(NSEvent *)theEvent {
//    [self setTitleAttrWithTitleColor:COLOR_MAINWINDOW_MESSAGE_TEXT];
    [NSApp sendAction:self.action to:self.target from:self];
}

#pragma mark - other methods
- (void)setTitleAttrWithTitleColor:(NSColor *)color {
    NSMutableParagraphStyle *pghStyle = [[NSMutableParagraphStyle alloc] init];
    pghStyle.alignment = NSTextAlignmentCenter;
    NSMutableDictionary *attrText = [[NSMutableDictionary alloc] init];
    [attrText setValue:color forKey:NSForegroundColorAttributeName];
    [attrText setValue:[NSFont fontWithName:IMBCommonFont size:12.0] forKey:NSFontAttributeName];
    [attrText setValue:pghStyle forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Go Now →" attributes:attrText];
    [self setAttributedTitle:attrString];
    
    [pghStyle release];
    pghStyle = nil;
    [attrText release];
    attrText = nil;
    [attrString release];
    attrString = nil;
}
@end
