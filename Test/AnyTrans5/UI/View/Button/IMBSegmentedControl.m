//
//  IMBSegmentedControl.m
//  PrimoMusic
//
//  Created by iMobie_Market on 16/4/13.
//  Copyright (c) 2016年 IMB. All rights reserved.
//

#import "IMBSegmentedControl.h"
#import "StringHelper.h"
@implementation IMBSegmentedControl
@synthesize firstTitle = _firstTitle;
@synthesize secondTitle = _secondTitle;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
    
}

- (void)drawRect:(NSRect)dirtyRect
{
    /*
     NSInteger i =[self selectedSegment];
    if(i == 0) {说明前面是选中状态
        前面部分draw成选中的；
        后面部分draw成未选中的；
     
     }else {
         前面部分draw成未选中的；
         后面部分draw成选中的；
     }
     */

    
    NSRect leftSegRect = NSMakeRect(dirtyRect.origin.x, dirtyRect.origin.y, dirtyRect.size.width * 0.5, dirtyRect.size.height);
    NSRect rightSegRect = NSMakeRect(dirtyRect.origin.x + dirtyRect.size.width * 0.5, dirtyRect.origin.y, dirtyRect.size.width * 0.5, dirtyRect.size.height);
    int selectedSeg = [self selectedSegment];
    if (selectedSeg == 0) {
        //左边
        NSImage *image1 = [StringHelper imageNamed:@"cancal_left3"];
        NSSize size1 = image1.size;
        [image1 drawInRect:NSMakeRect(leftSegRect.origin.x, (leftSegRect.size.height-size1.height)/2.0, size1.width, size1.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
        NSImage *image2 = [StringHelper imageNamed:@"cancal_min3"];
        NSSize size2 = image2.size;
        int count = ceil((leftSegRect.size.width - size1.width)/ size2.width);
        NSRect rect = NSMakeRect(leftSegRect.origin.x+size1.width, (leftSegRect.size.height-size1.height)/2.0, size2.width, size2.height);
        for (int i = 0; i < count; i ++) {
            [image2 drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
            rect.origin.x += size2.width;
        }
        //右边
        NSImage *image3 = [StringHelper imageNamed:@"cancal_min1"];
        NSSize size3 = image3.size;
        NSImage *image4 = [StringHelper imageNamed:@"cancal_right1"];
        NSSize size4 = image4.size;
        int count2 = ceil((rightSegRect.size.width - size4.width)/ size3.width);
        NSRect rect2 = NSMakeRect(rightSegRect.origin.x, (rightSegRect.size.height-size3.height)/2.0, size3.width, size3.height);
        for (int i = 0; i < count2; i ++) {
            [image3 drawInRect:rect2 fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            rect2.origin.x += size3.width;
        }
        [image4 drawInRect:NSMakeRect(rightSegRect.origin.x +rightSegRect.size.width - size4.width, (rightSegRect.size.height-size4.height)/2.0, size4.width, size4.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        
        _firstTitle = CustomLocalizedString(@"Seg_First_Title", nil);
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSCenterTabStopType];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:14], NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)],NSForegroundColorAttributeName,nil];
        [_firstTitle drawInRect:leftSegRect withAttributes:dic];
        
        _secondTitle = CustomLocalizedString(@"Menu_Import", nil);
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:14], NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"generalBtn_other_exitColor", nil)],NSForegroundColorAttributeName,nil];
        [_secondTitle drawInRect:rightSegRect withAttributes:dic2];
        
    }else if (selectedSeg == 1) {
        NSImage *image1 = [StringHelper imageNamed:@"cancal_left1"];
        NSSize size1 = image1.size;
        [image1 drawInRect:NSMakeRect(leftSegRect.origin.x, (leftSegRect.size.height-size1.height)/2.0, size1.width, size1.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
        NSImage *image2 = [StringHelper imageNamed:@"cancal_min1"];
        NSSize size2 = image2.size;
        int count = ceil((leftSegRect.size.width - size1.width)/ size2.width);
        NSRect rect = NSMakeRect(leftSegRect.origin.x+size1.width, (leftSegRect.size.height-size1.height)/2.0, size2.width, size2.height);
        for (int i = 0; i < count; i ++) {
            [image2 drawInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
            rect.origin.x += size2.width;
        }
        //右边
        NSImage *image3 = [StringHelper imageNamed:@"cancal_min3"];
        NSSize size3 = image3.size;
        NSImage *image4 = [StringHelper imageNamed:@"cancal_right3"];
        NSSize size4 = image4.size;
        int count2 = ceil((rightSegRect.size.width - size4.width)/ size3.width);
        NSRect rect2 = NSMakeRect(rightSegRect.origin.x, (rightSegRect.size.height-size3.height)/2.0, size3.width, size3.height);
        for (int i = 0; i < count2; i ++) {
            [image3 drawInRect:rect2 fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
            rect2.origin.x += size3.width;
        }
        [image4 drawInRect:NSMakeRect(rightSegRect.origin.x +rightSegRect.size.width - size4.width, (rightSegRect.size.height-size4.height)/2.0, size4.width, size4.height) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1 respectFlipped:YES hints:nil];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSCenterTabStopType];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:14], NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"generalBtn_other_exitColor", nil)],NSForegroundColorAttributeName,nil];
        [_firstTitle drawInRect:leftSegRect withAttributes:dic];
        
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:style,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:14], NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"generalBtn_enterColor", nil)],NSForegroundColorAttributeName,nil];
        [_secondTitle drawInRect:rightSegRect withAttributes:dic2];
    }

}

- (void)mouseDown:(NSEvent *)theEvent {
   
    
//       NSInteger i =[self selectedSegment];

    /*
     1、通过坐标判断点击的是那一部分
        NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
        NSRect rect = self.frame;
        
        NSRect rect1 =
     
        NSRect rect2 = 
      
        NSMouseInRect(point, rect1, [self isFlipped])
     
     2、NSInteger i =[self selectedSegment];
     i = 0 选中的就是前面一部分； i= 1 选择的就是后面部分；i = -1就是没有选中；
     设置它的状态- (void)setSelectedSegment:(NSInteger)selectedSegment;
     
     4、响应事件；
     */
    
    NSRect leftSegRect = NSMakeRect(0, 0, self.bounds.size.width / 2, self.bounds.size.height);
    NSRect rightSegRect = NSMakeRect(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height);
    
    //获取鼠标位置
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    //当前控件的位置
    if (NSMouseInRect(point, leftSegRect, [self isFlipped])) {
        [self setSelectedSegment:0];
    }else if (NSMouseInRect(point, rightSegRect, [self isFlipped])) {
        [self setSelectedSegment:1];
    }
    if (self.isEnabled) {
        [self setNeedsDisplay:YES];
        if (theEvent.clickCount == 1) {
            [NSApp sendAction:self.action to:self.target from:self];
        }
    }
}

- (void)updateTrackingAreas{
    [super updateTrackingAreas];
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
    }
    NSTrackingAreaOptions options = NSTrackingInVisibleRect|NSTrackingMouseEnteredAndExited|NSTrackingActiveInKeyWindow;
    _trackingArea = [[NSTrackingArea alloc]initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}
@end
