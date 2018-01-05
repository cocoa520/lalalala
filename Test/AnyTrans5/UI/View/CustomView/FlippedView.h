//
//  FlippedView.h
//  iMobieTrans
//
//  Created by apple on 6/21/14.
//  Copyright (c) 2014 iMobie Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FlippedView : NSView{
    BOOL _drawDivider;
    NSColor *_backGroundColor;
    NSColor *_borderColor;
    
    BOOL _isListView;
    BOOL _isDrawRightLine;
    BOOL _isDrawTopLine;
    BOOL _isDrawBroderLine;
    BOOL _isDrawImageBroder;
    BOOL _isDrawLeftLine;
    BOOL _allRightLine;
    
}
@property (nonatomic,readwrite,setter = setDrawDivider:) BOOL drawDivider;
@property (retain,readwrite,setter = setBackGroundColor:) NSColor *backgroundColor;
@property (nonatomic, readwrite) BOOL isListVeiw;
@property (nonatomic, readwrite, setter = setDrawRightLine:) BOOL isDrawRightLine;
@property (nonatomic, readwrite, setter = setDrawLeftLine:) BOOL isDrawLeftLine;
@property (nonatomic, readwrite, setter = setDrawTopLine:) BOOL isDrawTopLine;
@property (nonatomic, readwrite, setter = setDrawBroderLine:) BOOL isDrawBroderLine;
@property (nonatomic, readwrite, setter = setDrawImageBroder:) BOOL isDrawImageBroder;
@property (nonatomic, assign) BOOL allRightLine;
- (void)setDrawDivider:(BOOL)drawDivider;
- (void)setBackgroundColor:(NSColor *)backgroundColor;
- (void)setBorderColor:(NSColor *)borderColor;
- (void)setDrawRightLine:(BOOL)isDrawRightLine;
- (void)setDrawLeftLine:(BOOL)isDrawLeftLine;
- (void)setDrawTopLine:(BOOL)isDrawTopLine;
- (void)setDrawBroderLine:(BOOL)isDrawBroderLine;
- (void)setDrawImageBroder:(BOOL)isDrawImageBroder;

@end
