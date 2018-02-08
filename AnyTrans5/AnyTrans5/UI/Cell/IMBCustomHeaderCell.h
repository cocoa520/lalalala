//
//  CustomHeaderCell.h
//  CustomHeaderSample
//
//  Created by Hiroshi Hashiguchi on 11/01/25.
//  Copyright 2011 . All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IMBCustomHeaderCell : NSTableHeaderCell {

	BOOL _ascending;
	NSInteger _priority;
    NSGradient  *_backgroundgradient;
    BOOL _hasTitleBorderline;
    BOOL _hasLeftTitleBorderLine;
    BOOL _isShowTriangle;
    NSImage *_ascendingImage;//升序
    NSImage *_descendingImage;//降序
    BOOL _hasDiviation;
    float _diviationY;
}

@property (nonatomic,retain)NSGradient  *backgroundgradient;
@property (nonatomic,assign)BOOL hasTitleBorderline;
@property (nonatomic,assign)BOOL hasLeftTitleBorderLine;
@property (nonatomic,assign)BOOL ascending;
@property (nonatomic,assign)BOOL isShowTriangle;
@property (nonatomic, assign) BOOL hasDiviation;
@property (nonatomic, assign) float diviationY;
- (id)initWithCell:(NSTableHeaderCell*)cell;
- (void)setSortAscending:(BOOL)ascending priority:(NSInteger)priority;
- (void)setTextAlignment:(NSTextAlignment)textAlignment;
- (void)drawBackgroundInRect:(NSRect)rect hilighted:(BOOL)hilighted;
- (void)setBackgroundgradient:(NSGradient *)backgroundgradient;
@end
