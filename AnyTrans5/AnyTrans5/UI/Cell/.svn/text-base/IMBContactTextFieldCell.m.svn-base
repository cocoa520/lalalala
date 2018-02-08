//
//  IMBContactTextFieldCell.m
//  PhoneRescue_Android
//
//  Created by m on 17/5/3.
//  Copyright (c) 2017年 imobie. All rights reserved.
//

#import "IMBContactTextFieldCell.h"
#import "StringHelper.h"
@implementation IMBContactTextFieldCell

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSMutableAttributedString *attrString = nil;
    NSString *str = self.stringValue;
    NSFont *sysFont = [NSFont fontWithName:@"Helvetica Neue" size:12];
    if (_isDeleted){
        if (_isExistAndDeleted) {
            if (self.isHighlighted && self.backgroundStyle == NSBackgroundStyleDark) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)], NSForegroundColorAttributeName, [NSNumber numberWithInt:1], NSStrikethroughStyleAttributeName,sysFont,
                                     NSFontAttributeName,nil];
                attrString = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
            } else {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName, [NSNumber numberWithInt:1], NSStrikethroughStyleAttributeName,sysFont,
                                     NSFontAttributeName,nil];
                attrString = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
            }
            
        } else {
            if(self.isHighlighted && self.backgroundStyle == NSBackgroundStyleDark && self.backgroundStyle == NSBackgroundStyleDark) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName,sysFont,
                                     NSFontAttributeName,nil];
                attrString = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
            } else {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSColor redColor], NSForegroundColorAttributeName,sysFont,
                                     NSFontAttributeName,nil];
                attrString = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
            }
        }
    }else{
        if (self.isHighlighted && self.backgroundStyle == NSBackgroundStyleDark) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[StringHelper getColorFromString:CustomColor(@"text_numberColor", nil)], NSForegroundColorAttributeName,sysFont,
                                 NSFontAttributeName,nil];
            attrString = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
        } else {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,sysFont,
                                 NSFontAttributeName,nil];
            attrString = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
        }

    }
    NSRect rect = [self titleRectForBounds:cellFrame];
    NSRect newRect = NSMakeRect(rect.origin.x - 4, rect.origin.y - 2, rect.size.width, rect.size.height + 4);
    [attrString drawWithRect: newRect
                     options: NSStringDrawingUsesLineFragmentOrigin];
    [attrString release];
}
@end
