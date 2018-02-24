//
//  IMBFolderOrFileTitleField.m
//  IMBFolderOrFileButton
//
//  Created by iMobie on 14-7-3.
//  Copyright (c) 2014年 iMobie. All rights reserved.
//

#import "IMBFolderOrFileTitleField.h"
#import "StringHelper.h"
@implementation IMBFolderOrFileTitleField
@synthesize isselected = _isselected;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)setIsselected:(BOOL)isselected
{
    if (_isselected != isselected) {
        _isselected = isselected;
        [self setNeedsDisplay:YES];
    }

    
    
}
- (NSDictionary *)attributed:(NSColor *)textColor{
    
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
    [textParagraph setAlignment:NSCenterTextAlignment];
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,NSParagraphStyleAttributeName,[NSFont fontWithName:@"Helvetica Neue" size:12],NSFontAttributeName,textColor,NSForegroundColorAttributeName,nil];
    return fontDic;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSString *string = self.stringValue;
    if ([string isEqualToString:@""]||string == nil) {
        return;
    }
    NSMutableAttributedString *attiStr = [[NSMutableAttributedString alloc] initWithString:string == nil ? @"":string];
    NSSize size = [string sizeWithAttributes:[self attributed:[NSColor blackColor]]];
    NSRect rect;
   
    if (NSEqualSizes(self.frame.size, dirtyRect.size)) {
        rect = dirtyRect;
        rect.size.width = size.width + 18;
        if (rect.size.width > dirtyRect.size.width - 2) {
            rect.size.width = dirtyRect.size.width - 2;
        }
        rect.origin.y = (dirtyRect.size.height - rect.size.height)/2.0 ;
        rect.origin.x = (dirtyRect.size.width - rect.size.width)/2.0;
    }else
    {
        rect = self.bounds;
        rect.size.width = size.width + 18;
        if (rect.size.width > self.bounds.size.width - 2) {
            rect.size.width = self.bounds.size.width - 2;
        }
        rect.origin.y = (self.bounds.size.height - rect.size.height)/2.0 - 1;
        rect.origin.x = (self.bounds.size.width - rect.size.width)/2.0;

    }
    
   
    if (_isselected) {
        NSBezierPath *backgroundpath = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:8 yRadius:8];
        if (string != nil) {
            [attiStr addAttributes:[self attributed:[NSColor whiteColor]]  range:NSMakeRange(0, string.length)];
        }
      
        [[NSColor colorWithDeviceRed:50.0/255 green:177.0/255 blue:250/.0/255 alpha:1] setFill];
        [backgroundpath fill];
     }else
     {
         NSBezierPath *backgroundpath = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:8 yRadius:8];
         if (string != nil) {
             [attiStr addAttributes:[self attributed:[NSColor colorWithDeviceRed:51.0/255 green:51.0/255 blue:51/.0/255 alpha:1]]  range:NSMakeRange(0, string.length)];
        }
        [[NSColor clearColor] setFill];
        [backgroundpath fill];
    }
    NSRect drawrect = rect;
    drawrect.origin.y -= 2;
    drawrect.origin.x = drawrect.origin.x + 9;
    drawrect.size.width =  drawrect.size.width - 18;
    [attiStr drawInRect:drawrect];
    self.toolTip = string;
}


@end
