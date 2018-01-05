//
//  IMBCanClickText.h
//  PhoneRescue
//
//  Created by smz on 17/9/12.
//  Copyright (c) 2017年 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBMyDrawCommonly.h"

@interface IMBCanClickText : NSTextView {
    NSString *_normalString;
    NSString *_linkString;
    NSColor *_linkNormalColor;
    NSColor *_linkEnterColor;
    NSColor *_linkDownColor;
    NSColor *_normalColor;
    NSFont *_font;
    MouseStatusEnum _mouseType;
    NSColor *_linkColor;
}
- (void)setNormalString:(NSString *)normalString WithLinkString:(NSString *)linkString WithNormalColor:(NSColor *)normalColor WithLinkNormalColor:(NSColor *)linkNormalColor WithLinkEnterColor:(NSColor *)linkEnterColor WithLinkDownColor:(NSColor *)linkDownColor WithFont:(NSFont *)font;

@end
