//
//  IMBMessageNameTextCell.m
//  iMobieTrans
//
//  Created by iMobie on 14-11-19.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBMessageNameTextCell.h"
#import "IMBCustomHeaderTableView.h"
@implementation IMBMessageNameTextCell
@synthesize titleFont = _titleFont;
@synthesize subTitleFont = _subTitleFont;
@synthesize subTitleColor = _subTitleColor;
@synthesize titleColor = _titleColor;
@synthesize ishigh = _ishigh;
-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSMutableAttributedString *attrString = nil;
    NSString *str = self.stringValue;
    NSArray *array = [str componentsSeparatedByString:@"\n"];
    NSRect rect;
    if ([array count]>=2) {
               //[textParagraph setLineBreakMode:NSLineBreakByCharWrapping];
       
        NSFont *sysFont1 = _titleFont;
        NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                     sysFont1, NSFontAttributeName,
                                     _titleColor, NSForegroundColorAttributeName,
                                     nil];
        NSFont *sysFont2 = _subTitleFont;
        NSDictionary *attributes2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                     sysFont2, NSFontAttributeName,
                                     _subTitleColor, NSForegroundColorAttributeName,
                                     nil];
       
        
         attrString = [[NSMutableAttributedString alloc] initWithString:str];
        [attrString addAttributes:attributes1 range:NSMakeRange(0, ((NSString *)[array objectAtIndex:0]).length)];
        [attrString addAttributes:attributes2 range:NSMakeRange(((NSString *)[array objectAtIndex:0]).length,str.length-((NSString *)[array objectAtIndex:0]).length)];
       
        
        
    }else
    {
        NSFont *sysFont1 = _titleFont;
        NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                     sysFont1, NSFontAttributeName,
                                   _titleColor, NSForegroundColorAttributeName,
                                     nil];
       
        attrString = [[NSMutableAttributedString alloc] initWithString:[array objectAtIndex:0] attributes:attributes1];
        
    }

    /* if your values can be attributed strings, make them white when selected */
    if (self.ishigh) {
        NSMutableAttributedString *whiteString = attrString.mutableCopy;
        [whiteString addAttribute: NSForegroundColorAttributeName
                            value: [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:1.0 alpha:0.7]
                            range: NSMakeRange(0, whiteString.length) ];
        attrString = whiteString;
        
        
        
        
        if (!(controlView == [[controlView window] firstResponder])) {
            NSMutableAttributedString *whiteString = attrString.mutableCopy;
            [whiteString addAttribute: NSForegroundColorAttributeName
                                value: [NSColor blackColor]
                                range: NSMakeRange(0, whiteString.length) ];
            attrString = whiteString;

        }

    }
      _ishigh = NO;
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:4.0f];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
   
    
    NSDictionary *attributes3 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 textParagraph,NSParagraphStyleAttributeName,
                                 nil];
    [attrString addAttributes:attributes3 range:NSMakeRange(0, attrString.length)];
    rect = [self titleRectForBounds:cellFrame];
    
    rect.size.height += 14;
    rect.origin.y -= 5;

//    NSStringDrawingUsesLineFragmentOrigin = (1 << 0), // The specified origin is the line fragment origin, not the base line origin
//    NSStringDrawingUsesFontLeading = (1 << 1), // Uses the font leading for calculating line heights
//    NSStringDrawingDisableScreenFontSubstitution = (1 << 2), // Disable screen font substitution (-[NSLayoutManager setUsesScreenFonts:NO])
//    NSStringDrawingUsesDeviceMetrics = (1 << 3), // Uses image glyph bounds instead of typographic bounds
//    NSStringDrawingOneShot = (1 << 4) // Suppres
    //[attrString.string drawInRect:rect withAttributes:attributes3];
    [attrString drawWithRect: rect
                     options: NSStringDrawingUsesLineFragmentOrigin];
    [attrString release];
}

- (NSRect)titleRectForBounds:(NSRect)theRect {
    /* get the standard text content rectangle */
    NSRect titleFrame = [super titleRectForBounds:theRect];
    
    /* find out how big the rendered text will be */
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"st\nht"];
    NSRect textRect = [attrString boundingRectWithSize: titleFrame.size
                                               options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin ];
    
    /* If the height of the rendered text is less then the available height,
     * we modify the titleRect to center the text vertically */
    if (textRect.size.height < titleFrame.size.height) {
        titleFrame.origin.x = titleFrame.origin.x + 8;
        titleFrame.origin.y = theRect.origin.y + (theRect.size.height - textRect.size.height) / 2.0 -5;
        titleFrame.size.height = textRect.size.height;
        titleFrame.size.width -= 10;
    }
    return titleFrame;
}



@end
