//
//  IMBDottedlLineView.m
//  PhoneClean
//
//  Created by iMobie on 1/26/16.
//  Copyright (c) 2016 imobie.com. All rights reserved.
//

#import "IMBDottedlLineView.h"
#import <QuartzCore/QuartzCore.h>
#import "StringHelper.h"
#import "NSColor+Category.h"
#import "IMBNotificationDefine.h"
#import "IMBSoftWareInfo.h"
@implementation IMBDottedlLineView
@synthesize isSendLogView = _isSendLogView;
@synthesize isAirBackUpAlert = _isAirBackUpAlert;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:NOTIFY_CHANGE_SKIN object:nil];
}

- (void)drawRect:(NSRect)dirtyRect
{ 
    [super drawRect:dirtyRect];
    if (_isAirBackUpAlert) {
        NSBezierPath *clipPath = [NSBezierPath bezierPathWithRect:dirtyRect];
        [[StringHelper getColorFromString:CustomColor(@"alert_inside_bgColor", nil)] setFill];
        if ([[IMBSoftWareInfo singleton].curUseSkin isEqualToString:@"christmasSkin"]) {
            [[NSColor colorWithDeviceRed:212/255.0 green:232/255.0 blue:219/255.0 alpha:1.0] setStroke];
        } else {
            [[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)] setStroke];
        }
        [clipPath fill];
        [clipPath stroke];
        [clipPath closePath];
        
    } else {
        if (!_isSendLogView) {
            NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
            [clipPath setWindingRule:NSEvenOddWindingRule];
            [clipPath addClip];
            [[StringHelper getColorFromString:CustomColor(@"alert_inside_bgColor", nil)] set];
            [clipPath fill];
            [clipPath closePath];
        }
        NSBezierPath *clipPath1 = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
        [clipPath1 setWindingRule:NSEvenOddWindingRule];
        [clipPath1 closePath];
        [clipPath1 addClip];
        [[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)] set];
        [clipPath1 stroke];
    }
    // Drawing code here.
    
    
//    [self drawDottedLine:dirtyRect];
}

- (void)drawDottedLine:(NSRect)dirtyRect {
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)].toCGColor);
//    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, 14, 6);
//    CGContextAddLineToPoint(context, dirtyRect.size.width / 2 + 14, 10.0 + 20.0);
    CGContextAddLineToPoint(context, dirtyRect.size.width - 14, 6);
    CGContextAddArc(context, dirtyRect.size.width - 10, 10, 4, 1.5 * M_PI, 2 * M_PI, NO);
    CGContextAddLineToPoint(context, dirtyRect.size.width - 6, dirtyRect.size.height - 10);
    CGContextAddArc(context, dirtyRect.size.width - 10, dirtyRect.size.height - 6, 4, 0, 0.5 * M_PI, NO);
    CGContextAddLineToPoint(context, 14, dirtyRect.size.height - 2);
    CGContextAddArc(context, 14, dirtyRect.size.height - 6, 4, 0.5 * M_PI, M_PI, NO);
    CGContextAddLineToPoint(context, 10, 10);
    CGContextAddArc(context, 14, 10, 4, M_PI, 1.5 * M_PI, NO);
//    CGContextAddLineToPoint(context, dirtyRect.size.width / 2 - 14, 30);
//    CGContextAddLineToPoint(context, dirtyRect.size.width / 2, 10);
    CGContextStrokePath(context);
}

- (void)changeSkin:(NSNotification *)nsnotification {
    [self setNeedsDisplay:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CHANGE_SKIN object:nil];
    [super dealloc];
}
@end
