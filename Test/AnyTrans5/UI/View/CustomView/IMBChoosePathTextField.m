//
//  IMBChoosePathTextField.m
//  PhoneRescue
//
//  Created by iMobie023 on 16-5-6.
//  Copyright (c) 2016年 iMobie Inc. All rights reserved.
//

#import "IMBChoosePathTextField.h"
#import "StringHelper.h"
@implementation IMBChoosePathTextField

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
    NSBezierPath *roundRect = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5];
    [roundRect addClip];
    [[NSColor clearColor] set];
    [roundRect fill];
    [[StringHelper getColorFromString:CustomColor(@"lineAlertColor_InputTextBoderColor", nil)] setStroke];
    [roundRect stroke];
    [super drawRect:dirtyRect];
    // Drawing code here.

 
//    NSAttributedString *attrString = self.attributedStringValue;
//    /* if your values can be attributed strings, make them white when selected */
//    NSMutableAttributedString *whiteString = attrString.mutableCopy;
//    [whiteString addAttribute: NSForegroundColorAttributeName
//                        value: COLOR_TEXT_EXPLAIN
//                        range: NSMakeRange(0, whiteString.length)];
//    
//    [whiteString addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Helvetica Neue" size:12] range:NSMakeRange(0, whiteString.length)];
//    
//    
//    attrString = whiteString;
//    
//    NSRect rect1 = NSMakeRect(dirtyRect.origin.x +4, dirtyRect.origin.y +3, dirtyRect.size.width, dirtyRect.size.height);
////    NSRect rect = [self titleRectForBounds:dirtyRect];
//    [attrString drawWithRect: rect1
//                     options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin];
    
    
    //    self.stringValue
}



//- (NSRect)titleRectForBounds:(NSRect)theRect {
//    /* get the standard text content rectangle */
//    NSRect titleFrame = [super titleRectForBounds:theRect];
//    
//    /* find out how big the rendered text will be */
//    NSAttributedString *attrString = self.attributedStringValue;
//    NSString *title = self.stringValue;
//    NSRect textRect = [attrString boundingRectWithSize: titleFrame.size
//                                               options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin ];
//    
//    /* If the height of the rendered text is less then the available height,
//     * we modify the titleRect to center the text vertically */
//    if (textRect.size.height < titleFrame.size.height) {
//        titleFrame.origin.x = titleFrame.origin.x +8;
//        
//        int count = 0;
//        for (int i = 0; i < [title length]; i++) {
//            int a = [title characterAtIndex:i];
//            if (a > 0x4e00 && a < 0X9fff) {
//                count ++;
//            }
//        }
//        if (count >0) {
//            titleFrame.origin.y = theRect.origin.y + (theRect.size.height - textRect.size.height) / 2.0 -2;
//            titleFrame.size.height = textRect.size.height +2;
//            titleFrame.size.width -= 10;
//        }else{
//            titleFrame.origin.y = theRect.origin.y + (theRect.size.height - textRect.size.height) / 2.0;
//            titleFrame.size.height = textRect.size.height ;
//            titleFrame.size.width -= 10;
//        }
//        
//        
//        
//    }
//    return titleFrame;
//}


@end
