//
//  IMBTextButtonView.h
//  MacClean
//
//  Created by LuoLei on 15-12-25.
//  Copyright (c) 2015年 imobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IMBCommonEnum.h"

@interface IMBTextButtonView : NSButton
{
    NSString *_buttonTitle;
    NSFont *_font;
    NSColor *_fontColor;
    NSColor *_fontEnterColor;
    NSColor *_fontDownColor;
    NSTrackingArea *_trackingArea;
    BOOL _isAlertView;
    BOOL _isPromptView;
    MouseStatusEnum _mouseType;
}
@property (nonatomic, assign) BOOL isPromptView;
@property (nonatomic, retain) NSString *buttonTitle;
@property (nonatomic, assign) BOOL isAlertView;
@property (nonatomic, readwrite, retain) NSFont *font;
@property (nonatomic, readwrite, retain) NSColor *fontColor;
@property (nonatomic, readwrite, retain) NSColor *fontEnterColor;
@property (nonatomic, readwrite, retain) NSColor *fontDownColor;
@end
