//
//  StringHelper.m
//  AnyTrans
//
//  Created by iMobie_Market on 16/7/18.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import "StringHelper.h"
@implementation StringHelper

+ (BOOL)stringIsNilOrEmpty:(NSString*)string {
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if (string == nil || [string isEqualToString:@""]  ) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSImage *)imageNamed:(NSString *)name {
    NSImage *image = [[NSBundle mainBundle] imageForResource:name];
    return image;
}

//末尾是省略号。。。
+ (NSMutableAttributedString*)TruncatingTailForStringDrawing:(NSString*)myString withFont:(NSFont*)font withLineSpacing:(float)lineSpacing withMaxWidth:(float)maxWidth withSize:(NSSize*)size withColor:(NSColor*)color withAlignment:(NSTextAlignment)alignment {
    NSMutableAttributedString *retStr = [[[NSMutableAttributedString alloc] initWithString:myString] autorelease];
    
    NSTextStorage *textStorage = [[[NSTextStorage alloc] initWithString:myString] autorelease];
    NSTextContainer *textContainer = [[[NSTextContainer alloc] initWithContainerSize:NSMakeSize(maxWidth, FLT_MAX)] autorelease];
    
    NSLayoutManager *layoutManager = [[[NSLayoutManager alloc] init] autorelease];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    NSMutableParagraphStyle *textParagraph = [[[NSMutableParagraphStyle alloc] init] autorelease];
    [textParagraph setLineSpacing:lineSpacing];
    [textParagraph setLineBreakMode:NSLineBreakByTruncatingTail];
    [textParagraph setAlignment:alignment];
    NSDictionary *fontDic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph, NSParagraphStyleAttributeName, font, NSFontAttributeName, color,NSForegroundColorAttributeName, [NSColor clearColor], NSBackgroundColorAttributeName, nil];
    
    [textStorage setAttributes:fontDic range:NSMakeRange(0, [textStorage length])];
    [textContainer setLineFragmentPadding:lineSpacing];
    [retStr addAttributes:fontDic range:NSMakeRange(0, textStorage.length)];
    (void) [layoutManager glyphRangeForTextContainer:textContainer];
    NSSize tmpSize = [layoutManager usedRectForTextContainer:textContainer].size;
    (*size).width = ceil(tmpSize.width);
    (*size).height = ceil(tmpSize.height);
    return retStr;
}

//计算文字的尺寸
+ (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize {
    NSRect textBounds = NSMakeRect(0, 0, 0, 0);
    if (text) {
        NSAttributedString *as = [[NSAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [paragraphStyle setAlignment:NSLeftTextAlignment];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSFont fontWithName:@"Helvetica Neue" size:fontSize], NSFontAttributeName,
                                    paragraphStyle, NSParagraphStyleAttributeName,
                                    nil];
        NSSize textSize = [text sizeWithAttributes:attributes];
        textBounds = NSMakeRect(0, 0, textSize.width, textSize.height);
        [as release];
    }
    return textBounds;
}
@end
