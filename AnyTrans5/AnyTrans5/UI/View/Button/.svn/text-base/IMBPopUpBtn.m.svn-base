//
//  IMBPopUpBtn.m
//  MacClean
//
//  Created by iMobie023 on 15-5-29.
//  Copyright (c) 2015年 iMobie. All rights reserved.
//

#import "IMBPopUpBtn.h"
#import "StringHelper.h"
#import "IMBSoftWareInfo.h"
@implementation IMBPopUpBtn
@synthesize mouseDownImage = _mouseDownImage;
@synthesize normalImage = _normalImage;
@synthesize isMouseDown = _isMouseDown;
@synthesize isPopupBtn = _isPopupBtn;
@synthesize isDrawBackGroudColor = _isDrawBackGroudColor;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    _normalImage = [[StringHelper imageNamed:@"default_arrow1"] retain];
    _mouseDownImage = [[StringHelper imageNamed:@"default_arrow2"] retain];
}

- (void)setTitle:(NSString *)aString {
    [super setTitle:@""];
    if (_title != aString) {
        [_title release];
        _title = [aString retain];
    }
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:(aString?aString:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName, nil]];
    int width = 0;
    width = title.size.width + 10*3;
    [self setFrameSize:NSMakeSize(width, 22)];
    [title release];
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (!_isPopupBtn) {
        _isMouseDown = YES;
        [super mouseDown:theEvent];
        _isMouseDown = NO;
    }else
    {
         [super mouseDown:theEvent];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{

        //dirtyRect = NSMakeRect(dirtyRect.origin.x+3, dirtyRect.origin.y, dirtyRect.size.width -6, dirtyRect.size.height);
//    if (!_isDrawBackGroudColor) {
//        NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:dirtyRect];
//        [clipPath setWindingRule:NSEvenOddWindingRule];
//        [clipPath addClip];
//        [[StringHelper getColorFromString:CustomColor(@"mainView_bgColor", nil)] set];
//        [clipPath fill];
//    }

    [super drawRect:dirtyRect];
    if (!_isPopupBtn) {
        
        NSRect drawrect = NSMakeRect(NSWidth(dirtyRect) - 8, ceil(NSHeight(dirtyRect)/2.0), 8, 4);
        if (_isMouseDown) {
            NSRect imageRect;
            imageRect.origin = NSZeroPoint;
            imageRect.size = _mouseDownImage.size;
            [_mouseDownImage drawInRect:drawrect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        }else{
            NSRect imageRect;
            imageRect.origin = NSZeroPoint;
            imageRect.size = _normalImage.size;
            [_normalImage drawInRect:drawrect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        }
    }else{
        NSRect imageRect;
        imageRect.origin = NSZeroPoint;
        imageRect.size = _image.size;
        [_image drawInRect:dirtyRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
    }
    // Drawing code here.
    
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:(_title?_title:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,textParagraph,NSParagraphStyleAttributeName,nil]];
    int width = title.size.width + 10*3;
    width -= 10*3;
    NSRect rect ;
    if ([IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
           rect = NSMakeRect(ceilf((NSWidth(self.frame) - width)/2.0), ceilf((NSHeight(self.frame) - title.size.height)/2.0)-2, width + 5, title.size.height+20);
    }else {
           rect = NSMakeRect(ceilf((NSWidth(self.frame) - width)/2.0), ceilf((NSHeight(self.frame) - title.size.height)/2.0), width, title.size.height);
    }
    [title drawInRect:rect];
}

-(void)dealloc
{
    [_mouseDownImage release],_mouseDownImage = nil;
    [_normalImage release],_normalImage = nil;
    [super dealloc];
}

@end
