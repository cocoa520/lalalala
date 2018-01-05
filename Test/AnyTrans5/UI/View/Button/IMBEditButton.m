//
//  IMBEditButton.m
//  iMobieTrans
//
//  Created by iMobie on 7/1/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import "IMBEditButton.h"
#define RADIUSVALUE 5.0

@implementation IMBEditButton
@synthesize drawString = _drawString;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib{
    
}

- (void)viewDidMoveToSuperview{

    [self setTitle:@""];
    [self setBordered:NO];
    [self setNeedsDisplay];
    originRect = self.frame;
}


- (NSAttributedString *)settingTitle{
    if (self.drawString.length > 0) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:self.drawString];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setAlignment:NSCenterTextAlignment];
        [string addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithDeviceRed:30.0/255 green:166.0/255 blue:255.0/255 alpha:1.0]
 range:NSMakeRange(0, self.drawString.length)];
        [string addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:13.0] range:NSMakeRange(0, self.drawString.length)];
        [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.drawString.length)];
        int calSize = ((int)string.size.width + 8)%2 == 0 ? ((int)string.size.width + 8):((int)string.size.width + 8) + 1;
        if (calSize > originRect.size.width) {
            [self setFrameSize:NSMakeSize(calSize, self.frame.size.height)];
            float offset = -(calSize - originRect.size.width)/2;
            [self setFrameOrigin:NSMakePoint(offset + originRect.origin.x, originRect.origin.y)];
        }
        else{
            float offset = (self.frame.size.width - originRect.size.width)/2;
            [self setFrameSize:NSMakeSize(originRect.size.width, originRect.size.height)];
            [self setFrameOrigin:NSMakePoint(offset + originRect.origin.x, originRect.origin.y)];

        }
        
        return string;
    }
    return nil;
}

- (void)setDrawString:(NSString *)drawString{
    [_drawString release];
    _drawString = nil;
    _drawString = [drawString retain];
    [self setNeedsDisplay];
}

- (void)drawRect:(NSRect)dirtyRect
{
   // [super drawRect:dirtyRect];
    if ([_drawString isEqualToString:CustomLocalizedString(@"Calendar_id_12", nil)]) {
        [[NSColor blackColor] set];
        NSRectFill(dirtyRect);
        return;
    }
    dirtyRect = self.bounds;
    [[NSColor colorWithDeviceRed:30.0/255 green:166.0/255 blue:255.0/255 alpha:1.0] set];
    NSBezierPath *allRect = [NSBezierPath bezierPathWithRect:dirtyRect];
    //方框的Rect
    [[NSColor whiteColor] setFill];
    NSRect newRect = dirtyRect;
    NSBezierPath *rectangelRect = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:RADIUSVALUE yRadius:RADIUSVALUE];
    allRect = [allRect bezierPathByReversingPath];
    [rectangelRect appendBezierPath:allRect];
    [rectangelRect fill];
    
    NSBezierPath *bezierPath1 = [NSBezierPath bezierPath];
    [bezierPath1 moveToPoint:NSMakePoint(RADIUSVALUE, 0)];
    [bezierPath1 lineToPoint:NSMakePoint(dirtyRect.size.width - RADIUSVALUE, 0)];
    [self settingBezierStyle:bezierPath1];
    
    NSBezierPath *bezierPath2 = [NSBezierPath bezierPath];
    [bezierPath2 moveToPoint:NSMakePoint(dirtyRect.size.width - RADIUSVALUE, 0)];
    [bezierPath2 appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.size.width - RADIUSVALUE, RADIUSVALUE) radius:RADIUSVALUE startAngle:270 endAngle:0 clockwise:NO];
    [self settingArcBezierStyle:bezierPath2];
    
    NSBezierPath *bezierPath3= [NSBezierPath bezierPath];
    [bezierPath3 moveToPoint:NSMakePoint(dirtyRect.size.width, RADIUSVALUE)];
    [bezierPath3 lineToPoint:NSMakePoint(dirtyRect.size.width, dirtyRect.size.height - RADIUSVALUE)];
    [self settingBezierStyle:bezierPath3];
    
    NSBezierPath *bezierPath4= [NSBezierPath bezierPath];
    [bezierPath4 moveToPoint:NSMakePoint(dirtyRect.size.width + 1, dirtyRect.size.height - RADIUSVALUE)];
    [bezierPath4 appendBezierPathWithArcWithCenter:NSMakePoint(dirtyRect.size.width - RADIUSVALUE, dirtyRect.size.height - RADIUSVALUE) radius:RADIUSVALUE startAngle:0 endAngle:90 clockwise:NO];
    [self settingArcBezierStyle:bezierPath4];
    
    NSBezierPath *bezierPath5= [NSBezierPath bezierPath];
    [bezierPath5 moveToPoint:NSMakePoint(dirtyRect.size.width - RADIUSVALUE, dirtyRect.size.height)];
    [bezierPath5 lineToPoint:NSMakePoint(RADIUSVALUE, dirtyRect.size.height)];
    [self settingBezierStyle:bezierPath5];
    
    NSBezierPath *bezierPath6= [NSBezierPath bezierPath];
    [bezierPath6 moveToPoint:NSMakePoint(RADIUSVALUE, dirtyRect.size.height)];
    [bezierPath6 appendBezierPathWithArcWithCenter:NSMakePoint(RADIUSVALUE, dirtyRect.size.height - RADIUSVALUE) radius:RADIUSVALUE startAngle:90 endAngle:180 clockwise:NO];
    [self settingArcBezierStyle:bezierPath6];
    
    NSBezierPath *bezierPath7 = [NSBezierPath bezierPath];
    
    [bezierPath7 moveToPoint:NSMakePoint(0, dirtyRect.size.height - RADIUSVALUE)];
    [bezierPath7 lineToPoint:NSMakePoint(0, RADIUSVALUE)];
    [self settingBezierStyle:bezierPath7];
    
    NSBezierPath *bezierPath8 = [NSBezierPath bezierPath];
    [bezierPath8 moveToPoint:NSMakePoint(0, RADIUSVALUE)];
    [bezierPath8 appendBezierPathWithArcWithCenter:NSMakePoint(RADIUSVALUE, RADIUSVALUE) radius:RADIUSVALUE startAngle:180 endAngle:270 clockwise:NO];
    [self settingArcBezierStyle:bezierPath8];
    
    NSAttributedString *string = [self settingTitle];
    NSRect rect = self.bounds;
    rect.origin.y += 2;
    rect.size.height -= 2;
    [string drawInRect:rect];

    // Drawing code here.
}

- (void)settingBezierStyle:(NSBezierPath *)bezierPath{
    [[NSColor colorWithDeviceRed:30.0/255 green:166.0/255 blue:255.0/255 alpha:1.0] set];
    [bezierPath setLineWidth:2.0];
    [bezierPath setLineJoinStyle:NSRoundLineJoinStyle];
    [bezierPath setLineCapStyle:NSRoundLineCapStyle];
    [bezierPath stroke];
}

- (void)settingArcBezierStyle:(NSBezierPath *)bezierPath{
    [[NSColor colorWithDeviceRed:50.0/255 green:186.0/255 blue:255.0/255 alpha:1.0] set];
    [bezierPath setLineWidth:1.1];
    [bezierPath setLineJoinStyle:NSRoundLineJoinStyle];
    [bezierPath setLineCapStyle:NSRoundLineCapStyle];
    [bezierPath stroke];
}

- (void)dealloc{
    if (_drawString != nil) {
        [_drawString release];
        _drawString = nil;
    }
    [super dealloc];
}
@end
