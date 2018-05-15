//
//  IMBWhiteView.h
//  DataRecovery
//
//  Created by iMobie on 5/7/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBWhiteView : NSView {
    NSColor *_backgroundColor;
    NSColor *_borderColor;
    BOOL _isHaveLine;
    BOOL _isNOCanDraw;
    BOOL _isBommt;
    BOOL _isUpline;
    BOOL _isDrawFrame;
    BOOL _hasCorner;
    BOOL _isMove;
    float _cornerRadius;
}
@property (nonatomic, assign) BOOL isMove;
@property (nonatomic, assign) BOOL isRegistedTextView;
@property (nonatomic, assign) BOOL isBommt;
@property (nonatomic, readwrite) BOOL isHaveLine;
@property (nonatomic, assign) BOOL isNOCanDraw;
@property (nonatomic, assign) BOOL isUpline;
@property (nonatomic, assign) BOOL isDrawFrame;
@property (nonatomic, assign) BOOL hasCorner;
@property (nonatomic, retain) NSColor *backgroundColor;
/** 设置圆弧*/
@property (nonatomic, assign) float cornerRadius;

/**
 *  设置背景颜色
 *
 *  @param backgroundColor 背景颜色值
 */
- (void)setBackgroundColor:(NSColor *)backgroundColor;

/**
 *  设置边框颜色
 *
 *  @param borderColor 边框颜色值
 */
- (void)setBorderColor:(NSColor *)borderColor;
@end
