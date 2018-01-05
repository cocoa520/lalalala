//
//  IMBMenuPopupButton.h
//  AnyTrans
//
//  Created by LuoLei on 16-8-5.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBMenuPopupButton : NSPopUpButton
{
    NSString *_title;
    CGFloat _maxWidth;
    BOOL _hasBorder;
}
- (void)setMaxWidth:(CGFloat)maxWidth;
- (void)setHasBorder:(BOOL)hasBorder;
@end
