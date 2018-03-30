//
//  IMBMainPageWindowBackBtn.m
//  iOSFiles
//
//  Created by iMobie on 2018/3/21.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "IMBMainPageWindowBackBtn.h"
#import "IMBCommonDefine.h"


@interface IMBMainPageWindowBackBtn()
{
    NSString *_imgStirng;
}

@end

@implementation IMBMainPageWindowBackBtn

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    if (_imgStirng) {
        NSImage *iconImage =[[NSImage alloc] initWithSize:NSMakeSize(10.f, 10.f)];
        iconImage = [NSImage imageNamed:_imgStirng];
        [iconImage setResizingMode:NSImageResizingModeTile];
        int xPos = 0;
        NSRect imageRect;
        imageRect.origin = NSZeroPoint ;
        imageRect.size = NSMakeSize(iconImage.size.width , iconImage.size.height );
        NSRect drawingRect = NSZeroRect;
        drawingRect.origin = NSMakePoint(NSMinX(dirtyRect) + xPos , (dirtyRect.size.height - imageRect.size.height)/2.f + 2 );
        drawingRect.size = imageRect.size;
        [iconImage drawInRect:drawingRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    }
    
    
}

- (void)awakeFromNib {
    [self addTrackingRect:self.bounds owner:self userData:nil assumeInside:NO];
    [self setTitleAttrWithTitleColor:COLOR_MAINPAGE_BACK];
    
    _imgStirng = @"navbar_icon_rt_back";
}

- (void)mouseDown:(NSEvent *)theEvent {
    
}

- (void)mouseUp:(NSEvent *)theEvent {
    [self setTitleAttrWithTitleColor:COLOR_MAINPAGE_BACK];
    [NSApp sendAction:self.action to:self.target from:self];
    _imgStirng = @"navbar_icon_rt_back";
    
}

- (void)mouseEntered:(NSEvent *)theEvent {
    
    [self setTitleAttrWithTitleColor:COLOR_MAINWINDOW_MESSAGE_BLUE_TEXT];
    _imgStirng = @"navbar_icon_rt_back_hover";
}

- (void)mouseExited:(NSEvent *)theEvent {
    [self setTitleAttrWithTitleColor:COLOR_MAINPAGE_BACK];
    _imgStirng = @"navbar_icon_rt_back";
}
#pragma mark - other methods
- (void)setTitleAttrWithTitleColor:(NSColor *)color {
    NSMutableParagraphStyle *pghStyle = [[NSMutableParagraphStyle alloc] init];
    pghStyle.alignment = NSTextAlignmentCenter;
    NSMutableDictionary *attrText = [[NSMutableDictionary alloc] init];
    [attrText setValue:color forKey:NSForegroundColorAttributeName];
    [attrText setValue:[NSFont fontWithName:IMBCommonFont size:14.0] forKey:NSFontAttributeName];
    [attrText setValue:pghStyle forKey:NSParagraphStyleAttributeName];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"home" attributes:attrText];
    [self setAttributedTitle:attrString];
    
    [pghStyle release];
    pghStyle = nil;
    [attrText release];
    attrText = nil;
    [attrString release];
    attrString = nil;
}

@end
