
//
//  IMBMessageNameTextCell.m
//  iMobieTrans
//
//  Created by iMobie on 14-11-19.
//  Copyright (c) 2014年 iMobie Inc. All rights reserved.
//

#import "IMBMessageNameTextCell.h"
#import "StringHelper.h"
#import "IMBSoftWareInfo.h"
@implementation IMBMessageNameTextCell
@synthesize isMessage = _isMessage;
@synthesize isAlwaysHighLight = _isAlwaysHighLight;
-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSMutableAttributedString *attrString = nil;
    NSString *allStr = self.stringValue;
    NSArray *array = [allStr componentsSeparatedByString:@"\n"];
    NSString *str = nil;
    NSString *allName = nil;//用于避免短信名字太长和时间相重叠
    NSString *shortName = nil;
    if (_isMessage) {
        if (array.count >= 3) {
            allName = [array objectAtIndex:0];
            if (allName.length > 30) {
                shortName = [[allName substringToIndex:30] stringByAppendingString:@"..."];
            }else {
                shortName = allName;
            }
            str = [shortName stringByAppendingFormat:@"\n%@",[array objectAtIndex:2]];
        }else if(array.count >= 2) {
            str = allStr;
            shortName = allStr;
            
        }
    }else {
        if (array.count > 1) {
            shortName = [array objectAtIndex:0];
        }
        str = allStr;
    }
    

    NSRect rect;
    if ([array count]>=3) {
               //[textParagraph setLineBreakMode:NSLineBreakByCharWrapping];
       
        NSFont *sysFont1 = [NSFont fontWithName:@"Helvetica Neue" size:13];
        NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                     sysFont1, NSFontAttributeName,
                                     [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                     nil];

        
        NSFont *sysFont3 = [NSFont fontWithName:@"Helvetica Neue" size:13];
        NSDictionary *attributes3 = [NSDictionary dictionaryWithObjectsAndKeys:
                                     sysFont3, NSFontAttributeName,
                                     [StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)], NSForegroundColorAttributeName,
                                     nil];
       
        
         attrString = [[NSMutableAttributedString alloc] initWithString:str];
        [attrString addAttributes:attributes1 range:NSMakeRange(0, shortName.length)];
        [attrString addAttributes:attributes3 range:NSMakeRange(shortName.length,str.length-shortName.length)];
    }else
    {
        NSFont *sysFont1 = [NSFont fontWithName:@"Helvetica Neue" size:13];
        NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                     sysFont1, NSFontAttributeName,
                                   [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                     nil];
        
        if(_isMessage){
            attrString = [[NSMutableAttributedString alloc] initWithString:[shortName stringByAppendingString:[array objectAtIndex:1]] attributes:attributes1];
        }else {
            NSFont *sysFont1 = [NSFont fontWithName:@"Helvetica Neue" size:13];
            NSDictionary *attributes1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                         sysFont1, NSFontAttributeName,
                                         [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,
                                         nil];
            
            
            NSFont *sysFont3 = [NSFont fontWithName:@"Helvetica Neue" size:13];
            NSDictionary *attributes3 = [NSDictionary dictionaryWithObjectsAndKeys:
                                         sysFont3, NSFontAttributeName,
                                         [StringHelper getColorFromString:CustomColor(@"text_explainColor", nil)], NSForegroundColorAttributeName,
                                         nil];
            
            
            attrString = [[NSMutableAttributedString alloc] initWithString:str];
            [attrString addAttributes:attributes1 range:NSMakeRange(0, shortName.length)];
            [attrString addAttributes:attributes3 range:NSMakeRange(shortName.length,str.length-shortName.length)];
      
//            attrString = [[NSMutableAttributedString alloc] initWithString:str attributes:attributes1];
        }
    }

    /* if your values can be attributed strings, make them white when selected */

    if ((self.isHighlighted && self.backgroundStyle == NSBackgroundStyleDark) || _isAlwaysHighLight) {
        NSMutableAttributedString *whiteString = attrString.mutableCopy;
        [whiteString addAttribute: NSForegroundColorAttributeName
                            value: [StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)]
                            range: NSMakeRange(0, whiteString.length) ];
        attrString = whiteString;
    }
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:2.0f];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
    NSDictionary *attributes3 = [NSDictionary dictionaryWithObjectsAndKeys:
                                 textParagraph,NSParagraphStyleAttributeName,
                                 nil];
    [attrString addAttributes:attributes3 range:NSMakeRange(0, attrString.length)];

    rect = [self titleRectForBounds:cellFrame];
    
    rect.size.height += 8;
    rect.origin.y -= 5;

    //[attrString.string drawInRect:rect withAttributes:attributes3];
    [attrString drawWithRect: rect
                     options: NSStringDrawingUsesLineFragmentOrigin];
    [attrString release];
    
    //draw time

    if (_isMessage) {
        NSString *timeStr = [array objectAtIndex:1];
        NSMutableAttributedString *timeAs = [[NSMutableAttributedString alloc] initWithString:timeStr];
        
        NSFont *timeFont = [NSFont fontWithName:@"Helvetica Neue" size:13];
        NSMutableParagraphStyle *timeStyle = [[NSMutableParagraphStyle alloc] init];
        [timeStyle setAlignment:NSRightTextAlignment];
        NSDictionary *timeDic = nil;
        if ((self.isHighlighted && self.backgroundStyle == NSBackgroundStyleDark) || _isAlwaysHighLight) {
            timeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     timeFont, NSFontAttributeName,
                                     [StringHelper getColorFromString:CustomColor(@"tableView_highLightBtn_borderColor", nil)], NSForegroundColorAttributeName,timeStyle,NSParagraphStyleAttributeName
                                     ,nil];
        }else{
            timeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                       timeFont, NSFontAttributeName,
                       [StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,timeStyle,NSParagraphStyleAttributeName
                       ,nil];
        }

        [timeAs addAttributes:timeDic range:NSMakeRange(0,timeAs.length)];
        if ([[[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode] lowercaseString ]isEqualToString:@"ar"] && [IMBSoftWareInfo singleton].chooseLanguageType == ArabLanguage) {
            rect.size.width = 80;
        }else {
            rect.size.width -=8;
        }
        
        [timeAs drawWithRect: rect
                     options: NSStringDrawingUsesLineFragmentOrigin];
    }
}

- (NSRect)titleRectForBounds:(NSRect)theRect {
    /* get the standard text content rectangle */
    NSRect titleFrame = [super titleRectForBounds:theRect];
    
    /* find out how big the rendered text will be */
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"test\nheight"];
    NSRect textRect = [attrString boundingRectWithSize: titleFrame.size
                                               options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin ];
    
    /* If the height of the rendered text is less then the available height,
     * we modify the titleRect to center the text vertically */
    if (textRect.size.height < titleFrame.size.height) {
        titleFrame.origin.x = titleFrame.origin.x + 8;
        titleFrame.origin.y = theRect.origin.y + (theRect.size.height - textRect.size.height) / 2.0;
        titleFrame.size.height = textRect.size.height+10;
        titleFrame.size.width -= 10;
    }
    return titleFrame;
}

@end
