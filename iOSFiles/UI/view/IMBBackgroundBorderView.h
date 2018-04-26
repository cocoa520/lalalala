//
//  IMBBackgroundBorderView.h
//  MacClean
//
//  Created by Gehry on 12/29/14.
//  Copyright (c) 2014 iMobie. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface IMBBackgroundBorderView : NSView{
    NSColor *_backgroundColor;
    NSColor *_topBorderColor;
    NSColor *_leftBorderColor;
    NSColor *_bottomBorderColor;
    NSColor *_rightBorderColor;
    NSColor *_borderColor;
    BOOL _hasTopBorder;
    BOOL _hasLeftBorder;
    BOOL _hasBottomBorder;
    BOOL _hasRightBorder;
    BOOL _hasRadius;
    NSImage *_backgroundImage;
    CGFloat _xRadius;
    CGFloat _yRadius;
}

@property(nonatomic,retain)NSColor *backgroundColor;
@property(nonatomic,retain)NSColor *topBorderColor;
@property(nonatomic,retain)NSColor *leftBorderColor;
@property(nonatomic,retain)NSColor *bottomBorderColor;
@property(nonatomic,retain)NSColor *rightBorderColor;
@property(nonatomic,retain)NSColor *borderColor;
@property(nonatomic,assign)BOOL hasTopBorder;
@property(nonatomic,assign)BOOL hasLeftBorder;
@property(nonatomic,assign)BOOL hasBottomBorder;
@property(nonatomic,assign)BOOL hasRightBorder;
@property(nonatomic,assign)BOOL hasRadius;
@property(nonatomic,retain)NSImage *backgroundImage;

- (void)setXRadius:(CGFloat)xRadius YRadius:(CGFloat)yRadius;

@end
