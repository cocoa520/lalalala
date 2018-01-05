//
//  IMBTextField.h
//  iMobieTrans
//
//  Created by iMobie on 5/29/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "IMBPopupButton.h"

@interface IMBTextField : NSTextField<NSTextFieldDelegate>{
    BOOL _isEditing;
    NSRect initRect;
    BOOL isAddShapeLayer;
    CAShapeLayer *_shapeLayer;
    float _maxPreferenceWidth;
    BOOL _hasLastIntrinsicSize;
	NSSize _lastIntrinsicSize;
    float _initialHeight;
    float _initialWidth;
    BOOL isInitFromNib;
    NSString *_beforeStringValue;
    id _handleDelegate;
    float _fontSize;
    NSColor *_drawFontColor;
    BOOL _viewBeyondBasic;
    BOOL _isEmpty;
    id _bindingEntity;
    NSString *_bindingEntityKeyPath;
}

@property (nonatomic,setter = setMaxPreferenceWidth:) float maxPreferenceWidth;
@property (nonatomic,setter = setInitialWidth:) float initialWidth;
@property (nonatomic,setter = setInitialHeight:) float initialHeight;
@property (nonatomic,setter = setFontSize:) float fontSize;
@property (nonatomic,assign) id handleDelegate;
@property (nonatomic,retain,setter = setDrawFontColor:) NSColor *drawFontColor;
@property (nonatomic,assign) BOOL isEmpty;
@property (nonatomic,assign) BOOL viewBeyondBasic;
@property (nonatomic,retain) id bindingEntity;
@property (nonatomic,retain) NSString *bindingEntityKeyPath;

- (NSSize)intrinsicContentSize;
- (void)setInitialWidth:(float)initialWidth;
- (void)setInitialHeight:(float)initialHeight;
- (CGFloat)singleLineHeight;
- (void)setMaxPreferenceWidth:(float)maxPreferenceWidth;
- (void)setDrawFontColor:(NSColor *)drawFontColor;
- (NSRect)calcuTextBounds:(NSString *)text fontSize:(float)fontSize width:(CGFloat)width;
@end
