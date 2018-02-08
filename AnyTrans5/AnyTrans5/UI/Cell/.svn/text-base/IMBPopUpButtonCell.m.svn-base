//
//  IMBPopUpButtonCell.m
//  AnyTrans
//
//  Created by iMobie on 10/19/16.
//  Copyright (c) 2016 imobie. All rights reserved.
//

#import "IMBPopUpButtonCell.h"
#import "StringHelper.h"

@implementation IMBPopUpButtonCell

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView  {
    return [super drawTitle:[self attributedTitle] withFrame:frame inView:controlView];
}

- (NSAttributedString *)attributedTitle {
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:(self.title?self.title:@"") attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica Neue" size:12], NSFontAttributeName,[StringHelper getColorFromString:CustomColor(@"text_normalColor", nil)], NSForegroundColorAttributeName,textParagraph,NSParagraphStyleAttributeName,nil]];
    return title;
}

@end
