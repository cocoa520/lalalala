//
//  IMBToolTipView.m
//  iMobieTrans
//
//  Created by Pallas on 7/31/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBToolTipView.h"
#import "StringHelper.h"
@implementation IMBToolTipView
@synthesize isFirstCategory = _isFirstCategory;
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
    
    NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
    [shadow setShadowColor:[StringHelper getColorFromString:CustomColor(@"popover_shadowColor", nil)]];//0.571
    [shadow setShadowOffset:NSMakeSize(0, 0)];
    [shadow setShadowBlurRadius:2];
    [shadow set];
    
    if (dirtyRect.size.width > 40 && _isFirstCategory ) {
        NSBezierPath *path = [NSBezierPath bezierPath];
        path.lineWidth = 1.0;
        NSPoint p = NSMakePoint(dirtyRect.origin.x + 20, dirtyRect.origin.y+2);
        [path moveToPoint:p];
        
        [path lineToPoint:NSMakePoint(dirtyRect.origin.x + 20 - 5, dirtyRect.origin.y+7)];
        
        [path lineToPoint:NSMakePoint(dirtyRect.origin.x + 7, dirtyRect.origin.y+7)];
        
        [path appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.origin.x + 7, dirtyRect.origin.y+12) radius:5 startAngle:270 endAngle:180 clockwise:YES];
        
        [path lineToPoint:NSMakePoint(dirtyRect.origin.x + 2, dirtyRect.origin.y+dirtyRect.size.height - 7)];
        
        [path appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.origin.x + 7, dirtyRect.origin.y+dirtyRect.size.height - 7) radius:5 startAngle:180 endAngle:90 clockwise:YES];
        
        [path lineToPoint:NSMakePoint(dirtyRect.origin.x + dirtyRect.size.width - 9, dirtyRect.origin.y+dirtyRect.size.height - 2)];
        
        [path appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.origin.x + dirtyRect.size.width - 9, dirtyRect.origin.y+dirtyRect.size.height - 7) radius:5 startAngle:90 endAngle:0 clockwise:YES];
        
        [path lineToPoint:NSMakePoint(dirtyRect.origin.x + dirtyRect.size.width - 4, dirtyRect.origin.y+12)];
        
        [path appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.origin.x + dirtyRect.size.width - 9, dirtyRect.origin.y+12) radius:5 startAngle:0 endAngle:270 clockwise:YES];
        
        [path lineToPoint:NSMakePoint(dirtyRect.origin.x + 20 + 5, dirtyRect.origin.y+7)];
        [path closePath];
        [path addClip];
        [[StringHelper getColorFromString:CustomColor(@"popover_bgColor", nil)] set];
        [path fill];
        [[StringHelper getColorFromString:CustomColor(@"popover_borderColor", nil)] setStroke];
        [path stroke];
    }else {
        NSBezierPath *path = [NSBezierPath bezierPath];
        path.lineWidth = 1.0;
        NSPoint p = NSMakePoint(dirtyRect.origin.x + ceil(dirtyRect.size.width / 2), dirtyRect.origin.y+2);
        [path moveToPoint:p];
        [path lineToPoint:NSMakePoint(dirtyRect.origin.x + ceil(dirtyRect.size.width / 2) - 5, dirtyRect.origin.y+7)];
        
        [path lineToPoint:NSMakePoint(dirtyRect.origin.x + 7, dirtyRect.origin.y+7)];
        
        [path appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.origin.x + 7, dirtyRect.origin.y+12) radius:5 startAngle:270 endAngle:180 clockwise:YES];
        
        [path lineToPoint:NSMakePoint(dirtyRect.origin.x + 2, dirtyRect.origin.y+dirtyRect.size.height - 7)];
        
        [path appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.origin.x + 7, dirtyRect.origin.y+dirtyRect.size.height - 7) radius:5 startAngle:180 endAngle:90 clockwise:YES];
        
        [path lineToPoint:NSMakePoint(dirtyRect.origin.x + dirtyRect.size.width - 9, dirtyRect.origin.y+dirtyRect.size.height - 2)];
        
        [path appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.origin.x + dirtyRect.size.width - 9, dirtyRect.origin.y+dirtyRect.size.height - 7) radius:5 startAngle:90 endAngle:0 clockwise:YES];
        
        [path lineToPoint:NSMakePoint(dirtyRect.origin.x + dirtyRect.size.width - 4, dirtyRect.origin.y+12)];
        
        [path appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.origin.x + dirtyRect.size.width - 9, dirtyRect.origin.y+12) radius:5 startAngle:0 endAngle:270 clockwise:YES];
        
        [path lineToPoint:NSMakePoint(dirtyRect.origin.x + ceil(dirtyRect.size.width / 2) + 5, dirtyRect.origin.y+7)];
        [path closePath];
        [path addClip];
        [[StringHelper getColorFromString:CustomColor(@"popover_bgColor", nil)] set];
        [path fill];
        [[StringHelper getColorFromString:CustomColor(@"popover_borderColor", nil)] setStroke];
        [path stroke];
    }
}

- (void)dealloc {
    [super dealloc];
}
@end
