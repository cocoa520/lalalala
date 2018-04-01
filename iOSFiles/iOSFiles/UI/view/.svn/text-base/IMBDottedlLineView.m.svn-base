//
//  IMBDottedlLineView.m
//  PhoneClean
//
//  Created by iMobie on 1/26/16.
//  Copyright (c) 2016 imobie.com. All rights reserved.
//

#import "IMBDottedlLineView.h"
#import <QuartzCore/QuartzCore.h>
#import "IMBCommonDefine.h"
#import "NSColor+Category.h"
#import "IMBNotificationDefine.h"

@implementation IMBDottedlLineView
@synthesize isSendLogView = _isSendLogView;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
    
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    NSBezierPath *clipPath1 = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    [clipPath1 setWindingRule:NSEvenOddWindingRule];
    [clipPath1 closePath];
    [clipPath1 addClip];
    [COLOR_TEXT_LINE set];
    [clipPath1 stroke];
    
}

- (void)drawDottedLine:(NSRect)dirtyRect {
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, COLOR_TEXT_LINE.toCGColor);
    CGContextMoveToPoint(context, 14, 6);
    CGContextAddLineToPoint(context, dirtyRect.size.width - 14, 6);
    CGContextAddArc(context, dirtyRect.size.width - 10, 10, 4, 1.5 * M_PI, 2 * M_PI, NO);
    CGContextAddLineToPoint(context, dirtyRect.size.width - 6, dirtyRect.size.height - 10);
    CGContextAddArc(context, dirtyRect.size.width - 10, dirtyRect.size.height - 6, 4, 0, 0.5 * M_PI, NO);
    CGContextAddLineToPoint(context, 14, dirtyRect.size.height - 2);
    CGContextAddArc(context, 14, dirtyRect.size.height - 6, 4, 0.5 * M_PI, M_PI, NO);
    CGContextAddLineToPoint(context, 10, 10);
    CGContextAddArc(context, 14, 10, 4, M_PI, 1.5 * M_PI, NO);
    CGContextStrokePath(context);
}

- (void)changeSkin:(NSNotification *)nsnotification {
    [self setNeedsDisplay:YES];
}

- (void)dealloc {
    [super dealloc];
}
@end
