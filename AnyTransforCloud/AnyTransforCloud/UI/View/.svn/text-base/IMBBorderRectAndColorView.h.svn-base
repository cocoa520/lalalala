//
//  IMBBorderRectAndColorView.h
//  MacClean
//
//  Created by Gehry on 4/17/15.
//  Copyright (c) 2015 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IMBBorderRectAndColorView : NSView{
    NSColor *_background;
    double _borderLineSize;
    NSColor *_lineColor;
    
    NSGradient *gradient;
    NSShadow *outerShadow;
    BOOL _isOffSetY;
    float _offsetY;     //投影Y轴偏移量,传正数
    float _blurRadius;
    
    BOOL _luCorner;
    BOOL _lbCorner;
    BOOL _ruCorner;
    BOOL _rbCorner;
    float _cornerRadius;
    
    BOOL _isAlertView;
    BOOL _rightShadow;
    
}

@property (nonatomic, retain) NSColor *background;
@property (nonatomic, assign) double borderLineSize;
@property (nonatomic, retain) NSColor *lineColor;
@property (nonatomic, assign) BOOL isOffSetY;
@property (nonatomic, assign) float offsetY;
@property (nonatomic, assign) float blurRadius;
@property (nonatomic, assign) BOOL isAlertView;
@property (nonatomic, assign) BOOL rightShadow;

- (void)setLuCorner:(BOOL)luCorner LbCorner:(BOOL)lbConer RuCorner:(BOOL)ruConer RbConer:(BOOL)rbConer CornerRadius:(float)cornerRadius;

@end
