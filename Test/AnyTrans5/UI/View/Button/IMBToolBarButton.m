//
//  IMBToolBarButton.m
//  iMobieTrans
//
//  Created by iMobie on 14-8-11.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBToolBarButton.h"
#define RADIUSVALUE 5

@implementation IMBToolBarButton
@synthesize isselected = isselected;
- (id)initWithFrame:(NSRect)frame needTitle:(BOOL)_needTitle
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        needTitle = _needTitle;
    }
    return self;
}

- (void)awakeFromNib {
    if (_isThroughNib) {
        return;
    }
    if (!needTitle) {
        [self setTitle:@""];
    }
    _isThroughNib = YES;
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSString *minVersion =  processInfo.operatingSystemVersionString;
    BOOL isNewSystem = FALSE;
    NSArray *operatingArray = [minVersion componentsSeparatedByString:@" "];
    NSString *version = nil;
    for (NSString *string in operatingArray) {
        BOOL res = [self isVersion:string];
        if (res) {
            version = string;
            break;
        }
    }
    if (version != nil) {
        if ([IMBToolBarButton compareVersion:@"10.9.99" newVersion:version] == NSOrderedAscending) {
            isNewSystem = YES;
        }
    }
    if (isNewSystem) {
//        [self setFrameSize:NSMakeSize(self.frame.size.width, self.frame.size.height - 4)];
//        [self setImagePosition:NSImageOnly];
//        [self setNeedsDisplay];
    }
    [self setImagePosition:NSImageOverlaps];

}

- (void)viewDidMoveToSuperview{
    if(!_isThroughNib){
        [self awakeFromNib];
    }
}

- (BOOL)isVersion:(NSString *)judgeString{
    NSArray *array = [judgeString componentsSeparatedByString:@"."];
    if (array.count == 0) {
        return FALSE;
    }
    for (NSString *string in array) {
        for (int i = 0; i < string.length; i++){
            int a = [string characterAtIndex:i];
            if (a < '0' || a > '9') {
                return FALSE;
            }
        }
    }
    return YES;
}


// Drawing code here.
//NSSize size = ImageSize;
//CGFloat height = size.height-2;
//CGFloat width = size.width-2;
//整个rect
//NSBezierPath *rectBezierPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:0 yRadius:0];
//dirtyRect.origin.x += 1;
//dirtyRect.origin.y += 1;
//dirtyRect.size.width = width;
//dirtyRect.size.height = height;
//画圆
//NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:width/2.0 yRadius:height/2.0];
//
//rectBezierPath = [rectBezierPath bezierPathByReversingPath];
//[bezierPath appendBezierPath:rectBezierPath];
//[bezierPath fill];
//NSBezierPath *bezierPath1 = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:width/2.0 yRadius:height/2.0];
//[[NSColor lightGrayColor] set];
//[bezierPath1 stroke];


- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    //整个rect
    NSBezierPath *allRect = [NSBezierPath bezierPathWithRect:dirtyRect];
    //方框的Rect
    if (!needTitle&&!isselected) {
        [[NSColor whiteColor] setFill];
    }else if (needTitle && isselected)
    {
       
        [[NSColor colorWithDeviceRed:0.0/255 green:160.0/255 blue:233.0/255 alpha:1.0] setFill];
    }else
    {
        [[NSColor whiteColor] setFill];
    }
    
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
//    if (attributedAppTitle != nil&&![attributedAppTitle.string isEqualToString:@""]) {
//        NSRect drawRect ;
//        NSMutableAttributedString *title = attributedAppTitle;
//        drawRect.size.width = title.size.width;
//        drawRect.size.height = title.size.height;
//        drawRect.origin.x= ceilf((dirtyRect.size.width - title.size.width)/2);
//        drawRect.origin.y= ceilf((dirtyRect.size.height - title.size.height)/2);
//        [self.attributedTitle drawInRect:drawRect];
//
//    }
}


- (void)settingBezierStyle:(NSBezierPath *)bezierPath{
    if (self.isEnabled) {
        [[NSColor colorWithDeviceRed:146.0/255 green:146.0/255 blue:146.0/255 alpha:1.0] setStroke];

    }
    else{
        [[NSColor colorWithDeviceRed:146.0/255 green:146.0/255 blue:146.0/255 alpha:0.3] setStroke];

    }
    [bezierPath setLineWidth:2.0];
    [bezierPath setLineJoinStyle:NSRoundLineJoinStyle];
    [bezierPath setLineCapStyle:NSRoundLineCapStyle];
    [bezierPath stroke];
}

- (void)settingArcBezierStyle:(NSBezierPath *)bezierPath{
    if (self.isEnabled) {
        [[NSColor colorWithDeviceRed:167.0/255 green:167.0/255 blue:167.0/255 alpha:1.0] setStroke];
    }
    else{
        [[NSColor colorWithDeviceRed:167.0/255 green:167.0/255 blue:167.0/255 alpha:0.3] setStroke];

    }
    [bezierPath setLineWidth:1.1];
    [bezierPath setLineJoinStyle:NSRoundLineJoinStyle];
    [bezierPath setLineCapStyle:NSRoundLineCapStyle];
    [bezierPath stroke];

}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (theEvent.clickCount > 1) {
        return;
    }
    [super mouseDown:theEvent];
    
}

+ (NSComparisonResult)compareVersion:(NSString *)oldVersion newVersion:(NSString *)newVersion{
    NSArray *oldArray = [oldVersion componentsSeparatedByString:@"."];
    NSArray *newArray = [newVersion componentsSeparatedByString:@"."];
    NSComparisonResult comparisonResult = NSOrderedDescending;
    for (int i = 0; i < oldArray.count ; i++){
        if (newArray.count > i) {
            int oldnumber = [[oldArray objectAtIndex:i] intValue];
            int newnumber = [[newArray objectAtIndex:i] intValue];
            
            if (oldnumber > newnumber) {
                return NSOrderedDescending;
            }
            else if(oldnumber == newnumber){
                comparisonResult = NSOrderedSame;
                continue;
            }
            else{
                return NSOrderedAscending;
            }
        }
        else{
            int oldnumber = [[oldArray objectAtIndex:i] intValue];
            if (oldnumber > 0) {
                comparisonResult = NSOrderedDescending;
                break;
            }
            else if(oldnumber == 0){
                comparisonResult = NSOrderedSame;
                continue;
            }
        }
    }
    
    if (comparisonResult == NSOrderedSame) {
        if (oldArray.count < newArray.count) {
            for (int i = oldArray.count; i < newArray.count; i++) {
                int newnumber = [[newArray objectAtIndex:i] intValue];
                
                if (newnumber > 0) {
                    comparisonResult = NSOrderedAscending;
                    break;
                }
                else if(newnumber == 0){
                    comparisonResult = NSOrderedSame;
                    continue;
                }
                else{
                    comparisonResult = NSOrderedDescending;
                    break;
                }
                
            }
        }
    }
    
    return comparisonResult;
}


- (void)dealloc
{
   
    [super dealloc];
}
@end
