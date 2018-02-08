//
//  IMBCustomPopupButton.h
//  AnyTrans
//
//  Created by LuoLei on 16-12-19.
//  Copyright (c) 2016年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class IMBWhiteView;
@interface IMBCustomPopupButton : NSPopUpButton
{
    NSString *_title;
    IMBWhiteView *_arrBgView;
    NSImageView *_arrImageView;
}
- (void)resizeSize:(NSString *)aStringl;
@end
