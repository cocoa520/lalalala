//
//  IMBPromptView.h
//  AnyTransforCloud
//
//  Created by 帅明忠 on 18/5/3.
//  Copyright © 2018年 IMB. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBPromptView : NSView {
    NSColor *_fillColor;
    NSColor *_borderColor;
    NSImage *_image;
    NSString *_textString;
    CALayer *_loadImageLayer;
    BOOL _isLoading;
    promptTypeEnum _promptEnum;
}
- (void)setFillColor:(NSColor *)fillColor withBorderColor:(NSColor *)borderColor;
- (void)setImage:(NSImage *)image WithTextString:(NSString *)textString withIsLoading:(BOOL)isLoading withIsState:(promptTypeEnum)promptEnum;
@end
